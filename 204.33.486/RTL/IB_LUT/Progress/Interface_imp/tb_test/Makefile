SIMPRG   = vcs -full64 -v2005 -debug_access+r 
#SIMPRG   = vcs -full64 -v2005 -R -gui -debug_pp 
SIM_FILE = tb
SOURCES  = top.v decom_clk_gen.v c6ibm_port_shifter.v c6ibwr_ram_sel.v ram_sel_counter.v c6ibAddr_ram_sel.v

all:
	$(SIMPRG) $(SOURCES) -o $(SIM_FILE)

run:
	./${SIM_FILE}
	gtkwave ./${SIM_FILE}.vcd 

clean:
	rm -rf $(SIM_FILE) $(SIM_FILE).daidir csrc ucli.key
	rm ${SIM_FILE}.vcd
