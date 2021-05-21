`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/15/2020 08:38:07 PM
// Design Name: 
// Module Name: cn_write_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module cn_mem_latch #(
	parameter ROM_RD_BW = 6,    // bit-width of one read port of BRAM based IB-ROM
	parameter ROM_ADDR_BW = 10,  // bit-width of read address of BRAM based IB-ROM
								// #Entry: (64-entry*3-bit) / ROM_RD_BW)*25-iteration
								// ceil(log2(#Entry)) = 10-bit	
	parameter CN_LOAD_CYCLE = 32,
	parameter ITER_ROM_GROUP = 25,
	parameter CN_OVERPROVISION = 1, // the over-counted IB-ROM read address	
	parameter PAGE_ADDR_BW = 5, // bit-width of addressing (64-entry*3-bit)/ROM_RD_BW), i.e., ceil(log2((64-entry*3-bit)/ROM_RD_BW)))								
    parameter ITER_ADDR_BW = 5  // bit-width of addressing 25 iterationss
	//parameter CN_TYPE_A = 1,    // the number of check node type in terms of its check node degree   
	//parameter CN_TYPE_B = 1     // the number of check node type in terms of its check node degree
)(
	
	(* max_fanout = 200 *) output reg [ROM_RD_BW-1:0] latch_outA,
	(* max_fanout = 200 *) output reg [ROM_RD_BW-1:0] latch_outB,
	
	//output reg [ROM_RD_BW-1:0] latch_outA,
	//output reg [ROM_RD_BW-1:0] latch_outB,

	output reg [ROM_ADDR_BW-1:0] rom_read_addrA,
	output reg [ROM_ADDR_BW-1:0] rom_read_addrB,
	
	input wire [ROM_RD_BW-1:0] latch_inA,
	input wire [ROM_RD_BW-1:0] latch_inB,
	input wire [ROM_ADDR_BW-1:0] latch_iterA, // base address for latch A to indicate the iteration index
	input wire [ROM_ADDR_BW-1:0] latch_iterB, // base address for latch B to indicate the iteration index
	//input wire [CN_TYPE_A-1:0] latch_typeA,
	//input wire [CN_TYPE_B-1:0] latch_typeB,
	input wire rstn, // asserted/deasserted by "rom_port_fetch" signal of Iteration Update Control Unit
	input wire write_clk
);

// the upper bound of address count until 1-iteration's depth * 25-iteration
// ,where the depth accouts for the number page in one iteration
localparam rom_rd_addr_upper_bound = CN_LOAD_CYCLE*ITER_ROM_GROUP-1; 
initial rom_read_addrA <= 0;
always @(posedge write_clk) begin
	if(!rstn)
		rom_read_addrA[ROM_ADDR_BW-1:0] <= latch_iterA[ROM_ADDR_BW-1:0];
	else if(rom_read_addrA[ROM_ADDR_BW-1:0] == rom_rd_addr_upper_bound)
		rom_read_addrA[ROM_ADDR_BW-1:0] <= CN_OVERPROVISION;
	else
		rom_read_addrA[ROM_ADDR_BW-1:0] <= rom_read_addrA[ROM_ADDR_BW-1:0] + 1'b1;
end

initial rom_read_addrB <= 0;
always @(posedge write_clk) begin
	if(!rstn)
		rom_read_addrB[ROM_ADDR_BW-1:0] <= latch_iterB[ROM_ADDR_BW-1:0];
	else if(rom_read_addrB[ROM_ADDR_BW-1:0] == rom_rd_addr_upper_bound)
		rom_read_addrB[ROM_ADDR_BW-1:0] <= CN_OVERPROVISION;
	else
		rom_read_addrB[ROM_ADDR_BW-1:0] <= rom_read_addrB[ROM_ADDR_BW-1:0] + 1'b1;
end

always @(posedge write_clk, negedge rstn) begin
	if(!rstn) 
		latch_outA[ROM_RD_BW-1:0] <= 0;
	else
		latch_outA[ROM_RD_BW-1:0] <= latch_inA[ROM_RD_BW-1:0];
end
always @(posedge write_clk, negedge rstn) begin
	if(!rstn) 
		latch_outB[ROM_RD_BW-1:0] <= 0;
	else
		latch_outB[ROM_RD_BW-1:0] <= latch_inB[ROM_RD_BW-1:0];
end
endmodule

/*--------------------------------------------------------------------------------------------------*/
module c6rom_iter_selector #(
	parameter ITER_ROM_GROUP = 25, // the number of iteration datasets stored in one Group of IB-ROMs
	parameter ITER_ADDR_BW = 6  // bit-width of addressing 50 iterationss
) (
	output reg iter_switch,
	
	input wire [ITER_ADDR_BW-1:0] iter_cnt,
	input wire write_clk,
	input wire rstn
);
	initial iter_switch <= 1'b0;
	always @(posedge write_clk, negedge rstn) begin
		if(!rstn)	iter_switch <= 1'b0;
		else if((iter_cnt[ITER_ADDR_BW-1:0] >= ITER_ROM_GROUP))
			iter_switch <= 1'b1;
		else
			iter_switch <= 1'b0;
	end
endmodule
/*--------------------------------------------------------------------------------------------------*/

module cn_iter_counter #(
	parameter ITER_ADDR_BW = 6,  // bit-width of addressing 50 iterationss
	parameter MAX_ITER = 50
)(
	output reg [ITER_ADDR_BW-1:0] iter_cnt,
	
	input wire wr_iter_finish,
	input wire write_clk,
	input wire rstn
);
	always @(posedge write_clk, negedge rstn) begin
		if(rstn == 1'b0) iter_cnt[ITER_ADDR_BW-1:0] <= 0;
		else if(wr_iter_finish == 1'b1) iter_cnt[ITER_ADDR_BW-1:0] <= iter_cnt[ITER_ADDR_BW-1:0] + 1'b1;
		else iter_cnt[ITER_ADDR_BW-1:0] <= iter_cnt[ITER_ADDR_BW-1:0];
	end
endmodule

module c6rom_iter_mux #(
	parameter ROM_RD_BW = 6 // bit-width of one read port of BRAM based IB-ROM
)(
	output wire [ROM_RD_BW-1:0] dout,
	
	input wire [ROM_RD_BW-1:0] iter0_din,
	input wire [ROM_RD_BW-1:0] iter1_din,
	input wire iter_switch
);
	assign dout[ROM_RD_BW-1:0] = (iter_switch)? iter1_din[ROM_RD_BW-1:0] : iter0_din[ROM_RD_BW-1:0];
endmodule

module cn_mem_latch_route #(
	parameter ROM_RD_BW = 6    // bit-width of one read port of BRAM based IB-ROM
) (
	output wire [ROM_RD_BW-1:0] latch_outA,
	output wire [ROM_RD_BW-1:0] latch_outB,
	
	input wire [ROM_RD_BW-1:0] latch_inA,
	input wire [ROM_RD_BW-1:0] latch_inB
);
	assign latch_outA[ROM_RD_BW-1:0] = latch_inA[ROM_RD_BW-1:0];
	assign latch_outB[ROM_RD_BW-1:0] = latch_inB[ROM_RD_BW-1:0];
endmodule 

module cn_Waddr_counter #(
	parameter PAGE_ADDR_BW = 5, // bit-width of addressing (64-entry*3-bit)/ROM_RD_BW), i.e., ceil(log2((64-entry*3-bit)/ROM_RD_BW)))								
	parameter CN_LOAD_CYCLE = 32
) (
	(* max_fanout = 200 *) output reg [PAGE_ADDR_BW-1:0] wr_page_addr,
	output reg wr_iter_finish, // to notify the completion of iteration refresh 

	input wire en,
	input wire write_clk,
	input wire rstn
);

initial wr_page_addr[PAGE_ADDR_BW-1:0] <= 0;
always @(posedge write_clk, negedge rstn) begin
	if(!rstn) wr_page_addr[PAGE_ADDR_BW-1:0] <= 0;
	else if(en == 1'b1) wr_page_addr[PAGE_ADDR_BW-1:0] <= wr_page_addr[PAGE_ADDR_BW-1:0] + 1'b1;
end

initial wr_iter_finish <= 1'b0;
always @(posedge write_clk) begin
	if(wr_page_addr[PAGE_ADDR_BW-1:0] == 0)
		wr_iter_finish <= 1'b0;
	else if(wr_page_addr[PAGE_ADDR_BW-1:0] == CN_LOAD_CYCLE-1)
		wr_iter_finish <= 1'b1;
	else
		wr_iter_finish <= wr_iter_finish;
end
endmodule