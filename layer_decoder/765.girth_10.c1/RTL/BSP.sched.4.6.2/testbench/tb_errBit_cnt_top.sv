
`timescale 1ns/1ps

module tb_errBit_cnt_top (); /* this is automatically generated */

	// clock
	logic clk;
	initial begin
		clk = 0;
		forever #(5) clk = ~clk;
	end

	// asynchronous reset
	logic rstn;
	initial begin
		rstn <= 0;
		repeat (10) @(posedge clk);
		rstn <= 1;
	end

	// (*NOTE*) replace reset, clock, others
    parameter VN_NUM = 7650;
    parameter N = 850;
    parameter ROW_CHUNK_NUM = 9; // VN_NUM / N
    parameter ERR_BIT_BITWIDTH_Z = $clog2(N);
    parameter ERR_BIT_BITWIDTH = $clog2(VN_NUM);
	parameter PIPELINE_DEPTH = 5;
	parameter SYN_LATENCY = 2; // to prolong the assertion of "count_done" singal for two clock cycles, in order to make top module of decoder can catch the assertion state
							  // Because the clock rate of errBit_cnt_top is double of the decoder top module's clcok rate
	localparam [9:0] block_length = N;

	logic [ERR_BIT_BITWIDTH-1:0] err_count;
	logic                        count_done;
	logic                        busy;
	logic                [N-1:0] hard_frame;
	logic                        en;

	errBit_cnt_top #(
			.VN_NUM(VN_NUM),
			.N(N),
			.ERR_BIT_BITWIDTH_Z(ERR_BIT_BITWIDTH_Z),
			.ERR_BIT_BITWIDTH(ERR_BIT_BITWIDTH),
			.PIPELINE_DEPTH(PIPELINE_DEPTH),
			.SYN_LATENCY(SYN_LATENCY)
		) inst_errBit_cnt_top (
			.err_count  (err_count),
			.count_done (count_done),
			.busy       (busy),
			.hard_frame (hard_frame),
			.eval_clk   (clk),
			.en         (en),
			.rstn       (rstn)
		);

	task init();
		hard_frame <= 0;
		en         <= 0;
	endtask

	always @(posedge clk) begin
		if(rstn == 1'b0) en <= 0;
		else if(count_done == 1'b1) en <= 0;
	end

	task drive(int iter);
		for(int it = 0; it < iter; it++) begin
			hard_frame <= hard_frame + 10;
			@(posedge clk);
		end
	endtask

	initial begin
		// do something

		init();
		repeat(10)@(posedge clk);
		en <= 1;
		drive(13);

		repeat(10)@(posedge clk);
		$finish;
	end
endmodule
