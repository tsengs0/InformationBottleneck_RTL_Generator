module opt_cnu_min_6 #(
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

wire [QUAN_SIZE-1:0] min_1, min_2_prime;
wire [QUAN_SIZE-1:0] de_msg [0:CN_DEGREE-1];
assign de_msg[0] = de_msg_0[QUAN_SIZE-1:0];
assign de_msg[1] = de_msg_1[QUAN_SIZE-1:0];
assign de_msg[2] = de_msg_2[QUAN_SIZE-1:0];
assign de_msg[3] = de_msg_3[QUAN_SIZE-1:0];
assign de_msg[4] = de_msg_4[QUAN_SIZE-1:0];
assign de_msg[5] = de_msg_5[QUAN_SIZE-1:0];
/*
function integer log2;
   input integer value;
   begin
     value = value-1;
     for (log2=0; value>0; log2=log2+1)
       value = value>>1;
   end
endfunction
*/
function integer m21_num;
	input integer dc;
	begin
	m21_num = 0;
		for(dc=CN_DEGREE/2; dc>=1; dc=dc/2)
			m21_num = m21_num + dc;
	end
endfunction

wire [QUAN_SIZE-1:0] inner_min [0:m21_num(CN_DEGREE)-1];
wire index_sel [0:m21_num(CN_DEGREE)];
genvar j;
localparam M21_NUM = CN_DEGREE >> 1;
generate
	for(j = 0; j < M21_NUM; j=j+1) begin : instantiate_cnu_proc
		m21 #(.QUAN_SIZE(QUAN_SIZE)) u0 (
			.m1 (inner_min[j]),
			.min_index (index_sel[j]),	

			.v0 (de_msg[j*2]),
			.v1 (de_msg[j*2+1])
		);
	end
endgenerate

m21 #(.QUAN_SIZE(QUAN_SIZE)) inner_min0 (
	.m1 (inner_min[3]),
	.min_index (index_sel[3]),

	.v0 (inner_min[0]),
	.v1 (inner_min[1])
);
	
m22 #(.QUAN_SIZE(QUAN_SIZE)) out_min (
	.m1 (min_1[QUAN_SIZE-1:0]),
	.m2 (min_2_prime[QUAN_SIZE-1:0]),
	.min_index (index_sel[4]),

	.v0 (inner_min[3]),
	.v1 (inner_min[2])
);

wire [MIN_INDEX_BITWIDTH-1:0] index_gen [0:CN_DEGREE-1];
genvar i;
generate
	for(i=0;i<CN_DEGREE;i=i+1) begin : index_gen_inst
		assign index_gen[i] = i;
	end
endgenerate

wire [MIN_INDEX_BITWIDTH:0] index [0:m21_num(CN_DEGREE)-1];
// First-stage index multiplexers
assign index[0] = (index_sel[0] == 1'b0) ? index_gen[0] : index_gen[1];
assign index[1] = (index_sel[1] == 1'b0) ? index_gen[2] : index_gen[3];
assign index[2] = (index_sel[2] == 1'b0) ? index_gen[4] : index_gen[5];

// Second-stage index multiplexers
assign index[3] = (index_sel[3] == 1'b0) ? index[0] : index[1];

// Third-stage index multiplexer
assign min_1_index = (index_sel[4] == 1'b0) ? index[3] : index[2];
assign min_2_index = (index_sel[4] == 1'b0) ? index[2] : index[3];
endmodule