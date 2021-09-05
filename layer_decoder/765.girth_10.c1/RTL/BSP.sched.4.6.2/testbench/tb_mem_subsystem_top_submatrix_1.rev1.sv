`timescale 1ns/1ps

`include "define.vh"
module tb_mem_subsystem_top_submatrix_1_rev1 #(
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
	parameter [$clog2(CTRL_FSM_STATE_NUM)-1:0] VNU_IDLE  		   = 10,---------------*/
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
`ifdef SCHED_4_6
	parameter C2V_MEM_ADDR_BASE = 0,
	parameter V2C_MEM_ADDR_BASE = ROW_CHUNK_NUM,
/*-------------------------------------------------------------------------------------*/
	// Parameter for Channel Buffers
	parameter CH_INIT_LOAD_LEVEL = 5, // $ceil(ROW_CHUNK_NUM/WRITE_CLK_RATIO),
	parameter CH_RAM_WB_ADDR_BASE_1_0 = ROW_CHUNK_NUM,
	parameter CH_RAM_WB_ADDR_BASE_1_1 = ROW_CHUNK_NUM*2,
	parameter CH_FETCH_LATENCY = 3,
	parameter CNU_INIT_FETCH_LATENCY = 1,
	parameter CH_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter CH_MSG_NUM = CHECK_PARALLELISM*CN_DEGREE,
	// Parameters of Channel RAM
	parameter CH_RAM_DEPTH = ROW_CHUNK_NUM*LAYER_NUM,
	parameter CH_RAM_ADDR_WIDTH = $clog2(CH_RAM_DEPTH),
/*-------------------------------------------------------------------------------------*/
`endif
	parameter START_PAGE_1_0 = 2, // starting page address of layer 0 of submatrix_1
	parameter START_PAGE_1_1 = 8, // starting page address of layer 1 of submatrix_1
	parameter START_PAGE_1_2 = 1, // starting page address of layer 2 of submatrix_1
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

	// Duplication of all control signals in order to propagate "enable state" to following pipeline stages
	reg [ROW_CHUNK_NUM-2:0] c2v_mem_we_propagate; // the first one has already instantiated by FSM itself
	wire c2v_mem_we; assign c2v_mem_we = (c2v_mem_we_propagate[ROW_CHUNK_NUM-2:0] > 0 || c2v_mem_we_propagateIn > 0) ? 1'b1 : 1'b0;
	//reg c2v_mem_we; always @(posedge read_clk) begin if(!rstn) c2v_mem_we <= 0; else if(c2v_mem_we_propagate[ROW_CHUNK_NUM-2:0] > 0 || c2v_mem_we_propagateIn > 0) c2v_mem_we <= 1; else c2v_mem_we <= 0; end
	always @(posedge read_clk) begin if(!decoder_rstn) c2v_mem_we_propagate <= 0; else c2v_mem_we_propagate[ROW_CHUNK_NUM-2:0] <= {c2v_mem_we_propagate[ROW_CHUNK_NUM-3:0], c2v_mem_we_propagateIn}; end
	reg [ROW_CHUNK_NUM-2:0] c2v_last_row_chunk_propagate; // the first one has already instantiated by FSM itself
	wire c2v_last_row_chunk; assign c2v_last_row_chunk = c2v_last_row_chunk_propagate[ROW_CHUNK_NUM-2];
	always @(posedge read_clk) begin if(!decoder_rstn) c2v_last_row_chunk_propagate <= 0; else c2v_last_row_chunk_propagate[ROW_CHUNK_NUM-2:0] <= {c2v_last_row_chunk_propagate[ROW_CHUNK_NUM-3:0], c2v_pa_en}; end
	reg [ROW_CHUNK_NUM-2:0] c2v_bs_en_propagate;
	always @(posedge read_clk) begin if(!decoder_rstn) c2v_bs_en_propagate <= 0; else c2v_bs_en_propagate[ROW_CHUNK_NUM-2:0] <= {c2v_bs_en_propagate[ROW_CHUNK_NUM-3:0], c2v_bs_en_propagateIn}; end
	reg [ROW_CHUNK_NUM-2:0] v2c_mem_fetch_propagate;
	always @(posedge read_clk) begin if(!decoder_rstn) v2c_mem_fetch_propagate <= 0; else v2c_mem_fetch_propagate[ROW_CHUNK_NUM-2:0] <= {v2c_mem_fetch_propagate[ROW_CHUNK_NUM-3:0], v2c_mem_fetch_propagateIn}; end
	wire v2c_mem_fetch; assign v2c_mem_fetch = (v2c_mem_fetch_propagate > 0 || v2c_mem_fetch_propagateIn > 0) ? 1'b1 : 1'b0;
	cnu_control_unit #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.RESET_CYCLE(RESET_CYCLE),
			.CNU_FUNC_CYCLE(CNU_FUNC_CYCLE),
			.CNU_PIPELINE_LEVEL(CNU_PIPELINE_LEVEL),
			.PERMUTATION_LEVEL(PERMUTATION_LEVEL),
			.PAGE_ALIGN_LEVEL(PAGE_ALIGN_LEVEL),
			.MEM_RD_LEVEL(MEM_RD_LEVEL),
			.FSM_STATE_NUM(FSM_STATE_NUM),
			.INIT_LOAD(INIT_LOAD),
			.MEM_FETCH(MEM_FETCH),
			.VNU_IB_RAM_PEND (VNU_IB_RAM_PEND),
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
		reg c2v_last_row_chunk_reg0;
		reg c2v_last_row_chunk_reg1;
		always @(posedge read_clk) begin
			if(!decoder_rstn)
				c2v_last_row_chunk_reg0 <= 0;
			else
				c2v_last_row_chunk_reg0 <= c2v_last_row_chunk;
		end
		always @(posedge read_clk) begin
			if(!decoder_rstn)
				c2v_last_row_chunk_reg1 <= 0;
			else
				c2v_last_row_chunk_reg1 <= c2v_last_row_chunk_reg0;
		end
