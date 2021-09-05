`timescale 1ns / 1ps
`include "define.vh"

module entire_layer_decoder_tb #(
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
	output wire [VN_NUM-1:0] hard_decision_o,
	output reg decode_busy,
	output wire decode_termination,
	output reg [ITER_ADDR_BW-1:0] iter_cnt,
	output reg decode_fail,
	`ifdef AWGN_GEN_VERIFY
		output wire v2c_load_debug,
	`endif

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
	
	input wire tready_slave,
	input wire block_cnt_full,
	input wire read_clk,
	input wire vn_write_clk,
	input wire dn_write_clk,
	input wire decoder_rstn
);

//////////////////////////////////////////////////////////////////////////////////////////////////////
/*-----------------------------------------------------------------------------------------------------------------*/
// Reset Signal for main decoder module 
// Note that in the first codeword decoding process, 
// the reset signal will be kept asserted until the first codeword is generated, i.e., 
// the timing of first assertion of receivedBlock_generator.tvalid_master
//(* max_fanout = 50 *) reg decoder_rstn; initial decoder_rstn <= 1'b0;
reg decode_termination_reg;
/*---------------------------------------------------------------------------------------------------*/
localparam                  RESET_CYCLE_BITWIDTH = $clog2(RESET_CYCLE);
localparam                     bs_shift_overflow = 2**(PERMUTATION_LEVEL-1);
localparam                    cnu_shift_overflow = 2**(CNU_PIPELINE_LEVEL-1-1);
localparam                  fetch_shift_overflow = 2**(MEM_RD_LEVEL-1);
wire                             cnu_rd;
wire                             c2v_mem_we_propagateIn;
wire  							 c2v_pa_en;
wire 						 	 c2v_bs_en_propagateIn;
wire  							 v2c_mem_fetch_propagateIn;
//wire                             v2c_src;
wire							  c2v_last_layer;
wire                             de_frame_start;
wire [$clog2(FSM_STATE_NUM)-1:0] state;
wire                             layer_finish;
wire                             fsm_en;
wire							  vnu_update_pend;
reg                             iter_termination;

