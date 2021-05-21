-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Wed Jan 27 20:18:49 2021
-- Host        : lmpcc-21 running 64-bit SUSE Linux Enterprise Server 15 SP1
-- Command     : write_vhdl -force -mode synth_stub
--               /home/s1820419/Xilinx/Vivado/project/AXI.UART.customIP/AXI.UART.customIP.srcs/sources_1/bd/test/ip/test_axis_pl2ps_fifo_0_0/test_axis_pl2ps_fifo_0_0_stub.vhdl
-- Design      : test_axis_pl2ps_fifo_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu7ev-ffvc1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_axis_pl2ps_fifo_0_0 is
  Port ( 
    FrameSize : in STD_LOGIC_VECTOR ( 7 downto 0 );
    En : in STD_LOGIC;
    AXI_En : in STD_LOGIC;
    s_axis_aclk : in STD_LOGIC;
    s_axis_aresetn : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_tstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axis_tlast : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    m_axis_aclk : in STD_LOGIC;
    m_axis_aresetn : in STD_LOGIC;
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_tstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axis_tlast : out STD_LOGIC;
    m_axis_tready : in STD_LOGIC;
    result_fifo_in : in STD_LOGIC_VECTOR ( 31 downto 0 );
    result_fifo_we : in STD_LOGIC;
    pl_fifo_wr_clk : in STD_LOGIC
  );

end test_axis_pl2ps_fifo_0_0;

architecture stub of test_axis_pl2ps_fifo_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "FrameSize[7:0],En,AXI_En,s_axis_aclk,s_axis_aresetn,s_axis_tready,s_axis_tdata[31:0],s_axis_tstrb[3:0],s_axis_tlast,s_axis_tvalid,m_axis_aclk,m_axis_aresetn,m_axis_tvalid,m_axis_tdata[31:0],m_axis_tstrb[3:0],m_axis_tlast,m_axis_tready,result_fifo_in[31:0],result_fifo_we,pl_fifo_wr_clk";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "axis_pl2ps_fifo_v1_0,Vivado 2019.2";
begin
end;
