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

module vn_write_tb;

parameter ROM_RD_BW = 8;    // bit-width of one read port of BRAM based IB-ROM
parameter ROM_ADDR_BW = 11;  // bit-width of read address of BRAM based IB-ROM
							// #Entry: (128-entry*4-bit) / ROM_RD_BW)*25-iteration
							// ceil(log2(#Entry)) = 11-bit
						    
parameter PAGE_ADDR_BW = 6; // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
parameter ITER_ADDR_BW = 5;  // bit-width of addressing 25 iterationss
//parameter CN_TYPE_A = 1;    // the number of check node type in terms of its check node degree   
//parameter CN_TYPE_B = 1;     // the number of check node type in terms of its check node degree

parameter LOAD_CYCLE = 64; // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
parameter CN_RD_BW = 6;
parameter VN_RD_BW = 8;
parameter DN_RD_BW = 2;
parameter CN_ADDR_BW = 10;
parameter VN_ADDR_BW = 11;
parameter DN_ADDR_BW = 11;
parameter PIPELINE_DEPTH = 3;
	
// Memory System - Output
logic [VN_RD_BW-1:0] vn_iter0_m0_portA_dout;
logic [VN_RD_BW-1:0] vn_iter0_m0_portB_dout;
logic [VN_RD_BW-1:0] vn_iter0_m1_portA_dout;
logic [VN_RD_BW-1:0] vn_iter0_m1_portB_dout;
logic [VN_RD_BW-1:0] vn_iter1_m0_portA_dout;
logic [VN_RD_BW-1:0] vn_iter1_m0_portB_dout;
logic [VN_RD_BW-1:0] vn_iter1_m1_portA_dout;
logic [VN_RD_BW-1:0] vn_iter1_m1_portB_dout;

// Memory System - Ouput of Mux
logic [VN_RD_BW-1:0] vn_portA_dout [0:`IB_VNU_DECOMP_funNum-1];
logic [VN_RD_BW-1:0] vn_portB_dout [0:`IB_VNU_DECOMP_funNum-1];

// Memory Latch - Output
logic [ROM_RD_BW-1:0]   vn_latch_outA [0:`IB_VNU_DECOMP_funNum-1];
logic [ROM_RD_BW-1:0]   vn_latch_outB [0:`IB_VNU_DECOMP_funNum-1];
logic [ROM_ADDR_BW-1:0] vn_rom_read_addrA [0:`IB_VNU_DECOMP_funNum-1];
logic [ROM_ADDR_BW-1:0] vn_rom_read_addrB [0:`IB_VNU_DECOMP_funNum-1];

// IB-RAM Write Page Address Counter - Output
logic [PAGE_ADDR_BW-1:0] vn_wr_page_addr [0:`IB_VNU_DECOMP_funNum-1];

// CNU6 Update Iteration Control - Output
logic vn_rom_port_fetch [0:`IB_VNU_DECOMP_funNum-1]; // to enable the ib-map starting to fetch data from read port of IB ROM
logic vn_ram_write_en   [0:`IB_VNU_DECOMP_funNum-1];
logic vn_ram_mux_en     [0:`IB_VNU_DECOMP_funNum-1];
logic vn_iter_update    [0:`IB_VNU_DECOMP_funNum-1];
logic v3ib_rom_rst   [0:`IB_VNU_DECOMP_funNum-1];
logic [1:0] busy     [0:`IB_VNU_DECOMP_funNum-1];
logic [2:0] state    [0:`IB_VNU_DECOMP_funNum-1];
// CNU6 Update Iteration Control - Input
logic vn_iter_rqst        [0:`IB_VNU_DECOMP_funNum-1];
logic vn_iter_termination [0:`IB_VNU_DECOMP_funNum-1];
logic vn_pipeline_en      [0:`IB_VNU_DECOMP_funNum-1];
logic vn_rstn_cnu_fsm     [0:`IB_VNU_DECOMP_funNum-1];