// Duplication of all control signals in order to propagate "enable state" to following pipeline stages
reg [ROW_CHUNK_NUM-2:0] c2v_mem_we_propagate; // the first one has already instantiated by FSM itself
wire c2v_mem_we; assign c2v_mem_we = (c2v_mem_we_propagate[ROW_CHUNK_NUM-2:0] > 0 || c2v_mem_we_propagateIn > 0) ? 1'b1 : 1'b0;
//reg c2v_mem_we; always @(posedge read_clk) begin if(!rstn) c2v_mem_we <= 0; else if(c2v_mem_we_propagate[ROW_CHUNK_NUM-2:0] > 0 || c2v_mem_we_propagateIn > 0) c2v_mem_we <= 1; else c2v_mem_we <= 0; end
always @(posedge read_clk) begin if(!decoder_rstn) c2v_mem_we_propagate <= 0; else c2v_mem_we_propagate[ROW_CHUNK_NUM-2:0] <= {c2v_mem_we_propagate[ROW_CHUNK_NUM-3:0], c2v_mem_we_propagateIn}; end
reg [ROW_CHUNK_NUM-1:0] c2v_last_row_chunk_propagate; // the first one has already instantiated by FSM itself
wire c2v_last_row_chunk; assign c2v_last_row_chunk = c2v_last_row_chunk_propagate[ROW_CHUNK_NUM-1];
always @(posedge read_clk) begin if(!decoder_rstn) c2v_last_row_chunk_propagate <= 0; else c2v_last_row_chunk_propagate[ROW_CHUNK_NUM-1:0] <= {c2v_last_row_chunk_propagate[ROW_CHUNK_NUM-2:0], c2v_pa_en}; end
reg [ROW_CHUNK_NUM-2:0] c2v_bs_en_propagate;
always @(posedge read_clk) begin if(!decoder_rstn) c2v_bs_en_propagate <= 0; else c2v_bs_en_propagate[ROW_CHUNK_NUM-2:0] <= {c2v_bs_en_propagate[ROW_CHUNK_NUM-3:0], c2v_bs_en_propagateIn}; end
wire c2v_bs_en; assign c2v_bs_en = (c2v_bs_en_propagate > 0 || c2v_bs_en_propagateIn > 0) ? 1'b1 : 1'b0;
reg [ROW_CHUNK_NUM-2:0] v2c_mem_fetch_propagate;
always @(posedge read_clk) begin if(!decoder_rstn) v2c_mem_fetch_propagate <= 0; else v2c_mem_fetch_propagate[ROW_CHUNK_NUM-2:0] <= {v2c_mem_fetch_propagate[ROW_CHUNK_NUM-3:0], v2c_mem_fetch_propagateIn}; end
wire v2c_mem_fetch; assign v2c_mem_fetch = (v2c_mem_fetch_propagate > 0 || v2c_mem_fetch_propagateIn > 0) ? 1'b1 : 1'b0;
cnu_control_unit #(
	.QUAN_SIZE(QUAN_SIZE),
	.LAYER_NUM(LAYER_NUM),
	.RESET_CYCLE(RESET_CYCLE),
	.CNU_FUNC_CYCLE(CNU_FUNC_CYCLE),
	.CNU_PIPELINE_LEVEL(CNU_PIPELINE_LEVEL),
	.VNU_BUBBLE_LEVEL(VNU_BUBBLE_LEVEL),
	.PERMUTATION_LEVEL(PERMUTATION_LEVEL),
	.PAGE_ALIGN_LEVEL(PAGE_ALIGN_LEVEL),
	.MEM_RD_LEVEL(MEM_RD_LEVEL),
	.FSM_STATE_NUM(FSM_STATE_NUM),
	.INIT_LOAD(INIT_LOAD),
	.MEM_FETCH(MEM_FETCH),
	.VNU_IB_RAM_PEND (VNU_IB_RAM_PEND),
	.VNU_BUBBLE(VNU_BUBBLE),
	.CNU_PIPE(CNU_PIPE),
	.CNU_OUT(CNU_OUT),
	.BS_WB(BS_WB),
	.PAGE_ALIGN(PAGE_ALIGN),
	.MEM_WB(MEM_WB),
	.IDLE (IDLE)
) inst_cnu_control_unit (
	.cnu_rd             (cnu_rd),
	.c2v_mem_we         (c2v_mem_we_propagateIn),
	.c2v_pa_en          (c2v_pa_en),
	.c2v_bs_en 			(c2v_bs_en_propagateIn),
	.v2c_mem_fetch      (v2c_mem_fetch_propagateIn),
	//.v2c_src            (v2c_src),
	.last_layer         (c2v_last_layer), 
	.de_frame_start     (de_frame_start),
	.state              (state),

	.vnu_update_pend    (vnu_update_pend),
	.layer_finish       (layer_finish),
	.termination        (iter_termination),
	.fsm_en             (fsm_en),
	.read_clk           (read_clk),
	.rstn               (decoder_rstn)
);
/*---------------------------------------------------------------------------------------------------*/
localparam                 LOAD_HANDSHAKE_LATENCY = 3;
localparam                 vnu_shift_overflow = 2**(VNU_PIPELINE_LEVEL-1-1);
wire [`IB_VNU_DECOMP_funNum-1:0] vnu_wr;
wire                             dnu_wr;
wire                             v2c_src_propagateIn;
wire [LAYER_NUM-1:0] 			  v2c_layer_cnt;
wire 							  v2c_last_layer;
wire                             v2c_mem_we_propagateIn;
wire 							 v2c_pa_en;
wire 						 	 v2c_bs_en_propagateIn;
wire 							 c2v_mem_fetch_propagateIn;
wire 							 v2c_outRotate_reg_we_propagateIn;
wire 							 dnu_inRotate_bs_en_propagateIn;
wire 							 dnu_inRotate_pa_en;
wire 							 dnu_inRotate_wb_propagateIn;
wire 							 dnu_signExten_ram_fetch_propagateIn;
wire ch_ram_init_we_propagateIn;
wire ch_bs_en_propagateIn; 
wire ch_pa_en; 
wire ch_ram_wb_propagateIn;
wire ch_ram_fetch_propagateIn;
wire [`IB_VNU_DECOMP_funNum-1:0] vnu_rd;
wire                             dnu_rd;
wire [$clog2(CTRL_FSM_STATE_NUM)-1:0] vnu_ctrl_state;
//wire [$clog2(WR_FSM_STATE_NUM)-1:0]   vnu_wr_state;
wire                             hard_decision_done;
// Instantiation of Write.FSMs (for simulation only)
wire [IB_VNU_DECOMP_funNum-1:0] vn_rom_port_fetch; // to enable the ib-map starting to fetch data from read port of IB ROM
wire [IB_VNU_DECOMP_funNum-1:0] vn_ram_write_en;
wire [IB_VNU_DECOMP_funNum-1:0] vn_ram_mux_en;
wire [IB_VNU_DECOMP_funNum-1:0] vn_iter_update;
wire [IB_VNU_DECOMP_funNum-1:0] v3ib_rom_rst;
wire [IB_VNU_DECOMP_funNum-1:0] vn_write_busy;
wire [IB_VNU_DECOMP_funNum-1:0] vn_iter_switch;
wire dn_iter_switch;
/*------------------------------------------------------------------------------------------------------------------------------------------*/
// DNU Update Iteration Control - Output
wire                             dn_iter_update;
wire dn_ram_write_en;
wire dn_rom_port_fetch; // to enable the ib-map starting to fetch data from read port of IB ROM
wire dn_ram_mux_en;
wire d3ib_rom_rst;
wire [1:0] dn_write_busy;
//wire [2:0] dn_write_fsm_state [0:INTER_FRAME_LEVEL-1];
/*------------------------------------------------------------------------------------------------------------------------------------------*/
wire [IB_VNU_DECOMP_funNum-1:0] vn_wr_iter_finish; // to notify the completion of iteration refresh 
wire dn_wr_iter_finish; // to notify the completion of iteration refresh 
wire [ITER_ADDR_BW-1:0] vnu_iter_cnt [0:IB_VNU_DECOMP_funNum-1];
wire [ITER_ADDR_BW-1:0] dnu_iter_cnt;
/*------------------------------------------------------------------------------------------------------------------------------------------*/	
// Duplication of all control signals in order to propagate "enable state" to following pipeline stages
reg [ROW_CHUNK_NUM-2:0] v2c_src_propagate;
always @(posedge read_clk) begin if(!decoder_rstn) v2c_src_propagate <= 0; else v2c_src_propagate[ROW_CHUNK_NUM-2:0] <= {v2c_src_propagate[ROW_CHUNK_NUM-3:0], v2c_src_propagateIn}; end
wire v2c_src = (v2c_src_propagate > 0 || v2c_src_propagateIn > 0) ? 1'b1 : 1'b0;
reg [ROW_CHUNK_NUM-2:0] v2c_mem_we_propagate; // the first one has already instantiated by FSM itself
wire v2c_mem_we; assign v2c_mem_we = (v2c_mem_we_propagate[ROW_CHUNK_NUM-2:0] > 0 || v2c_mem_we_propagateIn > 0) ? 1'b1 : 1'b0;
always @(posedge read_clk) begin if(!decoder_rstn) v2c_mem_we_propagate <= 0; else v2c_mem_we_propagate[ROW_CHUNK_NUM-2:0] <= {v2c_mem_we_propagate[ROW_CHUNK_NUM-3:0], v2c_mem_we_propagateIn}; end
reg [ROW_CHUNK_NUM-1:0] v2c_last_row_chunk_propagate; // the first one has already instantiated by FSM itself
wire v2c_last_row_chunk; assign v2c_last_row_chunk = v2c_last_row_chunk_propagate[ROW_CHUNK_NUM-1];
always @(posedge read_clk) begin if(!decoder_rstn) v2c_last_row_chunk_propagate <= 0; else v2c_last_row_chunk_propagate[ROW_CHUNK_NUM-1:0] <= {v2c_last_row_chunk_propagate[ROW_CHUNK_NUM-2:0], v2c_pa_en}; end	
reg [ROW_CHUNK_NUM-2:0] v2c_bs_en_propagate;
always @(posedge read_clk) begin if(!decoder_rstn) v2c_bs_en_propagate <= 0; else v2c_bs_en_propagate[ROW_CHUNK_NUM-2:0] <= {v2c_bs_en_propagate[ROW_CHUNK_NUM-3:0], v2c_bs_en_propagateIn}; end	
wire v2c_bs_en; assign v2c_bs_en = (v2c_bs_en_propagate > 0 || v2c_bs_en_propagateIn > 0) ? 1'b1 : 1'b0;
	
