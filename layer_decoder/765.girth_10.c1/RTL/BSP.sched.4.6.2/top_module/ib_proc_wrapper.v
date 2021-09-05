`include "define.vh"
module ib_proc_wrapper #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,
	parameter READ_CLK_RATE  = 100, // 100MHz
	parameter WRITE_CLK_RATE = 200, // 200MHz
	parameter WRITE_CLK_RATIO = WRITE_CLK_RATE/READ_CLK_RATE, // the ratio of write_clk clock rate with respect to clock rate of read_clk, e.g., Ratio = write_clk / read_clk = 200MHz/100MHz = 2

	parameter VN_DEGREE = 3,   // degree of one variable node
	parameter CN_DEGREE = 10, // degree of one check node
	parameter SUBMATRIX_Z = 765,
	parameter IB_ROM_SIZE = 6, // width of one read-out port of RAMB36E1
	parameter IB_ROM_ADDR_WIDTH = 6, // ceil(log2(64-entry)) = 6-bit 
	parameter VNU3_INSTANTIATE_NUM  = 5,
	parameter VNU3_INSTANTIATE_UNIT =  2, // number of partial-VNUs instatiated in one modules (in order to reduce source code size)
	parameter BANK_NUM = 2,
	parameter MULTI_FRAME_NUM   = 2,
	parameter IB_CNU_DECOMP_funNum = 1, // equivalent to one decomposed IB-LUT depth
	parameter IB_VNU_DECOMP_funNum = VN_DEGREE+1-2,
	parameter IB_DNU_DECOMP_funNum = 1,

	parameter ITER_ADDR_BW = 4,  // bit-width of addressing 10 iterationss
    parameter ITER_ROM_GROUP = 10, // the number of iteration datasets stored in one Group of IB-ROMs
	parameter MAX_ITER = 10,

	/*VNUs and DNUs*/
	parameter VN_QUAN_SIZE = 4,
	parameter VN_ROM_RD_BW = 8,    // bit-width of one read port of BRAM based IB-ROM
	parameter VN_ROM_ADDR_BW = 10,  // bit-width of read address of BRAM based IB-ROM
								// #Entry: (128-entry*4-bit) / ROM_RD_BW)*10-iteration
	parameter VN_PIPELINE_DEPTH = 3,

	parameter VN_OVERPROVISION = 1, // the over-counted IB-ROM read address								// ceil(log2(#Entry)) = 11-bit
	parameter DN_QUAN_SIZE = 1,
	parameter DN_ROM_RD_BW = 2,    // bit-width of one read port of BRAM based IB-ROM
	parameter DN_ROM_ADDR_BW = 10,  // bit-width of read address of BRAM based IB-ROM
								// #Entry: (128-entry*4-bit) / ROM_RD_BW)*10-iteration
								// ceil(log2(#Entry)) = 11-bit
	
	parameter DN_OVERPROVISION = 1, // the over-counted IB-ROM read address	
	parameter VN_PAGE_ADDR_BW = 6, // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
	parameter VN_ITER_ADDR_BW = 4,  // bit-width of addressing 10 iterationss
	//parameter VN_TYPE_A = 1,    // the number of check node type in terms of its check node degree   
	//parameter VN_TYPE_B = 1,     // the number of check node type in terms of its check node degree
	parameter DN_PAGE_ADDR_BW = 6, // bit-width of addressing (128-entry*4-bit)/ROM_RD_BW), i.e., ceil(log2((128-entry*4-bit)/ROM_RD_BW)))								
	parameter DN_ITER_ADDR_BW = 4,  // bit-width of addressing 10 iterationss
	parameter DN_PIPELINE_DEPTH = 3,
	//parameter DN_TYPE_A = 1,    // the number of check node type in terms of its check node degree   
	//parameter DN_TYPE_B = 1,     // the number of check node type in terms of its check node degree
	parameter VN_LOAD_CYCLE = 64, // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
	parameter DN_LOAD_CYCLE = 64, // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
	parameter VN_RD_BW = 8,
	parameter DN_RD_BW = 2,
	parameter VN_ADDR_BW = 11,
	parameter DN_ADDR_BW = 11,
/*-------------------------------------------------------------------------------------*/
	// CNU FSMs
	parameter                            RESET_CYCLE = 100,
	parameter                         CNU_FUNC_CYCLE = 4,
	parameter                     CNU_PIPELINE_LEVEL = 1*CNU_FUNC_CYCLE,
	parameter 						BS_PIPELINE_LEVEL = 2,
	parameter 					    VNU_BUBBLE_LEVEL = 2,
	parameter                          FSM_STATE_NUM = 10,
	parameter  [$clog2(FSM_STATE_NUM)-1:0] INIT_LOAD   = 0,
	parameter  [$clog2(FSM_STATE_NUM)-1:0] VNU_IB_RAM_PEND = 1,
	parameter   [$clog2(FSM_STATE_NUM)-1:0] VNU_BUBBLE = 2,
	parameter  [$clog2(FSM_STATE_NUM)-1:0] MEM_FETCH   = 3,
	parameter   [$clog2(FSM_STATE_NUM)-1:0] CNU_PIPE   = 4,
	parameter    [$clog2(FSM_STATE_NUM)-1:0] CNU_OUT   = 5,
	parameter      [$clog2(FSM_STATE_NUM)-1:0] BS_WB   = 6,
	parameter [$clog2(FSM_STATE_NUM)-1:0] PAGE_ALIGN   = 7,
	parameter     [$clog2(FSM_STATE_NUM)-1:0] MEM_WB   = 8,
	parameter [$clog2(FSM_STATE_NUM)-1:0] IDLE 		   = 9,
/*-------------------------------------------------------------------------------------*/
	// VNU FSMs 
	parameter                      VN_PIPELINE_BUBBLE = 0,
	parameter                          VNU_FUNC_CYCLE = 3,
	parameter                          DNU_FUNC_CYCLE = 3,
	parameter                        VNU_FUNC_MEM_END = 2,
	parameter                        DNU_FUNC_MEM_END = 2,
	parameter               VNU_WR_HANDSHAKE_RESPONSE = 2,
	parameter               DNU_WR_HANDSHAKE_RESPONSE = 2,
	parameter                      VNU_PIPELINE_LEVEL = 2*VNU_FUNC_CYCLE+VN_PIPELINE_BUBBLE,
	parameter                      DNU_PIPELINE_LEVEL = 1*DNU_FUNC_CYCLE,
	parameter                       PERMUTATION_LEVEL = 2,
	parameter                        PAGE_ALIGN_LEVEL = 1,
	parameter 						CH_BUBBLE_LEVEL   = 2,
	parameter                       PAGE_MEM_WB_LEVEL = 1,
	parameter                            MEM_RD_LEVEL = 2,
	parameter                           CTRL_FSM_STATE_NUM = 11,
	parameter							WR_FSM_STATE_NUM   = 5,

	parameter [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_INIT_LOAD       = 0,
	parameter [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_VNU_IB_RAM_PEND = 1,
	parameter [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_CH_FETCH        = 2,
	parameter [$clog2(CTRL_FSM_STATE_NUM)-1:0] CH_BUBBLE           = 3,
	parameter [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_MEM_FETCH       = 4,
	parameter [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_VNU_PIPE        = 5,
	parameter [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_VNU_OUT         = 6,
	parameter [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_BS_WB 		   = 7,
	parameter [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_PAGE_ALIGN 	   = 8,
	parameter [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_MEM_WB 		   = 9,
	parameter [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_IDLE  		   = 10,
/*-------------------------------------------------------------------------------------*/
	// Parameters related to BS, PA and MEM
	parameter RAM_DEPTH = 1024,
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH),
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1),
	parameter shift_factor_0 = CHECK_PARALLELISM-24,
	parameter shift_factor_1 = CHECK_PARALLELISM-39,
	parameter shift_factor_2 = CHECK_PARALLELISM-63,
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,

	parameter V2C_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter C2V_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
`ifdef SCHED_4_6
	parameter C2V_MEM_ADDR_BASE = 0,
	parameter V2C_MEM_ADDR_BASE = ROW_CHUNK_NUM,
/*-------------------------------------------------------------------------------------*/
	// Parameters for Channel Buffers
	parameter CH_INIT_LOAD_LEVEL = 5, // $ceil(ROW_CHUNK_NUM/WRITE_CLK_RATIO),
	parameter CH_RAM_WB_ADDR_BASE_1_0 = ROW_CHUNK_NUM,
	parameter CH_RAM_WB_ADDR_BASE_1_1 = ROW_CHUNK_NUM*2,
	parameter CH_FETCH_LATENCY = 5,
	parameter CNU_INIT_FETCH_LATENCY = 3,
	parameter CH_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter CH_MSG_NUM = CHECK_PARALLELISM*CN_DEGREE,
	// Parameters of Channel RAM
	parameter CH_RAM_DEPTH = ROW_CHUNK_NUM*LAYER_NUM,
	parameter CH_RAM_ADDR_WIDTH = $clog2(CH_RAM_DEPTH),
/*-------------------------------------------------------------------------------------*/
	// Parameters for DNU Sign Extension related Control Signals
	parameter SIGN_EXTEN_FF_TO_BS = 10, // 10 clock cycles between latch of VNU.F1.SignExtenOut and input of DNU.SignExtenIn.BS
	/*obsolete*/ parameter PA_TO_DNU_DELAY = 4, // 4 clock cycles between output of PA and input of DNUs 
	parameter V2C_TO_DNU_LATENCY = 9,
	parameter C2V_TO_DNU_LATENCY = 7,
	parameter SIGN_EXTEN_LAYER_CNT_EXTEN = 10,
