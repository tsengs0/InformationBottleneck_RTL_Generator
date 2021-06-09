`include "define.vh"

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