reg [CH_INIT_LOAD_LEVEL-2:0] ch_ram_init_we_propagate;
reg [ROW_CHUNK_NUM-1:0] ch_last_row_chunk_propagate; // the first one has already instantiated by FSM itself
reg [ROW_CHUNK_NUM-2:0]ch_bs_en_propagate; always @(posedge read_clk) begin if(!decoder_rstn) ch_bs_en_propagate <= 0; else ch_bs_en_propagate[ROW_CHUNK_NUM-2:0] <= {ch_bs_en_propagate[ROW_CHUNK_NUM-3:0], ch_bs_en_propagateIn}; end 
reg [ROW_CHUNK_NUM-2:0]ch_ram_wb_propagate; always @(posedge read_clk) begin if(!decoder_rstn) ch_ram_wb_propagate <= 0; else ch_ram_wb_propagate[ROW_CHUNK_NUM-2:0] <= {ch_ram_wb_propagate[ROW_CHUNK_NUM-3:0], ch_ram_wb_propagateIn}; end
reg [ROW_CHUNK_NUM-2:0] c2v_mem_fetch_propagate;
reg [ROW_CHUNK_NUM-2:0] ch_ram_fetch_propagate;
reg [LAYER_NUM-1:0] v2c_layer_cnt_pa_propagate [0:1];
reg [LAYER_NUM-1:0] signExten_layer_cnt_pa_propagate [0:SIGN_EXTEN_LAYER_CNT_EXTEN-1];
always @(posedge read_clk) begin if(!decoder_rstn) ch_ram_init_we_propagate <= 0; else ch_ram_init_we_propagate[CH_INIT_LOAD_LEVEL-2:0] <= {ch_ram_init_we_propagate[CH_INIT_LOAD_LEVEL-3:0], ch_ram_init_we_propagateIn}; end
always @(posedge read_clk) begin if(!decoder_rstn) ch_last_row_chunk_propagate <= 0; else ch_last_row_chunk_propagate[ROW_CHUNK_NUM-1:0] <= {ch_last_row_chunk_propagate[ROW_CHUNK_NUM-2:0], ch_pa_en}; end	
always @(posedge read_clk) begin if(!decoder_rstn) ch_ram_fetch_propagate <= 0; else ch_ram_fetch_propagate[ROW_CHUNK_NUM-2:0] <= {ch_ram_fetch_propagate[ROW_CHUNK_NUM-3:0], ch_ram_fetch_propagateIn}; end
always @(posedge read_clk) begin if(!decoder_rstn) c2v_mem_fetch_propagate <= 0; else c2v_mem_fetch_propagate[ROW_CHUNK_NUM-2:0] <= {c2v_mem_fetch_propagate[ROW_CHUNK_NUM-3:0], c2v_mem_fetch_propagateIn}; end
always @(posedge read_clk) begin if(!decoder_rstn) v2c_layer_cnt_pa_propagate[0] <= 0; else v2c_layer_cnt_pa_propagate[0] <= v2c_layer_cnt[LAYER_NUM-1:0]; end
always @(posedge read_clk) begin if(!decoder_rstn) v2c_layer_cnt_pa_propagate[1] <= 0; else v2c_layer_cnt_pa_propagate[1] <= v2c_layer_cnt_pa_propagate[0]; end
always @(posedge read_clk) begin if(!decoder_rstn) signExten_layer_cnt_pa_propagate[0] <= 0; else /*if(v2c_layer_cnt_pa_propagate[1][LAYER_NUM-2])*/ signExten_layer_cnt_pa_propagate[0] <= v2c_layer_cnt_pa_propagate[1]; end
genvar signExten_id;
generate
	for(signExten_id=1; signExten_id<SIGN_EXTEN_LAYER_CNT_EXTEN; signExten_id=signExten_id+1) begin : propagation_signExten_layer_cnt_pa
		always @(posedge read_clk) begin if(!decoder_rstn) signExten_layer_cnt_pa_propagate[signExten_id] <= 0; else signExten_layer_cnt_pa_propagate[signExten_id] <= signExten_layer_cnt_pa_propagate[signExten_id-1]; end
	end
