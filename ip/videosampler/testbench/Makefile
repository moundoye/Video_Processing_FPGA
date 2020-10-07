#       Makefile
#       
#       2013 acvin <luca@luca-lab>
#       

QUARTUSVERSION = 15.1

ALTERA_DIR = ~/altera/$(QUARTUSVERSION)/modelsim_ase/bin
LIBSIM = -L ~/altera/$(QUARTUSVERSION)/modelsim_ase/altera/verilog/altera_mf/ -L ~/altera/$(QUARTUSVERSION)/modelsim_ase/altera/verilog/220model/
 

# compiling the source file.
%: %.v
	$(ALTERA_DIR)/vlib work
	$(ALTERA_DIR)/vlog $@.v ../hdl/*.v ../../streamstore/hdl/* && $(ALTERA_DIR)/vsim -c $(LIBSIM) -do 'run 200us;quit' $@
	
