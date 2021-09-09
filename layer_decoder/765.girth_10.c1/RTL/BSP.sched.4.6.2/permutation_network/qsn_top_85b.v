`include "define.vh"

module qsn_top_85b (
`ifdef SCHED_4_6
	output reg [84:0] sw_out_bit0,
	output reg [84:0] sw_out_bit1,
	output reg [84:0] sw_out_bit2,
	output reg [84:0] sw_out_bit3,
`else
	output wire [84:0] sw_out_bit0,
	output wire [84:0] sw_out_bit1,
	output wire [84:0] sw_out_bit2,
	output wire [84:0] sw_out_bit3,
`endif

`ifdef SCHED_4_6
	input wire sys_clk,
	input wire rstn,
`endif
	input wire [84:0] sw_in_bit0,
	input wire [84:0] sw_in_bit1,
	input wire [84:0] sw_in_bit2,
	input wire [84:0] sw_in_bit3,
	input wire [6:0] left_sel,
	input wire [6:0] right_sel,
	input wire [83:0] merge_sel
);

	wire [84:0] sw_in_reg[0:3];
	wire [84:0] sw_out_reg[0:3];
	genvar i;
	generate
		for(i=0;i<4;i=i+1) begin : bs_bitwidth_inst
		// Instantiation of Left Shift Network
		wire [83:0] left_sw_out;
		qsn_left_85b qsn_left_u0 (
			.sw_out (left_sw_out[83:0]),
`ifdef SCHED_4_6
			.sys_clk (sys_clk),
			.rstn    (rstn   ),
`endif
			.sw_in (sw_in_reg[i]),
			.sel (left_sel[6:0])
		);
		// Instantiation of Right Shift Network
		wire [84:0] right_sw_out;
		qsn_right_85b qsn_right_u0 (
			.sw_out (right_sw_out[84:0]),
`ifdef SCHED_4_6
			.sys_clk (sys_clk),
			.rstn    (rstn   ),
`endif
			.sw_in (sw_in_reg[i]),
			.sel (right_sel[6:0])
		);
		// Instantiation of Merge Network
`ifdef SCHED_4_6
		reg [83:0] merge_sel_reg0;
		always @(posedge sys_clk) begin if(!rstn) merge_sel_reg0 <= 0; else merge_sel_reg0 <= merge_sel; end
`endif
		qsn_merge_85b qsn_merge_u0 (
			.sw_out (sw_out_reg[i]),

			.left_in (left_sw_out[83:0]),
			.right_in (right_sw_out[84:0]),
`ifdef SCHED_4_6
			.sel (merge_sel_reg0[83:0])
`else
			.sel (merge_sel[83:0])
`endif
		);
		end
	endgenerate

	assign sw_in_reg[0] = sw_in_bit0[84:0];
	assign sw_in_reg[1] = sw_in_bit1[84:0];
	assign sw_in_reg[2] = sw_in_bit2[84:0];
	assign sw_in_reg[3] = sw_in_bit3[84:0];

`ifdef SCHED_4_6
	always @(posedge sys_clk) begin if(!rstn) sw_out_bit0[84:0] <= 0; else sw_out_bit0[84:0] <= sw_out_reg[0]; end
	always @(posedge sys_clk) begin if(!rstn) sw_out_bit1[84:0] <= 0; else sw_out_bit1[84:0] <= sw_out_reg[1]; end
	always @(posedge sys_clk) begin if(!rstn) sw_out_bit2[84:0] <= 0; else sw_out_bit2[84:0] <= sw_out_reg[2]; end
	always @(posedge sys_clk) begin if(!rstn) sw_out_bit3[84:0] <= 0; else sw_out_bit3[84:0] <= sw_out_reg[3]; end
`else
	assign sw_out_bit0[84:0] = sw_out_reg[0];
	assign sw_out_bit1[84:0] = sw_out_reg[1];
	assign sw_out_bit2[84:0] = sw_out_reg[2];
	assign sw_out_bit3[84:0] = sw_out_reg[3];
`endif
endmodule