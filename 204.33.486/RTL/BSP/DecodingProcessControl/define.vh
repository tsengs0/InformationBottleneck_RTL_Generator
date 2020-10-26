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