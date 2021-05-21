#SIMPRG   = vcs -full64 -v2005 -sverilog -debug_access+r 
SIMPRG   = vcs -full64 -v2005 -sverilog -R -gui -debug_pp 
SIM_FILE = tb
SOURCES  = leq.v \
	m21.v \
	m22.v \
	m42.v \
	opt_cnu_min_6.v \
	base_cnu_min_10.v \
	cnu_10.v \
	cnu_10_tb.sv

all:
	$(SIMPRG) $(SOURCES) -o $(SIM_FILE)

run:
	./${SIM_FILE}
	gtkwave ./${SIM_FILE}.vcd

sim:
	rm -rf $(SIM_FILE) $(SIM_FILE).daidir csrc ucli.key
	rm ${SIM_FILE}.vcd
	rm cnu_6.txt
	$(SIMPRG) $(SOURCES) -o $(SIM_FILE)
	./${SIM_FILE}
	gtkwave ./${SIM_FILE}.vcd

clean:
	rm -rf $(SIM_FILE) $(SIM_FILE).daidir csrc ucli.key
	rm ${SIM_FILE}.vcd
	rm cnu_6.txt
