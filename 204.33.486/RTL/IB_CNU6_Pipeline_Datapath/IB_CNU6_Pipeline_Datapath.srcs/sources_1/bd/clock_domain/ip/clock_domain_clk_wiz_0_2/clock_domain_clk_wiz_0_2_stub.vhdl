-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Fri Apr  3 12:42:21 2020
-- Host        : uv running 64-bit SUSE Linux Enterprise Server 12 SP1
-- Command     : write_vhdl -force -mode synth_stub
--               /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_CNU6_Pipeline_Datapath/IB_CNU6_Pipeline_Datapath.srcs/sources_1/bd/clock_domain/ip/clock_domain_clk_wiz_0_2/clock_domain_clk_wiz_0_2_stub.vhdl
-- Design      : clock_domain_clk_wiz_0_2
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu7ev-ffvc1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_domain_clk_wiz_0_2 is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_out2 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1_p : in STD_LOGIC;
    clk_in1_n : in STD_LOGIC
  );

end clock_domain_clk_wiz_0_2;

architecture stub of clock_domain_clk_wiz_0_2 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,clk_out2,reset,locked,clk_in1_p,clk_in1_n";
begin
end;
