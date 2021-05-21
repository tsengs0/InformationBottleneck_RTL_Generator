module m21 #(parameter QUAN_SIZE = 3)(
	output [QUAN_SIZE-1:0] m1, 		
	output min_index, // argmin(v0, v1)

	input wire [QUAN_SIZE-1:0] v0,
	input wire [QUAN_SIZE-1:0] v1
);

wire min_sel;
leq #(
	.QUAN_SIZE (QUAN_SIZE)
) leq_u0(
	.dataA_le (min_sel),

	.dataInA (v0[QUAN_SIZE-1:0]),
	.dataInB (v1[QUAN_SIZE-1:0])
);
assign m1[QUAN_SIZE-1:0] = (min_sel == 1'b0) ? v0[QUAN_SIZE-1:0] : v1[QUAN_SIZE-1:0];
assign min_index = min_sel;
endmodule