module submatrix_process_element #(
	parameter QUAN_SIZE = 4,
	parameter CN_DEGREE = 10,
	parameter VN_DEGREE = 3,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,
	parameter CNU_FUNC_CYCLE = 4, // the latency of one CNU (min approximation)

	// Parameters of Partial-VNU IB-RAMs
	parameter VN_ROM_RD_BW = 8,
	parameter VN_ROM_ADDR_BW = 11,
	parameter VN_PAGE_ADDR_BW = 6,
	parameter DN_ROM_RD_BW = 2,
	parameter DN_ROM_ADDR_BW = 11,
	parameter DN_PAGE_ADDR_BW = 6,
	parameter VNU3_INSTANTIATE_NUM  = 5,
	parameter VNU3_INSTANTIATE_UNIT =  2, // number of partial-VNUs instatiated in one modules (in order to reduce source code size)
	parameter BANK_NUM = 2,
	parameter IB_VNU_DECOMP_funNum = 2,
	parameter PIPELINE_DEPTH = 3,
	parameter VN_PIPELINE_DEPTH = 3,
	parameter DN_PIPELINE_DEPTH = 3,
	parameter MULTI_FRAME_NUM   = 2,

	// Parameter for Channel Buffers
	parameter CH_FETCH_LATENCY = 2,
	parameter CNU_INIT_FETCH_LATENCY = 1,
	parameter CH_DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter CH_MSG_NUM = CHECK_PARALLELISM*CN_DEGREE
) (
	// Output prot of hard decision messages
	output wire [CH_MSG_NUM-1:0] hard_decision,
	// Output port of extrinsic variable-to-check messages
	output wire [CH_DATA_WIDTH-1:0] submatrix_0_v2c, // outgoing to v2c memories throught BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_1_v2c, // outgoing to v2c memories throught BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_2_v2c, // outgoing to v2c memories throught BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_3_v2c, // outgoing to v2c memories throught BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_4_v2c, // outgoing to v2c memories throught BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_5_v2c, // outgoing to v2c memories throught BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_6_v2c, // outgoing to v2c memories throught BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_7_v2c, // outgoing to v2c memories throught BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_8_v2c, // outgoing to v2c memories throught BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_9_v2c, // outgoing to v2c memories throught BSs and PAs
	// Output port of extrinsic check-to-variable messages
	output wire [CH_DATA_WIDTH-1:0] submatrix_0_c2v, // outgoing to c2v memories through BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_1_c2v, // outgoing to c2v memories through BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_2_c2v, // outgoing to c2v memories through BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_3_c2v, // outgoing to c2v memories through BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_4_c2v, // outgoing to c2v memories through BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_5_c2v, // outgoing to c2v memories through BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_6_c2v, // outgoing to c2v memories through BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_7_c2v, // outgoing to c2v memories through BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_8_c2v, // outgoing to c2v memories through BSs and PAs
	output wire [CH_DATA_WIDTH-1:0] submatrix_9_c2v, // outgoing to c2v memories through BSs and PAs

	// Input port of channel messages
	input wire [CH_DATA_WIDTH-1:0] submatrix_0_ch_msgIn,
	input wire [CH_DATA_WIDTH-1:0] submatrix_1_ch_msgIn,
	input wire [CH_DATA_WIDTH-1:0] submatrix_2_ch_msgIn,
	input wire [CH_DATA_WIDTH-1:0] submatrix_3_ch_msgIn,
	input wire [CH_DATA_WIDTH-1:0] submatrix_4_ch_msgIn,
	input wire [CH_DATA_WIDTH-1:0] submatrix_5_ch_msgIn,
	input wire [CH_DATA_WIDTH-1:0] submatrix_6_ch_msgIn,
	input wire [CH_DATA_WIDTH-1:0] submatrix_7_ch_msgIn,
	input wire [CH_DATA_WIDTH-1:0] submatrix_8_ch_msgIn,
	input wire [CH_DATA_WIDTH-1:0] submatrix_9_ch_msgIn,
	// Input port of intrinsic check-to-variable messages updated by previous layers other than any of {old data of current layer, recently updated data of next layer}
	input wire [CH_DATA_WIDTH-1:0] submatrix_0_in_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [CH_DATA_WIDTH-1:0] submatrix_1_in_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [CH_DATA_WIDTH-1:0] submatrix_2_in_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [CH_DATA_WIDTH-1:0] submatrix_3_in_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [CH_DATA_WIDTH-1:0] submatrix_4_in_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [CH_DATA_WIDTH-1:0] submatrix_5_in_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [CH_DATA_WIDTH-1:0] submatrix_6_in_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [CH_DATA_WIDTH-1:0] submatrix_7_in_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [CH_DATA_WIDTH-1:0] submatrix_8_in_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	input wire [CH_DATA_WIDTH-1:0] submatrix_9_in_c2v0, // extrinsic message updated at previous layer, i.e., data fetched from V2C Memory regtion
	// Input port of intrinsic variable-to-check messages
	input wire [CH_DATA_WIDTH-1:0] submatrix_0_in_v2c0,
	input wire [CH_DATA_WIDTH-1:0] submatrix_1_in_v2c1,
	input wire [CH_DATA_WIDTH-1:0] submatrix_2_in_v2c2,
	input wire [CH_DATA_WIDTH-1:0] submatrix_3_in_v2c3,
	input wire [CH_DATA_WIDTH-1:0] submatrix_4_in_v2c4,
	input wire [CH_DATA_WIDTH-1:0] submatrix_5_in_v2c5,
	input wire [CH_DATA_WIDTH-1:0] submatrix_6_in_v2c6,
	input wire [CH_DATA_WIDTH-1:0] submatrix_7_in_v2c7,
	input wire [CH_DATA_WIDTH-1:0] submatrix_8_in_v2c8,
	input wire [CH_DATA_WIDTH-1:0] submatrix_9_in_v2c9,

	input wire read_clk,
	input wire vnu_read_addr_offset,
	input wire v2c_src,
	input wire v2c_latch_en,
	input wire c2v_latch_en,
	input wire [1:0] load, //({v2c_load[0], c2v_load[0]}),
	input wire [1:0] parallel_en,//({v2c_msg_en[0], c2v_msg_en[0]}),
	input wire rstn,

	// Iteration-Refresh Page Address
	input wire [VN_PAGE_ADDR_BW+1-1:0] vnu_page_addr_ram_0, // the MSB decides refreshed target, i.e., upper page group or lower page group
	input wire [VN_PAGE_ADDR_BW+1-1:0] vnu_page_addr_ram_1, // the MSB decides refreshed target, i.e., upper page group or lower page group
	input wire [VN_PAGE_ADDR_BW+1-1:0] vnu_page_addr_ram_2, // the MSB decides refreshed target, i.e., upper page group or lower page group // the last one is for decision node
	//Iteration-Refresh Page Data

	input wire [VN_ROM_RD_BW-1:0] vnu_ram_write_dataA_0, // from portA of IB-ROM
	input wire [VN_ROM_RD_BW-1:0] vnu_ram_write_dataB_0, // from portB of IB-ROM
	input wire [VN_ROM_RD_BW-1:0] vnu_ram_write_dataA_1, // from portA of IB-ROM
	input wire [VN_ROM_RD_BW-1:0] vnu_ram_write_dataB_1, // from portB of IB-ROM
	input wire [DN_ROM_RD_BW-1:0] vnu_ram_write_dataA_2, // from portA of IB-ROM (for decision node)
	input wire [DN_ROM_RD_BW-1:0] vnu_ram_write_dataB_2, // from portB of IB-ROM (for decision node)

	input wire [VN_DEGREE-1:0] vnu_ib_ram_we,
	input wire vn_write_clk,
	input wire dn_write_clk
);

