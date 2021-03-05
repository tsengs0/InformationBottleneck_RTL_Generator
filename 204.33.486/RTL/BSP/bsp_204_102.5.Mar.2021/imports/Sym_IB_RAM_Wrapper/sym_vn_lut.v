module sym_vn_lut (
    output wire [3:0] lut_data0,
    output wire [3:0] lut_data1,
    output wire [3:0] lut_data2,
    output wire [3:0] lut_data3,
 
    input wire [3:0] lut_in,
    input wire [6:0] write_addr,
        
    input wire [6:0] read_addr0,
    input wire [6:0] read_addr1,
    input wire [6:0] read_addr2,
    input wire [6:0] read_addr3,
    
    input wire we,
    input wire write_clk
 );

    wire [6:0] syn_addr_port0_1;
	wire [6:0] syn_addr_port2_3;
	wire [3:0] syn_lut_data_port0_1;
	wire [3:0] syn_lut_data_port2_3;
    assign syn_addr_port0_1[6:0] = (we == 1'b1) ? write_addr[6:0] : read_addr1[6:0];
	assign syn_addr_port2_3[6:0] = (we == 1'b1) ? write_addr[6:0] : read_addr3[6:0];
	assign lut_data1[3:0] = (we == 1'b1) ? 4'bzzz : syn_lut_data_port0_1[3:0];
	assign lut_data3[3:0] = (we == 1'b1) ? 4'bzzz : syn_lut_data_port2_3[3:0];
   genvar i;
   generate
	for(i=0;i<4;i=i+1) begin: sym_vn_lutinst_port0_port1
		// RAM128X1D: 128-deep by 1-wide positive edge write, asynchronous read
		//            dual-port distributed LUT RAM (Mapped to four LUT6s)
		//            Kintex UltraScale+
		// Xilinx HDL Language Template, version 2019.2
		RAM128X1D #(
			//.INIT(128'h00000000000000000000000000000000),
			.IS_WCLK_INVERTED(1'b0) // Specifies active high/low WCLK
		) vn_port0_port1_bit0_4 (
			.DPO(lut_data0[i]),   // Read port 1-bit output
			.SPO(syn_lut_data_port0_1[i]),   // Read/write port 1-bit output
			
			.D(lut_in[i]),       // RAM data input
			
			.DPRA(read_addr0[6:0]),    // Read port 7-bit address input
			.A(syn_addr_port0_1[6:0]), // Read/write port 7-bit address input
			.WE(we),      		       // Write enable input
			.WCLK(write_clk) 		   // Write clock input
		);
		
		RAM128X1D #(
			//.INIT(128'h00000000000000000000000000000000),
			.IS_WCLK_INVERTED(1'b0) // Specifies active high/low WCLK
		) vn_port2_port3_bit0_4 (
			.DPO(lut_data2[i]),   // Read port 1-bit output
			.SPO(syn_lut_data_port2_3[i]),   // Read/write port 1-bit output
			
			.D(lut_in[i]),       // RAM data input
			
			.DPRA(read_addr2[6:0]),    // Read port 7-bit address input
			.A(syn_addr_port2_3[6:0]), // Read/write port 7-bit address input
			.WE(we),      		       // Write enable input
			.WCLK(write_clk) 		   // Write clock input
		);
	end
   endgenerate
endmodule