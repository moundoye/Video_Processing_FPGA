/*
 * CameraOneFrame architecture
 * 
 * Copyright (c) 2014, 
 *  Luca Maggiani <maggiani.luca@gmail.com> 
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 * 
 * * Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above
 *   copyright notice, this list of conditions and the following disclaimer
 *   in the documentation and/or other materials provided with the
 *   distribution.
 * * Neither the name of the  nor the names of its
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 */
 
 /*! 
 *  \file      VideoSampler.v
 *  \brief     VideoSampler creates a stream from a CMOS video interface
 *  \author    Luca Maggiani
 *
 * \version v1.4.0 (31May12) - first release, it works with YUV422
 * \version v1.4.1 (23Nov12) - pclk_masked_color and pclk_masked_intensity signals used for intensity-color separation (Y to UV)                             
 * \version v1.4.2 (25Nov12) - new sampling machine
 * \version v1.4.3 (25Nov12)
 * \version v2.0 (30Nov12)   - total review, reduced complexity
 * \version v2.3 (9Dic12)     - as previous release
 * \version v3.0 (19Apr13)   - major release, now has an Avalon-MM interface and it merges also the DCFIFO module
 * \version v3.0 (6Mar14)    - FIFO show ahead OFF (decrease critical path lenght)
 * \version v3.1 (26May14)   - added onoff_neg_pclk as reset source of stato_video_pclk 
 *                             (resolve a bug whether fsm is turned off during VSYNC high)
 *                             removed write_s signal and write latency of 1 cycle as well
 * \version v3.2 (late15)    - Added hardware configuration through defines
 * \version v3.9 (10Dec18)   - Added Avalon-ST interface
 * \version v4.0 (24Dec18)   - New flow control logic
 * 
 *  \date      May 2012
 *
 */
 
module videosampler
(
    //inputs from camera
    input wire pclk_i,
    input wire href_i,
    input wire vsync_i,

    input wire [7:0] pixel_i,

    //input from CLOCK50 domain
    input wire clk_i,
    input wire reset_n_i,

    //Stream interface
    output wire [7:0] out_data,
    output wire out_dv,
    output wire out_sop,
    output wire out_eop,

    // Avalon-MM Slave interface
    input wire [2:0] addr_rel_i, 
    input wire wr_i,
    input wire [31:0] datawr_i,
    input wire rd_i,
    output wire [31:0] datard_o
);

parameter DATA_WIDTH = 32;
parameter PIXEL_WIDTH = 8;
parameter FIFO_DEPTH = 2048;
parameter DEFAULT_SCR = 0;
parameter DEFAULT_FLOWLENGTH = 320*240;

parameter HREF_POLARITY = "high";
parameter VSYNC_POLARITY = "high";
//    _______    _______
// __|       |__|       |__        high
// __         __         __
//   |_______|  |_______|        low

reg rdreq_d;

/* ######### Avalon-MM Interface ##############

    SCR             -   R/W
    HREF_COUNT      -   R
    PCLKONHREF      -   R
    VSYNC_PERIOD    -   R
    BUFFER_OVF      -   R
    FRAMELENGHT     -   R/W
*/

/* Status and Control Register */
reg [DATA_WIDTH-1:0] scr, scr_new;

/* Debug Registers */
reg [DATA_WIDTH-1:0] href_count, href_count_new;
reg [DATA_WIDTH-1:0] pclkonhref_count, pclkonhref_count_new;
reg [DATA_WIDTH-1:0] vsync_period;
reg [DATA_WIDTH-1:0] buffer_ovf_cnt, buffer_ovf_cnt_new;
reg [DATA_WIDTH-1:0] flowlength, flowlength_new;

/* Internal registers */
reg [DATA_WIDTH-1:0] readdata, readdata_new;

assign datard_o = readdata;

/* Frame valid output generation */
reg [DATA_WIDTH-1:0] dvcount;

/* DCFIFO wrreq */
reg wrreq;

/* wire definitions */
wire rdreq;
wire rdempty;
wire rdfull;
wire aclr_dcfifo;

/***************    VSYNC rising and falling signals    *****************/
reg v_int_pclk;
always @ (posedge pclk_i)
    v_int_pclk <= vsync_i;

wire vsync_neg_pclk;
assign vsync_neg_pclk = v_int_pclk & ~vsync_i;

wire vsync_pos_pclk;
assign vsync_pos_pclk = ~v_int_pclk & vsync_i;

reg v_int_clk;
always @ (posedge clk_i)
    v_int_clk <= vsync_i;

wire vsync_neg_clk;
assign vsync_neg_clk = v_int_clk & ~vsync_i;

wire vsync_pos_clk;
assign vsync_pos_clk = ~v_int_clk & vsync_i;

/***************    HREF pulse generator    *****************/
reg h_int_pclk;
always @ (posedge pclk_i)
    h_int_pclk <= href_i;

