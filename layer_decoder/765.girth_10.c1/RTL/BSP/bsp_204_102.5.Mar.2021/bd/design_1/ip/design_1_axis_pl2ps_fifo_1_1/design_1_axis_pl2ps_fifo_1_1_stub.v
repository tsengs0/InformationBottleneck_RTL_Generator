// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Wed Jan 27 20:18:48 2021
// Host        : lmpcc-21 running 64-bit SUSE Linux Enterprise Server 15 SP1
// Command     : write_verilog -force -mode synth_stub -rename_top design_1_axis_pl2ps_fifo_1_1 -prefix
//               design_1_axis_pl2ps_fifo_1_1_ test_axis_pl2ps_fifo_0_0_stub.v
// Design      : test_axis_pl2ps_fifo_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "axis_pl2ps_fifo_v1_0,Vivado 2019.2" *)
module design_1_axis_pl2ps_fifo_1_1(FrameSize, En, AXI_En, s_axis_aclk, 
  s_axis_aresetn, s_axis_tready, s_axis_tdata, s_axis_tstrb, s_axis_tlast, s_axis_tvalid, 
  m_axis_aclk, m_axis_aresetn, m_axis_tvalid, m_axis_tdata, m_axis_tstrb, m_axis_tlast, 
  m_axis_tready, result_fifo_in, result_fifo_we, pl_fifo_wr_clk)
/* synthesis syn_black_box black_box_pad_pin="FrameSize[7:0],En,AXI_En,s_axis_aclk,s_axis_aresetn,s_axis_tready,s_axis_tdata[31:0],s_axis_tstrb[3:0],s_axis_tlast,s_axis_tvalid,m_axis_aclk,m_axis_aresetn,m_axis_tvalid,m_axis_tdata[31:0],m_axis_tstrb[3:0],m_axis_tlast,m_axis_tready,result_fifo_in[31:0],result_fifo_we,pl_fifo_wr_clk" */;
  input [7:0]FrameSize;
  input En;
  input AXI_En;
  input s_axis_aclk;
  input s_axis_aresetn;
  output s_axis_tready;
  input [31:0]s_axis_tdata;
  input [3:0]s_axis_tstrb;
  input s_axis_tlast;
  input s_axis_tvalid;
  input m_axis_aclk;
  input m_axis_aresetn;
  output m_axis_tvalid;
  output [31:0]m_axis_tdata;
  output [3:0]m_axis_tstrb;
  output m_axis_tlast;
  input m_axis_tready;
  input [31:0]result_fifo_in;
  input result_fifo_we;
  input pl_fifo_wr_clk;
endmodule
