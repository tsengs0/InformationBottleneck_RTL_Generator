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

parameter QUAN_SIZE = 4;
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
/*Variable Node*/
logic [VN_RD_BW-1:0] vn_iter0_m0_portA_dout;
logic [VN_RD_BW-1:0] vn_iter0_m0_portB_dout;
logic [VN_RD_BW-1:0] vn_iter0_m1_portA_dout;
logic [VN_RD_BW-1:0] vn_iter0_m1_portB_dout;
logic [VN_RD_BW-1:0] vn_iter1_m0_portA_dout;
logic [VN_RD_BW-1:0] vn_iter1_m0_portB_dout;
logic [VN_RD_BW-1:0] vn_iter1_m1_portA_dout;
logic [VN_RD_BW-1:0] vn_iter1_m1_portB_dout;
/*Decision Node*/
logic [DN_RD_BW-1:0] dn_iter0_m2_portA_dout;
logic [DN_RD_BW-1:0] dn_iter0_m2_portB_dout;
logic [DN_RD_BW-1:0] dn_iter1_m2_portA_dout;
logic [DN_RD_BW-1:0] dn_iter1_m2_portB_dout;


// Memory System - Ouput of Mux
/*Variable Node*/
logic [VN_RD_BW-1:0] vn_portA_dout [0:`IB_VNU_DECOMP_funNum-1];
logic [VN_RD_BW-1:0] vn_portB_dout [0:`IB_VNU_DECOMP_funNum-1];
/*Decision Node*/
logic [DN_RD_BW-1:0] dn_portA_dout;
logic [DN_RD_BW-1:0] dn_portB_dout;

// Memory Latch - Output
/*Variable Node*/
logic [ROM_RD_BW-1:0]   vn_latch_outA [0:`IB_VNU_DECOMP_funNum-1];
logic [ROM_RD_BW-1:0]   vn_latch_outB [0:`IB_VNU_DECOMP_funNum-1];
logic [ROM_ADDR_BW-1:0] vn_rom_read_addrA [0:`IB_VNU_DECOMP_funNum-1];
logic [ROM_ADDR_BW-1:0] vn_rom_read_addrB [0:`IB_VNU_DECOMP_funNum-1];
/*Decision Node*/
logic [ROM_RD_BW-1:0]   dn_latch_outA;
logic [ROM_RD_BW-1:0]   dn_latch_outB;
logic [ROM_ADDR_BW-1:0] dn_rom_read_addrA;
logic [ROM_ADDR_BW-1:0] dn_rom_read_addrB;

// IB-RAM Write Page Address Counter - Output
/*Variable Node*/
logic [PAGE_ADDR_BW-1:0] vn_wr_page_addr [0:`IB_VNU_DECOMP_funNum-1];
/*Decision Node*/
logic [PAGE_ADDR_BW-1:0] dn_wr_page_addr;

// VNU3 Update Iteration Control - Output
/*Variable Node*/
logic vn_rom_port_fetch [0:`IB_VNU_DECOMP_funNum-1]; // to enable the ib-map starting to fetch data from read port of IB ROM
logic vn_ram_write_en   [0:`IB_VNU_DECOMP_funNum-1];
logic vn_ram_mux_en     [0:`IB_VNU_DECOMP_funNum-1];
logic vn_iter_update    [0:`IB_VNU_DECOMP_funNum-1];
logic v3ib_rom_rst   [0:`IB_VNU_DECOMP_funNum-1];
logic [1:0] vn_busy     [0:`IB_VNU_DECOMP_funNum-1];
logic [2:0] vn_state    [0:`IB_VNU_DECOMP_funNum-1];
// VNU3 Update Iteration Control - Input
logic vn_iter_rqst        [0:`IB_VNU_DECOMP_funNum-1];
logic vn_iter_termination [0:`IB_VNU_DECOMP_funNum-1];
logic vn_pipeline_en      [0:`IB_VNU_DECOMP_funNum-1];
logic rstn_vnu_fsm     [0:`IB_VNU_DECOMP_funNum-1];

/*Decision Node*/
logic dn_rom_port_fetch; // to enable the ib-map starting to fetch data from read port of IB ROM
logic dn_ram_write_en;   
logic dn_ram_mux_en;     
logic dn_iter_update;    
logic d3ib_rom_rst;
logic [1:0] dn_busy;
logic [2:0] dn_state;
// DNU3 Update Iteration Control - Input
logic dn_iter_rqst;       
logic dn_iter_termination;
logic dn_pipeline_en;     
logic rstn_dnu_fsm;

