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

module dn_mem_latch #(
	parameter ROM_RD_BW = 2,    // bit-width of one read port of BRAM based IB-ROM
	parameter ROM_ADDR_BW = 11,  // bit-width of read address of BRAM based IB-ROM
								// #Entry: (128-entry*1-bit) / ROM_RD_BW)*25-iteration
								// ceil(log2(#Entry)) = 11-bit
							    
	parameter PAGE_ADDR_BW = 6, // bit-width of addressing (128-entry*1-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*1-bit)/ROM_RD_BW)))								
    parameter ITER_ADDR_BW = 5  // bit-width of addressing 25 iterationss
	//parameter VN_TYPE_A = 1,    // the number of variable node types in terms of its check node degree   
	//parameter VN_TYPE_B = 1     // the number of variable node types in terms of its check node degree
)(
	output reg [ROM_RD_BW-1:0] latch_outA,
	output reg [ROM_RD_BW-1:0] latch_outB,
	output reg [ROM_ADDR_BW-1:0] rom_read_addrA,
	output reg [ROM_ADDR_BW-1:0] rom_read_addrB,
	
	input wire [ROM_RD_BW-1:0] latch_inA,
	input wire [ROM_RD_BW-1:0] latch_inB,
	input wire [ITER_ADDR_BW-1:0] latch_iterA, // base address for latch A to indicate the iteration index
	input wire [ITER_ADDR_BW-1:0] latch_iterB, // base address for latch B to indicate the iteration index
	//input wire [VN_TYPE_A-1:0] latch_typeA,
	//input wire [VN_TYPE_B-1:0] latch_typeB,
	input wire rstn, // asserted/deasserted by "rom_port_fetch" signal of Iteration Update Control Unit
	input wire write_clk
);

