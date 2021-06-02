//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Wed Jan 27 20:14:27 2021
//Host        : lmpcc-21 running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target test.bd
//Design      : test
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "test,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=test,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "test.hwdef" *) 
module test
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
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_0 TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS_0, CLK_DOMAIN test_m_axis_aclk_0, FREQ_HZ 100000000, HAS_TKEEP 0, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 1, INSERT_VIP 0, LAYERED_METADATA undef, PHASE 0.000, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) output [31:0]M_AXIS_0_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_0 TLAST" *) output M_AXIS_0_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_0 TREADY" *) input M_AXIS_0_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_0 TSTRB" *) output [3:0]M_AXIS_0_tstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_0 TVALID" *) output M_AXIS_0_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_0 TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS_0, CLK_DOMAIN test_s_axis_aclk_0, FREQ_HZ 100000000, HAS_TKEEP 0, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 1, INSERT_VIP 0, LAYERED_METADATA undef, PHASE 0.000, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) input [31:0]S_AXIS_0_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_0 TLAST" *) input S_AXIS_0_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_0 TREADY" *) output S_AXIS_0_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_0 TSTRB" *) input [3:0]S_AXIS_0_tstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_0 TVALID" *) input S_AXIS_0_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.M_AXIS_ACLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.M_AXIS_ACLK_0, ASSOCIATED_BUSIF M_AXIS_0, ASSOCIATED_RESET m_axis_aresetn_0, CLK_DOMAIN test_m_axis_aclk_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input m_axis_aclk_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.M_AXIS_ARESETN_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.M_AXIS_ARESETN_0, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input m_axis_aresetn_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.PL_FIFO_WR_CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.PL_FIFO_WR_CLK_0, CLK_DOMAIN test_pl_fifo_wr_clk_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input pl_fifo_wr_clk_0;
  input [31:0]result_fifo_in_0;
  input result_fifo_we_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.S_AXIS_ACLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.S_AXIS_ACLK_0, ASSOCIATED_BUSIF S_AXIS_0, ASSOCIATED_RESET s_axis_aresetn_0, CLK_DOMAIN test_s_axis_aclk_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input s_axis_aclk_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.S_AXIS_ARESETN_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.S_AXIS_ARESETN_0, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input s_axis_aresetn_0;

  wire AXI_En_0_1;
  wire En_0_1;
  wire [7:0]FrameSize_0_1;
  wire [31:0]S_AXIS_0_1_TDATA;
  wire S_AXIS_0_1_TLAST;
  wire S_AXIS_0_1_TREADY;
  wire [3:0]S_AXIS_0_1_TSTRB;
  wire S_AXIS_0_1_TVALID;
  wire [31:0]axis_pl2ps_fifo_0_M_AXIS_TDATA;
  wire axis_pl2ps_fifo_0_M_AXIS_TLAST;
  wire axis_pl2ps_fifo_0_M_AXIS_TREADY;
  wire [3:0]axis_pl2ps_fifo_0_M_AXIS_TSTRB;
  wire axis_pl2ps_fifo_0_M_AXIS_TVALID;
  wire m_axis_aclk_0_1;
  wire m_axis_aresetn_0_1;
  wire pl_fifo_wr_clk_0_1;
  wire [31:0]result_fifo_in_0_1;
  wire result_fifo_we_0_1;
  wire s_axis_aclk_0_1;
  wire s_axis_aresetn_0_1;

  assign AXI_En_0_1 = AXI_En_0;
  assign En_0_1 = En_0;
  assign FrameSize_0_1 = FrameSize_0[7:0];
  assign M_AXIS_0_tdata[31:0] = axis_pl2ps_fifo_0_M_AXIS_TDATA;
  assign M_AXIS_0_tlast = axis_pl2ps_fifo_0_M_AXIS_TLAST;
  assign M_AXIS_0_tstrb[3:0] = axis_pl2ps_fifo_0_M_AXIS_TSTRB;
  assign M_AXIS_0_tvalid = axis_pl2ps_fifo_0_M_AXIS_TVALID;
  assign S_AXIS_0_1_TDATA = S_AXIS_0_tdata[31:0];
  assign S_AXIS_0_1_TLAST = S_AXIS_0_tlast;
  assign S_AXIS_0_1_TSTRB = S_AXIS_0_tstrb[3:0];
  assign S_AXIS_0_1_TVALID = S_AXIS_0_tvalid;
  assign S_AXIS_0_tready = S_AXIS_0_1_TREADY;
  assign axis_pl2ps_fifo_0_M_AXIS_TREADY = M_AXIS_0_tready;
  assign m_axis_aclk_0_1 = m_axis_aclk_0;
  assign m_axis_aresetn_0_1 = m_axis_aresetn_0;
  assign pl_fifo_wr_clk_0_1 = pl_fifo_wr_clk_0;
  assign result_fifo_in_0_1 = result_fifo_in_0[31:0];
  assign result_fifo_we_0_1 = result_fifo_we_0;
  assign s_axis_aclk_0_1 = s_axis_aclk_0;
  assign s_axis_aresetn_0_1 = s_axis_aresetn_0;
  test_axis_pl2ps_fifo_0_0 axis_pl2ps_fifo_0
       (.AXI_En(AXI_En_0_1),
        .En(En_0_1),
        .FrameSize(FrameSize_0_1),
        .m_axis_aclk(m_axis_aclk_0_1),
        .m_axis_aresetn(m_axis_aresetn_0_1),
        .m_axis_tdata(axis_pl2ps_fifo_0_M_AXIS_TDATA),
        .m_axis_tlast(axis_pl2ps_fifo_0_M_AXIS_TLAST),
        .m_axis_tready(axis_pl2ps_fifo_0_M_AXIS_TREADY),
        .m_axis_tstrb(axis_pl2ps_fifo_0_M_AXIS_TSTRB),
        .m_axis_tvalid(axis_pl2ps_fifo_0_M_AXIS_TVALID),
        .pl_fifo_wr_clk(pl_fifo_wr_clk_0_1),
        .result_fifo_in(result_fifo_in_0_1),
        .result_fifo_we(result_fifo_we_0_1),
        .s_axis_aclk(s_axis_aclk_0_1),
        .s_axis_aresetn(s_axis_aresetn_0_1),
        .s_axis_tdata(S_AXIS_0_1_TDATA),
        .s_axis_tlast(S_AXIS_0_1_TLAST),
        .s_axis_tready(S_AXIS_0_1_TREADY),
        .s_axis_tstrb(S_AXIS_0_1_TSTRB),
        .s_axis_tvalid(S_AXIS_0_1_TVALID));
endmodule
