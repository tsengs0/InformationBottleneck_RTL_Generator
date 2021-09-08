module partial_base_cnu_min_10 #(
	parameter CN_DEGREE = 10,
	parameter QUAN_SIZE = 3,
	parameter ROW_SPLIT_FACTOR = 5
)(
	//output wire [QUAN_SIZE-1:0] m1,
	//output wire [QUAN_SIZE-1:0] m2,
	output wire [1:0] is_min_0_in,
	output wire [1:0] is_min_1_in,
	output wire min_index_newIn_set,

	input wire [QUAN_SIZE-1:0] de_msg_0,
	input wire [QUAN_SIZE-1:0] de_msg_1,
	input wire [QUAN_SIZE-1:0] de_msg_2,
	input wire [QUAN_SIZE-1:0] de_msg_3,
	input wire feedback_min_index_level_0,
	input wire first_comp // comparison for first set of v2c incoming messages
);

localparam EXT_MSG_PARALLELISM = CN_DEGREE/ROW_SPLIT_FACTOR;

localparam level_0_sorter_num = 5; // M22_NUM
localparam level_1_sorter_num = 2; // M42_NUM
localparam level_2_sorter_num = 1; // M42_NUM
localparam level_3_sorter_num = 1; // M42_NUM

wire [QUAN_SIZE-1:0] de_msg [0:(EXT_MSG_PARALLELISM*2)-1];
assign de_msg[0] = de_msg_0[QUAN_SIZE-1:0];
assign de_msg[1] = de_msg_1[QUAN_SIZE-1:0];
assign de_msg[2] = de_msg_2[QUAN_SIZE-1:0];
assign de_msg[3] = de_msg_3[QUAN_SIZE-1:0];
/*---------------------------------------------------  */
// Level 0: to sort the minimum and second minimum of each pair of variable-to-check messages
wire step_min_index_level_0;
m22 #(
	.QUAN_SIZE(QUAN_SIZE)
) min_sort_u0 (
	//.m1 (),
	//.m2 (),
	.min_index (step_min_index_level_0),

	.v0 (de_msg[0]),
	.v1 (de_msg[1])
);
/*
wire feedback_min_index_level_0;
m22 #(
	.QUAN_SIZE(QUAN_SIZE)
) min_sort_u1 (
	//.m1 (),
	//.m2 (),
	.min_index (feedback_min_index_level_0),

	.v0 (de_msg[2]),
	.v1 (de_msg[3])
);
*/
// To identify the indices of all sets of minimum and second minimum from incoming variable-to-check messages
wire [1:0] v0x_index_level_0 [0:1];// 4'b000_0; 4'b000_1
wire [1:0] v1x_index_level_0 [0:1];// 4'b000_0; 4'b000_1
assign v0x_index_level_0[0] = {1'b0,  step_min_index_level_0};
assign v0x_index_level_0[1] = {1'b0, ~step_min_index_level_0};
//assign v1x_index_level_0[0] = {1'b1,  feedback_min_index_level_0};
//assign v1x_index_level_0[1] = {1'b1, ~feedback_min_index_level_0};
/*---------------------------------------------------  */
// Level 1: to sort the minimum and second minimum among all pairs above
wire [QUAN_SIZE-1:0] feedback_de_msg [0:EXT_MSG_PARALLELISM-1];
partial_m42 #(
	.QUAN_SIZE (QUAN_SIZE)
) step_min_sort_u10 (
	//.m1 (),
	//.m2 (),
	.is_min_0_in (is_min_0_in[1:0]), // argmin(v00, v01, v10, v11)
	.is_min_1_in (is_min_1_in[1:0]),

	.v00 (de_msg[ v0x_index_level_0[0] ]),
	.v01 (de_msg[ v0x_index_level_0[1] ]),
	.v10 (feedback_de_msg[0]),
	.v11 (feedback_de_msg[1])
);
assign feedback_de_msg[0] = (first_comp == 1'b1) ? {QUAN_SIZE{1'b1}} : de_msg[2];//[ v1x_index_level_0[0] ];
assign feedback_de_msg[1] = (first_comp == 1'b1) ? {QUAN_SIZE{1'b1}} : de_msg[3];//[ v1x_index_level_0[1] ];
assign min_index_newIn_set = step_min_index_level_0;
endmodule