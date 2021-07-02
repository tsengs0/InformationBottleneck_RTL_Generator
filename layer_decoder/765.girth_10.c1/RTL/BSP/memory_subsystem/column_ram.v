`include "define.vh"
`include "mem_config.vh"
module column_ram_pc85 #(
	parameter QUAN_SIZE = 4,
	parameter CHECK_PARALLELISM = 85,
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 9,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH)
) (
	output wire [QUAN_SIZE-1:0] first_dout_0,
	output wire [QUAN_SIZE-1:0] first_dout_1,
	output wire [QUAN_SIZE-1:0] first_dout_2,
	output wire [QUAN_SIZE-1:0] first_dout_3,
	output wire [QUAN_SIZE-1:0] first_dout_4,
	output wire [QUAN_SIZE-1:0] first_dout_5,
	output wire [QUAN_SIZE-1:0] first_dout_6,
	output wire [QUAN_SIZE-1:0] first_dout_7,
	output wire [QUAN_SIZE-1:0] first_dout_8,
	output wire [QUAN_SIZE-1:0] first_dout_9,
	output wire [QUAN_SIZE-1:0] first_dout_10,
	output wire [QUAN_SIZE-1:0] first_dout_11,
	output wire [QUAN_SIZE-1:0] first_dout_12,
	output wire [QUAN_SIZE-1:0] first_dout_13,
	output wire [QUAN_SIZE-1:0] first_dout_14,
	output wire [QUAN_SIZE-1:0] first_dout_15,
	output wire [QUAN_SIZE-1:0] first_dout_16,
	output wire [QUAN_SIZE-1:0] first_dout_17,
	output wire [QUAN_SIZE-1:0] first_dout_18,
	output wire [QUAN_SIZE-1:0] first_dout_19,
	output wire [QUAN_SIZE-1:0] first_dout_20,
	output wire [QUAN_SIZE-1:0] first_dout_21,
	output wire [QUAN_SIZE-1:0] first_dout_22,
	output wire [QUAN_SIZE-1:0] first_dout_23,
	output wire [QUAN_SIZE-1:0] first_dout_24,
	output wire [QUAN_SIZE-1:0] first_dout_25,
	output wire [QUAN_SIZE-1:0] first_dout_26,
	output wire [QUAN_SIZE-1:0] first_dout_27,
	output wire [QUAN_SIZE-1:0] first_dout_28,
	output wire [QUAN_SIZE-1:0] first_dout_29,
	output wire [QUAN_SIZE-1:0] first_dout_30,
	output wire [QUAN_SIZE-1:0] first_dout_31,
	output wire [QUAN_SIZE-1:0] first_dout_32,
	output wire [QUAN_SIZE-1:0] first_dout_33,
	output wire [QUAN_SIZE-1:0] first_dout_34,
	output wire [QUAN_SIZE-1:0] first_dout_35,
	output wire [QUAN_SIZE-1:0] first_dout_36,
	output wire [QUAN_SIZE-1:0] first_dout_37,
	output wire [QUAN_SIZE-1:0] first_dout_38,
	output wire [QUAN_SIZE-1:0] first_dout_39,
	output wire [QUAN_SIZE-1:0] first_dout_40,
	output wire [QUAN_SIZE-1:0] first_dout_41,
	output wire [QUAN_SIZE-1:0] first_dout_42,
	output wire [QUAN_SIZE-1:0] first_dout_43,
	output wire [QUAN_SIZE-1:0] first_dout_44,
	output wire [QUAN_SIZE-1:0] first_dout_45,
	output wire [QUAN_SIZE-1:0] first_dout_46,
	output wire [QUAN_SIZE-1:0] first_dout_47,
	output wire [QUAN_SIZE-1:0] first_dout_48,
	output wire [QUAN_SIZE-1:0] first_dout_49,
	output wire [QUAN_SIZE-1:0] first_dout_50,
	output wire [QUAN_SIZE-1:0] first_dout_51,
	output wire [QUAN_SIZE-1:0] first_dout_52,
	output wire [QUAN_SIZE-1:0] first_dout_53,
	output wire [QUAN_SIZE-1:0] first_dout_54,
	output wire [QUAN_SIZE-1:0] first_dout_55,
	output wire [QUAN_SIZE-1:0] first_dout_56,
	output wire [QUAN_SIZE-1:0] first_dout_57,
	output wire [QUAN_SIZE-1:0] first_dout_58,
	output wire [QUAN_SIZE-1:0] first_dout_59,
	output wire [QUAN_SIZE-1:0] first_dout_60,
	output wire [QUAN_SIZE-1:0] first_dout_61,
	output wire [QUAN_SIZE-1:0] first_dout_62,
	output wire [QUAN_SIZE-1:0] first_dout_63,
	output wire [QUAN_SIZE-1:0] first_dout_64,
	output wire [QUAN_SIZE-1:0] first_dout_65,
	output wire [QUAN_SIZE-1:0] first_dout_66,
	output wire [QUAN_SIZE-1:0] first_dout_67,
	output wire [QUAN_SIZE-1:0] first_dout_68,
	output wire [QUAN_SIZE-1:0] first_dout_69,
	output wire [QUAN_SIZE-1:0] first_dout_70,
	output wire [QUAN_SIZE-1:0] first_dout_71,
	output wire [QUAN_SIZE-1:0] first_dout_72,
	output wire [QUAN_SIZE-1:0] first_dout_73,
	output wire [QUAN_SIZE-1:0] first_dout_74,
	output wire [QUAN_SIZE-1:0] first_dout_75,
	output wire [QUAN_SIZE-1:0] first_dout_76,
	output wire [QUAN_SIZE-1:0] first_dout_77,
	output wire [QUAN_SIZE-1:0] first_dout_78,
	output wire [QUAN_SIZE-1:0] first_dout_79,
	output wire [QUAN_SIZE-1:0] first_dout_80,
	output wire [QUAN_SIZE-1:0] first_dout_81,
	output wire [QUAN_SIZE-1:0] first_dout_82,
	output wire [QUAN_SIZE-1:0] first_dout_83,
	output wire [QUAN_SIZE-1:0] first_dout_84,

	output wire [QUAN_SIZE-1:0] second_dout_0,
	output wire [QUAN_SIZE-1:0] second_dout_1,
	output wire [QUAN_SIZE-1:0] second_dout_2,
	output wire [QUAN_SIZE-1:0] second_dout_3,
	output wire [QUAN_SIZE-1:0] second_dout_4,
	output wire [QUAN_SIZE-1:0] second_dout_5,
	output wire [QUAN_SIZE-1:0] second_dout_6,
	output wire [QUAN_SIZE-1:0] second_dout_7,
	output wire [QUAN_SIZE-1:0] second_dout_8,
	output wire [QUAN_SIZE-1:0] second_dout_9,
	output wire [QUAN_SIZE-1:0] second_dout_10,
	output wire [QUAN_SIZE-1:0] second_dout_11,
	output wire [QUAN_SIZE-1:0] second_dout_12,
	output wire [QUAN_SIZE-1:0] second_dout_13,
	output wire [QUAN_SIZE-1:0] second_dout_14,
	output wire [QUAN_SIZE-1:0] second_dout_15,
	output wire [QUAN_SIZE-1:0] second_dout_16,
	output wire [QUAN_SIZE-1:0] second_dout_17,
	output wire [QUAN_SIZE-1:0] second_dout_18,
	output wire [QUAN_SIZE-1:0] second_dout_19,
	output wire [QUAN_SIZE-1:0] second_dout_20,
	output wire [QUAN_SIZE-1:0] second_dout_21,
	output wire [QUAN_SIZE-1:0] second_dout_22,
	output wire [QUAN_SIZE-1:0] second_dout_23,
	output wire [QUAN_SIZE-1:0] second_dout_24,
	output wire [QUAN_SIZE-1:0] second_dout_25,
	output wire [QUAN_SIZE-1:0] second_dout_26,
	output wire [QUAN_SIZE-1:0] second_dout_27,
	output wire [QUAN_SIZE-1:0] second_dout_28,
	output wire [QUAN_SIZE-1:0] second_dout_29,
	output wire [QUAN_SIZE-1:0] second_dout_30,
	output wire [QUAN_SIZE-1:0] second_dout_31,
	output wire [QUAN_SIZE-1:0] second_dout_32,
	output wire [QUAN_SIZE-1:0] second_dout_33,
	output wire [QUAN_SIZE-1:0] second_dout_34,
	output wire [QUAN_SIZE-1:0] second_dout_35,
	output wire [QUAN_SIZE-1:0] second_dout_36,
	output wire [QUAN_SIZE-1:0] second_dout_37,
	output wire [QUAN_SIZE-1:0] second_dout_38,
	output wire [QUAN_SIZE-1:0] second_dout_39,
	output wire [QUAN_SIZE-1:0] second_dout_40,
	output wire [QUAN_SIZE-1:0] second_dout_41,
	output wire [QUAN_SIZE-1:0] second_dout_42,
	output wire [QUAN_SIZE-1:0] second_dout_43,
	output wire [QUAN_SIZE-1:0] second_dout_44,
	output wire [QUAN_SIZE-1:0] second_dout_45,
	output wire [QUAN_SIZE-1:0] second_dout_46,
	output wire [QUAN_SIZE-1:0] second_dout_47,
	output wire [QUAN_SIZE-1:0] second_dout_48,
	output wire [QUAN_SIZE-1:0] second_dout_49,
	output wire [QUAN_SIZE-1:0] second_dout_50,
	output wire [QUAN_SIZE-1:0] second_dout_51,
	output wire [QUAN_SIZE-1:0] second_dout_52,
	output wire [QUAN_SIZE-1:0] second_dout_53,
	output wire [QUAN_SIZE-1:0] second_dout_54,
	output wire [QUAN_SIZE-1:0] second_dout_55,
	output wire [QUAN_SIZE-1:0] second_dout_56,
	output wire [QUAN_SIZE-1:0] second_dout_57,
	output wire [QUAN_SIZE-1:0] second_dout_58,
	output wire [QUAN_SIZE-1:0] second_dout_59,
	output wire [QUAN_SIZE-1:0] second_dout_60,
	output wire [QUAN_SIZE-1:0] second_dout_61,
	output wire [QUAN_SIZE-1:0] second_dout_62,
	output wire [QUAN_SIZE-1:0] second_dout_63,
	output wire [QUAN_SIZE-1:0] second_dout_64,
	output wire [QUAN_SIZE-1:0] second_dout_65,
	output wire [QUAN_SIZE-1:0] second_dout_66,
	output wire [QUAN_SIZE-1:0] second_dout_67,
	output wire [QUAN_SIZE-1:0] second_dout_68,
	output wire [QUAN_SIZE-1:0] second_dout_69,
	output wire [QUAN_SIZE-1:0] second_dout_70,
	output wire [QUAN_SIZE-1:0] second_dout_71,
	output wire [QUAN_SIZE-1:0] second_dout_72,
	output wire [QUAN_SIZE-1:0] second_dout_73,
	output wire [QUAN_SIZE-1:0] second_dout_74,
	output wire [QUAN_SIZE-1:0] second_dout_75,
	output wire [QUAN_SIZE-1:0] second_dout_76,
	output wire [QUAN_SIZE-1:0] second_dout_77,
	output wire [QUAN_SIZE-1:0] second_dout_78,
	output wire [QUAN_SIZE-1:0] second_dout_79,
	output wire [QUAN_SIZE-1:0] second_dout_80,
	output wire [QUAN_SIZE-1:0] second_dout_81,
	output wire [QUAN_SIZE-1:0] second_dout_82,
	output wire [QUAN_SIZE-1:0] second_dout_83,
	output wire [QUAN_SIZE-1:0] second_dout_84,

	input wire [QUAN_SIZE-1:0] first_din_0,
	input wire [QUAN_SIZE-1:0] first_din_1,
	input wire [QUAN_SIZE-1:0] first_din_2,
	input wire [QUAN_SIZE-1:0] first_din_3,
	input wire [QUAN_SIZE-1:0] first_din_4,
	input wire [QUAN_SIZE-1:0] first_din_5,
	input wire [QUAN_SIZE-1:0] first_din_6,
	input wire [QUAN_SIZE-1:0] first_din_7,
	input wire [QUAN_SIZE-1:0] first_din_8,
	input wire [QUAN_SIZE-1:0] first_din_9,
	input wire [QUAN_SIZE-1:0] first_din_10,
	input wire [QUAN_SIZE-1:0] first_din_11,
	input wire [QUAN_SIZE-1:0] first_din_12,
	input wire [QUAN_SIZE-1:0] first_din_13,
	input wire [QUAN_SIZE-1:0] first_din_14,
	input wire [QUAN_SIZE-1:0] first_din_15,
	input wire [QUAN_SIZE-1:0] first_din_16,
	input wire [QUAN_SIZE-1:0] first_din_17,
	input wire [QUAN_SIZE-1:0] first_din_18,
	input wire [QUAN_SIZE-1:0] first_din_19,
	input wire [QUAN_SIZE-1:0] first_din_20,
	input wire [QUAN_SIZE-1:0] first_din_21,
	input wire [QUAN_SIZE-1:0] first_din_22,
	input wire [QUAN_SIZE-1:0] first_din_23,
	input wire [QUAN_SIZE-1:0] first_din_24,
	input wire [QUAN_SIZE-1:0] first_din_25,
	input wire [QUAN_SIZE-1:0] first_din_26,
	input wire [QUAN_SIZE-1:0] first_din_27,
	input wire [QUAN_SIZE-1:0] first_din_28,
	input wire [QUAN_SIZE-1:0] first_din_29,
	input wire [QUAN_SIZE-1:0] first_din_30,
	input wire [QUAN_SIZE-1:0] first_din_31,
	input wire [QUAN_SIZE-1:0] first_din_32,
	input wire [QUAN_SIZE-1:0] first_din_33,
	input wire [QUAN_SIZE-1:0] first_din_34,
	input wire [QUAN_SIZE-1:0] first_din_35,
	input wire [QUAN_SIZE-1:0] first_din_36,
	input wire [QUAN_SIZE-1:0] first_din_37,
	input wire [QUAN_SIZE-1:0] first_din_38,
	input wire [QUAN_SIZE-1:0] first_din_39,
	input wire [QUAN_SIZE-1:0] first_din_40,
	input wire [QUAN_SIZE-1:0] first_din_41,
	input wire [QUAN_SIZE-1:0] first_din_42,
	input wire [QUAN_SIZE-1:0] first_din_43,
	input wire [QUAN_SIZE-1:0] first_din_44,
	input wire [QUAN_SIZE-1:0] first_din_45,
	input wire [QUAN_SIZE-1:0] first_din_46,
	input wire [QUAN_SIZE-1:0] first_din_47,
	input wire [QUAN_SIZE-1:0] first_din_48,
	input wire [QUAN_SIZE-1:0] first_din_49,
	input wire [QUAN_SIZE-1:0] first_din_50,
	input wire [QUAN_SIZE-1:0] first_din_51,
	input wire [QUAN_SIZE-1:0] first_din_52,
	input wire [QUAN_SIZE-1:0] first_din_53,
	input wire [QUAN_SIZE-1:0] first_din_54,
	input wire [QUAN_SIZE-1:0] first_din_55,
	input wire [QUAN_SIZE-1:0] first_din_56,
	input wire [QUAN_SIZE-1:0] first_din_57,
	input wire [QUAN_SIZE-1:0] first_din_58,
	input wire [QUAN_SIZE-1:0] first_din_59,
	input wire [QUAN_SIZE-1:0] first_din_60,
	input wire [QUAN_SIZE-1:0] first_din_61,
	input wire [QUAN_SIZE-1:0] first_din_62,
	input wire [QUAN_SIZE-1:0] first_din_63,
	input wire [QUAN_SIZE-1:0] first_din_64,
	input wire [QUAN_SIZE-1:0] first_din_65,
	input wire [QUAN_SIZE-1:0] first_din_66,
	input wire [QUAN_SIZE-1:0] first_din_67,
	input wire [QUAN_SIZE-1:0] first_din_68,
	input wire [QUAN_SIZE-1:0] first_din_69,
	input wire [QUAN_SIZE-1:0] first_din_70,
	input wire [QUAN_SIZE-1:0] first_din_71,
	input wire [QUAN_SIZE-1:0] first_din_72,
	input wire [QUAN_SIZE-1:0] first_din_73,
	input wire [QUAN_SIZE-1:0] first_din_74,
	input wire [QUAN_SIZE-1:0] first_din_75,
	input wire [QUAN_SIZE-1:0] first_din_76,
	input wire [QUAN_SIZE-1:0] first_din_77,
	input wire [QUAN_SIZE-1:0] first_din_78,
	input wire [QUAN_SIZE-1:0] first_din_79,
	input wire [QUAN_SIZE-1:0] first_din_80,
	input wire [QUAN_SIZE-1:0] first_din_81,
	input wire [QUAN_SIZE-1:0] first_din_82,
	input wire [QUAN_SIZE-1:0] first_din_83,
	input wire [QUAN_SIZE-1:0] first_din_84,

	input wire [QUAN_SIZE-1:0] second_din_0,
	input wire [QUAN_SIZE-1:0] second_din_1,
	input wire [QUAN_SIZE-1:0] second_din_2,
	input wire [QUAN_SIZE-1:0] second_din_3,
	input wire [QUAN_SIZE-1:0] second_din_4,
	input wire [QUAN_SIZE-1:0] second_din_5,
	input wire [QUAN_SIZE-1:0] second_din_6,
	input wire [QUAN_SIZE-1:0] second_din_7,
	input wire [QUAN_SIZE-1:0] second_din_8,
	input wire [QUAN_SIZE-1:0] second_din_9,
	input wire [QUAN_SIZE-1:0] second_din_10,
	input wire [QUAN_SIZE-1:0] second_din_11,
	input wire [QUAN_SIZE-1:0] second_din_12,
	input wire [QUAN_SIZE-1:0] second_din_13,
	input wire [QUAN_SIZE-1:0] second_din_14,
	input wire [QUAN_SIZE-1:0] second_din_15,
	input wire [QUAN_SIZE-1:0] second_din_16,
	input wire [QUAN_SIZE-1:0] second_din_17,
	input wire [QUAN_SIZE-1:0] second_din_18,
	input wire [QUAN_SIZE-1:0] second_din_19,
	input wire [QUAN_SIZE-1:0] second_din_20,
	input wire [QUAN_SIZE-1:0] second_din_21,
	input wire [QUAN_SIZE-1:0] second_din_22,
	input wire [QUAN_SIZE-1:0] second_din_23,
	input wire [QUAN_SIZE-1:0] second_din_24,
	input wire [QUAN_SIZE-1:0] second_din_25,
	input wire [QUAN_SIZE-1:0] second_din_26,
	input wire [QUAN_SIZE-1:0] second_din_27,
	input wire [QUAN_SIZE-1:0] second_din_28,
	input wire [QUAN_SIZE-1:0] second_din_29,
	input wire [QUAN_SIZE-1:0] second_din_30,
	input wire [QUAN_SIZE-1:0] second_din_31,
	input wire [QUAN_SIZE-1:0] second_din_32,
	input wire [QUAN_SIZE-1:0] second_din_33,
	input wire [QUAN_SIZE-1:0] second_din_34,
	input wire [QUAN_SIZE-1:0] second_din_35,
	input wire [QUAN_SIZE-1:0] second_din_36,
	input wire [QUAN_SIZE-1:0] second_din_37,
	input wire [QUAN_SIZE-1:0] second_din_38,
	input wire [QUAN_SIZE-1:0] second_din_39,
	input wire [QUAN_SIZE-1:0] second_din_40,
	input wire [QUAN_SIZE-1:0] second_din_41,
	input wire [QUAN_SIZE-1:0] second_din_42,
	input wire [QUAN_SIZE-1:0] second_din_43,
	input wire [QUAN_SIZE-1:0] second_din_44,
	input wire [QUAN_SIZE-1:0] second_din_45,
	input wire [QUAN_SIZE-1:0] second_din_46,
	input wire [QUAN_SIZE-1:0] second_din_47,
	input wire [QUAN_SIZE-1:0] second_din_48,
	input wire [QUAN_SIZE-1:0] second_din_49,
	input wire [QUAN_SIZE-1:0] second_din_50,
	input wire [QUAN_SIZE-1:0] second_din_51,
	input wire [QUAN_SIZE-1:0] second_din_52,
	input wire [QUAN_SIZE-1:0] second_din_53,
	input wire [QUAN_SIZE-1:0] second_din_54,
	input wire [QUAN_SIZE-1:0] second_din_55,
	input wire [QUAN_SIZE-1:0] second_din_56,
	input wire [QUAN_SIZE-1:0] second_din_57,
	input wire [QUAN_SIZE-1:0] second_din_58,
	input wire [QUAN_SIZE-1:0] second_din_59,
	input wire [QUAN_SIZE-1:0] second_din_60,
	input wire [QUAN_SIZE-1:0] second_din_61,
	input wire [QUAN_SIZE-1:0] second_din_62,
	input wire [QUAN_SIZE-1:0] second_din_63,
	input wire [QUAN_SIZE-1:0] second_din_64,
	input wire [QUAN_SIZE-1:0] second_din_65,
	input wire [QUAN_SIZE-1:0] second_din_66,
	input wire [QUAN_SIZE-1:0] second_din_67,
	input wire [QUAN_SIZE-1:0] second_din_68,
	input wire [QUAN_SIZE-1:0] second_din_69,
	input wire [QUAN_SIZE-1:0] second_din_70,
	input wire [QUAN_SIZE-1:0] second_din_71,
	input wire [QUAN_SIZE-1:0] second_din_72,
	input wire [QUAN_SIZE-1:0] second_din_73,
	input wire [QUAN_SIZE-1:0] second_din_74,
	input wire [QUAN_SIZE-1:0] second_din_75,
	input wire [QUAN_SIZE-1:0] second_din_76,
	input wire [QUAN_SIZE-1:0] second_din_77,
	input wire [QUAN_SIZE-1:0] second_din_78,
	input wire [QUAN_SIZE-1:0] second_din_79,
	input wire [QUAN_SIZE-1:0] second_din_80,
	input wire [QUAN_SIZE-1:0] second_din_81,
	input wire [QUAN_SIZE-1:0] second_din_82,
	input wire [QUAN_SIZE-1:0] second_din_83,
	input wire [QUAN_SIZE-1:0] second_din_84,

	input wire [ADDR_WIDTH-1:0] sync_addr_0,
	input wire [ADDR_WIDTH-1:0] sync_addr_1,
	input wire [1:0] we, // [0]: check; [1]: variable
	input wire sys_clk
);

