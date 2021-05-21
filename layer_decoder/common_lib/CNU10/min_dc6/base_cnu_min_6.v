module base_cnu_min_6 #(
	parameter CN_DEGREE = 6,
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
	input wire [QUAN_SIZE-1:0] de_msg_5
);

localparam M22_NUM = CN_DEGREE/2;
localparam M42_NUM = $ceil(M22_NUM);

wire [QUAN_SIZE-1:0] de_msg [0:CN_DEGREE-1];
assign de_msg[0] = de_msg_0[QUAN_SIZE-1:0];
assign de_msg[1] = de_msg_1[QUAN_SIZE-1:0];
assign de_msg[2] = de_msg_2[QUAN_SIZE-1:0];
assign de_msg[3] = de_msg_3[QUAN_SIZE-1:0];
assign de_msg[4] = de_msg_4[QUAN_SIZE-1:0];
assign de_msg[5] = de_msg_5[QUAN_SIZE-1:0];

/*---------------------------------------------------  */
// First Depth: to sort the minimum and second minimum of each pair of variable-to-check messages
wire [M22_NUM-1:0] first_step_min_index;
genvar i;
generate
	for(i=0;i<M22_NUM;i=i+1) begin : first_step_min_sort_inst
		m22 #(
			.QUAN_SIZE(QUAN_SIZE)
		) min_sort_u0 (
			//.m1 (),
			//.m2 (),
			.min_index (first_step_min_index[i]),
		
			.v0 (de_msg[i*2]),
			.v1 (de_msg[(i*2)+1])
		);	
	end
endgenerate
// To identify the indices of all sets of minimum and second minimum from incoming variable-to-check messages
wire [2:0] v0x_index [0:1];
wire [2:0] v1x_index [0:1];
wire [2:0] v2x_index [0:1];
assign v0x_index[0] = {2'b00, first_step_min_index[0]};
assign v0x_index[1] = {2'b00, ~first_step_min_index[0]};
assign v1x_index[0] = {2'b01, first_step_min_index[1]};
assign v1x_index[1] = {2'b01, ~first_step_min_index[1]};
assign v2x_index[0] = {2'b10, first_step_min_index[2]};
assign v2x_index[1] = {2'b10, ~first_step_min_index[2]};
/*---------------------------------------------------  */
// Second Depth: to sort the minimum and second minimum among all pairs above
wire [1:0] second_step_min_index [0:1];
m42 #(
	.QUAN_SIZE (QUAN_SIZE)
) second_step_min_sort_u0 (
	//.m1 (),
	//.m2 (),
	.min_index (second_step_min_index[0]), // argmin(v00, v01, v10, v11)
	.second_min_index (second_step_min_index[1]),

	.v00 (de_msg[ v0x_index[0] ]),
	.v01 (de_msg[ v0x_index[1] ]),
	.v10 (de_msg[ v1x_index[0] ]),
	.v11 (de_msg[ v1x_index[1] ])
);
wire [2:0] v3x_index [0:1];
// Minimum of 2nd-step M42
assign v3x_index[0] = (second_step_min_index[0] == 0) ? v0x_index[0] :
					  (second_step_min_index[0] == 1) ? v0x_index[1] :
					  (second_step_min_index[0] == 2) ? v1x_index[0] : v1x_index[1];
// Second minimum of 2nd-step M42
assign v3x_index[1] = (second_step_min_index[1] == 0) ? v0x_index[0] :
					  (second_step_min_index[1] == 1) ? v0x_index[1] :
					  (second_step_min_index[1] == 2) ? v1x_index[0] : v1x_index[1];
/*---------------------------------------------------  */
// Third Depth: to sort final the minimum and second minimum among all pairs above
wire [1:0] third_step_min_index [0:1];
m42 #(
	.QUAN_SIZE (QUAN_SIZE)
) third_step_min_sort_u0 (
	//.m1 (),
	//.m2 (),
	.min_index (third_step_min_index[0]), // argmin(v00, v01, v10, v11)
	.second_min_index (third_step_min_index[1]),

	.v00 (de_msg[ v3x_index[0] ]),
	.v01 (de_msg[ v3x_index[1] ]),
	.v10 (de_msg[ v2x_index[0] ]),
	.v11 (de_msg[ v2x_index[1] ])
);

// Minimum of 2nd-step M42
assign min_1_index = (third_step_min_index[0] == 0) ? v3x_index[0] :
					  (third_step_min_index[0] == 1) ? v3x_index[1] :
					  (third_step_min_index[0] == 2) ? v2x_index[0] : v2x_index[1];
// Second minimum of 2nd-step M42
assign min_2_index = (third_step_min_index[1] == 0) ? v3x_index[0] :
					  (third_step_min_index[1] == 1) ? v3x_index[1] :
					  (third_step_min_index[1] == 2) ? v2x_index[0] : v2x_index[1];

assign m1 = de_msg[ min_1_index ];
assign m2 = de_msg[ min_2_index ];
endmodule