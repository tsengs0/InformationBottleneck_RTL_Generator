module sym_cn_rank #(
  parameter QUAN_SIZE = 2,
  parameter ENTRY_ADDR = 4,
  parameter MULTI_FRAME_NUM = 2
) (
	output wire [QUAN_SIZE-1:0] lut_data0,   
	output wire [QUAN_SIZE-1:0] lut_data1,   
	output wire [QUAN_SIZE-1:0] lut_data2,   
	output wire [QUAN_SIZE-1:0] lut_data3,

	// For CNU0
	input wire bank_addr_0,
	input wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_addr_0,
	input wire page_addr_offset_0,
	// For CNU1
	input wire bank_addr_1,
	input wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_addr_1,
	input wire page_addr_offset_1,
	// For CNU2
	input wire bank_addr_2,
	input wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_addr_2,
	input wire page_addr_offset_2,
	// For CNU3
	input wire bank_addr_3,
	input wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_addr_3,
	input wire page_addr_offset_3,
	
	input wire [QUAN_SIZE-1:0] lut_in_bank0, // update data in  
	input wire [QUAN_SIZE-1:0] lut_in_bank1, // update data in

	input wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_write_addr,
	input wire write_addr_offset,

   	input wire we,
	input wire write_clk
);

	wire [QUAN_SIZE-1:0] bank0_out0, bank1_out0;
	wire [QUAN_SIZE-1:0] bank0_out1, bank1_out1;
	wire [QUAN_SIZE-1:0] bank0_out2, bank1_out2;
	wire [QUAN_SIZE-1:0] bank0_out3, bank1_out3;
	assign lut_data0[QUAN_SIZE-1:0] = (bank_addr_0 == 1'b0) ? bank0_out0[QUAN_SIZE-1:0] : bank1_out0[QUAN_SIZE-1:0];
	assign lut_data1[QUAN_SIZE-1:0] = (bank_addr_1 == 1'b0) ? bank0_out1[QUAN_SIZE-1:0] : bank1_out1[QUAN_SIZE-1:0];
	assign lut_data2[QUAN_SIZE-1:0] = (bank_addr_2 == 1'b0) ? bank0_out2[QUAN_SIZE-1:0] : bank1_out2[QUAN_SIZE-1:0];
	assign lut_data3[QUAN_SIZE-1:0] = (bank_addr_3 == 1'b0) ? bank0_out3[QUAN_SIZE-1:0] : bank1_out3[QUAN_SIZE-1:0];

 sym_cn_lut #(
	.QUAN_SIZE  (QUAN_SIZE ),
	.ENTRY_ADDR (ENTRY_ADDR)
 ) bank0(
	.lut_data0 (bank0_out0[QUAN_SIZE-1:0]),
	.lut_data1 (bank0_out1[QUAN_SIZE-1:0]),
	.lut_data2 (bank0_out2[QUAN_SIZE-1:0]),
	.lut_data3 (bank0_out3[QUAN_SIZE-1:0]),
 
	// Write data and page address
	.lut_in (lut_in_bank0[QUAN_SIZE-1:0]),
	.write_addr ({write_addr_offset, page_write_addr[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]}),
        
	// Read page address and address offset
	.read_addr0 ({page_addr_offset_0, page_addr_0[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]}),
	.read_addr1 ({page_addr_offset_1, page_addr_1[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]}),
	.read_addr2 ({page_addr_offset_2, page_addr_2[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]}),
	.read_addr3 ({page_addr_offset_3, page_addr_3[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]}),
    
	.we (we),
	.write_clk (write_clk)
 );
 
 sym_cn_lut #(
	.QUAN_SIZE  (QUAN_SIZE ),
	.ENTRY_ADDR (ENTRY_ADDR)
 ) bank1(
	.lut_data0 (bank1_out0[QUAN_SIZE-1:0]),
	.lut_data1 (bank1_out1[QUAN_SIZE-1:0]),
	.lut_data2 (bank1_out2[QUAN_SIZE-1:0]),
	.lut_data3 (bank1_out3[QUAN_SIZE-1:0]),
 
	// Write data and page address
	.lut_in (lut_in_bank1[QUAN_SIZE-1:0]),
	.write_addr ({write_addr_offset, page_write_addr[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]}),
        
	// Read page address and address offset
	.read_addr0 ({page_addr_offset_0, page_addr_0[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]}),
	.read_addr1 ({page_addr_offset_1, page_addr_1[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]}),
	.read_addr2 ({page_addr_offset_2, page_addr_2[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]}),
	.read_addr3 ({page_addr_offset_3, page_addr_3[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]}),
    
	.we (we),
	.write_clk (write_clk)
 );
endmodule