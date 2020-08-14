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
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Description: 
// To decode the address mapping scheme in a bank-interleaving fashion
// 1) page address: 5-bit, i.e., depth of 32 per device
// 2) bank address: 1-bit, i.e., two interleaving banks
module cn_addr_map (
    output wire [4:0] page_addr,
    output wire       bank_addr,
	
    input wire [2:0] y0,
    input wire [2:0] y1
    );
	
	assign page_addr[4:0] = {y0[2:0], y1[2:1]};
	assign bank_addr      = y1[0];
endmodule

// Description:
// Concatenation of page and bank address bus for a multiple-port decomposed LUT
module cn_addr_bus (
	// For port A (output)
    output wire [4:0] page_addr_A,
    output wire       bank_addr_A,
	// For port B (output)
    output wire [4:0] page_addr_B,
    output wire       bank_addr_B,
	// For port C (output)
    output wire [4:0] page_addr_C,
    output wire       bank_addr_C,
	// For port D (output)
    output wire [4:0] page_addr_D,
    output wire       bank_addr_D,
	
	// For port A (input, two coreesponding incoming messages)
    input wire [2:0] y0_in_A,
    input wire [2:0] y1_in_A,
	// For port B (input, two coreesponding incoming messages)
    input wire [2:0] y0_in_B,
    input wire [2:0] y1_in_B,
	// For port C (input, two coreesponding incoming messages)
    input wire [2:0] y0_in_C,
    input wire [2:0] y1_in_C,
	// For port D (input, two coreesponding incoming messages)
    input wire [2:0] y0_in_D,
    input wire [2:0] y1_in_D
	);
	
	cn_addr_map cn_map_u0(
		.page_addr (page_addr_A[4:0]),
		.bank_addr (bank_addr_A),
		
		.y0 (y0_in_A[2:0]),
		.y1 (y1_in_A[2:0])
	);
	cn_addr_map cn_map_u1(
		.page_addr (page_addr_B[4:0]),
		.bank_addr (bank_addr_B),
		
		.y0 (y0_in_B[2:0]),
		.y1 (y1_in_B[2:0])
	);
	cn_addr_map cn_map_u2(
		.page_addr (page_addr_C[4:0]),
		.bank_addr (bank_addr_C),
		
		.y0 (y0_in_C[2:0]),
		.y1 (y1_in_C[2:0])
	);
	cn_addr_map cn_map_u3(
		.page_addr (page_addr_D[4:0]),
		.bank_addr (bank_addr_D),
		
		.y0 (y0_in_D[2:0]),
		.y1 (y1_in_D[2:0])
	);
endmodule

// Description: 
// To decode the address mapping scheme in a bank-interleaving fashion
// 1) page address: 6-bit, i.e., depth of 64 per device
// 2) bank address: 1-bit, i.e., two interleaving banks
module vn_addr_map (
    output wire [5:0] page_addr,
    output wire       bank_addr,
	
    input wire [2:0] y0,
    input wire [3:0] y1
    );
	
	assign page_addr[5:0] = {y0[2:0], y1[3:1]};
	assign bank_addr      = y1[0];
endmodule

// Description:
// Concatenation of page and bank address bus for a multiple-port decomposed LUT
module vn_addr_bus (
	// For port A (output)
    output wire [5:0] page_addr_A,
    output wire       bank_addr_A,
	// For port B (output)
    output wire [5:0] page_addr_B,
    output wire       bank_addr_B,
	// For port C (output)
    output wire [5:0] page_addr_C,
    output wire       bank_addr_C,
	// For port D (output)
    output wire [5:0] page_addr_D,
    output wire       bank_addr_D,
	
	// For port A (input, two coreesponding incoming messages)
    input wire [2:0] y0_in_A,
    input wire [3:0] y1_in_A,
	// For port B (input, two coreesponding incoming messages)
    input wire [2:0] y0_in_B,
    input wire [3:0] y1_in_B,
	// For port C (input, two coreesponding incoming messages)
    input wire [2:0] y0_in_C,
    input wire [3:0] y1_in_C,
	// For port D (input, two coreesponding incoming messages)
    input wire [2:0] y0_in_D,
    input wire [3:0] y1_in_D
	);
	
	vn_addr_map vn_map_u0(
		.page_addr (page_addr_A[5:0]),
		.bank_addr (bank_addr_A),
		
		.y0 (y0_in_A[2:0]),
		.y1 (y1_in_A[3:0])
	);
	vn_addr_map vn_map_u1(
		.page_addr (page_addr_B[5:0]),
		.bank_addr (bank_addr_B),
		
		.y0 (y0_in_B[2:0]),
		.y1 (y1_in_B[3:0])
	);
	vn_addr_map vn_map_u2(
		.page_addr (page_addr_C[5:0]),
		.bank_addr (bank_addr_C),
		
		.y0 (y0_in_C[2:0]),
		.y1 (y1_in_C[3:0])
	);
	vn_addr_map vn_map_u3(
		.page_addr (page_addr_D[5:0]),
		.bank_addr (bank_addr_D),
		
		.y0 (y0_in_D[2:0]),
		.y1 (y1_in_D[3:0])
	);
endmodule