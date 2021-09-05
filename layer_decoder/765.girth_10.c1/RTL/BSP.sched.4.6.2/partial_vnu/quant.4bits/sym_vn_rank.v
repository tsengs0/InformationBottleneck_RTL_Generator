module sym_vn_rank (
	output wire [3:0] lut_data0,   
	output wire [3:0] lut_data1,   

	// For VNU0
	input wire bank_addr_0,
	input wire [5:0] page_addr_0,
	input wire page_addr_offset_0,
	// For VNU1
	input wire bank_addr_1,
	input wire [5:0] page_addr_1,
	input wire page_addr_offset_1,
	
	input wire [3:0] lut_in_bank0, // update data in  
	input wire [3:0] lut_in_bank1, // update data in

	input wire [5:0] page_write_addr,
	input wire write_addr_offset,

   	input wire we,
	input wire write_clk
);

	wire [3:0] bank0_out0, bank1_out0;
	wire [3:0] bank0_out1, bank1_out1;
	assign lut_data0[3:0] = (bank_addr_0 == 1'b0) ? bank0_out0[3:0] : bank1_out0[3:0];
	assign lut_data1[3:0] = (bank_addr_1 == 1'b0) ? bank0_out1[3:0] : bank1_out1[3:0];

 sym_vn_lut bank0(
	.lut_data0 (bank0_out0[3:0]),
	.lut_data1 (bank0_out1[3:0]),
 
	// Write data and page address
	.lut_in (lut_in_bank0[3:0]),
	.write_addr ({write_addr_offset, page_write_addr[5:0]}),
        
	// Read page address and address offset
	.read_addr0 ({page_addr_offset_0, page_addr_0}),
	.read_addr1 ({page_addr_offset_1, page_addr_1}),
    
	.we (we),
	.write_clk (write_clk)
 );
 
 sym_vn_lut bank1(
	.lut_data0 (bank1_out0[3:0]),
	.lut_data1 (bank1_out1[3:0]),
 
	// Write data and page address
	.lut_in (lut_in_bank1[3:0]),
	.write_addr ({write_addr_offset, page_write_addr[5:0]}),
        
	// Read page address and address offset
	.read_addr0 ({page_addr_offset_0, page_addr_0}),
	.read_addr1 ({page_addr_offset_1, page_addr_1}),
    
	.we (we),
	.write_clk (write_clk)
 );
endmodule