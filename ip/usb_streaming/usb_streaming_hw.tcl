# TCL File Generated by Component Editor 18.1
# Thu Feb 14 17:02:35 CET 2019
# DO NOT MODIFY


# 
# usb_streaming "usb_streaming" v1.0
#  2019.02.14.17:02:35
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module usb_streaming
# 
set_module_property DESCRIPTION ""
set_module_property NAME usb_streaming
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME usb_streaming
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL usb_streaming
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file ez_interface.vhd VHDL PATH hdl/ez_interface.vhd
add_fileset_file ez_interface_pkg.vhd VHDL PATH hdl/ez_interface_pkg.vhd
add_fileset_file fifo_usb.v VERILOG PATH hdl/fifo_usb.v
add_fileset_file usb_streaming.v VERILOG PATH hdl/usb_streaming.v TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point asi_in0
# 
add_interface asi_in0 avalon_streaming end
set_interface_property asi_in0 associatedClock clock
set_interface_property asi_in0 associatedReset reset
set_interface_property asi_in0 dataBitsPerSymbol 8
set_interface_property asi_in0 errorDescriptor ""
set_interface_property asi_in0 firstSymbolInHighOrderBits true
set_interface_property asi_in0 maxChannel 0
set_interface_property asi_in0 readyLatency 0
set_interface_property asi_in0 ENABLED true
set_interface_property asi_in0 EXPORT_OF ""
set_interface_property asi_in0 PORT_NAME_MAP ""
set_interface_property asi_in0 CMSIS_SVD_VARIABLES ""
set_interface_property asi_in0 SVD_ADDRESS_GROUP ""

add_interface_port asi_in0 stream_data data Input 8
add_interface_port asi_in0 stream_eop endofpacket Input 1
add_interface_port asi_in0 stream_sop startofpacket Input 1
add_interface_port asi_in0 stream_valid valid Input 1


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1


# 
# connection point ctl0
# 
add_interface ctl0 conduit end
set_interface_property ctl0 associatedClock clock
set_interface_property ctl0 associatedReset ""
set_interface_property ctl0 ENABLED true
set_interface_property ctl0 EXPORT_OF ""
set_interface_property ctl0 PORT_NAME_MAP ""
set_interface_property ctl0 CMSIS_SVD_VARIABLES ""
set_interface_property ctl0 SVD_ADDRESS_GROUP ""

add_interface_port ctl0 ctl0 conduit Output 1


# 
# connection point clear_fifo
# 
add_interface clear_fifo conduit end
set_interface_property clear_fifo associatedClock clock
set_interface_property clear_fifo associatedReset ""
set_interface_property clear_fifo ENABLED true
set_interface_property clear_fifo EXPORT_OF ""
set_interface_property clear_fifo PORT_NAME_MAP ""
set_interface_property clear_fifo CMSIS_SVD_VARIABLES ""
set_interface_property clear_fifo SVD_ADDRESS_GROUP ""

add_interface_port clear_fifo clear_fifo conduit Input 1


# 
# connection point ctl1
# 
add_interface ctl1 conduit end
set_interface_property ctl1 associatedClock clock
set_interface_property ctl1 associatedReset ""
set_interface_property ctl1 ENABLED true
set_interface_property ctl1 EXPORT_OF ""
set_interface_property ctl1 PORT_NAME_MAP ""
set_interface_property ctl1 CMSIS_SVD_VARIABLES ""
set_interface_property ctl1 SVD_ADDRESS_GROUP ""

add_interface_port ctl1 ctl1 conduit Output 1


# 
# connection point ctl2
# 
add_interface ctl2 conduit end
set_interface_property ctl2 associatedClock clock
set_interface_property ctl2 associatedReset ""
set_interface_property ctl2 ENABLED true
set_interface_property ctl2 EXPORT_OF ""
set_interface_property ctl2 PORT_NAME_MAP ""
set_interface_property ctl2 CMSIS_SVD_VARIABLES ""
set_interface_property ctl2 SVD_ADDRESS_GROUP ""

add_interface_port ctl2 ctl2 conduit Output 1


# 
# connection point ctl3
# 
add_interface ctl3 conduit end
set_interface_property ctl3 associatedClock clock
set_interface_property ctl3 associatedReset ""
set_interface_property ctl3 ENABLED true
set_interface_property ctl3 EXPORT_OF ""
set_interface_property ctl3 PORT_NAME_MAP ""
set_interface_property ctl3 CMSIS_SVD_VARIABLES ""
set_interface_property ctl3 SVD_ADDRESS_GROUP ""

