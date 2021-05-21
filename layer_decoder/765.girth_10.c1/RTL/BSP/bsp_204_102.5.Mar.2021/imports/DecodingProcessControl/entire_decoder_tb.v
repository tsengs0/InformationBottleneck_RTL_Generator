`timescale 1ns / 1ps
`include "define.vh"

module entire_decoder_tb #(
	parameter CN_NUM = 102, // # CNsc2v_latch
	parameter VN_NUM = 204, // # VNs 
	parameter VN_DEGREE = 3,   // degree of one variable node
	parameter CN_DEGREE = 6,  // degree of one check node 
	
	parameter IB_ROM_SIZE = 6, // width of one read-out port of RAMB36E1
	parameter IB_ROM_ADDR_WIDTH = 6, // ceil(log2(64-entry)) = 6-bit 
	parameter IB_CNU_DECOMP_funNum = CN_DEGREE-2,
	parameter IB_VNU_DECOMP_funNum = VN_DEGREE+1-2,
	parameter IB_DNU_DECOMP_funNum = 1,

	parameter ITER_ADDR_BW = 6,  // bit-width of addressing 50 iterationss
    parameter ITER_ROM_GROUP = 25, // the number of iteration datasets stored in one Group of IB-ROMs
	parameter MAX_ITER = 50,

	parameter CNU6_INSTANTIATE_NUM  = 51,
	parameter CNU6_INSTANTIATE_UNIT =  2,
	parameter VNU3_INSTANTIATE_NUM  = 51,
	parameter VNU3_INSTANTIATE_UNIT =  4,
	
	parameter QUAN_SIZE = 4,
	parameter DATAPATH_WIDTH = 4,
	
	/*CNUs*/
	parameter CN_ROM_RD_BW = 6,    // bit-width of one read port of BRAM based IB-ROM
	parameter CN_ROM_ADDR_BW = 10,  // bit-width of read address of BRAM based IB-ROM
								// #Entry: (64-entry*3-bit) / ROM_RD_BW)*25-iteration
								// ceil(log2(#Entry)) = 10-bit
	parameter CN_OVERPROVISION = 1, // the over-counted IB-ROM read address							
	parameter CN_PAGE_ADDR_BW = 5, // bit-width of addressing (64-entry*3-bit)/ROM_RD_BW), i.e., ceil(log2((64-entry*3-bit)/ROM_RD_BW)))								
	parameter CN_ITER_ADDR_BW = 5,  // bit-width of addressing 25 iterationss
	//parameter CN_TYPE_A = 1,    // the number of check node type in terms of its check node degree   
	//parameter CN_TYPE_B = 1,     // the number of check node type in terms of its check node degree
	parameter CN_LOAD_CYCLE = 32,// 64-entry with two interleaving banks requires 32 clock cycle to finish iteration update
	parameter CN_RD_BW = 6,
	parameter CN_ADDR_BW = 10,
	parameter CN_PIPELINE_DEPTH = 3,
	
	/*VNUs and DNUs*/
	parameter VN_QUAN_SIZE = 4,
	parameter VN_ROM_RD_BW = 8,    // bit-width of one read port of BRAM based IB-ROM
	parameter VN_ROM_ADDR_BW = 11,  // bit-width of read address of BRAM based IB-ROM
								// #Entry: (128-entry*4-bit) / ROM_RD_BW)*25-iteration
	parameter VN_PIPELINE_DEPTH = 3,

	parameter VN_OVERPROVISION = 1, // the over-counted IB-ROM read address								// ceil(log2(#Entry)) = 11-bit
	parameter DN_QUAN_SIZE = 1,
	parameter DN_ROM_RD_BW = 2,    // bit-width of one read port of BRAM based IB-ROM
	parameter DN_ROM_ADDR_BW = 11,  // bit-width of read address of BRAM based IB-ROM
								// #Entry: (128-entry*4-bit) / ROM_RD_BW)*25-iteration
								// ceil(log2(#Entry)) = 11-bit
	
	parameter DN_OVERPROVISION = 1, // the over-counted IB-ROM read address	
	parameter VN_PAGE_ADDR_BW = 6, // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
	parameter VN_ITER_ADDR_BW = 5,  // bit-width of addressing 25 iterationss
	//parameter VN_TYPE_A = 1,    // the number of check node type in terms of its check node degree   
	//parameter VN_TYPE_B = 1,     // the number of check node type in terms of its check node degree
	parameter DN_PAGE_ADDR_BW = 6, // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
	parameter DN_ITER_ADDR_BW = 5,  // bit-width of addressing 25 iterationss
	parameter DN_PIPELINE_DEPTH = 3,
	//parameter DN_TYPE_A = 1,    // the number of check node type in terms of its check node degree   
	//parameter DN_TYPE_B = 1,     // the number of check node type in terms of its check node degree
	parameter VN_LOAD_CYCLE = 64, // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
	parameter DN_LOAD_CYCLE = 64, // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
	parameter VN_RD_BW = 8,
	parameter DN_RD_BW = 2,
	parameter VN_ADDR_BW = 11,
	parameter DN_ADDR_BW = 11,

	parameter BANK_NUM = 2,
	parameter MULTI_FRAME_NUM = 2,

	parameter CNU_FUNC_CYCLE   = 3, // the latency of one CNU 2-LUT function based on symmetrical design
	parameter VNU_FUNC_CYCLE   = 3, // the latency of one VNU 2-LUT function based on symmetrical design
	parameter DNU_FUNC_CYCLE   = 3, // the latency of one DNU 2-LUT function based on symmetrical design
	parameter CNU_FUNC_MEM_END = 2, // the Memory Read ends at rising edge of 2nd clock (indexed from 0th cycle)
	parameter VNU_FUNC_MEM_END = 2, // the Memory Read ends at rising edge of 2nd clock (indexed from 0th cycle)
	parameter DNU_FUNC_MEM_END = 2, // the Memory Read ends at rising edge of 2nd clock (indexed from 0th cycle)
	parameter CNU_WR_HANDSHAKE_RESPONSE = 2, // response time from assertion of pipe_load_start until rising edge of cnu_wr
	parameter VNU_WR_HANDSHAKE_RESPONSE = 2, // response time from assertion of pipe_load_start until rising edge of vnu_wr
	parameter DNU_WR_HANDSHAKE_RESPONSE = 2  // response time from assertion of pipe_load_start until rising edge of vnu_wr
) (
	output wire [VN_NUM-1:0] hard_decision_o,
	output reg decode_busy,
	output wire decode_termination,
	output reg [ITER_ADDR_BW-1:0] iter_cnt,
	output reg decode_fail,
	`ifdef AWGN_GEN_VERIFY
		output wire v2c_load_debug,
	`endif

	input wire [QUAN_SIZE-1:0] ch_msg_0  ,
	input wire [QUAN_SIZE-1:0] ch_msg_1  ,
	input wire [QUAN_SIZE-1:0] ch_msg_2  ,
	input wire [QUAN_SIZE-1:0] ch_msg_3  ,
	input wire [QUAN_SIZE-1:0] ch_msg_4  ,
	input wire [QUAN_SIZE-1:0] ch_msg_5  ,
	input wire [QUAN_SIZE-1:0] ch_msg_6  ,
	input wire [QUAN_SIZE-1:0] ch_msg_7  ,
	input wire [QUAN_SIZE-1:0] ch_msg_8  ,
	input wire [QUAN_SIZE-1:0] ch_msg_9  ,
	input wire [QUAN_SIZE-1:0] ch_msg_10 ,
	input wire [QUAN_SIZE-1:0] ch_msg_11 ,
	input wire [QUAN_SIZE-1:0] ch_msg_12 ,
	input wire [QUAN_SIZE-1:0] ch_msg_13 ,
	input wire [QUAN_SIZE-1:0] ch_msg_14 ,
	input wire [QUAN_SIZE-1:0] ch_msg_15 ,
	input wire [QUAN_SIZE-1:0] ch_msg_16 ,
	input wire [QUAN_SIZE-1:0] ch_msg_17 ,
	input wire [QUAN_SIZE-1:0] ch_msg_18 ,
	input wire [QUAN_SIZE-1:0] ch_msg_19 ,
	input wire [QUAN_SIZE-1:0] ch_msg_20 ,
	input wire [QUAN_SIZE-1:0] ch_msg_21 ,
	input wire [QUAN_SIZE-1:0] ch_msg_22 ,
	input wire [QUAN_SIZE-1:0] ch_msg_23 ,
	input wire [QUAN_SIZE-1:0] ch_msg_24 ,
	input wire [QUAN_SIZE-1:0] ch_msg_25 ,
	input wire [QUAN_SIZE-1:0] ch_msg_26 ,
	input wire [QUAN_SIZE-1:0] ch_msg_27 ,
	input wire [QUAN_SIZE-1:0] ch_msg_28 ,
	input wire [QUAN_SIZE-1:0] ch_msg_29 ,
	input wire [QUAN_SIZE-1:0] ch_msg_30 ,
	input wire [QUAN_SIZE-1:0] ch_msg_31 ,
	input wire [QUAN_SIZE-1:0] ch_msg_32 ,
	input wire [QUAN_SIZE-1:0] ch_msg_33 ,
	input wire [QUAN_SIZE-1:0] ch_msg_34 ,
	input wire [QUAN_SIZE-1:0] ch_msg_35 ,
	input wire [QUAN_SIZE-1:0] ch_msg_36 ,
	input wire [QUAN_SIZE-1:0] ch_msg_37 ,
	input wire [QUAN_SIZE-1:0] ch_msg_38 ,
	input wire [QUAN_SIZE-1:0] ch_msg_39 ,
	input wire [QUAN_SIZE-1:0] ch_msg_40 ,
	input wire [QUAN_SIZE-1:0] ch_msg_41 ,
	input wire [QUAN_SIZE-1:0] ch_msg_42 ,
	input wire [QUAN_SIZE-1:0] ch_msg_43 ,
	input wire [QUAN_SIZE-1:0] ch_msg_44 ,
	input wire [QUAN_SIZE-1:0] ch_msg_45 ,
	input wire [QUAN_SIZE-1:0] ch_msg_46 ,
	input wire [QUAN_SIZE-1:0] ch_msg_47 ,
	input wire [QUAN_SIZE-1:0] ch_msg_48 ,
	input wire [QUAN_SIZE-1:0] ch_msg_49 ,
	input wire [QUAN_SIZE-1:0] ch_msg_50 ,
	input wire [QUAN_SIZE-1:0] ch_msg_51 ,
	input wire [QUAN_SIZE-1:0] ch_msg_52 ,
	input wire [QUAN_SIZE-1:0] ch_msg_53 ,
	input wire [QUAN_SIZE-1:0] ch_msg_54 ,
	input wire [QUAN_SIZE-1:0] ch_msg_55 ,
	input wire [QUAN_SIZE-1:0] ch_msg_56 ,
	input wire [QUAN_SIZE-1:0] ch_msg_57 ,
	input wire [QUAN_SIZE-1:0] ch_msg_58 ,
	input wire [QUAN_SIZE-1:0] ch_msg_59 ,
	input wire [QUAN_SIZE-1:0] ch_msg_60 ,
	input wire [QUAN_SIZE-1:0] ch_msg_61 ,
	input wire [QUAN_SIZE-1:0] ch_msg_62 ,
	input wire [QUAN_SIZE-1:0] ch_msg_63 ,
	input wire [QUAN_SIZE-1:0] ch_msg_64 ,
	input wire [QUAN_SIZE-1:0] ch_msg_65 ,
	input wire [QUAN_SIZE-1:0] ch_msg_66 ,
	input wire [QUAN_SIZE-1:0] ch_msg_67 ,
	input wire [QUAN_SIZE-1:0] ch_msg_68 ,
	input wire [QUAN_SIZE-1:0] ch_msg_69 ,
	input wire [QUAN_SIZE-1:0] ch_msg_70 ,
	input wire [QUAN_SIZE-1:0] ch_msg_71 ,
	input wire [QUAN_SIZE-1:0] ch_msg_72 ,
	input wire [QUAN_SIZE-1:0] ch_msg_73 ,
	input wire [QUAN_SIZE-1:0] ch_msg_74 ,
	input wire [QUAN_SIZE-1:0] ch_msg_75 ,
	input wire [QUAN_SIZE-1:0] ch_msg_76 ,
	input wire [QUAN_SIZE-1:0] ch_msg_77 ,
	input wire [QUAN_SIZE-1:0] ch_msg_78 ,
	input wire [QUAN_SIZE-1:0] ch_msg_79 ,
	input wire [QUAN_SIZE-1:0] ch_msg_80 ,
	input wire [QUAN_SIZE-1:0] ch_msg_81 ,
	input wire [QUAN_SIZE-1:0] ch_msg_82 ,
	input wire [QUAN_SIZE-1:0] ch_msg_83 ,
	input wire [QUAN_SIZE-1:0] ch_msg_84 ,
	input wire [QUAN_SIZE-1:0] ch_msg_85 ,
	input wire [QUAN_SIZE-1:0] ch_msg_86 ,
	input wire [QUAN_SIZE-1:0] ch_msg_87 ,
	input wire [QUAN_SIZE-1:0] ch_msg_88 ,
	input wire [QUAN_SIZE-1:0] ch_msg_89 ,
	input wire [QUAN_SIZE-1:0] ch_msg_90 ,
	input wire [QUAN_SIZE-1:0] ch_msg_91 ,
	input wire [QUAN_SIZE-1:0] ch_msg_92 ,
	input wire [QUAN_SIZE-1:0] ch_msg_93 ,
	input wire [QUAN_SIZE-1:0] ch_msg_94 ,
	input wire [QUAN_SIZE-1:0] ch_msg_95 ,
	input wire [QUAN_SIZE-1:0] ch_msg_96 ,
	input wire [QUAN_SIZE-1:0] ch_msg_97 ,
	input wire [QUAN_SIZE-1:0] ch_msg_98 ,
	input wire [QUAN_SIZE-1:0] ch_msg_99 ,
	input wire [QUAN_SIZE-1:0] ch_msg_100,
	input wire [QUAN_SIZE-1:0] ch_msg_101,
	input wire [QUAN_SIZE-1:0] ch_msg_102,
	input wire [QUAN_SIZE-1:0] ch_msg_103,
	input wire [QUAN_SIZE-1:0] ch_msg_104,
	input wire [QUAN_SIZE-1:0] ch_msg_105,
	input wire [QUAN_SIZE-1:0] ch_msg_106,
	input wire [QUAN_SIZE-1:0] ch_msg_107,
	input wire [QUAN_SIZE-1:0] ch_msg_108,
	input wire [QUAN_SIZE-1:0] ch_msg_109,
	input wire [QUAN_SIZE-1:0] ch_msg_110,
	input wire [QUAN_SIZE-1:0] ch_msg_111,
	input wire [QUAN_SIZE-1:0] ch_msg_112,
	input wire [QUAN_SIZE-1:0] ch_msg_113,
	input wire [QUAN_SIZE-1:0] ch_msg_114,
	input wire [QUAN_SIZE-1:0] ch_msg_115,
	input wire [QUAN_SIZE-1:0] ch_msg_116,
	input wire [QUAN_SIZE-1:0] ch_msg_117,
	input wire [QUAN_SIZE-1:0] ch_msg_118,
	input wire [QUAN_SIZE-1:0] ch_msg_119,
	input wire [QUAN_SIZE-1:0] ch_msg_120,
	input wire [QUAN_SIZE-1:0] ch_msg_121,
	input wire [QUAN_SIZE-1:0] ch_msg_122,
	input wire [QUAN_SIZE-1:0] ch_msg_123,
	input wire [QUAN_SIZE-1:0] ch_msg_124,
	input wire [QUAN_SIZE-1:0] ch_msg_125,
	input wire [QUAN_SIZE-1:0] ch_msg_126,
	input wire [QUAN_SIZE-1:0] ch_msg_127,
	input wire [QUAN_SIZE-1:0] ch_msg_128,
	input wire [QUAN_SIZE-1:0] ch_msg_129,
	input wire [QUAN_SIZE-1:0] ch_msg_130,
	input wire [QUAN_SIZE-1:0] ch_msg_131,
	input wire [QUAN_SIZE-1:0] ch_msg_132,
	input wire [QUAN_SIZE-1:0] ch_msg_133,
	input wire [QUAN_SIZE-1:0] ch_msg_134,
	input wire [QUAN_SIZE-1:0] ch_msg_135,
	input wire [QUAN_SIZE-1:0] ch_msg_136,
	input wire [QUAN_SIZE-1:0] ch_msg_137,
	input wire [QUAN_SIZE-1:0] ch_msg_138,
	input wire [QUAN_SIZE-1:0] ch_msg_139,
	input wire [QUAN_SIZE-1:0] ch_msg_140,
	input wire [QUAN_SIZE-1:0] ch_msg_141,
	input wire [QUAN_SIZE-1:0] ch_msg_142,
	input wire [QUAN_SIZE-1:0] ch_msg_143,
	input wire [QUAN_SIZE-1:0] ch_msg_144,
	input wire [QUAN_SIZE-1:0] ch_msg_145,
	input wire [QUAN_SIZE-1:0] ch_msg_146,
	input wire [QUAN_SIZE-1:0] ch_msg_147,
	input wire [QUAN_SIZE-1:0] ch_msg_148,
	input wire [QUAN_SIZE-1:0] ch_msg_149,
	input wire [QUAN_SIZE-1:0] ch_msg_150,
	input wire [QUAN_SIZE-1:0] ch_msg_151,
	input wire [QUAN_SIZE-1:0] ch_msg_152,
	input wire [QUAN_SIZE-1:0] ch_msg_153,
	input wire [QUAN_SIZE-1:0] ch_msg_154,
	input wire [QUAN_SIZE-1:0] ch_msg_155,
	input wire [QUAN_SIZE-1:0] ch_msg_156,
	input wire [QUAN_SIZE-1:0] ch_msg_157,
	input wire [QUAN_SIZE-1:0] ch_msg_158,
	input wire [QUAN_SIZE-1:0] ch_msg_159,
	input wire [QUAN_SIZE-1:0] ch_msg_160,
	input wire [QUAN_SIZE-1:0] ch_msg_161,
	input wire [QUAN_SIZE-1:0] ch_msg_162,
	input wire [QUAN_SIZE-1:0] ch_msg_163,
	input wire [QUAN_SIZE-1:0] ch_msg_164,
	input wire [QUAN_SIZE-1:0] ch_msg_165,
	input wire [QUAN_SIZE-1:0] ch_msg_166,
	input wire [QUAN_SIZE-1:0] ch_msg_167,
	input wire [QUAN_SIZE-1:0] ch_msg_168,
	input wire [QUAN_SIZE-1:0] ch_msg_169,
	input wire [QUAN_SIZE-1:0] ch_msg_170,
	input wire [QUAN_SIZE-1:0] ch_msg_171,
	input wire [QUAN_SIZE-1:0] ch_msg_172,
	input wire [QUAN_SIZE-1:0] ch_msg_173,
	input wire [QUAN_SIZE-1:0] ch_msg_174,
	input wire [QUAN_SIZE-1:0] ch_msg_175,
	input wire [QUAN_SIZE-1:0] ch_msg_176,
	input wire [QUAN_SIZE-1:0] ch_msg_177,
	input wire [QUAN_SIZE-1:0] ch_msg_178,
	input wire [QUAN_SIZE-1:0] ch_msg_179,
	input wire [QUAN_SIZE-1:0] ch_msg_180,
	input wire [QUAN_SIZE-1:0] ch_msg_181,
	input wire [QUAN_SIZE-1:0] ch_msg_182,
	input wire [QUAN_SIZE-1:0] ch_msg_183,
	input wire [QUAN_SIZE-1:0] ch_msg_184,
	input wire [QUAN_SIZE-1:0] ch_msg_185,
	input wire [QUAN_SIZE-1:0] ch_msg_186,
	input wire [QUAN_SIZE-1:0] ch_msg_187,
	input wire [QUAN_SIZE-1:0] ch_msg_188,
	input wire [QUAN_SIZE-1:0] ch_msg_189,
	input wire [QUAN_SIZE-1:0] ch_msg_190,
	input wire [QUAN_SIZE-1:0] ch_msg_191,
	input wire [QUAN_SIZE-1:0] ch_msg_192,
	input wire [QUAN_SIZE-1:0] ch_msg_193,
	input wire [QUAN_SIZE-1:0] ch_msg_194,
	input wire [QUAN_SIZE-1:0] ch_msg_195,
	input wire [QUAN_SIZE-1:0] ch_msg_196,
	input wire [QUAN_SIZE-1:0] ch_msg_197,
	input wire [QUAN_SIZE-1:0] ch_msg_198,
	input wire [QUAN_SIZE-1:0] ch_msg_199,
	input wire [QUAN_SIZE-1:0] ch_msg_200,
	input wire [QUAN_SIZE-1:0] ch_msg_201,
	input wire [QUAN_SIZE-1:0] ch_msg_202,
	input wire [QUAN_SIZE-1:0] ch_msg_203,
	
	input wire tready_slave,
	input wire block_cnt_full,
	input wire read_clk,
	input wire cn_write_clk,
	input wire vn_write_clk,
	input wire dn_write_clk,
	input wire rstn
);

