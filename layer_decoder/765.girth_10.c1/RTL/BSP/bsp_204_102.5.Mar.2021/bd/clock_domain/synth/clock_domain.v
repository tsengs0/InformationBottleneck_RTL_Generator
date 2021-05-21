//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Fri Feb 19 22:14:12 2021
//Host        : lmpcc-21 running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target clock_domain.bd
//Design      : clock_domain
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "clock_domain,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=clock_domain,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_board_cnt=1,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "clock_domain.hwdef" *) 
module clock_domain
   (clk_100MHz,
    clk_150MHz,
    clk_200MHz,
    clk_300MHz,
    clk_300mhz_clk_n,
    clk_300mhz_clk_p,
    clk_50MHz,
    locked,
    reset_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_100MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_100MHZ, CLK_DOMAIN clock_domain_clk_wiz_0_0_clk_out1, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.0" *) output clk_100MHz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_150MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_150MHZ, CLK_DOMAIN clock_domain_clk_wiz_0_0_clk_out1, FREQ_HZ 150000000, INSERT_VIP 0, PHASE 0.0" *) output clk_150MHz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_200MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_200MHZ, CLK_DOMAIN clock_domain_clk_wiz_0_0_clk_out1, FREQ_HZ 200000000, INSERT_VIP 0, PHASE 0.0" *) output clk_200MHz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_300MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_300MHZ, CLK_DOMAIN clock_domain_clk_wiz_0_0_clk_out1, FREQ_HZ 300000000, INSERT_VIP 0, PHASE 0.0" *) output clk_300MHz;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 clk_300mhz CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk_300mhz, CAN_DEBUG false, FREQ_HZ 300000000" *) input clk_300mhz_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 clk_300mhz CLK_P" *) input clk_300mhz_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_50MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_50MHZ, CLK_DOMAIN clock_domain_clk_wiz_0_0_clk_out1, FREQ_HZ 50000000, INSERT_VIP 0, PHASE 0.0" *) output clk_50MHz;
  output locked;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_0, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input reset_0;

  wire clk_300mhz_1_CLK_N;
  wire clk_300mhz_1_CLK_P;
  wire clk_wiz_0_clk_out1;
  wire clk_wiz_0_clk_out2;
  wire clk_wiz_0_clk_out3;
  wire clk_wiz_0_clk_out4;
  wire clk_wiz_0_clk_out5;
  wire clk_wiz_0_locked;
  wire reset_0_1;

  assign clk_100MHz = clk_wiz_0_clk_out1;
  assign clk_150MHz = clk_wiz_0_clk_out5;
  assign clk_200MHz = clk_wiz_0_clk_out2;
  assign clk_300MHz = clk_wiz_0_clk_out3;
  assign clk_300mhz_1_CLK_N = clk_300mhz_clk_n;
  assign clk_300mhz_1_CLK_P = clk_300mhz_clk_p;
  assign clk_50MHz = clk_wiz_0_clk_out4;
  assign locked = clk_wiz_0_locked;
  assign reset_0_1 = reset_0;
  clock_domain_clk_wiz_0_0 clk_wiz_0
       (.clk_in1_n(clk_300mhz_1_CLK_N),
        .clk_in1_p(clk_300mhz_1_CLK_P),
        .clk_out1(clk_wiz_0_clk_out1),
        .clk_out2(clk_wiz_0_clk_out2),
        .clk_out3(clk_wiz_0_clk_out3),
        .clk_out4(clk_wiz_0_clk_out4),
        .clk_out5(clk_wiz_0_clk_out5),
        .locked(clk_wiz_0_locked),
        .reset(reset_0_1));
endmodule
