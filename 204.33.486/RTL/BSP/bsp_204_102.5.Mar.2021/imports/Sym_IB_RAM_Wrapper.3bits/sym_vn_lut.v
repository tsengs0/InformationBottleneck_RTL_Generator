module sym_vn_lut #(
	parameter QUAN_SIZE = 3,
	parameter ENTRY_ADDR = 5
) (
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

    wire [ENTRY_ADDR-1:0] syn_addr_port0_1;
	wire [ENTRY_ADDR-1:0] syn_addr_port2_3;
	wire [QUAN_SIZE-1:0] syn_lut_data_port0_1;
	wire [QUAN_SIZE-1:0] syn_lut_data_port2_3;
    assign syn_addr_port0_1[ENTRY_ADDR-1:0] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr1[ENTRY_ADDR-1:0];
	assign syn_addr_port2_3[ENTRY_ADDR-1:0] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr3[ENTRY_ADDR-1:0];
	assign lut_data1[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : syn_lut_data_port0_1[QUAN_SIZE-1:0];
	assign lut_data3[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : syn_lut_data_port2_3[QUAN_SIZE-1:0];
   genvar i;
   generate
	for(i=0;i<QUAN_SIZE;i=i+1) begin: sym_vn_lutinst_port0_port1
		// RAM32X1D: 32 x 1 positive edge write, asynchronous read dual-port
		//           distributed RAM (Mapped to a SliceM LUT6)
		//           Kintex-7
		// Xilinx HDL Language Template, version 2019.2
		RAM32X1D #(
		   .INIT(32'h00000000) // Initial contents of RAM
		) RAM32X1D_inst_port0_1 (
			// Read-only port 0
			.DPO(lut_data0[i]),     // Read-only 1-bit data output
			.DPRA0(read_addr0[0]), // Read-only address[0] input bit
			.DPRA1(read_addr0[1]), // Read-only address[1] input bit
			.DPRA2(read_addr0[2]), // Read-only address[2] input bit
			.DPRA3(read_addr0[3]), // Read-only address[3] input bit
			.DPRA4(read_addr0[4]), // Read-only address[4] input bit

      		// R/W synchronous port 1
	  		.SPO(syn_lut_data_port0_1[i]), // Rw/ 1-bit data output
	  		.A0(syn_addr_port0_1[0]),      // Rw/ address[0] input bit
      		.A1(syn_addr_port0_1[1]),      // Rw/ address[1] input bit
      		.A2(syn_addr_port0_1[2]),      // Rw/ address[2] input bit
      		.A3(syn_addr_port0_1[3]),      // Rw/ address[3] input bit
      		.A4(syn_addr_port0_1[4]),      // Rw/ address[4] input bit
      		.D(lut_in[i]), // RAM data input
      
      		.WCLK(write_clk),   // Write clock input
      		.WE(we)        // Write enable input
   		);

   		// RAM32X1D: 32 x 1 positive edge write, asynchronous read dual-port
   		//           distributed RAM (Mapped to a SliceM LUT6)
   		//           Kintex-7
   		// Xilinx HDL Language Template, version 2019.2
   		RAM32X1D #(
   		   .INIT(32'h00000000) // Initial contents of RAM
   		) RAM32X1D_inst_port2_3 (
   	  		// Read-only port 2
      		.DPO(lut_data2[i]),     // Read-only 1-bit data output
      		.DPRA0(read_addr2[0]), // Read-only address[0] input bit
      		.DPRA1(read_addr2[1]), // Read-only address[1] input bit
      		.DPRA2(read_addr2[2]), // Read-only address[2] input bit
      		.DPRA3(read_addr2[3]), // Read-only address[3] input bit
      		.DPRA4(read_addr2[4]), // Read-only address[4] input bit

      		// R/W synchronous prot 3
      		.SPO(syn_lut_data_port2_3[i]),     // Rw/ 1-bit data output
      		.A0(syn_addr_port2_3[0]),       // Rw/ address[0] input bit
      		.A1(syn_addr_port2_3[1]),       // Rw/ address[1] input bit
      		.A2(syn_addr_port2_3[2]),       // Rw/ address[2] input bit
      		.A3(syn_addr_port2_3[3]),       // Rw/ address[3] input bit
      		.A4(syn_addr_port2_3[4]),       // Rw/ address[4] input bit
      		.D(lut_in[i]), // RAM data input

      		.WCLK(write_clk),   // Write clock input
      		.WE(we)        // Write enable input
   		);
	end
   endgenerate
endmodule