module vnu3_ib_ram_wrapper #(
	parameter VN_ROM_RD_BW = 8,
	parameter VN_ROM_ADDR_WB = 11,
	parameter DN_ROM_RD_BW = 8,
	parameter DN_ROM_ADDR_WB = 11,
	parameter VN_DEGREE = 3,
	parameter IB_VNU_DECOMP_funNum = 2,
	parameter VN_NUM = 204,
	parameter VNU3_INSTANTIATE_NUM = 51,
	parameter VNU3_INSTANTIATE_UNIT = 4,
	parameter QUAN_SIZE = 4,
	parameter DATAPATH_WIDTH = 4
) (
	output wire read_addr_offset_out,
	output wire hard_decision_0,
	output wire [DATAPATH_WIDTH-1:0] v2c_0_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_0_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_0_out2,
	output wire hard_decision_1,
	output wire [DATAPATH_WIDTH-1:0] v2c_1_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_1_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_1_out2,
	output wire hard_decision_2,
	output wire [DATAPATH_WIDTH-1:0] v2c_2_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_2_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_2_out2,
	output wire hard_decision_3,
	output wire [DATAPATH_WIDTH-1:0] v2c_3_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_3_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_3_out2,
	output wire hard_decision_4,
	output wire [DATAPATH_WIDTH-1:0] v2c_4_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_4_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_4_out2,
	output wire hard_decision_5,
	output wire [DATAPATH_WIDTH-1:0] v2c_5_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_5_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_5_out2,
	output wire hard_decision_6,
	output wire [DATAPATH_WIDTH-1:0] v2c_6_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_6_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_6_out2,
	output wire hard_decision_7,
	output wire [DATAPATH_WIDTH-1:0] v2c_7_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_7_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_7_out2,
	output wire hard_decision_8,
	output wire [DATAPATH_WIDTH-1:0] v2c_8_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_8_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_8_out2,
	output wire hard_decision_9,
	output wire [DATAPATH_WIDTH-1:0] v2c_9_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_9_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_9_out2,
	output wire hard_decision_10,
	output wire [DATAPATH_WIDTH-1:0] v2c_10_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_10_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_10_out2,
	output wire hard_decision_11,
	output wire [DATAPATH_WIDTH-1:0] v2c_11_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_11_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_11_out2,
	output wire hard_decision_12,
	output wire [DATAPATH_WIDTH-1:0] v2c_12_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_12_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_12_out2,
	output wire hard_decision_13,
	output wire [DATAPATH_WIDTH-1:0] v2c_13_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_13_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_13_out2,
	output wire hard_decision_14,
	output wire [DATAPATH_WIDTH-1:0] v2c_14_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_14_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_14_out2,
	output wire hard_decision_15,
	output wire [DATAPATH_WIDTH-1:0] v2c_15_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_15_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_15_out2,
	output wire hard_decision_16,
	output wire [DATAPATH_WIDTH-1:0] v2c_16_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_16_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_16_out2,
	output wire hard_decision_17,
	output wire [DATAPATH_WIDTH-1:0] v2c_17_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_17_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_17_out2,
	output wire hard_decision_18,
	output wire [DATAPATH_WIDTH-1:0] v2c_18_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_18_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_18_out2,
	output wire hard_decision_19,
	output wire [DATAPATH_WIDTH-1:0] v2c_19_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_19_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_19_out2,
	output wire hard_decision_20,
	output wire [DATAPATH_WIDTH-1:0] v2c_20_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_20_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_20_out2,
	output wire hard_decision_21,
	output wire [DATAPATH_WIDTH-1:0] v2c_21_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_21_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_21_out2,
	output wire hard_decision_22,
	output wire [DATAPATH_WIDTH-1:0] v2c_22_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_22_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_22_out2,
	output wire hard_decision_23,
	output wire [DATAPATH_WIDTH-1:0] v2c_23_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_23_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_23_out2,
	output wire hard_decision_24,
	output wire [DATAPATH_WIDTH-1:0] v2c_24_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_24_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_24_out2,
	output wire hard_decision_25,
	output wire [DATAPATH_WIDTH-1:0] v2c_25_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_25_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_25_out2,
	output wire hard_decision_26,
	output wire [DATAPATH_WIDTH-1:0] v2c_26_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_26_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_26_out2,
	output wire hard_decision_27,
	output wire [DATAPATH_WIDTH-1:0] v2c_27_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_27_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_27_out2,
	output wire hard_decision_28,
	output wire [DATAPATH_WIDTH-1:0] v2c_28_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_28_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_28_out2,
	output wire hard_decision_29,
	output wire [DATAPATH_WIDTH-1:0] v2c_29_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_29_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_29_out2,
	output wire hard_decision_30,
	output wire [DATAPATH_WIDTH-1:0] v2c_30_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_30_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_30_out2,
	output wire hard_decision_31,
	output wire [DATAPATH_WIDTH-1:0] v2c_31_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_31_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_31_out2,
	output wire hard_decision_32,
	output wire [DATAPATH_WIDTH-1:0] v2c_32_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_32_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_32_out2,
	output wire hard_decision_33,
	output wire [DATAPATH_WIDTH-1:0] v2c_33_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_33_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_33_out2,
	output wire hard_decision_34,
	output wire [DATAPATH_WIDTH-1:0] v2c_34_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_34_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_34_out2,
	output wire hard_decision_35,
	output wire [DATAPATH_WIDTH-1:0] v2c_35_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_35_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_35_out2,
	output wire hard_decision_36,
	output wire [DATAPATH_WIDTH-1:0] v2c_36_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_36_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_36_out2,
	output wire hard_decision_37,
	output wire [DATAPATH_WIDTH-1:0] v2c_37_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_37_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_37_out2,
	output wire hard_decision_38,
	output wire [DATAPATH_WIDTH-1:0] v2c_38_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_38_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_38_out2,
	output wire hard_decision_39,
	output wire [DATAPATH_WIDTH-1:0] v2c_39_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_39_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_39_out2,
	output wire hard_decision_40,
	output wire [DATAPATH_WIDTH-1:0] v2c_40_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_40_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_40_out2,
	output wire hard_decision_41,
	output wire [DATAPATH_WIDTH-1:0] v2c_41_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_41_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_41_out2,
	output wire hard_decision_42,
	output wire [DATAPATH_WIDTH-1:0] v2c_42_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_42_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_42_out2,
	output wire hard_decision_43,
	output wire [DATAPATH_WIDTH-1:0] v2c_43_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_43_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_43_out2,
	output wire hard_decision_44,
	output wire [DATAPATH_WIDTH-1:0] v2c_44_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_44_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_44_out2,
	output wire hard_decision_45,
	output wire [DATAPATH_WIDTH-1:0] v2c_45_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_45_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_45_out2,
	output wire hard_decision_46,
	output wire [DATAPATH_WIDTH-1:0] v2c_46_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_46_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_46_out2,
	output wire hard_decision_47,
	output wire [DATAPATH_WIDTH-1:0] v2c_47_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_47_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_47_out2,
	output wire hard_decision_48,
	output wire [DATAPATH_WIDTH-1:0] v2c_48_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_48_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_48_out2,
	output wire hard_decision_49,
	output wire [DATAPATH_WIDTH-1:0] v2c_49_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_49_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_49_out2,
	output wire hard_decision_50,
	output wire [DATAPATH_WIDTH-1:0] v2c_50_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_50_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_50_out2,
	output wire hard_decision_51,
	output wire [DATAPATH_WIDTH-1:0] v2c_51_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_51_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_51_out2,
	output wire hard_decision_52,
	output wire [DATAPATH_WIDTH-1:0] v2c_52_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_52_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_52_out2,
	output wire hard_decision_53,
	output wire [DATAPATH_WIDTH-1:0] v2c_53_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_53_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_53_out2,
	output wire hard_decision_54,
	output wire [DATAPATH_WIDTH-1:0] v2c_54_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_54_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_54_out2,
	output wire hard_decision_55,
	output wire [DATAPATH_WIDTH-1:0] v2c_55_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_55_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_55_out2,
	output wire hard_decision_56,
	output wire [DATAPATH_WIDTH-1:0] v2c_56_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_56_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_56_out2,
	output wire hard_decision_57,
	output wire [DATAPATH_WIDTH-1:0] v2c_57_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_57_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_57_out2,
	output wire hard_decision_58,
	output wire [DATAPATH_WIDTH-1:0] v2c_58_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_58_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_58_out2,
	output wire hard_decision_59,
	output wire [DATAPATH_WIDTH-1:0] v2c_59_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_59_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_59_out2,
	output wire hard_decision_60,
	output wire [DATAPATH_WIDTH-1:0] v2c_60_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_60_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_60_out2,
	output wire hard_decision_61,
	output wire [DATAPATH_WIDTH-1:0] v2c_61_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_61_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_61_out2,
	output wire hard_decision_62,
	output wire [DATAPATH_WIDTH-1:0] v2c_62_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_62_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_62_out2,
	output wire hard_decision_63,
	output wire [DATAPATH_WIDTH-1:0] v2c_63_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_63_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_63_out2,
	output wire hard_decision_64,
	output wire [DATAPATH_WIDTH-1:0] v2c_64_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_64_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_64_out2,
	output wire hard_decision_65,
	output wire [DATAPATH_WIDTH-1:0] v2c_65_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_65_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_65_out2,
	output wire hard_decision_66,
	output wire [DATAPATH_WIDTH-1:0] v2c_66_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_66_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_66_out2,
	output wire hard_decision_67,
	output wire [DATAPATH_WIDTH-1:0] v2c_67_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_67_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_67_out2,
	output wire hard_decision_68,
	output wire [DATAPATH_WIDTH-1:0] v2c_68_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_68_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_68_out2,
	output wire hard_decision_69,
	output wire [DATAPATH_WIDTH-1:0] v2c_69_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_69_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_69_out2,
	output wire hard_decision_70,
	output wire [DATAPATH_WIDTH-1:0] v2c_70_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_70_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_70_out2,
	output wire hard_decision_71,
	output wire [DATAPATH_WIDTH-1:0] v2c_71_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_71_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_71_out2,
	output wire hard_decision_72,
	output wire [DATAPATH_WIDTH-1:0] v2c_72_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_72_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_72_out2,
	output wire hard_decision_73,
	output wire [DATAPATH_WIDTH-1:0] v2c_73_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_73_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_73_out2,
	output wire hard_decision_74,
	output wire [DATAPATH_WIDTH-1:0] v2c_74_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_74_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_74_out2,
	output wire hard_decision_75,
	output wire [DATAPATH_WIDTH-1:0] v2c_75_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_75_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_75_out2,
	output wire hard_decision_76,
	output wire [DATAPATH_WIDTH-1:0] v2c_76_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_76_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_76_out2,
	output wire hard_decision_77,
	output wire [DATAPATH_WIDTH-1:0] v2c_77_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_77_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_77_out2,
	output wire hard_decision_78,
	output wire [DATAPATH_WIDTH-1:0] v2c_78_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_78_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_78_out2,
	output wire hard_decision_79,
	output wire [DATAPATH_WIDTH-1:0] v2c_79_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_79_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_79_out2,
	output wire hard_decision_80,
	output wire [DATAPATH_WIDTH-1:0] v2c_80_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_80_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_80_out2,
	output wire hard_decision_81,
	output wire [DATAPATH_WIDTH-1:0] v2c_81_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_81_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_81_out2,
	output wire hard_decision_82,
	output wire [DATAPATH_WIDTH-1:0] v2c_82_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_82_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_82_out2,
	output wire hard_decision_83,
	output wire [DATAPATH_WIDTH-1:0] v2c_83_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_83_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_83_out2,
	output wire hard_decision_84,
	output wire [DATAPATH_WIDTH-1:0] v2c_84_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_84_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_84_out2,
	output wire hard_decision_85,
	output wire [DATAPATH_WIDTH-1:0] v2c_85_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_85_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_85_out2,
	output wire hard_decision_86,
	output wire [DATAPATH_WIDTH-1:0] v2c_86_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_86_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_86_out2,
	output wire hard_decision_87,
	output wire [DATAPATH_WIDTH-1:0] v2c_87_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_87_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_87_out2,
	output wire hard_decision_88,
	output wire [DATAPATH_WIDTH-1:0] v2c_88_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_88_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_88_out2,
	output wire hard_decision_89,
	output wire [DATAPATH_WIDTH-1:0] v2c_89_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_89_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_89_out2,
	output wire hard_decision_90,
	output wire [DATAPATH_WIDTH-1:0] v2c_90_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_90_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_90_out2,
	output wire hard_decision_91,
	output wire [DATAPATH_WIDTH-1:0] v2c_91_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_91_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_91_out2,
	output wire hard_decision_92,
	output wire [DATAPATH_WIDTH-1:0] v2c_92_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_92_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_92_out2,
	output wire hard_decision_93,
	output wire [DATAPATH_WIDTH-1:0] v2c_93_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_93_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_93_out2,
	output wire hard_decision_94,
	output wire [DATAPATH_WIDTH-1:0] v2c_94_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_94_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_94_out2,
	output wire hard_decision_95,
	output wire [DATAPATH_WIDTH-1:0] v2c_95_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_95_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_95_out2,
	output wire hard_decision_96,
	output wire [DATAPATH_WIDTH-1:0] v2c_96_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_96_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_96_out2,
	output wire hard_decision_97,
	output wire [DATAPATH_WIDTH-1:0] v2c_97_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_97_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_97_out2,
	output wire hard_decision_98,
	output wire [DATAPATH_WIDTH-1:0] v2c_98_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_98_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_98_out2,
	output wire hard_decision_99,
	output wire [DATAPATH_WIDTH-1:0] v2c_99_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_99_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_99_out2,
	output wire hard_decision_100,
	output wire [DATAPATH_WIDTH-1:0] v2c_100_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_100_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_100_out2,
	output wire hard_decision_101,
	output wire [DATAPATH_WIDTH-1:0] v2c_101_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_101_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_101_out2,
	output wire hard_decision_102,
	output wire [DATAPATH_WIDTH-1:0] v2c_102_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_102_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_102_out2,
	output wire hard_decision_103,
	output wire [DATAPATH_WIDTH-1:0] v2c_103_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_103_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_103_out2,
	output wire hard_decision_104,
	output wire [DATAPATH_WIDTH-1:0] v2c_104_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_104_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_104_out2,
	output wire hard_decision_105,
	output wire [DATAPATH_WIDTH-1:0] v2c_105_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_105_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_105_out2,
	output wire hard_decision_106,
	output wire [DATAPATH_WIDTH-1:0] v2c_106_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_106_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_106_out2,
	output wire hard_decision_107,
	output wire [DATAPATH_WIDTH-1:0] v2c_107_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_107_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_107_out2,
	output wire hard_decision_108,
	output wire [DATAPATH_WIDTH-1:0] v2c_108_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_108_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_108_out2,
	output wire hard_decision_109,
	output wire [DATAPATH_WIDTH-1:0] v2c_109_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_109_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_109_out2,
	output wire hard_decision_110,
	output wire [DATAPATH_WIDTH-1:0] v2c_110_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_110_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_110_out2,
	output wire hard_decision_111,
	output wire [DATAPATH_WIDTH-1:0] v2c_111_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_111_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_111_out2,
	output wire hard_decision_112,
	output wire [DATAPATH_WIDTH-1:0] v2c_112_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_112_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_112_out2,
	output wire hard_decision_113,
	output wire [DATAPATH_WIDTH-1:0] v2c_113_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_113_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_113_out2,
	output wire hard_decision_114,
	output wire [DATAPATH_WIDTH-1:0] v2c_114_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_114_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_114_out2,
	output wire hard_decision_115,
	output wire [DATAPATH_WIDTH-1:0] v2c_115_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_115_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_115_out2,
	output wire hard_decision_116,
	output wire [DATAPATH_WIDTH-1:0] v2c_116_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_116_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_116_out2,
	output wire hard_decision_117,
	output wire [DATAPATH_WIDTH-1:0] v2c_117_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_117_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_117_out2,
	output wire hard_decision_118,
	output wire [DATAPATH_WIDTH-1:0] v2c_118_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_118_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_118_out2,
	output wire hard_decision_119,
	output wire [DATAPATH_WIDTH-1:0] v2c_119_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_119_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_119_out2,
	output wire hard_decision_120,
	output wire [DATAPATH_WIDTH-1:0] v2c_120_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_120_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_120_out2,
	output wire hard_decision_121,
	output wire [DATAPATH_WIDTH-1:0] v2c_121_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_121_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_121_out2,
	output wire hard_decision_122,
	output wire [DATAPATH_WIDTH-1:0] v2c_122_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_122_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_122_out2,
	output wire hard_decision_123,
	output wire [DATAPATH_WIDTH-1:0] v2c_123_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_123_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_123_out2,
	output wire hard_decision_124,
	output wire [DATAPATH_WIDTH-1:0] v2c_124_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_124_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_124_out2,
	output wire hard_decision_125,
	output wire [DATAPATH_WIDTH-1:0] v2c_125_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_125_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_125_out2,
	output wire hard_decision_126,
	output wire [DATAPATH_WIDTH-1:0] v2c_126_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_126_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_126_out2,
	output wire hard_decision_127,
	output wire [DATAPATH_WIDTH-1:0] v2c_127_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_127_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_127_out2,
	output wire hard_decision_128,
	output wire [DATAPATH_WIDTH-1:0] v2c_128_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_128_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_128_out2,
	output wire hard_decision_129,
	output wire [DATAPATH_WIDTH-1:0] v2c_129_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_129_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_129_out2,
	output wire hard_decision_130,
	output wire [DATAPATH_WIDTH-1:0] v2c_130_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_130_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_130_out2,
	output wire hard_decision_131,
	output wire [DATAPATH_WIDTH-1:0] v2c_131_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_131_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_131_out2,
	output wire hard_decision_132,
	output wire [DATAPATH_WIDTH-1:0] v2c_132_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_132_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_132_out2,
	output wire hard_decision_133,
	output wire [DATAPATH_WIDTH-1:0] v2c_133_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_133_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_133_out2,
	output wire hard_decision_134,
	output wire [DATAPATH_WIDTH-1:0] v2c_134_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_134_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_134_out2,
	output wire hard_decision_135,
	output wire [DATAPATH_WIDTH-1:0] v2c_135_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_135_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_135_out2,
	output wire hard_decision_136,
	output wire [DATAPATH_WIDTH-1:0] v2c_136_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_136_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_136_out2,
	output wire hard_decision_137,
	output wire [DATAPATH_WIDTH-1:0] v2c_137_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_137_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_137_out2,
	output wire hard_decision_138,
	output wire [DATAPATH_WIDTH-1:0] v2c_138_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_138_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_138_out2,
	output wire hard_decision_139,
	output wire [DATAPATH_WIDTH-1:0] v2c_139_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_139_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_139_out2,
	output wire hard_decision_140,
	output wire [DATAPATH_WIDTH-1:0] v2c_140_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_140_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_140_out2,
	output wire hard_decision_141,
	output wire [DATAPATH_WIDTH-1:0] v2c_141_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_141_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_141_out2,
	output wire hard_decision_142,
	output wire [DATAPATH_WIDTH-1:0] v2c_142_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_142_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_142_out2,
	output wire hard_decision_143,
	output wire [DATAPATH_WIDTH-1:0] v2c_143_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_143_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_143_out2,
	output wire hard_decision_144,
	output wire [DATAPATH_WIDTH-1:0] v2c_144_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_144_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_144_out2,
	output wire hard_decision_145,
	output wire [DATAPATH_WIDTH-1:0] v2c_145_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_145_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_145_out2,
	output wire hard_decision_146,
	output wire [DATAPATH_WIDTH-1:0] v2c_146_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_146_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_146_out2,
	output wire hard_decision_147,
	output wire [DATAPATH_WIDTH-1:0] v2c_147_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_147_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_147_out2,
	output wire hard_decision_148,
	output wire [DATAPATH_WIDTH-1:0] v2c_148_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_148_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_148_out2,
	output wire hard_decision_149,
	output wire [DATAPATH_WIDTH-1:0] v2c_149_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_149_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_149_out2,
	output wire hard_decision_150,
	output wire [DATAPATH_WIDTH-1:0] v2c_150_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_150_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_150_out2,
	output wire hard_decision_151,
	output wire [DATAPATH_WIDTH-1:0] v2c_151_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_151_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_151_out2,
	output wire hard_decision_152,
	output wire [DATAPATH_WIDTH-1:0] v2c_152_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_152_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_152_out2,
	output wire hard_decision_153,
	output wire [DATAPATH_WIDTH-1:0] v2c_153_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_153_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_153_out2,
	output wire hard_decision_154,
	output wire [DATAPATH_WIDTH-1:0] v2c_154_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_154_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_154_out2,
	output wire hard_decision_155,
	output wire [DATAPATH_WIDTH-1:0] v2c_155_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_155_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_155_out2,
	output wire hard_decision_156,
	output wire [DATAPATH_WIDTH-1:0] v2c_156_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_156_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_156_out2,
	output wire hard_decision_157,
	output wire [DATAPATH_WIDTH-1:0] v2c_157_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_157_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_157_out2,
	output wire hard_decision_158,
	output wire [DATAPATH_WIDTH-1:0] v2c_158_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_158_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_158_out2,
	output wire hard_decision_159,
	output wire [DATAPATH_WIDTH-1:0] v2c_159_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_159_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_159_out2,
	output wire hard_decision_160,
	output wire [DATAPATH_WIDTH-1:0] v2c_160_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_160_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_160_out2,
	output wire hard_decision_161,
	output wire [DATAPATH_WIDTH-1:0] v2c_161_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_161_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_161_out2,
	output wire hard_decision_162,
	output wire [DATAPATH_WIDTH-1:0] v2c_162_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_162_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_162_out2,
	output wire hard_decision_163,
	output wire [DATAPATH_WIDTH-1:0] v2c_163_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_163_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_163_out2,
	output wire hard_decision_164,
	output wire [DATAPATH_WIDTH-1:0] v2c_164_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_164_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_164_out2,
	output wire hard_decision_165,
	output wire [DATAPATH_WIDTH-1:0] v2c_165_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_165_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_165_out2,
	output wire hard_decision_166,
	output wire [DATAPATH_WIDTH-1:0] v2c_166_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_166_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_166_out2,
	output wire hard_decision_167,
	output wire [DATAPATH_WIDTH-1:0] v2c_167_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_167_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_167_out2,
	output wire hard_decision_168,
	output wire [DATAPATH_WIDTH-1:0] v2c_168_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_168_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_168_out2,
	output wire hard_decision_169,
	output wire [DATAPATH_WIDTH-1:0] v2c_169_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_169_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_169_out2,
	output wire hard_decision_170,
	output wire [DATAPATH_WIDTH-1:0] v2c_170_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_170_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_170_out2,
	output wire hard_decision_171,
	output wire [DATAPATH_WIDTH-1:0] v2c_171_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_171_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_171_out2,
	output wire hard_decision_172,
	output wire [DATAPATH_WIDTH-1:0] v2c_172_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_172_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_172_out2,
	output wire hard_decision_173,
	output wire [DATAPATH_WIDTH-1:0] v2c_173_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_173_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_173_out2,
	output wire hard_decision_174,
	output wire [DATAPATH_WIDTH-1:0] v2c_174_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_174_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_174_out2,
	output wire hard_decision_175,
	output wire [DATAPATH_WIDTH-1:0] v2c_175_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_175_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_175_out2,
	output wire hard_decision_176,
	output wire [DATAPATH_WIDTH-1:0] v2c_176_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_176_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_176_out2,
	output wire hard_decision_177,
	output wire [DATAPATH_WIDTH-1:0] v2c_177_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_177_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_177_out2,
	output wire hard_decision_178,
	output wire [DATAPATH_WIDTH-1:0] v2c_178_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_178_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_178_out2,
	output wire hard_decision_179,
	output wire [DATAPATH_WIDTH-1:0] v2c_179_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_179_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_179_out2,
	output wire hard_decision_180,
	output wire [DATAPATH_WIDTH-1:0] v2c_180_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_180_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_180_out2,
	output wire hard_decision_181,
	output wire [DATAPATH_WIDTH-1:0] v2c_181_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_181_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_181_out2,
	output wire hard_decision_182,
	output wire [DATAPATH_WIDTH-1:0] v2c_182_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_182_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_182_out2,
	output wire hard_decision_183,
	output wire [DATAPATH_WIDTH-1:0] v2c_183_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_183_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_183_out2,
	output wire hard_decision_184,
	output wire [DATAPATH_WIDTH-1:0] v2c_184_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_184_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_184_out2,
	output wire hard_decision_185,
	output wire [DATAPATH_WIDTH-1:0] v2c_185_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_185_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_185_out2,
	output wire hard_decision_186,
	output wire [DATAPATH_WIDTH-1:0] v2c_186_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_186_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_186_out2,
	output wire hard_decision_187,
	output wire [DATAPATH_WIDTH-1:0] v2c_187_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_187_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_187_out2,
	output wire hard_decision_188,
	output wire [DATAPATH_WIDTH-1:0] v2c_188_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_188_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_188_out2,
	output wire hard_decision_189,
	output wire [DATAPATH_WIDTH-1:0] v2c_189_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_189_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_189_out2,
	output wire hard_decision_190,
	output wire [DATAPATH_WIDTH-1:0] v2c_190_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_190_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_190_out2,
	output wire hard_decision_191,
	output wire [DATAPATH_WIDTH-1:0] v2c_191_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_191_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_191_out2,
	output wire hard_decision_192,
	output wire [DATAPATH_WIDTH-1:0] v2c_192_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_192_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_192_out2,
	output wire hard_decision_193,
	output wire [DATAPATH_WIDTH-1:0] v2c_193_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_193_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_193_out2,
	output wire hard_decision_194,
	output wire [DATAPATH_WIDTH-1:0] v2c_194_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_194_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_194_out2,
	output wire hard_decision_195,
	output wire [DATAPATH_WIDTH-1:0] v2c_195_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_195_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_195_out2,
	output wire hard_decision_196,
	output wire [DATAPATH_WIDTH-1:0] v2c_196_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_196_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_196_out2,
	output wire hard_decision_197,
	output wire [DATAPATH_WIDTH-1:0] v2c_197_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_197_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_197_out2,
	output wire hard_decision_198,
	output wire [DATAPATH_WIDTH-1:0] v2c_198_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_198_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_198_out2,
	output wire hard_decision_199,
	output wire [DATAPATH_WIDTH-1:0] v2c_199_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_199_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_199_out2,
	output wire hard_decision_200,
	output wire [DATAPATH_WIDTH-1:0] v2c_200_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_200_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_200_out2,
	output wire hard_decision_201,
	output wire [DATAPATH_WIDTH-1:0] v2c_201_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_201_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_201_out2,
	output wire hard_decision_202,
	output wire [DATAPATH_WIDTH-1:0] v2c_202_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_202_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_202_out2,
	output wire hard_decision_203,
	output wire [DATAPATH_WIDTH-1:0] v2c_203_out0,
	output wire [DATAPATH_WIDTH-1:0] v2c_203_out1,
	output wire [DATAPATH_WIDTH-1:0] v2c_203_out2,

	input wire [DATAPATH_WIDTH-1:0] ch_msg_0,
	input wire [DATAPATH_WIDTH-1:0] c2v_0_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_0_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_0_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_1,
	input wire [DATAPATH_WIDTH-1:0] c2v_1_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_1_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_1_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_2,
	input wire [DATAPATH_WIDTH-1:0] c2v_2_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_2_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_2_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_3,
	input wire [DATAPATH_WIDTH-1:0] c2v_3_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_3_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_3_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_4,
	input wire [DATAPATH_WIDTH-1:0] c2v_4_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_4_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_4_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_5,
	input wire [DATAPATH_WIDTH-1:0] c2v_5_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_5_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_5_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_6,
	input wire [DATAPATH_WIDTH-1:0] c2v_6_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_6_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_6_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_7,
	input wire [DATAPATH_WIDTH-1:0] c2v_7_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_7_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_7_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_8,
	input wire [DATAPATH_WIDTH-1:0] c2v_8_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_8_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_8_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_9,
	input wire [DATAPATH_WIDTH-1:0] c2v_9_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_9_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_9_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_10,
	input wire [DATAPATH_WIDTH-1:0] c2v_10_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_10_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_10_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_11,
	input wire [DATAPATH_WIDTH-1:0] c2v_11_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_11_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_11_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_12,
	input wire [DATAPATH_WIDTH-1:0] c2v_12_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_12_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_12_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_13,
	input wire [DATAPATH_WIDTH-1:0] c2v_13_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_13_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_13_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_14,
	input wire [DATAPATH_WIDTH-1:0] c2v_14_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_14_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_14_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_15,
	input wire [DATAPATH_WIDTH-1:0] c2v_15_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_15_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_15_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_16,
	input wire [DATAPATH_WIDTH-1:0] c2v_16_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_16_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_16_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_17,
	input wire [DATAPATH_WIDTH-1:0] c2v_17_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_17_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_17_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_18,
	input wire [DATAPATH_WIDTH-1:0] c2v_18_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_18_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_18_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_19,
	input wire [DATAPATH_WIDTH-1:0] c2v_19_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_19_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_19_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_20,
	input wire [DATAPATH_WIDTH-1:0] c2v_20_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_20_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_20_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_21,
	input wire [DATAPATH_WIDTH-1:0] c2v_21_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_21_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_21_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_22,
	input wire [DATAPATH_WIDTH-1:0] c2v_22_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_22_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_22_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_23,
	input wire [DATAPATH_WIDTH-1:0] c2v_23_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_23_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_23_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_24,
	input wire [DATAPATH_WIDTH-1:0] c2v_24_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_24_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_24_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_25,
	input wire [DATAPATH_WIDTH-1:0] c2v_25_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_25_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_25_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_26,
	input wire [DATAPATH_WIDTH-1:0] c2v_26_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_26_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_26_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_27,
	input wire [DATAPATH_WIDTH-1:0] c2v_27_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_27_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_27_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_28,
	input wire [DATAPATH_WIDTH-1:0] c2v_28_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_28_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_28_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_29,
	input wire [DATAPATH_WIDTH-1:0] c2v_29_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_29_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_29_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_30,
	input wire [DATAPATH_WIDTH-1:0] c2v_30_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_30_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_30_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_31,
	input wire [DATAPATH_WIDTH-1:0] c2v_31_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_31_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_31_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_32,
	input wire [DATAPATH_WIDTH-1:0] c2v_32_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_32_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_32_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_33,
	input wire [DATAPATH_WIDTH-1:0] c2v_33_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_33_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_33_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_34,
	input wire [DATAPATH_WIDTH-1:0] c2v_34_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_34_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_34_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_35,
	input wire [DATAPATH_WIDTH-1:0] c2v_35_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_35_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_35_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_36,
	input wire [DATAPATH_WIDTH-1:0] c2v_36_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_36_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_36_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_37,
	input wire [DATAPATH_WIDTH-1:0] c2v_37_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_37_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_37_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_38,
	input wire [DATAPATH_WIDTH-1:0] c2v_38_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_38_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_38_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_39,
	input wire [DATAPATH_WIDTH-1:0] c2v_39_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_39_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_39_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_40,
	input wire [DATAPATH_WIDTH-1:0] c2v_40_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_40_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_40_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_41,
	input wire [DATAPATH_WIDTH-1:0] c2v_41_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_41_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_41_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_42,
	input wire [DATAPATH_WIDTH-1:0] c2v_42_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_42_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_42_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_43,
	input wire [DATAPATH_WIDTH-1:0] c2v_43_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_43_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_43_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_44,
	input wire [DATAPATH_WIDTH-1:0] c2v_44_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_44_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_44_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_45,
	input wire [DATAPATH_WIDTH-1:0] c2v_45_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_45_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_45_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_46,
	input wire [DATAPATH_WIDTH-1:0] c2v_46_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_46_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_46_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_47,
	input wire [DATAPATH_WIDTH-1:0] c2v_47_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_47_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_47_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_48,
	input wire [DATAPATH_WIDTH-1:0] c2v_48_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_48_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_48_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_49,
	input wire [DATAPATH_WIDTH-1:0] c2v_49_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_49_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_49_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_50,
	input wire [DATAPATH_WIDTH-1:0] c2v_50_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_50_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_50_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_51,
	input wire [DATAPATH_WIDTH-1:0] c2v_51_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_51_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_51_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_52,
	input wire [DATAPATH_WIDTH-1:0] c2v_52_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_52_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_52_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_53,
	input wire [DATAPATH_WIDTH-1:0] c2v_53_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_53_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_53_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_54,
	input wire [DATAPATH_WIDTH-1:0] c2v_54_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_54_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_54_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_55,
	input wire [DATAPATH_WIDTH-1:0] c2v_55_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_55_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_55_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_56,
	input wire [DATAPATH_WIDTH-1:0] c2v_56_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_56_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_56_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_57,
	input wire [DATAPATH_WIDTH-1:0] c2v_57_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_57_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_57_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_58,
	input wire [DATAPATH_WIDTH-1:0] c2v_58_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_58_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_58_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_59,
	input wire [DATAPATH_WIDTH-1:0] c2v_59_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_59_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_59_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_60,
	input wire [DATAPATH_WIDTH-1:0] c2v_60_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_60_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_60_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_61,
	input wire [DATAPATH_WIDTH-1:0] c2v_61_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_61_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_61_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_62,
	input wire [DATAPATH_WIDTH-1:0] c2v_62_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_62_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_62_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_63,
	input wire [DATAPATH_WIDTH-1:0] c2v_63_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_63_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_63_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_64,
	input wire [DATAPATH_WIDTH-1:0] c2v_64_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_64_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_64_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_65,
	input wire [DATAPATH_WIDTH-1:0] c2v_65_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_65_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_65_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_66,
	input wire [DATAPATH_WIDTH-1:0] c2v_66_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_66_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_66_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_67,
	input wire [DATAPATH_WIDTH-1:0] c2v_67_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_67_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_67_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_68,
	input wire [DATAPATH_WIDTH-1:0] c2v_68_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_68_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_68_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_69,
	input wire [DATAPATH_WIDTH-1:0] c2v_69_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_69_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_69_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_70,
	input wire [DATAPATH_WIDTH-1:0] c2v_70_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_70_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_70_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_71,
	input wire [DATAPATH_WIDTH-1:0] c2v_71_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_71_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_71_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_72,
	input wire [DATAPATH_WIDTH-1:0] c2v_72_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_72_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_72_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_73,
	input wire [DATAPATH_WIDTH-1:0] c2v_73_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_73_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_73_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_74,
	input wire [DATAPATH_WIDTH-1:0] c2v_74_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_74_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_74_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_75,
	input wire [DATAPATH_WIDTH-1:0] c2v_75_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_75_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_75_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_76,
	input wire [DATAPATH_WIDTH-1:0] c2v_76_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_76_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_76_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_77,
	input wire [DATAPATH_WIDTH-1:0] c2v_77_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_77_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_77_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_78,
	input wire [DATAPATH_WIDTH-1:0] c2v_78_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_78_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_78_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_79,
	input wire [DATAPATH_WIDTH-1:0] c2v_79_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_79_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_79_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_80,
	input wire [DATAPATH_WIDTH-1:0] c2v_80_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_80_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_80_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_81,
	input wire [DATAPATH_WIDTH-1:0] c2v_81_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_81_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_81_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_82,
	input wire [DATAPATH_WIDTH-1:0] c2v_82_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_82_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_82_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_83,
	input wire [DATAPATH_WIDTH-1:0] c2v_83_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_83_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_83_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_84,
	input wire [DATAPATH_WIDTH-1:0] c2v_84_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_84_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_84_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_85,
	input wire [DATAPATH_WIDTH-1:0] c2v_85_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_85_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_85_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_86,
	input wire [DATAPATH_WIDTH-1:0] c2v_86_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_86_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_86_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_87,
	input wire [DATAPATH_WIDTH-1:0] c2v_87_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_87_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_87_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_88,
	input wire [DATAPATH_WIDTH-1:0] c2v_88_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_88_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_88_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_89,
	input wire [DATAPATH_WIDTH-1:0] c2v_89_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_89_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_89_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_90,
	input wire [DATAPATH_WIDTH-1:0] c2v_90_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_90_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_90_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_91,
	input wire [DATAPATH_WIDTH-1:0] c2v_91_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_91_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_91_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_92,
	input wire [DATAPATH_WIDTH-1:0] c2v_92_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_92_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_92_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_93,
	input wire [DATAPATH_WIDTH-1:0] c2v_93_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_93_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_93_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_94,
	input wire [DATAPATH_WIDTH-1:0] c2v_94_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_94_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_94_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_95,
	input wire [DATAPATH_WIDTH-1:0] c2v_95_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_95_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_95_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_96,
	input wire [DATAPATH_WIDTH-1:0] c2v_96_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_96_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_96_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_97,
	input wire [DATAPATH_WIDTH-1:0] c2v_97_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_97_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_97_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_98,
	input wire [DATAPATH_WIDTH-1:0] c2v_98_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_98_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_98_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_99,
	input wire [DATAPATH_WIDTH-1:0] c2v_99_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_99_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_99_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_100,
	input wire [DATAPATH_WIDTH-1:0] c2v_100_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_100_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_100_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_101,
	input wire [DATAPATH_WIDTH-1:0] c2v_101_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_101_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_101_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_102,
	input wire [DATAPATH_WIDTH-1:0] c2v_102_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_102_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_102_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_103,
	input wire [DATAPATH_WIDTH-1:0] c2v_103_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_103_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_103_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_104,
	input wire [DATAPATH_WIDTH-1:0] c2v_104_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_104_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_104_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_105,
	input wire [DATAPATH_WIDTH-1:0] c2v_105_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_105_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_105_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_106,
	input wire [DATAPATH_WIDTH-1:0] c2v_106_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_106_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_106_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_107,
	input wire [DATAPATH_WIDTH-1:0] c2v_107_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_107_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_107_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_108,
	input wire [DATAPATH_WIDTH-1:0] c2v_108_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_108_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_108_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_109,
	input wire [DATAPATH_WIDTH-1:0] c2v_109_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_109_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_109_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_110,
	input wire [DATAPATH_WIDTH-1:0] c2v_110_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_110_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_110_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_111,
	input wire [DATAPATH_WIDTH-1:0] c2v_111_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_111_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_111_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_112,
	input wire [DATAPATH_WIDTH-1:0] c2v_112_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_112_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_112_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_113,
	input wire [DATAPATH_WIDTH-1:0] c2v_113_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_113_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_113_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_114,
	input wire [DATAPATH_WIDTH-1:0] c2v_114_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_114_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_114_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_115,
	input wire [DATAPATH_WIDTH-1:0] c2v_115_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_115_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_115_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_116,
	input wire [DATAPATH_WIDTH-1:0] c2v_116_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_116_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_116_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_117,
	input wire [DATAPATH_WIDTH-1:0] c2v_117_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_117_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_117_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_118,
	input wire [DATAPATH_WIDTH-1:0] c2v_118_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_118_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_118_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_119,
	input wire [DATAPATH_WIDTH-1:0] c2v_119_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_119_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_119_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_120,
	input wire [DATAPATH_WIDTH-1:0] c2v_120_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_120_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_120_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_121,
	input wire [DATAPATH_WIDTH-1:0] c2v_121_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_121_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_121_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_122,
	input wire [DATAPATH_WIDTH-1:0] c2v_122_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_122_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_122_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_123,
	input wire [DATAPATH_WIDTH-1:0] c2v_123_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_123_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_123_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_124,
	input wire [DATAPATH_WIDTH-1:0] c2v_124_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_124_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_124_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_125,
	input wire [DATAPATH_WIDTH-1:0] c2v_125_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_125_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_125_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_126,
	input wire [DATAPATH_WIDTH-1:0] c2v_126_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_126_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_126_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_127,
	input wire [DATAPATH_WIDTH-1:0] c2v_127_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_127_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_127_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_128,
	input wire [DATAPATH_WIDTH-1:0] c2v_128_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_128_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_128_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_129,
	input wire [DATAPATH_WIDTH-1:0] c2v_129_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_129_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_129_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_130,
	input wire [DATAPATH_WIDTH-1:0] c2v_130_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_130_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_130_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_131,
	input wire [DATAPATH_WIDTH-1:0] c2v_131_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_131_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_131_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_132,
	input wire [DATAPATH_WIDTH-1:0] c2v_132_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_132_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_132_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_133,
	input wire [DATAPATH_WIDTH-1:0] c2v_133_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_133_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_133_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_134,
	input wire [DATAPATH_WIDTH-1:0] c2v_134_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_134_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_134_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_135,
	input wire [DATAPATH_WIDTH-1:0] c2v_135_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_135_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_135_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_136,
	input wire [DATAPATH_WIDTH-1:0] c2v_136_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_136_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_136_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_137,
	input wire [DATAPATH_WIDTH-1:0] c2v_137_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_137_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_137_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_138,
	input wire [DATAPATH_WIDTH-1:0] c2v_138_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_138_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_138_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_139,
	input wire [DATAPATH_WIDTH-1:0] c2v_139_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_139_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_139_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_140,
	input wire [DATAPATH_WIDTH-1:0] c2v_140_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_140_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_140_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_141,
	input wire [DATAPATH_WIDTH-1:0] c2v_141_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_141_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_141_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_142,
	input wire [DATAPATH_WIDTH-1:0] c2v_142_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_142_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_142_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_143,
	input wire [DATAPATH_WIDTH-1:0] c2v_143_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_143_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_143_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_144,
	input wire [DATAPATH_WIDTH-1:0] c2v_144_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_144_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_144_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_145,
	input wire [DATAPATH_WIDTH-1:0] c2v_145_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_145_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_145_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_146,
	input wire [DATAPATH_WIDTH-1:0] c2v_146_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_146_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_146_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_147,
	input wire [DATAPATH_WIDTH-1:0] c2v_147_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_147_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_147_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_148,
	input wire [DATAPATH_WIDTH-1:0] c2v_148_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_148_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_148_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_149,
	input wire [DATAPATH_WIDTH-1:0] c2v_149_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_149_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_149_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_150,
	input wire [DATAPATH_WIDTH-1:0] c2v_150_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_150_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_150_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_151,
	input wire [DATAPATH_WIDTH-1:0] c2v_151_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_151_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_151_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_152,
	input wire [DATAPATH_WIDTH-1:0] c2v_152_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_152_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_152_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_153,
	input wire [DATAPATH_WIDTH-1:0] c2v_153_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_153_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_153_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_154,
	input wire [DATAPATH_WIDTH-1:0] c2v_154_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_154_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_154_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_155,
	input wire [DATAPATH_WIDTH-1:0] c2v_155_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_155_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_155_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_156,
	input wire [DATAPATH_WIDTH-1:0] c2v_156_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_156_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_156_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_157,
	input wire [DATAPATH_WIDTH-1:0] c2v_157_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_157_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_157_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_158,
	input wire [DATAPATH_WIDTH-1:0] c2v_158_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_158_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_158_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_159,
	input wire [DATAPATH_WIDTH-1:0] c2v_159_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_159_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_159_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_160,
	input wire [DATAPATH_WIDTH-1:0] c2v_160_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_160_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_160_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_161,
	input wire [DATAPATH_WIDTH-1:0] c2v_161_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_161_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_161_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_162,
	input wire [DATAPATH_WIDTH-1:0] c2v_162_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_162_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_162_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_163,
	input wire [DATAPATH_WIDTH-1:0] c2v_163_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_163_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_163_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_164,
	input wire [DATAPATH_WIDTH-1:0] c2v_164_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_164_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_164_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_165,
	input wire [DATAPATH_WIDTH-1:0] c2v_165_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_165_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_165_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_166,
	input wire [DATAPATH_WIDTH-1:0] c2v_166_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_166_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_166_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_167,
	input wire [DATAPATH_WIDTH-1:0] c2v_167_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_167_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_167_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_168,
	input wire [DATAPATH_WIDTH-1:0] c2v_168_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_168_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_168_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_169,
	input wire [DATAPATH_WIDTH-1:0] c2v_169_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_169_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_169_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_170,
	input wire [DATAPATH_WIDTH-1:0] c2v_170_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_170_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_170_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_171,
	input wire [DATAPATH_WIDTH-1:0] c2v_171_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_171_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_171_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_172,
	input wire [DATAPATH_WIDTH-1:0] c2v_172_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_172_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_172_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_173,
	input wire [DATAPATH_WIDTH-1:0] c2v_173_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_173_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_173_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_174,
	input wire [DATAPATH_WIDTH-1:0] c2v_174_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_174_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_174_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_175,
	input wire [DATAPATH_WIDTH-1:0] c2v_175_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_175_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_175_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_176,
	input wire [DATAPATH_WIDTH-1:0] c2v_176_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_176_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_176_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_177,
	input wire [DATAPATH_WIDTH-1:0] c2v_177_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_177_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_177_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_178,
	input wire [DATAPATH_WIDTH-1:0] c2v_178_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_178_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_178_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_179,
	input wire [DATAPATH_WIDTH-1:0] c2v_179_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_179_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_179_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_180,
	input wire [DATAPATH_WIDTH-1:0] c2v_180_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_180_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_180_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_181,
	input wire [DATAPATH_WIDTH-1:0] c2v_181_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_181_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_181_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_182,
	input wire [DATAPATH_WIDTH-1:0] c2v_182_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_182_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_182_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_183,
	input wire [DATAPATH_WIDTH-1:0] c2v_183_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_183_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_183_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_184,
	input wire [DATAPATH_WIDTH-1:0] c2v_184_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_184_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_184_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_185,
	input wire [DATAPATH_WIDTH-1:0] c2v_185_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_185_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_185_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_186,
	input wire [DATAPATH_WIDTH-1:0] c2v_186_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_186_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_186_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_187,
	input wire [DATAPATH_WIDTH-1:0] c2v_187_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_187_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_187_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_188,
	input wire [DATAPATH_WIDTH-1:0] c2v_188_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_188_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_188_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_189,
	input wire [DATAPATH_WIDTH-1:0] c2v_189_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_189_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_189_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_190,
	input wire [DATAPATH_WIDTH-1:0] c2v_190_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_190_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_190_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_191,
	input wire [DATAPATH_WIDTH-1:0] c2v_191_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_191_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_191_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_192,
	input wire [DATAPATH_WIDTH-1:0] c2v_192_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_192_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_192_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_193,
	input wire [DATAPATH_WIDTH-1:0] c2v_193_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_193_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_193_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_194,
	input wire [DATAPATH_WIDTH-1:0] c2v_194_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_194_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_194_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_195,
	input wire [DATAPATH_WIDTH-1:0] c2v_195_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_195_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_195_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_196,
	input wire [DATAPATH_WIDTH-1:0] c2v_196_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_196_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_196_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_197,
	input wire [DATAPATH_WIDTH-1:0] c2v_197_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_197_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_197_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_198,
	input wire [DATAPATH_WIDTH-1:0] c2v_198_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_198_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_198_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_199,
	input wire [DATAPATH_WIDTH-1:0] c2v_199_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_199_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_199_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_200,
	input wire [DATAPATH_WIDTH-1:0] c2v_200_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_200_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_200_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_201,
	input wire [DATAPATH_WIDTH-1:0] c2v_201_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_201_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_201_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_202,
	input wire [DATAPATH_WIDTH-1:0] c2v_202_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_202_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_202_in2,
	input wire [DATAPATH_WIDTH-1:0] ch_msg_203,
	input wire [DATAPATH_WIDTH-1:0] c2v_203_in0,
	input wire [DATAPATH_WIDTH-1:0] c2v_203_in1,
	input wire [DATAPATH_WIDTH-1:0] c2v_203_in2,

	input wire read_clk,
	input wire read_addr_offset,
	input wire v2c_src,

	// Iteration-Refresh Page Address
	input wire [VN_ROM_ADDR_BW-1:0] page_addr_ram_0,
	input wire [VN_ROM_ADDR_BW-1:0] page_addr_ram_1,
	input wire [VN_ROM_ADDR_BW-1:0] page_addr_ram_2, // the last one is for decision node
	//Iteration-Refresh Page Data
	input wire [VN_ROM_RD_BW-1:0] ram_write_dataA_0, // from portA of IB-ROM
	input wire [VN_ROM_RD_BW-1:0] ram_write_dataB_0, // from portB of IB-ROM
	input wire [VN_ROM_RD_BW-1:0] ram_write_dataA_1, // from portA of IB-ROM
	input wire [VN_ROM_RD_BW-1:0] ram_write_dataB_1, // from portB of IB-ROM
	input wire [VN_ROM_RD_BW-1:0] ram_write_dataA_2, // from portA of IB-ROM (for decision node)
	input wire [VN_ROM_RD_BW-1:0] ram_write_dataB_2, // from portB of IB-ROM (for decision node)

	input wire ib_ram_we_0,
	input wire ib_ram_we_1,
	input wire ib_ram_we_2,
	input wire vn_write_clk
	input wire dn_write_clk
);
// Input sources of vaiable node units
wire [QUAN_SIZE-1:0] c2v_0 [0:VN_NUM-1];
wire [QUAN_SIZE-1:0] c2v_1 [0:VN_NUM-1];
wire [QUAN_SIZE-1:0] c2v_2 [0:VN_NUM-1];
wire [QUAN_SIZE-1:0] ch_msg [0:VN_NUM-1];
// Output sources of check node units
wire [QUAN_SIZE-1:0] v2c_0 [0:VN_NUM-1];
wire [QUAN_SIZE-1:0] v2c_1 [0:VN_NUM-1];
wire [QUAN_SIZE-1:0] v2c_2 [0:VN_NUM-1];
wire [VN_NUM-1:0] hard_decision;
// Address related signals including the Net type
wire [VN_DEGREE+1-2-1-1:0] read_addr_offset_internal;

