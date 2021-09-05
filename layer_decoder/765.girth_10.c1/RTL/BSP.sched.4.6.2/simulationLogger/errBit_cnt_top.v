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
// Latency: 5 clock cycles
//////////////////////////////////////////////////////////////////////////////////

module errBit_cnt_top #(
    parameter VN_NUM = 7650,
    parameter N = 850,
    parameter ROW_CHUNK_NUM = 9, // VN_NUM / N
    parameter ERR_BIT_BITWIDTH_Z = $clog2(N),
    parameter ERR_BIT_BITWIDTH = $clog2(VN_NUM),
	parameter PIPELINE_DEPTH = 5,
	parameter SYN_LATENCY = 2 // to prolong the assertion of "count_done" singal for two clock cycles, in order to make top module of decoder can catch the assertion state
							  // Because the clock rate of errBit_cnt_top is double of the decoder top module's clcok rate
)(
    output reg [ERR_BIT_BITWIDTH-1:0] err_count,
    output reg isErrFrame,
	output wire count_done,
	output reg busy,
	
    input wire [N-1:0] hard_frame,
    input wire eval_clk,
    input wire en,
    input wire rstn
    );

localparam [9:0] block_length = N; 
/*-------------------------------------------------------*/
// Pipeline Stage 0: to latch the input of hard decision
    reg [127:0] hard_subFrame0_pipe0;
    reg [127:0] hard_subFrame1_pipe0;
    reg [127:0] hard_subFrame2_pipe0;
    reg [127:0] hard_subFrame3_pipe0;
    reg [127:0] hard_subFrame4_pipe0;
    reg [127:0] hard_subFrame5_pipe0;
    reg [81:0 ] hard_subFrame6_pipe0;

    initial begin
        hard_subFrame0_pipe0[127:0] <= 0;
        hard_subFrame1_pipe0[127:0] <= 0;
        hard_subFrame2_pipe0[127:0] <= 0;
        hard_subFrame3_pipe0[127:0] <= 0;
        hard_subFrame4_pipe0[127:0] <= 0;
        hard_subFrame5_pipe0[127:0] <= 0;
        hard_subFrame6_pipe0[ 81:0] <= 0;
    end
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame0_pipe0[127:0] <= 0;
	else if (en == 1'b1) hard_subFrame0_pipe0[127:0] <= hard_frame[767:640];
    end
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame1_pipe0[127:0] <= 0;
	else if (en == 1'b1) hard_subFrame1_pipe0[127:0] <= hard_frame[639:512];
    end
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame2_pipe0[127:0] <= 0;
	else if (en == 1'b1) hard_subFrame2_pipe0[127:0] <= hard_frame[511:384];
    end
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame3_pipe0[127:0] <= 0;
	else if (en == 1'b1) hard_subFrame3_pipe0[127:0] <= hard_frame[383:256];
    end
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame4_pipe0[127:0] <= 0;
	else if (en == 1'b1) hard_subFrame4_pipe0[127:0] <= hard_frame[255:128];
    end
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame5_pipe0[127:0] <= 0;
	else if (en == 1'b1) hard_subFrame5_pipe0[127:0] <= hard_frame[127:0];
    end
    always @(posedge eval_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_subFrame6_pipe0[81:0] <= 0;
	else if (en == 1'b1) hard_subFrame6_pipe0[81:0] <= hard_frame[849:768];
    end 
/*-------------------------------------------------------*/           
// Pipeline Stage 1: to count the number of error bits
    wire [7:0] bit_cnt0;
    wire [7:0] bit_cnt1;
    wire [7:0] bit_cnt2;
    wire [7:0] bit_cnt3;
    wire [7:0] bit_cnt4;
    wire [7:0] bit_cnt5;
    wire [6:0] bit_cnt6;
    errBit_cnt_128b #(.ERR_WIDTH(128), .COUNT_WIDTH(8)) bit_cnt_u0 (.A(hard_subFrame0_pipe0[127:0]), .err_count(bit_cnt0[7:0]));
    errBit_cnt_128b #(.ERR_WIDTH(128), .COUNT_WIDTH(8)) bit_cnt_u1 (.A(hard_subFrame1_pipe0[127:0]), .err_count(bit_cnt1[7:0]));
    errBit_cnt_128b #(.ERR_WIDTH(128), .COUNT_WIDTH(8)) bit_cnt_u2 (.A(hard_subFrame2_pipe0[127:0]), .err_count(bit_cnt2[7:0]));
    errBit_cnt_128b #(.ERR_WIDTH(128), .COUNT_WIDTH(8)) bit_cnt_u3 (.A(hard_subFrame3_pipe0[127:0]), .err_count(bit_cnt3[7:0]));
    errBit_cnt_128b #(.ERR_WIDTH(128), .COUNT_WIDTH(8)) bit_cnt_u4 (.A(hard_subFrame4_pipe0[127:0]), .err_count(bit_cnt4[7:0]));
    errBit_cnt_128b #(.ERR_WIDTH(128), .COUNT_WIDTH(8)) bit_cnt_u5 (.A(hard_subFrame5_pipe0[127:0]), .err_count(bit_cnt5[7:0]));
    errBit_cnt_96b  #(.ERR_WIDTH( 96), .COUNT_WIDTH(7)) bit_cnt_u6 (.A({{14{1'b0}}, hard_subFrame6_pipe0[ 81:0]}), .err_count(bit_cnt6[6:0]));

    reg [7:0] bit_cnt0_pipe1;
    reg [7:0] bit_cnt1_pipe1;
    reg [7:0] bit_cnt2_pipe1;
    reg [7:0] bit_cnt3_pipe1;
    reg [7:0] bit_cnt4_pipe1;
    reg [7:0] bit_cnt5_pipe1;
    reg [6:0] bit_cnt6_pipe1;
    initial begin
        bit_cnt0_pipe1[7:0] <= 0;
        bit_cnt1_pipe1[7:0] <= 0;
        bit_cnt2_pipe1[7:0] <= 0;
        bit_cnt3_pipe1[7:0] <= 0;
        bit_cnt4_pipe1[7:0] <= 0;
        bit_cnt5_pipe1[7:0] <= 0;
        bit_cnt6_pipe1[6:0] <= 0; 
    end
    
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt0_pipe1[7:0] <= 0;
	   else if (en == 1'b1) bit_cnt0_pipe1[7:0] <= bit_cnt0[7:0];
    end
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt1_pipe1[7:0] <= 0;
	   else if (en == 1'b1) bit_cnt1_pipe1[7:0] <= bit_cnt1[7:0];
    end
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt2_pipe1[7:0] <= 0;
	   else if (en == 1'b1) bit_cnt2_pipe1[7:0] <= bit_cnt2[7:0];
    end
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt3_pipe1[7:0] <= 0;
	   else if (en == 1'b1) bit_cnt3_pipe1[7:0] <= bit_cnt3[7:0];
    end
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt4_pipe1[7:0] <= 0;
	   else if (en == 1'b1) bit_cnt4_pipe1[7:0] <= bit_cnt4[7:0];
    end    
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt5_pipe1[7:0] <= 0;
	   else if (en == 1'b1) bit_cnt5_pipe1[7:0] <= bit_cnt5[7:0];
    end        
    always @(posedge eval_clk, negedge rstn) begin
	   if(rstn == 1'b0) bit_cnt6_pipe1[6:0] <= 0;
	   else if (en == 1'b1) bit_cnt6_pipe1[6:0] <= bit_cnt6[6:0];
    end                 
/*-------------------------------------------------------*/
// Pipeline Stage 2: to summate all error bit counts
    localparam ENTIRE_LATENCY = PIPELINE_DEPTH+(ROW_CHUNK_NUM-1);
    localparam ENTIRE_BITWIDTH = $clog2(ENTIRE_LATENCY);
    localparam SUM_TREE_LATENCY = 3; // 3 clock cycles delay to get responded by sum tree
	reg [ENTIRE_BITWIDTH-1:0] busy_cnt;
	reg en_latch;
	wire [9:0] sum_out;
    reg [9:0] sum_out_reg2;
	sum850_tree sum_tree_u0 (
		.sum_out (sum_out),

		.err_count0 (bit_cnt0_pipe1[7:0]),
		.err_count1 (bit_cnt1_pipe1[7:0]),
		.err_count2 (bit_cnt2_pipe1[7:0]),
		.err_count3 (bit_cnt3_pipe1[7:0]),
		.err_count4 (bit_cnt4_pipe1[7:0]),
		.err_count5 (bit_cnt5_pipe1[7:0]),
		.err_count6 (bit_cnt6_pipe1[6:0])
	);
    initial sum_out_reg2 <= 0;
    always @(posedge eval_clk, negedge rstn) begin
        if(rstn == 1'b0) sum_out_reg2 <= 0;
        else sum_out_reg2 <= sum_out;
    end
/*-------------------------------------------------------*/
// Pipeline Stage 3: To normalise the information of error 
//                   bit counts with repsect to BPSK modulation
    localparam NORMALISE_LATENCY = 3; // 3 clock cycles to get responded by normalisation
    reg [ERR_BIT_BITWIDTH_Z-1:0] submatrix_err_count;
	initial submatrix_err_count[9:0] <= 0;
    always @(posedge eval_clk, negedge rstn) begin
		if(rstn == 1'b0) 
            submatrix_err_count[9:0] <= 0;
		else if (en_latch == 1'b1 && busy_cnt >= SUM_TREE_LATENCY-1) 
            submatrix_err_count[9:0] <= block_length[9:0] - sum_out_reg2[9:0];
	end
/*-------------------------------------------------------*/
// Pipeline Stage 4: Accumulation of all error bit counts
//                   from current submatrix and previous 
//                   submatrices 
    initial err_count[ERR_BIT_BITWIDTH-1:0] <= 0;
    always @(posedge eval_clk, negedge rstn) begin
        if(rstn == 1'b0) 
            err_count <= 0;
        else if(en_latch == 1'b1 && busy_cnt >= NORMALISE_LATENCY-1 && busy_cnt < ENTIRE_LATENCY-1)
            err_count <= err_count + submatrix_err_count;
    end

    initial isErrFrame <= 0;
    always @(posedge eval_clk, negedge rstn) begin
        if(rstn == 1'b0) 
            isErrFrame <= 0;
        else if(en_latch == 1'b1 && busy_cnt >= NORMALISE_LATENCY-1 && busy_cnt < ENTIRE_LATENCY-1)
            isErrFrame <= (|err_count) && (|submatrix_err_count);
    end

	initial busy_cnt <= 0;
	always @(posedge eval_clk, negedge rstn) begin
		if(rstn == 1'b0) en_latch <= 1'b0;
		else if(busy_cnt == ENTIRE_LATENCY-1) en_latch <= 1'b0;
		else if(en == 1'b1) en_latch <= 1'b1;
        else en_latch <= 1'b0;
	end
	
	always @(posedge eval_clk, negedge rstn) begin
		if(rstn == 1'b0) busy_cnt <= 0;
		else if(en_latch == 1'b1) begin
			if(busy_cnt == ENTIRE_LATENCY-1) 
				busy_cnt <= 0;
			else
				busy_cnt <= busy_cnt+1;
		end
        else busy_cnt <= 0;
	end
	
	always @(posedge eval_clk, negedge rstn) begin
		if(rstn == 1'b0) busy <= 1'b0;
		else if(en_latch == 1'b1) begin
			if(busy_cnt == ENTIRE_LATENCY-1) busy <= 1'b0;
			else busy <= 1'b1;
		end
		else busy <= 1'b0;
	end
	
	reg count_done_reg; initial count_done_reg <= 0;
	always @(posedge eval_clk, negedge rstn) begin
		if(rstn == 1'b0) count_done_reg <= 1'b0;
		else if(en_latch && busy_cnt == ENTIRE_LATENCY-1) count_done_reg <= 1'b1;
		else count_done_reg <= 1'b0;
	end
	reg [SYN_LATENCY-1:0] count_done_sync; initial count_done_sync <= 0;
	always @(posedge eval_clk, negedge rstn) begin
		if(rstn == 1'b0) count_done_sync <= 0;
		else count_done_sync[SYN_LATENCY-1:0] <= {count_done_sync[0], count_done_reg};
	end
	assign count_done = |count_done_sync[SYN_LATENCY-1:0];
endmodule