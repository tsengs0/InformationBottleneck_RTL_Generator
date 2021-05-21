`timescale 1 ps / 1 ps
`include "snr_param.vh"
`include "define.vh"

module ib_ldpc_decoder_ber_eval # (
	parameter N = `VN_NUM, // block length
	parameter QUAN_SIZE = `QUAN_SIZE,
	parameter MAGNITUDE_SIZE = QUAN_SIZE-1,
	parameter ERR_FRAME_HALT = `ERR_FRAME_HALT, // evaluating every SNR (dB) until ERR_FRAME_HALT error frames have been undergone
	parameter MAX_ITER = `MAX_ITER,
	parameter ITER_ADDR_BW = `ITER_ADDR_BW,
	parameter SNR_SET_NUM = `SNR_SET_NUM,
	parameter START_SNR = `START_SNR
)(
    output wire ready_work,
	output wire is_awgn_out, // to check if there is any AWGN signal generated

    input wire CLK_300_N,
    input wire CLK_300_P,
    input wire GPIO_PB_SW2, // for PLL Rst
    input wire GPIO_PB_SW3 // for System RSTn
);
	// Determination of Bit-Width
	localparam errCnt_width = $clog2(N); // 8-bit
	localparam integer PACKAGE_FRAME_NUM = (2**`FRAME_COUNT_SIZE);
	localparam integer ERR_FRAME_PACKET_SIZE = $clog2(ERR_FRAME_HALT);
	localparam integer ERR_CNT_PACKET_SIZE = $clog2(ERR_FRAME_HALT*N);
	localparam integer ITER_CNT_PACKET_SIZE = $clog2(PACKAGE_FRAME_NUM*MAX_ITER);
	
	//localparam integer CH_MSG_BUFFER_DEPTH = 1; // the depth of channel-message buffer used for fowarding to the decoder
	localparam SNR_PACKET_SIZE = $clog2(SNR_SET_NUM);
	reg result_fifo_we;
	reg [7:0] snr_next_reg;
	wire clk_lock, clk_100MHz, clk_150MHz, clk_50MHz, clk_200MHz, clk_300MHz, syndrome_clk;
	wire ps_clk_100MHz, awgn_gen_clk, read_clk, write_clk;
	wire pll_rst, sys_rstn, symbol_gen_ce;  
	wire [N-1:0] hard_decision;
	reg [N-1:0] hard_decision_reg;
	reg [QUAN_SIZE-1:0] ch_msg [0:N-1];
	wire decode_busy, decode_termination, decode_fail;
	reg block_cnt_full;
	wire [ITER_ADDR_BW-1:0] decode_iter_cnt;
    `ifdef AWGN_GEN_VERIFY
    	wire v2c_load_debug;
    `endif
	assign pll_rst = GPIO_PB_SW2;
	assign sys_rstn = ~GPIO_PB_SW3;
	assign symbol_gen_ce = clk_lock; //sys_rstn;
	/*
	clock_domain_wrapper clock_u0 (
		.clk_100MHz (clk_100MHz),
		.clk_150MHz (clk_150MHz),
		.clk_50MHz (clk_50MHz),
		.clk_200MHz (clk_200MHz),
		.clk_300MHz (clk_300MHz),
		.clk_300mhz_clk_n (CLK_300_N),
		.clk_300mhz_clk_p (CLK_300_P),
		.locked (clk_lock),
		.reset_0 (pll_rst)
	);
	*/
	
	sync_clock_domain_wrapper sync_clock_u0 (
		.clk_100MHz (clk_100MHz),
    	.clk_150MHz (clk_150MHz),
    	.clk_200MHz (clk_200MHz),
    	.clk_300MHz (clk_300MHz),
    	.clk_50MHz (clk_50MHz),
    	.clk_in1_0 (ps_clk_100MHz),
    	.locked_0 (clk_lock),
    	.reset_0 (pll_rst)
    );
	assign read_clk = (clk_lock & clk_100MHz);
	assign write_clk = (clk_lock & clk_200MHz);
	assign awgn_gen_clk = read_clk;//(clk_lock & clk_50MHz); //write_clk;//(clk_lock & clk_300MHz);
	assign syndrome_clk = write_clk; // choosing a faster clock rate than read clock
	//assign result_fifo_we = clk_lock;
	assign ready_work = 1'b1;//result_fifo_we;

	//localparam frame_cnt_width = $clog2(CH_MSG_BUFFER_DEPTH);
	//reg [frame_cnt_width-1:0] frame_buffer_cnt;
	wire [N*QUAN_SIZE-1:0] coded_block;
	wire tvalid_master, ready_slave;
	// First codeword will takes 51+24=75 clock cycles to be generated
	// From the second codeword the latency is 12 clcok cycles due to the pipeline fashion
`ifdef CODE_RATE_05
    localparam [15:0] std_dev_0_0 = 16'b00001_00000000000;
    localparam [15:0] std_dev_0_1 = 16'b00000_11111101000;
    localparam [15:0] std_dev_0_2 = 16'b00000_11111010001;
    localparam [15:0] std_dev_0_3 = 16'b00000_11110111010;
    localparam [15:0] std_dev_0_4 = 16'b00000_11110100011;
    localparam [15:0] std_dev_0_5 = 16'b00000_11110001101;
    localparam [15:0] std_dev_0_6 = 16'b00000_11101110111;
    localparam [15:0] std_dev_0_7 = 16'b00000_11101100001;
    localparam [15:0] std_dev_0_8 = 16'b00000_11101001011;
    localparam [15:0] std_dev_0_9 = 16'b00000_11100110110;
    localparam [15:0] std_dev_1_0 = 16'b00000_11100100001;
    localparam [15:0] std_dev_1_1 = 16'b00000_11100001100;
    localparam [15:0] std_dev_1_2 = 16'b00000_11011110111;
    localparam [15:0] std_dev_1_3 = 16'b00000_11011100011;
    localparam [15:0] std_dev_1_4 = 16'b00000_11011001111;
    localparam [15:0] std_dev_1_5 = 16'b00000_11010111011;
    localparam [15:0] std_dev_1_6 = 16'b00000_11010100111;
    localparam [15:0] std_dev_1_7 = 16'b00000_11010010011;
    localparam [15:0] std_dev_1_8 = 16'b00000_11010000000;
    localparam [15:0] std_dev_1_9 = 16'b00000_11001101101;
    localparam [15:0] std_dev_2_0 = 16'b00000_11001011010;
    localparam [15:0] std_dev_2_1 = 16'b00000_11001001000;
    localparam [15:0] std_dev_2_2 = 16'b00000_11000110101;
    localparam [15:0] std_dev_2_3 = 16'b00000_11000100011;
    localparam [15:0] std_dev_2_4 = 16'b00000_11000010001;
    localparam [15:0] std_dev_2_5 = 16'b00000_10111111111;
    localparam [15:0] std_dev_2_6 = 16'b00000_10111101110;
    localparam [15:0] std_dev_2_7 = 16'b00000_10111011100;
    localparam [15:0] std_dev_2_8 = 16'b00000_10111001011;
    localparam [15:0] std_dev_2_9 = 16'b00000_10110111010;
    localparam [15:0] std_dev_3_0 = 16'b00000_10110101001;
    localparam [15:0] std_dev_3_1 = 16'b00000_10110011001;
    localparam [15:0] std_dev_3_2 = 16'b00000_10110001000;
    localparam [15:0] std_dev_3_3 = 16'b00000_10101111000;
    localparam [15:0] std_dev_3_4 = 16'b00000_10101101000;
    localparam [15:0] std_dev_3_5 = 16'b00000_10101011000;
    localparam [15:0] std_dev_3_6 = 16'b00000_10101001001;
    localparam [15:0] std_dev_3_7 = 16'b00000_10100111001;
    localparam [15:0] std_dev_3_8 = 16'b00000_10100101010;
    localparam [15:0] std_dev_3_9 = 16'b00000_10100011011;
    localparam [15:0] std_dev_4_0 = 16'b00000_10100001100;
    localparam [15:0] std_dev_4_1 = 16'b00000_10011111101;
    localparam [15:0] std_dev_4_2 = 16'b00000_10011101110;
    localparam [15:0] std_dev_4_3 = 16'b00000_10011100000;
    localparam [15:0] std_dev_4_4 = 16'b00000_10011010010;
    localparam [15:0] std_dev_4_5 = 16'b00000_10011000011;
    localparam [15:0] std_dev_4_6 = 16'b00000_10010110101;
    localparam [15:0] std_dev_4_7 = 16'b00000_10010101000;
    localparam [15:0] std_dev_4_8 = 16'b00000_10010011010;
    localparam [15:0] std_dev_4_9 = 16'b00000_10010001101;
    localparam [15:0] std_dev_5_0 = 16'b00000_10001111111;
    localparam [15:0] std_dev_5_1 = 16'b00000_10001110010;
    localparam [15:0] std_dev_5_2 = 16'b00000_10001100101;
    localparam [15:0] std_dev_5_3 = 16'b00000_10001011000;
    localparam [15:0] std_dev_5_4 = 16'b00000_10001001011;
    localparam [15:0] std_dev_5_5 = 16'b00000_10000111111;
    localparam [15:0] std_dev_5_6 = 16'b00000_10000110010;
    localparam [15:0] std_dev_5_7 = 16'b00000_10000100110;
    localparam [15:0] std_dev_5_8 = 16'b00000_10000011010;
    localparam [15:0] std_dev_5_9 = 16'b00000_10000001110;
    localparam [15:0] std_dev_6_0 = 16'b00000_10000000010; 	
`elsif CODE_RATE_075
	localparam [15:0] std_dev_0_0 = 16'b00000_11010001000;
	localparam [15:0] std_dev_0_1 = 16'b00000_11001110101;
	localparam [15:0] std_dev_0_2 = 16'b00000_11001100010;
	localparam [15:0] std_dev_0_3 = 16'b00000_11001001111;
	localparam [15:0] std_dev_0_4 = 16'b00000_11000111100;
	localparam [15:0] std_dev_0_5 = 16'b00000_11000101010;
	localparam [15:0] std_dev_0_6 = 16'b00000_11000011000;
	localparam [15:0] std_dev_0_7 = 16'b00000_11000000110;
	localparam [15:0] std_dev_0_8 = 16'b00000_10111110101;
	localparam [15:0] std_dev_0_9 = 16'b00000_10111100011;
	localparam [15:0] std_dev_1_0 = 16'b00000_10111010010;
	localparam [15:0] std_dev_1_1 = 16'b00000_10111000001;
	localparam [15:0] std_dev_1_2 = 16'b00000_10110110000;
	localparam [15:0] std_dev_1_3 = 16'b00000_10110011111;
	localparam [15:0] std_dev_1_4 = 16'b00000_10110001111;
	localparam [15:0] std_dev_1_5 = 16'b00000_10101111110;
	localparam [15:0] std_dev_1_6 = 16'b00000_10101101110;
	localparam [15:0] std_dev_1_7 = 16'b00000_10101011110;
	localparam [15:0] std_dev_1_8 = 16'b00000_10101001111;
	localparam [15:0] std_dev_1_9 = 16'b00000_10100111111;
	localparam [15:0] std_dev_2_0 = 16'b00000_10100110000;
	localparam [15:0] std_dev_2_1 = 16'b00000_10100100001;
	localparam [15:0] std_dev_2_2 = 16'b00000_10100010010;
	localparam [15:0] std_dev_2_3 = 16'b00000_10100000011;
	localparam [15:0] std_dev_2_4 = 16'b00000_10011110100;
	localparam [15:0] std_dev_2_5 = 16'b00000_10011100101;
	localparam [15:0] std_dev_2_6 = 16'b00000_10011010111;
	localparam [15:0] std_dev_2_7 = 16'b00000_10011001001;
	localparam [15:0] std_dev_2_8 = 16'b00000_10010111011;
	localparam [15:0] std_dev_2_9 = 16'b00000_10010101101;
	localparam [15:0] std_dev_3_0 = 16'b00000_10010011111;
	localparam [15:0] std_dev_3_1 = 16'b00000_10010010010;
	localparam [15:0] std_dev_3_2 = 16'b00000_10010000100;
	localparam [15:0] std_dev_3_3 = 16'b00000_10001110111;
	localparam [15:0] std_dev_3_4 = 16'b00000_10001101010;
	localparam [15:0] std_dev_3_5 = 16'b00000_10001011101;
	localparam [15:0] std_dev_3_6 = 16'b00000_10001010000;
	localparam [15:0] std_dev_3_7 = 16'b00000_10001000100;
	localparam [15:0] std_dev_3_8 = 16'b00000_10000110111;
	localparam [15:0] std_dev_3_9 = 16'b00000_10000101011;
	localparam [15:0] std_dev_4_0 = 16'b00000_10000011111;
	localparam [15:0] std_dev_4_1 = 16'b00000_10000010011;
	localparam [15:0] std_dev_4_2 = 16'b00000_10000000111;
	localparam [15:0] std_dev_4_3 = 16'b00000_01111111011;
	localparam [15:0] std_dev_4_4 = 16'b00000_01111101111;
	localparam [15:0] std_dev_4_5 = 16'b00000_01111100100;
	localparam [15:0] std_dev_4_6 = 16'b00000_01111011000;
	localparam [15:0] std_dev_4_7 = 16'b00000_01111001101;
	localparam [15:0] std_dev_4_8 = 16'b00000_01111000010;
	localparam [15:0] std_dev_4_9 = 16'b00000_01110110111;
	localparam [15:0] std_dev_5_0 = 16'b00000_01110101100;
	localparam [15:0] std_dev_5_1 = 16'b00000_01110100001;
	localparam [15:0] std_dev_5_2 = 16'b00000_01110010110;
	localparam [15:0] std_dev_5_3 = 16'b00000_01110001100;
	localparam [15:0] std_dev_5_4 = 16'b00000_01110000010;
	localparam [15:0] std_dev_5_5 = 16'b00000_01101110111;
	localparam [15:0] std_dev_5_6 = 16'b00000_01101000110;
	localparam [15:0] std_dev_5_7 = 16'b00000_01101101101;
	localparam [15:0] std_dev_5_8 = 16'b00000_01101100011;
	localparam [15:0] std_dev_5_9 = 16'b00000_01101011001;
	localparam [15:0] std_dev_6_0 = 16'b00000_01101001111;
`elsif CODE_RATE_060
	localparam [15:0] std_dev_0_0 = 16'b00000_11101001101;
	localparam [15:0] std_dev_0_1 = 16'b00000_11100111000;
	localparam [15:0] std_dev_0_2 = 16'b00000_11100100011;
	localparam [15:0] std_dev_0_3 = 16'b00000_11100001110;
	localparam [15:0] std_dev_0_4 = 16'b00000_11011111001;
	localparam [15:0] std_dev_0_5 = 16'b00000_11011100100;
	localparam [15:0] std_dev_0_6 = 16'b00000_11011010000;
	localparam [15:0] std_dev_0_7 = 16'b00000_11010111100;
	localparam [15:0] std_dev_0_8 = 16'b00000_11010101001;
	localparam [15:0] std_dev_0_9 = 16'b00000_11010010101;
	localparam [15:0] std_dev_1_0 = 16'b00000_11010000010;
	localparam [15:0] std_dev_1_1 = 16'b00000_11001101111;
	localparam [15:0] std_dev_1_2 = 16'b00000_11001011100;
	localparam [15:0] std_dev_1_3 = 16'b00000_11001001001;
	localparam [15:0] std_dev_1_4 = 16'b00000_11000110111;
	localparam [15:0] std_dev_1_5 = 16'b00000_11000100101;
	localparam [15:0] std_dev_1_6 = 16'b00000_11000010011;
	localparam [15:0] std_dev_1_7 = 16'b00000_11000000001;
	localparam [15:0] std_dev_1_8 = 16'b00000_10111101111;
	localparam [15:0] std_dev_1_9 = 16'b00000_10111011110;
	localparam [15:0] std_dev_2_0 = 16'b00000_10111001101;
	localparam [15:0] std_dev_2_1 = 16'b00000_10110111100;
	localparam [15:0] std_dev_2_2 = 16'b00000_10110101011;
	localparam [15:0] std_dev_2_3 = 16'b00000_10110011010;
	localparam [15:0] std_dev_2_4 = 16'b00000_10110001010;
	localparam [15:0] std_dev_2_5 = 16'b00000_10101111001;
	localparam [15:0] std_dev_2_6 = 16'b00000_10101101001;
	localparam [15:0] std_dev_2_7 = 16'b00000_10101011010;
	localparam [15:0] std_dev_2_8 = 16'b00000_10101001010;
	localparam [15:0] std_dev_2_9 = 16'b00000_10100111010;
	localparam [15:0] std_dev_3_0 = 16'b00000_10100101011;
	localparam [15:0] std_dev_3_1 = 16'b00000_10100011100;
	localparam [15:0] std_dev_3_2 = 16'b00000_10100001101;
	localparam [15:0] std_dev_3_3 = 16'b00000_10011111110;
	localparam [15:0] std_dev_3_4 = 16'b00000_10011101111;
	localparam [15:0] std_dev_3_5 = 16'b00000_10011100001;
	localparam [15:0] std_dev_3_6 = 16'b00000_10011010011;
	localparam [15:0] std_dev_3_7 = 16'b00000_10011000101;
	localparam [15:0] std_dev_3_8 = 16'b00000_10010110111;
	localparam [15:0] std_dev_3_9 = 16'b00000_10010101001;
	localparam [15:0] std_dev_4_0 = 16'b00000_10010011011;
	localparam [15:0] std_dev_4_1 = 16'b00000_10010001110;
	localparam [15:0] std_dev_4_2 = 16'b00000_10010000000;
	localparam [15:0] std_dev_4_3 = 16'b00000_10001110011;
	localparam [15:0] std_dev_4_4 = 16'b00000_10001100110;
	localparam [15:0] std_dev_4_5 = 16'b00000_10001011001;
	localparam [15:0] std_dev_4_6 = 16'b00000_10001001100;
	localparam [15:0] std_dev_4_7 = 16'b00000_10001000000;
	localparam [15:0] std_dev_4_8 = 16'b00000_10000110011;
	localparam [15:0] std_dev_4_9 = 16'b00000_10000100111;
	localparam [15:0] std_dev_5_0 = 16'b00000_10000011011;
	localparam [15:0] std_dev_5_1 = 16'b00000_10000001111;
	localparam [15:0] std_dev_5_2 = 16'b00000_10000000011;
	localparam [15:0] std_dev_5_3 = 16'b00000_01111110111;
	localparam [15:0] std_dev_5_4 = 16'b00000_01111101100;
	localparam [15:0] std_dev_5_5 = 16'b00000_01111100000;
	localparam [15:0] std_dev_5_6 = 16'b00000_01111010101;
	localparam [15:0] std_dev_5_7 = 16'b00000_01111001001;
	localparam [15:0] std_dev_5_8 = 16'b00000_01110111110;
	localparam [15:0] std_dev_5_9 = 16'b00000_01110110011;
	localparam [15:0] std_dev_6_0 = 16'b00000_01110101000;
`elsif CODE_RATE_065
	localparam [15:0] std_dev_0_0 = 16'b00000_11100000100;
	localparam [15:0] std_dev_0_1 = 16'b00000_11011101111;
	localparam [15:0] std_dev_0_2 = 16'b00000_11011011011;
	localparam [15:0] std_dev_0_3 = 16'b00000_11011000111;
	localparam [15:0] std_dev_0_4 = 16'b00000_11010110011;
	localparam [15:0] std_dev_0_5 = 16'b00000_11010011111;
	localparam [15:0] std_dev_0_6 = 16'b00000_11010001100;
	localparam [15:0] std_dev_0_7 = 16'b00000_11001111001;
	localparam [15:0] std_dev_0_8 = 16'b00000_11001100110;
	localparam [15:0] std_dev_0_9 = 16'b00000_11001010011;
	localparam [15:0] std_dev_1_0 = 16'b00000_11001000000;
	localparam [15:0] std_dev_1_1 = 16'b00000_11000101110;
	localparam [15:0] std_dev_1_2 = 16'b00000_11000011100;
	localparam [15:0] std_dev_1_3 = 16'b00000_11000001010;
	localparam [15:0] std_dev_1_4 = 16'b00000_10111111000;
	localparam [15:0] std_dev_1_5 = 16'b00000_10111100111;
	localparam [15:0] std_dev_1_6 = 16'b00000_10111010110;
	localparam [15:0] std_dev_1_7 = 16'b00000_10111000100;
	localparam [15:0] std_dev_1_8 = 16'b00000_10110110100;
	localparam [15:0] std_dev_1_9 = 16'b00000_10110100011;
	localparam [15:0] std_dev_2_0 = 16'b00000_10110010010;
	localparam [15:0] std_dev_2_1 = 16'b00000_10110000010;
	localparam [15:0] std_dev_2_2 = 16'b00000_10101110010;
	localparam [15:0] std_dev_2_3 = 16'b00000_10101100010;
	localparam [15:0] std_dev_2_4 = 16'b00000_10101010010;
	localparam [15:0] std_dev_2_5 = 16'b00000_10101000010;
	localparam [15:0] std_dev_2_6 = 16'b00000_10100110011;
	localparam [15:0] std_dev_2_7 = 16'b00000_10100100100;
	localparam [15:0] std_dev_2_8 = 16'b00000_10100010101;
	localparam [15:0] std_dev_2_9 = 16'b00000_10100000110;
	localparam [15:0] std_dev_3_0 = 16'b00000_10011110111;
	localparam [15:0] std_dev_3_1 = 16'b00000_10011101001;
	localparam [15:0] std_dev_3_2 = 16'b00000_10011011010;
	localparam [15:0] std_dev_3_3 = 16'b00000_10011001100;
	localparam [15:0] std_dev_3_4 = 16'b00000_10010111110;
	localparam [15:0] std_dev_3_5 = 16'b00000_10010110000;
	localparam [15:0] std_dev_3_6 = 16'b00000_10010100010;
	localparam [15:0] std_dev_3_7 = 16'b00000_10010010101;
	localparam [15:0] std_dev_3_8 = 16'b00000_10010000111;
	localparam [15:0] std_dev_3_9 = 16'b00000_10001111010;
	localparam [15:0] std_dev_4_0 = 16'b00000_10001101101;
	localparam [15:0] std_dev_4_1 = 16'b00000_10001100000;
	localparam [15:0] std_dev_4_2 = 16'b00000_10001010011;
	localparam [15:0] std_dev_4_3 = 16'b00000_10001000110;
	localparam [15:0] std_dev_4_4 = 16'b00000_10000111010;
	localparam [15:0] std_dev_4_5 = 16'b00000_10000101101;
	localparam [15:0] std_dev_4_6 = 16'b00000_10000100001;
	localparam [15:0] std_dev_4_7 = 16'b00000_10000010101;
	localparam [15:0] std_dev_4_8 = 16'b00000_10000001001;
	localparam [15:0] std_dev_4_9 = 16'b00000_01111111101;
	localparam [15:0] std_dev_5_0 = 16'b00000_01111110010;
	localparam [15:0] std_dev_5_1 = 16'b00000_01111100110;
	localparam [15:0] std_dev_5_2 = 16'b00000_01111011011;
	localparam [15:0] std_dev_5_3 = 16'b00000_01111001111;
	localparam [15:0] std_dev_5_4 = 16'b00000_01111000100;
	localparam [15:0] std_dev_5_5 = 16'b00000_01110111001;
	localparam [15:0] std_dev_5_6 = 16'b00000_01110101110;
	localparam [15:0] std_dev_5_7 = 16'b00000_01110100011;
	localparam [15:0] std_dev_5_8 = 16'b00000_01110011001;
	localparam [15:0] std_dev_5_9 = 16'b00000_01110001110;
	localparam [15:0] std_dev_6_0 = 16'b00000_01110000100;
`elsif CODE_RATE_070
	localparam [15:0] std_dev_0_0 = 16'b00000_11011000010;
	localparam [15:0] std_dev_0_1 = 16'b00000_11010101111;
	localparam [15:0] std_dev_0_2 = 16'b00000_11010011011;
	localparam [15:0] std_dev_0_3 = 16'b00000_11010001000;
	localparam [15:0] std_dev_0_4 = 16'b00000_11001110100;
	localparam [15:0] std_dev_0_5 = 16'b00000_11001100010;
	localparam [15:0] std_dev_0_6 = 16'b00000_11001001111;
	localparam [15:0] std_dev_0_7 = 16'b00000_11000111100;
	localparam [15:0] std_dev_0_8 = 16'b00000_11000101010;
	localparam [15:0] std_dev_0_9 = 16'b00000_11000011000;
	localparam [15:0] std_dev_1_0 = 16'b00000_11000000110;
	localparam [15:0] std_dev_1_1 = 16'b00000_10111110100;
	localparam [15:0] std_dev_1_2 = 16'b00000_10111100011;
	localparam [15:0] std_dev_1_3 = 16'b00000_10111010010;
	localparam [15:0] std_dev_1_4 = 16'b00000_10111000001;
	localparam [15:0] std_dev_1_5 = 16'b00000_10110110000;
	localparam [15:0] std_dev_1_6 = 16'b00000_10110011111;
	localparam [15:0] std_dev_1_7 = 16'b00000_10110001111;
	localparam [15:0] std_dev_1_8 = 16'b00000_10101111110;
	localparam [15:0] std_dev_1_9 = 16'b00000_10101101110;
	localparam [15:0] std_dev_2_0 = 16'b00000_10101011110;
	localparam [15:0] std_dev_2_1 = 16'b00000_10101001111;
	localparam [15:0] std_dev_2_2 = 16'b00000_10100111111;
	localparam [15:0] std_dev_2_3 = 16'b00000_10100110000;
	localparam [15:0] std_dev_2_4 = 16'b00000_10100100001;
	localparam [15:0] std_dev_2_5 = 16'b00000_10100010001;
	localparam [15:0] std_dev_2_6 = 16'b00000_10100000011;
	localparam [15:0] std_dev_2_7 = 16'b00000_10011110100;
	localparam [15:0] std_dev_2_8 = 16'b00000_10011100101;
	localparam [15:0] std_dev_2_9 = 16'b00000_10011010111;
	localparam [15:0] std_dev_3_0 = 16'b00000_10011001001;
	localparam [15:0] std_dev_3_1 = 16'b00000_10010111011;
	localparam [15:0] std_dev_3_2 = 16'b00000_10010101101;
	localparam [15:0] std_dev_3_3 = 16'b00000_10010011111;
	localparam [15:0] std_dev_3_4 = 16'b00000_10010010010;
	localparam [15:0] std_dev_3_5 = 16'b00000_10010000100;
	localparam [15:0] std_dev_3_6 = 16'b00000_10001110111;
	localparam [15:0] std_dev_3_7 = 16'b00000_10001101010;
	localparam [15:0] std_dev_3_8 = 16'b00000_10001011101;
	localparam [15:0] std_dev_3_9 = 16'b00000_10001010000;
	localparam [15:0] std_dev_4_0 = 16'b00000_10001000100;
	localparam [15:0] std_dev_4_1 = 16'b00000_10000110111;
	localparam [15:0] std_dev_4_2 = 16'b00000_10000101011;
	localparam [15:0] std_dev_4_3 = 16'b00000_10000011111;
	localparam [15:0] std_dev_4_4 = 16'b00000_10000010010;
	localparam [15:0] std_dev_4_5 = 16'b00000_10000000111;
	localparam [15:0] std_dev_4_6 = 16'b00000_01111111011;
	localparam [15:0] std_dev_4_7 = 16'b00000_01111101111;
	localparam [15:0] std_dev_4_8 = 16'b00000_01111100100;
	localparam [15:0] std_dev_4_9 = 16'b00000_01111011000;
	localparam [15:0] std_dev_5_0 = 16'b00000_01111001101;
	localparam [15:0] std_dev_5_1 = 16'b00000_01111000010;
	localparam [15:0] std_dev_5_2 = 16'b00000_01110110111;
	localparam [15:0] std_dev_5_3 = 16'b00000_01110101100;
	localparam [15:0] std_dev_5_4 = 16'b00000_01110100001;
	localparam [15:0] std_dev_5_5 = 16'b00000_01110010110;
	localparam [15:0] std_dev_5_6 = 16'b00000_01110001100;
	localparam [15:0] std_dev_5_7 = 16'b00000_01110000001;
	localparam [15:0] std_dev_5_8 = 16'b00000_01101110111;
	localparam [15:0] std_dev_5_9 = 16'b00000_01101101101;
	localparam [15:0] std_dev_6_0 = 16'b00000_01101100011;
`else // code rate = 1.0
	localparam [15:0] std_dev_0_0 = 16'b00000_10110101000;
    localparam [15:0] std_dev_0_1 = 16'b00000_10110010111;
    localparam [15:0] std_dev_0_2 = 16'b00000_10110000111;
    localparam [15:0] std_dev_0_3 = 16'b00000_10101110110;
    localparam [15:0] std_dev_0_4 = 16'b00000_10101100110;
    localparam [15:0] std_dev_0_5 = 16'b00000_10101010111;
    localparam [15:0] std_dev_0_6 = 16'b00000_10101000111;
    localparam [15:0] std_dev_0_7 = 16'b00000_10100111000;
    localparam [15:0] std_dev_0_8 = 16'b00000_10100101000;
    localparam [15:0] std_dev_0_9 = 16'b00000_10100011001;
    localparam [15:0] std_dev_1_0 = 16'b00000_10100001010;
    localparam [15:0] std_dev_1_1 = 16'b00000_10011111011;
    localparam [15:0] std_dev_1_2 = 16'b00000_10011101101;
    localparam [15:0] std_dev_1_3 = 16'b00000_10011011110;
    localparam [15:0] std_dev_1_4 = 16'b00000_10011010000;
    localparam [15:0] std_dev_1_5 = 16'b00000_10011000010;
    localparam [15:0] std_dev_1_6 = 16'b00000_10010110100;
    localparam [15:0] std_dev_1_7 = 16'b00000_10010100110;
    localparam [15:0] std_dev_1_8 = 16'b00000_10010011001;
    localparam [15:0] std_dev_1_9 = 16'b00000_10010001011;
    localparam [15:0] std_dev_2_0 = 16'b00000_10001111110;
    localparam [15:0] std_dev_2_1 = 16'b00000_10001110001;
    localparam [15:0] std_dev_2_2 = 16'b00000_10001100100;
    localparam [15:0] std_dev_2_3 = 16'b00000_10001010111;
    localparam [15:0] std_dev_2_4 = 16'b00000_10001001010;
    localparam [15:0] std_dev_2_5 = 16'b00000_10000111101;
    localparam [15:0] std_dev_2_6 = 16'b00000_10000110001;
    localparam [15:0] std_dev_2_7 = 16'b00000_10000100101;
    localparam [15:0] std_dev_2_8 = 16'b00000_10000011001;
    localparam [15:0] std_dev_2_9 = 16'b00000_10000001101;
    localparam [15:0] std_dev_3_0 = 16'b00000_10000000001;
    localparam [15:0] std_dev_3_1 = 16'b00000_01111110101;
    localparam [15:0] std_dev_3_2 = 16'b00000_01111101001;
    localparam [15:0] std_dev_3_3 = 16'b00000_01111011110;
    localparam [15:0] std_dev_3_4 = 16'b00000_01111010011;
    localparam [15:0] std_dev_3_5 = 16'b00000_01111000111;
    localparam [15:0] std_dev_3_6 = 16'b00000_01110111100;
    localparam [15:0] std_dev_3_7 = 16'b00000_01110110001;
    localparam [15:0] std_dev_3_8 = 16'b00000_01110100111;
    localparam [15:0] std_dev_3_9 = 16'b00000_01110011100;
    localparam [15:0] std_dev_4_0 = 16'b00000_01110010001;
    localparam [15:0] std_dev_4_1 = 16'b00000_01110000111;
    localparam [15:0] std_dev_4_2 = 16'b00000_01101111100;
    localparam [15:0] std_dev_4_3 = 16'b00000_01101110010;
    localparam [15:0] std_dev_4_4 = 16'b00000_01101101000;
    localparam [15:0] std_dev_4_5 = 16'b00000_01101011110;
    localparam [15:0] std_dev_4_6 = 16'b00000_01101010100;
    localparam [15:0] std_dev_4_7 = 16'b00000_01101001010;
    localparam [15:0] std_dev_4_8 = 16'b00000_01101000001;
    localparam [15:0] std_dev_4_9 = 16'b00000_01100110111;
    localparam [15:0] std_dev_5_0 = 16'b00000_01100101110;
    localparam [15:0] std_dev_5_1 = 16'b00000_01100100101;
    localparam [15:0] std_dev_5_2 = 16'b00000_01100011011;
    localparam [15:0] std_dev_5_3 = 16'b00000_01100010010;
    localparam [15:0] std_dev_5_4 = 16'b00000_01100001001;
    localparam [15:0] std_dev_5_5 = 16'b00000_01100000000;
    localparam [15:0] std_dev_5_6 = 16'b00000_01011111000;
    localparam [15:0] std_dev_5_7 = 16'b00000_01011101111;
    localparam [15:0] std_dev_5_8 = 16'b00000_01011100110;
    localparam [15:0] std_dev_5_9 = 16'b00000_01011011110;
    localparam [15:0] std_dev_6_0 = 16'b00000_01011010101;
`endif
	wire [15:0] sigma_in [0:SNR_SET_NUM-1];
	assign sigma_in[0 ] = std_dev_0_0[15:0];
	assign sigma_in[1 ] = std_dev_0_1[15:0];
	assign sigma_in[2 ] = std_dev_0_2[15:0];
	assign sigma_in[3 ] = std_dev_0_3[15:0];
	assign sigma_in[4 ] = std_dev_0_4[15:0];
	assign sigma_in[5 ] = std_dev_0_5[15:0];
	assign sigma_in[6 ] = std_dev_0_6[15:0];
	assign sigma_in[7 ] = std_dev_0_7[15:0];
	assign sigma_in[8 ] = std_dev_0_8[15:0];
	assign sigma_in[9 ] = std_dev_0_9[15:0];
	assign sigma_in[10] = std_dev_1_0[15:0];
	assign sigma_in[11] = std_dev_1_1[15:0];
	assign sigma_in[12] = std_dev_1_2[15:0];
	assign sigma_in[13] = std_dev_1_3[15:0];
	assign sigma_in[14] = std_dev_1_4[15:0];
	assign sigma_in[15] = std_dev_1_5[15:0];
	assign sigma_in[16] = std_dev_1_6[15:0];
	assign sigma_in[17] = std_dev_1_7[15:0];
	assign sigma_in[18] = std_dev_1_8[15:0];
	assign sigma_in[19] = std_dev_1_9[15:0];
	assign sigma_in[20] = std_dev_2_0[15:0];
	assign sigma_in[21] = std_dev_2_1[15:0];
	assign sigma_in[22] = std_dev_2_2[15:0];
	assign sigma_in[23] = std_dev_2_3[15:0];
	assign sigma_in[24] = std_dev_2_4[15:0];
	assign sigma_in[25] = std_dev_2_5[15:0];
	assign sigma_in[26] = std_dev_2_6[15:0];
	assign sigma_in[27] = std_dev_2_7[15:0];
	assign sigma_in[28] = std_dev_2_8[15:0];
	assign sigma_in[29] = std_dev_2_9[15:0];
	assign sigma_in[30] = std_dev_3_0[15:0];
	assign sigma_in[31] = std_dev_3_1[15:0];
	assign sigma_in[32] = std_dev_3_2[15:0];
	assign sigma_in[33] = std_dev_3_3[15:0];
	assign sigma_in[34] = std_dev_3_4[15:0];
	assign sigma_in[35] = std_dev_3_5[15:0];
	assign sigma_in[36] = std_dev_3_6[15:0];
	assign sigma_in[37] = std_dev_3_7[15:0];
	assign sigma_in[38] = std_dev_3_8[15:0];
	assign sigma_in[39] = std_dev_3_9[15:0];
	assign sigma_in[40] = std_dev_4_0[15:0];	
	assign sigma_in[41] = std_dev_4_1[15:0];
	assign sigma_in[42] = std_dev_4_2[15:0];
	assign sigma_in[43] = std_dev_4_3[15:0];
	assign sigma_in[44] = std_dev_4_4[15:0];
	assign sigma_in[45] = std_dev_4_5[15:0];
	assign sigma_in[46] = std_dev_4_6[15:0];
	assign sigma_in[47] = std_dev_4_7[15:0];
	assign sigma_in[48] = std_dev_4_8[15:0];
	assign sigma_in[49] = std_dev_4_9[15:0];
	assign sigma_in[50] = std_dev_5_0[15:0];
	assign sigma_in[51] = std_dev_5_1[15:0];
	assign sigma_in[52] = std_dev_5_2[15:0];
	assign sigma_in[53] = std_dev_5_3[15:0];
	assign sigma_in[54] = std_dev_5_4[15:0];
	assign sigma_in[55] = std_dev_5_5[15:0];
	assign sigma_in[56] = std_dev_5_6[15:0];
	assign sigma_in[57] = std_dev_5_7[15:0];
	assign sigma_in[58] = std_dev_5_8[15:0];
	assign sigma_in[59] = std_dev_5_9[15:0];
	assign sigma_in[60] = std_dev_6_0[15:0];

    wire snr_next_sync; assign snr_next_sync = (|snr_next_reg[7:0]);
	reg [SNR_PACKET_SIZE-1:0] snr_packet;
	receivedBlock_generator #(
		.N (`VN_NUM), // block length
		.NG_NUM (`NG_NUM), // 17 codeword segments
		.NG_SIZE (`NG_SIZE), // the number of codebits in each codeword segment
		.QUAN_SIZE (`QUAN_SIZE)// 4-bit quantisation for each channel message
	) block_gen_u0(
		.coded_block (coded_block[N*QUAN_SIZE-1:0]),
		.tvalid_master (tvalid_master),
		
		.sigma_in (sigma_in[snr_packet[SNR_PACKET_SIZE-1:0]]),
		//input wire [63:0] seed_base_0,
		//input wire [63:0] seed_base_1,
		//input wire [63:0] seed_base_2,
		.ready_slave (1'b1),//(ready_slave),
		.rstn (sys_rstn),//(~snr_next_sync && sys_rstn),//(sys_rstn),
		.sys_clk (awgn_gen_clk)
	);
/*-----------------------------------------------------------------------------------------------------------------*/
// Instantiation of Decoder unit
generate
	genvar n;
	for(n = 0; n < N/2; n=n+1) begin : ch_msg_assignment
	   always @(posedge awgn_gen_clk) begin
	        if((~snr_next_sync && sys_rstn) == 1'b0) ch_msg[n] <= {QUAN_SIZE{1'b1}};
	        //else if(coded_block[ ((n+1)*QUAN_SIZE)-1 : (n*QUAN_SIZE) ] <= 3) ch_msg[n] <= 15;
            else ch_msg[n] <= coded_block[ ((n+1)*QUAN_SIZE)-1 : (n*QUAN_SIZE) ];
		end
	end

	for(n = N/2; n < N; n=n+1) begin : ch_msg_assignment1
	   always @(posedge awgn_gen_clk) begin
	        if((~snr_next_sync && sys_rstn) == 1'b0) ch_msg[n] <= {QUAN_SIZE{1'b1}};
	        //else if(coded_block[ ((n+1)*QUAN_SIZE)-1 : (n*QUAN_SIZE) ] <= 3) ch_msg[n] <= 15;
            else ch_msg[n] <= coded_block[ ((n+1)*QUAN_SIZE)-1 : (n*QUAN_SIZE) ];
		end
	end
