`include "define.v"

module cnu6_ib_map (
	output wire [`QUAN_SIZE-1:0] bank0_portA,
	output wire [`QUAN_SIZE-1:0] bank0_portB,
	output wire [`QUAN_SIZE-1:0] bank0_portC,
	output wire [`QUAN_SIZE-1:0] bank0_portD,

	output wire [`QUAN_SIZE-1:0] bank1_portA,
	output wire [`QUAN_SIZE-1:0] bank1_portB,
	output wire [`QUAN_SIZE-1:0] bank1_portC,
	output wire [`QUAN_SIZE-1:0] bank1_portD,

	output wire [`QUAN_SIZE-1:0] bank2_portA,
	output wire [`QUAN_SIZE-1:0] bank2_portB,
	output wire [`QUAN_SIZE-1:0] bank2_portC,
	output wire [`QUAN_SIZE-1:0] bank2_portD,

	output wire [`QUAN_SIZE-1:0] bank3_portA,
	output wire [`QUAN_SIZE-1:0] bank3_portB,
	output wire [`QUAN_SIZE-1:0] bank3_portC,
	output wire [`QUAN_SIZE-1:0] bank3_portD,

	output wire [`QUAN_SIZE-1:0] bank4_portA,
	output wire [`QUAN_SIZE-1:0] bank4_portB,
	output wire [`QUAN_SIZE-1:0] bank4_portC,
	output wire [`QUAN_SIZE-1:0] bank4_portD,

	output wire [`QUAN_SIZE-1:0] bank5_portA,
	output wire [`QUAN_SIZE-1:0] bank5_portB,
	output wire [`QUAN_SIZE-1:0] bank5_portC,
	output wire [`QUAN_SIZE-1:0] bank5_portD,

	output wire [`QUAN_SIZE-1:0] bank6_portA,
	output wire [`QUAN_SIZE-1:0] bank6_portB,
	output wire [`QUAN_SIZE-1:0] bank6_portC,
	output wire [`QUAN_SIZE-1:0] bank6_portD,

	output wire [`QUAN_SIZE-1:0] bank7_portA,
	output wire [`QUAN_SIZE-1:0] bank7_portB,
	output wire [`QUAN_SIZE-1:0] bank7_portC,
	output wire [`QUAN_SIZE-1:0] bank7_portD,

	output reg [`IB_ROM_ADDR_WIDTH-1:0] rom_read_addrA,
	output reg [`IB_ROM_ADDR_WIDTH-1:0] rom_read_addrB,

	input wire [`IB_ROM_SIZE-1:0] rom_readA,
	input wire [`IB_ROM_SIZE-1:0] rom_readB,
	input sys_clk,
	input rstn,
	output reg cnt
);

// 18 entryies x4-bit can be read from cnu6_ib_rom in every clock cycle
// Thus, to flush out those 18 entries to cnu_ib_ram[x], two clock cycles is needed
//reg cnt = 1'b0;
always @(negedge sys_clk, negedge rstn) begin
	if(!rstn) cnt <= 1'b0;
	else      cnt <= cnt + 1'b1;
end

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

localparam bank_data_width = `QUAN_SIZE*4;
reg [bank_data_width-1:0] bank_portABCD[0:7];
reg [2:0] bank_id_shift0 [0:7];
//reg [2:0] bank_id_shift1 [0:7];
always @(negedge sys_clk, negedge rstn) begin
    if(!rstn) begin
        {bank_id_shift0[0], bank_id_shift0[1]} <= 6'b000_001;
        {bank_id_shift0[2], bank_id_shift0[3]} <= 6'b010_011;
        {bank_id_shift0[4], bank_id_shift0[5]} <= 6'b100_101;
        {bank_id_shift0[6], bank_id_shift0[7]} <= 6'b110_111;
   /*     
        {bank_id_shift1[0], bank_id_shift1[1]} <= 6'b001_010;
        {bank_id_shift1[2], bank_id_shift1[3]} <= 6'b011_100;
        {bank_id_shift1[4], bank_id_shift1[5]} <= 6'b101_110;
        {bank_id_shift1[6], bank_id_shift1[7]} <= 6'b111_000;*/
    end
    else begin
        {bank_id_shift0[0], bank_id_shift0[1]} <= {bank_id_shift0[1], bank_id_shift0[2]};
        {bank_id_shift0[2], bank_id_shift0[3]} <= {bank_id_shift0[3], bank_id_shift0[4]};
        {bank_id_shift0[4], bank_id_shift0[5]} <= {bank_id_shift0[5], bank_id_shift0[6]};
        {bank_id_shift0[6], bank_id_shift0[7]} <= {bank_id_shift0[7], bank_id_shift0[0]};
        
      /*  {bank_id_shift1[0], bank_id_shift1[1]} <=  {bank_id_shift1[1], bank_id_shift1[2]};
        {bank_id_shift1[2], bank_id_shift1[3]} <=  {bank_id_shift1[3], bank_id_shift1[4]};
        {bank_id_shift1[4], bank_id_shift1[5]} <=  {bank_id_shift1[5], bank_id_shift1[6]};
        {bank_id_shift1[6], bank_id_shift1[7]} <=  {bank_id_shift1[7], bank_id_shift1[0]};*/
    end
end

// Write the data to one cnu_ib_ram[x], where x is in {0, 1, 2, 3}
always @(negedge sys_clk, negedge rstn) begin
	if(!rstn) begin
		bank_portABCD[0] <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
		bank_portABCD[1] <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
		bank_portABCD[2] <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
		bank_portABCD[3] <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
		bank_portABCD[4] <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
		bank_portABCD[5] <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
		bank_portABCD[6] <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
		bank_portABCD[7] <= {bank_data_width{1'bx}}; // one bank 4-port x 4-bit = 16-bit
	end
	else if(cnt == 1'b0) begin
		bank_portABCD[bank_id_shift0[0]] <= rom_readA[`IB_ROM_SIZE-1:`IB_ROM_SIZE-16]; // one bank 4-port x 4-bit = 16-bit
		bank_portABCD[bank_id_shift0[1]] <= rom_readA[`IB_ROM_SIZE-1-16:`IB_ROM_SIZE-16-16]; 
		bank_portABCD[bank_id_shift0[2]] <= {rom_readA[3:0], rom_readB[`IB_ROM_SIZE-1:`IB_ROM_SIZE-12]}; 
		bank_portABCD[bank_id_shift0[3]] <= rom_readB[`IB_ROM_SIZE-1-12:`IB_ROM_SIZE-12-16];
		bank_portABCD[bank_id_shift0[4]][bank_data_width-1:bank_data_width-8] <= rom_readB[`IB_ROM_SIZE-1-12-16:`IB_ROM_SIZE-12-16-8];
	end
	else begin // cnt == 1'b1
    	bank_portABCD[bank_id_shift0[3]][bank_data_width-1-8:bank_data_width-8-8] <= rom_readA[`IB_ROM_SIZE-1:`IB_ROM_SIZE-8];
		bank_portABCD[bank_id_shift0[4]] <=  rom_readA[`IB_ROM_SIZE-1-8:`IB_ROM_SIZE-8-16]; 
		bank_portABCD[bank_id_shift0[5]] <= {rom_readA[`IB_ROM_SIZE-1-8-16:`IB_ROM_SIZE-8-16-12], rom_readB[`IB_ROM_SIZE-1:`IB_ROM_SIZE-4]}; 
		bank_portABCD[bank_id_shift0[6]] <=  rom_readB[`IB_ROM_SIZE-1-4:`IB_ROM_SIZE-4-16]; 
		bank_portABCD[bank_id_shift0[7]] <= rom_readB[`IB_ROM_SIZE-1-4-16:`IB_ROM_SIZE-4-16-16];
	end
end

assign {bank0_portA, bank0_portB, bank0_portC, bank0_portD} = bank_portABCD[0];
assign {bank1_portA, bank1_portB, bank1_portC, bank1_portD} = bank_portABCD[1];
assign {bank2_portA, bank2_portB, bank2_portC, bank2_portD} = bank_portABCD[2];
assign {bank3_portA, bank3_portB, bank3_portC, bank3_portD} = bank_portABCD[3];
assign {bank4_portA, bank4_portB, bank4_portC, bank4_portD} = bank_portABCD[4];
assign {bank5_portA, bank5_portB, bank5_portC, bank5_portD} = bank_portABCD[5];
assign {bank6_portA, bank6_portB, bank6_portC, bank6_portD} = bank_portABCD[6];
assign {bank7_portA, bank7_portB, bank7_portC, bank7_portD} = bank_portABCD[7];
endmodule
