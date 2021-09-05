module sum850_tree (
	output wire [9:0] sum_out,

	input wire [7:0] err_count0,
	input wire [7:0] err_count1,
	input wire [7:0] err_count2,
	input wire [7:0] err_count3,
	input wire [7:0] err_count4,
	input wire [7:0] err_count5,
	input wire [6:0] err_count6
);

	wire [8:0] sum_depth_00;
	wire [8:0] sum_depth_01;
	wire [8:0] sum_depth_02;
	assign sum_depth_00 = err_count0 + err_count1;
	assign sum_depth_01 = err_count2 + err_count3;
	assign sum_depth_02 = err_count4 + err_count5;

	wire [9:0] sum_depth_10;
	wire [8:0] sum_depth_11;
	assign sum_depth_10 = sum_depth_00 + sum_depth_01;
	assign sum_depth_11 = sum_depth_02 + err_count6;

	assign sum_out = sum_depth_10 + sum_depth_11;
endmodule

module sum204_tree (
	output wire [7:0] sum_out,

	input wire [5:0] err_count0,
	input wire [5:0] err_count1,
	input wire [5:0] err_count2,
	input wire [5:0] err_count3,
	input wire [5:0] err_count4,
	input wire [5:0] err_count5,
	input wire [3:0] err_count6
);

	wire [7:0] sum_depth_00;
	wire [7:0] sum_depth_01;
	wire [7:0] sum_depth_02;
	assign sum_depth_00 = err_count0 + err_count1;
	assign sum_depth_01 = err_count2 + err_count3;
	assign sum_depth_02 = err_count4 + err_count5;

	wire [7:0] sum_depth_10;
	wire [7:0] sum_depth_11;
	assign sum_depth_10 = sum_depth_00 + sum_depth_01;
	assign sum_depth_11 = sum_depth_02 + err_count6;

	assign sum_out = sum_depth_10 + sum_depth_11;
endmodule

module sum16_tree (
	output wire [4:0] sum_out,

	input wire [3:0] err_count0,
	input wire [3:0] err_count1
);
	assign sum_out = err_count0 + err_count1;
endmodule