wire [QUAN_SIZE-1:0] dout_reg_0 [0:CHECK_PARALLELISM-1];
wire [QUAN_SIZE-1:0] din_reg_0 [0:CHECK_PARALLELISM-1];
wire [QUAN_SIZE-1:0] dout_reg_1 [0:CHECK_PARALLELISM-1];
wire [QUAN_SIZE-1:0] din_reg_1 [0:CHECK_PARALLELISM-1];
genvar i;
generate
	for(i=0;i<MEM_DEVICE_NUM;i=i+1) begin : mem_device_inst
		ram_unit #(
			.DEPTH (DEPTH), //1024
			.DATA_WIDTH (DATA_WIDTH), //36
			.ADDR_WIDTH  (ADDR_WIDTH )  //$clog2(DEPTH)
		) ram_unit_u0(
			.Dout_a ({dout_reg_0[i*RAM_PORTA_RANGE], 
					 dout_reg_0[i*RAM_PORTA_RANGE+1], 
					 dout_reg_0[i*RAM_PORTA_RANGE+2], 
					 dout_reg_0[i*RAM_PORTA_RANGE+3], 
					 dout_reg_0[i*RAM_PORTA_RANGE+4], 
					 dout_reg_0[i*RAM_PORTA_RANGE+5], 
					 dout_reg_0[i*RAM_PORTA_RANGE+6], 
					 dout_reg_0[i*RAM_PORTA_RANGE+7], 
					 dout_reg_0[i*RAM_PORTA_RANGE+8]
					 }
			),
			.Dout_b ({dout_reg_1[i*RAM_PORTA_RANGE], 
					 dout_reg_1[i*RAM_PORTA_RANGE+1], 
					 dout_reg_1[i*RAM_PORTA_RANGE+2], 
					 dout_reg_1[i*RAM_PORTA_RANGE+3], 
					 dout_reg_1[i*RAM_PORTA_RANGE+4], 
					 dout_reg_1[i*RAM_PORTA_RANGE+5], 
					 dout_reg_1[i*RAM_PORTA_RANGE+6], 
					 dout_reg_1[i*RAM_PORTA_RANGE+7], 
					 dout_reg_1[i*RAM_PORTA_RANGE+8]
					 }
			),	

			.Din_a ({din_reg_0[i*RAM_PORTA_RANGE], 
					 din_reg_0[i*RAM_PORTA_RANGE+1], 
					 din_reg_0[i*RAM_PORTA_RANGE+2], 
					 din_reg_0[i*RAM_PORTA_RANGE+3], 
					 din_reg_0[i*RAM_PORTA_RANGE+4], 
					 din_reg_0[i*RAM_PORTA_RANGE+5], 
					 din_reg_0[i*RAM_PORTA_RANGE+6], 
					 din_reg_0[i*RAM_PORTA_RANGE+7], 
					 din_reg_0[i*RAM_PORTA_RANGE+8]
					 }
			),
			.Din_b ({din_reg_1[i*RAM_PORTA_RANGE], 
					 din_reg_1[i*RAM_PORTA_RANGE+1], 
					 din_reg_1[i*RAM_PORTA_RANGE+2], 
					 din_reg_1[i*RAM_PORTA_RANGE+3], 
					 din_reg_1[i*RAM_PORTA_RANGE+4], 
					 din_reg_1[i*RAM_PORTA_RANGE+5], 
					 din_reg_1[i*RAM_PORTA_RANGE+6], 
					 din_reg_1[i*RAM_PORTA_RANGE+7], 
					 din_reg_1[i*RAM_PORTA_RANGE+8]
					 }
			),				

			.AddrIn_a (sync_addr_0[ADDR_WIDTH-1:0]),
			.AddrIn_b (sync_addr_1[ADDR_WIDTH-1:0]),
			.we_a (we[0]),
			.we_b (we[1]),
			.sys_clk (sys_clk)
		);
	end
