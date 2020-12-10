`include "define.vh"

module cnu_bitSerial_port #(
	parameter MSG_WIDTH = 4
) (
	inout wire [`CN_DEGREE-1] serialInOut,
	output wire [MSG_WIDTH-1:0] v2c_parallelOut_0,
	output wire [MSG_WIDTH-1:0] v2c_parallelOut_1,
	output wire [MSG_WIDTH-1:0] v2c_parallelOut_2,
	output wire [MSG_WIDTH-1:0] v2c_parallelOut_3,
	output wire [MSG_WIDTH-1:0] v2c_parallelOut_4,
	output wire [MSG_WIDTH-1:0] v2c_parallelOut_5,

	input wire [MSG_WIDTH-1:0] c2v_parallelIn_0,
	input wire [MSG_WIDTH-1:0] c2v_parallelIn_1,
	input wire [MSG_WIDTH-1:0] c2v_parallelIn_2,
	input wire [MSG_WIDTH-1:0] c2v_parallelIn_3,
	input wire [MSG_WIDTH-1:0] c2v_parallelIn_4,
	input wire [MSG_WIDTH-1:0] c2v_parallelIn_5,
	input wire load,
	input wire parallel_en,
	input wire serial_clk
);

halfDuplex_parallel2serial #(
	.MSG_WIDTH(MSG_WIDTH) // the default bit width of one message is 4-bit
) cnu_interface_u0(
	.serial_inout (serialInOut[i]),
	.parallel_out (v2c_parallelOut_0[MSG_WIDTH-1:0]),

	.parallen_in (c2v_parallelIn_0[MSG_WIDTH-1:0]),
	.load (load),
	.parallel_en (parallel_en),
	.sys_clk (serial_clk)
);
halfDuplex_parallel2serial #(
	.MSG_WIDTH(MSG_WIDTH) // the default bit width of one message is 4-bit
) cnu_interface_u1(
	.serial_inout (serialInOut[i]),
	.parallel_out (v2c_parallelOut_1[MSG_WIDTH-1:0]),

	.parallen_in (c2v_parallelIn_1[MSG_WIDTH-1:0]),
	.load (load),
	.parallel_en (parallel_en),
	.sys_clk (serial_clk)
);
halfDuplex_parallel2serial #(
	.MSG_WIDTH(MSG_WIDTH) // the default bit width of one message is 4-bit
) cnu_interface_u2(
	.serial_inout (serialInOut[i]),
	.parallel_out (v2c_parallelOut_2[MSG_WIDTH-1:0]),

	.parallen_in (c2v_parallelIn_2[MSG_WIDTH-1:0]),
	.load (load),
	.parallel_en (parallel_en),
	.sys_clk (serial_clk)
);
halfDuplex_parallel2serial #(
	.MSG_WIDTH(MSG_WIDTH) // the default bit width of one message is 4-bit
) cnu_interface_u3(
	.serial_inout (serialInOut[i]),
	.parallel_out (v2c_parallelOut_3[MSG_WIDTH-1:0]),

	.parallen_in (c2v_parallelIn_3[MSG_WIDTH-1:0]),
	.load (load),
	.parallel_en (parallel_en),
	.sys_clk (serial_clk)
);
halfDuplex_parallel2serial #(
	.MSG_WIDTH(MSG_WIDTH) // the default bit width of one message is 4-bit
) cnu_interface_u4(
	.serial_inout (serialInOut[i]),
	.parallel_out (v2c_parallelOut_4[MSG_WIDTH-1:0]),

	.parallen_in (c2v_parallelIn_4[MSG_WIDTH-1:0]),
	.load (load),
	.parallel_en (parallel_en),
	.sys_clk (serial_clk)
);
halfDuplex_parallel2serial #(
	.MSG_WIDTH(MSG_WIDTH) // the default bit width of one message is 4-bit
) cnu_interface_u5(
	.serial_inout (serialInOut[i]),
	.parallel_out (v2c_parallelOut_5[MSG_WIDTH-1:0]),

	.parallen_in (c2v_parallelIn_5[MSG_WIDTH-1:0]),
	.load (load),
	.parallel_en (parallel_en),
	.sys_clk (serial_clk)
);
endmodule