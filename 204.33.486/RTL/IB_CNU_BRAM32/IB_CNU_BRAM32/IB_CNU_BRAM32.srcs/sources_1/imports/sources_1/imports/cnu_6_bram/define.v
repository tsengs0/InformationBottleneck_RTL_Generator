`define SIM

`define RC_204_102
`ifdef RC_204_102
`define CN_NUM  102 // # CNs
`define VN_NUM  204 // # VNs 
`define VN_DEGREE 3   // degree of one variable node
`define CN_DEGREE 6  // degree of one check node 

`define IB_ROM_SIZE 32 // width of one read-out port of RAMB36E1
`define IB_ROM_ADDR_WIDTH 7 // ceil(log2(114-entry)) = 7-bit 
`define IB_CNU_DECOMP_funNum 4
`endif

`define QUAN_SIZE 4
`define DATAPATH_WIDTH 4


