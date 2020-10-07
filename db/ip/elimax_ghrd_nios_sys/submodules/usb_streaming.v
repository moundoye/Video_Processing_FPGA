module usb_streaming
(
	input wire clk,
	input wire reset_n,
	input wire clear_fifo,
	input wire stream_eop,
	input [7:0] stream_data,
	input wire stream_valid,
	input wire stream_sop,
	inout wire [15:0] usb_data,
	output ctl0,
	output ctl1,
	output ctl2,
	output ctl3,
	input  ctl4_sw,
	input  ctl5,
	input  ctl6,
	output ctl7,
	input  ctl8,
	output ctl11,
	output ctl12
);

wire fifo_full;
wire fifo_last_data;
wire fifo_rdempty;
wire fifo_almost_full;
wire fifo_rdreq;
wire [15:0] fifo_data;

wire [15:0] ez_data_out;
wire [15:0] ez_data_in;

wire [15:0] sink_data;
wire sink_data_valid;

fifo_usb fifo_usb_inst
(
    .clock          (clk),
    .sclr           (clear_fifo),
    
    .data           ({stream_eop, stream_data[7:0]}),
    .wrreq          (stream_valid),
    
    .rdreq          (fifo_rdreq),
    .q              ({fifo_last_data, fifo_data[7:0]}),
    
    .almost_full    (fifo_almost_full),
    .empty          (fifo_rdempty),
    .full           (fifo_full)
    
);

assign fifo_data[15:8] = 0;

ez_interface 
#(
    .DATA_WIDTH(16)
) 
ez_interface_inst
(
    .clk                (clk),
    .rst                (~reset_n),
    .fifo_rdreq         (fifo_rdreq),
    .fifo_almost_full   (fifo_almost_full | stream_eop),
    .fifo_rdempty       (fifo_rdempty),
    .fifo_data          (fifo_data),
    .fifo_last_data     (fifo_last_data),
    .single_access_mode (1'b0),

    .sink_data          (),
    .sink_data_valid    (),

    // EZ GPIF II Slave FIFO interface
    .ez_data_out        (ez_data_out),
    .ez_data_in         (ez_data_in),
    .ez_addr            ({ctl11, ctl12}),
    .ez_rd              (ctl3), 
    .ez_cs              (ctl0),
    .ez_wr              (ctl1),
    .ez_oe              (ctl2),
    .ez_pktend          (ctl7),
    .ez_flaga           (ctl4_sw),
    .ez_flagb           (ctl5),
    .ez_flagc           (ctl6),
    .ez_flagd           (ctl8)
);

// EZ Bidir Data bus    
assign usb_data = (ctl2 == 1'b1) ? ez_data_out : 16'bZ;
assign ez_data_in = usb_data;

endmodule
