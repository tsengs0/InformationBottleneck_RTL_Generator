module base_cnu_min_10 #(
	parameter CN_DEGREE = 10,
	parameter QUAN_SIZE = 3,
	parameter MIN_INDEX_BITWIDTH = $clog2(CN_DEGREE)
)(
	output wire [QUAN_SIZE-1:0] m1,
	output wire [QUAN_SIZE-1:0] m2,
	output wire [MIN_INDEX_BITWIDTH-1:0] min_1_index,
	output wire [MIN_INDEX_BITWIDTH-1:0] min_2_index,

	input wire [QUAN_SIZE-1:0] de_msg_0,
	input wire [QUAN_SIZE-1:0] de_msg_1,
	input wire [QUAN_SIZE-1:0] de_msg_2,
	input wire [QUAN_SIZE-1:0] de_msg_3,
	input wire [QUAN_SIZE-1:0] de_msg_4,
	input wire [QUAN_SIZE-1:0] de_msg_5,
	input wire [QUAN_SIZE-1:0] de_msg_6,
	input wire [QUAN_SIZE-1:0] de_msg_7,
	input wire [QUAN_SIZE-1:0] de_msg_8,
	input wire [QUAN_SIZE-1:0] de_msg_9
);

localparam level_0_sorter_num = 5; // M22_NUM
localparam level_1_sorter_num = 2; // M42_NUM
localparam level_2_sorter_num = 1; // M42_NUM
localparam level_3_sorter_num = 1; // M42_NUM

wire [QUAN_SIZE-1:0] de_msg [0:CN_DEGREE-1];
assign de_msg[0] = de_msg_0[QUAN_SIZE-1:0];
assign de_msg[1] = de_msg_1[QUAN_SIZE-1:0];
assign de_msg[2] = de_msg_2[QUAN_SIZE-1:0];
assign de_msg[3] = de_msg_3[QUAN_SIZE-1:0];
assign de_msg[4] = de_msg_4[QUAN_SIZE-1:0];
assign de_msg[5] = de_msg_5[QUAN_SIZE-1:0];
assign de_msg[6] = de_msg_6[QUAN_SIZE-1:0];
assign de_msg[7] = de_msg_7[QUAN_SIZE-1:0];
assign de_msg[8] = de_msg_8[QUAN_SIZE-1:0];
assign de_msg[9] = de_msg_9[QUAN_SIZE-1:0];
/*---------------------------------------------------  */
// Level 0: to sort the minimum and second minimum of each pair of variable-to-check messages
wire [level_0_sorter_num-1:0] step_min_index_level_0;
genvar i;
generate
	for(i=0;i<level_0_sorter_num;i=i+1) begin : level_0_step_min_sort_inst
		m22 #(
			.QUAN_SIZE(QUAN_SIZE)
		) min_sort_u0 (
			//.m1 (),
			//.m2 (),
			.min_index (step_min_index_level_0[i]),
		
			.v0 (de_msg[i*2]),
			.v1 (de_msg[(i*2)+1])
		);	
	end
