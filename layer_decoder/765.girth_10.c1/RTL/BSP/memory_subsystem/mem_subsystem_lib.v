module page_align_depth_2 #(
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

module page_align_depth_1 #(
	parameter QUAN_SIZE = 4
) (
	output wire [QUAN_SIZE-1:0] align_out,

	input wire [QUAN_SIZE-1:0] vnu_align_in,
	input wire [QUAN_SIZE-1:0] cnu_align_in,
	input wire sched_cmd, // 1'b0: align_in from variable msg; 1'b1: align_in from check msg
	input wire sys_clk,
	input wire rstn
);

wire [QUAN_SIZE-1:0] align_in;
reg [QUAN_SIZE-1:0] delay_insert_0;
always @(posedge sys_clk) begin
	if(rstn == 1'b0) delay_insert_0 <= 0;
	else delay_insert_0[QUAN_SIZE-1:0] <= align_in[QUAN_SIZE-1:0];
end
assign align_in[QUAN_SIZE-1:0] = (sched_cmd == 1'b0) ? vnu_align_in[QUAN_SIZE-1:0] : cnu_align_in[QUAN_SIZE-1:0];

assign align_out[QUAN_SIZE-1:0] = delay_insert_0[QUAN_SIZE-1:0];
endmodule