`include "define.vh"
`include "revision_def.vh"
`include "define_sched_5.vh"

module entire_partial_message_passing_wrapper #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 3,
	parameter CHECK_PARALLELISM = 255,
	parameter READ_CLK_RATE  = 100, // 100MHz
	parameter WRITE_CLK_RATE = 200, // 200MHz
	parameter WRITE_CLK_RATIO = WRITE_CLK_RATE/READ_CLK_RATE, // the ratio of write_clk clock rate with respect to clock rate of read_clk, e.g., Ratio = write_clk / read_clk = 200MHz/100MHz = 2

	parameter VN_DEGREE = 3,   // degree of one variable node
	parameter CN_DEGREE = 10, // degree of one check node
	parameter SUBMATRIX_Z = 765,
	parameter IB_ROM_SIZE = 6, // width of one read-out port of RAMB36E1
	parameter IB_ROM_ADDR_WIDTH = 6, // ceil(log2(64-entry)) = 6-bit 
	parameter IB_CNU_DECOMP_funNum = 1, // equivalent to one decomposed IB-LUT depth
	parameter IB_VNU_DECOMP_funNum = VN_DEGREE+1-2,
	parameter IB_DNU_DECOMP_funNum = 1,

	parameter ITER_ADDR_BW = 4,  // bit-width of addressing 10 iterationss
    parameter ITER_ROM_GROUP = 10, // the number of iteration datasets stored in one Group of IB-ROMs
	parameter MAX_ITER = 10,

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
	parameter                          FSM_STATE_NUM = 9,
	parameter  [$clog2(FSM_STATE_NUM)-1:0] INIT_LOAD   = 0,
	parameter  [$clog2(FSM_STATE_NUM)-1:0] MEM_FETCH   = 1,
	parameter  [$clog2(FSM_STATE_NUM)-1:0] VNU_IB_RAM_PEND = 2,
	parameter   [$clog2(FSM_STATE_NUM)-1:0] CNU_PIPE   = 3,
	parameter    [$clog2(FSM_STATE_NUM)-1:0] CNU_OUT   = 4,
	parameter      [$clog2(FSM_STATE_NUM)-1:0] BS_WB   = 5,
	parameter [$clog2(FSM_STATE_NUM)-1:0] PAGE_ALIGN   = 6,
	parameter     [$clog2(FSM_STATE_NUM)-1:0] MEM_WB   = 7,
	parameter [$clog2(FSM_STATE_NUM)-1:0] IDLE 		   = 8,
/*-------------------------------------------------------------------------------------*/
	// VNU FSMs 
	parameter                      VN_PIPELINE_BUBBLE = 1,
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
	parameter                            MEM_RD_LEVEL = 2,
	parameter                           CTRL_FSM_STATE_NUM = 9,
	parameter							WR_FSM_STATE_NUM   = 5,
	parameter   [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_INIT_LOAD   = 0,
	parameter   [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_MEM_FETCH   = 1,
	//parameter   [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_IB_RAM_PEND = 2,
	parameter   [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_VNU_PIPE 	 = 3,
	parameter   [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_VNU_OUT 	 = 4,
	parameter   [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_BS_WB 		 = 5,
	parameter   [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_PAGE_ALIGN  = 6,
	parameter   [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_MEM_WB      = 7,
	parameter   [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_IDLE  	     = 8,
/*-------------------------------------------------------------------------------------*/
	// Parameters related to BS, PA and MEM
	parameter RAM_DEPTH = 1024,
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH),
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1),
	//parameter shift_factor_0 = CHECK_PARALLELISM-24,
	//parameter shift_factor_1 = CHECK_PARALLELISM-39,
	//parameter shift_factor_2 = CHECK_PARALLELISM-63,
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,
`ifdef SCHED_4_6
	parameter C2V_MEM_ADDR_BASE = 0,
	parameter V2C_MEM_ADDR_BASE = ROW_CHUNK_NUM,
	parameter V2C_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter C2V_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter BS_PIPELINE_LEVEL = 2,
/*-------------------------------------------------------------------------------------*/
	// Parameter for Channel Buffers
	parameter CH_INIT_LOAD_LEVEL = 5, // $ceil(ROW_CHUNK_NUM/WRITE_CLK_RATIO),
	parameter CH_RAM_WB_ADDR_BASE_1_0 = ROW_CHUNK_NUM,
	parameter CH_RAM_WB_ADDR_BASE_1_1 = ROW_CHUNK_NUM*2,
	parameter CH_FETCH_LATENCY = 5,
	parameter CNU_INIT_FETCH_LATENCY = 4,
	parameter CH_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter CH_MSG_NUM = CHECK_PARALLELISM*CN_DEGREE,
	// Parameters of Channel RAM
	parameter CH_RAM_DEPTH = ROW_CHUNK_NUM*LAYER_NUM,
	parameter CH_RAM_ADDR_WIDTH = $clog2(CH_RAM_DEPTH),
