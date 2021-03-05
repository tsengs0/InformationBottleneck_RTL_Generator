//`define SIM
//`define V2C_C2V_PROBE

`define RC_204_102
`ifdef RC_204_102
`define CN_NUM  102 // # CNs
`define VN_NUM  204 // # VNs 
`define VN_DEGREE 3   // degree of one variable node
`define CN_DEGREE 6  // degree of one check node 

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
`endif
