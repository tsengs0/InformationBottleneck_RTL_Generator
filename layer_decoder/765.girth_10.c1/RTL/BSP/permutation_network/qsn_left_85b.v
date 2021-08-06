`include "define.vh"

module qsn_left_85b (
	output wire [83:0] sw_out,

	input wire [84:0] sw_in,
	input wire [6:0] sel,
	input wire sys_clk,
	input wire rstn
);

	// Multiplexer Stage 6
	wire [20:0] mux_stage_6;
	assign mux_stage_6[0] = (sel[6] == 1'b1) ? sw_in[64] : sw_in[0];
	assign mux_stage_6[1] = (sel[6] == 1'b1) ? sw_in[65] : sw_in[1];
	assign mux_stage_6[2] = (sel[6] == 1'b1) ? sw_in[66] : sw_in[2];
	assign mux_stage_6[3] = (sel[6] == 1'b1) ? sw_in[67] : sw_in[3];
	assign mux_stage_6[4] = (sel[6] == 1'b1) ? sw_in[68] : sw_in[4];
	assign mux_stage_6[5] = (sel[6] == 1'b1) ? sw_in[69] : sw_in[5];
	assign mux_stage_6[6] = (sel[6] == 1'b1) ? sw_in[70] : sw_in[6];
	assign mux_stage_6[7] = (sel[6] == 1'b1) ? sw_in[71] : sw_in[7];
	assign mux_stage_6[8] = (sel[6] == 1'b1) ? sw_in[72] : sw_in[8];
	assign mux_stage_6[9] = (sel[6] == 1'b1) ? sw_in[73] : sw_in[9];
	assign mux_stage_6[10] = (sel[6] == 1'b1) ? sw_in[74] : sw_in[10];
	assign mux_stage_6[11] = (sel[6] == 1'b1) ? sw_in[75] : sw_in[11];
	assign mux_stage_6[12] = (sel[6] == 1'b1) ? sw_in[76] : sw_in[12];
	assign mux_stage_6[13] = (sel[6] == 1'b1) ? sw_in[77] : sw_in[13];
	assign mux_stage_6[14] = (sel[6] == 1'b1) ? sw_in[78] : sw_in[14];
	assign mux_stage_6[15] = (sel[6] == 1'b1) ? sw_in[79] : sw_in[15];
	assign mux_stage_6[16] = (sel[6] == 1'b1) ? sw_in[80] : sw_in[16];
	assign mux_stage_6[17] = (sel[6] == 1'b1) ? sw_in[81] : sw_in[17];
	assign mux_stage_6[18] = (sel[6] == 1'b1) ? sw_in[82] : sw_in[18];
	assign mux_stage_6[19] = (sel[6] == 1'b1) ? sw_in[83] : sw_in[19];
	assign mux_stage_6[20] = (sel[6] == 1'b1) ? sw_in[84] : sw_in[20];

	// Multiplexer Stage 5
	wire [52:0] mux_stage_5;
	assign mux_stage_5[0] = (sel[5] == 1'b1) ? sw_in[32] : mux_stage_6[0];
	assign mux_stage_5[1] = (sel[5] == 1'b1) ? sw_in[33] : mux_stage_6[1];
	assign mux_stage_5[2] = (sel[5] == 1'b1) ? sw_in[34] : mux_stage_6[2];
	assign mux_stage_5[3] = (sel[5] == 1'b1) ? sw_in[35] : mux_stage_6[3];
	assign mux_stage_5[4] = (sel[5] == 1'b1) ? sw_in[36] : mux_stage_6[4];
	assign mux_stage_5[5] = (sel[5] == 1'b1) ? sw_in[37] : mux_stage_6[5];
	assign mux_stage_5[6] = (sel[5] == 1'b1) ? sw_in[38] : mux_stage_6[6];
	assign mux_stage_5[7] = (sel[5] == 1'b1) ? sw_in[39] : mux_stage_6[7];
	assign mux_stage_5[8] = (sel[5] == 1'b1) ? sw_in[40] : mux_stage_6[8];
	assign mux_stage_5[9] = (sel[5] == 1'b1) ? sw_in[41] : mux_stage_6[9];
	assign mux_stage_5[10] = (sel[5] == 1'b1) ? sw_in[42] : mux_stage_6[10];
	assign mux_stage_5[11] = (sel[5] == 1'b1) ? sw_in[43] : mux_stage_6[11];
	assign mux_stage_5[12] = (sel[5] == 1'b1) ? sw_in[44] : mux_stage_6[12];
	assign mux_stage_5[13] = (sel[5] == 1'b1) ? sw_in[45] : mux_stage_6[13];
	assign mux_stage_5[14] = (sel[5] == 1'b1) ? sw_in[46] : mux_stage_6[14];
	assign mux_stage_5[15] = (sel[5] == 1'b1) ? sw_in[47] : mux_stage_6[15];
	assign mux_stage_5[16] = (sel[5] == 1'b1) ? sw_in[48] : mux_stage_6[16];
	assign mux_stage_5[17] = (sel[5] == 1'b1) ? sw_in[49] : mux_stage_6[17];
	assign mux_stage_5[18] = (sel[5] == 1'b1) ? sw_in[50] : mux_stage_6[18];
	assign mux_stage_5[19] = (sel[5] == 1'b1) ? sw_in[51] : mux_stage_6[19];
	assign mux_stage_5[20] = (sel[5] == 1'b1) ? sw_in[52] : mux_stage_6[20];
	assign mux_stage_5[21] = (sel[5] == 1'b1) ? sw_in[53] : sw_in[21];
	assign mux_stage_5[22] = (sel[5] == 1'b1) ? sw_in[54] : sw_in[22];
	assign mux_stage_5[23] = (sel[5] == 1'b1) ? sw_in[55] : sw_in[23];
	assign mux_stage_5[24] = (sel[5] == 1'b1) ? sw_in[56] : sw_in[24];
	assign mux_stage_5[25] = (sel[5] == 1'b1) ? sw_in[57] : sw_in[25];
	assign mux_stage_5[26] = (sel[5] == 1'b1) ? sw_in[58] : sw_in[26];
	assign mux_stage_5[27] = (sel[5] == 1'b1) ? sw_in[59] : sw_in[27];
	assign mux_stage_5[28] = (sel[5] == 1'b1) ? sw_in[60] : sw_in[28];
	assign mux_stage_5[29] = (sel[5] == 1'b1) ? sw_in[61] : sw_in[29];
	assign mux_stage_5[30] = (sel[5] == 1'b1) ? sw_in[62] : sw_in[30];
	assign mux_stage_5[31] = (sel[5] == 1'b1) ? sw_in[63] : sw_in[31];
	assign mux_stage_5[32] = (sel[5] == 1'b1) ? sw_in[64] : sw_in[32];
	assign mux_stage_5[33] = (sel[5] == 1'b1) ? sw_in[65] : sw_in[33];
	assign mux_stage_5[34] = (sel[5] == 1'b1) ? sw_in[66] : sw_in[34];
	assign mux_stage_5[35] = (sel[5] == 1'b1) ? sw_in[67] : sw_in[35];
	assign mux_stage_5[36] = (sel[5] == 1'b1) ? sw_in[68] : sw_in[36];
	assign mux_stage_5[37] = (sel[5] == 1'b1) ? sw_in[69] : sw_in[37];
	assign mux_stage_5[38] = (sel[5] == 1'b1) ? sw_in[70] : sw_in[38];
	assign mux_stage_5[39] = (sel[5] == 1'b1) ? sw_in[71] : sw_in[39];
	assign mux_stage_5[40] = (sel[5] == 1'b1) ? sw_in[72] : sw_in[40];
	assign mux_stage_5[41] = (sel[5] == 1'b1) ? sw_in[73] : sw_in[41];
	assign mux_stage_5[42] = (sel[5] == 1'b1) ? sw_in[74] : sw_in[42];
	assign mux_stage_5[43] = (sel[5] == 1'b1) ? sw_in[75] : sw_in[43];
	assign mux_stage_5[44] = (sel[5] == 1'b1) ? sw_in[76] : sw_in[44];
	assign mux_stage_5[45] = (sel[5] == 1'b1) ? sw_in[77] : sw_in[45];
	assign mux_stage_5[46] = (sel[5] == 1'b1) ? sw_in[78] : sw_in[46];
	assign mux_stage_5[47] = (sel[5] == 1'b1) ? sw_in[79] : sw_in[47];
	assign mux_stage_5[48] = (sel[5] == 1'b1) ? sw_in[80] : sw_in[48];
	assign mux_stage_5[49] = (sel[5] == 1'b1) ? sw_in[81] : sw_in[49];
	assign mux_stage_5[50] = (sel[5] == 1'b1) ? sw_in[82] : sw_in[50];
	assign mux_stage_5[51] = (sel[5] == 1'b1) ? sw_in[83] : sw_in[51];
	assign mux_stage_5[52] = (sel[5] == 1'b1) ? sw_in[84] : sw_in[52];

`ifdef SCHED_4_6
	// Multiplexer Stage 4
	reg [68:0] mux_stage_4;
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[0 ] <= 0; else if(sel[4] == 1'b1) mux_stage_4[0 ] <= mux_stage_5[16]; else mux_stage_4[0 ] <= mux_stage_5[0 ]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[1 ] <= 0; else if(sel[4] == 1'b1) mux_stage_4[1 ] <= mux_stage_5[17]; else mux_stage_4[1 ] <= mux_stage_5[1 ]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[2 ] <= 0; else if(sel[4] == 1'b1) mux_stage_4[2 ] <= mux_stage_5[18]; else mux_stage_4[2 ] <= mux_stage_5[2 ]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[3 ] <= 0; else if(sel[4] == 1'b1) mux_stage_4[3 ] <= mux_stage_5[19]; else mux_stage_4[3 ] <= mux_stage_5[3 ]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[4 ] <= 0; else if(sel[4] == 1'b1) mux_stage_4[4 ] <= mux_stage_5[20]; else mux_stage_4[4 ] <= mux_stage_5[4 ]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[5 ] <= 0; else if(sel[4] == 1'b1) mux_stage_4[5 ] <= mux_stage_5[21]; else mux_stage_4[5 ] <= mux_stage_5[5 ]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[6 ] <= 0; else if(sel[4] == 1'b1) mux_stage_4[6 ] <= mux_stage_5[22]; else mux_stage_4[6 ] <= mux_stage_5[6 ]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[7 ] <= 0; else if(sel[4] == 1'b1) mux_stage_4[7 ] <= mux_stage_5[23]; else mux_stage_4[7 ] <= mux_stage_5[7 ]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[8 ] <= 0; else if(sel[4] == 1'b1) mux_stage_4[8 ] <= mux_stage_5[24]; else mux_stage_4[8 ] <= mux_stage_5[8 ]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[9 ] <= 0; else if(sel[4] == 1'b1) mux_stage_4[9 ] <= mux_stage_5[25]; else mux_stage_4[9 ] <= mux_stage_5[9 ]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[10] <= 0; else if(sel[4] == 1'b1) mux_stage_4[10] <= mux_stage_5[26]; else mux_stage_4[10] <= mux_stage_5[10]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[11] <= 0; else if(sel[4] == 1'b1) mux_stage_4[11] <= mux_stage_5[27]; else mux_stage_4[11] <= mux_stage_5[11]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[12] <= 0; else if(sel[4] == 1'b1) mux_stage_4[12] <= mux_stage_5[28]; else mux_stage_4[12] <= mux_stage_5[12]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[13] <= 0; else if(sel[4] == 1'b1) mux_stage_4[13] <= mux_stage_5[29]; else mux_stage_4[13] <= mux_stage_5[13]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[14] <= 0; else if(sel[4] == 1'b1) mux_stage_4[14] <= mux_stage_5[30]; else mux_stage_4[14] <= mux_stage_5[14]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[15] <= 0; else if(sel[4] == 1'b1) mux_stage_4[15] <= mux_stage_5[31]; else mux_stage_4[15] <= mux_stage_5[15]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[16] <= 0; else if(sel[4] == 1'b1) mux_stage_4[16] <= mux_stage_5[32]; else mux_stage_4[16] <= mux_stage_5[16]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[17] <= 0; else if(sel[4] == 1'b1) mux_stage_4[17] <= mux_stage_5[33]; else mux_stage_4[17] <= mux_stage_5[17]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[18] <= 0; else if(sel[4] == 1'b1) mux_stage_4[18] <= mux_stage_5[34]; else mux_stage_4[18] <= mux_stage_5[18]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[19] <= 0; else if(sel[4] == 1'b1) mux_stage_4[19] <= mux_stage_5[35]; else mux_stage_4[19] <= mux_stage_5[19]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[20] <= 0; else if(sel[4] == 1'b1) mux_stage_4[20] <= mux_stage_5[36]; else mux_stage_4[20] <= mux_stage_5[20]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[21] <= 0; else if(sel[4] == 1'b1) mux_stage_4[21] <= mux_stage_5[37]; else mux_stage_4[21] <= mux_stage_5[21]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[22] <= 0; else if(sel[4] == 1'b1) mux_stage_4[22] <= mux_stage_5[38]; else mux_stage_4[22] <= mux_stage_5[22]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[23] <= 0; else if(sel[4] == 1'b1) mux_stage_4[23] <= mux_stage_5[39]; else mux_stage_4[23] <= mux_stage_5[23]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[24] <= 0; else if(sel[4] == 1'b1) mux_stage_4[24] <= mux_stage_5[40]; else mux_stage_4[24] <= mux_stage_5[24]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[25] <= 0; else if(sel[4] == 1'b1) mux_stage_4[25] <= mux_stage_5[41]; else mux_stage_4[25] <= mux_stage_5[25]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[26] <= 0; else if(sel[4] == 1'b1) mux_stage_4[26] <= mux_stage_5[42]; else mux_stage_4[26] <= mux_stage_5[26]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[27] <= 0; else if(sel[4] == 1'b1) mux_stage_4[27] <= mux_stage_5[43]; else mux_stage_4[27] <= mux_stage_5[27]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[28] <= 0; else if(sel[4] == 1'b1) mux_stage_4[28] <= mux_stage_5[44]; else mux_stage_4[28] <= mux_stage_5[28]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[29] <= 0; else if(sel[4] == 1'b1) mux_stage_4[29] <= mux_stage_5[45]; else mux_stage_4[29] <= mux_stage_5[29]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[30] <= 0; else if(sel[4] == 1'b1) mux_stage_4[30] <= mux_stage_5[46]; else mux_stage_4[30] <= mux_stage_5[30]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[31] <= 0; else if(sel[4] == 1'b1) mux_stage_4[31] <= mux_stage_5[47]; else mux_stage_4[31] <= mux_stage_5[31]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[32] <= 0; else if(sel[4] == 1'b1) mux_stage_4[32] <= mux_stage_5[48]; else mux_stage_4[32] <= mux_stage_5[32]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[33] <= 0; else if(sel[4] == 1'b1) mux_stage_4[33] <= mux_stage_5[49]; else mux_stage_4[33] <= mux_stage_5[33]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[34] <= 0; else if(sel[4] == 1'b1) mux_stage_4[34] <= mux_stage_5[50]; else mux_stage_4[34] <= mux_stage_5[34]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[35] <= 0; else if(sel[4] == 1'b1) mux_stage_4[35] <= mux_stage_5[51]; else mux_stage_4[35] <= mux_stage_5[35]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[36] <= 0; else if(sel[4] == 1'b1) mux_stage_4[36] <= mux_stage_5[52]; else mux_stage_4[36] <= mux_stage_5[36]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[37] <= 0; else if (sel[4] == 1'b1) mux_stage_4[37] <= sw_in[53]; else mux_stage_4[37] <= mux_stage_5[37]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[38] <= 0; else if (sel[4] == 1'b1) mux_stage_4[38] <= sw_in[54]; else mux_stage_4[38] <= mux_stage_5[38]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[39] <= 0; else if (sel[4] == 1'b1) mux_stage_4[39] <= sw_in[55]; else mux_stage_4[39] <= mux_stage_5[39]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[40] <= 0; else if (sel[4] == 1'b1) mux_stage_4[40] <= sw_in[56]; else mux_stage_4[40] <= mux_stage_5[40]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[41] <= 0; else if (sel[4] == 1'b1) mux_stage_4[41] <= sw_in[57]; else mux_stage_4[41] <= mux_stage_5[41]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[42] <= 0; else if (sel[4] == 1'b1) mux_stage_4[42] <= sw_in[58]; else mux_stage_4[42] <= mux_stage_5[42]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[43] <= 0; else if (sel[4] == 1'b1) mux_stage_4[43] <= sw_in[59]; else mux_stage_4[43] <= mux_stage_5[43]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[44] <= 0; else if (sel[4] == 1'b1) mux_stage_4[44] <= sw_in[60]; else mux_stage_4[44] <= mux_stage_5[44]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[45] <= 0; else if (sel[4] == 1'b1) mux_stage_4[45] <= sw_in[61]; else mux_stage_4[45] <= mux_stage_5[45]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[46] <= 0; else if (sel[4] == 1'b1) mux_stage_4[46] <= sw_in[62]; else mux_stage_4[46] <= mux_stage_5[46]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[47] <= 0; else if (sel[4] == 1'b1) mux_stage_4[47] <= sw_in[63]; else mux_stage_4[47] <= mux_stage_5[47]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[48] <= 0; else if (sel[4] == 1'b1) mux_stage_4[48] <= sw_in[64]; else mux_stage_4[48] <= mux_stage_5[48]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[49] <= 0; else if (sel[4] == 1'b1) mux_stage_4[49] <= sw_in[65]; else mux_stage_4[49] <= mux_stage_5[49]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[50] <= 0; else if (sel[4] == 1'b1) mux_stage_4[50] <= sw_in[66]; else mux_stage_4[50] <= mux_stage_5[50]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[51] <= 0; else if (sel[4] == 1'b1) mux_stage_4[51] <= sw_in[67]; else mux_stage_4[51] <= mux_stage_5[51]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[52] <= 0; else if (sel[4] == 1'b1) mux_stage_4[52] <= sw_in[68]; else mux_stage_4[52] <= mux_stage_5[52]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[53] <= 0; else if (sel[4] == 1'b1) mux_stage_4[53] <= sw_in[69]; else mux_stage_4[53] <= sw_in[53]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[54] <= 0; else if (sel[4] == 1'b1) mux_stage_4[54] <= sw_in[70]; else mux_stage_4[54] <= sw_in[54]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[55] <= 0; else if (sel[4] == 1'b1) mux_stage_4[55] <= sw_in[71]; else mux_stage_4[55] <= sw_in[55]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[56] <= 0; else if (sel[4] == 1'b1) mux_stage_4[56] <= sw_in[72]; else mux_stage_4[56] <= sw_in[56]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[57] <= 0; else if (sel[4] == 1'b1) mux_stage_4[57] <= sw_in[73]; else mux_stage_4[57] <= sw_in[57]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[58] <= 0; else if (sel[4] == 1'b1) mux_stage_4[58] <= sw_in[74]; else mux_stage_4[58] <= sw_in[58]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[59] <= 0; else if (sel[4] == 1'b1) mux_stage_4[59] <= sw_in[75]; else mux_stage_4[59] <= sw_in[59]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[60] <= 0; else if (sel[4] == 1'b1) mux_stage_4[60] <= sw_in[76]; else mux_stage_4[60] <= sw_in[60]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[61] <= 0; else if (sel[4] == 1'b1) mux_stage_4[61] <= sw_in[77]; else mux_stage_4[61] <= sw_in[61]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[62] <= 0; else if (sel[4] == 1'b1) mux_stage_4[62] <= sw_in[78]; else mux_stage_4[62] <= sw_in[62]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[63] <= 0; else if (sel[4] == 1'b1) mux_stage_4[63] <= sw_in[79]; else mux_stage_4[63] <= sw_in[63]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[64] <= 0; else if (sel[4] == 1'b1) mux_stage_4[64] <= sw_in[80]; else mux_stage_4[64] <= sw_in[64]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[65] <= 0; else if (sel[4] == 1'b1) mux_stage_4[65] <= sw_in[81]; else mux_stage_4[65] <= sw_in[65]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[66] <= 0; else if (sel[4] == 1'b1) mux_stage_4[66] <= sw_in[82]; else mux_stage_4[66] <= sw_in[66]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[67] <= 0; else if (sel[4] == 1'b1) mux_stage_4[67] <= sw_in[83]; else mux_stage_4[67] <= sw_in[67]; end
	always @(posedge sys_clk) begin if(!rstn) mux_stage_4[68] <= 0; else if (sel[4] == 1'b1) mux_stage_4[68] <= sw_in[84]; else mux_stage_4[68] <= sw_in[68]; end

	reg sw_in_69_reg0;
	reg sw_in_70_reg0;
	reg sw_in_71_reg0;
	reg sw_in_72_reg0;
	reg sw_in_73_reg0;
	reg sw_in_74_reg0;
	reg sw_in_75_reg0;
	reg sw_in_76_reg0;
	reg sw_in_77_reg0;
	reg sw_in_78_reg0;
	reg sw_in_79_reg0;
	reg sw_in_80_reg0;
	reg sw_in_81_reg0;
	reg sw_in_82_reg0;
	reg sw_in_83_reg0;
	reg sw_in_84_reg0;
	always @(posedge sys_clk) begin if(!rstn) sw_in_69_reg0 <= 0; else sw_in_69_reg0 <= sw_in[69]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_70_reg0 <= 0; else sw_in_70_reg0 <= sw_in[70]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_71_reg0 <= 0; else sw_in_71_reg0 <= sw_in[71]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_72_reg0 <= 0; else sw_in_72_reg0 <= sw_in[72]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_73_reg0 <= 0; else sw_in_73_reg0 <= sw_in[73]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_74_reg0 <= 0; else sw_in_74_reg0 <= sw_in[74]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_75_reg0 <= 0; else sw_in_75_reg0 <= sw_in[75]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_76_reg0 <= 0; else sw_in_76_reg0 <= sw_in[76]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_77_reg0 <= 0; else sw_in_77_reg0 <= sw_in[77]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_78_reg0 <= 0; else sw_in_78_reg0 <= sw_in[78]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_79_reg0 <= 0; else sw_in_79_reg0 <= sw_in[79]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_80_reg0 <= 0; else sw_in_80_reg0 <= sw_in[80]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_81_reg0 <= 0; else sw_in_81_reg0 <= sw_in[81]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_82_reg0 <= 0; else sw_in_82_reg0 <= sw_in[82]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_83_reg0 <= 0; else sw_in_83_reg0 <= sw_in[83]; end
	always @(posedge sys_clk) begin if(!rstn) sw_in_84_reg0 <= 0; else sw_in_84_reg0 <= sw_in[84]; end

	// Multiplexer Stage 3
	wire [76:0] mux_stage_3;
	reg sel_3_reg0;
	always @(posedge sys_clk) begin if(!rstn) sel_3_reg0 <= 0; else sel_3_reg0 <= sel[3]; end
	assign mux_stage_3[0 ] = (sel_3_reg0 == 1'b1) ? mux_stage_4[8] : mux_stage_4[0];
	assign mux_stage_3[1 ] = (sel_3_reg0 == 1'b1) ? mux_stage_4[9] : mux_stage_4[1];
	assign mux_stage_3[2 ] = (sel_3_reg0 == 1'b1) ? mux_stage_4[10] : mux_stage_4[2];
	assign mux_stage_3[3 ] = (sel_3_reg0 == 1'b1) ? mux_stage_4[11] : mux_stage_4[3];
	assign mux_stage_3[4 ] = (sel_3_reg0 == 1'b1) ? mux_stage_4[12] : mux_stage_4[4];
	assign mux_stage_3[5 ] = (sel_3_reg0 == 1'b1) ? mux_stage_4[13] : mux_stage_4[5];
	assign mux_stage_3[6 ] = (sel_3_reg0 == 1'b1) ? mux_stage_4[14] : mux_stage_4[6];
	assign mux_stage_3[7 ] = (sel_3_reg0 == 1'b1) ? mux_stage_4[15] : mux_stage_4[7];
	assign mux_stage_3[8 ] = (sel_3_reg0 == 1'b1) ? mux_stage_4[16] : mux_stage_4[8];
	assign mux_stage_3[9 ] = (sel_3_reg0 == 1'b1) ? mux_stage_4[17] : mux_stage_4[9];
	assign mux_stage_3[10] = (sel_3_reg0 == 1'b1) ? mux_stage_4[18] : mux_stage_4[10];
	assign mux_stage_3[11] = (sel_3_reg0 == 1'b1) ? mux_stage_4[19] : mux_stage_4[11];
	assign mux_stage_3[12] = (sel_3_reg0 == 1'b1) ? mux_stage_4[20] : mux_stage_4[12];
	assign mux_stage_3[13] = (sel_3_reg0 == 1'b1) ? mux_stage_4[21] : mux_stage_4[13];
	assign mux_stage_3[14] = (sel_3_reg0 == 1'b1) ? mux_stage_4[22] : mux_stage_4[14];
	assign mux_stage_3[15] = (sel_3_reg0 == 1'b1) ? mux_stage_4[23] : mux_stage_4[15];
	assign mux_stage_3[16] = (sel_3_reg0 == 1'b1) ? mux_stage_4[24] : mux_stage_4[16];
	assign mux_stage_3[17] = (sel_3_reg0 == 1'b1) ? mux_stage_4[25] : mux_stage_4[17];
	assign mux_stage_3[18] = (sel_3_reg0 == 1'b1) ? mux_stage_4[26] : mux_stage_4[18];
	assign mux_stage_3[19] = (sel_3_reg0 == 1'b1) ? mux_stage_4[27] : mux_stage_4[19];
	assign mux_stage_3[20] = (sel_3_reg0 == 1'b1) ? mux_stage_4[28] : mux_stage_4[20];
	assign mux_stage_3[21] = (sel_3_reg0 == 1'b1) ? mux_stage_4[29] : mux_stage_4[21];
	assign mux_stage_3[22] = (sel_3_reg0 == 1'b1) ? mux_stage_4[30] : mux_stage_4[22];
	assign mux_stage_3[23] = (sel_3_reg0 == 1'b1) ? mux_stage_4[31] : mux_stage_4[23];
	assign mux_stage_3[24] = (sel_3_reg0 == 1'b1) ? mux_stage_4[32] : mux_stage_4[24];
	assign mux_stage_3[25] = (sel_3_reg0 == 1'b1) ? mux_stage_4[33] : mux_stage_4[25];
	assign mux_stage_3[26] = (sel_3_reg0 == 1'b1) ? mux_stage_4[34] : mux_stage_4[26];
	assign mux_stage_3[27] = (sel_3_reg0 == 1'b1) ? mux_stage_4[35] : mux_stage_4[27];
	assign mux_stage_3[28] = (sel_3_reg0 == 1'b1) ? mux_stage_4[36] : mux_stage_4[28];
	assign mux_stage_3[29] = (sel_3_reg0 == 1'b1) ? mux_stage_4[37] : mux_stage_4[29];
	assign mux_stage_3[30] = (sel_3_reg0 == 1'b1) ? mux_stage_4[38] : mux_stage_4[30];
	assign mux_stage_3[31] = (sel_3_reg0 == 1'b1) ? mux_stage_4[39] : mux_stage_4[31];
	assign mux_stage_3[32] = (sel_3_reg0 == 1'b1) ? mux_stage_4[40] : mux_stage_4[32];
	assign mux_stage_3[33] = (sel_3_reg0 == 1'b1) ? mux_stage_4[41] : mux_stage_4[33];
	assign mux_stage_3[34] = (sel_3_reg0 == 1'b1) ? mux_stage_4[42] : mux_stage_4[34];
	assign mux_stage_3[35] = (sel_3_reg0 == 1'b1) ? mux_stage_4[43] : mux_stage_4[35];
	assign mux_stage_3[36] = (sel_3_reg0 == 1'b1) ? mux_stage_4[44] : mux_stage_4[36];
	assign mux_stage_3[37] = (sel_3_reg0 == 1'b1) ? mux_stage_4[45] : mux_stage_4[37];
	assign mux_stage_3[38] = (sel_3_reg0 == 1'b1) ? mux_stage_4[46] : mux_stage_4[38];
	assign mux_stage_3[39] = (sel_3_reg0 == 1'b1) ? mux_stage_4[47] : mux_stage_4[39];
	assign mux_stage_3[40] = (sel_3_reg0 == 1'b1) ? mux_stage_4[48] : mux_stage_4[40];
	assign mux_stage_3[41] = (sel_3_reg0 == 1'b1) ? mux_stage_4[49] : mux_stage_4[41];
	assign mux_stage_3[42] = (sel_3_reg0 == 1'b1) ? mux_stage_4[50] : mux_stage_4[42];
	assign mux_stage_3[43] = (sel_3_reg0 == 1'b1) ? mux_stage_4[51] : mux_stage_4[43];
	assign mux_stage_3[44] = (sel_3_reg0 == 1'b1) ? mux_stage_4[52] : mux_stage_4[44];
	assign mux_stage_3[45] = (sel_3_reg0 == 1'b1) ? mux_stage_4[53] : mux_stage_4[45];
	assign mux_stage_3[46] = (sel_3_reg0 == 1'b1) ? mux_stage_4[54] : mux_stage_4[46];
	assign mux_stage_3[47] = (sel_3_reg0 == 1'b1) ? mux_stage_4[55] : mux_stage_4[47];
	assign mux_stage_3[48] = (sel_3_reg0 == 1'b1) ? mux_stage_4[56] : mux_stage_4[48];
	assign mux_stage_3[49] = (sel_3_reg0 == 1'b1) ? mux_stage_4[57] : mux_stage_4[49];
	assign mux_stage_3[50] = (sel_3_reg0 == 1'b1) ? mux_stage_4[58] : mux_stage_4[50];
	assign mux_stage_3[51] = (sel_3_reg0 == 1'b1) ? mux_stage_4[59] : mux_stage_4[51];
	assign mux_stage_3[52] = (sel_3_reg0 == 1'b1) ? mux_stage_4[60] : mux_stage_4[52];
	assign mux_stage_3[53] = (sel_3_reg0 == 1'b1) ? mux_stage_4[61] : mux_stage_4[53];
	assign mux_stage_3[54] = (sel_3_reg0 == 1'b1) ? mux_stage_4[62] : mux_stage_4[54];
	assign mux_stage_3[55] = (sel_3_reg0 == 1'b1) ? mux_stage_4[63] : mux_stage_4[55];
	assign mux_stage_3[56] = (sel_3_reg0 == 1'b1) ? mux_stage_4[64] : mux_stage_4[56];
	assign mux_stage_3[57] = (sel_3_reg0 == 1'b1) ? mux_stage_4[65] : mux_stage_4[57];
	assign mux_stage_3[58] = (sel_3_reg0 == 1'b1) ? mux_stage_4[66] : mux_stage_4[58];
	assign mux_stage_3[59] = (sel_3_reg0 == 1'b1) ? mux_stage_4[67] : mux_stage_4[59];
	assign mux_stage_3[60] = (sel_3_reg0 == 1'b1) ? mux_stage_4[68] : mux_stage_4[60];
	assign mux_stage_3[61] = (sel_3_reg0 == 1'b1) ? sw_in_69_reg0 : mux_stage_4[61];
	assign mux_stage_3[62] = (sel_3_reg0 == 1'b1) ? sw_in_70_reg0 : mux_stage_4[62];
	assign mux_stage_3[63] = (sel_3_reg0 == 1'b1) ? sw_in_71_reg0 : mux_stage_4[63];
	assign mux_stage_3[64] = (sel_3_reg0 == 1'b1) ? sw_in_72_reg0 : mux_stage_4[64];
	assign mux_stage_3[65] = (sel_3_reg0 == 1'b1) ? sw_in_73_reg0 : mux_stage_4[65];
	assign mux_stage_3[66] = (sel_3_reg0 == 1'b1) ? sw_in_74_reg0 : mux_stage_4[66];
	assign mux_stage_3[67] = (sel_3_reg0 == 1'b1) ? sw_in_75_reg0 : mux_stage_4[67];
	assign mux_stage_3[68] = (sel_3_reg0 == 1'b1) ? sw_in_76_reg0 : mux_stage_4[68];
	assign mux_stage_3[69] = (sel_3_reg0 == 1'b1) ? sw_in_77_reg0 : sw_in_69_reg0;
	assign mux_stage_3[70] = (sel_3_reg0 == 1'b1) ? sw_in_78_reg0 : sw_in_70_reg0;
	assign mux_stage_3[71] = (sel_3_reg0 == 1'b1) ? sw_in_79_reg0 : sw_in_71_reg0;
	assign mux_stage_3[72] = (sel_3_reg0 == 1'b1) ? sw_in_80_reg0 : sw_in_72_reg0;
	assign mux_stage_3[73] = (sel_3_reg0 == 1'b1) ? sw_in_81_reg0 : sw_in_73_reg0;
	assign mux_stage_3[74] = (sel_3_reg0 == 1'b1) ? sw_in_82_reg0 : sw_in_74_reg0;
	assign mux_stage_3[75] = (sel_3_reg0 == 1'b1) ? sw_in_83_reg0 : sw_in_75_reg0;
	assign mux_stage_3[76] = (sel_3_reg0 == 1'b1) ? sw_in_84_reg0 : sw_in_76_reg0;

	// Multiplexer Stage 2
	wire [80:0] mux_stage_2;
	reg sel_2_reg0;
	always @(posedge sys_clk) begin if(!rstn) sel_2_reg0 <= 0; else sel_2_reg0 <= sel[2]; end
	assign mux_stage_2[0 ] = (sel_2_reg0 == 1'b1) ? mux_stage_3[4] : mux_stage_3[0];
	assign mux_stage_2[1 ] = (sel_2_reg0 == 1'b1) ? mux_stage_3[5] : mux_stage_3[1];
	assign mux_stage_2[2 ] = (sel_2_reg0 == 1'b1) ? mux_stage_3[6] : mux_stage_3[2];
	assign mux_stage_2[3 ] = (sel_2_reg0 == 1'b1) ? mux_stage_3[7] : mux_stage_3[3];
	assign mux_stage_2[4 ] = (sel_2_reg0 == 1'b1) ? mux_stage_3[8] : mux_stage_3[4];
	assign mux_stage_2[5 ] = (sel_2_reg0 == 1'b1) ? mux_stage_3[9] : mux_stage_3[5];
	assign mux_stage_2[6 ] = (sel_2_reg0 == 1'b1) ? mux_stage_3[10] : mux_stage_3[6];
	assign mux_stage_2[7 ] = (sel_2_reg0 == 1'b1) ? mux_stage_3[11] : mux_stage_3[7];
	assign mux_stage_2[8 ] = (sel_2_reg0 == 1'b1) ? mux_stage_3[12] : mux_stage_3[8];
	assign mux_stage_2[9 ] = (sel_2_reg0 == 1'b1) ? mux_stage_3[13] : mux_stage_3[9];
	assign mux_stage_2[10] = (sel_2_reg0 == 1'b1) ? mux_stage_3[14] : mux_stage_3[10];
	assign mux_stage_2[11] = (sel_2_reg0 == 1'b1) ? mux_stage_3[15] : mux_stage_3[11];
	assign mux_stage_2[12] = (sel_2_reg0 == 1'b1) ? mux_stage_3[16] : mux_stage_3[12];
	assign mux_stage_2[13] = (sel_2_reg0 == 1'b1) ? mux_stage_3[17] : mux_stage_3[13];
	assign mux_stage_2[14] = (sel_2_reg0 == 1'b1) ? mux_stage_3[18] : mux_stage_3[14];
	assign mux_stage_2[15] = (sel_2_reg0 == 1'b1) ? mux_stage_3[19] : mux_stage_3[15];
	assign mux_stage_2[16] = (sel_2_reg0 == 1'b1) ? mux_stage_3[20] : mux_stage_3[16];
	assign mux_stage_2[17] = (sel_2_reg0 == 1'b1) ? mux_stage_3[21] : mux_stage_3[17];
	assign mux_stage_2[18] = (sel_2_reg0 == 1'b1) ? mux_stage_3[22] : mux_stage_3[18];
	assign mux_stage_2[19] = (sel_2_reg0 == 1'b1) ? mux_stage_3[23] : mux_stage_3[19];
	assign mux_stage_2[20] = (sel_2_reg0 == 1'b1) ? mux_stage_3[24] : mux_stage_3[20];
	assign mux_stage_2[21] = (sel_2_reg0 == 1'b1) ? mux_stage_3[25] : mux_stage_3[21];
	assign mux_stage_2[22] = (sel_2_reg0 == 1'b1) ? mux_stage_3[26] : mux_stage_3[22];
	assign mux_stage_2[23] = (sel_2_reg0 == 1'b1) ? mux_stage_3[27] : mux_stage_3[23];
	assign mux_stage_2[24] = (sel_2_reg0 == 1'b1) ? mux_stage_3[28] : mux_stage_3[24];
	assign mux_stage_2[25] = (sel_2_reg0 == 1'b1) ? mux_stage_3[29] : mux_stage_3[25];
	assign mux_stage_2[26] = (sel_2_reg0 == 1'b1) ? mux_stage_3[30] : mux_stage_3[26];
	assign mux_stage_2[27] = (sel_2_reg0 == 1'b1) ? mux_stage_3[31] : mux_stage_3[27];
	assign mux_stage_2[28] = (sel_2_reg0 == 1'b1) ? mux_stage_3[32] : mux_stage_3[28];
	assign mux_stage_2[29] = (sel_2_reg0 == 1'b1) ? mux_stage_3[33] : mux_stage_3[29];
	assign mux_stage_2[30] = (sel_2_reg0 == 1'b1) ? mux_stage_3[34] : mux_stage_3[30];
	assign mux_stage_2[31] = (sel_2_reg0 == 1'b1) ? mux_stage_3[35] : mux_stage_3[31];
	assign mux_stage_2[32] = (sel_2_reg0 == 1'b1) ? mux_stage_3[36] : mux_stage_3[32];
	assign mux_stage_2[33] = (sel_2_reg0 == 1'b1) ? mux_stage_3[37] : mux_stage_3[33];
	assign mux_stage_2[34] = (sel_2_reg0 == 1'b1) ? mux_stage_3[38] : mux_stage_3[34];
	assign mux_stage_2[35] = (sel_2_reg0 == 1'b1) ? mux_stage_3[39] : mux_stage_3[35];
	assign mux_stage_2[36] = (sel_2_reg0 == 1'b1) ? mux_stage_3[40] : mux_stage_3[36];
	assign mux_stage_2[37] = (sel_2_reg0 == 1'b1) ? mux_stage_3[41] : mux_stage_3[37];
	assign mux_stage_2[38] = (sel_2_reg0 == 1'b1) ? mux_stage_3[42] : mux_stage_3[38];
	assign mux_stage_2[39] = (sel_2_reg0 == 1'b1) ? mux_stage_3[43] : mux_stage_3[39];
	assign mux_stage_2[40] = (sel_2_reg0 == 1'b1) ? mux_stage_3[44] : mux_stage_3[40];
	assign mux_stage_2[41] = (sel_2_reg0 == 1'b1) ? mux_stage_3[45] : mux_stage_3[41];
	assign mux_stage_2[42] = (sel_2_reg0 == 1'b1) ? mux_stage_3[46] : mux_stage_3[42];
	assign mux_stage_2[43] = (sel_2_reg0 == 1'b1) ? mux_stage_3[47] : mux_stage_3[43];
	assign mux_stage_2[44] = (sel_2_reg0 == 1'b1) ? mux_stage_3[48] : mux_stage_3[44];
	assign mux_stage_2[45] = (sel_2_reg0 == 1'b1) ? mux_stage_3[49] : mux_stage_3[45];
	assign mux_stage_2[46] = (sel_2_reg0 == 1'b1) ? mux_stage_3[50] : mux_stage_3[46];
	assign mux_stage_2[47] = (sel_2_reg0 == 1'b1) ? mux_stage_3[51] : mux_stage_3[47];
	assign mux_stage_2[48] = (sel_2_reg0 == 1'b1) ? mux_stage_3[52] : mux_stage_3[48];
	assign mux_stage_2[49] = (sel_2_reg0 == 1'b1) ? mux_stage_3[53] : mux_stage_3[49];
	assign mux_stage_2[50] = (sel_2_reg0 == 1'b1) ? mux_stage_3[54] : mux_stage_3[50];
	assign mux_stage_2[51] = (sel_2_reg0 == 1'b1) ? mux_stage_3[55] : mux_stage_3[51];
	assign mux_stage_2[52] = (sel_2_reg0 == 1'b1) ? mux_stage_3[56] : mux_stage_3[52];
	assign mux_stage_2[53] = (sel_2_reg0 == 1'b1) ? mux_stage_3[57] : mux_stage_3[53];
	assign mux_stage_2[54] = (sel_2_reg0 == 1'b1) ? mux_stage_3[58] : mux_stage_3[54];
	assign mux_stage_2[55] = (sel_2_reg0 == 1'b1) ? mux_stage_3[59] : mux_stage_3[55];
	assign mux_stage_2[56] = (sel_2_reg0 == 1'b1) ? mux_stage_3[60] : mux_stage_3[56];
	assign mux_stage_2[57] = (sel_2_reg0 == 1'b1) ? mux_stage_3[61] : mux_stage_3[57];
	assign mux_stage_2[58] = (sel_2_reg0 == 1'b1) ? mux_stage_3[62] : mux_stage_3[58];
	assign mux_stage_2[59] = (sel_2_reg0 == 1'b1) ? mux_stage_3[63] : mux_stage_3[59];
	assign mux_stage_2[60] = (sel_2_reg0 == 1'b1) ? mux_stage_3[64] : mux_stage_3[60];
	assign mux_stage_2[61] = (sel_2_reg0 == 1'b1) ? mux_stage_3[65] : mux_stage_3[61];
	assign mux_stage_2[62] = (sel_2_reg0 == 1'b1) ? mux_stage_3[66] : mux_stage_3[62];
	assign mux_stage_2[63] = (sel_2_reg0 == 1'b1) ? mux_stage_3[67] : mux_stage_3[63];
	assign mux_stage_2[64] = (sel_2_reg0 == 1'b1) ? mux_stage_3[68] : mux_stage_3[64];
	assign mux_stage_2[65] = (sel_2_reg0 == 1'b1) ? mux_stage_3[69] : mux_stage_3[65];
	assign mux_stage_2[66] = (sel_2_reg0 == 1'b1) ? mux_stage_3[70] : mux_stage_3[66];
	assign mux_stage_2[67] = (sel_2_reg0 == 1'b1) ? mux_stage_3[71] : mux_stage_3[67];
	assign mux_stage_2[68] = (sel_2_reg0 == 1'b1) ? mux_stage_3[72] : mux_stage_3[68];
	assign mux_stage_2[69] = (sel_2_reg0 == 1'b1) ? mux_stage_3[73] : mux_stage_3[69];
	assign mux_stage_2[70] = (sel_2_reg0 == 1'b1) ? mux_stage_3[74] : mux_stage_3[70];
	assign mux_stage_2[71] = (sel_2_reg0 == 1'b1) ? mux_stage_3[75] : mux_stage_3[71];
	assign mux_stage_2[72] = (sel_2_reg0 == 1'b1) ? mux_stage_3[76] : mux_stage_3[72];
	assign mux_stage_2[73] = (sel_2_reg0 == 1'b1) ? sw_in_77_reg0 : mux_stage_3[73];
	assign mux_stage_2[74] = (sel_2_reg0 == 1'b1) ? sw_in_78_reg0 : mux_stage_3[74];
	assign mux_stage_2[75] = (sel_2_reg0 == 1'b1) ? sw_in_79_reg0 : mux_stage_3[75];
	assign mux_stage_2[76] = (sel_2_reg0 == 1'b1) ? sw_in_80_reg0 : mux_stage_3[76];
	assign mux_stage_2[77] = (sel_2_reg0 == 1'b1) ? sw_in_81_reg0 : sw_in_77_reg0;
	assign mux_stage_2[78] = (sel_2_reg0 == 1'b1) ? sw_in_82_reg0 : sw_in_78_reg0;
	assign mux_stage_2[79] = (sel_2_reg0 == 1'b1) ? sw_in_83_reg0 : sw_in_79_reg0;
	assign mux_stage_2[80] = (sel_2_reg0 == 1'b1) ? sw_in_84_reg0 : sw_in_80_reg0;

	// Multiplexer Stage 1
	wire [82:0] mux_stage_1;
	reg sel_1_reg0;
	always @(posedge sys_clk) begin if(!rstn) sel_1_reg0 <= 0; else sel_1_reg0 <= sel[1]; end
	assign mux_stage_1[0 ] = (sel_1_reg0 == 1'b1) ? mux_stage_2[2] : mux_stage_2[0];
	assign mux_stage_1[1 ] = (sel_1_reg0 == 1'b1) ? mux_stage_2[3] : mux_stage_2[1];
	assign mux_stage_1[2 ] = (sel_1_reg0 == 1'b1) ? mux_stage_2[4] : mux_stage_2[2];
	assign mux_stage_1[3 ] = (sel_1_reg0 == 1'b1) ? mux_stage_2[5] : mux_stage_2[3];
	assign mux_stage_1[4 ] = (sel_1_reg0 == 1'b1) ? mux_stage_2[6] : mux_stage_2[4];
	assign mux_stage_1[5 ] = (sel_1_reg0 == 1'b1) ? mux_stage_2[7] : mux_stage_2[5];
	assign mux_stage_1[6 ] = (sel_1_reg0 == 1'b1) ? mux_stage_2[8] : mux_stage_2[6];
	assign mux_stage_1[7 ] = (sel_1_reg0 == 1'b1) ? mux_stage_2[9] : mux_stage_2[7];
	assign mux_stage_1[8 ] = (sel_1_reg0 == 1'b1) ? mux_stage_2[10] : mux_stage_2[8];
	assign mux_stage_1[9 ] = (sel_1_reg0 == 1'b1) ? mux_stage_2[11] : mux_stage_2[9];
	assign mux_stage_1[10] = (sel_1_reg0 == 1'b1) ? mux_stage_2[12] : mux_stage_2[10];
	assign mux_stage_1[11] = (sel_1_reg0 == 1'b1) ? mux_stage_2[13] : mux_stage_2[11];
	assign mux_stage_1[12] = (sel_1_reg0 == 1'b1) ? mux_stage_2[14] : mux_stage_2[12];
	assign mux_stage_1[13] = (sel_1_reg0 == 1'b1) ? mux_stage_2[15] : mux_stage_2[13];
	assign mux_stage_1[14] = (sel_1_reg0 == 1'b1) ? mux_stage_2[16] : mux_stage_2[14];
	assign mux_stage_1[15] = (sel_1_reg0 == 1'b1) ? mux_stage_2[17] : mux_stage_2[15];
	assign mux_stage_1[16] = (sel_1_reg0 == 1'b1) ? mux_stage_2[18] : mux_stage_2[16];
	assign mux_stage_1[17] = (sel_1_reg0 == 1'b1) ? mux_stage_2[19] : mux_stage_2[17];
	assign mux_stage_1[18] = (sel_1_reg0 == 1'b1) ? mux_stage_2[20] : mux_stage_2[18];
	assign mux_stage_1[19] = (sel_1_reg0 == 1'b1) ? mux_stage_2[21] : mux_stage_2[19];
	assign mux_stage_1[20] = (sel_1_reg0 == 1'b1) ? mux_stage_2[22] : mux_stage_2[20];
	assign mux_stage_1[21] = (sel_1_reg0 == 1'b1) ? mux_stage_2[23] : mux_stage_2[21];
	assign mux_stage_1[22] = (sel_1_reg0 == 1'b1) ? mux_stage_2[24] : mux_stage_2[22];
	assign mux_stage_1[23] = (sel_1_reg0 == 1'b1) ? mux_stage_2[25] : mux_stage_2[23];
	assign mux_stage_1[24] = (sel_1_reg0 == 1'b1) ? mux_stage_2[26] : mux_stage_2[24];
	assign mux_stage_1[25] = (sel_1_reg0 == 1'b1) ? mux_stage_2[27] : mux_stage_2[25];
	assign mux_stage_1[26] = (sel_1_reg0 == 1'b1) ? mux_stage_2[28] : mux_stage_2[26];
	assign mux_stage_1[27] = (sel_1_reg0 == 1'b1) ? mux_stage_2[29] : mux_stage_2[27];
	assign mux_stage_1[28] = (sel_1_reg0 == 1'b1) ? mux_stage_2[30] : mux_stage_2[28];
	assign mux_stage_1[29] = (sel_1_reg0 == 1'b1) ? mux_stage_2[31] : mux_stage_2[29];
	assign mux_stage_1[30] = (sel_1_reg0 == 1'b1) ? mux_stage_2[32] : mux_stage_2[30];
	assign mux_stage_1[31] = (sel_1_reg0 == 1'b1) ? mux_stage_2[33] : mux_stage_2[31];
	assign mux_stage_1[32] = (sel_1_reg0 == 1'b1) ? mux_stage_2[34] : mux_stage_2[32];
	assign mux_stage_1[33] = (sel_1_reg0 == 1'b1) ? mux_stage_2[35] : mux_stage_2[33];
	assign mux_stage_1[34] = (sel_1_reg0 == 1'b1) ? mux_stage_2[36] : mux_stage_2[34];
	assign mux_stage_1[35] = (sel_1_reg0 == 1'b1) ? mux_stage_2[37] : mux_stage_2[35];
	assign mux_stage_1[36] = (sel_1_reg0 == 1'b1) ? mux_stage_2[38] : mux_stage_2[36];
	assign mux_stage_1[37] = (sel_1_reg0 == 1'b1) ? mux_stage_2[39] : mux_stage_2[37];
	assign mux_stage_1[38] = (sel_1_reg0 == 1'b1) ? mux_stage_2[40] : mux_stage_2[38];
	assign mux_stage_1[39] = (sel_1_reg0 == 1'b1) ? mux_stage_2[41] : mux_stage_2[39];
	assign mux_stage_1[40] = (sel_1_reg0 == 1'b1) ? mux_stage_2[42] : mux_stage_2[40];
	assign mux_stage_1[41] = (sel_1_reg0 == 1'b1) ? mux_stage_2[43] : mux_stage_2[41];
	assign mux_stage_1[42] = (sel_1_reg0 == 1'b1) ? mux_stage_2[44] : mux_stage_2[42];
	assign mux_stage_1[43] = (sel_1_reg0 == 1'b1) ? mux_stage_2[45] : mux_stage_2[43];
	assign mux_stage_1[44] = (sel_1_reg0 == 1'b1) ? mux_stage_2[46] : mux_stage_2[44];
	assign mux_stage_1[45] = (sel_1_reg0 == 1'b1) ? mux_stage_2[47] : mux_stage_2[45];
	assign mux_stage_1[46] = (sel_1_reg0 == 1'b1) ? mux_stage_2[48] : mux_stage_2[46];
	assign mux_stage_1[47] = (sel_1_reg0 == 1'b1) ? mux_stage_2[49] : mux_stage_2[47];
	assign mux_stage_1[48] = (sel_1_reg0 == 1'b1) ? mux_stage_2[50] : mux_stage_2[48];
	assign mux_stage_1[49] = (sel_1_reg0 == 1'b1) ? mux_stage_2[51] : mux_stage_2[49];
	assign mux_stage_1[50] = (sel_1_reg0 == 1'b1) ? mux_stage_2[52] : mux_stage_2[50];
	assign mux_stage_1[51] = (sel_1_reg0 == 1'b1) ? mux_stage_2[53] : mux_stage_2[51];
	assign mux_stage_1[52] = (sel_1_reg0 == 1'b1) ? mux_stage_2[54] : mux_stage_2[52];
	assign mux_stage_1[53] = (sel_1_reg0 == 1'b1) ? mux_stage_2[55] : mux_stage_2[53];
	assign mux_stage_1[54] = (sel_1_reg0 == 1'b1) ? mux_stage_2[56] : mux_stage_2[54];
	assign mux_stage_1[55] = (sel_1_reg0 == 1'b1) ? mux_stage_2[57] : mux_stage_2[55];
	assign mux_stage_1[56] = (sel_1_reg0 == 1'b1) ? mux_stage_2[58] : mux_stage_2[56];
	assign mux_stage_1[57] = (sel_1_reg0 == 1'b1) ? mux_stage_2[59] : mux_stage_2[57];
	assign mux_stage_1[58] = (sel_1_reg0 == 1'b1) ? mux_stage_2[60] : mux_stage_2[58];
	assign mux_stage_1[59] = (sel_1_reg0 == 1'b1) ? mux_stage_2[61] : mux_stage_2[59];
	assign mux_stage_1[60] = (sel_1_reg0 == 1'b1) ? mux_stage_2[62] : mux_stage_2[60];
	assign mux_stage_1[61] = (sel_1_reg0 == 1'b1) ? mux_stage_2[63] : mux_stage_2[61];
	assign mux_stage_1[62] = (sel_1_reg0 == 1'b1) ? mux_stage_2[64] : mux_stage_2[62];
	assign mux_stage_1[63] = (sel_1_reg0 == 1'b1) ? mux_stage_2[65] : mux_stage_2[63];
	assign mux_stage_1[64] = (sel_1_reg0 == 1'b1) ? mux_stage_2[66] : mux_stage_2[64];
	assign mux_stage_1[65] = (sel_1_reg0 == 1'b1) ? mux_stage_2[67] : mux_stage_2[65];
	assign mux_stage_1[66] = (sel_1_reg0 == 1'b1) ? mux_stage_2[68] : mux_stage_2[66];
	assign mux_stage_1[67] = (sel_1_reg0 == 1'b1) ? mux_stage_2[69] : mux_stage_2[67];
	assign mux_stage_1[68] = (sel_1_reg0 == 1'b1) ? mux_stage_2[70] : mux_stage_2[68];
	assign mux_stage_1[69] = (sel_1_reg0 == 1'b1) ? mux_stage_2[71] : mux_stage_2[69];
	assign mux_stage_1[70] = (sel_1_reg0 == 1'b1) ? mux_stage_2[72] : mux_stage_2[70];
	assign mux_stage_1[71] = (sel_1_reg0 == 1'b1) ? mux_stage_2[73] : mux_stage_2[71];
	assign mux_stage_1[72] = (sel_1_reg0 == 1'b1) ? mux_stage_2[74] : mux_stage_2[72];
	assign mux_stage_1[73] = (sel_1_reg0 == 1'b1) ? mux_stage_2[75] : mux_stage_2[73];
	assign mux_stage_1[74] = (sel_1_reg0 == 1'b1) ? mux_stage_2[76] : mux_stage_2[74];
	assign mux_stage_1[75] = (sel_1_reg0 == 1'b1) ? mux_stage_2[77] : mux_stage_2[75];
	assign mux_stage_1[76] = (sel_1_reg0 == 1'b1) ? mux_stage_2[78] : mux_stage_2[76];
	assign mux_stage_1[77] = (sel_1_reg0 == 1'b1) ? mux_stage_2[79] : mux_stage_2[77];
	assign mux_stage_1[78] = (sel_1_reg0 == 1'b1) ? mux_stage_2[80] : mux_stage_2[78];
	assign mux_stage_1[79] = (sel_1_reg0 == 1'b1) ? sw_in_81_reg0 : mux_stage_2[79];
	assign mux_stage_1[80] = (sel_1_reg0 == 1'b1) ? sw_in_82_reg0 : mux_stage_2[80];
	assign mux_stage_1[81] = (sel_1_reg0 == 1'b1) ? sw_in_83_reg0 : sw_in_81_reg0;
	assign mux_stage_1[82] = (sel_1_reg0 == 1'b1) ? sw_in_84_reg0 : sw_in_82_reg0;

	// Multiplexer Stage 0
	wire [83:0] mux_stage_0;
	reg sel_0_reg0;
	always @(posedge sys_clk) begin if(!rstn) sel_0_reg0 <= 0; else sel_0_reg0 <= sel[0]; end
	assign mux_stage_0[0 ] = (sel_0_reg0 == 1'b1) ? mux_stage_1[1] : mux_stage_1[0];
	assign mux_stage_0[1 ] = (sel_0_reg0 == 1'b1) ? mux_stage_1[2] : mux_stage_1[1];
	assign mux_stage_0[2 ] = (sel_0_reg0 == 1'b1) ? mux_stage_1[3] : mux_stage_1[2];
	assign mux_stage_0[3 ] = (sel_0_reg0 == 1'b1) ? mux_stage_1[4] : mux_stage_1[3];
	assign mux_stage_0[4 ] = (sel_0_reg0 == 1'b1) ? mux_stage_1[5] : mux_stage_1[4];
	assign mux_stage_0[5 ] = (sel_0_reg0 == 1'b1) ? mux_stage_1[6] : mux_stage_1[5];
	assign mux_stage_0[6 ] = (sel_0_reg0 == 1'b1) ? mux_stage_1[7] : mux_stage_1[6];
	assign mux_stage_0[7 ] = (sel_0_reg0 == 1'b1) ? mux_stage_1[8] : mux_stage_1[7];
	assign mux_stage_0[8 ] = (sel_0_reg0 == 1'b1) ? mux_stage_1[9] : mux_stage_1[8];
	assign mux_stage_0[9 ] = (sel_0_reg0 == 1'b1) ? mux_stage_1[10] : mux_stage_1[9];
	assign mux_stage_0[10] = (sel_0_reg0 == 1'b1) ? mux_stage_1[11] : mux_stage_1[10];
	assign mux_stage_0[11] = (sel_0_reg0 == 1'b1) ? mux_stage_1[12] : mux_stage_1[11];
	assign mux_stage_0[12] = (sel_0_reg0 == 1'b1) ? mux_stage_1[13] : mux_stage_1[12];
	assign mux_stage_0[13] = (sel_0_reg0 == 1'b1) ? mux_stage_1[14] : mux_stage_1[13];
	assign mux_stage_0[14] = (sel_0_reg0 == 1'b1) ? mux_stage_1[15] : mux_stage_1[14];
	assign mux_stage_0[15] = (sel_0_reg0 == 1'b1) ? mux_stage_1[16] : mux_stage_1[15];
	assign mux_stage_0[16] = (sel_0_reg0 == 1'b1) ? mux_stage_1[17] : mux_stage_1[16];
	assign mux_stage_0[17] = (sel_0_reg0 == 1'b1) ? mux_stage_1[18] : mux_stage_1[17];
	assign mux_stage_0[18] = (sel_0_reg0 == 1'b1) ? mux_stage_1[19] : mux_stage_1[18];
	assign mux_stage_0[19] = (sel_0_reg0 == 1'b1) ? mux_stage_1[20] : mux_stage_1[19];
	assign mux_stage_0[20] = (sel_0_reg0 == 1'b1) ? mux_stage_1[21] : mux_stage_1[20];
	assign mux_stage_0[21] = (sel_0_reg0 == 1'b1) ? mux_stage_1[22] : mux_stage_1[21];
	assign mux_stage_0[22] = (sel_0_reg0 == 1'b1) ? mux_stage_1[23] : mux_stage_1[22];
	assign mux_stage_0[23] = (sel_0_reg0 == 1'b1) ? mux_stage_1[24] : mux_stage_1[23];
	assign mux_stage_0[24] = (sel_0_reg0 == 1'b1) ? mux_stage_1[25] : mux_stage_1[24];
	assign mux_stage_0[25] = (sel_0_reg0 == 1'b1) ? mux_stage_1[26] : mux_stage_1[25];
	assign mux_stage_0[26] = (sel_0_reg0 == 1'b1) ? mux_stage_1[27] : mux_stage_1[26];
	assign mux_stage_0[27] = (sel_0_reg0 == 1'b1) ? mux_stage_1[28] : mux_stage_1[27];
	assign mux_stage_0[28] = (sel_0_reg0 == 1'b1) ? mux_stage_1[29] : mux_stage_1[28];
	assign mux_stage_0[29] = (sel_0_reg0 == 1'b1) ? mux_stage_1[30] : mux_stage_1[29];
	assign mux_stage_0[30] = (sel_0_reg0 == 1'b1) ? mux_stage_1[31] : mux_stage_1[30];
	assign mux_stage_0[31] = (sel_0_reg0 == 1'b1) ? mux_stage_1[32] : mux_stage_1[31];
	assign mux_stage_0[32] = (sel_0_reg0 == 1'b1) ? mux_stage_1[33] : mux_stage_1[32];
	assign mux_stage_0[33] = (sel_0_reg0 == 1'b1) ? mux_stage_1[34] : mux_stage_1[33];
	assign mux_stage_0[34] = (sel_0_reg0 == 1'b1) ? mux_stage_1[35] : mux_stage_1[34];
	assign mux_stage_0[35] = (sel_0_reg0 == 1'b1) ? mux_stage_1[36] : mux_stage_1[35];
	assign mux_stage_0[36] = (sel_0_reg0 == 1'b1) ? mux_stage_1[37] : mux_stage_1[36];
	assign mux_stage_0[37] = (sel_0_reg0 == 1'b1) ? mux_stage_1[38] : mux_stage_1[37];
	assign mux_stage_0[38] = (sel_0_reg0 == 1'b1) ? mux_stage_1[39] : mux_stage_1[38];
	assign mux_stage_0[39] = (sel_0_reg0 == 1'b1) ? mux_stage_1[40] : mux_stage_1[39];
	assign mux_stage_0[40] = (sel_0_reg0 == 1'b1) ? mux_stage_1[41] : mux_stage_1[40];
	assign mux_stage_0[41] = (sel_0_reg0 == 1'b1) ? mux_stage_1[42] : mux_stage_1[41];
	assign mux_stage_0[42] = (sel_0_reg0 == 1'b1) ? mux_stage_1[43] : mux_stage_1[42];
	assign mux_stage_0[43] = (sel_0_reg0 == 1'b1) ? mux_stage_1[44] : mux_stage_1[43];
	assign mux_stage_0[44] = (sel_0_reg0 == 1'b1) ? mux_stage_1[45] : mux_stage_1[44];
	assign mux_stage_0[45] = (sel_0_reg0 == 1'b1) ? mux_stage_1[46] : mux_stage_1[45];
	assign mux_stage_0[46] = (sel_0_reg0 == 1'b1) ? mux_stage_1[47] : mux_stage_1[46];
	assign mux_stage_0[47] = (sel_0_reg0 == 1'b1) ? mux_stage_1[48] : mux_stage_1[47];
	assign mux_stage_0[48] = (sel_0_reg0 == 1'b1) ? mux_stage_1[49] : mux_stage_1[48];
	assign mux_stage_0[49] = (sel_0_reg0 == 1'b1) ? mux_stage_1[50] : mux_stage_1[49];
	assign mux_stage_0[50] = (sel_0_reg0 == 1'b1) ? mux_stage_1[51] : mux_stage_1[50];
	assign mux_stage_0[51] = (sel_0_reg0 == 1'b1) ? mux_stage_1[52] : mux_stage_1[51];
	assign mux_stage_0[52] = (sel_0_reg0 == 1'b1) ? mux_stage_1[53] : mux_stage_1[52];
	assign mux_stage_0[53] = (sel_0_reg0 == 1'b1) ? mux_stage_1[54] : mux_stage_1[53];
	assign mux_stage_0[54] = (sel_0_reg0 == 1'b1) ? mux_stage_1[55] : mux_stage_1[54];
	assign mux_stage_0[55] = (sel_0_reg0 == 1'b1) ? mux_stage_1[56] : mux_stage_1[55];
	assign mux_stage_0[56] = (sel_0_reg0 == 1'b1) ? mux_stage_1[57] : mux_stage_1[56];
	assign mux_stage_0[57] = (sel_0_reg0 == 1'b1) ? mux_stage_1[58] : mux_stage_1[57];
	assign mux_stage_0[58] = (sel_0_reg0 == 1'b1) ? mux_stage_1[59] : mux_stage_1[58];
	assign mux_stage_0[59] = (sel_0_reg0 == 1'b1) ? mux_stage_1[60] : mux_stage_1[59];
	assign mux_stage_0[60] = (sel_0_reg0 == 1'b1) ? mux_stage_1[61] : mux_stage_1[60];
	assign mux_stage_0[61] = (sel_0_reg0 == 1'b1) ? mux_stage_1[62] : mux_stage_1[61];
	assign mux_stage_0[62] = (sel_0_reg0 == 1'b1) ? mux_stage_1[63] : mux_stage_1[62];
	assign mux_stage_0[63] = (sel_0_reg0 == 1'b1) ? mux_stage_1[64] : mux_stage_1[63];
	assign mux_stage_0[64] = (sel_0_reg0 == 1'b1) ? mux_stage_1[65] : mux_stage_1[64];
	assign mux_stage_0[65] = (sel_0_reg0 == 1'b1) ? mux_stage_1[66] : mux_stage_1[65];
	assign mux_stage_0[66] = (sel_0_reg0 == 1'b1) ? mux_stage_1[67] : mux_stage_1[66];
	assign mux_stage_0[67] = (sel_0_reg0 == 1'b1) ? mux_stage_1[68] : mux_stage_1[67];
	assign mux_stage_0[68] = (sel_0_reg0 == 1'b1) ? mux_stage_1[69] : mux_stage_1[68];
	assign mux_stage_0[69] = (sel_0_reg0 == 1'b1) ? mux_stage_1[70] : mux_stage_1[69];
	assign mux_stage_0[70] = (sel_0_reg0 == 1'b1) ? mux_stage_1[71] : mux_stage_1[70];
	assign mux_stage_0[71] = (sel_0_reg0 == 1'b1) ? mux_stage_1[72] : mux_stage_1[71];
	assign mux_stage_0[72] = (sel_0_reg0 == 1'b1) ? mux_stage_1[73] : mux_stage_1[72];
	assign mux_stage_0[73] = (sel_0_reg0 == 1'b1) ? mux_stage_1[74] : mux_stage_1[73];
	assign mux_stage_0[74] = (sel_0_reg0 == 1'b1) ? mux_stage_1[75] : mux_stage_1[74];
	assign mux_stage_0[75] = (sel_0_reg0 == 1'b1) ? mux_stage_1[76] : mux_stage_1[75];
	assign mux_stage_0[76] = (sel_0_reg0 == 1'b1) ? mux_stage_1[77] : mux_stage_1[76];
	assign mux_stage_0[77] = (sel_0_reg0 == 1'b1) ? mux_stage_1[78] : mux_stage_1[77];
	assign mux_stage_0[78] = (sel_0_reg0 == 1'b1) ? mux_stage_1[79] : mux_stage_1[78];
	assign mux_stage_0[79] = (sel_0_reg0 == 1'b1) ? mux_stage_1[80] : mux_stage_1[79];
	assign mux_stage_0[80] = (sel_0_reg0 == 1'b1) ? mux_stage_1[81] : mux_stage_1[80];
	assign mux_stage_0[81] = (sel_0_reg0 == 1'b1) ? mux_stage_1[82] : mux_stage_1[81];
	assign mux_stage_0[82] = (sel_0_reg0 == 1'b1) ? sw_in_83_reg0 : mux_stage_1[82];
	assign mux_stage_0[83] = (sel_0_reg0 == 1'b1) ? sw_in_84_reg0 : sw_in_83_reg0;
`endif
	assign sw_out[83:0] = mux_stage_0[83:0];
endmodule