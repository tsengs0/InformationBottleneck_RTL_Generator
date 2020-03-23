-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
-- Date        : Sat Mar 21 01:09:36 2020
-- Host        : uv running 64-bit SUSE Linux Enterprise Server 12 SP1
-- Command     : write_vhdl -force -mode funcsim
--               /home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/IB_LUT/IB_LUT.srcs/sources_1/bd/clock_domain/ip/clock_domain_clk_wiz_0_1/clock_domain_clk_wiz_0_1_sim_netlist.vhdl
-- Design      : clock_domain_clk_wiz_0_1
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7k325tffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity clock_domain_clk_wiz_0_1_clock_domain_clk_wiz_0_1_clk_wiz is
  port (
    clk_out1 : out STD_LOGIC;
    clk_out2 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1_p : in STD_LOGIC;
    clk_in1_n : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of clock_domain_clk_wiz_0_1_clock_domain_clk_wiz_0_1_clk_wiz : entity is "clock_domain_clk_wiz_0_1_clk_wiz";
end clock_domain_clk_wiz_0_1_clock_domain_clk_wiz_0_1_clk_wiz;

architecture STRUCTURE of clock_domain_clk_wiz_0_1_clock_domain_clk_wiz_0_1_clk_wiz is
  signal clk_in1_clock_domain_clk_wiz_0_1 : STD_LOGIC;
  signal clk_out1_clock_domain_clk_wiz_0_1 : STD_LOGIC;
  signal clk_out2_clock_domain_clk_wiz_0_1 : STD_LOGIC;
  signal clkfbout_buf_clock_domain_clk_wiz_0_1 : STD_LOGIC;
  signal clkfbout_clock_domain_clk_wiz_0_1 : STD_LOGIC;
  signal NLW_plle2_adv_inst_CLKOUT2_UNCONNECTED : STD_LOGIC;
  signal NLW_plle2_adv_inst_CLKOUT3_UNCONNECTED : STD_LOGIC;
  signal NLW_plle2_adv_inst_CLKOUT4_UNCONNECTED : STD_LOGIC;
  signal NLW_plle2_adv_inst_CLKOUT5_UNCONNECTED : STD_LOGIC;
  signal NLW_plle2_adv_inst_DRDY_UNCONNECTED : STD_LOGIC;
  signal NLW_plle2_adv_inst_DO_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of clkf_buf : label is "PRIMITIVE";
  attribute BOX_TYPE of clkin1_ibufgds : label is "PRIMITIVE";
  attribute CAPACITANCE : string;
  attribute CAPACITANCE of clkin1_ibufgds : label is "DONT_CARE";
  attribute IBUF_DELAY_VALUE : string;
  attribute IBUF_DELAY_VALUE of clkin1_ibufgds : label is "0";
  attribute IFD_DELAY_VALUE : string;
  attribute IFD_DELAY_VALUE of clkin1_ibufgds : label is "AUTO";
  attribute BOX_TYPE of clkout1_buf : label is "PRIMITIVE";
  attribute BOX_TYPE of clkout2_buf : label is "PRIMITIVE";
  attribute BOX_TYPE of plle2_adv_inst : label is "PRIMITIVE";
begin
clkf_buf: unisim.vcomponents.BUFG
     port map (
      I => clkfbout_clock_domain_clk_wiz_0_1,
      O => clkfbout_buf_clock_domain_clk_wiz_0_1
    );
clkin1_ibufgds: unisim.vcomponents.IBUFDS
    generic map(
      IOSTANDARD => "DEFAULT"
    )
        port map (
      I => clk_in1_p,
      IB => clk_in1_n,
      O => clk_in1_clock_domain_clk_wiz_0_1
    );
clkout1_buf: unisim.vcomponents.BUFG
     port map (
      I => clk_out1_clock_domain_clk_wiz_0_1,
      O => clk_out1
    );
clkout2_buf: unisim.vcomponents.BUFG
     port map (
      I => clk_out2_clock_domain_clk_wiz_0_1,
      O => clk_out2
    );
plle2_adv_inst: unisim.vcomponents.PLLE2_ADV
    generic map(
      BANDWIDTH => "OPTIMIZED",
      CLKFBOUT_MULT => 9,
      CLKFBOUT_PHASE => 0.000000,
      CLKIN1_PERIOD => 5.000000,
      CLKIN2_PERIOD => 0.000000,
      CLKOUT0_DIVIDE => 3,
      CLKOUT0_DUTY_CYCLE => 0.500000,
      CLKOUT0_PHASE => 0.000000,
      CLKOUT1_DIVIDE => 9,
      CLKOUT1_DUTY_CYCLE => 0.167000,
      CLKOUT1_PHASE => 60.000000,
      CLKOUT2_DIVIDE => 1,
      CLKOUT2_DUTY_CYCLE => 0.500000,
      CLKOUT2_PHASE => 0.000000,
      CLKOUT3_DIVIDE => 1,
      CLKOUT3_DUTY_CYCLE => 0.500000,
      CLKOUT3_PHASE => 0.000000,
      CLKOUT4_DIVIDE => 1,
      CLKOUT4_DUTY_CYCLE => 0.500000,
      CLKOUT4_PHASE => 0.000000,
      CLKOUT5_DIVIDE => 1,
      CLKOUT5_DUTY_CYCLE => 0.500000,
      CLKOUT5_PHASE => 0.000000,
      COMPENSATION => "ZHOLD",
      DIVCLK_DIVIDE => 2,
      IS_CLKINSEL_INVERTED => '0',
      IS_PWRDWN_INVERTED => '0',
      IS_RST_INVERTED => '0',
      REF_JITTER1 => 0.010000,
      REF_JITTER2 => 0.010000,
      STARTUP_WAIT => "FALSE"
    )
        port map (
      CLKFBIN => clkfbout_buf_clock_domain_clk_wiz_0_1,
      CLKFBOUT => clkfbout_clock_domain_clk_wiz_0_1,
      CLKIN1 => clk_in1_clock_domain_clk_wiz_0_1,
      CLKIN2 => '0',
      CLKINSEL => '1',
      CLKOUT0 => clk_out1_clock_domain_clk_wiz_0_1,
      CLKOUT1 => clk_out2_clock_domain_clk_wiz_0_1,
      CLKOUT2 => NLW_plle2_adv_inst_CLKOUT2_UNCONNECTED,
      CLKOUT3 => NLW_plle2_adv_inst_CLKOUT3_UNCONNECTED,
      CLKOUT4 => NLW_plle2_adv_inst_CLKOUT4_UNCONNECTED,
      CLKOUT5 => NLW_plle2_adv_inst_CLKOUT5_UNCONNECTED,
      DADDR(6 downto 0) => B"0000000",
      DCLK => '0',
      DEN => '0',
      DI(15 downto 0) => B"0000000000000000",
      DO(15 downto 0) => NLW_plle2_adv_inst_DO_UNCONNECTED(15 downto 0),
      DRDY => NLW_plle2_adv_inst_DRDY_UNCONNECTED,
      DWE => '0',
      LOCKED => locked,
      PWRDWN => '0',
      RST => reset
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity clock_domain_clk_wiz_0_1 is
  port (
    clk_out1 : out STD_LOGIC;
    clk_out2 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1_p : in STD_LOGIC;
    clk_in1_n : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of clock_domain_clk_wiz_0_1 : entity is true;
end clock_domain_clk_wiz_0_1;

architecture STRUCTURE of clock_domain_clk_wiz_0_1 is
begin
inst: entity work.clock_domain_clk_wiz_0_1_clock_domain_clk_wiz_0_1_clk_wiz
     port map (
      clk_in1_n => clk_in1_n,
      clk_in1_p => clk_in1_p,
      clk_out1 => clk_out1,
      clk_out2 => clk_out2,
      locked => locked,
      reset => reset
    );
end STRUCTURE;
