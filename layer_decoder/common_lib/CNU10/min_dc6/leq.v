module leq #(
	parameter QUAN_SIZE = 3
) (
	output wire dataA_le, // '0' if A <= B, otherwise '1'

	input wire [QUAN_SIZE-1:0] dataInA,
	input wire [QUAN_SIZE-1:0] dataInB
);

wire [QUAN_SIZE-1:0] A;
wire [QUAN_SIZE-1:0] B;
assign A[QUAN_SIZE-1:0] = dataInA[QUAN_SIZE-1:0];
assign B[QUAN_SIZE-1:0] = dataInB[QUAN_SIZE-1:0];
assign dataA_le = (A[2] && ~B[2]) || ((~(A[2]^B[2])) && (A[1] && ~B[1])) || ((~(A[2]^B[2])) && (~(A[1]^B[1])) && (A[0] && ~B[0]));
endmodule