/*---------------------------------------------------------------------------------------------------*/
	localparam                 LOAD_HANDSHAKE_LATENCY = 3;
	//localparam                   RESET_CYCLE_BITWIDTH = $clog2(RESET_CYCLE);
	//localparam                      bs_shift_overflow = 2**(PERMUTATION_LEVEL-1);
	//localparam                   fetch_shift_overflow = 2**(MEM_RD_LEVEL-1);
	localparam                     vnu_shift_overflow = 2**(VNU_PIPELINE_LEVEL-1-1);

	wire [`IB_VNU_DECOMP_funNum-1:0] vnu_wr;
	wire                             dnu_wr;
	wire                             v2c_src;
	wire [LAYER_NUM-1:0] 			  v2c_layer_cnt;
	wire 							  v2c_last_layer;
	wire                             v2c_mem_we_propagateIn;
	wire 							 v2c_pa_en;
	wire 						 	 v2c_bs_en_propagateIn;
	wire 							 c2v_mem_fetch_propagateIn;
	wire 							 v2c_outRotate_reg_we_propagateIn;
	wire 							 dnu_inRotate_bs_en_propagateIn;
	wire 							 dnu_inRotate_pa_en_propagateIn;
	wire 							 dnu_inRotate_wb_propagateIn;

	wire ch_ram_init_we_propagateIn;
	//wire ch_bs_en_propagateIn;
	wire ch_pa_en;
	wire ch_ram_wb;

	wire [`IB_VNU_DECOMP_funNum-1:0] vnu_rd;
	wire                             dnu_rd;
	wire [$clog2(CTRL_FSM_STATE_NUM)-1:0] vnu_ctrl_state;
	//wire [$clog2(WR_FSM_STATE_NUM)-1:0]   vnu_wr_state;
	wire                             hard_decision_done;
	logic [`IB_VNU_DECOMP_funNum-1:0] vn_iter_update;
	logic                             dn_iter_update;
	//logic                             layer_finish;
	logic                             iter_termination;
	reg                               fsm_en;

	wire [IB_VNU_DECOMP_funNum-1:0] vn_wr_iter_finish; // to notify the completion of iteration refresh 
	wire dn_wr_iter_finish; // to notify the completion of iteration refresh 
	wire [ITER_ADDR_BW-1:0] vnu_iter_cnt [0:IB_VNU_DECOMP_funNum-1];
	wire [ITER_ADDR_BW-1:0] dnu_iter_cnt;
/*------------------------------------------------------------------------------------------------------------------------------------------*/	
	// Duplication of all control signals in order to propagate "enable state" to following pipeline stages
	reg [ROW_CHUNK_NUM-2:0] v2c_mem_we_propagate; // the first one has already instantiated by FSM itself
	wire v2c_mem_we; assign v2c_mem_we = (v2c_mem_we_propagate[ROW_CHUNK_NUM-2:0] > 0 || v2c_mem_we_propagateIn > 0) ? 1'b1 : 1'b0;
	always @(posedge read_clk) begin if(!decoder_rstn) v2c_mem_we_propagate <= 0; else v2c_mem_we_propagate[ROW_CHUNK_NUM-2:0] <= {v2c_mem_we_propagate[ROW_CHUNK_NUM-3:0], v2c_mem_we_propagateIn}; end
	reg [ROW_CHUNK_NUM-2:0] v2c_last_row_chunk_propagate; // the first one has already instantiated by FSM itself
	wire v2c_last_row_chunk; assign v2c_last_row_chunk = v2c_last_row_chunk_propagate[ROW_CHUNK_NUM-2];
	always @(posedge read_clk) begin if(!decoder_rstn) v2c_last_row_chunk_propagate <= 0; else v2c_last_row_chunk_propagate[ROW_CHUNK_NUM-2:0] <= {v2c_last_row_chunk_propagate[ROW_CHUNK_NUM-3:0], v2c_pa_en}; end	
	reg [ROW_CHUNK_NUM-2:0] v2c_bs_en_propagate;
	always @(posedge read_clk) begin if(!decoder_rstn) v2c_bs_en_propagate <= 0; else v2c_bs_en_propagate[ROW_CHUNK_NUM-2:0] <= {v2c_bs_en_propagate[ROW_CHUNK_NUM-3:0], v2c_bs_en_propagateIn}; end	
	wire v2c_bs_en; assign v2c_bs_en = (v2c_bs_en_propagate > 0 || v2c_bs_en_propagateIn > 0) ? 1'b1 : 1'b0;
	reg [CH_INIT_LOAD_LEVEL-2:0] ch_ram_init_we_propagate;
	always @(posedge read_clk) begin if(!decoder_rstn) ch_ram_init_we_propagate <= 0; else ch_ram_init_we_propagate[CH_INIT_LOAD_LEVEL-2:0] <= {ch_ram_init_we_propagate[CH_INIT_LOAD_LEVEL-3:0], ch_ram_init_we_propagateIn}; end
	wire ch_ram_init_we; assign ch_ram_init_we = (ch_ram_init_we_propagate[CH_INIT_LOAD_LEVEL-2:0] > 0 || ch_ram_init_we_propagateIn > 0) ? 1'b1 : 1'b0;
	//reg ch_bs_en_propagate; always @(posedge read_clk) begin if(!decoder_rstn) ch_bs_en_propagate <= 0; else ch_bs_en_propagate <= ch_bs_en_propagateIn; end
	wire ch_bs_en; //assign ch_bs_en = (ch_bs_en_propagate == 1'b1 || ch_bs_en_propagateIn == 1'b1) ? 1'b1 : 1'b0;
	reg [ROW_CHUNK_NUM-2:0] ch_ram_fetch_propagate;
	always @(posedge read_clk) begin if(!decoder_rstn) ch_ram_fetch_propagate <= 0; else ch_ram_fetch_propagate[ROW_CHUNK_NUM-2:0] <= {ch_ram_fetch_propagate[ROW_CHUNK_NUM-3:0], ch_ram_fetch_propagateIn}; end
	wire ch_ram_fetch; assign ch_ram_fetch = (ch_ram_fetch_propagate > 0 || ch_ram_fetch_propagateIn > 0) ? 1'b1 : 1'b0;
	reg [ROW_CHUNK_NUM-2:0] c2v_mem_fetch_propagate;
	always @(posedge read_clk) begin if(!decoder_rstn) c2v_mem_fetch_propagate <= 0; else c2v_mem_fetch_propagate[ROW_CHUNK_NUM-2:0] <= {c2v_mem_fetch_propagate[ROW_CHUNK_NUM-3:0], c2v_mem_fetch_propagateIn}; end
	wire c2v_mem_fetch; assign c2v_mem_fetch = (c2v_mem_fetch_propagate > 0 || c2v_mem_fetch_propagateIn > 0) ? 1'b1 : 1'b0;
	
	reg [ROW_CHUNK_NUM-2:0] v2c_outRotate_reg_we_propagate; 
	reg [ROW_CHUNK_NUM-2:0] dnu_inRotate_bs_en_propagate;
	reg [ROW_CHUNK_NUM-2:0] dnu_inRotate_pa_en_propagate;
	reg [ROW_CHUNK_NUM-2:0] dnu_inRotate_wb_propagate;
	always @(posedge read_clk) begin if(!decoder_rstn) v2c_outRotate_reg_we_propagate <= 0; else v2c_outRotate_reg_we_propagate[ROW_CHUNK_NUM-2:0] <= {v2c_outRotate_reg_we_propagate[ROW_CHUNK_NUM-3:0], v2c_outRotate_reg_we_propagateIn}; end
	always @(posedge read_clk) begin if(!decoder_rstn) dnu_inRotate_bs_en_propagate <= 0; else dnu_inRotate_bs_en_propagate[ROW_CHUNK_NUM-2:0] <= {dnu_inRotate_bs_en_propagate[ROW_CHUNK_NUM-3:0], dnu_inRotate_bs_en_propagateIn}; end
	always @(posedge read_clk) begin if(!decoder_rstn) dnu_inRotate_pa_en_propagate <= 0; else dnu_inRotate_pa_en_propagate[ROW_CHUNK_NUM-2:0] <= {dnu_inRotate_pa_en_propagate[ROW_CHUNK_NUM-3:0], dnu_inRotate_pa_en_propagateIn}; end
	always @(posedge read_clk) begin if(!decoder_rstn) dnu_inRotate_wb_propagate <= 0; else dnu_inRotate_wb_propagate[ROW_CHUNK_NUM-2:0] <= {dnu_inRotate_wb_propagate[ROW_CHUNK_NUM-3:0], dnu_inRotate_wb_propagateIn}; end
	wire v2c_outRotate_reg_we; assign v2c_outRotate_reg_we = (v2c_outRotate_reg_we_propagate > 0 || v2c_outRotate_reg_we_propagateIn > 0) ? 1'b1 : 1'b0; 
	wire dnu_inRotate_bs_en; assign dnu_inRotate_bs_en = (dnu_inRotate_bs_en_propagate > 0 || dnu_inRotate_bs_en_propagateIn > 0) ? 1'b1 : 1'b0;
	wire dnu_inRotate_pa_en; assign dnu_inRotate_pa_en = (dnu_inRotate_pa_en_propagate > 0 || dnu_inRotate_pa_en_propagateIn > 0) ? 1'b1 : 1'b0;
	wire dnu_inRotate_wb; assign dnu_inRotate_wb = (dnu_inRotate_wb_propagate > 0 || dnu_inRotate_wb_propagateIn > 0) ? 1'b1 : 1'b0;
/*------------------------------------------------------------------------------------------------------------------------------------------*/
	vnu_control_unit #(
		.QUAN_SIZE(QUAN_SIZE),
		.LAYER_NUM(LAYER_NUM),
		.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
		.RESET_CYCLE(RESET_CYCLE),
		.VN_PIPELINE_BUBBLE(VN_PIPELINE_BUBBLE),
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
	    .MEM_FETCH       (VNU_MEM_FETCH      ),  
	    .VNU_PIPE        (VNU_VNU_PIPE       ),        
	    .VNU_OUT         (VNU_VNU_OUT        ),         
	    .BS_WB 	         (VNU_BS_WB          ),	    
	    .PAGE_ALIGN 	 (VNU_PAGE_ALIGN     ),
	    .MEM_WB 		 (VNU_MEM_WB         ),
	    .IDLE  		     (VNU_IDLE           ) 
	) inst_vnu_control_unit (
		.vnu_wr          (vnu_wr),
		.dnu_wr          (dnu_wr),
		.vnu_update_pend (vnu_update_pend),
		.v2c_src         (v2c_src),
		.last_layer      (v2c_last_layer),
		.layer_cnt 		 (v2c_layer_cnt),
		.v2c_mem_we      (v2c_mem_we_propagateIn),
		.v2c_pa_en       (v2c_pa_en),
		.v2c_bs_en 		 (v2c_bs_en_propagateIn),
		.ch_ram_init_we  (ch_ram_init_we_propagateIn),
		.ch_bs_en        (ch_bs_en), //(ch_bs_en_propagateIn),
		.ch_pa_en        (ch_pa_en),
		.ch_ram_wb       (ch_ram_wb),
		.c2v_mem_fetch    (c2v_mem_fetch_propagateIn),
		.ch_ram_fetch    (ch_ram_fetch_propagateIn), // Enable signal of fetching channel buffers
		.layer_finish    (layer_finish),

		.v2c_outRotate_reg_we (v2c_outRotate_reg_we_propagateIn),
		.dnu_inRotate_bs_en   (dnu_inRotate_bs_en_propagateIn),
		.dnu_inRotate_pa_en   (dnu_inRotate_pa_en_propagateIn),
		.dnu_inRotate_wb      (dnu_inRotate_wb_propagateIn),

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

	reg v2c_last_row_chunk_reg0;
	reg v2c_last_row_chunk_reg1;
	always @(posedge read_clk) begin
		if(!decoder_rstn)
			v2c_last_row_chunk_reg0 <= 0;
		else
			v2c_last_row_chunk_reg0 <= v2c_last_row_chunk;
	end
	always @(posedge read_clk) begin
		if(!decoder_rstn)
			v2c_last_row_chunk_reg1 <= 0;
		else
			v2c_last_row_chunk_reg1 <= v2c_last_row_chunk_reg0;
	end
/*---------------------------------------------------------------------*/
// Instantiation of Write.FSMs (for simulation only)
wire [IB_VNU_DECOMP_funNum-1:0] vn_rom_port_fetch; // to enable the ib-map starting to fetch data from read port of IB ROM
wire [IB_VNU_DECOMP_funNum-1:0] vn_ram_write_en;
wire [IB_VNU_DECOMP_funNum-1:0] vn_ram_mux_en;
wire [IB_VNU_DECOMP_funNum-1:0] vn_iter_update;
wire [IB_VNU_DECOMP_funNum-1:0] v3ib_rom_rst;
wire [IB_VNU_DECOMP_funNum-1:0] vn_write_busy;
wire [IB_VNU_DECOMP_funNum-1:0] vn_iter_switch;
wire dn_iter_switch;
//////////////////////////////////////////////////////////////////////////////////////////////////////
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
	//logic [QUAN_SIZE-1:0] msgIn_pattern [0:CHECK_PARALLELISM*9*LAYER_NUM-1];
	
	logic [QUAN_SIZE-1:0] vnBsIn_pattern [CHECK_PARALLELISM*ROW_CHUNK_NUM*LAYER_NUM-1:0];
	initial begin
		$readmemh("/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/layer_decoder/layer_decoder_solution/submatrix_1_v2c_bs_in.mem", vnBsIn_pattern);
	end

	integer pageAlign_tb_fd;
	//integer pageAlignIn_tb_fd;
	initial begin
		pageAlign_tb_fd = $fopen("pageAlign_result_submatrix_1", "w");
		//pageAlignIn_tb_fd = $fopen("pageAlign_in_submatrix_1", "w");
	end

	// (*NOTE*) replace reset, clock, others
	
	//wire         [QUAN_SIZE-1:0] mem_to_cnu [0:CHECK_PARALLELISM-1];
	//wire         [QUAN_SIZE-1:0] mem_to_vnu [0:CHECK_PARALLELISM-1];
	wire [QUAN_SIZE-1:0] vnu_msg_in [0:CHECK_PARALLELISM-1];
	wire [QUAN_SIZE-1:0] cnu_msg_in [0:CHECK_PARALLELISM-1];
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

	wire [6:0]  cnu_left_sel;
	wire [6:0]  cnu_right_sel;
	wire [83:0] cnu_merge_sel;
	wire [6:0]  vnu_left_sel;
	wire [6:0]  vnu_right_sel;
	wire [83:0] vnu_merge_sel;
	logic [CHECK_PARALLELISM-1:0] cnu_bs_in_bit [0:QUAN_SIZE-1];
	logic [CHECK_PARALLELISM-1:0] vnu_bs_in_bit [0:QUAN_SIZE-1];
	initial begin
		// For ease of verification, cnu and vnu are using identical set of test patterns
		cnu_bs_in_bit[0] <= {vnBsIn_pattern[84][0],vnBsIn_pattern[83][0],vnBsIn_pattern[82][0],vnBsIn_pattern[81][0],vnBsIn_pattern[80][0],vnBsIn_pattern[79][0],vnBsIn_pattern[78][0],vnBsIn_pattern[77][0],vnBsIn_pattern[76][0],vnBsIn_pattern[75][0],vnBsIn_pattern[74][0],vnBsIn_pattern[73][0],vnBsIn_pattern[72][0],vnBsIn_pattern[71][0],vnBsIn_pattern[70][0],vnBsIn_pattern[69][0],vnBsIn_pattern[68][0],vnBsIn_pattern[67][0],vnBsIn_pattern[66][0],vnBsIn_pattern[65][0],vnBsIn_pattern[64][0],vnBsIn_pattern[63][0],vnBsIn_pattern[62][0],vnBsIn_pattern[61][0],vnBsIn_pattern[60][0],vnBsIn_pattern[59][0],vnBsIn_pattern[58][0],vnBsIn_pattern[57][0],vnBsIn_pattern[56][0],vnBsIn_pattern[55][0],vnBsIn_pattern[54][0],vnBsIn_pattern[53][0],vnBsIn_pattern[52][0],vnBsIn_pattern[51][0],vnBsIn_pattern[50][0],vnBsIn_pattern[49][0],vnBsIn_pattern[48][0],vnBsIn_pattern[47][0],vnBsIn_pattern[46][0],vnBsIn_pattern[45][0],vnBsIn_pattern[44][0],vnBsIn_pattern[43][0],vnBsIn_pattern[42][0],vnBsIn_pattern[41][0],vnBsIn_pattern[40][0],vnBsIn_pattern[39][0],vnBsIn_pattern[38][0],vnBsIn_pattern[37][0],vnBsIn_pattern[36][0],vnBsIn_pattern[35][0],vnBsIn_pattern[34][0],vnBsIn_pattern[33][0],vnBsIn_pattern[32][0],vnBsIn_pattern[31][0],vnBsIn_pattern[30][0],vnBsIn_pattern[29][0],vnBsIn_pattern[28][0],vnBsIn_pattern[27][0],vnBsIn_pattern[26][0],vnBsIn_pattern[25][0],vnBsIn_pattern[24][0],vnBsIn_pattern[23][0],vnBsIn_pattern[22][0],vnBsIn_pattern[21][0],vnBsIn_pattern[20][0],vnBsIn_pattern[19][0],vnBsIn_pattern[18][0],vnBsIn_pattern[17][0],vnBsIn_pattern[16][0],vnBsIn_pattern[15][0],vnBsIn_pattern[14][0],vnBsIn_pattern[13][0],vnBsIn_pattern[12][0],vnBsIn_pattern[11][0],vnBsIn_pattern[10][0],vnBsIn_pattern[9][0],vnBsIn_pattern[8][0],vnBsIn_pattern[7][0],vnBsIn_pattern[6][0],vnBsIn_pattern[5][0],vnBsIn_pattern[4][0],vnBsIn_pattern[3][0],vnBsIn_pattern[2][0],vnBsIn_pattern[1][0],vnBsIn_pattern[0][0]};
		cnu_bs_in_bit[1] <= {vnBsIn_pattern[84][1],vnBsIn_pattern[83][1],vnBsIn_pattern[82][1],vnBsIn_pattern[81][1],vnBsIn_pattern[80][1],vnBsIn_pattern[79][1],vnBsIn_pattern[78][1],vnBsIn_pattern[77][1],vnBsIn_pattern[76][1],vnBsIn_pattern[75][1],vnBsIn_pattern[74][1],vnBsIn_pattern[73][1],vnBsIn_pattern[72][1],vnBsIn_pattern[71][1],vnBsIn_pattern[70][1],vnBsIn_pattern[69][1],vnBsIn_pattern[68][1],vnBsIn_pattern[67][1],vnBsIn_pattern[66][1],vnBsIn_pattern[65][1],vnBsIn_pattern[64][1],vnBsIn_pattern[63][1],vnBsIn_pattern[62][1],vnBsIn_pattern[61][1],vnBsIn_pattern[60][1],vnBsIn_pattern[59][1],vnBsIn_pattern[58][1],vnBsIn_pattern[57][1],vnBsIn_pattern[56][1],vnBsIn_pattern[55][1],vnBsIn_pattern[54][1],vnBsIn_pattern[53][1],vnBsIn_pattern[52][1],vnBsIn_pattern[51][1],vnBsIn_pattern[50][1],vnBsIn_pattern[49][1],vnBsIn_pattern[48][1],vnBsIn_pattern[47][1],vnBsIn_pattern[46][1],vnBsIn_pattern[45][1],vnBsIn_pattern[44][1],vnBsIn_pattern[43][1],vnBsIn_pattern[42][1],vnBsIn_pattern[41][1],vnBsIn_pattern[40][1],vnBsIn_pattern[39][1],vnBsIn_pattern[38][1],vnBsIn_pattern[37][1],vnBsIn_pattern[36][1],vnBsIn_pattern[35][1],vnBsIn_pattern[34][1],vnBsIn_pattern[33][1],vnBsIn_pattern[32][1],vnBsIn_pattern[31][1],vnBsIn_pattern[30][1],vnBsIn_pattern[29][1],vnBsIn_pattern[28][1],vnBsIn_pattern[27][1],vnBsIn_pattern[26][1],vnBsIn_pattern[25][1],vnBsIn_pattern[24][1],vnBsIn_pattern[23][1],vnBsIn_pattern[22][1],vnBsIn_pattern[21][1],vnBsIn_pattern[20][1],vnBsIn_pattern[19][1],vnBsIn_pattern[18][1],vnBsIn_pattern[17][1],vnBsIn_pattern[16][1],vnBsIn_pattern[15][1],vnBsIn_pattern[14][1],vnBsIn_pattern[13][1],vnBsIn_pattern[12][1],vnBsIn_pattern[11][1],vnBsIn_pattern[10][1],vnBsIn_pattern[9][1],vnBsIn_pattern[8][1],vnBsIn_pattern[7][1],vnBsIn_pattern[6][1],vnBsIn_pattern[5][1],vnBsIn_pattern[4][1],vnBsIn_pattern[3][1],vnBsIn_pattern[2][1],vnBsIn_pattern[1][1],vnBsIn_pattern[0][1]};
		cnu_bs_in_bit[2] <= {vnBsIn_pattern[84][2],vnBsIn_pattern[83][2],vnBsIn_pattern[82][2],vnBsIn_pattern[81][2],vnBsIn_pattern[80][2],vnBsIn_pattern[79][2],vnBsIn_pattern[78][2],vnBsIn_pattern[77][2],vnBsIn_pattern[76][2],vnBsIn_pattern[75][2],vnBsIn_pattern[74][2],vnBsIn_pattern[73][2],vnBsIn_pattern[72][2],vnBsIn_pattern[71][2],vnBsIn_pattern[70][2],vnBsIn_pattern[69][2],vnBsIn_pattern[68][2],vnBsIn_pattern[67][2],vnBsIn_pattern[66][2],vnBsIn_pattern[65][2],vnBsIn_pattern[64][2],vnBsIn_pattern[63][2],vnBsIn_pattern[62][2],vnBsIn_pattern[61][2],vnBsIn_pattern[60][2],vnBsIn_pattern[59][2],vnBsIn_pattern[58][2],vnBsIn_pattern[57][2],vnBsIn_pattern[56][2],vnBsIn_pattern[55][2],vnBsIn_pattern[54][2],vnBsIn_pattern[53][2],vnBsIn_pattern[52][2],vnBsIn_pattern[51][2],vnBsIn_pattern[50][2],vnBsIn_pattern[49][2],vnBsIn_pattern[48][2],vnBsIn_pattern[47][2],vnBsIn_pattern[46][2],vnBsIn_pattern[45][2],vnBsIn_pattern[44][2],vnBsIn_pattern[43][2],vnBsIn_pattern[42][2],vnBsIn_pattern[41][2],vnBsIn_pattern[40][2],vnBsIn_pattern[39][2],vnBsIn_pattern[38][2],vnBsIn_pattern[37][2],vnBsIn_pattern[36][2],vnBsIn_pattern[35][2],vnBsIn_pattern[34][2],vnBsIn_pattern[33][2],vnBsIn_pattern[32][2],vnBsIn_pattern[31][2],vnBsIn_pattern[30][2],vnBsIn_pattern[29][2],vnBsIn_pattern[28][2],vnBsIn_pattern[27][2],vnBsIn_pattern[26][2],vnBsIn_pattern[25][2],vnBsIn_pattern[24][2],vnBsIn_pattern[23][2],vnBsIn_pattern[22][2],vnBsIn_pattern[21][2],vnBsIn_pattern[20][2],vnBsIn_pattern[19][2],vnBsIn_pattern[18][2],vnBsIn_pattern[17][2],vnBsIn_pattern[16][2],vnBsIn_pattern[15][2],vnBsIn_pattern[14][2],vnBsIn_pattern[13][2],vnBsIn_pattern[12][2],vnBsIn_pattern[11][2],vnBsIn_pattern[10][2],vnBsIn_pattern[9][2],vnBsIn_pattern[8][2],vnBsIn_pattern[7][2],vnBsIn_pattern[6][2],vnBsIn_pattern[5][2],vnBsIn_pattern[4][2],vnBsIn_pattern[3][2],vnBsIn_pattern[2][2],vnBsIn_pattern[1][2],vnBsIn_pattern[0][2]};
		cnu_bs_in_bit[3] <= {vnBsIn_pattern[84][3],vnBsIn_pattern[83][3],vnBsIn_pattern[82][3],vnBsIn_pattern[81][3],vnBsIn_pattern[80][3],vnBsIn_pattern[79][3],vnBsIn_pattern[78][3],vnBsIn_pattern[77][3],vnBsIn_pattern[76][3],vnBsIn_pattern[75][3],vnBsIn_pattern[74][3],vnBsIn_pattern[73][3],vnBsIn_pattern[72][3],vnBsIn_pattern[71][3],vnBsIn_pattern[70][3],vnBsIn_pattern[69][3],vnBsIn_pattern[68][3],vnBsIn_pattern[67][3],vnBsIn_pattern[66][3],vnBsIn_pattern[65][3],vnBsIn_pattern[64][3],vnBsIn_pattern[63][3],vnBsIn_pattern[62][3],vnBsIn_pattern[61][3],vnBsIn_pattern[60][3],vnBsIn_pattern[59][3],vnBsIn_pattern[58][3],vnBsIn_pattern[57][3],vnBsIn_pattern[56][3],vnBsIn_pattern[55][3],vnBsIn_pattern[54][3],vnBsIn_pattern[53][3],vnBsIn_pattern[52][3],vnBsIn_pattern[51][3],vnBsIn_pattern[50][3],vnBsIn_pattern[49][3],vnBsIn_pattern[48][3],vnBsIn_pattern[47][3],vnBsIn_pattern[46][3],vnBsIn_pattern[45][3],vnBsIn_pattern[44][3],vnBsIn_pattern[43][3],vnBsIn_pattern[42][3],vnBsIn_pattern[41][3],vnBsIn_pattern[40][3],vnBsIn_pattern[39][3],vnBsIn_pattern[38][3],vnBsIn_pattern[37][3],vnBsIn_pattern[36][3],vnBsIn_pattern[35][3],vnBsIn_pattern[34][3],vnBsIn_pattern[33][3],vnBsIn_pattern[32][3],vnBsIn_pattern[31][3],vnBsIn_pattern[30][3],vnBsIn_pattern[29][3],vnBsIn_pattern[28][3],vnBsIn_pattern[27][3],vnBsIn_pattern[26][3],vnBsIn_pattern[25][3],vnBsIn_pattern[24][3],vnBsIn_pattern[23][3],vnBsIn_pattern[22][3],vnBsIn_pattern[21][3],vnBsIn_pattern[20][3],vnBsIn_pattern[19][3],vnBsIn_pattern[18][3],vnBsIn_pattern[17][3],vnBsIn_pattern[16][3],vnBsIn_pattern[15][3],vnBsIn_pattern[14][3],vnBsIn_pattern[13][3],vnBsIn_pattern[12][3],vnBsIn_pattern[11][3],vnBsIn_pattern[10][3],vnBsIn_pattern[9][3],vnBsIn_pattern[8][3],vnBsIn_pattern[7][3],vnBsIn_pattern[6][3],vnBsIn_pattern[5][3],vnBsIn_pattern[4][3],vnBsIn_pattern[3][3],vnBsIn_pattern[2][3],vnBsIn_pattern[1][3],vnBsIn_pattern[0][3]};
	end
/*----------------------------------------------*/	
// Circular shifter of check nodes 
qsn_top_85b cnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({cnu_msg_in[84][0],cnu_msg_in[83][0],cnu_msg_in[82][0],cnu_msg_in[81][0],cnu_msg_in[80][0],cnu_msg_in[79][0],cnu_msg_in[78][0],cnu_msg_in[77][0],cnu_msg_in[76][0],cnu_msg_in[75][0],cnu_msg_in[74][0],cnu_msg_in[73][0],cnu_msg_in[72][0],cnu_msg_in[71][0],cnu_msg_in[70][0],cnu_msg_in[69][0],cnu_msg_in[68][0],cnu_msg_in[67][0],cnu_msg_in[66][0],cnu_msg_in[65][0],cnu_msg_in[64][0],cnu_msg_in[63][0],cnu_msg_in[62][0],cnu_msg_in[61][0],cnu_msg_in[60][0],cnu_msg_in[59][0],cnu_msg_in[58][0],cnu_msg_in[57][0],cnu_msg_in[56][0],cnu_msg_in[55][0],cnu_msg_in[54][0],cnu_msg_in[53][0],cnu_msg_in[52][0],cnu_msg_in[51][0],cnu_msg_in[50][0],cnu_msg_in[49][0],cnu_msg_in[48][0],cnu_msg_in[47][0],cnu_msg_in[46][0],cnu_msg_in[45][0],cnu_msg_in[44][0],cnu_msg_in[43][0],cnu_msg_in[42][0],cnu_msg_in[41][0],cnu_msg_in[40][0],cnu_msg_in[39][0],cnu_msg_in[38][0],cnu_msg_in[37][0],cnu_msg_in[36][0],cnu_msg_in[35][0],cnu_msg_in[34][0],cnu_msg_in[33][0],cnu_msg_in[32][0],cnu_msg_in[31][0],cnu_msg_in[30][0],cnu_msg_in[29][0],cnu_msg_in[28][0],cnu_msg_in[27][0],cnu_msg_in[26][0],cnu_msg_in[25][0],cnu_msg_in[24][0],cnu_msg_in[23][0],cnu_msg_in[22][0],cnu_msg_in[21][0],cnu_msg_in[20][0],cnu_msg_in[19][0],cnu_msg_in[18][0],cnu_msg_in[17][0],cnu_msg_in[16][0],cnu_msg_in[15][0],cnu_msg_in[14][0],cnu_msg_in[13][0],cnu_msg_in[12][0],cnu_msg_in[11][0],cnu_msg_in[10][0],cnu_msg_in[9][0],cnu_msg_in[8][0],cnu_msg_in[7][0],cnu_msg_in[6][0],cnu_msg_in[5][0],cnu_msg_in[4][0],cnu_msg_in[3][0],cnu_msg_in[2][0],cnu_msg_in[1][0],cnu_msg_in[0][0]}),
	.sw_out_bit1 ({cnu_msg_in[84][1],cnu_msg_in[83][1],cnu_msg_in[82][1],cnu_msg_in[81][1],cnu_msg_in[80][1],cnu_msg_in[79][1],cnu_msg_in[78][1],cnu_msg_in[77][1],cnu_msg_in[76][1],cnu_msg_in[75][1],cnu_msg_in[74][1],cnu_msg_in[73][1],cnu_msg_in[72][1],cnu_msg_in[71][1],cnu_msg_in[70][1],cnu_msg_in[69][1],cnu_msg_in[68][1],cnu_msg_in[67][1],cnu_msg_in[66][1],cnu_msg_in[65][1],cnu_msg_in[64][1],cnu_msg_in[63][1],cnu_msg_in[62][1],cnu_msg_in[61][1],cnu_msg_in[60][1],cnu_msg_in[59][1],cnu_msg_in[58][1],cnu_msg_in[57][1],cnu_msg_in[56][1],cnu_msg_in[55][1],cnu_msg_in[54][1],cnu_msg_in[53][1],cnu_msg_in[52][1],cnu_msg_in[51][1],cnu_msg_in[50][1],cnu_msg_in[49][1],cnu_msg_in[48][1],cnu_msg_in[47][1],cnu_msg_in[46][1],cnu_msg_in[45][1],cnu_msg_in[44][1],cnu_msg_in[43][1],cnu_msg_in[42][1],cnu_msg_in[41][1],cnu_msg_in[40][1],cnu_msg_in[39][1],cnu_msg_in[38][1],cnu_msg_in[37][1],cnu_msg_in[36][1],cnu_msg_in[35][1],cnu_msg_in[34][1],cnu_msg_in[33][1],cnu_msg_in[32][1],cnu_msg_in[31][1],cnu_msg_in[30][1],cnu_msg_in[29][1],cnu_msg_in[28][1],cnu_msg_in[27][1],cnu_msg_in[26][1],cnu_msg_in[25][1],cnu_msg_in[24][1],cnu_msg_in[23][1],cnu_msg_in[22][1],cnu_msg_in[21][1],cnu_msg_in[20][1],cnu_msg_in[19][1],cnu_msg_in[18][1],cnu_msg_in[17][1],cnu_msg_in[16][1],cnu_msg_in[15][1],cnu_msg_in[14][1],cnu_msg_in[13][1],cnu_msg_in[12][1],cnu_msg_in[11][1],cnu_msg_in[10][1],cnu_msg_in[9][1],cnu_msg_in[8][1],cnu_msg_in[7][1],cnu_msg_in[6][1],cnu_msg_in[5][1],cnu_msg_in[4][1],cnu_msg_in[3][1],cnu_msg_in[2][1],cnu_msg_in[1][1],cnu_msg_in[0][1]}),
	.sw_out_bit2 ({cnu_msg_in[84][2],cnu_msg_in[83][2],cnu_msg_in[82][2],cnu_msg_in[81][2],cnu_msg_in[80][2],cnu_msg_in[79][2],cnu_msg_in[78][2],cnu_msg_in[77][2],cnu_msg_in[76][2],cnu_msg_in[75][2],cnu_msg_in[74][2],cnu_msg_in[73][2],cnu_msg_in[72][2],cnu_msg_in[71][2],cnu_msg_in[70][2],cnu_msg_in[69][2],cnu_msg_in[68][2],cnu_msg_in[67][2],cnu_msg_in[66][2],cnu_msg_in[65][2],cnu_msg_in[64][2],cnu_msg_in[63][2],cnu_msg_in[62][2],cnu_msg_in[61][2],cnu_msg_in[60][2],cnu_msg_in[59][2],cnu_msg_in[58][2],cnu_msg_in[57][2],cnu_msg_in[56][2],cnu_msg_in[55][2],cnu_msg_in[54][2],cnu_msg_in[53][2],cnu_msg_in[52][2],cnu_msg_in[51][2],cnu_msg_in[50][2],cnu_msg_in[49][2],cnu_msg_in[48][2],cnu_msg_in[47][2],cnu_msg_in[46][2],cnu_msg_in[45][2],cnu_msg_in[44][2],cnu_msg_in[43][2],cnu_msg_in[42][2],cnu_msg_in[41][2],cnu_msg_in[40][2],cnu_msg_in[39][2],cnu_msg_in[38][2],cnu_msg_in[37][2],cnu_msg_in[36][2],cnu_msg_in[35][2],cnu_msg_in[34][2],cnu_msg_in[33][2],cnu_msg_in[32][2],cnu_msg_in[31][2],cnu_msg_in[30][2],cnu_msg_in[29][2],cnu_msg_in[28][2],cnu_msg_in[27][2],cnu_msg_in[26][2],cnu_msg_in[25][2],cnu_msg_in[24][2],cnu_msg_in[23][2],cnu_msg_in[22][2],cnu_msg_in[21][2],cnu_msg_in[20][2],cnu_msg_in[19][2],cnu_msg_in[18][2],cnu_msg_in[17][2],cnu_msg_in[16][2],cnu_msg_in[15][2],cnu_msg_in[14][2],cnu_msg_in[13][2],cnu_msg_in[12][2],cnu_msg_in[11][2],cnu_msg_in[10][2],cnu_msg_in[9][2],cnu_msg_in[8][2],cnu_msg_in[7][2],cnu_msg_in[6][2],cnu_msg_in[5][2],cnu_msg_in[4][2],cnu_msg_in[3][2],cnu_msg_in[2][2],cnu_msg_in[1][2],cnu_msg_in[0][2]}),	
	.sw_out_bit3 ({cnu_msg_in[84][3],cnu_msg_in[83][3],cnu_msg_in[82][3],cnu_msg_in[81][3],cnu_msg_in[80][3],cnu_msg_in[79][3],cnu_msg_in[78][3],cnu_msg_in[77][3],cnu_msg_in[76][3],cnu_msg_in[75][3],cnu_msg_in[74][3],cnu_msg_in[73][3],cnu_msg_in[72][3],cnu_msg_in[71][3],cnu_msg_in[70][3],cnu_msg_in[69][3],cnu_msg_in[68][3],cnu_msg_in[67][3],cnu_msg_in[66][3],cnu_msg_in[65][3],cnu_msg_in[64][3],cnu_msg_in[63][3],cnu_msg_in[62][3],cnu_msg_in[61][3],cnu_msg_in[60][3],cnu_msg_in[59][3],cnu_msg_in[58][3],cnu_msg_in[57][3],cnu_msg_in[56][3],cnu_msg_in[55][3],cnu_msg_in[54][3],cnu_msg_in[53][3],cnu_msg_in[52][3],cnu_msg_in[51][3],cnu_msg_in[50][3],cnu_msg_in[49][3],cnu_msg_in[48][3],cnu_msg_in[47][3],cnu_msg_in[46][3],cnu_msg_in[45][3],cnu_msg_in[44][3],cnu_msg_in[43][3],cnu_msg_in[42][3],cnu_msg_in[41][3],cnu_msg_in[40][3],cnu_msg_in[39][3],cnu_msg_in[38][3],cnu_msg_in[37][3],cnu_msg_in[36][3],cnu_msg_in[35][3],cnu_msg_in[34][3],cnu_msg_in[33][3],cnu_msg_in[32][3],cnu_msg_in[31][3],cnu_msg_in[30][3],cnu_msg_in[29][3],cnu_msg_in[28][3],cnu_msg_in[27][3],cnu_msg_in[26][3],cnu_msg_in[25][3],cnu_msg_in[24][3],cnu_msg_in[23][3],cnu_msg_in[22][3],cnu_msg_in[21][3],cnu_msg_in[20][3],cnu_msg_in[19][3],cnu_msg_in[18][3],cnu_msg_in[17][3],cnu_msg_in[16][3],cnu_msg_in[15][3],cnu_msg_in[14][3],cnu_msg_in[13][3],cnu_msg_in[12][3],cnu_msg_in[11][3],cnu_msg_in[10][3],cnu_msg_in[9][3],cnu_msg_in[8][3],cnu_msg_in[7][3],cnu_msg_in[6][3],cnu_msg_in[5][3],cnu_msg_in[4][3],cnu_msg_in[3][3],cnu_msg_in[2][3],cnu_msg_in[1][3],cnu_msg_in[0][3]}),
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (decoder_rstn),
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
	.rstn         (decoder_rstn),
	.sys_clk      (read_clk)
);
/*----------------------------------------------*/
// Circular shifter of variable nodes 
qsn_top_85b vnu_qsn_top_85b_0_3 (
	.sw_out_bit0 ({vnu_msg_in[84][0],vnu_msg_in[83][0],vnu_msg_in[82][0],vnu_msg_in[81][0],vnu_msg_in[80][0],vnu_msg_in[79][0],vnu_msg_in[78][0],vnu_msg_in[77][0],vnu_msg_in[76][0],vnu_msg_in[75][0],vnu_msg_in[74][0],vnu_msg_in[73][0],vnu_msg_in[72][0],vnu_msg_in[71][0],vnu_msg_in[70][0],vnu_msg_in[69][0],vnu_msg_in[68][0],vnu_msg_in[67][0],vnu_msg_in[66][0],vnu_msg_in[65][0],vnu_msg_in[64][0],vnu_msg_in[63][0],vnu_msg_in[62][0],vnu_msg_in[61][0],vnu_msg_in[60][0],vnu_msg_in[59][0],vnu_msg_in[58][0],vnu_msg_in[57][0],vnu_msg_in[56][0],vnu_msg_in[55][0],vnu_msg_in[54][0],vnu_msg_in[53][0],vnu_msg_in[52][0],vnu_msg_in[51][0],vnu_msg_in[50][0],vnu_msg_in[49][0],vnu_msg_in[48][0],vnu_msg_in[47][0],vnu_msg_in[46][0],vnu_msg_in[45][0],vnu_msg_in[44][0],vnu_msg_in[43][0],vnu_msg_in[42][0],vnu_msg_in[41][0],vnu_msg_in[40][0],vnu_msg_in[39][0],vnu_msg_in[38][0],vnu_msg_in[37][0],vnu_msg_in[36][0],vnu_msg_in[35][0],vnu_msg_in[34][0],vnu_msg_in[33][0],vnu_msg_in[32][0],vnu_msg_in[31][0],vnu_msg_in[30][0],vnu_msg_in[29][0],vnu_msg_in[28][0],vnu_msg_in[27][0],vnu_msg_in[26][0],vnu_msg_in[25][0],vnu_msg_in[24][0],vnu_msg_in[23][0],vnu_msg_in[22][0],vnu_msg_in[21][0],vnu_msg_in[20][0],vnu_msg_in[19][0],vnu_msg_in[18][0],vnu_msg_in[17][0],vnu_msg_in[16][0],vnu_msg_in[15][0],vnu_msg_in[14][0],vnu_msg_in[13][0],vnu_msg_in[12][0],vnu_msg_in[11][0],vnu_msg_in[10][0],vnu_msg_in[9][0],vnu_msg_in[8][0],vnu_msg_in[7][0],vnu_msg_in[6][0],vnu_msg_in[5][0],vnu_msg_in[4][0],vnu_msg_in[3][0],vnu_msg_in[2][0],vnu_msg_in[1][0],vnu_msg_in[0][0]}),
	.sw_out_bit1 ({vnu_msg_in[84][1],vnu_msg_in[83][1],vnu_msg_in[82][1],vnu_msg_in[81][1],vnu_msg_in[80][1],vnu_msg_in[79][1],vnu_msg_in[78][1],vnu_msg_in[77][1],vnu_msg_in[76][1],vnu_msg_in[75][1],vnu_msg_in[74][1],vnu_msg_in[73][1],vnu_msg_in[72][1],vnu_msg_in[71][1],vnu_msg_in[70][1],vnu_msg_in[69][1],vnu_msg_in[68][1],vnu_msg_in[67][1],vnu_msg_in[66][1],vnu_msg_in[65][1],vnu_msg_in[64][1],vnu_msg_in[63][1],vnu_msg_in[62][1],vnu_msg_in[61][1],vnu_msg_in[60][1],vnu_msg_in[59][1],vnu_msg_in[58][1],vnu_msg_in[57][1],vnu_msg_in[56][1],vnu_msg_in[55][1],vnu_msg_in[54][1],vnu_msg_in[53][1],vnu_msg_in[52][1],vnu_msg_in[51][1],vnu_msg_in[50][1],vnu_msg_in[49][1],vnu_msg_in[48][1],vnu_msg_in[47][1],vnu_msg_in[46][1],vnu_msg_in[45][1],vnu_msg_in[44][1],vnu_msg_in[43][1],vnu_msg_in[42][1],vnu_msg_in[41][1],vnu_msg_in[40][1],vnu_msg_in[39][1],vnu_msg_in[38][1],vnu_msg_in[37][1],vnu_msg_in[36][1],vnu_msg_in[35][1],vnu_msg_in[34][1],vnu_msg_in[33][1],vnu_msg_in[32][1],vnu_msg_in[31][1],vnu_msg_in[30][1],vnu_msg_in[29][1],vnu_msg_in[28][1],vnu_msg_in[27][1],vnu_msg_in[26][1],vnu_msg_in[25][1],vnu_msg_in[24][1],vnu_msg_in[23][1],vnu_msg_in[22][1],vnu_msg_in[21][1],vnu_msg_in[20][1],vnu_msg_in[19][1],vnu_msg_in[18][1],vnu_msg_in[17][1],vnu_msg_in[16][1],vnu_msg_in[15][1],vnu_msg_in[14][1],vnu_msg_in[13][1],vnu_msg_in[12][1],vnu_msg_in[11][1],vnu_msg_in[10][1],vnu_msg_in[9][1],vnu_msg_in[8][1],vnu_msg_in[7][1],vnu_msg_in[6][1],vnu_msg_in[5][1],vnu_msg_in[4][1],vnu_msg_in[3][1],vnu_msg_in[2][1],vnu_msg_in[1][1],vnu_msg_in[0][1]}),	
	.sw_out_bit2 ({vnu_msg_in[84][2],vnu_msg_in[83][2],vnu_msg_in[82][2],vnu_msg_in[81][2],vnu_msg_in[80][2],vnu_msg_in[79][2],vnu_msg_in[78][2],vnu_msg_in[77][2],vnu_msg_in[76][2],vnu_msg_in[75][2],vnu_msg_in[74][2],vnu_msg_in[73][2],vnu_msg_in[72][2],vnu_msg_in[71][2],vnu_msg_in[70][2],vnu_msg_in[69][2],vnu_msg_in[68][2],vnu_msg_in[67][2],vnu_msg_in[66][2],vnu_msg_in[65][2],vnu_msg_in[64][2],vnu_msg_in[63][2],vnu_msg_in[62][2],vnu_msg_in[61][2],vnu_msg_in[60][2],vnu_msg_in[59][2],vnu_msg_in[58][2],vnu_msg_in[57][2],vnu_msg_in[56][2],vnu_msg_in[55][2],vnu_msg_in[54][2],vnu_msg_in[53][2],vnu_msg_in[52][2],vnu_msg_in[51][2],vnu_msg_in[50][2],vnu_msg_in[49][2],vnu_msg_in[48][2],vnu_msg_in[47][2],vnu_msg_in[46][2],vnu_msg_in[45][2],vnu_msg_in[44][2],vnu_msg_in[43][2],vnu_msg_in[42][2],vnu_msg_in[41][2],vnu_msg_in[40][2],vnu_msg_in[39][2],vnu_msg_in[38][2],vnu_msg_in[37][2],vnu_msg_in[36][2],vnu_msg_in[35][2],vnu_msg_in[34][2],vnu_msg_in[33][2],vnu_msg_in[32][2],vnu_msg_in[31][2],vnu_msg_in[30][2],vnu_msg_in[29][2],vnu_msg_in[28][2],vnu_msg_in[27][2],vnu_msg_in[26][2],vnu_msg_in[25][2],vnu_msg_in[24][2],vnu_msg_in[23][2],vnu_msg_in[22][2],vnu_msg_in[21][2],vnu_msg_in[20][2],vnu_msg_in[19][2],vnu_msg_in[18][2],vnu_msg_in[17][2],vnu_msg_in[16][2],vnu_msg_in[15][2],vnu_msg_in[14][2],vnu_msg_in[13][2],vnu_msg_in[12][2],vnu_msg_in[11][2],vnu_msg_in[10][2],vnu_msg_in[9][2],vnu_msg_in[8][2],vnu_msg_in[7][2],vnu_msg_in[6][2],vnu_msg_in[5][2],vnu_msg_in[4][2],vnu_msg_in[3][2],vnu_msg_in[2][2],vnu_msg_in[1][2],vnu_msg_in[0][2]}),	
	.sw_out_bit3 ({vnu_msg_in[84][3],vnu_msg_in[83][3],vnu_msg_in[82][3],vnu_msg_in[81][3],vnu_msg_in[80][3],vnu_msg_in[79][3],vnu_msg_in[78][3],vnu_msg_in[77][3],vnu_msg_in[76][3],vnu_msg_in[75][3],vnu_msg_in[74][3],vnu_msg_in[73][3],vnu_msg_in[72][3],vnu_msg_in[71][3],vnu_msg_in[70][3],vnu_msg_in[69][3],vnu_msg_in[68][3],vnu_msg_in[67][3],vnu_msg_in[66][3],vnu_msg_in[65][3],vnu_msg_in[64][3],vnu_msg_in[63][3],vnu_msg_in[62][3],vnu_msg_in[61][3],vnu_msg_in[60][3],vnu_msg_in[59][3],vnu_msg_in[58][3],vnu_msg_in[57][3],vnu_msg_in[56][3],vnu_msg_in[55][3],vnu_msg_in[54][3],vnu_msg_in[53][3],vnu_msg_in[52][3],vnu_msg_in[51][3],vnu_msg_in[50][3],vnu_msg_in[49][3],vnu_msg_in[48][3],vnu_msg_in[47][3],vnu_msg_in[46][3],vnu_msg_in[45][3],vnu_msg_in[44][3],vnu_msg_in[43][3],vnu_msg_in[42][3],vnu_msg_in[41][3],vnu_msg_in[40][3],vnu_msg_in[39][3],vnu_msg_in[38][3],vnu_msg_in[37][3],vnu_msg_in[36][3],vnu_msg_in[35][3],vnu_msg_in[34][3],vnu_msg_in[33][3],vnu_msg_in[32][3],vnu_msg_in[31][3],vnu_msg_in[30][3],vnu_msg_in[29][3],vnu_msg_in[28][3],vnu_msg_in[27][3],vnu_msg_in[26][3],vnu_msg_in[25][3],vnu_msg_in[24][3],vnu_msg_in[23][3],vnu_msg_in[22][3],vnu_msg_in[21][3],vnu_msg_in[20][3],vnu_msg_in[19][3],vnu_msg_in[18][3],vnu_msg_in[17][3],vnu_msg_in[16][3],vnu_msg_in[15][3],vnu_msg_in[14][3],vnu_msg_in[13][3],vnu_msg_in[12][3],vnu_msg_in[11][3],vnu_msg_in[10][3],vnu_msg_in[9][3],vnu_msg_in[8][3],vnu_msg_in[7][3],vnu_msg_in[6][3],vnu_msg_in[5][3],vnu_msg_in[4][3],vnu_msg_in[3][3],vnu_msg_in[2][3],vnu_msg_in[1][3],vnu_msg_in[0][3]}),
`ifdef SCHED_4_6
	.sys_clk     (read_clk),
	.rstn		 (decoder_rstn),
`endif
	.sw_in_bit0  (vnu_bs_in_bit[0]),
	.sw_in_bit1  (vnu_bs_in_bit[1]),
	.sw_in_bit2  (vnu_bs_in_bit[2]),
	.sw_in_bit3  (vnu_bs_in_bit[3]),
	.left_sel    (vnu_left_sel),
	.right_sel   (vnu_right_sel),
	.merge_sel   (vnu_merge_sel)
);
qsn_controller_85b #(
	.PERMUTATION_LENGTH(CHECK_PARALLELISM)
) vnu_qsn_controller_85b (
	.left_sel     (vnu_left_sel ),
	.right_sel    (vnu_right_sel),
	.merge_sel    (vnu_merge_sel),
	.shift_factor (vnu_shift_factorIn), // offset shift factor of submatrix_1
	.rstn         (decoder_rstn),
	.sys_clk      (read_clk)
);
assign vnu_shift_factorIn = (v2c_bs_en == 1'b1) ? v2c_shift_factor_cur_0 :
							(ch_bs_en == 1'b1) ? ch_ramRD_shift_factor_cur_0 :
							(dnu_inRotate_bs_en == 1'b1) ? dnu_inRotate_shift_factor : v2c_shift_factor_cur_0;
/*----------------------------------------------*/	
	wire [QUAN_SIZE-1:0] mem_to_cnu [0:CHECK_PARALLELISM-1];
	wire [QUAN_SIZE-1:0] mem_to_vnu [0:CHECK_PARALLELISM-1];
	reg [ADDR_WIDTH-1:0] c2v_mem_page_addr [0:CN_DEGREE-1]; // page-write addresses
	reg [ADDR_WIDTH-1:0] v2c_mem_page_addr [0:CN_DEGREE-1]; // page-write addresses
	reg [ADDR_WIDTH-1:0] c2v_mem_page_rd_addr [0:CN_DEGREE-1]; // page-read addresses
	reg [ADDR_WIDTH-1:0] v2c_mem_page_rd_addr [0:CN_DEGREE-1]; // page-read addresses
	wire [ADDR_WIDTH-1:0] cnu_mem_page_sync_addr [0:CN_DEGREE-1]; // synchornous page-access addresses
	wire [ADDR_WIDTH-1:0] vnu_mem_page_sync_addr [0:CN_DEGREE-1]; // synchornous page-access addresses
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
			.cnu_sync_addr    (cnu_mem_page_sync_addr[0]),
			.vnu_sync_addr    (vnu_mem_page_sync_addr[0]),
			.cnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			.vnu_layer_status (v2c_layer_cnt), // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
			//.last_row_chunk   ({v2c_last_row_chunk, c2v_last_row_chunk}),
			.last_row_chunk   ({c2v_last_row_chunk_reg0, v2c_last_row_chunk_reg0}),
			.we               ({v2c_mem_we, c2v_mem_we}),
			.sys_clk          (read_clk),
			.rstn             (decoder_rstn)
		);
		assign cnu_mem_page_sync_addr[0] = (v2c_mem_fetch == 1'b1) ? v2c_mem_page_rd_addr[0] : 
										   (c2v_mem_we == 1'b1) ? c2v_mem_page_addr[0] : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.

		assign vnu_mem_page_sync_addr[0] = (c2v_mem_fetch == 1'b1) ? c2v_mem_page_rd_addr[0] : 
										   (v2c_mem_we == 1'b1) ? v2c_mem_page_addr[0] : DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Check-to-Variable messages RAMs write-page addresses
	wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt;
	assign c2v_row_chunk_cnt[ROW_CHUNK_NUM-1:0] = {c2v_mem_we_propagate[ROW_CHUNK_NUM-2:0], c2v_mem_we_propagateIn};
	always @(posedge read_clk) begin
		if(decoder_rstn == 1'b0) 
			c2v_mem_page_addr[0] <= START_PAGE_1_0+C2V_MEM_ADDR_BASE;
		else if(c2v_mem_we == 1'b1) begin
			// page increment pattern within layer 0
			if(v2c_layer_cnt[0] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr[0] <= START_PAGE_1_1+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
						c2v_mem_page_addr[0] <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr[0] <= c2v_mem_page_addr[0]+1;
			end
			// page increment pattern within layer 1
			if(v2c_layer_cnt[1] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr[0] <= START_PAGE_1_2+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
						c2v_mem_page_addr[0] <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr[0] <= c2v_mem_page_addr[0]+1;
			end
			// page increment pattern within layer 2
			if(v2c_layer_cnt[2] == 1) begin
				if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					c2v_mem_page_addr[0] <= START_PAGE_1_0+C2V_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(c2v_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_2-1] == 1'b1)
						c2v_mem_page_addr[0] <= C2V_MEM_ADDR_BASE; 
				else
					c2v_mem_page_addr[0] <= c2v_mem_page_addr[0]+1;
			end
		end
	end
	reg [5:0] c2v_bs_en_propagate_temp;
	always @(posedge read_clk) begin if(!decoder_rstn) c2v_bs_en_propagate_temp <= 0; else c2v_bs_en_propagate_temp[5:0] <= {c2v_bs_en_propagate_temp[4:0], c2v_bs_en_propagate[ROW_CHUNK_NUM-2]}; end
	always @(posedge read_clk) begin
		if(decoder_rstn == 1'b0) begin
			c2v_shift_factor_cur_2 <= shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
		end
		else if(/*c2v_bs_en_propagate[ROW_CHUNK_NUM-2]*/c2v_bs_en_propagate_temp[5] == 1'b1) begin
			c2v_shift_factor_cur_2 <= c2v_shift_factor_cur_0[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_1 <= c2v_shift_factor_cur_2[BITWIDTH_SHIFT_FACTOR-1:0];
			c2v_shift_factor_cur_0 <= c2v_shift_factor_cur_1[BITWIDTH_SHIFT_FACTOR-1:0];
		end
	end
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Variable-to-Check messages RAMs write-page addresses
	wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt;
	assign v2c_row_chunk_cnt[ROW_CHUNK_NUM-1:0] = {v2c_mem_we_propagate[ROW_CHUNK_NUM-2:0], v2c_mem_we_propagateIn};
	always @(posedge read_clk) begin
		if(decoder_rstn == 1'b0) 
			v2c_mem_page_addr[0] <= START_PAGE_1_0+V2C_MEM_ADDR_BASE;
		else if(v2c_mem_we == 1'b1) begin
			// page increment pattern within layer 0
			if(v2c_layer_cnt[0] == 1) begin
				if(v2c_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					v2c_mem_page_addr[0] <= START_PAGE_1_1+V2C_MEM_ADDR_BASE; // to move on to beginning of layer 1
				else if(v2c_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
						v2c_mem_page_addr[0] <= V2C_MEM_ADDR_BASE; 
				else
					v2c_mem_page_addr[0] <= v2c_mem_page_addr[0]+1;
			end
			// page increment pattern within layer 1
			if(v2c_layer_cnt[1] == 1) begin
				if(v2c_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					v2c_mem_page_addr[0] <= START_PAGE_1_2+V2C_MEM_ADDR_BASE; // to move on to beginning of layer 2
				else if(v2c_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
						v2c_mem_page_addr[0] <= V2C_MEM_ADDR_BASE; 
				else
					v2c_mem_page_addr[0] <= v2c_mem_page_addr[0]+1;
			end
			// page increment pattern within layer 2
			if(v2c_layer_cnt[2] == 1) begin
				if(v2c_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
					v2c_mem_page_addr[0] <= START_PAGE_1_0+V2C_MEM_ADDR_BASE; // to move on to beginning of layer 0
				else if(v2c_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_2-1] == 1'b1)
						v2c_mem_page_addr[0] <= V2C_MEM_ADDR_BASE; 
				else
					v2c_mem_page_addr[0] <= v2c_mem_page_addr[0]+1;
			end
		end
	end
	reg [5:0] v2c_bs_en_propagate_temp;
	always @(posedge read_clk) begin if(!decoder_rstn) v2c_bs_en_propagate_temp <= 0; else v2c_bs_en_propagate_temp[5:0] <= {v2c_bs_en_propagate_temp[4:0], v2c_bs_en_propagate[ROW_CHUNK_NUM-2]}; end
	always @(posedge read_clk) begin
		if(decoder_rstn == 1'b0) begin
			v2c_shift_factor_cur_2 <= shift_factor_2[BITWIDTH_SHIFT_FACTOR-1:0];
			v2c_shift_factor_cur_1 <= shift_factor_1[BITWIDTH_SHIFT_FACTOR-1:0];
			v2c_shift_factor_cur_0 <= shift_factor_0[BITWIDTH_SHIFT_FACTOR-1:0];
		end
		else if(/*v2c_bs_en_propagate[ROW_CHUNK_NUM-2]*/v2c_bs_en_propagate_temp[5] == 1'b1) begin
			v2c_shift_factor_cur_2 <= v2c_shift_factor_cur_0[BITWIDTH_SHIFT_FACTOR-1:0];
			v2c_shift_factor_cur_1 <= v2c_shift_factor_cur_2[BITWIDTH_SHIFT_FACTOR-1:0];
			v2c_shift_factor_cur_0 <= v2c_shift_factor_cur_1[BITWIDTH_SHIFT_FACTOR-1:0];
		end
	end
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//reg temp;
	//always @(posedge read_clk) begin if(!decoder_rstn) temp <= 0; else temp <= c2v_mem_we; end
	always @(posedge read_clk) begin
		if(c2v_mem_we/*temp*/ == 1'b1) begin
			$fwrite(pageAlign_tb_fd,"state_%d, mem_we: %b (page_addr: 0x%h), last_RC:%b -> ", $unsigned(inst_cnu_control_unit.state), c2v_mem_we, c2v_mem_page_addr[0], c2v_last_row_chunk);
			for(int i = 0; i < CHECK_PARALLELISM-1; i++) $fwrite(pageAlign_tb_fd, "%h,", $unsigned(inst_mem_subsystem_top_submatrix_1.cnu_pa_msg[i]));
			$fwrite(pageAlign_tb_fd, "%h\n", $unsigned(inst_mem_subsystem_top_submatrix_1.cnu_pa_msg[CHECK_PARALLELISM-1]));
		end
	end
	// Log file of BS output
	integer cnu_bs_out_fd;
	initial cnu_bs_out_fd = $fopen("cnu_bs_out.log", "w");
	always @(posedge read_clk) begin
		if(inst_cnu_control_unit.state >= BS_WB) begin
			$fwrite(cnu_bs_out_fd, "state_%d, bs_en_%b%b, right_shift_%d(IN:%d) -> ", $unsigned(inst_cnu_control_unit.state), c2v_bs_en_propagate[ROW_CHUNK_NUM-2:0], c2v_bs_en_propagateIn, $unsigned(c2v_shift_factor_cur_0), $unsigned(cnu_qsn_controller_85b.shift_factor));
			for(int i = 0; i < CHECK_PARALLELISM-1; i++) $fwrite(cnu_bs_out_fd, "%h,", $unsigned(cnu_msg_in[i]));
			$fwrite(cnu_bs_out_fd, "%h\n", $unsigned(cnu_msg_in[CHECK_PARALLELISM-1]));
		end
	end
/*
	always @(posedge read_clk) begin
		if(decoder_rstn == 1'b1 && layer_msg_pass_en == 1'b1) begin
			//$fwrite(pageAlignIn_tb_fd[1], "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n",
			$fwrite(pageAlignIn_tb_fd[1], "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h,%h\n",
				$unsigned(vnu_msg_in_0),$unsigned(vnu_msg_in_1),$unsigned(vnu_msg_in_2),$unsigned(vnu_msg_in_3),$unsigned(vnu_msg_in_4),$unsigned(vnu_msg_in_5),$unsigned(vnu_msg_in_6),$unsigned(vnu_msg_in_7),$unsigned(vnu_msg_in_8),$unsigned(vnu_msg_in_9),$unsigned(vnu_msg_in_10),$unsigned(vnu_msg_in_11),$unsigned(vnu_msg_in_12),$unsigned(vnu_msg_in_13),$unsigned(vnu_msg_in_14),$unsigned(vnu_msg_in_15),$unsigned(vnu_msg_in_16),$unsigned(vnu_msg_in_17),$unsigned(vnu_msg_in_18),$unsigned(vnu_msg_in_19),$unsigned(vnu_msg_in_20),$unsigned(vnu_msg_in_21),$unsigned(vnu_msg_in_22),$unsigned(vnu_msg_in_23),$unsigned(vnu_msg_in_24),$unsigned(vnu_msg_in_25),$unsigned(vnu_msg_in_26),$unsigned(vnu_msg_in_27),$unsigned(vnu_msg_in_28),$unsigned(vnu_msg_in_29),$unsigned(vnu_msg_in_30),$unsigned(vnu_msg_in_31),$unsigned(vnu_msg_in_32),$unsigned(vnu_msg_in_33),$unsigned(vnu_msg_in_34),$unsigned(vnu_msg_in_35),$unsigned(vnu_msg_in_36),$unsigned(vnu_msg_in_37),$unsigned(vnu_msg_in_38),$unsigned(vnu_msg_in_39),$unsigned(vnu_msg_in_40),$unsigned(vnu_msg_in_41),$unsigned(vnu_msg_in_42),$unsigned(vnu_msg_in_43),$unsigned(vnu_msg_in_44),$unsigned(vnu_msg_in_45),$unsigned(vnu_msg_in_46),$unsigned(vnu_msg_in_47),$unsigned(vnu_msg_in_48),$unsigned(vnu_msg_in_49),$unsigned(vnu_msg_in_50),$unsigned(vnu_msg_in_51),$unsigned(vnu_msg_in_52),$unsigned(vnu_msg_in_53),$unsigned(vnu_msg_in_54),$unsigned(vnu_msg_in_55),$unsigned(vnu_msg_in_56),$unsigned(vnu_msg_in_57),$unsigned(vnu_msg_in_58),$unsigned(vnu_msg_in_59),$unsigned(vnu_msg_in_60),$unsigned(vnu_msg_in_61),$unsigned(vnu_msg_in_62),$unsigned(vnu_msg_in_63),$unsigned(vnu_msg_in_64),$unsigned(vnu_msg_in_65),$unsigned(vnu_msg_in_66),$unsigned(vnu_msg_in_67),$unsigned(vnu_msg_in_68),$unsigned(vnu_msg_in_69),$unsigned(vnu_msg_in_70),$unsigned(vnu_msg_in_71),$unsigned(vnu_msg_in_72),$unsigned(vnu_msg_in_73),$unsigned(vnu_msg_in_74),$unsigned(vnu_msg_in_75),$unsigned(vnu_msg_in_76),$unsigned(vnu_msg_in_77),$unsigned(vnu_msg_in_78),$unsigned(vnu_msg_in_79),$unsigned(vnu_msg_in_80),$unsigned(vnu_msg_in_81),$unsigned(vnu_msg_in_82),$unsigned(vnu_msg_in_83),$unsigned(vnu_msg_in_84)
			);
		end
	end
*/
/*-------------------------------------------------------------------------------------------------------------------------*/
	always @(posedge read_clk) begin
			if(decoder_rstn == 1'b0) iter_termination <= 0;
			else if(
				//inst_vnu_control_unit.iter_cnt[MAX_ITER-1] == 1'b1 && 
				//vnu_ctrl_state[$clog2(CTRL_FSM_STATE_NUM)-1:0] == MEM_WB
				inst_vnu_control_unit.iter_cnt[2] == 1'b1 && // only simulating 2 iteration
				vnu_ctrl_state[$clog2(CTRL_FSM_STATE_NUM)-1:0] == VNU_CH_FETCH
			)
				iter_termination <= 1'b1;
	end


	task init();
		iter_termination  <= 0;
	endtask
	assign fsm_en = decoder_rstn;

	integer iter, vnu_iter; initial begin iter <= 1; vnu_iter <= 1; end
	always @(posedge read_clk) begin
		if(c2v_bs_en_propagate > 0 || c2v_bs_en_propagateIn > 0) begin
			iter <= iter+1;
		end

		if(v2c_bs_en_propagate > 0) begin
			vnu_iter <= vnu_iter+1;
		end
	end
	always @(posedge read_clk) begin
		if(c2v_bs_en_propagate > 0 || c2v_bs_en_propagateIn > 0) begin
			cnu_bs_in_bit[0] <= {vnBsIn_pattern[CHECK_PARALLELISM*iter+84][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+83][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+82][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+81][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+80][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+79][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+78][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+77][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+76][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+75][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+74][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+73][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+72][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+71][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+70][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+69][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+68][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+67][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+66][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+65][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+64][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+63][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+62][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+61][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+60][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+59][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+58][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+57][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+56][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+55][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+54][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+53][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+52][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+51][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+50][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+49][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+48][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+47][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+46][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+45][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+44][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+43][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+42][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+41][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+40][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+39][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+38][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+37][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+36][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+35][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+34][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+33][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+32][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+31][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+30][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+29][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+28][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+27][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+26][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+25][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+24][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+23][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+22][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+21][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+20][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+19][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+18][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+17][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+16][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+15][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+14][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+13][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+12][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+11][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+10][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+9][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+8][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+7][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+6][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+5][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+4][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+3][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+2][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+1][0],vnBsIn_pattern[CHECK_PARALLELISM*iter+0][0]};
			cnu_bs_in_bit[1] <= {vnBsIn_pattern[CHECK_PARALLELISM*iter+84][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+83][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+82][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+81][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+80][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+79][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+78][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+77][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+76][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+75][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+74][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+73][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+72][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+71][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+70][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+69][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+68][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+67][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+66][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+65][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+64][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+63][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+62][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+61][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+60][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+59][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+58][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+57][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+56][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+55][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+54][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+53][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+52][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+51][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+50][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+49][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+48][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+47][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+46][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+45][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+44][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+43][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+42][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+41][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+40][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+39][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+38][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+37][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+36][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+35][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+34][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+33][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+32][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+31][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+30][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+29][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+28][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+27][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+26][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+25][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+24][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+23][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+22][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+21][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+20][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+19][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+18][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+17][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+16][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+15][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+14][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+13][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+12][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+11][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+10][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+9][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+8][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+7][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+6][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+5][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+4][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+3][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+2][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+1][1],vnBsIn_pattern[CHECK_PARALLELISM*iter+0][1]}; 
			cnu_bs_in_bit[2] <= {vnBsIn_pattern[CHECK_PARALLELISM*iter+84][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+83][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+82][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+81][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+80][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+79][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+78][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+77][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+76][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+75][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+74][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+73][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+72][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+71][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+70][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+69][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+68][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+67][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+66][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+65][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+64][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+63][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+62][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+61][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+60][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+59][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+58][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+57][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+56][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+55][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+54][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+53][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+52][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+51][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+50][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+49][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+48][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+47][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+46][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+45][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+44][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+43][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+42][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+41][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+40][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+39][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+38][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+37][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+36][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+35][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+34][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+33][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+32][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+31][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+30][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+29][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+28][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+27][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+26][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+25][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+24][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+23][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+22][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+21][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+20][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+19][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+18][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+17][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+16][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+15][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+14][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+13][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+12][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+11][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+10][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+9][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+8][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+7][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+6][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+5][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+4][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+3][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+2][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+1][2],vnBsIn_pattern[CHECK_PARALLELISM*iter+0][2]}; 
			cnu_bs_in_bit[3] <= {vnBsIn_pattern[CHECK_PARALLELISM*iter+84][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+83][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+82][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+81][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+80][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+79][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+78][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+77][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+76][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+75][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+74][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+73][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+72][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+71][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+70][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+69][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+68][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+67][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+66][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+65][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+64][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+63][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+62][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+61][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+60][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+59][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+58][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+57][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+56][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+55][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+54][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+53][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+52][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+51][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+50][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+49][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+48][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+47][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+46][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+45][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+44][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+43][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+42][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+41][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+40][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+39][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+38][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+37][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+36][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+35][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+34][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+33][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+32][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+31][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+30][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+29][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+28][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+27][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+26][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+25][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+24][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+23][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+22][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+21][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+20][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+19][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+18][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+17][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+16][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+15][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+14][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+13][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+12][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+11][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+10][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+9][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+8][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+7][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+6][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+5][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+4][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+3][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+2][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+1][3],vnBsIn_pattern[CHECK_PARALLELISM*iter+0][3]}; 		
		end
	end
	/*
	integer cnu_bs_in_fd;
	initial cnu_bs_in_fd = $fopen("cnu_bs_in.log", "w");
	always @(posedge read_clk) begin
		if(inst_cnu_control_unit.state >= BS_WB) begin
			$fwrite(cnu_bs_in_fd, "state_%d, bs_en_%b%b, tb_iter_%d -> ", $unsigned(inst_cnu_control_unit.state), c2v_bs_en_propagate[ROW_CHUNK_NUM-2:0], c2v_bs_en_propagateIn, $unsigned(iter));
			for(int i = 0; i < CHECK_PARALLELISM-1; i++) $fwrite(cnu_bs_in_fd, "%h,", $unsigned({cnu_bs_in_bit[3][i], cnu_bs_in_bit[2][i], cnu_bs_in_bit[1][i], cnu_bs_in_bit[0][i]}));
			$fwrite(cnu_bs_in_fd, "%h\n", $unsigned({cnu_bs_in_bit[3][ROW_CHUNK_NUM-1], cnu_bs_in_bit[2][ROW_CHUNK_NUM-1], cnu_bs_in_bit[1][ROW_CHUNK_NUM-1], cnu_bs_in_bit[0][ROW_CHUNK_NUM-1]}));
		end
	end
	*/
	always @(posedge read_clk) begin
		if(v2c_bs_en_propagate > 0 || v2c_bs_en_propagateIn > 0) begin
			vnu_bs_in_bit[0] <= {vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+84][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+83][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+82][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+81][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+80][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+79][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+78][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+77][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+76][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+75][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+74][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+73][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+72][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+71][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+70][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+69][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+68][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+67][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+66][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+65][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+64][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+63][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+62][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+61][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+60][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+59][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+58][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+57][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+56][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+55][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+54][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+53][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+52][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+51][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+50][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+49][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+48][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+47][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+46][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+45][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+44][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+43][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+42][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+41][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+40][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+39][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+38][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+37][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+36][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+35][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+34][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+33][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+32][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+31][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+30][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+29][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+28][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+27][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+26][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+25][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+24][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+23][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+22][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+21][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+20][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+19][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+18][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+17][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+16][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+15][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+14][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+13][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+12][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+11][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+10][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+9][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+8][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+7][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+6][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+5][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+4][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+3][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+2][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+1][0],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+0][0]};			
			vnu_bs_in_bit[1] <= {vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+84][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+83][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+82][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+81][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+80][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+79][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+78][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+77][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+76][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+75][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+74][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+73][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+72][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+71][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+70][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+69][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+68][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+67][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+66][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+65][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+64][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+63][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+62][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+61][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+60][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+59][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+58][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+57][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+56][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+55][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+54][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+53][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+52][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+51][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+50][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+49][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+48][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+47][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+46][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+45][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+44][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+43][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+42][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+41][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+40][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+39][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+38][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+37][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+36][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+35][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+34][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+33][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+32][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+31][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+30][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+29][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+28][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+27][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+26][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+25][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+24][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+23][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+22][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+21][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+20][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+19][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+18][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+17][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+16][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+15][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+14][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+13][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+12][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+11][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+10][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+9][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+8][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+7][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+6][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+5][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+4][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+3][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+2][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+1][1],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+0][1]};			
			vnu_bs_in_bit[2] <= {vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+84][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+83][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+82][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+81][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+80][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+79][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+78][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+77][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+76][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+75][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+74][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+73][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+72][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+71][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+70][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+69][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+68][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+67][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+66][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+65][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+64][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+63][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+62][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+61][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+60][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+59][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+58][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+57][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+56][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+55][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+54][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+53][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+52][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+51][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+50][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+49][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+48][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+47][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+46][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+45][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+44][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+43][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+42][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+41][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+40][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+39][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+38][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+37][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+36][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+35][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+34][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+33][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+32][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+31][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+30][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+29][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+28][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+27][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+26][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+25][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+24][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+23][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+22][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+21][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+20][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+19][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+18][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+17][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+16][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+15][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+14][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+13][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+12][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+11][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+10][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+9][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+8][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+7][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+6][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+5][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+4][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+3][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+2][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+1][2],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+0][2]};			
			vnu_bs_in_bit[3] <= {vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+84][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+83][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+82][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+81][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+80][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+79][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+78][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+77][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+76][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+75][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+74][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+73][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+72][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+71][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+70][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+69][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+68][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+67][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+66][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+65][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+64][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+63][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+62][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+61][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+60][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+59][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+58][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+57][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+56][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+55][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+54][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+53][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+52][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+51][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+50][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+49][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+48][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+47][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+46][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+45][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+44][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+43][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+42][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+41][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+40][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+39][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+38][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+37][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+36][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+35][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+34][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+33][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+32][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+31][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+30][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+29][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+28][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+27][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+26][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+25][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+24][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+23][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+22][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+21][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+20][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+19][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+18][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+17][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+16][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+15][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+14][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+13][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+12][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+11][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+10][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+9][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+8][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+7][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+6][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+5][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+4][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+3][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+2][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+1][3],vnBsIn_pattern[CHECK_PARALLELISM*vnu_iter+0][3]};		
		end
	end
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
		
		.sigma_in (sigma_in[snr_packet[SNR_PACKET_SIZE-1:0]]),
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
/*--------------------------------------------------------------------------*/
// Channel Buffers
reg [CH_DATA_WIDTH-1:0] ch_msg_genIn [0:CN_DEGREE-1];
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_0 [0:CH_MSG_NUM-1]; // [0:849]
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_1 [0:CH_MSG_NUM-1]; // [0:849]
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_rd_addr [0:CN_DEGREE-1];
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_ch_ram_wr_addr [0:CN_DEGREE-1];
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chInit_wr_addr [0:CN_DEGREE-1];
reg [CH_RAM_ADDR_WIDTH-1:0] submatrix_chLayer_wr_addr [0:CN_DEGREE-1];
assign vnu_bs_in_bit[0] <= (ch_bs_en == 1'b1) ? {ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+84][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+83][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+82][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+81][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+80][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+79][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+78][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+77][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+76][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+75][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+74][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+73][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+72][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+71][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+70][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+69][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+68][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+67][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+66][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+65][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+64][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+63][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+62][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+61][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+60][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+59][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+58][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+57][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+56][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+55][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+54][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+53][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+52][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+51][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+50][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+49][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+48][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+47][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+46][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+45][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+44][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+43][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+42][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+41][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+40][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+39][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+38][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+37][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+36][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+35][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+34][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+33][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+32][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+31][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+30][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+29][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+28][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+27][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+26][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+25][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+24][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+23][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+22][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+21][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+20][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+19][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+18][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+17][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+16][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+15][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+14][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+13][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+12][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+11][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+10][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+9][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+8][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+7][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+6][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+5][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+4][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+3][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+2][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+1][0],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+0][0]} : {vnBsIn_pattern[84][0],vnBsIn_pattern[83][0],vnBsIn_pattern[82][0],vnBsIn_pattern[81][0],vnBsIn_pattern[80][0],vnBsIn_pattern[79][0],vnBsIn_pattern[78][0],vnBsIn_pattern[77][0],vnBsIn_pattern[76][0],vnBsIn_pattern[75][0],vnBsIn_pattern[74][0],vnBsIn_pattern[73][0],vnBsIn_pattern[72][0],vnBsIn_pattern[71][0],vnBsIn_pattern[70][0],vnBsIn_pattern[69][0],vnBsIn_pattern[68][0],vnBsIn_pattern[67][0],vnBsIn_pattern[66][0],vnBsIn_pattern[65][0],vnBsIn_pattern[64][0],vnBsIn_pattern[63][0],vnBsIn_pattern[62][0],vnBsIn_pattern[61][0],vnBsIn_pattern[60][0],vnBsIn_pattern[59][0],vnBsIn_pattern[58][0],vnBsIn_pattern[57][0],vnBsIn_pattern[56][0],vnBsIn_pattern[55][0],vnBsIn_pattern[54][0],vnBsIn_pattern[53][0],vnBsIn_pattern[52][0],vnBsIn_pattern[51][0],vnBsIn_pattern[50][0],vnBsIn_pattern[49][0],vnBsIn_pattern[48][0],vnBsIn_pattern[47][0],vnBsIn_pattern[46][0],vnBsIn_pattern[45][0],vnBsIn_pattern[44][0],vnBsIn_pattern[43][0],vnBsIn_pattern[42][0],vnBsIn_pattern[41][0],vnBsIn_pattern[40][0],vnBsIn_pattern[39][0],vnBsIn_pattern[38][0],vnBsIn_pattern[37][0],vnBsIn_pattern[36][0],vnBsIn_pattern[35][0],vnBsIn_pattern[34][0],vnBsIn_pattern[33][0],vnBsIn_pattern[32][0],vnBsIn_pattern[31][0],vnBsIn_pattern[30][0],vnBsIn_pattern[29][0],vnBsIn_pattern[28][0],vnBsIn_pattern[27][0],vnBsIn_pattern[26][0],vnBsIn_pattern[25][0],vnBsIn_pattern[24][0],vnBsIn_pattern[23][0],vnBsIn_pattern[22][0],vnBsIn_pattern[21][0],vnBsIn_pattern[20][0],vnBsIn_pattern[19][0],vnBsIn_pattern[18][0],vnBsIn_pattern[17][0],vnBsIn_pattern[16][0],vnBsIn_pattern[15][0],vnBsIn_pattern[14][0],vnBsIn_pattern[13][0],vnBsIn_pattern[12][0],vnBsIn_pattern[11][0],vnBsIn_pattern[10][0],vnBsIn_pattern[9][0],vnBsIn_pattern[8][0],vnBsIn_pattern[7][0],vnBsIn_pattern[6][0],vnBsIn_pattern[5][0],vnBsIn_pattern[4][0],vnBsIn_pattern[3][0],vnBsIn_pattern[2][0],vnBsIn_pattern[1][0],vnBsIn_pattern[0][0]};
assign vnu_bs_in_bit[1] <= (ch_bs_en == 1'b1) ? {ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+84][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+83][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+82][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+81][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+80][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+79][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+78][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+77][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+76][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+75][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+74][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+73][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+72][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+71][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+70][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+69][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+68][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+67][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+66][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+65][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+64][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+63][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+62][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+61][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+60][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+59][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+58][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+57][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+56][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+55][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+54][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+53][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+52][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+51][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+50][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+49][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+48][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+47][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+46][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+45][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+44][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+43][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+42][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+41][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+40][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+39][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+38][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+37][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+36][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+35][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+34][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+33][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+32][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+31][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+30][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+29][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+28][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+27][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+26][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+25][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+24][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+23][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+22][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+21][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+20][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+19][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+18][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+17][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+16][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+15][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+14][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+13][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+12][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+11][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+10][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+9][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+8][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+7][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+6][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+5][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+4][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+3][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+2][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+1][1],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+0][1]} : {vnBsIn_pattern[84][1],vnBsIn_pattern[83][1],vnBsIn_pattern[82][1],vnBsIn_pattern[81][1],vnBsIn_pattern[80][1],vnBsIn_pattern[79][1],vnBsIn_pattern[78][1],vnBsIn_pattern[77][1],vnBsIn_pattern[76][1],vnBsIn_pattern[75][1],vnBsIn_pattern[74][1],vnBsIn_pattern[73][1],vnBsIn_pattern[72][1],vnBsIn_pattern[71][1],vnBsIn_pattern[70][1],vnBsIn_pattern[69][1],vnBsIn_pattern[68][1],vnBsIn_pattern[67][1],vnBsIn_pattern[66][1],vnBsIn_pattern[65][1],vnBsIn_pattern[64][1],vnBsIn_pattern[63][1],vnBsIn_pattern[62][1],vnBsIn_pattern[61][1],vnBsIn_pattern[60][1],vnBsIn_pattern[59][1],vnBsIn_pattern[58][1],vnBsIn_pattern[57][1],vnBsIn_pattern[56][1],vnBsIn_pattern[55][1],vnBsIn_pattern[54][1],vnBsIn_pattern[53][1],vnBsIn_pattern[52][1],vnBsIn_pattern[51][1],vnBsIn_pattern[50][1],vnBsIn_pattern[49][1],vnBsIn_pattern[48][1],vnBsIn_pattern[47][1],vnBsIn_pattern[46][1],vnBsIn_pattern[45][1],vnBsIn_pattern[44][1],vnBsIn_pattern[43][1],vnBsIn_pattern[42][1],vnBsIn_pattern[41][1],vnBsIn_pattern[40][1],vnBsIn_pattern[39][1],vnBsIn_pattern[38][1],vnBsIn_pattern[37][1],vnBsIn_pattern[36][1],vnBsIn_pattern[35][1],vnBsIn_pattern[34][1],vnBsIn_pattern[33][1],vnBsIn_pattern[32][1],vnBsIn_pattern[31][1],vnBsIn_pattern[30][1],vnBsIn_pattern[29][1],vnBsIn_pattern[28][1],vnBsIn_pattern[27][1],vnBsIn_pattern[26][1],vnBsIn_pattern[25][1],vnBsIn_pattern[24][1],vnBsIn_pattern[23][1],vnBsIn_pattern[22][1],vnBsIn_pattern[21][1],vnBsIn_pattern[20][1],vnBsIn_pattern[19][1],vnBsIn_pattern[18][1],vnBsIn_pattern[17][1],vnBsIn_pattern[16][1],vnBsIn_pattern[15][1],vnBsIn_pattern[14][1],vnBsIn_pattern[13][1],vnBsIn_pattern[12][1],vnBsIn_pattern[11][1],vnBsIn_pattern[10][1],vnBsIn_pattern[9][1],vnBsIn_pattern[8][1],vnBsIn_pattern[7][1],vnBsIn_pattern[6][1],vnBsIn_pattern[5][1],vnBsIn_pattern[4][1],vnBsIn_pattern[3][1],vnBsIn_pattern[2][1],vnBsIn_pattern[1][1],vnBsIn_pattern[0][1]};
assign vnu_bs_in_bit[2] <= (ch_bs_en == 1'b1) ? {ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+84][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+83][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+82][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+81][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+80][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+79][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+78][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+77][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+76][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+75][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+74][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+73][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+72][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+71][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+70][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+69][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+68][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+67][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+66][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+65][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+64][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+63][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+62][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+61][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+60][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+59][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+58][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+57][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+56][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+55][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+54][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+53][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+52][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+51][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+50][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+49][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+48][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+47][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+46][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+45][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+44][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+43][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+42][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+41][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+40][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+39][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+38][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+37][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+36][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+35][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+34][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+33][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+32][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+31][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+30][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+29][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+28][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+27][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+26][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+25][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+24][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+23][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+22][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+21][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+20][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+19][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+18][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+17][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+16][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+15][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+14][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+13][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+12][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+11][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+10][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+9][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+8][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+7][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+6][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+5][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+4][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+3][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+2][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+1][2],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+0][2]} : {vnBsIn_pattern[84][2],vnBsIn_pattern[83][2],vnBsIn_pattern[82][2],vnBsIn_pattern[81][2],vnBsIn_pattern[80][2],vnBsIn_pattern[79][2],vnBsIn_pattern[78][2],vnBsIn_pattern[77][2],vnBsIn_pattern[76][2],vnBsIn_pattern[75][2],vnBsIn_pattern[74][2],vnBsIn_pattern[73][2],vnBsIn_pattern[72][2],vnBsIn_pattern[71][2],vnBsIn_pattern[70][2],vnBsIn_pattern[69][2],vnBsIn_pattern[68][2],vnBsIn_pattern[67][2],vnBsIn_pattern[66][2],vnBsIn_pattern[65][2],vnBsIn_pattern[64][2],vnBsIn_pattern[63][2],vnBsIn_pattern[62][2],vnBsIn_pattern[61][2],vnBsIn_pattern[60][2],vnBsIn_pattern[59][2],vnBsIn_pattern[58][2],vnBsIn_pattern[57][2],vnBsIn_pattern[56][2],vnBsIn_pattern[55][2],vnBsIn_pattern[54][2],vnBsIn_pattern[53][2],vnBsIn_pattern[52][2],vnBsIn_pattern[51][2],vnBsIn_pattern[50][2],vnBsIn_pattern[49][2],vnBsIn_pattern[48][2],vnBsIn_pattern[47][2],vnBsIn_pattern[46][2],vnBsIn_pattern[45][2],vnBsIn_pattern[44][2],vnBsIn_pattern[43][2],vnBsIn_pattern[42][2],vnBsIn_pattern[41][2],vnBsIn_pattern[40][2],vnBsIn_pattern[39][2],vnBsIn_pattern[38][2],vnBsIn_pattern[37][2],vnBsIn_pattern[36][2],vnBsIn_pattern[35][2],vnBsIn_pattern[34][2],vnBsIn_pattern[33][2],vnBsIn_pattern[32][2],vnBsIn_pattern[31][2],vnBsIn_pattern[30][2],vnBsIn_pattern[29][2],vnBsIn_pattern[28][2],vnBsIn_pattern[27][2],vnBsIn_pattern[26][2],vnBsIn_pattern[25][2],vnBsIn_pattern[24][2],vnBsIn_pattern[23][2],vnBsIn_pattern[22][2],vnBsIn_pattern[21][2],vnBsIn_pattern[20][2],vnBsIn_pattern[19][2],vnBsIn_pattern[18][2],vnBsIn_pattern[17][2],vnBsIn_pattern[16][2],vnBsIn_pattern[15][2],vnBsIn_pattern[14][2],vnBsIn_pattern[13][2],vnBsIn_pattern[12][2],vnBsIn_pattern[11][2],vnBsIn_pattern[10][2],vnBsIn_pattern[9][2],vnBsIn_pattern[8][2],vnBsIn_pattern[7][2],vnBsIn_pattern[6][2],vnBsIn_pattern[5][2],vnBsIn_pattern[4][2],vnBsIn_pattern[3][2],vnBsIn_pattern[2][2],vnBsIn_pattern[1][2],vnBsIn_pattern[0][2]};
assign vnu_bs_in_bit[3] <= (ch_bs_en == 1'b1) ? {ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+84][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+83][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+82][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+81][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+80][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+79][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+78][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+77][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+76][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+75][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+74][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+73][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+72][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+71][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+70][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+69][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+68][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+67][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+66][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+65][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+64][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+63][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+62][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+61][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+60][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+59][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+58][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+57][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+56][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+55][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+54][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+53][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+52][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+51][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+50][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+49][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+48][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+47][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+46][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+45][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+44][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+43][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+42][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+41][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+40][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+39][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+38][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+37][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+36][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+35][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+34][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+33][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+32][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+31][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+30][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+29][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+28][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+27][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+26][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+25][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+24][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+23][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+22][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+21][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+20][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+19][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+18][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+17][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+16][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+15][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+14][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+13][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+12][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+11][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+10][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+9][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+8][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+7][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+6][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+5][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+4][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+3][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+2][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+1][3],ch_msg_fetchOut_1[/*submatrix_id=0*/0*CHECK_PARALLELISM+0][3]} : {vnBsIn_pattern[84][3],vnBsIn_pattern[83][3],vnBsIn_pattern[82][3],vnBsIn_pattern[81][3],vnBsIn_pattern[80][3],vnBsIn_pattern[79][3],vnBsIn_pattern[78][3],vnBsIn_pattern[77][3],vnBsIn_pattern[76][3],vnBsIn_pattern[75][3],vnBsIn_pattern[74][3],vnBsIn_pattern[73][3],vnBsIn_pattern[72][3],vnBsIn_pattern[71][3],vnBsIn_pattern[70][3],vnBsIn_pattern[69][3],vnBsIn_pattern[68][3],vnBsIn_pattern[67][3],vnBsIn_pattern[66][3],vnBsIn_pattern[65][3],vnBsIn_pattern[64][3],vnBsIn_pattern[63][3],vnBsIn_pattern[62][3],vnBsIn_pattern[61][3],vnBsIn_pattern[60][3],vnBsIn_pattern[59][3],vnBsIn_pattern[58][3],vnBsIn_pattern[57][3],vnBsIn_pattern[56][3],vnBsIn_pattern[55][3],vnBsIn_pattern[54][3],vnBsIn_pattern[53][3],vnBsIn_pattern[52][3],vnBsIn_pattern[51][3],vnBsIn_pattern[50][3],vnBsIn_pattern[49][3],vnBsIn_pattern[48][3],vnBsIn_pattern[47][3],vnBsIn_pattern[46][3],vnBsIn_pattern[45][3],vnBsIn_pattern[44][3],vnBsIn_pattern[43][3],vnBsIn_pattern[42][3],vnBsIn_pattern[41][3],vnBsIn_pattern[40][3],vnBsIn_pattern[39][3],vnBsIn_pattern[38][3],vnBsIn_pattern[37][3],vnBsIn_pattern[36][3],vnBsIn_pattern[35][3],vnBsIn_pattern[34][3],vnBsIn_pattern[33][3],vnBsIn_pattern[32][3],vnBsIn_pattern[31][3],vnBsIn_pattern[30][3],vnBsIn_pattern[29][3],vnBsIn_pattern[28][3],vnBsIn_pattern[27][3],vnBsIn_pattern[26][3],vnBsIn_pattern[25][3],vnBsIn_pattern[24][3],vnBsIn_pattern[23][3],vnBsIn_pattern[22][3],vnBsIn_pattern[21][3],vnBsIn_pattern[20][3],vnBsIn_pattern[19][3],vnBsIn_pattern[18][3],vnBsIn_pattern[17][3],vnBsIn_pattern[16][3],vnBsIn_pattern[15][3],vnBsIn_pattern[14][3],vnBsIn_pattern[13][3],vnBsIn_pattern[12][3],vnBsIn_pattern[11][3],vnBsIn_pattern[10][3],vnBsIn_pattern[9][3],vnBsIn_pattern[8][3],vnBsIn_pattern[7][3],vnBsIn_pattern[6][3],vnBsIn_pattern[5][3],vnBsIn_pattern[4][3],vnBsIn_pattern[3][3],vnBsIn_pattern[2][3],vnBsIn_pattern[1][3],vnBsIn_pattern[0][3]};
/*----------------------------*/
wire ch_ram_we; assign ch_ram_we = ch_ram_init_we || ch_ram_wb;
wire ch_ram_rd_clk; assign ch_ram_rd_clk = read_clk;
wire ch_ram_wr_clk; assign ch_ram_wr_clk = write_clk;
/*----------------------------*/
genvar submatrix_id;
generate
	for(submatrix_id=0; submatrix_id<CN_DEGREE; submatrix_id=submatrix_id+1) begin : ch_buff_inst
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
			.dout_0     (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 0 ]),
			.dout_1     (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 1 ]),
			.dout_2     (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 2 ]),
			.dout_3     (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 3 ]),
			.dout_4     (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 4 ]),
			.dout_5     (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 5 ]),
			.dout_6     (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 6 ]),
			.dout_7     (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 7 ]),
			.dout_8     (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 8 ]),
			.dout_9     (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 9 ]),
			.dout_10    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 10]),
			.dout_11    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 11]),
			.dout_12    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 12]),
			.dout_13    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 13]),
			.dout_14    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 14]),
			.dout_15    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 15]),
			.dout_16    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 16]),
			.dout_17    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 17]),
			.dout_18    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 18]),
			.dout_19    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 19]),
			.dout_20    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 20]),
			.dout_21    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 21]),
			.dout_22    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 22]),
			.dout_23    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 23]),
			.dout_24    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 24]),
			.dout_25    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 25]),
			.dout_26    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 26]),
			.dout_27    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 27]),
			.dout_28    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 28]),
			.dout_29    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 29]),
			.dout_30    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 30]),
			.dout_31    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 31]),
			.dout_32    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 32]),
			.dout_33    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 33]),
			.dout_34    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 34]),
			.dout_35    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 35]),
			.dout_36    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 36]),
			.dout_37    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 37]),
			.dout_38    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 38]),
			.dout_39    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 39]),
			.dout_40    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 40]),
			.dout_41    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 41]),
			.dout_42    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 42]),
			.dout_43    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 43]),
			.dout_44    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 44]),
			.dout_45    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 45]),
			.dout_46    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 46]),
			.dout_47    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 47]),
			.dout_48    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 48]),
			.dout_49    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 49]),
			.dout_50    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 50]),
			.dout_51    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 51]),
			.dout_52    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 52]),
			.dout_53    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 53]),
			.dout_54    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 54]),
			.dout_55    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 55]),
			.dout_56    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 56]),
			.dout_57    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 57]),
			.dout_58    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 58]),
			.dout_59    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 59]),
			.dout_60    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 60]),
			.dout_61    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 61]),
			.dout_62    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 62]),
			.dout_63    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 63]),
			.dout_64    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 64]),
			.dout_65    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 65]),
			.dout_66    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 66]),
			.dout_67    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 67]),
			.dout_68    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 68]),
			.dout_69    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 69]),
			.dout_70    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 70]),
			.dout_71    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 71]),
			.dout_72    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 72]),
			.dout_73    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 73]),
			.dout_74    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 74]),
			.dout_75    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 75]),
			.dout_76    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 76]),
			.dout_77    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 77]),
			.dout_78    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 78]),
			.dout_79    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 79]),
			.dout_80    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 80]),
			.dout_81    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 81]),
			.dout_82    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 82]),
			.dout_83    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 83]),
			.dout_84    (ch_msg_fetchOut_1[submatrix_id*CHECK_PARALLELISM + 84]),
			// For CNUs at first iteration as their inital v2c messages, i.e., channel messages of all associative VNUs
			.cnu_init_dout_0     (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 0 ]),
			.cnu_init_dout_1     (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 1 ]),
			.cnu_init_dout_2     (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 2 ]),
			.cnu_init_dout_3     (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 3 ]),
			.cnu_init_dout_4     (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 4 ]),
			.cnu_init_dout_5     (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 5 ]),
			.cnu_init_dout_6     (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 6 ]),
			.cnu_init_dout_7     (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 7 ]),
			.cnu_init_dout_8     (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 8 ]),
			.cnu_init_dout_9     (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 9 ]),
			.cnu_init_dout_10    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 10]),
			.cnu_init_dout_11    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 11]),
			.cnu_init_dout_12    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 12]),
			.cnu_init_dout_13    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 13]),
			.cnu_init_dout_14    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 14]),
			.cnu_init_dout_15    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 15]),
			.cnu_init_dout_16    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 16]),
			.cnu_init_dout_17    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 17]),
			.cnu_init_dout_18    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 18]),
			.cnu_init_dout_19    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 19]),
			.cnu_init_dout_20    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 20]),
			.cnu_init_dout_21    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 21]),
			.cnu_init_dout_22    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 22]),
			.cnu_init_dout_23    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 23]),
			.cnu_init_dout_24    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 24]),
			.cnu_init_dout_25    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 25]),
			.cnu_init_dout_26    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 26]),
			.cnu_init_dout_27    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 27]),
			.cnu_init_dout_28    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 28]),
			.cnu_init_dout_29    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 29]),
			.cnu_init_dout_30    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 30]),
			.cnu_init_dout_31    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 31]),
			.cnu_init_dout_32    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 32]),
			.cnu_init_dout_33    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 33]),
			.cnu_init_dout_34    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 34]),
			.cnu_init_dout_35    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 35]),
			.cnu_init_dout_36    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 36]),
			.cnu_init_dout_37    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 37]),
			.cnu_init_dout_38    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 38]),
			.cnu_init_dout_39    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 39]),
			.cnu_init_dout_40    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 40]),
			.cnu_init_dout_41    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 41]),
			.cnu_init_dout_42    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 42]),
			.cnu_init_dout_43    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 43]),
			.cnu_init_dout_44    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 44]),
			.cnu_init_dout_45    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 45]),
			.cnu_init_dout_46    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 46]),
			.cnu_init_dout_47    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 47]),
			.cnu_init_dout_48    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 48]),
			.cnu_init_dout_49    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 49]),
			.cnu_init_dout_50    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 50]),
			.cnu_init_dout_51    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 51]),
			.cnu_init_dout_52    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 52]),
			.cnu_init_dout_53    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 53]),
			.cnu_init_dout_54    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 54]),
			.cnu_init_dout_55    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 55]),
			.cnu_init_dout_56    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 56]),
			.cnu_init_dout_57    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 57]),
			.cnu_init_dout_58    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 58]),
			.cnu_init_dout_59    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 59]),
			.cnu_init_dout_60    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 60]),
			.cnu_init_dout_61    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 61]),
			.cnu_init_dout_62    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 62]),
			.cnu_init_dout_63    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 63]),
			.cnu_init_dout_64    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 64]),
			.cnu_init_dout_65    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 65]),
			.cnu_init_dout_66    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 66]),
			.cnu_init_dout_67    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 67]),
			.cnu_init_dout_68    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 68]),
			.cnu_init_dout_69    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 69]),
			.cnu_init_dout_70    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 70]),
			.cnu_init_dout_71    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 71]),
			.cnu_init_dout_72    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 72]),
			.cnu_init_dout_73    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 73]),
			.cnu_init_dout_74    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 74]),
			.cnu_init_dout_75    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 75]),
			.cnu_init_dout_76    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 76]),
			.cnu_init_dout_77    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 77]),
			.cnu_init_dout_78    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 78]),
			.cnu_init_dout_79    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 79]),
			.cnu_init_dout_80    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 80]),
			.cnu_init_dout_81    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 81]),
			.cnu_init_dout_82    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 82]),
			.cnu_init_dout_83    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 83]),
			.cnu_init_dout_84    (ch_msg_fetchOut_0[submatrix_id*CHECK_PARALLELISM + 84]),

			.din        (ch_msg_genIn[submatrix_id]),

			.read_addr  (submatrix_ch_ram_rd_addr[submatrix_id]),
			.write_addr (submatrix_ch_ram_wr_addr[submatrix_id]),
			.we         (ch_ram_we),
			.read_clk   (ch_ram_rd_clk),
			.write_clk  (ch_ram_wr_clk),
			.rstn       (decoder_rstn)
		);
		// Updating the Channel RAMs by either initally channel messages (from AWGNs) or circularly shifted channel messages
		assign submatrix_ch_ram_wr_addr[submatrix_id] = (ch_ram_init_we == 1'b1) ? submatrix_chInit_wr_addr[submatrix_id] :
														(ch_ram_wb == 1'b1     ) ? submatrix_chLayer_wr_addr[submatrix_id] : 
																				   CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
		localparam 	CH_RAM_WR_UNIT = CHECK_PARALLELISM*ROW_CHUNK_NUM*QUAN_SIZE; // 85*4=340-bit
		always @(*) begin
			case (submatrix_ch_ram_wr_addr[submatrix_id])
				0 : ch_msg_genIn[submatrix_id] <= coded_block[submatrix_id][(0+1)*CH_DATA_WIDTH-1:0*CH_DATA_WIDTH];
				1 : ch_msg_genIn[submatrix_id] <= coded_block[submatrix_id][(1+1)*CH_DATA_WIDTH-1:1*CH_DATA_WIDTH];
				2 : ch_msg_genIn[submatrix_id] <= coded_block[submatrix_id][(2+1)*CH_DATA_WIDTH-1:2*CH_DATA_WIDTH];
				3 : ch_msg_genIn[submatrix_id] <= coded_block[submatrix_id][(3+1)*CH_DATA_WIDTH-1:3*CH_DATA_WIDTH];
				4 : ch_msg_genIn[submatrix_id] <= coded_block[submatrix_id][(4+1)*CH_DATA_WIDTH-1:4*CH_DATA_WIDTH];
				5 : ch_msg_genIn[submatrix_id] <= coded_block[submatrix_id][(5+1)*CH_DATA_WIDTH-1:5*CH_DATA_WIDTH];
				6 : ch_msg_genIn[submatrix_id] <= coded_block[submatrix_id][(6+1)*CH_DATA_WIDTH-1:6*CH_DATA_WIDTH];
				7 : ch_msg_genIn[submatrix_id] <= coded_block[submatrix_id][(7+1)*CH_DATA_WIDTH-1:7*CH_DATA_WIDTH];
				8 : ch_msg_genIn[submatrix_id] <= coded_block[submatrix_id][(8+1)*CH_DATA_WIDTH-1:8*CH_DATA_WIDTH];
				default : ch_msg_genIn[submatrix_id] <= coded_block[submatrix_id][(0+1)*CH_DATA_WIDTH-1:0*CH_DATA_WIDTH];
			endcase
		end

		initial submatrix_chInit_wr_addr[submatrix_id] <= 0;
		always @(posedge write_clk) begin
			if(decoder_rstn == 1'b0)
				submatrix_chInit_wr_addr[submatrix_id] <= 0;
			else if(iter_termination == 1'b1)
				submatrix_chInit_wr_addr[submatrix_id] <= 0;
			else if(ch_ram_init_we == 1'b1) begin
				// In the inital channel MSGs writing, execution is only done at the first layer of first iteration
				// Thus, only the first (z/Pc) pages across CH-RAMs are written, e,g., z(=765) / Pc(=85) = 9
				if(submatrix_chInit_wr_addr[submatrix_id] == ROW_CHUNK_NUM-1)
					submatrix_chInit_wr_addr[submatrix_id] <= CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
				else
					submatrix_chInit_wr_addr[submatrix_id] <= submatrix_chInit_wr_addr[submatrix_id]+1;
			end
			else
				submatrix_chInit_wr_addr[submatrix_id] <= submatrix_chInit_wr_addr[submatrix_id];
		end
	/*--------------------------------------------------------------------------*/
	// Channel messages RAMs write-page addresses
		reg [ROW_CHUNK_NUM-1:0] ch_ramRD_row_chunk_cnt;
		reg [LAYER_NUM-1:0] chLayer_wr_layer_cnt; // to identify the currently target layer of which the channel messages is being written back onto CH-RAMs circularly.
		always @(posedge read_clk) begin 
			if(decoder_rstn == 1'b0) 
				chLayer_wr_layer_cnt <= 1;
			else if(ch_ram_wb == 1'b1 && ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1)
				chLayer_wr_layer_cnt[LAYER_NUM-1:0] <= {chLayer_wr_layer_cnt[LAYER_NUM-2:0], chLayer_wr_layer_cnt[LAYER_NUM-1]};
		end
		always @(posedge read_clk) begin
			if(decoder_rstn == 1'b0) ch_ramRD_row_chunk_cnt <= 1;
			else if(ch_ram_wb == 1'b1) ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-1:0] <= {ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-2:0], ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-1]};
			else ch_ramRD_row_chunk_cnt <= ch_ramRD_row_chunk_cnt;
		end
		initial submatrix_chLayer_wr_addr[submatrix_id] <= 0;
		always @(posedge read_clk) begin
			if(decoder_rstn == 1'b0) 
				submatrix_chLayer_wr_addr[submatrix_id] <= START_PAGE_1_0+CH_RAM_WB_ADDR_BASE_1_0;
			else if(ch_ram_wb == 1'b1) begin
				// page increment pattern within layer 0
				if(chLayer_wr_layer_cnt[0] == 1) begin
					if(ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
						submatrix_chLayer_wr_addr[submatrix_id] <= START_PAGE_1_1+CH_RAM_WB_ADDR_BASE_1_1; // to move on to beginning of layer 1
					else if(ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_0-1] == 1'b1)
							submatrix_chLayer_wr_addr[submatrix_id] <= CH_RAM_WB_ADDR_BASE_1_0; 
					else
						submatrix_chLayer_wr_addr[submatrix_id] <= submatrix_chLayer_wr_addr[submatrix_id]+1;
				end
				// page increment pattern within layer 1
				if(chLayer_wr_layer_cnt[1] == 1) begin
					if(ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-1] == 1'b1) 
						submatrix_chLayer_wr_addr[submatrix_id] <= CH_RAM_DEPTH; // writing down the dummy data onto unused memory page so as to handle exception due to assertion of "Write-Enable" at wrong timing.
					else if(ch_ramRD_row_chunk_cnt[ROW_CHUNK_NUM-START_PAGE_1_1-1] == 1'b1)
						submatrix_chLayer_wr_addr[submatrix_id] <= CH_RAM_WB_ADDR_BASE_1_1; 
					else
						submatrix_chLayer_wr_addr[submatrix_id] <= submatrix_chLayer_wr_addr[submatrix_id]+1;
				end
				// Since channel messages are constant over all iterations of one codeword decoding process, 
				// the channel messages are thereby not necessarily written back circularly at last layer.
				// Because of the fact that the channel messages for first layer had been written onto their memory region at initial state of codeword decoding process.
			end
		end
		/*--------------------------------------------------------------------------*/
		// Channel messages RAMs Fetching addresses
		always @(posedge read_clk) begin
			if(decoder_rstn == 1'b0)
				submatrix_ch_ram_rd_addr[submatrix_id] <= 0;
			else if(ch_ram_fetch == 1'b1) begin
				if(submatrix_ch_ram_rd_addr[submatrix_id] == CH_RAM_DEPTH-1)
					submatrix_ch_ram_rd_addr[submatrix_id] <= 0;
				else
					submatrix_ch_ram_rd_addr[submatrix_id] <= submatrix_ch_ram_rd_addr[submatrix_id]+1;
			end
			else
				submatrix_ch_ram_rd_addr[submatrix_id] <= submatrix_ch_ram_rd_addr[submatrix_id];
		end
		/*--------------------------------------------------------------------------*/
		// V2C messages MEMs Fetching addresses
			always @(posedge read_clk) begin
				if(decoder_rstn == 1'b0)
					v2c_mem_page_rd_addr[submatrix_id] <= V2C_MEM_ADDR_BASE;
				else if(v2c_mem_fetch == 1'b1) begin
					if(v2c_mem_page_rd_addr[submatrix_id] == V2C_MEM_ADDR_BASE+ROW_CHUNK_NUM-1)
						v2c_mem_page_rd_addr[submatrix_id] <= V2C_MEM_ADDR_BASE;
					else
						v2c_mem_page_rd_addr[submatrix_id] <= v2c_mem_page_rd_addr[submatrix_id]+1;
				end
				else
					v2c_mem_page_rd_addr[submatrix_id] <= v2c_mem_page_rd_addr[submatrix_id];
			end
		/*--------------------------------------------------------------------------*/
		// C2V messages MEMs Fetching addresses
			always @(posedge read_clk) begin
				if(decoder_rstn == 1'b0)
					c2v_mem_page_rd_addr[submatrix_id] <= C2V_MEM_ADDR_BASE;
				else if(c2v_mem_fetch == 1'b1) begin
					if(c2v_mem_page_rd_addr[submatrix_id] == C2V_MEM_ADDR_BASE+ROW_CHUNK_NUM-1)
						c2v_mem_page_rd_addr[submatrix_id] <= C2V_MEM_ADDR_BASE;
					else
						c2v_mem_page_rd_addr[submatrix_id] <= c2v_mem_page_rd_addr[submatrix_id]+1;
				end
				else
					c2v_mem_page_rd_addr[submatrix_id] <= c2v_mem_page_rd_addr[submatrix_id];
			end
	end
endgenerate
/*--------------------------------------------------------------------------*/
// Channel messages Circular Shift Factor
always @(posedge read_clk) begin
	if(decoder_rstn == 1'b0) begin
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
	initial begin
		// do something

		init();
		repeat(10)@(posedge read_clk);

		wait(iter_termination == 1'b1);
		repeat(1)@(posedge read_clk);
		$fclose(pageAlign_tb_fd);
		$fclose(cnu_bs_out_fd);
		//$fclose(cnu_bs_in_fd);
		$finish;
	end
endmodule