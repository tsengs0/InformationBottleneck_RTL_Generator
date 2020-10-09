//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Fri Oct  9 18:36:45 2020
//Host        : lmpcc running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target memory_system.bd
//Design      : memory_system
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "memory_system,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=memory_system,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=14,numReposBlks=14,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "memory_system.hwdef" *) 
module memory_system
   (cn_iter0_m0_portA_addr,
    cn_iter0_m0_portA_clk,
    cn_iter0_m0_portA_dout,
    cn_iter0_m0_portB_addr,
    cn_iter0_m0_portB_clk,
    cn_iter0_m0_portB_dout,
    cn_iter0_m1_portA_addr,
    cn_iter0_m1_portA_clk,
    cn_iter0_m1_portA_dout,
    cn_iter0_m1_portB_addr,
    cn_iter0_m1_portB_clk,
    cn_iter0_m1_portB_dout,
    cn_iter0_m2_portA_addr,
    cn_iter0_m2_portA_clk,
    cn_iter0_m2_portA_dout,
    cn_iter0_m2_portB_addr,
    cn_iter0_m2_portB_clk,
    cn_iter0_m2_portB_dout,
    cn_iter0_m3_portA_addr,
    cn_iter0_m3_portA_clk,
    cn_iter0_m3_portA_dout,
    cn_iter0_m3_portB_addr,
    cn_iter0_m3_portB_clk,
    cn_iter0_m3_portB_dout,
    cn_iter1_m0_portA_addr,
    cn_iter1_m0_portA_clk,
    cn_iter1_m0_portA_dout,
    cn_iter1_m0_portB_addr,
    cn_iter1_m0_portB_clk,
    cn_iter1_m0_portB_dout,
    cn_iter1_m1_portA_addr,
    cn_iter1_m1_portA_clk,
    cn_iter1_m1_portA_dout,
    cn_iter1_m1_portB_addr,
    cn_iter1_m1_portB_clk,
    cn_iter1_m1_portB_dout,
    cn_iter1_m2_portA_addr,
    cn_iter1_m2_portA_clk,
    cn_iter1_m2_portA_dout,
    cn_iter1_m2_portB_addr,
    cn_iter1_m2_portB_clk,
    cn_iter1_m2_portB_dout,
    cn_iter1_m3_portA_addr,
    cn_iter1_m3_portA_clk,
    cn_iter1_m3_portA_dout,
    cn_iter1_m3_portB_addr,
    cn_iter1_m3_portB_clk,
    cn_iter1_m3_portB_dout,
    dn_iter0_portA_addr,
    dn_iter0_portA_clk,
    dn_iter0_portA_dout,
    dn_iter0_portB_addr,
    dn_iter0_portB_clk,
    dn_iter0_portB_dout,
    dn_iter1_portA_addr,
    dn_iter1_portA_clk,
    dn_iter1_portA_dout,
    dn_iter1_portB_addr,
    dn_iter1_portB_clk,
    dn_iter1_portB_dout,
    vn_iter0_m0_portA_addr,
    vn_iter0_m0_portA_clk,
    vn_iter0_m0_portA_dout,
    vn_iter0_m0_portB_addr,
    vn_iter0_m0_portB_clk,
    vn_iter0_m0_portB_dout,
    vn_iter0_m1_portA_addr,
    vn_iter0_m1_portA_clk,
    vn_iter0_m1_portA_dout,
    vn_iter0_m1_portB_addr,
    vn_iter0_m1_portB_clk,
    vn_iter0_m1_portB_dout,
    vn_iter1_m0_portA_addr,
    vn_iter1_m0_portA_clk,
    vn_iter1_m0_portA_dout,
    vn_iter1_m0_portB_addr,
    vn_iter1_m0_portB_clk,
    vn_iter1_m0_portB_dout,
    vn_iter1_m1_portA_addr,
    vn_iter1_m1_portA_clk,
    vn_iter1_m1_portA_dout,
    vn_iter1_m1_portB_addr,
    vn_iter1_m1_portB_clk,
    vn_iter1_m1_portB_dout);
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m0_portA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter0_m0_portA, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1" *) input [9:0]cn_iter0_m0_portA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m0_portA CLK" *) input cn_iter0_m0_portA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m0_portA DOUT" *) output [5:0]cn_iter0_m0_portA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m0_portB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter0_m0_portB, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1" *) input [9:0]cn_iter0_m0_portB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m0_portB CLK" *) input cn_iter0_m0_portB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m0_portB DOUT" *) output [5:0]cn_iter0_m0_portB_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m1_portA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter0_m1_portA, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1" *) input [9:0]cn_iter0_m1_portA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m1_portA CLK" *) input cn_iter0_m1_portA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m1_portA DOUT" *) output [5:0]cn_iter0_m1_portA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m1_portB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter0_m1_portB, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1" *) input [9:0]cn_iter0_m1_portB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m1_portB CLK" *) input cn_iter0_m1_portB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m1_portB DOUT" *) output [5:0]cn_iter0_m1_portB_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m2_portA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter0_m2_portA, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1" *) input [9:0]cn_iter0_m2_portA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m2_portA CLK" *) input cn_iter0_m2_portA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m2_portA DOUT" *) output [5:0]cn_iter0_m2_portA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m2_portB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter0_m2_portB, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1" *) input [9:0]cn_iter0_m2_portB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m2_portB CLK" *) input cn_iter0_m2_portB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m2_portB DOUT" *) output [5:0]cn_iter0_m2_portB_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m3_portA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter0_m3_portA, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1" *) input [9:0]cn_iter0_m3_portA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m3_portA CLK" *) input cn_iter0_m3_portA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m3_portA DOUT" *) output [5:0]cn_iter0_m3_portA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m3_portB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter0_m3_portB, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1" *) input [9:0]cn_iter0_m3_portB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m3_portB CLK" *) input cn_iter0_m3_portB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter0_m3_portB DOUT" *) output [5:0]cn_iter0_m3_portB_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m0_portA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter1_m0_portA, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [9:0]cn_iter1_m0_portA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m0_portA CLK" *) input cn_iter1_m0_portA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m0_portA DOUT" *) output [5:0]cn_iter1_m0_portA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m0_portB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter1_m0_portB, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [9:0]cn_iter1_m0_portB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m0_portB CLK" *) input cn_iter1_m0_portB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m0_portB DOUT" *) output [5:0]cn_iter1_m0_portB_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m1_portA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter1_m1_portA, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [9:0]cn_iter1_m1_portA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m1_portA CLK" *) input cn_iter1_m1_portA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m1_portA DOUT" *) output [5:0]cn_iter1_m1_portA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m1_portB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter1_m1_portB, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [9:0]cn_iter1_m1_portB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m1_portB CLK" *) input cn_iter1_m1_portB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m1_portB DOUT" *) output [5:0]cn_iter1_m1_portB_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m2_portA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter1_m2_portA, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [9:0]cn_iter1_m2_portA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m2_portA CLK" *) input cn_iter1_m2_portA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m2_portA DOUT" *) output [5:0]cn_iter1_m2_portA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m2_portB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter1_m2_portB, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [9:0]cn_iter1_m2_portB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m2_portB CLK" *) input cn_iter1_m2_portB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m2_portB DOUT" *) output [5:0]cn_iter1_m2_portB_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m3_portA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter1_m3_portA, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [9:0]cn_iter1_m3_portA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m3_portA CLK" *) input cn_iter1_m3_portA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m3_portA DOUT" *) output [5:0]cn_iter1_m3_portA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m3_portB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME cn_iter1_m3_portB, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [9:0]cn_iter1_m3_portB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m3_portB CLK" *) input cn_iter1_m3_portB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 cn_iter1_m3_portB DOUT" *) output [5:0]cn_iter1_m3_portB_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 dn_iter0_portA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME dn_iter0_portA, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [10:0]dn_iter0_portA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 dn_iter0_portA CLK" *) input dn_iter0_portA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 dn_iter0_portA DOUT" *) output [1:0]dn_iter0_portA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 dn_iter0_portB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME dn_iter0_portB, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [10:0]dn_iter0_portB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 dn_iter0_portB CLK" *) input dn_iter0_portB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 dn_iter0_portB DOUT" *) output [1:0]dn_iter0_portB_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 dn_iter1_portA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME dn_iter1_portA, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [10:0]dn_iter1_portA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 dn_iter1_portA CLK" *) input dn_iter1_portA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 dn_iter1_portA DOUT" *) output [1:0]dn_iter1_portA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 dn_iter1_portB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME dn_iter1_portB, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [10:0]dn_iter1_portB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 dn_iter1_portB CLK" *) input dn_iter1_portB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 dn_iter1_portB DOUT" *) output [1:0]dn_iter1_portB_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter0_m0_portA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vn_iter0_m0_portA, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [10:0]vn_iter0_m0_portA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter0_m0_portA CLK" *) input vn_iter0_m0_portA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter0_m0_portA DOUT" *) output [7:0]vn_iter0_m0_portA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter0_m0_portB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vn_iter0_m0_portB, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [10:0]vn_iter0_m0_portB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter0_m0_portB CLK" *) input vn_iter0_m0_portB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter0_m0_portB DOUT" *) output [7:0]vn_iter0_m0_portB_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter0_m1_portA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vn_iter0_m1_portA, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [10:0]vn_iter0_m1_portA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter0_m1_portA CLK" *) input vn_iter0_m1_portA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter0_m1_portA DOUT" *) output [7:0]vn_iter0_m1_portA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter0_m1_portB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vn_iter0_m1_portB, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [10:0]vn_iter0_m1_portB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter0_m1_portB CLK" *) input vn_iter0_m1_portB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter0_m1_portB DOUT" *) output [7:0]vn_iter0_m1_portB_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter1_m0_portA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vn_iter1_m0_portA, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [10:0]vn_iter1_m0_portA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter1_m0_portA CLK" *) input vn_iter1_m0_portA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter1_m0_portA DOUT" *) output [7:0]vn_iter1_m0_portA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter1_m0_portB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vn_iter1_m0_portB, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [10:0]vn_iter1_m0_portB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter1_m0_portB CLK" *) input vn_iter1_m0_portB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter1_m0_portB DOUT" *) output [7:0]vn_iter1_m0_portB_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter1_m1_portA ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vn_iter1_m1_portA, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [10:0]vn_iter1_m1_portA_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter1_m1_portA CLK" *) input vn_iter1_m1_portA_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter1_m1_portA DOUT" *) output [7:0]vn_iter1_m1_portA_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter1_m1_portB ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME vn_iter1_m1_portB, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1, READ_WRITE_MODE READ_ONLY" *) input [10:0]vn_iter1_m1_portB_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter1_m1_portB CLK" *) input vn_iter1_m1_portB_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 vn_iter1_m1_portB DOUT" *) output [7:0]vn_iter1_m1_portB_dout;

  wire [9:0]BRAM_PORTA_0_1_ADDR;
  wire BRAM_PORTA_0_1_CLK;
  wire [5:0]BRAM_PORTA_0_1_DOUT;
  wire [10:0]BRAM_PORTA_0_2_ADDR;
  wire BRAM_PORTA_0_2_CLK;
  wire [1:0]BRAM_PORTA_0_2_DOUT;
  wire [9:0]BRAM_PORTA_1_1_ADDR;
  wire BRAM_PORTA_1_1_CLK;
  wire [5:0]BRAM_PORTA_1_1_DOUT;
  wire [10:0]BRAM_PORTA_1_2_ADDR;
  wire BRAM_PORTA_1_2_CLK;
  wire [1:0]BRAM_PORTA_1_2_DOUT;
  wire [9:0]BRAM_PORTA_2_1_ADDR;
  wire BRAM_PORTA_2_1_CLK;
  wire [5:0]BRAM_PORTA_2_1_DOUT;
  wire [10:0]BRAM_PORTA_2_2_ADDR;
  wire BRAM_PORTA_2_2_CLK;
  wire [7:0]BRAM_PORTA_2_2_DOUT;
  wire [9:0]BRAM_PORTA_3_1_ADDR;
  wire BRAM_PORTA_3_1_CLK;
  wire [5:0]BRAM_PORTA_3_1_DOUT;
  wire [10:0]BRAM_PORTA_3_2_ADDR;
  wire BRAM_PORTA_3_2_CLK;
  wire [7:0]BRAM_PORTA_3_2_DOUT;
  wire [9:0]BRAM_PORTA_4_1_ADDR;
  wire BRAM_PORTA_4_1_CLK;
  wire [5:0]BRAM_PORTA_4_1_DOUT;
  wire [10:0]BRAM_PORTA_4_2_ADDR;
  wire BRAM_PORTA_4_2_CLK;
  wire [7:0]BRAM_PORTA_4_2_DOUT;
  wire [9:0]BRAM_PORTA_5_1_ADDR;
  wire BRAM_PORTA_5_1_CLK;
  wire [5:0]BRAM_PORTA_5_1_DOUT;
  wire [10:0]BRAM_PORTA_5_2_ADDR;
  wire BRAM_PORTA_5_2_CLK;
  wire [7:0]BRAM_PORTA_5_2_DOUT;
  wire [9:0]BRAM_PORTA_6_1_ADDR;
  wire BRAM_PORTA_6_1_CLK;
  wire [5:0]BRAM_PORTA_6_1_DOUT;
  wire [9:0]BRAM_PORTA_7_1_ADDR;
  wire BRAM_PORTA_7_1_CLK;
  wire [5:0]BRAM_PORTA_7_1_DOUT;
  wire [9:0]BRAM_PORTB_0_1_ADDR;
  wire BRAM_PORTB_0_1_CLK;
  wire [5:0]BRAM_PORTB_0_1_DOUT;
  wire [10:0]BRAM_PORTB_0_2_ADDR;
  wire BRAM_PORTB_0_2_CLK;
  wire [1:0]BRAM_PORTB_0_2_DOUT;
  wire [9:0]BRAM_PORTB_1_1_ADDR;
  wire BRAM_PORTB_1_1_CLK;
  wire [5:0]BRAM_PORTB_1_1_DOUT;
  wire [10:0]BRAM_PORTB_1_2_ADDR;
  wire BRAM_PORTB_1_2_CLK;
  wire [1:0]BRAM_PORTB_1_2_DOUT;
  wire [9:0]BRAM_PORTB_2_1_ADDR;
  wire BRAM_PORTB_2_1_CLK;
  wire [5:0]BRAM_PORTB_2_1_DOUT;
  wire [10:0]BRAM_PORTB_2_2_ADDR;
  wire BRAM_PORTB_2_2_CLK;
  wire [7:0]BRAM_PORTB_2_2_DOUT;
  wire [9:0]BRAM_PORTB_3_1_ADDR;
  wire BRAM_PORTB_3_1_CLK;
  wire [5:0]BRAM_PORTB_3_1_DOUT;
  wire [10:0]BRAM_PORTB_3_2_ADDR;
  wire BRAM_PORTB_3_2_CLK;
  wire [7:0]BRAM_PORTB_3_2_DOUT;
  wire [9:0]BRAM_PORTB_4_1_ADDR;
  wire BRAM_PORTB_4_1_CLK;
  wire [5:0]BRAM_PORTB_4_1_DOUT;
  wire [10:0]BRAM_PORTB_4_2_ADDR;
  wire BRAM_PORTB_4_2_CLK;
  wire [7:0]BRAM_PORTB_4_2_DOUT;
  wire [9:0]BRAM_PORTB_5_1_ADDR;
  wire BRAM_PORTB_5_1_CLK;
  wire [5:0]BRAM_PORTB_5_1_DOUT;
  wire [10:0]BRAM_PORTB_5_2_ADDR;
  wire BRAM_PORTB_5_2_CLK;
  wire [7:0]BRAM_PORTB_5_2_DOUT;
  wire [9:0]BRAM_PORTB_6_1_ADDR;
  wire BRAM_PORTB_6_1_CLK;
  wire [5:0]BRAM_PORTB_6_1_DOUT;
  wire [9:0]BRAM_PORTB_7_1_ADDR;
  wire BRAM_PORTB_7_1_CLK;
  wire [5:0]BRAM_PORTB_7_1_DOUT;

  assign BRAM_PORTA_0_1_ADDR = cn_iter0_m0_portA_addr[9:0];
  assign BRAM_PORTA_0_1_CLK = cn_iter0_m0_portA_clk;
  assign BRAM_PORTA_0_2_ADDR = dn_iter0_portA_addr[10:0];
  assign BRAM_PORTA_0_2_CLK = dn_iter0_portA_clk;
  assign BRAM_PORTA_1_1_ADDR = cn_iter0_m1_portA_addr[9:0];
  assign BRAM_PORTA_1_1_CLK = cn_iter0_m1_portA_clk;
  assign BRAM_PORTA_1_2_ADDR = dn_iter1_portA_addr[10:0];
  assign BRAM_PORTA_1_2_CLK = dn_iter1_portA_clk;
  assign BRAM_PORTA_2_1_ADDR = cn_iter0_m2_portA_addr[9:0];
  assign BRAM_PORTA_2_1_CLK = cn_iter0_m2_portA_clk;
  assign BRAM_PORTA_2_2_ADDR = vn_iter0_m0_portA_addr[10:0];
  assign BRAM_PORTA_2_2_CLK = vn_iter0_m0_portA_clk;
  assign BRAM_PORTA_3_1_ADDR = cn_iter0_m3_portA_addr[9:0];
  assign BRAM_PORTA_3_1_CLK = cn_iter0_m3_portA_clk;
  assign BRAM_PORTA_3_2_ADDR = vn_iter0_m1_portA_addr[10:0];
  assign BRAM_PORTA_3_2_CLK = vn_iter0_m1_portA_clk;
  assign BRAM_PORTA_4_1_ADDR = cn_iter1_m0_portA_addr[9:0];
  assign BRAM_PORTA_4_1_CLK = cn_iter1_m0_portA_clk;
  assign BRAM_PORTA_4_2_ADDR = vn_iter1_m0_portA_addr[10:0];
  assign BRAM_PORTA_4_2_CLK = vn_iter1_m0_portA_clk;
  assign BRAM_PORTA_5_1_ADDR = cn_iter1_m1_portA_addr[9:0];
  assign BRAM_PORTA_5_1_CLK = cn_iter1_m1_portA_clk;
  assign BRAM_PORTA_5_2_ADDR = vn_iter1_m1_portA_addr[10:0];
  assign BRAM_PORTA_5_2_CLK = vn_iter1_m1_portA_clk;
  assign BRAM_PORTA_6_1_ADDR = cn_iter1_m2_portA_addr[9:0];
  assign BRAM_PORTA_6_1_CLK = cn_iter1_m2_portA_clk;
  assign BRAM_PORTA_7_1_ADDR = cn_iter1_m3_portA_addr[9:0];
  assign BRAM_PORTA_7_1_CLK = cn_iter1_m3_portA_clk;
  assign BRAM_PORTB_0_1_ADDR = cn_iter0_m0_portB_addr[9:0];
  assign BRAM_PORTB_0_1_CLK = cn_iter0_m0_portB_clk;
  assign BRAM_PORTB_0_2_ADDR = dn_iter0_portB_addr[10:0];
  assign BRAM_PORTB_0_2_CLK = dn_iter0_portB_clk;
  assign BRAM_PORTB_1_1_ADDR = cn_iter0_m1_portB_addr[9:0];
  assign BRAM_PORTB_1_1_CLK = cn_iter0_m1_portB_clk;
  assign BRAM_PORTB_1_2_ADDR = dn_iter1_portB_addr[10:0];
  assign BRAM_PORTB_1_2_CLK = dn_iter1_portB_clk;
  assign BRAM_PORTB_2_1_ADDR = cn_iter0_m2_portB_addr[9:0];
  assign BRAM_PORTB_2_1_CLK = cn_iter0_m2_portB_clk;
  assign BRAM_PORTB_2_2_ADDR = vn_iter0_m0_portB_addr[10:0];
  assign BRAM_PORTB_2_2_CLK = vn_iter0_m0_portB_clk;
  assign BRAM_PORTB_3_1_ADDR = cn_iter0_m3_portB_addr[9:0];
  assign BRAM_PORTB_3_1_CLK = cn_iter0_m3_portB_clk;
  assign BRAM_PORTB_3_2_ADDR = vn_iter0_m1_portB_addr[10:0];
  assign BRAM_PORTB_3_2_CLK = vn_iter0_m1_portB_clk;
  assign BRAM_PORTB_4_1_ADDR = cn_iter1_m0_portB_addr[9:0];
  assign BRAM_PORTB_4_1_CLK = cn_iter1_m0_portB_clk;
  assign BRAM_PORTB_4_2_ADDR = vn_iter1_m0_portB_addr[10:0];
  assign BRAM_PORTB_4_2_CLK = vn_iter1_m0_portB_clk;
  assign BRAM_PORTB_5_1_ADDR = cn_iter1_m1_portB_addr[9:0];
  assign BRAM_PORTB_5_1_CLK = cn_iter1_m1_portB_clk;
  assign BRAM_PORTB_5_2_ADDR = vn_iter1_m1_portB_addr[10:0];
  assign BRAM_PORTB_5_2_CLK = vn_iter1_m1_portB_clk;
  assign BRAM_PORTB_6_1_ADDR = cn_iter1_m2_portB_addr[9:0];
  assign BRAM_PORTB_6_1_CLK = cn_iter1_m2_portB_clk;
  assign BRAM_PORTB_7_1_ADDR = cn_iter1_m3_portB_addr[9:0];
  assign BRAM_PORTB_7_1_CLK = cn_iter1_m3_portB_clk;
  assign cn_iter0_m0_portA_dout[5:0] = BRAM_PORTA_0_1_DOUT;
  assign cn_iter0_m0_portB_dout[5:0] = BRAM_PORTB_0_1_DOUT;
  assign cn_iter0_m1_portA_dout[5:0] = BRAM_PORTA_1_1_DOUT;
  assign cn_iter0_m1_portB_dout[5:0] = BRAM_PORTB_1_1_DOUT;
  assign cn_iter0_m2_portA_dout[5:0] = BRAM_PORTA_2_1_DOUT;
  assign cn_iter0_m2_portB_dout[5:0] = BRAM_PORTB_2_1_DOUT;
  assign cn_iter0_m3_portA_dout[5:0] = BRAM_PORTA_3_1_DOUT;
  assign cn_iter0_m3_portB_dout[5:0] = BRAM_PORTB_3_1_DOUT;
  assign cn_iter1_m0_portA_dout[5:0] = BRAM_PORTA_4_1_DOUT;
  assign cn_iter1_m0_portB_dout[5:0] = BRAM_PORTB_4_1_DOUT;
  assign cn_iter1_m1_portA_dout[5:0] = BRAM_PORTA_5_1_DOUT;
  assign cn_iter1_m1_portB_dout[5:0] = BRAM_PORTB_5_1_DOUT;
  assign cn_iter1_m2_portA_dout[5:0] = BRAM_PORTA_6_1_DOUT;
  assign cn_iter1_m2_portB_dout[5:0] = BRAM_PORTB_6_1_DOUT;
  assign cn_iter1_m3_portA_dout[5:0] = BRAM_PORTA_7_1_DOUT;
  assign cn_iter1_m3_portB_dout[5:0] = BRAM_PORTB_7_1_DOUT;
  assign dn_iter0_portA_dout[1:0] = BRAM_PORTA_0_2_DOUT;
  assign dn_iter0_portB_dout[1:0] = BRAM_PORTB_0_2_DOUT;
  assign dn_iter1_portA_dout[1:0] = BRAM_PORTA_1_2_DOUT;
  assign dn_iter1_portB_dout[1:0] = BRAM_PORTB_1_2_DOUT;
  assign vn_iter0_m0_portA_dout[7:0] = BRAM_PORTA_2_2_DOUT;
  assign vn_iter0_m0_portB_dout[7:0] = BRAM_PORTB_2_2_DOUT;
  assign vn_iter0_m1_portA_dout[7:0] = BRAM_PORTA_3_2_DOUT;
  assign vn_iter0_m1_portB_dout[7:0] = BRAM_PORTB_3_2_DOUT;
  assign vn_iter1_m0_portA_dout[7:0] = BRAM_PORTA_4_2_DOUT;
  assign vn_iter1_m0_portB_dout[7:0] = BRAM_PORTB_4_2_DOUT;
  assign vn_iter1_m1_portA_dout[7:0] = BRAM_PORTA_5_2_DOUT;
  assign vn_iter1_m1_portB_dout[7:0] = BRAM_PORTB_5_2_DOUT;
  memory_system_blk_mem_gen_0_0 cn_iter0_24_func0
       (.addra(BRAM_PORTA_0_1_ADDR),
        .addrb(BRAM_PORTB_0_1_ADDR),
        .clka(BRAM_PORTA_0_1_CLK),
        .clkb(BRAM_PORTB_0_1_CLK),
        .douta(BRAM_PORTA_0_1_DOUT),
        .doutb(BRAM_PORTB_0_1_DOUT));
  memory_system_cn_iter0_24_func0_0 cn_iter0_24_func1
       (.addra(BRAM_PORTA_1_1_ADDR),
        .addrb(BRAM_PORTB_1_1_ADDR),
        .clka(BRAM_PORTA_1_1_CLK),
        .clkb(BRAM_PORTB_1_1_CLK),
        .douta(BRAM_PORTA_1_1_DOUT),
        .doutb(BRAM_PORTB_1_1_DOUT));
  memory_system_cn_iter0_24_func1_0 cn_iter0_24_func2
       (.addra(BRAM_PORTA_2_1_ADDR),
        .addrb(BRAM_PORTB_2_1_ADDR),
        .clka(BRAM_PORTA_2_1_CLK),
        .clkb(BRAM_PORTB_2_1_CLK),
        .douta(BRAM_PORTA_2_1_DOUT),
        .doutb(BRAM_PORTB_2_1_DOUT));
  memory_system_cn_iter0_24_func1_1 cn_iter0_24_func3
       (.addra(BRAM_PORTA_3_1_ADDR),
        .addrb(BRAM_PORTB_3_1_ADDR),
        .clka(BRAM_PORTA_3_1_CLK),
        .clkb(BRAM_PORTB_3_1_CLK),
        .douta(BRAM_PORTA_3_1_DOUT),
        .doutb(BRAM_PORTB_3_1_DOUT));
  memory_system_cn_iter0_24_func0_1 cn_iter25_49_func0
       (.addra(BRAM_PORTA_4_1_ADDR),
        .addrb(BRAM_PORTB_4_1_ADDR),
        .clka(BRAM_PORTA_4_1_CLK),
        .clkb(BRAM_PORTB_4_1_CLK),
        .douta(BRAM_PORTA_4_1_DOUT),
        .doutb(BRAM_PORTB_4_1_DOUT));
  memory_system_cn_iter0_24_func1_2 cn_iter25_49_func1
       (.addra(BRAM_PORTA_5_1_ADDR),
        .addrb(BRAM_PORTB_5_1_ADDR),
        .clka(BRAM_PORTA_5_1_CLK),
        .clkb(BRAM_PORTB_5_1_CLK),
        .douta(BRAM_PORTA_5_1_DOUT),
        .doutb(BRAM_PORTB_5_1_DOUT));
  memory_system_cn_iter0_24_func3_0 cn_iter25_49_func2
       (.addra(BRAM_PORTA_6_1_ADDR),
        .addrb(BRAM_PORTB_6_1_ADDR),
        .clka(BRAM_PORTA_6_1_CLK),
        .clkb(BRAM_PORTB_6_1_CLK),
        .douta(BRAM_PORTA_6_1_DOUT),
        .doutb(BRAM_PORTB_6_1_DOUT));
  memory_system_cn_iter0_24_func2_0 cn_iter25_49_func3
       (.addra(BRAM_PORTA_7_1_ADDR),
        .addrb(BRAM_PORTB_7_1_ADDR),
        .clka(BRAM_PORTA_7_1_CLK),
        .clkb(BRAM_PORTB_7_1_CLK),
        .douta(BRAM_PORTA_7_1_DOUT),
        .doutb(BRAM_PORTB_7_1_DOUT));
  memory_system_vn_iter0_24_func0_0 dn_iter0_24
       (.addra(BRAM_PORTA_0_2_ADDR),
        .addrb(BRAM_PORTB_0_2_ADDR),
        .clka(BRAM_PORTA_0_2_CLK),
        .clkb(BRAM_PORTB_0_2_CLK),
        .douta(BRAM_PORTA_0_2_DOUT),
        .doutb(BRAM_PORTB_0_2_DOUT));
  memory_system_vn_iter25_49_func0_1 dn_iter25_49
       (.addra(BRAM_PORTA_1_2_ADDR),
        .addrb(BRAM_PORTB_1_2_ADDR),
        .clka(BRAM_PORTA_1_2_CLK),
        .clkb(BRAM_PORTB_1_2_CLK),
        .douta(BRAM_PORTA_1_2_DOUT),
        .doutb(BRAM_PORTB_1_2_DOUT));
  memory_system_cn_iter0_24_func0_2 vn_iter0_24_func0
       (.addra(BRAM_PORTA_2_2_ADDR),
        .addrb(BRAM_PORTB_2_2_ADDR),
        .clka(BRAM_PORTA_2_2_CLK),
        .clkb(BRAM_PORTB_2_2_CLK),
        .douta(BRAM_PORTA_2_2_DOUT),
        .doutb(BRAM_PORTB_2_2_DOUT));
  memory_system_cn_iter0_24_func1_3 vn_iter0_24_func1
       (.addra(BRAM_PORTA_3_2_ADDR),
        .addrb(BRAM_PORTB_3_2_ADDR),
        .clka(BRAM_PORTA_3_2_CLK),
        .clkb(BRAM_PORTB_3_2_CLK),
        .douta(BRAM_PORTA_3_2_DOUT),
        .doutb(BRAM_PORTB_3_2_DOUT));
  memory_system_cn_iter25_49_func0_0 vn_iter25_49_func0
       (.addra(BRAM_PORTA_4_2_ADDR),
        .addrb(BRAM_PORTB_4_2_ADDR),
        .clka(BRAM_PORTA_4_2_CLK),
        .clkb(BRAM_PORTB_4_2_CLK),
        .douta(BRAM_PORTA_4_2_DOUT),
        .doutb(BRAM_PORTB_4_2_DOUT));
  memory_system_vn_iter25_49_func0_0 vn_iter25_49_func1
       (.addra(BRAM_PORTA_5_2_ADDR),
        .addrb(BRAM_PORTB_5_2_ADDR),
        .clka(BRAM_PORTA_5_2_CLK),
        .clkb(BRAM_PORTB_5_2_CLK),
        .douta(BRAM_PORTA_5_2_DOUT),
        .doutb(BRAM_PORTB_5_2_DOUT));
endmodule
