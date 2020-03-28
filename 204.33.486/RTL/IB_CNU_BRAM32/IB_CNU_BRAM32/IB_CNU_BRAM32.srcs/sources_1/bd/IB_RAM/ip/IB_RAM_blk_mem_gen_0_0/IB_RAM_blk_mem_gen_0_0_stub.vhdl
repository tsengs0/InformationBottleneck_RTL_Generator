-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Mon Mar 23 19:36:45 2020
-- Host        : uv running 64-bit SUSE Linux Enterprise Server 12 SP1
-- Command     : write_vhdl -force -mode synth_stub
--               /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_CNU_BRAM32/IB_CNU_BRAM32/IB_CNU_BRAM32.srcs/sources_1/bd/IB_RAM/ip/IB_RAM_blk_mem_gen_0_0/IB_RAM_blk_mem_gen_0_0_stub.vhdl
-- Design      : IB_RAM_blk_mem_gen_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu7ev-ffvc1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IB_RAM_blk_mem_gen_0_0 is
  Port ( 
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 6 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 31 downto 0 );
    clkb : in STD_LOGIC;
    addrb : in STD_LOGIC_VECTOR ( 6 downto 0 );
    doutb : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );

end IB_RAM_blk_mem_gen_0_0;

architecture stub of IB_RAM_blk_mem_gen_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,addra[6:0],douta[31:0],clkb,addrb[6:0],doutb[31:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_4,Vivado 2019.2";
begin
end;
