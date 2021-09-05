`include "define.vh"

module zero_shuffle_top_85b_singleBit #(
	parameter CHECK_PARALLELISM = 85,
	parameter BS_PIPELINE_LEVEL = 2
) (
	output wire [CHECK_PARALLELISM-1:0] sw_out_bit0,

	input wire sys_clk,
	input wire rstn,
	input wire [CHECK_PARALLELISM-1:0] sw_in_bit0
);

`ifdef SCHED_4_6
reg [CHECK_PARALLELISM-1:0] sw_out_bit0_pipe [0:BS_PIPELINE_LEVEL-1];
always @(posedge sys_clk) begin if(!rstn) sw_out_bit0_pipe[0] <= 0; else sw_out_bit0_pipe[0] <= sw_in_bit0[CHECK_PARALLELISM-1:0]; end

genvar bit_index;
generate
	for(bit_index=1;bit_index<BS_PIPELINE_LEVEL;bit_index=bit_index+1) begin : bit_zero_shuffle_inst
		always @(posedge sys_clk) begin if(!rstn) sw_out_bit0_pipe[bit_index] <= 0; else sw_out_bit0_pipe[bit_index] <= sw_out_bit0_pipe[bit_index-1]; end
	end
endgenerate
assign sw_out_bit0[CHECK_PARALLELISM-1:0] = sw_out_bit0_pipe[BS_PIPELINE_LEVEL-1];
`else
assign sw_out_bit0[CHECK_PARALLELISM-1:0] = sw_in_bit0[CHECK_PARALLELISM-1:0];
`endif
endmodule

module zero_shuffle_top_85b #(
	parameter CHECK_PARALLELISM = 85,
	parameter BS_PIPELINE_LEVEL = 2
) (
	output wire [CHECK_PARALLELISM-1:0] sw_out_bit0,
	output wire [CHECK_PARALLELISM-1:0] sw_out_bit1,
	output wire [CHECK_PARALLELISM-1:0] sw_out_bit2,
	output wire [CHECK_PARALLELISM-1:0] sw_out_bit3,

	input wire sys_clk,
	input wire rstn,
	input wire [CHECK_PARALLELISM-1:0] sw_in_bit0,
	input wire [CHECK_PARALLELISM-1:0] sw_in_bit1,
	input wire [CHECK_PARALLELISM-1:0] sw_in_bit2,
	input wire [CHECK_PARALLELISM-1:0] sw_in_bit3
);

`ifdef SCHED_4_6
reg [CHECK_PARALLELISM-1:0] sw_out_bit0_pipe [0:BS_PIPELINE_LEVEL-1];
reg [CHECK_PARALLELISM-1:0] sw_out_bit1_pipe [0:BS_PIPELINE_LEVEL-1];
reg [CHECK_PARALLELISM-1:0] sw_out_bit2_pipe [0:BS_PIPELINE_LEVEL-1];
reg [CHECK_PARALLELISM-1:0] sw_out_bit3_pipe [0:BS_PIPELINE_LEVEL-1];
always @(posedge sys_clk) begin if(!rstn) sw_out_bit0_pipe[0] <= 0; else sw_out_bit0_pipe[0] <= sw_in_bit0[CHECK_PARALLELISM-1:0]; end
always @(posedge sys_clk) begin if(!rstn) sw_out_bit1_pipe[0] <= 0; else sw_out_bit1_pipe[0] <= sw_in_bit1[CHECK_PARALLELISM-1:0]; end
always @(posedge sys_clk) begin if(!rstn) sw_out_bit2_pipe[0] <= 0; else sw_out_bit2_pipe[0] <= sw_in_bit2[CHECK_PARALLELISM-1:0]; end
always @(posedge sys_clk) begin if(!rstn) sw_out_bit3_pipe[0] <= 0; else sw_out_bit3_pipe[0] <= sw_in_bit3[CHECK_PARALLELISM-1:0]; end
genvar bit_index;
generate
	for(bit_index=1;bit_index<BS_PIPELINE_LEVEL;bit_index=bit_index+1) begin : bit_zero_shuffle_inst
		always @(posedge sys_clk) begin if(!rstn) sw_out_bit0_pipe[bit_index] <= 0; else sw_out_bit0_pipe[bit_index] <= sw_out_bit0_pipe[bit_index-1]; end
		always @(posedge sys_clk) begin if(!rstn) sw_out_bit1_pipe[bit_index] <= 0; else sw_out_bit1_pipe[bit_index] <= sw_out_bit1_pipe[bit_index-1]; end
		always @(posedge sys_clk) begin if(!rstn) sw_out_bit2_pipe[bit_index] <= 0; else sw_out_bit2_pipe[bit_index] <= sw_out_bit2_pipe[bit_index-1]; end
		always @(posedge sys_clk) begin if(!rstn) sw_out_bit3_pipe[bit_index] <= 0; else sw_out_bit3_pipe[bit_index] <= sw_out_bit3_pipe[bit_index-1]; end
	end
endgenerate
assign sw_out_bit0[CHECK_PARALLELISM-1:0] = sw_out_bit0_pipe[BS_PIPELINE_LEVEL-1];
assign sw_out_bit1[CHECK_PARALLELISM-1:0] = sw_out_bit1_pipe[BS_PIPELINE_LEVEL-1];
assign sw_out_bit2[CHECK_PARALLELISM-1:0] = sw_out_bit2_pipe[BS_PIPELINE_LEVEL-1];
assign sw_out_bit3[CHECK_PARALLELISM-1:0] = sw_out_bit3_pipe[BS_PIPELINE_LEVEL-1];
`else
assign sw_out_bit0[CHECK_PARALLELISM-1:0] = sw_in_bit0[CHECK_PARALLELISM-1:0];
assign sw_out_bit1[CHECK_PARALLELISM-1:0] = sw_in_bit1[CHECK_PARALLELISM-1:0];
assign sw_out_bit2[CHECK_PARALLELISM-1:0] = sw_in_bit2[CHECK_PARALLELISM-1:0];
assign sw_out_bit3[CHECK_PARALLELISM-1:0] = sw_in_bit3[CHECK_PARALLELISM-1:0];
`endif
endmodule

module shared_zero_shuffle_top_85b #(
	parameter CHECK_PARALLELISM = 85,
	parameter BS_PIPELINE_LEVEL = 2
) (
	output wire [CHECK_PARALLELISM-1:0] sw_out_bit0,
	output wire [CHECK_PARALLELISM-1:0] sw_out_bit1,
	output wire [CHECK_PARALLELISM-1:0] sw_out_bit2,
	output wire [CHECK_PARALLELISM-1:0] sw_out_bit3,

`ifdef SCHED_4_6
	input wire sys_clk,
	input wire rstn,

	input wire [CHECK_PARALLELISM-1:0] sw_in1_bit0,
	input wire sw_in_bit0_src, 