endgenerate
/*-----------------------------------------------------------------------------------------------------------------*/
// Reset Signal for main decoder module 
// Note that in the first codeword decoding process, 
// the reset signal will be kept asserted until the first codeword is generated, i.e., 
// the timing of first assertion of receivedBlock_generator.tvalid_master
//(* max_fanout = 50 *) reg decoder_rstn; initial decoder_rstn <= 1'b0;
reg decoder_rstn; initial decoder_rstn <= 1'b0;
reg decode_termination_reg; initial decode_termination_reg <= 0;
always @(posedge awgn_gen_clk) begin if(!sys_rstn) decode_termination_reg <= 0; else decode_termination_reg <= decode_termination; end
always @(posedge awgn_gen_clk, negedge sys_rstn) begin
	if(sys_rstn == 1'b0) 
		decoder_rstn <= 1'b0;
	else begin
		if(tvalid_master == 1'b1 && snr_next_sync == 1'b0) decoder_rstn <= 1'b1 && (~decode_termination_reg);
		else if(tvalid_master == 1'b1 && snr_next_sync == 1'b1) decoder_rstn <= 1'b0 && (~decode_termination_reg);
		else if(tvalid_master == 1'b0 && snr_next_sync == 1'b1) decoder_rstn <= 1'b0 && (~decode_termination_reg);
		else decoder_rstn <= decoder_rstn && (~decode_termination_reg);
	end
end
/*-----------------------------------------------------------------------------------------------------------------*/
entire_decoder_tb #(
	.CN_NUM   	(`CN_NUM),// # CNsc2v_latch
	.VN_NUM   	(`VN_NUM),// # VNs 
	.VN_DEGREE	(`VN_DEGREE),// degree of one variable node
	.CN_DEGREE	(`CN_DEGREE),// degree of one check node 
	
	.IB_ROM_SIZE          (`IB_ROM_SIZE         ), // width of one read-out port of RAMB36E1
	.IB_ROM_ADDR_WIDTH    (`IB_ROM_ADDR_WIDTH   ), // ceil(log2(64-entry)) = 6-bit 
	.IB_CNU_DECOMP_funNum (`IB_CNU_DECOMP_funNum),
	.IB_VNU_DECOMP_funNum (`IB_VNU_DECOMP_funNum),
	.IB_DNU_DECOMP_funNum (`IB_DNU_DECOMP_funNum),
	.ITER_ADDR_BW         (`ITER_ADDR_BW        ),  // bit-width of addressing 50 iterationss
    .ITER_ROM_GROUP       (`ITER_ROM_GROUP      ), // the number of iteration datasets stored in one Group of IB-ROMs
	.MAX_ITER             (`MAX_ITER            ),

	.CNU6_INSTANTIATE_NUM  (`CNU6_INSTANTIATE_NUM ),
	.CNU6_INSTANTIATE_UNIT (`CNU6_INSTANTIATE_UNIT),
	.VNU3_INSTANTIATE_NUM  (`VNU3_INSTANTIATE_NUM ),
	.VNU3_INSTANTIATE_UNIT (`VNU3_INSTANTIATE_UNIT),
	
	.QUAN_SIZE      (`QUAN_SIZE     ),
	.DATAPATH_WIDTH (`DATAPATH_WIDTH),
	
	/*CNUs*/
	.CN_ROM_RD_BW   (`CN_ROM_RD_BW  ),    // bit-width of one read port of BRAM based IB-ROM
	.CN_ROM_ADDR_BW (`CN_ROM_ADDR_BW),  // bit-width of read address of BRAM based IB-ROM
								// #Entry: (64-entry*3-bit) / ROM_RD_BW)*25-iteration
								// ceil(log2(#Entry)) = 10-bit
	.CN_OVERPROVISION (`CN_OVERPROVISION), // the over-counted IB-ROM read address							
	.CN_PAGE_ADDR_BW  (`CN_PAGE_ADDR_BW ), // bit-width of addressing (64-entry*3-bit)/ROM_RD_BW), i.e., ceil(log2((64-entry*3-bit)/ROM_RD_BW)))								
	.CN_ITER_ADDR_BW  (`CN_ITER_ADDR_BW ),  // bit-width of addressing 25 iterationss
	//parameter CN_TYPE_A = 1,    // the number of check node type in terms of its check node degree   
	//parameter CN_TYPE_B = 1,     // the number of check node type in terms of its check node degree
	.CN_LOAD_CYCLE     (`CN_LOAD_CYCLE    ),// 64-entry with two interleaving banks requires 32 clock cycle to finish iteration update
	.CN_RD_BW          (`CN_RD_BW         ),
	.CN_ADDR_BW        (`CN_ADDR_BW       ),
	.CN_PIPELINE_DEPTH (`CN_PIPELINE_DEPTH),
	
	/*VNUs and DNUs*/
	.VN_QUAN_SIZE   (`VN_QUAN_SIZE  ),
	.VN_ROM_RD_BW   (`VN_ROM_RD_BW  ), // bit-width of one read port of BRAM based IB-ROM
	.VN_ROM_ADDR_BW (`VN_ROM_ADDR_BW), // bit-width of read address of BRAM based IB-ROM
								       // #Entry: (128-entry*4-bit) / ROM_RD_BW)*25-iteration
	.VN_PIPELINE_DEPTH (`VN_PIPELINE_DEPTH),

	.VN_OVERPROVISION (`VN_OVERPROVISION), // the over-counted IB-ROM read address								// ceil(log2(#Entry)) = 11-bit
	.DN_QUAN_SIZE     (`DN_QUAN_SIZE    ),
	.DN_ROM_RD_BW     (`DN_ROM_RD_BW    ),    // bit-width of one read port of BRAM based IB-ROM
	.DN_ROM_ADDR_BW   (`DN_ROM_ADDR_BW  ),  // bit-width of read address of BRAM based IB-ROM
								// #Entry: (128-entry*4-bit) / ROM_RD_BW)*25-iteration
								// ceil(log2(#Entry)) = 11-bit
	
	.DN_OVERPROVISION (`DN_OVERPROVISION), // the over-counted IB-ROM read address	
	.VN_PAGE_ADDR_BW  (`VN_PAGE_ADDR_BW ), // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
	.VN_ITER_ADDR_BW  (`VN_ITER_ADDR_BW ),  // bit-width of addressing 25 iterationss
	//parameter VN_TYPE_A = 1,    // the number of check node type in terms of its check node degree   
	//parameter VN_TYPE_B = 1,     // the number of check node type in terms of its check node degree
	.DN_PAGE_ADDR_BW   (`DN_PAGE_ADDR_BW  ), // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
	.DN_ITER_ADDR_BW   (`DN_ITER_ADDR_BW  ),  // bit-width of addressing 25 iterationss
	.DN_PIPELINE_DEPTH (`DN_PIPELINE_DEPTH),
	//parameter DN_TYPE_A = 1,    // the number of check node type in terms of its check node degree   
	//parameter DN_TYPE_B = 1,     // the number of check node type in terms of its check node degree
	.VN_LOAD_CYCLE (`VN_LOAD_CYCLE), // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
	.DN_LOAD_CYCLE (`DN_LOAD_CYCLE), // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
	.VN_RD_BW      (`VN_RD_BW     ),
	.DN_RD_BW      (`DN_RD_BW     ),
	.VN_ADDR_BW    (`VN_ADDR_BW   ),
	.DN_ADDR_BW    (`DN_ADDR_BW   ),

	.ITER_ADDR_BW   (`ITER_ADDR_BW),
	.MULTI_FRAME_NUM (`MULTI_FRAME_NUM),
	.CN_PIPELINE_DEPTH (`CN_PIPELINE_DEPTH),
	.VN_PIPELINE_DEPTH (`VN_PIPELINE_DEPTH),
	.DN_PIPELINE_DEPTH (`DN_PIPELINE_DEPTH),
	.BANK_NUM          (`BANK_NUM),

	.CNU_FUNC_CYCLE   (`CNU_FUNC_CYCLE), // the latency of one CNU 2-LUT function based on symmetrical design
	.VNU_FUNC_CYCLE   (`VNU_FUNC_CYCLE), // the latency of one VNU 2-LUT function based on symmetrical design
	.DNU_FUNC_CYCLE   (`DNU_FUNC_CYCLE), // the latency of one DNU 2-LUT function based on symmetrical design
	.CNU_FUNC_MEM_END (`CNU_FUNC_MEM_END), // the Memory Read ends at rising edge of 2nd clock (indexed from 0th cycle)
	.VNU_FUNC_MEM_END (`VNU_FUNC_MEM_END), // the Memory Read ends at rising edge of 2nd clock (indexed from 0th cycle)
	.DNU_FUNC_MEM_END (`DNU_FUNC_MEM_END), // the Memory Read ends at rising edge of 2nd clock (indexed from 0th cycle)
	.CNU_WR_HANDSHAKE_RESPONSE (`CNU_WR_HANDSHAKE_RESPONSE), // response time from assertion of pipe_load_start until rising edge of cnu_wr
	.VNU_WR_HANDSHAKE_RESPONSE (`VNU_WR_HANDSHAKE_RESPONSE), // response time from assertion of pipe_load_start until rising edge of vnu_wr
	.DNU_WR_HANDSHAKE_RESPONSE (`DNU_WR_HANDSHAKE_RESPONSE) // response time from assertion of pipe_load_start until rising edge of vnu_wr
) entire_decoder_u0(
	.hard_decision_o (hard_decision[N-1:0]),
	.decode_busy (decode_busy),
	.decode_termination (decode_termination),
	.iter_cnt (decode_iter_cnt[ITER_ADDR_BW-1:0]),
	.decode_fail (decode_fail),
	`ifdef AWGN_GEN_VERIFY
		.v2c_load_debug (v2c_load_debug),
	`endif
	.ch_msg_0   (ch_msg[0  ]),
	.ch_msg_1   (ch_msg[1  ]),
	.ch_msg_2   (ch_msg[2  ]),
	.ch_msg_3   (ch_msg[3  ]),
	.ch_msg_4   (ch_msg[4  ]),
	.ch_msg_5   (ch_msg[5  ]),
	.ch_msg_6   (ch_msg[6  ]),
	.ch_msg_7   (ch_msg[7  ]),
	.ch_msg_8   (ch_msg[8  ]),
	.ch_msg_9   (ch_msg[9  ]),
	.ch_msg_10  (ch_msg[10 ]),
	.ch_msg_11  (ch_msg[11 ]),
	.ch_msg_12  (ch_msg[12 ]),
	.ch_msg_13  (ch_msg[13 ]),
	.ch_msg_14  (ch_msg[14 ]),
	.ch_msg_15  (ch_msg[15 ]),
	.ch_msg_16  (ch_msg[16 ]),
	.ch_msg_17  (ch_msg[17 ]),
	.ch_msg_18  (ch_msg[18 ]),
	.ch_msg_19  (ch_msg[19 ]),
	.ch_msg_20  (ch_msg[20 ]),
	.ch_msg_21  (ch_msg[21 ]),
	.ch_msg_22  (ch_msg[22 ]),
	.ch_msg_23  (ch_msg[23 ]),
	.ch_msg_24  (ch_msg[24 ]),
	.ch_msg_25  (ch_msg[25 ]),
	.ch_msg_26  (ch_msg[26 ]),
	.ch_msg_27  (ch_msg[27 ]),
	.ch_msg_28  (ch_msg[28 ]),
	.ch_msg_29  (ch_msg[29 ]),
	.ch_msg_30  (ch_msg[30 ]),
	.ch_msg_31  (ch_msg[31 ]),
	.ch_msg_32  (ch_msg[32 ]),
	.ch_msg_33  (ch_msg[33 ]),
	.ch_msg_34  (ch_msg[34 ]),
	.ch_msg_35  (ch_msg[35 ]),
	.ch_msg_36  (ch_msg[36 ]),
	.ch_msg_37  (ch_msg[37 ]),
	.ch_msg_38  (ch_msg[38 ]),
	.ch_msg_39  (ch_msg[39 ]),
	.ch_msg_40  (ch_msg[40 ]),
	.ch_msg_41  (ch_msg[41 ]),
	.ch_msg_42  (ch_msg[42 ]),
	.ch_msg_43  (ch_msg[43 ]),
	.ch_msg_44  (ch_msg[44 ]),
	.ch_msg_45  (ch_msg[45 ]),
	.ch_msg_46  (ch_msg[46 ]),
	.ch_msg_47  (ch_msg[47 ]),
	.ch_msg_48  (ch_msg[48 ]),
	.ch_msg_49  (ch_msg[49 ]),
	.ch_msg_50  (ch_msg[50 ]),
	.ch_msg_51  (ch_msg[51 ]),
	.ch_msg_52  (ch_msg[52 ]),
	.ch_msg_53  (ch_msg[53 ]),
	.ch_msg_54  (ch_msg[54 ]),
	.ch_msg_55  (ch_msg[55 ]),
	.ch_msg_56  (ch_msg[56 ]),
	.ch_msg_57  (ch_msg[57 ]),
	.ch_msg_58  (ch_msg[58 ]),
	.ch_msg_59  (ch_msg[59 ]),
	.ch_msg_60  (ch_msg[60 ]),
	.ch_msg_61  (ch_msg[61 ]),
	.ch_msg_62  (ch_msg[62 ]),
	.ch_msg_63  (ch_msg[63 ]),
	.ch_msg_64  (ch_msg[64 ]),
	.ch_msg_65  (ch_msg[65 ]),
	.ch_msg_66  (ch_msg[66 ]),
	.ch_msg_67  (ch_msg[67 ]),
	.ch_msg_68  (ch_msg[68 ]),
	.ch_msg_69  (ch_msg[69 ]),
	.ch_msg_70  (ch_msg[70 ]),
	.ch_msg_71  (ch_msg[71 ]),
	.ch_msg_72  (ch_msg[72 ]),
	.ch_msg_73  (ch_msg[73 ]),
	.ch_msg_74  (ch_msg[74 ]),
	.ch_msg_75  (ch_msg[75 ]),
	.ch_msg_76  (ch_msg[76 ]),
	.ch_msg_77  (ch_msg[77 ]),
	.ch_msg_78  (ch_msg[78 ]),
	.ch_msg_79  (ch_msg[79 ]),
	.ch_msg_80  (ch_msg[80 ]),
	.ch_msg_81  (ch_msg[81 ]),
	.ch_msg_82  (ch_msg[82 ]),
	.ch_msg_83  (ch_msg[83 ]),
	.ch_msg_84  (ch_msg[84 ]),
	.ch_msg_85  (ch_msg[85 ]),
	.ch_msg_86  (ch_msg[86 ]),
	.ch_msg_87  (ch_msg[87 ]),
	.ch_msg_88  (ch_msg[88 ]),
	.ch_msg_89  (ch_msg[89 ]),
	.ch_msg_90  (ch_msg[90 ]),
	.ch_msg_91  (ch_msg[91 ]),
	.ch_msg_92  (ch_msg[92 ]),
	.ch_msg_93  (ch_msg[93 ]),
	.ch_msg_94  (ch_msg[94 ]),
	.ch_msg_95  (ch_msg[95 ]),
	.ch_msg_96  (ch_msg[96 ]),
	.ch_msg_97  (ch_msg[97 ]),
	.ch_msg_98  (ch_msg[98 ]),
	.ch_msg_99  (ch_msg[99 ]),
	.ch_msg_100 (ch_msg[100]),
	.ch_msg_101 (ch_msg[101]),
	.ch_msg_102 (ch_msg[102]),
	.ch_msg_103 (ch_msg[103]),
	.ch_msg_104 (ch_msg[104]),
	.ch_msg_105 (ch_msg[105]),
	.ch_msg_106 (ch_msg[106]),
	.ch_msg_107 (ch_msg[107]),
	.ch_msg_108 (ch_msg[108]),
	.ch_msg_109 (ch_msg[109]),
	.ch_msg_110 (ch_msg[110]),
	.ch_msg_111 (ch_msg[111]),
	.ch_msg_112 (ch_msg[112]),
	.ch_msg_113 (ch_msg[113]),
	.ch_msg_114 (ch_msg[114]),
	.ch_msg_115 (ch_msg[115]),
	.ch_msg_116 (ch_msg[116]),
	.ch_msg_117 (ch_msg[117]),
	.ch_msg_118 (ch_msg[118]),
	.ch_msg_119 (ch_msg[119]),
	.ch_msg_120 (ch_msg[120]),
	.ch_msg_121 (ch_msg[121]),
	.ch_msg_122 (ch_msg[122]),
	.ch_msg_123 (ch_msg[123]),
	.ch_msg_124 (ch_msg[124]),
	.ch_msg_125 (ch_msg[125]),
	.ch_msg_126 (ch_msg[126]),
	.ch_msg_127 (ch_msg[127]),
	.ch_msg_128 (ch_msg[128]),
	.ch_msg_129 (ch_msg[129]),
	.ch_msg_130 (ch_msg[130]),
	.ch_msg_131 (ch_msg[131]),
	.ch_msg_132 (ch_msg[132]),
	.ch_msg_133 (ch_msg[133]),
	.ch_msg_134 (ch_msg[134]),
	.ch_msg_135 (ch_msg[135]),
	.ch_msg_136 (ch_msg[136]),
	.ch_msg_137 (ch_msg[137]),
	.ch_msg_138 (ch_msg[138]),
	.ch_msg_139 (ch_msg[139]),
	.ch_msg_140 (ch_msg[140]),
	.ch_msg_141 (ch_msg[141]),
	.ch_msg_142 (ch_msg[142]),
	.ch_msg_143 (ch_msg[143]),
	.ch_msg_144 (ch_msg[144]),
	.ch_msg_145 (ch_msg[145]),
	.ch_msg_146 (ch_msg[146]),
	.ch_msg_147 (ch_msg[147]),
	.ch_msg_148 (ch_msg[148]),
	.ch_msg_149 (ch_msg[149]),
	.ch_msg_150 (ch_msg[150]),
	.ch_msg_151 (ch_msg[151]),
	.ch_msg_152 (ch_msg[152]),
	.ch_msg_153 (ch_msg[153]),
	.ch_msg_154 (ch_msg[154]),
	.ch_msg_155 (ch_msg[155]),
	.ch_msg_156 (ch_msg[156]),
	.ch_msg_157 (ch_msg[157]),
	.ch_msg_158 (ch_msg[158]),
	.ch_msg_159 (ch_msg[159]),
	.ch_msg_160 (ch_msg[160]),
	.ch_msg_161 (ch_msg[161]),
	.ch_msg_162 (ch_msg[162]),
	.ch_msg_163 (ch_msg[163]),
	.ch_msg_164 (ch_msg[164]),
	.ch_msg_165 (ch_msg[165]),
	.ch_msg_166 (ch_msg[166]),
	.ch_msg_167 (ch_msg[167]),
	.ch_msg_168 (ch_msg[168]),
	.ch_msg_169 (ch_msg[169]),
	.ch_msg_170 (ch_msg[170]),
	.ch_msg_171 (ch_msg[171]),
	.ch_msg_172 (ch_msg[172]),
	.ch_msg_173 (ch_msg[173]),
	.ch_msg_174 (ch_msg[174]),
	.ch_msg_175 (ch_msg[175]),
	.ch_msg_176 (ch_msg[176]),
	.ch_msg_177 (ch_msg[177]),
	.ch_msg_178 (ch_msg[178]),
	.ch_msg_179 (ch_msg[179]),
	.ch_msg_180 (ch_msg[180]),
	.ch_msg_181 (ch_msg[181]),
	.ch_msg_182 (ch_msg[182]),
	.ch_msg_183 (ch_msg[183]),
	.ch_msg_184 (ch_msg[184]),
	.ch_msg_185 (ch_msg[185]),
	.ch_msg_186 (ch_msg[186]),
	.ch_msg_187 (ch_msg[187]),
	.ch_msg_188 (ch_msg[188]),
	.ch_msg_189 (ch_msg[189]),
	.ch_msg_190 (ch_msg[190]),
	.ch_msg_191 (ch_msg[191]),
	.ch_msg_192 (ch_msg[192]),
	.ch_msg_193 (ch_msg[193]),
	.ch_msg_194 (ch_msg[194]),
	.ch_msg_195 (ch_msg[195]),
	.ch_msg_196 (ch_msg[196]),
	.ch_msg_197 (ch_msg[197]),
	.ch_msg_198 (ch_msg[198]),
	.ch_msg_199 (ch_msg[199]),
	.ch_msg_200 (ch_msg[200]),
	.ch_msg_201 (ch_msg[201]),
	.ch_msg_202 (ch_msg[202]),
	.ch_msg_203 (ch_msg[203]),
	
	.tready_slave (tvalid_master),
	.block_cnt_full (block_cnt_full),
	.read_clk (read_clk),
	.cn_write_clk (write_clk),
	.vn_write_clk (write_clk),
	.dn_write_clk (write_clk),
	.rstn (decoder_rstn)
);
assign ready_slave = symbol_gen_ce;
assign is_awgn_out = decode_termination;
`ifdef AWGN_GEN_VERIFY
	reg [13:0] awgn_hist [0:15];
	initial begin
		awgn_hist[0] <= 0; awgn_hist[4] <= 0; awgn_hist[8] <= 0; awgn_hist[12] <= 0;
		awgn_hist[1] <= 0; awgn_hist[5] <= 0; awgn_hist[9] <= 0; awgn_hist[13] <= 0;
		awgn_hist[2] <= 0; awgn_hist[6] <= 0; awgn_hist[10] <= 0; awgn_hist[14] <= 0;
		awgn_hist[3] <= 0; awgn_hist[7] <= 0; awgn_hist[11] <= 0; awgn_hist[15] <= 0;
	end
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) begin
			awgn_hist[0] <= 0; awgn_hist[4] <= 0; awgn_hist[8] <= 0; awgn_hist[12] <= 0;
			awgn_hist[1] <= 0; awgn_hist[5] <= 0; awgn_hist[9] <= 0; awgn_hist[13] <= 0;
			awgn_hist[2] <= 0; awgn_hist[6] <= 0; awgn_hist[10] <= 0; awgn_hist[14] <= 0;
			awgn_hist[3] <= 0; awgn_hist[7] <= 0; awgn_hist[11] <= 0; awgn_hist[15] <= 0;
		end
		else if(snr_next_reg[7] == 1'b1) begin
			awgn_hist[0] <= 0; awgn_hist[4] <= 0; awgn_hist[8] <= 0; awgn_hist[12] <= 0;
			awgn_hist[1] <= 0; awgn_hist[5] <= 0; awgn_hist[9] <= 0; awgn_hist[13] <= 0;
			awgn_hist[2] <= 0; awgn_hist[6] <= 0; awgn_hist[10] <= 0; awgn_hist[14] <= 0;
			awgn_hist[3] <= 0; awgn_hist[7] <= 0; awgn_hist[11] <= 0; awgn_hist[15] <= 0;
		end
		else if(v2c_load_debug == 1'b1) begin
			if(awgn_hist[ch_msg[203]] < ((2**14)-1))
				awgn_hist[ch_msg[203]] <= awgn_hist[ch_msg[203]]+1;
		end
	end
`endif
/*---------------------------------------------------------------------------------------------*/
	// Nets related to Evaluation Metrics
	reg [ERR_FRAME_PACKET_SIZE-1:0] errFrame_cnt; // Counting the number of evaluated blocks
	reg [ERR_CNT_PACKET_SIZE-1:0] err_cnt_acc; // // Accumulating error bits over all evaluated blocks
	reg [`FRAME_COUNT_SIZE-1:0] block_cnt; // // Counting the number of evaluated blocks
	reg [ITER_CNT_PACKET_SIZE-1:0] iter_cnt_acc;
	reg snr_next; // to indicate the current experiment is moved on to the next SNR
	/*Being declared in the earlier line*///reg [7:0] snr_next_reg;
	reg count_done_reg;
	reg decode_fail_reg;
	reg [SNR_PACKET_SIZE-1:0] snr_packet_reg;
    // To evaluate the number of bit error over current block
	wire [errCnt_width-1:0] err_count;
	wire syndrome_busy, count_done;
	localparam errBit_cnt_depth = 3;
	errBit_cnt_top #(.PIPELINE_DEPTH (errBit_cnt_depth), .N (N)) errBit_cnt_204 (
		.err_count (err_count[errCnt_width-1:0]),
		.count_done (count_done),
		.busy (syndrome_busy),
		
		.hard_frame (hard_decision[N-1:0]),
		.eval_clk (syndrome_clk),
		.en (decode_termination),
		.rstn (sys_rstn)
	);
	//assign ready_slave = symbol_gen_ce & ~syndrome_busy;

/*---------------------------------------------------------------------------------------------*/
// In the following experimental result summaries, all the findings is transferred once every "experimental run"
// Definition of "Experimental Run": 
// 	Case 1) the number of evaluated blocks has reached the specifid maximum number, i.e., 2^(FRAME_COUNT_SIZE), regardless of the number of error frames
//  Case 2) the number of error frames has reached the specified maximum number, i.e., 1000 or 100 frames as default, regardless of the number of evaluated frames
	// Counting the number of evaluated blocks in current experimental run
	initial block_cnt_full <= 1'b0;
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) 
			block_cnt_full <= 1'b0;
		else if(count_done_reg == 1'b1 && block_cnt[`FRAME_COUNT_SIZE-1:0] == PACKAGE_FRAME_NUM-1) 
			block_cnt_full <= 1'b1;
		else 
			block_cnt_full <= 1'b0;
	end

	initial count_done_reg <= 0; // since the block count and errBit count ought to synchronised with "rising event of count_done", the associated sensitivity have to be delayed for one clock cycle 
	always @(posedge read_clk) count_done_reg <= count_done;
	initial block_cnt[`FRAME_COUNT_SIZE-1:0] <= 0;
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) block_cnt[`FRAME_COUNT_SIZE-1:0] <= 0;
		//else if(decode_termination == 1'b1) begin
		else if(snr_next_reg[7] == 1'b1) block_cnt[`FRAME_COUNT_SIZE-1:0] <= 0;
		else if(count_done_reg == 1'b1) begin
		  if(block_cnt[`FRAME_COUNT_SIZE-1:0] == 0) block_cnt[`FRAME_COUNT_SIZE-1:0] <= 2;
		  else if(block_cnt[`FRAME_COUNT_SIZE-1:0] == PACKAGE_FRAME_NUM-1) block_cnt[`FRAME_COUNT_SIZE-1:0] <= 0;
		  else if(errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] == ERR_FRAME_HALT-1) block_cnt[`FRAME_COUNT_SIZE-1:0] <= 0; // Finish current SNR simulation, reset it thereby
		  else block_cnt[`FRAME_COUNT_SIZE-1:0] <= block_cnt[`FRAME_COUNT_SIZE-1:0] + 1'b1;
		end
	end
	
	// Counting the number of error frames at one specific SNR (dB)
	initial snr_next_reg <= 0;
	always @(posedge read_clk) snr_next_reg[7:0] <= {snr_next_reg[6:0], snr_next};
	initial errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] <= 0;
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] <= 0;
		else if(snr_next_reg[7] == 1'b1)  errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] <= 0;
		else if(decode_fail == 1'b1) errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] <= errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] + 1'b1;
		/*
		else if(decode_fail == 1'b1) begin
			if(block_cnt[`FRAME_COUNT_SIZE-1:0] == 0) errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] <= errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] + 1;
			else if(errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] == ERR_FRAME_HALT-1) errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] <= 0;
			else errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] <= errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] + 1'b1;
		end
		*/
		else errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] <= errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0];
	end

	// SNR indicator
	initial decode_fail_reg <= 0;
	always @(posedge read_clk) begin if(!sys_rstn) decode_fail_reg <= 0; else decode_fail_reg <= decode_fail; end
	initial snr_packet[SNR_PACKET_SIZE-1:0] <= START_SNR;
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) 
			snr_packet[SNR_PACKET_SIZE-1:0] <= START_SNR;
		else if(decode_fail_reg == 1'b1 && errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] == ERR_FRAME_HALT-1)
			if(snr_packet == SNR_SET_NUM-1)
				snr_packet[SNR_PACKET_SIZE-1:0] <= START_SNR;
			else
				snr_packet[SNR_PACKET_SIZE-1:0] <= snr_packet[SNR_PACKET_SIZE-1:0] + 1'b1;
		else 
			snr_packet[SNR_PACKET_SIZE-1:0] <= snr_packet[SNR_PACKET_SIZE-1:0];
	end
	initial snr_next <= 0;
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) snr_next <= 0;
		else if(decode_fail_reg == 1'b1 && errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] == ERR_FRAME_HALT-1) snr_next <= 1;
		else snr_next <= 0;
	end
	// The SNR information for AXI4 data packet, beacuse the snr_packet will be updated once "decode_fail" is asserted where the timing is too early.
	initial snr_packet_reg <= 0; 
	always @(posedge read_clk) begin
		if(sys_rstn == 1'b0) snr_packet_reg <= `START_SNR;
		else if(decode_termination == 1'b1) snr_packet_reg <= snr_packet;
		else snr_packet_reg <= snr_packet_reg;
	end

	// Accumulating error bits over all evaluated blocks
	initial err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0] <= 0;
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0] <= 0;
		else if(errFrame_cnt == 0) err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0] <= 0;
		else if(decode_fail_reg == 1'b1) err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0] <= err_cnt_acc + err_count;
		else err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0] <= err_cnt_acc;
		/*
		else if(count_done_reg == 1'b1) begin
			if(block_cnt[`FRAME_COUNT_SIZE-1:0] == 0) 
				err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0] <= err_count;
			else 
				err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0] <= err_cnt_acc+err_count;
		end
		*/
	end
	
	// Accumulating the number of actual decoding iterations over all evaluated blocks
	initial iter_cnt_acc <= 0;
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) 
			iter_cnt_acc[ITER_CNT_PACKET_SIZE-1:0] <= 0;
		else if(decode_termination == 1'b1) begin
			if(block_cnt[`FRAME_COUNT_SIZE-1:0] == 0) 
				iter_cnt_acc[ITER_CNT_PACKET_SIZE-1:0] <= decode_iter_cnt[ITER_ADDR_BW-1:0];
			//else if(block_cnt[`FRAME_COUNT_SIZE-1:0] == PACKAGE_FRAME_NUM-1) 
			//	iter_cnt_acc[ITER_CNT_PACKET_SIZE-1:0] <= iter_cnt_acc[ITER_CNT_PACKET_SIZE-1:0]+decode_iter_cnt[ITER_ADDR_BW-1:0];
			else 
				iter_cnt_acc[ITER_CNT_PACKET_SIZE-1:0] <= iter_cnt_acc[ITER_CNT_PACKET_SIZE-1:0]+decode_iter_cnt[ITER_ADDR_BW-1:0];
		end
	end
/*---------------------------------------------------------------------------------------------*/
	wire axi_wr_end, axi_wr_first_shift, axi_wr_next_shift, pl_ps_ext_intr;
	wire [0:0] m_axi_arestn;

	wire [`AXI_FRAME_SIZE-1:0] axi_frame_packet [0:4];
	wire axi_frame_packet_valid;
	axi_stream_packet_encoder #(
		.N (N),
		.AXI_FRAME_SIZE (`AXI_FRAME_SIZE),
		.FRAME_COUNT_SIZE (`FRAME_COUNT_SIZE),
		.ERR_FRAME_HALT (ERR_FRAME_HALT),
		.PACKAGE_FRAME_NUM (PACKAGE_FRAME_NUM),
		.MAX_ITER (MAX_ITER),
  		.ERR_CNT_PACKET_SIZE (ERR_CNT_PACKET_SIZE),
 		.ITER_CNT_PACKET_SIZE (ITER_CNT_PACKET_SIZE),
 		.SNR_PACKET_SIZE (SNR_PACKET_SIZE),
 		.ERR_FRAME_PACKET_SIZE (ERR_FRAME_PACKET_SIZE)
	) axi_packet_encoder_u0 (
		.axi_frame_packet_0 (axi_frame_packet[0]),
		.axi_frame_packet_1 (axi_frame_packet[1]),
		.axi_frame_packet_2 (axi_frame_packet[2]),
		.axi_frame_packet_3 (axi_frame_packet[3]),
		.axi_frame_packet_4 (axi_frame_packet[4]),
		.axi_frame_packet_valid (axi_frame_packet_valid),
	
		.count_done_in (count_done_reg),
		.block_cnt (block_cnt[`FRAME_COUNT_SIZE-1:0]),
		.errFrame_cnt (errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0]),
		.err_cnt_acc (err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0]),
		.iter_cnt_acc (iter_cnt_acc[ITER_CNT_PACKET_SIZE-1:0]),
		.snr_packet (snr_packet_reg[SNR_PACKET_SIZE-1:0]),
		.read_clk (read_clk), 
		.sys_rstn (sys_rstn)
	);

	reg [`AXI_FRAME_SIZE-1:0] axi_frame_packet_reg [0:4];
	always @(posedge read_clk, negedge m_axi_arestn) begin
		if(m_axi_arestn == 1'b0) begin
			axi_frame_packet_reg[0] <= {28'd0, 4'b1111};
			axi_frame_packet_reg[1] <= {28'd0, 4'b1111};
			axi_frame_packet_reg[2] <= {28'd0, 4'b1111};
			axi_frame_packet_reg[3] <= {28'd0, 4'b1111};
			axi_frame_packet_reg[4] <= {28'd0, 4'b1111};
		end
		else if(axi_frame_packet_valid == 1'b1) begin
			axi_frame_packet_reg[0] <= axi_frame_packet[0];
			axi_frame_packet_reg[1] <= axi_frame_packet[1];
			axi_frame_packet_reg[2] <= axi_frame_packet[2];
			axi_frame_packet_reg[3] <= axi_frame_packet[3];
			axi_frame_packet_reg[4] <= axi_frame_packet[4];
		end
		else if(axi_wr_end == 1'b1) begin
			axi_frame_packet_reg[0] <= {28'd0, 4'b1111};
			axi_frame_packet_reg[1] <= {28'd0, 4'b1111};
			axi_frame_packet_reg[2] <= {28'd0, 4'b1111};
			axi_frame_packet_reg[3] <= {28'd0, 4'b1111};
			axi_frame_packet_reg[4] <= {28'd0, 4'b1111};
		end
	end
/*---------------------------------------------------------------------------------------------*/
	reg axi_wr_first_shift_reg, axi_wr_next_shift_reg, axi_wr_end_reg;
	initial begin 
		axi_wr_first_shift_reg <= 0;
		axi_wr_next_shift_reg <= 0;
		axi_wr_end_reg <= 0;
	end
	always @(posedge read_clk, negedge m_axi_arestn) begin
		if(m_axi_arestn == 1'b0) begin 
			axi_wr_first_shift_reg <= 0;
			axi_wr_next_shift_reg <= 0;
			axi_wr_end_reg <= 0;
		end
		else begin
			axi_wr_first_shift_reg <= axi_wr_first_shift;
			axi_wr_next_shift_reg  <= axi_wr_next_shift;
			axi_wr_end_reg         <= axi_wr_end;
		end
	end
	reg axi_txn; initial axi_txn <= 0;
	always @(posedge read_clk, negedge m_axi_arestn) begin
		if(m_axi_arestn == 1'b0) axi_txn <= 0;
		else axi_txn <= axi_frame_packet_valid;
	end
	
	reg [(`AXI_FRAME_SIZE*8)-1:0] result_packet_in;
	always @(posedge read_clk, negedge m_axi_arestn) begin
		if(m_axi_arestn == 1'b0) begin
			result_packet_in <= 0;
		end
`ifdef AWGN_GEN_VERIFY
	else if(axi_txn == 1'b1) result_packet_in <= {axi_frame_packet_reg[4], awgn_hist[15], awgn_hist[14], awgn_hist[13], awgn_hist[12], awgn_hist[11], awgn_hist[10], awgn_hist[9], awgn_hist[8], awgn_hist[7], awgn_hist[6], awgn_hist[5], awgn_hist[4], awgn_hist[3], awgn_hist[2], awgn_hist[1], awgn_hist[0]};
`else
		else if(axi_txn == 1'b1) result_packet_in <= {axi_frame_packet_reg[0], axi_frame_packet_reg[1], axi_frame_packet_reg[2], axi_frame_packet_reg[3], axi_frame_packet_reg[4], axi_frame_packet_reg[0], axi_frame_packet_reg[1], axi_frame_packet_reg[2]};
`endif
		else if(axi_wr_first_shift_reg == 1'b1) result_packet_in <= {result_packet_in[(`AXI_FRAME_SIZE*7)-1:0], {32{1'b0}}};
		else if(axi_wr_next_shift_reg == 1'b1 || axi_wr_end_reg == 1'b1) result_packet_in <= {result_packet_in[(`AXI_FRAME_SIZE*7)-1:0], {32{1'b0}}};
		else result_packet_in <= result_packet_in;
	end

	design_2_wrapper ps_interface_u0(
		.axi_wr_end (axi_wr_end),
	    .axi_wr_first_shift (axi_wr_first_shift),
	    .axi_wr_next_shift (axi_wr_next_shift),
	    .m00_axi_wr_intr_en (pl_ps_ext_intr),
	    .m_axi_arestn (m_axi_arestn),
	    
	    .pl_ps_ext_intr (pl_ps_ext_intr),
	    .m00_axi_aclk (ps_clk_100MHz),
	    .m00_axi_init_axi_txn (axi_txn),
	    .result_packet_in (result_packet_in[(`AXI_FRAME_SIZE*8)-1:(`AXI_FRAME_SIZE*7)])
	);

/*
	design_1_wrapper design_1_i (
		.pl_fifo_wr_clk(pl_fifo_wr_clk),
        .result_fifo_in(result_fifo_in[`AXI_FRAME_SIZE-1:0]),
        .result_fifo_we(result_fifo_we)
	);
*/
endmodule

module axi_stream_packet_encoder #(
	parameter N = 204,
	parameter MAX_ITER = 50,
	parameter AXI_FRAME_SIZE = 32,
	parameter FRAME_COUNT_SIZE = 22,
	parameter ERR_FRAME_HALT = 1000,
	parameter PACKAGE_FRAME_NUM = (2**FRAME_COUNT_SIZE),
	parameter ERR_CNT_PACKET_SIZE = $clog2(PACKAGE_FRAME_NUM*N),
	parameter ITER_CNT_PACKET_SIZE = $clog2(PACKAGE_FRAME_NUM*MAX_ITER),
	parameter SNR_PACKET_SIZE = 6,
	parameter ERR_FRAME_PACKET_SIZE = $clog2(ERR_FRAME_HALT)
) (
	output reg [AXI_FRAME_SIZE-1:0] axi_frame_packet_0,
	output reg [AXI_FRAME_SIZE-1:0] axi_frame_packet_1,
	output reg [AXI_FRAME_SIZE-1:0] axi_frame_packet_2,
	output reg [AXI_FRAME_SIZE-1:0] axi_frame_packet_3,
	output reg [AXI_FRAME_SIZE-1:0] axi_frame_packet_4,
	output wire axi_frame_packet_valid,

	input wire count_done_in,
	input wire [FRAME_COUNT_SIZE-1:0] block_cnt,
	input wire [ERR_FRAME_PACKET_SIZE-1:0] errFrame_cnt,
	input wire [ERR_CNT_PACKET_SIZE-1:0] err_cnt_acc,
	input wire [ITER_CNT_PACKET_SIZE-1:0] iter_cnt_acc,
	input wire [SNR_PACKET_SIZE-1:0] snr_packet,
	input wire read_clk, 
	input wire sys_rstn
);

	//								AXI Frame Package 0)
	//  ---------------------------     -------------------------
	// | Number of Frames (28-bit) | + | Type Identifier (4-bit) |
	//  ---------------------------     -------------------------
	//								AXI Frame Package 1)
	//  ---------------------------------     -------------------------
	// | Error Bits over Frames (28-bit) | + | Type Identifier (4-bit) |
	//  ---------------------------------     -------------------------
	//								AXI Frame Package 2)
	//  --------------------------------------     -------------------------
	// | Iteration Count over Frames (28-bit) | + | Type Identifier (4-bit) |
	//  --------------------------------------     -------------------------
	//								AXI Frame Package 3)
	//  ---------------------------------     -------------------------
	// | Number of Error Frames (28-bit) | + | Type Identifier (4-bit) |
	//  ---------------------------------     -------------------------
	//								AXI Frame Package 4)
	//  ---------------------      -------------------------
	// | Current SNR (28-bit) | + | Type Identifier (4-bit) |
	//  ---------------------      -------------------------
	localparam packet_id_size = 4;
	localparam [packet_id_size-1:0] axi_pack_identifier_0 = 4'd0; // AXI-Stream Frame Package Indentifier 0
	localparam [packet_id_size-1:0] axi_pack_identifier_1 = 4'd1; // AXI-Stream Frame Package Indentifier 1
	localparam [packet_id_size-1:0] axi_pack_identifier_2 = 4'd2; // AXI-Stream Frame Package Indentifier 2
	localparam [packet_id_size-1:0] axi_pack_identifier_3 = 4'd3; // AXI-Stream Frame Package Indentifier 3
	localparam [packet_id_size-1:0] axi_pack_identifier_4 = 4'd4; // AXI-Stream Frame Package Indentifier 4
	localparam [packet_id_size-1:0] axi_pack_identifier_dummy = 4'b1111; // AXI-Stream Frame Package Preserve Indentifier
	
	reg count_done_reg; initial count_done_reg <= 0;
	always @(posedge read_clk) count_done_reg <= count_done_in;
	// AXI Frame Package 0
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) 
			axi_frame_packet_0 <= 0;
		else if(count_done_in == 1'b1) begin
		  if(block_cnt[FRAME_COUNT_SIZE-1:0] == (2**FRAME_COUNT_SIZE)-1) 
		  	axi_frame_packet_0 <= {block_cnt[FRAME_COUNT_SIZE-1:0], axi_pack_identifier_0};
		  else if(errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] == ERR_FRAME_HALT-1)  
		  	axi_frame_packet_0 <= {block_cnt[FRAME_COUNT_SIZE-1:0], axi_pack_identifier_0};
		  else
		  	axi_frame_packet_0 <= {28'd0, axi_pack_identifier_dummy}; // invalid/dummy fame package
		end
	end
	// AXI Frame Package 1
	//always @(negedge read_clk, negedge sys_rstn) begin
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) 
			axi_frame_packet_1 <= 0;
		else if(count_done_reg == 1'b1) begin
		  if(axi_frame_packet_0[FRAME_COUNT_SIZE+packet_id_size-1:packet_id_size] == (2**FRAME_COUNT_SIZE)-1) 
		  	axi_frame_packet_1 <= {err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0], axi_pack_identifier_1};
		  else if(axi_frame_packet_3[ERR_FRAME_PACKET_SIZE+packet_id_size-1:packet_id_size] == ERR_FRAME_HALT-1)  
		  	axi_frame_packet_1 <= {err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0], axi_pack_identifier_1};
		  else
		  	axi_frame_packet_1 <= {28'd0, axi_pack_identifier_dummy}; // invalid/dummy fame package
		end
	end
	// AXI Frame Package 2
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) 
			axi_frame_packet_2 <= 0;
		else if(count_done_in == 1'b1) begin
		  if(block_cnt[FRAME_COUNT_SIZE-1:0] == (2**FRAME_COUNT_SIZE)-1) 
		  	axi_frame_packet_2 <= {iter_cnt_acc[ITER_CNT_PACKET_SIZE-1:0], axi_pack_identifier_2};
		  else if(errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] == ERR_FRAME_HALT-1)  
		  	axi_frame_packet_2 <= {iter_cnt_acc[ITER_CNT_PACKET_SIZE-1:0], axi_pack_identifier_2};
		  else
		  	axi_frame_packet_2 <= {28'd0, axi_pack_identifier_dummy}; // invalid/dummy fame package
		end
	end
	// AXI Frame Package 3
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) 
			axi_frame_packet_3 <= 0;
		else if(count_done_in == 1'b1) begin
		  if(block_cnt[FRAME_COUNT_SIZE-1:0] == (2**FRAME_COUNT_SIZE)-1) 
		  	axi_frame_packet_3 <= {errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0], axi_pack_identifier_3};
		  else if(errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] == ERR_FRAME_HALT-1)  
		  	axi_frame_packet_3 <= {errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0], axi_pack_identifier_3};
		  else
		  	axi_frame_packet_3 <= {28'd0, axi_pack_identifier_dummy}; // invalid/dummy fame package
		end
	end
	// AXI Frame Package 4
	wire [SNR_PACKET_SIZE-1:0] snr_packet_adj;
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) 
			axi_frame_packet_4 <= 0;
		else if(count_done_in == 1'b1) begin
		  if(block_cnt[FRAME_COUNT_SIZE-1:0] == (2**FRAME_COUNT_SIZE)-1) 
		  	axi_frame_packet_4 <= {snr_packet[SNR_PACKET_SIZE-1:0], axi_pack_identifier_4};
		  else if(errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] == ERR_FRAME_HALT-1)  
		  	axi_frame_packet_4 <= {snr_packet[SNR_PACKET_SIZE-1:0], axi_pack_identifier_4};
		  else
		  	axi_frame_packet_4 <= {28'd0, axi_pack_identifier_dummy}; // invalid/dummy fame package
		end
	end

	reg [1:0] axi_frame_packet_valid_reg;
	initial axi_frame_packet_valid_reg <= 0;
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) axi_frame_packet_valid_reg[0] <= 1'b0;
		else if(count_done_in == 1'b1) begin
			if(errFrame_cnt[ERR_FRAME_PACKET_SIZE-1:0] == ERR_FRAME_HALT-1) 
				axi_frame_packet_valid_reg[0] <= count_done_in;
			else if(block_cnt[FRAME_COUNT_SIZE-1:0] == (2**FRAME_COUNT_SIZE)-1)
				axi_frame_packet_valid_reg[0] <= count_done_in;
		end
		else axi_frame_packet_valid_reg[0] <= 1'b0;
	end
	always @(posedge read_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) axi_frame_packet_valid_reg[1] <= 1'b0;
		else axi_frame_packet_valid_reg[1] <= axi_frame_packet_valid_reg[0];
	end
	assign axi_frame_packet_valid = axi_frame_packet_valid_reg[1];
endmodule