//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Tue Mar 16 18:35:13 2021
//Host        : lmpcc-16 running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target design_2.bd
//Design      : design_2
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_2,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_2,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=4,numReposBlks=4,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_axi4_cnt=1,da_clkrst_cnt=7,da_zynq_ultra_ps_e_cnt=1,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "design_2.hwdef" *) 
module design_2
   (axi_wr_end,
    axi_wr_first_shift,
    axi_wr_next_shift,
    m00_axi_aclk,
    m00_axi_init_axi_txn,
    m00_axi_wr_intr_en,
    m_axi_arestn,
    pl_ps_ext_intr,
    result_packet_in);
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.AXI_WR_END DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.AXI_WR_END, LAYERED_METADATA undef" *) output axi_wr_end;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.AXI_WR_FIRST_SHIFT DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.AXI_WR_FIRST_SHIFT, LAYERED_METADATA undef" *) output axi_wr_first_shift;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.AXI_WR_NEXT_SHIFT DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.AXI_WR_NEXT_SHIFT, LAYERED_METADATA undef" *) output axi_wr_next_shift;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.M00_AXI_ACLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.M00_AXI_ACLK, CLK_DOMAIN design_2_zynq_ultra_ps_e_0_0_pl_clk0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) output m00_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.M00_AXI_INIT_AXI_TXN DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.M00_AXI_INIT_AXI_TXN, LAYERED_METADATA undef" *) input m00_axi_init_axi_txn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.M00_AXI_WR_INTR_EN INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.M00_AXI_WR_INTR_EN, PortWidth 1, SENSITIVITY LEVEL_HIGH" *) output m00_axi_wr_intr_en;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.M_AXI_ARESTN DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.M_AXI_ARESTN, LAYERED_METADATA undef, POLARITY ACTIVE_LOW" *) output [0:0]m_axi_arestn;
  (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 INTR.PL_PS_EXT_INTR INTERRUPT" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME INTR.PL_PS_EXT_INTR, PortWidth 1, SENSITIVITY EDGE_RISING" *) input pl_ps_ext_intr;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.RESULT_PACKET_IN DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.RESULT_PACKET_IN, LAYERED_METADATA undef" *) input [31:0]result_packet_in;

  wire [48:0]axi_smc_M00_AXI_ARADDR;
  wire [1:0]axi_smc_M00_AXI_ARBURST;
  wire [3:0]axi_smc_M00_AXI_ARCACHE;
  wire [7:0]axi_smc_M00_AXI_ARLEN;
  wire [0:0]axi_smc_M00_AXI_ARLOCK;
  wire [2:0]axi_smc_M00_AXI_ARPROT;
  wire [3:0]axi_smc_M00_AXI_ARQOS;
  wire axi_smc_M00_AXI_ARREADY;
  wire [2:0]axi_smc_M00_AXI_ARSIZE;
  wire [0:0]axi_smc_M00_AXI_ARUSER;
  wire axi_smc_M00_AXI_ARVALID;
  wire [48:0]axi_smc_M00_AXI_AWADDR;
  wire [1:0]axi_smc_M00_AXI_AWBURST;
  wire [3:0]axi_smc_M00_AXI_AWCACHE;
  wire [7:0]axi_smc_M00_AXI_AWLEN;
  wire [0:0]axi_smc_M00_AXI_AWLOCK;
  wire [2:0]axi_smc_M00_AXI_AWPROT;
  wire [3:0]axi_smc_M00_AXI_AWQOS;
  wire axi_smc_M00_AXI_AWREADY;
  wire [2:0]axi_smc_M00_AXI_AWSIZE;
  wire [0:0]axi_smc_M00_AXI_AWUSER;
  wire axi_smc_M00_AXI_AWVALID;
  wire axi_smc_M00_AXI_BREADY;
  wire [1:0]axi_smc_M00_AXI_BRESP;
  wire axi_smc_M00_AXI_BVALID;
  wire [31:0]axi_smc_M00_AXI_RDATA;
  wire axi_smc_M00_AXI_RLAST;
  wire axi_smc_M00_AXI_RREADY;
  wire [1:0]axi_smc_M00_AXI_RRESP;
  wire axi_smc_M00_AXI_RVALID;
  wire [31:0]axi_smc_M00_AXI_WDATA;
  wire axi_smc_M00_AXI_WLAST;
  wire axi_smc_M00_AXI_WREADY;
  wire [3:0]axi_smc_M00_AXI_WSTRB;
  wire axi_smc_M00_AXI_WVALID;
  wire [31:0]full_axi4_burst_wr_0_M00_AXI_ARADDR;
  wire [1:0]full_axi4_burst_wr_0_M00_AXI_ARBURST;
  wire [3:0]full_axi4_burst_wr_0_M00_AXI_ARCACHE;
  wire [0:0]full_axi4_burst_wr_0_M00_AXI_ARID;
  wire [7:0]full_axi4_burst_wr_0_M00_AXI_ARLEN;
  wire full_axi4_burst_wr_0_M00_AXI_ARLOCK;
  wire [2:0]full_axi4_burst_wr_0_M00_AXI_ARPROT;
  wire [3:0]full_axi4_burst_wr_0_M00_AXI_ARQOS;
  wire full_axi4_burst_wr_0_M00_AXI_ARREADY;
  wire [2:0]full_axi4_burst_wr_0_M00_AXI_ARSIZE;
  wire [0:0]full_axi4_burst_wr_0_M00_AXI_ARUSER;
  wire full_axi4_burst_wr_0_M00_AXI_ARVALID;
  wire [31:0]full_axi4_burst_wr_0_M00_AXI_AWADDR;
  wire [1:0]full_axi4_burst_wr_0_M00_AXI_AWBURST;
  wire [3:0]full_axi4_burst_wr_0_M00_AXI_AWCACHE;
  wire [0:0]full_axi4_burst_wr_0_M00_AXI_AWID;
  wire [7:0]full_axi4_burst_wr_0_M00_AXI_AWLEN;
  wire full_axi4_burst_wr_0_M00_AXI_AWLOCK;
  wire [2:0]full_axi4_burst_wr_0_M00_AXI_AWPROT;
  wire [3:0]full_axi4_burst_wr_0_M00_AXI_AWQOS;
  wire full_axi4_burst_wr_0_M00_AXI_AWREADY;
  wire [2:0]full_axi4_burst_wr_0_M00_AXI_AWSIZE;
  wire [0:0]full_axi4_burst_wr_0_M00_AXI_AWUSER;
  wire full_axi4_burst_wr_0_M00_AXI_AWVALID;
  wire [0:0]full_axi4_burst_wr_0_M00_AXI_BID;
  wire full_axi4_burst_wr_0_M00_AXI_BREADY;
  wire [1:0]full_axi4_burst_wr_0_M00_AXI_BRESP;
  wire [0:0]full_axi4_burst_wr_0_M00_AXI_BUSER;
  wire full_axi4_burst_wr_0_M00_AXI_BVALID;
  wire [31:0]full_axi4_burst_wr_0_M00_AXI_RDATA;
  wire [0:0]full_axi4_burst_wr_0_M00_AXI_RID;
  wire full_axi4_burst_wr_0_M00_AXI_RLAST;
  wire full_axi4_burst_wr_0_M00_AXI_RREADY;
  wire [1:0]full_axi4_burst_wr_0_M00_AXI_RRESP;
  wire full_axi4_burst_wr_0_M00_AXI_RVALID;
  wire [31:0]full_axi4_burst_wr_0_M00_AXI_WDATA;
  wire full_axi4_burst_wr_0_M00_AXI_WLAST;
  wire full_axi4_burst_wr_0_M00_AXI_WREADY;
  wire [3:0]full_axi4_burst_wr_0_M00_AXI_WSTRB;
  wire full_axi4_burst_wr_0_M00_AXI_WVALID;
  wire full_axi4_burst_wr_0_axi_wr_end;
  wire full_axi4_burst_wr_0_axi_wr_first_shift;
  wire full_axi4_burst_wr_0_axi_wr_intr_en;
  wire full_axi4_burst_wr_0_axi_wr_next_shift;
  wire m00_axi_init_axi_txn_1;
  wire pl_ps_ext_intr_1;
  wire [31:0]result_packet_in_1;
  wire [0:0]rst_ps8_0_100M_peripheral_aresetn;
  wire zynq_ultra_ps_e_0_pl_clk0;
  wire zynq_ultra_ps_e_0_pl_resetn0;

  assign axi_wr_end = full_axi4_burst_wr_0_axi_wr_end;
  assign axi_wr_first_shift = full_axi4_burst_wr_0_axi_wr_first_shift;
  assign axi_wr_next_shift = full_axi4_burst_wr_0_axi_wr_next_shift;
  assign m00_axi_aclk = zynq_ultra_ps_e_0_pl_clk0;
  assign m00_axi_init_axi_txn_1 = m00_axi_init_axi_txn;
  assign m00_axi_wr_intr_en = full_axi4_burst_wr_0_axi_wr_intr_en;
  assign m_axi_arestn[0] = rst_ps8_0_100M_peripheral_aresetn;
  assign pl_ps_ext_intr_1 = pl_ps_ext_intr;
  assign result_packet_in_1 = result_packet_in[31:0];
  design_2_axi_smc_0 axi_smc
       (.M00_AXI_araddr(axi_smc_M00_AXI_ARADDR),
        .M00_AXI_arburst(axi_smc_M00_AXI_ARBURST),
        .M00_AXI_arcache(axi_smc_M00_AXI_ARCACHE),
        .M00_AXI_arlen(axi_smc_M00_AXI_ARLEN),
        .M00_AXI_arlock(axi_smc_M00_AXI_ARLOCK),
        .M00_AXI_arprot(axi_smc_M00_AXI_ARPROT),
        .M00_AXI_arqos(axi_smc_M00_AXI_ARQOS),
        .M00_AXI_arready(axi_smc_M00_AXI_ARREADY),
        .M00_AXI_arsize(axi_smc_M00_AXI_ARSIZE),
        .M00_AXI_aruser(axi_smc_M00_AXI_ARUSER),
        .M00_AXI_arvalid(axi_smc_M00_AXI_ARVALID),
        .M00_AXI_awaddr(axi_smc_M00_AXI_AWADDR),
        .M00_AXI_awburst(axi_smc_M00_AXI_AWBURST),
        .M00_AXI_awcache(axi_smc_M00_AXI_AWCACHE),
        .M00_AXI_awlen(axi_smc_M00_AXI_AWLEN),
        .M00_AXI_awlock(axi_smc_M00_AXI_AWLOCK),
        .M00_AXI_awprot(axi_smc_M00_AXI_AWPROT),
        .M00_AXI_awqos(axi_smc_M00_AXI_AWQOS),
        .M00_AXI_awready(axi_smc_M00_AXI_AWREADY),
        .M00_AXI_awsize(axi_smc_M00_AXI_AWSIZE),
        .M00_AXI_awuser(axi_smc_M00_AXI_AWUSER),
        .M00_AXI_awvalid(axi_smc_M00_AXI_AWVALID),
        .M00_AXI_bready(axi_smc_M00_AXI_BREADY),
        .M00_AXI_bresp(axi_smc_M00_AXI_BRESP),
        .M00_AXI_buser(1'b0),
        .M00_AXI_bvalid(axi_smc_M00_AXI_BVALID),
        .M00_AXI_rdata(axi_smc_M00_AXI_RDATA),
        .M00_AXI_rlast(axi_smc_M00_AXI_RLAST),
        .M00_AXI_rready(axi_smc_M00_AXI_RREADY),
        .M00_AXI_rresp(axi_smc_M00_AXI_RRESP),
        .M00_AXI_rvalid(axi_smc_M00_AXI_RVALID),
        .M00_AXI_wdata(axi_smc_M00_AXI_WDATA),
        .M00_AXI_wlast(axi_smc_M00_AXI_WLAST),
        .M00_AXI_wready(axi_smc_M00_AXI_WREADY),
        .M00_AXI_wstrb(axi_smc_M00_AXI_WSTRB),
        .M00_AXI_wvalid(axi_smc_M00_AXI_WVALID),
        .S00_AXI_araddr(full_axi4_burst_wr_0_M00_AXI_ARADDR),
        .S00_AXI_arburst(full_axi4_burst_wr_0_M00_AXI_ARBURST),
        .S00_AXI_arcache(full_axi4_burst_wr_0_M00_AXI_ARCACHE),
        .S00_AXI_arid(full_axi4_burst_wr_0_M00_AXI_ARID),
        .S00_AXI_arlen(full_axi4_burst_wr_0_M00_AXI_ARLEN),
        .S00_AXI_arlock(full_axi4_burst_wr_0_M00_AXI_ARLOCK),
        .S00_AXI_arprot(full_axi4_burst_wr_0_M00_AXI_ARPROT),
        .S00_AXI_arqos(full_axi4_burst_wr_0_M00_AXI_ARQOS),
        .S00_AXI_arready(full_axi4_burst_wr_0_M00_AXI_ARREADY),
        .S00_AXI_arsize(full_axi4_burst_wr_0_M00_AXI_ARSIZE),
        .S00_AXI_aruser(full_axi4_burst_wr_0_M00_AXI_ARUSER),
        .S00_AXI_arvalid(full_axi4_burst_wr_0_M00_AXI_ARVALID),
        .S00_AXI_awaddr(full_axi4_burst_wr_0_M00_AXI_AWADDR),
        .S00_AXI_awburst(full_axi4_burst_wr_0_M00_AXI_AWBURST),
        .S00_AXI_awcache(full_axi4_burst_wr_0_M00_AXI_AWCACHE),
        .S00_AXI_awid(full_axi4_burst_wr_0_M00_AXI_AWID),
        .S00_AXI_awlen(full_axi4_burst_wr_0_M00_AXI_AWLEN),
        .S00_AXI_awlock(full_axi4_burst_wr_0_M00_AXI_AWLOCK),
        .S00_AXI_awprot(full_axi4_burst_wr_0_M00_AXI_AWPROT),
        .S00_AXI_awqos(full_axi4_burst_wr_0_M00_AXI_AWQOS),
        .S00_AXI_awready(full_axi4_burst_wr_0_M00_AXI_AWREADY),
        .S00_AXI_awsize(full_axi4_burst_wr_0_M00_AXI_AWSIZE),
        .S00_AXI_awuser(full_axi4_burst_wr_0_M00_AXI_AWUSER),
        .S00_AXI_awvalid(full_axi4_burst_wr_0_M00_AXI_AWVALID),
        .S00_AXI_bid(full_axi4_burst_wr_0_M00_AXI_BID),
        .S00_AXI_bready(full_axi4_burst_wr_0_M00_AXI_BREADY),
        .S00_AXI_bresp(full_axi4_burst_wr_0_M00_AXI_BRESP),
        .S00_AXI_buser(full_axi4_burst_wr_0_M00_AXI_BUSER),
        .S00_AXI_bvalid(full_axi4_burst_wr_0_M00_AXI_BVALID),
        .S00_AXI_rdata(full_axi4_burst_wr_0_M00_AXI_RDATA),
        .S00_AXI_rid(full_axi4_burst_wr_0_M00_AXI_RID),
        .S00_AXI_rlast(full_axi4_burst_wr_0_M00_AXI_RLAST),
        .S00_AXI_rready(full_axi4_burst_wr_0_M00_AXI_RREADY),
        .S00_AXI_rresp(full_axi4_burst_wr_0_M00_AXI_RRESP),
        .S00_AXI_rvalid(full_axi4_burst_wr_0_M00_AXI_RVALID),
        .S00_AXI_wdata(full_axi4_burst_wr_0_M00_AXI_WDATA),
        .S00_AXI_wlast(full_axi4_burst_wr_0_M00_AXI_WLAST),
        .S00_AXI_wready(full_axi4_burst_wr_0_M00_AXI_WREADY),
        .S00_AXI_wstrb(full_axi4_burst_wr_0_M00_AXI_WSTRB),
        .S00_AXI_wvalid(full_axi4_burst_wr_0_M00_AXI_WVALID),
        .aclk(zynq_ultra_ps_e_0_pl_clk0),
        .aresetn(rst_ps8_0_100M_peripheral_aresetn));
  design_2_full_axi4_burst_wr_0_0 full_axi4_burst_wr_0
       (.axi_wr_end(full_axi4_burst_wr_0_axi_wr_end),
        .axi_wr_first_shift(full_axi4_burst_wr_0_axi_wr_first_shift),
        .axi_wr_intr_en(full_axi4_burst_wr_0_axi_wr_intr_en),
        .axi_wr_next_shift(full_axi4_burst_wr_0_axi_wr_next_shift),
        .m00_axi_aclk(zynq_ultra_ps_e_0_pl_clk0),
        .m00_axi_araddr(full_axi4_burst_wr_0_M00_AXI_ARADDR),
        .m00_axi_arburst(full_axi4_burst_wr_0_M00_AXI_ARBURST),
        .m00_axi_arcache(full_axi4_burst_wr_0_M00_AXI_ARCACHE),
        .m00_axi_aresetn(rst_ps8_0_100M_peripheral_aresetn),
        .m00_axi_arid(full_axi4_burst_wr_0_M00_AXI_ARID),
        .m00_axi_arlen(full_axi4_burst_wr_0_M00_AXI_ARLEN),
        .m00_axi_arlock(full_axi4_burst_wr_0_M00_AXI_ARLOCK),
        .m00_axi_arprot(full_axi4_burst_wr_0_M00_AXI_ARPROT),
        .m00_axi_arqos(full_axi4_burst_wr_0_M00_AXI_ARQOS),
        .m00_axi_arready(full_axi4_burst_wr_0_M00_AXI_ARREADY),
        .m00_axi_arsize(full_axi4_burst_wr_0_M00_AXI_ARSIZE),
        .m00_axi_aruser(full_axi4_burst_wr_0_M00_AXI_ARUSER),
        .m00_axi_arvalid(full_axi4_burst_wr_0_M00_AXI_ARVALID),
        .m00_axi_awaddr(full_axi4_burst_wr_0_M00_AXI_AWADDR),
        .m00_axi_awburst(full_axi4_burst_wr_0_M00_AXI_AWBURST),
        .m00_axi_awcache(full_axi4_burst_wr_0_M00_AXI_AWCACHE),
        .m00_axi_awid(full_axi4_burst_wr_0_M00_AXI_AWID),
        .m00_axi_awlen(full_axi4_burst_wr_0_M00_AXI_AWLEN),
        .m00_axi_awlock(full_axi4_burst_wr_0_M00_AXI_AWLOCK),
        .m00_axi_awprot(full_axi4_burst_wr_0_M00_AXI_AWPROT),
        .m00_axi_awqos(full_axi4_burst_wr_0_M00_AXI_AWQOS),
        .m00_axi_awready(full_axi4_burst_wr_0_M00_AXI_AWREADY),
        .m00_axi_awsize(full_axi4_burst_wr_0_M00_AXI_AWSIZE),
        .m00_axi_awuser(full_axi4_burst_wr_0_M00_AXI_AWUSER),
        .m00_axi_awvalid(full_axi4_burst_wr_0_M00_AXI_AWVALID),
        .m00_axi_bid(full_axi4_burst_wr_0_M00_AXI_BID),
        .m00_axi_bready(full_axi4_burst_wr_0_M00_AXI_BREADY),
        .m00_axi_bresp(full_axi4_burst_wr_0_M00_AXI_BRESP),
        .m00_axi_buser(full_axi4_burst_wr_0_M00_AXI_BUSER),
        .m00_axi_bvalid(full_axi4_burst_wr_0_M00_AXI_BVALID),
        .m00_axi_init_axi_txn(m00_axi_init_axi_txn_1),
        .m00_axi_rdata(full_axi4_burst_wr_0_M00_AXI_RDATA),
        .m00_axi_rid(full_axi4_burst_wr_0_M00_AXI_RID),
        .m00_axi_rlast(full_axi4_burst_wr_0_M00_AXI_RLAST),
        .m00_axi_rready(full_axi4_burst_wr_0_M00_AXI_RREADY),
        .m00_axi_rresp(full_axi4_burst_wr_0_M00_AXI_RRESP),
        .m00_axi_ruser(1'b0),
        .m00_axi_rvalid(full_axi4_burst_wr_0_M00_AXI_RVALID),
        .m00_axi_wdata(full_axi4_burst_wr_0_M00_AXI_WDATA),
        .m00_axi_wlast(full_axi4_burst_wr_0_M00_AXI_WLAST),
        .m00_axi_wready(full_axi4_burst_wr_0_M00_AXI_WREADY),
        .m00_axi_wstrb(full_axi4_burst_wr_0_M00_AXI_WSTRB),
        .m00_axi_wvalid(full_axi4_burst_wr_0_M00_AXI_WVALID),
        .result_packet_in(result_packet_in_1));
  design_2_rst_ps8_0_100M_0 rst_ps8_0_100M
       (.aux_reset_in(1'b1),
        .dcm_locked(1'b1),
        .ext_reset_in(zynq_ultra_ps_e_0_pl_resetn0),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(rst_ps8_0_100M_peripheral_aresetn),
        .slowest_sync_clk(zynq_ultra_ps_e_0_pl_clk0));
  design_2_zynq_ultra_ps_e_0_0 zynq_ultra_ps_e_0
       (.pl_clk0(zynq_ultra_ps_e_0_pl_clk0),
        .pl_ps_irq0(pl_ps_ext_intr_1),
        .pl_resetn0(zynq_ultra_ps_e_0_pl_resetn0),
        .saxigp2_araddr(axi_smc_M00_AXI_ARADDR),
        .saxigp2_arburst(axi_smc_M00_AXI_ARBURST),
        .saxigp2_arcache(axi_smc_M00_AXI_ARCACHE),
        .saxigp2_arid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp2_arlen(axi_smc_M00_AXI_ARLEN),
        .saxigp2_arlock(axi_smc_M00_AXI_ARLOCK),
        .saxigp2_arprot(axi_smc_M00_AXI_ARPROT),
        .saxigp2_arqos(axi_smc_M00_AXI_ARQOS),
        .saxigp2_arready(axi_smc_M00_AXI_ARREADY),
        .saxigp2_arsize(axi_smc_M00_AXI_ARSIZE),
        .saxigp2_aruser(axi_smc_M00_AXI_ARUSER),
        .saxigp2_arvalid(axi_smc_M00_AXI_ARVALID),
        .saxigp2_awaddr(axi_smc_M00_AXI_AWADDR),
        .saxigp2_awburst(axi_smc_M00_AXI_AWBURST),
        .saxigp2_awcache(axi_smc_M00_AXI_AWCACHE),
        .saxigp2_awid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .saxigp2_awlen(axi_smc_M00_AXI_AWLEN),
        .saxigp2_awlock(axi_smc_M00_AXI_AWLOCK),
        .saxigp2_awprot(axi_smc_M00_AXI_AWPROT),
        .saxigp2_awqos(axi_smc_M00_AXI_AWQOS),
        .saxigp2_awready(axi_smc_M00_AXI_AWREADY),
        .saxigp2_awsize(axi_smc_M00_AXI_AWSIZE),
        .saxigp2_awuser(axi_smc_M00_AXI_AWUSER),
        .saxigp2_awvalid(axi_smc_M00_AXI_AWVALID),
        .saxigp2_bready(axi_smc_M00_AXI_BREADY),
        .saxigp2_bresp(axi_smc_M00_AXI_BRESP),
        .saxigp2_bvalid(axi_smc_M00_AXI_BVALID),
        .saxigp2_rdata(axi_smc_M00_AXI_RDATA),
        .saxigp2_rlast(axi_smc_M00_AXI_RLAST),
        .saxigp2_rready(axi_smc_M00_AXI_RREADY),
        .saxigp2_rresp(axi_smc_M00_AXI_RRESP),
        .saxigp2_rvalid(axi_smc_M00_AXI_RVALID),
        .saxigp2_wdata(axi_smc_M00_AXI_WDATA),
        .saxigp2_wlast(axi_smc_M00_AXI_WLAST),
        .saxigp2_wready(axi_smc_M00_AXI_WREADY),
        .saxigp2_wstrb(axi_smc_M00_AXI_WSTRB),
        .saxigp2_wvalid(axi_smc_M00_AXI_WVALID),
        .saxihp0_fpd_aclk(zynq_ultra_ps_e_0_pl_clk0));
endmodule