endgenerate
wire ch_ram_init_we; assign ch_ram_init_we = (ch_ram_init_we_propagate[CH_INIT_LOAD_LEVEL-2:0] > 0 || ch_ram_init_we_propagateIn > 0) ? 1'b1 : 1'b0;
wire ch_last_row_chunk; assign ch_last_row_chunk = ch_last_row_chunk_propagate[ROW_CHUNK_NUM-1];
wire ch_bs_en; assign ch_bs_en = (ch_bs_en_propagate > 0 || ch_bs_en_propagateIn > 0) ? 1'b1 : 1'b0;
wire ch_ram_wb; assign ch_ram_wb = (ch_ram_wb_propagate > 0 || ch_ram_wb_propagateIn > 0) ? 1'b1 : 1'b0;
wire ch_ram_fetch; assign ch_ram_fetch = (ch_ram_fetch_propagate > 0 || ch_ram_fetch_propagateIn > 0) ? 1'b1 : 1'b0;
wire c2v_mem_fetch; assign c2v_mem_fetch = (c2v_mem_fetch_propagate > 0 || c2v_mem_fetch_propagateIn > 0) ? 1'b1 : 1'b0;
wire [LAYER_NUM-1:0] v2c_layer_cnt_pa; assign v2c_layer_cnt_pa = v2c_layer_cnt_pa_propagate[1];
wire [LAYER_NUM-1:0] signExten_layer_cnt_pa; assign signExten_layer_cnt_pa = signExten_layer_cnt_pa_propagate[SIGN_EXTEN_LAYER_CNT_EXTEN-1];