wire href_pos_pclk;
assign href_pos_pclk = href_i & ~h_int_pclk;

wire href_neg_pclk;
assign href_neg_pclk = ~href_i & h_int_pclk;

reg h_int_clk;
always @ (posedge clk_i)
    h_int_clk <= href_i;

wire href_neg_clk;
assign href_neg_clk = ~href_i & h_int_clk;

/***************    SCR onoff pulse generator    *****************/

reg scr_int_pclk;
always @ (posedge pclk_i)
    scr_int_pclk <= scr[0];

wire scr_pos_pclk;
assign scr_pos_pclk = scr[0] & ~scr_int_pclk;


reg scr_int_clk;
always @ (posedge clk_i)
    scr_int_clk <= scr[0];

wire scr_pos_clk;
assign scr_pos_clk = scr[0] & ~scr_int_clk;

/************************    FSM    **************************/
reg [2:0] video_st, video_st_new;

localparam START_PCLK       = 2'b00;
localparam WAIT_FIRST_PCLK  = 2'b01;
localparam FLOW_PCLK        = 2'b10;
localparam WAIT_TRIGGER     = 2'b11;

always@(posedge pclk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        video_st        <= START_PCLK;
    else
        video_st        <= video_st_new;

always@(*)
    if (scr_int_pclk)
        case(video_st)
            START_PCLK:
                /* Need to sync with a starting frame 
                 * (in case scr_int_pclk goes to 1 in the middle of a frame)
                 */
                if (vsync_pos_pclk)
                    video_st_new = WAIT_FIRST_PCLK;
                else
                    video_st_new = START_PCLK;
                
            WAIT_FIRST_PCLK:
                if(href_i == 1'b1)
                    video_st_new = FLOW_PCLK;
                else if (vsync_i == 1'b0)
                    video_st_new = WAIT_TRIGGER;
                else
                    video_st_new = WAIT_FIRST_PCLK;

            FLOW_PCLK:
                if(href_i == 1'b0)
                    video_st_new = WAIT_FIRST_PCLK;
                else
                    video_st_new = FLOW_PCLK;
                    
            WAIT_TRIGGER:
                if(scr_int_pclk == 1'b1)
                    video_st_new = WAIT_TRIGGER;
                else
                    video_st_new = START_PCLK;

            default:
                video_st_new    = START_PCLK;
        endcase
    else
        video_st_new = START_PCLK;


/*********    WRREQ generation ***********/
always@(*)
    case(video_st)
    START_PCLK:         wrreq = 1'b0;
    FLOW_PCLK:          wrreq = 1'b1;
    default:
        wrreq = 1'b0;
    endcase

assign aclr_dcfifo = ~scr_int_pclk;
    
reg [7:0] pixel_r;
always@(posedge pclk_i or negedge reset_n_i)
    if (reset_n_i == 0)
        pixel_r <= 8'd0;
    else if (href_i)
        pixel_r <= pixel_i;
    else
        pixel_r <= pixel_r;

/***********************    HREF counter    ****************/
reg [31:0] href_count_pclk;

always@(posedge pclk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        href_count_pclk <= {DATA_WIDTH{1'b0}};
    else
        if (video_st == START_PCLK)
            href_count_pclk <= {DATA_WIDTH{1'b0}};
        else if (href_pos_pclk)
            href_count_pclk <= href_count_pclk + 1'b1;
        else 
            href_count_pclk <= href_count_pclk;


/***********************    PCLK during HREF counter    ****************/
reg [31:0] pclkonhref_count_pclk, pclkonhref_count_pclk_new;

always@(posedge pclk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        pclkonhref_count_pclk <= {DATA_WIDTH{1'b0}};
    else if (video_st == START_PCLK)
        pclkonhref_count_pclk <= {DATA_WIDTH{1'b0}};
    else if (href_i)
        pclkonhref_count_pclk <= pclkonhref_count_pclk + 1'b1;

/***********************    DCFIFO    ****************/
dcfifo    #(
    .lpm_numwords(FIFO_DEPTH),
    .lpm_showahead("OFF"),
    .lpm_type("dcfifo"),
    .lpm_width(PIXEL_WIDTH),
    .lpm_widthu($clog2(FIFO_DEPTH)),
    .overflow_checking("ON"),
    .rdsync_delaypipe(4),
    .read_aclr_synch("ON"),
    .underflow_checking("ON"),
    .use_eab("ON"),
    .write_aclr_synch("OFF"),
    .wrsync_delaypipe(4)
) dcfifo_inst(
    .data (pixel_r),
    .rdclk ( clk_i ),
    .rdreq ( rdreq ),
    .wrclk ( pclk_i ),
    .wrreq ( wrreq ),
    .q ( out_data ),
    .rdempty ( rdempty ),
    .rdfull ( rdfull ),
    .wrfull( ),
    .wrempty(),
    .rdusedw(),
    .wrusedw(),
    .aclr(aclr_dcfifo),
    .eccstatus()
    );
   
localparam START        = 2'b00;
localparam WAIT_FIRST   = 2'b01;
localparam FLOW         = 2'b10;
localparam WAIT_LAST    = 2'b11;   
    
reg [1:0] stream_st, stream_st_new;

always@(posedge clk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        stream_st        <= START;
    else
        stream_st        <= stream_st_new;

always@(*)
    if(scr_int_clk)
        case(stream_st)
            START:
                stream_st_new = WAIT_FIRST;
            WAIT_FIRST:
                if (rdreq_d)
                    stream_st_new = FLOW;
                else
                    stream_st_new = WAIT_FIRST;
            FLOW:
                if (dvcount == 32'b0)
                    stream_st_new = WAIT_LAST;
                else
                    stream_st_new = FLOW;
            WAIT_LAST:
                stream_st_new = WAIT_FIRST;

            default:
                stream_st_new    = START;
        endcase
    else
        stream_st_new    = START;

assign rdreq = ~rdempty & scr_int_clk;

always@(posedge clk_i or negedge reset_n_i)
    if (reset_n_i == 0)
        rdreq_d <= 1'b0;
    else
        rdreq_d <= rdreq;

assign out_dv = rdreq_d;

/* dvcount */
always@(posedge clk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        dvcount <= 0;
    else
        if (rdreq_d && ((stream_st == FLOW) || (stream_st == WAIT_FIRST)))
            dvcount <= dvcount - 1'b1;
        else if (stream_st == WAIT_FIRST)
            dvcount <= flowlength;   

/* fv_ signal generation */
assign out_sop = (stream_st == WAIT_FIRST) && rdreq_d;
assign out_eop = (dvcount == 32'b1) && rdreq_d;

/*    Measuring if buffer_overflow occours */
always @ (*)
    if (rdfull)
        buffer_ovf_cnt_new = buffer_ovf_cnt + 1;
    else
        buffer_ovf_cnt_new = buffer_ovf_cnt;
    
/* Write phase - only available for SCR    */
always @ (*)
    if (wr_i)
        case(addr_rel_i)
        3'd0:
        begin
            scr_new = datawr_i;
            flowlength_new = flowlength;
        end
        3'd5:    
        begin 
            scr_new = scr;
            flowlength_new = datawr_i;
        end
        default:
        begin
            scr_new = scr;
            flowlength_new = flowlength;
        end
        endcase
    else
    begin
        scr_new = scr;
        flowlength_new = flowlength;
    end
    
/* Read phase */    
always @ (*)
if (rd_i)
    case(addr_rel_i)
        3'd0:   readdata_new = scr;
        3'd1:   readdata_new = href_count;
        3'd2:   readdata_new = pclkonhref_count;
        3'd3:   readdata_new = vsync_period;
        3'd4:   readdata_new = buffer_ovf_cnt;
        3'd5:   readdata_new = flowlength;
        default:    readdata_new = 32'd0;
    endcase
else 
    readdata_new = readdata;

/*	Measure of VSYNC period (in CLOCK50 cycles) */
reg [DATA_WIDTH-1:0] vsync_period_int;
always@(posedge clk_i or negedge reset_n_i)
begin
    if (reset_n_i == 1'b0)
        vsync_period_int <= {DATA_WIDTH{1'b0}};
    else if (vsync_pos_clk)
        vsync_period_int <= {DATA_WIDTH{1'b0}};
    else if (vsync_i & scr[0])
        vsync_period_int <= vsync_period_int + 1'b1;
end

always @ (posedge clk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        href_count           <= {DATA_WIDTH{1'b0}};
    else if (vsync_neg_clk)
        href_count          <= href_count_pclk;
        
always @ (posedge clk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        pclkonhref_count    <= {DATA_WIDTH{1'b0}};
    else if (href_neg_clk)
        pclkonhref_count          <= pclkonhref_count_pclk;
        
always @ (posedge clk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        vsync_period    <= {DATA_WIDTH{1'b0}};
    else if (vsync_neg_clk)
        vsync_period          <= vsync_period_int;
        
always @ (posedge clk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        buffer_ovf_cnt    <= {DATA_WIDTH{1'b0}};
    else if (vsync_neg_clk)
        buffer_ovf_cnt          <= buffer_ovf_cnt_new;

/* Internal register update */

always @ (posedge clk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
    begin
        scr                 <= DEFAULT_SCR;
        flowlength          <= DEFAULT_FLOWLENGTH;
        readdata            <= {DATA_WIDTH{1'b0}};
    end
    else
    begin
        scr                 <= scr_new;
        flowlength          <= flowlength_new;
        readdata            <= readdata_new;
    end

endmodule
