`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2020 17:33:45
// Design Name: 
// Module Name: cnu6_ram_write_tb
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
module cnu6_ram_write_tb;

reg sys_clk;
initial begin
	#0;
	sys_clk <= 1'b0;

	forever #10 sys_clk <= ~sys_clk;
end

wire [2:0] state;
wire ram_write_en, iter_update, c6ib_rom_rst;
reg rstn, iter_rqst, iter_termination;
 cnu6ib_control_unit u0 (
    .ram_write_en (ram_write_en),
    .iter_update  (iter_update),
    .c6ib_rom_rst (c6ib_rom_rst),
    .state (state[2:0]),
    
    .sys_clk (sys_clk),
    .rstn (rstn),
    .iter_rqst (iter_rqst),
    .iter_termination (iter_termination)
);

initial begin
	#0;
	{rstn, iter_rqst, iter_termination} <= 3'b000;

	#100;
	{rstn, iter_rqst, iter_termination} <= 3'b111;

	// State 1: PRELOAD_ADDR
	#20 {rstn, iter_rqst, iter_termination} <= 3'b111; // others	
	#20 {rstn, iter_rqst, iter_termination} <= 3'b110; // next state
	#20;
	
	// State 2: PRELOAD_DATA
	#20 {rstn, iter_rqst, iter_termination} <= 3'b111; // others	
	#20 {rstn, iter_rqst, iter_termination} <= 3'b110; // next state
	#20;
	
	// State 3: RAM_LOAD
	#20 {rstn, iter_rqst, iter_termination} <= 3'b111; // others	
	#20 {rstn, iter_rqst, iter_termination} <= 3'b110; // next state
	#20;
	
	// State 4: BATCH_WRITE
	#20 {rstn, iter_rqst, iter_termination} <= 3'b110; // itself	
	#20 {rstn, iter_rqst, iter_termination} <= 3'b100; // next step
	#20;
	//#20 {rstn, iter_rqst, iter_termination} <= 3'b101; // next step
	//#20 {rstn, iter_rqst, iter_termination} <= 3'b111; // next step
	
	// State 5: FINISH
	#20;	
end

initial #400 $finish;
endmodule
