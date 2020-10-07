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
 * \version v4.0 (10Dec18)   - Added Avalon-ST interface
 *
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
parameter DEFAULT_FLOWLENGTH = 512*512;

parameter HREF_POLARITY = "high";
parameter VSYNC_POLARITY = "high";
//    _______    _______
// __|       |__|       |__        high
// __         __         __
//   |_______|  |_______|        low

localparam WAIT_ONOFF_POS   = 2'b00;
localparam WAIT_FRAME_START = 2'b01;
localparam WAIT_FRAME_END   = 2'b10;

localparam FVSTATE_INIT = 2'd0;
localparam FVSTATE_HBLK = 2'd1;
localparam FVSTATE_FLOW = 2'd2;
localparam FVSTATE_END  = 2'd3;

reg state;

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
reg [1:0] fvstate, fvstate_new;
reg [DATA_WIDTH-1:0] dvcount;
reg fv_d;

/* DCFIFO wrreq */
reg wrreq;

/* wire definitions */
wire scr_onoff_bit;

wire rdreq;
wire rdempty;
wire rdfull;
wire aclr_dcfifo;

/***************    VSYNC rising and falling signals    *****************/
reg [1:0] v_int_pclk;
always @ (posedge pclk_i)
    v_int_pclk <= {v_int_pclk[0], vsync_i};

wire vsync_neg_pclk;
assign vsync_neg_pclk = v_int_pclk[1] & ~v_int_pclk[0];

wire vsync_pos_pclk;
assign vsync_pos_pclk = ~v_int_pclk[1] & v_int_pclk[0];

reg [1:0] v_int_clk;
always @ (posedge clk_i)
    v_int_clk <= {v_int_clk[0], vsync_i};

wire vsync_neg_clk;
assign vsync_neg_clk = v_int_clk[1] & ~v_int_clk[0];

wire vsync_pos_clk;
assign vsync_pos_clk = ~v_int_clk[1] & v_int_clk[0];

/***************    ONOFF rise pulse generator    *****************/
reg [1:0] o_int_pclk;
always @ (posedge pclk_i)
    o_int_pclk <= {o_int_pclk[0], scr[0]};

wire onoff_pclk;
assign onoff_pclk = o_int_pclk[0];

/***************    HREF pulse generator    *****************/
reg h_int_pclk;
always @ (posedge pclk_i)
    h_int_pclk <= href_i;

wire href_pos_pclk;
assign href_pos_pclk = href_i & ~h_int_pclk;

wire href_neg_pclk;
assign href_neg_pclk = ~href_i & h_int_pclk;


/************************    FSM    **************************/
reg [1:0] stato_video_pclk, stato_video_pclk_new;
reg [1:0] stato_video;

