`include "define.v"

module cnu6_ib_map (
	output wire [`QUAN_SIZE-1:0] bank0_portA,
	output wire [`QUAN_SIZE-1:0] bank0_portB,
	output wire [`QUAN_SIZE-1:0] bank0_portC,
	//output wire [`QUAN_SIZE-1:0] bank0_portD,

	output wire [`QUAN_SIZE-1:0] bank1_portA,
	output wire [`QUAN_SIZE-1:0] bank1_portB,
	output wire [`QUAN_SIZE-1:0] bank1_portC,
	//output wire [`QUAN_SIZE-1:0] bank1_portD,

	output wire [`QUAN_SIZE-1:0] bank2_portA,
	output wire [`QUAN_SIZE-1:0] bank2_portB,
	output wire [`QUAN_SIZE-1:0] bank2_portC,
	//output wire [`QUAN_SIZE-1:0] bank2_portD,

	output wire [`QUAN_SIZE-1:0] bank3_portA,
	output wire [`QUAN_SIZE-1:0] bank3_portB,
	output wire [`QUAN_SIZE-1:0] bank3_portC,
	//output wire [`QUAN_SIZE-1:0] bank3_portD,

	output wire [`QUAN_SIZE-1:0] bank4_portA,
	output wire [`QUAN_SIZE-1:0] bank4_portB,
	output wire [`QUAN_SIZE-1:0] bank4_portC,
	//output wire [`QUAN_SIZE-1:0] bank4_portD,

	output wire [`QUAN_SIZE-1:0] bank5_portA,
	output wire [`QUAN_SIZE-1:0] bank5_portB,
	output wire [`QUAN_SIZE-1:0] bank5_portC,
	//output wire [`QUAN_SIZE-1:0] bank5_portD,

	output wire [`QUAN_SIZE-1:0] bank6_portA,
	output wire [`QUAN_SIZE-1:0] bank6_portB,
	output wire [`QUAN_SIZE-1:0] bank6_portC,
	//output wire [`QUAN_SIZE-1:0] bank6_portD,

	output wire [`QUAN_SIZE-1:0] bank7_portA,
	output wire [`QUAN_SIZE-1:0] bank7_portB,
	output wire [`QUAN_SIZE-1:0] bank7_portC,
	//output wire [`QUAN_SIZE-1:0] bank7_portD,
	//output reg [3:0] port_shifter,

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
/*
// 4-Port ID shifter, ID in {portA, portB, portC, portD}
reg [1:0] port_id_shifter [0:3];
always @(negedge sys_clk, negedge rstn) begin
	if(!rstn) begin
		{port_id_shifter[0], port_id_shifter[1]} <= 4'b00_01;
		{port_id_shifter[2], port_id_shifter[3]} <= 4'b10_11;
	end
	else  begin
		{port_id_shifter[0], port_id_shifter[1]} <= {port_id_shifter[2], port_id_shifter[3]};
		{port_id_shifter[2], port_id_shifter[3]} <= {port_id_shifter[0], port_id_shifter[1]}; 
	end
end
*/
/*
always @(negedge sys_clk, negedge rstn) begin
    if(!rstn)   port_shifter[3:0] <= 4'b1110;
    else port_shifter[3:0] <= {port_shifter[2:3], port_shifter[0:1]};
end
*/
reg [1:0] offset_cnt;
always @(negedge sys_clk, negedge rstn) begin
	if(!rstn) offset_cnt[1:0] <= 2'b00;
	else offset_cnt[1:0] <= offset_cnt[1:0] + 1'b1;
