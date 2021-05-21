//`default_nettype none
`define IB_SIM
`define BASE_MIN
`ifdef IB_SIM
module cnu_6 #(
	parameter CN_DEGREE = 6,
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

	input wire [QUAN_SIZE-1:0] var_to_ch_0,
	input wire [QUAN_SIZE-1:0] var_to_ch_1,
	input wire [QUAN_SIZE-1:0] var_to_ch_2,
	input wire [QUAN_SIZE-1:0] var_to_ch_3,
	input wire [QUAN_SIZE-1:0] var_to_ch_4,
	input wire [QUAN_SIZE-1:0] var_to_ch_5,

	input sys_clk,
	input rstn
);

localparam MIN_INDEX_BITWIDTH = $clog2(CN_DEGREE);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
wire [CN_DEGREE-1:0] Q_signs;
wire [MAG_SIZE-1:0] Q_mag [0:CN_DEGREE-1];

// Product-Sign
assign Q_signs[0] = var_to_ch_1[QUAN_SIZE-1]^var_to_ch_2[QUAN_SIZE-1]^var_to_ch_3[QUAN_SIZE-1]^var_to_ch_4[QUAN_SIZE-1]^var_to_ch_5[QUAN_SIZE-1];
assign Q_signs[1] = var_to_ch_0[QUAN_SIZE-1]^var_to_ch_2[QUAN_SIZE-1]^var_to_ch_3[QUAN_SIZE-1]^var_to_ch_4[QUAN_SIZE-1]^var_to_ch_5[QUAN_SIZE-1];
assign Q_signs[2] = var_to_ch_0[QUAN_SIZE-1]^var_to_ch_1[QUAN_SIZE-1]^var_to_ch_3[QUAN_SIZE-1]^var_to_ch_4[QUAN_SIZE-1]^var_to_ch_5[QUAN_SIZE-1];
assign Q_signs[3] = var_to_ch_0[QUAN_SIZE-1]^var_to_ch_1[QUAN_SIZE-1]^var_to_ch_2[QUAN_SIZE-1]^var_to_ch_4[QUAN_SIZE-1]^var_to_ch_5[QUAN_SIZE-1];
assign Q_signs[4] = var_to_ch_0[QUAN_SIZE-1]^var_to_ch_1[QUAN_SIZE-1]^var_to_ch_2[QUAN_SIZE-1]^var_to_ch_3[QUAN_SIZE-1]^var_to_ch_5[QUAN_SIZE-1];
assign Q_signs[5] = var_to_ch_0[QUAN_SIZE-1]^var_to_ch_1[QUAN_SIZE-1]^var_to_ch_2[QUAN_SIZE-1]^var_to_ch_3[QUAN_SIZE-1]^var_to_ch_4[QUAN_SIZE-1];

// vector of magnitude of all var-to-ch messages
assign Q_mag[0] = (var_to_ch_0[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_0[MAG_SIZE-1:0] : var_to_ch_0[MAG_SIZE-1:0];
assign Q_mag[1] = (var_to_ch_1[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_1[MAG_SIZE-1:0] : var_to_ch_1[MAG_SIZE-1:0];
assign Q_mag[2] = (var_to_ch_2[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_2[MAG_SIZE-1:0] : var_to_ch_2[MAG_SIZE-1:0];
assign Q_mag[3] = (var_to_ch_3[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_3[MAG_SIZE-1:0] : var_to_ch_3[MAG_SIZE-1:0];
assign Q_mag[4] = (var_to_ch_4[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_4[MAG_SIZE-1:0] : var_to_ch_4[MAG_SIZE-1:0];
assign Q_mag[5] = (var_to_ch_5[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_5[MAG_SIZE-1:0] : var_to_ch_5[MAG_SIZE-1:0];
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pipeline Stage 0
wire [MIN_INDEX_BITWIDTH-1:0] min_index [0:1];
reg [MAG_SIZE-1:0] de_msg_pipe0 [0:CN_DEGREE-1];
genvar de_i;
generate
	for(de_i=0;de_i<CN_DEGREE;de_i=de_i+1) begin : de_msg_pipe0_inst
		always @(posedge sys_clk) begin
			if(rstn == 1'b0) de_msg_pipe0[de_i] <= {MAG_SIZE{1'bx}};
			else de_msg_pipe0[de_i] <= Q_mag[de_i];
		end
	end
endgenerate

`ifdef BASE_MIN
base_cnu_min_6 #(
`else
opt_cnu_min_6 #(
`endif
	.CN_DEGREE (CN_DEGREE),
	.QUAN_SIZE (MAG_SIZE),
	.MIN_INDEX_BITWIDTH (MIN_INDEX_BITWIDTH)
) u0( 
	//.m1 (m1_base[MAG_SIZE-1:0]),
	//.m2 (m2_base[MAG_SIZE-1:0]),
	.min_1_index (min_index[0]),
	.min_2_index (min_index[1]),

	.de_msg_0 (de_msg_pipe0[0]),
	.de_msg_1 (de_msg_pipe0[1]),
	.de_msg_2 (de_msg_pipe0[2]),
	.de_msg_3 (de_msg_pipe0[3]),
	.de_msg_4 (de_msg_pipe0[4]),
	.de_msg_5 (de_msg_pipe0[5])
);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pipeline Stage 1
reg [MAG_SIZE-1:0] de_msg_pipe1 [0:CN_DEGREE-1];
generate
	for(de_i=0;de_i<CN_DEGREE;de_i=de_i+1) begin : de_msg_pipe1_inst
		always @(posedge sys_clk) begin
			if(rstn == 1'b0) de_msg_pipe1[de_i] <= {MAG_SIZE{1'bx}};
			else de_msg_pipe1[de_i] <= de_msg_pipe0[de_i];
		end
	end
