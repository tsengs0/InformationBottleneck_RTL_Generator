module dnu_signExtenIn_ram #(
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,

	parameter DEPTH = ROW_CHUNK_NUM,
	parameter DATA_WIDTH = CHECK_PARALLELISM,
	parameter ADDR_WIDTH = $clog2(DEPTH)
) (
	output reg [DATA_WIDTH-1:0] mem_to_dnuIn,

	input wire [DATA_WIDTH-1:0] signExten_din,
	input wire [ADDR_WIDTH-1:0] read_addr,
	input wire [ADDR_WIDTH-1:0] write_addr,
	input wire we,

	input wire read_clk,
	input wire write_clk,
	input wire rstn
);

// Core Memory
reg [DATA_WIDTH-1:0] ram_block [0:DEPTH-1];

// Port-A
always @(posedge write_clk) begin
	if(we == 1'b1)
		ram_block[write_addr] <= signExten_din;
end

wire [DATA_WIDTH-1:0] do_a;
assign do_a = ram_block[read_addr];

always @(posedge read_clk) begin
	if(rstn == 1'b0) mem_to_dnuIn[DATA_WIDTH-1:0] <= 0;
	else mem_to_dnuIn[DATA_WIDTH-1:0] <= do_a;
end
endmodule