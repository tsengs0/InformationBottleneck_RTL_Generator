module m42 #(parameter QUAN_SIZE = 3)(
	output wire [QUAN_SIZE-1:0] m1,
	output wire [QUAN_SIZE-1:0] m2,
	output wire [1:0] min_index, // argmin(v00, v01, v10, v11)
	output wire [1:0] second_min_index,

	input wire [QUAN_SIZE-1:0] v00,
	input wire [QUAN_SIZE-1:0] v01,
	input wire [QUAN_SIZE-1:0] v10,
	input wire [QUAN_SIZE-1:0] v11
);

wire min_sel_0;
leq #(
	.QUAN_SIZE (QUAN_SIZE)
) leq_u0(
	.dataA_le (min_sel_0),

	.dataInA (v00[QUAN_SIZE-1:0]),
	.dataInB (v10[QUAN_SIZE-1:0])
);
assign m1[QUAN_SIZE-1:0] = (min_sel_0 == 1'b0) ? v00[QUAN_SIZE-1:0] : v10[QUAN_SIZE-1:0];

wire [QUAN_SIZE-1:0] second_min_src0;
wire second_min_sel_0;
leq #(
	.QUAN_SIZE (QUAN_SIZE)
) leq_u1(
	.dataA_le (second_min_sel_0),

	.dataInA (v01[QUAN_SIZE-1:0]),
	.dataInB (v10[QUAN_SIZE-1:0])
);
assign second_min_src0[QUAN_SIZE-1:0] = (second_min_sel_0 == 1'b0) ? v01[QUAN_SIZE-1:0] : v10[QUAN_SIZE-1:0];

wire [QUAN_SIZE-1:0] second_min_src1;
wire second_min_sel_1;
leq #(
	.QUAN_SIZE (QUAN_SIZE)
) leq_u2(
	.dataA_le (second_min_sel_1),

	.dataInA (v00[QUAN_SIZE-1:0]),
	.dataInB (v11[QUAN_SIZE-1:0])
);
assign second_min_src1[QUAN_SIZE-1:0] = (second_min_sel_1 == 1'b0) ? v00[QUAN_SIZE-1:0] : v11[QUAN_SIZE-1:0];


assign m2[QUAN_SIZE-1:0] = (min_sel_0 == 1'b0) ? second_min_src0[QUAN_SIZE-1:0] : second_min_src1[QUAN_SIZE-1:0];
assign min_index[1:0] = {min_sel_0, 1'b0};
assign second_min_index[1] = (second_min_sel_0 && ~min_sel_0) || (second_min_sel_1 && min_sel_0) || (~second_min_sel_0 && min_sel_0);
assign second_min_index[0] = (~second_min_sel_0) || (second_min_sel_1 && min_sel_0);
endmodule

module partial_m42 #(parameter QUAN_SIZE = 3)(
	output wire [QUAN_SIZE-1:0] m1,
	output wire [QUAN_SIZE-1:0] m2,
	output wire [1:0] is_min_0_in,
	output wire [1:0] is_min_1_in,

	input wire [QUAN_SIZE-1:0] v00,
	input wire [QUAN_SIZE-1:0] v01,
	input wire [QUAN_SIZE-1:0] v10,
	input wire [QUAN_SIZE-1:0] v11
);

wire min_sel_0;
leq #(
	.QUAN_SIZE (QUAN_SIZE)
) leq_u0(
	.dataA_le (min_sel_0),

	.dataInA (v00[QUAN_SIZE-1:0]),
	.dataInB (v10[QUAN_SIZE-1:0])
);
assign m1[QUAN_SIZE-1:0] = (min_sel_0 == 1'b0) ? v00[QUAN_SIZE-1:0] : v10[QUAN_SIZE-1:0];

wire [QUAN_SIZE-1:0] second_min_src0;
wire second_min_sel_0;
leq #(
	.QUAN_SIZE (QUAN_SIZE)
) leq_u1(
	.dataA_le (second_min_sel_0),

	.dataInA (v01[QUAN_SIZE-1:0]),
	.dataInB (v10[QUAN_SIZE-1:0])
);
assign second_min_src0[QUAN_SIZE-1:0] = (second_min_sel_0 == 1'b0) ? v01[QUAN_SIZE-1:0] : v10[QUAN_SIZE-1:0];

wire [QUAN_SIZE-1:0] second_min_src1;
wire second_min_sel_1;
leq #(
	.QUAN_SIZE (QUAN_SIZE)
) leq_u2(
	.dataA_le (second_min_sel_1),

	.dataInA (v00[QUAN_SIZE-1:0]),
	.dataInB (v11[QUAN_SIZE-1:0])
);
assign second_min_src1[QUAN_SIZE-1:0] = (second_min_sel_1 == 1'b0) ? v00[QUAN_SIZE-1:0] : v11[QUAN_SIZE-1:0];
assign m2[QUAN_SIZE-1:0] = (min_sel_0 == 1'b0) ? second_min_src0[QUAN_SIZE-1:0] : second_min_src1[QUAN_SIZE-1:0];

assign is_min_0_in[1:0] = {min_sel_0, ~min_sel_0};
assign is_min_1_in[1:0] = (min_sel_0 == 1'b0 && second_min_sel_0 == 1'b0) ? 2'b01 :
						  (min_sel_0 == 1'b0 && second_min_sel_0 == 1'b1) ? 2'b10 :
						  (min_sel_0 == 1'b1 && second_min_sel_1 == 1'b0) ? 2'b01 :
						  (min_sel_0 == 1'b1 && second_min_sel_1 == 1'b1) ? 2'b10 : 0;
endmodule