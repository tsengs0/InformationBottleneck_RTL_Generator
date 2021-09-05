//`define SIM
//`define V2C_C2V_PROBE
`define DECODER_4bit
//`define BOX_MULLER_AWGN
//`define DECODER_3bit
//`define RC_204_102
`define QC_RC_7650
`ifdef RC_204_102
	`define CN_NUM  102 // # CNs
	`define VN_NUM  204 // # VNs 
	`define VN_DEGREE 3   // degree of one variable node
	`define CN_DEGREE 6  // degree of one check node 

	`define CNU_FUNC_CYCLE   3 // the latency of one CNU 2-LUT function based on symmetrical design
	`define VNU_FUNC_CYCLE   3 // the latency of one VNU 2-LUT function based on symmetrical design
	`define DNU_FUNC_CYCLE   3 // the latency of one DNU 2-LUT function based on symmetrical design
	`define CNU_FUNC_MEM_END 2 // the Memory Read ends at rising edge of 2nd clock (indexed from 0th cycle)
	`define VNU_FUNC_MEM_END 2 // the Memory Read ends at rising edge of 2nd clock (indexed from 0th cycle)
	`define DNU_FUNC_MEM_END 2 // the Memory Read ends at rising edge of 2nd clock (indexed from 0th cycle)
	`define CNU_WR_HANDSHAKE_RESPONSE 2 // response time from assertion of pipe_load_start until rising edge of cnu_wr
	`define VNU_WR_HANDSHAKE_RESPONSE 2 // response time from assertion of pipe_load_start until rising edge of vnu_wr
	`define DNU_WR_HANDSHAKE_RESPONSE 2 // response time from assertion of pipe_load_start until rising edge of vnu_wr
	`define BANK_NUM 2 // the number of interleaving banks


	`define NG_NUM  1 // 1 codeword segments
	`define NG_SIZE `VN_NUM / `NG_NUM // the number of codebits in each codeword segment

	`ifdef DECODER_4bit
		/*obsolete*/`define IB_ROM_SIZE 6 // width of one read-out port of RAMB36E1
		/*obsolete*/`define IB_ROM_ADDR_WIDTH 6 // ceil(log2(64-entry)) = 6-bit 
		`define IB_CNU_DECOMP_funNum `CN_DEGREE-2
		`define IB_VNU_DECOMP_funNum `VN_DEGREE+1-2
		`define IB_DNU_DECOMP_funNum 1
		/*obsolete*/`define ITER_WRITE_PAGE_NUM  `IB_ROM_SIZE*`IB_CNU_DECOMP_funNum
		`define ITER_ADDR_BW 6  // bit-width of addressing 50 iterationss
		`define ITER_ROM_GROUP 25 // the number of iteration datasets stored in one Group of IB-ROMs
		`define ERR_FRAME_HALT 1020
		`define MAX_ITER 50
		`define SNR_SET_NUM 61 // from SNR_0.1 (dB) to SNR_6.0 (dB)
		`define START_SNR 1
		`define ALL_ZERO_CODEWORD // only evaluating all-zero codewords
		`define CODE_RATE_05
		//`define CODE_RATE_075
		//`define CODE_RATE_060
		//`define CODE_RATE_065
		//`define CODE_RATE_070
		//`define AWGN_GEN_VERIFY
		
		`define CNU6_INSTANTIATE_NUM 51
		`define CNU6_INSTANTIATE_UNIT 2
		`define VNU3_INSTANTIATE_NUM 51
		`define VNU3_INSTANTIATE_UNIT 4
		
		`define QUAN_SIZE 4
		`define DATAPATH_WIDTH 4
		
		/*CNUs*/
		`define CN_ROM_RD_BW  6    // bit-width of one read port of BRAM based IB-ROM
		`define CN_ROM_ADDR_BW 10  // bit-width of read address of BRAM based IB-ROM
									// #Entry: (64-entry*3-bit) / ROM_RD_BW)*25-iteration
									// ceil(log2(#Entry)) = 10-bit
								    
		`define CN_PAGE_ADDR_BW 5 // bit-width of addressing (64-entry*3-bit)/ROM_RD_BW), i.e., ceil(log2((64-entry*3-bit)/ROM_RD_BW)))								
		`define CN_LUT_MULTIFRAME_LEVEL 1
		//`define CN_TYPE_A 1    // the number of check node type in terms of its check node degree   
		//`define CN_TYPE_B 1     // the number of check node type in terms of its check node degree
		`define CN_LOAD_CYCLE 32// 64-entry with two interleaving banks requires 32 clock cycle to finish iteration update
		`define CN_RD_BW 6
		`define CN_ADDR_BW 10
		`define CN_PIPELINE_DEPTH 3
		`define CN_OVERPROVISION 1 // the over-counted IB-ROM read address
		`define CN_ITER_ADDR_BW 5  // bit-width of addressing 25 iterationss
		
		/*VNUs and DNUs*/
		`define VN_QUAN_SIZE 4
		`define VN_ROM_RD_BW 8    // bit-width of one read port of BRAM based IB-ROM
		`define VN_ROM_ADDR_BW 11  // bit-width of read address of BRAM based IB-ROM
									// #Entry: (128-entry*4-bit) / ROM_RD_BW)*25-iteration
									// ceil(log2(#Entry)) = 11-bit
		`define DN_QUAN_SIZE 1
		`define DN_ROM_RD_BW 2    // bit-width of one read port of BRAM based IB-ROM
		`define DN_ROM_ADDR_BW 11  // bit-width of read address of BRAM based IB-ROM
									// #Entry: (128-entry*4-bit) / ROM_RD_BW)*25-iteration
									// ceil(log2(#Entry)) = 11-bit
		`define VN_PIPELINE_DEPTH 3
		`define VN_OVERPROVISION 1 // the over-counted IB-ROM read address
		`define VN_ITER_ADDR_BW 5  // bit-width of addressing 25 iterationss
								    
		`define VN_PAGE_ADDR_BW 6 // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
		`define VN_LUT_MULTIFRAME_LEVEL 1
		//`define VN_TYPE_A 1    // the number of check node type in terms of its check node degree   
		//`define VN_TYPE_B 1     // the number of check node type in terms of its check node degree
		`define DN_PAGE_ADDR_BW 6 // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
		`define DN_LUT_MULTIFRAME_LEVEL 1
		//`define DN_TYPE_A 1    // the number of check node type in terms of its check node degree   
		//`define DN_TYPE_B 1     // the number of check node type in terms of its check node degree
		`define VN_LOAD_CYCLE 64 // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
		`define DN_LOAD_CYCLE 64 // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
		`define VN_RD_BW 8
		`define DN_RD_BW 2
		`define VN_ADDR_BW 11
		`define DN_ADDR_BW 11
		`define DN_PIPELINE_DEPTH 3
		`define DN_OVERPROVISION 1 // the over-counted IB-ROM read address
		`define DN_ITER_ADDR_BW 5  // bit-width of addressing 25 iterationss
		
		`define MULTI_FRAME_NUM 2