/*-------------------------------------------------------------------------------------*/
	parameter shift_factor_1_0 = CHECK_PARALLELISM-24,
	parameter shift_factor_1_1 = CHECK_PARALLELISM-39,
	parameter shift_factor_1_2 = CHECK_PARALLELISM-22,	
	parameter shift_factor_2_0 = CHECK_PARALLELISM-9 ,
	parameter shift_factor_2_1 = CHECK_PARALLELISM-21,
	parameter shift_factor_2_2 = CHECK_PARALLELISM-55,
	parameter shift_factor_3_0 = CHECK_PARALLELISM-38,
	parameter shift_factor_3_1 = CHECK_PARALLELISM-28,
	parameter shift_factor_3_2 = CHECK_PARALLELISM-19,	
	parameter shift_factor_4_0 = CHECK_PARALLELISM-71,
	parameter shift_factor_4_1 = CHECK_PARALLELISM-22,
	parameter shift_factor_4_2 = CHECK_PARALLELISM-77,
	parameter shift_factor_5_0 = CHECK_PARALLELISM-22,
	parameter shift_factor_5_1 = CHECK_PARALLELISM-83,
	parameter shift_factor_5_2 = CHECK_PARALLELISM-65,
	parameter shift_factor_6_0 = CHECK_PARALLELISM-39,
	parameter shift_factor_6_1 = CHECK_PARALLELISM-8 ,
	parameter shift_factor_6_2 = CHECK_PARALLELISM-38,
	parameter shift_factor_7_0 = CHECK_PARALLELISM-20,
	parameter shift_factor_7_1 = CHECK_PARALLELISM-25,
	parameter shift_factor_7_2 = CHECK_PARALLELISM-40,
	parameter shift_factor_8_0 = CHECK_PARALLELISM-51,
	parameter shift_factor_8_1 = CHECK_PARALLELISM-28,
	parameter shift_factor_8_2 = CHECK_PARALLELISM-6, 
	parameter shift_factor_9_0 = CHECK_PARALLELISM-50,
	parameter shift_factor_9_1 = CHECK_PARALLELISM-20,
	parameter shift_factor_9_2 = CHECK_PARALLELISM-15,	

	parameter START_PAGE_0_0 = 0,
	parameter START_PAGE_0_1 = 0,
	parameter START_PAGE_0_2 = 0,
	parameter START_PAGE_1_0 = 2,
	parameter START_PAGE_1_1 = 8,
	parameter START_PAGE_1_2 = 1,
	parameter START_PAGE_2_0 = 0,
	parameter START_PAGE_2_1 = 3,
	parameter START_PAGE_2_2 = 8,
	parameter START_PAGE_3_0 = 8,
	parameter START_PAGE_3_1 = 7,
	parameter START_PAGE_3_2 = 5,
	parameter START_PAGE_4_0 = 7,
	parameter START_PAGE_4_1 = 5,
	parameter START_PAGE_4_2 = 7,
	parameter START_PAGE_5_0 = 7,
	parameter START_PAGE_5_1 = 2,
	parameter START_PAGE_5_2 = 1,
	parameter START_PAGE_6_0 = 7,
	parameter START_PAGE_6_1 = 7,
	parameter START_PAGE_6_2 = 6,
	parameter START_PAGE_7_0 = 4,
	parameter START_PAGE_7_1 = 8,
	parameter START_PAGE_7_2 = 8,
	parameter START_PAGE_8_0 = 1,
	parameter START_PAGE_8_1 = 8,
	parameter START_PAGE_8_2 = 2,
	parameter START_PAGE_9_0 = 1,
	parameter START_PAGE_9_1 = 8,
	parameter START_PAGE_9_2 = 2,
