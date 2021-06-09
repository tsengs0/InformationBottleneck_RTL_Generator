
`timescale 1ns/1ps

module tb_ram_pageAlign_interface (); /* this is automatically generated */
	parameter         QUAN_SIZE = 4;
	parameter CHECK_PARALLELISM = 85;
	parameter         LAYER_NUM = 3;
	parameter ROW_CHUNK_NUM = 9;
	parameter START_PAGE_1_0 = 2; // starting page address of layer 0 of submatrix_1
	parameter START_PAGE_1_1 = 8; // starting page address of layer 1 of submatrix_1
	parameter START_PAGE_1_2 = 1; // starting page address of layer 2 of submatrix_1
	parameter RAM_DEPTH = 27;
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH);
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1);
	parameter shift_factor_0 = 24;
	parameter shift_factor_1 = 39;
	parameter shift_factor_2 = 63;

	// clock
	logic sys_clk;
	initial begin
		sys_clk = 1'b0;
		forever #(5) sys_clk = ~sys_clk;
	end

	// synchronous reset
	logic rstn;
	logic layer_msg_pass_en;
	initial begin
		rstn <= 1'b0;
		repeat(10)@(posedge sys_clk);
		rstn <= 1'b1;
	end

	//logic [QUAN_SIZE-1:0] msgIn_pattern [0:CHECK_PARALLELISM*9*LAYER_NUM-1];
	logic [QUAN_SIZE-1:0] vnBsIn_pattern [CHECK_PARALLELISM*ROW_CHUNK_NUM*LAYER_NUM-1:0];
	initial begin
		$readmemh("/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/layer_decoder_solution/submatrix_1_v2c_bs_in.mem", vnBsIn_pattern);
	end

	integer pageAlign_tb_fd [0:9];
	integer pageAlignIn_tb_fd [0:9];
	initial begin
		pageAlign_tb_fd[1] = $fopen("pageAlign_result_submatrix_1", "w");
		pageAlignIn_tb_fd[1] = $fopen("pageAlign_in_submatrix_1", "w");
	end

	// (*NOTE*) replace reset, clock, others
	logic         [QUAN_SIZE-1:0] msg_out [0:CHECK_PARALLELISM-1];
	logic         [QUAN_SIZE-1:0] vnu_msg_in_0;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_1;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_2;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_3;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_4;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_5;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_6;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_7;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_8;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_9;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_10;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_11;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_12;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_13;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_14;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_15;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_16;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_17;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_18;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_19;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_20;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_21;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_22;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_23;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_24;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_25;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_26;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_27;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_28;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_29;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_30;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_31;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_32;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_33;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_34;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_35;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_36;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_37;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_38;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_39;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_40;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_41;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_42;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_43;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_44;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_45;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_46;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_47;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_48;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_49;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_50;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_51;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_52;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_53;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_54;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_55;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_56;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_57;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_58;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_59;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_60;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_61;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_62;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_63;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_64;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_65;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_66;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_67;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_68;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_69;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_70;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_71;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_72;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_73;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_74;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_75;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_76;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_77;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_78;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_79;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_80;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_81;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_82;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_83;
	logic         [QUAN_SIZE-1:0] vnu_msg_in_84;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_0;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_1;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_2;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_3;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_4;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_5;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_6;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_7;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_8;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_9;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_10;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_11;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_12;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_13;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_14;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_15;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_16;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_17;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_18;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_19;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_20;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_21;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_22;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_23;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_24;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_25;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_26;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_27;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_28;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_29;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_30;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_31;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_32;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_33;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_34;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_35;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_36;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_37;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_38;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_39;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_40;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_41;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_42;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_43;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_44;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_45;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_46;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_47;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_48;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_49;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_50;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_51;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_52;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_53;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_54;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_55;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_56;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_57;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_58;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_59;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_60;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_61;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_62;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_63;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_64;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_65;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_66;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_67;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_68;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_69;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_70;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_71;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_72;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_73;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_74;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_75;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_76;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_77;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_78;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_79;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_80;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_81;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_82;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_83;
	logic         [QUAN_SIZE-1:0] cnu_msg_in_84;
	logic                         sched_cmd;
	logic         [LAYER_NUM-1:0] layer_status;
	wire                          first_row_chunk;
	logic         [LAYER_NUM-1:0] layer_status_reg0;
	logic                         last_row_chunk;

	reg [BITWIDTH_SHIFT_FACTOR-1:0] shift_factor_cur_0;
	reg [BITWIDTH_SHIFT_FACTOR-1:0] shift_factor_cur_1;
	reg [BITWIDTH_SHIFT_FACTOR-1:0] shift_factor_cur_2;

	logic [QUAN_SIZE-1:0] pageAlign_in [0:CHECK_PARALLELISM-1];
	logic [QUAN_SIZE-1:0] pageAlign_out [0:CHECK_PARALLELISM-1];

	logic [6:0] left_sel;
	logic [6:0] right_sel;
	logic [83:0] merge_sel;
	logic [CHECK_PARALLELISM-1:0] bs_in_bit [0:QUAN_SIZE-1];
	initial begin
		bs_in_bit[0] <= {vnBsIn_pattern[84][0],vnBsIn_pattern[83][0],vnBsIn_pattern[82][0],vnBsIn_pattern[81][0],vnBsIn_pattern[80][0],vnBsIn_pattern[79][0],vnBsIn_pattern[78][0],vnBsIn_pattern[77][0],vnBsIn_pattern[76][0],vnBsIn_pattern[75][0],vnBsIn_pattern[74][0],vnBsIn_pattern[73][0],vnBsIn_pattern[72][0],vnBsIn_pattern[71][0],vnBsIn_pattern[70][0],vnBsIn_pattern[69][0],vnBsIn_pattern[68][0],vnBsIn_pattern[67][0],vnBsIn_pattern[66][0],vnBsIn_pattern[65][0],vnBsIn_pattern[64][0],vnBsIn_pattern[63][0],vnBsIn_pattern[62][0],vnBsIn_pattern[61][0],vnBsIn_pattern[60][0],vnBsIn_pattern[59][0],vnBsIn_pattern[58][0],vnBsIn_pattern[57][0],vnBsIn_pattern[56][0],vnBsIn_pattern[55][0],vnBsIn_pattern[54][0],vnBsIn_pattern[53][0],vnBsIn_pattern[52][0],vnBsIn_pattern[51][0],vnBsIn_pattern[50][0],vnBsIn_pattern[49][0],vnBsIn_pattern[48][0],vnBsIn_pattern[47][0],vnBsIn_pattern[46][0],vnBsIn_pattern[45][0],vnBsIn_pattern[44][0],vnBsIn_pattern[43][0],vnBsIn_pattern[42][0],vnBsIn_pattern[41][0],vnBsIn_pattern[40][0],vnBsIn_pattern[39][0],vnBsIn_pattern[38][0],vnBsIn_pattern[37][0],vnBsIn_pattern[36][0],vnBsIn_pattern[35][0],vnBsIn_pattern[34][0],vnBsIn_pattern[33][0],vnBsIn_pattern[32][0],vnBsIn_pattern[31][0],vnBsIn_pattern[30][0],vnBsIn_pattern[29][0],vnBsIn_pattern[28][0],vnBsIn_pattern[27][0],vnBsIn_pattern[26][0],vnBsIn_pattern[25][0],vnBsIn_pattern[24][0],vnBsIn_pattern[23][0],vnBsIn_pattern[22][0],vnBsIn_pattern[21][0],vnBsIn_pattern[20][0],vnBsIn_pattern[19][0],vnBsIn_pattern[18][0],vnBsIn_pattern[17][0],vnBsIn_pattern[16][0],vnBsIn_pattern[15][0],vnBsIn_pattern[14][0],vnBsIn_pattern[13][0],vnBsIn_pattern[12][0],vnBsIn_pattern[11][0],vnBsIn_pattern[10][0],vnBsIn_pattern[9][0],vnBsIn_pattern[8][0],vnBsIn_pattern[7][0],vnBsIn_pattern[6][0],vnBsIn_pattern[5][0],vnBsIn_pattern[4][0],vnBsIn_pattern[3][0],vnBsIn_pattern[2][0],vnBsIn_pattern[1][0],vnBsIn_pattern[0][0]};
		bs_in_bit[1] <= {vnBsIn_pattern[84][1],vnBsIn_pattern[83][1],vnBsIn_pattern[82][1],vnBsIn_pattern[81][1],vnBsIn_pattern[80][1],vnBsIn_pattern[79][1],vnBsIn_pattern[78][1],vnBsIn_pattern[77][1],vnBsIn_pattern[76][1],vnBsIn_pattern[75][1],vnBsIn_pattern[74][1],vnBsIn_pattern[73][1],vnBsIn_pattern[72][1],vnBsIn_pattern[71][1],vnBsIn_pattern[70][1],vnBsIn_pattern[69][1],vnBsIn_pattern[68][1],vnBsIn_pattern[67][1],vnBsIn_pattern[66][1],vnBsIn_pattern[65][1],vnBsIn_pattern[64][1],vnBsIn_pattern[63][1],vnBsIn_pattern[62][1],vnBsIn_pattern[61][1],vnBsIn_pattern[60][1],vnBsIn_pattern[59][1],vnBsIn_pattern[58][1],vnBsIn_pattern[57][1],vnBsIn_pattern[56][1],vnBsIn_pattern[55][1],vnBsIn_pattern[54][1],vnBsIn_pattern[53][1],vnBsIn_pattern[52][1],vnBsIn_pattern[51][1],vnBsIn_pattern[50][1],vnBsIn_pattern[49][1],vnBsIn_pattern[48][1],vnBsIn_pattern[47][1],vnBsIn_pattern[46][1],vnBsIn_pattern[45][1],vnBsIn_pattern[44][1],vnBsIn_pattern[43][1],vnBsIn_pattern[42][1],vnBsIn_pattern[41][1],vnBsIn_pattern[40][1],vnBsIn_pattern[39][1],vnBsIn_pattern[38][1],vnBsIn_pattern[37][1],vnBsIn_pattern[36][1],vnBsIn_pattern[35][1],vnBsIn_pattern[34][1],vnBsIn_pattern[33][1],vnBsIn_pattern[32][1],vnBsIn_pattern[31][1],vnBsIn_pattern[30][1],vnBsIn_pattern[29][1],vnBsIn_pattern[28][1],vnBsIn_pattern[27][1],vnBsIn_pattern[26][1],vnBsIn_pattern[25][1],vnBsIn_pattern[24][1],vnBsIn_pattern[23][1],vnBsIn_pattern[22][1],vnBsIn_pattern[21][1],vnBsIn_pattern[20][1],vnBsIn_pattern[19][1],vnBsIn_pattern[18][1],vnBsIn_pattern[17][1],vnBsIn_pattern[16][1],vnBsIn_pattern[15][1],vnBsIn_pattern[14][1],vnBsIn_pattern[13][1],vnBsIn_pattern[12][1],vnBsIn_pattern[11][1],vnBsIn_pattern[10][1],vnBsIn_pattern[9][1],vnBsIn_pattern[8][1],vnBsIn_pattern[7][1],vnBsIn_pattern[6][1],vnBsIn_pattern[5][1],vnBsIn_pattern[4][1],vnBsIn_pattern[3][1],vnBsIn_pattern[2][1],vnBsIn_pattern[1][1],vnBsIn_pattern[0][1]};
		bs_in_bit[2] <= {vnBsIn_pattern[84][2],vnBsIn_pattern[83][2],vnBsIn_pattern[82][2],vnBsIn_pattern[81][2],vnBsIn_pattern[80][2],vnBsIn_pattern[79][2],vnBsIn_pattern[78][2],vnBsIn_pattern[77][2],vnBsIn_pattern[76][2],vnBsIn_pattern[75][2],vnBsIn_pattern[74][2],vnBsIn_pattern[73][2],vnBsIn_pattern[72][2],vnBsIn_pattern[71][2],vnBsIn_pattern[70][2],vnBsIn_pattern[69][2],vnBsIn_pattern[68][2],vnBsIn_pattern[67][2],vnBsIn_pattern[66][2],vnBsIn_pattern[65][2],vnBsIn_pattern[64][2],vnBsIn_pattern[63][2],vnBsIn_pattern[62][2],vnBsIn_pattern[61][2],vnBsIn_pattern[60][2],vnBsIn_pattern[59][2],vnBsIn_pattern[58][2],vnBsIn_pattern[57][2],vnBsIn_pattern[56][2],vnBsIn_pattern[55][2],vnBsIn_pattern[54][2],vnBsIn_pattern[53][2],vnBsIn_pattern[52][2],vnBsIn_pattern[51][2],vnBsIn_pattern[50][2],vnBsIn_pattern[49][2],vnBsIn_pattern[48][2],vnBsIn_pattern[47][2],vnBsIn_pattern[46][2],vnBsIn_pattern[45][2],vnBsIn_pattern[44][2],vnBsIn_pattern[43][2],vnBsIn_pattern[42][2],vnBsIn_pattern[41][2],vnBsIn_pattern[40][2],vnBsIn_pattern[39][2],vnBsIn_pattern[38][2],vnBsIn_pattern[37][2],vnBsIn_pattern[36][2],vnBsIn_pattern[35][2],vnBsIn_pattern[34][2],vnBsIn_pattern[33][2],vnBsIn_pattern[32][2],vnBsIn_pattern[31][2],vnBsIn_pattern[30][2],vnBsIn_pattern[29][2],vnBsIn_pattern[28][2],vnBsIn_pattern[27][2],vnBsIn_pattern[26][2],vnBsIn_pattern[25][2],vnBsIn_pattern[24][2],vnBsIn_pattern[23][2],vnBsIn_pattern[22][2],vnBsIn_pattern[21][2],vnBsIn_pattern[20][2],vnBsIn_pattern[19][2],vnBsIn_pattern[18][2],vnBsIn_pattern[17][2],vnBsIn_pattern[16][2],vnBsIn_pattern[15][2],vnBsIn_pattern[14][2],vnBsIn_pattern[13][2],vnBsIn_pattern[12][2],vnBsIn_pattern[11][2],vnBsIn_pattern[10][2],vnBsIn_pattern[9][2],vnBsIn_pattern[8][2],vnBsIn_pattern[7][2],vnBsIn_pattern[6][2],vnBsIn_pattern[5][2],vnBsIn_pattern[4][2],vnBsIn_pattern[3][2],vnBsIn_pattern[2][2],vnBsIn_pattern[1][2],vnBsIn_pattern[0][2]};
		bs_in_bit[3] <= {vnBsIn_pattern[84][3],vnBsIn_pattern[83][3],vnBsIn_pattern[82][3],vnBsIn_pattern[81][3],vnBsIn_pattern[80][3],vnBsIn_pattern[79][3],vnBsIn_pattern[78][3],vnBsIn_pattern[77][3],vnBsIn_pattern[76][3],vnBsIn_pattern[75][3],vnBsIn_pattern[74][3],vnBsIn_pattern[73][3],vnBsIn_pattern[72][3],vnBsIn_pattern[71][3],vnBsIn_pattern[70][3],vnBsIn_pattern[69][3],vnBsIn_pattern[68][3],vnBsIn_pattern[67][3],vnBsIn_pattern[66][3],vnBsIn_pattern[65][3],vnBsIn_pattern[64][3],vnBsIn_pattern[63][3],vnBsIn_pattern[62][3],vnBsIn_pattern[61][3],vnBsIn_pattern[60][3],vnBsIn_pattern[59][3],vnBsIn_pattern[58][3],vnBsIn_pattern[57][3],vnBsIn_pattern[56][3],vnBsIn_pattern[55][3],vnBsIn_pattern[54][3],vnBsIn_pattern[53][3],vnBsIn_pattern[52][3],vnBsIn_pattern[51][3],vnBsIn_pattern[50][3],vnBsIn_pattern[49][3],vnBsIn_pattern[48][3],vnBsIn_pattern[47][3],vnBsIn_pattern[46][3],vnBsIn_pattern[45][3],vnBsIn_pattern[44][3],vnBsIn_pattern[43][3],vnBsIn_pattern[42][3],vnBsIn_pattern[41][3],vnBsIn_pattern[40][3],vnBsIn_pattern[39][3],vnBsIn_pattern[38][3],vnBsIn_pattern[37][3],vnBsIn_pattern[36][3],vnBsIn_pattern[35][3],vnBsIn_pattern[34][3],vnBsIn_pattern[33][3],vnBsIn_pattern[32][3],vnBsIn_pattern[31][3],vnBsIn_pattern[30][3],vnBsIn_pattern[29][3],vnBsIn_pattern[28][3],vnBsIn_pattern[27][3],vnBsIn_pattern[26][3],vnBsIn_pattern[25][3],vnBsIn_pattern[24][3],vnBsIn_pattern[23][3],vnBsIn_pattern[22][3],vnBsIn_pattern[21][3],vnBsIn_pattern[20][3],vnBsIn_pattern[19][3],vnBsIn_pattern[18][3],vnBsIn_pattern[17][3],vnBsIn_pattern[16][3],vnBsIn_pattern[15][3],vnBsIn_pattern[14][3],vnBsIn_pattern[13][3],vnBsIn_pattern[12][3],vnBsIn_pattern[11][3],vnBsIn_pattern[10][3],vnBsIn_pattern[9][3],vnBsIn_pattern[8][3],vnBsIn_pattern[7][3],vnBsIn_pattern[6][3],vnBsIn_pattern[5][3],vnBsIn_pattern[4][3],vnBsIn_pattern[3][3],vnBsIn_pattern[2][3],vnBsIn_pattern[1][3],vnBsIn_pattern[0][3]};
	end

	qsn_top_85b inst_qsn_top_85b_0_3 (
		.sw_out_bit0 ({vnu_msg_in_84[0],vnu_msg_in_83[0],vnu_msg_in_82[0],vnu_msg_in_81[0],vnu_msg_in_80[0],vnu_msg_in_79[0],vnu_msg_in_78[0],vnu_msg_in_77[0],vnu_msg_in_76[0],vnu_msg_in_75[0],vnu_msg_in_74[0],vnu_msg_in_73[0],vnu_msg_in_72[0],vnu_msg_in_71[0],vnu_msg_in_70[0],vnu_msg_in_69[0],vnu_msg_in_68[0],vnu_msg_in_67[0],vnu_msg_in_66[0],vnu_msg_in_65[0],vnu_msg_in_64[0],vnu_msg_in_63[0],vnu_msg_in_62[0],vnu_msg_in_61[0],vnu_msg_in_60[0],vnu_msg_in_59[0],vnu_msg_in_58[0],vnu_msg_in_57[0],vnu_msg_in_56[0],vnu_msg_in_55[0],vnu_msg_in_54[0],vnu_msg_in_53[0],vnu_msg_in_52[0],vnu_msg_in_51[0],vnu_msg_in_50[0],vnu_msg_in_49[0],vnu_msg_in_48[0],vnu_msg_in_47[0],vnu_msg_in_46[0],vnu_msg_in_45[0],vnu_msg_in_44[0],vnu_msg_in_43[0],vnu_msg_in_42[0],vnu_msg_in_41[0],vnu_msg_in_40[0],vnu_msg_in_39[0],vnu_msg_in_38[0],vnu_msg_in_37[0],vnu_msg_in_36[0],vnu_msg_in_35[0],vnu_msg_in_34[0],vnu_msg_in_33[0],vnu_msg_in_32[0],vnu_msg_in_31[0],vnu_msg_in_30[0],vnu_msg_in_29[0],vnu_msg_in_28[0],vnu_msg_in_27[0],vnu_msg_in_26[0],vnu_msg_in_25[0],vnu_msg_in_24[0],vnu_msg_in_23[0],vnu_msg_in_22[0],vnu_msg_in_21[0],vnu_msg_in_20[0],vnu_msg_in_19[0],vnu_msg_in_18[0],vnu_msg_in_17[0],vnu_msg_in_16[0],vnu_msg_in_15[0],vnu_msg_in_14[0],vnu_msg_in_13[0],vnu_msg_in_12[0],vnu_msg_in_11[0],vnu_msg_in_10[0],vnu_msg_in_9[0],vnu_msg_in_8[0],vnu_msg_in_7[0],vnu_msg_in_6[0],vnu_msg_in_5[0],vnu_msg_in_4[0],vnu_msg_in_3[0],vnu_msg_in_2[0],vnu_msg_in_1[0],vnu_msg_in_0[0]}),
		.sw_out_bit1 ({vnu_msg_in_84[1],vnu_msg_in_83[1],vnu_msg_in_82[1],vnu_msg_in_81[1],vnu_msg_in_80[1],vnu_msg_in_79[1],vnu_msg_in_78[1],vnu_msg_in_77[1],vnu_msg_in_76[1],vnu_msg_in_75[1],vnu_msg_in_74[1],vnu_msg_in_73[1],vnu_msg_in_72[1],vnu_msg_in_71[1],vnu_msg_in_70[1],vnu_msg_in_69[1],vnu_msg_in_68[1],vnu_msg_in_67[1],vnu_msg_in_66[1],vnu_msg_in_65[1],vnu_msg_in_64[1],vnu_msg_in_63[1],vnu_msg_in_62[1],vnu_msg_in_61[1],vnu_msg_in_60[1],vnu_msg_in_59[1],vnu_msg_in_58[1],vnu_msg_in_57[1],vnu_msg_in_56[1],vnu_msg_in_55[1],vnu_msg_in_54[1],vnu_msg_in_53[1],vnu_msg_in_52[1],vnu_msg_in_51[1],vnu_msg_in_50[1],vnu_msg_in_49[1],vnu_msg_in_48[1],vnu_msg_in_47[1],vnu_msg_in_46[1],vnu_msg_in_45[1],vnu_msg_in_44[1],vnu_msg_in_43[1],vnu_msg_in_42[1],vnu_msg_in_41[1],vnu_msg_in_40[1],vnu_msg_in_39[1],vnu_msg_in_38[1],vnu_msg_in_37[1],vnu_msg_in_36[1],vnu_msg_in_35[1],vnu_msg_in_34[1],vnu_msg_in_33[1],vnu_msg_in_32[1],vnu_msg_in_31[1],vnu_msg_in_30[1],vnu_msg_in_29[1],vnu_msg_in_28[1],vnu_msg_in_27[1],vnu_msg_in_26[1],vnu_msg_in_25[1],vnu_msg_in_24[1],vnu_msg_in_23[1],vnu_msg_in_22[1],vnu_msg_in_21[1],vnu_msg_in_20[1],vnu_msg_in_19[1],vnu_msg_in_18[1],vnu_msg_in_17[1],vnu_msg_in_16[1],vnu_msg_in_15[1],vnu_msg_in_14[1],vnu_msg_in_13[1],vnu_msg_in_12[1],vnu_msg_in_11[1],vnu_msg_in_10[1],vnu_msg_in_9[1],vnu_msg_in_8[1],vnu_msg_in_7[1],vnu_msg_in_6[1],vnu_msg_in_5[1],vnu_msg_in_4[1],vnu_msg_in_3[1],vnu_msg_in_2[1],vnu_msg_in_1[1],vnu_msg_in_0[1]}),
		.sw_out_bit2 ({vnu_msg_in_84[2],vnu_msg_in_83[2],vnu_msg_in_82[2],vnu_msg_in_81[2],vnu_msg_in_80[2],vnu_msg_in_79[2],vnu_msg_in_78[2],vnu_msg_in_77[2],vnu_msg_in_76[2],vnu_msg_in_75[2],vnu_msg_in_74[2],vnu_msg_in_73[2],vnu_msg_in_72[2],vnu_msg_in_71[2],vnu_msg_in_70[2],vnu_msg_in_69[2],vnu_msg_in_68[2],vnu_msg_in_67[2],vnu_msg_in_66[2],vnu_msg_in_65[2],vnu_msg_in_64[2],vnu_msg_in_63[2],vnu_msg_in_62[2],vnu_msg_in_61[2],vnu_msg_in_60[2],vnu_msg_in_59[2],vnu_msg_in_58[2],vnu_msg_in_57[2],vnu_msg_in_56[2],vnu_msg_in_55[2],vnu_msg_in_54[2],vnu_msg_in_53[2],vnu_msg_in_52[2],vnu_msg_in_51[2],vnu_msg_in_50[2],vnu_msg_in_49[2],vnu_msg_in_48[2],vnu_msg_in_47[2],vnu_msg_in_46[2],vnu_msg_in_45[2],vnu_msg_in_44[2],vnu_msg_in_43[2],vnu_msg_in_42[2],vnu_msg_in_41[2],vnu_msg_in_40[2],vnu_msg_in_39[2],vnu_msg_in_38[2],vnu_msg_in_37[2],vnu_msg_in_36[2],vnu_msg_in_35[2],vnu_msg_in_34[2],vnu_msg_in_33[2],vnu_msg_in_32[2],vnu_msg_in_31[2],vnu_msg_in_30[2],vnu_msg_in_29[2],vnu_msg_in_28[2],vnu_msg_in_27[2],vnu_msg_in_26[2],vnu_msg_in_25[2],vnu_msg_in_24[2],vnu_msg_in_23[2],vnu_msg_in_22[2],vnu_msg_in_21[2],vnu_msg_in_20[2],vnu_msg_in_19[2],vnu_msg_in_18[2],vnu_msg_in_17[2],vnu_msg_in_16[2],vnu_msg_in_15[2],vnu_msg_in_14[2],vnu_msg_in_13[2],vnu_msg_in_12[2],vnu_msg_in_11[2],vnu_msg_in_10[2],vnu_msg_in_9[2],vnu_msg_in_8[2],vnu_msg_in_7[2],vnu_msg_in_6[2],vnu_msg_in_5[2],vnu_msg_in_4[2],vnu_msg_in_3[2],vnu_msg_in_2[2],vnu_msg_in_1[2],vnu_msg_in_0[2]}),
		.sw_out_bit3 ({vnu_msg_in_84[3],vnu_msg_in_83[3],vnu_msg_in_82[3],vnu_msg_in_81[3],vnu_msg_in_80[3],vnu_msg_in_79[3],vnu_msg_in_78[3],vnu_msg_in_77[3],vnu_msg_in_76[3],vnu_msg_in_75[3],vnu_msg_in_74[3],vnu_msg_in_73[3],vnu_msg_in_72[3],vnu_msg_in_71[3],vnu_msg_in_70[3],vnu_msg_in_69[3],vnu_msg_in_68[3],vnu_msg_in_67[3],vnu_msg_in_66[3],vnu_msg_in_65[3],vnu_msg_in_64[3],vnu_msg_in_63[3],vnu_msg_in_62[3],vnu_msg_in_61[3],vnu_msg_in_60[3],vnu_msg_in_59[3],vnu_msg_in_58[3],vnu_msg_in_57[3],vnu_msg_in_56[3],vnu_msg_in_55[3],vnu_msg_in_54[3],vnu_msg_in_53[3],vnu_msg_in_52[3],vnu_msg_in_51[3],vnu_msg_in_50[3],vnu_msg_in_49[3],vnu_msg_in_48[3],vnu_msg_in_47[3],vnu_msg_in_46[3],vnu_msg_in_45[3],vnu_msg_in_44[3],vnu_msg_in_43[3],vnu_msg_in_42[3],vnu_msg_in_41[3],vnu_msg_in_40[3],vnu_msg_in_39[3],vnu_msg_in_38[3],vnu_msg_in_37[3],vnu_msg_in_36[3],vnu_msg_in_35[3],vnu_msg_in_34[3],vnu_msg_in_33[3],vnu_msg_in_32[3],vnu_msg_in_31[3],vnu_msg_in_30[3],vnu_msg_in_29[3],vnu_msg_in_28[3],vnu_msg_in_27[3],vnu_msg_in_26[3],vnu_msg_in_25[3],vnu_msg_in_24[3],vnu_msg_in_23[3],vnu_msg_in_22[3],vnu_msg_in_21[3],vnu_msg_in_20[3],vnu_msg_in_19[3],vnu_msg_in_18[3],vnu_msg_in_17[3],vnu_msg_in_16[3],vnu_msg_in_15[3],vnu_msg_in_14[3],vnu_msg_in_13[3],vnu_msg_in_12[3],vnu_msg_in_11[3],vnu_msg_in_10[3],vnu_msg_in_9[3],vnu_msg_in_8[3],vnu_msg_in_7[3],vnu_msg_in_6[3],vnu_msg_in_5[3],vnu_msg_in_4[3],vnu_msg_in_3[3],vnu_msg_in_2[3],vnu_msg_in_1[3],vnu_msg_in_0[3]}),
		.sw_in_bit0  (bs_in_bit[0]),
		.sw_in_bit1  (bs_in_bit[1]),
		.sw_in_bit2  (bs_in_bit[2]),
		.sw_in_bit3  (bs_in_bit[3]),
		.left_sel    (left_sel),
		.right_sel   (right_sel),
		.merge_sel   (merge_sel),
		.sys_clk     (sys_clk),
		.rstn		 (rstn)
	);
	qsn_controller_85b #(
		.PERMUTATION_LENGTH(CHECK_PARALLELISM)
	) inst_qsn_controller_85b (
		.left_sel     (left_sel ),
		.right_sel    (right_sel),
		.merge_sel    (merge_sel),
		.shift_factor (CHECK_PARALLELISM-shift_factor_cur_0), // offset shift factor of submatrix_1
		.rstn         (rstn),
		.sys_clk      (sys_clk)
	);

	ram_pageAlign_interface #(
			.QUAN_SIZE(QUAN_SIZE),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.LAYER_NUM(LAYER_NUM)
		) inst_ram_pageAlign_interface (
			.msg_out_0       (msg_out[0 ]),
			.msg_out_1       (msg_out[1 ]),
			.msg_out_2       (msg_out[2 ]),
			.msg_out_3       (msg_out[3 ]),
			.msg_out_4       (msg_out[4 ]),
			.msg_out_5       (msg_out[5 ]),
			.msg_out_6       (msg_out[6 ]),
			.msg_out_7       (msg_out[7 ]),
			.msg_out_8       (msg_out[8 ]),
			.msg_out_9       (msg_out[9 ]),
			.msg_out_10      (msg_out[10]),
			.msg_out_11      (msg_out[11]),
			.msg_out_12      (msg_out[12]),
			.msg_out_13      (msg_out[13]),
			.msg_out_14      (msg_out[14]),
			.msg_out_15      (msg_out[15]),
			.msg_out_16      (msg_out[16]),
			.msg_out_17      (msg_out[17]),
			.msg_out_18      (msg_out[18]),
			.msg_out_19      (msg_out[19]),
			.msg_out_20      (msg_out[20]),
			.msg_out_21      (msg_out[21]),
			.msg_out_22      (msg_out[22]),
			.msg_out_23      (msg_out[23]),
			.msg_out_24      (msg_out[24]),
			.msg_out_25      (msg_out[25]),
			.msg_out_26      (msg_out[26]),
			.msg_out_27      (msg_out[27]),
			.msg_out_28      (msg_out[28]),
			.msg_out_29      (msg_out[29]),
			.msg_out_30      (msg_out[30]),
			.msg_out_31      (msg_out[31]),
			.msg_out_32      (msg_out[32]),
			.msg_out_33      (msg_out[33]),
			.msg_out_34      (msg_out[34]),
			.msg_out_35      (msg_out[35]),
			.msg_out_36      (msg_out[36]),
			.msg_out_37      (msg_out[37]),
			.msg_out_38      (msg_out[38]),
			.msg_out_39      (msg_out[39]),
			.msg_out_40      (msg_out[40]),
			.msg_out_41      (msg_out[41]),
			.msg_out_42      (msg_out[42]),
			.msg_out_43      (msg_out[43]),
			.msg_out_44      (msg_out[44]),
			.msg_out_45      (msg_out[45]),
			.msg_out_46      (msg_out[46]),
			.msg_out_47      (msg_out[47]),
			.msg_out_48      (msg_out[48]),
			.msg_out_49      (msg_out[49]),
			.msg_out_50      (msg_out[50]),
			.msg_out_51      (msg_out[51]),
			.msg_out_52      (msg_out[52]),
			.msg_out_53      (msg_out[53]),
			.msg_out_54      (msg_out[54]),
			.msg_out_55      (msg_out[55]),
			.msg_out_56      (msg_out[56]),
			.msg_out_57      (msg_out[57]),
			.msg_out_58      (msg_out[58]),
			.msg_out_59      (msg_out[59]),
			.msg_out_60      (msg_out[60]),
			.msg_out_61      (msg_out[61]),
			.msg_out_62      (msg_out[62]),
			.msg_out_63      (msg_out[63]),
			.msg_out_64      (msg_out[64]),
			.msg_out_65      (msg_out[65]),
			.msg_out_66      (msg_out[66]),
			.msg_out_67      (msg_out[67]),
			.msg_out_68      (msg_out[68]),
			.msg_out_69      (msg_out[69]),
			.msg_out_70      (msg_out[70]),
			.msg_out_71      (msg_out[71]),
			.msg_out_72      (msg_out[72]),
			.msg_out_73      (msg_out[73]),
			.msg_out_74      (msg_out[74]),
			.msg_out_75      (msg_out[75]),
			.msg_out_76      (msg_out[76]),
			.msg_out_77      (msg_out[77]),
			.msg_out_78      (msg_out[78]),
			.msg_out_79      (msg_out[79]),
			.msg_out_80      (msg_out[80]),
			.msg_out_81      (msg_out[81]),
			.msg_out_82      (msg_out[82]),
			.msg_out_83      (msg_out[83]),
			.msg_out_84      (msg_out[84]),
			.vnu_msg_in_0    (vnu_msg_in_0 ), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_1    (vnu_msg_in_1 ), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_2    (vnu_msg_in_2 ), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_3    (vnu_msg_in_3 ), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_4    (vnu_msg_in_4 ), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_5    (vnu_msg_in_5 ), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_6    (vnu_msg_in_6 ), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_7    (vnu_msg_in_7 ), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_8    (vnu_msg_in_8 ), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_9    (vnu_msg_in_9 ), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_10   (vnu_msg_in_10), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_11   (vnu_msg_in_11), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_12   (vnu_msg_in_12), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_13   (vnu_msg_in_13), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_14   (vnu_msg_in_14), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_15   (vnu_msg_in_15), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_16   (vnu_msg_in_16), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_17   (vnu_msg_in_17), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_18   (vnu_msg_in_18), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_19   (vnu_msg_in_19), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_20   (vnu_msg_in_20), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_21   (vnu_msg_in_21), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_22   (vnu_msg_in_22), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_23   (vnu_msg_in_23), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_24   (vnu_msg_in_24), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_25   (vnu_msg_in_25), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_26   (vnu_msg_in_26), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_27   (vnu_msg_in_27), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_28   (vnu_msg_in_28), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_29   (vnu_msg_in_29), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_30   (vnu_msg_in_30), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_31   (vnu_msg_in_31), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_32   (vnu_msg_in_32), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_33   (vnu_msg_in_33), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_34   (vnu_msg_in_34), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_35   (vnu_msg_in_35), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_36   (vnu_msg_in_36), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_37   (vnu_msg_in_37), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_38   (vnu_msg_in_38), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_39   (vnu_msg_in_39), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_40   (vnu_msg_in_40), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_41   (vnu_msg_in_41), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_42   (vnu_msg_in_42), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_43   (vnu_msg_in_43), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_44   (vnu_msg_in_44), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_45   (vnu_msg_in_45), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_46   (vnu_msg_in_46), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_47   (vnu_msg_in_47), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_48   (vnu_msg_in_48), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_49   (vnu_msg_in_49), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_50   (vnu_msg_in_50), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_51   (vnu_msg_in_51), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_52   (vnu_msg_in_52), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_53   (vnu_msg_in_53), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_54   (vnu_msg_in_54), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_55   (vnu_msg_in_55), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_56   (vnu_msg_in_56), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_57   (vnu_msg_in_57), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_58   (vnu_msg_in_58), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_59   (vnu_msg_in_59), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_60   (vnu_msg_in_60), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_61   (vnu_msg_in_61), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_62   (vnu_msg_in_62), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_63   (vnu_msg_in_63), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_64   (vnu_msg_in_64), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_65   (vnu_msg_in_65), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_66   (vnu_msg_in_66), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_67   (vnu_msg_in_67), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_68   (vnu_msg_in_68), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_69   (vnu_msg_in_69), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_70   (vnu_msg_in_70), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_71   (vnu_msg_in_71), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_72   (vnu_msg_in_72), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_73   (vnu_msg_in_73), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_74   (vnu_msg_in_74), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_75   (vnu_msg_in_75), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_76   (vnu_msg_in_76), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_77   (vnu_msg_in_77), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_78   (vnu_msg_in_78), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_79   (vnu_msg_in_79), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_80   (vnu_msg_in_80), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_81   (vnu_msg_in_81), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_82   (vnu_msg_in_82), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_83   (vnu_msg_in_83), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.vnu_msg_in_84   (vnu_msg_in_84), // additional increment for identifying the circularly page-aligned msg from 0th row chunk
			.cnu_msg_in_0    (cnu_msg_in_0),
			.cnu_msg_in_1    (cnu_msg_in_1),
			.cnu_msg_in_2    (cnu_msg_in_2),
			.cnu_msg_in_3    (cnu_msg_in_3),
			.cnu_msg_in_4    (cnu_msg_in_4),
			.cnu_msg_in_5    (cnu_msg_in_5),
			.cnu_msg_in_6    (cnu_msg_in_6),
			.cnu_msg_in_7    (cnu_msg_in_7),
			.cnu_msg_in_8    (cnu_msg_in_8),
			.cnu_msg_in_9    (cnu_msg_in_9),
			.cnu_msg_in_10   (cnu_msg_in_10),
			.cnu_msg_in_11   (cnu_msg_in_11),
			.cnu_msg_in_12   (cnu_msg_in_12),
			.cnu_msg_in_13   (cnu_msg_in_13),
			.cnu_msg_in_14   (cnu_msg_in_14),
			.cnu_msg_in_15   (cnu_msg_in_15),
			.cnu_msg_in_16   (cnu_msg_in_16),
			.cnu_msg_in_17   (cnu_msg_in_17),
			.cnu_msg_in_18   (cnu_msg_in_18),
			.cnu_msg_in_19   (cnu_msg_in_19),
			.cnu_msg_in_20   (cnu_msg_in_20),
			.cnu_msg_in_21   (cnu_msg_in_21),
			.cnu_msg_in_22   (cnu_msg_in_22),
			.cnu_msg_in_23   (cnu_msg_in_23),
			.cnu_msg_in_24   (cnu_msg_in_24),
			.cnu_msg_in_25   (cnu_msg_in_25),
			.cnu_msg_in_26   (cnu_msg_in_26),
			.cnu_msg_in_27   (cnu_msg_in_27),
			.cnu_msg_in_28   (cnu_msg_in_28),
			.cnu_msg_in_29   (cnu_msg_in_29),
			.cnu_msg_in_30   (cnu_msg_in_30),
			.cnu_msg_in_31   (cnu_msg_in_31),
			.cnu_msg_in_32   (cnu_msg_in_32),
			.cnu_msg_in_33   (cnu_msg_in_33),
			.cnu_msg_in_34   (cnu_msg_in_34),
			.cnu_msg_in_35   (cnu_msg_in_35),
			.cnu_msg_in_36   (cnu_msg_in_36),
			.cnu_msg_in_37   (cnu_msg_in_37),
			.cnu_msg_in_38   (cnu_msg_in_38),
			.cnu_msg_in_39   (cnu_msg_in_39),
			.cnu_msg_in_40   (cnu_msg_in_40),
			.cnu_msg_in_41   (cnu_msg_in_41),
			.cnu_msg_in_42   (cnu_msg_in_42),
			.cnu_msg_in_43   (cnu_msg_in_43),
			.cnu_msg_in_44   (cnu_msg_in_44),
			.cnu_msg_in_45   (cnu_msg_in_45),
			.cnu_msg_in_46   (cnu_msg_in_46),
			.cnu_msg_in_47   (cnu_msg_in_47),
			.cnu_msg_in_48   (cnu_msg_in_48),
			.cnu_msg_in_49   (cnu_msg_in_49),
			.cnu_msg_in_50   (cnu_msg_in_50),
			.cnu_msg_in_51   (cnu_msg_in_51),
			.cnu_msg_in_52   (cnu_msg_in_52),
			.cnu_msg_in_53   (cnu_msg_in_53),
			.cnu_msg_in_54   (cnu_msg_in_54),
			.cnu_msg_in_55   (cnu_msg_in_55),
			.cnu_msg_in_56   (cnu_msg_in_56),
			.cnu_msg_in_57   (cnu_msg_in_57),
			.cnu_msg_in_58   (cnu_msg_in_58),
			.cnu_msg_in_59   (cnu_msg_in_59),
			.cnu_msg_in_60   (cnu_msg_in_60),
			.cnu_msg_in_61   (cnu_msg_in_61),
			.cnu_msg_in_62   (cnu_msg_in_62),
			.cnu_msg_in_63   (cnu_msg_in_63),
			.cnu_msg_in_64   (cnu_msg_in_64),
			.cnu_msg_in_65   (cnu_msg_in_65),
			.cnu_msg_in_66   (cnu_msg_in_66),
			.cnu_msg_in_67   (cnu_msg_in_67),
			.cnu_msg_in_68   (cnu_msg_in_68),
			.cnu_msg_in_69   (cnu_msg_in_69),
			.cnu_msg_in_70   (cnu_msg_in_70),
			.cnu_msg_in_71   (cnu_msg_in_71),
			.cnu_msg_in_72   (cnu_msg_in_72),
			.cnu_msg_in_73   (cnu_msg_in_73),
			.cnu_msg_in_74   (cnu_msg_in_74),
			.cnu_msg_in_75   (cnu_msg_in_75),
			.cnu_msg_in_76   (cnu_msg_in_76),
			.cnu_msg_in_77   (cnu_msg_in_77),
			.cnu_msg_in_78   (cnu_msg_in_78),
			.cnu_msg_in_79   (cnu_msg_in_79),
			.cnu_msg_in_80   (cnu_msg_in_80),
			.cnu_msg_in_81   (cnu_msg_in_81),
			.cnu_msg_in_82   (cnu_msg_in_82),
			.cnu_msg_in_83   (cnu_msg_in_83),
			.cnu_msg_in_84   (cnu_msg_in_84),
			.sched_cmd       (sched_cmd),
			.layer_status    (layer_status_reg0),
			.first_row_chunk (last_row_chunk),
			.sys_clk         (sys_clk),
			.rstn            (rstn)
		);

	task init();
		vnu_msg_in_0    <= {QUAN_SIZE{1'bx}};
		vnu_msg_in_1    <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_0    <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_1    <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_2    <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_3    <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_4    <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_5    <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_6    <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_7    <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_8    <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_9    <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_10   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_11   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_12   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_13   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_14   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_15   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_16   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_17   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_18   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_19   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_20   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_21   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_22   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_23   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_24   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_25   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_26   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_27   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_28   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_29   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_30   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_31   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_32   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_33   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_34   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_35   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_36   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_37   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_38   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_39   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_40   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_41   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_42   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_43   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_44   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_45   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_46   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_47   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_48   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_49   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_50   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_51   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_52   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_53   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_54   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_55   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_56   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_57   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_58   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_59   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_60   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_61   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_62   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_63   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_64   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_65   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_66   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_67   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_68   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_69   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_70   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_71   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_72   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_73   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_74   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_75   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_76   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_77   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_78   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_79   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_80   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_81   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_82   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_83   <= {QUAN_SIZE{1'bx}};
		cnu_msg_in_84   <= {QUAN_SIZE{1'bx}};

		sched_cmd       <= 1'b0;
		layer_status[LAYER_NUM-1:0] <= 1;
		layer_msg_pass_en <= 1'b0;
	endtask

	task drive_bs_in(int iter_start);
		for(int iter = iter_start; iter < iter_start+ROW_CHUNK_NUM+1; iter++) begin
			bs_in_bit[0] <= {vnBsIn_pattern[CHECK_PARALLELISM*iter+84][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+83][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+82][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+81][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+80][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+79][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+78][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+77][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+76][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+75][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+74][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+73][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+72][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+71][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+70][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+69][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+68][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+67][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+66][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+65][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+64][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+63][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+62][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+61][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+60][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+59][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+58][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+57][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+56][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+55][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+54][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+53][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+52][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+51][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+50][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+49][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+48][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+47][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+46][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+45][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+44][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+43][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+42][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+41][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+40][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+39][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+38][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+37][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+36][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+35][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+34][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+33][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+32][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+31][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+30][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+29][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+28][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+27][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+26][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+25][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+24][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+23][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+22][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+21][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+20][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+19][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+18][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+17][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+16][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+15][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+14][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+13][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+12][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+11][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+10][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+9][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+8][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+7][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+6][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+5][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+4][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+3][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+2][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+1][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+0][0]};
			bs_in_bit[1] <= {vnBsIn_pattern[CHECK_PARALLELISM*iter+84][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+83][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+82][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+81][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+80][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+79][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+78][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+77][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+76][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+75][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+74][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+73][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+72][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+71][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+70][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+69][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+68][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+67][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+66][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+65][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+64][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+63][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+62][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+61][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+60][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+59][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+58][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+57][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+56][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+55][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+54][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+53][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+52][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+51][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+50][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+49][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+48][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+47][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+46][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+45][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+44][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+43][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+42][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+41][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+40][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+39][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+38][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+37][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+36][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+35][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+34][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+33][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+32][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+31][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+30][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+29][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+28][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+27][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+26][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+25][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+24][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+23][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+22][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+21][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+20][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+19][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+18][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+17][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+16][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+15][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+14][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+13][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+12][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+11][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+10][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+9][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+8][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+7][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+6][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+5][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+4][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+3][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+2][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+1][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+0][1]}; 
			bs_in_bit[2] <= {vnBsIn_pattern[CHECK_PARALLELISM*iter+84][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+83][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+82][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+81][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+80][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+79][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+78][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+77][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+76][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+75][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+74][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+73][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+72][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+71][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+70][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+69][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+68][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+67][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+66][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+65][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+64][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+63][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+62][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+61][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+60][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+59][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+58][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+57][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+56][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+55][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+54][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+53][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+52][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+51][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+50][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+49][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+48][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+47][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+46][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+45][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+44][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+43][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+42][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+41][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+40][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+39][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+38][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+37][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+36][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+35][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+34][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+33][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+32][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+31][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+30][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+29][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+28][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+27][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+26][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+25][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+24][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+23][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+22][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+21][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+20][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+19][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+18][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+17][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+16][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+15][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+14][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+13][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+12][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+11][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+10][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+9][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+8][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+7][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+6][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+5][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+4][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+3][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+2][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+1][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+0][2]}; 
			bs_in_bit[3] <= {vnBsIn_pattern[CHECK_PARALLELISM*iter+84][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+83][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+82][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+81][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+80][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+79][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+78][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+77][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+76][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+75][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+74][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+73][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+72][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+71][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+70][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+69][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+68][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+67][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+66][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+65][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+64][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+63][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+62][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+61][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+60][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+59][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+58][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+57][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+56][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+55][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+54][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+53][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+52][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+51][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+50][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+49][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+48][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+47][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+46][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+45][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+44][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+43][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+42][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+41][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+40][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+39][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+38][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+37][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+36][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+35][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+34][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+33][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+32][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+31][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+30][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+29][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+28][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+27][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+26][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+25][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+24][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+23][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+22][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+21][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+20][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+19][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+18][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+17][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+16][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+15][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+14][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+13][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+12][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+11][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+10][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+9][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+8][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+7][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+6][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+5][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+4][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+3][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+2][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+1][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+0][3]}; 

			@(posedge sys_clk);
		end
	endtask

	logic [3:0] sys_cnt;
	always @(posedge sys_clk) begin
		if(rstn == 1'b0) sys_cnt <= 0;
		else if(layer_msg_pass_en == 1'b1) begin
			if(sys_cnt == 10) sys_cnt <= 0;
			else sys_cnt[3:0] <= sys_cnt[3:0]+1;
		end
		else if(layer_msg_pass_en <= 1'b0)
			sys_cnt[3:0] <= 0;
	end	

	logic [3:0] intraLayer_status; // just for debugging
	always @(posedge sys_clk) begin
		if(rstn == 1'b0) intraLayer_status <= 0;
		else if(layer_msg_pass_en == 1'b1) begin
			if(intraLayer_status == 8) intraLayer_status <= 0;
			else if(sys_cnt >= 2) intraLayer_status[3:0] <= intraLayer_status[3:0]+1;
			else intraLayer_status[3:0] <= intraLayer_status[3:0];
		end
		else if(layer_msg_pass_en == 1'b0)
			intraLayer_status[3:0] <= 0;
	end

	logic [8:0] row_chunk_cnt;
	always @(posedge sys_clk) begin
		if(rstn == 1'b0) row_chunk_cnt <= 1;
		else if(layer_msg_pass_en == 1'b1) begin
			if(row_chunk_cnt[8] == 1'b1) row_chunk_cnt <= 1;
			else if(sys_cnt >= 2) row_chunk_cnt[8:0] <= {row_chunk_cnt[7:0], 1'b0};
			else row_chunk_cnt[8:0] <= row_chunk_cnt[8:0];
		end
		else if(layer_msg_pass_en == 1'b0)
			row_chunk_cnt <= 1;
	end
	always @(posedge sys_clk) begin
		if(rstn == 1'b0) begin
			layer_status[LAYER_NUM-1:0] <= {{(LAYER_NUM-1){1'b0}}, 1'b1};
			layer_status_reg0[LAYER_NUM-1:0] <= 0;
		end
		else if(layer_msg_pass_en == 1'b1) begin
			if(row_chunk_cnt[8] == 1'b1 && layer_status[LAYER_NUM-1] != 1'b1)
				layer_status[LAYER_NUM-1:0] <= {layer_status[LAYER_NUM-2:0], 1'b0};
			else if(row_chunk_cnt[8] == 1'b1 && layer_status[LAYER_NUM-1] == 1'b1)
				layer_status[LAYER_NUM-1:0] <= {{(LAYER_NUM-1){1'b0}}, 1'b1};
			else 
				layer_status[LAYER_NUM-1:0] <= layer_status[LAYER_NUM-1:0];

			layer_status_reg0[LAYER_NUM-1:0] <= layer_status[LAYER_NUM-1:0];
		end
	end

	/*
	always @(posedge sys_clk) begin
		if(rstn == 1'b0)
			last_row_chunk <= 1'b0;
		else if(layer_msg_pass_en == 1'b1)			
			last_row_chunk <= first_row_chunk;
		else if(layer_msg_pass_en == 1'b0)
			last_row_chunk <= 1'b0;
	end
	*/
	assign last_row_chunk = row_chunk_cnt[8];
	assign first_row_chunk = row_chunk_cnt[8];

	logic [3:0] mem_page_addr [0:9];
	wire last_page_increment_en;
	always @(posedge sys_clk) begin
		if(rstn == 1'b0) 
			mem_page_addr[0] <= START_PAGE_1_0;
		else if(layer_msg_pass_en == 1'b1) begin
			if(layer_status_reg0[0] == 1) begin // page increment pattern within layer 0
				if(last_row_chunk == 1'b1) mem_page_addr[0] <= START_PAGE_1_1; // to move on to beginning of layer 1
				else if(sys_cnt >= 2) begin
					if(row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
						mem_page_addr[0] <= 0; 
					else
						mem_page_addr[0] <= mem_page_addr[0]+1;
				end
				else if(last_page_increment_en == 1'b1) mem_page_addr[0] <= mem_page_addr[0]+1;
			end
			else if(layer_status_reg0[1] == 1) begin // page increment pattern within layer 1
				if(last_row_chunk == 1'b1) mem_page_addr[0] <= START_PAGE_1_2; // to move on to beginning of layer 2
				else if(sys_cnt >= 2) begin
					if(row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1) 
						mem_page_addr[0] <= 0;
					else
						mem_page_addr[0] <= mem_page_addr[0]+1;
				end
				else if(last_page_increment_en == 1'b1) mem_page_addr[0] <= mem_page_addr[0]+1;
			end
			else if(layer_status_reg0[2] == 1) begin // page increment pattern within layer 2
				if(last_row_chunk == 1'b1) mem_page_addr[0] <= START_PAGE_1_0; // to move on to beginning of layer 0
				else if(sys_cnt >= 2) begin
					if(row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_2-1] == 1'b1)
						mem_page_addr[0] <= 0;
					else
						mem_page_addr[0] <= mem_page_addr[0]+1;
				end
				else if(last_page_increment_en == 1'b1) mem_page_addr[0] <= mem_page_addr[0]+1;
			end
		end
	end
	assign last_page_increment_en = row_chunk_cnt[ROW_CHUNK_NUM-1];

	always @(posedge sys_clk) begin
		if(rstn == 1'b0) begin
			shift_factor_cur_2 <= shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
			shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
			shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
		end
		else if(last_row_chunk == 1'b1) begin
			shift_factor_cur_2 <= 0;
			shift_factor_cur_1 <= shift_factor_cur_2[BITWIDTH_SHIFT_FACTOR-1:0];
			shift_factor_cur_0 <= shift_factor_cur_1[BITWIDTH_SHIFT_FACTOR-1:0];
		end
	end

	always @(posedge sys_clk) begin
		if(rstn == 1'b1 && layer_msg_pass_en == 1'b1) begin
			for(int i = 0; i < CHECK_PARALLELISM-1; i++) $fwrite(pageAlign_tb_fd[1], "%h,", $unsigned(msg_out[i]));
			$fwrite(pageAlign_tb_fd[1], "%h\n", $unsigned(msg_out[CHECK_PARALLELISM-1]));
		end
	end
	always @(posedge sys_clk) begin
		if(rstn == 1'b1 && layer_msg_pass_en == 1'b1) begin
			//$fwrite(pageAlignIn_tb_fd[1], "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n",
			$fwrite(pageAlignIn_tb_fd[1], "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h\n",
				$unsigned(vnu_msg_in_0),$unsigned(vnu_msg_in_1),$unsigned(vnu_msg_in_2),$unsigned(vnu_msg_in_3),$unsigned(vnu_msg_in_4),$unsigned(vnu_msg_in_5),$unsigned(vnu_msg_in_6),$unsigned(vnu_msg_in_7),$unsigned(vnu_msg_in_8),$unsigned(vnu_msg_in_9),$unsigned(vnu_msg_in_10),$unsigned(vnu_msg_in_11),$unsigned(vnu_msg_in_12),$unsigned(vnu_msg_in_13),$unsigned(vnu_msg_in_14),$unsigned(vnu_msg_in_15),$unsigned(vnu_msg_in_16),$unsigned(vnu_msg_in_17),$unsigned(vnu_msg_in_18),$unsigned(vnu_msg_in_19),$unsigned(vnu_msg_in_20),$unsigned(vnu_msg_in_21),$unsigned(vnu_msg_in_22),$unsigned(vnu_msg_in_23),$unsigned(vnu_msg_in_24),$unsigned(vnu_msg_in_25),$unsigned(vnu_msg_in_26),$unsigned(vnu_msg_in_27),$unsigned(vnu_msg_in_28),$unsigned(vnu_msg_in_29),$unsigned(vnu_msg_in_30),$unsigned(vnu_msg_in_31),$unsigned(vnu_msg_in_32),$unsigned(vnu_msg_in_33),$unsigned(vnu_msg_in_34),$unsigned(vnu_msg_in_35),$unsigned(vnu_msg_in_36),$unsigned(vnu_msg_in_37),$unsigned(vnu_msg_in_38),$unsigned(vnu_msg_in_39),$unsigned(vnu_msg_in_40),$unsigned(vnu_msg_in_41),$unsigned(vnu_msg_in_42),$unsigned(vnu_msg_in_43),$unsigned(vnu_msg_in_44),$unsigned(vnu_msg_in_45),$unsigned(vnu_msg_in_46),$unsigned(vnu_msg_in_47),$unsigned(vnu_msg_in_48),$unsigned(vnu_msg_in_49),$unsigned(vnu_msg_in_50),$unsigned(vnu_msg_in_51),$unsigned(vnu_msg_in_52),$unsigned(vnu_msg_in_53),$unsigned(vnu_msg_in_54),$unsigned(vnu_msg_in_55),$unsigned(vnu_msg_in_56),$unsigned(vnu_msg_in_57),$unsigned(vnu_msg_in_58),$unsigned(vnu_msg_in_59),$unsigned(vnu_msg_in_60),$unsigned(vnu_msg_in_61),$unsigned(vnu_msg_in_62),$unsigned(vnu_msg_in_63),$unsigned(vnu_msg_in_64),$unsigned(vnu_msg_in_65),$unsigned(vnu_msg_in_66),$unsigned(vnu_msg_in_67),$unsigned(vnu_msg_in_68),$unsigned(vnu_msg_in_69),$unsigned(vnu_msg_in_70),$unsigned(vnu_msg_in_71),$unsigned(vnu_msg_in_72),$unsigned(vnu_msg_in_73),$unsigned(vnu_msg_in_74),$unsigned(vnu_msg_in_75),$unsigned(vnu_msg_in_76),$unsigned(vnu_msg_in_77),$unsigned(vnu_msg_in_78),$unsigned(vnu_msg_in_79),$unsigned(vnu_msg_in_80),$unsigned(vnu_msg_in_81),$unsigned(vnu_msg_in_82),$unsigned(vnu_msg_in_83),$unsigned(vnu_msg_in_84)
			);
		end
	end

	initial begin
		// do something

		init();
		repeat(11)@(posedge sys_clk);
		layer_msg_pass_en <= 1'b1;

		//drive((LAYER_NUM*9));
		for(int layer_id = 0; layer_id < LAYER_NUM; layer_id++) begin
			drive_bs_in(ROW_CHUNK_NUM*layer_id);

			repeat(1)@(posedge sys_clk);
			layer_msg_pass_en <= 1'b0;
			repeat(1)@(posedge sys_clk);
			layer_msg_pass_en <= 1'b1;
		end

		repeat(3)@(posedge sys_clk);
		$fclose(pageAlign_tb_fd[1]);
		$fclose(pageAlignIn_tb_fd[1]);
		$finish;
	end
/*
	// dump wave
	initial begin
		$display("random seed : %0d", $unsigned($get_initial_random_seed()));
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_ram_pageAlign_interface.fsdb");
			$fsdbDumpvars(0, "tb_ram_pageAlign_interface", "+mda", "+functions");
		end
	end
*/
logic [QUAN_SIZE-1:0] bs_in_reg [0:CHECK_PARALLELISM-1];
assign bs_in_reg[0] = {bs_in_bit[3][0], bs_in_bit[2][0], bs_in_bit[1][0], bs_in_bit[0][0]};
assign bs_in_reg[1] = {bs_in_bit[3][1], bs_in_bit[2][1], bs_in_bit[1][1], bs_in_bit[0][1]};
assign bs_in_reg[2] = {bs_in_bit[3][2], bs_in_bit[2][2], bs_in_bit[1][2], bs_in_bit[0][2]};
assign bs_in_reg[3] = {bs_in_bit[3][3], bs_in_bit[2][3], bs_in_bit[1][3], bs_in_bit[0][3]};
assign bs_in_reg[4] = {bs_in_bit[3][4], bs_in_bit[2][4], bs_in_bit[1][4], bs_in_bit[0][4]};
assign bs_in_reg[5] = {bs_in_bit[3][5], bs_in_bit[2][5], bs_in_bit[1][5], bs_in_bit[0][5]};
assign bs_in_reg[6] = {bs_in_bit[3][6], bs_in_bit[2][6], bs_in_bit[1][6], bs_in_bit[0][6]};
assign bs_in_reg[7] = {bs_in_bit[3][7], bs_in_bit[2][7], bs_in_bit[1][7], bs_in_bit[0][7]};
assign bs_in_reg[8] = {bs_in_bit[3][8], bs_in_bit[2][8], bs_in_bit[1][8], bs_in_bit[0][8]};
assign bs_in_reg[9] = {bs_in_bit[3][9], bs_in_bit[2][9], bs_in_bit[1][9], bs_in_bit[0][9]};
assign bs_in_reg[10] = {bs_in_bit[3][10], bs_in_bit[2][10], bs_in_bit[1][10], bs_in_bit[0][10]};
assign bs_in_reg[11] = {bs_in_bit[3][11], bs_in_bit[2][11], bs_in_bit[1][11], bs_in_bit[0][11]};
assign bs_in_reg[12] = {bs_in_bit[3][12], bs_in_bit[2][12], bs_in_bit[1][12], bs_in_bit[0][12]};
assign bs_in_reg[13] = {bs_in_bit[3][13], bs_in_bit[2][13], bs_in_bit[1][13], bs_in_bit[0][13]};
assign bs_in_reg[14] = {bs_in_bit[3][14], bs_in_bit[2][14], bs_in_bit[1][14], bs_in_bit[0][14]};
assign bs_in_reg[15] = {bs_in_bit[3][15], bs_in_bit[2][15], bs_in_bit[1][15], bs_in_bit[0][15]};
assign bs_in_reg[16] = {bs_in_bit[3][16], bs_in_bit[2][16], bs_in_bit[1][16], bs_in_bit[0][16]};
assign bs_in_reg[17] = {bs_in_bit[3][17], bs_in_bit[2][17], bs_in_bit[1][17], bs_in_bit[0][17]};
assign bs_in_reg[18] = {bs_in_bit[3][18], bs_in_bit[2][18], bs_in_bit[1][18], bs_in_bit[0][18]};
assign bs_in_reg[19] = {bs_in_bit[3][19], bs_in_bit[2][19], bs_in_bit[1][19], bs_in_bit[0][19]};
assign bs_in_reg[20] = {bs_in_bit[3][20], bs_in_bit[2][20], bs_in_bit[1][20], bs_in_bit[0][20]};
assign bs_in_reg[21] = {bs_in_bit[3][21], bs_in_bit[2][21], bs_in_bit[1][21], bs_in_bit[0][21]};
assign bs_in_reg[22] = {bs_in_bit[3][22], bs_in_bit[2][22], bs_in_bit[1][22], bs_in_bit[0][22]};
assign bs_in_reg[23] = {bs_in_bit[3][23], bs_in_bit[2][23], bs_in_bit[1][23], bs_in_bit[0][23]};
assign bs_in_reg[24] = {bs_in_bit[3][24], bs_in_bit[2][24], bs_in_bit[1][24], bs_in_bit[0][24]};
assign bs_in_reg[25] = {bs_in_bit[3][25], bs_in_bit[2][25], bs_in_bit[1][25], bs_in_bit[0][25]};
assign bs_in_reg[26] = {bs_in_bit[3][26], bs_in_bit[2][26], bs_in_bit[1][26], bs_in_bit[0][26]};
assign bs_in_reg[27] = {bs_in_bit[3][27], bs_in_bit[2][27], bs_in_bit[1][27], bs_in_bit[0][27]};
assign bs_in_reg[28] = {bs_in_bit[3][28], bs_in_bit[2][28], bs_in_bit[1][28], bs_in_bit[0][28]};
assign bs_in_reg[29] = {bs_in_bit[3][29], bs_in_bit[2][29], bs_in_bit[1][29], bs_in_bit[0][29]};
assign bs_in_reg[30] = {bs_in_bit[3][30], bs_in_bit[2][30], bs_in_bit[1][30], bs_in_bit[0][30]};
assign bs_in_reg[31] = {bs_in_bit[3][31], bs_in_bit[2][31], bs_in_bit[1][31], bs_in_bit[0][31]};
assign bs_in_reg[32] = {bs_in_bit[3][32], bs_in_bit[2][32], bs_in_bit[1][32], bs_in_bit[0][32]};
assign bs_in_reg[33] = {bs_in_bit[3][33], bs_in_bit[2][33], bs_in_bit[1][33], bs_in_bit[0][33]};
assign bs_in_reg[34] = {bs_in_bit[3][34], bs_in_bit[2][34], bs_in_bit[1][34], bs_in_bit[0][34]};
assign bs_in_reg[35] = {bs_in_bit[3][35], bs_in_bit[2][35], bs_in_bit[1][35], bs_in_bit[0][35]};
assign bs_in_reg[36] = {bs_in_bit[3][36], bs_in_bit[2][36], bs_in_bit[1][36], bs_in_bit[0][36]};
assign bs_in_reg[37] = {bs_in_bit[3][37], bs_in_bit[2][37], bs_in_bit[1][37], bs_in_bit[0][37]};
assign bs_in_reg[38] = {bs_in_bit[3][38], bs_in_bit[2][38], bs_in_bit[1][38], bs_in_bit[0][38]};
assign bs_in_reg[39] = {bs_in_bit[3][39], bs_in_bit[2][39], bs_in_bit[1][39], bs_in_bit[0][39]};
assign bs_in_reg[40] = {bs_in_bit[3][40], bs_in_bit[2][40], bs_in_bit[1][40], bs_in_bit[0][40]};
assign bs_in_reg[41] = {bs_in_bit[3][41], bs_in_bit[2][41], bs_in_bit[1][41], bs_in_bit[0][41]};
assign bs_in_reg[42] = {bs_in_bit[3][42], bs_in_bit[2][42], bs_in_bit[1][42], bs_in_bit[0][42]};
assign bs_in_reg[43] = {bs_in_bit[3][43], bs_in_bit[2][43], bs_in_bit[1][43], bs_in_bit[0][43]};
assign bs_in_reg[44] = {bs_in_bit[3][44], bs_in_bit[2][44], bs_in_bit[1][44], bs_in_bit[0][44]};
assign bs_in_reg[45] = {bs_in_bit[3][45], bs_in_bit[2][45], bs_in_bit[1][45], bs_in_bit[0][45]};
assign bs_in_reg[46] = {bs_in_bit[3][46], bs_in_bit[2][46], bs_in_bit[1][46], bs_in_bit[0][46]};
assign bs_in_reg[47] = {bs_in_bit[3][47], bs_in_bit[2][47], bs_in_bit[1][47], bs_in_bit[0][47]};
assign bs_in_reg[48] = {bs_in_bit[3][48], bs_in_bit[2][48], bs_in_bit[1][48], bs_in_bit[0][48]};
assign bs_in_reg[49] = {bs_in_bit[3][49], bs_in_bit[2][49], bs_in_bit[1][49], bs_in_bit[0][49]};
assign bs_in_reg[50] = {bs_in_bit[3][50], bs_in_bit[2][50], bs_in_bit[1][50], bs_in_bit[0][50]};
assign bs_in_reg[51] = {bs_in_bit[3][51], bs_in_bit[2][51], bs_in_bit[1][51], bs_in_bit[0][51]};
assign bs_in_reg[52] = {bs_in_bit[3][52], bs_in_bit[2][52], bs_in_bit[1][52], bs_in_bit[0][52]};
assign bs_in_reg[53] = {bs_in_bit[3][53], bs_in_bit[2][53], bs_in_bit[1][53], bs_in_bit[0][53]};
assign bs_in_reg[54] = {bs_in_bit[3][54], bs_in_bit[2][54], bs_in_bit[1][54], bs_in_bit[0][54]};
assign bs_in_reg[55] = {bs_in_bit[3][55], bs_in_bit[2][55], bs_in_bit[1][55], bs_in_bit[0][55]};
assign bs_in_reg[56] = {bs_in_bit[3][56], bs_in_bit[2][56], bs_in_bit[1][56], bs_in_bit[0][56]};
assign bs_in_reg[57] = {bs_in_bit[3][57], bs_in_bit[2][57], bs_in_bit[1][57], bs_in_bit[0][57]};
assign bs_in_reg[58] = {bs_in_bit[3][58], bs_in_bit[2][58], bs_in_bit[1][58], bs_in_bit[0][58]};
assign bs_in_reg[59] = {bs_in_bit[3][59], bs_in_bit[2][59], bs_in_bit[1][59], bs_in_bit[0][59]};
assign bs_in_reg[60] = {bs_in_bit[3][60], bs_in_bit[2][60], bs_in_bit[1][60], bs_in_bit[0][60]};
assign bs_in_reg[61] = {bs_in_bit[3][61], bs_in_bit[2][61], bs_in_bit[1][61], bs_in_bit[0][61]};
assign bs_in_reg[62] = {bs_in_bit[3][62], bs_in_bit[2][62], bs_in_bit[1][62], bs_in_bit[0][62]};
assign bs_in_reg[63] = {bs_in_bit[3][63], bs_in_bit[2][63], bs_in_bit[1][63], bs_in_bit[0][63]};
assign bs_in_reg[64] = {bs_in_bit[3][64], bs_in_bit[2][64], bs_in_bit[1][64], bs_in_bit[0][64]};
assign bs_in_reg[65] = {bs_in_bit[3][65], bs_in_bit[2][65], bs_in_bit[1][65], bs_in_bit[0][65]};
assign bs_in_reg[66] = {bs_in_bit[3][66], bs_in_bit[2][66], bs_in_bit[1][66], bs_in_bit[0][66]};
assign bs_in_reg[67] = {bs_in_bit[3][67], bs_in_bit[2][67], bs_in_bit[1][67], bs_in_bit[0][67]};
assign bs_in_reg[68] = {bs_in_bit[3][68], bs_in_bit[2][68], bs_in_bit[1][68], bs_in_bit[0][68]};
assign bs_in_reg[69] = {bs_in_bit[3][69], bs_in_bit[2][69], bs_in_bit[1][69], bs_in_bit[0][69]};
assign bs_in_reg[70] = {bs_in_bit[3][70], bs_in_bit[2][70], bs_in_bit[1][70], bs_in_bit[0][70]};
assign bs_in_reg[71] = {bs_in_bit[3][71], bs_in_bit[2][71], bs_in_bit[1][71], bs_in_bit[0][71]};
assign bs_in_reg[72] = {bs_in_bit[3][72], bs_in_bit[2][72], bs_in_bit[1][72], bs_in_bit[0][72]};
assign bs_in_reg[73] = {bs_in_bit[3][73], bs_in_bit[2][73], bs_in_bit[1][73], bs_in_bit[0][73]};
assign bs_in_reg[74] = {bs_in_bit[3][74], bs_in_bit[2][74], bs_in_bit[1][74], bs_in_bit[0][74]};
assign bs_in_reg[75] = {bs_in_bit[3][75], bs_in_bit[2][75], bs_in_bit[1][75], bs_in_bit[0][75]};
assign bs_in_reg[76] = {bs_in_bit[3][76], bs_in_bit[2][76], bs_in_bit[1][76], bs_in_bit[0][76]};
assign bs_in_reg[77] = {bs_in_bit[3][77], bs_in_bit[2][77], bs_in_bit[1][77], bs_in_bit[0][77]};
assign bs_in_reg[78] = {bs_in_bit[3][78], bs_in_bit[2][78], bs_in_bit[1][78], bs_in_bit[0][78]};
assign bs_in_reg[79] = {bs_in_bit[3][79], bs_in_bit[2][79], bs_in_bit[1][79], bs_in_bit[0][79]};
assign bs_in_reg[80] = {bs_in_bit[3][80], bs_in_bit[2][80], bs_in_bit[1][80], bs_in_bit[0][80]};
assign bs_in_reg[81] = {bs_in_bit[3][81], bs_in_bit[2][81], bs_in_bit[1][81], bs_in_bit[0][81]};
assign bs_in_reg[82] = {bs_in_bit[3][82], bs_in_bit[2][82], bs_in_bit[1][82], bs_in_bit[0][82]};
assign bs_in_reg[83] = {bs_in_bit[3][83], bs_in_bit[2][83], bs_in_bit[1][83], bs_in_bit[0][83]};
assign bs_in_reg[84] = {bs_in_bit[3][84], bs_in_bit[2][84], bs_in_bit[1][84], bs_in_bit[0][84]};

assign pageAlign_in[0 ] = inst_ram_pageAlign_interface.vnu_msg_in_0 ;
assign pageAlign_in[1 ] = inst_ram_pageAlign_interface.vnu_msg_in_1 ;
assign pageAlign_in[2 ] = inst_ram_pageAlign_interface.vnu_msg_in_2 ;
assign pageAlign_in[3 ] = inst_ram_pageAlign_interface.vnu_msg_in_3 ;
assign pageAlign_in[4 ] = inst_ram_pageAlign_interface.vnu_msg_in_4 ;
assign pageAlign_in[5 ] = inst_ram_pageAlign_interface.vnu_msg_in_5 ;
assign pageAlign_in[6 ] = inst_ram_pageAlign_interface.vnu_msg_in_6 ;
assign pageAlign_in[7 ] = inst_ram_pageAlign_interface.vnu_msg_in_7 ;
assign pageAlign_in[8 ] = inst_ram_pageAlign_interface.vnu_msg_in_8 ;
assign pageAlign_in[9 ] = inst_ram_pageAlign_interface.vnu_msg_in_9 ;
assign pageAlign_in[10] = inst_ram_pageAlign_interface.vnu_msg_in_10;
assign pageAlign_in[11] = inst_ram_pageAlign_interface.vnu_msg_in_11;
assign pageAlign_in[12] = inst_ram_pageAlign_interface.vnu_msg_in_12;
assign pageAlign_in[13] = inst_ram_pageAlign_interface.vnu_msg_in_13;
assign pageAlign_in[14] = inst_ram_pageAlign_interface.vnu_msg_in_14;
assign pageAlign_in[15] = inst_ram_pageAlign_interface.vnu_msg_in_15;
assign pageAlign_in[16] = inst_ram_pageAlign_interface.vnu_msg_in_16;
assign pageAlign_in[17] = inst_ram_pageAlign_interface.vnu_msg_in_17;
assign pageAlign_in[18] = inst_ram_pageAlign_interface.vnu_msg_in_18;
assign pageAlign_in[19] = inst_ram_pageAlign_interface.vnu_msg_in_19;
assign pageAlign_in[20] = inst_ram_pageAlign_interface.vnu_msg_in_20;
assign pageAlign_in[21] = inst_ram_pageAlign_interface.vnu_msg_in_21;
assign pageAlign_in[22] = inst_ram_pageAlign_interface.vnu_msg_in_22;
assign pageAlign_in[23] = inst_ram_pageAlign_interface.vnu_msg_in_23;
assign pageAlign_in[24] = inst_ram_pageAlign_interface.vnu_msg_in_24;
assign pageAlign_in[25] = inst_ram_pageAlign_interface.vnu_msg_in_25;
assign pageAlign_in[26] = inst_ram_pageAlign_interface.vnu_msg_in_26;
assign pageAlign_in[27] = inst_ram_pageAlign_interface.vnu_msg_in_27;
assign pageAlign_in[28] = inst_ram_pageAlign_interface.vnu_msg_in_28;
assign pageAlign_in[29] = inst_ram_pageAlign_interface.vnu_msg_in_29;
assign pageAlign_in[30] = inst_ram_pageAlign_interface.vnu_msg_in_30;
assign pageAlign_in[31] = inst_ram_pageAlign_interface.vnu_msg_in_31;
assign pageAlign_in[32] = inst_ram_pageAlign_interface.vnu_msg_in_32;
assign pageAlign_in[33] = inst_ram_pageAlign_interface.vnu_msg_in_33;
assign pageAlign_in[34] = inst_ram_pageAlign_interface.vnu_msg_in_34;
assign pageAlign_in[35] = inst_ram_pageAlign_interface.vnu_msg_in_35;
assign pageAlign_in[36] = inst_ram_pageAlign_interface.vnu_msg_in_36;
assign pageAlign_in[37] = inst_ram_pageAlign_interface.vnu_msg_in_37;
assign pageAlign_in[38] = inst_ram_pageAlign_interface.vnu_msg_in_38;
assign pageAlign_in[39] = inst_ram_pageAlign_interface.vnu_msg_in_39;
assign pageAlign_in[40] = inst_ram_pageAlign_interface.vnu_msg_in_40;
assign pageAlign_in[41] = inst_ram_pageAlign_interface.vnu_msg_in_41;
assign pageAlign_in[42] = inst_ram_pageAlign_interface.vnu_msg_in_42;
assign pageAlign_in[43] = inst_ram_pageAlign_interface.vnu_msg_in_43;
assign pageAlign_in[44] = inst_ram_pageAlign_interface.vnu_msg_in_44;
assign pageAlign_in[45] = inst_ram_pageAlign_interface.vnu_msg_in_45;
assign pageAlign_in[46] = inst_ram_pageAlign_interface.vnu_msg_in_46;
assign pageAlign_in[47] = inst_ram_pageAlign_interface.vnu_msg_in_47;
assign pageAlign_in[48] = inst_ram_pageAlign_interface.vnu_msg_in_48;
assign pageAlign_in[49] = inst_ram_pageAlign_interface.vnu_msg_in_49;
assign pageAlign_in[50] = inst_ram_pageAlign_interface.vnu_msg_in_50;
assign pageAlign_in[51] = inst_ram_pageAlign_interface.vnu_msg_in_51;
assign pageAlign_in[52] = inst_ram_pageAlign_interface.vnu_msg_in_52;
assign pageAlign_in[53] = inst_ram_pageAlign_interface.vnu_msg_in_53;
assign pageAlign_in[54] = inst_ram_pageAlign_interface.vnu_msg_in_54;
assign pageAlign_in[55] = inst_ram_pageAlign_interface.vnu_msg_in_55;
assign pageAlign_in[56] = inst_ram_pageAlign_interface.vnu_msg_in_56;
assign pageAlign_in[57] = inst_ram_pageAlign_interface.vnu_msg_in_57;
assign pageAlign_in[58] = inst_ram_pageAlign_interface.vnu_msg_in_58;
assign pageAlign_in[59] = inst_ram_pageAlign_interface.vnu_msg_in_59;
assign pageAlign_in[60] = inst_ram_pageAlign_interface.vnu_msg_in_60;
assign pageAlign_in[61] = inst_ram_pageAlign_interface.vnu_msg_in_61;
assign pageAlign_in[62] = inst_ram_pageAlign_interface.vnu_msg_in_62;
assign pageAlign_in[63] = inst_ram_pageAlign_interface.vnu_msg_in_63;
assign pageAlign_in[64] = inst_ram_pageAlign_interface.vnu_msg_in_64;
assign pageAlign_in[65] = inst_ram_pageAlign_interface.vnu_msg_in_65;
assign pageAlign_in[66] = inst_ram_pageAlign_interface.vnu_msg_in_66;
assign pageAlign_in[67] = inst_ram_pageAlign_interface.vnu_msg_in_67;
assign pageAlign_in[68] = inst_ram_pageAlign_interface.vnu_msg_in_68;
assign pageAlign_in[69] = inst_ram_pageAlign_interface.vnu_msg_in_69;
assign pageAlign_in[70] = inst_ram_pageAlign_interface.vnu_msg_in_70;
assign pageAlign_in[71] = inst_ram_pageAlign_interface.vnu_msg_in_71;
assign pageAlign_in[72] = inst_ram_pageAlign_interface.vnu_msg_in_72;
assign pageAlign_in[73] = inst_ram_pageAlign_interface.vnu_msg_in_73;
assign pageAlign_in[74] = inst_ram_pageAlign_interface.vnu_msg_in_74;
assign pageAlign_in[75] = inst_ram_pageAlign_interface.vnu_msg_in_75;
assign pageAlign_in[76] = inst_ram_pageAlign_interface.vnu_msg_in_76;
assign pageAlign_in[77] = inst_ram_pageAlign_interface.vnu_msg_in_77;
assign pageAlign_in[78] = inst_ram_pageAlign_interface.vnu_msg_in_78;
assign pageAlign_in[79] = inst_ram_pageAlign_interface.vnu_msg_in_79;
assign pageAlign_in[80] = inst_ram_pageAlign_interface.vnu_msg_in_80;
assign pageAlign_in[81] = inst_ram_pageAlign_interface.vnu_msg_in_81;
assign pageAlign_in[82] = inst_ram_pageAlign_interface.vnu_msg_in_82;
assign pageAlign_in[83] = inst_ram_pageAlign_interface.vnu_msg_in_83;
assign pageAlign_in[84] = inst_ram_pageAlign_interface.vnu_msg_in_84;

assign pageAlign_out[0] = msg_out[0];
assign pageAlign_out[1] = msg_out[1];
assign pageAlign_out[2] = msg_out[2];
assign pageAlign_out[3] = msg_out[3];
assign pageAlign_out[4] = msg_out[4];
assign pageAlign_out[5] = msg_out[5];
assign pageAlign_out[6] = msg_out[6];
assign pageAlign_out[7] = msg_out[7];
assign pageAlign_out[8] = msg_out[8];
assign pageAlign_out[9] = msg_out[9];
assign pageAlign_out[10] = msg_out[10];
assign pageAlign_out[11] = msg_out[11];
assign pageAlign_out[12] = msg_out[12];
assign pageAlign_out[13] = msg_out[13];
assign pageAlign_out[14] = msg_out[14];
assign pageAlign_out[15] = msg_out[15];
assign pageAlign_out[16] = msg_out[16];
assign pageAlign_out[17] = msg_out[17];
assign pageAlign_out[18] = msg_out[18];
assign pageAlign_out[19] = msg_out[19];
assign pageAlign_out[20] = msg_out[20];
assign pageAlign_out[21] = msg_out[21];
assign pageAlign_out[22] = msg_out[22];
assign pageAlign_out[23] = msg_out[23];
assign pageAlign_out[24] = msg_out[24];
assign pageAlign_out[25] = msg_out[25];
assign pageAlign_out[26] = msg_out[26];
assign pageAlign_out[27] = msg_out[27];
assign pageAlign_out[28] = msg_out[28];
assign pageAlign_out[29] = msg_out[29];
assign pageAlign_out[30] = msg_out[30];
assign pageAlign_out[31] = msg_out[31];
assign pageAlign_out[32] = msg_out[32];
assign pageAlign_out[33] = msg_out[33];
assign pageAlign_out[34] = msg_out[34];
assign pageAlign_out[35] = msg_out[35];
assign pageAlign_out[36] = msg_out[36];
assign pageAlign_out[37] = msg_out[37];
assign pageAlign_out[38] = msg_out[38];
assign pageAlign_out[39] = msg_out[39];
assign pageAlign_out[40] = msg_out[40];
assign pageAlign_out[41] = msg_out[41];
assign pageAlign_out[42] = msg_out[42];
assign pageAlign_out[43] = msg_out[43];
assign pageAlign_out[44] = msg_out[44];
assign pageAlign_out[45] = msg_out[45];
assign pageAlign_out[46] = msg_out[46];
assign pageAlign_out[47] = msg_out[47];
assign pageAlign_out[48] = msg_out[48];
assign pageAlign_out[49] = msg_out[49];
assign pageAlign_out[50] = msg_out[50];
assign pageAlign_out[51] = msg_out[51];
assign pageAlign_out[52] = msg_out[52];
assign pageAlign_out[53] = msg_out[53];
assign pageAlign_out[54] = msg_out[54];
assign pageAlign_out[55] = msg_out[55];
assign pageAlign_out[56] = msg_out[56];
assign pageAlign_out[57] = msg_out[57];
assign pageAlign_out[58] = msg_out[58];
assign pageAlign_out[59] = msg_out[59];
assign pageAlign_out[60] = msg_out[60];
assign pageAlign_out[61] = msg_out[61];
assign pageAlign_out[62] = msg_out[62];
assign pageAlign_out[63] = msg_out[63];
assign pageAlign_out[64] = msg_out[64];
assign pageAlign_out[65] = msg_out[65];
assign pageAlign_out[66] = msg_out[66];
assign pageAlign_out[67] = msg_out[67];
assign pageAlign_out[68] = msg_out[68];
assign pageAlign_out[69] = msg_out[69];
assign pageAlign_out[70] = msg_out[70];
assign pageAlign_out[71] = msg_out[71];
assign pageAlign_out[72] = msg_out[72];
assign pageAlign_out[73] = msg_out[73];
assign pageAlign_out[74] = msg_out[74];
assign pageAlign_out[75] = msg_out[75];
assign pageAlign_out[76] = msg_out[76];
assign pageAlign_out[77] = msg_out[77];
assign pageAlign_out[78] = msg_out[78];
assign pageAlign_out[79] = msg_out[79];
assign pageAlign_out[80] = msg_out[80];
assign pageAlign_out[81] = msg_out[81];
assign pageAlign_out[82] = msg_out[82];
assign pageAlign_out[83] = msg_out[83];
assign pageAlign_out[84] = msg_out[84];
endmodule

/*
	task drive(int iter);
		for(int it = 0; it < iter; it++) begin
			/*
			cnu_msg_in_0    <= '0;
			cnu_msg_in_1    <= '0;
			cnu_msg_in_2    <= '0;
			cnu_msg_in_3    <= '0;
			cnu_msg_in_4    <= '0;
			cnu_msg_in_5    <= '0;
			cnu_msg_in_6    <= '0;
			cnu_msg_in_7    <= '0;
			cnu_msg_in_8    <= '0;
			cnu_msg_in_9    <= '0;
			cnu_msg_in_10   <= '0;
			cnu_msg_in_11   <= '0;
			cnu_msg_in_12   <= '0;
			cnu_msg_in_13   <= '0;
			cnu_msg_in_14   <= '0;
			cnu_msg_in_15   <= '0;
			cnu_msg_in_16   <= '0;
			cnu_msg_in_17   <= '0;
			cnu_msg_in_18   <= '0;
			cnu_msg_in_19   <= '0;
			cnu_msg_in_20   <= '0;
			cnu_msg_in_21   <= '0;
			cnu_msg_in_22   <= '0;
			cnu_msg_in_23   <= '0;
			cnu_msg_in_24   <= '0;
			cnu_msg_in_25   <= '0;
			cnu_msg_in_26   <= '0;
			cnu_msg_in_27   <= '0;
			cnu_msg_in_28   <= '0;
			cnu_msg_in_29   <= '0;
			cnu_msg_in_30   <= '0;
			cnu_msg_in_31   <= '0;
			cnu_msg_in_32   <= '0;
			cnu_msg_in_33   <= '0;
			cnu_msg_in_34   <= '0;
			cnu_msg_in_35   <= '0;
			cnu_msg_in_36   <= '0;
			cnu_msg_in_37   <= '0;
			cnu_msg_in_38   <= '0;
			cnu_msg_in_39   <= '0;
			cnu_msg_in_40   <= '0;
			cnu_msg_in_41   <= '0;
			cnu_msg_in_42   <= '0;
			cnu_msg_in_43   <= '0;
			cnu_msg_in_44   <= '0;
			cnu_msg_in_45   <= '0;
			cnu_msg_in_46   <= '0;
			cnu_msg_in_47   <= '0;
			cnu_msg_in_48   <= '0;
			cnu_msg_in_49   <= '0;
			cnu_msg_in_50   <= '0;
			cnu_msg_in_51   <= '0;
			cnu_msg_in_52   <= '0;
			cnu_msg_in_53   <= '0;
			cnu_msg_in_54   <= '0;
			cnu_msg_in_55   <= '0;
			cnu_msg_in_56   <= '0;
			cnu_msg_in_57   <= '0;
			cnu_msg_in_58   <= '0;
			cnu_msg_in_59   <= '0;
			cnu_msg_in_60   <= '0;
			cnu_msg_in_61   <= '0;
			cnu_msg_in_62   <= '0;
			cnu_msg_in_63   <= '0;
			cnu_msg_in_64   <= '0;
			cnu_msg_in_65   <= '0;
			cnu_msg_in_66   <= '0;
			cnu_msg_in_67   <= '0;
			cnu_msg_in_68   <= '0;
			cnu_msg_in_69   <= '0;
			cnu_msg_in_70   <= '0;
			cnu_msg_in_71   <= '0;
			cnu_msg_in_72   <= '0;
			cnu_msg_in_73   <= '0;
			cnu_msg_in_74   <= '0;
			cnu_msg_in_75   <= '0;
			cnu_msg_in_76   <= '0;
			cnu_msg_in_77   <= '0;
			cnu_msg_in_78   <= '0;
			cnu_msg_in_79   <= '0;
			cnu_msg_in_80   <= '0;
			cnu_msg_in_81   <= '0;
			cnu_msg_in_82   <= '0;
			cnu_msg_in_83   <= '0;
			cnu_msg_in_84   <= '0;
			
			sched_cmd       <= 1'b0; // 1'b0: align_in from variable msg; 1'b1: align_in from check msg

			@(posedge sys_clk);
		end
	endtask
*/
