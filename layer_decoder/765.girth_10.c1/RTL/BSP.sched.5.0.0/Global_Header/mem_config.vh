
// whenever write-enable is asserted, but in the meanwhile, there comes a read request
// And the such the read address and write address are identical, the underlying policy 
// is to write new page data onto corresponding page and place the old page data on the read_dataout port
`define RD_WR_CONCURRENT
`define HDL_INFER // primitive of BRAM implementation