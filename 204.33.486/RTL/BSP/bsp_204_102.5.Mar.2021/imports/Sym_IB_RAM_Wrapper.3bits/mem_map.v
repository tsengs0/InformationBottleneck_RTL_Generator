`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2020 08:31:30 PM
// Design Name: 
// Module Name: mem_map
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// To decode the address mapping scheme in a bank-interleaving fashion
// 1) page address: 5-bit, i.e., depth of 32 per device
// 2) bank address: 1-bit, i.e., two interleaving banks
// Dependencies: 
// 
// Revision:
// Revision 0.02 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Description: 
// To decode the address mapping scheme in a bank-interleaving fashion
// 1) page address: 5-bit, i.e., depth of 32 per device
// 2) bank address: 1-bit, i.e., two interleaving banks
module cn_addr_map #(
	parameter ADDR_BW = 3,
	parameter LUT_PORT_SIZE = 2
)
    output wire [ADDR_BW-1:0] page_addr,
    output wire       bank_addr,
	
    input wire [LUT_PORT_SIZE-1:0] y0,
    input wire [LUT_PORT_SIZE-1:0] y1
    );
	
	assign page_addr[ADDR_BW-1:0] = {y0[LUT_PORT_SIZE-1:0], y1[LUT_PORT_SIZE-1:1]};
	assign bank_addr      = y1[0];
endmodule

// Description:
// Concatenation of page and bank address bus for a multiple-port decomposed LUT
module cn_addr_bus #(
  parameter QUAN_SIZE = 3,
  parameter LUT_PORT_SIZE = 2,
  parameter ENTRY_ADDR = 4,
  parameter MULTI_FRAME_NUM = 2
) (
	// For port A (output)
    output wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_addr_A,
    output wire       bank_addr_A,
	// For port B (output)
    output wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_addr_B,
    output wire       bank_addr_B,
	// For port C (output)
    output wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_addr_C,
    output wire       bank_addr_C,
	// For port D (output)
    output wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_addr_D,
    output wire       bank_addr_D,
	
	// For port A (input, two coreesponding incoming messages)
    input wire [LUT_PORT_SIZE-1:0] y0_in_A,
    input wire [LUT_PORT_SIZE-1:0] y1_in_A,
	// For port B (input, two coreesponding incoming messages)
    input wire [LUT_PORT_SIZE-1:0] y0_in_B,
    input wire [LUT_PORT_SIZE-1:0] y1_in_B,
	// For port C (input, two coreesponding incoming messages)
    input wire [LUT_PORT_SIZE-1:0] y0_in_C,
    input wire [LUT_PORT_SIZE-1:0] y1_in_C,
	// For port D (input, two coreesponding incoming messages)
    input wire [LUT_PORT_SIZE-1:0] y0_in_D,
    input wire [LUT_PORT_SIZE-1:0] y1_in_D
	);
	
	cn_addr_map #(
		.ADDR_BW (ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)),
		.LUT_PORT_SIZE (LUT_PORT_SIZE)
	) cn_map_u0(
		.page_addr (page_addr_A[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
		.bank_addr (bank_addr_A),
		
		.y0 (y0_in_A[LUT_PORT_SIZE-1:0]),
		.y1 (y1_in_A[LUT_PORT_SIZE-1:0])
	);
	cn_addr_map #(
		.ADDR_BW (ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)),
		.LUT_PORT_SIZE (LUT_PORT_SIZE)
	) cn_map_u1(
		.page_addr (page_addr_B[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
		.bank_addr (bank_addr_B),
		
		.y0 (y0_in_B[LUT_PORT_SIZE-1:0]),
		.y1 (y1_in_B[LUT_PORT_SIZE-1:0])
	);
	cn_addr_map #(
		.ADDR_BW (ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)),
		.LUT_PORT_SIZE (LUT_PORT_SIZE)
	) cn_map_u2(
		.page_addr (page_addr_C[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
		.bank_addr (bank_addr_C),
		
		.y0 (y0_in_C[LUT_PORT_SIZE-1:0]),
		.y1 (y1_in_C[LUT_PORT_SIZE-1:0])
	);
	cn_addr_map #(
		.ADDR_BW (ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)),
		.LUT_PORT_SIZE (LUT_PORT_SIZE)
	) cn_map_u3(
		.page_addr (page_addr_D[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
		.bank_addr (bank_addr_D),
		
		.y0 (y0_in_D[LUT_PORT_SIZE-1:0]),
		.y1 (y1_in_D[LUT_PORT_SIZE-1:0])
	);
endmodule

// Description: 
// To decode the address mapping scheme in a bank-interleaving fashion
// 1) page address: 6-bit, i.e., depth of 64 per device
// 2) bank address: 1-bit, i.e., two interleaving banks
module vn_addr_map #(
	parameter ADDR_BW = 4,
	parameter LUT_PORT_SIZE = 3,
	parameter QUAN_SIZE = 3
) (
    output wire [ADDR_BW-1:0] page_addr,
    output wire       bank_addr,
	
    input wire [LUT_PORT_SIZE-2:0] y0,
    input wire [QUAN_SIZE-1:0] y1
    );
	
	assign page_addr[ADDR_BW-1:0] = {y0[LUT_PORT_SIZE-2:0], y1[QUAN_SIZE-1:1]};
	assign bank_addr      = y1[0];
endmodule

// Description:
// Concatenation of page and bank address bus for a multiple-port decomposed LUT
module vn_addr_bus #(
	parameter QUAN_SIZE = 3,
	parameter LUT_PORT_SIZE = 3,
	parameter ENTRY_ADDR = 5
	parameter MULTI_FRAME_NUM = 2
) (
	// For port A (output)
    output wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_addr_A,
    output wire       bank_addr_A,
	// For port B (output)
    output wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_addr_B,
    output wire       bank_addr_B,
	// For port C (output)
    output wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_addr_C,
    output wire       bank_addr_C,
	// For port D (output)
    output wire [ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0] page_addr_D,
    output wire       bank_addr_D,
	
	// For port A (input, two coreesponding incoming messages)
    input wire [LUT_PORT_SIZE-2:0] y0_in_A,
    input wire [QUAN_SIZE-1:0] y1_in_A,
	// For port B (input, two coreesponding incoming messages)
    input wire [LUT_PORT_SIZE-2:0] y0_in_B,
    input wire [QUAN_SIZE-1:0] y1_in_B,
	// For port C (input, two coreesponding incoming messages)
    input wire [LUT_PORT_SIZE-2:0] y0_in_C,
    input wire [QUAN_SIZE-1:0] y1_in_C,
	// For port D (input, two coreesponding incoming messages)
    input wire [LUT_PORT_SIZE-2:0] y0_in_D,
    input wire [QUAN_SIZE-1:0] y1_in_D
	);
	
	vn_addr_map #(
		.ADDR_BW (ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)),
		.LUT_PORT_SIZE (LUT_PORT_SIZE),
		.QUAN_SIZE (QUAN_SIZE)
	) vn_map_u0(
		.page_addr (page_addr_A[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
		.bank_addr (bank_addr_A),
		
		.y0 (y0_in_A[LUT_PORT_SIZE-2:0]),
		.y1 (y1_in_A[QUAN_SIZE-1:0])
	);
	vn_addr_map #(
		.ADDR_BW (ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)),
		.LUT_PORT_SIZE (LUT_PORT_SIZE),
		.QUAN_SIZE (QUAN_SIZE)
	) vn_map_u1(
		.page_addr (page_addr_B[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
		.bank_addr (bank_addr_B),
		
		.y0 (y0_in_B[LUT_PORT_SIZE-2:0]),
		.y1 (y1_in_B[QUAN_SIZE-1:0])
	);
	vn_addr_map #(
		.ADDR_BW (ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)),
		.LUT_PORT_SIZE (LUT_PORT_SIZE),
		.QUAN_SIZE (QUAN_SIZE)
	) vn_map_u2(
		.page_addr (page_addr_C[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
		.bank_addr (bank_addr_C),
		
		.y0 (y0_in_C[LUT_PORT_SIZE-2:0]),
		.y1 (y1_in_C[QUAN_SIZE-1:0])
	);
	vn_addr_map #(
		.ADDR_BW (ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)),
		.LUT_PORT_SIZE (LUT_PORT_SIZE),
		.QUAN_SIZE (QUAN_SIZE)
	) vn_map_u3(
		.page_addr (page_addr_D[ENTRY_ADDR-$clog2(MULTI_FRAME_NUM)-1:0]),
		.bank_addr (bank_addr_D),
		
		.y0 (y0_in_D[LUT_PORT_SIZE-2:0]),
		.y1 (y1_in_D[QUAN_SIZE-1:0])
	);
endmodule