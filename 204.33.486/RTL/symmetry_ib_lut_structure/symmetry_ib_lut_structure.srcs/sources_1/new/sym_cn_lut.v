module sym_cn_lut (
    output [2:0] lut_data0,
    output [2:0] lut_data1,
    output [2:0] lut_data2,
    output [2:0] lut_data3,
 
    input wire [2:0] lut_in,
    input wire [5:0] write_addr,
        
    input wire [5:0] read_addr0,
    input wire [5:0] read_addr1,
    input wire [5:0] read_addr2,
    input wire [5:0] read_addr3,
    
    input wire we,
    input wire write_clk
 );

    wire [5:0] syn_addr;
    assign syn_addr[5:0] = (we == 1'b1) ? write_addr[5:0] : read_addr3[5:0];
   // RAM64M: 64-deep by 4-wide Multi Port LUT RAM (Mapped to four LUT6s)
   //         Kintex UltraScale+
   // Xilinx HDL Language Template, version 2019.2
   RAM64M #(
      //.INIT_A(64'h0000000000000000), // Initial contents of A Port
      //.INIT_B(64'h0000000000000000), // Initial contents of B Port
      //.INIT_C(64'h0000000000000000), // Initial contents of C Port
      //.INIT_D(64'h0000000000000000), // Initial contents of D Port
      .IS_WCLK_INVERTED(1'b0)        // Specifies active high/low WCLK
   ) cn_bit0 (
      .DOA(lut_data0[0]),     // Read port A 1-bit output
      .DOB(lut_data1[0]),     // Read port B 1-bit output
      .DOC(lut_data2[0]),     // Read port C 1-bit output
      .DOD(lut_data3[0]),     // Read/write port D 1-bit output
      
      .DIA(lut_in[0]),     // RAM 1-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRA
      .DIB(lut_in[0]),     // RAM 1-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRB
      .DIC(lut_in[0]),     // RAM 1-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRC
      .DID(lut_in[0]),     // RAM 1-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRD
      .ADDRA(read_addr0[5:0]), // Read port A 6-bit address input
      .ADDRB(read_addr1[5:0]), // Read port B 6-bit address input
      .ADDRC(read_addr2[5:0]), // Read port C 6-bit address input
      .ADDRD(syn_addr[5:0]), // Read/write port D 6-bit address input
      .WE(we),       // Write enable input
      .WCLK(write_clk)    // Write clock input
   );
   
   RAM64M #(
      //.INIT_A(64'h0000000000000000), // Initial contents of A Port
      //.INIT_B(64'h0000000000000000), // Initial contents of B Port
      //.INIT_C(64'h0000000000000000), // Initial contents of C Port
      //.INIT_D(64'h0000000000000000), // Initial contents of D Port
      .IS_WCLK_INVERTED(1'b0)        // Specifies active high/low WCLK
   ) cn_bit1 (
      .DOA(lut_data0[1]),     // Read port A 1-bit output
      .DOB(lut_data1[1]),     // Read port B 1-bit output
      .DOC(lut_data2[1]),     // Read port C 1-bit output
      .DOD(lut_data3[1]),     // Read/write port D 1-bit output
      
      .DIA(lut_in[1]),     // RAM 1-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRA
      .DIB(lut_in[1]),     // RAM 1-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRB
      .DIC(lut_in[1]),     // RAM 1-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRC
      .DID(lut_in[1]),     // RAM 1-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRD
      .ADDRA(read_addr0[5:0]), // Read port A 6-bit address input
      .ADDRB(read_addr1[5:0]), // Read port B 6-bit address input
      .ADDRC(read_addr2[5:0]), // Read port C 6-bit address input
      .ADDRD(syn_addr[5:0]), // Read/write port D 6-bit address input
      .WE(we),       // Write enable input
      .WCLK(write_clk)    // Write clock input
   );
   
   RAM64M #(
      //.INIT_A(64'h0000000000000000), // Initial contents of A Port
      //.INIT_B(64'h0000000000000000), // Initial contents of B Port
      //.INIT_C(64'h0000000000000000), // Initial contents of C Port
      //.INIT_D(64'h0000000000000000), // Initial contents of D Port
      .IS_WCLK_INVERTED(1'b0)        // Specifies active high/low WCLK
   ) cn_bit2 (
      .DOA(lut_data0[2]),     // Read port A 1-bit output
      .DOB(lut_data1[2]),     // Read port B 1-bit output
      .DOC(lut_data2[2]),     // Read port C 1-bit output
      .DOD(lut_data3[2]),     // Read/write port D 1-bit output
      
      .DIA(lut_in[2]),     // RAM 1-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRA
      .DIB(lut_in[2]),     // RAM 1-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRB
      .DIC(lut_in[2]),     // RAM 1-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRC
      .DID(lut_in[2]),     // RAM 1-bit data write input addressed by ADDRD,
                     //   read addressed by ADDRD
      .ADDRA(read_addr0[5:0]), // Read port A 6-bit address input
      .ADDRB(read_addr1[5:0]), // Read port B 6-bit address input
      .ADDRC(read_addr2[5:0]), // Read port C 6-bit address input
      .ADDRD(syn_addr[5:0]), // Read/write port D 6-bit address input
      .WE(we),       // Write enable input
      .WCLK(write_clk)    // Write clock input
   );        
   // End of RAM64M_inst instantiation
endmodule