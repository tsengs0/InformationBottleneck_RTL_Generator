module qsn_merge_85b (
	output wire [84:0] sw_out,

	input wire [83:0] left_in,
	input wire [84:0] right_in,
	input wire [83:0] sel
);

	assign sw_out[0] = (sel[0] == 1'b0) ? right_in[84] : left_in[0];
	assign sw_out[1] = (sel[1] == 1'b0) ? right_in[83] : left_in[1];
	assign sw_out[2] = (sel[2] == 1'b0) ? right_in[82] : left_in[2];
	assign sw_out[3] = (sel[3] == 1'b0) ? right_in[81] : left_in[3];
	assign sw_out[4] = (sel[4] == 1'b0) ? right_in[80] : left_in[4];
	assign sw_out[5] = (sel[5] == 1'b0) ? right_in[79] : left_in[5];
	assign sw_out[6] = (sel[6] == 1'b0) ? right_in[78] : left_in[6];
	assign sw_out[7] = (sel[7] == 1'b0) ? right_in[77] : left_in[7];
	assign sw_out[8] = (sel[8] == 1'b0) ? right_in[76] : left_in[8];
	assign sw_out[9] = (sel[9] == 1'b0) ? right_in[75] : left_in[9];
	assign sw_out[10] = (sel[10] == 1'b0) ? right_in[74] : left_in[10];
	assign sw_out[11] = (sel[11] == 1'b0) ? right_in[73] : left_in[11];
	assign sw_out[12] = (sel[12] == 1'b0) ? right_in[72] : left_in[12];
	assign sw_out[13] = (sel[13] == 1'b0) ? right_in[71] : left_in[13];
	assign sw_out[14] = (sel[14] == 1'b0) ? right_in[70] : left_in[14];
	assign sw_out[15] = (sel[15] == 1'b0) ? right_in[69] : left_in[15];
	assign sw_out[16] = (sel[16] == 1'b0) ? right_in[68] : left_in[16];
	assign sw_out[17] = (sel[17] == 1'b0) ? right_in[67] : left_in[17];
	assign sw_out[18] = (sel[18] == 1'b0) ? right_in[66] : left_in[18];
	assign sw_out[19] = (sel[19] == 1'b0) ? right_in[65] : left_in[19];
	assign sw_out[20] = (sel[20] == 1'b0) ? right_in[64] : left_in[20];
	assign sw_out[21] = (sel[21] == 1'b0) ? right_in[63] : left_in[21];
	assign sw_out[22] = (sel[22] == 1'b0) ? right_in[62] : left_in[22];
	assign sw_out[23] = (sel[23] == 1'b0) ? right_in[61] : left_in[23];
	assign sw_out[24] = (sel[24] == 1'b0) ? right_in[60] : left_in[24];
	assign sw_out[25] = (sel[25] == 1'b0) ? right_in[59] : left_in[25];
	assign sw_out[26] = (sel[26] == 1'b0) ? right_in[58] : left_in[26];
	assign sw_out[27] = (sel[27] == 1'b0) ? right_in[57] : left_in[27];
	assign sw_out[28] = (sel[28] == 1'b0) ? right_in[56] : left_in[28];
	assign sw_out[29] = (sel[29] == 1'b0) ? right_in[55] : left_in[29];
	assign sw_out[30] = (sel[30] == 1'b0) ? right_in[54] : left_in[30];
	assign sw_out[31] = (sel[31] == 1'b0) ? right_in[53] : left_in[31];
	assign sw_out[32] = (sel[32] == 1'b0) ? right_in[52] : left_in[32];
	assign sw_out[33] = (sel[33] == 1'b0) ? right_in[51] : left_in[33];
	assign sw_out[34] = (sel[34] == 1'b0) ? right_in[50] : left_in[34];
	assign sw_out[35] = (sel[35] == 1'b0) ? right_in[49] : left_in[35];
	assign sw_out[36] = (sel[36] == 1'b0) ? right_in[48] : left_in[36];
	assign sw_out[37] = (sel[37] == 1'b0) ? right_in[47] : left_in[37];
	assign sw_out[38] = (sel[38] == 1'b0) ? right_in[46] : left_in[38];
	assign sw_out[39] = (sel[39] == 1'b0) ? right_in[45] : left_in[39];
	assign sw_out[40] = (sel[40] == 1'b0) ? right_in[44] : left_in[40];
	assign sw_out[41] = (sel[41] == 1'b0) ? right_in[43] : left_in[41];
	assign sw_out[42] = (sel[42] == 1'b0) ? right_in[42] : left_in[42];
	assign sw_out[43] = (sel[43] == 1'b0) ? right_in[41] : left_in[43];
	assign sw_out[44] = (sel[44] == 1'b0) ? right_in[40] : left_in[44];
	assign sw_out[45] = (sel[45] == 1'b0) ? right_in[39] : left_in[45];
	assign sw_out[46] = (sel[46] == 1'b0) ? right_in[38] : left_in[46];
	assign sw_out[47] = (sel[47] == 1'b0) ? right_in[37] : left_in[47];
	assign sw_out[48] = (sel[48] == 1'b0) ? right_in[36] : left_in[48];
	assign sw_out[49] = (sel[49] == 1'b0) ? right_in[35] : left_in[49];
	assign sw_out[50] = (sel[50] == 1'b0) ? right_in[34] : left_in[50];
	assign sw_out[51] = (sel[51] == 1'b0) ? right_in[33] : left_in[51];
	assign sw_out[52] = (sel[52] == 1'b0) ? right_in[32] : left_in[52];
	assign sw_out[53] = (sel[53] == 1'b0) ? right_in[31] : left_in[53];
	assign sw_out[54] = (sel[54] == 1'b0) ? right_in[30] : left_in[54];
	assign sw_out[55] = (sel[55] == 1'b0) ? right_in[29] : left_in[55];
	assign sw_out[56] = (sel[56] == 1'b0) ? right_in[28] : left_in[56];
	assign sw_out[57] = (sel[57] == 1'b0) ? right_in[27] : left_in[57];
	assign sw_out[58] = (sel[58] == 1'b0) ? right_in[26] : left_in[58];
	assign sw_out[59] = (sel[59] == 1'b0) ? right_in[25] : left_in[59];
	assign sw_out[60] = (sel[60] == 1'b0) ? right_in[24] : left_in[60];
	assign sw_out[61] = (sel[61] == 1'b0) ? right_in[23] : left_in[61];
	assign sw_out[62] = (sel[62] == 1'b0) ? right_in[22] : left_in[62];
	assign sw_out[63] = (sel[63] == 1'b0) ? right_in[21] : left_in[63];
	assign sw_out[64] = (sel[64] == 1'b0) ? right_in[20] : left_in[64];
	assign sw_out[65] = (sel[65] == 1'b0) ? right_in[19] : left_in[65];
	assign sw_out[66] = (sel[66] == 1'b0) ? right_in[18] : left_in[66];
	assign sw_out[67] = (sel[67] == 1'b0) ? right_in[17] : left_in[67];
	assign sw_out[68] = (sel[68] == 1'b0) ? right_in[16] : left_in[68];
	assign sw_out[69] = (sel[69] == 1'b0) ? right_in[15] : left_in[69];
	assign sw_out[70] = (sel[70] == 1'b0) ? right_in[14] : left_in[70];
	assign sw_out[71] = (sel[71] == 1'b0) ? right_in[13] : left_in[71];
	assign sw_out[72] = (sel[72] == 1'b0) ? right_in[12] : left_in[72];
	assign sw_out[73] = (sel[73] == 1'b0) ? right_in[11] : left_in[73];
	assign sw_out[74] = (sel[74] == 1'b0) ? right_in[10] : left_in[74];
	assign sw_out[75] = (sel[75] == 1'b0) ? right_in[9] : left_in[75];
	assign sw_out[76] = (sel[76] == 1'b0) ? right_in[8] : left_in[76];
	assign sw_out[77] = (sel[77] == 1'b0) ? right_in[7] : left_in[77];
	assign sw_out[78] = (sel[78] == 1'b0) ? right_in[6] : left_in[78];
	assign sw_out[79] = (sel[79] == 1'b0) ? right_in[5] : left_in[79];
	assign sw_out[80] = (sel[80] == 1'b0) ? right_in[4] : left_in[80];
	assign sw_out[81] = (sel[81] == 1'b0) ? right_in[3] : left_in[81];
	assign sw_out[82] = (sel[82] == 1'b0) ? right_in[2] : left_in[82];
	assign sw_out[83] = (sel[83] == 1'b0) ? right_in[1] : left_in[83];
	assign sw_out[84] = right_in[0];
endmodule