end
localparam interBank_data_width = 32;
reg [interBank_data_width-1:0] interBank_port0_7[0:2];
// Write the data to one cnu_ib_ram[x], where x is in {0, 1, 2}
always @(negedge sys_clk, negedge rstn) begin
	if(!rstn) begin
		interBank_port0_7[0] <= {interBank_data_width{1'bx}}; // one set of 8 interleaving banks x 4-bit = 32-bit
		interBank_port0_7[1] <= {interBank_data_width{1'bx}}; // one set of 8 interleaving banks x 4-bit = 32-bit
		interBank_port0_7[2] <= {interBank_data_width{1'bx}}; // one set of 8 interleaving banks x 4-bit = 32-bit
		//interBank_port0_7[3] <= {interBank_data_width{1'bx}}; // one set of 8 interleaving banks x 4-bit = 32-bit
	end
	else if(offset_cnt[1:0] == 2'b00) begin
	    interBank_port0_7[/*port_id_shifter[0]*/0][31:0] <= rom_readA[`IB_ROM_SIZE-1:`IB_ROM_SIZE-32]; 
	    interBank_port0_7[/*port_id_shifter[1]*/1] <= {rom_readA[3:0], rom_readB[`IB_ROM_SIZE-1:`IB_ROM_SIZE-28]};
	    interBank_port0_7[/*port_id_shifter[2]*/2][interBank_data_width-1:24] <= rom_readB[`IB_ROM_SIZE-1-28:0];
	end
	else if(offset_cnt[1:0] == 2'b01) begin
		//{
		 interBank_port0_7[/*port_id_shifter[0]*/0][23:0] <= rom_readA[`IB_ROM_SIZE-1:`IB_ROM_SIZE-24];
		 interBank_port0_7[/*port_id_shifter[1]*/1] <= {rom_readA[`IB_ROM_SIZE-1-24:0], rom_readB[`IB_ROM_SIZE-1:`IB_ROM_SIZE-20]};
		 interBank_port0_7[/*port_id_shifter[2]*/2][interBank_data_width-1:16] <= rom_readB[`IB_ROM_SIZE-1-20:0];
		//} <= {rom_readA[`IB_ROM_SIZE-1:0], rom_readB[`IB_ROM_SIZE-1:0]}; 
	end
	else if(offset_cnt[1:0] == 2'b10) begin
		 interBank_port0_7[/*port_id_shifter[0]*/0][15:0] <= rom_readA[`IB_ROM_SIZE-1:`IB_ROM_SIZE-16];
		 interBank_port0_7[/*port_id_shifter[1]*/1]       <= {rom_readA[`IB_ROM_SIZE-1-16:0], rom_readB[`IB_ROM_SIZE-1:`IB_ROM_SIZE-12]};
		 interBank_port0_7[/*port_id_shifter[2]*/2][interBank_data_width-1:8] <= rom_readB[`IB_ROM_SIZE-1-12:0];
	end
	else begin // if(offset_cnt[1:0] == 2'b11) begin
		 interBank_port0_7[/*port_id_shifter[0]*/0][7:0] <= rom_readA[`IB_ROM_SIZE-1:`IB_ROM_SIZE-8];                                   
		 interBank_port0_7[/*port_id_shifter[1]*/1]      <= {rom_readA[`IB_ROM_SIZE-1-8:0], rom_readB[`IB_ROM_SIZE-1:`IB_ROM_SIZE-4]}; 
		 interBank_port0_7[/*port_id_shifter[2]*/2][interBank_data_width-1:0] <= rom_readB[`IB_ROM_SIZE-1-4:0];
	end
end

// In an bank-interleaving manner
assign {bank0_portA, bank1_portA, bank2_portA, bank3_portA, bank4_portA, bank5_portA, bank6_portA, bank7_portA} = interBank_port0_7[0];
assign {bank0_portB, bank1_portB, bank2_portB, bank3_portB, bank4_portB, bank5_portB, bank6_portB, bank7_portB} = interBank_port0_7[1];
assign {bank0_portC, bank1_portC, bank2_portC, bank3_portC, bank4_portC, bank5_portC, bank6_portC, bank7_portC} = interBank_port0_7[2];
//assign {bank0_portD, bank1_portD, bank2_portD, bank3_portD, bank4_portD, bank5_portD, bank6_portD, bank7_portD} = interBank_port0_7[3];
endmodule
