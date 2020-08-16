module sym_dn_lut (
    output wire lut_data0,
    output wire lut_data1,
    output wire lut_data2,
    output wire lut_data3,
 
    input wire lut_in, // written data
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
    assign syn_addr_port0_1[6:0] = (we == 1'b1) ? write_addr[6:0] : read_addr1[6:0];
	assign syn_addr_port2_3[6:0] = (we == 1'b1) ? write_addr[6:0] : read_addr3[6:0];
	
	// RAM128X1D: 128-deep by 1-wide positive edge write, asynchronous read
	//            dual-port distributed LUT RAM (Mapped to four LUT6s)
	//            Kintex UltraScale+
	// Xilinx HDL Language Template, version 2019.2
	RAM128X1D #(
		//.INIT(128'h00000000000000000000000000000000),
		.IS_WCLK_INVERTED(1'b0) // Specifies active high/low WCLK
	) dn_port0_port1 (
		.DPO(lut_data0),   // Read port 1-bit output
		.SPO(lut_data1),   // Read/write port 1-bit output
		
		.D(lut_in),       // RAM data input
		
		.DPRA(read_addr0[6:0]),    // Read port 7-bit address input
		.A(syn_addr_port0_1[6:0]), // Read/write port 7-bit address input
		.WE(we),      		       // Write enable input
		.WCLK(write_clk) 		   // Write clock input
	);
	
	RAM128X1D #(
		//.INIT(128'h00000000000000000000000000000000),
		.IS_WCLK_INVERTED(1'b0) // Specifies active high/low WCLK
	) dn_port2_port3 (
		.DPO(lut_data2),   // Read port 1-bit output
		.SPO(lut_data3),   // Read/write port 1-bit output
		
		.D(lut_in),       // RAM data input
		
		.DPRA(read_addr2[6:0]),    // Read port 7-bit address input
		.A(syn_addr_port2_3[6:0]), // Read/write port 7-bit address input
		.WE(we),      		       // Write enable input
		.WCLK(write_clk) 		   // Write clock input
	);
endmodule