// System Parameter - Input
logic [`IB_VNU_DECOMP_funNum-1:0] vn_iter_switch;
logic dn_iter_switch;
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
	.dn_iter0_portA_dout (dn_iter0_m2_portA_dout[DN_RD_BW-1:0]),
	.dn_iter0_portB_dout (dn_iter0_m2_portB_dout[DN_RD_BW-1:0]),
	.dn_iter1_portA_dout (dn_iter1_m2_portA_dout[DN_RD_BW-1:0]),
	.dn_iter1_portB_dout (dn_iter1_m2_portB_dout[DN_RD_BW-1:0]),	
	
	// Memory System - Input
	.vn_iter0_m0_portA_addr (vn_rom_read_addrA[0]),
	.vn_iter0_m0_portB_addr (vn_rom_read_addrB[0]),
	.vn_iter0_m1_portA_addr (vn_rom_read_addrA[1]),
	.vn_iter0_m1_portB_addr (vn_rom_read_addrB[1]),
	.vn_iter1_m0_portA_addr (vn_rom_read_addrA[0]),
	.vn_iter1_m0_portB_addr (vn_rom_read_addrB[0]),
	.vn_iter1_m1_portA_addr (vn_rom_read_addrA[1]),
	.vn_iter1_m1_portB_addr (vn_rom_read_addrB[1]),	
	.dn_iter0_portA_addr (dn_rom_read_addrA[ROM_ADDR_BW-1:0]),
	.dn_iter0_portB_addr (dn_rom_read_addrB[ROM_ADDR_BW-1:0]),
	.dn_iter1_portA_addr (dn_rom_read_addrA[ROM_ADDR_BW-1:0]),
	.dn_iter1_portB_addr (dn_rom_read_addrB[ROM_ADDR_BW-1:0]),
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
d3rom_iter_mux #(.ROM_RD_BW(DN_RD_BW)) d3rom_iter_mux_mA2(
	.dout        (dn_portA_dout[DN_RD_BW-1:0]),
	.iter0_din   (dn_iter0_m2_portA_dout[DN_RD_BW-1:0]),
	.iter1_din   (dn_iter1_m2_portA_dout[DN_RD_BW-1:0]),
	.iter_switch (dn_iter_switch) 
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
d3rom_iter_mux #(.ROM_RD_BW(DN_RD_BW)) d3rom_iter_mux_mB2(
	.dout        (dn_portB_dout[DN_RD_BW-1:0]),
	.iter0_din   (dn_iter0_m2_portB_dout[DN_RD_BW-1:0]),
	.iter1_din   (dn_iter1_m2_portB_dout[DN_RD_BW-1:0]),
	.iter_switch (dn_iter_switch) 
);

/*Variable Node*/
generate
	genvar i;
		for(i=0;i<`IB_VNU_DECOMP_funNum;i=i+1) begin : insta_vn_iter_switch
			v3rom_iter_selector #(.ITER_ADDR_BW(ITER_ADDR_BW)) v3rom_iter_selector_m01(
				.iter_switch   (vn_iter_switch[i]),
				.rom_read_addr (vn_rom_read_addrA[i][ROM_ADDR_BW-1:ITER_ADDR_BW]),
				.write_clk     (write_clk),
				.rstn          (rstn_vnu_fsm[i])
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

			vn_Waddr_counter #(.PAGE_ADDR_BW (PAGE_ADDR_BW)) vn_page_addr_vntM01 (
				.wr_page_addr (vn_wr_page_addr[i]),
				
				.en (vn_ram_write_en[i]),
				.write_clk (write_clk),
				.rstn (~v3ib_rom_rst[i])
			);

			vnu3_wr_fsm #(.LOAD_CYCLE(LOAD_CYCLE)) vnu3_wr_fsm_u0 (
				// FSM - Output
				.rom_port_fetch (vn_rom_port_fetch[i]), // to enable the ib-map starting to fetch data from read port of IB ROM
				.ram_write_en   (vn_ram_write_en[i]),
				.ram_mux_en     (vn_ram_mux_en[i]),
				.iter_update    (vn_iter_update[i]),
				.v3ib_rom_rst   (v3ib_rom_rst[i]),
				.busy           (vn_busy[i]),
				.state          (vn_state[i]),
				// FSM - Input
				.write_clk        (write_clk),
				.rstn             (rstn_vnu_fsm[i]),
				.iter_rqst        (vn_iter_rqst[i]),
				.iter_termination (vn_iter_termination[i])
				//.pipeline_en    (vn_pipeline_en[i])	// deprecated
			);
		end
