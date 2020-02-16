`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2020 09:35:33 PM
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


module ib_distributed_ram_bank(
    output [3:0] ib_ram_out,
    
    input wire [4:0] ib_ram_addr,
    input sys_clk
);


   // RAM32M: 32-deep by 8-wide Multi Port LUT RAM (Mapped to four SliceM LUT6s)
   //         Artix-7
   // Xilinx HDL Language Template, version 2019.2
   RAM32M #(
      .INIT_A(64'h0000000000000000), // Initial contents of A Port
      .INIT_B(64'h0000000000000000), // Initial contents of B Port
      .INIT_C(64'h0000000000000000), // Initial contents of C Port
      .INIT_D(64'h0000000000000000)  // Initial contents of D Port
   ) RAM32M_inst_0 (
      .DOA(ib_ram_out[3:2]),     // Read port A 2-bit output
      .DOB(),     // Read port B 2-bit output
      .DOC(),     // Read port C 2-bit output
      .DOD(),     // Read/write port D 2-bit output
      .ADDRA(ib_ram_addr[4:0]), // Read port A 5-bit address input
      .ADDRB(5'bx_xxxx), // Read port B 5-bit address input
      .ADDRC(5'bx_xxxx), // Read port C 5-bit address input
      .ADDRD(5'bx_xxxx), // Read/write port D 5-bit address input
      .DIA(2'bxx),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRA
      .DIB(2'bxx),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRB
      .DIC(2'bxx),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRC
      .DID(2'bxx),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRD
      .WCLK(sys_clk),   // Write clock input
      .WE(1'b0)        // Write enable input
   );
   
   RAM32M #(
      .INIT_A(64'h0000000000000000), // Initial contents of A Port
      .INIT_B(64'h0000000000000000), // Initial contents of B Port
      .INIT_C(64'h0000000000000000), // Initial contents of C Port
      .INIT_D(64'h0000000000000000)  // Initial contents of D Port
   ) RAM32M_inst_1 (
      .DOA(ib_ram_out[1:0]),     // Read port A 2-bit output
      .DOB(),     // Read port B 2-bit output
      .DOC(),     // Read port C 2-bit output
      .DOD(),     // Read/write port D 2-bit output
      .ADDRA(ib_ram_addr[4:0]), // Read port A 5-bit address input
      .ADDRB(5'bx_xxxx), // Read port B 5-bit address input
      .ADDRC(5'bx_xxxx), // Read port C 5-bit address input
      .ADDRD(5'bx_xxxx), // Read/write port D 5-bit address input
      .DIA(2'bxx),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRA
      .DIB(2'bxx),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRB
      .DIC(2'bxx),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRC
      .DID(2'bxx),     // RAM 2-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRD
      .WCLK(sys_clk),   // Write clock input
      .WE(1'b0)        // Write enable input
   );
endmodule