// System Parameter - Input
logic [`IB_CNU_DECOMP_funNum-1:0] vn_iter_switch;
logic write_clk, read_clk;
//logic rstn; // using rstn_cnu_fsm as its alternative

mem_sys mem_u0(
	// Memory System - Ouput
	.vn_iter0_m0_portA_dout (vn_iter0_m0_portA_dout[VN_RD_BW-1:0]),
	.vn_iter0_m0_portB_dout (vn_iter0_m0_portB_dout[VN_RD_BW-1:0]),
	.vn_iter0_m1_portA_dout (vn_iter0_m1_portA_dout[VN_RD_BW-1:0]),
	.vn_iter0_m1_portB_dout (vn_iter0_m1_portB_dout[VN_RD_BW-1:0]),
	.vn_iter1_m0_portA_dout (vn_iter1_m0_portA_dout[VN_RD_BW-1:0]),
	.vn_iter1_m0_portB_dout (vn_iter1_m0_portB_dout[VN_RD_BW-1:0]),
	.vn_iter1_m1_portA_dout (vn_iter1_m1_portA_dout[VN_RD_BW-1:0]),
	.vn_iter1_m1_portB_dout (vn_iter1_m1_portB_dout[VN_RD_BW-1:0]),	
	
	// Memory System - Input
	.vn_iter0_m0_portA_addr (vn_rom_read_addrA[0]),
	.vn_iter0_m0_portB_addr (vn_rom_read_addrB[0]),
	.vn_iter0_m1_portA_addr (vn_rom_read_addrA[1]),
	.vn_iter0_m1_portB_addr (vn_rom_read_addrB[1]),
	.vn_iter1_m0_portA_addr (vn_rom_read_addrA[0]),
	.vn_iter1_m0_portB_addr (vn_rom_read_addrB[0]),
	.vn_iter1_m1_portA_addr (vn_rom_read_addrA[1]),
	.vn_iter1_m1_portB_addr (vn_rom_read_addrB[1]),	
	.write_clk (write_clk)
);

v3rom_iter_mux #(.ROM_RD_BW(VN_RD_BW)) v3rom_iter_mux_mA0(
	.dout        (vn_portA_dout[0]),
	.iter0_din   (vn_iter0_m0_portA_dout),
	.iter1_din   (vn_iter1_m0_portA_dout),
	.iter_switch (vn_iter_switch[0])
);
v3rom_iter_mux #(.ROM_RD_BW(VN_RD_BW)) v3rom_iter_mux_mA1(
	.dout        (vn_portA_dout[1]),
	.iter0_din   (vn_iter0_m1_portA_dout),
	.iter1_din   (vn_iter1_m1_portA_dout),
	.iter_switch (vn_iter_switch[1]) 
);
v3rom_iter_mux #(.ROM_RD_BW(VN_RD_BW)) v3rom_iter_mux_mB0(
	.dout        (vn_portB_dout[0]),
	.iter0_din   (vn_iter0_m0_portB_dout),
	.iter1_din   (vn_iter1_m0_portB_dout),
	.iter_switch (vn_iter_switch[0])
);
v3rom_iter_mux #(.ROM_RD_BW(VN_RD_BW)) v3rom_iter_mux_mB1(
	.dout        (vn_portB_dout[1]),
	.iter0_din   (vn_iter0_m1_portB_dout),
	.iter1_din   (vn_iter1_m1_portB_dout),
	.iter_switch (vn_iter_switch[1]) 
);

generate
	genvar i;
		for(i=0;i<`IB_VNU_DECOMP_funNum;i=i+1) begin : insta_vn_iter_switch
			v3rom_iter_selector #(.ITER_ADDR_BW(ITER_ADDR_BW)) v3rom_iter_selector_m01(
				.iter_switch   (vn_iter_switch[i]),
				.rom_read_addr (vn_rom_read_addrA[i][ROM_ADDR_BW-1:ITER_ADDR_BW]),
				.write_clk     (write_clk),
				.rstn          (vn_rstn_cnu_fsm[i])
			);
		
			initial vn_iter_switch[i] <= 1'b0;
			always @(posedge write_clk) begin
				if((vn_rom_read_addrA[i][ROM_ADDR_BW-1:ITER_ADDR_BW] == 5'd24))
					vn_iter_switch[i] <= ~vn_iter_switch[i];
			end
			
			vn_mem_latch #(
				.ROM_RD_BW    (ROM_RD_BW), 
				.ROM_ADDR_BW  (ROM_ADDR_BW),    			    
				.PAGE_ADDR_BW (PAGE_ADDR_BW), 								
				.ITER_ADDR_BW (ITER_ADDR_BW)
			) vn_mem_latch_m01(
				// Memory Latch - Output	
				.latch_outA (vn_latch_outA[i]),
				.latch_outB (vn_latch_outB[i]),
				.rom_read_addrA (vn_rom_read_addrA[i]),
				.rom_read_addrB (vn_rom_read_addrB[i]),
				// Memory Latch - Input 
				.latch_inA (vn_portA_dout[i]),
				.latch_inB (vn_portB_dout[i]),
				.latch_iterA (5'd0), // base address for latch A to indicate the iteration index
				.latch_iterB (5'd0), // base address for latch B to indicate the iteration index
				.rstn (vn_rom_port_fetch[i]), // asserted/deasserted by "rom_port_fetch" signal of Iteration Update Control Unit
				.write_clk (write_clk)
			);

			vn_Waddr_counter #(.PAGE_ADDR_BW (PAGE_ADDR_BW)) vn_page_addr_cntM01 (
				.wr_page_addr (vn_wr_page_addr[i]),
				
				.en (vn_ram_write_en[i]),
				.write_clk (write_clk),
				.rstn (~c6ib_rom_rst[i])
			);

			vnu3_wr_fsm #(.LOAD_CYCLE(LOAD_CYCLE)) vnu3_wr_fsm_u0 (
				// FSM - Output
				.rom_port_fetch (vn_rom_port_fetch[i]), // to enable the ib-map starting to fetch data from read port of IB ROM
				.ram_write_en   (vn_ram_write_en[i]),
				.ram_mux_en     (vn_ram_mux_en[i]),
				.iter_update    (vn_iter_update[i]),
				.c6ib_rom_rst   (vn_c6ib_rom_rst[i]),
				.busy           (vn_busy[i]),
				.state          (vn_state[i]),
				// FSM - Input
				.write_clk        (write_clk),
				.rstn             (vn_rstn_cnu_fsm[i]),
				.iter_rqst        (vn_iter_rqst[i]),
				.iter_termination (vn_iter_termination[i])
				//.pipeline_en    (vn_pipeline_en[i])	// deprecated
			);
		end
endgenerate

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// IB-RAMs Instantiation
		// Instantiation of F_0
		wire [`QUAN_SIZE-1:0] f0_out[0:7];
		wire [`QUAN_SIZE-1:0] vnu0_c2v [0:1]; // c2v[1] and c2v[2]
		wire [`QUAN_SIZE-1:0] vnu1_c2v [0:1]; // c2v[1] and c2v[2]
		wire [`QUAN_SIZE-1:0] vnu2_c2v [0:1]; // c2v[1] and c2v[2]
		wire [`QUAN_SIZE-1:0] vnu3_c2v [0:1]; // c2v[1] and c2v[2]	
		wire [1:0] vnu0_tranEn_out;
		wire [1:0] vnu1_tranEn_out;
		wire [1:0] vnu2_tranEn_out;
		wire [1:0] vnu3_tranEn_out;
	
		// Dummy instantiation just for area overhead evaluation
		wire [`VN_DEGREE+1-2-1-1:0] read_addr_offset_internal;
		vnu3_f0 u_f0(
			.read_addr_offset_out (read_addr_offset_internal[0]), // to forward the current multi-frame offset signal to the next sub-datapath	
			// For the first VNU
			.vnu0_tPort0 (f0_out[0]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_tPort1 (f0_out[1]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_c2v1   (vnu0_c2v[0]),
			.vnu0_c2v2   (vnu0_c2v[1]),
			// For the second VNU       
			.vnu1_tPort0 (f0_out[2]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_tPort1 (f0_out[3]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_c2v1   (vnu1_c2v[0]),
			.vnu1_c2v2   (vnu1_c2v[1]),
			// For the third VNU        
			.vnu2_tPort0 (f0_out[4]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_tPort1 (f0_out[5]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_c2v1   (vnu2_c2v[0]),
			.vnu2_c2v2   (vnu2_c2v[1]),
			// For the fourth VNU       
			.vnu3_tPort0 (f0_out[6]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_tPort1 (f0_out[7]  ), // internal signals accounting for each 128-entry partial LUT's output	
			.vnu3_c2v1   (vnu3_c2v[0]),
			.vnu3_c2v2   (vnu3_c2v[1]),
			// For first to fourth VNUs (output port)
			.vnu0_tranEn_out0 (vnu0_tranEn_out[0]),
			.vnu0_tranEn_out1 (vnu0_tranEn_out[1]),
			.vnu1_tranEn_out0 (vnu1_tranEn_out[0]),
			.vnu1_tranEn_out1 (vnu1_tranEn_out[1]),
			.vnu2_tranEn_out0 (vnu2_tranEn_out[0]),
			.vnu2_tranEn_out1 (vnu2_tranEn_out[1]),
			.vnu3_tranEn_out0 (vnu3_tranEn_out[0]),
			.vnu3_tranEn_out1 (vnu3_tranEn_out[1]),
		
			// From the first VNU
			.vnu0_c2v_0  (c2v_0[(`VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_c2v_1  (c2v_1[(`VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_c2v_2  (c2v_2[(`VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_ch_llr (vnu0_ch_llr[QUAN_SIZE-1:0]),
	
			// From the second VNU
			.vnu1_c2v_0  (c2v_0[(`VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_c2v_1  (c2v_1[(`VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_c2v_2  (c2v_2[(`VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_ch_llr (vnu1_ch_llr[QUAN_SIZE-1:0]),
	
			// From the third VNU
			.vnu2_c2v_0  (c2v_0[(`VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_c2v_1  (c2v_1[(`VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_c2v_2  (c2v_2[(`VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_ch_llr (vnu2_ch_llr[QUAN_SIZE-1:0]),
	
			// From the fourth VNU
			.vnu3_c2v_0  (c2v_0[(`VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_c2v_1  (c2v_1[(`VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_c2v_2  (c2v_2[(`VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_ch_llr (vnu3_ch_llr[QUAN_SIZE-1:0]),
		
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset), // offset determing the switch between multi-frame
		
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_0[ENTRY_ADDR-1:0]),
			// Ieration-Update Data
			.ram_write_data_0 (ram_write_data_0[LUT_PORT_SIZE*BANK_NUM-1:0]),
	
			.write_clk (write_clk),
			.ib_ram_we (ib_ram_we[0])
		);

		// Instantiation of F_1
		wire [`QUAN_SIZE-1:0] vnu0_v2c[0:2];
		wire [`QUAN_SIZE-1:0] vnu1_v2c[0:2];
		wire [`QUAN_SIZE-1:0] vnu2_v2c[0:2];
		wire [`QUAN_SIZE-1:0] vnu3_v2c[0:2];
		wire [`QUAN_SIZE-1:0] vnu0_E_reg2, vnu1_E_reg2, vnu2_E_reg2, vnu3_E_reg2;
		vnu3_f1 u_f1(
			.read_addr_offset_out (read_addr_offset_outSet[j]), // to forward the current multi-frame offset signal to the next sub-datapath	
			// For the first VNU
			.vnu0_v2c0 (vnu0_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_v2c1 (vnu0_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_v2c2 (vnu0_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_E_reg2 (vnu0_E_reg2[`QUAN_SIZE-1:0]),
			.vnu0_tranEn_out0 (vnu0_tranEn_out0),
			// For the second VNU       
			.vnu1_v2c0 (vnu1_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_v2c1 (vnu1_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_v2c2 (vnu1_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_E_reg2 (vnu1_E_reg2[`QUAN_SIZE-1:0]),
			.vnu1_tranEn_out0 (vnu1_tranEn_out0),
			// For the third VNU        
			.vnu2_v2c0 (vnu2_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_v2c1 (vnu2_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_v2c2 (vnu2_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_E_reg2 (vnu2_E_reg2[`QUAN_SIZE-1:0]),
			.vnu2_tranEn_out0 (vnu2_tranEn_out0),
			// For the fourth VNU       
			.vnu3_v2c0 (vnu3_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_v2c1 (vnu3_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_v2c2 (vnu3_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_E_reg2 (vnu3_E_reg2[`QUAN_SIZE-1:0]),	
			.vnu3_tranEn_out0 (vnu3_tranEn_out0),
			// From the first VNU
			.vnu0_t00   (f0_out[0]  ),
			.vnu0_t01   (f0_out[1]  ),
			.vnu0_c2v_1 (vnu0_c2v[0]),
			.vnu0_c2v_2 (vnu0_c2v[1]),
			.vnu0_tranEn_in0 (vnu0_tranEn_out[0]),
			.vnu0_tranEn_in1 (vnu0_tranEn_out[1]),
	
			// From the second VNU
			.vnu1_t00   (f0_out[2]  ),
			.vnu1_t01   (f0_out[3]  ),
			.vnu1_c2v_1 (vnu1_c2v[0]),
			.vnu1_c2v_2 (vnu1_c2v[1]), 
			.vnu1_tranEn_in0 (vnu1_tranEn_out[0]),
			.vnu1_tranEn_in1 (vnu1_tranEn_out[1]),	
	
			// From the third VNU
			.vnu2_t00   (f0_out[4]  ),
			.vnu2_t01   (f0_out[5]  ),
			.vnu2_c2v_1 (vnu2_c2v[0]),
			.vnu2_c2v_2 (vnu2_c2v[1]),
			.vnu2_tranEn_in0 (vnu2_tranEn_out[0]),
			.vnu2_tranEn_in1 (vnu2_tranEn_out[1]),
	
			// From the fourth VNU
			.vnu3_t00   (f0_out[6]  ),
			.vnu3_t01   (f0_out[7]  ),
			.vnu3_c2v_1 (vnu3_c2v[0]),
			.vnu3_c2v_2 (vnu3_c2v[1]),
			.vnu3_tranEn_in0 (vnu3_tranEn_out[0]),
			.vnu3_tranEn_in1 (vnu3_tranEn_out[1]),
		
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset_internal[0]), // offset determing the switch between multi-frame
		
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_1[ENTRY_ADDR-1:0]),
			// Ieration-Update Data
			.ram_write_data_1 (ram_write_data_1[LUT_PORT_SIZE*BANK_NUM-1:0]),
	
			.write_clk (write_clk),
			.ib_ram_we (ib_ram_we[1])
		);	
	
		dnu_f0 u_f2(
			//output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath	
			.dnu0_hard_decision (termination_decision[`VNU3_INSTANTIATE_UNIT*j+0]), // internal signals accounting for each 128-entry partial LUT's output
			.dnu1_hard_decision (termination_decision[`VNU3_INSTANTIATE_UNIT*j+1]), // internal signals accounting for each 128-entry partial LUT's output		        
			.dnu2_hard_decision (termination_decision[`VNU3_INSTANTIATE_UNIT*j+2]), // internal signals accounting for each 128-entry partial LUT's output
			.dnu3_hard_decision (termination_decision[`VNU3_INSTANTIATE_UNIT*j+3]), // internal signals accounting for each 128-entry partial LUT's output
		
			// From the first DNU
			.vnu0_t10		 (vnu0_v2c[0]),
			.vnu0_c2v_2      (vnu0_E_reg2[`QUAN_SIZE-1:0]),
			.vnu0_tranEn_in0 (vnu0_tranEn_out0),

			// From the second DNU
			.vnu1_t10		 (vnu1_v2c[0]),
			.vnu1_c2v_2      (vnu1_E_reg2[`QUAN_SIZE-1:0]),
			.vnu1_tranEn_in0 (vnu1_tranEn_out0),

			// From the third DNU
			.vnu2_t10		 (vnu2_v2c[0]),
			.vnu2_c2v_2      (vnu2_E_reg2[`QUAN_SIZE-1:0]),
			.vnu2_tranEn_in0 (vnu2_tranEn_out0),
		
			// From the fourth DNU
			.vnu3_t10		 (vnu3_v2c[0]),
			.vnu3_c2v_2      (vnu3_E_reg2[`QUAN_SIZE-1:0]),
			.vnu3_tranEn_in0 (vnu3_tranEn_out0),
		
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset_outSet[j]), // offset determing the switch between multi-frame 
			.page_addr_ram (dnu_page_addr_ram),
			.ram_write_data_1 (dnu_ram_write_data[BANK_NUM-1:0]),
			.write_clk (write_clk),
			.ib_ram_we (ib_dnu_ram_we)
		);

		ib_vnu_3_pipeOut u_v2c_out0(
			.M0_src (v2c_0[(`VNU3_INSTANTIATE_UNIT*j)]),
			.M1_src (v2c_1[(`VNU3_INSTANTIATE_UNIT*j)]),
			.M2_src (v2c_2[(`VNU3_INSTANTIATE_UNIT*j)]),

			.M0 (vnu0_v2c[0]),
			.M1 (vnu0_v2c[1]),
			.M2 (vnu0_v2c[2]),
			.ch_llr (vnu0_ch_llr[`QUAN_SIZE-1:0]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out1(
			.M0_src (v2c_0[(`VNU3_INSTANTIATE_UNIT*j)+1]),
			.M1_src (v2c_1[(`VNU3_INSTANTIATE_UNIT*j)+1]),
			.M2_src (v2c_2[(`VNU3_INSTANTIATE_UNIT*j)+1]),

			.M0 (vnu1_v2c[0]),
			.M1 (vnu1_v2c[1]),
			.M2 (vnu1_v2c[2]),
			.ch_llr (vnu1_ch_llr[`QUAN_SIZE-1:0]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out2(
			.M0_src (v2c_0[(`VNU3_INSTANTIATE_UNIT*j)+2]),
			.M1_src (v2c_1[(`VNU3_INSTANTIATE_UNIT*j)+2]),
			.M2_src (v2c_2[(`VNU3_INSTANTIATE_UNIT*j)+2]),

			.M0 (vnu2_v2c[0]),
			.M1 (vnu2_v2c[1]),
			.M2 (vnu2_v2c[2]),
			.ch_llr (vnu2_ch_llr[`QUAN_SIZE-1:0]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out3(
			.M0_src (v2c_0[(`VNU3_INSTANTIATE_UNIT*j)+3]),
			.M1_src (v2c_1[(`VNU3_INSTANTIATE_UNIT*j)+3]),
			.M2_src (v2c_2[(`VNU3_INSTANTIATE_UNIT*j)+3]),

			.M0 (vnu3_v2c[0]),
			.M1 (vnu3_v2c[1]),
			.M2 (vnu3_v2c[2]),
			.ch_llr (vnu3_ch_llr[`QUAN_SIZE-1:0]),
			.v2c_src (v2c_src)              
		);
	end
// End of IB-RAMs Instantiation 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
initial begin
	#0 write_clk <= 0;
	forever #3.333 write_clk <= ~write_clk; // 150MHz
end
initial begin
	#0 read_clk <= 0;
	forever #5 read_clk <= ~read_clk; // 100MHz
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
			read_addr_offset <= 1'b0; // the mult-frame is not tested in this time
			
			#200;
			{rstn_cnu_fsm[i], iter_rqst[i], iter_termination[i]} <= 3'b110; 
		
			wait(update_finish[i] == 1'b1);
			{rstn_cnu_fsm[i], iter_rqst[i], iter_termination[i]} <= 3'b001;
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
/*
initial begin
	wait(&{update_finish[`IB_CNU_DECOMP_funNum-1:0]});
	#100 $finish;
end
*/
initial begin
    #0;
	{v2c_0[0], v2c_1[0]} <= 8'hff;
    {v2c_0[1], v2c_1[1]} <= 8'd0;
    {v2c_0[2], v2c_1[2]} <= 8'd0;
    {v2c_0[3], v2c_1[3]} <= 8'd0;
    {v2c_0[4], v2c_1[4]} <= 8'd0;
    {v2c_0[5], v2c_1[5]} <= 8'd0;
end

reg [`QUAN_SIZE*`CN_DEGREE-1:0] v2c_cnt;
initial #0 v2c_cnt[`QUAN_SIZE*`CN_DEGREE-1:0] <= 0;

always @(posedge read_clk) begin
    if({ram_write_en[0], iter_update[0], c6ib_rom_rst[0]} == 3'b001 && update_finish[0] == 1'b1)
		v2c_cnt[`QUAN_SIZE*`CN_DEGREE-1:0] <= v2c_cnt[`QUAN_SIZE*`CN_DEGREE-1:0]+1'b1;
end
always @(posedge read_clk) begin
    if({ram_write_en[0], iter_update[0], c6ib_rom_rst[0]} == 3'b001 && update_finish[0] == 1'b1) begin 
        // Simulation for CNU6_0
 	    v2c_0[0] <= v2c_cnt[3:0];
        v2c_0[1] <= v2c_cnt[7:4];
        v2c_0[2] <= v2c_cnt[11:8];
        v2c_0[3] <= v2c_cnt[15:12];
        v2c_0[4] <= v2c_cnt[19:16];
        v2c_0[5] <= v2c_cnt[23:20];
		// Simulation for CNU6_1
		v2c_1[0] <= v2c_cnt[3:0];
        v2c_1[1] <= v2c_cnt[7:4];
        v2c_1[2] <= v2c_cnt[11:8];
        v2c_1[3] <= v2c_cnt[15:12];
        v2c_1[4] <= v2c_cnt[19:16];
        v2c_1[5] <= v2c_cnt[23:20];
    end
end

integer cnu_ram_f [0:`IB_CNU_DECOMP_funNum-1];
initial begin
    cnu_ram_f[0] = $fopen("cnu_ram_dataOut.f0.csv", "w");
	cnu_ram_f[1] = $fopen("cnu_ram_dataOut.f1.csv", "w");
	cnu_ram_f[2] = $fopen("cnu_ram_dataOut.f2.csv", "w");
	cnu_ram_f[3] = $fopen("cnu_ram_dataOut.f3.csv", "w");
end
reg [`QUAN_SIZE*5-1:0] M0_reg[0:1]; reg [`QUAN_SIZE*5-1:0] M1_reg[0:1]; reg [`QUAN_SIZE*5-1:0] M2_reg[0:1];
reg [`QUAN_SIZE*5-1:0] M3_reg[0:1]; reg [`QUAN_SIZE*5-1:0] M4_reg[0:1]; reg [`QUAN_SIZE*5-1:0] M5_reg[0:1];
initial begin
    #0;//#833.5;
    {M0_reg[0], M0_reg[1]} <= 40'd0;
    {M1_reg[0], M1_reg[1]} <= 40'd0;
    {M2_reg[0], M2_reg[1]} <= 40'd0;
    {M3_reg[0], M3_reg[1]} <= 40'd0;
    {M4_reg[0], M4_reg[1]} <= 40'd0;
    {M5_reg[0], M5_reg[1]} <= 40'd0;      
end
always @(posedge read_clk) begin
    if({ram_write_en[0], iter_update[0], c6ib_rom_rst[0]} == 3'b001 && update_finish[0] == 1'b1) begin
		M0_reg[0] <= {v2c_0[0], M0_reg[0][`QUAN_SIZE*5-1:`QUAN_SIZE]};
		M1_reg[0] <= {v2c_0[1], M1_reg[0][`QUAN_SIZE*5-1:`QUAN_SIZE]};
		M2_reg[0] <= {v2c_0[2], M2_reg[0][`QUAN_SIZE*5-1:`QUAN_SIZE]};
		M3_reg[0] <= {v2c_0[3], M3_reg[0][`QUAN_SIZE*5-1:`QUAN_SIZE]};
		M4_reg[0] <= {v2c_0[4], M4_reg[0][`QUAN_SIZE*5-1:`QUAN_SIZE]};
		M5_reg[0] <= {v2c_0[5], M5_reg[0][`QUAN_SIZE*5-1:`QUAN_SIZE]};

		M0_reg[1] <= {v2c_1[0], M0_reg[1][`QUAN_SIZE*5-1:`QUAN_SIZE]};
		M1_reg[1] <= {v2c_1[1], M1_reg[1][`QUAN_SIZE*5-1:`QUAN_SIZE]};
		M2_reg[1] <= {v2c_1[2], M2_reg[1][`QUAN_SIZE*5-1:`QUAN_SIZE]};
		M3_reg[1] <= {v2c_1[3], M3_reg[1][`QUAN_SIZE*5-1:`QUAN_SIZE]};
		M4_reg[1] <= {v2c_1[4], M4_reg[1][`QUAN_SIZE*5-1:`QUAN_SIZE]};
		M5_reg[1] <= {v2c_1[5], M5_reg[1][`QUAN_SIZE*5-1:`QUAN_SIZE]};
    end
end
always @(posedge read_clk) begin
    if({ram_write_en[0], iter_update[0], c6ib_rom_rst[0]} == 3'b001 && update_finish[0] == 1'b1) begin
        //if({M0_reg[4], M1_reg[4], M2_reg[4], M3_reg[4], M4_reg[4], M5_reg[4]} != {`CN_DEGREE{4'hf}}) begin
        if({cnu0_f0_M_reg[0],cnu0_f0_M_reg[1],cnu0_f0_M_reg[2],cnu0_f0_M_reg[3],cnu0_f0_M_reg[4],cnu0_f0_M_reg[5]} != {24'hffffff}) begin
            // For F0
			$fwrite(cnu_ram_f[0], "%h,%h,%h,%h,%h,%h,%h,%h\n",
				cnu0_f0_M_reg[0],cnu0_f0_M_reg[1],cnu0_f0_M_reg[2],cnu0_f0_M_reg[3],cnu0_f0_M_reg[4],cnu0_f0_M_reg[5],
				f0_out[0], f0_out[1]
            );
			
			// For F1
	        $fwrite(cnu_ram_f[1], "%h,%h,%h,%h,%h,%h,%h,%h\n",
				cnu0_f0_M_reg[0],cnu0_f0_M_reg[1],cnu0_f0_M_reg[2],cnu0_f0_M_reg[3],cnu0_f0_M_reg[4],cnu0_f0_M_reg[5],
				f1_out[0], f1_out[1]
            );

			// For F2
			$fwrite(cnu_ram_f[2], "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h\n",
				cnu0_f0_M_reg[0],cnu0_f0_M_reg[1],cnu0_f0_M_reg[2],cnu0_f0_M_reg[3],cnu0_f0_M_reg[4],cnu0_f0_M_reg[5],
				cnu0_f2_out[0], cnu0_f2_out[1], cnu0_f2_out[2], cnu0_f2_out[3]
            );		
		end
		if({cnu0_v2c_probe[0],cnu0_v2c_probe[1],cnu0_v2c_probe[2],cnu0_v2c_probe[3],cnu0_v2c_probe[4],cnu0_v2c_probe[5]} != {24'hffffff}) begin
			// For F3
			$fwrite(cnu_ram_f[3], "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h\n",
				cnu0_v2c_probe[0],cnu0_v2c_probe[1],cnu0_v2c_probe[2],cnu0_v2c_probe[3],cnu0_v2c_probe[4],cnu0_v2c_probe[5],
				cnu0_c2v[0], cnu0_c2v[1], cnu0_c2v[2], cnu0_c2v[3], cnu0_c2v[4], cnu0_c2v[5]
            );		
        end
        //else if({M0_reg[4], M1_reg[4], M2_reg[4], M3_reg[4], M4_reg[4], M5_reg[4]} == {`CN_DEGREE{4'hf}}) begin
        else if({cnu0_f0_M_reg[0],cnu0_f0_M_reg[1],cnu0_f0_M_reg[2],cnu0_f0_M_reg[3],cnu0_f0_M_reg[4],cnu0_f0_M_reg[5]} == {24'hffffff}) begin
            // For F0
			$fwrite(cnu_ram_f[0], "%h,%h,%h,%h,%h,%h,%h,%h",
				cnu0_f0_M_reg[0],cnu0_f0_M_reg[1],cnu0_f0_M_reg[2],cnu0_f0_M_reg[3],cnu0_f0_M_reg[4],cnu0_f0_M_reg[5],
				f0_out[0], f0_out[1]
            );
			
			// For F1
	        $fwrite(cnu_ram_f[1], "%h,%h,%h,%h,%h,%h,%h,%h",
				cnu0_f0_M_reg[0],cnu0_f0_M_reg[1],cnu0_f0_M_reg[2],cnu0_f0_M_reg[3],cnu0_f0_M_reg[4],cnu0_f0_M_reg[5],
				f1_out[0], f1_out[1]
            );

			// For F2
			$fwrite(cnu_ram_f[2], "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h",
				cnu0_f0_M_reg[0],cnu0_f0_M_reg[1],cnu0_f0_M_reg[2],cnu0_f0_M_reg[3],cnu0_f0_M_reg[4],cnu0_f0_M_reg[5],
				cnu0_f2_out[0], cnu0_f2_out[1], cnu0_f2_out[2], cnu0_f2_out[3]
            );		
		end	
		
		if({cnu0_v2c_probe[0],cnu0_v2c_probe[1],cnu0_v2c_probe[2],cnu0_v2c_probe[3],cnu0_v2c_probe[4],cnu0_v2c_probe[5]} == {24'hffffff}) begin
			// For F3
			$fwrite(cnu_ram_f[3], "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h",
				cnu0_v2c_probe[0],cnu0_v2c_probe[1],cnu0_v2c_probe[2],cnu0_v2c_probe[3],cnu0_v2c_probe[4],cnu0_v2c_probe[5],
				cnu0_c2v[0], cnu0_c2v[1], cnu0_c2v[2], cnu0_c2v[3], cnu0_c2v[4], cnu0_c2v[5]
            );				
        end    
    end
end
always @(posedge read_clk) begin
    //if(update_finish == 1'b1 && {M0_reg[4], M1_reg[4], M2_reg[4], M3_reg[4], M4_reg[4], M5_reg[4]} == {`CN_DEGREE{4'hf}}) begin
    if(update_finish[0] == 1'b1 && {cnu0_v2c_probe[0],cnu0_v2c_probe[1],cnu0_v2c_probe[2],cnu0_v2c_probe[3],cnu0_v2c_probe[4],cnu0_v2c_probe[5]} == {24'hffffff}) begin
        $fclose(cnu_ram_f[0]); 
		$fclose(cnu_ram_f[1]); 
		$fclose(cnu_ram_f[2]); 
		$fclose(cnu_ram_f[3]);
    end
end

//initial #(7.5+2.5+5*3*60+5) $finish;
always @(posedge read_clk) begin
    //if({M0_reg[4], M1_reg[4], M2_reg[4], M3_reg[4], M4_reg[4], M5_reg[4]} == {`CN_DEGREE{4'hf}})
    if({cnu0_v2c_probe[0],cnu0_v2c_probe[1],cnu0_v2c_probe[2],cnu0_v2c_probe[3],cnu0_v2c_probe[4],cnu0_v2c_probe[5]} == {24'hffffff})
        $finish; 
end
endmodule