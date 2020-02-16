q=4 # 4-bit quantisation
CN_DEGREE = 6
M = CN_DEGREE-2
cardinality = pow(2, q)
Iter_max = 50
entry_num = cardinality*cardinality

# Generate input port of configured data
config_input_file = 'config_input_file.v'
def gen_reconf_input():
	create_config_input = config_input_file
	ConfigIn_file = open(create_config_input, "w")
	for i in range(entry_num):
		ConfigIn_file.write("\tinput wire [`QUAN_SIZE-1:0] t_"+str(i)+",\n")
	ConfigIn_file.close()	

# Generate the switch-cases of reconfigurable multiplexer 
reconfig_mux_file = 'config_mux_file.v'
def gen_reconf_mux():
	create_config_input = reconfig_mux_file
	ConfigIn_file = open(create_config_input, "w")
	ConfigIn_file.write("always @(posedge sys_clk) begin\n")
	ConfigIn_file.write("\tcase(addr_in[`IB_ADDR-1:0])\n")

	for i in range(entry_num):
		ConfigIn_file.write("\t\t`IB_ADDR'd"+str(int(i))+": t_c[`QUAN_SIZE-1:0] <= t_"+str(int(i))+"[`QUAN_SIZE-1:0];\n")
	ConfigIn_file.write("\tendcase\n")
	ConfigIn_file.write("end")
	ConfigIn_file.close()	

#gen_reconf_input()
#gen_reconf_mux()
