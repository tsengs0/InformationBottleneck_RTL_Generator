//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Tue Mar 16 18:36:12 2021
//Host        : lmpcc-16 running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target sync_clock_domain.bd
//Design      : sync_clock_domain
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "sync_clock_domain,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=sync_clock_domain,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "sync_clock_domain.hwdef" *) 
module sync_clock_domain
   (clk_100MHz,
    clk_150MHz,
    clk_200MHz,
    clk_300MHz,
    clk_50MHz,
    clk_in1_0,
    locked_0,
    reset_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_100MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_100MHZ, CLK_DOMAIN sync_clock_domain_clk_wiz_0_0_clk_out1, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.0" *) output clk_100MHz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_150MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_150MHZ, CLK_DOMAIN sync_clock_domain_clk_wiz_0_0_clk_out1, FREQ_HZ 150000000, INSERT_VIP 0, PHASE 0.0" *) output clk_150MHz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_200MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_200MHZ, CLK_DOMAIN sync_clock_domain_clk_wiz_0_0_clk_out1, FREQ_HZ 200000000, INSERT_VIP 0, PHASE 0.0" *) output clk_200MHz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_300MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_300MHZ, CLK_DOMAIN sync_clock_domain_clk_wiz_0_0_clk_out1, FREQ_HZ 300000000, INSERT_VIP 0, PHASE 0.0" *) output clk_300MHz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_50MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_50MHZ, CLK_DOMAIN sync_clock_domain_clk_wiz_0_0_clk_out1, FREQ_HZ 50000000, INSERT_VIP 0, PHASE 0.0" *) output clk_50MHz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_IN1_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_IN1_0, CLK_DOMAIN sync_clock_domain_clk_in1_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input clk_in1_0;
  output locked_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_0, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input reset_0;

  wire clk_in1_0_1;
  wire clk_wiz_0_clk_out1;
  wire clk_wiz_0_clk_out2;
  wire clk_wiz_0_clk_out3;
  wire clk_wiz_0_clk_out4;
  wire clk_wiz_0_clk_out5;
  wire clk_wiz_0_locked;
  wire reset_0_1;

  assign clk_100MHz = clk_wiz_0_clk_out2;
  assign clk_150MHz = clk_wiz_0_clk_out3;
  assign clk_200MHz = clk_wiz_0_clk_out4;
  assign clk_300MHz = clk_wiz_0_clk_out5;
  assign clk_50MHz = clk_wiz_0_clk_out1;
  assign clk_in1_0_1 = clk_in1_0;
  assign locked_0 = clk_wiz_0_locked;
  assign reset_0_1 = reset_0;
  sync_clock_domain_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clk_in1_0_1),
        .clk_out1(clk_wiz_0_clk_out1),
        .clk_out2(clk_wiz_0_clk_out2),
        .clk_out3(clk_wiz_0_clk_out3),
        .clk_out4(clk_wiz_0_clk_out4),
        .clk_out5(clk_wiz_0_clk_out5),
        .locked(clk_wiz_0_locked),
        .reset(reset_0_1));
endmodule
