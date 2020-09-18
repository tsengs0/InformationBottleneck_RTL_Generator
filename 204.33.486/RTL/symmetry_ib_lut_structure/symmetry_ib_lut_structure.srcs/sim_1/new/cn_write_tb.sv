`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2020 03:20:41 PM
// Design Name: 
// Module Name: cn_write_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "define.vh"

module cn_write_tb;

parameter ROM_RD_BW = 6;    // bit-width of one read port of BRAM based IB-ROM
parameter ROM_ADDR_BW = 10;  // bit-width of read address of BRAM based IB-ROM
							// #Entry: (64-entry*3-bit) / ROM_RD_BW)*25-iteration
							// ceil(log2(#Entry)) = 10-bit
						    
parameter PAGE_ADDR_BW = 5; // bit-width of addressing (64-entry*3-bit)/ROM_RD_BW), i.e., ceil(log2((64-entry*3-bit)/ROM_RD_BW)))								
parameter ITER_ADDR_BW = 5;  // bit-width of addressing 25 iterationss
//parameter CN_TYPE_A = 1;    // the number of check node type in terms of its check node degree   
//parameter CN_TYPE_B = 1;     // the number of check node type in terms of its check node degree

parameter LOAD_CYCLE = 32; // 64-entry with two interleaving banks requires 32 clock cycle to finish iteration update
parameter CN_RD_BW = 6;
parameter VN_RD_BW = 8;
parameter DN_RD_BW = 2;
parameter CN_ADDR_BW = 10;
parameter VN_ADDR_BW = 11;
parameter DN_ADDR_BW = 11;
	
// Memory System - Output
logic [CN_RD_BW-1:0] cn_iter0_m0_portA_dout;
logic [CN_RD_BW-1:0] cn_iter0_m0_portB_dout;
logic [CN_RD_BW-1:0] cn_iter0_m1_portA_dout;
logic [CN_RD_BW-1:0] cn_iter0_m1_portB_dout;
logic [CN_RD_BW-1:0] cn_iter0_m2_portA_dout;
logic [CN_RD_BW-1:0] cn_iter0_m2_portB_dout;
logic [CN_RD_BW-1:0] cn_iter0_m3_portA_dout;
logic [CN_RD_BW-1:0] cn_iter0_m3_portB_dout;
logic [CN_RD_BW-1:0] cn_iter1_m0_portA_dout;
logic [CN_RD_BW-1:0] cn_iter1_m0_portB_dout;
logic [CN_RD_BW-1:0] cn_iter1_m1_portA_dout;
logic [CN_RD_BW-1:0] cn_iter1_m1_portB_dout;
logic [CN_RD_BW-1:0] cn_iter1_m2_portA_dout;
logic [CN_RD_BW-1:0] cn_iter1_m2_portB_dout;
logic [CN_RD_BW-1:0] cn_iter1_m3_portA_dout;
logic [CN_RD_BW-1:0] cn_iter1_m3_portB_dout;
// Memory System - Ouput of Mux
logic [CN_RD_BW-1:0] cn_portA_dout [0:`IB_CNU_DECOMP_funNum-1];
logic [CN_RD_BW-1:0] cn_portB_dout [0:`IB_CNU_DECOMP_funNum-1];

// Memory Latch - Output
logic [ROM_RD_BW-1:0] latch_outA [0:`IB_CNU_DECOMP_funNum-1];
logic [ROM_RD_BW-1:0] latch_outB [0:`IB_CNU_DECOMP_funNum-1];
logic [ROM_ADDR_BW-1:0] rom_read_addrA [0:`IB_CNU_DECOMP_funNum-1];
logic [ROM_ADDR_BW-1:0] rom_read_addrB [0:`IB_CNU_DECOMP_funNum-1];

// IB-RAM Write Page Address Counter - Output
logic [PAGE_ADDR_BW-1:0] wr_page_addr [0:`IB_CNU_DECOMP_funNum-1];

// CNU6 Update Iteration Control - Output
logic rom_port_fetch [0:`IB_CNU_DECOMP_funNum-1]; // to enable the ib-map starting to fetch data from read port of IB ROM
logic ram_write_en [0:`IB_CNU_DECOMP_funNum-1];
logic ram_mux_en [0:`IB_CNU_DECOMP_funNum-1];
logic iter_update [0:`IB_CNU_DECOMP_funNum-1];
logic c6ib_rom_rst [0:`IB_CNU_DECOMP_funNum-1];
logic [1:0] busy [0:`IB_CNU_DECOMP_funNum-1];
logic [2:0] state [0:`IB_CNU_DECOMP_funNum-1];
// CNU6 Update Iteration Control - Input
logic iter_rqst [0:`IB_CNU_DECOMP_funNum-1];
logic iter_termination [0:`IB_CNU_DECOMP_funNum-1];
logic pipeline_en [0:`IB_CNU_DECOMP_funNum-1];
logic rstn_cnu_fsm [0:`IB_CNU_DECOMP_funNum-1];

// System Parameter - Input
logic [`IB_CNU_DECOMP_funNum-1:0] cn_iter_switch;
logic write_clk;
//logic rstn; // using rstn_cnu_fsm as its alternative

