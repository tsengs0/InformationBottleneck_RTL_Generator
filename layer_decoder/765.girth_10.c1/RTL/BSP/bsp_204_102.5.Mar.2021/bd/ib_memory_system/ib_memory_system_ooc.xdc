################################################################################

# This XDC is used only for OOC mode of synthesis, implementation
# This constraints file contains default clock frequencies to be used during
# out-of-context flows such as OOC Synthesis and Hierarchical Designs.
# This constraints file is not used in normal top-down synthesis (default flow
# of Vivado)
################################################################################
create_clock -name cn_iter0_m0_portA_clk -period 10 [get_ports cn_iter0_m0_portA_clk]
create_clock -name cn_iter0_m0_portB_clk -period 10 [get_ports cn_iter0_m0_portB_clk]
create_clock -name cn_iter0_m1_portA_clk -period 10 [get_ports cn_iter0_m1_portA_clk]
create_clock -name cn_iter0_m1_portB_clk -period 10 [get_ports cn_iter0_m1_portB_clk]
create_clock -name cn_iter0_m2_portA_clk -period 10 [get_ports cn_iter0_m2_portA_clk]
create_clock -name cn_iter0_m2_portB_clk -period 10 [get_ports cn_iter0_m2_portB_clk]
create_clock -name cn_iter0_m3_portA_clk -period 10 [get_ports cn_iter0_m3_portA_clk]
create_clock -name cn_iter0_m3_portB_clk -period 10 [get_ports cn_iter0_m3_portB_clk]
create_clock -name cn_iter1_m0_portA_clk -period 10 [get_ports cn_iter1_m0_portA_clk]
create_clock -name cn_iter1_m0_portB_clk -period 10 [get_ports cn_iter1_m0_portB_clk]
create_clock -name cn_iter1_m1_portA_clk -period 10 [get_ports cn_iter1_m1_portA_clk]
create_clock -name cn_iter1_m1_portB_clk -period 10 [get_ports cn_iter1_m1_portB_clk]
create_clock -name cn_iter1_m2_portA_clk -period 10 [get_ports cn_iter1_m2_portA_clk]
create_clock -name cn_iter1_m2_portB_clk -period 10 [get_ports cn_iter1_m2_portB_clk]
create_clock -name cn_iter1_m3_portA_clk -period 10 [get_ports cn_iter1_m3_portA_clk]
create_clock -name cn_iter1_m3_portB_clk -period 10 [get_ports cn_iter1_m3_portB_clk]
create_clock -name dn_iter0_portA_clk -period 10 [get_ports dn_iter0_portA_clk]
create_clock -name dn_iter0_portB_clk -period 10 [get_ports dn_iter0_portB_clk]
create_clock -name dn_iter1_portA_clk -period 10 [get_ports dn_iter1_portA_clk]
create_clock -name dn_iter1_portB_clk -period 10 [get_ports dn_iter1_portB_clk]
create_clock -name vn_iter0_m0_portA_clk -period 10 [get_ports vn_iter0_m0_portA_clk]
create_clock -name vn_iter0_m0_portB_clk -period 10 [get_ports vn_iter0_m0_portB_clk]
create_clock -name vn_iter0_m1_portA_clk -period 10 [get_ports vn_iter0_m1_portA_clk]
create_clock -name vn_iter0_m1_portB_clk -period 10 [get_ports vn_iter0_m1_portB_clk]
create_clock -name vn_iter1_m0_portA_clk -period 10 [get_ports vn_iter1_m0_portA_clk]
create_clock -name vn_iter1_m0_portB_clk -period 10 [get_ports vn_iter1_m0_portB_clk]
create_clock -name vn_iter1_m1_portA_clk -period 10 [get_ports vn_iter1_m1_portA_clk]
create_clock -name vn_iter1_m1_portB_clk -period 10 [get_ports vn_iter1_m1_portB_clk]

################################################################################