/*-------------------------------------------------------------------------------------*/
	// Parameters for DNU Sign Extension related Control Signals
	parameter SIGN_EXTEN_FF_TO_BS = 10, // 10 clock cycles between latch of VNU.F1.SignExtenOut and input of DNU.SignExtenIn.BS
	parameter PA_TO_DNU_DELAY = 4, // 4 clock cycles between output of PA and input of DNUs 
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
`endif
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH)
) (
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub0,
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub1,
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub2,
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub3,
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub4,
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub5,
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub6,
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub7,
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub8,
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub9,

	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub0,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub1,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub2,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub3,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub4,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub5,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub6,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub7,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub8,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub9,

	output wire [CH_DATA_WIDTH-1:0] ch_to_cnu_sub0,
	output wire [CH_DATA_WIDTH-1:0] ch_to_cnu_sub1,
	output wire [CH_DATA_WIDTH-1:0] ch_to_cnu_sub2,
	output wire [CH_DATA_WIDTH-1:0] ch_to_cnu_sub3,
	output wire [CH_DATA_WIDTH-1:0] ch_to_cnu_sub4,
	output wire [CH_DATA_WIDTH-1:0] ch_to_cnu_sub5,
	output wire [CH_DATA_WIDTH-1:0] ch_to_cnu_sub6,
	output wire [CH_DATA_WIDTH-1:0] ch_to_cnu_sub7,
	output wire [CH_DATA_WIDTH-1:0] ch_to_cnu_sub8,
	output wire [CH_DATA_WIDTH-1:0] ch_to_cnu_sub9,

	output wire [CH_DATA_WIDTH-1:0] ch_to_vnu_sub0,
	output wire [CH_DATA_WIDTH-1:0] ch_to_vnu_sub1,
	output wire [CH_DATA_WIDTH-1:0] ch_to_vnu_sub2,
	output wire [CH_DATA_WIDTH-1:0] ch_to_vnu_sub3,
	output wire [CH_DATA_WIDTH-1:0] ch_to_vnu_sub4,
	output wire [CH_DATA_WIDTH-1:0] ch_to_vnu_sub5,
	output wire [CH_DATA_WIDTH-1:0] ch_to_vnu_sub6,
	output wire [CH_DATA_WIDTH-1:0] ch_to_vnu_sub7,
	output wire [CH_DATA_WIDTH-1:0] ch_to_vnu_sub8,
	output wire [CH_DATA_WIDTH-1:0] ch_to_vnu_sub9,

	output wire [CHECK_PARALLELISM-1:0] dnu_signExten_sub0,
	output wire [CHECK_PARALLELISM-1:0] dnu_signExten_sub1,
	output wire [CHECK_PARALLELISM-1:0] dnu_signExten_sub2,
	output wire [CHECK_PARALLELISM-1:0] dnu_signExten_sub3,
	output wire [CHECK_PARALLELISM-1:0] dnu_signExten_sub4,
	output wire [CHECK_PARALLELISM-1:0] dnu_signExten_sub5,
	output wire [CHECK_PARALLELISM-1:0] dnu_signExten_sub6,
	output wire [CHECK_PARALLELISM-1:0] dnu_signExten_sub7,
	output wire [CHECK_PARALLELISM-1:0] dnu_signExten_sub8,
	output wire [CHECK_PARALLELISM-1:0] dnu_signExten_sub9,	
/*-----------------------------------------------------*/
	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in_sub0,
	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in_sub1,
	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in_sub2,
	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in_sub3,
	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in_sub4,
	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in_sub5,
	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in_sub6,
	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in_sub7,
	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in_sub8,
	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in_sub9,

	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in_sub0,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in_sub1,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in_sub2,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in_sub3,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in_sub4,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in_sub5,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in_sub6,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in_sub7,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in_sub8,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in_sub9,

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
	
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit_sub0,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit_sub1,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit_sub2,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit_sub3,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit_sub4,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit_sub5,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit_sub6,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit_sub7,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit_sub8,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit_sub9,

	// control signals
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
	input wire [2:0] vnu_bs_bit0_src, // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message; '2': rotate_en of last VNU decomposition level (for 2nd segment read_addr of upcoming DNU)
	input wire c2v_mem_we,
	input wire v2c_mem_we,
	input wire [LAYER_NUM-1:0] v2c_layer_cnt, // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
	input wire [LAYER_NUM-1:0] signExten_layer_cnt,
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,
	input wire [`ROW_SPLIT_FACTOR-1:0] cnu_sub_row_status,
	input wire [`ROW_SPLIT_FACTOR-1:0] vnu_sub_row_status,
	input wire iter_termination,

	input wire read_clk,
	input wire write_clk,
	input wire ch_ram_rd_clk,
	input wire ch_ram_wr_clk,
	input wire rstn
);

wire [CH_DATA_WIDTH-1:0] ch_to_bs_sub [0:CHECK_PARALLELISM-1];
/*-------------------------------------------------------------------------------------*/
// Message Passing Instantiation of Submatrix_1 consisting of BS, PA and MEM
	msg_pass_submatrix_1_3_5_7_9_unit #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.SUBMATRIX_Z (SUBMATRIX_Z), // 765
			.VN_DEGREE(VN_DEGREE),
			.RAM_DEPTH(RAM_DEPTH),
			.RAM_ADDR_BITWIDTH(RAM_ADDR_BITWIDTH),
			.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR),
			.shift_factor_0(shift_factor_1_0),
			.shift_factor_1(shift_factor_1_1),
			.shift_factor_2(shift_factor_1_2),
			.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
			.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
			.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
`ifdef SCHED_4_6			
			.C2V_MEM_ADDR_BASE(C2V_MEM_ADDR_BASE),
			.V2C_MEM_ADDR_BASE(V2C_MEM_ADDR_BASE),
			.V2C_DATA_WIDTH(V2C_DATA_WIDTH),
			.C2V_DATA_WIDTH(C2V_DATA_WIDTH),

			// Parameter for Channel Buffers
			.CH_INIT_LOAD_LEVEL      (CH_INIT_LOAD_LEVEL     ), // 5, // $ceil(ROW_CHUNK_NUM/WRITE_CLK_RATIO),
			.CH_RAM_WB_ADDR_BASE_1_0 (CH_RAM_WB_ADDR_BASE_1_0), // ROW_CHUNK_NUM,
			.CH_RAM_WB_ADDR_BASE_1_1 (CH_RAM_WB_ADDR_BASE_1_1), // ROW_CHUNK_NUM*2,
			.CH_FETCH_LATENCY        (CH_FETCH_LATENCY       ), // 2,
			.CNU_INIT_FETCH_LATENCY  (CNU_INIT_FETCH_LATENCY ), // 1,
			.CH_DATA_WIDTH (CH_DATA_WIDTH), // CHECK_PARALLELISM*QUAN_SIZE,
			.CH_MSG_NUM    (CH_MSG_NUM   ), // CHECK_PARALLELISM*CN_DEGREE,
			// Parameters of Channel RAM
			.CH_RAM_DEPTH      (CH_RAM_DEPTH     ), // ROW_CHUNK_NUM*LAYER_NUM,
			.CH_RAM_ADDR_WIDTH (CH_RAM_ADDR_WIDTH), // $clog2(CH_RAM_DEPTH),
			// Parameters of Sign Extenstion for DNUs
			.PA_TO_DNU_DELAY (PA_TO_DNU_DELAY), // 4 clock cycles
			.SIGN_EXTEN_FF_TO_BS (SIGN_EXTEN_FF_TO_BS), // 10 clock cycles
`endif
			.DEPTH(DEPTH),
			.DATA_WIDTH(DATA_WIDTH),
			.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
			.ADDR_WIDTH(ADDR_WIDTH),
			.START_PAGE_1_0(START_PAGE_1_0),
			.START_PAGE_1_1(START_PAGE_1_1),
			.START_PAGE_1_2(START_PAGE_1_2)
		) inst_msg_pass_submatrix_1_3_5_7_9_unit (
			.mem_to_cnu         (mem_to_cnu_sub1),
			.mem_to_vnu         (mem_to_vnu_sub1),
			.ch_to_cnu 			(ch_to_cnu_sub1 ),
			.ch_to_vnu 			(ch_to_vnu_sub1 ),
			.ch_to_bs           (ch_to_bs_sub[1]),
			.dnu_signExten 		(dnu_signExten_sub1),
			.c2v_bs_in          (c2v_bs_in_sub1 ),
			.v2c_bs_in          (v2c_bs_in_sub1 ),
			.ch_bs_in   		(ch_to_bs_sub[1]), //(ch_bs_in_sub1),
			.coded_block 		(coded_block_sub1),
			.dnu_inRotate_bit (dnu_inRotate_bit_sub1),
			.vnu_bs_bit0_src (vnu_bs_bit0_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message; '2': rotate_en of last VNU decomposition level (for 2nd segment read_addr of upcoming DNU)

			.vnu_bs_src 		(vnu_bs_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message
			.c2v_bs_en          (c2v_bs_en),
			.v2c_bs_en          (v2c_bs_en),
			.ch_bs_en			(ch_bs_en),
			/*------------------------------*/
			// Control signals associative with message passing of channel buffer and DNU.SignExtension
			.ch_ram_init_we       (ch_ram_init_we      ),
			.ch_ram_wb            (ch_ram_wb           ),
			.ch_ram_fetch         (ch_ram_fetch        ),
			.layer_finish	       (layer_finish        ),
			.v2c_outRotate_reg_we (v2c_outRotate_reg_we),
			.v2c_outRotate_reg_we_flush (v2c_outRotate_reg_we_flush),
			.dnu_inRotate_bs_en   (dnu_inRotate_bs_en  ),
			.dnu_inRotate_wb      (dnu_inRotate_wb     ),
			.dnu_signExten_ram_fetch  (dnu_signExten_ram_fetch ),
			/*------------------------------*/
			// 1) to indicate the current status of message passing of VNUs, in order to synchronise the C2V MEM's read/write address
			// 2) to indicate the current status of message passing of CNUs, in order to synchronise the V2C MEM's read/write address
			.c2v_mem_fetch (c2v_mem_fetch), 
			.v2c_mem_fetch (v2c_mem_fetch), 
			/*------------------------------*/		

			.c2v_mem_we         (c2v_mem_we),
			.v2c_mem_we         (v2c_mem_we),
			.v2c_layer_cnt      (v2c_layer_cnt),
			.signExten_layer_cnt(signExten_layer_cnt),
			.c2v_last_row_chunk (c2v_last_row_chunk),
			.v2c_last_row_chunk (v2c_last_row_chunk),
			.c2v_row_chunk_cnt  (c2v_row_chunk_cnt),
			.v2c_row_chunk_cnt  (v2c_row_chunk_cnt),
			.iter_termination (iter_termination),
			.read_clk (read_clk),
			.write_clk (write_clk),
			.ch_ram_rd_clk (ch_ram_rd_clk),
			.ch_ram_wr_clk (ch_ram_wr_clk),			
			.rstn               (rstn)
		);
/*-------------------------------------------------------------------------------------*/
endmodule

module msg_pass_submatrix_1_3_5_7_9_unit #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 3,
	parameter CHECK_PARALLELISM = 255,
	parameter VN_DEGREE = 3,
	parameter CN_DEGREE = 10,  
	parameter SUBMATRIX_Z = 765,
/*-------------------------------------------------------------------------------------*/
	// Parameters related to BS, PA and MEM
	parameter RAM_DEPTH = 1024,
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH),
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1),
	parameter shift_factor_0 = CHECK_PARALLELISM-24,
	parameter shift_factor_1 = CHECK_PARALLELISM-39,
	parameter shift_factor_2 = 63,

`ifdef SCHED_4_6
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,
	parameter C2V_MEM_ADDR_BASE = 0,
	parameter V2C_MEM_ADDR_BASE = ROW_CHUNK_NUM,
	parameter V2C_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter C2V_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
/*-------------------------------------------------------------------------------------*/
	// Parameter for Channel Buffers
	parameter CH_INIT_LOAD_LEVEL = 5, // $ceil(ROW_CHUNK_NUM/WRITE_CLK_RATIO),
	parameter CH_RAM_WB_ADDR_BASE_1_0 = ROW_CHUNK_NUM,
	parameter CH_RAM_WB_ADDR_BASE_1_1 = ROW_CHUNK_NUM*2,
	parameter CH_FETCH_LATENCY = 4,
	parameter CNU_INIT_FETCH_LATENCY = 1,
	parameter CH_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter CH_MSG_NUM = CHECK_PARALLELISM*CN_DEGREE,
	// Parameters of Channel RAM
	parameter CH_RAM_DEPTH = ROW_CHUNK_NUM*LAYER_NUM,
	parameter CH_RAM_ADDR_WIDTH = $clog2(CH_RAM_DEPTH),
/*-------------------------------------------------------------------------------------*/
	// Parameters for DNU Sign Extension related Control Signals
	parameter SIGN_EXTEN_FF_TO_BS = 10, // 10 clock cycles between latch of VNU.F1.SignExtenOut and input of DNU.SignExtenIn.BS
	parameter PA_TO_DNU_DELAY = 4, // 4 clock cycles between output of PA and input of DNUs 
/*-------------------------------------------------------------------------------------*/
`endif
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH),
	/*obsolete*/parameter START_PAGE_1_0 = 2, // starting page address of layer 0 of submatrix_1
	/*obsolete*/parameter START_PAGE_1_1 = 8, // starting page address of layer 1 of submatrix_1
	/*obsolete*/parameter START_PAGE_1_2 = 1  // starting page address of layer 2 of submatrix_1
) (
	output wire [V2C_DATA_WIDTH-1:0] mem_to_cnu,
	output wire [C2V_DATA_WIDTH-1:0] mem_to_vnu,
	output wire [CH_DATA_WIDTH-1:0] ch_to_cnu,
	output wire [CH_DATA_WIDTH-1:0] ch_to_vnu,
	output wire [CH_DATA_WIDTH-1:0] ch_to_bs,
	output wire [CHECK_PARALLELISM-1:0] dnu_signExten,

	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit,
	
	// Segment of codewords link to the underlying submatrix
	input wire [SUBMATRIX_Z*QUAN_SIZE-1:0] coded_block,

	// control signals
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
	input wire vnu_bs_src, // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message
	input wire [2:0] vnu_bs_bit0_src, // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message; '2': rotate_en of last VNU decomposition level (for 2nd segment read_addr of upcoming DNU)
	input wire c2v_mem_we,
	input wire v2c_mem_we,
	input wire [LAYER_NUM-1:0] v2c_layer_cnt, // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
	input wire [LAYER_NUM-1:0] signExten_layer_cnt,
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,
	input wire [`ROW_SPLIT_FACTOR-1:0] cnu_sub_row_status,
	input wire [`ROW_SPLIT_FACTOR-1:0] vnu_sub_row_status,
	input wire iter_termination,

	input wire read_clk,
	input wire write_clk,
	input wire ch_ram_rd_clk,
	input wire ch_ram_wr_clk,
	input wire rstn
);

/*-------------------------------------------------------------------------------------------------------------------------*/
// Instantiation of BS, PAs and MEMs
wire [QUAN_SIZE-1:0] vnu_msg_in [0:CHECK_PARALLELISM-1];
wire [QUAN_SIZE-1:0] cnu_msg_in [0:CHECK_PARALLELISM-1];
wire [CH_DATA_WIDTH-1:0] pa_to_ch_ram;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_2;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_2;
reg [BITWIDTH_SHIFT_FACTOR-1:0] ch_ramRD_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] ch_ramRD_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] ch_ramRD_shift_factor_cur_2;
wire [BITWIDTH_SHIFT_FACTOR-1:0] vnu_shift_factorIn;
wire [BITWIDTH_SHIFT_FACTOR-1:0] dnu_inRotate_shift_factor; // a constant, because only needed at last layer

localparam BS_SELECTOR_BITWIDTH = $clog2(CHECK_PARALLELISM);
wire [BS_SELECTOR_BITWIDTH-1:0]  cnu_left_sel;
wire [BS_SELECTOR_BITWIDTH-1:0]  cnu_right_sel;
wire [CHECK_PARALLELISM-2:0] cnu_merge_sel;
wire [BS_SELECTOR_BITWIDTH-1:0]  vnu_left_sel;
wire [BS_SELECTOR_BITWIDTH-1:0]  vnu_right_sel;
wire [CHECK_PARALLELISM-2:0] vnu_merge_sel;
wire [CHECK_PARALLELISM-1:0] cnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] vnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] ch_bs_in_bit [0:QUAN_SIZE-1];
genvar bit_index;
generate
	for(bit_index=0;bit_index<QUAN_SIZE;bit_index=bit_index+1) begin : extrinsic_msg_bs_in_inst
		assign cnu_bs_in_bit[bit_index] = {c2v_bs_in[QUAN_SIZE*254+bit_index],c2v_bs_in[QUAN_SIZE*253+bit_index],c2v_bs_in[QUAN_SIZE*252+bit_index],c2v_bs_in[QUAN_SIZE*251+bit_index],c2v_bs_in[QUAN_SIZE*250+bit_index],c2v_bs_in[QUAN_SIZE*249+bit_index],c2v_bs_in[QUAN_SIZE*248+bit_index],c2v_bs_in[QUAN_SIZE*247+bit_index],c2v_bs_in[QUAN_SIZE*246+bit_index],c2v_bs_in[QUAN_SIZE*245+bit_index],c2v_bs_in[QUAN_SIZE*244+bit_index],c2v_bs_in[QUAN_SIZE*243+bit_index],c2v_bs_in[QUAN_SIZE*242+bit_index],c2v_bs_in[QUAN_SIZE*241+bit_index],c2v_bs_in[QUAN_SIZE*240+bit_index],c2v_bs_in[QUAN_SIZE*239+bit_index],c2v_bs_in[QUAN_SIZE*238+bit_index],c2v_bs_in[QUAN_SIZE*237+bit_index],c2v_bs_in[QUAN_SIZE*236+bit_index],c2v_bs_in[QUAN_SIZE*235+bit_index],c2v_bs_in[QUAN_SIZE*234+bit_index],c2v_bs_in[QUAN_SIZE*233+bit_index],c2v_bs_in[QUAN_SIZE*232+bit_index],c2v_bs_in[QUAN_SIZE*231+bit_index],c2v_bs_in[QUAN_SIZE*230+bit_index],c2v_bs_in[QUAN_SIZE*229+bit_index],c2v_bs_in[QUAN_SIZE*228+bit_index],c2v_bs_in[QUAN_SIZE*227+bit_index],c2v_bs_in[QUAN_SIZE*226+bit_index],c2v_bs_in[QUAN_SIZE*225+bit_index],c2v_bs_in[QUAN_SIZE*224+bit_index],c2v_bs_in[QUAN_SIZE*223+bit_index],c2v_bs_in[QUAN_SIZE*222+bit_index],c2v_bs_in[QUAN_SIZE*221+bit_index],c2v_bs_in[QUAN_SIZE*220+bit_index],c2v_bs_in[QUAN_SIZE*219+bit_index],c2v_bs_in[QUAN_SIZE*218+bit_index],c2v_bs_in[QUAN_SIZE*217+bit_index],c2v_bs_in[QUAN_SIZE*216+bit_index],c2v_bs_in[QUAN_SIZE*215+bit_index],c2v_bs_in[QUAN_SIZE*214+bit_index],c2v_bs_in[QUAN_SIZE*213+bit_index],c2v_bs_in[QUAN_SIZE*212+bit_index],c2v_bs_in[QUAN_SIZE*211+bit_index],c2v_bs_in[QUAN_SIZE*210+bit_index],c2v_bs_in[QUAN_SIZE*209+bit_index],c2v_bs_in[QUAN_SIZE*208+bit_index],c2v_bs_in[QUAN_SIZE*207+bit_index],c2v_bs_in[QUAN_SIZE*206+bit_index],c2v_bs_in[QUAN_SIZE*205+bit_index],c2v_bs_in[QUAN_SIZE*204+bit_index],c2v_bs_in[QUAN_SIZE*203+bit_index],c2v_bs_in[QUAN_SIZE*202+bit_index],c2v_bs_in[QUAN_SIZE*201+bit_index],c2v_bs_in[QUAN_SIZE*200+bit_index],c2v_bs_in[QUAN_SIZE*199+bit_index],c2v_bs_in[QUAN_SIZE*198+bit_index],c2v_bs_in[QUAN_SIZE*197+bit_index],c2v_bs_in[QUAN_SIZE*196+bit_index],c2v_bs_in[QUAN_SIZE*195+bit_index],c2v_bs_in[QUAN_SIZE*194+bit_index],c2v_bs_in[QUAN_SIZE*193+bit_index],c2v_bs_in[QUAN_SIZE*192+bit_index],c2v_bs_in[QUAN_SIZE*191+bit_index],c2v_bs_in[QUAN_SIZE*190+bit_index],c2v_bs_in[QUAN_SIZE*189+bit_index],c2v_bs_in[QUAN_SIZE*188+bit_index],c2v_bs_in[QUAN_SIZE*187+bit_index],c2v_bs_in[QUAN_SIZE*186+bit_index],c2v_bs_in[QUAN_SIZE*185+bit_index],c2v_bs_in[QUAN_SIZE*184+bit_index],c2v_bs_in[QUAN_SIZE*183+bit_index],c2v_bs_in[QUAN_SIZE*182+bit_index],c2v_bs_in[QUAN_SIZE*181+bit_index],c2v_bs_in[QUAN_SIZE*180+bit_index],c2v_bs_in[QUAN_SIZE*179+bit_index],c2v_bs_in[QUAN_SIZE*178+bit_index],c2v_bs_in[QUAN_SIZE*177+bit_index],c2v_bs_in[QUAN_SIZE*176+bit_index],c2v_bs_in[QUAN_SIZE*175+bit_index],c2v_bs_in[QUAN_SIZE*174+bit_index],c2v_bs_in[QUAN_SIZE*173+bit_index],c2v_bs_in[QUAN_SIZE*172+bit_index],c2v_bs_in[QUAN_SIZE*171+bit_index],c2v_bs_in[QUAN_SIZE*170+bit_index],c2v_bs_in[QUAN_SIZE*169+bit_index],c2v_bs_in[QUAN_SIZE*168+bit_index],c2v_bs_in[QUAN_SIZE*167+bit_index],c2v_bs_in[QUAN_SIZE*166+bit_index],c2v_bs_in[QUAN_SIZE*165+bit_index],c2v_bs_in[QUAN_SIZE*164+bit_index],c2v_bs_in[QUAN_SIZE*163+bit_index],c2v_bs_in[QUAN_SIZE*162+bit_index],c2v_bs_in[QUAN_SIZE*161+bit_index],c2v_bs_in[QUAN_SIZE*160+bit_index],c2v_bs_in[QUAN_SIZE*159+bit_index],c2v_bs_in[QUAN_SIZE*158+bit_index],c2v_bs_in[QUAN_SIZE*157+bit_index],c2v_bs_in[QUAN_SIZE*156+bit_index],c2v_bs_in[QUAN_SIZE*155+bit_index],c2v_bs_in[QUAN_SIZE*154+bit_index],c2v_bs_in[QUAN_SIZE*153+bit_index],c2v_bs_in[QUAN_SIZE*152+bit_index],c2v_bs_in[QUAN_SIZE*151+bit_index],c2v_bs_in[QUAN_SIZE*150+bit_index],c2v_bs_in[QUAN_SIZE*149+bit_index],c2v_bs_in[QUAN_SIZE*148+bit_index],c2v_bs_in[QUAN_SIZE*147+bit_index],c2v_bs_in[QUAN_SIZE*146+bit_index],c2v_bs_in[QUAN_SIZE*145+bit_index],c2v_bs_in[QUAN_SIZE*144+bit_index],c2v_bs_in[QUAN_SIZE*143+bit_index],c2v_bs_in[QUAN_SIZE*142+bit_index],c2v_bs_in[QUAN_SIZE*141+bit_index],c2v_bs_in[QUAN_SIZE*140+bit_index],c2v_bs_in[QUAN_SIZE*139+bit_index],c2v_bs_in[QUAN_SIZE*138+bit_index],c2v_bs_in[QUAN_SIZE*137+bit_index],c2v_bs_in[QUAN_SIZE*136+bit_index],c2v_bs_in[QUAN_SIZE*135+bit_index],c2v_bs_in[QUAN_SIZE*134+bit_index],c2v_bs_in[QUAN_SIZE*133+bit_index],c2v_bs_in[QUAN_SIZE*132+bit_index],c2v_bs_in[QUAN_SIZE*131+bit_index],c2v_bs_in[QUAN_SIZE*130+bit_index],c2v_bs_in[QUAN_SIZE*129+bit_index],c2v_bs_in[QUAN_SIZE*128+bit_index],c2v_bs_in[QUAN_SIZE*127+bit_index],c2v_bs_in[QUAN_SIZE*126+bit_index],c2v_bs_in[QUAN_SIZE*125+bit_index],c2v_bs_in[QUAN_SIZE*124+bit_index],c2v_bs_in[QUAN_SIZE*123+bit_index],c2v_bs_in[QUAN_SIZE*122+bit_index],c2v_bs_in[QUAN_SIZE*121+bit_index],c2v_bs_in[QUAN_SIZE*120+bit_index],c2v_bs_in[QUAN_SIZE*119+bit_index],c2v_bs_in[QUAN_SIZE*118+bit_index],c2v_bs_in[QUAN_SIZE*117+bit_index],c2v_bs_in[QUAN_SIZE*116+bit_index],c2v_bs_in[QUAN_SIZE*115+bit_index],c2v_bs_in[QUAN_SIZE*114+bit_index],c2v_bs_in[QUAN_SIZE*113+bit_index],c2v_bs_in[QUAN_SIZE*112+bit_index],c2v_bs_in[QUAN_SIZE*111+bit_index],c2v_bs_in[QUAN_SIZE*110+bit_index],c2v_bs_in[QUAN_SIZE*109+bit_index],c2v_bs_in[QUAN_SIZE*108+bit_index],c2v_bs_in[QUAN_SIZE*107+bit_index],c2v_bs_in[QUAN_SIZE*106+bit_index],c2v_bs_in[QUAN_SIZE*105+bit_index],c2v_bs_in[QUAN_SIZE*104+bit_index],c2v_bs_in[QUAN_SIZE*103+bit_index],c2v_bs_in[QUAN_SIZE*102+bit_index],c2v_bs_in[QUAN_SIZE*101+bit_index],c2v_bs_in[QUAN_SIZE*100+bit_index],c2v_bs_in[QUAN_SIZE*99+bit_index],c2v_bs_in[QUAN_SIZE*98+bit_index],c2v_bs_in[QUAN_SIZE*97+bit_index],c2v_bs_in[QUAN_SIZE*96+bit_index],c2v_bs_in[QUAN_SIZE*95+bit_index],c2v_bs_in[QUAN_SIZE*94+bit_index],c2v_bs_in[QUAN_SIZE*93+bit_index],c2v_bs_in[QUAN_SIZE*92+bit_index],c2v_bs_in[QUAN_SIZE*91+bit_index],c2v_bs_in[QUAN_SIZE*90+bit_index],c2v_bs_in[QUAN_SIZE*89+bit_index],c2v_bs_in[QUAN_SIZE*88+bit_index],c2v_bs_in[QUAN_SIZE*87+bit_index],c2v_bs_in[QUAN_SIZE*86+bit_index],c2v_bs_in[QUAN_SIZE*85+bit_index],c2v_bs_in[QUAN_SIZE*84+bit_index],c2v_bs_in[QUAN_SIZE*83+bit_index],c2v_bs_in[QUAN_SIZE*82+bit_index],c2v_bs_in[QUAN_SIZE*81+bit_index],c2v_bs_in[QUAN_SIZE*80+bit_index],c2v_bs_in[QUAN_SIZE*79+bit_index],c2v_bs_in[QUAN_SIZE*78+bit_index],c2v_bs_in[QUAN_SIZE*77+bit_index],c2v_bs_in[QUAN_SIZE*76+bit_index],c2v_bs_in[QUAN_SIZE*75+bit_index],c2v_bs_in[QUAN_SIZE*74+bit_index],c2v_bs_in[QUAN_SIZE*73+bit_index],c2v_bs_in[QUAN_SIZE*72+bit_index],c2v_bs_in[QUAN_SIZE*71+bit_index],c2v_bs_in[QUAN_SIZE*70+bit_index],c2v_bs_in[QUAN_SIZE*69+bit_index],c2v_bs_in[QUAN_SIZE*68+bit_index],c2v_bs_in[QUAN_SIZE*67+bit_index],c2v_bs_in[QUAN_SIZE*66+bit_index],c2v_bs_in[QUAN_SIZE*65+bit_index],c2v_bs_in[QUAN_SIZE*64+bit_index],c2v_bs_in[QUAN_SIZE*63+bit_index],c2v_bs_in[QUAN_SIZE*62+bit_index],c2v_bs_in[QUAN_SIZE*61+bit_index],c2v_bs_in[QUAN_SIZE*60+bit_index],c2v_bs_in[QUAN_SIZE*59+bit_index],c2v_bs_in[QUAN_SIZE*58+bit_index],c2v_bs_in[QUAN_SIZE*57+bit_index],c2v_bs_in[QUAN_SIZE*56+bit_index],c2v_bs_in[QUAN_SIZE*55+bit_index],c2v_bs_in[QUAN_SIZE*54+bit_index],c2v_bs_in[QUAN_SIZE*53+bit_index],c2v_bs_in[QUAN_SIZE*52+bit_index],c2v_bs_in[QUAN_SIZE*51+bit_index],c2v_bs_in[QUAN_SIZE*50+bit_index],c2v_bs_in[QUAN_SIZE*49+bit_index],c2v_bs_in[QUAN_SIZE*48+bit_index],c2v_bs_in[QUAN_SIZE*47+bit_index],c2v_bs_in[QUAN_SIZE*46+bit_index],c2v_bs_in[QUAN_SIZE*45+bit_index],c2v_bs_in[QUAN_SIZE*44+bit_index],c2v_bs_in[QUAN_SIZE*43+bit_index],c2v_bs_in[QUAN_SIZE*42+bit_index],c2v_bs_in[QUAN_SIZE*41+bit_index],c2v_bs_in[QUAN_SIZE*40+bit_index],c2v_bs_in[QUAN_SIZE*39+bit_index],c2v_bs_in[QUAN_SIZE*38+bit_index],c2v_bs_in[QUAN_SIZE*37+bit_index],c2v_bs_in[QUAN_SIZE*36+bit_index],c2v_bs_in[QUAN_SIZE*35+bit_index],c2v_bs_in[QUAN_SIZE*34+bit_index],c2v_bs_in[QUAN_SIZE*33+bit_index],c2v_bs_in[QUAN_SIZE*32+bit_index],c2v_bs_in[QUAN_SIZE*31+bit_index],c2v_bs_in[QUAN_SIZE*30+bit_index],c2v_bs_in[QUAN_SIZE*29+bit_index],c2v_bs_in[QUAN_SIZE*28+bit_index],c2v_bs_in[QUAN_SIZE*27+bit_index],c2v_bs_in[QUAN_SIZE*26+bit_index],c2v_bs_in[QUAN_SIZE*25+bit_index],c2v_bs_in[QUAN_SIZE*24+bit_index],c2v_bs_in[QUAN_SIZE*23+bit_index],c2v_bs_in[QUAN_SIZE*22+bit_index],c2v_bs_in[QUAN_SIZE*21+bit_index],c2v_bs_in[QUAN_SIZE*20+bit_index],c2v_bs_in[QUAN_SIZE*19+bit_index],c2v_bs_in[QUAN_SIZE*18+bit_index],c2v_bs_in[QUAN_SIZE*17+bit_index],c2v_bs_in[QUAN_SIZE*16+bit_index],c2v_bs_in[QUAN_SIZE*15+bit_index],c2v_bs_in[QUAN_SIZE*14+bit_index],c2v_bs_in[QUAN_SIZE*13+bit_index],c2v_bs_in[QUAN_SIZE*12+bit_index],c2v_bs_in[QUAN_SIZE*11+bit_index],c2v_bs_in[QUAN_SIZE*10+bit_index],c2v_bs_in[QUAN_SIZE*9+bit_index],c2v_bs_in[QUAN_SIZE*8+bit_index],c2v_bs_in[QUAN_SIZE*7+bit_index],c2v_bs_in[QUAN_SIZE*6+bit_index],c2v_bs_in[QUAN_SIZE*5+bit_index],c2v_bs_in[QUAN_SIZE*4+bit_index],c2v_bs_in[QUAN_SIZE*3+bit_index],c2v_bs_in[QUAN_SIZE*2+bit_index],c2v_bs_in[QUAN_SIZE*1+bit_index],c2v_bs_in[QUAN_SIZE*0+bit_index]};
		assign vnu_bs_in_bit[bit_index] = {v2c_bs_in[QUAN_SIZE*254+bit_index],v2c_bs_in[QUAN_SIZE*253+bit_index],v2c_bs_in[QUAN_SIZE*252+bit_index],v2c_bs_in[QUAN_SIZE*251+bit_index],v2c_bs_in[QUAN_SIZE*250+bit_index],v2c_bs_in[QUAN_SIZE*249+bit_index],v2c_bs_in[QUAN_SIZE*248+bit_index],v2c_bs_in[QUAN_SIZE*247+bit_index],v2c_bs_in[QUAN_SIZE*246+bit_index],v2c_bs_in[QUAN_SIZE*245+bit_index],v2c_bs_in[QUAN_SIZE*244+bit_index],v2c_bs_in[QUAN_SIZE*243+bit_index],v2c_bs_in[QUAN_SIZE*242+bit_index],v2c_bs_in[QUAN_SIZE*241+bit_index],v2c_bs_in[QUAN_SIZE*240+bit_index],v2c_bs_in[QUAN_SIZE*239+bit_index],v2c_bs_in[QUAN_SIZE*238+bit_index],v2c_bs_in[QUAN_SIZE*237+bit_index],v2c_bs_in[QUAN_SIZE*236+bit_index],v2c_bs_in[QUAN_SIZE*235+bit_index],v2c_bs_in[QUAN_SIZE*234+bit_index],v2c_bs_in[QUAN_SIZE*233+bit_index],v2c_bs_in[QUAN_SIZE*232+bit_index],v2c_bs_in[QUAN_SIZE*231+bit_index],v2c_bs_in[QUAN_SIZE*230+bit_index],v2c_bs_in[QUAN_SIZE*229+bit_index],v2c_bs_in[QUAN_SIZE*228+bit_index],v2c_bs_in[QUAN_SIZE*227+bit_index],v2c_bs_in[QUAN_SIZE*226+bit_index],v2c_bs_in[QUAN_SIZE*225+bit_index],v2c_bs_in[QUAN_SIZE*224+bit_index],v2c_bs_in[QUAN_SIZE*223+bit_index],v2c_bs_in[QUAN_SIZE*222+bit_index],v2c_bs_in[QUAN_SIZE*221+bit_index],v2c_bs_in[QUAN_SIZE*220+bit_index],v2c_bs_in[QUAN_SIZE*219+bit_index],v2c_bs_in[QUAN_SIZE*218+bit_index],v2c_bs_in[QUAN_SIZE*217+bit_index],v2c_bs_in[QUAN_SIZE*216+bit_index],v2c_bs_in[QUAN_SIZE*215+bit_index],v2c_bs_in[QUAN_SIZE*214+bit_index],v2c_bs_in[QUAN_SIZE*213+bit_index],v2c_bs_in[QUAN_SIZE*212+bit_index],v2c_bs_in[QUAN_SIZE*211+bit_index],v2c_bs_in[QUAN_SIZE*210+bit_index],v2c_bs_in[QUAN_SIZE*209+bit_index],v2c_bs_in[QUAN_SIZE*208+bit_index],v2c_bs_in[QUAN_SIZE*207+bit_index],v2c_bs_in[QUAN_SIZE*206+bit_index],v2c_bs_in[QUAN_SIZE*205+bit_index],v2c_bs_in[QUAN_SIZE*204+bit_index],v2c_bs_in[QUAN_SIZE*203+bit_index],v2c_bs_in[QUAN_SIZE*202+bit_index],v2c_bs_in[QUAN_SIZE*201+bit_index],v2c_bs_in[QUAN_SIZE*200+bit_index],v2c_bs_in[QUAN_SIZE*199+bit_index],v2c_bs_in[QUAN_SIZE*198+bit_index],v2c_bs_in[QUAN_SIZE*197+bit_index],v2c_bs_in[QUAN_SIZE*196+bit_index],v2c_bs_in[QUAN_SIZE*195+bit_index],v2c_bs_in[QUAN_SIZE*194+bit_index],v2c_bs_in[QUAN_SIZE*193+bit_index],v2c_bs_in[QUAN_SIZE*192+bit_index],v2c_bs_in[QUAN_SIZE*191+bit_index],v2c_bs_in[QUAN_SIZE*190+bit_index],v2c_bs_in[QUAN_SIZE*189+bit_index],v2c_bs_in[QUAN_SIZE*188+bit_index],v2c_bs_in[QUAN_SIZE*187+bit_index],v2c_bs_in[QUAN_SIZE*186+bit_index],v2c_bs_in[QUAN_SIZE*185+bit_index],v2c_bs_in[QUAN_SIZE*184+bit_index],v2c_bs_in[QUAN_SIZE*183+bit_index],v2c_bs_in[QUAN_SIZE*182+bit_index],v2c_bs_in[QUAN_SIZE*181+bit_index],v2c_bs_in[QUAN_SIZE*180+bit_index],v2c_bs_in[QUAN_SIZE*179+bit_index],v2c_bs_in[QUAN_SIZE*178+bit_index],v2c_bs_in[QUAN_SIZE*177+bit_index],v2c_bs_in[QUAN_SIZE*176+bit_index],v2c_bs_in[QUAN_SIZE*175+bit_index],v2c_bs_in[QUAN_SIZE*174+bit_index],v2c_bs_in[QUAN_SIZE*173+bit_index],v2c_bs_in[QUAN_SIZE*172+bit_index],v2c_bs_in[QUAN_SIZE*171+bit_index],v2c_bs_in[QUAN_SIZE*170+bit_index],v2c_bs_in[QUAN_SIZE*169+bit_index],v2c_bs_in[QUAN_SIZE*168+bit_index],v2c_bs_in[QUAN_SIZE*167+bit_index],v2c_bs_in[QUAN_SIZE*166+bit_index],v2c_bs_in[QUAN_SIZE*165+bit_index],v2c_bs_in[QUAN_SIZE*164+bit_index],v2c_bs_in[QUAN_SIZE*163+bit_index],v2c_bs_in[QUAN_SIZE*162+bit_index],v2c_bs_in[QUAN_SIZE*161+bit_index],v2c_bs_in[QUAN_SIZE*160+bit_index],v2c_bs_in[QUAN_SIZE*159+bit_index],v2c_bs_in[QUAN_SIZE*158+bit_index],v2c_bs_in[QUAN_SIZE*157+bit_index],v2c_bs_in[QUAN_SIZE*156+bit_index],v2c_bs_in[QUAN_SIZE*155+bit_index],v2c_bs_in[QUAN_SIZE*154+bit_index],v2c_bs_in[QUAN_SIZE*153+bit_index],v2c_bs_in[QUAN_SIZE*152+bit_index],v2c_bs_in[QUAN_SIZE*151+bit_index],v2c_bs_in[QUAN_SIZE*150+bit_index],v2c_bs_in[QUAN_SIZE*149+bit_index],v2c_bs_in[QUAN_SIZE*148+bit_index],v2c_bs_in[QUAN_SIZE*147+bit_index],v2c_bs_in[QUAN_SIZE*146+bit_index],v2c_bs_in[QUAN_SIZE*145+bit_index],v2c_bs_in[QUAN_SIZE*144+bit_index],v2c_bs_in[QUAN_SIZE*143+bit_index],v2c_bs_in[QUAN_SIZE*142+bit_index],v2c_bs_in[QUAN_SIZE*141+bit_index],v2c_bs_in[QUAN_SIZE*140+bit_index],v2c_bs_in[QUAN_SIZE*139+bit_index],v2c_bs_in[QUAN_SIZE*138+bit_index],v2c_bs_in[QUAN_SIZE*137+bit_index],v2c_bs_in[QUAN_SIZE*136+bit_index],v2c_bs_in[QUAN_SIZE*135+bit_index],v2c_bs_in[QUAN_SIZE*134+bit_index],v2c_bs_in[QUAN_SIZE*133+bit_index],v2c_bs_in[QUAN_SIZE*132+bit_index],v2c_bs_in[QUAN_SIZE*131+bit_index],v2c_bs_in[QUAN_SIZE*130+bit_index],v2c_bs_in[QUAN_SIZE*129+bit_index],v2c_bs_in[QUAN_SIZE*128+bit_index],v2c_bs_in[QUAN_SIZE*127+bit_index],v2c_bs_in[QUAN_SIZE*126+bit_index],v2c_bs_in[QUAN_SIZE*125+bit_index],v2c_bs_in[QUAN_SIZE*124+bit_index],v2c_bs_in[QUAN_SIZE*123+bit_index],v2c_bs_in[QUAN_SIZE*122+bit_index],v2c_bs_in[QUAN_SIZE*121+bit_index],v2c_bs_in[QUAN_SIZE*120+bit_index],v2c_bs_in[QUAN_SIZE*119+bit_index],v2c_bs_in[QUAN_SIZE*118+bit_index],v2c_bs_in[QUAN_SIZE*117+bit_index],v2c_bs_in[QUAN_SIZE*116+bit_index],v2c_bs_in[QUAN_SIZE*115+bit_index],v2c_bs_in[QUAN_SIZE*114+bit_index],v2c_bs_in[QUAN_SIZE*113+bit_index],v2c_bs_in[QUAN_SIZE*112+bit_index],v2c_bs_in[QUAN_SIZE*111+bit_index],v2c_bs_in[QUAN_SIZE*110+bit_index],v2c_bs_in[QUAN_SIZE*109+bit_index],v2c_bs_in[QUAN_SIZE*108+bit_index],v2c_bs_in[QUAN_SIZE*107+bit_index],v2c_bs_in[QUAN_SIZE*106+bit_index],v2c_bs_in[QUAN_SIZE*105+bit_index],v2c_bs_in[QUAN_SIZE*104+bit_index],v2c_bs_in[QUAN_SIZE*103+bit_index],v2c_bs_in[QUAN_SIZE*102+bit_index],v2c_bs_in[QUAN_SIZE*101+bit_index],v2c_bs_in[QUAN_SIZE*100+bit_index],v2c_bs_in[QUAN_SIZE*99+bit_index],v2c_bs_in[QUAN_SIZE*98+bit_index],v2c_bs_in[QUAN_SIZE*97+bit_index],v2c_bs_in[QUAN_SIZE*96+bit_index],v2c_bs_in[QUAN_SIZE*95+bit_index],v2c_bs_in[QUAN_SIZE*94+bit_index],v2c_bs_in[QUAN_SIZE*93+bit_index],v2c_bs_in[QUAN_SIZE*92+bit_index],v2c_bs_in[QUAN_SIZE*91+bit_index],v2c_bs_in[QUAN_SIZE*90+bit_index],v2c_bs_in[QUAN_SIZE*89+bit_index],v2c_bs_in[QUAN_SIZE*88+bit_index],v2c_bs_in[QUAN_SIZE*87+bit_index],v2c_bs_in[QUAN_SIZE*86+bit_index],v2c_bs_in[QUAN_SIZE*85+bit_index],v2c_bs_in[QUAN_SIZE*84+bit_index],v2c_bs_in[QUAN_SIZE*83+bit_index],v2c_bs_in[QUAN_SIZE*82+bit_index],v2c_bs_in[QUAN_SIZE*81+bit_index],v2c_bs_in[QUAN_SIZE*80+bit_index],v2c_bs_in[QUAN_SIZE*79+bit_index],v2c_bs_in[QUAN_SIZE*78+bit_index],v2c_bs_in[QUAN_SIZE*77+bit_index],v2c_bs_in[QUAN_SIZE*76+bit_index],v2c_bs_in[QUAN_SIZE*75+bit_index],v2c_bs_in[QUAN_SIZE*74+bit_index],v2c_bs_in[QUAN_SIZE*73+bit_index],v2c_bs_in[QUAN_SIZE*72+bit_index],v2c_bs_in[QUAN_SIZE*71+bit_index],v2c_bs_in[QUAN_SIZE*70+bit_index],v2c_bs_in[QUAN_SIZE*69+bit_index],v2c_bs_in[QUAN_SIZE*68+bit_index],v2c_bs_in[QUAN_SIZE*67+bit_index],v2c_bs_in[QUAN_SIZE*66+bit_index],v2c_bs_in[QUAN_SIZE*65+bit_index],v2c_bs_in[QUAN_SIZE*64+bit_index],v2c_bs_in[QUAN_SIZE*63+bit_index],v2c_bs_in[QUAN_SIZE*62+bit_index],v2c_bs_in[QUAN_SIZE*61+bit_index],v2c_bs_in[QUAN_SIZE*60+bit_index],v2c_bs_in[QUAN_SIZE*59+bit_index],v2c_bs_in[QUAN_SIZE*58+bit_index],v2c_bs_in[QUAN_SIZE*57+bit_index],v2c_bs_in[QUAN_SIZE*56+bit_index],v2c_bs_in[QUAN_SIZE*55+bit_index],v2c_bs_in[QUAN_SIZE*54+bit_index],v2c_bs_in[QUAN_SIZE*53+bit_index],v2c_bs_in[QUAN_SIZE*52+bit_index],v2c_bs_in[QUAN_SIZE*51+bit_index],v2c_bs_in[QUAN_SIZE*50+bit_index],v2c_bs_in[QUAN_SIZE*49+bit_index],v2c_bs_in[QUAN_SIZE*48+bit_index],v2c_bs_in[QUAN_SIZE*47+bit_index],v2c_bs_in[QUAN_SIZE*46+bit_index],v2c_bs_in[QUAN_SIZE*45+bit_index],v2c_bs_in[QUAN_SIZE*44+bit_index],v2c_bs_in[QUAN_SIZE*43+bit_index],v2c_bs_in[QUAN_SIZE*42+bit_index],v2c_bs_in[QUAN_SIZE*41+bit_index],v2c_bs_in[QUAN_SIZE*40+bit_index],v2c_bs_in[QUAN_SIZE*39+bit_index],v2c_bs_in[QUAN_SIZE*38+bit_index],v2c_bs_in[QUAN_SIZE*37+bit_index],v2c_bs_in[QUAN_SIZE*36+bit_index],v2c_bs_in[QUAN_SIZE*35+bit_index],v2c_bs_in[QUAN_SIZE*34+bit_index],v2c_bs_in[QUAN_SIZE*33+bit_index],v2c_bs_in[QUAN_SIZE*32+bit_index],v2c_bs_in[QUAN_SIZE*31+bit_index],v2c_bs_in[QUAN_SIZE*30+bit_index],v2c_bs_in[QUAN_SIZE*29+bit_index],v2c_bs_in[QUAN_SIZE*28+bit_index],v2c_bs_in[QUAN_SIZE*27+bit_index],v2c_bs_in[QUAN_SIZE*26+bit_index],v2c_bs_in[QUAN_SIZE*25+bit_index],v2c_bs_in[QUAN_SIZE*24+bit_index],v2c_bs_in[QUAN_SIZE*23+bit_index],v2c_bs_in[QUAN_SIZE*22+bit_index],v2c_bs_in[QUAN_SIZE*21+bit_index],v2c_bs_in[QUAN_SIZE*20+bit_index],v2c_bs_in[QUAN_SIZE*19+bit_index],v2c_bs_in[QUAN_SIZE*18+bit_index],v2c_bs_in[QUAN_SIZE*17+bit_index],v2c_bs_in[QUAN_SIZE*16+bit_index],v2c_bs_in[QUAN_SIZE*15+bit_index],v2c_bs_in[QUAN_SIZE*14+bit_index],v2c_bs_in[QUAN_SIZE*13+bit_index],v2c_bs_in[QUAN_SIZE*12+bit_index],v2c_bs_in[QUAN_SIZE*11+bit_index],v2c_bs_in[QUAN_SIZE*10+bit_index],v2c_bs_in[QUAN_SIZE*9+bit_index],v2c_bs_in[QUAN_SIZE*8+bit_index],v2c_bs_in[QUAN_SIZE*7+bit_index],v2c_bs_in[QUAN_SIZE*6+bit_index],v2c_bs_in[QUAN_SIZE*5+bit_index],v2c_bs_in[QUAN_SIZE*4+bit_index],v2c_bs_in[QUAN_SIZE*3+bit_index],v2c_bs_in[QUAN_SIZE*2+bit_index],v2c_bs_in[QUAN_SIZE*1+bit_index],v2c_bs_in[QUAN_SIZE*0+bit_index]};
		assign ch_bs_in_bit[bit_index]  = { ch_bs_in[QUAN_SIZE*254+bit_index],ch_bs_in[QUAN_SIZE*253+bit_index],ch_bs_in[QUAN_SIZE*252+bit_index],ch_bs_in[QUAN_SIZE*251+bit_index],ch_bs_in[QUAN_SIZE*250+bit_index],ch_bs_in[QUAN_SIZE*249+bit_index],ch_bs_in[QUAN_SIZE*248+bit_index],ch_bs_in[QUAN_SIZE*247+bit_index],ch_bs_in[QUAN_SIZE*246+bit_index],ch_bs_in[QUAN_SIZE*245+bit_index],ch_bs_in[QUAN_SIZE*244+bit_index],ch_bs_in[QUAN_SIZE*243+bit_index],ch_bs_in[QUAN_SIZE*242+bit_index],ch_bs_in[QUAN_SIZE*241+bit_index],ch_bs_in[QUAN_SIZE*240+bit_index],ch_bs_in[QUAN_SIZE*239+bit_index],ch_bs_in[QUAN_SIZE*238+bit_index],ch_bs_in[QUAN_SIZE*237+bit_index],ch_bs_in[QUAN_SIZE*236+bit_index],ch_bs_in[QUAN_SIZE*235+bit_index],ch_bs_in[QUAN_SIZE*234+bit_index],ch_bs_in[QUAN_SIZE*233+bit_index],ch_bs_in[QUAN_SIZE*232+bit_index],ch_bs_in[QUAN_SIZE*231+bit_index],ch_bs_in[QUAN_SIZE*230+bit_index],ch_bs_in[QUAN_SIZE*229+bit_index],ch_bs_in[QUAN_SIZE*228+bit_index],ch_bs_in[QUAN_SIZE*227+bit_index],ch_bs_in[QUAN_SIZE*226+bit_index],ch_bs_in[QUAN_SIZE*225+bit_index],ch_bs_in[QUAN_SIZE*224+bit_index],ch_bs_in[QUAN_SIZE*223+bit_index],ch_bs_in[QUAN_SIZE*222+bit_index],ch_bs_in[QUAN_SIZE*221+bit_index],ch_bs_in[QUAN_SIZE*220+bit_index],ch_bs_in[QUAN_SIZE*219+bit_index],ch_bs_in[QUAN_SIZE*218+bit_index],ch_bs_in[QUAN_SIZE*217+bit_index],ch_bs_in[QUAN_SIZE*216+bit_index],ch_bs_in[QUAN_SIZE*215+bit_index],ch_bs_in[QUAN_SIZE*214+bit_index],ch_bs_in[QUAN_SIZE*213+bit_index],ch_bs_in[QUAN_SIZE*212+bit_index],ch_bs_in[QUAN_SIZE*211+bit_index],ch_bs_in[QUAN_SIZE*210+bit_index],ch_bs_in[QUAN_SIZE*209+bit_index],ch_bs_in[QUAN_SIZE*208+bit_index],ch_bs_in[QUAN_SIZE*207+bit_index],ch_bs_in[QUAN_SIZE*206+bit_index],ch_bs_in[QUAN_SIZE*205+bit_index],ch_bs_in[QUAN_SIZE*204+bit_index],ch_bs_in[QUAN_SIZE*203+bit_index],ch_bs_in[QUAN_SIZE*202+bit_index],ch_bs_in[QUAN_SIZE*201+bit_index],ch_bs_in[QUAN_SIZE*200+bit_index],ch_bs_in[QUAN_SIZE*199+bit_index],ch_bs_in[QUAN_SIZE*198+bit_index],ch_bs_in[QUAN_SIZE*197+bit_index],ch_bs_in[QUAN_SIZE*196+bit_index],ch_bs_in[QUAN_SIZE*195+bit_index],ch_bs_in[QUAN_SIZE*194+bit_index],ch_bs_in[QUAN_SIZE*193+bit_index],ch_bs_in[QUAN_SIZE*192+bit_index],ch_bs_in[QUAN_SIZE*191+bit_index],ch_bs_in[QUAN_SIZE*190+bit_index],ch_bs_in[QUAN_SIZE*189+bit_index],ch_bs_in[QUAN_SIZE*188+bit_index],ch_bs_in[QUAN_SIZE*187+bit_index],ch_bs_in[QUAN_SIZE*186+bit_index],ch_bs_in[QUAN_SIZE*185+bit_index],ch_bs_in[QUAN_SIZE*184+bit_index],ch_bs_in[QUAN_SIZE*183+bit_index],ch_bs_in[QUAN_SIZE*182+bit_index],ch_bs_in[QUAN_SIZE*181+bit_index],ch_bs_in[QUAN_SIZE*180+bit_index],ch_bs_in[QUAN_SIZE*179+bit_index],ch_bs_in[QUAN_SIZE*178+bit_index],ch_bs_in[QUAN_SIZE*177+bit_index],ch_bs_in[QUAN_SIZE*176+bit_index],ch_bs_in[QUAN_SIZE*175+bit_index],ch_bs_in[QUAN_SIZE*174+bit_index],ch_bs_in[QUAN_SIZE*173+bit_index],ch_bs_in[QUAN_SIZE*172+bit_index],ch_bs_in[QUAN_SIZE*171+bit_index],ch_bs_in[QUAN_SIZE*170+bit_index],ch_bs_in[QUAN_SIZE*169+bit_index],ch_bs_in[QUAN_SIZE*168+bit_index],ch_bs_in[QUAN_SIZE*167+bit_index],ch_bs_in[QUAN_SIZE*166+bit_index],ch_bs_in[QUAN_SIZE*165+bit_index],ch_bs_in[QUAN_SIZE*164+bit_index],ch_bs_in[QUAN_SIZE*163+bit_index],ch_bs_in[QUAN_SIZE*162+bit_index],ch_bs_in[QUAN_SIZE*161+bit_index],ch_bs_in[QUAN_SIZE*160+bit_index],ch_bs_in[QUAN_SIZE*159+bit_index],ch_bs_in[QUAN_SIZE*158+bit_index],ch_bs_in[QUAN_SIZE*157+bit_index],ch_bs_in[QUAN_SIZE*156+bit_index],ch_bs_in[QUAN_SIZE*155+bit_index],ch_bs_in[QUAN_SIZE*154+bit_index],ch_bs_in[QUAN_SIZE*153+bit_index],ch_bs_in[QUAN_SIZE*152+bit_index],ch_bs_in[QUAN_SIZE*151+bit_index],ch_bs_in[QUAN_SIZE*150+bit_index],ch_bs_in[QUAN_SIZE*149+bit_index],ch_bs_in[QUAN_SIZE*148+bit_index],ch_bs_in[QUAN_SIZE*147+bit_index],ch_bs_in[QUAN_SIZE*146+bit_index],ch_bs_in[QUAN_SIZE*145+bit_index],ch_bs_in[QUAN_SIZE*144+bit_index],ch_bs_in[QUAN_SIZE*143+bit_index],ch_bs_in[QUAN_SIZE*142+bit_index],ch_bs_in[QUAN_SIZE*141+bit_index],ch_bs_in[QUAN_SIZE*140+bit_index],ch_bs_in[QUAN_SIZE*139+bit_index],ch_bs_in[QUAN_SIZE*138+bit_index],ch_bs_in[QUAN_SIZE*137+bit_index],ch_bs_in[QUAN_SIZE*136+bit_index],ch_bs_in[QUAN_SIZE*135+bit_index],ch_bs_in[QUAN_SIZE*134+bit_index],ch_bs_in[QUAN_SIZE*133+bit_index],ch_bs_in[QUAN_SIZE*132+bit_index],ch_bs_in[QUAN_SIZE*131+bit_index],ch_bs_in[QUAN_SIZE*130+bit_index],ch_bs_in[QUAN_SIZE*129+bit_index],ch_bs_in[QUAN_SIZE*128+bit_index],ch_bs_in[QUAN_SIZE*127+bit_index],ch_bs_in[QUAN_SIZE*126+bit_index],ch_bs_in[QUAN_SIZE*125+bit_index],ch_bs_in[QUAN_SIZE*124+bit_index],ch_bs_in[QUAN_SIZE*123+bit_index],ch_bs_in[QUAN_SIZE*122+bit_index],ch_bs_in[QUAN_SIZE*121+bit_index],ch_bs_in[QUAN_SIZE*120+bit_index],ch_bs_in[QUAN_SIZE*119+bit_index],ch_bs_in[QUAN_SIZE*118+bit_index],ch_bs_in[QUAN_SIZE*117+bit_index],ch_bs_in[QUAN_SIZE*116+bit_index],ch_bs_in[QUAN_SIZE*115+bit_index],ch_bs_in[QUAN_SIZE*114+bit_index],ch_bs_in[QUAN_SIZE*113+bit_index],ch_bs_in[QUAN_SIZE*112+bit_index],ch_bs_in[QUAN_SIZE*111+bit_index],ch_bs_in[QUAN_SIZE*110+bit_index],ch_bs_in[QUAN_SIZE*109+bit_index],ch_bs_in[QUAN_SIZE*108+bit_index],ch_bs_in[QUAN_SIZE*107+bit_index],ch_bs_in[QUAN_SIZE*106+bit_index],ch_bs_in[QUAN_SIZE*105+bit_index],ch_bs_in[QUAN_SIZE*104+bit_index],ch_bs_in[QUAN_SIZE*103+bit_index],ch_bs_in[QUAN_SIZE*102+bit_index],ch_bs_in[QUAN_SIZE*101+bit_index],ch_bs_in[QUAN_SIZE*100+bit_index],ch_bs_in[QUAN_SIZE*99+bit_index],ch_bs_in[QUAN_SIZE*98+bit_index],ch_bs_in[QUAN_SIZE*97+bit_index],ch_bs_in[QUAN_SIZE*96+bit_index],ch_bs_in[QUAN_SIZE*95+bit_index],ch_bs_in[QUAN_SIZE*94+bit_index],ch_bs_in[QUAN_SIZE*93+bit_index],ch_bs_in[QUAN_SIZE*92+bit_index],ch_bs_in[QUAN_SIZE*91+bit_index],ch_bs_in[QUAN_SIZE*90+bit_index],ch_bs_in[QUAN_SIZE*89+bit_index],ch_bs_in[QUAN_SIZE*88+bit_index],ch_bs_in[QUAN_SIZE*87+bit_index],ch_bs_in[QUAN_SIZE*86+bit_index],ch_bs_in[QUAN_SIZE*85+bit_index],ch_bs_in[QUAN_SIZE*84+bit_index],ch_bs_in[QUAN_SIZE*83+bit_index],ch_bs_in[QUAN_SIZE*82+bit_index],ch_bs_in[QUAN_SIZE*81+bit_index],ch_bs_in[QUAN_SIZE*80+bit_index],ch_bs_in[QUAN_SIZE*79+bit_index],ch_bs_in[QUAN_SIZE*78+bit_index],ch_bs_in[QUAN_SIZE*77+bit_index],ch_bs_in[QUAN_SIZE*76+bit_index],ch_bs_in[QUAN_SIZE*75+bit_index],ch_bs_in[QUAN_SIZE*74+bit_index],ch_bs_in[QUAN_SIZE*73+bit_index],ch_bs_in[QUAN_SIZE*72+bit_index],ch_bs_in[QUAN_SIZE*71+bit_index],ch_bs_in[QUAN_SIZE*70+bit_index],ch_bs_in[QUAN_SIZE*69+bit_index],ch_bs_in[QUAN_SIZE*68+bit_index],ch_bs_in[QUAN_SIZE*67+bit_index],ch_bs_in[QUAN_SIZE*66+bit_index],ch_bs_in[QUAN_SIZE*65+bit_index],ch_bs_in[QUAN_SIZE*64+bit_index],ch_bs_in[QUAN_SIZE*63+bit_index],ch_bs_in[QUAN_SIZE*62+bit_index],ch_bs_in[QUAN_SIZE*61+bit_index],ch_bs_in[QUAN_SIZE*60+bit_index],ch_bs_in[QUAN_SIZE*59+bit_index],ch_bs_in[QUAN_SIZE*58+bit_index],ch_bs_in[QUAN_SIZE*57+bit_index],ch_bs_in[QUAN_SIZE*56+bit_index],ch_bs_in[QUAN_SIZE*55+bit_index],ch_bs_in[QUAN_SIZE*54+bit_index],ch_bs_in[QUAN_SIZE*53+bit_index],ch_bs_in[QUAN_SIZE*52+bit_index],ch_bs_in[QUAN_SIZE*51+bit_index],ch_bs_in[QUAN_SIZE*50+bit_index],ch_bs_in[QUAN_SIZE*49+bit_index],ch_bs_in[QUAN_SIZE*48+bit_index],ch_bs_in[QUAN_SIZE*47+bit_index],ch_bs_in[QUAN_SIZE*46+bit_index],ch_bs_in[QUAN_SIZE*45+bit_index],ch_bs_in[QUAN_SIZE*44+bit_index],ch_bs_in[QUAN_SIZE*43+bit_index],ch_bs_in[QUAN_SIZE*42+bit_index],ch_bs_in[QUAN_SIZE*41+bit_index],ch_bs_in[QUAN_SIZE*40+bit_index],ch_bs_in[QUAN_SIZE*39+bit_index],ch_bs_in[QUAN_SIZE*38+bit_index],ch_bs_in[QUAN_SIZE*37+bit_index],ch_bs_in[QUAN_SIZE*36+bit_index],ch_bs_in[QUAN_SIZE*35+bit_index],ch_bs_in[QUAN_SIZE*34+bit_index],ch_bs_in[QUAN_SIZE*33+bit_index],ch_bs_in[QUAN_SIZE*32+bit_index],ch_bs_in[QUAN_SIZE*31+bit_index],ch_bs_in[QUAN_SIZE*30+bit_index],ch_bs_in[QUAN_SIZE*29+bit_index],ch_bs_in[QUAN_SIZE*28+bit_index],ch_bs_in[QUAN_SIZE*27+bit_index],ch_bs_in[QUAN_SIZE*26+bit_index],ch_bs_in[QUAN_SIZE*25+bit_index],ch_bs_in[QUAN_SIZE*24+bit_index],ch_bs_in[QUAN_SIZE*23+bit_index],ch_bs_in[QUAN_SIZE*22+bit_index],ch_bs_in[QUAN_SIZE*21+bit_index],ch_bs_in[QUAN_SIZE*20+bit_index],ch_bs_in[QUAN_SIZE*19+bit_index],ch_bs_in[QUAN_SIZE*18+bit_index],ch_bs_in[QUAN_SIZE*17+bit_index],ch_bs_in[QUAN_SIZE*16+bit_index],ch_bs_in[QUAN_SIZE*15+bit_index],ch_bs_in[QUAN_SIZE*14+bit_index],ch_bs_in[QUAN_SIZE*13+bit_index],ch_bs_in[QUAN_SIZE*12+bit_index],ch_bs_in[QUAN_SIZE*11+bit_index],ch_bs_in[QUAN_SIZE*10+bit_index],ch_bs_in[QUAN_SIZE*9+bit_index],ch_bs_in[QUAN_SIZE*8+bit_index],ch_bs_in[QUAN_SIZE*7+bit_index],ch_bs_in[QUAN_SIZE*6+bit_index],ch_bs_in[QUAN_SIZE*5+bit_index],ch_bs_in[QUAN_SIZE*4+bit_index],ch_bs_in[QUAN_SIZE*3+bit_index],ch_bs_in[QUAN_SIZE*2+bit_index],ch_bs_in[QUAN_SIZE*1+bit_index],ch_bs_in[QUAN_SIZE*0+bit_index]};
	end
endgenerate
/*----------------------------------------------*/
// Circular shifter of check nodes
qsn_top cnu_qsn_top_0_3 (
	.sw_out_bit0 ({cnu_msg_in[254][0],cnu_msg_in[253][0],cnu_msg_in[252][0],cnu_msg_in[251][0],cnu_msg_in[250][0],cnu_msg_in[249][0],cnu_msg_in[248][0],cnu_msg_in[247][0],cnu_msg_in[246][0],cnu_msg_in[245][0],cnu_msg_in[244][0],cnu_msg_in[243][0],cnu_msg_in[242][0],cnu_msg_in[241][0],cnu_msg_in[240][0],cnu_msg_in[239][0],cnu_msg_in[238][0],cnu_msg_in[237][0],cnu_msg_in[236][0],cnu_msg_in[235][0],cnu_msg_in[234][0],cnu_msg_in[233][0],cnu_msg_in[232][0],cnu_msg_in[231][0],cnu_msg_in[230][0],cnu_msg_in[229][0],cnu_msg_in[228][0],cnu_msg_in[227][0],cnu_msg_in[226][0],cnu_msg_in[225][0],cnu_msg_in[224][0],cnu_msg_in[223][0],cnu_msg_in[222][0],cnu_msg_in[221][0],cnu_msg_in[220][0],cnu_msg_in[219][0],cnu_msg_in[218][0],cnu_msg_in[217][0],cnu_msg_in[216][0],cnu_msg_in[215][0],cnu_msg_in[214][0],cnu_msg_in[213][0],cnu_msg_in[212][0],cnu_msg_in[211][0],cnu_msg_in[210][0],cnu_msg_in[209][0],cnu_msg_in[208][0],cnu_msg_in[207][0],cnu_msg_in[206][0],cnu_msg_in[205][0],cnu_msg_in[204][0],cnu_msg_in[203][0],cnu_msg_in[202][0],cnu_msg_in[201][0],cnu_msg_in[200][0],cnu_msg_in[199][0],cnu_msg_in[198][0],cnu_msg_in[197][0],cnu_msg_in[196][0],cnu_msg_in[195][0],cnu_msg_in[194][0],cnu_msg_in[193][0],cnu_msg_in[192][0],cnu_msg_in[191][0],cnu_msg_in[190][0],cnu_msg_in[189][0],cnu_msg_in[188][0],cnu_msg_in[187][0],cnu_msg_in[186][0],cnu_msg_in[185][0],cnu_msg_in[184][0],cnu_msg_in[183][0],cnu_msg_in[182][0],cnu_msg_in[181][0],cnu_msg_in[180][0],cnu_msg_in[179][0],cnu_msg_in[178][0],cnu_msg_in[177][0],cnu_msg_in[176][0],cnu_msg_in[175][0],cnu_msg_in[174][0],cnu_msg_in[173][0],cnu_msg_in[172][0],cnu_msg_in[171][0],cnu_msg_in[170][0],cnu_msg_in[169][0],cnu_msg_in[168][0],cnu_msg_in[167][0],cnu_msg_in[166][0],cnu_msg_in[165][0],cnu_msg_in[164][0],cnu_msg_in[163][0],cnu_msg_in[162][0],cnu_msg_in[161][0],cnu_msg_in[160][0],cnu_msg_in[159][0],cnu_msg_in[158][0],cnu_msg_in[157][0],cnu_msg_in[156][0],cnu_msg_in[155][0],cnu_msg_in[154][0],cnu_msg_in[153][0],cnu_msg_in[152][0],cnu_msg_in[151][0],cnu_msg_in[150][0],cnu_msg_in[149][0],cnu_msg_in[148][0],cnu_msg_in[147][0],cnu_msg_in[146][0],cnu_msg_in[145][0],cnu_msg_in[144][0],cnu_msg_in[143][0],cnu_msg_in[142][0],cnu_msg_in[141][0],cnu_msg_in[140][0],cnu_msg_in[139][0],cnu_msg_in[138][0],cnu_msg_in[137][0],cnu_msg_in[136][0],cnu_msg_in[135][0],cnu_msg_in[134][0],cnu_msg_in[133][0],cnu_msg_in[132][0],cnu_msg_in[131][0],cnu_msg_in[130][0],cnu_msg_in[129][0],cnu_msg_in[128][0],cnu_msg_in[127][0],cnu_msg_in[126][0],cnu_msg_in[125][0],cnu_msg_in[124][0],cnu_msg_in[123][0],cnu_msg_in[122][0],cnu_msg_in[121][0],cnu_msg_in[120][0],cnu_msg_in[119][0],cnu_msg_in[118][0],cnu_msg_in[117][0],cnu_msg_in[116][0],cnu_msg_in[115][0],cnu_msg_in[114][0],cnu_msg_in[113][0],cnu_msg_in[112][0],cnu_msg_in[111][0],cnu_msg_in[110][0],cnu_msg_in[109][0],cnu_msg_in[108][0],cnu_msg_in[107][0],cnu_msg_in[106][0],cnu_msg_in[105][0],cnu_msg_in[104][0],cnu_msg_in[103][0],cnu_msg_in[102][0],cnu_msg_in[101][0],cnu_msg_in[100][0],cnu_msg_in[99][0],cnu_msg_in[98][0],cnu_msg_in[97][0],cnu_msg_in[96][0],cnu_msg_in[95][0],cnu_msg_in[94][0],cnu_msg_in[93][0],cnu_msg_in[92][0],cnu_msg_in[91][0],cnu_msg_in[90][0],cnu_msg_in[89][0],cnu_msg_in[88][0],cnu_msg_in[87][0],cnu_msg_in[86][0],cnu_msg_in[85][0],cnu_msg_in[84][0],cnu_msg_in[83][0],cnu_msg_in[82][0],cnu_msg_in[81][0],cnu_msg_in[80][0],cnu_msg_in[79][0],cnu_msg_in[78][0],cnu_msg_in[77][0],cnu_msg_in[76][0],cnu_msg_in[75][0],cnu_msg_in[74][0],cnu_msg_in[73][0],cnu_msg_in[72][0],cnu_msg_in[71][0],cnu_msg_in[70][0],cnu_msg_in[69][0],cnu_msg_in[68][0],cnu_msg_in[67][0],cnu_msg_in[66][0],cnu_msg_in[65][0],cnu_msg_in[64][0],cnu_msg_in[63][0],cnu_msg_in[62][0],cnu_msg_in[61][0],cnu_msg_in[60][0],cnu_msg_in[59][0],cnu_msg_in[58][0],cnu_msg_in[57][0],cnu_msg_in[56][0],cnu_msg_in[55][0],cnu_msg_in[54][0],cnu_msg_in[53][0],cnu_msg_in[52][0],cnu_msg_in[51][0],cnu_msg_in[50][0],cnu_msg_in[49][0],cnu_msg_in[48][0],cnu_msg_in[47][0],cnu_msg_in[46][0],cnu_msg_in[45][0],cnu_msg_in[44][0],cnu_msg_in[43][0],cnu_msg_in[42][0],cnu_msg_in[41][0],cnu_msg_in[40][0],cnu_msg_in[39][0],cnu_msg_in[38][0],cnu_msg_in[37][0],cnu_msg_in[36][0],cnu_msg_in[35][0],cnu_msg_in[34][0],cnu_msg_in[33][0],cnu_msg_in[32][0],cnu_msg_in[31][0],cnu_msg_in[30][0],cnu_msg_in[29][0],cnu_msg_in[28][0],cnu_msg_in[27][0],cnu_msg_in[26][0],cnu_msg_in[25][0],cnu_msg_in[24][0],cnu_msg_in[23][0],cnu_msg_in[22][0],cnu_msg_in[21][0],cnu_msg_in[20][0],cnu_msg_in[19][0],cnu_msg_in[18][0],cnu_msg_in[17][0],cnu_msg_in[16][0],cnu_msg_in[15][0],cnu_msg_in[14][0],cnu_msg_in[13][0],cnu_msg_in[12][0],cnu_msg_in[11][0],cnu_msg_in[10][0],cnu_msg_in[9][0],cnu_msg_in[8][0],cnu_msg_in[7][0],cnu_msg_in[6][0],cnu_msg_in[5][0],cnu_msg_in[4][0],cnu_msg_in[3][0],cnu_msg_in[2][0],cnu_msg_in[1][0],cnu_msg_in[0][0]}),
	.sw_out_bit1 ({cnu_msg_in[254][1],cnu_msg_in[253][1],cnu_msg_in[252][1],cnu_msg_in[251][1],cnu_msg_in[250][1],cnu_msg_in[249][1],cnu_msg_in[248][1],cnu_msg_in[247][1],cnu_msg_in[246][1],cnu_msg_in[245][1],cnu_msg_in[244][1],cnu_msg_in[243][1],cnu_msg_in[242][1],cnu_msg_in[241][1],cnu_msg_in[240][1],cnu_msg_in[239][1],cnu_msg_in[238][1],cnu_msg_in[237][1],cnu_msg_in[236][1],cnu_msg_in[235][1],cnu_msg_in[234][1],cnu_msg_in[233][1],cnu_msg_in[232][1],cnu_msg_in[231][1],cnu_msg_in[230][1],cnu_msg_in[229][1],cnu_msg_in[228][1],cnu_msg_in[227][1],cnu_msg_in[226][1],cnu_msg_in[225][1],cnu_msg_in[224][1],cnu_msg_in[223][1],cnu_msg_in[222][1],cnu_msg_in[221][1],cnu_msg_in[220][1],cnu_msg_in[219][1],cnu_msg_in[218][1],cnu_msg_in[217][1],cnu_msg_in[216][1],cnu_msg_in[215][1],cnu_msg_in[214][1],cnu_msg_in[213][1],cnu_msg_in[212][1],cnu_msg_in[211][1],cnu_msg_in[210][1],cnu_msg_in[209][1],cnu_msg_in[208][1],cnu_msg_in[207][1],cnu_msg_in[206][1],cnu_msg_in[205][1],cnu_msg_in[204][1],cnu_msg_in[203][1],cnu_msg_in[202][1],cnu_msg_in[201][1],cnu_msg_in[200][1],cnu_msg_in[199][1],cnu_msg_in[198][1],cnu_msg_in[197][1],cnu_msg_in[196][1],cnu_msg_in[195][1],cnu_msg_in[194][1],cnu_msg_in[193][1],cnu_msg_in[192][1],cnu_msg_in[191][1],cnu_msg_in[190][1],cnu_msg_in[189][1],cnu_msg_in[188][1],cnu_msg_in[187][1],cnu_msg_in[186][1],cnu_msg_in[185][1],cnu_msg_in[184][1],cnu_msg_in[183][1],cnu_msg_in[182][1],cnu_msg_in[181][1],cnu_msg_in[180][1],cnu_msg_in[179][1],cnu_msg_in[178][1],cnu_msg_in[177][1],cnu_msg_in[176][1],cnu_msg_in[175][1],cnu_msg_in[174][1],cnu_msg_in[173][1],cnu_msg_in[172][1],cnu_msg_in[171][1],cnu_msg_in[170][1],cnu_msg_in[169][1],cnu_msg_in[168][1],cnu_msg_in[167][1],cnu_msg_in[166][1],cnu_msg_in[165][1],cnu_msg_in[164][1],cnu_msg_in[163][1],cnu_msg_in[162][1],cnu_msg_in[161][1],cnu_msg_in[160][1],cnu_msg_in[159][1],cnu_msg_in[158][1],cnu_msg_in[157][1],cnu_msg_in[156][1],cnu_msg_in[155][1],cnu_msg_in[154][1],cnu_msg_in[153][1],cnu_msg_in[152][1],cnu_msg_in[151][1],cnu_msg_in[150][1],cnu_msg_in[149][1],cnu_msg_in[148][1],cnu_msg_in[147][1],cnu_msg_in[146][1],cnu_msg_in[145][1],cnu_msg_in[144][1],cnu_msg_in[143][1],cnu_msg_in[142][1],cnu_msg_in[141][1],cnu_msg_in[140][1],cnu_msg_in[139][1],cnu_msg_in[138][1],cnu_msg_in[137][1],cnu_msg_in[136][1],cnu_msg_in[135][1],cnu_msg_in[134][1],cnu_msg_in[133][1],cnu_msg_in[132][1],cnu_msg_in[131][1],cnu_msg_in[130][1],cnu_msg_in[129][1],cnu_msg_in[128][1],cnu_msg_in[127][1],cnu_msg_in[126][1],cnu_msg_in[125][1],cnu_msg_in[124][1],cnu_msg_in[123][1],cnu_msg_in[122][1],cnu_msg_in[121][1],cnu_msg_in[120][1],cnu_msg_in[119][1],cnu_msg_in[118][1],cnu_msg_in[117][1],cnu_msg_in[116][1],cnu_msg_in[115][1],cnu_msg_in[114][1],cnu_msg_in[113][1],cnu_msg_in[112][1],cnu_msg_in[111][1],cnu_msg_in[110][1],cnu_msg_in[109][1],cnu_msg_in[108][1],cnu_msg_in[107][1],cnu_msg_in[106][1],cnu_msg_in[105][1],cnu_msg_in[104][1],cnu_msg_in[103][1],cnu_msg_in[102][1],cnu_msg_in[101][1],cnu_msg_in[100][1],cnu_msg_in[99][1],cnu_msg_in[98][1],cnu_msg_in[97][1],cnu_msg_in[96][1],cnu_msg_in[95][1],cnu_msg_in[94][1],cnu_msg_in[93][1],cnu_msg_in[92][1],cnu_msg_in[91][1],cnu_msg_in[90][1],cnu_msg_in[89][1],cnu_msg_in[88][1],cnu_msg_in[87][1],cnu_msg_in[86][1],cnu_msg_in[85][1],cnu_msg_in[84][1],cnu_msg_in[83][1],cnu_msg_in[82][1],cnu_msg_in[81][1],cnu_msg_in[80][1],cnu_msg_in[79][1],cnu_msg_in[78][1],cnu_msg_in[77][1],cnu_msg_in[76][1],cnu_msg_in[75][1],cnu_msg_in[74][1],cnu_msg_in[73][1],cnu_msg_in[72][1],cnu_msg_in[71][1],cnu_msg_in[70][1],cnu_msg_in[69][1],cnu_msg_in[68][1],cnu_msg_in[67][1],cnu_msg_in[66][1],cnu_msg_in[65][1],cnu_msg_in[64][1],cnu_msg_in[63][1],cnu_msg_in[62][1],cnu_msg_in[61][1],cnu_msg_in[60][1],cnu_msg_in[59][1],cnu_msg_in[58][1],cnu_msg_in[57][1],cnu_msg_in[56][1],cnu_msg_in[55][1],cnu_msg_in[54][1],cnu_msg_in[53][1],cnu_msg_in[52][1],cnu_msg_in[51][1],cnu_msg_in[50][1],cnu_msg_in[49][1],cnu_msg_in[48][1],cnu_msg_in[47][1],cnu_msg_in[46][1],cnu_msg_in[45][1],cnu_msg_in[44][1],cnu_msg_in[43][1],cnu_msg_in[42][1],cnu_msg_in[41][1],cnu_msg_in[40][1],cnu_msg_in[39][1],cnu_msg_in[38][1],cnu_msg_in[37][1],cnu_msg_in[36][1],cnu_msg_in[35][1],cnu_msg_in[34][1],cnu_msg_in[33][1],cnu_msg_in[32][1],cnu_msg_in[31][1],cnu_msg_in[30][1],cnu_msg_in[29][1],cnu_msg_in[28][1],cnu_msg_in[27][1],cnu_msg_in[26][1],cnu_msg_in[25][1],cnu_msg_in[24][1],cnu_msg_in[23][1],cnu_msg_in[22][1],cnu_msg_in[21][1],cnu_msg_in[20][1],cnu_msg_in[19][1],cnu_msg_in[18][1],cnu_msg_in[17][1],cnu_msg_in[16][1],cnu_msg_in[15][1],cnu_msg_in[14][1],cnu_msg_in[13][1],cnu_msg_in[12][1],cnu_msg_in[11][1],cnu_msg_in[10][1],cnu_msg_in[9][1],cnu_msg_in[8][1],cnu_msg_in[7][1],cnu_msg_in[6][1],cnu_msg_in[5][1],cnu_msg_in[4][1],cnu_msg_in[3][1],cnu_msg_in[2][1],cnu_msg_in[1][1],cnu_msg_in[0][1]}),
	.sw_out_bit2 ({cnu_msg_in[254][2],cnu_msg_in[253][2],cnu_msg_in[252][2],cnu_msg_in[251][2],cnu_msg_in[250][2],cnu_msg_in[249][2],cnu_msg_in[248][2],cnu_msg_in[247][2],cnu_msg_in[246][2],cnu_msg_in[245][2],cnu_msg_in[244][2],cnu_msg_in[243][2],cnu_msg_in[242][2],cnu_msg_in[241][2],cnu_msg_in[240][2],cnu_msg_in[239][2],cnu_msg_in[238][2],cnu_msg_in[237][2],cnu_msg_in[236][2],cnu_msg_in[235][2],cnu_msg_in[234][2],cnu_msg_in[233][2],cnu_msg_in[232][2],cnu_msg_in[231][2],cnu_msg_in[230][2],cnu_msg_in[229][2],cnu_msg_in[228][2],cnu_msg_in[227][2],cnu_msg_in[226][2],cnu_msg_in[225][2],cnu_msg_in[224][2],cnu_msg_in[223][2],cnu_msg_in[222][2],cnu_msg_in[221][2],cnu_msg_in[220][2],cnu_msg_in[219][2],cnu_msg_in[218][2],cnu_msg_in[217][2],cnu_msg_in[216][2],cnu_msg_in[215][2],cnu_msg_in[214][2],cnu_msg_in[213][2],cnu_msg_in[212][2],cnu_msg_in[211][2],cnu_msg_in[210][2],cnu_msg_in[209][2],cnu_msg_in[208][2],cnu_msg_in[207][2],cnu_msg_in[206][2],cnu_msg_in[205][2],cnu_msg_in[204][2],cnu_msg_in[203][2],cnu_msg_in[202][2],cnu_msg_in[201][2],cnu_msg_in[200][2],cnu_msg_in[199][2],cnu_msg_in[198][2],cnu_msg_in[197][2],cnu_msg_in[196][2],cnu_msg_in[195][2],cnu_msg_in[194][2],cnu_msg_in[193][2],cnu_msg_in[192][2],cnu_msg_in[191][2],cnu_msg_in[190][2],cnu_msg_in[189][2],cnu_msg_in[188][2],cnu_msg_in[187][2],cnu_msg_in[186][2],cnu_msg_in[185][2],cnu_msg_in[184][2],cnu_msg_in[183][2],cnu_msg_in[182][2],cnu_msg_in[181][2],cnu_msg_in[180][2],cnu_msg_in[179][2],cnu_msg_in[178][2],cnu_msg_in[177][2],cnu_msg_in[176][2],cnu_msg_in[175][2],cnu_msg_in[174][2],cnu_msg_in[173][2],cnu_msg_in[172][2],cnu_msg_in[171][2],cnu_msg_in[170][2],cnu_msg_in[169][2],cnu_msg_in[168][2],cnu_msg_in[167][2],cnu_msg_in[166][2],cnu_msg_in[165][2],cnu_msg_in[164][2],cnu_msg_in[163][2],cnu_msg_in[162][2],cnu_msg_in[161][2],cnu_msg_in[160][2],cnu_msg_in[159][2],cnu_msg_in[158][2],cnu_msg_in[157][2],cnu_msg_in[156][2],cnu_msg_in[155][2],cnu_msg_in[154][2],cnu_msg_in[153][2],cnu_msg_in[152][2],cnu_msg_in[151][2],cnu_msg_in[150][2],cnu_msg_in[149][2],cnu_msg_in[148][2],cnu_msg_in[147][2],cnu_msg_in[146][2],cnu_msg_in[145][2],cnu_msg_in[144][2],cnu_msg_in[143][2],cnu_msg_in[142][2],cnu_msg_in[141][2],cnu_msg_in[140][2],cnu_msg_in[139][2],cnu_msg_in[138][2],cnu_msg_in[137][2],cnu_msg_in[136][2],cnu_msg_in[135][2],cnu_msg_in[134][2],cnu_msg_in[133][2],cnu_msg_in[132][2],cnu_msg_in[131][2],cnu_msg_in[130][2],cnu_msg_in[129][2],cnu_msg_in[128][2],cnu_msg_in[127][2],cnu_msg_in[126][2],cnu_msg_in[125][2],cnu_msg_in[124][2],cnu_msg_in[123][2],cnu_msg_in[122][2],cnu_msg_in[121][2],cnu_msg_in[120][2],cnu_msg_in[119][2],cnu_msg_in[118][2],cnu_msg_in[117][2],cnu_msg_in[116][2],cnu_msg_in[115][2],cnu_msg_in[114][2],cnu_msg_in[113][2],cnu_msg_in[112][2],cnu_msg_in[111][2],cnu_msg_in[110][2],cnu_msg_in[109][2],cnu_msg_in[108][2],cnu_msg_in[107][2],cnu_msg_in[106][2],cnu_msg_in[105][2],cnu_msg_in[104][2],cnu_msg_in[103][2],cnu_msg_in[102][2],cnu_msg_in[101][2],cnu_msg_in[100][2],cnu_msg_in[99][2],cnu_msg_in[98][2],cnu_msg_in[97][2],cnu_msg_in[96][2],cnu_msg_in[95][2],cnu_msg_in[94][2],cnu_msg_in[93][2],cnu_msg_in[92][2],cnu_msg_in[91][2],cnu_msg_in[90][2],cnu_msg_in[89][2],cnu_msg_in[88][2],cnu_msg_in[87][2],cnu_msg_in[86][2],cnu_msg_in[85][2],cnu_msg_in[84][2],cnu_msg_in[83][2],cnu_msg_in[82][2],cnu_msg_in[81][2],cnu_msg_in[80][2],cnu_msg_in[79][2],cnu_msg_in[78][2],cnu_msg_in[77][2],cnu_msg_in[76][2],cnu_msg_in[75][2],cnu_msg_in[74][2],cnu_msg_in[73][2],cnu_msg_in[72][2],cnu_msg_in[71][2],cnu_msg_in[70][2],cnu_msg_in[69][2],cnu_msg_in[68][2],cnu_msg_in[67][2],cnu_msg_in[66][2],cnu_msg_in[65][2],cnu_msg_in[64][2],cnu_msg_in[63][2],cnu_msg_in[62][2],cnu_msg_in[61][2],cnu_msg_in[60][2],cnu_msg_in[59][2],cnu_msg_in[58][2],cnu_msg_in[57][2],cnu_msg_in[56][2],cnu_msg_in[55][2],cnu_msg_in[54][2],cnu_msg_in[53][2],cnu_msg_in[52][2],cnu_msg_in[51][2],cnu_msg_in[50][2],cnu_msg_in[49][2],cnu_msg_in[48][2],cnu_msg_in[47][2],cnu_msg_in[46][2],cnu_msg_in[45][2],cnu_msg_in[44][2],cnu_msg_in[43][2],cnu_msg_in[42][2],cnu_msg_in[41][2],cnu_msg_in[40][2],cnu_msg_in[39][2],cnu_msg_in[38][2],cnu_msg_in[37][2],cnu_msg_in[36][2],cnu_msg_in[35][2],cnu_msg_in[34][2],cnu_msg_in[33][2],cnu_msg_in[32][2],cnu_msg_in[31][2],cnu_msg_in[30][2],cnu_msg_in[29][2],cnu_msg_in[28][2],cnu_msg_in[27][2],cnu_msg_in[26][2],cnu_msg_in[25][2],cnu_msg_in[24][2],cnu_msg_in[23][2],cnu_msg_in[22][2],cnu_msg_in[21][2],cnu_msg_in[20][2],cnu_msg_in[19][2],cnu_msg_in[18][2],cnu_msg_in[17][2],cnu_msg_in[16][2],cnu_msg_in[15][2],cnu_msg_in[14][2],cnu_msg_in[13][2],cnu_msg_in[12][2],cnu_msg_in[11][2],cnu_msg_in[10][2],cnu_msg_in[9][2],cnu_msg_in[8][2],cnu_msg_in[7][2],cnu_msg_in[6][2],cnu_msg_in[5][2],cnu_msg_in[4][2],cnu_msg_in[3][2],cnu_msg_in[2][2],cnu_msg_in[1][2],cnu_msg_in[0][2]}),
	.sw_out_bit3 ({cnu_msg_in[254][3],cnu_msg_in[253][3],cnu_msg_in[252][3],cnu_msg_in[251][3],cnu_msg_in[250][3],cnu_msg_in[249][3],cnu_msg_in[248][3],cnu_msg_in[247][3],cnu_msg_in[246][3],cnu_msg_in[245][3],cnu_msg_in[244][3],cnu_msg_in[243][3],cnu_msg_in[242][3],cnu_msg_in[241][3],cnu_msg_in[240][3],cnu_msg_in[239][3],cnu_msg_in[238][3],cnu_msg_in[237][3],cnu_msg_in[236][3],cnu_msg_in[235][3],cnu_msg_in[234][3],cnu_msg_in[233][3],cnu_msg_in[232][3],cnu_msg_in[231][3],cnu_msg_in[230][3],cnu_msg_in[229][3],cnu_msg_in[228][3],cnu_msg_in[227][3],cnu_msg_in[226][3],cnu_msg_in[225][3],cnu_msg_in[224][3],cnu_msg_in[223][3],cnu_msg_in[222][3],cnu_msg_in[221][3],cnu_msg_in[220][3],cnu_msg_in[219][3],cnu_msg_in[218][3],cnu_msg_in[217][3],cnu_msg_in[216][3],cnu_msg_in[215][3],cnu_msg_in[214][3],cnu_msg_in[213][3],cnu_msg_in[212][3],cnu_msg_in[211][3],cnu_msg_in[210][3],cnu_msg_in[209][3],cnu_msg_in[208][3],cnu_msg_in[207][3],cnu_msg_in[206][3],cnu_msg_in[205][3],cnu_msg_in[204][3],cnu_msg_in[203][3],cnu_msg_in[202][3],cnu_msg_in[201][3],cnu_msg_in[200][3],cnu_msg_in[199][3],cnu_msg_in[198][3],cnu_msg_in[197][3],cnu_msg_in[196][3],cnu_msg_in[195][3],cnu_msg_in[194][3],cnu_msg_in[193][3],cnu_msg_in[192][3],cnu_msg_in[191][3],cnu_msg_in[190][3],cnu_msg_in[189][3],cnu_msg_in[188][3],cnu_msg_in[187][3],cnu_msg_in[186][3],cnu_msg_in[185][3],cnu_msg_in[184][3],cnu_msg_in[183][3],cnu_msg_in[182][3],cnu_msg_in[181][3],cnu_msg_in[180][3],cnu_msg_in[179][3],cnu_msg_in[178][3],cnu_msg_in[177][3],cnu_msg_in[176][3],cnu_msg_in[175][3],cnu_msg_in[174][3],cnu_msg_in[173][3],cnu_msg_in[172][3],cnu_msg_in[171][3],cnu_msg_in[170][3],cnu_msg_in[169][3],cnu_msg_in[168][3],cnu_msg_in[167][3],cnu_msg_in[166][3],cnu_msg_in[165][3],cnu_msg_in[164][3],cnu_msg_in[163][3],cnu_msg_in[162][3],cnu_msg_in[161][3],cnu_msg_in[160][3],cnu_msg_in[159][3],cnu_msg_in[158][3],cnu_msg_in[157][3],cnu_msg_in[156][3],cnu_msg_in[155][3],cnu_msg_in[154][3],cnu_msg_in[153][3],cnu_msg_in[152][3],cnu_msg_in[151][3],cnu_msg_in[150][3],cnu_msg_in[149][3],cnu_msg_in[148][3],cnu_msg_in[147][3],cnu_msg_in[146][3],cnu_msg_in[145][3],cnu_msg_in[144][3],cnu_msg_in[143][3],cnu_msg_in[142][3],cnu_msg_in[141][3],cnu_msg_in[140][3],cnu_msg_in[139][3],cnu_msg_in[138][3],cnu_msg_in[137][3],cnu_msg_in[136][3],cnu_msg_in[135][3],cnu_msg_in[134][3],cnu_msg_in[133][3],cnu_msg_in[132][3],cnu_msg_in[131][3],cnu_msg_in[130][3],cnu_msg_in[129][3],cnu_msg_in[128][3],cnu_msg_in[127][3],cnu_msg_in[126][3],cnu_msg_in[125][3],cnu_msg_in[124][3],cnu_msg_in[123][3],cnu_msg_in[122][3],cnu_msg_in[121][3],cnu_msg_in[120][3],cnu_msg_in[119][3],cnu_msg_in[118][3],cnu_msg_in[117][3],cnu_msg_in[116][3],cnu_msg_in[115][3],cnu_msg_in[114][3],cnu_msg_in[113][3],cnu_msg_in[112][3],cnu_msg_in[111][3],cnu_msg_in[110][3],cnu_msg_in[109][3],cnu_msg_in[108][3],cnu_msg_in[107][3],cnu_msg_in[106][3],cnu_msg_in[105][3],cnu_msg_in[104][3],cnu_msg_in[103][3],cnu_msg_in[102][3],cnu_msg_in[101][3],cnu_msg_in[100][3],cnu_msg_in[99][3],cnu_msg_in[98][3],cnu_msg_in[97][3],cnu_msg_in[96][3],cnu_msg_in[95][3],cnu_msg_in[94][3],cnu_msg_in[93][3],cnu_msg_in[92][3],cnu_msg_in[91][3],cnu_msg_in[90][3],cnu_msg_in[89][3],cnu_msg_in[88][3],cnu_msg_in[87][3],cnu_msg_in[86][3],cnu_msg_in[85][3],cnu_msg_in[84][3],cnu_msg_in[83][3],cnu_msg_in[82][3],cnu_msg_in[81][3],cnu_msg_in[80][3],cnu_msg_in[79][3],cnu_msg_in[78][3],cnu_msg_in[77][3],cnu_msg_in[76][3],cnu_msg_in[75][3],cnu_msg_in[74][3],cnu_msg_in[73][3],cnu_msg_in[72][3],cnu_msg_in[71][3],cnu_msg_in[70][3],cnu_msg_in[69][3],cnu_msg_in[68][3],cnu_msg_in[67][3],cnu_msg_in[66][3],cnu_msg_in[65][3],cnu_msg_in[64][3],cnu_msg_in[63][3],cnu_msg_in[62][3],cnu_msg_in[61][3],cnu_msg_in[60][3],cnu_msg_in[59][3],cnu_msg_in[58][3],cnu_msg_in[57][3],cnu_msg_in[56][3],cnu_msg_in[55][3],cnu_msg_in[54][3],cnu_msg_in[53][3],cnu_msg_in[52][3],cnu_msg_in[51][3],cnu_msg_in[50][3],cnu_msg_in[49][3],cnu_msg_in[48][3],cnu_msg_in[47][3],cnu_msg_in[46][3],cnu_msg_in[45][3],cnu_msg_in[44][3],cnu_msg_in[43][3],cnu_msg_in[42][3],cnu_msg_in[41][3],cnu_msg_in[40][3],cnu_msg_in[39][3],cnu_msg_in[38][3],cnu_msg_in[37][3],cnu_msg_in[36][3],cnu_msg_in[35][3],cnu_msg_in[34][3],cnu_msg_in[33][3],cnu_msg_in[32][3],cnu_msg_in[31][3],cnu_msg_in[30][3],cnu_msg_in[29][3],cnu_msg_in[28][3],cnu_msg_in[27][3],cnu_msg_in[26][3],cnu_msg_in[25][3],cnu_msg_in[24][3],cnu_msg_in[23][3],cnu_msg_in[22][3],cnu_msg_in[21][3],cnu_msg_in[20][3],cnu_msg_in[19][3],cnu_msg_in[18][3],cnu_msg_in[17][3],cnu_msg_in[16][3],cnu_msg_in[15][3],cnu_msg_in[14][3],cnu_msg_in[13][3],cnu_msg_in[12][3],cnu_msg_in[11][3],cnu_msg_in[10][3],cnu_msg_in[9][3],cnu_msg_in[8][3],cnu_msg_in[7][3],cnu_msg_in[6][3],cnu_msg_in[5][3],cnu_msg_in[4][3],cnu_msg_in[3][3],cnu_msg_in[2][3],cnu_msg_in[1][3],cnu_msg_in[0][3]}),
	.sys_clk	(read_clk),
	.rstn	(rstn),
	.sw_in_bit0	(cnu_bs_in_bit[0]),
	.sw_in_bit1	(cnu_bs_in_bit[1]),
	.sw_in_bit2	(cnu_bs_in_bit[2]),
	.sw_in_bit3	(cnu_bs_in_bit[3]),
	.left_sel	(cnu_left_sel),
	.right_sel	(cnu_right_sel),
	.merge_sel	(cnu_merge_sel)
);
qsn_controller #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) cnu_qsn_controller_u0 (
	.left_sel     (cnu_left_sel ),
	.right_sel    (cnu_right_sel),
	.merge_sel    (cnu_merge_sel),
	.shift_factor (c2v_shift_factor_cur_0), // offset shift factor of submatrix_1
	.rstn         (rstn),
	.sys_clk      (read_clk)
);
/*----------------------------------------------*/
// Circular shifter of variable nodes
reg [CHECK_PARALLELISM-1:0] vnu_signExtenOut_reg [0:SIGN_EXTEN_FF_TO_BS-1];
shared_qsn_top #(
	.QUAN_SIZE(QUAN_SIZE),
	.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR)
) inst_shared_qsn_top_u0 (
	.sw_out_bit0 ({vnu_msg_in[254][0],vnu_msg_in[253][0],vnu_msg_in[252][0],vnu_msg_in[251][0],vnu_msg_in[250][0],vnu_msg_in[249][0],vnu_msg_in[248][0],vnu_msg_in[247][0],vnu_msg_in[246][0],vnu_msg_in[245][0],vnu_msg_in[244][0],vnu_msg_in[243][0],vnu_msg_in[242][0],vnu_msg_in[241][0],vnu_msg_in[240][0],vnu_msg_in[239][0],vnu_msg_in[238][0],vnu_msg_in[237][0],vnu_msg_in[236][0],vnu_msg_in[235][0],vnu_msg_in[234][0],vnu_msg_in[233][0],vnu_msg_in[232][0],vnu_msg_in[231][0],vnu_msg_in[230][0],vnu_msg_in[229][0],vnu_msg_in[228][0],vnu_msg_in[227][0],vnu_msg_in[226][0],vnu_msg_in[225][0],vnu_msg_in[224][0],vnu_msg_in[223][0],vnu_msg_in[222][0],vnu_msg_in[221][0],vnu_msg_in[220][0],vnu_msg_in[219][0],vnu_msg_in[218][0],vnu_msg_in[217][0],vnu_msg_in[216][0],vnu_msg_in[215][0],vnu_msg_in[214][0],vnu_msg_in[213][0],vnu_msg_in[212][0],vnu_msg_in[211][0],vnu_msg_in[210][0],vnu_msg_in[209][0],vnu_msg_in[208][0],vnu_msg_in[207][0],vnu_msg_in[206][0],vnu_msg_in[205][0],vnu_msg_in[204][0],vnu_msg_in[203][0],vnu_msg_in[202][0],vnu_msg_in[201][0],vnu_msg_in[200][0],vnu_msg_in[199][0],vnu_msg_in[198][0],vnu_msg_in[197][0],vnu_msg_in[196][0],vnu_msg_in[195][0],vnu_msg_in[194][0],vnu_msg_in[193][0],vnu_msg_in[192][0],vnu_msg_in[191][0],vnu_msg_in[190][0],vnu_msg_in[189][0],vnu_msg_in[188][0],vnu_msg_in[187][0],vnu_msg_in[186][0],vnu_msg_in[185][0],vnu_msg_in[184][0],vnu_msg_in[183][0],vnu_msg_in[182][0],vnu_msg_in[181][0],vnu_msg_in[180][0],vnu_msg_in[179][0],vnu_msg_in[178][0],vnu_msg_in[177][0],vnu_msg_in[176][0],vnu_msg_in[175][0],vnu_msg_in[174][0],vnu_msg_in[173][0],vnu_msg_in[172][0],vnu_msg_in[171][0],vnu_msg_in[170][0],vnu_msg_in[169][0],vnu_msg_in[168][0],vnu_msg_in[167][0],vnu_msg_in[166][0],vnu_msg_in[165][0],vnu_msg_in[164][0],vnu_msg_in[163][0],vnu_msg_in[162][0],vnu_msg_in[161][0],vnu_msg_in[160][0],vnu_msg_in[159][0],vnu_msg_in[158][0],vnu_msg_in[157][0],vnu_msg_in[156][0],vnu_msg_in[155][0],vnu_msg_in[154][0],vnu_msg_in[153][0],vnu_msg_in[152][0],vnu_msg_in[151][0],vnu_msg_in[150][0],vnu_msg_in[149][0],vnu_msg_in[148][0],vnu_msg_in[147][0],vnu_msg_in[146][0],vnu_msg_in[145][0],vnu_msg_in[144][0],vnu_msg_in[143][0],vnu_msg_in[142][0],vnu_msg_in[141][0],vnu_msg_in[140][0],vnu_msg_in[139][0],vnu_msg_in[138][0],vnu_msg_in[137][0],vnu_msg_in[136][0],vnu_msg_in[135][0],vnu_msg_in[134][0],vnu_msg_in[133][0],vnu_msg_in[132][0],vnu_msg_in[131][0],vnu_msg_in[130][0],vnu_msg_in[129][0],vnu_msg_in[128][0],vnu_msg_in[127][0],vnu_msg_in[126][0],vnu_msg_in[125][0],vnu_msg_in[124][0],vnu_msg_in[123][0],vnu_msg_in[122][0],vnu_msg_in[121][0],vnu_msg_in[120][0],vnu_msg_in[119][0],vnu_msg_in[118][0],vnu_msg_in[117][0],vnu_msg_in[116][0],vnu_msg_in[115][0],vnu_msg_in[114][0],vnu_msg_in[113][0],vnu_msg_in[112][0],vnu_msg_in[111][0],vnu_msg_in[110][0],vnu_msg_in[109][0],vnu_msg_in[108][0],vnu_msg_in[107][0],vnu_msg_in[106][0],vnu_msg_in[105][0],vnu_msg_in[104][0],vnu_msg_in[103][0],vnu_msg_in[102][0],vnu_msg_in[101][0],vnu_msg_in[100][0],vnu_msg_in[99][0],vnu_msg_in[98][0],vnu_msg_in[97][0],vnu_msg_in[96][0],vnu_msg_in[95][0],vnu_msg_in[94][0],vnu_msg_in[93][0],vnu_msg_in[92][0],vnu_msg_in[91][0],vnu_msg_in[90][0],vnu_msg_in[89][0],vnu_msg_in[88][0],vnu_msg_in[87][0],vnu_msg_in[86][0],vnu_msg_in[85][0],vnu_msg_in[84][0],vnu_msg_in[83][0],vnu_msg_in[82][0],vnu_msg_in[81][0],vnu_msg_in[80][0],vnu_msg_in[79][0],vnu_msg_in[78][0],vnu_msg_in[77][0],vnu_msg_in[76][0],vnu_msg_in[75][0],vnu_msg_in[74][0],vnu_msg_in[73][0],vnu_msg_in[72][0],vnu_msg_in[71][0],vnu_msg_in[70][0],vnu_msg_in[69][0],vnu_msg_in[68][0],vnu_msg_in[67][0],vnu_msg_in[66][0],vnu_msg_in[65][0],vnu_msg_in[64][0],vnu_msg_in[63][0],vnu_msg_in[62][0],vnu_msg_in[61][0],vnu_msg_in[60][0],vnu_msg_in[59][0],vnu_msg_in[58][0],vnu_msg_in[57][0],vnu_msg_in[56][0],vnu_msg_in[55][0],vnu_msg_in[54][0],vnu_msg_in[53][0],vnu_msg_in[52][0],vnu_msg_in[51][0],vnu_msg_in[50][0],vnu_msg_in[49][0],vnu_msg_in[48][0],vnu_msg_in[47][0],vnu_msg_in[46][0],vnu_msg_in[45][0],vnu_msg_in[44][0],vnu_msg_in[43][0],vnu_msg_in[42][0],vnu_msg_in[41][0],vnu_msg_in[40][0],vnu_msg_in[39][0],vnu_msg_in[38][0],vnu_msg_in[37][0],vnu_msg_in[36][0],vnu_msg_in[35][0],vnu_msg_in[34][0],vnu_msg_in[33][0],vnu_msg_in[32][0],vnu_msg_in[31][0],vnu_msg_in[30][0],vnu_msg_in[29][0],vnu_msg_in[28][0],vnu_msg_in[27][0],vnu_msg_in[26][0],vnu_msg_in[25][0],vnu_msg_in[24][0],vnu_msg_in[23][0],vnu_msg_in[22][0],vnu_msg_in[21][0],vnu_msg_in[20][0],vnu_msg_in[19][0],vnu_msg_in[18][0],vnu_msg_in[17][0],vnu_msg_in[16][0],vnu_msg_in[15][0],vnu_msg_in[14][0],vnu_msg_in[13][0],vnu_msg_in[12][0],vnu_msg_in[11][0],vnu_msg_in[10][0],vnu_msg_in[9][0],vnu_msg_in[8][0],vnu_msg_in[7][0],vnu_msg_in[6][0],vnu_msg_in[5][0],vnu_msg_in[4][0],vnu_msg_in[3][0],vnu_msg_in[2][0],vnu_msg_in[1][0],vnu_msg_in[0][0]}),
	.sw_out_bit1 ({vnu_msg_in[254][1],vnu_msg_in[253][1],vnu_msg_in[252][1],vnu_msg_in[251][1],vnu_msg_in[250][1],vnu_msg_in[249][1],vnu_msg_in[248][1],vnu_msg_in[247][1],vnu_msg_in[246][1],vnu_msg_in[245][1],vnu_msg_in[244][1],vnu_msg_in[243][1],vnu_msg_in[242][1],vnu_msg_in[241][1],vnu_msg_in[240][1],vnu_msg_in[239][1],vnu_msg_in[238][1],vnu_msg_in[237][1],vnu_msg_in[236][1],vnu_msg_in[235][1],vnu_msg_in[234][1],vnu_msg_in[233][1],vnu_msg_in[232][1],vnu_msg_in[231][1],vnu_msg_in[230][1],vnu_msg_in[229][1],vnu_msg_in[228][1],vnu_msg_in[227][1],vnu_msg_in[226][1],vnu_msg_in[225][1],vnu_msg_in[224][1],vnu_msg_in[223][1],vnu_msg_in[222][1],vnu_msg_in[221][1],vnu_msg_in[220][1],vnu_msg_in[219][1],vnu_msg_in[218][1],vnu_msg_in[217][1],vnu_msg_in[216][1],vnu_msg_in[215][1],vnu_msg_in[214][1],vnu_msg_in[213][1],vnu_msg_in[212][1],vnu_msg_in[211][1],vnu_msg_in[210][1],vnu_msg_in[209][1],vnu_msg_in[208][1],vnu_msg_in[207][1],vnu_msg_in[206][1],vnu_msg_in[205][1],vnu_msg_in[204][1],vnu_msg_in[203][1],vnu_msg_in[202][1],vnu_msg_in[201][1],vnu_msg_in[200][1],vnu_msg_in[199][1],vnu_msg_in[198][1],vnu_msg_in[197][1],vnu_msg_in[196][1],vnu_msg_in[195][1],vnu_msg_in[194][1],vnu_msg_in[193][1],vnu_msg_in[192][1],vnu_msg_in[191][1],vnu_msg_in[190][1],vnu_msg_in[189][1],vnu_msg_in[188][1],vnu_msg_in[187][1],vnu_msg_in[186][1],vnu_msg_in[185][1],vnu_msg_in[184][1],vnu_msg_in[183][1],vnu_msg_in[182][1],vnu_msg_in[181][1],vnu_msg_in[180][1],vnu_msg_in[179][1],vnu_msg_in[178][1],vnu_msg_in[177][1],vnu_msg_in[176][1],vnu_msg_in[175][1],vnu_msg_in[174][1],vnu_msg_in[173][1],vnu_msg_in[172][1],vnu_msg_in[171][1],vnu_msg_in[170][1],vnu_msg_in[169][1],vnu_msg_in[168][1],vnu_msg_in[167][1],vnu_msg_in[166][1],vnu_msg_in[165][1],vnu_msg_in[164][1],vnu_msg_in[163][1],vnu_msg_in[162][1],vnu_msg_in[161][1],vnu_msg_in[160][1],vnu_msg_in[159][1],vnu_msg_in[158][1],vnu_msg_in[157][1],vnu_msg_in[156][1],vnu_msg_in[155][1],vnu_msg_in[154][1],vnu_msg_in[153][1],vnu_msg_in[152][1],vnu_msg_in[151][1],vnu_msg_in[150][1],vnu_msg_in[149][1],vnu_msg_in[148][1],vnu_msg_in[147][1],vnu_msg_in[146][1],vnu_msg_in[145][1],vnu_msg_in[144][1],vnu_msg_in[143][1],vnu_msg_in[142][1],vnu_msg_in[141][1],vnu_msg_in[140][1],vnu_msg_in[139][1],vnu_msg_in[138][1],vnu_msg_in[137][1],vnu_msg_in[136][1],vnu_msg_in[135][1],vnu_msg_in[134][1],vnu_msg_in[133][1],vnu_msg_in[132][1],vnu_msg_in[131][1],vnu_msg_in[130][1],vnu_msg_in[129][1],vnu_msg_in[128][1],vnu_msg_in[127][1],vnu_msg_in[126][1],vnu_msg_in[125][1],vnu_msg_in[124][1],vnu_msg_in[123][1],vnu_msg_in[122][1],vnu_msg_in[121][1],vnu_msg_in[120][1],vnu_msg_in[119][1],vnu_msg_in[118][1],vnu_msg_in[117][1],vnu_msg_in[116][1],vnu_msg_in[115][1],vnu_msg_in[114][1],vnu_msg_in[113][1],vnu_msg_in[112][1],vnu_msg_in[111][1],vnu_msg_in[110][1],vnu_msg_in[109][1],vnu_msg_in[108][1],vnu_msg_in[107][1],vnu_msg_in[106][1],vnu_msg_in[105][1],vnu_msg_in[104][1],vnu_msg_in[103][1],vnu_msg_in[102][1],vnu_msg_in[101][1],vnu_msg_in[100][1],vnu_msg_in[99][1],vnu_msg_in[98][1],vnu_msg_in[97][1],vnu_msg_in[96][1],vnu_msg_in[95][1],vnu_msg_in[94][1],vnu_msg_in[93][1],vnu_msg_in[92][1],vnu_msg_in[91][1],vnu_msg_in[90][1],vnu_msg_in[89][1],vnu_msg_in[88][1],vnu_msg_in[87][1],vnu_msg_in[86][1],vnu_msg_in[85][1],vnu_msg_in[84][1],vnu_msg_in[83][1],vnu_msg_in[82][1],vnu_msg_in[81][1],vnu_msg_in[80][1],vnu_msg_in[79][1],vnu_msg_in[78][1],vnu_msg_in[77][1],vnu_msg_in[76][1],vnu_msg_in[75][1],vnu_msg_in[74][1],vnu_msg_in[73][1],vnu_msg_in[72][1],vnu_msg_in[71][1],vnu_msg_in[70][1],vnu_msg_in[69][1],vnu_msg_in[68][1],vnu_msg_in[67][1],vnu_msg_in[66][1],vnu_msg_in[65][1],vnu_msg_in[64][1],vnu_msg_in[63][1],vnu_msg_in[62][1],vnu_msg_in[61][1],vnu_msg_in[60][1],vnu_msg_in[59][1],vnu_msg_in[58][1],vnu_msg_in[57][1],vnu_msg_in[56][1],vnu_msg_in[55][1],vnu_msg_in[54][1],vnu_msg_in[53][1],vnu_msg_in[52][1],vnu_msg_in[51][1],vnu_msg_in[50][1],vnu_msg_in[49][1],vnu_msg_in[48][1],vnu_msg_in[47][1],vnu_msg_in[46][1],vnu_msg_in[45][1],vnu_msg_in[44][1],vnu_msg_in[43][1],vnu_msg_in[42][1],vnu_msg_in[41][1],vnu_msg_in[40][1],vnu_msg_in[39][1],vnu_msg_in[38][1],vnu_msg_in[37][1],vnu_msg_in[36][1],vnu_msg_in[35][1],vnu_msg_in[34][1],vnu_msg_in[33][1],vnu_msg_in[32][1],vnu_msg_in[31][1],vnu_msg_in[30][1],vnu_msg_in[29][1],vnu_msg_in[28][1],vnu_msg_in[27][1],vnu_msg_in[26][1],vnu_msg_in[25][1],vnu_msg_in[24][1],vnu_msg_in[23][1],vnu_msg_in[22][1],vnu_msg_in[21][1],vnu_msg_in[20][1],vnu_msg_in[19][1],vnu_msg_in[18][1],vnu_msg_in[17][1],vnu_msg_in[16][1],vnu_msg_in[15][1],vnu_msg_in[14][1],vnu_msg_in[13][1],vnu_msg_in[12][1],vnu_msg_in[11][1],vnu_msg_in[10][1],vnu_msg_in[9][1],vnu_msg_in[8][1],vnu_msg_in[7][1],vnu_msg_in[6][1],vnu_msg_in[5][1],vnu_msg_in[4][1],vnu_msg_in[3][1],vnu_msg_in[2][1],vnu_msg_in[1][1],vnu_msg_in[0][1]}),
	.sw_out_bit2 ({vnu_msg_in[254][2],vnu_msg_in[253][2],vnu_msg_in[252][2],vnu_msg_in[251][2],vnu_msg_in[250][2],vnu_msg_in[249][2],vnu_msg_in[248][2],vnu_msg_in[247][2],vnu_msg_in[246][2],vnu_msg_in[245][2],vnu_msg_in[244][2],vnu_msg_in[243][2],vnu_msg_in[242][2],vnu_msg_in[241][2],vnu_msg_in[240][2],vnu_msg_in[239][2],vnu_msg_in[238][2],vnu_msg_in[237][2],vnu_msg_in[236][2],vnu_msg_in[235][2],vnu_msg_in[234][2],vnu_msg_in[233][2],vnu_msg_in[232][2],vnu_msg_in[231][2],vnu_msg_in[230][2],vnu_msg_in[229][2],vnu_msg_in[228][2],vnu_msg_in[227][2],vnu_msg_in[226][2],vnu_msg_in[225][2],vnu_msg_in[224][2],vnu_msg_in[223][2],vnu_msg_in[222][2],vnu_msg_in[221][2],vnu_msg_in[220][2],vnu_msg_in[219][2],vnu_msg_in[218][2],vnu_msg_in[217][2],vnu_msg_in[216][2],vnu_msg_in[215][2],vnu_msg_in[214][2],vnu_msg_in[213][2],vnu_msg_in[212][2],vnu_msg_in[211][2],vnu_msg_in[210][2],vnu_msg_in[209][2],vnu_msg_in[208][2],vnu_msg_in[207][2],vnu_msg_in[206][2],vnu_msg_in[205][2],vnu_msg_in[204][2],vnu_msg_in[203][2],vnu_msg_in[202][2],vnu_msg_in[201][2],vnu_msg_in[200][2],vnu_msg_in[199][2],vnu_msg_in[198][2],vnu_msg_in[197][2],vnu_msg_in[196][2],vnu_msg_in[195][2],vnu_msg_in[194][2],vnu_msg_in[193][2],vnu_msg_in[192][2],vnu_msg_in[191][2],vnu_msg_in[190][2],vnu_msg_in[189][2],vnu_msg_in[188][2],vnu_msg_in[187][2],vnu_msg_in[186][2],vnu_msg_in[185][2],vnu_msg_in[184][2],vnu_msg_in[183][2],vnu_msg_in[182][2],vnu_msg_in[181][2],vnu_msg_in[180][2],vnu_msg_in[179][2],vnu_msg_in[178][2],vnu_msg_in[177][2],vnu_msg_in[176][2],vnu_msg_in[175][2],vnu_msg_in[174][2],vnu_msg_in[173][2],vnu_msg_in[172][2],vnu_msg_in[171][2],vnu_msg_in[170][2],vnu_msg_in[169][2],vnu_msg_in[168][2],vnu_msg_in[167][2],vnu_msg_in[166][2],vnu_msg_in[165][2],vnu_msg_in[164][2],vnu_msg_in[163][2],vnu_msg_in[162][2],vnu_msg_in[161][2],vnu_msg_in[160][2],vnu_msg_in[159][2],vnu_msg_in[158][2],vnu_msg_in[157][2],vnu_msg_in[156][2],vnu_msg_in[155][2],vnu_msg_in[154][2],vnu_msg_in[153][2],vnu_msg_in[152][2],vnu_msg_in[151][2],vnu_msg_in[150][2],vnu_msg_in[149][2],vnu_msg_in[148][2],vnu_msg_in[147][2],vnu_msg_in[146][2],vnu_msg_in[145][2],vnu_msg_in[144][2],vnu_msg_in[143][2],vnu_msg_in[142][2],vnu_msg_in[141][2],vnu_msg_in[140][2],vnu_msg_in[139][2],vnu_msg_in[138][2],vnu_msg_in[137][2],vnu_msg_in[136][2],vnu_msg_in[135][2],vnu_msg_in[134][2],vnu_msg_in[133][2],vnu_msg_in[132][2],vnu_msg_in[131][2],vnu_msg_in[130][2],vnu_msg_in[129][2],vnu_msg_in[128][2],vnu_msg_in[127][2],vnu_msg_in[126][2],vnu_msg_in[125][2],vnu_msg_in[124][2],vnu_msg_in[123][2],vnu_msg_in[122][2],vnu_msg_in[121][2],vnu_msg_in[120][2],vnu_msg_in[119][2],vnu_msg_in[118][2],vnu_msg_in[117][2],vnu_msg_in[116][2],vnu_msg_in[115][2],vnu_msg_in[114][2],vnu_msg_in[113][2],vnu_msg_in[112][2],vnu_msg_in[111][2],vnu_msg_in[110][2],vnu_msg_in[109][2],vnu_msg_in[108][2],vnu_msg_in[107][2],vnu_msg_in[106][2],vnu_msg_in[105][2],vnu_msg_in[104][2],vnu_msg_in[103][2],vnu_msg_in[102][2],vnu_msg_in[101][2],vnu_msg_in[100][2],vnu_msg_in[99][2],vnu_msg_in[98][2],vnu_msg_in[97][2],vnu_msg_in[96][2],vnu_msg_in[95][2],vnu_msg_in[94][2],vnu_msg_in[93][2],vnu_msg_in[92][2],vnu_msg_in[91][2],vnu_msg_in[90][2],vnu_msg_in[89][2],vnu_msg_in[88][2],vnu_msg_in[87][2],vnu_msg_in[86][2],vnu_msg_in[85][2],vnu_msg_in[84][2],vnu_msg_in[83][2],vnu_msg_in[82][2],vnu_msg_in[81][2],vnu_msg_in[80][2],vnu_msg_in[79][2],vnu_msg_in[78][2],vnu_msg_in[77][2],vnu_msg_in[76][2],vnu_msg_in[75][2],vnu_msg_in[74][2],vnu_msg_in[73][2],vnu_msg_in[72][2],vnu_msg_in[71][2],vnu_msg_in[70][2],vnu_msg_in[69][2],vnu_msg_in[68][2],vnu_msg_in[67][2],vnu_msg_in[66][2],vnu_msg_in[65][2],vnu_msg_in[64][2],vnu_msg_in[63][2],vnu_msg_in[62][2],vnu_msg_in[61][2],vnu_msg_in[60][2],vnu_msg_in[59][2],vnu_msg_in[58][2],vnu_msg_in[57][2],vnu_msg_in[56][2],vnu_msg_in[55][2],vnu_msg_in[54][2],vnu_msg_in[53][2],vnu_msg_in[52][2],vnu_msg_in[51][2],vnu_msg_in[50][2],vnu_msg_in[49][2],vnu_msg_in[48][2],vnu_msg_in[47][2],vnu_msg_in[46][2],vnu_msg_in[45][2],vnu_msg_in[44][2],vnu_msg_in[43][2],vnu_msg_in[42][2],vnu_msg_in[41][2],vnu_msg_in[40][2],vnu_msg_in[39][2],vnu_msg_in[38][2],vnu_msg_in[37][2],vnu_msg_in[36][2],vnu_msg_in[35][2],vnu_msg_in[34][2],vnu_msg_in[33][2],vnu_msg_in[32][2],vnu_msg_in[31][2],vnu_msg_in[30][2],vnu_msg_in[29][2],vnu_msg_in[28][2],vnu_msg_in[27][2],vnu_msg_in[26][2],vnu_msg_in[25][2],vnu_msg_in[24][2],vnu_msg_in[23][2],vnu_msg_in[22][2],vnu_msg_in[21][2],vnu_msg_in[20][2],vnu_msg_in[19][2],vnu_msg_in[18][2],vnu_msg_in[17][2],vnu_msg_in[16][2],vnu_msg_in[15][2],vnu_msg_in[14][2],vnu_msg_in[13][2],vnu_msg_in[12][2],vnu_msg_in[11][2],vnu_msg_in[10][2],vnu_msg_in[9][2],vnu_msg_in[8][2],vnu_msg_in[7][2],vnu_msg_in[6][2],vnu_msg_in[5][2],vnu_msg_in[4][2],vnu_msg_in[3][2],vnu_msg_in[2][2],vnu_msg_in[1][2],vnu_msg_in[0][2]}),
	.sw_out_bit3 ({vnu_msg_in[254][3],vnu_msg_in[253][3],vnu_msg_in[252][3],vnu_msg_in[251][3],vnu_msg_in[250][3],vnu_msg_in[249][3],vnu_msg_in[248][3],vnu_msg_in[247][3],vnu_msg_in[246][3],vnu_msg_in[245][3],vnu_msg_in[244][3],vnu_msg_in[243][3],vnu_msg_in[242][3],vnu_msg_in[241][3],vnu_msg_in[240][3],vnu_msg_in[239][3],vnu_msg_in[238][3],vnu_msg_in[237][3],vnu_msg_in[236][3],vnu_msg_in[235][3],vnu_msg_in[234][3],vnu_msg_in[233][3],vnu_msg_in[232][3],vnu_msg_in[231][3],vnu_msg_in[230][3],vnu_msg_in[229][3],vnu_msg_in[228][3],vnu_msg_in[227][3],vnu_msg_in[226][3],vnu_msg_in[225][3],vnu_msg_in[224][3],vnu_msg_in[223][3],vnu_msg_in[222][3],vnu_msg_in[221][3],vnu_msg_in[220][3],vnu_msg_in[219][3],vnu_msg_in[218][3],vnu_msg_in[217][3],vnu_msg_in[216][3],vnu_msg_in[215][3],vnu_msg_in[214][3],vnu_msg_in[213][3],vnu_msg_in[212][3],vnu_msg_in[211][3],vnu_msg_in[210][3],vnu_msg_in[209][3],vnu_msg_in[208][3],vnu_msg_in[207][3],vnu_msg_in[206][3],vnu_msg_in[205][3],vnu_msg_in[204][3],vnu_msg_in[203][3],vnu_msg_in[202][3],vnu_msg_in[201][3],vnu_msg_in[200][3],vnu_msg_in[199][3],vnu_msg_in[198][3],vnu_msg_in[197][3],vnu_msg_in[196][3],vnu_msg_in[195][3],vnu_msg_in[194][3],vnu_msg_in[193][3],vnu_msg_in[192][3],vnu_msg_in[191][3],vnu_msg_in[190][3],vnu_msg_in[189][3],vnu_msg_in[188][3],vnu_msg_in[187][3],vnu_msg_in[186][3],vnu_msg_in[185][3],vnu_msg_in[184][3],vnu_msg_in[183][3],vnu_msg_in[182][3],vnu_msg_in[181][3],vnu_msg_in[180][3],vnu_msg_in[179][3],vnu_msg_in[178][3],vnu_msg_in[177][3],vnu_msg_in[176][3],vnu_msg_in[175][3],vnu_msg_in[174][3],vnu_msg_in[173][3],vnu_msg_in[172][3],vnu_msg_in[171][3],vnu_msg_in[170][3],vnu_msg_in[169][3],vnu_msg_in[168][3],vnu_msg_in[167][3],vnu_msg_in[166][3],vnu_msg_in[165][3],vnu_msg_in[164][3],vnu_msg_in[163][3],vnu_msg_in[162][3],vnu_msg_in[161][3],vnu_msg_in[160][3],vnu_msg_in[159][3],vnu_msg_in[158][3],vnu_msg_in[157][3],vnu_msg_in[156][3],vnu_msg_in[155][3],vnu_msg_in[154][3],vnu_msg_in[153][3],vnu_msg_in[152][3],vnu_msg_in[151][3],vnu_msg_in[150][3],vnu_msg_in[149][3],vnu_msg_in[148][3],vnu_msg_in[147][3],vnu_msg_in[146][3],vnu_msg_in[145][3],vnu_msg_in[144][3],vnu_msg_in[143][3],vnu_msg_in[142][3],vnu_msg_in[141][3],vnu_msg_in[140][3],vnu_msg_in[139][3],vnu_msg_in[138][3],vnu_msg_in[137][3],vnu_msg_in[136][3],vnu_msg_in[135][3],vnu_msg_in[134][3],vnu_msg_in[133][3],vnu_msg_in[132][3],vnu_msg_in[131][3],vnu_msg_in[130][3],vnu_msg_in[129][3],vnu_msg_in[128][3],vnu_msg_in[127][3],vnu_msg_in[126][3],vnu_msg_in[125][3],vnu_msg_in[124][3],vnu_msg_in[123][3],vnu_msg_in[122][3],vnu_msg_in[121][3],vnu_msg_in[120][3],vnu_msg_in[119][3],vnu_msg_in[118][3],vnu_msg_in[117][3],vnu_msg_in[116][3],vnu_msg_in[115][3],vnu_msg_in[114][3],vnu_msg_in[113][3],vnu_msg_in[112][3],vnu_msg_in[111][3],vnu_msg_in[110][3],vnu_msg_in[109][3],vnu_msg_in[108][3],vnu_msg_in[107][3],vnu_msg_in[106][3],vnu_msg_in[105][3],vnu_msg_in[104][3],vnu_msg_in[103][3],vnu_msg_in[102][3],vnu_msg_in[101][3],vnu_msg_in[100][3],vnu_msg_in[99][3],vnu_msg_in[98][3],vnu_msg_in[97][3],vnu_msg_in[96][3],vnu_msg_in[95][3],vnu_msg_in[94][3],vnu_msg_in[93][3],vnu_msg_in[92][3],vnu_msg_in[91][3],vnu_msg_in[90][3],vnu_msg_in[89][3],vnu_msg_in[88][3],vnu_msg_in[87][3],vnu_msg_in[86][3],vnu_msg_in[85][3],vnu_msg_in[84][3],vnu_msg_in[83][3],vnu_msg_in[82][3],vnu_msg_in[81][3],vnu_msg_in[80][3],vnu_msg_in[79][3],vnu_msg_in[78][3],vnu_msg_in[77][3],vnu_msg_in[76][3],vnu_msg_in[75][3],vnu_msg_in[74][3],vnu_msg_in[73][3],vnu_msg_in[72][3],vnu_msg_in[71][3],vnu_msg_in[70][3],vnu_msg_in[69][3],vnu_msg_in[68][3],vnu_msg_in[67][3],vnu_msg_in[66][3],vnu_msg_in[65][3],vnu_msg_in[64][3],vnu_msg_in[63][3],vnu_msg_in[62][3],vnu_msg_in[61][3],vnu_msg_in[60][3],vnu_msg_in[59][3],vnu_msg_in[58][3],vnu_msg_in[57][3],vnu_msg_in[56][3],vnu_msg_in[55][3],vnu_msg_in[54][3],vnu_msg_in[53][3],vnu_msg_in[52][3],vnu_msg_in[51][3],vnu_msg_in[50][3],vnu_msg_in[49][3],vnu_msg_in[48][3],vnu_msg_in[47][3],vnu_msg_in[46][3],vnu_msg_in[45][3],vnu_msg_in[44][3],vnu_msg_in[43][3],vnu_msg_in[42][3],vnu_msg_in[41][3],vnu_msg_in[40][3],vnu_msg_in[39][3],vnu_msg_in[38][3],vnu_msg_in[37][3],vnu_msg_in[36][3],vnu_msg_in[35][3],vnu_msg_in[34][3],vnu_msg_in[33][3],vnu_msg_in[32][3],vnu_msg_in[31][3],vnu_msg_in[30][3],vnu_msg_in[29][3],vnu_msg_in[28][3],vnu_msg_in[27][3],vnu_msg_in[26][3],vnu_msg_in[25][3],vnu_msg_in[24][3],vnu_msg_in[23][3],vnu_msg_in[22][3],vnu_msg_in[21][3],vnu_msg_in[20][3],vnu_msg_in[19][3],vnu_msg_in[18][3],vnu_msg_in[17][3],vnu_msg_in[16][3],vnu_msg_in[15][3],vnu_msg_in[14][3],vnu_msg_in[13][3],vnu_msg_in[12][3],vnu_msg_in[11][3],vnu_msg_in[10][3],vnu_msg_in[9][3],vnu_msg_in[8][3],vnu_msg_in[7][3],vnu_msg_in[6][3],vnu_msg_in[5][3],vnu_msg_in[4][3],vnu_msg_in[3][3],vnu_msg_in[2][3],vnu_msg_in[1][3],vnu_msg_in[0][3]}),
	
	.sys_clk	(read_clk),
	.rstn	(rstn),
	
	.sw_in0_bit0	(vnu_bs_in_bit[0]),
	.sw_in0_bit1	(vnu_bs_in_bit[1]),
	.sw_in0_bit2	(vnu_bs_in_bit[2]),
	.sw_in0_bit3	(vnu_bs_in_bit[3]),
	
	.sw_in1_bit0	(ch_bs_in_bit[0]),
	.sw_in1_bit1	(ch_bs_in_bit[1]),
	.sw_in1_bit2	(ch_bs_in_bit[2]),
	.sw_in1_bit3	(ch_bs_in_bit[3]),
	
	.sw_in2_bit0	(vnu_signExtenOut_reg[SIGN_EXTEN_FF_TO_BS-1]),
	
	.shift_factor	(vnu_shift_factorIn), // offset shift factor of submatrix
	.sw_in_bit0_src	(vnu_bs_bit0_src),
	.sw_in_src	(vnu_bs_src)
);
assign vnu_shift_factorIn = (vnu_bs_bit0_src[0] == 1'b1) ? v2c_shift_factor_cur_0 :
							(vnu_bs_bit0_src[1] == 1'b1) ? ch_ramRD_shift_factor_cur_0 :
							(vnu_bs_bit0_src[2] == 1'b1) ? dnu_inRotate_shift_factor : v2c_shift_factor_cur_0;
	
always @(posedge read_clk) begin if(!rstn) vnu_signExtenOut_reg[0] <= 0; else if(v2c_outRotate_reg_we) vnu_signExtenOut_reg[0] <= dnu_inRotate_bit[CHECK_PARALLELISM-1:0]; else if(v2c_outRotate_reg_we_flush) vnu_signExtenOut_reg[0] <= 0; end
genvar signExten_ff_id;
generate
	for(signExten_ff_id=1; signExten_ff_id<SIGN_EXTEN_FF_TO_BS; signExten_ff_id=signExten_ff_id+1) begin : sign_exten_ff_inst
		always @(posedge read_clk) begin if(!rstn) vnu_signExtenOut_reg[signExten_ff_id] <= 0; else if(v2c_outRotate_reg_we) vnu_signExtenOut_reg[signExten_ff_id] <= vnu_signExtenOut_reg[signExten_ff_id-1]; else if(v2c_outRotate_reg_we_flush) vnu_signExtenOut_reg[signExten_ff_id] <= vnu_signExtenOut_reg[signExten_ff_id-1]; end
	end
endgenerate
/*----------------------------------------------*/
reg [ADDR_WIDTH-1:0] c2v_mem_page_addr; // page-write addresses
reg [ADDR_WIDTH-1:0] v2c_mem_page_addr; // page-write addresses
reg [ADDR_WIDTH-1:0] c2v_mem_page_rd_addr; // page-read addresses
reg [ADDR_WIDTH-1:0] v2c_mem_page_rd_addr; // page-read addresses
wire [ADDR_WIDTH-1:0] cnu_mem_page_sync_addr; // synchornous page-access addresses
wire [ADDR_WIDTH-1:0] vnu_mem_page_sync_addr; // synchornous page-access addresses
wire [CHECK_PARALLELISM-1:0] dnu_signExten_wire;
wire [LAYER_NUM-1:0] vnu_layer_cnt_sync;
parital_mem_subsystem_top_submatrix_1_3_5_7_9 #(
	.QUAN_SIZE(QUAN_SIZE),
	.CHECK_PARALLELISM(CHECK_PARALLELISM),
	.LAYER_NUM(LAYER_NUM),
	.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
	.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
	.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
	.DEPTH(DEPTH),
	.DATA_WIDTH(DATA_WIDTH),
	.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH)
) inst_parital_mem_subsystem_top_submatrix_1_3_5_7_9 (
	.vnu_pa_msg_bit0		(dnu_signExten_wire[CHECK_PARALLELISM-1:0]),
	.pa_to_ch_ram		(pa_to_ch_ram[CH_DATA_WIDTH-1:0]),
	.mem_to_vnu_0		(mem_to_vnu[(0+1)*QUAN_SIZE-1:0*QUAN_SIZE]),
	.mem_to_vnu_1		(mem_to_vnu[(1+1)*QUAN_SIZE-1:1*QUAN_SIZE]),
	.mem_to_vnu_2		(mem_to_vnu[(2+1)*QUAN_SIZE-1:2*QUAN_SIZE]),
	.mem_to_vnu_3		(mem_to_vnu[(3+1)*QUAN_SIZE-1:3*QUAN_SIZE]),
	.mem_to_vnu_4		(mem_to_vnu[(4+1)*QUAN_SIZE-1:4*QUAN_SIZE]),
	.mem_to_vnu_5		(mem_to_vnu[(5+1)*QUAN_SIZE-1:5*QUAN_SIZE]),
	.mem_to_vnu_6		(mem_to_vnu[(6+1)*QUAN_SIZE-1:6*QUAN_SIZE]),
	.mem_to_vnu_7		(mem_to_vnu[(7+1)*QUAN_SIZE-1:7*QUAN_SIZE]),
	.mem_to_vnu_8		(mem_to_vnu[(8+1)*QUAN_SIZE-1:8*QUAN_SIZE]),
	.mem_to_vnu_9		(mem_to_vnu[(9+1)*QUAN_SIZE-1:9*QUAN_SIZE]),
	.mem_to_vnu_10		(mem_to_vnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
	.mem_to_vnu_11		(mem_to_vnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
	.mem_to_vnu_12		(mem_to_vnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
	.mem_to_vnu_13		(mem_to_vnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
	.mem_to_vnu_14		(mem_to_vnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
	.mem_to_vnu_15		(mem_to_vnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
	.mem_to_vnu_16		(mem_to_vnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
	.mem_to_vnu_17		(mem_to_vnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
	.mem_to_vnu_18		(mem_to_vnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
	.mem_to_vnu_19		(mem_to_vnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
	.mem_to_vnu_20		(mem_to_vnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
	.mem_to_vnu_21		(mem_to_vnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
	.mem_to_vnu_22		(mem_to_vnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
	.mem_to_vnu_23		(mem_to_vnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
	.mem_to_vnu_24		(mem_to_vnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
	.mem_to_vnu_25		(mem_to_vnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
	.mem_to_vnu_26		(mem_to_vnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
	.mem_to_vnu_27		(mem_to_vnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
	.mem_to_vnu_28		(mem_to_vnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
	.mem_to_vnu_29		(mem_to_vnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
	.mem_to_vnu_30		(mem_to_vnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
	.mem_to_vnu_31		(mem_to_vnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
	.mem_to_vnu_32		(mem_to_vnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
	.mem_to_vnu_33		(mem_to_vnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
	.mem_to_vnu_34		(mem_to_vnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
	.mem_to_vnu_35		(mem_to_vnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
	.mem_to_vnu_36		(mem_to_vnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
	.mem_to_vnu_37		(mem_to_vnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
	.mem_to_vnu_38		(mem_to_vnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
	.mem_to_vnu_39		(mem_to_vnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
	.mem_to_vnu_40		(mem_to_vnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
	.mem_to_vnu_41		(mem_to_vnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
	.mem_to_vnu_42		(mem_to_vnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
	.mem_to_vnu_43		(mem_to_vnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
	.mem_to_vnu_44		(mem_to_vnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
	.mem_to_vnu_45		(mem_to_vnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
	.mem_to_vnu_46		(mem_to_vnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
	.mem_to_vnu_47		(mem_to_vnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
	.mem_to_vnu_48		(mem_to_vnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
	.mem_to_vnu_49		(mem_to_vnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
	.mem_to_vnu_50		(mem_to_vnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
	.mem_to_vnu_51		(mem_to_vnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
	.mem_to_vnu_52		(mem_to_vnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
	.mem_to_vnu_53		(mem_to_vnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
	.mem_to_vnu_54		(mem_to_vnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
	.mem_to_vnu_55		(mem_to_vnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
	.mem_to_vnu_56		(mem_to_vnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
	.mem_to_vnu_57		(mem_to_vnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
	.mem_to_vnu_58		(mem_to_vnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
	.mem_to_vnu_59		(mem_to_vnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
	.mem_to_vnu_60		(mem_to_vnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
	.mem_to_vnu_61		(mem_to_vnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
	.mem_to_vnu_62		(mem_to_vnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
	.mem_to_vnu_63		(mem_to_vnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
	.mem_to_vnu_64		(mem_to_vnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
	.mem_to_vnu_65		(mem_to_vnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
	.mem_to_vnu_66		(mem_to_vnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
	.mem_to_vnu_67		(mem_to_vnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
	.mem_to_vnu_68		(mem_to_vnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
	.mem_to_vnu_69		(mem_to_vnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
	.mem_to_vnu_70		(mem_to_vnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
	.mem_to_vnu_71		(mem_to_vnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
	.mem_to_vnu_72		(mem_to_vnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
	.mem_to_vnu_73		(mem_to_vnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
	.mem_to_vnu_74		(mem_to_vnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
	.mem_to_vnu_75		(mem_to_vnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
	.mem_to_vnu_76		(mem_to_vnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
	.mem_to_vnu_77		(mem_to_vnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
	.mem_to_vnu_78		(mem_to_vnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
	.mem_to_vnu_79		(mem_to_vnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
	.mem_to_vnu_80		(mem_to_vnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
	.mem_to_vnu_81		(mem_to_vnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
	.mem_to_vnu_82		(mem_to_vnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
	.mem_to_vnu_83		(mem_to_vnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
	.mem_to_vnu_84		(mem_to_vnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),
	.mem_to_vnu_85		(mem_to_vnu[(85+1)*QUAN_SIZE-1:85*QUAN_SIZE]),
	.mem_to_vnu_86		(mem_to_vnu[(86+1)*QUAN_SIZE-1:86*QUAN_SIZE]),
	.mem_to_vnu_87		(mem_to_vnu[(87+1)*QUAN_SIZE-1:87*QUAN_SIZE]),
	.mem_to_vnu_88		(mem_to_vnu[(88+1)*QUAN_SIZE-1:88*QUAN_SIZE]),
	.mem_to_vnu_89		(mem_to_vnu[(89+1)*QUAN_SIZE-1:89*QUAN_SIZE]),
	.mem_to_vnu_90		(mem_to_vnu[(90+1)*QUAN_SIZE-1:90*QUAN_SIZE]),
	.mem_to_vnu_91		(mem_to_vnu[(91+1)*QUAN_SIZE-1:91*QUAN_SIZE]),
	.mem_to_vnu_92		(mem_to_vnu[(92+1)*QUAN_SIZE-1:92*QUAN_SIZE]),
	.mem_to_vnu_93		(mem_to_vnu[(93+1)*QUAN_SIZE-1:93*QUAN_SIZE]),
	.mem_to_vnu_94		(mem_to_vnu[(94+1)*QUAN_SIZE-1:94*QUAN_SIZE]),
	.mem_to_vnu_95		(mem_to_vnu[(95+1)*QUAN_SIZE-1:95*QUAN_SIZE]),
	.mem_to_vnu_96		(mem_to_vnu[(96+1)*QUAN_SIZE-1:96*QUAN_SIZE]),
	.mem_to_vnu_97		(mem_to_vnu[(97+1)*QUAN_SIZE-1:97*QUAN_SIZE]),
	.mem_to_vnu_98		(mem_to_vnu[(98+1)*QUAN_SIZE-1:98*QUAN_SIZE]),
	.mem_to_vnu_99		(mem_to_vnu[(99+1)*QUAN_SIZE-1:99*QUAN_SIZE]),
	.mem_to_vnu_100		(mem_to_vnu[(100+1)*QUAN_SIZE-1:100*QUAN_SIZE]),
	.mem_to_vnu_101		(mem_to_vnu[(101+1)*QUAN_SIZE-1:101*QUAN_SIZE]),
	.mem_to_vnu_102		(mem_to_vnu[(102+1)*QUAN_SIZE-1:102*QUAN_SIZE]),
	.mem_to_vnu_103		(mem_to_vnu[(103+1)*QUAN_SIZE-1:103*QUAN_SIZE]),
	.mem_to_vnu_104		(mem_to_vnu[(104+1)*QUAN_SIZE-1:104*QUAN_SIZE]),
	.mem_to_vnu_105		(mem_to_vnu[(105+1)*QUAN_SIZE-1:105*QUAN_SIZE]),
	.mem_to_vnu_106		(mem_to_vnu[(106+1)*QUAN_SIZE-1:106*QUAN_SIZE]),
	.mem_to_vnu_107		(mem_to_vnu[(107+1)*QUAN_SIZE-1:107*QUAN_SIZE]),
	.mem_to_vnu_108		(mem_to_vnu[(108+1)*QUAN_SIZE-1:108*QUAN_SIZE]),
	.mem_to_vnu_109		(mem_to_vnu[(109+1)*QUAN_SIZE-1:109*QUAN_SIZE]),
	.mem_to_vnu_110		(mem_to_vnu[(110+1)*QUAN_SIZE-1:110*QUAN_SIZE]),
	.mem_to_vnu_111		(mem_to_vnu[(111+1)*QUAN_SIZE-1:111*QUAN_SIZE]),
	.mem_to_vnu_112		(mem_to_vnu[(112+1)*QUAN_SIZE-1:112*QUAN_SIZE]),
	.mem_to_vnu_113		(mem_to_vnu[(113+1)*QUAN_SIZE-1:113*QUAN_SIZE]),
	.mem_to_vnu_114		(mem_to_vnu[(114+1)*QUAN_SIZE-1:114*QUAN_SIZE]),
	.mem_to_vnu_115		(mem_to_vnu[(115+1)*QUAN_SIZE-1:115*QUAN_SIZE]),
	.mem_to_vnu_116		(mem_to_vnu[(116+1)*QUAN_SIZE-1:116*QUAN_SIZE]),
	.mem_to_vnu_117		(mem_to_vnu[(117+1)*QUAN_SIZE-1:117*QUAN_SIZE]),
	.mem_to_vnu_118		(mem_to_vnu[(118+1)*QUAN_SIZE-1:118*QUAN_SIZE]),
	.mem_to_vnu_119		(mem_to_vnu[(119+1)*QUAN_SIZE-1:119*QUAN_SIZE]),
	.mem_to_vnu_120		(mem_to_vnu[(120+1)*QUAN_SIZE-1:120*QUAN_SIZE]),
	.mem_to_vnu_121		(mem_to_vnu[(121+1)*QUAN_SIZE-1:121*QUAN_SIZE]),
	.mem_to_vnu_122		(mem_to_vnu[(122+1)*QUAN_SIZE-1:122*QUAN_SIZE]),
	.mem_to_vnu_123		(mem_to_vnu[(123+1)*QUAN_SIZE-1:123*QUAN_SIZE]),
	.mem_to_vnu_124		(mem_to_vnu[(124+1)*QUAN_SIZE-1:124*QUAN_SIZE]),
	.mem_to_vnu_125		(mem_to_vnu[(125+1)*QUAN_SIZE-1:125*QUAN_SIZE]),
	.mem_to_vnu_126		(mem_to_vnu[(126+1)*QUAN_SIZE-1:126*QUAN_SIZE]),
	.mem_to_vnu_127		(mem_to_vnu[(127+1)*QUAN_SIZE-1:127*QUAN_SIZE]),
	.mem_to_vnu_128		(mem_to_vnu[(128+1)*QUAN_SIZE-1:128*QUAN_SIZE]),
	.mem_to_vnu_129		(mem_to_vnu[(129+1)*QUAN_SIZE-1:129*QUAN_SIZE]),
	.mem_to_vnu_130		(mem_to_vnu[(130+1)*QUAN_SIZE-1:130*QUAN_SIZE]),
	.mem_to_vnu_131		(mem_to_vnu[(131+1)*QUAN_SIZE-1:131*QUAN_SIZE]),
	.mem_to_vnu_132		(mem_to_vnu[(132+1)*QUAN_SIZE-1:132*QUAN_SIZE]),
	.mem_to_vnu_133		(mem_to_vnu[(133+1)*QUAN_SIZE-1:133*QUAN_SIZE]),
	.mem_to_vnu_134		(mem_to_vnu[(134+1)*QUAN_SIZE-1:134*QUAN_SIZE]),
	.mem_to_vnu_135		(mem_to_vnu[(135+1)*QUAN_SIZE-1:135*QUAN_SIZE]),
	.mem_to_vnu_136		(mem_to_vnu[(136+1)*QUAN_SIZE-1:136*QUAN_SIZE]),
	.mem_to_vnu_137		(mem_to_vnu[(137+1)*QUAN_SIZE-1:137*QUAN_SIZE]),
	.mem_to_vnu_138		(mem_to_vnu[(138+1)*QUAN_SIZE-1:138*QUAN_SIZE]),
	.mem_to_vnu_139		(mem_to_vnu[(139+1)*QUAN_SIZE-1:139*QUAN_SIZE]),
	.mem_to_vnu_140		(mem_to_vnu[(140+1)*QUAN_SIZE-1:140*QUAN_SIZE]),
	.mem_to_vnu_141		(mem_to_vnu[(141+1)*QUAN_SIZE-1:141*QUAN_SIZE]),
	.mem_to_vnu_142		(mem_to_vnu[(142+1)*QUAN_SIZE-1:142*QUAN_SIZE]),
	.mem_to_vnu_143		(mem_to_vnu[(143+1)*QUAN_SIZE-1:143*QUAN_SIZE]),
	.mem_to_vnu_144		(mem_to_vnu[(144+1)*QUAN_SIZE-1:144*QUAN_SIZE]),
	.mem_to_vnu_145		(mem_to_vnu[(145+1)*QUAN_SIZE-1:145*QUAN_SIZE]),
	.mem_to_vnu_146		(mem_to_vnu[(146+1)*QUAN_SIZE-1:146*QUAN_SIZE]),
	.mem_to_vnu_147		(mem_to_vnu[(147+1)*QUAN_SIZE-1:147*QUAN_SIZE]),
	.mem_to_vnu_148		(mem_to_vnu[(148+1)*QUAN_SIZE-1:148*QUAN_SIZE]),
	.mem_to_vnu_149		(mem_to_vnu[(149+1)*QUAN_SIZE-1:149*QUAN_SIZE]),
	.mem_to_vnu_150		(mem_to_vnu[(150+1)*QUAN_SIZE-1:150*QUAN_SIZE]),
	.mem_to_vnu_151		(mem_to_vnu[(151+1)*QUAN_SIZE-1:151*QUAN_SIZE]),
	.mem_to_vnu_152		(mem_to_vnu[(152+1)*QUAN_SIZE-1:152*QUAN_SIZE]),
	.mem_to_vnu_153		(mem_to_vnu[(153+1)*QUAN_SIZE-1:153*QUAN_SIZE]),
	.mem_to_vnu_154		(mem_to_vnu[(154+1)*QUAN_SIZE-1:154*QUAN_SIZE]),
	.mem_to_vnu_155		(mem_to_vnu[(155+1)*QUAN_SIZE-1:155*QUAN_SIZE]),
	.mem_to_vnu_156		(mem_to_vnu[(156+1)*QUAN_SIZE-1:156*QUAN_SIZE]),
	.mem_to_vnu_157		(mem_to_vnu[(157+1)*QUAN_SIZE-1:157*QUAN_SIZE]),
	.mem_to_vnu_158		(mem_to_vnu[(158+1)*QUAN_SIZE-1:158*QUAN_SIZE]),
	.mem_to_vnu_159		(mem_to_vnu[(159+1)*QUAN_SIZE-1:159*QUAN_SIZE]),
	.mem_to_vnu_160		(mem_to_vnu[(160+1)*QUAN_SIZE-1:160*QUAN_SIZE]),
	.mem_to_vnu_161		(mem_to_vnu[(161+1)*QUAN_SIZE-1:161*QUAN_SIZE]),
	.mem_to_vnu_162		(mem_to_vnu[(162+1)*QUAN_SIZE-1:162*QUAN_SIZE]),
	.mem_to_vnu_163		(mem_to_vnu[(163+1)*QUAN_SIZE-1:163*QUAN_SIZE]),
	.mem_to_vnu_164		(mem_to_vnu[(164+1)*QUAN_SIZE-1:164*QUAN_SIZE]),
	.mem_to_vnu_165		(mem_to_vnu[(165+1)*QUAN_SIZE-1:165*QUAN_SIZE]),
	.mem_to_vnu_166		(mem_to_vnu[(166+1)*QUAN_SIZE-1:166*QUAN_SIZE]),
	.mem_to_vnu_167		(mem_to_vnu[(167+1)*QUAN_SIZE-1:167*QUAN_SIZE]),
	.mem_to_vnu_168		(mem_to_vnu[(168+1)*QUAN_SIZE-1:168*QUAN_SIZE]),
	.mem_to_vnu_169		(mem_to_vnu[(169+1)*QUAN_SIZE-1:169*QUAN_SIZE]),
	.mem_to_vnu_170		(mem_to_vnu[(170+1)*QUAN_SIZE-1:170*QUAN_SIZE]),
	.mem_to_vnu_171		(mem_to_vnu[(171+1)*QUAN_SIZE-1:171*QUAN_SIZE]),
	.mem_to_vnu_172		(mem_to_vnu[(172+1)*QUAN_SIZE-1:172*QUAN_SIZE]),
	.mem_to_vnu_173		(mem_to_vnu[(173+1)*QUAN_SIZE-1:173*QUAN_SIZE]),
	.mem_to_vnu_174		(mem_to_vnu[(174+1)*QUAN_SIZE-1:174*QUAN_SIZE]),
	.mem_to_vnu_175		(mem_to_vnu[(175+1)*QUAN_SIZE-1:175*QUAN_SIZE]),
	.mem_to_vnu_176		(mem_to_vnu[(176+1)*QUAN_SIZE-1:176*QUAN_SIZE]),
	.mem_to_vnu_177		(mem_to_vnu[(177+1)*QUAN_SIZE-1:177*QUAN_SIZE]),
	.mem_to_vnu_178		(mem_to_vnu[(178+1)*QUAN_SIZE-1:178*QUAN_SIZE]),
	.mem_to_vnu_179		(mem_to_vnu[(179+1)*QUAN_SIZE-1:179*QUAN_SIZE]),
	.mem_to_vnu_180		(mem_to_vnu[(180+1)*QUAN_SIZE-1:180*QUAN_SIZE]),
	.mem_to_vnu_181		(mem_to_vnu[(181+1)*QUAN_SIZE-1:181*QUAN_SIZE]),
	.mem_to_vnu_182		(mem_to_vnu[(182+1)*QUAN_SIZE-1:182*QUAN_SIZE]),
	.mem_to_vnu_183		(mem_to_vnu[(183+1)*QUAN_SIZE-1:183*QUAN_SIZE]),
	.mem_to_vnu_184		(mem_to_vnu[(184+1)*QUAN_SIZE-1:184*QUAN_SIZE]),
	.mem_to_vnu_185		(mem_to_vnu[(185+1)*QUAN_SIZE-1:185*QUAN_SIZE]),
	.mem_to_vnu_186		(mem_to_vnu[(186+1)*QUAN_SIZE-1:186*QUAN_SIZE]),
	.mem_to_vnu_187		(mem_to_vnu[(187+1)*QUAN_SIZE-1:187*QUAN_SIZE]),
	.mem_to_vnu_188		(mem_to_vnu[(188+1)*QUAN_SIZE-1:188*QUAN_SIZE]),
	.mem_to_vnu_189		(mem_to_vnu[(189+1)*QUAN_SIZE-1:189*QUAN_SIZE]),
	.mem_to_vnu_190		(mem_to_vnu[(190+1)*QUAN_SIZE-1:190*QUAN_SIZE]),
	.mem_to_vnu_191		(mem_to_vnu[(191+1)*QUAN_SIZE-1:191*QUAN_SIZE]),
	.mem_to_vnu_192		(mem_to_vnu[(192+1)*QUAN_SIZE-1:192*QUAN_SIZE]),
	.mem_to_vnu_193		(mem_to_vnu[(193+1)*QUAN_SIZE-1:193*QUAN_SIZE]),
	.mem_to_vnu_194		(mem_to_vnu[(194+1)*QUAN_SIZE-1:194*QUAN_SIZE]),
	.mem_to_vnu_195		(mem_to_vnu[(195+1)*QUAN_SIZE-1:195*QUAN_SIZE]),
	.mem_to_vnu_196		(mem_to_vnu[(196+1)*QUAN_SIZE-1:196*QUAN_SIZE]),
	.mem_to_vnu_197		(mem_to_vnu[(197+1)*QUAN_SIZE-1:197*QUAN_SIZE]),
	.mem_to_vnu_198		(mem_to_vnu[(198+1)*QUAN_SIZE-1:198*QUAN_SIZE]),
	.mem_to_vnu_199		(mem_to_vnu[(199+1)*QUAN_SIZE-1:199*QUAN_SIZE]),
	.mem_to_vnu_200		(mem_to_vnu[(200+1)*QUAN_SIZE-1:200*QUAN_SIZE]),
	.mem_to_vnu_201		(mem_to_vnu[(201+1)*QUAN_SIZE-1:201*QUAN_SIZE]),
	.mem_to_vnu_202		(mem_to_vnu[(202+1)*QUAN_SIZE-1:202*QUAN_SIZE]),
	.mem_to_vnu_203		(mem_to_vnu[(203+1)*QUAN_SIZE-1:203*QUAN_SIZE]),
	.mem_to_vnu_204		(mem_to_vnu[(204+1)*QUAN_SIZE-1:204*QUAN_SIZE]),
	.mem_to_vnu_205		(mem_to_vnu[(205+1)*QUAN_SIZE-1:205*QUAN_SIZE]),
	.mem_to_vnu_206		(mem_to_vnu[(206+1)*QUAN_SIZE-1:206*QUAN_SIZE]),
	.mem_to_vnu_207		(mem_to_vnu[(207+1)*QUAN_SIZE-1:207*QUAN_SIZE]),
	.mem_to_vnu_208		(mem_to_vnu[(208+1)*QUAN_SIZE-1:208*QUAN_SIZE]),
	.mem_to_vnu_209		(mem_to_vnu[(209+1)*QUAN_SIZE-1:209*QUAN_SIZE]),
	.mem_to_vnu_210		(mem_to_vnu[(210+1)*QUAN_SIZE-1:210*QUAN_SIZE]),
	.mem_to_vnu_211		(mem_to_vnu[(211+1)*QUAN_SIZE-1:211*QUAN_SIZE]),
	.mem_to_vnu_212		(mem_to_vnu[(212+1)*QUAN_SIZE-1:212*QUAN_SIZE]),
	.mem_to_vnu_213		(mem_to_vnu[(213+1)*QUAN_SIZE-1:213*QUAN_SIZE]),
	.mem_to_vnu_214		(mem_to_vnu[(214+1)*QUAN_SIZE-1:214*QUAN_SIZE]),
	.mem_to_vnu_215		(mem_to_vnu[(215+1)*QUAN_SIZE-1:215*QUAN_SIZE]),
	.mem_to_vnu_216		(mem_to_vnu[(216+1)*QUAN_SIZE-1:216*QUAN_SIZE]),
	.mem_to_vnu_217		(mem_to_vnu[(217+1)*QUAN_SIZE-1:217*QUAN_SIZE]),
	.mem_to_vnu_218		(mem_to_vnu[(218+1)*QUAN_SIZE-1:218*QUAN_SIZE]),
	.mem_to_vnu_219		(mem_to_vnu[(219+1)*QUAN_SIZE-1:219*QUAN_SIZE]),
	.mem_to_vnu_220		(mem_to_vnu[(220+1)*QUAN_SIZE-1:220*QUAN_SIZE]),
	.mem_to_vnu_221		(mem_to_vnu[(221+1)*QUAN_SIZE-1:221*QUAN_SIZE]),
	.mem_to_vnu_222		(mem_to_vnu[(222+1)*QUAN_SIZE-1:222*QUAN_SIZE]),
	.mem_to_vnu_223		(mem_to_vnu[(223+1)*QUAN_SIZE-1:223*QUAN_SIZE]),
	.mem_to_vnu_224		(mem_to_vnu[(224+1)*QUAN_SIZE-1:224*QUAN_SIZE]),
	.mem_to_vnu_225		(mem_to_vnu[(225+1)*QUAN_SIZE-1:225*QUAN_SIZE]),
	.mem_to_vnu_226		(mem_to_vnu[(226+1)*QUAN_SIZE-1:226*QUAN_SIZE]),
	.mem_to_vnu_227		(mem_to_vnu[(227+1)*QUAN_SIZE-1:227*QUAN_SIZE]),
	.mem_to_vnu_228		(mem_to_vnu[(228+1)*QUAN_SIZE-1:228*QUAN_SIZE]),
	.mem_to_vnu_229		(mem_to_vnu[(229+1)*QUAN_SIZE-1:229*QUAN_SIZE]),
	.mem_to_vnu_230		(mem_to_vnu[(230+1)*QUAN_SIZE-1:230*QUAN_SIZE]),
	.mem_to_vnu_231		(mem_to_vnu[(231+1)*QUAN_SIZE-1:231*QUAN_SIZE]),
	.mem_to_vnu_232		(mem_to_vnu[(232+1)*QUAN_SIZE-1:232*QUAN_SIZE]),
	.mem_to_vnu_233		(mem_to_vnu[(233+1)*QUAN_SIZE-1:233*QUAN_SIZE]),
	.mem_to_vnu_234		(mem_to_vnu[(234+1)*QUAN_SIZE-1:234*QUAN_SIZE]),
	.mem_to_vnu_235		(mem_to_vnu[(235+1)*QUAN_SIZE-1:235*QUAN_SIZE]),
	.mem_to_vnu_236		(mem_to_vnu[(236+1)*QUAN_SIZE-1:236*QUAN_SIZE]),
	.mem_to_vnu_237		(mem_to_vnu[(237+1)*QUAN_SIZE-1:237*QUAN_SIZE]),
	.mem_to_vnu_238		(mem_to_vnu[(238+1)*QUAN_SIZE-1:238*QUAN_SIZE]),
	.mem_to_vnu_239		(mem_to_vnu[(239+1)*QUAN_SIZE-1:239*QUAN_SIZE]),
	.mem_to_vnu_240		(mem_to_vnu[(240+1)*QUAN_SIZE-1:240*QUAN_SIZE]),
	.mem_to_vnu_241		(mem_to_vnu[(241+1)*QUAN_SIZE-1:241*QUAN_SIZE]),
	.mem_to_vnu_242		(mem_to_vnu[(242+1)*QUAN_SIZE-1:242*QUAN_SIZE]),
	.mem_to_vnu_243		(mem_to_vnu[(243+1)*QUAN_SIZE-1:243*QUAN_SIZE]),
	.mem_to_vnu_244		(mem_to_vnu[(244+1)*QUAN_SIZE-1:244*QUAN_SIZE]),
	.mem_to_vnu_245		(mem_to_vnu[(245+1)*QUAN_SIZE-1:245*QUAN_SIZE]),
	.mem_to_vnu_246		(mem_to_vnu[(246+1)*QUAN_SIZE-1:246*QUAN_SIZE]),
	.mem_to_vnu_247		(mem_to_vnu[(247+1)*QUAN_SIZE-1:247*QUAN_SIZE]),
	.mem_to_vnu_248		(mem_to_vnu[(248+1)*QUAN_SIZE-1:248*QUAN_SIZE]),
	.mem_to_vnu_249		(mem_to_vnu[(249+1)*QUAN_SIZE-1:249*QUAN_SIZE]),
	.mem_to_vnu_250		(mem_to_vnu[(250+1)*QUAN_SIZE-1:250*QUAN_SIZE]),
	.mem_to_vnu_251		(mem_to_vnu[(251+1)*QUAN_SIZE-1:251*QUAN_SIZE]),
	.mem_to_vnu_252		(mem_to_vnu[(252+1)*QUAN_SIZE-1:252*QUAN_SIZE]),
	.mem_to_vnu_253		(mem_to_vnu[(253+1)*QUAN_SIZE-1:253*QUAN_SIZE]),
	.mem_to_vnu_254		(mem_to_vnu[(254+1)*QUAN_SIZE-1:254*QUAN_SIZE]),

	.mem_to_cnu_0		(mem_to_cnu[(0+1)*QUAN_SIZE-1:0*QUAN_SIZE]),
	.mem_to_cnu_1		(mem_to_cnu[(1+1)*QUAN_SIZE-1:1*QUAN_SIZE]),
	.mem_to_cnu_2		(mem_to_cnu[(2+1)*QUAN_SIZE-1:2*QUAN_SIZE]),
	.mem_to_cnu_3		(mem_to_cnu[(3+1)*QUAN_SIZE-1:3*QUAN_SIZE]),
	.mem_to_cnu_4		(mem_to_cnu[(4+1)*QUAN_SIZE-1:4*QUAN_SIZE]),
	.mem_to_cnu_5		(mem_to_cnu[(5+1)*QUAN_SIZE-1:5*QUAN_SIZE]),
	.mem_to_cnu_6		(mem_to_cnu[(6+1)*QUAN_SIZE-1:6*QUAN_SIZE]),
	.mem_to_cnu_7		(mem_to_cnu[(7+1)*QUAN_SIZE-1:7*QUAN_SIZE]),
	.mem_to_cnu_8		(mem_to_cnu[(8+1)*QUAN_SIZE-1:8*QUAN_SIZE]),
	.mem_to_cnu_9		(mem_to_cnu[(9+1)*QUAN_SIZE-1:9*QUAN_SIZE]),
	.mem_to_cnu_10		(mem_to_cnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
	.mem_to_cnu_11		(mem_to_cnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
	.mem_to_cnu_12		(mem_to_cnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
	.mem_to_cnu_13		(mem_to_cnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
	.mem_to_cnu_14		(mem_to_cnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
	.mem_to_cnu_15		(mem_to_cnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
	.mem_to_cnu_16		(mem_to_cnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
	.mem_to_cnu_17		(mem_to_cnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
	.mem_to_cnu_18		(mem_to_cnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
	.mem_to_cnu_19		(mem_to_cnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
	.mem_to_cnu_20		(mem_to_cnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
	.mem_to_cnu_21		(mem_to_cnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
	.mem_to_cnu_22		(mem_to_cnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
	.mem_to_cnu_23		(mem_to_cnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
	.mem_to_cnu_24		(mem_to_cnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
	.mem_to_cnu_25		(mem_to_cnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
	.mem_to_cnu_26		(mem_to_cnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
	.mem_to_cnu_27		(mem_to_cnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
	.mem_to_cnu_28		(mem_to_cnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
	.mem_to_cnu_29		(mem_to_cnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
	.mem_to_cnu_30		(mem_to_cnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
	.mem_to_cnu_31		(mem_to_cnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
	.mem_to_cnu_32		(mem_to_cnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
	.mem_to_cnu_33		(mem_to_cnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
	.mem_to_cnu_34		(mem_to_cnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
	.mem_to_cnu_35		(mem_to_cnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
	.mem_to_cnu_36		(mem_to_cnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
	.mem_to_cnu_37		(mem_to_cnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
	.mem_to_cnu_38		(mem_to_cnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
	.mem_to_cnu_39		(mem_to_cnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
	.mem_to_cnu_40		(mem_to_cnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
	.mem_to_cnu_41		(mem_to_cnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
	.mem_to_cnu_42		(mem_to_cnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
	.mem_to_cnu_43		(mem_to_cnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
	.mem_to_cnu_44		(mem_to_cnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
	.mem_to_cnu_45		(mem_to_cnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
	.mem_to_cnu_46		(mem_to_cnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
	.mem_to_cnu_47		(mem_to_cnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
	.mem_to_cnu_48		(mem_to_cnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
	.mem_to_cnu_49		(mem_to_cnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
	.mem_to_cnu_50		(mem_to_cnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
	.mem_to_cnu_51		(mem_to_cnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
	.mem_to_cnu_52		(mem_to_cnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
	.mem_to_cnu_53		(mem_to_cnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
	.mem_to_cnu_54		(mem_to_cnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
	.mem_to_cnu_55		(mem_to_cnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
	.mem_to_cnu_56		(mem_to_cnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
	.mem_to_cnu_57		(mem_to_cnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
	.mem_to_cnu_58		(mem_to_cnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
	.mem_to_cnu_59		(mem_to_cnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
	.mem_to_cnu_60		(mem_to_cnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
	.mem_to_cnu_61		(mem_to_cnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
	.mem_to_cnu_62		(mem_to_cnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
	.mem_to_cnu_63		(mem_to_cnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
	.mem_to_cnu_64		(mem_to_cnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
	.mem_to_cnu_65		(mem_to_cnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
	.mem_to_cnu_66		(mem_to_cnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
	.mem_to_cnu_67		(mem_to_cnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
	.mem_to_cnu_68		(mem_to_cnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
	.mem_to_cnu_69		(mem_to_cnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
	.mem_to_cnu_70		(mem_to_cnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
	.mem_to_cnu_71		(mem_to_cnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
	.mem_to_cnu_72		(mem_to_cnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
	.mem_to_cnu_73		(mem_to_cnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
	.mem_to_cnu_74		(mem_to_cnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
	.mem_to_cnu_75		(mem_to_cnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
	.mem_to_cnu_76		(mem_to_cnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
	.mem_to_cnu_77		(mem_to_cnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
	.mem_to_cnu_78		(mem_to_cnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
	.mem_to_cnu_79		(mem_to_cnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
	.mem_to_cnu_80		(mem_to_cnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
	.mem_to_cnu_81		(mem_to_cnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
	.mem_to_cnu_82		(mem_to_cnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
	.mem_to_cnu_83		(mem_to_cnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
	.mem_to_cnu_84		(mem_to_cnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),
	.mem_to_cnu_85		(mem_to_cnu[(85+1)*QUAN_SIZE-1:85*QUAN_SIZE]),
	.mem_to_cnu_86		(mem_to_cnu[(86+1)*QUAN_SIZE-1:86*QUAN_SIZE]),
	.mem_to_cnu_87		(mem_to_cnu[(87+1)*QUAN_SIZE-1:87*QUAN_SIZE]),
	.mem_to_cnu_88		(mem_to_cnu[(88+1)*QUAN_SIZE-1:88*QUAN_SIZE]),
	.mem_to_cnu_89		(mem_to_cnu[(89+1)*QUAN_SIZE-1:89*QUAN_SIZE]),
	.mem_to_cnu_90		(mem_to_cnu[(90+1)*QUAN_SIZE-1:90*QUAN_SIZE]),
	.mem_to_cnu_91		(mem_to_cnu[(91+1)*QUAN_SIZE-1:91*QUAN_SIZE]),
	.mem_to_cnu_92		(mem_to_cnu[(92+1)*QUAN_SIZE-1:92*QUAN_SIZE]),
	.mem_to_cnu_93		(mem_to_cnu[(93+1)*QUAN_SIZE-1:93*QUAN_SIZE]),
	.mem_to_cnu_94		(mem_to_cnu[(94+1)*QUAN_SIZE-1:94*QUAN_SIZE]),
	.mem_to_cnu_95		(mem_to_cnu[(95+1)*QUAN_SIZE-1:95*QUAN_SIZE]),
	.mem_to_cnu_96		(mem_to_cnu[(96+1)*QUAN_SIZE-1:96*QUAN_SIZE]),
	.mem_to_cnu_97		(mem_to_cnu[(97+1)*QUAN_SIZE-1:97*QUAN_SIZE]),
	.mem_to_cnu_98		(mem_to_cnu[(98+1)*QUAN_SIZE-1:98*QUAN_SIZE]),
	.mem_to_cnu_99		(mem_to_cnu[(99+1)*QUAN_SIZE-1:99*QUAN_SIZE]),
	.mem_to_cnu_100		(mem_to_cnu[(100+1)*QUAN_SIZE-1:100*QUAN_SIZE]),
	.mem_to_cnu_101		(mem_to_cnu[(101+1)*QUAN_SIZE-1:101*QUAN_SIZE]),
	.mem_to_cnu_102		(mem_to_cnu[(102+1)*QUAN_SIZE-1:102*QUAN_SIZE]),
	.mem_to_cnu_103		(mem_to_cnu[(103+1)*QUAN_SIZE-1:103*QUAN_SIZE]),
	.mem_to_cnu_104		(mem_to_cnu[(104+1)*QUAN_SIZE-1:104*QUAN_SIZE]),
	.mem_to_cnu_105		(mem_to_cnu[(105+1)*QUAN_SIZE-1:105*QUAN_SIZE]),
	.mem_to_cnu_106		(mem_to_cnu[(106+1)*QUAN_SIZE-1:106*QUAN_SIZE]),
	.mem_to_cnu_107		(mem_to_cnu[(107+1)*QUAN_SIZE-1:107*QUAN_SIZE]),
	.mem_to_cnu_108		(mem_to_cnu[(108+1)*QUAN_SIZE-1:108*QUAN_SIZE]),
	.mem_to_cnu_109		(mem_to_cnu[(109+1)*QUAN_SIZE-1:109*QUAN_SIZE]),
	.mem_to_cnu_110		(mem_to_cnu[(110+1)*QUAN_SIZE-1:110*QUAN_SIZE]),
	.mem_to_cnu_111		(mem_to_cnu[(111+1)*QUAN_SIZE-1:111*QUAN_SIZE]),
	.mem_to_cnu_112		(mem_to_cnu[(112+1)*QUAN_SIZE-1:112*QUAN_SIZE]),
	.mem_to_cnu_113		(mem_to_cnu[(113+1)*QUAN_SIZE-1:113*QUAN_SIZE]),
	.mem_to_cnu_114		(mem_to_cnu[(114+1)*QUAN_SIZE-1:114*QUAN_SIZE]),
	.mem_to_cnu_115		(mem_to_cnu[(115+1)*QUAN_SIZE-1:115*QUAN_SIZE]),
	.mem_to_cnu_116		(mem_to_cnu[(116+1)*QUAN_SIZE-1:116*QUAN_SIZE]),
	.mem_to_cnu_117		(mem_to_cnu[(117+1)*QUAN_SIZE-1:117*QUAN_SIZE]),
	.mem_to_cnu_118		(mem_to_cnu[(118+1)*QUAN_SIZE-1:118*QUAN_SIZE]),
	.mem_to_cnu_119		(mem_to_cnu[(119+1)*QUAN_SIZE-1:119*QUAN_SIZE]),
	.mem_to_cnu_120		(mem_to_cnu[(120+1)*QUAN_SIZE-1:120*QUAN_SIZE]),
	.mem_to_cnu_121		(mem_to_cnu[(121+1)*QUAN_SIZE-1:121*QUAN_SIZE]),
	.mem_to_cnu_122		(mem_to_cnu[(122+1)*QUAN_SIZE-1:122*QUAN_SIZE]),
	.mem_to_cnu_123		(mem_to_cnu[(123+1)*QUAN_SIZE-1:123*QUAN_SIZE]),
	.mem_to_cnu_124		(mem_to_cnu[(124+1)*QUAN_SIZE-1:124*QUAN_SIZE]),
	.mem_to_cnu_125		(mem_to_cnu[(125+1)*QUAN_SIZE-1:125*QUAN_SIZE]),
	.mem_to_cnu_126		(mem_to_cnu[(126+1)*QUAN_SIZE-1:126*QUAN_SIZE]),
	.mem_to_cnu_127		(mem_to_cnu[(127+1)*QUAN_SIZE-1:127*QUAN_SIZE]),
	.mem_to_cnu_128		(mem_to_cnu[(128+1)*QUAN_SIZE-1:128*QUAN_SIZE]),
	.mem_to_cnu_129		(mem_to_cnu[(129+1)*QUAN_SIZE-1:129*QUAN_SIZE]),
	.mem_to_cnu_130		(mem_to_cnu[(130+1)*QUAN_SIZE-1:130*QUAN_SIZE]),
	.mem_to_cnu_131		(mem_to_cnu[(131+1)*QUAN_SIZE-1:131*QUAN_SIZE]),
	.mem_to_cnu_132		(mem_to_cnu[(132+1)*QUAN_SIZE-1:132*QUAN_SIZE]),
	.mem_to_cnu_133		(mem_to_cnu[(133+1)*QUAN_SIZE-1:133*QUAN_SIZE]),
	.mem_to_cnu_134		(mem_to_cnu[(134+1)*QUAN_SIZE-1:134*QUAN_SIZE]),
	.mem_to_cnu_135		(mem_to_cnu[(135+1)*QUAN_SIZE-1:135*QUAN_SIZE]),
	.mem_to_cnu_136		(mem_to_cnu[(136+1)*QUAN_SIZE-1:136*QUAN_SIZE]),
	.mem_to_cnu_137		(mem_to_cnu[(137+1)*QUAN_SIZE-1:137*QUAN_SIZE]),
	.mem_to_cnu_138		(mem_to_cnu[(138+1)*QUAN_SIZE-1:138*QUAN_SIZE]),
	.mem_to_cnu_139		(mem_to_cnu[(139+1)*QUAN_SIZE-1:139*QUAN_SIZE]),
	.mem_to_cnu_140		(mem_to_cnu[(140+1)*QUAN_SIZE-1:140*QUAN_SIZE]),
	.mem_to_cnu_141		(mem_to_cnu[(141+1)*QUAN_SIZE-1:141*QUAN_SIZE]),
	.mem_to_cnu_142		(mem_to_cnu[(142+1)*QUAN_SIZE-1:142*QUAN_SIZE]),
	.mem_to_cnu_143		(mem_to_cnu[(143+1)*QUAN_SIZE-1:143*QUAN_SIZE]),
	.mem_to_cnu_144		(mem_to_cnu[(144+1)*QUAN_SIZE-1:144*QUAN_SIZE]),
	.mem_to_cnu_145		(mem_to_cnu[(145+1)*QUAN_SIZE-1:145*QUAN_SIZE]),
	.mem_to_cnu_146		(mem_to_cnu[(146+1)*QUAN_SIZE-1:146*QUAN_SIZE]),
	.mem_to_cnu_147		(mem_to_cnu[(147+1)*QUAN_SIZE-1:147*QUAN_SIZE]),
	.mem_to_cnu_148		(mem_to_cnu[(148+1)*QUAN_SIZE-1:148*QUAN_SIZE]),
	.mem_to_cnu_149		(mem_to_cnu[(149+1)*QUAN_SIZE-1:149*QUAN_SIZE]),
	.mem_to_cnu_150		(mem_to_cnu[(150+1)*QUAN_SIZE-1:150*QUAN_SIZE]),
	.mem_to_cnu_151		(mem_to_cnu[(151+1)*QUAN_SIZE-1:151*QUAN_SIZE]),
	.mem_to_cnu_152		(mem_to_cnu[(152+1)*QUAN_SIZE-1:152*QUAN_SIZE]),
	.mem_to_cnu_153		(mem_to_cnu[(153+1)*QUAN_SIZE-1:153*QUAN_SIZE]),
	.mem_to_cnu_154		(mem_to_cnu[(154+1)*QUAN_SIZE-1:154*QUAN_SIZE]),
	.mem_to_cnu_155		(mem_to_cnu[(155+1)*QUAN_SIZE-1:155*QUAN_SIZE]),
	.mem_to_cnu_156		(mem_to_cnu[(156+1)*QUAN_SIZE-1:156*QUAN_SIZE]),
	.mem_to_cnu_157		(mem_to_cnu[(157+1)*QUAN_SIZE-1:157*QUAN_SIZE]),
	.mem_to_cnu_158		(mem_to_cnu[(158+1)*QUAN_SIZE-1:158*QUAN_SIZE]),
	.mem_to_cnu_159		(mem_to_cnu[(159+1)*QUAN_SIZE-1:159*QUAN_SIZE]),
	.mem_to_cnu_160		(mem_to_cnu[(160+1)*QUAN_SIZE-1:160*QUAN_SIZE]),
	.mem_to_cnu_161		(mem_to_cnu[(161+1)*QUAN_SIZE-1:161*QUAN_SIZE]),
	.mem_to_cnu_162		(mem_to_cnu[(162+1)*QUAN_SIZE-1:162*QUAN_SIZE]),
	.mem_to_cnu_163		(mem_to_cnu[(163+1)*QUAN_SIZE-1:163*QUAN_SIZE]),
	.mem_to_cnu_164		(mem_to_cnu[(164+1)*QUAN_SIZE-1:164*QUAN_SIZE]),
	.mem_to_cnu_165		(mem_to_cnu[(165+1)*QUAN_SIZE-1:165*QUAN_SIZE]),
	.mem_to_cnu_166		(mem_to_cnu[(166+1)*QUAN_SIZE-1:166*QUAN_SIZE]),
	.mem_to_cnu_167		(mem_to_cnu[(167+1)*QUAN_SIZE-1:167*QUAN_SIZE]),
	.mem_to_cnu_168		(mem_to_cnu[(168+1)*QUAN_SIZE-1:168*QUAN_SIZE]),
	.mem_to_cnu_169		(mem_to_cnu[(169+1)*QUAN_SIZE-1:169*QUAN_SIZE]),
	.mem_to_cnu_170		(mem_to_cnu[(170+1)*QUAN_SIZE-1:170*QUAN_SIZE]),
	.mem_to_cnu_171		(mem_to_cnu[(171+1)*QUAN_SIZE-1:171*QUAN_SIZE]),
	.mem_to_cnu_172		(mem_to_cnu[(172+1)*QUAN_SIZE-1:172*QUAN_SIZE]),
	.mem_to_cnu_173		(mem_to_cnu[(173+1)*QUAN_SIZE-1:173*QUAN_SIZE]),
	.mem_to_cnu_174		(mem_to_cnu[(174+1)*QUAN_SIZE-1:174*QUAN_SIZE]),
	.mem_to_cnu_175		(mem_to_cnu[(175+1)*QUAN_SIZE-1:175*QUAN_SIZE]),
	.mem_to_cnu_176		(mem_to_cnu[(176+1)*QUAN_SIZE-1:176*QUAN_SIZE]),
	.mem_to_cnu_177		(mem_to_cnu[(177+1)*QUAN_SIZE-1:177*QUAN_SIZE]),
	.mem_to_cnu_178		(mem_to_cnu[(178+1)*QUAN_SIZE-1:178*QUAN_SIZE]),
	.mem_to_cnu_179		(mem_to_cnu[(179+1)*QUAN_SIZE-1:179*QUAN_SIZE]),
	.mem_to_cnu_180		(mem_to_cnu[(180+1)*QUAN_SIZE-1:180*QUAN_SIZE]),
	.mem_to_cnu_181		(mem_to_cnu[(181+1)*QUAN_SIZE-1:181*QUAN_SIZE]),
	.mem_to_cnu_182		(mem_to_cnu[(182+1)*QUAN_SIZE-1:182*QUAN_SIZE]),
	.mem_to_cnu_183		(mem_to_cnu[(183+1)*QUAN_SIZE-1:183*QUAN_SIZE]),
	.mem_to_cnu_184		(mem_to_cnu[(184+1)*QUAN_SIZE-1:184*QUAN_SIZE]),
	.mem_to_cnu_185		(mem_to_cnu[(185+1)*QUAN_SIZE-1:185*QUAN_SIZE]),
	.mem_to_cnu_186		(mem_to_cnu[(186+1)*QUAN_SIZE-1:186*QUAN_SIZE]),
	.mem_to_cnu_187		(mem_to_cnu[(187+1)*QUAN_SIZE-1:187*QUAN_SIZE]),
	.mem_to_cnu_188		(mem_to_cnu[(188+1)*QUAN_SIZE-1:188*QUAN_SIZE]),
	.mem_to_cnu_189		(mem_to_cnu[(189+1)*QUAN_SIZE-1:189*QUAN_SIZE]),
	.mem_to_cnu_190		(mem_to_cnu[(190+1)*QUAN_SIZE-1:190*QUAN_SIZE]),
	.mem_to_cnu_191		(mem_to_cnu[(191+1)*QUAN_SIZE-1:191*QUAN_SIZE]),
	.mem_to_cnu_192		(mem_to_cnu[(192+1)*QUAN_SIZE-1:192*QUAN_SIZE]),
	.mem_to_cnu_193		(mem_to_cnu[(193+1)*QUAN_SIZE-1:193*QUAN_SIZE]),
	.mem_to_cnu_194		(mem_to_cnu[(194+1)*QUAN_SIZE-1:194*QUAN_SIZE]),
	.mem_to_cnu_195		(mem_to_cnu[(195+1)*QUAN_SIZE-1:195*QUAN_SIZE]),
	.mem_to_cnu_196		(mem_to_cnu[(196+1)*QUAN_SIZE-1:196*QUAN_SIZE]),
	.mem_to_cnu_197		(mem_to_cnu[(197+1)*QUAN_SIZE-1:197*QUAN_SIZE]),
	.mem_to_cnu_198		(mem_to_cnu[(198+1)*QUAN_SIZE-1:198*QUAN_SIZE]),
	.mem_to_cnu_199		(mem_to_cnu[(199+1)*QUAN_SIZE-1:199*QUAN_SIZE]),
	.mem_to_cnu_200		(mem_to_cnu[(200+1)*QUAN_SIZE-1:200*QUAN_SIZE]),
	.mem_to_cnu_201		(mem_to_cnu[(201+1)*QUAN_SIZE-1:201*QUAN_SIZE]),
	.mem_to_cnu_202		(mem_to_cnu[(202+1)*QUAN_SIZE-1:202*QUAN_SIZE]),
	.mem_to_cnu_203		(mem_to_cnu[(203+1)*QUAN_SIZE-1:203*QUAN_SIZE]),
	.mem_to_cnu_204		(mem_to_cnu[(204+1)*QUAN_SIZE-1:204*QUAN_SIZE]),
	.mem_to_cnu_205		(mem_to_cnu[(205+1)*QUAN_SIZE-1:205*QUAN_SIZE]),
	.mem_to_cnu_206		(mem_to_cnu[(206+1)*QUAN_SIZE-1:206*QUAN_SIZE]),
	.mem_to_cnu_207		(mem_to_cnu[(207+1)*QUAN_SIZE-1:207*QUAN_SIZE]),
	.mem_to_cnu_208		(mem_to_cnu[(208+1)*QUAN_SIZE-1:208*QUAN_SIZE]),
	.mem_to_cnu_209		(mem_to_cnu[(209+1)*QUAN_SIZE-1:209*QUAN_SIZE]),
	.mem_to_cnu_210		(mem_to_cnu[(210+1)*QUAN_SIZE-1:210*QUAN_SIZE]),
	.mem_to_cnu_211		(mem_to_cnu[(211+1)*QUAN_SIZE-1:211*QUAN_SIZE]),
	.mem_to_cnu_212		(mem_to_cnu[(212+1)*QUAN_SIZE-1:212*QUAN_SIZE]),
	.mem_to_cnu_213		(mem_to_cnu[(213+1)*QUAN_SIZE-1:213*QUAN_SIZE]),
	.mem_to_cnu_214		(mem_to_cnu[(214+1)*QUAN_SIZE-1:214*QUAN_SIZE]),
	.mem_to_cnu_215		(mem_to_cnu[(215+1)*QUAN_SIZE-1:215*QUAN_SIZE]),
	.mem_to_cnu_216		(mem_to_cnu[(216+1)*QUAN_SIZE-1:216*QUAN_SIZE]),
	.mem_to_cnu_217		(mem_to_cnu[(217+1)*QUAN_SIZE-1:217*QUAN_SIZE]),
	.mem_to_cnu_218		(mem_to_cnu[(218+1)*QUAN_SIZE-1:218*QUAN_SIZE]),
	.mem_to_cnu_219		(mem_to_cnu[(219+1)*QUAN_SIZE-1:219*QUAN_SIZE]),
	.mem_to_cnu_220		(mem_to_cnu[(220+1)*QUAN_SIZE-1:220*QUAN_SIZE]),
	.mem_to_cnu_221		(mem_to_cnu[(221+1)*QUAN_SIZE-1:221*QUAN_SIZE]),
	.mem_to_cnu_222		(mem_to_cnu[(222+1)*QUAN_SIZE-1:222*QUAN_SIZE]),
	.mem_to_cnu_223		(mem_to_cnu[(223+1)*QUAN_SIZE-1:223*QUAN_SIZE]),
	.mem_to_cnu_224		(mem_to_cnu[(224+1)*QUAN_SIZE-1:224*QUAN_SIZE]),
	.mem_to_cnu_225		(mem_to_cnu[(225+1)*QUAN_SIZE-1:225*QUAN_SIZE]),
	.mem_to_cnu_226		(mem_to_cnu[(226+1)*QUAN_SIZE-1:226*QUAN_SIZE]),
	.mem_to_cnu_227		(mem_to_cnu[(227+1)*QUAN_SIZE-1:227*QUAN_SIZE]),
	.mem_to_cnu_228		(mem_to_cnu[(228+1)*QUAN_SIZE-1:228*QUAN_SIZE]),
	.mem_to_cnu_229		(mem_to_cnu[(229+1)*QUAN_SIZE-1:229*QUAN_SIZE]),
	.mem_to_cnu_230		(mem_to_cnu[(230+1)*QUAN_SIZE-1:230*QUAN_SIZE]),
	.mem_to_cnu_231		(mem_to_cnu[(231+1)*QUAN_SIZE-1:231*QUAN_SIZE]),
	.mem_to_cnu_232		(mem_to_cnu[(232+1)*QUAN_SIZE-1:232*QUAN_SIZE]),
	.mem_to_cnu_233		(mem_to_cnu[(233+1)*QUAN_SIZE-1:233*QUAN_SIZE]),
	.mem_to_cnu_234		(mem_to_cnu[(234+1)*QUAN_SIZE-1:234*QUAN_SIZE]),
	.mem_to_cnu_235		(mem_to_cnu[(235+1)*QUAN_SIZE-1:235*QUAN_SIZE]),
	.mem_to_cnu_236		(mem_to_cnu[(236+1)*QUAN_SIZE-1:236*QUAN_SIZE]),
	.mem_to_cnu_237		(mem_to_cnu[(237+1)*QUAN_SIZE-1:237*QUAN_SIZE]),
	.mem_to_cnu_238		(mem_to_cnu[(238+1)*QUAN_SIZE-1:238*QUAN_SIZE]),
	.mem_to_cnu_239		(mem_to_cnu[(239+1)*QUAN_SIZE-1:239*QUAN_SIZE]),
	.mem_to_cnu_240		(mem_to_cnu[(240+1)*QUAN_SIZE-1:240*QUAN_SIZE]),
	.mem_to_cnu_241		(mem_to_cnu[(241+1)*QUAN_SIZE-1:241*QUAN_SIZE]),
	.mem_to_cnu_242		(mem_to_cnu[(242+1)*QUAN_SIZE-1:242*QUAN_SIZE]),
	.mem_to_cnu_243		(mem_to_cnu[(243+1)*QUAN_SIZE-1:243*QUAN_SIZE]),
	.mem_to_cnu_244		(mem_to_cnu[(244+1)*QUAN_SIZE-1:244*QUAN_SIZE]),
	.mem_to_cnu_245		(mem_to_cnu[(245+1)*QUAN_SIZE-1:245*QUAN_SIZE]),
	.mem_to_cnu_246		(mem_to_cnu[(246+1)*QUAN_SIZE-1:246*QUAN_SIZE]),
	.mem_to_cnu_247		(mem_to_cnu[(247+1)*QUAN_SIZE-1:247*QUAN_SIZE]),
	.mem_to_cnu_248		(mem_to_cnu[(248+1)*QUAN_SIZE-1:248*QUAN_SIZE]),
	.mem_to_cnu_249		(mem_to_cnu[(249+1)*QUAN_SIZE-1:249*QUAN_SIZE]),
	.mem_to_cnu_250		(mem_to_cnu[(250+1)*QUAN_SIZE-1:250*QUAN_SIZE]),
	.mem_to_cnu_251		(mem_to_cnu[(251+1)*QUAN_SIZE-1:251*QUAN_SIZE]),
	.mem_to_cnu_252		(mem_to_cnu[(252+1)*QUAN_SIZE-1:252*QUAN_SIZE]),
	.mem_to_cnu_253		(mem_to_cnu[(253+1)*QUAN_SIZE-1:253*QUAN_SIZE]),
	.mem_to_cnu_254		(mem_to_cnu[(254+1)*QUAN_SIZE-1:254*QUAN_SIZE]),

	.vnu_to_mem_0		(vnu_msg_in[0]),
	.vnu_to_mem_1		(vnu_msg_in[1]),
	.vnu_to_mem_2		(vnu_msg_in[2]),
	.vnu_to_mem_3		(vnu_msg_in[3]),
	.vnu_to_mem_4		(vnu_msg_in[4]),
	.vnu_to_mem_5		(vnu_msg_in[5]),
	.vnu_to_mem_6		(vnu_msg_in[6]),
	.vnu_to_mem_7		(vnu_msg_in[7]),
	.vnu_to_mem_8		(vnu_msg_in[8]),
	.vnu_to_mem_9		(vnu_msg_in[9]),
	.vnu_to_mem_10		(vnu_msg_in[10]),
	.vnu_to_mem_11		(vnu_msg_in[11]),
	.vnu_to_mem_12		(vnu_msg_in[12]),
	.vnu_to_mem_13		(vnu_msg_in[13]),
	.vnu_to_mem_14		(vnu_msg_in[14]),
	.vnu_to_mem_15		(vnu_msg_in[15]),
	.vnu_to_mem_16		(vnu_msg_in[16]),
	.vnu_to_mem_17		(vnu_msg_in[17]),
	.vnu_to_mem_18		(vnu_msg_in[18]),
	.vnu_to_mem_19		(vnu_msg_in[19]),
	.vnu_to_mem_20		(vnu_msg_in[20]),
	.vnu_to_mem_21		(vnu_msg_in[21]),
	.vnu_to_mem_22		(vnu_msg_in[22]),
	.vnu_to_mem_23		(vnu_msg_in[23]),
	.vnu_to_mem_24		(vnu_msg_in[24]),
	.vnu_to_mem_25		(vnu_msg_in[25]),
	.vnu_to_mem_26		(vnu_msg_in[26]),
	.vnu_to_mem_27		(vnu_msg_in[27]),
	.vnu_to_mem_28		(vnu_msg_in[28]),
	.vnu_to_mem_29		(vnu_msg_in[29]),
	.vnu_to_mem_30		(vnu_msg_in[30]),
	.vnu_to_mem_31		(vnu_msg_in[31]),
	.vnu_to_mem_32		(vnu_msg_in[32]),
	.vnu_to_mem_33		(vnu_msg_in[33]),
	.vnu_to_mem_34		(vnu_msg_in[34]),
	.vnu_to_mem_35		(vnu_msg_in[35]),
	.vnu_to_mem_36		(vnu_msg_in[36]),
	.vnu_to_mem_37		(vnu_msg_in[37]),
	.vnu_to_mem_38		(vnu_msg_in[38]),
	.vnu_to_mem_39		(vnu_msg_in[39]),
	.vnu_to_mem_40		(vnu_msg_in[40]),
	.vnu_to_mem_41		(vnu_msg_in[41]),
	.vnu_to_mem_42		(vnu_msg_in[42]),
	.vnu_to_mem_43		(vnu_msg_in[43]),
	.vnu_to_mem_44		(vnu_msg_in[44]),
	.vnu_to_mem_45		(vnu_msg_in[45]),
	.vnu_to_mem_46		(vnu_msg_in[46]),
	.vnu_to_mem_47		(vnu_msg_in[47]),
	.vnu_to_mem_48		(vnu_msg_in[48]),
	.vnu_to_mem_49		(vnu_msg_in[49]),
	.vnu_to_mem_50		(vnu_msg_in[50]),
	.vnu_to_mem_51		(vnu_msg_in[51]),
	.vnu_to_mem_52		(vnu_msg_in[52]),
	.vnu_to_mem_53		(vnu_msg_in[53]),
	.vnu_to_mem_54		(vnu_msg_in[54]),
	.vnu_to_mem_55		(vnu_msg_in[55]),
	.vnu_to_mem_56		(vnu_msg_in[56]),
	.vnu_to_mem_57		(vnu_msg_in[57]),
	.vnu_to_mem_58		(vnu_msg_in[58]),
	.vnu_to_mem_59		(vnu_msg_in[59]),
	.vnu_to_mem_60		(vnu_msg_in[60]),
	.vnu_to_mem_61		(vnu_msg_in[61]),
	.vnu_to_mem_62		(vnu_msg_in[62]),
	.vnu_to_mem_63		(vnu_msg_in[63]),
	.vnu_to_mem_64		(vnu_msg_in[64]),
	.vnu_to_mem_65		(vnu_msg_in[65]),
	.vnu_to_mem_66		(vnu_msg_in[66]),
	.vnu_to_mem_67		(vnu_msg_in[67]),
	.vnu_to_mem_68		(vnu_msg_in[68]),
	.vnu_to_mem_69		(vnu_msg_in[69]),
	.vnu_to_mem_70		(vnu_msg_in[70]),
	.vnu_to_mem_71		(vnu_msg_in[71]),
	.vnu_to_mem_72		(vnu_msg_in[72]),
	.vnu_to_mem_73		(vnu_msg_in[73]),
	.vnu_to_mem_74		(vnu_msg_in[74]),
	.vnu_to_mem_75		(vnu_msg_in[75]),
	.vnu_to_mem_76		(vnu_msg_in[76]),
	.vnu_to_mem_77		(vnu_msg_in[77]),
	.vnu_to_mem_78		(vnu_msg_in[78]),
	.vnu_to_mem_79		(vnu_msg_in[79]),
	.vnu_to_mem_80		(vnu_msg_in[80]),
	.vnu_to_mem_81		(vnu_msg_in[81]),
	.vnu_to_mem_82		(vnu_msg_in[82]),
	.vnu_to_mem_83		(vnu_msg_in[83]),
	.vnu_to_mem_84		(vnu_msg_in[84]),
	.vnu_to_mem_85		(vnu_msg_in[85]),
	.vnu_to_mem_86		(vnu_msg_in[86]),
	.vnu_to_mem_87		(vnu_msg_in[87]),
	.vnu_to_mem_88		(vnu_msg_in[88]),
	.vnu_to_mem_89		(vnu_msg_in[89]),
	.vnu_to_mem_90		(vnu_msg_in[90]),
	.vnu_to_mem_91		(vnu_msg_in[91]),
	.vnu_to_mem_92		(vnu_msg_in[92]),
	.vnu_to_mem_93		(vnu_msg_in[93]),
	.vnu_to_mem_94		(vnu_msg_in[94]),
	.vnu_to_mem_95		(vnu_msg_in[95]),
	.vnu_to_mem_96		(vnu_msg_in[96]),
	.vnu_to_mem_97		(vnu_msg_in[97]),
	.vnu_to_mem_98		(vnu_msg_in[98]),
	.vnu_to_mem_99		(vnu_msg_in[99]),
	.vnu_to_mem_100		(vnu_msg_in[100]),
	.vnu_to_mem_101		(vnu_msg_in[101]),
	.vnu_to_mem_102		(vnu_msg_in[102]),
	.vnu_to_mem_103		(vnu_msg_in[103]),
	.vnu_to_mem_104		(vnu_msg_in[104]),
	.vnu_to_mem_105		(vnu_msg_in[105]),
	.vnu_to_mem_106		(vnu_msg_in[106]),
	.vnu_to_mem_107		(vnu_msg_in[107]),
	.vnu_to_mem_108		(vnu_msg_in[108]),
	.vnu_to_mem_109		(vnu_msg_in[109]),
	.vnu_to_mem_110		(vnu_msg_in[110]),
	.vnu_to_mem_111		(vnu_msg_in[111]),
	.vnu_to_mem_112		(vnu_msg_in[112]),
	.vnu_to_mem_113		(vnu_msg_in[113]),
	.vnu_to_mem_114		(vnu_msg_in[114]),
	.vnu_to_mem_115		(vnu_msg_in[115]),
	.vnu_to_mem_116		(vnu_msg_in[116]),
	.vnu_to_mem_117		(vnu_msg_in[117]),
	.vnu_to_mem_118		(vnu_msg_in[118]),
	.vnu_to_mem_119		(vnu_msg_in[119]),
	.vnu_to_mem_120		(vnu_msg_in[120]),
	.vnu_to_mem_121		(vnu_msg_in[121]),
	.vnu_to_mem_122		(vnu_msg_in[122]),
	.vnu_to_mem_123		(vnu_msg_in[123]),
	.vnu_to_mem_124		(vnu_msg_in[124]),
	.vnu_to_mem_125		(vnu_msg_in[125]),
	.vnu_to_mem_126		(vnu_msg_in[126]),
	.vnu_to_mem_127		(vnu_msg_in[127]),
	.vnu_to_mem_128		(vnu_msg_in[128]),
	.vnu_to_mem_129		(vnu_msg_in[129]),
	.vnu_to_mem_130		(vnu_msg_in[130]),
	.vnu_to_mem_131		(vnu_msg_in[131]),
	.vnu_to_mem_132		(vnu_msg_in[132]),
	.vnu_to_mem_133		(vnu_msg_in[133]),
	.vnu_to_mem_134		(vnu_msg_in[134]),
	.vnu_to_mem_135		(vnu_msg_in[135]),
	.vnu_to_mem_136		(vnu_msg_in[136]),
	.vnu_to_mem_137		(vnu_msg_in[137]),
	.vnu_to_mem_138		(vnu_msg_in[138]),
	.vnu_to_mem_139		(vnu_msg_in[139]),
	.vnu_to_mem_140		(vnu_msg_in[140]),
	.vnu_to_mem_141		(vnu_msg_in[141]),
	.vnu_to_mem_142		(vnu_msg_in[142]),
	.vnu_to_mem_143		(vnu_msg_in[143]),
	.vnu_to_mem_144		(vnu_msg_in[144]),
	.vnu_to_mem_145		(vnu_msg_in[145]),
	.vnu_to_mem_146		(vnu_msg_in[146]),
	.vnu_to_mem_147		(vnu_msg_in[147]),
	.vnu_to_mem_148		(vnu_msg_in[148]),
	.vnu_to_mem_149		(vnu_msg_in[149]),
	.vnu_to_mem_150		(vnu_msg_in[150]),
	.vnu_to_mem_151		(vnu_msg_in[151]),
	.vnu_to_mem_152		(vnu_msg_in[152]),
	.vnu_to_mem_153		(vnu_msg_in[153]),
	.vnu_to_mem_154		(vnu_msg_in[154]),
	.vnu_to_mem_155		(vnu_msg_in[155]),
	.vnu_to_mem_156		(vnu_msg_in[156]),
	.vnu_to_mem_157		(vnu_msg_in[157]),
	.vnu_to_mem_158		(vnu_msg_in[158]),
	.vnu_to_mem_159		(vnu_msg_in[159]),
	.vnu_to_mem_160		(vnu_msg_in[160]),
	.vnu_to_mem_161		(vnu_msg_in[161]),
	.vnu_to_mem_162		(vnu_msg_in[162]),
	.vnu_to_mem_163		(vnu_msg_in[163]),
	.vnu_to_mem_164		(vnu_msg_in[164]),
	.vnu_to_mem_165		(vnu_msg_in[165]),
	.vnu_to_mem_166		(vnu_msg_in[166]),
	.vnu_to_mem_167		(vnu_msg_in[167]),
	.vnu_to_mem_168		(vnu_msg_in[168]),
	.vnu_to_mem_169		(vnu_msg_in[169]),
	.vnu_to_mem_170		(vnu_msg_in[170]),
	.vnu_to_mem_171		(vnu_msg_in[171]),
	.vnu_to_mem_172		(vnu_msg_in[172]),
	.vnu_to_mem_173		(vnu_msg_in[173]),
	.vnu_to_mem_174		(vnu_msg_in[174]),
	.vnu_to_mem_175		(vnu_msg_in[175]),
	.vnu_to_mem_176		(vnu_msg_in[176]),
	.vnu_to_mem_177		(vnu_msg_in[177]),
	.vnu_to_mem_178		(vnu_msg_in[178]),
	.vnu_to_mem_179		(vnu_msg_in[179]),
	.vnu_to_mem_180		(vnu_msg_in[180]),
	.vnu_to_mem_181		(vnu_msg_in[181]),
	.vnu_to_mem_182		(vnu_msg_in[182]),
	.vnu_to_mem_183		(vnu_msg_in[183]),
	.vnu_to_mem_184		(vnu_msg_in[184]),
	.vnu_to_mem_185		(vnu_msg_in[185]),
	.vnu_to_mem_186		(vnu_msg_in[186]),
	.vnu_to_mem_187		(vnu_msg_in[187]),
	.vnu_to_mem_188		(vnu_msg_in[188]),
	.vnu_to_mem_189		(vnu_msg_in[189]),
	.vnu_to_mem_190		(vnu_msg_in[190]),
	.vnu_to_mem_191		(vnu_msg_in[191]),
	.vnu_to_mem_192		(vnu_msg_in[192]),
	.vnu_to_mem_193		(vnu_msg_in[193]),
	.vnu_to_mem_194		(vnu_msg_in[194]),
	.vnu_to_mem_195		(vnu_msg_in[195]),
	.vnu_to_mem_196		(vnu_msg_in[196]),
	.vnu_to_mem_197		(vnu_msg_in[197]),
	.vnu_to_mem_198		(vnu_msg_in[198]),
	.vnu_to_mem_199		(vnu_msg_in[199]),
	.vnu_to_mem_200		(vnu_msg_in[200]),
	.vnu_to_mem_201		(vnu_msg_in[201]),
	.vnu_to_mem_202		(vnu_msg_in[202]),
	.vnu_to_mem_203		(vnu_msg_in[203]),
	.vnu_to_mem_204		(vnu_msg_in[204]),
	.vnu_to_mem_205		(vnu_msg_in[205]),
	.vnu_to_mem_206		(vnu_msg_in[206]),
	.vnu_to_mem_207		(vnu_msg_in[207]),
	.vnu_to_mem_208		(vnu_msg_in[208]),
	.vnu_to_mem_209		(vnu_msg_in[209]),
	.vnu_to_mem_210		(vnu_msg_in[210]),
	.vnu_to_mem_211		(vnu_msg_in[211]),
	.vnu_to_mem_212		(vnu_msg_in[212]),
	.vnu_to_mem_213		(vnu_msg_in[213]),
	.vnu_to_mem_214		(vnu_msg_in[214]),
	.vnu_to_mem_215		(vnu_msg_in[215]),
	.vnu_to_mem_216		(vnu_msg_in[216]),
	.vnu_to_mem_217		(vnu_msg_in[217]),
	.vnu_to_mem_218		(vnu_msg_in[218]),
	.vnu_to_mem_219		(vnu_msg_in[219]),
	.vnu_to_mem_220		(vnu_msg_in[220]),
	.vnu_to_mem_221		(vnu_msg_in[221]),
	.vnu_to_mem_222		(vnu_msg_in[222]),
	.vnu_to_mem_223		(vnu_msg_in[223]),
	.vnu_to_mem_224		(vnu_msg_in[224]),
	.vnu_to_mem_225		(vnu_msg_in[225]),
	.vnu_to_mem_226		(vnu_msg_in[226]),
	.vnu_to_mem_227		(vnu_msg_in[227]),
	.vnu_to_mem_228		(vnu_msg_in[228]),
	.vnu_to_mem_229		(vnu_msg_in[229]),
	.vnu_to_mem_230		(vnu_msg_in[230]),
	.vnu_to_mem_231		(vnu_msg_in[231]),
	.vnu_to_mem_232		(vnu_msg_in[232]),
	.vnu_to_mem_233		(vnu_msg_in[233]),
	.vnu_to_mem_234		(vnu_msg_in[234]),
	.vnu_to_mem_235		(vnu_msg_in[235]),
	.vnu_to_mem_236		(vnu_msg_in[236]),
	.vnu_to_mem_237		(vnu_msg_in[237]),
	.vnu_to_mem_238		(vnu_msg_in[238]),
	.vnu_to_mem_239		(vnu_msg_in[239]),
	.vnu_to_mem_240		(vnu_msg_in[240]),
	.vnu_to_mem_241		(vnu_msg_in[241]),
	.vnu_to_mem_242		(vnu_msg_in[242]),
	.vnu_to_mem_243		(vnu_msg_in[243]),
	.vnu_to_mem_244		(vnu_msg_in[244]),
	.vnu_to_mem_245		(vnu_msg_in[245]),
	.vnu_to_mem_246		(vnu_msg_in[246]),
	.vnu_to_mem_247		(vnu_msg_in[247]),
	.vnu_to_mem_248		(vnu_msg_in[248]),
	.vnu_to_mem_249		(vnu_msg_in[249]),
	.vnu_to_mem_250		(vnu_msg_in[250]),
	.vnu_to_mem_251		(vnu_msg_in[251]),
	.vnu_to_mem_252		(vnu_msg_in[252]),
	.vnu_to_mem_253		(vnu_msg_in[253]),
	.vnu_to_mem_254		(vnu_msg_in[254]),

	.cnu_to_mem_0		(cnu_msg_in[0]),
	.cnu_to_mem_1		(cnu_msg_in[1]),
	.cnu_to_mem_2		(cnu_msg_in[2]),
	.cnu_to_mem_3		(cnu_msg_in[3]),
	.cnu_to_mem_4		(cnu_msg_in[4]),
	.cnu_to_mem_5		(cnu_msg_in[5]),
	.cnu_to_mem_6		(cnu_msg_in[6]),
	.cnu_to_mem_7		(cnu_msg_in[7]),
	.cnu_to_mem_8		(cnu_msg_in[8]),
	.cnu_to_mem_9		(cnu_msg_in[9]),
	.cnu_to_mem_10		(cnu_msg_in[10]),
	.cnu_to_mem_11		(cnu_msg_in[11]),
	.cnu_to_mem_12		(cnu_msg_in[12]),
	.cnu_to_mem_13		(cnu_msg_in[13]),
	.cnu_to_mem_14		(cnu_msg_in[14]),
	.cnu_to_mem_15		(cnu_msg_in[15]),
	.cnu_to_mem_16		(cnu_msg_in[16]),
	.cnu_to_mem_17		(cnu_msg_in[17]),
	.cnu_to_mem_18		(cnu_msg_in[18]),
	.cnu_to_mem_19		(cnu_msg_in[19]),
	.cnu_to_mem_20		(cnu_msg_in[20]),
	.cnu_to_mem_21		(cnu_msg_in[21]),
	.cnu_to_mem_22		(cnu_msg_in[22]),
	.cnu_to_mem_23		(cnu_msg_in[23]),
	.cnu_to_mem_24		(cnu_msg_in[24]),
	.cnu_to_mem_25		(cnu_msg_in[25]),
	.cnu_to_mem_26		(cnu_msg_in[26]),
	.cnu_to_mem_27		(cnu_msg_in[27]),
	.cnu_to_mem_28		(cnu_msg_in[28]),
	.cnu_to_mem_29		(cnu_msg_in[29]),
	.cnu_to_mem_30		(cnu_msg_in[30]),
	.cnu_to_mem_31		(cnu_msg_in[31]),
	.cnu_to_mem_32		(cnu_msg_in[32]),
	.cnu_to_mem_33		(cnu_msg_in[33]),
	.cnu_to_mem_34		(cnu_msg_in[34]),
	.cnu_to_mem_35		(cnu_msg_in[35]),
	.cnu_to_mem_36		(cnu_msg_in[36]),
	.cnu_to_mem_37		(cnu_msg_in[37]),
	.cnu_to_mem_38		(cnu_msg_in[38]),
	.cnu_to_mem_39		(cnu_msg_in[39]),
	.cnu_to_mem_40		(cnu_msg_in[40]),
	.cnu_to_mem_41		(cnu_msg_in[41]),
	.cnu_to_mem_42		(cnu_msg_in[42]),
	.cnu_to_mem_43		(cnu_msg_in[43]),
	.cnu_to_mem_44		(cnu_msg_in[44]),
	.cnu_to_mem_45		(cnu_msg_in[45]),
	.cnu_to_mem_46		(cnu_msg_in[46]),
	.cnu_to_mem_47		(cnu_msg_in[47]),
	.cnu_to_mem_48		(cnu_msg_in[48]),
	.cnu_to_mem_49		(cnu_msg_in[49]),
	.cnu_to_mem_50		(cnu_msg_in[50]),
	.cnu_to_mem_51		(cnu_msg_in[51]),
	.cnu_to_mem_52		(cnu_msg_in[52]),
	.cnu_to_mem_53		(cnu_msg_in[53]),
	.cnu_to_mem_54		(cnu_msg_in[54]),
	.cnu_to_mem_55		(cnu_msg_in[55]),
	.cnu_to_mem_56		(cnu_msg_in[56]),
	.cnu_to_mem_57		(cnu_msg_in[57]),
	.cnu_to_mem_58		(cnu_msg_in[58]),
	.cnu_to_mem_59		(cnu_msg_in[59]),
	.cnu_to_mem_60		(cnu_msg_in[60]),
	.cnu_to_mem_61		(cnu_msg_in[61]),
	.cnu_to_mem_62		(cnu_msg_in[62]),
	.cnu_to_mem_63		(cnu_msg_in[63]),
	.cnu_to_mem_64		(cnu_msg_in[64]),
	.cnu_to_mem_65		(cnu_msg_in[65]),
	.cnu_to_mem_66		(cnu_msg_in[66]),
	.cnu_to_mem_67		(cnu_msg_in[67]),
	.cnu_to_mem_68		(cnu_msg_in[68]),
	.cnu_to_mem_69		(cnu_msg_in[69]),
	.cnu_to_mem_70		(cnu_msg_in[70]),
	.cnu_to_mem_71		(cnu_msg_in[71]),
	.cnu_to_mem_72		(cnu_msg_in[72]),
	.cnu_to_mem_73		(cnu_msg_in[73]),
	.cnu_to_mem_74		(cnu_msg_in[74]),
	.cnu_to_mem_75		(cnu_msg_in[75]),
	.cnu_to_mem_76		(cnu_msg_in[76]),
	.cnu_to_mem_77		(cnu_msg_in[77]),
	.cnu_to_mem_78		(cnu_msg_in[78]),
	.cnu_to_mem_79		(cnu_msg_in[79]),
	.cnu_to_mem_80		(cnu_msg_in[80]),
	.cnu_to_mem_81		(cnu_msg_in[81]),
	.cnu_to_mem_82		(cnu_msg_in[82]),
	.cnu_to_mem_83		(cnu_msg_in[83]),
	.cnu_to_mem_84		(cnu_msg_in[84]),
	.cnu_to_mem_85		(cnu_msg_in[85]),
	.cnu_to_mem_86		(cnu_msg_in[86]),
	.cnu_to_mem_87		(cnu_msg_in[87]),
	.cnu_to_mem_88		(cnu_msg_in[88]),
	.cnu_to_mem_89		(cnu_msg_in[89]),
	.cnu_to_mem_90		(cnu_msg_in[90]),
	.cnu_to_mem_91		(cnu_msg_in[91]),
	.cnu_to_mem_92		(cnu_msg_in[92]),
	.cnu_to_mem_93		(cnu_msg_in[93]),
	.cnu_to_mem_94		(cnu_msg_in[94]),
	.cnu_to_mem_95		(cnu_msg_in[95]),
	.cnu_to_mem_96		(cnu_msg_in[96]),
	.cnu_to_mem_97		(cnu_msg_in[97]),
	.cnu_to_mem_98		(cnu_msg_in[98]),
	.cnu_to_mem_99		(cnu_msg_in[99]),
	.cnu_to_mem_100		(cnu_msg_in[100]),
	.cnu_to_mem_101		(cnu_msg_in[101]),
	.cnu_to_mem_102		(cnu_msg_in[102]),
	.cnu_to_mem_103		(cnu_msg_in[103]),
	.cnu_to_mem_104		(cnu_msg_in[104]),
	.cnu_to_mem_105		(cnu_msg_in[105]),
	.cnu_to_mem_106		(cnu_msg_in[106]),
	.cnu_to_mem_107		(cnu_msg_in[107]),
	.cnu_to_mem_108		(cnu_msg_in[108]),
	.cnu_to_mem_109		(cnu_msg_in[109]),
	.cnu_to_mem_110		(cnu_msg_in[110]),
	.cnu_to_mem_111		(cnu_msg_in[111]),
	.cnu_to_mem_112		(cnu_msg_in[112]),
	.cnu_to_mem_113		(cnu_msg_in[113]),
	.cnu_to_mem_114		(cnu_msg_in[114]),
	.cnu_to_mem_115		(cnu_msg_in[115]),
	.cnu_to_mem_116		(cnu_msg_in[116]),
	.cnu_to_mem_117		(cnu_msg_in[117]),
	.cnu_to_mem_118		(cnu_msg_in[118]),
	.cnu_to_mem_119		(cnu_msg_in[119]),
	.cnu_to_mem_120		(cnu_msg_in[120]),
	.cnu_to_mem_121		(cnu_msg_in[121]),
	.cnu_to_mem_122		(cnu_msg_in[122]),
	.cnu_to_mem_123		(cnu_msg_in[123]),
	.cnu_to_mem_124		(cnu_msg_in[124]),
	.cnu_to_mem_125		(cnu_msg_in[125]),
	.cnu_to_mem_126		(cnu_msg_in[126]),
	.cnu_to_mem_127		(cnu_msg_in[127]),
	.cnu_to_mem_128		(cnu_msg_in[128]),
	.cnu_to_mem_129		(cnu_msg_in[129]),
	.cnu_to_mem_130		(cnu_msg_in[130]),
	.cnu_to_mem_131		(cnu_msg_in[131]),
	.cnu_to_mem_132		(cnu_msg_in[132]),
	.cnu_to_mem_133		(cnu_msg_in[133]),
	.cnu_to_mem_134		(cnu_msg_in[134]),
	.cnu_to_mem_135		(cnu_msg_in[135]),
	.cnu_to_mem_136		(cnu_msg_in[136]),
	.cnu_to_mem_137		(cnu_msg_in[137]),
	.cnu_to_mem_138		(cnu_msg_in[138]),
	.cnu_to_mem_139		(cnu_msg_in[139]),
	.cnu_to_mem_140		(cnu_msg_in[140]),
	.cnu_to_mem_141		(cnu_msg_in[141]),
	.cnu_to_mem_142		(cnu_msg_in[142]),
	.cnu_to_mem_143		(cnu_msg_in[143]),
	.cnu_to_mem_144		(cnu_msg_in[144]),
	.cnu_to_mem_145		(cnu_msg_in[145]),
	.cnu_to_mem_146		(cnu_msg_in[146]),
	.cnu_to_mem_147		(cnu_msg_in[147]),
	.cnu_to_mem_148		(cnu_msg_in[148]),
	.cnu_to_mem_149		(cnu_msg_in[149]),
	.cnu_to_mem_150		(cnu_msg_in[150]),
	.cnu_to_mem_151		(cnu_msg_in[151]),
	.cnu_to_mem_152		(cnu_msg_in[152]),
	.cnu_to_mem_153		(cnu_msg_in[153]),
	.cnu_to_mem_154		(cnu_msg_in[154]),
	.cnu_to_mem_155		(cnu_msg_in[155]),
	.cnu_to_mem_156		(cnu_msg_in[156]),
	.cnu_to_mem_157		(cnu_msg_in[157]),
	.cnu_to_mem_158		(cnu_msg_in[158]),
	.cnu_to_mem_159		(cnu_msg_in[159]),
	.cnu_to_mem_160		(cnu_msg_in[160]),
	.cnu_to_mem_161		(cnu_msg_in[161]),
	.cnu_to_mem_162		(cnu_msg_in[162]),
	.cnu_to_mem_163		(cnu_msg_in[163]),
	.cnu_to_mem_164		(cnu_msg_in[164]),
	.cnu_to_mem_165		(cnu_msg_in[165]),
	.cnu_to_mem_166		(cnu_msg_in[166]),
	.cnu_to_mem_167		(cnu_msg_in[167]),
	.cnu_to_mem_168		(cnu_msg_in[168]),
	.cnu_to_mem_169		(cnu_msg_in[169]),
	.cnu_to_mem_170		(cnu_msg_in[170]),
	.cnu_to_mem_171		(cnu_msg_in[171]),
	.cnu_to_mem_172		(cnu_msg_in[172]),
	.cnu_to_mem_173		(cnu_msg_in[173]),
	.cnu_to_mem_174		(cnu_msg_in[174]),
	.cnu_to_mem_175		(cnu_msg_in[175]),
	.cnu_to_mem_176		(cnu_msg_in[176]),
	.cnu_to_mem_177		(cnu_msg_in[177]),
	.cnu_to_mem_178		(cnu_msg_in[178]),
	.cnu_to_mem_179		(cnu_msg_in[179]),
	.cnu_to_mem_180		(cnu_msg_in[180]),
	.cnu_to_mem_181		(cnu_msg_in[181]),
	.cnu_to_mem_182		(cnu_msg_in[182]),
	.cnu_to_mem_183		(cnu_msg_in[183]),
	.cnu_to_mem_184		(cnu_msg_in[184]),
	.cnu_to_mem_185		(cnu_msg_in[185]),
	.cnu_to_mem_186		(cnu_msg_in[186]),
	.cnu_to_mem_187		(cnu_msg_in[187]),
	.cnu_to_mem_188		(cnu_msg_in[188]),
	.cnu_to_mem_189		(cnu_msg_in[189]),
	.cnu_to_mem_190		(cnu_msg_in[190]),
	.cnu_to_mem_191		(cnu_msg_in[191]),
	.cnu_to_mem_192		(cnu_msg_in[192]),
	.cnu_to_mem_193		(cnu_msg_in[193]),
	.cnu_to_mem_194		(cnu_msg_in[194]),
	.cnu_to_mem_195		(cnu_msg_in[195]),
	.cnu_to_mem_196		(cnu_msg_in[196]),
	.cnu_to_mem_197		(cnu_msg_in[197]),
	.cnu_to_mem_198		(cnu_msg_in[198]),
	.cnu_to_mem_199		(cnu_msg_in[199]),
	.cnu_to_mem_200		(cnu_msg_in[200]),
	.cnu_to_mem_201		(cnu_msg_in[201]),
	.cnu_to_mem_202		(cnu_msg_in[202]),
	.cnu_to_mem_203		(cnu_msg_in[203]),
	.cnu_to_mem_204		(cnu_msg_in[204]),
	.cnu_to_mem_205		(cnu_msg_in[205]),
	.cnu_to_mem_206		(cnu_msg_in[206]),
	.cnu_to_mem_207		(cnu_msg_in[207]),
	.cnu_to_mem_208		(cnu_msg_in[208]),
	.cnu_to_mem_209		(cnu_msg_in[209]),
	.cnu_to_mem_210		(cnu_msg_in[210]),
	.cnu_to_mem_211		(cnu_msg_in[211]),
	.cnu_to_mem_212		(cnu_msg_in[212]),
	.cnu_to_mem_213		(cnu_msg_in[213]),
	.cnu_to_mem_214		(cnu_msg_in[214]),
	.cnu_to_mem_215		(cnu_msg_in[215]),
	.cnu_to_mem_216		(cnu_msg_in[216]),
	.cnu_to_mem_217		(cnu_msg_in[217]),
	.cnu_to_mem_218		(cnu_msg_in[218]),
	.cnu_to_mem_219		(cnu_msg_in[219]),
	.cnu_to_mem_220		(cnu_msg_in[220]),
	.cnu_to_mem_221		(cnu_msg_in[221]),
	.cnu_to_mem_222		(cnu_msg_in[222]),
	.cnu_to_mem_223		(cnu_msg_in[223]),
	.cnu_to_mem_224		(cnu_msg_in[224]),
	.cnu_to_mem_225		(cnu_msg_in[225]),
	.cnu_to_mem_226		(cnu_msg_in[226]),
	.cnu_to_mem_227		(cnu_msg_in[227]),
	.cnu_to_mem_228		(cnu_msg_in[228]),
	.cnu_to_mem_229		(cnu_msg_in[229]),
	.cnu_to_mem_230		(cnu_msg_in[230]),
	.cnu_to_mem_231		(cnu_msg_in[231]),
	.cnu_to_mem_232		(cnu_msg_in[232]),
	.cnu_to_mem_233		(cnu_msg_in[233]),
	.cnu_to_mem_234		(cnu_msg_in[234]),
	.cnu_to_mem_235		(cnu_msg_in[235]),
	.cnu_to_mem_236		(cnu_msg_in[236]),
	.cnu_to_mem_237		(cnu_msg_in[237]),
	.cnu_to_mem_238		(cnu_msg_in[238]),
	.cnu_to_mem_239		(cnu_msg_in[239]),
	.cnu_to_mem_240		(cnu_msg_in[240]),
	.cnu_to_mem_241		(cnu_msg_in[241]),
	.cnu_to_mem_242		(cnu_msg_in[242]),
	.cnu_to_mem_243		(cnu_msg_in[243]),
	.cnu_to_mem_244		(cnu_msg_in[244]),
	.cnu_to_mem_245		(cnu_msg_in[245]),
	.cnu_to_mem_246		(cnu_msg_in[246]),
	.cnu_to_mem_247		(cnu_msg_in[247]),
	.cnu_to_mem_248		(cnu_msg_in[248]),
	.cnu_to_mem_249		(cnu_msg_in[249]),
	.cnu_to_mem_250		(cnu_msg_in[250]),
	.cnu_to_mem_251		(cnu_msg_in[251]),
	.cnu_to_mem_252		(cnu_msg_in[252]),
	.cnu_to_mem_253		(cnu_msg_in[253]),
	.cnu_to_mem_254		(cnu_msg_in[254]),

	.vnu_sync_addr    (vnu_mem_page_sync_addr),
	.cnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
	.vnu_layer_status (vnu_layer_cnt_sync[LAYER_NUM-1:0]), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
	.cnu_sub_row_status (cnu_sub_row_status[`ROW_SPLIT_FACTOR-1:0]),
	.vnu_sub_row_status (vnu_sub_row_status[`ROW_SPLIT_FACTOR-1:0]),
	.last_row_chunk   ({v2c_last_row_chunk, c2v_last_row_chunk}),
	.we               ({v2c_mem_we, c2v_mem_we}),
	.sys_clk          (read_clk),
	.rstn             (rstn)
);
assign vnu_layer_cnt_sync[LAYER_NUM-1:0] = (signExten_layer_cnt[LAYER_NUM-2] == 1'b1) ? signExten_layer_cnt[LAYER_NUM-1:0] : v2c_layer_cnt[LAYER_NUM-1:0];
assign cnu_mem_page_sync_addr = (v2c_mem_fetch == 1'b1) ? v2c_mem_page_rd_addr : 
								(c2v_mem_we == 1'b1) ? c2v_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
assign vnu_mem_page_sync_addr = (c2v_mem_fetch == 1'b1) ? c2v_mem_page_rd_addr : 
								(v2c_mem_we == 1'b1) ? v2c_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Check-to-Variable messages RAMs write-page addresses
reg [ADDR_WIDTH*ROW_SPLIT_FACTOR*LAYER_NUM-1:0] c2v_wr_page_addr_begin;
reg [ADDR_WIDTH-1:0] c2v_page_addr_base;
reg [$clog2(ROW_CHUNK_NUM)-1:0] page_zero_flag;
always @(posedge read_clk) begin
	if(rstn == 1'b0) 
		c2v_mem_page_addr <= `START_PAGE_BS_1_0_0+C2V_MEM_ADDR_BASE;
	else if(c2v_mem_we == 1'b1) begin
		if(c2v_row_chunk_cnt[page_zero_flag[$clog2(ROW_CHUNK_NUM)-1:0]-1] == 1'b1)
			c2v_mem_page_addr <= c2v_wr_page_addr_begin[ADDR_WIDTH-1:0]+c2v_page_addr_base;
		else
			c2v_mem_page_addr <= c2v_mem_page_addr+1;
	end
end

always @(posedge read_clk) begin
	if(rstn == 1'b0) page_zero_flag[$clog2(ROW_CHUNK_NUM)-1:0] <= 0;
	else page_zero_flag[$clog2(ROW_CHUNK_NUM)-1:0] <= ROW_CHUNK_NUM-c2v_wr_page_addr_begin[ADDR_WIDTH-1:0][$clog2(ROW_CHUNK_NUM)-1:0];
end

always @(posedge read_clk) begin
	if(rstn == 1'b0) begin
		// Layer 0
		c2v_wr_page_addr_begin[(ADDR_WIDTH*1)-1:(ADDR_WIDTH*0)] <= `START_PAGE_BS_1_0_0+C2V_MEM_ADDR_BASE;
		c2v_wr_page_addr_begin[(ADDR_WIDTH*2)-1:(ADDR_WIDTH*1)] <= `START_PAGE_BS_1_1_0+C2V_MEM_ADDR_BASE;
		c2v_wr_page_addr_begin[(ADDR_WIDTH*3)-1:(ADDR_WIDTH*2)] <= `START_PAGE_BS_1_2_0+C2V_MEM_ADDR_BASE;
		c2v_wr_page_addr_begin[(ADDR_WIDTH*4)-1:(ADDR_WIDTH*3)] <= `START_PAGE_BS_1_3_0+C2V_MEM_ADDR_BASE;
		c2v_wr_page_addr_begin[(ADDR_WIDTH*5)-1:(ADDR_WIDTH*4)] <= `START_PAGE_BS_1_4_0+C2V_MEM_ADDR_BASE;
		// Layer 1
		c2v_wr_page_addr_begin[(ADDR_WIDTH*6 )-1:(ADDR_WIDTH*5)] <= `START_PAGE_BS_1_0_1+C2V_MEM_ADDR_BASE;
		c2v_wr_page_addr_begin[(ADDR_WIDTH*7 )-1:(ADDR_WIDTH*6)] <= `START_PAGE_BS_1_1_1+C2V_MEM_ADDR_BASE;
		c2v_wr_page_addr_begin[(ADDR_WIDTH*8 )-1:(ADDR_WIDTH*7)] <= `START_PAGE_BS_1_2_1+C2V_MEM_ADDR_BASE;
		c2v_wr_page_addr_begin[(ADDR_WIDTH*9 )-1:(ADDR_WIDTH*8)] <= `START_PAGE_BS_1_3_1+C2V_MEM_ADDR_BASE;
		c2v_wr_page_addr_begin[(ADDR_WIDTH*10)-1:(ADDR_WIDTH*9)] <= `START_PAGE_BS_1_4_1+C2V_MEM_ADDR_BASE;
		// Layer 2
		c2v_wr_page_addr_begin[(ADDR_WIDTH*11)-1:(ADDR_WIDTH*10)] <= `START_PAGE_BS_1_0_2+C2V_MEM_ADDR_BASE;
		c2v_wr_page_addr_begin[(ADDR_WIDTH*12)-1:(ADDR_WIDTH*11)] <= `START_PAGE_BS_1_1_2+C2V_MEM_ADDR_BASE;
		c2v_wr_page_addr_begin[(ADDR_WIDTH*13)-1:(ADDR_WIDTH*12)] <= `START_PAGE_BS_1_2_2+C2V_MEM_ADDR_BASE;
		c2v_wr_page_addr_begin[(ADDR_WIDTH*14)-1:(ADDR_WIDTH*13)] <= `START_PAGE_BS_1_3_2+C2V_MEM_ADDR_BASE;
		c2v_wr_page_addr_begin[(ADDR_WIDTH*15)-1:(ADDR_WIDTH*14)] <= `START_PAGE_BS_1_4_2+C2V_MEM_ADDR_BASE;
	end
	else if(cnu_sub_row_status[`ROW_SPLIT_FACTOR-2] == 1'b1 && c2v_mem_we == 1'b1)
		c2v_wr_page_addr_begin[ADDR_WIDTH*ROW_SPLIT_FACTOR*LAYER_NUM-1:0] <= {c2v_wr_page_addr_begin[ADDR_WIDTH-1:0], c2v_wr_page_addr_begin[ADDR_WIDTH*ROW_SPLIT_FACTOR*LAYER_NUM-1:ADDR_WIDTH]}; 
end

always @(posedge read_clk) begin
	if(rstn == 1'b0) c2v_page_addr_base <= C2V_MEM_ADDR_BASE;
	else if(cnu_sub_row_status[`ROW_SPLIT_FACTOR-2] == 1'b1 && c2v_mem_we == 1'b1 == 1'b1) c2v_page_addr_base <= c2v_page_addr_base+LAYER_NUM;
end

always @(posedge read_clk) begin
	if(rstn == 1'b0) begin
		c2v_shift_factor_cur_2 <= shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
		c2v_shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
		c2v_shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
	end
	else if(c2v_bs_en == 1'b1) begin
		c2v_shift_factor_cur_2 <= c2v_shift_factor_cur_0[BITWIDTH_SHIFT_FACTOR-1:0];
		c2v_shift_factor_cur_1 <= c2v_shift_factor_cur_2[BITWIDTH_SHIFT_FACTOR-1:0];
		c2v_shift_factor_cur_0 <= c2v_shift_factor_cur_1[BITWIDTH_SHIFT_FACTOR-1:0];
	end
end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Variable-to-Check messages RAMs write-page addresses
always @(posedge read_clk) begin
	if(rstn == 1'b0) 
		v2c_mem_page_addr <= START_PAGE_1_0+V2C_MEM_ADDR_BASE;
	else if(v2c_mem_we == 1'b1) begin
		// page increment pattern within layer 0
		if(v2c_layer_cnt[0] == 1) begin
			if(v2c_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
				v2c_mem_page_addr <= START_PAGE_1_1+V2C_MEM_ADDR_BASE; // to move on to beginning of layer 1
			else if(v2c_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
					v2c_mem_page_addr <= V2C_MEM_ADDR_BASE; 
			else
				v2c_mem_page_addr <= v2c_mem_page_addr+1;
		end
		// page increment pattern within layer 1
		if(v2c_layer_cnt[1] == 1) begin
			if(v2c_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
				v2c_mem_page_addr <= START_PAGE_1_2+V2C_MEM_ADDR_BASE; // to move on to beginning of layer 1
			else if(v2c_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
					v2c_mem_page_addr <= V2C_MEM_ADDR_BASE; 
			else
				v2c_mem_page_addr <= v2c_mem_page_addr+1;
		end
		// page increment pattern within layer 2
		if(v2c_layer_cnt[2] == 1) begin
			if(v2c_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
				v2c_mem_page_addr <= START_PAGE_1_0+V2C_MEM_ADDR_BASE; // to move on to beginning of layer 1
			else if(v2c_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_2-1] == 1'b1)
					v2c_mem_page_addr <= V2C_MEM_ADDR_BASE; 
			else
				v2c_mem_page_addr <= v2c_mem_page_addr+1;
		end
	end
end
always @(posedge read_clk) begin
	if(rstn == 1'b0) begin
		v2c_shift_factor_cur_2 <= shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
		v2c_shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
		v2c_shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
	end
	else if(v2c_bs_en == 1'b1) begin
		v2c_shift_factor_cur_2 <= v2c_shift_factor_cur_0[BITWIDTH_SHIFT_FACTOR-1:0];
		v2c_shift_factor_cur_1 <= v2c_shift_factor_cur_2[BITWIDTH_SHIFT_FACTOR-1:0];
		v2c_shift_factor_cur_0 <= v2c_shift_factor_cur_1[BITWIDTH_SHIFT_FACTOR-1:0];
	end
end
/*-------------------------------------------------------------------------------------------------------------------------*/
// Channel Buffers
reg [CH_DATA_WIDTH-1:0] ch_msg_genIn;
wire [CH_DATA_WIDTH-1:0] ch_ram_din;
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_0 [0:CHECK_PARALLELISM-1]; // [0:84]
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_1 [0:CHECK_PARALLELISM-1]; // [0:84]
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_2 [0:CHECK_PARALLELISM-1]; // [0:84]
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_rd_addr;
wire [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chInit_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chLayer_wr_addr;
reg [$clog2(ROW_CHUNK_NUM)-1:0] submatrix_signExten_ram_rd_addr;
reg [$clog2(ROW_CHUNK_NUM)-1:0] submatrix_signExten_ram_wr_addr;
/*----------------------------*/
wire ch_ram_we; assign ch_ram_we = ch_ram_init_we || ch_ram_wb;
	ch_msg_ram #(
		.QUAN_SIZE(QUAN_SIZE),
		.LAYER_NUM(LAYER_NUM),
		.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
		.CHECK_PARALLELISM(CHECK_PARALLELISM),
		.DEPTH(CH_RAM_DEPTH),
		.DATA_WIDTH(CH_DATA_WIDTH),
		.ADDR_WIDTH($clog2(CH_RAM_DEPTH)),
		.VNU_FETCH_LATENCY (CH_FETCH_LATENCY),
		.CNU_FETCH_LATENCY (CNU_INIT_FETCH_LATENCY)
	) inst_ch_msg_ram (
		.dout_0     (ch_msg_fetchOut_1[0 ]),
		.dout_1     (ch_msg_fetchOut_1[1 ]),
		.dout_2     (ch_msg_fetchOut_1[2 ]),
		.dout_3     (ch_msg_fetchOut_1[3 ]),
		.dout_4     (ch_msg_fetchOut_1[4 ]),
		.dout_5     (ch_msg_fetchOut_1[5 ]),
		.dout_6     (ch_msg_fetchOut_1[6 ]),
		.dout_7     (ch_msg_fetchOut_1[7 ]),
		.dout_8     (ch_msg_fetchOut_1[8 ]),
		.dout_9     (ch_msg_fetchOut_1[9 ]),
		.dout_10    (ch_msg_fetchOut_1[10]),
		.dout_11    (ch_msg_fetchOut_1[11]),
		.dout_12    (ch_msg_fetchOut_1[12]),
		.dout_13    (ch_msg_fetchOut_1[13]),
		.dout_14    (ch_msg_fetchOut_1[14]),
		.dout_15    (ch_msg_fetchOut_1[15]),
		.dout_16    (ch_msg_fetchOut_1[16]),
		.dout_17    (ch_msg_fetchOut_1[17]),
		.dout_18    (ch_msg_fetchOut_1[18]),
		.dout_19    (ch_msg_fetchOut_1[19]),
		.dout_20    (ch_msg_fetchOut_1[20]),
		.dout_21    (ch_msg_fetchOut_1[21]),
		.dout_22    (ch_msg_fetchOut_1[22]),
		.dout_23    (ch_msg_fetchOut_1[23]),
		.dout_24    (ch_msg_fetchOut_1[24]),
		.dout_25    (ch_msg_fetchOut_1[25]),
		.dout_26    (ch_msg_fetchOut_1[26]),
		.dout_27    (ch_msg_fetchOut_1[27]),
		.dout_28    (ch_msg_fetchOut_1[28]),
		.dout_29    (ch_msg_fetchOut_1[29]),
		.dout_30    (ch_msg_fetchOut_1[30]),
		.dout_31    (ch_msg_fetchOut_1[31]),
		.dout_32    (ch_msg_fetchOut_1[32]),
		.dout_33    (ch_msg_fetchOut_1[33]),
		.dout_34    (ch_msg_fetchOut_1[34]),
		.dout_35    (ch_msg_fetchOut_1[35]),
		.dout_36    (ch_msg_fetchOut_1[36]),
		.dout_37    (ch_msg_fetchOut_1[37]),
		.dout_38    (ch_msg_fetchOut_1[38]),
		.dout_39    (ch_msg_fetchOut_1[39]),
		.dout_40    (ch_msg_fetchOut_1[40]),
		.dout_41    (ch_msg_fetchOut_1[41]),
		.dout_42    (ch_msg_fetchOut_1[42]),
		.dout_43    (ch_msg_fetchOut_1[43]),
		.dout_44    (ch_msg_fetchOut_1[44]),
		.dout_45    (ch_msg_fetchOut_1[45]),
		.dout_46    (ch_msg_fetchOut_1[46]),
		.dout_47    (ch_msg_fetchOut_1[47]),
		.dout_48    (ch_msg_fetchOut_1[48]),
		.dout_49    (ch_msg_fetchOut_1[49]),
		.dout_50    (ch_msg_fetchOut_1[50]),
		.dout_51    (ch_msg_fetchOut_1[51]),
		.dout_52    (ch_msg_fetchOut_1[52]),
		.dout_53    (ch_msg_fetchOut_1[53]),
		.dout_54    (ch_msg_fetchOut_1[54]),
		.dout_55    (ch_msg_fetchOut_1[55]),
		.dout_56    (ch_msg_fetchOut_1[56]),
		.dout_57    (ch_msg_fetchOut_1[57]),
		.dout_58    (ch_msg_fetchOut_1[58]),
		.dout_59    (ch_msg_fetchOut_1[59]),
		.dout_60    (ch_msg_fetchOut_1[60]),
		.dout_61    (ch_msg_fetchOut_1[61]),
		.dout_62    (ch_msg_fetchOut_1[62]),
		.dout_63    (ch_msg_fetchOut_1[63]),
		.dout_64    (ch_msg_fetchOut_1[64]),
		.dout_65    (ch_msg_fetchOut_1[65]),
		.dout_66    (ch_msg_fetchOut_1[66]),
		.dout_67    (ch_msg_fetchOut_1[67]),
		.dout_68    (ch_msg_fetchOut_1[68]),
		.dout_69    (ch_msg_fetchOut_1[69]),
		.dout_70    (ch_msg_fetchOut_1[70]),
		.dout_71    (ch_msg_fetchOut_1[71]),
		.dout_72    (ch_msg_fetchOut_1[72]),
		.dout_73    (ch_msg_fetchOut_1[73]),
		.dout_74    (ch_msg_fetchOut_1[74]),
		.dout_75    (ch_msg_fetchOut_1[75]),
		.dout_76    (ch_msg_fetchOut_1[76]),
		.dout_77    (ch_msg_fetchOut_1[77]),
		.dout_78    (ch_msg_fetchOut_1[78]),
		.dout_79    (ch_msg_fetchOut_1[79]),
		.dout_80    (ch_msg_fetchOut_1[80]),
		.dout_81    (ch_msg_fetchOut_1[81]),
		.dout_82    (ch_msg_fetchOut_1[82]),
		.dout_83    (ch_msg_fetchOut_1[83]),
		.dout_84    (ch_msg_fetchOut_1[84]),
		// For CNUs at first iteration as their inital v2c messages, i.e., channel messages of all associative VNUs
		.cnu_init_dout_0     (ch_msg_fetchOut_0[0 ]),
		.cnu_init_dout_1     (ch_msg_fetchOut_0[1 ]),
		.cnu_init_dout_2     (ch_msg_fetchOut_0[2 ]),
		.cnu_init_dout_3     (ch_msg_fetchOut_0[3 ]),
		.cnu_init_dout_4     (ch_msg_fetchOut_0[4 ]),
		.cnu_init_dout_5     (ch_msg_fetchOut_0[5 ]),
		.cnu_init_dout_6     (ch_msg_fetchOut_0[6 ]),
		.cnu_init_dout_7     (ch_msg_fetchOut_0[7 ]),
		.cnu_init_dout_8     (ch_msg_fetchOut_0[8 ]),
		.cnu_init_dout_9     (ch_msg_fetchOut_0[9 ]),
		.cnu_init_dout_10    (ch_msg_fetchOut_0[10]),
		.cnu_init_dout_11    (ch_msg_fetchOut_0[11]),
		.cnu_init_dout_12    (ch_msg_fetchOut_0[12]),
		.cnu_init_dout_13    (ch_msg_fetchOut_0[13]),
		.cnu_init_dout_14    (ch_msg_fetchOut_0[14]),
		.cnu_init_dout_15    (ch_msg_fetchOut_0[15]),
		.cnu_init_dout_16    (ch_msg_fetchOut_0[16]),
		.cnu_init_dout_17    (ch_msg_fetchOut_0[17]),
		.cnu_init_dout_18    (ch_msg_fetchOut_0[18]),
		.cnu_init_dout_19    (ch_msg_fetchOut_0[19]),
		.cnu_init_dout_20    (ch_msg_fetchOut_0[20]),
		.cnu_init_dout_21    (ch_msg_fetchOut_0[21]),
		.cnu_init_dout_22    (ch_msg_fetchOut_0[22]),
		.cnu_init_dout_23    (ch_msg_fetchOut_0[23]),
		.cnu_init_dout_24    (ch_msg_fetchOut_0[24]),
		.cnu_init_dout_25    (ch_msg_fetchOut_0[25]),
		.cnu_init_dout_26    (ch_msg_fetchOut_0[26]),
		.cnu_init_dout_27    (ch_msg_fetchOut_0[27]),
		.cnu_init_dout_28    (ch_msg_fetchOut_0[28]),
		.cnu_init_dout_29    (ch_msg_fetchOut_0[29]),
		.cnu_init_dout_30    (ch_msg_fetchOut_0[30]),
		.cnu_init_dout_31    (ch_msg_fetchOut_0[31]),
		.cnu_init_dout_32    (ch_msg_fetchOut_0[32]),
		.cnu_init_dout_33    (ch_msg_fetchOut_0[33]),
		.cnu_init_dout_34    (ch_msg_fetchOut_0[34]),
		.cnu_init_dout_35    (ch_msg_fetchOut_0[35]),
		.cnu_init_dout_36    (ch_msg_fetchOut_0[36]),
		.cnu_init_dout_37    (ch_msg_fetchOut_0[37]),
		.cnu_init_dout_38    (ch_msg_fetchOut_0[38]),
		.cnu_init_dout_39    (ch_msg_fetchOut_0[39]),
		.cnu_init_dout_40    (ch_msg_fetchOut_0[40]),
		.cnu_init_dout_41    (ch_msg_fetchOut_0[41]),
		.cnu_init_dout_42    (ch_msg_fetchOut_0[42]),
		.cnu_init_dout_43    (ch_msg_fetchOut_0[43]),
		.cnu_init_dout_44    (ch_msg_fetchOut_0[44]),
		.cnu_init_dout_45    (ch_msg_fetchOut_0[45]),
		.cnu_init_dout_46    (ch_msg_fetchOut_0[46]),
		.cnu_init_dout_47    (ch_msg_fetchOut_0[47]),
		.cnu_init_dout_48    (ch_msg_fetchOut_0[48]),
		.cnu_init_dout_49    (ch_msg_fetchOut_0[49]),
		.cnu_init_dout_50    (ch_msg_fetchOut_0[50]),
		.cnu_init_dout_51    (ch_msg_fetchOut_0[51]),
		.cnu_init_dout_52    (ch_msg_fetchOut_0[52]),
		.cnu_init_dout_53    (ch_msg_fetchOut_0[53]),
		.cnu_init_dout_54    (ch_msg_fetchOut_0[54]),
		.cnu_init_dout_55    (ch_msg_fetchOut_0[55]),
		.cnu_init_dout_56    (ch_msg_fetchOut_0[56]),
		.cnu_init_dout_57    (ch_msg_fetchOut_0[57]),
		.cnu_init_dout_58    (ch_msg_fetchOut_0[58]),
		.cnu_init_dout_59    (ch_msg_fetchOut_0[59]),
		.cnu_init_dout_60    (ch_msg_fetchOut_0[60]),
		.cnu_init_dout_61    (ch_msg_fetchOut_0[61]),
		.cnu_init_dout_62    (ch_msg_fetchOut_0[62]),
		.cnu_init_dout_63    (ch_msg_fetchOut_0[63]),
		.cnu_init_dout_64    (ch_msg_fetchOut_0[64]),
		.cnu_init_dout_65    (ch_msg_fetchOut_0[65]),
		.cnu_init_dout_66    (ch_msg_fetchOut_0[66]),
		.cnu_init_dout_67    (ch_msg_fetchOut_0[67]),
		.cnu_init_dout_68    (ch_msg_fetchOut_0[68]),
		.cnu_init_dout_69    (ch_msg_fetchOut_0[69]),
		.cnu_init_dout_70    (ch_msg_fetchOut_0[70]),
		.cnu_init_dout_71    (ch_msg_fetchOut_0[71]),
		.cnu_init_dout_72    (ch_msg_fetchOut_0[72]),
		.cnu_init_dout_73    (ch_msg_fetchOut_0[73]),
		.cnu_init_dout_74    (ch_msg_fetchOut_0[74]),
		.cnu_init_dout_75    (ch_msg_fetchOut_0[75]),
		.cnu_init_dout_76    (ch_msg_fetchOut_0[76]),
		.cnu_init_dout_77    (ch_msg_fetchOut_0[77]),
		.cnu_init_dout_78    (ch_msg_fetchOut_0[78]),
		.cnu_init_dout_79    (ch_msg_fetchOut_0[79]),
		.cnu_init_dout_80    (ch_msg_fetchOut_0[80]),
		.cnu_init_dout_81    (ch_msg_fetchOut_0[81]),
		.cnu_init_dout_82    (ch_msg_fetchOut_0[82]),
		.cnu_init_dout_83    (ch_msg_fetchOut_0[83]),
		.cnu_init_dout_84    (ch_msg_fetchOut_0[84]),
		// For input sources of permutation network
		.bs_src_dout_0     (ch_msg_fetchOut_2[0 ]),
		.bs_src_dout_1     (ch_msg_fetchOut_2[1 ]),
		.bs_src_dout_2     (ch_msg_fetchOut_2[2 ]),
		.bs_src_dout_3     (ch_msg_fetchOut_2[3 ]),
		.bs_src_dout_4     (ch_msg_fetchOut_2[4 ]),
		.bs_src_dout_5     (ch_msg_fetchOut_2[5 ]),
		.bs_src_dout_6     (ch_msg_fetchOut_2[6 ]),
		.bs_src_dout_7     (ch_msg_fetchOut_2[7 ]),
		.bs_src_dout_8     (ch_msg_fetchOut_2[8 ]),
		.bs_src_dout_9     (ch_msg_fetchOut_2[9 ]),
		.bs_src_dout_10    (ch_msg_fetchOut_2[10]),
		.bs_src_dout_11    (ch_msg_fetchOut_2[11]),
		.bs_src_dout_12    (ch_msg_fetchOut_2[12]),
		.bs_src_dout_13    (ch_msg_fetchOut_2[13]),
		.bs_src_dout_14    (ch_msg_fetchOut_2[14]),
		.bs_src_dout_15    (ch_msg_fetchOut_2[15]),
		.bs_src_dout_16    (ch_msg_fetchOut_2[16]),
		.bs_src_dout_17    (ch_msg_fetchOut_2[17]),
		.bs_src_dout_18    (ch_msg_fetchOut_2[18]),
		.bs_src_dout_19    (ch_msg_fetchOut_2[19]),
		.bs_src_dout_20    (ch_msg_fetchOut_2[20]),
		.bs_src_dout_21    (ch_msg_fetchOut_2[21]),
		.bs_src_dout_22    (ch_msg_fetchOut_2[22]),
		.bs_src_dout_23    (ch_msg_fetchOut_2[23]),
		.bs_src_dout_24    (ch_msg_fetchOut_2[24]),
		.bs_src_dout_25    (ch_msg_fetchOut_2[25]),
		.bs_src_dout_26    (ch_msg_fetchOut_2[26]),
		.bs_src_dout_27    (ch_msg_fetchOut_2[27]),
		.bs_src_dout_28    (ch_msg_fetchOut_2[28]),
		.bs_src_dout_29    (ch_msg_fetchOut_2[29]),
		.bs_src_dout_30    (ch_msg_fetchOut_2[30]),
		.bs_src_dout_31    (ch_msg_fetchOut_2[31]),
		.bs_src_dout_32    (ch_msg_fetchOut_2[32]),
		.bs_src_dout_33    (ch_msg_fetchOut_2[33]),
		.bs_src_dout_34    (ch_msg_fetchOut_2[34]),
		.bs_src_dout_35    (ch_msg_fetchOut_2[35]),
		.bs_src_dout_36    (ch_msg_fetchOut_2[36]),
		.bs_src_dout_37    (ch_msg_fetchOut_2[37]),
		.bs_src_dout_38    (ch_msg_fetchOut_2[38]),
		.bs_src_dout_39    (ch_msg_fetchOut_2[39]),
		.bs_src_dout_40    (ch_msg_fetchOut_2[40]),
		.bs_src_dout_41    (ch_msg_fetchOut_2[41]),
		.bs_src_dout_42    (ch_msg_fetchOut_2[42]),
		.bs_src_dout_43    (ch_msg_fetchOut_2[43]),
		.bs_src_dout_44    (ch_msg_fetchOut_2[44]),
		.bs_src_dout_45    (ch_msg_fetchOut_2[45]),
		.bs_src_dout_46    (ch_msg_fetchOut_2[46]),
		.bs_src_dout_47    (ch_msg_fetchOut_2[47]),
		.bs_src_dout_48    (ch_msg_fetchOut_2[48]),
		.bs_src_dout_49    (ch_msg_fetchOut_2[49]),
		.bs_src_dout_50    (ch_msg_fetchOut_2[50]),
		.bs_src_dout_51    (ch_msg_fetchOut_2[51]),
		.bs_src_dout_52    (ch_msg_fetchOut_2[52]),
		.bs_src_dout_53    (ch_msg_fetchOut_2[53]),
		.bs_src_dout_54    (ch_msg_fetchOut_2[54]),
		.bs_src_dout_55    (ch_msg_fetchOut_2[55]),
		.bs_src_dout_56    (ch_msg_fetchOut_2[56]),
		.bs_src_dout_57    (ch_msg_fetchOut_2[57]),
		.bs_src_dout_58    (ch_msg_fetchOut_2[58]),
		.bs_src_dout_59    (ch_msg_fetchOut_2[59]),
		.bs_src_dout_60    (ch_msg_fetchOut_2[60]),
		.bs_src_dout_61    (ch_msg_fetchOut_2[61]),
		.bs_src_dout_62    (ch_msg_fetchOut_2[62]),
		.bs_src_dout_63    (ch_msg_fetchOut_2[63]),
		.bs_src_dout_64    (ch_msg_fetchOut_2[64]),
		.bs_src_dout_65    (ch_msg_fetchOut_2[65]),
		.bs_src_dout_66    (ch_msg_fetchOut_2[66]),
		.bs_src_dout_67    (ch_msg_fetchOut_2[67]),
		.bs_src_dout_68    (ch_msg_fetchOut_2[68]),
		.bs_src_dout_69    (ch_msg_fetchOut_2[69]),
		.bs_src_dout_70    (ch_msg_fetchOut_2[70]),
		.bs_src_dout_71    (ch_msg_fetchOut_2[71]),
		.bs_src_dout_72    (ch_msg_fetchOut_2[72]),
		.bs_src_dout_73    (ch_msg_fetchOut_2[73]),
		.bs_src_dout_74    (ch_msg_fetchOut_2[74]),
		.bs_src_dout_75    (ch_msg_fetchOut_2[75]),
		.bs_src_dout_76    (ch_msg_fetchOut_2[76]),
		.bs_src_dout_77    (ch_msg_fetchOut_2[77]),
		.bs_src_dout_78    (ch_msg_fetchOut_2[78]),
		.bs_src_dout_79    (ch_msg_fetchOut_2[79]),
		.bs_src_dout_80    (ch_msg_fetchOut_2[80]),
		.bs_src_dout_81    (ch_msg_fetchOut_2[81]),
		.bs_src_dout_82    (ch_msg_fetchOut_2[82]),
		.bs_src_dout_83    (ch_msg_fetchOut_2[83]),
		.bs_src_dout_84    (ch_msg_fetchOut_2[84]),

		.din        (ch_ram_din[CH_DATA_WIDTH-1:0]),

		.read_addr  (submatrix_ch_ram_rd_addr[CH_RAM_ADDR_WIDTH-1:0]),
		.write_addr (submatrix_ch_ram_wr_addr[CH_RAM_ADDR_WIDTH-1:0]),
		.we         (ch_ram_we),
		.read_clk   (ch_ram_rd_clk),
		.write_clk  (ch_ram_wr_clk),
		.rstn       (rstn)
	);
	// To assign the net output ports of channel buffer
	assign ch_to_vnu[CH_DATA_WIDTH-1:0] = {ch_msg_fetchOut_1[84],ch_msg_fetchOut_1[83],ch_msg_fetchOut_1[82],ch_msg_fetchOut_1[81],ch_msg_fetchOut_1[80],ch_msg_fetchOut_1[79],ch_msg_fetchOut_1[78],ch_msg_fetchOut_1[77],ch_msg_fetchOut_1[76],ch_msg_fetchOut_1[75],ch_msg_fetchOut_1[74],ch_msg_fetchOut_1[73],ch_msg_fetchOut_1[72],ch_msg_fetchOut_1[71],ch_msg_fetchOut_1[70],ch_msg_fetchOut_1[69],ch_msg_fetchOut_1[68],ch_msg_fetchOut_1[67],ch_msg_fetchOut_1[66],ch_msg_fetchOut_1[65],ch_msg_fetchOut_1[64],ch_msg_fetchOut_1[63],ch_msg_fetchOut_1[62],ch_msg_fetchOut_1[61],ch_msg_fetchOut_1[60],ch_msg_fetchOut_1[59],ch_msg_fetchOut_1[58],ch_msg_fetchOut_1[57],ch_msg_fetchOut_1[56],ch_msg_fetchOut_1[55],ch_msg_fetchOut_1[54],ch_msg_fetchOut_1[53],ch_msg_fetchOut_1[52],ch_msg_fetchOut_1[51],ch_msg_fetchOut_1[50],ch_msg_fetchOut_1[49],ch_msg_fetchOut_1[48],ch_msg_fetchOut_1[47],ch_msg_fetchOut_1[46],ch_msg_fetchOut_1[45],ch_msg_fetchOut_1[44],ch_msg_fetchOut_1[43],ch_msg_fetchOut_1[42],ch_msg_fetchOut_1[41],ch_msg_fetchOut_1[40],ch_msg_fetchOut_1[39],ch_msg_fetchOut_1[38],ch_msg_fetchOut_1[37],ch_msg_fetchOut_1[36],ch_msg_fetchOut_1[35],ch_msg_fetchOut_1[34],ch_msg_fetchOut_1[33],ch_msg_fetchOut_1[32],ch_msg_fetchOut_1[31],ch_msg_fetchOut_1[30],ch_msg_fetchOut_1[29],ch_msg_fetchOut_1[28],ch_msg_fetchOut_1[27],ch_msg_fetchOut_1[26],ch_msg_fetchOut_1[25],ch_msg_fetchOut_1[24],ch_msg_fetchOut_1[23],ch_msg_fetchOut_1[22],ch_msg_fetchOut_1[21],ch_msg_fetchOut_1[20],ch_msg_fetchOut_1[19],ch_msg_fetchOut_1[18],ch_msg_fetchOut_1[17],ch_msg_fetchOut_1[16],ch_msg_fetchOut_1[15],ch_msg_fetchOut_1[14],ch_msg_fetchOut_1[13],ch_msg_fetchOut_1[12],ch_msg_fetchOut_1[11],ch_msg_fetchOut_1[10],ch_msg_fetchOut_1[9],ch_msg_fetchOut_1[8],ch_msg_fetchOut_1[7],ch_msg_fetchOut_1[6],ch_msg_fetchOut_1[5],ch_msg_fetchOut_1[4],ch_msg_fetchOut_1[3],ch_msg_fetchOut_1[2],ch_msg_fetchOut_1[1],ch_msg_fetchOut_1[0]};
	assign ch_to_cnu[CH_DATA_WIDTH-1:0] = {ch_msg_fetchOut_0[84],ch_msg_fetchOut_0[83],ch_msg_fetchOut_0[82],ch_msg_fetchOut_0[81],ch_msg_fetchOut_0[80],ch_msg_fetchOut_0[79],ch_msg_fetchOut_0[78],ch_msg_fetchOut_0[77],ch_msg_fetchOut_0[76],ch_msg_fetchOut_0[75],ch_msg_fetchOut_0[74],ch_msg_fetchOut_0[73],ch_msg_fetchOut_0[72],ch_msg_fetchOut_0[71],ch_msg_fetchOut_0[70],ch_msg_fetchOut_0[69],ch_msg_fetchOut_0[68],ch_msg_fetchOut_0[67],ch_msg_fetchOut_0[66],ch_msg_fetchOut_0[65],ch_msg_fetchOut_0[64],ch_msg_fetchOut_0[63],ch_msg_fetchOut_0[62],ch_msg_fetchOut_0[61],ch_msg_fetchOut_0[60],ch_msg_fetchOut_0[59],ch_msg_fetchOut_0[58],ch_msg_fetchOut_0[57],ch_msg_fetchOut_0[56],ch_msg_fetchOut_0[55],ch_msg_fetchOut_0[54],ch_msg_fetchOut_0[53],ch_msg_fetchOut_0[52],ch_msg_fetchOut_0[51],ch_msg_fetchOut_0[50],ch_msg_fetchOut_0[49],ch_msg_fetchOut_0[48],ch_msg_fetchOut_0[47],ch_msg_fetchOut_0[46],ch_msg_fetchOut_0[45],ch_msg_fetchOut_0[44],ch_msg_fetchOut_0[43],ch_msg_fetchOut_0[42],ch_msg_fetchOut_0[41],ch_msg_fetchOut_0[40],ch_msg_fetchOut_0[39],ch_msg_fetchOut_0[38],ch_msg_fetchOut_0[37],ch_msg_fetchOut_0[36],ch_msg_fetchOut_0[35],ch_msg_fetchOut_0[34],ch_msg_fetchOut_0[33],ch_msg_fetchOut_0[32],ch_msg_fetchOut_0[31],ch_msg_fetchOut_0[30],ch_msg_fetchOut_0[29],ch_msg_fetchOut_0[28],ch_msg_fetchOut_0[27],ch_msg_fetchOut_0[26],ch_msg_fetchOut_0[25],ch_msg_fetchOut_0[24],ch_msg_fetchOut_0[23],ch_msg_fetchOut_0[22],ch_msg_fetchOut_0[21],ch_msg_fetchOut_0[20],ch_msg_fetchOut_0[19],ch_msg_fetchOut_0[18],ch_msg_fetchOut_0[17],ch_msg_fetchOut_0[16],ch_msg_fetchOut_0[15],ch_msg_fetchOut_0[14],ch_msg_fetchOut_0[13],ch_msg_fetchOut_0[12],ch_msg_fetchOut_0[11],ch_msg_fetchOut_0[10],ch_msg_fetchOut_0[9],ch_msg_fetchOut_0[8],ch_msg_fetchOut_0[7],ch_msg_fetchOut_0[6],ch_msg_fetchOut_0[5],ch_msg_fetchOut_0[4],ch_msg_fetchOut_0[3],ch_msg_fetchOut_0[2],ch_msg_fetchOut_0[1],ch_msg_fetchOut_0[0]};
	assign ch_to_bs [CH_DATA_WIDTH-1:0] = {ch_msg_fetchOut_2[84],ch_msg_fetchOut_2[83],ch_msg_fetchOut_2[82],ch_msg_fetchOut_2[81],ch_msg_fetchOut_2[80],ch_msg_fetchOut_2[79],ch_msg_fetchOut_2[78],ch_msg_fetchOut_2[77],ch_msg_fetchOut_2[76],ch_msg_fetchOut_2[75],ch_msg_fetchOut_2[74],ch_msg_fetchOut_2[73],ch_msg_fetchOut_2[72],ch_msg_fetchOut_2[71],ch_msg_fetchOut_2[70],ch_msg_fetchOut_2[69],ch_msg_fetchOut_2[68],ch_msg_fetchOut_2[67],ch_msg_fetchOut_2[66],ch_msg_fetchOut_2[65],ch_msg_fetchOut_2[64],ch_msg_fetchOut_2[63],ch_msg_fetchOut_2[62],ch_msg_fetchOut_2[61],ch_msg_fetchOut_2[60],ch_msg_fetchOut_2[59],ch_msg_fetchOut_2[58],ch_msg_fetchOut_2[57],ch_msg_fetchOut_2[56],ch_msg_fetchOut_2[55],ch_msg_fetchOut_2[54],ch_msg_fetchOut_2[53],ch_msg_fetchOut_2[52],ch_msg_fetchOut_2[51],ch_msg_fetchOut_2[50],ch_msg_fetchOut_2[49],ch_msg_fetchOut_2[48],ch_msg_fetchOut_2[47],ch_msg_fetchOut_2[46],ch_msg_fetchOut_2[45],ch_msg_fetchOut_2[44],ch_msg_fetchOut_2[43],ch_msg_fetchOut_2[42],ch_msg_fetchOut_2[41],ch_msg_fetchOut_2[40],ch_msg_fetchOut_2[39],ch_msg_fetchOut_2[38],ch_msg_fetchOut_2[37],ch_msg_fetchOut_2[36],ch_msg_fetchOut_2[35],ch_msg_fetchOut_2[34],ch_msg_fetchOut_2[33],ch_msg_fetchOut_2[32],ch_msg_fetchOut_2[31],ch_msg_fetchOut_2[30],ch_msg_fetchOut_2[29],ch_msg_fetchOut_2[28],ch_msg_fetchOut_2[27],ch_msg_fetchOut_2[26],ch_msg_fetchOut_2[25],ch_msg_fetchOut_2[24],ch_msg_fetchOut_2[23],ch_msg_fetchOut_2[22],ch_msg_fetchOut_2[21],ch_msg_fetchOut_2[20],ch_msg_fetchOut_2[19],ch_msg_fetchOut_2[18],ch_msg_fetchOut_2[17],ch_msg_fetchOut_2[16],ch_msg_fetchOut_2[15],ch_msg_fetchOut_2[14],ch_msg_fetchOut_2[13],ch_msg_fetchOut_2[12],ch_msg_fetchOut_2[11],ch_msg_fetchOut_2[10],ch_msg_fetchOut_2[9],ch_msg_fetchOut_2[8],ch_msg_fetchOut_2[7],ch_msg_fetchOut_2[6],ch_msg_fetchOut_2[5],ch_msg_fetchOut_2[4],ch_msg_fetchOut_2[3],ch_msg_fetchOut_2[2],ch_msg_fetchOut_2[1],ch_msg_fetchOut_2[0]};	
	/*--------------------------------------------------------------------------*/
	// Sign-Extension Control Signals for second segment of DNU IB-LUT read addresses
	// Source: sign extension output from last decomposition level of VNU IB-LUT
	// Destination: sign extension input of DNU IB-LUT
	dnu_signExtenIn_ram #(
		.ROW_CHUNK_NUM (ROW_CHUNK_NUM),
		.CHECK_PARALLELISM (CHECK_PARALLELISM),
		.DEPTH (ROW_CHUNK_NUM),
		.DATA_WIDTH (CHECK_PARALLELISM),
		.ADDR_WIDTH ($clog2(ROW_CHUNK_NUM))
	) dnu_signExtenIn_ram_u0 (
		.mem_to_dnuIn (dnu_signExten[CHECK_PARALLELISM-1:0]),
	
		.signExten_din (dnu_signExten_wire[CHECK_PARALLELISM-1:0]),
		.read_addr     (submatrix_signExten_ram_rd_addr[$clog2(ROW_CHUNK_NUM)-1:0]),
		.write_addr    (submatrix_signExten_ram_wr_addr[$clog2(ROW_CHUNK_NUM)-1:0]),
		.we (dnu_inRotate_wb),
	
		.read_clk  (read_clk),
		.write_clk (read_clk),
		.rstn (rstn)
	);
	/*--------------------------------------------------------------------------*/
	// Updating the Channel RAMs by either initally channel messages (from AWGNs) or circularly shifted channel messages
	assign submatrix_ch_ram_wr_addr = (ch_ram_init_we == 1'b1) ? submatrix_chInit_wr_addr :
									  (ch_ram_wb == 1'b1     ) ? submatrix_chLayer_wr_addr : 
																 CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.	
	/*--------------------------------------------------------------------------*/ 
	// Multiplexing the sources of Write-Data of Channel Buffer, as follows:
	// 		1) coded_block (from AWGN generator); 
	// 		2) vnu_msg_in (from output of message_pass.PA)
	/*--------------------------------------------------------------------------*/
	localparam 	CH_RAM_WR_UNIT = CHECK_PARALLELISM*ROW_CHUNK_NUM*QUAN_SIZE; // 85*4=340-bit
	always @(*) begin
		case (submatrix_ch_ram_wr_addr)
			0 : ch_msg_genIn <= coded_block[(0+1)*CH_DATA_WIDTH-1:0*CH_DATA_WIDTH];
			1 : ch_msg_genIn <= coded_block[(1+1)*CH_DATA_WIDTH-1:1*CH_DATA_WIDTH];
			2 : ch_msg_genIn <= coded_block[(2+1)*CH_DATA_WIDTH-1:2*CH_DATA_WIDTH];
			3 : ch_msg_genIn <= coded_block[(3+1)*CH_DATA_WIDTH-1:3*CH_DATA_WIDTH];
			4 : ch_msg_genIn <= coded_block[(4+1)*CH_DATA_WIDTH-1:4*CH_DATA_WIDTH];
			5 : ch_msg_genIn <= coded_block[(5+1)*CH_DATA_WIDTH-1:5*CH_DATA_WIDTH];
			6 : ch_msg_genIn <= coded_block[(6+1)*CH_DATA_WIDTH-1:6*CH_DATA_WIDTH];
			7 : ch_msg_genIn <= coded_block[(7+1)*CH_DATA_WIDTH-1:7*CH_DATA_WIDTH];
			8 : ch_msg_genIn <= coded_block[(8+1)*CH_DATA_WIDTH-1:8*CH_DATA_WIDTH];
			default : ch_msg_genIn <= coded_block[(0+1)*CH_DATA_WIDTH-1:0*CH_DATA_WIDTH];
		endcase
	end
	assign ch_ram_din[CH_DATA_WIDTH-1:0] = (ch_ram_init_we == 1'b1) ? ch_msg_genIn[CH_DATA_WIDTH-1:0] : pa_to_ch_ram[CH_DATA_WIDTH-1:0];															  
	/*--------------------------------------------------------------------------*/
	// Channel messages RAMs write-page addresses - For Initial Write Operation
	// To store the channed messages onto Channel Buffer at first layer of first iteration only
		initial submatrix_chInit_wr_addr <= 0;
		always @(posedge write_clk) begin
			if(rstn == 1'b0)
				submatrix_chInit_wr_addr <= 0;
			else if(iter_termination == 1'b1)
				submatrix_chInit_wr_addr <= 0;
			else if(ch_ram_init_we == 1'b1) begin
				// In the inital channel MSGs writing, execution is only done at the first layer of first iteration
				// Thus, only the first (z/Pc) pages across CH-RAMs are written, e,g., z(=765) / Pc(=85) = 9
				if(submatrix_chInit_wr_addr == ROW_CHUNK_NUM-1)
					submatrix_chInit_wr_addr <= CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
				else
					submatrix_chInit_wr_addr <= submatrix_chInit_wr_addr+1;
			end
			else
				submatrix_chInit_wr_addr <= submatrix_chInit_wr_addr;
		end
	/*--------------------------------------------------------------------------*/
	// Channel messages RAMs write-page addresses - For Layer Write Operation
	// To duplicate and shuffle their memory location for next layer; moreover, store their onto Channel Buffer of distince memory region from other layers
	// Such a Layer Write Operation is only taken place at first iteration.
		reg [ROW_CHUNK_NUM-1:0] ch_ramRD_row_chunk_cnt;
		reg [LAYER_NUM-1:0] chLayer_wr_layer_cnt; // to identify the currently target layer of which the channel messages is being written back onto CH-RAMs circularly.
		always @(posedge read_clk) begin 
			if(rstn == 1'b0) 
				chLayer_wr_layer_cnt <= 1;
			else if(ch_ram_wb == 1'b1 && ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1)
				chLayer_wr_layer_cnt[LAYER_NUM-1:0] <= {chLayer_wr_layer_cnt[LAYER_NUM-2:0], chLayer_wr_layer_cnt[LAYER_NUM-1]};
		end
		always @(posedge read_clk) begin
			if(rstn == 1'b0) ch_ramRD_row_chunk_cnt <= 1;
			else if(ch_ram_wb == 1'b1) ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-1:0] <= {ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-2:0], ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-1]};
			else ch_ramRD_row_chunk_cnt <= ch_ramRD_row_chunk_cnt;
		end
		initial submatrix_chLayer_wr_addr <= 0;
		always @(posedge read_clk) begin
			if(rstn == 1'b0) 
				submatrix_chLayer_wr_addr <= START_PAGE_1_0+CH_RAM_WB_ADDR_BASE_1_0;
			else if(ch_ram_wb == 1'b1) begin
				// page increment pattern within layer 0
				if(chLayer_wr_layer_cnt[0] == 1) begin
					if(ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
						submatrix_chLayer_wr_addr <= START_PAGE_1_1+CH_RAM_WB_ADDR_BASE_1_1; // to move on to beginning of layer 1
					else if(ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
							submatrix_chLayer_wr_addr <= CH_RAM_WB_ADDR_BASE_1_0; 
					else
						submatrix_chLayer_wr_addr <= submatrix_chLayer_wr_addr+1;
				end
				// page increment pattern within layer 1
				if(chLayer_wr_layer_cnt[1] == 1) begin
					if(ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
						submatrix_chLayer_wr_addr <= CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
					else if(ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
						submatrix_chLayer_wr_addr <= CH_RAM_WB_ADDR_BASE_1_1; 
					else
						submatrix_chLayer_wr_addr <= submatrix_chLayer_wr_addr+1;
				end
				// Since channel messages are constant over all iterations of one codeword decoding process, 
				// the channel messages are thereby not necessarily written back circularly at last layer.
				// Because of the fact that the channel messages for first layer had been written onto their memory region at initial state of codeword decoding process.
			end
		end
		/*--------------------------------------------------------------------------*/
		// Channel messages RAMs Fetching addresses
		always @(posedge read_clk) begin
			if(rstn == 1'b0)
				submatrix_ch_ram_rd_addr <= 0;
			else if(ch_ram_fetch == 1'b1) begin
				if(submatrix_ch_ram_rd_addr == CH_RAM_DEPTH-1)
					submatrix_ch_ram_rd_addr <= 0;
				else
					submatrix_ch_ram_rd_addr <= submatrix_ch_ram_rd_addr+1;
			end
			else
				submatrix_ch_ram_rd_addr <= submatrix_ch_ram_rd_addr;
		end
		/*--------------------------------------------------------------------------*/
		// V2C messages MEMs Fetching addresses
			always @(posedge read_clk) begin
				if(rstn == 1'b0)
					v2c_mem_page_rd_addr <= V2C_MEM_ADDR_BASE;
				else if(v2c_mem_fetch == 1'b1) begin
					if(v2c_mem_page_rd_addr == V2C_MEM_ADDR_BASE+ROW_CHUNK_NUM-1)
						v2c_mem_page_rd_addr <= V2C_MEM_ADDR_BASE;
					else
						v2c_mem_page_rd_addr <= v2c_mem_page_rd_addr+1;
				end
				else
					v2c_mem_page_rd_addr <= v2c_mem_page_rd_addr;
			end
		/*--------------------------------------------------------------------------*/
		// C2V messages MEMs Fetching addresses
			always @(posedge read_clk) begin
				if(rstn == 1'b0)
					c2v_mem_page_rd_addr <= C2V_MEM_ADDR_BASE;
				else if(c2v_mem_fetch == 1'b1) begin
					if(c2v_mem_page_rd_addr == C2V_MEM_ADDR_BASE+ROW_CHUNK_NUM-1)
						c2v_mem_page_rd_addr <= C2V_MEM_ADDR_BASE;
					else
						c2v_mem_page_rd_addr <= c2v_mem_page_rd_addr+1;
				end
				else
					c2v_mem_page_rd_addr <= c2v_mem_page_rd_addr;
			end
/*--------------------------------------------------------------------------*/
// Channel messages Circular Shift Factor
always @(posedge read_clk) begin
	if(rstn == 1'b0) begin
		ch_ramRD_shift_factor_cur_2 <= 0;//shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
		ch_ramRD_shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
		ch_ramRD_shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
	end
	else if(layer_finish == 1'b1) begin
		ch_ramRD_shift_factor_cur_2 <= ch_ramRD_shift_factor_cur_0;
		ch_ramRD_shift_factor_cur_1 <= ch_ramRD_shift_factor_cur_2; //ch_ramRD_shift_factor_cur_2[BITWIDTH_SHIFT_FACTOR-1:0];
		ch_ramRD_shift_factor_cur_0 <= ch_ramRD_shift_factor_cur_1[BITWIDTH_SHIFT_FACTOR-1:0];
	end
end
/*--------------------------------------------------------------------------*/
// DNU Sign-Input Control Circular Shift Factor
assign dnu_inRotate_shift_factor = shift_factor_1;
/*--------------------------------------------------------------------------*/
// DNU Sign-Extension RAMs write-page addresses 
reg [ROW_CHUNK_NUM-1:0] signExten_ramWR_row_chunk_cnt; initial signExten_ramWR_row_chunk_cnt <= 0;
always @(posedge read_clk) begin
	if(rstn == 1'b0) signExten_ramWR_row_chunk_cnt <= 1;
	else if(dnu_inRotate_wb == 1'b1) signExten_ramWR_row_chunk_cnt[ROW_CHUNK_NUM-1:0] <= {signExten_ramWR_row_chunk_cnt[ROW_CHUNK_NUM-2:0], signExten_ramWR_row_chunk_cnt[ROW_CHUNK_NUM-1]};
	else signExten_ramWR_row_chunk_cnt <= signExten_ramWR_row_chunk_cnt;
end
initial submatrix_signExten_ram_wr_addr <= 0;
always @(posedge read_clk) begin
	if(rstn == 1'b0) 
		submatrix_signExten_ram_wr_addr <= START_PAGE_1_1;
	else if(dnu_inRotate_wb == 1'b1) begin
		if(signExten_ramWR_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
			submatrix_signExten_ram_wr_addr <= START_PAGE_1_1;
		else if(signExten_ramWR_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
			submatrix_signExten_ram_wr_addr <= 0; 
		else
			submatrix_signExten_ram_wr_addr <= submatrix_signExten_ram_wr_addr+1;
	end
end
/*--------------------------------------------------------------------------*/
// DNU Sign-Extension RAMs Fetching addresses
always @(posedge read_clk) begin
	if(rstn == 1'b0)
		submatrix_signExten_ram_rd_addr <= 0;
	else if(dnu_signExten_ram_fetch == 1'b1) begin
		if(submatrix_signExten_ram_rd_addr == ROW_CHUNK_NUM-1)
			submatrix_signExten_ram_rd_addr <= 0;
		else
			submatrix_signExten_ram_rd_addr <= submatrix_signExten_ram_rd_addr+1;
	end
	else
		submatrix_signExten_ram_rd_addr <= submatrix_signExten_ram_rd_addr;
end
/*--------------------------------------------------------------------------*/
endmodule