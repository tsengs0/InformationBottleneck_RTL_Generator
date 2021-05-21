//`include "define.v"

module opt_cnu_min_8 #(
	parameter CN_DEGREE = 8,
	parameter QUAN_SIZE = 4,
	parameter alpha_2 = 2, // 0.25 -> x >> 2
	parameter gamma   = 1  // 0.50 -> x >> 1 
)(
	output [QUAN_SIZE-1:0] m1,
	output [QUAN_SIZE-1:0] m2,
	output [2:0]           min_index,

	input [QUAN_SIZE-1:0] de_msg_0,
	input [QUAN_SIZE-1:0] de_msg_1,
	input [QUAN_SIZE-1:0] de_msg_2,
	input [QUAN_SIZE-1:0] de_msg_3,
	input [QUAN_SIZE-1:0] de_msg_4,
	input [QUAN_SIZE-1:0] de_msg_5,
	input [QUAN_SIZE-1:0] de_msg_6,
	input [QUAN_SIZE-1:0] de_msg_7
);

wire [QUAN_SIZE-1:0] min_1, min_2_prime;
wire [QUAN_SIZE-1:0] de_msg [0:CN_DEGREE-1];
assign de_msg[0] = de_msg_0;
assign de_msg[1] = de_msg_1;
assign de_msg[2] = de_msg_2;
assign de_msg[3] = de_msg_3;
assign de_msg[4] = de_msg_4;
assign de_msg[5] = de_msg_5;
assign de_msg[6] = de_msg_6;
assign de_msg[7] = de_msg_7;

function integer log2;
   input integer value;
   begin
     value = value-1;
     for (log2=0; value>0; log2=log2+1)
       value = value>>1;
   end
endfunction

function integer m21_num;
	input integer dc;
	begin
	m21_num = 0;
		for(dc=CN_DEGREE/2; dc>1; dc=dc/2)
			m21_num = m21_num + dc;
	end
endfunction

wire [QUAN_SIZE-1:0] inner_min [0:m21_num(CN_DEGREE)-1];
wire index_sel [0:m21_num(CN_DEGREE)];
genvar j;
localparam temp = CN_DEGREE >> 1;
generate
	for(j = 0; j < temp; j=j+1) begin : instantiate_cnu_proc
		m21 #() u0 (
			.m1 (inner_min[j]),
			.min_index (index_sel[j]),	

			.v1 (de_msg[j*2]),
			.v2 (de_msg[j*2+1])
		);
	end
endgenerate

m21 #() inner_min0 (
	.m1 (inner_min[4]),
	.min_index (index_sel[4]),

	.v1 (inner_min[0]),
	.v2 (inner_min[1])
);
	
m21 #() inner_min1 (
	.m1 (inner_min[5]),
	.min_index (index_sel[5]),

	.v1 (inner_min[2]),
	.v2 (inner_min[3])
);

m22 #() out_min (
	.m1 (min_1[QUAN_SIZE-1:0]),
	.m2 (min_2_prime[QUAN_SIZE-1:0]),
	.min_index (index_sel[6]),

	.v1 (inner_min[4]),
	.v2 (inner_min[5])
);

// min1 = min_1 * alpha_2
// min2 = min_1 * alpha_2 + min_2_prime * gamma
wire [QUAN_SIZE-1:0] m1_wire;
assign m1_wire = {{alpha_2{1'b0}}, min_1[QUAN_SIZE-1-alpha_2:0]};
assign m1 = m1_wire;
assign m2 = m1_wire + {{gamma{1'b0}}, min_2_prime[QUAN_SIZE-1-gamma:0]}; 

wire [2:0] index_gen [0:7];
assign index_gen[0] = 3'b000;
assign index_gen[1] = 3'b001;
assign index_gen[2] = 3'b010;
assign index_gen[3] = 3'b011;
assign index_gen[4] = 3'b100;
assign index_gen[5] = 3'b101;
assign index_gen[6] = 3'b110;
assign index_gen[7] = 3'b111;

wire [2:0] index [0:m21_num(CN_DEGREE)-1];
// First-stage index multiplexers
assign index[0] = (index_sel[0] == 1'b0) ? index_gen[0] : index_gen[1];
assign index[1] = (index_sel[1] == 1'b0) ? index_gen[2] : index_gen[3];
assign index[2] = (index_sel[2] == 1'b0) ? index_gen[4] : index_gen[5];
assign index[3] = (index_sel[3] == 1'b0) ? index_gen[6] : index_gen[7];

// Second-stage index multiplexers
assign index[4] = (index_sel[4] == 1'b0) ? index[0] : index[1];
assign index[5] = (index_sel[5] == 1'b0) ? index[2] : index[3];

// Third-stage index multiplexer
assign min_index = (index_sel[6] == 1'b0) ? index[4] : index[5];

endmodule