`endif
	input wire [CHECK_PARALLELISM-1:0] sw_in_bit0,
	input wire [CHECK_PARALLELISM-1:0] sw_in_bit1,
	input wire [CHECK_PARALLELISM-1:0] sw_in_bit2,
	input wire [CHECK_PARALLELISM-1:0] sw_in_bit3
);

`ifdef SCHED_4_6
reg [CHECK_PARALLELISM-1:0] sw_out_bit0_pipe [0:BS_PIPELINE_LEVEL-1];
reg [CHECK_PARALLELISM-1:0] sw_out_bit1_pipe [0:BS_PIPELINE_LEVEL-1];
reg [CHECK_PARALLELISM-1:0] sw_out_bit2_pipe [0:BS_PIPELINE_LEVEL-1];
reg [CHECK_PARALLELISM-1:0] sw_out_bit3_pipe [0:BS_PIPELINE_LEVEL-1];
always @(posedge sys_clk) begin if(!rstn) sw_out_bit0_pipe[0] <= 0; else if (sw_in_bit0_src == 1'b1) sw_out_bit0_pipe[0] <= sw_in1_bit0[CHECK_PARALLELISM-1:0]; else sw_out_bit0_pipe[0] <= sw_in_bit0[CHECK_PARALLELISM-1:0]; end
always @(posedge sys_clk) begin if(!rstn) sw_out_bit1_pipe[0] <= 0; else sw_out_bit1_pipe[0] <= sw_in_bit1[CHECK_PARALLELISM-1:0]; end
always @(posedge sys_clk) begin if(!rstn) sw_out_bit2_pipe[0] <= 0; else sw_out_bit2_pipe[0] <= sw_in_bit2[CHECK_PARALLELISM-1:0]; end
always @(posedge sys_clk) begin if(!rstn) sw_out_bit3_pipe[0] <= 0; else sw_out_bit3_pipe[0] <= sw_in_bit3[CHECK_PARALLELISM-1:0]; end
genvar bit_index;
generate
	for(bit_index=1;bit_index<BS_PIPELINE_LEVEL;bit_index=bit_index+1) begin : bit_zero_shuffle_inst
		always @(posedge sys_clk) begin if(!rstn) sw_out_bit0_pipe[bit_index] <= 0; else sw_out_bit0_pipe[bit_index] <= sw_out_bit0_pipe[bit_index-1]; end
		always @(posedge sys_clk) begin if(!rstn) sw_out_bit1_pipe[bit_index] <= 0; else sw_out_bit1_pipe[bit_index] <= sw_out_bit1_pipe[bit_index-1]; end
		always @(posedge sys_clk) begin if(!rstn) sw_out_bit2_pipe[bit_index] <= 0; else sw_out_bit2_pipe[bit_index] <= sw_out_bit2_pipe[bit_index-1]; end
		always @(posedge sys_clk) begin if(!rstn) sw_out_bit3_pipe[bit_index] <= 0; else sw_out_bit3_pipe[bit_index] <= sw_out_bit3_pipe[bit_index-1]; end
	end
endgenerate
assign sw_out_bit0[CHECK_PARALLELISM-1:0] = sw_out_bit0_pipe[BS_PIPELINE_LEVEL-1];
assign sw_out_bit1[CHECK_PARALLELISM-1:0] = sw_out_bit1_pipe[BS_PIPELINE_LEVEL-1];
assign sw_out_bit2[CHECK_PARALLELISM-1:0] = sw_out_bit2_pipe[BS_PIPELINE_LEVEL-1];
assign sw_out_bit3[CHECK_PARALLELISM-1:0] = sw_out_bit3_pipe[BS_PIPELINE_LEVEL-1];
`else
assign sw_out_bit0[CHECK_PARALLELISM-1:0] = sw_in_bit0[CHECK_PARALLELISM-1:0];
assign sw_out_bit1[CHECK_PARALLELISM-1:0] = sw_in_bit1[CHECK_PARALLELISM-1:0];
assign sw_out_bit2[CHECK_PARALLELISM-1:0] = sw_in_bit2[CHECK_PARALLELISM-1:0];
assign sw_out_bit3[CHECK_PARALLELISM-1:0] = sw_in_bit3[CHECK_PARALLELISM-1:0];
`endif
endmodule

module shared_qsn_top_85b #(
	parameter QUAN_SIZE = 4,
	parameter CHECK_PARALLELISM = 85,
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1)
) (
	output wire [CHECK_PARALLELISM-1:0] sw_out_bit0,
	output wire [CHECK_PARALLELISM-1:0] sw_out_bit1,
	output wire [CHECK_PARALLELISM-1:0] sw_out_bit2,
	output wire [CHECK_PARALLELISM-1:0] sw_out_bit3,

	input wire [CHECK_PARALLELISM-1:0] sw_in0_bit0,
	input wire [CHECK_PARALLELISM-1:0] sw_in0_bit1,
	input wire [CHECK_PARALLELISM-1:0] sw_in0_bit2,
	input wire [CHECK_PARALLELISM-1:0] sw_in0_bit3,

	input wire [CHECK_PARALLELISM-1:0] sw_in1_bit0,
	input wire [CHECK_PARALLELISM-1:0] sw_in1_bit1,
	input wire [CHECK_PARALLELISM-1:0] sw_in1_bit2,
	input wire [CHECK_PARALLELISM-1:0] sw_in1_bit3,

`ifdef SCHED_4_6
	input wire [CHECK_PARALLELISM-1:0] sw_in2_bit0,
	input wire [2:0] sw_in_bit0_src,
`endif
	input wire [BITWIDTH_SHIFT_FACTOR-1:0] shift_factor,
	input wire sw_in_src,
	input wire sys_clk,
	input wire rstn
);

