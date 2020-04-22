`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2020 06:10:51 PM
// Design Name: 
// Module Name: ib_cnu_6
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "define.v"

module ib_cnu6_f0_pipeReg (
    output reg [4:0] f00_page_addr,
    output reg [2:0] f00_bank_addr,
    output reg [4:0] f01_page_addr,
    output reg [2:0] f01_bank_addr,
    output reg [`QUAN_SIZE-1:0] M0_reg,
    output reg [`QUAN_SIZE-1:0] M1_reg,
    output reg [`QUAN_SIZE-1:0] M2_reg,
    output reg [`QUAN_SIZE-1:0] M3_reg,
    output reg [`QUAN_SIZE-1:0] M4_reg,
    output reg [`QUAN_SIZE-1:0] M5_reg,
        
    input wire [`QUAN_SIZE-1:0] M0,
    input wire [`QUAN_SIZE-1:0] M1,
    input wire [`QUAN_SIZE-1:0] M2,
    input wire [`QUAN_SIZE-1:0] M3,
    input wire [`QUAN_SIZE-1:0] M4,
    input wire [`QUAN_SIZE-1:0] M5,
    input wire ram_clk,
    input wire en
);
wire [4:0] f00_page_addr_wire;
wire [2:0] f00_bank_addr_wire;
reconf_ib_lut2 func_00(
     .ib_ram_page_addr (f00_page_addr_wire[4:0]),
     .ib_ram_bank_addr (f00_bank_addr_wire[2:0]),
    
     .y0 (M0[`QUAN_SIZE-1:0]),
     .y1 (M1[`QUAN_SIZE-1:0])
);
always @(posedge ram_clk, posedge en) begin
    if(en) begin
        f00_page_addr[4:0] <= 5'd0;
        f00_bank_addr[2:0] <= 3'd0;
    end
    else begin
        f00_page_addr[4:0] <= f00_page_addr_wire[4:0];
        f00_bank_addr[2:0] <= f00_bank_addr_wire[2:0];    
    end
end

wire [4:0] f01_page_addr_wire;
wire [2:0] f01_bank_addr_wire;
reconf_ib_lut2 func_01(
     .ib_ram_page_addr (f01_page_addr_wire[4:0]),
     .ib_ram_bank_addr (f01_bank_addr_wire[2:0]),
    
     .y0 (M3[`QUAN_SIZE-1:0]),
     .y1 (M4[`QUAN_SIZE-1:0])
);
always @(posedge ram_clk, posedge en) begin
    if(en) begin
        f01_page_addr[4:0] <= 5'd0;
        f01_bank_addr[2:0] <= 3'd0;
    end
    else begin
        f01_page_addr[4:0] <= f01_page_addr_wire[4:0];
        f01_bank_addr[2:0] <= f01_bank_addr_wire[2:0];    
    end
end

always @(posedge ram_clk, posedge en) begin
    if(en) begin
        M0_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        M1_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        M2_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        M3_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        M4_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        M5_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
    end
    else begin
        M0_reg[`QUAN_SIZE-1:0] <= M0[`QUAN_SIZE-1:0];
        M1_reg[`QUAN_SIZE-1:0] <= M1[`QUAN_SIZE-1:0];
        M2_reg[`QUAN_SIZE-1:0] <= M2[`QUAN_SIZE-1:0];
        M3_reg[`QUAN_SIZE-1:0] <= M3[`QUAN_SIZE-1:0];
        M4_reg[`QUAN_SIZE-1:0] <= M4[`QUAN_SIZE-1:0];
        M5_reg[`QUAN_SIZE-1:0] <= M5[`QUAN_SIZE-1:0];    
    end
end
/*
assign M0_reg[`QUAN_SIZE-1:0] = M0[`QUAN_SIZE-1:0];
assign M1_reg[`QUAN_SIZE-1:0] = M1[`QUAN_SIZE-1:0];
assign M2_reg[`QUAN_SIZE-1:0] = M2[`QUAN_SIZE-1:0];
assign M3_reg[`QUAN_SIZE-1:0] = M3[`QUAN_SIZE-1:0];
assign M4_reg[`QUAN_SIZE-1:0] = M4[`QUAN_SIZE-1:0];
assign M5_reg[`QUAN_SIZE-1:0] = M5[`QUAN_SIZE-1:0];
*/
endmodule

module ib_cnu6_f1_pipeReg (
    output reg [4:0] f10_page_addr,
    output reg [2:0] f10_bank_addr,
    output reg [4:0] f11_page_addr,
    output reg [2:0] f11_bank_addr,
    output reg [`QUAN_SIZE-1:0] M0_reg,
    output reg [`QUAN_SIZE-1:0] M1_reg,
    output reg [`QUAN_SIZE-1:0] M2_reg,
    output reg [`QUAN_SIZE-1:0] M3_reg,
    output reg [`QUAN_SIZE-1:0] M4_reg,
    output reg [`QUAN_SIZE-1:0] M5_reg,

    input wire [`QUAN_SIZE-1:0] t_00,
    input wire [`QUAN_SIZE-1:0] t_01,
    input wire [`QUAN_SIZE-1:0] M0,
    input wire [`QUAN_SIZE-1:0] M1,
    input wire [`QUAN_SIZE-1:0] M2,
    input wire [`QUAN_SIZE-1:0] M3,
    input wire [`QUAN_SIZE-1:0] M4,
    input wire [`QUAN_SIZE-1:0] M5,
    input wire ram_clk,
    input wire en              
);

wire [4:0] f10_page_addr_wire;
wire [2:0] f10_bank_addr_wire;
reconf_ib_lut2 func_10(
     .ib_ram_page_addr (f10_page_addr_wire[4:0]),
     .ib_ram_bank_addr (f10_bank_addr_wire[2:0]),
    
     .y0 (t_00[`QUAN_SIZE-1:0]),
     .y1 (M2[`QUAN_SIZE-1:0])
);
always @(posedge ram_clk, posedge en) begin
    if(en) begin
        f10_page_addr[4:0] <= 5'd0;
        f10_bank_addr[2:0] <= 3'd0;
    end
    else begin
        f10_page_addr[4:0] <= f10_page_addr_wire[4:0];
        f10_bank_addr[2:0] <= f10_bank_addr_wire[2:0];    
    end
end

wire [4:0] f11_page_addr_wire;
wire [2:0] f11_bank_addr_wire;
reconf_ib_lut2 func_11(
     .ib_ram_page_addr (f11_page_addr_wire[4:0]),
     .ib_ram_bank_addr (f11_bank_addr_wire[2:0]),
    
     .y0 (t_01[`QUAN_SIZE-1:0]),
     .y1 (M5[`QUAN_SIZE-1:0])
);
always @(posedge ram_clk, posedge en) begin
    if(en) begin
        f11_page_addr[4:0] <= 5'd0;
        f11_bank_addr[2:0] <= 3'd0;
    end
    else begin
        f11_page_addr[4:0] <= f11_page_addr_wire[4:0];
        f11_bank_addr[2:0] <= f11_bank_addr_wire[2:0];    
    end
end

always @(posedge ram_clk, posedge en) begin
    if(en) begin
        M0_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        M1_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        M2_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        M3_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        M4_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        M5_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
    end
    else begin
        M0_reg[`QUAN_SIZE-1:0] <= M0[`QUAN_SIZE-1:0];
        M1_reg[`QUAN_SIZE-1:0] <= M1[`QUAN_SIZE-1:0];
        M2_reg[`QUAN_SIZE-1:0] <= M2[`QUAN_SIZE-1:0];
        M3_reg[`QUAN_SIZE-1:0] <= M3[`QUAN_SIZE-1:0];
        M4_reg[`QUAN_SIZE-1:0] <= M4[`QUAN_SIZE-1:0];
        M5_reg[`QUAN_SIZE-1:0] <= M5[`QUAN_SIZE-1:0];    
    end
end
/*
assign M0_reg[`QUAN_SIZE-1:0] = M0[`QUAN_SIZE-1:0];
assign M1_reg[`QUAN_SIZE-1:0] = M1[`QUAN_SIZE-1:0];
assign M2_reg[`QUAN_SIZE-1:0] = M2[`QUAN_SIZE-1:0];
assign M3_reg[`QUAN_SIZE-1:0] = M3[`QUAN_SIZE-1:0];
assign M4_reg[`QUAN_SIZE-1:0] = M4[`QUAN_SIZE-1:0];
assign M5_reg[`QUAN_SIZE-1:0] = M5[`QUAN_SIZE-1:0];
*/
endmodule

module ib_cnu6_f2_pipeReg (
    output reg [4:0] f20_page_addr,
    output reg [2:0] f20_bank_addr,
    output reg [4:0] f21_page_addr,
    output reg [2:0] f21_bank_addr,
    output reg [4:0] f22_page_addr,
    output reg [2:0] f22_bank_addr,
    output reg [4:0] f23_page_addr,
    output reg [2:0] f23_bank_addr,
    output reg [`QUAN_SIZE-1:0] M1_reg,
    output reg [`QUAN_SIZE-1:0] M2_reg,
    output reg [`QUAN_SIZE-1:0] M4_reg,
    output reg [`QUAN_SIZE-1:0] M5_reg,

    input wire [`QUAN_SIZE-1:0] t_10,
    input wire [`QUAN_SIZE-1:0] t_11,
    input wire [`QUAN_SIZE-1:0] M0,
    input wire [`QUAN_SIZE-1:0] M1,
    input wire [`QUAN_SIZE-1:0] M2,
    input wire [`QUAN_SIZE-1:0] M3,
    input wire [`QUAN_SIZE-1:0] M4,
    input wire [`QUAN_SIZE-1:0] M5,
    input wire ram_clk,
    input wire en               
);
wire [4:0] f20_page_addr_wire;
wire [2:0] f20_bank_addr_wire;
reconf_ib_lut2 func_20(
     .ib_ram_page_addr (f20_page_addr_wire[4:0]),
     .ib_ram_bank_addr (f20_bank_addr_wire[2:0]),
    
     .y0 (t_10[`QUAN_SIZE-1:0]),
     .y1 (M3[`QUAN_SIZE-1:0])
);
always @(posedge ram_clk, posedge en) begin
    if(en) begin
        f20_page_addr[4:0] <= 5'd0;
        f20_bank_addr[2:0] <= 3'd0;
    end
    else begin
        f20_page_addr[4:0] <= f20_page_addr_wire[4:0];
        f20_bank_addr[2:0] <= f20_bank_addr_wire[2:0];    
    end
end

wire [4:0] f21_page_addr_wire;
wire [2:0] f21_bank_addr_wire;
reconf_ib_lut2 func_21(
     .ib_ram_page_addr (f21_page_addr_wire[4:0]),
     .ib_ram_bank_addr (f21_bank_addr_wire[2:0]),
    
     .y0 (t_10[`QUAN_SIZE-1:0]),
     .y1 (M4[`QUAN_SIZE-1:0])
);
always @(posedge ram_clk, posedge en) begin
    if(en) begin
        f21_page_addr[4:0] <= 5'd0;
        f21_bank_addr[2:0] <= 3'd0;
    end
    else begin
        f21_page_addr[4:0] <= f21_page_addr_wire[4:0];
        f21_bank_addr[2:0] <= f21_bank_addr_wire[2:0];    
    end
end

wire [4:0] f22_page_addr_wire;
wire [2:0] f22_bank_addr_wire;
reconf_ib_lut2 func_22(
     .ib_ram_page_addr (f22_page_addr_wire[4:0]),
     .ib_ram_bank_addr (f22_bank_addr_wire[2:0]),
    
     .y0 (t_11[`QUAN_SIZE-1:0]),
     .y1 (M0[`QUAN_SIZE-1:0])
);
always @(posedge ram_clk, posedge en) begin
    if(en) begin
        f22_page_addr[4:0] <= 5'd0;
        f22_bank_addr[2:0] <= 3'd0;
    end
    else begin
        f22_page_addr[4:0] <= f22_page_addr_wire[4:0];
        f22_bank_addr[2:0] <= f22_bank_addr_wire[2:0];    
    end
end

wire [4:0] f23_page_addr_wire;
wire [2:0] f23_bank_addr_wire;
reconf_ib_lut2 func_23(
     .ib_ram_page_addr (f23_page_addr_wire[4:0]),
     .ib_ram_bank_addr (f23_bank_addr_wire[2:0]),
    
     .y0 (t_11[`QUAN_SIZE-1:0]),
     .y1 (M1[`QUAN_SIZE-1:0])
);
always @(posedge ram_clk, posedge en) begin
    if(en) begin
        f23_page_addr[4:0] <= 5'd0;
        f23_bank_addr[2:0] <= 3'd0;
    end
    else begin
        f23_page_addr[4:0] <= f23_page_addr_wire[4:0];
        f23_bank_addr[2:0] <= f23_bank_addr_wire[2:0];    
    end
end

always @(posedge ram_clk, posedge en) begin
    if(en) begin
        M1_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        M2_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        M4_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        M5_reg[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
    end
    else begin
        M1_reg[`QUAN_SIZE-1:0] <= M1[`QUAN_SIZE-1:0];
        M2_reg[`QUAN_SIZE-1:0] <= M2[`QUAN_SIZE-1:0];
        M4_reg[`QUAN_SIZE-1:0] <= M4[`QUAN_SIZE-1:0];
        M5_reg[`QUAN_SIZE-1:0] <= M5[`QUAN_SIZE-1:0];    
    end
end
/*
assign M1_reg[`QUAN_SIZE-1:0] = M1[`QUAN_SIZE-1:0];
assign M2_reg[`QUAN_SIZE-1:0] = M2[`QUAN_SIZE-1:0];
assign M4_reg[`QUAN_SIZE-1:0] = M4[`QUAN_SIZE-1:0];
assign M5_reg[`QUAN_SIZE-1:0] = M5[`QUAN_SIZE-1:0];
*/
endmodule

module ib_cnu6_f3_pipeReg (
    output reg [4:0] f30_page_addr,
    output reg [2:0] f30_bank_addr,
    output reg [4:0] f31_page_addr,
    output reg [2:0] f31_bank_addr,
    output reg [4:0] f32_page_addr,
    output reg [2:0] f32_bank_addr,
    output reg [4:0] f33_page_addr,
    output reg [2:0] f33_bank_addr,
    output reg [4:0] f34_page_addr,
    output reg [2:0] f34_bank_addr,
    output reg [4:0] f35_page_addr,
    output reg [2:0] f35_bank_addr,

    input wire [`QUAN_SIZE-1:0] t_20,
    input wire [`QUAN_SIZE-1:0] t_21,
    input wire [`QUAN_SIZE-1:0] t_22,
    input wire [`QUAN_SIZE-1:0] t_23,
    input wire [`QUAN_SIZE-1:0] M1,
    input wire [`QUAN_SIZE-1:0] M2,
    input wire [`QUAN_SIZE-1:0] M4,
    input wire [`QUAN_SIZE-1:0] M5,
    input wire ram_clk,
    input wire en               
);

wire [4:0] f30_page_addr_wire;
wire [2:0] f30_bank_addr_wire;
reconf_ib_lut2 func_30(
     .ib_ram_page_addr (f30_page_addr_wire[4:0]),
     .ib_ram_bank_addr (f30_bank_addr_wire[2:0]),
    
     .y0 (t_20[`QUAN_SIZE-1:0]),
     .y1 (M4[`QUAN_SIZE-1:0])
);
always @(posedge ram_clk, posedge en) begin
    if(en) begin
        f30_page_addr[4:0] <= 5'd0;
        f30_bank_addr[2:0] <= 3'd0;
    end
    else begin
        f30_page_addr[4:0] <= f30_page_addr_wire[4:0];
        f30_bank_addr[2:0] <= f30_bank_addr_wire[2:0];    
    end
end

wire [4:0] f31_page_addr_wire;
wire [2:0] f31_bank_addr_wire;
reconf_ib_lut2 func_31(
     .ib_ram_page_addr (f31_page_addr_wire[4:0]),
     .ib_ram_bank_addr (f31_bank_addr_wire[2:0]),
    
     .y0 (t_20[`QUAN_SIZE-1:0]),
     .y1 (M5[`QUAN_SIZE-1:0])
);
always @(posedge ram_clk, posedge en) begin
    if(en) begin
        f31_page_addr[4:0] <= 5'd0;
        f31_bank_addr[2:0] <= 3'd0;
    end
    else begin
        f31_page_addr[4:0] <= f31_page_addr_wire[4:0];
        f31_bank_addr[2:0] <= f31_bank_addr_wire[2:0];    
    end
end

wire [4:0] f32_page_addr_wire;
wire [2:0] f32_bank_addr_wire;
reconf_ib_lut2 func_32(
     .ib_ram_page_addr (f32_page_addr_wire[4:0]),
     .ib_ram_bank_addr (f32_bank_addr_wire[2:0]),
    
     .y0 (t_21[`QUAN_SIZE-1:0]),
     .y1 (M5[`QUAN_SIZE-1:0])
);
always @(posedge ram_clk, posedge en) begin
    if(en) begin
        f32_page_addr[4:0] <= 5'd0;
        f32_bank_addr[2:0] <= 3'd0;
    end
    else begin
        f32_page_addr[4:0] <= f32_page_addr_wire[4:0];
        f32_bank_addr[2:0] <= f32_bank_addr_wire[2:0];    
    end
end

wire [4:0] f33_page_addr_wire;
wire [2:0] f33_bank_addr_wire;
reconf_ib_lut2 func_33(
     .ib_ram_page_addr (f33_page_addr_wire[4:0]),
     .ib_ram_bank_addr (f33_bank_addr_wire[2:0]),
    
     .y0 (t_22[`QUAN_SIZE-1:0]),
     .y1 (M1[`QUAN_SIZE-1:0])
);
always @(posedge ram_clk, posedge en) begin
    if(en) begin
        f33_page_addr[4:0] <= 5'd0;
        f33_bank_addr[2:0] <= 3'd0;
    end
    else begin
        f33_page_addr[4:0] <= f33_page_addr_wire[4:0];
        f33_bank_addr[2:0] <= f33_bank_addr_wire[2:0];    
    end
end

wire [4:0] f34_page_addr_wire;
wire [2:0] f34_bank_addr_wire;
reconf_ib_lut2 func_34(
     .ib_ram_page_addr (f34_page_addr_wire[4:0]),
     .ib_ram_bank_addr (f34_bank_addr_wire[2:0]),
    
     .y0 (t_22[`QUAN_SIZE-1:0]),
     .y1 (M2[`QUAN_SIZE-1:0])
);
always @(posedge ram_clk, posedge en) begin
    if(en) begin
        f34_page_addr[4:0] <= 5'd0;
        f34_bank_addr[2:0] <= 3'd0;
    end
    else begin
        f34_page_addr[4:0] <= f34_page_addr_wire[4:0];
        f34_bank_addr[2:0] <= f34_bank_addr_wire[2:0];    
    end
end

wire [4:0] f35_page_addr_wire;
wire [2:0] f35_bank_addr_wire;
reconf_ib_lut2 func_35(
     .ib_ram_page_addr (f35_page_addr_wire[4:0]),
     .ib_ram_bank_addr (f35_bank_addr_wire[2:0]),
    
     .y0 (t_23[`QUAN_SIZE-1:0]),
     .y1 (M2[`QUAN_SIZE-1:0])
);
always @(posedge ram_clk, posedge en) begin
    if(en) begin
        f35_page_addr[4:0] <= 5'd0;
        f35_bank_addr[2:0] <= 3'd0;
    end
    else begin
        f35_page_addr[4:0] <= f35_page_addr_wire[4:0];
        f35_bank_addr[2:0] <= f35_bank_addr_wire[2:0];    
    end
end
endmodule

module ib_cnu6_c2v_pipeReg (
    output reg [`QUAN_SIZE-1:0] E0,
    output reg [`QUAN_SIZE-1:0] E1,
    output reg [`QUAN_SIZE-1:0] E2,
    output reg [`QUAN_SIZE-1:0] E3,
    output reg [`QUAN_SIZE-1:0] E4,
    output reg [`QUAN_SIZE-1:0] E5,

    input wire [`QUAN_SIZE-1:0] M0,
    input wire [`QUAN_SIZE-1:0] M1,
    input wire [`QUAN_SIZE-1:0] M2,
    input wire [`QUAN_SIZE-1:0] M3,
    input wire [`QUAN_SIZE-1:0] M4,
    input wire [`QUAN_SIZE-1:0] M5,
    input wire ram_clk,
    input wire en              
);

always @(posedge ram_clk, posedge en) begin
    if(en) begin
        E0[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        E1[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        E2[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        E3[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        E4[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
        E5[`QUAN_SIZE-1:0] <= `QUAN_SIZE'd0;
    end
    else begin
        E0[`QUAN_SIZE-1:0] <= M0[`QUAN_SIZE-1:0];
        E1[`QUAN_SIZE-1:0] <= M1[`QUAN_SIZE-1:0];
        E2[`QUAN_SIZE-1:0] <= M2[`QUAN_SIZE-1:0];
        E3[`QUAN_SIZE-1:0] <= M3[`QUAN_SIZE-1:0];
        E4[`QUAN_SIZE-1:0] <= M4[`QUAN_SIZE-1:0];
        E5[`QUAN_SIZE-1:0] <= M5[`QUAN_SIZE-1:0];    
    end
end
/*
assign E0[`QUAN_SIZE-1:0] = M0[`QUAN_SIZE-1:0];
assign E1[`QUAN_SIZE-1:0] = M1[`QUAN_SIZE-1:0];
assign E2[`QUAN_SIZE-1:0] = M2[`QUAN_SIZE-1:0];
assign E3[`QUAN_SIZE-1:0] = M3[`QUAN_SIZE-1:0];
assign E4[`QUAN_SIZE-1:0] = M4[`QUAN_SIZE-1:0];
assign E5[`QUAN_SIZE-1:0] = M5[`QUAN_SIZE-1:0];
*/
endmodule