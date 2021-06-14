module row_vnu_wrapper #(
	parameter QUAN_SIZE = 4,
	parameter CN_DEGREE = 10,
	parameter VN_DEGREE = 3,

	// Parameters of Partial-VNU IB-RAMs
	parameter VNU3_INSTANTIATE_NUM  = 5,
	parameter VNU3_INSTANTIATE_UNIT =  2, // number of partial-VNUs instatiated in one modules (in order to reduce source code size)
	parameter VN_ROM_RD_BW = 8,
	parameter VN_ROM_ADDR_BW = 11,
	parameter VN_PAGE_ADDR_BW = 6,
	parameter DN_ROM_RD_BW = 2,
	parameter DN_ROM_ADDR_BW = 11,
	parameter DN_PAGE_ADDR_BW = 6,
	parameter BANK_NUM = 2,
	parameter IB_VNU_DECOMP_funNum = 2,
	parameter PIPELINE_DEPTH = 3,
	parameter VN_PIPELINE_DEPTH = 3,
	parameter DN_PIPELINE_DEPTH = 3,
	parameter MULTI_FRAME_NUM = 2
)(
	//output wire read_addr_offset_out,
	// From the 1st partial-VNU
	output wire hard_decision_0,
	output wire [QUAN_SIZE-1:0] v2c_0_out0,
	// From the 2nd partial-VNU
	output wire hard_decision_1,
	output wire [QUAN_SIZE-1:0] v2c_1_out0,
	// From the 3rd partial-VNU
	output wire hard_decision_2,
	output wire [QUAN_SIZE-1:0] v2c_2_out0,
	// From the 4th partial-VNU
	output wire hard_decision_3,
	output wire [QUAN_SIZE-1:0] v2c_3_out0,
	// From the 5th partial-VNU
	output wire hard_decision_4,
	output wire [QUAN_SIZE-1:0] v2c_4_out0,
	// From the 6th partial-VNU
	output wire hard_decision_5,
	output wire [QUAN_SIZE-1:0] v2c_5_out0,
	// From the 7th partial-VNU
	output wire hard_decision_6,
	output wire [QUAN_SIZE-1:0] v2c_6_out0,
	// From the 8th partial-VNU
	output wire hard_decision_7,
	output wire [QUAN_SIZE-1:0] v2c_7_out0,
	// From the 9th partial-VNU
	output wire hard_decision_8,
	output wire [QUAN_SIZE-1:0] v2c_8_out0,
	// From the 10th partial-VNU
	output wire hard_decision_9,
	output wire [QUAN_SIZE-1:0] v2c_9_out0,

	// Intrinsic check-to-variable messages and channel messages
	input wire [QUAN_SIZE-1:0] ch_msg_0,
	input wire [QUAN_SIZE-1:0] c2v_0_in0,
	input wire [QUAN_SIZE-1:0] c2v_0_in1,
	input wire [QUAN_SIZE-1:0] c2v_0_in2,
	input wire [QUAN_SIZE-1:0] ch_msg_1,
	input wire [QUAN_SIZE-1:0] c2v_1_in0,
	input wire [QUAN_SIZE-1:0] c2v_1_in1,
	input wire [QUAN_SIZE-1:0] c2v_1_in2,
	input wire [QUAN_SIZE-1:0] ch_msg_2,
	input wire [QUAN_SIZE-1:0] c2v_2_in0,
	input wire [QUAN_SIZE-1:0] c2v_2_in1,
	input wire [QUAN_SIZE-1:0] c2v_2_in2,
	input wire [QUAN_SIZE-1:0] ch_msg_3,
	input wire [QUAN_SIZE-1:0] c2v_3_in0,
	input wire [QUAN_SIZE-1:0] c2v_3_in1,
	input wire [QUAN_SIZE-1:0] c2v_3_in2,
	input wire [QUAN_SIZE-1:0] ch_msg_4,
	input wire [QUAN_SIZE-1:0] c2v_4_in0,
	input wire [QUAN_SIZE-1:0] c2v_4_in1,
	input wire [QUAN_SIZE-1:0] c2v_4_in2,
	input wire [QUAN_SIZE-1:0] ch_msg_5,
	input wire [QUAN_SIZE-1:0] c2v_5_in0,
	input wire [QUAN_SIZE-1:0] c2v_5_in1,
	input wire [QUAN_SIZE-1:0] c2v_5_in2,
	input wire [QUAN_SIZE-1:0] ch_msg_6,
	input wire [QUAN_SIZE-1:0] c2v_6_in0,
	input wire [QUAN_SIZE-1:0] c2v_6_in1,
	input wire [QUAN_SIZE-1:0] c2v_6_in2,
	input wire [QUAN_SIZE-1:0] ch_msg_7,
	input wire [QUAN_SIZE-1:0] c2v_7_in0,
	input wire [QUAN_SIZE-1:0] c2v_7_in1,
	input wire [QUAN_SIZE-1:0] c2v_7_in2,
	input wire [QUAN_SIZE-1:0] ch_msg_8,
	input wire [QUAN_SIZE-1:0] c2v_8_in0,
	input wire [QUAN_SIZE-1:0] c2v_8_in1,
	input wire [QUAN_SIZE-1:0] c2v_8_in2,
	input wire [QUAN_SIZE-1:0] ch_msg_9,
	input wire [QUAN_SIZE-1:0] c2v_9_in0,
	input wire [QUAN_SIZE-1:0] c2v_9_in1,
	input wire [QUAN_SIZE-1:0] c2v_9_in2,

	input wire read_clk,
	input wire read_addr_offset,
	input wire c2v_latch_en,
	input wire c2v_parallel_load,
	input wire v2c_src,

	// Iteration-Refresh Page Address
	input wire [VN_PAGE_ADDR_BW+1-1:0] page_addr_ram_0,
	input wire [VN_PAGE_ADDR_BW+1-1:0] page_addr_ram_1,
	input wire [DN_PAGE_ADDR_BW+1-1:0] page_addr_ram_2, // the last one is for decision node
	//Iteration-Refresh Page Data
	input wire [VN_ROM_RD_BW-1:0] ram_write_dataA_0, // from portA of IB-ROM
	input wire [VN_ROM_RD_BW-1:0] ram_write_dataB_0, // from portA of IB-ROM
	input wire [VN_ROM_RD_BW-1:0] ram_write_dataA_1, // from portA of IB-ROM
	input wire [VN_ROM_RD_BW-1:0] ram_write_dataB_1, // from portA of IB-ROM
	input wire [DN_ROM_RD_BW-1:0] ram_write_dataA_2, // from portA of IB-ROM (for decision node)
	input wire [DN_ROM_RD_BW-1:0] ram_write_dataB_2, // from portA of IB-ROM (for decision node)

	input wire [2:0] ib_ram_we,
	input wire vn_write_clk,
	input wire dn_write_clk,
	input wire rstn
);