endgenerate

ram_unit_frag #(
	.DEPTH (DEPTH), //1024
	.DATA_WIDTH (FRAG_DATA_WIDTH), //16
	.ADDR_WIDTH  (ADDR_WIDTH )  //$clog2(DEPTH)
) ram_unit_frag_u0(
	.Dout_a ({dout_reg_0[CHECK_PARALLELISM-4], dout_reg_0[CHECK_PARALLELISM-3], dout_reg_0[CHECK_PARALLELISM-2], dout_reg_0[CHECK_PARALLELISM-1]}),
	.Dout_b ({dout_reg_1[CHECK_PARALLELISM-4], dout_reg_1[CHECK_PARALLELISM-3], dout_reg_1[CHECK_PARALLELISM-2], dout_reg_1[CHECK_PARALLELISM-1]}),

	.Din_a ({din_reg_0[CHECK_PARALLELISM-4], din_reg_0[CHECK_PARALLELISM-3], din_reg_0[CHECK_PARALLELISM-2], din_reg_0[CHECK_PARALLELISM-1]}),
	.Din_b ({din_reg_1[CHECK_PARALLELISM-4], din_reg_1[CHECK_PARALLELISM-3], din_reg_1[CHECK_PARALLELISM-2], din_reg_1[CHECK_PARALLELISM-1]}),

	.AddrIn_a (sync_addr_0[ADDR_WIDTH-1:0]),
	.AddrIn_b (sync_addr_1[ADDR_WIDTH-1:0]),
	.we_a (we[0]),
	.we_b (we[1]),
	.sys_clk (sys_clk)
);

