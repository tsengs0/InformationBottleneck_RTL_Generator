module vnu_bitSerial_port #(
	parameter MSG_WIDTH = 4,
	parameter VN_DEGREE = 3
) (
	inout wire serialInOut_0,
	inout wire serialInOut_1,
	inout wire serialInOut_2,
	output wire [MSG_WIDTH-1:0] c2v_parallelOut_0,
	output wire [MSG_WIDTH-1:0] c2v_parallelOut_1,
	output wire [MSG_WIDTH-1:0] c2v_parallelOut_2,

	input wire [MSG_WIDTH-1:0] v2c_parallelIn_0,
	input wire [MSG_WIDTH-1:0] v2c_parallelIn_1,
	input wire [MSG_WIDTH-1:0] v2c_parallelIn_2,
	input wire load,
	input wire parallel_en,
	input wire serial_clk
);

halfDuplex_parallel2serial #(
	.MSG_WIDTH(MSG_WIDTH) // the default bit width of one message is 4-bit
) vnu_interface_u0(
	.serial_inout (serialInOut_0),
	.parallel_out (c2v_parallelOut_0[MSG_WIDTH-1:0]),

	.parallel_in (v2c_parallelIn_0[MSG_WIDTH-1:0]),
	.load (load),
	.parallel_en (parallel_en),
	.sys_clk (serial_clk)
);
halfDuplex_parallel2serial #(
	.MSG_WIDTH(MSG_WIDTH) // the default bit width of one message is 4-bit
) vnu_interface_u1(
	.serial_inout (serialInOut_1),
	.parallel_out (c2v_parallelOut_1[MSG_WIDTH-1:0]),

	.parallel_in (v2c_parallelIn_1[MSG_WIDTH-1:0]),
	.load (load),
	.parallel_en (parallel_en),
	.sys_clk (serial_clk)
);
halfDuplex_parallel2serial #(
	.MSG_WIDTH(MSG_WIDTH) // the default bit width of one message is 4-bit
) vnu_interface_u2(
	.serial_inout (serialInOut_2),
	.parallel_out (c2v_parallelOut_2[MSG_WIDTH-1:0]),

	.parallel_in (v2c_parallelIn_2[MSG_WIDTH-1:0]),
	.load (load),
	.parallel_en (parallel_en),
	.sys_clk (serial_clk)
);
endmodule