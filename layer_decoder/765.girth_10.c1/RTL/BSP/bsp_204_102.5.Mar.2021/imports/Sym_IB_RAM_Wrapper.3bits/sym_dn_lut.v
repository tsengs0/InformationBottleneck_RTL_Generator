module sym_dn_lut #(
  parameter ENTRY_ADDR = 5
) (
    output wire lut_data0,
    output wire lut_data1,
    output wire lut_data2,
    output wire lut_data3,
 
    input wire lut_in,
    input wire [ENTRY_ADDR-1:0] write_addr,
        
    input wire [ENTRY_ADDR-1:0] read_addr0,
    input wire [ENTRY_ADDR-1:0] read_addr1,
    input wire [ENTRY_ADDR-1:0] read_addr2,
    input wire [ENTRY_ADDR-1:0] read_addr3,
    
    input wire we,
    input wire write_clk
 );

wire [3:0] lut_data_port;
wire [ENTRY_ADDR-1:0] read_addr_port [0:3];
genvar i;
generate
  for(i=0;i<4/*4 ports instantiation*/;i=i+1) begin : four_port_inst
    // RAM32X1S: 32 x 1 posedge write distributed (LUT) RAM (Mapped to a LUT6)
    //           Kintex UltraScale+
    // Xilinx HDL Language Template, version 2019.2
    RAM32X1S #(
       .INIT(32'h00000000),    // Initial contents of RAM
       .IS_WCLK_INVERTED(1'b0) // Specifies active high/low WCLK
    ) RAM32X1S_inst_msb_port03 (
       .O(lut_data_port[i]),       // RAM output
       .A0(read_addr_port[i][0]),     // RAM address[0] input
       .A1(read_addr_port[i][1]),     // RAM address[1] input
       .A2(read_addr_port[i][2]),     // RAM address[2] input
       .A3(read_addr_port[i][3]),     // RAM address[3] input
       .A4(read_addr_port[i][4]),     // RAM address[4] input
       .D(lut_in),       // RAM data input
       .WCLK(write_clk), // Write clock input
       .WE(we)      // Write enable input
    );
  end
endgenerate
assign lut_data0 = (we == 1'b1) ? 1'bz : lut_data_port[0];
assign lut_data1 = (we == 1'b1) ? 1'bz : lut_data_port[1];
assign lut_data2 = (we == 1'b1) ? 1'bz : lut_data_port[2];
assign lut_data3 = (we == 1'b1) ? 1'bz : lut_data_port[3];
assign read_addr_port[0] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr0[ENTRY_ADDR-1:0];
assign read_addr_port[1] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr1[ENTRY_ADDR-1:0];
assign read_addr_port[2] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr2[ENTRY_ADDR-1:0];
assign read_addr_port[3] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr3[ENTRY_ADDR-1:0];
endmodule