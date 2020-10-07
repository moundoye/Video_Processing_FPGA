
#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3


#**************************************************************
# Create Clock
#**************************************************************

create_clock \
 -name {CLOCK_25} \
 -period 40.000 \
 -waveform {0.000 20.000 } \
 [get_ports {CLOCK_25}]
 
  create_clock \
 -name {PIXCLK} \
 -period 100.000 \
 -waveform {0.000 50.000 } \
 [get_ports {PIXCLK}]
 
  create_clock \
 -name {PCLK} \
 -period 10.000 \
 -waveform {0.000 5.000 } \
 [get_ports {PCLK}]
 
 create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]


#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks


#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty

#**************************************************************
# Set Clock Groups
#**************************************************************
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {PCLK}] 
set_clock_groups -asynchronous -group [get_clocks {elimax_ghrd_nios_sys_inst|altpll_0|sd1|pll7|clk[1]}] 

#**************************************************************
# Set False Path
#**************************************************************

#**************************************************************
# IO delays
#**************************************************************

#**************************************************************
# Set Input Delay
#**************************************************************
set_input_delay -min -clock {PCLK} 0.5ns [get_ports CTL4_SW]
set_input_delay -min -clock {PCLK} 0.5ns [get_ports CTL5]
set_input_delay -min -clock {PCLK} 0.5ns [get_ports CTL6]
set_input_delay -min -clock {PCLK} 0.5ns [get_ports CTL8]
set_input_delay -min -clock {PCLK} 0.5ns [get_ports CTL9]
set_input_delay -min -clock {PCLK} 0.5ns [get_ports CTL10]
set_input_delay -min -clock {PCLK} 0.5ns [get_ports DQ*]

set_input_delay -max -clock {PCLK} 0.5ns [get_ports CTL4_SW]
set_input_delay -max -clock {PCLK} 0.5ns [get_ports CTL5]
set_input_delay -max -clock {PCLK} 0.5ns [get_ports CTL6]
set_input_delay -max -clock {PCLK} 0.5ns [get_ports CTL8]
set_input_delay -max -clock {PCLK} 0.5ns [get_ports CTL9]
set_input_delay -max -clock {PCLK} 0.5ns [get_ports CTL10]
set_input_delay -max -clock {PCLK} 0.5ns [get_ports DQ*]

#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -max -clock {PCLK} 2.0ns [get_ports CTL0]
set_output_delay -min -clock {PCLK} 0.5ns [get_ports CTL0]

set_output_delay -max -clock {PCLK} 2.0ns [get_ports CTL1]
set_output_delay -min -clock {PCLK} 0.5ns [get_ports CTL1]

set_output_delay -max -clock {PCLK} 2.0ns [get_ports CTL2]
set_output_delay -min -clock {PCLK} 0.5ns [get_ports CTL2]

set_output_delay -max -clock {PCLK} 2.0ns [get_ports CTL3]
set_output_delay -min -clock {PCLK} 0.5ns [get_ports CTL3]

set_output_delay -max -clock {PCLK} 2.0ns [get_ports CTL7]
set_output_delay -min -clock {PCLK} 0.5ns [get_ports CTL7]

set_output_delay -max -clock {PCLK} 2.0ns [get_ports CTL11]
set_output_delay -min -clock {PCLK} 0.5ns [get_ports CTL11]

set_output_delay -max -clock {PCLK} 2.0ns [get_ports CTL12]
set_output_delay -min -clock {PCLK} 0.5ns [get_ports CTL12]

set_output_delay -max -clock {PCLK} 2.0ns [get_ports DQ*]
set_output_delay -min -clock {PCLK} 0.5ns [get_ports DQ*]


