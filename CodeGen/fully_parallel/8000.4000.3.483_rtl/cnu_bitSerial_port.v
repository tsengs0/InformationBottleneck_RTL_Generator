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