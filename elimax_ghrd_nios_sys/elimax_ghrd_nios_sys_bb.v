
module elimax_ghrd_nios_sys (
	altpll_0_areset_conduit_export,
	altpll_0_c0_clk,
	altpll_0_locked_conduit_export,
	clear_external_connection_export,
	clk_clk,
	clock_bridge_0_out_clk_clk,
	led_external_connection_export,
	opencores_i2c_0_export_0_scl_pad_io,
	opencores_i2c_0_export_0_sda_pad_io,
	reset_reset_n,
	trigger_external_connection_export,
	usb_streaming_0_clear_fifo_conduit,
	usb_streaming_0_ctl0_conduit,
	usb_streaming_0_ctl1_conduit,
	usb_streaming_0_ctl11_conduit,
	usb_streaming_0_ctl12_conduit,
	usb_streaming_0_ctl2_conduit,
	usb_streaming_0_ctl3_conduit,
	usb_streaming_0_ctl4_sw_conduit,
	usb_streaming_0_ctl5_conduit,
	usb_streaming_0_ctl6_conduit,
	usb_streaming_0_ctl7_conduit,
	usb_streaming_0_ctl8_conduit,
	usb_streaming_0_usb_data_conduit,
	usbstatus_external_connection_export,
	videosampler_0_href_conduit,
	videosampler_0_pclk_i_conduit,
	videosampler_0_pixel_i_conduit,
	videosampler_0_vsync_i_conduit);	

	input		altpll_0_areset_conduit_export;
	output		altpll_0_c0_clk;
	output		altpll_0_locked_conduit_export;
	output		clear_external_connection_export;
	input		clk_clk;
	output		clock_bridge_0_out_clk_clk;
	output	[1:0]	led_external_connection_export;
	inout		opencores_i2c_0_export_0_scl_pad_io;
	inout		opencores_i2c_0_export_0_sda_pad_io;
	input		reset_reset_n;
	output		trigger_external_connection_export;
	input		usb_streaming_0_clear_fifo_conduit;
	output		usb_streaming_0_ctl0_conduit;
	output		usb_streaming_0_ctl1_conduit;
	output		usb_streaming_0_ctl11_conduit;
	output		usb_streaming_0_ctl12_conduit;
	output		usb_streaming_0_ctl2_conduit;
	output		usb_streaming_0_ctl3_conduit;
	input		usb_streaming_0_ctl4_sw_conduit;
	input		usb_streaming_0_ctl5_conduit;
	input		usb_streaming_0_ctl6_conduit;
	output		usb_streaming_0_ctl7_conduit;
	input		usb_streaming_0_ctl8_conduit;
	inout	[15:0]	usb_streaming_0_usb_data_conduit;
	input	[3:0]	usbstatus_external_connection_export;
	input		videosampler_0_href_conduit;
	input		videosampler_0_pclk_i_conduit;
	input	[7:0]	videosampler_0_pixel_i_conduit;
	input		videosampler_0_vsync_i_conduit;
endmodule