endgenerate

// Minimum magnitude
reg [MIN_INDEX_BITWIDTH-1:0] min1_index_pipe1; initial min1_index_pipe1 <= 0;
always @(posedge sys_clk) begin
	if(rstn == 1'b0) min1_index_pipe1 <= 0;
	else min1_index_pipe1[MIN_INDEX_BITWIDTH-1:0] <= min_index[0];
end

reg [MAG_SIZE-1:0] m1_base; initial m1_base <= 0;
always @(posedge sys_clk) begin
	if(rstn == 1'b0) m1_base <= 0;
	else m1_base[MAG_SIZE-1:0] <= de_msg_pipe1[ min_index[0] ];
end
// Second minimum magnitude
reg [MAG_SIZE-1:0] m2_base; initial m2_base <= 0;
always @(posedge sys_clk) begin
	if(rstn == 1'b0) m2_base <= 0;
	else m2_base[MAG_SIZE-1:0] <= de_msg_pipe1[ min_index[1] ];
end

wire [MAG_SIZE-1:0] m1;
wire [MAG_SIZE-1:0] m2;
`ifdef BASE_MIN
assign m1 = m1_base[MAG_SIZE-1:0];
assign m2 = m2_base[MAG_SIZE-1:0];
`else
// min1 = min_1 * alpha_2
// min2 = min_1 * alpha_2 + min_2_prime * gamma
wire [MAG_SIZE-1:0] m1_wire;
wire [MAG_SIZE:0] m2_wire;
assign m1_wire = {{alpha_2{1'b0}}, m1_base[MAG_SIZE-1:alpha_2]};
assign m1 = m1_wire;
assign m2_wire = m1_wire + {{gamma{1'b0}}, m2_base[MAG_SIZE-1:gamma]}; 
assign m2 = (m2_wire[MAG_SIZE] == 1'b1) ? {MAG_SIZE{1'b1}} : m2_wire[MAG_SIZE-1:0];
`endif
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pipeline Stage 2
always @(posedge sys_clk) begin
	if(rstn == 1'b0) begin
		ch_to_var_0[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
		ch_to_var_1[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
		ch_to_var_2[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
		ch_to_var_3[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
		ch_to_var_4[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
		ch_to_var_5[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
	end
	else begin
		case(min1_index_pipe1[MIN_INDEX_BITWIDTH-1:0])
			3'b000: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs[0], (m2[MAG_SIZE-1:0])^(~Q_signs[0])};
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs[1], (m1[MAG_SIZE-1:0])^(~Q_signs[1])};
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs[2], (m1[MAG_SIZE-1:0])^(~Q_signs[2])};
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs[3], (m1[MAG_SIZE-1:0])^(~Q_signs[3])};
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs[4], (m1[MAG_SIZE-1:0])^(~Q_signs[4])};
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs[5], (m1[MAG_SIZE-1:0])^(~Q_signs[5])};
			end
			3'b001: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs[0], (m1[MAG_SIZE-1:0])^(~Q_signs[0])};
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs[1], (m2[MAG_SIZE-1:0])^(~Q_signs[1])};
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs[2], (m1[MAG_SIZE-1:0])^(~Q_signs[2])};
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs[3], (m1[MAG_SIZE-1:0])^(~Q_signs[3])};
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs[4], (m1[MAG_SIZE-1:0])^(~Q_signs[4])};
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs[5], (m1[MAG_SIZE-1:0])^(~Q_signs[5])};
			end
			3'b010: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs[0], (m1[MAG_SIZE-1:0])^(~Q_signs[0])};
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs[1], (m1[MAG_SIZE-1:0])^(~Q_signs[1])};
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs[2], (m2[MAG_SIZE-1:0])^(~Q_signs[2])};
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs[3], (m1[MAG_SIZE-1:0])^(~Q_signs[3])};
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs[4], (m1[MAG_SIZE-1:0])^(~Q_signs[4])};
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs[5], (m1[MAG_SIZE-1:0])^(~Q_signs[5])};
			end
			3'b011: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs[0], (m1[MAG_SIZE-1:0])^(~Q_signs[0])};
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs[1], (m1[MAG_SIZE-1:0])^(~Q_signs[1])};
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs[2], (m1[MAG_SIZE-1:0])^(~Q_signs[2])};
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs[3], (m2[MAG_SIZE-1:0])^(~Q_signs[3])};
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs[4], (m1[MAG_SIZE-1:0])^(~Q_signs[4])};
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs[5], (m1[MAG_SIZE-1:0])^(~Q_signs[5])};
			end
			3'b100: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs[0], (m1[MAG_SIZE-1:0])^(~Q_signs[0])};
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs[1], (m1[MAG_SIZE-1:0])^(~Q_signs[1])};
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs[2], (m1[MAG_SIZE-1:0])^(~Q_signs[2])};
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs[3], (m1[MAG_SIZE-1:0])^(~Q_signs[3])};
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs[4], (m2[MAG_SIZE-1:0])^(~Q_signs[4])};
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs[5], (m1[MAG_SIZE-1:0])^(~Q_signs[5])};
			end
			3'b101: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {Q_signs[0], (m1[MAG_SIZE-1:0])^(~Q_signs[0])};
				ch_to_var_1[QUAN_SIZE-1:0] <= {Q_signs[1], (m1[MAG_SIZE-1:0])^(~Q_signs[1])};
				ch_to_var_2[QUAN_SIZE-1:0] <= {Q_signs[2], (m1[MAG_SIZE-1:0])^(~Q_signs[2])};
				ch_to_var_3[QUAN_SIZE-1:0] <= {Q_signs[3], (m1[MAG_SIZE-1:0])^(~Q_signs[3])};
				ch_to_var_4[QUAN_SIZE-1:0] <= {Q_signs[4], (m1[MAG_SIZE-1:0])^(~Q_signs[4])};
				ch_to_var_5[QUAN_SIZE-1:0] <= {Q_signs[5], (m2[MAG_SIZE-1:0])^(~Q_signs[5])};
			end
			default: begin
				ch_to_var_0[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
				ch_to_var_1[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
				ch_to_var_2[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
				ch_to_var_3[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
				ch_to_var_4[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
				ch_to_var_5[QUAN_SIZE-1:0] <= {QUAN_SIZE{1'bx}};		
			end
		endcase
	end
end
endmodule
`else
module cnu_6 #(
	parameter CN_DEGREE = 6,
	parameter QUAN_SIZE = 4,
	parameter MAG_SIZE = 3
) (
	output wire [QUAN_SIZE-1:0] ch_to_var_0,
	output wire [QUAN_SIZE-1:0] ch_to_var_1,
	output wire [QUAN_SIZE-1:0] ch_to_var_2,
	output wire [QUAN_SIZE-1:0] ch_to_var_3,
	output wire [QUAN_SIZE-1:0] ch_to_var_4,
	output wire [QUAN_SIZE-1:0] ch_to_var_5,

	input wire [QUAN_SIZE-1:0] var_to_ch_0,
	input wire [QUAN_SIZE-1:0] var_to_ch_1,
	input wire [QUAN_SIZE-1:0] var_to_ch_2,
	input wire [QUAN_SIZE-1:0] var_to_ch_3,
	input wire [QUAN_SIZE-1:0] var_to_ch_4,
	input wire [QUAN_SIZE-1:0] var_to_ch_5,

	input sys_clk,
	input rstn,
	input wire en // enable-control signal
);

reg signed [`QUAN_SIZE-1:0] min_sum [0:`CN_DEGREE-1];
wire [`CN_DEGREE-1:0] Q_signs;

// Product-Sign
assign Q_signs[0] = var_to_ch_1[`QUAN_SIZE-1]^var_to_ch_2[`QUAN_SIZE-1]^var_to_ch_3[`QUAN_SIZE-1]^var_to_ch_4[`QUAN_SIZE-1]^var_to_ch_5[`QUAN_SIZE-1];
assign Q_signs[1] = var_to_ch_0[`QUAN_SIZE-1]^var_to_ch_2[`QUAN_SIZE-1]^var_to_ch_3[`QUAN_SIZE-1]^var_to_ch_4[`QUAN_SIZE-1]^var_to_ch_5[`QUAN_SIZE-1];
assign Q_signs[2] = var_to_ch_0[`QUAN_SIZE-1]^var_to_ch_1[`QUAN_SIZE-1]^var_to_ch_3[`QUAN_SIZE-1]^var_to_ch_4[`QUAN_SIZE-1]^var_to_ch_5[`QUAN_SIZE-1];
assign Q_signs[3] = var_to_ch_0[`QUAN_SIZE-1]^var_to_ch_1[`QUAN_SIZE-1]^var_to_ch_2[`QUAN_SIZE-1]^var_to_ch_4[`QUAN_SIZE-1]^var_to_ch_5[`QUAN_SIZE-1];
assign Q_signs[4] = var_to_ch_0[`QUAN_SIZE-1]^var_to_ch_1[`QUAN_SIZE-1]^var_to_ch_2[`QUAN_SIZE-1]^var_to_ch_3[`QUAN_SIZE-1]^var_to_ch_5[`QUAN_SIZE-1];
assign Q_signs[5] = var_to_ch_0[`QUAN_SIZE-1]^var_to_ch_1[`QUAN_SIZE-1]^var_to_ch_2[`QUAN_SIZE-1]^var_to_ch_3[`QUAN_SIZE-1]^var_to_ch_4[`QUAN_SIZE-1];

localparam MIN_INDEX_BITWIDTH = $clog2(CN_DEGREE);
wire [MAG_SIZE-1:0] m1;
wire [MAG_SIZE-1:0] m2;
wire [MIN_INDEX_BITWIDTH-1:0] min_index;

reg [`QUAN_SIZE-2:0] de_msg_0;
reg [`QUAN_SIZE-2:0] de_msg_1;
reg [`QUAN_SIZE-2:0] de_msg_2;
reg [`QUAN_SIZE-2:0] de_msg_3;
reg [`QUAN_SIZE-2:0] de_msg_4;
reg [`QUAN_SIZE-2:0] de_msg_5;
opt_cnu_min_6 #(
	.CN_DEGREE (CN_DEGREE),
	.QUAN_SIZE (MAG_SIZE),
	.alpha_2   (2), // 0.25 -> x >> 2
	.gamma     (3)  // 0.50 -> x >> 1 
) u0( 
	.m1 (m1[MAG_SIZE-1:0]),
	.m2 (m2[MAG_SIZE-1:0]),
	.min_index (min_index[MIN_INDEX_BITWIDTH-1:0]),

	.de_msg_0 (de_msg_0[MAG_SIZE-1:0]),
	.de_msg_1 (de_msg_1[MAG_SIZE-1:0]),
	.de_msg_2 (de_msg_2[MAG_SIZE-1:0]),
	.de_msg_3 (de_msg_3[MAG_SIZE-1:0]),
	.de_msg_4 (de_msg_4[MAG_SIZE-1:0]),
	.de_msg_5 (de_msg_5[MAG_SIZE-1:0])
);

always @(posedge sys_clk) begin
	if(rstn == 1'b0) begin
		de_msg_0[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};
		de_msg_1[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};
		de_msg_2[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};
		de_msg_3[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};
		de_msg_4[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};
		de_msg_5[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};
	end
	else if(en == 1'b1) begin
		de_msg_0[MAG_SIZE-1:0] <= var_to_ch_0[MAG_SIZE-1:0];
		de_msg_1[MAG_SIZE-1:0] <= var_to_ch_1[MAG_SIZE-1:0];
		de_msg_2[MAG_SIZE-1:0] <= var_to_ch_2[MAG_SIZE-1:0];
		de_msg_3[MAG_SIZE-1:0] <= var_to_ch_3[MAG_SIZE-1:0];
		de_msg_4[MAG_SIZE-1:0] <= var_to_ch_4[MAG_SIZE-1:0];
		de_msg_5[MAG_SIZE-1:0] <= var_to_ch_5[MAG_SIZE-1:0];
	end
	else begin
		de_msg_0[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};
		de_msg_1[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};
		de_msg_2[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};
		de_msg_3[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};
		de_msg_4[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};
		de_msg_5[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};
	end
end

always @(posedge sys_clk) begin
	if(rstn == 1'b0) begin
		ch_to_var_0[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
		ch_to_var_1[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
		ch_to_var_2[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
		ch_to_var_3[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
		ch_to_var_4[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
		ch_to_var_5[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
	end
	else if(en == 1'b1) begin
		case(min_index[MIN_INDEX_BITWIDTH-1:0])
			3'b000: begin
				ch_to_var_0[MAG_SIZE-1:0] <= (Q_signs[0] == 1'b1) ? ~m2[MAG_SIZE-1:0] + 1'b1 : m2[MAG_SIZE-1-1:0];
				ch_to_var_1[MAG_SIZE-1:0] <= (Q_signs[1] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1-1:0];
				ch_to_var_2[MAG_SIZE-1:0] <= (Q_signs[2] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1-1:0];
				ch_to_var_3[MAG_SIZE-1:0] <= (Q_signs[3] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1-1:0];
				ch_to_var_4[MAG_SIZE-1:0] <= (Q_signs[4] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1-1:0];
				ch_to_var_5[MAG_SIZE-1:0] <= (Q_signs[5] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1-1:0];
			end
			3'b001: begin
				ch_to_var_0[MAG_SIZE-1:0] <= (Q_signs[0] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_1[MAG_SIZE-1:0] <= (Q_signs[1] == 1'b1) ? ~m2[MAG_SIZE-1:0] + 1'b1 : m2[MAG_SIZE-1:0];
				ch_to_var_2[MAG_SIZE-1:0] <= (Q_signs[2] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_3[MAG_SIZE-1:0] <= (Q_signs[3] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_4[MAG_SIZE-1:0] <= (Q_signs[4] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_5[MAG_SIZE-1:0] <= (Q_signs[5] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
			end
			3'b010: begin
				ch_to_var_0[MAG_SIZE-1:0] <= (Q_signs[0] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_1[MAG_SIZE-1:0] <= (Q_signs[1] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_2[MAG_SIZE-1:0] <= (Q_signs[2] == 1'b1) ? ~m2[MAG_SIZE-1:0] + 1'b1 : m2[MAG_SIZE-1:0];
				ch_to_var_3[MAG_SIZE-1:0] <= (Q_signs[3] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_4[MAG_SIZE-1:0] <= (Q_signs[4] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_5[MAG_SIZE-1:0] <= (Q_signs[5] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
			end
			3'b011: begin
				ch_to_var_0[MAG_SIZE-1:0] <= (Q_signs[0] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_1[MAG_SIZE-1:0] <= (Q_signs[1] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_2[MAG_SIZE-1:0] <= (Q_signs[2] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_3[MAG_SIZE-1:0] <= (Q_signs[3] == 1'b1) ? ~m2[MAG_SIZE-1:0] + 1'b1 : m2[MAG_SIZE-1:0];
				ch_to_var_4[MAG_SIZE-1:0] <= (Q_signs[4] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_5[MAG_SIZE-1:0] <= (Q_signs[5] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
			end
			3'b100: begin
				ch_to_var_0[MAG_SIZE-1:0] <= (Q_signs[0] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_1[MAG_SIZE-1:0] <= (Q_signs[1] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_2[MAG_SIZE-1:0] <= (Q_signs[2] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_3[MAG_SIZE-1:0] <= (Q_signs[3] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_4[MAG_SIZE-1:0] <= (Q_signs[4] == 1'b1) ? ~m2[MAG_SIZE-1:0] + 1'b1 : m2[MAG_SIZE-1:0];
				ch_to_var_5[MAG_SIZE-1:0] <= (Q_signs[5] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
			end
			3'b101: begin
				ch_to_var_0[MAG_SIZE-1:0] <= (Q_signs[0] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_1[MAG_SIZE-1:0] <= (Q_signs[1] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_2[MAG_SIZE-1:0] <= (Q_signs[2] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_3[MAG_SIZE-1:0] <= (Q_signs[3] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_4[MAG_SIZE-1:0] <= (Q_signs[4] == 1'b1) ? ~m1[MAG_SIZE-1:0] + 1'b1 : m1[MAG_SIZE-1:0];
				ch_to_var_5[MAG_SIZE-1:0] <= (Q_signs[5] == 1'b1) ? ~m2[MAG_SIZE-1:0] + 1'b1 : m2[MAG_SIZE-1:0];
			end
			default: begin
				ch_to_var_0[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
				ch_to_var_1[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
				ch_to_var_2[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
				ch_to_var_3[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
				ch_to_var_4[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
				ch_to_var_5[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
			end
		endcase
	end
	else begin
		ch_to_var_0[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
		ch_to_var_1[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
		ch_to_var_2[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
		ch_to_var_3[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
		ch_to_var_4[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
		ch_to_var_5[MAG_SIZE-1:0] <= {MAG_SIZE{1'bx}};		
	end
end
always @(posedge sys_clk) begin
	if(rstn == 1'b0) begin
		ch_to_var_0[QUAN_SIZE-1] <= 1'bx;
		ch_to_var_1[QUAN_SIZE-1] <= 1'bx;
		ch_to_var_2[QUAN_SIZE-1] <= 1'bx;
		ch_to_var_3[QUAN_SIZE-1] <= 1'bx;
		ch_to_var_4[QUAN_SIZE-1] <= 1'bx;
		ch_to_var_5[QUAN_SIZE-1] <= 1'bx;
	end
	else if(en == 1'b1) begin
		ch_to_var_0[QUAN_SIZE-1] <= Q_signs[0];
		ch_to_var_1[QUAN_SIZE-1] <= Q_signs[1];
		ch_to_var_2[QUAN_SIZE-1] <= Q_signs[2];
		ch_to_var_3[QUAN_SIZE-1] <= Q_signs[3];
		ch_to_var_4[QUAN_SIZE-1] <= Q_signs[4];
		ch_to_var_5[QUAN_SIZE-1] <= Q_signs[5];
	end
	else begin
		ch_to_var_0[QUAN_SIZE-1] <= 1'bx;
		ch_to_var_1[QUAN_SIZE-1] <= 1'bx;
		ch_to_var_2[QUAN_SIZE-1] <= 1'bx;
		ch_to_var_3[QUAN_SIZE-1] <= 1'bx;
		ch_to_var_4[QUAN_SIZE-1] <= 1'bx;
		ch_to_var_5[QUAN_SIZE-1] <= 1'bx;
	end
end
endmodule
`endif