// FSM steps for Sys.FSMs
localparam [3:0] INIT_LOAD     = 4'b0000;
localparam [3:0] LLR_FETCH     = 4'b0001;  
localparam [3:0] LLR_FETCH_OUT = 4'b0010;
localparam [3:0] CNU_PIPE      = 4'b0011;
localparam [3:0] CNU_OUT       = 4'b0100;
localparam [3:0] P2P_C         = 4'b0101;
localparam [3:0] P2P_C_OUT     = 4'b0110;
localparam [3:0] VNU_PIPE      = 4'b0111;
localparam [3:0] VNU_OUT       = 4'b1000;
localparam [3:0] P2P_V         = 4'b1001;
localparam [3:0] P2P_V_OUT     = 4'b1010;
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Memory System
// Memory System - Output
/*Check Node*/
wire [CN_RD_BW-1:0] cn_iter0_m0_portA_dout;
wire [CN_RD_BW-1:0] cn_iter0_m0_portB_dout;
wire [CN_RD_BW-1:0] cn_iter0_m1_portA_dout;
wire [CN_RD_BW-1:0] cn_iter0_m1_portB_dout;
wire [CN_RD_BW-1:0] cn_iter0_m2_portA_dout;
wire [CN_RD_BW-1:0] cn_iter0_m2_portB_dout;
wire [CN_RD_BW-1:0] cn_iter0_m3_portA_dout;
wire [CN_RD_BW-1:0] cn_iter0_m3_portB_dout;
wire [CN_RD_BW-1:0] cn_iter1_m0_portA_dout;
wire [CN_RD_BW-1:0] cn_iter1_m0_portB_dout;
wire [CN_RD_BW-1:0] cn_iter1_m1_portA_dout;
wire [CN_RD_BW-1:0] cn_iter1_m1_portB_dout;
wire [CN_RD_BW-1:0] cn_iter1_m2_portA_dout;
wire [CN_RD_BW-1:0] cn_iter1_m2_portB_dout;
wire [CN_RD_BW-1:0] cn_iter1_m3_portA_dout;
wire [CN_RD_BW-1:0] cn_iter1_m3_portB_dout;
/*Variable Node*/
wire [VN_RD_BW-1:0] vn_iter0_m0_portA_dout;
wire [VN_RD_BW-1:0] vn_iter0_m0_portB_dout;
wire [VN_RD_BW-1:0] vn_iter0_m1_portA_dout;
wire [VN_RD_BW-1:0] vn_iter0_m1_portB_dout;
wire [VN_RD_BW-1:0] vn_iter1_m0_portA_dout;
wire [VN_RD_BW-1:0] vn_iter1_m0_portB_dout;
wire [VN_RD_BW-1:0] vn_iter1_m1_portA_dout;
wire [VN_RD_BW-1:0] vn_iter1_m1_portB_dout;
/*Decision Node*/
wire [DN_RD_BW-1:0] dn_iter0_m2_portA_dout;
wire [DN_RD_BW-1:0] dn_iter0_m2_portB_dout;
wire [DN_RD_BW-1:0] dn_iter1_m2_portA_dout;
wire [DN_RD_BW-1:0] dn_iter1_m2_portB_dout;

// Memory System - Ouput of Mux
/*Check Node*/
wire [CN_RD_BW-1:0] cn_portA_dout [0:IB_CNU_DECOMP_funNum-1];
wire [CN_RD_BW-1:0] cn_portB_dout [0:IB_CNU_DECOMP_funNum-1];
/*Variable Node*/
wire [VN_RD_BW-1:0] vn_portA_dout [0:IB_VNU_DECOMP_funNum-1];
wire [VN_RD_BW-1:0] vn_portB_dout [0:IB_VNU_DECOMP_funNum-1];
/*Decision Node*/
wire [DN_RD_BW-1:0] dn_portA_dout;
wire [DN_RD_BW-1:0] dn_portB_dout;

