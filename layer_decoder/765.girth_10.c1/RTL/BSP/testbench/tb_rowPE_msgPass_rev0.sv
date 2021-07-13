`timescale 1ns/1ps

`include "define.vh"
module tb_rowPE_msgPass_rev0 #(
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
	parameter C2V_TO_DNU_LATENCY = 5,
/*-------------------------------------------------------------------------------------*/
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
) ();

	// clock
	logic read_clk, write_clk, awgn_gen_clk;
	initial begin
		read_clk = 0;
		forever #(10) read_clk = ~read_clk;
	end
	initial begin
		write_clk = 0;
		#5;
		forever #(5) write_clk = ~write_clk;
	end
	initial begin
		awgn_gen_clk = 0;
		#5;
		forever #(3.3) awgn_gen_clk = ~awgn_gen_clk;
	end

	// asynchronous reset
	reg sys_rstn;
	initial begin
		sys_rstn <= 0;
		repeat (10) @(posedge read_clk);
		sys_rstn <= 1;
	end
/*-----------------------------------------------------------------------------------------------------------------*/
// Reset Signal for main decoder module 
// Note that in the first codeword decoding process, 
// the reset signal will be kept asserted until the first codeword is generated, i.e., 
// the timing of first assertion of receivedBlock_generator.tvalid_master
//(* max_fanout = 50 *) reg decoder_rstn; initial decoder_rstn <= 1'b0;
reg decoder_rstn;
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
	logic							  vnu_update_pend;
	logic                             iter_termination;

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
	//localparam                   RESET_CYCLE_BITWIDTH = $clog2(RESET_CYCLE);
	//localparam                      bs_shift_overflow = 2**(PERMUTATION_LEVEL-1);
	//localparam                   fetch_shift_overflow = 2**(MEM_RD_LEVEL-1);
	localparam                     vnu_shift_overflow = 2**(VNU_PIPELINE_LEVEL-1-1);

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
	//logic                             layer_finish;
	//logic                             iter_termination;
	//reg                               fsm_en;

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
	reg [1:0] v2c_layer_cnt_pa_propagate;
	always @(posedge read_clk) begin if(!decoder_rstn) ch_ram_init_we_propagate <= 0; else ch_ram_init_we_propagate[CH_INIT_LOAD_LEVEL-2:0] <= {ch_ram_init_we_propagate[CH_INIT_LOAD_LEVEL-3:0], ch_ram_init_we_propagateIn}; end
	always @(posedge read_clk) begin if(!decoder_rstn) ch_last_row_chunk_propagate <= 0; else ch_last_row_chunk_propagate[ROW_CHUNK_NUM-1:0] <= {ch_last_row_chunk_propagate[ROW_CHUNK_NUM-2:0], ch_pa_en}; end	
	always @(posedge read_clk) begin if(!decoder_rstn) ch_ram_fetch_propagate <= 0; else ch_ram_fetch_propagate[ROW_CHUNK_NUM-2:0] <= {ch_ram_fetch_propagate[ROW_CHUNK_NUM-3:0], ch_ram_fetch_propagateIn}; end
	always @(posedge read_clk) begin if(!decoder_rstn) c2v_mem_fetch_propagate <= 0; else c2v_mem_fetch_propagate[ROW_CHUNK_NUM-2:0] <= {c2v_mem_fetch_propagate[ROW_CHUNK_NUM-3:0], c2v_mem_fetch_propagateIn}; end
	always @(posedge read_clk) begin if(!decoder_rstn) v2c_layer_cnt_pa_propagate <= 0; else v2c_layer_cnt_pa_propagate[1:0] <= {v2c_layer_cnt_pa_propagate[0], v2c_layer_cnt}; end
	wire ch_ram_init_we; assign ch_ram_init_we = (ch_ram_init_we_propagate[CH_INIT_LOAD_LEVEL-2:0] > 0 || ch_ram_init_we_propagateIn > 0) ? 1'b1 : 1'b0;
	wire ch_last_row_chunk; assign ch_last_row_chunk = ch_last_row_chunk_propagate[ROW_CHUNK_NUM-1];
	wire ch_bs_en; assign ch_bs_en = (ch_bs_en_propagate > 0 || ch_bs_en_propagateIn > 0) ? 1'b1 : 1'b0;
	wire ch_ram_wb; assign ch_ram_wb = (ch_ram_wb_propagate > 0 || ch_ram_wb_propagateIn > 0) ? 1'b1 : 1'b0;
	wire ch_ram_fetch; assign ch_ram_fetch = (ch_ram_fetch_propagate > 0 || ch_ram_fetch_propagateIn > 0) ? 1'b1 : 1'b0;
	wire c2v_mem_fetch; assign c2v_mem_fetch = (c2v_mem_fetch_propagate > 0 || c2v_mem_fetch_propagateIn > 0) ? 1'b1 : 1'b0;
	wire v2c_layer_cnt_pa; assign v2c_layer_cnt_pa = v2c_layer_cnt_pa_propagate[1];

	reg [ROW_CHUNK_NUM-2:0] v2c_outRotate_reg_we_propagate; 
	reg [ROW_CHUNK_NUM-1:0] dnu_inRotate_last_row_chunk_propagate; // the first one has already instantiated by FSM itself
	reg [ROW_CHUNK_NUM-2:0] dnu_inRotate_bs_en_propagate;
	reg [ROW_CHUNK_NUM-2:0] dnu_inRotate_wb_propagate;
	reg [ROW_CHUNK_NUM-2:0] dnu_signExten_ram_fetch_propagate;
	always @(posedge read_clk) begin if(!decoder_rstn) v2c_outRotate_reg_we_propagate <= 0; else v2c_outRotate_reg_we_propagate[ROW_CHUNK_NUM-2:0] <= {v2c_outRotate_reg_we_propagate[ROW_CHUNK_NUM-3:0], v2c_outRotate_reg_we_propagateIn}; end
	always @(posedge read_clk) begin if(!decoder_rstn) dnu_inRotate_last_row_chunk_propagate <= 0; else dnu_inRotate_last_row_chunk_propagate[ROW_CHUNK_NUM-1:0] <= {dnu_inRotate_last_row_chunk_propagate[ROW_CHUNK_NUM-2:0], dnu_inRotate_pa_en}; end	
	always @(posedge read_clk) begin if(!decoder_rstn) dnu_inRotate_bs_en_propagate <= 0; else dnu_inRotate_bs_en_propagate[ROW_CHUNK_NUM-2:0] <= {dnu_inRotate_bs_en_propagate[ROW_CHUNK_NUM-3:0], dnu_inRotate_bs_en_propagateIn}; end
	always @(posedge read_clk) begin if(!decoder_rstn) dnu_inRotate_wb_propagate <= 0; else dnu_inRotate_wb_propagate[ROW_CHUNK_NUM-2:0] <= {dnu_inRotate_wb_propagate[ROW_CHUNK_NUM-3:0], dnu_inRotate_wb_propagateIn}; end
	always @(posedge read_clk) begin if(!decoder_rstn) dnu_signExten_ram_fetch_propagate <= 0; else dnu_signExten_ram_fetch_propagate[ROW_CHUNK_NUM-2:0] <= {dnu_signExten_ram_fetch_propagate[ROW_CHUNK_NUM-3:0], dnu_signExten_ram_fetch_propagateIn}; end
	wire v2c_outRotate_reg_we; assign v2c_outRotate_reg_we = (v2c_outRotate_reg_we_propagate > 0 || v2c_outRotate_reg_we_propagateIn > 0) ? 1'b1 : 1'b0; 
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
// Instantiation of BS, PAs and MEMs
	integer c2v_pageAlign_tb_fd [CN_DEGREE-1:0];
	integer v2c_pageAlign_tb_fd [CN_DEGREE-1:0];
	integer c2v_mem_fetch_fd    [CN_DEGREE-1:0];
	integer v2c_mem_fetch_fd    [CN_DEGREE-1:0];
	initial begin
		// Input Patterns for Submatrix 0
		c2v_pageAlign_tb_fd[0] = $fopen("c2v_pageAlign_result_submatrix_0", "w");
		v2c_pageAlign_tb_fd[0] = $fopen("v2c_pageAlign_result_submatrix_0", "w");
		c2v_mem_fetch_fd   [0] = 		$fopen("c2v_mem_fetch_submatrix_0", "w");
		v2c_mem_fetch_fd   [0] = 		$fopen("v2c_mem_fetch_submatrix_0", "w");
		// Input Patterns for Submatrix 1
		c2v_pageAlign_tb_fd[1] = $fopen("c2v_pageAlign_result_submatrix_1", "w");
		v2c_pageAlign_tb_fd[1] = $fopen("v2c_pageAlign_result_submatrix_1", "w");
		c2v_mem_fetch_fd   [1] = 		$fopen("c2v_mem_fetch_submatrix_1", "w");
		v2c_mem_fetch_fd   [1] = 		$fopen("v2c_mem_fetch_submatrix_1", "w");
		// Input Patterns for Submatrix 2
		c2v_pageAlign_tb_fd[2] = $fopen("c2v_pageAlign_result_submatrix_2", "w");
		v2c_pageAlign_tb_fd[2] = $fopen("v2c_pageAlign_result_submatrix_2", "w");
		c2v_mem_fetch_fd   [2] = 		$fopen("c2v_mem_fetch_submatrix_2", "w");
		v2c_mem_fetch_fd   [2] = 		$fopen("v2c_mem_fetch_submatrix_2", "w");
		// Input Patterns for Submatrix 3
		c2v_pageAlign_tb_fd[3] = $fopen("c2v_pageAlign_result_submatrix_3", "w");
		v2c_pageAlign_tb_fd[3] = $fopen("v2c_pageAlign_result_submatrix_3", "w");
		c2v_mem_fetch_fd   [3] = 		$fopen("c2v_mem_fetch_submatrix_3", "w");
		v2c_mem_fetch_fd   [3] = 		$fopen("v2c_mem_fetch_submatrix_3", "w");
		// Input Patterns for Submatrix 4
		c2v_pageAlign_tb_fd[4] = $fopen("c2v_pageAlign_result_submatrix_4", "w");
		v2c_pageAlign_tb_fd[4] = $fopen("v2c_pageAlign_result_submatrix_4", "w");
		c2v_mem_fetch_fd   [4] = 		$fopen("c2v_mem_fetch_submatrix_4", "w");
		v2c_mem_fetch_fd   [4] = 		$fopen("v2c_mem_fetch_submatrix_4", "w");
		// Input Patterns for Submatrix 5
		c2v_pageAlign_tb_fd[5] = $fopen("c2v_pageAlign_result_submatrix_5", "w");
		v2c_pageAlign_tb_fd[5] = $fopen("v2c_pageAlign_result_submatrix_5", "w");
		c2v_mem_fetch_fd   [5] =        $fopen("c2v_mem_fetch_submatrix_5", "w");
		v2c_mem_fetch_fd   [5] =        $fopen("v2c_mem_fetch_submatrix_5", "w");
		// Input Patterns for Submatrix 6
		c2v_pageAlign_tb_fd[6] = $fopen("c2v_pageAlign_result_submatrix_6", "w");
		v2c_pageAlign_tb_fd[6] = $fopen("v2c_pageAlign_result_submatrix_6", "w");
		c2v_mem_fetch_fd   [6] =        $fopen("c2v_mem_fetch_submatrix_6", "w");
		v2c_mem_fetch_fd   [6] =        $fopen("v2c_mem_fetch_submatrix_6", "w");
		// Input Patterns for Submatrix 7
		c2v_pageAlign_tb_fd[7] = $fopen("c2v_pageAlign_result_submatrix_7", "w");
		v2c_pageAlign_tb_fd[7] = $fopen("v2c_pageAlign_result_submatrix_7", "w");
		c2v_mem_fetch_fd   [7] =        $fopen("c2v_mem_fetch_submatrix_7", "w");
		v2c_mem_fetch_fd   [7] =        $fopen("v2c_mem_fetch_submatrix_7", "w");
		// Input Patterns for Submatrix 8
		c2v_pageAlign_tb_fd[8] = $fopen("c2v_pageAlign_result_submatrix_8", "w");
		v2c_pageAlign_tb_fd[8] = $fopen("v2c_pageAlign_result_submatrix_8", "w");
		c2v_mem_fetch_fd   [8] =        $fopen("c2v_mem_fetch_submatrix_8", "w");
		v2c_mem_fetch_fd   [8] =        $fopen("v2c_mem_fetch_submatrix_8", "w");
		// Input Patterns for Submatrix 9
		c2v_pageAlign_tb_fd[9] = $fopen("c2v_pageAlign_result_submatrix_9", "w");
		v2c_pageAlign_tb_fd[9] = $fopen("v2c_pageAlign_result_submatrix_9", "w");
		c2v_mem_fetch_fd   [9] =        $fopen("c2v_mem_fetch_submatrix_9", "w");
		v2c_mem_fetch_fd   [9] =        $fopen("v2c_mem_fetch_submatrix_9", "w");
	end

	logic [C2V_DATA_WIDTH-1:0] c2v_bs_in_sub [0:CN_DEGREE-1];
	logic [V2C_DATA_WIDTH-1:0] v2c_bs_in_sub [0:CN_DEGREE-1];
	logic [CHECK_PARALLELISM-1:0] cnu_bs_in_bit [0:QUAN_SIZE-1];
	logic [CHECK_PARALLELISM-1:0] vnu_bs_in_bit [0:QUAN_SIZE-1];
	/*----------------------------------------------*/
	// C2V page-aligned messages logger for Submatrix 0
	always @(posedge read_clk) begin
		if(c2v_mem_we/*temp*/ == 1'b1) begin
			//$fwrite(c2v_pageAlign_tb_fd[0],"state_%d, mem_we: %b (page_addr: 0x%h), last_RC:%b -> ", $unsigned(inst_cnu_control_unit.state), c2v_mem_we, inst_msg_pass_submatrix_1_unit.c2v_mem_page_addr, c2v_last_row_chunk);
			for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(c2v_pageAlign_tb_fd[0], "%h ", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_0_unit.inst_mem_subsystem_top_submatrix_0.cnu_pa_msg[i]));
			$fwrite(c2v_pageAlign_tb_fd[0], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_0_unit.inst_mem_subsystem_top_submatrix_0.cnu_pa_msg[0]));
		end
	end
	// V2C page-aligned messages logger for Submatrix 0
	always @(posedge read_clk) begin
		if(v2c_mem_we/*temp*/ == 1'b1) begin
			//$fwrite(v2c_pageAlign_tb_fd[0],"state_%d, mem_we: %b (page_addr: 0x%h), last_RC:%b -> ", $unsigned(inst_vnu_control_unit.state), v2c_mem_we, inst_msg_pass_submatrix_1_unit.v2c_mem_page_addr, v2c_last_row_chunk);
			for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(v2c_pageAlign_tb_fd[0], "%h ", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_0_unit.inst_mem_subsystem_top_submatrix_0.vnu_pa_msg[i]));
			$fwrite(v2c_pageAlign_tb_fd[0], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_0_unit.inst_mem_subsystem_top_submatrix_0.vnu_pa_msg[0]));
		end
	end
	/*----------------------------------------------*/
	// C2V page-aligned messages logger for Submatrix 1
	always @(posedge read_clk) begin
		if(c2v_mem_we/*temp*/ == 1'b1) begin
			//$fwrite(c2v_pageAlign_tb_fd[0],"state_%d, mem_we: %b (page_addr: 0x%h), last_RC:%b -> ", $unsigned(inst_cnu_control_unit.state), c2v_mem_we, inst_msg_pass_submatrix_1_unit.c2v_mem_page_addr, c2v_last_row_chunk);
			for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(c2v_pageAlign_tb_fd[1], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_0_unit.inst_mem_subsystem_top_submatrix_0.cnu_pa_msg[i]));
			$fwrite(c2v_pageAlign_tb_fd[1], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_0_unit.inst_mem_subsystem_top_submatrix_0.cnu_pa_msg[0]));
		end
	end
	// V2C page-aligned messages logger for Submatrix 1
	always @(posedge read_clk) begin
		if(v2c_mem_we/*temp*/ == 1'b1) begin
			//$fwrite(v2c_pageAlign_tb_fd[0],"state_%d, mem_we: %b (page_addr: 0x%h), last_RC:%b -> ", $unsigned(inst_vnu_control_unit.state), v2c_mem_we, inst_msg_pass_submatrix_1_unit.v2c_mem_page_addr, v2c_last_row_chunk);
			for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(v2c_pageAlign_tb_fd[0], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_0_unit.inst_mem_subsystem_top_submatrix_0.vnu_pa_msg[i]));
			$fwrite(v2c_pageAlign_tb_fd[0], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_0_unit.inst_mem_subsystem_top_submatrix_0.vnu_pa_msg[0]));
		end
	end
	/*----------------------------------------------*/
	// C2V page-aligned messages logger for Submatrix 2
	always @(posedge read_clk) begin
	        if(c2v_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(c2v_pageAlign_tb_fd[2], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_2_unit.inst_mem_subsystem_top_submatrix_2.cnu_pa_msg[i]));
	                $fwrite(c2v_pageAlign_tb_fd[2], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_2_unit.inst_mem_subsystem_top_submatrix_2.cnu_pa_msg[0]));
	        end
	end
	// V2C page-aligned messages logger for Submatrix 2
	always @(posedge read_clk) begin
	        if(v2c_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(v2c_pageAlign_tb_fd[2], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_2_unit.inst_mem_subsystem_top_submatrix_2.vnu_pa_msg[i]));
	                $fwrite(v2c_pageAlign_tb_fd[2], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_2_unit.inst_mem_subsystem_top_submatrix_2.vnu_pa_msg[0]));
	        end
	end
	/*----------------------------------------------*/
	// C2V page-aligned messages logger for Submatrix 3
	always @(posedge read_clk) begin
	        if(c2v_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(c2v_pageAlign_tb_fd[3], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_3_unit.inst_mem_subsystem_top_submatrix_3.cnu_pa_msg[i]));
	                $fwrite(c2v_pageAlign_tb_fd[3], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_3_unit.inst_mem_subsystem_top_submatrix_3.cnu_pa_msg[0]));
	        end
	end
	// V2C page-aligned messages logger for Submatrix 3
	always @(posedge read_clk) begin
	        if(v2c_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(v2c_pageAlign_tb_fd[3], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_3_unit.inst_mem_subsystem_top_submatrix_3.vnu_pa_msg[i]));
	                $fwrite(v2c_pageAlign_tb_fd[3], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_3_unit.inst_mem_subsystem_top_submatrix_3.vnu_pa_msg[0]));
	        end
	end
	/*----------------------------------------------*/
	// C2V page-aligned messages logger for Submatrix 4
	always @(posedge read_clk) begin
	        if(c2v_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(c2v_pageAlign_tb_fd[4], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_4_unit.inst_mem_subsystem_top_submatrix_4.cnu_pa_msg[i]));
	                $fwrite(c2v_pageAlign_tb_fd[4], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_4_unit.inst_mem_subsystem_top_submatrix_4.cnu_pa_msg[0]));
	        end
	end
	// V2C page-aligned messages logger for Submatrix 4
	always @(posedge read_clk) begin
	        if(v2c_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(v2c_pageAlign_tb_fd[4], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_4_unit.inst_mem_subsystem_top_submatrix_4.vnu_pa_msg[i]));
	                $fwrite(v2c_pageAlign_tb_fd[4], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_4_unit.inst_mem_subsystem_top_submatrix_4.vnu_pa_msg[0]));
	        end
	end
	/*----------------------------------------------*/
	// C2V page-aligned messages logger for Submatrix 5
	always @(posedge read_clk) begin
	        if(c2v_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(c2v_pageAlign_tb_fd[5], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_5_unit.inst_mem_subsystem_top_submatrix_5.cnu_pa_msg[i]));
	                $fwrite(c2v_pageAlign_tb_fd[5], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_5_unit.inst_mem_subsystem_top_submatrix_5.cnu_pa_msg[0]));
	        end
	end
	// V2C page-aligned messages logger for Submatrix 5
	always @(posedge read_clk) begin
	        if(v2c_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(v2c_pageAlign_tb_fd[5], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_5_unit.inst_mem_subsystem_top_submatrix_5.vnu_pa_msg[i]));
	                $fwrite(v2c_pageAlign_tb_fd[5], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_5_unit.inst_mem_subsystem_top_submatrix_5.vnu_pa_msg[0]));
	        end
	end
	/*----------------------------------------------*/
	// C2V page-aligned messages logger for Submatrix 6
	always @(posedge read_clk) begin
	        if(c2v_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(c2v_pageAlign_tb_fd[6], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_6_unit.inst_mem_subsystem_top_submatrix_6.cnu_pa_msg[i]));
	                $fwrite(c2v_pageAlign_tb_fd[6], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_6_unit.inst_mem_subsystem_top_submatrix_6.cnu_pa_msg[0]));
	        end
	end
	// V2C page-aligned messages logger for Submatrix 6
	always @(posedge read_clk) begin
	        if(v2c_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(v2c_pageAlign_tb_fd[6], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_6_unit.inst_mem_subsystem_top_submatrix_6.vnu_pa_msg[i]));
	                $fwrite(v2c_pageAlign_tb_fd[6], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_6_unit.inst_mem_subsystem_top_submatrix_6.vnu_pa_msg[0]));
	        end
	end
	/*----------------------------------------------*/
	// C2V page-aligned messages logger for Submatrix 7
	always @(posedge read_clk) begin
	        if(c2v_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(c2v_pageAlign_tb_fd[7], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_7_unit.inst_mem_subsystem_top_submatrix_7.cnu_pa_msg[i]));
	                $fwrite(c2v_pageAlign_tb_fd[7], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_7_unit.inst_mem_subsystem_top_submatrix_7.cnu_pa_msg[0]));
	        end
	end
	// V2C page-aligned messages logger for Submatrix 7
	always @(posedge read_clk) begin
	        if(v2c_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(v2c_pageAlign_tb_fd[7], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_7_unit.inst_mem_subsystem_top_submatrix_7.vnu_pa_msg[i]));
	                $fwrite(v2c_pageAlign_tb_fd[7], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_7_unit.inst_mem_subsystem_top_submatrix_7.vnu_pa_msg[0]));
	        end
	end
	/*----------------------------------------------*/
	// C2V page-aligned messages logger for Submatrix 8
	always @(posedge read_clk) begin
	        if(c2v_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(c2v_pageAlign_tb_fd[8], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_8_unit.inst_mem_subsystem_top_submatrix_8.cnu_pa_msg[i]));
	                $fwrite(c2v_pageAlign_tb_fd[8], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_8_unit.inst_mem_subsystem_top_submatrix_8.cnu_pa_msg[0]));
	        end
	end
	// V2C page-aligned messages logger for Submatrix 8
	always @(posedge read_clk) begin
	        if(v2c_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(v2c_pageAlign_tb_fd[8], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_8_unit.inst_mem_subsystem_top_submatrix_8.vnu_pa_msg[i]));
	                $fwrite(v2c_pageAlign_tb_fd[8], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_8_unit.inst_mem_subsystem_top_submatrix_8.vnu_pa_msg[0]));
	        end
	end
	/*----------------------------------------------*/
	// C2V page-aligned messages logger for Submatrix 9
	always @(posedge read_clk) begin
	        if(c2v_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(c2v_pageAlign_tb_fd[9], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_9_unit.inst_mem_subsystem_top_submatrix_9.cnu_pa_msg[i]));
	                $fwrite(c2v_pageAlign_tb_fd[9], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_9_unit.inst_mem_subsystem_top_submatrix_9.cnu_pa_msg[0]));
	        end
	end
	// V2C page-aligned messages logger for Submatrix 9
	always @(posedge read_clk) begin
	        if(v2c_mem_we == 1'b1) begin
	                for(int i = CHECK_PARALLELISM-1; i >= 1; i--) $fwrite(v2c_pageAlign_tb_fd[9], "%h,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_9_unit.inst_mem_subsystem_top_submatrix_9.vnu_pa_msg[i]));
	                $fwrite(v2c_pageAlign_tb_fd[9], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_9_unit.inst_mem_subsystem_top_submatrix_9.vnu_pa_msg[0]));
	        end
	end
	/*-------------------------------------------------------------------------------------------------------------------------*/
	always @(posedge read_clk) begin
			if(decoder_rstn == 1'b0) iter_termination <= 0;
			else if(
				//inst_vnu_control_unit.iter_cnt[MAX_ITER-1] == 1'b1 && 
				//vnu_ctrl_state[$clog2(CTRL_FSM_STATE_NUM)-1:0] == MEM_WB
				inst_vnu_control_unit.iter_cnt[1] == 1'b1 && // only simulating 2 iteration
				inst_vnu_control_unit.state == VNU_CH_FETCH
				&& inst_vnu_control_unit.layer_cnt[1] == 1'b1
			)
				iter_termination <= 1'b1;
	end

	task init();
		iter_termination  <= 0;
	endtask
	assign fsm_en = decoder_rstn;
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

	localparam AWGN_BLOCK_NUM = SUBMATRIX_Z*CN_DEGREE;
	localparam SNR_PACKET_SIZE = $clog2(`SNR_SET_NUM);
	wire [SUBMATRIX_Z*QUAN_SIZE-1:0] coded_block [0:CN_DEGREE-1];
	wire tvalid_master, ready_slave;
    //wire snr_next_sync; assign snr_next_sync = (|snr_next_reg[7:0]);
	reg [SNR_PACKET_SIZE-1:0] snr_packet; initial snr_packet <= 0;
	receivedBlock_generator #(
		.N (AWGN_BLOCK_NUM), // block length, e.g., 7650
		.NG_NUM (`NG_NUM), // 10 codeword segments
		.NG_SIZE (`NG_SIZE), // the number of codebits in each codeword segment, e.g., 765
		.QUAN_SIZE (QUAN_SIZE)// 4-bit quantisation for each channel message
	) block_gen_u0(
		.coded_block_0 (coded_block[0]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_1 (coded_block[1]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_2 (coded_block[2]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_3 (coded_block[3]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_4 (coded_block[4]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_5 (coded_block[5]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_6 (coded_block[6]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_7 (coded_block[7]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_8 (coded_block[8]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.coded_block_9 (coded_block[9]), // each segment consists of Z*q bits, e.g., 765*4-bit
		.tvalid_master (tvalid_master),
		
		.sigma_in (sigma_in[/*snr_packet[SNR_PACKET_SIZE-1:0]*/55]),
		//input wire [63:0] seed_base_0,
		//input wire [63:0] seed_base_1,
		//input wire [63:0] seed_base_2,
		.ready_slave (1'b1),//(ready_slave),
		.rstn (sys_rstn),//(~snr_next_sync && sys_rstn),//(sys_rstn),
		.sys_clk (awgn_gen_clk)
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
	logic        [V2C_DATA_WIDTH-1:0] mem_to_cnu_sub    [0:CN_DEGREE-1];
	logic        [C2V_DATA_WIDTH-1:0] mem_to_vnu_sub    [0:CN_DEGREE-1];
	logic         [CH_DATA_WIDTH-1:0] ch_to_cnu_sub     [0:CN_DEGREE-1];
	logic         [CH_DATA_WIDTH-1:0] ch_to_vnu_sub     [0:CN_DEGREE-1];
	logic 		  [CH_DATA_WIDTH-1:0] ch_to_bs_sub      [0:CN_DEGREE-1];
	wire     [CHECK_PARALLELISM-1:0] dnu_signExten_sub [0:CN_DEGREE-1];
	// Data In
	wire [V2C_DATA_WIDTH-1:0] vnuOut_to_mem [0:CN_DEGREE-1];
	wire [C2V_DATA_WIDTH-1:0] cnuOut_to_mem [0:CN_DEGREE-1];
	wire [CHECK_PARALLELISM-1:0] signExten_to_bs [0:CN_DEGREE-1];

	logic        [V2C_DATA_WIDTH-1:0] ch_bs_in_sub [0:CN_DEGREE-1];
	logic [SUBMATRIX_Z*QUAN_SIZE-1:0] coded_block_sub [0:CN_DEGREE-1];
	logic     [CHECK_PARALLELISM-1:0] dnu_inRotate_bit_sub [0:CN_DEGREE-1]; //assign dnu_inRotate_bit_sub1 = 85'd1;
	genvar coded_block_id;
	generate
		for(coded_block_id=0; coded_block_id<CN_DEGREE; coded_block_id=coded_block_id+1) begin : coded_block_net_inst
			//assign coded_block_sub [coded_block_id] = {340'd9, 340'd8, 340'd7, 340'd6, 340'd5, 340'd4, 340'd3, 340'd2, 340'd1};
			assign coded_block_sub [coded_block_id] = coded_block[coded_block_id];
		end
	endgenerate
	
	// Control signals In
	logic                             vnu_bs_src; assign vnu_bs_src = ch_bs_en;
	logic                       [2:0] vnu_bs_bit0_src; assign vnu_bs_bit0_src[2:0] = {dnu_inRotate_bs_en, ch_bs_en, v2c_bs_en};

	logic                             ch_ram_rd_clk; assign ch_ram_rd_clk = read_clk;
	logic                             ch_ram_wr_clk; assign ch_ram_wr_clk = write_clk;

	reg [5:0] v2c_bs_en_propagate_temp; always @(posedge read_clk) begin if(!decoder_rstn) v2c_bs_en_propagate_temp <= 0; else v2c_bs_en_propagate_temp[5:0] <= {v2c_bs_en_propagate_temp[4:0], v2c_bs_en_propagate[ROW_CHUNK_NUM-2]}; end
	reg [5:0] c2v_bs_en_propagate_temp; always @(posedge read_clk) begin if(!decoder_rstn) c2v_bs_en_propagate_temp <= 0; else c2v_bs_en_propagate_temp[5:0] <= {c2v_bs_en_propagate_temp[4:0], c2v_bs_en_propagate[ROW_CHUNK_NUM-2]}; end
	wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt; assign c2v_row_chunk_cnt[ROW_CHUNK_NUM-1:0] = {c2v_mem_we_propagate[ROW_CHUNK_NUM-2:0], c2v_mem_we_propagateIn};
	wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt; assign v2c_row_chunk_cnt[ROW_CHUNK_NUM-1:0] = {v2c_mem_we_propagate[ROW_CHUNK_NUM-2:0], v2c_mem_we_propagateIn};
/*-----------------------------------------------------------------------------------------------------------------*/
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

			.coded_block_sub0      (coded_block_sub[0]),
			.coded_block_sub1      (coded_block_sub[1]),
			.coded_block_sub2      (coded_block_sub[2]),
			.coded_block_sub3      (coded_block_sub[3]),
			.coded_block_sub4      (coded_block_sub[4]),
			.coded_block_sub5      (coded_block_sub[5]),
			.coded_block_sub6      (coded_block_sub[6]),
			.coded_block_sub7      (coded_block_sub[7]),
			.coded_block_sub8      (coded_block_sub[8]),
			.coded_block_sub9      (coded_block_sub[9]),
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
			.v2c_layer_cnt         (v2c_layer_cnt_pa), //(v2c_layer_cnt),
			.c2v_last_row_chunk    (c2v_last_row_chunk),
			.v2c_last_row_chunk    (shared_vnu_last_row_chunk), // (v2c_last_row_chunk),
			.c2v_row_chunk_cnt     (c2v_row_chunk_cnt),
			.v2c_row_chunk_cnt     (v2c_row_chunk_cnt),
			.iter_termination      (iter_termination),
			.read_clk              (read_clk),
			.write_clk             (write_clk),
			.ch_ram_rd_clk         (ch_ram_rd_clk),
			.ch_ram_wr_clk         (ch_ram_wr_clk),
			.rstn                  (decoder_rstn)
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
// Log Files of V2C message to BS.in
integer v2c_to_bs [CN_DEGREE-1:0];
integer c2v_to_bs [CN_DEGREE-1:0];
initial begin
	v2c_to_bs[0] = $fopen("submatrix_0_v2c_to_bs.mem", "w");
	v2c_to_bs[1] = $fopen("submatrix_1_v2c_to_bs.mem", "w");
	v2c_to_bs[2] = $fopen("submatrix_2_v2c_to_bs.mem", "w");
	v2c_to_bs[3] = $fopen("submatrix_3_v2c_to_bs.mem", "w");
	v2c_to_bs[4] = $fopen("submatrix_4_v2c_to_bs.mem", "w");
	v2c_to_bs[5] = $fopen("submatrix_5_v2c_to_bs.mem", "w");
	v2c_to_bs[6] = $fopen("submatrix_6_v2c_to_bs.mem", "w");
	v2c_to_bs[7] = $fopen("submatrix_7_v2c_to_bs.mem", "w");
	v2c_to_bs[8] = $fopen("submatrix_8_v2c_to_bs.mem", "w");
	v2c_to_bs[9] = $fopen("submatrix_9_v2c_to_bs.mem", "w");

	c2v_to_bs[0] = $fopen("submatrix_0_c2v_to_bs.mem", "w");
	c2v_to_bs[1] = $fopen("submatrix_1_c2v_to_bs.mem", "w");
	c2v_to_bs[2] = $fopen("submatrix_2_c2v_to_bs.mem", "w");
	c2v_to_bs[3] = $fopen("submatrix_3_c2v_to_bs.mem", "w");
	c2v_to_bs[4] = $fopen("submatrix_4_c2v_to_bs.mem", "w");
	c2v_to_bs[5] = $fopen("submatrix_5_c2v_to_bs.mem", "w");
	c2v_to_bs[6] = $fopen("submatrix_6_c2v_to_bs.mem", "w");
	c2v_to_bs[7] = $fopen("submatrix_7_c2v_to_bs.mem", "w");
	c2v_to_bs[8] = $fopen("submatrix_8_c2v_to_bs.mem", "w");
	c2v_to_bs[9] = $fopen("submatrix_9_c2v_to_bs.mem", "w");
end
always @(posedge read_clk) begin
	if(decoder_rstn == 1'b1) begin
		if(v2c_bs_en == 1'b1) begin
			$fwrite(v2c_to_bs[0], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_0_unit.v2c_bs_in));
			$fwrite(v2c_to_bs[1], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_1_unit.v2c_bs_in));
			$fwrite(v2c_to_bs[2], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_2_unit.v2c_bs_in));
			$fwrite(v2c_to_bs[3], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_3_unit.v2c_bs_in));
			$fwrite(v2c_to_bs[4], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_4_unit.v2c_bs_in));
			$fwrite(v2c_to_bs[5], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_5_unit.v2c_bs_in));
			$fwrite(v2c_to_bs[6], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_6_unit.v2c_bs_in));
			$fwrite(v2c_to_bs[7], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_7_unit.v2c_bs_in));
			$fwrite(v2c_to_bs[8], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_8_unit.v2c_bs_in));
			$fwrite(v2c_to_bs[9], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_9_unit.v2c_bs_in));
		end
	end
end

always @(posedge read_clk) begin
	if(decoder_rstn == 1'b1) begin
		if(c2v_bs_en == 1'b1) begin
			$fwrite(c2v_to_bs[0], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_0_unit.c2v_bs_in));
			$fwrite(c2v_to_bs[1], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_1_unit.c2v_bs_in));
			$fwrite(c2v_to_bs[2], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_2_unit.c2v_bs_in));
			$fwrite(c2v_to_bs[3], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_3_unit.c2v_bs_in));
			$fwrite(c2v_to_bs[4], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_4_unit.c2v_bs_in));
			$fwrite(c2v_to_bs[5], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_5_unit.c2v_bs_in));
			$fwrite(c2v_to_bs[6], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_6_unit.c2v_bs_in));
			$fwrite(c2v_to_bs[7], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_7_unit.c2v_bs_in));
			$fwrite(c2v_to_bs[8], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_8_unit.c2v_bs_in));
			$fwrite(c2v_to_bs[9], "%h\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_9_unit.c2v_bs_in));
		end
	end
end
/*-----------------------------------------------------------------------------------------------------------------*/
// Log Files of VNU.F1.signExtenOut outgoing to BS
integer signExtenOut_fd [CN_DEGREE-1:0];
initial begin
	signExtenOut_fd[0] = $fopen("signExtenOut_sub0", "w");
	signExtenOut_fd[1] = $fopen("signExtenOut_sub1", "w");
	signExtenOut_fd[2] = $fopen("signExtenOut_sub2", "w");
	signExtenOut_fd[3] = $fopen("signExtenOut_sub3", "w");
	signExtenOut_fd[4] = $fopen("signExtenOut_sub4", "w");
	signExtenOut_fd[5] = $fopen("signExtenOut_sub5", "w");
	signExtenOut_fd[6] = $fopen("signExtenOut_sub6", "w");
	signExtenOut_fd[7] = $fopen("signExtenOut_sub7", "w");
	signExtenOut_fd[8] = $fopen("signExtenOut_sub8", "w");
	signExtenOut_fd[9] = $fopen("signExtenOut_sub9", "w");
end
always @(posedge read_clk) begin
	if(decoder_rstn == 1'b1) begin
		if(inst_vnu_control_unit.layer_cnt[LAYER_NUM-1] == 1'b1 && dnu_inRotate_bs_en == 1'b1) begin
			for(int bitPos=0; bitPos<CHECK_PARALLELISM-1; bitPos=bitPos+1) begin
				$fwrite(signExtenOut_fd[0], "%b,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_0_unit.vnu_qsn_top_85b_0_3.sw_in1_bit0[bitPos]));
				$fwrite(signExtenOut_fd[1], "%b,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_1_unit.inst_shared_qsn_top_85b.sw_in2_bit0[bitPos]));
				$fwrite(signExtenOut_fd[2], "%b,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_2_unit.inst_shared_qsn_top_85b.sw_in2_bit0[bitPos]));
				$fwrite(signExtenOut_fd[3], "%b,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_3_unit.inst_shared_qsn_top_85b.sw_in2_bit0[bitPos]));
				$fwrite(signExtenOut_fd[4], "%b,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_4_unit.inst_shared_qsn_top_85b.sw_in2_bit0[bitPos]));
				$fwrite(signExtenOut_fd[5], "%b,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_5_unit.inst_shared_qsn_top_85b.sw_in2_bit0[bitPos]));
				$fwrite(signExtenOut_fd[6], "%b,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_6_unit.inst_shared_qsn_top_85b.sw_in2_bit0[bitPos]));
				$fwrite(signExtenOut_fd[7], "%b,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_7_unit.inst_shared_qsn_top_85b.sw_in2_bit0[bitPos]));
				$fwrite(signExtenOut_fd[8], "%b,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_8_unit.inst_shared_qsn_top_85b.sw_in2_bit0[bitPos]));
				$fwrite(signExtenOut_fd[9], "%b,", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_9_unit.inst_shared_qsn_top_85b.sw_in2_bit0[bitPos]));
			end
			$fwrite(signExtenOut_fd[0], "%b\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_0_unit.vnu_qsn_top_85b_0_3.sw_in1_bit0[CHECK_PARALLELISM-1]));
			$fwrite(signExtenOut_fd[1], "%b\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_1_unit.inst_shared_qsn_top_85b.sw_in2_bit0[CHECK_PARALLELISM-1]));
			$fwrite(signExtenOut_fd[2], "%b\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_2_unit.inst_shared_qsn_top_85b.sw_in2_bit0[CHECK_PARALLELISM-1]));
			$fwrite(signExtenOut_fd[3], "%b\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_3_unit.inst_shared_qsn_top_85b.sw_in2_bit0[CHECK_PARALLELISM-1]));
			$fwrite(signExtenOut_fd[4], "%b\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_4_unit.inst_shared_qsn_top_85b.sw_in2_bit0[CHECK_PARALLELISM-1]));
			$fwrite(signExtenOut_fd[5], "%b\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_5_unit.inst_shared_qsn_top_85b.sw_in2_bit0[CHECK_PARALLELISM-1]));
			$fwrite(signExtenOut_fd[6], "%b\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_6_unit.inst_shared_qsn_top_85b.sw_in2_bit0[CHECK_PARALLELISM-1]));
			$fwrite(signExtenOut_fd[7], "%b\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_7_unit.inst_shared_qsn_top_85b.sw_in2_bit0[CHECK_PARALLELISM-1]));
			$fwrite(signExtenOut_fd[8], "%b\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_8_unit.inst_shared_qsn_top_85b.sw_in2_bit0[CHECK_PARALLELISM-1]));
			$fwrite(signExtenOut_fd[9], "%b\n", $unsigned(inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_9_unit.inst_shared_qsn_top_85b.sw_in2_bit0[CHECK_PARALLELISM-1]));
		end
	end
end
//		.v2c_outRotate_reg_we (v2c_outRotate_reg_we_propagateIn),
//		.dnu_inRotate_bs_en   (dnu_inRotate_bs_en_propagateIn),
//		.dnu_inRotate_pa_en   (dnu_inRotate_pa_en),
//		.dnu_inRotate_wb      (dnu_inRotate_wb_propagateIn),
//		.dnu_signExten_ram_fetch  (dnu_signExten_ram_fetch_propagateIn),
/*-----------------------------------------------------------------------------------------------------------------*/
// Instantiation of Row Process Elements
/*
	parameter             QUAN_SIZE = 4;
	parameter             CN_DEGREE = 10;
	parameter             VN_DEGREE = 3;
	parameter        CNU_FUNC_CYCLE = 4;
	parameter          VN_ROM_RD_BW = 8;
	parameter        VN_ROM_ADDR_BW = 11;
	parameter       VN_PAGE_ADDR_BW = 6;
	parameter          DN_ROM_RD_BW = 2;
	parameter        DN_ROM_ADDR_BW = 11;
	parameter       DN_PAGE_ADDR_BW = 6;
	parameter  VNU3_INSTANTIATE_NUM = 5;
	parameter VNU3_INSTANTIATE_UNIT = 2;
	parameter              BANK_NUM = 2;
	parameter  IB_VNU_DECOMP_funNum = 2;
	parameter     VN_PIPELINE_DEPTH = 3;
	parameter     DN_PIPELINE_DEPTH = 3;
	parameter       MULTI_FRAME_NUM = 2;
*/
wire         [CN_DEGREE-1:0] hard_decision [0:CHECK_PARALLELISM-1];

//	logic         [QUAN_SIZE-1:0] vnu0_ch_msgIn;
//	logic         [QUAN_SIZE-1:0] vnu1_ch_msgIn;
//	logic         [QUAN_SIZE-1:0] vnu2_ch_msgIn;
//	logic         [QUAN_SIZE-1:0] vnu3_ch_msgIn;
//	logic         [QUAN_SIZE-1:0] vnu4_ch_msgIn;
//	logic         [QUAN_SIZE-1:0] vnu5_ch_msgIn;
//	logic         [QUAN_SIZE-1:0] vnu6_ch_msgIn;
//	logic         [QUAN_SIZE-1:0] vnu7_ch_msgIn;
//	logic         [QUAN_SIZE-1:0] vnu8_ch_msgIn;
//	logic         [QUAN_SIZE-1:0] vnu9_ch_msgIn;
//	logic         [QUAN_SIZE-1:0] cnu_ch_msgIn_0;
//	logic         [QUAN_SIZE-1:0] cnu_ch_msgIn_1;
//	logic         [QUAN_SIZE-1:0] cnu_ch_msgIn_2;
//	logic         [QUAN_SIZE-1:0] cnu_ch_msgIn_3;
//	logic         [QUAN_SIZE-1:0] cnu_ch_msgIn_4;
//	logic         [QUAN_SIZE-1:0] cnu_ch_msgIn_5;
//	logic         [QUAN_SIZE-1:0] cnu_ch_msgIn_6;
//	logic         [QUAN_SIZE-1:0] cnu_ch_msgIn_7;
//	logic         [QUAN_SIZE-1:0] cnu_ch_msgIn_8;
//	logic         [QUAN_SIZE-1:0] cnu_ch_msgIn_9;

	wire         [CN_DEGREE*QUAN_SIZE-1:0] cnuIn_v2c0 [0:CHECK_PARALLELISM-1];
	wire         [CN_DEGREE*QUAN_SIZE-1:0] vnu_post_c2v0 [0:CHECK_PARALLELISM-1];
	wire         [CN_DEGREE-1:0] dnu_signExtenIn [0:CHECK_PARALLELISM-1];

	//logic                         v2c_src;
	//logic                         v2c_latch_en;
	//logic                         c2v_latch_en;
	//logic                   [1:0] load;
	//logic                   [1:0] parallel_en;
	//logic [VN_PAGE_ADDR_BW+1-1:0] vnu_page_addr_ram_0;
	//logic [VN_PAGE_ADDR_BW+1-1:0] vnu_page_addr_ram_1;
	//logic [VN_PAGE_ADDR_BW+1-1:0] vnu_page_addr_ram_2;
	//logic      [VN_ROM_RD_BW-1:0] vnu_ram_write_dataA_0;
	//logic      [VN_ROM_RD_BW-1:0] vnu_ram_write_dataB_0;
	//logic      [VN_ROM_RD_BW-1:0] vnu_ram_write_dataA_1;
	//logic      [VN_ROM_RD_BW-1:0] vnu_ram_write_dataB_1;
	//logic      [DN_ROM_RD_BW-1:0] vnu_ram_write_dataA_2;
	//logic      [DN_ROM_RD_BW-1:0] vnu_ram_write_dataB_2;
	//logic         [VN_DEGREE-1:0] vnu_ib_ram_we;
	//logic                         vn_write_clk;
	//logic                         dn_write_clk;

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

			.read_clk              (read_clk),
			.vnu_read_addr_offset  (1'b0), // for future expansion of mult-frame feature
			.v2c_src               (v2c_src),
			//.v2c_latch_en          (v2c_latch_en),
			//.c2v_latch_en          (c2v_latch_en),
			//.load                  (load),
			//.parallel_en           (parallel_en),
			.rstn                  (decoder_rstn),
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
		assign cnuIn_v2c0[row_pe_id] = {mem_to_cnu_sub[9][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[8][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[7][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[6][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[5][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[4][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[3][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[2][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[1][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_cnu_sub[0][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE]};
		assign vnu_post_c2v0[row_pe_id] = {mem_to_vnu_sub[9][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[8][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[7][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[6][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[5][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[4][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[3][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[2][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[1][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],mem_to_vnu_sub[0][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE]};
		assign dnu_signExtenIn[row_pe_id] = {dnu_signExten_sub[9][row_pe_id],dnu_signExten_sub[8][row_pe_id],dnu_signExten_sub[7][row_pe_id],dnu_signExten_sub[6][row_pe_id],dnu_signExten_sub[5][row_pe_id],dnu_signExten_sub[4][row_pe_id],dnu_signExten_sub[3][row_pe_id],dnu_signExten_sub[2][row_pe_id],dnu_signExten_sub[1][row_pe_id],dnu_signExten_sub[0][row_pe_id]};
		assign ch_to_cnu[row_pe_id] = {ch_to_cnu_sub[9][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[8][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[7][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[6][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[5][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[4][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[3][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[2][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[1][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_cnu_sub[0][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE]};
		assign ch_to_vnu[row_pe_id] = {ch_to_vnu_sub[9][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[8][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[7][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[6][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[5][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[4][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[3][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[2][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[1][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE],ch_to_vnu_sub[0][(row_pe_id+1)*QUAN_SIZE-1:row_pe_id*QUAN_SIZE]};
	end
endgenerate
/*-----------------------------------------------------------------------------------------------------------------*/
// Reset Signal for main decoder module 
// Note that in the first codeword decoding process, 
// the reset signal will be kept asserted until the first codeword is generated, i.e., 
// the timing of first assertion of receivedBlock_generator.tvalid_master
//(* max_fanout = 50 *) reg decoder_rstn; initial decoder_rstn <= 1'b0;
initial decoder_rstn <= 1'b0;
initial decode_termination_reg <= 0;
always @(posedge awgn_gen_clk) begin if(!sys_rstn) decode_termination_reg <= 0; else decode_termination_reg <= iter_termination; end
always @(posedge awgn_gen_clk, negedge sys_rstn) begin
	if(sys_rstn == 1'b0) 
		decoder_rstn <= 1'b0;
	else begin
		if(tvalid_master == 1'b1/* && snr_next_sync == 1'b0*/) decoder_rstn <= 1'b1 && (~decode_termination_reg);
		//else if(tvalid_master == 1'b1 && snr_next_sync == 1'b1) decoder_rstn <= 1'b0 && (~decode_termination_reg);
		//else if(tvalid_master == 1'b0/* && snr_next_sync == 1'b1*/) decoder_rstn <= 1'b0 && (~decode_termination_reg);
		else decoder_rstn <= decoder_rstn && (~decode_termination_reg);
	end
end
/*-----------------------------------------------------------------------------------------------------------------*/
	/*only in testbench*/ reg v2c_mem_fetch_reg0; always @(posedge read_clk) begin v2c_mem_fetch_reg0 <= v2c_mem_fetch; end
	/*only in testbench*/ reg c2v_mem_fetch_reg0; always @(posedge read_clk) begin c2v_mem_fetch_reg0 <= c2v_mem_fetch; end
	/*only in testbench*/ reg v2c_mem_fetch_reg1; always @(posedge read_clk) begin v2c_mem_fetch_reg1 <= v2c_mem_fetch_reg0; end
	/*only in testbench*/ reg c2v_mem_fetch_reg1; always @(posedge read_clk) begin c2v_mem_fetch_reg1 <= c2v_mem_fetch_reg0; end
genvar bs_in_pattern_id;
generate
	for(bs_in_pattern_id=0; bs_in_pattern_id<CN_DEGREE; bs_in_pattern_id=bs_in_pattern_id+1) begin : mem_fetch_log_inst
		// C2V message fetched from C2V MEMs and forworded to VNUs
		always @(posedge read_clk) begin
			if(c2v_mem_fetch_reg1 == 1'b1) begin
				//$fwrite(c2v_mem_fetch_fd,"state_%d (layer: %d, Iter: %d) -> ", $unsigned(inst_vnu_control_unit.state), $unsigned(inst_vnu_control_unit.layer_cnt), $unsigned(inst_vnu_control_unit.iter_cnt));
				$fwrite(c2v_mem_fetch_fd[bs_in_pattern_id], "%h\n", $unsigned(mem_to_vnu_sub[bs_in_pattern_id]));
			end
		end
		// V2C message fetched from V2C MEMs and forworded to CNUs
		always @(posedge read_clk) begin
		if(v2c_mem_fetch_reg1 == 1'b1) begin
				//$fwrite(v2c_mem_fetch_fd,"state_%d (layer: %d, Iter: %d) -> ", $unsigned(inst_cnu_control_unit.state), $unsigned(inst_vnu_control_unit.layer_cnt), $unsigned(inst_vnu_control_unit.iter_cnt));
				$fwrite(v2c_mem_fetch_fd[bs_in_pattern_id], "%h\n", $unsigned(mem_to_cnu_sub[bs_in_pattern_id]));
			end
		end
/*-----------------------------------------------------------------------------------------------------------------*/
		initial begin
			repeat(10)@(posedge read_clk);
			wait(iter_termination == 1'b1);
			repeat(1)@(posedge read_clk);

			$fclose(c2v_pageAlign_tb_fd[bs_in_pattern_id]);
			$fclose(v2c_pageAlign_tb_fd[bs_in_pattern_id]);
			$fclose(v2c_mem_fetch_fd[bs_in_pattern_id]);
			$fclose(c2v_mem_fetch_fd[bs_in_pattern_id]);
			$fclose(signExtenOut_fd[bs_in_pattern_id]);

			$fclose(v2c_to_bs[bs_in_pattern_id]);
			$fclose(c2v_to_bs[bs_in_pattern_id]);
		end
	end
endgenerate
/*-----------------------------------------------------------------------------------------------------------------*/
// Display the Hard Decision
reg [ROW_CHUNK_NUM-1:0] hard_decision_cnt;
initial hard_decision_cnt <= 0;
always @(posedge read_clk) begin
	if(decoder_rstn == 1'b0)
		hard_decision_cnt <= 0;
	else if(inst_vnu_control_unit.layer_cnt[LAYER_NUM-1] == 1'b1 && inst_vnu_control_unit.state == 9)
		hard_decision_cnt <= 1;
	else if(hard_decision_cnt > 0 && hard_decision_cnt[ROW_CHUNK_NUM-1] == 1'b0)
		hard_decision_cnt[ROW_CHUNK_NUM-1:0] <= {hard_decision_cnt[ROW_CHUNK_NUM-2:0], 1'b0};
	else if(hard_decision_cnt[ROW_CHUNK_NUM-1] == 1'b1)
		hard_decision_cnt <= 0;
	else 
		hard_decision_cnt <= hard_decision_cnt;
end
always @(posedge read_clk) begin
	if(decoder_rstn == 1'b0) 
		$write("RESET\n");
	else if(hard_decision_cnt > 0) begin
		$write("Iter_%d, layer_%d, state_%d -> ", $unsigned(inst_vnu_control_unit.iter_cnt), $unsigned(inst_vnu_control_unit.layer_cnt), $unsigned(inst_vnu_control_unit.state));
		for(int a=0; a<CHECK_PARALLELISM; a++) $write("%b", $unsigned(hard_decision[a])); 
		$write("\n");
	end
end
/*-----------------------------------------------------------------------------------------------------------------*/
	initial begin
		// do something
		init();

		repeat(10)@(posedge read_clk);
		wait(iter_termination == 1'b1);
		repeat(1)@(posedge read_clk);
		$finish;
	end
endmodule