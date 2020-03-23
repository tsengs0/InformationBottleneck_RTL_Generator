// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Tue Mar 10 00:43:52 2020
// Host        : vpcc running 64-bit CentOS Linux release 7.4.1708 (Core)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_LUT/IB_LUT.sim/sim_1/impl/func/xsim/top_func_impl.v
// Design      : top
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* HW_HANDOFF = "IB_RAM.hwdef" *) 
module IB_RAM
   (BRAM_PORTA_0_addr,
    BRAM_PORTA_0_clk,
    BRAM_PORTA_0_din,
    BRAM_PORTA_0_dout,
    BRAM_PORTA_0_we,
    BRAM_PORTB_0_addr,
    BRAM_PORTB_0_clk,
    BRAM_PORTB_0_din,
    BRAM_PORTB_0_dout,
    BRAM_PORTB_0_we);
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTA_0, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1" *) input [6:0]BRAM_PORTA_0_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 CLK" *) input BRAM_PORTA_0_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 DIN" *) input [35:0]BRAM_PORTA_0_din;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 DOUT" *) output [35:0]BRAM_PORTA_0_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA_0 WE" *) input [0:0]BRAM_PORTA_0_we;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB_0 ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTB_0, MASTER_TYPE OTHER, MEM_ECC NONE, MEM_SIZE 8192, MEM_WIDTH 32, READ_LATENCY 1" *) input [6:0]BRAM_PORTB_0_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB_0 CLK" *) input BRAM_PORTB_0_clk;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB_0 DIN" *) input [35:0]BRAM_PORTB_0_din;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB_0 DOUT" *) output [35:0]BRAM_PORTB_0_dout;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB_0 WE" *) input [0:0]BRAM_PORTB_0_we;

  wire [6:0]BRAM_PORTA_0_addr;
  wire BRAM_PORTA_0_clk;
  wire [35:0]BRAM_PORTA_0_din;
  wire [35:0]BRAM_PORTA_0_dout;
  wire [0:0]BRAM_PORTA_0_we;
  wire [6:0]BRAM_PORTB_0_addr;
  wire [35:0]BRAM_PORTB_0_din;
  wire [35:0]BRAM_PORTB_0_dout;
  wire [0:0]BRAM_PORTB_0_we;
  wire NLW_blk_mem_gen_1_clkb_UNCONNECTED;

  (* IMPORTED_FROM = "/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_LUT/IB_LUT.srcs/sources_1/bd/IB_RAM/ip/IB_RAM_blk_mem_gen_1_0/IB_RAM_blk_mem_gen_1_0.dcp" *) 
  (* IMPORTED_TYPE = "CHECKPOINT" *) 
  (* IS_IMPORTED *) 
  (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *) 
  IB_RAM_blk_mem_gen_1_0 blk_mem_gen_1
       (.addra(BRAM_PORTA_0_addr),
        .addrb(BRAM_PORTB_0_addr),
        .clka(BRAM_PORTA_0_clk),
        .clkb(NLW_blk_mem_gen_1_clkb_UNCONNECTED),
        .dina(BRAM_PORTA_0_din),
        .dinb(BRAM_PORTB_0_din),
        .douta(BRAM_PORTA_0_dout),
        .doutb(BRAM_PORTB_0_dout),
        .wea(BRAM_PORTA_0_we),
        .web(BRAM_PORTB_0_we));
endmodule

