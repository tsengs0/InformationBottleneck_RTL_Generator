-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Sat Mar  6 23:27:56 2021
-- Host        : lmpcc-12 running 64-bit SUSE Linux Enterprise Server 15 SP1
-- Command     : write_vhdl -force -mode synth_stub -rename_top ib_memory_system_dn_iter0_24_0 -prefix
--               ib_memory_system_dn_iter0_24_0_ ib_memory_system_dn_iter0_24_0_stub.vhdl
-- Design      : ib_memory_system_dn_iter0_24_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu7ev-ffvc1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ib_memory_system_dn_iter0_24_0 is
  Port ( 
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 8 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 1 downto 0 );
    clkb : in STD_LOGIC;
    addrb : in STD_LOGIC_VECTOR ( 8 downto 0 );
    doutb : out STD_LOGIC_VECTOR ( 1 downto 0 )
  );

end ib_memory_system_dn_iter0_24_0;

architecture stub of ib_memory_system_dn_iter0_24_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,addra[8:0],douta[1:0],clkb,addrb[8:0],doutb[1:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_4,Vivado 2019.2";
begin
end;