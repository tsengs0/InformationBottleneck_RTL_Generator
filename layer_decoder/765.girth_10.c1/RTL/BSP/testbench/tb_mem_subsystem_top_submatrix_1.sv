module tb_mem_subsystem_top_submatrix_1 (); /* this is automatically generated */
	parameter         QUAN_SIZE = 4;
	parameter CHECK_PARALLELISM = 85;
	parameter         LAYER_NUM = 3;
	parameter     ROW_CHUNK_NUM = 9;
	parameter START_PAGE_1_0 = 2; // starting page address of layer 0 of submatrix_1
	parameter START_PAGE_1_1 = 8; // starting page address of layer 1 of submatrix_1
	parameter START_PAGE_1_2 = 1; // starting page address of layer 2 of submatrix_1
	parameter RAM_DEPTH = 1024;
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH);
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1);
	parameter shift_factor_0 = CHECK_PARALLELISM-24;
	parameter shift_factor_1 = CHECK_PARALLELISM-39;
	parameter shift_factor_2 = CHECK_PARALLELISM-63;
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH)

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

	integer pageAlign_tb_fd;
	integer pageAlignIn_tb_fd;
	initial begin
		pageAlign_tb_fd = $fopen("pageAlign_result_submatrix_1", "w");
		pageAlignIn_tb_fd = $fopen("pageAlign_in_submatrix_1", "w");
	end

	// (*NOTE*) replace reset, clock, others
	logic         [QUAN_SIZE-1:0] mem_to_cnu [0:CHECK_PARALLELISM-1];
	logic         [QUAN_SIZE-1:0] mem_to_vnu [0:CHECK_PARALLELISM-1];
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
	logic                         cnu_sched_cmd;
	logic                         vnu_sched_cmd;
	logic         [LAYER_NUM-1:0] cnu_layer_status;
	logic         [LAYER_NUM-1:0] vnu_layer_status;
	wire                          cnu_first_row_chunk;
	wire                          vnu_first_row_chunk;
	logic         [LAYER_NUM-1:0] cnu_layer_status_reg0;
	logic         [LAYER_NUM-1:0] vnu_layer_status_reg0;
	logic                         cnu_last_row_chunk;
	logic                         vnu_last_row_chunk;

	reg [BITWIDTH_SHIFT_FACTOR-1:0] cnu_shift_factor_cur_0;
	reg [BITWIDTH_SHIFT_FACTOR-1:0] cnu_shift_factor_cur_1;
	reg [BITWIDTH_SHIFT_FACTOR-1:0] cnu_shift_factor_cur_2;
	reg [BITWIDTH_SHIFT_FACTOR-1:0] vnu_shift_factor_cur_0;
	reg [BITWIDTH_SHIFT_FACTOR-1:0] vnu_shift_factor_cur_1;
	reg [BITWIDTH_SHIFT_FACTOR-1:0] vnu_shift_factor_cur_2;

	logic [QUAN_SIZE-1:0] cnu_pageAlign_in [0:CHECK_PARALLELISM-1];
	logic [QUAN_SIZE-1:0] cnu_pageAlign_out [0:CHECK_PARALLELISM-1];
	logic [QUAN_SIZE-1:0] vnu_pageAlign_in [0:CHECK_PARALLELISM-1];
	logic [QUAN_SIZE-1:0] vnu_pageAlign_out [0:CHECK_PARALLELISM-1];

	logic [6:0]  cnu_left_sel;
	logic [6:0]  cnu_right_sel;
	logic [83:0] cnu_merge_sel;
	logic [6:0]  vnu_left_sel;
	logic [6:0]  vnu_right_sel;
	logic [83:0] vnu_merge_sel;
	logic [CHECK_PARALLELISM-1:0] cnu_bs_in_bit [0:QUAN_SIZE-1];
	logic [CHECK_PARALLELISM-1:0] vnu_bs_in_bit [0:QUAN_SIZE-1];
	initial begin
		// For ease of verification, cnu and vnu are using identical set of test patterns
		cnu_bs_in_bit[0] <= {vnBsIn_pattern[84][0],vnBsIn_pattern[83][0],vnBsIn_pattern[82][0],vnBsIn_pattern[81][0],vnBsIn_pattern[80][0],vnBsIn_pattern[79][0],vnBsIn_pattern[78][0],vnBsIn_pattern[77][0],vnBsIn_pattern[76][0],vnBsIn_pattern[75][0],vnBsIn_pattern[74][0],vnBsIn_pattern[73][0],vnBsIn_pattern[72][0],vnBsIn_pattern[71][0],vnBsIn_pattern[70][0],vnBsIn_pattern[69][0],vnBsIn_pattern[68][0],vnBsIn_pattern[67][0],vnBsIn_pattern[66][0],vnBsIn_pattern[65][0],vnBsIn_pattern[64][0],vnBsIn_pattern[63][0],vnBsIn_pattern[62][0],vnBsIn_pattern[61][0],vnBsIn_pattern[60][0],vnBsIn_pattern[59][0],vnBsIn_pattern[58][0],vnBsIn_pattern[57][0],vnBsIn_pattern[56][0],vnBsIn_pattern[55][0],vnBsIn_pattern[54][0],vnBsIn_pattern[53][0],vnBsIn_pattern[52][0],vnBsIn_pattern[51][0],vnBsIn_pattern[50][0],vnBsIn_pattern[49][0],vnBsIn_pattern[48][0],vnBsIn_pattern[47][0],vnBsIn_pattern[46][0],vnBsIn_pattern[45][0],vnBsIn_pattern[44][0],vnBsIn_pattern[43][0],vnBsIn_pattern[42][0],vnBsIn_pattern[41][0],vnBsIn_pattern[40][0],vnBsIn_pattern[39][0],vnBsIn_pattern[38][0],vnBsIn_pattern[37][0],vnBsIn_pattern[36][0],vnBsIn_pattern[35][0],vnBsIn_pattern[34][0],vnBsIn_pattern[33][0],vnBsIn_pattern[32][0],vnBsIn_pattern[31][0],vnBsIn_pattern[30][0],vnBsIn_pattern[29][0],vnBsIn_pattern[28][0],vnBsIn_pattern[27][0],vnBsIn_pattern[26][0],vnBsIn_pattern[25][0],vnBsIn_pattern[24][0],vnBsIn_pattern[23][0],vnBsIn_pattern[22][0],vnBsIn_pattern[21][0],vnBsIn_pattern[20][0],vnBsIn_pattern[19][0],vnBsIn_pattern[18][0],vnBsIn_pattern[17][0],vnBsIn_pattern[16][0],vnBsIn_pattern[15][0],vnBsIn_pattern[14][0],vnBsIn_pattern[13][0],vnBsIn_pattern[12][0],vnBsIn_pattern[11][0],vnBsIn_pattern[10][0],vnBsIn_pattern[9][0],vnBsIn_pattern[8][0],vnBsIn_pattern[7][0],vnBsIn_pattern[6][0],vnBsIn_pattern[5][0],vnBsIn_pattern[4][0],vnBsIn_pattern[3][0],vnBsIn_pattern[2][0],vnBsIn_pattern[1][0],vnBsIn_pattern[0][0]};
		cnu_bs_in_bit[1] <= {vnBsIn_pattern[84][1],vnBsIn_pattern[83][1],vnBsIn_pattern[82][1],vnBsIn_pattern[81][1],vnBsIn_pattern[80][1],vnBsIn_pattern[79][1],vnBsIn_pattern[78][1],vnBsIn_pattern[77][1],vnBsIn_pattern[76][1],vnBsIn_pattern[75][1],vnBsIn_pattern[74][1],vnBsIn_pattern[73][1],vnBsIn_pattern[72][1],vnBsIn_pattern[71][1],vnBsIn_pattern[70][1],vnBsIn_pattern[69][1],vnBsIn_pattern[68][1],vnBsIn_pattern[67][1],vnBsIn_pattern[66][1],vnBsIn_pattern[65][1],vnBsIn_pattern[64][1],vnBsIn_pattern[63][1],vnBsIn_pattern[62][1],vnBsIn_pattern[61][1],vnBsIn_pattern[60][1],vnBsIn_pattern[59][1],vnBsIn_pattern[58][1],vnBsIn_pattern[57][1],vnBsIn_pattern[56][1],vnBsIn_pattern[55][1],vnBsIn_pattern[54][1],vnBsIn_pattern[53][1],vnBsIn_pattern[52][1],vnBsIn_pattern[51][1],vnBsIn_pattern[50][1],vnBsIn_pattern[49][1],vnBsIn_pattern[48][1],vnBsIn_pattern[47][1],vnBsIn_pattern[46][1],vnBsIn_pattern[45][1],vnBsIn_pattern[44][1],vnBsIn_pattern[43][1],vnBsIn_pattern[42][1],vnBsIn_pattern[41][1],vnBsIn_pattern[40][1],vnBsIn_pattern[39][1],vnBsIn_pattern[38][1],vnBsIn_pattern[37][1],vnBsIn_pattern[36][1],vnBsIn_pattern[35][1],vnBsIn_pattern[34][1],vnBsIn_pattern[33][1],vnBsIn_pattern[32][1],vnBsIn_pattern[31][1],vnBsIn_pattern[30][1],vnBsIn_pattern[29][1],vnBsIn_pattern[28][1],vnBsIn_pattern[27][1],vnBsIn_pattern[26][1],vnBsIn_pattern[25][1],vnBsIn_pattern[24][1],vnBsIn_pattern[23][1],vnBsIn_pattern[22][1],vnBsIn_pattern[21][1],vnBsIn_pattern[20][1],vnBsIn_pattern[19][1],vnBsIn_pattern[18][1],vnBsIn_pattern[17][1],vnBsIn_pattern[16][1],vnBsIn_pattern[15][1],vnBsIn_pattern[14][1],vnBsIn_pattern[13][1],vnBsIn_pattern[12][1],vnBsIn_pattern[11][1],vnBsIn_pattern[10][1],vnBsIn_pattern[9][1],vnBsIn_pattern[8][1],vnBsIn_pattern[7][1],vnBsIn_pattern[6][1],vnBsIn_pattern[5][1],vnBsIn_pattern[4][1],vnBsIn_pattern[3][1],vnBsIn_pattern[2][1],vnBsIn_pattern[1][1],vnBsIn_pattern[0][1]};
		cnu_bs_in_bit[2] <= {vnBsIn_pattern[84][2],vnBsIn_pattern[83][2],vnBsIn_pattern[82][2],vnBsIn_pattern[81][2],vnBsIn_pattern[80][2],vnBsIn_pattern[79][2],vnBsIn_pattern[78][2],vnBsIn_pattern[77][2],vnBsIn_pattern[76][2],vnBsIn_pattern[75][2],vnBsIn_pattern[74][2],vnBsIn_pattern[73][2],vnBsIn_pattern[72][2],vnBsIn_pattern[71][2],vnBsIn_pattern[70][2],vnBsIn_pattern[69][2],vnBsIn_pattern[68][2],vnBsIn_pattern[67][2],vnBsIn_pattern[66][2],vnBsIn_pattern[65][2],vnBsIn_pattern[64][2],vnBsIn_pattern[63][2],vnBsIn_pattern[62][2],vnBsIn_pattern[61][2],vnBsIn_pattern[60][2],vnBsIn_pattern[59][2],vnBsIn_pattern[58][2],vnBsIn_pattern[57][2],vnBsIn_pattern[56][2],vnBsIn_pattern[55][2],vnBsIn_pattern[54][2],vnBsIn_pattern[53][2],vnBsIn_pattern[52][2],vnBsIn_pattern[51][2],vnBsIn_pattern[50][2],vnBsIn_pattern[49][2],vnBsIn_pattern[48][2],vnBsIn_pattern[47][2],vnBsIn_pattern[46][2],vnBsIn_pattern[45][2],vnBsIn_pattern[44][2],vnBsIn_pattern[43][2],vnBsIn_pattern[42][2],vnBsIn_pattern[41][2],vnBsIn_pattern[40][2],vnBsIn_pattern[39][2],vnBsIn_pattern[38][2],vnBsIn_pattern[37][2],vnBsIn_pattern[36][2],vnBsIn_pattern[35][2],vnBsIn_pattern[34][2],vnBsIn_pattern[33][2],vnBsIn_pattern[32][2],vnBsIn_pattern[31][2],vnBsIn_pattern[30][2],vnBsIn_pattern[29][2],vnBsIn_pattern[28][2],vnBsIn_pattern[27][2],vnBsIn_pattern[26][2],vnBsIn_pattern[25][2],vnBsIn_pattern[24][2],vnBsIn_pattern[23][2],vnBsIn_pattern[22][2],vnBsIn_pattern[21][2],vnBsIn_pattern[20][2],vnBsIn_pattern[19][2],vnBsIn_pattern[18][2],vnBsIn_pattern[17][2],vnBsIn_pattern[16][2],vnBsIn_pattern[15][2],vnBsIn_pattern[14][2],vnBsIn_pattern[13][2],vnBsIn_pattern[12][2],vnBsIn_pattern[11][2],vnBsIn_pattern[10][2],vnBsIn_pattern[9][2],vnBsIn_pattern[8][2],vnBsIn_pattern[7][2],vnBsIn_pattern[6][2],vnBsIn_pattern[5][2],vnBsIn_pattern[4][2],vnBsIn_pattern[3][2],vnBsIn_pattern[2][2],vnBsIn_pattern[1][2],vnBsIn_pattern[0][2]};
		cnu_bs_in_bit[3] <= {vnBsIn_pattern[84][3],vnBsIn_pattern[83][3],vnBsIn_pattern[82][3],vnBsIn_pattern[81][3],vnBsIn_pattern[80][3],vnBsIn_pattern[79][3],vnBsIn_pattern[78][3],vnBsIn_pattern[77][3],vnBsIn_pattern[76][3],vnBsIn_pattern[75][3],vnBsIn_pattern[74][3],vnBsIn_pattern[73][3],vnBsIn_pattern[72][3],vnBsIn_pattern[71][3],vnBsIn_pattern[70][3],vnBsIn_pattern[69][3],vnBsIn_pattern[68][3],vnBsIn_pattern[67][3],vnBsIn_pattern[66][3],vnBsIn_pattern[65][3],vnBsIn_pattern[64][3],vnBsIn_pattern[63][3],vnBsIn_pattern[62][3],vnBsIn_pattern[61][3],vnBsIn_pattern[60][3],vnBsIn_pattern[59][3],vnBsIn_pattern[58][3],vnBsIn_pattern[57][3],vnBsIn_pattern[56][3],vnBsIn_pattern[55][3],vnBsIn_pattern[54][3],vnBsIn_pattern[53][3],vnBsIn_pattern[52][3],vnBsIn_pattern[51][3],vnBsIn_pattern[50][3],vnBsIn_pattern[49][3],vnBsIn_pattern[48][3],vnBsIn_pattern[47][3],vnBsIn_pattern[46][3],vnBsIn_pattern[45][3],vnBsIn_pattern[44][3],vnBsIn_pattern[43][3],vnBsIn_pattern[42][3],vnBsIn_pattern[41][3],vnBsIn_pattern[40][3],vnBsIn_pattern[39][3],vnBsIn_pattern[38][3],vnBsIn_pattern[37][3],vnBsIn_pattern[36][3],vnBsIn_pattern[35][3],vnBsIn_pattern[34][3],vnBsIn_pattern[33][3],vnBsIn_pattern[32][3],vnBsIn_pattern[31][3],vnBsIn_pattern[30][3],vnBsIn_pattern[29][3],vnBsIn_pattern[28][3],vnBsIn_pattern[27][3],vnBsIn_pattern[26][3],vnBsIn_pattern[25][3],vnBsIn_pattern[24][3],vnBsIn_pattern[23][3],vnBsIn_pattern[22][3],vnBsIn_pattern[21][3],vnBsIn_pattern[20][3],vnBsIn_pattern[19][3],vnBsIn_pattern[18][3],vnBsIn_pattern[17][3],vnBsIn_pattern[16][3],vnBsIn_pattern[15][3],vnBsIn_pattern[14][3],vnBsIn_pattern[13][3],vnBsIn_pattern[12][3],vnBsIn_pattern[11][3],vnBsIn_pattern[10][3],vnBsIn_pattern[9][3],vnBsIn_pattern[8][3],vnBsIn_pattern[7][3],vnBsIn_pattern[6][3],vnBsIn_pattern[5][3],vnBsIn_pattern[4][3],vnBsIn_pattern[3][3],vnBsIn_pattern[2][3],vnBsIn_pattern[1][3],vnBsIn_pattern[0][3]};
		
		vnu_bs_in_bit[0] <= {vnBsIn_pattern[84][0],vnBsIn_pattern[83][0],vnBsIn_pattern[82][0],vnBsIn_pattern[81][0],vnBsIn_pattern[80][0],vnBsIn_pattern[79][0],vnBsIn_pattern[78][0],vnBsIn_pattern[77][0],vnBsIn_pattern[76][0],vnBsIn_pattern[75][0],vnBsIn_pattern[74][0],vnBsIn_pattern[73][0],vnBsIn_pattern[72][0],vnBsIn_pattern[71][0],vnBsIn_pattern[70][0],vnBsIn_pattern[69][0],vnBsIn_pattern[68][0],vnBsIn_pattern[67][0],vnBsIn_pattern[66][0],vnBsIn_pattern[65][0],vnBsIn_pattern[64][0],vnBsIn_pattern[63][0],vnBsIn_pattern[62][0],vnBsIn_pattern[61][0],vnBsIn_pattern[60][0],vnBsIn_pattern[59][0],vnBsIn_pattern[58][0],vnBsIn_pattern[57][0],vnBsIn_pattern[56][0],vnBsIn_pattern[55][0],vnBsIn_pattern[54][0],vnBsIn_pattern[53][0],vnBsIn_pattern[52][0],vnBsIn_pattern[51][0],vnBsIn_pattern[50][0],vnBsIn_pattern[49][0],vnBsIn_pattern[48][0],vnBsIn_pattern[47][0],vnBsIn_pattern[46][0],vnBsIn_pattern[45][0],vnBsIn_pattern[44][0],vnBsIn_pattern[43][0],vnBsIn_pattern[42][0],vnBsIn_pattern[41][0],vnBsIn_pattern[40][0],vnBsIn_pattern[39][0],vnBsIn_pattern[38][0],vnBsIn_pattern[37][0],vnBsIn_pattern[36][0],vnBsIn_pattern[35][0],vnBsIn_pattern[34][0],vnBsIn_pattern[33][0],vnBsIn_pattern[32][0],vnBsIn_pattern[31][0],vnBsIn_pattern[30][0],vnBsIn_pattern[29][0],vnBsIn_pattern[28][0],vnBsIn_pattern[27][0],vnBsIn_pattern[26][0],vnBsIn_pattern[25][0],vnBsIn_pattern[24][0],vnBsIn_pattern[23][0],vnBsIn_pattern[22][0],vnBsIn_pattern[21][0],vnBsIn_pattern[20][0],vnBsIn_pattern[19][0],vnBsIn_pattern[18][0],vnBsIn_pattern[17][0],vnBsIn_pattern[16][0],vnBsIn_pattern[15][0],vnBsIn_pattern[14][0],vnBsIn_pattern[13][0],vnBsIn_pattern[12][0],vnBsIn_pattern[11][0],vnBsIn_pattern[10][0],vnBsIn_pattern[9][0],vnBsIn_pattern[8][0],vnBsIn_pattern[7][0],vnBsIn_pattern[6][0],vnBsIn_pattern[5][0],vnBsIn_pattern[4][0],vnBsIn_pattern[3][0],vnBsIn_pattern[2][0],vnBsIn_pattern[1][0],vnBsIn_pattern[0][0]};
		vnu_bs_in_bit[1] <= {vnBsIn_pattern[84][1],vnBsIn_pattern[83][1],vnBsIn_pattern[82][1],vnBsIn_pattern[81][1],vnBsIn_pattern[80][1],vnBsIn_pattern[79][1],vnBsIn_pattern[78][1],vnBsIn_pattern[77][1],vnBsIn_pattern[76][1],vnBsIn_pattern[75][1],vnBsIn_pattern[74][1],vnBsIn_pattern[73][1],vnBsIn_pattern[72][1],vnBsIn_pattern[71][1],vnBsIn_pattern[70][1],vnBsIn_pattern[69][1],vnBsIn_pattern[68][1],vnBsIn_pattern[67][1],vnBsIn_pattern[66][1],vnBsIn_pattern[65][1],vnBsIn_pattern[64][1],vnBsIn_pattern[63][1],vnBsIn_pattern[62][1],vnBsIn_pattern[61][1],vnBsIn_pattern[60][1],vnBsIn_pattern[59][1],vnBsIn_pattern[58][1],vnBsIn_pattern[57][1],vnBsIn_pattern[56][1],vnBsIn_pattern[55][1],vnBsIn_pattern[54][1],vnBsIn_pattern[53][1],vnBsIn_pattern[52][1],vnBsIn_pattern[51][1],vnBsIn_pattern[50][1],vnBsIn_pattern[49][1],vnBsIn_pattern[48][1],vnBsIn_pattern[47][1],vnBsIn_pattern[46][1],vnBsIn_pattern[45][1],vnBsIn_pattern[44][1],vnBsIn_pattern[43][1],vnBsIn_pattern[42][1],vnBsIn_pattern[41][1],vnBsIn_pattern[40][1],vnBsIn_pattern[39][1],vnBsIn_pattern[38][1],vnBsIn_pattern[37][1],vnBsIn_pattern[36][1],vnBsIn_pattern[35][1],vnBsIn_pattern[34][1],vnBsIn_pattern[33][1],vnBsIn_pattern[32][1],vnBsIn_pattern[31][1],vnBsIn_pattern[30][1],vnBsIn_pattern[29][1],vnBsIn_pattern[28][1],vnBsIn_pattern[27][1],vnBsIn_pattern[26][1],vnBsIn_pattern[25][1],vnBsIn_pattern[24][1],vnBsIn_pattern[23][1],vnBsIn_pattern[22][1],vnBsIn_pattern[21][1],vnBsIn_pattern[20][1],vnBsIn_pattern[19][1],vnBsIn_pattern[18][1],vnBsIn_pattern[17][1],vnBsIn_pattern[16][1],vnBsIn_pattern[15][1],vnBsIn_pattern[14][1],vnBsIn_pattern[13][1],vnBsIn_pattern[12][1],vnBsIn_pattern[11][1],vnBsIn_pattern[10][1],vnBsIn_pattern[9][1],vnBsIn_pattern[8][1],vnBsIn_pattern[7][1],vnBsIn_pattern[6][1],vnBsIn_pattern[5][1],vnBsIn_pattern[4][1],vnBsIn_pattern[3][1],vnBsIn_pattern[2][1],vnBsIn_pattern[1][1],vnBsIn_pattern[0][1]};
		vnu_bs_in_bit[2] <= {vnBsIn_pattern[84][2],vnBsIn_pattern[83][2],vnBsIn_pattern[82][2],vnBsIn_pattern[81][2],vnBsIn_pattern[80][2],vnBsIn_pattern[79][2],vnBsIn_pattern[78][2],vnBsIn_pattern[77][2],vnBsIn_pattern[76][2],vnBsIn_pattern[75][2],vnBsIn_pattern[74][2],vnBsIn_pattern[73][2],vnBsIn_pattern[72][2],vnBsIn_pattern[71][2],vnBsIn_pattern[70][2],vnBsIn_pattern[69][2],vnBsIn_pattern[68][2],vnBsIn_pattern[67][2],vnBsIn_pattern[66][2],vnBsIn_pattern[65][2],vnBsIn_pattern[64][2],vnBsIn_pattern[63][2],vnBsIn_pattern[62][2],vnBsIn_pattern[61][2],vnBsIn_pattern[60][2],vnBsIn_pattern[59][2],vnBsIn_pattern[58][2],vnBsIn_pattern[57][2],vnBsIn_pattern[56][2],vnBsIn_pattern[55][2],vnBsIn_pattern[54][2],vnBsIn_pattern[53][2],vnBsIn_pattern[52][2],vnBsIn_pattern[51][2],vnBsIn_pattern[50][2],vnBsIn_pattern[49][2],vnBsIn_pattern[48][2],vnBsIn_pattern[47][2],vnBsIn_pattern[46][2],vnBsIn_pattern[45][2],vnBsIn_pattern[44][2],vnBsIn_pattern[43][2],vnBsIn_pattern[42][2],vnBsIn_pattern[41][2],vnBsIn_pattern[40][2],vnBsIn_pattern[39][2],vnBsIn_pattern[38][2],vnBsIn_pattern[37][2],vnBsIn_pattern[36][2],vnBsIn_pattern[35][2],vnBsIn_pattern[34][2],vnBsIn_pattern[33][2],vnBsIn_pattern[32][2],vnBsIn_pattern[31][2],vnBsIn_pattern[30][2],vnBsIn_pattern[29][2],vnBsIn_pattern[28][2],vnBsIn_pattern[27][2],vnBsIn_pattern[26][2],vnBsIn_pattern[25][2],vnBsIn_pattern[24][2],vnBsIn_pattern[23][2],vnBsIn_pattern[22][2],vnBsIn_pattern[21][2],vnBsIn_pattern[20][2],vnBsIn_pattern[19][2],vnBsIn_pattern[18][2],vnBsIn_pattern[17][2],vnBsIn_pattern[16][2],vnBsIn_pattern[15][2],vnBsIn_pattern[14][2],vnBsIn_pattern[13][2],vnBsIn_pattern[12][2],vnBsIn_pattern[11][2],vnBsIn_pattern[10][2],vnBsIn_pattern[9][2],vnBsIn_pattern[8][2],vnBsIn_pattern[7][2],vnBsIn_pattern[6][2],vnBsIn_pattern[5][2],vnBsIn_pattern[4][2],vnBsIn_pattern[3][2],vnBsIn_pattern[2][2],vnBsIn_pattern[1][2],vnBsIn_pattern[0][2]};
		vnu_bs_in_bit[3] <= {vnBsIn_pattern[84][3],vnBsIn_pattern[83][3],vnBsIn_pattern[82][3],vnBsIn_pattern[81][3],vnBsIn_pattern[80][3],vnBsIn_pattern[79][3],vnBsIn_pattern[78][3],vnBsIn_pattern[77][3],vnBsIn_pattern[76][3],vnBsIn_pattern[75][3],vnBsIn_pattern[74][3],vnBsIn_pattern[73][3],vnBsIn_pattern[72][3],vnBsIn_pattern[71][3],vnBsIn_pattern[70][3],vnBsIn_pattern[69][3],vnBsIn_pattern[68][3],vnBsIn_pattern[67][3],vnBsIn_pattern[66][3],vnBsIn_pattern[65][3],vnBsIn_pattern[64][3],vnBsIn_pattern[63][3],vnBsIn_pattern[62][3],vnBsIn_pattern[61][3],vnBsIn_pattern[60][3],vnBsIn_pattern[59][3],vnBsIn_pattern[58][3],vnBsIn_pattern[57][3],vnBsIn_pattern[56][3],vnBsIn_pattern[55][3],vnBsIn_pattern[54][3],vnBsIn_pattern[53][3],vnBsIn_pattern[52][3],vnBsIn_pattern[51][3],vnBsIn_pattern[50][3],vnBsIn_pattern[49][3],vnBsIn_pattern[48][3],vnBsIn_pattern[47][3],vnBsIn_pattern[46][3],vnBsIn_pattern[45][3],vnBsIn_pattern[44][3],vnBsIn_pattern[43][3],vnBsIn_pattern[42][3],vnBsIn_pattern[41][3],vnBsIn_pattern[40][3],vnBsIn_pattern[39][3],vnBsIn_pattern[38][3],vnBsIn_pattern[37][3],vnBsIn_pattern[36][3],vnBsIn_pattern[35][3],vnBsIn_pattern[34][3],vnBsIn_pattern[33][3],vnBsIn_pattern[32][3],vnBsIn_pattern[31][3],vnBsIn_pattern[30][3],vnBsIn_pattern[29][3],vnBsIn_pattern[28][3],vnBsIn_pattern[27][3],vnBsIn_pattern[26][3],vnBsIn_pattern[25][3],vnBsIn_pattern[24][3],vnBsIn_pattern[23][3],vnBsIn_pattern[22][3],vnBsIn_pattern[21][3],vnBsIn_pattern[20][3],vnBsIn_pattern[19][3],vnBsIn_pattern[18][3],vnBsIn_pattern[17][3],vnBsIn_pattern[16][3],vnBsIn_pattern[15][3],vnBsIn_pattern[14][3],vnBsIn_pattern[13][3],vnBsIn_pattern[12][3],vnBsIn_pattern[11][3],vnBsIn_pattern[10][3],vnBsIn_pattern[9][3],vnBsIn_pattern[8][3],vnBsIn_pattern[7][3],vnBsIn_pattern[6][3],vnBsIn_pattern[5][3],vnBsIn_pattern[4][3],vnBsIn_pattern[3][3],vnBsIn_pattern[2][3],vnBsIn_pattern[1][3],vnBsIn_pattern[0][3]};
	end
