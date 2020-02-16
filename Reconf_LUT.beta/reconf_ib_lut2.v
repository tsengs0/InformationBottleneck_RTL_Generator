`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2020 08:22:41 PM
// Design Name: 
// Module Name: reconf_ib_lut2
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
//`include "define.v"
`define QUAN_SIZE 4
`define IB_ADDR 8
`define CARDINALITY 16
`define RAM_DEPTH 256

module reconf_ib_lut2(
    output wire [`QUAN_SIZE-1:0] t_c,
    output wire [`IB_ADDR-1:0] ib_ram_addr,
    
    //input wire [`QUAN_SIZE-1:0] ib_ram_in, // read 4-bit result from distributed RAM
    input wire [`QUAN_SIZE-1:0] y1,
    input wire [`QUAN_SIZE-1:0] y0,
    input sys_clk
);
    
wire [4:0] bank_addr;
wire [`QUAN_SIZE-1:0] t_c_bank[0:7];
assign {bank_addr[4:0], t_c[`QUAN_SIZE-1:0]} = 
                        (ib_ram_addr[`IB_ADDR-1:0] < `IB_ADDR'd32)  ? {y1[0], y0[`QUAN_SIZE-1:0], t_c_bank[0]} : // for bank 0
                        (ib_ram_addr[`IB_ADDR-1:0] < `IB_ADDR'd48)  ? {1'b0 , y0[`QUAN_SIZE-1:0], t_c_bank[1]} : // for bank 1
                        (ib_ram_addr[`IB_ADDR-1:0] < `IB_ADDR'd64)  ? {1'b1 , y0[`QUAN_SIZE-1:0], t_c_bank[1]} : // for bank 1
                        (ib_ram_addr[`IB_ADDR-1:0] < `IB_ADDR'd80)  ? {1'b0 , y0[`QUAN_SIZE-1:0], t_c_bank[2]} : // for bank 2
                        (ib_ram_addr[`IB_ADDR-1:0] < `IB_ADDR'd96)  ? {1'b1 , y0[`QUAN_SIZE-1:0], t_c_bank[2]} : // for bank 2 
                        (ib_ram_addr[`IB_ADDR-1:0] < `IB_ADDR'd112) ? {1'b0 , y0[`QUAN_SIZE-1:0], t_c_bank[3]} : // for bank 3
                        (ib_ram_addr[`IB_ADDR-1:0] < `IB_ADDR'd128) ? {1'b1 , y0[`QUAN_SIZE-1:0], t_c_bank[3]} : // for bank 3 
                        (ib_ram_addr[`IB_ADDR-1:0] < `IB_ADDR'd144) ? {1'b0 , y0[`QUAN_SIZE-1:0], t_c_bank[4]} : // for bank 4
                        (ib_ram_addr[`IB_ADDR-1:0] < `IB_ADDR'd160) ? {1'b1 , y0[`QUAN_SIZE-1:0], t_c_bank[4]} : // for bank 4  
                        (ib_ram_addr[`IB_ADDR-1:0] < `IB_ADDR'd176) ? {1'b0 , y0[`QUAN_SIZE-1:0], t_c_bank[5]} : // for bank 5
                        (ib_ram_addr[`IB_ADDR-1:0] < `IB_ADDR'd192) ? {1'b1 , y0[`QUAN_SIZE-1:0], t_c_bank[5]} : // for bank 5 
                        (ib_ram_addr[`IB_ADDR-1:0] < `IB_ADDR'd208) ? {1'b0 , y0[`QUAN_SIZE-1:0], t_c_bank[6]} : // for bank 6
                        (ib_ram_addr[`IB_ADDR-1:0] < `IB_ADDR'd224) ? {1'b1 , y0[`QUAN_SIZE-1:0], t_c_bank[6]} : // for bank 6 
                        (ib_ram_addr[`IB_ADDR-1:0] < `IB_ADDR'd240) ? {1'b0 , y0[`QUAN_SIZE-1:0], t_c_bank[7]} : // for bank 7
                                                                      {1'b1 , y0[`QUAN_SIZE-1:0], t_c_bank[7]};  // for bank 7
                                                                                                                                         
ib_distributed_ram_bank bank_0 (
    .ib_ram_out  (t_c_bank[0]),
    .ib_ram_addr (ib_ram_addr[`IB_ADDR-1:0]),
    .sys_clk     (sys_clk)    
);

ib_distributed_ram_bank bank_1 (
    .ib_ram_out  (t_c_bank[1]),
    .ib_ram_addr (ib_ram_addr[`IB_ADDR-1:0]),
    .sys_clk     (sys_clk)    
);

ib_distributed_ram_bank bank_2 (
    .ib_ram_out  (t_c_bank[2]),
    .ib_ram_addr (ib_ram_addr[`IB_ADDR-1:0]),
    .sys_clk     (sys_clk)    
);

ib_distributed_ram_bank bank_3 (
    .ib_ram_out  (t_c_bank[3]),
    .ib_ram_addr (ib_ram_addr[`IB_ADDR-1:0]),
    .sys_clk     (sys_clk)    
);

ib_distributed_ram_bank bank_4 (
    .ib_ram_out  (t_c_bank[4]),
    .ib_ram_addr (ib_ram_addr[`IB_ADDR-1:0]),
    .sys_clk     (sys_clk)    
);

ib_distributed_ram_bank bank_5 (
    .ib_ram_out  (t_c_bank[5]),
    .ib_ram_addr (ib_ram_addr[`IB_ADDR-1:0]),
    .sys_clk     (sys_clk)    
);

ib_distributed_ram_bank bank_6 (
    .ib_ram_out  (t_c_bank[6]),
    .ib_ram_addr (ib_ram_addr[`IB_ADDR-1:0]),
    .sys_clk     (sys_clk)    
);

ib_distributed_ram_bank bank_7 (
    .ib_ram_out  (t_c_bank[7]),
    .ib_ram_addr (ib_ram_addr[`IB_ADDR-1:0]),
    .sys_clk     (sys_clk)    
);
 
//always @(posedge sys_clk) begin
//    t_c[`QUAN_SIZE-1:0] <= ib_ram_in;
//end
endmodule


