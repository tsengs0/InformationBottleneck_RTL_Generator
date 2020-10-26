SIMPRG   = vcs -full64 -v2005 -sverilog #-gui
SIM_FILE = wr_update_handshake
SOURCES  = wr_update_handshake_tb.sv wr_update_handshake.v

all:
	$(SIMPRG) $(SOURCES) -o $(SIM_FILE)

run:
	./${SIM_FILE}
	gtkwave cnu_wr_update.vcd &

clean:
	rm -rf $(SIM_FILE) $(SIM_FILE).daidir csrc ucli.key