(* CHECK_LICENSE_TYPE = "IB_RAM_blk_mem_gen_1_0,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *) 
module IB_RAM_blk_mem_gen_1_0
   (clka,
    wea,
    addra,
    dina,
    douta,
    clkb,
    web,
    addrb,
    dinb,
    doutb);
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1" *) input clka;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [6:0]addra;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [35:0]dina;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [35:0]douta;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_WRITE_MODE READ_WRITE, READ_LATENCY 1" *) input clkb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [6:0]addrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [35:0]dinb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [35:0]doutb;

  wire [6:0]addra;
  wire [6:0]addrb;
  wire clka;
  wire [35:0]dina;
  wire [35:0]dinb;
  wire [35:0]douta;
  wire [35:0]doutb;
  wire [0:0]wea;
  wire [0:0]web;
  wire NLW_U0_clkb_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_deepsleep_UNCONNECTED;
  wire NLW_U0_eccpipece_UNCONNECTED;
  wire NLW_U0_ena_UNCONNECTED;
  wire NLW_U0_enb_UNCONNECTED;
  wire NLW_U0_injectdbiterr_UNCONNECTED;
  wire NLW_U0_injectsbiterr_UNCONNECTED;
  wire NLW_U0_regcea_UNCONNECTED;
  wire NLW_U0_regceb_UNCONNECTED;
  wire NLW_U0_rsta_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_aclk_UNCONNECTED;
  wire NLW_U0_s_aresetn_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_arvalid_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_awvalid_UNCONNECTED;
  wire NLW_U0_s_axi_bready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_injectdbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_injectsbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rready_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wlast_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axi_wvalid_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_shutdown_UNCONNECTED;
  wire NLW_U0_sleep_UNCONNECTED;
  wire [6:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_arlen_UNCONNECTED;
  wire [2:0]NLW_U0_s_axi_arsize_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_awlen_UNCONNECTED;
  wire [2:0]NLW_U0_s_axi_awsize_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [6:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [35:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [35:0]NLW_U0_s_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_wstrb_UNCONNECTED;

  (* C_ADDRA_WIDTH = "7" *) 
  (* C_ADDRB_WIDTH = "7" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "1" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     5.40625 mW" *) 
  (* C_FAMILY = "kintex7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "NONE" *) 
  (* C_INIT_FILE_NAME = "IB_RAM_blk_mem_gen_1_0.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "114" *) 
  (* C_READ_DEPTH_B = "114" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "36" *) 
  (* C_READ_WIDTH_B = "36" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "114" *) 
  (* C_WRITE_DEPTH_B = "114" *) 
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "NO_CHANGE" *) 
  (* C_WRITE_WIDTH_A = "36" *) 
  (* C_WRITE_WIDTH_B = "36" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  IB_RAM_blk_mem_gen_1_0_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(NLW_U0_clkb_UNCONNECTED),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(NLW_U0_deepsleep_UNCONNECTED),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(NLW_U0_eccpipece_UNCONNECTED),
        .ena(NLW_U0_ena_UNCONNECTED),
        .enb(NLW_U0_enb_UNCONNECTED),
        .injectdbiterr(NLW_U0_injectdbiterr_UNCONNECTED),
        .injectsbiterr(NLW_U0_injectsbiterr_UNCONNECTED),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[6:0]),
        .regcea(NLW_U0_regcea_UNCONNECTED),
        .regceb(NLW_U0_regceb_UNCONNECTED),
        .rsta(NLW_U0_rsta_UNCONNECTED),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(NLW_U0_rstb_UNCONNECTED),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(NLW_U0_s_aclk_UNCONNECTED),
        .s_aresetn(NLW_U0_s_aresetn_UNCONNECTED),
        .s_axi_araddr(NLW_U0_s_axi_araddr_UNCONNECTED[31:0]),
        .s_axi_arburst(NLW_U0_s_axi_arburst_UNCONNECTED[1:0]),
        .s_axi_arid(NLW_U0_s_axi_arid_UNCONNECTED[3:0]),
        .s_axi_arlen(NLW_U0_s_axi_arlen_UNCONNECTED[7:0]),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize(NLW_U0_s_axi_arsize_UNCONNECTED[2:0]),
        .s_axi_arvalid(NLW_U0_s_axi_arvalid_UNCONNECTED),
        .s_axi_awaddr(NLW_U0_s_axi_awaddr_UNCONNECTED[31:0]),
        .s_axi_awburst(NLW_U0_s_axi_awburst_UNCONNECTED[1:0]),
        .s_axi_awid(NLW_U0_s_axi_awid_UNCONNECTED[3:0]),
        .s_axi_awlen(NLW_U0_s_axi_awlen_UNCONNECTED[7:0]),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize(NLW_U0_s_axi_awsize_UNCONNECTED[2:0]),
        .s_axi_awvalid(NLW_U0_s_axi_awvalid_UNCONNECTED),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(NLW_U0_s_axi_bready_UNCONNECTED),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(NLW_U0_s_axi_injectdbiterr_UNCONNECTED),
        .s_axi_injectsbiterr(NLW_U0_s_axi_injectsbiterr_UNCONNECTED),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[6:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[35:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(NLW_U0_s_axi_rready_UNCONNECTED),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata(NLW_U0_s_axi_wdata_UNCONNECTED[35:0]),
        .s_axi_wlast(NLW_U0_s_axi_wlast_UNCONNECTED),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(NLW_U0_s_axi_wstrb_UNCONNECTED[0]),
        .s_axi_wvalid(NLW_U0_s_axi_wvalid_UNCONNECTED),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(NLW_U0_shutdown_UNCONNECTED),
        .sleep(NLW_U0_sleep_UNCONNECTED),
        .wea(wea),
        .web(web));
endmodule

module IB_RAM_wrapper
   (BRAM_PORTA_0_dout,
    BRAM_PORTB_0_dout,
    BRAM_PORTB_0_addr,
    CLK);
  output [35:0]BRAM_PORTA_0_dout;
  output [35:0]BRAM_PORTB_0_dout;
  input [5:0]BRAM_PORTB_0_addr;
  input CLK;

  wire [35:0]BRAM_PORTA_0_dout;
  wire [5:0]BRAM_PORTB_0_addr;
  wire [35:0]BRAM_PORTB_0_dout;
  wire CLK;
  wire NLW_IB_RAM_i_BRAM_PORTB_0_clk_UNCONNECTED;

  (* HW_HANDOFF = "IB_RAM.hwdef" *) 
  IB_RAM IB_RAM_i
       (.BRAM_PORTA_0_addr({BRAM_PORTB_0_addr,1'b0}),
        .BRAM_PORTA_0_clk(CLK),
        .BRAM_PORTA_0_din({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BRAM_PORTA_0_dout(BRAM_PORTA_0_dout),
        .BRAM_PORTA_0_we(1'b0),
        .BRAM_PORTB_0_addr({BRAM_PORTB_0_addr,1'b1}),
        .BRAM_PORTB_0_clk(NLW_IB_RAM_i_BRAM_PORTB_0_clk_UNCONNECTED),
        .BRAM_PORTB_0_din({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BRAM_PORTB_0_dout(BRAM_PORTB_0_dout),
        .BRAM_PORTB_0_we(1'b0));
endmodule

module c6ibAddr_ram_sel
   (en_reg,
    SR,
    ADDRA,
    \page_addr_ram1_reg[4]_0 ,
    \page_addr_ram2_reg[4]_0 ,
    \page_addr_ram3_reg[4]_0 ,
    en_IBUF,
    clk_out1_0,
    ADDRD,
    RAM32M_inst_1,
    RAM32M_inst_1_0,
    RAM32M_inst_1_1,
    \page_addr_ram0_reg[4]_0 ,
    \page_addr_ram1_reg[4]_1 ,
    \page_addr_ram2_reg[4]_1 ,
    \page_addr_ram3_reg[4]_1 ,
    \page_addr_ram2_reg[4]_0[0]_repN_alias );
  output en_reg;
  output [0:0]SR;
  output [4:0]ADDRA;
  output [4:0]\page_addr_ram1_reg[4]_0 ;
  output [4:0]\page_addr_ram2_reg[4]_0 ;
  output [4:0]\page_addr_ram3_reg[4]_0 ;
  input en_IBUF;
  input clk_out1_0;
  input [4:0]ADDRD;
  input [4:0]RAM32M_inst_1;
  input [4:0]RAM32M_inst_1_0;
  input [4:0]RAM32M_inst_1_1;
  input [0:0]\page_addr_ram0_reg[4]_0 ;
  input [0:0]\page_addr_ram1_reg[4]_1 ;
  input [0:0]\page_addr_ram2_reg[4]_1 ;
  input [0:0]\page_addr_ram3_reg[4]_1 ;
  output \page_addr_ram2_reg[4]_0[0]_repN_alias ;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire [4:0]RAM32M_inst_1;
  wire [4:0]RAM32M_inst_1_0;
  wire [4:0]RAM32M_inst_1_1;
  wire [0:0]SR;
  wire clk_out1_0;
  wire [4:0]cnt;
  wire \cnt[0]_i_1__0_n_0 ;
  wire \cnt[1]_i_1_n_0 ;
  wire \cnt[2]_i_1_n_0 ;
  wire \cnt[3]_i_1__0_n_0 ;
  wire \cnt[4]_i_1_n_0 ;
  wire en_IBUF;
  wire en_reg;
  wire [4:0]page_addr_ram0;
  wire [0:0]\page_addr_ram0_reg[4]_0 ;
  wire [4:0]page_addr_ram1;
  wire [4:0]\page_addr_ram1_reg[4]_0 ;
  wire [0:0]\page_addr_ram1_reg[4]_1 ;
  wire [4:0]page_addr_ram2;
  wire [4:0]\page_addr_ram2_reg[4]_0 ;
  wire \page_addr_ram2_reg[4]_0[0]_repN ;
  wire [0:0]\page_addr_ram2_reg[4]_1 ;
  wire [4:0]page_addr_ram3;
  wire [4:0]\page_addr_ram3_reg[4]_0 ;
  wire [0:0]\page_addr_ram3_reg[4]_1 ;

  assign \page_addr_ram2_reg[4]_0[0]_repN_alias  = \page_addr_ram2_reg[4]_0[0]_repN ;
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_3
       (.I0(page_addr_ram0[4]),
        .I1(en_IBUF),
        .I2(ADDRD[4]),
        .O(ADDRA[4]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_3__0
       (.I0(page_addr_ram1[4]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1[4]),
        .O(\page_addr_ram1_reg[4]_0 [4]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_3__1
       (.I0(page_addr_ram2[4]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1_0[4]),
        .O(\page_addr_ram2_reg[4]_0 [4]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_3__2
       (.I0(page_addr_ram3[4]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1_1[4]),
        .O(\page_addr_ram3_reg[4]_0 [4]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_4
       (.I0(page_addr_ram0[3]),
        .I1(en_IBUF),
        .I2(ADDRD[3]),
        .O(ADDRA[3]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_4__0
       (.I0(page_addr_ram1[3]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1[3]),
        .O(\page_addr_ram1_reg[4]_0 [3]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_4__1
       (.I0(page_addr_ram2[3]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1_0[3]),
        .O(\page_addr_ram2_reg[4]_0 [3]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_4__2
       (.I0(page_addr_ram3[3]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1_1[3]),
        .O(\page_addr_ram3_reg[4]_0 [3]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_5
       (.I0(page_addr_ram0[2]),
        .I1(en_IBUF),
        .I2(ADDRD[2]),
        .O(ADDRA[2]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_5__0
       (.I0(page_addr_ram1[2]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1[2]),
        .O(\page_addr_ram1_reg[4]_0 [2]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_5__1
       (.I0(page_addr_ram2[2]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1_0[2]),
        .O(\page_addr_ram2_reg[4]_0 [2]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_5__2
       (.I0(page_addr_ram3[2]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1_1[2]),
        .O(\page_addr_ram3_reg[4]_0 [2]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_6
       (.I0(page_addr_ram0[1]),
        .I1(en_IBUF),
        .I2(ADDRD[1]),
        .O(ADDRA[1]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_6__0
       (.I0(page_addr_ram1[1]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1[1]),
        .O(\page_addr_ram1_reg[4]_0 [1]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_6__1
       (.I0(page_addr_ram2[1]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1_0[1]),
        .O(\page_addr_ram2_reg[4]_0 [1]));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_6__2
       (.I0(page_addr_ram3[1]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1_1[1]),
        .O(\page_addr_ram3_reg[4]_0 [1]));
  (* PHYS_OPT_MODIFIED = "FANOUT_OPT" *) 
  (* PHYS_OPT_SKIPPED = "FANOUT_OPT" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_7
       (.I0(page_addr_ram0[0]),
        .I1(en_IBUF),
        .I2(ADDRD[0]),
        .O(ADDRA[0]));
  (* PHYS_OPT_MODIFIED = "FANOUT_OPT" *) 
  (* PHYS_OPT_SKIPPED = "FANOUT_OPT" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_7__0
       (.I0(page_addr_ram1[0]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1[0]),
        .O(\page_addr_ram1_reg[4]_0 [0]));
  (* PHYS_OPT_MODIFIED = "CRITICAL_CELL_OPT" *) 
  (* PHYS_OPT_SKIPPED = "CRITICAL_CELL_OPT" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_7__1
       (.I0(page_addr_ram2[0]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1_0[0]),
        .O(\page_addr_ram2_reg[4]_0 [0]));
  (* ORIG_CELL_NAME = "RAM32M_inst_0_i_7__1" *) 
  (* PHYS_OPT_MODIFIED = "CRITICAL_CELL_OPT" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_7__1_replica
       (.I0(page_addr_ram2[0]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1_0[0]),
        .O(\page_addr_ram2_reg[4]_0[0]_repN ));
  LUT3 #(
    .INIT(8'hB8)) 
    RAM32M_inst_0_i_7__2
       (.I0(page_addr_ram3[0]),
        .I1(en_IBUF),
        .I2(RAM32M_inst_1_1[0]),
        .O(\page_addr_ram3_reg[4]_0 [0]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'h0000FF7F)) 
    \cnt[0]_i_1__0 
       (.I0(cnt[1]),
        .I1(cnt[3]),
        .I2(cnt[2]),
        .I3(cnt[4]),
        .I4(cnt[0]),
        .O(\cnt[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'h5555AA2A)) 
    \cnt[1]_i_1 
       (.I0(cnt[1]),
        .I1(cnt[3]),
        .I2(cnt[2]),
        .I3(cnt[4]),
        .I4(cnt[0]),
        .O(\cnt[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h5A5AF070)) 
    \cnt[2]_i_1 
       (.I0(cnt[1]),
        .I1(cnt[3]),
        .I2(cnt[2]),
        .I3(cnt[4]),
        .I4(cnt[0]),
        .O(\cnt[2]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \cnt[3]_i_1 
       (.I0(en_reg),
        .O(SR));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h6C6CCC4C)) 
    \cnt[3]_i_1__0 
       (.I0(cnt[1]),
        .I1(cnt[3]),
        .I2(cnt[2]),
        .I3(cnt[4]),
        .I4(cnt[0]),
        .O(\cnt[3]_i_1__0_n_0 ));
  LUT5 #(
    .INIT(32'h7F80FF00)) 
    \cnt[4]_i_1 
       (.I0(cnt[1]),
        .I1(cnt[3]),
        .I2(cnt[2]),
        .I3(cnt[4]),
        .I4(cnt[0]),
        .O(\cnt[4]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \cnt_reg[0] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(\cnt[0]_i_1__0_n_0 ),
        .Q(cnt[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \cnt_reg[1] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(\cnt[1]_i_1_n_0 ),
        .Q(cnt[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \cnt_reg[2] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(\cnt[2]_i_1_n_0 ),
        .Q(cnt[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \cnt_reg[3] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(\cnt[3]_i_1__0_n_0 ),
        .Q(cnt[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \cnt_reg[4] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(\cnt[4]_i_1_n_0 ),
        .Q(cnt[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    en_reg_reg
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(en_IBUF),
        .Q(en_reg),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram0_reg[0] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[0]),
        .Q(page_addr_ram0[0]),
        .R(\page_addr_ram0_reg[4]_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram0_reg[1] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[1]),
        .Q(page_addr_ram0[1]),
        .R(\page_addr_ram0_reg[4]_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram0_reg[2] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[2]),
        .Q(page_addr_ram0[2]),
        .R(\page_addr_ram0_reg[4]_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram0_reg[3] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[3]),
        .Q(page_addr_ram0[3]),
        .R(\page_addr_ram0_reg[4]_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram0_reg[4] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[4]),
        .Q(page_addr_ram0[4]),
        .R(\page_addr_ram0_reg[4]_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram1_reg[0] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[0]),
        .Q(page_addr_ram1[0]),
        .R(\page_addr_ram1_reg[4]_1 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram1_reg[1] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[1]),
        .Q(page_addr_ram1[1]),
        .R(\page_addr_ram1_reg[4]_1 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram1_reg[2] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[2]),
        .Q(page_addr_ram1[2]),
        .R(\page_addr_ram1_reg[4]_1 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram1_reg[3] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[3]),
        .Q(page_addr_ram1[3]),
        .R(\page_addr_ram1_reg[4]_1 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram1_reg[4] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[4]),
        .Q(page_addr_ram1[4]),
        .R(\page_addr_ram1_reg[4]_1 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram2_reg[0] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[0]),
        .Q(page_addr_ram2[0]),
        .R(\page_addr_ram2_reg[4]_1 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram2_reg[1] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[1]),
        .Q(page_addr_ram2[1]),
        .R(\page_addr_ram2_reg[4]_1 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram2_reg[2] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[2]),
        .Q(page_addr_ram2[2]),
        .R(\page_addr_ram2_reg[4]_1 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram2_reg[3] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[3]),
        .Q(page_addr_ram2[3]),
        .R(\page_addr_ram2_reg[4]_1 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram2_reg[4] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[4]),
        .Q(page_addr_ram2[4]),
        .R(\page_addr_ram2_reg[4]_1 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram3_reg[0] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[0]),
        .Q(page_addr_ram3[0]),
        .R(\page_addr_ram3_reg[4]_1 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram3_reg[1] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[1]),
        .Q(page_addr_ram3[1]),
        .R(\page_addr_ram3_reg[4]_1 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram3_reg[2] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[2]),
        .Q(page_addr_ram3[2]),
        .R(\page_addr_ram3_reg[4]_1 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram3_reg[3] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[3]),
        .Q(page_addr_ram3[3]),
        .R(\page_addr_ram3_reg[4]_1 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \page_addr_ram3_reg[4] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(cnt[4]),
        .Q(page_addr_ram3[4]),
        .R(\page_addr_ram3_reg[4]_1 ));
endmodule

module c6ibm_port_shifter
   (Q,
    en_IBUF,
    CLK,
    \ports_data_reg[95]_0 ,
    \ports_data_reg[63]_0 ,
    \ports_data_reg[31]_0 );
  output [31:0]Q;
  input en_IBUF;
  input CLK;
  input [31:0]\ports_data_reg[95]_0 ;
  input [31:0]\ports_data_reg[63]_0 ;
  input [31:0]\ports_data_reg[31]_0 ;

  wire CLK;
  wire [31:0]Q;
  wire [1:0]cnt;
  wire \cnt[0]_i_1__1_n_0 ;
  wire \cnt[1]_i_1__0_n_0 ;
  wire \cnt[1]_i_2_n_0 ;
  wire en_IBUF;
  wire en_reg;
  wire [95:0]ports_data;
  wire \ports_data[0]_i_1_n_0 ;
  wire \ports_data[10]_i_1_n_0 ;
  wire \ports_data[11]_i_1_n_0 ;
  wire \ports_data[12]_i_1_n_0 ;
  wire \ports_data[13]_i_1_n_0 ;
  wire \ports_data[14]_i_1_n_0 ;
  wire \ports_data[15]_i_1_n_0 ;
  wire \ports_data[16]_i_1_n_0 ;
  wire \ports_data[17]_i_1_n_0 ;
  wire \ports_data[18]_i_1_n_0 ;
  wire \ports_data[19]_i_1_n_0 ;
  wire \ports_data[1]_i_1_n_0 ;
  wire \ports_data[20]_i_1_n_0 ;
  wire \ports_data[21]_i_1_n_0 ;
  wire \ports_data[22]_i_1_n_0 ;
  wire \ports_data[23]_i_1_n_0 ;
  wire \ports_data[24]_i_1_n_0 ;
  wire \ports_data[25]_i_1_n_0 ;
  wire \ports_data[26]_i_1_n_0 ;
  wire \ports_data[27]_i_1_n_0 ;
  wire \ports_data[28]_i_1_n_0 ;
  wire \ports_data[29]_i_1_n_0 ;
  wire \ports_data[2]_i_1_n_0 ;
  wire \ports_data[30]_i_1_n_0 ;
  wire \ports_data[31]_i_1_n_0 ;
  wire \ports_data[32]_i_1_n_0 ;
  wire \ports_data[33]_i_1_n_0 ;
  wire \ports_data[34]_i_1_n_0 ;
  wire \ports_data[35]_i_1_n_0 ;
  wire \ports_data[36]_i_1_n_0 ;
  wire \ports_data[37]_i_1_n_0 ;
  wire \ports_data[38]_i_1_n_0 ;
  wire \ports_data[39]_i_1_n_0 ;
  wire \ports_data[3]_i_1_n_0 ;
  wire \ports_data[40]_i_1_n_0 ;
  wire \ports_data[41]_i_1_n_0 ;
  wire \ports_data[42]_i_1_n_0 ;
  wire \ports_data[43]_i_1_n_0 ;
  wire \ports_data[44]_i_1_n_0 ;
  wire \ports_data[45]_i_1_n_0 ;
  wire \ports_data[46]_i_1_n_0 ;
  wire \ports_data[47]_i_1_n_0 ;
  wire \ports_data[48]_i_1_n_0 ;
  wire \ports_data[49]_i_1_n_0 ;
  wire \ports_data[4]_i_1_n_0 ;
  wire \ports_data[50]_i_1_n_0 ;
  wire \ports_data[51]_i_1_n_0 ;
  wire \ports_data[52]_i_1_n_0 ;
  wire \ports_data[53]_i_1_n_0 ;
  wire \ports_data[54]_i_1_n_0 ;
  wire \ports_data[55]_i_1_n_0 ;
  wire \ports_data[56]_i_1_n_0 ;
  wire \ports_data[57]_i_1_n_0 ;
  wire \ports_data[58]_i_1_n_0 ;
  wire \ports_data[59]_i_1_n_0 ;
  wire \ports_data[5]_i_1_n_0 ;
  wire \ports_data[60]_i_1_n_0 ;
  wire \ports_data[61]_i_1_n_0 ;
  wire \ports_data[62]_i_1_n_0 ;
  wire \ports_data[63]_i_1_n_0 ;
  wire \ports_data[64]_i_1_n_0 ;
  wire \ports_data[65]_i_1_n_0 ;
  wire \ports_data[66]_i_1_n_0 ;
  wire \ports_data[67]_i_1_n_0 ;
  wire \ports_data[68]_i_1_n_0 ;
  wire \ports_data[69]_i_1_n_0 ;
  wire \ports_data[6]_i_1_n_0 ;
  wire \ports_data[70]_i_1_n_0 ;
  wire \ports_data[71]_i_1_n_0 ;
  wire \ports_data[72]_i_1_n_0 ;
  wire \ports_data[73]_i_1_n_0 ;
  wire \ports_data[74]_i_1_n_0 ;
  wire \ports_data[75]_i_1_n_0 ;
  wire \ports_data[76]_i_1_n_0 ;
  wire \ports_data[77]_i_1_n_0 ;
  wire \ports_data[78]_i_1_n_0 ;
  wire \ports_data[79]_i_1_n_0 ;
  wire \ports_data[7]_i_1_n_0 ;
  wire \ports_data[80]_i_1_n_0 ;
  wire \ports_data[81]_i_1_n_0 ;
  wire \ports_data[82]_i_1_n_0 ;
  wire \ports_data[83]_i_1_n_0 ;
  wire \ports_data[84]_i_1_n_0 ;
  wire \ports_data[85]_i_1_n_0 ;
  wire \ports_data[86]_i_1_n_0 ;
  wire \ports_data[87]_i_1_n_0 ;
  wire \ports_data[88]_i_1_n_0 ;
  wire \ports_data[89]_i_1_n_0 ;
  wire \ports_data[8]_i_1_n_0 ;
  wire \ports_data[90]_i_1_n_0 ;
  wire \ports_data[91]_i_1_n_0 ;
  wire \ports_data[92]_i_1_n_0 ;
  wire \ports_data[93]_i_1_n_0 ;
  wire \ports_data[94]_i_1_n_0 ;
  wire \ports_data[95]_i_1_n_0 ;
  wire \ports_data[9]_i_1_n_0 ;
  wire [31:0]\ports_data_reg[31]_0 ;
  wire [31:0]\ports_data_reg[63]_0 ;
  wire [31:0]\ports_data_reg[95]_0 ;

  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \cnt[0]_i_1__1 
       (.I0(cnt[0]),
        .I1(cnt[1]),
        .O(\cnt[0]_i_1__1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \cnt[1]_i_1__0 
       (.I0(en_reg),
        .O(\cnt[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \cnt[1]_i_2 
       (.I0(cnt[0]),
        .I1(cnt[1]),
        .O(\cnt[1]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \cnt_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cnt[0]_i_1__1_n_0 ),
        .Q(cnt[0]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \cnt_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .D(\cnt[1]_i_2_n_0 ),
        .Q(cnt[1]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    en_reg_reg
       (.C(CLK),
        .CE(1'b1),
        .D(en_IBUF),
        .Q(en_reg),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[64]),
        .Q(Q[0]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[74]),
        .Q(Q[10]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[75]),
        .Q(Q[11]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[12] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[76]),
        .Q(Q[12]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[13] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[77]),
        .Q(Q[13]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[14] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[78]),
        .Q(Q[14]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[15] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[79]),
        .Q(Q[15]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[16] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[80]),
        .Q(Q[16]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[17] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[81]),
        .Q(Q[17]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[18] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[82]),
        .Q(Q[18]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[19] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[83]),
        .Q(Q[19]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[65]),
        .Q(Q[1]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[20] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[84]),
        .Q(Q[20]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[21] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[85]),
        .Q(Q[21]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[22] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[86]),
        .Q(Q[22]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[23] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[87]),
        .Q(Q[23]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[24] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[88]),
        .Q(Q[24]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[25] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[89]),
        .Q(Q[25]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[26] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[90]),
        .Q(Q[26]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[27] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[91]),
        .Q(Q[27]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[28] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[92]),
        .Q(Q[28]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[29] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[93]),
        .Q(Q[29]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[66]),
        .Q(Q[2]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[30] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[94]),
        .Q(Q[30]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[31] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[95]),
        .Q(Q[31]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[67]),
        .Q(Q[3]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[68]),
        .Q(Q[4]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[69]),
        .Q(Q[5]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[70]),
        .Q(Q[6]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[71]),
        .Q(Q[7]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[72]),
        .Q(Q[8]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \port_out_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .D(ports_data[73]),
        .Q(Q[9]),
        .R(\cnt[1]_i_1__0_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[0]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [0]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [0]),
        .O(\ports_data[0]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[10]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [10]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [10]),
        .O(\ports_data[10]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[11]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [11]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [11]),
        .O(\ports_data[11]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[12]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [12]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [12]),
        .O(\ports_data[12]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[13]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [13]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [13]),
        .O(\ports_data[13]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[14]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [14]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [14]),
        .O(\ports_data[14]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[15]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [15]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [15]),
        .O(\ports_data[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[16]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [16]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [16]),
        .O(\ports_data[16]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[17]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [17]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [17]),
        .O(\ports_data[17]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[18]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [18]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [18]),
        .O(\ports_data[18]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[19]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [19]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [19]),
        .O(\ports_data[19]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[1]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [1]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [1]),
        .O(\ports_data[1]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[20]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [20]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [20]),
        .O(\ports_data[20]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[21]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [21]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [21]),
        .O(\ports_data[21]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[22]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [22]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [22]),
        .O(\ports_data[22]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[23]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [23]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [23]),
        .O(\ports_data[23]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[24]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [24]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [24]),
        .O(\ports_data[24]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[25]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [25]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [25]),
        .O(\ports_data[25]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[26]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [26]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [26]),
        .O(\ports_data[26]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[27]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [27]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [27]),
        .O(\ports_data[27]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[28]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [28]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [28]),
        .O(\ports_data[28]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[29]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [29]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [29]),
        .O(\ports_data[29]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[2]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [2]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [2]),
        .O(\ports_data[2]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[30]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [30]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [30]),
        .O(\ports_data[30]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[31]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [31]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [31]),
        .O(\ports_data[31]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[32]_i_1 
       (.I0(ports_data[0]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [0]),
        .I3(cnt[1]),
        .O(\ports_data[32]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[33]_i_1 
       (.I0(ports_data[1]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [1]),
        .I3(cnt[1]),
        .O(\ports_data[33]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[34]_i_1 
       (.I0(ports_data[2]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [2]),
        .I3(cnt[1]),
        .O(\ports_data[34]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[35]_i_1 
       (.I0(ports_data[3]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [3]),
        .I3(cnt[1]),
        .O(\ports_data[35]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[36]_i_1 
       (.I0(ports_data[4]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [4]),
        .I3(cnt[1]),
        .O(\ports_data[36]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[37]_i_1 
       (.I0(ports_data[5]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [5]),
        .I3(cnt[1]),
        .O(\ports_data[37]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[38]_i_1 
       (.I0(ports_data[6]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [6]),
        .I3(cnt[1]),
        .O(\ports_data[38]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[39]_i_1 
       (.I0(ports_data[7]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [7]),
        .I3(cnt[1]),
        .O(\ports_data[39]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[3]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [3]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [3]),
        .O(\ports_data[3]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[40]_i_1 
       (.I0(ports_data[8]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [8]),
        .I3(cnt[1]),
        .O(\ports_data[40]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[41]_i_1 
       (.I0(ports_data[9]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [9]),
        .I3(cnt[1]),
        .O(\ports_data[41]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[42]_i_1 
       (.I0(ports_data[10]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [10]),
        .I3(cnt[1]),
        .O(\ports_data[42]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[43]_i_1 
       (.I0(ports_data[11]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [11]),
        .I3(cnt[1]),
        .O(\ports_data[43]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[44]_i_1 
       (.I0(ports_data[12]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [12]),
        .I3(cnt[1]),
        .O(\ports_data[44]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[45]_i_1 
       (.I0(ports_data[13]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [13]),
        .I3(cnt[1]),
        .O(\ports_data[45]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[46]_i_1 
       (.I0(ports_data[14]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [14]),
        .I3(cnt[1]),
        .O(\ports_data[46]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[47]_i_1 
       (.I0(ports_data[15]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [15]),
        .I3(cnt[1]),
        .O(\ports_data[47]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[48]_i_1 
       (.I0(ports_data[16]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [16]),
        .I3(cnt[1]),
        .O(\ports_data[48]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[49]_i_1 
       (.I0(ports_data[17]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [17]),
        .I3(cnt[1]),
        .O(\ports_data[49]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[4]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [4]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [4]),
        .O(\ports_data[4]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[50]_i_1 
       (.I0(ports_data[18]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [18]),
        .I3(cnt[1]),
        .O(\ports_data[50]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[51]_i_1 
       (.I0(ports_data[19]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [19]),
        .I3(cnt[1]),
        .O(\ports_data[51]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[52]_i_1 
       (.I0(ports_data[20]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [20]),
        .I3(cnt[1]),
        .O(\ports_data[52]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[53]_i_1 
       (.I0(ports_data[21]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [21]),
        .I3(cnt[1]),
        .O(\ports_data[53]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[54]_i_1 
       (.I0(ports_data[22]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [22]),
        .I3(cnt[1]),
        .O(\ports_data[54]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[55]_i_1 
       (.I0(ports_data[23]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [23]),
        .I3(cnt[1]),
        .O(\ports_data[55]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[56]_i_1 
       (.I0(ports_data[24]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [24]),
        .I3(cnt[1]),
        .O(\ports_data[56]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[57]_i_1 
       (.I0(ports_data[25]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [25]),
        .I3(cnt[1]),
        .O(\ports_data[57]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[58]_i_1 
       (.I0(ports_data[26]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [26]),
        .I3(cnt[1]),
        .O(\ports_data[58]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[59]_i_1 
       (.I0(ports_data[27]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [27]),
        .I3(cnt[1]),
        .O(\ports_data[59]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[5]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [5]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [5]),
        .O(\ports_data[5]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[60]_i_1 
       (.I0(ports_data[28]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [28]),
        .I3(cnt[1]),
        .O(\ports_data[60]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[61]_i_1 
       (.I0(ports_data[29]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [29]),
        .I3(cnt[1]),
        .O(\ports_data[61]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[62]_i_1 
       (.I0(ports_data[30]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [30]),
        .I3(cnt[1]),
        .O(\ports_data[62]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[63]_i_1 
       (.I0(ports_data[31]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[63]_0 [31]),
        .I3(cnt[1]),
        .O(\ports_data[63]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[64]_i_1 
       (.I0(ports_data[32]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[95]_0 [0]),
        .I3(cnt[1]),
        .O(\ports_data[64]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[65]_i_1 
       (.I0(ports_data[33]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[95]_0 [1]),
        .I3(cnt[1]),
        .O(\ports_data[65]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[66]_i_1 
       (.I0(ports_data[34]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[95]_0 [2]),
        .I3(cnt[1]),
        .O(\ports_data[66]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[67]_i_1 
       (.I0(ports_data[35]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[95]_0 [3]),
        .I3(cnt[1]),
        .O(\ports_data[67]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[68]_i_1 
       (.I0(ports_data[36]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[95]_0 [4]),
        .I3(cnt[1]),
        .O(\ports_data[68]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[69]_i_1 
       (.I0(ports_data[37]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[95]_0 [5]),
        .I3(cnt[1]),
        .O(\ports_data[69]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[6]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [6]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [6]),
        .O(\ports_data[6]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[70]_i_1 
       (.I0(ports_data[38]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[95]_0 [6]),
        .I3(cnt[1]),
        .O(\ports_data[70]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hAAB8)) 
    \ports_data[71]_i_1 
       (.I0(ports_data[39]),
        .I1(cnt[0]),
        .I2(\ports_data_reg[95]_0 [7]),
        .I3(cnt[1]),
        .O(\ports_data[71]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[72]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[40]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [8]),
        .O(\ports_data[72]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[73]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[41]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [9]),
        .O(\ports_data[73]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[74]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[42]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [10]),
        .O(\ports_data[74]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[75]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[43]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [11]),
        .O(\ports_data[75]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[76]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[44]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [12]),
        .O(\ports_data[76]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[77]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[45]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [13]),
        .O(\ports_data[77]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[78]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[46]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [14]),
        .O(\ports_data[78]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[79]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[47]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [15]),
        .O(\ports_data[79]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[7]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [7]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [7]),
        .O(\ports_data[7]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[80]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[48]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [16]),
        .O(\ports_data[80]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[81]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[49]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [17]),
        .O(\ports_data[81]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[82]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[50]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [18]),
        .O(\ports_data[82]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[83]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[51]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [19]),
        .O(\ports_data[83]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[84]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[52]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [20]),
        .O(\ports_data[84]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[85]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[53]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [21]),
        .O(\ports_data[85]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[86]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[54]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [22]),
        .O(\ports_data[86]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[87]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[55]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [23]),
        .O(\ports_data[87]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[88]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[56]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [24]),
        .O(\ports_data[88]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[89]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[57]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [25]),
        .O(\ports_data[89]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[8]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [8]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [8]),
        .O(\ports_data[8]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[90]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[58]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [26]),
        .O(\ports_data[90]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[91]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[59]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [27]),
        .O(\ports_data[91]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[92]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[60]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [28]),
        .O(\ports_data[92]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[93]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[61]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [29]),
        .O(\ports_data[93]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[94]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[62]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [30]),
        .O(\ports_data[94]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[95]_i_1 
       (.I0(cnt[1]),
        .I1(ports_data[63]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[95]_0 [31]),
        .O(\ports_data[95]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCDC8)) 
    \ports_data[9]_i_1 
       (.I0(cnt[1]),
        .I1(\ports_data_reg[95]_0 [9]),
        .I2(cnt[0]),
        .I3(\ports_data_reg[31]_0 [9]),
        .O(\ports_data[9]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[0]_i_1_n_0 ),
        .Q(ports_data[0]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[10]_i_1_n_0 ),
        .Q(ports_data[10]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[11]_i_1_n_0 ),
        .Q(ports_data[11]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[12] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[12]_i_1_n_0 ),
        .Q(ports_data[12]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[13] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[13]_i_1_n_0 ),
        .Q(ports_data[13]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[14] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[14]_i_1_n_0 ),
        .Q(ports_data[14]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[15] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[15]_i_1_n_0 ),
        .Q(ports_data[15]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[16] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[16]_i_1_n_0 ),
        .Q(ports_data[16]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[17] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[17]_i_1_n_0 ),
        .Q(ports_data[17]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[18] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[18]_i_1_n_0 ),
        .Q(ports_data[18]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[19] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[19]_i_1_n_0 ),
        .Q(ports_data[19]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[1]_i_1_n_0 ),
        .Q(ports_data[1]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[20] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[20]_i_1_n_0 ),
        .Q(ports_data[20]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[21] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[21]_i_1_n_0 ),
        .Q(ports_data[21]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[22] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[22]_i_1_n_0 ),
        .Q(ports_data[22]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[23] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[23]_i_1_n_0 ),
        .Q(ports_data[23]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[24] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[24]_i_1_n_0 ),
        .Q(ports_data[24]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[25] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[25]_i_1_n_0 ),
        .Q(ports_data[25]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[26] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[26]_i_1_n_0 ),
        .Q(ports_data[26]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[27] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[27]_i_1_n_0 ),
        .Q(ports_data[27]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[28] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[28]_i_1_n_0 ),
        .Q(ports_data[28]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[29] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[29]_i_1_n_0 ),
        .Q(ports_data[29]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[2]_i_1_n_0 ),
        .Q(ports_data[2]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[30] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[30]_i_1_n_0 ),
        .Q(ports_data[30]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[31] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[31]_i_1_n_0 ),
        .Q(ports_data[31]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[32] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[32]_i_1_n_0 ),
        .Q(ports_data[32]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[33] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[33]_i_1_n_0 ),
        .Q(ports_data[33]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[34] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[34]_i_1_n_0 ),
        .Q(ports_data[34]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[35] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[35]_i_1_n_0 ),
        .Q(ports_data[35]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[36] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[36]_i_1_n_0 ),
        .Q(ports_data[36]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[37] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[37]_i_1_n_0 ),
        .Q(ports_data[37]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[38] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[38]_i_1_n_0 ),
        .Q(ports_data[38]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[39] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[39]_i_1_n_0 ),
        .Q(ports_data[39]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[3]_i_1_n_0 ),
        .Q(ports_data[3]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[40] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[40]_i_1_n_0 ),
        .Q(ports_data[40]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[41] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[41]_i_1_n_0 ),
        .Q(ports_data[41]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[42] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[42]_i_1_n_0 ),
        .Q(ports_data[42]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[43] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[43]_i_1_n_0 ),
        .Q(ports_data[43]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[44] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[44]_i_1_n_0 ),
        .Q(ports_data[44]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[45] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[45]_i_1_n_0 ),
        .Q(ports_data[45]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[46] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[46]_i_1_n_0 ),
        .Q(ports_data[46]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[47] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[47]_i_1_n_0 ),
        .Q(ports_data[47]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[48] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[48]_i_1_n_0 ),
        .Q(ports_data[48]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[49] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[49]_i_1_n_0 ),
        .Q(ports_data[49]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[4]_i_1_n_0 ),
        .Q(ports_data[4]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[50] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[50]_i_1_n_0 ),
        .Q(ports_data[50]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[51] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[51]_i_1_n_0 ),
        .Q(ports_data[51]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[52] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[52]_i_1_n_0 ),
        .Q(ports_data[52]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[53] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[53]_i_1_n_0 ),
        .Q(ports_data[53]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[54] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[54]_i_1_n_0 ),
        .Q(ports_data[54]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[55] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[55]_i_1_n_0 ),
        .Q(ports_data[55]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[56] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[56]_i_1_n_0 ),
        .Q(ports_data[56]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[57] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[57]_i_1_n_0 ),
        .Q(ports_data[57]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[58] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[58]_i_1_n_0 ),
        .Q(ports_data[58]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[59] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[59]_i_1_n_0 ),
        .Q(ports_data[59]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[5]_i_1_n_0 ),
        .Q(ports_data[5]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[60] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[60]_i_1_n_0 ),
        .Q(ports_data[60]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[61] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[61]_i_1_n_0 ),
        .Q(ports_data[61]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[62] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[62]_i_1_n_0 ),
        .Q(ports_data[62]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[63] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[63]_i_1_n_0 ),
        .Q(ports_data[63]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[64] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[64]_i_1_n_0 ),
        .Q(ports_data[64]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[65] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[65]_i_1_n_0 ),
        .Q(ports_data[65]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[66] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[66]_i_1_n_0 ),
        .Q(ports_data[66]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[67] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[67]_i_1_n_0 ),
        .Q(ports_data[67]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[68] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[68]_i_1_n_0 ),
        .Q(ports_data[68]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[69] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[69]_i_1_n_0 ),
        .Q(ports_data[69]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[6]_i_1_n_0 ),
        .Q(ports_data[6]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[70] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[70]_i_1_n_0 ),
        .Q(ports_data[70]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[71] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[71]_i_1_n_0 ),
        .Q(ports_data[71]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[72] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[72]_i_1_n_0 ),
        .Q(ports_data[72]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[73] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[73]_i_1_n_0 ),
        .Q(ports_data[73]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[74] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[74]_i_1_n_0 ),
        .Q(ports_data[74]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[75] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[75]_i_1_n_0 ),
        .Q(ports_data[75]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[76] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[76]_i_1_n_0 ),
        .Q(ports_data[76]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[77] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[77]_i_1_n_0 ),
        .Q(ports_data[77]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[78] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[78]_i_1_n_0 ),
        .Q(ports_data[78]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[79] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[79]_i_1_n_0 ),
        .Q(ports_data[79]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[7]_i_1_n_0 ),
        .Q(ports_data[7]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[80] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[80]_i_1_n_0 ),
        .Q(ports_data[80]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[81] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[81]_i_1_n_0 ),
        .Q(ports_data[81]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[82] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[82]_i_1_n_0 ),
        .Q(ports_data[82]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[83] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[83]_i_1_n_0 ),
        .Q(ports_data[83]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[84] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[84]_i_1_n_0 ),
        .Q(ports_data[84]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[85] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[85]_i_1_n_0 ),
        .Q(ports_data[85]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[86] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[86]_i_1_n_0 ),
        .Q(ports_data[86]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[87] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[87]_i_1_n_0 ),
        .Q(ports_data[87]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[88] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[88]_i_1_n_0 ),
        .Q(ports_data[88]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[89] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[89]_i_1_n_0 ),
        .Q(ports_data[89]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[8]_i_1_n_0 ),
        .Q(ports_data[8]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[90] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[90]_i_1_n_0 ),
        .Q(ports_data[90]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[91] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[91]_i_1_n_0 ),
        .Q(ports_data[91]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[92] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[92]_i_1_n_0 ),
        .Q(ports_data[92]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[93] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[93]_i_1_n_0 ),
        .Q(ports_data[93]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[94] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[94]_i_1_n_0 ),
        .Q(ports_data[94]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[95] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[95]_i_1_n_0 ),
        .Q(ports_data[95]),
        .R(\cnt[1]_i_1__0_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \ports_data_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .D(\ports_data[9]_i_1_n_0 ),
        .Q(ports_data[9]),
        .R(\cnt[1]_i_1__0_n_0 ));
endmodule

(* HW_HANDOFF = "clock_domain.hwdef" *) 
module clock_domain
   (clk_out1_0,
    clk_out2_0,
    reset,
    sys_diff_clock_clk_n,
    sys_diff_clock_clk_p,
    lopt);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_OUT1_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_OUT1_0, CLK_DOMAIN clock_domain_clk_wiz_0_0_clk_out1, FREQ_HZ 300000000, INSERT_VIP 0, PHASE 0.0" *) output clk_out1_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_OUT2_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_OUT2_0, CLK_DOMAIN clock_domain_clk_wiz_0_0_clk_out1, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.0" *) output clk_out2_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input reset;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 sys_diff_clock CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME sys_diff_clock, CAN_DEBUG false, FREQ_HZ 200000000" *) input sys_diff_clock_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 sys_diff_clock CLK_P" *) input sys_diff_clock_clk_p;
  input lopt;

  wire clk_out1_0;
  wire clk_out2_0;
  wire lopt;
  wire sys_diff_clock_clk_n;
  wire sys_diff_clock_clk_p;
  wire NLW_clk_wiz_0_locked_UNCONNECTED;
  wire NLW_clk_wiz_0_reset_UNCONNECTED;

  (* IMPORTED_FROM = "/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_LUT/IB_LUT.srcs/sources_1/bd/clock_domain/ip/clock_domain_clk_wiz_0_0/clock_domain_clk_wiz_0_0.dcp" *) 
  (* IMPORTED_TYPE = "CHECKPOINT" *) 
  (* IS_IMPORTED *) 
  clock_domain_clk_wiz_0_0 clk_wiz_0
       (.clk_in1_n(sys_diff_clock_clk_n),
        .clk_in1_p(sys_diff_clock_clk_p),
        .clk_out1(clk_out1_0),
        .clk_out2(clk_out2_0),
        .locked(NLW_clk_wiz_0_locked_UNCONNECTED),
        .lopt(lopt),
        .reset(NLW_clk_wiz_0_reset_UNCONNECTED));
endmodule

module clock_domain_clk_wiz_0_0
   (clk_out1,
    clk_out2,
    reset,
    locked,
    clk_in1_p,
    clk_in1_n,
    lopt);
  output clk_out1;
  output clk_out2;
  input reset;
  output locked;
  input clk_in1_p;
  input clk_in1_n;
  input lopt;

  wire clk_in1_n;
  wire clk_in1_p;
  wire clk_out1;
  wire clk_out2;
  wire lopt;
  wire NLW_inst_locked_UNCONNECTED;
  wire NLW_inst_reset_UNCONNECTED;

  clock_domain_clk_wiz_0_0_clock_domain_clk_wiz_0_0_clk_wiz inst
       (.clk_in1_n(clk_in1_n),
        .clk_in1_p(clk_in1_p),
        .clk_out1(clk_out1),
        .clk_out2(clk_out2),
        .locked(NLW_inst_locked_UNCONNECTED),
        .lopt(lopt),
        .reset(NLW_inst_reset_UNCONNECTED));
endmodule

(* ORIG_REF_NAME = "clock_domain_clk_wiz_0_0_clk_wiz" *) 
module clock_domain_clk_wiz_0_0_clock_domain_clk_wiz_0_0_clk_wiz
   (clk_out1,
    clk_out2,
    reset,
    locked,
    clk_in1_p,
    clk_in1_n,
    lopt);
  output clk_out1;
  output clk_out2;
  input reset;
  output locked;
  input clk_in1_p;
  input clk_in1_n;
  input lopt;

  wire clk_in1_clock_domain_clk_wiz_0_0;
  wire clk_in1_n;
  wire clk_in1_p;
  wire clk_out1;
  wire clk_out1_clock_domain_clk_wiz_0_0;
  wire clk_out2;
  wire clk_out2_clock_domain_clk_wiz_0_0;
  wire clkfbout_buf_clock_domain_clk_wiz_0_0;
  wire clkfbout_clock_domain_clk_wiz_0_0;
  wire lopt;
  wire NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT2_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT3_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT4_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED;
  wire NLW_mmcm_adv_inst_DRDY_UNCONNECTED;
  wire NLW_mmcm_adv_inst_LOCKED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_PSDONE_UNCONNECTED;
  wire [15:0]NLW_mmcm_adv_inst_DO_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkf_buf
       (.I(clkfbout_clock_domain_clk_wiz_0_0),
        .O(clkfbout_buf_clock_domain_clk_wiz_0_0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  (* IBUF_DELAY_VALUE = "0" *) 
  (* IFD_DELAY_VALUE = "AUTO" *) 
  IBUFDS #(
    .IOSTANDARD("DEFAULT")) 
    clkin1_ibufgds
       (.I(clk_in1_p),
        .IB(clk_in1_n),
        .O(clk_in1_clock_domain_clk_wiz_0_0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkout1_buf
       (.I(clk_out1_clock_domain_clk_wiz_0_0),
        .O(clk_out1));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkout2_buf
       (.I(clk_out2_clock_domain_clk_wiz_0_0),
        .O(clk_out2));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "RETARGET SWEEP" *) 
  MMCME2_ADV #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKFBOUT_MULT_F(4.500000),
    .CLKFBOUT_PHASE(0.000000),
    .CLKFBOUT_USE_FINE_PS("FALSE"),
    .CLKIN1_PERIOD(5.000000),
    .CLKIN2_PERIOD(0.000000),
    .CLKOUT0_DIVIDE_F(3.000000),
    .CLKOUT0_DUTY_CYCLE(0.500000),
    .CLKOUT0_PHASE(0.000000),
    .CLKOUT0_USE_FINE_PS("FALSE"),
    .CLKOUT1_DIVIDE(9),
    .CLKOUT1_DUTY_CYCLE(0.167000),
    .CLKOUT1_PHASE(0.000000),
    .CLKOUT1_USE_FINE_PS("FALSE"),
    .CLKOUT2_DIVIDE(1),
    .CLKOUT2_DUTY_CYCLE(0.500000),
    .CLKOUT2_PHASE(0.000000),
    .CLKOUT2_USE_FINE_PS("FALSE"),
    .CLKOUT3_DIVIDE(1),
    .CLKOUT3_DUTY_CYCLE(0.500000),
    .CLKOUT3_PHASE(0.000000),
    .CLKOUT3_USE_FINE_PS("FALSE"),
    .CLKOUT4_CASCADE("FALSE"),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT4_DUTY_CYCLE(0.500000),
    .CLKOUT4_PHASE(0.000000),
    .CLKOUT4_USE_FINE_PS("FALSE"),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT5_DUTY_CYCLE(0.500000),
    .CLKOUT5_PHASE(0.000000),
    .CLKOUT5_USE_FINE_PS("FALSE"),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT6_DUTY_CYCLE(0.500000),
    .CLKOUT6_PHASE(0.000000),
    .CLKOUT6_USE_FINE_PS("FALSE"),
    .COMPENSATION("ZHOLD"),
    .DIVCLK_DIVIDE(1),
    .IS_CLKINSEL_INVERTED(1'b0),
    .IS_PSEN_INVERTED(1'b0),
    .IS_PSINCDEC_INVERTED(1'b0),
    .IS_PWRDWN_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b1),
    .REF_JITTER1(0.010000),
    .REF_JITTER2(0.010000),
    .SS_EN("FALSE"),
    .SS_MODE("CENTER_HIGH"),
    .SS_MOD_PERIOD(10000),
    .STARTUP_WAIT("FALSE")) 
    mmcm_adv_inst
       (.CLKFBIN(clkfbout_buf_clock_domain_clk_wiz_0_0),
        .CLKFBOUT(clkfbout_clock_domain_clk_wiz_0_0),
        .CLKFBOUTB(NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED),
        .CLKFBSTOPPED(NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED),
        .CLKIN1(clk_in1_clock_domain_clk_wiz_0_0),
        .CLKIN2(1'b0),
        .CLKINSEL(1'b1),
        .CLKINSTOPPED(NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED),
        .CLKOUT0(clk_out1_clock_domain_clk_wiz_0_0),
        .CLKOUT0B(NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED),
        .CLKOUT1(clk_out2_clock_domain_clk_wiz_0_0),
        .CLKOUT1B(NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED),
        .CLKOUT2(NLW_mmcm_adv_inst_CLKOUT2_UNCONNECTED),
        .CLKOUT2B(NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED),
        .CLKOUT3(NLW_mmcm_adv_inst_CLKOUT3_UNCONNECTED),
        .CLKOUT3B(NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED),
        .CLKOUT4(NLW_mmcm_adv_inst_CLKOUT4_UNCONNECTED),
        .CLKOUT5(NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED),
        .CLKOUT6(NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED),
        .DADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DCLK(1'b0),
        .DEN(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DO(NLW_mmcm_adv_inst_DO_UNCONNECTED[15:0]),
        .DRDY(NLW_mmcm_adv_inst_DRDY_UNCONNECTED),
        .DWE(1'b0),
        .LOCKED(NLW_mmcm_adv_inst_LOCKED_UNCONNECTED),
        .PSCLK(1'b0),
        .PSDONE(NLW_mmcm_adv_inst_PSDONE_UNCONNECTED),
        .PSEN(1'b0),
        .PSINCDEC(1'b0),
        .PWRDWN(1'b0),
        .RST(lopt));
endmodule

module clock_domain_wrapper
   (clk_out1_0,
    CLK,
    reset,
    sys_clk_n,
    sys_clk_p,
    lopt);
  output clk_out1_0;
  output CLK;
  input reset;
  input sys_clk_n;
  input sys_clk_p;
  input lopt;

  wire CLK;
  wire clk_out1_0;
  wire lopt;
  wire sys_clk_n;
  wire sys_clk_p;
  wire NLW_clock_domain_i_reset_UNCONNECTED;

  (* HW_HANDOFF = "clock_domain.hwdef" *) 
  clock_domain clock_domain_i
       (.clk_out1_0(clk_out1_0),
        .clk_out2_0(CLK),
        .lopt(lopt),
        .reset(NLW_clock_domain_i_reset_UNCONNECTED),
        .sys_diff_clock_clk_n(sys_clk_n),
        .sys_diff_clock_clk_p(sys_clk_p));
endmodule

module cnu6_ib_map
   (BRAM_PORTB_0_addr,
    reset,
    Q,
    \interBank_port0_7_reg[2][31]_0 ,
    \interBank_port0_7_reg[1][31]_0 ,
    CLK,
    BRAM_PORTA_0_dout,
    BRAM_PORTB_0_dout,
    rstn);
  output [5:0]BRAM_PORTB_0_addr;
  output reset;
  output [31:0]Q;
  output [31:0]\interBank_port0_7_reg[2][31]_0 ;
  output [31:0]\interBank_port0_7_reg[1][31]_0 ;
  input CLK;
  input [35:0]BRAM_PORTA_0_dout;
  input [35:0]BRAM_PORTB_0_dout;
  input rstn;

  wire [35:0]BRAM_PORTA_0_dout;
  wire [5:0]BRAM_PORTB_0_addr;
  wire [35:0]BRAM_PORTB_0_dout;
  wire CLK;
  wire [31:0]Q;
  wire \interBank_port0_7[0][0]_i_1_n_0 ;
  wire \interBank_port0_7[0][10]_i_1_n_0 ;
  wire \interBank_port0_7[0][11]_i_1_n_0 ;
  wire \interBank_port0_7[0][12]_i_1_n_0 ;
  wire \interBank_port0_7[0][13]_i_1_n_0 ;
  wire \interBank_port0_7[0][14]_i_1_n_0 ;
  wire \interBank_port0_7[0][15]_i_1_n_0 ;
  wire \interBank_port0_7[0][15]_i_2_n_0 ;
  wire \interBank_port0_7[0][16]_i_1_n_0 ;
  wire \interBank_port0_7[0][17]_i_1_n_0 ;
  wire \interBank_port0_7[0][18]_i_1_n_0 ;
  wire \interBank_port0_7[0][19]_i_1_n_0 ;
  wire \interBank_port0_7[0][1]_i_1_n_0 ;
  wire \interBank_port0_7[0][20]_i_1_n_0 ;
  wire \interBank_port0_7[0][21]_i_1_n_0 ;
  wire \interBank_port0_7[0][22]_i_1_n_0 ;
  wire \interBank_port0_7[0][23]_i_2_n_0 ;
  wire \interBank_port0_7[0][2]_i_1_n_0 ;
  wire \interBank_port0_7[0][31]_i_1_n_0 ;
  wire \interBank_port0_7[0][3]_i_1_n_0 ;
  wire \interBank_port0_7[0][4]_i_1_n_0 ;
  wire \interBank_port0_7[0][5]_i_1_n_0 ;
  wire \interBank_port0_7[0][6]_i_1_n_0 ;
  wire \interBank_port0_7[0][7]_i_1_n_0 ;
  wire \interBank_port0_7[0][8]_i_1_n_0 ;
  wire \interBank_port0_7[0][9]_i_1_n_0 ;
  wire \interBank_port0_7[1][0]_i_1_n_0 ;
  wire \interBank_port0_7[1][10]_i_1_n_0 ;
  wire \interBank_port0_7[1][11]_i_1_n_0 ;
  wire \interBank_port0_7[1][12]_i_1_n_0 ;
  wire \interBank_port0_7[1][13]_i_1_n_0 ;
  wire \interBank_port0_7[1][14]_i_1_n_0 ;
  wire \interBank_port0_7[1][15]_i_1_n_0 ;
  wire \interBank_port0_7[1][16]_i_1_n_0 ;
  wire \interBank_port0_7[1][17]_i_1_n_0 ;
  wire \interBank_port0_7[1][18]_i_1_n_0 ;
  wire \interBank_port0_7[1][19]_i_1_n_0 ;
  wire \interBank_port0_7[1][1]_i_1_n_0 ;
  wire \interBank_port0_7[1][20]_i_1_n_0 ;
  wire \interBank_port0_7[1][21]_i_1_n_0 ;
  wire \interBank_port0_7[1][22]_i_1_n_0 ;
  wire \interBank_port0_7[1][23]_i_1_n_0 ;
  wire \interBank_port0_7[1][24]_i_1_n_0 ;
  wire \interBank_port0_7[1][25]_i_1_n_0 ;
  wire \interBank_port0_7[1][26]_i_1_n_0 ;
  wire \interBank_port0_7[1][27]_i_1_n_0 ;
  wire \interBank_port0_7[1][28]_i_1_n_0 ;
  wire \interBank_port0_7[1][29]_i_1_n_0 ;
  wire \interBank_port0_7[1][2]_i_1_n_0 ;
  wire \interBank_port0_7[1][30]_i_1_n_0 ;
  wire \interBank_port0_7[1][31]_i_1_n_0 ;
  wire \interBank_port0_7[1][3]_i_1_n_0 ;
  wire \interBank_port0_7[1][4]_i_1_n_0 ;
  wire \interBank_port0_7[1][5]_i_1_n_0 ;
  wire \interBank_port0_7[1][6]_i_1_n_0 ;
  wire \interBank_port0_7[1][7]_i_1_n_0 ;
  wire \interBank_port0_7[1][8]_i_1_n_0 ;
  wire \interBank_port0_7[1][9]_i_1_n_0 ;
  wire \interBank_port0_7[2][10]_i_1_n_0 ;
  wire \interBank_port0_7[2][11]_i_1_n_0 ;
  wire \interBank_port0_7[2][12]_i_1_n_0 ;
  wire \interBank_port0_7[2][13]_i_1_n_0 ;
  wire \interBank_port0_7[2][14]_i_1_n_0 ;
  wire \interBank_port0_7[2][15]_i_1_n_0 ;
  wire \interBank_port0_7[2][16]_i_1_n_0 ;
  wire \interBank_port0_7[2][17]_i_1_n_0 ;
  wire \interBank_port0_7[2][18]_i_1_n_0 ;
  wire \interBank_port0_7[2][19]_i_1_n_0 ;
  wire \interBank_port0_7[2][20]_i_1_n_0 ;
  wire \interBank_port0_7[2][21]_i_1_n_0 ;
  wire \interBank_port0_7[2][22]_i_1_n_0 ;
  wire \interBank_port0_7[2][23]_i_1_n_0 ;
  wire \interBank_port0_7[2][23]_i_2_n_0 ;
  wire \interBank_port0_7[2][24]_i_1_n_0 ;
  wire \interBank_port0_7[2][25]_i_1_n_0 ;
  wire \interBank_port0_7[2][26]_i_1_n_0 ;
  wire \interBank_port0_7[2][27]_i_1_n_0 ;
  wire \interBank_port0_7[2][28]_i_1_n_0 ;
  wire \interBank_port0_7[2][29]_i_1_n_0 ;
  wire \interBank_port0_7[2][30]_i_1_n_0 ;
  wire \interBank_port0_7[2][31]_i_1_n_0 ;
  wire \interBank_port0_7[2][7]_i_1_n_0 ;
  wire \interBank_port0_7[2][8]_i_1_n_0 ;
  wire \interBank_port0_7[2][9]_i_1_n_0 ;
  wire [31:0]\interBank_port0_7_reg[1][31]_0 ;
  wire [31:0]\interBank_port0_7_reg[2][31]_0 ;
  wire [1:0]offset_cnt;
  wire \offset_cnt[0]_i_1_n_0 ;
  wire \offset_cnt[1]_i_1_n_0 ;
  wire p_0_in0;
  wire \^reset ;
  wire \rom_read_addrA[1]_i_1_n_0 ;
  wire \rom_read_addrA[2]_i_1_n_0 ;
  wire \rom_read_addrA[3]_i_1_n_0 ;
  wire \rom_read_addrA[4]_i_1_n_0 ;
  wire \rom_read_addrA[5]_i_1_n_0 ;
  wire \rom_read_addrA[6]_i_1_n_0 ;
  wire rstn;

  LUT1 #(
    .INIT(2'h1)) 
    clock_domain_i_i_1
       (.I0(rstn),
        .O(\^reset ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[0][0]_i_1 
       (.I0(BRAM_PORTA_0_dout[28]),
        .I1(BRAM_PORTA_0_dout[12]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTA_0_dout[20]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[4]),
        .O(\interBank_port0_7[0][0]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \interBank_port0_7[0][10]_i_1 
       (.I0(BRAM_PORTA_0_dout[30]),
        .I1(offset_cnt[1]),
        .I2(BRAM_PORTA_0_dout[22]),
        .I3(offset_cnt[0]),
        .I4(BRAM_PORTA_0_dout[14]),
        .O(\interBank_port0_7[0][10]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \interBank_port0_7[0][11]_i_1 
       (.I0(BRAM_PORTA_0_dout[31]),
        .I1(offset_cnt[1]),
        .I2(BRAM_PORTA_0_dout[23]),
        .I3(offset_cnt[0]),
        .I4(BRAM_PORTA_0_dout[15]),
        .O(\interBank_port0_7[0][11]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \interBank_port0_7[0][12]_i_1 
       (.I0(BRAM_PORTA_0_dout[32]),
        .I1(offset_cnt[1]),
        .I2(BRAM_PORTA_0_dout[24]),
        .I3(offset_cnt[0]),
        .I4(BRAM_PORTA_0_dout[16]),
        .O(\interBank_port0_7[0][12]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \interBank_port0_7[0][13]_i_1 
       (.I0(BRAM_PORTA_0_dout[33]),
        .I1(offset_cnt[1]),
        .I2(BRAM_PORTA_0_dout[25]),
        .I3(offset_cnt[0]),
        .I4(BRAM_PORTA_0_dout[17]),
        .O(\interBank_port0_7[0][13]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \interBank_port0_7[0][14]_i_1 
       (.I0(BRAM_PORTA_0_dout[34]),
        .I1(offset_cnt[1]),
        .I2(BRAM_PORTA_0_dout[26]),
        .I3(offset_cnt[0]),
        .I4(BRAM_PORTA_0_dout[18]),
        .O(\interBank_port0_7[0][14]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h7)) 
    \interBank_port0_7[0][15]_i_1 
       (.I0(offset_cnt[1]),
        .I1(offset_cnt[0]),
        .O(\interBank_port0_7[0][15]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \interBank_port0_7[0][15]_i_2 
       (.I0(BRAM_PORTA_0_dout[35]),
        .I1(offset_cnt[1]),
        .I2(BRAM_PORTA_0_dout[27]),
        .I3(offset_cnt[0]),
        .I4(BRAM_PORTA_0_dout[19]),
        .O(\interBank_port0_7[0][15]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[0][16]_i_1 
       (.I0(BRAM_PORTA_0_dout[28]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTA_0_dout[20]),
        .O(\interBank_port0_7[0][16]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[0][17]_i_1 
       (.I0(BRAM_PORTA_0_dout[29]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTA_0_dout[21]),
        .O(\interBank_port0_7[0][17]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[0][18]_i_1 
       (.I0(BRAM_PORTA_0_dout[30]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTA_0_dout[22]),
        .O(\interBank_port0_7[0][18]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[0][19]_i_1 
       (.I0(BRAM_PORTA_0_dout[31]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTA_0_dout[23]),
        .O(\interBank_port0_7[0][19]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[0][1]_i_1 
       (.I0(BRAM_PORTA_0_dout[29]),
        .I1(BRAM_PORTA_0_dout[13]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTA_0_dout[21]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[5]),
        .O(\interBank_port0_7[0][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[0][20]_i_1 
       (.I0(BRAM_PORTA_0_dout[32]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTA_0_dout[24]),
        .O(\interBank_port0_7[0][20]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[0][21]_i_1 
       (.I0(BRAM_PORTA_0_dout[33]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTA_0_dout[25]),
        .O(\interBank_port0_7[0][21]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[0][22]_i_1 
       (.I0(BRAM_PORTA_0_dout[34]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTA_0_dout[26]),
        .O(\interBank_port0_7[0][22]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \interBank_port0_7[0][23]_i_1 
       (.I0(offset_cnt[1]),
        .O(p_0_in0));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[0][23]_i_2 
       (.I0(BRAM_PORTA_0_dout[35]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTA_0_dout[27]),
        .O(\interBank_port0_7[0][23]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[0][2]_i_1 
       (.I0(BRAM_PORTA_0_dout[30]),
        .I1(BRAM_PORTA_0_dout[14]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTA_0_dout[22]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[6]),
        .O(\interBank_port0_7[0][2]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h1)) 
    \interBank_port0_7[0][31]_i_1 
       (.I0(offset_cnt[1]),
        .I1(offset_cnt[0]),
        .O(\interBank_port0_7[0][31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[0][3]_i_1 
       (.I0(BRAM_PORTA_0_dout[31]),
        .I1(BRAM_PORTA_0_dout[15]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTA_0_dout[23]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[7]),
        .O(\interBank_port0_7[0][3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[0][4]_i_1 
       (.I0(BRAM_PORTA_0_dout[32]),
        .I1(BRAM_PORTA_0_dout[16]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTA_0_dout[24]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[8]),
        .O(\interBank_port0_7[0][4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[0][5]_i_1 
       (.I0(BRAM_PORTA_0_dout[33]),
        .I1(BRAM_PORTA_0_dout[17]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTA_0_dout[25]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[9]),
        .O(\interBank_port0_7[0][5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[0][6]_i_1 
       (.I0(BRAM_PORTA_0_dout[34]),
        .I1(BRAM_PORTA_0_dout[18]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTA_0_dout[26]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[10]),
        .O(\interBank_port0_7[0][6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[0][7]_i_1 
       (.I0(BRAM_PORTA_0_dout[35]),
        .I1(BRAM_PORTA_0_dout[19]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTA_0_dout[27]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[11]),
        .O(\interBank_port0_7[0][7]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \interBank_port0_7[0][8]_i_1 
       (.I0(BRAM_PORTA_0_dout[28]),
        .I1(offset_cnt[1]),
        .I2(BRAM_PORTA_0_dout[20]),
        .I3(offset_cnt[0]),
        .I4(BRAM_PORTA_0_dout[12]),
        .O(\interBank_port0_7[0][8]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \interBank_port0_7[0][9]_i_1 
       (.I0(BRAM_PORTA_0_dout[29]),
        .I1(offset_cnt[1]),
        .I2(BRAM_PORTA_0_dout[21]),
        .I3(offset_cnt[0]),
        .I4(BRAM_PORTA_0_dout[13]),
        .O(\interBank_port0_7[0][9]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][0]_i_1 
       (.I0(BRAM_PORTB_0_dout[16]),
        .I1(BRAM_PORTB_0_dout[8]),
        .I2(BRAM_PORTB_0_dout[32]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[24]),
        .O(\interBank_port0_7[1][0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][10]_i_1 
       (.I0(BRAM_PORTB_0_dout[26]),
        .I1(BRAM_PORTB_0_dout[18]),
        .I2(BRAM_PORTA_0_dout[6]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[34]),
        .O(\interBank_port0_7[1][10]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][11]_i_1 
       (.I0(BRAM_PORTB_0_dout[27]),
        .I1(BRAM_PORTB_0_dout[19]),
        .I2(BRAM_PORTA_0_dout[7]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[35]),
        .O(\interBank_port0_7[1][11]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][12]_i_1 
       (.I0(BRAM_PORTB_0_dout[28]),
        .I1(BRAM_PORTB_0_dout[20]),
        .I2(BRAM_PORTA_0_dout[8]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[0]),
        .O(\interBank_port0_7[1][12]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][13]_i_1 
       (.I0(BRAM_PORTB_0_dout[29]),
        .I1(BRAM_PORTB_0_dout[21]),
        .I2(BRAM_PORTA_0_dout[9]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[1]),
        .O(\interBank_port0_7[1][13]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][14]_i_1 
       (.I0(BRAM_PORTB_0_dout[30]),
        .I1(BRAM_PORTB_0_dout[22]),
        .I2(BRAM_PORTA_0_dout[10]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[2]),
        .O(\interBank_port0_7[1][14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][15]_i_1 
       (.I0(BRAM_PORTB_0_dout[31]),
        .I1(BRAM_PORTB_0_dout[23]),
        .I2(BRAM_PORTA_0_dout[11]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[3]),
        .O(\interBank_port0_7[1][15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][16]_i_1 
       (.I0(BRAM_PORTB_0_dout[32]),
        .I1(BRAM_PORTB_0_dout[24]),
        .I2(BRAM_PORTA_0_dout[12]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[4]),
        .O(\interBank_port0_7[1][16]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][17]_i_1 
       (.I0(BRAM_PORTB_0_dout[33]),
        .I1(BRAM_PORTB_0_dout[25]),
        .I2(BRAM_PORTA_0_dout[13]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[5]),
        .O(\interBank_port0_7[1][17]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][18]_i_1 
       (.I0(BRAM_PORTB_0_dout[34]),
        .I1(BRAM_PORTB_0_dout[26]),
        .I2(BRAM_PORTA_0_dout[14]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[6]),
        .O(\interBank_port0_7[1][18]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][19]_i_1 
       (.I0(BRAM_PORTB_0_dout[35]),
        .I1(BRAM_PORTB_0_dout[27]),
        .I2(BRAM_PORTA_0_dout[15]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[7]),
        .O(\interBank_port0_7[1][19]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][1]_i_1 
       (.I0(BRAM_PORTB_0_dout[17]),
        .I1(BRAM_PORTB_0_dout[9]),
        .I2(BRAM_PORTB_0_dout[33]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[25]),
        .O(\interBank_port0_7[1][1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][20]_i_1 
       (.I0(BRAM_PORTA_0_dout[0]),
        .I1(BRAM_PORTB_0_dout[28]),
        .I2(BRAM_PORTA_0_dout[16]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[8]),
        .O(\interBank_port0_7[1][20]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][21]_i_1 
       (.I0(BRAM_PORTA_0_dout[1]),
        .I1(BRAM_PORTB_0_dout[29]),
        .I2(BRAM_PORTA_0_dout[17]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[9]),
        .O(\interBank_port0_7[1][21]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][22]_i_1 
       (.I0(BRAM_PORTA_0_dout[2]),
        .I1(BRAM_PORTB_0_dout[30]),
        .I2(BRAM_PORTA_0_dout[18]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[10]),
        .O(\interBank_port0_7[1][22]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][23]_i_1 
       (.I0(BRAM_PORTA_0_dout[3]),
        .I1(BRAM_PORTB_0_dout[31]),
        .I2(BRAM_PORTA_0_dout[19]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[11]),
        .O(\interBank_port0_7[1][23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][24]_i_1 
       (.I0(BRAM_PORTA_0_dout[4]),
        .I1(BRAM_PORTB_0_dout[32]),
        .I2(BRAM_PORTA_0_dout[20]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[12]),
        .O(\interBank_port0_7[1][24]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][25]_i_1 
       (.I0(BRAM_PORTA_0_dout[5]),
        .I1(BRAM_PORTB_0_dout[33]),
        .I2(BRAM_PORTA_0_dout[21]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[13]),
        .O(\interBank_port0_7[1][25]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][26]_i_1 
       (.I0(BRAM_PORTA_0_dout[6]),
        .I1(BRAM_PORTB_0_dout[34]),
        .I2(BRAM_PORTA_0_dout[22]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[14]),
        .O(\interBank_port0_7[1][26]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][27]_i_1 
       (.I0(BRAM_PORTA_0_dout[7]),
        .I1(BRAM_PORTB_0_dout[35]),
        .I2(BRAM_PORTA_0_dout[23]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[15]),
        .O(\interBank_port0_7[1][27]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][28]_i_1 
       (.I0(BRAM_PORTA_0_dout[8]),
        .I1(BRAM_PORTA_0_dout[0]),
        .I2(BRAM_PORTA_0_dout[24]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[16]),
        .O(\interBank_port0_7[1][28]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][29]_i_1 
       (.I0(BRAM_PORTA_0_dout[9]),
        .I1(BRAM_PORTA_0_dout[1]),
        .I2(BRAM_PORTA_0_dout[25]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[17]),
        .O(\interBank_port0_7[1][29]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][2]_i_1 
       (.I0(BRAM_PORTB_0_dout[18]),
        .I1(BRAM_PORTB_0_dout[10]),
        .I2(BRAM_PORTB_0_dout[34]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[26]),
        .O(\interBank_port0_7[1][2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][30]_i_1 
       (.I0(BRAM_PORTA_0_dout[10]),
        .I1(BRAM_PORTA_0_dout[2]),
        .I2(BRAM_PORTA_0_dout[26]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[18]),
        .O(\interBank_port0_7[1][30]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][31]_i_1 
       (.I0(BRAM_PORTA_0_dout[11]),
        .I1(BRAM_PORTA_0_dout[3]),
        .I2(BRAM_PORTA_0_dout[27]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTA_0_dout[19]),
        .O(\interBank_port0_7[1][31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][3]_i_1 
       (.I0(BRAM_PORTB_0_dout[19]),
        .I1(BRAM_PORTB_0_dout[11]),
        .I2(BRAM_PORTB_0_dout[35]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[27]),
        .O(\interBank_port0_7[1][3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][4]_i_1 
       (.I0(BRAM_PORTB_0_dout[20]),
        .I1(BRAM_PORTB_0_dout[12]),
        .I2(BRAM_PORTA_0_dout[0]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[28]),
        .O(\interBank_port0_7[1][4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][5]_i_1 
       (.I0(BRAM_PORTB_0_dout[21]),
        .I1(BRAM_PORTB_0_dout[13]),
        .I2(BRAM_PORTA_0_dout[1]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[29]),
        .O(\interBank_port0_7[1][5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][6]_i_1 
       (.I0(BRAM_PORTB_0_dout[22]),
        .I1(BRAM_PORTB_0_dout[14]),
        .I2(BRAM_PORTA_0_dout[2]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[30]),
        .O(\interBank_port0_7[1][6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][7]_i_1 
       (.I0(BRAM_PORTB_0_dout[23]),
        .I1(BRAM_PORTB_0_dout[15]),
        .I2(BRAM_PORTA_0_dout[3]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[31]),
        .O(\interBank_port0_7[1][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][8]_i_1 
       (.I0(BRAM_PORTB_0_dout[24]),
        .I1(BRAM_PORTB_0_dout[16]),
        .I2(BRAM_PORTA_0_dout[4]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[32]),
        .O(\interBank_port0_7[1][8]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FFAACCF000AACC)) 
    \interBank_port0_7[1][9]_i_1 
       (.I0(BRAM_PORTB_0_dout[25]),
        .I1(BRAM_PORTB_0_dout[17]),
        .I2(BRAM_PORTA_0_dout[5]),
        .I3(offset_cnt[0]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[33]),
        .O(\interBank_port0_7[1][9]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[2][10]_i_1 
       (.I0(BRAM_PORTB_0_dout[10]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[2]),
        .O(\interBank_port0_7[2][10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[2][11]_i_1 
       (.I0(BRAM_PORTB_0_dout[11]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[3]),
        .O(\interBank_port0_7[2][11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[2][12]_i_1 
       (.I0(BRAM_PORTB_0_dout[12]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[4]),
        .O(\interBank_port0_7[2][12]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[2][13]_i_1 
       (.I0(BRAM_PORTB_0_dout[13]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[5]),
        .O(\interBank_port0_7[2][13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[2][14]_i_1 
       (.I0(BRAM_PORTB_0_dout[14]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[6]),
        .O(\interBank_port0_7[2][14]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[2][15]_i_1 
       (.I0(BRAM_PORTB_0_dout[15]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[7]),
        .O(\interBank_port0_7[2][15]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \interBank_port0_7[2][16]_i_1 
       (.I0(BRAM_PORTB_0_dout[16]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[8]),
        .I3(offset_cnt[1]),
        .I4(BRAM_PORTB_0_dout[0]),
        .O(\interBank_port0_7[2][16]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \interBank_port0_7[2][17]_i_1 
       (.I0(BRAM_PORTB_0_dout[17]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[9]),
        .I3(offset_cnt[1]),
        .I4(BRAM_PORTB_0_dout[1]),
        .O(\interBank_port0_7[2][17]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \interBank_port0_7[2][18]_i_1 
       (.I0(BRAM_PORTB_0_dout[18]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[10]),
        .I3(offset_cnt[1]),
        .I4(BRAM_PORTB_0_dout[2]),
        .O(\interBank_port0_7[2][18]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \interBank_port0_7[2][19]_i_1 
       (.I0(BRAM_PORTB_0_dout[19]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[11]),
        .I3(offset_cnt[1]),
        .I4(BRAM_PORTB_0_dout[3]),
        .O(\interBank_port0_7[2][19]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \interBank_port0_7[2][20]_i_1 
       (.I0(BRAM_PORTB_0_dout[20]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[12]),
        .I3(offset_cnt[1]),
        .I4(BRAM_PORTB_0_dout[4]),
        .O(\interBank_port0_7[2][20]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \interBank_port0_7[2][21]_i_1 
       (.I0(BRAM_PORTB_0_dout[21]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[13]),
        .I3(offset_cnt[1]),
        .I4(BRAM_PORTB_0_dout[5]),
        .O(\interBank_port0_7[2][21]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \interBank_port0_7[2][22]_i_1 
       (.I0(BRAM_PORTB_0_dout[22]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[14]),
        .I3(offset_cnt[1]),
        .I4(BRAM_PORTB_0_dout[6]),
        .O(\interBank_port0_7[2][22]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \interBank_port0_7[2][23]_i_1 
       (.I0(offset_cnt[0]),
        .I1(offset_cnt[1]),
        .O(\interBank_port0_7[2][23]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \interBank_port0_7[2][23]_i_2 
       (.I0(BRAM_PORTB_0_dout[23]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[15]),
        .I3(offset_cnt[1]),
        .I4(BRAM_PORTB_0_dout[7]),
        .O(\interBank_port0_7[2][23]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[2][24]_i_1 
       (.I0(BRAM_PORTB_0_dout[24]),
        .I1(BRAM_PORTB_0_dout[8]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTB_0_dout[16]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[0]),
        .O(\interBank_port0_7[2][24]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[2][25]_i_1 
       (.I0(BRAM_PORTB_0_dout[25]),
        .I1(BRAM_PORTB_0_dout[9]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTB_0_dout[17]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[1]),
        .O(\interBank_port0_7[2][25]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[2][26]_i_1 
       (.I0(BRAM_PORTB_0_dout[26]),
        .I1(BRAM_PORTB_0_dout[10]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTB_0_dout[18]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[2]),
        .O(\interBank_port0_7[2][26]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[2][27]_i_1 
       (.I0(BRAM_PORTB_0_dout[27]),
        .I1(BRAM_PORTB_0_dout[11]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTB_0_dout[19]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[3]),
        .O(\interBank_port0_7[2][27]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[2][28]_i_1 
       (.I0(BRAM_PORTB_0_dout[28]),
        .I1(BRAM_PORTB_0_dout[12]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTB_0_dout[20]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[4]),
        .O(\interBank_port0_7[2][28]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[2][29]_i_1 
       (.I0(BRAM_PORTB_0_dout[29]),
        .I1(BRAM_PORTB_0_dout[13]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTB_0_dout[21]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[5]),
        .O(\interBank_port0_7[2][29]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[2][30]_i_1 
       (.I0(BRAM_PORTB_0_dout[30]),
        .I1(BRAM_PORTB_0_dout[14]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTB_0_dout[22]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[6]),
        .O(\interBank_port0_7[2][30]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \interBank_port0_7[2][31]_i_1 
       (.I0(BRAM_PORTB_0_dout[31]),
        .I1(BRAM_PORTB_0_dout[15]),
        .I2(offset_cnt[0]),
        .I3(BRAM_PORTB_0_dout[23]),
        .I4(offset_cnt[1]),
        .I5(BRAM_PORTB_0_dout[7]),
        .O(\interBank_port0_7[2][31]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \interBank_port0_7[2][7]_i_1 
       (.I0(offset_cnt[0]),
        .I1(offset_cnt[1]),
        .O(\interBank_port0_7[2][7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[2][8]_i_1 
       (.I0(BRAM_PORTB_0_dout[8]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[0]),
        .O(\interBank_port0_7[2][8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \interBank_port0_7[2][9]_i_1 
       (.I0(BRAM_PORTB_0_dout[9]),
        .I1(offset_cnt[0]),
        .I2(BRAM_PORTB_0_dout[1]),
        .O(\interBank_port0_7[2][9]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][0] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[0][0]_i_1_n_0 ),
        .Q(Q[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][10] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][15]_i_1_n_0 ),
        .D(\interBank_port0_7[0][10]_i_1_n_0 ),
        .Q(Q[10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][11] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][15]_i_1_n_0 ),
        .D(\interBank_port0_7[0][11]_i_1_n_0 ),
        .Q(Q[11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][12] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][15]_i_1_n_0 ),
        .D(\interBank_port0_7[0][12]_i_1_n_0 ),
        .Q(Q[12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][13] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][15]_i_1_n_0 ),
        .D(\interBank_port0_7[0][13]_i_1_n_0 ),
        .Q(Q[13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][14] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][15]_i_1_n_0 ),
        .D(\interBank_port0_7[0][14]_i_1_n_0 ),
        .Q(Q[14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][15] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][15]_i_1_n_0 ),
        .D(\interBank_port0_7[0][15]_i_2_n_0 ),
        .Q(Q[15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][16] 
       (.C(CLK),
        .CE(p_0_in0),
        .D(\interBank_port0_7[0][16]_i_1_n_0 ),
        .Q(Q[16]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][17] 
       (.C(CLK),
        .CE(p_0_in0),
        .D(\interBank_port0_7[0][17]_i_1_n_0 ),
        .Q(Q[17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][18] 
       (.C(CLK),
        .CE(p_0_in0),
        .D(\interBank_port0_7[0][18]_i_1_n_0 ),
        .Q(Q[18]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][19] 
       (.C(CLK),
        .CE(p_0_in0),
        .D(\interBank_port0_7[0][19]_i_1_n_0 ),
        .Q(Q[19]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][1] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[0][1]_i_1_n_0 ),
        .Q(Q[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][20] 
       (.C(CLK),
        .CE(p_0_in0),
        .D(\interBank_port0_7[0][20]_i_1_n_0 ),
        .Q(Q[20]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][21] 
       (.C(CLK),
        .CE(p_0_in0),
        .D(\interBank_port0_7[0][21]_i_1_n_0 ),
        .Q(Q[21]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][22] 
       (.C(CLK),
        .CE(p_0_in0),
        .D(\interBank_port0_7[0][22]_i_1_n_0 ),
        .Q(Q[22]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][23] 
       (.C(CLK),
        .CE(p_0_in0),
        .D(\interBank_port0_7[0][23]_i_2_n_0 ),
        .Q(Q[23]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][24] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][31]_i_1_n_0 ),
        .D(BRAM_PORTA_0_dout[28]),
        .Q(Q[24]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][25] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][31]_i_1_n_0 ),
        .D(BRAM_PORTA_0_dout[29]),
        .Q(Q[25]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][26] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][31]_i_1_n_0 ),
        .D(BRAM_PORTA_0_dout[30]),
        .Q(Q[26]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][27] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][31]_i_1_n_0 ),
        .D(BRAM_PORTA_0_dout[31]),
        .Q(Q[27]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][28] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][31]_i_1_n_0 ),
        .D(BRAM_PORTA_0_dout[32]),
        .Q(Q[28]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][29] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][31]_i_1_n_0 ),
        .D(BRAM_PORTA_0_dout[33]),
        .Q(Q[29]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][2] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[0][2]_i_1_n_0 ),
        .Q(Q[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][30] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][31]_i_1_n_0 ),
        .D(BRAM_PORTA_0_dout[34]),
        .Q(Q[30]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][31] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][31]_i_1_n_0 ),
        .D(BRAM_PORTA_0_dout[35]),
        .Q(Q[31]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][3] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[0][3]_i_1_n_0 ),
        .Q(Q[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][4] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[0][4]_i_1_n_0 ),
        .Q(Q[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][5] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[0][5]_i_1_n_0 ),
        .Q(Q[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][6] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[0][6]_i_1_n_0 ),
        .Q(Q[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][7] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[0][7]_i_1_n_0 ),
        .Q(Q[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][8] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][15]_i_1_n_0 ),
        .D(\interBank_port0_7[0][8]_i_1_n_0 ),
        .Q(Q[8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[0][9] 
       (.C(CLK),
        .CE(\interBank_port0_7[0][15]_i_1_n_0 ),
        .D(\interBank_port0_7[0][9]_i_1_n_0 ),
        .Q(Q[9]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][0] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][0]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][10] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][10]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][11] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][11]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][12] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][12]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][13] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][13]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][14] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][14]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][15] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][15]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][16] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][16]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [16]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][17] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][17]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][18] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][18]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [18]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][19] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][19]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [19]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][1] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][1]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][20] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][20]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [20]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][21] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][21]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [21]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][22] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][22]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [22]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][23] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][23]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [23]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][24] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][24]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [24]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][25] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][25]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [25]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][26] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][26]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [26]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][27] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][27]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [27]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][28] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][28]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [28]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][29] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][29]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [29]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][2] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][2]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][30] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][30]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [30]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][31] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][31]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [31]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][3] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][3]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][4] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][4]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][5] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][5]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][6] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][6]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][7] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][7]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][8] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][8]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[1][9] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[1][9]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[1][31]_0 [9]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][0] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][7]_i_1_n_0 ),
        .D(BRAM_PORTB_0_dout[0]),
        .Q(\interBank_port0_7_reg[2][31]_0 [0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][10] 
       (.C(CLK),
        .CE(offset_cnt[1]),
        .D(\interBank_port0_7[2][10]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][11] 
       (.C(CLK),
        .CE(offset_cnt[1]),
        .D(\interBank_port0_7[2][11]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][12] 
       (.C(CLK),
        .CE(offset_cnt[1]),
        .D(\interBank_port0_7[2][12]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][13] 
       (.C(CLK),
        .CE(offset_cnt[1]),
        .D(\interBank_port0_7[2][13]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][14] 
       (.C(CLK),
        .CE(offset_cnt[1]),
        .D(\interBank_port0_7[2][14]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][15] 
       (.C(CLK),
        .CE(offset_cnt[1]),
        .D(\interBank_port0_7[2][15]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][16] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][23]_i_1_n_0 ),
        .D(\interBank_port0_7[2][16]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [16]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][17] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][23]_i_1_n_0 ),
        .D(\interBank_port0_7[2][17]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][18] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][23]_i_1_n_0 ),
        .D(\interBank_port0_7[2][18]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [18]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][19] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][23]_i_1_n_0 ),
        .D(\interBank_port0_7[2][19]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [19]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][1] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][7]_i_1_n_0 ),
        .D(BRAM_PORTB_0_dout[1]),
        .Q(\interBank_port0_7_reg[2][31]_0 [1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][20] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][23]_i_1_n_0 ),
        .D(\interBank_port0_7[2][20]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [20]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][21] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][23]_i_1_n_0 ),
        .D(\interBank_port0_7[2][21]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [21]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][22] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][23]_i_1_n_0 ),
        .D(\interBank_port0_7[2][22]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [22]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][23] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][23]_i_1_n_0 ),
        .D(\interBank_port0_7[2][23]_i_2_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [23]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][24] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[2][24]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [24]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][25] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[2][25]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [25]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][26] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[2][26]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [26]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][27] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[2][27]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [27]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][28] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[2][28]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [28]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][29] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[2][29]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [29]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][2] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][7]_i_1_n_0 ),
        .D(BRAM_PORTB_0_dout[2]),
        .Q(\interBank_port0_7_reg[2][31]_0 [2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][30] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[2][30]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [30]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][31] 
       (.C(CLK),
        .CE(1'b1),
        .D(\interBank_port0_7[2][31]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [31]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][3] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][7]_i_1_n_0 ),
        .D(BRAM_PORTB_0_dout[3]),
        .Q(\interBank_port0_7_reg[2][31]_0 [3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][4] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][7]_i_1_n_0 ),
        .D(BRAM_PORTB_0_dout[4]),
        .Q(\interBank_port0_7_reg[2][31]_0 [4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][5] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][7]_i_1_n_0 ),
        .D(BRAM_PORTB_0_dout[5]),
        .Q(\interBank_port0_7_reg[2][31]_0 [5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][6] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][7]_i_1_n_0 ),
        .D(BRAM_PORTB_0_dout[6]),
        .Q(\interBank_port0_7_reg[2][31]_0 [6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][7] 
       (.C(CLK),
        .CE(\interBank_port0_7[2][7]_i_1_n_0 ),
        .D(BRAM_PORTB_0_dout[7]),
        .Q(\interBank_port0_7_reg[2][31]_0 [7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][8] 
       (.C(CLK),
        .CE(offset_cnt[1]),
        .D(\interBank_port0_7[2][8]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \interBank_port0_7_reg[2][9] 
       (.C(CLK),
        .CE(offset_cnt[1]),
        .D(\interBank_port0_7[2][9]_i_1_n_0 ),
        .Q(\interBank_port0_7_reg[2][31]_0 [9]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \offset_cnt[0]_i_1 
       (.I0(offset_cnt[0]),
        .O(\offset_cnt[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \offset_cnt[1]_i_1 
       (.I0(offset_cnt[0]),
        .I1(offset_cnt[1]),
        .O(\offset_cnt[1]_i_1_n_0 ));
  (* PHYS_OPT_MODIFIED = "PLACEMENT_OPT" *) 
  FDCE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \offset_cnt_reg[0] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(\^reset ),
        .D(\offset_cnt[0]_i_1_n_0 ),
        .Q(offset_cnt[0]));
  (* PHYS_OPT_MODIFIED = "PLACEMENT_OPT" *) 
  FDCE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \offset_cnt_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(\^reset ),
        .D(\offset_cnt[1]_i_1_n_0 ),
        .Q(offset_cnt[1]));
  LUT1 #(
    .INIT(2'h1)) 
    \rom_read_addrA[1]_i_1 
       (.I0(BRAM_PORTB_0_addr[0]),
        .O(\rom_read_addrA[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rom_read_addrA[2]_i_1 
       (.I0(BRAM_PORTB_0_addr[0]),
        .I1(BRAM_PORTB_0_addr[1]),
        .O(\rom_read_addrA[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \rom_read_addrA[3]_i_1 
       (.I0(BRAM_PORTB_0_addr[0]),
        .I1(BRAM_PORTB_0_addr[1]),
        .I2(BRAM_PORTB_0_addr[2]),
        .O(\rom_read_addrA[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \rom_read_addrA[4]_i_1 
       (.I0(BRAM_PORTB_0_addr[1]),
        .I1(BRAM_PORTB_0_addr[0]),
        .I2(BRAM_PORTB_0_addr[2]),
        .I3(BRAM_PORTB_0_addr[3]),
        .O(\rom_read_addrA[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \rom_read_addrA[5]_i_1 
       (.I0(BRAM_PORTB_0_addr[2]),
        .I1(BRAM_PORTB_0_addr[0]),
        .I2(BRAM_PORTB_0_addr[1]),
        .I3(BRAM_PORTB_0_addr[3]),
        .I4(BRAM_PORTB_0_addr[4]),
        .O(\rom_read_addrA[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \rom_read_addrA[6]_i_1 
       (.I0(BRAM_PORTB_0_addr[3]),
        .I1(BRAM_PORTB_0_addr[1]),
        .I2(BRAM_PORTB_0_addr[0]),
        .I3(BRAM_PORTB_0_addr[2]),
        .I4(BRAM_PORTB_0_addr[4]),
        .I5(BRAM_PORTB_0_addr[5]),
        .O(\rom_read_addrA[6]_i_1_n_0 ));
  (* PHYS_OPT_MODIFIED = "PLACEMENT_OPT" *) 
  FDCE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rom_read_addrA_reg[1] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(\^reset ),
        .D(\rom_read_addrA[1]_i_1_n_0 ),
        .Q(BRAM_PORTB_0_addr[0]));
  (* PHYS_OPT_MODIFIED = "PLACEMENT_OPT" *) 
  FDCE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rom_read_addrA_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(\^reset ),
        .D(\rom_read_addrA[2]_i_1_n_0 ),
        .Q(BRAM_PORTB_0_addr[1]));
  (* PHYS_OPT_MODIFIED = "PLACEMENT_OPT" *) 
  FDCE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rom_read_addrA_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(\^reset ),
        .D(\rom_read_addrA[3]_i_1_n_0 ),
        .Q(BRAM_PORTB_0_addr[2]));
  (* PHYS_OPT_MODIFIED = "PLACEMENT_OPT" *) 
  FDCE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rom_read_addrA_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(\^reset ),
        .D(\rom_read_addrA[4]_i_1_n_0 ),
        .Q(BRAM_PORTB_0_addr[3]));
  (* PHYS_OPT_MODIFIED = "PLACEMENT_OPT" *) 
  FDCE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rom_read_addrA_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(\^reset ),
        .D(\rom_read_addrA[5]_i_1_n_0 ),
        .Q(BRAM_PORTB_0_addr[4]));
  (* PHYS_OPT_MODIFIED = "PLACEMENT_OPT" *) 
  FDCE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \rom_read_addrA_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .CLR(\^reset ),
        .D(\rom_read_addrA[6]_i_1_n_0 ),
        .Q(BRAM_PORTB_0_addr[5]));
endmodule

module decomp_clk_gen
   (clk_gate,
    m_clk,
    en_IBUF,
    en_reg,
    clk_out1_0,
    SR);
  output clk_gate;
  output m_clk;
  input en_IBUF;
  input en_reg;
  input clk_out1_0;
  input [0:0]SR;

  wire [0:0]SR;
  wire clk_gate;
  wire clk_out1_0;
  wire [3:0]cnt;
  wire \cnt[0]_i_1_n_0 ;
  wire \cnt[1]_i_1_n_0 ;
  wire \cnt[2]_i_1_n_0 ;
  wire \cnt[3]_i_2_n_0 ;
  wire en_IBUF;
  wire en_reg;
  wire m_clk;

  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h007F)) 
    \cnt[0]_i_1 
       (.I0(cnt[1]),
        .I1(cnt[2]),
        .I2(cnt[3]),
        .I3(cnt[0]),
        .O(\cnt[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h2666)) 
    \cnt[1]_i_1 
       (.I0(cnt[0]),
        .I1(cnt[1]),
        .I2(cnt[2]),
        .I3(cnt[3]),
        .O(\cnt[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h3878)) 
    \cnt[2]_i_1 
       (.I0(cnt[0]),
        .I1(cnt[1]),
        .I2(cnt[2]),
        .I3(cnt[3]),
        .O(\cnt[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h3F80)) 
    \cnt[3]_i_2 
       (.I0(cnt[0]),
        .I1(cnt[1]),
        .I2(cnt[2]),
        .I3(cnt[3]),
        .O(\cnt[3]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[0] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(\cnt[0]_i_1_n_0 ),
        .Q(cnt[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[1] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(\cnt[1]_i_1_n_0 ),
        .Q(cnt[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[2] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(\cnt[2]_i_1_n_0 ),
        .Q(cnt[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[3] 
       (.C(clk_out1_0),
        .CE(1'b1),
        .D(\cnt[3]_i_2_n_0 ),
        .Q(cnt[3]),
        .R(SR));
  LUT2 #(
    .INIT(4'h8)) 
    \ram_sel[1]_i_2 
       (.I0(m_clk),
        .I1(en_IBUF),
        .O(clk_gate));
  LUT6 #(
    .INIT(64'h0000000080000000)) 
    \ram_sel[1]_i_3 
       (.I0(en_reg),
        .I1(cnt[2]),
        .I2(cnt[1]),
        .I3(clk_out1_0),
        .I4(cnt[3]),
        .I5(cnt[0]),
        .O(m_clk));
endmodule

module ib_distributed_ram_bank
   (\t_c_bankA[0]_3 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[3] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[0]_3 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[3] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[3] ;
  wire [3:0]\t_c_bankA[0]_3 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [3:2]),
        .DIB(\ram_write_data[3] [3:2]),
        .DIC(\ram_write_data[3] [3:2]),
        .DID(\ram_write_data[3] [3:2]),
        .DOA(\t_c_bankA[0]_3 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [1:0]),
        .DIB(\ram_write_data[3] [1:0]),
        .DIC(\ram_write_data[3] [1:0]),
        .DID(\ram_write_data[3] [1:0]),
        .DOA(\t_c_bankA[0]_3 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_10
   (\t_c_bankA[0]__0 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[2] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[0]__0 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[2] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[2] ;
  wire [3:0]\t_c_bankA[0]__0 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [3:2]),
        .DIB(\ram_write_data[2] [3:2]),
        .DIC(\ram_write_data[2] [3:2]),
        .DID(\ram_write_data[2] [3:2]),
        .DOA(\t_c_bankA[0]__0 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [1:0]),
        .DIB(\ram_write_data[2] [1:0]),
        .DIC(\ram_write_data[2] [1:0]),
        .DID(\ram_write_data[2] [1:0]),
        .DOA(\t_c_bankA[0]__0 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_11
   (\t_c_bankA[1]__0 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[2] ,
    ADDRA,
    ADDRD,
    \page_addr_ram2_reg[4]_0[0]_repN_alias );
  output [3:0]\t_c_bankA[1]__0 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[2] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;
  input \page_addr_ram2_reg[4]_0[0]_repN_alias ;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire \page_addr_ram2_reg[4]_0[0]_repN_alias ;
  wire [3:0]\ram_write_data[2] ;
  wire [3:0]\t_c_bankA[1]__0 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA({ADDRA[4:1],\page_addr_ram2_reg[4]_0[0]_repN_alias }),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [3:2]),
        .DIB(\ram_write_data[2] [3:2]),
        .DIC(\ram_write_data[2] [3:2]),
        .DID(\ram_write_data[2] [3:2]),
        .DOA(\t_c_bankA[1]__0 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [1:0]),
        .DIB(\ram_write_data[2] [1:0]),
        .DIC(\ram_write_data[2] [1:0]),
        .DID(\ram_write_data[2] [1:0]),
        .DOA(\t_c_bankA[1]__0 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_12
   (\t_c_bankA[2]__0 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[2] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[2]__0 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[2] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[2] ;
  wire [3:0]\t_c_bankA[2]__0 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [3:2]),
        .DIB(\ram_write_data[2] [3:2]),
        .DIC(\ram_write_data[2] [3:2]),
        .DID(\ram_write_data[2] [3:2]),
        .DOA(\t_c_bankA[2]__0 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [1:0]),
        .DIB(\ram_write_data[2] [1:0]),
        .DIC(\ram_write_data[2] [1:0]),
        .DID(\ram_write_data[2] [1:0]),
        .DOA(\t_c_bankA[2]__0 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_13
   (t_c_bankA__27,
    RAM32M_inst_0_i_11,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[2] ,
    ADDRA,
    ADDRD,
    t_c_bankA__27_0,
    \t_c_0_OBUF[0]_inst_i_2 ,
    \t_c_bankA[2]__0 ,
    \t_c_bankA[1]__0 ,
    \t_c_bankA[0]__0 ,
    \t_c_0_OBUF[0]_inst_i_2_0 ,
    \t_c_0_OBUF[0]_inst_i_1 ,
    RAM32M_inst_1_0);
  output [2:0]t_c_bankA__27;
  output [0:0]RAM32M_inst_0_i_11;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[2] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;
  input [2:0]t_c_bankA__27_0;
  input \t_c_0_OBUF[0]_inst_i_2 ;
  input [3:0]\t_c_bankA[2]__0 ;
  input [3:0]\t_c_bankA[1]__0 ;
  input [3:0]\t_c_bankA[0]__0 ;
  input \t_c_0_OBUF[0]_inst_i_2_0 ;
  input \t_c_0_OBUF[0]_inst_i_1 ;
  input RAM32M_inst_1_0;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire RAM32M_inst_0_i_10_n_0;
  wire [0:0]RAM32M_inst_0_i_11;
  wire RAM32M_inst_1_0;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[2] ;
  wire \t_c_0_OBUF[0]_inst_i_1 ;
  wire \t_c_0_OBUF[0]_inst_i_2 ;
  wire \t_c_0_OBUF[0]_inst_i_2_0 ;
  wire \t_c_0_OBUF[3]_inst_i_11_n_0 ;
  wire \t_c_0_OBUF[3]_inst_i_5_n_0 ;
  wire \t_c_0_OBUF[3]_inst_i_9_n_0 ;
  wire [3:0]\t_c_bankA[0]__0 ;
  wire [3:0]\t_c_bankA[1]__0 ;
  wire [3:0]\t_c_bankA[2]__0 ;
  wire [3:0]\t_c_bankA[3]_12 ;
  wire [2:0]t_c_bankA__27;
  wire [2:0]t_c_bankA__27_0;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [3:2]),
        .DIB(\ram_write_data[2] [3:2]),
        .DIC(\ram_write_data[2] [3:2]),
        .DID(\ram_write_data[2] [3:2]),
        .DOA(\t_c_bankA[3]_12 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_10
       (.I0(\t_c_bankA[3]_12 [3]),
        .I1(\t_c_bankA[2]__0 [3]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[1]__0 [3]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[0]__0 [3]),
        .O(RAM32M_inst_0_i_10_n_0));
  MUXF7 RAM32M_inst_0_i_8
       (.I0(RAM32M_inst_0_i_10_n_0),
        .I1(RAM32M_inst_1_0),
        .O(RAM32M_inst_0_i_11),
        .S(t_c_bankA__27_0[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [1:0]),
        .DIB(\ram_write_data[2] [1:0]),
        .DIC(\ram_write_data[2] [1:0]),
        .DID(\ram_write_data[2] [1:0]),
        .DOA(\t_c_bankA[3]_12 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \t_c_0_OBUF[3]_inst_i_11 
       (.I0(\t_c_bankA[3]_12 [0]),
        .I1(\t_c_bankA[2]__0 [0]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[1]__0 [0]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[0]__0 [0]),
        .O(\t_c_0_OBUF[3]_inst_i_11_n_0 ));
  MUXF7 \t_c_0_OBUF[3]_inst_i_2 
       (.I0(\t_c_0_OBUF[3]_inst_i_5_n_0 ),
        .I1(\t_c_0_OBUF[0]_inst_i_1 ),
        .O(t_c_bankA__27[2]),
        .S(t_c_bankA__27_0[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \t_c_0_OBUF[3]_inst_i_5 
       (.I0(\t_c_bankA[3]_12 [2]),
        .I1(\t_c_bankA[2]__0 [2]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[1]__0 [2]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[0]__0 [2]),
        .O(\t_c_0_OBUF[3]_inst_i_5_n_0 ));
  MUXF7 \t_c_0_OBUF[3]_inst_i_7 
       (.I0(\t_c_0_OBUF[3]_inst_i_9_n_0 ),
        .I1(\t_c_0_OBUF[0]_inst_i_2_0 ),
        .O(t_c_bankA__27[1]),
        .S(t_c_bankA__27_0[2]));
  MUXF7 \t_c_0_OBUF[3]_inst_i_8 
       (.I0(\t_c_0_OBUF[3]_inst_i_11_n_0 ),
        .I1(\t_c_0_OBUF[0]_inst_i_2 ),
        .O(t_c_bankA__27[0]),
        .S(t_c_bankA__27_0[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \t_c_0_OBUF[3]_inst_i_9 
       (.I0(\t_c_bankA[3]_12 [1]),
        .I1(\t_c_bankA[2]__0 [1]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[1]__0 [1]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[0]__0 [1]),
        .O(\t_c_0_OBUF[3]_inst_i_9_n_0 ));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_14
   (\t_c_bankA[4]_16 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[2] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[4]_16 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[2] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[2] ;
  wire [3:0]\t_c_bankA[4]_16 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [3:2]),
        .DIB(\ram_write_data[2] [3:2]),
        .DIC(\ram_write_data[2] [3:2]),
        .DID(\ram_write_data[2] [3:2]),
        .DOA(\t_c_bankA[4]_16 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [1:0]),
        .DIB(\ram_write_data[2] [1:0]),
        .DIC(\ram_write_data[2] [1:0]),
        .DID(\ram_write_data[2] [1:0]),
        .DOA(\t_c_bankA[4]_16 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_15
   (\t_c_bankA[5]_20 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[2] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[5]_20 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[2] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[2] ;
  wire [3:0]\t_c_bankA[5]_20 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [3:2]),
        .DIB(\ram_write_data[2] [3:2]),
        .DIC(\ram_write_data[2] [3:2]),
        .DID(\ram_write_data[2] [3:2]),
        .DOA(\t_c_bankA[5]_20 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [1:0]),
        .DIB(\ram_write_data[2] [1:0]),
        .DIC(\ram_write_data[2] [1:0]),
        .DID(\ram_write_data[2] [1:0]),
        .DOA(\t_c_bankA[5]_20 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_16
   (\t_c_bankA[6]_24 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[2] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[6]_24 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[2] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[2] ;
  wire [3:0]\t_c_bankA[6]_24 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [3:2]),
        .DIB(\ram_write_data[2] [3:2]),
        .DIC(\ram_write_data[2] [3:2]),
        .DID(\ram_write_data[2] [3:2]),
        .DOA(\t_c_bankA[6]_24 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [1:0]),
        .DIB(\ram_write_data[2] [1:0]),
        .DIC(\ram_write_data[2] [1:0]),
        .DID(\ram_write_data[2] [1:0]),
        .DOA(\t_c_bankA[6]_24 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_17
   (RAM32M_inst_1_0,
    RAM32M_inst_1_1,
    RAM32M_inst_0_0,
    RAM32M_inst_0_1,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[2] ,
    ADDRA,
    ADDRD,
    \t_c_bankA[6]_24 ,
    t_c_bankA__27_0,
    \t_c_bankA[5]_20 ,
    \t_c_bankA[4]_16 );
  output RAM32M_inst_1_0;
  output RAM32M_inst_1_1;
  output RAM32M_inst_0_0;
  output RAM32M_inst_0_1;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[2] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;
  input [3:0]\t_c_bankA[6]_24 ;
  input [1:0]t_c_bankA__27_0;
  input [3:0]\t_c_bankA[5]_20 ;
  input [3:0]\t_c_bankA[4]_16 ;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire RAM32M_inst_0_0;
  wire RAM32M_inst_0_1;
  wire RAM32M_inst_1_0;
  wire RAM32M_inst_1_1;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[2] ;
  wire [3:0]\t_c_bankA[4]_16 ;
  wire [3:0]\t_c_bankA[5]_20 ;
  wire [3:0]\t_c_bankA[6]_24 ;
  wire [3:0]\t_c_bankA[7]_28 ;
  wire [1:0]t_c_bankA__27_0;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [3:2]),
        .DIB(\ram_write_data[2] [3:2]),
        .DIC(\ram_write_data[2] [3:2]),
        .DID(\ram_write_data[2] [3:2]),
        .DOA(\t_c_bankA[7]_28 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_11
       (.I0(\t_c_bankA[7]_28 [3]),
        .I1(\t_c_bankA[6]_24 [3]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[5]_20 [3]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[4]_16 [3]),
        .O(RAM32M_inst_0_1));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[2] [1:0]),
        .DIB(\ram_write_data[2] [1:0]),
        .DIC(\ram_write_data[2] [1:0]),
        .DID(\ram_write_data[2] [1:0]),
        .DOA(\t_c_bankA[7]_28 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \t_c_0_OBUF[3]_inst_i_10 
       (.I0(\t_c_bankA[7]_28 [1]),
        .I1(\t_c_bankA[6]_24 [1]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[5]_20 [1]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[4]_16 [1]),
        .O(RAM32M_inst_1_1));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \t_c_0_OBUF[3]_inst_i_12 
       (.I0(\t_c_bankA[7]_28 [0]),
        .I1(\t_c_bankA[6]_24 [0]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[5]_20 [0]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[4]_16 [0]),
        .O(RAM32M_inst_1_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \t_c_0_OBUF[3]_inst_i_6 
       (.I0(\t_c_bankA[7]_28 [2]),
        .I1(\t_c_bankA[6]_24 [2]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[5]_20 [2]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[4]_16 [2]),
        .O(RAM32M_inst_0_0));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_18
   (\t_c_bankA[0]__0 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[1] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[0]__0 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[1] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[1] ;
  wire [3:0]\t_c_bankA[0]__0 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [3:2]),
        .DIB(\ram_write_data[1] [3:2]),
        .DIC(\ram_write_data[1] [3:2]),
        .DID(\ram_write_data[1] [3:2]),
        .DOA(\t_c_bankA[0]__0 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [1:0]),
        .DIB(\ram_write_data[1] [1:0]),
        .DIC(\ram_write_data[1] [1:0]),
        .DID(\ram_write_data[1] [1:0]),
        .DOA(\t_c_bankA[0]__0 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_19
   (\t_c_bankA[1]__0 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[1] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[1]__0 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[1] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[1] ;
  wire [3:0]\t_c_bankA[1]__0 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [3:2]),
        .DIB(\ram_write_data[1] [3:2]),
        .DIC(\ram_write_data[1] [3:2]),
        .DID(\ram_write_data[1] [3:2]),
        .DOA(\t_c_bankA[1]__0 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [1:0]),
        .DIB(\ram_write_data[1] [1:0]),
        .DIC(\ram_write_data[1] [1:0]),
        .DID(\ram_write_data[1] [1:0]),
        .DOA(\t_c_bankA[1]__0 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_20
   (\t_c_bankA[2]__0 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[1] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[2]__0 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[1] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[1] ;
  wire [3:0]\t_c_bankA[2]__0 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [3:2]),
        .DIB(\ram_write_data[1] [3:2]),
        .DIC(\ram_write_data[1] [3:2]),
        .DID(\ram_write_data[1] [3:2]),
        .DOA(\t_c_bankA[2]__0 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [1:0]),
        .DIB(\ram_write_data[1] [1:0]),
        .DIC(\ram_write_data[1] [1:0]),
        .DID(\ram_write_data[1] [1:0]),
        .DOA(\t_c_bankA[2]__0 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_21
   (t_c_bankA__27,
    RAM32M_inst_0_i_11__0,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[1] ,
    ADDRA,
    ADDRD,
    t_c_bankA__27_0,
    \t_c_0_OBUF[3]_inst_i_11 ,
    \t_c_bankA[2]__0 ,
    \t_c_bankA[1]__0 ,
    \t_c_bankA[0]__0 ,
    \t_c_0_OBUF[3]_inst_i_11_0 ,
    \t_c_0_OBUF[3]_inst_i_8 ,
    RAM32M_inst_1_0);
  output [2:0]t_c_bankA__27;
  output [0:0]RAM32M_inst_0_i_11__0;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[1] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;
  input [2:0]t_c_bankA__27_0;
  input \t_c_0_OBUF[3]_inst_i_11 ;
  input [3:0]\t_c_bankA[2]__0 ;
  input [3:0]\t_c_bankA[1]__0 ;
  input [3:0]\t_c_bankA[0]__0 ;
  input \t_c_0_OBUF[3]_inst_i_11_0 ;
  input \t_c_0_OBUF[3]_inst_i_8 ;
  input RAM32M_inst_1_0;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire RAM32M_inst_0_i_10__0_n_0;
  wire [0:0]RAM32M_inst_0_i_11__0;
  wire RAM32M_inst_0_i_12_n_0;
  wire RAM32M_inst_0_i_16_n_0;
  wire RAM32M_inst_0_i_18_n_0;
  wire RAM32M_inst_1_0;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[1] ;
  wire \t_c_0_OBUF[3]_inst_i_11 ;
  wire \t_c_0_OBUF[3]_inst_i_11_0 ;
  wire \t_c_0_OBUF[3]_inst_i_8 ;
  wire [3:0]\t_c_bankA[0]__0 ;
  wire [3:0]\t_c_bankA[1]__0 ;
  wire [3:0]\t_c_bankA[2]__0 ;
  wire [3:0]\t_c_bankA[3]_12 ;
  wire [2:0]t_c_bankA__27;
  wire [2:0]t_c_bankA__27_0;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [3:2]),
        .DIB(\ram_write_data[1] [3:2]),
        .DIC(\ram_write_data[1] [3:2]),
        .DID(\ram_write_data[1] [3:2]),
        .DOA(\t_c_bankA[3]_12 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_10__0
       (.I0(\t_c_bankA[3]_12 [3]),
        .I1(\t_c_bankA[2]__0 [3]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[1]__0 [3]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[0]__0 [3]),
        .O(RAM32M_inst_0_i_10__0_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_12
       (.I0(\t_c_bankA[3]_12 [2]),
        .I1(\t_c_bankA[2]__0 [2]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[1]__0 [2]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[0]__0 [2]),
        .O(RAM32M_inst_0_i_12_n_0));
  MUXF7 RAM32M_inst_0_i_14
       (.I0(RAM32M_inst_0_i_16_n_0),
        .I1(\t_c_0_OBUF[3]_inst_i_11_0 ),
        .O(t_c_bankA__27[1]),
        .S(t_c_bankA__27_0[2]));
  MUXF7 RAM32M_inst_0_i_15
       (.I0(RAM32M_inst_0_i_18_n_0),
        .I1(\t_c_0_OBUF[3]_inst_i_11 ),
        .O(t_c_bankA__27[0]),
        .S(t_c_bankA__27_0[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_16
       (.I0(\t_c_bankA[3]_12 [1]),
        .I1(\t_c_bankA[2]__0 [1]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[1]__0 [1]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[0]__0 [1]),
        .O(RAM32M_inst_0_i_16_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_18
       (.I0(\t_c_bankA[3]_12 [0]),
        .I1(\t_c_bankA[2]__0 [0]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[1]__0 [0]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[0]__0 [0]),
        .O(RAM32M_inst_0_i_18_n_0));
  MUXF7 RAM32M_inst_0_i_8__0
       (.I0(RAM32M_inst_0_i_10__0_n_0),
        .I1(RAM32M_inst_1_0),
        .O(RAM32M_inst_0_i_11__0),
        .S(t_c_bankA__27_0[2]));
  MUXF7 RAM32M_inst_0_i_9
       (.I0(RAM32M_inst_0_i_12_n_0),
        .I1(\t_c_0_OBUF[3]_inst_i_8 ),
        .O(t_c_bankA__27[2]),
        .S(t_c_bankA__27_0[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [1:0]),
        .DIB(\ram_write_data[1] [1:0]),
        .DIC(\ram_write_data[1] [1:0]),
        .DID(\ram_write_data[1] [1:0]),
        .DOA(\t_c_bankA[3]_12 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_22
   (\t_c_bankA[4]_16 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[1] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[4]_16 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[1] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[1] ;
  wire [3:0]\t_c_bankA[4]_16 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [3:2]),
        .DIB(\ram_write_data[1] [3:2]),
        .DIC(\ram_write_data[1] [3:2]),
        .DID(\ram_write_data[1] [3:2]),
        .DOA(\t_c_bankA[4]_16 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [1:0]),
        .DIB(\ram_write_data[1] [1:0]),
        .DIC(\ram_write_data[1] [1:0]),
        .DID(\ram_write_data[1] [1:0]),
        .DOA(\t_c_bankA[4]_16 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_23
   (\t_c_bankA[5]_20 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[1] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[5]_20 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[1] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[1] ;
  wire [3:0]\t_c_bankA[5]_20 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [3:2]),
        .DIB(\ram_write_data[1] [3:2]),
        .DIC(\ram_write_data[1] [3:2]),
        .DID(\ram_write_data[1] [3:2]),
        .DOA(\t_c_bankA[5]_20 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [1:0]),
        .DIB(\ram_write_data[1] [1:0]),
        .DIC(\ram_write_data[1] [1:0]),
        .DID(\ram_write_data[1] [1:0]),
        .DOA(\t_c_bankA[5]_20 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_24
   (\t_c_bankA[6]_24 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[1] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[6]_24 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[1] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[1] ;
  wire [3:0]\t_c_bankA[6]_24 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [3:2]),
        .DIB(\ram_write_data[1] [3:2]),
        .DIC(\ram_write_data[1] [3:2]),
        .DID(\ram_write_data[1] [3:2]),
        .DOA(\t_c_bankA[6]_24 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [1:0]),
        .DIB(\ram_write_data[1] [1:0]),
        .DIC(\ram_write_data[1] [1:0]),
        .DID(\ram_write_data[1] [1:0]),
        .DOA(\t_c_bankA[6]_24 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_25
   (RAM32M_inst_1_0,
    RAM32M_inst_1_1,
    RAM32M_inst_0_0,
    RAM32M_inst_0_1,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[1] ,
    ADDRA,
    ADDRD,
    \t_c_bankA[6]_24 ,
    t_c_bankA__27_0,
    \t_c_bankA[5]_20 ,
    \t_c_bankA[4]_16 );
  output RAM32M_inst_1_0;
  output RAM32M_inst_1_1;
  output RAM32M_inst_0_0;
  output RAM32M_inst_0_1;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[1] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;
  input [3:0]\t_c_bankA[6]_24 ;
  input [1:0]t_c_bankA__27_0;
  input [3:0]\t_c_bankA[5]_20 ;
  input [3:0]\t_c_bankA[4]_16 ;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire RAM32M_inst_0_0;
  wire RAM32M_inst_0_1;
  wire RAM32M_inst_1_0;
  wire RAM32M_inst_1_1;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[1] ;
  wire [3:0]\t_c_bankA[4]_16 ;
  wire [3:0]\t_c_bankA[5]_20 ;
  wire [3:0]\t_c_bankA[6]_24 ;
  wire [3:0]\t_c_bankA[7]_28 ;
  wire [1:0]t_c_bankA__27_0;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [3:2]),
        .DIB(\ram_write_data[1] [3:2]),
        .DIC(\ram_write_data[1] [3:2]),
        .DID(\ram_write_data[1] [3:2]),
        .DOA(\t_c_bankA[7]_28 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_11__0
       (.I0(\t_c_bankA[7]_28 [3]),
        .I1(\t_c_bankA[6]_24 [3]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[5]_20 [3]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[4]_16 [3]),
        .O(RAM32M_inst_0_1));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_13
       (.I0(\t_c_bankA[7]_28 [2]),
        .I1(\t_c_bankA[6]_24 [2]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[5]_20 [2]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[4]_16 [2]),
        .O(RAM32M_inst_0_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_17
       (.I0(\t_c_bankA[7]_28 [1]),
        .I1(\t_c_bankA[6]_24 [1]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[5]_20 [1]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[4]_16 [1]),
        .O(RAM32M_inst_1_1));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_19
       (.I0(\t_c_bankA[7]_28 [0]),
        .I1(\t_c_bankA[6]_24 [0]),
        .I2(t_c_bankA__27_0[1]),
        .I3(\t_c_bankA[5]_20 [0]),
        .I4(t_c_bankA__27_0[0]),
        .I5(\t_c_bankA[4]_16 [0]),
        .O(RAM32M_inst_1_0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[1] [1:0]),
        .DIB(\ram_write_data[1] [1:0]),
        .DIC(\ram_write_data[1] [1:0]),
        .DID(\ram_write_data[1] [1:0]),
        .DOA(\t_c_bankA[7]_28 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_26
   (\t_c_bankA[0]__0 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[0] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[0]__0 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[0] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[0] ;
  wire [3:0]\t_c_bankA[0]__0 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [3:2]),
        .DIB(\ram_write_data[0] [3:2]),
        .DIC(\ram_write_data[0] [3:2]),
        .DID(\ram_write_data[0] [3:2]),
        .DOA(\t_c_bankA[0]__0 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [1:0]),
        .DIB(\ram_write_data[0] [1:0]),
        .DIC(\ram_write_data[0] [1:0]),
        .DID(\ram_write_data[0] [1:0]),
        .DOA(\t_c_bankA[0]__0 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_27
   (\t_c_bankA[1]__0 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[0] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[1]__0 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[0] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[0] ;
  wire [3:0]\t_c_bankA[1]__0 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [3:2]),
        .DIB(\ram_write_data[0] [3:2]),
        .DIC(\ram_write_data[0] [3:2]),
        .DID(\ram_write_data[0] [3:2]),
        .DOA(\t_c_bankA[1]__0 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [1:0]),
        .DIB(\ram_write_data[0] [1:0]),
        .DIC(\ram_write_data[0] [1:0]),
        .DID(\ram_write_data[0] [1:0]),
        .DOA(\t_c_bankA[1]__0 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_28
   (\t_c_bankA[2]__0 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[0] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[2]__0 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[0] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[0] ;
  wire [3:0]\t_c_bankA[2]__0 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [3:2]),
        .DIB(\ram_write_data[0] [3:2]),
        .DIC(\ram_write_data[0] [3:2]),
        .DID(\ram_write_data[0] [3:2]),
        .DOA(\t_c_bankA[2]__0 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [1:0]),
        .DIB(\ram_write_data[0] [1:0]),
        .DIC(\ram_write_data[0] [1:0]),
        .DID(\ram_write_data[0] [1:0]),
        .DOA(\t_c_bankA[2]__0 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_29
   (t_c_bankA__27,
    \y1[2] ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[0] ,
    ADDRA,
    ADDRD,
    y1_IBUF,
    RAM32M_inst_0_i_18,
    \t_c_bankA[2]__0 ,
    \t_c_bankA[1]__0 ,
    \t_c_bankA[0]__0 ,
    RAM32M_inst_0_i_18_0,
    RAM32M_inst_0_i_15,
    RAM32M_inst_1_0);
  output [2:0]t_c_bankA__27;
  output [0:0]\y1[2] ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[0] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;
  input [2:0]y1_IBUF;
  input RAM32M_inst_0_i_18;
  input [3:0]\t_c_bankA[2]__0 ;
  input [3:0]\t_c_bankA[1]__0 ;
  input [3:0]\t_c_bankA[0]__0 ;
  input RAM32M_inst_0_i_18_0;
  input RAM32M_inst_0_i_15;
  input RAM32M_inst_1_0;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire RAM32M_inst_0_i_12__0_n_0;
  wire RAM32M_inst_0_i_15;
  wire RAM32M_inst_0_i_16__0_n_0;
  wire RAM32M_inst_0_i_18;
  wire RAM32M_inst_0_i_18_0;
  wire RAM32M_inst_0_i_18__0_n_0;
  wire RAM32M_inst_0_i_9__1_n_0;
  wire RAM32M_inst_1_0;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[0] ;
  wire [3:0]\t_c_bankA[0]__0 ;
  wire [3:0]\t_c_bankA[1]__0 ;
  wire [3:0]\t_c_bankA[2]__0 ;
  wire [3:0]\t_c_bankA[3]_12 ;
  wire [2:0]t_c_bankA__27;
  wire [0:0]\y1[2] ;
  wire [2:0]y1_IBUF;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [3:2]),
        .DIB(\ram_write_data[0] [3:2]),
        .DIC(\ram_write_data[0] [3:2]),
        .DID(\ram_write_data[0] [3:2]),
        .DOA(\t_c_bankA[3]_12 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_12__0
       (.I0(\t_c_bankA[3]_12 [2]),
        .I1(\t_c_bankA[2]__0 [2]),
        .I2(y1_IBUF[1]),
        .I3(\t_c_bankA[1]__0 [2]),
        .I4(y1_IBUF[0]),
        .I5(\t_c_bankA[0]__0 [2]),
        .O(RAM32M_inst_0_i_12__0_n_0));
  MUXF7 RAM32M_inst_0_i_14__0
       (.I0(RAM32M_inst_0_i_16__0_n_0),
        .I1(RAM32M_inst_0_i_18_0),
        .O(t_c_bankA__27[1]),
        .S(y1_IBUF[2]));
  MUXF7 RAM32M_inst_0_i_15__0
       (.I0(RAM32M_inst_0_i_18__0_n_0),
        .I1(RAM32M_inst_0_i_18),
        .O(t_c_bankA__27[0]),
        .S(y1_IBUF[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_16__0
       (.I0(\t_c_bankA[3]_12 [1]),
        .I1(\t_c_bankA[2]__0 [1]),
        .I2(y1_IBUF[1]),
        .I3(\t_c_bankA[1]__0 [1]),
        .I4(y1_IBUF[0]),
        .I5(\t_c_bankA[0]__0 [1]),
        .O(RAM32M_inst_0_i_16__0_n_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_18__0
       (.I0(\t_c_bankA[3]_12 [0]),
        .I1(\t_c_bankA[2]__0 [0]),
        .I2(y1_IBUF[1]),
        .I3(\t_c_bankA[1]__0 [0]),
        .I4(y1_IBUF[0]),
        .I5(\t_c_bankA[0]__0 [0]),
        .O(RAM32M_inst_0_i_18__0_n_0));
  MUXF7 RAM32M_inst_0_i_8__1
       (.I0(RAM32M_inst_0_i_9__1_n_0),
        .I1(RAM32M_inst_1_0),
        .O(\y1[2] ),
        .S(y1_IBUF[2]));
  MUXF7 RAM32M_inst_0_i_9__0
       (.I0(RAM32M_inst_0_i_12__0_n_0),
        .I1(RAM32M_inst_0_i_15),
        .O(t_c_bankA__27[2]),
        .S(y1_IBUF[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_9__1
       (.I0(\t_c_bankA[3]_12 [3]),
        .I1(\t_c_bankA[2]__0 [3]),
        .I2(y1_IBUF[1]),
        .I3(\t_c_bankA[1]__0 [3]),
        .I4(y1_IBUF[0]),
        .I5(\t_c_bankA[0]__0 [3]),
        .O(RAM32M_inst_0_i_9__1_n_0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [1:0]),
        .DIB(\ram_write_data[0] [1:0]),
        .DIC(\ram_write_data[0] [1:0]),
        .DID(\ram_write_data[0] [1:0]),
        .DOA(\t_c_bankA[3]_12 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_3
   (\t_c_bankA[1]_7 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[3] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[1]_7 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[3] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[3] ;
  wire [3:0]\t_c_bankA[1]_7 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [3:2]),
        .DIB(\ram_write_data[3] [3:2]),
        .DIC(\ram_write_data[3] [3:2]),
        .DID(\ram_write_data[3] [3:2]),
        .DOA(\t_c_bankA[1]_7 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [1:0]),
        .DIB(\ram_write_data[3] [1:0]),
        .DIC(\ram_write_data[3] [1:0]),
        .DID(\ram_write_data[3] [1:0]),
        .DOA(\t_c_bankA[1]_7 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_30
   (\t_c_bankA[4]_16 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[0] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[4]_16 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[0] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[0] ;
  wire [3:0]\t_c_bankA[4]_16 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [3:2]),
        .DIB(\ram_write_data[0] [3:2]),
        .DIC(\ram_write_data[0] [3:2]),
        .DID(\ram_write_data[0] [3:2]),
        .DOA(\t_c_bankA[4]_16 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [1:0]),
        .DIB(\ram_write_data[0] [1:0]),
        .DIC(\ram_write_data[0] [1:0]),
        .DID(\ram_write_data[0] [1:0]),
        .DOA(\t_c_bankA[4]_16 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_31
   (\t_c_bankA[5]_20 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[0] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[5]_20 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[0] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[0] ;
  wire [3:0]\t_c_bankA[5]_20 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [3:2]),
        .DIB(\ram_write_data[0] [3:2]),
        .DIC(\ram_write_data[0] [3:2]),
        .DID(\ram_write_data[0] [3:2]),
        .DOA(\t_c_bankA[5]_20 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [1:0]),
        .DIB(\ram_write_data[0] [1:0]),
        .DIC(\ram_write_data[0] [1:0]),
        .DID(\ram_write_data[0] [1:0]),
        .DOA(\t_c_bankA[5]_20 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_32
   (\t_c_bankA[6]_24 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[0] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[6]_24 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[0] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[0] ;
  wire [3:0]\t_c_bankA[6]_24 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [3:2]),
        .DIB(\ram_write_data[0] [3:2]),
        .DIC(\ram_write_data[0] [3:2]),
        .DID(\ram_write_data[0] [3:2]),
        .DOA(\t_c_bankA[6]_24 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [1:0]),
        .DIB(\ram_write_data[0] [1:0]),
        .DIC(\ram_write_data[0] [1:0]),
        .DID(\ram_write_data[0] [1:0]),
        .DOA(\t_c_bankA[6]_24 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_33
   (\y1[1] ,
    \y1[1]_0 ,
    \y1[1]_1 ,
    \y1[1]_2 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[0] ,
    ADDRA,
    ADDRD,
    \t_c_bankA[6]_24 ,
    y1_IBUF,
    \t_c_bankA[5]_20 ,
    \t_c_bankA[4]_16 );
  output \y1[1] ;
  output \y1[1]_0 ;
  output \y1[1]_1 ;
  output \y1[1]_2 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[0] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;
  input [3:0]\t_c_bankA[6]_24 ;
  input [1:0]y1_IBUF;
  input [3:0]\t_c_bankA[5]_20 ;
  input [3:0]\t_c_bankA[4]_16 ;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[0] ;
  wire [3:0]\t_c_bankA[4]_16 ;
  wire [3:0]\t_c_bankA[5]_20 ;
  wire [3:0]\t_c_bankA[6]_24 ;
  wire [3:0]\t_c_bankA[7]_28 ;
  wire \y1[1] ;
  wire \y1[1]_0 ;
  wire \y1[1]_1 ;
  wire \y1[1]_2 ;
  wire [1:0]y1_IBUF;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [3:2]),
        .DIB(\ram_write_data[0] [3:2]),
        .DIC(\ram_write_data[0] [3:2]),
        .DID(\ram_write_data[0] [3:2]),
        .DOA(\t_c_bankA[7]_28 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_10__1
       (.I0(\t_c_bankA[7]_28 [3]),
        .I1(\t_c_bankA[6]_24 [3]),
        .I2(y1_IBUF[1]),
        .I3(\t_c_bankA[5]_20 [3]),
        .I4(y1_IBUF[0]),
        .I5(\t_c_bankA[4]_16 [3]),
        .O(\y1[1]_2 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_13__0
       (.I0(\t_c_bankA[7]_28 [2]),
        .I1(\t_c_bankA[6]_24 [2]),
        .I2(y1_IBUF[1]),
        .I3(\t_c_bankA[5]_20 [2]),
        .I4(y1_IBUF[0]),
        .I5(\t_c_bankA[4]_16 [2]),
        .O(\y1[1]_1 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_17__0
       (.I0(\t_c_bankA[7]_28 [1]),
        .I1(\t_c_bankA[6]_24 [1]),
        .I2(y1_IBUF[1]),
        .I3(\t_c_bankA[5]_20 [1]),
        .I4(y1_IBUF[0]),
        .I5(\t_c_bankA[4]_16 [1]),
        .O(\y1[1]_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    RAM32M_inst_0_i_19__0
       (.I0(\t_c_bankA[7]_28 [0]),
        .I1(\t_c_bankA[6]_24 [0]),
        .I2(y1_IBUF[1]),
        .I3(\t_c_bankA[5]_20 [0]),
        .I4(y1_IBUF[0]),
        .I5(\t_c_bankA[4]_16 [0]),
        .O(\y1[1] ));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[0] [1:0]),
        .DIB(\ram_write_data[0] [1:0]),
        .DIC(\ram_write_data[0] [1:0]),
        .DID(\ram_write_data[0] [1:0]),
        .DOA(\t_c_bankA[7]_28 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_4
   (\t_c_bankA[2]_11 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[3] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[2]_11 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[3] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[3] ;
  wire [3:0]\t_c_bankA[2]_11 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [3:2]),
        .DIB(\ram_write_data[3] [3:2]),
        .DIC(\ram_write_data[3] [3:2]),
        .DID(\ram_write_data[3] [3:2]),
        .DOA(\t_c_bankA[2]_11 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [1:0]),
        .DIB(\ram_write_data[3] [1:0]),
        .DIC(\ram_write_data[3] [1:0]),
        .DID(\ram_write_data[3] [1:0]),
        .DOA(\t_c_bankA[2]_11 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_5
   (t_c_3_OBUF,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[3] ,
    ADDRA,
    ADDRD,
    t_c_bankA__27,
    \t_c_3[0] ,
    \t_c_bankA[2]_11 ,
    \t_c_bankA[1]_7 ,
    \t_c_bankA[0]_3 ,
    \t_c_3[1] ,
    \t_c_3[2] ,
    \t_c_3[3] );
  output [3:0]t_c_3_OBUF;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[3] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;
  input [2:0]t_c_bankA__27;
  input \t_c_3[0] ;
  input [3:0]\t_c_bankA[2]_11 ;
  input [3:0]\t_c_bankA[1]_7 ;
  input [3:0]\t_c_bankA[0]_3 ;
  input \t_c_3[1] ;
  input \t_c_3[2] ;
  input \t_c_3[3] ;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[3] ;
  wire \t_c_0_OBUF[0]_inst_i_2_n_0 ;
  wire \t_c_0_OBUF[1]_inst_i_2_n_0 ;
  wire \t_c_0_OBUF[2]_inst_i_2_n_0 ;
  wire \t_c_0_OBUF[3]_inst_i_3_n_0 ;
  wire \t_c_3[0] ;
  wire \t_c_3[1] ;
  wire \t_c_3[2] ;
  wire \t_c_3[3] ;
  wire [3:0]t_c_3_OBUF;
  wire [3:0]\t_c_bankA[0]_3 ;
  wire [3:0]\t_c_bankA[1]_7 ;
  wire [3:0]\t_c_bankA[2]_11 ;
  wire [3:0]\t_c_bankA[3]_15 ;
  wire [2:0]t_c_bankA__27;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [3:2]),
        .DIB(\ram_write_data[3] [3:2]),
        .DIC(\ram_write_data[3] [3:2]),
        .DID(\ram_write_data[3] [3:2]),
        .DOA(\t_c_bankA[3]_15 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [1:0]),
        .DIB(\ram_write_data[3] [1:0]),
        .DIC(\ram_write_data[3] [1:0]),
        .DID(\ram_write_data[3] [1:0]),
        .DOA(\t_c_bankA[3]_15 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  MUXF7 \t_c_0_OBUF[0]_inst_i_1 
       (.I0(\t_c_0_OBUF[0]_inst_i_2_n_0 ),
        .I1(\t_c_3[0] ),
        .O(t_c_3_OBUF[0]),
        .S(t_c_bankA__27[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \t_c_0_OBUF[0]_inst_i_2 
       (.I0(\t_c_bankA[3]_15 [0]),
        .I1(\t_c_bankA[2]_11 [0]),
        .I2(t_c_bankA__27[1]),
        .I3(\t_c_bankA[1]_7 [0]),
        .I4(t_c_bankA__27[0]),
        .I5(\t_c_bankA[0]_3 [0]),
        .O(\t_c_0_OBUF[0]_inst_i_2_n_0 ));
  MUXF7 \t_c_0_OBUF[1]_inst_i_1 
       (.I0(\t_c_0_OBUF[1]_inst_i_2_n_0 ),
        .I1(\t_c_3[1] ),
        .O(t_c_3_OBUF[1]),
        .S(t_c_bankA__27[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \t_c_0_OBUF[1]_inst_i_2 
       (.I0(\t_c_bankA[3]_15 [1]),
        .I1(\t_c_bankA[2]_11 [1]),
        .I2(t_c_bankA__27[1]),
        .I3(\t_c_bankA[1]_7 [1]),
        .I4(t_c_bankA__27[0]),
        .I5(\t_c_bankA[0]_3 [1]),
        .O(\t_c_0_OBUF[1]_inst_i_2_n_0 ));
  MUXF7 \t_c_0_OBUF[2]_inst_i_1 
       (.I0(\t_c_0_OBUF[2]_inst_i_2_n_0 ),
        .I1(\t_c_3[2] ),
        .O(t_c_3_OBUF[2]),
        .S(t_c_bankA__27[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \t_c_0_OBUF[2]_inst_i_2 
       (.I0(\t_c_bankA[3]_15 [2]),
        .I1(\t_c_bankA[2]_11 [2]),
        .I2(t_c_bankA__27[1]),
        .I3(\t_c_bankA[1]_7 [2]),
        .I4(t_c_bankA__27[0]),
        .I5(\t_c_bankA[0]_3 [2]),
        .O(\t_c_0_OBUF[2]_inst_i_2_n_0 ));
  MUXF7 \t_c_0_OBUF[3]_inst_i_1 
       (.I0(\t_c_0_OBUF[3]_inst_i_3_n_0 ),
        .I1(\t_c_3[3] ),
        .O(t_c_3_OBUF[3]),
        .S(t_c_bankA__27[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \t_c_0_OBUF[3]_inst_i_3 
       (.I0(\t_c_bankA[3]_15 [3]),
        .I1(\t_c_bankA[2]_11 [3]),
        .I2(t_c_bankA__27[1]),
        .I3(\t_c_bankA[1]_7 [3]),
        .I4(t_c_bankA__27[0]),
        .I5(\t_c_bankA[0]_3 [3]),
        .O(\t_c_0_OBUF[3]_inst_i_3_n_0 ));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_6
   (\t_c_bankA[4]_19 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[3] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[4]_19 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[3] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[3] ;
  wire [3:0]\t_c_bankA[4]_19 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [3:2]),
        .DIB(\ram_write_data[3] [3:2]),
        .DIC(\ram_write_data[3] [3:2]),
        .DID(\ram_write_data[3] [3:2]),
        .DOA(\t_c_bankA[4]_19 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [1:0]),
        .DIB(\ram_write_data[3] [1:0]),
        .DIC(\ram_write_data[3] [1:0]),
        .DID(\ram_write_data[3] [1:0]),
        .DOA(\t_c_bankA[4]_19 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_7
   (\t_c_bankA[5]_23 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[3] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[5]_23 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[3] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[3] ;
  wire [3:0]\t_c_bankA[5]_23 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [3:2]),
        .DIB(\ram_write_data[3] [3:2]),
        .DIC(\ram_write_data[3] [3:2]),
        .DID(\ram_write_data[3] [3:2]),
        .DOA(\t_c_bankA[5]_23 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [1:0]),
        .DIB(\ram_write_data[3] [1:0]),
        .DIC(\ram_write_data[3] [1:0]),
        .DID(\ram_write_data[3] [1:0]),
        .DOA(\t_c_bankA[5]_23 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_8
   (\t_c_bankA[6]_27 ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[3] ,
    ADDRA,
    ADDRD);
  output [3:0]\t_c_bankA[6]_27 ;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[3] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[3] ;
  wire [3:0]\t_c_bankA[6]_27 ;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [3:2]),
        .DIB(\ram_write_data[3] [3:2]),
        .DIC(\ram_write_data[3] [3:2]),
        .DID(\ram_write_data[3] [3:2]),
        .DOA(\t_c_bankA[6]_27 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [1:0]),
        .DIB(\ram_write_data[3] [1:0]),
        .DIC(\ram_write_data[3] [1:0]),
        .DID(\ram_write_data[3] [1:0]),
        .DOA(\t_c_bankA[6]_27 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
endmodule

(* ORIG_REF_NAME = "ib_distributed_ram_bank" *) 
module ib_distributed_ram_bank_9
   (RAM32M_inst_1_0,
    RAM32M_inst_1_1,
    RAM32M_inst_0_0,
    RAM32M_inst_0_1,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[3] ,
    ADDRA,
    ADDRD,
    \t_c_bankA[6]_27 ,
    t_c_bankA__27,
    \t_c_bankA[5]_23 ,
    \t_c_bankA[4]_19 );
  output RAM32M_inst_1_0;
  output RAM32M_inst_1_1;
  output RAM32M_inst_0_0;
  output RAM32M_inst_0_1;
  input clk_out1_0;
  input en_IBUF;
  input [3:0]\ram_write_data[3] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;
  input [3:0]\t_c_bankA[6]_27 ;
  input [1:0]t_c_bankA__27;
  input [3:0]\t_c_bankA[5]_23 ;
  input [3:0]\t_c_bankA[4]_19 ;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire RAM32M_inst_0_0;
  wire RAM32M_inst_0_1;
  wire RAM32M_inst_1_0;
  wire RAM32M_inst_1_1;
  wire clk_out1_0;
  wire en_IBUF;
  wire [3:0]\ram_write_data[3] ;
  wire [3:0]\t_c_bankA[4]_19 ;
  wire [3:0]\t_c_bankA[5]_23 ;
  wire [3:0]\t_c_bankA[6]_27 ;
  wire [3:0]\t_c_bankA[7]_31 ;
  wire [1:0]t_c_bankA__27;
  wire [1:0]NLW_RAM32M_inst_0_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_0_DOD_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOB_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOC_UNCONNECTED;
  wire [1:0]NLW_RAM32M_inst_1_DOD_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_0
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [3:2]),
        .DIB(\ram_write_data[3] [3:2]),
        .DIC(\ram_write_data[3] [3:2]),
        .DID(\ram_write_data[3] [3:2]),
        .DOA(\t_c_bankA[7]_31 [3:2]),
        .DOB(NLW_RAM32M_inst_0_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_0_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_0_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .IS_WCLK_INVERTED(1'b0)) 
    RAM32M_inst_1
       (.ADDRA(ADDRA),
        .ADDRB(ADDRD),
        .ADDRC(ADDRD),
        .ADDRD(ADDRD),
        .DIA(\ram_write_data[3] [1:0]),
        .DIB(\ram_write_data[3] [1:0]),
        .DIC(\ram_write_data[3] [1:0]),
        .DID(\ram_write_data[3] [1:0]),
        .DOA(\t_c_bankA[7]_31 [1:0]),
        .DOB(NLW_RAM32M_inst_1_DOB_UNCONNECTED[1:0]),
        .DOC(NLW_RAM32M_inst_1_DOC_UNCONNECTED[1:0]),
        .DOD(NLW_RAM32M_inst_1_DOD_UNCONNECTED[1:0]),
        .WCLK(clk_out1_0),
        .WE(en_IBUF));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \t_c_0_OBUF[0]_inst_i_3 
       (.I0(\t_c_bankA[7]_31 [0]),
        .I1(\t_c_bankA[6]_27 [0]),
        .I2(t_c_bankA__27[1]),
        .I3(\t_c_bankA[5]_23 [0]),
        .I4(t_c_bankA__27[0]),
        .I5(\t_c_bankA[4]_19 [0]),
        .O(RAM32M_inst_1_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \t_c_0_OBUF[1]_inst_i_3 
       (.I0(\t_c_bankA[7]_31 [1]),
        .I1(\t_c_bankA[6]_27 [1]),
        .I2(t_c_bankA__27[1]),
        .I3(\t_c_bankA[5]_23 [1]),
        .I4(t_c_bankA__27[0]),
        .I5(\t_c_bankA[4]_19 [1]),
        .O(RAM32M_inst_1_1));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \t_c_0_OBUF[2]_inst_i_3 
       (.I0(\t_c_bankA[7]_31 [2]),
        .I1(\t_c_bankA[6]_27 [2]),
        .I2(t_c_bankA__27[1]),
        .I3(\t_c_bankA[5]_23 [2]),
        .I4(t_c_bankA__27[0]),
        .I5(\t_c_bankA[4]_19 [2]),
        .O(RAM32M_inst_0_0));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \t_c_0_OBUF[3]_inst_i_4 
       (.I0(\t_c_bankA[7]_31 [3]),
        .I1(\t_c_bankA[6]_27 [3]),
        .I2(t_c_bankA__27[1]),
        .I3(\t_c_bankA[5]_23 [3]),
        .I4(t_c_bankA__27[0]),
        .I5(\t_c_bankA[4]_19 [3]),
        .O(RAM32M_inst_0_1));
endmodule

module ib_lut_ram
   (t_c_bankA__27,
    \y1[2] ,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[0] ,
    ADDRA,
    ADDRD,
    y1_IBUF);
  output [2:0]t_c_bankA__27;
  output [0:0]\y1[2] ;
  input clk_out1_0;
  input en_IBUF;
  input [31:0]\ram_write_data[0] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;
  input [2:0]y1_IBUF;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire bank_7_n_0;
  wire bank_7_n_1;
  wire bank_7_n_2;
  wire bank_7_n_3;
  wire clk_out1_0;
  wire en_IBUF;
  wire [31:0]\ram_write_data[0] ;
  wire [3:0]\t_c_bankA[0]__0 ;
  wire [3:0]\t_c_bankA[1]__0 ;
  wire [3:0]\t_c_bankA[2]__0 ;
  wire [3:0]\t_c_bankA[4]_16 ;
  wire [3:0]\t_c_bankA[5]_20 ;
  wire [3:0]\t_c_bankA[6]_24 ;
  wire [2:0]t_c_bankA__27;
  wire [0:0]\y1[2] ;
  wire [2:0]y1_IBUF;

  ib_distributed_ram_bank_26 bank_0
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[0] (\ram_write_data[0] [31:28]),
        .\t_c_bankA[0]__0 (\t_c_bankA[0]__0 ));
  ib_distributed_ram_bank_27 bank_1
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[0] (\ram_write_data[0] [27:24]),
        .\t_c_bankA[1]__0 (\t_c_bankA[1]__0 ));
  ib_distributed_ram_bank_28 bank_2
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[0] (\ram_write_data[0] [23:20]),
        .\t_c_bankA[2]__0 (\t_c_bankA[2]__0 ));
  ib_distributed_ram_bank_29 bank_3
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .RAM32M_inst_0_i_15(bank_7_n_2),
        .RAM32M_inst_0_i_18(bank_7_n_0),
        .RAM32M_inst_0_i_18_0(bank_7_n_1),
        .RAM32M_inst_1_0(bank_7_n_3),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[0] (\ram_write_data[0] [19:16]),
        .\t_c_bankA[0]__0 (\t_c_bankA[0]__0 ),
        .\t_c_bankA[1]__0 (\t_c_bankA[1]__0 ),
        .\t_c_bankA[2]__0 (\t_c_bankA[2]__0 ),
        .t_c_bankA__27(t_c_bankA__27),
        .\y1[2] (\y1[2] ),
        .y1_IBUF(y1_IBUF));
  ib_distributed_ram_bank_30 bank_4
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[0] (\ram_write_data[0] [15:12]),
        .\t_c_bankA[4]_16 (\t_c_bankA[4]_16 ));
  ib_distributed_ram_bank_31 bank_5
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[0] (\ram_write_data[0] [11:8]),
        .\t_c_bankA[5]_20 (\t_c_bankA[5]_20 ));
  ib_distributed_ram_bank_32 bank_6
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[0] (\ram_write_data[0] [7:4]),
        .\t_c_bankA[6]_24 (\t_c_bankA[6]_24 ));
  ib_distributed_ram_bank_33 bank_7
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[0] (\ram_write_data[0] [3:0]),
        .\t_c_bankA[4]_16 (\t_c_bankA[4]_16 ),
        .\t_c_bankA[5]_20 (\t_c_bankA[5]_20 ),
        .\t_c_bankA[6]_24 (\t_c_bankA[6]_24 ),
        .\y1[1] (bank_7_n_0),
        .\y1[1]_0 (bank_7_n_1),
        .\y1[1]_1 (bank_7_n_2),
        .\y1[1]_2 (bank_7_n_3),
        .y1_IBUF(y1_IBUF[1:0]));
endmodule

(* ORIG_REF_NAME = "ib_lut_ram" *) 
module ib_lut_ram_0
   (t_c_bankA__27,
    RAM32M_inst_0_i_11__0,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[1] ,
    ADDRA,
    ADDRD,
    t_c_bankA__27_0);
  output [2:0]t_c_bankA__27;
  output [0:0]RAM32M_inst_0_i_11__0;
  input clk_out1_0;
  input en_IBUF;
  input [31:0]\ram_write_data[1] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;
  input [2:0]t_c_bankA__27_0;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire [0:0]RAM32M_inst_0_i_11__0;
  wire bank_7_n_0;
  wire bank_7_n_1;
  wire bank_7_n_2;
  wire bank_7_n_3;
  wire clk_out1_0;
  wire en_IBUF;
  wire [31:0]\ram_write_data[1] ;
  wire [3:0]\t_c_bankA[0]__0 ;
  wire [3:0]\t_c_bankA[1]__0 ;
  wire [3:0]\t_c_bankA[2]__0 ;
  wire [3:0]\t_c_bankA[4]_16 ;
  wire [3:0]\t_c_bankA[5]_20 ;
  wire [3:0]\t_c_bankA[6]_24 ;
  wire [2:0]t_c_bankA__27;
  wire [2:0]t_c_bankA__27_0;

  ib_distributed_ram_bank_18 bank_0
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[1] (\ram_write_data[1] [31:28]),
        .\t_c_bankA[0]__0 (\t_c_bankA[0]__0 ));
  ib_distributed_ram_bank_19 bank_1
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[1] (\ram_write_data[1] [27:24]),
        .\t_c_bankA[1]__0 (\t_c_bankA[1]__0 ));
  ib_distributed_ram_bank_20 bank_2
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[1] (\ram_write_data[1] [23:20]),
        .\t_c_bankA[2]__0 (\t_c_bankA[2]__0 ));
  ib_distributed_ram_bank_21 bank_3
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .RAM32M_inst_0_i_11__0(RAM32M_inst_0_i_11__0),
        .RAM32M_inst_1_0(bank_7_n_3),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[1] (\ram_write_data[1] [19:16]),
        .\t_c_0_OBUF[3]_inst_i_11 (bank_7_n_0),
        .\t_c_0_OBUF[3]_inst_i_11_0 (bank_7_n_1),
        .\t_c_0_OBUF[3]_inst_i_8 (bank_7_n_2),
        .\t_c_bankA[0]__0 (\t_c_bankA[0]__0 ),
        .\t_c_bankA[1]__0 (\t_c_bankA[1]__0 ),
        .\t_c_bankA[2]__0 (\t_c_bankA[2]__0 ),
        .t_c_bankA__27(t_c_bankA__27),
        .t_c_bankA__27_0(t_c_bankA__27_0));
  ib_distributed_ram_bank_22 bank_4
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[1] (\ram_write_data[1] [15:12]),
        .\t_c_bankA[4]_16 (\t_c_bankA[4]_16 ));
  ib_distributed_ram_bank_23 bank_5
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[1] (\ram_write_data[1] [11:8]),
        .\t_c_bankA[5]_20 (\t_c_bankA[5]_20 ));
  ib_distributed_ram_bank_24 bank_6
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[1] (\ram_write_data[1] [7:4]),
        .\t_c_bankA[6]_24 (\t_c_bankA[6]_24 ));
  ib_distributed_ram_bank_25 bank_7
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .RAM32M_inst_0_0(bank_7_n_2),
        .RAM32M_inst_0_1(bank_7_n_3),
        .RAM32M_inst_1_0(bank_7_n_0),
        .RAM32M_inst_1_1(bank_7_n_1),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[1] (\ram_write_data[1] [3:0]),
        .\t_c_bankA[4]_16 (\t_c_bankA[4]_16 ),
        .\t_c_bankA[5]_20 (\t_c_bankA[5]_20 ),
        .\t_c_bankA[6]_24 (\t_c_bankA[6]_24 ),
        .t_c_bankA__27_0(t_c_bankA__27_0[1:0]));
endmodule

(* ORIG_REF_NAME = "ib_lut_ram" *) 
module ib_lut_ram_1
   (t_c_bankA__27,
    RAM32M_inst_0_i_11,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[2] ,
    ADDRA,
    ADDRD,
    t_c_bankA__27_0,
    \page_addr_ram2_reg[4]_0[0]_repN_alias );
  output [2:0]t_c_bankA__27;
  output [0:0]RAM32M_inst_0_i_11;
  input clk_out1_0;
  input en_IBUF;
  input [31:0]\ram_write_data[2] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;
  input [2:0]t_c_bankA__27_0;
  input \page_addr_ram2_reg[4]_0[0]_repN_alias ;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire [0:0]RAM32M_inst_0_i_11;
  wire bank_7_n_0;
  wire bank_7_n_1;
  wire bank_7_n_2;
  wire bank_7_n_3;
  wire clk_out1_0;
  wire en_IBUF;
  wire \page_addr_ram2_reg[4]_0[0]_repN_alias ;
  wire [31:0]\ram_write_data[2] ;
  wire [3:0]\t_c_bankA[0]__0 ;
  wire [3:0]\t_c_bankA[1]__0 ;
  wire [3:0]\t_c_bankA[2]__0 ;
  wire [3:0]\t_c_bankA[4]_16 ;
  wire [3:0]\t_c_bankA[5]_20 ;
  wire [3:0]\t_c_bankA[6]_24 ;
  wire [2:0]t_c_bankA__27;
  wire [2:0]t_c_bankA__27_0;

  ib_distributed_ram_bank_10 bank_0
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[2] (\ram_write_data[2] [31:28]),
        .\t_c_bankA[0]__0 (\t_c_bankA[0]__0 ));
  ib_distributed_ram_bank_11 bank_1
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\page_addr_ram2_reg[4]_0[0]_repN_alias (\page_addr_ram2_reg[4]_0[0]_repN_alias ),
        .\ram_write_data[2] (\ram_write_data[2] [27:24]),
        .\t_c_bankA[1]__0 (\t_c_bankA[1]__0 ));
  ib_distributed_ram_bank_12 bank_2
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[2] (\ram_write_data[2] [23:20]),
        .\t_c_bankA[2]__0 (\t_c_bankA[2]__0 ));
  ib_distributed_ram_bank_13 bank_3
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .RAM32M_inst_0_i_11(RAM32M_inst_0_i_11),
        .RAM32M_inst_1_0(bank_7_n_3),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[2] (\ram_write_data[2] [19:16]),
        .\t_c_0_OBUF[0]_inst_i_1 (bank_7_n_2),
        .\t_c_0_OBUF[0]_inst_i_2 (bank_7_n_0),
        .\t_c_0_OBUF[0]_inst_i_2_0 (bank_7_n_1),
        .\t_c_bankA[0]__0 (\t_c_bankA[0]__0 ),
        .\t_c_bankA[1]__0 (\t_c_bankA[1]__0 ),
        .\t_c_bankA[2]__0 (\t_c_bankA[2]__0 ),
        .t_c_bankA__27(t_c_bankA__27),
        .t_c_bankA__27_0(t_c_bankA__27_0));
  ib_distributed_ram_bank_14 bank_4
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[2] (\ram_write_data[2] [15:12]),
        .\t_c_bankA[4]_16 (\t_c_bankA[4]_16 ));
  ib_distributed_ram_bank_15 bank_5
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[2] (\ram_write_data[2] [11:8]),
        .\t_c_bankA[5]_20 (\t_c_bankA[5]_20 ));
  ib_distributed_ram_bank_16 bank_6
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[2] (\ram_write_data[2] [7:4]),
        .\t_c_bankA[6]_24 (\t_c_bankA[6]_24 ));
  ib_distributed_ram_bank_17 bank_7
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .RAM32M_inst_0_0(bank_7_n_2),
        .RAM32M_inst_0_1(bank_7_n_3),
        .RAM32M_inst_1_0(bank_7_n_0),
        .RAM32M_inst_1_1(bank_7_n_1),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[2] (\ram_write_data[2] [3:0]),
        .\t_c_bankA[4]_16 (\t_c_bankA[4]_16 ),
        .\t_c_bankA[5]_20 (\t_c_bankA[5]_20 ),
        .\t_c_bankA[6]_24 (\t_c_bankA[6]_24 ),
        .t_c_bankA__27_0(t_c_bankA__27_0[1:0]));
endmodule

(* ORIG_REF_NAME = "ib_lut_ram" *) 
module ib_lut_ram_2
   (t_c_3_OBUF,
    clk_out1_0,
    en_IBUF,
    \ram_write_data[3] ,
    ADDRA,
    ADDRD,
    t_c_bankA__27);
  output [3:0]t_c_3_OBUF;
  input clk_out1_0;
  input en_IBUF;
  input [31:0]\ram_write_data[3] ;
  input [4:0]ADDRA;
  input [4:0]ADDRD;
  input [2:0]t_c_bankA__27;

  wire [4:0]ADDRA;
  wire [4:0]ADDRD;
  wire bank_7_n_0;
  wire bank_7_n_1;
  wire bank_7_n_2;
  wire bank_7_n_3;
  wire clk_out1_0;
  wire en_IBUF;
  wire [31:0]\ram_write_data[3] ;
  wire [3:0]t_c_3_OBUF;
  wire [3:0]\t_c_bankA[0]_3 ;
  wire [3:0]\t_c_bankA[1]_7 ;
  wire [3:0]\t_c_bankA[2]_11 ;
  wire [3:0]\t_c_bankA[4]_19 ;
  wire [3:0]\t_c_bankA[5]_23 ;
  wire [3:0]\t_c_bankA[6]_27 ;
  wire [2:0]t_c_bankA__27;

  ib_distributed_ram_bank bank_0
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[3] (\ram_write_data[3] [31:28]),
        .\t_c_bankA[0]_3 (\t_c_bankA[0]_3 ));
  ib_distributed_ram_bank_3 bank_1
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[3] (\ram_write_data[3] [27:24]),
        .\t_c_bankA[1]_7 (\t_c_bankA[1]_7 ));
  ib_distributed_ram_bank_4 bank_2
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[3] (\ram_write_data[3] [23:20]),
        .\t_c_bankA[2]_11 (\t_c_bankA[2]_11 ));
  ib_distributed_ram_bank_5 bank_3
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[3] (\ram_write_data[3] [19:16]),
        .\t_c_3[0] (bank_7_n_0),
        .\t_c_3[1] (bank_7_n_1),
        .\t_c_3[2] (bank_7_n_2),
        .\t_c_3[3] (bank_7_n_3),
        .t_c_3_OBUF(t_c_3_OBUF),
        .\t_c_bankA[0]_3 (\t_c_bankA[0]_3 ),
        .\t_c_bankA[1]_7 (\t_c_bankA[1]_7 ),
        .\t_c_bankA[2]_11 (\t_c_bankA[2]_11 ),
        .t_c_bankA__27(t_c_bankA__27));
  ib_distributed_ram_bank_6 bank_4
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[3] (\ram_write_data[3] [15:12]),
        .\t_c_bankA[4]_19 (\t_c_bankA[4]_19 ));
  ib_distributed_ram_bank_7 bank_5
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[3] (\ram_write_data[3] [11:8]),
        .\t_c_bankA[5]_23 (\t_c_bankA[5]_23 ));
  ib_distributed_ram_bank_8 bank_6
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[3] (\ram_write_data[3] [7:4]),
        .\t_c_bankA[6]_27 (\t_c_bankA[6]_27 ));
  ib_distributed_ram_bank_9 bank_7
       (.ADDRA(ADDRA),
        .ADDRD(ADDRD),
        .RAM32M_inst_0_0(bank_7_n_2),
        .RAM32M_inst_0_1(bank_7_n_3),
        .RAM32M_inst_1_0(bank_7_n_0),
        .RAM32M_inst_1_1(bank_7_n_1),
        .clk_out1_0(clk_out1_0),
        .en_IBUF(en_IBUF),
        .\ram_write_data[3] (\ram_write_data[3] [3:0]),
        .\t_c_bankA[4]_19 (\t_c_bankA[4]_19 ),
        .\t_c_bankA[5]_23 (\t_c_bankA[5]_23 ),
        .\t_c_bankA[6]_27 (\t_c_bankA[6]_27 ),
        .t_c_bankA__27(t_c_bankA__27[1:0]));
endmodule

module ram_sel_counter
   (\ram_write_data[3] ,
    \ram_write_data[1] ,
    SR,
    en_reg_reg,
    \ram_sel_reg[1]_0 ,
    \ram_sel_reg[1]_1 ,
    \ram_write_data[0] ,
    \ram_write_data[2] ,
    Q,
    en_reg,
    m_clk,
    clk_gate);
  output [31:0]\ram_write_data[3] ;
  output [31:0]\ram_write_data[1] ;
  output [0:0]SR;
  output [0:0]en_reg_reg;
  output [0:0]\ram_sel_reg[1]_0 ;
  output [0:0]\ram_sel_reg[1]_1 ;
  output [31:0]\ram_write_data[0] ;
  output [31:0]\ram_write_data[2] ;
  input [31:0]Q;
  input en_reg;
  input m_clk;
  input clk_gate;

  wire [31:0]Q;
  wire [0:0]SR;
  wire clk_gate;
  wire en_reg;
  wire [0:0]en_reg_reg;
  wire m_clk;
  wire [1:0]p_0_in;
  wire \ram_sel[0]_i_1_n_0 ;
  wire \ram_sel[1]_i_1_n_0 ;
  wire [0:0]\ram_sel_reg[1]_0 ;
  wire [0:0]\ram_sel_reg[1]_1 ;
  wire [31:0]\ram_write_data[0] ;
  wire [31:0]\ram_write_data[1] ;
  wire [31:0]\ram_write_data[2] ;
  wire [31:0]\ram_write_data[3] ;

  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_1
       (.I0(p_0_in[1]),
        .I1(Q[31]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [31]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__0
       (.I0(Q[31]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [31]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_1__1
       (.I0(p_0_in[1]),
        .I1(Q[27]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [27]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__10
       (.I0(Q[11]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [11]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_1__11
       (.I0(p_0_in[1]),
        .I1(Q[7]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [7]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__12
       (.I0(Q[7]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [7]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_1__13
       (.I0(p_0_in[1]),
        .I1(Q[3]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [3]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__14
       (.I0(Q[3]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [3]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_1__15
       (.I0(p_0_in[0]),
        .I1(Q[3]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [3]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_1__16
       (.I0(p_0_in[0]),
        .I1(Q[7]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [7]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_1__17
       (.I0(p_0_in[0]),
        .I1(Q[11]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [11]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_1__18
       (.I0(p_0_in[0]),
        .I1(Q[15]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [15]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_1__19
       (.I0(p_0_in[0]),
        .I1(Q[19]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [19]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__2
       (.I0(Q[27]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [27]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_1__20
       (.I0(p_0_in[0]),
        .I1(Q[23]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [23]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_1__21
       (.I0(p_0_in[0]),
        .I1(Q[27]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [27]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_1__22
       (.I0(p_0_in[0]),
        .I1(Q[31]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [31]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__23
       (.I0(p_0_in[1]),
        .I1(Q[3]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [3]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__24
       (.I0(p_0_in[1]),
        .I1(Q[7]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [7]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__25
       (.I0(p_0_in[1]),
        .I1(Q[11]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [11]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__26
       (.I0(p_0_in[1]),
        .I1(Q[15]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [15]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__27
       (.I0(p_0_in[1]),
        .I1(Q[19]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [19]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__28
       (.I0(p_0_in[1]),
        .I1(Q[23]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [23]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__29
       (.I0(p_0_in[1]),
        .I1(Q[27]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [27]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_1__3
       (.I0(p_0_in[1]),
        .I1(Q[23]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [23]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__30
       (.I0(p_0_in[1]),
        .I1(Q[31]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [31]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__4
       (.I0(Q[23]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [23]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_1__5
       (.I0(p_0_in[1]),
        .I1(Q[19]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [19]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__6
       (.I0(Q[19]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [19]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_1__7
       (.I0(p_0_in[1]),
        .I1(Q[15]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [15]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_1__8
       (.I0(Q[15]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [15]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_1__9
       (.I0(p_0_in[1]),
        .I1(Q[11]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [11]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_2
       (.I0(p_0_in[1]),
        .I1(Q[30]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [30]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__0
       (.I0(Q[30]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [30]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_2__1
       (.I0(p_0_in[1]),
        .I1(Q[26]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [26]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__10
       (.I0(Q[10]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [10]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_2__11
       (.I0(p_0_in[1]),
        .I1(Q[6]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [6]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__12
       (.I0(Q[6]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [6]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_2__13
       (.I0(p_0_in[1]),
        .I1(Q[2]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [2]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__14
       (.I0(Q[2]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [2]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_2__15
       (.I0(p_0_in[0]),
        .I1(Q[2]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [2]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_2__16
       (.I0(p_0_in[0]),
        .I1(Q[6]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [6]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_2__17
       (.I0(p_0_in[0]),
        .I1(Q[10]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [10]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_2__18
       (.I0(p_0_in[0]),
        .I1(Q[14]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [14]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_2__19
       (.I0(p_0_in[0]),
        .I1(Q[18]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [18]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__2
       (.I0(Q[26]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [26]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_2__20
       (.I0(p_0_in[0]),
        .I1(Q[22]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [22]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_2__21
       (.I0(p_0_in[0]),
        .I1(Q[26]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [26]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_0_i_2__22
       (.I0(p_0_in[0]),
        .I1(Q[30]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [30]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__23
       (.I0(p_0_in[1]),
        .I1(Q[2]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [2]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__24
       (.I0(p_0_in[1]),
        .I1(Q[6]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [6]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__25
       (.I0(p_0_in[1]),
        .I1(Q[10]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [10]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__26
       (.I0(p_0_in[1]),
        .I1(Q[14]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [14]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__27
       (.I0(p_0_in[1]),
        .I1(Q[18]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [18]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__28
       (.I0(p_0_in[1]),
        .I1(Q[22]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [22]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__29
       (.I0(p_0_in[1]),
        .I1(Q[26]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [26]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_2__3
       (.I0(p_0_in[1]),
        .I1(Q[22]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [22]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__30
       (.I0(p_0_in[1]),
        .I1(Q[30]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [30]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__4
       (.I0(Q[22]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [22]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_2__5
       (.I0(p_0_in[1]),
        .I1(Q[18]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [18]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__6
       (.I0(Q[18]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [18]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_2__7
       (.I0(p_0_in[1]),
        .I1(Q[14]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [14]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_0_i_2__8
       (.I0(Q[14]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [14]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_0_i_2__9
       (.I0(p_0_in[1]),
        .I1(Q[10]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [10]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_1
       (.I0(p_0_in[1]),
        .I1(Q[29]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [29]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__0
       (.I0(Q[29]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [29]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_1__1
       (.I0(p_0_in[1]),
        .I1(Q[25]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [25]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__10
       (.I0(Q[9]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [9]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_1__11
       (.I0(p_0_in[1]),
        .I1(Q[5]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [5]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__12
       (.I0(Q[5]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [5]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_1__13
       (.I0(p_0_in[1]),
        .I1(Q[1]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [1]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__14
       (.I0(Q[1]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [1]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_1__15
       (.I0(p_0_in[0]),
        .I1(Q[1]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [1]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_1__16
       (.I0(p_0_in[0]),
        .I1(Q[5]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [5]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_1__17
       (.I0(p_0_in[0]),
        .I1(Q[9]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [9]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_1__18
       (.I0(p_0_in[0]),
        .I1(Q[13]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [13]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_1__19
       (.I0(p_0_in[0]),
        .I1(Q[17]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [17]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__2
       (.I0(Q[25]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [25]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_1__20
       (.I0(p_0_in[0]),
        .I1(Q[21]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [21]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_1__21
       (.I0(p_0_in[0]),
        .I1(Q[25]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [25]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_1__22
       (.I0(p_0_in[0]),
        .I1(Q[29]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [29]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__23
       (.I0(p_0_in[1]),
        .I1(Q[1]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [1]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__24
       (.I0(p_0_in[1]),
        .I1(Q[5]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [5]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__25
       (.I0(p_0_in[1]),
        .I1(Q[9]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [9]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__26
       (.I0(p_0_in[1]),
        .I1(Q[13]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [13]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__27
       (.I0(p_0_in[1]),
        .I1(Q[17]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [17]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__28
       (.I0(p_0_in[1]),
        .I1(Q[21]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [21]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__29
       (.I0(p_0_in[1]),
        .I1(Q[25]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [25]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_1__3
       (.I0(p_0_in[1]),
        .I1(Q[21]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [21]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__30
       (.I0(p_0_in[1]),
        .I1(Q[29]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [29]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__4
       (.I0(Q[21]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [21]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_1__5
       (.I0(p_0_in[1]),
        .I1(Q[17]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [17]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__6
       (.I0(Q[17]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [17]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_1__7
       (.I0(p_0_in[1]),
        .I1(Q[13]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [13]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_1__8
       (.I0(Q[13]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [13]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_1__9
       (.I0(p_0_in[1]),
        .I1(Q[9]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [9]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_2
       (.I0(p_0_in[1]),
        .I1(Q[28]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [28]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__0
       (.I0(Q[28]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [28]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_2__1
       (.I0(p_0_in[1]),
        .I1(Q[24]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [24]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__10
       (.I0(Q[8]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [8]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_2__11
       (.I0(p_0_in[1]),
        .I1(Q[4]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [4]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__12
       (.I0(Q[4]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [4]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_2__13
       (.I0(p_0_in[1]),
        .I1(Q[0]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [0]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__14
       (.I0(Q[0]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [0]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_2__15
       (.I0(p_0_in[0]),
        .I1(Q[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [0]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_2__16
       (.I0(p_0_in[0]),
        .I1(Q[4]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [4]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_2__17
       (.I0(p_0_in[0]),
        .I1(Q[8]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [8]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_2__18
       (.I0(p_0_in[0]),
        .I1(Q[12]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [12]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_2__19
       (.I0(p_0_in[0]),
        .I1(Q[16]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [16]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__2
       (.I0(Q[24]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [24]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_2__20
       (.I0(p_0_in[0]),
        .I1(Q[20]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [20]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_2__21
       (.I0(p_0_in[0]),
        .I1(Q[24]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [24]));
  LUT3 #(
    .INIT(8'h04)) 
    RAM32M_inst_1_i_2__22
       (.I0(p_0_in[0]),
        .I1(Q[28]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[0] [28]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__23
       (.I0(p_0_in[1]),
        .I1(Q[0]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [0]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__24
       (.I0(p_0_in[1]),
        .I1(Q[4]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [4]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__25
       (.I0(p_0_in[1]),
        .I1(Q[8]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [8]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__26
       (.I0(p_0_in[1]),
        .I1(Q[12]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [12]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__27
       (.I0(p_0_in[1]),
        .I1(Q[16]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [16]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__28
       (.I0(p_0_in[1]),
        .I1(Q[20]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [20]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__29
       (.I0(p_0_in[1]),
        .I1(Q[24]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [24]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_2__3
       (.I0(p_0_in[1]),
        .I1(Q[20]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [20]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__30
       (.I0(p_0_in[1]),
        .I1(Q[28]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[2] [28]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__4
       (.I0(Q[20]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [20]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_2__5
       (.I0(p_0_in[1]),
        .I1(Q[16]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [16]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__6
       (.I0(Q[16]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [16]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_2__7
       (.I0(p_0_in[1]),
        .I1(Q[12]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [12]));
  LUT3 #(
    .INIT(8'h08)) 
    RAM32M_inst_1_i_2__8
       (.I0(Q[12]),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(\ram_write_data[1] [12]));
  LUT3 #(
    .INIT(8'h80)) 
    RAM32M_inst_1_i_2__9
       (.I0(p_0_in[1]),
        .I1(Q[8]),
        .I2(p_0_in[0]),
        .O(\ram_write_data[3] [8]));
  LUT3 #(
    .INIT(8'hEF)) 
    \page_addr_ram0[4]_i_1 
       (.I0(p_0_in[1]),
        .I1(p_0_in[0]),
        .I2(en_reg),
        .O(\ram_sel_reg[1]_0 ));
  LUT3 #(
    .INIT(8'hF7)) 
    \page_addr_ram1[4]_i_1 
       (.I0(en_reg),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(en_reg_reg));
  LUT3 #(
    .INIT(8'hF7)) 
    \page_addr_ram2[4]_i_1 
       (.I0(p_0_in[1]),
        .I1(en_reg),
        .I2(p_0_in[0]),
        .O(\ram_sel_reg[1]_1 ));
  LUT3 #(
    .INIT(8'h7F)) 
    \page_addr_ram3[4]_i_1 
       (.I0(en_reg),
        .I1(p_0_in[0]),
        .I2(p_0_in[1]),
        .O(SR));
  (* \PinAttr:I0:HOLD_DETOUR  = "916" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \ram_sel[0]_i_1 
       (.I0(m_clk),
        .I1(p_0_in[0]),
        .O(\ram_sel[0]_i_1_n_0 ));
  (* \PinAttr:I1:HOLD_DETOUR  = "932" *) 
  LUT3 #(
    .INIT(8'hD2)) 
    \ram_sel[1]_i_1 
       (.I0(p_0_in[0]),
        .I1(m_clk),
        .I2(p_0_in[1]),
        .O(\ram_sel[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \ram_sel_reg[0] 
       (.C(clk_gate),
        .CE(1'b1),
        .D(\ram_sel[0]_i_1_n_0 ),
        .Q(p_0_in[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1)) 
    \ram_sel_reg[1] 
       (.C(clk_gate),
        .CE(1'b1),
        .D(\ram_sel[1]_i_1_n_0 ),
        .Q(p_0_in[1]),
        .R(1'b0));
endmodule

(* ECO_CHECKSUM = "94609bfc" *) (* POWER_OPT_BRAM_CDC = "2" *) (* POWER_OPT_BRAM_SR_ADDR = "0" *) 
(* POWER_OPT_LOOPED_NET_PERCENTAGE = "0" *) 
(* NotValidForBitStream *)
module top
   (t_c_0,
    t_c_1,
    t_c_2,
    t_c_3,
    y0,
    y1,
    y2,
    y3,
    y4,
    sys_clk_n,
    sys_clk_p,
    en,
    iter_update);
  output [3:0]t_c_0;
  output [3:0]t_c_1;
  output [3:0]t_c_2;
  output [3:0]t_c_3;
  input [3:0]y0;
  input [3:0]y1;
  input [3:0]y2;
  input [3:0]y3;
  input [3:0]y4;
  input sys_clk_n;
  input sys_clk_p;
  input en;
  input iter_update;

  wire [4:0]\bank_0/sync_addr_0 ;
  wire [4:0]\bank_0/sync_addr_0_2 ;
  wire [4:0]\bank_0/sync_addr_0_3 ;
  wire [4:0]\bank_0/sync_addr_0_4 ;
  wire clk_gate;
  wire en;
  wire en_IBUF;
  wire en_reg;
  wire [35:0]\entry_set_9[0] ;
  wire [35:0]\entry_set_9[1] ;
  wire [6:1]\entry_set_addr[0] ;
  wire [31:0]\interBank_port0_7_reg[0] ;
  wire [31:0]\interBank_port0_7_reg[1] ;
  wire [31:0]\interBank_port0_7_reg[2] ;
  wire iter_update;
  wire iter_update_IBUF;
  wire m_clk;
  wire p_0_in__0;
  wire page_addr_ram0__0;
  wire page_addr_ram1__0;
  wire page_addr_ram2__0;
  wire \page_addr_ram2_reg[4]_0[0]_repN_alias ;
  wire page_addr_ram3__0;
  wire [31:0]port_out;
  wire ram_clk;
  wire [31:0]\ram_write_data[0] ;
  wire [31:0]\ram_write_data[1] ;
  wire [31:0]\ram_write_data[2] ;
  wire [31:0]\ram_write_data[3] ;
  wire rom_clk;
  wire rstn;
  wire rstn_i_1_n_0;
  (* DIFF_TERM = 0 *) (* IBUF_LOW_PWR *) wire sys_clk_n;
  (* DIFF_TERM = 0 *) (* IBUF_LOW_PWR *) wire sys_clk_p;
  wire [3:0]t_c_0;
  wire [3:0]t_c_1;
  wire [3:0]t_c_2;
  wire [3:0]t_c_3;
  wire [3:0]t_c_3_OBUF;
  wire [2:0]t_c_bankA__27;
  wire [2:0]t_c_bankA__27_0;
  wire [2:0]t_c_bankA__27_1;
  wire [3:3]\t_portA[0] ;
  wire [3:3]\t_portA[1] ;
  wire [3:3]\t_portA[2] ;
  wire [3:0]y0;
  wire [3:0]y0_IBUF;
  wire [3:0]y1;
  wire [3:0]y1_IBUF;
  wire [3:0]y2;
  wire [3:0]y2_IBUF;
  wire [3:0]y3;
  wire [3:0]y3_IBUF;
  wire [3:0]y4;
  wire [3:0]y4_IBUF;
  wire NLW_clock_domain_0_reset_UNCONNECTED;
  wire NLW_ib_map_0_reset_UNCONNECTED;

  IB_RAM_wrapper RAMB36E1_0
       (.BRAM_PORTA_0_dout(\entry_set_9[0] ),
        .BRAM_PORTB_0_addr(\entry_set_addr[0] ),
        .BRAM_PORTB_0_dout(\entry_set_9[1] ),
        .CLK(rom_clk));
  c6ibm_port_shifter c6ibm_port_shifter_0
       (.CLK(ram_clk),
        .Q(port_out),
        .en_IBUF(en_IBUF),
        .\ports_data_reg[31]_0 (\interBank_port0_7_reg[2] ),
        .\ports_data_reg[63]_0 (\interBank_port0_7_reg[1] ),
        .\ports_data_reg[95]_0 (\interBank_port0_7_reg[0] ));
  clock_domain_wrapper clock_domain_0
       (.CLK(rom_clk),
        .clk_out1_0(ram_clk),
        .lopt(rstn),
        .reset(NLW_clock_domain_0_reset_UNCONNECTED),
        .sys_clk_n(sys_clk_n),
        .sys_clk_p(sys_clk_p));
  decomp_clk_gen decomp_clk_gen_0
       (.SR(p_0_in__0),
        .clk_gate(clk_gate),
        .clk_out1_0(ram_clk),
        .en_IBUF(en_IBUF),
        .en_reg(en_reg),
        .m_clk(m_clk));
  IBUF en_IBUF_inst
       (.I(en),
        .O(en_IBUF));
  ib_lut_ram func_ram_0
       (.ADDRA(\bank_0/sync_addr_0_4 ),
        .ADDRD({y0_IBUF,y1_IBUF[3]}),
        .clk_out1_0(ram_clk),
        .en_IBUF(en_IBUF),
        .\ram_write_data[0] (\ram_write_data[0] ),
        .t_c_bankA__27(t_c_bankA__27),
        .\y1[2] (\t_portA[0] ),
        .y1_IBUF(y1_IBUF[2:0]));
  ib_lut_ram_0 func_ram_1
       (.ADDRA(\bank_0/sync_addr_0_3 ),
        .ADDRD({y2_IBUF,\t_portA[0] }),
        .RAM32M_inst_0_i_11__0(\t_portA[1] ),
        .clk_out1_0(ram_clk),
        .en_IBUF(en_IBUF),
        .\ram_write_data[1] (\ram_write_data[1] ),
        .t_c_bankA__27(t_c_bankA__27_0),
        .t_c_bankA__27_0(t_c_bankA__27));
  ib_lut_ram_1 func_ram_2
       (.ADDRA(\bank_0/sync_addr_0_2 ),
        .ADDRD({y3_IBUF,\t_portA[1] }),
        .RAM32M_inst_0_i_11(\t_portA[2] ),
        .clk_out1_0(ram_clk),
        .en_IBUF(en_IBUF),
        .\page_addr_ram2_reg[4]_0[0]_repN_alias (\page_addr_ram2_reg[4]_0[0]_repN_alias ),
        .\ram_write_data[2] (\ram_write_data[2] ),
        .t_c_bankA__27(t_c_bankA__27_1),
        .t_c_bankA__27_0(t_c_bankA__27_0));
  ib_lut_ram_2 func_ram_3
       (.ADDRA(\bank_0/sync_addr_0 ),
        .ADDRD({y4_IBUF,\t_portA[2] }),
        .clk_out1_0(ram_clk),
        .en_IBUF(en_IBUF),
        .\ram_write_data[3] (\ram_write_data[3] ),
        .t_c_3_OBUF(t_c_3_OBUF),
        .t_c_bankA__27(t_c_bankA__27_1));
  cnu6_ib_map ib_map_0
       (.BRAM_PORTA_0_dout(\entry_set_9[0] ),
        .BRAM_PORTB_0_addr(\entry_set_addr[0] ),
        .BRAM_PORTB_0_dout(\entry_set_9[1] ),
        .CLK(rom_clk),
        .Q(\interBank_port0_7_reg[0] ),
        .\interBank_port0_7_reg[1][31]_0 (\interBank_port0_7_reg[1] ),
        .\interBank_port0_7_reg[2][31]_0 (\interBank_port0_7_reg[2] ),
        .reset(NLW_ib_map_0_reset_UNCONNECTED),
        .rstn(rstn));
  IBUF iter_update_IBUF_inst
       (.I(iter_update),
        .O(iter_update_IBUF));
  ram_sel_counter ram_sel_cnt_0
       (.Q(port_out),
        .SR(page_addr_ram3__0),
        .clk_gate(clk_gate),
        .en_reg(en_reg),
        .en_reg_reg(page_addr_ram1__0),
        .m_clk(m_clk),
        .\ram_sel_reg[1]_0 (page_addr_ram0__0),
        .\ram_sel_reg[1]_1 (page_addr_ram2__0),
        .\ram_write_data[0] (\ram_write_data[0] ),
        .\ram_write_data[1] (\ram_write_data[1] ),
        .\ram_write_data[2] (\ram_write_data[2] ),
        .\ram_write_data[3] (\ram_write_data[3] ));
  c6ibAddr_ram_sel ram_write_addr_gate
       (.ADDRA(\bank_0/sync_addr_0_4 ),
        .ADDRD({y0_IBUF,y1_IBUF[3]}),
        .RAM32M_inst_1({y2_IBUF,\t_portA[0] }),
        .RAM32M_inst_1_0({y3_IBUF,\t_portA[1] }),
        .RAM32M_inst_1_1({y4_IBUF,\t_portA[2] }),
        .SR(p_0_in__0),
        .clk_out1_0(ram_clk),
        .en_IBUF(en_IBUF),
        .en_reg(en_reg),
        .\page_addr_ram0_reg[4]_0 (page_addr_ram0__0),
        .\page_addr_ram1_reg[4]_0 (\bank_0/sync_addr_0_3 ),
        .\page_addr_ram1_reg[4]_1 (page_addr_ram1__0),
        .\page_addr_ram2_reg[4]_0 (\bank_0/sync_addr_0_2 ),
        .\page_addr_ram2_reg[4]_0[0]_repN_alias (\page_addr_ram2_reg[4]_0[0]_repN_alias ),
        .\page_addr_ram2_reg[4]_1 (page_addr_ram2__0),
        .\page_addr_ram3_reg[4]_0 (\bank_0/sync_addr_0 ),
        .\page_addr_ram3_reg[4]_1 (page_addr_ram3__0));
  LUT2 #(
    .INIT(4'hB)) 
    rstn_i_1
       (.I0(rstn),
        .I1(iter_update_IBUF),
        .O(rstn_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    rstn_reg
       (.C(ram_clk),
        .CE(1'b1),
        .D(rstn_i_1_n_0),
        .Q(rstn),
        .R(1'b0));
  OBUF \t_c_0_OBUF[0]_inst 
       (.I(t_c_3_OBUF[0]),
        .O(t_c_0[0]));
  OBUF \t_c_0_OBUF[1]_inst 
       (.I(t_c_3_OBUF[1]),
        .O(t_c_0[1]));
  OBUF \t_c_0_OBUF[2]_inst 
       (.I(t_c_3_OBUF[2]),
        .O(t_c_0[2]));
  OBUF \t_c_0_OBUF[3]_inst 
       (.I(t_c_3_OBUF[3]),
        .O(t_c_0[3]));
  OBUF \t_c_1_OBUF[0]_inst 
       (.I(t_c_3_OBUF[0]),
        .O(t_c_1[0]));
  OBUF \t_c_1_OBUF[1]_inst 
       (.I(t_c_3_OBUF[1]),
        .O(t_c_1[1]));
  OBUF \t_c_1_OBUF[2]_inst 
       (.I(t_c_3_OBUF[2]),
        .O(t_c_1[2]));
  OBUF \t_c_1_OBUF[3]_inst 
       (.I(t_c_3_OBUF[3]),
        .O(t_c_1[3]));
  OBUF \t_c_2_OBUF[0]_inst 
       (.I(t_c_3_OBUF[0]),
        .O(t_c_2[0]));
  OBUF \t_c_2_OBUF[1]_inst 
       (.I(t_c_3_OBUF[1]),
        .O(t_c_2[1]));
  OBUF \t_c_2_OBUF[2]_inst 
       (.I(t_c_3_OBUF[2]),
        .O(t_c_2[2]));
  OBUF \t_c_2_OBUF[3]_inst 
       (.I(t_c_3_OBUF[3]),
        .O(t_c_2[3]));
  OBUF \t_c_3_OBUF[0]_inst 
       (.I(t_c_3_OBUF[0]),
        .O(t_c_3[0]));
  OBUF \t_c_3_OBUF[1]_inst 
       (.I(t_c_3_OBUF[1]),
        .O(t_c_3[1]));
  OBUF \t_c_3_OBUF[2]_inst 
       (.I(t_c_3_OBUF[2]),
        .O(t_c_3[2]));
  OBUF \t_c_3_OBUF[3]_inst 
       (.I(t_c_3_OBUF[3]),
        .O(t_c_3[3]));
  IBUF \y0_IBUF[0]_inst 
       (.I(y0[0]),
        .O(y0_IBUF[0]));
  IBUF \y0_IBUF[1]_inst 
       (.I(y0[1]),
        .O(y0_IBUF[1]));
  IBUF \y0_IBUF[2]_inst 
       (.I(y0[2]),
        .O(y0_IBUF[2]));
  IBUF \y0_IBUF[3]_inst 
       (.I(y0[3]),
        .O(y0_IBUF[3]));
  IBUF \y1_IBUF[0]_inst 
       (.I(y1[0]),
        .O(y1_IBUF[0]));
  IBUF \y1_IBUF[1]_inst 
       (.I(y1[1]),
        .O(y1_IBUF[1]));
  IBUF \y1_IBUF[2]_inst 
       (.I(y1[2]),
        .O(y1_IBUF[2]));
  IBUF \y1_IBUF[3]_inst 
       (.I(y1[3]),
        .O(y1_IBUF[3]));
  IBUF \y2_IBUF[0]_inst 
       (.I(y2[0]),
        .O(y2_IBUF[0]));
  IBUF \y2_IBUF[1]_inst 
       (.I(y2[1]),
        .O(y2_IBUF[1]));
  IBUF \y2_IBUF[2]_inst 
       (.I(y2[2]),
        .O(y2_IBUF[2]));
  IBUF \y2_IBUF[3]_inst 
       (.I(y2[3]),
        .O(y2_IBUF[3]));
  IBUF \y3_IBUF[0]_inst 
       (.I(y3[0]),
        .O(y3_IBUF[0]));
  IBUF \y3_IBUF[1]_inst 
       (.I(y3[1]),
        .O(y3_IBUF[1]));
  IBUF \y3_IBUF[2]_inst 
       (.I(y3[2]),
        .O(y3_IBUF[2]));
  IBUF \y3_IBUF[3]_inst 
       (.I(y3[3]),
        .O(y3_IBUF[3]));
  IBUF \y4_IBUF[0]_inst 
       (.I(y4[0]),
        .O(y4_IBUF[0]));
  IBUF \y4_IBUF[1]_inst 
       (.I(y4[1]),
        .O(y4_IBUF[1]));
  IBUF \y4_IBUF[2]_inst 
       (.I(y4[2]),
        .O(y4_IBUF[2]));
  IBUF \y4_IBUF[3]_inst 
       (.I(y4[3]),
        .O(y4_IBUF[3]));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_generic_cstr" *) 
module IB_RAM_blk_mem_gen_1_0_blk_mem_gen_generic_cstr
   (douta,
    doutb,
    clka,
    addra,
    addrb,
    dina,
    dinb,
    wea,
    web);
  output [35:0]douta;
  output [35:0]doutb;
  input clka;
  input [6:0]addra;
  input [6:0]addrb;
  input [35:0]dina;
  input [35:0]dinb;
  input [0:0]wea;
  input [0:0]web;

  wire [6:0]addra;
  wire [6:0]addrb;
  wire clka;
  wire [35:0]dina;
  wire [35:0]dinb;
  wire [35:0]douta;
  wire [35:0]doutb;
  wire [0:0]wea;
  wire [0:0]web;

  IB_RAM_blk_mem_gen_1_0_blk_mem_gen_prim_width \ramloop[0].ram.r 
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .wea(wea),
        .web(web));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module IB_RAM_blk_mem_gen_1_0_blk_mem_gen_prim_width
   (douta,
    doutb,
    clka,
    addra,
    addrb,
    dina,
    dinb,
    wea,
    web);
  output [35:0]douta;
  output [35:0]doutb;
  input clka;
  input [6:0]addra;
  input [6:0]addrb;
  input [35:0]dina;
  input [35:0]dinb;
  input [0:0]wea;
  input [0:0]web;

  wire [6:0]addra;
  wire [6:0]addrb;
  wire clka;
  wire [35:0]dina;
  wire [35:0]dinb;
  wire [35:0]douta;
  wire [35:0]doutb;
  wire [0:0]wea;
  wire [0:0]web;

  IB_RAM_blk_mem_gen_1_0_blk_mem_gen_prim_wrapper_init \prim_init.ram 
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .wea(wea),
        .web(web));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module IB_RAM_blk_mem_gen_1_0_blk_mem_gen_prim_wrapper_init
   (douta,
    doutb,
    clka,
    addra,
    addrb,
    dina,
    dinb,
    wea,
    web);
  output [35:0]douta;
  output [35:0]doutb;
  input clka;
  input [6:0]addra;
  input [6:0]addrb;
  input [35:0]dina;
  input [35:0]dinb;
  input [0:0]wea;
  input [0:0]web;

  wire [6:0]addra;
  wire [6:0]addrb;
  wire clka;
  wire [35:0]dina;
  wire [35:0]dinb;
  wire [35:0]douta;
  wire [35:0]doutb;
  wire [0:0]wea;
  wire [0:0]web;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* BOX_TYPE = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'hE492D1C0A3C5D6803D5A67860F2B293DF6B67E19B3A5A69707B495843C1B196F),
    .INITP_01(256'h00000000000000033A5B7A79E1A47968E1A687A64C74E0E31B5B7A787F4A497F),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h77EE549830D9AA3364B365AA7561B2438684EECCB9EAC365CA0C08EEFD72D487),
    .INIT_01(256'hF1224488EEDDBB77111DBB77CC9A448833223B76CC55AC9955A6C477EC95A24A),
    .INIT_02(256'h848CA267CF2655CC77CC9A55AC9E4CAA35AA2245AA99BC891166CC55CC993B78),
    .INIT_03(256'h0E90901001FB6EB9731D2121197BFFDC6859C4AB5737701224D1B38913AF66D1),
    .INIT_04(256'h9366CC8810DD2A4466EEDDA97561B244868866CBB9EAC365C8C808DDDD775C87),
    .INIT_05(256'hF12655BB32112A67EEE2449911213366EEDDC488EEDDBB7711224477EED93368),
    .INIT_06(256'hE0041A67CF26E6EEBD808934689E4DCD7977882246153C9A35EF662266D12B78),
    .INIT_07(256'h0E9099222377E6B9751DA121220377DCDB2A3A32644007FEFFB75475116F6FFF),
    .INIT_08(256'hEEDDBB7710DDBB77AA6244883321BB65AA1155AA75A6C366CA1099BB992ED487),
    .INIT_09(256'hF16F66DD98881946ACE2D5BC57EC9944AA99C49A33AA5244AA593B8811224485),
    .INIT_0A(256'h1B775D9850D519101FFFF6CB465E56DEBDBF8001228DBCAC573777002248A278),
    .INIT_0B(256'h0ED93366AB66CC98311DB355A81255A955663B65A80C9DBB99EE4C76EC50912C),
    .INIT_0C(256'h2C993377EF22449911193377EEDE4488EEDDBB7711224377EED9338833664487),
    .INIT_0D(256'hF16AE6DD98881A56ACE2D5BC57EC9944AA99C49A33AA5244AA593B881166CC95),
    .INIT_0E(256'h00000000000000000000000000000000000000000000000001AF6FFF0048A278),
    .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_20(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_21(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_22(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_23(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_24(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_25(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_26(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_27(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_28(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_29(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_2F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_30(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_31(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_32(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_33(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_34(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_35(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_36(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_37(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_38(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_39(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_3F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_40(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_41(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_42(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_43(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_44(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_45(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_46(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_47(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_48(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_49(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_4F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_50(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_51(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_52(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_53(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_54(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_55(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_56(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_57(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_58(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_59(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_5F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_60(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_61(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_62(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_63(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_64(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_65(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_66(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_67(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_68(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_69(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(36),
    .READ_WIDTH_B(36),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("NO_CHANGE"),
    .WRITE_MODE_B("NO_CHANGE"),
    .WRITE_WIDTH_A(36),
    .WRITE_WIDTH_B(36)) 
    \DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,1'b0,1'b0,1'b0,addra,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,1'b0,1'b0,1'b0,addrb,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(clka),
        .CLKBWRCLK(clka),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({dina[34:27],dina[25:18],dina[16:9],dina[7:0]}),
        .DIBDI({dinb[34:27],dinb[25:18],dinb[16:9],dinb[7:0]}),
        .DIPADIP({dina[35],dina[26],dina[17],dina[8]}),
        .DIPBDIP({dinb[35],dinb[26],dinb[17],dinb[8]}),
        .DOADO({douta[34:27],douta[25:18],douta[16:9],douta[7:0]}),
        .DOBDO({doutb[34:27],doutb[25:18],doutb[16:9],doutb[7:0]}),
        .DOPADOP({douta[35],douta[26],douta[17],douta[8]}),
        .DOPBDOP({doutb[35],doutb[26],doutb[17],doutb[8]}),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(1'b1),
        .ENBWREN(1'b1),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(1'b0),
        .RSTRAMB(1'b0),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.TRUE_DP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({wea,wea,wea,wea}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,web,web,web,web}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_top" *) 
module IB_RAM_blk_mem_gen_1_0_blk_mem_gen_top
   (douta,
    doutb,
    clka,
    addra,
    addrb,
    dina,
    dinb,
    wea,
    web);
  output [35:0]douta;
  output [35:0]doutb;
  input clka;
  input [6:0]addra;
  input [6:0]addrb;
  input [35:0]dina;
  input [35:0]dinb;
  input [0:0]wea;
  input [0:0]web;

  wire [6:0]addra;
  wire [6:0]addrb;
  wire clka;
  wire [35:0]dina;
  wire [35:0]dinb;
  wire [35:0]douta;
  wire [35:0]doutb;
  wire [0:0]wea;
  wire [0:0]web;

  IB_RAM_blk_mem_gen_1_0_blk_mem_gen_generic_cstr \valid.cstr 
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .wea(wea),
        .web(web));
endmodule

(* C_ADDRA_WIDTH = "7" *) (* C_ADDRB_WIDTH = "7" *) (* C_ALGORITHM = "1" *) 
(* C_AXI_ID_WIDTH = "4" *) (* C_AXI_SLAVE_TYPE = "0" *) (* C_AXI_TYPE = "1" *) 
(* C_BYTE_SIZE = "9" *) (* C_COMMON_CLK = "1" *) (* C_COUNT_18K_BRAM = "0" *) 
(* C_COUNT_36K_BRAM = "1" *) (* C_CTRL_ECC_ALGO = "NONE" *) (* C_DEFAULT_DATA = "0" *) 
(* C_DISABLE_WARN_BHV_COLL = "0" *) (* C_DISABLE_WARN_BHV_RANGE = "0" *) (* C_ELABORATION_DIR = "./" *) 
(* C_ENABLE_32BIT_ADDRESS = "0" *) (* C_EN_DEEPSLEEP_PIN = "0" *) (* C_EN_ECC_PIPE = "0" *) 
(* C_EN_RDADDRA_CHG = "0" *) (* C_EN_RDADDRB_CHG = "0" *) (* C_EN_SAFETY_CKT = "0" *) 
(* C_EN_SHUTDOWN_PIN = "0" *) (* C_EN_SLEEP_PIN = "0" *) (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     5.40625 mW" *) 
(* C_FAMILY = "kintex7" *) (* C_HAS_AXI_ID = "0" *) (* C_HAS_ENA = "0" *) 
(* C_HAS_ENB = "0" *) (* C_HAS_INJECTERR = "0" *) (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
(* C_HAS_MEM_OUTPUT_REGS_B = "0" *) (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
(* C_HAS_REGCEA = "0" *) (* C_HAS_REGCEB = "0" *) (* C_HAS_RSTA = "0" *) 
(* C_HAS_RSTB = "0" *) (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
(* C_INITA_VAL = "0" *) (* C_INITB_VAL = "0" *) (* C_INIT_FILE = "NONE" *) 
(* C_INIT_FILE_NAME = "IB_RAM_blk_mem_gen_1_0.mif" *) (* C_INTERFACE_TYPE = "0" *) (* C_LOAD_INIT_FILE = "1" *) 
(* C_MEM_TYPE = "2" *) (* C_MUX_PIPELINE_STAGES = "0" *) (* C_PRIM_TYPE = "1" *) 
(* C_READ_DEPTH_A = "114" *) (* C_READ_DEPTH_B = "114" *) (* C_READ_LATENCY_A = "1" *) 
(* C_READ_LATENCY_B = "1" *) (* C_READ_WIDTH_A = "36" *) (* C_READ_WIDTH_B = "36" *) 
(* C_RSTRAM_A = "0" *) (* C_RSTRAM_B = "0" *) (* C_RST_PRIORITY_A = "CE" *) 
(* C_RST_PRIORITY_B = "CE" *) (* C_SIM_COLLISION_CHECK = "ALL" *) (* C_USE_BRAM_BLOCK = "0" *) 
(* C_USE_BYTE_WEA = "0" *) (* C_USE_BYTE_WEB = "0" *) (* C_USE_DEFAULT_DATA = "0" *) 
(* C_USE_ECC = "0" *) (* C_USE_SOFTECC = "0" *) (* C_USE_URAM = "0" *) 
(* C_WEA_WIDTH = "1" *) (* C_WEB_WIDTH = "1" *) (* C_WRITE_DEPTH_A = "114" *) 
(* C_WRITE_DEPTH_B = "114" *) (* C_WRITE_MODE_A = "NO_CHANGE" *) (* C_WRITE_MODE_B = "NO_CHANGE" *) 
(* C_WRITE_WIDTH_A = "36" *) (* C_WRITE_WIDTH_B = "36" *) (* C_XDEVICEFAMILY = "kintex7" *) 
(* ORIG_REF_NAME = "blk_mem_gen_v8_4_4" *) (* downgradeipidentifiedwarnings = "yes" *) 
module IB_RAM_blk_mem_gen_1_0_blk_mem_gen_v8_4_4
   (clka,
    rsta,
    ena,
    regcea,
    wea,
    addra,
    dina,
    douta,
    clkb,
    rstb,
    enb,
    regceb,
    web,
    addrb,
    dinb,
    doutb,
    injectsbiterr,
    injectdbiterr,
    eccpipece,
    sbiterr,
    dbiterr,
    rdaddrecc,
    sleep,
    deepsleep,
    shutdown,
    rsta_busy,
    rstb_busy,
    s_aclk,
    s_aresetn,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_rvalid,
    s_axi_rready,
    s_axi_injectsbiterr,
    s_axi_injectdbiterr,
    s_axi_sbiterr,
    s_axi_dbiterr,
    s_axi_rdaddrecc);
  input clka;
  input rsta;
  input ena;
  input regcea;
  input [0:0]wea;
  input [6:0]addra;
  input [35:0]dina;
  output [35:0]douta;
  input clkb;
  input rstb;
  input enb;
  input regceb;
  input [0:0]web;
  input [6:0]addrb;
  input [35:0]dinb;
  output [35:0]doutb;
  input injectsbiterr;
  input injectdbiterr;
  input eccpipece;
  output sbiterr;
  output dbiterr;
  output [6:0]rdaddrecc;
  input sleep;
  input deepsleep;
  input shutdown;
  output rsta_busy;
  output rstb_busy;
  input s_aclk;
  input s_aresetn;
  input [3:0]s_axi_awid;
  input [31:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input s_axi_awvalid;
  output s_axi_awready;
  input [35:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;
  input s_axi_wlast;
  input s_axi_wvalid;
  output s_axi_wready;
  output [3:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output s_axi_bvalid;
  input s_axi_bready;
  input [3:0]s_axi_arid;
  input [31:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input s_axi_arvalid;
  output s_axi_arready;
  output [3:0]s_axi_rid;
  output [35:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rlast;
  output s_axi_rvalid;
  input s_axi_rready;
  input s_axi_injectsbiterr;
  input s_axi_injectdbiterr;
  output s_axi_sbiterr;
  output s_axi_dbiterr;
  output [6:0]s_axi_rdaddrecc;

  wire [6:0]addra;
  wire [6:0]addrb;
  wire clka;
  wire [35:0]dina;
  wire [35:0]dinb;
  wire [35:0]douta;
  wire [35:0]doutb;
  wire [0:0]wea;
  wire [0:0]web;

  IB_RAM_blk_mem_gen_1_0_blk_mem_gen_v8_4_4_synth inst_blk_mem_gen
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .wea(wea),
        .web(web));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_v8_4_4_synth" *) 
module IB_RAM_blk_mem_gen_1_0_blk_mem_gen_v8_4_4_synth
   (douta,
    doutb,
    clka,
    addra,
    addrb,
    dina,
    dinb,
    wea,
    web);
  output [35:0]douta;
  output [35:0]doutb;
  input clka;
  input [6:0]addra;
  input [6:0]addrb;
  input [35:0]dina;
  input [35:0]dinb;
  input [0:0]wea;
  input [0:0]web;

  wire [6:0]addra;
  wire [6:0]addrb;
  wire clka;
  wire [35:0]dina;
  wire [35:0]dinb;
  wire [35:0]douta;
  wire [35:0]doutb;
  wire [0:0]wea;
  wire [0:0]web;

  IB_RAM_blk_mem_gen_1_0_blk_mem_gen_top \gnbram.gnativebmg.native_blk_mem_gen 
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .wea(wea),
        .web(web));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
