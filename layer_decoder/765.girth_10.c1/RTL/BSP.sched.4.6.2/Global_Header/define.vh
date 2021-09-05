//`define SIM
//`define V2C_C2V_PROBE
`define DECODER_4bit
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
	`define CN_NUM  SUBMATRIX_Z*VN_DEGREE // # CNs
	`define VN_NUM  SUBMATRIX_Z*CN_DEGREE // # VNs 
	`define QUAN_SIZE 4
	`define READ_CLK_RATE 100 // 100MHz
	`define WRITE_CLK_RATE 200 // 200MHz

	//`define SCHED_4_4
	`define SCHED_4_6
	`define MAX_ITER 10
	`define VN_ITER_ADDR_BW $clog2(`MAX_ITER)  // bit-width of addressing 10 iterationss
	`define DN_ITER_ADDR_BW $clog2(`MAX_ITER)
	`define ITER_ADDR_BW $clog2(`MAX_ITER)  // bit-width of addressing 10 iterationss
	`define IB_VNU_DECOMP_funNum `VN_DEGREE+1-2
	`define IB_DNU_DECOMP_funNum 1
	`define ITER_ROM_GROUP 10 // the number of iteration datasets stored in one Group of IB-ROMs

	`ifdef SCHED_4_6
		`define CNU_FSM_STATE_NUM 7
		`define VNU_FSM_STATE_NUM 8
		`define CH_FETCH_LATENCY 2
		`define CNU_INIT_FETCH_LATENCY 1
		`define BS_PIPELINE_LEVEL 2
	`endif

	//`define CODE_RATE_070
	`define NG_NUM 10  // 10 codeword segments
	`define NG_SIZE (`SUBMATRIX_Z*`CN_DEGREE)/`NG_NUM // the number of codebits in each codeword segment
	`define ERR_FRAME_HALT 1020
	`define SNR_SET_NUM 61 // from SNR_0.1 (dB) to SNR_6.0 (dB)
	`define START_SNR 1
	`define ALL_ZERO_CODEWORD // only evaluating all-zero codewords
`endif 
