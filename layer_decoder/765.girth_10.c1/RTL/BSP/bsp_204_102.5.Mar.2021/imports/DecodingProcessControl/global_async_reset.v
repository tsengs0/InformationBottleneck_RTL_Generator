// To synchronise the exit of global reset signal by inserting N number flip-flops, i.e., a FF chain method
module global_reset #(
	parameter SYNC_FF_NUM = 5
)(
	output reg sync_rstn,

	input wire async_rstn_in,
	input wire sys_clk
);

reg [SYNC_FF_NUM-2:0] rstn_pipe;
always @(posedge sys_clk, negedge async_rstn_in) begin
	if(async_rstn_in == 1'b0) {sync_rstn, rstn_pipe[SYNC_FF_NUM-2:0]} <= {SYNC_FF_NUM{1'b0}};
	else {sync_rstn, rstn_pipe[SYNC_FF_NUM-2:0]} <= {rstn_pipe[SYNC_FF_NUM-2:0], 1'b1};
end
endmodule
