`include "define.vh"

module entire_message_passing_wrapper #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,

	parameter VN_DEGREE = 3,   // degree of one variable node
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

	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in_sub0,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in_sub1,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in_sub2,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in_sub3,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in_sub4,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in_sub5,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in_sub6,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in_sub7,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in_sub8,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in_sub9,
	
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
	input wire ch_ram_fetch,
	input wire v2c_outRotate_reg_we,
	input wire dnu_inRotate_bs_en,
	input wire dnu_inRotate_pa_en,
	input wire dnu_inRotate_wb,
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
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,

	input wire read_clk,
	input wire write_clk,
	input wire ch_ram_rd_clk,
	input wire ch_ram_wr_clk,
	input wire rstn
);

/*-------------------------------------------------------------------------------------*/
// Message Passing Instantiation of Submatrix_0 consisting of BS, PA and MEM
	msg_pass_submatrix_0_unit #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.VN_DEGREE(VN_DEGREE),
			.RAM_DEPTH(RAM_DEPTH),
			.RAM_ADDR_BITWIDTH(RAM_ADDR_BITWIDTH),
			.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR),
			//.shift_factor_0(shift_factor_0),
			//.shift_factor_1(shift_factor_1),
			//.shift_factor_2(shift_factor_2),
			.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
			.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
			.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
			.C2V_MEM_ADDR_BASE(C2V_MEM_ADDR_BASE),
			.V2C_MEM_ADDR_BASE(V2C_MEM_ADDR_BASE),
			.V2C_DATA_WIDTH(V2C_DATA_WIDTH),
			.C2V_DATA_WIDTH(C2V_DATA_WIDTH),
			.DEPTH(DEPTH),
			.DATA_WIDTH(DATA_WIDTH),
			.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
			.ADDR_WIDTH(ADDR_WIDTH),
			.START_PAGE_1_0(START_PAGE_0_0),
			.START_PAGE_1_1(START_PAGE_0_1),
			.START_PAGE_1_2(START_PAGE_0_2)
		) inst_msg_pass_submatrix_0_unit (
			.mem_to_cnu         (mem_to_cnu_sub0),
			.mem_to_vnu         (mem_to_vnu_sub0),
			.c2v_bs_in          (c2v_bs_in_sub0 ),
			.v2c_bs_in          (v2c_bs_in_sub0 ),

			.dnu_inRotate_bit (dnu_inRotate_bit_sub0),
			.vnu_bs_bit0_src (vnu_bs_bit0_src[2]), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message; '2': rotate_en of last VNU decomposition level (for 2nd segment read_addr of upcoming DNU)

			.c2v_bs_en          (c2v_bs_en),
			.v2c_bs_en          (v2c_bs_en),
			.c2v_mem_we         (c2v_mem_we),
			.v2c_mem_we         (v2c_mem_we),
			.v2c_layer_cnt      (v2c_layer_cnt),
			.c2v_last_row_chunk (c2v_last_row_chunk),
			.v2c_last_row_chunk (v2c_last_row_chunk),
			.c2v_row_chunk_cnt  (c2v_row_chunk_cnt),
			.v2c_row_chunk_cnt  (v2c_row_chunk_cnt),
			.read_clk           (read_clk),
			.rstn               (rstn)
		);
/*-------------------------------------------------------------------------------------*/
// Message Passing Instantiation of Submatrix_1 consisting of BS, PA and MEM
	msg_pass_submatrix_1_unit #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.VN_DEGREE(VN_DEGREE),
			.RAM_DEPTH(RAM_DEPTH),
			.RAM_ADDR_BITWIDTH(RAM_ADDR_BITWIDTH),
			.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR),
			.shift_factor_0(CHECK_PARALLELISM-24),
			.shift_factor_1(CHECK_PARALLELISM-39),
			.shift_factor_2(CHECK_PARALLELISM-63),
			.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
			.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
			.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
			.C2V_MEM_ADDR_BASE(C2V_MEM_ADDR_BASE),
			.V2C_MEM_ADDR_BASE(V2C_MEM_ADDR_BASE),
			.V2C_DATA_WIDTH(V2C_DATA_WIDTH),
			.C2V_DATA_WIDTH(C2V_DATA_WIDTH),
			.DEPTH(DEPTH),
			.DATA_WIDTH(DATA_WIDTH),
			.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
			.ADDR_WIDTH(ADDR_WIDTH),
			.START_PAGE_1_0(START_PAGE_1_0),
			.START_PAGE_1_1(START_PAGE_1_1),
			.START_PAGE_1_2(START_PAGE_1_2)
		) inst_msg_pass_submatrix_1_unit (
			.mem_to_cnu         (mem_to_cnu_sub1),
			.mem_to_vnu         (mem_to_vnu_sub1),
			.c2v_bs_in          (c2v_bs_in_sub1 ),
			.v2c_bs_in          (v2c_bs_in_sub1 ),
			.ch_bs_in   		(ch_bs_in_sub1),

			.dnu_inRotate_bit (dnu_inRotate_bit_sub1),
			.vnu_bs_bit0_src (vnu_bs_bit0_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message; '2': rotate_en of last VNU decomposition level (for 2nd segment read_addr of upcoming DNU)

			.vnu_bs_src 		(vnu_bs_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message
			.c2v_bs_en          (c2v_bs_en),
			.v2c_bs_en          (v2c_bs_en),
			.c2v_mem_we         (c2v_mem_we),
			.v2c_mem_we         (v2c_mem_we),
			.v2c_layer_cnt      (v2c_layer_cnt),
			.c2v_last_row_chunk (c2v_last_row_chunk),
			.v2c_last_row_chunk (v2c_last_row_chunk),
			.c2v_row_chunk_cnt  (c2v_row_chunk_cnt),
			.v2c_row_chunk_cnt  (v2c_row_chunk_cnt),
			.read_clk           (read_clk),
			.rstn               (rstn)
		);
/*-------------------------------------------------------------------------------------*/
// Message Passing Instantiation of Submatrix_2 consisting of BS, PA and MEM
	msg_pass_submatrix_2_unit #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.VN_DEGREE(VN_DEGREE),
			.RAM_DEPTH(RAM_DEPTH),
			.RAM_ADDR_BITWIDTH(RAM_ADDR_BITWIDTH),
			.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR),
			.shift_factor_0(CHECK_PARALLELISM-9),
			.shift_factor_1(CHECK_PARALLELISM-21),
			.shift_factor_2(CHECK_PARALLELISM-30),
			.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
			.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
			.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
			.C2V_MEM_ADDR_BASE(C2V_MEM_ADDR_BASE),
			.V2C_MEM_ADDR_BASE(V2C_MEM_ADDR_BASE),
			.V2C_DATA_WIDTH(V2C_DATA_WIDTH),
			.C2V_DATA_WIDTH(C2V_DATA_WIDTH),
			.DEPTH(DEPTH),
			.DATA_WIDTH(DATA_WIDTH),
			.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
			.ADDR_WIDTH(ADDR_WIDTH),
			.START_PAGE_1_0(START_PAGE_2_0),
			.START_PAGE_1_1(START_PAGE_2_1),
			.START_PAGE_1_2(START_PAGE_2_2)
		) inst_msg_pass_submatrix_2_unit (
			.mem_to_cnu         (mem_to_cnu_sub2),
			.mem_to_vnu         (mem_to_vnu_sub2),
			.c2v_bs_in          (c2v_bs_in_sub2 ),
			.v2c_bs_in          (v2c_bs_in_sub2 ),
			.ch_bs_in   		(ch_bs_in_sub2),

			.dnu_inRotate_bit (dnu_inRotate_bit_sub2),
			.vnu_bs_bit0_src (vnu_bs_bit0_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message; '2': rotate_en of last VNU decomposition level (for 2nd segment read_addr of upcoming DNU)

			.vnu_bs_src 		(vnu_bs_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message
			.c2v_bs_en          (c2v_bs_en),
			.v2c_bs_en          (v2c_bs_en),
			.c2v_mem_we         (c2v_mem_we),
			.v2c_mem_we         (v2c_mem_we),
			.v2c_layer_cnt      (v2c_layer_cnt),
			.c2v_last_row_chunk (c2v_last_row_chunk),
			.v2c_last_row_chunk (v2c_last_row_chunk),
			.c2v_row_chunk_cnt  (c2v_row_chunk_cnt),
			.v2c_row_chunk_cnt  (v2c_row_chunk_cnt),
			.read_clk           (read_clk),
			.rstn               (rstn)
		);
/*-------------------------------------------------------------------------------------*/
// Message Passing Instantiation of Submatrix_3 consisting of BS, PA and MEM
	msg_pass_submatrix_3_unit #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.VN_DEGREE(VN_DEGREE),
			.RAM_DEPTH(RAM_DEPTH),
			.RAM_ADDR_BITWIDTH(RAM_ADDR_BITWIDTH),
			.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR),
			.shift_factor_0(CHECK_PARALLELISM-38),
			.shift_factor_1(CHECK_PARALLELISM-28),
			.shift_factor_2(CHECK_PARALLELISM-66),
			.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
			.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
			.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
			.C2V_MEM_ADDR_BASE(C2V_MEM_ADDR_BASE),
			.V2C_MEM_ADDR_BASE(V2C_MEM_ADDR_BASE),
			.V2C_DATA_WIDTH(V2C_DATA_WIDTH),
			.C2V_DATA_WIDTH(C2V_DATA_WIDTH),
			.DEPTH(DEPTH),
			.DATA_WIDTH(DATA_WIDTH),
			.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
			.ADDR_WIDTH(ADDR_WIDTH),
			.START_PAGE_1_0(START_PAGE_3_0),
			.START_PAGE_1_1(START_PAGE_3_1),
			.START_PAGE_1_2(START_PAGE_3_2)
		) inst_msg_pass_submatrix_3_unit (
			.mem_to_cnu         (mem_to_cnu_sub3),
			.mem_to_vnu         (mem_to_vnu_sub3),
			.c2v_bs_in          (c2v_bs_in_sub3 ),
			.v2c_bs_in          (v2c_bs_in_sub3 ),
			.ch_bs_in   		(ch_bs_in_sub3),

			.dnu_inRotate_bit (dnu_inRotate_bit_sub3),
			.vnu_bs_bit0_src (vnu_bs_bit0_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message; '2': rotate_en of last VNU decomposition level (for 2nd segment read_addr of upcoming DNU)

			.vnu_bs_src 		(vnu_bs_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message
			.c2v_bs_en          (c2v_bs_en),
			.v2c_bs_en          (v2c_bs_en),
			.c2v_mem_we         (c2v_mem_we),
			.v2c_mem_we         (v2c_mem_we),
			.v2c_layer_cnt      (v2c_layer_cnt),
			.c2v_last_row_chunk (c2v_last_row_chunk),
			.v2c_last_row_chunk (v2c_last_row_chunk),
			.c2v_row_chunk_cnt  (c2v_row_chunk_cnt),
			.v2c_row_chunk_cnt  (v2c_row_chunk_cnt),
			.read_clk           (read_clk),
			.rstn               (rstn)
		);
/*-------------------------------------------------------------------------------------*/
// Message Passing Instantiation of Submatrix_4 consisting of BS, PA and MEM
	msg_pass_submatrix_4_unit #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.VN_DEGREE(VN_DEGREE),
			.RAM_DEPTH(RAM_DEPTH),
			.RAM_ADDR_BITWIDTH(RAM_ADDR_BITWIDTH),
			.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR),
			.shift_factor_0(CHECK_PARALLELISM-71),
			.shift_factor_1(CHECK_PARALLELISM-63),
			.shift_factor_2(CHECK_PARALLELISM-8 ),
			.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
			.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
			.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
			.C2V_MEM_ADDR_BASE(C2V_MEM_ADDR_BASE),
			.V2C_MEM_ADDR_BASE(V2C_MEM_ADDR_BASE),
			.V2C_DATA_WIDTH(V2C_DATA_WIDTH),
			.C2V_DATA_WIDTH(C2V_DATA_WIDTH),
			.DEPTH(DEPTH),
			.DATA_WIDTH(DATA_WIDTH),
			.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
			.ADDR_WIDTH(ADDR_WIDTH),
			.START_PAGE_1_0(START_PAGE_4_0),
			.START_PAGE_1_1(START_PAGE_4_1),
			.START_PAGE_1_2(START_PAGE_4_2)
		) inst_msg_pass_submatrix_4_unit (
			.mem_to_cnu         (mem_to_cnu_sub4),
			.mem_to_vnu         (mem_to_vnu_sub4),
			.c2v_bs_in          (c2v_bs_in_sub4 ),
			.v2c_bs_in          (v2c_bs_in_sub4 ),
			.ch_bs_in   		(ch_bs_in_sub4),

			.dnu_inRotate_bit (dnu_inRotate_bit_sub4),
			.vnu_bs_bit0_src (vnu_bs_bit0_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message; '2': rotate_en of last VNU decomposition level (for 2nd segment read_addr of upcoming DNU)

			.vnu_bs_src 		(vnu_bs_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message
			.c2v_bs_en          (c2v_bs_en),
			.v2c_bs_en          (v2c_bs_en),
			.c2v_mem_we         (c2v_mem_we),
			.v2c_mem_we         (v2c_mem_we),
			.v2c_layer_cnt      (v2c_layer_cnt),
			.c2v_last_row_chunk (c2v_last_row_chunk),
			.v2c_last_row_chunk (v2c_last_row_chunk),
			.c2v_row_chunk_cnt  (c2v_row_chunk_cnt),
			.v2c_row_chunk_cnt  (v2c_row_chunk_cnt),
			.read_clk           (read_clk),
			.rstn               (rstn)
		);
/*-------------------------------------------------------------------------------------*/
// Message Passing Instantiation of Submatrix_5 consisting of BS, PA and MEM
	msg_pass_submatrix_5_unit #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.VN_DEGREE(VN_DEGREE),
			.RAM_DEPTH(RAM_DEPTH),
			.RAM_ADDR_BITWIDTH(RAM_ADDR_BITWIDTH),
			.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR),
			.shift_factor_0(CHECK_PARALLELISM-22),
			.shift_factor_1(CHECK_PARALLELISM-2 ),
			.shift_factor_2(CHECK_PARALLELISM-20),
			.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
			.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
			.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
			.C2V_MEM_ADDR_BASE(C2V_MEM_ADDR_BASE),
			.V2C_MEM_ADDR_BASE(V2C_MEM_ADDR_BASE),
			.V2C_DATA_WIDTH(V2C_DATA_WIDTH),
			.C2V_DATA_WIDTH(C2V_DATA_WIDTH),
			.DEPTH(DEPTH),
			.DATA_WIDTH(DATA_WIDTH),
			.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
			.ADDR_WIDTH(ADDR_WIDTH),
			.START_PAGE_1_0(START_PAGE_5_0),
			.START_PAGE_1_1(START_PAGE_5_1),
			.START_PAGE_1_2(START_PAGE_5_2)
		) inst_msg_pass_submatrix_5_unit (
			.mem_to_cnu         (mem_to_cnu_sub5),
			.mem_to_vnu         (mem_to_vnu_sub5),
			.c2v_bs_in          (c2v_bs_in_sub5 ),
			.v2c_bs_in          (v2c_bs_in_sub5 ),
			.ch_bs_in   		(ch_bs_in_sub5),

			.dnu_inRotate_bit (dnu_inRotate_bit_sub5),
			.vnu_bs_bit0_src (vnu_bs_bit0_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message; '2': rotate_en of last VNU decomposition level (for 2nd segment read_addr of upcoming DNU)

			.vnu_bs_src 		(vnu_bs_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message
			.c2v_bs_en          (c2v_bs_en),
			.v2c_bs_en          (v2c_bs_en),
			.c2v_mem_we         (c2v_mem_we),
			.v2c_mem_we         (v2c_mem_we),
			.v2c_layer_cnt      (v2c_layer_cnt),
			.c2v_last_row_chunk (c2v_last_row_chunk),
			.v2c_last_row_chunk (v2c_last_row_chunk),
			.c2v_row_chunk_cnt  (c2v_row_chunk_cnt),
			.v2c_row_chunk_cnt  (v2c_row_chunk_cnt),
			.read_clk           (read_clk),
			.rstn               (rstn)
		);
/*-------------------------------------------------------------------------------------*/
// Message Passing Instantiation of Submatrix_6 consisting of BS, PA and MEM
	msg_pass_submatrix_6_unit #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.VN_DEGREE(VN_DEGREE),
			.RAM_DEPTH(RAM_DEPTH),
			.RAM_ADDR_BITWIDTH(RAM_ADDR_BITWIDTH),
			.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR),
			.shift_factor_0(CHECK_PARALLELISM-39),
			.shift_factor_1(CHECK_PARALLELISM-8 ),
			.shift_factor_2(CHECK_PARALLELISM-47),
			.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
			.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
			.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
			.C2V_MEM_ADDR_BASE(C2V_MEM_ADDR_BASE),
			.V2C_MEM_ADDR_BASE(V2C_MEM_ADDR_BASE),
			.V2C_DATA_WIDTH(V2C_DATA_WIDTH),
			.C2V_DATA_WIDTH(C2V_DATA_WIDTH),
			.DEPTH(DEPTH),
			.DATA_WIDTH(DATA_WIDTH),
			.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
			.ADDR_WIDTH(ADDR_WIDTH),
			.START_PAGE_1_0(START_PAGE_6_0),
			.START_PAGE_1_1(START_PAGE_6_1),
			.START_PAGE_1_2(START_PAGE_6_2)
		) inst_msg_pass_submatrix_6_unit (
			.mem_to_cnu         (mem_to_cnu_sub6),
			.mem_to_vnu         (mem_to_vnu_sub6),
			.c2v_bs_in          (c2v_bs_in_sub6 ),
			.v2c_bs_in          (v2c_bs_in_sub6 ),
			.ch_bs_in   		(ch_bs_in_sub6),

			.dnu_inRotate_bit (dnu_inRotate_bit_sub6),
			.vnu_bs_bit0_src (vnu_bs_bit0_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message; '2': rotate_en of last VNU decomposition level (for 2nd segment read_addr of upcoming DNU)

			.vnu_bs_src 		(vnu_bs_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message
			.c2v_bs_en          (c2v_bs_en),
			.v2c_bs_en          (v2c_bs_en),
			.c2v_mem_we         (c2v_mem_we),
			.v2c_mem_we         (v2c_mem_we),
			.v2c_layer_cnt      (v2c_layer_cnt),
			.c2v_last_row_chunk (c2v_last_row_chunk),
			.v2c_last_row_chunk (v2c_last_row_chunk),
			.c2v_row_chunk_cnt  (c2v_row_chunk_cnt),
			.v2c_row_chunk_cnt  (v2c_row_chunk_cnt),
			.read_clk           (read_clk),
			.rstn               (rstn)
		);
/*-------------------------------------------------------------------------------------*/
// Message Passing Instantiation of Submatrix_7 consisting of BS, PA and MEM
	msg_pass_submatrix_7_unit #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.VN_DEGREE(VN_DEGREE),
			.RAM_DEPTH(RAM_DEPTH),
			.RAM_ADDR_BITWIDTH(RAM_ADDR_BITWIDTH),
			.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR),
			.shift_factor_0(CHECK_PARALLELISM-20),
			.shift_factor_1(CHECK_PARALLELISM-25),
			.shift_factor_2(CHECK_PARALLELISM-45),
			.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
			.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
			.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
			.C2V_MEM_ADDR_BASE(C2V_MEM_ADDR_BASE),
			.V2C_MEM_ADDR_BASE(V2C_MEM_ADDR_BASE),
			.V2C_DATA_WIDTH(V2C_DATA_WIDTH),
			.C2V_DATA_WIDTH(C2V_DATA_WIDTH),
			.DEPTH(DEPTH),
			.DATA_WIDTH(DATA_WIDTH),
			.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
			.ADDR_WIDTH(ADDR_WIDTH),
			.START_PAGE_1_0(START_PAGE_7_0),
			.START_PAGE_1_1(START_PAGE_7_1),
			.START_PAGE_1_2(START_PAGE_7_2)
		) inst_msg_pass_submatrix_7_unit (
			.mem_to_cnu         (mem_to_cnu_sub7),
			.mem_to_vnu         (mem_to_vnu_sub7),
			.c2v_bs_in          (c2v_bs_in_sub7 ),
			.v2c_bs_in          (v2c_bs_in_sub7 ),
			.ch_bs_in   		(ch_bs_in_sub7),

			.dnu_inRotate_bit (dnu_inRotate_bit_sub7),
			.vnu_bs_bit0_src (vnu_bs_bit0_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message; '2': rotate_en of last VNU decomposition level (for 2nd segment read_addr of upcoming DNU)

			.vnu_bs_src 		(vnu_bs_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message
			.c2v_bs_en          (c2v_bs_en),
			.v2c_bs_en          (v2c_bs_en),
			.c2v_mem_we         (c2v_mem_we),
			.v2c_mem_we         (v2c_mem_we),
			.v2c_layer_cnt      (v2c_layer_cnt),
			.c2v_last_row_chunk (c2v_last_row_chunk),
			.v2c_last_row_chunk (v2c_last_row_chunk),
			.c2v_row_chunk_cnt  (c2v_row_chunk_cnt),
			.v2c_row_chunk_cnt  (v2c_row_chunk_cnt),
			.read_clk           (read_clk),
			.rstn               (rstn)
		);
/*-------------------------------------------------------------------------------------*/
// Message Passing Instantiation of Submatrix_8 consisting of BS, PA and MEM
	msg_pass_submatrix_8_unit #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.VN_DEGREE(VN_DEGREE),
			.RAM_DEPTH(RAM_DEPTH),
			.RAM_ADDR_BITWIDTH(RAM_ADDR_BITWIDTH),
			.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR),
			.shift_factor_0(CHECK_PARALLELISM-51),
			.shift_factor_1(CHECK_PARALLELISM-28),
			.shift_factor_2(CHECK_PARALLELISM-79),
			.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
			.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
			.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
			.C2V_MEM_ADDR_BASE(C2V_MEM_ADDR_BASE),
			.V2C_MEM_ADDR_BASE(V2C_MEM_ADDR_BASE),
			.V2C_DATA_WIDTH(V2C_DATA_WIDTH),
			.C2V_DATA_WIDTH(C2V_DATA_WIDTH),
			.DEPTH(DEPTH),
			.DATA_WIDTH(DATA_WIDTH),
			.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
			.ADDR_WIDTH(ADDR_WIDTH),
			.START_PAGE_1_0(START_PAGE_8_0),
			.START_PAGE_1_1(START_PAGE_8_1),
			.START_PAGE_1_2(START_PAGE_8_2)
		) inst_msg_pass_submatrix_8_unit (
			.mem_to_cnu         (mem_to_cnu_sub8),
			.mem_to_vnu         (mem_to_vnu_sub8),
			.c2v_bs_in          (c2v_bs_in_sub8 ),
			.v2c_bs_in          (v2c_bs_in_sub8 ),
			.ch_bs_in   		(ch_bs_in_sub8),

			.dnu_inRotate_bit (dnu_inRotate_bit_sub8),
			.vnu_bs_bit0_src (vnu_bs_bit0_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message; '2': rotate_en of last VNU decomposition level (for 2nd segment read_addr of upcoming DNU)

			.vnu_bs_src 		(vnu_bs_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message
			.c2v_bs_en          (c2v_bs_en),
			.v2c_bs_en          (v2c_bs_en),
			.c2v_mem_we         (c2v_mem_we),
			.v2c_mem_we         (v2c_mem_we),
			.v2c_layer_cnt      (v2c_layer_cnt),
			.c2v_last_row_chunk (c2v_last_row_chunk),
			.v2c_last_row_chunk (v2c_last_row_chunk),
			.c2v_row_chunk_cnt  (c2v_row_chunk_cnt),
			.v2c_row_chunk_cnt  (v2c_row_chunk_cnt),
			.read_clk           (read_clk),
			.rstn               (rstn)
		);
/*-------------------------------------------------------------------------------------*/
// Message Passing Instantiation of Submatrix_9 consisting of BS, PA and MEM
	msg_pass_submatrix_9_unit #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.VN_DEGREE(VN_DEGREE),
			.RAM_DEPTH(RAM_DEPTH),
			.RAM_ADDR_BITWIDTH(RAM_ADDR_BITWIDTH),
			.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR),
			.shift_factor_0(CHECK_PARALLELISM-50),
			.shift_factor_1(CHECK_PARALLELISM-20),
			.shift_factor_2(CHECK_PARALLELISM-70),
			.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
			.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
			.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
			.C2V_MEM_ADDR_BASE(C2V_MEM_ADDR_BASE),
			.V2C_MEM_ADDR_BASE(V2C_MEM_ADDR_BASE),
			.V2C_DATA_WIDTH(V2C_DATA_WIDTH),
			.C2V_DATA_WIDTH(C2V_DATA_WIDTH),
			.DEPTH(DEPTH),
			.DATA_WIDTH(DATA_WIDTH),
			.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
			.ADDR_WIDTH(ADDR_WIDTH),
			.START_PAGE_1_0(START_PAGE_9_0),
			.START_PAGE_1_1(START_PAGE_9_1),
			.START_PAGE_1_2(START_PAGE_9_2)
		) inst_msg_pass_submatrix_9_unit (
			.mem_to_cnu         (mem_to_cnu_sub9),
			.mem_to_vnu         (mem_to_vnu_sub9),
			.c2v_bs_in          (c2v_bs_in_sub9 ),
			.v2c_bs_in          (v2c_bs_in_sub9 ),
			.ch_bs_in   		(ch_bs_in_sub9),

			.dnu_inRotate_bit (dnu_inRotate_bit_sub9),
			.vnu_bs_bit0_src (vnu_bs_bit0_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message; '2': rotate_en of last VNU decomposition level (for 2nd segment read_addr of upcoming DNU)

			.vnu_bs_src 		(vnu_bs_src), // selection of v2c_bs input source, i.e., '0': v2c; '1': channel message
			.c2v_bs_en          (c2v_bs_en),
			.v2c_bs_en          (v2c_bs_en),
			.c2v_mem_we         (c2v_mem_we),
			.v2c_mem_we         (v2c_mem_we),
			.v2c_layer_cnt      (v2c_layer_cnt),
			.c2v_last_row_chunk (c2v_last_row_chunk),
			.v2c_last_row_chunk (v2c_last_row_chunk),
			.c2v_row_chunk_cnt  (c2v_row_chunk_cnt),
			.v2c_row_chunk_cnt  (v2c_row_chunk_cnt),
			.read_clk           (read_clk),
			.rstn               (rstn)
		);
endmodule

module msg_pass_submatrix_0_unit #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,
	parameter VN_DEGREE = 3,   // degree of one variable node
/*-------------------------------------------------------------------------------------*/
	// Parameters related to BS, PA and MEM
	parameter RAM_DEPTH = 1024,
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH),
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1),
`ifdef SCHED_4_6
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,
	parameter C2V_MEM_ADDR_BASE = 0,
	parameter V2C_MEM_ADDR_BASE = ROW_CHUNK_NUM,
	parameter V2C_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter C2V_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH),
	parameter BS_PIPELINE_LEVEL = 2,
`endif
	parameter START_PAGE_1_0 = 2, // starting page address of layer 0 of submatrix_1
	parameter START_PAGE_1_1 = 8, // starting page address of layer 1 of submatrix_1
	parameter START_PAGE_1_2 = 1  // starting page address of layer 2 of submatrix_1
) (
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu,

	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit,

	// control signals
	input wire c2v_bs_en,
	input wire v2c_bs_en,
	input wire ch_bs_en,
	/*------------------------------*/
	// Control signals associative with message passing of channel buffer and DNU.SignExtension
	input wire ch_ram_init_we,
	input wire ch_ram_fetch,
	input wire v2c_outRotate_reg_we,
	input wire dnu_inRotate_bs_en,
	input wire dnu_inRotate_pa_en,
	input wire dnu_inRotate_wb,
	/*------------------------------*/
	// 1) to indicate the current status of message passing of VNUs, in order to synchronise the C2V MEM's read/write address
	// 2) to indicate the current status of message passing of CNUs, in order to synchronise the V2C MEM's read/write address
	input wire c2v_mem_fetch, 
	input wire v2c_mem_fetch, 
	/*------------------------------*/
	input wire c2v_mem_we,
	input wire v2c_mem_we,
	input wire [LAYER_NUM-1:0] v2c_layer_cnt, // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,
	input wire vnu_bs_bit0_src, // selection of v2c_bs input source, i.e., '0': v2c; '1': rotate_en of last VNU decomposition level (for 2nd segment read_addr of upcoming DNU)


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
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_2;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_2;
wire [6:0]  cnu_left_sel;
wire [6:0]  cnu_right_sel;
wire [83:0] cnu_merge_sel;
wire [6:0]  vnu_left_sel;
wire [6:0]  vnu_right_sel;
wire [83:0] vnu_merge_sel;
wire [CHECK_PARALLELISM-1:0] cnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] vnu_bs_in_bit [0:QUAN_SIZE-1];
genvar bit_index;
generate
	for(bit_index=0;bit_index<QUAN_SIZE;bit_index=bit_index+1) begin : extrinsic_msg_bs_in_inst
		assign cnu_bs_in_bit[bit_index] = {c2v_bs_in[QUAN_SIZE*84+bit_index],c2v_bs_in[QUAN_SIZE*83+bit_index],c2v_bs_in[QUAN_SIZE*82+bit_index],c2v_bs_in[QUAN_SIZE*81+bit_index],c2v_bs_in[QUAN_SIZE*80+bit_index],c2v_bs_in[QUAN_SIZE*79+bit_index],c2v_bs_in[QUAN_SIZE*78+bit_index],c2v_bs_in[QUAN_SIZE*77+bit_index],c2v_bs_in[QUAN_SIZE*76+bit_index],c2v_bs_in[QUAN_SIZE*75+bit_index],c2v_bs_in[QUAN_SIZE*74+bit_index],c2v_bs_in[QUAN_SIZE*73+bit_index],c2v_bs_in[QUAN_SIZE*72+bit_index],c2v_bs_in[QUAN_SIZE*71+bit_index],c2v_bs_in[QUAN_SIZE*70+bit_index],c2v_bs_in[QUAN_SIZE*69+bit_index],c2v_bs_in[QUAN_SIZE*68+bit_index],c2v_bs_in[QUAN_SIZE*67+bit_index],c2v_bs_in[QUAN_SIZE*66+bit_index],c2v_bs_in[QUAN_SIZE*65+bit_index],c2v_bs_in[QUAN_SIZE*64+bit_index],c2v_bs_in[QUAN_SIZE*63+bit_index],c2v_bs_in[QUAN_SIZE*62+bit_index],c2v_bs_in[QUAN_SIZE*61+bit_index],c2v_bs_in[QUAN_SIZE*60+bit_index],c2v_bs_in[QUAN_SIZE*59+bit_index],c2v_bs_in[QUAN_SIZE*58+bit_index],c2v_bs_in[QUAN_SIZE*57+bit_index],c2v_bs_in[QUAN_SIZE*56+bit_index],c2v_bs_in[QUAN_SIZE*55+bit_index],c2v_bs_in[QUAN_SIZE*54+bit_index],c2v_bs_in[QUAN_SIZE*53+bit_index],c2v_bs_in[QUAN_SIZE*52+bit_index],c2v_bs_in[QUAN_SIZE*51+bit_index],c2v_bs_in[QUAN_SIZE*50+bit_index],c2v_bs_in[QUAN_SIZE*49+bit_index],c2v_bs_in[QUAN_SIZE*48+bit_index],c2v_bs_in[QUAN_SIZE*47+bit_index],c2v_bs_in[QUAN_SIZE*46+bit_index],c2v_bs_in[QUAN_SIZE*45+bit_index],c2v_bs_in[QUAN_SIZE*44+bit_index],c2v_bs_in[QUAN_SIZE*43+bit_index],c2v_bs_in[QUAN_SIZE*42+bit_index],c2v_bs_in[QUAN_SIZE*41+bit_index],c2v_bs_in[QUAN_SIZE*40+bit_index],c2v_bs_in[QUAN_SIZE*39+bit_index],c2v_bs_in[QUAN_SIZE*38+bit_index],c2v_bs_in[QUAN_SIZE*37+bit_index],c2v_bs_in[QUAN_SIZE*36+bit_index],c2v_bs_in[QUAN_SIZE*35+bit_index],c2v_bs_in[QUAN_SIZE*34+bit_index],c2v_bs_in[QUAN_SIZE*33+bit_index],c2v_bs_in[QUAN_SIZE*32+bit_index],c2v_bs_in[QUAN_SIZE*31+bit_index],c2v_bs_in[QUAN_SIZE*30+bit_index],c2v_bs_in[QUAN_SIZE*29+bit_index],c2v_bs_in[QUAN_SIZE*28+bit_index],c2v_bs_in[QUAN_SIZE*27+bit_index],c2v_bs_in[QUAN_SIZE*26+bit_index],c2v_bs_in[QUAN_SIZE*25+bit_index],c2v_bs_in[QUAN_SIZE*24+bit_index],c2v_bs_in[QUAN_SIZE*23+bit_index],c2v_bs_in[QUAN_SIZE*22+bit_index],c2v_bs_in[QUAN_SIZE*21+bit_index],c2v_bs_in[QUAN_SIZE*20+bit_index],c2v_bs_in[QUAN_SIZE*19+bit_index],c2v_bs_in[QUAN_SIZE*18+bit_index],c2v_bs_in[QUAN_SIZE*17+bit_index],c2v_bs_in[QUAN_SIZE*16+bit_index],c2v_bs_in[QUAN_SIZE*15+bit_index],c2v_bs_in[QUAN_SIZE*14+bit_index],c2v_bs_in[QUAN_SIZE*13+bit_index],c2v_bs_in[QUAN_SIZE*12+bit_index],c2v_bs_in[QUAN_SIZE*11+bit_index],c2v_bs_in[QUAN_SIZE*10+bit_index],c2v_bs_in[QUAN_SIZE*9+bit_index],c2v_bs_in[QUAN_SIZE*8+bit_index],c2v_bs_in[QUAN_SIZE*7+bit_index],c2v_bs_in[QUAN_SIZE*6+bit_index],c2v_bs_in[QUAN_SIZE*5+bit_index],c2v_bs_in[QUAN_SIZE*4+bit_index],c2v_bs_in[QUAN_SIZE*3+bit_index],c2v_bs_in[QUAN_SIZE*2+bit_index],c2v_bs_in[QUAN_SIZE*1+bit_index],c2v_bs_in[QUAN_SIZE*0+bit_index]};
		assign vnu_bs_in_bit[bit_index] = {v2c_bs_in[QUAN_SIZE*84+bit_index],v2c_bs_in[QUAN_SIZE*83+bit_index],v2c_bs_in[QUAN_SIZE*82+bit_index],v2c_bs_in[QUAN_SIZE*81+bit_index],v2c_bs_in[QUAN_SIZE*80+bit_index],v2c_bs_in[QUAN_SIZE*79+bit_index],v2c_bs_in[QUAN_SIZE*78+bit_index],v2c_bs_in[QUAN_SIZE*77+bit_index],v2c_bs_in[QUAN_SIZE*76+bit_index],v2c_bs_in[QUAN_SIZE*75+bit_index],v2c_bs_in[QUAN_SIZE*74+bit_index],v2c_bs_in[QUAN_SIZE*73+bit_index],v2c_bs_in[QUAN_SIZE*72+bit_index],v2c_bs_in[QUAN_SIZE*71+bit_index],v2c_bs_in[QUAN_SIZE*70+bit_index],v2c_bs_in[QUAN_SIZE*69+bit_index],v2c_bs_in[QUAN_SIZE*68+bit_index],v2c_bs_in[QUAN_SIZE*67+bit_index],v2c_bs_in[QUAN_SIZE*66+bit_index],v2c_bs_in[QUAN_SIZE*65+bit_index],v2c_bs_in[QUAN_SIZE*64+bit_index],v2c_bs_in[QUAN_SIZE*63+bit_index],v2c_bs_in[QUAN_SIZE*62+bit_index],v2c_bs_in[QUAN_SIZE*61+bit_index],v2c_bs_in[QUAN_SIZE*60+bit_index],v2c_bs_in[QUAN_SIZE*59+bit_index],v2c_bs_in[QUAN_SIZE*58+bit_index],v2c_bs_in[QUAN_SIZE*57+bit_index],v2c_bs_in[QUAN_SIZE*56+bit_index],v2c_bs_in[QUAN_SIZE*55+bit_index],v2c_bs_in[QUAN_SIZE*54+bit_index],v2c_bs_in[QUAN_SIZE*53+bit_index],v2c_bs_in[QUAN_SIZE*52+bit_index],v2c_bs_in[QUAN_SIZE*51+bit_index],v2c_bs_in[QUAN_SIZE*50+bit_index],v2c_bs_in[QUAN_SIZE*49+bit_index],v2c_bs_in[QUAN_SIZE*48+bit_index],v2c_bs_in[QUAN_SIZE*47+bit_index],v2c_bs_in[QUAN_SIZE*46+bit_index],v2c_bs_in[QUAN_SIZE*45+bit_index],v2c_bs_in[QUAN_SIZE*44+bit_index],v2c_bs_in[QUAN_SIZE*43+bit_index],v2c_bs_in[QUAN_SIZE*42+bit_index],v2c_bs_in[QUAN_SIZE*41+bit_index],v2c_bs_in[QUAN_SIZE*40+bit_index],v2c_bs_in[QUAN_SIZE*39+bit_index],v2c_bs_in[QUAN_SIZE*38+bit_index],v2c_bs_in[QUAN_SIZE*37+bit_index],v2c_bs_in[QUAN_SIZE*36+bit_index],v2c_bs_in[QUAN_SIZE*35+bit_index],v2c_bs_in[QUAN_SIZE*34+bit_index],v2c_bs_in[QUAN_SIZE*33+bit_index],v2c_bs_in[QUAN_SIZE*32+bit_index],v2c_bs_in[QUAN_SIZE*31+bit_index],v2c_bs_in[QUAN_SIZE*30+bit_index],v2c_bs_in[QUAN_SIZE*29+bit_index],v2c_bs_in[QUAN_SIZE*28+bit_index],v2c_bs_in[QUAN_SIZE*27+bit_index],v2c_bs_in[QUAN_SIZE*26+bit_index],v2c_bs_in[QUAN_SIZE*25+bit_index],v2c_bs_in[QUAN_SIZE*24+bit_index],v2c_bs_in[QUAN_SIZE*23+bit_index],v2c_bs_in[QUAN_SIZE*22+bit_index],v2c_bs_in[QUAN_SIZE*21+bit_index],v2c_bs_in[QUAN_SIZE*20+bit_index],v2c_bs_in[QUAN_SIZE*19+bit_index],v2c_bs_in[QUAN_SIZE*18+bit_index],v2c_bs_in[QUAN_SIZE*17+bit_index],v2c_bs_in[QUAN_SIZE*16+bit_index],v2c_bs_in[QUAN_SIZE*15+bit_index],v2c_bs_in[QUAN_SIZE*14+bit_index],v2c_bs_in[QUAN_SIZE*13+bit_index],v2c_bs_in[QUAN_SIZE*12+bit_index],v2c_bs_in[QUAN_SIZE*11+bit_index],v2c_bs_in[QUAN_SIZE*10+bit_index],v2c_bs_in[QUAN_SIZE*9+bit_index],v2c_bs_in[QUAN_SIZE*8+bit_index],v2c_bs_in[QUAN_SIZE*7+bit_index],v2c_bs_in[QUAN_SIZE*6+bit_index],v2c_bs_in[QUAN_SIZE*5+bit_index],v2c_bs_in[QUAN_SIZE*4+bit_index],v2c_bs_in[QUAN_SIZE*3+bit_index],v2c_bs_in[QUAN_SIZE*2+bit_index],v2c_bs_in[QUAN_SIZE*1+bit_index],v2c_bs_in[QUAN_SIZE*0+bit_index]};
	end
endgenerate
/*----------------------------------------------*/	
// Circular shifter of check nodes 
zero_shuffle_top_85b #(
	.CHECK_PARALLELISM(CHECK_PARALLELISM),
	.BS_PIPELINE_LEVEL(BS_PIPELINE_LEVEL)
)  cnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({cnu_msg_in[84][0],cnu_msg_in[83][0],cnu_msg_in[82][0],cnu_msg_in[81][0],cnu_msg_in[80][0],cnu_msg_in[79][0],cnu_msg_in[78][0],cnu_msg_in[77][0],cnu_msg_in[76][0],cnu_msg_in[75][0],cnu_msg_in[74][0],cnu_msg_in[73][0],cnu_msg_in[72][0],cnu_msg_in[71][0],cnu_msg_in[70][0],cnu_msg_in[69][0],cnu_msg_in[68][0],cnu_msg_in[67][0],cnu_msg_in[66][0],cnu_msg_in[65][0],cnu_msg_in[64][0],cnu_msg_in[63][0],cnu_msg_in[62][0],cnu_msg_in[61][0],cnu_msg_in[60][0],cnu_msg_in[59][0],cnu_msg_in[58][0],cnu_msg_in[57][0],cnu_msg_in[56][0],cnu_msg_in[55][0],cnu_msg_in[54][0],cnu_msg_in[53][0],cnu_msg_in[52][0],cnu_msg_in[51][0],cnu_msg_in[50][0],cnu_msg_in[49][0],cnu_msg_in[48][0],cnu_msg_in[47][0],cnu_msg_in[46][0],cnu_msg_in[45][0],cnu_msg_in[44][0],cnu_msg_in[43][0],cnu_msg_in[42][0],cnu_msg_in[41][0],cnu_msg_in[40][0],cnu_msg_in[39][0],cnu_msg_in[38][0],cnu_msg_in[37][0],cnu_msg_in[36][0],cnu_msg_in[35][0],cnu_msg_in[34][0],cnu_msg_in[33][0],cnu_msg_in[32][0],cnu_msg_in[31][0],cnu_msg_in[30][0],cnu_msg_in[29][0],cnu_msg_in[28][0],cnu_msg_in[27][0],cnu_msg_in[26][0],cnu_msg_in[25][0],cnu_msg_in[24][0],cnu_msg_in[23][0],cnu_msg_in[22][0],cnu_msg_in[21][0],cnu_msg_in[20][0],cnu_msg_in[19][0],cnu_msg_in[18][0],cnu_msg_in[17][0],cnu_msg_in[16][0],cnu_msg_in[15][0],cnu_msg_in[14][0],cnu_msg_in[13][0],cnu_msg_in[12][0],cnu_msg_in[11][0],cnu_msg_in[10][0],cnu_msg_in[9][0],cnu_msg_in[8][0],cnu_msg_in[7][0],cnu_msg_in[6][0],cnu_msg_in[5][0],cnu_msg_in[4][0],cnu_msg_in[3][0],cnu_msg_in[2][0],cnu_msg_in[1][0],cnu_msg_in[0][0]}),
	.sw_out_bit1 ({cnu_msg_in[84][1],cnu_msg_in[83][1],cnu_msg_in[82][1],cnu_msg_in[81][1],cnu_msg_in[80][1],cnu_msg_in[79][1],cnu_msg_in[78][1],cnu_msg_in[77][1],cnu_msg_in[76][1],cnu_msg_in[75][1],cnu_msg_in[74][1],cnu_msg_in[73][1],cnu_msg_in[72][1],cnu_msg_in[71][1],cnu_msg_in[70][1],cnu_msg_in[69][1],cnu_msg_in[68][1],cnu_msg_in[67][1],cnu_msg_in[66][1],cnu_msg_in[65][1],cnu_msg_in[64][1],cnu_msg_in[63][1],cnu_msg_in[62][1],cnu_msg_in[61][1],cnu_msg_in[60][1],cnu_msg_in[59][1],cnu_msg_in[58][1],cnu_msg_in[57][1],cnu_msg_in[56][1],cnu_msg_in[55][1],cnu_msg_in[54][1],cnu_msg_in[53][1],cnu_msg_in[52][1],cnu_msg_in[51][1],cnu_msg_in[50][1],cnu_msg_in[49][1],cnu_msg_in[48][1],cnu_msg_in[47][1],cnu_msg_in[46][1],cnu_msg_in[45][1],cnu_msg_in[44][1],cnu_msg_in[43][1],cnu_msg_in[42][1],cnu_msg_in[41][1],cnu_msg_in[40][1],cnu_msg_in[39][1],cnu_msg_in[38][1],cnu_msg_in[37][1],cnu_msg_in[36][1],cnu_msg_in[35][1],cnu_msg_in[34][1],cnu_msg_in[33][1],cnu_msg_in[32][1],cnu_msg_in[31][1],cnu_msg_in[30][1],cnu_msg_in[29][1],cnu_msg_in[28][1],cnu_msg_in[27][1],cnu_msg_in[26][1],cnu_msg_in[25][1],cnu_msg_in[24][1],cnu_msg_in[23][1],cnu_msg_in[22][1],cnu_msg_in[21][1],cnu_msg_in[20][1],cnu_msg_in[19][1],cnu_msg_in[18][1],cnu_msg_in[17][1],cnu_msg_in[16][1],cnu_msg_in[15][1],cnu_msg_in[14][1],cnu_msg_in[13][1],cnu_msg_in[12][1],cnu_msg_in[11][1],cnu_msg_in[10][1],cnu_msg_in[9][1],cnu_msg_in[8][1],cnu_msg_in[7][1],cnu_msg_in[6][1],cnu_msg_in[5][1],cnu_msg_in[4][1],cnu_msg_in[3][1],cnu_msg_in[2][1],cnu_msg_in[1][1],cnu_msg_in[0][1]}),
	.sw_out_bit2 ({cnu_msg_in[84][2],cnu_msg_in[83][2],cnu_msg_in[82][2],cnu_msg_in[81][2],cnu_msg_in[80][2],cnu_msg_in[79][2],cnu_msg_in[78][2],cnu_msg_in[77][2],cnu_msg_in[76][2],cnu_msg_in[75][2],cnu_msg_in[74][2],cnu_msg_in[73][2],cnu_msg_in[72][2],cnu_msg_in[71][2],cnu_msg_in[70][2],cnu_msg_in[69][2],cnu_msg_in[68][2],cnu_msg_in[67][2],cnu_msg_in[66][2],cnu_msg_in[65][2],cnu_msg_in[64][2],cnu_msg_in[63][2],cnu_msg_in[62][2],cnu_msg_in[61][2],cnu_msg_in[60][2],cnu_msg_in[59][2],cnu_msg_in[58][2],cnu_msg_in[57][2],cnu_msg_in[56][2],cnu_msg_in[55][2],cnu_msg_in[54][2],cnu_msg_in[53][2],cnu_msg_in[52][2],cnu_msg_in[51][2],cnu_msg_in[50][2],cnu_msg_in[49][2],cnu_msg_in[48][2],cnu_msg_in[47][2],cnu_msg_in[46][2],cnu_msg_in[45][2],cnu_msg_in[44][2],cnu_msg_in[43][2],cnu_msg_in[42][2],cnu_msg_in[41][2],cnu_msg_in[40][2],cnu_msg_in[39][2],cnu_msg_in[38][2],cnu_msg_in[37][2],cnu_msg_in[36][2],cnu_msg_in[35][2],cnu_msg_in[34][2],cnu_msg_in[33][2],cnu_msg_in[32][2],cnu_msg_in[31][2],cnu_msg_in[30][2],cnu_msg_in[29][2],cnu_msg_in[28][2],cnu_msg_in[27][2],cnu_msg_in[26][2],cnu_msg_in[25][2],cnu_msg_in[24][2],cnu_msg_in[23][2],cnu_msg_in[22][2],cnu_msg_in[21][2],cnu_msg_in[20][2],cnu_msg_in[19][2],cnu_msg_in[18][2],cnu_msg_in[17][2],cnu_msg_in[16][2],cnu_msg_in[15][2],cnu_msg_in[14][2],cnu_msg_in[13][2],cnu_msg_in[12][2],cnu_msg_in[11][2],cnu_msg_in[10][2],cnu_msg_in[9][2],cnu_msg_in[8][2],cnu_msg_in[7][2],cnu_msg_in[6][2],cnu_msg_in[5][2],cnu_msg_in[4][2],cnu_msg_in[3][2],cnu_msg_in[2][2],cnu_msg_in[1][2],cnu_msg_in[0][2]}),	
	.sw_out_bit3 ({cnu_msg_in[84][3],cnu_msg_in[83][3],cnu_msg_in[82][3],cnu_msg_in[81][3],cnu_msg_in[80][3],cnu_msg_in[79][3],cnu_msg_in[78][3],cnu_msg_in[77][3],cnu_msg_in[76][3],cnu_msg_in[75][3],cnu_msg_in[74][3],cnu_msg_in[73][3],cnu_msg_in[72][3],cnu_msg_in[71][3],cnu_msg_in[70][3],cnu_msg_in[69][3],cnu_msg_in[68][3],cnu_msg_in[67][3],cnu_msg_in[66][3],cnu_msg_in[65][3],cnu_msg_in[64][3],cnu_msg_in[63][3],cnu_msg_in[62][3],cnu_msg_in[61][3],cnu_msg_in[60][3],cnu_msg_in[59][3],cnu_msg_in[58][3],cnu_msg_in[57][3],cnu_msg_in[56][3],cnu_msg_in[55][3],cnu_msg_in[54][3],cnu_msg_in[53][3],cnu_msg_in[52][3],cnu_msg_in[51][3],cnu_msg_in[50][3],cnu_msg_in[49][3],cnu_msg_in[48][3],cnu_msg_in[47][3],cnu_msg_in[46][3],cnu_msg_in[45][3],cnu_msg_in[44][3],cnu_msg_in[43][3],cnu_msg_in[42][3],cnu_msg_in[41][3],cnu_msg_in[40][3],cnu_msg_in[39][3],cnu_msg_in[38][3],cnu_msg_in[37][3],cnu_msg_in[36][3],cnu_msg_in[35][3],cnu_msg_in[34][3],cnu_msg_in[33][3],cnu_msg_in[32][3],cnu_msg_in[31][3],cnu_msg_in[30][3],cnu_msg_in[29][3],cnu_msg_in[28][3],cnu_msg_in[27][3],cnu_msg_in[26][3],cnu_msg_in[25][3],cnu_msg_in[24][3],cnu_msg_in[23][3],cnu_msg_in[22][3],cnu_msg_in[21][3],cnu_msg_in[20][3],cnu_msg_in[19][3],cnu_msg_in[18][3],cnu_msg_in[17][3],cnu_msg_in[16][3],cnu_msg_in[15][3],cnu_msg_in[14][3],cnu_msg_in[13][3],cnu_msg_in[12][3],cnu_msg_in[11][3],cnu_msg_in[10][3],cnu_msg_in[9][3],cnu_msg_in[8][3],cnu_msg_in[7][3],cnu_msg_in[6][3],cnu_msg_in[5][3],cnu_msg_in[4][3],cnu_msg_in[3][3],cnu_msg_in[2][3],cnu_msg_in[1][3],cnu_msg_in[0][3]}),
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in_bit0  (cnu_bs_in_bit[0]),
	.sw_in_bit1  (cnu_bs_in_bit[1]),
	.sw_in_bit2  (cnu_bs_in_bit[2]),
	.sw_in_bit3  (cnu_bs_in_bit[3])
);
/*----------------------------------------------*/
// Circular shifter of variable nodes 
zero_shuffle_top_85b #(
	.CHECK_PARALLELISM(CHECK_PARALLELISM),
	.BS_PIPELINE_LEVEL(BS_PIPELINE_LEVEL)
) vnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({vnu_msg_in[84][0],vnu_msg_in[83][0],vnu_msg_in[82][0],vnu_msg_in[81][0],vnu_msg_in[80][0],vnu_msg_in[79][0],vnu_msg_in[78][0],vnu_msg_in[77][0],vnu_msg_in[76][0],vnu_msg_in[75][0],vnu_msg_in[74][0],vnu_msg_in[73][0],vnu_msg_in[72][0],vnu_msg_in[71][0],vnu_msg_in[70][0],vnu_msg_in[69][0],vnu_msg_in[68][0],vnu_msg_in[67][0],vnu_msg_in[66][0],vnu_msg_in[65][0],vnu_msg_in[64][0],vnu_msg_in[63][0],vnu_msg_in[62][0],vnu_msg_in[61][0],vnu_msg_in[60][0],vnu_msg_in[59][0],vnu_msg_in[58][0],vnu_msg_in[57][0],vnu_msg_in[56][0],vnu_msg_in[55][0],vnu_msg_in[54][0],vnu_msg_in[53][0],vnu_msg_in[52][0],vnu_msg_in[51][0],vnu_msg_in[50][0],vnu_msg_in[49][0],vnu_msg_in[48][0],vnu_msg_in[47][0],vnu_msg_in[46][0],vnu_msg_in[45][0],vnu_msg_in[44][0],vnu_msg_in[43][0],vnu_msg_in[42][0],vnu_msg_in[41][0],vnu_msg_in[40][0],vnu_msg_in[39][0],vnu_msg_in[38][0],vnu_msg_in[37][0],vnu_msg_in[36][0],vnu_msg_in[35][0],vnu_msg_in[34][0],vnu_msg_in[33][0],vnu_msg_in[32][0],vnu_msg_in[31][0],vnu_msg_in[30][0],vnu_msg_in[29][0],vnu_msg_in[28][0],vnu_msg_in[27][0],vnu_msg_in[26][0],vnu_msg_in[25][0],vnu_msg_in[24][0],vnu_msg_in[23][0],vnu_msg_in[22][0],vnu_msg_in[21][0],vnu_msg_in[20][0],vnu_msg_in[19][0],vnu_msg_in[18][0],vnu_msg_in[17][0],vnu_msg_in[16][0],vnu_msg_in[15][0],vnu_msg_in[14][0],vnu_msg_in[13][0],vnu_msg_in[12][0],vnu_msg_in[11][0],vnu_msg_in[10][0],vnu_msg_in[9][0],vnu_msg_in[8][0],vnu_msg_in[7][0],vnu_msg_in[6][0],vnu_msg_in[5][0],vnu_msg_in[4][0],vnu_msg_in[3][0],vnu_msg_in[2][0],vnu_msg_in[1][0],vnu_msg_in[0][0]}),
	.sw_out_bit1 ({vnu_msg_in[84][1],vnu_msg_in[83][1],vnu_msg_in[82][1],vnu_msg_in[81][1],vnu_msg_in[80][1],vnu_msg_in[79][1],vnu_msg_in[78][1],vnu_msg_in[77][1],vnu_msg_in[76][1],vnu_msg_in[75][1],vnu_msg_in[74][1],vnu_msg_in[73][1],vnu_msg_in[72][1],vnu_msg_in[71][1],vnu_msg_in[70][1],vnu_msg_in[69][1],vnu_msg_in[68][1],vnu_msg_in[67][1],vnu_msg_in[66][1],vnu_msg_in[65][1],vnu_msg_in[64][1],vnu_msg_in[63][1],vnu_msg_in[62][1],vnu_msg_in[61][1],vnu_msg_in[60][1],vnu_msg_in[59][1],vnu_msg_in[58][1],vnu_msg_in[57][1],vnu_msg_in[56][1],vnu_msg_in[55][1],vnu_msg_in[54][1],vnu_msg_in[53][1],vnu_msg_in[52][1],vnu_msg_in[51][1],vnu_msg_in[50][1],vnu_msg_in[49][1],vnu_msg_in[48][1],vnu_msg_in[47][1],vnu_msg_in[46][1],vnu_msg_in[45][1],vnu_msg_in[44][1],vnu_msg_in[43][1],vnu_msg_in[42][1],vnu_msg_in[41][1],vnu_msg_in[40][1],vnu_msg_in[39][1],vnu_msg_in[38][1],vnu_msg_in[37][1],vnu_msg_in[36][1],vnu_msg_in[35][1],vnu_msg_in[34][1],vnu_msg_in[33][1],vnu_msg_in[32][1],vnu_msg_in[31][1],vnu_msg_in[30][1],vnu_msg_in[29][1],vnu_msg_in[28][1],vnu_msg_in[27][1],vnu_msg_in[26][1],vnu_msg_in[25][1],vnu_msg_in[24][1],vnu_msg_in[23][1],vnu_msg_in[22][1],vnu_msg_in[21][1],vnu_msg_in[20][1],vnu_msg_in[19][1],vnu_msg_in[18][1],vnu_msg_in[17][1],vnu_msg_in[16][1],vnu_msg_in[15][1],vnu_msg_in[14][1],vnu_msg_in[13][1],vnu_msg_in[12][1],vnu_msg_in[11][1],vnu_msg_in[10][1],vnu_msg_in[9][1],vnu_msg_in[8][1],vnu_msg_in[7][1],vnu_msg_in[6][1],vnu_msg_in[5][1],vnu_msg_in[4][1],vnu_msg_in[3][1],vnu_msg_in[2][1],vnu_msg_in[1][1],vnu_msg_in[0][1]}),	
	.sw_out_bit2 ({vnu_msg_in[84][2],vnu_msg_in[83][2],vnu_msg_in[82][2],vnu_msg_in[81][2],vnu_msg_in[80][2],vnu_msg_in[79][2],vnu_msg_in[78][2],vnu_msg_in[77][2],vnu_msg_in[76][2],vnu_msg_in[75][2],vnu_msg_in[74][2],vnu_msg_in[73][2],vnu_msg_in[72][2],vnu_msg_in[71][2],vnu_msg_in[70][2],vnu_msg_in[69][2],vnu_msg_in[68][2],vnu_msg_in[67][2],vnu_msg_in[66][2],vnu_msg_in[65][2],vnu_msg_in[64][2],vnu_msg_in[63][2],vnu_msg_in[62][2],vnu_msg_in[61][2],vnu_msg_in[60][2],vnu_msg_in[59][2],vnu_msg_in[58][2],vnu_msg_in[57][2],vnu_msg_in[56][2],vnu_msg_in[55][2],vnu_msg_in[54][2],vnu_msg_in[53][2],vnu_msg_in[52][2],vnu_msg_in[51][2],vnu_msg_in[50][2],vnu_msg_in[49][2],vnu_msg_in[48][2],vnu_msg_in[47][2],vnu_msg_in[46][2],vnu_msg_in[45][2],vnu_msg_in[44][2],vnu_msg_in[43][2],vnu_msg_in[42][2],vnu_msg_in[41][2],vnu_msg_in[40][2],vnu_msg_in[39][2],vnu_msg_in[38][2],vnu_msg_in[37][2],vnu_msg_in[36][2],vnu_msg_in[35][2],vnu_msg_in[34][2],vnu_msg_in[33][2],vnu_msg_in[32][2],vnu_msg_in[31][2],vnu_msg_in[30][2],vnu_msg_in[29][2],vnu_msg_in[28][2],vnu_msg_in[27][2],vnu_msg_in[26][2],vnu_msg_in[25][2],vnu_msg_in[24][2],vnu_msg_in[23][2],vnu_msg_in[22][2],vnu_msg_in[21][2],vnu_msg_in[20][2],vnu_msg_in[19][2],vnu_msg_in[18][2],vnu_msg_in[17][2],vnu_msg_in[16][2],vnu_msg_in[15][2],vnu_msg_in[14][2],vnu_msg_in[13][2],vnu_msg_in[12][2],vnu_msg_in[11][2],vnu_msg_in[10][2],vnu_msg_in[9][2],vnu_msg_in[8][2],vnu_msg_in[7][2],vnu_msg_in[6][2],vnu_msg_in[5][2],vnu_msg_in[4][2],vnu_msg_in[3][2],vnu_msg_in[2][2],vnu_msg_in[1][2],vnu_msg_in[0][2]}),	
	.sw_out_bit3 ({vnu_msg_in[84][3],vnu_msg_in[83][3],vnu_msg_in[82][3],vnu_msg_in[81][3],vnu_msg_in[80][3],vnu_msg_in[79][3],vnu_msg_in[78][3],vnu_msg_in[77][3],vnu_msg_in[76][3],vnu_msg_in[75][3],vnu_msg_in[74][3],vnu_msg_in[73][3],vnu_msg_in[72][3],vnu_msg_in[71][3],vnu_msg_in[70][3],vnu_msg_in[69][3],vnu_msg_in[68][3],vnu_msg_in[67][3],vnu_msg_in[66][3],vnu_msg_in[65][3],vnu_msg_in[64][3],vnu_msg_in[63][3],vnu_msg_in[62][3],vnu_msg_in[61][3],vnu_msg_in[60][3],vnu_msg_in[59][3],vnu_msg_in[58][3],vnu_msg_in[57][3],vnu_msg_in[56][3],vnu_msg_in[55][3],vnu_msg_in[54][3],vnu_msg_in[53][3],vnu_msg_in[52][3],vnu_msg_in[51][3],vnu_msg_in[50][3],vnu_msg_in[49][3],vnu_msg_in[48][3],vnu_msg_in[47][3],vnu_msg_in[46][3],vnu_msg_in[45][3],vnu_msg_in[44][3],vnu_msg_in[43][3],vnu_msg_in[42][3],vnu_msg_in[41][3],vnu_msg_in[40][3],vnu_msg_in[39][3],vnu_msg_in[38][3],vnu_msg_in[37][3],vnu_msg_in[36][3],vnu_msg_in[35][3],vnu_msg_in[34][3],vnu_msg_in[33][3],vnu_msg_in[32][3],vnu_msg_in[31][3],vnu_msg_in[30][3],vnu_msg_in[29][3],vnu_msg_in[28][3],vnu_msg_in[27][3],vnu_msg_in[26][3],vnu_msg_in[25][3],vnu_msg_in[24][3],vnu_msg_in[23][3],vnu_msg_in[22][3],vnu_msg_in[21][3],vnu_msg_in[20][3],vnu_msg_in[19][3],vnu_msg_in[18][3],vnu_msg_in[17][3],vnu_msg_in[16][3],vnu_msg_in[15][3],vnu_msg_in[14][3],vnu_msg_in[13][3],vnu_msg_in[12][3],vnu_msg_in[11][3],vnu_msg_in[10][3],vnu_msg_in[9][3],vnu_msg_in[8][3],vnu_msg_in[7][3],vnu_msg_in[6][3],vnu_msg_in[5][3],vnu_msg_in[4][3],vnu_msg_in[3][3],vnu_msg_in[2][3],vnu_msg_in[1][3],vnu_msg_in[0][3]}),
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),

	.sw_in1_bit0 (dnu_inRotate_bit),
	.sw_in_bit0_src (vnu_bs_bit0_src),
`endif
	.sw_in_bit0  (vnu_bs_in_bit[0]),
	.sw_in_bit1  (vnu_bs_in_bit[1]),
	.sw_in_bit2  (vnu_bs_in_bit[2]),
	.sw_in_bit3  (vnu_bs_in_bit[3])
);
/*----------------------------------------------*/	
	reg [ADDR_WIDTH-1:0] c2v_mem_page_addr;
	reg [ADDR_WIDTH-1:0] v2c_mem_page_addr;
	mem_subsystem_top_submatrix_0 #(
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
		) inst_mem_subsystem_top_submatrix_0 (
			.mem_to_vnu_0     (mem_to_vnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_vnu_1     (mem_to_vnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_vnu_2     (mem_to_vnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_vnu_3     (mem_to_vnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_vnu_4     (mem_to_vnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_vnu_5     (mem_to_vnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_vnu_6     (mem_to_vnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_vnu_7     (mem_to_vnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_vnu_8     (mem_to_vnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_vnu_9     (mem_to_vnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_vnu_10    (mem_to_vnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_vnu_11    (mem_to_vnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_vnu_12    (mem_to_vnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_vnu_13    (mem_to_vnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_vnu_14    (mem_to_vnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_vnu_15    (mem_to_vnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_vnu_16    (mem_to_vnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_vnu_17    (mem_to_vnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_vnu_18    (mem_to_vnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_vnu_19    (mem_to_vnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_vnu_20    (mem_to_vnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_vnu_21    (mem_to_vnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_vnu_22    (mem_to_vnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_vnu_23    (mem_to_vnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_vnu_24    (mem_to_vnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_vnu_25    (mem_to_vnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_vnu_26    (mem_to_vnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_vnu_27    (mem_to_vnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_vnu_28    (mem_to_vnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_vnu_29    (mem_to_vnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_vnu_30    (mem_to_vnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_vnu_31    (mem_to_vnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_vnu_32    (mem_to_vnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_vnu_33    (mem_to_vnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_vnu_34    (mem_to_vnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_vnu_35    (mem_to_vnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_vnu_36    (mem_to_vnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_vnu_37    (mem_to_vnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_vnu_38    (mem_to_vnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_vnu_39    (mem_to_vnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_vnu_40    (mem_to_vnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_vnu_41    (mem_to_vnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_vnu_42    (mem_to_vnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_vnu_43    (mem_to_vnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_vnu_44    (mem_to_vnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_vnu_45    (mem_to_vnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_vnu_46    (mem_to_vnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_vnu_47    (mem_to_vnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_vnu_48    (mem_to_vnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_vnu_49    (mem_to_vnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_vnu_50    (mem_to_vnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_vnu_51    (mem_to_vnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_vnu_52    (mem_to_vnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_vnu_53    (mem_to_vnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_vnu_54    (mem_to_vnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_vnu_55    (mem_to_vnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_vnu_56    (mem_to_vnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_vnu_57    (mem_to_vnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_vnu_58    (mem_to_vnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_vnu_59    (mem_to_vnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_vnu_60    (mem_to_vnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_vnu_61    (mem_to_vnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_vnu_62    (mem_to_vnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_vnu_63    (mem_to_vnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_vnu_64    (mem_to_vnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_vnu_65    (mem_to_vnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_vnu_66    (mem_to_vnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_vnu_67    (mem_to_vnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_vnu_68    (mem_to_vnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_vnu_69    (mem_to_vnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_vnu_70    (mem_to_vnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_vnu_71    (mem_to_vnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_vnu_72    (mem_to_vnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_vnu_73    (mem_to_vnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_vnu_74    (mem_to_vnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_vnu_75    (mem_to_vnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_vnu_76    (mem_to_vnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_vnu_77    (mem_to_vnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_vnu_78    (mem_to_vnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_vnu_79    (mem_to_vnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_vnu_80    (mem_to_vnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_vnu_81    (mem_to_vnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_vnu_82    (mem_to_vnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_vnu_83    (mem_to_vnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_vnu_84    (mem_to_vnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),
			.mem_to_cnu_0     (mem_to_cnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_cnu_1     (mem_to_cnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_cnu_2     (mem_to_cnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_cnu_3     (mem_to_cnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_cnu_4     (mem_to_cnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_cnu_5     (mem_to_cnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_cnu_6     (mem_to_cnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_cnu_7     (mem_to_cnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_cnu_8     (mem_to_cnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_cnu_9     (mem_to_cnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_cnu_10    (mem_to_cnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_cnu_11    (mem_to_cnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_cnu_12    (mem_to_cnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_cnu_13    (mem_to_cnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_cnu_14    (mem_to_cnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_cnu_15    (mem_to_cnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_cnu_16    (mem_to_cnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_cnu_17    (mem_to_cnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_cnu_18    (mem_to_cnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_cnu_19    (mem_to_cnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_cnu_20    (mem_to_cnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_cnu_21    (mem_to_cnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_cnu_22    (mem_to_cnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_cnu_23    (mem_to_cnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_cnu_24    (mem_to_cnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_cnu_25    (mem_to_cnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_cnu_26    (mem_to_cnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_cnu_27    (mem_to_cnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_cnu_28    (mem_to_cnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_cnu_29    (mem_to_cnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_cnu_30    (mem_to_cnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_cnu_31    (mem_to_cnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_cnu_32    (mem_to_cnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_cnu_33    (mem_to_cnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_cnu_34    (mem_to_cnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_cnu_35    (mem_to_cnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_cnu_36    (mem_to_cnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_cnu_37    (mem_to_cnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_cnu_38    (mem_to_cnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_cnu_39    (mem_to_cnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_cnu_40    (mem_to_cnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_cnu_41    (mem_to_cnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_cnu_42    (mem_to_cnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_cnu_43    (mem_to_cnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_cnu_44    (mem_to_cnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_cnu_45    (mem_to_cnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_cnu_46    (mem_to_cnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_cnu_47    (mem_to_cnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_cnu_48    (mem_to_cnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_cnu_49    (mem_to_cnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_cnu_50    (mem_to_cnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_cnu_51    (mem_to_cnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_cnu_52    (mem_to_cnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_cnu_53    (mem_to_cnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_cnu_54    (mem_to_cnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_cnu_55    (mem_to_cnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_cnu_56    (mem_to_cnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_cnu_57    (mem_to_cnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_cnu_58    (mem_to_cnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_cnu_59    (mem_to_cnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_cnu_60    (mem_to_cnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_cnu_61    (mem_to_cnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_cnu_62    (mem_to_cnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_cnu_63    (mem_to_cnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_cnu_64    (mem_to_cnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_cnu_65    (mem_to_cnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_cnu_66    (mem_to_cnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_cnu_67    (mem_to_cnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_cnu_68    (mem_to_cnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_cnu_69    (mem_to_cnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_cnu_70    (mem_to_cnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_cnu_71    (mem_to_cnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_cnu_72    (mem_to_cnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_cnu_73    (mem_to_cnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_cnu_74    (mem_to_cnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_cnu_75    (mem_to_cnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_cnu_76    (mem_to_cnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_cnu_77    (mem_to_cnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_cnu_78    (mem_to_cnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_cnu_79    (mem_to_cnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_cnu_80    (mem_to_cnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_cnu_81    (mem_to_cnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_cnu_82    (mem_to_cnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_cnu_83    (mem_to_cnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_cnu_84    (mem_to_cnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),

			.vnu_to_mem_0     (vnu_msg_in[0 ]),
			.vnu_to_mem_1     (vnu_msg_in[1 ]),
			.vnu_to_mem_2     (vnu_msg_in[2 ]),
			.vnu_to_mem_3     (vnu_msg_in[3 ]),
			.vnu_to_mem_4     (vnu_msg_in[4 ]),
			.vnu_to_mem_5     (vnu_msg_in[5 ]),
			.vnu_to_mem_6     (vnu_msg_in[6 ]),
			.vnu_to_mem_7     (vnu_msg_in[7 ]),
			.vnu_to_mem_8     (vnu_msg_in[8 ]),
			.vnu_to_mem_9     (vnu_msg_in[9 ]),
			.vnu_to_mem_10    (vnu_msg_in[10]),
			.vnu_to_mem_11    (vnu_msg_in[11]),
			.vnu_to_mem_12    (vnu_msg_in[12]),
			.vnu_to_mem_13    (vnu_msg_in[13]),
			.vnu_to_mem_14    (vnu_msg_in[14]),
			.vnu_to_mem_15    (vnu_msg_in[15]),
			.vnu_to_mem_16    (vnu_msg_in[16]),
			.vnu_to_mem_17    (vnu_msg_in[17]),
			.vnu_to_mem_18    (vnu_msg_in[18]),
			.vnu_to_mem_19    (vnu_msg_in[19]),
			.vnu_to_mem_20    (vnu_msg_in[20]),
			.vnu_to_mem_21    (vnu_msg_in[21]),
			.vnu_to_mem_22    (vnu_msg_in[22]),
			.vnu_to_mem_23    (vnu_msg_in[23]),
			.vnu_to_mem_24    (vnu_msg_in[24]),
			.vnu_to_mem_25    (vnu_msg_in[25]),
			.vnu_to_mem_26    (vnu_msg_in[26]),
			.vnu_to_mem_27    (vnu_msg_in[27]),
			.vnu_to_mem_28    (vnu_msg_in[28]),
			.vnu_to_mem_29    (vnu_msg_in[29]),
			.vnu_to_mem_30    (vnu_msg_in[30]),
			.vnu_to_mem_31    (vnu_msg_in[31]),
			.vnu_to_mem_32    (vnu_msg_in[32]),
			.vnu_to_mem_33    (vnu_msg_in[33]),
			.vnu_to_mem_34    (vnu_msg_in[34]),
			.vnu_to_mem_35    (vnu_msg_in[35]),
			.vnu_to_mem_36    (vnu_msg_in[36]),
			.vnu_to_mem_37    (vnu_msg_in[37]),
			.vnu_to_mem_38    (vnu_msg_in[38]),
			.vnu_to_mem_39    (vnu_msg_in[39]),
			.vnu_to_mem_40    (vnu_msg_in[40]),
			.vnu_to_mem_41    (vnu_msg_in[41]),
			.vnu_to_mem_42    (vnu_msg_in[42]),
			.vnu_to_mem_43    (vnu_msg_in[43]),
			.vnu_to_mem_44    (vnu_msg_in[44]),
			.vnu_to_mem_45    (vnu_msg_in[45]),
			.vnu_to_mem_46    (vnu_msg_in[46]),
			.vnu_to_mem_47    (vnu_msg_in[47]),
			.vnu_to_mem_48    (vnu_msg_in[48]),
			.vnu_to_mem_49    (vnu_msg_in[49]),
			.vnu_to_mem_50    (vnu_msg_in[50]),
			.vnu_to_mem_51    (vnu_msg_in[51]),
			.vnu_to_mem_52    (vnu_msg_in[52]),
			.vnu_to_mem_53    (vnu_msg_in[53]),
			.vnu_to_mem_54    (vnu_msg_in[54]),
			.vnu_to_mem_55    (vnu_msg_in[55]),
			.vnu_to_mem_56    (vnu_msg_in[56]),
			.vnu_to_mem_57    (vnu_msg_in[57]),
			.vnu_to_mem_58    (vnu_msg_in[58]),
			.vnu_to_mem_59    (vnu_msg_in[59]),
			.vnu_to_mem_60    (vnu_msg_in[60]),
			.vnu_to_mem_61    (vnu_msg_in[61]),
			.vnu_to_mem_62    (vnu_msg_in[62]),
			.vnu_to_mem_63    (vnu_msg_in[63]),
			.vnu_to_mem_64    (vnu_msg_in[64]),
			.vnu_to_mem_65    (vnu_msg_in[65]),
			.vnu_to_mem_66    (vnu_msg_in[66]),
			.vnu_to_mem_67    (vnu_msg_in[67]),
			.vnu_to_mem_68    (vnu_msg_in[68]),
			.vnu_to_mem_69    (vnu_msg_in[69]),
			.vnu_to_mem_70    (vnu_msg_in[70]),
			.vnu_to_mem_71    (vnu_msg_in[71]),
			.vnu_to_mem_72    (vnu_msg_in[72]),
			.vnu_to_mem_73    (vnu_msg_in[73]),
			.vnu_to_mem_74    (vnu_msg_in[74]),
			.vnu_to_mem_75    (vnu_msg_in[75]),
			.vnu_to_mem_76    (vnu_msg_in[76]),
			.vnu_to_mem_77    (vnu_msg_in[77]),
			.vnu_to_mem_78    (vnu_msg_in[78]),
			.vnu_to_mem_79    (vnu_msg_in[79]),
			.vnu_to_mem_80    (vnu_msg_in[80]),
			.vnu_to_mem_81    (vnu_msg_in[81]),
			.vnu_to_mem_82    (vnu_msg_in[82]),
			.vnu_to_mem_83    (vnu_msg_in[83]),
			.vnu_to_mem_84    (vnu_msg_in[84]),
			.cnu_to_mem_0     (cnu_msg_in[0 ]),
			.cnu_to_mem_1     (cnu_msg_in[1 ]),
			.cnu_to_mem_2     (cnu_msg_in[2 ]),
			.cnu_to_mem_3     (cnu_msg_in[3 ]),
			.cnu_to_mem_4     (cnu_msg_in[4 ]),
			.cnu_to_mem_5     (cnu_msg_in[5 ]),
			.cnu_to_mem_6     (cnu_msg_in[6 ]),
			.cnu_to_mem_7     (cnu_msg_in[7 ]),
			.cnu_to_mem_8     (cnu_msg_in[8 ]),
			.cnu_to_mem_9     (cnu_msg_in[9 ]),
			.cnu_to_mem_10    (cnu_msg_in[10]),
			.cnu_to_mem_11    (cnu_msg_in[11]),
			.cnu_to_mem_12    (cnu_msg_in[12]),
			.cnu_to_mem_13    (cnu_msg_in[13]),
			.cnu_to_mem_14    (cnu_msg_in[14]),
			.cnu_to_mem_15    (cnu_msg_in[15]),
			.cnu_to_mem_16    (cnu_msg_in[16]),
			.cnu_to_mem_17    (cnu_msg_in[17]),
			.cnu_to_mem_18    (cnu_msg_in[18]),
			.cnu_to_mem_19    (cnu_msg_in[19]),
			.cnu_to_mem_20    (cnu_msg_in[20]),
			.cnu_to_mem_21    (cnu_msg_in[21]),
			.cnu_to_mem_22    (cnu_msg_in[22]),
			.cnu_to_mem_23    (cnu_msg_in[23]),
			.cnu_to_mem_24    (cnu_msg_in[24]),
			.cnu_to_mem_25    (cnu_msg_in[25]),
			.cnu_to_mem_26    (cnu_msg_in[26]),
			.cnu_to_mem_27    (cnu_msg_in[27]),
			.cnu_to_mem_28    (cnu_msg_in[28]),
			.cnu_to_mem_29    (cnu_msg_in[29]),
			.cnu_to_mem_30    (cnu_msg_in[30]),
			.cnu_to_mem_31    (cnu_msg_in[31]),
			.cnu_to_mem_32    (cnu_msg_in[32]),
			.cnu_to_mem_33    (cnu_msg_in[33]),
			.cnu_to_mem_34    (cnu_msg_in[34]),
			.cnu_to_mem_35    (cnu_msg_in[35]),
			.cnu_to_mem_36    (cnu_msg_in[36]),
			.cnu_to_mem_37    (cnu_msg_in[37]),
			.cnu_to_mem_38    (cnu_msg_in[38]),
			.cnu_to_mem_39    (cnu_msg_in[39]),
			.cnu_to_mem_40    (cnu_msg_in[40]),
			.cnu_to_mem_41    (cnu_msg_in[41]),
			.cnu_to_mem_42    (cnu_msg_in[42]),
			.cnu_to_mem_43    (cnu_msg_in[43]),
			.cnu_to_mem_44    (cnu_msg_in[44]),
			.cnu_to_mem_45    (cnu_msg_in[45]),
			.cnu_to_mem_46    (cnu_msg_in[46]),
			.cnu_to_mem_47    (cnu_msg_in[47]),
			.cnu_to_mem_48    (cnu_msg_in[48]),
			.cnu_to_mem_49    (cnu_msg_in[49]),
			.cnu_to_mem_50    (cnu_msg_in[50]),
			.cnu_to_mem_51    (cnu_msg_in[51]),
			.cnu_to_mem_52    (cnu_msg_in[52]),
			.cnu_to_mem_53    (cnu_msg_in[53]),
			.cnu_to_mem_54    (cnu_msg_in[54]),
			.cnu_to_mem_55    (cnu_msg_in[55]),
			.cnu_to_mem_56    (cnu_msg_in[56]),
			.cnu_to_mem_57    (cnu_msg_in[57]),
			.cnu_to_mem_58    (cnu_msg_in[58]),
			.cnu_to_mem_59    (cnu_msg_in[59]),
			.cnu_to_mem_60    (cnu_msg_in[60]),
			.cnu_to_mem_61    (cnu_msg_in[61]),
			.cnu_to_mem_62    (cnu_msg_in[62]),
			.cnu_to_mem_63    (cnu_msg_in[63]),
			.cnu_to_mem_64    (cnu_msg_in[64]),
			.cnu_to_mem_65    (cnu_msg_in[65]),
			.cnu_to_mem_66    (cnu_msg_in[66]),
			.cnu_to_mem_67    (cnu_msg_in[67]),
			.cnu_to_mem_68    (cnu_msg_in[68]),
			.cnu_to_mem_69    (cnu_msg_in[69]),
			.cnu_to_mem_70    (cnu_msg_in[70]),
			.cnu_to_mem_71    (cnu_msg_in[71]),
			.cnu_to_mem_72    (cnu_msg_in[72]),
			.cnu_to_mem_73    (cnu_msg_in[73]),
			.cnu_to_mem_74    (cnu_msg_in[74]),
			.cnu_to_mem_75    (cnu_msg_in[75]),
			.cnu_to_mem_76    (cnu_msg_in[76]),
			.cnu_to_mem_77    (cnu_msg_in[77]),
			.cnu_to_mem_78    (cnu_msg_in[78]),
			.cnu_to_mem_79    (cnu_msg_in[79]),
			.cnu_to_mem_80    (cnu_msg_in[80]),
			.cnu_to_mem_81    (cnu_msg_in[81]),
			.cnu_to_mem_82    (cnu_msg_in[82]),
			.cnu_to_mem_83    (cnu_msg_in[83]),
			.cnu_to_mem_84    (cnu_msg_in[84]),
			.cnu_sync_addr    (cnu_mem_page_sync_addr),
			.vnu_sync_addr    (vnu_mem_page_sync_addr),
			.cnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.vnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.last_row_chunk   ({c2v_last_row_chunk, v2c_last_row_chunk}),
			.we               ({v2c_mem_we, c2v_mem_we}),
			.sys_clk          (read_clk),
			.rstn             (rstn)
		);
		assign cnu_mem_page_sync_addr = (v2c_mem_fetch == 1'b1) ? v2c_mem_page_rd_addr : 
										(c2v_mem_we == 1'b1) ? c2v_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.

		assign vnu_mem_page_sync_addr = (c2v_mem_fetch == 1'b1) ? c2v_mem_page_rd_addr : 
										(v2c_mem_we == 1'b1) ? v2c_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Check-to-Variable messages RAMs write-page addresses
	always @(posedge read_clk) begin
		if(rstn == 1'b0) 
			c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE;
		else if(c2v_mem_we == 1'b1) begin
			// page increment pattern within layer 0
			if(v2c_layer_cnt[0] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_1+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 1
			if(v2c_layer_cnt[1] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_2+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 2
			if(v2c_layer_cnt[2] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_2-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
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
/*-------------------------------------------------------------------------------------------------------------------------*/
endmodule

module msg_pass_submatrix_1_unit #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,
	parameter VN_DEGREE = 3,   // degree of one variable node
/*-------------------------------------------------------------------------------------*/
	// Parameters related to BS, PA and MEM
	parameter RAM_DEPTH = 1024,
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH),
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1),
	parameter shift_factor_0 = CHECK_PARALLELISM-24,
	parameter shift_factor_1 = CHECK_PARALLELISM-39,
	parameter shift_factor_2 = CHECK_PARALLELISM-63,

`ifdef SCHED_4_6
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,
	parameter C2V_MEM_ADDR_BASE = 0,
	parameter V2C_MEM_ADDR_BASE = ROW_CHUNK_NUM,
	parameter V2C_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter C2V_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH),
`endif
	parameter START_PAGE_1_0 = 2, // starting page address of layer 0 of submatrix_1
	parameter START_PAGE_1_1 = 8, // starting page address of layer 1 of submatrix_1
	parameter START_PAGE_1_2 = 1  // starting page address of layer 2 of submatrix_1
) (
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu,

	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit,

	// control signals
	input wire c2v_bs_en,
	input wire v2c_bs_en,
	input wire ch_bs_en,
	/*------------------------------*/
	// Control signals associative with message passing of channel buffer and DNU.SignExtension
	input wire ch_ram_init_we,
	input wire ch_ram_fetch,
	input wire v2c_outRotate_reg_we,
	input wire dnu_inRotate_bs_en,
	input wire dnu_inRotate_pa_en,
	input wire dnu_inRotate_wb,
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
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,

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
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_2;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_2;
wire [6:0]  cnu_left_sel;
wire [6:0]  cnu_right_sel;
wire [83:0] cnu_merge_sel;
wire [6:0]  vnu_left_sel;
wire [6:0]  vnu_right_sel;
wire [83:0] vnu_merge_sel;
wire [CHECK_PARALLELISM-1:0] cnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] vnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] ch_bs_in_bit [0:QUAN_SIZE-1];
genvar bit_index;
generate
	for(bit_index=0;bit_index<QUAN_SIZE;bit_index=bit_index+1) begin : extrinsic_msg_bs_in_inst
		assign cnu_bs_in_bit[bit_index] = {c2v_bs_in[QUAN_SIZE*84+bit_index],c2v_bs_in[QUAN_SIZE*83+bit_index],c2v_bs_in[QUAN_SIZE*82+bit_index],c2v_bs_in[QUAN_SIZE*81+bit_index],c2v_bs_in[QUAN_SIZE*80+bit_index],c2v_bs_in[QUAN_SIZE*79+bit_index],c2v_bs_in[QUAN_SIZE*78+bit_index],c2v_bs_in[QUAN_SIZE*77+bit_index],c2v_bs_in[QUAN_SIZE*76+bit_index],c2v_bs_in[QUAN_SIZE*75+bit_index],c2v_bs_in[QUAN_SIZE*74+bit_index],c2v_bs_in[QUAN_SIZE*73+bit_index],c2v_bs_in[QUAN_SIZE*72+bit_index],c2v_bs_in[QUAN_SIZE*71+bit_index],c2v_bs_in[QUAN_SIZE*70+bit_index],c2v_bs_in[QUAN_SIZE*69+bit_index],c2v_bs_in[QUAN_SIZE*68+bit_index],c2v_bs_in[QUAN_SIZE*67+bit_index],c2v_bs_in[QUAN_SIZE*66+bit_index],c2v_bs_in[QUAN_SIZE*65+bit_index],c2v_bs_in[QUAN_SIZE*64+bit_index],c2v_bs_in[QUAN_SIZE*63+bit_index],c2v_bs_in[QUAN_SIZE*62+bit_index],c2v_bs_in[QUAN_SIZE*61+bit_index],c2v_bs_in[QUAN_SIZE*60+bit_index],c2v_bs_in[QUAN_SIZE*59+bit_index],c2v_bs_in[QUAN_SIZE*58+bit_index],c2v_bs_in[QUAN_SIZE*57+bit_index],c2v_bs_in[QUAN_SIZE*56+bit_index],c2v_bs_in[QUAN_SIZE*55+bit_index],c2v_bs_in[QUAN_SIZE*54+bit_index],c2v_bs_in[QUAN_SIZE*53+bit_index],c2v_bs_in[QUAN_SIZE*52+bit_index],c2v_bs_in[QUAN_SIZE*51+bit_index],c2v_bs_in[QUAN_SIZE*50+bit_index],c2v_bs_in[QUAN_SIZE*49+bit_index],c2v_bs_in[QUAN_SIZE*48+bit_index],c2v_bs_in[QUAN_SIZE*47+bit_index],c2v_bs_in[QUAN_SIZE*46+bit_index],c2v_bs_in[QUAN_SIZE*45+bit_index],c2v_bs_in[QUAN_SIZE*44+bit_index],c2v_bs_in[QUAN_SIZE*43+bit_index],c2v_bs_in[QUAN_SIZE*42+bit_index],c2v_bs_in[QUAN_SIZE*41+bit_index],c2v_bs_in[QUAN_SIZE*40+bit_index],c2v_bs_in[QUAN_SIZE*39+bit_index],c2v_bs_in[QUAN_SIZE*38+bit_index],c2v_bs_in[QUAN_SIZE*37+bit_index],c2v_bs_in[QUAN_SIZE*36+bit_index],c2v_bs_in[QUAN_SIZE*35+bit_index],c2v_bs_in[QUAN_SIZE*34+bit_index],c2v_bs_in[QUAN_SIZE*33+bit_index],c2v_bs_in[QUAN_SIZE*32+bit_index],c2v_bs_in[QUAN_SIZE*31+bit_index],c2v_bs_in[QUAN_SIZE*30+bit_index],c2v_bs_in[QUAN_SIZE*29+bit_index],c2v_bs_in[QUAN_SIZE*28+bit_index],c2v_bs_in[QUAN_SIZE*27+bit_index],c2v_bs_in[QUAN_SIZE*26+bit_index],c2v_bs_in[QUAN_SIZE*25+bit_index],c2v_bs_in[QUAN_SIZE*24+bit_index],c2v_bs_in[QUAN_SIZE*23+bit_index],c2v_bs_in[QUAN_SIZE*22+bit_index],c2v_bs_in[QUAN_SIZE*21+bit_index],c2v_bs_in[QUAN_SIZE*20+bit_index],c2v_bs_in[QUAN_SIZE*19+bit_index],c2v_bs_in[QUAN_SIZE*18+bit_index],c2v_bs_in[QUAN_SIZE*17+bit_index],c2v_bs_in[QUAN_SIZE*16+bit_index],c2v_bs_in[QUAN_SIZE*15+bit_index],c2v_bs_in[QUAN_SIZE*14+bit_index],c2v_bs_in[QUAN_SIZE*13+bit_index],c2v_bs_in[QUAN_SIZE*12+bit_index],c2v_bs_in[QUAN_SIZE*11+bit_index],c2v_bs_in[QUAN_SIZE*10+bit_index],c2v_bs_in[QUAN_SIZE*9+bit_index],c2v_bs_in[QUAN_SIZE*8+bit_index],c2v_bs_in[QUAN_SIZE*7+bit_index],c2v_bs_in[QUAN_SIZE*6+bit_index],c2v_bs_in[QUAN_SIZE*5+bit_index],c2v_bs_in[QUAN_SIZE*4+bit_index],c2v_bs_in[QUAN_SIZE*3+bit_index],c2v_bs_in[QUAN_SIZE*2+bit_index],c2v_bs_in[QUAN_SIZE*1+bit_index],c2v_bs_in[QUAN_SIZE*0+bit_index]};
		assign vnu_bs_in_bit[bit_index] = {v2c_bs_in[QUAN_SIZE*84+bit_index],v2c_bs_in[QUAN_SIZE*83+bit_index],v2c_bs_in[QUAN_SIZE*82+bit_index],v2c_bs_in[QUAN_SIZE*81+bit_index],v2c_bs_in[QUAN_SIZE*80+bit_index],v2c_bs_in[QUAN_SIZE*79+bit_index],v2c_bs_in[QUAN_SIZE*78+bit_index],v2c_bs_in[QUAN_SIZE*77+bit_index],v2c_bs_in[QUAN_SIZE*76+bit_index],v2c_bs_in[QUAN_SIZE*75+bit_index],v2c_bs_in[QUAN_SIZE*74+bit_index],v2c_bs_in[QUAN_SIZE*73+bit_index],v2c_bs_in[QUAN_SIZE*72+bit_index],v2c_bs_in[QUAN_SIZE*71+bit_index],v2c_bs_in[QUAN_SIZE*70+bit_index],v2c_bs_in[QUAN_SIZE*69+bit_index],v2c_bs_in[QUAN_SIZE*68+bit_index],v2c_bs_in[QUAN_SIZE*67+bit_index],v2c_bs_in[QUAN_SIZE*66+bit_index],v2c_bs_in[QUAN_SIZE*65+bit_index],v2c_bs_in[QUAN_SIZE*64+bit_index],v2c_bs_in[QUAN_SIZE*63+bit_index],v2c_bs_in[QUAN_SIZE*62+bit_index],v2c_bs_in[QUAN_SIZE*61+bit_index],v2c_bs_in[QUAN_SIZE*60+bit_index],v2c_bs_in[QUAN_SIZE*59+bit_index],v2c_bs_in[QUAN_SIZE*58+bit_index],v2c_bs_in[QUAN_SIZE*57+bit_index],v2c_bs_in[QUAN_SIZE*56+bit_index],v2c_bs_in[QUAN_SIZE*55+bit_index],v2c_bs_in[QUAN_SIZE*54+bit_index],v2c_bs_in[QUAN_SIZE*53+bit_index],v2c_bs_in[QUAN_SIZE*52+bit_index],v2c_bs_in[QUAN_SIZE*51+bit_index],v2c_bs_in[QUAN_SIZE*50+bit_index],v2c_bs_in[QUAN_SIZE*49+bit_index],v2c_bs_in[QUAN_SIZE*48+bit_index],v2c_bs_in[QUAN_SIZE*47+bit_index],v2c_bs_in[QUAN_SIZE*46+bit_index],v2c_bs_in[QUAN_SIZE*45+bit_index],v2c_bs_in[QUAN_SIZE*44+bit_index],v2c_bs_in[QUAN_SIZE*43+bit_index],v2c_bs_in[QUAN_SIZE*42+bit_index],v2c_bs_in[QUAN_SIZE*41+bit_index],v2c_bs_in[QUAN_SIZE*40+bit_index],v2c_bs_in[QUAN_SIZE*39+bit_index],v2c_bs_in[QUAN_SIZE*38+bit_index],v2c_bs_in[QUAN_SIZE*37+bit_index],v2c_bs_in[QUAN_SIZE*36+bit_index],v2c_bs_in[QUAN_SIZE*35+bit_index],v2c_bs_in[QUAN_SIZE*34+bit_index],v2c_bs_in[QUAN_SIZE*33+bit_index],v2c_bs_in[QUAN_SIZE*32+bit_index],v2c_bs_in[QUAN_SIZE*31+bit_index],v2c_bs_in[QUAN_SIZE*30+bit_index],v2c_bs_in[QUAN_SIZE*29+bit_index],v2c_bs_in[QUAN_SIZE*28+bit_index],v2c_bs_in[QUAN_SIZE*27+bit_index],v2c_bs_in[QUAN_SIZE*26+bit_index],v2c_bs_in[QUAN_SIZE*25+bit_index],v2c_bs_in[QUAN_SIZE*24+bit_index],v2c_bs_in[QUAN_SIZE*23+bit_index],v2c_bs_in[QUAN_SIZE*22+bit_index],v2c_bs_in[QUAN_SIZE*21+bit_index],v2c_bs_in[QUAN_SIZE*20+bit_index],v2c_bs_in[QUAN_SIZE*19+bit_index],v2c_bs_in[QUAN_SIZE*18+bit_index],v2c_bs_in[QUAN_SIZE*17+bit_index],v2c_bs_in[QUAN_SIZE*16+bit_index],v2c_bs_in[QUAN_SIZE*15+bit_index],v2c_bs_in[QUAN_SIZE*14+bit_index],v2c_bs_in[QUAN_SIZE*13+bit_index],v2c_bs_in[QUAN_SIZE*12+bit_index],v2c_bs_in[QUAN_SIZE*11+bit_index],v2c_bs_in[QUAN_SIZE*10+bit_index],v2c_bs_in[QUAN_SIZE*9+bit_index],v2c_bs_in[QUAN_SIZE*8+bit_index],v2c_bs_in[QUAN_SIZE*7+bit_index],v2c_bs_in[QUAN_SIZE*6+bit_index],v2c_bs_in[QUAN_SIZE*5+bit_index],v2c_bs_in[QUAN_SIZE*4+bit_index],v2c_bs_in[QUAN_SIZE*3+bit_index],v2c_bs_in[QUAN_SIZE*2+bit_index],v2c_bs_in[QUAN_SIZE*1+bit_index],v2c_bs_in[QUAN_SIZE*0+bit_index]};
		assign ch_bs_in_bit[bit_index]  = { ch_bs_in[QUAN_SIZE*84+bit_index], ch_bs_in[QUAN_SIZE*83+bit_index], ch_bs_in[QUAN_SIZE*82+bit_index], ch_bs_in[QUAN_SIZE*81+bit_index], ch_bs_in[QUAN_SIZE*80+bit_index], ch_bs_in[QUAN_SIZE*79+bit_index], ch_bs_in[QUAN_SIZE*78+bit_index], ch_bs_in[QUAN_SIZE*77+bit_index], ch_bs_in[QUAN_SIZE*76+bit_index], ch_bs_in[QUAN_SIZE*75+bit_index], ch_bs_in[QUAN_SIZE*74+bit_index], ch_bs_in[QUAN_SIZE*73+bit_index], ch_bs_in[QUAN_SIZE*72+bit_index], ch_bs_in[QUAN_SIZE*71+bit_index], ch_bs_in[QUAN_SIZE*70+bit_index], ch_bs_in[QUAN_SIZE*69+bit_index], ch_bs_in[QUAN_SIZE*68+bit_index], ch_bs_in[QUAN_SIZE*67+bit_index], ch_bs_in[QUAN_SIZE*66+bit_index], ch_bs_in[QUAN_SIZE*65+bit_index], ch_bs_in[QUAN_SIZE*64+bit_index], ch_bs_in[QUAN_SIZE*63+bit_index], ch_bs_in[QUAN_SIZE*62+bit_index], ch_bs_in[QUAN_SIZE*61+bit_index], ch_bs_in[QUAN_SIZE*60+bit_index], ch_bs_in[QUAN_SIZE*59+bit_index], ch_bs_in[QUAN_SIZE*58+bit_index], ch_bs_in[QUAN_SIZE*57+bit_index], ch_bs_in[QUAN_SIZE*56+bit_index], ch_bs_in[QUAN_SIZE*55+bit_index], ch_bs_in[QUAN_SIZE*54+bit_index], ch_bs_in[QUAN_SIZE*53+bit_index], ch_bs_in[QUAN_SIZE*52+bit_index], ch_bs_in[QUAN_SIZE*51+bit_index], ch_bs_in[QUAN_SIZE*50+bit_index], ch_bs_in[QUAN_SIZE*49+bit_index], ch_bs_in[QUAN_SIZE*48+bit_index], ch_bs_in[QUAN_SIZE*47+bit_index], ch_bs_in[QUAN_SIZE*46+bit_index], ch_bs_in[QUAN_SIZE*45+bit_index], ch_bs_in[QUAN_SIZE*44+bit_index], ch_bs_in[QUAN_SIZE*43+bit_index], ch_bs_in[QUAN_SIZE*42+bit_index], ch_bs_in[QUAN_SIZE*41+bit_index], ch_bs_in[QUAN_SIZE*40+bit_index], ch_bs_in[QUAN_SIZE*39+bit_index], ch_bs_in[QUAN_SIZE*38+bit_index], ch_bs_in[QUAN_SIZE*37+bit_index], ch_bs_in[QUAN_SIZE*36+bit_index], ch_bs_in[QUAN_SIZE*35+bit_index], ch_bs_in[QUAN_SIZE*34+bit_index], ch_bs_in[QUAN_SIZE*33+bit_index], ch_bs_in[QUAN_SIZE*32+bit_index], ch_bs_in[QUAN_SIZE*31+bit_index], ch_bs_in[QUAN_SIZE*30+bit_index], ch_bs_in[QUAN_SIZE*29+bit_index], ch_bs_in[QUAN_SIZE*28+bit_index], ch_bs_in[QUAN_SIZE*27+bit_index], ch_bs_in[QUAN_SIZE*26+bit_index], ch_bs_in[QUAN_SIZE*25+bit_index], ch_bs_in[QUAN_SIZE*24+bit_index], ch_bs_in[QUAN_SIZE*23+bit_index], ch_bs_in[QUAN_SIZE*22+bit_index], ch_bs_in[QUAN_SIZE*21+bit_index], ch_bs_in[QUAN_SIZE*20+bit_index], ch_bs_in[QUAN_SIZE*19+bit_index], ch_bs_in[QUAN_SIZE*18+bit_index], ch_bs_in[QUAN_SIZE*17+bit_index], ch_bs_in[QUAN_SIZE*16+bit_index], ch_bs_in[QUAN_SIZE*15+bit_index], ch_bs_in[QUAN_SIZE*14+bit_index], ch_bs_in[QUAN_SIZE*13+bit_index], ch_bs_in[QUAN_SIZE*12+bit_index], ch_bs_in[QUAN_SIZE*11+bit_index], ch_bs_in[QUAN_SIZE*10+bit_index], ch_bs_in[QUAN_SIZE*9+bit_index], ch_bs_in[QUAN_SIZE*8+bit_index], ch_bs_in[QUAN_SIZE*7+bit_index], ch_bs_in[QUAN_SIZE*6+bit_index], ch_bs_in[QUAN_SIZE*5+bit_index], ch_bs_in[QUAN_SIZE*4+bit_index], ch_bs_in[QUAN_SIZE*3+bit_index], ch_bs_in[QUAN_SIZE*2+bit_index],ch_bs_in[QUAN_SIZE*1+bit_index], ch_bs_in[QUAN_SIZE*0+bit_index]};
	end
endgenerate
/*----------------------------------------------*/	
// Circular shifter of check nodes 
qsn_top_85b cnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({cnu_msg_in[84][0],cnu_msg_in[83][0],cnu_msg_in[82][0],cnu_msg_in[81][0],cnu_msg_in[80][0],cnu_msg_in[79][0],cnu_msg_in[78][0],cnu_msg_in[77][0],cnu_msg_in[76][0],cnu_msg_in[75][0],cnu_msg_in[74][0],cnu_msg_in[73][0],cnu_msg_in[72][0],cnu_msg_in[71][0],cnu_msg_in[70][0],cnu_msg_in[69][0],cnu_msg_in[68][0],cnu_msg_in[67][0],cnu_msg_in[66][0],cnu_msg_in[65][0],cnu_msg_in[64][0],cnu_msg_in[63][0],cnu_msg_in[62][0],cnu_msg_in[61][0],cnu_msg_in[60][0],cnu_msg_in[59][0],cnu_msg_in[58][0],cnu_msg_in[57][0],cnu_msg_in[56][0],cnu_msg_in[55][0],cnu_msg_in[54][0],cnu_msg_in[53][0],cnu_msg_in[52][0],cnu_msg_in[51][0],cnu_msg_in[50][0],cnu_msg_in[49][0],cnu_msg_in[48][0],cnu_msg_in[47][0],cnu_msg_in[46][0],cnu_msg_in[45][0],cnu_msg_in[44][0],cnu_msg_in[43][0],cnu_msg_in[42][0],cnu_msg_in[41][0],cnu_msg_in[40][0],cnu_msg_in[39][0],cnu_msg_in[38][0],cnu_msg_in[37][0],cnu_msg_in[36][0],cnu_msg_in[35][0],cnu_msg_in[34][0],cnu_msg_in[33][0],cnu_msg_in[32][0],cnu_msg_in[31][0],cnu_msg_in[30][0],cnu_msg_in[29][0],cnu_msg_in[28][0],cnu_msg_in[27][0],cnu_msg_in[26][0],cnu_msg_in[25][0],cnu_msg_in[24][0],cnu_msg_in[23][0],cnu_msg_in[22][0],cnu_msg_in[21][0],cnu_msg_in[20][0],cnu_msg_in[19][0],cnu_msg_in[18][0],cnu_msg_in[17][0],cnu_msg_in[16][0],cnu_msg_in[15][0],cnu_msg_in[14][0],cnu_msg_in[13][0],cnu_msg_in[12][0],cnu_msg_in[11][0],cnu_msg_in[10][0],cnu_msg_in[9][0],cnu_msg_in[8][0],cnu_msg_in[7][0],cnu_msg_in[6][0],cnu_msg_in[5][0],cnu_msg_in[4][0],cnu_msg_in[3][0],cnu_msg_in[2][0],cnu_msg_in[1][0],cnu_msg_in[0][0]}),
	.sw_out_bit1 ({cnu_msg_in[84][1],cnu_msg_in[83][1],cnu_msg_in[82][1],cnu_msg_in[81][1],cnu_msg_in[80][1],cnu_msg_in[79][1],cnu_msg_in[78][1],cnu_msg_in[77][1],cnu_msg_in[76][1],cnu_msg_in[75][1],cnu_msg_in[74][1],cnu_msg_in[73][1],cnu_msg_in[72][1],cnu_msg_in[71][1],cnu_msg_in[70][1],cnu_msg_in[69][1],cnu_msg_in[68][1],cnu_msg_in[67][1],cnu_msg_in[66][1],cnu_msg_in[65][1],cnu_msg_in[64][1],cnu_msg_in[63][1],cnu_msg_in[62][1],cnu_msg_in[61][1],cnu_msg_in[60][1],cnu_msg_in[59][1],cnu_msg_in[58][1],cnu_msg_in[57][1],cnu_msg_in[56][1],cnu_msg_in[55][1],cnu_msg_in[54][1],cnu_msg_in[53][1],cnu_msg_in[52][1],cnu_msg_in[51][1],cnu_msg_in[50][1],cnu_msg_in[49][1],cnu_msg_in[48][1],cnu_msg_in[47][1],cnu_msg_in[46][1],cnu_msg_in[45][1],cnu_msg_in[44][1],cnu_msg_in[43][1],cnu_msg_in[42][1],cnu_msg_in[41][1],cnu_msg_in[40][1],cnu_msg_in[39][1],cnu_msg_in[38][1],cnu_msg_in[37][1],cnu_msg_in[36][1],cnu_msg_in[35][1],cnu_msg_in[34][1],cnu_msg_in[33][1],cnu_msg_in[32][1],cnu_msg_in[31][1],cnu_msg_in[30][1],cnu_msg_in[29][1],cnu_msg_in[28][1],cnu_msg_in[27][1],cnu_msg_in[26][1],cnu_msg_in[25][1],cnu_msg_in[24][1],cnu_msg_in[23][1],cnu_msg_in[22][1],cnu_msg_in[21][1],cnu_msg_in[20][1],cnu_msg_in[19][1],cnu_msg_in[18][1],cnu_msg_in[17][1],cnu_msg_in[16][1],cnu_msg_in[15][1],cnu_msg_in[14][1],cnu_msg_in[13][1],cnu_msg_in[12][1],cnu_msg_in[11][1],cnu_msg_in[10][1],cnu_msg_in[9][1],cnu_msg_in[8][1],cnu_msg_in[7][1],cnu_msg_in[6][1],cnu_msg_in[5][1],cnu_msg_in[4][1],cnu_msg_in[3][1],cnu_msg_in[2][1],cnu_msg_in[1][1],cnu_msg_in[0][1]}),
	.sw_out_bit2 ({cnu_msg_in[84][2],cnu_msg_in[83][2],cnu_msg_in[82][2],cnu_msg_in[81][2],cnu_msg_in[80][2],cnu_msg_in[79][2],cnu_msg_in[78][2],cnu_msg_in[77][2],cnu_msg_in[76][2],cnu_msg_in[75][2],cnu_msg_in[74][2],cnu_msg_in[73][2],cnu_msg_in[72][2],cnu_msg_in[71][2],cnu_msg_in[70][2],cnu_msg_in[69][2],cnu_msg_in[68][2],cnu_msg_in[67][2],cnu_msg_in[66][2],cnu_msg_in[65][2],cnu_msg_in[64][2],cnu_msg_in[63][2],cnu_msg_in[62][2],cnu_msg_in[61][2],cnu_msg_in[60][2],cnu_msg_in[59][2],cnu_msg_in[58][2],cnu_msg_in[57][2],cnu_msg_in[56][2],cnu_msg_in[55][2],cnu_msg_in[54][2],cnu_msg_in[53][2],cnu_msg_in[52][2],cnu_msg_in[51][2],cnu_msg_in[50][2],cnu_msg_in[49][2],cnu_msg_in[48][2],cnu_msg_in[47][2],cnu_msg_in[46][2],cnu_msg_in[45][2],cnu_msg_in[44][2],cnu_msg_in[43][2],cnu_msg_in[42][2],cnu_msg_in[41][2],cnu_msg_in[40][2],cnu_msg_in[39][2],cnu_msg_in[38][2],cnu_msg_in[37][2],cnu_msg_in[36][2],cnu_msg_in[35][2],cnu_msg_in[34][2],cnu_msg_in[33][2],cnu_msg_in[32][2],cnu_msg_in[31][2],cnu_msg_in[30][2],cnu_msg_in[29][2],cnu_msg_in[28][2],cnu_msg_in[27][2],cnu_msg_in[26][2],cnu_msg_in[25][2],cnu_msg_in[24][2],cnu_msg_in[23][2],cnu_msg_in[22][2],cnu_msg_in[21][2],cnu_msg_in[20][2],cnu_msg_in[19][2],cnu_msg_in[18][2],cnu_msg_in[17][2],cnu_msg_in[16][2],cnu_msg_in[15][2],cnu_msg_in[14][2],cnu_msg_in[13][2],cnu_msg_in[12][2],cnu_msg_in[11][2],cnu_msg_in[10][2],cnu_msg_in[9][2],cnu_msg_in[8][2],cnu_msg_in[7][2],cnu_msg_in[6][2],cnu_msg_in[5][2],cnu_msg_in[4][2],cnu_msg_in[3][2],cnu_msg_in[2][2],cnu_msg_in[1][2],cnu_msg_in[0][2]}),	
	.sw_out_bit3 ({cnu_msg_in[84][3],cnu_msg_in[83][3],cnu_msg_in[82][3],cnu_msg_in[81][3],cnu_msg_in[80][3],cnu_msg_in[79][3],cnu_msg_in[78][3],cnu_msg_in[77][3],cnu_msg_in[76][3],cnu_msg_in[75][3],cnu_msg_in[74][3],cnu_msg_in[73][3],cnu_msg_in[72][3],cnu_msg_in[71][3],cnu_msg_in[70][3],cnu_msg_in[69][3],cnu_msg_in[68][3],cnu_msg_in[67][3],cnu_msg_in[66][3],cnu_msg_in[65][3],cnu_msg_in[64][3],cnu_msg_in[63][3],cnu_msg_in[62][3],cnu_msg_in[61][3],cnu_msg_in[60][3],cnu_msg_in[59][3],cnu_msg_in[58][3],cnu_msg_in[57][3],cnu_msg_in[56][3],cnu_msg_in[55][3],cnu_msg_in[54][3],cnu_msg_in[53][3],cnu_msg_in[52][3],cnu_msg_in[51][3],cnu_msg_in[50][3],cnu_msg_in[49][3],cnu_msg_in[48][3],cnu_msg_in[47][3],cnu_msg_in[46][3],cnu_msg_in[45][3],cnu_msg_in[44][3],cnu_msg_in[43][3],cnu_msg_in[42][3],cnu_msg_in[41][3],cnu_msg_in[40][3],cnu_msg_in[39][3],cnu_msg_in[38][3],cnu_msg_in[37][3],cnu_msg_in[36][3],cnu_msg_in[35][3],cnu_msg_in[34][3],cnu_msg_in[33][3],cnu_msg_in[32][3],cnu_msg_in[31][3],cnu_msg_in[30][3],cnu_msg_in[29][3],cnu_msg_in[28][3],cnu_msg_in[27][3],cnu_msg_in[26][3],cnu_msg_in[25][3],cnu_msg_in[24][3],cnu_msg_in[23][3],cnu_msg_in[22][3],cnu_msg_in[21][3],cnu_msg_in[20][3],cnu_msg_in[19][3],cnu_msg_in[18][3],cnu_msg_in[17][3],cnu_msg_in[16][3],cnu_msg_in[15][3],cnu_msg_in[14][3],cnu_msg_in[13][3],cnu_msg_in[12][3],cnu_msg_in[11][3],cnu_msg_in[10][3],cnu_msg_in[9][3],cnu_msg_in[8][3],cnu_msg_in[7][3],cnu_msg_in[6][3],cnu_msg_in[5][3],cnu_msg_in[4][3],cnu_msg_in[3][3],cnu_msg_in[2][3],cnu_msg_in[1][3],cnu_msg_in[0][3]}),
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in_bit0  (cnu_bs_in_bit[0]),
	.sw_in_bit1  (cnu_bs_in_bit[1]),
	.sw_in_bit2  (cnu_bs_in_bit[2]),
	.sw_in_bit3  (cnu_bs_in_bit[3]),
	.left_sel    (cnu_left_sel),
	.right_sel   (cnu_right_sel),
	.merge_sel   (cnu_merge_sel)
);
qsn_controller_85b #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) cnu_qsn_controller_85b (
	.left_sel     (cnu_left_sel ),
	.right_sel    (cnu_right_sel),
	.merge_sel    (cnu_merge_sel),
	.shift_factor (c2v_shift_factor_cur_0), // offset shift factor of submatrix_1
	.rstn         (rstn),
	.sys_clk      (read_clk)
);
/*----------------------------------------------*/
// Circular shifter of variable nodes 
wire [BITWIDTH_SHIFT_FACTOR-1:0] vnu_shift_factorIn;
wire [BITWIDTH_SHIFT_FACTOR-1:0] dnu_inRotate_shift_factor; // a constant, because only needed at last layer
shared_qsn_top_85b #(
		.QUAN_SIZE(QUAN_SIZE),
		.CHECK_PARALLELISM(CHECK_PARALLELISM),
		.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR)
) inst_shared_qsn_top_85b (
	.sw_out_bit0 ({vnu_msg_in[84][0],vnu_msg_in[83][0],vnu_msg_in[82][0],vnu_msg_in[81][0],vnu_msg_in[80][0],vnu_msg_in[79][0],vnu_msg_in[78][0],vnu_msg_in[77][0],vnu_msg_in[76][0],vnu_msg_in[75][0],vnu_msg_in[74][0],vnu_msg_in[73][0],vnu_msg_in[72][0],vnu_msg_in[71][0],vnu_msg_in[70][0],vnu_msg_in[69][0],vnu_msg_in[68][0],vnu_msg_in[67][0],vnu_msg_in[66][0],vnu_msg_in[65][0],vnu_msg_in[64][0],vnu_msg_in[63][0],vnu_msg_in[62][0],vnu_msg_in[61][0],vnu_msg_in[60][0],vnu_msg_in[59][0],vnu_msg_in[58][0],vnu_msg_in[57][0],vnu_msg_in[56][0],vnu_msg_in[55][0],vnu_msg_in[54][0],vnu_msg_in[53][0],vnu_msg_in[52][0],vnu_msg_in[51][0],vnu_msg_in[50][0],vnu_msg_in[49][0],vnu_msg_in[48][0],vnu_msg_in[47][0],vnu_msg_in[46][0],vnu_msg_in[45][0],vnu_msg_in[44][0],vnu_msg_in[43][0],vnu_msg_in[42][0],vnu_msg_in[41][0],vnu_msg_in[40][0],vnu_msg_in[39][0],vnu_msg_in[38][0],vnu_msg_in[37][0],vnu_msg_in[36][0],vnu_msg_in[35][0],vnu_msg_in[34][0],vnu_msg_in[33][0],vnu_msg_in[32][0],vnu_msg_in[31][0],vnu_msg_in[30][0],vnu_msg_in[29][0],vnu_msg_in[28][0],vnu_msg_in[27][0],vnu_msg_in[26][0],vnu_msg_in[25][0],vnu_msg_in[24][0],vnu_msg_in[23][0],vnu_msg_in[22][0],vnu_msg_in[21][0],vnu_msg_in[20][0],vnu_msg_in[19][0],vnu_msg_in[18][0],vnu_msg_in[17][0],vnu_msg_in[16][0],vnu_msg_in[15][0],vnu_msg_in[14][0],vnu_msg_in[13][0],vnu_msg_in[12][0],vnu_msg_in[11][0],vnu_msg_in[10][0],vnu_msg_in[9][0],vnu_msg_in[8][0],vnu_msg_in[7][0],vnu_msg_in[6][0],vnu_msg_in[5][0],vnu_msg_in[4][0],vnu_msg_in[3][0],vnu_msg_in[2][0],vnu_msg_in[1][0],vnu_msg_in[0][0]}),	
	.sw_out_bit1 ({vnu_msg_in[84][1],vnu_msg_in[83][1],vnu_msg_in[82][1],vnu_msg_in[81][1],vnu_msg_in[80][1],vnu_msg_in[79][1],vnu_msg_in[78][1],vnu_msg_in[77][1],vnu_msg_in[76][1],vnu_msg_in[75][1],vnu_msg_in[74][1],vnu_msg_in[73][1],vnu_msg_in[72][1],vnu_msg_in[71][1],vnu_msg_in[70][1],vnu_msg_in[69][1],vnu_msg_in[68][1],vnu_msg_in[67][1],vnu_msg_in[66][1],vnu_msg_in[65][1],vnu_msg_in[64][1],vnu_msg_in[63][1],vnu_msg_in[62][1],vnu_msg_in[61][1],vnu_msg_in[60][1],vnu_msg_in[59][1],vnu_msg_in[58][1],vnu_msg_in[57][1],vnu_msg_in[56][1],vnu_msg_in[55][1],vnu_msg_in[54][1],vnu_msg_in[53][1],vnu_msg_in[52][1],vnu_msg_in[51][1],vnu_msg_in[50][1],vnu_msg_in[49][1],vnu_msg_in[48][1],vnu_msg_in[47][1],vnu_msg_in[46][1],vnu_msg_in[45][1],vnu_msg_in[44][1],vnu_msg_in[43][1],vnu_msg_in[42][1],vnu_msg_in[41][1],vnu_msg_in[40][1],vnu_msg_in[39][1],vnu_msg_in[38][1],vnu_msg_in[37][1],vnu_msg_in[36][1],vnu_msg_in[35][1],vnu_msg_in[34][1],vnu_msg_in[33][1],vnu_msg_in[32][1],vnu_msg_in[31][1],vnu_msg_in[30][1],vnu_msg_in[29][1],vnu_msg_in[28][1],vnu_msg_in[27][1],vnu_msg_in[26][1],vnu_msg_in[25][1],vnu_msg_in[24][1],vnu_msg_in[23][1],vnu_msg_in[22][1],vnu_msg_in[21][1],vnu_msg_in[20][1],vnu_msg_in[19][1],vnu_msg_in[18][1],vnu_msg_in[17][1],vnu_msg_in[16][1],vnu_msg_in[15][1],vnu_msg_in[14][1],vnu_msg_in[13][1],vnu_msg_in[12][1],vnu_msg_in[11][1],vnu_msg_in[10][1],vnu_msg_in[9][1],vnu_msg_in[8][1],vnu_msg_in[7][1],vnu_msg_in[6][1],vnu_msg_in[5][1],vnu_msg_in[4][1],vnu_msg_in[3][1],vnu_msg_in[2][1],vnu_msg_in[1][1],vnu_msg_in[0][1]}),	
	.sw_out_bit2 ({vnu_msg_in[84][2],vnu_msg_in[83][2],vnu_msg_in[82][2],vnu_msg_in[81][2],vnu_msg_in[80][2],vnu_msg_in[79][2],vnu_msg_in[78][2],vnu_msg_in[77][2],vnu_msg_in[76][2],vnu_msg_in[75][2],vnu_msg_in[74][2],vnu_msg_in[73][2],vnu_msg_in[72][2],vnu_msg_in[71][2],vnu_msg_in[70][2],vnu_msg_in[69][2],vnu_msg_in[68][2],vnu_msg_in[67][2],vnu_msg_in[66][2],vnu_msg_in[65][2],vnu_msg_in[64][2],vnu_msg_in[63][2],vnu_msg_in[62][2],vnu_msg_in[61][2],vnu_msg_in[60][2],vnu_msg_in[59][2],vnu_msg_in[58][2],vnu_msg_in[57][2],vnu_msg_in[56][2],vnu_msg_in[55][2],vnu_msg_in[54][2],vnu_msg_in[53][2],vnu_msg_in[52][2],vnu_msg_in[51][2],vnu_msg_in[50][2],vnu_msg_in[49][2],vnu_msg_in[48][2],vnu_msg_in[47][2],vnu_msg_in[46][2],vnu_msg_in[45][2],vnu_msg_in[44][2],vnu_msg_in[43][2],vnu_msg_in[42][2],vnu_msg_in[41][2],vnu_msg_in[40][2],vnu_msg_in[39][2],vnu_msg_in[38][2],vnu_msg_in[37][2],vnu_msg_in[36][2],vnu_msg_in[35][2],vnu_msg_in[34][2],vnu_msg_in[33][2],vnu_msg_in[32][2],vnu_msg_in[31][2],vnu_msg_in[30][2],vnu_msg_in[29][2],vnu_msg_in[28][2],vnu_msg_in[27][2],vnu_msg_in[26][2],vnu_msg_in[25][2],vnu_msg_in[24][2],vnu_msg_in[23][2],vnu_msg_in[22][2],vnu_msg_in[21][2],vnu_msg_in[20][2],vnu_msg_in[19][2],vnu_msg_in[18][2],vnu_msg_in[17][2],vnu_msg_in[16][2],vnu_msg_in[15][2],vnu_msg_in[14][2],vnu_msg_in[13][2],vnu_msg_in[12][2],vnu_msg_in[11][2],vnu_msg_in[10][2],vnu_msg_in[9][2],vnu_msg_in[8][2],vnu_msg_in[7][2],vnu_msg_in[6][2],vnu_msg_in[5][2],vnu_msg_in[4][2],vnu_msg_in[3][2],vnu_msg_in[2][2],vnu_msg_in[1][2],vnu_msg_in[0][2]}),	
	.sw_out_bit3 ({vnu_msg_in[84][3],vnu_msg_in[83][3],vnu_msg_in[82][3],vnu_msg_in[81][3],vnu_msg_in[80][3],vnu_msg_in[79][3],vnu_msg_in[78][3],vnu_msg_in[77][3],vnu_msg_in[76][3],vnu_msg_in[75][3],vnu_msg_in[74][3],vnu_msg_in[73][3],vnu_msg_in[72][3],vnu_msg_in[71][3],vnu_msg_in[70][3],vnu_msg_in[69][3],vnu_msg_in[68][3],vnu_msg_in[67][3],vnu_msg_in[66][3],vnu_msg_in[65][3],vnu_msg_in[64][3],vnu_msg_in[63][3],vnu_msg_in[62][3],vnu_msg_in[61][3],vnu_msg_in[60][3],vnu_msg_in[59][3],vnu_msg_in[58][3],vnu_msg_in[57][3],vnu_msg_in[56][3],vnu_msg_in[55][3],vnu_msg_in[54][3],vnu_msg_in[53][3],vnu_msg_in[52][3],vnu_msg_in[51][3],vnu_msg_in[50][3],vnu_msg_in[49][3],vnu_msg_in[48][3],vnu_msg_in[47][3],vnu_msg_in[46][3],vnu_msg_in[45][3],vnu_msg_in[44][3],vnu_msg_in[43][3],vnu_msg_in[42][3],vnu_msg_in[41][3],vnu_msg_in[40][3],vnu_msg_in[39][3],vnu_msg_in[38][3],vnu_msg_in[37][3],vnu_msg_in[36][3],vnu_msg_in[35][3],vnu_msg_in[34][3],vnu_msg_in[33][3],vnu_msg_in[32][3],vnu_msg_in[31][3],vnu_msg_in[30][3],vnu_msg_in[29][3],vnu_msg_in[28][3],vnu_msg_in[27][3],vnu_msg_in[26][3],vnu_msg_in[25][3],vnu_msg_in[24][3],vnu_msg_in[23][3],vnu_msg_in[22][3],vnu_msg_in[21][3],vnu_msg_in[20][3],vnu_msg_in[19][3],vnu_msg_in[18][3],vnu_msg_in[17][3],vnu_msg_in[16][3],vnu_msg_in[15][3],vnu_msg_in[14][3],vnu_msg_in[13][3],vnu_msg_in[12][3],vnu_msg_in[11][3],vnu_msg_in[10][3],vnu_msg_in[9][3],vnu_msg_in[8][3],vnu_msg_in[7][3],vnu_msg_in[6][3],vnu_msg_in[5][3],vnu_msg_in[4][3],vnu_msg_in[3][3],vnu_msg_in[2][3],vnu_msg_in[1][3],vnu_msg_in[0][3]}),	
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in0_bit0  (vnu_bs_in_bit[0]),
	.sw_in0_bit1  (vnu_bs_in_bit[1]),
	.sw_in0_bit2  (vnu_bs_in_bit[2]),
	.sw_in0_bit3  (vnu_bs_in_bit[3]),

	.sw_in1_bit0 (ch_bs_in_bit[0]),
	.sw_in1_bit1 (ch_bs_in_bit[1]),
	.sw_in1_bit2 (ch_bs_in_bit[2]),
	.sw_in1_bit3 (ch_bs_in_bit[3]),

	.sw_in2_bit0 (dnu_inRotate_bit),

	.shift_factor (vnu_shift_factorIn), // offset shift factor of submatrix
	.sw_in_bit0_src (vnu_bs_bit0_src),
	.sw_in_src (vnu_bs_src)
);
assign vnu_shift_factorIn = (vnu_bs_bit0_src[0] == 1'b1) ? v2c_shift_factor_cur_0 :
							(vnu_bs_bit0_src[1] == 1'b1) ? ch_ramRD_shift_factor_cur_0 :
							(vnu_bs_bit0_src[2] == 1'b1) ? dnu_inRotate_shift_factor : v2c_shift_factor_cur_0;
/*----------------------------------------------*/	
	reg [ADDR_WIDTH-1:0] c2v_mem_page_addr;
	reg [ADDR_WIDTH-1:0] v2c_mem_page_addr;
	mem_subsystem_top_submatrix_1 #(
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
		) inst_mem_subsystem_top_submatrix_1 (
			.mem_to_vnu_0     (mem_to_vnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_vnu_1     (mem_to_vnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_vnu_2     (mem_to_vnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_vnu_3     (mem_to_vnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_vnu_4     (mem_to_vnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_vnu_5     (mem_to_vnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_vnu_6     (mem_to_vnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_vnu_7     (mem_to_vnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_vnu_8     (mem_to_vnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_vnu_9     (mem_to_vnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_vnu_10    (mem_to_vnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_vnu_11    (mem_to_vnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_vnu_12    (mem_to_vnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_vnu_13    (mem_to_vnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_vnu_14    (mem_to_vnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_vnu_15    (mem_to_vnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_vnu_16    (mem_to_vnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_vnu_17    (mem_to_vnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_vnu_18    (mem_to_vnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_vnu_19    (mem_to_vnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_vnu_20    (mem_to_vnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_vnu_21    (mem_to_vnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_vnu_22    (mem_to_vnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_vnu_23    (mem_to_vnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_vnu_24    (mem_to_vnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_vnu_25    (mem_to_vnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_vnu_26    (mem_to_vnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_vnu_27    (mem_to_vnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_vnu_28    (mem_to_vnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_vnu_29    (mem_to_vnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_vnu_30    (mem_to_vnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_vnu_31    (mem_to_vnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_vnu_32    (mem_to_vnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_vnu_33    (mem_to_vnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_vnu_34    (mem_to_vnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_vnu_35    (mem_to_vnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_vnu_36    (mem_to_vnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_vnu_37    (mem_to_vnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_vnu_38    (mem_to_vnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_vnu_39    (mem_to_vnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_vnu_40    (mem_to_vnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_vnu_41    (mem_to_vnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_vnu_42    (mem_to_vnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_vnu_43    (mem_to_vnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_vnu_44    (mem_to_vnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_vnu_45    (mem_to_vnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_vnu_46    (mem_to_vnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_vnu_47    (mem_to_vnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_vnu_48    (mem_to_vnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_vnu_49    (mem_to_vnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_vnu_50    (mem_to_vnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_vnu_51    (mem_to_vnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_vnu_52    (mem_to_vnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_vnu_53    (mem_to_vnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_vnu_54    (mem_to_vnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_vnu_55    (mem_to_vnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_vnu_56    (mem_to_vnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_vnu_57    (mem_to_vnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_vnu_58    (mem_to_vnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_vnu_59    (mem_to_vnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_vnu_60    (mem_to_vnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_vnu_61    (mem_to_vnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_vnu_62    (mem_to_vnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_vnu_63    (mem_to_vnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_vnu_64    (mem_to_vnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_vnu_65    (mem_to_vnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_vnu_66    (mem_to_vnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_vnu_67    (mem_to_vnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_vnu_68    (mem_to_vnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_vnu_69    (mem_to_vnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_vnu_70    (mem_to_vnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_vnu_71    (mem_to_vnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_vnu_72    (mem_to_vnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_vnu_73    (mem_to_vnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_vnu_74    (mem_to_vnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_vnu_75    (mem_to_vnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_vnu_76    (mem_to_vnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_vnu_77    (mem_to_vnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_vnu_78    (mem_to_vnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_vnu_79    (mem_to_vnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_vnu_80    (mem_to_vnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_vnu_81    (mem_to_vnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_vnu_82    (mem_to_vnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_vnu_83    (mem_to_vnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_vnu_84    (mem_to_vnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),
			.mem_to_cnu_0     (mem_to_cnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_cnu_1     (mem_to_cnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_cnu_2     (mem_to_cnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_cnu_3     (mem_to_cnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_cnu_4     (mem_to_cnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_cnu_5     (mem_to_cnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_cnu_6     (mem_to_cnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_cnu_7     (mem_to_cnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_cnu_8     (mem_to_cnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_cnu_9     (mem_to_cnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_cnu_10    (mem_to_cnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_cnu_11    (mem_to_cnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_cnu_12    (mem_to_cnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_cnu_13    (mem_to_cnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_cnu_14    (mem_to_cnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_cnu_15    (mem_to_cnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_cnu_16    (mem_to_cnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_cnu_17    (mem_to_cnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_cnu_18    (mem_to_cnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_cnu_19    (mem_to_cnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_cnu_20    (mem_to_cnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_cnu_21    (mem_to_cnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_cnu_22    (mem_to_cnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_cnu_23    (mem_to_cnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_cnu_24    (mem_to_cnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_cnu_25    (mem_to_cnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_cnu_26    (mem_to_cnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_cnu_27    (mem_to_cnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_cnu_28    (mem_to_cnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_cnu_29    (mem_to_cnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_cnu_30    (mem_to_cnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_cnu_31    (mem_to_cnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_cnu_32    (mem_to_cnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_cnu_33    (mem_to_cnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_cnu_34    (mem_to_cnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_cnu_35    (mem_to_cnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_cnu_36    (mem_to_cnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_cnu_37    (mem_to_cnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_cnu_38    (mem_to_cnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_cnu_39    (mem_to_cnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_cnu_40    (mem_to_cnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_cnu_41    (mem_to_cnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_cnu_42    (mem_to_cnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_cnu_43    (mem_to_cnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_cnu_44    (mem_to_cnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_cnu_45    (mem_to_cnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_cnu_46    (mem_to_cnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_cnu_47    (mem_to_cnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_cnu_48    (mem_to_cnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_cnu_49    (mem_to_cnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_cnu_50    (mem_to_cnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_cnu_51    (mem_to_cnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_cnu_52    (mem_to_cnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_cnu_53    (mem_to_cnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_cnu_54    (mem_to_cnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_cnu_55    (mem_to_cnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_cnu_56    (mem_to_cnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_cnu_57    (mem_to_cnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_cnu_58    (mem_to_cnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_cnu_59    (mem_to_cnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_cnu_60    (mem_to_cnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_cnu_61    (mem_to_cnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_cnu_62    (mem_to_cnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_cnu_63    (mem_to_cnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_cnu_64    (mem_to_cnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_cnu_65    (mem_to_cnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_cnu_66    (mem_to_cnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_cnu_67    (mem_to_cnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_cnu_68    (mem_to_cnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_cnu_69    (mem_to_cnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_cnu_70    (mem_to_cnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_cnu_71    (mem_to_cnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_cnu_72    (mem_to_cnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_cnu_73    (mem_to_cnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_cnu_74    (mem_to_cnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_cnu_75    (mem_to_cnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_cnu_76    (mem_to_cnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_cnu_77    (mem_to_cnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_cnu_78    (mem_to_cnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_cnu_79    (mem_to_cnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_cnu_80    (mem_to_cnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_cnu_81    (mem_to_cnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_cnu_82    (mem_to_cnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_cnu_83    (mem_to_cnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_cnu_84    (mem_to_cnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),

			.vnu_to_mem_0     (vnu_msg_in[0 ]),
			.vnu_to_mem_1     (vnu_msg_in[1 ]),
			.vnu_to_mem_2     (vnu_msg_in[2 ]),
			.vnu_to_mem_3     (vnu_msg_in[3 ]),
			.vnu_to_mem_4     (vnu_msg_in[4 ]),
			.vnu_to_mem_5     (vnu_msg_in[5 ]),
			.vnu_to_mem_6     (vnu_msg_in[6 ]),
			.vnu_to_mem_7     (vnu_msg_in[7 ]),
			.vnu_to_mem_8     (vnu_msg_in[8 ]),
			.vnu_to_mem_9     (vnu_msg_in[9 ]),
			.vnu_to_mem_10    (vnu_msg_in[10]),
			.vnu_to_mem_11    (vnu_msg_in[11]),
			.vnu_to_mem_12    (vnu_msg_in[12]),
			.vnu_to_mem_13    (vnu_msg_in[13]),
			.vnu_to_mem_14    (vnu_msg_in[14]),
			.vnu_to_mem_15    (vnu_msg_in[15]),
			.vnu_to_mem_16    (vnu_msg_in[16]),
			.vnu_to_mem_17    (vnu_msg_in[17]),
			.vnu_to_mem_18    (vnu_msg_in[18]),
			.vnu_to_mem_19    (vnu_msg_in[19]),
			.vnu_to_mem_20    (vnu_msg_in[20]),
			.vnu_to_mem_21    (vnu_msg_in[21]),
			.vnu_to_mem_22    (vnu_msg_in[22]),
			.vnu_to_mem_23    (vnu_msg_in[23]),
			.vnu_to_mem_24    (vnu_msg_in[24]),
			.vnu_to_mem_25    (vnu_msg_in[25]),
			.vnu_to_mem_26    (vnu_msg_in[26]),
			.vnu_to_mem_27    (vnu_msg_in[27]),
			.vnu_to_mem_28    (vnu_msg_in[28]),
			.vnu_to_mem_29    (vnu_msg_in[29]),
			.vnu_to_mem_30    (vnu_msg_in[30]),
			.vnu_to_mem_31    (vnu_msg_in[31]),
			.vnu_to_mem_32    (vnu_msg_in[32]),
			.vnu_to_mem_33    (vnu_msg_in[33]),
			.vnu_to_mem_34    (vnu_msg_in[34]),
			.vnu_to_mem_35    (vnu_msg_in[35]),
			.vnu_to_mem_36    (vnu_msg_in[36]),
			.vnu_to_mem_37    (vnu_msg_in[37]),
			.vnu_to_mem_38    (vnu_msg_in[38]),
			.vnu_to_mem_39    (vnu_msg_in[39]),
			.vnu_to_mem_40    (vnu_msg_in[40]),
			.vnu_to_mem_41    (vnu_msg_in[41]),
			.vnu_to_mem_42    (vnu_msg_in[42]),
			.vnu_to_mem_43    (vnu_msg_in[43]),
			.vnu_to_mem_44    (vnu_msg_in[44]),
			.vnu_to_mem_45    (vnu_msg_in[45]),
			.vnu_to_mem_46    (vnu_msg_in[46]),
			.vnu_to_mem_47    (vnu_msg_in[47]),
			.vnu_to_mem_48    (vnu_msg_in[48]),
			.vnu_to_mem_49    (vnu_msg_in[49]),
			.vnu_to_mem_50    (vnu_msg_in[50]),
			.vnu_to_mem_51    (vnu_msg_in[51]),
			.vnu_to_mem_52    (vnu_msg_in[52]),
			.vnu_to_mem_53    (vnu_msg_in[53]),
			.vnu_to_mem_54    (vnu_msg_in[54]),
			.vnu_to_mem_55    (vnu_msg_in[55]),
			.vnu_to_mem_56    (vnu_msg_in[56]),
			.vnu_to_mem_57    (vnu_msg_in[57]),
			.vnu_to_mem_58    (vnu_msg_in[58]),
			.vnu_to_mem_59    (vnu_msg_in[59]),
			.vnu_to_mem_60    (vnu_msg_in[60]),
			.vnu_to_mem_61    (vnu_msg_in[61]),
			.vnu_to_mem_62    (vnu_msg_in[62]),
			.vnu_to_mem_63    (vnu_msg_in[63]),
			.vnu_to_mem_64    (vnu_msg_in[64]),
			.vnu_to_mem_65    (vnu_msg_in[65]),
			.vnu_to_mem_66    (vnu_msg_in[66]),
			.vnu_to_mem_67    (vnu_msg_in[67]),
			.vnu_to_mem_68    (vnu_msg_in[68]),
			.vnu_to_mem_69    (vnu_msg_in[69]),
			.vnu_to_mem_70    (vnu_msg_in[70]),
			.vnu_to_mem_71    (vnu_msg_in[71]),
			.vnu_to_mem_72    (vnu_msg_in[72]),
			.vnu_to_mem_73    (vnu_msg_in[73]),
			.vnu_to_mem_74    (vnu_msg_in[74]),
			.vnu_to_mem_75    (vnu_msg_in[75]),
			.vnu_to_mem_76    (vnu_msg_in[76]),
			.vnu_to_mem_77    (vnu_msg_in[77]),
			.vnu_to_mem_78    (vnu_msg_in[78]),
			.vnu_to_mem_79    (vnu_msg_in[79]),
			.vnu_to_mem_80    (vnu_msg_in[80]),
			.vnu_to_mem_81    (vnu_msg_in[81]),
			.vnu_to_mem_82    (vnu_msg_in[82]),
			.vnu_to_mem_83    (vnu_msg_in[83]),
			.vnu_to_mem_84    (vnu_msg_in[84]),
			.cnu_to_mem_0     (cnu_msg_in[0 ]),
			.cnu_to_mem_1     (cnu_msg_in[1 ]),
			.cnu_to_mem_2     (cnu_msg_in[2 ]),
			.cnu_to_mem_3     (cnu_msg_in[3 ]),
			.cnu_to_mem_4     (cnu_msg_in[4 ]),
			.cnu_to_mem_5     (cnu_msg_in[5 ]),
			.cnu_to_mem_6     (cnu_msg_in[6 ]),
			.cnu_to_mem_7     (cnu_msg_in[7 ]),
			.cnu_to_mem_8     (cnu_msg_in[8 ]),
			.cnu_to_mem_9     (cnu_msg_in[9 ]),
			.cnu_to_mem_10    (cnu_msg_in[10]),
			.cnu_to_mem_11    (cnu_msg_in[11]),
			.cnu_to_mem_12    (cnu_msg_in[12]),
			.cnu_to_mem_13    (cnu_msg_in[13]),
			.cnu_to_mem_14    (cnu_msg_in[14]),
			.cnu_to_mem_15    (cnu_msg_in[15]),
			.cnu_to_mem_16    (cnu_msg_in[16]),
			.cnu_to_mem_17    (cnu_msg_in[17]),
			.cnu_to_mem_18    (cnu_msg_in[18]),
			.cnu_to_mem_19    (cnu_msg_in[19]),
			.cnu_to_mem_20    (cnu_msg_in[20]),
			.cnu_to_mem_21    (cnu_msg_in[21]),
			.cnu_to_mem_22    (cnu_msg_in[22]),
			.cnu_to_mem_23    (cnu_msg_in[23]),
			.cnu_to_mem_24    (cnu_msg_in[24]),
			.cnu_to_mem_25    (cnu_msg_in[25]),
			.cnu_to_mem_26    (cnu_msg_in[26]),
			.cnu_to_mem_27    (cnu_msg_in[27]),
			.cnu_to_mem_28    (cnu_msg_in[28]),
			.cnu_to_mem_29    (cnu_msg_in[29]),
			.cnu_to_mem_30    (cnu_msg_in[30]),
			.cnu_to_mem_31    (cnu_msg_in[31]),
			.cnu_to_mem_32    (cnu_msg_in[32]),
			.cnu_to_mem_33    (cnu_msg_in[33]),
			.cnu_to_mem_34    (cnu_msg_in[34]),
			.cnu_to_mem_35    (cnu_msg_in[35]),
			.cnu_to_mem_36    (cnu_msg_in[36]),
			.cnu_to_mem_37    (cnu_msg_in[37]),
			.cnu_to_mem_38    (cnu_msg_in[38]),
			.cnu_to_mem_39    (cnu_msg_in[39]),
			.cnu_to_mem_40    (cnu_msg_in[40]),
			.cnu_to_mem_41    (cnu_msg_in[41]),
			.cnu_to_mem_42    (cnu_msg_in[42]),
			.cnu_to_mem_43    (cnu_msg_in[43]),
			.cnu_to_mem_44    (cnu_msg_in[44]),
			.cnu_to_mem_45    (cnu_msg_in[45]),
			.cnu_to_mem_46    (cnu_msg_in[46]),
			.cnu_to_mem_47    (cnu_msg_in[47]),
			.cnu_to_mem_48    (cnu_msg_in[48]),
			.cnu_to_mem_49    (cnu_msg_in[49]),
			.cnu_to_mem_50    (cnu_msg_in[50]),
			.cnu_to_mem_51    (cnu_msg_in[51]),
			.cnu_to_mem_52    (cnu_msg_in[52]),
			.cnu_to_mem_53    (cnu_msg_in[53]),
			.cnu_to_mem_54    (cnu_msg_in[54]),
			.cnu_to_mem_55    (cnu_msg_in[55]),
			.cnu_to_mem_56    (cnu_msg_in[56]),
			.cnu_to_mem_57    (cnu_msg_in[57]),
			.cnu_to_mem_58    (cnu_msg_in[58]),
			.cnu_to_mem_59    (cnu_msg_in[59]),
			.cnu_to_mem_60    (cnu_msg_in[60]),
			.cnu_to_mem_61    (cnu_msg_in[61]),
			.cnu_to_mem_62    (cnu_msg_in[62]),
			.cnu_to_mem_63    (cnu_msg_in[63]),
			.cnu_to_mem_64    (cnu_msg_in[64]),
			.cnu_to_mem_65    (cnu_msg_in[65]),
			.cnu_to_mem_66    (cnu_msg_in[66]),
			.cnu_to_mem_67    (cnu_msg_in[67]),
			.cnu_to_mem_68    (cnu_msg_in[68]),
			.cnu_to_mem_69    (cnu_msg_in[69]),
			.cnu_to_mem_70    (cnu_msg_in[70]),
			.cnu_to_mem_71    (cnu_msg_in[71]),
			.cnu_to_mem_72    (cnu_msg_in[72]),
			.cnu_to_mem_73    (cnu_msg_in[73]),
			.cnu_to_mem_74    (cnu_msg_in[74]),
			.cnu_to_mem_75    (cnu_msg_in[75]),
			.cnu_to_mem_76    (cnu_msg_in[76]),
			.cnu_to_mem_77    (cnu_msg_in[77]),
			.cnu_to_mem_78    (cnu_msg_in[78]),
			.cnu_to_mem_79    (cnu_msg_in[79]),
			.cnu_to_mem_80    (cnu_msg_in[80]),
			.cnu_to_mem_81    (cnu_msg_in[81]),
			.cnu_to_mem_82    (cnu_msg_in[82]),
			.cnu_to_mem_83    (cnu_msg_in[83]),
			.cnu_to_mem_84    (cnu_msg_in[84]),
			.cnu_sync_addr    (cnu_mem_page_sync_addr),
			.vnu_sync_addr    (vnu_mem_page_sync_addr),
			.cnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.vnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.last_row_chunk   ({c2v_last_row_chunk, v2c_last_row_chunk}),
			.we               ({v2c_mem_we, c2v_mem_we}),
			.sys_clk          (read_clk),
			.rstn             (rstn)
		);
		assign cnu_mem_page_sync_addr = (v2c_mem_fetch == 1'b1) ? v2c_mem_page_rd_addr : 
										(c2v_mem_we == 1'b1) ? c2v_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.

		assign vnu_mem_page_sync_addr = (c2v_mem_fetch == 1'b1) ? c2v_mem_page_rd_addr : 
										(v2c_mem_we == 1'b1) ? v2c_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Check-to-Variable messages RAMs write-page addresses
	always @(posedge read_clk) begin
		if(rstn == 1'b0) 
			c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE;
		else if(c2v_mem_we == 1'b1) begin
			// page increment pattern within layer 0
			if(v2c_layer_cnt[0] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_1+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 1
			if(v2c_layer_cnt[1] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_2+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 2
			if(v2c_layer_cnt[2] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_2-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
		end
	end

	always @(posedge read_clk) begin
		if(rstn == 1'b0) begin
			c2v_shift_factor_cur_2 <= shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
		end
		else if(c2v_bs_en == 1'b1) begin
			c2v_shift_factor_cur_2 <= 0;
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
/*--------------------------------------------------------------------------*/
// Channel Buffers
reg [CH_DATA_WIDTH-1:0] ch_msg_genIn;
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_0 [0:CHECK_PARALLELISM-1]; // [0:84]
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_1 [0:CHECK_PARALLELISM-1]; // [0:84]
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_rd_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chInit_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chLayer_wr_addr;
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

			.din        (ch_msg_genIn[CH_DATA_WIDTH-1:0]),

			.read_addr  (submatrix_ch_ram_rd_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.write_addr (submatrix_ch_ram_wr_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.we         (ch_ram_we),
			.read_clk   (ch_ram_rd_clk),
			.write_clk  (ch_ram_wr_clk),
			.rstn       (rstn)
		);
		// Updating the Channel RAMs by either initally channel messages (from AWGNs) or circularly shifted channel messages
		assign submatrix_ch_ram_wr_addr = (ch_ram_init_we == 1'b1) ? submatrix_chInit_wr_addr :
														(ch_ram_wb == 1'b1     ) ? submatrix_chLayer_wr_addr : 
																				   CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.


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
	// Channel messages RAMs write-page addresses
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
endmodule

module msg_pass_submatrix_2_unit #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,
	parameter VN_DEGREE = 3,   // degree of one variable node
/*-------------------------------------------------------------------------------------*/
	// Parameters related to BS, PA and MEM
	parameter RAM_DEPTH = 1024,
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH),
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1),
	parameter shift_factor_0 = CHECK_PARALLELISM-9,
	parameter shift_factor_1 = CHECK_PARALLELISM-21,
	parameter shift_factor_2 = CHECK_PARALLELISM-30,

`ifdef SCHED_4_6
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,
	parameter C2V_MEM_ADDR_BASE = 0,
	parameter V2C_MEM_ADDR_BASE = ROW_CHUNK_NUM,
	parameter V2C_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter C2V_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH),
`endif
	parameter START_PAGE_1_0 = 2, // starting page address of layer 0 of submatrix_1
	parameter START_PAGE_1_1 = 8, // starting page address of layer 1 of submatrix_1
	parameter START_PAGE_1_2 = 1  // starting page address of layer 2 of submatrix_1
) (
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu,

	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit,

	// control signals
	input wire c2v_bs_en,
	input wire v2c_bs_en,
	input wire ch_bs_en,
	/*------------------------------*/
	// Control signals associative with message passing of channel buffer and DNU.SignExtension
	input wire ch_ram_init_we,
	input wire ch_ram_fetch,
	input wire v2c_outRotate_reg_we,
	input wire dnu_inRotate_bs_en,
	input wire dnu_inRotate_pa_en,
	input wire dnu_inRotate_wb,
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
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,

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
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_2;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_2;
wire [6:0]  cnu_left_sel;
wire [6:0]  cnu_right_sel;
wire [83:0] cnu_merge_sel;
wire [6:0]  vnu_left_sel;
wire [6:0]  vnu_right_sel;
wire [83:0] vnu_merge_sel;
wire [CHECK_PARALLELISM-1:0] cnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] vnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] ch_bs_in_bit [0:QUAN_SIZE-1];
genvar bit_index;
generate
	for(bit_index=0;bit_index<QUAN_SIZE;bit_index=bit_index+1) begin : extrinsic_msg_bs_in_inst
		assign cnu_bs_in_bit[bit_index] = {c2v_bs_in[QUAN_SIZE*84+bit_index],c2v_bs_in[QUAN_SIZE*83+bit_index],c2v_bs_in[QUAN_SIZE*82+bit_index],c2v_bs_in[QUAN_SIZE*81+bit_index],c2v_bs_in[QUAN_SIZE*80+bit_index],c2v_bs_in[QUAN_SIZE*79+bit_index],c2v_bs_in[QUAN_SIZE*78+bit_index],c2v_bs_in[QUAN_SIZE*77+bit_index],c2v_bs_in[QUAN_SIZE*76+bit_index],c2v_bs_in[QUAN_SIZE*75+bit_index],c2v_bs_in[QUAN_SIZE*74+bit_index],c2v_bs_in[QUAN_SIZE*73+bit_index],c2v_bs_in[QUAN_SIZE*72+bit_index],c2v_bs_in[QUAN_SIZE*71+bit_index],c2v_bs_in[QUAN_SIZE*70+bit_index],c2v_bs_in[QUAN_SIZE*69+bit_index],c2v_bs_in[QUAN_SIZE*68+bit_index],c2v_bs_in[QUAN_SIZE*67+bit_index],c2v_bs_in[QUAN_SIZE*66+bit_index],c2v_bs_in[QUAN_SIZE*65+bit_index],c2v_bs_in[QUAN_SIZE*64+bit_index],c2v_bs_in[QUAN_SIZE*63+bit_index],c2v_bs_in[QUAN_SIZE*62+bit_index],c2v_bs_in[QUAN_SIZE*61+bit_index],c2v_bs_in[QUAN_SIZE*60+bit_index],c2v_bs_in[QUAN_SIZE*59+bit_index],c2v_bs_in[QUAN_SIZE*58+bit_index],c2v_bs_in[QUAN_SIZE*57+bit_index],c2v_bs_in[QUAN_SIZE*56+bit_index],c2v_bs_in[QUAN_SIZE*55+bit_index],c2v_bs_in[QUAN_SIZE*54+bit_index],c2v_bs_in[QUAN_SIZE*53+bit_index],c2v_bs_in[QUAN_SIZE*52+bit_index],c2v_bs_in[QUAN_SIZE*51+bit_index],c2v_bs_in[QUAN_SIZE*50+bit_index],c2v_bs_in[QUAN_SIZE*49+bit_index],c2v_bs_in[QUAN_SIZE*48+bit_index],c2v_bs_in[QUAN_SIZE*47+bit_index],c2v_bs_in[QUAN_SIZE*46+bit_index],c2v_bs_in[QUAN_SIZE*45+bit_index],c2v_bs_in[QUAN_SIZE*44+bit_index],c2v_bs_in[QUAN_SIZE*43+bit_index],c2v_bs_in[QUAN_SIZE*42+bit_index],c2v_bs_in[QUAN_SIZE*41+bit_index],c2v_bs_in[QUAN_SIZE*40+bit_index],c2v_bs_in[QUAN_SIZE*39+bit_index],c2v_bs_in[QUAN_SIZE*38+bit_index],c2v_bs_in[QUAN_SIZE*37+bit_index],c2v_bs_in[QUAN_SIZE*36+bit_index],c2v_bs_in[QUAN_SIZE*35+bit_index],c2v_bs_in[QUAN_SIZE*34+bit_index],c2v_bs_in[QUAN_SIZE*33+bit_index],c2v_bs_in[QUAN_SIZE*32+bit_index],c2v_bs_in[QUAN_SIZE*31+bit_index],c2v_bs_in[QUAN_SIZE*30+bit_index],c2v_bs_in[QUAN_SIZE*29+bit_index],c2v_bs_in[QUAN_SIZE*28+bit_index],c2v_bs_in[QUAN_SIZE*27+bit_index],c2v_bs_in[QUAN_SIZE*26+bit_index],c2v_bs_in[QUAN_SIZE*25+bit_index],c2v_bs_in[QUAN_SIZE*24+bit_index],c2v_bs_in[QUAN_SIZE*23+bit_index],c2v_bs_in[QUAN_SIZE*22+bit_index],c2v_bs_in[QUAN_SIZE*21+bit_index],c2v_bs_in[QUAN_SIZE*20+bit_index],c2v_bs_in[QUAN_SIZE*19+bit_index],c2v_bs_in[QUAN_SIZE*18+bit_index],c2v_bs_in[QUAN_SIZE*17+bit_index],c2v_bs_in[QUAN_SIZE*16+bit_index],c2v_bs_in[QUAN_SIZE*15+bit_index],c2v_bs_in[QUAN_SIZE*14+bit_index],c2v_bs_in[QUAN_SIZE*13+bit_index],c2v_bs_in[QUAN_SIZE*12+bit_index],c2v_bs_in[QUAN_SIZE*11+bit_index],c2v_bs_in[QUAN_SIZE*10+bit_index],c2v_bs_in[QUAN_SIZE*9+bit_index],c2v_bs_in[QUAN_SIZE*8+bit_index],c2v_bs_in[QUAN_SIZE*7+bit_index],c2v_bs_in[QUAN_SIZE*6+bit_index],c2v_bs_in[QUAN_SIZE*5+bit_index],c2v_bs_in[QUAN_SIZE*4+bit_index],c2v_bs_in[QUAN_SIZE*3+bit_index],c2v_bs_in[QUAN_SIZE*2+bit_index],c2v_bs_in[QUAN_SIZE*1+bit_index],c2v_bs_in[QUAN_SIZE*0+bit_index]};
		assign vnu_bs_in_bit[bit_index] = {v2c_bs_in[QUAN_SIZE*84+bit_index],v2c_bs_in[QUAN_SIZE*83+bit_index],v2c_bs_in[QUAN_SIZE*82+bit_index],v2c_bs_in[QUAN_SIZE*81+bit_index],v2c_bs_in[QUAN_SIZE*80+bit_index],v2c_bs_in[QUAN_SIZE*79+bit_index],v2c_bs_in[QUAN_SIZE*78+bit_index],v2c_bs_in[QUAN_SIZE*77+bit_index],v2c_bs_in[QUAN_SIZE*76+bit_index],v2c_bs_in[QUAN_SIZE*75+bit_index],v2c_bs_in[QUAN_SIZE*74+bit_index],v2c_bs_in[QUAN_SIZE*73+bit_index],v2c_bs_in[QUAN_SIZE*72+bit_index],v2c_bs_in[QUAN_SIZE*71+bit_index],v2c_bs_in[QUAN_SIZE*70+bit_index],v2c_bs_in[QUAN_SIZE*69+bit_index],v2c_bs_in[QUAN_SIZE*68+bit_index],v2c_bs_in[QUAN_SIZE*67+bit_index],v2c_bs_in[QUAN_SIZE*66+bit_index],v2c_bs_in[QUAN_SIZE*65+bit_index],v2c_bs_in[QUAN_SIZE*64+bit_index],v2c_bs_in[QUAN_SIZE*63+bit_index],v2c_bs_in[QUAN_SIZE*62+bit_index],v2c_bs_in[QUAN_SIZE*61+bit_index],v2c_bs_in[QUAN_SIZE*60+bit_index],v2c_bs_in[QUAN_SIZE*59+bit_index],v2c_bs_in[QUAN_SIZE*58+bit_index],v2c_bs_in[QUAN_SIZE*57+bit_index],v2c_bs_in[QUAN_SIZE*56+bit_index],v2c_bs_in[QUAN_SIZE*55+bit_index],v2c_bs_in[QUAN_SIZE*54+bit_index],v2c_bs_in[QUAN_SIZE*53+bit_index],v2c_bs_in[QUAN_SIZE*52+bit_index],v2c_bs_in[QUAN_SIZE*51+bit_index],v2c_bs_in[QUAN_SIZE*50+bit_index],v2c_bs_in[QUAN_SIZE*49+bit_index],v2c_bs_in[QUAN_SIZE*48+bit_index],v2c_bs_in[QUAN_SIZE*47+bit_index],v2c_bs_in[QUAN_SIZE*46+bit_index],v2c_bs_in[QUAN_SIZE*45+bit_index],v2c_bs_in[QUAN_SIZE*44+bit_index],v2c_bs_in[QUAN_SIZE*43+bit_index],v2c_bs_in[QUAN_SIZE*42+bit_index],v2c_bs_in[QUAN_SIZE*41+bit_index],v2c_bs_in[QUAN_SIZE*40+bit_index],v2c_bs_in[QUAN_SIZE*39+bit_index],v2c_bs_in[QUAN_SIZE*38+bit_index],v2c_bs_in[QUAN_SIZE*37+bit_index],v2c_bs_in[QUAN_SIZE*36+bit_index],v2c_bs_in[QUAN_SIZE*35+bit_index],v2c_bs_in[QUAN_SIZE*34+bit_index],v2c_bs_in[QUAN_SIZE*33+bit_index],v2c_bs_in[QUAN_SIZE*32+bit_index],v2c_bs_in[QUAN_SIZE*31+bit_index],v2c_bs_in[QUAN_SIZE*30+bit_index],v2c_bs_in[QUAN_SIZE*29+bit_index],v2c_bs_in[QUAN_SIZE*28+bit_index],v2c_bs_in[QUAN_SIZE*27+bit_index],v2c_bs_in[QUAN_SIZE*26+bit_index],v2c_bs_in[QUAN_SIZE*25+bit_index],v2c_bs_in[QUAN_SIZE*24+bit_index],v2c_bs_in[QUAN_SIZE*23+bit_index],v2c_bs_in[QUAN_SIZE*22+bit_index],v2c_bs_in[QUAN_SIZE*21+bit_index],v2c_bs_in[QUAN_SIZE*20+bit_index],v2c_bs_in[QUAN_SIZE*19+bit_index],v2c_bs_in[QUAN_SIZE*18+bit_index],v2c_bs_in[QUAN_SIZE*17+bit_index],v2c_bs_in[QUAN_SIZE*16+bit_index],v2c_bs_in[QUAN_SIZE*15+bit_index],v2c_bs_in[QUAN_SIZE*14+bit_index],v2c_bs_in[QUAN_SIZE*13+bit_index],v2c_bs_in[QUAN_SIZE*12+bit_index],v2c_bs_in[QUAN_SIZE*11+bit_index],v2c_bs_in[QUAN_SIZE*10+bit_index],v2c_bs_in[QUAN_SIZE*9+bit_index],v2c_bs_in[QUAN_SIZE*8+bit_index],v2c_bs_in[QUAN_SIZE*7+bit_index],v2c_bs_in[QUAN_SIZE*6+bit_index],v2c_bs_in[QUAN_SIZE*5+bit_index],v2c_bs_in[QUAN_SIZE*4+bit_index],v2c_bs_in[QUAN_SIZE*3+bit_index],v2c_bs_in[QUAN_SIZE*2+bit_index],v2c_bs_in[QUAN_SIZE*1+bit_index],v2c_bs_in[QUAN_SIZE*0+bit_index]};
		assign ch_bs_in_bit[bit_index]  = { ch_bs_in[QUAN_SIZE*84+bit_index], ch_bs_in[QUAN_SIZE*83+bit_index], ch_bs_in[QUAN_SIZE*82+bit_index], ch_bs_in[QUAN_SIZE*81+bit_index], ch_bs_in[QUAN_SIZE*80+bit_index], ch_bs_in[QUAN_SIZE*79+bit_index], ch_bs_in[QUAN_SIZE*78+bit_index], ch_bs_in[QUAN_SIZE*77+bit_index], ch_bs_in[QUAN_SIZE*76+bit_index], ch_bs_in[QUAN_SIZE*75+bit_index], ch_bs_in[QUAN_SIZE*74+bit_index], ch_bs_in[QUAN_SIZE*73+bit_index], ch_bs_in[QUAN_SIZE*72+bit_index], ch_bs_in[QUAN_SIZE*71+bit_index], ch_bs_in[QUAN_SIZE*70+bit_index], ch_bs_in[QUAN_SIZE*69+bit_index], ch_bs_in[QUAN_SIZE*68+bit_index], ch_bs_in[QUAN_SIZE*67+bit_index], ch_bs_in[QUAN_SIZE*66+bit_index], ch_bs_in[QUAN_SIZE*65+bit_index], ch_bs_in[QUAN_SIZE*64+bit_index], ch_bs_in[QUAN_SIZE*63+bit_index], ch_bs_in[QUAN_SIZE*62+bit_index], ch_bs_in[QUAN_SIZE*61+bit_index], ch_bs_in[QUAN_SIZE*60+bit_index], ch_bs_in[QUAN_SIZE*59+bit_index], ch_bs_in[QUAN_SIZE*58+bit_index], ch_bs_in[QUAN_SIZE*57+bit_index], ch_bs_in[QUAN_SIZE*56+bit_index], ch_bs_in[QUAN_SIZE*55+bit_index], ch_bs_in[QUAN_SIZE*54+bit_index], ch_bs_in[QUAN_SIZE*53+bit_index], ch_bs_in[QUAN_SIZE*52+bit_index], ch_bs_in[QUAN_SIZE*51+bit_index], ch_bs_in[QUAN_SIZE*50+bit_index], ch_bs_in[QUAN_SIZE*49+bit_index], ch_bs_in[QUAN_SIZE*48+bit_index], ch_bs_in[QUAN_SIZE*47+bit_index], ch_bs_in[QUAN_SIZE*46+bit_index], ch_bs_in[QUAN_SIZE*45+bit_index], ch_bs_in[QUAN_SIZE*44+bit_index], ch_bs_in[QUAN_SIZE*43+bit_index], ch_bs_in[QUAN_SIZE*42+bit_index], ch_bs_in[QUAN_SIZE*41+bit_index], ch_bs_in[QUAN_SIZE*40+bit_index], ch_bs_in[QUAN_SIZE*39+bit_index], ch_bs_in[QUAN_SIZE*38+bit_index], ch_bs_in[QUAN_SIZE*37+bit_index], ch_bs_in[QUAN_SIZE*36+bit_index], ch_bs_in[QUAN_SIZE*35+bit_index], ch_bs_in[QUAN_SIZE*34+bit_index], ch_bs_in[QUAN_SIZE*33+bit_index], ch_bs_in[QUAN_SIZE*32+bit_index], ch_bs_in[QUAN_SIZE*31+bit_index], ch_bs_in[QUAN_SIZE*30+bit_index], ch_bs_in[QUAN_SIZE*29+bit_index], ch_bs_in[QUAN_SIZE*28+bit_index], ch_bs_in[QUAN_SIZE*27+bit_index], ch_bs_in[QUAN_SIZE*26+bit_index], ch_bs_in[QUAN_SIZE*25+bit_index], ch_bs_in[QUAN_SIZE*24+bit_index], ch_bs_in[QUAN_SIZE*23+bit_index], ch_bs_in[QUAN_SIZE*22+bit_index], ch_bs_in[QUAN_SIZE*21+bit_index], ch_bs_in[QUAN_SIZE*20+bit_index], ch_bs_in[QUAN_SIZE*19+bit_index], ch_bs_in[QUAN_SIZE*18+bit_index], ch_bs_in[QUAN_SIZE*17+bit_index], ch_bs_in[QUAN_SIZE*16+bit_index], ch_bs_in[QUAN_SIZE*15+bit_index], ch_bs_in[QUAN_SIZE*14+bit_index], ch_bs_in[QUAN_SIZE*13+bit_index], ch_bs_in[QUAN_SIZE*12+bit_index], ch_bs_in[QUAN_SIZE*11+bit_index], ch_bs_in[QUAN_SIZE*10+bit_index], ch_bs_in[QUAN_SIZE*9+bit_index], ch_bs_in[QUAN_SIZE*8+bit_index], ch_bs_in[QUAN_SIZE*7+bit_index], ch_bs_in[QUAN_SIZE*6+bit_index], ch_bs_in[QUAN_SIZE*5+bit_index], ch_bs_in[QUAN_SIZE*4+bit_index], ch_bs_in[QUAN_SIZE*3+bit_index], ch_bs_in[QUAN_SIZE*2+bit_index],ch_bs_in[QUAN_SIZE*1+bit_index], ch_bs_in[QUAN_SIZE*0+bit_index]};
	end
endgenerate
/*----------------------------------------------*/	
// Circular shifter of check nodes 
qsn_top_85b cnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({cnu_msg_in[84][0],cnu_msg_in[83][0],cnu_msg_in[82][0],cnu_msg_in[81][0],cnu_msg_in[80][0],cnu_msg_in[79][0],cnu_msg_in[78][0],cnu_msg_in[77][0],cnu_msg_in[76][0],cnu_msg_in[75][0],cnu_msg_in[74][0],cnu_msg_in[73][0],cnu_msg_in[72][0],cnu_msg_in[71][0],cnu_msg_in[70][0],cnu_msg_in[69][0],cnu_msg_in[68][0],cnu_msg_in[67][0],cnu_msg_in[66][0],cnu_msg_in[65][0],cnu_msg_in[64][0],cnu_msg_in[63][0],cnu_msg_in[62][0],cnu_msg_in[61][0],cnu_msg_in[60][0],cnu_msg_in[59][0],cnu_msg_in[58][0],cnu_msg_in[57][0],cnu_msg_in[56][0],cnu_msg_in[55][0],cnu_msg_in[54][0],cnu_msg_in[53][0],cnu_msg_in[52][0],cnu_msg_in[51][0],cnu_msg_in[50][0],cnu_msg_in[49][0],cnu_msg_in[48][0],cnu_msg_in[47][0],cnu_msg_in[46][0],cnu_msg_in[45][0],cnu_msg_in[44][0],cnu_msg_in[43][0],cnu_msg_in[42][0],cnu_msg_in[41][0],cnu_msg_in[40][0],cnu_msg_in[39][0],cnu_msg_in[38][0],cnu_msg_in[37][0],cnu_msg_in[36][0],cnu_msg_in[35][0],cnu_msg_in[34][0],cnu_msg_in[33][0],cnu_msg_in[32][0],cnu_msg_in[31][0],cnu_msg_in[30][0],cnu_msg_in[29][0],cnu_msg_in[28][0],cnu_msg_in[27][0],cnu_msg_in[26][0],cnu_msg_in[25][0],cnu_msg_in[24][0],cnu_msg_in[23][0],cnu_msg_in[22][0],cnu_msg_in[21][0],cnu_msg_in[20][0],cnu_msg_in[19][0],cnu_msg_in[18][0],cnu_msg_in[17][0],cnu_msg_in[16][0],cnu_msg_in[15][0],cnu_msg_in[14][0],cnu_msg_in[13][0],cnu_msg_in[12][0],cnu_msg_in[11][0],cnu_msg_in[10][0],cnu_msg_in[9][0],cnu_msg_in[8][0],cnu_msg_in[7][0],cnu_msg_in[6][0],cnu_msg_in[5][0],cnu_msg_in[4][0],cnu_msg_in[3][0],cnu_msg_in[2][0],cnu_msg_in[1][0],cnu_msg_in[0][0]}),
	.sw_out_bit1 ({cnu_msg_in[84][1],cnu_msg_in[83][1],cnu_msg_in[82][1],cnu_msg_in[81][1],cnu_msg_in[80][1],cnu_msg_in[79][1],cnu_msg_in[78][1],cnu_msg_in[77][1],cnu_msg_in[76][1],cnu_msg_in[75][1],cnu_msg_in[74][1],cnu_msg_in[73][1],cnu_msg_in[72][1],cnu_msg_in[71][1],cnu_msg_in[70][1],cnu_msg_in[69][1],cnu_msg_in[68][1],cnu_msg_in[67][1],cnu_msg_in[66][1],cnu_msg_in[65][1],cnu_msg_in[64][1],cnu_msg_in[63][1],cnu_msg_in[62][1],cnu_msg_in[61][1],cnu_msg_in[60][1],cnu_msg_in[59][1],cnu_msg_in[58][1],cnu_msg_in[57][1],cnu_msg_in[56][1],cnu_msg_in[55][1],cnu_msg_in[54][1],cnu_msg_in[53][1],cnu_msg_in[52][1],cnu_msg_in[51][1],cnu_msg_in[50][1],cnu_msg_in[49][1],cnu_msg_in[48][1],cnu_msg_in[47][1],cnu_msg_in[46][1],cnu_msg_in[45][1],cnu_msg_in[44][1],cnu_msg_in[43][1],cnu_msg_in[42][1],cnu_msg_in[41][1],cnu_msg_in[40][1],cnu_msg_in[39][1],cnu_msg_in[38][1],cnu_msg_in[37][1],cnu_msg_in[36][1],cnu_msg_in[35][1],cnu_msg_in[34][1],cnu_msg_in[33][1],cnu_msg_in[32][1],cnu_msg_in[31][1],cnu_msg_in[30][1],cnu_msg_in[29][1],cnu_msg_in[28][1],cnu_msg_in[27][1],cnu_msg_in[26][1],cnu_msg_in[25][1],cnu_msg_in[24][1],cnu_msg_in[23][1],cnu_msg_in[22][1],cnu_msg_in[21][1],cnu_msg_in[20][1],cnu_msg_in[19][1],cnu_msg_in[18][1],cnu_msg_in[17][1],cnu_msg_in[16][1],cnu_msg_in[15][1],cnu_msg_in[14][1],cnu_msg_in[13][1],cnu_msg_in[12][1],cnu_msg_in[11][1],cnu_msg_in[10][1],cnu_msg_in[9][1],cnu_msg_in[8][1],cnu_msg_in[7][1],cnu_msg_in[6][1],cnu_msg_in[5][1],cnu_msg_in[4][1],cnu_msg_in[3][1],cnu_msg_in[2][1],cnu_msg_in[1][1],cnu_msg_in[0][1]}),
	.sw_out_bit2 ({cnu_msg_in[84][2],cnu_msg_in[83][2],cnu_msg_in[82][2],cnu_msg_in[81][2],cnu_msg_in[80][2],cnu_msg_in[79][2],cnu_msg_in[78][2],cnu_msg_in[77][2],cnu_msg_in[76][2],cnu_msg_in[75][2],cnu_msg_in[74][2],cnu_msg_in[73][2],cnu_msg_in[72][2],cnu_msg_in[71][2],cnu_msg_in[70][2],cnu_msg_in[69][2],cnu_msg_in[68][2],cnu_msg_in[67][2],cnu_msg_in[66][2],cnu_msg_in[65][2],cnu_msg_in[64][2],cnu_msg_in[63][2],cnu_msg_in[62][2],cnu_msg_in[61][2],cnu_msg_in[60][2],cnu_msg_in[59][2],cnu_msg_in[58][2],cnu_msg_in[57][2],cnu_msg_in[56][2],cnu_msg_in[55][2],cnu_msg_in[54][2],cnu_msg_in[53][2],cnu_msg_in[52][2],cnu_msg_in[51][2],cnu_msg_in[50][2],cnu_msg_in[49][2],cnu_msg_in[48][2],cnu_msg_in[47][2],cnu_msg_in[46][2],cnu_msg_in[45][2],cnu_msg_in[44][2],cnu_msg_in[43][2],cnu_msg_in[42][2],cnu_msg_in[41][2],cnu_msg_in[40][2],cnu_msg_in[39][2],cnu_msg_in[38][2],cnu_msg_in[37][2],cnu_msg_in[36][2],cnu_msg_in[35][2],cnu_msg_in[34][2],cnu_msg_in[33][2],cnu_msg_in[32][2],cnu_msg_in[31][2],cnu_msg_in[30][2],cnu_msg_in[29][2],cnu_msg_in[28][2],cnu_msg_in[27][2],cnu_msg_in[26][2],cnu_msg_in[25][2],cnu_msg_in[24][2],cnu_msg_in[23][2],cnu_msg_in[22][2],cnu_msg_in[21][2],cnu_msg_in[20][2],cnu_msg_in[19][2],cnu_msg_in[18][2],cnu_msg_in[17][2],cnu_msg_in[16][2],cnu_msg_in[15][2],cnu_msg_in[14][2],cnu_msg_in[13][2],cnu_msg_in[12][2],cnu_msg_in[11][2],cnu_msg_in[10][2],cnu_msg_in[9][2],cnu_msg_in[8][2],cnu_msg_in[7][2],cnu_msg_in[6][2],cnu_msg_in[5][2],cnu_msg_in[4][2],cnu_msg_in[3][2],cnu_msg_in[2][2],cnu_msg_in[1][2],cnu_msg_in[0][2]}),	
	.sw_out_bit3 ({cnu_msg_in[84][3],cnu_msg_in[83][3],cnu_msg_in[82][3],cnu_msg_in[81][3],cnu_msg_in[80][3],cnu_msg_in[79][3],cnu_msg_in[78][3],cnu_msg_in[77][3],cnu_msg_in[76][3],cnu_msg_in[75][3],cnu_msg_in[74][3],cnu_msg_in[73][3],cnu_msg_in[72][3],cnu_msg_in[71][3],cnu_msg_in[70][3],cnu_msg_in[69][3],cnu_msg_in[68][3],cnu_msg_in[67][3],cnu_msg_in[66][3],cnu_msg_in[65][3],cnu_msg_in[64][3],cnu_msg_in[63][3],cnu_msg_in[62][3],cnu_msg_in[61][3],cnu_msg_in[60][3],cnu_msg_in[59][3],cnu_msg_in[58][3],cnu_msg_in[57][3],cnu_msg_in[56][3],cnu_msg_in[55][3],cnu_msg_in[54][3],cnu_msg_in[53][3],cnu_msg_in[52][3],cnu_msg_in[51][3],cnu_msg_in[50][3],cnu_msg_in[49][3],cnu_msg_in[48][3],cnu_msg_in[47][3],cnu_msg_in[46][3],cnu_msg_in[45][3],cnu_msg_in[44][3],cnu_msg_in[43][3],cnu_msg_in[42][3],cnu_msg_in[41][3],cnu_msg_in[40][3],cnu_msg_in[39][3],cnu_msg_in[38][3],cnu_msg_in[37][3],cnu_msg_in[36][3],cnu_msg_in[35][3],cnu_msg_in[34][3],cnu_msg_in[33][3],cnu_msg_in[32][3],cnu_msg_in[31][3],cnu_msg_in[30][3],cnu_msg_in[29][3],cnu_msg_in[28][3],cnu_msg_in[27][3],cnu_msg_in[26][3],cnu_msg_in[25][3],cnu_msg_in[24][3],cnu_msg_in[23][3],cnu_msg_in[22][3],cnu_msg_in[21][3],cnu_msg_in[20][3],cnu_msg_in[19][3],cnu_msg_in[18][3],cnu_msg_in[17][3],cnu_msg_in[16][3],cnu_msg_in[15][3],cnu_msg_in[14][3],cnu_msg_in[13][3],cnu_msg_in[12][3],cnu_msg_in[11][3],cnu_msg_in[10][3],cnu_msg_in[9][3],cnu_msg_in[8][3],cnu_msg_in[7][3],cnu_msg_in[6][3],cnu_msg_in[5][3],cnu_msg_in[4][3],cnu_msg_in[3][3],cnu_msg_in[2][3],cnu_msg_in[1][3],cnu_msg_in[0][3]}),
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in_bit0  (cnu_bs_in_bit[0]),
	.sw_in_bit1  (cnu_bs_in_bit[1]),
	.sw_in_bit2  (cnu_bs_in_bit[2]),
	.sw_in_bit3  (cnu_bs_in_bit[3]),
	.left_sel    (cnu_left_sel),
	.right_sel   (cnu_right_sel),
	.merge_sel   (cnu_merge_sel)
);
qsn_controller_85b #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) cnu_qsn_controller_85b (
	.left_sel     (cnu_left_sel ),
	.right_sel    (cnu_right_sel),
	.merge_sel    (cnu_merge_sel),
	.shift_factor (c2v_shift_factor_cur_0), // offset shift factor of submatrix_1
	.rstn         (rstn),
	.sys_clk      (read_clk)
);
/*----------------------------------------------*/
// Circular shifter of variable nodes 
shared_qsn_top_85b #(
		.QUAN_SIZE(QUAN_SIZE),
		.CHECK_PARALLELISM(CHECK_PARALLELISM),
		.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR)
) inst_shared_qsn_top_85b (
	.sw_out_bit0 ({vnu_msg_in[84][0],vnu_msg_in[83][0],vnu_msg_in[82][0],vnu_msg_in[81][0],vnu_msg_in[80][0],vnu_msg_in[79][0],vnu_msg_in[78][0],vnu_msg_in[77][0],vnu_msg_in[76][0],vnu_msg_in[75][0],vnu_msg_in[74][0],vnu_msg_in[73][0],vnu_msg_in[72][0],vnu_msg_in[71][0],vnu_msg_in[70][0],vnu_msg_in[69][0],vnu_msg_in[68][0],vnu_msg_in[67][0],vnu_msg_in[66][0],vnu_msg_in[65][0],vnu_msg_in[64][0],vnu_msg_in[63][0],vnu_msg_in[62][0],vnu_msg_in[61][0],vnu_msg_in[60][0],vnu_msg_in[59][0],vnu_msg_in[58][0],vnu_msg_in[57][0],vnu_msg_in[56][0],vnu_msg_in[55][0],vnu_msg_in[54][0],vnu_msg_in[53][0],vnu_msg_in[52][0],vnu_msg_in[51][0],vnu_msg_in[50][0],vnu_msg_in[49][0],vnu_msg_in[48][0],vnu_msg_in[47][0],vnu_msg_in[46][0],vnu_msg_in[45][0],vnu_msg_in[44][0],vnu_msg_in[43][0],vnu_msg_in[42][0],vnu_msg_in[41][0],vnu_msg_in[40][0],vnu_msg_in[39][0],vnu_msg_in[38][0],vnu_msg_in[37][0],vnu_msg_in[36][0],vnu_msg_in[35][0],vnu_msg_in[34][0],vnu_msg_in[33][0],vnu_msg_in[32][0],vnu_msg_in[31][0],vnu_msg_in[30][0],vnu_msg_in[29][0],vnu_msg_in[28][0],vnu_msg_in[27][0],vnu_msg_in[26][0],vnu_msg_in[25][0],vnu_msg_in[24][0],vnu_msg_in[23][0],vnu_msg_in[22][0],vnu_msg_in[21][0],vnu_msg_in[20][0],vnu_msg_in[19][0],vnu_msg_in[18][0],vnu_msg_in[17][0],vnu_msg_in[16][0],vnu_msg_in[15][0],vnu_msg_in[14][0],vnu_msg_in[13][0],vnu_msg_in[12][0],vnu_msg_in[11][0],vnu_msg_in[10][0],vnu_msg_in[9][0],vnu_msg_in[8][0],vnu_msg_in[7][0],vnu_msg_in[6][0],vnu_msg_in[5][0],vnu_msg_in[4][0],vnu_msg_in[3][0],vnu_msg_in[2][0],vnu_msg_in[1][0],vnu_msg_in[0][0]}),	
	.sw_out_bit1 ({vnu_msg_in[84][1],vnu_msg_in[83][1],vnu_msg_in[82][1],vnu_msg_in[81][1],vnu_msg_in[80][1],vnu_msg_in[79][1],vnu_msg_in[78][1],vnu_msg_in[77][1],vnu_msg_in[76][1],vnu_msg_in[75][1],vnu_msg_in[74][1],vnu_msg_in[73][1],vnu_msg_in[72][1],vnu_msg_in[71][1],vnu_msg_in[70][1],vnu_msg_in[69][1],vnu_msg_in[68][1],vnu_msg_in[67][1],vnu_msg_in[66][1],vnu_msg_in[65][1],vnu_msg_in[64][1],vnu_msg_in[63][1],vnu_msg_in[62][1],vnu_msg_in[61][1],vnu_msg_in[60][1],vnu_msg_in[59][1],vnu_msg_in[58][1],vnu_msg_in[57][1],vnu_msg_in[56][1],vnu_msg_in[55][1],vnu_msg_in[54][1],vnu_msg_in[53][1],vnu_msg_in[52][1],vnu_msg_in[51][1],vnu_msg_in[50][1],vnu_msg_in[49][1],vnu_msg_in[48][1],vnu_msg_in[47][1],vnu_msg_in[46][1],vnu_msg_in[45][1],vnu_msg_in[44][1],vnu_msg_in[43][1],vnu_msg_in[42][1],vnu_msg_in[41][1],vnu_msg_in[40][1],vnu_msg_in[39][1],vnu_msg_in[38][1],vnu_msg_in[37][1],vnu_msg_in[36][1],vnu_msg_in[35][1],vnu_msg_in[34][1],vnu_msg_in[33][1],vnu_msg_in[32][1],vnu_msg_in[31][1],vnu_msg_in[30][1],vnu_msg_in[29][1],vnu_msg_in[28][1],vnu_msg_in[27][1],vnu_msg_in[26][1],vnu_msg_in[25][1],vnu_msg_in[24][1],vnu_msg_in[23][1],vnu_msg_in[22][1],vnu_msg_in[21][1],vnu_msg_in[20][1],vnu_msg_in[19][1],vnu_msg_in[18][1],vnu_msg_in[17][1],vnu_msg_in[16][1],vnu_msg_in[15][1],vnu_msg_in[14][1],vnu_msg_in[13][1],vnu_msg_in[12][1],vnu_msg_in[11][1],vnu_msg_in[10][1],vnu_msg_in[9][1],vnu_msg_in[8][1],vnu_msg_in[7][1],vnu_msg_in[6][1],vnu_msg_in[5][1],vnu_msg_in[4][1],vnu_msg_in[3][1],vnu_msg_in[2][1],vnu_msg_in[1][1],vnu_msg_in[0][1]}),	
	.sw_out_bit2 ({vnu_msg_in[84][2],vnu_msg_in[83][2],vnu_msg_in[82][2],vnu_msg_in[81][2],vnu_msg_in[80][2],vnu_msg_in[79][2],vnu_msg_in[78][2],vnu_msg_in[77][2],vnu_msg_in[76][2],vnu_msg_in[75][2],vnu_msg_in[74][2],vnu_msg_in[73][2],vnu_msg_in[72][2],vnu_msg_in[71][2],vnu_msg_in[70][2],vnu_msg_in[69][2],vnu_msg_in[68][2],vnu_msg_in[67][2],vnu_msg_in[66][2],vnu_msg_in[65][2],vnu_msg_in[64][2],vnu_msg_in[63][2],vnu_msg_in[62][2],vnu_msg_in[61][2],vnu_msg_in[60][2],vnu_msg_in[59][2],vnu_msg_in[58][2],vnu_msg_in[57][2],vnu_msg_in[56][2],vnu_msg_in[55][2],vnu_msg_in[54][2],vnu_msg_in[53][2],vnu_msg_in[52][2],vnu_msg_in[51][2],vnu_msg_in[50][2],vnu_msg_in[49][2],vnu_msg_in[48][2],vnu_msg_in[47][2],vnu_msg_in[46][2],vnu_msg_in[45][2],vnu_msg_in[44][2],vnu_msg_in[43][2],vnu_msg_in[42][2],vnu_msg_in[41][2],vnu_msg_in[40][2],vnu_msg_in[39][2],vnu_msg_in[38][2],vnu_msg_in[37][2],vnu_msg_in[36][2],vnu_msg_in[35][2],vnu_msg_in[34][2],vnu_msg_in[33][2],vnu_msg_in[32][2],vnu_msg_in[31][2],vnu_msg_in[30][2],vnu_msg_in[29][2],vnu_msg_in[28][2],vnu_msg_in[27][2],vnu_msg_in[26][2],vnu_msg_in[25][2],vnu_msg_in[24][2],vnu_msg_in[23][2],vnu_msg_in[22][2],vnu_msg_in[21][2],vnu_msg_in[20][2],vnu_msg_in[19][2],vnu_msg_in[18][2],vnu_msg_in[17][2],vnu_msg_in[16][2],vnu_msg_in[15][2],vnu_msg_in[14][2],vnu_msg_in[13][2],vnu_msg_in[12][2],vnu_msg_in[11][2],vnu_msg_in[10][2],vnu_msg_in[9][2],vnu_msg_in[8][2],vnu_msg_in[7][2],vnu_msg_in[6][2],vnu_msg_in[5][2],vnu_msg_in[4][2],vnu_msg_in[3][2],vnu_msg_in[2][2],vnu_msg_in[1][2],vnu_msg_in[0][2]}),	
	.sw_out_bit3 ({vnu_msg_in[84][3],vnu_msg_in[83][3],vnu_msg_in[82][3],vnu_msg_in[81][3],vnu_msg_in[80][3],vnu_msg_in[79][3],vnu_msg_in[78][3],vnu_msg_in[77][3],vnu_msg_in[76][3],vnu_msg_in[75][3],vnu_msg_in[74][3],vnu_msg_in[73][3],vnu_msg_in[72][3],vnu_msg_in[71][3],vnu_msg_in[70][3],vnu_msg_in[69][3],vnu_msg_in[68][3],vnu_msg_in[67][3],vnu_msg_in[66][3],vnu_msg_in[65][3],vnu_msg_in[64][3],vnu_msg_in[63][3],vnu_msg_in[62][3],vnu_msg_in[61][3],vnu_msg_in[60][3],vnu_msg_in[59][3],vnu_msg_in[58][3],vnu_msg_in[57][3],vnu_msg_in[56][3],vnu_msg_in[55][3],vnu_msg_in[54][3],vnu_msg_in[53][3],vnu_msg_in[52][3],vnu_msg_in[51][3],vnu_msg_in[50][3],vnu_msg_in[49][3],vnu_msg_in[48][3],vnu_msg_in[47][3],vnu_msg_in[46][3],vnu_msg_in[45][3],vnu_msg_in[44][3],vnu_msg_in[43][3],vnu_msg_in[42][3],vnu_msg_in[41][3],vnu_msg_in[40][3],vnu_msg_in[39][3],vnu_msg_in[38][3],vnu_msg_in[37][3],vnu_msg_in[36][3],vnu_msg_in[35][3],vnu_msg_in[34][3],vnu_msg_in[33][3],vnu_msg_in[32][3],vnu_msg_in[31][3],vnu_msg_in[30][3],vnu_msg_in[29][3],vnu_msg_in[28][3],vnu_msg_in[27][3],vnu_msg_in[26][3],vnu_msg_in[25][3],vnu_msg_in[24][3],vnu_msg_in[23][3],vnu_msg_in[22][3],vnu_msg_in[21][3],vnu_msg_in[20][3],vnu_msg_in[19][3],vnu_msg_in[18][3],vnu_msg_in[17][3],vnu_msg_in[16][3],vnu_msg_in[15][3],vnu_msg_in[14][3],vnu_msg_in[13][3],vnu_msg_in[12][3],vnu_msg_in[11][3],vnu_msg_in[10][3],vnu_msg_in[9][3],vnu_msg_in[8][3],vnu_msg_in[7][3],vnu_msg_in[6][3],vnu_msg_in[5][3],vnu_msg_in[4][3],vnu_msg_in[3][3],vnu_msg_in[2][3],vnu_msg_in[1][3],vnu_msg_in[0][3]}),	
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in0_bit0  (vnu_bs_in_bit[0]),
	.sw_in0_bit1  (vnu_bs_in_bit[1]),
	.sw_in0_bit2  (vnu_bs_in_bit[2]),
	.sw_in0_bit3  (vnu_bs_in_bit[3]),

	.sw_in1_bit0 (ch_bs_in_bit[0]),
	.sw_in1_bit1 (ch_bs_in_bit[1]),
	.sw_in1_bit2 (ch_bs_in_bit[2]),
	.sw_in1_bit3 (ch_bs_in_bit[3]),

	.sw_in2_bit0 (dnu_inRotate_bit),

	.shift_factor (v2c_shift_factor_cur_0), // offset shift factor of submatrix
	.sw_in_src (vnu_bs_src),
	.sw_in_bit0_src (vnu_bs_bit0_src)
);
/*----------------------------------------------*/	
	reg [ADDR_WIDTH-1:0] c2v_mem_page_addr;
	reg [ADDR_WIDTH-1:0] v2c_mem_page_addr;
	mem_subsystem_top_submatrix_2 #(
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
		) inst_mem_subsystem_top_submatrix_2 (
			.mem_to_vnu_0     (mem_to_vnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_vnu_1     (mem_to_vnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_vnu_2     (mem_to_vnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_vnu_3     (mem_to_vnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_vnu_4     (mem_to_vnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_vnu_5     (mem_to_vnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_vnu_6     (mem_to_vnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_vnu_7     (mem_to_vnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_vnu_8     (mem_to_vnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_vnu_9     (mem_to_vnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_vnu_10    (mem_to_vnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_vnu_11    (mem_to_vnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_vnu_12    (mem_to_vnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_vnu_13    (mem_to_vnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_vnu_14    (mem_to_vnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_vnu_15    (mem_to_vnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_vnu_16    (mem_to_vnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_vnu_17    (mem_to_vnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_vnu_18    (mem_to_vnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_vnu_19    (mem_to_vnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_vnu_20    (mem_to_vnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_vnu_21    (mem_to_vnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_vnu_22    (mem_to_vnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_vnu_23    (mem_to_vnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_vnu_24    (mem_to_vnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_vnu_25    (mem_to_vnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_vnu_26    (mem_to_vnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_vnu_27    (mem_to_vnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_vnu_28    (mem_to_vnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_vnu_29    (mem_to_vnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_vnu_30    (mem_to_vnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_vnu_31    (mem_to_vnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_vnu_32    (mem_to_vnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_vnu_33    (mem_to_vnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_vnu_34    (mem_to_vnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_vnu_35    (mem_to_vnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_vnu_36    (mem_to_vnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_vnu_37    (mem_to_vnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_vnu_38    (mem_to_vnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_vnu_39    (mem_to_vnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_vnu_40    (mem_to_vnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_vnu_41    (mem_to_vnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_vnu_42    (mem_to_vnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_vnu_43    (mem_to_vnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_vnu_44    (mem_to_vnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_vnu_45    (mem_to_vnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_vnu_46    (mem_to_vnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_vnu_47    (mem_to_vnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_vnu_48    (mem_to_vnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_vnu_49    (mem_to_vnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_vnu_50    (mem_to_vnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_vnu_51    (mem_to_vnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_vnu_52    (mem_to_vnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_vnu_53    (mem_to_vnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_vnu_54    (mem_to_vnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_vnu_55    (mem_to_vnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_vnu_56    (mem_to_vnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_vnu_57    (mem_to_vnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_vnu_58    (mem_to_vnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_vnu_59    (mem_to_vnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_vnu_60    (mem_to_vnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_vnu_61    (mem_to_vnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_vnu_62    (mem_to_vnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_vnu_63    (mem_to_vnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_vnu_64    (mem_to_vnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_vnu_65    (mem_to_vnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_vnu_66    (mem_to_vnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_vnu_67    (mem_to_vnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_vnu_68    (mem_to_vnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_vnu_69    (mem_to_vnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_vnu_70    (mem_to_vnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_vnu_71    (mem_to_vnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_vnu_72    (mem_to_vnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_vnu_73    (mem_to_vnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_vnu_74    (mem_to_vnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_vnu_75    (mem_to_vnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_vnu_76    (mem_to_vnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_vnu_77    (mem_to_vnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_vnu_78    (mem_to_vnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_vnu_79    (mem_to_vnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_vnu_80    (mem_to_vnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_vnu_81    (mem_to_vnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_vnu_82    (mem_to_vnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_vnu_83    (mem_to_vnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_vnu_84    (mem_to_vnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),
			.mem_to_cnu_0     (mem_to_cnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_cnu_1     (mem_to_cnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_cnu_2     (mem_to_cnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_cnu_3     (mem_to_cnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_cnu_4     (mem_to_cnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_cnu_5     (mem_to_cnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_cnu_6     (mem_to_cnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_cnu_7     (mem_to_cnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_cnu_8     (mem_to_cnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_cnu_9     (mem_to_cnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_cnu_10    (mem_to_cnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_cnu_11    (mem_to_cnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_cnu_12    (mem_to_cnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_cnu_13    (mem_to_cnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_cnu_14    (mem_to_cnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_cnu_15    (mem_to_cnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_cnu_16    (mem_to_cnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_cnu_17    (mem_to_cnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_cnu_18    (mem_to_cnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_cnu_19    (mem_to_cnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_cnu_20    (mem_to_cnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_cnu_21    (mem_to_cnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_cnu_22    (mem_to_cnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_cnu_23    (mem_to_cnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_cnu_24    (mem_to_cnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_cnu_25    (mem_to_cnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_cnu_26    (mem_to_cnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_cnu_27    (mem_to_cnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_cnu_28    (mem_to_cnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_cnu_29    (mem_to_cnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_cnu_30    (mem_to_cnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_cnu_31    (mem_to_cnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_cnu_32    (mem_to_cnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_cnu_33    (mem_to_cnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_cnu_34    (mem_to_cnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_cnu_35    (mem_to_cnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_cnu_36    (mem_to_cnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_cnu_37    (mem_to_cnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_cnu_38    (mem_to_cnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_cnu_39    (mem_to_cnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_cnu_40    (mem_to_cnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_cnu_41    (mem_to_cnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_cnu_42    (mem_to_cnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_cnu_43    (mem_to_cnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_cnu_44    (mem_to_cnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_cnu_45    (mem_to_cnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_cnu_46    (mem_to_cnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_cnu_47    (mem_to_cnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_cnu_48    (mem_to_cnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_cnu_49    (mem_to_cnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_cnu_50    (mem_to_cnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_cnu_51    (mem_to_cnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_cnu_52    (mem_to_cnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_cnu_53    (mem_to_cnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_cnu_54    (mem_to_cnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_cnu_55    (mem_to_cnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_cnu_56    (mem_to_cnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_cnu_57    (mem_to_cnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_cnu_58    (mem_to_cnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_cnu_59    (mem_to_cnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_cnu_60    (mem_to_cnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_cnu_61    (mem_to_cnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_cnu_62    (mem_to_cnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_cnu_63    (mem_to_cnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_cnu_64    (mem_to_cnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_cnu_65    (mem_to_cnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_cnu_66    (mem_to_cnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_cnu_67    (mem_to_cnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_cnu_68    (mem_to_cnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_cnu_69    (mem_to_cnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_cnu_70    (mem_to_cnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_cnu_71    (mem_to_cnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_cnu_72    (mem_to_cnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_cnu_73    (mem_to_cnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_cnu_74    (mem_to_cnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_cnu_75    (mem_to_cnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_cnu_76    (mem_to_cnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_cnu_77    (mem_to_cnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_cnu_78    (mem_to_cnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_cnu_79    (mem_to_cnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_cnu_80    (mem_to_cnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_cnu_81    (mem_to_cnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_cnu_82    (mem_to_cnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_cnu_83    (mem_to_cnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_cnu_84    (mem_to_cnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),

			.vnu_to_mem_0     (vnu_msg_in[0 ]),
			.vnu_to_mem_1     (vnu_msg_in[1 ]),
			.vnu_to_mem_2     (vnu_msg_in[2 ]),
			.vnu_to_mem_3     (vnu_msg_in[3 ]),
			.vnu_to_mem_4     (vnu_msg_in[4 ]),
			.vnu_to_mem_5     (vnu_msg_in[5 ]),
			.vnu_to_mem_6     (vnu_msg_in[6 ]),
			.vnu_to_mem_7     (vnu_msg_in[7 ]),
			.vnu_to_mem_8     (vnu_msg_in[8 ]),
			.vnu_to_mem_9     (vnu_msg_in[9 ]),
			.vnu_to_mem_10    (vnu_msg_in[10]),
			.vnu_to_mem_11    (vnu_msg_in[11]),
			.vnu_to_mem_12    (vnu_msg_in[12]),
			.vnu_to_mem_13    (vnu_msg_in[13]),
			.vnu_to_mem_14    (vnu_msg_in[14]),
			.vnu_to_mem_15    (vnu_msg_in[15]),
			.vnu_to_mem_16    (vnu_msg_in[16]),
			.vnu_to_mem_17    (vnu_msg_in[17]),
			.vnu_to_mem_18    (vnu_msg_in[18]),
			.vnu_to_mem_19    (vnu_msg_in[19]),
			.vnu_to_mem_20    (vnu_msg_in[20]),
			.vnu_to_mem_21    (vnu_msg_in[21]),
			.vnu_to_mem_22    (vnu_msg_in[22]),
			.vnu_to_mem_23    (vnu_msg_in[23]),
			.vnu_to_mem_24    (vnu_msg_in[24]),
			.vnu_to_mem_25    (vnu_msg_in[25]),
			.vnu_to_mem_26    (vnu_msg_in[26]),
			.vnu_to_mem_27    (vnu_msg_in[27]),
			.vnu_to_mem_28    (vnu_msg_in[28]),
			.vnu_to_mem_29    (vnu_msg_in[29]),
			.vnu_to_mem_30    (vnu_msg_in[30]),
			.vnu_to_mem_31    (vnu_msg_in[31]),
			.vnu_to_mem_32    (vnu_msg_in[32]),
			.vnu_to_mem_33    (vnu_msg_in[33]),
			.vnu_to_mem_34    (vnu_msg_in[34]),
			.vnu_to_mem_35    (vnu_msg_in[35]),
			.vnu_to_mem_36    (vnu_msg_in[36]),
			.vnu_to_mem_37    (vnu_msg_in[37]),
			.vnu_to_mem_38    (vnu_msg_in[38]),
			.vnu_to_mem_39    (vnu_msg_in[39]),
			.vnu_to_mem_40    (vnu_msg_in[40]),
			.vnu_to_mem_41    (vnu_msg_in[41]),
			.vnu_to_mem_42    (vnu_msg_in[42]),
			.vnu_to_mem_43    (vnu_msg_in[43]),
			.vnu_to_mem_44    (vnu_msg_in[44]),
			.vnu_to_mem_45    (vnu_msg_in[45]),
			.vnu_to_mem_46    (vnu_msg_in[46]),
			.vnu_to_mem_47    (vnu_msg_in[47]),
			.vnu_to_mem_48    (vnu_msg_in[48]),
			.vnu_to_mem_49    (vnu_msg_in[49]),
			.vnu_to_mem_50    (vnu_msg_in[50]),
			.vnu_to_mem_51    (vnu_msg_in[51]),
			.vnu_to_mem_52    (vnu_msg_in[52]),
			.vnu_to_mem_53    (vnu_msg_in[53]),
			.vnu_to_mem_54    (vnu_msg_in[54]),
			.vnu_to_mem_55    (vnu_msg_in[55]),
			.vnu_to_mem_56    (vnu_msg_in[56]),
			.vnu_to_mem_57    (vnu_msg_in[57]),
			.vnu_to_mem_58    (vnu_msg_in[58]),
			.vnu_to_mem_59    (vnu_msg_in[59]),
			.vnu_to_mem_60    (vnu_msg_in[60]),
			.vnu_to_mem_61    (vnu_msg_in[61]),
			.vnu_to_mem_62    (vnu_msg_in[62]),
			.vnu_to_mem_63    (vnu_msg_in[63]),
			.vnu_to_mem_64    (vnu_msg_in[64]),
			.vnu_to_mem_65    (vnu_msg_in[65]),
			.vnu_to_mem_66    (vnu_msg_in[66]),
			.vnu_to_mem_67    (vnu_msg_in[67]),
			.vnu_to_mem_68    (vnu_msg_in[68]),
			.vnu_to_mem_69    (vnu_msg_in[69]),
			.vnu_to_mem_70    (vnu_msg_in[70]),
			.vnu_to_mem_71    (vnu_msg_in[71]),
			.vnu_to_mem_72    (vnu_msg_in[72]),
			.vnu_to_mem_73    (vnu_msg_in[73]),
			.vnu_to_mem_74    (vnu_msg_in[74]),
			.vnu_to_mem_75    (vnu_msg_in[75]),
			.vnu_to_mem_76    (vnu_msg_in[76]),
			.vnu_to_mem_77    (vnu_msg_in[77]),
			.vnu_to_mem_78    (vnu_msg_in[78]),
			.vnu_to_mem_79    (vnu_msg_in[79]),
			.vnu_to_mem_80    (vnu_msg_in[80]),
			.vnu_to_mem_81    (vnu_msg_in[81]),
			.vnu_to_mem_82    (vnu_msg_in[82]),
			.vnu_to_mem_83    (vnu_msg_in[83]),
			.vnu_to_mem_84    (vnu_msg_in[84]),
			.cnu_to_mem_0     (cnu_msg_in[0 ]),
			.cnu_to_mem_1     (cnu_msg_in[1 ]),
			.cnu_to_mem_2     (cnu_msg_in[2 ]),
			.cnu_to_mem_3     (cnu_msg_in[3 ]),
			.cnu_to_mem_4     (cnu_msg_in[4 ]),
			.cnu_to_mem_5     (cnu_msg_in[5 ]),
			.cnu_to_mem_6     (cnu_msg_in[6 ]),
			.cnu_to_mem_7     (cnu_msg_in[7 ]),
			.cnu_to_mem_8     (cnu_msg_in[8 ]),
			.cnu_to_mem_9     (cnu_msg_in[9 ]),
			.cnu_to_mem_10    (cnu_msg_in[10]),
			.cnu_to_mem_11    (cnu_msg_in[11]),
			.cnu_to_mem_12    (cnu_msg_in[12]),
			.cnu_to_mem_13    (cnu_msg_in[13]),
			.cnu_to_mem_14    (cnu_msg_in[14]),
			.cnu_to_mem_15    (cnu_msg_in[15]),
			.cnu_to_mem_16    (cnu_msg_in[16]),
			.cnu_to_mem_17    (cnu_msg_in[17]),
			.cnu_to_mem_18    (cnu_msg_in[18]),
			.cnu_to_mem_19    (cnu_msg_in[19]),
			.cnu_to_mem_20    (cnu_msg_in[20]),
			.cnu_to_mem_21    (cnu_msg_in[21]),
			.cnu_to_mem_22    (cnu_msg_in[22]),
			.cnu_to_mem_23    (cnu_msg_in[23]),
			.cnu_to_mem_24    (cnu_msg_in[24]),
			.cnu_to_mem_25    (cnu_msg_in[25]),
			.cnu_to_mem_26    (cnu_msg_in[26]),
			.cnu_to_mem_27    (cnu_msg_in[27]),
			.cnu_to_mem_28    (cnu_msg_in[28]),
			.cnu_to_mem_29    (cnu_msg_in[29]),
			.cnu_to_mem_30    (cnu_msg_in[30]),
			.cnu_to_mem_31    (cnu_msg_in[31]),
			.cnu_to_mem_32    (cnu_msg_in[32]),
			.cnu_to_mem_33    (cnu_msg_in[33]),
			.cnu_to_mem_34    (cnu_msg_in[34]),
			.cnu_to_mem_35    (cnu_msg_in[35]),
			.cnu_to_mem_36    (cnu_msg_in[36]),
			.cnu_to_mem_37    (cnu_msg_in[37]),
			.cnu_to_mem_38    (cnu_msg_in[38]),
			.cnu_to_mem_39    (cnu_msg_in[39]),
			.cnu_to_mem_40    (cnu_msg_in[40]),
			.cnu_to_mem_41    (cnu_msg_in[41]),
			.cnu_to_mem_42    (cnu_msg_in[42]),
			.cnu_to_mem_43    (cnu_msg_in[43]),
			.cnu_to_mem_44    (cnu_msg_in[44]),
			.cnu_to_mem_45    (cnu_msg_in[45]),
			.cnu_to_mem_46    (cnu_msg_in[46]),
			.cnu_to_mem_47    (cnu_msg_in[47]),
			.cnu_to_mem_48    (cnu_msg_in[48]),
			.cnu_to_mem_49    (cnu_msg_in[49]),
			.cnu_to_mem_50    (cnu_msg_in[50]),
			.cnu_to_mem_51    (cnu_msg_in[51]),
			.cnu_to_mem_52    (cnu_msg_in[52]),
			.cnu_to_mem_53    (cnu_msg_in[53]),
			.cnu_to_mem_54    (cnu_msg_in[54]),
			.cnu_to_mem_55    (cnu_msg_in[55]),
			.cnu_to_mem_56    (cnu_msg_in[56]),
			.cnu_to_mem_57    (cnu_msg_in[57]),
			.cnu_to_mem_58    (cnu_msg_in[58]),
			.cnu_to_mem_59    (cnu_msg_in[59]),
			.cnu_to_mem_60    (cnu_msg_in[60]),
			.cnu_to_mem_61    (cnu_msg_in[61]),
			.cnu_to_mem_62    (cnu_msg_in[62]),
			.cnu_to_mem_63    (cnu_msg_in[63]),
			.cnu_to_mem_64    (cnu_msg_in[64]),
			.cnu_to_mem_65    (cnu_msg_in[65]),
			.cnu_to_mem_66    (cnu_msg_in[66]),
			.cnu_to_mem_67    (cnu_msg_in[67]),
			.cnu_to_mem_68    (cnu_msg_in[68]),
			.cnu_to_mem_69    (cnu_msg_in[69]),
			.cnu_to_mem_70    (cnu_msg_in[70]),
			.cnu_to_mem_71    (cnu_msg_in[71]),
			.cnu_to_mem_72    (cnu_msg_in[72]),
			.cnu_to_mem_73    (cnu_msg_in[73]),
			.cnu_to_mem_74    (cnu_msg_in[74]),
			.cnu_to_mem_75    (cnu_msg_in[75]),
			.cnu_to_mem_76    (cnu_msg_in[76]),
			.cnu_to_mem_77    (cnu_msg_in[77]),
			.cnu_to_mem_78    (cnu_msg_in[78]),
			.cnu_to_mem_79    (cnu_msg_in[79]),
			.cnu_to_mem_80    (cnu_msg_in[80]),
			.cnu_to_mem_81    (cnu_msg_in[81]),
			.cnu_to_mem_82    (cnu_msg_in[82]),
			.cnu_to_mem_83    (cnu_msg_in[83]),
			.cnu_to_mem_84    (cnu_msg_in[84]),
			.cnu_sync_addr    (cnu_mem_page_sync_addr),
			.vnu_sync_addr    (vnu_mem_page_sync_addr),
			.cnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.vnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.last_row_chunk   ({c2v_last_row_chunk, v2c_last_row_chunk}),
			.we               ({v2c_mem_we, c2v_mem_we}),
			.sys_clk          (read_clk),
			.rstn             (rstn)
		);
		assign cnu_mem_page_sync_addr = (v2c_mem_fetch == 1'b1) ? v2c_mem_page_rd_addr : 
										(c2v_mem_we == 1'b1) ? c2v_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.

		assign vnu_mem_page_sync_addr = (c2v_mem_fetch == 1'b1) ? c2v_mem_page_rd_addr : 
										(v2c_mem_we == 1'b1) ? v2c_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Check-to-Variable messages RAMs write-page addresses
	always @(posedge read_clk) begin
		if(rstn == 1'b0) 
			c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE;
		else if(c2v_mem_we == 1'b1) begin
			// page increment pattern within layer 0
			if(v2c_layer_cnt[0] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_1+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 1
			if(v2c_layer_cnt[1] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_2+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 2
			if(v2c_layer_cnt[2] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_2-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
		end
	end

	always @(posedge read_clk) begin
		if(rstn == 1'b0) begin
			c2v_shift_factor_cur_2 <= shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
		end
		else if(c2v_bs_en == 1'b1) begin
			c2v_shift_factor_cur_2 <= 0;
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
/*--------------------------------------------------------------------------*/
// Channel Buffers
reg [CH_DATA_WIDTH-1:0] ch_msg_genIn;
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_0 [0:CHECK_PARALLELISM-1]; // [0:84]
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_1 [0:CHECK_PARALLELISM-1]; // [0:84]
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_rd_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chInit_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chLayer_wr_addr;
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

			.din        (ch_msg_genIn[CH_DATA_WIDTH-1:0]),

			.read_addr  (submatrix_ch_ram_rd_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.write_addr (submatrix_ch_ram_wr_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.we         (ch_ram_we),
			.read_clk   (ch_ram_rd_clk),
			.write_clk  (ch_ram_wr_clk),
			.rstn       (rstn)
		);
		// Updating the Channel RAMs by either initally channel messages (from AWGNs) or circularly shifted channel messages
		assign submatrix_ch_ram_wr_addr = (ch_ram_init_we == 1'b1) ? submatrix_chInit_wr_addr :
														(ch_ram_wb == 1'b1     ) ? submatrix_chLayer_wr_addr : 
																				   CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.


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
	// Channel messages RAMs write-page addresses
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
endmodule

module msg_pass_submatrix_3_unit #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,
	parameter VN_DEGREE = 3,   // degree of one variable node
/*-------------------------------------------------------------------------------------*/
	// Parameters related to BS, PA and MEM
	parameter RAM_DEPTH = 1024,
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH),
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1),
	parameter shift_factor_0 = CHECK_PARALLELISM-38,
	parameter shift_factor_1 = CHECK_PARALLELISM-28,
	parameter shift_factor_2 = CHECK_PARALLELISM-66,

`ifdef SCHED_4_6
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,
	parameter C2V_MEM_ADDR_BASE = 0,
	parameter V2C_MEM_ADDR_BASE = ROW_CHUNK_NUM,
	parameter V2C_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter C2V_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH),
`endif
	parameter START_PAGE_1_0 = 2, // starting page address of layer 0 of submatrix_1
	parameter START_PAGE_1_1 = 8, // starting page address of layer 1 of submatrix_1
	parameter START_PAGE_1_2 = 1  // starting page address of layer 2 of submatrix_1
) (
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu,

	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit,

	// control signals
	input wire c2v_bs_en,
	input wire v2c_bs_en,
	input wire ch_bs_en,
	/*------------------------------*/
	// Control signals associative with message passing of channel buffer and DNU.SignExtension
	input wire ch_ram_init_we,
	input wire ch_ram_fetch,
	input wire v2c_outRotate_reg_we,
	input wire dnu_inRotate_bs_en,
	input wire dnu_inRotate_pa_en,
	input wire dnu_inRotate_wb,
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
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,

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
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_2;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_2;
wire [6:0]  cnu_left_sel;
wire [6:0]  cnu_right_sel;
wire [83:0] cnu_merge_sel;
wire [6:0]  vnu_left_sel;
wire [6:0]  vnu_right_sel;
wire [83:0] vnu_merge_sel;
wire [CHECK_PARALLELISM-1:0] cnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] vnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] ch_bs_in_bit [0:QUAN_SIZE-1];
genvar bit_index;
generate
	for(bit_index=0;bit_index<QUAN_SIZE;bit_index=bit_index+1) begin : extrinsic_msg_bs_in_inst
		assign cnu_bs_in_bit[bit_index] = {c2v_bs_in[QUAN_SIZE*84+bit_index],c2v_bs_in[QUAN_SIZE*83+bit_index],c2v_bs_in[QUAN_SIZE*82+bit_index],c2v_bs_in[QUAN_SIZE*81+bit_index],c2v_bs_in[QUAN_SIZE*80+bit_index],c2v_bs_in[QUAN_SIZE*79+bit_index],c2v_bs_in[QUAN_SIZE*78+bit_index],c2v_bs_in[QUAN_SIZE*77+bit_index],c2v_bs_in[QUAN_SIZE*76+bit_index],c2v_bs_in[QUAN_SIZE*75+bit_index],c2v_bs_in[QUAN_SIZE*74+bit_index],c2v_bs_in[QUAN_SIZE*73+bit_index],c2v_bs_in[QUAN_SIZE*72+bit_index],c2v_bs_in[QUAN_SIZE*71+bit_index],c2v_bs_in[QUAN_SIZE*70+bit_index],c2v_bs_in[QUAN_SIZE*69+bit_index],c2v_bs_in[QUAN_SIZE*68+bit_index],c2v_bs_in[QUAN_SIZE*67+bit_index],c2v_bs_in[QUAN_SIZE*66+bit_index],c2v_bs_in[QUAN_SIZE*65+bit_index],c2v_bs_in[QUAN_SIZE*64+bit_index],c2v_bs_in[QUAN_SIZE*63+bit_index],c2v_bs_in[QUAN_SIZE*62+bit_index],c2v_bs_in[QUAN_SIZE*61+bit_index],c2v_bs_in[QUAN_SIZE*60+bit_index],c2v_bs_in[QUAN_SIZE*59+bit_index],c2v_bs_in[QUAN_SIZE*58+bit_index],c2v_bs_in[QUAN_SIZE*57+bit_index],c2v_bs_in[QUAN_SIZE*56+bit_index],c2v_bs_in[QUAN_SIZE*55+bit_index],c2v_bs_in[QUAN_SIZE*54+bit_index],c2v_bs_in[QUAN_SIZE*53+bit_index],c2v_bs_in[QUAN_SIZE*52+bit_index],c2v_bs_in[QUAN_SIZE*51+bit_index],c2v_bs_in[QUAN_SIZE*50+bit_index],c2v_bs_in[QUAN_SIZE*49+bit_index],c2v_bs_in[QUAN_SIZE*48+bit_index],c2v_bs_in[QUAN_SIZE*47+bit_index],c2v_bs_in[QUAN_SIZE*46+bit_index],c2v_bs_in[QUAN_SIZE*45+bit_index],c2v_bs_in[QUAN_SIZE*44+bit_index],c2v_bs_in[QUAN_SIZE*43+bit_index],c2v_bs_in[QUAN_SIZE*42+bit_index],c2v_bs_in[QUAN_SIZE*41+bit_index],c2v_bs_in[QUAN_SIZE*40+bit_index],c2v_bs_in[QUAN_SIZE*39+bit_index],c2v_bs_in[QUAN_SIZE*38+bit_index],c2v_bs_in[QUAN_SIZE*37+bit_index],c2v_bs_in[QUAN_SIZE*36+bit_index],c2v_bs_in[QUAN_SIZE*35+bit_index],c2v_bs_in[QUAN_SIZE*34+bit_index],c2v_bs_in[QUAN_SIZE*33+bit_index],c2v_bs_in[QUAN_SIZE*32+bit_index],c2v_bs_in[QUAN_SIZE*31+bit_index],c2v_bs_in[QUAN_SIZE*30+bit_index],c2v_bs_in[QUAN_SIZE*29+bit_index],c2v_bs_in[QUAN_SIZE*28+bit_index],c2v_bs_in[QUAN_SIZE*27+bit_index],c2v_bs_in[QUAN_SIZE*26+bit_index],c2v_bs_in[QUAN_SIZE*25+bit_index],c2v_bs_in[QUAN_SIZE*24+bit_index],c2v_bs_in[QUAN_SIZE*23+bit_index],c2v_bs_in[QUAN_SIZE*22+bit_index],c2v_bs_in[QUAN_SIZE*21+bit_index],c2v_bs_in[QUAN_SIZE*20+bit_index],c2v_bs_in[QUAN_SIZE*19+bit_index],c2v_bs_in[QUAN_SIZE*18+bit_index],c2v_bs_in[QUAN_SIZE*17+bit_index],c2v_bs_in[QUAN_SIZE*16+bit_index],c2v_bs_in[QUAN_SIZE*15+bit_index],c2v_bs_in[QUAN_SIZE*14+bit_index],c2v_bs_in[QUAN_SIZE*13+bit_index],c2v_bs_in[QUAN_SIZE*12+bit_index],c2v_bs_in[QUAN_SIZE*11+bit_index],c2v_bs_in[QUAN_SIZE*10+bit_index],c2v_bs_in[QUAN_SIZE*9+bit_index],c2v_bs_in[QUAN_SIZE*8+bit_index],c2v_bs_in[QUAN_SIZE*7+bit_index],c2v_bs_in[QUAN_SIZE*6+bit_index],c2v_bs_in[QUAN_SIZE*5+bit_index],c2v_bs_in[QUAN_SIZE*4+bit_index],c2v_bs_in[QUAN_SIZE*3+bit_index],c2v_bs_in[QUAN_SIZE*2+bit_index],c2v_bs_in[QUAN_SIZE*1+bit_index],c2v_bs_in[QUAN_SIZE*0+bit_index]};
		assign vnu_bs_in_bit[bit_index] = {v2c_bs_in[QUAN_SIZE*84+bit_index],v2c_bs_in[QUAN_SIZE*83+bit_index],v2c_bs_in[QUAN_SIZE*82+bit_index],v2c_bs_in[QUAN_SIZE*81+bit_index],v2c_bs_in[QUAN_SIZE*80+bit_index],v2c_bs_in[QUAN_SIZE*79+bit_index],v2c_bs_in[QUAN_SIZE*78+bit_index],v2c_bs_in[QUAN_SIZE*77+bit_index],v2c_bs_in[QUAN_SIZE*76+bit_index],v2c_bs_in[QUAN_SIZE*75+bit_index],v2c_bs_in[QUAN_SIZE*74+bit_index],v2c_bs_in[QUAN_SIZE*73+bit_index],v2c_bs_in[QUAN_SIZE*72+bit_index],v2c_bs_in[QUAN_SIZE*71+bit_index],v2c_bs_in[QUAN_SIZE*70+bit_index],v2c_bs_in[QUAN_SIZE*69+bit_index],v2c_bs_in[QUAN_SIZE*68+bit_index],v2c_bs_in[QUAN_SIZE*67+bit_index],v2c_bs_in[QUAN_SIZE*66+bit_index],v2c_bs_in[QUAN_SIZE*65+bit_index],v2c_bs_in[QUAN_SIZE*64+bit_index],v2c_bs_in[QUAN_SIZE*63+bit_index],v2c_bs_in[QUAN_SIZE*62+bit_index],v2c_bs_in[QUAN_SIZE*61+bit_index],v2c_bs_in[QUAN_SIZE*60+bit_index],v2c_bs_in[QUAN_SIZE*59+bit_index],v2c_bs_in[QUAN_SIZE*58+bit_index],v2c_bs_in[QUAN_SIZE*57+bit_index],v2c_bs_in[QUAN_SIZE*56+bit_index],v2c_bs_in[QUAN_SIZE*55+bit_index],v2c_bs_in[QUAN_SIZE*54+bit_index],v2c_bs_in[QUAN_SIZE*53+bit_index],v2c_bs_in[QUAN_SIZE*52+bit_index],v2c_bs_in[QUAN_SIZE*51+bit_index],v2c_bs_in[QUAN_SIZE*50+bit_index],v2c_bs_in[QUAN_SIZE*49+bit_index],v2c_bs_in[QUAN_SIZE*48+bit_index],v2c_bs_in[QUAN_SIZE*47+bit_index],v2c_bs_in[QUAN_SIZE*46+bit_index],v2c_bs_in[QUAN_SIZE*45+bit_index],v2c_bs_in[QUAN_SIZE*44+bit_index],v2c_bs_in[QUAN_SIZE*43+bit_index],v2c_bs_in[QUAN_SIZE*42+bit_index],v2c_bs_in[QUAN_SIZE*41+bit_index],v2c_bs_in[QUAN_SIZE*40+bit_index],v2c_bs_in[QUAN_SIZE*39+bit_index],v2c_bs_in[QUAN_SIZE*38+bit_index],v2c_bs_in[QUAN_SIZE*37+bit_index],v2c_bs_in[QUAN_SIZE*36+bit_index],v2c_bs_in[QUAN_SIZE*35+bit_index],v2c_bs_in[QUAN_SIZE*34+bit_index],v2c_bs_in[QUAN_SIZE*33+bit_index],v2c_bs_in[QUAN_SIZE*32+bit_index],v2c_bs_in[QUAN_SIZE*31+bit_index],v2c_bs_in[QUAN_SIZE*30+bit_index],v2c_bs_in[QUAN_SIZE*29+bit_index],v2c_bs_in[QUAN_SIZE*28+bit_index],v2c_bs_in[QUAN_SIZE*27+bit_index],v2c_bs_in[QUAN_SIZE*26+bit_index],v2c_bs_in[QUAN_SIZE*25+bit_index],v2c_bs_in[QUAN_SIZE*24+bit_index],v2c_bs_in[QUAN_SIZE*23+bit_index],v2c_bs_in[QUAN_SIZE*22+bit_index],v2c_bs_in[QUAN_SIZE*21+bit_index],v2c_bs_in[QUAN_SIZE*20+bit_index],v2c_bs_in[QUAN_SIZE*19+bit_index],v2c_bs_in[QUAN_SIZE*18+bit_index],v2c_bs_in[QUAN_SIZE*17+bit_index],v2c_bs_in[QUAN_SIZE*16+bit_index],v2c_bs_in[QUAN_SIZE*15+bit_index],v2c_bs_in[QUAN_SIZE*14+bit_index],v2c_bs_in[QUAN_SIZE*13+bit_index],v2c_bs_in[QUAN_SIZE*12+bit_index],v2c_bs_in[QUAN_SIZE*11+bit_index],v2c_bs_in[QUAN_SIZE*10+bit_index],v2c_bs_in[QUAN_SIZE*9+bit_index],v2c_bs_in[QUAN_SIZE*8+bit_index],v2c_bs_in[QUAN_SIZE*7+bit_index],v2c_bs_in[QUAN_SIZE*6+bit_index],v2c_bs_in[QUAN_SIZE*5+bit_index],v2c_bs_in[QUAN_SIZE*4+bit_index],v2c_bs_in[QUAN_SIZE*3+bit_index],v2c_bs_in[QUAN_SIZE*2+bit_index],v2c_bs_in[QUAN_SIZE*1+bit_index],v2c_bs_in[QUAN_SIZE*0+bit_index]};
		assign ch_bs_in_bit[bit_index]  = { ch_bs_in[QUAN_SIZE*84+bit_index], ch_bs_in[QUAN_SIZE*83+bit_index], ch_bs_in[QUAN_SIZE*82+bit_index], ch_bs_in[QUAN_SIZE*81+bit_index], ch_bs_in[QUAN_SIZE*80+bit_index], ch_bs_in[QUAN_SIZE*79+bit_index], ch_bs_in[QUAN_SIZE*78+bit_index], ch_bs_in[QUAN_SIZE*77+bit_index], ch_bs_in[QUAN_SIZE*76+bit_index], ch_bs_in[QUAN_SIZE*75+bit_index], ch_bs_in[QUAN_SIZE*74+bit_index], ch_bs_in[QUAN_SIZE*73+bit_index], ch_bs_in[QUAN_SIZE*72+bit_index], ch_bs_in[QUAN_SIZE*71+bit_index], ch_bs_in[QUAN_SIZE*70+bit_index], ch_bs_in[QUAN_SIZE*69+bit_index], ch_bs_in[QUAN_SIZE*68+bit_index], ch_bs_in[QUAN_SIZE*67+bit_index], ch_bs_in[QUAN_SIZE*66+bit_index], ch_bs_in[QUAN_SIZE*65+bit_index], ch_bs_in[QUAN_SIZE*64+bit_index], ch_bs_in[QUAN_SIZE*63+bit_index], ch_bs_in[QUAN_SIZE*62+bit_index], ch_bs_in[QUAN_SIZE*61+bit_index], ch_bs_in[QUAN_SIZE*60+bit_index], ch_bs_in[QUAN_SIZE*59+bit_index], ch_bs_in[QUAN_SIZE*58+bit_index], ch_bs_in[QUAN_SIZE*57+bit_index], ch_bs_in[QUAN_SIZE*56+bit_index], ch_bs_in[QUAN_SIZE*55+bit_index], ch_bs_in[QUAN_SIZE*54+bit_index], ch_bs_in[QUAN_SIZE*53+bit_index], ch_bs_in[QUAN_SIZE*52+bit_index], ch_bs_in[QUAN_SIZE*51+bit_index], ch_bs_in[QUAN_SIZE*50+bit_index], ch_bs_in[QUAN_SIZE*49+bit_index], ch_bs_in[QUAN_SIZE*48+bit_index], ch_bs_in[QUAN_SIZE*47+bit_index], ch_bs_in[QUAN_SIZE*46+bit_index], ch_bs_in[QUAN_SIZE*45+bit_index], ch_bs_in[QUAN_SIZE*44+bit_index], ch_bs_in[QUAN_SIZE*43+bit_index], ch_bs_in[QUAN_SIZE*42+bit_index], ch_bs_in[QUAN_SIZE*41+bit_index], ch_bs_in[QUAN_SIZE*40+bit_index], ch_bs_in[QUAN_SIZE*39+bit_index], ch_bs_in[QUAN_SIZE*38+bit_index], ch_bs_in[QUAN_SIZE*37+bit_index], ch_bs_in[QUAN_SIZE*36+bit_index], ch_bs_in[QUAN_SIZE*35+bit_index], ch_bs_in[QUAN_SIZE*34+bit_index], ch_bs_in[QUAN_SIZE*33+bit_index], ch_bs_in[QUAN_SIZE*32+bit_index], ch_bs_in[QUAN_SIZE*31+bit_index], ch_bs_in[QUAN_SIZE*30+bit_index], ch_bs_in[QUAN_SIZE*29+bit_index], ch_bs_in[QUAN_SIZE*28+bit_index], ch_bs_in[QUAN_SIZE*27+bit_index], ch_bs_in[QUAN_SIZE*26+bit_index], ch_bs_in[QUAN_SIZE*25+bit_index], ch_bs_in[QUAN_SIZE*24+bit_index], ch_bs_in[QUAN_SIZE*23+bit_index], ch_bs_in[QUAN_SIZE*22+bit_index], ch_bs_in[QUAN_SIZE*21+bit_index], ch_bs_in[QUAN_SIZE*20+bit_index], ch_bs_in[QUAN_SIZE*19+bit_index], ch_bs_in[QUAN_SIZE*18+bit_index], ch_bs_in[QUAN_SIZE*17+bit_index], ch_bs_in[QUAN_SIZE*16+bit_index], ch_bs_in[QUAN_SIZE*15+bit_index], ch_bs_in[QUAN_SIZE*14+bit_index], ch_bs_in[QUAN_SIZE*13+bit_index], ch_bs_in[QUAN_SIZE*12+bit_index], ch_bs_in[QUAN_SIZE*11+bit_index], ch_bs_in[QUAN_SIZE*10+bit_index], ch_bs_in[QUAN_SIZE*9+bit_index], ch_bs_in[QUAN_SIZE*8+bit_index], ch_bs_in[QUAN_SIZE*7+bit_index], ch_bs_in[QUAN_SIZE*6+bit_index], ch_bs_in[QUAN_SIZE*5+bit_index], ch_bs_in[QUAN_SIZE*4+bit_index], ch_bs_in[QUAN_SIZE*3+bit_index], ch_bs_in[QUAN_SIZE*2+bit_index],ch_bs_in[QUAN_SIZE*1+bit_index], ch_bs_in[QUAN_SIZE*0+bit_index]};
	end
endgenerate
/*----------------------------------------------*/	
// Circular shifter of check nodes 
qsn_top_85b cnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({cnu_msg_in[84][0],cnu_msg_in[83][0],cnu_msg_in[82][0],cnu_msg_in[81][0],cnu_msg_in[80][0],cnu_msg_in[79][0],cnu_msg_in[78][0],cnu_msg_in[77][0],cnu_msg_in[76][0],cnu_msg_in[75][0],cnu_msg_in[74][0],cnu_msg_in[73][0],cnu_msg_in[72][0],cnu_msg_in[71][0],cnu_msg_in[70][0],cnu_msg_in[69][0],cnu_msg_in[68][0],cnu_msg_in[67][0],cnu_msg_in[66][0],cnu_msg_in[65][0],cnu_msg_in[64][0],cnu_msg_in[63][0],cnu_msg_in[62][0],cnu_msg_in[61][0],cnu_msg_in[60][0],cnu_msg_in[59][0],cnu_msg_in[58][0],cnu_msg_in[57][0],cnu_msg_in[56][0],cnu_msg_in[55][0],cnu_msg_in[54][0],cnu_msg_in[53][0],cnu_msg_in[52][0],cnu_msg_in[51][0],cnu_msg_in[50][0],cnu_msg_in[49][0],cnu_msg_in[48][0],cnu_msg_in[47][0],cnu_msg_in[46][0],cnu_msg_in[45][0],cnu_msg_in[44][0],cnu_msg_in[43][0],cnu_msg_in[42][0],cnu_msg_in[41][0],cnu_msg_in[40][0],cnu_msg_in[39][0],cnu_msg_in[38][0],cnu_msg_in[37][0],cnu_msg_in[36][0],cnu_msg_in[35][0],cnu_msg_in[34][0],cnu_msg_in[33][0],cnu_msg_in[32][0],cnu_msg_in[31][0],cnu_msg_in[30][0],cnu_msg_in[29][0],cnu_msg_in[28][0],cnu_msg_in[27][0],cnu_msg_in[26][0],cnu_msg_in[25][0],cnu_msg_in[24][0],cnu_msg_in[23][0],cnu_msg_in[22][0],cnu_msg_in[21][0],cnu_msg_in[20][0],cnu_msg_in[19][0],cnu_msg_in[18][0],cnu_msg_in[17][0],cnu_msg_in[16][0],cnu_msg_in[15][0],cnu_msg_in[14][0],cnu_msg_in[13][0],cnu_msg_in[12][0],cnu_msg_in[11][0],cnu_msg_in[10][0],cnu_msg_in[9][0],cnu_msg_in[8][0],cnu_msg_in[7][0],cnu_msg_in[6][0],cnu_msg_in[5][0],cnu_msg_in[4][0],cnu_msg_in[3][0],cnu_msg_in[2][0],cnu_msg_in[1][0],cnu_msg_in[0][0]}),
	.sw_out_bit1 ({cnu_msg_in[84][1],cnu_msg_in[83][1],cnu_msg_in[82][1],cnu_msg_in[81][1],cnu_msg_in[80][1],cnu_msg_in[79][1],cnu_msg_in[78][1],cnu_msg_in[77][1],cnu_msg_in[76][1],cnu_msg_in[75][1],cnu_msg_in[74][1],cnu_msg_in[73][1],cnu_msg_in[72][1],cnu_msg_in[71][1],cnu_msg_in[70][1],cnu_msg_in[69][1],cnu_msg_in[68][1],cnu_msg_in[67][1],cnu_msg_in[66][1],cnu_msg_in[65][1],cnu_msg_in[64][1],cnu_msg_in[63][1],cnu_msg_in[62][1],cnu_msg_in[61][1],cnu_msg_in[60][1],cnu_msg_in[59][1],cnu_msg_in[58][1],cnu_msg_in[57][1],cnu_msg_in[56][1],cnu_msg_in[55][1],cnu_msg_in[54][1],cnu_msg_in[53][1],cnu_msg_in[52][1],cnu_msg_in[51][1],cnu_msg_in[50][1],cnu_msg_in[49][1],cnu_msg_in[48][1],cnu_msg_in[47][1],cnu_msg_in[46][1],cnu_msg_in[45][1],cnu_msg_in[44][1],cnu_msg_in[43][1],cnu_msg_in[42][1],cnu_msg_in[41][1],cnu_msg_in[40][1],cnu_msg_in[39][1],cnu_msg_in[38][1],cnu_msg_in[37][1],cnu_msg_in[36][1],cnu_msg_in[35][1],cnu_msg_in[34][1],cnu_msg_in[33][1],cnu_msg_in[32][1],cnu_msg_in[31][1],cnu_msg_in[30][1],cnu_msg_in[29][1],cnu_msg_in[28][1],cnu_msg_in[27][1],cnu_msg_in[26][1],cnu_msg_in[25][1],cnu_msg_in[24][1],cnu_msg_in[23][1],cnu_msg_in[22][1],cnu_msg_in[21][1],cnu_msg_in[20][1],cnu_msg_in[19][1],cnu_msg_in[18][1],cnu_msg_in[17][1],cnu_msg_in[16][1],cnu_msg_in[15][1],cnu_msg_in[14][1],cnu_msg_in[13][1],cnu_msg_in[12][1],cnu_msg_in[11][1],cnu_msg_in[10][1],cnu_msg_in[9][1],cnu_msg_in[8][1],cnu_msg_in[7][1],cnu_msg_in[6][1],cnu_msg_in[5][1],cnu_msg_in[4][1],cnu_msg_in[3][1],cnu_msg_in[2][1],cnu_msg_in[1][1],cnu_msg_in[0][1]}),
	.sw_out_bit2 ({cnu_msg_in[84][2],cnu_msg_in[83][2],cnu_msg_in[82][2],cnu_msg_in[81][2],cnu_msg_in[80][2],cnu_msg_in[79][2],cnu_msg_in[78][2],cnu_msg_in[77][2],cnu_msg_in[76][2],cnu_msg_in[75][2],cnu_msg_in[74][2],cnu_msg_in[73][2],cnu_msg_in[72][2],cnu_msg_in[71][2],cnu_msg_in[70][2],cnu_msg_in[69][2],cnu_msg_in[68][2],cnu_msg_in[67][2],cnu_msg_in[66][2],cnu_msg_in[65][2],cnu_msg_in[64][2],cnu_msg_in[63][2],cnu_msg_in[62][2],cnu_msg_in[61][2],cnu_msg_in[60][2],cnu_msg_in[59][2],cnu_msg_in[58][2],cnu_msg_in[57][2],cnu_msg_in[56][2],cnu_msg_in[55][2],cnu_msg_in[54][2],cnu_msg_in[53][2],cnu_msg_in[52][2],cnu_msg_in[51][2],cnu_msg_in[50][2],cnu_msg_in[49][2],cnu_msg_in[48][2],cnu_msg_in[47][2],cnu_msg_in[46][2],cnu_msg_in[45][2],cnu_msg_in[44][2],cnu_msg_in[43][2],cnu_msg_in[42][2],cnu_msg_in[41][2],cnu_msg_in[40][2],cnu_msg_in[39][2],cnu_msg_in[38][2],cnu_msg_in[37][2],cnu_msg_in[36][2],cnu_msg_in[35][2],cnu_msg_in[34][2],cnu_msg_in[33][2],cnu_msg_in[32][2],cnu_msg_in[31][2],cnu_msg_in[30][2],cnu_msg_in[29][2],cnu_msg_in[28][2],cnu_msg_in[27][2],cnu_msg_in[26][2],cnu_msg_in[25][2],cnu_msg_in[24][2],cnu_msg_in[23][2],cnu_msg_in[22][2],cnu_msg_in[21][2],cnu_msg_in[20][2],cnu_msg_in[19][2],cnu_msg_in[18][2],cnu_msg_in[17][2],cnu_msg_in[16][2],cnu_msg_in[15][2],cnu_msg_in[14][2],cnu_msg_in[13][2],cnu_msg_in[12][2],cnu_msg_in[11][2],cnu_msg_in[10][2],cnu_msg_in[9][2],cnu_msg_in[8][2],cnu_msg_in[7][2],cnu_msg_in[6][2],cnu_msg_in[5][2],cnu_msg_in[4][2],cnu_msg_in[3][2],cnu_msg_in[2][2],cnu_msg_in[1][2],cnu_msg_in[0][2]}),	
	.sw_out_bit3 ({cnu_msg_in[84][3],cnu_msg_in[83][3],cnu_msg_in[82][3],cnu_msg_in[81][3],cnu_msg_in[80][3],cnu_msg_in[79][3],cnu_msg_in[78][3],cnu_msg_in[77][3],cnu_msg_in[76][3],cnu_msg_in[75][3],cnu_msg_in[74][3],cnu_msg_in[73][3],cnu_msg_in[72][3],cnu_msg_in[71][3],cnu_msg_in[70][3],cnu_msg_in[69][3],cnu_msg_in[68][3],cnu_msg_in[67][3],cnu_msg_in[66][3],cnu_msg_in[65][3],cnu_msg_in[64][3],cnu_msg_in[63][3],cnu_msg_in[62][3],cnu_msg_in[61][3],cnu_msg_in[60][3],cnu_msg_in[59][3],cnu_msg_in[58][3],cnu_msg_in[57][3],cnu_msg_in[56][3],cnu_msg_in[55][3],cnu_msg_in[54][3],cnu_msg_in[53][3],cnu_msg_in[52][3],cnu_msg_in[51][3],cnu_msg_in[50][3],cnu_msg_in[49][3],cnu_msg_in[48][3],cnu_msg_in[47][3],cnu_msg_in[46][3],cnu_msg_in[45][3],cnu_msg_in[44][3],cnu_msg_in[43][3],cnu_msg_in[42][3],cnu_msg_in[41][3],cnu_msg_in[40][3],cnu_msg_in[39][3],cnu_msg_in[38][3],cnu_msg_in[37][3],cnu_msg_in[36][3],cnu_msg_in[35][3],cnu_msg_in[34][3],cnu_msg_in[33][3],cnu_msg_in[32][3],cnu_msg_in[31][3],cnu_msg_in[30][3],cnu_msg_in[29][3],cnu_msg_in[28][3],cnu_msg_in[27][3],cnu_msg_in[26][3],cnu_msg_in[25][3],cnu_msg_in[24][3],cnu_msg_in[23][3],cnu_msg_in[22][3],cnu_msg_in[21][3],cnu_msg_in[20][3],cnu_msg_in[19][3],cnu_msg_in[18][3],cnu_msg_in[17][3],cnu_msg_in[16][3],cnu_msg_in[15][3],cnu_msg_in[14][3],cnu_msg_in[13][3],cnu_msg_in[12][3],cnu_msg_in[11][3],cnu_msg_in[10][3],cnu_msg_in[9][3],cnu_msg_in[8][3],cnu_msg_in[7][3],cnu_msg_in[6][3],cnu_msg_in[5][3],cnu_msg_in[4][3],cnu_msg_in[3][3],cnu_msg_in[2][3],cnu_msg_in[1][3],cnu_msg_in[0][3]}),
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in_bit0  (cnu_bs_in_bit[0]),
	.sw_in_bit1  (cnu_bs_in_bit[1]),
	.sw_in_bit2  (cnu_bs_in_bit[2]),
	.sw_in_bit3  (cnu_bs_in_bit[3]),
	.left_sel    (cnu_left_sel),
	.right_sel   (cnu_right_sel),
	.merge_sel   (cnu_merge_sel)
);
qsn_controller_85b #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) cnu_qsn_controller_85b (
	.left_sel     (cnu_left_sel ),
	.right_sel    (cnu_right_sel),
	.merge_sel    (cnu_merge_sel),
	.shift_factor (c2v_shift_factor_cur_0), // offset shift factor of submatrix_1
	.rstn         (rstn),
	.sys_clk      (read_clk)
);
/*----------------------------------------------*/
// Circular shifter of variable nodes 
shared_qsn_top_85b #(
		.QUAN_SIZE(QUAN_SIZE),
		.CHECK_PARALLELISM(CHECK_PARALLELISM),
		.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR)
) inst_shared_qsn_top_85b (
	.sw_out_bit0 ({vnu_msg_in[84][0],vnu_msg_in[83][0],vnu_msg_in[82][0],vnu_msg_in[81][0],vnu_msg_in[80][0],vnu_msg_in[79][0],vnu_msg_in[78][0],vnu_msg_in[77][0],vnu_msg_in[76][0],vnu_msg_in[75][0],vnu_msg_in[74][0],vnu_msg_in[73][0],vnu_msg_in[72][0],vnu_msg_in[71][0],vnu_msg_in[70][0],vnu_msg_in[69][0],vnu_msg_in[68][0],vnu_msg_in[67][0],vnu_msg_in[66][0],vnu_msg_in[65][0],vnu_msg_in[64][0],vnu_msg_in[63][0],vnu_msg_in[62][0],vnu_msg_in[61][0],vnu_msg_in[60][0],vnu_msg_in[59][0],vnu_msg_in[58][0],vnu_msg_in[57][0],vnu_msg_in[56][0],vnu_msg_in[55][0],vnu_msg_in[54][0],vnu_msg_in[53][0],vnu_msg_in[52][0],vnu_msg_in[51][0],vnu_msg_in[50][0],vnu_msg_in[49][0],vnu_msg_in[48][0],vnu_msg_in[47][0],vnu_msg_in[46][0],vnu_msg_in[45][0],vnu_msg_in[44][0],vnu_msg_in[43][0],vnu_msg_in[42][0],vnu_msg_in[41][0],vnu_msg_in[40][0],vnu_msg_in[39][0],vnu_msg_in[38][0],vnu_msg_in[37][0],vnu_msg_in[36][0],vnu_msg_in[35][0],vnu_msg_in[34][0],vnu_msg_in[33][0],vnu_msg_in[32][0],vnu_msg_in[31][0],vnu_msg_in[30][0],vnu_msg_in[29][0],vnu_msg_in[28][0],vnu_msg_in[27][0],vnu_msg_in[26][0],vnu_msg_in[25][0],vnu_msg_in[24][0],vnu_msg_in[23][0],vnu_msg_in[22][0],vnu_msg_in[21][0],vnu_msg_in[20][0],vnu_msg_in[19][0],vnu_msg_in[18][0],vnu_msg_in[17][0],vnu_msg_in[16][0],vnu_msg_in[15][0],vnu_msg_in[14][0],vnu_msg_in[13][0],vnu_msg_in[12][0],vnu_msg_in[11][0],vnu_msg_in[10][0],vnu_msg_in[9][0],vnu_msg_in[8][0],vnu_msg_in[7][0],vnu_msg_in[6][0],vnu_msg_in[5][0],vnu_msg_in[4][0],vnu_msg_in[3][0],vnu_msg_in[2][0],vnu_msg_in[1][0],vnu_msg_in[0][0]}),	
	.sw_out_bit1 ({vnu_msg_in[84][1],vnu_msg_in[83][1],vnu_msg_in[82][1],vnu_msg_in[81][1],vnu_msg_in[80][1],vnu_msg_in[79][1],vnu_msg_in[78][1],vnu_msg_in[77][1],vnu_msg_in[76][1],vnu_msg_in[75][1],vnu_msg_in[74][1],vnu_msg_in[73][1],vnu_msg_in[72][1],vnu_msg_in[71][1],vnu_msg_in[70][1],vnu_msg_in[69][1],vnu_msg_in[68][1],vnu_msg_in[67][1],vnu_msg_in[66][1],vnu_msg_in[65][1],vnu_msg_in[64][1],vnu_msg_in[63][1],vnu_msg_in[62][1],vnu_msg_in[61][1],vnu_msg_in[60][1],vnu_msg_in[59][1],vnu_msg_in[58][1],vnu_msg_in[57][1],vnu_msg_in[56][1],vnu_msg_in[55][1],vnu_msg_in[54][1],vnu_msg_in[53][1],vnu_msg_in[52][1],vnu_msg_in[51][1],vnu_msg_in[50][1],vnu_msg_in[49][1],vnu_msg_in[48][1],vnu_msg_in[47][1],vnu_msg_in[46][1],vnu_msg_in[45][1],vnu_msg_in[44][1],vnu_msg_in[43][1],vnu_msg_in[42][1],vnu_msg_in[41][1],vnu_msg_in[40][1],vnu_msg_in[39][1],vnu_msg_in[38][1],vnu_msg_in[37][1],vnu_msg_in[36][1],vnu_msg_in[35][1],vnu_msg_in[34][1],vnu_msg_in[33][1],vnu_msg_in[32][1],vnu_msg_in[31][1],vnu_msg_in[30][1],vnu_msg_in[29][1],vnu_msg_in[28][1],vnu_msg_in[27][1],vnu_msg_in[26][1],vnu_msg_in[25][1],vnu_msg_in[24][1],vnu_msg_in[23][1],vnu_msg_in[22][1],vnu_msg_in[21][1],vnu_msg_in[20][1],vnu_msg_in[19][1],vnu_msg_in[18][1],vnu_msg_in[17][1],vnu_msg_in[16][1],vnu_msg_in[15][1],vnu_msg_in[14][1],vnu_msg_in[13][1],vnu_msg_in[12][1],vnu_msg_in[11][1],vnu_msg_in[10][1],vnu_msg_in[9][1],vnu_msg_in[8][1],vnu_msg_in[7][1],vnu_msg_in[6][1],vnu_msg_in[5][1],vnu_msg_in[4][1],vnu_msg_in[3][1],vnu_msg_in[2][1],vnu_msg_in[1][1],vnu_msg_in[0][1]}),	
	.sw_out_bit2 ({vnu_msg_in[84][2],vnu_msg_in[83][2],vnu_msg_in[82][2],vnu_msg_in[81][2],vnu_msg_in[80][2],vnu_msg_in[79][2],vnu_msg_in[78][2],vnu_msg_in[77][2],vnu_msg_in[76][2],vnu_msg_in[75][2],vnu_msg_in[74][2],vnu_msg_in[73][2],vnu_msg_in[72][2],vnu_msg_in[71][2],vnu_msg_in[70][2],vnu_msg_in[69][2],vnu_msg_in[68][2],vnu_msg_in[67][2],vnu_msg_in[66][2],vnu_msg_in[65][2],vnu_msg_in[64][2],vnu_msg_in[63][2],vnu_msg_in[62][2],vnu_msg_in[61][2],vnu_msg_in[60][2],vnu_msg_in[59][2],vnu_msg_in[58][2],vnu_msg_in[57][2],vnu_msg_in[56][2],vnu_msg_in[55][2],vnu_msg_in[54][2],vnu_msg_in[53][2],vnu_msg_in[52][2],vnu_msg_in[51][2],vnu_msg_in[50][2],vnu_msg_in[49][2],vnu_msg_in[48][2],vnu_msg_in[47][2],vnu_msg_in[46][2],vnu_msg_in[45][2],vnu_msg_in[44][2],vnu_msg_in[43][2],vnu_msg_in[42][2],vnu_msg_in[41][2],vnu_msg_in[40][2],vnu_msg_in[39][2],vnu_msg_in[38][2],vnu_msg_in[37][2],vnu_msg_in[36][2],vnu_msg_in[35][2],vnu_msg_in[34][2],vnu_msg_in[33][2],vnu_msg_in[32][2],vnu_msg_in[31][2],vnu_msg_in[30][2],vnu_msg_in[29][2],vnu_msg_in[28][2],vnu_msg_in[27][2],vnu_msg_in[26][2],vnu_msg_in[25][2],vnu_msg_in[24][2],vnu_msg_in[23][2],vnu_msg_in[22][2],vnu_msg_in[21][2],vnu_msg_in[20][2],vnu_msg_in[19][2],vnu_msg_in[18][2],vnu_msg_in[17][2],vnu_msg_in[16][2],vnu_msg_in[15][2],vnu_msg_in[14][2],vnu_msg_in[13][2],vnu_msg_in[12][2],vnu_msg_in[11][2],vnu_msg_in[10][2],vnu_msg_in[9][2],vnu_msg_in[8][2],vnu_msg_in[7][2],vnu_msg_in[6][2],vnu_msg_in[5][2],vnu_msg_in[4][2],vnu_msg_in[3][2],vnu_msg_in[2][2],vnu_msg_in[1][2],vnu_msg_in[0][2]}),	
	.sw_out_bit3 ({vnu_msg_in[84][3],vnu_msg_in[83][3],vnu_msg_in[82][3],vnu_msg_in[81][3],vnu_msg_in[80][3],vnu_msg_in[79][3],vnu_msg_in[78][3],vnu_msg_in[77][3],vnu_msg_in[76][3],vnu_msg_in[75][3],vnu_msg_in[74][3],vnu_msg_in[73][3],vnu_msg_in[72][3],vnu_msg_in[71][3],vnu_msg_in[70][3],vnu_msg_in[69][3],vnu_msg_in[68][3],vnu_msg_in[67][3],vnu_msg_in[66][3],vnu_msg_in[65][3],vnu_msg_in[64][3],vnu_msg_in[63][3],vnu_msg_in[62][3],vnu_msg_in[61][3],vnu_msg_in[60][3],vnu_msg_in[59][3],vnu_msg_in[58][3],vnu_msg_in[57][3],vnu_msg_in[56][3],vnu_msg_in[55][3],vnu_msg_in[54][3],vnu_msg_in[53][3],vnu_msg_in[52][3],vnu_msg_in[51][3],vnu_msg_in[50][3],vnu_msg_in[49][3],vnu_msg_in[48][3],vnu_msg_in[47][3],vnu_msg_in[46][3],vnu_msg_in[45][3],vnu_msg_in[44][3],vnu_msg_in[43][3],vnu_msg_in[42][3],vnu_msg_in[41][3],vnu_msg_in[40][3],vnu_msg_in[39][3],vnu_msg_in[38][3],vnu_msg_in[37][3],vnu_msg_in[36][3],vnu_msg_in[35][3],vnu_msg_in[34][3],vnu_msg_in[33][3],vnu_msg_in[32][3],vnu_msg_in[31][3],vnu_msg_in[30][3],vnu_msg_in[29][3],vnu_msg_in[28][3],vnu_msg_in[27][3],vnu_msg_in[26][3],vnu_msg_in[25][3],vnu_msg_in[24][3],vnu_msg_in[23][3],vnu_msg_in[22][3],vnu_msg_in[21][3],vnu_msg_in[20][3],vnu_msg_in[19][3],vnu_msg_in[18][3],vnu_msg_in[17][3],vnu_msg_in[16][3],vnu_msg_in[15][3],vnu_msg_in[14][3],vnu_msg_in[13][3],vnu_msg_in[12][3],vnu_msg_in[11][3],vnu_msg_in[10][3],vnu_msg_in[9][3],vnu_msg_in[8][3],vnu_msg_in[7][3],vnu_msg_in[6][3],vnu_msg_in[5][3],vnu_msg_in[4][3],vnu_msg_in[3][3],vnu_msg_in[2][3],vnu_msg_in[1][3],vnu_msg_in[0][3]}),	
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in0_bit0  (vnu_bs_in_bit[0]),
	.sw_in0_bit1  (vnu_bs_in_bit[1]),
	.sw_in0_bit2  (vnu_bs_in_bit[2]),
	.sw_in0_bit3  (vnu_bs_in_bit[3]),

	.sw_in1_bit0 (ch_bs_in_bit[0]),
	.sw_in1_bit1 (ch_bs_in_bit[1]),
	.sw_in1_bit2 (ch_bs_in_bit[2]),
	.sw_in1_bit3 (ch_bs_in_bit[3]),

	.sw_in2_bit0 (dnu_inRotate_bit),

	.shift_factor (v2c_shift_factor_cur_0), // offset shift factor of submatrix
	.sw_in_src (vnu_bs_src),
	.sw_in_bit0_src (vnu_bs_bit0_src)
);
/*----------------------------------------------*/	
	reg [ADDR_WIDTH-1:0] c2v_mem_page_addr;
	reg [ADDR_WIDTH-1:0] v2c_mem_page_addr;
	mem_subsystem_top_submatrix_3 #(
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
		) inst_mem_subsystem_top_submatrix_3 (
			.mem_to_vnu_0     (mem_to_vnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_vnu_1     (mem_to_vnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_vnu_2     (mem_to_vnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_vnu_3     (mem_to_vnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_vnu_4     (mem_to_vnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_vnu_5     (mem_to_vnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_vnu_6     (mem_to_vnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_vnu_7     (mem_to_vnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_vnu_8     (mem_to_vnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_vnu_9     (mem_to_vnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_vnu_10    (mem_to_vnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_vnu_11    (mem_to_vnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_vnu_12    (mem_to_vnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_vnu_13    (mem_to_vnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_vnu_14    (mem_to_vnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_vnu_15    (mem_to_vnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_vnu_16    (mem_to_vnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_vnu_17    (mem_to_vnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_vnu_18    (mem_to_vnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_vnu_19    (mem_to_vnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_vnu_20    (mem_to_vnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_vnu_21    (mem_to_vnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_vnu_22    (mem_to_vnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_vnu_23    (mem_to_vnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_vnu_24    (mem_to_vnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_vnu_25    (mem_to_vnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_vnu_26    (mem_to_vnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_vnu_27    (mem_to_vnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_vnu_28    (mem_to_vnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_vnu_29    (mem_to_vnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_vnu_30    (mem_to_vnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_vnu_31    (mem_to_vnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_vnu_32    (mem_to_vnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_vnu_33    (mem_to_vnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_vnu_34    (mem_to_vnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_vnu_35    (mem_to_vnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_vnu_36    (mem_to_vnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_vnu_37    (mem_to_vnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_vnu_38    (mem_to_vnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_vnu_39    (mem_to_vnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_vnu_40    (mem_to_vnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_vnu_41    (mem_to_vnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_vnu_42    (mem_to_vnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_vnu_43    (mem_to_vnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_vnu_44    (mem_to_vnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_vnu_45    (mem_to_vnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_vnu_46    (mem_to_vnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_vnu_47    (mem_to_vnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_vnu_48    (mem_to_vnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_vnu_49    (mem_to_vnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_vnu_50    (mem_to_vnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_vnu_51    (mem_to_vnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_vnu_52    (mem_to_vnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_vnu_53    (mem_to_vnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_vnu_54    (mem_to_vnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_vnu_55    (mem_to_vnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_vnu_56    (mem_to_vnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_vnu_57    (mem_to_vnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_vnu_58    (mem_to_vnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_vnu_59    (mem_to_vnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_vnu_60    (mem_to_vnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_vnu_61    (mem_to_vnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_vnu_62    (mem_to_vnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_vnu_63    (mem_to_vnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_vnu_64    (mem_to_vnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_vnu_65    (mem_to_vnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_vnu_66    (mem_to_vnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_vnu_67    (mem_to_vnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_vnu_68    (mem_to_vnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_vnu_69    (mem_to_vnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_vnu_70    (mem_to_vnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_vnu_71    (mem_to_vnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_vnu_72    (mem_to_vnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_vnu_73    (mem_to_vnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_vnu_74    (mem_to_vnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_vnu_75    (mem_to_vnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_vnu_76    (mem_to_vnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_vnu_77    (mem_to_vnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_vnu_78    (mem_to_vnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_vnu_79    (mem_to_vnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_vnu_80    (mem_to_vnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_vnu_81    (mem_to_vnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_vnu_82    (mem_to_vnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_vnu_83    (mem_to_vnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_vnu_84    (mem_to_vnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),
			.mem_to_cnu_0     (mem_to_cnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_cnu_1     (mem_to_cnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_cnu_2     (mem_to_cnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_cnu_3     (mem_to_cnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_cnu_4     (mem_to_cnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_cnu_5     (mem_to_cnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_cnu_6     (mem_to_cnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_cnu_7     (mem_to_cnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_cnu_8     (mem_to_cnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_cnu_9     (mem_to_cnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_cnu_10    (mem_to_cnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_cnu_11    (mem_to_cnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_cnu_12    (mem_to_cnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_cnu_13    (mem_to_cnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_cnu_14    (mem_to_cnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_cnu_15    (mem_to_cnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_cnu_16    (mem_to_cnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_cnu_17    (mem_to_cnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_cnu_18    (mem_to_cnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_cnu_19    (mem_to_cnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_cnu_20    (mem_to_cnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_cnu_21    (mem_to_cnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_cnu_22    (mem_to_cnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_cnu_23    (mem_to_cnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_cnu_24    (mem_to_cnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_cnu_25    (mem_to_cnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_cnu_26    (mem_to_cnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_cnu_27    (mem_to_cnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_cnu_28    (mem_to_cnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_cnu_29    (mem_to_cnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_cnu_30    (mem_to_cnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_cnu_31    (mem_to_cnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_cnu_32    (mem_to_cnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_cnu_33    (mem_to_cnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_cnu_34    (mem_to_cnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_cnu_35    (mem_to_cnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_cnu_36    (mem_to_cnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_cnu_37    (mem_to_cnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_cnu_38    (mem_to_cnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_cnu_39    (mem_to_cnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_cnu_40    (mem_to_cnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_cnu_41    (mem_to_cnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_cnu_42    (mem_to_cnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_cnu_43    (mem_to_cnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_cnu_44    (mem_to_cnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_cnu_45    (mem_to_cnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_cnu_46    (mem_to_cnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_cnu_47    (mem_to_cnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_cnu_48    (mem_to_cnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_cnu_49    (mem_to_cnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_cnu_50    (mem_to_cnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_cnu_51    (mem_to_cnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_cnu_52    (mem_to_cnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_cnu_53    (mem_to_cnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_cnu_54    (mem_to_cnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_cnu_55    (mem_to_cnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_cnu_56    (mem_to_cnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_cnu_57    (mem_to_cnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_cnu_58    (mem_to_cnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_cnu_59    (mem_to_cnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_cnu_60    (mem_to_cnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_cnu_61    (mem_to_cnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_cnu_62    (mem_to_cnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_cnu_63    (mem_to_cnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_cnu_64    (mem_to_cnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_cnu_65    (mem_to_cnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_cnu_66    (mem_to_cnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_cnu_67    (mem_to_cnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_cnu_68    (mem_to_cnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_cnu_69    (mem_to_cnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_cnu_70    (mem_to_cnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_cnu_71    (mem_to_cnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_cnu_72    (mem_to_cnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_cnu_73    (mem_to_cnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_cnu_74    (mem_to_cnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_cnu_75    (mem_to_cnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_cnu_76    (mem_to_cnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_cnu_77    (mem_to_cnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_cnu_78    (mem_to_cnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_cnu_79    (mem_to_cnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_cnu_80    (mem_to_cnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_cnu_81    (mem_to_cnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_cnu_82    (mem_to_cnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_cnu_83    (mem_to_cnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_cnu_84    (mem_to_cnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),

			.vnu_to_mem_0     (vnu_msg_in[0 ]),
			.vnu_to_mem_1     (vnu_msg_in[1 ]),
			.vnu_to_mem_2     (vnu_msg_in[2 ]),
			.vnu_to_mem_3     (vnu_msg_in[3 ]),
			.vnu_to_mem_4     (vnu_msg_in[4 ]),
			.vnu_to_mem_5     (vnu_msg_in[5 ]),
			.vnu_to_mem_6     (vnu_msg_in[6 ]),
			.vnu_to_mem_7     (vnu_msg_in[7 ]),
			.vnu_to_mem_8     (vnu_msg_in[8 ]),
			.vnu_to_mem_9     (vnu_msg_in[9 ]),
			.vnu_to_mem_10    (vnu_msg_in[10]),
			.vnu_to_mem_11    (vnu_msg_in[11]),
			.vnu_to_mem_12    (vnu_msg_in[12]),
			.vnu_to_mem_13    (vnu_msg_in[13]),
			.vnu_to_mem_14    (vnu_msg_in[14]),
			.vnu_to_mem_15    (vnu_msg_in[15]),
			.vnu_to_mem_16    (vnu_msg_in[16]),
			.vnu_to_mem_17    (vnu_msg_in[17]),
			.vnu_to_mem_18    (vnu_msg_in[18]),
			.vnu_to_mem_19    (vnu_msg_in[19]),
			.vnu_to_mem_20    (vnu_msg_in[20]),
			.vnu_to_mem_21    (vnu_msg_in[21]),
			.vnu_to_mem_22    (vnu_msg_in[22]),
			.vnu_to_mem_23    (vnu_msg_in[23]),
			.vnu_to_mem_24    (vnu_msg_in[24]),
			.vnu_to_mem_25    (vnu_msg_in[25]),
			.vnu_to_mem_26    (vnu_msg_in[26]),
			.vnu_to_mem_27    (vnu_msg_in[27]),
			.vnu_to_mem_28    (vnu_msg_in[28]),
			.vnu_to_mem_29    (vnu_msg_in[29]),
			.vnu_to_mem_30    (vnu_msg_in[30]),
			.vnu_to_mem_31    (vnu_msg_in[31]),
			.vnu_to_mem_32    (vnu_msg_in[32]),
			.vnu_to_mem_33    (vnu_msg_in[33]),
			.vnu_to_mem_34    (vnu_msg_in[34]),
			.vnu_to_mem_35    (vnu_msg_in[35]),
			.vnu_to_mem_36    (vnu_msg_in[36]),
			.vnu_to_mem_37    (vnu_msg_in[37]),
			.vnu_to_mem_38    (vnu_msg_in[38]),
			.vnu_to_mem_39    (vnu_msg_in[39]),
			.vnu_to_mem_40    (vnu_msg_in[40]),
			.vnu_to_mem_41    (vnu_msg_in[41]),
			.vnu_to_mem_42    (vnu_msg_in[42]),
			.vnu_to_mem_43    (vnu_msg_in[43]),
			.vnu_to_mem_44    (vnu_msg_in[44]),
			.vnu_to_mem_45    (vnu_msg_in[45]),
			.vnu_to_mem_46    (vnu_msg_in[46]),
			.vnu_to_mem_47    (vnu_msg_in[47]),
			.vnu_to_mem_48    (vnu_msg_in[48]),
			.vnu_to_mem_49    (vnu_msg_in[49]),
			.vnu_to_mem_50    (vnu_msg_in[50]),
			.vnu_to_mem_51    (vnu_msg_in[51]),
			.vnu_to_mem_52    (vnu_msg_in[52]),
			.vnu_to_mem_53    (vnu_msg_in[53]),
			.vnu_to_mem_54    (vnu_msg_in[54]),
			.vnu_to_mem_55    (vnu_msg_in[55]),
			.vnu_to_mem_56    (vnu_msg_in[56]),
			.vnu_to_mem_57    (vnu_msg_in[57]),
			.vnu_to_mem_58    (vnu_msg_in[58]),
			.vnu_to_mem_59    (vnu_msg_in[59]),
			.vnu_to_mem_60    (vnu_msg_in[60]),
			.vnu_to_mem_61    (vnu_msg_in[61]),
			.vnu_to_mem_62    (vnu_msg_in[62]),
			.vnu_to_mem_63    (vnu_msg_in[63]),
			.vnu_to_mem_64    (vnu_msg_in[64]),
			.vnu_to_mem_65    (vnu_msg_in[65]),
			.vnu_to_mem_66    (vnu_msg_in[66]),
			.vnu_to_mem_67    (vnu_msg_in[67]),
			.vnu_to_mem_68    (vnu_msg_in[68]),
			.vnu_to_mem_69    (vnu_msg_in[69]),
			.vnu_to_mem_70    (vnu_msg_in[70]),
			.vnu_to_mem_71    (vnu_msg_in[71]),
			.vnu_to_mem_72    (vnu_msg_in[72]),
			.vnu_to_mem_73    (vnu_msg_in[73]),
			.vnu_to_mem_74    (vnu_msg_in[74]),
			.vnu_to_mem_75    (vnu_msg_in[75]),
			.vnu_to_mem_76    (vnu_msg_in[76]),
			.vnu_to_mem_77    (vnu_msg_in[77]),
			.vnu_to_mem_78    (vnu_msg_in[78]),
			.vnu_to_mem_79    (vnu_msg_in[79]),
			.vnu_to_mem_80    (vnu_msg_in[80]),
			.vnu_to_mem_81    (vnu_msg_in[81]),
			.vnu_to_mem_82    (vnu_msg_in[82]),
			.vnu_to_mem_83    (vnu_msg_in[83]),
			.vnu_to_mem_84    (vnu_msg_in[84]),
			.cnu_to_mem_0     (cnu_msg_in[0 ]),
			.cnu_to_mem_1     (cnu_msg_in[1 ]),
			.cnu_to_mem_2     (cnu_msg_in[2 ]),
			.cnu_to_mem_3     (cnu_msg_in[3 ]),
			.cnu_to_mem_4     (cnu_msg_in[4 ]),
			.cnu_to_mem_5     (cnu_msg_in[5 ]),
			.cnu_to_mem_6     (cnu_msg_in[6 ]),
			.cnu_to_mem_7     (cnu_msg_in[7 ]),
			.cnu_to_mem_8     (cnu_msg_in[8 ]),
			.cnu_to_mem_9     (cnu_msg_in[9 ]),
			.cnu_to_mem_10    (cnu_msg_in[10]),
			.cnu_to_mem_11    (cnu_msg_in[11]),
			.cnu_to_mem_12    (cnu_msg_in[12]),
			.cnu_to_mem_13    (cnu_msg_in[13]),
			.cnu_to_mem_14    (cnu_msg_in[14]),
			.cnu_to_mem_15    (cnu_msg_in[15]),
			.cnu_to_mem_16    (cnu_msg_in[16]),
			.cnu_to_mem_17    (cnu_msg_in[17]),
			.cnu_to_mem_18    (cnu_msg_in[18]),
			.cnu_to_mem_19    (cnu_msg_in[19]),
			.cnu_to_mem_20    (cnu_msg_in[20]),
			.cnu_to_mem_21    (cnu_msg_in[21]),
			.cnu_to_mem_22    (cnu_msg_in[22]),
			.cnu_to_mem_23    (cnu_msg_in[23]),
			.cnu_to_mem_24    (cnu_msg_in[24]),
			.cnu_to_mem_25    (cnu_msg_in[25]),
			.cnu_to_mem_26    (cnu_msg_in[26]),
			.cnu_to_mem_27    (cnu_msg_in[27]),
			.cnu_to_mem_28    (cnu_msg_in[28]),
			.cnu_to_mem_29    (cnu_msg_in[29]),
			.cnu_to_mem_30    (cnu_msg_in[30]),
			.cnu_to_mem_31    (cnu_msg_in[31]),
			.cnu_to_mem_32    (cnu_msg_in[32]),
			.cnu_to_mem_33    (cnu_msg_in[33]),
			.cnu_to_mem_34    (cnu_msg_in[34]),
			.cnu_to_mem_35    (cnu_msg_in[35]),
			.cnu_to_mem_36    (cnu_msg_in[36]),
			.cnu_to_mem_37    (cnu_msg_in[37]),
			.cnu_to_mem_38    (cnu_msg_in[38]),
			.cnu_to_mem_39    (cnu_msg_in[39]),
			.cnu_to_mem_40    (cnu_msg_in[40]),
			.cnu_to_mem_41    (cnu_msg_in[41]),
			.cnu_to_mem_42    (cnu_msg_in[42]),
			.cnu_to_mem_43    (cnu_msg_in[43]),
			.cnu_to_mem_44    (cnu_msg_in[44]),
			.cnu_to_mem_45    (cnu_msg_in[45]),
			.cnu_to_mem_46    (cnu_msg_in[46]),
			.cnu_to_mem_47    (cnu_msg_in[47]),
			.cnu_to_mem_48    (cnu_msg_in[48]),
			.cnu_to_mem_49    (cnu_msg_in[49]),
			.cnu_to_mem_50    (cnu_msg_in[50]),
			.cnu_to_mem_51    (cnu_msg_in[51]),
			.cnu_to_mem_52    (cnu_msg_in[52]),
			.cnu_to_mem_53    (cnu_msg_in[53]),
			.cnu_to_mem_54    (cnu_msg_in[54]),
			.cnu_to_mem_55    (cnu_msg_in[55]),
			.cnu_to_mem_56    (cnu_msg_in[56]),
			.cnu_to_mem_57    (cnu_msg_in[57]),
			.cnu_to_mem_58    (cnu_msg_in[58]),
			.cnu_to_mem_59    (cnu_msg_in[59]),
			.cnu_to_mem_60    (cnu_msg_in[60]),
			.cnu_to_mem_61    (cnu_msg_in[61]),
			.cnu_to_mem_62    (cnu_msg_in[62]),
			.cnu_to_mem_63    (cnu_msg_in[63]),
			.cnu_to_mem_64    (cnu_msg_in[64]),
			.cnu_to_mem_65    (cnu_msg_in[65]),
			.cnu_to_mem_66    (cnu_msg_in[66]),
			.cnu_to_mem_67    (cnu_msg_in[67]),
			.cnu_to_mem_68    (cnu_msg_in[68]),
			.cnu_to_mem_69    (cnu_msg_in[69]),
			.cnu_to_mem_70    (cnu_msg_in[70]),
			.cnu_to_mem_71    (cnu_msg_in[71]),
			.cnu_to_mem_72    (cnu_msg_in[72]),
			.cnu_to_mem_73    (cnu_msg_in[73]),
			.cnu_to_mem_74    (cnu_msg_in[74]),
			.cnu_to_mem_75    (cnu_msg_in[75]),
			.cnu_to_mem_76    (cnu_msg_in[76]),
			.cnu_to_mem_77    (cnu_msg_in[77]),
			.cnu_to_mem_78    (cnu_msg_in[78]),
			.cnu_to_mem_79    (cnu_msg_in[79]),
			.cnu_to_mem_80    (cnu_msg_in[80]),
			.cnu_to_mem_81    (cnu_msg_in[81]),
			.cnu_to_mem_82    (cnu_msg_in[82]),
			.cnu_to_mem_83    (cnu_msg_in[83]),
			.cnu_to_mem_84    (cnu_msg_in[84]),
			.cnu_sync_addr    (cnu_mem_page_sync_addr),
			.vnu_sync_addr    (vnu_mem_page_sync_addr),
			.cnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.vnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.last_row_chunk   ({c2v_last_row_chunk, v2c_last_row_chunk}),
			.we               ({v2c_mem_we, c2v_mem_we}),
			.sys_clk          (read_clk),
			.rstn             (rstn)
		);
		assign cnu_mem_page_sync_addr = (v2c_mem_fetch == 1'b1) ? v2c_mem_page_rd_addr : 
										(c2v_mem_we == 1'b1) ? c2v_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.

		assign vnu_mem_page_sync_addr = (c2v_mem_fetch == 1'b1) ? c2v_mem_page_rd_addr : 
										(v2c_mem_we == 1'b1) ? v2c_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Check-to-Variable messages RAMs write-page addresses
	always @(posedge read_clk) begin
		if(rstn == 1'b0) 
			c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE;
		else if(c2v_mem_we == 1'b1) begin
			// page increment pattern within layer 0
			if(v2c_layer_cnt[0] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_1+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 1
			if(v2c_layer_cnt[1] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_2+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 2
			if(v2c_layer_cnt[2] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_2-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
		end
	end

	always @(posedge read_clk) begin
		if(rstn == 1'b0) begin
			c2v_shift_factor_cur_2 <= shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
		end
		else if(c2v_bs_en == 1'b1) begin
			c2v_shift_factor_cur_2 <= 0;
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
/*--------------------------------------------------------------------------*/
// Channel Buffers
reg [CH_DATA_WIDTH-1:0] ch_msg_genIn;
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_0 [0:CHECK_PARALLELISM-1]; // [0:84]
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_1 [0:CHECK_PARALLELISM-1]; // [0:84]
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_rd_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chInit_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chLayer_wr_addr;
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

			.din        (ch_msg_genIn[CH_DATA_WIDTH-1:0]),

			.read_addr  (submatrix_ch_ram_rd_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.write_addr (submatrix_ch_ram_wr_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.we         (ch_ram_we),
			.read_clk   (ch_ram_rd_clk),
			.write_clk  (ch_ram_wr_clk),
			.rstn       (rstn)
		);
		// Updating the Channel RAMs by either initally channel messages (from AWGNs) or circularly shifted channel messages
		assign submatrix_ch_ram_wr_addr = (ch_ram_init_we == 1'b1) ? submatrix_chInit_wr_addr :
														(ch_ram_wb == 1'b1     ) ? submatrix_chLayer_wr_addr : 
																				   CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.


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
	// Channel messages RAMs write-page addresses
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
endmodule

module msg_pass_submatrix_4_unit #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,
	parameter VN_DEGREE = 3,   // degree of one variable node
/*-------------------------------------------------------------------------------------*/
	// Parameters related to BS, PA and MEM
	parameter RAM_DEPTH = 1024,
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH),
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1),
	parameter shift_factor_0 = CHECK_PARALLELISM-71,
	parameter shift_factor_1 = CHECK_PARALLELISM-63,
	parameter shift_factor_2 = CHECK_PARALLELISM-8,

`ifdef SCHED_4_6
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,
	parameter C2V_MEM_ADDR_BASE = 0,
	parameter V2C_MEM_ADDR_BASE = ROW_CHUNK_NUM,
	parameter V2C_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter C2V_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH),
`endif
	parameter START_PAGE_1_0 = 2, // starting page address of layer 0 of submatrix_1
	parameter START_PAGE_1_1 = 8, // starting page address of layer 1 of submatrix_1
	parameter START_PAGE_1_2 = 1  // starting page address of layer 2 of submatrix_1
) (
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu,

	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit,

	// control signals
	input wire c2v_bs_en,
	input wire v2c_bs_en,
	input wire ch_bs_en,
	/*------------------------------*/
	// Control signals associative with message passing of channel buffer and DNU.SignExtension
	input wire ch_ram_init_we,
	input wire ch_ram_fetch,
	input wire v2c_outRotate_reg_we,
	input wire dnu_inRotate_bs_en,
	input wire dnu_inRotate_pa_en,
	input wire dnu_inRotate_wb,
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
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,

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
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_2;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_2;

wire [6:0]  cnu_left_sel;
wire [6:0]  cnu_right_sel;
wire [83:0] cnu_merge_sel;
wire [6:0]  vnu_left_sel;
wire [6:0]  vnu_right_sel;
wire [83:0] vnu_merge_sel;
wire [CHECK_PARALLELISM-1:0] cnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] vnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] ch_bs_in_bit [0:QUAN_SIZE-1];
genvar bit_index;
generate
	for(bit_index=0;bit_index<QUAN_SIZE;bit_index=bit_index+1) begin : extrinsic_msg_bs_in_inst
		assign cnu_bs_in_bit[bit_index] = {c2v_bs_in[QUAN_SIZE*84+bit_index],c2v_bs_in[QUAN_SIZE*83+bit_index],c2v_bs_in[QUAN_SIZE*82+bit_index],c2v_bs_in[QUAN_SIZE*81+bit_index],c2v_bs_in[QUAN_SIZE*80+bit_index],c2v_bs_in[QUAN_SIZE*79+bit_index],c2v_bs_in[QUAN_SIZE*78+bit_index],c2v_bs_in[QUAN_SIZE*77+bit_index],c2v_bs_in[QUAN_SIZE*76+bit_index],c2v_bs_in[QUAN_SIZE*75+bit_index],c2v_bs_in[QUAN_SIZE*74+bit_index],c2v_bs_in[QUAN_SIZE*73+bit_index],c2v_bs_in[QUAN_SIZE*72+bit_index],c2v_bs_in[QUAN_SIZE*71+bit_index],c2v_bs_in[QUAN_SIZE*70+bit_index],c2v_bs_in[QUAN_SIZE*69+bit_index],c2v_bs_in[QUAN_SIZE*68+bit_index],c2v_bs_in[QUAN_SIZE*67+bit_index],c2v_bs_in[QUAN_SIZE*66+bit_index],c2v_bs_in[QUAN_SIZE*65+bit_index],c2v_bs_in[QUAN_SIZE*64+bit_index],c2v_bs_in[QUAN_SIZE*63+bit_index],c2v_bs_in[QUAN_SIZE*62+bit_index],c2v_bs_in[QUAN_SIZE*61+bit_index],c2v_bs_in[QUAN_SIZE*60+bit_index],c2v_bs_in[QUAN_SIZE*59+bit_index],c2v_bs_in[QUAN_SIZE*58+bit_index],c2v_bs_in[QUAN_SIZE*57+bit_index],c2v_bs_in[QUAN_SIZE*56+bit_index],c2v_bs_in[QUAN_SIZE*55+bit_index],c2v_bs_in[QUAN_SIZE*54+bit_index],c2v_bs_in[QUAN_SIZE*53+bit_index],c2v_bs_in[QUAN_SIZE*52+bit_index],c2v_bs_in[QUAN_SIZE*51+bit_index],c2v_bs_in[QUAN_SIZE*50+bit_index],c2v_bs_in[QUAN_SIZE*49+bit_index],c2v_bs_in[QUAN_SIZE*48+bit_index],c2v_bs_in[QUAN_SIZE*47+bit_index],c2v_bs_in[QUAN_SIZE*46+bit_index],c2v_bs_in[QUAN_SIZE*45+bit_index],c2v_bs_in[QUAN_SIZE*44+bit_index],c2v_bs_in[QUAN_SIZE*43+bit_index],c2v_bs_in[QUAN_SIZE*42+bit_index],c2v_bs_in[QUAN_SIZE*41+bit_index],c2v_bs_in[QUAN_SIZE*40+bit_index],c2v_bs_in[QUAN_SIZE*39+bit_index],c2v_bs_in[QUAN_SIZE*38+bit_index],c2v_bs_in[QUAN_SIZE*37+bit_index],c2v_bs_in[QUAN_SIZE*36+bit_index],c2v_bs_in[QUAN_SIZE*35+bit_index],c2v_bs_in[QUAN_SIZE*34+bit_index],c2v_bs_in[QUAN_SIZE*33+bit_index],c2v_bs_in[QUAN_SIZE*32+bit_index],c2v_bs_in[QUAN_SIZE*31+bit_index],c2v_bs_in[QUAN_SIZE*30+bit_index],c2v_bs_in[QUAN_SIZE*29+bit_index],c2v_bs_in[QUAN_SIZE*28+bit_index],c2v_bs_in[QUAN_SIZE*27+bit_index],c2v_bs_in[QUAN_SIZE*26+bit_index],c2v_bs_in[QUAN_SIZE*25+bit_index],c2v_bs_in[QUAN_SIZE*24+bit_index],c2v_bs_in[QUAN_SIZE*23+bit_index],c2v_bs_in[QUAN_SIZE*22+bit_index],c2v_bs_in[QUAN_SIZE*21+bit_index],c2v_bs_in[QUAN_SIZE*20+bit_index],c2v_bs_in[QUAN_SIZE*19+bit_index],c2v_bs_in[QUAN_SIZE*18+bit_index],c2v_bs_in[QUAN_SIZE*17+bit_index],c2v_bs_in[QUAN_SIZE*16+bit_index],c2v_bs_in[QUAN_SIZE*15+bit_index],c2v_bs_in[QUAN_SIZE*14+bit_index],c2v_bs_in[QUAN_SIZE*13+bit_index],c2v_bs_in[QUAN_SIZE*12+bit_index],c2v_bs_in[QUAN_SIZE*11+bit_index],c2v_bs_in[QUAN_SIZE*10+bit_index],c2v_bs_in[QUAN_SIZE*9+bit_index],c2v_bs_in[QUAN_SIZE*8+bit_index],c2v_bs_in[QUAN_SIZE*7+bit_index],c2v_bs_in[QUAN_SIZE*6+bit_index],c2v_bs_in[QUAN_SIZE*5+bit_index],c2v_bs_in[QUAN_SIZE*4+bit_index],c2v_bs_in[QUAN_SIZE*3+bit_index],c2v_bs_in[QUAN_SIZE*2+bit_index],c2v_bs_in[QUAN_SIZE*1+bit_index],c2v_bs_in[QUAN_SIZE*0+bit_index]};
		assign vnu_bs_in_bit[bit_index] = {v2c_bs_in[QUAN_SIZE*84+bit_index],v2c_bs_in[QUAN_SIZE*83+bit_index],v2c_bs_in[QUAN_SIZE*82+bit_index],v2c_bs_in[QUAN_SIZE*81+bit_index],v2c_bs_in[QUAN_SIZE*80+bit_index],v2c_bs_in[QUAN_SIZE*79+bit_index],v2c_bs_in[QUAN_SIZE*78+bit_index],v2c_bs_in[QUAN_SIZE*77+bit_index],v2c_bs_in[QUAN_SIZE*76+bit_index],v2c_bs_in[QUAN_SIZE*75+bit_index],v2c_bs_in[QUAN_SIZE*74+bit_index],v2c_bs_in[QUAN_SIZE*73+bit_index],v2c_bs_in[QUAN_SIZE*72+bit_index],v2c_bs_in[QUAN_SIZE*71+bit_index],v2c_bs_in[QUAN_SIZE*70+bit_index],v2c_bs_in[QUAN_SIZE*69+bit_index],v2c_bs_in[QUAN_SIZE*68+bit_index],v2c_bs_in[QUAN_SIZE*67+bit_index],v2c_bs_in[QUAN_SIZE*66+bit_index],v2c_bs_in[QUAN_SIZE*65+bit_index],v2c_bs_in[QUAN_SIZE*64+bit_index],v2c_bs_in[QUAN_SIZE*63+bit_index],v2c_bs_in[QUAN_SIZE*62+bit_index],v2c_bs_in[QUAN_SIZE*61+bit_index],v2c_bs_in[QUAN_SIZE*60+bit_index],v2c_bs_in[QUAN_SIZE*59+bit_index],v2c_bs_in[QUAN_SIZE*58+bit_index],v2c_bs_in[QUAN_SIZE*57+bit_index],v2c_bs_in[QUAN_SIZE*56+bit_index],v2c_bs_in[QUAN_SIZE*55+bit_index],v2c_bs_in[QUAN_SIZE*54+bit_index],v2c_bs_in[QUAN_SIZE*53+bit_index],v2c_bs_in[QUAN_SIZE*52+bit_index],v2c_bs_in[QUAN_SIZE*51+bit_index],v2c_bs_in[QUAN_SIZE*50+bit_index],v2c_bs_in[QUAN_SIZE*49+bit_index],v2c_bs_in[QUAN_SIZE*48+bit_index],v2c_bs_in[QUAN_SIZE*47+bit_index],v2c_bs_in[QUAN_SIZE*46+bit_index],v2c_bs_in[QUAN_SIZE*45+bit_index],v2c_bs_in[QUAN_SIZE*44+bit_index],v2c_bs_in[QUAN_SIZE*43+bit_index],v2c_bs_in[QUAN_SIZE*42+bit_index],v2c_bs_in[QUAN_SIZE*41+bit_index],v2c_bs_in[QUAN_SIZE*40+bit_index],v2c_bs_in[QUAN_SIZE*39+bit_index],v2c_bs_in[QUAN_SIZE*38+bit_index],v2c_bs_in[QUAN_SIZE*37+bit_index],v2c_bs_in[QUAN_SIZE*36+bit_index],v2c_bs_in[QUAN_SIZE*35+bit_index],v2c_bs_in[QUAN_SIZE*34+bit_index],v2c_bs_in[QUAN_SIZE*33+bit_index],v2c_bs_in[QUAN_SIZE*32+bit_index],v2c_bs_in[QUAN_SIZE*31+bit_index],v2c_bs_in[QUAN_SIZE*30+bit_index],v2c_bs_in[QUAN_SIZE*29+bit_index],v2c_bs_in[QUAN_SIZE*28+bit_index],v2c_bs_in[QUAN_SIZE*27+bit_index],v2c_bs_in[QUAN_SIZE*26+bit_index],v2c_bs_in[QUAN_SIZE*25+bit_index],v2c_bs_in[QUAN_SIZE*24+bit_index],v2c_bs_in[QUAN_SIZE*23+bit_index],v2c_bs_in[QUAN_SIZE*22+bit_index],v2c_bs_in[QUAN_SIZE*21+bit_index],v2c_bs_in[QUAN_SIZE*20+bit_index],v2c_bs_in[QUAN_SIZE*19+bit_index],v2c_bs_in[QUAN_SIZE*18+bit_index],v2c_bs_in[QUAN_SIZE*17+bit_index],v2c_bs_in[QUAN_SIZE*16+bit_index],v2c_bs_in[QUAN_SIZE*15+bit_index],v2c_bs_in[QUAN_SIZE*14+bit_index],v2c_bs_in[QUAN_SIZE*13+bit_index],v2c_bs_in[QUAN_SIZE*12+bit_index],v2c_bs_in[QUAN_SIZE*11+bit_index],v2c_bs_in[QUAN_SIZE*10+bit_index],v2c_bs_in[QUAN_SIZE*9+bit_index],v2c_bs_in[QUAN_SIZE*8+bit_index],v2c_bs_in[QUAN_SIZE*7+bit_index],v2c_bs_in[QUAN_SIZE*6+bit_index],v2c_bs_in[QUAN_SIZE*5+bit_index],v2c_bs_in[QUAN_SIZE*4+bit_index],v2c_bs_in[QUAN_SIZE*3+bit_index],v2c_bs_in[QUAN_SIZE*2+bit_index],v2c_bs_in[QUAN_SIZE*1+bit_index],v2c_bs_in[QUAN_SIZE*0+bit_index]};
		assign ch_bs_in_bit[bit_index]  = { ch_bs_in[QUAN_SIZE*84+bit_index], ch_bs_in[QUAN_SIZE*83+bit_index], ch_bs_in[QUAN_SIZE*82+bit_index], ch_bs_in[QUAN_SIZE*81+bit_index], ch_bs_in[QUAN_SIZE*80+bit_index], ch_bs_in[QUAN_SIZE*79+bit_index], ch_bs_in[QUAN_SIZE*78+bit_index], ch_bs_in[QUAN_SIZE*77+bit_index], ch_bs_in[QUAN_SIZE*76+bit_index], ch_bs_in[QUAN_SIZE*75+bit_index], ch_bs_in[QUAN_SIZE*74+bit_index], ch_bs_in[QUAN_SIZE*73+bit_index], ch_bs_in[QUAN_SIZE*72+bit_index], ch_bs_in[QUAN_SIZE*71+bit_index], ch_bs_in[QUAN_SIZE*70+bit_index], ch_bs_in[QUAN_SIZE*69+bit_index], ch_bs_in[QUAN_SIZE*68+bit_index], ch_bs_in[QUAN_SIZE*67+bit_index], ch_bs_in[QUAN_SIZE*66+bit_index], ch_bs_in[QUAN_SIZE*65+bit_index], ch_bs_in[QUAN_SIZE*64+bit_index], ch_bs_in[QUAN_SIZE*63+bit_index], ch_bs_in[QUAN_SIZE*62+bit_index], ch_bs_in[QUAN_SIZE*61+bit_index], ch_bs_in[QUAN_SIZE*60+bit_index], ch_bs_in[QUAN_SIZE*59+bit_index], ch_bs_in[QUAN_SIZE*58+bit_index], ch_bs_in[QUAN_SIZE*57+bit_index], ch_bs_in[QUAN_SIZE*56+bit_index], ch_bs_in[QUAN_SIZE*55+bit_index], ch_bs_in[QUAN_SIZE*54+bit_index], ch_bs_in[QUAN_SIZE*53+bit_index], ch_bs_in[QUAN_SIZE*52+bit_index], ch_bs_in[QUAN_SIZE*51+bit_index], ch_bs_in[QUAN_SIZE*50+bit_index], ch_bs_in[QUAN_SIZE*49+bit_index], ch_bs_in[QUAN_SIZE*48+bit_index], ch_bs_in[QUAN_SIZE*47+bit_index], ch_bs_in[QUAN_SIZE*46+bit_index], ch_bs_in[QUAN_SIZE*45+bit_index], ch_bs_in[QUAN_SIZE*44+bit_index], ch_bs_in[QUAN_SIZE*43+bit_index], ch_bs_in[QUAN_SIZE*42+bit_index], ch_bs_in[QUAN_SIZE*41+bit_index], ch_bs_in[QUAN_SIZE*40+bit_index], ch_bs_in[QUAN_SIZE*39+bit_index], ch_bs_in[QUAN_SIZE*38+bit_index], ch_bs_in[QUAN_SIZE*37+bit_index], ch_bs_in[QUAN_SIZE*36+bit_index], ch_bs_in[QUAN_SIZE*35+bit_index], ch_bs_in[QUAN_SIZE*34+bit_index], ch_bs_in[QUAN_SIZE*33+bit_index], ch_bs_in[QUAN_SIZE*32+bit_index], ch_bs_in[QUAN_SIZE*31+bit_index], ch_bs_in[QUAN_SIZE*30+bit_index], ch_bs_in[QUAN_SIZE*29+bit_index], ch_bs_in[QUAN_SIZE*28+bit_index], ch_bs_in[QUAN_SIZE*27+bit_index], ch_bs_in[QUAN_SIZE*26+bit_index], ch_bs_in[QUAN_SIZE*25+bit_index], ch_bs_in[QUAN_SIZE*24+bit_index], ch_bs_in[QUAN_SIZE*23+bit_index], ch_bs_in[QUAN_SIZE*22+bit_index], ch_bs_in[QUAN_SIZE*21+bit_index], ch_bs_in[QUAN_SIZE*20+bit_index], ch_bs_in[QUAN_SIZE*19+bit_index], ch_bs_in[QUAN_SIZE*18+bit_index], ch_bs_in[QUAN_SIZE*17+bit_index], ch_bs_in[QUAN_SIZE*16+bit_index], ch_bs_in[QUAN_SIZE*15+bit_index], ch_bs_in[QUAN_SIZE*14+bit_index], ch_bs_in[QUAN_SIZE*13+bit_index], ch_bs_in[QUAN_SIZE*12+bit_index], ch_bs_in[QUAN_SIZE*11+bit_index], ch_bs_in[QUAN_SIZE*10+bit_index], ch_bs_in[QUAN_SIZE*9+bit_index], ch_bs_in[QUAN_SIZE*8+bit_index], ch_bs_in[QUAN_SIZE*7+bit_index], ch_bs_in[QUAN_SIZE*6+bit_index], ch_bs_in[QUAN_SIZE*5+bit_index], ch_bs_in[QUAN_SIZE*4+bit_index], ch_bs_in[QUAN_SIZE*3+bit_index], ch_bs_in[QUAN_SIZE*2+bit_index],ch_bs_in[QUAN_SIZE*1+bit_index], ch_bs_in[QUAN_SIZE*0+bit_index]};
	end
endgenerate
/*----------------------------------------------*/	
// Circular shifter of check nodes 
qsn_top_85b cnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({cnu_msg_in[84][0],cnu_msg_in[83][0],cnu_msg_in[82][0],cnu_msg_in[81][0],cnu_msg_in[80][0],cnu_msg_in[79][0],cnu_msg_in[78][0],cnu_msg_in[77][0],cnu_msg_in[76][0],cnu_msg_in[75][0],cnu_msg_in[74][0],cnu_msg_in[73][0],cnu_msg_in[72][0],cnu_msg_in[71][0],cnu_msg_in[70][0],cnu_msg_in[69][0],cnu_msg_in[68][0],cnu_msg_in[67][0],cnu_msg_in[66][0],cnu_msg_in[65][0],cnu_msg_in[64][0],cnu_msg_in[63][0],cnu_msg_in[62][0],cnu_msg_in[61][0],cnu_msg_in[60][0],cnu_msg_in[59][0],cnu_msg_in[58][0],cnu_msg_in[57][0],cnu_msg_in[56][0],cnu_msg_in[55][0],cnu_msg_in[54][0],cnu_msg_in[53][0],cnu_msg_in[52][0],cnu_msg_in[51][0],cnu_msg_in[50][0],cnu_msg_in[49][0],cnu_msg_in[48][0],cnu_msg_in[47][0],cnu_msg_in[46][0],cnu_msg_in[45][0],cnu_msg_in[44][0],cnu_msg_in[43][0],cnu_msg_in[42][0],cnu_msg_in[41][0],cnu_msg_in[40][0],cnu_msg_in[39][0],cnu_msg_in[38][0],cnu_msg_in[37][0],cnu_msg_in[36][0],cnu_msg_in[35][0],cnu_msg_in[34][0],cnu_msg_in[33][0],cnu_msg_in[32][0],cnu_msg_in[31][0],cnu_msg_in[30][0],cnu_msg_in[29][0],cnu_msg_in[28][0],cnu_msg_in[27][0],cnu_msg_in[26][0],cnu_msg_in[25][0],cnu_msg_in[24][0],cnu_msg_in[23][0],cnu_msg_in[22][0],cnu_msg_in[21][0],cnu_msg_in[20][0],cnu_msg_in[19][0],cnu_msg_in[18][0],cnu_msg_in[17][0],cnu_msg_in[16][0],cnu_msg_in[15][0],cnu_msg_in[14][0],cnu_msg_in[13][0],cnu_msg_in[12][0],cnu_msg_in[11][0],cnu_msg_in[10][0],cnu_msg_in[9][0],cnu_msg_in[8][0],cnu_msg_in[7][0],cnu_msg_in[6][0],cnu_msg_in[5][0],cnu_msg_in[4][0],cnu_msg_in[3][0],cnu_msg_in[2][0],cnu_msg_in[1][0],cnu_msg_in[0][0]}),
	.sw_out_bit1 ({cnu_msg_in[84][1],cnu_msg_in[83][1],cnu_msg_in[82][1],cnu_msg_in[81][1],cnu_msg_in[80][1],cnu_msg_in[79][1],cnu_msg_in[78][1],cnu_msg_in[77][1],cnu_msg_in[76][1],cnu_msg_in[75][1],cnu_msg_in[74][1],cnu_msg_in[73][1],cnu_msg_in[72][1],cnu_msg_in[71][1],cnu_msg_in[70][1],cnu_msg_in[69][1],cnu_msg_in[68][1],cnu_msg_in[67][1],cnu_msg_in[66][1],cnu_msg_in[65][1],cnu_msg_in[64][1],cnu_msg_in[63][1],cnu_msg_in[62][1],cnu_msg_in[61][1],cnu_msg_in[60][1],cnu_msg_in[59][1],cnu_msg_in[58][1],cnu_msg_in[57][1],cnu_msg_in[56][1],cnu_msg_in[55][1],cnu_msg_in[54][1],cnu_msg_in[53][1],cnu_msg_in[52][1],cnu_msg_in[51][1],cnu_msg_in[50][1],cnu_msg_in[49][1],cnu_msg_in[48][1],cnu_msg_in[47][1],cnu_msg_in[46][1],cnu_msg_in[45][1],cnu_msg_in[44][1],cnu_msg_in[43][1],cnu_msg_in[42][1],cnu_msg_in[41][1],cnu_msg_in[40][1],cnu_msg_in[39][1],cnu_msg_in[38][1],cnu_msg_in[37][1],cnu_msg_in[36][1],cnu_msg_in[35][1],cnu_msg_in[34][1],cnu_msg_in[33][1],cnu_msg_in[32][1],cnu_msg_in[31][1],cnu_msg_in[30][1],cnu_msg_in[29][1],cnu_msg_in[28][1],cnu_msg_in[27][1],cnu_msg_in[26][1],cnu_msg_in[25][1],cnu_msg_in[24][1],cnu_msg_in[23][1],cnu_msg_in[22][1],cnu_msg_in[21][1],cnu_msg_in[20][1],cnu_msg_in[19][1],cnu_msg_in[18][1],cnu_msg_in[17][1],cnu_msg_in[16][1],cnu_msg_in[15][1],cnu_msg_in[14][1],cnu_msg_in[13][1],cnu_msg_in[12][1],cnu_msg_in[11][1],cnu_msg_in[10][1],cnu_msg_in[9][1],cnu_msg_in[8][1],cnu_msg_in[7][1],cnu_msg_in[6][1],cnu_msg_in[5][1],cnu_msg_in[4][1],cnu_msg_in[3][1],cnu_msg_in[2][1],cnu_msg_in[1][1],cnu_msg_in[0][1]}),
	.sw_out_bit2 ({cnu_msg_in[84][2],cnu_msg_in[83][2],cnu_msg_in[82][2],cnu_msg_in[81][2],cnu_msg_in[80][2],cnu_msg_in[79][2],cnu_msg_in[78][2],cnu_msg_in[77][2],cnu_msg_in[76][2],cnu_msg_in[75][2],cnu_msg_in[74][2],cnu_msg_in[73][2],cnu_msg_in[72][2],cnu_msg_in[71][2],cnu_msg_in[70][2],cnu_msg_in[69][2],cnu_msg_in[68][2],cnu_msg_in[67][2],cnu_msg_in[66][2],cnu_msg_in[65][2],cnu_msg_in[64][2],cnu_msg_in[63][2],cnu_msg_in[62][2],cnu_msg_in[61][2],cnu_msg_in[60][2],cnu_msg_in[59][2],cnu_msg_in[58][2],cnu_msg_in[57][2],cnu_msg_in[56][2],cnu_msg_in[55][2],cnu_msg_in[54][2],cnu_msg_in[53][2],cnu_msg_in[52][2],cnu_msg_in[51][2],cnu_msg_in[50][2],cnu_msg_in[49][2],cnu_msg_in[48][2],cnu_msg_in[47][2],cnu_msg_in[46][2],cnu_msg_in[45][2],cnu_msg_in[44][2],cnu_msg_in[43][2],cnu_msg_in[42][2],cnu_msg_in[41][2],cnu_msg_in[40][2],cnu_msg_in[39][2],cnu_msg_in[38][2],cnu_msg_in[37][2],cnu_msg_in[36][2],cnu_msg_in[35][2],cnu_msg_in[34][2],cnu_msg_in[33][2],cnu_msg_in[32][2],cnu_msg_in[31][2],cnu_msg_in[30][2],cnu_msg_in[29][2],cnu_msg_in[28][2],cnu_msg_in[27][2],cnu_msg_in[26][2],cnu_msg_in[25][2],cnu_msg_in[24][2],cnu_msg_in[23][2],cnu_msg_in[22][2],cnu_msg_in[21][2],cnu_msg_in[20][2],cnu_msg_in[19][2],cnu_msg_in[18][2],cnu_msg_in[17][2],cnu_msg_in[16][2],cnu_msg_in[15][2],cnu_msg_in[14][2],cnu_msg_in[13][2],cnu_msg_in[12][2],cnu_msg_in[11][2],cnu_msg_in[10][2],cnu_msg_in[9][2],cnu_msg_in[8][2],cnu_msg_in[7][2],cnu_msg_in[6][2],cnu_msg_in[5][2],cnu_msg_in[4][2],cnu_msg_in[3][2],cnu_msg_in[2][2],cnu_msg_in[1][2],cnu_msg_in[0][2]}),	
	.sw_out_bit3 ({cnu_msg_in[84][3],cnu_msg_in[83][3],cnu_msg_in[82][3],cnu_msg_in[81][3],cnu_msg_in[80][3],cnu_msg_in[79][3],cnu_msg_in[78][3],cnu_msg_in[77][3],cnu_msg_in[76][3],cnu_msg_in[75][3],cnu_msg_in[74][3],cnu_msg_in[73][3],cnu_msg_in[72][3],cnu_msg_in[71][3],cnu_msg_in[70][3],cnu_msg_in[69][3],cnu_msg_in[68][3],cnu_msg_in[67][3],cnu_msg_in[66][3],cnu_msg_in[65][3],cnu_msg_in[64][3],cnu_msg_in[63][3],cnu_msg_in[62][3],cnu_msg_in[61][3],cnu_msg_in[60][3],cnu_msg_in[59][3],cnu_msg_in[58][3],cnu_msg_in[57][3],cnu_msg_in[56][3],cnu_msg_in[55][3],cnu_msg_in[54][3],cnu_msg_in[53][3],cnu_msg_in[52][3],cnu_msg_in[51][3],cnu_msg_in[50][3],cnu_msg_in[49][3],cnu_msg_in[48][3],cnu_msg_in[47][3],cnu_msg_in[46][3],cnu_msg_in[45][3],cnu_msg_in[44][3],cnu_msg_in[43][3],cnu_msg_in[42][3],cnu_msg_in[41][3],cnu_msg_in[40][3],cnu_msg_in[39][3],cnu_msg_in[38][3],cnu_msg_in[37][3],cnu_msg_in[36][3],cnu_msg_in[35][3],cnu_msg_in[34][3],cnu_msg_in[33][3],cnu_msg_in[32][3],cnu_msg_in[31][3],cnu_msg_in[30][3],cnu_msg_in[29][3],cnu_msg_in[28][3],cnu_msg_in[27][3],cnu_msg_in[26][3],cnu_msg_in[25][3],cnu_msg_in[24][3],cnu_msg_in[23][3],cnu_msg_in[22][3],cnu_msg_in[21][3],cnu_msg_in[20][3],cnu_msg_in[19][3],cnu_msg_in[18][3],cnu_msg_in[17][3],cnu_msg_in[16][3],cnu_msg_in[15][3],cnu_msg_in[14][3],cnu_msg_in[13][3],cnu_msg_in[12][3],cnu_msg_in[11][3],cnu_msg_in[10][3],cnu_msg_in[9][3],cnu_msg_in[8][3],cnu_msg_in[7][3],cnu_msg_in[6][3],cnu_msg_in[5][3],cnu_msg_in[4][3],cnu_msg_in[3][3],cnu_msg_in[2][3],cnu_msg_in[1][3],cnu_msg_in[0][3]}),
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in_bit0  (cnu_bs_in_bit[0]),
	.sw_in_bit1  (cnu_bs_in_bit[1]),
	.sw_in_bit2  (cnu_bs_in_bit[2]),
	.sw_in_bit3  (cnu_bs_in_bit[3]),
	.left_sel    (cnu_left_sel),
	.right_sel   (cnu_right_sel),
	.merge_sel   (cnu_merge_sel)
);
qsn_controller_85b #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) cnu_qsn_controller_85b (
	.left_sel     (cnu_left_sel ),
	.right_sel    (cnu_right_sel),
	.merge_sel    (cnu_merge_sel),
	.shift_factor (c2v_shift_factor_cur_0), // offset shift factor of submatrix_1
	.rstn         (rstn),
	.sys_clk      (read_clk)
);
/*----------------------------------------------*/
// Circular shifter of variable nodes 
wire [BITWIDTH_SHIFT_FACTOR-1:0] vnu_shift_factorIn;
wire [BITWIDTH_SHIFT_FACTOR-1:0] dnu_inRotate_shift_factor; // a constant, because only needed at last layer
wire [BITWIDTH_SHIFT_FACTOR-1:0] dnu_inRotate_shift_factor; // a constant, because only needed at last layer
shared_qsn_top_85b #(
		.QUAN_SIZE(QUAN_SIZE),
		.CHECK_PARALLELISM(CHECK_PARALLELISM),
		.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR)
) inst_shared_qsn_top_85b (
	.sw_out_bit0 ({vnu_msg_in[84][0],vnu_msg_in[83][0],vnu_msg_in[82][0],vnu_msg_in[81][0],vnu_msg_in[80][0],vnu_msg_in[79][0],vnu_msg_in[78][0],vnu_msg_in[77][0],vnu_msg_in[76][0],vnu_msg_in[75][0],vnu_msg_in[74][0],vnu_msg_in[73][0],vnu_msg_in[72][0],vnu_msg_in[71][0],vnu_msg_in[70][0],vnu_msg_in[69][0],vnu_msg_in[68][0],vnu_msg_in[67][0],vnu_msg_in[66][0],vnu_msg_in[65][0],vnu_msg_in[64][0],vnu_msg_in[63][0],vnu_msg_in[62][0],vnu_msg_in[61][0],vnu_msg_in[60][0],vnu_msg_in[59][0],vnu_msg_in[58][0],vnu_msg_in[57][0],vnu_msg_in[56][0],vnu_msg_in[55][0],vnu_msg_in[54][0],vnu_msg_in[53][0],vnu_msg_in[52][0],vnu_msg_in[51][0],vnu_msg_in[50][0],vnu_msg_in[49][0],vnu_msg_in[48][0],vnu_msg_in[47][0],vnu_msg_in[46][0],vnu_msg_in[45][0],vnu_msg_in[44][0],vnu_msg_in[43][0],vnu_msg_in[42][0],vnu_msg_in[41][0],vnu_msg_in[40][0],vnu_msg_in[39][0],vnu_msg_in[38][0],vnu_msg_in[37][0],vnu_msg_in[36][0],vnu_msg_in[35][0],vnu_msg_in[34][0],vnu_msg_in[33][0],vnu_msg_in[32][0],vnu_msg_in[31][0],vnu_msg_in[30][0],vnu_msg_in[29][0],vnu_msg_in[28][0],vnu_msg_in[27][0],vnu_msg_in[26][0],vnu_msg_in[25][0],vnu_msg_in[24][0],vnu_msg_in[23][0],vnu_msg_in[22][0],vnu_msg_in[21][0],vnu_msg_in[20][0],vnu_msg_in[19][0],vnu_msg_in[18][0],vnu_msg_in[17][0],vnu_msg_in[16][0],vnu_msg_in[15][0],vnu_msg_in[14][0],vnu_msg_in[13][0],vnu_msg_in[12][0],vnu_msg_in[11][0],vnu_msg_in[10][0],vnu_msg_in[9][0],vnu_msg_in[8][0],vnu_msg_in[7][0],vnu_msg_in[6][0],vnu_msg_in[5][0],vnu_msg_in[4][0],vnu_msg_in[3][0],vnu_msg_in[2][0],vnu_msg_in[1][0],vnu_msg_in[0][0]}),	
	.sw_out_bit1 ({vnu_msg_in[84][1],vnu_msg_in[83][1],vnu_msg_in[82][1],vnu_msg_in[81][1],vnu_msg_in[80][1],vnu_msg_in[79][1],vnu_msg_in[78][1],vnu_msg_in[77][1],vnu_msg_in[76][1],vnu_msg_in[75][1],vnu_msg_in[74][1],vnu_msg_in[73][1],vnu_msg_in[72][1],vnu_msg_in[71][1],vnu_msg_in[70][1],vnu_msg_in[69][1],vnu_msg_in[68][1],vnu_msg_in[67][1],vnu_msg_in[66][1],vnu_msg_in[65][1],vnu_msg_in[64][1],vnu_msg_in[63][1],vnu_msg_in[62][1],vnu_msg_in[61][1],vnu_msg_in[60][1],vnu_msg_in[59][1],vnu_msg_in[58][1],vnu_msg_in[57][1],vnu_msg_in[56][1],vnu_msg_in[55][1],vnu_msg_in[54][1],vnu_msg_in[53][1],vnu_msg_in[52][1],vnu_msg_in[51][1],vnu_msg_in[50][1],vnu_msg_in[49][1],vnu_msg_in[48][1],vnu_msg_in[47][1],vnu_msg_in[46][1],vnu_msg_in[45][1],vnu_msg_in[44][1],vnu_msg_in[43][1],vnu_msg_in[42][1],vnu_msg_in[41][1],vnu_msg_in[40][1],vnu_msg_in[39][1],vnu_msg_in[38][1],vnu_msg_in[37][1],vnu_msg_in[36][1],vnu_msg_in[35][1],vnu_msg_in[34][1],vnu_msg_in[33][1],vnu_msg_in[32][1],vnu_msg_in[31][1],vnu_msg_in[30][1],vnu_msg_in[29][1],vnu_msg_in[28][1],vnu_msg_in[27][1],vnu_msg_in[26][1],vnu_msg_in[25][1],vnu_msg_in[24][1],vnu_msg_in[23][1],vnu_msg_in[22][1],vnu_msg_in[21][1],vnu_msg_in[20][1],vnu_msg_in[19][1],vnu_msg_in[18][1],vnu_msg_in[17][1],vnu_msg_in[16][1],vnu_msg_in[15][1],vnu_msg_in[14][1],vnu_msg_in[13][1],vnu_msg_in[12][1],vnu_msg_in[11][1],vnu_msg_in[10][1],vnu_msg_in[9][1],vnu_msg_in[8][1],vnu_msg_in[7][1],vnu_msg_in[6][1],vnu_msg_in[5][1],vnu_msg_in[4][1],vnu_msg_in[3][1],vnu_msg_in[2][1],vnu_msg_in[1][1],vnu_msg_in[0][1]}),	
	.sw_out_bit2 ({vnu_msg_in[84][2],vnu_msg_in[83][2],vnu_msg_in[82][2],vnu_msg_in[81][2],vnu_msg_in[80][2],vnu_msg_in[79][2],vnu_msg_in[78][2],vnu_msg_in[77][2],vnu_msg_in[76][2],vnu_msg_in[75][2],vnu_msg_in[74][2],vnu_msg_in[73][2],vnu_msg_in[72][2],vnu_msg_in[71][2],vnu_msg_in[70][2],vnu_msg_in[69][2],vnu_msg_in[68][2],vnu_msg_in[67][2],vnu_msg_in[66][2],vnu_msg_in[65][2],vnu_msg_in[64][2],vnu_msg_in[63][2],vnu_msg_in[62][2],vnu_msg_in[61][2],vnu_msg_in[60][2],vnu_msg_in[59][2],vnu_msg_in[58][2],vnu_msg_in[57][2],vnu_msg_in[56][2],vnu_msg_in[55][2],vnu_msg_in[54][2],vnu_msg_in[53][2],vnu_msg_in[52][2],vnu_msg_in[51][2],vnu_msg_in[50][2],vnu_msg_in[49][2],vnu_msg_in[48][2],vnu_msg_in[47][2],vnu_msg_in[46][2],vnu_msg_in[45][2],vnu_msg_in[44][2],vnu_msg_in[43][2],vnu_msg_in[42][2],vnu_msg_in[41][2],vnu_msg_in[40][2],vnu_msg_in[39][2],vnu_msg_in[38][2],vnu_msg_in[37][2],vnu_msg_in[36][2],vnu_msg_in[35][2],vnu_msg_in[34][2],vnu_msg_in[33][2],vnu_msg_in[32][2],vnu_msg_in[31][2],vnu_msg_in[30][2],vnu_msg_in[29][2],vnu_msg_in[28][2],vnu_msg_in[27][2],vnu_msg_in[26][2],vnu_msg_in[25][2],vnu_msg_in[24][2],vnu_msg_in[23][2],vnu_msg_in[22][2],vnu_msg_in[21][2],vnu_msg_in[20][2],vnu_msg_in[19][2],vnu_msg_in[18][2],vnu_msg_in[17][2],vnu_msg_in[16][2],vnu_msg_in[15][2],vnu_msg_in[14][2],vnu_msg_in[13][2],vnu_msg_in[12][2],vnu_msg_in[11][2],vnu_msg_in[10][2],vnu_msg_in[9][2],vnu_msg_in[8][2],vnu_msg_in[7][2],vnu_msg_in[6][2],vnu_msg_in[5][2],vnu_msg_in[4][2],vnu_msg_in[3][2],vnu_msg_in[2][2],vnu_msg_in[1][2],vnu_msg_in[0][2]}),	
	.sw_out_bit3 ({vnu_msg_in[84][3],vnu_msg_in[83][3],vnu_msg_in[82][3],vnu_msg_in[81][3],vnu_msg_in[80][3],vnu_msg_in[79][3],vnu_msg_in[78][3],vnu_msg_in[77][3],vnu_msg_in[76][3],vnu_msg_in[75][3],vnu_msg_in[74][3],vnu_msg_in[73][3],vnu_msg_in[72][3],vnu_msg_in[71][3],vnu_msg_in[70][3],vnu_msg_in[69][3],vnu_msg_in[68][3],vnu_msg_in[67][3],vnu_msg_in[66][3],vnu_msg_in[65][3],vnu_msg_in[64][3],vnu_msg_in[63][3],vnu_msg_in[62][3],vnu_msg_in[61][3],vnu_msg_in[60][3],vnu_msg_in[59][3],vnu_msg_in[58][3],vnu_msg_in[57][3],vnu_msg_in[56][3],vnu_msg_in[55][3],vnu_msg_in[54][3],vnu_msg_in[53][3],vnu_msg_in[52][3],vnu_msg_in[51][3],vnu_msg_in[50][3],vnu_msg_in[49][3],vnu_msg_in[48][3],vnu_msg_in[47][3],vnu_msg_in[46][3],vnu_msg_in[45][3],vnu_msg_in[44][3],vnu_msg_in[43][3],vnu_msg_in[42][3],vnu_msg_in[41][3],vnu_msg_in[40][3],vnu_msg_in[39][3],vnu_msg_in[38][3],vnu_msg_in[37][3],vnu_msg_in[36][3],vnu_msg_in[35][3],vnu_msg_in[34][3],vnu_msg_in[33][3],vnu_msg_in[32][3],vnu_msg_in[31][3],vnu_msg_in[30][3],vnu_msg_in[29][3],vnu_msg_in[28][3],vnu_msg_in[27][3],vnu_msg_in[26][3],vnu_msg_in[25][3],vnu_msg_in[24][3],vnu_msg_in[23][3],vnu_msg_in[22][3],vnu_msg_in[21][3],vnu_msg_in[20][3],vnu_msg_in[19][3],vnu_msg_in[18][3],vnu_msg_in[17][3],vnu_msg_in[16][3],vnu_msg_in[15][3],vnu_msg_in[14][3],vnu_msg_in[13][3],vnu_msg_in[12][3],vnu_msg_in[11][3],vnu_msg_in[10][3],vnu_msg_in[9][3],vnu_msg_in[8][3],vnu_msg_in[7][3],vnu_msg_in[6][3],vnu_msg_in[5][3],vnu_msg_in[4][3],vnu_msg_in[3][3],vnu_msg_in[2][3],vnu_msg_in[1][3],vnu_msg_in[0][3]}),	
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in0_bit0  (vnu_bs_in_bit[0]),
	.sw_in0_bit1  (vnu_bs_in_bit[1]),
	.sw_in0_bit2  (vnu_bs_in_bit[2]),
	.sw_in0_bit3  (vnu_bs_in_bit[3]),

	.sw_in1_bit0 (ch_bs_in_bit[0]),
	.sw_in1_bit1 (ch_bs_in_bit[1]),
	.sw_in1_bit2 (ch_bs_in_bit[2]),
	.sw_in1_bit3 (ch_bs_in_bit[3]),

	.sw_in2_bit0 (dnu_inRotate_bit),

	.shift_factor (vnu_shift_factorIn), // offset shift factor of submatrix
	.sw_in_bit0_src (vnu_bs_bit0_src),
	.sw_in_src (vnu_bs_src)
);
assign vnu_shift_factorIn = (vnu_bs_bit0_src[0] == 1'b1) ? v2c_shift_factor_cur_0 :
							(vnu_bs_bit0_src[1] == 1'b1) ? ch_ramRD_shift_factor_cur_0 :
							(vnu_bs_bit0_src[2] == 1'b1) ? dnu_inRotate_shift_factor : v2c_shift_factor_cur_0;
/*----------------------------------------------*/	
	reg [ADDR_WIDTH-1:0] c2v_mem_page_addr;
	reg [ADDR_WIDTH-1:0] v2c_mem_page_addr;
	mem_subsystem_top_submatrix_4 #(
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
		) inst_mem_subsystem_top_submatrix_4 (
			.mem_to_vnu_0     (mem_to_vnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_vnu_1     (mem_to_vnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_vnu_2     (mem_to_vnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_vnu_3     (mem_to_vnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_vnu_4     (mem_to_vnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_vnu_5     (mem_to_vnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_vnu_6     (mem_to_vnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_vnu_7     (mem_to_vnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_vnu_8     (mem_to_vnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_vnu_9     (mem_to_vnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_vnu_10    (mem_to_vnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_vnu_11    (mem_to_vnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_vnu_12    (mem_to_vnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_vnu_13    (mem_to_vnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_vnu_14    (mem_to_vnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_vnu_15    (mem_to_vnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_vnu_16    (mem_to_vnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_vnu_17    (mem_to_vnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_vnu_18    (mem_to_vnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_vnu_19    (mem_to_vnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_vnu_20    (mem_to_vnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_vnu_21    (mem_to_vnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_vnu_22    (mem_to_vnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_vnu_23    (mem_to_vnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_vnu_24    (mem_to_vnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_vnu_25    (mem_to_vnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_vnu_26    (mem_to_vnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_vnu_27    (mem_to_vnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_vnu_28    (mem_to_vnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_vnu_29    (mem_to_vnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_vnu_30    (mem_to_vnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_vnu_31    (mem_to_vnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_vnu_32    (mem_to_vnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_vnu_33    (mem_to_vnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_vnu_34    (mem_to_vnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_vnu_35    (mem_to_vnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_vnu_36    (mem_to_vnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_vnu_37    (mem_to_vnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_vnu_38    (mem_to_vnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_vnu_39    (mem_to_vnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_vnu_40    (mem_to_vnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_vnu_41    (mem_to_vnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_vnu_42    (mem_to_vnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_vnu_43    (mem_to_vnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_vnu_44    (mem_to_vnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_vnu_45    (mem_to_vnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_vnu_46    (mem_to_vnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_vnu_47    (mem_to_vnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_vnu_48    (mem_to_vnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_vnu_49    (mem_to_vnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_vnu_50    (mem_to_vnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_vnu_51    (mem_to_vnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_vnu_52    (mem_to_vnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_vnu_53    (mem_to_vnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_vnu_54    (mem_to_vnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_vnu_55    (mem_to_vnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_vnu_56    (mem_to_vnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_vnu_57    (mem_to_vnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_vnu_58    (mem_to_vnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_vnu_59    (mem_to_vnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_vnu_60    (mem_to_vnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_vnu_61    (mem_to_vnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_vnu_62    (mem_to_vnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_vnu_63    (mem_to_vnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_vnu_64    (mem_to_vnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_vnu_65    (mem_to_vnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_vnu_66    (mem_to_vnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_vnu_67    (mem_to_vnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_vnu_68    (mem_to_vnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_vnu_69    (mem_to_vnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_vnu_70    (mem_to_vnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_vnu_71    (mem_to_vnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_vnu_72    (mem_to_vnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_vnu_73    (mem_to_vnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_vnu_74    (mem_to_vnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_vnu_75    (mem_to_vnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_vnu_76    (mem_to_vnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_vnu_77    (mem_to_vnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_vnu_78    (mem_to_vnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_vnu_79    (mem_to_vnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_vnu_80    (mem_to_vnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_vnu_81    (mem_to_vnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_vnu_82    (mem_to_vnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_vnu_83    (mem_to_vnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_vnu_84    (mem_to_vnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),
			.mem_to_cnu_0     (mem_to_cnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_cnu_1     (mem_to_cnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_cnu_2     (mem_to_cnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_cnu_3     (mem_to_cnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_cnu_4     (mem_to_cnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_cnu_5     (mem_to_cnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_cnu_6     (mem_to_cnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_cnu_7     (mem_to_cnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_cnu_8     (mem_to_cnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_cnu_9     (mem_to_cnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_cnu_10    (mem_to_cnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_cnu_11    (mem_to_cnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_cnu_12    (mem_to_cnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_cnu_13    (mem_to_cnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_cnu_14    (mem_to_cnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_cnu_15    (mem_to_cnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_cnu_16    (mem_to_cnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_cnu_17    (mem_to_cnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_cnu_18    (mem_to_cnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_cnu_19    (mem_to_cnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_cnu_20    (mem_to_cnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_cnu_21    (mem_to_cnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_cnu_22    (mem_to_cnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_cnu_23    (mem_to_cnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_cnu_24    (mem_to_cnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_cnu_25    (mem_to_cnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_cnu_26    (mem_to_cnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_cnu_27    (mem_to_cnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_cnu_28    (mem_to_cnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_cnu_29    (mem_to_cnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_cnu_30    (mem_to_cnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_cnu_31    (mem_to_cnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_cnu_32    (mem_to_cnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_cnu_33    (mem_to_cnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_cnu_34    (mem_to_cnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_cnu_35    (mem_to_cnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_cnu_36    (mem_to_cnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_cnu_37    (mem_to_cnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_cnu_38    (mem_to_cnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_cnu_39    (mem_to_cnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_cnu_40    (mem_to_cnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_cnu_41    (mem_to_cnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_cnu_42    (mem_to_cnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_cnu_43    (mem_to_cnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_cnu_44    (mem_to_cnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_cnu_45    (mem_to_cnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_cnu_46    (mem_to_cnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_cnu_47    (mem_to_cnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_cnu_48    (mem_to_cnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_cnu_49    (mem_to_cnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_cnu_50    (mem_to_cnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_cnu_51    (mem_to_cnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_cnu_52    (mem_to_cnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_cnu_53    (mem_to_cnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_cnu_54    (mem_to_cnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_cnu_55    (mem_to_cnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_cnu_56    (mem_to_cnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_cnu_57    (mem_to_cnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_cnu_58    (mem_to_cnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_cnu_59    (mem_to_cnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_cnu_60    (mem_to_cnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_cnu_61    (mem_to_cnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_cnu_62    (mem_to_cnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_cnu_63    (mem_to_cnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_cnu_64    (mem_to_cnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_cnu_65    (mem_to_cnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_cnu_66    (mem_to_cnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_cnu_67    (mem_to_cnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_cnu_68    (mem_to_cnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_cnu_69    (mem_to_cnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_cnu_70    (mem_to_cnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_cnu_71    (mem_to_cnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_cnu_72    (mem_to_cnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_cnu_73    (mem_to_cnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_cnu_74    (mem_to_cnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_cnu_75    (mem_to_cnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_cnu_76    (mem_to_cnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_cnu_77    (mem_to_cnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_cnu_78    (mem_to_cnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_cnu_79    (mem_to_cnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_cnu_80    (mem_to_cnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_cnu_81    (mem_to_cnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_cnu_82    (mem_to_cnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_cnu_83    (mem_to_cnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_cnu_84    (mem_to_cnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),

			.vnu_to_mem_0     (vnu_msg_in[0 ]),
			.vnu_to_mem_1     (vnu_msg_in[1 ]),
			.vnu_to_mem_2     (vnu_msg_in[2 ]),
			.vnu_to_mem_3     (vnu_msg_in[3 ]),
			.vnu_to_mem_4     (vnu_msg_in[4 ]),
			.vnu_to_mem_5     (vnu_msg_in[5 ]),
			.vnu_to_mem_6     (vnu_msg_in[6 ]),
			.vnu_to_mem_7     (vnu_msg_in[7 ]),
			.vnu_to_mem_8     (vnu_msg_in[8 ]),
			.vnu_to_mem_9     (vnu_msg_in[9 ]),
			.vnu_to_mem_10    (vnu_msg_in[10]),
			.vnu_to_mem_11    (vnu_msg_in[11]),
			.vnu_to_mem_12    (vnu_msg_in[12]),
			.vnu_to_mem_13    (vnu_msg_in[13]),
			.vnu_to_mem_14    (vnu_msg_in[14]),
			.vnu_to_mem_15    (vnu_msg_in[15]),
			.vnu_to_mem_16    (vnu_msg_in[16]),
			.vnu_to_mem_17    (vnu_msg_in[17]),
			.vnu_to_mem_18    (vnu_msg_in[18]),
			.vnu_to_mem_19    (vnu_msg_in[19]),
			.vnu_to_mem_20    (vnu_msg_in[20]),
			.vnu_to_mem_21    (vnu_msg_in[21]),
			.vnu_to_mem_22    (vnu_msg_in[22]),
			.vnu_to_mem_23    (vnu_msg_in[23]),
			.vnu_to_mem_24    (vnu_msg_in[24]),
			.vnu_to_mem_25    (vnu_msg_in[25]),
			.vnu_to_mem_26    (vnu_msg_in[26]),
			.vnu_to_mem_27    (vnu_msg_in[27]),
			.vnu_to_mem_28    (vnu_msg_in[28]),
			.vnu_to_mem_29    (vnu_msg_in[29]),
			.vnu_to_mem_30    (vnu_msg_in[30]),
			.vnu_to_mem_31    (vnu_msg_in[31]),
			.vnu_to_mem_32    (vnu_msg_in[32]),
			.vnu_to_mem_33    (vnu_msg_in[33]),
			.vnu_to_mem_34    (vnu_msg_in[34]),
			.vnu_to_mem_35    (vnu_msg_in[35]),
			.vnu_to_mem_36    (vnu_msg_in[36]),
			.vnu_to_mem_37    (vnu_msg_in[37]),
			.vnu_to_mem_38    (vnu_msg_in[38]),
			.vnu_to_mem_39    (vnu_msg_in[39]),
			.vnu_to_mem_40    (vnu_msg_in[40]),
			.vnu_to_mem_41    (vnu_msg_in[41]),
			.vnu_to_mem_42    (vnu_msg_in[42]),
			.vnu_to_mem_43    (vnu_msg_in[43]),
			.vnu_to_mem_44    (vnu_msg_in[44]),
			.vnu_to_mem_45    (vnu_msg_in[45]),
			.vnu_to_mem_46    (vnu_msg_in[46]),
			.vnu_to_mem_47    (vnu_msg_in[47]),
			.vnu_to_mem_48    (vnu_msg_in[48]),
			.vnu_to_mem_49    (vnu_msg_in[49]),
			.vnu_to_mem_50    (vnu_msg_in[50]),
			.vnu_to_mem_51    (vnu_msg_in[51]),
			.vnu_to_mem_52    (vnu_msg_in[52]),
			.vnu_to_mem_53    (vnu_msg_in[53]),
			.vnu_to_mem_54    (vnu_msg_in[54]),
			.vnu_to_mem_55    (vnu_msg_in[55]),
			.vnu_to_mem_56    (vnu_msg_in[56]),
			.vnu_to_mem_57    (vnu_msg_in[57]),
			.vnu_to_mem_58    (vnu_msg_in[58]),
			.vnu_to_mem_59    (vnu_msg_in[59]),
			.vnu_to_mem_60    (vnu_msg_in[60]),
			.vnu_to_mem_61    (vnu_msg_in[61]),
			.vnu_to_mem_62    (vnu_msg_in[62]),
			.vnu_to_mem_63    (vnu_msg_in[63]),
			.vnu_to_mem_64    (vnu_msg_in[64]),
			.vnu_to_mem_65    (vnu_msg_in[65]),
			.vnu_to_mem_66    (vnu_msg_in[66]),
			.vnu_to_mem_67    (vnu_msg_in[67]),
			.vnu_to_mem_68    (vnu_msg_in[68]),
			.vnu_to_mem_69    (vnu_msg_in[69]),
			.vnu_to_mem_70    (vnu_msg_in[70]),
			.vnu_to_mem_71    (vnu_msg_in[71]),
			.vnu_to_mem_72    (vnu_msg_in[72]),
			.vnu_to_mem_73    (vnu_msg_in[73]),
			.vnu_to_mem_74    (vnu_msg_in[74]),
			.vnu_to_mem_75    (vnu_msg_in[75]),
			.vnu_to_mem_76    (vnu_msg_in[76]),
			.vnu_to_mem_77    (vnu_msg_in[77]),
			.vnu_to_mem_78    (vnu_msg_in[78]),
			.vnu_to_mem_79    (vnu_msg_in[79]),
			.vnu_to_mem_80    (vnu_msg_in[80]),
			.vnu_to_mem_81    (vnu_msg_in[81]),
			.vnu_to_mem_82    (vnu_msg_in[82]),
			.vnu_to_mem_83    (vnu_msg_in[83]),
			.vnu_to_mem_84    (vnu_msg_in[84]),
			.cnu_to_mem_0     (cnu_msg_in[0 ]),
			.cnu_to_mem_1     (cnu_msg_in[1 ]),
			.cnu_to_mem_2     (cnu_msg_in[2 ]),
			.cnu_to_mem_3     (cnu_msg_in[3 ]),
			.cnu_to_mem_4     (cnu_msg_in[4 ]),
			.cnu_to_mem_5     (cnu_msg_in[5 ]),
			.cnu_to_mem_6     (cnu_msg_in[6 ]),
			.cnu_to_mem_7     (cnu_msg_in[7 ]),
			.cnu_to_mem_8     (cnu_msg_in[8 ]),
			.cnu_to_mem_9     (cnu_msg_in[9 ]),
			.cnu_to_mem_10    (cnu_msg_in[10]),
			.cnu_to_mem_11    (cnu_msg_in[11]),
			.cnu_to_mem_12    (cnu_msg_in[12]),
			.cnu_to_mem_13    (cnu_msg_in[13]),
			.cnu_to_mem_14    (cnu_msg_in[14]),
			.cnu_to_mem_15    (cnu_msg_in[15]),
			.cnu_to_mem_16    (cnu_msg_in[16]),
			.cnu_to_mem_17    (cnu_msg_in[17]),
			.cnu_to_mem_18    (cnu_msg_in[18]),
			.cnu_to_mem_19    (cnu_msg_in[19]),
			.cnu_to_mem_20    (cnu_msg_in[20]),
			.cnu_to_mem_21    (cnu_msg_in[21]),
			.cnu_to_mem_22    (cnu_msg_in[22]),
			.cnu_to_mem_23    (cnu_msg_in[23]),
			.cnu_to_mem_24    (cnu_msg_in[24]),
			.cnu_to_mem_25    (cnu_msg_in[25]),
			.cnu_to_mem_26    (cnu_msg_in[26]),
			.cnu_to_mem_27    (cnu_msg_in[27]),
			.cnu_to_mem_28    (cnu_msg_in[28]),
			.cnu_to_mem_29    (cnu_msg_in[29]),
			.cnu_to_mem_30    (cnu_msg_in[30]),
			.cnu_to_mem_31    (cnu_msg_in[31]),
			.cnu_to_mem_32    (cnu_msg_in[32]),
			.cnu_to_mem_33    (cnu_msg_in[33]),
			.cnu_to_mem_34    (cnu_msg_in[34]),
			.cnu_to_mem_35    (cnu_msg_in[35]),
			.cnu_to_mem_36    (cnu_msg_in[36]),
			.cnu_to_mem_37    (cnu_msg_in[37]),
			.cnu_to_mem_38    (cnu_msg_in[38]),
			.cnu_to_mem_39    (cnu_msg_in[39]),
			.cnu_to_mem_40    (cnu_msg_in[40]),
			.cnu_to_mem_41    (cnu_msg_in[41]),
			.cnu_to_mem_42    (cnu_msg_in[42]),
			.cnu_to_mem_43    (cnu_msg_in[43]),
			.cnu_to_mem_44    (cnu_msg_in[44]),
			.cnu_to_mem_45    (cnu_msg_in[45]),
			.cnu_to_mem_46    (cnu_msg_in[46]),
			.cnu_to_mem_47    (cnu_msg_in[47]),
			.cnu_to_mem_48    (cnu_msg_in[48]),
			.cnu_to_mem_49    (cnu_msg_in[49]),
			.cnu_to_mem_50    (cnu_msg_in[50]),
			.cnu_to_mem_51    (cnu_msg_in[51]),
			.cnu_to_mem_52    (cnu_msg_in[52]),
			.cnu_to_mem_53    (cnu_msg_in[53]),
			.cnu_to_mem_54    (cnu_msg_in[54]),
			.cnu_to_mem_55    (cnu_msg_in[55]),
			.cnu_to_mem_56    (cnu_msg_in[56]),
			.cnu_to_mem_57    (cnu_msg_in[57]),
			.cnu_to_mem_58    (cnu_msg_in[58]),
			.cnu_to_mem_59    (cnu_msg_in[59]),
			.cnu_to_mem_60    (cnu_msg_in[60]),
			.cnu_to_mem_61    (cnu_msg_in[61]),
			.cnu_to_mem_62    (cnu_msg_in[62]),
			.cnu_to_mem_63    (cnu_msg_in[63]),
			.cnu_to_mem_64    (cnu_msg_in[64]),
			.cnu_to_mem_65    (cnu_msg_in[65]),
			.cnu_to_mem_66    (cnu_msg_in[66]),
			.cnu_to_mem_67    (cnu_msg_in[67]),
			.cnu_to_mem_68    (cnu_msg_in[68]),
			.cnu_to_mem_69    (cnu_msg_in[69]),
			.cnu_to_mem_70    (cnu_msg_in[70]),
			.cnu_to_mem_71    (cnu_msg_in[71]),
			.cnu_to_mem_72    (cnu_msg_in[72]),
			.cnu_to_mem_73    (cnu_msg_in[73]),
			.cnu_to_mem_74    (cnu_msg_in[74]),
			.cnu_to_mem_75    (cnu_msg_in[75]),
			.cnu_to_mem_76    (cnu_msg_in[76]),
			.cnu_to_mem_77    (cnu_msg_in[77]),
			.cnu_to_mem_78    (cnu_msg_in[78]),
			.cnu_to_mem_79    (cnu_msg_in[79]),
			.cnu_to_mem_80    (cnu_msg_in[80]),
			.cnu_to_mem_81    (cnu_msg_in[81]),
			.cnu_to_mem_82    (cnu_msg_in[82]),
			.cnu_to_mem_83    (cnu_msg_in[83]),
			.cnu_to_mem_84    (cnu_msg_in[84]),
			.cnu_sync_addr    (cnu_mem_page_sync_addr),
			.vnu_sync_addr    (vnu_mem_page_sync_addr),
			.cnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.vnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.last_row_chunk   ({c2v_last_row_chunk, v2c_last_row_chunk}),
			.we               ({v2c_mem_we, c2v_mem_we}),
			.sys_clk          (read_clk),
			.rstn             (rstn)
		);
		assign cnu_mem_page_sync_addr = (v2c_mem_fetch == 1'b1) ? v2c_mem_page_rd_addr : 
										(c2v_mem_we == 1'b1) ? c2v_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.

		assign vnu_mem_page_sync_addr = (c2v_mem_fetch == 1'b1) ? c2v_mem_page_rd_addr : 
										(v2c_mem_we == 1'b1) ? v2c_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Check-to-Variable messages RAMs write-page addresses
	always @(posedge read_clk) begin
		if(rstn == 1'b0) 
			c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE;
		else if(c2v_mem_we == 1'b1) begin
			// page increment pattern within layer 0
			if(v2c_layer_cnt[0] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_1+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 1
			if(v2c_layer_cnt[1] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_2+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 2
			if(v2c_layer_cnt[2] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_2-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
		end
	end

	always @(posedge read_clk) begin
		if(rstn == 1'b0) begin
			c2v_shift_factor_cur_2 <= shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
		end
		else if(c2v_bs_en == 1'b1) begin
			c2v_shift_factor_cur_2 <= 0;
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
/*--------------------------------------------------------------------------*/
// Channel Buffers
reg [CH_DATA_WIDTH-1:0] ch_msg_genIn;
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_0 [0:CHECK_PARALLELISM-1]; // [0:84]
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_1 [0:CHECK_PARALLELISM-1]; // [0:84]
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_rd_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chInit_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chLayer_wr_addr;
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

			.din        (ch_msg_genIn[CH_DATA_WIDTH-1:0]),

			.read_addr  (submatrix_ch_ram_rd_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.write_addr (submatrix_ch_ram_wr_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.we         (ch_ram_we),
			.read_clk   (ch_ram_rd_clk),
			.write_clk  (ch_ram_wr_clk),
			.rstn       (rstn)
		);
		// Updating the Channel RAMs by either initally channel messages (from AWGNs) or circularly shifted channel messages
		assign submatrix_ch_ram_wr_addr = (ch_ram_init_we == 1'b1) ? submatrix_chInit_wr_addr :
														(ch_ram_wb == 1'b1     ) ? submatrix_chLayer_wr_addr : 
																				   CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.


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
	// Channel messages RAMs write-page addresses
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
endmodule

module msg_pass_submatrix_5_unit #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,
	parameter VN_DEGREE = 3,   // degree of one variable node
/*-------------------------------------------------------------------------------------*/
	// Parameters related to BS, PA and MEM
	parameter RAM_DEPTH = 1024,
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH),
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1),
	parameter shift_factor_0 = CHECK_PARALLELISM-22,
	parameter shift_factor_1 = CHECK_PARALLELISM-2,
	parameter shift_factor_2 = CHECK_PARALLELISM-20 ,

`ifdef SCHED_4_6
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,
	parameter C2V_MEM_ADDR_BASE = 0,
	parameter V2C_MEM_ADDR_BASE = ROW_CHUNK_NUM,
	parameter V2C_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter C2V_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH),
`endif
	parameter START_PAGE_1_0 = 2, // starting page address of layer 0 of submatrix_1
	parameter START_PAGE_1_1 = 8, // starting page address of layer 1 of submatrix_1
	parameter START_PAGE_1_2 = 1  // starting page address of layer 2 of submatrix_1
) (
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu,

	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit,

	// control signals
	input wire c2v_bs_en,
	input wire v2c_bs_en,
	input wire ch_bs_en,
	/*------------------------------*/
	// Control signals associative with message passing of channel buffer and DNU.SignExtension
	input wire ch_ram_init_we,
	input wire ch_ram_fetch,
	input wire v2c_outRotate_reg_we,
	input wire dnu_inRotate_bs_en,
	input wire dnu_inRotate_pa_en,
	input wire dnu_inRotate_wb,
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
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,

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
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_2;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_2;
wire [6:0]  cnu_left_sel;
wire [6:0]  cnu_right_sel;
wire [83:0] cnu_merge_sel;
wire [6:0]  vnu_left_sel;
wire [6:0]  vnu_right_sel;
wire [83:0] vnu_merge_sel;
wire [CHECK_PARALLELISM-1:0] cnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] vnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] ch_bs_in_bit [0:QUAN_SIZE-1];
genvar bit_index;
generate
	for(bit_index=0;bit_index<QUAN_SIZE;bit_index=bit_index+1) begin : extrinsic_msg_bs_in_inst
		assign cnu_bs_in_bit[bit_index] = {c2v_bs_in[QUAN_SIZE*84+bit_index],c2v_bs_in[QUAN_SIZE*83+bit_index],c2v_bs_in[QUAN_SIZE*82+bit_index],c2v_bs_in[QUAN_SIZE*81+bit_index],c2v_bs_in[QUAN_SIZE*80+bit_index],c2v_bs_in[QUAN_SIZE*79+bit_index],c2v_bs_in[QUAN_SIZE*78+bit_index],c2v_bs_in[QUAN_SIZE*77+bit_index],c2v_bs_in[QUAN_SIZE*76+bit_index],c2v_bs_in[QUAN_SIZE*75+bit_index],c2v_bs_in[QUAN_SIZE*74+bit_index],c2v_bs_in[QUAN_SIZE*73+bit_index],c2v_bs_in[QUAN_SIZE*72+bit_index],c2v_bs_in[QUAN_SIZE*71+bit_index],c2v_bs_in[QUAN_SIZE*70+bit_index],c2v_bs_in[QUAN_SIZE*69+bit_index],c2v_bs_in[QUAN_SIZE*68+bit_index],c2v_bs_in[QUAN_SIZE*67+bit_index],c2v_bs_in[QUAN_SIZE*66+bit_index],c2v_bs_in[QUAN_SIZE*65+bit_index],c2v_bs_in[QUAN_SIZE*64+bit_index],c2v_bs_in[QUAN_SIZE*63+bit_index],c2v_bs_in[QUAN_SIZE*62+bit_index],c2v_bs_in[QUAN_SIZE*61+bit_index],c2v_bs_in[QUAN_SIZE*60+bit_index],c2v_bs_in[QUAN_SIZE*59+bit_index],c2v_bs_in[QUAN_SIZE*58+bit_index],c2v_bs_in[QUAN_SIZE*57+bit_index],c2v_bs_in[QUAN_SIZE*56+bit_index],c2v_bs_in[QUAN_SIZE*55+bit_index],c2v_bs_in[QUAN_SIZE*54+bit_index],c2v_bs_in[QUAN_SIZE*53+bit_index],c2v_bs_in[QUAN_SIZE*52+bit_index],c2v_bs_in[QUAN_SIZE*51+bit_index],c2v_bs_in[QUAN_SIZE*50+bit_index],c2v_bs_in[QUAN_SIZE*49+bit_index],c2v_bs_in[QUAN_SIZE*48+bit_index],c2v_bs_in[QUAN_SIZE*47+bit_index],c2v_bs_in[QUAN_SIZE*46+bit_index],c2v_bs_in[QUAN_SIZE*45+bit_index],c2v_bs_in[QUAN_SIZE*44+bit_index],c2v_bs_in[QUAN_SIZE*43+bit_index],c2v_bs_in[QUAN_SIZE*42+bit_index],c2v_bs_in[QUAN_SIZE*41+bit_index],c2v_bs_in[QUAN_SIZE*40+bit_index],c2v_bs_in[QUAN_SIZE*39+bit_index],c2v_bs_in[QUAN_SIZE*38+bit_index],c2v_bs_in[QUAN_SIZE*37+bit_index],c2v_bs_in[QUAN_SIZE*36+bit_index],c2v_bs_in[QUAN_SIZE*35+bit_index],c2v_bs_in[QUAN_SIZE*34+bit_index],c2v_bs_in[QUAN_SIZE*33+bit_index],c2v_bs_in[QUAN_SIZE*32+bit_index],c2v_bs_in[QUAN_SIZE*31+bit_index],c2v_bs_in[QUAN_SIZE*30+bit_index],c2v_bs_in[QUAN_SIZE*29+bit_index],c2v_bs_in[QUAN_SIZE*28+bit_index],c2v_bs_in[QUAN_SIZE*27+bit_index],c2v_bs_in[QUAN_SIZE*26+bit_index],c2v_bs_in[QUAN_SIZE*25+bit_index],c2v_bs_in[QUAN_SIZE*24+bit_index],c2v_bs_in[QUAN_SIZE*23+bit_index],c2v_bs_in[QUAN_SIZE*22+bit_index],c2v_bs_in[QUAN_SIZE*21+bit_index],c2v_bs_in[QUAN_SIZE*20+bit_index],c2v_bs_in[QUAN_SIZE*19+bit_index],c2v_bs_in[QUAN_SIZE*18+bit_index],c2v_bs_in[QUAN_SIZE*17+bit_index],c2v_bs_in[QUAN_SIZE*16+bit_index],c2v_bs_in[QUAN_SIZE*15+bit_index],c2v_bs_in[QUAN_SIZE*14+bit_index],c2v_bs_in[QUAN_SIZE*13+bit_index],c2v_bs_in[QUAN_SIZE*12+bit_index],c2v_bs_in[QUAN_SIZE*11+bit_index],c2v_bs_in[QUAN_SIZE*10+bit_index],c2v_bs_in[QUAN_SIZE*9+bit_index],c2v_bs_in[QUAN_SIZE*8+bit_index],c2v_bs_in[QUAN_SIZE*7+bit_index],c2v_bs_in[QUAN_SIZE*6+bit_index],c2v_bs_in[QUAN_SIZE*5+bit_index],c2v_bs_in[QUAN_SIZE*4+bit_index],c2v_bs_in[QUAN_SIZE*3+bit_index],c2v_bs_in[QUAN_SIZE*2+bit_index],c2v_bs_in[QUAN_SIZE*1+bit_index],c2v_bs_in[QUAN_SIZE*0+bit_index]};
		assign vnu_bs_in_bit[bit_index] = {v2c_bs_in[QUAN_SIZE*84+bit_index],v2c_bs_in[QUAN_SIZE*83+bit_index],v2c_bs_in[QUAN_SIZE*82+bit_index],v2c_bs_in[QUAN_SIZE*81+bit_index],v2c_bs_in[QUAN_SIZE*80+bit_index],v2c_bs_in[QUAN_SIZE*79+bit_index],v2c_bs_in[QUAN_SIZE*78+bit_index],v2c_bs_in[QUAN_SIZE*77+bit_index],v2c_bs_in[QUAN_SIZE*76+bit_index],v2c_bs_in[QUAN_SIZE*75+bit_index],v2c_bs_in[QUAN_SIZE*74+bit_index],v2c_bs_in[QUAN_SIZE*73+bit_index],v2c_bs_in[QUAN_SIZE*72+bit_index],v2c_bs_in[QUAN_SIZE*71+bit_index],v2c_bs_in[QUAN_SIZE*70+bit_index],v2c_bs_in[QUAN_SIZE*69+bit_index],v2c_bs_in[QUAN_SIZE*68+bit_index],v2c_bs_in[QUAN_SIZE*67+bit_index],v2c_bs_in[QUAN_SIZE*66+bit_index],v2c_bs_in[QUAN_SIZE*65+bit_index],v2c_bs_in[QUAN_SIZE*64+bit_index],v2c_bs_in[QUAN_SIZE*63+bit_index],v2c_bs_in[QUAN_SIZE*62+bit_index],v2c_bs_in[QUAN_SIZE*61+bit_index],v2c_bs_in[QUAN_SIZE*60+bit_index],v2c_bs_in[QUAN_SIZE*59+bit_index],v2c_bs_in[QUAN_SIZE*58+bit_index],v2c_bs_in[QUAN_SIZE*57+bit_index],v2c_bs_in[QUAN_SIZE*56+bit_index],v2c_bs_in[QUAN_SIZE*55+bit_index],v2c_bs_in[QUAN_SIZE*54+bit_index],v2c_bs_in[QUAN_SIZE*53+bit_index],v2c_bs_in[QUAN_SIZE*52+bit_index],v2c_bs_in[QUAN_SIZE*51+bit_index],v2c_bs_in[QUAN_SIZE*50+bit_index],v2c_bs_in[QUAN_SIZE*49+bit_index],v2c_bs_in[QUAN_SIZE*48+bit_index],v2c_bs_in[QUAN_SIZE*47+bit_index],v2c_bs_in[QUAN_SIZE*46+bit_index],v2c_bs_in[QUAN_SIZE*45+bit_index],v2c_bs_in[QUAN_SIZE*44+bit_index],v2c_bs_in[QUAN_SIZE*43+bit_index],v2c_bs_in[QUAN_SIZE*42+bit_index],v2c_bs_in[QUAN_SIZE*41+bit_index],v2c_bs_in[QUAN_SIZE*40+bit_index],v2c_bs_in[QUAN_SIZE*39+bit_index],v2c_bs_in[QUAN_SIZE*38+bit_index],v2c_bs_in[QUAN_SIZE*37+bit_index],v2c_bs_in[QUAN_SIZE*36+bit_index],v2c_bs_in[QUAN_SIZE*35+bit_index],v2c_bs_in[QUAN_SIZE*34+bit_index],v2c_bs_in[QUAN_SIZE*33+bit_index],v2c_bs_in[QUAN_SIZE*32+bit_index],v2c_bs_in[QUAN_SIZE*31+bit_index],v2c_bs_in[QUAN_SIZE*30+bit_index],v2c_bs_in[QUAN_SIZE*29+bit_index],v2c_bs_in[QUAN_SIZE*28+bit_index],v2c_bs_in[QUAN_SIZE*27+bit_index],v2c_bs_in[QUAN_SIZE*26+bit_index],v2c_bs_in[QUAN_SIZE*25+bit_index],v2c_bs_in[QUAN_SIZE*24+bit_index],v2c_bs_in[QUAN_SIZE*23+bit_index],v2c_bs_in[QUAN_SIZE*22+bit_index],v2c_bs_in[QUAN_SIZE*21+bit_index],v2c_bs_in[QUAN_SIZE*20+bit_index],v2c_bs_in[QUAN_SIZE*19+bit_index],v2c_bs_in[QUAN_SIZE*18+bit_index],v2c_bs_in[QUAN_SIZE*17+bit_index],v2c_bs_in[QUAN_SIZE*16+bit_index],v2c_bs_in[QUAN_SIZE*15+bit_index],v2c_bs_in[QUAN_SIZE*14+bit_index],v2c_bs_in[QUAN_SIZE*13+bit_index],v2c_bs_in[QUAN_SIZE*12+bit_index],v2c_bs_in[QUAN_SIZE*11+bit_index],v2c_bs_in[QUAN_SIZE*10+bit_index],v2c_bs_in[QUAN_SIZE*9+bit_index],v2c_bs_in[QUAN_SIZE*8+bit_index],v2c_bs_in[QUAN_SIZE*7+bit_index],v2c_bs_in[QUAN_SIZE*6+bit_index],v2c_bs_in[QUAN_SIZE*5+bit_index],v2c_bs_in[QUAN_SIZE*4+bit_index],v2c_bs_in[QUAN_SIZE*3+bit_index],v2c_bs_in[QUAN_SIZE*2+bit_index],v2c_bs_in[QUAN_SIZE*1+bit_index],v2c_bs_in[QUAN_SIZE*0+bit_index]};
		assign ch_bs_in_bit[bit_index]  = { ch_bs_in[QUAN_SIZE*84+bit_index], ch_bs_in[QUAN_SIZE*83+bit_index], ch_bs_in[QUAN_SIZE*82+bit_index], ch_bs_in[QUAN_SIZE*81+bit_index], ch_bs_in[QUAN_SIZE*80+bit_index], ch_bs_in[QUAN_SIZE*79+bit_index], ch_bs_in[QUAN_SIZE*78+bit_index], ch_bs_in[QUAN_SIZE*77+bit_index], ch_bs_in[QUAN_SIZE*76+bit_index], ch_bs_in[QUAN_SIZE*75+bit_index], ch_bs_in[QUAN_SIZE*74+bit_index], ch_bs_in[QUAN_SIZE*73+bit_index], ch_bs_in[QUAN_SIZE*72+bit_index], ch_bs_in[QUAN_SIZE*71+bit_index], ch_bs_in[QUAN_SIZE*70+bit_index], ch_bs_in[QUAN_SIZE*69+bit_index], ch_bs_in[QUAN_SIZE*68+bit_index], ch_bs_in[QUAN_SIZE*67+bit_index], ch_bs_in[QUAN_SIZE*66+bit_index], ch_bs_in[QUAN_SIZE*65+bit_index], ch_bs_in[QUAN_SIZE*64+bit_index], ch_bs_in[QUAN_SIZE*63+bit_index], ch_bs_in[QUAN_SIZE*62+bit_index], ch_bs_in[QUAN_SIZE*61+bit_index], ch_bs_in[QUAN_SIZE*60+bit_index], ch_bs_in[QUAN_SIZE*59+bit_index], ch_bs_in[QUAN_SIZE*58+bit_index], ch_bs_in[QUAN_SIZE*57+bit_index], ch_bs_in[QUAN_SIZE*56+bit_index], ch_bs_in[QUAN_SIZE*55+bit_index], ch_bs_in[QUAN_SIZE*54+bit_index], ch_bs_in[QUAN_SIZE*53+bit_index], ch_bs_in[QUAN_SIZE*52+bit_index], ch_bs_in[QUAN_SIZE*51+bit_index], ch_bs_in[QUAN_SIZE*50+bit_index], ch_bs_in[QUAN_SIZE*49+bit_index], ch_bs_in[QUAN_SIZE*48+bit_index], ch_bs_in[QUAN_SIZE*47+bit_index], ch_bs_in[QUAN_SIZE*46+bit_index], ch_bs_in[QUAN_SIZE*45+bit_index], ch_bs_in[QUAN_SIZE*44+bit_index], ch_bs_in[QUAN_SIZE*43+bit_index], ch_bs_in[QUAN_SIZE*42+bit_index], ch_bs_in[QUAN_SIZE*41+bit_index], ch_bs_in[QUAN_SIZE*40+bit_index], ch_bs_in[QUAN_SIZE*39+bit_index], ch_bs_in[QUAN_SIZE*38+bit_index], ch_bs_in[QUAN_SIZE*37+bit_index], ch_bs_in[QUAN_SIZE*36+bit_index], ch_bs_in[QUAN_SIZE*35+bit_index], ch_bs_in[QUAN_SIZE*34+bit_index], ch_bs_in[QUAN_SIZE*33+bit_index], ch_bs_in[QUAN_SIZE*32+bit_index], ch_bs_in[QUAN_SIZE*31+bit_index], ch_bs_in[QUAN_SIZE*30+bit_index], ch_bs_in[QUAN_SIZE*29+bit_index], ch_bs_in[QUAN_SIZE*28+bit_index], ch_bs_in[QUAN_SIZE*27+bit_index], ch_bs_in[QUAN_SIZE*26+bit_index], ch_bs_in[QUAN_SIZE*25+bit_index], ch_bs_in[QUAN_SIZE*24+bit_index], ch_bs_in[QUAN_SIZE*23+bit_index], ch_bs_in[QUAN_SIZE*22+bit_index], ch_bs_in[QUAN_SIZE*21+bit_index], ch_bs_in[QUAN_SIZE*20+bit_index], ch_bs_in[QUAN_SIZE*19+bit_index], ch_bs_in[QUAN_SIZE*18+bit_index], ch_bs_in[QUAN_SIZE*17+bit_index], ch_bs_in[QUAN_SIZE*16+bit_index], ch_bs_in[QUAN_SIZE*15+bit_index], ch_bs_in[QUAN_SIZE*14+bit_index], ch_bs_in[QUAN_SIZE*13+bit_index], ch_bs_in[QUAN_SIZE*12+bit_index], ch_bs_in[QUAN_SIZE*11+bit_index], ch_bs_in[QUAN_SIZE*10+bit_index], ch_bs_in[QUAN_SIZE*9+bit_index], ch_bs_in[QUAN_SIZE*8+bit_index], ch_bs_in[QUAN_SIZE*7+bit_index], ch_bs_in[QUAN_SIZE*6+bit_index], ch_bs_in[QUAN_SIZE*5+bit_index], ch_bs_in[QUAN_SIZE*4+bit_index], ch_bs_in[QUAN_SIZE*3+bit_index], ch_bs_in[QUAN_SIZE*2+bit_index],ch_bs_in[QUAN_SIZE*1+bit_index], ch_bs_in[QUAN_SIZE*0+bit_index]};
	end
endgenerate
/*----------------------------------------------*/	
// Circular shifter of check nodes 
qsn_top_85b cnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({cnu_msg_in[84][0],cnu_msg_in[83][0],cnu_msg_in[82][0],cnu_msg_in[81][0],cnu_msg_in[80][0],cnu_msg_in[79][0],cnu_msg_in[78][0],cnu_msg_in[77][0],cnu_msg_in[76][0],cnu_msg_in[75][0],cnu_msg_in[74][0],cnu_msg_in[73][0],cnu_msg_in[72][0],cnu_msg_in[71][0],cnu_msg_in[70][0],cnu_msg_in[69][0],cnu_msg_in[68][0],cnu_msg_in[67][0],cnu_msg_in[66][0],cnu_msg_in[65][0],cnu_msg_in[64][0],cnu_msg_in[63][0],cnu_msg_in[62][0],cnu_msg_in[61][0],cnu_msg_in[60][0],cnu_msg_in[59][0],cnu_msg_in[58][0],cnu_msg_in[57][0],cnu_msg_in[56][0],cnu_msg_in[55][0],cnu_msg_in[54][0],cnu_msg_in[53][0],cnu_msg_in[52][0],cnu_msg_in[51][0],cnu_msg_in[50][0],cnu_msg_in[49][0],cnu_msg_in[48][0],cnu_msg_in[47][0],cnu_msg_in[46][0],cnu_msg_in[45][0],cnu_msg_in[44][0],cnu_msg_in[43][0],cnu_msg_in[42][0],cnu_msg_in[41][0],cnu_msg_in[40][0],cnu_msg_in[39][0],cnu_msg_in[38][0],cnu_msg_in[37][0],cnu_msg_in[36][0],cnu_msg_in[35][0],cnu_msg_in[34][0],cnu_msg_in[33][0],cnu_msg_in[32][0],cnu_msg_in[31][0],cnu_msg_in[30][0],cnu_msg_in[29][0],cnu_msg_in[28][0],cnu_msg_in[27][0],cnu_msg_in[26][0],cnu_msg_in[25][0],cnu_msg_in[24][0],cnu_msg_in[23][0],cnu_msg_in[22][0],cnu_msg_in[21][0],cnu_msg_in[20][0],cnu_msg_in[19][0],cnu_msg_in[18][0],cnu_msg_in[17][0],cnu_msg_in[16][0],cnu_msg_in[15][0],cnu_msg_in[14][0],cnu_msg_in[13][0],cnu_msg_in[12][0],cnu_msg_in[11][0],cnu_msg_in[10][0],cnu_msg_in[9][0],cnu_msg_in[8][0],cnu_msg_in[7][0],cnu_msg_in[6][0],cnu_msg_in[5][0],cnu_msg_in[4][0],cnu_msg_in[3][0],cnu_msg_in[2][0],cnu_msg_in[1][0],cnu_msg_in[0][0]}),
	.sw_out_bit1 ({cnu_msg_in[84][1],cnu_msg_in[83][1],cnu_msg_in[82][1],cnu_msg_in[81][1],cnu_msg_in[80][1],cnu_msg_in[79][1],cnu_msg_in[78][1],cnu_msg_in[77][1],cnu_msg_in[76][1],cnu_msg_in[75][1],cnu_msg_in[74][1],cnu_msg_in[73][1],cnu_msg_in[72][1],cnu_msg_in[71][1],cnu_msg_in[70][1],cnu_msg_in[69][1],cnu_msg_in[68][1],cnu_msg_in[67][1],cnu_msg_in[66][1],cnu_msg_in[65][1],cnu_msg_in[64][1],cnu_msg_in[63][1],cnu_msg_in[62][1],cnu_msg_in[61][1],cnu_msg_in[60][1],cnu_msg_in[59][1],cnu_msg_in[58][1],cnu_msg_in[57][1],cnu_msg_in[56][1],cnu_msg_in[55][1],cnu_msg_in[54][1],cnu_msg_in[53][1],cnu_msg_in[52][1],cnu_msg_in[51][1],cnu_msg_in[50][1],cnu_msg_in[49][1],cnu_msg_in[48][1],cnu_msg_in[47][1],cnu_msg_in[46][1],cnu_msg_in[45][1],cnu_msg_in[44][1],cnu_msg_in[43][1],cnu_msg_in[42][1],cnu_msg_in[41][1],cnu_msg_in[40][1],cnu_msg_in[39][1],cnu_msg_in[38][1],cnu_msg_in[37][1],cnu_msg_in[36][1],cnu_msg_in[35][1],cnu_msg_in[34][1],cnu_msg_in[33][1],cnu_msg_in[32][1],cnu_msg_in[31][1],cnu_msg_in[30][1],cnu_msg_in[29][1],cnu_msg_in[28][1],cnu_msg_in[27][1],cnu_msg_in[26][1],cnu_msg_in[25][1],cnu_msg_in[24][1],cnu_msg_in[23][1],cnu_msg_in[22][1],cnu_msg_in[21][1],cnu_msg_in[20][1],cnu_msg_in[19][1],cnu_msg_in[18][1],cnu_msg_in[17][1],cnu_msg_in[16][1],cnu_msg_in[15][1],cnu_msg_in[14][1],cnu_msg_in[13][1],cnu_msg_in[12][1],cnu_msg_in[11][1],cnu_msg_in[10][1],cnu_msg_in[9][1],cnu_msg_in[8][1],cnu_msg_in[7][1],cnu_msg_in[6][1],cnu_msg_in[5][1],cnu_msg_in[4][1],cnu_msg_in[3][1],cnu_msg_in[2][1],cnu_msg_in[1][1],cnu_msg_in[0][1]}),
	.sw_out_bit2 ({cnu_msg_in[84][2],cnu_msg_in[83][2],cnu_msg_in[82][2],cnu_msg_in[81][2],cnu_msg_in[80][2],cnu_msg_in[79][2],cnu_msg_in[78][2],cnu_msg_in[77][2],cnu_msg_in[76][2],cnu_msg_in[75][2],cnu_msg_in[74][2],cnu_msg_in[73][2],cnu_msg_in[72][2],cnu_msg_in[71][2],cnu_msg_in[70][2],cnu_msg_in[69][2],cnu_msg_in[68][2],cnu_msg_in[67][2],cnu_msg_in[66][2],cnu_msg_in[65][2],cnu_msg_in[64][2],cnu_msg_in[63][2],cnu_msg_in[62][2],cnu_msg_in[61][2],cnu_msg_in[60][2],cnu_msg_in[59][2],cnu_msg_in[58][2],cnu_msg_in[57][2],cnu_msg_in[56][2],cnu_msg_in[55][2],cnu_msg_in[54][2],cnu_msg_in[53][2],cnu_msg_in[52][2],cnu_msg_in[51][2],cnu_msg_in[50][2],cnu_msg_in[49][2],cnu_msg_in[48][2],cnu_msg_in[47][2],cnu_msg_in[46][2],cnu_msg_in[45][2],cnu_msg_in[44][2],cnu_msg_in[43][2],cnu_msg_in[42][2],cnu_msg_in[41][2],cnu_msg_in[40][2],cnu_msg_in[39][2],cnu_msg_in[38][2],cnu_msg_in[37][2],cnu_msg_in[36][2],cnu_msg_in[35][2],cnu_msg_in[34][2],cnu_msg_in[33][2],cnu_msg_in[32][2],cnu_msg_in[31][2],cnu_msg_in[30][2],cnu_msg_in[29][2],cnu_msg_in[28][2],cnu_msg_in[27][2],cnu_msg_in[26][2],cnu_msg_in[25][2],cnu_msg_in[24][2],cnu_msg_in[23][2],cnu_msg_in[22][2],cnu_msg_in[21][2],cnu_msg_in[20][2],cnu_msg_in[19][2],cnu_msg_in[18][2],cnu_msg_in[17][2],cnu_msg_in[16][2],cnu_msg_in[15][2],cnu_msg_in[14][2],cnu_msg_in[13][2],cnu_msg_in[12][2],cnu_msg_in[11][2],cnu_msg_in[10][2],cnu_msg_in[9][2],cnu_msg_in[8][2],cnu_msg_in[7][2],cnu_msg_in[6][2],cnu_msg_in[5][2],cnu_msg_in[4][2],cnu_msg_in[3][2],cnu_msg_in[2][2],cnu_msg_in[1][2],cnu_msg_in[0][2]}),	
	.sw_out_bit3 ({cnu_msg_in[84][3],cnu_msg_in[83][3],cnu_msg_in[82][3],cnu_msg_in[81][3],cnu_msg_in[80][3],cnu_msg_in[79][3],cnu_msg_in[78][3],cnu_msg_in[77][3],cnu_msg_in[76][3],cnu_msg_in[75][3],cnu_msg_in[74][3],cnu_msg_in[73][3],cnu_msg_in[72][3],cnu_msg_in[71][3],cnu_msg_in[70][3],cnu_msg_in[69][3],cnu_msg_in[68][3],cnu_msg_in[67][3],cnu_msg_in[66][3],cnu_msg_in[65][3],cnu_msg_in[64][3],cnu_msg_in[63][3],cnu_msg_in[62][3],cnu_msg_in[61][3],cnu_msg_in[60][3],cnu_msg_in[59][3],cnu_msg_in[58][3],cnu_msg_in[57][3],cnu_msg_in[56][3],cnu_msg_in[55][3],cnu_msg_in[54][3],cnu_msg_in[53][3],cnu_msg_in[52][3],cnu_msg_in[51][3],cnu_msg_in[50][3],cnu_msg_in[49][3],cnu_msg_in[48][3],cnu_msg_in[47][3],cnu_msg_in[46][3],cnu_msg_in[45][3],cnu_msg_in[44][3],cnu_msg_in[43][3],cnu_msg_in[42][3],cnu_msg_in[41][3],cnu_msg_in[40][3],cnu_msg_in[39][3],cnu_msg_in[38][3],cnu_msg_in[37][3],cnu_msg_in[36][3],cnu_msg_in[35][3],cnu_msg_in[34][3],cnu_msg_in[33][3],cnu_msg_in[32][3],cnu_msg_in[31][3],cnu_msg_in[30][3],cnu_msg_in[29][3],cnu_msg_in[28][3],cnu_msg_in[27][3],cnu_msg_in[26][3],cnu_msg_in[25][3],cnu_msg_in[24][3],cnu_msg_in[23][3],cnu_msg_in[22][3],cnu_msg_in[21][3],cnu_msg_in[20][3],cnu_msg_in[19][3],cnu_msg_in[18][3],cnu_msg_in[17][3],cnu_msg_in[16][3],cnu_msg_in[15][3],cnu_msg_in[14][3],cnu_msg_in[13][3],cnu_msg_in[12][3],cnu_msg_in[11][3],cnu_msg_in[10][3],cnu_msg_in[9][3],cnu_msg_in[8][3],cnu_msg_in[7][3],cnu_msg_in[6][3],cnu_msg_in[5][3],cnu_msg_in[4][3],cnu_msg_in[3][3],cnu_msg_in[2][3],cnu_msg_in[1][3],cnu_msg_in[0][3]}),
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in_bit0  (cnu_bs_in_bit[0]),
	.sw_in_bit1  (cnu_bs_in_bit[1]),
	.sw_in_bit2  (cnu_bs_in_bit[2]),
	.sw_in_bit3  (cnu_bs_in_bit[3]),
	.left_sel    (cnu_left_sel),
	.right_sel   (cnu_right_sel),
	.merge_sel   (cnu_merge_sel)
);
qsn_controller_85b #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) cnu_qsn_controller_85b (
	.left_sel     (cnu_left_sel ),
	.right_sel    (cnu_right_sel),
	.merge_sel    (cnu_merge_sel),
	.shift_factor (c2v_shift_factor_cur_0), // offset shift factor of submatrix_1
	.rstn         (rstn),
	.sys_clk      (read_clk)
);
/*----------------------------------------------*/
// Circular shifter of variable nodes 
wire [BITWIDTH_SHIFT_FACTOR-1:0] vnu_shift_factorIn;
wire [BITWIDTH_SHIFT_FACTOR-1:0] dnu_inRotate_shift_factor; // a constant, because only needed at last layer
shared_qsn_top_85b #(
		.QUAN_SIZE(QUAN_SIZE),
		.CHECK_PARALLELISM(CHECK_PARALLELISM),
		.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR)
) inst_shared_qsn_top_85b (
	.sw_out_bit0 ({vnu_msg_in[84][0],vnu_msg_in[83][0],vnu_msg_in[82][0],vnu_msg_in[81][0],vnu_msg_in[80][0],vnu_msg_in[79][0],vnu_msg_in[78][0],vnu_msg_in[77][0],vnu_msg_in[76][0],vnu_msg_in[75][0],vnu_msg_in[74][0],vnu_msg_in[73][0],vnu_msg_in[72][0],vnu_msg_in[71][0],vnu_msg_in[70][0],vnu_msg_in[69][0],vnu_msg_in[68][0],vnu_msg_in[67][0],vnu_msg_in[66][0],vnu_msg_in[65][0],vnu_msg_in[64][0],vnu_msg_in[63][0],vnu_msg_in[62][0],vnu_msg_in[61][0],vnu_msg_in[60][0],vnu_msg_in[59][0],vnu_msg_in[58][0],vnu_msg_in[57][0],vnu_msg_in[56][0],vnu_msg_in[55][0],vnu_msg_in[54][0],vnu_msg_in[53][0],vnu_msg_in[52][0],vnu_msg_in[51][0],vnu_msg_in[50][0],vnu_msg_in[49][0],vnu_msg_in[48][0],vnu_msg_in[47][0],vnu_msg_in[46][0],vnu_msg_in[45][0],vnu_msg_in[44][0],vnu_msg_in[43][0],vnu_msg_in[42][0],vnu_msg_in[41][0],vnu_msg_in[40][0],vnu_msg_in[39][0],vnu_msg_in[38][0],vnu_msg_in[37][0],vnu_msg_in[36][0],vnu_msg_in[35][0],vnu_msg_in[34][0],vnu_msg_in[33][0],vnu_msg_in[32][0],vnu_msg_in[31][0],vnu_msg_in[30][0],vnu_msg_in[29][0],vnu_msg_in[28][0],vnu_msg_in[27][0],vnu_msg_in[26][0],vnu_msg_in[25][0],vnu_msg_in[24][0],vnu_msg_in[23][0],vnu_msg_in[22][0],vnu_msg_in[21][0],vnu_msg_in[20][0],vnu_msg_in[19][0],vnu_msg_in[18][0],vnu_msg_in[17][0],vnu_msg_in[16][0],vnu_msg_in[15][0],vnu_msg_in[14][0],vnu_msg_in[13][0],vnu_msg_in[12][0],vnu_msg_in[11][0],vnu_msg_in[10][0],vnu_msg_in[9][0],vnu_msg_in[8][0],vnu_msg_in[7][0],vnu_msg_in[6][0],vnu_msg_in[5][0],vnu_msg_in[4][0],vnu_msg_in[3][0],vnu_msg_in[2][0],vnu_msg_in[1][0],vnu_msg_in[0][0]}),	
	.sw_out_bit1 ({vnu_msg_in[84][1],vnu_msg_in[83][1],vnu_msg_in[82][1],vnu_msg_in[81][1],vnu_msg_in[80][1],vnu_msg_in[79][1],vnu_msg_in[78][1],vnu_msg_in[77][1],vnu_msg_in[76][1],vnu_msg_in[75][1],vnu_msg_in[74][1],vnu_msg_in[73][1],vnu_msg_in[72][1],vnu_msg_in[71][1],vnu_msg_in[70][1],vnu_msg_in[69][1],vnu_msg_in[68][1],vnu_msg_in[67][1],vnu_msg_in[66][1],vnu_msg_in[65][1],vnu_msg_in[64][1],vnu_msg_in[63][1],vnu_msg_in[62][1],vnu_msg_in[61][1],vnu_msg_in[60][1],vnu_msg_in[59][1],vnu_msg_in[58][1],vnu_msg_in[57][1],vnu_msg_in[56][1],vnu_msg_in[55][1],vnu_msg_in[54][1],vnu_msg_in[53][1],vnu_msg_in[52][1],vnu_msg_in[51][1],vnu_msg_in[50][1],vnu_msg_in[49][1],vnu_msg_in[48][1],vnu_msg_in[47][1],vnu_msg_in[46][1],vnu_msg_in[45][1],vnu_msg_in[44][1],vnu_msg_in[43][1],vnu_msg_in[42][1],vnu_msg_in[41][1],vnu_msg_in[40][1],vnu_msg_in[39][1],vnu_msg_in[38][1],vnu_msg_in[37][1],vnu_msg_in[36][1],vnu_msg_in[35][1],vnu_msg_in[34][1],vnu_msg_in[33][1],vnu_msg_in[32][1],vnu_msg_in[31][1],vnu_msg_in[30][1],vnu_msg_in[29][1],vnu_msg_in[28][1],vnu_msg_in[27][1],vnu_msg_in[26][1],vnu_msg_in[25][1],vnu_msg_in[24][1],vnu_msg_in[23][1],vnu_msg_in[22][1],vnu_msg_in[21][1],vnu_msg_in[20][1],vnu_msg_in[19][1],vnu_msg_in[18][1],vnu_msg_in[17][1],vnu_msg_in[16][1],vnu_msg_in[15][1],vnu_msg_in[14][1],vnu_msg_in[13][1],vnu_msg_in[12][1],vnu_msg_in[11][1],vnu_msg_in[10][1],vnu_msg_in[9][1],vnu_msg_in[8][1],vnu_msg_in[7][1],vnu_msg_in[6][1],vnu_msg_in[5][1],vnu_msg_in[4][1],vnu_msg_in[3][1],vnu_msg_in[2][1],vnu_msg_in[1][1],vnu_msg_in[0][1]}),	
	.sw_out_bit2 ({vnu_msg_in[84][2],vnu_msg_in[83][2],vnu_msg_in[82][2],vnu_msg_in[81][2],vnu_msg_in[80][2],vnu_msg_in[79][2],vnu_msg_in[78][2],vnu_msg_in[77][2],vnu_msg_in[76][2],vnu_msg_in[75][2],vnu_msg_in[74][2],vnu_msg_in[73][2],vnu_msg_in[72][2],vnu_msg_in[71][2],vnu_msg_in[70][2],vnu_msg_in[69][2],vnu_msg_in[68][2],vnu_msg_in[67][2],vnu_msg_in[66][2],vnu_msg_in[65][2],vnu_msg_in[64][2],vnu_msg_in[63][2],vnu_msg_in[62][2],vnu_msg_in[61][2],vnu_msg_in[60][2],vnu_msg_in[59][2],vnu_msg_in[58][2],vnu_msg_in[57][2],vnu_msg_in[56][2],vnu_msg_in[55][2],vnu_msg_in[54][2],vnu_msg_in[53][2],vnu_msg_in[52][2],vnu_msg_in[51][2],vnu_msg_in[50][2],vnu_msg_in[49][2],vnu_msg_in[48][2],vnu_msg_in[47][2],vnu_msg_in[46][2],vnu_msg_in[45][2],vnu_msg_in[44][2],vnu_msg_in[43][2],vnu_msg_in[42][2],vnu_msg_in[41][2],vnu_msg_in[40][2],vnu_msg_in[39][2],vnu_msg_in[38][2],vnu_msg_in[37][2],vnu_msg_in[36][2],vnu_msg_in[35][2],vnu_msg_in[34][2],vnu_msg_in[33][2],vnu_msg_in[32][2],vnu_msg_in[31][2],vnu_msg_in[30][2],vnu_msg_in[29][2],vnu_msg_in[28][2],vnu_msg_in[27][2],vnu_msg_in[26][2],vnu_msg_in[25][2],vnu_msg_in[24][2],vnu_msg_in[23][2],vnu_msg_in[22][2],vnu_msg_in[21][2],vnu_msg_in[20][2],vnu_msg_in[19][2],vnu_msg_in[18][2],vnu_msg_in[17][2],vnu_msg_in[16][2],vnu_msg_in[15][2],vnu_msg_in[14][2],vnu_msg_in[13][2],vnu_msg_in[12][2],vnu_msg_in[11][2],vnu_msg_in[10][2],vnu_msg_in[9][2],vnu_msg_in[8][2],vnu_msg_in[7][2],vnu_msg_in[6][2],vnu_msg_in[5][2],vnu_msg_in[4][2],vnu_msg_in[3][2],vnu_msg_in[2][2],vnu_msg_in[1][2],vnu_msg_in[0][2]}),	
	.sw_out_bit3 ({vnu_msg_in[84][3],vnu_msg_in[83][3],vnu_msg_in[82][3],vnu_msg_in[81][3],vnu_msg_in[80][3],vnu_msg_in[79][3],vnu_msg_in[78][3],vnu_msg_in[77][3],vnu_msg_in[76][3],vnu_msg_in[75][3],vnu_msg_in[74][3],vnu_msg_in[73][3],vnu_msg_in[72][3],vnu_msg_in[71][3],vnu_msg_in[70][3],vnu_msg_in[69][3],vnu_msg_in[68][3],vnu_msg_in[67][3],vnu_msg_in[66][3],vnu_msg_in[65][3],vnu_msg_in[64][3],vnu_msg_in[63][3],vnu_msg_in[62][3],vnu_msg_in[61][3],vnu_msg_in[60][3],vnu_msg_in[59][3],vnu_msg_in[58][3],vnu_msg_in[57][3],vnu_msg_in[56][3],vnu_msg_in[55][3],vnu_msg_in[54][3],vnu_msg_in[53][3],vnu_msg_in[52][3],vnu_msg_in[51][3],vnu_msg_in[50][3],vnu_msg_in[49][3],vnu_msg_in[48][3],vnu_msg_in[47][3],vnu_msg_in[46][3],vnu_msg_in[45][3],vnu_msg_in[44][3],vnu_msg_in[43][3],vnu_msg_in[42][3],vnu_msg_in[41][3],vnu_msg_in[40][3],vnu_msg_in[39][3],vnu_msg_in[38][3],vnu_msg_in[37][3],vnu_msg_in[36][3],vnu_msg_in[35][3],vnu_msg_in[34][3],vnu_msg_in[33][3],vnu_msg_in[32][3],vnu_msg_in[31][3],vnu_msg_in[30][3],vnu_msg_in[29][3],vnu_msg_in[28][3],vnu_msg_in[27][3],vnu_msg_in[26][3],vnu_msg_in[25][3],vnu_msg_in[24][3],vnu_msg_in[23][3],vnu_msg_in[22][3],vnu_msg_in[21][3],vnu_msg_in[20][3],vnu_msg_in[19][3],vnu_msg_in[18][3],vnu_msg_in[17][3],vnu_msg_in[16][3],vnu_msg_in[15][3],vnu_msg_in[14][3],vnu_msg_in[13][3],vnu_msg_in[12][3],vnu_msg_in[11][3],vnu_msg_in[10][3],vnu_msg_in[9][3],vnu_msg_in[8][3],vnu_msg_in[7][3],vnu_msg_in[6][3],vnu_msg_in[5][3],vnu_msg_in[4][3],vnu_msg_in[3][3],vnu_msg_in[2][3],vnu_msg_in[1][3],vnu_msg_in[0][3]}),	
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in0_bit0  (vnu_bs_in_bit[0]),
	.sw_in0_bit1  (vnu_bs_in_bit[1]),
	.sw_in0_bit2  (vnu_bs_in_bit[2]),
	.sw_in0_bit3  (vnu_bs_in_bit[3]),

	.sw_in1_bit0 (ch_bs_in_bit[0]),
	.sw_in1_bit1 (ch_bs_in_bit[1]),
	.sw_in1_bit2 (ch_bs_in_bit[2]),
	.sw_in1_bit3 (ch_bs_in_bit[3]),

	.sw_in2_bit0 (dnu_inRotate_bit),

	.shift_factor (vnu_shift_factorIn), // offset shift factor of submatrix
	.sw_in_bit0_src (vnu_bs_bit0_src),
	.sw_in_src (vnu_bs_src)
);
assign vnu_shift_factorIn = (vnu_bs_bit0_src[0] == 1'b1) ? v2c_shift_factor_cur_0 :
							(vnu_bs_bit0_src[1] == 1'b1) ? ch_ramRD_shift_factor_cur_0 :
							(vnu_bs_bit0_src[2] == 1'b1) ? dnu_inRotate_shift_factor : v2c_shift_factor_cur_0;
/*----------------------------------------------*/	
	reg [ADDR_WIDTH-1:0] c2v_mem_page_addr;
	reg [ADDR_WIDTH-1:0] v2c_mem_page_addr;
	mem_subsystem_top_submatrix_5 #(
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
		) inst_mem_subsystem_top_submatrix_5 (
			.mem_to_vnu_0     (mem_to_vnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_vnu_1     (mem_to_vnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_vnu_2     (mem_to_vnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_vnu_3     (mem_to_vnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_vnu_4     (mem_to_vnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_vnu_5     (mem_to_vnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_vnu_6     (mem_to_vnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_vnu_7     (mem_to_vnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_vnu_8     (mem_to_vnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_vnu_9     (mem_to_vnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_vnu_10    (mem_to_vnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_vnu_11    (mem_to_vnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_vnu_12    (mem_to_vnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_vnu_13    (mem_to_vnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_vnu_14    (mem_to_vnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_vnu_15    (mem_to_vnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_vnu_16    (mem_to_vnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_vnu_17    (mem_to_vnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_vnu_18    (mem_to_vnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_vnu_19    (mem_to_vnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_vnu_20    (mem_to_vnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_vnu_21    (mem_to_vnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_vnu_22    (mem_to_vnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_vnu_23    (mem_to_vnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_vnu_24    (mem_to_vnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_vnu_25    (mem_to_vnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_vnu_26    (mem_to_vnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_vnu_27    (mem_to_vnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_vnu_28    (mem_to_vnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_vnu_29    (mem_to_vnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_vnu_30    (mem_to_vnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_vnu_31    (mem_to_vnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_vnu_32    (mem_to_vnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_vnu_33    (mem_to_vnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_vnu_34    (mem_to_vnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_vnu_35    (mem_to_vnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_vnu_36    (mem_to_vnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_vnu_37    (mem_to_vnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_vnu_38    (mem_to_vnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_vnu_39    (mem_to_vnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_vnu_40    (mem_to_vnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_vnu_41    (mem_to_vnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_vnu_42    (mem_to_vnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_vnu_43    (mem_to_vnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_vnu_44    (mem_to_vnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_vnu_45    (mem_to_vnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_vnu_46    (mem_to_vnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_vnu_47    (mem_to_vnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_vnu_48    (mem_to_vnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_vnu_49    (mem_to_vnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_vnu_50    (mem_to_vnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_vnu_51    (mem_to_vnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_vnu_52    (mem_to_vnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_vnu_53    (mem_to_vnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_vnu_54    (mem_to_vnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_vnu_55    (mem_to_vnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_vnu_56    (mem_to_vnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_vnu_57    (mem_to_vnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_vnu_58    (mem_to_vnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_vnu_59    (mem_to_vnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_vnu_60    (mem_to_vnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_vnu_61    (mem_to_vnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_vnu_62    (mem_to_vnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_vnu_63    (mem_to_vnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_vnu_64    (mem_to_vnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_vnu_65    (mem_to_vnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_vnu_66    (mem_to_vnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_vnu_67    (mem_to_vnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_vnu_68    (mem_to_vnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_vnu_69    (mem_to_vnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_vnu_70    (mem_to_vnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_vnu_71    (mem_to_vnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_vnu_72    (mem_to_vnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_vnu_73    (mem_to_vnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_vnu_74    (mem_to_vnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_vnu_75    (mem_to_vnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_vnu_76    (mem_to_vnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_vnu_77    (mem_to_vnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_vnu_78    (mem_to_vnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_vnu_79    (mem_to_vnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_vnu_80    (mem_to_vnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_vnu_81    (mem_to_vnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_vnu_82    (mem_to_vnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_vnu_83    (mem_to_vnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_vnu_84    (mem_to_vnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),
			.mem_to_cnu_0     (mem_to_cnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_cnu_1     (mem_to_cnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_cnu_2     (mem_to_cnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_cnu_3     (mem_to_cnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_cnu_4     (mem_to_cnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_cnu_5     (mem_to_cnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_cnu_6     (mem_to_cnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_cnu_7     (mem_to_cnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_cnu_8     (mem_to_cnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_cnu_9     (mem_to_cnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_cnu_10    (mem_to_cnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_cnu_11    (mem_to_cnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_cnu_12    (mem_to_cnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_cnu_13    (mem_to_cnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_cnu_14    (mem_to_cnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_cnu_15    (mem_to_cnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_cnu_16    (mem_to_cnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_cnu_17    (mem_to_cnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_cnu_18    (mem_to_cnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_cnu_19    (mem_to_cnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_cnu_20    (mem_to_cnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_cnu_21    (mem_to_cnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_cnu_22    (mem_to_cnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_cnu_23    (mem_to_cnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_cnu_24    (mem_to_cnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_cnu_25    (mem_to_cnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_cnu_26    (mem_to_cnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_cnu_27    (mem_to_cnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_cnu_28    (mem_to_cnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_cnu_29    (mem_to_cnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_cnu_30    (mem_to_cnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_cnu_31    (mem_to_cnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_cnu_32    (mem_to_cnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_cnu_33    (mem_to_cnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_cnu_34    (mem_to_cnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_cnu_35    (mem_to_cnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_cnu_36    (mem_to_cnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_cnu_37    (mem_to_cnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_cnu_38    (mem_to_cnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_cnu_39    (mem_to_cnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_cnu_40    (mem_to_cnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_cnu_41    (mem_to_cnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_cnu_42    (mem_to_cnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_cnu_43    (mem_to_cnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_cnu_44    (mem_to_cnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_cnu_45    (mem_to_cnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_cnu_46    (mem_to_cnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_cnu_47    (mem_to_cnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_cnu_48    (mem_to_cnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_cnu_49    (mem_to_cnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_cnu_50    (mem_to_cnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_cnu_51    (mem_to_cnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_cnu_52    (mem_to_cnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_cnu_53    (mem_to_cnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_cnu_54    (mem_to_cnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_cnu_55    (mem_to_cnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_cnu_56    (mem_to_cnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_cnu_57    (mem_to_cnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_cnu_58    (mem_to_cnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_cnu_59    (mem_to_cnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_cnu_60    (mem_to_cnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_cnu_61    (mem_to_cnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_cnu_62    (mem_to_cnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_cnu_63    (mem_to_cnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_cnu_64    (mem_to_cnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_cnu_65    (mem_to_cnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_cnu_66    (mem_to_cnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_cnu_67    (mem_to_cnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_cnu_68    (mem_to_cnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_cnu_69    (mem_to_cnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_cnu_70    (mem_to_cnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_cnu_71    (mem_to_cnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_cnu_72    (mem_to_cnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_cnu_73    (mem_to_cnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_cnu_74    (mem_to_cnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_cnu_75    (mem_to_cnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_cnu_76    (mem_to_cnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_cnu_77    (mem_to_cnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_cnu_78    (mem_to_cnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_cnu_79    (mem_to_cnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_cnu_80    (mem_to_cnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_cnu_81    (mem_to_cnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_cnu_82    (mem_to_cnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_cnu_83    (mem_to_cnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_cnu_84    (mem_to_cnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),

			.vnu_to_mem_0     (vnu_msg_in[0 ]),
			.vnu_to_mem_1     (vnu_msg_in[1 ]),
			.vnu_to_mem_2     (vnu_msg_in[2 ]),
			.vnu_to_mem_3     (vnu_msg_in[3 ]),
			.vnu_to_mem_4     (vnu_msg_in[4 ]),
			.vnu_to_mem_5     (vnu_msg_in[5 ]),
			.vnu_to_mem_6     (vnu_msg_in[6 ]),
			.vnu_to_mem_7     (vnu_msg_in[7 ]),
			.vnu_to_mem_8     (vnu_msg_in[8 ]),
			.vnu_to_mem_9     (vnu_msg_in[9 ]),
			.vnu_to_mem_10    (vnu_msg_in[10]),
			.vnu_to_mem_11    (vnu_msg_in[11]),
			.vnu_to_mem_12    (vnu_msg_in[12]),
			.vnu_to_mem_13    (vnu_msg_in[13]),
			.vnu_to_mem_14    (vnu_msg_in[14]),
			.vnu_to_mem_15    (vnu_msg_in[15]),
			.vnu_to_mem_16    (vnu_msg_in[16]),
			.vnu_to_mem_17    (vnu_msg_in[17]),
			.vnu_to_mem_18    (vnu_msg_in[18]),
			.vnu_to_mem_19    (vnu_msg_in[19]),
			.vnu_to_mem_20    (vnu_msg_in[20]),
			.vnu_to_mem_21    (vnu_msg_in[21]),
			.vnu_to_mem_22    (vnu_msg_in[22]),
			.vnu_to_mem_23    (vnu_msg_in[23]),
			.vnu_to_mem_24    (vnu_msg_in[24]),
			.vnu_to_mem_25    (vnu_msg_in[25]),
			.vnu_to_mem_26    (vnu_msg_in[26]),
			.vnu_to_mem_27    (vnu_msg_in[27]),
			.vnu_to_mem_28    (vnu_msg_in[28]),
			.vnu_to_mem_29    (vnu_msg_in[29]),
			.vnu_to_mem_30    (vnu_msg_in[30]),
			.vnu_to_mem_31    (vnu_msg_in[31]),
			.vnu_to_mem_32    (vnu_msg_in[32]),
			.vnu_to_mem_33    (vnu_msg_in[33]),
			.vnu_to_mem_34    (vnu_msg_in[34]),
			.vnu_to_mem_35    (vnu_msg_in[35]),
			.vnu_to_mem_36    (vnu_msg_in[36]),
			.vnu_to_mem_37    (vnu_msg_in[37]),
			.vnu_to_mem_38    (vnu_msg_in[38]),
			.vnu_to_mem_39    (vnu_msg_in[39]),
			.vnu_to_mem_40    (vnu_msg_in[40]),
			.vnu_to_mem_41    (vnu_msg_in[41]),
			.vnu_to_mem_42    (vnu_msg_in[42]),
			.vnu_to_mem_43    (vnu_msg_in[43]),
			.vnu_to_mem_44    (vnu_msg_in[44]),
			.vnu_to_mem_45    (vnu_msg_in[45]),
			.vnu_to_mem_46    (vnu_msg_in[46]),
			.vnu_to_mem_47    (vnu_msg_in[47]),
			.vnu_to_mem_48    (vnu_msg_in[48]),
			.vnu_to_mem_49    (vnu_msg_in[49]),
			.vnu_to_mem_50    (vnu_msg_in[50]),
			.vnu_to_mem_51    (vnu_msg_in[51]),
			.vnu_to_mem_52    (vnu_msg_in[52]),
			.vnu_to_mem_53    (vnu_msg_in[53]),
			.vnu_to_mem_54    (vnu_msg_in[54]),
			.vnu_to_mem_55    (vnu_msg_in[55]),
			.vnu_to_mem_56    (vnu_msg_in[56]),
			.vnu_to_mem_57    (vnu_msg_in[57]),
			.vnu_to_mem_58    (vnu_msg_in[58]),
			.vnu_to_mem_59    (vnu_msg_in[59]),
			.vnu_to_mem_60    (vnu_msg_in[60]),
			.vnu_to_mem_61    (vnu_msg_in[61]),
			.vnu_to_mem_62    (vnu_msg_in[62]),
			.vnu_to_mem_63    (vnu_msg_in[63]),
			.vnu_to_mem_64    (vnu_msg_in[64]),
			.vnu_to_mem_65    (vnu_msg_in[65]),
			.vnu_to_mem_66    (vnu_msg_in[66]),
			.vnu_to_mem_67    (vnu_msg_in[67]),
			.vnu_to_mem_68    (vnu_msg_in[68]),
			.vnu_to_mem_69    (vnu_msg_in[69]),
			.vnu_to_mem_70    (vnu_msg_in[70]),
			.vnu_to_mem_71    (vnu_msg_in[71]),
			.vnu_to_mem_72    (vnu_msg_in[72]),
			.vnu_to_mem_73    (vnu_msg_in[73]),
			.vnu_to_mem_74    (vnu_msg_in[74]),
			.vnu_to_mem_75    (vnu_msg_in[75]),
			.vnu_to_mem_76    (vnu_msg_in[76]),
			.vnu_to_mem_77    (vnu_msg_in[77]),
			.vnu_to_mem_78    (vnu_msg_in[78]),
			.vnu_to_mem_79    (vnu_msg_in[79]),
			.vnu_to_mem_80    (vnu_msg_in[80]),
			.vnu_to_mem_81    (vnu_msg_in[81]),
			.vnu_to_mem_82    (vnu_msg_in[82]),
			.vnu_to_mem_83    (vnu_msg_in[83]),
			.vnu_to_mem_84    (vnu_msg_in[84]),
			.cnu_to_mem_0     (cnu_msg_in[0 ]),
			.cnu_to_mem_1     (cnu_msg_in[1 ]),
			.cnu_to_mem_2     (cnu_msg_in[2 ]),
			.cnu_to_mem_3     (cnu_msg_in[3 ]),
			.cnu_to_mem_4     (cnu_msg_in[4 ]),
			.cnu_to_mem_5     (cnu_msg_in[5 ]),
			.cnu_to_mem_6     (cnu_msg_in[6 ]),
			.cnu_to_mem_7     (cnu_msg_in[7 ]),
			.cnu_to_mem_8     (cnu_msg_in[8 ]),
			.cnu_to_mem_9     (cnu_msg_in[9 ]),
			.cnu_to_mem_10    (cnu_msg_in[10]),
			.cnu_to_mem_11    (cnu_msg_in[11]),
			.cnu_to_mem_12    (cnu_msg_in[12]),
			.cnu_to_mem_13    (cnu_msg_in[13]),
			.cnu_to_mem_14    (cnu_msg_in[14]),
			.cnu_to_mem_15    (cnu_msg_in[15]),
			.cnu_to_mem_16    (cnu_msg_in[16]),
			.cnu_to_mem_17    (cnu_msg_in[17]),
			.cnu_to_mem_18    (cnu_msg_in[18]),
			.cnu_to_mem_19    (cnu_msg_in[19]),
			.cnu_to_mem_20    (cnu_msg_in[20]),
			.cnu_to_mem_21    (cnu_msg_in[21]),
			.cnu_to_mem_22    (cnu_msg_in[22]),
			.cnu_to_mem_23    (cnu_msg_in[23]),
			.cnu_to_mem_24    (cnu_msg_in[24]),
			.cnu_to_mem_25    (cnu_msg_in[25]),
			.cnu_to_mem_26    (cnu_msg_in[26]),
			.cnu_to_mem_27    (cnu_msg_in[27]),
			.cnu_to_mem_28    (cnu_msg_in[28]),
			.cnu_to_mem_29    (cnu_msg_in[29]),
			.cnu_to_mem_30    (cnu_msg_in[30]),
			.cnu_to_mem_31    (cnu_msg_in[31]),
			.cnu_to_mem_32    (cnu_msg_in[32]),
			.cnu_to_mem_33    (cnu_msg_in[33]),
			.cnu_to_mem_34    (cnu_msg_in[34]),
			.cnu_to_mem_35    (cnu_msg_in[35]),
			.cnu_to_mem_36    (cnu_msg_in[36]),
			.cnu_to_mem_37    (cnu_msg_in[37]),
			.cnu_to_mem_38    (cnu_msg_in[38]),
			.cnu_to_mem_39    (cnu_msg_in[39]),
			.cnu_to_mem_40    (cnu_msg_in[40]),
			.cnu_to_mem_41    (cnu_msg_in[41]),
			.cnu_to_mem_42    (cnu_msg_in[42]),
			.cnu_to_mem_43    (cnu_msg_in[43]),
			.cnu_to_mem_44    (cnu_msg_in[44]),
			.cnu_to_mem_45    (cnu_msg_in[45]),
			.cnu_to_mem_46    (cnu_msg_in[46]),
			.cnu_to_mem_47    (cnu_msg_in[47]),
			.cnu_to_mem_48    (cnu_msg_in[48]),
			.cnu_to_mem_49    (cnu_msg_in[49]),
			.cnu_to_mem_50    (cnu_msg_in[50]),
			.cnu_to_mem_51    (cnu_msg_in[51]),
			.cnu_to_mem_52    (cnu_msg_in[52]),
			.cnu_to_mem_53    (cnu_msg_in[53]),
			.cnu_to_mem_54    (cnu_msg_in[54]),
			.cnu_to_mem_55    (cnu_msg_in[55]),
			.cnu_to_mem_56    (cnu_msg_in[56]),
			.cnu_to_mem_57    (cnu_msg_in[57]),
			.cnu_to_mem_58    (cnu_msg_in[58]),
			.cnu_to_mem_59    (cnu_msg_in[59]),
			.cnu_to_mem_60    (cnu_msg_in[60]),
			.cnu_to_mem_61    (cnu_msg_in[61]),
			.cnu_to_mem_62    (cnu_msg_in[62]),
			.cnu_to_mem_63    (cnu_msg_in[63]),
			.cnu_to_mem_64    (cnu_msg_in[64]),
			.cnu_to_mem_65    (cnu_msg_in[65]),
			.cnu_to_mem_66    (cnu_msg_in[66]),
			.cnu_to_mem_67    (cnu_msg_in[67]),
			.cnu_to_mem_68    (cnu_msg_in[68]),
			.cnu_to_mem_69    (cnu_msg_in[69]),
			.cnu_to_mem_70    (cnu_msg_in[70]),
			.cnu_to_mem_71    (cnu_msg_in[71]),
			.cnu_to_mem_72    (cnu_msg_in[72]),
			.cnu_to_mem_73    (cnu_msg_in[73]),
			.cnu_to_mem_74    (cnu_msg_in[74]),
			.cnu_to_mem_75    (cnu_msg_in[75]),
			.cnu_to_mem_76    (cnu_msg_in[76]),
			.cnu_to_mem_77    (cnu_msg_in[77]),
			.cnu_to_mem_78    (cnu_msg_in[78]),
			.cnu_to_mem_79    (cnu_msg_in[79]),
			.cnu_to_mem_80    (cnu_msg_in[80]),
			.cnu_to_mem_81    (cnu_msg_in[81]),
			.cnu_to_mem_82    (cnu_msg_in[82]),
			.cnu_to_mem_83    (cnu_msg_in[83]),
			.cnu_to_mem_84    (cnu_msg_in[84]),
			.cnu_sync_addr    (cnu_mem_page_sync_addr),
			.vnu_sync_addr    (vnu_mem_page_sync_addr),
			.cnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.vnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.last_row_chunk   ({c2v_last_row_chunk, v2c_last_row_chunk}),
			.we               ({v2c_mem_we, c2v_mem_we}),
			.sys_clk          (read_clk),
			.rstn             (rstn)
		);
		assign cnu_mem_page_sync_addr = (v2c_mem_fetch == 1'b1) ? v2c_mem_page_rd_addr : 
										(c2v_mem_we == 1'b1) ? c2v_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.

		assign vnu_mem_page_sync_addr = (c2v_mem_fetch == 1'b1) ? c2v_mem_page_rd_addr : 
										(v2c_mem_we == 1'b1) ? v2c_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Check-to-Variable messages RAMs write-page addresses
	always @(posedge read_clk) begin
		if(rstn == 1'b0) 
			c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE;
		else if(c2v_mem_we == 1'b1) begin
			// page increment pattern within layer 0
			if(v2c_layer_cnt[0] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_1+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 1
			if(v2c_layer_cnt[1] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_2+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 2
			if(v2c_layer_cnt[2] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_2-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
		end
	end

	always @(posedge read_clk) begin
		if(rstn == 1'b0) begin
			c2v_shift_factor_cur_2 <= shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
		end
		else if(c2v_bs_en == 1'b1) begin
			c2v_shift_factor_cur_2 <= 0;
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
/*--------------------------------------------------------------------------*/
// Channel Buffers
reg [CH_DATA_WIDTH-1:0] ch_msg_genIn;
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_0 [0:CHECK_PARALLELISM-1]; // [0:84]
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_1 [0:CHECK_PARALLELISM-1]; // [0:84]
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_rd_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chInit_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chLayer_wr_addr;
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

			.din        (ch_msg_genIn[CH_DATA_WIDTH-1:0]),

			.read_addr  (submatrix_ch_ram_rd_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.write_addr (submatrix_ch_ram_wr_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.we         (ch_ram_we),
			.read_clk   (ch_ram_rd_clk),
			.write_clk  (ch_ram_wr_clk),
			.rstn       (rstn)
		);
		// Updating the Channel RAMs by either initally channel messages (from AWGNs) or circularly shifted channel messages
		assign submatrix_ch_ram_wr_addr = (ch_ram_init_we == 1'b1) ? submatrix_chInit_wr_addr :
														(ch_ram_wb == 1'b1     ) ? submatrix_chLayer_wr_addr : 
																				   CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.


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
	// Channel messages RAMs write-page addresses
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
endmodule

module msg_pass_submatrix_6_unit #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,
	parameter VN_DEGREE = 3,   // degree of one variable node
/*-------------------------------------------------------------------------------------*/
	// Parameters related to BS, PA and MEM
	parameter RAM_DEPTH = 1024,
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH),
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1),
	parameter shift_factor_0 = CHECK_PARALLELISM-39,
	parameter shift_factor_1 = CHECK_PARALLELISM-8 ,
	parameter shift_factor_2 = CHECK_PARALLELISM-47,

`ifdef SCHED_4_6
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,
	parameter C2V_MEM_ADDR_BASE = 0,
	parameter V2C_MEM_ADDR_BASE = ROW_CHUNK_NUM,
	parameter V2C_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter C2V_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH),
`endif
	parameter START_PAGE_1_0 = 2, // starting page address of layer 0 of submatrix_1
	parameter START_PAGE_1_1 = 8, // starting page address of layer 1 of submatrix_1
	parameter START_PAGE_1_2 = 1  // starting page address of layer 2 of submatrix_1
) (
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu,

	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit,

	// control signals
	input wire c2v_bs_en,
	input wire v2c_bs_en,
	input wire ch_bs_en,
	/*------------------------------*/
	// Control signals associative with message passing of channel buffer and DNU.SignExtension
	input wire ch_ram_init_we,
	input wire ch_ram_fetch,
	input wire v2c_outRotate_reg_we,
	input wire dnu_inRotate_bs_en,
	input wire dnu_inRotate_pa_en,
	input wire dnu_inRotate_wb,
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
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,

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
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_2;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_2;
wire [6:0]  cnu_left_sel;
wire [6:0]  cnu_right_sel;
wire [83:0] cnu_merge_sel;
wire [6:0]  vnu_left_sel;
wire [6:0]  vnu_right_sel;
wire [83:0] vnu_merge_sel;
wire [CHECK_PARALLELISM-1:0] cnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] vnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] ch_bs_in_bit [0:QUAN_SIZE-1];
genvar bit_index;
generate
	for(bit_index=0;bit_index<QUAN_SIZE;bit_index=bit_index+1) begin : extrinsic_msg_bs_in_inst
		assign cnu_bs_in_bit[bit_index] = {c2v_bs_in[QUAN_SIZE*84+bit_index],c2v_bs_in[QUAN_SIZE*83+bit_index],c2v_bs_in[QUAN_SIZE*82+bit_index],c2v_bs_in[QUAN_SIZE*81+bit_index],c2v_bs_in[QUAN_SIZE*80+bit_index],c2v_bs_in[QUAN_SIZE*79+bit_index],c2v_bs_in[QUAN_SIZE*78+bit_index],c2v_bs_in[QUAN_SIZE*77+bit_index],c2v_bs_in[QUAN_SIZE*76+bit_index],c2v_bs_in[QUAN_SIZE*75+bit_index],c2v_bs_in[QUAN_SIZE*74+bit_index],c2v_bs_in[QUAN_SIZE*73+bit_index],c2v_bs_in[QUAN_SIZE*72+bit_index],c2v_bs_in[QUAN_SIZE*71+bit_index],c2v_bs_in[QUAN_SIZE*70+bit_index],c2v_bs_in[QUAN_SIZE*69+bit_index],c2v_bs_in[QUAN_SIZE*68+bit_index],c2v_bs_in[QUAN_SIZE*67+bit_index],c2v_bs_in[QUAN_SIZE*66+bit_index],c2v_bs_in[QUAN_SIZE*65+bit_index],c2v_bs_in[QUAN_SIZE*64+bit_index],c2v_bs_in[QUAN_SIZE*63+bit_index],c2v_bs_in[QUAN_SIZE*62+bit_index],c2v_bs_in[QUAN_SIZE*61+bit_index],c2v_bs_in[QUAN_SIZE*60+bit_index],c2v_bs_in[QUAN_SIZE*59+bit_index],c2v_bs_in[QUAN_SIZE*58+bit_index],c2v_bs_in[QUAN_SIZE*57+bit_index],c2v_bs_in[QUAN_SIZE*56+bit_index],c2v_bs_in[QUAN_SIZE*55+bit_index],c2v_bs_in[QUAN_SIZE*54+bit_index],c2v_bs_in[QUAN_SIZE*53+bit_index],c2v_bs_in[QUAN_SIZE*52+bit_index],c2v_bs_in[QUAN_SIZE*51+bit_index],c2v_bs_in[QUAN_SIZE*50+bit_index],c2v_bs_in[QUAN_SIZE*49+bit_index],c2v_bs_in[QUAN_SIZE*48+bit_index],c2v_bs_in[QUAN_SIZE*47+bit_index],c2v_bs_in[QUAN_SIZE*46+bit_index],c2v_bs_in[QUAN_SIZE*45+bit_index],c2v_bs_in[QUAN_SIZE*44+bit_index],c2v_bs_in[QUAN_SIZE*43+bit_index],c2v_bs_in[QUAN_SIZE*42+bit_index],c2v_bs_in[QUAN_SIZE*41+bit_index],c2v_bs_in[QUAN_SIZE*40+bit_index],c2v_bs_in[QUAN_SIZE*39+bit_index],c2v_bs_in[QUAN_SIZE*38+bit_index],c2v_bs_in[QUAN_SIZE*37+bit_index],c2v_bs_in[QUAN_SIZE*36+bit_index],c2v_bs_in[QUAN_SIZE*35+bit_index],c2v_bs_in[QUAN_SIZE*34+bit_index],c2v_bs_in[QUAN_SIZE*33+bit_index],c2v_bs_in[QUAN_SIZE*32+bit_index],c2v_bs_in[QUAN_SIZE*31+bit_index],c2v_bs_in[QUAN_SIZE*30+bit_index],c2v_bs_in[QUAN_SIZE*29+bit_index],c2v_bs_in[QUAN_SIZE*28+bit_index],c2v_bs_in[QUAN_SIZE*27+bit_index],c2v_bs_in[QUAN_SIZE*26+bit_index],c2v_bs_in[QUAN_SIZE*25+bit_index],c2v_bs_in[QUAN_SIZE*24+bit_index],c2v_bs_in[QUAN_SIZE*23+bit_index],c2v_bs_in[QUAN_SIZE*22+bit_index],c2v_bs_in[QUAN_SIZE*21+bit_index],c2v_bs_in[QUAN_SIZE*20+bit_index],c2v_bs_in[QUAN_SIZE*19+bit_index],c2v_bs_in[QUAN_SIZE*18+bit_index],c2v_bs_in[QUAN_SIZE*17+bit_index],c2v_bs_in[QUAN_SIZE*16+bit_index],c2v_bs_in[QUAN_SIZE*15+bit_index],c2v_bs_in[QUAN_SIZE*14+bit_index],c2v_bs_in[QUAN_SIZE*13+bit_index],c2v_bs_in[QUAN_SIZE*12+bit_index],c2v_bs_in[QUAN_SIZE*11+bit_index],c2v_bs_in[QUAN_SIZE*10+bit_index],c2v_bs_in[QUAN_SIZE*9+bit_index],c2v_bs_in[QUAN_SIZE*8+bit_index],c2v_bs_in[QUAN_SIZE*7+bit_index],c2v_bs_in[QUAN_SIZE*6+bit_index],c2v_bs_in[QUAN_SIZE*5+bit_index],c2v_bs_in[QUAN_SIZE*4+bit_index],c2v_bs_in[QUAN_SIZE*3+bit_index],c2v_bs_in[QUAN_SIZE*2+bit_index],c2v_bs_in[QUAN_SIZE*1+bit_index],c2v_bs_in[QUAN_SIZE*0+bit_index]};
		assign vnu_bs_in_bit[bit_index] = {v2c_bs_in[QUAN_SIZE*84+bit_index],v2c_bs_in[QUAN_SIZE*83+bit_index],v2c_bs_in[QUAN_SIZE*82+bit_index],v2c_bs_in[QUAN_SIZE*81+bit_index],v2c_bs_in[QUAN_SIZE*80+bit_index],v2c_bs_in[QUAN_SIZE*79+bit_index],v2c_bs_in[QUAN_SIZE*78+bit_index],v2c_bs_in[QUAN_SIZE*77+bit_index],v2c_bs_in[QUAN_SIZE*76+bit_index],v2c_bs_in[QUAN_SIZE*75+bit_index],v2c_bs_in[QUAN_SIZE*74+bit_index],v2c_bs_in[QUAN_SIZE*73+bit_index],v2c_bs_in[QUAN_SIZE*72+bit_index],v2c_bs_in[QUAN_SIZE*71+bit_index],v2c_bs_in[QUAN_SIZE*70+bit_index],v2c_bs_in[QUAN_SIZE*69+bit_index],v2c_bs_in[QUAN_SIZE*68+bit_index],v2c_bs_in[QUAN_SIZE*67+bit_index],v2c_bs_in[QUAN_SIZE*66+bit_index],v2c_bs_in[QUAN_SIZE*65+bit_index],v2c_bs_in[QUAN_SIZE*64+bit_index],v2c_bs_in[QUAN_SIZE*63+bit_index],v2c_bs_in[QUAN_SIZE*62+bit_index],v2c_bs_in[QUAN_SIZE*61+bit_index],v2c_bs_in[QUAN_SIZE*60+bit_index],v2c_bs_in[QUAN_SIZE*59+bit_index],v2c_bs_in[QUAN_SIZE*58+bit_index],v2c_bs_in[QUAN_SIZE*57+bit_index],v2c_bs_in[QUAN_SIZE*56+bit_index],v2c_bs_in[QUAN_SIZE*55+bit_index],v2c_bs_in[QUAN_SIZE*54+bit_index],v2c_bs_in[QUAN_SIZE*53+bit_index],v2c_bs_in[QUAN_SIZE*52+bit_index],v2c_bs_in[QUAN_SIZE*51+bit_index],v2c_bs_in[QUAN_SIZE*50+bit_index],v2c_bs_in[QUAN_SIZE*49+bit_index],v2c_bs_in[QUAN_SIZE*48+bit_index],v2c_bs_in[QUAN_SIZE*47+bit_index],v2c_bs_in[QUAN_SIZE*46+bit_index],v2c_bs_in[QUAN_SIZE*45+bit_index],v2c_bs_in[QUAN_SIZE*44+bit_index],v2c_bs_in[QUAN_SIZE*43+bit_index],v2c_bs_in[QUAN_SIZE*42+bit_index],v2c_bs_in[QUAN_SIZE*41+bit_index],v2c_bs_in[QUAN_SIZE*40+bit_index],v2c_bs_in[QUAN_SIZE*39+bit_index],v2c_bs_in[QUAN_SIZE*38+bit_index],v2c_bs_in[QUAN_SIZE*37+bit_index],v2c_bs_in[QUAN_SIZE*36+bit_index],v2c_bs_in[QUAN_SIZE*35+bit_index],v2c_bs_in[QUAN_SIZE*34+bit_index],v2c_bs_in[QUAN_SIZE*33+bit_index],v2c_bs_in[QUAN_SIZE*32+bit_index],v2c_bs_in[QUAN_SIZE*31+bit_index],v2c_bs_in[QUAN_SIZE*30+bit_index],v2c_bs_in[QUAN_SIZE*29+bit_index],v2c_bs_in[QUAN_SIZE*28+bit_index],v2c_bs_in[QUAN_SIZE*27+bit_index],v2c_bs_in[QUAN_SIZE*26+bit_index],v2c_bs_in[QUAN_SIZE*25+bit_index],v2c_bs_in[QUAN_SIZE*24+bit_index],v2c_bs_in[QUAN_SIZE*23+bit_index],v2c_bs_in[QUAN_SIZE*22+bit_index],v2c_bs_in[QUAN_SIZE*21+bit_index],v2c_bs_in[QUAN_SIZE*20+bit_index],v2c_bs_in[QUAN_SIZE*19+bit_index],v2c_bs_in[QUAN_SIZE*18+bit_index],v2c_bs_in[QUAN_SIZE*17+bit_index],v2c_bs_in[QUAN_SIZE*16+bit_index],v2c_bs_in[QUAN_SIZE*15+bit_index],v2c_bs_in[QUAN_SIZE*14+bit_index],v2c_bs_in[QUAN_SIZE*13+bit_index],v2c_bs_in[QUAN_SIZE*12+bit_index],v2c_bs_in[QUAN_SIZE*11+bit_index],v2c_bs_in[QUAN_SIZE*10+bit_index],v2c_bs_in[QUAN_SIZE*9+bit_index],v2c_bs_in[QUAN_SIZE*8+bit_index],v2c_bs_in[QUAN_SIZE*7+bit_index],v2c_bs_in[QUAN_SIZE*6+bit_index],v2c_bs_in[QUAN_SIZE*5+bit_index],v2c_bs_in[QUAN_SIZE*4+bit_index],v2c_bs_in[QUAN_SIZE*3+bit_index],v2c_bs_in[QUAN_SIZE*2+bit_index],v2c_bs_in[QUAN_SIZE*1+bit_index],v2c_bs_in[QUAN_SIZE*0+bit_index]};
		assign ch_bs_in_bit[bit_index]  = { ch_bs_in[QUAN_SIZE*84+bit_index], ch_bs_in[QUAN_SIZE*83+bit_index], ch_bs_in[QUAN_SIZE*82+bit_index], ch_bs_in[QUAN_SIZE*81+bit_index], ch_bs_in[QUAN_SIZE*80+bit_index], ch_bs_in[QUAN_SIZE*79+bit_index], ch_bs_in[QUAN_SIZE*78+bit_index], ch_bs_in[QUAN_SIZE*77+bit_index], ch_bs_in[QUAN_SIZE*76+bit_index], ch_bs_in[QUAN_SIZE*75+bit_index], ch_bs_in[QUAN_SIZE*74+bit_index], ch_bs_in[QUAN_SIZE*73+bit_index], ch_bs_in[QUAN_SIZE*72+bit_index], ch_bs_in[QUAN_SIZE*71+bit_index], ch_bs_in[QUAN_SIZE*70+bit_index], ch_bs_in[QUAN_SIZE*69+bit_index], ch_bs_in[QUAN_SIZE*68+bit_index], ch_bs_in[QUAN_SIZE*67+bit_index], ch_bs_in[QUAN_SIZE*66+bit_index], ch_bs_in[QUAN_SIZE*65+bit_index], ch_bs_in[QUAN_SIZE*64+bit_index], ch_bs_in[QUAN_SIZE*63+bit_index], ch_bs_in[QUAN_SIZE*62+bit_index], ch_bs_in[QUAN_SIZE*61+bit_index], ch_bs_in[QUAN_SIZE*60+bit_index], ch_bs_in[QUAN_SIZE*59+bit_index], ch_bs_in[QUAN_SIZE*58+bit_index], ch_bs_in[QUAN_SIZE*57+bit_index], ch_bs_in[QUAN_SIZE*56+bit_index], ch_bs_in[QUAN_SIZE*55+bit_index], ch_bs_in[QUAN_SIZE*54+bit_index], ch_bs_in[QUAN_SIZE*53+bit_index], ch_bs_in[QUAN_SIZE*52+bit_index], ch_bs_in[QUAN_SIZE*51+bit_index], ch_bs_in[QUAN_SIZE*50+bit_index], ch_bs_in[QUAN_SIZE*49+bit_index], ch_bs_in[QUAN_SIZE*48+bit_index], ch_bs_in[QUAN_SIZE*47+bit_index], ch_bs_in[QUAN_SIZE*46+bit_index], ch_bs_in[QUAN_SIZE*45+bit_index], ch_bs_in[QUAN_SIZE*44+bit_index], ch_bs_in[QUAN_SIZE*43+bit_index], ch_bs_in[QUAN_SIZE*42+bit_index], ch_bs_in[QUAN_SIZE*41+bit_index], ch_bs_in[QUAN_SIZE*40+bit_index], ch_bs_in[QUAN_SIZE*39+bit_index], ch_bs_in[QUAN_SIZE*38+bit_index], ch_bs_in[QUAN_SIZE*37+bit_index], ch_bs_in[QUAN_SIZE*36+bit_index], ch_bs_in[QUAN_SIZE*35+bit_index], ch_bs_in[QUAN_SIZE*34+bit_index], ch_bs_in[QUAN_SIZE*33+bit_index], ch_bs_in[QUAN_SIZE*32+bit_index], ch_bs_in[QUAN_SIZE*31+bit_index], ch_bs_in[QUAN_SIZE*30+bit_index], ch_bs_in[QUAN_SIZE*29+bit_index], ch_bs_in[QUAN_SIZE*28+bit_index], ch_bs_in[QUAN_SIZE*27+bit_index], ch_bs_in[QUAN_SIZE*26+bit_index], ch_bs_in[QUAN_SIZE*25+bit_index], ch_bs_in[QUAN_SIZE*24+bit_index], ch_bs_in[QUAN_SIZE*23+bit_index], ch_bs_in[QUAN_SIZE*22+bit_index], ch_bs_in[QUAN_SIZE*21+bit_index], ch_bs_in[QUAN_SIZE*20+bit_index], ch_bs_in[QUAN_SIZE*19+bit_index], ch_bs_in[QUAN_SIZE*18+bit_index], ch_bs_in[QUAN_SIZE*17+bit_index], ch_bs_in[QUAN_SIZE*16+bit_index], ch_bs_in[QUAN_SIZE*15+bit_index], ch_bs_in[QUAN_SIZE*14+bit_index], ch_bs_in[QUAN_SIZE*13+bit_index], ch_bs_in[QUAN_SIZE*12+bit_index], ch_bs_in[QUAN_SIZE*11+bit_index], ch_bs_in[QUAN_SIZE*10+bit_index], ch_bs_in[QUAN_SIZE*9+bit_index], ch_bs_in[QUAN_SIZE*8+bit_index], ch_bs_in[QUAN_SIZE*7+bit_index], ch_bs_in[QUAN_SIZE*6+bit_index], ch_bs_in[QUAN_SIZE*5+bit_index], ch_bs_in[QUAN_SIZE*4+bit_index], ch_bs_in[QUAN_SIZE*3+bit_index], ch_bs_in[QUAN_SIZE*2+bit_index],ch_bs_in[QUAN_SIZE*1+bit_index], ch_bs_in[QUAN_SIZE*0+bit_index]};
	end
endgenerate
/*----------------------------------------------*/	
// Circular shifter of check nodes 
qsn_top_85b cnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({cnu_msg_in[84][0],cnu_msg_in[83][0],cnu_msg_in[82][0],cnu_msg_in[81][0],cnu_msg_in[80][0],cnu_msg_in[79][0],cnu_msg_in[78][0],cnu_msg_in[77][0],cnu_msg_in[76][0],cnu_msg_in[75][0],cnu_msg_in[74][0],cnu_msg_in[73][0],cnu_msg_in[72][0],cnu_msg_in[71][0],cnu_msg_in[70][0],cnu_msg_in[69][0],cnu_msg_in[68][0],cnu_msg_in[67][0],cnu_msg_in[66][0],cnu_msg_in[65][0],cnu_msg_in[64][0],cnu_msg_in[63][0],cnu_msg_in[62][0],cnu_msg_in[61][0],cnu_msg_in[60][0],cnu_msg_in[59][0],cnu_msg_in[58][0],cnu_msg_in[57][0],cnu_msg_in[56][0],cnu_msg_in[55][0],cnu_msg_in[54][0],cnu_msg_in[53][0],cnu_msg_in[52][0],cnu_msg_in[51][0],cnu_msg_in[50][0],cnu_msg_in[49][0],cnu_msg_in[48][0],cnu_msg_in[47][0],cnu_msg_in[46][0],cnu_msg_in[45][0],cnu_msg_in[44][0],cnu_msg_in[43][0],cnu_msg_in[42][0],cnu_msg_in[41][0],cnu_msg_in[40][0],cnu_msg_in[39][0],cnu_msg_in[38][0],cnu_msg_in[37][0],cnu_msg_in[36][0],cnu_msg_in[35][0],cnu_msg_in[34][0],cnu_msg_in[33][0],cnu_msg_in[32][0],cnu_msg_in[31][0],cnu_msg_in[30][0],cnu_msg_in[29][0],cnu_msg_in[28][0],cnu_msg_in[27][0],cnu_msg_in[26][0],cnu_msg_in[25][0],cnu_msg_in[24][0],cnu_msg_in[23][0],cnu_msg_in[22][0],cnu_msg_in[21][0],cnu_msg_in[20][0],cnu_msg_in[19][0],cnu_msg_in[18][0],cnu_msg_in[17][0],cnu_msg_in[16][0],cnu_msg_in[15][0],cnu_msg_in[14][0],cnu_msg_in[13][0],cnu_msg_in[12][0],cnu_msg_in[11][0],cnu_msg_in[10][0],cnu_msg_in[9][0],cnu_msg_in[8][0],cnu_msg_in[7][0],cnu_msg_in[6][0],cnu_msg_in[5][0],cnu_msg_in[4][0],cnu_msg_in[3][0],cnu_msg_in[2][0],cnu_msg_in[1][0],cnu_msg_in[0][0]}),
	.sw_out_bit1 ({cnu_msg_in[84][1],cnu_msg_in[83][1],cnu_msg_in[82][1],cnu_msg_in[81][1],cnu_msg_in[80][1],cnu_msg_in[79][1],cnu_msg_in[78][1],cnu_msg_in[77][1],cnu_msg_in[76][1],cnu_msg_in[75][1],cnu_msg_in[74][1],cnu_msg_in[73][1],cnu_msg_in[72][1],cnu_msg_in[71][1],cnu_msg_in[70][1],cnu_msg_in[69][1],cnu_msg_in[68][1],cnu_msg_in[67][1],cnu_msg_in[66][1],cnu_msg_in[65][1],cnu_msg_in[64][1],cnu_msg_in[63][1],cnu_msg_in[62][1],cnu_msg_in[61][1],cnu_msg_in[60][1],cnu_msg_in[59][1],cnu_msg_in[58][1],cnu_msg_in[57][1],cnu_msg_in[56][1],cnu_msg_in[55][1],cnu_msg_in[54][1],cnu_msg_in[53][1],cnu_msg_in[52][1],cnu_msg_in[51][1],cnu_msg_in[50][1],cnu_msg_in[49][1],cnu_msg_in[48][1],cnu_msg_in[47][1],cnu_msg_in[46][1],cnu_msg_in[45][1],cnu_msg_in[44][1],cnu_msg_in[43][1],cnu_msg_in[42][1],cnu_msg_in[41][1],cnu_msg_in[40][1],cnu_msg_in[39][1],cnu_msg_in[38][1],cnu_msg_in[37][1],cnu_msg_in[36][1],cnu_msg_in[35][1],cnu_msg_in[34][1],cnu_msg_in[33][1],cnu_msg_in[32][1],cnu_msg_in[31][1],cnu_msg_in[30][1],cnu_msg_in[29][1],cnu_msg_in[28][1],cnu_msg_in[27][1],cnu_msg_in[26][1],cnu_msg_in[25][1],cnu_msg_in[24][1],cnu_msg_in[23][1],cnu_msg_in[22][1],cnu_msg_in[21][1],cnu_msg_in[20][1],cnu_msg_in[19][1],cnu_msg_in[18][1],cnu_msg_in[17][1],cnu_msg_in[16][1],cnu_msg_in[15][1],cnu_msg_in[14][1],cnu_msg_in[13][1],cnu_msg_in[12][1],cnu_msg_in[11][1],cnu_msg_in[10][1],cnu_msg_in[9][1],cnu_msg_in[8][1],cnu_msg_in[7][1],cnu_msg_in[6][1],cnu_msg_in[5][1],cnu_msg_in[4][1],cnu_msg_in[3][1],cnu_msg_in[2][1],cnu_msg_in[1][1],cnu_msg_in[0][1]}),
	.sw_out_bit2 ({cnu_msg_in[84][2],cnu_msg_in[83][2],cnu_msg_in[82][2],cnu_msg_in[81][2],cnu_msg_in[80][2],cnu_msg_in[79][2],cnu_msg_in[78][2],cnu_msg_in[77][2],cnu_msg_in[76][2],cnu_msg_in[75][2],cnu_msg_in[74][2],cnu_msg_in[73][2],cnu_msg_in[72][2],cnu_msg_in[71][2],cnu_msg_in[70][2],cnu_msg_in[69][2],cnu_msg_in[68][2],cnu_msg_in[67][2],cnu_msg_in[66][2],cnu_msg_in[65][2],cnu_msg_in[64][2],cnu_msg_in[63][2],cnu_msg_in[62][2],cnu_msg_in[61][2],cnu_msg_in[60][2],cnu_msg_in[59][2],cnu_msg_in[58][2],cnu_msg_in[57][2],cnu_msg_in[56][2],cnu_msg_in[55][2],cnu_msg_in[54][2],cnu_msg_in[53][2],cnu_msg_in[52][2],cnu_msg_in[51][2],cnu_msg_in[50][2],cnu_msg_in[49][2],cnu_msg_in[48][2],cnu_msg_in[47][2],cnu_msg_in[46][2],cnu_msg_in[45][2],cnu_msg_in[44][2],cnu_msg_in[43][2],cnu_msg_in[42][2],cnu_msg_in[41][2],cnu_msg_in[40][2],cnu_msg_in[39][2],cnu_msg_in[38][2],cnu_msg_in[37][2],cnu_msg_in[36][2],cnu_msg_in[35][2],cnu_msg_in[34][2],cnu_msg_in[33][2],cnu_msg_in[32][2],cnu_msg_in[31][2],cnu_msg_in[30][2],cnu_msg_in[29][2],cnu_msg_in[28][2],cnu_msg_in[27][2],cnu_msg_in[26][2],cnu_msg_in[25][2],cnu_msg_in[24][2],cnu_msg_in[23][2],cnu_msg_in[22][2],cnu_msg_in[21][2],cnu_msg_in[20][2],cnu_msg_in[19][2],cnu_msg_in[18][2],cnu_msg_in[17][2],cnu_msg_in[16][2],cnu_msg_in[15][2],cnu_msg_in[14][2],cnu_msg_in[13][2],cnu_msg_in[12][2],cnu_msg_in[11][2],cnu_msg_in[10][2],cnu_msg_in[9][2],cnu_msg_in[8][2],cnu_msg_in[7][2],cnu_msg_in[6][2],cnu_msg_in[5][2],cnu_msg_in[4][2],cnu_msg_in[3][2],cnu_msg_in[2][2],cnu_msg_in[1][2],cnu_msg_in[0][2]}),	
	.sw_out_bit3 ({cnu_msg_in[84][3],cnu_msg_in[83][3],cnu_msg_in[82][3],cnu_msg_in[81][3],cnu_msg_in[80][3],cnu_msg_in[79][3],cnu_msg_in[78][3],cnu_msg_in[77][3],cnu_msg_in[76][3],cnu_msg_in[75][3],cnu_msg_in[74][3],cnu_msg_in[73][3],cnu_msg_in[72][3],cnu_msg_in[71][3],cnu_msg_in[70][3],cnu_msg_in[69][3],cnu_msg_in[68][3],cnu_msg_in[67][3],cnu_msg_in[66][3],cnu_msg_in[65][3],cnu_msg_in[64][3],cnu_msg_in[63][3],cnu_msg_in[62][3],cnu_msg_in[61][3],cnu_msg_in[60][3],cnu_msg_in[59][3],cnu_msg_in[58][3],cnu_msg_in[57][3],cnu_msg_in[56][3],cnu_msg_in[55][3],cnu_msg_in[54][3],cnu_msg_in[53][3],cnu_msg_in[52][3],cnu_msg_in[51][3],cnu_msg_in[50][3],cnu_msg_in[49][3],cnu_msg_in[48][3],cnu_msg_in[47][3],cnu_msg_in[46][3],cnu_msg_in[45][3],cnu_msg_in[44][3],cnu_msg_in[43][3],cnu_msg_in[42][3],cnu_msg_in[41][3],cnu_msg_in[40][3],cnu_msg_in[39][3],cnu_msg_in[38][3],cnu_msg_in[37][3],cnu_msg_in[36][3],cnu_msg_in[35][3],cnu_msg_in[34][3],cnu_msg_in[33][3],cnu_msg_in[32][3],cnu_msg_in[31][3],cnu_msg_in[30][3],cnu_msg_in[29][3],cnu_msg_in[28][3],cnu_msg_in[27][3],cnu_msg_in[26][3],cnu_msg_in[25][3],cnu_msg_in[24][3],cnu_msg_in[23][3],cnu_msg_in[22][3],cnu_msg_in[21][3],cnu_msg_in[20][3],cnu_msg_in[19][3],cnu_msg_in[18][3],cnu_msg_in[17][3],cnu_msg_in[16][3],cnu_msg_in[15][3],cnu_msg_in[14][3],cnu_msg_in[13][3],cnu_msg_in[12][3],cnu_msg_in[11][3],cnu_msg_in[10][3],cnu_msg_in[9][3],cnu_msg_in[8][3],cnu_msg_in[7][3],cnu_msg_in[6][3],cnu_msg_in[5][3],cnu_msg_in[4][3],cnu_msg_in[3][3],cnu_msg_in[2][3],cnu_msg_in[1][3],cnu_msg_in[0][3]}),
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in_bit0  (cnu_bs_in_bit[0]),
	.sw_in_bit1  (cnu_bs_in_bit[1]),
	.sw_in_bit2  (cnu_bs_in_bit[2]),
	.sw_in_bit3  (cnu_bs_in_bit[3]),
	.left_sel    (cnu_left_sel),
	.right_sel   (cnu_right_sel),
	.merge_sel   (cnu_merge_sel)
);
qsn_controller_85b #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) cnu_qsn_controller_85b (
	.left_sel     (cnu_left_sel ),
	.right_sel    (cnu_right_sel),
	.merge_sel    (cnu_merge_sel),
	.shift_factor (c2v_shift_factor_cur_0), // offset shift factor of submatrix_1
	.rstn         (rstn),
	.sys_clk      (read_clk)
);
/*----------------------------------------------*/
// Circular shifter of variable nodes 
wire [BITWIDTH_SHIFT_FACTOR-1:0] vnu_shift_factorIn;
wire [BITWIDTH_SHIFT_FACTOR-1:0] dnu_inRotate_shift_factor; // a constant, because only needed at last layer
shared_qsn_top_85b #(
		.QUAN_SIZE(QUAN_SIZE),
		.CHECK_PARALLELISM(CHECK_PARALLELISM),
		.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR)
) inst_shared_qsn_top_85b (
	.sw_out_bit0 ({vnu_msg_in[84][0],vnu_msg_in[83][0],vnu_msg_in[82][0],vnu_msg_in[81][0],vnu_msg_in[80][0],vnu_msg_in[79][0],vnu_msg_in[78][0],vnu_msg_in[77][0],vnu_msg_in[76][0],vnu_msg_in[75][0],vnu_msg_in[74][0],vnu_msg_in[73][0],vnu_msg_in[72][0],vnu_msg_in[71][0],vnu_msg_in[70][0],vnu_msg_in[69][0],vnu_msg_in[68][0],vnu_msg_in[67][0],vnu_msg_in[66][0],vnu_msg_in[65][0],vnu_msg_in[64][0],vnu_msg_in[63][0],vnu_msg_in[62][0],vnu_msg_in[61][0],vnu_msg_in[60][0],vnu_msg_in[59][0],vnu_msg_in[58][0],vnu_msg_in[57][0],vnu_msg_in[56][0],vnu_msg_in[55][0],vnu_msg_in[54][0],vnu_msg_in[53][0],vnu_msg_in[52][0],vnu_msg_in[51][0],vnu_msg_in[50][0],vnu_msg_in[49][0],vnu_msg_in[48][0],vnu_msg_in[47][0],vnu_msg_in[46][0],vnu_msg_in[45][0],vnu_msg_in[44][0],vnu_msg_in[43][0],vnu_msg_in[42][0],vnu_msg_in[41][0],vnu_msg_in[40][0],vnu_msg_in[39][0],vnu_msg_in[38][0],vnu_msg_in[37][0],vnu_msg_in[36][0],vnu_msg_in[35][0],vnu_msg_in[34][0],vnu_msg_in[33][0],vnu_msg_in[32][0],vnu_msg_in[31][0],vnu_msg_in[30][0],vnu_msg_in[29][0],vnu_msg_in[28][0],vnu_msg_in[27][0],vnu_msg_in[26][0],vnu_msg_in[25][0],vnu_msg_in[24][0],vnu_msg_in[23][0],vnu_msg_in[22][0],vnu_msg_in[21][0],vnu_msg_in[20][0],vnu_msg_in[19][0],vnu_msg_in[18][0],vnu_msg_in[17][0],vnu_msg_in[16][0],vnu_msg_in[15][0],vnu_msg_in[14][0],vnu_msg_in[13][0],vnu_msg_in[12][0],vnu_msg_in[11][0],vnu_msg_in[10][0],vnu_msg_in[9][0],vnu_msg_in[8][0],vnu_msg_in[7][0],vnu_msg_in[6][0],vnu_msg_in[5][0],vnu_msg_in[4][0],vnu_msg_in[3][0],vnu_msg_in[2][0],vnu_msg_in[1][0],vnu_msg_in[0][0]}),	
	.sw_out_bit1 ({vnu_msg_in[84][1],vnu_msg_in[83][1],vnu_msg_in[82][1],vnu_msg_in[81][1],vnu_msg_in[80][1],vnu_msg_in[79][1],vnu_msg_in[78][1],vnu_msg_in[77][1],vnu_msg_in[76][1],vnu_msg_in[75][1],vnu_msg_in[74][1],vnu_msg_in[73][1],vnu_msg_in[72][1],vnu_msg_in[71][1],vnu_msg_in[70][1],vnu_msg_in[69][1],vnu_msg_in[68][1],vnu_msg_in[67][1],vnu_msg_in[66][1],vnu_msg_in[65][1],vnu_msg_in[64][1],vnu_msg_in[63][1],vnu_msg_in[62][1],vnu_msg_in[61][1],vnu_msg_in[60][1],vnu_msg_in[59][1],vnu_msg_in[58][1],vnu_msg_in[57][1],vnu_msg_in[56][1],vnu_msg_in[55][1],vnu_msg_in[54][1],vnu_msg_in[53][1],vnu_msg_in[52][1],vnu_msg_in[51][1],vnu_msg_in[50][1],vnu_msg_in[49][1],vnu_msg_in[48][1],vnu_msg_in[47][1],vnu_msg_in[46][1],vnu_msg_in[45][1],vnu_msg_in[44][1],vnu_msg_in[43][1],vnu_msg_in[42][1],vnu_msg_in[41][1],vnu_msg_in[40][1],vnu_msg_in[39][1],vnu_msg_in[38][1],vnu_msg_in[37][1],vnu_msg_in[36][1],vnu_msg_in[35][1],vnu_msg_in[34][1],vnu_msg_in[33][1],vnu_msg_in[32][1],vnu_msg_in[31][1],vnu_msg_in[30][1],vnu_msg_in[29][1],vnu_msg_in[28][1],vnu_msg_in[27][1],vnu_msg_in[26][1],vnu_msg_in[25][1],vnu_msg_in[24][1],vnu_msg_in[23][1],vnu_msg_in[22][1],vnu_msg_in[21][1],vnu_msg_in[20][1],vnu_msg_in[19][1],vnu_msg_in[18][1],vnu_msg_in[17][1],vnu_msg_in[16][1],vnu_msg_in[15][1],vnu_msg_in[14][1],vnu_msg_in[13][1],vnu_msg_in[12][1],vnu_msg_in[11][1],vnu_msg_in[10][1],vnu_msg_in[9][1],vnu_msg_in[8][1],vnu_msg_in[7][1],vnu_msg_in[6][1],vnu_msg_in[5][1],vnu_msg_in[4][1],vnu_msg_in[3][1],vnu_msg_in[2][1],vnu_msg_in[1][1],vnu_msg_in[0][1]}),	
	.sw_out_bit2 ({vnu_msg_in[84][2],vnu_msg_in[83][2],vnu_msg_in[82][2],vnu_msg_in[81][2],vnu_msg_in[80][2],vnu_msg_in[79][2],vnu_msg_in[78][2],vnu_msg_in[77][2],vnu_msg_in[76][2],vnu_msg_in[75][2],vnu_msg_in[74][2],vnu_msg_in[73][2],vnu_msg_in[72][2],vnu_msg_in[71][2],vnu_msg_in[70][2],vnu_msg_in[69][2],vnu_msg_in[68][2],vnu_msg_in[67][2],vnu_msg_in[66][2],vnu_msg_in[65][2],vnu_msg_in[64][2],vnu_msg_in[63][2],vnu_msg_in[62][2],vnu_msg_in[61][2],vnu_msg_in[60][2],vnu_msg_in[59][2],vnu_msg_in[58][2],vnu_msg_in[57][2],vnu_msg_in[56][2],vnu_msg_in[55][2],vnu_msg_in[54][2],vnu_msg_in[53][2],vnu_msg_in[52][2],vnu_msg_in[51][2],vnu_msg_in[50][2],vnu_msg_in[49][2],vnu_msg_in[48][2],vnu_msg_in[47][2],vnu_msg_in[46][2],vnu_msg_in[45][2],vnu_msg_in[44][2],vnu_msg_in[43][2],vnu_msg_in[42][2],vnu_msg_in[41][2],vnu_msg_in[40][2],vnu_msg_in[39][2],vnu_msg_in[38][2],vnu_msg_in[37][2],vnu_msg_in[36][2],vnu_msg_in[35][2],vnu_msg_in[34][2],vnu_msg_in[33][2],vnu_msg_in[32][2],vnu_msg_in[31][2],vnu_msg_in[30][2],vnu_msg_in[29][2],vnu_msg_in[28][2],vnu_msg_in[27][2],vnu_msg_in[26][2],vnu_msg_in[25][2],vnu_msg_in[24][2],vnu_msg_in[23][2],vnu_msg_in[22][2],vnu_msg_in[21][2],vnu_msg_in[20][2],vnu_msg_in[19][2],vnu_msg_in[18][2],vnu_msg_in[17][2],vnu_msg_in[16][2],vnu_msg_in[15][2],vnu_msg_in[14][2],vnu_msg_in[13][2],vnu_msg_in[12][2],vnu_msg_in[11][2],vnu_msg_in[10][2],vnu_msg_in[9][2],vnu_msg_in[8][2],vnu_msg_in[7][2],vnu_msg_in[6][2],vnu_msg_in[5][2],vnu_msg_in[4][2],vnu_msg_in[3][2],vnu_msg_in[2][2],vnu_msg_in[1][2],vnu_msg_in[0][2]}),	
	.sw_out_bit3 ({vnu_msg_in[84][3],vnu_msg_in[83][3],vnu_msg_in[82][3],vnu_msg_in[81][3],vnu_msg_in[80][3],vnu_msg_in[79][3],vnu_msg_in[78][3],vnu_msg_in[77][3],vnu_msg_in[76][3],vnu_msg_in[75][3],vnu_msg_in[74][3],vnu_msg_in[73][3],vnu_msg_in[72][3],vnu_msg_in[71][3],vnu_msg_in[70][3],vnu_msg_in[69][3],vnu_msg_in[68][3],vnu_msg_in[67][3],vnu_msg_in[66][3],vnu_msg_in[65][3],vnu_msg_in[64][3],vnu_msg_in[63][3],vnu_msg_in[62][3],vnu_msg_in[61][3],vnu_msg_in[60][3],vnu_msg_in[59][3],vnu_msg_in[58][3],vnu_msg_in[57][3],vnu_msg_in[56][3],vnu_msg_in[55][3],vnu_msg_in[54][3],vnu_msg_in[53][3],vnu_msg_in[52][3],vnu_msg_in[51][3],vnu_msg_in[50][3],vnu_msg_in[49][3],vnu_msg_in[48][3],vnu_msg_in[47][3],vnu_msg_in[46][3],vnu_msg_in[45][3],vnu_msg_in[44][3],vnu_msg_in[43][3],vnu_msg_in[42][3],vnu_msg_in[41][3],vnu_msg_in[40][3],vnu_msg_in[39][3],vnu_msg_in[38][3],vnu_msg_in[37][3],vnu_msg_in[36][3],vnu_msg_in[35][3],vnu_msg_in[34][3],vnu_msg_in[33][3],vnu_msg_in[32][3],vnu_msg_in[31][3],vnu_msg_in[30][3],vnu_msg_in[29][3],vnu_msg_in[28][3],vnu_msg_in[27][3],vnu_msg_in[26][3],vnu_msg_in[25][3],vnu_msg_in[24][3],vnu_msg_in[23][3],vnu_msg_in[22][3],vnu_msg_in[21][3],vnu_msg_in[20][3],vnu_msg_in[19][3],vnu_msg_in[18][3],vnu_msg_in[17][3],vnu_msg_in[16][3],vnu_msg_in[15][3],vnu_msg_in[14][3],vnu_msg_in[13][3],vnu_msg_in[12][3],vnu_msg_in[11][3],vnu_msg_in[10][3],vnu_msg_in[9][3],vnu_msg_in[8][3],vnu_msg_in[7][3],vnu_msg_in[6][3],vnu_msg_in[5][3],vnu_msg_in[4][3],vnu_msg_in[3][3],vnu_msg_in[2][3],vnu_msg_in[1][3],vnu_msg_in[0][3]}),	
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in0_bit0  (vnu_bs_in_bit[0]),
	.sw_in0_bit1  (vnu_bs_in_bit[1]),
	.sw_in0_bit2  (vnu_bs_in_bit[2]),
	.sw_in0_bit3  (vnu_bs_in_bit[3]),

	.sw_in1_bit0 (ch_bs_in_bit[0]),
	.sw_in1_bit1 (ch_bs_in_bit[1]),
	.sw_in1_bit2 (ch_bs_in_bit[2]),
	.sw_in1_bit3 (ch_bs_in_bit[3]),

	.sw_in2_bit0 (dnu_inRotate_bit),

	.shift_factor (vnu_shift_factorIn), // offset shift factor of submatrix
	.sw_in_bit0_src (vnu_bs_bit0_src),
	.sw_in_src (vnu_bs_src)
);
assign vnu_shift_factorIn = (vnu_bs_bit0_src[0] == 1'b1) ? v2c_shift_factor_cur_0 :
							(vnu_bs_bit0_src[1] == 1'b1) ? ch_ramRD_shift_factor_cur_0 :
							(vnu_bs_bit0_src[2] == 1'b1) ? dnu_inRotate_shift_factor : v2c_shift_factor_cur_0;
/*----------------------------------------------*/	
	reg [ADDR_WIDTH-1:0] c2v_mem_page_addr;
	reg [ADDR_WIDTH-1:0] v2c_mem_page_addr;
	mem_subsystem_top_submatrix_6 #(
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
		) inst_mem_subsystem_top_submatrix_6 (
			.mem_to_vnu_0     (mem_to_vnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_vnu_1     (mem_to_vnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_vnu_2     (mem_to_vnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_vnu_3     (mem_to_vnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_vnu_4     (mem_to_vnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_vnu_5     (mem_to_vnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_vnu_6     (mem_to_vnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_vnu_7     (mem_to_vnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_vnu_8     (mem_to_vnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_vnu_9     (mem_to_vnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_vnu_10    (mem_to_vnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_vnu_11    (mem_to_vnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_vnu_12    (mem_to_vnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_vnu_13    (mem_to_vnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_vnu_14    (mem_to_vnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_vnu_15    (mem_to_vnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_vnu_16    (mem_to_vnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_vnu_17    (mem_to_vnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_vnu_18    (mem_to_vnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_vnu_19    (mem_to_vnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_vnu_20    (mem_to_vnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_vnu_21    (mem_to_vnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_vnu_22    (mem_to_vnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_vnu_23    (mem_to_vnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_vnu_24    (mem_to_vnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_vnu_25    (mem_to_vnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_vnu_26    (mem_to_vnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_vnu_27    (mem_to_vnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_vnu_28    (mem_to_vnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_vnu_29    (mem_to_vnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_vnu_30    (mem_to_vnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_vnu_31    (mem_to_vnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_vnu_32    (mem_to_vnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_vnu_33    (mem_to_vnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_vnu_34    (mem_to_vnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_vnu_35    (mem_to_vnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_vnu_36    (mem_to_vnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_vnu_37    (mem_to_vnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_vnu_38    (mem_to_vnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_vnu_39    (mem_to_vnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_vnu_40    (mem_to_vnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_vnu_41    (mem_to_vnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_vnu_42    (mem_to_vnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_vnu_43    (mem_to_vnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_vnu_44    (mem_to_vnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_vnu_45    (mem_to_vnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_vnu_46    (mem_to_vnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_vnu_47    (mem_to_vnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_vnu_48    (mem_to_vnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_vnu_49    (mem_to_vnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_vnu_50    (mem_to_vnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_vnu_51    (mem_to_vnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_vnu_52    (mem_to_vnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_vnu_53    (mem_to_vnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_vnu_54    (mem_to_vnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_vnu_55    (mem_to_vnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_vnu_56    (mem_to_vnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_vnu_57    (mem_to_vnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_vnu_58    (mem_to_vnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_vnu_59    (mem_to_vnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_vnu_60    (mem_to_vnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_vnu_61    (mem_to_vnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_vnu_62    (mem_to_vnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_vnu_63    (mem_to_vnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_vnu_64    (mem_to_vnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_vnu_65    (mem_to_vnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_vnu_66    (mem_to_vnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_vnu_67    (mem_to_vnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_vnu_68    (mem_to_vnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_vnu_69    (mem_to_vnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_vnu_70    (mem_to_vnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_vnu_71    (mem_to_vnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_vnu_72    (mem_to_vnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_vnu_73    (mem_to_vnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_vnu_74    (mem_to_vnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_vnu_75    (mem_to_vnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_vnu_76    (mem_to_vnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_vnu_77    (mem_to_vnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_vnu_78    (mem_to_vnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_vnu_79    (mem_to_vnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_vnu_80    (mem_to_vnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_vnu_81    (mem_to_vnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_vnu_82    (mem_to_vnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_vnu_83    (mem_to_vnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_vnu_84    (mem_to_vnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),
			.mem_to_cnu_0     (mem_to_cnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_cnu_1     (mem_to_cnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_cnu_2     (mem_to_cnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_cnu_3     (mem_to_cnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_cnu_4     (mem_to_cnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_cnu_5     (mem_to_cnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_cnu_6     (mem_to_cnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_cnu_7     (mem_to_cnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_cnu_8     (mem_to_cnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_cnu_9     (mem_to_cnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_cnu_10    (mem_to_cnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_cnu_11    (mem_to_cnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_cnu_12    (mem_to_cnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_cnu_13    (mem_to_cnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_cnu_14    (mem_to_cnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_cnu_15    (mem_to_cnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_cnu_16    (mem_to_cnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_cnu_17    (mem_to_cnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_cnu_18    (mem_to_cnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_cnu_19    (mem_to_cnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_cnu_20    (mem_to_cnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_cnu_21    (mem_to_cnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_cnu_22    (mem_to_cnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_cnu_23    (mem_to_cnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_cnu_24    (mem_to_cnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_cnu_25    (mem_to_cnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_cnu_26    (mem_to_cnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_cnu_27    (mem_to_cnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_cnu_28    (mem_to_cnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_cnu_29    (mem_to_cnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_cnu_30    (mem_to_cnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_cnu_31    (mem_to_cnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_cnu_32    (mem_to_cnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_cnu_33    (mem_to_cnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_cnu_34    (mem_to_cnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_cnu_35    (mem_to_cnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_cnu_36    (mem_to_cnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_cnu_37    (mem_to_cnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_cnu_38    (mem_to_cnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_cnu_39    (mem_to_cnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_cnu_40    (mem_to_cnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_cnu_41    (mem_to_cnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_cnu_42    (mem_to_cnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_cnu_43    (mem_to_cnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_cnu_44    (mem_to_cnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_cnu_45    (mem_to_cnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_cnu_46    (mem_to_cnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_cnu_47    (mem_to_cnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_cnu_48    (mem_to_cnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_cnu_49    (mem_to_cnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_cnu_50    (mem_to_cnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_cnu_51    (mem_to_cnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_cnu_52    (mem_to_cnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_cnu_53    (mem_to_cnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_cnu_54    (mem_to_cnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_cnu_55    (mem_to_cnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_cnu_56    (mem_to_cnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_cnu_57    (mem_to_cnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_cnu_58    (mem_to_cnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_cnu_59    (mem_to_cnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_cnu_60    (mem_to_cnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_cnu_61    (mem_to_cnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_cnu_62    (mem_to_cnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_cnu_63    (mem_to_cnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_cnu_64    (mem_to_cnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_cnu_65    (mem_to_cnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_cnu_66    (mem_to_cnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_cnu_67    (mem_to_cnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_cnu_68    (mem_to_cnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_cnu_69    (mem_to_cnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_cnu_70    (mem_to_cnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_cnu_71    (mem_to_cnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_cnu_72    (mem_to_cnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_cnu_73    (mem_to_cnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_cnu_74    (mem_to_cnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_cnu_75    (mem_to_cnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_cnu_76    (mem_to_cnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_cnu_77    (mem_to_cnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_cnu_78    (mem_to_cnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_cnu_79    (mem_to_cnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_cnu_80    (mem_to_cnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_cnu_81    (mem_to_cnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_cnu_82    (mem_to_cnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_cnu_83    (mem_to_cnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_cnu_84    (mem_to_cnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),

			.vnu_to_mem_0     (vnu_msg_in[0 ]),
			.vnu_to_mem_1     (vnu_msg_in[1 ]),
			.vnu_to_mem_2     (vnu_msg_in[2 ]),
			.vnu_to_mem_3     (vnu_msg_in[3 ]),
			.vnu_to_mem_4     (vnu_msg_in[4 ]),
			.vnu_to_mem_5     (vnu_msg_in[5 ]),
			.vnu_to_mem_6     (vnu_msg_in[6 ]),
			.vnu_to_mem_7     (vnu_msg_in[7 ]),
			.vnu_to_mem_8     (vnu_msg_in[8 ]),
			.vnu_to_mem_9     (vnu_msg_in[9 ]),
			.vnu_to_mem_10    (vnu_msg_in[10]),
			.vnu_to_mem_11    (vnu_msg_in[11]),
			.vnu_to_mem_12    (vnu_msg_in[12]),
			.vnu_to_mem_13    (vnu_msg_in[13]),
			.vnu_to_mem_14    (vnu_msg_in[14]),
			.vnu_to_mem_15    (vnu_msg_in[15]),
			.vnu_to_mem_16    (vnu_msg_in[16]),
			.vnu_to_mem_17    (vnu_msg_in[17]),
			.vnu_to_mem_18    (vnu_msg_in[18]),
			.vnu_to_mem_19    (vnu_msg_in[19]),
			.vnu_to_mem_20    (vnu_msg_in[20]),
			.vnu_to_mem_21    (vnu_msg_in[21]),
			.vnu_to_mem_22    (vnu_msg_in[22]),
			.vnu_to_mem_23    (vnu_msg_in[23]),
			.vnu_to_mem_24    (vnu_msg_in[24]),
			.vnu_to_mem_25    (vnu_msg_in[25]),
			.vnu_to_mem_26    (vnu_msg_in[26]),
			.vnu_to_mem_27    (vnu_msg_in[27]),
			.vnu_to_mem_28    (vnu_msg_in[28]),
			.vnu_to_mem_29    (vnu_msg_in[29]),
			.vnu_to_mem_30    (vnu_msg_in[30]),
			.vnu_to_mem_31    (vnu_msg_in[31]),
			.vnu_to_mem_32    (vnu_msg_in[32]),
			.vnu_to_mem_33    (vnu_msg_in[33]),
			.vnu_to_mem_34    (vnu_msg_in[34]),
			.vnu_to_mem_35    (vnu_msg_in[35]),
			.vnu_to_mem_36    (vnu_msg_in[36]),
			.vnu_to_mem_37    (vnu_msg_in[37]),
			.vnu_to_mem_38    (vnu_msg_in[38]),
			.vnu_to_mem_39    (vnu_msg_in[39]),
			.vnu_to_mem_40    (vnu_msg_in[40]),
			.vnu_to_mem_41    (vnu_msg_in[41]),
			.vnu_to_mem_42    (vnu_msg_in[42]),
			.vnu_to_mem_43    (vnu_msg_in[43]),
			.vnu_to_mem_44    (vnu_msg_in[44]),
			.vnu_to_mem_45    (vnu_msg_in[45]),
			.vnu_to_mem_46    (vnu_msg_in[46]),
			.vnu_to_mem_47    (vnu_msg_in[47]),
			.vnu_to_mem_48    (vnu_msg_in[48]),
			.vnu_to_mem_49    (vnu_msg_in[49]),
			.vnu_to_mem_50    (vnu_msg_in[50]),
			.vnu_to_mem_51    (vnu_msg_in[51]),
			.vnu_to_mem_52    (vnu_msg_in[52]),
			.vnu_to_mem_53    (vnu_msg_in[53]),
			.vnu_to_mem_54    (vnu_msg_in[54]),
			.vnu_to_mem_55    (vnu_msg_in[55]),
			.vnu_to_mem_56    (vnu_msg_in[56]),
			.vnu_to_mem_57    (vnu_msg_in[57]),
			.vnu_to_mem_58    (vnu_msg_in[58]),
			.vnu_to_mem_59    (vnu_msg_in[59]),
			.vnu_to_mem_60    (vnu_msg_in[60]),
			.vnu_to_mem_61    (vnu_msg_in[61]),
			.vnu_to_mem_62    (vnu_msg_in[62]),
			.vnu_to_mem_63    (vnu_msg_in[63]),
			.vnu_to_mem_64    (vnu_msg_in[64]),
			.vnu_to_mem_65    (vnu_msg_in[65]),
			.vnu_to_mem_66    (vnu_msg_in[66]),
			.vnu_to_mem_67    (vnu_msg_in[67]),
			.vnu_to_mem_68    (vnu_msg_in[68]),
			.vnu_to_mem_69    (vnu_msg_in[69]),
			.vnu_to_mem_70    (vnu_msg_in[70]),
			.vnu_to_mem_71    (vnu_msg_in[71]),
			.vnu_to_mem_72    (vnu_msg_in[72]),
			.vnu_to_mem_73    (vnu_msg_in[73]),
			.vnu_to_mem_74    (vnu_msg_in[74]),
			.vnu_to_mem_75    (vnu_msg_in[75]),
			.vnu_to_mem_76    (vnu_msg_in[76]),
			.vnu_to_mem_77    (vnu_msg_in[77]),
			.vnu_to_mem_78    (vnu_msg_in[78]),
			.vnu_to_mem_79    (vnu_msg_in[79]),
			.vnu_to_mem_80    (vnu_msg_in[80]),
			.vnu_to_mem_81    (vnu_msg_in[81]),
			.vnu_to_mem_82    (vnu_msg_in[82]),
			.vnu_to_mem_83    (vnu_msg_in[83]),
			.vnu_to_mem_84    (vnu_msg_in[84]),
			.cnu_to_mem_0     (cnu_msg_in[0 ]),
			.cnu_to_mem_1     (cnu_msg_in[1 ]),
			.cnu_to_mem_2     (cnu_msg_in[2 ]),
			.cnu_to_mem_3     (cnu_msg_in[3 ]),
			.cnu_to_mem_4     (cnu_msg_in[4 ]),
			.cnu_to_mem_5     (cnu_msg_in[5 ]),
			.cnu_to_mem_6     (cnu_msg_in[6 ]),
			.cnu_to_mem_7     (cnu_msg_in[7 ]),
			.cnu_to_mem_8     (cnu_msg_in[8 ]),
			.cnu_to_mem_9     (cnu_msg_in[9 ]),
			.cnu_to_mem_10    (cnu_msg_in[10]),
			.cnu_to_mem_11    (cnu_msg_in[11]),
			.cnu_to_mem_12    (cnu_msg_in[12]),
			.cnu_to_mem_13    (cnu_msg_in[13]),
			.cnu_to_mem_14    (cnu_msg_in[14]),
			.cnu_to_mem_15    (cnu_msg_in[15]),
			.cnu_to_mem_16    (cnu_msg_in[16]),
			.cnu_to_mem_17    (cnu_msg_in[17]),
			.cnu_to_mem_18    (cnu_msg_in[18]),
			.cnu_to_mem_19    (cnu_msg_in[19]),
			.cnu_to_mem_20    (cnu_msg_in[20]),
			.cnu_to_mem_21    (cnu_msg_in[21]),
			.cnu_to_mem_22    (cnu_msg_in[22]),
			.cnu_to_mem_23    (cnu_msg_in[23]),
			.cnu_to_mem_24    (cnu_msg_in[24]),
			.cnu_to_mem_25    (cnu_msg_in[25]),
			.cnu_to_mem_26    (cnu_msg_in[26]),
			.cnu_to_mem_27    (cnu_msg_in[27]),
			.cnu_to_mem_28    (cnu_msg_in[28]),
			.cnu_to_mem_29    (cnu_msg_in[29]),
			.cnu_to_mem_30    (cnu_msg_in[30]),
			.cnu_to_mem_31    (cnu_msg_in[31]),
			.cnu_to_mem_32    (cnu_msg_in[32]),
			.cnu_to_mem_33    (cnu_msg_in[33]),
			.cnu_to_mem_34    (cnu_msg_in[34]),
			.cnu_to_mem_35    (cnu_msg_in[35]),
			.cnu_to_mem_36    (cnu_msg_in[36]),
			.cnu_to_mem_37    (cnu_msg_in[37]),
			.cnu_to_mem_38    (cnu_msg_in[38]),
			.cnu_to_mem_39    (cnu_msg_in[39]),
			.cnu_to_mem_40    (cnu_msg_in[40]),
			.cnu_to_mem_41    (cnu_msg_in[41]),
			.cnu_to_mem_42    (cnu_msg_in[42]),
			.cnu_to_mem_43    (cnu_msg_in[43]),
			.cnu_to_mem_44    (cnu_msg_in[44]),
			.cnu_to_mem_45    (cnu_msg_in[45]),
			.cnu_to_mem_46    (cnu_msg_in[46]),
			.cnu_to_mem_47    (cnu_msg_in[47]),
			.cnu_to_mem_48    (cnu_msg_in[48]),
			.cnu_to_mem_49    (cnu_msg_in[49]),
			.cnu_to_mem_50    (cnu_msg_in[50]),
			.cnu_to_mem_51    (cnu_msg_in[51]),
			.cnu_to_mem_52    (cnu_msg_in[52]),
			.cnu_to_mem_53    (cnu_msg_in[53]),
			.cnu_to_mem_54    (cnu_msg_in[54]),
			.cnu_to_mem_55    (cnu_msg_in[55]),
			.cnu_to_mem_56    (cnu_msg_in[56]),
			.cnu_to_mem_57    (cnu_msg_in[57]),
			.cnu_to_mem_58    (cnu_msg_in[58]),
			.cnu_to_mem_59    (cnu_msg_in[59]),
			.cnu_to_mem_60    (cnu_msg_in[60]),
			.cnu_to_mem_61    (cnu_msg_in[61]),
			.cnu_to_mem_62    (cnu_msg_in[62]),
			.cnu_to_mem_63    (cnu_msg_in[63]),
			.cnu_to_mem_64    (cnu_msg_in[64]),
			.cnu_to_mem_65    (cnu_msg_in[65]),
			.cnu_to_mem_66    (cnu_msg_in[66]),
			.cnu_to_mem_67    (cnu_msg_in[67]),
			.cnu_to_mem_68    (cnu_msg_in[68]),
			.cnu_to_mem_69    (cnu_msg_in[69]),
			.cnu_to_mem_70    (cnu_msg_in[70]),
			.cnu_to_mem_71    (cnu_msg_in[71]),
			.cnu_to_mem_72    (cnu_msg_in[72]),
			.cnu_to_mem_73    (cnu_msg_in[73]),
			.cnu_to_mem_74    (cnu_msg_in[74]),
			.cnu_to_mem_75    (cnu_msg_in[75]),
			.cnu_to_mem_76    (cnu_msg_in[76]),
			.cnu_to_mem_77    (cnu_msg_in[77]),
			.cnu_to_mem_78    (cnu_msg_in[78]),
			.cnu_to_mem_79    (cnu_msg_in[79]),
			.cnu_to_mem_80    (cnu_msg_in[80]),
			.cnu_to_mem_81    (cnu_msg_in[81]),
			.cnu_to_mem_82    (cnu_msg_in[82]),
			.cnu_to_mem_83    (cnu_msg_in[83]),
			.cnu_to_mem_84    (cnu_msg_in[84]),
			.cnu_sync_addr    (cnu_mem_page_sync_addr),
			.vnu_sync_addr    (vnu_mem_page_sync_addr),
			.cnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.vnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.last_row_chunk   ({c2v_last_row_chunk, v2c_last_row_chunk}),
			.we               ({v2c_mem_we, c2v_mem_we}),
			.sys_clk          (read_clk),
			.rstn             (rstn)
		);
		assign cnu_mem_page_sync_addr = (v2c_mem_fetch == 1'b1) ? v2c_mem_page_rd_addr : 
										(c2v_mem_we == 1'b1) ? c2v_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.

		assign vnu_mem_page_sync_addr = (c2v_mem_fetch == 1'b1) ? c2v_mem_page_rd_addr : 
										(v2c_mem_we == 1'b1) ? v2c_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Check-to-Variable messages RAMs write-page addresses
	always @(posedge read_clk) begin
		if(rstn == 1'b0) 
			c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE;
		else if(c2v_mem_we == 1'b1) begin
			// page increment pattern within layer 0
			if(v2c_layer_cnt[0] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_1+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 1
			if(v2c_layer_cnt[1] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_2+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 2
			if(v2c_layer_cnt[2] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_2-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
		end
	end

	always @(posedge read_clk) begin
		if(rstn == 1'b0) begin
			c2v_shift_factor_cur_2 <= shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
		end
		else if(c2v_bs_en == 1'b1) begin
			c2v_shift_factor_cur_2 <= 0;
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
/*--------------------------------------------------------------------------*/
// Channel Buffers
reg [CH_DATA_WIDTH-1:0] ch_msg_genIn;
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_0 [0:CHECK_PARALLELISM-1]; // [0:84]
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_1 [0:CHECK_PARALLELISM-1]; // [0:84]
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_rd_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chInit_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chLayer_wr_addr;
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

			.din        (ch_msg_genIn[CH_DATA_WIDTH-1:0]),

			.read_addr  (submatrix_ch_ram_rd_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.write_addr (submatrix_ch_ram_wr_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.we         (ch_ram_we),
			.read_clk   (ch_ram_rd_clk),
			.write_clk  (ch_ram_wr_clk),
			.rstn       (rstn)
		);
		// Updating the Channel RAMs by either initally channel messages (from AWGNs) or circularly shifted channel messages
		assign submatrix_ch_ram_wr_addr = (ch_ram_init_we == 1'b1) ? submatrix_chInit_wr_addr :
														(ch_ram_wb == 1'b1     ) ? submatrix_chLayer_wr_addr : 
																				   CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.


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
	// Channel messages RAMs write-page addresses
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
endmodule

module msg_pass_submatrix_7_unit #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,
	parameter VN_DEGREE = 3,   // degree of one variable node
/*-------------------------------------------------------------------------------------*/
	// Parameters related to BS, PA and MEM
	parameter RAM_DEPTH = 1024,
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH),
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1),
	parameter shift_factor_0 = CHECK_PARALLELISM-20,
	parameter shift_factor_1 = CHECK_PARALLELISM-25,
	parameter shift_factor_2 = CHECK_PARALLELISM-45,

`ifdef SCHED_4_6
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,
	parameter C2V_MEM_ADDR_BASE = 0,
	parameter V2C_MEM_ADDR_BASE = ROW_CHUNK_NUM,
	parameter V2C_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter C2V_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH),
`endif
	parameter START_PAGE_1_0 = 2, // starting page address of layer 0 of submatrix_1
	parameter START_PAGE_1_1 = 8, // starting page address of layer 1 of submatrix_1
	parameter START_PAGE_1_2 = 1  // starting page address of layer 2 of submatrix_1
) (
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu,

	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit,

	// control signals
	input wire c2v_bs_en,
	input wire v2c_bs_en,
	input wire ch_bs_en,
	/*------------------------------*/
	// Control signals associative with message passing of channel buffer and DNU.SignExtension
	input wire ch_ram_init_we,
	input wire ch_ram_fetch,
	input wire v2c_outRotate_reg_we,
	input wire dnu_inRotate_bs_en,
	input wire dnu_inRotate_pa_en,
	input wire dnu_inRotate_wb,
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
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,

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
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_2;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_2;
wire [6:0]  cnu_left_sel;
wire [6:0]  cnu_right_sel;
wire [83:0] cnu_merge_sel;
wire [6:0]  vnu_left_sel;
wire [6:0]  vnu_right_sel;
wire [83:0] vnu_merge_sel;
wire [CHECK_PARALLELISM-1:0] cnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] vnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] ch_bs_in_bit [0:QUAN_SIZE-1];
genvar bit_index;
generate
	for(bit_index=0;bit_index<QUAN_SIZE;bit_index=bit_index+1) begin : extrinsic_msg_bs_in_inst
		assign cnu_bs_in_bit[bit_index] = {c2v_bs_in[QUAN_SIZE*84+bit_index],c2v_bs_in[QUAN_SIZE*83+bit_index],c2v_bs_in[QUAN_SIZE*82+bit_index],c2v_bs_in[QUAN_SIZE*81+bit_index],c2v_bs_in[QUAN_SIZE*80+bit_index],c2v_bs_in[QUAN_SIZE*79+bit_index],c2v_bs_in[QUAN_SIZE*78+bit_index],c2v_bs_in[QUAN_SIZE*77+bit_index],c2v_bs_in[QUAN_SIZE*76+bit_index],c2v_bs_in[QUAN_SIZE*75+bit_index],c2v_bs_in[QUAN_SIZE*74+bit_index],c2v_bs_in[QUAN_SIZE*73+bit_index],c2v_bs_in[QUAN_SIZE*72+bit_index],c2v_bs_in[QUAN_SIZE*71+bit_index],c2v_bs_in[QUAN_SIZE*70+bit_index],c2v_bs_in[QUAN_SIZE*69+bit_index],c2v_bs_in[QUAN_SIZE*68+bit_index],c2v_bs_in[QUAN_SIZE*67+bit_index],c2v_bs_in[QUAN_SIZE*66+bit_index],c2v_bs_in[QUAN_SIZE*65+bit_index],c2v_bs_in[QUAN_SIZE*64+bit_index],c2v_bs_in[QUAN_SIZE*63+bit_index],c2v_bs_in[QUAN_SIZE*62+bit_index],c2v_bs_in[QUAN_SIZE*61+bit_index],c2v_bs_in[QUAN_SIZE*60+bit_index],c2v_bs_in[QUAN_SIZE*59+bit_index],c2v_bs_in[QUAN_SIZE*58+bit_index],c2v_bs_in[QUAN_SIZE*57+bit_index],c2v_bs_in[QUAN_SIZE*56+bit_index],c2v_bs_in[QUAN_SIZE*55+bit_index],c2v_bs_in[QUAN_SIZE*54+bit_index],c2v_bs_in[QUAN_SIZE*53+bit_index],c2v_bs_in[QUAN_SIZE*52+bit_index],c2v_bs_in[QUAN_SIZE*51+bit_index],c2v_bs_in[QUAN_SIZE*50+bit_index],c2v_bs_in[QUAN_SIZE*49+bit_index],c2v_bs_in[QUAN_SIZE*48+bit_index],c2v_bs_in[QUAN_SIZE*47+bit_index],c2v_bs_in[QUAN_SIZE*46+bit_index],c2v_bs_in[QUAN_SIZE*45+bit_index],c2v_bs_in[QUAN_SIZE*44+bit_index],c2v_bs_in[QUAN_SIZE*43+bit_index],c2v_bs_in[QUAN_SIZE*42+bit_index],c2v_bs_in[QUAN_SIZE*41+bit_index],c2v_bs_in[QUAN_SIZE*40+bit_index],c2v_bs_in[QUAN_SIZE*39+bit_index],c2v_bs_in[QUAN_SIZE*38+bit_index],c2v_bs_in[QUAN_SIZE*37+bit_index],c2v_bs_in[QUAN_SIZE*36+bit_index],c2v_bs_in[QUAN_SIZE*35+bit_index],c2v_bs_in[QUAN_SIZE*34+bit_index],c2v_bs_in[QUAN_SIZE*33+bit_index],c2v_bs_in[QUAN_SIZE*32+bit_index],c2v_bs_in[QUAN_SIZE*31+bit_index],c2v_bs_in[QUAN_SIZE*30+bit_index],c2v_bs_in[QUAN_SIZE*29+bit_index],c2v_bs_in[QUAN_SIZE*28+bit_index],c2v_bs_in[QUAN_SIZE*27+bit_index],c2v_bs_in[QUAN_SIZE*26+bit_index],c2v_bs_in[QUAN_SIZE*25+bit_index],c2v_bs_in[QUAN_SIZE*24+bit_index],c2v_bs_in[QUAN_SIZE*23+bit_index],c2v_bs_in[QUAN_SIZE*22+bit_index],c2v_bs_in[QUAN_SIZE*21+bit_index],c2v_bs_in[QUAN_SIZE*20+bit_index],c2v_bs_in[QUAN_SIZE*19+bit_index],c2v_bs_in[QUAN_SIZE*18+bit_index],c2v_bs_in[QUAN_SIZE*17+bit_index],c2v_bs_in[QUAN_SIZE*16+bit_index],c2v_bs_in[QUAN_SIZE*15+bit_index],c2v_bs_in[QUAN_SIZE*14+bit_index],c2v_bs_in[QUAN_SIZE*13+bit_index],c2v_bs_in[QUAN_SIZE*12+bit_index],c2v_bs_in[QUAN_SIZE*11+bit_index],c2v_bs_in[QUAN_SIZE*10+bit_index],c2v_bs_in[QUAN_SIZE*9+bit_index],c2v_bs_in[QUAN_SIZE*8+bit_index],c2v_bs_in[QUAN_SIZE*7+bit_index],c2v_bs_in[QUAN_SIZE*6+bit_index],c2v_bs_in[QUAN_SIZE*5+bit_index],c2v_bs_in[QUAN_SIZE*4+bit_index],c2v_bs_in[QUAN_SIZE*3+bit_index],c2v_bs_in[QUAN_SIZE*2+bit_index],c2v_bs_in[QUAN_SIZE*1+bit_index],c2v_bs_in[QUAN_SIZE*0+bit_index]};
		assign vnu_bs_in_bit[bit_index] = {v2c_bs_in[QUAN_SIZE*84+bit_index],v2c_bs_in[QUAN_SIZE*83+bit_index],v2c_bs_in[QUAN_SIZE*82+bit_index],v2c_bs_in[QUAN_SIZE*81+bit_index],v2c_bs_in[QUAN_SIZE*80+bit_index],v2c_bs_in[QUAN_SIZE*79+bit_index],v2c_bs_in[QUAN_SIZE*78+bit_index],v2c_bs_in[QUAN_SIZE*77+bit_index],v2c_bs_in[QUAN_SIZE*76+bit_index],v2c_bs_in[QUAN_SIZE*75+bit_index],v2c_bs_in[QUAN_SIZE*74+bit_index],v2c_bs_in[QUAN_SIZE*73+bit_index],v2c_bs_in[QUAN_SIZE*72+bit_index],v2c_bs_in[QUAN_SIZE*71+bit_index],v2c_bs_in[QUAN_SIZE*70+bit_index],v2c_bs_in[QUAN_SIZE*69+bit_index],v2c_bs_in[QUAN_SIZE*68+bit_index],v2c_bs_in[QUAN_SIZE*67+bit_index],v2c_bs_in[QUAN_SIZE*66+bit_index],v2c_bs_in[QUAN_SIZE*65+bit_index],v2c_bs_in[QUAN_SIZE*64+bit_index],v2c_bs_in[QUAN_SIZE*63+bit_index],v2c_bs_in[QUAN_SIZE*62+bit_index],v2c_bs_in[QUAN_SIZE*61+bit_index],v2c_bs_in[QUAN_SIZE*60+bit_index],v2c_bs_in[QUAN_SIZE*59+bit_index],v2c_bs_in[QUAN_SIZE*58+bit_index],v2c_bs_in[QUAN_SIZE*57+bit_index],v2c_bs_in[QUAN_SIZE*56+bit_index],v2c_bs_in[QUAN_SIZE*55+bit_index],v2c_bs_in[QUAN_SIZE*54+bit_index],v2c_bs_in[QUAN_SIZE*53+bit_index],v2c_bs_in[QUAN_SIZE*52+bit_index],v2c_bs_in[QUAN_SIZE*51+bit_index],v2c_bs_in[QUAN_SIZE*50+bit_index],v2c_bs_in[QUAN_SIZE*49+bit_index],v2c_bs_in[QUAN_SIZE*48+bit_index],v2c_bs_in[QUAN_SIZE*47+bit_index],v2c_bs_in[QUAN_SIZE*46+bit_index],v2c_bs_in[QUAN_SIZE*45+bit_index],v2c_bs_in[QUAN_SIZE*44+bit_index],v2c_bs_in[QUAN_SIZE*43+bit_index],v2c_bs_in[QUAN_SIZE*42+bit_index],v2c_bs_in[QUAN_SIZE*41+bit_index],v2c_bs_in[QUAN_SIZE*40+bit_index],v2c_bs_in[QUAN_SIZE*39+bit_index],v2c_bs_in[QUAN_SIZE*38+bit_index],v2c_bs_in[QUAN_SIZE*37+bit_index],v2c_bs_in[QUAN_SIZE*36+bit_index],v2c_bs_in[QUAN_SIZE*35+bit_index],v2c_bs_in[QUAN_SIZE*34+bit_index],v2c_bs_in[QUAN_SIZE*33+bit_index],v2c_bs_in[QUAN_SIZE*32+bit_index],v2c_bs_in[QUAN_SIZE*31+bit_index],v2c_bs_in[QUAN_SIZE*30+bit_index],v2c_bs_in[QUAN_SIZE*29+bit_index],v2c_bs_in[QUAN_SIZE*28+bit_index],v2c_bs_in[QUAN_SIZE*27+bit_index],v2c_bs_in[QUAN_SIZE*26+bit_index],v2c_bs_in[QUAN_SIZE*25+bit_index],v2c_bs_in[QUAN_SIZE*24+bit_index],v2c_bs_in[QUAN_SIZE*23+bit_index],v2c_bs_in[QUAN_SIZE*22+bit_index],v2c_bs_in[QUAN_SIZE*21+bit_index],v2c_bs_in[QUAN_SIZE*20+bit_index],v2c_bs_in[QUAN_SIZE*19+bit_index],v2c_bs_in[QUAN_SIZE*18+bit_index],v2c_bs_in[QUAN_SIZE*17+bit_index],v2c_bs_in[QUAN_SIZE*16+bit_index],v2c_bs_in[QUAN_SIZE*15+bit_index],v2c_bs_in[QUAN_SIZE*14+bit_index],v2c_bs_in[QUAN_SIZE*13+bit_index],v2c_bs_in[QUAN_SIZE*12+bit_index],v2c_bs_in[QUAN_SIZE*11+bit_index],v2c_bs_in[QUAN_SIZE*10+bit_index],v2c_bs_in[QUAN_SIZE*9+bit_index],v2c_bs_in[QUAN_SIZE*8+bit_index],v2c_bs_in[QUAN_SIZE*7+bit_index],v2c_bs_in[QUAN_SIZE*6+bit_index],v2c_bs_in[QUAN_SIZE*5+bit_index],v2c_bs_in[QUAN_SIZE*4+bit_index],v2c_bs_in[QUAN_SIZE*3+bit_index],v2c_bs_in[QUAN_SIZE*2+bit_index],v2c_bs_in[QUAN_SIZE*1+bit_index],v2c_bs_in[QUAN_SIZE*0+bit_index]};
		assign ch_bs_in_bit[bit_index]  = { ch_bs_in[QUAN_SIZE*84+bit_index], ch_bs_in[QUAN_SIZE*83+bit_index], ch_bs_in[QUAN_SIZE*82+bit_index], ch_bs_in[QUAN_SIZE*81+bit_index], ch_bs_in[QUAN_SIZE*80+bit_index], ch_bs_in[QUAN_SIZE*79+bit_index], ch_bs_in[QUAN_SIZE*78+bit_index], ch_bs_in[QUAN_SIZE*77+bit_index], ch_bs_in[QUAN_SIZE*76+bit_index], ch_bs_in[QUAN_SIZE*75+bit_index], ch_bs_in[QUAN_SIZE*74+bit_index], ch_bs_in[QUAN_SIZE*73+bit_index], ch_bs_in[QUAN_SIZE*72+bit_index], ch_bs_in[QUAN_SIZE*71+bit_index], ch_bs_in[QUAN_SIZE*70+bit_index], ch_bs_in[QUAN_SIZE*69+bit_index], ch_bs_in[QUAN_SIZE*68+bit_index], ch_bs_in[QUAN_SIZE*67+bit_index], ch_bs_in[QUAN_SIZE*66+bit_index], ch_bs_in[QUAN_SIZE*65+bit_index], ch_bs_in[QUAN_SIZE*64+bit_index], ch_bs_in[QUAN_SIZE*63+bit_index], ch_bs_in[QUAN_SIZE*62+bit_index], ch_bs_in[QUAN_SIZE*61+bit_index], ch_bs_in[QUAN_SIZE*60+bit_index], ch_bs_in[QUAN_SIZE*59+bit_index], ch_bs_in[QUAN_SIZE*58+bit_index], ch_bs_in[QUAN_SIZE*57+bit_index], ch_bs_in[QUAN_SIZE*56+bit_index], ch_bs_in[QUAN_SIZE*55+bit_index], ch_bs_in[QUAN_SIZE*54+bit_index], ch_bs_in[QUAN_SIZE*53+bit_index], ch_bs_in[QUAN_SIZE*52+bit_index], ch_bs_in[QUAN_SIZE*51+bit_index], ch_bs_in[QUAN_SIZE*50+bit_index], ch_bs_in[QUAN_SIZE*49+bit_index], ch_bs_in[QUAN_SIZE*48+bit_index], ch_bs_in[QUAN_SIZE*47+bit_index], ch_bs_in[QUAN_SIZE*46+bit_index], ch_bs_in[QUAN_SIZE*45+bit_index], ch_bs_in[QUAN_SIZE*44+bit_index], ch_bs_in[QUAN_SIZE*43+bit_index], ch_bs_in[QUAN_SIZE*42+bit_index], ch_bs_in[QUAN_SIZE*41+bit_index], ch_bs_in[QUAN_SIZE*40+bit_index], ch_bs_in[QUAN_SIZE*39+bit_index], ch_bs_in[QUAN_SIZE*38+bit_index], ch_bs_in[QUAN_SIZE*37+bit_index], ch_bs_in[QUAN_SIZE*36+bit_index], ch_bs_in[QUAN_SIZE*35+bit_index], ch_bs_in[QUAN_SIZE*34+bit_index], ch_bs_in[QUAN_SIZE*33+bit_index], ch_bs_in[QUAN_SIZE*32+bit_index], ch_bs_in[QUAN_SIZE*31+bit_index], ch_bs_in[QUAN_SIZE*30+bit_index], ch_bs_in[QUAN_SIZE*29+bit_index], ch_bs_in[QUAN_SIZE*28+bit_index], ch_bs_in[QUAN_SIZE*27+bit_index], ch_bs_in[QUAN_SIZE*26+bit_index], ch_bs_in[QUAN_SIZE*25+bit_index], ch_bs_in[QUAN_SIZE*24+bit_index], ch_bs_in[QUAN_SIZE*23+bit_index], ch_bs_in[QUAN_SIZE*22+bit_index], ch_bs_in[QUAN_SIZE*21+bit_index], ch_bs_in[QUAN_SIZE*20+bit_index], ch_bs_in[QUAN_SIZE*19+bit_index], ch_bs_in[QUAN_SIZE*18+bit_index], ch_bs_in[QUAN_SIZE*17+bit_index], ch_bs_in[QUAN_SIZE*16+bit_index], ch_bs_in[QUAN_SIZE*15+bit_index], ch_bs_in[QUAN_SIZE*14+bit_index], ch_bs_in[QUAN_SIZE*13+bit_index], ch_bs_in[QUAN_SIZE*12+bit_index], ch_bs_in[QUAN_SIZE*11+bit_index], ch_bs_in[QUAN_SIZE*10+bit_index], ch_bs_in[QUAN_SIZE*9+bit_index], ch_bs_in[QUAN_SIZE*8+bit_index], ch_bs_in[QUAN_SIZE*7+bit_index], ch_bs_in[QUAN_SIZE*6+bit_index], ch_bs_in[QUAN_SIZE*5+bit_index], ch_bs_in[QUAN_SIZE*4+bit_index], ch_bs_in[QUAN_SIZE*3+bit_index], ch_bs_in[QUAN_SIZE*2+bit_index],ch_bs_in[QUAN_SIZE*1+bit_index], ch_bs_in[QUAN_SIZE*0+bit_index]};
	end
endgenerate
/*----------------------------------------------*/	
// Circular shifter of check nodes 
qsn_top_85b cnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({cnu_msg_in[84][0],cnu_msg_in[83][0],cnu_msg_in[82][0],cnu_msg_in[81][0],cnu_msg_in[80][0],cnu_msg_in[79][0],cnu_msg_in[78][0],cnu_msg_in[77][0],cnu_msg_in[76][0],cnu_msg_in[75][0],cnu_msg_in[74][0],cnu_msg_in[73][0],cnu_msg_in[72][0],cnu_msg_in[71][0],cnu_msg_in[70][0],cnu_msg_in[69][0],cnu_msg_in[68][0],cnu_msg_in[67][0],cnu_msg_in[66][0],cnu_msg_in[65][0],cnu_msg_in[64][0],cnu_msg_in[63][0],cnu_msg_in[62][0],cnu_msg_in[61][0],cnu_msg_in[60][0],cnu_msg_in[59][0],cnu_msg_in[58][0],cnu_msg_in[57][0],cnu_msg_in[56][0],cnu_msg_in[55][0],cnu_msg_in[54][0],cnu_msg_in[53][0],cnu_msg_in[52][0],cnu_msg_in[51][0],cnu_msg_in[50][0],cnu_msg_in[49][0],cnu_msg_in[48][0],cnu_msg_in[47][0],cnu_msg_in[46][0],cnu_msg_in[45][0],cnu_msg_in[44][0],cnu_msg_in[43][0],cnu_msg_in[42][0],cnu_msg_in[41][0],cnu_msg_in[40][0],cnu_msg_in[39][0],cnu_msg_in[38][0],cnu_msg_in[37][0],cnu_msg_in[36][0],cnu_msg_in[35][0],cnu_msg_in[34][0],cnu_msg_in[33][0],cnu_msg_in[32][0],cnu_msg_in[31][0],cnu_msg_in[30][0],cnu_msg_in[29][0],cnu_msg_in[28][0],cnu_msg_in[27][0],cnu_msg_in[26][0],cnu_msg_in[25][0],cnu_msg_in[24][0],cnu_msg_in[23][0],cnu_msg_in[22][0],cnu_msg_in[21][0],cnu_msg_in[20][0],cnu_msg_in[19][0],cnu_msg_in[18][0],cnu_msg_in[17][0],cnu_msg_in[16][0],cnu_msg_in[15][0],cnu_msg_in[14][0],cnu_msg_in[13][0],cnu_msg_in[12][0],cnu_msg_in[11][0],cnu_msg_in[10][0],cnu_msg_in[9][0],cnu_msg_in[8][0],cnu_msg_in[7][0],cnu_msg_in[6][0],cnu_msg_in[5][0],cnu_msg_in[4][0],cnu_msg_in[3][0],cnu_msg_in[2][0],cnu_msg_in[1][0],cnu_msg_in[0][0]}),
	.sw_out_bit1 ({cnu_msg_in[84][1],cnu_msg_in[83][1],cnu_msg_in[82][1],cnu_msg_in[81][1],cnu_msg_in[80][1],cnu_msg_in[79][1],cnu_msg_in[78][1],cnu_msg_in[77][1],cnu_msg_in[76][1],cnu_msg_in[75][1],cnu_msg_in[74][1],cnu_msg_in[73][1],cnu_msg_in[72][1],cnu_msg_in[71][1],cnu_msg_in[70][1],cnu_msg_in[69][1],cnu_msg_in[68][1],cnu_msg_in[67][1],cnu_msg_in[66][1],cnu_msg_in[65][1],cnu_msg_in[64][1],cnu_msg_in[63][1],cnu_msg_in[62][1],cnu_msg_in[61][1],cnu_msg_in[60][1],cnu_msg_in[59][1],cnu_msg_in[58][1],cnu_msg_in[57][1],cnu_msg_in[56][1],cnu_msg_in[55][1],cnu_msg_in[54][1],cnu_msg_in[53][1],cnu_msg_in[52][1],cnu_msg_in[51][1],cnu_msg_in[50][1],cnu_msg_in[49][1],cnu_msg_in[48][1],cnu_msg_in[47][1],cnu_msg_in[46][1],cnu_msg_in[45][1],cnu_msg_in[44][1],cnu_msg_in[43][1],cnu_msg_in[42][1],cnu_msg_in[41][1],cnu_msg_in[40][1],cnu_msg_in[39][1],cnu_msg_in[38][1],cnu_msg_in[37][1],cnu_msg_in[36][1],cnu_msg_in[35][1],cnu_msg_in[34][1],cnu_msg_in[33][1],cnu_msg_in[32][1],cnu_msg_in[31][1],cnu_msg_in[30][1],cnu_msg_in[29][1],cnu_msg_in[28][1],cnu_msg_in[27][1],cnu_msg_in[26][1],cnu_msg_in[25][1],cnu_msg_in[24][1],cnu_msg_in[23][1],cnu_msg_in[22][1],cnu_msg_in[21][1],cnu_msg_in[20][1],cnu_msg_in[19][1],cnu_msg_in[18][1],cnu_msg_in[17][1],cnu_msg_in[16][1],cnu_msg_in[15][1],cnu_msg_in[14][1],cnu_msg_in[13][1],cnu_msg_in[12][1],cnu_msg_in[11][1],cnu_msg_in[10][1],cnu_msg_in[9][1],cnu_msg_in[8][1],cnu_msg_in[7][1],cnu_msg_in[6][1],cnu_msg_in[5][1],cnu_msg_in[4][1],cnu_msg_in[3][1],cnu_msg_in[2][1],cnu_msg_in[1][1],cnu_msg_in[0][1]}),
	.sw_out_bit2 ({cnu_msg_in[84][2],cnu_msg_in[83][2],cnu_msg_in[82][2],cnu_msg_in[81][2],cnu_msg_in[80][2],cnu_msg_in[79][2],cnu_msg_in[78][2],cnu_msg_in[77][2],cnu_msg_in[76][2],cnu_msg_in[75][2],cnu_msg_in[74][2],cnu_msg_in[73][2],cnu_msg_in[72][2],cnu_msg_in[71][2],cnu_msg_in[70][2],cnu_msg_in[69][2],cnu_msg_in[68][2],cnu_msg_in[67][2],cnu_msg_in[66][2],cnu_msg_in[65][2],cnu_msg_in[64][2],cnu_msg_in[63][2],cnu_msg_in[62][2],cnu_msg_in[61][2],cnu_msg_in[60][2],cnu_msg_in[59][2],cnu_msg_in[58][2],cnu_msg_in[57][2],cnu_msg_in[56][2],cnu_msg_in[55][2],cnu_msg_in[54][2],cnu_msg_in[53][2],cnu_msg_in[52][2],cnu_msg_in[51][2],cnu_msg_in[50][2],cnu_msg_in[49][2],cnu_msg_in[48][2],cnu_msg_in[47][2],cnu_msg_in[46][2],cnu_msg_in[45][2],cnu_msg_in[44][2],cnu_msg_in[43][2],cnu_msg_in[42][2],cnu_msg_in[41][2],cnu_msg_in[40][2],cnu_msg_in[39][2],cnu_msg_in[38][2],cnu_msg_in[37][2],cnu_msg_in[36][2],cnu_msg_in[35][2],cnu_msg_in[34][2],cnu_msg_in[33][2],cnu_msg_in[32][2],cnu_msg_in[31][2],cnu_msg_in[30][2],cnu_msg_in[29][2],cnu_msg_in[28][2],cnu_msg_in[27][2],cnu_msg_in[26][2],cnu_msg_in[25][2],cnu_msg_in[24][2],cnu_msg_in[23][2],cnu_msg_in[22][2],cnu_msg_in[21][2],cnu_msg_in[20][2],cnu_msg_in[19][2],cnu_msg_in[18][2],cnu_msg_in[17][2],cnu_msg_in[16][2],cnu_msg_in[15][2],cnu_msg_in[14][2],cnu_msg_in[13][2],cnu_msg_in[12][2],cnu_msg_in[11][2],cnu_msg_in[10][2],cnu_msg_in[9][2],cnu_msg_in[8][2],cnu_msg_in[7][2],cnu_msg_in[6][2],cnu_msg_in[5][2],cnu_msg_in[4][2],cnu_msg_in[3][2],cnu_msg_in[2][2],cnu_msg_in[1][2],cnu_msg_in[0][2]}),	
	.sw_out_bit3 ({cnu_msg_in[84][3],cnu_msg_in[83][3],cnu_msg_in[82][3],cnu_msg_in[81][3],cnu_msg_in[80][3],cnu_msg_in[79][3],cnu_msg_in[78][3],cnu_msg_in[77][3],cnu_msg_in[76][3],cnu_msg_in[75][3],cnu_msg_in[74][3],cnu_msg_in[73][3],cnu_msg_in[72][3],cnu_msg_in[71][3],cnu_msg_in[70][3],cnu_msg_in[69][3],cnu_msg_in[68][3],cnu_msg_in[67][3],cnu_msg_in[66][3],cnu_msg_in[65][3],cnu_msg_in[64][3],cnu_msg_in[63][3],cnu_msg_in[62][3],cnu_msg_in[61][3],cnu_msg_in[60][3],cnu_msg_in[59][3],cnu_msg_in[58][3],cnu_msg_in[57][3],cnu_msg_in[56][3],cnu_msg_in[55][3],cnu_msg_in[54][3],cnu_msg_in[53][3],cnu_msg_in[52][3],cnu_msg_in[51][3],cnu_msg_in[50][3],cnu_msg_in[49][3],cnu_msg_in[48][3],cnu_msg_in[47][3],cnu_msg_in[46][3],cnu_msg_in[45][3],cnu_msg_in[44][3],cnu_msg_in[43][3],cnu_msg_in[42][3],cnu_msg_in[41][3],cnu_msg_in[40][3],cnu_msg_in[39][3],cnu_msg_in[38][3],cnu_msg_in[37][3],cnu_msg_in[36][3],cnu_msg_in[35][3],cnu_msg_in[34][3],cnu_msg_in[33][3],cnu_msg_in[32][3],cnu_msg_in[31][3],cnu_msg_in[30][3],cnu_msg_in[29][3],cnu_msg_in[28][3],cnu_msg_in[27][3],cnu_msg_in[26][3],cnu_msg_in[25][3],cnu_msg_in[24][3],cnu_msg_in[23][3],cnu_msg_in[22][3],cnu_msg_in[21][3],cnu_msg_in[20][3],cnu_msg_in[19][3],cnu_msg_in[18][3],cnu_msg_in[17][3],cnu_msg_in[16][3],cnu_msg_in[15][3],cnu_msg_in[14][3],cnu_msg_in[13][3],cnu_msg_in[12][3],cnu_msg_in[11][3],cnu_msg_in[10][3],cnu_msg_in[9][3],cnu_msg_in[8][3],cnu_msg_in[7][3],cnu_msg_in[6][3],cnu_msg_in[5][3],cnu_msg_in[4][3],cnu_msg_in[3][3],cnu_msg_in[2][3],cnu_msg_in[1][3],cnu_msg_in[0][3]}),
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in_bit0  (cnu_bs_in_bit[0]),
	.sw_in_bit1  (cnu_bs_in_bit[1]),
	.sw_in_bit2  (cnu_bs_in_bit[2]),
	.sw_in_bit3  (cnu_bs_in_bit[3]),
	.left_sel    (cnu_left_sel),
	.right_sel   (cnu_right_sel),
	.merge_sel   (cnu_merge_sel)
);
qsn_controller_85b #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) cnu_qsn_controller_85b (
	.left_sel     (cnu_left_sel ),
	.right_sel    (cnu_right_sel),
	.merge_sel    (cnu_merge_sel),
	.shift_factor (c2v_shift_factor_cur_0), // offset shift factor of submatrix_1
	.rstn         (rstn),
	.sys_clk      (read_clk)
);
/*----------------------------------------------*/
// Circular shifter of variable nodes 
wire [BITWIDTH_SHIFT_FACTOR-1:0] vnu_shift_factorIn;
wire [BITWIDTH_SHIFT_FACTOR-1:0] dnu_inRotate_shift_factor; // a constant, because only needed at last layer
shared_qsn_top_85b #(
		.QUAN_SIZE(QUAN_SIZE),
		.CHECK_PARALLELISM(CHECK_PARALLELISM),
		.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR)
) inst_shared_qsn_top_85b (
	.sw_out_bit0 ({vnu_msg_in[84][0],vnu_msg_in[83][0],vnu_msg_in[82][0],vnu_msg_in[81][0],vnu_msg_in[80][0],vnu_msg_in[79][0],vnu_msg_in[78][0],vnu_msg_in[77][0],vnu_msg_in[76][0],vnu_msg_in[75][0],vnu_msg_in[74][0],vnu_msg_in[73][0],vnu_msg_in[72][0],vnu_msg_in[71][0],vnu_msg_in[70][0],vnu_msg_in[69][0],vnu_msg_in[68][0],vnu_msg_in[67][0],vnu_msg_in[66][0],vnu_msg_in[65][0],vnu_msg_in[64][0],vnu_msg_in[63][0],vnu_msg_in[62][0],vnu_msg_in[61][0],vnu_msg_in[60][0],vnu_msg_in[59][0],vnu_msg_in[58][0],vnu_msg_in[57][0],vnu_msg_in[56][0],vnu_msg_in[55][0],vnu_msg_in[54][0],vnu_msg_in[53][0],vnu_msg_in[52][0],vnu_msg_in[51][0],vnu_msg_in[50][0],vnu_msg_in[49][0],vnu_msg_in[48][0],vnu_msg_in[47][0],vnu_msg_in[46][0],vnu_msg_in[45][0],vnu_msg_in[44][0],vnu_msg_in[43][0],vnu_msg_in[42][0],vnu_msg_in[41][0],vnu_msg_in[40][0],vnu_msg_in[39][0],vnu_msg_in[38][0],vnu_msg_in[37][0],vnu_msg_in[36][0],vnu_msg_in[35][0],vnu_msg_in[34][0],vnu_msg_in[33][0],vnu_msg_in[32][0],vnu_msg_in[31][0],vnu_msg_in[30][0],vnu_msg_in[29][0],vnu_msg_in[28][0],vnu_msg_in[27][0],vnu_msg_in[26][0],vnu_msg_in[25][0],vnu_msg_in[24][0],vnu_msg_in[23][0],vnu_msg_in[22][0],vnu_msg_in[21][0],vnu_msg_in[20][0],vnu_msg_in[19][0],vnu_msg_in[18][0],vnu_msg_in[17][0],vnu_msg_in[16][0],vnu_msg_in[15][0],vnu_msg_in[14][0],vnu_msg_in[13][0],vnu_msg_in[12][0],vnu_msg_in[11][0],vnu_msg_in[10][0],vnu_msg_in[9][0],vnu_msg_in[8][0],vnu_msg_in[7][0],vnu_msg_in[6][0],vnu_msg_in[5][0],vnu_msg_in[4][0],vnu_msg_in[3][0],vnu_msg_in[2][0],vnu_msg_in[1][0],vnu_msg_in[0][0]}),	
	.sw_out_bit1 ({vnu_msg_in[84][1],vnu_msg_in[83][1],vnu_msg_in[82][1],vnu_msg_in[81][1],vnu_msg_in[80][1],vnu_msg_in[79][1],vnu_msg_in[78][1],vnu_msg_in[77][1],vnu_msg_in[76][1],vnu_msg_in[75][1],vnu_msg_in[74][1],vnu_msg_in[73][1],vnu_msg_in[72][1],vnu_msg_in[71][1],vnu_msg_in[70][1],vnu_msg_in[69][1],vnu_msg_in[68][1],vnu_msg_in[67][1],vnu_msg_in[66][1],vnu_msg_in[65][1],vnu_msg_in[64][1],vnu_msg_in[63][1],vnu_msg_in[62][1],vnu_msg_in[61][1],vnu_msg_in[60][1],vnu_msg_in[59][1],vnu_msg_in[58][1],vnu_msg_in[57][1],vnu_msg_in[56][1],vnu_msg_in[55][1],vnu_msg_in[54][1],vnu_msg_in[53][1],vnu_msg_in[52][1],vnu_msg_in[51][1],vnu_msg_in[50][1],vnu_msg_in[49][1],vnu_msg_in[48][1],vnu_msg_in[47][1],vnu_msg_in[46][1],vnu_msg_in[45][1],vnu_msg_in[44][1],vnu_msg_in[43][1],vnu_msg_in[42][1],vnu_msg_in[41][1],vnu_msg_in[40][1],vnu_msg_in[39][1],vnu_msg_in[38][1],vnu_msg_in[37][1],vnu_msg_in[36][1],vnu_msg_in[35][1],vnu_msg_in[34][1],vnu_msg_in[33][1],vnu_msg_in[32][1],vnu_msg_in[31][1],vnu_msg_in[30][1],vnu_msg_in[29][1],vnu_msg_in[28][1],vnu_msg_in[27][1],vnu_msg_in[26][1],vnu_msg_in[25][1],vnu_msg_in[24][1],vnu_msg_in[23][1],vnu_msg_in[22][1],vnu_msg_in[21][1],vnu_msg_in[20][1],vnu_msg_in[19][1],vnu_msg_in[18][1],vnu_msg_in[17][1],vnu_msg_in[16][1],vnu_msg_in[15][1],vnu_msg_in[14][1],vnu_msg_in[13][1],vnu_msg_in[12][1],vnu_msg_in[11][1],vnu_msg_in[10][1],vnu_msg_in[9][1],vnu_msg_in[8][1],vnu_msg_in[7][1],vnu_msg_in[6][1],vnu_msg_in[5][1],vnu_msg_in[4][1],vnu_msg_in[3][1],vnu_msg_in[2][1],vnu_msg_in[1][1],vnu_msg_in[0][1]}),	
	.sw_out_bit2 ({vnu_msg_in[84][2],vnu_msg_in[83][2],vnu_msg_in[82][2],vnu_msg_in[81][2],vnu_msg_in[80][2],vnu_msg_in[79][2],vnu_msg_in[78][2],vnu_msg_in[77][2],vnu_msg_in[76][2],vnu_msg_in[75][2],vnu_msg_in[74][2],vnu_msg_in[73][2],vnu_msg_in[72][2],vnu_msg_in[71][2],vnu_msg_in[70][2],vnu_msg_in[69][2],vnu_msg_in[68][2],vnu_msg_in[67][2],vnu_msg_in[66][2],vnu_msg_in[65][2],vnu_msg_in[64][2],vnu_msg_in[63][2],vnu_msg_in[62][2],vnu_msg_in[61][2],vnu_msg_in[60][2],vnu_msg_in[59][2],vnu_msg_in[58][2],vnu_msg_in[57][2],vnu_msg_in[56][2],vnu_msg_in[55][2],vnu_msg_in[54][2],vnu_msg_in[53][2],vnu_msg_in[52][2],vnu_msg_in[51][2],vnu_msg_in[50][2],vnu_msg_in[49][2],vnu_msg_in[48][2],vnu_msg_in[47][2],vnu_msg_in[46][2],vnu_msg_in[45][2],vnu_msg_in[44][2],vnu_msg_in[43][2],vnu_msg_in[42][2],vnu_msg_in[41][2],vnu_msg_in[40][2],vnu_msg_in[39][2],vnu_msg_in[38][2],vnu_msg_in[37][2],vnu_msg_in[36][2],vnu_msg_in[35][2],vnu_msg_in[34][2],vnu_msg_in[33][2],vnu_msg_in[32][2],vnu_msg_in[31][2],vnu_msg_in[30][2],vnu_msg_in[29][2],vnu_msg_in[28][2],vnu_msg_in[27][2],vnu_msg_in[26][2],vnu_msg_in[25][2],vnu_msg_in[24][2],vnu_msg_in[23][2],vnu_msg_in[22][2],vnu_msg_in[21][2],vnu_msg_in[20][2],vnu_msg_in[19][2],vnu_msg_in[18][2],vnu_msg_in[17][2],vnu_msg_in[16][2],vnu_msg_in[15][2],vnu_msg_in[14][2],vnu_msg_in[13][2],vnu_msg_in[12][2],vnu_msg_in[11][2],vnu_msg_in[10][2],vnu_msg_in[9][2],vnu_msg_in[8][2],vnu_msg_in[7][2],vnu_msg_in[6][2],vnu_msg_in[5][2],vnu_msg_in[4][2],vnu_msg_in[3][2],vnu_msg_in[2][2],vnu_msg_in[1][2],vnu_msg_in[0][2]}),	
	.sw_out_bit3 ({vnu_msg_in[84][3],vnu_msg_in[83][3],vnu_msg_in[82][3],vnu_msg_in[81][3],vnu_msg_in[80][3],vnu_msg_in[79][3],vnu_msg_in[78][3],vnu_msg_in[77][3],vnu_msg_in[76][3],vnu_msg_in[75][3],vnu_msg_in[74][3],vnu_msg_in[73][3],vnu_msg_in[72][3],vnu_msg_in[71][3],vnu_msg_in[70][3],vnu_msg_in[69][3],vnu_msg_in[68][3],vnu_msg_in[67][3],vnu_msg_in[66][3],vnu_msg_in[65][3],vnu_msg_in[64][3],vnu_msg_in[63][3],vnu_msg_in[62][3],vnu_msg_in[61][3],vnu_msg_in[60][3],vnu_msg_in[59][3],vnu_msg_in[58][3],vnu_msg_in[57][3],vnu_msg_in[56][3],vnu_msg_in[55][3],vnu_msg_in[54][3],vnu_msg_in[53][3],vnu_msg_in[52][3],vnu_msg_in[51][3],vnu_msg_in[50][3],vnu_msg_in[49][3],vnu_msg_in[48][3],vnu_msg_in[47][3],vnu_msg_in[46][3],vnu_msg_in[45][3],vnu_msg_in[44][3],vnu_msg_in[43][3],vnu_msg_in[42][3],vnu_msg_in[41][3],vnu_msg_in[40][3],vnu_msg_in[39][3],vnu_msg_in[38][3],vnu_msg_in[37][3],vnu_msg_in[36][3],vnu_msg_in[35][3],vnu_msg_in[34][3],vnu_msg_in[33][3],vnu_msg_in[32][3],vnu_msg_in[31][3],vnu_msg_in[30][3],vnu_msg_in[29][3],vnu_msg_in[28][3],vnu_msg_in[27][3],vnu_msg_in[26][3],vnu_msg_in[25][3],vnu_msg_in[24][3],vnu_msg_in[23][3],vnu_msg_in[22][3],vnu_msg_in[21][3],vnu_msg_in[20][3],vnu_msg_in[19][3],vnu_msg_in[18][3],vnu_msg_in[17][3],vnu_msg_in[16][3],vnu_msg_in[15][3],vnu_msg_in[14][3],vnu_msg_in[13][3],vnu_msg_in[12][3],vnu_msg_in[11][3],vnu_msg_in[10][3],vnu_msg_in[9][3],vnu_msg_in[8][3],vnu_msg_in[7][3],vnu_msg_in[6][3],vnu_msg_in[5][3],vnu_msg_in[4][3],vnu_msg_in[3][3],vnu_msg_in[2][3],vnu_msg_in[1][3],vnu_msg_in[0][3]}),	
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in0_bit0  (vnu_bs_in_bit[0]),
	.sw_in0_bit1  (vnu_bs_in_bit[1]),
	.sw_in0_bit2  (vnu_bs_in_bit[2]),
	.sw_in0_bit3  (vnu_bs_in_bit[3]),

	.sw_in1_bit0 (ch_bs_in_bit[0]),
	.sw_in1_bit1 (ch_bs_in_bit[1]),
	.sw_in1_bit2 (ch_bs_in_bit[2]),
	.sw_in1_bit3 (ch_bs_in_bit[3]),

	.sw_in2_bit0 (dnu_inRotate_bit),

	.shift_factor (vnu_shift_factorIn), // offset shift factor of submatrix
	.sw_in_bit0_src (vnu_bs_bit0_src),
	.sw_in_src (vnu_bs_src)
);
assign vnu_shift_factorIn = (vnu_bs_bit0_src[0] == 1'b1) ? v2c_shift_factor_cur_0 :
							(vnu_bs_bit0_src[1] == 1'b1) ? ch_ramRD_shift_factor_cur_0 :
							(vnu_bs_bit0_src[2] == 1'b1) ? dnu_inRotate_shift_factor : v2c_shift_factor_cur_0;
/*----------------------------------------------*/	
	reg [ADDR_WIDTH-1:0] c2v_mem_page_addr;
	reg [ADDR_WIDTH-1:0] v2c_mem_page_addr;
	mem_subsystem_top_submatrix_7 #(
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
		) inst_mem_subsystem_top_submatrix_7 (
			.mem_to_vnu_0     (mem_to_vnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_vnu_1     (mem_to_vnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_vnu_2     (mem_to_vnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_vnu_3     (mem_to_vnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_vnu_4     (mem_to_vnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_vnu_5     (mem_to_vnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_vnu_6     (mem_to_vnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_vnu_7     (mem_to_vnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_vnu_8     (mem_to_vnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_vnu_9     (mem_to_vnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_vnu_10    (mem_to_vnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_vnu_11    (mem_to_vnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_vnu_12    (mem_to_vnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_vnu_13    (mem_to_vnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_vnu_14    (mem_to_vnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_vnu_15    (mem_to_vnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_vnu_16    (mem_to_vnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_vnu_17    (mem_to_vnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_vnu_18    (mem_to_vnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_vnu_19    (mem_to_vnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_vnu_20    (mem_to_vnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_vnu_21    (mem_to_vnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_vnu_22    (mem_to_vnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_vnu_23    (mem_to_vnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_vnu_24    (mem_to_vnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_vnu_25    (mem_to_vnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_vnu_26    (mem_to_vnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_vnu_27    (mem_to_vnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_vnu_28    (mem_to_vnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_vnu_29    (mem_to_vnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_vnu_30    (mem_to_vnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_vnu_31    (mem_to_vnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_vnu_32    (mem_to_vnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_vnu_33    (mem_to_vnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_vnu_34    (mem_to_vnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_vnu_35    (mem_to_vnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_vnu_36    (mem_to_vnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_vnu_37    (mem_to_vnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_vnu_38    (mem_to_vnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_vnu_39    (mem_to_vnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_vnu_40    (mem_to_vnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_vnu_41    (mem_to_vnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_vnu_42    (mem_to_vnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_vnu_43    (mem_to_vnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_vnu_44    (mem_to_vnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_vnu_45    (mem_to_vnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_vnu_46    (mem_to_vnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_vnu_47    (mem_to_vnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_vnu_48    (mem_to_vnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_vnu_49    (mem_to_vnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_vnu_50    (mem_to_vnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_vnu_51    (mem_to_vnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_vnu_52    (mem_to_vnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_vnu_53    (mem_to_vnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_vnu_54    (mem_to_vnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_vnu_55    (mem_to_vnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_vnu_56    (mem_to_vnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_vnu_57    (mem_to_vnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_vnu_58    (mem_to_vnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_vnu_59    (mem_to_vnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_vnu_60    (mem_to_vnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_vnu_61    (mem_to_vnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_vnu_62    (mem_to_vnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_vnu_63    (mem_to_vnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_vnu_64    (mem_to_vnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_vnu_65    (mem_to_vnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_vnu_66    (mem_to_vnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_vnu_67    (mem_to_vnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_vnu_68    (mem_to_vnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_vnu_69    (mem_to_vnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_vnu_70    (mem_to_vnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_vnu_71    (mem_to_vnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_vnu_72    (mem_to_vnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_vnu_73    (mem_to_vnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_vnu_74    (mem_to_vnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_vnu_75    (mem_to_vnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_vnu_76    (mem_to_vnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_vnu_77    (mem_to_vnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_vnu_78    (mem_to_vnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_vnu_79    (mem_to_vnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_vnu_80    (mem_to_vnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_vnu_81    (mem_to_vnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_vnu_82    (mem_to_vnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_vnu_83    (mem_to_vnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_vnu_84    (mem_to_vnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),
			.mem_to_cnu_0     (mem_to_cnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_cnu_1     (mem_to_cnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_cnu_2     (mem_to_cnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_cnu_3     (mem_to_cnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_cnu_4     (mem_to_cnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_cnu_5     (mem_to_cnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_cnu_6     (mem_to_cnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_cnu_7     (mem_to_cnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_cnu_8     (mem_to_cnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_cnu_9     (mem_to_cnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_cnu_10    (mem_to_cnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_cnu_11    (mem_to_cnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_cnu_12    (mem_to_cnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_cnu_13    (mem_to_cnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_cnu_14    (mem_to_cnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_cnu_15    (mem_to_cnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_cnu_16    (mem_to_cnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_cnu_17    (mem_to_cnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_cnu_18    (mem_to_cnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_cnu_19    (mem_to_cnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_cnu_20    (mem_to_cnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_cnu_21    (mem_to_cnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_cnu_22    (mem_to_cnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_cnu_23    (mem_to_cnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_cnu_24    (mem_to_cnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_cnu_25    (mem_to_cnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_cnu_26    (mem_to_cnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_cnu_27    (mem_to_cnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_cnu_28    (mem_to_cnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_cnu_29    (mem_to_cnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_cnu_30    (mem_to_cnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_cnu_31    (mem_to_cnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_cnu_32    (mem_to_cnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_cnu_33    (mem_to_cnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_cnu_34    (mem_to_cnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_cnu_35    (mem_to_cnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_cnu_36    (mem_to_cnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_cnu_37    (mem_to_cnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_cnu_38    (mem_to_cnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_cnu_39    (mem_to_cnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_cnu_40    (mem_to_cnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_cnu_41    (mem_to_cnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_cnu_42    (mem_to_cnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_cnu_43    (mem_to_cnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_cnu_44    (mem_to_cnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_cnu_45    (mem_to_cnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_cnu_46    (mem_to_cnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_cnu_47    (mem_to_cnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_cnu_48    (mem_to_cnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_cnu_49    (mem_to_cnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_cnu_50    (mem_to_cnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_cnu_51    (mem_to_cnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_cnu_52    (mem_to_cnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_cnu_53    (mem_to_cnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_cnu_54    (mem_to_cnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_cnu_55    (mem_to_cnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_cnu_56    (mem_to_cnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_cnu_57    (mem_to_cnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_cnu_58    (mem_to_cnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_cnu_59    (mem_to_cnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_cnu_60    (mem_to_cnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_cnu_61    (mem_to_cnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_cnu_62    (mem_to_cnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_cnu_63    (mem_to_cnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_cnu_64    (mem_to_cnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_cnu_65    (mem_to_cnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_cnu_66    (mem_to_cnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_cnu_67    (mem_to_cnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_cnu_68    (mem_to_cnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_cnu_69    (mem_to_cnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_cnu_70    (mem_to_cnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_cnu_71    (mem_to_cnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_cnu_72    (mem_to_cnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_cnu_73    (mem_to_cnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_cnu_74    (mem_to_cnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_cnu_75    (mem_to_cnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_cnu_76    (mem_to_cnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_cnu_77    (mem_to_cnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_cnu_78    (mem_to_cnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_cnu_79    (mem_to_cnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_cnu_80    (mem_to_cnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_cnu_81    (mem_to_cnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_cnu_82    (mem_to_cnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_cnu_83    (mem_to_cnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_cnu_84    (mem_to_cnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),

			.vnu_to_mem_0     (vnu_msg_in[0 ]),
			.vnu_to_mem_1     (vnu_msg_in[1 ]),
			.vnu_to_mem_2     (vnu_msg_in[2 ]),
			.vnu_to_mem_3     (vnu_msg_in[3 ]),
			.vnu_to_mem_4     (vnu_msg_in[4 ]),
			.vnu_to_mem_5     (vnu_msg_in[5 ]),
			.vnu_to_mem_6     (vnu_msg_in[6 ]),
			.vnu_to_mem_7     (vnu_msg_in[7 ]),
			.vnu_to_mem_8     (vnu_msg_in[8 ]),
			.vnu_to_mem_9     (vnu_msg_in[9 ]),
			.vnu_to_mem_10    (vnu_msg_in[10]),
			.vnu_to_mem_11    (vnu_msg_in[11]),
			.vnu_to_mem_12    (vnu_msg_in[12]),
			.vnu_to_mem_13    (vnu_msg_in[13]),
			.vnu_to_mem_14    (vnu_msg_in[14]),
			.vnu_to_mem_15    (vnu_msg_in[15]),
			.vnu_to_mem_16    (vnu_msg_in[16]),
			.vnu_to_mem_17    (vnu_msg_in[17]),
			.vnu_to_mem_18    (vnu_msg_in[18]),
			.vnu_to_mem_19    (vnu_msg_in[19]),
			.vnu_to_mem_20    (vnu_msg_in[20]),
			.vnu_to_mem_21    (vnu_msg_in[21]),
			.vnu_to_mem_22    (vnu_msg_in[22]),
			.vnu_to_mem_23    (vnu_msg_in[23]),
			.vnu_to_mem_24    (vnu_msg_in[24]),
			.vnu_to_mem_25    (vnu_msg_in[25]),
			.vnu_to_mem_26    (vnu_msg_in[26]),
			.vnu_to_mem_27    (vnu_msg_in[27]),
			.vnu_to_mem_28    (vnu_msg_in[28]),
			.vnu_to_mem_29    (vnu_msg_in[29]),
			.vnu_to_mem_30    (vnu_msg_in[30]),
			.vnu_to_mem_31    (vnu_msg_in[31]),
			.vnu_to_mem_32    (vnu_msg_in[32]),
			.vnu_to_mem_33    (vnu_msg_in[33]),
			.vnu_to_mem_34    (vnu_msg_in[34]),
			.vnu_to_mem_35    (vnu_msg_in[35]),
			.vnu_to_mem_36    (vnu_msg_in[36]),
			.vnu_to_mem_37    (vnu_msg_in[37]),
			.vnu_to_mem_38    (vnu_msg_in[38]),
			.vnu_to_mem_39    (vnu_msg_in[39]),
			.vnu_to_mem_40    (vnu_msg_in[40]),
			.vnu_to_mem_41    (vnu_msg_in[41]),
			.vnu_to_mem_42    (vnu_msg_in[42]),
			.vnu_to_mem_43    (vnu_msg_in[43]),
			.vnu_to_mem_44    (vnu_msg_in[44]),
			.vnu_to_mem_45    (vnu_msg_in[45]),
			.vnu_to_mem_46    (vnu_msg_in[46]),
			.vnu_to_mem_47    (vnu_msg_in[47]),
			.vnu_to_mem_48    (vnu_msg_in[48]),
			.vnu_to_mem_49    (vnu_msg_in[49]),
			.vnu_to_mem_50    (vnu_msg_in[50]),
			.vnu_to_mem_51    (vnu_msg_in[51]),
			.vnu_to_mem_52    (vnu_msg_in[52]),
			.vnu_to_mem_53    (vnu_msg_in[53]),
			.vnu_to_mem_54    (vnu_msg_in[54]),
			.vnu_to_mem_55    (vnu_msg_in[55]),
			.vnu_to_mem_56    (vnu_msg_in[56]),
			.vnu_to_mem_57    (vnu_msg_in[57]),
			.vnu_to_mem_58    (vnu_msg_in[58]),
			.vnu_to_mem_59    (vnu_msg_in[59]),
			.vnu_to_mem_60    (vnu_msg_in[60]),
			.vnu_to_mem_61    (vnu_msg_in[61]),
			.vnu_to_mem_62    (vnu_msg_in[62]),
			.vnu_to_mem_63    (vnu_msg_in[63]),
			.vnu_to_mem_64    (vnu_msg_in[64]),
			.vnu_to_mem_65    (vnu_msg_in[65]),
			.vnu_to_mem_66    (vnu_msg_in[66]),
			.vnu_to_mem_67    (vnu_msg_in[67]),
			.vnu_to_mem_68    (vnu_msg_in[68]),
			.vnu_to_mem_69    (vnu_msg_in[69]),
			.vnu_to_mem_70    (vnu_msg_in[70]),
			.vnu_to_mem_71    (vnu_msg_in[71]),
			.vnu_to_mem_72    (vnu_msg_in[72]),
			.vnu_to_mem_73    (vnu_msg_in[73]),
			.vnu_to_mem_74    (vnu_msg_in[74]),
			.vnu_to_mem_75    (vnu_msg_in[75]),
			.vnu_to_mem_76    (vnu_msg_in[76]),
			.vnu_to_mem_77    (vnu_msg_in[77]),
			.vnu_to_mem_78    (vnu_msg_in[78]),
			.vnu_to_mem_79    (vnu_msg_in[79]),
			.vnu_to_mem_80    (vnu_msg_in[80]),
			.vnu_to_mem_81    (vnu_msg_in[81]),
			.vnu_to_mem_82    (vnu_msg_in[82]),
			.vnu_to_mem_83    (vnu_msg_in[83]),
			.vnu_to_mem_84    (vnu_msg_in[84]),
			.cnu_to_mem_0     (cnu_msg_in[0 ]),
			.cnu_to_mem_1     (cnu_msg_in[1 ]),
			.cnu_to_mem_2     (cnu_msg_in[2 ]),
			.cnu_to_mem_3     (cnu_msg_in[3 ]),
			.cnu_to_mem_4     (cnu_msg_in[4 ]),
			.cnu_to_mem_5     (cnu_msg_in[5 ]),
			.cnu_to_mem_6     (cnu_msg_in[6 ]),
			.cnu_to_mem_7     (cnu_msg_in[7 ]),
			.cnu_to_mem_8     (cnu_msg_in[8 ]),
			.cnu_to_mem_9     (cnu_msg_in[9 ]),
			.cnu_to_mem_10    (cnu_msg_in[10]),
			.cnu_to_mem_11    (cnu_msg_in[11]),
			.cnu_to_mem_12    (cnu_msg_in[12]),
			.cnu_to_mem_13    (cnu_msg_in[13]),
			.cnu_to_mem_14    (cnu_msg_in[14]),
			.cnu_to_mem_15    (cnu_msg_in[15]),
			.cnu_to_mem_16    (cnu_msg_in[16]),
			.cnu_to_mem_17    (cnu_msg_in[17]),
			.cnu_to_mem_18    (cnu_msg_in[18]),
			.cnu_to_mem_19    (cnu_msg_in[19]),
			.cnu_to_mem_20    (cnu_msg_in[20]),
			.cnu_to_mem_21    (cnu_msg_in[21]),
			.cnu_to_mem_22    (cnu_msg_in[22]),
			.cnu_to_mem_23    (cnu_msg_in[23]),
			.cnu_to_mem_24    (cnu_msg_in[24]),
			.cnu_to_mem_25    (cnu_msg_in[25]),
			.cnu_to_mem_26    (cnu_msg_in[26]),
			.cnu_to_mem_27    (cnu_msg_in[27]),
			.cnu_to_mem_28    (cnu_msg_in[28]),
			.cnu_to_mem_29    (cnu_msg_in[29]),
			.cnu_to_mem_30    (cnu_msg_in[30]),
			.cnu_to_mem_31    (cnu_msg_in[31]),
			.cnu_to_mem_32    (cnu_msg_in[32]),
			.cnu_to_mem_33    (cnu_msg_in[33]),
			.cnu_to_mem_34    (cnu_msg_in[34]),
			.cnu_to_mem_35    (cnu_msg_in[35]),
			.cnu_to_mem_36    (cnu_msg_in[36]),
			.cnu_to_mem_37    (cnu_msg_in[37]),
			.cnu_to_mem_38    (cnu_msg_in[38]),
			.cnu_to_mem_39    (cnu_msg_in[39]),
			.cnu_to_mem_40    (cnu_msg_in[40]),
			.cnu_to_mem_41    (cnu_msg_in[41]),
			.cnu_to_mem_42    (cnu_msg_in[42]),
			.cnu_to_mem_43    (cnu_msg_in[43]),
			.cnu_to_mem_44    (cnu_msg_in[44]),
			.cnu_to_mem_45    (cnu_msg_in[45]),
			.cnu_to_mem_46    (cnu_msg_in[46]),
			.cnu_to_mem_47    (cnu_msg_in[47]),
			.cnu_to_mem_48    (cnu_msg_in[48]),
			.cnu_to_mem_49    (cnu_msg_in[49]),
			.cnu_to_mem_50    (cnu_msg_in[50]),
			.cnu_to_mem_51    (cnu_msg_in[51]),
			.cnu_to_mem_52    (cnu_msg_in[52]),
			.cnu_to_mem_53    (cnu_msg_in[53]),
			.cnu_to_mem_54    (cnu_msg_in[54]),
			.cnu_to_mem_55    (cnu_msg_in[55]),
			.cnu_to_mem_56    (cnu_msg_in[56]),
			.cnu_to_mem_57    (cnu_msg_in[57]),
			.cnu_to_mem_58    (cnu_msg_in[58]),
			.cnu_to_mem_59    (cnu_msg_in[59]),
			.cnu_to_mem_60    (cnu_msg_in[60]),
			.cnu_to_mem_61    (cnu_msg_in[61]),
			.cnu_to_mem_62    (cnu_msg_in[62]),
			.cnu_to_mem_63    (cnu_msg_in[63]),
			.cnu_to_mem_64    (cnu_msg_in[64]),
			.cnu_to_mem_65    (cnu_msg_in[65]),
			.cnu_to_mem_66    (cnu_msg_in[66]),
			.cnu_to_mem_67    (cnu_msg_in[67]),
			.cnu_to_mem_68    (cnu_msg_in[68]),
			.cnu_to_mem_69    (cnu_msg_in[69]),
			.cnu_to_mem_70    (cnu_msg_in[70]),
			.cnu_to_mem_71    (cnu_msg_in[71]),
			.cnu_to_mem_72    (cnu_msg_in[72]),
			.cnu_to_mem_73    (cnu_msg_in[73]),
			.cnu_to_mem_74    (cnu_msg_in[74]),
			.cnu_to_mem_75    (cnu_msg_in[75]),
			.cnu_to_mem_76    (cnu_msg_in[76]),
			.cnu_to_mem_77    (cnu_msg_in[77]),
			.cnu_to_mem_78    (cnu_msg_in[78]),
			.cnu_to_mem_79    (cnu_msg_in[79]),
			.cnu_to_mem_80    (cnu_msg_in[80]),
			.cnu_to_mem_81    (cnu_msg_in[81]),
			.cnu_to_mem_82    (cnu_msg_in[82]),
			.cnu_to_mem_83    (cnu_msg_in[83]),
			.cnu_to_mem_84    (cnu_msg_in[84]),
			.cnu_sync_addr    (cnu_mem_page_sync_addr),
			.vnu_sync_addr    (vnu_mem_page_sync_addr),
			.cnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.vnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.last_row_chunk   ({c2v_last_row_chunk, v2c_last_row_chunk}),
			.we               ({v2c_mem_we, c2v_mem_we}),
			.sys_clk          (read_clk),
			.rstn             (rstn)
		);
		assign cnu_mem_page_sync_addr = (v2c_mem_fetch == 1'b1) ? v2c_mem_page_rd_addr : 
										(c2v_mem_we == 1'b1) ? c2v_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.

		assign vnu_mem_page_sync_addr = (c2v_mem_fetch == 1'b1) ? c2v_mem_page_rd_addr : 
										(v2c_mem_we == 1'b1) ? v2c_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Check-to-Variable messages RAMs write-page addresses
	always @(posedge read_clk) begin
		if(rstn == 1'b0) 
			c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE;
		else if(c2v_mem_we == 1'b1) begin
			// page increment pattern within layer 0
			if(v2c_layer_cnt[0] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_1+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 1
			if(v2c_layer_cnt[1] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_2+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 2
			if(v2c_layer_cnt[2] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_2-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
		end
	end

	always @(posedge read_clk) begin
		if(rstn == 1'b0) begin
			c2v_shift_factor_cur_2 <= shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
		end
		else if(c2v_bs_en == 1'b1) begin
			c2v_shift_factor_cur_2 <= 0;
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
/*--------------------------------------------------------------------------*/
// Channel Buffers
reg [CH_DATA_WIDTH-1:0] ch_msg_genIn;
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_0 [0:CHECK_PARALLELISM-1]; // [0:84]
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_1 [0:CHECK_PARALLELISM-1]; // [0:84]
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_rd_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chInit_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chLayer_wr_addr;
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

			.din        (ch_msg_genIn[CH_DATA_WIDTH-1:0]),

			.read_addr  (submatrix_ch_ram_rd_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.write_addr (submatrix_ch_ram_wr_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.we         (ch_ram_we),
			.read_clk   (ch_ram_rd_clk),
			.write_clk  (ch_ram_wr_clk),
			.rstn       (rstn)
		);
		// Updating the Channel RAMs by either initally channel messages (from AWGNs) or circularly shifted channel messages
		assign submatrix_ch_ram_wr_addr = (ch_ram_init_we == 1'b1) ? submatrix_chInit_wr_addr :
														(ch_ram_wb == 1'b1     ) ? submatrix_chLayer_wr_addr : 
																				   CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.


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
	// Channel messages RAMs write-page addresses
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
endmodule

module msg_pass_submatrix_8_unit #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,
	parameter VN_DEGREE = 3,   // degree of one variable node
/*-------------------------------------------------------------------------------------*/
	// Parameters related to BS, PA and MEM
	parameter RAM_DEPTH = 1024,
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH),
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1),
	parameter shift_factor_0 = CHECK_PARALLELISM-51,
	parameter shift_factor_1 = CHECK_PARALLELISM-28,
	parameter shift_factor_2 = CHECK_PARALLELISM-79,

`ifdef SCHED_4_6
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,
	parameter C2V_MEM_ADDR_BASE = 0,
	parameter V2C_MEM_ADDR_BASE = ROW_CHUNK_NUM,
	parameter V2C_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter C2V_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH),
`endif
	parameter START_PAGE_1_0 = 2, // starting page address of layer 0 of submatrix_1
	parameter START_PAGE_1_1 = 8, // starting page address of layer 1 of submatrix_1
	parameter START_PAGE_1_2 = 1  // starting page address of layer 2 of submatrix_1
) (
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu,

	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit,

	// control signals
	input wire c2v_bs_en,
	input wire v2c_bs_en,
	input wire ch_bs_en,
	/*------------------------------*/
	// Control signals associative with message passing of channel buffer and DNU.SignExtension
	input wire ch_ram_init_we,
	input wire ch_ram_fetch,
	input wire v2c_outRotate_reg_we,
	input wire dnu_inRotate_bs_en,
	input wire dnu_inRotate_pa_en,
	input wire dnu_inRotate_wb,
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
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,

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
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_2;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_2;
wire [6:0]  cnu_left_sel;
wire [6:0]  cnu_right_sel;
wire [83:0] cnu_merge_sel;
wire [6:0]  vnu_left_sel;
wire [6:0]  vnu_right_sel;
wire [83:0] vnu_merge_sel;
wire [CHECK_PARALLELISM-1:0] cnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] vnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] ch_bs_in_bit [0:QUAN_SIZE-1];
genvar bit_index;
generate
	for(bit_index=0;bit_index<QUAN_SIZE;bit_index=bit_index+1) begin : extrinsic_msg_bs_in_inst
		assign cnu_bs_in_bit[bit_index] = {c2v_bs_in[QUAN_SIZE*84+bit_index],c2v_bs_in[QUAN_SIZE*83+bit_index],c2v_bs_in[QUAN_SIZE*82+bit_index],c2v_bs_in[QUAN_SIZE*81+bit_index],c2v_bs_in[QUAN_SIZE*80+bit_index],c2v_bs_in[QUAN_SIZE*79+bit_index],c2v_bs_in[QUAN_SIZE*78+bit_index],c2v_bs_in[QUAN_SIZE*77+bit_index],c2v_bs_in[QUAN_SIZE*76+bit_index],c2v_bs_in[QUAN_SIZE*75+bit_index],c2v_bs_in[QUAN_SIZE*74+bit_index],c2v_bs_in[QUAN_SIZE*73+bit_index],c2v_bs_in[QUAN_SIZE*72+bit_index],c2v_bs_in[QUAN_SIZE*71+bit_index],c2v_bs_in[QUAN_SIZE*70+bit_index],c2v_bs_in[QUAN_SIZE*69+bit_index],c2v_bs_in[QUAN_SIZE*68+bit_index],c2v_bs_in[QUAN_SIZE*67+bit_index],c2v_bs_in[QUAN_SIZE*66+bit_index],c2v_bs_in[QUAN_SIZE*65+bit_index],c2v_bs_in[QUAN_SIZE*64+bit_index],c2v_bs_in[QUAN_SIZE*63+bit_index],c2v_bs_in[QUAN_SIZE*62+bit_index],c2v_bs_in[QUAN_SIZE*61+bit_index],c2v_bs_in[QUAN_SIZE*60+bit_index],c2v_bs_in[QUAN_SIZE*59+bit_index],c2v_bs_in[QUAN_SIZE*58+bit_index],c2v_bs_in[QUAN_SIZE*57+bit_index],c2v_bs_in[QUAN_SIZE*56+bit_index],c2v_bs_in[QUAN_SIZE*55+bit_index],c2v_bs_in[QUAN_SIZE*54+bit_index],c2v_bs_in[QUAN_SIZE*53+bit_index],c2v_bs_in[QUAN_SIZE*52+bit_index],c2v_bs_in[QUAN_SIZE*51+bit_index],c2v_bs_in[QUAN_SIZE*50+bit_index],c2v_bs_in[QUAN_SIZE*49+bit_index],c2v_bs_in[QUAN_SIZE*48+bit_index],c2v_bs_in[QUAN_SIZE*47+bit_index],c2v_bs_in[QUAN_SIZE*46+bit_index],c2v_bs_in[QUAN_SIZE*45+bit_index],c2v_bs_in[QUAN_SIZE*44+bit_index],c2v_bs_in[QUAN_SIZE*43+bit_index],c2v_bs_in[QUAN_SIZE*42+bit_index],c2v_bs_in[QUAN_SIZE*41+bit_index],c2v_bs_in[QUAN_SIZE*40+bit_index],c2v_bs_in[QUAN_SIZE*39+bit_index],c2v_bs_in[QUAN_SIZE*38+bit_index],c2v_bs_in[QUAN_SIZE*37+bit_index],c2v_bs_in[QUAN_SIZE*36+bit_index],c2v_bs_in[QUAN_SIZE*35+bit_index],c2v_bs_in[QUAN_SIZE*34+bit_index],c2v_bs_in[QUAN_SIZE*33+bit_index],c2v_bs_in[QUAN_SIZE*32+bit_index],c2v_bs_in[QUAN_SIZE*31+bit_index],c2v_bs_in[QUAN_SIZE*30+bit_index],c2v_bs_in[QUAN_SIZE*29+bit_index],c2v_bs_in[QUAN_SIZE*28+bit_index],c2v_bs_in[QUAN_SIZE*27+bit_index],c2v_bs_in[QUAN_SIZE*26+bit_index],c2v_bs_in[QUAN_SIZE*25+bit_index],c2v_bs_in[QUAN_SIZE*24+bit_index],c2v_bs_in[QUAN_SIZE*23+bit_index],c2v_bs_in[QUAN_SIZE*22+bit_index],c2v_bs_in[QUAN_SIZE*21+bit_index],c2v_bs_in[QUAN_SIZE*20+bit_index],c2v_bs_in[QUAN_SIZE*19+bit_index],c2v_bs_in[QUAN_SIZE*18+bit_index],c2v_bs_in[QUAN_SIZE*17+bit_index],c2v_bs_in[QUAN_SIZE*16+bit_index],c2v_bs_in[QUAN_SIZE*15+bit_index],c2v_bs_in[QUAN_SIZE*14+bit_index],c2v_bs_in[QUAN_SIZE*13+bit_index],c2v_bs_in[QUAN_SIZE*12+bit_index],c2v_bs_in[QUAN_SIZE*11+bit_index],c2v_bs_in[QUAN_SIZE*10+bit_index],c2v_bs_in[QUAN_SIZE*9+bit_index],c2v_bs_in[QUAN_SIZE*8+bit_index],c2v_bs_in[QUAN_SIZE*7+bit_index],c2v_bs_in[QUAN_SIZE*6+bit_index],c2v_bs_in[QUAN_SIZE*5+bit_index],c2v_bs_in[QUAN_SIZE*4+bit_index],c2v_bs_in[QUAN_SIZE*3+bit_index],c2v_bs_in[QUAN_SIZE*2+bit_index],c2v_bs_in[QUAN_SIZE*1+bit_index],c2v_bs_in[QUAN_SIZE*0+bit_index]};
		assign vnu_bs_in_bit[bit_index] = {v2c_bs_in[QUAN_SIZE*84+bit_index],v2c_bs_in[QUAN_SIZE*83+bit_index],v2c_bs_in[QUAN_SIZE*82+bit_index],v2c_bs_in[QUAN_SIZE*81+bit_index],v2c_bs_in[QUAN_SIZE*80+bit_index],v2c_bs_in[QUAN_SIZE*79+bit_index],v2c_bs_in[QUAN_SIZE*78+bit_index],v2c_bs_in[QUAN_SIZE*77+bit_index],v2c_bs_in[QUAN_SIZE*76+bit_index],v2c_bs_in[QUAN_SIZE*75+bit_index],v2c_bs_in[QUAN_SIZE*74+bit_index],v2c_bs_in[QUAN_SIZE*73+bit_index],v2c_bs_in[QUAN_SIZE*72+bit_index],v2c_bs_in[QUAN_SIZE*71+bit_index],v2c_bs_in[QUAN_SIZE*70+bit_index],v2c_bs_in[QUAN_SIZE*69+bit_index],v2c_bs_in[QUAN_SIZE*68+bit_index],v2c_bs_in[QUAN_SIZE*67+bit_index],v2c_bs_in[QUAN_SIZE*66+bit_index],v2c_bs_in[QUAN_SIZE*65+bit_index],v2c_bs_in[QUAN_SIZE*64+bit_index],v2c_bs_in[QUAN_SIZE*63+bit_index],v2c_bs_in[QUAN_SIZE*62+bit_index],v2c_bs_in[QUAN_SIZE*61+bit_index],v2c_bs_in[QUAN_SIZE*60+bit_index],v2c_bs_in[QUAN_SIZE*59+bit_index],v2c_bs_in[QUAN_SIZE*58+bit_index],v2c_bs_in[QUAN_SIZE*57+bit_index],v2c_bs_in[QUAN_SIZE*56+bit_index],v2c_bs_in[QUAN_SIZE*55+bit_index],v2c_bs_in[QUAN_SIZE*54+bit_index],v2c_bs_in[QUAN_SIZE*53+bit_index],v2c_bs_in[QUAN_SIZE*52+bit_index],v2c_bs_in[QUAN_SIZE*51+bit_index],v2c_bs_in[QUAN_SIZE*50+bit_index],v2c_bs_in[QUAN_SIZE*49+bit_index],v2c_bs_in[QUAN_SIZE*48+bit_index],v2c_bs_in[QUAN_SIZE*47+bit_index],v2c_bs_in[QUAN_SIZE*46+bit_index],v2c_bs_in[QUAN_SIZE*45+bit_index],v2c_bs_in[QUAN_SIZE*44+bit_index],v2c_bs_in[QUAN_SIZE*43+bit_index],v2c_bs_in[QUAN_SIZE*42+bit_index],v2c_bs_in[QUAN_SIZE*41+bit_index],v2c_bs_in[QUAN_SIZE*40+bit_index],v2c_bs_in[QUAN_SIZE*39+bit_index],v2c_bs_in[QUAN_SIZE*38+bit_index],v2c_bs_in[QUAN_SIZE*37+bit_index],v2c_bs_in[QUAN_SIZE*36+bit_index],v2c_bs_in[QUAN_SIZE*35+bit_index],v2c_bs_in[QUAN_SIZE*34+bit_index],v2c_bs_in[QUAN_SIZE*33+bit_index],v2c_bs_in[QUAN_SIZE*32+bit_index],v2c_bs_in[QUAN_SIZE*31+bit_index],v2c_bs_in[QUAN_SIZE*30+bit_index],v2c_bs_in[QUAN_SIZE*29+bit_index],v2c_bs_in[QUAN_SIZE*28+bit_index],v2c_bs_in[QUAN_SIZE*27+bit_index],v2c_bs_in[QUAN_SIZE*26+bit_index],v2c_bs_in[QUAN_SIZE*25+bit_index],v2c_bs_in[QUAN_SIZE*24+bit_index],v2c_bs_in[QUAN_SIZE*23+bit_index],v2c_bs_in[QUAN_SIZE*22+bit_index],v2c_bs_in[QUAN_SIZE*21+bit_index],v2c_bs_in[QUAN_SIZE*20+bit_index],v2c_bs_in[QUAN_SIZE*19+bit_index],v2c_bs_in[QUAN_SIZE*18+bit_index],v2c_bs_in[QUAN_SIZE*17+bit_index],v2c_bs_in[QUAN_SIZE*16+bit_index],v2c_bs_in[QUAN_SIZE*15+bit_index],v2c_bs_in[QUAN_SIZE*14+bit_index],v2c_bs_in[QUAN_SIZE*13+bit_index],v2c_bs_in[QUAN_SIZE*12+bit_index],v2c_bs_in[QUAN_SIZE*11+bit_index],v2c_bs_in[QUAN_SIZE*10+bit_index],v2c_bs_in[QUAN_SIZE*9+bit_index],v2c_bs_in[QUAN_SIZE*8+bit_index],v2c_bs_in[QUAN_SIZE*7+bit_index],v2c_bs_in[QUAN_SIZE*6+bit_index],v2c_bs_in[QUAN_SIZE*5+bit_index],v2c_bs_in[QUAN_SIZE*4+bit_index],v2c_bs_in[QUAN_SIZE*3+bit_index],v2c_bs_in[QUAN_SIZE*2+bit_index],v2c_bs_in[QUAN_SIZE*1+bit_index],v2c_bs_in[QUAN_SIZE*0+bit_index]};
		assign ch_bs_in_bit[bit_index]  = { ch_bs_in[QUAN_SIZE*84+bit_index], ch_bs_in[QUAN_SIZE*83+bit_index], ch_bs_in[QUAN_SIZE*82+bit_index], ch_bs_in[QUAN_SIZE*81+bit_index], ch_bs_in[QUAN_SIZE*80+bit_index], ch_bs_in[QUAN_SIZE*79+bit_index], ch_bs_in[QUAN_SIZE*78+bit_index], ch_bs_in[QUAN_SIZE*77+bit_index], ch_bs_in[QUAN_SIZE*76+bit_index], ch_bs_in[QUAN_SIZE*75+bit_index], ch_bs_in[QUAN_SIZE*74+bit_index], ch_bs_in[QUAN_SIZE*73+bit_index], ch_bs_in[QUAN_SIZE*72+bit_index], ch_bs_in[QUAN_SIZE*71+bit_index], ch_bs_in[QUAN_SIZE*70+bit_index], ch_bs_in[QUAN_SIZE*69+bit_index], ch_bs_in[QUAN_SIZE*68+bit_index], ch_bs_in[QUAN_SIZE*67+bit_index], ch_bs_in[QUAN_SIZE*66+bit_index], ch_bs_in[QUAN_SIZE*65+bit_index], ch_bs_in[QUAN_SIZE*64+bit_index], ch_bs_in[QUAN_SIZE*63+bit_index], ch_bs_in[QUAN_SIZE*62+bit_index], ch_bs_in[QUAN_SIZE*61+bit_index], ch_bs_in[QUAN_SIZE*60+bit_index], ch_bs_in[QUAN_SIZE*59+bit_index], ch_bs_in[QUAN_SIZE*58+bit_index], ch_bs_in[QUAN_SIZE*57+bit_index], ch_bs_in[QUAN_SIZE*56+bit_index], ch_bs_in[QUAN_SIZE*55+bit_index], ch_bs_in[QUAN_SIZE*54+bit_index], ch_bs_in[QUAN_SIZE*53+bit_index], ch_bs_in[QUAN_SIZE*52+bit_index], ch_bs_in[QUAN_SIZE*51+bit_index], ch_bs_in[QUAN_SIZE*50+bit_index], ch_bs_in[QUAN_SIZE*49+bit_index], ch_bs_in[QUAN_SIZE*48+bit_index], ch_bs_in[QUAN_SIZE*47+bit_index], ch_bs_in[QUAN_SIZE*46+bit_index], ch_bs_in[QUAN_SIZE*45+bit_index], ch_bs_in[QUAN_SIZE*44+bit_index], ch_bs_in[QUAN_SIZE*43+bit_index], ch_bs_in[QUAN_SIZE*42+bit_index], ch_bs_in[QUAN_SIZE*41+bit_index], ch_bs_in[QUAN_SIZE*40+bit_index], ch_bs_in[QUAN_SIZE*39+bit_index], ch_bs_in[QUAN_SIZE*38+bit_index], ch_bs_in[QUAN_SIZE*37+bit_index], ch_bs_in[QUAN_SIZE*36+bit_index], ch_bs_in[QUAN_SIZE*35+bit_index], ch_bs_in[QUAN_SIZE*34+bit_index], ch_bs_in[QUAN_SIZE*33+bit_index], ch_bs_in[QUAN_SIZE*32+bit_index], ch_bs_in[QUAN_SIZE*31+bit_index], ch_bs_in[QUAN_SIZE*30+bit_index], ch_bs_in[QUAN_SIZE*29+bit_index], ch_bs_in[QUAN_SIZE*28+bit_index], ch_bs_in[QUAN_SIZE*27+bit_index], ch_bs_in[QUAN_SIZE*26+bit_index], ch_bs_in[QUAN_SIZE*25+bit_index], ch_bs_in[QUAN_SIZE*24+bit_index], ch_bs_in[QUAN_SIZE*23+bit_index], ch_bs_in[QUAN_SIZE*22+bit_index], ch_bs_in[QUAN_SIZE*21+bit_index], ch_bs_in[QUAN_SIZE*20+bit_index], ch_bs_in[QUAN_SIZE*19+bit_index], ch_bs_in[QUAN_SIZE*18+bit_index], ch_bs_in[QUAN_SIZE*17+bit_index], ch_bs_in[QUAN_SIZE*16+bit_index], ch_bs_in[QUAN_SIZE*15+bit_index], ch_bs_in[QUAN_SIZE*14+bit_index], ch_bs_in[QUAN_SIZE*13+bit_index], ch_bs_in[QUAN_SIZE*12+bit_index], ch_bs_in[QUAN_SIZE*11+bit_index], ch_bs_in[QUAN_SIZE*10+bit_index], ch_bs_in[QUAN_SIZE*9+bit_index], ch_bs_in[QUAN_SIZE*8+bit_index], ch_bs_in[QUAN_SIZE*7+bit_index], ch_bs_in[QUAN_SIZE*6+bit_index], ch_bs_in[QUAN_SIZE*5+bit_index], ch_bs_in[QUAN_SIZE*4+bit_index], ch_bs_in[QUAN_SIZE*3+bit_index], ch_bs_in[QUAN_SIZE*2+bit_index],ch_bs_in[QUAN_SIZE*1+bit_index], ch_bs_in[QUAN_SIZE*0+bit_index]};
	end
endgenerate
/*----------------------------------------------*/	
// Circular shifter of check nodes 
qsn_top_85b cnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({cnu_msg_in[84][0],cnu_msg_in[83][0],cnu_msg_in[82][0],cnu_msg_in[81][0],cnu_msg_in[80][0],cnu_msg_in[79][0],cnu_msg_in[78][0],cnu_msg_in[77][0],cnu_msg_in[76][0],cnu_msg_in[75][0],cnu_msg_in[74][0],cnu_msg_in[73][0],cnu_msg_in[72][0],cnu_msg_in[71][0],cnu_msg_in[70][0],cnu_msg_in[69][0],cnu_msg_in[68][0],cnu_msg_in[67][0],cnu_msg_in[66][0],cnu_msg_in[65][0],cnu_msg_in[64][0],cnu_msg_in[63][0],cnu_msg_in[62][0],cnu_msg_in[61][0],cnu_msg_in[60][0],cnu_msg_in[59][0],cnu_msg_in[58][0],cnu_msg_in[57][0],cnu_msg_in[56][0],cnu_msg_in[55][0],cnu_msg_in[54][0],cnu_msg_in[53][0],cnu_msg_in[52][0],cnu_msg_in[51][0],cnu_msg_in[50][0],cnu_msg_in[49][0],cnu_msg_in[48][0],cnu_msg_in[47][0],cnu_msg_in[46][0],cnu_msg_in[45][0],cnu_msg_in[44][0],cnu_msg_in[43][0],cnu_msg_in[42][0],cnu_msg_in[41][0],cnu_msg_in[40][0],cnu_msg_in[39][0],cnu_msg_in[38][0],cnu_msg_in[37][0],cnu_msg_in[36][0],cnu_msg_in[35][0],cnu_msg_in[34][0],cnu_msg_in[33][0],cnu_msg_in[32][0],cnu_msg_in[31][0],cnu_msg_in[30][0],cnu_msg_in[29][0],cnu_msg_in[28][0],cnu_msg_in[27][0],cnu_msg_in[26][0],cnu_msg_in[25][0],cnu_msg_in[24][0],cnu_msg_in[23][0],cnu_msg_in[22][0],cnu_msg_in[21][0],cnu_msg_in[20][0],cnu_msg_in[19][0],cnu_msg_in[18][0],cnu_msg_in[17][0],cnu_msg_in[16][0],cnu_msg_in[15][0],cnu_msg_in[14][0],cnu_msg_in[13][0],cnu_msg_in[12][0],cnu_msg_in[11][0],cnu_msg_in[10][0],cnu_msg_in[9][0],cnu_msg_in[8][0],cnu_msg_in[7][0],cnu_msg_in[6][0],cnu_msg_in[5][0],cnu_msg_in[4][0],cnu_msg_in[3][0],cnu_msg_in[2][0],cnu_msg_in[1][0],cnu_msg_in[0][0]}),
	.sw_out_bit1 ({cnu_msg_in[84][1],cnu_msg_in[83][1],cnu_msg_in[82][1],cnu_msg_in[81][1],cnu_msg_in[80][1],cnu_msg_in[79][1],cnu_msg_in[78][1],cnu_msg_in[77][1],cnu_msg_in[76][1],cnu_msg_in[75][1],cnu_msg_in[74][1],cnu_msg_in[73][1],cnu_msg_in[72][1],cnu_msg_in[71][1],cnu_msg_in[70][1],cnu_msg_in[69][1],cnu_msg_in[68][1],cnu_msg_in[67][1],cnu_msg_in[66][1],cnu_msg_in[65][1],cnu_msg_in[64][1],cnu_msg_in[63][1],cnu_msg_in[62][1],cnu_msg_in[61][1],cnu_msg_in[60][1],cnu_msg_in[59][1],cnu_msg_in[58][1],cnu_msg_in[57][1],cnu_msg_in[56][1],cnu_msg_in[55][1],cnu_msg_in[54][1],cnu_msg_in[53][1],cnu_msg_in[52][1],cnu_msg_in[51][1],cnu_msg_in[50][1],cnu_msg_in[49][1],cnu_msg_in[48][1],cnu_msg_in[47][1],cnu_msg_in[46][1],cnu_msg_in[45][1],cnu_msg_in[44][1],cnu_msg_in[43][1],cnu_msg_in[42][1],cnu_msg_in[41][1],cnu_msg_in[40][1],cnu_msg_in[39][1],cnu_msg_in[38][1],cnu_msg_in[37][1],cnu_msg_in[36][1],cnu_msg_in[35][1],cnu_msg_in[34][1],cnu_msg_in[33][1],cnu_msg_in[32][1],cnu_msg_in[31][1],cnu_msg_in[30][1],cnu_msg_in[29][1],cnu_msg_in[28][1],cnu_msg_in[27][1],cnu_msg_in[26][1],cnu_msg_in[25][1],cnu_msg_in[24][1],cnu_msg_in[23][1],cnu_msg_in[22][1],cnu_msg_in[21][1],cnu_msg_in[20][1],cnu_msg_in[19][1],cnu_msg_in[18][1],cnu_msg_in[17][1],cnu_msg_in[16][1],cnu_msg_in[15][1],cnu_msg_in[14][1],cnu_msg_in[13][1],cnu_msg_in[12][1],cnu_msg_in[11][1],cnu_msg_in[10][1],cnu_msg_in[9][1],cnu_msg_in[8][1],cnu_msg_in[7][1],cnu_msg_in[6][1],cnu_msg_in[5][1],cnu_msg_in[4][1],cnu_msg_in[3][1],cnu_msg_in[2][1],cnu_msg_in[1][1],cnu_msg_in[0][1]}),
	.sw_out_bit2 ({cnu_msg_in[84][2],cnu_msg_in[83][2],cnu_msg_in[82][2],cnu_msg_in[81][2],cnu_msg_in[80][2],cnu_msg_in[79][2],cnu_msg_in[78][2],cnu_msg_in[77][2],cnu_msg_in[76][2],cnu_msg_in[75][2],cnu_msg_in[74][2],cnu_msg_in[73][2],cnu_msg_in[72][2],cnu_msg_in[71][2],cnu_msg_in[70][2],cnu_msg_in[69][2],cnu_msg_in[68][2],cnu_msg_in[67][2],cnu_msg_in[66][2],cnu_msg_in[65][2],cnu_msg_in[64][2],cnu_msg_in[63][2],cnu_msg_in[62][2],cnu_msg_in[61][2],cnu_msg_in[60][2],cnu_msg_in[59][2],cnu_msg_in[58][2],cnu_msg_in[57][2],cnu_msg_in[56][2],cnu_msg_in[55][2],cnu_msg_in[54][2],cnu_msg_in[53][2],cnu_msg_in[52][2],cnu_msg_in[51][2],cnu_msg_in[50][2],cnu_msg_in[49][2],cnu_msg_in[48][2],cnu_msg_in[47][2],cnu_msg_in[46][2],cnu_msg_in[45][2],cnu_msg_in[44][2],cnu_msg_in[43][2],cnu_msg_in[42][2],cnu_msg_in[41][2],cnu_msg_in[40][2],cnu_msg_in[39][2],cnu_msg_in[38][2],cnu_msg_in[37][2],cnu_msg_in[36][2],cnu_msg_in[35][2],cnu_msg_in[34][2],cnu_msg_in[33][2],cnu_msg_in[32][2],cnu_msg_in[31][2],cnu_msg_in[30][2],cnu_msg_in[29][2],cnu_msg_in[28][2],cnu_msg_in[27][2],cnu_msg_in[26][2],cnu_msg_in[25][2],cnu_msg_in[24][2],cnu_msg_in[23][2],cnu_msg_in[22][2],cnu_msg_in[21][2],cnu_msg_in[20][2],cnu_msg_in[19][2],cnu_msg_in[18][2],cnu_msg_in[17][2],cnu_msg_in[16][2],cnu_msg_in[15][2],cnu_msg_in[14][2],cnu_msg_in[13][2],cnu_msg_in[12][2],cnu_msg_in[11][2],cnu_msg_in[10][2],cnu_msg_in[9][2],cnu_msg_in[8][2],cnu_msg_in[7][2],cnu_msg_in[6][2],cnu_msg_in[5][2],cnu_msg_in[4][2],cnu_msg_in[3][2],cnu_msg_in[2][2],cnu_msg_in[1][2],cnu_msg_in[0][2]}),	
	.sw_out_bit3 ({cnu_msg_in[84][3],cnu_msg_in[83][3],cnu_msg_in[82][3],cnu_msg_in[81][3],cnu_msg_in[80][3],cnu_msg_in[79][3],cnu_msg_in[78][3],cnu_msg_in[77][3],cnu_msg_in[76][3],cnu_msg_in[75][3],cnu_msg_in[74][3],cnu_msg_in[73][3],cnu_msg_in[72][3],cnu_msg_in[71][3],cnu_msg_in[70][3],cnu_msg_in[69][3],cnu_msg_in[68][3],cnu_msg_in[67][3],cnu_msg_in[66][3],cnu_msg_in[65][3],cnu_msg_in[64][3],cnu_msg_in[63][3],cnu_msg_in[62][3],cnu_msg_in[61][3],cnu_msg_in[60][3],cnu_msg_in[59][3],cnu_msg_in[58][3],cnu_msg_in[57][3],cnu_msg_in[56][3],cnu_msg_in[55][3],cnu_msg_in[54][3],cnu_msg_in[53][3],cnu_msg_in[52][3],cnu_msg_in[51][3],cnu_msg_in[50][3],cnu_msg_in[49][3],cnu_msg_in[48][3],cnu_msg_in[47][3],cnu_msg_in[46][3],cnu_msg_in[45][3],cnu_msg_in[44][3],cnu_msg_in[43][3],cnu_msg_in[42][3],cnu_msg_in[41][3],cnu_msg_in[40][3],cnu_msg_in[39][3],cnu_msg_in[38][3],cnu_msg_in[37][3],cnu_msg_in[36][3],cnu_msg_in[35][3],cnu_msg_in[34][3],cnu_msg_in[33][3],cnu_msg_in[32][3],cnu_msg_in[31][3],cnu_msg_in[30][3],cnu_msg_in[29][3],cnu_msg_in[28][3],cnu_msg_in[27][3],cnu_msg_in[26][3],cnu_msg_in[25][3],cnu_msg_in[24][3],cnu_msg_in[23][3],cnu_msg_in[22][3],cnu_msg_in[21][3],cnu_msg_in[20][3],cnu_msg_in[19][3],cnu_msg_in[18][3],cnu_msg_in[17][3],cnu_msg_in[16][3],cnu_msg_in[15][3],cnu_msg_in[14][3],cnu_msg_in[13][3],cnu_msg_in[12][3],cnu_msg_in[11][3],cnu_msg_in[10][3],cnu_msg_in[9][3],cnu_msg_in[8][3],cnu_msg_in[7][3],cnu_msg_in[6][3],cnu_msg_in[5][3],cnu_msg_in[4][3],cnu_msg_in[3][3],cnu_msg_in[2][3],cnu_msg_in[1][3],cnu_msg_in[0][3]}),
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in_bit0  (cnu_bs_in_bit[0]),
	.sw_in_bit1  (cnu_bs_in_bit[1]),
	.sw_in_bit2  (cnu_bs_in_bit[2]),
	.sw_in_bit3  (cnu_bs_in_bit[3]),
	.left_sel    (cnu_left_sel),
	.right_sel   (cnu_right_sel),
	.merge_sel   (cnu_merge_sel)
);
qsn_controller_85b #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) cnu_qsn_controller_85b (
	.left_sel     (cnu_left_sel ),
	.right_sel    (cnu_right_sel),
	.merge_sel    (cnu_merge_sel),
	.shift_factor (c2v_shift_factor_cur_0), // offset shift factor of submatrix_1
	.rstn         (rstn),
	.sys_clk      (read_clk)
);
/*----------------------------------------------*/
// Circular shifter of variable nodes 
wire [BITWIDTH_SHIFT_FACTOR-1:0] vnu_shift_factorIn;
wire [BITWIDTH_SHIFT_FACTOR-1:0] dnu_inRotate_shift_factor; // a constant, because only needed at last layer
shared_qsn_top_85b #(
		.QUAN_SIZE(QUAN_SIZE),
		.CHECK_PARALLELISM(CHECK_PARALLELISM),
		.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR)
) inst_shared_qsn_top_85b (
	.sw_out_bit0 ({vnu_msg_in[84][0],vnu_msg_in[83][0],vnu_msg_in[82][0],vnu_msg_in[81][0],vnu_msg_in[80][0],vnu_msg_in[79][0],vnu_msg_in[78][0],vnu_msg_in[77][0],vnu_msg_in[76][0],vnu_msg_in[75][0],vnu_msg_in[74][0],vnu_msg_in[73][0],vnu_msg_in[72][0],vnu_msg_in[71][0],vnu_msg_in[70][0],vnu_msg_in[69][0],vnu_msg_in[68][0],vnu_msg_in[67][0],vnu_msg_in[66][0],vnu_msg_in[65][0],vnu_msg_in[64][0],vnu_msg_in[63][0],vnu_msg_in[62][0],vnu_msg_in[61][0],vnu_msg_in[60][0],vnu_msg_in[59][0],vnu_msg_in[58][0],vnu_msg_in[57][0],vnu_msg_in[56][0],vnu_msg_in[55][0],vnu_msg_in[54][0],vnu_msg_in[53][0],vnu_msg_in[52][0],vnu_msg_in[51][0],vnu_msg_in[50][0],vnu_msg_in[49][0],vnu_msg_in[48][0],vnu_msg_in[47][0],vnu_msg_in[46][0],vnu_msg_in[45][0],vnu_msg_in[44][0],vnu_msg_in[43][0],vnu_msg_in[42][0],vnu_msg_in[41][0],vnu_msg_in[40][0],vnu_msg_in[39][0],vnu_msg_in[38][0],vnu_msg_in[37][0],vnu_msg_in[36][0],vnu_msg_in[35][0],vnu_msg_in[34][0],vnu_msg_in[33][0],vnu_msg_in[32][0],vnu_msg_in[31][0],vnu_msg_in[30][0],vnu_msg_in[29][0],vnu_msg_in[28][0],vnu_msg_in[27][0],vnu_msg_in[26][0],vnu_msg_in[25][0],vnu_msg_in[24][0],vnu_msg_in[23][0],vnu_msg_in[22][0],vnu_msg_in[21][0],vnu_msg_in[20][0],vnu_msg_in[19][0],vnu_msg_in[18][0],vnu_msg_in[17][0],vnu_msg_in[16][0],vnu_msg_in[15][0],vnu_msg_in[14][0],vnu_msg_in[13][0],vnu_msg_in[12][0],vnu_msg_in[11][0],vnu_msg_in[10][0],vnu_msg_in[9][0],vnu_msg_in[8][0],vnu_msg_in[7][0],vnu_msg_in[6][0],vnu_msg_in[5][0],vnu_msg_in[4][0],vnu_msg_in[3][0],vnu_msg_in[2][0],vnu_msg_in[1][0],vnu_msg_in[0][0]}),	
	.sw_out_bit1 ({vnu_msg_in[84][1],vnu_msg_in[83][1],vnu_msg_in[82][1],vnu_msg_in[81][1],vnu_msg_in[80][1],vnu_msg_in[79][1],vnu_msg_in[78][1],vnu_msg_in[77][1],vnu_msg_in[76][1],vnu_msg_in[75][1],vnu_msg_in[74][1],vnu_msg_in[73][1],vnu_msg_in[72][1],vnu_msg_in[71][1],vnu_msg_in[70][1],vnu_msg_in[69][1],vnu_msg_in[68][1],vnu_msg_in[67][1],vnu_msg_in[66][1],vnu_msg_in[65][1],vnu_msg_in[64][1],vnu_msg_in[63][1],vnu_msg_in[62][1],vnu_msg_in[61][1],vnu_msg_in[60][1],vnu_msg_in[59][1],vnu_msg_in[58][1],vnu_msg_in[57][1],vnu_msg_in[56][1],vnu_msg_in[55][1],vnu_msg_in[54][1],vnu_msg_in[53][1],vnu_msg_in[52][1],vnu_msg_in[51][1],vnu_msg_in[50][1],vnu_msg_in[49][1],vnu_msg_in[48][1],vnu_msg_in[47][1],vnu_msg_in[46][1],vnu_msg_in[45][1],vnu_msg_in[44][1],vnu_msg_in[43][1],vnu_msg_in[42][1],vnu_msg_in[41][1],vnu_msg_in[40][1],vnu_msg_in[39][1],vnu_msg_in[38][1],vnu_msg_in[37][1],vnu_msg_in[36][1],vnu_msg_in[35][1],vnu_msg_in[34][1],vnu_msg_in[33][1],vnu_msg_in[32][1],vnu_msg_in[31][1],vnu_msg_in[30][1],vnu_msg_in[29][1],vnu_msg_in[28][1],vnu_msg_in[27][1],vnu_msg_in[26][1],vnu_msg_in[25][1],vnu_msg_in[24][1],vnu_msg_in[23][1],vnu_msg_in[22][1],vnu_msg_in[21][1],vnu_msg_in[20][1],vnu_msg_in[19][1],vnu_msg_in[18][1],vnu_msg_in[17][1],vnu_msg_in[16][1],vnu_msg_in[15][1],vnu_msg_in[14][1],vnu_msg_in[13][1],vnu_msg_in[12][1],vnu_msg_in[11][1],vnu_msg_in[10][1],vnu_msg_in[9][1],vnu_msg_in[8][1],vnu_msg_in[7][1],vnu_msg_in[6][1],vnu_msg_in[5][1],vnu_msg_in[4][1],vnu_msg_in[3][1],vnu_msg_in[2][1],vnu_msg_in[1][1],vnu_msg_in[0][1]}),	
	.sw_out_bit2 ({vnu_msg_in[84][2],vnu_msg_in[83][2],vnu_msg_in[82][2],vnu_msg_in[81][2],vnu_msg_in[80][2],vnu_msg_in[79][2],vnu_msg_in[78][2],vnu_msg_in[77][2],vnu_msg_in[76][2],vnu_msg_in[75][2],vnu_msg_in[74][2],vnu_msg_in[73][2],vnu_msg_in[72][2],vnu_msg_in[71][2],vnu_msg_in[70][2],vnu_msg_in[69][2],vnu_msg_in[68][2],vnu_msg_in[67][2],vnu_msg_in[66][2],vnu_msg_in[65][2],vnu_msg_in[64][2],vnu_msg_in[63][2],vnu_msg_in[62][2],vnu_msg_in[61][2],vnu_msg_in[60][2],vnu_msg_in[59][2],vnu_msg_in[58][2],vnu_msg_in[57][2],vnu_msg_in[56][2],vnu_msg_in[55][2],vnu_msg_in[54][2],vnu_msg_in[53][2],vnu_msg_in[52][2],vnu_msg_in[51][2],vnu_msg_in[50][2],vnu_msg_in[49][2],vnu_msg_in[48][2],vnu_msg_in[47][2],vnu_msg_in[46][2],vnu_msg_in[45][2],vnu_msg_in[44][2],vnu_msg_in[43][2],vnu_msg_in[42][2],vnu_msg_in[41][2],vnu_msg_in[40][2],vnu_msg_in[39][2],vnu_msg_in[38][2],vnu_msg_in[37][2],vnu_msg_in[36][2],vnu_msg_in[35][2],vnu_msg_in[34][2],vnu_msg_in[33][2],vnu_msg_in[32][2],vnu_msg_in[31][2],vnu_msg_in[30][2],vnu_msg_in[29][2],vnu_msg_in[28][2],vnu_msg_in[27][2],vnu_msg_in[26][2],vnu_msg_in[25][2],vnu_msg_in[24][2],vnu_msg_in[23][2],vnu_msg_in[22][2],vnu_msg_in[21][2],vnu_msg_in[20][2],vnu_msg_in[19][2],vnu_msg_in[18][2],vnu_msg_in[17][2],vnu_msg_in[16][2],vnu_msg_in[15][2],vnu_msg_in[14][2],vnu_msg_in[13][2],vnu_msg_in[12][2],vnu_msg_in[11][2],vnu_msg_in[10][2],vnu_msg_in[9][2],vnu_msg_in[8][2],vnu_msg_in[7][2],vnu_msg_in[6][2],vnu_msg_in[5][2],vnu_msg_in[4][2],vnu_msg_in[3][2],vnu_msg_in[2][2],vnu_msg_in[1][2],vnu_msg_in[0][2]}),	
	.sw_out_bit3 ({vnu_msg_in[84][3],vnu_msg_in[83][3],vnu_msg_in[82][3],vnu_msg_in[81][3],vnu_msg_in[80][3],vnu_msg_in[79][3],vnu_msg_in[78][3],vnu_msg_in[77][3],vnu_msg_in[76][3],vnu_msg_in[75][3],vnu_msg_in[74][3],vnu_msg_in[73][3],vnu_msg_in[72][3],vnu_msg_in[71][3],vnu_msg_in[70][3],vnu_msg_in[69][3],vnu_msg_in[68][3],vnu_msg_in[67][3],vnu_msg_in[66][3],vnu_msg_in[65][3],vnu_msg_in[64][3],vnu_msg_in[63][3],vnu_msg_in[62][3],vnu_msg_in[61][3],vnu_msg_in[60][3],vnu_msg_in[59][3],vnu_msg_in[58][3],vnu_msg_in[57][3],vnu_msg_in[56][3],vnu_msg_in[55][3],vnu_msg_in[54][3],vnu_msg_in[53][3],vnu_msg_in[52][3],vnu_msg_in[51][3],vnu_msg_in[50][3],vnu_msg_in[49][3],vnu_msg_in[48][3],vnu_msg_in[47][3],vnu_msg_in[46][3],vnu_msg_in[45][3],vnu_msg_in[44][3],vnu_msg_in[43][3],vnu_msg_in[42][3],vnu_msg_in[41][3],vnu_msg_in[40][3],vnu_msg_in[39][3],vnu_msg_in[38][3],vnu_msg_in[37][3],vnu_msg_in[36][3],vnu_msg_in[35][3],vnu_msg_in[34][3],vnu_msg_in[33][3],vnu_msg_in[32][3],vnu_msg_in[31][3],vnu_msg_in[30][3],vnu_msg_in[29][3],vnu_msg_in[28][3],vnu_msg_in[27][3],vnu_msg_in[26][3],vnu_msg_in[25][3],vnu_msg_in[24][3],vnu_msg_in[23][3],vnu_msg_in[22][3],vnu_msg_in[21][3],vnu_msg_in[20][3],vnu_msg_in[19][3],vnu_msg_in[18][3],vnu_msg_in[17][3],vnu_msg_in[16][3],vnu_msg_in[15][3],vnu_msg_in[14][3],vnu_msg_in[13][3],vnu_msg_in[12][3],vnu_msg_in[11][3],vnu_msg_in[10][3],vnu_msg_in[9][3],vnu_msg_in[8][3],vnu_msg_in[7][3],vnu_msg_in[6][3],vnu_msg_in[5][3],vnu_msg_in[4][3],vnu_msg_in[3][3],vnu_msg_in[2][3],vnu_msg_in[1][3],vnu_msg_in[0][3]}),	
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in0_bit0  (vnu_bs_in_bit[0]),
	.sw_in0_bit1  (vnu_bs_in_bit[1]),
	.sw_in0_bit2  (vnu_bs_in_bit[2]),
	.sw_in0_bit3  (vnu_bs_in_bit[3]),

	.sw_in1_bit0 (ch_bs_in_bit[0]),
	.sw_in1_bit1 (ch_bs_in_bit[1]),
	.sw_in1_bit2 (ch_bs_in_bit[2]),
	.sw_in1_bit3 (ch_bs_in_bit[3]),

	.sw_in2_bit0 (dnu_inRotate_bit),

	.shift_factor (vnu_shift_factorIn), // offset shift factor of submatrix
	.sw_in_bit0_src (vnu_bs_bit0_src),
	.sw_in_src (vnu_bs_src)
);
assign vnu_shift_factorIn = (vnu_bs_bit0_src[0] == 1'b1) ? v2c_shift_factor_cur_0 :
							(vnu_bs_bit0_src[1] == 1'b1) ? ch_ramRD_shift_factor_cur_0 :
							(vnu_bs_bit0_src[2] == 1'b1) ? dnu_inRotate_shift_factor : v2c_shift_factor_cur_0;
/*----------------------------------------------*/	
	reg [ADDR_WIDTH-1:0] c2v_mem_page_addr;
	reg [ADDR_WIDTH-1:0] v2c_mem_page_addr;
	mem_subsystem_top_submatrix_8 #(
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
		) inst_mem_subsystem_top_submatrix_8 (
			.mem_to_vnu_0     (mem_to_vnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_vnu_1     (mem_to_vnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_vnu_2     (mem_to_vnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_vnu_3     (mem_to_vnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_vnu_4     (mem_to_vnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_vnu_5     (mem_to_vnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_vnu_6     (mem_to_vnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_vnu_7     (mem_to_vnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_vnu_8     (mem_to_vnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_vnu_9     (mem_to_vnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_vnu_10    (mem_to_vnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_vnu_11    (mem_to_vnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_vnu_12    (mem_to_vnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_vnu_13    (mem_to_vnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_vnu_14    (mem_to_vnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_vnu_15    (mem_to_vnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_vnu_16    (mem_to_vnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_vnu_17    (mem_to_vnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_vnu_18    (mem_to_vnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_vnu_19    (mem_to_vnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_vnu_20    (mem_to_vnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_vnu_21    (mem_to_vnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_vnu_22    (mem_to_vnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_vnu_23    (mem_to_vnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_vnu_24    (mem_to_vnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_vnu_25    (mem_to_vnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_vnu_26    (mem_to_vnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_vnu_27    (mem_to_vnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_vnu_28    (mem_to_vnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_vnu_29    (mem_to_vnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_vnu_30    (mem_to_vnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_vnu_31    (mem_to_vnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_vnu_32    (mem_to_vnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_vnu_33    (mem_to_vnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_vnu_34    (mem_to_vnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_vnu_35    (mem_to_vnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_vnu_36    (mem_to_vnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_vnu_37    (mem_to_vnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_vnu_38    (mem_to_vnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_vnu_39    (mem_to_vnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_vnu_40    (mem_to_vnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_vnu_41    (mem_to_vnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_vnu_42    (mem_to_vnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_vnu_43    (mem_to_vnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_vnu_44    (mem_to_vnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_vnu_45    (mem_to_vnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_vnu_46    (mem_to_vnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_vnu_47    (mem_to_vnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_vnu_48    (mem_to_vnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_vnu_49    (mem_to_vnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_vnu_50    (mem_to_vnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_vnu_51    (mem_to_vnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_vnu_52    (mem_to_vnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_vnu_53    (mem_to_vnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_vnu_54    (mem_to_vnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_vnu_55    (mem_to_vnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_vnu_56    (mem_to_vnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_vnu_57    (mem_to_vnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_vnu_58    (mem_to_vnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_vnu_59    (mem_to_vnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_vnu_60    (mem_to_vnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_vnu_61    (mem_to_vnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_vnu_62    (mem_to_vnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_vnu_63    (mem_to_vnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_vnu_64    (mem_to_vnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_vnu_65    (mem_to_vnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_vnu_66    (mem_to_vnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_vnu_67    (mem_to_vnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_vnu_68    (mem_to_vnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_vnu_69    (mem_to_vnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_vnu_70    (mem_to_vnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_vnu_71    (mem_to_vnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_vnu_72    (mem_to_vnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_vnu_73    (mem_to_vnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_vnu_74    (mem_to_vnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_vnu_75    (mem_to_vnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_vnu_76    (mem_to_vnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_vnu_77    (mem_to_vnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_vnu_78    (mem_to_vnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_vnu_79    (mem_to_vnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_vnu_80    (mem_to_vnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_vnu_81    (mem_to_vnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_vnu_82    (mem_to_vnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_vnu_83    (mem_to_vnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_vnu_84    (mem_to_vnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),
			.mem_to_cnu_0     (mem_to_cnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_cnu_1     (mem_to_cnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_cnu_2     (mem_to_cnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_cnu_3     (mem_to_cnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_cnu_4     (mem_to_cnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_cnu_5     (mem_to_cnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_cnu_6     (mem_to_cnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_cnu_7     (mem_to_cnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_cnu_8     (mem_to_cnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_cnu_9     (mem_to_cnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_cnu_10    (mem_to_cnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_cnu_11    (mem_to_cnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_cnu_12    (mem_to_cnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_cnu_13    (mem_to_cnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_cnu_14    (mem_to_cnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_cnu_15    (mem_to_cnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_cnu_16    (mem_to_cnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_cnu_17    (mem_to_cnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_cnu_18    (mem_to_cnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_cnu_19    (mem_to_cnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_cnu_20    (mem_to_cnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_cnu_21    (mem_to_cnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_cnu_22    (mem_to_cnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_cnu_23    (mem_to_cnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_cnu_24    (mem_to_cnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_cnu_25    (mem_to_cnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_cnu_26    (mem_to_cnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_cnu_27    (mem_to_cnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_cnu_28    (mem_to_cnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_cnu_29    (mem_to_cnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_cnu_30    (mem_to_cnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_cnu_31    (mem_to_cnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_cnu_32    (mem_to_cnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_cnu_33    (mem_to_cnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_cnu_34    (mem_to_cnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_cnu_35    (mem_to_cnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_cnu_36    (mem_to_cnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_cnu_37    (mem_to_cnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_cnu_38    (mem_to_cnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_cnu_39    (mem_to_cnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_cnu_40    (mem_to_cnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_cnu_41    (mem_to_cnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_cnu_42    (mem_to_cnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_cnu_43    (mem_to_cnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_cnu_44    (mem_to_cnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_cnu_45    (mem_to_cnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_cnu_46    (mem_to_cnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_cnu_47    (mem_to_cnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_cnu_48    (mem_to_cnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_cnu_49    (mem_to_cnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_cnu_50    (mem_to_cnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_cnu_51    (mem_to_cnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_cnu_52    (mem_to_cnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_cnu_53    (mem_to_cnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_cnu_54    (mem_to_cnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_cnu_55    (mem_to_cnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_cnu_56    (mem_to_cnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_cnu_57    (mem_to_cnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_cnu_58    (mem_to_cnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_cnu_59    (mem_to_cnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_cnu_60    (mem_to_cnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_cnu_61    (mem_to_cnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_cnu_62    (mem_to_cnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_cnu_63    (mem_to_cnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_cnu_64    (mem_to_cnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_cnu_65    (mem_to_cnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_cnu_66    (mem_to_cnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_cnu_67    (mem_to_cnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_cnu_68    (mem_to_cnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_cnu_69    (mem_to_cnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_cnu_70    (mem_to_cnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_cnu_71    (mem_to_cnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_cnu_72    (mem_to_cnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_cnu_73    (mem_to_cnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_cnu_74    (mem_to_cnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_cnu_75    (mem_to_cnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_cnu_76    (mem_to_cnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_cnu_77    (mem_to_cnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_cnu_78    (mem_to_cnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_cnu_79    (mem_to_cnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_cnu_80    (mem_to_cnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_cnu_81    (mem_to_cnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_cnu_82    (mem_to_cnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_cnu_83    (mem_to_cnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_cnu_84    (mem_to_cnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),

			.vnu_to_mem_0     (vnu_msg_in[0 ]),
			.vnu_to_mem_1     (vnu_msg_in[1 ]),
			.vnu_to_mem_2     (vnu_msg_in[2 ]),
			.vnu_to_mem_3     (vnu_msg_in[3 ]),
			.vnu_to_mem_4     (vnu_msg_in[4 ]),
			.vnu_to_mem_5     (vnu_msg_in[5 ]),
			.vnu_to_mem_6     (vnu_msg_in[6 ]),
			.vnu_to_mem_7     (vnu_msg_in[7 ]),
			.vnu_to_mem_8     (vnu_msg_in[8 ]),
			.vnu_to_mem_9     (vnu_msg_in[9 ]),
			.vnu_to_mem_10    (vnu_msg_in[10]),
			.vnu_to_mem_11    (vnu_msg_in[11]),
			.vnu_to_mem_12    (vnu_msg_in[12]),
			.vnu_to_mem_13    (vnu_msg_in[13]),
			.vnu_to_mem_14    (vnu_msg_in[14]),
			.vnu_to_mem_15    (vnu_msg_in[15]),
			.vnu_to_mem_16    (vnu_msg_in[16]),
			.vnu_to_mem_17    (vnu_msg_in[17]),
			.vnu_to_mem_18    (vnu_msg_in[18]),
			.vnu_to_mem_19    (vnu_msg_in[19]),
			.vnu_to_mem_20    (vnu_msg_in[20]),
			.vnu_to_mem_21    (vnu_msg_in[21]),
			.vnu_to_mem_22    (vnu_msg_in[22]),
			.vnu_to_mem_23    (vnu_msg_in[23]),
			.vnu_to_mem_24    (vnu_msg_in[24]),
			.vnu_to_mem_25    (vnu_msg_in[25]),
			.vnu_to_mem_26    (vnu_msg_in[26]),
			.vnu_to_mem_27    (vnu_msg_in[27]),
			.vnu_to_mem_28    (vnu_msg_in[28]),
			.vnu_to_mem_29    (vnu_msg_in[29]),
			.vnu_to_mem_30    (vnu_msg_in[30]),
			.vnu_to_mem_31    (vnu_msg_in[31]),
			.vnu_to_mem_32    (vnu_msg_in[32]),
			.vnu_to_mem_33    (vnu_msg_in[33]),
			.vnu_to_mem_34    (vnu_msg_in[34]),
			.vnu_to_mem_35    (vnu_msg_in[35]),
			.vnu_to_mem_36    (vnu_msg_in[36]),
			.vnu_to_mem_37    (vnu_msg_in[37]),
			.vnu_to_mem_38    (vnu_msg_in[38]),
			.vnu_to_mem_39    (vnu_msg_in[39]),
			.vnu_to_mem_40    (vnu_msg_in[40]),
			.vnu_to_mem_41    (vnu_msg_in[41]),
			.vnu_to_mem_42    (vnu_msg_in[42]),
			.vnu_to_mem_43    (vnu_msg_in[43]),
			.vnu_to_mem_44    (vnu_msg_in[44]),
			.vnu_to_mem_45    (vnu_msg_in[45]),
			.vnu_to_mem_46    (vnu_msg_in[46]),
			.vnu_to_mem_47    (vnu_msg_in[47]),
			.vnu_to_mem_48    (vnu_msg_in[48]),
			.vnu_to_mem_49    (vnu_msg_in[49]),
			.vnu_to_mem_50    (vnu_msg_in[50]),
			.vnu_to_mem_51    (vnu_msg_in[51]),
			.vnu_to_mem_52    (vnu_msg_in[52]),
			.vnu_to_mem_53    (vnu_msg_in[53]),
			.vnu_to_mem_54    (vnu_msg_in[54]),
			.vnu_to_mem_55    (vnu_msg_in[55]),
			.vnu_to_mem_56    (vnu_msg_in[56]),
			.vnu_to_mem_57    (vnu_msg_in[57]),
			.vnu_to_mem_58    (vnu_msg_in[58]),
			.vnu_to_mem_59    (vnu_msg_in[59]),
			.vnu_to_mem_60    (vnu_msg_in[60]),
			.vnu_to_mem_61    (vnu_msg_in[61]),
			.vnu_to_mem_62    (vnu_msg_in[62]),
			.vnu_to_mem_63    (vnu_msg_in[63]),
			.vnu_to_mem_64    (vnu_msg_in[64]),
			.vnu_to_mem_65    (vnu_msg_in[65]),
			.vnu_to_mem_66    (vnu_msg_in[66]),
			.vnu_to_mem_67    (vnu_msg_in[67]),
			.vnu_to_mem_68    (vnu_msg_in[68]),
			.vnu_to_mem_69    (vnu_msg_in[69]),
			.vnu_to_mem_70    (vnu_msg_in[70]),
			.vnu_to_mem_71    (vnu_msg_in[71]),
			.vnu_to_mem_72    (vnu_msg_in[72]),
			.vnu_to_mem_73    (vnu_msg_in[73]),
			.vnu_to_mem_74    (vnu_msg_in[74]),
			.vnu_to_mem_75    (vnu_msg_in[75]),
			.vnu_to_mem_76    (vnu_msg_in[76]),
			.vnu_to_mem_77    (vnu_msg_in[77]),
			.vnu_to_mem_78    (vnu_msg_in[78]),
			.vnu_to_mem_79    (vnu_msg_in[79]),
			.vnu_to_mem_80    (vnu_msg_in[80]),
			.vnu_to_mem_81    (vnu_msg_in[81]),
			.vnu_to_mem_82    (vnu_msg_in[82]),
			.vnu_to_mem_83    (vnu_msg_in[83]),
			.vnu_to_mem_84    (vnu_msg_in[84]),
			.cnu_to_mem_0     (cnu_msg_in[0 ]),
			.cnu_to_mem_1     (cnu_msg_in[1 ]),
			.cnu_to_mem_2     (cnu_msg_in[2 ]),
			.cnu_to_mem_3     (cnu_msg_in[3 ]),
			.cnu_to_mem_4     (cnu_msg_in[4 ]),
			.cnu_to_mem_5     (cnu_msg_in[5 ]),
			.cnu_to_mem_6     (cnu_msg_in[6 ]),
			.cnu_to_mem_7     (cnu_msg_in[7 ]),
			.cnu_to_mem_8     (cnu_msg_in[8 ]),
			.cnu_to_mem_9     (cnu_msg_in[9 ]),
			.cnu_to_mem_10    (cnu_msg_in[10]),
			.cnu_to_mem_11    (cnu_msg_in[11]),
			.cnu_to_mem_12    (cnu_msg_in[12]),
			.cnu_to_mem_13    (cnu_msg_in[13]),
			.cnu_to_mem_14    (cnu_msg_in[14]),
			.cnu_to_mem_15    (cnu_msg_in[15]),
			.cnu_to_mem_16    (cnu_msg_in[16]),
			.cnu_to_mem_17    (cnu_msg_in[17]),
			.cnu_to_mem_18    (cnu_msg_in[18]),
			.cnu_to_mem_19    (cnu_msg_in[19]),
			.cnu_to_mem_20    (cnu_msg_in[20]),
			.cnu_to_mem_21    (cnu_msg_in[21]),
			.cnu_to_mem_22    (cnu_msg_in[22]),
			.cnu_to_mem_23    (cnu_msg_in[23]),
			.cnu_to_mem_24    (cnu_msg_in[24]),
			.cnu_to_mem_25    (cnu_msg_in[25]),
			.cnu_to_mem_26    (cnu_msg_in[26]),
			.cnu_to_mem_27    (cnu_msg_in[27]),
			.cnu_to_mem_28    (cnu_msg_in[28]),
			.cnu_to_mem_29    (cnu_msg_in[29]),
			.cnu_to_mem_30    (cnu_msg_in[30]),
			.cnu_to_mem_31    (cnu_msg_in[31]),
			.cnu_to_mem_32    (cnu_msg_in[32]),
			.cnu_to_mem_33    (cnu_msg_in[33]),
			.cnu_to_mem_34    (cnu_msg_in[34]),
			.cnu_to_mem_35    (cnu_msg_in[35]),
			.cnu_to_mem_36    (cnu_msg_in[36]),
			.cnu_to_mem_37    (cnu_msg_in[37]),
			.cnu_to_mem_38    (cnu_msg_in[38]),
			.cnu_to_mem_39    (cnu_msg_in[39]),
			.cnu_to_mem_40    (cnu_msg_in[40]),
			.cnu_to_mem_41    (cnu_msg_in[41]),
			.cnu_to_mem_42    (cnu_msg_in[42]),
			.cnu_to_mem_43    (cnu_msg_in[43]),
			.cnu_to_mem_44    (cnu_msg_in[44]),
			.cnu_to_mem_45    (cnu_msg_in[45]),
			.cnu_to_mem_46    (cnu_msg_in[46]),
			.cnu_to_mem_47    (cnu_msg_in[47]),
			.cnu_to_mem_48    (cnu_msg_in[48]),
			.cnu_to_mem_49    (cnu_msg_in[49]),
			.cnu_to_mem_50    (cnu_msg_in[50]),
			.cnu_to_mem_51    (cnu_msg_in[51]),
			.cnu_to_mem_52    (cnu_msg_in[52]),
			.cnu_to_mem_53    (cnu_msg_in[53]),
			.cnu_to_mem_54    (cnu_msg_in[54]),
			.cnu_to_mem_55    (cnu_msg_in[55]),
			.cnu_to_mem_56    (cnu_msg_in[56]),
			.cnu_to_mem_57    (cnu_msg_in[57]),
			.cnu_to_mem_58    (cnu_msg_in[58]),
			.cnu_to_mem_59    (cnu_msg_in[59]),
			.cnu_to_mem_60    (cnu_msg_in[60]),
			.cnu_to_mem_61    (cnu_msg_in[61]),
			.cnu_to_mem_62    (cnu_msg_in[62]),
			.cnu_to_mem_63    (cnu_msg_in[63]),
			.cnu_to_mem_64    (cnu_msg_in[64]),
			.cnu_to_mem_65    (cnu_msg_in[65]),
			.cnu_to_mem_66    (cnu_msg_in[66]),
			.cnu_to_mem_67    (cnu_msg_in[67]),
			.cnu_to_mem_68    (cnu_msg_in[68]),
			.cnu_to_mem_69    (cnu_msg_in[69]),
			.cnu_to_mem_70    (cnu_msg_in[70]),
			.cnu_to_mem_71    (cnu_msg_in[71]),
			.cnu_to_mem_72    (cnu_msg_in[72]),
			.cnu_to_mem_73    (cnu_msg_in[73]),
			.cnu_to_mem_74    (cnu_msg_in[74]),
			.cnu_to_mem_75    (cnu_msg_in[75]),
			.cnu_to_mem_76    (cnu_msg_in[76]),
			.cnu_to_mem_77    (cnu_msg_in[77]),
			.cnu_to_mem_78    (cnu_msg_in[78]),
			.cnu_to_mem_79    (cnu_msg_in[79]),
			.cnu_to_mem_80    (cnu_msg_in[80]),
			.cnu_to_mem_81    (cnu_msg_in[81]),
			.cnu_to_mem_82    (cnu_msg_in[82]),
			.cnu_to_mem_83    (cnu_msg_in[83]),
			.cnu_to_mem_84    (cnu_msg_in[84]),
			.cnu_sync_addr    (cnu_mem_page_sync_addr),
			.vnu_sync_addr    (vnu_mem_page_sync_addr),
			.cnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.vnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.last_row_chunk   ({c2v_last_row_chunk, v2c_last_row_chunk}),
			.we               ({v2c_mem_we, c2v_mem_we}),
			.sys_clk          (read_clk),
			.rstn             (rstn)
		);
		assign cnu_mem_page_sync_addr = (v2c_mem_fetch == 1'b1) ? v2c_mem_page_rd_addr : 
										(c2v_mem_we == 1'b1) ? c2v_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.

		assign vnu_mem_page_sync_addr = (c2v_mem_fetch == 1'b1) ? c2v_mem_page_rd_addr : 
										(v2c_mem_we == 1'b1) ? v2c_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Check-to-Variable messages RAMs write-page addresses
	always @(posedge read_clk) begin
		if(rstn == 1'b0) 
			c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE;
		else if(c2v_mem_we == 1'b1) begin
			// page increment pattern within layer 0
			if(v2c_layer_cnt[0] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_1+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 1
			if(v2c_layer_cnt[1] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_2+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 2
			if(v2c_layer_cnt[2] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_2-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
		end
	end

	always @(posedge read_clk) begin
		if(rstn == 1'b0) begin
			c2v_shift_factor_cur_2 <= shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
		end
		else if(c2v_bs_en == 1'b1) begin
			c2v_shift_factor_cur_2 <= 0;
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
/*--------------------------------------------------------------------------*/
// Channel Buffers
reg [CH_DATA_WIDTH-1:0] ch_msg_genIn;
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_0 [0:CHECK_PARALLELISM-1]; // [0:84]
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_1 [0:CHECK_PARALLELISM-1]; // [0:84]
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_rd_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chInit_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chLayer_wr_addr;
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

			.din        (ch_msg_genIn[CH_DATA_WIDTH-1:0]),

			.read_addr  (submatrix_ch_ram_rd_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.write_addr (submatrix_ch_ram_wr_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.we         (ch_ram_we),
			.read_clk   (ch_ram_rd_clk),
			.write_clk  (ch_ram_wr_clk),
			.rstn       (rstn)
		);
		// Updating the Channel RAMs by either initally channel messages (from AWGNs) or circularly shifted channel messages
		assign submatrix_ch_ram_wr_addr = (ch_ram_init_we == 1'b1) ? submatrix_chInit_wr_addr :
														(ch_ram_wb == 1'b1     ) ? submatrix_chLayer_wr_addr : 
																				   CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.


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
	// Channel messages RAMs write-page addresses
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
endmodule

module msg_pass_submatrix_9_unit #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,
	parameter VN_DEGREE = 3,   // degree of one variable node
/*-------------------------------------------------------------------------------------*/
	// Parameters related to BS, PA and MEM
	parameter RAM_DEPTH = 1024,
	parameter RAM_ADDR_BITWIDTH = $clog2(RAM_DEPTH),
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(CHECK_PARALLELISM-1),
	parameter shift_factor_0 = CHECK_PARALLELISM-50,
	parameter shift_factor_1 = CHECK_PARALLELISM-20,
	parameter shift_factor_2 = CHECK_PARALLELISM-70,

`ifdef SCHED_4_6
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,
	parameter C2V_MEM_ADDR_BASE = 0,
	parameter V2C_MEM_ADDR_BASE = ROW_CHUNK_NUM,
	parameter V2C_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter C2V_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH),
`endif
	parameter START_PAGE_1_0 = 2, // starting page address of layer 0 of submatrix_1
	parameter START_PAGE_1_1 = 8, // starting page address of layer 1 of submatrix_1
	parameter START_PAGE_1_2 = 1  // starting page address of layer 2 of submatrix_1
) (
	output wire [C2V_DATA_WIDTH-1:0] mem_to_cnu,
	output wire [V2C_DATA_WIDTH-1:0] mem_to_vnu,

	input wire [C2V_DATA_WIDTH-1:0] c2v_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] v2c_bs_in,
	input wire [V2C_DATA_WIDTH-1:0] ch_bs_in,
	input wire [CHECK_PARALLELISM-1:0] dnu_inRotate_bit,

	// control signals
	input wire c2v_bs_en,
	input wire v2c_bs_en,
	input wire ch_bs_en,
	/*------------------------------*/
	// Control signals associative with message passing of channel buffer and DNU.SignExtension
	input wire ch_ram_init_we,
	input wire ch_ram_fetch,
	input wire v2c_outRotate_reg_we,
	input wire dnu_inRotate_bs_en,
	input wire dnu_inRotate_pa_en,
	input wire dnu_inRotate_wb,
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
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,

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
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] c2v_shift_factor_cur_2;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_0;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_1;
reg [BITWIDTH_SHIFT_FACTOR-1:0] v2c_shift_factor_cur_2;
wire [BITWIDTH_SHIFT_FACTOR-1:0] vnu_shift_factorIn;
wire [6:0]  cnu_left_sel;
wire [6:0]  cnu_right_sel;
wire [83:0] cnu_merge_sel;
wire [6:0]  vnu_left_sel;
wire [6:0]  vnu_right_sel;
wire [83:0] vnu_merge_sel;
wire [CHECK_PARALLELISM-1:0] cnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] vnu_bs_in_bit [0:QUAN_SIZE-1];
wire [CHECK_PARALLELISM-1:0] ch_bs_in_bit [0:QUAN_SIZE-1];
genvar bit_index;
generate
	for(bit_index=0;bit_index<QUAN_SIZE;bit_index=bit_index+1) begin : extrinsic_msg_bs_in_inst
		assign cnu_bs_in_bit[bit_index] = {c2v_bs_in[QUAN_SIZE*84+bit_index],c2v_bs_in[QUAN_SIZE*83+bit_index],c2v_bs_in[QUAN_SIZE*82+bit_index],c2v_bs_in[QUAN_SIZE*81+bit_index],c2v_bs_in[QUAN_SIZE*80+bit_index],c2v_bs_in[QUAN_SIZE*79+bit_index],c2v_bs_in[QUAN_SIZE*78+bit_index],c2v_bs_in[QUAN_SIZE*77+bit_index],c2v_bs_in[QUAN_SIZE*76+bit_index],c2v_bs_in[QUAN_SIZE*75+bit_index],c2v_bs_in[QUAN_SIZE*74+bit_index],c2v_bs_in[QUAN_SIZE*73+bit_index],c2v_bs_in[QUAN_SIZE*72+bit_index],c2v_bs_in[QUAN_SIZE*71+bit_index],c2v_bs_in[QUAN_SIZE*70+bit_index],c2v_bs_in[QUAN_SIZE*69+bit_index],c2v_bs_in[QUAN_SIZE*68+bit_index],c2v_bs_in[QUAN_SIZE*67+bit_index],c2v_bs_in[QUAN_SIZE*66+bit_index],c2v_bs_in[QUAN_SIZE*65+bit_index],c2v_bs_in[QUAN_SIZE*64+bit_index],c2v_bs_in[QUAN_SIZE*63+bit_index],c2v_bs_in[QUAN_SIZE*62+bit_index],c2v_bs_in[QUAN_SIZE*61+bit_index],c2v_bs_in[QUAN_SIZE*60+bit_index],c2v_bs_in[QUAN_SIZE*59+bit_index],c2v_bs_in[QUAN_SIZE*58+bit_index],c2v_bs_in[QUAN_SIZE*57+bit_index],c2v_bs_in[QUAN_SIZE*56+bit_index],c2v_bs_in[QUAN_SIZE*55+bit_index],c2v_bs_in[QUAN_SIZE*54+bit_index],c2v_bs_in[QUAN_SIZE*53+bit_index],c2v_bs_in[QUAN_SIZE*52+bit_index],c2v_bs_in[QUAN_SIZE*51+bit_index],c2v_bs_in[QUAN_SIZE*50+bit_index],c2v_bs_in[QUAN_SIZE*49+bit_index],c2v_bs_in[QUAN_SIZE*48+bit_index],c2v_bs_in[QUAN_SIZE*47+bit_index],c2v_bs_in[QUAN_SIZE*46+bit_index],c2v_bs_in[QUAN_SIZE*45+bit_index],c2v_bs_in[QUAN_SIZE*44+bit_index],c2v_bs_in[QUAN_SIZE*43+bit_index],c2v_bs_in[QUAN_SIZE*42+bit_index],c2v_bs_in[QUAN_SIZE*41+bit_index],c2v_bs_in[QUAN_SIZE*40+bit_index],c2v_bs_in[QUAN_SIZE*39+bit_index],c2v_bs_in[QUAN_SIZE*38+bit_index],c2v_bs_in[QUAN_SIZE*37+bit_index],c2v_bs_in[QUAN_SIZE*36+bit_index],c2v_bs_in[QUAN_SIZE*35+bit_index],c2v_bs_in[QUAN_SIZE*34+bit_index],c2v_bs_in[QUAN_SIZE*33+bit_index],c2v_bs_in[QUAN_SIZE*32+bit_index],c2v_bs_in[QUAN_SIZE*31+bit_index],c2v_bs_in[QUAN_SIZE*30+bit_index],c2v_bs_in[QUAN_SIZE*29+bit_index],c2v_bs_in[QUAN_SIZE*28+bit_index],c2v_bs_in[QUAN_SIZE*27+bit_index],c2v_bs_in[QUAN_SIZE*26+bit_index],c2v_bs_in[QUAN_SIZE*25+bit_index],c2v_bs_in[QUAN_SIZE*24+bit_index],c2v_bs_in[QUAN_SIZE*23+bit_index],c2v_bs_in[QUAN_SIZE*22+bit_index],c2v_bs_in[QUAN_SIZE*21+bit_index],c2v_bs_in[QUAN_SIZE*20+bit_index],c2v_bs_in[QUAN_SIZE*19+bit_index],c2v_bs_in[QUAN_SIZE*18+bit_index],c2v_bs_in[QUAN_SIZE*17+bit_index],c2v_bs_in[QUAN_SIZE*16+bit_index],c2v_bs_in[QUAN_SIZE*15+bit_index],c2v_bs_in[QUAN_SIZE*14+bit_index],c2v_bs_in[QUAN_SIZE*13+bit_index],c2v_bs_in[QUAN_SIZE*12+bit_index],c2v_bs_in[QUAN_SIZE*11+bit_index],c2v_bs_in[QUAN_SIZE*10+bit_index],c2v_bs_in[QUAN_SIZE*9+bit_index],c2v_bs_in[QUAN_SIZE*8+bit_index],c2v_bs_in[QUAN_SIZE*7+bit_index],c2v_bs_in[QUAN_SIZE*6+bit_index],c2v_bs_in[QUAN_SIZE*5+bit_index],c2v_bs_in[QUAN_SIZE*4+bit_index],c2v_bs_in[QUAN_SIZE*3+bit_index],c2v_bs_in[QUAN_SIZE*2+bit_index],c2v_bs_in[QUAN_SIZE*1+bit_index],c2v_bs_in[QUAN_SIZE*0+bit_index]};
		assign vnu_bs_in_bit[bit_index] = {v2c_bs_in[QUAN_SIZE*84+bit_index],v2c_bs_in[QUAN_SIZE*83+bit_index],v2c_bs_in[QUAN_SIZE*82+bit_index],v2c_bs_in[QUAN_SIZE*81+bit_index],v2c_bs_in[QUAN_SIZE*80+bit_index],v2c_bs_in[QUAN_SIZE*79+bit_index],v2c_bs_in[QUAN_SIZE*78+bit_index],v2c_bs_in[QUAN_SIZE*77+bit_index],v2c_bs_in[QUAN_SIZE*76+bit_index],v2c_bs_in[QUAN_SIZE*75+bit_index],v2c_bs_in[QUAN_SIZE*74+bit_index],v2c_bs_in[QUAN_SIZE*73+bit_index],v2c_bs_in[QUAN_SIZE*72+bit_index],v2c_bs_in[QUAN_SIZE*71+bit_index],v2c_bs_in[QUAN_SIZE*70+bit_index],v2c_bs_in[QUAN_SIZE*69+bit_index],v2c_bs_in[QUAN_SIZE*68+bit_index],v2c_bs_in[QUAN_SIZE*67+bit_index],v2c_bs_in[QUAN_SIZE*66+bit_index],v2c_bs_in[QUAN_SIZE*65+bit_index],v2c_bs_in[QUAN_SIZE*64+bit_index],v2c_bs_in[QUAN_SIZE*63+bit_index],v2c_bs_in[QUAN_SIZE*62+bit_index],v2c_bs_in[QUAN_SIZE*61+bit_index],v2c_bs_in[QUAN_SIZE*60+bit_index],v2c_bs_in[QUAN_SIZE*59+bit_index],v2c_bs_in[QUAN_SIZE*58+bit_index],v2c_bs_in[QUAN_SIZE*57+bit_index],v2c_bs_in[QUAN_SIZE*56+bit_index],v2c_bs_in[QUAN_SIZE*55+bit_index],v2c_bs_in[QUAN_SIZE*54+bit_index],v2c_bs_in[QUAN_SIZE*53+bit_index],v2c_bs_in[QUAN_SIZE*52+bit_index],v2c_bs_in[QUAN_SIZE*51+bit_index],v2c_bs_in[QUAN_SIZE*50+bit_index],v2c_bs_in[QUAN_SIZE*49+bit_index],v2c_bs_in[QUAN_SIZE*48+bit_index],v2c_bs_in[QUAN_SIZE*47+bit_index],v2c_bs_in[QUAN_SIZE*46+bit_index],v2c_bs_in[QUAN_SIZE*45+bit_index],v2c_bs_in[QUAN_SIZE*44+bit_index],v2c_bs_in[QUAN_SIZE*43+bit_index],v2c_bs_in[QUAN_SIZE*42+bit_index],v2c_bs_in[QUAN_SIZE*41+bit_index],v2c_bs_in[QUAN_SIZE*40+bit_index],v2c_bs_in[QUAN_SIZE*39+bit_index],v2c_bs_in[QUAN_SIZE*38+bit_index],v2c_bs_in[QUAN_SIZE*37+bit_index],v2c_bs_in[QUAN_SIZE*36+bit_index],v2c_bs_in[QUAN_SIZE*35+bit_index],v2c_bs_in[QUAN_SIZE*34+bit_index],v2c_bs_in[QUAN_SIZE*33+bit_index],v2c_bs_in[QUAN_SIZE*32+bit_index],v2c_bs_in[QUAN_SIZE*31+bit_index],v2c_bs_in[QUAN_SIZE*30+bit_index],v2c_bs_in[QUAN_SIZE*29+bit_index],v2c_bs_in[QUAN_SIZE*28+bit_index],v2c_bs_in[QUAN_SIZE*27+bit_index],v2c_bs_in[QUAN_SIZE*26+bit_index],v2c_bs_in[QUAN_SIZE*25+bit_index],v2c_bs_in[QUAN_SIZE*24+bit_index],v2c_bs_in[QUAN_SIZE*23+bit_index],v2c_bs_in[QUAN_SIZE*22+bit_index],v2c_bs_in[QUAN_SIZE*21+bit_index],v2c_bs_in[QUAN_SIZE*20+bit_index],v2c_bs_in[QUAN_SIZE*19+bit_index],v2c_bs_in[QUAN_SIZE*18+bit_index],v2c_bs_in[QUAN_SIZE*17+bit_index],v2c_bs_in[QUAN_SIZE*16+bit_index],v2c_bs_in[QUAN_SIZE*15+bit_index],v2c_bs_in[QUAN_SIZE*14+bit_index],v2c_bs_in[QUAN_SIZE*13+bit_index],v2c_bs_in[QUAN_SIZE*12+bit_index],v2c_bs_in[QUAN_SIZE*11+bit_index],v2c_bs_in[QUAN_SIZE*10+bit_index],v2c_bs_in[QUAN_SIZE*9+bit_index],v2c_bs_in[QUAN_SIZE*8+bit_index],v2c_bs_in[QUAN_SIZE*7+bit_index],v2c_bs_in[QUAN_SIZE*6+bit_index],v2c_bs_in[QUAN_SIZE*5+bit_index],v2c_bs_in[QUAN_SIZE*4+bit_index],v2c_bs_in[QUAN_SIZE*3+bit_index],v2c_bs_in[QUAN_SIZE*2+bit_index],v2c_bs_in[QUAN_SIZE*1+bit_index],v2c_bs_in[QUAN_SIZE*0+bit_index]};
		assign ch_bs_in_bit[bit_index]  = { ch_bs_in[QUAN_SIZE*84+bit_index], ch_bs_in[QUAN_SIZE*83+bit_index], ch_bs_in[QUAN_SIZE*82+bit_index], ch_bs_in[QUAN_SIZE*81+bit_index], ch_bs_in[QUAN_SIZE*80+bit_index], ch_bs_in[QUAN_SIZE*79+bit_index], ch_bs_in[QUAN_SIZE*78+bit_index], ch_bs_in[QUAN_SIZE*77+bit_index], ch_bs_in[QUAN_SIZE*76+bit_index], ch_bs_in[QUAN_SIZE*75+bit_index], ch_bs_in[QUAN_SIZE*74+bit_index], ch_bs_in[QUAN_SIZE*73+bit_index], ch_bs_in[QUAN_SIZE*72+bit_index], ch_bs_in[QUAN_SIZE*71+bit_index], ch_bs_in[QUAN_SIZE*70+bit_index], ch_bs_in[QUAN_SIZE*69+bit_index], ch_bs_in[QUAN_SIZE*68+bit_index], ch_bs_in[QUAN_SIZE*67+bit_index], ch_bs_in[QUAN_SIZE*66+bit_index], ch_bs_in[QUAN_SIZE*65+bit_index], ch_bs_in[QUAN_SIZE*64+bit_index], ch_bs_in[QUAN_SIZE*63+bit_index], ch_bs_in[QUAN_SIZE*62+bit_index], ch_bs_in[QUAN_SIZE*61+bit_index], ch_bs_in[QUAN_SIZE*60+bit_index], ch_bs_in[QUAN_SIZE*59+bit_index], ch_bs_in[QUAN_SIZE*58+bit_index], ch_bs_in[QUAN_SIZE*57+bit_index], ch_bs_in[QUAN_SIZE*56+bit_index], ch_bs_in[QUAN_SIZE*55+bit_index], ch_bs_in[QUAN_SIZE*54+bit_index], ch_bs_in[QUAN_SIZE*53+bit_index], ch_bs_in[QUAN_SIZE*52+bit_index], ch_bs_in[QUAN_SIZE*51+bit_index], ch_bs_in[QUAN_SIZE*50+bit_index], ch_bs_in[QUAN_SIZE*49+bit_index], ch_bs_in[QUAN_SIZE*48+bit_index], ch_bs_in[QUAN_SIZE*47+bit_index], ch_bs_in[QUAN_SIZE*46+bit_index], ch_bs_in[QUAN_SIZE*45+bit_index], ch_bs_in[QUAN_SIZE*44+bit_index], ch_bs_in[QUAN_SIZE*43+bit_index], ch_bs_in[QUAN_SIZE*42+bit_index], ch_bs_in[QUAN_SIZE*41+bit_index], ch_bs_in[QUAN_SIZE*40+bit_index], ch_bs_in[QUAN_SIZE*39+bit_index], ch_bs_in[QUAN_SIZE*38+bit_index], ch_bs_in[QUAN_SIZE*37+bit_index], ch_bs_in[QUAN_SIZE*36+bit_index], ch_bs_in[QUAN_SIZE*35+bit_index], ch_bs_in[QUAN_SIZE*34+bit_index], ch_bs_in[QUAN_SIZE*33+bit_index], ch_bs_in[QUAN_SIZE*32+bit_index], ch_bs_in[QUAN_SIZE*31+bit_index], ch_bs_in[QUAN_SIZE*30+bit_index], ch_bs_in[QUAN_SIZE*29+bit_index], ch_bs_in[QUAN_SIZE*28+bit_index], ch_bs_in[QUAN_SIZE*27+bit_index], ch_bs_in[QUAN_SIZE*26+bit_index], ch_bs_in[QUAN_SIZE*25+bit_index], ch_bs_in[QUAN_SIZE*24+bit_index], ch_bs_in[QUAN_SIZE*23+bit_index], ch_bs_in[QUAN_SIZE*22+bit_index], ch_bs_in[QUAN_SIZE*21+bit_index], ch_bs_in[QUAN_SIZE*20+bit_index], ch_bs_in[QUAN_SIZE*19+bit_index], ch_bs_in[QUAN_SIZE*18+bit_index], ch_bs_in[QUAN_SIZE*17+bit_index], ch_bs_in[QUAN_SIZE*16+bit_index], ch_bs_in[QUAN_SIZE*15+bit_index], ch_bs_in[QUAN_SIZE*14+bit_index], ch_bs_in[QUAN_SIZE*13+bit_index], ch_bs_in[QUAN_SIZE*12+bit_index], ch_bs_in[QUAN_SIZE*11+bit_index], ch_bs_in[QUAN_SIZE*10+bit_index], ch_bs_in[QUAN_SIZE*9+bit_index], ch_bs_in[QUAN_SIZE*8+bit_index], ch_bs_in[QUAN_SIZE*7+bit_index], ch_bs_in[QUAN_SIZE*6+bit_index], ch_bs_in[QUAN_SIZE*5+bit_index], ch_bs_in[QUAN_SIZE*4+bit_index], ch_bs_in[QUAN_SIZE*3+bit_index], ch_bs_in[QUAN_SIZE*2+bit_index],ch_bs_in[QUAN_SIZE*1+bit_index], ch_bs_in[QUAN_SIZE*0+bit_index]};
	end
endgenerate
/*----------------------------------------------*/	
// Circular shifter of check nodes 
qsn_top_85b cnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({cnu_msg_in[84][0],cnu_msg_in[83][0],cnu_msg_in[82][0],cnu_msg_in[81][0],cnu_msg_in[80][0],cnu_msg_in[79][0],cnu_msg_in[78][0],cnu_msg_in[77][0],cnu_msg_in[76][0],cnu_msg_in[75][0],cnu_msg_in[74][0],cnu_msg_in[73][0],cnu_msg_in[72][0],cnu_msg_in[71][0],cnu_msg_in[70][0],cnu_msg_in[69][0],cnu_msg_in[68][0],cnu_msg_in[67][0],cnu_msg_in[66][0],cnu_msg_in[65][0],cnu_msg_in[64][0],cnu_msg_in[63][0],cnu_msg_in[62][0],cnu_msg_in[61][0],cnu_msg_in[60][0],cnu_msg_in[59][0],cnu_msg_in[58][0],cnu_msg_in[57][0],cnu_msg_in[56][0],cnu_msg_in[55][0],cnu_msg_in[54][0],cnu_msg_in[53][0],cnu_msg_in[52][0],cnu_msg_in[51][0],cnu_msg_in[50][0],cnu_msg_in[49][0],cnu_msg_in[48][0],cnu_msg_in[47][0],cnu_msg_in[46][0],cnu_msg_in[45][0],cnu_msg_in[44][0],cnu_msg_in[43][0],cnu_msg_in[42][0],cnu_msg_in[41][0],cnu_msg_in[40][0],cnu_msg_in[39][0],cnu_msg_in[38][0],cnu_msg_in[37][0],cnu_msg_in[36][0],cnu_msg_in[35][0],cnu_msg_in[34][0],cnu_msg_in[33][0],cnu_msg_in[32][0],cnu_msg_in[31][0],cnu_msg_in[30][0],cnu_msg_in[29][0],cnu_msg_in[28][0],cnu_msg_in[27][0],cnu_msg_in[26][0],cnu_msg_in[25][0],cnu_msg_in[24][0],cnu_msg_in[23][0],cnu_msg_in[22][0],cnu_msg_in[21][0],cnu_msg_in[20][0],cnu_msg_in[19][0],cnu_msg_in[18][0],cnu_msg_in[17][0],cnu_msg_in[16][0],cnu_msg_in[15][0],cnu_msg_in[14][0],cnu_msg_in[13][0],cnu_msg_in[12][0],cnu_msg_in[11][0],cnu_msg_in[10][0],cnu_msg_in[9][0],cnu_msg_in[8][0],cnu_msg_in[7][0],cnu_msg_in[6][0],cnu_msg_in[5][0],cnu_msg_in[4][0],cnu_msg_in[3][0],cnu_msg_in[2][0],cnu_msg_in[1][0],cnu_msg_in[0][0]}),
	.sw_out_bit1 ({cnu_msg_in[84][1],cnu_msg_in[83][1],cnu_msg_in[82][1],cnu_msg_in[81][1],cnu_msg_in[80][1],cnu_msg_in[79][1],cnu_msg_in[78][1],cnu_msg_in[77][1],cnu_msg_in[76][1],cnu_msg_in[75][1],cnu_msg_in[74][1],cnu_msg_in[73][1],cnu_msg_in[72][1],cnu_msg_in[71][1],cnu_msg_in[70][1],cnu_msg_in[69][1],cnu_msg_in[68][1],cnu_msg_in[67][1],cnu_msg_in[66][1],cnu_msg_in[65][1],cnu_msg_in[64][1],cnu_msg_in[63][1],cnu_msg_in[62][1],cnu_msg_in[61][1],cnu_msg_in[60][1],cnu_msg_in[59][1],cnu_msg_in[58][1],cnu_msg_in[57][1],cnu_msg_in[56][1],cnu_msg_in[55][1],cnu_msg_in[54][1],cnu_msg_in[53][1],cnu_msg_in[52][1],cnu_msg_in[51][1],cnu_msg_in[50][1],cnu_msg_in[49][1],cnu_msg_in[48][1],cnu_msg_in[47][1],cnu_msg_in[46][1],cnu_msg_in[45][1],cnu_msg_in[44][1],cnu_msg_in[43][1],cnu_msg_in[42][1],cnu_msg_in[41][1],cnu_msg_in[40][1],cnu_msg_in[39][1],cnu_msg_in[38][1],cnu_msg_in[37][1],cnu_msg_in[36][1],cnu_msg_in[35][1],cnu_msg_in[34][1],cnu_msg_in[33][1],cnu_msg_in[32][1],cnu_msg_in[31][1],cnu_msg_in[30][1],cnu_msg_in[29][1],cnu_msg_in[28][1],cnu_msg_in[27][1],cnu_msg_in[26][1],cnu_msg_in[25][1],cnu_msg_in[24][1],cnu_msg_in[23][1],cnu_msg_in[22][1],cnu_msg_in[21][1],cnu_msg_in[20][1],cnu_msg_in[19][1],cnu_msg_in[18][1],cnu_msg_in[17][1],cnu_msg_in[16][1],cnu_msg_in[15][1],cnu_msg_in[14][1],cnu_msg_in[13][1],cnu_msg_in[12][1],cnu_msg_in[11][1],cnu_msg_in[10][1],cnu_msg_in[9][1],cnu_msg_in[8][1],cnu_msg_in[7][1],cnu_msg_in[6][1],cnu_msg_in[5][1],cnu_msg_in[4][1],cnu_msg_in[3][1],cnu_msg_in[2][1],cnu_msg_in[1][1],cnu_msg_in[0][1]}),
	.sw_out_bit2 ({cnu_msg_in[84][2],cnu_msg_in[83][2],cnu_msg_in[82][2],cnu_msg_in[81][2],cnu_msg_in[80][2],cnu_msg_in[79][2],cnu_msg_in[78][2],cnu_msg_in[77][2],cnu_msg_in[76][2],cnu_msg_in[75][2],cnu_msg_in[74][2],cnu_msg_in[73][2],cnu_msg_in[72][2],cnu_msg_in[71][2],cnu_msg_in[70][2],cnu_msg_in[69][2],cnu_msg_in[68][2],cnu_msg_in[67][2],cnu_msg_in[66][2],cnu_msg_in[65][2],cnu_msg_in[64][2],cnu_msg_in[63][2],cnu_msg_in[62][2],cnu_msg_in[61][2],cnu_msg_in[60][2],cnu_msg_in[59][2],cnu_msg_in[58][2],cnu_msg_in[57][2],cnu_msg_in[56][2],cnu_msg_in[55][2],cnu_msg_in[54][2],cnu_msg_in[53][2],cnu_msg_in[52][2],cnu_msg_in[51][2],cnu_msg_in[50][2],cnu_msg_in[49][2],cnu_msg_in[48][2],cnu_msg_in[47][2],cnu_msg_in[46][2],cnu_msg_in[45][2],cnu_msg_in[44][2],cnu_msg_in[43][2],cnu_msg_in[42][2],cnu_msg_in[41][2],cnu_msg_in[40][2],cnu_msg_in[39][2],cnu_msg_in[38][2],cnu_msg_in[37][2],cnu_msg_in[36][2],cnu_msg_in[35][2],cnu_msg_in[34][2],cnu_msg_in[33][2],cnu_msg_in[32][2],cnu_msg_in[31][2],cnu_msg_in[30][2],cnu_msg_in[29][2],cnu_msg_in[28][2],cnu_msg_in[27][2],cnu_msg_in[26][2],cnu_msg_in[25][2],cnu_msg_in[24][2],cnu_msg_in[23][2],cnu_msg_in[22][2],cnu_msg_in[21][2],cnu_msg_in[20][2],cnu_msg_in[19][2],cnu_msg_in[18][2],cnu_msg_in[17][2],cnu_msg_in[16][2],cnu_msg_in[15][2],cnu_msg_in[14][2],cnu_msg_in[13][2],cnu_msg_in[12][2],cnu_msg_in[11][2],cnu_msg_in[10][2],cnu_msg_in[9][2],cnu_msg_in[8][2],cnu_msg_in[7][2],cnu_msg_in[6][2],cnu_msg_in[5][2],cnu_msg_in[4][2],cnu_msg_in[3][2],cnu_msg_in[2][2],cnu_msg_in[1][2],cnu_msg_in[0][2]}),	
	.sw_out_bit3 ({cnu_msg_in[84][3],cnu_msg_in[83][3],cnu_msg_in[82][3],cnu_msg_in[81][3],cnu_msg_in[80][3],cnu_msg_in[79][3],cnu_msg_in[78][3],cnu_msg_in[77][3],cnu_msg_in[76][3],cnu_msg_in[75][3],cnu_msg_in[74][3],cnu_msg_in[73][3],cnu_msg_in[72][3],cnu_msg_in[71][3],cnu_msg_in[70][3],cnu_msg_in[69][3],cnu_msg_in[68][3],cnu_msg_in[67][3],cnu_msg_in[66][3],cnu_msg_in[65][3],cnu_msg_in[64][3],cnu_msg_in[63][3],cnu_msg_in[62][3],cnu_msg_in[61][3],cnu_msg_in[60][3],cnu_msg_in[59][3],cnu_msg_in[58][3],cnu_msg_in[57][3],cnu_msg_in[56][3],cnu_msg_in[55][3],cnu_msg_in[54][3],cnu_msg_in[53][3],cnu_msg_in[52][3],cnu_msg_in[51][3],cnu_msg_in[50][3],cnu_msg_in[49][3],cnu_msg_in[48][3],cnu_msg_in[47][3],cnu_msg_in[46][3],cnu_msg_in[45][3],cnu_msg_in[44][3],cnu_msg_in[43][3],cnu_msg_in[42][3],cnu_msg_in[41][3],cnu_msg_in[40][3],cnu_msg_in[39][3],cnu_msg_in[38][3],cnu_msg_in[37][3],cnu_msg_in[36][3],cnu_msg_in[35][3],cnu_msg_in[34][3],cnu_msg_in[33][3],cnu_msg_in[32][3],cnu_msg_in[31][3],cnu_msg_in[30][3],cnu_msg_in[29][3],cnu_msg_in[28][3],cnu_msg_in[27][3],cnu_msg_in[26][3],cnu_msg_in[25][3],cnu_msg_in[24][3],cnu_msg_in[23][3],cnu_msg_in[22][3],cnu_msg_in[21][3],cnu_msg_in[20][3],cnu_msg_in[19][3],cnu_msg_in[18][3],cnu_msg_in[17][3],cnu_msg_in[16][3],cnu_msg_in[15][3],cnu_msg_in[14][3],cnu_msg_in[13][3],cnu_msg_in[12][3],cnu_msg_in[11][3],cnu_msg_in[10][3],cnu_msg_in[9][3],cnu_msg_in[8][3],cnu_msg_in[7][3],cnu_msg_in[6][3],cnu_msg_in[5][3],cnu_msg_in[4][3],cnu_msg_in[3][3],cnu_msg_in[2][3],cnu_msg_in[1][3],cnu_msg_in[0][3]}),
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in_bit0  (cnu_bs_in_bit[0]),
	.sw_in_bit1  (cnu_bs_in_bit[1]),
	.sw_in_bit2  (cnu_bs_in_bit[2]),
	.sw_in_bit3  (cnu_bs_in_bit[3]),
	.left_sel    (cnu_left_sel),
	.right_sel   (cnu_right_sel),
	.merge_sel   (cnu_merge_sel)
);
qsn_controller_85b #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) cnu_qsn_controller_85b (
	.left_sel     (cnu_left_sel ),
	.right_sel    (cnu_right_sel),
	.merge_sel    (cnu_merge_sel),
	.shift_factor (c2v_shift_factor_cur_0), // offset shift factor of submatrix_1
	.rstn         (rstn),
	.sys_clk      (read_clk)
);
/*----------------------------------------------*/
// Circular shifter of variable nodes 
wire [BITWIDTH_SHIFT_FACTOR-1:0] vnu_shift_factorIn;
wire [BITWIDTH_SHIFT_FACTOR-1:0] dnu_inRotate_shift_factor; // a constant, because only needed at last layer
shared_qsn_top_85b #(
		.QUAN_SIZE(QUAN_SIZE),
		.CHECK_PARALLELISM(CHECK_PARALLELISM),
		.BITWIDTH_SHIFT_FACTOR(BITWIDTH_SHIFT_FACTOR)
) inst_shared_qsn_top_85b (
	.sw_out_bit0 ({vnu_msg_in[84][0],vnu_msg_in[83][0],vnu_msg_in[82][0],vnu_msg_in[81][0],vnu_msg_in[80][0],vnu_msg_in[79][0],vnu_msg_in[78][0],vnu_msg_in[77][0],vnu_msg_in[76][0],vnu_msg_in[75][0],vnu_msg_in[74][0],vnu_msg_in[73][0],vnu_msg_in[72][0],vnu_msg_in[71][0],vnu_msg_in[70][0],vnu_msg_in[69][0],vnu_msg_in[68][0],vnu_msg_in[67][0],vnu_msg_in[66][0],vnu_msg_in[65][0],vnu_msg_in[64][0],vnu_msg_in[63][0],vnu_msg_in[62][0],vnu_msg_in[61][0],vnu_msg_in[60][0],vnu_msg_in[59][0],vnu_msg_in[58][0],vnu_msg_in[57][0],vnu_msg_in[56][0],vnu_msg_in[55][0],vnu_msg_in[54][0],vnu_msg_in[53][0],vnu_msg_in[52][0],vnu_msg_in[51][0],vnu_msg_in[50][0],vnu_msg_in[49][0],vnu_msg_in[48][0],vnu_msg_in[47][0],vnu_msg_in[46][0],vnu_msg_in[45][0],vnu_msg_in[44][0],vnu_msg_in[43][0],vnu_msg_in[42][0],vnu_msg_in[41][0],vnu_msg_in[40][0],vnu_msg_in[39][0],vnu_msg_in[38][0],vnu_msg_in[37][0],vnu_msg_in[36][0],vnu_msg_in[35][0],vnu_msg_in[34][0],vnu_msg_in[33][0],vnu_msg_in[32][0],vnu_msg_in[31][0],vnu_msg_in[30][0],vnu_msg_in[29][0],vnu_msg_in[28][0],vnu_msg_in[27][0],vnu_msg_in[26][0],vnu_msg_in[25][0],vnu_msg_in[24][0],vnu_msg_in[23][0],vnu_msg_in[22][0],vnu_msg_in[21][0],vnu_msg_in[20][0],vnu_msg_in[19][0],vnu_msg_in[18][0],vnu_msg_in[17][0],vnu_msg_in[16][0],vnu_msg_in[15][0],vnu_msg_in[14][0],vnu_msg_in[13][0],vnu_msg_in[12][0],vnu_msg_in[11][0],vnu_msg_in[10][0],vnu_msg_in[9][0],vnu_msg_in[8][0],vnu_msg_in[7][0],vnu_msg_in[6][0],vnu_msg_in[5][0],vnu_msg_in[4][0],vnu_msg_in[3][0],vnu_msg_in[2][0],vnu_msg_in[1][0],vnu_msg_in[0][0]}),	
	.sw_out_bit1 ({vnu_msg_in[84][1],vnu_msg_in[83][1],vnu_msg_in[82][1],vnu_msg_in[81][1],vnu_msg_in[80][1],vnu_msg_in[79][1],vnu_msg_in[78][1],vnu_msg_in[77][1],vnu_msg_in[76][1],vnu_msg_in[75][1],vnu_msg_in[74][1],vnu_msg_in[73][1],vnu_msg_in[72][1],vnu_msg_in[71][1],vnu_msg_in[70][1],vnu_msg_in[69][1],vnu_msg_in[68][1],vnu_msg_in[67][1],vnu_msg_in[66][1],vnu_msg_in[65][1],vnu_msg_in[64][1],vnu_msg_in[63][1],vnu_msg_in[62][1],vnu_msg_in[61][1],vnu_msg_in[60][1],vnu_msg_in[59][1],vnu_msg_in[58][1],vnu_msg_in[57][1],vnu_msg_in[56][1],vnu_msg_in[55][1],vnu_msg_in[54][1],vnu_msg_in[53][1],vnu_msg_in[52][1],vnu_msg_in[51][1],vnu_msg_in[50][1],vnu_msg_in[49][1],vnu_msg_in[48][1],vnu_msg_in[47][1],vnu_msg_in[46][1],vnu_msg_in[45][1],vnu_msg_in[44][1],vnu_msg_in[43][1],vnu_msg_in[42][1],vnu_msg_in[41][1],vnu_msg_in[40][1],vnu_msg_in[39][1],vnu_msg_in[38][1],vnu_msg_in[37][1],vnu_msg_in[36][1],vnu_msg_in[35][1],vnu_msg_in[34][1],vnu_msg_in[33][1],vnu_msg_in[32][1],vnu_msg_in[31][1],vnu_msg_in[30][1],vnu_msg_in[29][1],vnu_msg_in[28][1],vnu_msg_in[27][1],vnu_msg_in[26][1],vnu_msg_in[25][1],vnu_msg_in[24][1],vnu_msg_in[23][1],vnu_msg_in[22][1],vnu_msg_in[21][1],vnu_msg_in[20][1],vnu_msg_in[19][1],vnu_msg_in[18][1],vnu_msg_in[17][1],vnu_msg_in[16][1],vnu_msg_in[15][1],vnu_msg_in[14][1],vnu_msg_in[13][1],vnu_msg_in[12][1],vnu_msg_in[11][1],vnu_msg_in[10][1],vnu_msg_in[9][1],vnu_msg_in[8][1],vnu_msg_in[7][1],vnu_msg_in[6][1],vnu_msg_in[5][1],vnu_msg_in[4][1],vnu_msg_in[3][1],vnu_msg_in[2][1],vnu_msg_in[1][1],vnu_msg_in[0][1]}),	
	.sw_out_bit2 ({vnu_msg_in[84][2],vnu_msg_in[83][2],vnu_msg_in[82][2],vnu_msg_in[81][2],vnu_msg_in[80][2],vnu_msg_in[79][2],vnu_msg_in[78][2],vnu_msg_in[77][2],vnu_msg_in[76][2],vnu_msg_in[75][2],vnu_msg_in[74][2],vnu_msg_in[73][2],vnu_msg_in[72][2],vnu_msg_in[71][2],vnu_msg_in[70][2],vnu_msg_in[69][2],vnu_msg_in[68][2],vnu_msg_in[67][2],vnu_msg_in[66][2],vnu_msg_in[65][2],vnu_msg_in[64][2],vnu_msg_in[63][2],vnu_msg_in[62][2],vnu_msg_in[61][2],vnu_msg_in[60][2],vnu_msg_in[59][2],vnu_msg_in[58][2],vnu_msg_in[57][2],vnu_msg_in[56][2],vnu_msg_in[55][2],vnu_msg_in[54][2],vnu_msg_in[53][2],vnu_msg_in[52][2],vnu_msg_in[51][2],vnu_msg_in[50][2],vnu_msg_in[49][2],vnu_msg_in[48][2],vnu_msg_in[47][2],vnu_msg_in[46][2],vnu_msg_in[45][2],vnu_msg_in[44][2],vnu_msg_in[43][2],vnu_msg_in[42][2],vnu_msg_in[41][2],vnu_msg_in[40][2],vnu_msg_in[39][2],vnu_msg_in[38][2],vnu_msg_in[37][2],vnu_msg_in[36][2],vnu_msg_in[35][2],vnu_msg_in[34][2],vnu_msg_in[33][2],vnu_msg_in[32][2],vnu_msg_in[31][2],vnu_msg_in[30][2],vnu_msg_in[29][2],vnu_msg_in[28][2],vnu_msg_in[27][2],vnu_msg_in[26][2],vnu_msg_in[25][2],vnu_msg_in[24][2],vnu_msg_in[23][2],vnu_msg_in[22][2],vnu_msg_in[21][2],vnu_msg_in[20][2],vnu_msg_in[19][2],vnu_msg_in[18][2],vnu_msg_in[17][2],vnu_msg_in[16][2],vnu_msg_in[15][2],vnu_msg_in[14][2],vnu_msg_in[13][2],vnu_msg_in[12][2],vnu_msg_in[11][2],vnu_msg_in[10][2],vnu_msg_in[9][2],vnu_msg_in[8][2],vnu_msg_in[7][2],vnu_msg_in[6][2],vnu_msg_in[5][2],vnu_msg_in[4][2],vnu_msg_in[3][2],vnu_msg_in[2][2],vnu_msg_in[1][2],vnu_msg_in[0][2]}),	
	.sw_out_bit3 ({vnu_msg_in[84][3],vnu_msg_in[83][3],vnu_msg_in[82][3],vnu_msg_in[81][3],vnu_msg_in[80][3],vnu_msg_in[79][3],vnu_msg_in[78][3],vnu_msg_in[77][3],vnu_msg_in[76][3],vnu_msg_in[75][3],vnu_msg_in[74][3],vnu_msg_in[73][3],vnu_msg_in[72][3],vnu_msg_in[71][3],vnu_msg_in[70][3],vnu_msg_in[69][3],vnu_msg_in[68][3],vnu_msg_in[67][3],vnu_msg_in[66][3],vnu_msg_in[65][3],vnu_msg_in[64][3],vnu_msg_in[63][3],vnu_msg_in[62][3],vnu_msg_in[61][3],vnu_msg_in[60][3],vnu_msg_in[59][3],vnu_msg_in[58][3],vnu_msg_in[57][3],vnu_msg_in[56][3],vnu_msg_in[55][3],vnu_msg_in[54][3],vnu_msg_in[53][3],vnu_msg_in[52][3],vnu_msg_in[51][3],vnu_msg_in[50][3],vnu_msg_in[49][3],vnu_msg_in[48][3],vnu_msg_in[47][3],vnu_msg_in[46][3],vnu_msg_in[45][3],vnu_msg_in[44][3],vnu_msg_in[43][3],vnu_msg_in[42][3],vnu_msg_in[41][3],vnu_msg_in[40][3],vnu_msg_in[39][3],vnu_msg_in[38][3],vnu_msg_in[37][3],vnu_msg_in[36][3],vnu_msg_in[35][3],vnu_msg_in[34][3],vnu_msg_in[33][3],vnu_msg_in[32][3],vnu_msg_in[31][3],vnu_msg_in[30][3],vnu_msg_in[29][3],vnu_msg_in[28][3],vnu_msg_in[27][3],vnu_msg_in[26][3],vnu_msg_in[25][3],vnu_msg_in[24][3],vnu_msg_in[23][3],vnu_msg_in[22][3],vnu_msg_in[21][3],vnu_msg_in[20][3],vnu_msg_in[19][3],vnu_msg_in[18][3],vnu_msg_in[17][3],vnu_msg_in[16][3],vnu_msg_in[15][3],vnu_msg_in[14][3],vnu_msg_in[13][3],vnu_msg_in[12][3],vnu_msg_in[11][3],vnu_msg_in[10][3],vnu_msg_in[9][3],vnu_msg_in[8][3],vnu_msg_in[7][3],vnu_msg_in[6][3],vnu_msg_in[5][3],vnu_msg_in[4][3],vnu_msg_in[3][3],vnu_msg_in[2][3],vnu_msg_in[1][3],vnu_msg_in[0][3]}),	
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (rstn),
`endif
	.sw_in0_bit0  (vnu_bs_in_bit[0]),
	.sw_in0_bit1  (vnu_bs_in_bit[1]),
	.sw_in0_bit2  (vnu_bs_in_bit[2]),
	.sw_in0_bit3  (vnu_bs_in_bit[3]),

	.sw_in1_bit0 (ch_bs_in_bit[0]),
	.sw_in1_bit1 (ch_bs_in_bit[1]),
	.sw_in1_bit2 (ch_bs_in_bit[2]),
	.sw_in1_bit3 (ch_bs_in_bit[3]),

	.sw_in2_bit0 (dnu_inRotate_bit),

	.shift_factor (vnu_shift_factorIn), // offset shift factor of submatrix
	.sw_in_bit0_src (vnu_bs_bit0_src),
	.sw_in_src (vnu_bs_src)
);
assign vnu_shift_factorIn = (vnu_bs_bit0_src[0] == 1'b1) ? v2c_shift_factor_cur_0 :
							(vnu_bs_bit0_src[1] == 1'b1) ? ch_ramRD_shift_factor_cur_0 :
							(vnu_bs_bit0_src[2] == 1'b1) ? dnu_inRotate_shift_factor : v2c_shift_factor_cur_0;
/*----------------------------------------------*/	
	reg [ADDR_WIDTH-1:0] c2v_mem_page_addr;
	reg [ADDR_WIDTH-1:0] v2c_mem_page_addr;
	mem_subsystem_top_submatrix_9 #(
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
		) inst_mem_subsystem_top_submatrix_9 (
			.mem_to_vnu_0     (mem_to_vnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_vnu_1     (mem_to_vnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_vnu_2     (mem_to_vnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_vnu_3     (mem_to_vnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_vnu_4     (mem_to_vnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_vnu_5     (mem_to_vnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_vnu_6     (mem_to_vnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_vnu_7     (mem_to_vnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_vnu_8     (mem_to_vnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_vnu_9     (mem_to_vnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_vnu_10    (mem_to_vnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_vnu_11    (mem_to_vnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_vnu_12    (mem_to_vnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_vnu_13    (mem_to_vnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_vnu_14    (mem_to_vnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_vnu_15    (mem_to_vnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_vnu_16    (mem_to_vnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_vnu_17    (mem_to_vnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_vnu_18    (mem_to_vnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_vnu_19    (mem_to_vnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_vnu_20    (mem_to_vnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_vnu_21    (mem_to_vnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_vnu_22    (mem_to_vnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_vnu_23    (mem_to_vnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_vnu_24    (mem_to_vnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_vnu_25    (mem_to_vnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_vnu_26    (mem_to_vnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_vnu_27    (mem_to_vnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_vnu_28    (mem_to_vnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_vnu_29    (mem_to_vnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_vnu_30    (mem_to_vnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_vnu_31    (mem_to_vnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_vnu_32    (mem_to_vnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_vnu_33    (mem_to_vnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_vnu_34    (mem_to_vnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_vnu_35    (mem_to_vnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_vnu_36    (mem_to_vnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_vnu_37    (mem_to_vnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_vnu_38    (mem_to_vnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_vnu_39    (mem_to_vnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_vnu_40    (mem_to_vnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_vnu_41    (mem_to_vnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_vnu_42    (mem_to_vnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_vnu_43    (mem_to_vnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_vnu_44    (mem_to_vnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_vnu_45    (mem_to_vnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_vnu_46    (mem_to_vnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_vnu_47    (mem_to_vnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_vnu_48    (mem_to_vnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_vnu_49    (mem_to_vnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_vnu_50    (mem_to_vnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_vnu_51    (mem_to_vnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_vnu_52    (mem_to_vnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_vnu_53    (mem_to_vnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_vnu_54    (mem_to_vnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_vnu_55    (mem_to_vnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_vnu_56    (mem_to_vnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_vnu_57    (mem_to_vnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_vnu_58    (mem_to_vnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_vnu_59    (mem_to_vnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_vnu_60    (mem_to_vnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_vnu_61    (mem_to_vnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_vnu_62    (mem_to_vnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_vnu_63    (mem_to_vnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_vnu_64    (mem_to_vnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_vnu_65    (mem_to_vnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_vnu_66    (mem_to_vnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_vnu_67    (mem_to_vnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_vnu_68    (mem_to_vnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_vnu_69    (mem_to_vnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_vnu_70    (mem_to_vnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_vnu_71    (mem_to_vnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_vnu_72    (mem_to_vnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_vnu_73    (mem_to_vnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_vnu_74    (mem_to_vnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_vnu_75    (mem_to_vnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_vnu_76    (mem_to_vnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_vnu_77    (mem_to_vnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_vnu_78    (mem_to_vnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_vnu_79    (mem_to_vnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_vnu_80    (mem_to_vnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_vnu_81    (mem_to_vnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_vnu_82    (mem_to_vnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_vnu_83    (mem_to_vnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_vnu_84    (mem_to_vnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),
			.mem_to_cnu_0     (mem_to_cnu[(0 +1)*QUAN_SIZE-1:0 *QUAN_SIZE]),
			.mem_to_cnu_1     (mem_to_cnu[(1 +1)*QUAN_SIZE-1:1 *QUAN_SIZE]),
			.mem_to_cnu_2     (mem_to_cnu[(2 +1)*QUAN_SIZE-1:2 *QUAN_SIZE]),
			.mem_to_cnu_3     (mem_to_cnu[(3 +1)*QUAN_SIZE-1:3 *QUAN_SIZE]),
			.mem_to_cnu_4     (mem_to_cnu[(4 +1)*QUAN_SIZE-1:4 *QUAN_SIZE]),
			.mem_to_cnu_5     (mem_to_cnu[(5 +1)*QUAN_SIZE-1:5 *QUAN_SIZE]),
			.mem_to_cnu_6     (mem_to_cnu[(6 +1)*QUAN_SIZE-1:6 *QUAN_SIZE]),
			.mem_to_cnu_7     (mem_to_cnu[(7 +1)*QUAN_SIZE-1:7 *QUAN_SIZE]),
			.mem_to_cnu_8     (mem_to_cnu[(8 +1)*QUAN_SIZE-1:8 *QUAN_SIZE]),
			.mem_to_cnu_9     (mem_to_cnu[(9 +1)*QUAN_SIZE-1:9 *QUAN_SIZE]),
			.mem_to_cnu_10    (mem_to_cnu[(10+1)*QUAN_SIZE-1:10*QUAN_SIZE]),
			.mem_to_cnu_11    (mem_to_cnu[(11+1)*QUAN_SIZE-1:11*QUAN_SIZE]),
			.mem_to_cnu_12    (mem_to_cnu[(12+1)*QUAN_SIZE-1:12*QUAN_SIZE]),
			.mem_to_cnu_13    (mem_to_cnu[(13+1)*QUAN_SIZE-1:13*QUAN_SIZE]),
			.mem_to_cnu_14    (mem_to_cnu[(14+1)*QUAN_SIZE-1:14*QUAN_SIZE]),
			.mem_to_cnu_15    (mem_to_cnu[(15+1)*QUAN_SIZE-1:15*QUAN_SIZE]),
			.mem_to_cnu_16    (mem_to_cnu[(16+1)*QUAN_SIZE-1:16*QUAN_SIZE]),
			.mem_to_cnu_17    (mem_to_cnu[(17+1)*QUAN_SIZE-1:17*QUAN_SIZE]),
			.mem_to_cnu_18    (mem_to_cnu[(18+1)*QUAN_SIZE-1:18*QUAN_SIZE]),
			.mem_to_cnu_19    (mem_to_cnu[(19+1)*QUAN_SIZE-1:19*QUAN_SIZE]),
			.mem_to_cnu_20    (mem_to_cnu[(20+1)*QUAN_SIZE-1:20*QUAN_SIZE]),
			.mem_to_cnu_21    (mem_to_cnu[(21+1)*QUAN_SIZE-1:21*QUAN_SIZE]),
			.mem_to_cnu_22    (mem_to_cnu[(22+1)*QUAN_SIZE-1:22*QUAN_SIZE]),
			.mem_to_cnu_23    (mem_to_cnu[(23+1)*QUAN_SIZE-1:23*QUAN_SIZE]),
			.mem_to_cnu_24    (mem_to_cnu[(24+1)*QUAN_SIZE-1:24*QUAN_SIZE]),
			.mem_to_cnu_25    (mem_to_cnu[(25+1)*QUAN_SIZE-1:25*QUAN_SIZE]),
			.mem_to_cnu_26    (mem_to_cnu[(26+1)*QUAN_SIZE-1:26*QUAN_SIZE]),
			.mem_to_cnu_27    (mem_to_cnu[(27+1)*QUAN_SIZE-1:27*QUAN_SIZE]),
			.mem_to_cnu_28    (mem_to_cnu[(28+1)*QUAN_SIZE-1:28*QUAN_SIZE]),
			.mem_to_cnu_29    (mem_to_cnu[(29+1)*QUAN_SIZE-1:29*QUAN_SIZE]),
			.mem_to_cnu_30    (mem_to_cnu[(30+1)*QUAN_SIZE-1:30*QUAN_SIZE]),
			.mem_to_cnu_31    (mem_to_cnu[(31+1)*QUAN_SIZE-1:31*QUAN_SIZE]),
			.mem_to_cnu_32    (mem_to_cnu[(32+1)*QUAN_SIZE-1:32*QUAN_SIZE]),
			.mem_to_cnu_33    (mem_to_cnu[(33+1)*QUAN_SIZE-1:33*QUAN_SIZE]),
			.mem_to_cnu_34    (mem_to_cnu[(34+1)*QUAN_SIZE-1:34*QUAN_SIZE]),
			.mem_to_cnu_35    (mem_to_cnu[(35+1)*QUAN_SIZE-1:35*QUAN_SIZE]),
			.mem_to_cnu_36    (mem_to_cnu[(36+1)*QUAN_SIZE-1:36*QUAN_SIZE]),
			.mem_to_cnu_37    (mem_to_cnu[(37+1)*QUAN_SIZE-1:37*QUAN_SIZE]),
			.mem_to_cnu_38    (mem_to_cnu[(38+1)*QUAN_SIZE-1:38*QUAN_SIZE]),
			.mem_to_cnu_39    (mem_to_cnu[(39+1)*QUAN_SIZE-1:39*QUAN_SIZE]),
			.mem_to_cnu_40    (mem_to_cnu[(40+1)*QUAN_SIZE-1:40*QUAN_SIZE]),
			.mem_to_cnu_41    (mem_to_cnu[(41+1)*QUAN_SIZE-1:41*QUAN_SIZE]),
			.mem_to_cnu_42    (mem_to_cnu[(42+1)*QUAN_SIZE-1:42*QUAN_SIZE]),
			.mem_to_cnu_43    (mem_to_cnu[(43+1)*QUAN_SIZE-1:43*QUAN_SIZE]),
			.mem_to_cnu_44    (mem_to_cnu[(44+1)*QUAN_SIZE-1:44*QUAN_SIZE]),
			.mem_to_cnu_45    (mem_to_cnu[(45+1)*QUAN_SIZE-1:45*QUAN_SIZE]),
			.mem_to_cnu_46    (mem_to_cnu[(46+1)*QUAN_SIZE-1:46*QUAN_SIZE]),
			.mem_to_cnu_47    (mem_to_cnu[(47+1)*QUAN_SIZE-1:47*QUAN_SIZE]),
			.mem_to_cnu_48    (mem_to_cnu[(48+1)*QUAN_SIZE-1:48*QUAN_SIZE]),
			.mem_to_cnu_49    (mem_to_cnu[(49+1)*QUAN_SIZE-1:49*QUAN_SIZE]),
			.mem_to_cnu_50    (mem_to_cnu[(50+1)*QUAN_SIZE-1:50*QUAN_SIZE]),
			.mem_to_cnu_51    (mem_to_cnu[(51+1)*QUAN_SIZE-1:51*QUAN_SIZE]),
			.mem_to_cnu_52    (mem_to_cnu[(52+1)*QUAN_SIZE-1:52*QUAN_SIZE]),
			.mem_to_cnu_53    (mem_to_cnu[(53+1)*QUAN_SIZE-1:53*QUAN_SIZE]),
			.mem_to_cnu_54    (mem_to_cnu[(54+1)*QUAN_SIZE-1:54*QUAN_SIZE]),
			.mem_to_cnu_55    (mem_to_cnu[(55+1)*QUAN_SIZE-1:55*QUAN_SIZE]),
			.mem_to_cnu_56    (mem_to_cnu[(56+1)*QUAN_SIZE-1:56*QUAN_SIZE]),
			.mem_to_cnu_57    (mem_to_cnu[(57+1)*QUAN_SIZE-1:57*QUAN_SIZE]),
			.mem_to_cnu_58    (mem_to_cnu[(58+1)*QUAN_SIZE-1:58*QUAN_SIZE]),
			.mem_to_cnu_59    (mem_to_cnu[(59+1)*QUAN_SIZE-1:59*QUAN_SIZE]),
			.mem_to_cnu_60    (mem_to_cnu[(60+1)*QUAN_SIZE-1:60*QUAN_SIZE]),
			.mem_to_cnu_61    (mem_to_cnu[(61+1)*QUAN_SIZE-1:61*QUAN_SIZE]),
			.mem_to_cnu_62    (mem_to_cnu[(62+1)*QUAN_SIZE-1:62*QUAN_SIZE]),
			.mem_to_cnu_63    (mem_to_cnu[(63+1)*QUAN_SIZE-1:63*QUAN_SIZE]),
			.mem_to_cnu_64    (mem_to_cnu[(64+1)*QUAN_SIZE-1:64*QUAN_SIZE]),
			.mem_to_cnu_65    (mem_to_cnu[(65+1)*QUAN_SIZE-1:65*QUAN_SIZE]),
			.mem_to_cnu_66    (mem_to_cnu[(66+1)*QUAN_SIZE-1:66*QUAN_SIZE]),
			.mem_to_cnu_67    (mem_to_cnu[(67+1)*QUAN_SIZE-1:67*QUAN_SIZE]),
			.mem_to_cnu_68    (mem_to_cnu[(68+1)*QUAN_SIZE-1:68*QUAN_SIZE]),
			.mem_to_cnu_69    (mem_to_cnu[(69+1)*QUAN_SIZE-1:69*QUAN_SIZE]),
			.mem_to_cnu_70    (mem_to_cnu[(70+1)*QUAN_SIZE-1:70*QUAN_SIZE]),
			.mem_to_cnu_71    (mem_to_cnu[(71+1)*QUAN_SIZE-1:71*QUAN_SIZE]),
			.mem_to_cnu_72    (mem_to_cnu[(72+1)*QUAN_SIZE-1:72*QUAN_SIZE]),
			.mem_to_cnu_73    (mem_to_cnu[(73+1)*QUAN_SIZE-1:73*QUAN_SIZE]),
			.mem_to_cnu_74    (mem_to_cnu[(74+1)*QUAN_SIZE-1:74*QUAN_SIZE]),
			.mem_to_cnu_75    (mem_to_cnu[(75+1)*QUAN_SIZE-1:75*QUAN_SIZE]),
			.mem_to_cnu_76    (mem_to_cnu[(76+1)*QUAN_SIZE-1:76*QUAN_SIZE]),
			.mem_to_cnu_77    (mem_to_cnu[(77+1)*QUAN_SIZE-1:77*QUAN_SIZE]),
			.mem_to_cnu_78    (mem_to_cnu[(78+1)*QUAN_SIZE-1:78*QUAN_SIZE]),
			.mem_to_cnu_79    (mem_to_cnu[(79+1)*QUAN_SIZE-1:79*QUAN_SIZE]),
			.mem_to_cnu_80    (mem_to_cnu[(80+1)*QUAN_SIZE-1:80*QUAN_SIZE]),
			.mem_to_cnu_81    (mem_to_cnu[(81+1)*QUAN_SIZE-1:81*QUAN_SIZE]),
			.mem_to_cnu_82    (mem_to_cnu[(82+1)*QUAN_SIZE-1:82*QUAN_SIZE]),
			.mem_to_cnu_83    (mem_to_cnu[(83+1)*QUAN_SIZE-1:83*QUAN_SIZE]),
			.mem_to_cnu_84    (mem_to_cnu[(84+1)*QUAN_SIZE-1:84*QUAN_SIZE]),

			.vnu_to_mem_0     (vnu_msg_in[0 ]),
			.vnu_to_mem_1     (vnu_msg_in[1 ]),
			.vnu_to_mem_2     (vnu_msg_in[2 ]),
			.vnu_to_mem_3     (vnu_msg_in[3 ]),
			.vnu_to_mem_4     (vnu_msg_in[4 ]),
			.vnu_to_mem_5     (vnu_msg_in[5 ]),
			.vnu_to_mem_6     (vnu_msg_in[6 ]),
			.vnu_to_mem_7     (vnu_msg_in[7 ]),
			.vnu_to_mem_8     (vnu_msg_in[8 ]),
			.vnu_to_mem_9     (vnu_msg_in[9 ]),
			.vnu_to_mem_10    (vnu_msg_in[10]),
			.vnu_to_mem_11    (vnu_msg_in[11]),
			.vnu_to_mem_12    (vnu_msg_in[12]),
			.vnu_to_mem_13    (vnu_msg_in[13]),
			.vnu_to_mem_14    (vnu_msg_in[14]),
			.vnu_to_mem_15    (vnu_msg_in[15]),
			.vnu_to_mem_16    (vnu_msg_in[16]),
			.vnu_to_mem_17    (vnu_msg_in[17]),
			.vnu_to_mem_18    (vnu_msg_in[18]),
			.vnu_to_mem_19    (vnu_msg_in[19]),
			.vnu_to_mem_20    (vnu_msg_in[20]),
			.vnu_to_mem_21    (vnu_msg_in[21]),
			.vnu_to_mem_22    (vnu_msg_in[22]),
			.vnu_to_mem_23    (vnu_msg_in[23]),
			.vnu_to_mem_24    (vnu_msg_in[24]),
			.vnu_to_mem_25    (vnu_msg_in[25]),
			.vnu_to_mem_26    (vnu_msg_in[26]),
			.vnu_to_mem_27    (vnu_msg_in[27]),
			.vnu_to_mem_28    (vnu_msg_in[28]),
			.vnu_to_mem_29    (vnu_msg_in[29]),
			.vnu_to_mem_30    (vnu_msg_in[30]),
			.vnu_to_mem_31    (vnu_msg_in[31]),
			.vnu_to_mem_32    (vnu_msg_in[32]),
			.vnu_to_mem_33    (vnu_msg_in[33]),
			.vnu_to_mem_34    (vnu_msg_in[34]),
			.vnu_to_mem_35    (vnu_msg_in[35]),
			.vnu_to_mem_36    (vnu_msg_in[36]),
			.vnu_to_mem_37    (vnu_msg_in[37]),
			.vnu_to_mem_38    (vnu_msg_in[38]),
			.vnu_to_mem_39    (vnu_msg_in[39]),
			.vnu_to_mem_40    (vnu_msg_in[40]),
			.vnu_to_mem_41    (vnu_msg_in[41]),
			.vnu_to_mem_42    (vnu_msg_in[42]),
			.vnu_to_mem_43    (vnu_msg_in[43]),
			.vnu_to_mem_44    (vnu_msg_in[44]),
			.vnu_to_mem_45    (vnu_msg_in[45]),
			.vnu_to_mem_46    (vnu_msg_in[46]),
			.vnu_to_mem_47    (vnu_msg_in[47]),
			.vnu_to_mem_48    (vnu_msg_in[48]),
			.vnu_to_mem_49    (vnu_msg_in[49]),
			.vnu_to_mem_50    (vnu_msg_in[50]),
			.vnu_to_mem_51    (vnu_msg_in[51]),
			.vnu_to_mem_52    (vnu_msg_in[52]),
			.vnu_to_mem_53    (vnu_msg_in[53]),
			.vnu_to_mem_54    (vnu_msg_in[54]),
			.vnu_to_mem_55    (vnu_msg_in[55]),
			.vnu_to_mem_56    (vnu_msg_in[56]),
			.vnu_to_mem_57    (vnu_msg_in[57]),
			.vnu_to_mem_58    (vnu_msg_in[58]),
			.vnu_to_mem_59    (vnu_msg_in[59]),
			.vnu_to_mem_60    (vnu_msg_in[60]),
			.vnu_to_mem_61    (vnu_msg_in[61]),
			.vnu_to_mem_62    (vnu_msg_in[62]),
			.vnu_to_mem_63    (vnu_msg_in[63]),
			.vnu_to_mem_64    (vnu_msg_in[64]),
			.vnu_to_mem_65    (vnu_msg_in[65]),
			.vnu_to_mem_66    (vnu_msg_in[66]),
			.vnu_to_mem_67    (vnu_msg_in[67]),
			.vnu_to_mem_68    (vnu_msg_in[68]),
			.vnu_to_mem_69    (vnu_msg_in[69]),
			.vnu_to_mem_70    (vnu_msg_in[70]),
			.vnu_to_mem_71    (vnu_msg_in[71]),
			.vnu_to_mem_72    (vnu_msg_in[72]),
			.vnu_to_mem_73    (vnu_msg_in[73]),
			.vnu_to_mem_74    (vnu_msg_in[74]),
			.vnu_to_mem_75    (vnu_msg_in[75]),
			.vnu_to_mem_76    (vnu_msg_in[76]),
			.vnu_to_mem_77    (vnu_msg_in[77]),
			.vnu_to_mem_78    (vnu_msg_in[78]),
			.vnu_to_mem_79    (vnu_msg_in[79]),
			.vnu_to_mem_80    (vnu_msg_in[80]),
			.vnu_to_mem_81    (vnu_msg_in[81]),
			.vnu_to_mem_82    (vnu_msg_in[82]),
			.vnu_to_mem_83    (vnu_msg_in[83]),
			.vnu_to_mem_84    (vnu_msg_in[84]),
			.cnu_to_mem_0     (cnu_msg_in[0 ]),
			.cnu_to_mem_1     (cnu_msg_in[1 ]),
			.cnu_to_mem_2     (cnu_msg_in[2 ]),
			.cnu_to_mem_3     (cnu_msg_in[3 ]),
			.cnu_to_mem_4     (cnu_msg_in[4 ]),
			.cnu_to_mem_5     (cnu_msg_in[5 ]),
			.cnu_to_mem_6     (cnu_msg_in[6 ]),
			.cnu_to_mem_7     (cnu_msg_in[7 ]),
			.cnu_to_mem_8     (cnu_msg_in[8 ]),
			.cnu_to_mem_9     (cnu_msg_in[9 ]),
			.cnu_to_mem_10    (cnu_msg_in[10]),
			.cnu_to_mem_11    (cnu_msg_in[11]),
			.cnu_to_mem_12    (cnu_msg_in[12]),
			.cnu_to_mem_13    (cnu_msg_in[13]),
			.cnu_to_mem_14    (cnu_msg_in[14]),
			.cnu_to_mem_15    (cnu_msg_in[15]),
			.cnu_to_mem_16    (cnu_msg_in[16]),
			.cnu_to_mem_17    (cnu_msg_in[17]),
			.cnu_to_mem_18    (cnu_msg_in[18]),
			.cnu_to_mem_19    (cnu_msg_in[19]),
			.cnu_to_mem_20    (cnu_msg_in[20]),
			.cnu_to_mem_21    (cnu_msg_in[21]),
			.cnu_to_mem_22    (cnu_msg_in[22]),
			.cnu_to_mem_23    (cnu_msg_in[23]),
			.cnu_to_mem_24    (cnu_msg_in[24]),
			.cnu_to_mem_25    (cnu_msg_in[25]),
			.cnu_to_mem_26    (cnu_msg_in[26]),
			.cnu_to_mem_27    (cnu_msg_in[27]),
			.cnu_to_mem_28    (cnu_msg_in[28]),
			.cnu_to_mem_29    (cnu_msg_in[29]),
			.cnu_to_mem_30    (cnu_msg_in[30]),
			.cnu_to_mem_31    (cnu_msg_in[31]),
			.cnu_to_mem_32    (cnu_msg_in[32]),
			.cnu_to_mem_33    (cnu_msg_in[33]),
			.cnu_to_mem_34    (cnu_msg_in[34]),
			.cnu_to_mem_35    (cnu_msg_in[35]),
			.cnu_to_mem_36    (cnu_msg_in[36]),
			.cnu_to_mem_37    (cnu_msg_in[37]),
			.cnu_to_mem_38    (cnu_msg_in[38]),
			.cnu_to_mem_39    (cnu_msg_in[39]),
			.cnu_to_mem_40    (cnu_msg_in[40]),
			.cnu_to_mem_41    (cnu_msg_in[41]),
			.cnu_to_mem_42    (cnu_msg_in[42]),
			.cnu_to_mem_43    (cnu_msg_in[43]),
			.cnu_to_mem_44    (cnu_msg_in[44]),
			.cnu_to_mem_45    (cnu_msg_in[45]),
			.cnu_to_mem_46    (cnu_msg_in[46]),
			.cnu_to_mem_47    (cnu_msg_in[47]),
			.cnu_to_mem_48    (cnu_msg_in[48]),
			.cnu_to_mem_49    (cnu_msg_in[49]),
			.cnu_to_mem_50    (cnu_msg_in[50]),
			.cnu_to_mem_51    (cnu_msg_in[51]),
			.cnu_to_mem_52    (cnu_msg_in[52]),
			.cnu_to_mem_53    (cnu_msg_in[53]),
			.cnu_to_mem_54    (cnu_msg_in[54]),
			.cnu_to_mem_55    (cnu_msg_in[55]),
			.cnu_to_mem_56    (cnu_msg_in[56]),
			.cnu_to_mem_57    (cnu_msg_in[57]),
			.cnu_to_mem_58    (cnu_msg_in[58]),
			.cnu_to_mem_59    (cnu_msg_in[59]),
			.cnu_to_mem_60    (cnu_msg_in[60]),
			.cnu_to_mem_61    (cnu_msg_in[61]),
			.cnu_to_mem_62    (cnu_msg_in[62]),
			.cnu_to_mem_63    (cnu_msg_in[63]),
			.cnu_to_mem_64    (cnu_msg_in[64]),
			.cnu_to_mem_65    (cnu_msg_in[65]),
			.cnu_to_mem_66    (cnu_msg_in[66]),
			.cnu_to_mem_67    (cnu_msg_in[67]),
			.cnu_to_mem_68    (cnu_msg_in[68]),
			.cnu_to_mem_69    (cnu_msg_in[69]),
			.cnu_to_mem_70    (cnu_msg_in[70]),
			.cnu_to_mem_71    (cnu_msg_in[71]),
			.cnu_to_mem_72    (cnu_msg_in[72]),
			.cnu_to_mem_73    (cnu_msg_in[73]),
			.cnu_to_mem_74    (cnu_msg_in[74]),
			.cnu_to_mem_75    (cnu_msg_in[75]),
			.cnu_to_mem_76    (cnu_msg_in[76]),
			.cnu_to_mem_77    (cnu_msg_in[77]),
			.cnu_to_mem_78    (cnu_msg_in[78]),
			.cnu_to_mem_79    (cnu_msg_in[79]),
			.cnu_to_mem_80    (cnu_msg_in[80]),
			.cnu_to_mem_81    (cnu_msg_in[81]),
			.cnu_to_mem_82    (cnu_msg_in[82]),
			.cnu_to_mem_83    (cnu_msg_in[83]),
			.cnu_to_mem_84    (cnu_msg_in[84]),
			.cnu_sync_addr    (cnu_mem_page_sync_addr),
			.vnu_sync_addr    (vnu_mem_page_sync_addr),
			.cnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.vnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.last_row_chunk   ({c2v_last_row_chunk, v2c_last_row_chunk}),
			.we               ({v2c_mem_we, c2v_mem_we}),
			.sys_clk          (read_clk),
			.rstn             (rstn)
		);
		assign cnu_mem_page_sync_addr = (v2c_mem_fetch == 1'b1) ? v2c_mem_page_rd_addr : 
										(c2v_mem_we == 1'b1) ? c2v_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.

		assign vnu_mem_page_sync_addr = (c2v_mem_fetch == 1'b1) ? c2v_mem_page_rd_addr : 
										(v2c_mem_we == 1'b1) ? v2c_mem_page_addr : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Check-to-Variable messages RAMs write-page addresses
	always @(posedge read_clk) begin
		if(rstn == 1'b0) 
			c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE;
		else if(c2v_mem_we == 1'b1) begin
			// page increment pattern within layer 0
			if(v2c_layer_cnt[0] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_1+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 1
			if(v2c_layer_cnt[1] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_2+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
			// page increment pattern within layer 2
			if(v2c_layer_cnt[2] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr <= START_PAGE_1_0+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_2-1] == 1'b1)
						c2v_mem_page_addr <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr <= c2v_mem_page_addr+1;
			end
		end
	end

	always @(posedge read_clk) begin
		if(rstn == 1'b0) begin
			c2v_shift_factor_cur_2 <= shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
		end
		else if(c2v_bs_en == 1'b1) begin
			c2v_shift_factor_cur_2 <= 0;
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
/*--------------------------------------------------------------------------*/
// Channel Buffers
reg [CH_DATA_WIDTH-1:0] ch_msg_genIn;
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_0 [0:CHECK_PARALLELISM-1]; // [0:84]
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_1 [0:CHECK_PARALLELISM-1]; // [0:84]
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_rd_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chInit_wr_addr;
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chLayer_wr_addr;
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

			.din        (ch_msg_genIn[CH_DATA_WIDTH-1:0]),

			.read_addr  (submatrix_ch_ram_rd_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.write_addr (submatrix_ch_ram_wr_addr[CH_RAM_ADDR_WIDTH-1:0]),
			.we         (ch_ram_we),
			.read_clk   (ch_ram_rd_clk),
			.write_clk  (ch_ram_wr_clk),
			.rstn       (rstn)
		);
		// Updating the Channel RAMs by either initally channel messages (from AWGNs) or circularly shifted channel messages
		assign submatrix_ch_ram_wr_addr[submatrix_id] = (ch_ram_init_we == 1'b1) ? submatrix_chInit_wr_addr[submatrix_id] :
														(ch_ram_wb == 1'b1     ) ? submatrix_chLayer_wr_addr[submatrix_id] : 
																				   CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.


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
	// Channel messages RAMs write-page addresses
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
endmodule