/*-------------------------------------------------------------------------------------------------*/
	`elsif DECODER_3bit		
		/*obsolete*/`define IB_ROM_SIZE 6 // width of one read-out port of RAMB36E1
		/*obsolete*/`define IB_ROM_ADDR_WIDTH 6 // ceil(log2(64-entry)) = 6-bit 
		`define IB_CNU_DECOMP_funNum `CN_DEGREE-2
		`define IB_VNU_DECOMP_funNum `VN_DEGREE+1-2
		`define IB_DNU_DECOMP_funNum 1
		/*obsolete*/`define ITER_WRITE_PAGE_NUM  `IB_ROM_SIZE*`IB_CNU_DECOMP_funNum
		`define ITER_ADDR_BW 6  // bit-width of addressing 50 iterationss
		`define ITER_ROM_GROUP 25 // the number of iteration datasets stored in one Group of IB-ROMs
		`define ERR_FRAME_HALT 1020
		`define MAX_ITER 50
		`define SNR_SET_NUM 61 // from SNR_0.1 (dB) to SNR_6.0 (dB)
		`define START_SNR 1
		`define ALL_ZERO_CODEWORD // only evaluating all-zero codewords
		`define CODE_RATE_05
		//`define CODE_RATE_075
		//`define CODE_RATE_060
		//`define CODE_RATE_065
		//`define CODE_RATE_070
		//`define AWGN_GEN_VERIFY
		
		`define CNU6_INSTANTIATE_NUM 51
		`define CNU6_INSTANTIATE_UNIT 2
		`define VNU3_INSTANTIATE_NUM 51
		`define VNU3_INSTANTIATE_UNIT 4
		
		`define QUAN_SIZE 3
		`define DATAPATH_WIDTH 3
		
		/*CNUs*/
		`define CN_ROM_RD_BW  4    // bit-width of one read port of BRAM based IB-ROM
		`define CN_ROM_ADDR_BW 8  // bit-width of read address of BRAM based IB-ROM
									// #Entry: (16-entry*2-bit) / ROM_RD_BW)*25-iteration
									// ceil(log2(#Entry)) = 8-bit
								    
		`define CN_PAGE_ADDR_BW 3 // bit-width of addressing (16-entry*2-bit)/ROM_RD_BW), i.e., ceil(log2((16-entry*2-bit)/ROM_RD_BW)))								
		`define CN_LUT_MULTIFRAME_LEVEL 1
		//`define CN_TYPE_A 1    // the number of check node type in terms of its check node degree   
		//`define CN_TYPE_B 1     // the number of check node type in terms of its check node degree
		`define CN_LOAD_CYCLE 8// 16-entry with two interleaving banks requires 8 clock cycle to finish iteration update
		`define CN_RD_BW 4
		`define CN_ADDR_BW 8
		`define CN_PIPELINE_DEPTH 3
		`define CN_OVERPROVISION 1 // the over-counted IB-ROM read address
		`define CN_ITER_ADDR_BW 5  // bit-width of addressing 25 iterationss
		
		/*VNUs and DNUs*/
		`define VN_QUAN_SIZE 3
		`define VN_ROM_RD_BW 6    // bit-width of one read port of BRAM based IB-ROM
		`define VN_ROM_ADDR_BW 9  // bit-width of read address of BRAM based IB-ROM
									// #Entry: (32-entry*3-bit) / ROM_RD_BW)*25-iteration
									// ceil(log2(#Entry)) = 9-bit
		`define DN_QUAN_SIZE 1
		`define DN_ROM_RD_BW 2    // bit-width of one read port of BRAM based IB-ROM
		`define DN_ROM_ADDR_BW 9  // bit-width of read address of BRAM based IB-ROM
									// #Entry: (32-entry*1-bit) / ROM_RD_BW)*25-iteration
									// ceil(log2(#Entry)) = 9-bit
		`define VN_PIPELINE_DEPTH 3
		`define VN_OVERPROVISION 1 // the over-counted IB-ROM read address
		`define VN_ITER_ADDR_BW 5  // bit-width of addressing 25 iterationss
								    
		`define VN_PAGE_ADDR_BW 4 // bit-width of addressing (32-entry*3-bit)/ROM_RD_BW), i.e., ceil(log2((32-entry*3-bit)/ROM_RD_BW)))								
		`define VN_LUT_MULTIFRAME_LEVEL 1
		//`define VN_TYPE_A 1    // the number of check node type in terms of its check node degree   
		//`define VN_TYPE_B 1     // the number of check node type in terms of its check node degree
		`define DN_PAGE_ADDR_BW 4 // bit-width of addressing (32-entry*1-bit)/ROM_RD_BW), i.e., ceil(log2((32-entry*1-bit)/ROM_RD_BW)))								
		`define DN_LUT_MULTIFRAME_LEVEL 1
		//`define DN_TYPE_A 1    // the number of check node type in terms of its check node degree   
		//`define DN_TYPE_B 1     // the number of check node type in terms of its check node degree
		`define VN_LOAD_CYCLE 16 // 32-entry with two interleaving banks requires 16 clock cycle to finish iteration update
		`define DN_LOAD_CYCLE 16 // 32-entry with two interleaving banks requires 16 clock cycle to finish iteration update
		`define VN_RD_BW 6
		`define DN_RD_BW 2
		`define VN_ADDR_BW 9
		`define DN_ADDR_BW 9
		`define DN_PIPELINE_DEPTH 3
		`define DN_OVERPROVISION 1 // the over-counted IB-ROM read address
		`define DN_ITER_ADDR_BW 5  // bit-width of addressing 25 iterationss
		
		`define MULTI_FRAME_NUM 2
