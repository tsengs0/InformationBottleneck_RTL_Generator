`timescale 1 ps / 1 ps

module symbol_gen_ber_eval # (
	parameter N = 204, // block length
	parameter QUAN_SIZE = 4,
	parameter MAGNITUDE_SIZE = QUAN_SIZE-1
)(
    output wire ready_work,
	output wire is_awgn_out, // to check if there is any AWGN signal generated

    input wire CLK_300_N,
    input wire CLK_300_P,
    input wire GPIO_PB_SW2, // for PLL Rst
    input wire GPIO_PB_SW3 // for System RSTn
);

	localparam [15:0] std_dev_0 = 16'b0000010110101000;
	localparam [15:0] std_dev_1 = 16'b0000010100001010;
	localparam [15:0] std_dev_2 = 16'b0000010001111110; 
	localparam [15:0] std_dev_3 = 16'b0000010000000001;
	localparam [15:0] std_dev_4 = 16'b0000001110010001;
	localparam [15:0] std_dev_5 = 16'b0000001100101110;
	localparam [15:0] std_dev_6 = 16'b0000001011010101;
	localparam [15:0] std_dev_7 = 16'b0000001010000110;
	localparam [15:0] std_dev_8 = 16'b0000001001000000;
	localparam [15:0] std_dev_9 = 16'b0000001000000001;
	localparam [15:0] std_dev_10 = 16'b0000000111001001;
	//localparam integer CH_MSG_BUFFER_DEPTH = 1; // the depth of channel-message buffer used for fowarding to the decoder
	localparam integer ERR_CNT_PACKET_SIZE = 28;
	localparam integer SNR_PACKET_SIZE = 4;
	wire [15:0] sigma_in [0:(2**SNR_PACKET_SIZE)-1];
	reg [SNR_PACKET_SIZE-1:0] snr_packet = 10;
    assign sigma_in[0 ] = std_dev_0[15:0];
	assign sigma_in[1 ] = std_dev_1[15:0];
	assign sigma_in[2 ] = std_dev_2[15:0];
	assign sigma_in[3 ] = std_dev_3[15:0];
	assign sigma_in[4 ] = std_dev_4[15:0];
	assign sigma_in[5 ] = std_dev_5[15:0];
	assign sigma_in[6 ] = std_dev_6[15:0];
	assign sigma_in[7 ] = std_dev_7[15:0];
	assign sigma_in[8 ] = std_dev_8[15:0];
	assign sigma_in[9 ] = std_dev_9[15:0];
	assign sigma_in[10] = std_dev_10[15:0];
	
	//wire result_fifo_we;
	reg result_fifo_we;
	wire clk_lock, clk_100MHz, clk_200MHz, clk_300MHz;
	wire pl_fifo_wr_clk, read_clk, write_clk;
	wire pll_rst, sys_rstn, symbol_gen_ce;  
	wire [N-1:0] hard_decision;
	wire [QUAN_SIZE-1:0] ch_msg [0:N-1];
	wire decode_busy, decode_termination;
    
	assign pll_rst = GPIO_PB_SW2;
	assign sys_rstn = ~GPIO_PB_SW3;
	assign symbol_gen_ce = clk_lock; //sys_rstn;
	
	clock_domain_wrapper clock_u0 (
		.clk_100MHz (clk_100MHz),
		.clk_200MHz (clk_200MHz),
		.clk_300MHz (clk_300MHz),
		.clk_300mhz_clk_n (CLK_300_N),
		.clk_300mhz_clk_p (CLK_300_P),
		.locked (clk_lock),
		.reset_0 (pll_rst)
	);
	assign pl_fifo_wr_clk = (clk_lock & clk_300MHz);
	assign read_clk = (clk_lock & clk_100MHz);
	assign write_clk = (clk_lock & clk_200MHz);
	//assign result_fifo_we = clk_lock;
	assign ready_work = result_fifo_we;

	//localparam frame_cnt_width = $clog2(CH_MSG_BUFFER_DEPTH);
	//reg [frame_cnt_width-1:0] frame_buffer_cnt;
	wire [N*QUAN_SIZE-1:0] coded_block;
	wire tvalid_master, ready_slave;
	// First codeword will takes 51+24=75 clock cycles to be generated
	// From the second codeword the latency is 51 clcok cycles due to the pipeline fashion
	receivedBlock_generator block_gen_u0(
		.coded_block (coded_block[N*QUAN_SIZE-1:0]),
		.tvalid_master (tvalid_master),
		
		.sigma_in (sigma_in[snr_packet[SNR_PACKET_SIZE-1:0]]),
		//input wire [63:0] seed_base_0,
		//input wire [63:0] seed_base_1,
		//input wire [63:0] seed_base_2,
		.ready_slave (ready_slave),
		.rstn (sys_rstn),
		.sys_clk (pl_fifo_wr_clk)
	);
/*-----------------------------------------------------------------------------------------------------------------*/
// Instantiation of Decoder unit
generate
	genvar n;
	for(n = 0; n < N; n=n+1) begin : ch_msg_assignment
		assign ch_msg[n] = coded_block[ ((n+1)*QUAN_SIZE)-1 : (n*QUAN_SIZE) ];
	end
endgenerate
entire_decoder_tb entire_decoder_u0(
	.hard_decision_o (hard_decision[N-1:0]),
	.decode_busy (decode_busy),
	.decode_termination (decode_termination),

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
	.read_clk (read_clk),
	.cn_write_clk (write_clk),
	.vn_write_clk (write_clk),
	.dn_write_clk (write_clk),
	.rstn (sys_rstn)
);
assign ready_slave = symbol_gen_ce;
assign is_awgn_out = decode_termination;
/*-----------------------------------------------------------------------------------------------------------------*/	
// Dummy module for DUT
/*
	wire [N*MAGNITUDE_SIZE-1:0] ch_msg_mag;
	generate
		genvar i;
		for(i=0; i < N; i = i+1) begin : ch_msg_mag_inst
			assign ch_msg_mag[(i+1)*MAGNITUDE_SIZE-1:i*MAGNITUDE_SIZE] = coded_block[(i+1)*QUAN_SIZE-2:i*QUAN_SIZE];
			assign hard_decision[i] = coded_block[(i+1)*QUAN_SIZE-1];
		end
	endgenerate
	awgn_exist_dut #(.N (N), .MAG_BITWIDTH (MAGNITUDE_SIZE)) is_awgn_dut_u0 (
		.is_signal (is_awgn_out),
		.ch_msg_mag (ch_msg_mag[N*MAGNITUDE_SIZE-1:0])
	);
	*/
/*-----------------------------------------------------------------------------------------------------------------*/
/*
    // To evaluate the number of bit error over current block
	localparam errCnt_width = $clog2(N);
	wire [errCnt_width-1:0] err_count;
	wire busy;
	localparam errBit_cnt_depth = 3;
	errBit_cnt_top #(.PIPELINE_DEPTH (errBit_cnt_depth)) errBit_cnt_204 (
		.err_count (err_count[errCnt_width-1:0]),
		.busy (busy),
		
		.hard_frame (hard_decision[N-1:0]),
		.eval_clk (pl_fifo_wr_clk),
		.en (tvalid_master),
		.rstn (sys_rstn)
	);
	assign ready_slave = symbol_gen_ce & ~busy;
*/	

/*
	// Counting the number of evaluated blocks
	wire block_cnt_clk; assign block_cnt_clk = pl_fifo_wr_clk;
	reg [errBit_cnt_depth-1:0] frame_sync;
	reg [19:0] block_cnt;
	localparam [2:0] frame_sync_sign = 3'b110;
    initial begin
        frame_sync <= 1'b0;
        block_cnt[19:0] <= 20'd0;
    end
    always @(posedge block_cnt_clk, negedge sys_rstn) begin
        if(sys_rstn == 1'b0) frame_sync <= 0;
        else frame_sync[errBit_cnt_depth-1:0] <= {busy, frame_sync[errBit_cnt_depth-1:1]};
    end
	always @(posedge block_cnt_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) block_cnt[19:0] <= 20'd0;
		else if(frame_sync[errBit_cnt_depth-1:0] == frame_sync_sign) begin
		  if(block_cnt[19:0] == 0) block_cnt[19:0] <= 2;
		  else block_cnt[19:0] <= block_cnt[19:0] + 1'b1;
		end
	end

	// Accumulating error bits among all evaluated blocks
	reg [ERR_CNT_PACKET_SIZE-1:0] err_cnt_acc;
	initial err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0] <= 0;
	always @(posedge block_cnt_clk, negedge sys_rstn) begin
		if(sys_rstn == 1'b0) 
			err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0] <= 0;
			
		else if(frame_sync[errBit_cnt_depth-1:0] == frame_sync_sign && block_cnt[19:0] >= 4) begin
		  if(block_cnt[19:0] == 0) err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0] <= {12'd0, err_count[errCnt_width-1:0]};
		  else err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0] <= err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0] + {12'd0, err_count[errCnt_width-1:0]};
		end
		
		else if(frame_sync[errBit_cnt_depth-1:0] == frame_sync_sign && block_cnt[19:0] < 4) begin
			err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0] <= 0;
		end
	end
	
	reg [31:0] result_fifo_in;
	initial result_fifo_in[31:0] <= 32'd0;
	always @(posedge pl_fifo_wr_clk) begin
		if(!sys_rstn)
			result_fifo_in[31:0] <= 32'd0;
        else if(frame_sync[errBit_cnt_depth-1:0] == frame_sync_sign && block_cnt[19:0] >= 4) begin
			result_fifo_in[31:0] <= {err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0], snr_packet[SNR_PACKET_SIZE-1:0]};
			result_fifo_we <= 1'b1;
		end
		else begin
	       result_fifo_in[31:0] <= {err_cnt_acc[ERR_CNT_PACKET_SIZE-1:0], 4'b1111};
		   result_fifo_we <= 1'b1;
		end
	end

	design_1_wrapper design_1_i (
		.pl_fifo_wr_clk(pl_fifo_wr_clk),
        .result_fifo_in(result_fifo_in[31:0]),
        .result_fifo_we(result_fifo_we)
	);
*/	
endmodule

module awgn_exist_dut #(
	parameter N = 204,
	parameter MAG_BITWIDTH = 3
) (
	output wire is_signal,
	input wire [N*MAG_BITWIDTH-1:0] ch_msg_mag
);
 assign is_signal = {|ch_msg_mag[N*MAG_BITWIDTH-1:0]};
endmodule
