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
    output wire ram_write_en,
    output wire iter_update,
    output wire c6ib_rom_rst,
    output reg [2:0] state,
    
    input wire sys_clk,
    input wire rstn,
    input wire iter_rqst,
    input wire iter_termination
);
      
parameter IDLE         = 3'b000;
parameter PRELOAD_ADDR = 3'b001;
parameter PRELOAD_DATA = 3'b010;
parameter RAM_LOAD     = 3'b011;
parameter BATCH_WRITE  = 3'b100;
parameter FINISH       = 3'b101;

initial state[2:0] <= IDLE;
wire idle_cond, finish_cond;
wire [2:0] in_cond;
assign in_cond[2:0] = {rstn, iter_rqst, iter_termination};
or u0 (idle_cond, rstn, iter_rqst, iter_termination);
or u1 (finish_cond, !iter_rqst, iter_termination);
  
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
               state <= PRELOAD_ADDR;
            end
            else
               state <= IDLE;
           //{ram_write_en, iter_update, c6ib_rom_rst}  <= 3'b001;
         end
         PRELOAD_ADDR : begin
            if (in_cond[2:0] == 3'b110)
               state <= PRELOAD_DATA;
            else
               state <= PRELOAD_ADDR;
            //{ram_write_en, iter_update, c6ib_rom_rst} <= 3'b010;
         end
         PRELOAD_DATA : begin
            if (in_cond[2:0] == 3'b110)
               state <= RAM_LOAD;
            else
               state <= PRELOAD_DATA;
            //{ram_write_en, iter_update, c6ib_rom_rst} <= 3'b010;
         end
         RAM_LOAD : begin
            if (in_cond[2:0] == 3'b110)
               state <= BATCH_WRITE;
            else
               state <= RAM_LOAD;
            //{ram_write_en, iter_update, c6ib_rom_rst} <= 3'b110;
         end
         BATCH_WRITE : begin
            if (in_cond[2:0] == 3'b110)
               state <= BATCH_WRITE;
            else if(finish_cond)
               state <= FINISH;
            //{ram_write_en, iter_update, c6ib_rom_rst} <= 3'b110;
         end 
         FINISH : begin
            state <= IDLE;
            //{ram_write_en, iter_update, c6ib_rom_rst} <= 3'b001;
         end                     
      endcase	
end	


assign {ram_write_en, iter_update, c6ib_rom_rst} = (state[2:0] == IDLE        ) ? 3'b001 :
                                                   (state[2:0] == PRELOAD_ADDR) ? 3'b010 :
                                                   (state[2:0] == PRELOAD_DATA) ? 3'b110 :
                                                   (state[2:0] == RAM_LOAD    ) ? 3'b110 :
                                                   (state[2:0] == BATCH_WRITE ) ? 3'b110 : 3'b001;
	
/* 
// Optimisation by Karnaugh maps                                                  
assign ram_write_en = ~state[2] & state[1];
assign iter_update = (state[2] & ~state[1] & ~state[0]) | (~state[2] & state[1]) | (~state[2] & state[0]);
assign c6ib_rom_rst = (~state[2] & ~state[1] & ~state[0]) | (state[2] & ~state[1] & state[0]); 
*/                                                										
endmodule