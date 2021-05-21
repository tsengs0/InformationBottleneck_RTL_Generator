module cnu_10 #(
	parameter CN_DEGREE = 10,
	parameter QUAN_SIZE = 4,
	parameter MAG_SIZE = 3,
	parameter alpha_2  = 2, // 0.25 -> x >> 2
	parameter gamma    = 1  // 0.50 -> x >> 1 
) (
	output reg [QUAN_SIZE-1:0] ch_to_var_0,
	output reg [QUAN_SIZE-1:0] ch_to_var_1,
	output reg [QUAN_SIZE-1:0] ch_to_var_2,
	output reg [QUAN_SIZE-1:0] ch_to_var_3,
	output reg [QUAN_SIZE-1:0] ch_to_var_4,
	output reg [QUAN_SIZE-1:0] ch_to_var_5,
	output reg [QUAN_SIZE-1:0] ch_to_var_6,
	output reg [QUAN_SIZE-1:0] ch_to_var_7,
	output reg [QUAN_SIZE-1:0] ch_to_var_8,
	output reg [QUAN_SIZE-1:0] ch_to_var_9,

	input wire [QUAN_SIZE-1:0] var_to_ch_0,
	input wire [QUAN_SIZE-1:0] var_to_ch_1,
	input wire [QUAN_SIZE-1:0] var_to_ch_2,
	input wire [QUAN_SIZE-1:0] var_to_ch_3,
	input wire [QUAN_SIZE-1:0] var_to_ch_4,
	input wire [QUAN_SIZE-1:0] var_to_ch_5,
	input wire [QUAN_SIZE-1:0] var_to_ch_6,
	input wire [QUAN_SIZE-1:0] var_to_ch_7,
	input wire [QUAN_SIZE-1:0] var_to_ch_8,
	input wire [QUAN_SIZE-1:0] var_to_ch_9,

	input sys_clk,
	input rstn
);