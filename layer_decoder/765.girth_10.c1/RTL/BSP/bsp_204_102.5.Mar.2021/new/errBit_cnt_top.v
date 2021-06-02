`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2020 12:40:51 PM
// Design Name: 
// Module Name: errBit_cnt_top
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


module errBit_cnt_top #(
    parameter N = 204,
	parameter PIPELINE_DEPTH = 3,
	parameter SYN_LATENCY = 2 // to prolong the assertion of "count_done" singal for two clock cycles, in order to make top module of decoder can catch the assertion state
							  // Because the clock rate of errBit_cnt_top is double of the decoder top module's clcok rate
)(
    output reg [7:0] err_count,
	output wire count_done,
	output reg busy,
	
    input wire [203:0] hard_frame,
    input wire eval_clk,
    input wire en,
    input wire rstn
    );

localparam [7:0] block_length = N; 

// Pipeline Stage 0: to latch the input of hard decision
    reg [31:0] hard_subFrame0_pipe0;
    reg [31:0] hard_subFrame1_pipe0;
    reg [31:0] hard_subFrame2_pipe0;
    reg [31:0] hard_subFrame3_pipe0;
    reg [31:0] hard_subFrame4_pipe0;
    reg [31:0] hard_subFrame5_pipe0;
    reg [11:0] hard_subFrame6_pipe0;

    initial begin
        hard_subFrame0_pipe0[31:0] <= 0;
        hard_subFrame1_pipe0[31:0] <= 0;
        hard_subFrame2_pipe0[31:0] <= 0;
        hard_subFrame3_pipe0[31:0] <= 0;
        hard_subFrame4_pipe0[31:0] <= 0;
        hard_subFrame5_pipe0[31:0] <= 0;
        hard_subFrame6_pipe0[11:0] <= 0;
    end
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame0_pipe0[31:0] <= 0;
	else if (en == 1'b1) hard_subFrame0_pipe0[31:0] <= hard_frame[203:172];
    end
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame1_pipe0[31:0] <= 0;
	else if (en == 1'b1) hard_subFrame1_pipe0[31:0] <= hard_frame[171:140];
    end
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame2_pipe0[31:0] <= 0;
	else if (en == 1'b1) hard_subFrame2_pipe0[31:0] <= hard_frame[139:108];
    end
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame3_pipe0[31:0] <= 0;
	else if (en == 1'b1) hard_subFrame3_pipe0[31:0] <= hard_frame[107:76];
    end
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame4_pipe0[31:0] <= 0;
	else if (en == 1'b1) hard_subFrame4_pipe0[31:0] <= hard_frame[75:44];
    end
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame5_pipe0[31:0] <= 0;
	else if (en == 1'b1) hard_subFrame5_pipe0[31:0] <= hard_frame[43:12];
    end
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame6_pipe0[11:0] <= 0;
	else if (en == 1'b1) hard_subFrame6_pipe0[11:0] <= hard_frame[11:0];
    end            
// Pipeline Stage 1: to count the number of error bits
    wire [5:0] bit_cnt0;
    wire [5:0] bit_cnt1;
    wire [5:0] bit_cnt2;
    wire [5:0] bit_cnt3;
    wire [5:0] bit_cnt4;
    wire [5:0] bit_cnt5;
    wire [3:0] bit_cnt6;
    errBit_cnt_32b #(.ERR_WIDTH(32), .COUNT_WIDTH(6), .ERR_SIGN(1)) bit_cnt_u0 (.A(hard_subFrame0_pipe0[31:0]), .err_count(bit_cnt0[5:0]));
    errBit_cnt_32b #(.ERR_WIDTH(32), .COUNT_WIDTH(6), .ERR_SIGN(1)) bit_cnt_u1 (.A(hard_subFrame1_pipe0[31:0]), .err_count(bit_cnt1[5:0]));
    errBit_cnt_32b #(.ERR_WIDTH(32), .COUNT_WIDTH(6), .ERR_SIGN(1)) bit_cnt_u2 (.A(hard_subFrame2_pipe0[31:0]), .err_count(bit_cnt2[5:0]));
    errBit_cnt_32b #(.ERR_WIDTH(32), .COUNT_WIDTH(6), .ERR_SIGN(1)) bit_cnt_u3 (.A(hard_subFrame3_pipe0[31:0]), .err_count(bit_cnt3[5:0]));
    errBit_cnt_32b #(.ERR_WIDTH(32), .COUNT_WIDTH(6), .ERR_SIGN(1)) bit_cnt_u4 (.A(hard_subFrame4_pipe0[31:0]), .err_count(bit_cnt4[5:0]));
    errBit_cnt_32b #(.ERR_WIDTH(32), .COUNT_WIDTH(6), .ERR_SIGN(1)) bit_cnt_u5 (.A(hard_subFrame5_pipe0[31:0]), .err_count(bit_cnt5[5:0]));
    errBit_cnt_12b #(.ERR_WIDTH(12), .COUNT_WIDTH(4), .ERR_SIGN(1)) bit_cnt_u6 (.A(hard_subFrame6_pipe0[11:0]), .err_count(bit_cnt6[3:0]));

    reg [5:0] bit_cnt0_pipe1;
    reg [5:0] bit_cnt1_pipe1;
    reg [5:0] bit_cnt2_pipe1;
    reg [5:0] bit_cnt3_pipe1;
    reg [5:0] bit_cnt4_pipe1;
    reg [5:0] bit_cnt5_pipe1;
    reg [3:0] bit_cnt6_pipe1;
    initial begin
        bit_cnt0_pipe1[5:0] <= 0;
        bit_cnt1_pipe1[5:0] <= 0;
        bit_cnt2_pipe1[5:0] <= 0;
        bit_cnt3_pipe1[5:0] <= 0;
        bit_cnt4_pipe1[5:0] <= 0;
        bit_cnt5_pipe1[5:0] <= 0;
        bit_cnt6_pipe1[3:0] <= 0; 
    end
    
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt0_pipe1[5:0] <= 0;
	   else if (en == 1'b1) bit_cnt0_pipe1[5:0] <= bit_cnt0[5:0];
    end
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt1_pipe1[5:0] <= 0;
	   else if (en == 1'b1) bit_cnt1_pipe1[5:0] <= bit_cnt1[5:0];
    end
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt2_pipe1[5:0] <= 0;
	   else if (en == 1'b1) bit_cnt2_pipe1[5:0] <= bit_cnt2[5:0];
    end
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt3_pipe1[5:0] <= 0;
	   else if (en == 1'b1) bit_cnt3_pipe1[5:0] <= bit_cnt3[5:0];
    end
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt4_pipe1[5:0] <= 0;
	   else if (en == 1'b1) bit_cnt4_pipe1[5:0] <= bit_cnt4[5:0];
    end    
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt5_pipe1[5:0] <= 0;
	   else if (en == 1'b1) bit_cnt5_pipe1[5:0] <= bit_cnt5[5:0];
    end        
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt6_pipe1[3:0] <= 0;
	   else if (en == 1'b1) bit_cnt6_pipe1[3:0] <= bit_cnt6[3:0];
    end                 

// Pipeline Stage 2: to summate all error bit counts
	reg [1:0] busy_cnt;
	reg en_latch;
	wire [7:0] sum_out;
	sum204_tree sum_tree_u0 (
		.sum_out (sum_out),

		.err_count0 (bit_cnt0_pipe1[5:0]),
		.err_count1 (bit_cnt1_pipe1[5:0]),
		.err_count2 (bit_cnt2_pipe1[5:0]),
		.err_count3 (bit_cnt3_pipe1[5:0]),
		.err_count4 (bit_cnt4_pipe1[5:0]),
		.err_count5 (bit_cnt5_pipe1[5:0]),
		.err_count6 (bit_cnt6_pipe1[3:0])
	);
 
	initial err_count[7:0] <= 0;
    always @(posedge eval_clk, negedge rstn) begin
		if(rstn == 1'b0) err_count[7:0] <= 0;
		else if (en_latch == 1'b1 || busy_cnt[1:0] == 2'b10) err_count[7:0] <= block_length[7:0] - sum_out[7:0];
	end
	

	initial busy_cnt[1:0] <= 2'b00;
	always @(posedge eval_clk, negedge rstn) begin
		if(rstn == 1'b0) en_latch <= 1'b0;
		else if(busy_cnt[1:0] == 2'b10) en_latch <= 1'b0;
		else if(en == 1'b1) en_latch <= 1'b1; 
	end
	
	always @(posedge eval_clk, negedge rstn) begin
		if(rstn == 1'b0) busy_cnt[1:0] <= 2'b00;
		else if(en_latch == 1'b1) begin
			if(busy_cnt[1:0] == 2'b10) 
				busy_cnt[1:0] <= 2'b00;
			else
				busy_cnt[1:0] <= busy_cnt[1:0] + 1'b1;
		end
	end
	
	always @(posedge eval_clk, negedge rstn) begin
		if(rstn == 1'b0) busy <= 1'b0;
		else if(en_latch) begin
			if(busy_cnt[1:0] == 2'b10) busy <= 1'b0;
			else busy <= 1'b1;
		end
		else busy <= 1'b0;
	end
	
	reg count_done_reg; initial count_done_reg <= 0;
	always @(posedge eval_clk, negedge rstn) begin
		if(rstn == 1'b0) count_done_reg <= 1'b0;
		else if(en_latch && busy_cnt[1:0] == 2'b10) count_done_reg <= 1'b1;
		else count_done_reg <= 1'b0;
	end
	reg [SYN_LATENCY-1:0] count_done_sync; initial count_done_sync <= 0;
	always @(posedge eval_clk, negedge rstn) begin
		if(rstn == 1'b0) count_done_sync <= 0;
		else count_done_sync[SYN_LATENCY-1:0] <= {count_done_sync[0], count_done_reg};
	end
	assign count_done = |count_done_sync[SYN_LATENCY-1:0];
endmodule

module errBit_cnt_16b(
    output reg [4:0] err_count,
    input wire [15:0] hard_frame,
    input wire eval_clk,
    input wire en,
    input wire rstn
    );

// Pipeline Stage 0: to latch the input of hard decision
    reg [7:0] hard_subFrame0_pipe0;
    reg [7:0] hard_subFrame1_pipe0;
 
    initial hard_subFrame0_pipe0[7:0] <= 0;
    initial hard_subFrame1_pipe0[7:0] <= 0;

    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame0_pipe0[7:0] <= 0;
	else if (en == 1'b1) hard_subFrame0_pipe0[7:0] <= hard_frame[7:0];
    end
    
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame1_pipe0[7:0] <= 0;
	else if (en == 1'b1) hard_subFrame1_pipe0[7:0] <= hard_frame[15:8];
    end 
// Pipeline Stage 1: to count the number of error bits
    wire [3:0] bit_cnt0;
    wire [3:0] bit_cnt1;

    errBit_cnt_8b #(.ERR_WIDTH(8), .COUNT_WIDTH(4), .ERR_SIGN(1)) bit_cnt_u0 (.A(hard_subFrame0_pipe0[7:0]), .err_count(bit_cnt0[3:0]));
    errBit_cnt_8b #(.ERR_WIDTH(8), .COUNT_WIDTH(4), .ERR_SIGN(1)) bit_cnt_u1 (.A(hard_subFrame1_pipe0[7:0]), .err_count(bit_cnt1[3:0]));

    reg [3:0] bit_cnt0_pipe1;
    reg [3:0] bit_cnt1_pipe1;
    initial begin
        bit_cnt0_pipe1[3:0] <= 0;
        bit_cnt1_pipe1[3:0] <= 0;
    end
    
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt0_pipe1[3:0] <= 0;
	   else if (en == 1'b1) bit_cnt0_pipe1[3:0] <= bit_cnt0[3:0];
    end
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt1_pipe1[3:0] <= 0;
	   else if (en == 1'b1) bit_cnt1_pipe1[3:0] <= bit_cnt1[3:0];
    end             

// Pipeline Stage 2: to summate all error bit counts
	wire [4:0] sum_out;
	sum16_tree sum_tree_u0 (
		.sum_out (sum_out),

		.err_count0 (bit_cnt0_pipe1[3:0]),
		.err_count1 (bit_cnt1_pipe1[3:0])
	);
   	
	initial err_count[4:0] <= 0;
    	always @(posedge eval_clk, negedge rstn) begin
		if(rstn == 1'b0) err_count[4:0] <= 0;
		else if (en == 1'b1) err_count[4:0] <= sum_out[4:0];
	end
endmodule

