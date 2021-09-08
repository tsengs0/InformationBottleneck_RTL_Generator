module cnu_10_area_eval (
	output wire [3:0] ch_to_var_0,
	output wire [3:0] ch_to_var_1,
	output wire [3:0] ch_to_var_2,
	output wire [3:0] ch_to_var_3,
	output wire [3:0] ch_to_var_4,
	output wire [3:0] ch_to_var_5,
	output wire [3:0] ch_to_var_6,
	output wire [3:0] ch_to_var_7,
	output wire [3:0] ch_to_var_8,
	output wire [3:0] ch_to_var_9,

	input wire [3:0] var_to_ch_0,
	input wire [3:0] var_to_ch_1,
	input wire [3:0] var_to_ch_2,
	input wire [3:0] var_to_ch_3,
	input wire [3:0] var_to_ch_4,
	input wire [3:0] var_to_ch_5,
	input wire [3:0] var_to_ch_6,
	input wire [3:0] var_to_ch_7,
	input wire [3:0] var_to_ch_8,
	input wire [3:0] var_to_ch_9,

	output wire [3:0] partial_ch_to_var_0,
	output wire [3:0] partial_ch_to_var_1,

	input wire [3:0] partial_var_to_ch_0,
	input wire [3:0] partial_var_to_ch_1,

	input wire first_comp, // comparison for first set of v2c incoming messages

	input sys_clk,
	input rstn
);

cnu_10 #(
	.CN_DEGREE (10),
	.QUAN_SIZE (4),
	.MAG_SIZE  (3),
	.alpha_2   (2), // 0.25 -> x >> 2
	.gamma     (1)  // 0.50 -> x >> 1 
) u0 (
	.ch_to_var_0 (ch_to_var_0),
	.ch_to_var_1 (ch_to_var_1),
	.ch_to_var_2 (ch_to_var_2),
	.ch_to_var_3 (ch_to_var_3),
	.ch_to_var_4 (ch_to_var_4),
	.ch_to_var_5 (ch_to_var_5),
	.ch_to_var_6 (ch_to_var_6),
	.ch_to_var_7 (ch_to_var_7),
	.ch_to_var_8 (ch_to_var_8),
	.ch_to_var_9 (ch_to_var_9),

	.var_to_ch_0 (var_to_ch_0),
	.var_to_ch_1 (var_to_ch_1),
	.var_to_ch_2 (var_to_ch_2),
	.var_to_ch_3 (var_to_ch_3),
	.var_to_ch_4 (var_to_ch_4),
	.var_to_ch_5 (var_to_ch_5),
	.var_to_ch_6 (var_to_ch_6),
	.var_to_ch_7 (var_to_ch_7),
	.var_to_ch_8 (var_to_ch_8),
	.var_to_ch_9 (var_to_ch_9),

	.sys_clk (sys_clk),
	.rstn (rstn)
);

partial_cnu_10 #(
	.CN_DEGREE (10),
	.QUAN_SIZE (4),
	.MAG_SIZE  (3),
	.ROW_SPLIT_FACTOR (5)
) u1 (
	.ch_to_var_0 (partial_ch_to_var_0),
	.ch_to_var_1 (partial_ch_to_var_1),

	.var_to_ch_0 (partial_var_to_ch_0),
	.var_to_ch_1 (partial_var_to_ch_1),

	.first_comp (first_comp), // comparison for first set of v2c incoming messages
	.sys_clk (sys_clk),
	.rstn (rstn)
);
endmodule