initial rom_read_addrA <= 0;
always @(posedge write_clk, negedge rstn) begin
	if(!rstn) rom_read_addrA[ROM_ADDR_BW-1:0] <= {latch_iterA[ITER_ADDR_BW-1:0], {PAGE_ADDR_BW{1'b0}}};
	else      rom_read_addrA[ROM_ADDR_BW-1:0] <= rom_read_addrA[ROM_ADDR_BW-1:0] + 1'b1;
end
initial rom_read_addrB <= 0;
always @(posedge write_clk, negedge rstn) begin
	if(!rstn) rom_read_addrB[ROM_ADDR_BW-1:0] <= {latch_iterB[ITER_ADDR_BW-1:0], {PAGE_ADDR_BW{1'b0}}};
	else      rom_read_addrB[ROM_ADDR_BW-1:0] <= rom_read_addrB[ROM_ADDR_BW-1:0] + 1'b1;
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

module d3rom_iter_selector #(
	parameter ITER_ADDR_BW = 5  // bit-width of addressing 25 iterationss
) (
	output reg iter_switch,
	input wire [ITER_ADDR_BW-1:0] rom_read_addr,
	input wire write_clk,
	input wire rstn
);
	initial iter_switch <= 1'b0;
	always @(posedge write_clk, negedge rstn) begin
		if(!rstn)	iter_switch <= 1'b0;
		else if((rom_read_addr[ITER_ADDR_BW-1:0] == 'd24))
			iter_switch <= ~iter_switch;
	end
endmodule

// Whenever a IB-ROM data fetch is requested, all associated IB-ROMs are fetched page data,
// regardless of the requesed iteration group. And then, the iteration switch determined by 
// the Module "rom_iter_selector", is going to select the source data from either Iter0_24 or 
// Iter25_49
module d3rom_iter_mux #(
	parameter ROM_RD_BW = 2 // bit-width of one read port of BRAM based IB-ROM
)(
	output wire [ROM_RD_BW-1:0] dout,
	
	input wire [ROM_RD_BW-1:0] iter0_din,
	input wire [ROM_RD_BW-1:0] iter1_din,
	input wire iter_switch
);
	assign dout[ROM_RD_BW-1:0] = (iter_switch)? iter1_din[ROM_RD_BW-1:0] : iter0_din[ROM_RD_BW-1:0];
endmodule

// Under a fully-parallel architecture, the routes connecting the Mem Latch data with target IB-RAM write_data_in
// are all directly linked
module dn_mem_latch_route #(
	parameter ROM_RD_BW = 2    // bit-width of one read port of BRAM based IB-ROM
) (
	output wire [ROM_RD_BW-1:0] latch_outA,
	output wire [ROM_RD_BW-1:0] latch_outB,
	
	input wire [ROM_RD_BW-1:0] latch_inA,
	input wire [ROM_RD_BW-1:0] latch_inB
);
	assign latch_outA[ROM_RD_BW-1:0] = latch_inA[ROM_RD_BW-1:0];
	assign latch_outB[ROM_RD_BW-1:0] = latch_inB[ROM_RD_BW-1:0];
endmodule 

module dnu3_wr_fsm #(
	parameter LOAD_CYCLE = 64 // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update 
) (
	output wire rom_port_fetch, // to enable the ib-map starting to fetch data from read port of IB ROM
    output wire ram_write_en,
    output wire ram_mux_en,
    output wire iter_update,
    output wire v3ib_rom_rst,
	output wire [1:0] busy, // 00b: not busy at IDLE state; 01b: busy with update operations; 10b: not busy at FINISH state
    output reg [2:0] state,
    
    input wire write_clk,
    input wire rstn,
    input wire iter_rqst,
    input wire iter_termination
);

localparam IDLE       = 3'b000;
localparam ROM_FETCH0 = 3'b001; // only for the first write or non-pipeline fashion
localparam RAM_LOAD0  = 3'b010;
localparam RAM_LOAD1  = 3'b011;
localparam FINISH     = 3'b100;

parameter CNT_WIDTH = $clog2(LOAD_CYCLE);
reg [CNT_WIDTH-1:0] write_cnt;
initial write_cnt[CNT_WIDTH-1:0] <= 0;
always @(posedge write_clk, negedge rstn) begin
	if(!rstn) 
		write_cnt[CNT_WIDTH-1:0] <= 0;
	else if(!ram_write_en)
		write_cnt[CNT_WIDTH-1:0] <= 0;
	else
		write_cnt[CNT_WIDTH-1:0] <= write_cnt[CNT_WIDTH-1:0] + 1'b1;
end

initial state[2:0] <= IDLE;
wire idle_cond, finish_cond;
wire [2:0] in_cond;
assign in_cond[2:0] = {rstn, iter_rqst, iter_termination};
or u0 (idle_cond, rstn, iter_rqst, iter_termination);
or u1 (finish_cond, ~iter_rqst, iter_termination);

always @(posedge write_clk) begin
   if (!idle_cond) begin
      state <= IDLE;
   end
   else
      case (state[2:0])
         IDLE : begin
            if (!idle_cond)
               state <= IDLE;
            else if (in_cond[2:0] == 3'b110) begin // negedge
                state <= ROM_FETCH0;
            end
            else
               state <= IDLE;
         end
         
         ROM_FETCH0 : begin
            if (in_cond[2:0] == 3'b110)
               state <= RAM_LOAD0;
            else
               state <= ROM_FETCH0;
         end
         
         RAM_LOAD0 : begin 
            if (finish_cond)
               state <= FINISH;         
            else if (in_cond[2:0] == 3'b110)
               state <= RAM_LOAD1;
            else
               state <= RAM_LOAD0;
         end
         RAM_LOAD1 : begin
            if (finish_cond)
               state <= FINISH;
            else if (write_cnt[CNT_WIDTH-1:0] == LOAD_CYCLE-1)
				state <= FINISH;
            else
				state <= RAM_LOAD1;
         end
         FINISH : begin
            state <= IDLE;
         end                     
      endcase	
end	
/*
reg ram_write_en_latch;
initial ram_write_en_latch <= 1'b0;
always @(posedge sys_clk) begin
    ram_write_en_latch <= rom_port_fetch;
end
assign {rom_port_fetch, iter_update, v3ib_rom_rst, ram_write_en} = (state[2:0] == IDLE        ) ? {3'b001, ram_write_en_latch} :
                                                                   (state[2:0] == PRELOAD_ADDR) ? {3'b110, ram_write_en_latch} :
                                                                   (state[2:0] == PRELOAD_DATA) ? {3'b110, ram_write_en_latch} :
                                                                   (state[2:0] == RAM_LOAD    ) ? {3'b110, ram_write_en_latch} :
                                                                   (state[2:0] == BATCH_WRITE ) ? {3'b110, ram_write_en_latch} : 
                                                                                                  {3'b001, ram_write_en_latch};
*/
assign {rom_port_fetch, ram_mux_en, ram_write_en, iter_update, v3ib_rom_rst, busy[1:0]} = 
                                                                   /*State 0*/ (state[2:0] == IDLE      ) ? 7'b0000100 :
                                                                   /*State 1*/ (state[2:0] == ROM_FETCH0) ? 7'b1001001 :
                                                                   /*State 2*/ (state[2:0] == RAM_LOAD0 ) ? 7'b1101001 :
                                                                   /*State 3*/ (state[2:0] == RAM_LOAD1 ) ? 7'b1111001 :
                                                                   /*State 4*/                              7'b0000110; // FINISH state	
/* 
// Optimisation by Karnaugh maps                                                  
assign ram_write_en = ~state[2] & state[1];
assign iter_update = (state[2] & ~state[1] & ~state[0]) | (~state[2] & state[1]) | (~state[2] & state[0]);
assign v3ib_rom_rst = (~state[2] & ~state[1] & ~state[0]) | (state[2] & ~state[1] & state[0]); 
*/     
endmodule

module dn_Waddr_counter #(
	parameter PAGE_ADDR_BW = 6  // bit-width of addressing (128-entry*1-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*1-bit)/ROM_RD_BW)))								
) (
	output reg [PAGE_ADDR_BW-1:0] wr_page_addr,
	
	input wire en,
	input wire write_clk,
	input wire rstn
);

initial wr_page_addr[PAGE_ADDR_BW-1:0] <= 0;
always @(posedge write_clk, negedge rstn) begin
	if(!rstn) wr_page_addr[PAGE_ADDR_BW-1:0] <= 0;
	else if(en == 1'b1) wr_page_addr[PAGE_ADDR_BW-1:0] <= wr_page_addr[PAGE_ADDR_BW-1:0] + 1'b1;
end
endmodule