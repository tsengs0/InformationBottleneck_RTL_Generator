
// file: clock_domain_clk_wiz_0_2.v
// 
// (c) Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
//----------------------------------------------------------------------------
// User entered comments
//----------------------------------------------------------------------------
// None
//
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// clk_out1__300.00000______0.000______50.0_______81.814_____77.836
// clk_out2__100.00000____-300.000______16.7______101.475_____77.836
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary_________300.000____________0.010

`timescale 1ps/1ps

module clock_domain_clk_wiz_0_2_clk_wiz 

 (// Clock in ports
  // Clock out ports
  output        clk_out1,
  output        clk_out2,
  // Status and control signals
  input         reset,
  output        locked,
  input         clk_in1_p,
  input         clk_in1_n
 );
  // Input buffering
  //------------------------------------
wire clk_in1_clock_domain_clk_wiz_0_2;
wire clk_in2_clock_domain_clk_wiz_0_2;
  IBUFDS clkin1_ibufds
   (.O  (clk_in1_clock_domain_clk_wiz_0_2),
    .I  (clk_in1_p),
    .IB (clk_in1_n));




  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        clk_out1_clock_domain_clk_wiz_0_2;
  wire        clk_out2_clock_domain_clk_wiz_0_2;
  wire        clk_out3_clock_domain_clk_wiz_0_2;
  wire        clk_out4_clock_domain_clk_wiz_0_2;
  wire        clk_out5_clock_domain_clk_wiz_0_2;
  wire        clk_out6_clock_domain_clk_wiz_0_2;
  wire        clk_out7_clock_domain_clk_wiz_0_2;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_clock_domain_clk_wiz_0_2;
  wire        clkfboutb_unused;
    wire clkout0b_unused;
   wire clkout1b_unused;
  wire        clkfbstopped_unused;
  wire        clkinstopped_unused;
  wire        reset_high;

  
    PLLE4_ADV
  #(
    .COMPENSATION         ("AUTO"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT        (4),
    .CLKFBOUT_PHASE       (0.000),
    .CLKOUT0_DIVIDE       (4),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT1_DIVIDE       (12),
    .CLKOUT1_PHASE        (-300.000),
    .CLKOUT1_DUTY_CYCLE   (0.167),
    .CLKIN_PERIOD         (3.333))
  
  plle4_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_clock_domain_clk_wiz_0_2),
    .CLKOUT0             (clk_out1_clock_domain_clk_wiz_0_2),
    .CLKOUT0B            (clkout0b_unused),
    .CLKOUT1             (clk_out2_clock_domain_clk_wiz_0_2),
    .CLKOUT1B            (clkout1b_unused),
     // Input clock control
    .CLKFBIN             (clkfbout_clock_domain_clk_wiz_0_2),
    .CLKIN               (clk_in1_clock_domain_clk_wiz_0_2),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    .CLKOUTPHYEN         (1'b0),
    .CLKOUTPHY           (),
    // Other control and status signals
    .LOCKED              (locked_int),
    .PWRDWN              (1'b0),
    .RST                 (reset_high));
  assign reset_high = reset; 

  assign locked = locked_int;
// Clock Monitor clock assigning
//--------------------------------------
 // Output buffering
  //-----------------------------------






  BUFG clkout1_buf
   (.O   (clk_out1),
    .I   (clk_out1_clock_domain_clk_wiz_0_2));


  BUFG clkout2_buf
   (.O   (clk_out2),
    .I   (clk_out2_clock_domain_clk_wiz_0_2));



endmodule