assign first_dout_0[QUAN_SIZE-1:0 ] = dout_reg_0[0 ];
assign first_dout_1[QUAN_SIZE-1:0 ] = dout_reg_0[1 ];
assign first_dout_2[QUAN_SIZE-1:0 ] = dout_reg_0[2 ];
assign first_dout_3[QUAN_SIZE-1:0 ] = dout_reg_0[3 ];
assign first_dout_4[QUAN_SIZE-1:0 ] = dout_reg_0[4 ];
assign first_dout_5[QUAN_SIZE-1:0 ] = dout_reg_0[5 ];
assign first_dout_6[QUAN_SIZE-1:0 ] = dout_reg_0[6 ];
assign first_dout_7[QUAN_SIZE-1:0 ] = dout_reg_0[7 ];
assign first_dout_8[QUAN_SIZE-1:0 ] = dout_reg_0[8 ];
assign first_dout_9[QUAN_SIZE-1:0 ] = dout_reg_0[9 ];
assign first_dout_10[QUAN_SIZE-1:0] = dout_reg_0[10];
assign first_dout_11[QUAN_SIZE-1:0] = dout_reg_0[11];
assign first_dout_12[QUAN_SIZE-1:0] = dout_reg_0[12];
assign first_dout_13[QUAN_SIZE-1:0] = dout_reg_0[13];
assign first_dout_14[QUAN_SIZE-1:0] = dout_reg_0[14];
assign first_dout_15[QUAN_SIZE-1:0] = dout_reg_0[15];
assign first_dout_16[QUAN_SIZE-1:0] = dout_reg_0[16];
assign first_dout_17[QUAN_SIZE-1:0] = dout_reg_0[17];
assign first_dout_18[QUAN_SIZE-1:0] = dout_reg_0[18];
assign first_dout_19[QUAN_SIZE-1:0] = dout_reg_0[19];
assign first_dout_20[QUAN_SIZE-1:0] = dout_reg_0[20];
assign first_dout_21[QUAN_SIZE-1:0] = dout_reg_0[21];
assign first_dout_22[QUAN_SIZE-1:0] = dout_reg_0[22];
assign first_dout_23[QUAN_SIZE-1:0] = dout_reg_0[23];
assign first_dout_24[QUAN_SIZE-1:0] = dout_reg_0[24];
assign first_dout_25[QUAN_SIZE-1:0] = dout_reg_0[25];
assign first_dout_26[QUAN_SIZE-1:0] = dout_reg_0[26];
assign first_dout_27[QUAN_SIZE-1:0] = dout_reg_0[27];
assign first_dout_28[QUAN_SIZE-1:0] = dout_reg_0[28];
assign first_dout_29[QUAN_SIZE-1:0] = dout_reg_0[29];
assign first_dout_30[QUAN_SIZE-1:0] = dout_reg_0[30];
assign first_dout_31[QUAN_SIZE-1:0] = dout_reg_0[31];
assign first_dout_32[QUAN_SIZE-1:0] = dout_reg_0[32];
assign first_dout_33[QUAN_SIZE-1:0] = dout_reg_0[33];
assign first_dout_34[QUAN_SIZE-1:0] = dout_reg_0[34];
assign first_dout_35[QUAN_SIZE-1:0] = dout_reg_0[35];
assign first_dout_36[QUAN_SIZE-1:0] = dout_reg_0[36];
assign first_dout_37[QUAN_SIZE-1:0] = dout_reg_0[37];
assign first_dout_38[QUAN_SIZE-1:0] = dout_reg_0[38];
assign first_dout_39[QUAN_SIZE-1:0] = dout_reg_0[39];
assign first_dout_40[QUAN_SIZE-1:0] = dout_reg_0[40];
assign first_dout_41[QUAN_SIZE-1:0] = dout_reg_0[41];
assign first_dout_42[QUAN_SIZE-1:0] = dout_reg_0[42];
assign first_dout_43[QUAN_SIZE-1:0] = dout_reg_0[43];
assign first_dout_44[QUAN_SIZE-1:0] = dout_reg_0[44];
assign first_dout_45[QUAN_SIZE-1:0] = dout_reg_0[45];
assign first_dout_46[QUAN_SIZE-1:0] = dout_reg_0[46];
assign first_dout_47[QUAN_SIZE-1:0] = dout_reg_0[47];
assign first_dout_48[QUAN_SIZE-1:0] = dout_reg_0[48];
assign first_dout_49[QUAN_SIZE-1:0] = dout_reg_0[49];
assign first_dout_50[QUAN_SIZE-1:0] = dout_reg_0[50];
assign first_dout_51[QUAN_SIZE-1:0] = dout_reg_0[51];
assign first_dout_52[QUAN_SIZE-1:0] = dout_reg_0[52];
assign first_dout_53[QUAN_SIZE-1:0] = dout_reg_0[53];
assign first_dout_54[QUAN_SIZE-1:0] = dout_reg_0[54];
assign first_dout_55[QUAN_SIZE-1:0] = dout_reg_0[55];
assign first_dout_56[QUAN_SIZE-1:0] = dout_reg_0[56];
assign first_dout_57[QUAN_SIZE-1:0] = dout_reg_0[57];
assign first_dout_58[QUAN_SIZE-1:0] = dout_reg_0[58];
assign first_dout_59[QUAN_SIZE-1:0] = dout_reg_0[59];
assign first_dout_60[QUAN_SIZE-1:0] = dout_reg_0[60];
assign first_dout_61[QUAN_SIZE-1:0] = dout_reg_0[61];
assign first_dout_62[QUAN_SIZE-1:0] = dout_reg_0[62];
assign first_dout_63[QUAN_SIZE-1:0] = dout_reg_0[63];
assign first_dout_64[QUAN_SIZE-1:0] = dout_reg_0[64];
assign first_dout_65[QUAN_SIZE-1:0] = dout_reg_0[65];
assign first_dout_66[QUAN_SIZE-1:0] = dout_reg_0[66];
assign first_dout_67[QUAN_SIZE-1:0] = dout_reg_0[67];
assign first_dout_68[QUAN_SIZE-1:0] = dout_reg_0[68];
assign first_dout_69[QUAN_SIZE-1:0] = dout_reg_0[69];
assign first_dout_70[QUAN_SIZE-1:0] = dout_reg_0[70];
assign first_dout_71[QUAN_SIZE-1:0] = dout_reg_0[71];
assign first_dout_72[QUAN_SIZE-1:0] = dout_reg_0[72];
assign first_dout_73[QUAN_SIZE-1:0] = dout_reg_0[73];
assign first_dout_74[QUAN_SIZE-1:0] = dout_reg_0[74];
assign first_dout_75[QUAN_SIZE-1:0] = dout_reg_0[75];
assign first_dout_76[QUAN_SIZE-1:0] = dout_reg_0[76];
assign first_dout_77[QUAN_SIZE-1:0] = dout_reg_0[77];
assign first_dout_78[QUAN_SIZE-1:0] = dout_reg_0[78];
assign first_dout_79[QUAN_SIZE-1:0] = dout_reg_0[79];
assign first_dout_80[QUAN_SIZE-1:0] = dout_reg_0[80];
assign first_dout_81[QUAN_SIZE-1:0] = dout_reg_0[81];
assign first_dout_82[QUAN_SIZE-1:0] = dout_reg_0[82];
assign first_dout_83[QUAN_SIZE-1:0] = dout_reg_0[83];
assign first_dout_84[QUAN_SIZE-1:0] = dout_reg_0[84];

