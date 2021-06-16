`include "define.vh"

module 	entire_message_passing_area_eval #(
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
	output reg mem_to_cnu_sub0_reg1,
	output reg mem_to_cnu_sub1_reg1,
	output reg mem_to_cnu_sub2_reg1,
	output reg mem_to_cnu_sub3_reg1,
	output reg mem_to_cnu_sub4_reg1,
	output reg mem_to_cnu_sub5_reg1,
	output reg mem_to_cnu_sub6_reg1,
	output reg mem_to_cnu_sub7_reg1,
	output reg mem_to_cnu_sub8_reg1,
	output reg mem_to_cnu_sub9_reg1,

	output reg mem_to_vnu_sub0_reg1,
	output reg mem_to_vnu_sub1_reg1,
	output reg mem_to_vnu_sub2_reg1,
	output reg mem_to_vnu_sub3_reg1,
	output reg mem_to_vnu_sub4_reg1,
	output reg mem_to_vnu_sub5_reg1,
	output reg mem_to_vnu_sub6_reg1,
	output reg mem_to_vnu_sub7_reg1,
	output reg mem_to_vnu_sub8_reg1,
	output reg mem_to_vnu_sub9_reg1,

	input wire c2v_bs_in_sub0,
	input wire c2v_bs_in_sub1,
	input wire c2v_bs_in_sub2,
	input wire c2v_bs_in_sub3,
	input wire c2v_bs_in_sub4,
	input wire c2v_bs_in_sub5,
	input wire c2v_bs_in_sub6,
	input wire c2v_bs_in_sub7,
	input wire c2v_bs_in_sub8,
	input wire c2v_bs_in_sub9,

	input wire v2c_bs_in_sub0,
	input wire v2c_bs_in_sub1,
	input wire v2c_bs_in_sub2,
	input wire v2c_bs_in_sub3,
	input wire v2c_bs_in_sub4,
	input wire v2c_bs_in_sub5,
	input wire v2c_bs_in_sub6,
	input wire v2c_bs_in_sub7,
	input wire v2c_bs_in_sub8,
	input wire v2c_bs_in_sub9,

	input wire ch_bs_in_sub0,
	input wire ch_bs_in_sub1,
	input wire ch_bs_in_sub2,
	input wire ch_bs_in_sub3,
	input wire ch_bs_in_sub4,
	input wire ch_bs_in_sub5,
	input wire ch_bs_in_sub6,
	input wire ch_bs_in_sub7,
	input wire ch_bs_in_sub8,
	input wire ch_bs_in_sub9,
	

	// control signals
	input wire c2v_bs_en,
	input wire v2c_bs_en,
	input wire vnu_bs_src,
	input wire c2v_mem_we,
	input wire v2c_mem_we,
	input wire [LAYER_NUM-1:0] v2c_layer_cnt, // layer counter is synchronised with state of VNU FSM, the c2v_layer_cnt is thereby not needed
	input wire c2v_last_row_chunk,
	input wire v2c_last_row_chunk,
	input wire [ROW_CHUNK_NUM-1:0] c2v_row_chunk_cnt,
	input wire [ROW_CHUNK_NUM-1:0] v2c_row_chunk_cnt,

	input wire CLK_300_N,
    input wire CLK_300_P,
	input wire rstn
);

wire clk_100MHz, clk_lock, read_clk;
clock_domain_wrapper sync_clock_u0 (
	.clk_100MHz (clk_100MHz),
   	//.clk_150MHz (clk_150MHz),
   	//.clk_200MHz (clk_200MHz),
   	//.clk_300MHz (clk_300MHz),
   	//.clk_50MHz (clk_50MHz),

   	.clk_300mhz_clk_n (CLK_300_N),
   	.clk_300mhz_clk_p (CLK_300_P),
   	.locked_0 (clk_lock),
   	.rstn (rstn)
);
assign read_clk = (clk_lock & clk_100MHz);

wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub0_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_cnu_sub0_reg1 <= 0; else mem_to_cnu_sub0_reg1 <= (|mem_to_cnu_sub0_reg0[C2V_DATA_WIDTH-1:0]); end
wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub1_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_cnu_sub1_reg1 <= 0; else mem_to_cnu_sub1_reg1 <= (|mem_to_cnu_sub1_reg0[C2V_DATA_WIDTH-1:0]); end
wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub2_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_cnu_sub2_reg1 <= 0; else mem_to_cnu_sub2_reg1 <= (|mem_to_cnu_sub2_reg0[C2V_DATA_WIDTH-1:0]); end
wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub3_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_cnu_sub3_reg1 <= 0; else mem_to_cnu_sub3_reg1 <= (|mem_to_cnu_sub3_reg0[C2V_DATA_WIDTH-1:0]); end
wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub4_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_cnu_sub4_reg1 <= 0; else mem_to_cnu_sub4_reg1 <= (|mem_to_cnu_sub4_reg0[C2V_DATA_WIDTH-1:0]); end
wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub5_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_cnu_sub5_reg1 <= 0; else mem_to_cnu_sub5_reg1 <= (|mem_to_cnu_sub5_reg0[C2V_DATA_WIDTH-1:0]); end
wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub6_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_cnu_sub6_reg1 <= 0; else mem_to_cnu_sub6_reg1 <= (|mem_to_cnu_sub6_reg0[C2V_DATA_WIDTH-1:0]); end
wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub7_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_cnu_sub7_reg1 <= 0; else mem_to_cnu_sub7_reg1 <= (|mem_to_cnu_sub7_reg0[C2V_DATA_WIDTH-1:0]); end
wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub8_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_cnu_sub8_reg1 <= 0; else mem_to_cnu_sub8_reg1 <= (|mem_to_cnu_sub8_reg0[C2V_DATA_WIDTH-1:0]); end
wire [C2V_DATA_WIDTH-1:0] mem_to_cnu_sub9_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_cnu_sub9_reg1 <= 0; else mem_to_cnu_sub9_reg1 <= (|mem_to_cnu_sub9_reg0[C2V_DATA_WIDTH-1:0]); end
wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub0_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_vnu_sub0_reg1 <= 0; else mem_to_vnu_sub0_reg1 <= (|mem_to_vnu_sub0_reg0[C2V_DATA_WIDTH-1:0]); end
wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub1_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_vnu_sub1_reg1 <= 0; else mem_to_vnu_sub1_reg1 <= (|mem_to_vnu_sub1_reg0[C2V_DATA_WIDTH-1:0]); end
wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub2_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_vnu_sub2_reg1 <= 0; else mem_to_vnu_sub2_reg1 <= (|mem_to_vnu_sub2_reg0[C2V_DATA_WIDTH-1:0]); end
wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub3_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_vnu_sub3_reg1 <= 0; else mem_to_vnu_sub3_reg1 <= (|mem_to_vnu_sub3_reg0[C2V_DATA_WIDTH-1:0]); end
wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub4_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_vnu_sub4_reg1 <= 0; else mem_to_vnu_sub4_reg1 <= (|mem_to_vnu_sub4_reg0[C2V_DATA_WIDTH-1:0]); end
wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub5_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_vnu_sub5_reg1 <= 0; else mem_to_vnu_sub5_reg1 <= (|mem_to_vnu_sub5_reg0[C2V_DATA_WIDTH-1:0]); end
wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub6_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_vnu_sub6_reg1 <= 0; else mem_to_vnu_sub6_reg1 <= (|mem_to_vnu_sub6_reg0[C2V_DATA_WIDTH-1:0]); end
wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub7_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_vnu_sub7_reg1 <= 0; else mem_to_vnu_sub7_reg1 <= (|mem_to_vnu_sub7_reg0[C2V_DATA_WIDTH-1:0]); end
wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub8_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_vnu_sub8_reg1 <= 0; else mem_to_vnu_sub8_reg1 <= (|mem_to_vnu_sub8_reg0[C2V_DATA_WIDTH-1:0]); end
wire [V2C_DATA_WIDTH-1:0] mem_to_vnu_sub9_reg0;	always @(posedge read_clk) begin if(!rstn) mem_to_vnu_sub9_reg1 <= 0; else mem_to_vnu_sub9_reg1 <= (|mem_to_vnu_sub9_reg0[C2V_DATA_WIDTH-1:0]); end	
	entire_message_passing_wrapper #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.VN_DEGREE(VN_DEGREE),
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
			.mem_to_cnu_sub0    (mem_to_cnu_sub0_reg0),
			.mem_to_cnu_sub1    (mem_to_cnu_sub1_reg0),
			.mem_to_cnu_sub2    (mem_to_cnu_sub2_reg0),
			.mem_to_cnu_sub3    (mem_to_cnu_sub3_reg0),
			.mem_to_cnu_sub4    (mem_to_cnu_sub4_reg0),
			.mem_to_cnu_sub5    (mem_to_cnu_sub5_reg0),
			.mem_to_cnu_sub6    (mem_to_cnu_sub6_reg0),
			.mem_to_cnu_sub7    (mem_to_cnu_sub7_reg0),
			.mem_to_cnu_sub8    (mem_to_cnu_sub8_reg0),
			.mem_to_cnu_sub9    (mem_to_cnu_sub9_reg0),

			.mem_to_vnu_sub0    (mem_to_vnu_sub0_reg0),
			.mem_to_vnu_sub1    (mem_to_vnu_sub1_reg0),
			.mem_to_vnu_sub2    (mem_to_vnu_sub2_reg0),
			.mem_to_vnu_sub3    (mem_to_vnu_sub3_reg0),
			.mem_to_vnu_sub4    (mem_to_vnu_sub4_reg0),
			.mem_to_vnu_sub5    (mem_to_vnu_sub5_reg0),
			.mem_to_vnu_sub6    (mem_to_vnu_sub6_reg0),
			.mem_to_vnu_sub7    (mem_to_vnu_sub7_reg0),
			.mem_to_vnu_sub8    (mem_to_vnu_sub8_reg0),
			.mem_to_vnu_sub9    (mem_to_vnu_sub9_reg0),

			.c2v_bs_in_sub0     ({{339{1'b1}}, c2v_bs_in_sub0}),
			.c2v_bs_in_sub1     ({{339{1'b1}}, c2v_bs_in_sub1}),
			.c2v_bs_in_sub2     ({{339{1'b1}}, c2v_bs_in_sub2}),
			.c2v_bs_in_sub3     ({{339{1'b1}}, c2v_bs_in_sub3}),
			.c2v_bs_in_sub4     ({{339{1'b1}}, c2v_bs_in_sub4}),
			.c2v_bs_in_sub5     ({{339{1'b1}}, c2v_bs_in_sub5}),
			.c2v_bs_in_sub6     ({{339{1'b1}}, c2v_bs_in_sub6}),
			.c2v_bs_in_sub7     ({{339{1'b1}}, c2v_bs_in_sub7}),
			.c2v_bs_in_sub8     ({{339{1'b1}}, c2v_bs_in_sub8}),
			.c2v_bs_in_sub9     ({{339{1'b1}}, c2v_bs_in_sub9}),

			.v2c_bs_in_sub0     ({{339{1'b1}}, v2c_bs_in_sub0}),
			.v2c_bs_in_sub1     ({{339{1'b1}}, v2c_bs_in_sub1}),
			.v2c_bs_in_sub2     ({{339{1'b1}}, v2c_bs_in_sub2}),
			.v2c_bs_in_sub3     ({{339{1'b1}}, v2c_bs_in_sub3}),
			.v2c_bs_in_sub4     ({{339{1'b1}}, v2c_bs_in_sub4}),
			.v2c_bs_in_sub5     ({{339{1'b1}}, v2c_bs_in_sub5}),
			.v2c_bs_in_sub6     ({{339{1'b1}}, v2c_bs_in_sub6}),
			.v2c_bs_in_sub7     ({{339{1'b1}}, v2c_bs_in_sub7}),
			.v2c_bs_in_sub8     ({{339{1'b1}}, v2c_bs_in_sub8}),
			.v2c_bs_in_sub9     ({{339{1'b1}}, v2c_bs_in_sub9}),

			.ch_bs_in_sub0      ({{339{1'b1}}, ch_bs_in_sub0}),
			.ch_bs_in_sub1      ({{339{1'b1}}, ch_bs_in_sub1}),
			.ch_bs_in_sub2      ({{339{1'b1}}, ch_bs_in_sub2}),
			.ch_bs_in_sub3      ({{339{1'b1}}, ch_bs_in_sub3}),
			.ch_bs_in_sub4      ({{339{1'b1}}, ch_bs_in_sub4}),
			.ch_bs_in_sub5      ({{339{1'b1}}, ch_bs_in_sub5}),
			.ch_bs_in_sub6      ({{339{1'b1}}, ch_bs_in_sub6}),
			.ch_bs_in_sub7      ({{339{1'b1}}, ch_bs_in_sub7}),
			.ch_bs_in_sub8      ({{339{1'b1}}, ch_bs_in_sub8}),
			.ch_bs_in_sub9      ({{339{1'b1}}, ch_bs_in_sub9}),

			.c2v_bs_en          (c2v_bs_en),
			.v2c_bs_en          (v2c_bs_en),
			.vnu_bs_src         (vnu_bs_src),
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