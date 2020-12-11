`define SIM
`define V2C_C2V_PROBE

`define RC_204_102
`ifdef RC_204_102
`define CN_NUM  102 // # CNs
`define VN_NUM  204 // # VNs 
`define VN_DEGREE 3   // degree of one variable node
`define CN_DEGREE 6  // degree of one check node 

`define IB_ROM_SIZE 6 // width of one read-out port of RAMB36E1
`define IB_ROM_ADDR_WIDTH 6 // ceil(log2(64-entry)) = 6-bit 
`define IB_CNU_DECOMP_funNum `CN_DEGREE-2
`define IB_VNU_DECOMP_funNum `VN_DEGREE+1-2
`define IB_DNU_DECOMP_funNum 1
`define ITER_WRITE_PAGE_NUM  `IB_ROM_SIZE*`IB_CNU_DECOMP_funNum

`define CNU6_INSTANTIATE_NUM 51
`define CNU6_INSTANTIATE_UNIT 2
`define VNU3_INSTANTIATE_NUM 51
`define VNU3_INSTANTIATE_UNIT 4
`endif

`define QUAN_SIZE 4
`define DATAPATH_WIDTH 4

/*CNUs*/
parameter CN_ROM_RD_BW = 6;    // bit-width of one read port of BRAM based IB-ROM
parameter CN_ROM_ADDR_BW = 10;  // bit-width of read address of BRAM based IB-ROM
							// #Entry: (64-entry*3-bit) / ROM_RD_BW)*25-iteration
							// ceil(log2(#Entry)) = 10-bit
						    
parameter CN_PAGE_ADDR_BW = 5; // bit-width of addressing (64-entry*3-bit)/ROM_RD_BW), i.e., ceil(log2((64-entry*3-bit)/ROM_RD_BW)))								
parameter CN_ITER_ADDR_BW = 5;  // bit-width of addressing 25 iterationss
//parameter CN_TYPE_A = 1;    // the number of check node type in terms of its check node degree   
//parameter CN_TYPE_B = 1;     // the number of check node type in terms of its check node degree
parameter CN_LOAD_CYCLE = 32; // 64-entry with two interleaving banks requires 32 clock cycle to finish iteration update
parameter CN_RD_BW = 6;
parameter CN_ADDR_BW = 10;
parameter PIPELINE_DEPTH = 3;

/*VNUs and DNUs*/
parameter VN_QUAN_SIZE = 4;
parameter VN_ROM_RD_BW = 8;    // bit-width of one read port of BRAM based IB-ROM
parameter VN_ROM_ADDR_BW = 11;  // bit-width of read address of BRAM based IB-ROM
							// #Entry: (128-entry*4-bit) / ROM_RD_BW)*25-iteration
							// ceil(log2(#Entry)) = 11-bit
parameter DN_QUAN_SIZE = 4;
parameter DN_ROM_RD_BW = 8;    // bit-width of one read port of BRAM based IB-ROM
parameter DN_ROM_ADDR_BW = 11;  // bit-width of read address of BRAM based IB-ROM
							// #Entry: (128-entry*4-bit) / ROM_RD_BW)*25-iteration
							// ceil(log2(#Entry)) = 11-bit
						    
parameter VN_PAGE_ADDR_BW = 6; // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
parameter VN_ITER_ADDR_BW = 5;  // bit-width of addressing 25 iterationss
//parameter VN_TYPE_A = 1;    // the number of check node type in terms of its check node degree   
//parameter VN_TYPE_B = 1;     // the number of check node type in terms of its check node degree
parameter DN_PAGE_ADDR_BW = 6; // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
parameter DN_ITER_ADDR_BW = 5;  // bit-width of addressing 25 iterationss
//parameter DN_TYPE_A = 1;    // the number of check node type in terms of its check node degree   
//parameter DN_TYPE_B = 1;     // the number of check node type in terms of its check node degree
parameter VN_LOAD_CYCLE = 64; // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
parameter DN_LOAD_CYCLE = 64; // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
parameter VN_RD_BW = 8;
parameter DN_RD_BW = 2;
parameter VN_ADDR_BW = 11;
parameter DN_ADDR_BW = 11;
parameter PIPELINE_DEPTH = 3;