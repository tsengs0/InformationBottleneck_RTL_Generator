module sym_vn_rank (
	output wire [3:0] lut_data0,   
	output wire [3:0] lut_data1,   
	output wire [3:0] lut_data2,   
	output wire [3:0] lut_data3,

	// For VNU0
	input wire bank_addr_0,
	input wire [5:0] page_addr_0,
	input wire page_addr_offset_0,
	// For VNU1
	input wire bank_addr_1,
	input wire [5:0] page_addr_1,
	input wire page_addr_offset_1,
	// For VNU2
	input wire bank_addr_2,
	input wire [5:0] page_addr_2,
	input wire page_addr_offset_2,
	// For VNU3
	input wire bank_addr_3,
	input wire [5:0] page_addr_3,
	input wire page_addr_offset_3,
	
	input wire [3:0] lut_in_bank0, // update data in  
	input wire [3:0] lut_in_bank1, // update data in

	input wire [5:0] page_write_addr,
	input wire write_addr_offset,

   	input wire we,
	input wire write_clk
);

	wire [3:0] bank0_out0, bank1_out0;
	wire [3:0] bank0_out1, bank1_out1;
	wire [3:0] bank0_out2, bank1_out2;
	wire [3:0] bank0_out3, bank1_out3;
	assign lut_data0[3:0] = (bank_addr_0 == 1'b0) ? bank0_out0[3:0] : bank1_out0[3:0];
	assign lut_data1[3:0] = (bank_addr_1 == 1'b0) ? bank0_out1[3:0] : bank1_out1[3:0];
	assign lut_data2[3:0] = (bank_addr_2 == 1'b0) ? bank0_out2[3:0] : bank1_out2[3:0];
	assign lut_data3[3:0] = (bank_addr_3 == 1'b0) ? bank0_out3[3:0] : bank1_out3[3:0];

 sym_vn_lut bank0(
	.lut_data0 (bank0_out0[3:0]),
	.lut_data1 (bank0_out1[3:0]),
	.lut_data2 (bank0_out2[3:0]),
	.lut_data3 (bank0_out3[3:0]),
 
	// Write data and page address
	.lut_in (lut_in_bank0[3:0]),
	.write_addr ({write_addr_offset, page_write_addr[5:0]}),
        
	// Read page address and address offset
	.read_addr0 ({page_addr_offset_0, page_addr_0}),
	.read_addr1 ({page_addr_offset_1, page_addr_1}),
	.read_addr2 ({page_addr_offset_2, page_addr_2}),
	.read_addr3 ({page_addr_offset_3, page_addr_3}),
    
	.we (we),
	.write_clk (write_clk)
 );
 
 sym_vn_lut bank1(
	.lut_data0 (bank1_out0[3:0]),
	.lut_data1 (bank1_out1[3:0]),
	.lut_data2 (bank1_out2[3:0]),
	.lut_data3 (bank1_out3[3:0]),
 
	// Write data and page address
	.lut_in (lut_in_bank1[3:0]),
	.write_addr ({write_addr_offset, page_write_addr[5:0]}),
        
	// Read page address and address offset
	.read_addr0 ({page_addr_offset_0, page_addr_0}),
	.read_addr1 ({page_addr_offset_1, page_addr_1}),
	.read_addr2 ({page_addr_offset_2, page_addr_2}),
	.read_addr3 ({page_addr_offset_3, page_addr_3}),
    
	.we (we),
	.write_clk (write_clk)
 );
endmodule