/*--------------------------------------------------------------------------*/
// Channel Buffers
localparam CH_BUFF_DEPTH = ROW_CHUNK_NUM*LAYER_NUM;
wire [CH_DATA_WIDTH-1:0] ch_msg_genIn [0:CN_DEGREE-1];
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_0 [0:CH_MSG_NUM-1]; // [0:849]
wire [QUAN_SIZE-1:0] ch_msg_fetchOut_1 [0:CH_MSG_NUM-1]; // [0:849]
genvar submatrix_id;
generate
	for(submatrix_id=0; submatrix_id<CN_DEGREE; submatrix_id=submatrix_id+1) begin : ch_buff_inst
		ch_msg_ram #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.ROW_CHUNK_NUM(ROW_CHUNK_NUM),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.DEPTH(CH_BUFF_DEPTH),
			.DATA_WIDTH(CH_DATA_WIDTH),
			.ADDR_WIDTH($clog2(CH_BUFF_DEPTH)),
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

			.read_addr  (read_addr),
			.write_addr (write_addr),
			.we         (we),
			.read_clk   (read_clk),
			.write_clk  (write_clk),
			.rstn       (rstn)
		);
	end
endgenerate
assign ch_msg_genIn[0] = submatrix_0_ch_msgIn[CH_DATA_WIDTH-1:0];
assign ch_msg_genIn[1] = submatrix_1_ch_msgIn[CH_DATA_WIDTH-1:0]; 
assign ch_msg_genIn[2] = submatrix_2_ch_msgIn[CH_DATA_WIDTH-1:0]; 
assign ch_msg_genIn[3] = submatrix_3_ch_msgIn[CH_DATA_WIDTH-1:0]; 
assign ch_msg_genIn[4] = submatrix_4_ch_msgIn[CH_DATA_WIDTH-1:0]; 
assign ch_msg_genIn[5] = submatrix_5_ch_msgIn[CH_DATA_WIDTH-1:0]; 
assign ch_msg_genIn[6] = submatrix_6_ch_msgIn[CH_DATA_WIDTH-1:0]; 
assign ch_msg_genIn[7] = submatrix_7_ch_msgIn[CH_DATA_WIDTH-1:0]; 
assign ch_msg_genIn[8] = submatrix_8_ch_msgIn[CH_DATA_WIDTH-1:0]; 
assign ch_msg_genIn[9] = submatrix_9_ch_msgIn[CH_DATA_WIDTH-1:0]; 
/*--------------------------------------------------------------------------*/
// 1xPc number of CNUs and dcxPc number of VNUs in total
genvar i;
generate
	for(i=0;i<CHECK_PARALLELISM;i=i+1) begin : submatrix_pe_inst
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
			.PIPELINE_DEPTH(PIPELINE_DEPTH),
			.VN_PIPELINE_DEPTH(VN_PIPELINE_DEPTH),
			.DN_PIPELINE_DEPTH(DN_PIPELINE_DEPTH),
			.MULTI_FRAME_NUM(MULTI_FRAME_NUM)
		) inst_row_process_element (
			.hard_decision         (hard_decision[(i+1)*CN_DEGREE-1:i*CN_DEGREE]),
			.vnu0_v2c              (submatrix_0_v2c[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu1_v2c              (submatrix_1_v2c[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu2_v2c              (submatrix_2_v2c[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu3_v2c              (submatrix_3_v2c[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu4_v2c              (submatrix_4_v2c[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu5_v2c              (submatrix_5_v2c[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu6_v2c              (submatrix_6_v2c[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu7_v2c              (submatrix_7_v2c[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu8_v2c              (submatrix_8_v2c[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu9_v2c              (submatrix_9_v2c[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),

			.cnu0_c2v              (submatrix_0_c2v[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu1_c2v              (submatrix_1_c2v[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu2_c2v              (submatrix_2_c2v[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu3_c2v              (submatrix_3_c2v[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu4_c2v              (submatrix_4_c2v[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu5_c2v              (submatrix_5_c2v[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu6_c2v              (submatrix_6_c2v[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu7_c2v              (submatrix_7_c2v[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu8_c2v              (submatrix_8_c2v[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu9_c2v              (submatrix_9_c2v[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),

			.vnu0_ch_msgIn         (ch_msg_fetchOut_1[(0*CHECK_PARALLELISM)+i]), //(submatrix_0_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu1_ch_msgIn         (ch_msg_fetchOut_1[(1*CHECK_PARALLELISM)+i]), //(submatrix_1_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu2_ch_msgIn         (ch_msg_fetchOut_1[(2*CHECK_PARALLELISM)+i]), //(submatrix_2_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu3_ch_msgIn         (ch_msg_fetchOut_1[(3*CHECK_PARALLELISM)+i]), //(submatrix_3_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu4_ch_msgIn         (ch_msg_fetchOut_1[(4*CHECK_PARALLELISM)+i]), //(submatrix_4_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu5_ch_msgIn         (ch_msg_fetchOut_1[(5*CHECK_PARALLELISM)+i]), //(submatrix_5_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu6_ch_msgIn         (ch_msg_fetchOut_1[(6*CHECK_PARALLELISM)+i]), //(submatrix_6_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu7_ch_msgIn         (ch_msg_fetchOut_1[(7*CHECK_PARALLELISM)+i]), //(submatrix_7_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu8_ch_msgIn         (ch_msg_fetchOut_1[(8*CHECK_PARALLELISM)+i]), //(submatrix_8_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu9_ch_msgIn         (ch_msg_fetchOut_1[(9*CHECK_PARALLELISM)+i]), //(submatrix_9_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),

			.cnu_ch_msgIn_0         (ch_msg_fetchOut_0[(0*CHECK_PARALLELISM)+i]), //(submatrix_0_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu_ch_msgIn_1         (ch_msg_fetchOut_0[(1*CHECK_PARALLELISM)+i]), //(submatrix_1_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu_ch_msgIn_2         (ch_msg_fetchOut_0[(2*CHECK_PARALLELISM)+i]), //(submatrix_2_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu_ch_msgIn_3         (ch_msg_fetchOut_0[(3*CHECK_PARALLELISM)+i]), //(submatrix_3_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu_ch_msgIn_4         (ch_msg_fetchOut_0[(4*CHECK_PARALLELISM)+i]), //(submatrix_4_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu_ch_msgIn_5         (ch_msg_fetchOut_0[(5*CHECK_PARALLELISM)+i]), //(submatrix_5_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu_ch_msgIn_6         (ch_msg_fetchOut_0[(6*CHECK_PARALLELISM)+i]), //(submatrix_6_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu_ch_msgIn_7         (ch_msg_fetchOut_0[(7*CHECK_PARALLELISM)+i]), //(submatrix_7_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu_ch_msgIn_8         (ch_msg_fetchOut_0[(8*CHECK_PARALLELISM)+i]), //(submatrix_8_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnu_ch_msgIn_9         (ch_msg_fetchOut_0[(9*CHECK_PARALLELISM)+i]), //(submatrix_9_ch_msgIn[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),

			.vnu0_post_c2v0        (submatrix_0_in_c2v0[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu1_post_c2v0        (submatrix_1_in_c2v0[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu2_post_c2v0        (submatrix_2_in_c2v0[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu3_post_c2v0        (submatrix_3_in_c2v0[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu4_post_c2v0        (submatrix_4_in_c2v0[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu5_post_c2v0        (submatrix_5_in_c2v0[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu6_post_c2v0        (submatrix_6_in_c2v0[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu7_post_c2v0        (submatrix_7_in_c2v0[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu8_post_c2v0        (submatrix_8_in_c2v0[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.vnu9_post_c2v0        (submatrix_9_in_c2v0[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),

			.cnuIn_v2c0            (submatrix_0_in_v2c0[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnuIn_v2c1            (submatrix_1_in_v2c1[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnuIn_v2c2            (submatrix_2_in_v2c2[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnuIn_v2c3            (submatrix_3_in_v2c3[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnuIn_v2c4            (submatrix_4_in_v2c4[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnuIn_v2c5            (submatrix_5_in_v2c5[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnuIn_v2c6            (submatrix_6_in_v2c6[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnuIn_v2c7            (submatrix_7_in_v2c7[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnuIn_v2c8            (submatrix_8_in_v2c8[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),
			.cnuIn_v2c9            (submatrix_9_in_v2c9[(i+1)*QUAN_SIZE-1:i*QUAN_SIZE]),

			.read_clk              (read_clk),
			.vnu_read_addr_offset  (vnu_read_addr_offset),
			.v2c_src               (v2c_src),
			.v2c_latch_en          (v2c_latch_en),
			.c2v_latch_en          (c2v_latch_en),
			.load                  (load),
			.parallel_en           (parallel_en),
			.rstn                  (rstn),
			.vnu_page_addr_ram_0   (vnu_page_addr_ram_0),
			.vnu_page_addr_ram_1   (vnu_page_addr_ram_1),
			.vnu_page_addr_ram_2   (vnu_page_addr_ram_2),
			.vnu_ram_write_dataA_0 (vnu_ram_write_dataA_0),
			.vnu_ram_write_dataB_0 (vnu_ram_write_dataB_0),
			.vnu_ram_write_dataA_1 (vnu_ram_write_dataA_1),
			.vnu_ram_write_dataB_1 (vnu_ram_write_dataB_1),
			.vnu_ram_write_dataA_2 (vnu_ram_write_dataA_2),
			.vnu_ram_write_dataB_2 (vnu_ram_write_dataB_2),
			.vnu_ib_ram_we         (vnu_ib_ram_we),
			.vn_write_clk          (vn_write_clk),
			.dn_write_clk          (dn_write_clk)
		);
	end
endgenerate
endmodule