wire [CHECK_PARALLELISM-1:0] shared_sw_in_bit [0:QUAN_SIZE-1];
wire [6:0]  left_sel;
wire [6:0]  right_sel;
wire [83:0] merge_sel;
qsn_top_85b cnu_qsn_top_85b_0_3 (
	.sw_out_bit0 (sw_out_bit0),
	.sw_out_bit1 (sw_out_bit1),	
	.sw_out_bit2 (sw_out_bit2),	
	.sw_out_bit3 (sw_out_bit3),
`ifdef SCHED_4_6
	.sys_clk     (sys_clk),
	.rstn		 (rstn),
`endif
	.sw_in_bit0  (shared_sw_in_bit[0]),
	.sw_in_bit1  (shared_sw_in_bit[1]),
	.sw_in_bit2  (shared_sw_in_bit[2]),
	.sw_in_bit3  (shared_sw_in_bit[3]),
	.left_sel    (left_sel),
	.right_sel   (right_sel),
	.merge_sel   (merge_sel)
);

qsn_controller_85b #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) cnu_qsn_controller_85b (
	.left_sel     (left_sel ),
	.right_sel    (right_sel),
	.merge_sel    (merge_sel),
	.shift_factor (shift_factor), // offset shift factor of submatrix_1
	.rstn         (rstn),
	.sys_clk      (sys_clk)
);