assign second_dout_0[QUAN_SIZE-1:0 ] = dout_reg_1[0 ];
assign second_dout_1[QUAN_SIZE-1:0 ] = dout_reg_1[1 ];
assign second_dout_2[QUAN_SIZE-1:0 ] = dout_reg_1[2 ];
assign second_dout_3[QUAN_SIZE-1:0 ] = dout_reg_1[3 ];
assign second_dout_4[QUAN_SIZE-1:0 ] = dout_reg_1[4 ];
assign second_dout_5[QUAN_SIZE-1:0 ] = dout_reg_1[5 ];
assign second_dout_6[QUAN_SIZE-1:0 ] = dout_reg_1[6 ];
assign second_dout_7[QUAN_SIZE-1:0 ] = dout_reg_1[7 ];
assign second_dout_8[QUAN_SIZE-1:0 ] = dout_reg_1[8 ];
assign second_dout_9[QUAN_SIZE-1:0 ] = dout_reg_1[9 ];
assign second_dout_10[QUAN_SIZE-1:0] = dout_reg_1[10];
assign second_dout_11[QUAN_SIZE-1:0] = dout_reg_1[11];
assign second_dout_12[QUAN_SIZE-1:0] = dout_reg_1[12];
assign second_dout_13[QUAN_SIZE-1:0] = dout_reg_1[13];
assign second_dout_14[QUAN_SIZE-1:0] = dout_reg_1[14];
assign second_dout_15[QUAN_SIZE-1:0] = dout_reg_1[15];
assign second_dout_16[QUAN_SIZE-1:0] = dout_reg_1[16];
assign second_dout_17[QUAN_SIZE-1:0] = dout_reg_1[17];
assign second_dout_18[QUAN_SIZE-1:0] = dout_reg_1[18];
assign second_dout_19[QUAN_SIZE-1:0] = dout_reg_1[19];
assign second_dout_20[QUAN_SIZE-1:0] = dout_reg_1[20];
assign second_dout_21[QUAN_SIZE-1:0] = dout_reg_1[21];
assign second_dout_22[QUAN_SIZE-1:0] = dout_reg_1[22];
assign second_dout_23[QUAN_SIZE-1:0] = dout_reg_1[23];
assign second_dout_24[QUAN_SIZE-1:0] = dout_reg_1[24];
assign second_dout_25[QUAN_SIZE-1:0] = dout_reg_1[25];
assign second_dout_26[QUAN_SIZE-1:0] = dout_reg_1[26];
assign second_dout_27[QUAN_SIZE-1:0] = dout_reg_1[27];
assign second_dout_28[QUAN_SIZE-1:0] = dout_reg_1[28];
assign second_dout_29[QUAN_SIZE-1:0] = dout_reg_1[29];
assign second_dout_30[QUAN_SIZE-1:0] = dout_reg_1[30];
assign second_dout_31[QUAN_SIZE-1:0] = dout_reg_1[31];
assign second_dout_32[QUAN_SIZE-1:0] = dout_reg_1[32];
assign second_dout_33[QUAN_SIZE-1:0] = dout_reg_1[33];
assign second_dout_34[QUAN_SIZE-1:0] = dout_reg_1[34];
assign second_dout_35[QUAN_SIZE-1:0] = dout_reg_1[35];
assign second_dout_36[QUAN_SIZE-1:0] = dout_reg_1[36];
assign second_dout_37[QUAN_SIZE-1:0] = dout_reg_1[37];
assign second_dout_38[QUAN_SIZE-1:0] = dout_reg_1[38];
assign second_dout_39[QUAN_SIZE-1:0] = dout_reg_1[39];
assign second_dout_40[QUAN_SIZE-1:0] = dout_reg_1[40];
assign second_dout_41[QUAN_SIZE-1:0] = dout_reg_1[41];
assign second_dout_42[QUAN_SIZE-1:0] = dout_reg_1[42];
assign second_dout_43[QUAN_SIZE-1:0] = dout_reg_1[43];
assign second_dout_44[QUAN_SIZE-1:0] = dout_reg_1[44];
assign second_dout_45[QUAN_SIZE-1:0] = dout_reg_1[45];
assign second_dout_46[QUAN_SIZE-1:0] = dout_reg_1[46];
assign second_dout_47[QUAN_SIZE-1:0] = dout_reg_1[47];
assign second_dout_48[QUAN_SIZE-1:0] = dout_reg_1[48];
assign second_dout_49[QUAN_SIZE-1:0] = dout_reg_1[49];
assign second_dout_50[QUAN_SIZE-1:0] = dout_reg_1[50];
assign second_dout_51[QUAN_SIZE-1:0] = dout_reg_1[51];
assign second_dout_52[QUAN_SIZE-1:0] = dout_reg_1[52];
assign second_dout_53[QUAN_SIZE-1:0] = dout_reg_1[53];
assign second_dout_54[QUAN_SIZE-1:0] = dout_reg_1[54];
assign second_dout_55[QUAN_SIZE-1:0] = dout_reg_1[55];
assign second_dout_56[QUAN_SIZE-1:0] = dout_reg_1[56];
assign second_dout_57[QUAN_SIZE-1:0] = dout_reg_1[57];
assign second_dout_58[QUAN_SIZE-1:0] = dout_reg_1[58];
assign second_dout_59[QUAN_SIZE-1:0] = dout_reg_1[59];
assign second_dout_60[QUAN_SIZE-1:0] = dout_reg_1[60];
assign second_dout_61[QUAN_SIZE-1:0] = dout_reg_1[61];
assign second_dout_62[QUAN_SIZE-1:0] = dout_reg_1[62];
assign second_dout_63[QUAN_SIZE-1:0] = dout_reg_1[63];
assign second_dout_64[QUAN_SIZE-1:0] = dout_reg_1[64];
assign second_dout_65[QUAN_SIZE-1:0] = dout_reg_1[65];
assign second_dout_66[QUAN_SIZE-1:0] = dout_reg_1[66];
assign second_dout_67[QUAN_SIZE-1:0] = dout_reg_1[67];
assign second_dout_68[QUAN_SIZE-1:0] = dout_reg_1[68];
assign second_dout_69[QUAN_SIZE-1:0] = dout_reg_1[69];
assign second_dout_70[QUAN_SIZE-1:0] = dout_reg_1[70];
assign second_dout_71[QUAN_SIZE-1:0] = dout_reg_1[71];
assign second_dout_72[QUAN_SIZE-1:0] = dout_reg_1[72];
assign second_dout_73[QUAN_SIZE-1:0] = dout_reg_1[73];
assign second_dout_74[QUAN_SIZE-1:0] = dout_reg_1[74];
assign second_dout_75[QUAN_SIZE-1:0] = dout_reg_1[75];
assign second_dout_76[QUAN_SIZE-1:0] = dout_reg_1[76];
assign second_dout_77[QUAN_SIZE-1:0] = dout_reg_1[77];
assign second_dout_78[QUAN_SIZE-1:0] = dout_reg_1[78];
assign second_dout_79[QUAN_SIZE-1:0] = dout_reg_1[79];
assign second_dout_80[QUAN_SIZE-1:0] = dout_reg_1[80];
assign second_dout_81[QUAN_SIZE-1:0] = dout_reg_1[81];
assign second_dout_82[QUAN_SIZE-1:0] = dout_reg_1[82];
assign second_dout_83[QUAN_SIZE-1:0] = dout_reg_1[83];
assign second_dout_84[QUAN_SIZE-1:0] = dout_reg_1[84];