// Memory Latch - Output
/*Check Node*/
wire [CN_ROM_RD_BW-1:0] cn_latch_outA [0:IB_CNU_DECOMP_funNum-1];
wire [CN_ROM_RD_BW-1:0] cn_latch_outB [0:IB_CNU_DECOMP_funNum-1];
wire [CN_ROM_ADDR_BW-1:0] cn_rom_read_addrA [0:IB_CNU_DECOMP_funNum-1];
wire [CN_ROM_ADDR_BW-1:0] cn_rom_read_addrB [0:IB_CNU_DECOMP_funNum-1];
/*Variable Node*/
wire [VN_ROM_RD_BW-1:0]   vn_latch_outA [0:IB_VNU_DECOMP_funNum-1];
wire [VN_ROM_RD_BW-1:0]   vn_latch_outB [0:IB_VNU_DECOMP_funNum-1];
wire [VN_ROM_ADDR_BW-1:0] vn_rom_read_addrA [0:IB_VNU_DECOMP_funNum-1];
wire [VN_ROM_ADDR_BW-1:0] vn_rom_read_addrB [0:IB_VNU_DECOMP_funNum-1];
/*Decision Node*/
wire [DN_ROM_RD_BW-1:0]   dn_latch_outA;
wire [DN_ROM_RD_BW-1:0]   dn_latch_outB;
wire [DN_ROM_ADDR_BW-1:0] dn_rom_read_addrA;
wire [DN_ROM_ADDR_BW-1:0] dn_rom_read_addrB;
// Memory Latch - Channel Message Latch (only latch the ch_msg from input at first clock cycle of SYS_FSM.state.LLR_FETCH)
reg [QUAN_SIZE-1:0] ch_msg_buffer [0:VN_NUM-1];

// IB-RAM Write Page Address Counter - Output
wire [CN_PAGE_ADDR_BW-1:0] cn_wr_page_addr [0:IB_CNU_DECOMP_funNum-1];
wire [VN_PAGE_ADDR_BW-1:0] vn_wr_page_addr [0:IB_VNU_DECOMP_funNum-1];
wire [DN_PAGE_ADDR_BW-1:0] dn_wr_page_addr;
//////////////////////////////////////////////////////////////////////////////////////////////////////
// FSM steps for Write.FSMs
localparam IDLE       = 3'b000;
localparam ROM_FETCH0 = 3'b001; // only for the first write or non-pipeline fashion
localparam RAM_LOAD0  = 3'b010;
localparam RAM_LOAD1  = 3'b011;
localparam FINISH     = 3'b100;

/*Obsoleted*/localparam iter_cnt_bitwidth = $clog2(MAX_ITER);
localparam INTER_FRAME_LEVEL = 2;
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Global Simulation Nets
wire [VN_NUM-1:0] hard_decision;
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Nets of Sys.FSMs
wire [INTER_FRAME_LEVEL-1:0] llr_fetch;
wire [INTER_FRAME_LEVEL-1:0] v2c_src;
wire [INTER_FRAME_LEVEL-1:0] v2c_msg_en;
wire [IB_CNU_DECOMP_funNum-1:0] cnu_rd [0:INTER_FRAME_LEVEL-1];
wire [INTER_FRAME_LEVEL-1:0] c2v_msg_en;
wire [IB_VNU_DECOMP_funNum-1:0] vnu_rd [0:INTER_FRAME_LEVEL-1];
wire dnu_rd [0:INTER_FRAME_LEVEL-1];
wire [INTER_FRAME_LEVEL-1:0] c2v_load;
wire [INTER_FRAME_LEVEL-1:0] v2c_load;
`ifdef AWGN_GEN_VERIFY
	assign v2c_load_debug = v2c_load[0];
`endif
wire [INTER_FRAME_LEVEL-1:0] de_frame_start;
wire [INTER_FRAME_LEVEL-1:0] inter_frame_en;
wire [3:0] sys_fsm_state [0:INTER_FRAME_LEVEL-1];
wire hard_decision_done;
reg [INTER_FRAME_LEVEL-1:0] fsm_en;
/*Obsoleted*///wire [`IB_CNU_DECOMP_funNum-1:0] fsm_cn_ram_re [0:INTER_FRAME_LEVEL-1];
/*Obsoleted*///wire [`IB_VNU_DECOMP_funNum-1:0] fsm_vn_ram_re [0:INTER_FRAME_LEVEL-1];
/*Obsoleted*///wire [INTER_FRAME_LEVEL-1:0] fsm_dn_ram_re;
wire [IB_CNU_DECOMP_funNum-1:0] cn_wr_iter_finish; // to notify the completion of iteration refresh 
wire [IB_VNU_DECOMP_funNum-1:0] vn_wr_iter_finish; // to notify the completion of iteration refresh 
wire dn_wr_iter_finish; // to notify the completion of iteration refresh 
wire [ITER_ADDR_BW-1:0] cnu_iter_cnt [0:IB_CNU_DECOMP_funNum-1];
wire [ITER_ADDR_BW-1:0] vnu_iter_cnt [0:IB_VNU_DECOMP_funNum-1];
wire [ITER_ADDR_BW-1:0] dnu_iter_cnt;

wire [IB_CNU_DECOMP_funNum-1:0] cn_iter_switch;
wire [IB_VNU_DECOMP_funNum-1:0] vn_iter_switch;
wire dn_iter_switch;

reg [INTER_FRAME_LEVEL-1:0] iter_termination;
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Nets for handshaking protocol between Sys.FSM and Write.FSM
// Input port for Write FSMs from Sys.FSMs
wire [IB_CNU_DECOMP_funNum-1:0] cnu_wr [0:INTER_FRAME_LEVEL-1];
wire [IB_VNU_DECOMP_funNum-1:0] vnu_wr [0:INTER_FRAME_LEVEL-1];
wire [INTER_FRAME_LEVEL-1:0] dnu_wr;
wire [ITER_ADDR_BW-1:0] cnu_iter;
// Output port from Write FSMs to Sys.FSMs
wire [IB_CNU_DECOMP_funNum-1:0] cn_iter_update [0:INTER_FRAME_LEVEL-1];
wire [IB_VNU_DECOMP_funNum-1:0] vn_iter_update [0:INTER_FRAME_LEVEL-1];
wire [INTER_FRAME_LEVEL-1:0] dn_iter_update;
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Nets of Write.FSMs

