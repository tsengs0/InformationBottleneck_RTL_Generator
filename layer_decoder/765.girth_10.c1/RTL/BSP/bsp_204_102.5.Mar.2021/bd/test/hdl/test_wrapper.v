//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Wed Jan 27 20:14:28 2021
//Host        : lmpcc-21 running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target test_wrapper.bd
//Design      : test_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module test_wrapper
   (AXI_En_0,
    En_0,
    FrameSize_0,
    M_AXIS_0_tdata,
    M_AXIS_0_tlast,
    M_AXIS_0_tready,
    M_AXIS_0_tstrb,
    M_AXIS_0_tvalid,
    S_AXIS_0_tdata,
    S_AXIS_0_tlast,
    S_AXIS_0_tready,
    S_AXIS_0_tstrb,
    S_AXIS_0_tvalid,
    m_axis_aclk_0,
    m_axis_aresetn_0,
    pl_fifo_wr_clk_0,
    result_fifo_in_0,
    result_fifo_we_0,
    s_axis_aclk_0,
    s_axis_aresetn_0);
  input AXI_En_0;
  input En_0;
  input [7:0]FrameSize_0;
  output [31:0]M_AXIS_0_tdata;
  output M_AXIS_0_tlast;
  input M_AXIS_0_tready;
  output [3:0]M_AXIS_0_tstrb;
  output M_AXIS_0_tvalid;
  input [31:0]S_AXIS_0_tdata;
  input S_AXIS_0_tlast;
  output S_AXIS_0_tready;
  input [3:0]S_AXIS_0_tstrb;
  input S_AXIS_0_tvalid;
  input m_axis_aclk_0;
  input m_axis_aresetn_0;
  input pl_fifo_wr_clk_0;
  input [31:0]result_fifo_in_0;
  input result_fifo_we_0;
  input s_axis_aclk_0;
  input s_axis_aresetn_0;

  wire AXI_En_0;
  wire En_0;
  wire [7:0]FrameSize_0;
  wire [31:0]M_AXIS_0_tdata;
  wire M_AXIS_0_tlast;
  wire M_AXIS_0_tready;
  wire [3:0]M_AXIS_0_tstrb;
  wire M_AXIS_0_tvalid;
  wire [31:0]S_AXIS_0_tdata;
  wire S_AXIS_0_tlast;
  wire S_AXIS_0_tready;
  wire [3:0]S_AXIS_0_tstrb;
  wire S_AXIS_0_tvalid;
  wire m_axis_aclk_0;
  wire m_axis_aresetn_0;
  wire pl_fifo_wr_clk_0;
  wire [31:0]result_fifo_in_0;
  wire result_fifo_we_0;
  wire s_axis_aclk_0;
  wire s_axis_aresetn_0;

  test test_i
       (.AXI_En_0(AXI_En_0),
        .En_0(En_0),
        .FrameSize_0(FrameSize_0),
        .M_AXIS_0_tdata(M_AXIS_0_tdata),
        .M_AXIS_0_tlast(M_AXIS_0_tlast),
        .M_AXIS_0_tready(M_AXIS_0_tready),
        .M_AXIS_0_tstrb(M_AXIS_0_tstrb),
        .M_AXIS_0_tvalid(M_AXIS_0_tvalid),
        .S_AXIS_0_tdata(S_AXIS_0_tdata),
        .S_AXIS_0_tlast(S_AXIS_0_tlast),
        .S_AXIS_0_tready(S_AXIS_0_tready),
        .S_AXIS_0_tstrb(S_AXIS_0_tstrb),
        .S_AXIS_0_tvalid(S_AXIS_0_tvalid),
        .m_axis_aclk_0(m_axis_aclk_0),
        .m_axis_aresetn_0(m_axis_aresetn_0),
        .pl_fifo_wr_clk_0(pl_fifo_wr_clk_0),
        .result_fifo_in_0(result_fifo_in_0),
        .result_fifo_we_0(result_fifo_we_0),
        .s_axis_aclk_0(s_axis_aclk_0),
        .s_axis_aresetn_0(s_axis_aresetn_0));
endmodule
