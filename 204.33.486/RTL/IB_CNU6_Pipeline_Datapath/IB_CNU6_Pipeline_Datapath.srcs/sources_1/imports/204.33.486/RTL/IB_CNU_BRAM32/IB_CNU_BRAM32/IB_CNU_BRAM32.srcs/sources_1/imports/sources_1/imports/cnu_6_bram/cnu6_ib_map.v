`include "define.v"

module cnu6_ib_map (
	output wire [`QUAN_SIZE-1:0] bank0_portA,
	output wire [`QUAN_SIZE-1:0] bank0_portB,

	output wire [`QUAN_SIZE-1:0] bank1_portA,
	output wire [`QUAN_SIZE-1:0] bank1_portB,

	output wire [`QUAN_SIZE-1:0] bank2_portA,
	output wire [`QUAN_SIZE-1:0] bank2_portB,

	output wire [`QUAN_SIZE-1:0] bank3_portA,
	output wire [`QUAN_SIZE-1:0] bank3_portB,

	output wire [`QUAN_SIZE-1:0] bank4_portA,
	output wire [`QUAN_SIZE-1:0] bank4_portB,

	output wire [`QUAN_SIZE-1:0] bank5_portA,
	output wire [`QUAN_SIZE-1:0] bank5_portB,

	output wire [`QUAN_SIZE-1:0] bank6_portA,
	output wire [`QUAN_SIZE-1:0] bank6_portB,

	output wire [`QUAN_SIZE-1:0] bank7_portA,
	output wire [`QUAN_SIZE-1:0] bank7_portB,

	output reg [`IB_ROM_ADDR_WIDTH-1:0] rom_read_addrA,
	output reg [`IB_ROM_ADDR_WIDTH-1:0] rom_read_addrB,

	input wire [`IB_ROM_SIZE-1:0] rom_readA,
	input wire [`IB_ROM_SIZE-1:0] rom_readB,
	input sys_clk,
	input rstn
);

always @(negedge sys_clk, negedge rstn) begin
	if(!rstn) begin
	   rom_read_addrA[`IB_ROM_ADDR_WIDTH-1:0] <= `IB_ROM_ADDR_WIDTH'd0;
	   rom_read_addrB[`IB_ROM_ADDR_WIDTH-1:0] <= `IB_ROM_ADDR_WIDTH'd1;
	end
	else begin
		rom_read_addrA[`IB_ROM_ADDR_WIDTH-1:0] <= rom_read_addrB[`IB_ROM_ADDR_WIDTH-1:0] + 1'b1;
		rom_read_addrB[`IB_ROM_ADDR_WIDTH-1:0] <= rom_read_addrB[`IB_ROM_ADDR_WIDTH-1:0] + 2'b10;
	end
end

localparam interBank_data_width = 32;
reg [interBank_data_width-1:0] interBank_port0_7[0:1];
// Write the data to one cnu_ib_ram[x], where x is in {0, 1, 2}
always @(negedge sys_clk, negedge rstn) begin
	if(!rstn) begin
		interBank_port0_7[0] <= {interBank_data_width{1'bx}}; // one set of 8 interleaving banks x 4-bit = 32-bit
		interBank_port0_7[1] <= {interBank_data_width{1'bx}}; // one set of 8 interleaving banks x 4-bit = 32-bit
	end
	else begin
	    interBank_port0_7[0] <= rom_readA[`IB_ROM_SIZE-1:0]; 
	    interBank_port0_7[1] <= rom_readB[`IB_ROM_SIZE-1:0];
	end
end

// In an bank-interleaving manner
assign {bank0_portA, bank1_portA, bank2_portA, bank3_portA, bank4_portA, bank5_portA, bank6_portA, bank7_portA} = interBank_port0_7[0];
assign {bank0_portB, bank1_portB, bank2_portB, bank3_portB, bank4_portB, bank5_portB, bank6_portB, bank7_portB} = interBank_port0_7[1];
endmodule
