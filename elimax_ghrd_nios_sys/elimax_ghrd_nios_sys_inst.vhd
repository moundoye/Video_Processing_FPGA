	component elimax_ghrd_nios_sys is
		port (
			altpll_0_areset_conduit_export       : in    std_logic                     := 'X';             -- export
			altpll_0_c0_clk                      : out   std_logic;                                        -- clk
			altpll_0_locked_conduit_export       : out   std_logic;                                        -- export
			clear_external_connection_export     : out   std_logic;                                        -- export
			clk_clk                              : in    std_logic                     := 'X';             -- clk
			clock_bridge_0_out_clk_clk           : out   std_logic;                                        -- clk
			led_external_connection_export       : out   std_logic_vector(1 downto 0);                     -- export
			opencores_i2c_0_export_0_scl_pad_io  : inout std_logic                     := 'X';             -- scl_pad_io
			opencores_i2c_0_export_0_sda_pad_io  : inout std_logic                     := 'X';             -- sda_pad_io
			reset_reset_n                        : in    std_logic                     := 'X';             -- reset_n
			trigger_external_connection_export   : out   std_logic;                                        -- export
			usb_streaming_0_clear_fifo_conduit   : in    std_logic                     := 'X';             -- conduit
			usb_streaming_0_ctl0_conduit         : out   std_logic;                                        -- conduit
			usb_streaming_0_ctl1_conduit         : out   std_logic;                                        -- conduit
			usb_streaming_0_ctl11_conduit        : out   std_logic;                                        -- conduit
			usb_streaming_0_ctl12_conduit        : out   std_logic;                                        -- conduit
			usb_streaming_0_ctl2_conduit         : out   std_logic;                                        -- conduit
			usb_streaming_0_ctl3_conduit         : out   std_logic;                                        -- conduit
			usb_streaming_0_ctl4_sw_conduit      : in    std_logic                     := 'X';             -- conduit
			usb_streaming_0_ctl5_conduit         : in    std_logic                     := 'X';             -- conduit
			usb_streaming_0_ctl6_conduit         : in    std_logic                     := 'X';             -- conduit
			usb_streaming_0_ctl7_conduit         : out   std_logic;                                        -- conduit
			usb_streaming_0_ctl8_conduit         : in    std_logic                     := 'X';             -- conduit
			usb_streaming_0_usb_data_conduit     : inout std_logic_vector(15 downto 0) := (others => 'X'); -- conduit
			usbstatus_external_connection_export : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			videosampler_0_href_conduit          : in    std_logic                     := 'X';             -- conduit
			videosampler_0_pclk_i_conduit        : in    std_logic                     := 'X';             -- conduit
			videosampler_0_pixel_i_conduit       : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- conduit
			videosampler_0_vsync_i_conduit       : in    std_logic                     := 'X'              -- conduit
		);
	end component elimax_ghrd_nios_sys;

	u0 : component elimax_ghrd_nios_sys
		port map (
			altpll_0_areset_conduit_export       => CONNECTED_TO_altpll_0_areset_conduit_export,       --       altpll_0_areset_conduit.export
			altpll_0_c0_clk                      => CONNECTED_TO_altpll_0_c0_clk,                      --                   altpll_0_c0.clk
			altpll_0_locked_conduit_export       => CONNECTED_TO_altpll_0_locked_conduit_export,       --       altpll_0_locked_conduit.export
			clear_external_connection_export     => CONNECTED_TO_clear_external_connection_export,     --     clear_external_connection.export
			clk_clk                              => CONNECTED_TO_clk_clk,                              --                           clk.clk
			clock_bridge_0_out_clk_clk           => CONNECTED_TO_clock_bridge_0_out_clk_clk,           --        clock_bridge_0_out_clk.clk
			led_external_connection_export       => CONNECTED_TO_led_external_connection_export,       --       led_external_connection.export
			opencores_i2c_0_export_0_scl_pad_io  => CONNECTED_TO_opencores_i2c_0_export_0_scl_pad_io,  --      opencores_i2c_0_export_0.scl_pad_io
			opencores_i2c_0_export_0_sda_pad_io  => CONNECTED_TO_opencores_i2c_0_export_0_sda_pad_io,  --                              .sda_pad_io
			reset_reset_n                        => CONNECTED_TO_reset_reset_n,                        --                         reset.reset_n
			trigger_external_connection_export   => CONNECTED_TO_trigger_external_connection_export,   --   trigger_external_connection.export
			usb_streaming_0_clear_fifo_conduit   => CONNECTED_TO_usb_streaming_0_clear_fifo_conduit,   --    usb_streaming_0_clear_fifo.conduit
			usb_streaming_0_ctl0_conduit         => CONNECTED_TO_usb_streaming_0_ctl0_conduit,         --          usb_streaming_0_ctl0.conduit
			usb_streaming_0_ctl1_conduit         => CONNECTED_TO_usb_streaming_0_ctl1_conduit,         --          usb_streaming_0_ctl1.conduit
			usb_streaming_0_ctl11_conduit        => CONNECTED_TO_usb_streaming_0_ctl11_conduit,        --         usb_streaming_0_ctl11.conduit
			usb_streaming_0_ctl12_conduit        => CONNECTED_TO_usb_streaming_0_ctl12_conduit,        --         usb_streaming_0_ctl12.conduit
			usb_streaming_0_ctl2_conduit         => CONNECTED_TO_usb_streaming_0_ctl2_conduit,         --          usb_streaming_0_ctl2.conduit
			usb_streaming_0_ctl3_conduit         => CONNECTED_TO_usb_streaming_0_ctl3_conduit,         --          usb_streaming_0_ctl3.conduit
			usb_streaming_0_ctl4_sw_conduit      => CONNECTED_TO_usb_streaming_0_ctl4_sw_conduit,      --       usb_streaming_0_ctl4_sw.conduit
			usb_streaming_0_ctl5_conduit         => CONNECTED_TO_usb_streaming_0_ctl5_conduit,         --          usb_streaming_0_ctl5.conduit
			usb_streaming_0_ctl6_conduit         => CONNECTED_TO_usb_streaming_0_ctl6_conduit,         --          usb_streaming_0_ctl6.conduit
			usb_streaming_0_ctl7_conduit         => CONNECTED_TO_usb_streaming_0_ctl7_conduit,         --          usb_streaming_0_ctl7.conduit
			usb_streaming_0_ctl8_conduit         => CONNECTED_TO_usb_streaming_0_ctl8_conduit,         --          usb_streaming_0_ctl8.conduit
			usb_streaming_0_usb_data_conduit     => CONNECTED_TO_usb_streaming_0_usb_data_conduit,     --      usb_streaming_0_usb_data.conduit
			usbstatus_external_connection_export => CONNECTED_TO_usbstatus_external_connection_export, -- usbstatus_external_connection.export
			videosampler_0_href_conduit          => CONNECTED_TO_videosampler_0_href_conduit,          --           videosampler_0_href.conduit
			videosampler_0_pclk_i_conduit        => CONNECTED_TO_videosampler_0_pclk_i_conduit,        --         videosampler_0_pclk_i.conduit
			videosampler_0_pixel_i_conduit       => CONNECTED_TO_videosampler_0_pixel_i_conduit,       --        videosampler_0_pixel_i.conduit
			videosampler_0_vsync_i_conduit       => CONNECTED_TO_videosampler_0_vsync_i_conduit        --        videosampler_0_vsync_i.conduit
		);

