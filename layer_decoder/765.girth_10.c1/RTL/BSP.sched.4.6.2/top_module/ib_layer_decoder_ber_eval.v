`timescale 1 ps / 1 ps
//`include "snr_param.vh"
`include "define.vh"

module ib_layer_decoder_ber_eval # (
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
	wire [CHECK_PARALLELISM-1:0] hard_decision_sub [0:CN_DEGREE-1];
	reg [CHECK_PARALLELISM-1:0] hard_decision_sub_reg [0:CN_DEGREE-1];

	wire decode_busy, decode_termination, decode_fail;
	reg block_cnt_full;
	wire [ITER_ADDR_BW-1:0] decode_iter_cnt;
    `ifdef AWGN_GEN_VERIFY
    	wire v2c_load_debug;
    `endif
	assign pll_rst = GPIO_PB_SW2;
	assign sys_rstn = ~GPIO_PB_SW3;
	assign symbol_gen_ce = clk_lock; //sys_rstn;
	
	sync_clock_domain_wrapper sync_clock_u0 (
		.clk_100MHz (clk_100MHz),
    	.clk_150MHz (clk_150MHz),
    	.clk_200MHz (clk_200MHz),
    	.clk_300MHz (clk_300MHz),
    	.clk_50MHz (clk_50MHz),
    	.clk_in1_0 (ps_clk_100MHz),
    	.locked (clk_lock),
    	.rst (pll_rst)
    );
	assign read_clk = (clk_lock & clk_100MHz);
	assign write_clk = (clk_lock & clk_200MHz);
	assign awgn_gen_clk = read_clk;//(clk_lock & clk_50MHz); //write_clk;//(clk_lock & clk_300MHz);
	assign syndrome_clk = write_clk; // choosing a faster clock rate than read clock
	assign ready_work = 1'b1;

	wire tvalid_master, ready_slave;
/*-----------------------------------------------------------------------------------------------------------------*/
// First codeword will takes 51+24=75 clock cycles to be generated
// From the second codeword the latency is 12 clcok cycles due to the pipeline fashion
`ifdef CODE_RATE_070
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
	wire [15:0] sigma_in [0:`SNR_SET_NUM-1];
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

	localparam AWGN_BLOCK_NUM = `SUBMATRIX_Z*`CN_DEGREE;
	localparam SNR_PACKET_SIZE = $clog2(`SNR_SET_NUM);
	wire [SUBMATRIX_Z*QUAN_SIZE-1:0] coded_block_sub [0:`CN_DEGREE-1];
	wire tvalid_master, ready_slave;
    //wire snr_next_sync; assign snr_next_sync = (|snr_next_reg[7:0]);
	reg [SNR_PACKET_SIZE-1:0] snr_packet; initial snr_packet <= 0;
	receivedBlock_generator #(
		.N (AWGN_BLOCK_NUM), // block length, e.g., 7650
		.NG_NUM (`NG_NUM), // 10 codeword segments
		.NG_SIZE (`NG_SIZE), // the number of codebits in each codeword segment, e.g., 765
		.QUAN_SIZE (`QUAN_SIZE)// 4-bit quantisation for each channel message
	) block_gen_u0(
		.coded_block_0 (coded_block_sub[0]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_1 (coded_block_sub[1]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_2 (coded_block_sub[2]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_3 (coded_block_sub[3]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_4 (coded_block_sub[4]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_5 (coded_block_sub[5]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_6 (coded_block_sub[6]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_7 (coded_block_sub[7]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_8 (coded_block_sub[8]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_9 (coded_block_sub[9]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.tvalid_master (tvalid_master),
		
		.sigma_in (sigma_in[snr_packet[SNR_PACKET_SIZE-1:0]]),// Correctable from 3.5 dB 
																	// offset: 2.4-dB is actually 3.8 dB
		//input wire [63:0] seed_base_0,
		//input wire [63:0] seed_base_1,
		//input wire [63:0] seed_base_2,
		.ready_slave (1'b1),//(ready_slave),
		.rstn (sys_rstn),//(~snr_next_sync && sys_rstn),//(sys_rstn),
		.sys_clk (awgn_gen_clk)
	);
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
entire_layer_decoder_tb #(
	.QUAN_SIZE(`QUAN_SIZE),
	.LAYER_NUM(`LAYER_NUM),
	.ROW_CHUNK_NUM(`ROW_CHUNK_NUM),
	.CHECK_PARALLELISM(`CHECK_PARALLELISM),
	.READ_CLK_RATE(`READ_CLK_RATE),
	.WRITE_CLK_RATE(`WRITE_CLK_RATE),
	.WRITE_CLK_RATIO(`WRITE_CLK_RATIO),
	.VN_DEGREE(`VN_DEGREE),
	.CN_DEGREE(`CN_DEGREE),
	.SUBMATRIX_Z(`SUBMATRIX_Z),
	.IB_ROM_SIZE(`IB_ROM_SIZE),
	.IB_ROM_ADDR_WIDTH(`IB_ROM_ADDR_WIDTH),
	.VNU3_INSTANTIATE_NUM(`VNU3_INSTANTIATE_NUM),
	.VNU3_INSTANTIATE_UNIT(`VNU3_INSTANTIATE_UNIT),
	.BANK_NUM(`BANK_NUM),
	.MULTI_FRAME_NUM(`MULTI_FRAME_NUM),
	.IB_CNU_DECOMP_funNum(`IB_CNU_DECOMP_funNum),
	.IB_VNU_DECOMP_funNum(`IB_VNU_DECOMP_funNum),
	.IB_DNU_DECOMP_funNum(`IB_DNU_DECOMP_funNum),
	.ITER_ADDR_BW(`ITER_ADDR_BW),
	.ITER_ROM_GROUP(`ITER_ROM_GROUP),
	.MAX_ITER(`MAX_ITER),
	.VN_QUAN_SIZE(`VN_QUAN_SIZE),
	.VN_ROM_RD_BW(`VN_ROM_RD_BW),
	.VN_ROM_ADDR_BW(`VN_ROM_ADDR_BW),
	.VN_PIPELINE_DEPTH(`VN_PIPELINE_DEPTH),
	.VN_OVERPROVISION(`VN_OVERPROVISION),
	.DN_QUAN_SIZE(`DN_QUAN_SIZE),
	.DN_ROM_RD_BW(`DN_ROM_RD_BW),
	.DN_ROM_ADDR_BW(`DN_ROM_ADDR_BW),
	.DN_OVERPROVISION(`DN_OVERPROVISION),
	.VN_PAGE_ADDR_BW(`VN_PAGE_ADDR_BW),
	.VN_ITER_ADDR_BW(`VN_ITER_ADDR_BW),
	.DN_PAGE_ADDR_BW(`DN_PAGE_ADDR_BW),
	.DN_ITER_ADDR_BW(`DN_ITER_ADDR_BW),
	.DN_PIPELINE_DEPTH(`DN_PIPELINE_DEPTH),
	.VN_LOAD_CYCLE(`VN_LOAD_CYCLE),
	.DN_LOAD_CYCLE(`DN_LOAD_CYCLE),
	.VN_RD_BW(`VN_RD_BW),
	.DN_RD_BW(`DN_RD_BW),
	.VN_ADDR_BW(`VN_ADDR_BW),
	.DN_ADDR_BW(`DN_ADDR_BW),
	.RESET_CYCLE(`RESET_CYCLE),
	.CNU_FUNC_CYCLE(`CNU_FUNC_CYCLE),
	.CNU_PIPELINE_LEVEL(`CNU_PIPELINE_LEVEL),
	.BS_PIPELINE_LEVEL(`BS_PIPELINE_LEVEL),
	.VNU_BUBBLE_LEVEL(`VNU_BUBBLE_LEVEL),
	.FSM_STATE_NUM(`FSM_STATE_NUM),
	.INIT_LOAD(`INIT_LOAD),
	.VNU_IB_RAM_PEND(`VNU_IB_RAM_PEND),
	.VNU_BUBBLE(`VNU_BUBBLE),
	.MEM_FETCH(`MEM_FETCH),
	.CNU_PIPE(`CNU_PIPE),
	.CNU_OUT(`CNU_OUT),
	.BS_WB(`BS_WB),
	.PAGE_ALIGN(`PAGE_ALIGN),
	.MEM_WB(`MEM_WB),
	.IDLE(`IDLE),
	.VN_PIPELINE_BUBBLE(`VN_PIPELINE_BUBBLE),
	.VNU_FUNC_CYCLE(`VNU_FUNC_CYCLE),
	.DNU_FUNC_CYCLE(`DNU_FUNC_CYCLE),
	.VNU_FUNC_MEM_END(`VNU_FUNC_MEM_END),
	.DNU_FUNC_MEM_END(`DNU_FUNC_MEM_END),
	.VNU_WR_HANDSHAKE_RESPONSE(`VNU_WR_HANDSHAKE_RESPONSE),
	.DNU_WR_HANDSHAKE_RESPONSE(`DNU_WR_HANDSHAKE_RESPONSE),
	.VNU_PIPELINE_LEVEL(`VNU_PIPELINE_LEVEL),
	.DNU_PIPELINE_LEVEL(`DNU_PIPELINE_LEVEL),
	.PERMUTATION_LEVEL(`PERMUTATION_LEVEL),
	.PAGE_ALIGN_LEVEL(`PAGE_ALIGN_LEVEL),
	.CH_BUBBLE_LEVEL(`CH_BUBBLE_LEVEL),
	.PAGE_MEM_WB_LEVEL(`PAGE_MEM_WB_LEVEL),
	.MEM_RD_LEVEL(`MEM_RD_LEVEL),
	.CTRL_FSM_STATE_NUM(`CTRL_FSM_STATE_NUM),
	.WR_FSM_STATE_NUM(`WR_FSM_STATE_NUM),
	.VNU_INIT_LOAD(`VNU_INIT_LOAD),
	.VNU_VNU_IB_RAM_PEND(`VNU_VNU_IB_RAM_PEND),
	.VNU_CH_FETCH(`VNU_CH_FETCH),
	.CH_BUBBLE(`CH_BUBBLE),
	.VNU_MEM_FETCH(`VNU_MEM_FETCH),
	.VNU_VNU_PIPE(`VNU_VNU_PIPE),
	.VNU_VNU_OUT(`VNU_VNU_OUT),
	.VNU_BS_WB(`VNU_BS_WB),
	.VNU_PAGE_ALIGN(`VNU_PAGE_ALIGN),
	.VNU_MEM_WB(`VNU_MEM_WB),
	.VNU_IDLE(`VNU_IDLE),
	.RAM_DEPTH(`RAM_DEPTH),
	.RAM_ADDR_BITWIDTH(`RAM_ADDR_BITWIDTH),
	.BITWIDTH_SHIFT_FACTOR(`BITWIDTH_SHIFT_FACTOR),
	.shift_factor_0(`shift_factor_0),
	.shift_factor_1(`shift_factor_1),
	.shift_factor_2(`shift_factor_2),
	.RAM_PORTA_RANGE(`RAM_PORTA_RANGE),
	.RAM_PORTB_RANGE(`RAM_PORTB_RANGE),
	.MEM_DEVICE_NUM(`MEM_DEVICE_NUM),
	.V2C_DATA_WIDTH(`V2C_DATA_WIDTH),
	.C2V_DATA_WIDTH(`C2V_DATA_WIDTH),
	.C2V_MEM_ADDR_BASE(`C2V_MEM_ADDR_BASE),
	.V2C_MEM_ADDR_BASE(`V2C_MEM_ADDR_BASE),
	.CH_INIT_LOAD_LEVEL(`CH_INIT_LOAD_LEVEL),
	.CH_FETCH_LATENCY(`CH_FETCH_LATENCY),
	.CNU_INIT_FETCH_LATENCY(`CNU_INIT_FETCH_LATENCY),
	.CH_DATA_WIDTH(`CH_DATA_WIDTH),
	.CH_MSG_NUM(`CH_MSG_NUM),
	.CH_RAM_DEPTH(`CH_RAM_DEPTH),
	.CH_RAM_ADDR_WIDTH(`CH_RAM_ADDR_WIDTH),
	.CH_RAM_INIT_WR_ADDR_BASE(`CH_RAM_INIT_WR_ADDR_BASE),
	.CH_RAM_INIT_WB_ADDR_BASE_0(`CH_RAM_INIT_WB_ADDR_BASE_0),
	.CH_RAM_INIT_WB_ADDR_BASE_1(`CH_RAM_INIT_WB_ADDR_BASE_1),
	.CH_RAM_INIT_RD_ADDR_BASE(`CH_RAM_INIT_RD_ADDR_BASE),
	.SIGN_EXTEN_FF_TO_BS(`SIGN_EXTEN_FF_TO_BS),
	.PA_TO_DNU_DELAY(`PA_TO_DNU_DELAY),
	.V2C_TO_DNU_LATENCY(`V2C_TO_DNU_LATENCY),
	.C2V_TO_DNU_LATENCY(`C2V_TO_DNU_LATENCY),
	.SIGN_EXTEN_LAYER_CNT_EXTEN(`SIGN_EXTEN_LAYER_CNT_EXTEN),
	.shift_factor_1_0(`shift_factor_1_0),
	.shift_factor_1_1(`shift_factor_1_1),
	.shift_factor_1_2(`shift_factor_1_2),
	.shift_factor_2_0(`shift_factor_2_0),
	.shift_factor_2_1(`shift_factor_2_1),
	.shift_factor_2_2(`shift_factor_2_2),
	.shift_factor_3_0(`shift_factor_3_0),
	.shift_factor_3_1(`shift_factor_3_1),
	.shift_factor_3_2(`shift_factor_3_2),
	.shift_factor_4_0(`shift_factor_4_0),
	.shift_factor_4_1(`shift_factor_4_1),
	.shift_factor_4_2(`shift_factor_4_2),
	.shift_factor_5_0(`shift_factor_5_0),
	.shift_factor_5_1(`shift_factor_5_1),
	.shift_factor_5_2(`shift_factor_5_2),
	.shift_factor_6_0(`shift_factor_6_0),
	.shift_factor_6_1(`shift_factor_6_1),
	.shift_factor_6_2(`shift_factor_6_2),
	.shift_factor_7_0(`shift_factor_7_0),
	.shift_factor_7_1(`shift_factor_7_1),
	.shift_factor_7_2(`shift_factor_7_2),
	.shift_factor_8_0(`shift_factor_8_0),
	.shift_factor_8_1(`shift_factor_8_1),
	.shift_factor_8_2(`shift_factor_8_2),
	.shift_factor_9_0(`shift_factor_9_0),
	.shift_factor_9_1(`shift_factor_9_1),
	.shift_factor_9_2(`shift_factor_9_2),
	.C2V_SHIFT_FACTOR_1_0(`C2V_SHIFT_FACTOR_1_0),
	.C2V_SHIFT_FACTOR_1_1(`C2V_SHIFT_FACTOR_1_1),
	.C2V_SHIFT_FACTOR_1_2(`C2V_SHIFT_FACTOR_1_2),
	.C2V_SHIFT_FACTOR_2_0(`C2V_SHIFT_FACTOR_2_0),
	.C2V_SHIFT_FACTOR_2_1(`C2V_SHIFT_FACTOR_2_1),
	.C2V_SHIFT_FACTOR_2_2(`C2V_SHIFT_FACTOR_2_2),
	.C2V_SHIFT_FACTOR_3_0(`C2V_SHIFT_FACTOR_3_0),
	.C2V_SHIFT_FACTOR_3_1(`C2V_SHIFT_FACTOR_3_1),
	.C2V_SHIFT_FACTOR_3_2(`C2V_SHIFT_FACTOR_3_2),
	.C2V_SHIFT_FACTOR_4_0(`C2V_SHIFT_FACTOR_4_0),
	.C2V_SHIFT_FACTOR_4_1(`C2V_SHIFT_FACTOR_4_1),
	.C2V_SHIFT_FACTOR_4_2(`C2V_SHIFT_FACTOR_4_2),
	.C2V_SHIFT_FACTOR_5_0(`C2V_SHIFT_FACTOR_5_0),
	.C2V_SHIFT_FACTOR_5_1(`C2V_SHIFT_FACTOR_5_1),
	.C2V_SHIFT_FACTOR_5_2(`C2V_SHIFT_FACTOR_5_2),
	.C2V_SHIFT_FACTOR_6_0(`C2V_SHIFT_FACTOR_6_0),
	.C2V_SHIFT_FACTOR_6_1(`C2V_SHIFT_FACTOR_6_1),
	.C2V_SHIFT_FACTOR_6_2(`C2V_SHIFT_FACTOR_6_2),
	.C2V_SHIFT_FACTOR_7_0(`C2V_SHIFT_FACTOR_7_0),
	.C2V_SHIFT_FACTOR_7_1(`C2V_SHIFT_FACTOR_7_1),
	.C2V_SHIFT_FACTOR_7_2(`C2V_SHIFT_FACTOR_7_2),
	.C2V_SHIFT_FACTOR_8_0(`C2V_SHIFT_FACTOR_8_0),
	.C2V_SHIFT_FACTOR_8_1(`C2V_SHIFT_FACTOR_8_1),
	.C2V_SHIFT_FACTOR_8_2(`C2V_SHIFT_FACTOR_8_2),
	.C2V_SHIFT_FACTOR_9_0(`C2V_SHIFT_FACTOR_9_0),
	.C2V_SHIFT_FACTOR_9_1(`C2V_SHIFT_FACTOR_9_1),
	.C2V_SHIFT_FACTOR_9_2(`C2V_SHIFT_FACTOR_9_2),
	.V2C_SHIFT_FACTOR_1_0(`V2C_SHIFT_FACTOR_1_0),
	.V2C_SHIFT_FACTOR_1_1(`V2C_SHIFT_FACTOR_1_1),
	.V2C_SHIFT_FACTOR_1_2(`V2C_SHIFT_FACTOR_1_2),
	.V2C_SHIFT_FACTOR_2_0(`V2C_SHIFT_FACTOR_2_0),
	.V2C_SHIFT_FACTOR_2_1(`V2C_SHIFT_FACTOR_2_1),
	.V2C_SHIFT_FACTOR_2_2(`V2C_SHIFT_FACTOR_2_2),
	.V2C_SHIFT_FACTOR_3_0(`V2C_SHIFT_FACTOR_3_0),
	.V2C_SHIFT_FACTOR_3_1(`V2C_SHIFT_FACTOR_3_1),
	.V2C_SHIFT_FACTOR_3_2(`V2C_SHIFT_FACTOR_3_2),
	.V2C_SHIFT_FACTOR_4_0(`V2C_SHIFT_FACTOR_4_0),
	.V2C_SHIFT_FACTOR_4_1(`V2C_SHIFT_FACTOR_4_1),
	.V2C_SHIFT_FACTOR_4_2(`V2C_SHIFT_FACTOR_4_2),
	.V2C_SHIFT_FACTOR_5_0(`V2C_SHIFT_FACTOR_5_0),
	.V2C_SHIFT_FACTOR_5_1(`V2C_SHIFT_FACTOR_5_1),
	.V2C_SHIFT_FACTOR_5_2(`V2C_SHIFT_FACTOR_5_2),
	.V2C_SHIFT_FACTOR_6_0(`V2C_SHIFT_FACTOR_6_0),
	.V2C_SHIFT_FACTOR_6_1(`V2C_SHIFT_FACTOR_6_1),
	.V2C_SHIFT_FACTOR_6_2(`V2C_SHIFT_FACTOR_6_2),
	.V2C_SHIFT_FACTOR_7_0(`V2C_SHIFT_FACTOR_7_0),
	.V2C_SHIFT_FACTOR_7_1(`V2C_SHIFT_FACTOR_7_1),
	.V2C_SHIFT_FACTOR_7_2(`V2C_SHIFT_FACTOR_7_2),
	.V2C_SHIFT_FACTOR_8_0(`V2C_SHIFT_FACTOR_8_0),
	.V2C_SHIFT_FACTOR_8_1(`V2C_SHIFT_FACTOR_8_1),
	.V2C_SHIFT_FACTOR_8_2(`V2C_SHIFT_FACTOR_8_2),
	.V2C_SHIFT_FACTOR_9_0(`V2C_SHIFT_FACTOR_9_0),
	.V2C_SHIFT_FACTOR_9_1(`V2C_SHIFT_FACTOR_9_1),
	.V2C_SHIFT_FACTOR_9_2(`V2C_SHIFT_FACTOR_9_2),
	.CH_WB_SHIFT_FACTOR_1_0(`CH_WB_SHIFT_FACTOR_1_0),
	.CH_WB_SHIFT_FACTOR_1_1(`CH_WB_SHIFT_FACTOR_1_1),
	.CH_WB_SHIFT_FACTOR_2_0(`CH_WB_SHIFT_FACTOR_2_0),
	.CH_WB_SHIFT_FACTOR_2_1(`CH_WB_SHIFT_FACTOR_2_1),
	.CH_WB_SHIFT_FACTOR_3_0(`CH_WB_SHIFT_FACTOR_3_0),
	.CH_WB_SHIFT_FACTOR_3_1(`CH_WB_SHIFT_FACTOR_3_1),
	.CH_WB_SHIFT_FACTOR_4_0(`CH_WB_SHIFT_FACTOR_4_0),
	.CH_WB_SHIFT_FACTOR_4_1(`CH_WB_SHIFT_FACTOR_4_1),
	.CH_WB_SHIFT_FACTOR_5_0(`CH_WB_SHIFT_FACTOR_5_0),
	.CH_WB_SHIFT_FACTOR_5_1(`CH_WB_SHIFT_FACTOR_5_1),
	.CH_WB_SHIFT_FACTOR_6_0(`CH_WB_SHIFT_FACTOR_6_0),
	.CH_WB_SHIFT_FACTOR_6_1(`CH_WB_SHIFT_FACTOR_6_1),
	.CH_WB_SHIFT_FACTOR_7_0(`CH_WB_SHIFT_FACTOR_7_0),
	.CH_WB_SHIFT_FACTOR_7_1(`CH_WB_SHIFT_FACTOR_7_1),
	.CH_WB_SHIFT_FACTOR_8_0(`CH_WB_SHIFT_FACTOR_8_0),
	.CH_WB_SHIFT_FACTOR_8_1(`CH_WB_SHIFT_FACTOR_8_1),
	.CH_WB_SHIFT_FACTOR_9_0(`CH_WB_SHIFT_FACTOR_9_0),
	.CH_WB_SHIFT_FACTOR_9_1(`CH_WB_SHIFT_FACTOR_9_1),
	.START_PAGE_0_0(`START_PAGE_0_0),
	.START_PAGE_0_1(`START_PAGE_0_1),
	.START_PAGE_0_2(`START_PAGE_0_2),
	.START_PAGE_1_0(`START_PAGE_1_0),
	.START_PAGE_1_1(`START_PAGE_1_1),
	.START_PAGE_1_2(`START_PAGE_1_2),
	.START_PAGE_2_0(`START_PAGE_2_0),
	.START_PAGE_2_1(`START_PAGE_2_1),
	.START_PAGE_2_2(`START_PAGE_2_2),
	.START_PAGE_3_0(`START_PAGE_3_0),
	.START_PAGE_3_1(`START_PAGE_3_1),
	.START_PAGE_3_2(`START_PAGE_3_2),
	.START_PAGE_4_0(`START_PAGE_4_0),
	.START_PAGE_4_1(`START_PAGE_4_1),
	.START_PAGE_4_2(`START_PAGE_4_2),
	.START_PAGE_5_0(`START_PAGE_5_0),
	.START_PAGE_5_1(`START_PAGE_5_1),
	.START_PAGE_5_2(`START_PAGE_5_2),
	.START_PAGE_6_0(`START_PAGE_6_0),
	.START_PAGE_6_1(`START_PAGE_6_1),
	.START_PAGE_6_2(`START_PAGE_6_2),
	.START_PAGE_7_0(`START_PAGE_7_0),
	.START_PAGE_7_1(`START_PAGE_7_1),
	.START_PAGE_7_2(`START_PAGE_7_2),
	.START_PAGE_8_0(`START_PAGE_8_0),
	.START_PAGE_8_1(`START_PAGE_8_1),
	.START_PAGE_8_2(`START_PAGE_8_2),
	.START_PAGE_9_0(`START_PAGE_9_0),
	.START_PAGE_9_1(`START_PAGE_9_1),
	.START_PAGE_9_2(`START_PAGE_9_2),
	.C2V_START_PAGE_0_0(`C2V_START_PAGE_0_0),
	.C2V_START_PAGE_0_1(`C2V_START_PAGE_0_1),
	.C2V_START_PAGE_0_2(`C2V_START_PAGE_0_2),
	.C2V_START_PAGE_1_0(`C2V_START_PAGE_1_0),
	.C2V_START_PAGE_1_1(`C2V_START_PAGE_1_1),
	.C2V_START_PAGE_1_2(`C2V_START_PAGE_1_2),
	.C2V_START_PAGE_2_0(`C2V_START_PAGE_2_0),
	.C2V_START_PAGE_2_1(`C2V_START_PAGE_2_1),
	.C2V_START_PAGE_2_2(`C2V_START_PAGE_2_2),
	.C2V_START_PAGE_3_0(`C2V_START_PAGE_3_0),
	.C2V_START_PAGE_3_1(`C2V_START_PAGE_3_1),
	.C2V_START_PAGE_3_2(`C2V_START_PAGE_3_2),
	.C2V_START_PAGE_4_0(`C2V_START_PAGE_4_0),
	.C2V_START_PAGE_4_1(`C2V_START_PAGE_4_1),
	.C2V_START_PAGE_4_2(`C2V_START_PAGE_4_2),
	.C2V_START_PAGE_5_0(`C2V_START_PAGE_5_0),
	.C2V_START_PAGE_5_1(`C2V_START_PAGE_5_1),
	.C2V_START_PAGE_5_2(`C2V_START_PAGE_5_2),
	.C2V_START_PAGE_6_0(`C2V_START_PAGE_6_0),
	.C2V_START_PAGE_6_1(`C2V_START_PAGE_6_1),
	.C2V_START_PAGE_6_2(`C2V_START_PAGE_6_2),
	.C2V_START_PAGE_7_0(`C2V_START_PAGE_7_0),
	.C2V_START_PAGE_7_1(`C2V_START_PAGE_7_1),
	.C2V_START_PAGE_7_2(`C2V_START_PAGE_7_2),
	.C2V_START_PAGE_8_0(`C2V_START_PAGE_8_0),
	.C2V_START_PAGE_8_1(`C2V_START_PAGE_8_1),
	.C2V_START_PAGE_8_2(`C2V_START_PAGE_8_2),
	.C2V_START_PAGE_9_0(`C2V_START_PAGE_9_0),
	.C2V_START_PAGE_9_1(`C2V_START_PAGE_9_1),
	.C2V_START_PAGE_9_2(`C2V_START_PAGE_9_2),
	.V2C_START_PAGE_0_0(`V2C_START_PAGE_0_0),
	.V2C_START_PAGE_0_1(`V2C_START_PAGE_0_1),
	.V2C_START_PAGE_0_2(`V2C_START_PAGE_0_2),
	.V2C_START_PAGE_1_0(`V2C_START_PAGE_1_0),
	.V2C_START_PAGE_1_1(`V2C_START_PAGE_1_1),
	.V2C_START_PAGE_1_2(`V2C_START_PAGE_1_2),
	.V2C_START_PAGE_2_0(`V2C_START_PAGE_2_0),
	.V2C_START_PAGE_2_1(`V2C_START_PAGE_2_1),
	.V2C_START_PAGE_2_2(`V2C_START_PAGE_2_2),
	.V2C_START_PAGE_3_0(`V2C_START_PAGE_3_0),
	.V2C_START_PAGE_3_1(`V2C_START_PAGE_3_1),
	.V2C_START_PAGE_3_2(`V2C_START_PAGE_3_2),
	.V2C_START_PAGE_4_0(`V2C_START_PAGE_4_0),
	.V2C_START_PAGE_4_1(`V2C_START_PAGE_4_1),
	.V2C_START_PAGE_4_2(`V2C_START_PAGE_4_2),
	.V2C_START_PAGE_5_0(`V2C_START_PAGE_5_0),
	.V2C_START_PAGE_5_1(`V2C_START_PAGE_5_1),
	.V2C_START_PAGE_5_2(`V2C_START_PAGE_5_2),
	.V2C_START_PAGE_6_0(`V2C_START_PAGE_6_0),
	.V2C_START_PAGE_6_1(`V2C_START_PAGE_6_1),
	.V2C_START_PAGE_6_2(`V2C_START_PAGE_6_2),
	.V2C_START_PAGE_7_0(`V2C_START_PAGE_7_0),
	.V2C_START_PAGE_7_1(`V2C_START_PAGE_7_1),
	.V2C_START_PAGE_7_2(`V2C_START_PAGE_7_2),
	.V2C_START_PAGE_8_0(`V2C_START_PAGE_8_0),
	.V2C_START_PAGE_8_1(`V2C_START_PAGE_8_1),
	.V2C_START_PAGE_8_2(`V2C_START_PAGE_8_2),
	.V2C_START_PAGE_9_0(`V2C_START_PAGE_9_0),
	.V2C_START_PAGE_9_1(`V2C_START_PAGE_9_1),
	.V2C_START_PAGE_9_2(`V2C_START_PAGE_9_2),
	.CNU_LAYER_ORDER_0(`CNU_LAYER_ORDER_0),
	.CNU_LAYER_ORDER_1(`CNU_LAYER_ORDER_1),
	.CNU_LAYER_ORDER_2(`CNU_LAYER_ORDER_2),
	.VNU_LAYER_ORDER_0(`VNU_LAYER_ORDER_0),
	.VNU_LAYER_ORDER_1(`VNU_LAYER_ORDER_1),
	.VNU_LAYER_ORDER_2(`VNU_LAYER_ORDER_2),
	.DEPTH(`DEPTH),
	.DATA_WIDTH(`DATA_WIDTH),
	.FRAG_DATA_WIDTH(`FRAG_DATA_WIDTH),
	.ADDR_WIDTH(`ADDR_WIDTH)
inst_entire_layer_decoder_tb (
	.hard_decision_sub0 (hard_decision_sub[0]),
	.hard_decision_sub1 (hard_decision_sub[1]),
	.hard_decision_sub2 (hard_decision_sub[2]),
	.hard_decision_sub3 (hard_decision_sub[3]),
	.hard_decision_sub4 (hard_decision_sub[4]),
	.hard_decision_sub5 (hard_decision_sub[5]),
	.hard_decision_sub6 (hard_decision_sub[6]),
	.hard_decision_sub7 (hard_decision_sub[7]),
	.hard_decision_sub8 (hard_decision_sub[8]),
	.hard_decision_sub9 (hard_decision_sub[9]),

	.decode_busy        (decode_busy),
	.decode_termination (decode_termination),
	.iter_cnt           (iter_cnt),
	.decode_fail        (decode_fail),
	//.v2c_load_debug     (v2c_load_debug),

	.coded_block_sub0   (coded_block_sub[0]),
	.coded_block_sub1   (coded_block_sub[1]),
	.coded_block_sub2   (coded_block_sub[2]),
	.coded_block_sub3   (coded_block_sub[3]),
	.coded_block_sub4   (coded_block_sub[4]),
	.coded_block_sub5   (coded_block_sub[5]),
	.coded_block_sub6   (coded_block_sub[6]),
	.coded_block_sub7   (coded_block_sub[7]),
	.coded_block_sub8   (coded_block_sub[8]),
	.coded_block_sub9   (coded_block_sub[9]),
	.zero_err_symbol    (zero_err_symbol),
	.block_cnt_full     (block_cnt_full),
	.read_clk           (clk),
	.vn_write_clk       (write_clk),
	.dn_write_clk       (write_clk),
	.decoder_rstn       (decoder_rstn)
);
assign ready_slave = symbol_gen_ce;
assign is_awgn_out = decode_termination;
/*-----------------------------------------------------------------------------------------------------------------*/
wire [$clog2(`SUBMATRIX_Z*`CN_DEGREE)-1:0] err_count;
wire isErrFrame;
wire count_done;
wire busy;

reg errBit_cnt_en;
errBit_cnt_top #(
    .VN_NUM             (`SUBMATRIX_Z*CN_DEGREE),//7650,
    .N                  (`CHECK_PARALLELISM*CN_DEGREE),//850,
    .ROW_CHUNK_NUM      (`ROW_CHUNK_NUM), //9, // VN_NUM / N
    .ERR_BIT_BITWIDTH_Z ($clog2(`CHECK_PARALLELISM*`CN_DEGREE)),
    .ERR_BIT_BITWIDTH   ($clog2(`SUBMATRIX_Z*`CN_DEGREE)),
	.PIPELINE_DEPTH     (5),
	.SYN_LATENCY (2) // to prolong the assertion of "count_done" singal for two clock cycles, in order to make top module of decoder can catch the assertion state
					 // Because the clock rate of errBit_cnt_top is double of the decoder top module's clcok rate
) errBit_cnt_top_u0(
    .err_count (err_count[$clog2(`SUBMATRIX_Z*`CN_DEGREE)-1:0]),
    .isErrFrame (isErrFrame),
	.count_done (count_done),
	.busy (busy),
	
    .hard_frame ({hard_decision_sub[9], hard_decision_sub[8], hard_decision_sub[7], hard_decision_sub[6], hard_decision_sub[5], hard_decision_sub[4], hard_decision_sub[3], hard_decision_sub[2], hard_decision_sub[1], hard_decision_sub[0]}),
    .eval_clk (read_clk),
    .en (decode_termination),
    .rstn (sys_rstn)
);
/*-----------------------------------------------------------------------------------------------------------------*/
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
/*
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