reg [ROW_CHUNK_NUM-2:0] v2c_outRotate_reg_we_propagate;
reg [ROW_CHUNK_NUM:0] v2c_outRotate_reg_we_flush_propagate; 
reg [ROW_CHUNK_NUM-1:0] dnu_inRotate_last_row_chunk_propagate; // the first one has already instantiated by FSM itself
reg [ROW_CHUNK_NUM-2:0] dnu_inRotate_bs_en_propagate;
reg [ROW_CHUNK_NUM-2:0] dnu_inRotate_wb_propagate;
reg [ROW_CHUNK_NUM-2:0] dnu_signExten_ram_fetch_propagate;
always @(posedge read_clk) begin if(!decoder_rstn) v2c_outRotate_reg_we_propagate <= 0; else v2c_outRotate_reg_we_propagate[ROW_CHUNK_NUM-2:0] <= {v2c_outRotate_reg_we_propagate[ROW_CHUNK_NUM-3:0], v2c_outRotate_reg_we_propagateIn}; end
always @(posedge read_clk) begin if(!decoder_rstn) v2c_outRotate_reg_we_flush_propagate <= 0; else v2c_outRotate_reg_we_flush_propagate[ROW_CHUNK_NUM:0] <= {v2c_outRotate_reg_we_flush_propagate[ROW_CHUNK_NUM-1:0], v2c_outRotate_reg_we_propagate[ROW_CHUNK_NUM-2]}; end
always @(posedge read_clk) begin if(!decoder_rstn) dnu_inRotate_last_row_chunk_propagate <= 0; else dnu_inRotate_last_row_chunk_propagate[ROW_CHUNK_NUM-1:0] <= {dnu_inRotate_last_row_chunk_propagate[ROW_CHUNK_NUM-2:0], dnu_inRotate_pa_en}; end	
always @(posedge read_clk) begin if(!decoder_rstn) dnu_inRotate_bs_en_propagate <= 0; else dnu_inRotate_bs_en_propagate[ROW_CHUNK_NUM-2:0] <= {dnu_inRotate_bs_en_propagate[ROW_CHUNK_NUM-3:0], dnu_inRotate_bs_en_propagateIn}; end
always @(posedge read_clk) begin if(!decoder_rstn) dnu_inRotate_wb_propagate <= 0; else dnu_inRotate_wb_propagate[ROW_CHUNK_NUM-2:0] <= {dnu_inRotate_wb_propagate[ROW_CHUNK_NUM-3:0], dnu_inRotate_wb_propagateIn}; end
always @(posedge read_clk) begin if(!decoder_rstn) dnu_signExten_ram_fetch_propagate <= 0; else dnu_signExten_ram_fetch_propagate[ROW_CHUNK_NUM-2:0] <= {dnu_signExten_ram_fetch_propagate[ROW_CHUNK_NUM-3:0], dnu_signExten_ram_fetch_propagateIn}; end
wire v2c_outRotate_reg_we; assign v2c_outRotate_reg_we = (v2c_outRotate_reg_we_propagate > 0 || v2c_outRotate_reg_we_propagateIn > 0) ? 1'b1 : 1'b0; 
wire v2c_outRotate_reg_we_flush; assign v2c_outRotate_reg_we_flush = (v2c_outRotate_reg_we_flush_propagate > 0) ? 1'b1 : 1'b0;
wire dnu_inRotate_last_row_chunk; assign dnu_inRotate_last_row_chunk = dnu_inRotate_last_row_chunk_propagate[ROW_CHUNK_NUM-1];	
wire dnu_inRotate_bs_en; assign dnu_inRotate_bs_en = (dnu_inRotate_bs_en_propagate > 0 || dnu_inRotate_bs_en_propagateIn > 0) ? 1'b1 : 1'b0;
wire dnu_inRotate_wb; assign dnu_inRotate_wb = (dnu_inRotate_wb_propagate > 0 || dnu_inRotate_wb_propagateIn > 0) ? 1'b1 : 1'b0;
wire dnu_signExten_ram_fetch; assign dnu_signExten_ram_fetch = (dnu_signExten_ram_fetch_propagate > 0 || dnu_signExten_ram_fetch_propagateIn > 0) ? 1'b1 : 1'b0;
wire shared_vnu_last_row_chunk;
/*------------------------------------------------------------------------------------------------------------------------------------------*/
vnu_control_unit #(
	.QUAN_SIZE(QUAN_SIZE),
	.LAYER_NUM(LAYER_NUM),
	.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
	.RESET_CYCLE(RESET_CYCLE),
	.VN_PIPELINE_BUBBLE(VN_PIPELINE_BUBBLE),
	.CH_BUBBLE_LEVEL(CH_BUBBLE_LEVEL),
	.VN_LOAD_CYCLE(VN_LOAD_CYCLE),
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
	.PAGE_MEM_WB_LEVEL(PAGE_MEM_WB_LEVEL),
	.MEM_RD_LEVEL(MEM_RD_LEVEL),

	.FSM_STATE_NUM(CTRL_FSM_STATE_NUM),
    .INIT_LOAD       (VNU_INIT_LOAD      ),
    .VNU_IB_RAM_PEND (VNU_VNU_IB_RAM_PEND),        
    .CH_FETCH        (VNU_CH_FETCH       ), 
    .CH_BUBBLE       (CH_BUBBLE          ),        
    .MEM_FETCH       (VNU_MEM_FETCH      ),  
    .VNU_PIPE        (VNU_VNU_PIPE       ),        
    .VNU_OUT         (VNU_VNU_OUT        ),         
    .BS_WB 	         (VNU_BS_WB          ),	    
    .PAGE_ALIGN 	 (VNU_PAGE_ALIGN     ),
    .MEM_WB 		 (VNU_MEM_WB         ),
    .IDLE  		     (VNU_IDLE           ) 
) inst_vnu_control_unit (
	.vnu_wr          (vnu_wr),
//`ifdef SCHED_4_6
//	//.dnu_wr          (), // in schedule_4.6, the DNU and VN.F1 are updated at the same time
//`else
	.dnu_wr          (dnu_wr),
//`endif
	.vnu_update_pend (vnu_update_pend),
	.v2c_src         (v2c_src_propagateIn),
	.last_layer      (v2c_last_layer),
	.layer_cnt 		 (v2c_layer_cnt),
	.v2c_mem_we      (v2c_mem_we_propagateIn),
	.v2c_pa_en       (v2c_pa_en),
	.v2c_bs_en 		 (v2c_bs_en_propagateIn),
	.ch_ram_init_we  (ch_ram_init_we_propagateIn),
	.ch_bs_en        (ch_bs_en_propagateIn), //(ch_bs_en_propagateIn),
	.ch_pa_en        (ch_pa_en),
	.ch_ram_wb       (ch_ram_wb_propagateIn),
	.c2v_mem_fetch    (c2v_mem_fetch_propagateIn),
	.ch_ram_fetch    (ch_ram_fetch_propagateIn), // Enable signal of fetching channel buffers
	.layer_finish    (layer_finish),

	.v2c_outRotate_reg_we (v2c_outRotate_reg_we_propagateIn),
	.dnu_inRotate_bs_en   (dnu_inRotate_bs_en_propagateIn),
	.dnu_inRotate_pa_en   (dnu_inRotate_pa_en),
	.dnu_inRotate_wb      (dnu_inRotate_wb_propagateIn),
	.dnu_signExten_ram_fetch  (dnu_signExten_ram_fetch_propagateIn),

	.vnu_rd             (vnu_rd),
	.dnu_rd             (dnu_rd),
	.state              (vnu_ctrl_state),
	.hard_decision_done (hard_decision_done),

	.vn_iter_update (vn_iter_update),
	.dn_iter_update (dn_iter_update),
	.termination    (iter_termination),
	.fsm_en         (fsm_en),
	.read_clk       (read_clk),
	.rstn           (decoder_rstn)
);
//`ifdef SCHED_4_6
//	assign dnu_wr = vnu_wr[IB_VNU_DECOMP_funNum-1]; // in schedule_4.6, the DNU and VN.F1 are updated at the same time
//`endif
assign shared_vnu_last_row_chunk = v2c_last_row_chunk || ch_last_row_chunk || dnu_inRotate_last_row_chunk;
/*---------------------------------------------------------------------*/
// Memory System
// Memory System - Output
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
wire vn_write_clk, dn_write_clk;

// Memory System - Ouput of Mux
/*Variable Node*/
wire [VN_RD_BW-1:0] vn_portA_dout [0:IB_VNU_DECOMP_funNum-1];
wire [VN_RD_BW-1:0] vn_portB_dout [0:IB_VNU_DECOMP_funNum-1];
/*Decision Node*/
wire [DN_RD_BW-1:0] dn_portA_dout;
wire [DN_RD_BW-1:0] dn_portB_dout;