scalable_mux_3_to_1 #(.BITWIDTH(CHECK_PARALLELISM)) shared_sw_in_u0 (.sw_out(shared_sw_in_bit[0]), .sw_in_0(sw_in0_bit0[CHECK_PARALLELISM-1:0]), .sw_in_1(sw_in1_bit0[CHECK_PARALLELISM-1:0]), .sw_in_2(sw_in2_bit0[CHECK_PARALLELISM-1:0]), .in_src(sw_in_bit0_src[2:0]));
scalable_mux #(.BITWIDTH(CHECK_PARALLELISM)) shared_sw_in_u1 (.sw_out(shared_sw_in_bit[1]), .sw_in_0(sw_in0_bit1[CHECK_PARALLELISM-1:0]), .sw_in_1(sw_in1_bit1[CHECK_PARALLELISM-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(CHECK_PARALLELISM)) shared_sw_in_u2 (.sw_out(shared_sw_in_bit[2]), .sw_in_0(sw_in0_bit2[CHECK_PARALLELISM-1:0]), .sw_in_1(sw_in1_bit2[CHECK_PARALLELISM-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(CHECK_PARALLELISM)) shared_sw_in_u3 (.sw_out(shared_sw_in_bit[3]), .sw_in_0(sw_in0_bit3[CHECK_PARALLELISM-1:0]), .sw_in_1(sw_in1_bit3[CHECK_PARALLELISM-1:0]), .in_src(sw_in_src));
endmodule

module scalable_mux #(
	parameter BITWIDTH = 85
) (
	output wire [BITWIDTH-1:0] sw_out,
	input wire [BITWIDTH-1:0] sw_in_0,
	input wire [BITWIDTH-1:0] sw_in_1,
	input wire in_src
);

assign sw_out[BITWIDTH-1:0] = (in_src == 1'b0) ? sw_in_0[BITWIDTH-1:0] : sw_in_1[BITWIDTH-1:0];
endmodule

module scalable_mux_3_to_1 #(
	parameter BITWIDTH = 85
) (
	output wire [BITWIDTH-1:0] sw_out,
	input wire [BITWIDTH-1:0] sw_in_0,
	input wire [BITWIDTH-1:0] sw_in_1,
	input wire [BITWIDTH-1:0] sw_in_2,
	input wire [2:0] in_src
);

assign sw_out[BITWIDTH-1:0] = (in_src[0] == 1'b1) ? sw_in_0[BITWIDTH-1:0] : 
							  (in_src[1] == 1'b1) ? sw_in_1[BITWIDTH-1:0] :
							  (in_src[2] == 1'b1) ? sw_in_2[BITWIDTH-1:0] : 0;
endmodule

// Obselete
module permutation_wrapper #(
	parameter CHECK_PARALLELISM = 85
) (
	output wire [84:0] bs_out,

	input wire [3:0] sw_in,
	input wire [6:0] shift_factor,
	input wire read_clk,
	input wire rstn
);

wire [6:0] left_sel;
wire [6:0] right_sel;
wire [83:0] merge_sel;
// Control unit of permutation network
qsn_controller_85b #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) inst_qsn_controller_85b (
	.left_sel     (left_sel),
	.right_sel    (right_sel),
	.merge_sel    (merge_sel),

	.shift_factor (shift_factor),
	.rstn         (rstn),
	.sys_clk      (read_clk)
);

// Permutation Network
wire [84:0] sw_out_bit0;
wire [84:0] sw_out_bit1;
wire [84:0] sw_out_bit2;
wire [84:0] sw_out_bit3;
qsn_top_85b inst_qsn_top_85b (
	.sw_out_bit0 (sw_out_bit0),
	.sw_out_bit1 (sw_out_bit1),
	.sw_out_bit2 (sw_out_bit2),
	.sw_out_bit3 (sw_out_bit3),
	.sw_in_bit0  ({{84{1'b0}}, sw_in[0]}),
	.sw_in_bit1  ({{84{1'b0}}, sw_in[1]}),
	.sw_in_bit2  ({{84{1'b0}}, sw_in[2]}),
	.sw_in_bit3  ({{84{1'b0}}, sw_in[3]}),
`ifdef SCHED_4_6
	.sys_clk (read_clk),
	.rstn (rstn),
`endif
	.left_sel    (left_sel),
	.right_sel   (right_sel),
	.merge_sel   (merge_sel)
);

permutation_lib permutation_lib_u0 (
	.bs_out (bs_out),
	.bs_in ({sw_out_bit0, sw_out_bit1, sw_out_bit2, sw_out_bit3})
);
endmodule

module permutation_lib (
	output wire [84:0] bs_out,
	input wire [85*4-1:0] bs_in
);

generate
	genvar i;
	for(i=0;i<85;i=i+1) begin : dummy_inst
		assign bs_out[i] = |bs_in[(i+1)*4-1:i*4];
	end
endgenerate
endmodule