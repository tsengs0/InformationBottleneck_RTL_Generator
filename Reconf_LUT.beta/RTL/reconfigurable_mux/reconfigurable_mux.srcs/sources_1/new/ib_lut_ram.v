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

module ib_lut_ram(
    output wire [`QUAN_SIZE-1:0] t_c_bank0,
    output wire [`QUAN_SIZE-1:0] t_c_bank1,
    output wire [`QUAN_SIZE-1:0] t_c_bank2,
    output wire [`QUAN_SIZE-1:0] t_c_bank3,
    output wire [`QUAN_SIZE-1:0] t_c_bank4,
    output wire [`QUAN_SIZE-1:0] t_c_bank5,
    output wire [`QUAN_SIZE-1:0] t_c_bank6,
    output wire [`QUAN_SIZE-1:0] t_c_bank7,
    
    input wire [4:0] ib_ram_addr,
    input sys_clk
);
    
wire [4:0] ib_ram_addr;
                                                                                                                                       
ib_distributed_ram_bank #(
    .inputA(64'h0000000000000000), 
    .inputB(64'h0000000000000001),
    .inputC(64'h0000000000000002),
    .inputD(64'h0000000000000003)
) bank_0 (
    .ib_ram_out  (t_c_bank0),
    .ib_ram_addr (ib_ram_addr[4:0]),
    .sys_clk     (sys_clk)    
);

ib_distributed_ram_bank #(
    .inputA(64'h0000000000000010), 
    .inputB(64'h0000000000000011),
    .inputC(64'h0000000000000012),
    .inputD(64'h0000000000000013)
) bank_1 (
    .ib_ram_out  (t_c_bank1),
    .ib_ram_addr (ib_ram_addr[4:0]),
    .sys_clk     (sys_clk)    
);

ib_distributed_ram_bank #(
    .inputA(64'h0000000000000020), 
    .inputB(64'h0000000000000021),
    .inputC(64'h0000000000000022),
    .inputD(64'h0000000000000023)
) bank_2 (
    .ib_ram_out  (t_c_bank2),
    .ib_ram_addr (ib_ram_addr[4:0]),
    .sys_clk     (sys_clk)    
);

ib_distributed_ram_bank #(
    .inputA(64'h0000000000000030), 
    .inputB(64'h0000000000000031),
    .inputC(64'h0000000000000032),
    .inputD(64'h0000000000000033)
) bank_3 (
    .ib_ram_out  (t_c_bank3),
    .ib_ram_addr (ib_ram_addr[4:0]),
    .sys_clk     (sys_clk)    
);

ib_distributed_ram_bank #(
    .inputA(64'h0000000000000040), 
    .inputB(64'h0000000000000041),
    .inputC(64'h0000000000000042),
    .inputD(64'h0000000000000043)
) bank_4 (
    .ib_ram_out  (t_c_bank4),
    .ib_ram_addr (ib_ram_addr[4:0]),
    .sys_clk     (sys_clk)    
);

ib_distributed_ram_bank #(
    .inputA(64'h0000000000000050), 
    .inputB(64'h0000000000000051),
    .inputC(64'h0000000000000052),
    .inputD(64'h0000000000000053)
) bank_5 (
    .ib_ram_out  (t_c_bank5),
    .ib_ram_addr (ib_ram_addr[4:0]),
    .sys_clk     (sys_clk)    
);

ib_distributed_ram_bank #(
    .inputA(64'h0000000000000060), 
    .inputB(64'h0000000000000061),
    .inputC(64'h0000000000000062),
    .inputD(64'h0000000000000063)
) bank_6 (
    .ib_ram_out  (t_c_bank6),
    .ib_ram_addr (ib_ram_addr[4:0]),
    .sys_clk     (sys_clk)    
);

ib_distributed_ram_bank #(
    .inputA(64'h0000000000000070), 
    .inputB(64'h0000000000000071),
    .inputC(64'h0000000000000072),
    .inputD(64'h0000000000000073)
) bank_7 (
    .ib_ram_out  (t_c_bank7),
    .ib_ram_addr (ib_ram_addr[4:0]),
    .sys_clk     (sys_clk)    
);
 
endmodule