endgenerate
// To identify the indices of all sets of minimum and second minimum from incoming variable-to-check messages
wire [MIN_INDEX_BITWIDTH-1:0] v0x_index_level_0 [0:1];// 4'b000_0; 4'b000_1
wire [MIN_INDEX_BITWIDTH-1:0] v1x_index_level_0 [0:1];// 4'b001_0; 4'b001_1
wire [MIN_INDEX_BITWIDTH-1:0] v2x_index_level_0 [0:1];// 4'b010_0; 4'b010_1
wire [MIN_INDEX_BITWIDTH-1:0] v3x_index_level_0 [0:1];// 4'b011_0: 4'b011_1
wire [MIN_INDEX_BITWIDTH-1:0] v4x_index_level_0 [0:1];// 4'b100_0; 4'b100_1
assign v0x_index_level_0[0] = {3'd0, step_min_index_level_0[0]};
assign v0x_index_level_0[1] = {3'd0, ~step_min_index_level_0[0]};
assign v1x_index_level_0[0] = {3'd1, step_min_index_level_0[1]};
assign v1x_index_level_0[1] = {3'd1, ~step_min_index_level_0[1]};
assign v2x_index_level_0[0] = {3'd2, step_min_index_level_0[2]};
assign v2x_index_level_0[1] = {3'd2, ~step_min_index_level_0[2]};
assign v3x_index_level_0[0] = {3'd3, step_min_index_level_0[3]};
assign v3x_index_level_0[1] = {3'd3, ~step_min_index_level_0[3]};
assign v4x_index_level_0[0] = {3'd4, step_min_index_level_0[4]};
assign v4x_index_level_0[1] = {3'd4, ~step_min_index_level_0[4]};
/*---------------------------------------------------  */
// Level 1: to sort the minimum and second minimum among all pairs above
wire [1:0] step_min_index_level_10 [0:1];
wire [1:0] step_min_index_level_11 [0:1];
m42 #(
	.QUAN_SIZE (QUAN_SIZE)
) step_min_sort_u10 (
	//.m1 (),
	//.m2 (),
	.min_index (step_min_index_level_10[0]), // argmin(v00, v01, v10, v11)
	.second_min_index (step_min_index_level_10[1]),

	.v00 (de_msg[ v0x_index_level_0[0] ]),
	.v01 (de_msg[ v0x_index_level_0[1] ]),
	.v10 (de_msg[ v1x_index_level_0[0] ]),
	.v11 (de_msg[ v1x_index_level_0[1] ])
);
m42 #(
	.QUAN_SIZE (QUAN_SIZE)
) step_min_sort_u11 (
	//.m1 (),
	//.m2 (),
	.min_index (step_min_index_level_11[0]), // argmin(v00, v01, v10, v11)
	.second_min_index (step_min_index_level_11[1]),

	.v00 (de_msg[ v2x_index_level_0[0] ]),
	.v01 (de_msg[ v2x_index_level_0[1] ]),
	.v10 (de_msg[ v3x_index_level_0[0] ]),
	.v11 (de_msg[ v3x_index_level_0[1] ])
);

wire [MIN_INDEX_BITWIDTH-1:0] v0x_index_level_1 [0:1];
wire [MIN_INDEX_BITWIDTH-1:0] v1x_index_level_1 [0:1];
// Minimum of (level-1)th M42-0
assign v0x_index_level_1[0] = (step_min_index_level_10[0] == 0) ? v0x_index_level_0[0] :
					  		  (step_min_index_level_10[0] == 1) ? v0x_index_level_0[1] :
					  		  (step_min_index_level_10[0] == 2) ? v1x_index_level_0[0] : v1x_index_level_0[1];
// Second minimum of (level-1)th M42-0
assign v0x_index_level_1[1] = (step_min_index_level_10[1] == 0) ? v0x_index_level_0[0] :
					  		  (step_min_index_level_10[1] == 1) ? v0x_index_level_0[1] :
					  		  (step_min_index_level_10[1] == 2) ? v1x_index_level_0[0] : v1x_index_level_0[1];
// Minimum of (level-1)th M42-1
assign v1x_index_level_1[0] = (step_min_index_level_11[0] == 0) ? v2x_index_level_0[0] :
					  		  (step_min_index_level_11[0] == 1) ? v2x_index_level_0[1] :
					  		  (step_min_index_level_11[0] == 2) ? v3x_index_level_0[0] : v3x_index_level_0[1];
// Second minimum of (level-1)th M42-1
assign v1x_index_level_1[1] = (step_min_index_level_11[1] == 0) ? v2x_index_level_0[0] :
					  		  (step_min_index_level_11[1] == 1) ? v2x_index_level_0[1] :
					  		  (step_min_index_level_11[1] == 2) ? v3x_index_level_0[0] : v3x_index_level_0[1];
/*---------------------------------------------------  */
// Level 2: to sort the minimum and second minimum among all pairs above
wire [1:0] step_min_index_level_20 [0:1];
m42 #(
	.QUAN_SIZE (QUAN_SIZE)
) step_min_sort_u20 (
	//.m1 (),
	//.m2 (),
	.min_index (step_min_index_level_20[0]), // argmin(v00, v01, v10, v11)
	.second_min_index (step_min_index_level_20[1]),

	.v00 (de_msg[ v0x_index_level_1[0] ]),
	.v01 (de_msg[ v0x_index_level_1[1] ]),
	.v10 (de_msg[ v1x_index_level_1[0] ]),
	.v11 (de_msg[ v1x_index_level_1[1] ])
);

wire [MIN_INDEX_BITWIDTH-1:0] v0x_index_level_2 [0:1];
// Minimum of (level-1)th M42-0
assign v0x_index_level_2[0] = (step_min_index_level_20[0] == 0) ? v0x_index_level_1[0] :
					  		  (step_min_index_level_20[0] == 1) ? v0x_index_level_1[1] :
					  		  (step_min_index_level_20[0] == 2) ? v1x_index_level_1[0] : v1x_index_level_1[1];
// Second minimum of (level-1)th M42-0
assign v0x_index_level_2[1] = (step_min_index_level_20[1] == 0) ? v0x_index_level_1[0] :
					  		  (step_min_index_level_20[1] == 1) ? v0x_index_level_1[1] :
					  		  (step_min_index_level_20[1] == 2) ? v1x_index_level_1[0] : v1x_index_level_1[1];
/*---------------------------------------------------  */
// Level 3: to sort final the minimum and second minimum among all pairs above
wire [1:0] step_min_index_level_30 [0:1];
m42 #(
	.QUAN_SIZE (QUAN_SIZE)
) step_min_sort_u30 (
	//.m1 (),
	//.m2 (),
	.min_index (step_min_index_level_30[0]), // argmin(v00, v01, v10, v11)
	.second_min_index (step_min_index_level_30[1]),

	.v00 (de_msg[ v0x_index_level_2[0] ]),
	.v01 (de_msg[ v0x_index_level_2[1] ]),
	.v10 (de_msg[ v4x_index_level_0[0] ]),
	.v11 (de_msg[ v4x_index_level_0[1] ])
);

wire [MIN_INDEX_BITWIDTH-1:0] v0x_index_level_3 [0:1];
// Minimum of 2nd-step M42
assign v0x_index_level_3[0] = (step_min_index_level_30[0] == 0) ? v0x_index_level_2[0] :
					  		  (step_min_index_level_30[0] == 1) ? v0x_index_level_2[1] :
					  		  (step_min_index_level_30[0] == 2) ? v4x_index_level_0[0] : v4x_index_level_0[1];
// Second minimum of 2nd-step M42
assign v0x_index_level_3[1] = (step_min_index_level_30[1] == 0) ? v0x_index_level_2[0] :
					  		  (step_min_index_level_30[1] == 1) ? v0x_index_level_2[1] :
					  		  (step_min_index_level_30[1] == 2) ? v4x_index_level_0[0] : v4x_index_level_0[1];

assign m1[QUAN_SIZE-1:0] = de_msg[ v0x_index_level_3[0] ];
assign m2[QUAN_SIZE-1:0] = de_msg[ v0x_index_level_3[1] ];
assign min_1_index[MIN_INDEX_BITWIDTH-1:0] = v0x_index_level_3[0]; 
assign min_2_index[MIN_INDEX_BITWIDTH-1:0] = v0x_index_level_3[1]; 
endmodule