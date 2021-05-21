module permutation_wrapper #(
	parameter CHECK_PARALLELISM = 85
) (

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
qsn_top_85b inst_qsn_top_85b (
	.sw_out_bit0 (sw_out_bit0),
	.sw_out_bit1 (sw_out_bit1),
	.sw_out_bit2 (sw_out_bit2),
	.sw_out_bit3 (sw_out_bit3),
	.sw_in_bit0  (sw_in_bit0),
	.sw_in_bit1  (sw_in_bit1),
	.sw_in_bit2  (sw_in_bit2),
	.sw_in_bit3  (sw_in_bit3),
	.left_sel    (left_sel),
	.right_sel   (right_sel),
	.merge_sel   (merge_sel)
);
endmodule

module page_align #(
	parameter QUAN_SIZE = 4
) (
	output wire [QUAN_SIZE-1:0] align_out,

	input wire [QUAN_SIZE-1:0] vnu_align_in,
	input wire [QUAN_SIZE-1:0] cnu_align_in,
	input wire sched_cmd, // 1'b0: align_in from variable msg; 1'b1: align_in from check msg
	input wire delay_cmd,
	input wire sys_clk,
	input wire rstn
);

wire [QUAN_SIZE-1:0] align_in;
reg [QUAN_SIZE-1:0] delay_insert_0;
reg [QUAN_SIZE-1:0] delay_insert_1;
always @(posedge sys_clk) begin
	if(rstn == 1'b0) delay_insert_0 <= 0;
	else delay_insert_0[QUAN_SIZE-1:0] <= align_in[QUAN_SIZE-1:0];
end
assign align_in[QUAN_SIZE-1:0] = (sched_cmd == 1'b0) ? vnu_align_in[QUAN_SIZE-1:0] : cnu_align_in[QUAN_SIZE-1:0];

always @(posedge sys_clk) begin
	if(rstn == 1'b0) delay_insert_1 <= 0;
	else delay_insert_1[QUAN_SIZE-1:0] <= delay_insert_0[QUAN_SIZE-1:0];
end

assign align_out[QUAN_SIZE-1:0] = (delay_cmd == 1'b0) ? delay_insert_0[QUAN_SIZE-1:0] : delay_insert_1[QUAN_SIZE-1:0];
endmodule