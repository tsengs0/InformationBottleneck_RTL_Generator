`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2020 06:51:52 PM
// Design Name: 
// Module Name: serial2parallel
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

module serial2parallel (
	output reg [`DATAPATH_WIDTH-1:0] parallel_data,

	input serial_clk,
	input rstn,
	input data_in
);
function integer log2;
	input integer addr;
	begin
        	addr = addr - 1;
        	for (log2=0; addr>0; log2=log2+1)
                	addr = addr >> 1;
	end
endfunction
        localparam serial_cnt_width = log2(`DATAPATH_WIDTH);
	reg [serial_cnt_width-1:0] serial_cnt;
	reg [`DATAPATH_WIDTH-1:0] shift_data;
	initial serial_cnt[serial_cnt_width-1:0] <= 'd0;
	always @(negedge serial_clk)
	begin
		if(!rstn) serial_cnt[serial_cnt_width-1:0] <= 'd0;
		else if(serial_cnt[serial_cnt_width-1:0] == (`DATAPATH_WIDTH - 1)) serial_cnt[serial_cnt_width-1:0] <= 'd0;
		else serial_cnt <= serial_cnt + 1'b1;
	end

	// D FF
	always @(posedge serial_clk) 
	begin
		if(!rstn) shift_data[`DATAPATH_WIDTH-1:0] <= {`DATAPATH_WIDTH{1'b0}};
		else shift_data[`DATAPATH_WIDTH-1:0] <= {shift_data[`DATAPATH_WIDTH-2:0], data_in};
	end

	// Memory Register connected to the pipeline register of first stage
	always @(negedge serial_clk)
	begin
		if(!rstn) parallel_data[`DATAPATH_WIDTH-1:0] <= {`DATAPATH_WIDTH{1'b0}};
		else if (serial_cnt == (`DATAPATH_WIDTH-1)) parallel_data[`DATAPATH_WIDTH-1:0] <= shift_data[`DATAPATH_WIDTH-1:0];
		else parallel_data[`DATAPATH_WIDTH-1:0] <= {`DATAPATH_WIDTH{1'bx}};
	end
endmodule