generate
	genvar j;
	// Group A interacting with Port A of IB-ROMs
	integer inst_num_groupA = VNU3_INSTANTIATE_NUM / 2;
	for (j=0; j<inst_num_groupA; j=j+1) begin : vnu3_204_102_inst_GroupA
		// Instantiation of F_0
		// Instantiation of F_0
		wire [QUAN_SIZE-1:0] f0_out[0:7];
		wire [QUAN_SIZE-1:0] vnu0_c2v [0:1]; // c2v[1] and c2v[2]
		wire [QUAN_SIZE-1:0] vnu1_c2v [0:1]; // c2v[1] and c2v[2]
		wire [QUAN_SIZE-1:0] vnu2_c2v [0:1]; // c2v[1] and c2v[2]
		wire [QUAN_SIZE-1:0] vnu3_c2v [0:1]; // c2v[1] and c2v[2]	
		wire [1:0] vnu0_tranEn_out;
		wire [1:0] vnu1_tranEn_out;
		wire [1:0] vnu2_tranEn_out;
		wire [1:0] vnu3_tranEn_out;
	
		vnu3_f0 u_f0(
			.read_addr_offset_out (read_addr_offset_internal[0]), // to forward the current multi-frame offset signal to the next sub-datapath	
			// For the first VNU
			.vnu0_tPort0 (f0_out[0]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_tPort1 (f0_out[1]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_c2v1   (vnu0_c2v[0]),
			.vnu0_c2v2   (vnu0_c2v[1]),
			// For the second VNU       
			.vnu1_tPort0 (f0_out[2]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_tPort1 (f0_out[3]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_c2v1   (vnu1_c2v[0]),
			.vnu1_c2v2   (vnu1_c2v[1]),
			// For the third VNU        
			.vnu2_tPort0 (f0_out[4]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_tPort1 (f0_out[5]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_c2v1   (vnu2_c2v[0]),
			.vnu2_c2v2   (vnu2_c2v[1]),
			// For the fourth VNU       
			.vnu3_tPort0 (f0_out[6]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_tPort1 (f0_out[7]  ), // internal signals accounting for each 128-entry partial LUT's output	
			.vnu3_c2v1   (vnu3_c2v[0]),
			.vnu3_c2v2   (vnu3_c2v[1]),
			// For first to fourth VNUs (output port)
			.vnu0_tranEn_out0 (vnu0_tranEn_out[0]),
			.vnu0_tranEn_out1 (vnu0_tranEn_out[1]),
			.vnu1_tranEn_out0 (vnu1_tranEn_out[0]),
			.vnu1_tranEn_out1 (vnu1_tranEn_out[1]),
			.vnu2_tranEn_out0 (vnu2_tranEn_out[0]),
			.vnu2_tranEn_out1 (vnu2_tranEn_out[1]),
			.vnu3_tranEn_out0 (vnu3_tranEn_out[0]),
			.vnu3_tranEn_out1 (vnu3_tranEn_out[1]),
		
			// From the first VNU
			.vnu0_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_ch_llr (ch_msg[VNU3_INSTANTIATE_UNIT*j]),
	
			// From the second VNU
			.vnu1_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+1]),
	
			// From the third VNU
			.vnu2_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+2]),
	
			// From the fourth VNU
			.vnu3_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+3]),
		
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset), // offset determing the switch between multi-frame
		
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_0[VN_ROM_ADDR_BW-1:0]),
			// Ieration-Update Data
			.ram_write_data_0 (ram_write_dataA_0[VN_ROM_RD_BW-1:0]),
		
			.write_clk (vn_write_clk),
			.ib_ram_we (ib_ram_we[0])
		);

		// Instantiation of F_1
		wire [QUAN_SIZE-1:0] vnu0_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu1_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu2_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu3_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu0_E_reg2, vnu1_E_reg2, vnu2_E_reg2, vnu3_E_reg2;
		wire [1:0] vnu0_tranEn_out_f1;
		wire [1:0] vnu1_tranEn_out_f1;
		wire [1:0] vnu2_tranEn_out_f1;
		wire [1:0] vnu3_tranEn_out_f1;
		vnu3_f1 u_f1(
			.read_addr_offset_out (read_addr_offset_outSet[j]), // to forward the current multi-frame offset signal to the next sub-datapath	
			// For the first VNU
			.vnu0_v2c0 (vnu0_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_v2c1 (vnu0_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_v2c2 (vnu0_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_E_reg2 (vnu0_E_reg2[QUAN_SIZE-1:0]),
			.vnu0_tranEn_out0 (vnu0_tranEn_out_f1),
			// For the second VNU       
			.vnu1_v2c0 (vnu1_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_v2c1 (vnu1_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_v2c2 (vnu1_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_E_reg2 (vnu1_E_reg2[QUAN_SIZE-1:0]),
			.vnu1_tranEn_out0 (vnu1_tranEn_out_f1),
			// For the third VNU        
			.vnu2_v2c0 (vnu2_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_v2c1 (vnu2_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_v2c2 (vnu2_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_E_reg2 (vnu2_E_reg2[QUAN_SIZE-1:0]),
			.vnu2_tranEn_out0 (vnu2_tranEn_out_f1),
			// For the fourth VNU       
			.vnu3_v2c0 (vnu3_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_v2c1 (vnu3_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_v2c2 (vnu3_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_E_reg2 (vnu3_E_reg2[QUAN_SIZE-1:0]),	
			.vnu3_tranEn_out0 (vnu3_tranEn_out_f1),
			
			// From the first VNU
			.vnu0_t00   (f0_out[0]  ),
			.vnu0_t01   (f0_out[1]  ),
			.vnu0_c2v_1 (vnu0_c2v[0]),
			.vnu0_c2v_2 (vnu0_c2v[1]),
			.vnu0_tranEn_in0 (vnu0_tranEn_out[0]),
			.vnu0_tranEn_in1 (vnu0_tranEn_out[1]),
	
			// From the second VNU
			.vnu1_t00   (f0_out[2]  ),
			.vnu1_t01   (f0_out[3]  ),
			.vnu1_c2v_1 (vnu1_c2v[0]),
			.vnu1_c2v_2 (vnu1_c2v[1]), 
			.vnu1_tranEn_in0 (vnu1_tranEn_out[0]),
			.vnu1_tranEn_in1 (vnu1_tranEn_out[1]),	
	
			// From the third VNU
			.vnu2_t00   (f0_out[4]  ),
			.vnu2_t01   (f0_out[5]  ),
			.vnu2_c2v_1 (vnu2_c2v[0]),
			.vnu2_c2v_2 (vnu2_c2v[1]),
			.vnu2_tranEn_in0 (vnu2_tranEn_out[0]),
			.vnu2_tranEn_in1 (vnu2_tranEn_out[1]),
	
			// From the fourth VNU
			.vnu3_t00   (f0_out[6]  ),
			.vnu3_t01   (f0_out[7]  ),
			.vnu3_c2v_1 (vnu3_c2v[0]),
			.vnu3_c2v_2 (vnu3_c2v[1]),
			.vnu3_tranEn_in0 (vnu3_tranEn_out[0]),
			.vnu3_tranEn_in1 (vnu3_tranEn_out[1]),
		
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset_internal[0]), // offset determing the switch between multi-frame
		
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_1[VN_ROM_ADDR_BW-1:0]),
			// Ieration-Update Data
			.ram_write_data_1 (ram_write_dataA_1[VN_ROM_RD_BW-1:0]),
			
			.write_clk (vn_write_clk),
			.ib_ram_we (ib_ram_we[1])
		);	
	
		dnu_f0 u_f2(
			//output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath	
			.dnu0_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+0]), // internal signals accounting for each 128-entry partial LUT's output
			.dnu1_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+1]), // internal signals accounting for each 128-entry partial LUT's output		        
			.dnu2_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+2]), // internal signals accounting for each 128-entry partial LUT's output
			.dnu3_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+3]), // internal signals accounting for each 128-entry partial LUT's output
		
			// From the first DNU
			.vnu0_t10		 (vnu0_v2c[0]),
			.vnu0_c2v_2      (vnu0_E_reg2[QUAN_SIZE-1:0]),
			.vnu0_tranEn_in0 (vnu0_tranEn_out_f1),

			// From the second DNU
			.vnu1_t10		 (vnu1_v2c[0]),
			.vnu1_c2v_2      (vnu1_E_reg2[QUAN_SIZE-1:0]),
			.vnu1_tranEn_in0 (vnu1_tranEn_out_f1),

			// From the third DNU
			.vnu2_t10		 (vnu2_v2c[0]),
			.vnu2_c2v_2      (vnu2_E_reg2[QUAN_SIZE-1:0]),
			.vnu2_tranEn_in0 (vnu2_tranEn_out_f1),
		
			// From the fourth DNU
			.vnu3_t10		 (vnu3_v2c[0]),
			.vnu3_c2v_2      (vnu3_E_reg2[QUAN_SIZE-1:0]),
			.vnu3_tranEn_in0 (vnu3_tranEn_out_f1),
		
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset_outSet[j]), // offset determing the switch between multi-frame 
			
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_2[VN_ROM_ADDR_BW-1:0]),
			// Ieration-Update Data
			.ram_write_data_1 (ram_write_dataA_2[VN_ROM_RD_BW-1:0]),
			
			.write_clk (dn_write_clk),
			.ib_ram_we (ib_dnu_ram_we)
		);

		ib_vnu_3_pipeOut u_v2c_out0(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)]),

			.M0 (vnu0_v2c[0]),
			.M1 (vnu0_v2c[1]),
			.M2 (vnu0_v2c[2]),
			.ch_llr (vnu0_ch_llr[QUAN_SIZE-1:0]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out1(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)+1]),

			.M0 (vnu1_v2c[0]),
			.M1 (vnu1_v2c[1]),
			.M2 (vnu1_v2c[2]),
			.ch_llr (vnu1_ch_llr[QUAN_SIZE-1:0]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out2(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)+2]),

			.M0 (vnu2_v2c[0]),
			.M1 (vnu2_v2c[1]),
			.M2 (vnu2_v2c[2]),
			.ch_llr (vnu2_ch_llr[QUAN_SIZE-1:0]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out3(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)+3]),

			.M0 (vnu3_v2c[0]),
			.M1 (vnu3_v2c[1]),
			.M2 (vnu3_v2c[2]),
			.ch_llr (vnu3_ch_llr[QUAN_SIZE-1:0]),
			.v2c_src (v2c_src)              
		);
	end

	// Group B interacting with Port B of IB-ROMs
	integer inst_num_groupB = VNU3_INSTANTIATE_NUM - inst_num_groupA;
	for (j=inst_num_groupB-1; j<VNU3_INSTANTIATE_NUM; j=j+1) begin : vnu3_204_102_inst_GroupB
		// Instantiation of F_0
		// Instantiation of F_0
		wire [QUAN_SIZE-1:0] f0_out[0:7];
		wire [QUAN_SIZE-1:0] vnu0_c2v [0:1]; // c2v[1] and c2v[2]
		wire [QUAN_SIZE-1:0] vnu1_c2v [0:1]; // c2v[1] and c2v[2]
		wire [QUAN_SIZE-1:0] vnu2_c2v [0:1]; // c2v[1] and c2v[2]
		wire [QUAN_SIZE-1:0] vnu3_c2v [0:1]; // c2v[1] and c2v[2]	
		wire [1:0] vnu0_tranEn_out;
		wire [1:0] vnu1_tranEn_out;
		wire [1:0] vnu2_tranEn_out;
		wire [1:0] vnu3_tranEn_out;
	
		vnu3_f0 u_f0(
			.read_addr_offset_out (read_addr_offset_internal[0]), // to forward the current multi-frame offset signal to the next sub-datapath	
			// For the first VNU
			.vnu0_tPort0 (f0_out[0]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_tPort1 (f0_out[1]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_c2v1   (vnu0_c2v[0]),
			.vnu0_c2v2   (vnu0_c2v[1]),
			// For the second VNU       
			.vnu1_tPort0 (f0_out[2]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_tPort1 (f0_out[3]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_c2v1   (vnu1_c2v[0]),
			.vnu1_c2v2   (vnu1_c2v[1]),
			// For the third VNU        
			.vnu2_tPort0 (f0_out[4]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_tPort1 (f0_out[5]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_c2v1   (vnu2_c2v[0]),
			.vnu2_c2v2   (vnu2_c2v[1]),
			// For the fourth VNU       
			.vnu3_tPort0 (f0_out[6]  ), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_tPort1 (f0_out[7]  ), // internal signals accounting for each 128-entry partial LUT's output	
			.vnu3_c2v1   (vnu3_c2v[0]),
			.vnu3_c2v2   (vnu3_c2v[1]),
			// For first to fourth VNUs (output port)
			.vnu0_tranEn_out0 (vnu0_tranEn_out[0]),
			.vnu0_tranEn_out1 (vnu0_tranEn_out[1]),
			.vnu1_tranEn_out0 (vnu1_tranEn_out[0]),
			.vnu1_tranEn_out1 (vnu1_tranEn_out[1]),
			.vnu2_tranEn_out0 (vnu2_tranEn_out[0]),
			.vnu2_tranEn_out1 (vnu2_tranEn_out[1]),
			.vnu3_tranEn_out0 (vnu3_tranEn_out[0]),
			.vnu3_tranEn_out1 (vnu3_tranEn_out[1]),
		
			// From the first VNU
			.vnu0_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)]),
			.vnu0_ch_llr (ch_msg[VNU3_INSTANTIATE_UNIT*j]),
	
			// From the second VNU
			.vnu1_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.vnu1_ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+1]),
	
			// From the third VNU
			.vnu2_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.vnu2_ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+2]),
	
			// From the fourth VNU
			.vnu3_c2v_0  (c2v_0[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_c2v_1  (c2v_1[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_c2v_2  (c2v_2[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.vnu3_ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+3]),
		
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset), // offset determing the switch between multi-frame
		
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_0[VN_ROM_ADDR_BW-1:0]),
			// Ieration-Update Data
			.ram_write_data_0 (ram_write_dataA_0[VN_ROM_RD_BW-1:0]),
		
			.write_clk (vn_write_clk),
			.ib_ram_we (ib_ram_we[0])
		);

		// Instantiation of F_1
		wire [QUAN_SIZE-1:0] vnu0_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu1_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu2_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu3_v2c[0:2];
		wire [QUAN_SIZE-1:0] vnu0_E_reg2, vnu1_E_reg2, vnu2_E_reg2, vnu3_E_reg2;
		wire [1:0] vnu0_tranEn_out_f1;
		wire [1:0] vnu1_tranEn_out_f1;
		wire [1:0] vnu2_tranEn_out_f1;
		wire [1:0] vnu3_tranEn_out_f1;
		vnu3_f1 u_f1(
			.read_addr_offset_out (read_addr_offset_outSet[j]), // to forward the current multi-frame offset signal to the next sub-datapath	
			// For the first VNU
			.vnu0_v2c0 (vnu0_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_v2c1 (vnu0_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_v2c2 (vnu0_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu0_E_reg2 (vnu0_E_reg2[QUAN_SIZE-1:0]),
			.vnu0_tranEn_out0 (vnu0_tranEn_out_f1),
			// For the second VNU       
			.vnu1_v2c0 (vnu1_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_v2c1 (vnu1_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_v2c2 (vnu1_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu1_E_reg2 (vnu1_E_reg2[QUAN_SIZE-1:0]),
			.vnu1_tranEn_out0 (vnu1_tranEn_out_f1),
			// For the third VNU        
			.vnu2_v2c0 (vnu2_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_v2c1 (vnu2_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_v2c2 (vnu2_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu2_E_reg2 (vnu2_E_reg2[QUAN_SIZE-1:0]),
			.vnu2_tranEn_out0 (vnu2_tranEn_out_f1),
			// For the fourth VNU       
			.vnu3_v2c0 (vnu3_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_v2c1 (vnu3_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_v2c2 (vnu3_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			.vnu3_E_reg2 (vnu3_E_reg2[QUAN_SIZE-1:0]),	
			.vnu3_tranEn_out0 (vnu3_tranEn_out_f1),
			
			// From the first VNU
			.vnu0_t00   (f0_out[0]  ),
			.vnu0_t01   (f0_out[1]  ),
			.vnu0_c2v_1 (vnu0_c2v[0]),
			.vnu0_c2v_2 (vnu0_c2v[1]),
			.vnu0_tranEn_in0 (vnu0_tranEn_out[0]),
			.vnu0_tranEn_in1 (vnu0_tranEn_out[1]),
	
			// From the second VNU
			.vnu1_t00   (f0_out[2]  ),
			.vnu1_t01   (f0_out[3]  ),
			.vnu1_c2v_1 (vnu1_c2v[0]),
			.vnu1_c2v_2 (vnu1_c2v[1]), 
			.vnu1_tranEn_in0 (vnu1_tranEn_out[0]),
			.vnu1_tranEn_in1 (vnu1_tranEn_out[1]),	
	
			// From the third VNU
			.vnu2_t00   (f0_out[4]  ),
			.vnu2_t01   (f0_out[5]  ),
			.vnu2_c2v_1 (vnu2_c2v[0]),
			.vnu2_c2v_2 (vnu2_c2v[1]),
			.vnu2_tranEn_in0 (vnu2_tranEn_out[0]),
			.vnu2_tranEn_in1 (vnu2_tranEn_out[1]),
	
			// From the fourth VNU
			.vnu3_t00   (f0_out[6]  ),
			.vnu3_t01   (f0_out[7]  ),
			.vnu3_c2v_1 (vnu3_c2v[0]),
			.vnu3_c2v_2 (vnu3_c2v[1]),
			.vnu3_tranEn_in0 (vnu3_tranEn_out[0]),
			.vnu3_tranEn_in1 (vnu3_tranEn_out[1]),
		
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset_internal[0]), // offset determing the switch between multi-frame
		
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_1[VN_ROM_ADDR_BW-1:0]),
			// Ieration-Update Data
			.ram_write_data_1 (ram_write_dataA_1[VN_ROM_RD_BW-1:0]),
			
			.write_clk (vn_write_clk),
			.ib_ram_we (ib_ram_we[1])
		);	
	
		dnu_f0 u_f2(
			//output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath	
			.dnu0_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+0]), // internal signals accounting for each 128-entry partial LUT's output
			.dnu1_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+1]), // internal signals accounting for each 128-entry partial LUT's output		        
			.dnu2_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+2]), // internal signals accounting for each 128-entry partial LUT's output
			.dnu3_hard_decision (hard_decision[VNU3_INSTANTIATE_UNIT*j+3]), // internal signals accounting for each 128-entry partial LUT's output
		
			// From the first DNU
			.vnu0_t10		 (vnu0_v2c[0]),
			.vnu0_c2v_2      (vnu0_E_reg2[QUAN_SIZE-1:0]),
			.vnu0_tranEn_in0 (vnu0_tranEn_out_f1),

			// From the second DNU
			.vnu1_t10		 (vnu1_v2c[0]),
			.vnu1_c2v_2      (vnu1_E_reg2[QUAN_SIZE-1:0]),
			.vnu1_tranEn_in0 (vnu1_tranEn_out_f1),

			// From the third DNU
			.vnu2_t10		 (vnu2_v2c[0]),
			.vnu2_c2v_2      (vnu2_E_reg2[QUAN_SIZE-1:0]),
			.vnu2_tranEn_in0 (vnu2_tranEn_out_f1),
		
			// From the fourth DNU
			.vnu3_t10		 (vnu3_v2c[0]),
			.vnu3_c2v_2      (vnu3_E_reg2[QUAN_SIZE-1:0]),
			.vnu3_tranEn_in0 (vnu3_tranEn_out_f1),
		
			.read_clk (read_clk),
			.read_addr_offset (read_addr_offset_outSet[j]), // offset determing the switch between multi-frame 
			
			// Iteration-Update Page Address 
			.page_addr_ram (page_addr_ram_2[VN_ROM_ADDR_BW-1:0]),
			// Ieration-Update Data
			.ram_write_data_1 (ram_write_dataA_2[VN_ROM_RD_BW-1:0]),
			
			.write_clk (dn_write_clk),
			.ib_ram_we (ib_dnu_ram_we)
		);

		ib_vnu_3_pipeOut u_v2c_out0(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)]),

			.M0 (vnu0_v2c[0]),
			.M1 (vnu0_v2c[1]),
			.M2 (vnu0_v2c[2]),
			.ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out1(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)+1]),

			.M0 (vnu1_v2c[0]),
			.M1 (vnu1_v2c[1]),
			.M2 (vnu1_v2c[2]),
			.ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+1]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out2(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)+2]),

			.M0 (vnu2_v2c[0]),
			.M1 (vnu2_v2c[1]),
			.M2 (vnu2_v2c[2]),
			.ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+2]),
			.v2c_src (v2c_src)             
		);
		ib_vnu_3_pipeOut u_v2c_out3(
			.M0_src (v2c_0[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.M1_src (v2c_1[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.M2_src (v2c_2[(VNU3_INSTANTIATE_UNIT*j)+3]),

			.M0 (vnu3_v2c[0]),
			.M1 (vnu3_v2c[1]),
			.M2 (vnu3_v2c[2]),
			.ch_llr (ch_msg[(VNU3_INSTANTIATE_UNIT*j)+3]),
			.v2c_src (v2c_src)              
		);
	end
endgenerate

assign hard_decision_0 = hard_decision[0];
assign ch_msg[0] = ch_msg_0[QUAN_SIZE-1:0];
assign v2c_0_out0[QUAN_SIZE-1:0] = v2c_0[0];
assign c2v_0[0] = c2v_0_in0[QUAN_SIZE-1:0];
assign v2c_0_out1[QUAN_SIZE-1:0] = v2c_1[0];
assign c2v_1[0] = c2v_0_in1[QUAN_SIZE-1:0];
assign v2c_0_out2[QUAN_SIZE-1:0] = v2c_2[0];
assign c2v_2[0] = c2v_0_in2[QUAN_SIZE-1:0];
assign hard_decision_1 = hard_decision[1];
assign ch_msg[1] = ch_msg_1[QUAN_SIZE-1:0];
assign v2c_1_out0[QUAN_SIZE-1:0] = v2c_0[1];
assign c2v_0[1] = c2v_1_in0[QUAN_SIZE-1:0];
assign v2c_1_out1[QUAN_SIZE-1:0] = v2c_1[1];
assign c2v_1[1] = c2v_1_in1[QUAN_SIZE-1:0];
assign v2c_1_out2[QUAN_SIZE-1:0] = v2c_2[1];
assign c2v_2[1] = c2v_1_in2[QUAN_SIZE-1:0];
assign hard_decision_2 = hard_decision[2];
assign ch_msg[2] = ch_msg_2[QUAN_SIZE-1:0];
assign v2c_2_out0[QUAN_SIZE-1:0] = v2c_0[2];
assign c2v_0[2] = c2v_2_in0[QUAN_SIZE-1:0];
assign v2c_2_out1[QUAN_SIZE-1:0] = v2c_1[2];
assign c2v_1[2] = c2v_2_in1[QUAN_SIZE-1:0];
assign v2c_2_out2[QUAN_SIZE-1:0] = v2c_2[2];
assign c2v_2[2] = c2v_2_in2[QUAN_SIZE-1:0];
assign hard_decision_3 = hard_decision[3];
assign ch_msg[3] = ch_msg_3[QUAN_SIZE-1:0];
assign v2c_3_out0[QUAN_SIZE-1:0] = v2c_0[3];
assign c2v_0[3] = c2v_3_in0[QUAN_SIZE-1:0];
assign v2c_3_out1[QUAN_SIZE-1:0] = v2c_1[3];
assign c2v_1[3] = c2v_3_in1[QUAN_SIZE-1:0];
assign v2c_3_out2[QUAN_SIZE-1:0] = v2c_2[3];
assign c2v_2[3] = c2v_3_in2[QUAN_SIZE-1:0];
assign hard_decision_4 = hard_decision[4];
assign ch_msg[4] = ch_msg_4[QUAN_SIZE-1:0];
assign v2c_4_out0[QUAN_SIZE-1:0] = v2c_0[4];
assign c2v_0[4] = c2v_4_in0[QUAN_SIZE-1:0];
assign v2c_4_out1[QUAN_SIZE-1:0] = v2c_1[4];
assign c2v_1[4] = c2v_4_in1[QUAN_SIZE-1:0];
assign v2c_4_out2[QUAN_SIZE-1:0] = v2c_2[4];
assign c2v_2[4] = c2v_4_in2[QUAN_SIZE-1:0];
assign hard_decision_5 = hard_decision[5];
assign ch_msg[5] = ch_msg_5[QUAN_SIZE-1:0];
assign v2c_5_out0[QUAN_SIZE-1:0] = v2c_0[5];
assign c2v_0[5] = c2v_5_in0[QUAN_SIZE-1:0];
assign v2c_5_out1[QUAN_SIZE-1:0] = v2c_1[5];
assign c2v_1[5] = c2v_5_in1[QUAN_SIZE-1:0];
assign v2c_5_out2[QUAN_SIZE-1:0] = v2c_2[5];
assign c2v_2[5] = c2v_5_in2[QUAN_SIZE-1:0];
assign hard_decision_6 = hard_decision[6];
assign ch_msg[6] = ch_msg_6[QUAN_SIZE-1:0];
assign v2c_6_out0[QUAN_SIZE-1:0] = v2c_0[6];
assign c2v_0[6] = c2v_6_in0[QUAN_SIZE-1:0];
assign v2c_6_out1[QUAN_SIZE-1:0] = v2c_1[6];
assign c2v_1[6] = c2v_6_in1[QUAN_SIZE-1:0];
assign v2c_6_out2[QUAN_SIZE-1:0] = v2c_2[6];
assign c2v_2[6] = c2v_6_in2[QUAN_SIZE-1:0];
assign hard_decision_7 = hard_decision[7];
assign ch_msg[7] = ch_msg_7[QUAN_SIZE-1:0];
assign v2c_7_out0[QUAN_SIZE-1:0] = v2c_0[7];
assign c2v_0[7] = c2v_7_in0[QUAN_SIZE-1:0];
assign v2c_7_out1[QUAN_SIZE-1:0] = v2c_1[7];
assign c2v_1[7] = c2v_7_in1[QUAN_SIZE-1:0];
assign v2c_7_out2[QUAN_SIZE-1:0] = v2c_2[7];
assign c2v_2[7] = c2v_7_in2[QUAN_SIZE-1:0];
assign hard_decision_8 = hard_decision[8];
assign ch_msg[8] = ch_msg_8[QUAN_SIZE-1:0];
assign v2c_8_out0[QUAN_SIZE-1:0] = v2c_0[8];
assign c2v_0[8] = c2v_8_in0[QUAN_SIZE-1:0];
assign v2c_8_out1[QUAN_SIZE-1:0] = v2c_1[8];
assign c2v_1[8] = c2v_8_in1[QUAN_SIZE-1:0];
assign v2c_8_out2[QUAN_SIZE-1:0] = v2c_2[8];
assign c2v_2[8] = c2v_8_in2[QUAN_SIZE-1:0];
assign hard_decision_9 = hard_decision[9];
assign ch_msg[9] = ch_msg_9[QUAN_SIZE-1:0];
assign v2c_9_out0[QUAN_SIZE-1:0] = v2c_0[9];
assign c2v_0[9] = c2v_9_in0[QUAN_SIZE-1:0];
assign v2c_9_out1[QUAN_SIZE-1:0] = v2c_1[9];
assign c2v_1[9] = c2v_9_in1[QUAN_SIZE-1:0];
assign v2c_9_out2[QUAN_SIZE-1:0] = v2c_2[9];
assign c2v_2[9] = c2v_9_in2[QUAN_SIZE-1:0];
assign hard_decision_10 = hard_decision[10];
assign ch_msg[10] = ch_msg_10[QUAN_SIZE-1:0];
assign v2c_10_out0[QUAN_SIZE-1:0] = v2c_0[10];
assign c2v_0[10] = c2v_10_in0[QUAN_SIZE-1:0];
assign v2c_10_out1[QUAN_SIZE-1:0] = v2c_1[10];
assign c2v_1[10] = c2v_10_in1[QUAN_SIZE-1:0];
assign v2c_10_out2[QUAN_SIZE-1:0] = v2c_2[10];
assign c2v_2[10] = c2v_10_in2[QUAN_SIZE-1:0];
assign hard_decision_11 = hard_decision[11];
assign ch_msg[11] = ch_msg_11[QUAN_SIZE-1:0];
assign v2c_11_out0[QUAN_SIZE-1:0] = v2c_0[11];
assign c2v_0[11] = c2v_11_in0[QUAN_SIZE-1:0];
assign v2c_11_out1[QUAN_SIZE-1:0] = v2c_1[11];
assign c2v_1[11] = c2v_11_in1[QUAN_SIZE-1:0];
assign v2c_11_out2[QUAN_SIZE-1:0] = v2c_2[11];
assign c2v_2[11] = c2v_11_in2[QUAN_SIZE-1:0];
assign hard_decision_12 = hard_decision[12];
assign ch_msg[12] = ch_msg_12[QUAN_SIZE-1:0];
assign v2c_12_out0[QUAN_SIZE-1:0] = v2c_0[12];
assign c2v_0[12] = c2v_12_in0[QUAN_SIZE-1:0];
assign v2c_12_out1[QUAN_SIZE-1:0] = v2c_1[12];
assign c2v_1[12] = c2v_12_in1[QUAN_SIZE-1:0];
assign v2c_12_out2[QUAN_SIZE-1:0] = v2c_2[12];
assign c2v_2[12] = c2v_12_in2[QUAN_SIZE-1:0];
assign hard_decision_13 = hard_decision[13];
assign ch_msg[13] = ch_msg_13[QUAN_SIZE-1:0];
assign v2c_13_out0[QUAN_SIZE-1:0] = v2c_0[13];
assign c2v_0[13] = c2v_13_in0[QUAN_SIZE-1:0];
assign v2c_13_out1[QUAN_SIZE-1:0] = v2c_1[13];
assign c2v_1[13] = c2v_13_in1[QUAN_SIZE-1:0];
assign v2c_13_out2[QUAN_SIZE-1:0] = v2c_2[13];
assign c2v_2[13] = c2v_13_in2[QUAN_SIZE-1:0];
assign hard_decision_14 = hard_decision[14];
assign ch_msg[14] = ch_msg_14[QUAN_SIZE-1:0];
assign v2c_14_out0[QUAN_SIZE-1:0] = v2c_0[14];
assign c2v_0[14] = c2v_14_in0[QUAN_SIZE-1:0];
assign v2c_14_out1[QUAN_SIZE-1:0] = v2c_1[14];
assign c2v_1[14] = c2v_14_in1[QUAN_SIZE-1:0];
assign v2c_14_out2[QUAN_SIZE-1:0] = v2c_2[14];
assign c2v_2[14] = c2v_14_in2[QUAN_SIZE-1:0];
assign hard_decision_15 = hard_decision[15];
assign ch_msg[15] = ch_msg_15[QUAN_SIZE-1:0];
assign v2c_15_out0[QUAN_SIZE-1:0] = v2c_0[15];
assign c2v_0[15] = c2v_15_in0[QUAN_SIZE-1:0];
assign v2c_15_out1[QUAN_SIZE-1:0] = v2c_1[15];
assign c2v_1[15] = c2v_15_in1[QUAN_SIZE-1:0];
assign v2c_15_out2[QUAN_SIZE-1:0] = v2c_2[15];
assign c2v_2[15] = c2v_15_in2[QUAN_SIZE-1:0];
assign hard_decision_16 = hard_decision[16];
assign ch_msg[16] = ch_msg_16[QUAN_SIZE-1:0];
assign v2c_16_out0[QUAN_SIZE-1:0] = v2c_0[16];
assign c2v_0[16] = c2v_16_in0[QUAN_SIZE-1:0];
assign v2c_16_out1[QUAN_SIZE-1:0] = v2c_1[16];
assign c2v_1[16] = c2v_16_in1[QUAN_SIZE-1:0];
assign v2c_16_out2[QUAN_SIZE-1:0] = v2c_2[16];
assign c2v_2[16] = c2v_16_in2[QUAN_SIZE-1:0];
assign hard_decision_17 = hard_decision[17];
assign ch_msg[17] = ch_msg_17[QUAN_SIZE-1:0];
assign v2c_17_out0[QUAN_SIZE-1:0] = v2c_0[17];
assign c2v_0[17] = c2v_17_in0[QUAN_SIZE-1:0];
assign v2c_17_out1[QUAN_SIZE-1:0] = v2c_1[17];
assign c2v_1[17] = c2v_17_in1[QUAN_SIZE-1:0];
assign v2c_17_out2[QUAN_SIZE-1:0] = v2c_2[17];
assign c2v_2[17] = c2v_17_in2[QUAN_SIZE-1:0];
assign hard_decision_18 = hard_decision[18];
assign ch_msg[18] = ch_msg_18[QUAN_SIZE-1:0];
assign v2c_18_out0[QUAN_SIZE-1:0] = v2c_0[18];
assign c2v_0[18] = c2v_18_in0[QUAN_SIZE-1:0];
assign v2c_18_out1[QUAN_SIZE-1:0] = v2c_1[18];
assign c2v_1[18] = c2v_18_in1[QUAN_SIZE-1:0];
assign v2c_18_out2[QUAN_SIZE-1:0] = v2c_2[18];
assign c2v_2[18] = c2v_18_in2[QUAN_SIZE-1:0];
assign hard_decision_19 = hard_decision[19];
assign ch_msg[19] = ch_msg_19[QUAN_SIZE-1:0];
assign v2c_19_out0[QUAN_SIZE-1:0] = v2c_0[19];
assign c2v_0[19] = c2v_19_in0[QUAN_SIZE-1:0];
assign v2c_19_out1[QUAN_SIZE-1:0] = v2c_1[19];
assign c2v_1[19] = c2v_19_in1[QUAN_SIZE-1:0];
assign v2c_19_out2[QUAN_SIZE-1:0] = v2c_2[19];
assign c2v_2[19] = c2v_19_in2[QUAN_SIZE-1:0];
assign hard_decision_20 = hard_decision[20];
assign ch_msg[20] = ch_msg_20[QUAN_SIZE-1:0];
assign v2c_20_out0[QUAN_SIZE-1:0] = v2c_0[20];
assign c2v_0[20] = c2v_20_in0[QUAN_SIZE-1:0];
assign v2c_20_out1[QUAN_SIZE-1:0] = v2c_1[20];
assign c2v_1[20] = c2v_20_in1[QUAN_SIZE-1:0];
assign v2c_20_out2[QUAN_SIZE-1:0] = v2c_2[20];
assign c2v_2[20] = c2v_20_in2[QUAN_SIZE-1:0];
assign hard_decision_21 = hard_decision[21];
assign ch_msg[21] = ch_msg_21[QUAN_SIZE-1:0];
assign v2c_21_out0[QUAN_SIZE-1:0] = v2c_0[21];
assign c2v_0[21] = c2v_21_in0[QUAN_SIZE-1:0];
assign v2c_21_out1[QUAN_SIZE-1:0] = v2c_1[21];
assign c2v_1[21] = c2v_21_in1[QUAN_SIZE-1:0];
assign v2c_21_out2[QUAN_SIZE-1:0] = v2c_2[21];
assign c2v_2[21] = c2v_21_in2[QUAN_SIZE-1:0];
assign hard_decision_22 = hard_decision[22];
assign ch_msg[22] = ch_msg_22[QUAN_SIZE-1:0];
assign v2c_22_out0[QUAN_SIZE-1:0] = v2c_0[22];
assign c2v_0[22] = c2v_22_in0[QUAN_SIZE-1:0];
assign v2c_22_out1[QUAN_SIZE-1:0] = v2c_1[22];
assign c2v_1[22] = c2v_22_in1[QUAN_SIZE-1:0];
assign v2c_22_out2[QUAN_SIZE-1:0] = v2c_2[22];
assign c2v_2[22] = c2v_22_in2[QUAN_SIZE-1:0];
assign hard_decision_23 = hard_decision[23];
assign ch_msg[23] = ch_msg_23[QUAN_SIZE-1:0];
assign v2c_23_out0[QUAN_SIZE-1:0] = v2c_0[23];
assign c2v_0[23] = c2v_23_in0[QUAN_SIZE-1:0];
assign v2c_23_out1[QUAN_SIZE-1:0] = v2c_1[23];
assign c2v_1[23] = c2v_23_in1[QUAN_SIZE-1:0];
assign v2c_23_out2[QUAN_SIZE-1:0] = v2c_2[23];
assign c2v_2[23] = c2v_23_in2[QUAN_SIZE-1:0];
assign hard_decision_24 = hard_decision[24];
assign ch_msg[24] = ch_msg_24[QUAN_SIZE-1:0];
assign v2c_24_out0[QUAN_SIZE-1:0] = v2c_0[24];
assign c2v_0[24] = c2v_24_in0[QUAN_SIZE-1:0];
assign v2c_24_out1[QUAN_SIZE-1:0] = v2c_1[24];
assign c2v_1[24] = c2v_24_in1[QUAN_SIZE-1:0];
assign v2c_24_out2[QUAN_SIZE-1:0] = v2c_2[24];
assign c2v_2[24] = c2v_24_in2[QUAN_SIZE-1:0];
assign hard_decision_25 = hard_decision[25];
assign ch_msg[25] = ch_msg_25[QUAN_SIZE-1:0];
assign v2c_25_out0[QUAN_SIZE-1:0] = v2c_0[25];
assign c2v_0[25] = c2v_25_in0[QUAN_SIZE-1:0];
assign v2c_25_out1[QUAN_SIZE-1:0] = v2c_1[25];
assign c2v_1[25] = c2v_25_in1[QUAN_SIZE-1:0];
assign v2c_25_out2[QUAN_SIZE-1:0] = v2c_2[25];
assign c2v_2[25] = c2v_25_in2[QUAN_SIZE-1:0];
assign hard_decision_26 = hard_decision[26];
assign ch_msg[26] = ch_msg_26[QUAN_SIZE-1:0];
assign v2c_26_out0[QUAN_SIZE-1:0] = v2c_0[26];
assign c2v_0[26] = c2v_26_in0[QUAN_SIZE-1:0];
assign v2c_26_out1[QUAN_SIZE-1:0] = v2c_1[26];
assign c2v_1[26] = c2v_26_in1[QUAN_SIZE-1:0];
assign v2c_26_out2[QUAN_SIZE-1:0] = v2c_2[26];
assign c2v_2[26] = c2v_26_in2[QUAN_SIZE-1:0];
assign hard_decision_27 = hard_decision[27];
assign ch_msg[27] = ch_msg_27[QUAN_SIZE-1:0];
assign v2c_27_out0[QUAN_SIZE-1:0] = v2c_0[27];
assign c2v_0[27] = c2v_27_in0[QUAN_SIZE-1:0];
assign v2c_27_out1[QUAN_SIZE-1:0] = v2c_1[27];
assign c2v_1[27] = c2v_27_in1[QUAN_SIZE-1:0];
assign v2c_27_out2[QUAN_SIZE-1:0] = v2c_2[27];
assign c2v_2[27] = c2v_27_in2[QUAN_SIZE-1:0];
assign hard_decision_28 = hard_decision[28];
assign ch_msg[28] = ch_msg_28[QUAN_SIZE-1:0];
assign v2c_28_out0[QUAN_SIZE-1:0] = v2c_0[28];
assign c2v_0[28] = c2v_28_in0[QUAN_SIZE-1:0];
assign v2c_28_out1[QUAN_SIZE-1:0] = v2c_1[28];
assign c2v_1[28] = c2v_28_in1[QUAN_SIZE-1:0];
assign v2c_28_out2[QUAN_SIZE-1:0] = v2c_2[28];
assign c2v_2[28] = c2v_28_in2[QUAN_SIZE-1:0];
assign hard_decision_29 = hard_decision[29];
assign ch_msg[29] = ch_msg_29[QUAN_SIZE-1:0];
assign v2c_29_out0[QUAN_SIZE-1:0] = v2c_0[29];
assign c2v_0[29] = c2v_29_in0[QUAN_SIZE-1:0];
assign v2c_29_out1[QUAN_SIZE-1:0] = v2c_1[29];
assign c2v_1[29] = c2v_29_in1[QUAN_SIZE-1:0];
assign v2c_29_out2[QUAN_SIZE-1:0] = v2c_2[29];
assign c2v_2[29] = c2v_29_in2[QUAN_SIZE-1:0];
assign hard_decision_30 = hard_decision[30];
assign ch_msg[30] = ch_msg_30[QUAN_SIZE-1:0];
assign v2c_30_out0[QUAN_SIZE-1:0] = v2c_0[30];
assign c2v_0[30] = c2v_30_in0[QUAN_SIZE-1:0];
assign v2c_30_out1[QUAN_SIZE-1:0] = v2c_1[30];
assign c2v_1[30] = c2v_30_in1[QUAN_SIZE-1:0];
assign v2c_30_out2[QUAN_SIZE-1:0] = v2c_2[30];
assign c2v_2[30] = c2v_30_in2[QUAN_SIZE-1:0];
assign hard_decision_31 = hard_decision[31];
assign ch_msg[31] = ch_msg_31[QUAN_SIZE-1:0];
assign v2c_31_out0[QUAN_SIZE-1:0] = v2c_0[31];
assign c2v_0[31] = c2v_31_in0[QUAN_SIZE-1:0];
assign v2c_31_out1[QUAN_SIZE-1:0] = v2c_1[31];
assign c2v_1[31] = c2v_31_in1[QUAN_SIZE-1:0];
assign v2c_31_out2[QUAN_SIZE-1:0] = v2c_2[31];
assign c2v_2[31] = c2v_31_in2[QUAN_SIZE-1:0];
assign hard_decision_32 = hard_decision[32];
assign ch_msg[32] = ch_msg_32[QUAN_SIZE-1:0];
assign v2c_32_out0[QUAN_SIZE-1:0] = v2c_0[32];
assign c2v_0[32] = c2v_32_in0[QUAN_SIZE-1:0];
assign v2c_32_out1[QUAN_SIZE-1:0] = v2c_1[32];
assign c2v_1[32] = c2v_32_in1[QUAN_SIZE-1:0];
assign v2c_32_out2[QUAN_SIZE-1:0] = v2c_2[32];
assign c2v_2[32] = c2v_32_in2[QUAN_SIZE-1:0];
assign hard_decision_33 = hard_decision[33];
assign ch_msg[33] = ch_msg_33[QUAN_SIZE-1:0];
assign v2c_33_out0[QUAN_SIZE-1:0] = v2c_0[33];
assign c2v_0[33] = c2v_33_in0[QUAN_SIZE-1:0];
assign v2c_33_out1[QUAN_SIZE-1:0] = v2c_1[33];
assign c2v_1[33] = c2v_33_in1[QUAN_SIZE-1:0];
assign v2c_33_out2[QUAN_SIZE-1:0] = v2c_2[33];
assign c2v_2[33] = c2v_33_in2[QUAN_SIZE-1:0];
assign hard_decision_34 = hard_decision[34];
assign ch_msg[34] = ch_msg_34[QUAN_SIZE-1:0];
assign v2c_34_out0[QUAN_SIZE-1:0] = v2c_0[34];
assign c2v_0[34] = c2v_34_in0[QUAN_SIZE-1:0];
assign v2c_34_out1[QUAN_SIZE-1:0] = v2c_1[34];
assign c2v_1[34] = c2v_34_in1[QUAN_SIZE-1:0];
assign v2c_34_out2[QUAN_SIZE-1:0] = v2c_2[34];
assign c2v_2[34] = c2v_34_in2[QUAN_SIZE-1:0];
assign hard_decision_35 = hard_decision[35];
assign ch_msg[35] = ch_msg_35[QUAN_SIZE-1:0];
assign v2c_35_out0[QUAN_SIZE-1:0] = v2c_0[35];
assign c2v_0[35] = c2v_35_in0[QUAN_SIZE-1:0];
assign v2c_35_out1[QUAN_SIZE-1:0] = v2c_1[35];
assign c2v_1[35] = c2v_35_in1[QUAN_SIZE-1:0];
assign v2c_35_out2[QUAN_SIZE-1:0] = v2c_2[35];
assign c2v_2[35] = c2v_35_in2[QUAN_SIZE-1:0];
assign hard_decision_36 = hard_decision[36];
assign ch_msg[36] = ch_msg_36[QUAN_SIZE-1:0];
assign v2c_36_out0[QUAN_SIZE-1:0] = v2c_0[36];
assign c2v_0[36] = c2v_36_in0[QUAN_SIZE-1:0];
assign v2c_36_out1[QUAN_SIZE-1:0] = v2c_1[36];
assign c2v_1[36] = c2v_36_in1[QUAN_SIZE-1:0];
assign v2c_36_out2[QUAN_SIZE-1:0] = v2c_2[36];
assign c2v_2[36] = c2v_36_in2[QUAN_SIZE-1:0];
assign hard_decision_37 = hard_decision[37];
assign ch_msg[37] = ch_msg_37[QUAN_SIZE-1:0];
assign v2c_37_out0[QUAN_SIZE-1:0] = v2c_0[37];
assign c2v_0[37] = c2v_37_in0[QUAN_SIZE-1:0];
assign v2c_37_out1[QUAN_SIZE-1:0] = v2c_1[37];
assign c2v_1[37] = c2v_37_in1[QUAN_SIZE-1:0];
assign v2c_37_out2[QUAN_SIZE-1:0] = v2c_2[37];
assign c2v_2[37] = c2v_37_in2[QUAN_SIZE-1:0];
assign hard_decision_38 = hard_decision[38];
assign ch_msg[38] = ch_msg_38[QUAN_SIZE-1:0];
assign v2c_38_out0[QUAN_SIZE-1:0] = v2c_0[38];
assign c2v_0[38] = c2v_38_in0[QUAN_SIZE-1:0];
assign v2c_38_out1[QUAN_SIZE-1:0] = v2c_1[38];
assign c2v_1[38] = c2v_38_in1[QUAN_SIZE-1:0];
assign v2c_38_out2[QUAN_SIZE-1:0] = v2c_2[38];
assign c2v_2[38] = c2v_38_in2[QUAN_SIZE-1:0];
assign hard_decision_39 = hard_decision[39];
assign ch_msg[39] = ch_msg_39[QUAN_SIZE-1:0];
assign v2c_39_out0[QUAN_SIZE-1:0] = v2c_0[39];
assign c2v_0[39] = c2v_39_in0[QUAN_SIZE-1:0];
assign v2c_39_out1[QUAN_SIZE-1:0] = v2c_1[39];
assign c2v_1[39] = c2v_39_in1[QUAN_SIZE-1:0];
assign v2c_39_out2[QUAN_SIZE-1:0] = v2c_2[39];
assign c2v_2[39] = c2v_39_in2[QUAN_SIZE-1:0];
assign hard_decision_40 = hard_decision[40];
assign ch_msg[40] = ch_msg_40[QUAN_SIZE-1:0];
assign v2c_40_out0[QUAN_SIZE-1:0] = v2c_0[40];
assign c2v_0[40] = c2v_40_in0[QUAN_SIZE-1:0];
assign v2c_40_out1[QUAN_SIZE-1:0] = v2c_1[40];
assign c2v_1[40] = c2v_40_in1[QUAN_SIZE-1:0];
assign v2c_40_out2[QUAN_SIZE-1:0] = v2c_2[40];
assign c2v_2[40] = c2v_40_in2[QUAN_SIZE-1:0];
assign hard_decision_41 = hard_decision[41];
assign ch_msg[41] = ch_msg_41[QUAN_SIZE-1:0];
assign v2c_41_out0[QUAN_SIZE-1:0] = v2c_0[41];
assign c2v_0[41] = c2v_41_in0[QUAN_SIZE-1:0];
assign v2c_41_out1[QUAN_SIZE-1:0] = v2c_1[41];
assign c2v_1[41] = c2v_41_in1[QUAN_SIZE-1:0];
assign v2c_41_out2[QUAN_SIZE-1:0] = v2c_2[41];
assign c2v_2[41] = c2v_41_in2[QUAN_SIZE-1:0];
assign hard_decision_42 = hard_decision[42];
assign ch_msg[42] = ch_msg_42[QUAN_SIZE-1:0];
assign v2c_42_out0[QUAN_SIZE-1:0] = v2c_0[42];
assign c2v_0[42] = c2v_42_in0[QUAN_SIZE-1:0];
assign v2c_42_out1[QUAN_SIZE-1:0] = v2c_1[42];
assign c2v_1[42] = c2v_42_in1[QUAN_SIZE-1:0];
assign v2c_42_out2[QUAN_SIZE-1:0] = v2c_2[42];
assign c2v_2[42] = c2v_42_in2[QUAN_SIZE-1:0];
assign hard_decision_43 = hard_decision[43];
assign ch_msg[43] = ch_msg_43[QUAN_SIZE-1:0];
assign v2c_43_out0[QUAN_SIZE-1:0] = v2c_0[43];
assign c2v_0[43] = c2v_43_in0[QUAN_SIZE-1:0];
assign v2c_43_out1[QUAN_SIZE-1:0] = v2c_1[43];
assign c2v_1[43] = c2v_43_in1[QUAN_SIZE-1:0];
assign v2c_43_out2[QUAN_SIZE-1:0] = v2c_2[43];
assign c2v_2[43] = c2v_43_in2[QUAN_SIZE-1:0];
assign hard_decision_44 = hard_decision[44];
assign ch_msg[44] = ch_msg_44[QUAN_SIZE-1:0];
assign v2c_44_out0[QUAN_SIZE-1:0] = v2c_0[44];
assign c2v_0[44] = c2v_44_in0[QUAN_SIZE-1:0];
assign v2c_44_out1[QUAN_SIZE-1:0] = v2c_1[44];
assign c2v_1[44] = c2v_44_in1[QUAN_SIZE-1:0];
assign v2c_44_out2[QUAN_SIZE-1:0] = v2c_2[44];
assign c2v_2[44] = c2v_44_in2[QUAN_SIZE-1:0];
assign hard_decision_45 = hard_decision[45];
assign ch_msg[45] = ch_msg_45[QUAN_SIZE-1:0];
assign v2c_45_out0[QUAN_SIZE-1:0] = v2c_0[45];
assign c2v_0[45] = c2v_45_in0[QUAN_SIZE-1:0];
assign v2c_45_out1[QUAN_SIZE-1:0] = v2c_1[45];
assign c2v_1[45] = c2v_45_in1[QUAN_SIZE-1:0];
assign v2c_45_out2[QUAN_SIZE-1:0] = v2c_2[45];
assign c2v_2[45] = c2v_45_in2[QUAN_SIZE-1:0];
assign hard_decision_46 = hard_decision[46];
assign ch_msg[46] = ch_msg_46[QUAN_SIZE-1:0];
assign v2c_46_out0[QUAN_SIZE-1:0] = v2c_0[46];
assign c2v_0[46] = c2v_46_in0[QUAN_SIZE-1:0];
assign v2c_46_out1[QUAN_SIZE-1:0] = v2c_1[46];
assign c2v_1[46] = c2v_46_in1[QUAN_SIZE-1:0];
assign v2c_46_out2[QUAN_SIZE-1:0] = v2c_2[46];
assign c2v_2[46] = c2v_46_in2[QUAN_SIZE-1:0];
assign hard_decision_47 = hard_decision[47];
assign ch_msg[47] = ch_msg_47[QUAN_SIZE-1:0];
assign v2c_47_out0[QUAN_SIZE-1:0] = v2c_0[47];
assign c2v_0[47] = c2v_47_in0[QUAN_SIZE-1:0];
assign v2c_47_out1[QUAN_SIZE-1:0] = v2c_1[47];
assign c2v_1[47] = c2v_47_in1[QUAN_SIZE-1:0];
assign v2c_47_out2[QUAN_SIZE-1:0] = v2c_2[47];
assign c2v_2[47] = c2v_47_in2[QUAN_SIZE-1:0];
assign hard_decision_48 = hard_decision[48];
assign ch_msg[48] = ch_msg_48[QUAN_SIZE-1:0];
assign v2c_48_out0[QUAN_SIZE-1:0] = v2c_0[48];
assign c2v_0[48] = c2v_48_in0[QUAN_SIZE-1:0];
assign v2c_48_out1[QUAN_SIZE-1:0] = v2c_1[48];
assign c2v_1[48] = c2v_48_in1[QUAN_SIZE-1:0];
assign v2c_48_out2[QUAN_SIZE-1:0] = v2c_2[48];
assign c2v_2[48] = c2v_48_in2[QUAN_SIZE-1:0];
assign hard_decision_49 = hard_decision[49];
assign ch_msg[49] = ch_msg_49[QUAN_SIZE-1:0];
assign v2c_49_out0[QUAN_SIZE-1:0] = v2c_0[49];
assign c2v_0[49] = c2v_49_in0[QUAN_SIZE-1:0];
assign v2c_49_out1[QUAN_SIZE-1:0] = v2c_1[49];
assign c2v_1[49] = c2v_49_in1[QUAN_SIZE-1:0];
assign v2c_49_out2[QUAN_SIZE-1:0] = v2c_2[49];
assign c2v_2[49] = c2v_49_in2[QUAN_SIZE-1:0];
assign hard_decision_50 = hard_decision[50];
assign ch_msg[50] = ch_msg_50[QUAN_SIZE-1:0];
assign v2c_50_out0[QUAN_SIZE-1:0] = v2c_0[50];
assign c2v_0[50] = c2v_50_in0[QUAN_SIZE-1:0];
assign v2c_50_out1[QUAN_SIZE-1:0] = v2c_1[50];
assign c2v_1[50] = c2v_50_in1[QUAN_SIZE-1:0];
assign v2c_50_out2[QUAN_SIZE-1:0] = v2c_2[50];
assign c2v_2[50] = c2v_50_in2[QUAN_SIZE-1:0];
assign hard_decision_51 = hard_decision[51];
assign ch_msg[51] = ch_msg_51[QUAN_SIZE-1:0];
assign v2c_51_out0[QUAN_SIZE-1:0] = v2c_0[51];
assign c2v_0[51] = c2v_51_in0[QUAN_SIZE-1:0];
assign v2c_51_out1[QUAN_SIZE-1:0] = v2c_1[51];
assign c2v_1[51] = c2v_51_in1[QUAN_SIZE-1:0];
assign v2c_51_out2[QUAN_SIZE-1:0] = v2c_2[51];
assign c2v_2[51] = c2v_51_in2[QUAN_SIZE-1:0];
assign hard_decision_52 = hard_decision[52];
assign ch_msg[52] = ch_msg_52[QUAN_SIZE-1:0];
assign v2c_52_out0[QUAN_SIZE-1:0] = v2c_0[52];
assign c2v_0[52] = c2v_52_in0[QUAN_SIZE-1:0];
assign v2c_52_out1[QUAN_SIZE-1:0] = v2c_1[52];
assign c2v_1[52] = c2v_52_in1[QUAN_SIZE-1:0];
assign v2c_52_out2[QUAN_SIZE-1:0] = v2c_2[52];
assign c2v_2[52] = c2v_52_in2[QUAN_SIZE-1:0];
assign hard_decision_53 = hard_decision[53];
assign ch_msg[53] = ch_msg_53[QUAN_SIZE-1:0];
assign v2c_53_out0[QUAN_SIZE-1:0] = v2c_0[53];
assign c2v_0[53] = c2v_53_in0[QUAN_SIZE-1:0];
assign v2c_53_out1[QUAN_SIZE-1:0] = v2c_1[53];
assign c2v_1[53] = c2v_53_in1[QUAN_SIZE-1:0];
assign v2c_53_out2[QUAN_SIZE-1:0] = v2c_2[53];
assign c2v_2[53] = c2v_53_in2[QUAN_SIZE-1:0];
assign hard_decision_54 = hard_decision[54];
assign ch_msg[54] = ch_msg_54[QUAN_SIZE-1:0];
assign v2c_54_out0[QUAN_SIZE-1:0] = v2c_0[54];
assign c2v_0[54] = c2v_54_in0[QUAN_SIZE-1:0];
assign v2c_54_out1[QUAN_SIZE-1:0] = v2c_1[54];
assign c2v_1[54] = c2v_54_in1[QUAN_SIZE-1:0];
assign v2c_54_out2[QUAN_SIZE-1:0] = v2c_2[54];
assign c2v_2[54] = c2v_54_in2[QUAN_SIZE-1:0];
assign hard_decision_55 = hard_decision[55];
assign ch_msg[55] = ch_msg_55[QUAN_SIZE-1:0];
assign v2c_55_out0[QUAN_SIZE-1:0] = v2c_0[55];
assign c2v_0[55] = c2v_55_in0[QUAN_SIZE-1:0];
assign v2c_55_out1[QUAN_SIZE-1:0] = v2c_1[55];
assign c2v_1[55] = c2v_55_in1[QUAN_SIZE-1:0];
assign v2c_55_out2[QUAN_SIZE-1:0] = v2c_2[55];
assign c2v_2[55] = c2v_55_in2[QUAN_SIZE-1:0];
assign hard_decision_56 = hard_decision[56];
assign ch_msg[56] = ch_msg_56[QUAN_SIZE-1:0];
assign v2c_56_out0[QUAN_SIZE-1:0] = v2c_0[56];
assign c2v_0[56] = c2v_56_in0[QUAN_SIZE-1:0];
assign v2c_56_out1[QUAN_SIZE-1:0] = v2c_1[56];
assign c2v_1[56] = c2v_56_in1[QUAN_SIZE-1:0];
assign v2c_56_out2[QUAN_SIZE-1:0] = v2c_2[56];
assign c2v_2[56] = c2v_56_in2[QUAN_SIZE-1:0];
assign hard_decision_57 = hard_decision[57];
assign ch_msg[57] = ch_msg_57[QUAN_SIZE-1:0];
assign v2c_57_out0[QUAN_SIZE-1:0] = v2c_0[57];
assign c2v_0[57] = c2v_57_in0[QUAN_SIZE-1:0];
assign v2c_57_out1[QUAN_SIZE-1:0] = v2c_1[57];
assign c2v_1[57] = c2v_57_in1[QUAN_SIZE-1:0];
assign v2c_57_out2[QUAN_SIZE-1:0] = v2c_2[57];
assign c2v_2[57] = c2v_57_in2[QUAN_SIZE-1:0];
assign hard_decision_58 = hard_decision[58];
assign ch_msg[58] = ch_msg_58[QUAN_SIZE-1:0];
assign v2c_58_out0[QUAN_SIZE-1:0] = v2c_0[58];
assign c2v_0[58] = c2v_58_in0[QUAN_SIZE-1:0];
assign v2c_58_out1[QUAN_SIZE-1:0] = v2c_1[58];
assign c2v_1[58] = c2v_58_in1[QUAN_SIZE-1:0];
assign v2c_58_out2[QUAN_SIZE-1:0] = v2c_2[58];
assign c2v_2[58] = c2v_58_in2[QUAN_SIZE-1:0];
assign hard_decision_59 = hard_decision[59];
assign ch_msg[59] = ch_msg_59[QUAN_SIZE-1:0];
assign v2c_59_out0[QUAN_SIZE-1:0] = v2c_0[59];
assign c2v_0[59] = c2v_59_in0[QUAN_SIZE-1:0];
assign v2c_59_out1[QUAN_SIZE-1:0] = v2c_1[59];
assign c2v_1[59] = c2v_59_in1[QUAN_SIZE-1:0];
assign v2c_59_out2[QUAN_SIZE-1:0] = v2c_2[59];
assign c2v_2[59] = c2v_59_in2[QUAN_SIZE-1:0];
assign hard_decision_60 = hard_decision[60];
assign ch_msg[60] = ch_msg_60[QUAN_SIZE-1:0];
assign v2c_60_out0[QUAN_SIZE-1:0] = v2c_0[60];
assign c2v_0[60] = c2v_60_in0[QUAN_SIZE-1:0];
assign v2c_60_out1[QUAN_SIZE-1:0] = v2c_1[60];
assign c2v_1[60] = c2v_60_in1[QUAN_SIZE-1:0];
assign v2c_60_out2[QUAN_SIZE-1:0] = v2c_2[60];
assign c2v_2[60] = c2v_60_in2[QUAN_SIZE-1:0];
assign hard_decision_61 = hard_decision[61];
assign ch_msg[61] = ch_msg_61[QUAN_SIZE-1:0];
assign v2c_61_out0[QUAN_SIZE-1:0] = v2c_0[61];
assign c2v_0[61] = c2v_61_in0[QUAN_SIZE-1:0];
assign v2c_61_out1[QUAN_SIZE-1:0] = v2c_1[61];
assign c2v_1[61] = c2v_61_in1[QUAN_SIZE-1:0];
assign v2c_61_out2[QUAN_SIZE-1:0] = v2c_2[61];
assign c2v_2[61] = c2v_61_in2[QUAN_SIZE-1:0];
assign hard_decision_62 = hard_decision[62];
assign ch_msg[62] = ch_msg_62[QUAN_SIZE-1:0];
assign v2c_62_out0[QUAN_SIZE-1:0] = v2c_0[62];
assign c2v_0[62] = c2v_62_in0[QUAN_SIZE-1:0];
assign v2c_62_out1[QUAN_SIZE-1:0] = v2c_1[62];
assign c2v_1[62] = c2v_62_in1[QUAN_SIZE-1:0];
assign v2c_62_out2[QUAN_SIZE-1:0] = v2c_2[62];
assign c2v_2[62] = c2v_62_in2[QUAN_SIZE-1:0];
assign hard_decision_63 = hard_decision[63];
assign ch_msg[63] = ch_msg_63[QUAN_SIZE-1:0];
assign v2c_63_out0[QUAN_SIZE-1:0] = v2c_0[63];
assign c2v_0[63] = c2v_63_in0[QUAN_SIZE-1:0];
assign v2c_63_out1[QUAN_SIZE-1:0] = v2c_1[63];
assign c2v_1[63] = c2v_63_in1[QUAN_SIZE-1:0];
assign v2c_63_out2[QUAN_SIZE-1:0] = v2c_2[63];
assign c2v_2[63] = c2v_63_in2[QUAN_SIZE-1:0];
assign hard_decision_64 = hard_decision[64];
assign ch_msg[64] = ch_msg_64[QUAN_SIZE-1:0];
assign v2c_64_out0[QUAN_SIZE-1:0] = v2c_0[64];
assign c2v_0[64] = c2v_64_in0[QUAN_SIZE-1:0];
assign v2c_64_out1[QUAN_SIZE-1:0] = v2c_1[64];
assign c2v_1[64] = c2v_64_in1[QUAN_SIZE-1:0];
assign v2c_64_out2[QUAN_SIZE-1:0] = v2c_2[64];
assign c2v_2[64] = c2v_64_in2[QUAN_SIZE-1:0];
assign hard_decision_65 = hard_decision[65];
assign ch_msg[65] = ch_msg_65[QUAN_SIZE-1:0];
assign v2c_65_out0[QUAN_SIZE-1:0] = v2c_0[65];
assign c2v_0[65] = c2v_65_in0[QUAN_SIZE-1:0];
assign v2c_65_out1[QUAN_SIZE-1:0] = v2c_1[65];
assign c2v_1[65] = c2v_65_in1[QUAN_SIZE-1:0];
assign v2c_65_out2[QUAN_SIZE-1:0] = v2c_2[65];
assign c2v_2[65] = c2v_65_in2[QUAN_SIZE-1:0];
assign hard_decision_66 = hard_decision[66];
assign ch_msg[66] = ch_msg_66[QUAN_SIZE-1:0];
assign v2c_66_out0[QUAN_SIZE-1:0] = v2c_0[66];
assign c2v_0[66] = c2v_66_in0[QUAN_SIZE-1:0];
assign v2c_66_out1[QUAN_SIZE-1:0] = v2c_1[66];
assign c2v_1[66] = c2v_66_in1[QUAN_SIZE-1:0];
assign v2c_66_out2[QUAN_SIZE-1:0] = v2c_2[66];
assign c2v_2[66] = c2v_66_in2[QUAN_SIZE-1:0];
assign hard_decision_67 = hard_decision[67];
assign ch_msg[67] = ch_msg_67[QUAN_SIZE-1:0];
assign v2c_67_out0[QUAN_SIZE-1:0] = v2c_0[67];
assign c2v_0[67] = c2v_67_in0[QUAN_SIZE-1:0];
assign v2c_67_out1[QUAN_SIZE-1:0] = v2c_1[67];
assign c2v_1[67] = c2v_67_in1[QUAN_SIZE-1:0];
assign v2c_67_out2[QUAN_SIZE-1:0] = v2c_2[67];
assign c2v_2[67] = c2v_67_in2[QUAN_SIZE-1:0];
assign hard_decision_68 = hard_decision[68];
assign ch_msg[68] = ch_msg_68[QUAN_SIZE-1:0];
assign v2c_68_out0[QUAN_SIZE-1:0] = v2c_0[68];
assign c2v_0[68] = c2v_68_in0[QUAN_SIZE-1:0];
assign v2c_68_out1[QUAN_SIZE-1:0] = v2c_1[68];
assign c2v_1[68] = c2v_68_in1[QUAN_SIZE-1:0];
assign v2c_68_out2[QUAN_SIZE-1:0] = v2c_2[68];
assign c2v_2[68] = c2v_68_in2[QUAN_SIZE-1:0];
assign hard_decision_69 = hard_decision[69];
assign ch_msg[69] = ch_msg_69[QUAN_SIZE-1:0];
assign v2c_69_out0[QUAN_SIZE-1:0] = v2c_0[69];
assign c2v_0[69] = c2v_69_in0[QUAN_SIZE-1:0];
assign v2c_69_out1[QUAN_SIZE-1:0] = v2c_1[69];
assign c2v_1[69] = c2v_69_in1[QUAN_SIZE-1:0];
assign v2c_69_out2[QUAN_SIZE-1:0] = v2c_2[69];
assign c2v_2[69] = c2v_69_in2[QUAN_SIZE-1:0];
assign hard_decision_70 = hard_decision[70];
assign ch_msg[70] = ch_msg_70[QUAN_SIZE-1:0];
assign v2c_70_out0[QUAN_SIZE-1:0] = v2c_0[70];
assign c2v_0[70] = c2v_70_in0[QUAN_SIZE-1:0];
assign v2c_70_out1[QUAN_SIZE-1:0] = v2c_1[70];
assign c2v_1[70] = c2v_70_in1[QUAN_SIZE-1:0];
assign v2c_70_out2[QUAN_SIZE-1:0] = v2c_2[70];
assign c2v_2[70] = c2v_70_in2[QUAN_SIZE-1:0];
assign hard_decision_71 = hard_decision[71];
assign ch_msg[71] = ch_msg_71[QUAN_SIZE-1:0];
assign v2c_71_out0[QUAN_SIZE-1:0] = v2c_0[71];
assign c2v_0[71] = c2v_71_in0[QUAN_SIZE-1:0];
assign v2c_71_out1[QUAN_SIZE-1:0] = v2c_1[71];
assign c2v_1[71] = c2v_71_in1[QUAN_SIZE-1:0];
assign v2c_71_out2[QUAN_SIZE-1:0] = v2c_2[71];
assign c2v_2[71] = c2v_71_in2[QUAN_SIZE-1:0];
assign hard_decision_72 = hard_decision[72];
assign ch_msg[72] = ch_msg_72[QUAN_SIZE-1:0];
assign v2c_72_out0[QUAN_SIZE-1:0] = v2c_0[72];
assign c2v_0[72] = c2v_72_in0[QUAN_SIZE-1:0];
assign v2c_72_out1[QUAN_SIZE-1:0] = v2c_1[72];
assign c2v_1[72] = c2v_72_in1[QUAN_SIZE-1:0];
assign v2c_72_out2[QUAN_SIZE-1:0] = v2c_2[72];
assign c2v_2[72] = c2v_72_in2[QUAN_SIZE-1:0];
assign hard_decision_73 = hard_decision[73];
assign ch_msg[73] = ch_msg_73[QUAN_SIZE-1:0];
assign v2c_73_out0[QUAN_SIZE-1:0] = v2c_0[73];
assign c2v_0[73] = c2v_73_in0[QUAN_SIZE-1:0];
assign v2c_73_out1[QUAN_SIZE-1:0] = v2c_1[73];
assign c2v_1[73] = c2v_73_in1[QUAN_SIZE-1:0];
assign v2c_73_out2[QUAN_SIZE-1:0] = v2c_2[73];
assign c2v_2[73] = c2v_73_in2[QUAN_SIZE-1:0];
assign hard_decision_74 = hard_decision[74];
assign ch_msg[74] = ch_msg_74[QUAN_SIZE-1:0];
assign v2c_74_out0[QUAN_SIZE-1:0] = v2c_0[74];
assign c2v_0[74] = c2v_74_in0[QUAN_SIZE-1:0];
assign v2c_74_out1[QUAN_SIZE-1:0] = v2c_1[74];
assign c2v_1[74] = c2v_74_in1[QUAN_SIZE-1:0];
assign v2c_74_out2[QUAN_SIZE-1:0] = v2c_2[74];
assign c2v_2[74] = c2v_74_in2[QUAN_SIZE-1:0];
assign hard_decision_75 = hard_decision[75];
assign ch_msg[75] = ch_msg_75[QUAN_SIZE-1:0];
assign v2c_75_out0[QUAN_SIZE-1:0] = v2c_0[75];
assign c2v_0[75] = c2v_75_in0[QUAN_SIZE-1:0];
assign v2c_75_out1[QUAN_SIZE-1:0] = v2c_1[75];
assign c2v_1[75] = c2v_75_in1[QUAN_SIZE-1:0];
assign v2c_75_out2[QUAN_SIZE-1:0] = v2c_2[75];
assign c2v_2[75] = c2v_75_in2[QUAN_SIZE-1:0];
assign hard_decision_76 = hard_decision[76];
assign ch_msg[76] = ch_msg_76[QUAN_SIZE-1:0];
assign v2c_76_out0[QUAN_SIZE-1:0] = v2c_0[76];
assign c2v_0[76] = c2v_76_in0[QUAN_SIZE-1:0];
assign v2c_76_out1[QUAN_SIZE-1:0] = v2c_1[76];
assign c2v_1[76] = c2v_76_in1[QUAN_SIZE-1:0];
assign v2c_76_out2[QUAN_SIZE-1:0] = v2c_2[76];
assign c2v_2[76] = c2v_76_in2[QUAN_SIZE-1:0];
assign hard_decision_77 = hard_decision[77];
assign ch_msg[77] = ch_msg_77[QUAN_SIZE-1:0];
assign v2c_77_out0[QUAN_SIZE-1:0] = v2c_0[77];
assign c2v_0[77] = c2v_77_in0[QUAN_SIZE-1:0];
assign v2c_77_out1[QUAN_SIZE-1:0] = v2c_1[77];
assign c2v_1[77] = c2v_77_in1[QUAN_SIZE-1:0];
assign v2c_77_out2[QUAN_SIZE-1:0] = v2c_2[77];
assign c2v_2[77] = c2v_77_in2[QUAN_SIZE-1:0];
assign hard_decision_78 = hard_decision[78];
assign ch_msg[78] = ch_msg_78[QUAN_SIZE-1:0];
assign v2c_78_out0[QUAN_SIZE-1:0] = v2c_0[78];
assign c2v_0[78] = c2v_78_in0[QUAN_SIZE-1:0];
assign v2c_78_out1[QUAN_SIZE-1:0] = v2c_1[78];
assign c2v_1[78] = c2v_78_in1[QUAN_SIZE-1:0];
assign v2c_78_out2[QUAN_SIZE-1:0] = v2c_2[78];
assign c2v_2[78] = c2v_78_in2[QUAN_SIZE-1:0];
assign hard_decision_79 = hard_decision[79];
assign ch_msg[79] = ch_msg_79[QUAN_SIZE-1:0];
assign v2c_79_out0[QUAN_SIZE-1:0] = v2c_0[79];
assign c2v_0[79] = c2v_79_in0[QUAN_SIZE-1:0];
assign v2c_79_out1[QUAN_SIZE-1:0] = v2c_1[79];
assign c2v_1[79] = c2v_79_in1[QUAN_SIZE-1:0];
assign v2c_79_out2[QUAN_SIZE-1:0] = v2c_2[79];
assign c2v_2[79] = c2v_79_in2[QUAN_SIZE-1:0];
assign hard_decision_80 = hard_decision[80];
assign ch_msg[80] = ch_msg_80[QUAN_SIZE-1:0];
assign v2c_80_out0[QUAN_SIZE-1:0] = v2c_0[80];
assign c2v_0[80] = c2v_80_in0[QUAN_SIZE-1:0];
assign v2c_80_out1[QUAN_SIZE-1:0] = v2c_1[80];
assign c2v_1[80] = c2v_80_in1[QUAN_SIZE-1:0];
assign v2c_80_out2[QUAN_SIZE-1:0] = v2c_2[80];
assign c2v_2[80] = c2v_80_in2[QUAN_SIZE-1:0];
assign hard_decision_81 = hard_decision[81];
assign ch_msg[81] = ch_msg_81[QUAN_SIZE-1:0];
assign v2c_81_out0[QUAN_SIZE-1:0] = v2c_0[81];
assign c2v_0[81] = c2v_81_in0[QUAN_SIZE-1:0];
assign v2c_81_out1[QUAN_SIZE-1:0] = v2c_1[81];
assign c2v_1[81] = c2v_81_in1[QUAN_SIZE-1:0];
assign v2c_81_out2[QUAN_SIZE-1:0] = v2c_2[81];
assign c2v_2[81] = c2v_81_in2[QUAN_SIZE-1:0];
assign hard_decision_82 = hard_decision[82];
assign ch_msg[82] = ch_msg_82[QUAN_SIZE-1:0];
assign v2c_82_out0[QUAN_SIZE-1:0] = v2c_0[82];
assign c2v_0[82] = c2v_82_in0[QUAN_SIZE-1:0];
assign v2c_82_out1[QUAN_SIZE-1:0] = v2c_1[82];
assign c2v_1[82] = c2v_82_in1[QUAN_SIZE-1:0];
assign v2c_82_out2[QUAN_SIZE-1:0] = v2c_2[82];
assign c2v_2[82] = c2v_82_in2[QUAN_SIZE-1:0];
assign hard_decision_83 = hard_decision[83];
assign ch_msg[83] = ch_msg_83[QUAN_SIZE-1:0];
assign v2c_83_out0[QUAN_SIZE-1:0] = v2c_0[83];
assign c2v_0[83] = c2v_83_in0[QUAN_SIZE-1:0];
assign v2c_83_out1[QUAN_SIZE-1:0] = v2c_1[83];
assign c2v_1[83] = c2v_83_in1[QUAN_SIZE-1:0];
assign v2c_83_out2[QUAN_SIZE-1:0] = v2c_2[83];
assign c2v_2[83] = c2v_83_in2[QUAN_SIZE-1:0];
assign hard_decision_84 = hard_decision[84];
assign ch_msg[84] = ch_msg_84[QUAN_SIZE-1:0];
assign v2c_84_out0[QUAN_SIZE-1:0] = v2c_0[84];
assign c2v_0[84] = c2v_84_in0[QUAN_SIZE-1:0];
assign v2c_84_out1[QUAN_SIZE-1:0] = v2c_1[84];
assign c2v_1[84] = c2v_84_in1[QUAN_SIZE-1:0];
assign v2c_84_out2[QUAN_SIZE-1:0] = v2c_2[84];
assign c2v_2[84] = c2v_84_in2[QUAN_SIZE-1:0];
assign hard_decision_85 = hard_decision[85];
assign ch_msg[85] = ch_msg_85[QUAN_SIZE-1:0];
assign v2c_85_out0[QUAN_SIZE-1:0] = v2c_0[85];
assign c2v_0[85] = c2v_85_in0[QUAN_SIZE-1:0];
assign v2c_85_out1[QUAN_SIZE-1:0] = v2c_1[85];
assign c2v_1[85] = c2v_85_in1[QUAN_SIZE-1:0];
assign v2c_85_out2[QUAN_SIZE-1:0] = v2c_2[85];
assign c2v_2[85] = c2v_85_in2[QUAN_SIZE-1:0];
assign hard_decision_86 = hard_decision[86];
assign ch_msg[86] = ch_msg_86[QUAN_SIZE-1:0];
assign v2c_86_out0[QUAN_SIZE-1:0] = v2c_0[86];
assign c2v_0[86] = c2v_86_in0[QUAN_SIZE-1:0];
assign v2c_86_out1[QUAN_SIZE-1:0] = v2c_1[86];
assign c2v_1[86] = c2v_86_in1[QUAN_SIZE-1:0];
assign v2c_86_out2[QUAN_SIZE-1:0] = v2c_2[86];
assign c2v_2[86] = c2v_86_in2[QUAN_SIZE-1:0];
assign hard_decision_87 = hard_decision[87];
assign ch_msg[87] = ch_msg_87[QUAN_SIZE-1:0];
assign v2c_87_out0[QUAN_SIZE-1:0] = v2c_0[87];
assign c2v_0[87] = c2v_87_in0[QUAN_SIZE-1:0];
assign v2c_87_out1[QUAN_SIZE-1:0] = v2c_1[87];
assign c2v_1[87] = c2v_87_in1[QUAN_SIZE-1:0];
assign v2c_87_out2[QUAN_SIZE-1:0] = v2c_2[87];
assign c2v_2[87] = c2v_87_in2[QUAN_SIZE-1:0];
assign hard_decision_88 = hard_decision[88];
assign ch_msg[88] = ch_msg_88[QUAN_SIZE-1:0];
assign v2c_88_out0[QUAN_SIZE-1:0] = v2c_0[88];
assign c2v_0[88] = c2v_88_in0[QUAN_SIZE-1:0];
assign v2c_88_out1[QUAN_SIZE-1:0] = v2c_1[88];
assign c2v_1[88] = c2v_88_in1[QUAN_SIZE-1:0];
assign v2c_88_out2[QUAN_SIZE-1:0] = v2c_2[88];
assign c2v_2[88] = c2v_88_in2[QUAN_SIZE-1:0];
assign hard_decision_89 = hard_decision[89];
assign ch_msg[89] = ch_msg_89[QUAN_SIZE-1:0];
assign v2c_89_out0[QUAN_SIZE-1:0] = v2c_0[89];
assign c2v_0[89] = c2v_89_in0[QUAN_SIZE-1:0];
assign v2c_89_out1[QUAN_SIZE-1:0] = v2c_1[89];
assign c2v_1[89] = c2v_89_in1[QUAN_SIZE-1:0];
assign v2c_89_out2[QUAN_SIZE-1:0] = v2c_2[89];
assign c2v_2[89] = c2v_89_in2[QUAN_SIZE-1:0];
assign hard_decision_90 = hard_decision[90];
assign ch_msg[90] = ch_msg_90[QUAN_SIZE-1:0];
assign v2c_90_out0[QUAN_SIZE-1:0] = v2c_0[90];
assign c2v_0[90] = c2v_90_in0[QUAN_SIZE-1:0];
assign v2c_90_out1[QUAN_SIZE-1:0] = v2c_1[90];
assign c2v_1[90] = c2v_90_in1[QUAN_SIZE-1:0];
assign v2c_90_out2[QUAN_SIZE-1:0] = v2c_2[90];
assign c2v_2[90] = c2v_90_in2[QUAN_SIZE-1:0];
assign hard_decision_91 = hard_decision[91];
assign ch_msg[91] = ch_msg_91[QUAN_SIZE-1:0];
assign v2c_91_out0[QUAN_SIZE-1:0] = v2c_0[91];
assign c2v_0[91] = c2v_91_in0[QUAN_SIZE-1:0];
assign v2c_91_out1[QUAN_SIZE-1:0] = v2c_1[91];
assign c2v_1[91] = c2v_91_in1[QUAN_SIZE-1:0];
assign v2c_91_out2[QUAN_SIZE-1:0] = v2c_2[91];
assign c2v_2[91] = c2v_91_in2[QUAN_SIZE-1:0];
assign hard_decision_92 = hard_decision[92];
assign ch_msg[92] = ch_msg_92[QUAN_SIZE-1:0];
assign v2c_92_out0[QUAN_SIZE-1:0] = v2c_0[92];
assign c2v_0[92] = c2v_92_in0[QUAN_SIZE-1:0];
assign v2c_92_out1[QUAN_SIZE-1:0] = v2c_1[92];
assign c2v_1[92] = c2v_92_in1[QUAN_SIZE-1:0];
assign v2c_92_out2[QUAN_SIZE-1:0] = v2c_2[92];
assign c2v_2[92] = c2v_92_in2[QUAN_SIZE-1:0];
assign hard_decision_93 = hard_decision[93];
assign ch_msg[93] = ch_msg_93[QUAN_SIZE-1:0];
assign v2c_93_out0[QUAN_SIZE-1:0] = v2c_0[93];
assign c2v_0[93] = c2v_93_in0[QUAN_SIZE-1:0];
assign v2c_93_out1[QUAN_SIZE-1:0] = v2c_1[93];
assign c2v_1[93] = c2v_93_in1[QUAN_SIZE-1:0];
assign v2c_93_out2[QUAN_SIZE-1:0] = v2c_2[93];
assign c2v_2[93] = c2v_93_in2[QUAN_SIZE-1:0];
assign hard_decision_94 = hard_decision[94];
assign ch_msg[94] = ch_msg_94[QUAN_SIZE-1:0];
assign v2c_94_out0[QUAN_SIZE-1:0] = v2c_0[94];
assign c2v_0[94] = c2v_94_in0[QUAN_SIZE-1:0];
assign v2c_94_out1[QUAN_SIZE-1:0] = v2c_1[94];
assign c2v_1[94] = c2v_94_in1[QUAN_SIZE-1:0];
assign v2c_94_out2[QUAN_SIZE-1:0] = v2c_2[94];
assign c2v_2[94] = c2v_94_in2[QUAN_SIZE-1:0];
assign hard_decision_95 = hard_decision[95];
assign ch_msg[95] = ch_msg_95[QUAN_SIZE-1:0];
assign v2c_95_out0[QUAN_SIZE-1:0] = v2c_0[95];
assign c2v_0[95] = c2v_95_in0[QUAN_SIZE-1:0];
assign v2c_95_out1[QUAN_SIZE-1:0] = v2c_1[95];
assign c2v_1[95] = c2v_95_in1[QUAN_SIZE-1:0];
assign v2c_95_out2[QUAN_SIZE-1:0] = v2c_2[95];
assign c2v_2[95] = c2v_95_in2[QUAN_SIZE-1:0];
assign hard_decision_96 = hard_decision[96];
assign ch_msg[96] = ch_msg_96[QUAN_SIZE-1:0];
assign v2c_96_out0[QUAN_SIZE-1:0] = v2c_0[96];
assign c2v_0[96] = c2v_96_in0[QUAN_SIZE-1:0];
assign v2c_96_out1[QUAN_SIZE-1:0] = v2c_1[96];
assign c2v_1[96] = c2v_96_in1[QUAN_SIZE-1:0];
assign v2c_96_out2[QUAN_SIZE-1:0] = v2c_2[96];
assign c2v_2[96] = c2v_96_in2[QUAN_SIZE-1:0];
assign hard_decision_97 = hard_decision[97];
assign ch_msg[97] = ch_msg_97[QUAN_SIZE-1:0];
assign v2c_97_out0[QUAN_SIZE-1:0] = v2c_0[97];
assign c2v_0[97] = c2v_97_in0[QUAN_SIZE-1:0];
assign v2c_97_out1[QUAN_SIZE-1:0] = v2c_1[97];
assign c2v_1[97] = c2v_97_in1[QUAN_SIZE-1:0];
assign v2c_97_out2[QUAN_SIZE-1:0] = v2c_2[97];
assign c2v_2[97] = c2v_97_in2[QUAN_SIZE-1:0];
assign hard_decision_98 = hard_decision[98];
assign ch_msg[98] = ch_msg_98[QUAN_SIZE-1:0];
assign v2c_98_out0[QUAN_SIZE-1:0] = v2c_0[98];
assign c2v_0[98] = c2v_98_in0[QUAN_SIZE-1:0];
assign v2c_98_out1[QUAN_SIZE-1:0] = v2c_1[98];
assign c2v_1[98] = c2v_98_in1[QUAN_SIZE-1:0];
assign v2c_98_out2[QUAN_SIZE-1:0] = v2c_2[98];
assign c2v_2[98] = c2v_98_in2[QUAN_SIZE-1:0];
assign hard_decision_99 = hard_decision[99];
assign ch_msg[99] = ch_msg_99[QUAN_SIZE-1:0];
assign v2c_99_out0[QUAN_SIZE-1:0] = v2c_0[99];
assign c2v_0[99] = c2v_99_in0[QUAN_SIZE-1:0];
assign v2c_99_out1[QUAN_SIZE-1:0] = v2c_1[99];
assign c2v_1[99] = c2v_99_in1[QUAN_SIZE-1:0];
assign v2c_99_out2[QUAN_SIZE-1:0] = v2c_2[99];
assign c2v_2[99] = c2v_99_in2[QUAN_SIZE-1:0];
assign hard_decision_100 = hard_decision[100];
assign ch_msg[100] = ch_msg_100[QUAN_SIZE-1:0];
assign v2c_100_out0[QUAN_SIZE-1:0] = v2c_0[100];
assign c2v_0[100] = c2v_100_in0[QUAN_SIZE-1:0];
assign v2c_100_out1[QUAN_SIZE-1:0] = v2c_1[100];
assign c2v_1[100] = c2v_100_in1[QUAN_SIZE-1:0];
assign v2c_100_out2[QUAN_SIZE-1:0] = v2c_2[100];
assign c2v_2[100] = c2v_100_in2[QUAN_SIZE-1:0];
assign hard_decision_101 = hard_decision[101];
assign ch_msg[101] = ch_msg_101[QUAN_SIZE-1:0];
assign v2c_101_out0[QUAN_SIZE-1:0] = v2c_0[101];
assign c2v_0[101] = c2v_101_in0[QUAN_SIZE-1:0];
assign v2c_101_out1[QUAN_SIZE-1:0] = v2c_1[101];
assign c2v_1[101] = c2v_101_in1[QUAN_SIZE-1:0];
assign v2c_101_out2[QUAN_SIZE-1:0] = v2c_2[101];
assign c2v_2[101] = c2v_101_in2[QUAN_SIZE-1:0];
assign hard_decision_102 = hard_decision[102];
assign ch_msg[102] = ch_msg_102[QUAN_SIZE-1:0];
assign v2c_102_out0[QUAN_SIZE-1:0] = v2c_0[102];
assign c2v_0[102] = c2v_102_in0[QUAN_SIZE-1:0];
assign v2c_102_out1[QUAN_SIZE-1:0] = v2c_1[102];
assign c2v_1[102] = c2v_102_in1[QUAN_SIZE-1:0];
assign v2c_102_out2[QUAN_SIZE-1:0] = v2c_2[102];
assign c2v_2[102] = c2v_102_in2[QUAN_SIZE-1:0];
assign hard_decision_103 = hard_decision[103];
assign ch_msg[103] = ch_msg_103[QUAN_SIZE-1:0];
assign v2c_103_out0[QUAN_SIZE-1:0] = v2c_0[103];
assign c2v_0[103] = c2v_103_in0[QUAN_SIZE-1:0];
assign v2c_103_out1[QUAN_SIZE-1:0] = v2c_1[103];
assign c2v_1[103] = c2v_103_in1[QUAN_SIZE-1:0];
assign v2c_103_out2[QUAN_SIZE-1:0] = v2c_2[103];
assign c2v_2[103] = c2v_103_in2[QUAN_SIZE-1:0];
assign hard_decision_104 = hard_decision[104];
assign ch_msg[104] = ch_msg_104[QUAN_SIZE-1:0];
assign v2c_104_out0[QUAN_SIZE-1:0] = v2c_0[104];
assign c2v_0[104] = c2v_104_in0[QUAN_SIZE-1:0];
assign v2c_104_out1[QUAN_SIZE-1:0] = v2c_1[104];
assign c2v_1[104] = c2v_104_in1[QUAN_SIZE-1:0];
assign v2c_104_out2[QUAN_SIZE-1:0] = v2c_2[104];
assign c2v_2[104] = c2v_104_in2[QUAN_SIZE-1:0];
assign hard_decision_105 = hard_decision[105];
assign ch_msg[105] = ch_msg_105[QUAN_SIZE-1:0];
assign v2c_105_out0[QUAN_SIZE-1:0] = v2c_0[105];
assign c2v_0[105] = c2v_105_in0[QUAN_SIZE-1:0];
assign v2c_105_out1[QUAN_SIZE-1:0] = v2c_1[105];
assign c2v_1[105] = c2v_105_in1[QUAN_SIZE-1:0];
assign v2c_105_out2[QUAN_SIZE-1:0] = v2c_2[105];
assign c2v_2[105] = c2v_105_in2[QUAN_SIZE-1:0];
assign hard_decision_106 = hard_decision[106];
assign ch_msg[106] = ch_msg_106[QUAN_SIZE-1:0];
assign v2c_106_out0[QUAN_SIZE-1:0] = v2c_0[106];
assign c2v_0[106] = c2v_106_in0[QUAN_SIZE-1:0];
assign v2c_106_out1[QUAN_SIZE-1:0] = v2c_1[106];
assign c2v_1[106] = c2v_106_in1[QUAN_SIZE-1:0];
assign v2c_106_out2[QUAN_SIZE-1:0] = v2c_2[106];
assign c2v_2[106] = c2v_106_in2[QUAN_SIZE-1:0];
assign hard_decision_107 = hard_decision[107];
assign ch_msg[107] = ch_msg_107[QUAN_SIZE-1:0];
assign v2c_107_out0[QUAN_SIZE-1:0] = v2c_0[107];
assign c2v_0[107] = c2v_107_in0[QUAN_SIZE-1:0];
assign v2c_107_out1[QUAN_SIZE-1:0] = v2c_1[107];
assign c2v_1[107] = c2v_107_in1[QUAN_SIZE-1:0];
assign v2c_107_out2[QUAN_SIZE-1:0] = v2c_2[107];
assign c2v_2[107] = c2v_107_in2[QUAN_SIZE-1:0];
assign hard_decision_108 = hard_decision[108];
assign ch_msg[108] = ch_msg_108[QUAN_SIZE-1:0];
assign v2c_108_out0[QUAN_SIZE-1:0] = v2c_0[108];
assign c2v_0[108] = c2v_108_in0[QUAN_SIZE-1:0];
assign v2c_108_out1[QUAN_SIZE-1:0] = v2c_1[108];
assign c2v_1[108] = c2v_108_in1[QUAN_SIZE-1:0];
assign v2c_108_out2[QUAN_SIZE-1:0] = v2c_2[108];
assign c2v_2[108] = c2v_108_in2[QUAN_SIZE-1:0];
assign hard_decision_109 = hard_decision[109];
assign ch_msg[109] = ch_msg_109[QUAN_SIZE-1:0];
assign v2c_109_out0[QUAN_SIZE-1:0] = v2c_0[109];
assign c2v_0[109] = c2v_109_in0[QUAN_SIZE-1:0];
assign v2c_109_out1[QUAN_SIZE-1:0] = v2c_1[109];
assign c2v_1[109] = c2v_109_in1[QUAN_SIZE-1:0];
assign v2c_109_out2[QUAN_SIZE-1:0] = v2c_2[109];
assign c2v_2[109] = c2v_109_in2[QUAN_SIZE-1:0];
assign hard_decision_110 = hard_decision[110];
assign ch_msg[110] = ch_msg_110[QUAN_SIZE-1:0];
assign v2c_110_out0[QUAN_SIZE-1:0] = v2c_0[110];
assign c2v_0[110] = c2v_110_in0[QUAN_SIZE-1:0];
assign v2c_110_out1[QUAN_SIZE-1:0] = v2c_1[110];
assign c2v_1[110] = c2v_110_in1[QUAN_SIZE-1:0];
assign v2c_110_out2[QUAN_SIZE-1:0] = v2c_2[110];
assign c2v_2[110] = c2v_110_in2[QUAN_SIZE-1:0];
assign hard_decision_111 = hard_decision[111];
assign ch_msg[111] = ch_msg_111[QUAN_SIZE-1:0];
assign v2c_111_out0[QUAN_SIZE-1:0] = v2c_0[111];
assign c2v_0[111] = c2v_111_in0[QUAN_SIZE-1:0];
assign v2c_111_out1[QUAN_SIZE-1:0] = v2c_1[111];
assign c2v_1[111] = c2v_111_in1[QUAN_SIZE-1:0];
assign v2c_111_out2[QUAN_SIZE-1:0] = v2c_2[111];
assign c2v_2[111] = c2v_111_in2[QUAN_SIZE-1:0];
assign hard_decision_112 = hard_decision[112];
assign ch_msg[112] = ch_msg_112[QUAN_SIZE-1:0];
assign v2c_112_out0[QUAN_SIZE-1:0] = v2c_0[112];
assign c2v_0[112] = c2v_112_in0[QUAN_SIZE-1:0];
assign v2c_112_out1[QUAN_SIZE-1:0] = v2c_1[112];
assign c2v_1[112] = c2v_112_in1[QUAN_SIZE-1:0];
assign v2c_112_out2[QUAN_SIZE-1:0] = v2c_2[112];
assign c2v_2[112] = c2v_112_in2[QUAN_SIZE-1:0];
assign hard_decision_113 = hard_decision[113];
assign ch_msg[113] = ch_msg_113[QUAN_SIZE-1:0];
assign v2c_113_out0[QUAN_SIZE-1:0] = v2c_0[113];
assign c2v_0[113] = c2v_113_in0[QUAN_SIZE-1:0];
assign v2c_113_out1[QUAN_SIZE-1:0] = v2c_1[113];
assign c2v_1[113] = c2v_113_in1[QUAN_SIZE-1:0];
assign v2c_113_out2[QUAN_SIZE-1:0] = v2c_2[113];
assign c2v_2[113] = c2v_113_in2[QUAN_SIZE-1:0];
assign hard_decision_114 = hard_decision[114];
assign ch_msg[114] = ch_msg_114[QUAN_SIZE-1:0];
assign v2c_114_out0[QUAN_SIZE-1:0] = v2c_0[114];
assign c2v_0[114] = c2v_114_in0[QUAN_SIZE-1:0];
assign v2c_114_out1[QUAN_SIZE-1:0] = v2c_1[114];
assign c2v_1[114] = c2v_114_in1[QUAN_SIZE-1:0];
assign v2c_114_out2[QUAN_SIZE-1:0] = v2c_2[114];
assign c2v_2[114] = c2v_114_in2[QUAN_SIZE-1:0];
assign hard_decision_115 = hard_decision[115];
assign ch_msg[115] = ch_msg_115[QUAN_SIZE-1:0];
assign v2c_115_out0[QUAN_SIZE-1:0] = v2c_0[115];
assign c2v_0[115] = c2v_115_in0[QUAN_SIZE-1:0];
assign v2c_115_out1[QUAN_SIZE-1:0] = v2c_1[115];
assign c2v_1[115] = c2v_115_in1[QUAN_SIZE-1:0];
assign v2c_115_out2[QUAN_SIZE-1:0] = v2c_2[115];
assign c2v_2[115] = c2v_115_in2[QUAN_SIZE-1:0];
assign hard_decision_116 = hard_decision[116];
assign ch_msg[116] = ch_msg_116[QUAN_SIZE-1:0];
assign v2c_116_out0[QUAN_SIZE-1:0] = v2c_0[116];
assign c2v_0[116] = c2v_116_in0[QUAN_SIZE-1:0];
assign v2c_116_out1[QUAN_SIZE-1:0] = v2c_1[116];
assign c2v_1[116] = c2v_116_in1[QUAN_SIZE-1:0];
assign v2c_116_out2[QUAN_SIZE-1:0] = v2c_2[116];
assign c2v_2[116] = c2v_116_in2[QUAN_SIZE-1:0];
assign hard_decision_117 = hard_decision[117];
assign ch_msg[117] = ch_msg_117[QUAN_SIZE-1:0];
assign v2c_117_out0[QUAN_SIZE-1:0] = v2c_0[117];
assign c2v_0[117] = c2v_117_in0[QUAN_SIZE-1:0];
assign v2c_117_out1[QUAN_SIZE-1:0] = v2c_1[117];
assign c2v_1[117] = c2v_117_in1[QUAN_SIZE-1:0];
assign v2c_117_out2[QUAN_SIZE-1:0] = v2c_2[117];
assign c2v_2[117] = c2v_117_in2[QUAN_SIZE-1:0];
assign hard_decision_118 = hard_decision[118];
assign ch_msg[118] = ch_msg_118[QUAN_SIZE-1:0];
assign v2c_118_out0[QUAN_SIZE-1:0] = v2c_0[118];
assign c2v_0[118] = c2v_118_in0[QUAN_SIZE-1:0];
assign v2c_118_out1[QUAN_SIZE-1:0] = v2c_1[118];
assign c2v_1[118] = c2v_118_in1[QUAN_SIZE-1:0];
assign v2c_118_out2[QUAN_SIZE-1:0] = v2c_2[118];
assign c2v_2[118] = c2v_118_in2[QUAN_SIZE-1:0];
assign hard_decision_119 = hard_decision[119];
assign ch_msg[119] = ch_msg_119[QUAN_SIZE-1:0];
assign v2c_119_out0[QUAN_SIZE-1:0] = v2c_0[119];
assign c2v_0[119] = c2v_119_in0[QUAN_SIZE-1:0];
assign v2c_119_out1[QUAN_SIZE-1:0] = v2c_1[119];
assign c2v_1[119] = c2v_119_in1[QUAN_SIZE-1:0];
assign v2c_119_out2[QUAN_SIZE-1:0] = v2c_2[119];
assign c2v_2[119] = c2v_119_in2[QUAN_SIZE-1:0];
assign hard_decision_120 = hard_decision[120];
assign ch_msg[120] = ch_msg_120[QUAN_SIZE-1:0];
assign v2c_120_out0[QUAN_SIZE-1:0] = v2c_0[120];
assign c2v_0[120] = c2v_120_in0[QUAN_SIZE-1:0];
assign v2c_120_out1[QUAN_SIZE-1:0] = v2c_1[120];
assign c2v_1[120] = c2v_120_in1[QUAN_SIZE-1:0];
assign v2c_120_out2[QUAN_SIZE-1:0] = v2c_2[120];
assign c2v_2[120] = c2v_120_in2[QUAN_SIZE-1:0];
assign hard_decision_121 = hard_decision[121];
assign ch_msg[121] = ch_msg_121[QUAN_SIZE-1:0];
assign v2c_121_out0[QUAN_SIZE-1:0] = v2c_0[121];
assign c2v_0[121] = c2v_121_in0[QUAN_SIZE-1:0];
assign v2c_121_out1[QUAN_SIZE-1:0] = v2c_1[121];
assign c2v_1[121] = c2v_121_in1[QUAN_SIZE-1:0];
assign v2c_121_out2[QUAN_SIZE-1:0] = v2c_2[121];
assign c2v_2[121] = c2v_121_in2[QUAN_SIZE-1:0];
assign hard_decision_122 = hard_decision[122];
assign ch_msg[122] = ch_msg_122[QUAN_SIZE-1:0];
assign v2c_122_out0[QUAN_SIZE-1:0] = v2c_0[122];
assign c2v_0[122] = c2v_122_in0[QUAN_SIZE-1:0];
assign v2c_122_out1[QUAN_SIZE-1:0] = v2c_1[122];
assign c2v_1[122] = c2v_122_in1[QUAN_SIZE-1:0];
assign v2c_122_out2[QUAN_SIZE-1:0] = v2c_2[122];
assign c2v_2[122] = c2v_122_in2[QUAN_SIZE-1:0];
assign hard_decision_123 = hard_decision[123];
assign ch_msg[123] = ch_msg_123[QUAN_SIZE-1:0];
assign v2c_123_out0[QUAN_SIZE-1:0] = v2c_0[123];
assign c2v_0[123] = c2v_123_in0[QUAN_SIZE-1:0];
assign v2c_123_out1[QUAN_SIZE-1:0] = v2c_1[123];
assign c2v_1[123] = c2v_123_in1[QUAN_SIZE-1:0];
assign v2c_123_out2[QUAN_SIZE-1:0] = v2c_2[123];
assign c2v_2[123] = c2v_123_in2[QUAN_SIZE-1:0];
assign hard_decision_124 = hard_decision[124];
assign ch_msg[124] = ch_msg_124[QUAN_SIZE-1:0];
assign v2c_124_out0[QUAN_SIZE-1:0] = v2c_0[124];
assign c2v_0[124] = c2v_124_in0[QUAN_SIZE-1:0];
assign v2c_124_out1[QUAN_SIZE-1:0] = v2c_1[124];
assign c2v_1[124] = c2v_124_in1[QUAN_SIZE-1:0];
assign v2c_124_out2[QUAN_SIZE-1:0] = v2c_2[124];
assign c2v_2[124] = c2v_124_in2[QUAN_SIZE-1:0];
assign hard_decision_125 = hard_decision[125];
assign ch_msg[125] = ch_msg_125[QUAN_SIZE-1:0];
assign v2c_125_out0[QUAN_SIZE-1:0] = v2c_0[125];
assign c2v_0[125] = c2v_125_in0[QUAN_SIZE-1:0];
assign v2c_125_out1[QUAN_SIZE-1:0] = v2c_1[125];
assign c2v_1[125] = c2v_125_in1[QUAN_SIZE-1:0];
assign v2c_125_out2[QUAN_SIZE-1:0] = v2c_2[125];
assign c2v_2[125] = c2v_125_in2[QUAN_SIZE-1:0];
assign hard_decision_126 = hard_decision[126];
assign ch_msg[126] = ch_msg_126[QUAN_SIZE-1:0];
assign v2c_126_out0[QUAN_SIZE-1:0] = v2c_0[126];
assign c2v_0[126] = c2v_126_in0[QUAN_SIZE-1:0];
assign v2c_126_out1[QUAN_SIZE-1:0] = v2c_1[126];
assign c2v_1[126] = c2v_126_in1[QUAN_SIZE-1:0];
assign v2c_126_out2[QUAN_SIZE-1:0] = v2c_2[126];
assign c2v_2[126] = c2v_126_in2[QUAN_SIZE-1:0];
assign hard_decision_127 = hard_decision[127];
assign ch_msg[127] = ch_msg_127[QUAN_SIZE-1:0];
assign v2c_127_out0[QUAN_SIZE-1:0] = v2c_0[127];
assign c2v_0[127] = c2v_127_in0[QUAN_SIZE-1:0];
assign v2c_127_out1[QUAN_SIZE-1:0] = v2c_1[127];
assign c2v_1[127] = c2v_127_in1[QUAN_SIZE-1:0];
assign v2c_127_out2[QUAN_SIZE-1:0] = v2c_2[127];
assign c2v_2[127] = c2v_127_in2[QUAN_SIZE-1:0];
assign hard_decision_128 = hard_decision[128];
assign ch_msg[128] = ch_msg_128[QUAN_SIZE-1:0];
assign v2c_128_out0[QUAN_SIZE-1:0] = v2c_0[128];
assign c2v_0[128] = c2v_128_in0[QUAN_SIZE-1:0];
assign v2c_128_out1[QUAN_SIZE-1:0] = v2c_1[128];
assign c2v_1[128] = c2v_128_in1[QUAN_SIZE-1:0];
assign v2c_128_out2[QUAN_SIZE-1:0] = v2c_2[128];
assign c2v_2[128] = c2v_128_in2[QUAN_SIZE-1:0];
assign hard_decision_129 = hard_decision[129];
assign ch_msg[129] = ch_msg_129[QUAN_SIZE-1:0];
assign v2c_129_out0[QUAN_SIZE-1:0] = v2c_0[129];
assign c2v_0[129] = c2v_129_in0[QUAN_SIZE-1:0];
assign v2c_129_out1[QUAN_SIZE-1:0] = v2c_1[129];
assign c2v_1[129] = c2v_129_in1[QUAN_SIZE-1:0];
assign v2c_129_out2[QUAN_SIZE-1:0] = v2c_2[129];
assign c2v_2[129] = c2v_129_in2[QUAN_SIZE-1:0];
assign hard_decision_130 = hard_decision[130];
assign ch_msg[130] = ch_msg_130[QUAN_SIZE-1:0];
assign v2c_130_out0[QUAN_SIZE-1:0] = v2c_0[130];
assign c2v_0[130] = c2v_130_in0[QUAN_SIZE-1:0];
assign v2c_130_out1[QUAN_SIZE-1:0] = v2c_1[130];
assign c2v_1[130] = c2v_130_in1[QUAN_SIZE-1:0];
assign v2c_130_out2[QUAN_SIZE-1:0] = v2c_2[130];
assign c2v_2[130] = c2v_130_in2[QUAN_SIZE-1:0];
assign hard_decision_131 = hard_decision[131];
assign ch_msg[131] = ch_msg_131[QUAN_SIZE-1:0];
assign v2c_131_out0[QUAN_SIZE-1:0] = v2c_0[131];
assign c2v_0[131] = c2v_131_in0[QUAN_SIZE-1:0];
assign v2c_131_out1[QUAN_SIZE-1:0] = v2c_1[131];
assign c2v_1[131] = c2v_131_in1[QUAN_SIZE-1:0];
assign v2c_131_out2[QUAN_SIZE-1:0] = v2c_2[131];
assign c2v_2[131] = c2v_131_in2[QUAN_SIZE-1:0];
assign hard_decision_132 = hard_decision[132];
assign ch_msg[132] = ch_msg_132[QUAN_SIZE-1:0];
assign v2c_132_out0[QUAN_SIZE-1:0] = v2c_0[132];
assign c2v_0[132] = c2v_132_in0[QUAN_SIZE-1:0];
assign v2c_132_out1[QUAN_SIZE-1:0] = v2c_1[132];
assign c2v_1[132] = c2v_132_in1[QUAN_SIZE-1:0];
assign v2c_132_out2[QUAN_SIZE-1:0] = v2c_2[132];
assign c2v_2[132] = c2v_132_in2[QUAN_SIZE-1:0];
assign hard_decision_133 = hard_decision[133];
assign ch_msg[133] = ch_msg_133[QUAN_SIZE-1:0];
assign v2c_133_out0[QUAN_SIZE-1:0] = v2c_0[133];
assign c2v_0[133] = c2v_133_in0[QUAN_SIZE-1:0];
assign v2c_133_out1[QUAN_SIZE-1:0] = v2c_1[133];
assign c2v_1[133] = c2v_133_in1[QUAN_SIZE-1:0];
assign v2c_133_out2[QUAN_SIZE-1:0] = v2c_2[133];
assign c2v_2[133] = c2v_133_in2[QUAN_SIZE-1:0];
assign hard_decision_134 = hard_decision[134];
assign ch_msg[134] = ch_msg_134[QUAN_SIZE-1:0];
assign v2c_134_out0[QUAN_SIZE-1:0] = v2c_0[134];
assign c2v_0[134] = c2v_134_in0[QUAN_SIZE-1:0];
assign v2c_134_out1[QUAN_SIZE-1:0] = v2c_1[134];
assign c2v_1[134] = c2v_134_in1[QUAN_SIZE-1:0];
assign v2c_134_out2[QUAN_SIZE-1:0] = v2c_2[134];
assign c2v_2[134] = c2v_134_in2[QUAN_SIZE-1:0];
assign hard_decision_135 = hard_decision[135];
assign ch_msg[135] = ch_msg_135[QUAN_SIZE-1:0];
assign v2c_135_out0[QUAN_SIZE-1:0] = v2c_0[135];
assign c2v_0[135] = c2v_135_in0[QUAN_SIZE-1:0];
assign v2c_135_out1[QUAN_SIZE-1:0] = v2c_1[135];
assign c2v_1[135] = c2v_135_in1[QUAN_SIZE-1:0];
assign v2c_135_out2[QUAN_SIZE-1:0] = v2c_2[135];
assign c2v_2[135] = c2v_135_in2[QUAN_SIZE-1:0];
assign hard_decision_136 = hard_decision[136];
assign ch_msg[136] = ch_msg_136[QUAN_SIZE-1:0];
assign v2c_136_out0[QUAN_SIZE-1:0] = v2c_0[136];
assign c2v_0[136] = c2v_136_in0[QUAN_SIZE-1:0];
assign v2c_136_out1[QUAN_SIZE-1:0] = v2c_1[136];
assign c2v_1[136] = c2v_136_in1[QUAN_SIZE-1:0];
assign v2c_136_out2[QUAN_SIZE-1:0] = v2c_2[136];
assign c2v_2[136] = c2v_136_in2[QUAN_SIZE-1:0];
assign hard_decision_137 = hard_decision[137];
assign ch_msg[137] = ch_msg_137[QUAN_SIZE-1:0];
assign v2c_137_out0[QUAN_SIZE-1:0] = v2c_0[137];
assign c2v_0[137] = c2v_137_in0[QUAN_SIZE-1:0];
assign v2c_137_out1[QUAN_SIZE-1:0] = v2c_1[137];
assign c2v_1[137] = c2v_137_in1[QUAN_SIZE-1:0];
assign v2c_137_out2[QUAN_SIZE-1:0] = v2c_2[137];
assign c2v_2[137] = c2v_137_in2[QUAN_SIZE-1:0];
assign hard_decision_138 = hard_decision[138];
assign ch_msg[138] = ch_msg_138[QUAN_SIZE-1:0];
assign v2c_138_out0[QUAN_SIZE-1:0] = v2c_0[138];
assign c2v_0[138] = c2v_138_in0[QUAN_SIZE-1:0];
assign v2c_138_out1[QUAN_SIZE-1:0] = v2c_1[138];
assign c2v_1[138] = c2v_138_in1[QUAN_SIZE-1:0];
assign v2c_138_out2[QUAN_SIZE-1:0] = v2c_2[138];
assign c2v_2[138] = c2v_138_in2[QUAN_SIZE-1:0];
assign hard_decision_139 = hard_decision[139];
assign ch_msg[139] = ch_msg_139[QUAN_SIZE-1:0];
assign v2c_139_out0[QUAN_SIZE-1:0] = v2c_0[139];
assign c2v_0[139] = c2v_139_in0[QUAN_SIZE-1:0];
assign v2c_139_out1[QUAN_SIZE-1:0] = v2c_1[139];
assign c2v_1[139] = c2v_139_in1[QUAN_SIZE-1:0];
assign v2c_139_out2[QUAN_SIZE-1:0] = v2c_2[139];
assign c2v_2[139] = c2v_139_in2[QUAN_SIZE-1:0];
assign hard_decision_140 = hard_decision[140];
assign ch_msg[140] = ch_msg_140[QUAN_SIZE-1:0];
assign v2c_140_out0[QUAN_SIZE-1:0] = v2c_0[140];
assign c2v_0[140] = c2v_140_in0[QUAN_SIZE-1:0];
assign v2c_140_out1[QUAN_SIZE-1:0] = v2c_1[140];
assign c2v_1[140] = c2v_140_in1[QUAN_SIZE-1:0];
assign v2c_140_out2[QUAN_SIZE-1:0] = v2c_2[140];
assign c2v_2[140] = c2v_140_in2[QUAN_SIZE-1:0];
assign hard_decision_141 = hard_decision[141];
assign ch_msg[141] = ch_msg_141[QUAN_SIZE-1:0];
assign v2c_141_out0[QUAN_SIZE-1:0] = v2c_0[141];
assign c2v_0[141] = c2v_141_in0[QUAN_SIZE-1:0];
assign v2c_141_out1[QUAN_SIZE-1:0] = v2c_1[141];
assign c2v_1[141] = c2v_141_in1[QUAN_SIZE-1:0];
assign v2c_141_out2[QUAN_SIZE-1:0] = v2c_2[141];
assign c2v_2[141] = c2v_141_in2[QUAN_SIZE-1:0];
assign hard_decision_142 = hard_decision[142];
assign ch_msg[142] = ch_msg_142[QUAN_SIZE-1:0];
assign v2c_142_out0[QUAN_SIZE-1:0] = v2c_0[142];
assign c2v_0[142] = c2v_142_in0[QUAN_SIZE-1:0];
assign v2c_142_out1[QUAN_SIZE-1:0] = v2c_1[142];
assign c2v_1[142] = c2v_142_in1[QUAN_SIZE-1:0];
assign v2c_142_out2[QUAN_SIZE-1:0] = v2c_2[142];
assign c2v_2[142] = c2v_142_in2[QUAN_SIZE-1:0];
assign hard_decision_143 = hard_decision[143];
assign ch_msg[143] = ch_msg_143[QUAN_SIZE-1:0];
assign v2c_143_out0[QUAN_SIZE-1:0] = v2c_0[143];
assign c2v_0[143] = c2v_143_in0[QUAN_SIZE-1:0];
assign v2c_143_out1[QUAN_SIZE-1:0] = v2c_1[143];
assign c2v_1[143] = c2v_143_in1[QUAN_SIZE-1:0];
assign v2c_143_out2[QUAN_SIZE-1:0] = v2c_2[143];
assign c2v_2[143] = c2v_143_in2[QUAN_SIZE-1:0];
assign hard_decision_144 = hard_decision[144];
assign ch_msg[144] = ch_msg_144[QUAN_SIZE-1:0];
assign v2c_144_out0[QUAN_SIZE-1:0] = v2c_0[144];
assign c2v_0[144] = c2v_144_in0[QUAN_SIZE-1:0];
assign v2c_144_out1[QUAN_SIZE-1:0] = v2c_1[144];
assign c2v_1[144] = c2v_144_in1[QUAN_SIZE-1:0];
assign v2c_144_out2[QUAN_SIZE-1:0] = v2c_2[144];
assign c2v_2[144] = c2v_144_in2[QUAN_SIZE-1:0];
assign hard_decision_145 = hard_decision[145];
assign ch_msg[145] = ch_msg_145[QUAN_SIZE-1:0];
assign v2c_145_out0[QUAN_SIZE-1:0] = v2c_0[145];
assign c2v_0[145] = c2v_145_in0[QUAN_SIZE-1:0];
assign v2c_145_out1[QUAN_SIZE-1:0] = v2c_1[145];
assign c2v_1[145] = c2v_145_in1[QUAN_SIZE-1:0];
assign v2c_145_out2[QUAN_SIZE-1:0] = v2c_2[145];
assign c2v_2[145] = c2v_145_in2[QUAN_SIZE-1:0];
assign hard_decision_146 = hard_decision[146];
assign ch_msg[146] = ch_msg_146[QUAN_SIZE-1:0];
assign v2c_146_out0[QUAN_SIZE-1:0] = v2c_0[146];
assign c2v_0[146] = c2v_146_in0[QUAN_SIZE-1:0];
assign v2c_146_out1[QUAN_SIZE-1:0] = v2c_1[146];
assign c2v_1[146] = c2v_146_in1[QUAN_SIZE-1:0];
assign v2c_146_out2[QUAN_SIZE-1:0] = v2c_2[146];
assign c2v_2[146] = c2v_146_in2[QUAN_SIZE-1:0];
assign hard_decision_147 = hard_decision[147];
assign ch_msg[147] = ch_msg_147[QUAN_SIZE-1:0];
assign v2c_147_out0[QUAN_SIZE-1:0] = v2c_0[147];
assign c2v_0[147] = c2v_147_in0[QUAN_SIZE-1:0];
assign v2c_147_out1[QUAN_SIZE-1:0] = v2c_1[147];
assign c2v_1[147] = c2v_147_in1[QUAN_SIZE-1:0];
assign v2c_147_out2[QUAN_SIZE-1:0] = v2c_2[147];
assign c2v_2[147] = c2v_147_in2[QUAN_SIZE-1:0];
assign hard_decision_148 = hard_decision[148];
assign ch_msg[148] = ch_msg_148[QUAN_SIZE-1:0];
assign v2c_148_out0[QUAN_SIZE-1:0] = v2c_0[148];
assign c2v_0[148] = c2v_148_in0[QUAN_SIZE-1:0];
assign v2c_148_out1[QUAN_SIZE-1:0] = v2c_1[148];
assign c2v_1[148] = c2v_148_in1[QUAN_SIZE-1:0];
assign v2c_148_out2[QUAN_SIZE-1:0] = v2c_2[148];
assign c2v_2[148] = c2v_148_in2[QUAN_SIZE-1:0];
assign hard_decision_149 = hard_decision[149];
assign ch_msg[149] = ch_msg_149[QUAN_SIZE-1:0];
assign v2c_149_out0[QUAN_SIZE-1:0] = v2c_0[149];
assign c2v_0[149] = c2v_149_in0[QUAN_SIZE-1:0];
assign v2c_149_out1[QUAN_SIZE-1:0] = v2c_1[149];
assign c2v_1[149] = c2v_149_in1[QUAN_SIZE-1:0];
assign v2c_149_out2[QUAN_SIZE-1:0] = v2c_2[149];
assign c2v_2[149] = c2v_149_in2[QUAN_SIZE-1:0];
assign hard_decision_150 = hard_decision[150];
assign ch_msg[150] = ch_msg_150[QUAN_SIZE-1:0];
assign v2c_150_out0[QUAN_SIZE-1:0] = v2c_0[150];
assign c2v_0[150] = c2v_150_in0[QUAN_SIZE-1:0];
assign v2c_150_out1[QUAN_SIZE-1:0] = v2c_1[150];
assign c2v_1[150] = c2v_150_in1[QUAN_SIZE-1:0];
assign v2c_150_out2[QUAN_SIZE-1:0] = v2c_2[150];
assign c2v_2[150] = c2v_150_in2[QUAN_SIZE-1:0];
assign hard_decision_151 = hard_decision[151];
assign ch_msg[151] = ch_msg_151[QUAN_SIZE-1:0];
assign v2c_151_out0[QUAN_SIZE-1:0] = v2c_0[151];
assign c2v_0[151] = c2v_151_in0[QUAN_SIZE-1:0];
assign v2c_151_out1[QUAN_SIZE-1:0] = v2c_1[151];
assign c2v_1[151] = c2v_151_in1[QUAN_SIZE-1:0];
assign v2c_151_out2[QUAN_SIZE-1:0] = v2c_2[151];
assign c2v_2[151] = c2v_151_in2[QUAN_SIZE-1:0];
assign hard_decision_152 = hard_decision[152];
assign ch_msg[152] = ch_msg_152[QUAN_SIZE-1:0];
assign v2c_152_out0[QUAN_SIZE-1:0] = v2c_0[152];
assign c2v_0[152] = c2v_152_in0[QUAN_SIZE-1:0];
assign v2c_152_out1[QUAN_SIZE-1:0] = v2c_1[152];
assign c2v_1[152] = c2v_152_in1[QUAN_SIZE-1:0];
assign v2c_152_out2[QUAN_SIZE-1:0] = v2c_2[152];
assign c2v_2[152] = c2v_152_in2[QUAN_SIZE-1:0];
assign hard_decision_153 = hard_decision[153];
assign ch_msg[153] = ch_msg_153[QUAN_SIZE-1:0];
assign v2c_153_out0[QUAN_SIZE-1:0] = v2c_0[153];
assign c2v_0[153] = c2v_153_in0[QUAN_SIZE-1:0];
assign v2c_153_out1[QUAN_SIZE-1:0] = v2c_1[153];
assign c2v_1[153] = c2v_153_in1[QUAN_SIZE-1:0];
assign v2c_153_out2[QUAN_SIZE-1:0] = v2c_2[153];
assign c2v_2[153] = c2v_153_in2[QUAN_SIZE-1:0];
assign hard_decision_154 = hard_decision[154];
assign ch_msg[154] = ch_msg_154[QUAN_SIZE-1:0];
assign v2c_154_out0[QUAN_SIZE-1:0] = v2c_0[154];
assign c2v_0[154] = c2v_154_in0[QUAN_SIZE-1:0];
assign v2c_154_out1[QUAN_SIZE-1:0] = v2c_1[154];
assign c2v_1[154] = c2v_154_in1[QUAN_SIZE-1:0];
assign v2c_154_out2[QUAN_SIZE-1:0] = v2c_2[154];
assign c2v_2[154] = c2v_154_in2[QUAN_SIZE-1:0];
assign hard_decision_155 = hard_decision[155];
assign ch_msg[155] = ch_msg_155[QUAN_SIZE-1:0];
assign v2c_155_out0[QUAN_SIZE-1:0] = v2c_0[155];
assign c2v_0[155] = c2v_155_in0[QUAN_SIZE-1:0];
assign v2c_155_out1[QUAN_SIZE-1:0] = v2c_1[155];
assign c2v_1[155] = c2v_155_in1[QUAN_SIZE-1:0];
assign v2c_155_out2[QUAN_SIZE-1:0] = v2c_2[155];
assign c2v_2[155] = c2v_155_in2[QUAN_SIZE-1:0];
assign hard_decision_156 = hard_decision[156];
assign ch_msg[156] = ch_msg_156[QUAN_SIZE-1:0];
assign v2c_156_out0[QUAN_SIZE-1:0] = v2c_0[156];
assign c2v_0[156] = c2v_156_in0[QUAN_SIZE-1:0];
assign v2c_156_out1[QUAN_SIZE-1:0] = v2c_1[156];
assign c2v_1[156] = c2v_156_in1[QUAN_SIZE-1:0];
assign v2c_156_out2[QUAN_SIZE-1:0] = v2c_2[156];
assign c2v_2[156] = c2v_156_in2[QUAN_SIZE-1:0];
assign hard_decision_157 = hard_decision[157];
assign ch_msg[157] = ch_msg_157[QUAN_SIZE-1:0];
assign v2c_157_out0[QUAN_SIZE-1:0] = v2c_0[157];
assign c2v_0[157] = c2v_157_in0[QUAN_SIZE-1:0];
assign v2c_157_out1[QUAN_SIZE-1:0] = v2c_1[157];
assign c2v_1[157] = c2v_157_in1[QUAN_SIZE-1:0];
assign v2c_157_out2[QUAN_SIZE-1:0] = v2c_2[157];
assign c2v_2[157] = c2v_157_in2[QUAN_SIZE-1:0];
assign hard_decision_158 = hard_decision[158];
assign ch_msg[158] = ch_msg_158[QUAN_SIZE-1:0];
assign v2c_158_out0[QUAN_SIZE-1:0] = v2c_0[158];
assign c2v_0[158] = c2v_158_in0[QUAN_SIZE-1:0];
assign v2c_158_out1[QUAN_SIZE-1:0] = v2c_1[158];
assign c2v_1[158] = c2v_158_in1[QUAN_SIZE-1:0];
assign v2c_158_out2[QUAN_SIZE-1:0] = v2c_2[158];
assign c2v_2[158] = c2v_158_in2[QUAN_SIZE-1:0];
assign hard_decision_159 = hard_decision[159];
assign ch_msg[159] = ch_msg_159[QUAN_SIZE-1:0];
assign v2c_159_out0[QUAN_SIZE-1:0] = v2c_0[159];
assign c2v_0[159] = c2v_159_in0[QUAN_SIZE-1:0];
assign v2c_159_out1[QUAN_SIZE-1:0] = v2c_1[159];
assign c2v_1[159] = c2v_159_in1[QUAN_SIZE-1:0];
assign v2c_159_out2[QUAN_SIZE-1:0] = v2c_2[159];
assign c2v_2[159] = c2v_159_in2[QUAN_SIZE-1:0];
assign hard_decision_160 = hard_decision[160];
assign ch_msg[160] = ch_msg_160[QUAN_SIZE-1:0];
assign v2c_160_out0[QUAN_SIZE-1:0] = v2c_0[160];
assign c2v_0[160] = c2v_160_in0[QUAN_SIZE-1:0];
assign v2c_160_out1[QUAN_SIZE-1:0] = v2c_1[160];
assign c2v_1[160] = c2v_160_in1[QUAN_SIZE-1:0];
assign v2c_160_out2[QUAN_SIZE-1:0] = v2c_2[160];
assign c2v_2[160] = c2v_160_in2[QUAN_SIZE-1:0];
assign hard_decision_161 = hard_decision[161];
assign ch_msg[161] = ch_msg_161[QUAN_SIZE-1:0];
assign v2c_161_out0[QUAN_SIZE-1:0] = v2c_0[161];
assign c2v_0[161] = c2v_161_in0[QUAN_SIZE-1:0];
assign v2c_161_out1[QUAN_SIZE-1:0] = v2c_1[161];
assign c2v_1[161] = c2v_161_in1[QUAN_SIZE-1:0];
assign v2c_161_out2[QUAN_SIZE-1:0] = v2c_2[161];
assign c2v_2[161] = c2v_161_in2[QUAN_SIZE-1:0];
assign hard_decision_162 = hard_decision[162];
assign ch_msg[162] = ch_msg_162[QUAN_SIZE-1:0];
assign v2c_162_out0[QUAN_SIZE-1:0] = v2c_0[162];
assign c2v_0[162] = c2v_162_in0[QUAN_SIZE-1:0];
assign v2c_162_out1[QUAN_SIZE-1:0] = v2c_1[162];
assign c2v_1[162] = c2v_162_in1[QUAN_SIZE-1:0];
assign v2c_162_out2[QUAN_SIZE-1:0] = v2c_2[162];
assign c2v_2[162] = c2v_162_in2[QUAN_SIZE-1:0];
assign hard_decision_163 = hard_decision[163];
assign ch_msg[163] = ch_msg_163[QUAN_SIZE-1:0];
assign v2c_163_out0[QUAN_SIZE-1:0] = v2c_0[163];
assign c2v_0[163] = c2v_163_in0[QUAN_SIZE-1:0];
assign v2c_163_out1[QUAN_SIZE-1:0] = v2c_1[163];
assign c2v_1[163] = c2v_163_in1[QUAN_SIZE-1:0];
assign v2c_163_out2[QUAN_SIZE-1:0] = v2c_2[163];
assign c2v_2[163] = c2v_163_in2[QUAN_SIZE-1:0];
assign hard_decision_164 = hard_decision[164];
assign ch_msg[164] = ch_msg_164[QUAN_SIZE-1:0];
assign v2c_164_out0[QUAN_SIZE-1:0] = v2c_0[164];
assign c2v_0[164] = c2v_164_in0[QUAN_SIZE-1:0];
assign v2c_164_out1[QUAN_SIZE-1:0] = v2c_1[164];
assign c2v_1[164] = c2v_164_in1[QUAN_SIZE-1:0];
assign v2c_164_out2[QUAN_SIZE-1:0] = v2c_2[164];
assign c2v_2[164] = c2v_164_in2[QUAN_SIZE-1:0];
assign hard_decision_165 = hard_decision[165];
assign ch_msg[165] = ch_msg_165[QUAN_SIZE-1:0];
assign v2c_165_out0[QUAN_SIZE-1:0] = v2c_0[165];
assign c2v_0[165] = c2v_165_in0[QUAN_SIZE-1:0];
assign v2c_165_out1[QUAN_SIZE-1:0] = v2c_1[165];
assign c2v_1[165] = c2v_165_in1[QUAN_SIZE-1:0];
assign v2c_165_out2[QUAN_SIZE-1:0] = v2c_2[165];
assign c2v_2[165] = c2v_165_in2[QUAN_SIZE-1:0];
assign hard_decision_166 = hard_decision[166];
assign ch_msg[166] = ch_msg_166[QUAN_SIZE-1:0];
assign v2c_166_out0[QUAN_SIZE-1:0] = v2c_0[166];
assign c2v_0[166] = c2v_166_in0[QUAN_SIZE-1:0];
assign v2c_166_out1[QUAN_SIZE-1:0] = v2c_1[166];
assign c2v_1[166] = c2v_166_in1[QUAN_SIZE-1:0];
assign v2c_166_out2[QUAN_SIZE-1:0] = v2c_2[166];
assign c2v_2[166] = c2v_166_in2[QUAN_SIZE-1:0];
assign hard_decision_167 = hard_decision[167];
assign ch_msg[167] = ch_msg_167[QUAN_SIZE-1:0];
assign v2c_167_out0[QUAN_SIZE-1:0] = v2c_0[167];
assign c2v_0[167] = c2v_167_in0[QUAN_SIZE-1:0];
assign v2c_167_out1[QUAN_SIZE-1:0] = v2c_1[167];
assign c2v_1[167] = c2v_167_in1[QUAN_SIZE-1:0];
assign v2c_167_out2[QUAN_SIZE-1:0] = v2c_2[167];
assign c2v_2[167] = c2v_167_in2[QUAN_SIZE-1:0];
assign hard_decision_168 = hard_decision[168];
assign ch_msg[168] = ch_msg_168[QUAN_SIZE-1:0];
assign v2c_168_out0[QUAN_SIZE-1:0] = v2c_0[168];
assign c2v_0[168] = c2v_168_in0[QUAN_SIZE-1:0];
assign v2c_168_out1[QUAN_SIZE-1:0] = v2c_1[168];
assign c2v_1[168] = c2v_168_in1[QUAN_SIZE-1:0];
assign v2c_168_out2[QUAN_SIZE-1:0] = v2c_2[168];
assign c2v_2[168] = c2v_168_in2[QUAN_SIZE-1:0];
assign hard_decision_169 = hard_decision[169];
assign ch_msg[169] = ch_msg_169[QUAN_SIZE-1:0];
assign v2c_169_out0[QUAN_SIZE-1:0] = v2c_0[169];
assign c2v_0[169] = c2v_169_in0[QUAN_SIZE-1:0];
assign v2c_169_out1[QUAN_SIZE-1:0] = v2c_1[169];
assign c2v_1[169] = c2v_169_in1[QUAN_SIZE-1:0];
assign v2c_169_out2[QUAN_SIZE-1:0] = v2c_2[169];
assign c2v_2[169] = c2v_169_in2[QUAN_SIZE-1:0];
assign hard_decision_170 = hard_decision[170];
assign ch_msg[170] = ch_msg_170[QUAN_SIZE-1:0];
assign v2c_170_out0[QUAN_SIZE-1:0] = v2c_0[170];
assign c2v_0[170] = c2v_170_in0[QUAN_SIZE-1:0];
assign v2c_170_out1[QUAN_SIZE-1:0] = v2c_1[170];
assign c2v_1[170] = c2v_170_in1[QUAN_SIZE-1:0];
assign v2c_170_out2[QUAN_SIZE-1:0] = v2c_2[170];
assign c2v_2[170] = c2v_170_in2[QUAN_SIZE-1:0];
assign hard_decision_171 = hard_decision[171];
assign ch_msg[171] = ch_msg_171[QUAN_SIZE-1:0];
assign v2c_171_out0[QUAN_SIZE-1:0] = v2c_0[171];
assign c2v_0[171] = c2v_171_in0[QUAN_SIZE-1:0];
assign v2c_171_out1[QUAN_SIZE-1:0] = v2c_1[171];
assign c2v_1[171] = c2v_171_in1[QUAN_SIZE-1:0];
assign v2c_171_out2[QUAN_SIZE-1:0] = v2c_2[171];
assign c2v_2[171] = c2v_171_in2[QUAN_SIZE-1:0];
assign hard_decision_172 = hard_decision[172];
assign ch_msg[172] = ch_msg_172[QUAN_SIZE-1:0];
assign v2c_172_out0[QUAN_SIZE-1:0] = v2c_0[172];
assign c2v_0[172] = c2v_172_in0[QUAN_SIZE-1:0];
assign v2c_172_out1[QUAN_SIZE-1:0] = v2c_1[172];
assign c2v_1[172] = c2v_172_in1[QUAN_SIZE-1:0];
assign v2c_172_out2[QUAN_SIZE-1:0] = v2c_2[172];
assign c2v_2[172] = c2v_172_in2[QUAN_SIZE-1:0];
assign hard_decision_173 = hard_decision[173];
assign ch_msg[173] = ch_msg_173[QUAN_SIZE-1:0];
assign v2c_173_out0[QUAN_SIZE-1:0] = v2c_0[173];
assign c2v_0[173] = c2v_173_in0[QUAN_SIZE-1:0];
assign v2c_173_out1[QUAN_SIZE-1:0] = v2c_1[173];
assign c2v_1[173] = c2v_173_in1[QUAN_SIZE-1:0];
assign v2c_173_out2[QUAN_SIZE-1:0] = v2c_2[173];
assign c2v_2[173] = c2v_173_in2[QUAN_SIZE-1:0];
assign hard_decision_174 = hard_decision[174];
assign ch_msg[174] = ch_msg_174[QUAN_SIZE-1:0];
assign v2c_174_out0[QUAN_SIZE-1:0] = v2c_0[174];
assign c2v_0[174] = c2v_174_in0[QUAN_SIZE-1:0];
assign v2c_174_out1[QUAN_SIZE-1:0] = v2c_1[174];
assign c2v_1[174] = c2v_174_in1[QUAN_SIZE-1:0];
assign v2c_174_out2[QUAN_SIZE-1:0] = v2c_2[174];
assign c2v_2[174] = c2v_174_in2[QUAN_SIZE-1:0];
assign hard_decision_175 = hard_decision[175];
assign ch_msg[175] = ch_msg_175[QUAN_SIZE-1:0];
assign v2c_175_out0[QUAN_SIZE-1:0] = v2c_0[175];
assign c2v_0[175] = c2v_175_in0[QUAN_SIZE-1:0];
assign v2c_175_out1[QUAN_SIZE-1:0] = v2c_1[175];
assign c2v_1[175] = c2v_175_in1[QUAN_SIZE-1:0];
assign v2c_175_out2[QUAN_SIZE-1:0] = v2c_2[175];
assign c2v_2[175] = c2v_175_in2[QUAN_SIZE-1:0];
assign hard_decision_176 = hard_decision[176];
assign ch_msg[176] = ch_msg_176[QUAN_SIZE-1:0];
assign v2c_176_out0[QUAN_SIZE-1:0] = v2c_0[176];
assign c2v_0[176] = c2v_176_in0[QUAN_SIZE-1:0];
assign v2c_176_out1[QUAN_SIZE-1:0] = v2c_1[176];
assign c2v_1[176] = c2v_176_in1[QUAN_SIZE-1:0];
assign v2c_176_out2[QUAN_SIZE-1:0] = v2c_2[176];
assign c2v_2[176] = c2v_176_in2[QUAN_SIZE-1:0];
assign hard_decision_177 = hard_decision[177];
assign ch_msg[177] = ch_msg_177[QUAN_SIZE-1:0];
assign v2c_177_out0[QUAN_SIZE-1:0] = v2c_0[177];
assign c2v_0[177] = c2v_177_in0[QUAN_SIZE-1:0];
assign v2c_177_out1[QUAN_SIZE-1:0] = v2c_1[177];
assign c2v_1[177] = c2v_177_in1[QUAN_SIZE-1:0];
assign v2c_177_out2[QUAN_SIZE-1:0] = v2c_2[177];
assign c2v_2[177] = c2v_177_in2[QUAN_SIZE-1:0];
assign hard_decision_178 = hard_decision[178];
assign ch_msg[178] = ch_msg_178[QUAN_SIZE-1:0];
assign v2c_178_out0[QUAN_SIZE-1:0] = v2c_0[178];
assign c2v_0[178] = c2v_178_in0[QUAN_SIZE-1:0];
assign v2c_178_out1[QUAN_SIZE-1:0] = v2c_1[178];
assign c2v_1[178] = c2v_178_in1[QUAN_SIZE-1:0];
assign v2c_178_out2[QUAN_SIZE-1:0] = v2c_2[178];
assign c2v_2[178] = c2v_178_in2[QUAN_SIZE-1:0];
assign hard_decision_179 = hard_decision[179];
assign ch_msg[179] = ch_msg_179[QUAN_SIZE-1:0];
assign v2c_179_out0[QUAN_SIZE-1:0] = v2c_0[179];
assign c2v_0[179] = c2v_179_in0[QUAN_SIZE-1:0];
assign v2c_179_out1[QUAN_SIZE-1:0] = v2c_1[179];
assign c2v_1[179] = c2v_179_in1[QUAN_SIZE-1:0];
assign v2c_179_out2[QUAN_SIZE-1:0] = v2c_2[179];
assign c2v_2[179] = c2v_179_in2[QUAN_SIZE-1:0];
assign hard_decision_180 = hard_decision[180];
assign ch_msg[180] = ch_msg_180[QUAN_SIZE-1:0];
assign v2c_180_out0[QUAN_SIZE-1:0] = v2c_0[180];
assign c2v_0[180] = c2v_180_in0[QUAN_SIZE-1:0];
assign v2c_180_out1[QUAN_SIZE-1:0] = v2c_1[180];
assign c2v_1[180] = c2v_180_in1[QUAN_SIZE-1:0];
assign v2c_180_out2[QUAN_SIZE-1:0] = v2c_2[180];
assign c2v_2[180] = c2v_180_in2[QUAN_SIZE-1:0];
assign hard_decision_181 = hard_decision[181];
assign ch_msg[181] = ch_msg_181[QUAN_SIZE-1:0];
assign v2c_181_out0[QUAN_SIZE-1:0] = v2c_0[181];
assign c2v_0[181] = c2v_181_in0[QUAN_SIZE-1:0];
assign v2c_181_out1[QUAN_SIZE-1:0] = v2c_1[181];
assign c2v_1[181] = c2v_181_in1[QUAN_SIZE-1:0];
assign v2c_181_out2[QUAN_SIZE-1:0] = v2c_2[181];
assign c2v_2[181] = c2v_181_in2[QUAN_SIZE-1:0];
assign hard_decision_182 = hard_decision[182];
assign ch_msg[182] = ch_msg_182[QUAN_SIZE-1:0];
assign v2c_182_out0[QUAN_SIZE-1:0] = v2c_0[182];
assign c2v_0[182] = c2v_182_in0[QUAN_SIZE-1:0];
assign v2c_182_out1[QUAN_SIZE-1:0] = v2c_1[182];
assign c2v_1[182] = c2v_182_in1[QUAN_SIZE-1:0];
assign v2c_182_out2[QUAN_SIZE-1:0] = v2c_2[182];
assign c2v_2[182] = c2v_182_in2[QUAN_SIZE-1:0];
assign hard_decision_183 = hard_decision[183];
assign ch_msg[183] = ch_msg_183[QUAN_SIZE-1:0];
assign v2c_183_out0[QUAN_SIZE-1:0] = v2c_0[183];
assign c2v_0[183] = c2v_183_in0[QUAN_SIZE-1:0];
assign v2c_183_out1[QUAN_SIZE-1:0] = v2c_1[183];
assign c2v_1[183] = c2v_183_in1[QUAN_SIZE-1:0];
assign v2c_183_out2[QUAN_SIZE-1:0] = v2c_2[183];
assign c2v_2[183] = c2v_183_in2[QUAN_SIZE-1:0];
assign hard_decision_184 = hard_decision[184];
assign ch_msg[184] = ch_msg_184[QUAN_SIZE-1:0];
assign v2c_184_out0[QUAN_SIZE-1:0] = v2c_0[184];
assign c2v_0[184] = c2v_184_in0[QUAN_SIZE-1:0];
assign v2c_184_out1[QUAN_SIZE-1:0] = v2c_1[184];
assign c2v_1[184] = c2v_184_in1[QUAN_SIZE-1:0];
assign v2c_184_out2[QUAN_SIZE-1:0] = v2c_2[184];
assign c2v_2[184] = c2v_184_in2[QUAN_SIZE-1:0];
assign hard_decision_185 = hard_decision[185];
assign ch_msg[185] = ch_msg_185[QUAN_SIZE-1:0];
assign v2c_185_out0[QUAN_SIZE-1:0] = v2c_0[185];
assign c2v_0[185] = c2v_185_in0[QUAN_SIZE-1:0];
assign v2c_185_out1[QUAN_SIZE-1:0] = v2c_1[185];
assign c2v_1[185] = c2v_185_in1[QUAN_SIZE-1:0];
assign v2c_185_out2[QUAN_SIZE-1:0] = v2c_2[185];
assign c2v_2[185] = c2v_185_in2[QUAN_SIZE-1:0];
assign hard_decision_186 = hard_decision[186];
assign ch_msg[186] = ch_msg_186[QUAN_SIZE-1:0];
assign v2c_186_out0[QUAN_SIZE-1:0] = v2c_0[186];
assign c2v_0[186] = c2v_186_in0[QUAN_SIZE-1:0];
assign v2c_186_out1[QUAN_SIZE-1:0] = v2c_1[186];
assign c2v_1[186] = c2v_186_in1[QUAN_SIZE-1:0];
assign v2c_186_out2[QUAN_SIZE-1:0] = v2c_2[186];
assign c2v_2[186] = c2v_186_in2[QUAN_SIZE-1:0];
assign hard_decision_187 = hard_decision[187];
assign ch_msg[187] = ch_msg_187[QUAN_SIZE-1:0];
assign v2c_187_out0[QUAN_SIZE-1:0] = v2c_0[187];
assign c2v_0[187] = c2v_187_in0[QUAN_SIZE-1:0];
assign v2c_187_out1[QUAN_SIZE-1:0] = v2c_1[187];
assign c2v_1[187] = c2v_187_in1[QUAN_SIZE-1:0];
assign v2c_187_out2[QUAN_SIZE-1:0] = v2c_2[187];
assign c2v_2[187] = c2v_187_in2[QUAN_SIZE-1:0];
assign hard_decision_188 = hard_decision[188];
assign ch_msg[188] = ch_msg_188[QUAN_SIZE-1:0];
assign v2c_188_out0[QUAN_SIZE-1:0] = v2c_0[188];
assign c2v_0[188] = c2v_188_in0[QUAN_SIZE-1:0];
assign v2c_188_out1[QUAN_SIZE-1:0] = v2c_1[188];
assign c2v_1[188] = c2v_188_in1[QUAN_SIZE-1:0];
assign v2c_188_out2[QUAN_SIZE-1:0] = v2c_2[188];
assign c2v_2[188] = c2v_188_in2[QUAN_SIZE-1:0];
assign hard_decision_189 = hard_decision[189];
assign ch_msg[189] = ch_msg_189[QUAN_SIZE-1:0];
assign v2c_189_out0[QUAN_SIZE-1:0] = v2c_0[189];
assign c2v_0[189] = c2v_189_in0[QUAN_SIZE-1:0];
assign v2c_189_out1[QUAN_SIZE-1:0] = v2c_1[189];
assign c2v_1[189] = c2v_189_in1[QUAN_SIZE-1:0];
assign v2c_189_out2[QUAN_SIZE-1:0] = v2c_2[189];
assign c2v_2[189] = c2v_189_in2[QUAN_SIZE-1:0];
assign hard_decision_190 = hard_decision[190];
assign ch_msg[190] = ch_msg_190[QUAN_SIZE-1:0];
assign v2c_190_out0[QUAN_SIZE-1:0] = v2c_0[190];
assign c2v_0[190] = c2v_190_in0[QUAN_SIZE-1:0];
assign v2c_190_out1[QUAN_SIZE-1:0] = v2c_1[190];
assign c2v_1[190] = c2v_190_in1[QUAN_SIZE-1:0];
assign v2c_190_out2[QUAN_SIZE-1:0] = v2c_2[190];
assign c2v_2[190] = c2v_190_in2[QUAN_SIZE-1:0];
assign hard_decision_191 = hard_decision[191];
assign ch_msg[191] = ch_msg_191[QUAN_SIZE-1:0];
assign v2c_191_out0[QUAN_SIZE-1:0] = v2c_0[191];
assign c2v_0[191] = c2v_191_in0[QUAN_SIZE-1:0];
assign v2c_191_out1[QUAN_SIZE-1:0] = v2c_1[191];
assign c2v_1[191] = c2v_191_in1[QUAN_SIZE-1:0];
assign v2c_191_out2[QUAN_SIZE-1:0] = v2c_2[191];
assign c2v_2[191] = c2v_191_in2[QUAN_SIZE-1:0];
assign hard_decision_192 = hard_decision[192];
assign ch_msg[192] = ch_msg_192[QUAN_SIZE-1:0];
assign v2c_192_out0[QUAN_SIZE-1:0] = v2c_0[192];
assign c2v_0[192] = c2v_192_in0[QUAN_SIZE-1:0];
assign v2c_192_out1[QUAN_SIZE-1:0] = v2c_1[192];
assign c2v_1[192] = c2v_192_in1[QUAN_SIZE-1:0];
assign v2c_192_out2[QUAN_SIZE-1:0] = v2c_2[192];
assign c2v_2[192] = c2v_192_in2[QUAN_SIZE-1:0];
assign hard_decision_193 = hard_decision[193];
assign ch_msg[193] = ch_msg_193[QUAN_SIZE-1:0];
assign v2c_193_out0[QUAN_SIZE-1:0] = v2c_0[193];
assign c2v_0[193] = c2v_193_in0[QUAN_SIZE-1:0];
assign v2c_193_out1[QUAN_SIZE-1:0] = v2c_1[193];
assign c2v_1[193] = c2v_193_in1[QUAN_SIZE-1:0];
assign v2c_193_out2[QUAN_SIZE-1:0] = v2c_2[193];
assign c2v_2[193] = c2v_193_in2[QUAN_SIZE-1:0];
assign hard_decision_194 = hard_decision[194];
assign ch_msg[194] = ch_msg_194[QUAN_SIZE-1:0];
assign v2c_194_out0[QUAN_SIZE-1:0] = v2c_0[194];
assign c2v_0[194] = c2v_194_in0[QUAN_SIZE-1:0];
assign v2c_194_out1[QUAN_SIZE-1:0] = v2c_1[194];
assign c2v_1[194] = c2v_194_in1[QUAN_SIZE-1:0];
assign v2c_194_out2[QUAN_SIZE-1:0] = v2c_2[194];
assign c2v_2[194] = c2v_194_in2[QUAN_SIZE-1:0];
assign hard_decision_195 = hard_decision[195];
assign ch_msg[195] = ch_msg_195[QUAN_SIZE-1:0];
assign v2c_195_out0[QUAN_SIZE-1:0] = v2c_0[195];
assign c2v_0[195] = c2v_195_in0[QUAN_SIZE-1:0];
assign v2c_195_out1[QUAN_SIZE-1:0] = v2c_1[195];
assign c2v_1[195] = c2v_195_in1[QUAN_SIZE-1:0];
assign v2c_195_out2[QUAN_SIZE-1:0] = v2c_2[195];
assign c2v_2[195] = c2v_195_in2[QUAN_SIZE-1:0];
assign hard_decision_196 = hard_decision[196];
assign ch_msg[196] = ch_msg_196[QUAN_SIZE-1:0];
assign v2c_196_out0[QUAN_SIZE-1:0] = v2c_0[196];
assign c2v_0[196] = c2v_196_in0[QUAN_SIZE-1:0];
assign v2c_196_out1[QUAN_SIZE-1:0] = v2c_1[196];
assign c2v_1[196] = c2v_196_in1[QUAN_SIZE-1:0];
assign v2c_196_out2[QUAN_SIZE-1:0] = v2c_2[196];
assign c2v_2[196] = c2v_196_in2[QUAN_SIZE-1:0];
assign hard_decision_197 = hard_decision[197];
assign ch_msg[197] = ch_msg_197[QUAN_SIZE-1:0];
assign v2c_197_out0[QUAN_SIZE-1:0] = v2c_0[197];
assign c2v_0[197] = c2v_197_in0[QUAN_SIZE-1:0];
assign v2c_197_out1[QUAN_SIZE-1:0] = v2c_1[197];
assign c2v_1[197] = c2v_197_in1[QUAN_SIZE-1:0];
assign v2c_197_out2[QUAN_SIZE-1:0] = v2c_2[197];
assign c2v_2[197] = c2v_197_in2[QUAN_SIZE-1:0];
assign hard_decision_198 = hard_decision[198];
assign ch_msg[198] = ch_msg_198[QUAN_SIZE-1:0];
assign v2c_198_out0[QUAN_SIZE-1:0] = v2c_0[198];
assign c2v_0[198] = c2v_198_in0[QUAN_SIZE-1:0];
assign v2c_198_out1[QUAN_SIZE-1:0] = v2c_1[198];
assign c2v_1[198] = c2v_198_in1[QUAN_SIZE-1:0];
assign v2c_198_out2[QUAN_SIZE-1:0] = v2c_2[198];
assign c2v_2[198] = c2v_198_in2[QUAN_SIZE-1:0];
assign hard_decision_199 = hard_decision[199];
assign ch_msg[199] = ch_msg_199[QUAN_SIZE-1:0];
assign v2c_199_out0[QUAN_SIZE-1:0] = v2c_0[199];
assign c2v_0[199] = c2v_199_in0[QUAN_SIZE-1:0];
assign v2c_199_out1[QUAN_SIZE-1:0] = v2c_1[199];
assign c2v_1[199] = c2v_199_in1[QUAN_SIZE-1:0];
assign v2c_199_out2[QUAN_SIZE-1:0] = v2c_2[199];
assign c2v_2[199] = c2v_199_in2[QUAN_SIZE-1:0];
assign hard_decision_200 = hard_decision[200];
assign ch_msg[200] = ch_msg_200[QUAN_SIZE-1:0];
assign v2c_200_out0[QUAN_SIZE-1:0] = v2c_0[200];
assign c2v_0[200] = c2v_200_in0[QUAN_SIZE-1:0];
assign v2c_200_out1[QUAN_SIZE-1:0] = v2c_1[200];
assign c2v_1[200] = c2v_200_in1[QUAN_SIZE-1:0];
assign v2c_200_out2[QUAN_SIZE-1:0] = v2c_2[200];
assign c2v_2[200] = c2v_200_in2[QUAN_SIZE-1:0];
assign hard_decision_201 = hard_decision[201];
assign ch_msg[201] = ch_msg_201[QUAN_SIZE-1:0];
assign v2c_201_out0[QUAN_SIZE-1:0] = v2c_0[201];
assign c2v_0[201] = c2v_201_in0[QUAN_SIZE-1:0];
assign v2c_201_out1[QUAN_SIZE-1:0] = v2c_1[201];
assign c2v_1[201] = c2v_201_in1[QUAN_SIZE-1:0];
assign v2c_201_out2[QUAN_SIZE-1:0] = v2c_2[201];
assign c2v_2[201] = c2v_201_in2[QUAN_SIZE-1:0];
assign hard_decision_202 = hard_decision[202];
assign ch_msg[202] = ch_msg_202[QUAN_SIZE-1:0];
assign v2c_202_out0[QUAN_SIZE-1:0] = v2c_0[202];
assign c2v_0[202] = c2v_202_in0[QUAN_SIZE-1:0];
assign v2c_202_out1[QUAN_SIZE-1:0] = v2c_1[202];
assign c2v_1[202] = c2v_202_in1[QUAN_SIZE-1:0];
assign v2c_202_out2[QUAN_SIZE-1:0] = v2c_2[202];
assign c2v_2[202] = c2v_202_in2[QUAN_SIZE-1:0];
assign hard_decision_203 = hard_decision[203];
assign ch_msg[203] = ch_msg_203[QUAN_SIZE-1:0];
assign v2c_203_out0[QUAN_SIZE-1:0] = v2c_0[203];
assign c2v_0[203] = c2v_203_in0[QUAN_SIZE-1:0];
assign v2c_203_out1[QUAN_SIZE-1:0] = v2c_1[203];
assign c2v_1[203] = c2v_203_in1[QUAN_SIZE-1:0];
assign v2c_203_out2[QUAN_SIZE-1:0] = v2c_2[203];
assign c2v_2[203] = c2v_203_in2[QUAN_SIZE-1:0];
endmodule