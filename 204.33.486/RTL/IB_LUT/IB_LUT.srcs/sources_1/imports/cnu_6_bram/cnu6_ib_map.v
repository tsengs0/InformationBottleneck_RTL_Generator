`include "define.v"

module cnu6_ib_map (
	output reg [`QUAN_SIZE-1:0] bank0_portA,
	output reg [`QUAN_SIZE-1:0] bank0_portB,
	output reg [`QUAN_SIZE-1:0] bank0_portC,
	output reg [`QUAN_SIZE-1:0] bank0_portD,

	output reg [`QUAN_SIZE-1:0] bank1_portA,
	output reg [`QUAN_SIZE-1:0] bank1_portB,
	output reg [`QUAN_SIZE-1:0] bank1_portC,
	output reg [`QUAN_SIZE-1:0] bank1_portD,

	output reg [`QUAN_SIZE-1:0] bank2_portA,
	output reg [`QUAN_SIZE-1:0] bank2_portB,
	output reg [`QUAN_SIZE-1:0] bank2_portC,
	output reg [`QUAN_SIZE-1:0] bank2_portD,

	output reg [`QUAN_SIZE-1:0] bank3_portA,
	output reg [`QUAN_SIZE-1:0] bank3_portB,
	output reg [`QUAN_SIZE-1:0] bank3_portC,
	output reg [`QUAN_SIZE-1:0] bank3_portD,

	output reg [`QUAN_SIZE-1:0] bank4_portA,
	output reg [`QUAN_SIZE-1:0] bank4_portB,
	output reg [`QUAN_SIZE-1:0] bank4_portC,
	output reg [`QUAN_SIZE-1:0] bank4_portD,

	output reg [`QUAN_SIZE-1:0] bank5_portA,
	output reg [`QUAN_SIZE-1:0] bank5_portB,
	output reg [`QUAN_SIZE-1:0] bank5_portC,
	output reg [`QUAN_SIZE-1:0] bank5_portD,

	output reg [`QUAN_SIZE-1:0] bank6_portA,
	output reg [`QUAN_SIZE-1:0] bank6_portB,
	output reg [`QUAN_SIZE-1:0] bank6_portC,
	output reg [`QUAN_SIZE-1:0] bank6_portD,

	output reg [`QUAN_SIZE-1:0] bank7_portA,
	output reg [`QUAN_SIZE-1:0] bank7_portB,
	output reg [`QUAN_SIZE-1:0] bank7_portC,
	output reg [`QUAN_SIZE-1:0] bank7_portD,

	output reg [`IB_ROM_ADDR_WIDTH-1:0] rom_read_addrA,
	output reg [`IB_ROM_ADDR_WIDTH-1:0] rom_read_addrB,

	input wire [`IB_ROM_SIZE-1:0] rom_readA,
	input wire [`IB_ROM_SIZE-1:0] rom_readB,
	input sys_clk,
	input rstn
);

// 18 entryies x4-bit can be read from cnu6_ib_rom in every clock cycle
// Thus, to flush out those 18 entries to cnu_ib_ram[x], two clock cycles is needed
reg [1:0] cnt = 2'b00;
always @(posedge sys_clk, negedge rstn) begin
	if(!rstn) cnt[1:0] <= 2'b00;
	else      cnt[1:0] <= cnt[1:0] + 1'b1;
end

always @(posedge sys_clk, negedge rstn) begin
	if(!rstn) begin
	   rom_read_addrA[`IB_ROM_ADDR_WIDTH-1:0] <= `IB_ROM_ADDR_WIDTH'd0;
	   rom_read_addrB[`IB_ROM_ADDR_WIDTH-1:0] <= `IB_ROM_ADDR_WIDTH'd1;
	end
	else begin
		rom_read_addrA[`IB_ROM_ADDR_WIDTH-1:0] <= rom_read_addrA[`IB_ROM_ADDR_WIDTH-1:0] + 1'b1;
		rom_read_addrB[`IB_ROM_ADDR_WIDTH-1:0] <= rom_read_addrB[`IB_ROM_ADDR_WIDTH-1:0] + 1'b1;
	end
end

localparam bank_data_width = `QUAN_SIZE*4;
// Write the data to one cnu_ib_ram[x], where x is in {0, 1, 2, 3}
always @(posedge sys_clk, negedge rstn) begin
	if(!rstn) begin
		{bank0_portA, bank0_portB, bank0_portC, bank0_portD} <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
		{bank1_portA, bank1_portB, bank1_portC, bank1_portD} <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
		{bank2_portA, bank2_portB, bank2_portC, bank2_portD} <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
		{bank3_portA, bank3_portB, bank3_portC, bank3_portD} <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
		{bank4_portA, bank4_portB, bank4_portC, bank4_portD} <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
		{bank5_portA, bank5_portB, bank5_portC, bank5_portD} <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
		{bank6_portA, bank6_portB, bank6_portC, bank6_portD} <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
		{bank7_portA, bank7_portB, bank7_portC, bank7_portD} <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
	end
	else if(cnt[1:0] == 2'b00) begin
		{bank0_portA, bank0_portB, bank0_portC, bank0_portD} <= rom_readA[`IB_ROM_SIZE-1:`IB_ROM_SIZE-16]; // one bank 4-port x 4-bit = 16-bit
		{bank1_portA, bank1_portB, bank1_portC, bank1_portD} <= rom_readA[`IB_ROM_SIZE-1-16:`IB_ROM_SIZE-16-16]; 
		 bank2_portA                                         <= rom_readA[3:0]; 
	end
	else if(cnt[1:0] == 2'b01) begin
		{bank2_portB, bank2_portC, bank2_portD}              <= rom_readB[`IB_ROM_SIZE-1:`IB_ROM_SIZE-12];
		{bank3_portA, bank3_portB, bank3_portC, bank3_portD} <= rom_readB[`IB_ROM_SIZE-1-12:`IB_ROM_SIZE-12-16]; 
		{bank4_portA, bank4_portB}                           <= rom_readB[`IB_ROM_SIZE-1-12-16:`IB_ROM_SIZE-12-16-8]; 
	end
	else if(cnt[1:0] == 2'b10) begin
		{bank4_portC, bank4_portD}                           <= rom_readA[`IB_ROM_SIZE-1:`IB_ROM_SIZE-8];
		{bank5_portA, bank5_portB, bank5_portC, bank5_portD} <= rom_readA[`IB_ROM_SIZE-1-8:`IB_ROM_SIZE-8-16];
		{bank6_portA, bank6_portB, bank6_portC}              <= rom_readA[`IB_ROM_SIZE-1-8-16:`IB_ROM_SIZE-8-16-12]; 
	end
	else begin //if(cnt[1:0] == 2'b11)
		 bank6_portD                                         <= rom_readB[`IB_ROM_SIZE-1:`IB_ROM_SIZE-4];
		{bank7_portA, bank7_portB, bank7_portC, bank7_portD} <= rom_readA[`IB_ROM_SIZE-1-4:`IB_ROM_SIZE-4-16]; // one bank 4-port x 4-bit = 16-bit
	end
end

endmodule