mem_sys mem_u0(
	// Memory System - Ouput
	.cn_iter0_m0_portA_dout(cn_iter0_m0_portA_dout[CN_RD_BW-1:0]),
	.cn_iter0_m0_portB_dout(cn_iter0_m0_portB_dout[CN_RD_BW-1:0]),
	.cn_iter0_m1_portA_dout(cn_iter0_m1_portA_dout[CN_RD_BW-1:0]),
	.cn_iter0_m1_portB_dout(cn_iter0_m1_portB_dout[CN_RD_BW-1:0]),
	.cn_iter0_m2_portA_dout(cn_iter0_m2_portA_dout[CN_RD_BW-1:0]),
	.cn_iter0_m2_portB_dout(cn_iter0_m2_portB_dout[CN_RD_BW-1:0]),
	.cn_iter0_m3_portA_dout(cn_iter0_m3_portA_dout[CN_RD_BW-1:0]),
	.cn_iter0_m3_portB_dout(cn_iter0_m3_portB_dout[CN_RD_BW-1:0]),
	.cn_iter1_m0_portA_dout(cn_iter1_m0_portA_dout[CN_RD_BW-1:0]),
	.cn_iter1_m0_portB_dout(cn_iter1_m0_portB_dout[CN_RD_BW-1:0]),
	.cn_iter1_m1_portA_dout(cn_iter1_m1_portA_dout[CN_RD_BW-1:0]),
	.cn_iter1_m1_portB_dout(cn_iter1_m1_portB_dout[CN_RD_BW-1:0]),
	.cn_iter1_m2_portA_dout(cn_iter1_m2_portA_dout[CN_RD_BW-1:0]),
	.cn_iter1_m2_portB_dout(cn_iter1_m2_portB_dout[CN_RD_BW-1:0]),
	.cn_iter1_m3_portA_dout(cn_iter1_m3_portA_dout[CN_RD_BW-1:0]),
	.cn_iter1_m3_portB_dout(cn_iter1_m3_portB_dout[CN_RD_BW-1:0]),
	
	// Memory System - Input
	.cn_iter0_m0_portA_addr (rom_read_addrA[0]),
	.cn_iter0_m0_portB_addr (rom_read_addrB[0]),
	.cn_iter0_m1_portA_addr (rom_read_addrA[1]),
	.cn_iter0_m1_portB_addr (rom_read_addrB[1]),
	.cn_iter0_m2_portA_addr (rom_read_addrA[2]),
	.cn_iter0_m2_portB_addr (rom_read_addrB[2]),
	.cn_iter0_m3_portA_addr (rom_read_addrA[3]),
	.cn_iter0_m3_portB_addr (rom_read_addrB[3]),
	.cn_iter1_m0_portA_addr (rom_read_addrA[0]),
	.cn_iter1_m0_portB_addr (rom_read_addrB[0]),
	.cn_iter1_m1_portA_addr (rom_read_addrA[1]),
	.cn_iter1_m1_portB_addr (rom_read_addrB[1]),
	.cn_iter1_m2_portA_addr (rom_read_addrA[2]),
	.cn_iter1_m2_portB_addr (rom_read_addrB[2]),
	.cn_iter1_m3_portA_addr (rom_read_addrA[3]),
	.cn_iter1_m3_portB_addr (rom_read_addrB[3]),
	.write_clk (write_clk)
);

rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) rom_iter_mux_mA0(
	.dout (cn_portA_dout[0]),
	.iter0_din (cn_iter0_m0_portA_dout),
	.iter1_din (cn_iter1_m0_portA_dout),
	.iter_switch (cn_iter_switch[0])
);
rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) rom_iter_mux_mA1(
	.dout (cn_portA_dout[1]),
	.iter0_din  (cn_iter0_m1_portA_dout),
	.iter1_din  (cn_iter1_m1_portA_dout),
	.iter_switch (cn_iter_switch[1]) 
);
rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) rom_iter_mux_mA2(
	.dout (cn_portA_dout[2]),
	.iter0_din  (cn_iter0_m2_portA_dout),
	.iter1_din  (cn_iter1_m2_portA_dout),
	.iter_switch (cn_iter_switch[2]) 
);
rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) rom_iter_mux_mA3(
	.dout (cn_portA_dout[3]),
	.iter0_din  (cn_iter0_m3_portA_dout),
	.iter1_din  (cn_iter1_m3_portA_dout),
	.iter_switch (cn_iter_switch[3]) 
);
rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) rom_iter_mux_mB0(
	.dout (cn_portB_dout[0]),
	.iter0_din (cn_iter0_m0_portB_dout),
	.iter1_din (cn_iter1_m0_portB_dout),
	.iter_switch (cn_iter_switch[0])
);
rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) rom_iter_mux_mB1(
	.dout (cn_portB_dout[1]),
	.iter0_din  (cn_iter0_m1_portB_dout),
	.iter1_din  (cn_iter1_m1_portB_dout),
	.iter_switch (cn_iter_switch[1]) 
);
rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) rom_iter_mux_mB2(
	.dout (cn_portB_dout[2]),
	.iter0_din  (cn_iter0_m2_portB_dout),
	.iter1_din  (cn_iter1_m2_portB_dout),
	.iter_switch (cn_iter_switch[2]) 
);
rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) rom_iter_mux_mB3(
	.dout (cn_portB_dout[3]),
	.iter0_din  (cn_iter0_m3_portB_dout),
	.iter1_din  (cn_iter1_m3_portB_dout),
	.iter_switch (cn_iter_switch[3]) 
);

