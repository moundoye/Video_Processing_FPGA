library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity elimax is
    port (
    CLOCK_25    :  in std_logic;

    RESET_N     :  in std_logic;
    
    USR_LEDS    : out std_logic_vector(1 downto 0);
    
    CMOS_SDA    : inout std_logic;
    CMOS_SCL    : inout std_logic;
    
    DOUT        : in std_logic_vector(11 downto 0);
    
    EXTCLOCK    : out std_logic;
    PIXCLK      :  in std_logic;
    TRIGGER     : out std_logic;
    FRAME_VALID :  in std_logic;
    LINE_VALID  :  in std_logic;
    
    OE_BAR      : out std_logic;
    RESET_BAR   : out std_logic;
    
    EZ_RSTN : out std_logic;

    PMODE0  : inout std_logic;
    PMODE1  : inout std_logic;
    PMODE2  : inout std_logic;
    
    PCLK    : out std_logic;

    DQ      : inout std_logic_vector(15 downto 0);

    CTL0    : out std_logic;
    CTL1    : out std_logic;
    CTL2    : out std_logic;
    CTL3    : out std_logic;
    CTL4_SW :  in std_logic;
    CTL5    :  in std_logic;
    CTL6    :  in std_logic;
    CTL7    : out std_logic;
    CTL8    :  in std_logic;
    CTL9    :  in std_logic;
    CTL10   :  in std_logic;
    CTL11   : out std_logic;
    CTL12   : out std_logic
);
end entity; 

architecture structural of elimax is

signal data_pixel   : std_logic_vector(7 downto 0);
signal data_valid   : std_logic;
signal eop          : std_logic;
signal sop          : std_logic;

signal clock          : std_logic;

signal inter_data_pixel   : std_logic_vector(7 downto 0);
signal inter_data_valid   : std_logic;
signal inter_eop          : std_logic;
signal inter_sop          : std_logic;

signal clear_fifo   : std_logic;
signal leds         : std_logic_vector(1 downto 0);
signal usbstatus : std_logic_vector (3 downto 0);

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

component IP_custom is 
    port (
	 
	 CLOCK    :  in std_logic;

    RESET_N     :  in std_logic;
    
	 in_data    :  in std_logic_vector(7 downto 0);
	 in_dv		:	in std_logic;
	 in_sop		:	in std_logic;
	 in_eop		:	in std_logic;
	 
	 
	 out_data   :  out std_logic_vector(7 downto 0);
	 out_dv		:	out std_logic;
	 out_sop		:	out std_logic;
	 out_eop		:	out std_logic);
end component; 



begin

OE_BAR      <= '0';
RESET_BAR   <= RESET_N;
USR_LEDS    <= leds;
PCLK			<= clock;

usbstatus <= '0' & '0' & CTL6 & CTL9;

elimax_ghrd_nios_sys_inst : component elimax_ghrd_nios_sys 
    port map (
    altpll_0_areset_conduit_export       => '0',      
    altpll_0_locked_conduit_export       => open,
    altpll_0_c0_clk                      => EXTCLOCK,
    clock_bridge_0_out_clk_clk           => clock,
    clear_external_connection_export     => clear_fifo,    
    clk_clk                              => CLOCK_25,                     
    led_external_connection_export       => leds,      
    opencores_i2c_0_export_0_scl_pad_io  => CMOS_SCL,  
    opencores_i2c_0_export_0_sda_pad_io  => CMOS_SDA,
    reset_reset_n                        => RESET_N,                       
    trigger_external_connection_export   => TRIGGER,   
    usbstatus_external_connection_export => usbstatus, 
    videosampler_0_href_conduit          => LINE_VALID, 
    videosampler_0_pclk_i_conduit        => PIXCLK,     
    videosampler_0_pixel_i_conduit       => DOUT(11 downto 4), 
    videosampler_0_vsync_i_conduit       => FRAME_VALID,
    usb_streaming_0_ctl0_conduit         => CTL0,         
    usb_streaming_0_clear_fifo_conduit   => clear_fifo,   
    usb_streaming_0_ctl1_conduit         => CTL1,         
    usb_streaming_0_ctl2_conduit         => CTL2,         
    usb_streaming_0_ctl3_conduit         => CTL3,         
    usb_streaming_0_ctl5_conduit         => CTL5,         
    usb_streaming_0_ctl6_conduit         => CTL6,         
    usb_streaming_0_ctl7_conduit         => CTL7,         
    usb_streaming_0_ctl8_conduit         => CTL8,         
    usb_streaming_0_ctl11_conduit        => CTL11,        
    usb_streaming_0_ctl12_conduit        => CTL12,        
    usb_streaming_0_usb_data_conduit     => DQ,         
    usb_streaming_0_ctl4_sw_conduit      => CTL4_SW

    --videosampler_0_avalon_streaming_source_data          => data_pixel,
    --videosampler_0_avalon_streaming_source_valid         => data_valid,
    --videosampler_0_avalon_streaming_source_endofpacket   => eop,
    --videosampler_0_avalon_streaming_source_startofpacket => sop,

    --usb_streaming_0_asi_in0_data                         => inter_data_pixel,
    --usb_streaming_0_asi_in0_endofpacket                  => inter_eop,
    --usb_streaming_0_asi_in0_startofpacket                => inter_sop,
    --usb_streaming_0_asi_in0_valid                        => inter_data_valid
         
);		  
		  
--My_IP : IP_custom port map (clock, RESET_N, data_pixel, data_valid,sop, eop, inter_data_pixel, inter_data_valid, inter_sop, inter_eop);

PMODE0 <= 'Z';
PMODE1 <= 'Z';
PMODE2 <= 'Z';

EZ_RSTN <= RESET_N; 

end structural;