assign din_reg_0[0 ] = first_din_0[QUAN_SIZE-1:0 ];
assign din_reg_0[1 ] = first_din_1[QUAN_SIZE-1:0 ];
assign din_reg_0[2 ] = first_din_2[QUAN_SIZE-1:0 ];
assign din_reg_0[3 ] = first_din_3[QUAN_SIZE-1:0 ];
assign din_reg_0[4 ] = first_din_4[QUAN_SIZE-1:0 ];
assign din_reg_0[5 ] = first_din_5[QUAN_SIZE-1:0 ];
assign din_reg_0[6 ] = first_din_6[QUAN_SIZE-1:0 ];
assign din_reg_0[7 ] = first_din_7[QUAN_SIZE-1:0 ];
assign din_reg_0[8 ] = first_din_8[QUAN_SIZE-1:0 ];
assign din_reg_0[9 ] = first_din_9[QUAN_SIZE-1:0 ];
assign din_reg_0[10] = first_din_10[QUAN_SIZE-1:0];
assign din_reg_0[11] = first_din_11[QUAN_SIZE-1:0];
assign din_reg_0[12] = first_din_12[QUAN_SIZE-1:0];
assign din_reg_0[13] = first_din_13[QUAN_SIZE-1:0];
assign din_reg_0[14] = first_din_14[QUAN_SIZE-1:0];
assign din_reg_0[15] = first_din_15[QUAN_SIZE-1:0];
assign din_reg_0[16] = first_din_16[QUAN_SIZE-1:0];
assign din_reg_0[17] = first_din_17[QUAN_SIZE-1:0];
assign din_reg_0[18] = first_din_18[QUAN_SIZE-1:0];
assign din_reg_0[19] = first_din_19[QUAN_SIZE-1:0];
assign din_reg_0[20] = first_din_20[QUAN_SIZE-1:0];
assign din_reg_0[21] = first_din_21[QUAN_SIZE-1:0];
assign din_reg_0[22] = first_din_22[QUAN_SIZE-1:0];
assign din_reg_0[23] = first_din_23[QUAN_SIZE-1:0];
assign din_reg_0[24] = first_din_24[QUAN_SIZE-1:0];
assign din_reg_0[25] = first_din_25[QUAN_SIZE-1:0];
assign din_reg_0[26] = first_din_26[QUAN_SIZE-1:0];
assign din_reg_0[27] = first_din_27[QUAN_SIZE-1:0];
assign din_reg_0[28] = first_din_28[QUAN_SIZE-1:0];
assign din_reg_0[29] = first_din_29[QUAN_SIZE-1:0];
assign din_reg_0[30] = first_din_30[QUAN_SIZE-1:0];
assign din_reg_0[31] = first_din_31[QUAN_SIZE-1:0];
assign din_reg_0[32] = first_din_32[QUAN_SIZE-1:0];
assign din_reg_0[33] = first_din_33[QUAN_SIZE-1:0];
assign din_reg_0[34] = first_din_34[QUAN_SIZE-1:0];
assign din_reg_0[35] = first_din_35[QUAN_SIZE-1:0];
assign din_reg_0[36] = first_din_36[QUAN_SIZE-1:0];
assign din_reg_0[37] = first_din_37[QUAN_SIZE-1:0];
assign din_reg_0[38] = first_din_38[QUAN_SIZE-1:0];
assign din_reg_0[39] = first_din_39[QUAN_SIZE-1:0];
assign din_reg_0[40] = first_din_40[QUAN_SIZE-1:0];
assign din_reg_0[41] = first_din_41[QUAN_SIZE-1:0];
assign din_reg_0[42] = first_din_42[QUAN_SIZE-1:0];
assign din_reg_0[43] = first_din_43[QUAN_SIZE-1:0];
assign din_reg_0[44] = first_din_44[QUAN_SIZE-1:0];
assign din_reg_0[45] = first_din_45[QUAN_SIZE-1:0];
assign din_reg_0[46] = first_din_46[QUAN_SIZE-1:0];
assign din_reg_0[47] = first_din_47[QUAN_SIZE-1:0];
assign din_reg_0[48] = first_din_48[QUAN_SIZE-1:0];
assign din_reg_0[49] = first_din_49[QUAN_SIZE-1:0];
assign din_reg_0[50] = first_din_50[QUAN_SIZE-1:0];
assign din_reg_0[51] = first_din_51[QUAN_SIZE-1:0];
assign din_reg_0[52] = first_din_52[QUAN_SIZE-1:0];
assign din_reg_0[53] = first_din_53[QUAN_SIZE-1:0];
assign din_reg_0[54] = first_din_54[QUAN_SIZE-1:0];
assign din_reg_0[55] = first_din_55[QUAN_SIZE-1:0];
assign din_reg_0[56] = first_din_56[QUAN_SIZE-1:0];
assign din_reg_0[57] = first_din_57[QUAN_SIZE-1:0];
assign din_reg_0[58] = first_din_58[QUAN_SIZE-1:0];
assign din_reg_0[59] = first_din_59[QUAN_SIZE-1:0];
assign din_reg_0[60] = first_din_60[QUAN_SIZE-1:0];
assign din_reg_0[61] = first_din_61[QUAN_SIZE-1:0];
assign din_reg_0[62] = first_din_62[QUAN_SIZE-1:0];
assign din_reg_0[63] = first_din_63[QUAN_SIZE-1:0];
assign din_reg_0[64] = first_din_64[QUAN_SIZE-1:0];
assign din_reg_0[65] = first_din_65[QUAN_SIZE-1:0];
assign din_reg_0[66] = first_din_66[QUAN_SIZE-1:0];
assign din_reg_0[67] = first_din_67[QUAN_SIZE-1:0];
assign din_reg_0[68] = first_din_68[QUAN_SIZE-1:0];
assign din_reg_0[69] = first_din_69[QUAN_SIZE-1:0];
assign din_reg_0[70] = first_din_70[QUAN_SIZE-1:0];
assign din_reg_0[71] = first_din_71[QUAN_SIZE-1:0];
assign din_reg_0[72] = first_din_72[QUAN_SIZE-1:0];
assign din_reg_0[73] = first_din_73[QUAN_SIZE-1:0];
assign din_reg_0[74] = first_din_74[QUAN_SIZE-1:0];
assign din_reg_0[75] = first_din_75[QUAN_SIZE-1:0];
assign din_reg_0[76] = first_din_76[QUAN_SIZE-1:0];
assign din_reg_0[77] = first_din_77[QUAN_SIZE-1:0];
assign din_reg_0[78] = first_din_78[QUAN_SIZE-1:0];
assign din_reg_0[79] = first_din_79[QUAN_SIZE-1:0];
assign din_reg_0[80] = first_din_80[QUAN_SIZE-1:0];
assign din_reg_0[81] = first_din_81[QUAN_SIZE-1:0];
assign din_reg_0[82] = first_din_82[QUAN_SIZE-1:0];
assign din_reg_0[83] = first_din_83[QUAN_SIZE-1:0];
assign din_reg_0[84] = first_din_84[QUAN_SIZE-1:0];