/*-------------------------------------------------------------------------------------*/
`endif
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH)
) (
	output wire [CHECK_PARALLELISM-1:0] hard_decision_sub0,
	output wire [CHECK_PARALLELISM-1:0] hard_decision_sub1,
	output wire [CHECK_PARALLELISM-1:0] hard_decision_sub2,
	output wire [CHECK_PARALLELISM-1:0] hard_decision_sub3,
	output wire [CHECK_PARALLELISM-1:0] hard_decision_sub4,
	output wire [CHECK_PARALLELISM-1:0] hard_decision_sub5,
	output wire [CHECK_PARALLELISM-1:0] hard_decision_sub6,
	output wire [CHECK_PARALLELISM-1:0] hard_decision_sub7,
	output wire [CHECK_PARALLELISM-1:0] hard_decision_sub8,
	output wire [CHECK_PARALLELISM-1:0] hard_decision_sub9,

	input wire [SUBMATRIX_Z*QUAN_SIZE-1:0] coded_block_sub0,
	input wire [SUBMATRIX_Z*QUAN_SIZE-1:0] coded_block_sub1,
	input wire [SUBMATRIX_Z*QUAN_SIZE-1:0] coded_block_sub2,
	input wire [SUBMATRIX_Z*QUAN_SIZE-1:0] coded_block_sub3,
	input wire [SUBMATRIX_Z*QUAN_SIZE-1:0] coded_block_sub4,
	input wire [SUBMATRIX_Z*QUAN_SIZE-1:0] coded_block_sub5,
	input wire [SUBMATRIX_Z*QUAN_SIZE-1:0] coded_block_sub6,
	input wire [SUBMATRIX_Z*QUAN_SIZE-1:0] coded_block_sub7,
	input wire [SUBMATRIX_Z*QUAN_SIZE-1:0] coded_block_sub8,
	input wire [SUBMATRIX_Z*QUAN_SIZE-1:0] coded_block_sub9,

	/*-----------------------------------------------------------------------------------------------------------------*/
	//  Control Signals for Message-Pass Wrapper
	input wire c2v_bs_en,
	input wire v2c_bs_en,
	input wire ch_bs_en,
	/*------------------------------*/
	// Control signals associative with message passing of channel buffer and DNU.SignExtension
	input wire ch_ram_init_we,
	input wire ch_ram_wb,
	input wire ch_ram_fetch,
	input wire layer_finish,
	input wire v2c_outRotate_reg_we,
	input wire v2c_outRotate_reg_we_flush,
	input wire dnu_inRotate_bs_en,
	input wire dnu_inRotate_wb,
	input wire dnu_signExten_ram_fetch,
	/*------------------------------*/
	// 1) to indicate the current status of message passing of VNUs, in order to synchronise the C2V MEM's read/write address
	// 2) to indicate the current status of message passing of CNUs, in order to synchronise the V2C MEM's read/write address
	input wire c2v_mem_fetch,
	input wire v2c_mem_fetch,
	/*------------------------------*/
	input wire vnu_bs_src,
	input wire [2:0] vnu_bs_bit0_src,

	input wire c2v_mem_we,
	input wire v2c_mem_we,
	input wire [LAYER_NUM-1:0] v2c_layer_cnt,
	input wire [LAYER_NUM-1:0] signExten_layer_cnt,
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-2:0] v2c_bs_en_propagate,
	input wire [ROW_CHUNK_NUM-2:0] c2v_bs_en_propagate,
	input wire [ROW_CHUNK_NUM-2:0] c2v_mem_we_propagate,
	input wire [ROW_CHUNK_NUM-2:0] v2c_mem_we_propagate,
	input wire c2v_mem_we_propagateIn,
	input wire v2c_mem_we_propagateIn,
	input wire iter_termination,
	input wire read_clk,
	input wire write_clk,
	input wire ch_ram_rd_clk,
	input wire ch_ram_wr_clk,
	input wire decoder_rstn,
	/*-----------------------------------------------------------------------------------------------------------------*/
	// Control Signals for Row Process Elements
	input wire vnu_read_addr_offset, // for future expansion of mult-frame feature
	input wire v2c_src,
	//input wire v2c_latch_en,
	//input wire c2v_latch_en,
	//input wire load,,
	//input wire parallel_en,,
	input wire [VN_PAGE_ADDR_BW:0] vnu_page_addr_ram_0,
	input wire [VN_PAGE_ADDR_BW:0] vnu_page_addr_ram_1,
	input wire [DN_PAGE_ADDR_BW:0] vnu_page_addr_ram_2, // the last one is for decision node

	input wire [VN_ROM_RD_BW-1:0] vnu_ram_write_dataA_0,
	input wire [VN_ROM_RD_BW-1:0] vnu_ram_write_dataB_0,

	input wire [VN_ROM_RD_BW-1:0] vnu_ram_write_dataA_1,
	input wire [VN_ROM_RD_BW-1:0] vnu_ram_write_dataB_1,

	input wire [DN_ROM_RD_BW-1:0] vnu_ram_write_dataA_2,
	input wire [DN_ROM_RD_BW-1:0] vnu_ram_write_dataB_2,
	input wire [IB_VNU_DECOMP_funNum:0] vnu_ib_ram_we,
	input wire vn_write_clk,
	input wire dn_write_clk
);

/*-----------------------------------------------------------------------------------------------------------------*/
// Common Net and Regs for usage of Message-Passing Wrapper and Row Process Elements
wire         [CN_DEGREE*QUAN_SIZE-1:0] vnuOut_v2c [0:CHECK_PARALLELISM-1];
wire         [CN_DEGREE-1:0] dnu_signExten_gen [0:CHECK_PARALLELISM-1];
wire         [CN_DEGREE*QUAN_SIZE-1:0] cnuOut_c2v [0:CHECK_PARALLELISM-1];
wire         [CN_DEGREE*QUAN_SIZE-1:0] ch_to_cnu [0:CHECK_PARALLELISM-1];
wire         [CN_DEGREE*QUAN_SIZE-1:0] ch_to_vnu [0:CHECK_PARALLELISM-1];
/*-----------------------------------------------------------------------------------------------------------------*/
// Instantiation of Message Passing Mechanism where included components are as follows:
//		1) Permutation network of check-to-variable messages
//		2) Page-Aligned Mechanism of check-to-variable messages
//		3) Check-to-Variable Memory
//		4) Multiplexing of VNU related permutation network input sources
//		5) Permutation network of variable-to-check messages
//		6) Page-Aligned Mechanism of variable-to-check messages
//		7) Variable-to-Check Memory
//		8) Channel Buffer
//		9) Sign Extension Control Signals for second segment of read address of Decision Node Unit
/*-----------------------------------------------------------------------------------------------------------------*/
// Data Out
wire        [V2C_DATA_WIDTH-1:0] mem_to_cnu_sub    [0:CN_DEGREE-1];
wire        [C2V_DATA_WIDTH-1:0] mem_to_vnu_sub    [0:CN_DEGREE-1];
wire         [CH_DATA_WIDTH-1:0] ch_to_cnu_sub     [0:CN_DEGREE-1];
wire         [CH_DATA_WIDTH-1:0] ch_to_vnu_sub     [0:CN_DEGREE-1];
wire 		  [CH_DATA_WIDTH-1:0] ch_to_bs_sub      [0:CN_DEGREE-1];
wire     [CHECK_PARALLELISM-1:0] dnu_signExten_sub [0:CN_DEGREE-1];
// Data In
wire [V2C_DATA_WIDTH-1:0] vnuOut_to_mem [0:CN_DEGREE-1];
wire [C2V_DATA_WIDTH-1:0] cnuOut_to_mem [0:CN_DEGREE-1];
wire [CHECK_PARALLELISM-1:0] signExten_to_bs [0:CN_DEGREE-1];
/*-----------------------------------------------------------------------------------------------------------------*/
// Control signals In
wire                             vnu_bs_src; assign vnu_bs_src = ch_bs_en;
wire                       [2:0] vnu_bs_bit0_src; assign vnu_bs_bit0_src[2:0] = {dnu_inRotate_bs_en, ch_bs_en, v2c_bs_en};
wire                             ch_ram_rd_clk; assign ch_ram_rd_clk = read_clk;
wire                             ch_ram_wr_clk; assign ch_ram_wr_clk = write_clk;

reg [5:0] v2c_bs_en_propagate_temp; always @(posedge read_clk) begin if(!decoder_rstn) v2c_bs_en_propagate_temp <= 0; else v2c_bs_en_propagate_temp[5:0] <= {v2c_bs_en_propagate_temp[4:0], v2c_bs_en_propagate[ROW_CHUNK_NUM-2]}; end
reg [5:0] c2v_bs_en_propagate_temp; always @(posedge read_clk) begin if(!decoder_rstn) c2v_bs_en_propagate_temp <= 0; else c2v_bs_en_propagate_temp[5:0] <= {c2v_bs_en_propagate_temp[4:0], c2v_bs_en_propagate[ROW_CHUNK_NUM-2]}; end
wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt; assign c2v_row_chunk_cnt[ROW_CHUNK_NUM-1:0] = {c2v_mem_we_propagate[ROW_CHUNK_NUM-2:0], c2v_mem_we_propagateIn};
wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt; assign v2c_row_chunk_cnt[ROW_CHUNK_NUM-1:0] = {v2c_mem_we_propagate[ROW_CHUNK_NUM-2:0], v2c_mem_we_propagateIn};
/*-----------------------------------------------------------------------------------------------------------------*/
// Instantiation of Message-Padding Wrapper Top Module of functionality so as the aforementioned description
entire_message_passing_wrapper #(
	.QUAN_SIZE(QUAN_SIZE),
	.LAYER_NUM(LAYER_NUM),
	.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
	.CHECK_PARALLELISM(CHECK_PARALLELISM),
	.READ_CLK_RATE(READ_CLK_RATE),
	.WRITE_CLK_RATE(WRITE_CLK_RATE),
	.WRITE_CLK_RATIO(WRITE_CLK_RATIO),
	.VN_DEGREE(VN_DEGREE),
	.CN_DEGREE(CN_DEGREE),
	.SUBMATRIX_Z(SUBMATRIX_Z),
	.IB_ROM_SIZE(IB_ROM_SIZE),
	.IB_ROM_ADDR_WIDTH(IB_ROM_ADDR_WIDTH),
	.IB_CNU_DECOMP_funNum(IB_CNU_DECOMP_funNum),
	.IB_VNU_DECOMP_funNum(IB_VNU_DECOMP_funNum),
	.IB_DNU_DECOMP_funNum(IB_DNU_DECOMP_funNum),
	.ITER_ADDR_BW(ITER_ADDR_BW),
	.ITER_ROM_GROUP(ITER_ROM_GROUP),
	.MAX_ITER(MAX_ITER),
	.VN_QUAN_SIZE(VN_QUAN_SIZE),
	.VN_ROM_RD_BW(VN_ROM_RD_BW),
	.VN_ROM_ADDR_BW(VN_ROM_ADDR_BW),
	.VN_PIPELINE_DEPTH(VN_PIPELINE_DEPTH),
	.VN_OVERPROVISION(VN_OVERPROVISION),
	.DN_QUAN_SIZE(DN_QUAN_SIZE),
	.DN_ROM_RD_BW(DN_ROM_RD_BW),
	.DN_ROM_ADDR_BW(DN_ROM_ADDR_BW),
	.DN_OVERPROVISION(DN_OVERPROVISION),
	.VN_PAGE_ADDR_BW(VN_PAGE_ADDR_BW),
	.VN_ITER_ADDR_BW(VN_ITER_ADDR_BW),
	.DN_PAGE_ADDR_BW(DN_PAGE_ADDR_BW),
	.DN_ITER_ADDR_BW(DN_ITER_ADDR_BW),
	.DN_PIPELINE_DEPTH(DN_PIPELINE_DEPTH),
	.VN_LOAD_CYCLE(VN_LOAD_CYCLE),
	.DN_LOAD_CYCLE(DN_LOAD_CYCLE),
	.VN_RD_BW(VN_RD_BW),
	.DN_RD_BW(DN_RD_BW),
	.VN_ADDR_BW(VN_ADDR_BW),
	.DN_ADDR_BW(DN_ADDR_BW),
	.RESET_CYCLE(RESET_CYCLE),
	.CNU_FUNC_CYCLE(CNU_FUNC_CYCLE),
	.CNU_PIPELINE_LEVEL(CNU_PIPELINE_LEVEL),
	.FSM_STATE_NUM(FSM_STATE_NUM),
	.INIT_LOAD(INIT_LOAD),
	.MEM_FETCH(MEM_FETCH),
	.VNU_IB_RAM_PEND(VNU_IB_RAM_PEND),
	.CNU_PIPE(CNU_PIPE),
	.CNU_OUT(CNU_OUT),
	.BS_WB(BS_WB),
	.PAGE_ALIGN(PAGE_ALIGN),
	.MEM_WB(MEM_WB),
	.IDLE(IDLE),
	.VN_PIPELINE_BUBBLE(VN_PIPELINE_BUBBLE),
	.VNU_FUNC_CYCLE(VNU_FUNC_CYCLE),
	.DNU_FUNC_CYCLE(DNU_FUNC_CYCLE),
	.VNU_FUNC_MEM_END(VNU_FUNC_MEM_END),
	.DNU_FUNC_MEM_END(DNU_FUNC_MEM_END),
	.VNU_WR_HANDSHAKE_RESPONSE(VNU_WR_HANDSHAKE_RESPONSE),
	.DNU_WR_HANDSHAKE_RESPONSE(DNU_WR_HANDSHAKE_RESPONSE),
	.VNU_PIPELINE_LEVEL(VNU_PIPELINE_LEVEL),
	.DNU_PIPELINE_LEVEL(DNU_PIPELINE_LEVEL),
	.PERMUTATION_LEVEL(PERMUTATION_LEVEL),
	.PAGE_ALIGN_LEVEL(PAGE_ALIGN_LEVEL),
	.MEM_RD_LEVEL(MEM_RD_LEVEL),
	.CTRL_FSM_STATE_NUM(CTRL_FSM_STATE_NUM),
	.WR_FSM_STATE_NUM(WR_FSM_STATE_NUM),
	.VNU_INIT_LOAD(VNU_INIT_LOAD),
	.VNU_MEM_FETCH(VNU_MEM_FETCH),
	.VNU_VNU_PIPE(VNU_VNU_PIPE),
	.VNU_VNU_OUT(VNU_VNU_OUT),
	.VNU_BS_WB(VNU_BS_WB),
	.VNU_PAGE_ALIGN(VNU_PAGE_ALIGN),
	.VNU_MEM_WB(VNU_MEM_WB),
	.VNU_IDLE(VNU_IDLE),
	.RAM_DEPTH(RAM_DEPTH),
	.RAM_ADDR_BITWIDTH(RAM_ADDR_BITWIDTH),
	.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR),
	.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
	.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
	.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
	.C2V_MEM_ADDR_BASE(C2V_MEM_ADDR_BASE),
	.V2C_MEM_ADDR_BASE(V2C_MEM_ADDR_BASE),
	.V2C_DATA_WIDTH(V2C_DATA_WIDTH),
	.C2V_DATA_WIDTH(C2V_DATA_WIDTH),
	.BS_PIPELINE_LEVEL(BS_PIPELINE_LEVEL),
	.CH_INIT_LOAD_LEVEL(CH_INIT_LOAD_LEVEL),
	.CH_RAM_WB_ADDR_BASE_1_0(CH_RAM_WB_ADDR_BASE_1_0),
	.CH_RAM_WB_ADDR_BASE_1_1(CH_RAM_WB_ADDR_BASE_1_1),
	.CH_FETCH_LATENCY(CH_FETCH_LATENCY),
	.CNU_INIT_FETCH_LATENCY(CNU_INIT_FETCH_LATENCY),
	.CH_DATA_WIDTH(CH_DATA_WIDTH),
	.CH_MSG_NUM(CH_MSG_NUM),
	.CH_RAM_DEPTH(CH_RAM_DEPTH),
	.CH_RAM_ADDR_WIDTH(CH_RAM_ADDR_WIDTH),
	.PA_TO_DNU_DELAY(PA_TO_DNU_DELAY),
	.SIGN_EXTEN_FF_TO_BS(SIGN_EXTEN_FF_TO_BS),
	.shift_factor_1_0(shift_factor_1_0),
	.shift_factor_1_1(shift_factor_1_1),
	.shift_factor_1_2(shift_factor_1_2),
	.shift_factor_2_0(shift_factor_2_0),
	.shift_factor_2_1(shift_factor_2_1),
	.shift_factor_2_2(shift_factor_2_2),
	.shift_factor_3_0(shift_factor_3_0),
	.shift_factor_3_1(shift_factor_3_1),
	.shift_factor_3_2(shift_factor_3_2),
	.shift_factor_4_0(shift_factor_4_0),
	.shift_factor_4_1(shift_factor_4_1),
	.shift_factor_4_2(shift_factor_4_2),
	.shift_factor_5_0(shift_factor_5_0),
	.shift_factor_5_1(shift_factor_5_1),
	.shift_factor_5_2(shift_factor_5_2),
	.shift_factor_6_0(shift_factor_6_0),
	.shift_factor_6_1(shift_factor_6_1),
	.shift_factor_6_2(shift_factor_6_2),
	.shift_factor_7_0(shift_factor_7_0),
	.shift_factor_7_1(shift_factor_7_1),
	.shift_factor_7_2(shift_factor_7_2),
	.shift_factor_8_0(shift_factor_8_0),
	.shift_factor_8_1(shift_factor_8_1),
	.shift_factor_8_2(shift_factor_8_2),
	.shift_factor_9_0(shift_factor_9_0),
	.shift_factor_9_1(shift_factor_9_1),
	.shift_factor_9_2(shift_factor_9_2),
	.START_PAGE_0_0(START_PAGE_0_0),
	.START_PAGE_0_1(START_PAGE_0_1),
	.START_PAGE_0_2(START_PAGE_0_2),
	.START_PAGE_1_0(START_PAGE_1_0),
	.START_PAGE_1_1(START_PAGE_1_1),
	.START_PAGE_1_2(START_PAGE_1_2),
	.START_PAGE_2_0(START_PAGE_2_0),
	.START_PAGE_2_1(START_PAGE_2_1),
	.START_PAGE_2_2(START_PAGE_2_2),
	.START_PAGE_3_0(START_PAGE_3_0),
	.START_PAGE_3_1(START_PAGE_3_1),
	.START_PAGE_3_2(START_PAGE_3_2),
	.START_PAGE_4_0(START_PAGE_4_0),
	.START_PAGE_4_1(START_PAGE_4_1),
	.START_PAGE_4_2(START_PAGE_4_2),
	.START_PAGE_5_0(START_PAGE_5_0),
	.START_PAGE_5_1(START_PAGE_5_1),
	.START_PAGE_5_2(START_PAGE_5_2),
	.START_PAGE_6_0(START_PAGE_6_0),
	.START_PAGE_6_1(START_PAGE_6_1),
	.START_PAGE_6_2(START_PAGE_6_2),
	.START_PAGE_7_0(START_PAGE_7_0),
	.START_PAGE_7_1(START_PAGE_7_1),
	.START_PAGE_7_2(START_PAGE_7_2),
	.START_PAGE_8_0(START_PAGE_8_0),
	.START_PAGE_8_1(START_PAGE_8_1),
	.START_PAGE_8_2(START_PAGE_8_2),
	.START_PAGE_9_0(START_PAGE_9_0),
	.START_PAGE_9_1(START_PAGE_9_1),
	.START_PAGE_9_2(START_PAGE_9_2),
	.DEPTH(DEPTH),
	.DATA_WIDTH(DATA_WIDTH),
	.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH)
) inst_entire_message_passing_wrapper (
	.mem_to_cnu_sub0       (mem_to_cnu_sub[0]),
	.mem_to_cnu_sub1       (mem_to_cnu_sub[1]),
	.mem_to_cnu_sub2       (mem_to_cnu_sub[2]),
	.mem_to_cnu_sub3       (mem_to_cnu_sub[3]),
	.mem_to_cnu_sub4       (mem_to_cnu_sub[4]),
	.mem_to_cnu_sub5       (mem_to_cnu_sub[5]),
	.mem_to_cnu_sub6       (mem_to_cnu_sub[6]),
	.mem_to_cnu_sub7       (mem_to_cnu_sub[7]),
	.mem_to_cnu_sub8       (mem_to_cnu_sub[8]),
	.mem_to_cnu_sub9       (mem_to_cnu_sub[9]),
	.mem_to_vnu_sub0       (mem_to_vnu_sub[0]),
	.mem_to_vnu_sub1       (mem_to_vnu_sub[1]),
	.mem_to_vnu_sub2       (mem_to_vnu_sub[2]),
	.mem_to_vnu_sub3       (mem_to_vnu_sub[3]),
	.mem_to_vnu_sub4       (mem_to_vnu_sub[4]),
	.mem_to_vnu_sub5       (mem_to_vnu_sub[5]),
	.mem_to_vnu_sub6       (mem_to_vnu_sub[6]),
	.mem_to_vnu_sub7       (mem_to_vnu_sub[7]),
	.mem_to_vnu_sub8       (mem_to_vnu_sub[8]),
	.mem_to_vnu_sub9       (mem_to_vnu_sub[9]),
	.ch_to_cnu_sub0        (ch_to_cnu_sub[0]),
	.ch_to_cnu_sub1        (ch_to_cnu_sub[1]),
	.ch_to_cnu_sub2        (ch_to_cnu_sub[2]),
	.ch_to_cnu_sub3        (ch_to_cnu_sub[3]),
	.ch_to_cnu_sub4        (ch_to_cnu_sub[4]),
	.ch_to_cnu_sub5        (ch_to_cnu_sub[5]),
	.ch_to_cnu_sub6        (ch_to_cnu_sub[6]),
	.ch_to_cnu_sub7        (ch_to_cnu_sub[7]),
	.ch_to_cnu_sub8        (ch_to_cnu_sub[8]),
	.ch_to_cnu_sub9        (ch_to_cnu_sub[9]),
	.ch_to_vnu_sub0        (ch_to_vnu_sub[0]),
	.ch_to_vnu_sub1        (ch_to_vnu_sub[1]),
	.ch_to_vnu_sub2        (ch_to_vnu_sub[2]),
	.ch_to_vnu_sub3        (ch_to_vnu_sub[3]),
	.ch_to_vnu_sub4        (ch_to_vnu_sub[4]),
	.ch_to_vnu_sub5        (ch_to_vnu_sub[5]),
	.ch_to_vnu_sub6        (ch_to_vnu_sub[6]),
	.ch_to_vnu_sub7        (ch_to_vnu_sub[7]),
	.ch_to_vnu_sub8        (ch_to_vnu_sub[8]),
	.ch_to_vnu_sub9        (ch_to_vnu_sub[9]),
	.dnu_signExten_sub0    (dnu_signExten_sub[0]),
	.dnu_signExten_sub1    (dnu_signExten_sub[1]),
	.dnu_signExten_sub2    (dnu_signExten_sub[2]),
	.dnu_signExten_sub3    (dnu_signExten_sub[3]),
	.dnu_signExten_sub4    (dnu_signExten_sub[4]),
	.dnu_signExten_sub5    (dnu_signExten_sub[5]),
	.dnu_signExten_sub6    (dnu_signExten_sub[6]),
	.dnu_signExten_sub7    (dnu_signExten_sub[7]),
	.dnu_signExten_sub8    (dnu_signExten_sub[8]),
	.dnu_signExten_sub9    (dnu_signExten_sub[9]),

	.c2v_bs_in_sub0        (cnuOut_to_mem[0]),
	.c2v_bs_in_sub1        (cnuOut_to_mem[1]),
	.c2v_bs_in_sub2        (cnuOut_to_mem[2]),
	.c2v_bs_in_sub3        (cnuOut_to_mem[3]),
	.c2v_bs_in_sub4        (cnuOut_to_mem[4]),
	.c2v_bs_in_sub5        (cnuOut_to_mem[5]),
	.c2v_bs_in_sub6        (cnuOut_to_mem[6]),
	.c2v_bs_in_sub7        (cnuOut_to_mem[7]),
	.c2v_bs_in_sub8        (cnuOut_to_mem[8]),
	.c2v_bs_in_sub9        (cnuOut_to_mem[9]),

	.v2c_bs_in_sub0        (vnuOut_to_mem[0]),
	.v2c_bs_in_sub1        (vnuOut_to_mem[1]),
	.v2c_bs_in_sub2        (vnuOut_to_mem[2]),
	.v2c_bs_in_sub3        (vnuOut_to_mem[3]),
	.v2c_bs_in_sub4        (vnuOut_to_mem[4]),
	.v2c_bs_in_sub5        (vnuOut_to_mem[5]),
	.v2c_bs_in_sub6        (vnuOut_to_mem[6]),
	.v2c_bs_in_sub7        (vnuOut_to_mem[7]),
	.v2c_bs_in_sub8        (vnuOut_to_mem[8]),
	.v2c_bs_in_sub9        (vnuOut_to_mem[9]),

	.coded_block_sub0      (coded_block_sub0[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub1      (coded_block_sub1[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub2      (coded_block_sub2[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub3      (coded_block_sub3[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub4      (coded_block_sub4[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub5      (coded_block_sub5[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub6      (coded_block_sub6[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub7      (coded_block_sub7[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub8      (coded_block_sub8[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub9      (coded_block_sub9[SUBMATRIX_Z*QUAN_SIZE-1:0]),

	.dnu_inRotate_bit_sub0 (signExten_to_bs[0]),
	.dnu_inRotate_bit_sub1 (signExten_to_bs[1]),
	.dnu_inRotate_bit_sub2 (signExten_to_bs[2]),
	.dnu_inRotate_bit_sub3 (signExten_to_bs[3]),
	.dnu_inRotate_bit_sub4 (signExten_to_bs[4]),
	.dnu_inRotate_bit_sub5 (signExten_to_bs[5]),
	.dnu_inRotate_bit_sub6 (signExten_to_bs[6]),
	.dnu_inRotate_bit_sub7 (signExten_to_bs[7]),
	.dnu_inRotate_bit_sub8 (signExten_to_bs[8]),
	.dnu_inRotate_bit_sub9 (signExten_to_bs[9]),

	// Control Signals
	.c2v_bs_en (c2v_bs_en),
	.v2c_bs_en (v2c_bs_en),
	.ch_bs_en  (ch_bs_en ),
	/*------------------------------*/
	// Control signals associative with message passing of channel buffer and DNU.SignExtension
	.ch_ram_init_we             (ch_ram_init_we            ),
	.ch_ram_wb                  (ch_ram_wb                 ),
	.ch_ram_fetch               (ch_ram_fetch              ),
	.layer_finish               (layer_finish              ),
	.v2c_outRotate_reg_we       (v2c_outRotate_reg_we      ),
	.v2c_outRotate_reg_we_flush (v2c_outRotate_reg_we_flush),
	.dnu_inRotate_bs_en         (dnu_inRotate_bs_en        ),
	.dnu_inRotate_wb            (dnu_inRotate_wb           ),
	.dnu_signExten_ram_fetch    (dnu_signExten_ram_fetch   ),
	/*------------------------------*/
	// 1) to indicate the current status of message passing of VNUs, in order to synchronise the C2V MEM's read/write address
	// 2) to indicate the current status of message passing of CNUs, in order to synchronise the V2C MEM's read/write address
	.c2v_mem_fetch (c2v_mem_fetch),
	.v2c_mem_fetch (v2c_mem_fetch),
	/*------------------------------*/
	.vnu_bs_src (vnu_bs_src),
	.vnu_bs_bit0_src (vnu_bs_bit0_src[2:0]),

	.c2v_mem_we (c2v_mem_we),
	.v2c_mem_we (v2c_mem_we),
	.v2c_layer_cnt       (v2c_layer_cnt[LAYER_NUM-1:0]),
	.signExten_layer_cnt (signExten_layer_cnt[LAYER_NUM-1:0]),
	.c2v_last_row_chunk (c2v_last_row_chunk),
	.v2c_last_row_chunk (v2c_last_row_chunk),
	.c2v_row_chunk_cnt (c2v_row_chunk_cnt[ROW_CHUNK_NUM-1:0]),
	.v2c_row_chunk_cnt (v2c_row_chunk_cnt[ROW_CHUNK_NUM-1:0]),
	.iter_termination (iter_termination),
	.read_clk         (read_clk        ),
	.write_clk        (write_clk       ),
	.ch_ram_rd_clk    (ch_ram_rd_clk   ),
	.ch_ram_wr_clk    (ch_ram_wr_clk   ),
	.rstn (decoder_rstn)
);
genvar submatrix_id;
generate
	for(submatrix_id=0; submatrix_id<CN_DEGREE; submatrix_id=submatrix_id+1) begin : mem_Din_net_assignment
		assign cnuOut_to_mem[submatrix_id] = {cnuOut_c2v[84][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[83][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[82][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[81][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[80][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[79][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[78][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[77][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[76][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[75][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[74][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[73][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[72][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[71][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[70][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[69][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[68][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[67][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[66][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[65][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[64][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[63][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[62][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[61][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[60][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[59][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[58][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[57][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[56][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[55][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[54][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[53][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[52][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[51][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[50][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[49][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[48][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[47][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[46][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[45][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[44][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[43][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[42][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[41][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[40][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[39][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[38][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[37][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[36][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[35][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[34][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[33][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[32][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[31][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[30][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[29][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[28][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[27][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[26][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[25][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[24][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[23][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[22][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[21][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[20][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[19][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[18][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[17][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[16][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[15][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[14][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[13][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[12][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[11][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[10][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[9][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[8][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[7][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[6][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[5][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[4][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[3][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[2][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[1][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],cnuOut_c2v[0][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE]};
		assign vnuOut_to_mem[submatrix_id] = {vnuOut_v2c[84][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[83][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[82][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[81][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[80][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[79][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[78][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[77][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[76][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[75][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[74][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[73][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[72][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[71][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[70][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[69][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[68][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[67][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[66][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[65][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[64][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[63][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[62][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[61][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[60][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[59][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[58][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[57][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[56][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[55][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[54][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[53][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[52][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[51][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[50][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[49][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[48][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[47][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[46][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[45][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[44][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[43][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[42][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[41][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[40][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[39][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[38][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[37][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[36][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[35][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[34][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[33][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[32][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[31][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[30][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[29][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[28][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[27][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[26][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[25][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[24][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[23][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[22][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[21][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[20][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[19][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[18][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[17][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[16][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[15][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[14][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[13][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[12][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[11][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[10][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[9][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[8][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[7][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[6][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[5][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[4][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[3][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[2][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[1][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE],vnuOut_v2c[0][(submatrix_id+1)*QUAN_SIZE-1:submatrix_id*QUAN_SIZE]};
		assign signExten_to_bs[submatrix_id] = {dnu_signExten_gen[84][submatrix_id],dnu_signExten_gen[83][submatrix_id],dnu_signExten_gen[82][submatrix_id],dnu_signExten_gen[81][submatrix_id],dnu_signExten_gen[80][submatrix_id],dnu_signExten_gen[79][submatrix_id],dnu_signExten_gen[78][submatrix_id],dnu_signExten_gen[77][submatrix_id],dnu_signExten_gen[76][submatrix_id],dnu_signExten_gen[75][submatrix_id],dnu_signExten_gen[74][submatrix_id],dnu_signExten_gen[73][submatrix_id],dnu_signExten_gen[72][submatrix_id],dnu_signExten_gen[71][submatrix_id],dnu_signExten_gen[70][submatrix_id],dnu_signExten_gen[69][submatrix_id],dnu_signExten_gen[68][submatrix_id],dnu_signExten_gen[67][submatrix_id],dnu_signExten_gen[66][submatrix_id],dnu_signExten_gen[65][submatrix_id],dnu_signExten_gen[64][submatrix_id],dnu_signExten_gen[63][submatrix_id],dnu_signExten_gen[62][submatrix_id],dnu_signExten_gen[61][submatrix_id],dnu_signExten_gen[60][submatrix_id],dnu_signExten_gen[59][submatrix_id],dnu_signExten_gen[58][submatrix_id],dnu_signExten_gen[57][submatrix_id],dnu_signExten_gen[56][submatrix_id],dnu_signExten_gen[55][submatrix_id],dnu_signExten_gen[54][submatrix_id],dnu_signExten_gen[53][submatrix_id],dnu_signExten_gen[52][submatrix_id],dnu_signExten_gen[51][submatrix_id],dnu_signExten_gen[50][submatrix_id],dnu_signExten_gen[49][submatrix_id],dnu_signExten_gen[48][submatrix_id],dnu_signExten_gen[47][submatrix_id],dnu_signExten_gen[46][submatrix_id],dnu_signExten_gen[45][submatrix_id],dnu_signExten_gen[44][submatrix_id],dnu_signExten_gen[43][submatrix_id],dnu_signExten_gen[42][submatrix_id],dnu_signExten_gen[41][submatrix_id],dnu_signExten_gen[40][submatrix_id],dnu_signExten_gen[39][submatrix_id],dnu_signExten_gen[38][submatrix_id],dnu_signExten_gen[37][submatrix_id],dnu_signExten_gen[36][submatrix_id],dnu_signExten_gen[35][submatrix_id],dnu_signExten_gen[34][submatrix_id],dnu_signExten_gen[33][submatrix_id],dnu_signExten_gen[32][submatrix_id],dnu_signExten_gen[31][submatrix_id],dnu_signExten_gen[30][submatrix_id],dnu_signExten_gen[29][submatrix_id],dnu_signExten_gen[28][submatrix_id],dnu_signExten_gen[27][submatrix_id],dnu_signExten_gen[26][submatrix_id],dnu_signExten_gen[25][submatrix_id],dnu_signExten_gen[24][submatrix_id],dnu_signExten_gen[23][submatrix_id],dnu_signExten_gen[22][submatrix_id],dnu_signExten_gen[21][submatrix_id],dnu_signExten_gen[20][submatrix_id],dnu_signExten_gen[19][submatrix_id],dnu_signExten_gen[18][submatrix_id],dnu_signExten_gen[17][submatrix_id],dnu_signExten_gen[16][submatrix_id],dnu_signExten_gen[15][submatrix_id],dnu_signExten_gen[14][submatrix_id],dnu_signExten_gen[13][submatrix_id],dnu_signExten_gen[12][submatrix_id],dnu_signExten_gen[11][submatrix_id],dnu_signExten_gen[10][submatrix_id],dnu_signExten_gen[9][submatrix_id],dnu_signExten_gen[8][submatrix_id],dnu_signExten_gen[7][submatrix_id],dnu_signExten_gen[6][submatrix_id],dnu_signExten_gen[5][submatrix_id],dnu_signExten_gen[4][submatrix_id],dnu_signExten_gen[3][submatrix_id],dnu_signExten_gen[2][submatrix_id],dnu_signExten_gen[1][submatrix_id],dnu_signExten_gen[0][submatrix_id]};		
	end
endgenerate
/*-----------------------------------------------------------------------------------------------------------------*/
// Instantiation of Row Process Elements
wire         [CN_DEGREE-1:0] hard_decision [0:CHECK_PARALLELISM-1];
wire         [CN_DEGREE*QUAN_SIZE-1:0] cnuIn_v2c0 [0:CHECK_PARALLELISM-1];
wire         [CN_DEGREE*QUAN_SIZE-1:0] vnu_post_c2v0 [0:CHECK_PARALLELISM-1];
wire         [CN_DEGREE-1:0] dnu_signExtenIn [0:CHECK_PARALLELISM-1];
genvar row_pe_id;
generate
	for(row_pe_id=0; row_pe_id<CHECK_PARALLELISM; row_pe_id=row_pe_id+1) begin : row_pe_inst
		row_process_element #(
			.QUAN_SIZE(QUAN_SIZE),
			.CN_DEGREE(CN_DEGREE),
			.VN_DEGREE(VN_DEGREE),
			.CNU_FUNC_CYCLE(CNU_FUNC_CYCLE),
			.VN_ROM_RD_BW(VN_ROM_RD_BW),
			.VN_ROM_ADDR_BW(VN_ROM_ADDR_BW),
			.VN_PAGE_ADDR_BW(VN_PAGE_ADDR_BW),
			.DN_ROM_RD_BW(DN_ROM_RD_BW),
			.DN_ROM_ADDR_BW(DN_ROM_ADDR_BW),
			.DN_PAGE_ADDR_BW(DN_PAGE_ADDR_BW),
			.VNU3_INSTANTIATE_NUM(VNU3_INSTANTIATE_NUM),
			.VNU3_INSTANTIATE_UNIT(VNU3_INSTANTIATE_UNIT),
			.BANK_NUM(BANK_NUM),
			.IB_VNU_DECOMP_funNum(IB_VNU_DECOMP_funNum),
			.VN_PIPELINE_DEPTH(VN_PIPELINE_DEPTH),
			.DN_PIPELINE_DEPTH(DN_PIPELINE_DEPTH),
			.MULTI_FRAME_NUM(MULTI_FRAME_NUM),
			.V2C_TO_DNU_LATENCY (V2C_TO_DNU_LATENCY),
			.C2V_TO_DNU_LATENCY (C2V_TO_DNU_LATENCY)
		) inst_row_process_element (
			.hard_decision         (hard_decision[row_pe_id]),
			.vnu0_v2c              (vnuOut_v2c[row_pe_id][(0+1)*QUAN_SIZE-1:0*QUAN_SIZE]),
			.vnu1_v2c              (vnuOut_v2c[row_pe_id][(1+1)*QUAN_SIZE-1:1*QUAN_SIZE]),
			.vnu2_v2c              (vnuOut_v2c[row_pe_id][(2+1)*QUAN_SIZE-1:2*QUAN_SIZE]),
			.vnu3_v2c              (vnuOut_v2c[row_pe_id][(3+1)*QUAN_SIZE-1:3*QUAN_SIZE]),
			.vnu4_v2c              (vnuOut_v2c[row_pe_id][(4+1)*QUAN_SIZE-1:4*QUAN_SIZE]),
			.vnu5_v2c              (vnuOut_v2c[row_pe_id][(5+1)*QUAN_SIZE-1:5*QUAN_SIZE]),
			.vnu6_v2c              (vnuOut_v2c[row_pe_id][(6+1)*QUAN_SIZE-1:6*QUAN_SIZE]),
			.vnu7_v2c              (vnuOut_v2c[row_pe_id][(7+1)*QUAN_SIZE-1:7*QUAN_SIZE]),
			.vnu8_v2c              (vnuOut_v2c[row_pe_id][(8+1)*QUAN_SIZE-1:8*QUAN_SIZE]),
			.vnu9_v2c              (vnuOut_v2c[row_pe_id][(9+1)*QUAN_SIZE-1:9*QUAN_SIZE]),
			.dnu_signExten_gen     (dnu_signExten_gen[row_pe_id]),
			.cnu0_c2v              (cnuOut_c2v[row_pe_id][(0+1)*QUAN_SIZE-1:0*QUAN_SIZE]),
			.cnu1_c2v              (cnuOut_c2v[row_pe_id][(1+1)*QUAN_SIZE-1:1*QUAN_SIZE]),
			.cnu2_c2v              (cnuOut_c2v[row_pe_id][(2+1)*QUAN_SIZE-1:2*QUAN_SIZE]),
			.cnu3_c2v              (cnuOut_c2v[row_pe_id][(3+1)*QUAN_SIZE-1:3*QUAN_SIZE]),
			.cnu4_c2v              (cnuOut_c2v[row_pe_id][(4+1)*QUAN_SIZE-1:4*QUAN_SIZE]),
			.cnu5_c2v              (cnuOut_c2v[row_pe_id][(5+1)*QUAN_SIZE-1:5*QUAN_SIZE]),
			.cnu6_c2v              (cnuOut_c2v[row_pe_id][(6+1)*QUAN_SIZE-1:6*QUAN_SIZE]),
			.cnu7_c2v              (cnuOut_c2v[row_pe_id][(7+1)*QUAN_SIZE-1:7*QUAN_SIZE]),
			.cnu8_c2v              (cnuOut_c2v[row_pe_id][(8+1)*QUAN_SIZE-1:8*QUAN_SIZE]),
			.cnu9_c2v              (cnuOut_c2v[row_pe_id][(9+1)*QUAN_SIZE-1:9*QUAN_SIZE]),

			.cnu_ch_msgIn_0        (ch_to_cnu[row_pe_id][(0+1)*QUAN_SIZE-1:0*QUAN_SIZE]),
			.cnu_ch_msgIn_1        (ch_to_cnu[row_pe_id][(1+1)*QUAN_SIZE-1:1*QUAN_SIZE]),
			.cnu_ch_msgIn_2        (ch_to_cnu[row_pe_id][(2+1)*QUAN_SIZE-1:2*QUAN_SIZE]),
			.cnu_ch_msgIn_3        (ch_to_cnu[row_pe_id][(3+1)*QUAN_SIZE-1:3*QUAN_SIZE]),
			.cnu_ch_msgIn_4        (ch_to_cnu[row_pe_id][(4+1)*QUAN_SIZE-1:4*QUAN_SIZE]),
			.cnu_ch_msgIn_5        (ch_to_cnu[row_pe_id][(5+1)*QUAN_SIZE-1:5*QUAN_SIZE]),
			.cnu_ch_msgIn_6        (ch_to_cnu[row_pe_id][(6+1)*QUAN_SIZE-1:6*QUAN_SIZE]),
			.cnu_ch_msgIn_7        (ch_to_cnu[row_pe_id][(7+1)*QUAN_SIZE-1:7*QUAN_SIZE]),
			.cnu_ch_msgIn_8        (ch_to_cnu[row_pe_id][(8+1)*QUAN_SIZE-1:8*QUAN_SIZE]),
			.cnu_ch_msgIn_9        (ch_to_cnu[row_pe_id][(9+1)*QUAN_SIZE-1:9*QUAN_SIZE]),

			.vnu0_ch_msgIn         (ch_to_vnu[row_pe_id][(0+1)*QUAN_SIZE-1:0*QUAN_SIZE]),
			.vnu1_ch_msgIn         (ch_to_vnu[row_pe_id][(1+1)*QUAN_SIZE-1:1*QUAN_SIZE]),
			.vnu2_ch_msgIn         (ch_to_vnu[row_pe_id][(2+1)*QUAN_SIZE-1:2*QUAN_SIZE]),
			.vnu3_ch_msgIn         (ch_to_vnu[row_pe_id][(3+1)*QUAN_SIZE-1:3*QUAN_SIZE]),
			.vnu4_ch_msgIn         (ch_to_vnu[row_pe_id][(4+1)*QUAN_SIZE-1:4*QUAN_SIZE]),
			.vnu5_ch_msgIn         (ch_to_vnu[row_pe_id][(5+1)*QUAN_SIZE-1:5*QUAN_SIZE]),
			.vnu6_ch_msgIn         (ch_to_vnu[row_pe_id][(6+1)*QUAN_SIZE-1:6*QUAN_SIZE]),
			.vnu7_ch_msgIn         (ch_to_vnu[row_pe_id][(7+1)*QUAN_SIZE-1:7*QUAN_SIZE]),
			.vnu8_ch_msgIn         (ch_to_vnu[row_pe_id][(8+1)*QUAN_SIZE-1:8*QUAN_SIZE]),
			.vnu9_ch_msgIn         (ch_to_vnu[row_pe_id][(9+1)*QUAN_SIZE-1:9*QUAN_SIZE]),

			.cnuIn_v2c0            (cnuIn_v2c0[row_pe_id][(0+1)*QUAN_SIZE-1:0*QUAN_SIZE]),
			.cnuIn_v2c1            (cnuIn_v2c0[row_pe_id][(1+1)*QUAN_SIZE-1:1*QUAN_SIZE]),
			.cnuIn_v2c2            (cnuIn_v2c0[row_pe_id][(2+1)*QUAN_SIZE-1:2*QUAN_SIZE]),
			.cnuIn_v2c3            (cnuIn_v2c0[row_pe_id][(3+1)*QUAN_SIZE-1:3*QUAN_SIZE]),
			.cnuIn_v2c4            (cnuIn_v2c0[row_pe_id][(4+1)*QUAN_SIZE-1:4*QUAN_SIZE]),
			.cnuIn_v2c5            (cnuIn_v2c0[row_pe_id][(5+1)*QUAN_SIZE-1:5*QUAN_SIZE]),
			.cnuIn_v2c6            (cnuIn_v2c0[row_pe_id][(6+1)*QUAN_SIZE-1:6*QUAN_SIZE]),
			.cnuIn_v2c7            (cnuIn_v2c0[row_pe_id][(7+1)*QUAN_SIZE-1:7*QUAN_SIZE]),
			.cnuIn_v2c8            (cnuIn_v2c0[row_pe_id][(8+1)*QUAN_SIZE-1:8*QUAN_SIZE]),
			.cnuIn_v2c9            (cnuIn_v2c0[row_pe_id][(9+1)*QUAN_SIZE-1:9*QUAN_SIZE]),

			.vnu0_post_c2v0        (vnu_post_c2v0[row_pe_id][(0+1)*QUAN_SIZE-1:0*QUAN_SIZE]),
			.vnu1_post_c2v0        (vnu_post_c2v0[row_pe_id][(1+1)*QUAN_SIZE-1:1*QUAN_SIZE]),
			.vnu2_post_c2v0        (vnu_post_c2v0[row_pe_id][(2+1)*QUAN_SIZE-1:2*QUAN_SIZE]),
			.vnu3_post_c2v0        (vnu_post_c2v0[row_pe_id][(3+1)*QUAN_SIZE-1:3*QUAN_SIZE]),
			.vnu4_post_c2v0        (vnu_post_c2v0[row_pe_id][(4+1)*QUAN_SIZE-1:4*QUAN_SIZE]),
			.vnu5_post_c2v0        (vnu_post_c2v0[row_pe_id][(5+1)*QUAN_SIZE-1:5*QUAN_SIZE]),
			.vnu6_post_c2v0        (vnu_post_c2v0[row_pe_id][(6+1)*QUAN_SIZE-1:6*QUAN_SIZE]),
			.vnu7_post_c2v0        (vnu_post_c2v0[row_pe_id][(7+1)*QUAN_SIZE-1:7*QUAN_SIZE]),
			.vnu8_post_c2v0        (vnu_post_c2v0[row_pe_id][(8+1)*QUAN_SIZE-1:8*QUAN_SIZE]),
			.vnu9_post_c2v0        (vnu_post_c2v0[row_pe_id][(9+1)*QUAN_SIZE-1:9*QUAN_SIZE]),
			.dnu_signExtenIn       (dnu_signExtenIn[row_pe_id]),
/////////////////////////////////////////////
			.read_clk              (read_clk),
			.vnu_read_addr_offset (vnu_read_addr_offset), // for future expansion of mult-frame feature
			.v2c_src (v2c_src),
			//input wire v2c_latch_en,
			//input wire c2v_latch_en,
			//input wire load,,
			//input wire parallel_en,
			.rstn (decoder_rstn),
			.vnu_page_addr_ram_0 (vnu_page_addr_ram_0[VN_PAGE_ADDR_BW:0]),
			.vnu_page_addr_ram_1 (vnu_page_addr_ram_1[VN_PAGE_ADDR_BW:0]),
			.vnu_page_addr_ram_2 (vnu_page_addr_ram_2[DN_PAGE_ADDR_BW:0]), // the last one is for decision node

			.vnu_ram_write_dataA_0 (vnu_ram_write_dataA_0[VN_ROM_RD_BW-1:0]),
			.vnu_ram_write_dataB_0 (vnu_ram_write_dataB_0[VN_ROM_RD_BW-1:0]),

			.vnu_ram_write_dataA_1 (vnu_ram_write_dataA_1[VN_ROM_RD_BW-1:0]),
			.vnu_ram_write_dataB_1 (vnu_ram_write_dataB_1[VN_ROM_RD_BW-1:0]),

			.vnu_ram_write_dataA_2 (vnu_ram_write_dataA_2[DN_ROM_RD_BW-1:0]),
			.vnu_ram_write_dataB_2 (vnu_ram_write_dataB_2[DN_ROM_RD_BW-1:0]),
			.vnu_ib_ram_we (vnu_ib_ram_we[IB_VNU_DECOMP_funNum:0]),
			.vn_write_clk (vn_write_clk),
			.dn_write_clk (dn_write_clk)
		);
		assign cnuIn_v2c0[row_pe_id] = {mem_to_cnu_sub[9][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[8][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[7][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[6][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[5][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[4][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[3][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[2][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[1][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[0][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE]};
		assign vnu_post_c2v0[row_pe_id] = {mem_to_vnu_sub[9][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[8][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[7][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[6][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[5][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[4][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[3][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[2][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[1][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[0][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE]};
		assign dnu_signExtenIn[row_pe_id] = {dnu_signExten_sub[9][row_pe_id],dnu_signExten_sub[8][row_pe_id],dnu_signExten_sub[7][row_pe_id],dnu_signExten_sub[6][row_pe_id],dnu_signExten_sub[5][row_pe_id],dnu_signExten_sub[4][row_pe_id],dnu_signExten_sub[3][row_pe_id],dnu_signExten_sub[2][row_pe_id],dnu_signExten_sub[1][row_pe_id],dnu_signExten_sub[0][row_pe_id]};
		assign ch_to_cnu[row_pe_id] = {ch_to_cnu_sub[9][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[8][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[7][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[6][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[5][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[4][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[3][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[2][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[1][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[0][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE]};
		assign ch_to_vnu[row_pe_id] = {ch_to_vnu_sub[9][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[8][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[7][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[6][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[5][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[4][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[3][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[2][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[1][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[0][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE]};
	end
endgenerate
assign hard_decision_sub0[CHECK_PARALLELISM-1:0] = {hard_decision[84][0],hard_decision[83][0],hard_decision[82][0],hard_decision[81][0],hard_decision[80][0],hard_decision[79][0],hard_decision[78][0],hard_decision[77][0],hard_decision[76][0],hard_decision[75][0],hard_decision[74][0],hard_decision[73][0],hard_decision[72][0],hard_decision[71][0],hard_decision[70][0],hard_decision[69][0],hard_decision[68][0],hard_decision[67][0],hard_decision[66][0],hard_decision[65][0],hard_decision[64][0],hard_decision[63][0],hard_decision[62][0],hard_decision[61][0],hard_decision[60][0],hard_decision[59][0],hard_decision[58][0],hard_decision[57][0],hard_decision[56][0],hard_decision[55][0],hard_decision[54][0],hard_decision[53][0],hard_decision[52][0],hard_decision[51][0],hard_decision[50][0],hard_decision[49][0],hard_decision[48][0],hard_decision[47][0],hard_decision[46][0],hard_decision[45][0],hard_decision[44][0],hard_decision[43][0],hard_decision[42][0],hard_decision[41][0],hard_decision[40][0],hard_decision[39][0],hard_decision[38][0],hard_decision[37][0],hard_decision[36][0],hard_decision[35][0],hard_decision[34][0],hard_decision[33][0],hard_decision[32][0],hard_decision[31][0],hard_decision[30][0],hard_decision[29][0],hard_decision[28][0],hard_decision[27][0],hard_decision[26][0],hard_decision[25][0],hard_decision[24][0],hard_decision[23][0],hard_decision[22][0],hard_decision[21][0],hard_decision[20][0],hard_decision[19][0],hard_decision[18][0],hard_decision[17][0],hard_decision[16][0],hard_decision[15][0],hard_decision[14][0],hard_decision[13][0],hard_decision[12][0],hard_decision[11][0],hard_decision[10][0],hard_decision[9][0],hard_decision[8][0],hard_decision[7][0],hard_decision[6][0],hard_decision[5][0],hard_decision[4][0],hard_decision[3][0],hard_decision[2][0],hard_decision[1][0],hard_decision[1][0]};
assign hard_decision_sub1[CHECK_PARALLELISM-1:0] = {hard_decision[84][1],hard_decision[83][1],hard_decision[82][1],hard_decision[81][1],hard_decision[80][1],hard_decision[79][1],hard_decision[78][1],hard_decision[77][1],hard_decision[76][1],hard_decision[75][1],hard_decision[74][1],hard_decision[73][1],hard_decision[72][1],hard_decision[71][1],hard_decision[70][1],hard_decision[69][1],hard_decision[68][1],hard_decision[67][1],hard_decision[66][1],hard_decision[65][1],hard_decision[64][1],hard_decision[63][1],hard_decision[62][1],hard_decision[61][1],hard_decision[60][1],hard_decision[59][1],hard_decision[58][1],hard_decision[57][1],hard_decision[56][1],hard_decision[55][1],hard_decision[54][1],hard_decision[53][1],hard_decision[52][1],hard_decision[51][1],hard_decision[50][1],hard_decision[49][1],hard_decision[48][1],hard_decision[47][1],hard_decision[46][1],hard_decision[45][1],hard_decision[44][1],hard_decision[43][1],hard_decision[42][1],hard_decision[41][1],hard_decision[40][1],hard_decision[39][1],hard_decision[38][1],hard_decision[37][1],hard_decision[36][1],hard_decision[35][1],hard_decision[34][1],hard_decision[33][1],hard_decision[32][1],hard_decision[31][1],hard_decision[30][1],hard_decision[29][1],hard_decision[28][1],hard_decision[27][1],hard_decision[26][1],hard_decision[25][1],hard_decision[24][1],hard_decision[23][1],hard_decision[22][1],hard_decision[21][1],hard_decision[20][1],hard_decision[19][1],hard_decision[18][1],hard_decision[17][1],hard_decision[16][1],hard_decision[15][1],hard_decision[14][1],hard_decision[13][1],hard_decision[12][1],hard_decision[11][1],hard_decision[10][1],hard_decision[9][1],hard_decision[8][1],hard_decision[7][1],hard_decision[6][1],hard_decision[5][1],hard_decision[4][1],hard_decision[3][1],hard_decision[2][1],hard_decision[1][1],hard_decision[1][0]};
assign hard_decision_sub2[CHECK_PARALLELISM-1:0] = {hard_decision[84][2],hard_decision[83][2],hard_decision[82][2],hard_decision[81][2],hard_decision[80][2],hard_decision[79][2],hard_decision[78][2],hard_decision[77][2],hard_decision[76][2],hard_decision[75][2],hard_decision[74][2],hard_decision[73][2],hard_decision[72][2],hard_decision[71][2],hard_decision[70][2],hard_decision[69][2],hard_decision[68][2],hard_decision[67][2],hard_decision[66][2],hard_decision[65][2],hard_decision[64][2],hard_decision[63][2],hard_decision[62][2],hard_decision[61][2],hard_decision[60][2],hard_decision[59][2],hard_decision[58][2],hard_decision[57][2],hard_decision[56][2],hard_decision[55][2],hard_decision[54][2],hard_decision[53][2],hard_decision[52][2],hard_decision[51][2],hard_decision[50][2],hard_decision[49][2],hard_decision[48][2],hard_decision[47][2],hard_decision[46][2],hard_decision[45][2],hard_decision[44][2],hard_decision[43][2],hard_decision[42][2],hard_decision[41][2],hard_decision[40][2],hard_decision[39][2],hard_decision[38][2],hard_decision[37][2],hard_decision[36][2],hard_decision[35][2],hard_decision[34][2],hard_decision[33][2],hard_decision[32][2],hard_decision[31][2],hard_decision[30][2],hard_decision[29][2],hard_decision[28][2],hard_decision[27][2],hard_decision[26][2],hard_decision[25][2],hard_decision[24][2],hard_decision[23][2],hard_decision[22][2],hard_decision[21][2],hard_decision[20][2],hard_decision[19][2],hard_decision[18][2],hard_decision[17][2],hard_decision[16][2],hard_decision[15][2],hard_decision[14][2],hard_decision[13][2],hard_decision[12][2],hard_decision[11][2],hard_decision[10][2],hard_decision[9][2],hard_decision[8][2],hard_decision[7][2],hard_decision[6][2],hard_decision[5][2],hard_decision[4][2],hard_decision[3][2],hard_decision[2][2],hard_decision[1][2],hard_decision[1][0]};
assign hard_decision_sub3[CHECK_PARALLELISM-1:0] = {hard_decision[84][3],hard_decision[83][3],hard_decision[82][3],hard_decision[81][3],hard_decision[80][3],hard_decision[79][3],hard_decision[78][3],hard_decision[77][3],hard_decision[76][3],hard_decision[75][3],hard_decision[74][3],hard_decision[73][3],hard_decision[72][3],hard_decision[71][3],hard_decision[70][3],hard_decision[69][3],hard_decision[68][3],hard_decision[67][3],hard_decision[66][3],hard_decision[65][3],hard_decision[64][3],hard_decision[63][3],hard_decision[62][3],hard_decision[61][3],hard_decision[60][3],hard_decision[59][3],hard_decision[58][3],hard_decision[57][3],hard_decision[56][3],hard_decision[55][3],hard_decision[54][3],hard_decision[53][3],hard_decision[52][3],hard_decision[51][3],hard_decision[50][3],hard_decision[49][3],hard_decision[48][3],hard_decision[47][3],hard_decision[46][3],hard_decision[45][3],hard_decision[44][3],hard_decision[43][3],hard_decision[42][3],hard_decision[41][3],hard_decision[40][3],hard_decision[39][3],hard_decision[38][3],hard_decision[37][3],hard_decision[36][3],hard_decision[35][3],hard_decision[34][3],hard_decision[33][3],hard_decision[32][3],hard_decision[31][3],hard_decision[30][3],hard_decision[29][3],hard_decision[28][3],hard_decision[27][3],hard_decision[26][3],hard_decision[25][3],hard_decision[24][3],hard_decision[23][3],hard_decision[22][3],hard_decision[21][3],hard_decision[20][3],hard_decision[19][3],hard_decision[18][3],hard_decision[17][3],hard_decision[16][3],hard_decision[15][3],hard_decision[14][3],hard_decision[13][3],hard_decision[12][3],hard_decision[11][3],hard_decision[10][3],hard_decision[9][3],hard_decision[8][3],hard_decision[7][3],hard_decision[6][3],hard_decision[5][3],hard_decision[4][3],hard_decision[3][3],hard_decision[2][3],hard_decision[1][3],hard_decision[1][0]};
assign hard_decision_sub4[CHECK_PARALLELISM-1:0] = {hard_decision[84][4],hard_decision[83][4],hard_decision[82][4],hard_decision[81][4],hard_decision[80][4],hard_decision[79][4],hard_decision[78][4],hard_decision[77][4],hard_decision[76][4],hard_decision[75][4],hard_decision[74][4],hard_decision[73][4],hard_decision[72][4],hard_decision[71][4],hard_decision[70][4],hard_decision[69][4],hard_decision[68][4],hard_decision[67][4],hard_decision[66][4],hard_decision[65][4],hard_decision[64][4],hard_decision[63][4],hard_decision[62][4],hard_decision[61][4],hard_decision[60][4],hard_decision[59][4],hard_decision[58][4],hard_decision[57][4],hard_decision[56][4],hard_decision[55][4],hard_decision[54][4],hard_decision[53][4],hard_decision[52][4],hard_decision[51][4],hard_decision[50][4],hard_decision[49][4],hard_decision[48][4],hard_decision[47][4],hard_decision[46][4],hard_decision[45][4],hard_decision[44][4],hard_decision[43][4],hard_decision[42][4],hard_decision[41][4],hard_decision[40][4],hard_decision[39][4],hard_decision[38][4],hard_decision[37][4],hard_decision[36][4],hard_decision[35][4],hard_decision[34][4],hard_decision[33][4],hard_decision[32][4],hard_decision[31][4],hard_decision[30][4],hard_decision[29][4],hard_decision[28][4],hard_decision[27][4],hard_decision[26][4],hard_decision[25][4],hard_decision[24][4],hard_decision[23][4],hard_decision[22][4],hard_decision[21][4],hard_decision[20][4],hard_decision[19][4],hard_decision[18][4],hard_decision[17][4],hard_decision[16][4],hard_decision[15][4],hard_decision[14][4],hard_decision[13][4],hard_decision[12][4],hard_decision[11][4],hard_decision[10][4],hard_decision[9][4],hard_decision[8][4],hard_decision[7][4],hard_decision[6][4],hard_decision[5][4],hard_decision[4][4],hard_decision[3][4],hard_decision[2][4],hard_decision[1][4],hard_decision[1][0]};
assign hard_decision_sub5[CHECK_PARALLELISM-1:0] = {hard_decision[84][5],hard_decision[83][5],hard_decision[82][5],hard_decision[81][5],hard_decision[80][5],hard_decision[79][5],hard_decision[78][5],hard_decision[77][5],hard_decision[76][5],hard_decision[75][5],hard_decision[74][5],hard_decision[73][5],hard_decision[72][5],hard_decision[71][5],hard_decision[70][5],hard_decision[69][5],hard_decision[68][5],hard_decision[67][5],hard_decision[66][5],hard_decision[65][5],hard_decision[64][5],hard_decision[63][5],hard_decision[62][5],hard_decision[61][5],hard_decision[60][5],hard_decision[59][5],hard_decision[58][5],hard_decision[57][5],hard_decision[56][5],hard_decision[55][5],hard_decision[54][5],hard_decision[53][5],hard_decision[52][5],hard_decision[51][5],hard_decision[50][5],hard_decision[49][5],hard_decision[48][5],hard_decision[47][5],hard_decision[46][5],hard_decision[45][5],hard_decision[44][5],hard_decision[43][5],hard_decision[42][5],hard_decision[41][5],hard_decision[40][5],hard_decision[39][5],hard_decision[38][5],hard_decision[37][5],hard_decision[36][5],hard_decision[35][5],hard_decision[34][5],hard_decision[33][5],hard_decision[32][5],hard_decision[31][5],hard_decision[30][5],hard_decision[29][5],hard_decision[28][5],hard_decision[27][5],hard_decision[26][5],hard_decision[25][5],hard_decision[24][5],hard_decision[23][5],hard_decision[22][5],hard_decision[21][5],hard_decision[20][5],hard_decision[19][5],hard_decision[18][5],hard_decision[17][5],hard_decision[16][5],hard_decision[15][5],hard_decision[14][5],hard_decision[13][5],hard_decision[12][5],hard_decision[11][5],hard_decision[10][5],hard_decision[9][5],hard_decision[8][5],hard_decision[7][5],hard_decision[6][5],hard_decision[5][5],hard_decision[4][5],hard_decision[3][5],hard_decision[2][5],hard_decision[1][5],hard_decision[1][0]};
assign hard_decision_sub6[CHECK_PARALLELISM-1:0] = {hard_decision[84][6],hard_decision[83][6],hard_decision[82][6],hard_decision[81][6],hard_decision[80][6],hard_decision[79][6],hard_decision[78][6],hard_decision[77][6],hard_decision[76][6],hard_decision[75][6],hard_decision[74][6],hard_decision[73][6],hard_decision[72][6],hard_decision[71][6],hard_decision[70][6],hard_decision[69][6],hard_decision[68][6],hard_decision[67][6],hard_decision[66][6],hard_decision[65][6],hard_decision[64][6],hard_decision[63][6],hard_decision[62][6],hard_decision[61][6],hard_decision[60][6],hard_decision[59][6],hard_decision[58][6],hard_decision[57][6],hard_decision[56][6],hard_decision[55][6],hard_decision[54][6],hard_decision[53][6],hard_decision[52][6],hard_decision[51][6],hard_decision[50][6],hard_decision[49][6],hard_decision[48][6],hard_decision[47][6],hard_decision[46][6],hard_decision[45][6],hard_decision[44][6],hard_decision[43][6],hard_decision[42][6],hard_decision[41][6],hard_decision[40][6],hard_decision[39][6],hard_decision[38][6],hard_decision[37][6],hard_decision[36][6],hard_decision[35][6],hard_decision[34][6],hard_decision[33][6],hard_decision[32][6],hard_decision[31][6],hard_decision[30][6],hard_decision[29][6],hard_decision[28][6],hard_decision[27][6],hard_decision[26][6],hard_decision[25][6],hard_decision[24][6],hard_decision[23][6],hard_decision[22][6],hard_decision[21][6],hard_decision[20][6],hard_decision[19][6],hard_decision[18][6],hard_decision[17][6],hard_decision[16][6],hard_decision[15][6],hard_decision[14][6],hard_decision[13][6],hard_decision[12][6],hard_decision[11][6],hard_decision[10][6],hard_decision[9][6],hard_decision[8][6],hard_decision[7][6],hard_decision[6][6],hard_decision[5][6],hard_decision[4][6],hard_decision[3][6],hard_decision[2][6],hard_decision[1][6],hard_decision[1][0]};
assign hard_decision_sub7[CHECK_PARALLELISM-1:0] = {hard_decision[84][7],hard_decision[83][7],hard_decision[82][7],hard_decision[81][7],hard_decision[80][7],hard_decision[79][7],hard_decision[78][7],hard_decision[77][7],hard_decision[76][7],hard_decision[75][7],hard_decision[74][7],hard_decision[73][7],hard_decision[72][7],hard_decision[71][7],hard_decision[70][7],hard_decision[69][7],hard_decision[68][7],hard_decision[67][7],hard_decision[66][7],hard_decision[65][7],hard_decision[64][7],hard_decision[63][7],hard_decision[62][7],hard_decision[61][7],hard_decision[60][7],hard_decision[59][7],hard_decision[58][7],hard_decision[57][7],hard_decision[56][7],hard_decision[55][7],hard_decision[54][7],hard_decision[53][7],hard_decision[52][7],hard_decision[51][7],hard_decision[50][7],hard_decision[49][7],hard_decision[48][7],hard_decision[47][7],hard_decision[46][7],hard_decision[45][7],hard_decision[44][7],hard_decision[43][7],hard_decision[42][7],hard_decision[41][7],hard_decision[40][7],hard_decision[39][7],hard_decision[38][7],hard_decision[37][7],hard_decision[36][7],hard_decision[35][7],hard_decision[34][7],hard_decision[33][7],hard_decision[32][7],hard_decision[31][7],hard_decision[30][7],hard_decision[29][7],hard_decision[28][7],hard_decision[27][7],hard_decision[26][7],hard_decision[25][7],hard_decision[24][7],hard_decision[23][7],hard_decision[22][7],hard_decision[21][7],hard_decision[20][7],hard_decision[19][7],hard_decision[18][7],hard_decision[17][7],hard_decision[16][7],hard_decision[15][7],hard_decision[14][7],hard_decision[13][7],hard_decision[12][7],hard_decision[11][7],hard_decision[10][7],hard_decision[9][7],hard_decision[8][7],hard_decision[7][7],hard_decision[6][7],hard_decision[5][7],hard_decision[4][7],hard_decision[3][7],hard_decision[2][7],hard_decision[1][7],hard_decision[1][0]};
assign hard_decision_sub8[CHECK_PARALLELISM-1:0] = {hard_decision[84][8],hard_decision[83][8],hard_decision[82][8],hard_decision[81][8],hard_decision[80][8],hard_decision[79][8],hard_decision[78][8],hard_decision[77][8],hard_decision[76][8],hard_decision[75][8],hard_decision[74][8],hard_decision[73][8],hard_decision[72][8],hard_decision[71][8],hard_decision[70][8],hard_decision[69][8],hard_decision[68][8],hard_decision[67][8],hard_decision[66][8],hard_decision[65][8],hard_decision[64][8],hard_decision[63][8],hard_decision[62][8],hard_decision[61][8],hard_decision[60][8],hard_decision[59][8],hard_decision[58][8],hard_decision[57][8],hard_decision[56][8],hard_decision[55][8],hard_decision[54][8],hard_decision[53][8],hard_decision[52][8],hard_decision[51][8],hard_decision[50][8],hard_decision[49][8],hard_decision[48][8],hard_decision[47][8],hard_decision[46][8],hard_decision[45][8],hard_decision[44][8],hard_decision[43][8],hard_decision[42][8],hard_decision[41][8],hard_decision[40][8],hard_decision[39][8],hard_decision[38][8],hard_decision[37][8],hard_decision[36][8],hard_decision[35][8],hard_decision[34][8],hard_decision[33][8],hard_decision[32][8],hard_decision[31][8],hard_decision[30][8],hard_decision[29][8],hard_decision[28][8],hard_decision[27][8],hard_decision[26][8],hard_decision[25][8],hard_decision[24][8],hard_decision[23][8],hard_decision[22][8],hard_decision[21][8],hard_decision[20][8],hard_decision[19][8],hard_decision[18][8],hard_decision[17][8],hard_decision[16][8],hard_decision[15][8],hard_decision[14][8],hard_decision[13][8],hard_decision[12][8],hard_decision[11][8],hard_decision[10][8],hard_decision[9][8],hard_decision[8][8],hard_decision[7][8],hard_decision[6][8],hard_decision[5][8],hard_decision[4][8],hard_decision[3][8],hard_decision[2][8],hard_decision[1][8],hard_decision[1][0]};
assign hard_decision_sub9[CHECK_PARALLELISM-1:0] = {hard_decision[84][9],hard_decision[83][9],hard_decision[82][9],hard_decision[81][9],hard_decision[80][9],hard_decision[79][9],hard_decision[78][9],hard_decision[77][9],hard_decision[76][9],hard_decision[75][9],hard_decision[74][9],hard_decision[73][9],hard_decision[72][9],hard_decision[71][9],hard_decision[70][9],hard_decision[69][9],hard_decision[68][9],hard_decision[67][9],hard_decision[66][9],hard_decision[65][9],hard_decision[64][9],hard_decision[63][9],hard_decision[62][9],hard_decision[61][9],hard_decision[60][9],hard_decision[59][9],hard_decision[58][9],hard_decision[57][9],hard_decision[56][9],hard_decision[55][9],hard_decision[54][9],hard_decision[53][9],hard_decision[52][9],hard_decision[51][9],hard_decision[50][9],hard_decision[49][9],hard_decision[48][9],hard_decision[47][9],hard_decision[46][9],hard_decision[45][9],hard_decision[44][9],hard_decision[43][9],hard_decision[42][9],hard_decision[41][9],hard_decision[40][9],hard_decision[39][9],hard_decision[38][9],hard_decision[37][9],hard_decision[36][9],hard_decision[35][9],hard_decision[34][9],hard_decision[33][9],hard_decision[32][9],hard_decision[31][9],hard_decision[30][9],hard_decision[29][9],hard_decision[28][9],hard_decision[27][9],hard_decision[26][9],hard_decision[25][9],hard_decision[24][9],hard_decision[23][9],hard_decision[22][9],hard_decision[21][9],hard_decision[20][9],hard_decision[19][9],hard_decision[18][9],hard_decision[17][9],hard_decision[16][9],hard_decision[15][9],hard_decision[14][9],hard_decision[13][9],hard_decision[12][9],hard_decision[11][9],hard_decision[10][9],hard_decision[9][9],hard_decision[8][9],hard_decision[7][9],hard_decision[6][9],hard_decision[5][9],hard_decision[4][9],hard_decision[3][9],hard_decision[2][9],hard_decision[1][9],hard_decision[1][0]};
/*-----------------------------------------------------------------------------------------------------------------*/
endmodule