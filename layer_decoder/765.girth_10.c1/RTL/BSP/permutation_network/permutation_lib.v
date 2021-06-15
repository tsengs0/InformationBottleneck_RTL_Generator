`include "define.vh"

module zero_shuffle_top_85b #(
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