// Input sources of vaiable node units
wire [QUAN_SIZE-1:0] c2v_0 [0:CN_DEGREE-1];
wire [QUAN_SIZE-1:0] c2v_1 [0:CN_DEGREE-1];
wire [QUAN_SIZE-1:0] c2v_2 [0:CN_DEGREE-1];
wire [QUAN_SIZE-1:0] ch_msg [0:CN_DEGREE-1];
// Output sources of check node units
wire [QUAN_SIZE-1:0] v2c_0 [0:CN_DEGREE-1];
wire [CN_DEGREE-1:0] hard_decision;
// Address related signals including the Net type

reg [QUAN_SIZE-1:0] c2v_latch_0 [0:CN_DEGREE-1];
reg [QUAN_SIZE-1:0] c2v_latch_1 [0:CN_DEGREE-1];
reg [QUAN_SIZE-1:0] c2v_latch_2 [0:CN_DEGREE-1];
generate 
	genvar j;
	for (j=0; j<CN_DEGREE; j=j+1) begin : c2v_latch_inst
		// c2v_out_0
		///////////////////////////////////////////////////////////////////////////////////////////
		always @(posedge read_clk) begin
			if(c2v_parallel_load == 1'b1) // from c2v_load[0]
				c2v_latch_0[j] <= 0;
			else if(c2v_latch_en == 1'b1) 
				c2v_latch_0[j] <= c2v_0[j];
		end
		///////////////////////////////////////////////////////////////////////////////////////////
		// c2v_out_1
		always @(posedge read_clk) begin
			if(c2v_parallel_load == 1'b1) // from c2v_load[0]
				c2v_latch_1[j] <= 0;
			else if(c2v_latch_en == 1'b1) 
				c2v_latch_1[j] <= c2v_1[j];
		end
		///////////////////////////////////////////////////////////////////////////////////////////
		// c2v_out_2
		always @(posedge read_clk) begin
			if(c2v_parallel_load == 1'b1) // from c2v_load[0]
				c2v_latch_2[j] <= 0;
			else if(c2v_latch_en == 1'b1) 
				c2v_latch_2[j] <= c2v_2[j];
		end	
		///////////////////////////////////////////////////////////////////////////////////////////
	end
endgenerate
generate
	for (j=0; j<VNU3_INSTANTIATE_NUM; j=j+1) begin : partial_vnu3_inst
		// Instantiation of F_0
		wire [QUAN_SIZE-1:0] vnu0_f0_out;
		wire [QUAN_SIZE-1:0] vnu1_f0_out;
		wire [QUAN_SIZE-1:0] vnu0_c2v [0:1]; // c2v[1] and c2v[2]
		wire [QUAN_SIZE-1:0] vnu1_c2v [0:1]; // c2v[1] and c2v[2]
		wire vnu0_tranEn_out;
		wire vnu1_tranEn_out;
		wire read_addr_offset_internal;
		vnu3_f0 #(
			.QUAN_SIZE       (QUAN_SIZE        ),
			.PIPELINE_DEPTH  (VN_PIPELINE_DEPTH),
			.ENTRY_ADDR      (VN_PAGE_ADDR_BW+MULTI_FRAME_NUM-1), // regardless of bank interleaving here
			.MULTI_FRAME_NUM (MULTI_FRAME_NUM),
			.BANK_NUM        (BANK_NUM),
			.LUT_PORT_SIZE   (VN_ROM_RD_BW/BANK_NUM)
		) u_f0 (
			.read_addr_offset_out (read_addr_offset_internal), // to forward the current multi-frame offset signal to the next sub-datapath	
			// For the first VNU
			.vnu0_tPort0 (vnu0_f0_out[QUAN_SIZE-1:0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_c2v1   (vnu0_c2v[0]),
			.vnu0_c2v2   (vnu0_c2v[1]),
			// For the second VNU       
			.vnu1_tPort0 (vnu1_f0_out[QUAN_SIZE-1:0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_c2v1   (vnu1_c2v[0]),
			.vnu1_c2v2   (vnu1_c2v[1]),

			// For first to fourth VNUs (output port)
			.vnu0_tranEn_out0 (vnu0_tranEn_out),
			.vnu1_tranEn_out0 (vnu1_tranEn_out),

			// From the first VNU
			.vnu0_c2v_0  (c2v_latch_0[VNU3_INSTANTIATE_UNIT*j]),
			.vnu0_c2v_1  (c2v_latch_1[VNU3_INSTANTIATE_UNIT*j]),
			.vnu0_c2v_2  (c2v_latch_2[VNU3_INSTANTIATE_UNIT*j]),
			.vnu0_ch_llr (ch_msg[VNU3_INSTANTIATE_UNIT*j]),
	
			// From the second VNU
			.vnu1_c2v_0  (c2v_latch_0[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_c2v_1  (c2v_latch_1[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_c2v_2  (c2v_latch_2[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+1]),
		
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset), // offset determing the switch between multi-frame
			.rstn (rstn),
		
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_0[VN_PAGE_ADDR_BW+1-1:0]),
			// Ieration-Update Data
			.ram_write_data_0 (ram_write_dataA_0[VN_ROM_RD_BW-1:0]),
		
			.write_clk (vn_write_clk),
			.ib_ram_we (ib_ram_we[0])
		);

		// Instantiation of F_1
		wire [QUAN_SIZE-1:0] vnu0_v2c;
		wire [QUAN_SIZE-1:0] vnu1_v2c;
		wire [QUAN_SIZE-1:0] vnu0_dn_in;
		wire [QUAN_SIZE-1:0] vnu1_dn_in;
		wire [QUAN_SIZE-1:0] vnu0_E_reg2, vnu1_E_reg2;
		wire vnu0_tranEn_out_f1;
		wire vnu1_tranEn_out_f1;
		wire read_addr_offset_outSet;
		vnu3_f1 #(
			.QUAN_SIZE       (QUAN_SIZE        ),
			.PIPELINE_DEPTH  (VN_PIPELINE_DEPTH),
			.ENTRY_ADDR      (VN_PAGE_ADDR_BW+MULTI_FRAME_NUM-1), // regardless of bank interleaving here
			.MULTI_FRAME_NUM (MULTI_FRAME_NUM),
			.BANK_NUM        (BANK_NUM),
			.LUT_PORT_SIZE   (VN_ROM_RD_BW/BANK_NUM)
		) u_f1 (
			.read_addr_offset_out (read_addr_offset_outSet), // to forward the current multi-frame offset signal to the next sub-datapath	
			// For the first VNU
			.vnu0_v2c0 (v2c_0[VNU3_INSTANTIATE_UNIT*j]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_E_reg2 (vnu0_E_reg2[QUAN_SIZE-1:0]),
			.vnu0_dn_in (vnu0_dn_in[QUAN_SIZE-1:0]), // the input source to decision node in the next step
			.vnu0_tranEn_out0 (vnu0_tranEn_out_f1),
			// For the second VNU       
			.vnu1_v2c0 (v2c_0[(VNU3_INSTANTIATE_UNIT*j)+1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_E_reg2 (vnu1_E_reg2[QUAN_SIZE-1:0]),
			.vnu1_dn_in (vnu1_dn_in[QUAN_SIZE-1:0]), // the input source to decision node in the next step
			.vnu1_tranEn_out0 (vnu1_tranEn_out_f1),
			
			// From the first VNU
			.vnu0_t00   (vnu0_f0_out[QUAN_SIZE-1:0]),
			.vnu0_c2v_1 (vnu0_c2v[0]),
			.vnu0_c2v_2 (vnu0_c2v[1]),
			.vnu0_tranEn_in0 (vnu0_tranEn_out),
	
			// From the second VNU
			.vnu1_t00   (vnu1_f0_out[QUAN_SIZE-1:0]),
			.vnu1_c2v_1 (vnu1_c2v[0]),
			.vnu1_c2v_2 (vnu1_c2v[1]), 
			.vnu1_tranEn_in0 (vnu1_tranEn_out),	
	
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset_internal), // offset determing the switch between multi-frame
			.rstn (rstn),
		
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_1[VN_PAGE_ADDR_BW+1-1:0]),
			// Ieration-Update Data
			.ram_write_data_1 (ram_write_dataA_1[VN_ROM_RD_BW-1:0]),
			
			.write_clk (vn_write_clk),
			.ib_ram_we (ib_ram_we[1])
		);	
	
		dnu_f0 #(
			.QUAN_SIZE       (QUAN_SIZE        ),
			.PIPELINE_DEPTH  (DN_PIPELINE_DEPTH),
			.ENTRY_ADDR      (DN_PAGE_ADDR_BW+MULTI_FRAME_NUM-1), // regardless of bank interleaving here
			.MULTI_FRAME_NUM (MULTI_FRAME_NUM),
			.BANK_NUM        (BANK_NUM),
			.LUT_PORT_SIZE   (DN_ROM_RD_BW/BANK_NUM)
		) u_f2 (
			//output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath	
			.dnu0_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j]), // internal signals accounting for each 128-entry partial LUT's output
			.dnu1_hard_decision (hard_decision[(VNU3_INSTANTIATE_UNIT*j)+1]), // internal signals accounting for each 128-entry partial LUT's output		        
		
			// From the first DNU
			.vnu0_t10		 (vnu0_dn_in[QUAN_SIZE-1:0]),
			.vnu0_c2v_2      (vnu0_E_reg2[QUAN_SIZE-1:0]),
			.vnu0_tranEn_in0 (vnu0_tranEn_out_f1),

			// From the second DNU
			.vnu1_t10		 (vnu1_dn_in[QUAN_SIZE-1:0]),
			.vnu1_c2v_2      (vnu1_E_reg2[QUAN_SIZE-1:0]),
			.vnu1_tranEn_in0 (vnu1_tranEn_out_f1),

			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset_outSet), // offset determing the switch between multi-frame
			.rstn (rstn),
			
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_2[DN_PAGE_ADDR_BW+1-1:0]),
			// Ieration-Update Data
			.ram_write_data_1 (ram_write_dataA_2[DN_ROM_RD_BW-1:0]),
			
			.write_clk (dn_write_clk),
			.ib_ram_we (ib_ram_we[2])
		);
	end
endgenerate

assign hard_decision_0 = hard_decision[0];
assign v2c_0_out0[QUAN_SIZE-1:0] = v2c_0[0];
assign c2v_0[0] = c2v_0_in0[QUAN_SIZE-1:0];
assign c2v_1[0] = c2v_0_in1[QUAN_SIZE-1:0];
assign c2v_2[0] = c2v_0_in2[QUAN_SIZE-1:0];
assign ch_msg[0] = ch_msg_0[QUAN_SIZE-1:0];

assign hard_decision_1 = hard_decision[1];
assign v2c_1_out0[QUAN_SIZE-1:0] = v2c_0[1];
assign c2v_0[1] = c2v_1_in0[QUAN_SIZE-1:0];
assign c2v_1[1] = c2v_1_in1[QUAN_SIZE-1:0];
assign c2v_2[1] = c2v_1_in2[QUAN_SIZE-1:0];
assign ch_msg[1] = ch_msg_1[QUAN_SIZE-1:0];

assign hard_decision_2 = hard_decision[2];
assign v2c_2_out0[QUAN_SIZE-1:0] = v2c_0[2];
assign c2v_0[2] = c2v_2_in0[QUAN_SIZE-1:0];
assign c2v_1[2] = c2v_2_in1[QUAN_SIZE-1:0];
assign c2v_2[2] = c2v_2_in2[QUAN_SIZE-1:0];
assign ch_msg[2] = ch_msg_2[QUAN_SIZE-1:0];

assign hard_decision_3 = hard_decision[3];
assign v2c_3_out0[QUAN_SIZE-1:0] = v2c_0[3];
assign c2v_0[3] = c2v_3_in0[QUAN_SIZE-1:0];
assign c2v_1[3] = c2v_3_in1[QUAN_SIZE-1:0];
assign c2v_2[3] = c2v_3_in2[QUAN_SIZE-1:0];
assign ch_msg[3] = ch_msg_3[QUAN_SIZE-1:0];

assign hard_decision_4 = hard_decision[4];
assign v2c_4_out0[QUAN_SIZE-1:0] = v2c_0[4];
assign c2v_0[4] = c2v_4_in0[QUAN_SIZE-1:0];
assign c2v_1[4] = c2v_4_in1[QUAN_SIZE-1:0];
assign c2v_2[4] = c2v_4_in2[QUAN_SIZE-1:0];
assign ch_msg[4] = ch_msg_4[QUAN_SIZE-1:0];

assign hard_decision_5 = hard_decision[5];
assign v2c_5_out0[QUAN_SIZE-1:0] = v2c_0[5];
assign c2v_0[5] = c2v_5_in0[QUAN_SIZE-1:0];
assign c2v_1[5] = c2v_5_in1[QUAN_SIZE-1:0];
assign c2v_2[5] = c2v_5_in2[QUAN_SIZE-1:0];
assign ch_msg[5] = ch_msg_5[QUAN_SIZE-1:0];

assign hard_decision_6 = hard_decision[6];
assign v2c_6_out0[QUAN_SIZE-1:0] = v2c_0[6];
assign c2v_0[6] = c2v_6_in0[QUAN_SIZE-1:0];
assign c2v_1[6] = c2v_6_in1[QUAN_SIZE-1:0];
assign c2v_2[6] = c2v_6_in2[QUAN_SIZE-1:0];
assign ch_msg[6] = ch_msg_6[QUAN_SIZE-1:0];

assign hard_decision_7 = hard_decision[7];
assign v2c_7_out0[QUAN_SIZE-1:0] = v2c_0[7];
assign c2v_0[7] = c2v_7_in0[QUAN_SIZE-1:0];
assign c2v_1[7] = c2v_7_in1[QUAN_SIZE-1:0];
assign c2v_2[7] = c2v_7_in2[QUAN_SIZE-1:0];
assign ch_msg[7] = ch_msg_7[QUAN_SIZE-1:0];

assign hard_decision_8 = hard_decision[8];
assign v2c_8_out0[QUAN_SIZE-1:0] = v2c_0[8];
assign c2v_0[8] = c2v_8_in0[QUAN_SIZE-1:0];
assign c2v_1[8] = c2v_8_in1[QUAN_SIZE-1:0];
assign c2v_2[8] = c2v_8_in2[QUAN_SIZE-1:0];
assign ch_msg[8] = ch_msg_8[QUAN_SIZE-1:0];

assign hard_decision_9 = hard_decision[9];
assign v2c_9_out0[QUAN_SIZE-1:0] = v2c_0[9];
assign c2v_0[9] = c2v_9_in0[QUAN_SIZE-1:0];
assign c2v_1[9] = c2v_9_in1[QUAN_SIZE-1:0];
assign c2v_2[9] = c2v_9_in2[QUAN_SIZE-1:0];
assign ch_msg[9] = ch_msg_9[QUAN_SIZE-1:0];
endmodule