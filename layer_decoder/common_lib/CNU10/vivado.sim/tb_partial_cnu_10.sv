
`timescale 1ns/1ps

module tb_partial_cnu_10 (); /* this is automatically generated */

	// clock

	// clock
	logic read_clk;
	initial begin
		read_clk = 0;
		forever #(10) read_clk = ~read_clk;
	end

	// asynchronous reset
	reg sys_rstn;
	initial begin
		sys_rstn <= 0;
		repeat (10) @(posedge read_clk);
		sys_rstn <= 1;
	end

	logic [QUAN_SIZE-1:0] v2cIn_pattern [0:(CN_DEGREE*PATTERN_NUM)-1];
	initial begin
		$readmemh("/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/common_lib/CNU10/vivado.sim/readFiles/v2cIn_msg.mem", v2cIn_pattern);
	end

	// (*NOTE*) replace reset, clock, others
	parameter            CN_DEGREE = 10;
	parameter            QUAN_SIZE = 4;
	parameter             MAG_SIZE = 3;
	parameter     ROW_SPLIT_FACTOR = 5;
	localparam EXT_MSG_PARALLELISM = CN_DEGREE/ROW_SPLIT_FACTOR;
	localparam PATTERN_NUM = 16;

	logic [QUAN_SIZE-1:0] ch_to_var_0;
	logic [QUAN_SIZE-1:0] ch_to_var_1;
	logic [QUAN_SIZE-1:0] var_to_ch_0;
	logic [QUAN_SIZE-1:0] var_to_ch_1;
	logic                 first_comp;

	partial_cnu_10 #(
			.CN_DEGREE(CN_DEGREE),
			.QUAN_SIZE(QUAN_SIZE),
			.MAG_SIZE(MAG_SIZE),
			.ROW_SPLIT_FACTOR(ROW_SPLIT_FACTOR)
		) inst_partial_cnu_10 (
			.ch_to_var_0 (ch_to_var_0),
			.ch_to_var_1 (ch_to_var_1),
			.var_to_ch_0 (var_to_ch_0),
			.var_to_ch_1 (var_to_ch_1),
			.first_comp  (first_comp),
			.sys_clk     (read_clk),
			.rstn        (sys_rstn)
		);

	integer row_split_cnt, row_cnt;
	task init();
		var_to_ch_0 <= 0;
		var_to_ch_1 <= 0;
		row_split_cnt <= 0;
		row_cnt <= 0;
	endtask

	task drive(int iter);
		for(int it = 0; it < iter; it++) begin
			var_to_ch_0 <= v2cIn_pattern[(row_cnt*CN_DEGREE)+(row_split_cnt*EXT_MSG_PARALLELISM)+0];
			var_to_ch_1 <= v2cIn_pattern[(row_cnt*CN_DEGREE)+(row_split_cnt*EXT_MSG_PARALLELISM)+1];

			@(posedge read_clk);
		end
	endtask
	always @(posedge read_clk) begin
		if(sys_rstn == 1'b0) begin
			row_split_cnt <= 0;
			row_cnt <= 0;
		end
		else if(row_split_cnt == ROW_SPLIT_FACTOR-1) begin
			row_split_cnt <= 0;
			row_cnt <= row_cnt+1;
		end
		else begin
			row_split_cnt <= row_split_cnt+1;
		end
	end
	assign first_comp = (row_split_cnt == 0) ? (1 & sys_rstn ) : 0;


	initial begin
		// do something

		init();
		repeat(10)@(posedge read_clk);

		drive((ROW_SPLIT_FACTOR*PATTERN_NUM));

		repeat(10)@(posedge read_clk);
		$finish;
	end
endmodule



/*
	integer pageAlign_tb_fd;
	//integer pageAlignIn_tb_fd;
	initial begin
		pageAlign_tb_fd = $fopen("pageAlign_result_submatrix_1", "w");
		//pageAlignIn_tb_fd = $fopen("pageAlign_in_submatrix_1", "w");
	end
	*/