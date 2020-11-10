SIMPRG   = vcs -full64 -v2005 -sverilog #-gui
SIM_FILE = sys_control_tb
SOURCES  = sys_fsm_tb.v \
	define.vh \
	sys_control_unit.v \
	cnu_wr_update_handshake.v \
	vnu_wr_update_handshake.v \
	cn_write_unit.v \
	vn_write_unit.v \
	dn_write_unit.v

all:
	$(SIMPRG) $(SOURCES) -o $(SIM_FILE)

run:
	./${SIM_FILE} &
	gtkwave sys_fsm.vcd & 

clean:
	rm -rf $(SIM_FILE) $(SIM_FILE).daidir csrc ucli.key
	rm sys_fsm.vcd
