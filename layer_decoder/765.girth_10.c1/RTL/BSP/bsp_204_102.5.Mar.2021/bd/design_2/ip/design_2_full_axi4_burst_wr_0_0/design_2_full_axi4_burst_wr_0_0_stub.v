// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Tue Mar 16 18:39:16 2021
// Host        : lmpcc-16 running 64-bit SUSE Linux Enterprise Server 15 SP1
// Command     : write_verilog -force -mode synth_stub
//               /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/BSP/bsp_204_102.5.Mar.2021/bd/design_2/ip/design_2_full_axi4_burst_wr_0_0/design_2_full_axi4_burst_wr_0_0_stub.v
// Design      : design_2_full_axi4_burst_wr_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "full_axi4_burst_wr_v1_0,Vivado 2019.2" *)
module design_2_full_axi4_burst_wr_0_0(axi_wr_intr_en, axi_wr_first_shift, 
  axi_wr_next_shift, axi_wr_end, result_packet_in, m00_axi_init_axi_txn, m00_axi_txn_done, 
  m00_axi_error, m00_axi_aclk, m00_axi_aresetn, m00_axi_awid, m00_axi_awaddr, m00_axi_awlen, 
  m00_axi_awsize, m00_axi_awburst, m00_axi_awlock, m00_axi_awcache, m00_axi_awprot, 
  m00_axi_awqos, m00_axi_awuser, m00_axi_awvalid, m00_axi_awready, m00_axi_wdata, 
  m00_axi_wstrb, m00_axi_wlast, m00_axi_wuser, m00_axi_wvalid, m00_axi_wready, m00_axi_bid, 
  m00_axi_bresp, m00_axi_buser, m00_axi_bvalid, m00_axi_bready, m00_axi_arid, m00_axi_araddr, 
  m00_axi_arlen, m00_axi_arsize, m00_axi_arburst, m00_axi_arlock, m00_axi_arcache, 
  m00_axi_arprot, m00_axi_arqos, m00_axi_aruser, m00_axi_arvalid, m00_axi_arready, 
  m00_axi_rid, m00_axi_rdata, m00_axi_rresp, m00_axi_rlast, m00_axi_ruser, m00_axi_rvalid, 
  m00_axi_rready)
/* synthesis syn_black_box black_box_pad_pin="axi_wr_intr_en,axi_wr_first_shift,axi_wr_next_shift,axi_wr_end,result_packet_in[31:0],m00_axi_init_axi_txn,m00_axi_txn_done,m00_axi_error,m00_axi_aclk,m00_axi_aresetn,m00_axi_awid[0:0],m00_axi_awaddr[31:0],m00_axi_awlen[7:0],m00_axi_awsize[2:0],m00_axi_awburst[1:0],m00_axi_awlock,m00_axi_awcache[3:0],m00_axi_awprot[2:0],m00_axi_awqos[3:0],m00_axi_awuser[0:0],m00_axi_awvalid,m00_axi_awready,m00_axi_wdata[31:0],m00_axi_wstrb[3:0],m00_axi_wlast,m00_axi_wuser[0:0],m00_axi_wvalid,m00_axi_wready,m00_axi_bid[0:0],m00_axi_bresp[1:0],m00_axi_buser[0:0],m00_axi_bvalid,m00_axi_bready,m00_axi_arid[0:0],m00_axi_araddr[31:0],m00_axi_arlen[7:0],m00_axi_arsize[2:0],m00_axi_arburst[1:0],m00_axi_arlock,m00_axi_arcache[3:0],m00_axi_arprot[2:0],m00_axi_arqos[3:0],m00_axi_aruser[0:0],m00_axi_arvalid,m00_axi_arready,m00_axi_rid[0:0],m00_axi_rdata[31:0],m00_axi_rresp[1:0],m00_axi_rlast,m00_axi_ruser[0:0],m00_axi_rvalid,m00_axi_rready" */;
  output axi_wr_intr_en;
  output axi_wr_first_shift;
  output axi_wr_next_shift;
  output axi_wr_end;
  input [31:0]result_packet_in;
  input m00_axi_init_axi_txn;
  output m00_axi_txn_done;
  output m00_axi_error;
  input m00_axi_aclk;
  input m00_axi_aresetn;
  output [0:0]m00_axi_awid;
  output [31:0]m00_axi_awaddr;
  output [7:0]m00_axi_awlen;
  output [2:0]m00_axi_awsize;
  output [1:0]m00_axi_awburst;
  output m00_axi_awlock;
  output [3:0]m00_axi_awcache;
  output [2:0]m00_axi_awprot;
  output [3:0]m00_axi_awqos;
  output [0:0]m00_axi_awuser;
  output m00_axi_awvalid;
  input m00_axi_awready;
  output [31:0]m00_axi_wdata;
  output [3:0]m00_axi_wstrb;
  output m00_axi_wlast;
  output [0:0]m00_axi_wuser;
  output m00_axi_wvalid;
  input m00_axi_wready;
  input [0:0]m00_axi_bid;
  input [1:0]m00_axi_bresp;
  input [0:0]m00_axi_buser;
  input m00_axi_bvalid;
  output m00_axi_bready;
  output [0:0]m00_axi_arid;
  output [31:0]m00_axi_araddr;
  output [7:0]m00_axi_arlen;
  output [2:0]m00_axi_arsize;
  output [1:0]m00_axi_arburst;
  output m00_axi_arlock;
  output [3:0]m00_axi_arcache;
  output [2:0]m00_axi_arprot;
  output [3:0]m00_axi_arqos;
  output [0:0]m00_axi_aruser;
  output m00_axi_arvalid;
  input m00_axi_arready;
  input [0:0]m00_axi_rid;
  input [31:0]m00_axi_rdata;
  input [1:0]m00_axi_rresp;
  input m00_axi_rlast;
  input [0:0]m00_axi_ruser;
  input m00_axi_rvalid;
  output m00_axi_rready;
endmodule
