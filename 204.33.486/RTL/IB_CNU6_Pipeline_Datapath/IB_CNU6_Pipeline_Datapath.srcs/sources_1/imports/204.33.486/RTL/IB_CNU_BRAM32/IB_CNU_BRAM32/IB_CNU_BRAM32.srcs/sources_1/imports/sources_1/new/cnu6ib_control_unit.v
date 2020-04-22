`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2020 04:18:16 PM
// Design Name: 
// Module Name: cnu6ib_control_unit
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
module cnu6ib_control_unit(
    output wire rom_port_fetch, // to enable the ib-map starting to fetch data from read port of ROM
    output wire ram_write_en,
    output wire ram_mux_en,
    output wire iter_update,
    output wire c6ib_rom_rst,
    output reg [2:0] state,
    
    input wire sys_clk,
    input wire rstn,
    input wire iter_rqst,
    input wire iter_termination,
    input wire pipeline_en
);
      
parameter IDLE       = 3'b000;
parameter ROM_FETCH0 = 3'b001; // only for the first write or non-pipeline fashion
parameter ROM_FETCH  = 3'b010;
parameter RAM_LOAD0  = 3'b011;
parameter RAM_LOAD1  = 3'b100;
parameter FINISH     = 3'b101;

initial state[2:0] <= IDLE;
wire idle_cond, finish_cond;
wire [2:0] in_cond;
assign in_cond[2:0] = {rstn, iter_rqst, iter_termination};
or u0 (idle_cond, rstn, iter_rqst, iter_termination);
or u1 (finish_cond, ~iter_rqst, iter_termination);
  
always @(negedge sys_clk) begin
   if (!idle_cond) begin
      state <= IDLE;
     // {ram_write_en, iter_update, c6ib_rom_rst} <= 3'b001;
   end
   else
      case (state[2:0])
         IDLE : begin
            if (!idle_cond)
               state <= IDLE;
            else if (in_cond[2:0] == 3'b110) begin // negedge
                if(pipeline_en == 1'b0)
                    state <= ROM_FETCH0;
                else
                    state <= ROM_FETCH;
            end
            else
               state <= IDLE;
           //{ram_write_en, iter_update, c6ib_rom_rst}  <= 3'b001;
         end
         
         ROM_FETCH0 : begin
            if (in_cond[2:0] == 3'b110)
               state <= RAM_LOAD0;
            else
               state <= ROM_FETCH0;
            //{ram_write_en, iter_update, c6ib_rom_rst} <= 3'b010;
         end
         
         ROM_FETCH : begin
            if (in_cond[2:0] == 3'b110)
               state <= RAM_LOAD0;
            else
               state <= ROM_FETCH;
            //{ram_write_en, iter_update, c6ib_rom_rst} <= 3'b010;
         end
         RAM_LOAD0 : begin 
            if (finish_cond)
               state <= FINISH;         
            else if (in_cond[2:0] == 3'b110)
               state <= RAM_LOAD1;
            else
               state <= RAM_LOAD0;
            //{ram_write_en, iter_update, c6ib_rom_rst} <= 3'b010;
         end
         RAM_LOAD1 : begin
            if (finish_cond)
               state <= FINISH;
            else if (in_cond[2:0] == 3'b110)
                if(pipeline_en == 1'b0)
                    state <= ROM_FETCH0;
                else
                    state <= ROM_FETCH;
            else
               state <= RAM_LOAD1;
            //{ram_write_en, iter_update, c6ib_rom_rst} <= 3'b110;
         end
         FINISH : begin
            state <= IDLE;
            //{ram_write_en, iter_update, c6ib_rom_rst} <= 3'b001;
         end                     
      endcase	
end	
/*
reg ram_write_en_latch;
initial ram_write_en_latch <= 1'b0;
always @(posedge sys_clk) begin
    ram_write_en_latch <= rom_port_fetch;
end
assign {rom_port_fetch, iter_update, c6ib_rom_rst, ram_write_en} = (state[2:0] == IDLE        ) ? {3'b001, ram_write_en_latch} :
                                                                   (state[2:0] == PRELOAD_ADDR) ? {3'b110, ram_write_en_latch} :
                                                                   (state[2:0] == PRELOAD_DATA) ? {3'b110, ram_write_en_latch} :
                                                                   (state[2:0] == RAM_LOAD    ) ? {3'b110, ram_write_en_latch} :
                                                                   (state[2:0] == BATCH_WRITE ) ? {3'b110, ram_write_en_latch} : 
                                                                                                  {3'b001, ram_write_en_latch};
*/
assign {rom_port_fetch, ram_mux_en, ram_write_en, iter_update, c6ib_rom_rst} = 
                                                                   /*State 0*/ (state[2:0] == IDLE      ) ? 5'b00001 :
                                                                   /*State 1*/ (state[2:0] == ROM_FETCH0) ? 5'b10010 :
                                                                   /*State 2*/ (state[2:0] == ROM_FETCH ) ? 5'b10110 :
                                                                   /*State 3*/ (state[2:0] == RAM_LOAD0 ) ? 5'b11010 :
                                                                   /*State 4*/ (state[2:0] == RAM_LOAD1 ) ? 5'b11110 :
                                                                   /*State 5*/                              5'b00001; // FINISH state
	
/* 
// Optimisation by Karnaugh maps                                                  
assign ram_write_en = ~state[2] & state[1];
assign iter_update = (state[2] & ~state[1] & ~state[0]) | (~state[2] & state[1]) | (~state[2] & state[0]);
assign c6ib_rom_rst = (~state[2] & ~state[1] & ~state[0]) | (state[2] & ~state[1] & state[0]); 
*/                                                										
endmodule