/*----------------------------------------------*/	
// Circular shifter of check nodes 
qsn_top_85b cnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({cnu_msg_in_84[0],cnu_msg_in_83[0],cnu_msg_in_82[0],cnu_msg_in_81[0],cnu_msg_in_80[0],cnu_msg_in_79[0],cnu_msg_in_78[0],cnu_msg_in_77[0],cnu_msg_in_76[0],cnu_msg_in_75[0],cnu_msg_in_74[0],cnu_msg_in_73[0],cnu_msg_in_72[0],cnu_msg_in_71[0],cnu_msg_in_70[0],cnu_msg_in_69[0],cnu_msg_in_68[0],cnu_msg_in_67[0],cnu_msg_in_66[0],cnu_msg_in_65[0],cnu_msg_in_64[0],cnu_msg_in_63[0],cnu_msg_in_62[0],cnu_msg_in_61[0],cnu_msg_in_60[0],cnu_msg_in_59[0],cnu_msg_in_58[0],cnu_msg_in_57[0],cnu_msg_in_56[0],cnu_msg_in_55[0],cnu_msg_in_54[0],cnu_msg_in_53[0],cnu_msg_in_52[0],cnu_msg_in_51[0],cnu_msg_in_50[0],cnu_msg_in_49[0],cnu_msg_in_48[0],cnu_msg_in_47[0],cnu_msg_in_46[0],cnu_msg_in_45[0],cnu_msg_in_44[0],cnu_msg_in_43[0],cnu_msg_in_42[0],cnu_msg_in_41[0],cnu_msg_in_40[0],cnu_msg_in_39[0],cnu_msg_in_38[0],cnu_msg_in_37[0],cnu_msg_in_36[0],cnu_msg_in_35[0],cnu_msg_in_34[0],cnu_msg_in_33[0],cnu_msg_in_32[0],cnu_msg_in_31[0],cnu_msg_in_30[0],cnu_msg_in_29[0],cnu_msg_in_28[0],cnu_msg_in_27[0],cnu_msg_in_26[0],cnu_msg_in_25[0],cnu_msg_in_24[0],cnu_msg_in_23[0],cnu_msg_in_22[0],cnu_msg_in_21[0],cnu_msg_in_20[0],cnu_msg_in_19[0],cnu_msg_in_18[0],cnu_msg_in_17[0],cnu_msg_in_16[0],cnu_msg_in_15[0],cnu_msg_in_14[0],cnu_msg_in_13[0],cnu_msg_in_12[0],cnu_msg_in_11[0],cnu_msg_in_10[0],cnu_msg_in_9[0],cnu_msg_in_8[0],cnu_msg_in_7[0],cnu_msg_in_6[0],cnu_msg_in_5[0],cnu_msg_in_4[0],cnu_msg_in_3[0],cnu_msg_in_2[0],cnu_msg_in_1[0],cnu_msg_in_0[0]}),
	.sw_out_bit1 ({cnu_msg_in_84[1],cnu_msg_in_83[1],cnu_msg_in_82[1],cnu_msg_in_81[1],cnu_msg_in_80[1],cnu_msg_in_79[1],cnu_msg_in_78[1],cnu_msg_in_77[1],cnu_msg_in_76[1],cnu_msg_in_75[1],cnu_msg_in_74[1],cnu_msg_in_73[1],cnu_msg_in_72[1],cnu_msg_in_71[1],cnu_msg_in_70[1],cnu_msg_in_69[1],cnu_msg_in_68[1],cnu_msg_in_67[1],cnu_msg_in_66[1],cnu_msg_in_65[1],cnu_msg_in_64[1],cnu_msg_in_63[1],cnu_msg_in_62[1],cnu_msg_in_61[1],cnu_msg_in_60[1],cnu_msg_in_59[1],cnu_msg_in_58[1],cnu_msg_in_57[1],cnu_msg_in_56[1],cnu_msg_in_55[1],cnu_msg_in_54[1],cnu_msg_in_53[1],cnu_msg_in_52[1],cnu_msg_in_51[1],cnu_msg_in_50[1],cnu_msg_in_49[1],cnu_msg_in_48[1],cnu_msg_in_47[1],cnu_msg_in_46[1],cnu_msg_in_45[1],cnu_msg_in_44[1],cnu_msg_in_43[1],cnu_msg_in_42[1],cnu_msg_in_41[1],cnu_msg_in_40[1],cnu_msg_in_39[1],cnu_msg_in_38[1],cnu_msg_in_37[1],cnu_msg_in_36[1],cnu_msg_in_35[1],cnu_msg_in_34[1],cnu_msg_in_33[1],cnu_msg_in_32[1],cnu_msg_in_31[1],cnu_msg_in_30[1],cnu_msg_in_29[1],cnu_msg_in_28[1],cnu_msg_in_27[1],cnu_msg_in_26[1],cnu_msg_in_25[1],cnu_msg_in_24[1],cnu_msg_in_23[1],cnu_msg_in_22[1],cnu_msg_in_21[1],cnu_msg_in_20[1],cnu_msg_in_19[1],cnu_msg_in_18[1],cnu_msg_in_17[1],cnu_msg_in_16[1],cnu_msg_in_15[1],cnu_msg_in_14[1],cnu_msg_in_13[1],cnu_msg_in_12[1],cnu_msg_in_11[1],cnu_msg_in_10[1],cnu_msg_in_9[1],cnu_msg_in_8[1],cnu_msg_in_7[1],cnu_msg_in_6[1],cnu_msg_in_5[1],cnu_msg_in_4[1],cnu_msg_in_3[1],cnu_msg_in_2[1],cnu_msg_in_1[1],cnu_msg_in_0[1]}),	
	.sw_out_bit2 ({cnu_msg_in_84[2],cnu_msg_in_83[2],cnu_msg_in_82[2],cnu_msg_in_81[2],cnu_msg_in_80[2],cnu_msg_in_79[2],cnu_msg_in_78[2],cnu_msg_in_77[2],cnu_msg_in_76[2],cnu_msg_in_75[2],cnu_msg_in_74[2],cnu_msg_in_73[2],cnu_msg_in_72[2],cnu_msg_in_71[2],cnu_msg_in_70[2],cnu_msg_in_69[2],cnu_msg_in_68[2],cnu_msg_in_67[2],cnu_msg_in_66[2],cnu_msg_in_65[2],cnu_msg_in_64[2],cnu_msg_in_63[2],cnu_msg_in_62[2],cnu_msg_in_61[2],cnu_msg_in_60[2],cnu_msg_in_59[2],cnu_msg_in_58[2],cnu_msg_in_57[2],cnu_msg_in_56[2],cnu_msg_in_55[2],cnu_msg_in_54[2],cnu_msg_in_53[2],cnu_msg_in_52[2],cnu_msg_in_51[2],cnu_msg_in_50[2],cnu_msg_in_49[2],cnu_msg_in_48[2],cnu_msg_in_47[2],cnu_msg_in_46[2],cnu_msg_in_45[2],cnu_msg_in_44[2],cnu_msg_in_43[2],cnu_msg_in_42[2],cnu_msg_in_41[2],cnu_msg_in_40[2],cnu_msg_in_39[2],cnu_msg_in_38[2],cnu_msg_in_37[2],cnu_msg_in_36[2],cnu_msg_in_35[2],cnu_msg_in_34[2],cnu_msg_in_33[2],cnu_msg_in_32[2],cnu_msg_in_31[2],cnu_msg_in_30[2],cnu_msg_in_29[2],cnu_msg_in_28[2],cnu_msg_in_27[2],cnu_msg_in_26[2],cnu_msg_in_25[2],cnu_msg_in_24[2],cnu_msg_in_23[2],cnu_msg_in_22[2],cnu_msg_in_21[2],cnu_msg_in_20[2],cnu_msg_in_19[2],cnu_msg_in_18[2],cnu_msg_in_17[2],cnu_msg_in_16[2],cnu_msg_in_15[2],cnu_msg_in_14[2],cnu_msg_in_13[2],cnu_msg_in_12[2],cnu_msg_in_11[2],cnu_msg_in_10[2],cnu_msg_in_9[2],cnu_msg_in_8[2],cnu_msg_in_7[2],cnu_msg_in_6[2],cnu_msg_in_5[2],cnu_msg_in_4[2],cnu_msg_in_3[2],cnu_msg_in_2[2],cnu_msg_in_1[2],cnu_msg_in_0[2]}),	
	.sw_out_bit3 ({cnu_msg_in_84[3],cnu_msg_in_83[3],cnu_msg_in_82[3],cnu_msg_in_81[3],cnu_msg_in_80[3],cnu_msg_in_79[3],cnu_msg_in_78[3],cnu_msg_in_77[3],cnu_msg_in_76[3],cnu_msg_in_75[3],cnu_msg_in_74[3],cnu_msg_in_73[3],cnu_msg_in_72[3],cnu_msg_in_71[3],cnu_msg_in_70[3],cnu_msg_in_69[3],cnu_msg_in_68[3],cnu_msg_in_67[3],cnu_msg_in_66[3],cnu_msg_in_65[3],cnu_msg_in_64[3],cnu_msg_in_63[3],cnu_msg_in_62[3],cnu_msg_in_61[3],cnu_msg_in_60[3],cnu_msg_in_59[3],cnu_msg_in_58[3],cnu_msg_in_57[3],cnu_msg_in_56[3],cnu_msg_in_55[3],cnu_msg_in_54[3],cnu_msg_in_53[3],cnu_msg_in_52[3],cnu_msg_in_51[3],cnu_msg_in_50[3],cnu_msg_in_49[3],cnu_msg_in_48[3],cnu_msg_in_47[3],cnu_msg_in_46[3],cnu_msg_in_45[3],cnu_msg_in_44[3],cnu_msg_in_43[3],cnu_msg_in_42[3],cnu_msg_in_41[3],cnu_msg_in_40[3],cnu_msg_in_39[3],cnu_msg_in_38[3],cnu_msg_in_37[3],cnu_msg_in_36[3],cnu_msg_in_35[3],cnu_msg_in_34[3],cnu_msg_in_33[3],cnu_msg_in_32[3],cnu_msg_in_31[3],cnu_msg_in_30[3],cnu_msg_in_29[3],cnu_msg_in_28[3],cnu_msg_in_27[3],cnu_msg_in_26[3],cnu_msg_in_25[3],cnu_msg_in_24[3],cnu_msg_in_23[3],cnu_msg_in_22[3],cnu_msg_in_21[3],cnu_msg_in_20[3],cnu_msg_in_19[3],cnu_msg_in_18[3],cnu_msg_in_17[3],cnu_msg_in_16[3],cnu_msg_in_15[3],cnu_msg_in_14[3],cnu_msg_in_13[3],cnu_msg_in_12[3],cnu_msg_in_11[3],cnu_msg_in_10[3],cnu_msg_in_9[3],cnu_msg_in_8[3],cnu_msg_in_7[3],cnu_msg_in_6[3],cnu_msg_in_5[3],cnu_msg_in_4[3],cnu_msg_in_3[3],cnu_msg_in_2[3],cnu_msg_in_1[3],cnu_msg_in_0[3]}),	
	.sw_in_bit0  (cnu_bs_in_bit[0]),
	.sw_in_bit1  (cnu_bs_in_bit[1]),
	.sw_in_bit2  (cnu_bs_in_bit[2]),
	.sw_in_bit3  (cnu_bs_in_bit[3]),
	.left_sel    (cnu_left_sel),
	.right_sel   (cnu_right_sel),
	.merge_sel   (cnu_merge_sel),
	.sys_clk     (sys_clk),
	.rstn		 (rstn)
);
qsn_controller_85b #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) cnu_qsn_controller_85b (
	.left_sel     (cnu_left_sel ),
	.right_sel    (cnu_right_sel),
	.merge_sel    (cnu_merge_sel),
	.shift_factor (cnu_shift_factor_cur_0), // offset shift factor of submatrix_1
	.rstn         (rstn),
	.sys_clk      (sys_clk)
);
/*----------------------------------------------*/
// Circular shifter of variable nodes 
qsn_top_85b vnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({vnu_msg_in_84[0],vnu_msg_in_83[0],vnu_msg_in_82[0],vnu_msg_in_81[0],vnu_msg_in_80[0],vnu_msg_in_79[0],vnu_msg_in_78[0],vnu_msg_in_77[0],vnu_msg_in_76[0],vnu_msg_in_75[0],vnu_msg_in_74[0],vnu_msg_in_73[0],vnu_msg_in_72[0],vnu_msg_in_71[0],vnu_msg_in_70[0],vnu_msg_in_69[0],vnu_msg_in_68[0],vnu_msg_in_67[0],vnu_msg_in_66[0],vnu_msg_in_65[0],vnu_msg_in_64[0],vnu_msg_in_63[0],vnu_msg_in_62[0],vnu_msg_in_61[0],vnu_msg_in_60[0],vnu_msg_in_59[0],vnu_msg_in_58[0],vnu_msg_in_57[0],vnu_msg_in_56[0],vnu_msg_in_55[0],vnu_msg_in_54[0],vnu_msg_in_53[0],vnu_msg_in_52[0],vnu_msg_in_51[0],vnu_msg_in_50[0],vnu_msg_in_49[0],vnu_msg_in_48[0],vnu_msg_in_47[0],vnu_msg_in_46[0],vnu_msg_in_45[0],vnu_msg_in_44[0],vnu_msg_in_43[0],vnu_msg_in_42[0],vnu_msg_in_41[0],vnu_msg_in_40[0],vnu_msg_in_39[0],vnu_msg_in_38[0],vnu_msg_in_37[0],vnu_msg_in_36[0],vnu_msg_in_35[0],vnu_msg_in_34[0],vnu_msg_in_33[0],vnu_msg_in_32[0],vnu_msg_in_31[0],vnu_msg_in_30[0],vnu_msg_in_29[0],vnu_msg_in_28[0],vnu_msg_in_27[0],vnu_msg_in_26[0],vnu_msg_in_25[0],vnu_msg_in_24[0],vnu_msg_in_23[0],vnu_msg_in_22[0],vnu_msg_in_21[0],vnu_msg_in_20[0],vnu_msg_in_19[0],vnu_msg_in_18[0],vnu_msg_in_17[0],vnu_msg_in_16[0],vnu_msg_in_15[0],vnu_msg_in_14[0],vnu_msg_in_13[0],vnu_msg_in_12[0],vnu_msg_in_11[0],vnu_msg_in_10[0],vnu_msg_in_9[0],vnu_msg_in_8[0],vnu_msg_in_7[0],vnu_msg_in_6[0],vnu_msg_in_5[0],vnu_msg_in_4[0],vnu_msg_in_3[0],vnu_msg_in_2[0],vnu_msg_in_1[0],vnu_msg_in_0[0]}),
	.sw_out_bit1 ({vnu_msg_in_84[1],vnu_msg_in_83[1],vnu_msg_in_82[1],vnu_msg_in_81[1],vnu_msg_in_80[1],vnu_msg_in_79[1],vnu_msg_in_78[1],vnu_msg_in_77[1],vnu_msg_in_76[1],vnu_msg_in_75[1],vnu_msg_in_74[1],vnu_msg_in_73[1],vnu_msg_in_72[1],vnu_msg_in_71[1],vnu_msg_in_70[1],vnu_msg_in_69[1],vnu_msg_in_68[1],vnu_msg_in_67[1],vnu_msg_in_66[1],vnu_msg_in_65[1],vnu_msg_in_64[1],vnu_msg_in_63[1],vnu_msg_in_62[1],vnu_msg_in_61[1],vnu_msg_in_60[1],vnu_msg_in_59[1],vnu_msg_in_58[1],vnu_msg_in_57[1],vnu_msg_in_56[1],vnu_msg_in_55[1],vnu_msg_in_54[1],vnu_msg_in_53[1],vnu_msg_in_52[1],vnu_msg_in_51[1],vnu_msg_in_50[1],vnu_msg_in_49[1],vnu_msg_in_48[1],vnu_msg_in_47[1],vnu_msg_in_46[1],vnu_msg_in_45[1],vnu_msg_in_44[1],vnu_msg_in_43[1],vnu_msg_in_42[1],vnu_msg_in_41[1],vnu_msg_in_40[1],vnu_msg_in_39[1],vnu_msg_in_38[1],vnu_msg_in_37[1],vnu_msg_in_36[1],vnu_msg_in_35[1],vnu_msg_in_34[1],vnu_msg_in_33[1],vnu_msg_in_32[1],vnu_msg_in_31[1],vnu_msg_in_30[1],vnu_msg_in_29[1],vnu_msg_in_28[1],vnu_msg_in_27[1],vnu_msg_in_26[1],vnu_msg_in_25[1],vnu_msg_in_24[1],vnu_msg_in_23[1],vnu_msg_in_22[1],vnu_msg_in_21[1],vnu_msg_in_20[1],vnu_msg_in_19[1],vnu_msg_in_18[1],vnu_msg_in_17[1],vnu_msg_in_16[1],vnu_msg_in_15[1],vnu_msg_in_14[1],vnu_msg_in_13[1],vnu_msg_in_12[1],vnu_msg_in_11[1],vnu_msg_in_10[1],vnu_msg_in_9[1],vnu_msg_in_8[1],vnu_msg_in_7[1],vnu_msg_in_6[1],vnu_msg_in_5[1],vnu_msg_in_4[1],vnu_msg_in_3[1],vnu_msg_in_2[1],vnu_msg_in_1[1],vnu_msg_in_0[1]}),
	.sw_out_bit2 ({vnu_msg_in_84[2],vnu_msg_in_83[2],vnu_msg_in_82[2],vnu_msg_in_81[2],vnu_msg_in_80[2],vnu_msg_in_79[2],vnu_msg_in_78[2],vnu_msg_in_77[2],vnu_msg_in_76[2],vnu_msg_in_75[2],vnu_msg_in_74[2],vnu_msg_in_73[2],vnu_msg_in_72[2],vnu_msg_in_71[2],vnu_msg_in_70[2],vnu_msg_in_69[2],vnu_msg_in_68[2],vnu_msg_in_67[2],vnu_msg_in_66[2],vnu_msg_in_65[2],vnu_msg_in_64[2],vnu_msg_in_63[2],vnu_msg_in_62[2],vnu_msg_in_61[2],vnu_msg_in_60[2],vnu_msg_in_59[2],vnu_msg_in_58[2],vnu_msg_in_57[2],vnu_msg_in_56[2],vnu_msg_in_55[2],vnu_msg_in_54[2],vnu_msg_in_53[2],vnu_msg_in_52[2],vnu_msg_in_51[2],vnu_msg_in_50[2],vnu_msg_in_49[2],vnu_msg_in_48[2],vnu_msg_in_47[2],vnu_msg_in_46[2],vnu_msg_in_45[2],vnu_msg_in_44[2],vnu_msg_in_43[2],vnu_msg_in_42[2],vnu_msg_in_41[2],vnu_msg_in_40[2],vnu_msg_in_39[2],vnu_msg_in_38[2],vnu_msg_in_37[2],vnu_msg_in_36[2],vnu_msg_in_35[2],vnu_msg_in_34[2],vnu_msg_in_33[2],vnu_msg_in_32[2],vnu_msg_in_31[2],vnu_msg_in_30[2],vnu_msg_in_29[2],vnu_msg_in_28[2],vnu_msg_in_27[2],vnu_msg_in_26[2],vnu_msg_in_25[2],vnu_msg_in_24[2],vnu_msg_in_23[2],vnu_msg_in_22[2],vnu_msg_in_21[2],vnu_msg_in_20[2],vnu_msg_in_19[2],vnu_msg_in_18[2],vnu_msg_in_17[2],vnu_msg_in_16[2],vnu_msg_in_15[2],vnu_msg_in_14[2],vnu_msg_in_13[2],vnu_msg_in_12[2],vnu_msg_in_11[2],vnu_msg_in_10[2],vnu_msg_in_9[2],vnu_msg_in_8[2],vnu_msg_in_7[2],vnu_msg_in_6[2],vnu_msg_in_5[2],vnu_msg_in_4[2],vnu_msg_in_3[2],vnu_msg_in_2[2],vnu_msg_in_1[2],vnu_msg_in_0[2]}),
	.sw_out_bit3 ({vnu_msg_in_84[3],vnu_msg_in_83[3],vnu_msg_in_82[3],vnu_msg_in_81[3],vnu_msg_in_80[3],vnu_msg_in_79[3],vnu_msg_in_78[3],vnu_msg_in_77[3],vnu_msg_in_76[3],vnu_msg_in_75[3],vnu_msg_in_74[3],vnu_msg_in_73[3],vnu_msg_in_72[3],vnu_msg_in_71[3],vnu_msg_in_70[3],vnu_msg_in_69[3],vnu_msg_in_68[3],vnu_msg_in_67[3],vnu_msg_in_66[3],vnu_msg_in_65[3],vnu_msg_in_64[3],vnu_msg_in_63[3],vnu_msg_in_62[3],vnu_msg_in_61[3],vnu_msg_in_60[3],vnu_msg_in_59[3],vnu_msg_in_58[3],vnu_msg_in_57[3],vnu_msg_in_56[3],vnu_msg_in_55[3],vnu_msg_in_54[3],vnu_msg_in_53[3],vnu_msg_in_52[3],vnu_msg_in_51[3],vnu_msg_in_50[3],vnu_msg_in_49[3],vnu_msg_in_48[3],vnu_msg_in_47[3],vnu_msg_in_46[3],vnu_msg_in_45[3],vnu_msg_in_44[3],vnu_msg_in_43[3],vnu_msg_in_42[3],vnu_msg_in_41[3],vnu_msg_in_40[3],vnu_msg_in_39[3],vnu_msg_in_38[3],vnu_msg_in_37[3],vnu_msg_in_36[3],vnu_msg_in_35[3],vnu_msg_in_34[3],vnu_msg_in_33[3],vnu_msg_in_32[3],vnu_msg_in_31[3],vnu_msg_in_30[3],vnu_msg_in_29[3],vnu_msg_in_28[3],vnu_msg_in_27[3],vnu_msg_in_26[3],vnu_msg_in_25[3],vnu_msg_in_24[3],vnu_msg_in_23[3],vnu_msg_in_22[3],vnu_msg_in_21[3],vnu_msg_in_20[3],vnu_msg_in_19[3],vnu_msg_in_18[3],vnu_msg_in_17[3],vnu_msg_in_16[3],vnu_msg_in_15[3],vnu_msg_in_14[3],vnu_msg_in_13[3],vnu_msg_in_12[3],vnu_msg_in_11[3],vnu_msg_in_10[3],vnu_msg_in_9[3],vnu_msg_in_8[3],vnu_msg_in_7[3],vnu_msg_in_6[3],vnu_msg_in_5[3],vnu_msg_in_4[3],vnu_msg_in_3[3],vnu_msg_in_2[3],vnu_msg_in_1[3],vnu_msg_in_0[3]}),
	.sw_in_bit0  (vnu_bs_in_bit[0]),
	.sw_in_bit1  (vnu_bs_in_bit[1]),
	.sw_in_bit2  (vnu_bs_in_bit[2]),
	.sw_in_bit3  (vnu_bs_in_bit[3]),
	.left_sel    (vnu_left_sel),
	.right_sel   (vnu_right_sel),
	.merge_sel   (vnu_merge_sel),
	.sys_clk     (sys_clk),
	.rstn		 (rstn)
);
qsn_controller_85b #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) vnu_qsn_controller_85b (
	.left_sel     (vnu_left_sel ),
	.right_sel    (vnu_right_sel),
	.merge_sel    (vnu_merge_sel),
	.shift_factor (vnu_shift_factor_cur_0), // offset shift factor of submatrix_1
	.rstn         (rstn),
	.sys_clk      (sys_clk)
);
/*----------------------------------------------*/	
	logic [QUAN_SIZE-1:0] mem_to_vnu_0;
	logic [QUAN_SIZE-1:0] mem_to_vnu_1;
	logic [QUAN_SIZE-1:0] mem_to_vnu_2;
	logic [QUAN_SIZE-1:0] mem_to_vnu_3;
	logic [QUAN_SIZE-1:0] mem_to_vnu_4;
	logic [QUAN_SIZE-1:0] mem_to_vnu_5;
	logic [QUAN_SIZE-1:0] mem_to_vnu_6;
	logic [QUAN_SIZE-1:0] mem_to_vnu_7;
	logic [QUAN_SIZE-1:0] mem_to_vnu_8;
	logic [QUAN_SIZE-1:0] mem_to_vnu_9;
	logic [QUAN_SIZE-1:0] mem_to_vnu_10;
	logic [QUAN_SIZE-1:0] mem_to_vnu_11;
	logic [QUAN_SIZE-1:0] mem_to_vnu_12;
	logic [QUAN_SIZE-1:0] mem_to_vnu_13;
	logic [QUAN_SIZE-1:0] mem_to_vnu_14;
	logic [QUAN_SIZE-1:0] mem_to_vnu_15;
	logic [QUAN_SIZE-1:0] mem_to_vnu_16;
	logic [QUAN_SIZE-1:0] mem_to_vnu_17;
	logic [QUAN_SIZE-1:0] mem_to_vnu_18;
	logic [QUAN_SIZE-1:0] mem_to_vnu_19;
	logic [QUAN_SIZE-1:0] mem_to_vnu_20;
	logic [QUAN_SIZE-1:0] mem_to_vnu_21;
	logic [QUAN_SIZE-1:0] mem_to_vnu_22;
	logic [QUAN_SIZE-1:0] mem_to_vnu_23;
	logic [QUAN_SIZE-1:0] mem_to_vnu_24;
	logic [QUAN_SIZE-1:0] mem_to_vnu_25;
	logic [QUAN_SIZE-1:0] mem_to_vnu_26;
	logic [QUAN_SIZE-1:0] mem_to_vnu_27;
	logic [QUAN_SIZE-1:0] mem_to_vnu_28;
	logic [QUAN_SIZE-1:0] mem_to_vnu_29;
	logic [QUAN_SIZE-1:0] mem_to_vnu_30;
	logic [QUAN_SIZE-1:0] mem_to_vnu_31;
	logic [QUAN_SIZE-1:0] mem_to_vnu_32;
	logic [QUAN_SIZE-1:0] mem_to_vnu_33;
	logic [QUAN_SIZE-1:0] mem_to_vnu_34;
	logic [QUAN_SIZE-1:0] mem_to_vnu_35;
	logic [QUAN_SIZE-1:0] mem_to_vnu_36;
	logic [QUAN_SIZE-1:0] mem_to_vnu_37;
	logic [QUAN_SIZE-1:0] mem_to_vnu_38;
	logic [QUAN_SIZE-1:0] mem_to_vnu_39;
	logic [QUAN_SIZE-1:0] mem_to_vnu_40;
	logic [QUAN_SIZE-1:0] mem_to_vnu_41;
	logic [QUAN_SIZE-1:0] mem_to_vnu_42;
	logic [QUAN_SIZE-1:0] mem_to_vnu_43;
	logic [QUAN_SIZE-1:0] mem_to_vnu_44;
	logic [QUAN_SIZE-1:0] mem_to_vnu_45;
	logic [QUAN_SIZE-1:0] mem_to_vnu_46;
	logic [QUAN_SIZE-1:0] mem_to_vnu_47;
	logic [QUAN_SIZE-1:0] mem_to_vnu_48;
	logic [QUAN_SIZE-1:0] mem_to_vnu_49;
	logic [QUAN_SIZE-1:0] mem_to_vnu_50;
	logic [QUAN_SIZE-1:0] mem_to_vnu_51;
	logic [QUAN_SIZE-1:0] mem_to_vnu_52;
	logic [QUAN_SIZE-1:0] mem_to_vnu_53;
	logic [QUAN_SIZE-1:0] mem_to_vnu_54;
	logic [QUAN_SIZE-1:0] mem_to_vnu_55;
	logic [QUAN_SIZE-1:0] mem_to_vnu_56;
	logic [QUAN_SIZE-1:0] mem_to_vnu_57;
	logic [QUAN_SIZE-1:0] mem_to_vnu_58;
	logic [QUAN_SIZE-1:0] mem_to_vnu_59;
	logic [QUAN_SIZE-1:0] mem_to_vnu_60;
	logic [QUAN_SIZE-1:0] mem_to_vnu_61;
	logic [QUAN_SIZE-1:0] mem_to_vnu_62;
	logic [QUAN_SIZE-1:0] mem_to_vnu_63;
	logic [QUAN_SIZE-1:0] mem_to_vnu_64;
	logic [QUAN_SIZE-1:0] mem_to_vnu_65;
	logic [QUAN_SIZE-1:0] mem_to_vnu_66;
	logic [QUAN_SIZE-1:0] mem_to_vnu_67;
	logic [QUAN_SIZE-1:0] mem_to_vnu_68;
	logic [QUAN_SIZE-1:0] mem_to_vnu_69;
	logic [QUAN_SIZE-1:0] mem_to_vnu_70;
	logic [QUAN_SIZE-1:0] mem_to_vnu_71;
	logic [QUAN_SIZE-1:0] mem_to_vnu_72;
	logic [QUAN_SIZE-1:0] mem_to_vnu_73;
	logic [QUAN_SIZE-1:0] mem_to_vnu_74;
	logic [QUAN_SIZE-1:0] mem_to_vnu_75;
	logic [QUAN_SIZE-1:0] mem_to_vnu_76;
	logic [QUAN_SIZE-1:0] mem_to_vnu_77;
	logic [QUAN_SIZE-1:0] mem_to_vnu_78;
	logic [QUAN_SIZE-1:0] mem_to_vnu_79;
	logic [QUAN_SIZE-1:0] mem_to_vnu_80;
	logic [QUAN_SIZE-1:0] mem_to_vnu_81;
	logic [QUAN_SIZE-1:0] mem_to_vnu_82;
	logic [QUAN_SIZE-1:0] mem_to_vnu_83;
	logic [QUAN_SIZE-1:0] mem_to_vnu_84;
	logic [QUAN_SIZE-1:0] mem_to_cnu_0;
	logic [QUAN_SIZE-1:0] mem_to_cnu_1;
	logic [QUAN_SIZE-1:0] mem_to_cnu_2;
	logic [QUAN_SIZE-1:0] mem_to_cnu_3;
	logic [QUAN_SIZE-1:0] mem_to_cnu_4;
	logic [QUAN_SIZE-1:0] mem_to_cnu_5;
	logic [QUAN_SIZE-1:0] mem_to_cnu_6;
	logic [QUAN_SIZE-1:0] mem_to_cnu_7;
	logic [QUAN_SIZE-1:0] mem_to_cnu_8;
	logic [QUAN_SIZE-1:0] mem_to_cnu_9;
	logic [QUAN_SIZE-1:0] mem_to_cnu_10;
	logic [QUAN_SIZE-1:0] mem_to_cnu_11;
	logic [QUAN_SIZE-1:0] mem_to_cnu_12;
	logic [QUAN_SIZE-1:0] mem_to_cnu_13;
	logic [QUAN_SIZE-1:0] mem_to_cnu_14;
	logic [QUAN_SIZE-1:0] mem_to_cnu_15;
	logic [QUAN_SIZE-1:0] mem_to_cnu_16;
	logic [QUAN_SIZE-1:0] mem_to_cnu_17;
	logic [QUAN_SIZE-1:0] mem_to_cnu_18;
	logic [QUAN_SIZE-1:0] mem_to_cnu_19;
	logic [QUAN_SIZE-1:0] mem_to_cnu_20;
	logic [QUAN_SIZE-1:0] mem_to_cnu_21;
	logic [QUAN_SIZE-1:0] mem_to_cnu_22;
	logic [QUAN_SIZE-1:0] mem_to_cnu_23;
	logic [QUAN_SIZE-1:0] mem_to_cnu_24;
	logic [QUAN_SIZE-1:0] mem_to_cnu_25;
	logic [QUAN_SIZE-1:0] mem_to_cnu_26;
	logic [QUAN_SIZE-1:0] mem_to_cnu_27;
	logic [QUAN_SIZE-1:0] mem_to_cnu_28;
	logic [QUAN_SIZE-1:0] mem_to_cnu_29;
	logic [QUAN_SIZE-1:0] mem_to_cnu_30;
	logic [QUAN_SIZE-1:0] mem_to_cnu_31;
	logic [QUAN_SIZE-1:0] mem_to_cnu_32;
	logic [QUAN_SIZE-1:0] mem_to_cnu_33;
	logic [QUAN_SIZE-1:0] mem_to_cnu_34;
	logic [QUAN_SIZE-1:0] mem_to_cnu_35;
	logic [QUAN_SIZE-1:0] mem_to_cnu_36;
	logic [QUAN_SIZE-1:0] mem_to_cnu_37;
	logic [QUAN_SIZE-1:0] mem_to_cnu_38;
	logic [QUAN_SIZE-1:0] mem_to_cnu_39;
	logic [QUAN_SIZE-1:0] mem_to_cnu_40;
	logic [QUAN_SIZE-1:0] mem_to_cnu_41;
	logic [QUAN_SIZE-1:0] mem_to_cnu_42;
	logic [QUAN_SIZE-1:0] mem_to_cnu_43;
	logic [QUAN_SIZE-1:0] mem_to_cnu_44;
	logic [QUAN_SIZE-1:0] mem_to_cnu_45;
	logic [QUAN_SIZE-1:0] mem_to_cnu_46;
	logic [QUAN_SIZE-1:0] mem_to_cnu_47;
	logic [QUAN_SIZE-1:0] mem_to_cnu_48;
	logic [QUAN_SIZE-1:0] mem_to_cnu_49;
	logic [QUAN_SIZE-1:0] mem_to_cnu_50;
	logic [QUAN_SIZE-1:0] mem_to_cnu_51;
	logic [QUAN_SIZE-1:0] mem_to_cnu_52;
	logic [QUAN_SIZE-1:0] mem_to_cnu_53;
	logic [QUAN_SIZE-1:0] mem_to_cnu_54;
	logic [QUAN_SIZE-1:0] mem_to_cnu_55;
	logic [QUAN_SIZE-1:0] mem_to_cnu_56;
	logic [QUAN_SIZE-1:0] mem_to_cnu_57;
	logic [QUAN_SIZE-1:0] mem_to_cnu_58;
	logic [QUAN_SIZE-1:0] mem_to_cnu_59;
	logic [QUAN_SIZE-1:0] mem_to_cnu_60;
	logic [QUAN_SIZE-1:0] mem_to_cnu_61;
	logic [QUAN_SIZE-1:0] mem_to_cnu_62;
	logic [QUAN_SIZE-1:0] mem_to_cnu_63;
	logic [QUAN_SIZE-1:0] mem_to_cnu_64;
	logic [QUAN_SIZE-1:0] mem_to_cnu_65;
	logic [QUAN_SIZE-1:0] mem_to_cnu_66;
	logic [QUAN_SIZE-1:0] mem_to_cnu_67;
	logic [QUAN_SIZE-1:0] mem_to_cnu_68;
	logic [QUAN_SIZE-1:0] mem_to_cnu_69;
	logic [QUAN_SIZE-1:0] mem_to_cnu_70;
	logic [QUAN_SIZE-1:0] mem_to_cnu_71;
	logic [QUAN_SIZE-1:0] mem_to_cnu_72;
	logic [QUAN_SIZE-1:0] mem_to_cnu_73;
	logic [QUAN_SIZE-1:0] mem_to_cnu_74;
	logic [QUAN_SIZE-1:0] mem_to_cnu_75;
	logic [QUAN_SIZE-1:0] mem_to_cnu_76;
	logic [QUAN_SIZE-1:0] mem_to_cnu_77;
	logic [QUAN_SIZE-1:0] mem_to_cnu_78;
	logic [QUAN_SIZE-1:0] mem_to_cnu_79;
	logic [QUAN_SIZE-1:0] mem_to_cnu_80;
	logic [QUAN_SIZE-1:0] mem_to_cnu_81;
	logic [QUAN_SIZE-1:0] mem_to_cnu_82;
	logic [QUAN_SIZE-1:0] mem_to_cnu_83;
	logic [QUAN_SIZE-1:0] mem_to_cnu_84;
	logic      [ADDR-1:0] cnu_sync_addr;
	logic      [ADDR-1:0] vnu_sync_addr;
	logic [LAYER_NUM-1:0] cnu_layer_status;
	logic [LAYER_NUM-1:0] vnu_layer_status;
	logic           [1:0] last_row_chunk;
	logic           [1:0] we;
	logic                 sys_clk;
	logic                 rstn;

	mem_subsystem_top_submatrix_1 #(
			.QUAN_SIZE(QUAN_SIZE),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.LAYER_NUM(LAYER_NUM),
			.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
			.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
			.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
			.DEPTH(DEPTH),
			.DATA_WIDTH(WIDTH),
			.FRAG_WIDTH(FRAG_WIDTH),
			.ADDR(ADDR)
		) inst_mem_subsystem_top_submatrix_1 (
			.mem_to_vnu_0     (mem_to_vnu[0 ]),
			.mem_to_vnu_1     (mem_to_vnu[1 ]),
			.mem_to_vnu_2     (mem_to_vnu[2 ]),
			.mem_to_vnu_3     (mem_to_vnu[3 ]),
			.mem_to_vnu_4     (mem_to_vnu[4 ]),
			.mem_to_vnu_5     (mem_to_vnu[5 ]),
			.mem_to_vnu_6     (mem_to_vnu[6 ]),
			.mem_to_vnu_7     (mem_to_vnu[7 ]),
			.mem_to_vnu_8     (mem_to_vnu[8 ]),
			.mem_to_vnu_9     (mem_to_vnu[9 ]),
			.mem_to_vnu_10    (mem_to_vnu[10]),
			.mem_to_vnu_11    (mem_to_vnu[11]),
			.mem_to_vnu_12    (mem_to_vnu[12]),
			.mem_to_vnu_13    (mem_to_vnu[13]),
			.mem_to_vnu_14    (mem_to_vnu[14]),
			.mem_to_vnu_15    (mem_to_vnu[15]),
			.mem_to_vnu_16    (mem_to_vnu[16]),
			.mem_to_vnu_17    (mem_to_vnu[17]),
			.mem_to_vnu_18    (mem_to_vnu[18]),
			.mem_to_vnu_19    (mem_to_vnu[19]),
			.mem_to_vnu_20    (mem_to_vnu[20]),
			.mem_to_vnu_21    (mem_to_vnu[21]),
			.mem_to_vnu_22    (mem_to_vnu[22]),
			.mem_to_vnu_23    (mem_to_vnu[23]),
			.mem_to_vnu_24    (mem_to_vnu[24]),
			.mem_to_vnu_25    (mem_to_vnu[25]),
			.mem_to_vnu_26    (mem_to_vnu[26]),
			.mem_to_vnu_27    (mem_to_vnu[27]),
			.mem_to_vnu_28    (mem_to_vnu[28]),
			.mem_to_vnu_29    (mem_to_vnu[29]),
			.mem_to_vnu_30    (mem_to_vnu[30]),
			.mem_to_vnu_31    (mem_to_vnu[31]),
			.mem_to_vnu_32    (mem_to_vnu[32]),
			.mem_to_vnu_33    (mem_to_vnu[33]),
			.mem_to_vnu_34    (mem_to_vnu[34]),
			.mem_to_vnu_35    (mem_to_vnu[35]),
			.mem_to_vnu_36    (mem_to_vnu[36]),
			.mem_to_vnu_37    (mem_to_vnu[37]),
			.mem_to_vnu_38    (mem_to_vnu[38]),
			.mem_to_vnu_39    (mem_to_vnu[39]),
			.mem_to_vnu_40    (mem_to_vnu[40]),
			.mem_to_vnu_41    (mem_to_vnu[41]),
			.mem_to_vnu_42    (mem_to_vnu[42]),
			.mem_to_vnu_43    (mem_to_vnu[43]),
			.mem_to_vnu_44    (mem_to_vnu[44]),
			.mem_to_vnu_45    (mem_to_vnu[45]),
			.mem_to_vnu_46    (mem_to_vnu[46]),
			.mem_to_vnu_47    (mem_to_vnu[47]),
			.mem_to_vnu_48    (mem_to_vnu[48]),
			.mem_to_vnu_49    (mem_to_vnu[49]),
			.mem_to_vnu_50    (mem_to_vnu[50]),
			.mem_to_vnu_51    (mem_to_vnu[51]),
			.mem_to_vnu_52    (mem_to_vnu[52]),
			.mem_to_vnu_53    (mem_to_vnu[53]),
			.mem_to_vnu_54    (mem_to_vnu[54]),
			.mem_to_vnu_55    (mem_to_vnu[55]),
			.mem_to_vnu_56    (mem_to_vnu[56]),
			.mem_to_vnu_57    (mem_to_vnu[57]),
			.mem_to_vnu_58    (mem_to_vnu[58]),
			.mem_to_vnu_59    (mem_to_vnu[59]),
			.mem_to_vnu_60    (mem_to_vnu[60]),
			.mem_to_vnu_61    (mem_to_vnu[61]),
			.mem_to_vnu_62    (mem_to_vnu[62]),
			.mem_to_vnu_63    (mem_to_vnu[63]),
			.mem_to_vnu_64    (mem_to_vnu[64]),
			.mem_to_vnu_65    (mem_to_vnu[65]),
			.mem_to_vnu_66    (mem_to_vnu[66]),
			.mem_to_vnu_67    (mem_to_vnu[67]),
			.mem_to_vnu_68    (mem_to_vnu[68]),
			.mem_to_vnu_69    (mem_to_vnu[69]),
			.mem_to_vnu_70    (mem_to_vnu[70]),
			.mem_to_vnu_71    (mem_to_vnu[71]),
			.mem_to_vnu_72    (mem_to_vnu[72]),
			.mem_to_vnu_73    (mem_to_vnu[73]),
			.mem_to_vnu_74    (mem_to_vnu[74]),
			.mem_to_vnu_75    (mem_to_vnu[75]),
			.mem_to_vnu_76    (mem_to_vnu[76]),
			.mem_to_vnu_77    (mem_to_vnu[77]),
			.mem_to_vnu_78    (mem_to_vnu[78]),
			.mem_to_vnu_79    (mem_to_vnu[79]),
			.mem_to_vnu_80    (mem_to_vnu[80]),
			.mem_to_vnu_81    (mem_to_vnu[81]),
			.mem_to_vnu_82    (mem_to_vnu[82]),
			.mem_to_vnu_83    (mem_to_vnu[83]),
			.mem_to_vnu_84    (mem_to_vnu[84]),
			.mem_to_cnu_0     (mem_to_cnu[0 ]),
			.mem_to_cnu_1     (mem_to_cnu[1 ]),
			.mem_to_cnu_2     (mem_to_cnu[2 ]),
			.mem_to_cnu_3     (mem_to_cnu[3 ]),
			.mem_to_cnu_4     (mem_to_cnu[4 ]),
			.mem_to_cnu_5     (mem_to_cnu[5 ]),
			.mem_to_cnu_6     (mem_to_cnu[6 ]),
			.mem_to_cnu_7     (mem_to_cnu[7 ]),
			.mem_to_cnu_8     (mem_to_cnu[8 ]),
			.mem_to_cnu_9     (mem_to_cnu[9 ]),
			.mem_to_cnu_10    (mem_to_cnu[10]),
			.mem_to_cnu_11    (mem_to_cnu[11]),
			.mem_to_cnu_12    (mem_to_cnu[12]),
			.mem_to_cnu_13    (mem_to_cnu[13]),
			.mem_to_cnu_14    (mem_to_cnu[14]),
			.mem_to_cnu_15    (mem_to_cnu[15]),
			.mem_to_cnu_16    (mem_to_cnu[16]),
			.mem_to_cnu_17    (mem_to_cnu[17]),
			.mem_to_cnu_18    (mem_to_cnu[18]),
			.mem_to_cnu_19    (mem_to_cnu[19]),
			.mem_to_cnu_20    (mem_to_cnu[20]),
			.mem_to_cnu_21    (mem_to_cnu[21]),
			.mem_to_cnu_22    (mem_to_cnu[22]),
			.mem_to_cnu_23    (mem_to_cnu[23]),
			.mem_to_cnu_24    (mem_to_cnu[24]),
			.mem_to_cnu_25    (mem_to_cnu[25]),
			.mem_to_cnu_26    (mem_to_cnu[26]),
			.mem_to_cnu_27    (mem_to_cnu[27]),
			.mem_to_cnu_28    (mem_to_cnu[28]),
			.mem_to_cnu_29    (mem_to_cnu[29]),
			.mem_to_cnu_30    (mem_to_cnu[30]),
			.mem_to_cnu_31    (mem_to_cnu[31]),
			.mem_to_cnu_32    (mem_to_cnu[32]),
			.mem_to_cnu_33    (mem_to_cnu[33]),
			.mem_to_cnu_34    (mem_to_cnu[34]),
			.mem_to_cnu_35    (mem_to_cnu[35]),
			.mem_to_cnu_36    (mem_to_cnu[36]),
			.mem_to_cnu_37    (mem_to_cnu[37]),
			.mem_to_cnu_38    (mem_to_cnu[38]),
			.mem_to_cnu_39    (mem_to_cnu[39]),
			.mem_to_cnu_40    (mem_to_cnu[40]),
			.mem_to_cnu_41    (mem_to_cnu[41]),
			.mem_to_cnu_42    (mem_to_cnu[42]),
			.mem_to_cnu_43    (mem_to_cnu[43]),
			.mem_to_cnu_44    (mem_to_cnu[44]),
			.mem_to_cnu_45    (mem_to_cnu[45]),
			.mem_to_cnu_46    (mem_to_cnu[46]),
			.mem_to_cnu_47    (mem_to_cnu[47]),
			.mem_to_cnu_48    (mem_to_cnu[48]),
			.mem_to_cnu_49    (mem_to_cnu[49]),
			.mem_to_cnu_50    (mem_to_cnu[50]),
			.mem_to_cnu_51    (mem_to_cnu[51]),
			.mem_to_cnu_52    (mem_to_cnu[52]),
			.mem_to_cnu_53    (mem_to_cnu[53]),
			.mem_to_cnu_54    (mem_to_cnu[54]),
			.mem_to_cnu_55    (mem_to_cnu[55]),
			.mem_to_cnu_56    (mem_to_cnu[56]),
			.mem_to_cnu_57    (mem_to_cnu[57]),
			.mem_to_cnu_58    (mem_to_cnu[58]),
			.mem_to_cnu_59    (mem_to_cnu[59]),
			.mem_to_cnu_60    (mem_to_cnu[60]),
			.mem_to_cnu_61    (mem_to_cnu[61]),
			.mem_to_cnu_62    (mem_to_cnu[62]),
			.mem_to_cnu_63    (mem_to_cnu[63]),
			.mem_to_cnu_64    (mem_to_cnu[64]),
			.mem_to_cnu_65    (mem_to_cnu[65]),
			.mem_to_cnu_66    (mem_to_cnu[66]),
			.mem_to_cnu_67    (mem_to_cnu[67]),
			.mem_to_cnu_68    (mem_to_cnu[68]),
			.mem_to_cnu_69    (mem_to_cnu[69]),
			.mem_to_cnu_70    (mem_to_cnu[70]),
			.mem_to_cnu_71    (mem_to_cnu[71]),
			.mem_to_cnu_72    (mem_to_cnu[72]),
			.mem_to_cnu_73    (mem_to_cnu[73]),
			.mem_to_cnu_74    (mem_to_cnu[74]),
			.mem_to_cnu_75    (mem_to_cnu[75]),
			.mem_to_cnu_76    (mem_to_cnu[76]),
			.mem_to_cnu_77    (mem_to_cnu[77]),
			.mem_to_cnu_78    (mem_to_cnu[78]),
			.mem_to_cnu_79    (mem_to_cnu[79]),
			.mem_to_cnu_80    (mem_to_cnu[80]),
			.mem_to_cnu_81    (mem_to_cnu[81]),
			.mem_to_cnu_82    (mem_to_cnu[82]),
			.mem_to_cnu_83    (mem_to_cnu[83]),
			.mem_to_cnu_84    (mem_to_cnu[84]),

			.vnu_to_mem_0     (vnu_to_mem_0 ),
			.vnu_to_mem_1     (vnu_msg_in_1 ),
			.vnu_to_mem_2     (vnu_msg_in_2 ),
			.vnu_to_mem_3     (vnu_msg_in_3 ),
			.vnu_to_mem_4     (vnu_msg_in_4 ),
			.vnu_to_mem_5     (vnu_msg_in_5 ),
			.vnu_to_mem_6     (vnu_msg_in_6 ),
			.vnu_to_mem_7     (vnu_msg_in_7 ),
			.vnu_to_mem_8     (vnu_msg_in_8 ),
			.vnu_to_mem_9     (vnu_msg_in_9 ),
			.vnu_to_mem_10    (vnu_msg_in_10),
			.vnu_to_mem_11    (vnu_msg_in_11),
			.vnu_to_mem_12    (vnu_msg_in_12),
			.vnu_to_mem_13    (vnu_msg_in_13),
			.vnu_to_mem_14    (vnu_msg_in_14),
			.vnu_to_mem_15    (vnu_msg_in_15),
			.vnu_to_mem_16    (vnu_msg_in_16),
			.vnu_to_mem_17    (vnu_msg_in_17),
			.vnu_to_mem_18    (vnu_msg_in_18),
			.vnu_to_mem_19    (vnu_msg_in_19),
			.vnu_to_mem_20    (vnu_msg_in_20),
			.vnu_to_mem_21    (vnu_msg_in_21),
			.vnu_to_mem_22    (vnu_msg_in_22),
			.vnu_to_mem_23    (vnu_msg_in_23),
			.vnu_to_mem_24    (vnu_msg_in_24),
			.vnu_to_mem_25    (vnu_msg_in_25),
			.vnu_to_mem_26    (vnu_msg_in_26),
			.vnu_to_mem_27    (vnu_msg_in_27),
			.vnu_to_mem_28    (vnu_msg_in_28),
			.vnu_to_mem_29    (vnu_msg_in_29),
			.vnu_to_mem_30    (vnu_msg_in_30),
			.vnu_to_mem_31    (vnu_msg_in_31),
			.vnu_to_mem_32    (vnu_msg_in_32),
			.vnu_to_mem_33    (vnu_msg_in_33),
			.vnu_to_mem_34    (vnu_msg_in_34),
			.vnu_to_mem_35    (vnu_msg_in_35),
			.vnu_to_mem_36    (vnu_msg_in_36),
			.vnu_to_mem_37    (vnu_msg_in_37),
			.vnu_to_mem_38    (vnu_msg_in_38),
			.vnu_to_mem_39    (vnu_msg_in_39),
			.vnu_to_mem_40    (vnu_msg_in_40),
			.vnu_to_mem_41    (vnu_msg_in_41),
			.vnu_to_mem_42    (vnu_msg_in_42),
			.vnu_to_mem_43    (vnu_msg_in_43),
			.vnu_to_mem_44    (vnu_msg_in_44),
			.vnu_to_mem_45    (vnu_msg_in_45),
			.vnu_to_mem_46    (vnu_msg_in_46),
			.vnu_to_mem_47    (vnu_msg_in_47),
			.vnu_to_mem_48    (vnu_msg_in_48),
			.vnu_to_mem_49    (vnu_msg_in_49),
			.vnu_to_mem_50    (vnu_msg_in_50),
			.vnu_to_mem_51    (vnu_msg_in_51),
			.vnu_to_mem_52    (vnu_msg_in_52),
			.vnu_to_mem_53    (vnu_msg_in_53),
			.vnu_to_mem_54    (vnu_msg_in_54),
			.vnu_to_mem_55    (vnu_msg_in_55),
			.vnu_to_mem_56    (vnu_msg_in_56),
			.vnu_to_mem_57    (vnu_msg_in_57),
			.vnu_to_mem_58    (vnu_msg_in_58),
			.vnu_to_mem_59    (vnu_msg_in_59),
			.vnu_to_mem_60    (vnu_msg_in_60),
			.vnu_to_mem_61    (vnu_msg_in_61),
			.vnu_to_mem_62    (vnu_msg_in_62),
			.vnu_to_mem_63    (vnu_msg_in_63),
			.vnu_to_mem_64    (vnu_msg_in_64),
			.vnu_to_mem_65    (vnu_msg_in_65),
			.vnu_to_mem_66    (vnu_msg_in_66),
			.vnu_to_mem_67    (vnu_msg_in_67),
			.vnu_to_mem_68    (vnu_msg_in_68),
			.vnu_to_mem_69    (vnu_msg_in_69),
			.vnu_to_mem_70    (vnu_msg_in_70),
			.vnu_to_mem_71    (vnu_msg_in_71),
			.vnu_to_mem_72    (vnu_msg_in_72),
			.vnu_to_mem_73    (vnu_msg_in_73),
			.vnu_to_mem_74    (vnu_msg_in_74),
			.vnu_to_mem_75    (vnu_msg_in_75),
			.vnu_to_mem_76    (vnu_msg_in_76),
			.vnu_to_mem_77    (vnu_msg_in_77),
			.vnu_to_mem_78    (vnu_msg_in_78),
			.vnu_to_mem_79    (vnu_msg_in_79),
			.vnu_to_mem_80    (vnu_msg_in_80),
			.vnu_to_mem_81    (vnu_msg_in_81),
			.vnu_to_mem_82    (vnu_msg_in_82),
			.vnu_to_mem_83    (vnu_msg_in_83),
			.vnu_to_mem_84    (vnu_msg_in_84),
			.cnu_to_mem_0     (cnu_msg_in_0 ),
			.cnu_to_mem_1     (cnu_msg_in_1 ),
			.cnu_to_mem_2     (cnu_msg_in_2 ),
			.cnu_to_mem_3     (cnu_msg_in_3 ),
			.cnu_to_mem_4     (cnu_msg_in_4 ),
			.cnu_to_mem_5     (cnu_msg_in_5 ),
			.cnu_to_mem_6     (cnu_msg_in_6 ),
			.cnu_to_mem_7     (cnu_msg_in_7 ),
			.cnu_to_mem_8     (cnu_msg_in_8 ),
			.cnu_to_mem_9     (cnu_msg_in_9 ),
			.cnu_to_mem_10    (cnu_msg_in_10),
			.cnu_to_mem_11    (cnu_msg_in_11),
			.cnu_to_mem_12    (cnu_msg_in_12),
			.cnu_to_mem_13    (cnu_msg_in_13),
			.cnu_to_mem_14    (cnu_msg_in_14),
			.cnu_to_mem_15    (cnu_msg_in_15),
			.cnu_to_mem_16    (cnu_msg_in_16),
			.cnu_to_mem_17    (cnu_msg_in_17),
			.cnu_to_mem_18    (cnu_msg_in_18),
			.cnu_to_mem_19    (cnu_msg_in_19),
			.cnu_to_mem_20    (cnu_msg_in_20),
			.cnu_to_mem_21    (cnu_msg_in_21),
			.cnu_to_mem_22    (cnu_msg_in_22),
			.cnu_to_mem_23    (cnu_msg_in_23),
			.cnu_to_mem_24    (cnu_msg_in_24),
			.cnu_to_mem_25    (cnu_msg_in_25),
			.cnu_to_mem_26    (cnu_msg_in_26),
			.cnu_to_mem_27    (cnu_msg_in_27),
			.cnu_to_mem_28    (cnu_msg_in_28),
			.cnu_to_mem_29    (cnu_msg_in_29),
			.cnu_to_mem_30    (cnu_msg_in_30),
			.cnu_to_mem_31    (cnu_msg_in_31),
			.cnu_to_mem_32    (cnu_msg_in_32),
			.cnu_to_mem_33    (cnu_msg_in_33),
			.cnu_to_mem_34    (cnu_msg_in_34),
			.cnu_to_mem_35    (cnu_msg_in_35),
			.cnu_to_mem_36    (cnu_msg_in_36),
			.cnu_to_mem_37    (cnu_msg_in_37),
			.cnu_to_mem_38    (cnu_msg_in_38),
			.cnu_to_mem_39    (cnu_msg_in_39),
			.cnu_to_mem_40    (cnu_msg_in_40),
			.cnu_to_mem_41    (cnu_msg_in_41),
			.cnu_to_mem_42    (cnu_msg_in_42),
			.cnu_to_mem_43    (cnu_msg_in_43),
			.cnu_to_mem_44    (cnu_msg_in_44),
			.cnu_to_mem_45    (cnu_msg_in_45),
			.cnu_to_mem_46    (cnu_msg_in_46),
			.cnu_to_mem_47    (cnu_msg_in_47),
			.cnu_to_mem_48    (cnu_msg_in_48),
			.cnu_to_mem_49    (cnu_msg_in_49),
			.cnu_to_mem_50    (cnu_msg_in_50),
			.cnu_to_mem_51    (cnu_msg_in_51),
			.cnu_to_mem_52    (cnu_msg_in_52),
			.cnu_to_mem_53    (cnu_msg_in_53),
			.cnu_to_mem_54    (cnu_msg_in_54),
			.cnu_to_mem_55    (cnu_msg_in_55),
			.cnu_to_mem_56    (cnu_msg_in_56),
			.cnu_to_mem_57    (cnu_msg_in_57),
			.cnu_to_mem_58    (cnu_msg_in_58),
			.cnu_to_mem_59    (cnu_msg_in_59),
			.cnu_to_mem_60    (cnu_msg_in_60),
			.cnu_to_mem_61    (cnu_msg_in_61),
			.cnu_to_mem_62    (cnu_msg_in_62),
			.cnu_to_mem_63    (cnu_msg_in_63),
			.cnu_to_mem_64    (cnu_msg_in_64),
			.cnu_to_mem_65    (cnu_msg_in_65),
			.cnu_to_mem_66    (cnu_msg_in_66),
			.cnu_to_mem_67    (cnu_msg_in_67),
			.cnu_to_mem_68    (cnu_msg_in_68),
			.cnu_to_mem_69    (cnu_msg_in_69),
			.cnu_to_mem_70    (cnu_msg_in_70),
			.cnu_to_mem_71    (cnu_msg_in_71),
			.cnu_to_mem_72    (cnu_msg_in_72),
			.cnu_to_mem_73    (cnu_msg_in_73),
			.cnu_to_mem_74    (cnu_msg_in_74),
			.cnu_to_mem_75    (cnu_msg_in_75),
			.cnu_to_mem_76    (cnu_msg_in_76),
			.cnu_to_mem_77    (cnu_msg_in_77),
			.cnu_to_mem_78    (cnu_msg_in_78),
			.cnu_to_mem_79    (cnu_msg_in_79),
			.cnu_to_mem_80    (cnu_msg_in_80),
			.cnu_to_mem_81    (cnu_msg_in_81),
			.cnu_to_mem_82    (cnu_msg_in_82),
			.cnu_to_mem_83    (cnu_msg_in_83),
			.cnu_to_mem_84    (cnu_to_mem_84),
			.cnu_sync_addr    (cnu_sync_addr),
			.vnu_sync_addr    (vnu_sync_addr),
			.cnu_layer_status (cnu_layer_status),
			.vnu_layer_status (vnu_layer_status),
			.last_row_chunk   (last_row_chunk),
			.we               (we),
			.sys_clk          (sys_clk),
			.rstn             (rstn)
		);
endmodule