// CNU6 Update Iteration Control - Output
wire [IB_CNU_DECOMP_funNum-1:0] cn_ram_write_en;
wire cn_rom_port_fetch [0:IB_CNU_DECOMP_funNum-1]; // to enable the ib-map starting to fetch data from read port of IB ROM
wire cn_ram_mux_en [0:IB_CNU_DECOMP_funNum-1];
wire c6ib_rom_rst [0:IB_CNU_DECOMP_funNum-1];
wire [1:0] cn_write_busy [0:IB_CNU_DECOMP_funNum-1];
wire [2:0] cn_write_fsm_state [0:INTER_FRAME_LEVEL-1];
// VNU3 Update Iteration Control - Output
wire [IB_VNU_DECOMP_funNum-1:0] vn_ram_write_en;
wire vn_rom_port_fetch [0:IB_VNU_DECOMP_funNum-1]; // to enable the ib-map starting to fetch data from read port of IB ROM
wire vn_ram_mux_en [0:IB_VNU_DECOMP_funNum-1];
wire v3ib_rom_rst [0:IB_VNU_DECOMP_funNum-1];
wire [1:0] vn_write_busy [0:IB_VNU_DECOMP_funNum-1];
wire [2:0] vn_write_fsm_state [0:INTER_FRAME_LEVEL-1];
// DNU Update Iteration Control - Output
wire dn_ram_write_en;
wire dn_rom_port_fetch; // to enable the ib-map starting to fetch data from read port of IB ROM
wire dn_ram_mux_en;
wire d3ib_rom_rst;
wire [1:0] dn_write_busy;
wire [2:0] dn_write_fsm_state [0:INTER_FRAME_LEVEL-1];
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Nets of VNU and CNU extrinsic messages
/*Obsoleted*/reg [DATAPATH_WIDTH-1:0] c2v_parallel_in;
/*Obsoleted*/reg [DATAPATH_WIDTH-1:0] v2c_parallel_in;
/*Obsoleted*/wire [DATAPATH_WIDTH-1:0] c2v_parallel_out;
/*Obsoleted*/wire [DATAPATH_WIDTH-1:0] v2c_parallel_out;
/*Obsoleted*/wire extrinsic_route; // 1-bit message-passing route
reg c2v_msg_busy; 
reg v2c_msg_busy;
wire c2v_latch_en, v2c_latch_en; 
wire cnu_read_addr_offset; assign cnu_read_addr_offset = 1'b0; // for future expansion of mult-frame feature
wire vnu_read_addr_offset; assign vnu_read_addr_offset = 1'b0; // for future expansion of mult-frame feature
/*Obsoleted*/reg [DATAPATH_WIDTH-1:0] c2v_latch; // latch the extrinsic message right after PSP which will be fetch by CNU
/*Obsoleted*/reg [DATAPATH_WIDTH-1:0] v2c_latch; // latch the extrinsic message right after PSP which will be fetch by VNU 
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Instantiation of Sys.FSMs
sys_control_unit #(
    //.CNU_PIPELINE_LEVEL  (5-1), // the last pipeline register is actually shared with P2P_C
    //.VNU_PIPELINE_LEVEL  (3-1), // the last pipeline register is actually shared with P2P_V
	.RESET_CYCLE (100), // once rstn is deasserted, the system goes into reset mode for 100 clock cycles
	
	.CN_LOAD_CYCLE (CN_LOAD_CYCLE), // 64-entry with two interleaving banks requires 32 clock cycle to finish iteration update
	.VN_LOAD_CYCLE (VN_LOAD_CYCLE), // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
	.DN_LOAD_CYCLE (DN_LOAD_CYCLE), // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
	.MSG_PASS_CYCLE (QUAN_SIZE+1), // the message passing (v2c and c2v) via Parallel-to-Serial-Parallel converter takes 5 clock cycles
	
	.CNU_FUNC_CYCLE   (3), // the latency of one CNU 2-LUT function based on symmetrical design
	.VNU_FUNC_CYCLE   (3), // the latency of one VNU 2-LUT function based on symmetrical design
	.DNU_FUNC_CYCLE   (3), // the latency of one DNU 2-LUT function based on symmetrical design
	.CNU_FUNC_MEM_END (2), // the Memory Read ends at rising edge of 2nd clock (indexed from 0th cycle)
	.VNU_FUNC_MEM_END (2), // the Memory Read ends at rising edge of 2nd clock (indexed from 0th cycle)
	.DNU_FUNC_MEM_END (2), // the Memory Read ends at rising edge of 2nd clock (indexed from 0th cycle)
	.CNU_WR_HANDSHAKE_RESPONSE (2), // response time from assertion of pipe_load_start until rising edge of cnu_wr
	.VNU_WR_HANDSHAKE_RESPONSE (2), // response time from assertion of pipe_load_start until rising edge of vnu_wr
	.DNU_WR_HANDSHAKE_RESPONSE (2), // response time from assertion of pipe_load_start until rising edge of vnu_wr
	
	.CNU_PIPELINE_LEVEL (IB_CNU_DECOMP_funNum*CNU_FUNC_CYCLE), // the last pipeline register is actually shared with P2P_C
	.VNU_PIPELINE_LEVEL (IB_VNU_DECOMP_funNum*VNU_FUNC_CYCLE), // the last pipeline register is actually shared with P2P_V
	.DNU_PIPELINE_LEVEL (IB_DNU_DECOMP_funNum*DNU_FUNC_CYCLE), 
	.INIT_INTER_FRAME_EN (0),
      
	.INIT_LOAD     (4'b0000),
	.LLR_FETCH     (4'b0001),  
	.LLR_FETCH_OUT (4'b0010),
	.CNU_PIPE      (4'b0011),
	.CNU_OUT       (4'b0100),
	.P2P_C         (4'b0101),
	.P2P_C_OUT     (4'b0110),
	.VNU_PIPE      (4'b0111),
	.VNU_OUT       (4'b1000),
	.P2P_V         (4'b1001),
	.P2P_V_OUT     (4'b1010)
) frame_fsm_0 (
	// output port for IB-ROM update
	.cnu_wr (cnu_wr[0]),
	.vnu_wr (vnu_wr[0]),
	.dnu_wr (dnu_wr[0]),

    .llr_fetch  (llr_fetch[0]),
    .v2c_src    (v2c_src[0]),
    .v2c_msg_en (v2c_msg_en[0]),
    .cnu_rd     (cnu_rd[0]),
    .c2v_msg_en (c2v_msg_en[0]),
    .vnu_rd     (vnu_rd[0]),
	.dnu_rd		(dnu_rd[0]),
	.c2v_load	(c2v_load[0]), // load enable signal to parallel-to-serial converter
	.v2c_load	(v2c_load[0]), // load enable signal to parallel-to-serial converter
    .inter_frame_en (inter_frame_en[0]),
    .de_frame_start (de_frame_start[0]),
    /*obsoleted*///.cn_ram_re (fsm_cn_ram_re[0]),
    /*obsoleted*///.vn_ram_re (fsm_vn_ram_re[0]),
	/*obsoleted*///.dn_ram_re (fsm_dn_ram_re[0]),
    .state (sys_fsm_state[0]),
	.hard_decision_done (hard_decision_done), // // State Signal - hard decision is going to be done one clock cycle later
	
/*
	// Since the assertion/deassertion of any wr_iter_finish signal has to be synchronised with write clock
	// instead of read clock, the following output net is obsoleted
	.cn_wr_iter_finish (cn_wr_iter_finish[IB_CNU_DECOMP_funNum-1:0]), // to notify the completion of iteration refresh
	.vn_wr_iter_finish (vn_wr_iter_finish[IB_VNU_DECOMP_funNum-1:0]), // to notify the completion of iteration refresh
	.dn_wr_iter_finish (dn_wr_iter_finish), // to notify the completion of iteration refresh
*/
	// Input port acknowledging from Write/Update FSMs
	.cn_iter_update (cn_iter_update[0]),
	.vn_iter_update (vn_iter_update[0]),
	.dn_iter_update (dn_iter_update[0]),
	
    .termination (iter_termination[0]),
    .inter_frame_align (/*iter_termination[1]*/1'b0),
    .read_clk (read_clk),
    .fsm_en (fsm_en[0]), // enable this FSM only when IB-CNU and VNU RAMs stop write operation
    .rstn (rstn)
);
//and and0(fsm_en[0], rstn, inter_frame_en[1]);

//(* max_fanout = 17 *) reg hard_decision_done_reg;
reg hard_decision_done_reg;
always @(posedge read_clk) begin if(!rstn) hard_decision_done_reg <= 0; else hard_decision_done_reg <= hard_decision_done; end

wire decoder_busy;
reg [1:0] next_codeword;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) fsm_en[0] <= 1'b0;
	else if (block_cnt_full == 1'b1) fsm_en[0] <= 1'b1; // to activate in the first time only
	else fsm_en[0] <= ~next_codeword[0];
end
assign decoder_busy = inter_frame_en[0];
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) next_codeword <= 0;
	else next_codeword[1:0] <= {next_codeword[0], iter_termination[0]};
end
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Instantiation of Memory System
// Channel Message Buffer
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[0  ] <= ch_msg_0  [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[1  ] <= ch_msg_1  [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[2  ] <= ch_msg_2  [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[3  ] <= ch_msg_3  [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[4  ] <= ch_msg_4  [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[5  ] <= ch_msg_5  [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[6  ] <= ch_msg_6  [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[7  ] <= ch_msg_7  [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[8  ] <= ch_msg_8  [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[9  ] <= ch_msg_9  [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[10 ] <= ch_msg_10 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[11 ] <= ch_msg_11 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[12 ] <= ch_msg_12 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[13 ] <= ch_msg_13 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[14 ] <= ch_msg_14 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[15 ] <= ch_msg_15 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[16 ] <= ch_msg_16 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[17 ] <= ch_msg_17 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[18 ] <= ch_msg_18 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[19 ] <= ch_msg_19 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[20 ] <= ch_msg_20 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[21 ] <= ch_msg_21 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[22 ] <= ch_msg_22 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[23 ] <= ch_msg_23 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[24 ] <= ch_msg_24 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[25 ] <= ch_msg_25 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[26 ] <= ch_msg_26 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[27 ] <= ch_msg_27 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[28 ] <= ch_msg_28 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[29 ] <= ch_msg_29 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[30 ] <= ch_msg_30 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[31 ] <= ch_msg_31 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[32 ] <= ch_msg_32 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[33 ] <= ch_msg_33 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[34 ] <= ch_msg_34 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[35 ] <= ch_msg_35 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[36 ] <= ch_msg_36 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[37 ] <= ch_msg_37 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[38 ] <= ch_msg_38 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[39 ] <= ch_msg_39 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[40 ] <= ch_msg_40 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[41 ] <= ch_msg_41 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[42 ] <= ch_msg_42 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[43 ] <= ch_msg_43 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[44 ] <= ch_msg_44 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[45 ] <= ch_msg_45 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[46 ] <= ch_msg_46 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[47 ] <= ch_msg_47 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[48 ] <= ch_msg_48 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[49 ] <= ch_msg_49 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[50 ] <= ch_msg_50 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[52 ] <= ch_msg_52 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[53 ] <= ch_msg_53 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[54 ] <= ch_msg_54 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[51 ] <= ch_msg_51 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[55 ] <= ch_msg_55 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[56 ] <= ch_msg_56 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[57 ] <= ch_msg_57 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[58 ] <= ch_msg_58 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[59 ] <= ch_msg_59 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[60 ] <= ch_msg_60 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[61 ] <= ch_msg_61 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[62 ] <= ch_msg_62 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[63 ] <= ch_msg_63 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[64 ] <= ch_msg_64 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[65 ] <= ch_msg_65 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[66 ] <= ch_msg_66 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[67 ] <= ch_msg_67 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[68 ] <= ch_msg_68 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[69 ] <= ch_msg_69 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[70 ] <= ch_msg_70 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[71 ] <= ch_msg_71 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[72 ] <= ch_msg_72 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[73 ] <= ch_msg_73 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[74 ] <= ch_msg_74 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[75 ] <= ch_msg_75 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[76 ] <= ch_msg_76 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[77 ] <= ch_msg_77 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[78 ] <= ch_msg_78 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[79 ] <= ch_msg_79 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[80 ] <= ch_msg_80 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[81 ] <= ch_msg_81 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[82 ] <= ch_msg_82 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[83 ] <= ch_msg_83 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[84 ] <= ch_msg_84 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[85 ] <= ch_msg_85 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[86 ] <= ch_msg_86 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[87 ] <= ch_msg_87 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[88 ] <= ch_msg_88 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[89 ] <= ch_msg_89 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[90 ] <= ch_msg_90 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[91 ] <= ch_msg_91 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[92 ] <= ch_msg_92 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[93 ] <= ch_msg_93 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[94 ] <= ch_msg_94 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[95 ] <= ch_msg_95 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[96 ] <= ch_msg_96 [QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[97 ] <= ch_msg_97 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[98 ] <= ch_msg_98 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[99 ] <= ch_msg_99 [QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[100] <= ch_msg_100[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[101] <= ch_msg_101[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[102] <= ch_msg_102[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[103] <= ch_msg_103[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[104] <= ch_msg_104[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[105] <= ch_msg_105[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[106] <= ch_msg_106[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[107] <= ch_msg_107[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[108] <= ch_msg_108[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[109] <= ch_msg_109[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[110] <= ch_msg_110[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[111] <= ch_msg_111[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[112] <= ch_msg_112[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[113] <= ch_msg_113[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[114] <= ch_msg_114[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[115] <= ch_msg_115[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[116] <= ch_msg_116[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[117] <= ch_msg_117[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[118] <= ch_msg_118[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[119] <= ch_msg_119[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[120] <= ch_msg_120[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[121] <= ch_msg_121[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[122] <= ch_msg_122[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[123] <= ch_msg_123[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[124] <= ch_msg_124[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[125] <= ch_msg_125[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[126] <= ch_msg_126[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[127] <= ch_msg_127[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[128] <= ch_msg_128[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[129] <= ch_msg_129[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[130] <= ch_msg_130[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[131] <= ch_msg_131[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[132] <= ch_msg_132[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[133] <= ch_msg_133[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[134] <= ch_msg_134[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[135] <= ch_msg_135[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[136] <= ch_msg_136[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[137] <= ch_msg_137[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[138] <= ch_msg_138[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[139] <= ch_msg_139[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[140] <= ch_msg_140[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[141] <= ch_msg_141[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[142] <= ch_msg_142[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[143] <= ch_msg_143[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[144] <= ch_msg_144[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[145] <= ch_msg_145[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[146] <= ch_msg_146[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[147] <= ch_msg_147[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[148] <= ch_msg_148[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[149] <= ch_msg_149[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[150] <= ch_msg_150[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[151] <= ch_msg_151[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[152] <= ch_msg_152[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[153] <= ch_msg_153[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[154] <= ch_msg_154[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[155] <= ch_msg_155[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[156] <= ch_msg_156[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[157] <= ch_msg_157[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[158] <= ch_msg_158[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[159] <= ch_msg_159[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[160] <= ch_msg_160[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[161] <= ch_msg_161[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[162] <= ch_msg_162[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[163] <= ch_msg_163[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[164] <= ch_msg_164[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[165] <= ch_msg_165[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[166] <= ch_msg_166[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[167] <= ch_msg_167[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[168] <= ch_msg_168[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[169] <= ch_msg_169[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[170] <= ch_msg_170[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[171] <= ch_msg_171[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[172] <= ch_msg_172[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[173] <= ch_msg_173[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[174] <= ch_msg_174[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[175] <= ch_msg_175[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[176] <= ch_msg_176[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[177] <= ch_msg_177[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[178] <= ch_msg_178[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[179] <= ch_msg_179[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[180] <= ch_msg_180[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[181] <= ch_msg_181[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[182] <= ch_msg_182[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[183] <= ch_msg_183[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[184] <= ch_msg_184[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[185] <= ch_msg_185[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[186] <= ch_msg_186[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[187] <= ch_msg_187[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[188] <= ch_msg_188[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[189] <= ch_msg_189[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[190] <= ch_msg_190[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[191] <= ch_msg_191[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[192] <= ch_msg_192[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[193] <= ch_msg_193[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[194] <= ch_msg_194[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[195] <= ch_msg_195[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[196] <= ch_msg_196[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[197] <= ch_msg_197[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[198] <= ch_msg_198[QUAN_SIZE-1:0];
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[199] <= ch_msg_199[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[200] <= ch_msg_200[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[201] <= ch_msg_201[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[202] <= ch_msg_202[QUAN_SIZE-1:0]; 
always @(posedge read_clk) if(llr_fetch[0] == 1) ch_msg_buffer[203] <= ch_msg_203[QUAN_SIZE-1:0]; 
// IB-ROM
mem_sys #(
	.CN_RD_BW   (`CN_RD_BW  ),
	.VN_RD_BW   (`VN_RD_BW  ),
	.DN_RD_BW   (`DN_RD_BW  ),
	.CN_ADDR_BW (`CN_ADDR_BW),
	.VN_ADDR_BW (`VN_ADDR_BW),
	.DN_ADDR_BW (`DN_ADDR_BW)
) mem_u0(
	// Memory System - Ouput
	.cn_iter0_m0_portA_dout(cn_iter0_m0_portA_dout[CN_RD_BW-1:0]),
	.cn_iter0_m0_portB_dout(cn_iter0_m0_portB_dout[CN_RD_BW-1:0]),
	.cn_iter0_m1_portA_dout(cn_iter0_m1_portA_dout[CN_RD_BW-1:0]),
	.cn_iter0_m1_portB_dout(cn_iter0_m1_portB_dout[CN_RD_BW-1:0]),
	.cn_iter0_m2_portA_dout(cn_iter0_m2_portA_dout[CN_RD_BW-1:0]),
	.cn_iter0_m2_portB_dout(cn_iter0_m2_portB_dout[CN_RD_BW-1:0]),
	.cn_iter0_m3_portA_dout(cn_iter0_m3_portA_dout[CN_RD_BW-1:0]),
	.cn_iter0_m3_portB_dout(cn_iter0_m3_portB_dout[CN_RD_BW-1:0]),
	.cn_iter1_m0_portA_dout(cn_iter1_m0_portA_dout[CN_RD_BW-1:0]),
	.cn_iter1_m0_portB_dout(cn_iter1_m0_portB_dout[CN_RD_BW-1:0]),
	.cn_iter1_m1_portA_dout(cn_iter1_m1_portA_dout[CN_RD_BW-1:0]),
	.cn_iter1_m1_portB_dout(cn_iter1_m1_portB_dout[CN_RD_BW-1:0]),
	.cn_iter1_m2_portA_dout(cn_iter1_m2_portA_dout[CN_RD_BW-1:0]),
	.cn_iter1_m2_portB_dout(cn_iter1_m2_portB_dout[CN_RD_BW-1:0]),
	.cn_iter1_m3_portA_dout(cn_iter1_m3_portA_dout[CN_RD_BW-1:0]),
	.cn_iter1_m3_portB_dout(cn_iter1_m3_portB_dout[CN_RD_BW-1:0]),
	
	.vn_iter0_m0_portA_dout (vn_iter0_m0_portA_dout[VN_RD_BW-1:0]),
	.vn_iter0_m0_portB_dout (vn_iter0_m0_portB_dout[VN_RD_BW-1:0]),
	.vn_iter0_m1_portA_dout (vn_iter0_m1_portA_dout[VN_RD_BW-1:0]),
	.vn_iter0_m1_portB_dout (vn_iter0_m1_portB_dout[VN_RD_BW-1:0]),
	.vn_iter1_m0_portA_dout (vn_iter1_m0_portA_dout[VN_RD_BW-1:0]),
	.vn_iter1_m0_portB_dout (vn_iter1_m0_portB_dout[VN_RD_BW-1:0]),
	.vn_iter1_m1_portA_dout (vn_iter1_m1_portA_dout[VN_RD_BW-1:0]),
	.vn_iter1_m1_portB_dout (vn_iter1_m1_portB_dout[VN_RD_BW-1:0]),
	.dn_iter0_portA_dout (dn_iter0_m2_portA_dout[DN_RD_BW-1:0]),
	.dn_iter0_portB_dout (dn_iter0_m2_portB_dout[DN_RD_BW-1:0]),
	.dn_iter1_portA_dout (dn_iter1_m2_portA_dout[DN_RD_BW-1:0]),
	.dn_iter1_portB_dout (dn_iter1_m2_portB_dout[DN_RD_BW-1:0]),	
	
	// Memory System - Input
	.cn_iter0_m0_portA_addr (cn_rom_read_addrA[0]),
	.cn_iter0_m0_portB_addr (cn_rom_read_addrB[0]),
	.cn_iter0_m1_portA_addr (cn_rom_read_addrA[1]),
	.cn_iter0_m1_portB_addr (cn_rom_read_addrB[1]),
	.cn_iter0_m2_portA_addr (cn_rom_read_addrA[2]),
	.cn_iter0_m2_portB_addr (cn_rom_read_addrB[2]),
	.cn_iter0_m3_portA_addr (cn_rom_read_addrA[3]),
	.cn_iter0_m3_portB_addr (cn_rom_read_addrB[3]),
	.cn_iter1_m0_portA_addr (cn_rom_read_addrA[0]),
	.cn_iter1_m0_portB_addr (cn_rom_read_addrB[0]),
	.cn_iter1_m1_portA_addr (cn_rom_read_addrA[1]),
	.cn_iter1_m1_portB_addr (cn_rom_read_addrB[1]),
	.cn_iter1_m2_portA_addr (cn_rom_read_addrA[2]),
	.cn_iter1_m2_portB_addr (cn_rom_read_addrB[2]),
	.cn_iter1_m3_portA_addr (cn_rom_read_addrA[3]),
	.cn_iter1_m3_portB_addr (cn_rom_read_addrB[3]),
	
	.vn_iter0_m0_portA_addr (vn_rom_read_addrA[0]),
	.vn_iter0_m0_portB_addr (vn_rom_read_addrB[0]),
	.vn_iter0_m1_portA_addr (vn_rom_read_addrA[1]),
	.vn_iter0_m1_portB_addr (vn_rom_read_addrB[1]),
	.vn_iter1_m0_portA_addr (vn_rom_read_addrA[0]),
	.vn_iter1_m0_portB_addr (vn_rom_read_addrB[0]),
	.vn_iter1_m1_portA_addr (vn_rom_read_addrA[1]),
	.vn_iter1_m1_portB_addr (vn_rom_read_addrB[1]),	
	.dn_iter0_portA_addr (dn_rom_read_addrA[DN_ROM_ADDR_BW-1:0]),
	.dn_iter0_portB_addr (dn_rom_read_addrB[DN_ROM_ADDR_BW-1:0]),
	.dn_iter1_portA_addr (dn_rom_read_addrA[DN_ROM_ADDR_BW-1:0]),
	.dn_iter1_portB_addr (dn_rom_read_addrB[DN_ROM_ADDR_BW-1:0]),
	.cn_write_clk (cn_write_clk),
	.vn_write_clk (vn_write_clk),
	.dn_write_clk (dn_write_clk)
);
// Instantiation of Multiplexers, where the final refresh data is from either Group_Iter0 or Grroup_Iter1 of IB-ROMs
// Note that LUT dataset from iteration 0 to 24 is stored in Group_Iter0 of IB-ROMs
// Note that LUT dataset from iteration 25 to 49 is stored in Group_Iter1 of IB-ROMs
c6rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) c6rom_iter_mux_mA0(
	.dout (cn_portA_dout[0]),
	.iter0_din (cn_iter0_m0_portA_dout),
	.iter1_din (cn_iter1_m0_portA_dout),
	.iter_switch (cn_iter_switch[0])
);
c6rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) c6rom_iter_mux_mA1(
	.dout (cn_portA_dout[1]),
	.iter0_din  (cn_iter0_m1_portA_dout),
	.iter1_din  (cn_iter1_m1_portA_dout),
	.iter_switch (cn_iter_switch[1]) 
);
c6rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) c6rom_iter_mux_mA2(
	.dout (cn_portA_dout[2]),
	.iter0_din  (cn_iter0_m2_portA_dout),
	.iter1_din  (cn_iter1_m2_portA_dout),
	.iter_switch (cn_iter_switch[2]) 
);
c6rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) c6rom_iter_mux_mA3(
	.dout (cn_portA_dout[3]),
	.iter0_din  (cn_iter0_m3_portA_dout),
	.iter1_din  (cn_iter1_m3_portA_dout),
	.iter_switch (cn_iter_switch[3]) 
);
c6rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) c6rom_iter_mux_mB0(
	.dout (cn_portB_dout[0]),
	.iter0_din (cn_iter0_m0_portB_dout),
	.iter1_din (cn_iter1_m0_portB_dout),
	.iter_switch (cn_iter_switch[0])
);
c6rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) c6rom_iter_mux_mB1(
	.dout (cn_portB_dout[1]),
	.iter0_din  (cn_iter0_m1_portB_dout),
	.iter1_din  (cn_iter1_m1_portB_dout),
	.iter_switch (cn_iter_switch[1]) 
);
c6rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) c6rom_iter_mux_mB2(
	.dout (cn_portB_dout[2]),
	.iter0_din  (cn_iter0_m2_portB_dout),
	.iter1_din  (cn_iter1_m2_portB_dout),
	.iter_switch (cn_iter_switch[2]) 
);
c6rom_iter_mux #(.ROM_RD_BW(CN_RD_BW)) c6rom_iter_mux_mB3(
	.dout (cn_portB_dout[3]),
	.iter0_din  (cn_iter0_m3_portB_dout),
	.iter1_din  (cn_iter1_m3_portB_dout),
	.iter_switch (cn_iter_switch[3]) 
);

v3rom_iter_mux #(.ROM_RD_BW(VN_RD_BW)) v3rom_iter_mux_mA0(
	.dout        (vn_portA_dout[0]),
	.iter0_din   (vn_iter0_m0_portA_dout),
	.iter1_din   (vn_iter1_m0_portA_dout),
	.iter_switch (vn_iter_switch[0])
);
v3rom_iter_mux #(.ROM_RD_BW(VN_RD_BW)) v3rom_iter_mux_mA1(
	.dout        (vn_portA_dout[1]),
	.iter0_din   (vn_iter0_m1_portA_dout),
	.iter1_din   (vn_iter1_m1_portA_dout),
	.iter_switch (vn_iter_switch[1]) 
);
d3rom_iter_mux #(.ROM_RD_BW(DN_RD_BW)) d3rom_iter_mux_mA2(
	.dout        (dn_portA_dout[DN_RD_BW-1:0]),
	.iter0_din   (dn_iter0_m2_portA_dout[DN_RD_BW-1:0]),
	.iter1_din   (dn_iter1_m2_portA_dout[DN_RD_BW-1:0]),
	.iter_switch (dn_iter_switch) 
);
v3rom_iter_mux #(.ROM_RD_BW(VN_RD_BW)) v3rom_iter_mux_mB0(
	.dout        (vn_portB_dout[0]),
	.iter0_din   (vn_iter0_m0_portB_dout),
	.iter1_din   (vn_iter1_m0_portB_dout),
	.iter_switch (vn_iter_switch[0])
);
v3rom_iter_mux #(.ROM_RD_BW(VN_RD_BW)) v3rom_iter_mux_mB1(
	.dout        (vn_portB_dout[1]),
	.iter0_din   (vn_iter0_m1_portB_dout),
	.iter1_din   (vn_iter1_m1_portB_dout),
	.iter_switch (vn_iter_switch[1]) 
);
d3rom_iter_mux #(.ROM_RD_BW(DN_RD_BW)) d3rom_iter_mux_mB2(
	.dout        (dn_portB_dout[DN_RD_BW-1:0]),
	.iter0_din   (dn_iter0_m2_portB_dout[DN_RD_BW-1:0]),
	.iter1_din   (dn_iter1_m2_portB_dout[DN_RD_BW-1:0]),
	.iter_switch (dn_iter_switch) 
);
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Instantiation of Write.FSMs (for simulation only)
generate
		genvar i, j;
		// For CNUs
		for(i=0;i<IB_CNU_DECOMP_funNum;i=i+1) begin : cn_wr_fsm_inst		
			cnu6_wr_fsm #(.LOAD_CYCLE(CN_LOAD_CYCLE)) cnu6_wr_fsm_u0 (
				// FSM - Output
				.rom_port_fetch (cn_rom_port_fetch[i]), // to enable the ib-map starting to fetch data from read port of IB ROM
				.ram_write_en   (cn_ram_write_en[i]),
				.ram_mux_en     (cn_ram_mux_en[i]),
				.iter_update    (cn_iter_update[0][i]),
				.c6ib_rom_rst   (c6ib_rom_rst[i]),
				.busy           (cn_write_busy[i]),
				//.state          (cn_write_fsm_state[0]),
				
				// FSM - Input
				.write_clk (cn_write_clk),
				.rstn (/*rstn*/fsm_en[0]),
				.iter_rqst (cnu_wr[0][i]),
				.iter_termination (iter_termination[0])
				//.pipeline_en (pipeline_en[i])	// deprecated
			);
			
			cn_iter_counter #(
				.ITER_ADDR_BW (ITER_ADDR_BW),  // bit-width of addressing 50 iterationss
				.MAX_ITER (MAX_ITER)
			) cn_iter_counter_m03(
				.iter_cnt (cnu_iter_cnt[i]),
				
				.wr_iter_finish (cn_wr_iter_finish[i]),
				.write_clk (cn_write_clk),
				.rstn (/*rstn*/fsm_en[0])
			);
		
			c6rom_iter_selector #(
				.ITER_ROM_GROUP (ITER_ROM_GROUP), // the number of iteration datasets stored in one Group of IB-ROMs
				.ITER_ADDR_BW (ITER_ADDR_BW)// bit-width of addressing 50 iterationss
			) cn_rom_iter_selector_m03(
				.iter_switch (cn_iter_switch[i]),
				.iter_cnt (cnu_iter_cnt[i]),
				.write_clk (cn_write_clk),
				.rstn (fsm_en[0])
			);

			reg [CN_ROM_ADDR_BW-1:0] cn_iter_cnt_temp;
			initial cn_iter_cnt_temp[CN_ROM_ADDR_BW-1:0] <= 0;
			always @(posedge cn_write_clk, negedge fsm_en[0]) begin
				if(fsm_en[0] == 1'b0) cn_iter_cnt_temp[CN_ROM_ADDR_BW-1:0] <= 0;
				else if(cn_wr_page_addr[i] == (CN_LOAD_CYCLE-1)  && cnu_iter_cnt[i] == ITER_ROM_GROUP-1) cn_iter_cnt_temp[CN_ROM_ADDR_BW-1:0] <= 1'b0; 
				else if(cn_ram_write_en[i] == 1'b1) cn_iter_cnt_temp[CN_ROM_ADDR_BW-1:0] <= cn_rom_read_addrA[i]-CN_OVERPROVISION;
				else cn_iter_cnt_temp[CN_ROM_ADDR_BW-1:0] <= cn_iter_cnt_temp[CN_ROM_ADDR_BW-1:0];
			end	
			cn_mem_latch #(
				.ROM_RD_BW    (CN_ROM_RD_BW), 
				.ROM_ADDR_BW  (CN_ROM_ADDR_BW), 	
				.CN_LOAD_CYCLE (CN_LOAD_CYCLE),
				.ITER_ROM_GROUP (ITER_ROM_GROUP),
				.CN_OVERPROVISION (CN_OVERPROVISION),		
				.PAGE_ADDR_BW (CN_PAGE_ADDR_BW), 								
				.ITER_ADDR_BW (CN_ITER_ADDR_BW)
			) cn_mem_latch_m03(
				// Memory Latch - Output	
				.latch_outA (cn_latch_outA[i]),
				.latch_outB (cn_latch_outB[i]),
				.rom_read_addrA (cn_rom_read_addrA[i]),
				.rom_read_addrB (cn_rom_read_addrB[i]),
				// Memory Latch - Input 
				.latch_inA (cn_portA_dout[i]),
				.latch_inB (cn_portB_dout[i]),
				.latch_iterA (cn_iter_cnt_temp[CN_ROM_ADDR_BW-1:0]), // base address for latch A to indicate the iteration index
				.latch_iterB (cn_iter_cnt_temp[CN_ROM_ADDR_BW-1:0]), // base address for latch B to indicate the iteration index
				.rstn (cn_rom_port_fetch[i]), // asserted/deasserted by "rom_port_fetch" signal of Iteration Update Control Unit
				.write_clk (cn_write_clk)
			);
			
			cn_Waddr_counter #(
				.PAGE_ADDR_BW (CN_PAGE_ADDR_BW),
				.CN_LOAD_CYCLE (CN_LOAD_CYCLE)
			) cn_page_addr_cntM03 (
				.wr_page_addr (cn_wr_page_addr[i]),
				.wr_iter_finish (cn_wr_iter_finish[i]),
				
				.en (cn_ram_write_en[i]),
				.write_clk (cn_write_clk),
				.rstn (~c6ib_rom_rst[i])
			);
		end
		/*----------------------------------------------------------*/
		// For VNUs
		for(j=0;j<IB_VNU_DECOMP_funNum;j=j+1) begin : vn_wr_fsm_inst
			vnu3_wr_fsm #(.LOAD_CYCLE(VN_LOAD_CYCLE)) vnu3_wr_fsm_u0 (
				// FSM - Output
				.rom_port_fetch (vn_rom_port_fetch[j]), // to enable the ib-map starting to fetch data from read port of IB ROM
				.ram_write_en   (vn_ram_write_en[j]),
				.ram_mux_en     (vn_ram_mux_en[j]),
				.iter_update    (vn_iter_update[0][j]),
				.v3ib_rom_rst   (v3ib_rom_rst[j]),
				.busy           (vn_write_busy[j]),
				//.state (vn_write_fsm_state[0]),
				
				// FSM - Input
				.write_clk (vn_write_clk),
				.rstn (/*rstn*/fsm_en[0]),
				.iter_rqst (vnu_wr[0][j]),
				.iter_termination (iter_termination[0])
				//.pipeline_en (pipeline_en[j])	// deprecated
			);
			
			vn_iter_counter #(
				.ITER_ADDR_BW (ITER_ADDR_BW),  // bit-width of addressing 50 iterationss
				.MAX_ITER (MAX_ITER)
			) vn_iter_counter_m01(
				.iter_cnt (vnu_iter_cnt[j]),
				
				.wr_iter_finish (vn_wr_iter_finish[j]),
				.write_clk (vn_write_clk),
				.rstn (fsm_en[0])
			);
					
			v3rom_iter_selector #(
				.ITER_ROM_GROUP (ITER_ROM_GROUP), // the number of iteration datasets stored in one Group of IB-ROMs
				.ITER_ADDR_BW (ITER_ADDR_BW)// bit-width of addressing 50 iterationss
			) vn_rom_iter_selector_m01(
				.iter_switch (vn_iter_switch[j]),
				.iter_cnt (vnu_iter_cnt[j]),
				.write_clk (vn_write_clk),
				.rstn (fsm_en[0])
			);			
			
			reg [VN_ROM_ADDR_BW-1:0] vn_iter_cnt_temp;
			initial vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0] <= 0;
			always @(posedge vn_write_clk, negedge fsm_en[0]) begin
				if(fsm_en[0] == 1'b0) vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0] <= 0;
				else if(vn_wr_page_addr[j] == (VN_LOAD_CYCLE-1)  && vnu_iter_cnt[j] == ITER_ROM_GROUP-1) vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0] <= 1'b0; 
				else if(vn_ram_write_en[j] == 1'b1) vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0] <= vn_rom_read_addrA[j]-VN_OVERPROVISION;
				else vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0] <= vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0];
			end		
/*
			always @(negedge vn_ram_write_en[j], negedge fsm_en[0]) begin
				if(fsm_en[0] == 1'b0) vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0] <= 0;
				else if(vn_iter_switch[j] == 1'b1 && vnu_iter_cnt[j] == ITER_ROM_GROUP-1) vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0] <= 1'b0; 
				else vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0] <= vn_rom_read_addrA[j]-VN_OVERPROVISION;
			end	
*/
			vn_mem_latch #(
				.ROM_RD_BW    (VN_ROM_RD_BW), 
				.ROM_ADDR_BW  (VN_ROM_ADDR_BW),
				.VN_LOAD_CYCLE (VN_LOAD_CYCLE),
				.ITER_ROM_GROUP (ITER_ROM_GROUP),
				.VN_OVERPROVISION (VN_OVERPROVISION),					
				.PAGE_ADDR_BW (VN_PAGE_ADDR_BW), 								
				.ITER_ADDR_BW (VN_ITER_ADDR_BW)
			) vn_mem_latch_m01(
				// Memory Latch - Output	
				.latch_outA (vn_latch_outA[j]),
				.latch_outB (vn_latch_outB[j]),
				.rom_read_addrA (vn_rom_read_addrA[j]),
				.rom_read_addrB (vn_rom_read_addrB[j]),
				// Memory Latch - Input 
				.latch_inA (vn_portA_dout[j]),
				.latch_inB (vn_portB_dout[j]),
				.latch_iterA (vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0]), // base address for latch A to indicate the iteration index
				.latch_iterB (vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0]), // base address for latch B to indicate the iteration index
				.rstn (vn_rom_port_fetch[j]), // asserted/deasserted by "rom_port_fetch" signal of Iteration Update Control Unit
				.write_clk (vn_write_clk)
			);

			vn_Waddr_counter #(
				.PAGE_ADDR_BW (VN_PAGE_ADDR_BW),
				.VN_LOAD_CYCLE (VN_LOAD_CYCLE)
			) vn_page_addr_vntM01 (
				.wr_page_addr (vn_wr_page_addr[j]),
				.wr_iter_finish (vn_wr_iter_finish[j]),
				
				.en (vn_ram_write_en[j]),
				.write_clk (vn_write_clk),
				.rstn (~v3ib_rom_rst[j])
			);
		end
endgenerate
dnu3_wr_fsm #(.LOAD_CYCLE(DN_LOAD_CYCLE)) dnu3_wr_fsm_u0 (
	// FSM - Output
	.rom_port_fetch (dn_rom_port_fetch), // to enable the ib-map starting to fetch data from read port of IB ROM
	.ram_write_en   (dn_ram_write_en),
	.ram_mux_en     (dn_ram_mux_en),
	.iter_update    (dn_iter_update[0]),
	.v3ib_rom_rst   (d3ib_rom_rst),
	.busy           (dn_write_busy),
	//.state          (dn_write_fsm_state[0]),
	// FSM - Input
	.write_clk        (dn_write_clk),
	.rstn             (/*rstn*/fsm_en[0]),
	.iter_rqst        (dnu_wr[0]),
	.iter_termination (iter_termination[0])
	//.pipeline_en    (vn_pipeline_en[i])	// deprecated
);

dn_iter_counter #(
	.ITER_ADDR_BW (ITER_ADDR_BW),  // bit-width of addressing 50 iterationss
	.MAX_ITER (MAX_ITER)
) dn_iter_counter_m2(
	.iter_cnt (dnu_iter_cnt),
	
	.wr_iter_finish (dn_wr_iter_finish),
	.write_clk (dn_write_clk),
	.rstn (/*rstn*/fsm_en[0])
);

d3rom_iter_selector #(
	.ITER_ROM_GROUP (ITER_ROM_GROUP), // the number of iteration datasets stored in one Group of IB-ROMs
	.ITER_ADDR_BW (ITER_ADDR_BW)// bit-width of addressing 50 iterationss
) dn_rom_iter_selector_m2(
	.iter_switch (dn_iter_switch),
	.iter_cnt (dnu_iter_cnt),
	.write_clk (dn_write_clk),
	.rstn (fsm_en[0])
);

reg [DN_ROM_ADDR_BW-1:0] dn_iter_cnt_temp;
initial dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0] <= 0;
always @(posedge dn_write_clk, negedge fsm_en[0]) begin
	if(fsm_en[0] == 1'b0) dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0] <= 0;
	else if(dn_wr_page_addr == (DN_LOAD_CYCLE-1)  && dnu_iter_cnt == ITER_ROM_GROUP-1) dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0] <= 1'b0; 
	else if(dn_ram_write_en == 1'b1) dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0] <= dn_rom_read_addrA-DN_OVERPROVISION;
	else dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0] <= dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0];
end		

/*
always @(negedge dn_ram_write_en, negedge fsm_en[0]) begin
	if(fsm_en[0] == 1'b0) dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0] <= 0;
	else if(dn_iter_switch == 1'b1 && dnu_iter_cnt == ITER_ROM_GROUP-1) dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0] <= 1'b0; 
	else dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0] <= dn_rom_read_addrA-DN_OVERPROVISION;
end	
*/
dn_mem_latch #(
	.ROM_RD_BW    (DN_ROM_RD_BW), 
	.ROM_ADDR_BW  (DN_ROM_ADDR_BW), 
	.DN_LOAD_CYCLE (DN_LOAD_CYCLE),
	.ITER_ROM_GROUP (ITER_ROM_GROUP),
	.DN_OVERPROVISION (DN_OVERPROVISION),		
	.PAGE_ADDR_BW (DN_PAGE_ADDR_BW), 								
	.ITER_ADDR_BW (DN_ITER_ADDR_BW)
) dn_mem_latch_m2(
	// Memory Latch - Output	
	.latch_outA (dn_latch_outA[DN_ROM_RD_BW-1:0]),
	.latch_outB (dn_latch_outB[DN_ROM_RD_BW-1:0]),
	.rom_read_addrA (dn_rom_read_addrA[DN_ROM_ADDR_BW-1:0]),
	.rom_read_addrB (dn_rom_read_addrB[DN_ROM_ADDR_BW-1:0]),
	// Memory Latch - Input 
	.latch_inA (dn_portA_dout[DN_RD_BW-1:0]),
	.latch_inB (dn_portB_dout[DN_RD_BW-1:0]),
	.latch_iterA (dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0]), // base address for latch A to indicate the iteration index
	.latch_iterB (dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0]), // base address for latch B to indicate the iteration index
	.rstn (dn_rom_port_fetch), // asserted/deasserted by "rom_port_fetch" signal of Iteration Update Control Unit
	.write_clk (dn_write_clk)
);

dn_Waddr_counter #(
	.PAGE_ADDR_BW (DN_PAGE_ADDR_BW),
	.DN_LOAD_CYCLE (DN_LOAD_CYCLE)
) dn_page_addr_vntM2 (
	.wr_page_addr (dn_wr_page_addr[DN_PAGE_ADDR_BW-1:0]),
	.wr_iter_finish (dn_wr_iter_finish),
	
	.en (dn_ram_write_en),
	.write_clk (dn_write_clk),
	.rstn (~d3ib_rom_rst)
);
/*---------------------------------------------------------------------*/
// Instantiation of IB-Process Unit including the following blocks
// a) Check node unit
// b) Variable node unit
// c) Decision node unit (for final hard decision)
// d) Routing network with Parallel-to-Serial based message-passing converter
ib_proc_wrapper #(
	.CN_ROM_RD_BW          (CN_ROM_RD_BW         ),
	.CN_ROM_ADDR_BW        (CN_ROM_ADDR_BW       ),
	.CN_PAGE_ADDR_BW       (CN_PAGE_ADDR_BW      ),
	.BANK_NUM              (BANK_NUM             ), 
	.CN_DEGREE             (CN_DEGREE            ), 
	.IB_CNU_DECOMP_funNum  (IB_CNU_DECOMP_funNum ),
	.CN_NUM                (CN_NUM               ), 
	.CNU6_INSTANTIATE_NUM  (CNU6_INSTANTIATE_NUM ),
	.CNU6_INSTANTIATE_UNIT (CNU6_INSTANTIATE_UNIT),

	.VN_ROM_RD_BW          (VN_ROM_RD_BW         ),
	.VN_ROM_ADDR_BW        (VN_ROM_ADDR_BW       ),
	.VN_PAGE_ADDR_BW       (VN_PAGE_ADDR_BW      ),
	.DN_ROM_RD_BW          (DN_ROM_RD_BW         ),
	.DN_ROM_ADDR_BW        (DN_ROM_ADDR_BW       ),
	.DN_PAGE_ADDR_BW       (DN_PAGE_ADDR_BW      ),
	.VN_DEGREE             (VN_DEGREE            ),
	.IB_VNU_DECOMP_funNum  (IB_VNU_DECOMP_funNum ),
	.VN_NUM                (VN_NUM               ),
	.VNU3_INSTANTIATE_NUM  (VNU3_INSTANTIATE_NUM ),
	.VNU3_INSTANTIATE_UNIT (VNU3_INSTANTIATE_UNIT),
	.QUAN_SIZE             (QUAN_SIZE            ),
	.MSG_WIDTH             (QUAN_SIZE            ),
	.DATAPATH_WIDTH        (DATAPATH_WIDTH       ),
	.MULTI_FRAME_NUM       (MULTI_FRAME_NUM      ),
	.CN_PIPELINE_DEPTH     (CN_PIPELINE_DEPTH    ),
	.VN_PIPELINE_DEPTH     (VN_PIPELINE_DEPTH    ),
	.DN_PIPELINE_DEPTH     (DN_PIPELINE_DEPTH    )
) ib_proc_u0 (
	.hard_decision (hard_decision[VN_NUM-1:0]),

	.ch_msg_0   (ch_msg_buffer[0  ]),
	.ch_msg_1   (ch_msg_buffer[1  ]),
	.ch_msg_2   (ch_msg_buffer[2  ]),
	.ch_msg_3   (ch_msg_buffer[3  ]),
	.ch_msg_4   (ch_msg_buffer[4  ]),
	.ch_msg_5   (ch_msg_buffer[5  ]),
	.ch_msg_6   (ch_msg_buffer[6  ]),
	.ch_msg_7   (ch_msg_buffer[7  ]),
	.ch_msg_8   (ch_msg_buffer[8  ]),
	.ch_msg_9   (ch_msg_buffer[9  ]),
	.ch_msg_10  (ch_msg_buffer[10 ]),
	.ch_msg_11  (ch_msg_buffer[11 ]),
	.ch_msg_12  (ch_msg_buffer[12 ]),
	.ch_msg_13  (ch_msg_buffer[13 ]),
	.ch_msg_14  (ch_msg_buffer[14 ]),
	.ch_msg_15  (ch_msg_buffer[15 ]),
	.ch_msg_16  (ch_msg_buffer[16 ]),
	.ch_msg_17  (ch_msg_buffer[17 ]),
	.ch_msg_18  (ch_msg_buffer[18 ]),
	.ch_msg_19  (ch_msg_buffer[19 ]),
	.ch_msg_20  (ch_msg_buffer[20 ]),
	.ch_msg_21  (ch_msg_buffer[21 ]),
	.ch_msg_22  (ch_msg_buffer[22 ]),
	.ch_msg_23  (ch_msg_buffer[23 ]),
	.ch_msg_24  (ch_msg_buffer[24 ]),
	.ch_msg_25  (ch_msg_buffer[25 ]),
	.ch_msg_26  (ch_msg_buffer[26 ]),
	.ch_msg_27  (ch_msg_buffer[27 ]),
	.ch_msg_28  (ch_msg_buffer[28 ]),
	.ch_msg_29  (ch_msg_buffer[29 ]),
	.ch_msg_30  (ch_msg_buffer[30 ]),
	.ch_msg_31  (ch_msg_buffer[31 ]),
	.ch_msg_32  (ch_msg_buffer[32 ]),
	.ch_msg_33  (ch_msg_buffer[33 ]),
	.ch_msg_34  (ch_msg_buffer[34 ]),
	.ch_msg_35  (ch_msg_buffer[35 ]),
	.ch_msg_36  (ch_msg_buffer[36 ]),
	.ch_msg_37  (ch_msg_buffer[37 ]),
	.ch_msg_38  (ch_msg_buffer[38 ]),
	.ch_msg_39  (ch_msg_buffer[39 ]),
	.ch_msg_40  (ch_msg_buffer[40 ]),
	.ch_msg_41  (ch_msg_buffer[41 ]),
	.ch_msg_42  (ch_msg_buffer[42 ]),
	.ch_msg_43  (ch_msg_buffer[43 ]),
	.ch_msg_44  (ch_msg_buffer[44 ]),
	.ch_msg_45  (ch_msg_buffer[45 ]),
	.ch_msg_46  (ch_msg_buffer[46 ]),
	.ch_msg_47  (ch_msg_buffer[47 ]),
	.ch_msg_48  (ch_msg_buffer[48 ]),
	.ch_msg_49  (ch_msg_buffer[49 ]),
	.ch_msg_50  (ch_msg_buffer[50 ]),
	.ch_msg_51  (ch_msg_buffer[51 ]),
	.ch_msg_52  (ch_msg_buffer[52 ]),
	.ch_msg_53  (ch_msg_buffer[53 ]),
	.ch_msg_54  (ch_msg_buffer[54 ]),
	.ch_msg_55  (ch_msg_buffer[55 ]),
	.ch_msg_56  (ch_msg_buffer[56 ]),
	.ch_msg_57  (ch_msg_buffer[57 ]),
	.ch_msg_58  (ch_msg_buffer[58 ]),
	.ch_msg_59  (ch_msg_buffer[59 ]),
	.ch_msg_60  (ch_msg_buffer[60 ]),
	.ch_msg_61  (ch_msg_buffer[61 ]),
	.ch_msg_62  (ch_msg_buffer[62 ]),
	.ch_msg_63  (ch_msg_buffer[63 ]),
	.ch_msg_64  (ch_msg_buffer[64 ]),
	.ch_msg_65  (ch_msg_buffer[65 ]),
	.ch_msg_66  (ch_msg_buffer[66 ]),
	.ch_msg_67  (ch_msg_buffer[67 ]),
	.ch_msg_68  (ch_msg_buffer[68 ]),
	.ch_msg_69  (ch_msg_buffer[69 ]),
	.ch_msg_70  (ch_msg_buffer[70 ]),
	.ch_msg_71  (ch_msg_buffer[71 ]),
	.ch_msg_72  (ch_msg_buffer[72 ]),
	.ch_msg_73  (ch_msg_buffer[73 ]),
	.ch_msg_74  (ch_msg_buffer[74 ]),
	.ch_msg_75  (ch_msg_buffer[75 ]),
	.ch_msg_76  (ch_msg_buffer[76 ]),
	.ch_msg_77  (ch_msg_buffer[77 ]),
	.ch_msg_78  (ch_msg_buffer[78 ]),
	.ch_msg_79  (ch_msg_buffer[79 ]),
	.ch_msg_80  (ch_msg_buffer[80 ]),
	.ch_msg_81  (ch_msg_buffer[81 ]),
	.ch_msg_82  (ch_msg_buffer[82 ]),
	.ch_msg_83  (ch_msg_buffer[83 ]),
	.ch_msg_84  (ch_msg_buffer[84 ]),
	.ch_msg_85  (ch_msg_buffer[85 ]),
	.ch_msg_86  (ch_msg_buffer[86 ]),
	.ch_msg_87  (ch_msg_buffer[87 ]),
	.ch_msg_88  (ch_msg_buffer[88 ]),
	.ch_msg_89  (ch_msg_buffer[89 ]),
	.ch_msg_90  (ch_msg_buffer[90 ]),
	.ch_msg_91  (ch_msg_buffer[91 ]),
	.ch_msg_92  (ch_msg_buffer[92 ]),
	.ch_msg_93  (ch_msg_buffer[93 ]),
	.ch_msg_94  (ch_msg_buffer[94 ]),
	.ch_msg_95  (ch_msg_buffer[95 ]),
	.ch_msg_96  (ch_msg_buffer[96 ]),
	.ch_msg_97  (ch_msg_buffer[97 ]),
	.ch_msg_98  (ch_msg_buffer[98 ]),
	.ch_msg_99  (ch_msg_buffer[99 ]),
	.ch_msg_100 (ch_msg_buffer[100]),
	.ch_msg_101 (ch_msg_buffer[101]),
	.ch_msg_102 (ch_msg_buffer[102]),
	.ch_msg_103 (ch_msg_buffer[103]),
	.ch_msg_104 (ch_msg_buffer[104]),
	.ch_msg_105 (ch_msg_buffer[105]),
	.ch_msg_106 (ch_msg_buffer[106]),
	.ch_msg_107 (ch_msg_buffer[107]),
	.ch_msg_108 (ch_msg_buffer[108]),
	.ch_msg_109 (ch_msg_buffer[109]),
	.ch_msg_110 (ch_msg_buffer[110]),
	.ch_msg_111 (ch_msg_buffer[111]),
	.ch_msg_112 (ch_msg_buffer[112]),
	.ch_msg_113 (ch_msg_buffer[113]),
	.ch_msg_114 (ch_msg_buffer[114]),
	.ch_msg_115 (ch_msg_buffer[115]),
	.ch_msg_116 (ch_msg_buffer[116]),
	.ch_msg_117 (ch_msg_buffer[117]),
	.ch_msg_118 (ch_msg_buffer[118]),
	.ch_msg_119 (ch_msg_buffer[119]),
	.ch_msg_120 (ch_msg_buffer[120]),
	.ch_msg_121 (ch_msg_buffer[121]),
	.ch_msg_122 (ch_msg_buffer[122]),
	.ch_msg_123 (ch_msg_buffer[123]),
	.ch_msg_124 (ch_msg_buffer[124]),
	.ch_msg_125 (ch_msg_buffer[125]),
	.ch_msg_126 (ch_msg_buffer[126]),
	.ch_msg_127 (ch_msg_buffer[127]),
	.ch_msg_128 (ch_msg_buffer[128]),
	.ch_msg_129 (ch_msg_buffer[129]),
	.ch_msg_130 (ch_msg_buffer[130]),
	.ch_msg_131 (ch_msg_buffer[131]),
	.ch_msg_132 (ch_msg_buffer[132]),
	.ch_msg_133 (ch_msg_buffer[133]),
	.ch_msg_134 (ch_msg_buffer[134]),
	.ch_msg_135 (ch_msg_buffer[135]),
	.ch_msg_136 (ch_msg_buffer[136]),
	.ch_msg_137 (ch_msg_buffer[137]),
	.ch_msg_138 (ch_msg_buffer[138]),
	.ch_msg_139 (ch_msg_buffer[139]),
	.ch_msg_140 (ch_msg_buffer[140]),
	.ch_msg_141 (ch_msg_buffer[141]),
	.ch_msg_142 (ch_msg_buffer[142]),
	.ch_msg_143 (ch_msg_buffer[143]),
	.ch_msg_144 (ch_msg_buffer[144]),
	.ch_msg_145 (ch_msg_buffer[145]),
	.ch_msg_146 (ch_msg_buffer[146]),
	.ch_msg_147 (ch_msg_buffer[147]),
	.ch_msg_148 (ch_msg_buffer[148]),
	.ch_msg_149 (ch_msg_buffer[149]),
	.ch_msg_150 (ch_msg_buffer[150]),
	.ch_msg_151 (ch_msg_buffer[151]),
	.ch_msg_152 (ch_msg_buffer[152]),
	.ch_msg_153 (ch_msg_buffer[153]),
	.ch_msg_154 (ch_msg_buffer[154]),
	.ch_msg_155 (ch_msg_buffer[155]),
	.ch_msg_156 (ch_msg_buffer[156]),
	.ch_msg_157 (ch_msg_buffer[157]),
	.ch_msg_158 (ch_msg_buffer[158]),
	.ch_msg_159 (ch_msg_buffer[159]),
	.ch_msg_160 (ch_msg_buffer[160]),
	.ch_msg_161 (ch_msg_buffer[161]),
	.ch_msg_162 (ch_msg_buffer[162]),
	.ch_msg_163 (ch_msg_buffer[163]),
	.ch_msg_164 (ch_msg_buffer[164]),
	.ch_msg_165 (ch_msg_buffer[165]),
	.ch_msg_166 (ch_msg_buffer[166]),
	.ch_msg_167 (ch_msg_buffer[167]),
	.ch_msg_168 (ch_msg_buffer[168]),
	.ch_msg_169 (ch_msg_buffer[169]),
	.ch_msg_170 (ch_msg_buffer[170]),
	.ch_msg_171 (ch_msg_buffer[171]),
	.ch_msg_172 (ch_msg_buffer[172]),
	.ch_msg_173 (ch_msg_buffer[173]),
	.ch_msg_174 (ch_msg_buffer[174]),
	.ch_msg_175 (ch_msg_buffer[175]),
	.ch_msg_176 (ch_msg_buffer[176]),
	.ch_msg_177 (ch_msg_buffer[177]),
	.ch_msg_178 (ch_msg_buffer[178]),
	.ch_msg_179 (ch_msg_buffer[179]),
	.ch_msg_180 (ch_msg_buffer[180]),
	.ch_msg_181 (ch_msg_buffer[181]),
	.ch_msg_182 (ch_msg_buffer[182]),
	.ch_msg_183 (ch_msg_buffer[183]),
	.ch_msg_184 (ch_msg_buffer[184]),
	.ch_msg_185 (ch_msg_buffer[185]),
	.ch_msg_186 (ch_msg_buffer[186]),
	.ch_msg_187 (ch_msg_buffer[187]),
	.ch_msg_188 (ch_msg_buffer[188]),
	.ch_msg_189 (ch_msg_buffer[189]),
	.ch_msg_190 (ch_msg_buffer[190]),
	.ch_msg_191 (ch_msg_buffer[191]),
	.ch_msg_192 (ch_msg_buffer[192]),
	.ch_msg_193 (ch_msg_buffer[193]),
	.ch_msg_194 (ch_msg_buffer[194]),
	.ch_msg_195 (ch_msg_buffer[195]),
	.ch_msg_196 (ch_msg_buffer[196]),
	.ch_msg_197 (ch_msg_buffer[197]),
	.ch_msg_198 (ch_msg_buffer[198]),
	.ch_msg_199 (ch_msg_buffer[199]),
	.ch_msg_200 (ch_msg_buffer[200]),
	.ch_msg_201 (ch_msg_buffer[201]),
	.ch_msg_202 (ch_msg_buffer[202]),
	.ch_msg_203 (ch_msg_buffer[203]),
	.read_clk (read_clk),
	.cnu_read_addr_offset (cnu_read_addr_offset),
	.vnu_read_addr_offset (vnu_read_addr_offset),
	.v2c_src (v2c_src[0]),
	.v2c_latch_en (v2c_latch_en),
	.c2v_latch_en (c2v_latch_en),
	.load({v2c_load[0], c2v_load[0]}),
	.parallel_en({v2c_msg_en[0], c2v_msg_en[0]}),

	// Iteration-Refresh Page Address
	.cnu_page_addr_ram_0 ({1'b0, cn_wr_page_addr[0]}),
	.cnu_page_addr_ram_1 ({1'b0, cn_wr_page_addr[1]}),
	.cnu_page_addr_ram_2 ({1'b0, cn_wr_page_addr[2]}),
	.cnu_page_addr_ram_3 ({1'b0, cn_wr_page_addr[3]}),
	.vnu_page_addr_ram_0 ({1'b0, vn_wr_page_addr[0]}),
	.vnu_page_addr_ram_1 ({1'b0, vn_wr_page_addr[1]}),
	.vnu_page_addr_ram_2 ({1'b0, dn_wr_page_addr[DN_PAGE_ADDR_BW-1:0]}), // the last one is for decision node
	//Iteration-Refresh Page Data
	.cnu_ram_write_dataA_0 (cn_latch_outA[0]), // from portA of IB-ROM
	.cnu_ram_write_dataB_0 (cn_latch_outB[0]), // from portB of IB-ROM
	.cnu_ram_write_dataA_1 (cn_latch_outA[1]), // from portA of IB-ROM
	.cnu_ram_write_dataB_1 (cn_latch_outB[1]), // from portB of IB-ROM
	.cnu_ram_write_dataA_2 (cn_latch_outA[2]), // from portA of IB-ROM
	.cnu_ram_write_dataB_2 (cn_latch_outB[2]), // from portB of IB-ROM
	.cnu_ram_write_dataA_3 (cn_latch_outA[3]), // from portA of IB-ROM
	.cnu_ram_write_dataB_3 (cn_latch_outB[3]), // from portB of IB-ROM
	.vnu_ram_write_dataA_0 (vn_latch_outA[0]), // from portA of IB-ROM
	.vnu_ram_write_dataB_0 (vn_latch_outB[0]), // from portB of IB-ROM
	.vnu_ram_write_dataA_1 (vn_latch_outA[1]), // from portA of IB-ROM
	.vnu_ram_write_dataB_1 (vn_latch_outB[1]), // from portB of IB-ROM
	.vnu_ram_write_dataA_2 (dn_latch_outA[DN_ROM_RD_BW-1:0]), // from portA of IB-ROM (for decision node)
	.vnu_ram_write_dataB_2 (dn_latch_outB[DN_ROM_RD_BW-1:0]), // from portB of IB-ROM (for decision node)

	.rstn (rstn),
	.cnu_ib_ram_we (cn_ram_write_en[IB_CNU_DECOMP_funNum-1:0]),
	.vnu_ib_ram_we ({dn_ram_write_en, vn_ram_write_en[IB_VNU_DECOMP_funNum-1:0]}),
	.cn_write_clk (cn_write_clk),
	.vn_write_clk (vn_write_clk),
	.dn_write_clk (dn_write_clk)
);
// End of Instantiation of IB-Process Unit
/*---------------------------------------------------------------------*/
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) c2v_msg_busy <= 0;
	else c2v_msg_busy <= c2v_msg_en[0];
end
assign c2v_latch_en = {c2v_msg_busy && ~c2v_msg_en[0]}; // the busy sign of PSP: 00b -> idle, 01b -> load, 11b -> message passing, 10b -> message passing finished
/*---------------------------------------------------------------------*/
// Obsoleted
//always @(posedge read_clk, negedge rstn) begin
//	if(rstn == 1'b0) 
//		c2v_latch[`DATAPATH_WIDTH-1:0] <= 0;
//	else if(c2v_latch_en == 1'b1) 
//		c2v_latch[`DATAPATH_WIDTH-1:0] <= c2v_parallel_out[`DATAPATH_WIDTH-1:0];
//	else 
//		c2v_latch[`DATAPATH_WIDTH-1:0] <= c2v_latch[`DATAPATH_WIDTH-1:0];
//end
/*---------------------------------------------------------------------*/
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) v2c_msg_busy <= 0;
	else v2c_msg_busy <= v2c_msg_en[0];
end
assign v2c_latch_en = {v2c_msg_busy && ~v2c_msg_en[0]}; // the busy sign of PSP: 00b -> idle, 01b -> load, 11b -> message passing, 10b -> message passing finished
/*---------------------------------------------------------------------*/
// Obsoleted
//always @(posedge read_clk, negedge rstn) begin
//	if(rstn == 1'b0) 
//		v2c_latch[`DATAPATH_WIDTH-1:0] <= 0;
//	else if(v2c_latch_en == 1'b1) 
//		v2c_latch[`DATAPATH_WIDTH-1:0] <= v2c_parallel_out[`DATAPATH_WIDTH-1:0];
//	else 
//		v2c_latch[`DATAPATH_WIDTH-1:0] <= v2c_latch[`DATAPATH_WIDTH-1:0];
//end
/*---------------------------------------------------------------------*/
//////////////////////////////////////////////////////////////////////////////////////////////////////
/*
initial begin
       $dumpfile("sys_fsm.vcd");
       $dumpvars;
end

initial begin
	#0 read_clk     <= 1'b0;
	#2.5;
	forever #5   read_clk     <= ~read_clk;
end
initial begin
	#0 cn_write_clk <= 1'b0;
	//#2.5;
	forever #2.5 cn_write_clk <= ~cn_write_clk;
end
initial begin
	#0 vn_write_clk <= 1'b0;
	forever #2.5 vn_write_clk <= ~vn_write_clk;
end
initial begin
	#0 dn_write_clk <= 1'b0;
	forever #2.5 dn_write_clk <= ~dn_write_clk;
end
initial begin
	#0;
	rstn <= 1'b0;
	
	#2.5;
	#(10*100);
	rstn <= 1'b1;
end
*/
/*
reg [3:0] iter_cnt [0:1];
initial #0 iter_cnt[0] <= 4'd0;
always @(posedge read_clk) begin
	if(sys_fsm_state[0] == P2P_V_OUT) iter_cnt[0] <= iter_cnt[0] + 1'b1;
	else if(iter_cnt[0] == 5) iter_cnt[0] <= 4'd0;
end 
initial #0 iter_cnt[1] <= 4'd0;
always @(posedge read_clk) begin
	if(sys_fsm_state[1] == P2P_V_OUT) iter_cnt[1] <= iter_cnt[1] + 1'b1;
	else if(iter_cnt[1] == 5) iter_cnt[1] <= 4'd0;
end 
initial #0 iter_termination[INTER_FRAME_LEVEL-1:0] <= 'd0;
always @(posedge read_clk) begin
	if(iter_cnt[0] == 5 && sys_fsm_state[0] == CNU_PIPE && de_frame_start[0]) iter_termination[0] <= 1'b1;
	else if(de_frame_start[0] == 1'b1 && iter_termination[0] == 1'b1) iter_termination[0] <= 1'b0;  
end
always @(posedge read_clk) begin
	if(iter_cnt[1] == 5 && sys_fsm_state[1] == CNU_PIPE && de_frame_start[1]) iter_termination[1] <= 1'b1;
	else if(de_frame_start[1] == 1'b1 && iter_termination[1] == 1'b1) iter_termination[1] <= 1'b0;  
end
*/

always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) 
		iter_cnt <= 0;
	else if(sys_fsm_state[0] == VNU_OUT)
		iter_cnt <= iter_cnt + 1'b1;
	else if(iter_termination[0] == 1'b1)
		iter_cnt <= 0;
	else
		iter_cnt <= iter_cnt;
end

reg [1:0] termination_latch;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) termination_latch <= 0;
	else termination_latch[1:0] <= {termination_latch[0], iter_termination[0]};
end
/*--------------------------------------------------------------------------------------------*/
reg [VN_NUM-1:0] hard_decision_reg;
initial hard_decision_reg <= 0;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) hard_decision_reg <= 0;
	else if(decode_busy == 1'b0) hard_decision_reg[VN_NUM-1:0] <= 0;
	//else if(sys_fsm_state[0] == LLR_FETCH) hard_decision_reg[VN_NUM-1:0] <= 0;
	else if(hard_decision_done == 1'b1 || hard_decision_done_reg == 1'b1) hard_decision_reg[VN_NUM-1:0] <= hard_decision[VN_NUM-1:0];
	//else if(sys_fsm_state[0] == P2P_V_OUT) hard_decision_reg[VN_NUM-1:0] <= hard_decision[VN_NUM-1:0]; // to latch the hard decision for two clock cycles
	else hard_decision_reg[VN_NUM-1:0] <= 0;//hard_decision_reg[VN_NUM-1:0];
end
/*--------------------------------------------------------------------------------------------*/
// Syndrome Calculation or all-zero detection
`ifdef ALL_ZERO_CODEWORD
localparam [VN_NUM-1:0] zero_err_symbol = {VN_NUM{1'b1}};
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) iter_termination <= 0;
	else if(hard_decision_done_reg == 1'b1) begin//else if(sys_fsm_state[0] == P2P_V_OUT) begin
		if(hard_decision_reg[VN_NUM-1:0] == zero_err_symbol) iter_termination <= 2'b11;
		else if(iter_cnt == MAX_ITER) iter_termination <= 2'b11;
	end
	else if(iter_termination == 2'b11) iter_termination <= 0;
end
`else // real syndrome calculation

`endif
/*--------------------------------------------------------------------------------------------*/
initial decode_fail <= 1'b0;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) 
		decode_fail <= 1'b0;
	else if(hard_decision_done_reg == 1'b1/*sys_fsm_state[0] == P2P_V_OUT*/ && hard_decision_reg[VN_NUM-1:0] != zero_err_symbol && iter_cnt == MAX_ITER) 
		decode_fail <= 1'b1;
	else 
		decode_fail <= 0;
end
assign decode_termination = |iter_termination[1:0];
assign hard_decision_o[VN_NUM-1:0] = hard_decision_reg[VN_NUM-1:0];

initial decode_busy <= 1'b0;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) decode_busy <= 1'b0;
	else if(sys_fsm_state[0] == LLR_FETCH) decode_busy <= 1'b1;
	else if(iter_termination == 2'b11) decode_busy <= 1'b0;
	else decode_busy <= decode_busy;
end
endmodule