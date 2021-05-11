module qsn_top_85b (
	output wire [84:0] sw_out,

	input wire [84:0] sw_in,
	input wire [6:0] left_sel,
	input wire [6:0] right_sel,
	input wire [83:0] merge_sel
);

	// Instantiation of Left Shift Network
	wire [83:0] left_sw_out;
	qsn_left_85b qsn_left_u0 (
		.sw_out (left_sw_out[83:0]),

		.sw_in (sw_in[84:0]),
		.sel (left_sel[6:0])
	);
	// Instantiation of Right Shift Network
	wire [85:0] right_sw_out;
	qsn_right_85b qsn_right_u0 (
		.sw_out (right_sw_out[84:0]),

		.sw_in (sw_in[84:0]),
		.sel (right_sel[6:0])
	);
	// Instantiation of Merge Network
	qsn_merge_85b qsn_merge_u0 (
		.sw_out (sw_out[84:0]),

		.left_in (left_sw_out[83:0]),
		.right_in (right_sw_out[84:0]),
		.sel (merge_sel[83:0])
	);
endmodule