assign din_reg_1[0 ] = second_din_0[QUAN_SIZE-1:0 ];
assign din_reg_1[1 ] = second_din_1[QUAN_SIZE-1:0 ];
assign din_reg_1[2 ] = second_din_2[QUAN_SIZE-1:0 ];
assign din_reg_1[3 ] = second_din_3[QUAN_SIZE-1:0 ];
assign din_reg_1[4 ] = second_din_4[QUAN_SIZE-1:0 ];
assign din_reg_1[5 ] = second_din_5[QUAN_SIZE-1:0 ];
assign din_reg_1[6 ] = second_din_6[QUAN_SIZE-1:0 ];
assign din_reg_1[7 ] = second_din_7[QUAN_SIZE-1:0 ];
assign din_reg_1[8 ] = second_din_8[QUAN_SIZE-1:0 ];
assign din_reg_1[9 ] = second_din_9[QUAN_SIZE-1:0 ];
assign din_reg_1[10] = second_din_10[QUAN_SIZE-1:0];
assign din_reg_1[11] = second_din_11[QUAN_SIZE-1:0];
assign din_reg_1[12] = second_din_12[QUAN_SIZE-1:0];
assign din_reg_1[13] = second_din_13[QUAN_SIZE-1:0];
assign din_reg_1[14] = second_din_14[QUAN_SIZE-1:0];
assign din_reg_1[15] = second_din_15[QUAN_SIZE-1:0];
assign din_reg_1[16] = second_din_16[QUAN_SIZE-1:0];
assign din_reg_1[17] = second_din_17[QUAN_SIZE-1:0];
assign din_reg_1[18] = second_din_18[QUAN_SIZE-1:0];
assign din_reg_1[19] = second_din_19[QUAN_SIZE-1:0];
assign din_reg_1[20] = second_din_20[QUAN_SIZE-1:0];
assign din_reg_1[21] = second_din_21[QUAN_SIZE-1:0];
assign din_reg_1[22] = second_din_22[QUAN_SIZE-1:0];
assign din_reg_1[23] = second_din_23[QUAN_SIZE-1:0];
assign din_reg_1[24] = second_din_24[QUAN_SIZE-1:0];
assign din_reg_1[25] = second_din_25[QUAN_SIZE-1:0];
assign din_reg_1[26] = second_din_26[QUAN_SIZE-1:0];
assign din_reg_1[27] = second_din_27[QUAN_SIZE-1:0];
assign din_reg_1[28] = second_din_28[QUAN_SIZE-1:0];
assign din_reg_1[29] = second_din_29[QUAN_SIZE-1:0];
assign din_reg_1[30] = second_din_30[QUAN_SIZE-1:0];
assign din_reg_1[31] = second_din_31[QUAN_SIZE-1:0];
assign din_reg_1[32] = second_din_32[QUAN_SIZE-1:0];
assign din_reg_1[33] = second_din_33[QUAN_SIZE-1:0];
assign din_reg_1[34] = second_din_34[QUAN_SIZE-1:0];
assign din_reg_1[35] = second_din_35[QUAN_SIZE-1:0];
assign din_reg_1[36] = second_din_36[QUAN_SIZE-1:0];
assign din_reg_1[37] = second_din_37[QUAN_SIZE-1:0];
assign din_reg_1[38] = second_din_38[QUAN_SIZE-1:0];
assign din_reg_1[39] = second_din_39[QUAN_SIZE-1:0];
assign din_reg_1[40] = second_din_40[QUAN_SIZE-1:0];
assign din_reg_1[41] = second_din_41[QUAN_SIZE-1:0];
assign din_reg_1[42] = second_din_42[QUAN_SIZE-1:0];
assign din_reg_1[43] = second_din_43[QUAN_SIZE-1:0];
assign din_reg_1[44] = second_din_44[QUAN_SIZE-1:0];
assign din_reg_1[45] = second_din_45[QUAN_SIZE-1:0];
assign din_reg_1[46] = second_din_46[QUAN_SIZE-1:0];
assign din_reg_1[47] = second_din_47[QUAN_SIZE-1:0];
assign din_reg_1[48] = second_din_48[QUAN_SIZE-1:0];
assign din_reg_1[49] = second_din_49[QUAN_SIZE-1:0];
assign din_reg_1[50] = second_din_50[QUAN_SIZE-1:0];
assign din_reg_1[51] = second_din_51[QUAN_SIZE-1:0];
assign din_reg_1[52] = second_din_52[QUAN_SIZE-1:0];
assign din_reg_1[53] = second_din_53[QUAN_SIZE-1:0];
assign din_reg_1[54] = second_din_54[QUAN_SIZE-1:0];
assign din_reg_1[55] = second_din_55[QUAN_SIZE-1:0];
assign din_reg_1[56] = second_din_56[QUAN_SIZE-1:0];
assign din_reg_1[57] = second_din_57[QUAN_SIZE-1:0];
assign din_reg_1[58] = second_din_58[QUAN_SIZE-1:0];
assign din_reg_1[59] = second_din_59[QUAN_SIZE-1:0];
assign din_reg_1[60] = second_din_60[QUAN_SIZE-1:0];
assign din_reg_1[61] = second_din_61[QUAN_SIZE-1:0];
assign din_reg_1[62] = second_din_62[QUAN_SIZE-1:0];
assign din_reg_1[63] = second_din_63[QUAN_SIZE-1:0];
assign din_reg_1[64] = second_din_64[QUAN_SIZE-1:0];
assign din_reg_1[65] = second_din_65[QUAN_SIZE-1:0];
assign din_reg_1[66] = second_din_66[QUAN_SIZE-1:0];
assign din_reg_1[67] = second_din_67[QUAN_SIZE-1:0];
assign din_reg_1[68] = second_din_68[QUAN_SIZE-1:0];
assign din_reg_1[69] = second_din_69[QUAN_SIZE-1:0];
assign din_reg_1[70] = second_din_70[QUAN_SIZE-1:0];
assign din_reg_1[71] = second_din_71[QUAN_SIZE-1:0];
assign din_reg_1[72] = second_din_72[QUAN_SIZE-1:0];
assign din_reg_1[73] = second_din_73[QUAN_SIZE-1:0];
assign din_reg_1[74] = second_din_74[QUAN_SIZE-1:0];
assign din_reg_1[75] = second_din_75[QUAN_SIZE-1:0];
assign din_reg_1[76] = second_din_76[QUAN_SIZE-1:0];
assign din_reg_1[77] = second_din_77[QUAN_SIZE-1:0];
assign din_reg_1[78] = second_din_78[QUAN_SIZE-1:0];
assign din_reg_1[79] = second_din_79[QUAN_SIZE-1:0];
assign din_reg_1[80] = second_din_80[QUAN_SIZE-1:0];
assign din_reg_1[81] = second_din_81[QUAN_SIZE-1:0];
assign din_reg_1[82] = second_din_82[QUAN_SIZE-1:0];
assign din_reg_1[83] = second_din_83[QUAN_SIZE-1:0];
assign din_reg_1[84] = second_din_84[QUAN_SIZE-1:0];
endmodule