always@(posedge pclk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        stato_video_pclk        <= WAIT_ONOFF_POS;
    else
        stato_video_pclk        <= stato_video_pclk_new;

always@(posedge clk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        stato_video <= WAIT_ONOFF_POS;
    else
        stato_video <= stato_video_pclk;

/*    FSM modified for continous processing
    it waits until onoff_pclk goes to 1 and then acquire!
    a later change of onoff_pclk bit is then checked when another frame
    is starting ...
*/
always@(*)
    if(onoff_pclk)
    begin
        case(stato_video_pclk)
            WAIT_ONOFF_POS:
                stato_video_pclk_new = WAIT_FRAME_START;
            WAIT_FRAME_START:
                if (VSYNC_POLARITY == "high")
                begin
                    if(vsync_pos_pclk)
                        stato_video_pclk_new = WAIT_FRAME_END;
                    else
                        stato_video_pclk_new = WAIT_FRAME_START;
                end
                else if(VSYNC_POLARITY == "low")
                begin
                    if(vsync_neg_pclk)
                        stato_video_pclk_new = WAIT_FRAME_END;
                    else
                        stato_video_pclk_new = WAIT_FRAME_START;
                end
                else
                begin
                    $error("VSYNC_POLARITY wrong case (high, low)");
                end

            WAIT_FRAME_END:
                if (VSYNC_POLARITY == "high")
                begin
                    if(vsync_neg_pclk)
                        stato_video_pclk_new = WAIT_ONOFF_POS;
                    else
                        stato_video_pclk_new = WAIT_FRAME_END;
                end
                else if (VSYNC_POLARITY == "low")
                begin
                    if(vsync_pos_pclk)
                        stato_video_pclk_new = WAIT_ONOFF_POS;
                    else
                        stato_video_pclk_new = WAIT_FRAME_END;
                end
                else
                begin
                    $error("VSYNC_POLARITY wrong case (high, low)");
                end

            default:
                stato_video_pclk_new    = WAIT_ONOFF_POS;
        endcase
    end
    else
        stato_video_pclk_new = WAIT_ONOFF_POS;


/*********    WRREQ generation ***********/
/*    WRREQ becomes 'high' when:
        - FSM received a ONOFF_RISE signal
        - FSM received starting frame condition
        - HREF active (depending on HREF_POLARITY parameter)
*/

always@(*)
    begin
        if (HREF_POLARITY == "high")
        begin
            wrreq = href_i & (stato_video_pclk == WAIT_FRAME_END);
        end
        else if (HREF_POLARITY == "low")
        begin
            wrreq = ~href_i & (stato_video_pclk == WAIT_FRAME_END);
        end
        else
        begin
            $error("HREF_POLARITY wrong case (high, low)");
        end
    end


assign aclr_dcfifo = ~scr[0];

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
    .data ( pixel_i ),
    .rdclk ( clk_i ),
    .rdreq ( rdreq ),
    .wrclk ( pclk_i ),
    .wrreq ( wrreq ),
    .q ( out_data ),
    .rdempty ( rdempty ),
    .rdfull ( rdfull ),
    .wrfull(),
    .wrempty(),
    .rdusedw(),
    .wrusedw(),
    .aclr(aclr_dcfifo),
    .eccstatus()
    );



/*****************************************************************************
 *                       Flow generator                                      *
 *****************************************************************************/

 /* DCFIFO rdreq generation */
parameter WAIT_FIFO= 1'b0;
parameter RX_FIFO =  1'b1;

assign scr_onoff_bit = scr[0];

always@(posedge clk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        state <= WAIT_FIFO;
    else
        state <= (scr_onoff_bit & ~rdempty) ? RX_FIFO : WAIT_FIFO;

assign rdreq = ((state == RX_FIFO & ~rdempty) && (fvstate == FVSTATE_FLOW)) ? 1'b1 : 1'b0;

reg dv_d;
always@(posedge clk_i or negedge reset_n_i)
    if (reset_n_i == 0)
        dv_d <= 1'b0;
    else
        dv_d <= rdreq;

assign out_dv = dv_d;


/* Frame valid and data valid generation */
always@(posedge clk_i or negedge reset_n_i)
    if (reset_n_i == 0)
        fvstate <= FVSTATE_INIT;
    else
        fvstate <= fvstate_new;

always@(*)
    case(fvstate)
        FVSTATE_INIT:
            if (scr_onoff_bit)
                if (VSYNC_POLARITY == "high")
                begin
                    if (vsync_pos_clk)
                        fvstate_new = FVSTATE_HBLK;
                    else
                        fvstate_new = FVSTATE_INIT;
                end
                else if (VSYNC_POLARITY == "low")
                begin
                    if (vsync_neg_clk)
                        fvstate_new = FVSTATE_HBLK;
                    else
                        fvstate_new = FVSTATE_INIT;
                end
                else
                begin
                    $error("VSYNC_POLARITY wrong case (high, low)");
                end
            else
                fvstate_new = FVSTATE_INIT;
        FVSTATE_HBLK:
            if (scr_onoff_bit)
                if (state == RX_FIFO & ~rdempty)
                    fvstate_new = FVSTATE_FLOW;
                else
                    fvstate_new = FVSTATE_HBLK;
            else
                fvstate_new = FVSTATE_INIT;
        FVSTATE_FLOW:
            if (scr_onoff_bit)
                if (dvcount == flowlength)
                    fvstate_new = FVSTATE_END;
                else
                    fvstate_new = FVSTATE_FLOW;
            else
                fvstate_new = FVSTATE_INIT;
        FVSTATE_END:
            if (VSYNC_POLARITY == "high")
            begin
                if (scr_onoff_bit)
                    if (vsync_neg_clk)
                        fvstate_new = FVSTATE_INIT;
                    else
                        fvstate_new = FVSTATE_END;
                else
                    fvstate_new = FVSTATE_INIT;
            end
            else if (VSYNC_POLARITY == "low")
            begin
                if (scr_onoff_bit)
                    if (vsync_pos_clk)
                        fvstate_new = FVSTATE_INIT;
                    else
                        fvstate_new = FVSTATE_END;
                else
                    fvstate_new = FVSTATE_INIT;
            end
            else
            begin
                $error("VSYNC_POLARITY wrong case (high, low)");
            end

        default:
            fvstate_new = FVSTATE_HBLK;
    endcase


/* dvcount */
always@(posedge clk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        dvcount <= 0;
    else
        if (out_dv && (dvcount != flowlength))
            dvcount <= dvcount + 1;
        else if (fvstate == FVSTATE_INIT)
            dvcount <= 0;

/* fv_ signal generation */

//always@(posedge clk_i or negedge reset_n_i)
//    if (reset_n_i == 1'b0)
//        fv_d <= 0;
//   else
//        fv_d <= (fvstate == FVSTATE_FLOW);
//assign out_fv = fv_d && (dvcount != flowlength);

assign out_sop = (fvstate == FVSTATE_HBLK) & out_dv;
assign out_eop = (fvstate == FVSTATE_END);

/***********************    HREF counter    ****************/
reg [DATA_WIDTH-1:0] href_count_pclk, href_count_pclk_new;

always@(posedge pclk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        href_count_pclk <= {DATA_WIDTH{1'b0}};
    else
        href_count_pclk <= href_count_pclk_new;

always@(*)
    case(stato_video_pclk)
        WAIT_ONOFF_POS:
            href_count_pclk_new = href_count_pclk;
        WAIT_FRAME_START:
            href_count_pclk_new = {DATA_WIDTH{1'b0}};
        WAIT_FRAME_END:
            if (HREF_POLARITY == "high")
            begin
                if(href_pos_pclk)
                    href_count_pclk_new = href_count_pclk + 1;
                else
                    href_count_pclk_new = href_count_pclk;
            end
            else if (HREF_POLARITY == "low")
            begin
                if(href_neg_pclk)
                    href_count_pclk_new = href_count_pclk + 1;
                else
                    href_count_pclk_new = href_count_pclk;
            end
            else
            begin
                $error("HREF_POLARITY wrong case (high, low)");
            end

        default:
            href_count_pclk_new = {DATA_WIDTH{1'b0}};
    endcase

/***********************    PCLK during HREF counter    ****************/
reg [31:0] pclkonhref_count_pclk, pclkonhref_count_pclk_new;

always@(posedge pclk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
        pclkonhref_count_pclk <= {DATA_WIDTH{1'b0}};
    else
        pclkonhref_count_pclk <= pclkonhref_count_pclk_new;

always@(*)
    case(stato_video_pclk)
        WAIT_ONOFF_POS:
            pclkonhref_count_pclk_new = pclkonhref_count_pclk;
        WAIT_FRAME_START:
            pclkonhref_count_pclk_new = {DATA_WIDTH{1'b0}};
        WAIT_FRAME_END:
            if (HREF_POLARITY == "high")
            begin
                if(href_i)
                    pclkonhref_count_pclk_new = pclkonhref_count_pclk + 1;
                else
                    pclkonhref_count_pclk_new = pclkonhref_count_pclk;
            end
            else if (HREF_POLARITY == "low")
            begin
                if(~href_i)
                    pclkonhref_count_pclk_new = pclkonhref_count_pclk + 1;
                else
                    pclkonhref_count_pclk_new = pclkonhref_count_pclk;
            end
            else
            begin
                $error("HREF_POLARITY wrong case (high, low)");
            end
        default:
            pclkonhref_count_pclk_new = {DATA_WIDTH{1'b0}};
    endcase

/*	Measure of VSYNC period (in CLOCK50 cycles) */
reg [31:0] vsync_period_int;
always@(posedge clk_i or negedge reset_n_i)
begin
    if (reset_n_i == 1'b0)
        vsync_period_int <= 32'd0;
    else
        case(fvstate)
        FVSTATE_HBLK: vsync_period_int <= 0;
        FVSTATE_FLOW: vsync_period_int <= vsync_period_int + 1;
        default:
            vsync_period_int <= vsync_period_int;
        endcase
end

/*    Measuring if buffer_overflow occours */
always @ (*)
    if (rdfull)
        buffer_ovf_cnt_new    = buffer_ovf_cnt + 1;
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


always @ (posedge clk_i or negedge reset_n_i)
    if (reset_n_i == 1'b0)
    begin
        href_count          <= {DATA_WIDTH{1'b0}};
        pclkonhref_count    <= {DATA_WIDTH{1'b0}};
        vsync_period        <= {DATA_WIDTH{1'b0}};
        buffer_ovf_cnt      <= {DATA_WIDTH{1'b0}};
    end
    else if (fvstate == FVSTATE_END)
    begin
        href_count          <= href_count_pclk;
        pclkonhref_count    <= pclkonhref_count_pclk;
        vsync_period        <= vsync_period_int;
        buffer_ovf_cnt      <= buffer_ovf_cnt_new;
    end
    else
    begin
        href_count          <= href_count;
        pclkonhref_count    <= pclkonhref_count;
        vsync_period        <= vsync_period;
        buffer_ovf_cnt      <= buffer_ovf_cnt;
    end

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
