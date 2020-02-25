-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Tue Feb 25 01:25:14 2020
-- Host        : vpcc running 64-bit CentOS Linux release 7.4.1708 (Core)
-- Command     : write_vhdl -force -mode synth_stub
--               /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_LUT/IB_LUT.srcs/sources_1/bd/IB_RAM/ip/IB_RAM_blk_mem_gen_0_0/IB_RAM_blk_mem_gen_0_0_stub.vhdl
-- Design      : IB_RAM_blk_mem_gen_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IB_RAM_blk_mem_gen_0_0 is
  Port ( 
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 0 to 0 );
    addra : in STD_LOGIC_VECTOR ( 1 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 1023 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 1023 downto 0 );
    clkb : in STD_LOGIC;
    enb : in STD_LOGIC;
    web : in STD_LOGIC_VECTOR ( 0 to 0 );
    addrb : in STD_LOGIC_VECTOR ( 1 downto 0 );
    dinb : in STD_LOGIC_VECTOR ( 1023 downto 0 );
    doutb : out STD_LOGIC_VECTOR ( 1023 downto 0 )
  );

end IB_RAM_blk_mem_gen_0_0;

architecture stub of IB_RAM_blk_mem_gen_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,ena,wea[0:0],addra[1:0],dina[1023:0],douta[1023:0],clkb,enb,web[0:0],addrb[1:0],dinb[1023:0],doutb[1023:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_4,Vivado 2019.2";
begin
end;
