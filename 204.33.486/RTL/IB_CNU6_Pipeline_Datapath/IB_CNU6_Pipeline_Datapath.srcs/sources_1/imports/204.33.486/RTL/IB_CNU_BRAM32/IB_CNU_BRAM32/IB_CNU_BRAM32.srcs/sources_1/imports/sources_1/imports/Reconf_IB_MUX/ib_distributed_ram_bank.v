`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2020, AM2:04
// Design Name: 
// Module Name: ib_distributed_ram
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
`include "define.v"
module ib_distributed_ram_bank
// #(
//    parameter inputA = 64'h0000000000000000,
//    parameter inputB = 64'h0000000000000001,
//    parameter inputC = 64'h0000000000000002,
//    parameter inputD = 64'h0000000000000003 
//)
(
    output [3:0] ib_ram_outA,
    output [3:0] ib_ram_outB,
    output [3:0] ib_ram_outC,
    output [3:0] ib_ram_outD,
    
    // Read Port Addresses
    input wire [4:0] ram_addr_readA, // asynchronous read address
    input wire [4:0] ram_addr_readB, // asynchronous read address
    input wire [4:0] ram_addr_readC, // asynchronous read address
    input wire [4:0] ram_addr_readD, // asynchronous read address
    // Write Port Addresses
    input wire [4:0] ram_addr_write, // synchronous write address
    // Write Qual-port
    input wire [`QUAN_SIZE-1:0] ib_ram_in,
    
    input wire write_en,
    input wire sys_clk
);
   wire [`QUAN_SIZE-1:0] ram_in_portABCD[0:3];
   assign ram_in_portABCD[0] = ib_ram_in[`QUAN_SIZE-1:0];
   assign ram_in_portABCD[1] = ib_ram_in[`QUAN_SIZE-1:0];
   assign ram_in_portABCD[2] = ib_ram_in[`QUAN_SIZE-1:0];
   assign ram_in_portABCD[3] = ib_ram_in[`QUAN_SIZE-1:0];
   wire [4:0] sync_addr;
   assign sync_addr[4:0] = (write_en == 1'b1) ? ram_addr_write[4:0] : ram_addr_readD;
   // RAM32M: 32-deep by 8-wide Multi Port LUT RAM (Mapped to four SliceM LUT6s)
   //         Artix-7
   // Xilinx HDL Language Template, version 2019.2
   RAM32M 
   // #(
   //    .INIT_A(inputA), // Initial contents of A Port
   //    .INIT_B(inputB), // Initial contents of B Port
   //    .INIT_C(inputC), // Initial contents of C Port
   //    .INIT_D(inputD)  // Initial contents of D Port
   // ) 
    RAM32M_inst_0 (
      .DOA(ib_ram_outA[3:2]),     // Read port A 2-bit output
      .DOB(ib_ram_outB[3:2]),     // Read port B 2-bit output
      .DOC(ib_ram_outC[3:2]),     // Read port C 2-bit output
      .DOD(ib_ram_outD[3:2]),     // Read/write port D 2-bit output
      .ADDRA(ram_addr_readA[4:0]), // Read port A 5-bit address input
      .ADDRB(ram_addr_readB[4:0]), // Read port B 5-bit address input
      .ADDRC(ram_addr_readC[4:0]), // Read port C 5-bit address input
      .ADDRD(sync_addr[4:0]), // Read/write port D 5-bit address input
      .DIA(ram_in_portABCD[0][3:2]),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRA
      .DIB(ram_in_portABCD[1][3:2]),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRB
      .DIC(ram_in_portABCD[2][3:2]),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRC
      .DID(ram_in_portABCD[3][3:2]),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRD
      .WCLK(sys_clk),   // Write clock input
      .WE(write_en)        // Write enable input
   );
   
   RAM32M 
 // #(
 //     .INIT_A(inputA), // Initial contents of A Port
 //     .INIT_B(inputB), // Initial contents of B Port
 //     .INIT_C(inputC), // Initial contents of C Port
 //     .INIT_D(inputD)  // Initial contents of D Port
 //  ) 
    RAM32M_inst_1 (
      .DOA(ib_ram_outA[1:0]),     // Read port A 2-bit output
      .DOB(ib_ram_outB[1:0]),     // Read port B 2-bit output
      .DOC(ib_ram_outC[1:0]),     // Read port C 2-bit output
      .DOD(ib_ram_outD[1:0]),     // Read/write port D 2-bit output
      .ADDRA(ram_addr_readA[4:0]), // Read port A 5-bit address input
      .ADDRB(ram_addr_readB[4:0]), // Read port B 5-bit address input
      .ADDRC(ram_addr_readC[4:0]), // Read port C 5-bit address input
      .ADDRD(sync_addr[4:0]), // Read/write port D 5-bit address input
      .DIA(ram_in_portABCD[0][1:0]),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRA
      .DIB(ram_in_portABCD[1][1:0]),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRB
      .DIC(ram_in_portABCD[2][1:0]),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRC
      .DID(ram_in_portABCD[3][1:0]),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRD
      .WCLK(sys_clk),   // Write clock input
      .WE(write_en)        // Write enable input
   );
endmodule