// Memory Latch - Output
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

// IB-RAM Write Page Address Counter - Output
wire [VN_PAGE_ADDR_BW-1:0] vn_wr_page_addr [0:IB_VNU_DECOMP_funNum-1];
wire [DN_PAGE_ADDR_BW-1:0] dn_wr_page_addr;
//////////////////////////////////////////////////////////////////////////////////////////////////////
// IB-ROMs
ib_memory_system_wrapper ib_memory_system_inst_u0 (
	// Memory System - Ouput
	.vn_iter0_m0_portA_dout (vn_iter0_m0_portA_dout[VN_RD_BW-1:0]),
	.vn_iter0_m0_portB_dout (vn_iter0_m0_portB_dout[VN_RD_BW-1:0]),
	.vn_iter0_m1_portA_dout (vn_iter0_m1_portA_dout[VN_RD_BW-1:0]),
	.vn_iter0_m1_portB_dout (vn_iter0_m1_portB_dout[VN_RD_BW-1:0]),

   	.dn_iter0_portA_dout (dn_iter0_m2_portA_dout[DN_RD_BW-1:0]),
   	.dn_iter0_portB_dout (dn_iter0_m2_portB_dout[DN_RD_BW-1:0]),

   	// Memory System - Input
    .vn_iter0_m0_portA_addr (vn_rom_read_addrA[0]),
    .vn_iter0_m0_portB_addr (vn_rom_read_addrB[0]),
    .vn_iter0_m1_portA_addr (vn_rom_read_addrA[1]),
    .vn_iter0_m1_portB_addr (vn_rom_read_addrB[1]),

   	.dn_iter0_portA_addr (dn_rom_read_addrA[DN_ROM_ADDR_BW-1:0]),
    .dn_iter0_portB_addr (dn_rom_read_addrB[DN_ROM_ADDR_BW-1:0]),

    .vn_iter0_m0_portA_clk (vn_write_clk),
    .vn_iter0_m0_portB_clk (vn_write_clk),
    .vn_iter0_m1_portA_clk (vn_write_clk),
    .vn_iter0_m1_portB_clk (vn_write_clk),
    .dn_iter0_portB_clk (dn_write_clk),
    .dn_iter0_portA_clk (dn_write_clk) 
);
assign vn_write_clk = write_clk;
assign dn_write_clk = write_clk;
assign vn_portA_dout[0] = vn_iter0_m0_portA_dout[VN_RD_BW-1:0]; 
assign vn_portB_dout[0] = vn_iter0_m0_portB_dout[VN_RD_BW-1:0];
assign vn_portA_dout[1] = vn_iter0_m1_portA_dout[VN_RD_BW-1:0]; 
assign vn_portB_dout[1] = vn_iter0_m1_portB_dout[VN_RD_BW-1:0];
assign dn_portA_dout = dn_iter0_m2_portA_dout[DN_RD_BW-1:0]; 
assign dn_portB_dout = dn_iter0_m2_portB_dout[DN_RD_BW-1:0];
//////////////////////////////////////////////////////////////////////////////////////////////////////
generate
		genvar i, j;
		/*----------------------------------------------------------*/
		// For VNUs
		for(j=0;j<`IB_VNU_DECOMP_funNum;j=j+1) begin : vn_wr_fsm_inst
			vnu3_wr_fsm #(.LOAD_CYCLE(VN_LOAD_CYCLE), .FSM_STATE_NUM (WR_FSM_STATE_NUM)) vnu3_wr_fsm_u0 (
				// FSM - Output
				.rom_port_fetch (vn_rom_port_fetch[j]), // to enable the ib-map starting to fetch data from read port of IB ROM
				.ram_write_en   (vn_ram_write_en[j]),
				.ram_mux_en     (vn_ram_mux_en[j]),
				.iter_update    (vn_iter_update[j]),
				.v3ib_rom_rst   (v3ib_rom_rst[j]),
				.busy           (vn_write_busy[j]),
				//.state (vn_write_fsm_state[0]),
				
				// FSM - Input
				.write_clk (write_clk),
				.rstn (/*rstn*/fsm_en),
				.iter_rqst (vnu_wr[j]),
				.iter_termination (iter_termination)
			);
			
			vn_iter_counter #(
				.ITER_ADDR_BW (ITER_ADDR_BW),  // bit-width of addressing 50 iterationss
				.MAX_ITER (MAX_ITER)
			) vn_iter_counter_m01(
				.iter_cnt (vnu_iter_cnt[j]),
				
				.wr_iter_finish (vn_wr_iter_finish[j]),
				.write_clk (write_clk),
				.rstn (fsm_en)
			);
					
			v3rom_iter_selector #(
				.ITER_ROM_GROUP (ITER_ROM_GROUP), // the number of iteration datasets stored in one Group of IB-ROMs
				.ITER_ADDR_BW (ITER_ADDR_BW)// bit-width of addressing 50 iterationss
			) vn_rom_iter_selector_m01(
				.iter_switch (vn_iter_switch[j]),
				.iter_cnt (vnu_iter_cnt[j]),
				.write_clk (write_clk),
				.rstn (fsm_en)
			);			
			
			reg [VN_ROM_ADDR_BW-1:0] vn_iter_cnt_temp;
			initial vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0] <= 0;
			always @(posedge write_clk, negedge fsm_en) begin
				if(fsm_en == 1'b0) vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0] <= 0;
				else if(vn_wr_page_addr[j] == (VN_LOAD_CYCLE-1)  && vnu_iter_cnt[j] == ITER_ROM_GROUP-1) vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0] <= 1'b0; 
				else if(vn_ram_write_en[j] == 1'b1) vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0] <= vn_rom_read_addrA[j]-VN_OVERPROVISION;
				else vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0] <= vn_iter_cnt_temp[VN_ROM_ADDR_BW-1:0];
			end		

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
				.write_clk (write_clk)
			);

			vn_Waddr_counter #(
				.PAGE_ADDR_BW (VN_PAGE_ADDR_BW),
				.VN_LOAD_CYCLE (VN_LOAD_CYCLE)
			) vn_page_addr_vntM01 (
				.wr_page_addr (vn_wr_page_addr[j]),
				.wr_iter_finish (vn_wr_iter_finish[j]),
				
				.en (vn_ram_write_en[j]),
				.write_clk (write_clk),
				.rstn (~v3ib_rom_rst[j])
			); 
		end
endgenerate
dnu3_wr_fsm #(.LOAD_CYCLE(DN_LOAD_CYCLE)) dnu3_wr_fsm_u0 (
	// FSM - Output
	.rom_port_fetch (dn_rom_port_fetch), // to enable the ib-map starting to fetch data from read port of IB ROM
	.ram_write_en   (dn_ram_write_en),
	.ram_mux_en     (dn_ram_mux_en),
	.iter_update    (dn_iter_update),
	.v3ib_rom_rst   (d3ib_rom_rst),
	.busy           (dn_write_busy),
	//.state          (dn_write_fsm_state[0]),
	// FSM - Input
	.write_clk        (write_clk),
	.rstn             (/*rstn*/fsm_en),
	.iter_rqst        (dnu_wr),
	.iter_termination (iter_termination)
	//.pipeline_en    (vn_pipeline_en[i])	// deprecated
);

dn_iter_counter #(
	.ITER_ADDR_BW (ITER_ADDR_BW),  // bit-width of addressing 50 iterationss
	.MAX_ITER (MAX_ITER)
) dn_iter_counter_m2(
	.iter_cnt (dnu_iter_cnt),
	
	.wr_iter_finish (dn_wr_iter_finish),
	.write_clk (write_clk),
	.rstn (/*rstn*/fsm_en)
);

d3rom_iter_selector #(
	.ITER_ROM_GROUP (ITER_ROM_GROUP), // the number of iteration datasets stored in one Group of IB-ROMs
	.ITER_ADDR_BW (ITER_ADDR_BW)// bit-width of addressing 50 iterationss
) dn_rom_iter_selector_m2(
	.iter_switch (dn_iter_switch),
	.iter_cnt (dnu_iter_cnt),
	.write_clk (write_clk),
	.rstn (fsm_en)
);

reg [DN_ROM_ADDR_BW-1:0] dn_iter_cnt_temp;
initial dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0] <= 0;
always @(posedge write_clk, negedge fsm_en) begin
	if(fsm_en == 1'b0) dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0] <= 0;
	else if(dn_wr_page_addr == (DN_LOAD_CYCLE-1)  && dnu_iter_cnt == ITER_ROM_GROUP-1) dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0] <= 1'b0; 
	else if(dn_ram_write_en == 1'b1) dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0] <= dn_rom_read_addrA-DN_OVERPROVISION;
	else dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0] <= dn_iter_cnt_temp[DN_ROM_ADDR_BW-1:0];
end		

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
	.write_clk (write_clk)
);

dn_Waddr_counter #(
	.PAGE_ADDR_BW (DN_PAGE_ADDR_BW),
	.DN_LOAD_CYCLE (DN_LOAD_CYCLE)
) dn_page_addr_vntM2 (
	.wr_page_addr (dn_wr_page_addr[DN_PAGE_ADDR_BW-1:0]),
	.wr_iter_finish (dn_wr_iter_finish),
	
	.en (dn_ram_write_en),
	.write_clk (write_clk),
	.rstn (~d3ib_rom_rst)
);
/*-------------------------------------------------------------------------------------------------------------------------*/
//////////////////////////////////////////////////////////////////////////////////////////////////////
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
/*---------------------------------------------------------------------*/
// Instantiation of IB-Process Unit including the following blocks
// a) Check node unit
// b) Variable node unit
// c) Decision node unit (for final hard decision)
// d) Routing network with Parallel-to-Serial based message-passing converter
ib_proc_wrapper #(
	// Parameters of Message-Pass Wrapper
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
	.ADDR_WIDTH(ADDR_WIDTH),

	// Parameters of Row Process Elements
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
) ib_proc_u0 (
	.hard_decision_sub0 (hard_decision_sub0[CHECK_PARALLELISM-1:0]),
	.hard_decision_sub1 (hard_decision_sub1[CHECK_PARALLELISM-1:0]),
	.hard_decision_sub2 (hard_decision_sub2[CHECK_PARALLELISM-1:0]),
	.hard_decision_sub3 (hard_decision_sub3[CHECK_PARALLELISM-1:0]),
	.hard_decision_sub4 (hard_decision_sub4[CHECK_PARALLELISM-1:0]),
	.hard_decision_sub5 (hard_decision_sub5[CHECK_PARALLELISM-1:0]),
	.hard_decision_sub6 (hard_decision_sub6[CHECK_PARALLELISM-1:0]),
	.hard_decision_sub7 (hard_decision_sub7[CHECK_PARALLELISM-1:0]),
	.hard_decision_sub8 (hard_decision_sub8[CHECK_PARALLELISM-1:0]),
	.hard_decision_sub9 (hard_decision_sub9[CHECK_PARALLELISM-1:0]),

	.coded_block_sub0 (coded_block_sub0[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub1 (coded_block_sub1[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub2 (coded_block_sub2[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub3 (coded_block_sub3[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub4 (coded_block_sub4[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub5 (coded_block_sub5[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub6 (coded_block_sub6[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub7 (coded_block_sub7[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub8 (coded_block_sub8[SUBMATRIX_Z*QUAN_SIZE-1:0]),
	.coded_block_sub9 (coded_block_sub9[SUBMATRIX_Z*QUAN_SIZE-1:0]),
/*-----------------------------------------------------------------------------------------------------------------*/
	//  Control Signals for Message-Pass Wrapper
	.c2v_bs_en             (c2v_bs_en_propagate_temp[5]),
	.v2c_bs_en             (v2c_bs_en_propagate_temp[5]),
	.ch_bs_en              (ch_bs_en),
	/*------------------------------*/
	// Control signals associative with message passing of channel buffer and DNU.SignExtension
	.ch_ram_init_we          (ch_ram_init_we),
	.ch_ram_wb               (ch_ram_wb),
	.ch_ram_fetch            (ch_ram_fetch),
	.layer_finish            (layer_finish),
	.v2c_outRotate_reg_we    (v2c_outRotate_reg_we),
	.v2c_outRotate_reg_we_flush (v2c_outRotate_reg_we_flush),
	.dnu_inRotate_bs_en      (dnu_inRotate_bs_en),
	.dnu_inRotate_wb         (dnu_inRotate_wb),
	.dnu_signExten_ram_fetch (dnu_signExten_ram_fetch),
	/*------------------------------*/
	// 1) to indicate the current status of message passing of VNUs, in order to synchronise the C2V MEM's read/write address
	// 2) to indicate the current status of message passing of CNUs, in order to synchronise the V2C MEM's read/write address
	.c2v_mem_fetch         (c2v_mem_fetch),
	.v2c_mem_fetch         (v2c_mem_fetch),
	/*------------------------------*/
	.vnu_bs_src            (vnu_bs_src),
	.vnu_bs_bit0_src       (vnu_bs_bit0_src),

	.c2v_mem_we            (c2v_mem_we),
	.v2c_mem_we            (v2c_mem_we),
	.v2c_layer_cnt         (v2c_layer_cnt_pa[LAYER_NUM-1:0]), //(v2c_layer_cnt),
	.signExten_layer_cnt   (signExten_layer_cnt_pa),
	.c2v_last_row_chunk    (c2v_last_row_chunk),
	.v2c_last_row_chunk    (shared_vnu_last_row_chunk), // (v2c_last_row_chunk),
	.c2v_row_chunk_cnt     (c2v_row_chunk_cnt),
	.v2c_row_chunk_cnt     (v2c_row_chunk_cnt),
	.v2c_bs_en_propagate   (v2c_bs_en_propagate[ROW_CHUNK_NUM-2:0]),
	.c2v_bs_en_propagate   (c2v_bs_en_propagate[ROW_CHUNK_NUM-2:0]),
	.c2v_mem_we_propagate  (c2v_mem_we_propagate[ROW_CHUNK_NUM-2:0]),
	.v2c_mem_we_propagate  (v2c_mem_we_propagate[ROW_CHUNK_NUM-2:0]),
	.c2v_mem_we_propagateIn (c2v_mem_we_propagateIn),
	.v2c_mem_we_propagateIn (v2c_mem_we_propagateIn),
	.iter_termination      (iter_termination),
	.read_clk              (read_clk),
	.write_clk             (write_clk),
	.ch_ram_rd_clk         (ch_ram_rd_clk),
	.ch_ram_wr_clk         (ch_ram_wr_clk),
	.decoder_rstn          (decoder_rstn),
/*-----------------------------------------------------------------------------------------------------------------*/
	// Control Signals for Row Process Elements
	.vnu_read_addr_offset  (1'b0), // for future expansion of mult-frame feature
	.v2c_src               (v2c_src),
	//.v2c_latch_en          (v2c_latch_en),
	//.c2v_latch_en          (c2v_latch_en),
	//.load                  (load),
	//.parallel_en           (parallel_en),
	.vnu_page_addr_ram_0   ({1'b0, vn_wr_page_addr[0]}),
	.vnu_page_addr_ram_1   ({1'b0, vn_wr_page_addr[1]}),
	.vnu_page_addr_ram_2   ({1'b0, dn_wr_page_addr[DN_PAGE_ADDR_BW-1:0]}), // the last one is for decision node

	.vnu_ram_write_dataA_0 (vn_latch_outA[0]),
	.vnu_ram_write_dataB_0 (vn_latch_outB[0]),

	.vnu_ram_write_dataA_1 (vn_latch_outA[1]),
	.vnu_ram_write_dataB_1 (vn_latch_outB[1]),

	.vnu_ram_write_dataA_2 (dn_latch_outA[DN_ROM_RD_BW-1:0]),
	.vnu_ram_write_dataB_2 (dn_latch_outB[DN_ROM_RD_BW-1:0]),
	.vnu_ib_ram_we         ({dn_ram_write_en, vn_ram_write_en[IB_VNU_DECOMP_funNum-1:0]}),
	.vn_write_clk          (vn_write_clk),
	.dn_write_clk          (dn_write_clk)
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