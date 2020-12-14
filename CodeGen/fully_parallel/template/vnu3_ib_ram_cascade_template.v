generate
	genvar j;
	// Group A interacting with Port A of IB-ROMs
	integer inst_num_groupA = VNU3_INSTANTIATE_NUM / 2;
	for (j=0; j<inst_num_groupA; j=j+1) begin : vnu3_204_102_inst_GroupA
		// Instantiation of F_0
		// Instantiation of F_0
		wire [QUAN_SIZE-1:0] f0_out[0:7];
		wire [QUAN_SIZE-1:0] vnu0_c2v [0:1]; // c2v[1] and c2v[2]
		wire [QUAN_SIZE-1:0] vnu1_c2v [0:1]; // c2v[1] and c2v[2]
		wire [QUAN_SIZE-1:0] vnu2_c2v [0:1]; // c2v[1] and c2v[2]
		wire [QUAN_SIZE-1:0] vnu3_c2v [0:1]; // c2v[1] and c2v[2]	
		wire [1:0] vnu0_tranEn_out;
		wire [1:0] vnu1_tranEn_out;
		wire [1:0] vnu2_tranEn_out;
		wire [1:0] vnu3_tranEn_out;
	
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
			.vnu0_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_ch_llr (ch_msg[VNU3_INSTANTIATE_UNIT*j]),
	
			// From the second VNU
			.vnu1_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+1]),
	
			// From the third VNU
			.vnu2_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+2]),
	
			// From the fourth VNU
			.vnu3_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+3]),
		
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset), // offset determing the switch between multi-frame
		
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_0[VN_ROM_ADDR_BW-1:0]),
			// Ieration-Update Data
			.ram_write_data_0 (ram_write_dataA_0[VN_ROM_RD_BW-1:0]),
		
			.write_clk (vn_write_clk),
			.ib_ram_we (ib_ram_we[0])
		);

		// Instantiation of F_1
		wire [QUAN_SIZE-1:0] vnu0_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu1_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu2_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu3_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu0_E_reg2, vnu1_E_reg2, vnu2_E_reg2, vnu3_E_reg2;
		wire [1:0] vnu0_tranEn_out_f1;
		wire [1:0] vnu1_tranEn_out_f1;
		wire [1:0] vnu2_tranEn_out_f1;
		wire [1:0] vnu3_tranEn_out_f1;
		vnu3_f1 u_f1(
			.read_addr_offset_out (read_addr_offset_outSet[j]), // to forward the current multi-frame offset signal to the next sub-datapath	
			// For the first VNU
			.vnu0_v2c0 (vnu0_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_v2c1 (vnu0_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_v2c2 (vnu0_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_E_reg2 (vnu0_E_reg2[QUAN_SIZE-1:0]),
			.vnu0_tranEn_out0 (vnu0_tranEn_out_f1),
			// For the second VNU       
			.vnu1_v2c0 (vnu1_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_v2c1 (vnu1_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_v2c2 (vnu1_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_E_reg2 (vnu1_E_reg2[QUAN_SIZE-1:0]),
			.vnu1_tranEn_out0 (vnu1_tranEn_out_f1),
			// For the third VNU        
			.vnu2_v2c0 (vnu2_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_v2c1 (vnu2_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_v2c2 (vnu2_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_E_reg2 (vnu2_E_reg2[QUAN_SIZE-1:0]),
			.vnu2_tranEn_out0 (vnu2_tranEn_out_f1),
			// For the fourth VNU       
			.vnu3_v2c0 (vnu3_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_v2c1 (vnu3_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_v2c2 (vnu3_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_E_reg2 (vnu3_E_reg2[QUAN_SIZE-1:0]),	
			.vnu3_tranEn_out0 (vnu3_tranEn_out_f1),
			
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
			.page_addr_ram (page_addr_ram_1[VN_ROM_ADDR_BW-1:0]),
			// Ieration-Update Data
			.ram_write_data_1 (ram_write_dataA_1[VN_ROM_RD_BW-1:0]),
			
			.write_clk (vn_write_clk),
			.ib_ram_we (ib_ram_we[1])
		);	
	
		dnu_f0 u_f2(
			//output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath	
			.dnu0_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+0]), // internal signals accounting for each 128-entry partial LUT's output
			.dnu1_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+1]), // internal signals accounting for each 128-entry partial LUT's output		        
			.dnu2_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+2]), // internal signals accounting for each 128-entry partial LUT's output
			.dnu3_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+3]), // internal signals accounting for each 128-entry partial LUT's output
		
			// From the first DNU
			.vnu0_t10		 (vnu0_v2c[0]),
			.vnu0_c2v_2      (vnu0_E_reg2[QUAN_SIZE-1:0]),
			.vnu0_tranEn_in0 (vnu0_tranEn_out_f1),

			// From the second DNU
			.vnu1_t10		 (vnu1_v2c[0]),
			.vnu1_c2v_2      (vnu1_E_reg2[QUAN_SIZE-1:0]),
			.vnu1_tranEn_in0 (vnu1_tranEn_out_f1),

			// From the third DNU
			.vnu2_t10		 (vnu2_v2c[0]),
			.vnu2_c2v_2      (vnu2_E_reg2[QUAN_SIZE-1:0]),
			.vnu2_tranEn_in0 (vnu2_tranEn_out_f1),
		
			// From the fourth DNU
			.vnu3_t10		 (vnu3_v2c[0]),
			.vnu3_c2v_2      (vnu3_E_reg2[QUAN_SIZE-1:0]),
			.vnu3_tranEn_in0 (vnu3_tranEn_out_f1),
		
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset_outSet[j]), // offset determing the switch between multi-frame 
			
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_2[VN_ROM_ADDR_BW-1:0]),
			// Ieration-Update Data
			.ram_write_data_1 (ram_write_dataA_2[VN_ROM_RD_BW-1:0]),
			
			.write_clk (dn_write_clk),
			.ib_ram_we (ib_ram_we[2])
		);

		ib_vnu_3_pipeOut u_v2c_out0(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)]),

			.M0 (vnu0_v2c[0]),
			.M1 (vnu0_v2c[1]),
			.M2 (vnu0_v2c[2]),
			.ch_llr (vnu0_ch_llr[QUAN_SIZE-1:0]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out1(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)+1]),

			.M0 (vnu1_v2c[0]),
			.M1 (vnu1_v2c[1]),
			.M2 (vnu1_v2c[2]),
			.ch_llr (vnu1_ch_llr[QUAN_SIZE-1:0]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out2(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)+2]),

			.M0 (vnu2_v2c[0]),
			.M1 (vnu2_v2c[1]),
			.M2 (vnu2_v2c[2]),
			.ch_llr (vnu2_ch_llr[QUAN_SIZE-1:0]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out3(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)+3]),

			.M0 (vnu3_v2c[0]),
			.M1 (vnu3_v2c[1]),
			.M2 (vnu3_v2c[2]),
			.ch_llr (vnu3_ch_llr[QUAN_SIZE-1:0]),
			.v2c_src (v2c_src)              
		);
	end

	// Group B interacting with Port B of IB-ROMs
	integer inst_num_groupB = VNU3_INSTANTIATE_NUM - inst_num_groupA;
	for (j=inst_num_groupB-1; j<VNU3_INSTANTIATE_NUM; j=j+1) begin : vnu3_204_102_inst_GroupB
		// Instantiation of F_0
		// Instantiation of F_0
		wire [QUAN_SIZE-1:0] f0_out[0:7];
		wire [QUAN_SIZE-1:0] vnu0_c2v [0:1]; // c2v[1] and c2v[2]
		wire [QUAN_SIZE-1:0] vnu1_c2v [0:1]; // c2v[1] and c2v[2]
		wire [QUAN_SIZE-1:0] vnu2_c2v [0:1]; // c2v[1] and c2v[2]
		wire [QUAN_SIZE-1:0] vnu3_c2v [0:1]; // c2v[1] and c2v[2]	
		wire [1:0] vnu0_tranEn_out;
		wire [1:0] vnu1_tranEn_out;
		wire [1:0] vnu2_tranEn_out;
		wire [1:0] vnu3_tranEn_out;
	
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
			.vnu0_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_ch_llr (ch_msg[VNU3_INSTANTIATE_UNIT*j]),
	
			// From the second VNU
			.vnu1_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+1]),
	
			// From the third VNU
			.vnu2_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+2]),
	
			// From the fourth VNU
			.vnu3_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+3]),
		
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset), // offset determing the switch between multi-frame
		
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_0[VN_ROM_ADDR_BW-1:0]),
			// Ieration-Update Data
			.ram_write_data_0 (ram_write_dataA_0[VN_ROM_RD_BW-1:0]),
		
			.write_clk (vn_write_clk),
			.ib_ram_we (ib_ram_we[0])
		);

		// Instantiation of F_1
		wire [QUAN_SIZE-1:0] vnu0_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu1_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu2_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu3_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu0_E_reg2, vnu1_E_reg2, vnu2_E_reg2, vnu3_E_reg2;
		wire [1:0] vnu0_tranEn_out_f1;
		wire [1:0] vnu1_tranEn_out_f1;
		wire [1:0] vnu2_tranEn_out_f1;
		wire [1:0] vnu3_tranEn_out_f1;
		vnu3_f1 u_f1(
			.read_addr_offset_out (read_addr_offset_outSet[j]), // to forward the current multi-frame offset signal to the next sub-datapath	
			// For the first VNU
			.vnu0_v2c0 (vnu0_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_v2c1 (vnu0_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_v2c2 (vnu0_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_E_reg2 (vnu0_E_reg2[QUAN_SIZE-1:0]),
			.vnu0_tranEn_out0 (vnu0_tranEn_out_f1),
			// For the second VNU       
			.vnu1_v2c0 (vnu1_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_v2c1 (vnu1_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_v2c2 (vnu1_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_E_reg2 (vnu1_E_reg2[QUAN_SIZE-1:0]),
			.vnu1_tranEn_out0 (vnu1_tranEn_out_f1),
			// For the third VNU        
			.vnu2_v2c0 (vnu2_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_v2c1 (vnu2_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_v2c2 (vnu2_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_E_reg2 (vnu2_E_reg2[QUAN_SIZE-1:0]),
			.vnu2_tranEn_out0 (vnu2_tranEn_out_f1),
			// For the fourth VNU       
			.vnu3_v2c0 (vnu3_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_v2c1 (vnu3_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_v2c2 (vnu3_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_E_reg2 (vnu3_E_reg2[QUAN_SIZE-1:0]),	
			.vnu3_tranEn_out0 (vnu3_tranEn_out_f1),
			
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
			.page_addr_ram (page_addr_ram_1[VN_ROM_ADDR_BW-1:0]),
			// Ieration-Update Data
			.ram_write_data_1 (ram_write_dataA_1[VN_ROM_RD_BW-1:0]),
			
			.write_clk (vn_write_clk),
			.ib_ram_we (ib_ram_we[1])
		);	
	
		dnu_f0 u_f2(
			//output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath	
			.dnu0_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+0]), // internal signals accounting for each 128-entry partial LUT's output
			.dnu1_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+1]), // internal signals accounting for each 128-entry partial LUT's output		        
			.dnu2_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+2]), // internal signals accounting for each 128-entry partial LUT's output
			.dnu3_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+3]), // internal signals accounting for each 128-entry partial LUT's output
		
			// From the first DNU
			.vnu0_t10		 (vnu0_v2c[0]),
			.vnu0_c2v_2      (vnu0_E_reg2[QUAN_SIZE-1:0]),
			.vnu0_tranEn_in0 (vnu0_tranEn_out_f1),

			// From the second DNU
			.vnu1_t10		 (vnu1_v2c[0]),
			.vnu1_c2v_2      (vnu1_E_reg2[QUAN_SIZE-1:0]),
			.vnu1_tranEn_in0 (vnu1_tranEn_out_f1),

			// From the third DNU
			.vnu2_t10		 (vnu2_v2c[0]),
			.vnu2_c2v_2      (vnu2_E_reg2[QUAN_SIZE-1:0]),
			.vnu2_tranEn_in0 (vnu2_tranEn_out_f1),
		
			// From the fourth DNU
			.vnu3_t10		 (vnu3_v2c[0]),
			.vnu3_c2v_2      (vnu3_E_reg2[QUAN_SIZE-1:0]),
			.vnu3_tranEn_in0 (vnu3_tranEn_out_f1),
		
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset_outSet[j]), // offset determing the switch between multi-frame 
			
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_2[VN_ROM_ADDR_BW-1:0]),
			// Ieration-Update Data
			.ram_write_data_1 (ram_write_dataA_2[VN_ROM_RD_BW-1:0]),
			
			.write_clk (dn_write_clk),
			.ib_ram_we (ib_ram_we[2])
		);

		ib_vnu_3_pipeOut u_v2c_out0(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)]),

			.M0 (vnu0_v2c[0]),
			.M1 (vnu0_v2c[1]),
			.M2 (vnu0_v2c[2]),
			.ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out1(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)+1]),

			.M0 (vnu1_v2c[0]),
			.M1 (vnu1_v2c[1]),
			.M2 (vnu1_v2c[2]),
			.ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out2(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)+2]),

			.M0 (vnu2_v2c[0]),
			.M1 (vnu2_v2c[1]),
			.M2 (vnu2_v2c[2]),
			.ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out3(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)+3]),

			.M0 (vnu3_v2c[0]),
			.M1 (vnu3_v2c[1]),
			.M2 (vnu3_v2c[2]),
			.ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.v2c_src (v2c_src)              
		);
	end
endgenerate