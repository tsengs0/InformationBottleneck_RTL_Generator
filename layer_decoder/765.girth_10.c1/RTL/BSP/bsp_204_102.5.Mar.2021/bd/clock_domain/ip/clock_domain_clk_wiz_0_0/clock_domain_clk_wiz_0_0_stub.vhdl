-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Fri Feb 19 22:52:28 2021
-- Host        : lmpcc-21 running 64-bit SUSE Linux Enterprise Server 15 SP1
-- Command     : write_vhdl -force -mode synth_stub
--               /home/s1820419/Xilinx/Vivado/project/AXI.UART.customIP/AXI.UART.customIP.srcs/sources_1/bd/clock_domain/ip/clock_domain_clk_wiz_0_0/clock_domain_clk_wiz_0_0_stub.vhdl
-- Design      : clock_domain_clk_wiz_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu7ev-ffvc1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_domain_clk_wiz_0_0 is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_out2 : out STD_LOGIC;
    clk_out3 : out STD_LOGIC;
    clk_out4 : out STD_LOGIC;
    clk_out5 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1_p : in STD_LOGIC;
    clk_in1_n : in STD_LOGIC
  );

end clock_domain_clk_wiz_0_0;

architecture stub of clock_domain_clk_wiz_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,reset,locked,clk_in1_p,clk_in1_n";
begin
end;