endgenerate
/*Decision Node*/
d3rom_iter_selector #(.ITER_ADDR_BW(ITER_ADDR_BW)) d3rom_iter_selector_m2(
	.iter_switch   (dn_iter_switch),
	.rom_read_addr (dn_rom_read_addrA[ROM_ADDR_BW-1:ITER_ADDR_BW]),
	.write_clk     (write_clk),
	.rstn          (rstn_dnu_fsm)
);

initial dn_iter_switch <= 1'b0;
always @(posedge write_clk) begin
	if((dn_rom_read_addrA[ROM_ADDR_BW-1:ITER_ADDR_BW] == 5'd24))
		dn_iter_switch <= ~dn_iter_switch;
end

dn_mem_latch #(
	.ROM_RD_BW    (ROM_RD_BW), 
	.ROM_ADDR_BW  (ROM_ADDR_BW),    			    
	.PAGE_ADDR_BW (PAGE_ADDR_BW), 								
	.ITER_ADDR_BW (ITER_ADDR_BW)
) dn_mem_latch_m2(
	// Memory Latch - Output	
	.latch_outA (dn_latch_outA[ROM_RD_BW-1:0]),
	.latch_outB (dn_latch_outB[ROM_RD_BW-1:0]),
	.rom_read_addrA (dn_rom_read_addrA[ROM_ADDR_BW-1:0]),
	.rom_read_addrB (dn_rom_read_addrB[ROM_ADDR_BW-1:0]),
	// Memory Latch - Input 
	.latch_inA (dn_portA_dout[DN_RD_BW-1:0]),
	.latch_inB (dn_portB_dout[DN_RD_BW-1:0]),
	.latch_iterA (5'd0), // base address for latch A to indicate the iteration index
	.latch_iterB (5'd0), // base address for latch B to indicate the iteration index
	.rstn (dn_rom_port_fetch), // asserted/deasserted by "rom_port_fetch" signal of Iteration Update Control Unit
	.write_clk (write_clk)
);

dn_Waddr_counter #(.PAGE_ADDR_BW (PAGE_ADDR_BW)) dn_page_addr_vntM2 (
	.wr_page_addr (dn_wr_page_addr[PAGE_ADDR_BW-1:0]),
	
	.en (dn_ram_write_en),
	.write_clk (write_clk),
	.rstn (~d3ib_rom_rst)
);

dnu3_wr_fsm #(.LOAD_CYCLE(LOAD_CYCLE)) dnu3_wr_fsm_u0 (
	// FSM - Output
	.rom_port_fetch (dn_rom_port_fetch), // to enable the ib-map starting to fetch data from read port of IB ROM
	.ram_write_en   (dn_ram_write_en),
	.ram_mux_en     (dn_ram_mux_en),
	.iter_update    (dn_iter_update),
	.v3ib_rom_rst   (d3ib_rom_rst),
	.busy           (dn_busy),
	.state          (dn_state),
	// FSM - Input
	.write_clk        (write_clk),
	.rstn             (rstn_dnu_fsm),
	.iter_rqst        (dn_iter_rqst),
	.iter_termination (dn_iter_termination)
	//.pipeline_en    (vn_pipeline_en[i])	// deprecated
);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// IB-RAMs Instantiation
		// Instantiation of F_0
		reg [`QUAN_SIZE-1:0] c2v_0[0:`VN_DEGREE-1];
		reg [`QUAN_SIZE-1:0] c2v_1[0:`VN_DEGREE-1];	
		reg [`QUAN_SIZE-1:0] c2v_2[0:`VN_DEGREE-1];
		reg [`QUAN_SIZE-1:0] c2v_3[0:`VN_DEGREE-1];
		reg [`QUAN_SIZE-1:0] vnu0_ch_llr;
		reg [`QUAN_SIZE-1:0] vnu1_ch_llr;
		reg [`QUAN_SIZE-1:0] vnu2_ch_llr;
		reg [`QUAN_SIZE-1:0] vnu3_ch_llr;	
		
		wire [`QUAN_SIZE-1:0] f0_out[0:7];
`ifdef V2C_C2V_PROBE
		wire [`QUAN_SIZE-1:0] vnu0_c2v [0:`VN_DEGREE-1]; // c2v[0], c2v[1] and c2v[2]
		wire [`QUAN_SIZE-1:0] vnu0_ch_llr_probe [0:`IB_VNU_DECOMP_funNum-1];
		wire [`QUAN_SIZE-1:0] dnu0_ch_llr_probe;
`else
		wire [`QUAN_SIZE-1:0] vnu0_c2v [0:1]; // c2v[1] and c2v[2]
`endif
		wire [`QUAN_SIZE-1:0] vnu1_c2v [0:1]; // c2v[1] and c2v[2]
		wire [`QUAN_SIZE-1:0] vnu2_c2v [0:1]; // c2v[1] and c2v[2]
		wire [`QUAN_SIZE-1:0] vnu3_c2v [0:1]; // c2v[1] and c2v[2]	
		wire [1:0] vnu0_tranEn_out;
		wire [1:0] vnu1_tranEn_out;
		wire [1:0] vnu2_tranEn_out;
		wire [1:0] vnu3_tranEn_out;
		
		logic vn_read_addr_offset;
		logic vn_read_addr_offset_outSet;
	
		// Dummy instantiation just for area overhead evaluation
		wire [`VN_DEGREE+1-2-1-1:0] vn_read_addr_offset_internal;
		vnu3_f0 u_f0(
			.read_addr_offset_out (vn_read_addr_offset_internal[0]), // to forward the current multi-frame offset signal to the next sub-datapath	
			// For the first VNU
			.vnu0_tPort0 (f0_out[0]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_tPort1 (f0_out[1]  ), // internal signals accounting for each 128-entry partial LUT's output
		`ifdef V2C_C2V_PROBE
			.vnu0_c2v0   (vnu0_c2v[0]),
			.vnu0_c2v1   (vnu0_c2v[1]),
			.vnu0_c2v2   (vnu0_c2v[2]),
			.vnu0_ch_llr_probe (vnu0_ch_llr_probe[0]),
		`else
			.vnu0_c2v1   (vnu0_c2v[0]),
			.vnu0_c2v2   (vnu0_c2v[1]),
		`endif
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
			.vnu0_c2v_0  (c2v_0[0]),
			.vnu0_c2v_1  (c2v_0[1]),
			.vnu0_c2v_2  (c2v_0[2]),
			.vnu0_ch_llr (vnu0_ch_llr[`QUAN_SIZE-1:0]),
	
			// From the second VNU
			.vnu1_c2v_0  (c2v_1[0]),
			.vnu1_c2v_1  (c2v_1[1]),
			.vnu1_c2v_2  (c2v_1[2]),
			.vnu1_ch_llr (vnu1_ch_llr[`QUAN_SIZE-1:0]),
	
			// From the third VNU
			.vnu2_c2v_0  (c2v_2[0]),
			.vnu2_c2v_1  (c2v_2[1]),
			.vnu2_c2v_2  (c2v_2[2]),
			.vnu2_ch_llr (vnu2_ch_llr[`QUAN_SIZE-1:0]),
	
			// From the fourth VNU
			.vnu3_c2v_0  (c2v_3[0]),
			.vnu3_c2v_1  (c2v_3[1]),
			.vnu3_c2v_2  (c2v_3[2]),
			.vnu3_ch_llr (vnu3_ch_llr[`QUAN_SIZE-1:0]),
		
			.read_clk (read_clk),
			.read_addr_offset (vn_read_addr_offset), // offset determing the switch between multi-frame
		
			// Iteration-Update Page Address 
			.page_addr_ram ({1'b0, vn_wr_page_addr[0]}),
			// Ieration-Update Data
			.ram_write_data_0 (vn_latch_outA[0]),
	
			.write_clk (write_clk),
			.ib_ram_we (vn_ram_write_en[0])
		);

		// Instantiation of F_1
		wire [`QUAN_SIZE-1:0] vnu0_v2c[0:2];
		wire [`QUAN_SIZE-1:0] vnu1_v2c[0:2];
		wire [`QUAN_SIZE-1:0] vnu2_v2c[0:2];
		wire [`QUAN_SIZE-1:0] vnu3_v2c[0:2];
		wire [`QUAN_SIZE-1:0] vnu0_dn_in;
		wire [`QUAN_SIZE-1:0] vnu1_dn_in;
		wire [`QUAN_SIZE-1:0] vnu2_dn_in;
		wire [`QUAN_SIZE-1:0] vnu3_dn_in;
		wire [`QUAN_SIZE-1:0] vnu0_E_reg2, vnu1_E_reg2, vnu2_E_reg2, vnu3_E_reg2;
`ifdef V2C_C2V_PROBE		
		wire [`QUAN_SIZE-1:0] vnu0_E_reg0, vnu0_E_reg1; 
`endif
		vnu3_f1 u_f1(
			.read_addr_offset_out (vn_read_addr_offset_outSet), // to forward the current multi-frame offset signal to the next sub-datapath	
			// For the first VNU
			.vnu0_v2c0 (vnu0_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_v2c1 (vnu0_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_v2c2 (vnu0_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_E_reg2 (vnu0_E_reg2[`QUAN_SIZE-1:0]),
			.vnu0_dn_in (vnu0_dn_in[`QUAN_SIZE-1:0]), // the input source to decision node in the next step
			.vnu0_tranEn_out0 (vnu0_tranEn_out0),
`ifdef V2C_C2V_PROBE
			.vnu0_E_reg0 (vnu0_E_reg0[`QUAN_SIZE-1:0]),
			.vnu0_E_reg1 (vnu0_E_reg1[`QUAN_SIZE-1:0]),
			.vnu0_ch_llr_probe (vnu0_ch_llr_probe[1]) ,
`endif
			
			// For the second VNU       
			.vnu1_v2c0 (vnu1_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_v2c1 (vnu1_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_v2c2 (vnu1_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_E_reg2 (vnu1_E_reg2[`QUAN_SIZE-1:0]),
			.vnu1_dn_in (vnu1_dn_in[`QUAN_SIZE-1:0]), // the input source to decision node in the next step
			.vnu1_tranEn_out0 (vnu1_tranEn_out0),
			// For the third VNU        
			.vnu2_v2c0 (vnu2_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_v2c1 (vnu2_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_v2c2 (vnu2_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_E_reg2 (vnu2_E_reg2[`QUAN_SIZE-1:0]),
			.vnu2_dn_in (vnu2_dn_in[`QUAN_SIZE-1:0]), // the input source to decision node in the next step
			.vnu2_tranEn_out0 (vnu2_tranEn_out0),
			// For the fourth VNU       
			.vnu3_v2c0 (vnu3_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_v2c1 (vnu3_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_v2c2 (vnu3_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_E_reg2 (vnu3_E_reg2[`QUAN_SIZE-1:0]),	
			.vnu3_dn_in (vnu3_dn_in[`QUAN_SIZE-1:0]), // the input source to decision node in the next step
			.vnu3_tranEn_out0 (vnu3_tranEn_out0),
			// From the first VNU
			.vnu0_t00   (f0_out[0]  ),
			.vnu0_t01   (f0_out[1]  ),
		`ifdef V2C_C2V_PROBE
			.vnu0_c2v_0 (vnu0_c2v[0]),
			.vnu0_c2v_1 (vnu0_c2v[1]),
			.vnu0_c2v_2 (vnu0_c2v[2]),
			.vnu0_ch_llr (vnu0_ch_llr_probe[0]),
		`else
			.vnu0_c2v_1 (vnu0_c2v[0]),
			.vnu0_c2v_2 (vnu0_c2v[1]),
		`endif
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
			.read_addr_offset (vn_read_addr_offset_internal[0]), // offset determing the switch between multi-frame
		
			// Iteration-Update Page Address 
			.page_addr_ram ({1'b0, vn_wr_page_addr[1]}),
			// Ieration-Update Data
			.ram_write_data_1 (vn_latch_outA[1]),
	
			.write_clk (write_clk),
			.ib_ram_we (vn_ram_write_en[1])
		);	
				
`ifdef V2C_C2V_PROBE		
		wire [`QUAN_SIZE-1:0] dnu0_E_reg0, dnu0_E_reg1, dnu0_E_reg2; 
`endif
		wire dnu0_hard_decision, dnu1_hard_decision, dnu2_hard_decision, dnu3_hard_decision;
		dnu_f0 u_f2(
			//output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath	
			.dnu0_hard_decision (dnu0_hard_decision), // internal signals accounting for each 128-entry partial LUT's output
			.dnu1_hard_decision (dnu1_hard_decision), // internal signals accounting for each 128-entry partial LUT's output		        
			.dnu2_hard_decision (dnu2_hard_decision), // internal signals accounting for each 128-entry partial LUT's output
			.dnu3_hard_decision (dnu3_hard_decision), // internal signals accounting for each 128-entry partial LUT's output
		
			// From the first DNU
			`ifdef V2C_C2V_PROBE
				.vnu0_E_reg0 (dnu0_E_reg0[`QUAN_SIZE-1:0]),
				.vnu0_E_reg1 (dnu0_E_reg1[`QUAN_SIZE-1:0]),
				.vnu0_E_reg2 (dnu0_E_reg2[`QUAN_SIZE-1:0]),
				.vnu0_ch_llr_probe (dnu0_ch_llr_probe[`QUAN_SIZE-1:0]),
				
				.vnu0_c2v_0 (vnu0_E_reg0[`QUAN_SIZE-1:0]),
				.vnu0_c2v_1 (vnu0_E_reg1[`QUAN_SIZE-1:0]),
				.vnu0_ch_llr (vnu0_ch_llr_probe[1]),
			`endif
			.vnu0_t10		 (vnu0_dn_in[`QUAN_SIZE-1:0]),
			.vnu0_c2v_2      (vnu0_E_reg2[`QUAN_SIZE-1:0]),
			.vnu0_tranEn_in0 (vnu0_tranEn_out0),

			// From the second DNU
			.vnu1_t10		 (vnu1_dn_in[`QUAN_SIZE-1:0]),
			.vnu1_c2v_2      (vnu1_E_reg2[`QUAN_SIZE-1:0]),
			.vnu1_tranEn_in0 (vnu1_tranEn_out0),

			// From the third DNU
			.vnu2_t10		 (vnu2_dn_in[`QUAN_SIZE-1:0]),
			.vnu2_c2v_2      (vnu2_E_reg2[`QUAN_SIZE-1:0]),
			.vnu2_tranEn_in0 (vnu2_tranEn_out0),
		
			// From the fourth DNU
			.vnu3_t10		 (vnu3_dn_in[`QUAN_SIZE-1:0]),
			.vnu3_c2v_2      (vnu3_E_reg2[`QUAN_SIZE-1:0]),
			.vnu3_tranEn_in0 (vnu3_tranEn_out0),
		
			.read_clk (read_clk),
			.read_addr_offset (vn_read_addr_offset_outSet), // offset determing the switch between multi-frame 
			
			// Iteration-Update Page Address 
			.page_addr_ram ({1'b0, dn_wr_page_addr[PAGE_ADDR_BW-1:0]}),
			// Ieration-Update Data
			.ram_write_data_1 (dn_latch_outA[ROM_RD_BW-1:0]),
			
			.write_clk (write_clk),
			.ib_ram_we (dn_ram_write_en)
		);
		/*
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
		*/
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
logic [`IB_VNU_DECOMP_funNum-1:0] vn_update_finish;
logic dn_update_finish;
integer vnu_f [0:`IB_VNU_DECOMP_funNum-1];
integer dnu_f;
initial begin
    vnu_f[0] = $fopen("vnu_ram_dataIn.f0.csv", "w");
	vnu_f[1] = $fopen("vnu_ram_dataIn.f1.csv", "w");
	dnu_f    = $fopen("dnu_ram_dataIn.f2.csv", "w");
end
//----------------------------------------------------------------------------------------------------------//
// Variable Node IB-RAM Read DUT
generate
	//genvar i;
	for(i=0;i<`IB_VNU_DECOMP_funNum;i=i+1) begin : insta_vn_fsm_in_sim
		initial begin
			#0;
			{rstn_vnu_fsm[i], vn_iter_rqst[i], vn_iter_termination[i]} <= 3'b000;
			vn_update_finish[i]  <= 1'b0;
			//pipeline_en[i] <= 1'b0;
			{rstn_vnu_fsm[i], vn_iter_rqst[i], vn_iter_termination[i]} <= 3'b000; 
			vn_update_finish[i] <= 1'b0;
			vn_read_addr_offset <= 1'b0; // the mult-frame is not tested in this time
			
			#200;
			{rstn_vnu_fsm[i], vn_iter_rqst[i], vn_iter_termination[i]} <= 3'b110; 
		
			wait(vn_update_finish[i] == 1'b1);
			{rstn_vnu_fsm[i], vn_iter_rqst[i], vn_iter_termination[i]} <= 3'b001;
		end
		always @(posedge write_clk) begin
			if(vn_iter_rqst[i] == 1'b1 && vn_busy[i] == 2'b10) begin
				vn_update_finish[i] <= 1'b1;
				$fclose(vnu_f[i]);
			end		
		end
		
		//initial pipeline_en[i] <= 1'b0;
		//always @(posedge write_clk) begin
		//	if(state[i] == 3'd1) pipeline_en <= 1'b1;
		//	else pipeline_en <= pipeline_en;
		//end
		
		always @(posedge write_clk) begin
			if(vn_state[i] == 3'd3) begin
				$fwrite(vnu_f[i], "%d,%b,%b\n", 
								{1'b0, vn_wr_page_addr[i]},
								vn_latch_outA[i][7:4],
								vn_latch_outA[i][3:0]
				);      
			end
		end
	end
endgenerate
//----------------------------------------------------------------------------------------------------------//
// Decision Node IB-RAM Read DUT
initial begin
	#0;
	{rstn_dnu_fsm, dn_iter_rqst, dn_iter_termination} <= 3'b000;
	dn_update_finish  <= 1'b0;
	//pipeline_en[i] <= 1'b0;
	{rstn_dnu_fsm, dn_iter_rqst, dn_iter_termination} <= 3'b000; 
	dn_update_finish <= 1'b0;
		
	#200;
	{rstn_dnu_fsm, dn_iter_rqst, dn_iter_termination} <= 3'b110; 

	wait(dn_update_finish == 1'b1);
	{rstn_dnu_fsm, dn_iter_rqst, dn_iter_termination} <= 3'b001;
end
always @(posedge write_clk) begin
	if(dn_iter_rqst == 1'b1 && dn_busy == 2'b10) begin
		dn_update_finish <= 1'b1;
		$fclose(dnu_f);
	end			
end
always @(posedge write_clk) begin
	if(dn_state == 3'd3) begin
		$fwrite(dnu_f, "%d,%b,%b\n", 
						{1'b0, dn_wr_page_addr[PAGE_ADDR_BW-1:0]},
						dn_latch_outA[1],
						dn_latch_outA[0]
		);      
	end
end
//----------------------------------------------------------------------------------------------------------//
/*
initial begin
	wait(&{update_finish[`IB_CNU_DECOMP_funNum-1:0]});
	#100 $finish;
end
*/
initial begin
    #0;
	{vnu0_ch_llr, vnu1_ch_llr, vnu2_ch_llr, vnu3_ch_llr} <= 16'hffff;
	{c2v_0[0], c2v_1[0], c2v_2[0], c2v_3[0]} <= 16'd0;
    {c2v_0[1], c2v_1[1], c2v_2[1], c2v_3[1]} <= 16'd0;
    {c2v_0[2], c2v_1[2], c2v_2[2], c2v_3[2]} <= 16'd0;
end

reg [`QUAN_SIZE*(`VN_DEGREE+1)-1:0] c2v_cnt;
initial #0 c2v_cnt[`QUAN_SIZE*(`VN_DEGREE+1)-1:0] <= 0; // including channel message

always @(posedge read_clk) begin
    if({vn_ram_write_en[0], vn_iter_update[0], v3ib_rom_rst[0]} == 3'b001 && vn_update_finish[0] == 1'b1)
		c2v_cnt[`QUAN_SIZE*(`VN_DEGREE+1)-1:0] <= c2v_cnt[`QUAN_SIZE*(`VN_DEGREE+1)-1:0]+1'b1;
end
always @(posedge read_clk) begin
    if({vn_ram_write_en[0], vn_iter_update[0], v3ib_rom_rst[0]} == 3'b001 && vn_update_finish[0] == 1'b1) begin 
        // Simulation for VNU3_0
		vnu0_ch_llr[`QUAN_SIZE-1:0] <= c2v_cnt[3:0];
 	    c2v_0[0] <= c2v_cnt[7:4];
        c2v_0[1] <= c2v_cnt[11:8];
        c2v_0[2] <= c2v_cnt[15:12];

		// Simulation for VNU3_1
		vnu1_ch_llr[`QUAN_SIZE-1:0] <= c2v_cnt[3:0];
 	    c2v_1[0] <= c2v_cnt[7:4];
        c2v_1[1] <= c2v_cnt[11:8];
        c2v_1[2] <= c2v_cnt[15:12];
		
        // Simulation for VNU3_2
		vnu2_ch_llr[`QUAN_SIZE-1:0] <= c2v_cnt[3:0];
 	    c2v_2[0] <= c2v_cnt[7:4];
        c2v_2[1] <= c2v_cnt[11:8];
        c2v_2[2] <= c2v_cnt[15:12];

		// Simulation for VNU3_3
		vnu3_ch_llr[`QUAN_SIZE-1:0] <= c2v_cnt[3:0];
 	    c2v_3[0] <= c2v_cnt[7:4];
        c2v_3[1] <= c2v_cnt[11:8];
        c2v_3[2] <= c2v_cnt[15:12];
    end
end

integer vnu_ram_f [0:`IB_VNU_DECOMP_funNum-1];
integer dnu_ram_f;
initial begin
    vnu_ram_f[0] = $fopen("vnu_ram_dataOut.f0.csv", "w");
	vnu_ram_f[1] = $fopen("vnu_ram_dataOut.f1.csv", "w");
	dnu_ram_f    = $fopen("dnu_ram_dataOut.f2.csv", "w");
end
//----------------------------------------------------------------------------------------------------------//
// Variable Node IB-RAM Read DUT
always @(posedge read_clk) begin
    if({vn_ram_write_en[0], vn_iter_update[0], v3ib_rom_rst[0]} == 3'b001 && vn_update_finish[0] == 1'b1) begin
        if({vnu0_ch_llr_probe[0], vnu0_c2v[0], vnu0_c2v[1], vnu0_c2v[2]} != {16'hffff}) begin
            // For F0
			$fwrite(vnu_ram_f[0], "%h,%h,%h,%h,%h,%h\n",
				vnu0_ch_llr_probe[0], vnu0_c2v[0], vnu0_c2v[1], vnu0_c2v[2],
				f0_out[0], f0_out[1]
            );
		end
		else if({vnu0_ch_llr_probe[0], vnu0_c2v[0], vnu0_c2v[1], vnu0_c2v[2]} == {16'hffff}) begin
            // For F0
			$fwrite(vnu_ram_f[0], "%h,%h,%h,%h,%h,%h",
				vnu0_ch_llr_probe[0], vnu0_c2v[0], vnu0_c2v[1], vnu0_c2v[2],
				f0_out[0], f0_out[1]
            );
		end
		
		if({vnu0_ch_llr_probe[1], vnu0_E_reg0[`QUAN_SIZE-1:0], vnu0_E_reg1[`QUAN_SIZE-1:0], vnu0_E_reg2[`QUAN_SIZE-1:0]} != {16'hffff}) begin
			// For F1
			$fwrite(vnu_ram_f[1], "%h,%h,%h,%h,%h,%h,%h\n",
				vnu0_ch_llr_probe[1], vnu0_E_reg0[`QUAN_SIZE-1:0], vnu0_E_reg1[`QUAN_SIZE-1:0], vnu0_E_reg2[`QUAN_SIZE-1:0],
				vnu0_v2c[0], vnu0_v2c[1], vnu0_v2c[2]
            );		
        end
		else if({vnu0_ch_llr_probe[1], vnu0_E_reg0[`QUAN_SIZE-1:0], vnu0_E_reg1[`QUAN_SIZE-1:0], vnu0_E_reg2[`QUAN_SIZE-1:0]} == {16'hffff}) begin
			// For F1
			$fwrite(vnu_ram_f[1], "%h,%h,%h,%h,%h,%h,%h",
				vnu0_ch_llr_probe[1], vnu0_E_reg0[`QUAN_SIZE-1:0], vnu0_E_reg1[`QUAN_SIZE-1:0], vnu0_E_reg2[`QUAN_SIZE-1:0],
				vnu0_v2c[0], vnu0_v2c[1], vnu0_v2c[2]
            );		
        end 
    end
end
always @(posedge read_clk) begin
    //if(update_finish == 1'b1 && {M0_reg[4], M1_reg[4], M2_reg[4], M3_reg[4], M4_reg[4], M5_reg[4]} == {`CN_DEGREE{4'hf}}) begin
    if({vnu0_ch_llr_probe[1], vnu0_E_reg0[`QUAN_SIZE-1:0], vnu0_E_reg1[`QUAN_SIZE-1:0], vnu0_E_reg2[`QUAN_SIZE-1:0]} == {16'hffff}) begin
        $fclose(vnu_ram_f[0]); 
		$fclose(vnu_ram_f[1]); 
    end
end
//----------------------------------------------------------------------------------------------------------//
// Decision Node IB-RAM Read DUT
always @(posedge read_clk) begin
    if({dn_ram_write_en, dn_iter_update, d3ib_rom_rst} == 3'b001 && dn_update_finish == 1'b1) begin
        if({dnu0_ch_llr_probe, dnu0_E_reg0, dnu0_E_reg1, dnu0_E_reg2} != {16'hffff}) begin
            // For F2
			$fwrite(dnu_ram_f, "%h,%h,%h,%h,%h\n",
				dnu0_ch_llr_probe, dnu0_E_reg0, dnu0_E_reg1, dnu0_E_reg2,
				dnu0_hard_decision
            );
		end
		else  if({dnu0_ch_llr_probe, dnu0_E_reg0, dnu0_E_reg1, dnu0_E_reg2} == {16'hffff}) begin
            // For F2
			$fwrite(dnu_ram_f, "%h,%h,%h,%h,%h",
				dnu0_ch_llr_probe, dnu0_E_reg0, dnu0_E_reg1, dnu0_E_reg2,
				dnu0_hard_decision
            );
		end
    end
end
always @(posedge read_clk) begin
    //if(update_finish == 1'b1 && {M0_reg[4], M1_reg[4], M2_reg[4], M3_reg[4], M4_reg[4], M5_reg[4]} == {`CN_DEGREE{4'hf}}) begin
    if({dnu0_ch_llr_probe, dnu0_E_reg0, dnu0_E_reg1, dnu0_E_reg2} == {16'hffff}) begin
        $fclose(dnu_ram_f); 
    end
end
//----------------------------------------------------------------------------------------------------------//
//initial #(7.5+2.5+5*3*60+5) $finish;
always @(posedge read_clk) begin
    if({dnu0_ch_llr_probe, dnu0_E_reg0, dnu0_E_reg1, dnu0_E_reg2} == {16'hffff})
        $finish; 
end
endmodule