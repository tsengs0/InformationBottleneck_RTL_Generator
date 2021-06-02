module sym_cn_lut #(
  parameter QUAN_SIZE = 2,
  parameter ENTRY_ADDR = 4
)(
    output wire [QUAN_SIZE-1:0] lut_data0,
    output wire [QUAN_SIZE-1:0] lut_data1,
    output wire [QUAN_SIZE-1:0] lut_data2,
    output wire [QUAN_SIZE-1:0] lut_data3,
 
    input wire [QUAN_SIZE-1:0] lut_in,
    input wire [ENTRY_ADDR-1:0] write_addr,
        
    input wire [ENTRY_ADDR-1:0] read_addr0,
    input wire [ENTRY_ADDR-1:0] read_addr1,
    input wire [ENTRY_ADDR-1:0] read_addr2,
    input wire [ENTRY_ADDR-1:0] read_addr3,
    
    input wire we,
    input wire write_clk
 );

  wire [QUAN_SIZE-1:0] lut_data_port [0:3];
  wire [ENTRY_ADDR-1:0] read_addr_port [0:3];
  genvar i;
  generate
    for(i=0;i<4/*4 ports instantiation*/;i=i+1) begin : four_port_inst
      // RAM32X2S: 32 x 2 posedge write distributed (LUT) RAM (Mapped to a SliceM LUT6)
      //           Kintex-7
      // Xilinx HDL Language Template, version 2019.2
      RAM32X2S #(
         .INIT_00(32'h00000000), // INIT for bit 0 of RAM
         .INIT_01(32'h00000000)  // INIT for bit 1 of RAM
      ) RAM32X2S_inst_port03 (
         .O0(lut_data_port[i][0]),     // RAM data[0] output
         .O1(lut_data_port[i][1]),     // RAM data[1] output
         .A0(read_addr_port[i][0]),     // RAM address[0] input
         .A1(read_addr_port[i][1]),     // RAM address[1] input
         .A2(read_addr_port[i][2]),     // RAM address[2] input
         .A3(read_addr_port[i][3]),     // RAM address[3] input
         .A4(1'b0         ),     // RAM address[4] input
         .D0(lut_in[0]),     // RAM data[0] input
         .D1(lut_in[1]),     // RAM data[1] input
         .WCLK(write_clk), // Write clock input
         .WE(we)      // Write enable input
      );
    end
  endgenerate
  assign lut_data0[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[0];
  assign lut_data1[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[1];
  assign lut_data2[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[2];
  assign lut_data3[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[3];
  assign read_addr_port[0] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr0[ENTRY_ADDR-1:0];
  assign read_addr_port[1] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr1[ENTRY_ADDR-1:0];
  assign read_addr_port[2] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr2[ENTRY_ADDR-1:0];
  assign read_addr_port[3] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr3[ENTRY_ADDR-1:0];
endmodule