module ram_unit #(
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter ADDR_WIDTH = $clog2(DEPTH)
) (
`ifdef HDL_INFER
	output reg [DATA_WIDTH-1:0] Dout_a,
	output reg [DATA_WIDTH-1:0] Dout_b,
`else
	output wire [DATA_WIDTH-1:0] Dout_a,
	output wire [DATA_WIDTH-1:0] Dout_b,	
`endif
	input wire [DATA_WIDTH-1:0] Din_a,
	input wire [DATA_WIDTH-1:0] Din_b,
	input wire [ADDR_WIDTH-1:0] AddrIn_a,
	input wire [ADDR_WIDTH-1:0] AddrIn_b,
	input wire we_a,
	input wire we_b,
	input wire sys_clk
);
`ifdef HDL_INFER
// Core Memory
 reg [DATA_WIDTH-1:0] ram_block [0:DEPTH-1];
 genvar i;
 generate
 	for(i=0;i<DEPTH;i=i+1) begin : ram_block_zeroInit_inst
 		initial ram_block[i] <= 0;
 	end
 endgenerate

 // Port-A
always @(posedge sys_clk) begin
	if(we_a == 1'b1)
		ram_block[AddrIn_a] <= Din_a;
end
reg [DATA_WIDTH-1:0] do_a;
always @(posedge sys_clk) begin
	`ifdef RD_WR_CONCURRENT
		do_a <= ram_block[AddrIn_a];
	`else
		if(we_a == 1'b0) do_a <= ram_block[AddrIn_a];
	`endif
end
always @(posedge sys_clk) begin
	Dout_a <= do_a;
end

// Port-B
always @(posedge sys_clk) begin
	if(we_b == 1'b1)
		ram_block[AddrIn_b] <= Din_b;
end
reg [DATA_WIDTH-1:0] do_b;
always @(posedge sys_clk) begin
	`ifdef RD_WR_CONCURRENT
		do_b <= ram_block[AddrIn_b];
	`else
		if(we_b == 1'b0) do_b <= ram_block[AddrIn_b];
	`endif
end
always @(posedge sys_clk) begin
	Dout_b <= do_b;
end
`else
mem_subsys_wrapper ram_unit_u0 (
	.BRAM_PORTA_0_addr (AddrIn_a[ADDR_WIDTH-1:0]),
	.BRAM_PORTA_0_clk (sys_clk),
	.BRAM_PORTA_0_din (Din_a[DATA_WIDTH-1:0]),
	.BRAM_PORTA_0_dout (Dout_a[DATA_WIDTH-1:0]),
	.BRAM_PORTA_0_we (we_a),
	
	.BRAM_PORTB_0_addr (AddrIn_b[ADDR_WIDTH-1:0]),
	.BRAM_PORTB_0_clk (sys_clk),
	.BRAM_PORTB_0_din (Din_b[DATA_WIDTH-1:0]),
	.BRAM_PORTB_0_dout (Dout_b[DATA_WIDTH-1:0]),
	.BRAM_PORTB_0_we (we_b)
);
`endif
endmodule

module ram_unit_frag #(
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 16,
	parameter ADDR_WIDTH = $clog2(DEPTH)
) (
`ifdef HDL_INFER
	output reg [DATA_WIDTH-1:0] Dout_a,
	output reg [DATA_WIDTH-1:0] Dout_b,
`else
	output wire [DATA_WIDTH-1:0] Dout_a,
	output wire [DATA_WIDTH-1:0] Dout_b,	
`endif
	input wire [DATA_WIDTH-1:0] Din_a,
	input wire [DATA_WIDTH-1:0] Din_b,
	input wire [ADDR_WIDTH-1:0] AddrIn_a,
	input wire [ADDR_WIDTH-1:0] AddrIn_b,
	input wire we_a,
	input wire we_b,
	input wire sys_clk
);

`ifdef HDL_INFER
// Core Memory
 reg [DATA_WIDTH-1:0] ram_block [0:DEPTH-1];
 genvar i;
 generate
 	for(i=0;i<DEPTH;i=i+1) begin : ram_block_zeroInit_inst
 		initial ram_block[i] <= 0;
 	end
 endgenerate
 
 // Port-A
always @(posedge sys_clk) begin
	if(we_a == 1'b1)
		ram_block[AddrIn_a] <= Din_a;
end
reg [DATA_WIDTH-1:0] do_a;
always @(posedge sys_clk) begin
	`ifdef RD_WR_CONCURRENT
		do_a <= ram_block[AddrIn_a];
	`else
		if(we_a == 1'b0) do_a <= ram_block[AddrIn_a];
	`endif
end
always @(posedge sys_clk) begin
	Dout_a <= do_a;
end

// Port-B
always @(posedge sys_clk) begin
	if(we_b == 1'b1)
		ram_block[AddrIn_b] <= Din_b;
end
reg [DATA_WIDTH-1:0] do_b;
always @(posedge sys_clk) begin
	`ifdef RD_WR_CONCURRENT
		do_b <= ram_block[AddrIn_b];
	`else
		if(we_b == 1'b0) do_b <= ram_block[AddrIn_b];
	`endif
end
always @(posedge sys_clk) begin
	Dout_b <= do_b;
end
`else
mem_subsys_frag_wrapper ram_unit_frag_u0 (
	.BRAM_PORTA_0_addr (AddrIn_a[ADDR_WIDTH-1:0]),
	.BRAM_PORTA_0_clk (sys_clk),
	.BRAM_PORTA_0_din (Din_a[DATA_WIDTH-1:0]),
	.BRAM_PORTA_0_dout (Dout_a[DATA_WIDTH-1:0]),
	.BRAM_PORTA_0_we (we_a),
	
	.BRAM_PORTB_0_addr (AddrIn_b[ADDR_WIDTH-1:0]),
	.BRAM_PORTB_0_clk (sys_clk),
	.BRAM_PORTB_0_din (Din_b[DATA_WIDTH-1:0]),
	.BRAM_PORTB_0_dout (Dout_b[DATA_WIDTH-1:0]),
	.BRAM_PORTB_0_we (we_b)
);
`endif
endmodule