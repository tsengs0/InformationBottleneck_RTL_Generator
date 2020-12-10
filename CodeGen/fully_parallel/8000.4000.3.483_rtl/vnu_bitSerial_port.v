`include "define.vh"

module vnu_bitSerial_port #(
	parameter MSG_WIDTH = 4
) (
	inout wire [`VN_DEGREE-1] serialInOut,
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