/*-------------------------------------------------------------------------------------------------*/
	`else		
		/*obsolete*/`define IB_ROM_SIZE 6 // width of one read-out port of RAMB36E1
		/*obsolete*/`define IB_ROM_ADDR_WIDTH 6 // ceil(log2(64-entry)) = 6-bit 
		`define IB_CNU_DECOMP_funNum `CN_DEGREE-2
		`define IB_VNU_DECOMP_funNum `VN_DEGREE+1-2
		`define IB_DNU_DECOMP_funNum 1
		/*obsolete*/`define ITER_WRITE_PAGE_NUM  `IB_ROM_SIZE*`IB_CNU_DECOMP_funNum
		`define ITER_ADDR_BW 6  // bit-width of addressing 50 iterationss
		`define ITER_ROM_GROUP 25 // the number of iteration datasets stored in one Group of IB-ROMs
		`define ERR_FRAME_HALT 1020
		`define MAX_ITER 50
		`define SNR_SET_NUM 61 // from SNR_0.1 (dB) to SNR_6.0 (dB)
		`define START_SNR 20
		`define ALL_ZERO_CODEWORD // only evaluating all-zero codewords
		//`define CODE_RATE_05
		//`define CODE_RATE_075
		//`define CODE_RATE_060
		//`define CODE_RATE_065
		`define CODE_RATE_070
		//`define AWGN_GEN_VERIFY
		
		`define CNU6_INSTANTIATE_NUM 51
		`define CNU6_INSTANTIATE_UNIT 2
		`define VNU3_INSTANTIATE_NUM 51
		`define VNU3_INSTANTIATE_UNIT 4
		
		`define QUAN_SIZE 4
		`define DATAPATH_WIDTH 4
		
		/*CNUs*/
		`define CN_ROM_RD_BW  6    // bit-width of one read port of BRAM based IB-ROM
		`define CN_ROM_ADDR_BW 10  // bit-width of read address of BRAM based IB-ROM
									// #Entry: (64-entry*3-bit) / ROM_RD_BW)*25-iteration
									// ceil(log2(#Entry)) = 10-bit
								    
		`define CN_PAGE_ADDR_BW 5 // bit-width of addressing (64-entry*3-bit)/ROM_RD_BW), i.e., ceil(log2((64-entry*3-bit)/ROM_RD_BW)))								
		`define CN_LUT_MULTIFRAME_LEVEL 1
		//`define CN_TYPE_A 1    // the number of check node type in terms of its check node degree   
		//`define CN_TYPE_B 1     // the number of check node type in terms of its check node degree
		`define CN_LOAD_CYCLE 32// 64-entry with two interleaving banks requires 32 clock cycle to finish iteration update
		`define CN_RD_BW 6
		`define CN_ADDR_BW 10
		`define CN_PIPELINE_DEPTH 3
		`define CN_OVERPROVISION 1 // the over-counted IB-ROM read address
		`define CN_ITER_ADDR_BW 5  // bit-width of addressing 25 iterationss
		
		/*VNUs and DNUs*/
		`define VN_QUAN_SIZE 4
		`define VN_ROM_RD_BW 8    // bit-width of one read port of BRAM based IB-ROM
		`define VN_ROM_ADDR_BW 11  // bit-width of read address of BRAM based IB-ROM
									// #Entry: (128-entry*4-bit) / ROM_RD_BW)*25-iteration
									// ceil(log2(#Entry)) = 11-bit
		`define DN_QUAN_SIZE 1
		`define DN_ROM_RD_BW 2    // bit-width of one read port of BRAM based IB-ROM
		`define DN_ROM_ADDR_BW 11  // bit-width of read address of BRAM based IB-ROM
									// #Entry: (128-entry*4-bit) / ROM_RD_BW)*25-iteration
									// ceil(log2(#Entry)) = 11-bit
		`define VN_PIPELINE_DEPTH 3
		`define VN_OVERPROVISION 1 // the over-counted IB-ROM read address
		`define VN_ITER_ADDR_BW 5  // bit-width of addressing 25 iterationss
								    
		`define VN_PAGE_ADDR_BW 6 // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
		`define VN_LUT_MULTIFRAME_LEVEL 1
		//`define VN_TYPE_A 1    // the number of check node type in terms of its check node degree   
		//`define VN_TYPE_B 1     // the number of check node type in terms of its check node degree
		`define DN_PAGE_ADDR_BW 6 // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
		`define DN_LUT_MULTIFRAME_LEVEL 1
		//`define DN_TYPE_A 1    // the number of check node type in terms of its check node degree   
		//`define DN_TYPE_B 1     // the number of check node type in terms of its check node degree
		`define VN_LOAD_CYCLE 64 // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
		`define DN_LOAD_CYCLE 64 // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
		`define VN_RD_BW 8
		`define DN_RD_BW 2
		`define VN_ADDR_BW 11
		`define DN_ADDR_BW 11
		`define DN_PIPELINE_DEPTH 3
		`define DN_OVERPROVISION 1 // the over-counted IB-ROM read address
		`define DN_ITER_ADDR_BW 5  // bit-width of addressing 25 iterationss
		
		`define MULTI_FRAME_NUM 2
	`endif // DECODER_4bit
`elsif QC_RC_7650
	`define VN_DEGREE 3   // degree of one variable node
	`define CN_DEGREE 10  // degree of one check node 
	`define SUBMATRIX_Z 765
	`define CHECK_PARALLELISM 85
	`define ROW_CHUNK_NUM `SUBMATRIX_Z / `CHECK_PARALLELISM
	`define CN_NUM `SUBMATRIX_Z*`VN_DEGREE // # CNs
	`define VN_NUM `SUBMATRIX_Z*`CN_DEGREE // # VNs 
	`define QUAN_SIZE 4
	`define LAYER_NUM  3
	`define READ_CLK_RATE   100 // 100MHz
	`define WRITE_CLK_RATE  200 // 200MHz
	`define WRITE_CLK_RATIO  `WRITE_CLK_RATE/`READ_CLK_RATE // the ratio of write_clk clock rate with respect to clock rate of read_clk, e.g., Ratio = write_clk / read_clk = 200MHz/100MHz = 2


	//`define SCHED_4_4
	`define SCHED_4_6
	`define MAX_ITER 10
	//`define CODE_RATE_070
	`define NG_NUM 10  // 10 codeword segments
	`define NG_SIZE (`SUBMATRIX_Z*`CN_DEGREE)/`NG_NUM // the number of codebits in each codeword segment
	`define ERR_FRAME_HALT 300
	`define SNR_SET_NUM 61 // from SNR_0.1 (dB) to SNR_6.0 (dB)
	`define START_SNR 52 // 2.5dB is actually 4.5dB
	`define ALL_ZERO_CODEWORD // only evaluating all-zero codewords


	`define IB_ROM_SIZE  6 // width of one read-out port of RAMB36E1
	`define IB_ROM_ADDR_WIDTH  6 // ceil(log2(64-entry)) = 6-bit 
	`define VNU3_INSTANTIATE_NUM   5
	`define VNU3_INSTANTIATE_UNIT   2 // number of partial-VNUs instatiated in one modules (in order to reduce source code size)
	`define BANK_NUM  2
	`define MULTI_FRAME_NUM    2
	`define IB_CNU_DECOMP_funNum  1 // equivalent to one decomposed IB-LUT depth
	`define IB_VNU_DECOMP_funNum  `VN_DEGREE+1-2
	`define IB_DNU_DECOMP_funNum  1
	`define ITER_ADDR_BW  $clog2(`MAX_ITER) // bit-width of addressing 10 iterationss
    `define ITER_ROM_GROUP  10 // the number of iteration datasets stored in one Group of IB-ROMs

	/*VNUs and DNUs*/
	`define VN_QUAN_SIZE 4
	`define VN_ROM_RD_BW 8    // bit-width of one read port of BRAM based IB-ROM
	`define VN_ROM_ADDR_BW 10  // bit-width of read address of BRAM based IB-ROM
								// #Entry: (128-entry*4-bit) / ROM_RD_BW)*10-iteration
	`define VN_PIPELINE_DEPTH 3

	`define VN_OVERPROVISION  1 // the over-counted IB-ROM read address								// ceil(log2(#Entry)) = 11-bit
	`define DN_QUAN_SIZE  1
	`define DN_ROM_RD_BW  2    // bit-width of one read port of BRAM based IB-ROM
	`define DN_ROM_ADDR_BW  10  // bit-width of read address of BRAM based IB-ROM
								// #Entry: (128-entry*4-bit) / ROM_RD_BW)*10-iteration
								// ceil(log2(#Entry)) = 11-bit
	
	`define DN_OVERPROVISION  1 // the over-counted IB-ROM read address	
	`define VN_PAGE_ADDR_BW  6 // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
	`define VN_ITER_ADDR_BW $clog2(`MAX_ITER)  // bit-width of addressing 10 iterationss
	//`define VN_TYPE_A 1    // the number of check node type in terms of its check node degree   
	//`define VN_TYPE_B 1     // the number of check node type in terms of its check node degree
	`define DN_PAGE_ADDR_BW  6 // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
	`define DN_ITER_ADDR_BW $clog2(`MAX_ITER)  // bit-width of addressing 10 iterationss
	`define DN_PIPELINE_DEPTH 3
	//`define DN_TYPE_A 1    // the number of check node type in terms of its check node degree   
	//`define DN_TYPE_B 1     // the number of check node type in terms of its check node degree
	`define VN_LOAD_CYCLE 64 // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
	`define DN_LOAD_CYCLE 64 // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
	`define VN_RD_BW 8
	`define DN_RD_BW 2
	`define VN_ADDR_BW 11
	`define DN_ADDR_BW 11
/*-------------------------------------------------------------------------------------*/
	// CNU FSMs
	`define                            RESET_CYCLE  100
	`define                         CNU_FUNC_CYCLE  4
	`define                     CNU_PIPELINE_LEVEL  1*`CNU_FUNC_CYCLE
	`define 						BS_PIPELINE_LEVEL 2
	`define 					    VNU_BUBBLE_LEVEL 2
	`define                          FSM_STATE_NUM  10
	`define  INIT_LOAD    0
	`define  VNU_IB_RAM_PEND  1
	`define  VNU_BUBBLE 2
	`define  MEM_FETCH   3
	`define  CNU_PIPE   4
	`define  CNU_OUT   5
	`define  BS_WB   6
	`define  PAGE_ALIGN   7
	`define  MEM_WB   8
	`define  IDLE 		 9
/*-------------------------------------------------------------------------------------*/
	// VNU FSMs 
	`define                      VN_PIPELINE_BUBBLE 0
	`define                          VNU_FUNC_CYCLE 3
	`define                          DNU_FUNC_CYCLE 3
	`define                        VNU_FUNC_MEM_END 2
	`define                        DNU_FUNC_MEM_END 2
	`define               VNU_WR_HANDSHAKE_RESPONSE 2
	`define               DNU_WR_HANDSHAKE_RESPONSE 2
	`define                      VNU_PIPELINE_LEVEL 2*`VNU_FUNC_CYCLE+`VN_PIPELINE_BUBBLE
	`define                      DNU_PIPELINE_LEVEL 1*`DNU_FUNC_CYCLE
	`define 					  CH_FETCH_LEVEL    1
	`define                       PERMUTATION_LEVEL 2
	`define                        PAGE_ALIGN_LEVEL 1
	`define 						CH_BUBBLE_LEVEL 2
	`define                       PAGE_MEM_WB_LEVEL 1
	`define                            MEM_RD_LEVEL 2
	`define                           CTRL_FSM_STATE_NUM 11
	`define							WR_FSM_STATE_NUM 5
	`define VNU_MAIN_PIPELINE_LEVEL `VNU_PIPELINE_LEVEL+`PERMUTATION_LEVEL+`PAGE_ALIGN_LEVEL+`PAGE_MEM_WB_LEVEL+`ROW_CHUNK_NUM-1

	`define VNU_INIT_LOAD       0
	`define VNU_VNU_IB_RAM_PEND 1
	`define VNU_CH_FETCH        2
	`define CH_BUBBLE           3
	`define VNU_MEM_FETCH       4
	`define VNU_VNU_PIPE        5
	`define VNU_VNU_OUT         6
	`define VNU_BS_WB 		    7
	`define VNU_PAGE_ALIGN 	    8
	`define VNU_MEM_WB 		    9
	`define VNU_IDLE  		    10
/*-------------------------------------------------------------------------------------*/
	// `defines related to BS, PA and MEM
	`define RAM_DEPTH 1024
	`define RAM_ADDR_BITWIDTH $clog2(`RAM_DEPTH)
	`define BITWIDTH_SHIFT_FACTOR $clog2(`CHECK_PARALLELISM-1)
	`define shift_factor_0 `CHECK_PARALLELISM-24
	`define shift_factor_1 `CHECK_PARALLELISM-39
	`define shift_factor_2 `CHECK_PARALLELISM-63
	// `defines of extrinsic RAMs
	`define RAM_PORTA_RANGE 9 // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	`define RAM_PORTB_RANGE 9 // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	`define MEM_DEVICE_NUM  9

	`define V2C_DATA_WIDTH `CHECK_PARALLELISM*`QUAN_SIZE
	`define C2V_DATA_WIDTH `CHECK_PARALLELISM*`QUAN_SIZE
`ifdef SCHED_4_6
	`define C2V_MEM_ADDR_BASE 0
	`define V2C_MEM_ADDR_BASE `ROW_CHUNK_NUM
/*-------------------------------------------------------------------------------------*/
	// `defines for Channel Buffers
	`define CH_INIT_LOAD_LEVEL 5 // Write Cycle of ChMsg initial setup, i.e., $ceil(ROW_CHUNK_NUM/WRITE_CLK_RATIO),
	`define CH_FETCH_LATENCY   5
	`define CNU_INIT_FETCH_LATENCY  16+27//3,
	`define CH_DATA_WIDTH `CHECK_PARALLELISM*`QUAN_SIZE
	`define CH_MSG_NUM `CHECK_PARALLELISM*`CN_DEGREE
	// `defines of Channel RAM
	`define CH_RAM_DEPTH `ROW_CHUNK_NUM*`LAYER_NUM
	`define CH_RAM_ADDR_WIDTH $clog2(`CH_RAM_DEPTH)

	/*
	`define CH_RAM_INIT_WR_ADDR_BASE `ROW_CHUNK_NUM*2 // P2
	`define CH_RAM_INIT_WB_ADDR_BASE_0 0// P0
	`define CH_RAM_INIT_WB_ADDR_BASE_1 `ROW_CHUNK_NUM// P1
	`define CH_RAM_INIT_RD_ADDR_BASE   `ROW_CHUNK_NUM*2
	*/
	
	`define CH_RAM_INIT_WR_ADDR_BASE   `ROW_CHUNK_NUM*0 // P0
	`define CH_RAM_INIT_WB_ADDR_BASE_0 `ROW_CHUNK_NUM*1 // P1
	`define CH_RAM_INIT_WB_ADDR_BASE_1 `ROW_CHUNK_NUM*2 // P2
	`define CH_RAM_INIT_RD_ADDR_BASE   `ROW_CHUNK_NUM*0 // P0
	
/*-------------------------------------------------------------------------------------*/
	// `defines for DNU Sign Extension related Control Signals
	`define SIGN_EXTEN_FF_TO_BS 10 // 10 clock cycles between latch of VNU.F1.SignExtenOut and input of DNU.SignExtenIn.BS
	/*obsolete*/ `define PA_TO_DNU_DELAY 4 // 4 clock cycles between output of PA and input of DNUs 
	`define V2C_TO_DNU_LATENCY 9
	`define C2V_TO_DNU_LATENCY 6
	`define SIGN_EXTEN_LAYER_CNT_EXTEN 10
/*-------------------------------------------------------------------------------------*/
	`define shift_factor_1_0 `CHECK_PARALLELISM-24
	`define shift_factor_1_1 `CHECK_PARALLELISM-39
	`define shift_factor_1_2 `CHECK_PARALLELISM-22	
	`define shift_factor_2_0 `CHECK_PARALLELISM-9 
	`define shift_factor_2_1 `CHECK_PARALLELISM-21
	`define shift_factor_2_2 `CHECK_PARALLELISM-55
	`define shift_factor_3_0 `CHECK_PARALLELISM-38
	`define shift_factor_3_1 `CHECK_PARALLELISM-28
	`define shift_factor_3_2 `CHECK_PARALLELISM-19	
	`define shift_factor_4_0 `CHECK_PARALLELISM-71
	`define shift_factor_4_1 `CHECK_PARALLELISM-22
	`define shift_factor_4_2 `CHECK_PARALLELISM-77
	`define shift_factor_5_0 `CHECK_PARALLELISM-22
	`define shift_factor_5_1 `CHECK_PARALLELISM-83
	`define shift_factor_5_2 `CHECK_PARALLELISM-65
	`define shift_factor_6_0 `CHECK_PARALLELISM-39
	`define shift_factor_6_1 `CHECK_PARALLELISM-8 
	`define shift_factor_6_2 `CHECK_PARALLELISM-38
	`define shift_factor_7_0 `CHECK_PARALLELISM-20
	`define shift_factor_7_1 `CHECK_PARALLELISM-25
	`define shift_factor_7_2 `CHECK_PARALLELISM-40
	`define shift_factor_8_0 `CHECK_PARALLELISM-51
	`define shift_factor_8_1 `CHECK_PARALLELISM-28
	`define shift_factor_8_2 `CHECK_PARALLELISM-6 
	`define shift_factor_9_0 `CHECK_PARALLELISM-50
	`define shift_factor_9_1 `CHECK_PARALLELISM-20
	`define shift_factor_9_2 `CHECK_PARALLELISM-15

/*
	`define C2V_SHIFT_FACTOR_1_0 `shift_factor_1_0
	`define C2V_SHIFT_FACTOR_1_1 `shift_factor_1_1
	`define C2V_SHIFT_FACTOR_1_2 `shift_factor_1_2	
	`define C2V_SHIFT_FACTOR_2_0 `shift_factor_2_0
	`define C2V_SHIFT_FACTOR_2_1 `shift_factor_2_1
	`define C2V_SHIFT_FACTOR_2_2 `shift_factor_2_2
	`define C2V_SHIFT_FACTOR_3_0 `shift_factor_3_0
	`define C2V_SHIFT_FACTOR_3_1 `shift_factor_3_1
	`define C2V_SHIFT_FACTOR_3_2 `shift_factor_3_2	
	`define C2V_SHIFT_FACTOR_4_0 `shift_factor_4_0
	`define C2V_SHIFT_FACTOR_4_1 `shift_factor_4_1
	`define C2V_SHIFT_FACTOR_4_2 `shift_factor_4_2
	`define C2V_SHIFT_FACTOR_5_0 `shift_factor_5_0
	`define C2V_SHIFT_FACTOR_5_1 `shift_factor_5_1
	`define C2V_SHIFT_FACTOR_5_2 `shift_factor_5_2
	`define C2V_SHIFT_FACTOR_6_0 `shift_factor_6_0
	`define C2V_SHIFT_FACTOR_6_1 `shift_factor_6_1
	`define C2V_SHIFT_FACTOR_6_2 `shift_factor_6_2
	`define C2V_SHIFT_FACTOR_7_0 `shift_factor_7_0
	`define C2V_SHIFT_FACTOR_7_1 `shift_factor_7_1
	`define C2V_SHIFT_FACTOR_7_2 `shift_factor_7_2
	`define C2V_SHIFT_FACTOR_8_0 `shift_factor_8_0
	`define C2V_SHIFT_FACTOR_8_1 `shift_factor_8_1
	`define C2V_SHIFT_FACTOR_8_2 `shift_factor_8_2 
	`define C2V_SHIFT_FACTOR_9_0 `shift_factor_9_0
	`define C2V_SHIFT_FACTOR_9_1 `shift_factor_9_1
	`define C2V_SHIFT_FACTOR_9_2 `shift_factor_9_2

	`define V2C_SHIFT_FACTOR_1_0 `shift_factor_1_2
	`define V2C_SHIFT_FACTOR_1_1 `shift_factor_1_0
	`define V2C_SHIFT_FACTOR_1_2 `shift_factor_1_1	
	`define V2C_SHIFT_FACTOR_2_0 `shift_factor_2_2
	`define V2C_SHIFT_FACTOR_2_1 `shift_factor_2_0
	`define V2C_SHIFT_FACTOR_2_2 `shift_factor_2_1
	`define V2C_SHIFT_FACTOR_3_0 `shift_factor_3_2
	`define V2C_SHIFT_FACTOR_3_1 `shift_factor_3_0
	`define V2C_SHIFT_FACTOR_3_2 `shift_factor_3_1	
	`define V2C_SHIFT_FACTOR_4_0 `shift_factor_4_2
	`define V2C_SHIFT_FACTOR_4_1 `shift_factor_4_0
	`define V2C_SHIFT_FACTOR_4_2 `shift_factor_4_1
	`define V2C_SHIFT_FACTOR_5_0 `shift_factor_5_2
	`define V2C_SHIFT_FACTOR_5_1 `shift_factor_5_0
	`define V2C_SHIFT_FACTOR_5_2 `shift_factor_5_1
	`define V2C_SHIFT_FACTOR_6_0 `shift_factor_6_2
	`define V2C_SHIFT_FACTOR_6_1 `shift_factor_6_0
	`define V2C_SHIFT_FACTOR_6_2 `shift_factor_6_1
	`define V2C_SHIFT_FACTOR_7_0 `shift_factor_7_2
	`define V2C_SHIFT_FACTOR_7_1 `shift_factor_7_0
	`define V2C_SHIFT_FACTOR_7_2 `shift_factor_7_1
	`define V2C_SHIFT_FACTOR_8_0 `shift_factor_8_2
	`define V2C_SHIFT_FACTOR_8_1 `shift_factor_8_0
	`define V2C_SHIFT_FACTOR_8_2 `shift_factor_8_1 
	`define V2C_SHIFT_FACTOR_9_0 `shift_factor_9_2
	`define V2C_SHIFT_FACTOR_9_1 `shift_factor_9_0
	`define V2C_SHIFT_FACTOR_9_2 `shift_factor_9_1

	`define CH_WB_SHIFT_FACTOR_1_0 `shift_factor_1_2
	`define CH_WB_SHIFT_FACTOR_1_1 `shift_factor_1_0
	`define CH_WB_SHIFT_FACTOR_2_0 `shift_factor_2_2
	`define CH_WB_SHIFT_FACTOR_2_1 `shift_factor_2_0
	`define CH_WB_SHIFT_FACTOR_3_0 `shift_factor_3_2
	`define CH_WB_SHIFT_FACTOR_3_1 `shift_factor_3_0
	`define CH_WB_SHIFT_FACTOR_4_0 `shift_factor_4_2
	`define CH_WB_SHIFT_FACTOR_4_1 `shift_factor_4_0
	`define CH_WB_SHIFT_FACTOR_5_0 `shift_factor_5_2
	`define CH_WB_SHIFT_FACTOR_5_1 `shift_factor_5_0
	`define CH_WB_SHIFT_FACTOR_6_0 `shift_factor_6_2
	`define CH_WB_SHIFT_FACTOR_6_1 `shift_factor_6_0
	`define CH_WB_SHIFT_FACTOR_7_0 `shift_factor_7_2
	`define CH_WB_SHIFT_FACTOR_7_1 `shift_factor_7_0
	`define CH_WB_SHIFT_FACTOR_8_0 `shift_factor_8_2
	`define CH_WB_SHIFT_FACTOR_8_1 `shift_factor_8_0
	`define CH_WB_SHIFT_FACTOR_9_0 `shift_factor_9_2
	`define CH_WB_SHIFT_FACTOR_9_1 `shift_factor_9_0
*/
	
	`define C2V_SHIFT_FACTOR_1_0 `shift_factor_1_0
	`define C2V_SHIFT_FACTOR_1_1 `shift_factor_1_1
	`define C2V_SHIFT_FACTOR_1_2 `shift_factor_1_2	
	`define C2V_SHIFT_FACTOR_2_0 `shift_factor_2_0
	`define C2V_SHIFT_FACTOR_2_1 `shift_factor_2_1
	`define C2V_SHIFT_FACTOR_2_2 `shift_factor_2_2
	`define C2V_SHIFT_FACTOR_3_0 `shift_factor_3_0
	`define C2V_SHIFT_FACTOR_3_1 `shift_factor_3_1
	`define C2V_SHIFT_FACTOR_3_2 `shift_factor_3_2	
	`define C2V_SHIFT_FACTOR_4_0 `shift_factor_4_0
	`define C2V_SHIFT_FACTOR_4_1 `shift_factor_4_1
	`define C2V_SHIFT_FACTOR_4_2 `shift_factor_4_2
	`define C2V_SHIFT_FACTOR_5_0 `shift_factor_5_0
	`define C2V_SHIFT_FACTOR_5_1 `shift_factor_5_1
	`define C2V_SHIFT_FACTOR_5_2 `shift_factor_5_2
	`define C2V_SHIFT_FACTOR_6_0 `shift_factor_6_0
	`define C2V_SHIFT_FACTOR_6_1 `shift_factor_6_1
	`define C2V_SHIFT_FACTOR_6_2 `shift_factor_6_2
	`define C2V_SHIFT_FACTOR_7_0 `shift_factor_7_0
	`define C2V_SHIFT_FACTOR_7_1 `shift_factor_7_1
	`define C2V_SHIFT_FACTOR_7_2 `shift_factor_7_2
	`define C2V_SHIFT_FACTOR_8_0 `shift_factor_8_0
	`define C2V_SHIFT_FACTOR_8_1 `shift_factor_8_1
	`define C2V_SHIFT_FACTOR_8_2 `shift_factor_8_2 
	`define C2V_SHIFT_FACTOR_9_0 `shift_factor_9_0
	`define C2V_SHIFT_FACTOR_9_1 `shift_factor_9_1
	`define C2V_SHIFT_FACTOR_9_2 `shift_factor_9_2

	`define V2C_SHIFT_FACTOR_1_0 `shift_factor_1_0
	`define V2C_SHIFT_FACTOR_1_1 `shift_factor_1_1
	`define V2C_SHIFT_FACTOR_1_2 `shift_factor_1_2	
	`define V2C_SHIFT_FACTOR_2_0 `shift_factor_2_0
	`define V2C_SHIFT_FACTOR_2_1 `shift_factor_2_1
	`define V2C_SHIFT_FACTOR_2_2 `shift_factor_2_2
	`define V2C_SHIFT_FACTOR_3_0 `shift_factor_3_0
	`define V2C_SHIFT_FACTOR_3_1 `shift_factor_3_1
	`define V2C_SHIFT_FACTOR_3_2 `shift_factor_3_2	
	`define V2C_SHIFT_FACTOR_4_0 `shift_factor_4_0
	`define V2C_SHIFT_FACTOR_4_1 `shift_factor_4_1
	`define V2C_SHIFT_FACTOR_4_2 `shift_factor_4_2
	`define V2C_SHIFT_FACTOR_5_0 `shift_factor_5_0
	`define V2C_SHIFT_FACTOR_5_1 `shift_factor_5_1
	`define V2C_SHIFT_FACTOR_5_2 `shift_factor_5_2
	`define V2C_SHIFT_FACTOR_6_0 `shift_factor_6_0
	`define V2C_SHIFT_FACTOR_6_1 `shift_factor_6_1
	`define V2C_SHIFT_FACTOR_6_2 `shift_factor_6_2
	`define V2C_SHIFT_FACTOR_7_0 `shift_factor_7_0
	`define V2C_SHIFT_FACTOR_7_1 `shift_factor_7_1
	`define V2C_SHIFT_FACTOR_7_2 `shift_factor_7_2
	`define V2C_SHIFT_FACTOR_8_0 `shift_factor_8_0
	`define V2C_SHIFT_FACTOR_8_1 `shift_factor_8_1
	`define V2C_SHIFT_FACTOR_8_2 `shift_factor_8_2
	`define V2C_SHIFT_FACTOR_9_0 `shift_factor_9_0
	`define V2C_SHIFT_FACTOR_9_1 `shift_factor_9_1
	`define V2C_SHIFT_FACTOR_9_2 `shift_factor_9_2

	`define CH_WB_SHIFT_FACTOR_1_0 `shift_factor_1_0
	`define CH_WB_SHIFT_FACTOR_1_1 `shift_factor_1_1
	`define CH_WB_SHIFT_FACTOR_2_0 `shift_factor_2_0
	`define CH_WB_SHIFT_FACTOR_2_1 `shift_factor_2_1
	`define CH_WB_SHIFT_FACTOR_3_0 `shift_factor_3_0
	`define CH_WB_SHIFT_FACTOR_3_1 `shift_factor_3_1
	`define CH_WB_SHIFT_FACTOR_4_0 `shift_factor_4_0
	`define CH_WB_SHIFT_FACTOR_4_1 `shift_factor_4_1
	`define CH_WB_SHIFT_FACTOR_5_0 `shift_factor_5_0
	`define CH_WB_SHIFT_FACTOR_5_1 `shift_factor_5_1
	`define CH_WB_SHIFT_FACTOR_6_0 `shift_factor_6_0
	`define CH_WB_SHIFT_FACTOR_6_1 `shift_factor_6_1
	`define CH_WB_SHIFT_FACTOR_7_0 `shift_factor_7_0
	`define CH_WB_SHIFT_FACTOR_7_1 `shift_factor_7_1
	`define CH_WB_SHIFT_FACTOR_8_0 `shift_factor_8_0
	`define CH_WB_SHIFT_FACTOR_8_1 `shift_factor_8_1
	`define CH_WB_SHIFT_FACTOR_9_0 `shift_factor_9_0
	`define CH_WB_SHIFT_FACTOR_9_1 `shift_factor_9_1
	
/*-------------------------------------------------------------*/
	`define START_PAGE_0_0 0
	`define START_PAGE_0_1 0
	`define START_PAGE_0_2 0
	`define START_PAGE_1_0 2
	`define START_PAGE_1_1 8
	`define START_PAGE_1_2 1
	`define START_PAGE_2_0 0
	`define START_PAGE_2_1 3
	`define START_PAGE_2_2 8
	`define START_PAGE_3_0 8
	`define START_PAGE_3_1 7
	`define START_PAGE_3_2 5
	`define START_PAGE_4_0 7
	`define START_PAGE_4_1 5
	`define START_PAGE_4_2 7
	`define START_PAGE_5_0 7
	`define START_PAGE_5_1 2
	`define START_PAGE_5_2 1
	`define START_PAGE_6_0 7
	`define START_PAGE_6_1 7
	`define START_PAGE_6_2 6
	`define START_PAGE_7_0 4
	`define START_PAGE_7_1 8
	`define START_PAGE_7_2 8
	`define START_PAGE_8_0 1
	`define START_PAGE_8_1 8
	`define START_PAGE_8_2 2
	`define START_PAGE_9_0 1
	`define START_PAGE_9_1 8
	`define START_PAGE_9_2 2
/*
	`define C2V_START_PAGE_0_0 `START_PAGE_0_0
	`define C2V_START_PAGE_0_1 `START_PAGE_0_1
	`define C2V_START_PAGE_0_2 `START_PAGE_0_2
	`define C2V_START_PAGE_1_0 `START_PAGE_1_0
	`define C2V_START_PAGE_1_1 `START_PAGE_1_1
	`define C2V_START_PAGE_1_2 `START_PAGE_1_2
	`define C2V_START_PAGE_2_0 `START_PAGE_2_0
	`define C2V_START_PAGE_2_1 `START_PAGE_2_1
	`define C2V_START_PAGE_2_2 `START_PAGE_2_2
	`define C2V_START_PAGE_3_0 `START_PAGE_3_0
	`define C2V_START_PAGE_3_1 `START_PAGE_3_1
	`define C2V_START_PAGE_3_2 `START_PAGE_3_2
	`define C2V_START_PAGE_4_0 `START_PAGE_4_0
	`define C2V_START_PAGE_4_1 `START_PAGE_4_1
	`define C2V_START_PAGE_4_2 `START_PAGE_4_2
	`define C2V_START_PAGE_5_0 `START_PAGE_5_0
	`define C2V_START_PAGE_5_1 `START_PAGE_5_1
	`define C2V_START_PAGE_5_2 `START_PAGE_5_2
	`define C2V_START_PAGE_6_0 `START_PAGE_6_0
	`define C2V_START_PAGE_6_1 `START_PAGE_6_1
	`define C2V_START_PAGE_6_2 `START_PAGE_6_2
	`define C2V_START_PAGE_7_0 `START_PAGE_7_0
	`define C2V_START_PAGE_7_1 `START_PAGE_7_1
	`define C2V_START_PAGE_7_2 `START_PAGE_7_2
	`define C2V_START_PAGE_8_0 `START_PAGE_8_0
	`define C2V_START_PAGE_8_1 `START_PAGE_8_1
	`define C2V_START_PAGE_8_2 `START_PAGE_8_2
	`define C2V_START_PAGE_9_0 `START_PAGE_9_0
	`define C2V_START_PAGE_9_1 `START_PAGE_9_1
	`define C2V_START_PAGE_9_2 `START_PAGE_9_2

	`define V2C_START_PAGE_0_0 `START_PAGE_0_0
	`define V2C_START_PAGE_0_1 `START_PAGE_0_1
	`define V2C_START_PAGE_0_2 `START_PAGE_0_2
	`define V2C_START_PAGE_1_0 `START_PAGE_1_2
	`define V2C_START_PAGE_1_1 `START_PAGE_1_0
	`define V2C_START_PAGE_1_2 `START_PAGE_1_1
	`define V2C_START_PAGE_2_0 `START_PAGE_2_2
	`define V2C_START_PAGE_2_1 `START_PAGE_2_0
	`define V2C_START_PAGE_2_2 `START_PAGE_2_1
	`define V2C_START_PAGE_3_0 `START_PAGE_3_2
	`define V2C_START_PAGE_3_1 `START_PAGE_3_0
	`define V2C_START_PAGE_3_2 `START_PAGE_3_1
	`define V2C_START_PAGE_4_0 `START_PAGE_4_2
	`define V2C_START_PAGE_4_1 `START_PAGE_4_0
	`define V2C_START_PAGE_4_2 `START_PAGE_4_1
	`define V2C_START_PAGE_5_0 `START_PAGE_5_2
	`define V2C_START_PAGE_5_1 `START_PAGE_5_0
	`define V2C_START_PAGE_5_2 `START_PAGE_5_1
	`define V2C_START_PAGE_6_0 `START_PAGE_6_2
	`define V2C_START_PAGE_6_1 `START_PAGE_6_0
	`define V2C_START_PAGE_6_2 `START_PAGE_6_1
	`define V2C_START_PAGE_7_0 `START_PAGE_7_2
	`define V2C_START_PAGE_7_1 `START_PAGE_7_0
	`define V2C_START_PAGE_7_2 `START_PAGE_7_1
	`define V2C_START_PAGE_8_0 `START_PAGE_8_2
	`define V2C_START_PAGE_8_1 `START_PAGE_8_0
	`define V2C_START_PAGE_8_2 `START_PAGE_8_1
	`define V2C_START_PAGE_9_0 `START_PAGE_9_2
	`define V2C_START_PAGE_9_1 `START_PAGE_9_0
	`define V2C_START_PAGE_9_2 `START_PAGE_9_1
*/
	
	`define C2V_START_PAGE_0_0 `START_PAGE_0_0
	`define C2V_START_PAGE_0_1 `START_PAGE_0_1
	`define C2V_START_PAGE_0_2 `START_PAGE_0_2
	`define C2V_START_PAGE_1_0 `START_PAGE_1_0
	`define C2V_START_PAGE_1_1 `START_PAGE_1_1
	`define C2V_START_PAGE_1_2 `START_PAGE_1_2
	`define C2V_START_PAGE_2_0 `START_PAGE_2_0
	`define C2V_START_PAGE_2_1 `START_PAGE_2_1
	`define C2V_START_PAGE_2_2 `START_PAGE_2_2
	`define C2V_START_PAGE_3_0 `START_PAGE_3_0
	`define C2V_START_PAGE_3_1 `START_PAGE_3_1
	`define C2V_START_PAGE_3_2 `START_PAGE_3_2
	`define C2V_START_PAGE_4_0 `START_PAGE_4_0
	`define C2V_START_PAGE_4_1 `START_PAGE_4_1
	`define C2V_START_PAGE_4_2 `START_PAGE_4_2
	`define C2V_START_PAGE_5_0 `START_PAGE_5_0
	`define C2V_START_PAGE_5_1 `START_PAGE_5_1
	`define C2V_START_PAGE_5_2 `START_PAGE_5_2
	`define C2V_START_PAGE_6_0 `START_PAGE_6_0
	`define C2V_START_PAGE_6_1 `START_PAGE_6_1
	`define C2V_START_PAGE_6_2 `START_PAGE_6_2
	`define C2V_START_PAGE_7_0 `START_PAGE_7_0
	`define C2V_START_PAGE_7_1 `START_PAGE_7_1
	`define C2V_START_PAGE_7_2 `START_PAGE_7_2
	`define C2V_START_PAGE_8_0 `START_PAGE_8_0
	`define C2V_START_PAGE_8_1 `START_PAGE_8_1
	`define C2V_START_PAGE_8_2 `START_PAGE_8_2
	`define C2V_START_PAGE_9_0 `START_PAGE_9_0
	`define C2V_START_PAGE_9_1 `START_PAGE_9_1
	`define C2V_START_PAGE_9_2 `START_PAGE_9_2

	`define V2C_START_PAGE_0_0 `START_PAGE_0_0
	`define V2C_START_PAGE_0_1 `START_PAGE_0_1
	`define V2C_START_PAGE_0_2 `START_PAGE_0_2
	`define V2C_START_PAGE_1_0 `START_PAGE_1_0
	`define V2C_START_PAGE_1_1 `START_PAGE_1_1
	`define V2C_START_PAGE_1_2 `START_PAGE_1_2
	`define V2C_START_PAGE_2_0 `START_PAGE_2_0
	`define V2C_START_PAGE_2_1 `START_PAGE_2_1
	`define V2C_START_PAGE_2_2 `START_PAGE_2_2
	`define V2C_START_PAGE_3_0 `START_PAGE_3_0
	`define V2C_START_PAGE_3_1 `START_PAGE_3_1
	`define V2C_START_PAGE_3_2 `START_PAGE_3_2
	`define V2C_START_PAGE_4_0 `START_PAGE_4_0
	`define V2C_START_PAGE_4_1 `START_PAGE_4_1
	`define V2C_START_PAGE_4_2 `START_PAGE_4_2
	`define V2C_START_PAGE_5_0 `START_PAGE_5_0
	`define V2C_START_PAGE_5_1 `START_PAGE_5_1
	`define V2C_START_PAGE_5_2 `START_PAGE_5_2
	`define V2C_START_PAGE_6_0 `START_PAGE_6_0
	`define V2C_START_PAGE_6_1 `START_PAGE_6_1
	`define V2C_START_PAGE_6_2 `START_PAGE_6_2
	`define V2C_START_PAGE_7_0 `START_PAGE_7_0
	`define V2C_START_PAGE_7_1 `START_PAGE_7_1
	`define V2C_START_PAGE_7_2 `START_PAGE_7_2
	`define V2C_START_PAGE_8_0 `START_PAGE_8_0
	`define V2C_START_PAGE_8_1 `START_PAGE_8_1
	`define V2C_START_PAGE_8_2 `START_PAGE_8_2
	`define V2C_START_PAGE_9_0 `START_PAGE_9_0
	`define V2C_START_PAGE_9_1 `START_PAGE_9_1
	`define V2C_START_PAGE_9_2 `START_PAGE_9_2
/*-------------------------------------------------------------------------------------*/
	/*
	`define CNU_LAYER_ORDER_0 3'b001
	`define CNU_LAYER_ORDER_1 3'b010
	`define CNU_LAYER_ORDER_2 3'b100
	`define VNU_LAYER_ORDER_0 3'b100
	`define VNU_LAYER_ORDER_1 3'b001
	`define VNU_LAYER_ORDER_2 3'b010
	*/
	
	`define CNU_LAYER_ORDER_0 3'b001
	`define CNU_LAYER_ORDER_1 3'b010
	`define CNU_LAYER_ORDER_2 3'b100
	`define VNU_LAYER_ORDER_0 3'b001
	`define VNU_LAYER_ORDER_1 3'b010
	`define VNU_LAYER_ORDER_2 3'b100
	
`endif
	`define DEPTH 1024
	`define DATA_WIDTH 36
	`define FRAG_DATA_WIDTH 16
	`define ADDR_WIDTH $clog2(`DEPTH)

`endif 
