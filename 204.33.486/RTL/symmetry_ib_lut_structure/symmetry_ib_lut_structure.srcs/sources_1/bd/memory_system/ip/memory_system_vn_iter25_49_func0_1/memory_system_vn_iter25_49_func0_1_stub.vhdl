-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Thu Sep 17 15:20:40 2020
-- Host        : lmpcc running 64-bit SUSE Linux Enterprise Server 15 SP1
-- Command     : write_vhdl -force -mode synth_stub -rename_top memory_system_vn_iter25_49_func0_1 -prefix
--               memory_system_vn_iter25_49_func0_1_ memory_system_vn_iter25_49_func0_1_stub.vhdl
-- Design      : memory_system_vn_iter25_49_func0_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu7ev-ffvc1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory_system_vn_iter25_49_func0_1 is
  Port ( 
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 10 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 1 downto 0 );
    clkb : in STD_LOGIC;
    enb : in STD_LOGIC;
    addrb : in STD_LOGIC_VECTOR ( 10 downto 0 );
    doutb : out STD_LOGIC_VECTOR ( 1 downto 0 )
  );

end memory_system_vn_iter25_49_func0_1;

architecture stub of memory_system_vn_iter25_49_func0_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,addra[10:0],douta[1:0],clkb,enb,addrb[10:0],doutb[1:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_4,Vivado 2019.2";
begin
end;