generate
	genvar i;
		for(i=0;i<`IB_CNU_DECOMP_funNum;i=i+1) begin : insta_cn_iter_switch
			rom_iter_selector #(.ITER_ADDR_BW(ITER_ADDR_BW)) rom_iter_selector_m03(
				.iter_switch (cn_iter_switch[i]),
				.rom_read_addr (rom_read_addrA[i][ROM_ADDR_BW-1:ITER_ADDR_BW]),
				.write_clk (write_clk),
				.rstn (rstn_cnu_fsm[i])
			);
		
			initial cn_iter_switch[i] <= 1'b0;
			always @(posedge write_clk) begin
				if((rom_read_addrA[i][ROM_ADDR_BW-1:ITER_ADDR_BW] == 5'd24))
					cn_iter_switch[i] <= ~cn_iter_switch[i];
			end
			
			cn_mem_latch #(
				.ROM_RD_BW    (ROM_RD_BW), 
				.ROM_ADDR_BW  (ROM_ADDR_BW),    			    
				.PAGE_ADDR_BW (PAGE_ADDR_BW), 								
				.ITER_ADDR_BW (ITER_ADDR_BW)
			) cn_mem_latch_m03(
				// Memory Latch - Output	
				.latch_outA (latch_outA[i]),
				.latch_outB (latch_outB[i]),
				.rom_read_addrA (rom_read_addrA[i]),
				.rom_read_addrB (rom_read_addrB[i]),
				// Memory Latch - Input 
				.latch_inA (cn_portA_dout[i]),
				.latch_inB (cn_portB_dout[i]),
				.latch_iterA (5'd0), // base address for latch A to indicate the iteration index
				.latch_iterB (5'd0), // base address for latch B to indicate the iteration index
				.rstn (rom_port_fetch[i]), // asserted/deasserted by "rom_port_fetch" signal of Iteration Update Control Unit
				.write_clk (write_clk)
			);

			cn_Waddr_counter #(.PAGE_ADDR_BW (PAGE_ADDR_BW)) cn_page_addr_cntM03 (
				.wr_page_addr (wr_page_addr[i]),
				
				.en (ram_write_en[i]),
				.write_clk (write_clk),
				.rstn (~c6ib_rom_rst[i])
			);

			cnu6_wr_fsm #(.LOAD_CYCLE(LOAD_CYCLE)) cnu6_wr_fsm_u0 (
				// FSM - Output
				.rom_port_fetch (rom_port_fetch[i]), // to enable the ib-map starting to fetch data from read port of IB ROM
				.ram_write_en (ram_write_en[i]),
				.ram_mux_en (ram_mux_en[i]),
				.iter_update (iter_update[i]),
				.c6ib_rom_rst (c6ib_rom_rst[i]),
				.busy (busy[i]),
				.state (state[i]),
				// FSM - Input
				.write_clk (write_clk),
				.rstn (rstn_cnu_fsm[i]),
				.iter_rqst (iter_rqst[i]),
				.iter_termination (iter_termination[i])
				//.pipeline_en (pipeline_en[i])	// deprecated
			);
		end
endgenerate

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// IB-RAMs Instantiation
    // Instantiation of F_0
	reg [`QUAN_SIZE-1:0] v2c_0[0:`CN_DEGREE-1];
	reg [`QUAN_SIZE-1:0] v2c_1[0:`CN_DEGREE-1];
    wire [`QUAN_SIZE-1:0] f0_out[0:3];
    wire [`QUAN_SIZE-1:0] cnu0_f0_M_reg [0:`CN_DEGREE-1];
    wire [`QUAN_SIZE-1:0] cnu1_f0_M_reg [0:`CN_DEGREE-1];

	// Dummy instantiation just for area overhead evaluation
	wire [`CN_DEGREE-2-1-1:0] read_addr_offset_internal;
    cnu6_f0 u_f0(
//		.read_addr_offset_out (read_addr_offset_internal[0]), // to forward the current multi-frame offset signal to the next sub-datapath
//        // For the first CNU
//        .t_portA (f0_out[0]), // internal signals accounting for each 256-entry partial LUT's output
//        .t_portB (f0_out[1]), // internal signals accounting for each 256-entry partial LUT's output
//        // For the second CNU
//        .t_portC (f0_out[2]), // internal signals accounting for each 256-entry partial LUT's output
//        .t_portD (f0_out[3]), // internal signals accounting for each 256-entry partial LUT's output
//        // For the first CNU
//        .cnu0_M_reg0 (cnu0_f0_M_reg[0]),
//        .cnu0_M_reg1 (cnu0_f0_M_reg[1]),
//        .cnu0_M_reg2 (cnu0_f0_M_reg[2]),
//        .cnu0_M_reg3 (cnu0_f0_M_reg[3]),
//        .cnu0_M_reg4 (cnu0_f0_M_reg[4]),
//        .cnu0_M_reg5 (cnu0_f0_M_reg[5]),
//        // For the second CNU
//        .cnu1_M_reg0 (cnu1_f0_M_reg[0]),
//        .cnu1_M_reg1 (cnu1_f0_M_reg[1]),
//        .cnu1_M_reg2 (cnu1_f0_M_reg[2]),
//        .cnu1_M_reg3 (cnu1_f0_M_reg[3]),
//        .cnu1_M_reg4 (cnu1_f0_M_reg[4]),
//        .cnu1_M_reg5 (cnu1_f0_M_reg[5]),

//        // From the first CNU
//        .cnu0_v2c_0 (v2c_0[0]),
//        .cnu0_v2c_1 (v2c_0[1]),
//        .cnu0_v2c_2 (v2c_0[2]),
//        .cnu0_v2c_3 (v2c_0[3]),
//        .cnu0_v2c_4 (v2c_0[4]),
//        .cnu0_v2c_5 (v2c_0[5]),
//        // From the second CNU
//        .cnu1_v2c_0 (v2c_1[0]),
//        .cnu1_v2c_1 (v2c_1[1]),
//        .cnu1_v2c_2 (v2c_1[2]),
//        .cnu1_v2c_3 (v2c_1[3]),
//        .cnu1_v2c_4 (v2c_1[4]),
//        .cnu1_v2c_5 (v2c_1[5]),

//		.read_clk (read_clk),
//        .read_addr_offset (read_addr_offset), // offset determing the switch between multi-frame under the following sub-datapath
      
		// Iteration-Update Page Address 
        .page_addr_ram ({1'b0, wr_page_addr[0]}), // only load one iteration dataset onto IB-RAM
        // Iteration-Update Data
        .ram_write_data_0 (latch_outA[0]),

        .write_clk (write_clk),
        .ib_ram_we (ram_write_en[0])
    );
    // Instantiation of F_1
    wire [`QUAN_SIZE-1:0] f1_out[0:3];
    wire [`QUAN_SIZE-1:0] cnu0_f1_M_reg [0:`CN_DEGREE-1];
    wire [`QUAN_SIZE-1:0] cnu1_f1_M_reg [0:`CN_DEGREE-1];
    cnu6_f1 u_f1(
//		.read_addr_offset_out (read_addr_offset_internal[1]), // to forward the current multi-frame offset signal to the next sub-datapath
//        // For the first CNU
//        .t_portA (f1_out[0]), // internal signals accounting for each 256-entry partial LUT's output
//        .t_portB (f1_out[1]), // internal signals accounting for each 256-entry partial LUT's output
//        // For the second CNU
//        .t_portC (f1_out[2]), // internal signals accounting for each 256-entry partial LUT's output
//        .t_portD (f1_out[3]), // internal signals accounting for each 256-entry partial LUT's output
//        // For the first CNU
//        .cnu0_M_reg0 (cnu0_f1_M_reg[0]),
//        .cnu0_M_reg1 (cnu0_f1_M_reg[1]),
//        .cnu0_M_reg2 (cnu0_f1_M_reg[2]),
//        .cnu0_M_reg3 (cnu0_f1_M_reg[3]),
//        .cnu0_M_reg4 (cnu0_f1_M_reg[4]),
//        .cnu0_M_reg5 (cnu0_f1_M_reg[5]),
//        // For the second CNU
//        .cnu1_M_reg0 (cnu1_f1_M_reg[0]),
//        .cnu1_M_reg1 (cnu1_f1_M_reg[1]),
//        .cnu1_M_reg2 (cnu1_f1_M_reg[2]),
//        .cnu1_M_reg3 (cnu1_f1_M_reg[3]),
//        .cnu1_M_reg4 (cnu1_f1_M_reg[4]),
//        .cnu1_M_reg5 (cnu1_f1_M_reg[5]),

//        // From the first CNU
//        .t_00 (f0_out[0]),
//        .t_01 (f0_out[1]),
//        .cnu0_v2c_0 (cnu0_f0_M_reg[0]),
//        .cnu0_v2c_1 (cnu0_f0_M_reg[1]),
//        .cnu0_v2c_2 (cnu0_f0_M_reg[2]),
//        .cnu0_v2c_3 (cnu0_f0_M_reg[3]),
//        .cnu0_v2c_4 (cnu0_f0_M_reg[4]),
//        .cnu0_v2c_5 (cnu0_f0_M_reg[5]),
//        // From the second CNU
//        .t_02 (f0_out[2]),
//        .t_03 (f0_out[3]),
//        .cnu1_v2c_0 (cnu1_f0_M_reg[0]),
//        .cnu1_v2c_1 (cnu1_f0_M_reg[1]),
//        .cnu1_v2c_2 (cnu1_f0_M_reg[2]),
//        .cnu1_v2c_3 (cnu1_f0_M_reg[3]),
//        .cnu1_v2c_4 (cnu1_f0_M_reg[4]),
//        .cnu1_v2c_5 (cnu1_f0_M_reg[5]),

//		.read_clk (read_clk),
//        .read_addr_offset (read_addr_offset_internal[0]), // offset determing the switch between multi-frame under the following sub-datapath

        // Iteration-Update Page Address 
        .page_addr_ram ({1'b0, wr_page_addr[1]}), // only load one iteration dataset onto IB-RAM
        // Iteration-Update Data
        .ram_write_data_1 (latch_outA[1]),

        .write_clk (write_clk),
        .ib_ram_we (ram_write_en[1])
    );
    // Instantiation of F_2
    wire [`QUAN_SIZE-1:0] cnu0_f2_out[0:3];
    wire [`QUAN_SIZE-1:0] cnu1_f2_out[0:3];
    wire [`QUAN_SIZE-1:0] cnu0_f2_M_reg [0:3];
    wire [`QUAN_SIZE-1:0] cnu1_f2_M_reg [0:3];
    cnu6_f2 u_f2(
//		.read_addr_offset_out (read_addr_offset_internal[2]), // to forward the current multi-frame offset signal to the next sub-datapath
//        // For the first CNU
//        .cnu0_t_portA (cnu0_f2_out[0]), // internal signals accounting for each 256-entry partial LUT's output
//        .cnu0_t_portB (cnu0_f2_out[1]), // internal signals accounting for each 256-entry partial LUT's output
//        .cnu0_t_portC (cnu0_f2_out[2]), // internal signals accounting for each 256-entry partial LUT's output
//        .cnu0_t_portD (cnu0_f2_out[3]), // internal signals accounting for each 256-entry partial LUT's output
//        // For the second CNU
//        .cnu1_t_portA (cnu1_f2_out[0]), // internal signals accounting for each 256-entry partial LUT's output
//        .cnu1_t_portB (cnu1_f2_out[1]), // internal signals accounting for each 256-entry partial LUT's output
//        .cnu1_t_portC (cnu1_f2_out[2]), // internal signals accounting for each 256-entry partial LUT's output
//        .cnu1_t_portD (cnu1_f2_out[3]), // internal signals accounting for each 256-entry partial LUT's output
//        // For the first CNU
//        .cnu0_M_reg1 (cnu0_f2_M_reg[0]),
//        .cnu0_M_reg2 (cnu0_f2_M_reg[1]),
//        .cnu0_M_reg4 (cnu0_f2_M_reg[2]),
//        .cnu0_M_reg5 (cnu0_f2_M_reg[3]),
//        // For the second CNU
//        .cnu1_M_reg1 (cnu1_f2_M_reg[0]),
//        .cnu1_M_reg2 (cnu1_f2_M_reg[1]),
//        .cnu1_M_reg4 (cnu1_f2_M_reg[2]),
//        .cnu1_M_reg5 (cnu1_f2_M_reg[3]),

//		.read_clk (read_clk),
//        .read_addr_offset (read_addr_offset_internal[1]), // offset determing the switch between multi-frame under the following sub-datapath

//        // From the first CNU
//        .t_10 (f1_out[0]),
//        .t_11 (f1_out[1]),
//        .cnu0_v2c_0 (cnu0_f1_M_reg[0]),
//        .cnu0_v2c_1 (cnu0_f1_M_reg[1]),
//        .cnu0_v2c_2 (cnu0_f1_M_reg[2]),
//        .cnu0_v2c_3 (cnu0_f1_M_reg[3]),
//        .cnu0_v2c_4 (cnu0_f1_M_reg[4]),
//        .cnu0_v2c_5 (cnu0_f1_M_reg[5]),
//        // From the second CNU
//        .t_12 (f1_out[1]),
//        .t_13 (f1_out[2]),
//        .cnu1_v2c_0 (cnu1_f1_M_reg[0]),
//        .cnu1_v2c_1 (cnu1_f1_M_reg[1]),
//        .cnu1_v2c_2 (cnu1_f1_M_reg[2]),
//        .cnu1_v2c_3 (cnu1_f1_M_reg[3]),
//        .cnu1_v2c_4 (cnu1_f1_M_reg[4]),
//        .cnu1_v2c_5 (cnu1_f1_M_reg[5]),

        // Iteration-Update Page Address 
        .page_addr_ram ({1'b0, wr_page_addr[2]}), // only load one iteration dataset onto IB-RAM
        // Iteration-Update Data
        .ram_write_data_2 (latch_outA[2]),

        .write_clk (write_clk),
        .ib_ram_we (ram_write_en[2])
    );
    // Instantiation of F_3
    wire [`QUAN_SIZE-1:0] cnu0_c2v [0:`CN_DEGREE-1];
    wire [`QUAN_SIZE-1:0] cnu1_c2v [0:`CN_DEGREE-1];
    cnu6_f3 u_f3(
//		.read_addr_offset_out (read_addr_offset_outSet[j]), // to forward the current multi-frame offset signal to the next sub-datapath
//        // For the first CNU
//        .cnu0_c2v_0 (cnu0_c2v[0]), 
//        .cnu0_c2v_1 (cnu0_c2v[1]), 
//        .cnu0_c2v_2 (cnu0_c2v[2]), 
//        .cnu0_c2v_3 (cnu0_c2v[3]),
//        .cnu0_c2v_4 (cnu0_c2v[4]),
//        .cnu0_c2v_5 (cnu0_c2v[5]), 
//        // For the second CNU
//        .cnu1_c2v_0 (cnu1_c2v[0]), 
//        .cnu1_c2v_1 (cnu1_c2v[1]), 
//        .cnu1_c2v_2 (cnu1_c2v[2]), 
//        .cnu1_c2v_3 (cnu1_c2v[3]),
//        .cnu1_c2v_4 (cnu1_c2v[4]),
//        .cnu1_c2v_5 (cnu1_c2v[5]),

//        // From the first CNU
//        .cnu0_t_20 (cnu0_f2_out[0]),
//        .cnu0_t_21 (cnu0_f2_out[1]),
//        .cnu0_t_22 (cnu0_f2_out[2]),
//        .cnu0_t_23 (cnu0_f2_out[3]),
//        .cnu0_v2c_1 (cnu0_f2_M_reg[0]),
//        .cnu0_v2c_2 (cnu0_f2_M_reg[1]),
//        .cnu0_v2c_4 (cnu0_f2_M_reg[2]),
//        .cnu0_v2c_5 (cnu0_f2_M_reg[3]),
//        // From the second CNU
//        .cnu1_t_20 (cnu1_f2_out[0]),
//        .cnu1_t_21 (cnu1_f2_out[1]),
//        .cnu1_t_22 (cnu1_f2_out[2]),
//        .cnu1_t_23 (cnu1_f2_out[3]),
//        .cnu1_v2c_1 (cnu1_f2_M_reg[0]),
//        .cnu1_v2c_2 (cnu1_f2_M_reg[1]),
//        .cnu1_v2c_4 (cnu1_f2_M_reg[2]),
//        .cnu1_v2c_5 (cnu1_f2_M_reg[3]),

//		.read_clk (read_clk),
//        .read_addr_offset (read_addr_offset_internal[2]), // offset determing the switch between multi-frame under the following sub-datapath

        // Iteration-Update Page Address 
        .page_addr_ram ({1'b0, wr_page_addr[3]}), // only load one iteration dataset onto IB-RAM
        // Iteration-Update Data
        .ram_write_data_3 (latch_outA[3]),

        .write_clk (write_clk),
        .ib_ram_we (ram_write_en[3])
    );
// End of IB-RAMs Instantiation 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
initial begin
	#0 write_clk <= 0;
	forever #3.333 write_clk <= ~write_clk;
end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
logic [`IB_CNU_DECOMP_funNum-1:0] update_finish;
integer cnu_f [0:`IB_CNU_DECOMP_funNum-1];
initial begin
    cnu_f[0] = $fopen("cnu_ram_dataIn.f0.csv", "w");
	cnu_f[1] = $fopen("cnu_ram_dataIn.f1.csv", "w");
	cnu_f[2] = $fopen("cnu_ram_dataIn.f2.csv", "w");
	cnu_f[3] = $fopen("cnu_ram_dataIn.f3.csv", "w");
end

generate
	//genvar i;
	for(i=0;i<`IB_CNU_DECOMP_funNum;i=i+1) begin : insta_cn_fsm_in_sim
		initial begin
			#0;
			{rstn_cnu_fsm[i], iter_rqst[i], iter_termination[i]} <= 3'b000;
			update_finish[i]  <= 1'b0; 
			//pipeline_en[i] <= 1'b0;
			{rstn_cnu_fsm[i], iter_rqst[i], iter_termination[i]} <= 3'b000; 
			update_finish[i] <= 1'b0;
			
			#200;
			{rstn_cnu_fsm[i], iter_rqst[i], iter_termination[i]} <= 3'b110; 
			
		end
		always @(posedge write_clk) begin
			if(iter_rqst[i] == 1'b1 && busy[i] == 2'b10) begin
				update_finish[i] <= 1'b1;
				$fclose(cnu_f[i]);
			end
		end
		
		//initial pipeline_en[i] <= 1'b0;
		//always @(posedge write_clk) begin
		//	if(state[i] == 3'd1) pipeline_en <= 1'b1;
		//	else pipeline_en <= pipeline_en;
		//end
		
		always @(posedge write_clk) begin
			if(state[i] == 3'd3) begin
				$fwrite(cnu_f[i], "%d,%b,%b\n", 
								{1'b0, wr_page_addr[i]},
								latch_outA[i][5:3],
								latch_outA[i][2:0]
				);      
			end
		end
	end
endgenerate

initial begin
	wait(&{update_finish[`IB_CNU_DECOMP_funNum-1:0]});
	#100 $finish;
end
/*
initial begin
    #0;
    M0 <= 0;
    M1 <= 0;
    M2 <= 0;
    M3 <= 0;
    M4 <= 0;
    M5 <= 0;
end
always @(posedge ram_clk) begin
    if({ram_write_en, iter_update, c6ib_rom_rst} == 3'b001 && update_finish == 1'b1) begin 
        M0 <= M0 + 1;
        M1 <= M1 + &M0;
        M2 <= M2 + &{M1, M0};
        M3 <= M3 + &{M2, M1, M0};
        M4 <= M4 + &{M3, M2, M1, M0};
        M5 <= M5 + &{M4, M3, M2, M1, M0};
    end
end

integer f1;
initial begin
    f1 = $fopen("C2V.csv", "w");
end
reg [`QUAN_SIZE-1:0] M0_reg[0:4]; reg [`QUAN_SIZE-1:0] M1_reg[0:4]; reg [`QUAN_SIZE-1:0] M2_reg[0:4];
reg [`QUAN_SIZE-1:0] M3_reg[0:4]; reg [`QUAN_SIZE-1:0] M4_reg[0:4]; reg [`QUAN_SIZE-1:0] M5_reg[0:4];
initial begin
    #833.5;
    {M0_reg[0], M0_reg[1], M0_reg[2], M0_reg[3], M0_reg[4]} <= 20'd0;
    {M1_reg[0], M1_reg[1], M1_reg[2], M1_reg[3], M1_reg[4]} <= 20'd0;
    {M2_reg[0], M2_reg[1], M2_reg[2], M2_reg[3], M2_reg[4]} <= 20'd0;
    {M3_reg[0], M3_reg[1], M3_reg[2], M3_reg[3], M3_reg[4]} <= 20'd0;
    {M4_reg[0], M4_reg[1], M4_reg[2], M4_reg[3], M4_reg[4]} <= 20'd0;
    {M5_reg[0], M5_reg[1], M5_reg[2], M5_reg[3], M5_reg[4]} <= 20'd0;      
end
always @(posedge ram_clk) begin
    if(update_finish == 1'b1) begin
        {M0_reg[0], M0_reg[1], M0_reg[2], M0_reg[3], M0_reg[4]} <= {M0[`QUAN_SIZE-1:0], M0_reg[0], M0_reg[1], M0_reg[2], M0_reg[3]};
        {M1_reg[0], M1_reg[1], M1_reg[2], M1_reg[3], M1_reg[4]} <= {M1[`QUAN_SIZE-1:0], M1_reg[0], M1_reg[1], M1_reg[2], M1_reg[3]};
        {M2_reg[0], M2_reg[1], M2_reg[2], M2_reg[3], M2_reg[4]} <= {M2[`QUAN_SIZE-1:0], M2_reg[0], M2_reg[1], M2_reg[2], M2_reg[3]};
        {M3_reg[0], M3_reg[1], M3_reg[2], M3_reg[3], M3_reg[4]} <= {M3[`QUAN_SIZE-1:0], M3_reg[0], M3_reg[1], M3_reg[2], M3_reg[3]};
        {M4_reg[0], M4_reg[1], M4_reg[2], M4_reg[3], M4_reg[4]} <= {M4[`QUAN_SIZE-1:0], M4_reg[0], M4_reg[1], M4_reg[2], M4_reg[3]};
        {M5_reg[0], M5_reg[1], M5_reg[2], M5_reg[3], M5_reg[4]} <= {M5[`QUAN_SIZE-1:0], M5_reg[0], M5_reg[1], M5_reg[2], M5_reg[3]};
    end
end
always @(posedge ram_clk) begin
    if(update_finish == 1'b1) begin
        //if({M0_reg[4], M1_reg[4], M2_reg[4], M3_reg[4], M4_reg[4], M5_reg[4]} != {`CN_DEGREE{4'hf}}) begin
        if({M0_reg[4], M1_reg[4], M2_reg[4], M3_reg[4], M4_reg[4], M5_reg[4]} != {24'hff0000}) begin
             $fwrite(f1, "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h\n",
                M0_reg[4],M1_reg[4],M2_reg[4],M3_reg[4],M4_reg[4],M5_reg[4],
                E0[`QUAN_SIZE-1:0],E1[`QUAN_SIZE-1:0],E2[`QUAN_SIZE-1:0],E3[`QUAN_SIZE-1:0],E4[`QUAN_SIZE-1:0],E5[`QUAN_SIZE-1:0]);
        end
        //else if({M0_reg[4], M1_reg[4], M2_reg[4], M3_reg[4], M4_reg[4], M5_reg[4]} == {`CN_DEGREE{4'hf}}) begin
        else if({M0_reg[4], M1_reg[4], M2_reg[4], M3_reg[4], M4_reg[4], M5_reg[4]} == {24'hff0000}) begin
            $fwrite(f1, "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h",
                M0_reg[4],M1_reg[4],M2_reg[4],M3_reg[4],M4_reg[4],M5_reg[4],
                E0[`QUAN_SIZE-1:0],E1[`QUAN_SIZE-1:0],E2[`QUAN_SIZE-1:0],E3[`QUAN_SIZE-1:0],E4[`QUAN_SIZE-1:0],E5[`QUAN_SIZE-1:0]);      
        end    
    end
end
always @(posedge ram_clk) begin
    //if(update_finish == 1'b1 && {M0_reg[4], M1_reg[4], M2_reg[4], M3_reg[4], M4_reg[4], M5_reg[4]} == {`CN_DEGREE{4'hf}}) begin
    if(update_finish == 1'b1 && {M0_reg[4], M1_reg[4], M2_reg[4], M3_reg[4], M4_reg[4], M5_reg[4]} == {24'hff0000}) begin
        $fclose(f1);
    end
end

//initial #(7.5+2.5+5*3*60+5) $finish;
always @(posedge ram_clk) begin
    //if({M0_reg[4], M1_reg[4], M2_reg[4], M3_reg[4], M4_reg[4], M5_reg[4]} == {`CN_DEGREE{4'hf}})
    if({M0_reg[4], M1_reg[4], M2_reg[4], M3_reg[4], M4_reg[4], M5_reg[4]} == {24'hff0000})
        $finish; 
end
*/
endmodule
