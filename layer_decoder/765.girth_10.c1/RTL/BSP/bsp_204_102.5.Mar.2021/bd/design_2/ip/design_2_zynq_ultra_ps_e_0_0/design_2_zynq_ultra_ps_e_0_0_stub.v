// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Tue Mar 16 18:39:35 2021
// Host        : lmpcc-16 running 64-bit SUSE Linux Enterprise Server 15 SP1
// Command     : write_verilog -force -mode synth_stub
//               /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/BSP/bsp_204_102.5.Mar.2021/bd/design_2/ip/design_2_zynq_ultra_ps_e_0_0/design_2_zynq_ultra_ps_e_0_0_stub.v
// Design      : design_2_zynq_ultra_ps_e_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "zynq_ultra_ps_e_v3_3_1_zynq_ultra_ps_e,Vivado 2019.2" *)
module design_2_zynq_ultra_ps_e_0_0(saxihp0_fpd_aclk, saxigp2_aruser, 
  saxigp2_awuser, saxigp2_awid, saxigp2_awaddr, saxigp2_awlen, saxigp2_awsize, 
  saxigp2_awburst, saxigp2_awlock, saxigp2_awcache, saxigp2_awprot, saxigp2_awvalid, 
  saxigp2_awready, saxigp2_wdata, saxigp2_wstrb, saxigp2_wlast, saxigp2_wvalid, 
  saxigp2_wready, saxigp2_bid, saxigp2_bresp, saxigp2_bvalid, saxigp2_bready, saxigp2_arid, 
  saxigp2_araddr, saxigp2_arlen, saxigp2_arsize, saxigp2_arburst, saxigp2_arlock, 
  saxigp2_arcache, saxigp2_arprot, saxigp2_arvalid, saxigp2_arready, saxigp2_rid, 
  saxigp2_rdata, saxigp2_rresp, saxigp2_rlast, saxigp2_rvalid, saxigp2_rready, saxigp2_awqos, 
  saxigp2_arqos, pl_ps_irq0, pl_resetn0, pl_clk0)
/* synthesis syn_black_box black_box_pad_pin="saxihp0_fpd_aclk,saxigp2_aruser,saxigp2_awuser,saxigp2_awid[5:0],saxigp2_awaddr[48:0],saxigp2_awlen[7:0],saxigp2_awsize[2:0],saxigp2_awburst[1:0],saxigp2_awlock,saxigp2_awcache[3:0],saxigp2_awprot[2:0],saxigp2_awvalid,saxigp2_awready,saxigp2_wdata[31:0],saxigp2_wstrb[3:0],saxigp2_wlast,saxigp2_wvalid,saxigp2_wready,saxigp2_bid[5:0],saxigp2_bresp[1:0],saxigp2_bvalid,saxigp2_bready,saxigp2_arid[5:0],saxigp2_araddr[48:0],saxigp2_arlen[7:0],saxigp2_arsize[2:0],saxigp2_arburst[1:0],saxigp2_arlock,saxigp2_arcache[3:0],saxigp2_arprot[2:0],saxigp2_arvalid,saxigp2_arready,saxigp2_rid[5:0],saxigp2_rdata[31:0],saxigp2_rresp[1:0],saxigp2_rlast,saxigp2_rvalid,saxigp2_rready,saxigp2_awqos[3:0],saxigp2_arqos[3:0],pl_ps_irq0[0:0],pl_resetn0,pl_clk0" */;
  input saxihp0_fpd_aclk;
  input saxigp2_aruser;
  input saxigp2_awuser;
  input [5:0]saxigp2_awid;
  input [48:0]saxigp2_awaddr;
  input [7:0]saxigp2_awlen;
  input [2:0]saxigp2_awsize;
  input [1:0]saxigp2_awburst;
  input saxigp2_awlock;
  input [3:0]saxigp2_awcache;
  input [2:0]saxigp2_awprot;
  input saxigp2_awvalid;
  output saxigp2_awready;
  input [31:0]saxigp2_wdata;
  input [3:0]saxigp2_wstrb;
  input saxigp2_wlast;
  input saxigp2_wvalid;
  output saxigp2_wready;
  output [5:0]saxigp2_bid;
  output [1:0]saxigp2_bresp;
  output saxigp2_bvalid;
  input saxigp2_bready;
  input [5:0]saxigp2_arid;
  input [48:0]saxigp2_araddr;
  input [7:0]saxigp2_arlen;
  input [2:0]saxigp2_arsize;
  input [1:0]saxigp2_arburst;
  input saxigp2_arlock;
  input [3:0]saxigp2_arcache;
  input [2:0]saxigp2_arprot;
  input saxigp2_arvalid;
  output saxigp2_arready;
  output [5:0]saxigp2_rid;
  output [31:0]saxigp2_rdata;
  output [1:0]saxigp2_rresp;
  output saxigp2_rlast;
  output saxigp2_rvalid;
  input saxigp2_rready;
  input [3:0]saxigp2_awqos;
  input [3:0]saxigp2_arqos;
  input [0:0]pl_ps_irq0;
  output pl_resetn0;
  output pl_clk0;
endmodule