add_interface_port ctl3 ctl3 conduit Output 1


# 
# connection point ctl5
# 
add_interface ctl5 conduit end
set_interface_property ctl5 associatedClock clock
set_interface_property ctl5 associatedReset ""
set_interface_property ctl5 ENABLED true
set_interface_property ctl5 EXPORT_OF ""
set_interface_property ctl5 PORT_NAME_MAP ""
set_interface_property ctl5 CMSIS_SVD_VARIABLES ""
set_interface_property ctl5 SVD_ADDRESS_GROUP ""

add_interface_port ctl5 ctl5 conduit Input 1


# 
# connection point ctl6
# 
add_interface ctl6 conduit end
set_interface_property ctl6 associatedClock clock
set_interface_property ctl6 associatedReset ""
set_interface_property ctl6 ENABLED true
set_interface_property ctl6 EXPORT_OF ""
set_interface_property ctl6 PORT_NAME_MAP ""
set_interface_property ctl6 CMSIS_SVD_VARIABLES ""
set_interface_property ctl6 SVD_ADDRESS_GROUP ""

add_interface_port ctl6 ctl6 conduit Input 1


# 
# connection point ctl7
# 
add_interface ctl7 conduit end
set_interface_property ctl7 associatedClock clock
set_interface_property ctl7 associatedReset ""
set_interface_property ctl7 ENABLED true
set_interface_property ctl7 EXPORT_OF ""
set_interface_property ctl7 PORT_NAME_MAP ""
set_interface_property ctl7 CMSIS_SVD_VARIABLES ""
set_interface_property ctl7 SVD_ADDRESS_GROUP ""

add_interface_port ctl7 ctl7 conduit Output 1


# 
# connection point ctl8
# 
add_interface ctl8 conduit end
set_interface_property ctl8 associatedClock clock
set_interface_property ctl8 associatedReset ""
set_interface_property ctl8 ENABLED true
set_interface_property ctl8 EXPORT_OF ""
set_interface_property ctl8 PORT_NAME_MAP ""
set_interface_property ctl8 CMSIS_SVD_VARIABLES ""
set_interface_property ctl8 SVD_ADDRESS_GROUP ""

add_interface_port ctl8 ctl8 conduit Input 1


# 
# connection point ctl11
# 
add_interface ctl11 conduit end
set_interface_property ctl11 associatedClock clock
set_interface_property ctl11 associatedReset ""
set_interface_property ctl11 ENABLED true
set_interface_property ctl11 EXPORT_OF ""
set_interface_property ctl11 PORT_NAME_MAP ""
set_interface_property ctl11 CMSIS_SVD_VARIABLES ""
set_interface_property ctl11 SVD_ADDRESS_GROUP ""

add_interface_port ctl11 ctl11 conduit Output 1


# 
# connection point ctl12
# 
add_interface ctl12 conduit end
set_interface_property ctl12 associatedClock clock
set_interface_property ctl12 associatedReset ""
set_interface_property ctl12 ENABLED true
set_interface_property ctl12 EXPORT_OF ""
set_interface_property ctl12 PORT_NAME_MAP ""
set_interface_property ctl12 CMSIS_SVD_VARIABLES ""
set_interface_property ctl12 SVD_ADDRESS_GROUP ""

add_interface_port ctl12 ctl12 conduit Output 1


# 
# connection point usb_data
# 
add_interface usb_data conduit end
set_interface_property usb_data associatedClock clock
set_interface_property usb_data associatedReset ""
set_interface_property usb_data ENABLED true
set_interface_property usb_data EXPORT_OF ""
set_interface_property usb_data PORT_NAME_MAP ""
set_interface_property usb_data CMSIS_SVD_VARIABLES ""
set_interface_property usb_data SVD_ADDRESS_GROUP ""

add_interface_port usb_data usb_data conduit Bidir 16


# 
# connection point ctl4_sw
# 
add_interface ctl4_sw conduit end
set_interface_property ctl4_sw associatedClock clock
set_interface_property ctl4_sw associatedReset ""
set_interface_property ctl4_sw ENABLED true
set_interface_property ctl4_sw EXPORT_OF ""
set_interface_property ctl4_sw PORT_NAME_MAP ""
set_interface_property ctl4_sw CMSIS_SVD_VARIABLES ""
set_interface_property ctl4_sw SVD_ADDRESS_GROUP ""

add_interface_port ctl4_sw ctl4_sw conduit Input 1

