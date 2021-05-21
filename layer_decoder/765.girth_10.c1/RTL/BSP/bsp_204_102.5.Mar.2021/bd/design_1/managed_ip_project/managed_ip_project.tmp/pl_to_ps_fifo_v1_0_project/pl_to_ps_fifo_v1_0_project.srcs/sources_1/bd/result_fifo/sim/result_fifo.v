//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
//Date        : Wed Jun 10 00:17:58 2020
//Host        : lmpcc running 64-bit SUSE Linux Enterprise Server 15 SP1
//Command     : generate_target result_fifo.bd
//Design      : result_fifo
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "result_fifo,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=result_fifo,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "result_fifo.hwdef" *) 
module result_fifo
   (FIFO_READ_0_empty,
    FIFO_READ_0_rd_data,
    FIFO_READ_0_rd_en,
    FIFO_WRITE_0_full,
    FIFO_WRITE_0_wr_data,
    FIFO_WRITE_0_wr_en,
    rd_clk,
    rd_rst_busy_0,
    srst_0,
    valid_0,
    wr_clk,
    wr_rst_busy_0);
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 EMPTY" *) output FIFO_READ_0_empty;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 RD_DATA" *) output [31:0]FIFO_READ_0_rd_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 RD_EN" *) input FIFO_READ_0_rd_en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 FULL" *) output FIFO_WRITE_0_full;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 WR_DATA" *) input [31:0]FIFO_WRITE_0_wr_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 WR_EN" *) input FIFO_WRITE_0_wr_en;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.RD_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.RD_CLK, CLK_DOMAIN result_fifo_rd_clk_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input rd_clk;
  output rd_rst_busy_0;
  input srst_0;
  output valid_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.WR_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.WR_CLK, CLK_DOMAIN result_fifo_wr_clk_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input wr_clk;
  output wr_rst_busy_0;

  wire FIFO_READ_0_1_EMPTY;
  wire [31:0]FIFO_READ_0_1_RD_DATA;
  wire FIFO_READ_0_1_RD_EN;
  wire FIFO_WRITE_0_1_FULL;
  wire [31:0]FIFO_WRITE_0_1_WR_DATA;
  wire FIFO_WRITE_0_1_WR_EN;
  wire fifo_generator_0_rd_rst_busy;
  wire fifo_generator_0_valid;
  wire fifo_generator_0_wr_rst_busy;
  wire rd_clk_0_1;
  wire srst_0_1;
  wire wr_clk_0_1;

  assign FIFO_READ_0_1_RD_EN = FIFO_READ_0_rd_en;
  assign FIFO_READ_0_empty = FIFO_READ_0_1_EMPTY;
  assign FIFO_READ_0_rd_data[31:0] = FIFO_READ_0_1_RD_DATA;
  assign FIFO_WRITE_0_1_WR_DATA = FIFO_WRITE_0_wr_data[31:0];
  assign FIFO_WRITE_0_1_WR_EN = FIFO_WRITE_0_wr_en;
  assign FIFO_WRITE_0_full = FIFO_WRITE_0_1_FULL;
  assign rd_clk_0_1 = rd_clk;
  assign rd_rst_busy_0 = fifo_generator_0_rd_rst_busy;
  assign srst_0_1 = srst_0;
  assign valid_0 = fifo_generator_0_valid;
  assign wr_clk_0_1 = wr_clk;
  assign wr_rst_busy_0 = fifo_generator_0_wr_rst_busy;
  result_fifo_fifo_generator_0_0 fifo_generator_0
       (.din(FIFO_WRITE_0_1_WR_DATA),
        .dout(FIFO_READ_0_1_RD_DATA),
        .empty(FIFO_READ_0_1_EMPTY),
        .full(FIFO_WRITE_0_1_FULL),
        .rd_clk(rd_clk_0_1),
        .rd_en(FIFO_READ_0_1_RD_EN),
        .rd_rst_busy(fifo_generator_0_rd_rst_busy),
        .srst(srst_0_1),
        .valid(fifo_generator_0_valid),
        .wr_clk(wr_clk_0_1),
        .wr_en(FIFO_WRITE_0_1_WR_EN),
        .wr_rst_busy(fifo_generator_0_wr_rst_busy));
endmodule
