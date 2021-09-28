`include "define.vh"
`include "mem_config.vh"
module column_ram_pc255 #(
	parameter QUAN_SIZE = 4,
	parameter CHECK_PARALLELISM = 255,
	parameter RAM_PORTA_RANGE = 28, // 28 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 28, // 28 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 28,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 12,
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
	output wire [QUAN_SIZE-1:0] first_dout_85,
	output wire [QUAN_SIZE-1:0] first_dout_86,
	output wire [QUAN_SIZE-1:0] first_dout_87,
	output wire [QUAN_SIZE-1:0] first_dout_88,
	output wire [QUAN_SIZE-1:0] first_dout_89,
	output wire [QUAN_SIZE-1:0] first_dout_90,
	output wire [QUAN_SIZE-1:0] first_dout_91,
	output wire [QUAN_SIZE-1:0] first_dout_92,
	output wire [QUAN_SIZE-1:0] first_dout_93,
	output wire [QUAN_SIZE-1:0] first_dout_94,
	output wire [QUAN_SIZE-1:0] first_dout_95,
	output wire [QUAN_SIZE-1:0] first_dout_96,
	output wire [QUAN_SIZE-1:0] first_dout_97,
	output wire [QUAN_SIZE-1:0] first_dout_98,
	output wire [QUAN_SIZE-1:0] first_dout_99,
	output wire [QUAN_SIZE-1:0] first_dout_100,
	output wire [QUAN_SIZE-1:0] first_dout_101,
	output wire [QUAN_SIZE-1:0] first_dout_102,
	output wire [QUAN_SIZE-1:0] first_dout_103,
	output wire [QUAN_SIZE-1:0] first_dout_104,
	output wire [QUAN_SIZE-1:0] first_dout_105,
	output wire [QUAN_SIZE-1:0] first_dout_106,
	output wire [QUAN_SIZE-1:0] first_dout_107,
	output wire [QUAN_SIZE-1:0] first_dout_108,
	output wire [QUAN_SIZE-1:0] first_dout_109,
	output wire [QUAN_SIZE-1:0] first_dout_110,
	output wire [QUAN_SIZE-1:0] first_dout_111,
	output wire [QUAN_SIZE-1:0] first_dout_112,
	output wire [QUAN_SIZE-1:0] first_dout_113,
	output wire [QUAN_SIZE-1:0] first_dout_114,
	output wire [QUAN_SIZE-1:0] first_dout_115,
	output wire [QUAN_SIZE-1:0] first_dout_116,
	output wire [QUAN_SIZE-1:0] first_dout_117,
	output wire [QUAN_SIZE-1:0] first_dout_118,
	output wire [QUAN_SIZE-1:0] first_dout_119,
	output wire [QUAN_SIZE-1:0] first_dout_120,
	output wire [QUAN_SIZE-1:0] first_dout_121,
	output wire [QUAN_SIZE-1:0] first_dout_122,
	output wire [QUAN_SIZE-1:0] first_dout_123,
	output wire [QUAN_SIZE-1:0] first_dout_124,
	output wire [QUAN_SIZE-1:0] first_dout_125,
	output wire [QUAN_SIZE-1:0] first_dout_126,
	output wire [QUAN_SIZE-1:0] first_dout_127,
	output wire [QUAN_SIZE-1:0] first_dout_128,
	output wire [QUAN_SIZE-1:0] first_dout_129,
	output wire [QUAN_SIZE-1:0] first_dout_130,
	output wire [QUAN_SIZE-1:0] first_dout_131,
	output wire [QUAN_SIZE-1:0] first_dout_132,
	output wire [QUAN_SIZE-1:0] first_dout_133,
	output wire [QUAN_SIZE-1:0] first_dout_134,
	output wire [QUAN_SIZE-1:0] first_dout_135,
	output wire [QUAN_SIZE-1:0] first_dout_136,
	output wire [QUAN_SIZE-1:0] first_dout_137,
	output wire [QUAN_SIZE-1:0] first_dout_138,
	output wire [QUAN_SIZE-1:0] first_dout_139,
	output wire [QUAN_SIZE-1:0] first_dout_140,
	output wire [QUAN_SIZE-1:0] first_dout_141,
	output wire [QUAN_SIZE-1:0] first_dout_142,
	output wire [QUAN_SIZE-1:0] first_dout_143,
	output wire [QUAN_SIZE-1:0] first_dout_144,
	output wire [QUAN_SIZE-1:0] first_dout_145,
	output wire [QUAN_SIZE-1:0] first_dout_146,
	output wire [QUAN_SIZE-1:0] first_dout_147,
	output wire [QUAN_SIZE-1:0] first_dout_148,
	output wire [QUAN_SIZE-1:0] first_dout_149,
	output wire [QUAN_SIZE-1:0] first_dout_150,
	output wire [QUAN_SIZE-1:0] first_dout_151,
	output wire [QUAN_SIZE-1:0] first_dout_152,
	output wire [QUAN_SIZE-1:0] first_dout_153,
	output wire [QUAN_SIZE-1:0] first_dout_154,
	output wire [QUAN_SIZE-1:0] first_dout_155,
	output wire [QUAN_SIZE-1:0] first_dout_156,
	output wire [QUAN_SIZE-1:0] first_dout_157,
	output wire [QUAN_SIZE-1:0] first_dout_158,
	output wire [QUAN_SIZE-1:0] first_dout_159,
	output wire [QUAN_SIZE-1:0] first_dout_160,
	output wire [QUAN_SIZE-1:0] first_dout_161,
	output wire [QUAN_SIZE-1:0] first_dout_162,
	output wire [QUAN_SIZE-1:0] first_dout_163,
	output wire [QUAN_SIZE-1:0] first_dout_164,
	output wire [QUAN_SIZE-1:0] first_dout_165,
	output wire [QUAN_SIZE-1:0] first_dout_166,
	output wire [QUAN_SIZE-1:0] first_dout_167,
	output wire [QUAN_SIZE-1:0] first_dout_168,
	output wire [QUAN_SIZE-1:0] first_dout_169,
	output wire [QUAN_SIZE-1:0] first_dout_170,
	output wire [QUAN_SIZE-1:0] first_dout_171,
	output wire [QUAN_SIZE-1:0] first_dout_172,
	output wire [QUAN_SIZE-1:0] first_dout_173,
	output wire [QUAN_SIZE-1:0] first_dout_174,
	output wire [QUAN_SIZE-1:0] first_dout_175,
	output wire [QUAN_SIZE-1:0] first_dout_176,
	output wire [QUAN_SIZE-1:0] first_dout_177,
	output wire [QUAN_SIZE-1:0] first_dout_178,
	output wire [QUAN_SIZE-1:0] first_dout_179,
	output wire [QUAN_SIZE-1:0] first_dout_180,
	output wire [QUAN_SIZE-1:0] first_dout_181,
	output wire [QUAN_SIZE-1:0] first_dout_182,
	output wire [QUAN_SIZE-1:0] first_dout_183,
	output wire [QUAN_SIZE-1:0] first_dout_184,
	output wire [QUAN_SIZE-1:0] first_dout_185,
	output wire [QUAN_SIZE-1:0] first_dout_186,
	output wire [QUAN_SIZE-1:0] first_dout_187,
	output wire [QUAN_SIZE-1:0] first_dout_188,
	output wire [QUAN_SIZE-1:0] first_dout_189,
	output wire [QUAN_SIZE-1:0] first_dout_190,
	output wire [QUAN_SIZE-1:0] first_dout_191,
	output wire [QUAN_SIZE-1:0] first_dout_192,
	output wire [QUAN_SIZE-1:0] first_dout_193,
	output wire [QUAN_SIZE-1:0] first_dout_194,
	output wire [QUAN_SIZE-1:0] first_dout_195,
	output wire [QUAN_SIZE-1:0] first_dout_196,
	output wire [QUAN_SIZE-1:0] first_dout_197,
	output wire [QUAN_SIZE-1:0] first_dout_198,
	output wire [QUAN_SIZE-1:0] first_dout_199,
	output wire [QUAN_SIZE-1:0] first_dout_200,
	output wire [QUAN_SIZE-1:0] first_dout_201,
	output wire [QUAN_SIZE-1:0] first_dout_202,
	output wire [QUAN_SIZE-1:0] first_dout_203,
	output wire [QUAN_SIZE-1:0] first_dout_204,
	output wire [QUAN_SIZE-1:0] first_dout_205,
	output wire [QUAN_SIZE-1:0] first_dout_206,
	output wire [QUAN_SIZE-1:0] first_dout_207,
	output wire [QUAN_SIZE-1:0] first_dout_208,
	output wire [QUAN_SIZE-1:0] first_dout_209,
	output wire [QUAN_SIZE-1:0] first_dout_210,
	output wire [QUAN_SIZE-1:0] first_dout_211,
	output wire [QUAN_SIZE-1:0] first_dout_212,
	output wire [QUAN_SIZE-1:0] first_dout_213,
	output wire [QUAN_SIZE-1:0] first_dout_214,
	output wire [QUAN_SIZE-1:0] first_dout_215,
	output wire [QUAN_SIZE-1:0] first_dout_216,
	output wire [QUAN_SIZE-1:0] first_dout_217,
	output wire [QUAN_SIZE-1:0] first_dout_218,
	output wire [QUAN_SIZE-1:0] first_dout_219,
	output wire [QUAN_SIZE-1:0] first_dout_220,
	output wire [QUAN_SIZE-1:0] first_dout_221,
	output wire [QUAN_SIZE-1:0] first_dout_222,
	output wire [QUAN_SIZE-1:0] first_dout_223,
	output wire [QUAN_SIZE-1:0] first_dout_224,
	output wire [QUAN_SIZE-1:0] first_dout_225,
	output wire [QUAN_SIZE-1:0] first_dout_226,
	output wire [QUAN_SIZE-1:0] first_dout_227,
	output wire [QUAN_SIZE-1:0] first_dout_228,
	output wire [QUAN_SIZE-1:0] first_dout_229,
	output wire [QUAN_SIZE-1:0] first_dout_230,
	output wire [QUAN_SIZE-1:0] first_dout_231,
	output wire [QUAN_SIZE-1:0] first_dout_232,
	output wire [QUAN_SIZE-1:0] first_dout_233,
	output wire [QUAN_SIZE-1:0] first_dout_234,
	output wire [QUAN_SIZE-1:0] first_dout_235,
	output wire [QUAN_SIZE-1:0] first_dout_236,
	output wire [QUAN_SIZE-1:0] first_dout_237,
	output wire [QUAN_SIZE-1:0] first_dout_238,
	output wire [QUAN_SIZE-1:0] first_dout_239,
	output wire [QUAN_SIZE-1:0] first_dout_240,
	output wire [QUAN_SIZE-1:0] first_dout_241,
	output wire [QUAN_SIZE-1:0] first_dout_242,
	output wire [QUAN_SIZE-1:0] first_dout_243,
	output wire [QUAN_SIZE-1:0] first_dout_244,
	output wire [QUAN_SIZE-1:0] first_dout_245,
	output wire [QUAN_SIZE-1:0] first_dout_246,
	output wire [QUAN_SIZE-1:0] first_dout_247,
	output wire [QUAN_SIZE-1:0] first_dout_248,
	output wire [QUAN_SIZE-1:0] first_dout_249,
	output wire [QUAN_SIZE-1:0] first_dout_250,
	output wire [QUAN_SIZE-1:0] first_dout_251,
	output wire [QUAN_SIZE-1:0] first_dout_252,
	output wire [QUAN_SIZE-1:0] first_dout_253,
	output wire [QUAN_SIZE-1:0] first_dout_254,

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
	output wire [QUAN_SIZE-1:0] second_dout_85,
	output wire [QUAN_SIZE-1:0] second_dout_86,
	output wire [QUAN_SIZE-1:0] second_dout_87,
	output wire [QUAN_SIZE-1:0] second_dout_88,
	output wire [QUAN_SIZE-1:0] second_dout_89,
	output wire [QUAN_SIZE-1:0] second_dout_90,
	output wire [QUAN_SIZE-1:0] second_dout_91,
	output wire [QUAN_SIZE-1:0] second_dout_92,
	output wire [QUAN_SIZE-1:0] second_dout_93,
	output wire [QUAN_SIZE-1:0] second_dout_94,
	output wire [QUAN_SIZE-1:0] second_dout_95,
	output wire [QUAN_SIZE-1:0] second_dout_96,
	output wire [QUAN_SIZE-1:0] second_dout_97,
	output wire [QUAN_SIZE-1:0] second_dout_98,
	output wire [QUAN_SIZE-1:0] second_dout_99,
	output wire [QUAN_SIZE-1:0] second_dout_100,
	output wire [QUAN_SIZE-1:0] second_dout_101,
	output wire [QUAN_SIZE-1:0] second_dout_102,
	output wire [QUAN_SIZE-1:0] second_dout_103,
	output wire [QUAN_SIZE-1:0] second_dout_104,
	output wire [QUAN_SIZE-1:0] second_dout_105,
	output wire [QUAN_SIZE-1:0] second_dout_106,
	output wire [QUAN_SIZE-1:0] second_dout_107,
	output wire [QUAN_SIZE-1:0] second_dout_108,
	output wire [QUAN_SIZE-1:0] second_dout_109,
	output wire [QUAN_SIZE-1:0] second_dout_110,
	output wire [QUAN_SIZE-1:0] second_dout_111,
	output wire [QUAN_SIZE-1:0] second_dout_112,
	output wire [QUAN_SIZE-1:0] second_dout_113,
	output wire [QUAN_SIZE-1:0] second_dout_114,
	output wire [QUAN_SIZE-1:0] second_dout_115,
	output wire [QUAN_SIZE-1:0] second_dout_116,
	output wire [QUAN_SIZE-1:0] second_dout_117,
	output wire [QUAN_SIZE-1:0] second_dout_118,
	output wire [QUAN_SIZE-1:0] second_dout_119,
	output wire [QUAN_SIZE-1:0] second_dout_120,
	output wire [QUAN_SIZE-1:0] second_dout_121,
	output wire [QUAN_SIZE-1:0] second_dout_122,
	output wire [QUAN_SIZE-1:0] second_dout_123,
	output wire [QUAN_SIZE-1:0] second_dout_124,
	output wire [QUAN_SIZE-1:0] second_dout_125,
	output wire [QUAN_SIZE-1:0] second_dout_126,
	output wire [QUAN_SIZE-1:0] second_dout_127,
	output wire [QUAN_SIZE-1:0] second_dout_128,
	output wire [QUAN_SIZE-1:0] second_dout_129,
	output wire [QUAN_SIZE-1:0] second_dout_130,
	output wire [QUAN_SIZE-1:0] second_dout_131,
	output wire [QUAN_SIZE-1:0] second_dout_132,
	output wire [QUAN_SIZE-1:0] second_dout_133,
	output wire [QUAN_SIZE-1:0] second_dout_134,
	output wire [QUAN_SIZE-1:0] second_dout_135,
	output wire [QUAN_SIZE-1:0] second_dout_136,
	output wire [QUAN_SIZE-1:0] second_dout_137,
	output wire [QUAN_SIZE-1:0] second_dout_138,
	output wire [QUAN_SIZE-1:0] second_dout_139,
	output wire [QUAN_SIZE-1:0] second_dout_140,
	output wire [QUAN_SIZE-1:0] second_dout_141,
	output wire [QUAN_SIZE-1:0] second_dout_142,
	output wire [QUAN_SIZE-1:0] second_dout_143,
	output wire [QUAN_SIZE-1:0] second_dout_144,
	output wire [QUAN_SIZE-1:0] second_dout_145,
	output wire [QUAN_SIZE-1:0] second_dout_146,
	output wire [QUAN_SIZE-1:0] second_dout_147,
	output wire [QUAN_SIZE-1:0] second_dout_148,
	output wire [QUAN_SIZE-1:0] second_dout_149,
	output wire [QUAN_SIZE-1:0] second_dout_150,
	output wire [QUAN_SIZE-1:0] second_dout_151,
	output wire [QUAN_SIZE-1:0] second_dout_152,
	output wire [QUAN_SIZE-1:0] second_dout_153,
	output wire [QUAN_SIZE-1:0] second_dout_154,
	output wire [QUAN_SIZE-1:0] second_dout_155,
	output wire [QUAN_SIZE-1:0] second_dout_156,
	output wire [QUAN_SIZE-1:0] second_dout_157,
	output wire [QUAN_SIZE-1:0] second_dout_158,
	output wire [QUAN_SIZE-1:0] second_dout_159,
	output wire [QUAN_SIZE-1:0] second_dout_160,
	output wire [QUAN_SIZE-1:0] second_dout_161,
	output wire [QUAN_SIZE-1:0] second_dout_162,
	output wire [QUAN_SIZE-1:0] second_dout_163,
	output wire [QUAN_SIZE-1:0] second_dout_164,
	output wire [QUAN_SIZE-1:0] second_dout_165,
	output wire [QUAN_SIZE-1:0] second_dout_166,
	output wire [QUAN_SIZE-1:0] second_dout_167,
	output wire [QUAN_SIZE-1:0] second_dout_168,
	output wire [QUAN_SIZE-1:0] second_dout_169,
	output wire [QUAN_SIZE-1:0] second_dout_170,
	output wire [QUAN_SIZE-1:0] second_dout_171,
	output wire [QUAN_SIZE-1:0] second_dout_172,
	output wire [QUAN_SIZE-1:0] second_dout_173,
	output wire [QUAN_SIZE-1:0] second_dout_174,
	output wire [QUAN_SIZE-1:0] second_dout_175,
	output wire [QUAN_SIZE-1:0] second_dout_176,
	output wire [QUAN_SIZE-1:0] second_dout_177,
	output wire [QUAN_SIZE-1:0] second_dout_178,
	output wire [QUAN_SIZE-1:0] second_dout_179,
	output wire [QUAN_SIZE-1:0] second_dout_180,
	output wire [QUAN_SIZE-1:0] second_dout_181,
	output wire [QUAN_SIZE-1:0] second_dout_182,
	output wire [QUAN_SIZE-1:0] second_dout_183,
	output wire [QUAN_SIZE-1:0] second_dout_184,
	output wire [QUAN_SIZE-1:0] second_dout_185,
	output wire [QUAN_SIZE-1:0] second_dout_186,
	output wire [QUAN_SIZE-1:0] second_dout_187,
	output wire [QUAN_SIZE-1:0] second_dout_188,
	output wire [QUAN_SIZE-1:0] second_dout_189,
	output wire [QUAN_SIZE-1:0] second_dout_190,
	output wire [QUAN_SIZE-1:0] second_dout_191,
	output wire [QUAN_SIZE-1:0] second_dout_192,
	output wire [QUAN_SIZE-1:0] second_dout_193,
	output wire [QUAN_SIZE-1:0] second_dout_194,
	output wire [QUAN_SIZE-1:0] second_dout_195,
	output wire [QUAN_SIZE-1:0] second_dout_196,
	output wire [QUAN_SIZE-1:0] second_dout_197,
	output wire [QUAN_SIZE-1:0] second_dout_198,
	output wire [QUAN_SIZE-1:0] second_dout_199,
	output wire [QUAN_SIZE-1:0] second_dout_200,
	output wire [QUAN_SIZE-1:0] second_dout_201,
	output wire [QUAN_SIZE-1:0] second_dout_202,
	output wire [QUAN_SIZE-1:0] second_dout_203,
	output wire [QUAN_SIZE-1:0] second_dout_204,
	output wire [QUAN_SIZE-1:0] second_dout_205,
	output wire [QUAN_SIZE-1:0] second_dout_206,
	output wire [QUAN_SIZE-1:0] second_dout_207,
	output wire [QUAN_SIZE-1:0] second_dout_208,
	output wire [QUAN_SIZE-1:0] second_dout_209,
	output wire [QUAN_SIZE-1:0] second_dout_210,
	output wire [QUAN_SIZE-1:0] second_dout_211,
	output wire [QUAN_SIZE-1:0] second_dout_212,
	output wire [QUAN_SIZE-1:0] second_dout_213,
	output wire [QUAN_SIZE-1:0] second_dout_214,
	output wire [QUAN_SIZE-1:0] second_dout_215,
	output wire [QUAN_SIZE-1:0] second_dout_216,
	output wire [QUAN_SIZE-1:0] second_dout_217,
	output wire [QUAN_SIZE-1:0] second_dout_218,
	output wire [QUAN_SIZE-1:0] second_dout_219,
	output wire [QUAN_SIZE-1:0] second_dout_220,
	output wire [QUAN_SIZE-1:0] second_dout_221,
	output wire [QUAN_SIZE-1:0] second_dout_222,
	output wire [QUAN_SIZE-1:0] second_dout_223,
	output wire [QUAN_SIZE-1:0] second_dout_224,
	output wire [QUAN_SIZE-1:0] second_dout_225,
	output wire [QUAN_SIZE-1:0] second_dout_226,
	output wire [QUAN_SIZE-1:0] second_dout_227,
	output wire [QUAN_SIZE-1:0] second_dout_228,
	output wire [QUAN_SIZE-1:0] second_dout_229,
	output wire [QUAN_SIZE-1:0] second_dout_230,
	output wire [QUAN_SIZE-1:0] second_dout_231,
	output wire [QUAN_SIZE-1:0] second_dout_232,
	output wire [QUAN_SIZE-1:0] second_dout_233,
	output wire [QUAN_SIZE-1:0] second_dout_234,
	output wire [QUAN_SIZE-1:0] second_dout_235,
	output wire [QUAN_SIZE-1:0] second_dout_236,
	output wire [QUAN_SIZE-1:0] second_dout_237,
	output wire [QUAN_SIZE-1:0] second_dout_238,
	output wire [QUAN_SIZE-1:0] second_dout_239,
	output wire [QUAN_SIZE-1:0] second_dout_240,
	output wire [QUAN_SIZE-1:0] second_dout_241,
	output wire [QUAN_SIZE-1:0] second_dout_242,
	output wire [QUAN_SIZE-1:0] second_dout_243,
	output wire [QUAN_SIZE-1:0] second_dout_244,
	output wire [QUAN_SIZE-1:0] second_dout_245,
	output wire [QUAN_SIZE-1:0] second_dout_246,
	output wire [QUAN_SIZE-1:0] second_dout_247,
	output wire [QUAN_SIZE-1:0] second_dout_248,
	output wire [QUAN_SIZE-1:0] second_dout_249,
	output wire [QUAN_SIZE-1:0] second_dout_250,
	output wire [QUAN_SIZE-1:0] second_dout_251,
	output wire [QUAN_SIZE-1:0] second_dout_252,
	output wire [QUAN_SIZE-1:0] second_dout_253,
	output wire [QUAN_SIZE-1:0] second_dout_254,

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
	input wire [QUAN_SIZE-1:0] first_din_85,
	input wire [QUAN_SIZE-1:0] first_din_86,
	input wire [QUAN_SIZE-1:0] first_din_87,
	input wire [QUAN_SIZE-1:0] first_din_88,
	input wire [QUAN_SIZE-1:0] first_din_89,
	input wire [QUAN_SIZE-1:0] first_din_90,
	input wire [QUAN_SIZE-1:0] first_din_91,
	input wire [QUAN_SIZE-1:0] first_din_92,
	input wire [QUAN_SIZE-1:0] first_din_93,
	input wire [QUAN_SIZE-1:0] first_din_94,
	input wire [QUAN_SIZE-1:0] first_din_95,
	input wire [QUAN_SIZE-1:0] first_din_96,
	input wire [QUAN_SIZE-1:0] first_din_97,
	input wire [QUAN_SIZE-1:0] first_din_98,
	input wire [QUAN_SIZE-1:0] first_din_99,
	input wire [QUAN_SIZE-1:0] first_din_100,
	input wire [QUAN_SIZE-1:0] first_din_101,
	input wire [QUAN_SIZE-1:0] first_din_102,
	input wire [QUAN_SIZE-1:0] first_din_103,
	input wire [QUAN_SIZE-1:0] first_din_104,
	input wire [QUAN_SIZE-1:0] first_din_105,
	input wire [QUAN_SIZE-1:0] first_din_106,
	input wire [QUAN_SIZE-1:0] first_din_107,
	input wire [QUAN_SIZE-1:0] first_din_108,
	input wire [QUAN_SIZE-1:0] first_din_109,
	input wire [QUAN_SIZE-1:0] first_din_110,
	input wire [QUAN_SIZE-1:0] first_din_111,
	input wire [QUAN_SIZE-1:0] first_din_112,
	input wire [QUAN_SIZE-1:0] first_din_113,
	input wire [QUAN_SIZE-1:0] first_din_114,
	input wire [QUAN_SIZE-1:0] first_din_115,
	input wire [QUAN_SIZE-1:0] first_din_116,
	input wire [QUAN_SIZE-1:0] first_din_117,
	input wire [QUAN_SIZE-1:0] first_din_118,
	input wire [QUAN_SIZE-1:0] first_din_119,
	input wire [QUAN_SIZE-1:0] first_din_120,
	input wire [QUAN_SIZE-1:0] first_din_121,
	input wire [QUAN_SIZE-1:0] first_din_122,
	input wire [QUAN_SIZE-1:0] first_din_123,
	input wire [QUAN_SIZE-1:0] first_din_124,
	input wire [QUAN_SIZE-1:0] first_din_125,
	input wire [QUAN_SIZE-1:0] first_din_126,
	input wire [QUAN_SIZE-1:0] first_din_127,
	input wire [QUAN_SIZE-1:0] first_din_128,
	input wire [QUAN_SIZE-1:0] first_din_129,
	input wire [QUAN_SIZE-1:0] first_din_130,
	input wire [QUAN_SIZE-1:0] first_din_131,
	input wire [QUAN_SIZE-1:0] first_din_132,
	input wire [QUAN_SIZE-1:0] first_din_133,
	input wire [QUAN_SIZE-1:0] first_din_134,
	input wire [QUAN_SIZE-1:0] first_din_135,
	input wire [QUAN_SIZE-1:0] first_din_136,
	input wire [QUAN_SIZE-1:0] first_din_137,
	input wire [QUAN_SIZE-1:0] first_din_138,
	input wire [QUAN_SIZE-1:0] first_din_139,
	input wire [QUAN_SIZE-1:0] first_din_140,
	input wire [QUAN_SIZE-1:0] first_din_141,
	input wire [QUAN_SIZE-1:0] first_din_142,
	input wire [QUAN_SIZE-1:0] first_din_143,
	input wire [QUAN_SIZE-1:0] first_din_144,
	input wire [QUAN_SIZE-1:0] first_din_145,
	input wire [QUAN_SIZE-1:0] first_din_146,
	input wire [QUAN_SIZE-1:0] first_din_147,
	input wire [QUAN_SIZE-1:0] first_din_148,
	input wire [QUAN_SIZE-1:0] first_din_149,
	input wire [QUAN_SIZE-1:0] first_din_150,
	input wire [QUAN_SIZE-1:0] first_din_151,
	input wire [QUAN_SIZE-1:0] first_din_152,
	input wire [QUAN_SIZE-1:0] first_din_153,
	input wire [QUAN_SIZE-1:0] first_din_154,
	input wire [QUAN_SIZE-1:0] first_din_155,
	input wire [QUAN_SIZE-1:0] first_din_156,
	input wire [QUAN_SIZE-1:0] first_din_157,
	input wire [QUAN_SIZE-1:0] first_din_158,
	input wire [QUAN_SIZE-1:0] first_din_159,
	input wire [QUAN_SIZE-1:0] first_din_160,
	input wire [QUAN_SIZE-1:0] first_din_161,
	input wire [QUAN_SIZE-1:0] first_din_162,
	input wire [QUAN_SIZE-1:0] first_din_163,
	input wire [QUAN_SIZE-1:0] first_din_164,
	input wire [QUAN_SIZE-1:0] first_din_165,
	input wire [QUAN_SIZE-1:0] first_din_166,
	input wire [QUAN_SIZE-1:0] first_din_167,
	input wire [QUAN_SIZE-1:0] first_din_168,
	input wire [QUAN_SIZE-1:0] first_din_169,
	input wire [QUAN_SIZE-1:0] first_din_170,
	input wire [QUAN_SIZE-1:0] first_din_171,
	input wire [QUAN_SIZE-1:0] first_din_172,
	input wire [QUAN_SIZE-1:0] first_din_173,
	input wire [QUAN_SIZE-1:0] first_din_174,
	input wire [QUAN_SIZE-1:0] first_din_175,
	input wire [QUAN_SIZE-1:0] first_din_176,
	input wire [QUAN_SIZE-1:0] first_din_177,
	input wire [QUAN_SIZE-1:0] first_din_178,
	input wire [QUAN_SIZE-1:0] first_din_179,
	input wire [QUAN_SIZE-1:0] first_din_180,
	input wire [QUAN_SIZE-1:0] first_din_181,
	input wire [QUAN_SIZE-1:0] first_din_182,
	input wire [QUAN_SIZE-1:0] first_din_183,
	input wire [QUAN_SIZE-1:0] first_din_184,
	input wire [QUAN_SIZE-1:0] first_din_185,
	input wire [QUAN_SIZE-1:0] first_din_186,
	input wire [QUAN_SIZE-1:0] first_din_187,
	input wire [QUAN_SIZE-1:0] first_din_188,
	input wire [QUAN_SIZE-1:0] first_din_189,
	input wire [QUAN_SIZE-1:0] first_din_190,
	input wire [QUAN_SIZE-1:0] first_din_191,
	input wire [QUAN_SIZE-1:0] first_din_192,
	input wire [QUAN_SIZE-1:0] first_din_193,
	input wire [QUAN_SIZE-1:0] first_din_194,
	input wire [QUAN_SIZE-1:0] first_din_195,
	input wire [QUAN_SIZE-1:0] first_din_196,
	input wire [QUAN_SIZE-1:0] first_din_197,
	input wire [QUAN_SIZE-1:0] first_din_198,
	input wire [QUAN_SIZE-1:0] first_din_199,
	input wire [QUAN_SIZE-1:0] first_din_200,
	input wire [QUAN_SIZE-1:0] first_din_201,
	input wire [QUAN_SIZE-1:0] first_din_202,
	input wire [QUAN_SIZE-1:0] first_din_203,
	input wire [QUAN_SIZE-1:0] first_din_204,
	input wire [QUAN_SIZE-1:0] first_din_205,
	input wire [QUAN_SIZE-1:0] first_din_206,
	input wire [QUAN_SIZE-1:0] first_din_207,
	input wire [QUAN_SIZE-1:0] first_din_208,
	input wire [QUAN_SIZE-1:0] first_din_209,
	input wire [QUAN_SIZE-1:0] first_din_210,
	input wire [QUAN_SIZE-1:0] first_din_211,
	input wire [QUAN_SIZE-1:0] first_din_212,
	input wire [QUAN_SIZE-1:0] first_din_213,
	input wire [QUAN_SIZE-1:0] first_din_214,
	input wire [QUAN_SIZE-1:0] first_din_215,
	input wire [QUAN_SIZE-1:0] first_din_216,
	input wire [QUAN_SIZE-1:0] first_din_217,
	input wire [QUAN_SIZE-1:0] first_din_218,
	input wire [QUAN_SIZE-1:0] first_din_219,
	input wire [QUAN_SIZE-1:0] first_din_220,
	input wire [QUAN_SIZE-1:0] first_din_221,
	input wire [QUAN_SIZE-1:0] first_din_222,
	input wire [QUAN_SIZE-1:0] first_din_223,
	input wire [QUAN_SIZE-1:0] first_din_224,
	input wire [QUAN_SIZE-1:0] first_din_225,
	input wire [QUAN_SIZE-1:0] first_din_226,
	input wire [QUAN_SIZE-1:0] first_din_227,
	input wire [QUAN_SIZE-1:0] first_din_228,
	input wire [QUAN_SIZE-1:0] first_din_229,
	input wire [QUAN_SIZE-1:0] first_din_230,
	input wire [QUAN_SIZE-1:0] first_din_231,
	input wire [QUAN_SIZE-1:0] first_din_232,
	input wire [QUAN_SIZE-1:0] first_din_233,
	input wire [QUAN_SIZE-1:0] first_din_234,
	input wire [QUAN_SIZE-1:0] first_din_235,
	input wire [QUAN_SIZE-1:0] first_din_236,
	input wire [QUAN_SIZE-1:0] first_din_237,
	input wire [QUAN_SIZE-1:0] first_din_238,
	input wire [QUAN_SIZE-1:0] first_din_239,
	input wire [QUAN_SIZE-1:0] first_din_240,
	input wire [QUAN_SIZE-1:0] first_din_241,
	input wire [QUAN_SIZE-1:0] first_din_242,
	input wire [QUAN_SIZE-1:0] first_din_243,
	input wire [QUAN_SIZE-1:0] first_din_244,
	input wire [QUAN_SIZE-1:0] first_din_245,
	input wire [QUAN_SIZE-1:0] first_din_246,
	input wire [QUAN_SIZE-1:0] first_din_247,
	input wire [QUAN_SIZE-1:0] first_din_248,
	input wire [QUAN_SIZE-1:0] first_din_249,
	input wire [QUAN_SIZE-1:0] first_din_250,
	input wire [QUAN_SIZE-1:0] first_din_251,
	input wire [QUAN_SIZE-1:0] first_din_252,
	input wire [QUAN_SIZE-1:0] first_din_253,
	input wire [QUAN_SIZE-1:0] first_din_254,

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
	input wire [QUAN_SIZE-1:0] second_din_85,
	input wire [QUAN_SIZE-1:0] second_din_86,
	input wire [QUAN_SIZE-1:0] second_din_87,
	input wire [QUAN_SIZE-1:0] second_din_88,
	input wire [QUAN_SIZE-1:0] second_din_89,
	input wire [QUAN_SIZE-1:0] second_din_90,
	input wire [QUAN_SIZE-1:0] second_din_91,
	input wire [QUAN_SIZE-1:0] second_din_92,
	input wire [QUAN_SIZE-1:0] second_din_93,
	input wire [QUAN_SIZE-1:0] second_din_94,
	input wire [QUAN_SIZE-1:0] second_din_95,
	input wire [QUAN_SIZE-1:0] second_din_96,
	input wire [QUAN_SIZE-1:0] second_din_97,
	input wire [QUAN_SIZE-1:0] second_din_98,
	input wire [QUAN_SIZE-1:0] second_din_99,
	input wire [QUAN_SIZE-1:0] second_din_100,
	input wire [QUAN_SIZE-1:0] second_din_101,
	input wire [QUAN_SIZE-1:0] second_din_102,
	input wire [QUAN_SIZE-1:0] second_din_103,
	input wire [QUAN_SIZE-1:0] second_din_104,
	input wire [QUAN_SIZE-1:0] second_din_105,
	input wire [QUAN_SIZE-1:0] second_din_106,
	input wire [QUAN_SIZE-1:0] second_din_107,
	input wire [QUAN_SIZE-1:0] second_din_108,
	input wire [QUAN_SIZE-1:0] second_din_109,
	input wire [QUAN_SIZE-1:0] second_din_110,
	input wire [QUAN_SIZE-1:0] second_din_111,
	input wire [QUAN_SIZE-1:0] second_din_112,
	input wire [QUAN_SIZE-1:0] second_din_113,
	input wire [QUAN_SIZE-1:0] second_din_114,
	input wire [QUAN_SIZE-1:0] second_din_115,
	input wire [QUAN_SIZE-1:0] second_din_116,
	input wire [QUAN_SIZE-1:0] second_din_117,
	input wire [QUAN_SIZE-1:0] second_din_118,
	input wire [QUAN_SIZE-1:0] second_din_119,
	input wire [QUAN_SIZE-1:0] second_din_120,
	input wire [QUAN_SIZE-1:0] second_din_121,
	input wire [QUAN_SIZE-1:0] second_din_122,
	input wire [QUAN_SIZE-1:0] second_din_123,
	input wire [QUAN_SIZE-1:0] second_din_124,
	input wire [QUAN_SIZE-1:0] second_din_125,
	input wire [QUAN_SIZE-1:0] second_din_126,
	input wire [QUAN_SIZE-1:0] second_din_127,
	input wire [QUAN_SIZE-1:0] second_din_128,
	input wire [QUAN_SIZE-1:0] second_din_129,
	input wire [QUAN_SIZE-1:0] second_din_130,
	input wire [QUAN_SIZE-1:0] second_din_131,
	input wire [QUAN_SIZE-1:0] second_din_132,
	input wire [QUAN_SIZE-1:0] second_din_133,
	input wire [QUAN_SIZE-1:0] second_din_134,
	input wire [QUAN_SIZE-1:0] second_din_135,
	input wire [QUAN_SIZE-1:0] second_din_136,
	input wire [QUAN_SIZE-1:0] second_din_137,
	input wire [QUAN_SIZE-1:0] second_din_138,
	input wire [QUAN_SIZE-1:0] second_din_139,
	input wire [QUAN_SIZE-1:0] second_din_140,
	input wire [QUAN_SIZE-1:0] second_din_141,
	input wire [QUAN_SIZE-1:0] second_din_142,
	input wire [QUAN_SIZE-1:0] second_din_143,
	input wire [QUAN_SIZE-1:0] second_din_144,
	input wire [QUAN_SIZE-1:0] second_din_145,
	input wire [QUAN_SIZE-1:0] second_din_146,
	input wire [QUAN_SIZE-1:0] second_din_147,
	input wire [QUAN_SIZE-1:0] second_din_148,
	input wire [QUAN_SIZE-1:0] second_din_149,
	input wire [QUAN_SIZE-1:0] second_din_150,
	input wire [QUAN_SIZE-1:0] second_din_151,
	input wire [QUAN_SIZE-1:0] second_din_152,
	input wire [QUAN_SIZE-1:0] second_din_153,
	input wire [QUAN_SIZE-1:0] second_din_154,
	input wire [QUAN_SIZE-1:0] second_din_155,
	input wire [QUAN_SIZE-1:0] second_din_156,
	input wire [QUAN_SIZE-1:0] second_din_157,
	input wire [QUAN_SIZE-1:0] second_din_158,
	input wire [QUAN_SIZE-1:0] second_din_159,
	input wire [QUAN_SIZE-1:0] second_din_160,
	input wire [QUAN_SIZE-1:0] second_din_161,
	input wire [QUAN_SIZE-1:0] second_din_162,
	input wire [QUAN_SIZE-1:0] second_din_163,
	input wire [QUAN_SIZE-1:0] second_din_164,
	input wire [QUAN_SIZE-1:0] second_din_165,
	input wire [QUAN_SIZE-1:0] second_din_166,
	input wire [QUAN_SIZE-1:0] second_din_167,
	input wire [QUAN_SIZE-1:0] second_din_168,
	input wire [QUAN_SIZE-1:0] second_din_169,
	input wire [QUAN_SIZE-1:0] second_din_170,
	input wire [QUAN_SIZE-1:0] second_din_171,
	input wire [QUAN_SIZE-1:0] second_din_172,
	input wire [QUAN_SIZE-1:0] second_din_173,
	input wire [QUAN_SIZE-1:0] second_din_174,
	input wire [QUAN_SIZE-1:0] second_din_175,
	input wire [QUAN_SIZE-1:0] second_din_176,
	input wire [QUAN_SIZE-1:0] second_din_177,
	input wire [QUAN_SIZE-1:0] second_din_178,
	input wire [QUAN_SIZE-1:0] second_din_179,
	input wire [QUAN_SIZE-1:0] second_din_180,
	input wire [QUAN_SIZE-1:0] second_din_181,
	input wire [QUAN_SIZE-1:0] second_din_182,
	input wire [QUAN_SIZE-1:0] second_din_183,
	input wire [QUAN_SIZE-1:0] second_din_184,
	input wire [QUAN_SIZE-1:0] second_din_185,
	input wire [QUAN_SIZE-1:0] second_din_186,
	input wire [QUAN_SIZE-1:0] second_din_187,
	input wire [QUAN_SIZE-1:0] second_din_188,
	input wire [QUAN_SIZE-1:0] second_din_189,
	input wire [QUAN_SIZE-1:0] second_din_190,
	input wire [QUAN_SIZE-1:0] second_din_191,
	input wire [QUAN_SIZE-1:0] second_din_192,
	input wire [QUAN_SIZE-1:0] second_din_193,
	input wire [QUAN_SIZE-1:0] second_din_194,
	input wire [QUAN_SIZE-1:0] second_din_195,
	input wire [QUAN_SIZE-1:0] second_din_196,
	input wire [QUAN_SIZE-1:0] second_din_197,
	input wire [QUAN_SIZE-1:0] second_din_198,
	input wire [QUAN_SIZE-1:0] second_din_199,
	input wire [QUAN_SIZE-1:0] second_din_200,
	input wire [QUAN_SIZE-1:0] second_din_201,
	input wire [QUAN_SIZE-1:0] second_din_202,
	input wire [QUAN_SIZE-1:0] second_din_203,
	input wire [QUAN_SIZE-1:0] second_din_204,
	input wire [QUAN_SIZE-1:0] second_din_205,
	input wire [QUAN_SIZE-1:0] second_din_206,
	input wire [QUAN_SIZE-1:0] second_din_207,
	input wire [QUAN_SIZE-1:0] second_din_208,
	input wire [QUAN_SIZE-1:0] second_din_209,
	input wire [QUAN_SIZE-1:0] second_din_210,
	input wire [QUAN_SIZE-1:0] second_din_211,
	input wire [QUAN_SIZE-1:0] second_din_212,
	input wire [QUAN_SIZE-1:0] second_din_213,
	input wire [QUAN_SIZE-1:0] second_din_214,
	input wire [QUAN_SIZE-1:0] second_din_215,
	input wire [QUAN_SIZE-1:0] second_din_216,
	input wire [QUAN_SIZE-1:0] second_din_217,
	input wire [QUAN_SIZE-1:0] second_din_218,
	input wire [QUAN_SIZE-1:0] second_din_219,
	input wire [QUAN_SIZE-1:0] second_din_220,
	input wire [QUAN_SIZE-1:0] second_din_221,
	input wire [QUAN_SIZE-1:0] second_din_222,
	input wire [QUAN_SIZE-1:0] second_din_223,
	input wire [QUAN_SIZE-1:0] second_din_224,
	input wire [QUAN_SIZE-1:0] second_din_225,
	input wire [QUAN_SIZE-1:0] second_din_226,
	input wire [QUAN_SIZE-1:0] second_din_227,
	input wire [QUAN_SIZE-1:0] second_din_228,
	input wire [QUAN_SIZE-1:0] second_din_229,
	input wire [QUAN_SIZE-1:0] second_din_230,
	input wire [QUAN_SIZE-1:0] second_din_231,
	input wire [QUAN_SIZE-1:0] second_din_232,
	input wire [QUAN_SIZE-1:0] second_din_233,
	input wire [QUAN_SIZE-1:0] second_din_234,
	input wire [QUAN_SIZE-1:0] second_din_235,
	input wire [QUAN_SIZE-1:0] second_din_236,
	input wire [QUAN_SIZE-1:0] second_din_237,
	input wire [QUAN_SIZE-1:0] second_din_238,
	input wire [QUAN_SIZE-1:0] second_din_239,
	input wire [QUAN_SIZE-1:0] second_din_240,
	input wire [QUAN_SIZE-1:0] second_din_241,
	input wire [QUAN_SIZE-1:0] second_din_242,
	input wire [QUAN_SIZE-1:0] second_din_243,
	input wire [QUAN_SIZE-1:0] second_din_244,
	input wire [QUAN_SIZE-1:0] second_din_245,
	input wire [QUAN_SIZE-1:0] second_din_246,
	input wire [QUAN_SIZE-1:0] second_din_247,
	input wire [QUAN_SIZE-1:0] second_din_248,
	input wire [QUAN_SIZE-1:0] second_din_249,
	input wire [QUAN_SIZE-1:0] second_din_250,
	input wire [QUAN_SIZE-1:0] second_din_251,
	input wire [QUAN_SIZE-1:0] second_din_252,
	input wire [QUAN_SIZE-1:0] second_din_253,
	input wire [QUAN_SIZE-1:0] second_din_254,

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
			.QUAN_SIZE (QUAN_SIZE), // 4
			.DEPTH (DEPTH), //1024
			.DATA_WIDTH (DATA_WIDTH), //36
			.ADDR_WIDTH  (ADDR_WIDTH )  //$clog2(DEPTH)
		) ram_unit_u0(
			.Dout_a ({
						dout_reg_0[i*RAM_PORTA_RANGE+0],
						dout_reg_0[i*RAM_PORTA_RANGE+1],
						dout_reg_0[i*RAM_PORTA_RANGE+2],
						dout_reg_0[i*RAM_PORTA_RANGE+3],
						dout_reg_0[i*RAM_PORTA_RANGE+4],
						dout_reg_0[i*RAM_PORTA_RANGE+5],
						dout_reg_0[i*RAM_PORTA_RANGE+6],
						dout_reg_0[i*RAM_PORTA_RANGE+7],
						dout_reg_0[i*RAM_PORTA_RANGE+8],
						dout_reg_0[i*RAM_PORTA_RANGE+9],
						dout_reg_0[i*RAM_PORTA_RANGE+10],
						dout_reg_0[i*RAM_PORTA_RANGE+11],
						dout_reg_0[i*RAM_PORTA_RANGE+12],
						dout_reg_0[i*RAM_PORTA_RANGE+13],
						dout_reg_0[i*RAM_PORTA_RANGE+14],
						dout_reg_0[i*RAM_PORTA_RANGE+15],
						dout_reg_0[i*RAM_PORTA_RANGE+16],
						dout_reg_0[i*RAM_PORTA_RANGE+17],
						dout_reg_0[i*RAM_PORTA_RANGE+18],
						dout_reg_0[i*RAM_PORTA_RANGE+19],
						dout_reg_0[i*RAM_PORTA_RANGE+20],
						dout_reg_0[i*RAM_PORTA_RANGE+21],
						dout_reg_0[i*RAM_PORTA_RANGE+22],
						dout_reg_0[i*RAM_PORTA_RANGE+23],
						dout_reg_0[i*RAM_PORTA_RANGE+24],
						dout_reg_0[i*RAM_PORTA_RANGE+25],
						dout_reg_0[i*RAM_PORTA_RANGE+26],
						dout_reg_0[i*RAM_PORTA_RANGE+27]
					 }
			),
			.Dout_b ({
						dout_reg_1[i*RAM_PORTA_RANGE+0],
						dout_reg_1[i*RAM_PORTA_RANGE+1],
						dout_reg_1[i*RAM_PORTA_RANGE+2],
						dout_reg_1[i*RAM_PORTA_RANGE+3],
						dout_reg_1[i*RAM_PORTA_RANGE+4],
						dout_reg_1[i*RAM_PORTA_RANGE+5],
						dout_reg_1[i*RAM_PORTA_RANGE+6],
						dout_reg_1[i*RAM_PORTA_RANGE+7],
						dout_reg_1[i*RAM_PORTA_RANGE+8],
						dout_reg_1[i*RAM_PORTA_RANGE+9],
						dout_reg_1[i*RAM_PORTA_RANGE+10],
						dout_reg_1[i*RAM_PORTA_RANGE+11],
						dout_reg_1[i*RAM_PORTA_RANGE+12],
						dout_reg_1[i*RAM_PORTA_RANGE+13],
						dout_reg_1[i*RAM_PORTA_RANGE+14],
						dout_reg_1[i*RAM_PORTA_RANGE+15],
						dout_reg_1[i*RAM_PORTA_RANGE+16],
						dout_reg_1[i*RAM_PORTA_RANGE+17],
						dout_reg_1[i*RAM_PORTA_RANGE+18],
						dout_reg_1[i*RAM_PORTA_RANGE+19],
						dout_reg_1[i*RAM_PORTA_RANGE+20],
						dout_reg_1[i*RAM_PORTA_RANGE+21],
						dout_reg_1[i*RAM_PORTA_RANGE+22],
						dout_reg_1[i*RAM_PORTA_RANGE+23],
						dout_reg_1[i*RAM_PORTA_RANGE+24],
						dout_reg_1[i*RAM_PORTA_RANGE+25],
						dout_reg_1[i*RAM_PORTA_RANGE+26],
						dout_reg_1[i*RAM_PORTA_RANGE+27]
					 }
			),	

			.Din_a ({
						din_reg_0[i*RAM_PORTA_RANGE+0],
						din_reg_0[i*RAM_PORTA_RANGE+1],
						din_reg_0[i*RAM_PORTA_RANGE+2],
						din_reg_0[i*RAM_PORTA_RANGE+3],
						din_reg_0[i*RAM_PORTA_RANGE+4],
						din_reg_0[i*RAM_PORTA_RANGE+5],
						din_reg_0[i*RAM_PORTA_RANGE+6],
						din_reg_0[i*RAM_PORTA_RANGE+7],
						din_reg_0[i*RAM_PORTA_RANGE+8],
						din_reg_0[i*RAM_PORTA_RANGE+9],
						din_reg_0[i*RAM_PORTA_RANGE+10],
						din_reg_0[i*RAM_PORTA_RANGE+11],
						din_reg_0[i*RAM_PORTA_RANGE+12],
						din_reg_0[i*RAM_PORTA_RANGE+13],
						din_reg_0[i*RAM_PORTA_RANGE+14],
						din_reg_0[i*RAM_PORTA_RANGE+15],
						din_reg_0[i*RAM_PORTA_RANGE+16],
						din_reg_0[i*RAM_PORTA_RANGE+17],
						din_reg_0[i*RAM_PORTA_RANGE+18],
						din_reg_0[i*RAM_PORTA_RANGE+19],
						din_reg_0[i*RAM_PORTA_RANGE+20],
						din_reg_0[i*RAM_PORTA_RANGE+21],
						din_reg_0[i*RAM_PORTA_RANGE+22],
						din_reg_0[i*RAM_PORTA_RANGE+23],
						din_reg_0[i*RAM_PORTA_RANGE+24],
						din_reg_0[i*RAM_PORTA_RANGE+25],
						din_reg_0[i*RAM_PORTA_RANGE+26],
						din_reg_0[i*RAM_PORTA_RANGE+27]
					 }
			),
			.Din_b ({
						din_reg_1[i*RAM_PORTA_RANGE+0],
						din_reg_1[i*RAM_PORTA_RANGE+1],
						din_reg_1[i*RAM_PORTA_RANGE+2],
						din_reg_1[i*RAM_PORTA_RANGE+3],
						din_reg_1[i*RAM_PORTA_RANGE+4],
						din_reg_1[i*RAM_PORTA_RANGE+5],
						din_reg_1[i*RAM_PORTA_RANGE+6],
						din_reg_1[i*RAM_PORTA_RANGE+7],
						din_reg_1[i*RAM_PORTA_RANGE+8],
						din_reg_1[i*RAM_PORTA_RANGE+9],
						din_reg_1[i*RAM_PORTA_RANGE+10],
						din_reg_1[i*RAM_PORTA_RANGE+11],
						din_reg_1[i*RAM_PORTA_RANGE+12],
						din_reg_1[i*RAM_PORTA_RANGE+13],
						din_reg_1[i*RAM_PORTA_RANGE+14],
						din_reg_1[i*RAM_PORTA_RANGE+15],
						din_reg_1[i*RAM_PORTA_RANGE+16],
						din_reg_1[i*RAM_PORTA_RANGE+17],
						din_reg_1[i*RAM_PORTA_RANGE+18],
						din_reg_1[i*RAM_PORTA_RANGE+19],
						din_reg_1[i*RAM_PORTA_RANGE+20],
						din_reg_1[i*RAM_PORTA_RANGE+21],
						din_reg_1[i*RAM_PORTA_RANGE+22],
						din_reg_1[i*RAM_PORTA_RANGE+23],
						din_reg_1[i*RAM_PORTA_RANGE+24],
						din_reg_1[i*RAM_PORTA_RANGE+25],
						din_reg_1[i*RAM_PORTA_RANGE+26],
						din_reg_1[i*RAM_PORTA_RANGE+27]
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
	.QUAN_SIZE (QUAN_SIZE), // 4
	.DEPTH (DEPTH), //1024
	.DATA_WIDTH (FRAG_DATA_WIDTH), //12
	.ADDR_WIDTH  (ADDR_WIDTH )  //$clog2(DEPTH)
) ram_unit_frag_u0(
	.Dout_a ({dout_reg_0[CHECK_PARALLELISM-3], dout_reg_0[CHECK_PARALLELISM-2], dout_reg_0[CHECK_PARALLELISM-1]}),
	.Dout_b ({dout_reg_1[CHECK_PARALLELISM-3], dout_reg_1[CHECK_PARALLELISM-2], dout_reg_1[CHECK_PARALLELISM-1]}),

	.Din_a ({din_reg_0[CHECK_PARALLELISM-3], din_reg_0[CHECK_PARALLELISM-2], din_reg_0[CHECK_PARALLELISM-1]}),
	.Din_b ({din_reg_1[CHECK_PARALLELISM-3], din_reg_1[CHECK_PARALLELISM-2], din_reg_1[CHECK_PARALLELISM-1]}),

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
assign first_dout_10[QUAN_SIZE-1:0 ] = dout_reg_0[10];
assign first_dout_11[QUAN_SIZE-1:0 ] = dout_reg_0[11];
assign first_dout_12[QUAN_SIZE-1:0 ] = dout_reg_0[12];
assign first_dout_13[QUAN_SIZE-1:0 ] = dout_reg_0[13];
assign first_dout_14[QUAN_SIZE-1:0 ] = dout_reg_0[14];
assign first_dout_15[QUAN_SIZE-1:0 ] = dout_reg_0[15];
assign first_dout_16[QUAN_SIZE-1:0 ] = dout_reg_0[16];
assign first_dout_17[QUAN_SIZE-1:0 ] = dout_reg_0[17];
assign first_dout_18[QUAN_SIZE-1:0 ] = dout_reg_0[18];
assign first_dout_19[QUAN_SIZE-1:0 ] = dout_reg_0[19];
assign first_dout_20[QUAN_SIZE-1:0 ] = dout_reg_0[20];
assign first_dout_21[QUAN_SIZE-1:0 ] = dout_reg_0[21];
assign first_dout_22[QUAN_SIZE-1:0 ] = dout_reg_0[22];
assign first_dout_23[QUAN_SIZE-1:0 ] = dout_reg_0[23];
assign first_dout_24[QUAN_SIZE-1:0 ] = dout_reg_0[24];
assign first_dout_25[QUAN_SIZE-1:0 ] = dout_reg_0[25];
assign first_dout_26[QUAN_SIZE-1:0 ] = dout_reg_0[26];
assign first_dout_27[QUAN_SIZE-1:0 ] = dout_reg_0[27];
assign first_dout_28[QUAN_SIZE-1:0 ] = dout_reg_0[28];
assign first_dout_29[QUAN_SIZE-1:0 ] = dout_reg_0[29];
assign first_dout_30[QUAN_SIZE-1:0 ] = dout_reg_0[30];
assign first_dout_31[QUAN_SIZE-1:0 ] = dout_reg_0[31];
assign first_dout_32[QUAN_SIZE-1:0 ] = dout_reg_0[32];
assign first_dout_33[QUAN_SIZE-1:0 ] = dout_reg_0[33];
assign first_dout_34[QUAN_SIZE-1:0 ] = dout_reg_0[34];
assign first_dout_35[QUAN_SIZE-1:0 ] = dout_reg_0[35];
assign first_dout_36[QUAN_SIZE-1:0 ] = dout_reg_0[36];
assign first_dout_37[QUAN_SIZE-1:0 ] = dout_reg_0[37];
assign first_dout_38[QUAN_SIZE-1:0 ] = dout_reg_0[38];
assign first_dout_39[QUAN_SIZE-1:0 ] = dout_reg_0[39];
assign first_dout_40[QUAN_SIZE-1:0 ] = dout_reg_0[40];
assign first_dout_41[QUAN_SIZE-1:0 ] = dout_reg_0[41];
assign first_dout_42[QUAN_SIZE-1:0 ] = dout_reg_0[42];
assign first_dout_43[QUAN_SIZE-1:0 ] = dout_reg_0[43];
assign first_dout_44[QUAN_SIZE-1:0 ] = dout_reg_0[44];
assign first_dout_45[QUAN_SIZE-1:0 ] = dout_reg_0[45];
assign first_dout_46[QUAN_SIZE-1:0 ] = dout_reg_0[46];
assign first_dout_47[QUAN_SIZE-1:0 ] = dout_reg_0[47];
assign first_dout_48[QUAN_SIZE-1:0 ] = dout_reg_0[48];
assign first_dout_49[QUAN_SIZE-1:0 ] = dout_reg_0[49];
assign first_dout_50[QUAN_SIZE-1:0 ] = dout_reg_0[50];
assign first_dout_51[QUAN_SIZE-1:0 ] = dout_reg_0[51];
assign first_dout_52[QUAN_SIZE-1:0 ] = dout_reg_0[52];
assign first_dout_53[QUAN_SIZE-1:0 ] = dout_reg_0[53];
assign first_dout_54[QUAN_SIZE-1:0 ] = dout_reg_0[54];
assign first_dout_55[QUAN_SIZE-1:0 ] = dout_reg_0[55];
assign first_dout_56[QUAN_SIZE-1:0 ] = dout_reg_0[56];
assign first_dout_57[QUAN_SIZE-1:0 ] = dout_reg_0[57];
assign first_dout_58[QUAN_SIZE-1:0 ] = dout_reg_0[58];
assign first_dout_59[QUAN_SIZE-1:0 ] = dout_reg_0[59];
assign first_dout_60[QUAN_SIZE-1:0 ] = dout_reg_0[60];
assign first_dout_61[QUAN_SIZE-1:0 ] = dout_reg_0[61];
assign first_dout_62[QUAN_SIZE-1:0 ] = dout_reg_0[62];
assign first_dout_63[QUAN_SIZE-1:0 ] = dout_reg_0[63];
assign first_dout_64[QUAN_SIZE-1:0 ] = dout_reg_0[64];
assign first_dout_65[QUAN_SIZE-1:0 ] = dout_reg_0[65];
assign first_dout_66[QUAN_SIZE-1:0 ] = dout_reg_0[66];
assign first_dout_67[QUAN_SIZE-1:0 ] = dout_reg_0[67];
assign first_dout_68[QUAN_SIZE-1:0 ] = dout_reg_0[68];
assign first_dout_69[QUAN_SIZE-1:0 ] = dout_reg_0[69];
assign first_dout_70[QUAN_SIZE-1:0 ] = dout_reg_0[70];
assign first_dout_71[QUAN_SIZE-1:0 ] = dout_reg_0[71];
assign first_dout_72[QUAN_SIZE-1:0 ] = dout_reg_0[72];
assign first_dout_73[QUAN_SIZE-1:0 ] = dout_reg_0[73];
assign first_dout_74[QUAN_SIZE-1:0 ] = dout_reg_0[74];
assign first_dout_75[QUAN_SIZE-1:0 ] = dout_reg_0[75];
assign first_dout_76[QUAN_SIZE-1:0 ] = dout_reg_0[76];
assign first_dout_77[QUAN_SIZE-1:0 ] = dout_reg_0[77];
assign first_dout_78[QUAN_SIZE-1:0 ] = dout_reg_0[78];
assign first_dout_79[QUAN_SIZE-1:0 ] = dout_reg_0[79];
assign first_dout_80[QUAN_SIZE-1:0 ] = dout_reg_0[80];
assign first_dout_81[QUAN_SIZE-1:0 ] = dout_reg_0[81];
assign first_dout_82[QUAN_SIZE-1:0 ] = dout_reg_0[82];
assign first_dout_83[QUAN_SIZE-1:0 ] = dout_reg_0[83];
assign first_dout_84[QUAN_SIZE-1:0 ] = dout_reg_0[84];
assign first_dout_85[QUAN_SIZE-1:0 ] = dout_reg_0[85];
assign first_dout_86[QUAN_SIZE-1:0 ] = dout_reg_0[86];
assign first_dout_87[QUAN_SIZE-1:0 ] = dout_reg_0[87];
assign first_dout_88[QUAN_SIZE-1:0 ] = dout_reg_0[88];
assign first_dout_89[QUAN_SIZE-1:0 ] = dout_reg_0[89];
assign first_dout_90[QUAN_SIZE-1:0 ] = dout_reg_0[90];
assign first_dout_91[QUAN_SIZE-1:0 ] = dout_reg_0[91];
assign first_dout_92[QUAN_SIZE-1:0 ] = dout_reg_0[92];
assign first_dout_93[QUAN_SIZE-1:0 ] = dout_reg_0[93];
assign first_dout_94[QUAN_SIZE-1:0 ] = dout_reg_0[94];
assign first_dout_95[QUAN_SIZE-1:0 ] = dout_reg_0[95];
assign first_dout_96[QUAN_SIZE-1:0 ] = dout_reg_0[96];
assign first_dout_97[QUAN_SIZE-1:0 ] = dout_reg_0[97];
assign first_dout_98[QUAN_SIZE-1:0 ] = dout_reg_0[98];
assign first_dout_99[QUAN_SIZE-1:0 ] = dout_reg_0[99];
assign first_dout_100[QUAN_SIZE-1:0 ] = dout_reg_0[100];
assign first_dout_101[QUAN_SIZE-1:0 ] = dout_reg_0[101];
assign first_dout_102[QUAN_SIZE-1:0 ] = dout_reg_0[102];
assign first_dout_103[QUAN_SIZE-1:0 ] = dout_reg_0[103];
assign first_dout_104[QUAN_SIZE-1:0 ] = dout_reg_0[104];
assign first_dout_105[QUAN_SIZE-1:0 ] = dout_reg_0[105];
assign first_dout_106[QUAN_SIZE-1:0 ] = dout_reg_0[106];
assign first_dout_107[QUAN_SIZE-1:0 ] = dout_reg_0[107];
assign first_dout_108[QUAN_SIZE-1:0 ] = dout_reg_0[108];
assign first_dout_109[QUAN_SIZE-1:0 ] = dout_reg_0[109];
assign first_dout_110[QUAN_SIZE-1:0 ] = dout_reg_0[110];
assign first_dout_111[QUAN_SIZE-1:0 ] = dout_reg_0[111];
assign first_dout_112[QUAN_SIZE-1:0 ] = dout_reg_0[112];
assign first_dout_113[QUAN_SIZE-1:0 ] = dout_reg_0[113];
assign first_dout_114[QUAN_SIZE-1:0 ] = dout_reg_0[114];
assign first_dout_115[QUAN_SIZE-1:0 ] = dout_reg_0[115];
assign first_dout_116[QUAN_SIZE-1:0 ] = dout_reg_0[116];
assign first_dout_117[QUAN_SIZE-1:0 ] = dout_reg_0[117];
assign first_dout_118[QUAN_SIZE-1:0 ] = dout_reg_0[118];
assign first_dout_119[QUAN_SIZE-1:0 ] = dout_reg_0[119];
assign first_dout_120[QUAN_SIZE-1:0 ] = dout_reg_0[120];
assign first_dout_121[QUAN_SIZE-1:0 ] = dout_reg_0[121];
assign first_dout_122[QUAN_SIZE-1:0 ] = dout_reg_0[122];
assign first_dout_123[QUAN_SIZE-1:0 ] = dout_reg_0[123];
assign first_dout_124[QUAN_SIZE-1:0 ] = dout_reg_0[124];
assign first_dout_125[QUAN_SIZE-1:0 ] = dout_reg_0[125];
assign first_dout_126[QUAN_SIZE-1:0 ] = dout_reg_0[126];
assign first_dout_127[QUAN_SIZE-1:0 ] = dout_reg_0[127];
assign first_dout_128[QUAN_SIZE-1:0 ] = dout_reg_0[128];
assign first_dout_129[QUAN_SIZE-1:0 ] = dout_reg_0[129];
assign first_dout_130[QUAN_SIZE-1:0 ] = dout_reg_0[130];
assign first_dout_131[QUAN_SIZE-1:0 ] = dout_reg_0[131];
assign first_dout_132[QUAN_SIZE-1:0 ] = dout_reg_0[132];
assign first_dout_133[QUAN_SIZE-1:0 ] = dout_reg_0[133];
assign first_dout_134[QUAN_SIZE-1:0 ] = dout_reg_0[134];
assign first_dout_135[QUAN_SIZE-1:0 ] = dout_reg_0[135];
assign first_dout_136[QUAN_SIZE-1:0 ] = dout_reg_0[136];
assign first_dout_137[QUAN_SIZE-1:0 ] = dout_reg_0[137];
assign first_dout_138[QUAN_SIZE-1:0 ] = dout_reg_0[138];
assign first_dout_139[QUAN_SIZE-1:0 ] = dout_reg_0[139];
assign first_dout_140[QUAN_SIZE-1:0 ] = dout_reg_0[140];
assign first_dout_141[QUAN_SIZE-1:0 ] = dout_reg_0[141];
assign first_dout_142[QUAN_SIZE-1:0 ] = dout_reg_0[142];
assign first_dout_143[QUAN_SIZE-1:0 ] = dout_reg_0[143];
assign first_dout_144[QUAN_SIZE-1:0 ] = dout_reg_0[144];
assign first_dout_145[QUAN_SIZE-1:0 ] = dout_reg_0[145];
assign first_dout_146[QUAN_SIZE-1:0 ] = dout_reg_0[146];
assign first_dout_147[QUAN_SIZE-1:0 ] = dout_reg_0[147];
assign first_dout_148[QUAN_SIZE-1:0 ] = dout_reg_0[148];
assign first_dout_149[QUAN_SIZE-1:0 ] = dout_reg_0[149];
assign first_dout_150[QUAN_SIZE-1:0 ] = dout_reg_0[150];
assign first_dout_151[QUAN_SIZE-1:0 ] = dout_reg_0[151];
assign first_dout_152[QUAN_SIZE-1:0 ] = dout_reg_0[152];
assign first_dout_153[QUAN_SIZE-1:0 ] = dout_reg_0[153];
assign first_dout_154[QUAN_SIZE-1:0 ] = dout_reg_0[154];
assign first_dout_155[QUAN_SIZE-1:0 ] = dout_reg_0[155];
assign first_dout_156[QUAN_SIZE-1:0 ] = dout_reg_0[156];
assign first_dout_157[QUAN_SIZE-1:0 ] = dout_reg_0[157];
assign first_dout_158[QUAN_SIZE-1:0 ] = dout_reg_0[158];
assign first_dout_159[QUAN_SIZE-1:0 ] = dout_reg_0[159];
assign first_dout_160[QUAN_SIZE-1:0 ] = dout_reg_0[160];
assign first_dout_161[QUAN_SIZE-1:0 ] = dout_reg_0[161];
assign first_dout_162[QUAN_SIZE-1:0 ] = dout_reg_0[162];
assign first_dout_163[QUAN_SIZE-1:0 ] = dout_reg_0[163];
assign first_dout_164[QUAN_SIZE-1:0 ] = dout_reg_0[164];
assign first_dout_165[QUAN_SIZE-1:0 ] = dout_reg_0[165];
assign first_dout_166[QUAN_SIZE-1:0 ] = dout_reg_0[166];
assign first_dout_167[QUAN_SIZE-1:0 ] = dout_reg_0[167];
assign first_dout_168[QUAN_SIZE-1:0 ] = dout_reg_0[168];
assign first_dout_169[QUAN_SIZE-1:0 ] = dout_reg_0[169];
assign first_dout_170[QUAN_SIZE-1:0 ] = dout_reg_0[170];
assign first_dout_171[QUAN_SIZE-1:0 ] = dout_reg_0[171];
assign first_dout_172[QUAN_SIZE-1:0 ] = dout_reg_0[172];
assign first_dout_173[QUAN_SIZE-1:0 ] = dout_reg_0[173];
assign first_dout_174[QUAN_SIZE-1:0 ] = dout_reg_0[174];
assign first_dout_175[QUAN_SIZE-1:0 ] = dout_reg_0[175];
assign first_dout_176[QUAN_SIZE-1:0 ] = dout_reg_0[176];
assign first_dout_177[QUAN_SIZE-1:0 ] = dout_reg_0[177];
assign first_dout_178[QUAN_SIZE-1:0 ] = dout_reg_0[178];
assign first_dout_179[QUAN_SIZE-1:0 ] = dout_reg_0[179];
assign first_dout_180[QUAN_SIZE-1:0 ] = dout_reg_0[180];
assign first_dout_181[QUAN_SIZE-1:0 ] = dout_reg_0[181];
assign first_dout_182[QUAN_SIZE-1:0 ] = dout_reg_0[182];
assign first_dout_183[QUAN_SIZE-1:0 ] = dout_reg_0[183];
assign first_dout_184[QUAN_SIZE-1:0 ] = dout_reg_0[184];
assign first_dout_185[QUAN_SIZE-1:0 ] = dout_reg_0[185];
assign first_dout_186[QUAN_SIZE-1:0 ] = dout_reg_0[186];
assign first_dout_187[QUAN_SIZE-1:0 ] = dout_reg_0[187];
assign first_dout_188[QUAN_SIZE-1:0 ] = dout_reg_0[188];
assign first_dout_189[QUAN_SIZE-1:0 ] = dout_reg_0[189];
assign first_dout_190[QUAN_SIZE-1:0 ] = dout_reg_0[190];
assign first_dout_191[QUAN_SIZE-1:0 ] = dout_reg_0[191];
assign first_dout_192[QUAN_SIZE-1:0 ] = dout_reg_0[192];
assign first_dout_193[QUAN_SIZE-1:0 ] = dout_reg_0[193];
assign first_dout_194[QUAN_SIZE-1:0 ] = dout_reg_0[194];
assign first_dout_195[QUAN_SIZE-1:0 ] = dout_reg_0[195];
assign first_dout_196[QUAN_SIZE-1:0 ] = dout_reg_0[196];
assign first_dout_197[QUAN_SIZE-1:0 ] = dout_reg_0[197];
assign first_dout_198[QUAN_SIZE-1:0 ] = dout_reg_0[198];
assign first_dout_199[QUAN_SIZE-1:0 ] = dout_reg_0[199];
assign first_dout_200[QUAN_SIZE-1:0 ] = dout_reg_0[200];
assign first_dout_201[QUAN_SIZE-1:0 ] = dout_reg_0[201];
assign first_dout_202[QUAN_SIZE-1:0 ] = dout_reg_0[202];
assign first_dout_203[QUAN_SIZE-1:0 ] = dout_reg_0[203];
assign first_dout_204[QUAN_SIZE-1:0 ] = dout_reg_0[204];
assign first_dout_205[QUAN_SIZE-1:0 ] = dout_reg_0[205];
assign first_dout_206[QUAN_SIZE-1:0 ] = dout_reg_0[206];
assign first_dout_207[QUAN_SIZE-1:0 ] = dout_reg_0[207];
assign first_dout_208[QUAN_SIZE-1:0 ] = dout_reg_0[208];
assign first_dout_209[QUAN_SIZE-1:0 ] = dout_reg_0[209];
assign first_dout_210[QUAN_SIZE-1:0 ] = dout_reg_0[210];
assign first_dout_211[QUAN_SIZE-1:0 ] = dout_reg_0[211];
assign first_dout_212[QUAN_SIZE-1:0 ] = dout_reg_0[212];
assign first_dout_213[QUAN_SIZE-1:0 ] = dout_reg_0[213];
assign first_dout_214[QUAN_SIZE-1:0 ] = dout_reg_0[214];
assign first_dout_215[QUAN_SIZE-1:0 ] = dout_reg_0[215];
assign first_dout_216[QUAN_SIZE-1:0 ] = dout_reg_0[216];
assign first_dout_217[QUAN_SIZE-1:0 ] = dout_reg_0[217];
assign first_dout_218[QUAN_SIZE-1:0 ] = dout_reg_0[218];
assign first_dout_219[QUAN_SIZE-1:0 ] = dout_reg_0[219];
assign first_dout_220[QUAN_SIZE-1:0 ] = dout_reg_0[220];
assign first_dout_221[QUAN_SIZE-1:0 ] = dout_reg_0[221];
assign first_dout_222[QUAN_SIZE-1:0 ] = dout_reg_0[222];
assign first_dout_223[QUAN_SIZE-1:0 ] = dout_reg_0[223];
assign first_dout_224[QUAN_SIZE-1:0 ] = dout_reg_0[224];
assign first_dout_225[QUAN_SIZE-1:0 ] = dout_reg_0[225];
assign first_dout_226[QUAN_SIZE-1:0 ] = dout_reg_0[226];
assign first_dout_227[QUAN_SIZE-1:0 ] = dout_reg_0[227];
assign first_dout_228[QUAN_SIZE-1:0 ] = dout_reg_0[228];
assign first_dout_229[QUAN_SIZE-1:0 ] = dout_reg_0[229];
assign first_dout_230[QUAN_SIZE-1:0 ] = dout_reg_0[230];
assign first_dout_231[QUAN_SIZE-1:0 ] = dout_reg_0[231];
assign first_dout_232[QUAN_SIZE-1:0 ] = dout_reg_0[232];
assign first_dout_233[QUAN_SIZE-1:0 ] = dout_reg_0[233];
assign first_dout_234[QUAN_SIZE-1:0 ] = dout_reg_0[234];
assign first_dout_235[QUAN_SIZE-1:0 ] = dout_reg_0[235];
assign first_dout_236[QUAN_SIZE-1:0 ] = dout_reg_0[236];
assign first_dout_237[QUAN_SIZE-1:0 ] = dout_reg_0[237];
assign first_dout_238[QUAN_SIZE-1:0 ] = dout_reg_0[238];
assign first_dout_239[QUAN_SIZE-1:0 ] = dout_reg_0[239];
assign first_dout_240[QUAN_SIZE-1:0 ] = dout_reg_0[240];
assign first_dout_241[QUAN_SIZE-1:0 ] = dout_reg_0[241];
assign first_dout_242[QUAN_SIZE-1:0 ] = dout_reg_0[242];
assign first_dout_243[QUAN_SIZE-1:0 ] = dout_reg_0[243];
assign first_dout_244[QUAN_SIZE-1:0 ] = dout_reg_0[244];
assign first_dout_245[QUAN_SIZE-1:0 ] = dout_reg_0[245];
assign first_dout_246[QUAN_SIZE-1:0 ] = dout_reg_0[246];
assign first_dout_247[QUAN_SIZE-1:0 ] = dout_reg_0[247];
assign first_dout_248[QUAN_SIZE-1:0 ] = dout_reg_0[248];
assign first_dout_249[QUAN_SIZE-1:0 ] = dout_reg_0[249];
assign first_dout_250[QUAN_SIZE-1:0 ] = dout_reg_0[250];
assign first_dout_251[QUAN_SIZE-1:0 ] = dout_reg_0[251];
assign first_dout_252[QUAN_SIZE-1:0 ] = dout_reg_0[252];
assign first_dout_253[QUAN_SIZE-1:0 ] = dout_reg_0[253];
assign first_dout_254[QUAN_SIZE-1:0 ] = dout_reg_0[254];

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
assign second_dout_10[QUAN_SIZE-1:0 ] = dout_reg_1[10 ];
assign second_dout_11[QUAN_SIZE-1:0 ] = dout_reg_1[11 ];
assign second_dout_12[QUAN_SIZE-1:0 ] = dout_reg_1[12 ];
assign second_dout_13[QUAN_SIZE-1:0 ] = dout_reg_1[13 ];
assign second_dout_14[QUAN_SIZE-1:0 ] = dout_reg_1[14 ];
assign second_dout_15[QUAN_SIZE-1:0 ] = dout_reg_1[15 ];
assign second_dout_16[QUAN_SIZE-1:0 ] = dout_reg_1[16 ];
assign second_dout_17[QUAN_SIZE-1:0 ] = dout_reg_1[17 ];
assign second_dout_18[QUAN_SIZE-1:0 ] = dout_reg_1[18 ];
assign second_dout_19[QUAN_SIZE-1:0 ] = dout_reg_1[19 ];
assign second_dout_20[QUAN_SIZE-1:0 ] = dout_reg_1[20 ];
assign second_dout_21[QUAN_SIZE-1:0 ] = dout_reg_1[21 ];
assign second_dout_22[QUAN_SIZE-1:0 ] = dout_reg_1[22 ];
assign second_dout_23[QUAN_SIZE-1:0 ] = dout_reg_1[23 ];
assign second_dout_24[QUAN_SIZE-1:0 ] = dout_reg_1[24 ];
assign second_dout_25[QUAN_SIZE-1:0 ] = dout_reg_1[25 ];
assign second_dout_26[QUAN_SIZE-1:0 ] = dout_reg_1[26 ];
assign second_dout_27[QUAN_SIZE-1:0 ] = dout_reg_1[27 ];
assign second_dout_28[QUAN_SIZE-1:0 ] = dout_reg_1[28 ];
assign second_dout_29[QUAN_SIZE-1:0 ] = dout_reg_1[29 ];
assign second_dout_30[QUAN_SIZE-1:0 ] = dout_reg_1[30 ];
assign second_dout_31[QUAN_SIZE-1:0 ] = dout_reg_1[31 ];
assign second_dout_32[QUAN_SIZE-1:0 ] = dout_reg_1[32 ];
assign second_dout_33[QUAN_SIZE-1:0 ] = dout_reg_1[33 ];
assign second_dout_34[QUAN_SIZE-1:0 ] = dout_reg_1[34 ];
assign second_dout_35[QUAN_SIZE-1:0 ] = dout_reg_1[35 ];
assign second_dout_36[QUAN_SIZE-1:0 ] = dout_reg_1[36 ];
assign second_dout_37[QUAN_SIZE-1:0 ] = dout_reg_1[37 ];
assign second_dout_38[QUAN_SIZE-1:0 ] = dout_reg_1[38 ];
assign second_dout_39[QUAN_SIZE-1:0 ] = dout_reg_1[39 ];
assign second_dout_40[QUAN_SIZE-1:0 ] = dout_reg_1[40 ];
assign second_dout_41[QUAN_SIZE-1:0 ] = dout_reg_1[41 ];
assign second_dout_42[QUAN_SIZE-1:0 ] = dout_reg_1[42 ];
assign second_dout_43[QUAN_SIZE-1:0 ] = dout_reg_1[43 ];
assign second_dout_44[QUAN_SIZE-1:0 ] = dout_reg_1[44 ];
assign second_dout_45[QUAN_SIZE-1:0 ] = dout_reg_1[45 ];
assign second_dout_46[QUAN_SIZE-1:0 ] = dout_reg_1[46 ];
assign second_dout_47[QUAN_SIZE-1:0 ] = dout_reg_1[47 ];
assign second_dout_48[QUAN_SIZE-1:0 ] = dout_reg_1[48 ];
assign second_dout_49[QUAN_SIZE-1:0 ] = dout_reg_1[49 ];
assign second_dout_50[QUAN_SIZE-1:0 ] = dout_reg_1[50 ];
assign second_dout_51[QUAN_SIZE-1:0 ] = dout_reg_1[51 ];
assign second_dout_52[QUAN_SIZE-1:0 ] = dout_reg_1[52 ];
assign second_dout_53[QUAN_SIZE-1:0 ] = dout_reg_1[53 ];
assign second_dout_54[QUAN_SIZE-1:0 ] = dout_reg_1[54 ];
assign second_dout_55[QUAN_SIZE-1:0 ] = dout_reg_1[55 ];
assign second_dout_56[QUAN_SIZE-1:0 ] = dout_reg_1[56 ];
assign second_dout_57[QUAN_SIZE-1:0 ] = dout_reg_1[57 ];
assign second_dout_58[QUAN_SIZE-1:0 ] = dout_reg_1[58 ];
assign second_dout_59[QUAN_SIZE-1:0 ] = dout_reg_1[59 ];
assign second_dout_60[QUAN_SIZE-1:0 ] = dout_reg_1[60 ];
assign second_dout_61[QUAN_SIZE-1:0 ] = dout_reg_1[61 ];
assign second_dout_62[QUAN_SIZE-1:0 ] = dout_reg_1[62 ];
assign second_dout_63[QUAN_SIZE-1:0 ] = dout_reg_1[63 ];
assign second_dout_64[QUAN_SIZE-1:0 ] = dout_reg_1[64 ];
assign second_dout_65[QUAN_SIZE-1:0 ] = dout_reg_1[65 ];
assign second_dout_66[QUAN_SIZE-1:0 ] = dout_reg_1[66 ];
assign second_dout_67[QUAN_SIZE-1:0 ] = dout_reg_1[67 ];
assign second_dout_68[QUAN_SIZE-1:0 ] = dout_reg_1[68 ];
assign second_dout_69[QUAN_SIZE-1:0 ] = dout_reg_1[69 ];
assign second_dout_70[QUAN_SIZE-1:0 ] = dout_reg_1[70 ];
assign second_dout_71[QUAN_SIZE-1:0 ] = dout_reg_1[71 ];
assign second_dout_72[QUAN_SIZE-1:0 ] = dout_reg_1[72 ];
assign second_dout_73[QUAN_SIZE-1:0 ] = dout_reg_1[73 ];
assign second_dout_74[QUAN_SIZE-1:0 ] = dout_reg_1[74 ];
assign second_dout_75[QUAN_SIZE-1:0 ] = dout_reg_1[75 ];
assign second_dout_76[QUAN_SIZE-1:0 ] = dout_reg_1[76 ];
assign second_dout_77[QUAN_SIZE-1:0 ] = dout_reg_1[77 ];
assign second_dout_78[QUAN_SIZE-1:0 ] = dout_reg_1[78 ];
assign second_dout_79[QUAN_SIZE-1:0 ] = dout_reg_1[79 ];
assign second_dout_80[QUAN_SIZE-1:0 ] = dout_reg_1[80 ];
assign second_dout_81[QUAN_SIZE-1:0 ] = dout_reg_1[81 ];
assign second_dout_82[QUAN_SIZE-1:0 ] = dout_reg_1[82 ];
assign second_dout_83[QUAN_SIZE-1:0 ] = dout_reg_1[83 ];
assign second_dout_84[QUAN_SIZE-1:0 ] = dout_reg_1[84 ];
assign second_dout_85[QUAN_SIZE-1:0 ] = dout_reg_1[85 ];
assign second_dout_86[QUAN_SIZE-1:0 ] = dout_reg_1[86 ];
assign second_dout_87[QUAN_SIZE-1:0 ] = dout_reg_1[87 ];
assign second_dout_88[QUAN_SIZE-1:0 ] = dout_reg_1[88 ];
assign second_dout_89[QUAN_SIZE-1:0 ] = dout_reg_1[89 ];
assign second_dout_90[QUAN_SIZE-1:0 ] = dout_reg_1[90 ];
assign second_dout_91[QUAN_SIZE-1:0 ] = dout_reg_1[91 ];
assign second_dout_92[QUAN_SIZE-1:0 ] = dout_reg_1[92 ];
assign second_dout_93[QUAN_SIZE-1:0 ] = dout_reg_1[93 ];
assign second_dout_94[QUAN_SIZE-1:0 ] = dout_reg_1[94 ];
assign second_dout_95[QUAN_SIZE-1:0 ] = dout_reg_1[95 ];
assign second_dout_96[QUAN_SIZE-1:0 ] = dout_reg_1[96 ];
assign second_dout_97[QUAN_SIZE-1:0 ] = dout_reg_1[97 ];
assign second_dout_98[QUAN_SIZE-1:0 ] = dout_reg_1[98 ];
assign second_dout_99[QUAN_SIZE-1:0 ] = dout_reg_1[99 ];
assign second_dout_100[QUAN_SIZE-1:0 ] = dout_reg_1[100 ];
assign second_dout_101[QUAN_SIZE-1:0 ] = dout_reg_1[101 ];
assign second_dout_102[QUAN_SIZE-1:0 ] = dout_reg_1[102 ];
assign second_dout_103[QUAN_SIZE-1:0 ] = dout_reg_1[103 ];
assign second_dout_104[QUAN_SIZE-1:0 ] = dout_reg_1[104 ];
assign second_dout_105[QUAN_SIZE-1:0 ] = dout_reg_1[105 ];
assign second_dout_106[QUAN_SIZE-1:0 ] = dout_reg_1[106 ];
assign second_dout_107[QUAN_SIZE-1:0 ] = dout_reg_1[107 ];
assign second_dout_108[QUAN_SIZE-1:0 ] = dout_reg_1[108 ];
assign second_dout_109[QUAN_SIZE-1:0 ] = dout_reg_1[109 ];
assign second_dout_110[QUAN_SIZE-1:0 ] = dout_reg_1[110 ];
assign second_dout_111[QUAN_SIZE-1:0 ] = dout_reg_1[111 ];
assign second_dout_112[QUAN_SIZE-1:0 ] = dout_reg_1[112 ];
assign second_dout_113[QUAN_SIZE-1:0 ] = dout_reg_1[113 ];
assign second_dout_114[QUAN_SIZE-1:0 ] = dout_reg_1[114 ];
assign second_dout_115[QUAN_SIZE-1:0 ] = dout_reg_1[115 ];
assign second_dout_116[QUAN_SIZE-1:0 ] = dout_reg_1[116 ];
assign second_dout_117[QUAN_SIZE-1:0 ] = dout_reg_1[117 ];
assign second_dout_118[QUAN_SIZE-1:0 ] = dout_reg_1[118 ];
assign second_dout_119[QUAN_SIZE-1:0 ] = dout_reg_1[119 ];
assign second_dout_120[QUAN_SIZE-1:0 ] = dout_reg_1[120 ];
assign second_dout_121[QUAN_SIZE-1:0 ] = dout_reg_1[121 ];
assign second_dout_122[QUAN_SIZE-1:0 ] = dout_reg_1[122 ];
assign second_dout_123[QUAN_SIZE-1:0 ] = dout_reg_1[123 ];
assign second_dout_124[QUAN_SIZE-1:0 ] = dout_reg_1[124 ];
assign second_dout_125[QUAN_SIZE-1:0 ] = dout_reg_1[125 ];
assign second_dout_126[QUAN_SIZE-1:0 ] = dout_reg_1[126 ];
assign second_dout_127[QUAN_SIZE-1:0 ] = dout_reg_1[127 ];
assign second_dout_128[QUAN_SIZE-1:0 ] = dout_reg_1[128 ];
assign second_dout_129[QUAN_SIZE-1:0 ] = dout_reg_1[129 ];
assign second_dout_130[QUAN_SIZE-1:0 ] = dout_reg_1[130 ];
assign second_dout_131[QUAN_SIZE-1:0 ] = dout_reg_1[131 ];
assign second_dout_132[QUAN_SIZE-1:0 ] = dout_reg_1[132 ];
assign second_dout_133[QUAN_SIZE-1:0 ] = dout_reg_1[133 ];
assign second_dout_134[QUAN_SIZE-1:0 ] = dout_reg_1[134 ];
assign second_dout_135[QUAN_SIZE-1:0 ] = dout_reg_1[135 ];
assign second_dout_136[QUAN_SIZE-1:0 ] = dout_reg_1[136 ];
assign second_dout_137[QUAN_SIZE-1:0 ] = dout_reg_1[137 ];
assign second_dout_138[QUAN_SIZE-1:0 ] = dout_reg_1[138 ];
assign second_dout_139[QUAN_SIZE-1:0 ] = dout_reg_1[139 ];
assign second_dout_140[QUAN_SIZE-1:0 ] = dout_reg_1[140 ];
assign second_dout_141[QUAN_SIZE-1:0 ] = dout_reg_1[141 ];
assign second_dout_142[QUAN_SIZE-1:0 ] = dout_reg_1[142 ];
assign second_dout_143[QUAN_SIZE-1:0 ] = dout_reg_1[143 ];
assign second_dout_144[QUAN_SIZE-1:0 ] = dout_reg_1[144 ];
assign second_dout_145[QUAN_SIZE-1:0 ] = dout_reg_1[145 ];
assign second_dout_146[QUAN_SIZE-1:0 ] = dout_reg_1[146 ];
assign second_dout_147[QUAN_SIZE-1:0 ] = dout_reg_1[147 ];
assign second_dout_148[QUAN_SIZE-1:0 ] = dout_reg_1[148 ];
assign second_dout_149[QUAN_SIZE-1:0 ] = dout_reg_1[149 ];
assign second_dout_150[QUAN_SIZE-1:0 ] = dout_reg_1[150 ];
assign second_dout_151[QUAN_SIZE-1:0 ] = dout_reg_1[151 ];
assign second_dout_152[QUAN_SIZE-1:0 ] = dout_reg_1[152 ];
assign second_dout_153[QUAN_SIZE-1:0 ] = dout_reg_1[153 ];
assign second_dout_154[QUAN_SIZE-1:0 ] = dout_reg_1[154 ];
assign second_dout_155[QUAN_SIZE-1:0 ] = dout_reg_1[155 ];
assign second_dout_156[QUAN_SIZE-1:0 ] = dout_reg_1[156 ];
assign second_dout_157[QUAN_SIZE-1:0 ] = dout_reg_1[157 ];
assign second_dout_158[QUAN_SIZE-1:0 ] = dout_reg_1[158 ];
assign second_dout_159[QUAN_SIZE-1:0 ] = dout_reg_1[159 ];
assign second_dout_160[QUAN_SIZE-1:0 ] = dout_reg_1[160 ];
assign second_dout_161[QUAN_SIZE-1:0 ] = dout_reg_1[161 ];
assign second_dout_162[QUAN_SIZE-1:0 ] = dout_reg_1[162 ];
assign second_dout_163[QUAN_SIZE-1:0 ] = dout_reg_1[163 ];
assign second_dout_164[QUAN_SIZE-1:0 ] = dout_reg_1[164 ];
assign second_dout_165[QUAN_SIZE-1:0 ] = dout_reg_1[165 ];
assign second_dout_166[QUAN_SIZE-1:0 ] = dout_reg_1[166 ];
assign second_dout_167[QUAN_SIZE-1:0 ] = dout_reg_1[167 ];
assign second_dout_168[QUAN_SIZE-1:0 ] = dout_reg_1[168 ];
assign second_dout_169[QUAN_SIZE-1:0 ] = dout_reg_1[169 ];
assign second_dout_170[QUAN_SIZE-1:0 ] = dout_reg_1[170 ];
assign second_dout_171[QUAN_SIZE-1:0 ] = dout_reg_1[171 ];
assign second_dout_172[QUAN_SIZE-1:0 ] = dout_reg_1[172 ];
assign second_dout_173[QUAN_SIZE-1:0 ] = dout_reg_1[173 ];
assign second_dout_174[QUAN_SIZE-1:0 ] = dout_reg_1[174 ];
assign second_dout_175[QUAN_SIZE-1:0 ] = dout_reg_1[175 ];
assign second_dout_176[QUAN_SIZE-1:0 ] = dout_reg_1[176 ];
assign second_dout_177[QUAN_SIZE-1:0 ] = dout_reg_1[177 ];
assign second_dout_178[QUAN_SIZE-1:0 ] = dout_reg_1[178 ];
assign second_dout_179[QUAN_SIZE-1:0 ] = dout_reg_1[179 ];
assign second_dout_180[QUAN_SIZE-1:0 ] = dout_reg_1[180 ];
assign second_dout_181[QUAN_SIZE-1:0 ] = dout_reg_1[181 ];
assign second_dout_182[QUAN_SIZE-1:0 ] = dout_reg_1[182 ];
assign second_dout_183[QUAN_SIZE-1:0 ] = dout_reg_1[183 ];
assign second_dout_184[QUAN_SIZE-1:0 ] = dout_reg_1[184 ];
assign second_dout_185[QUAN_SIZE-1:0 ] = dout_reg_1[185 ];
assign second_dout_186[QUAN_SIZE-1:0 ] = dout_reg_1[186 ];
assign second_dout_187[QUAN_SIZE-1:0 ] = dout_reg_1[187 ];
assign second_dout_188[QUAN_SIZE-1:0 ] = dout_reg_1[188 ];
assign second_dout_189[QUAN_SIZE-1:0 ] = dout_reg_1[189 ];
assign second_dout_190[QUAN_SIZE-1:0 ] = dout_reg_1[190 ];
assign second_dout_191[QUAN_SIZE-1:0 ] = dout_reg_1[191 ];
assign second_dout_192[QUAN_SIZE-1:0 ] = dout_reg_1[192 ];
assign second_dout_193[QUAN_SIZE-1:0 ] = dout_reg_1[193 ];
assign second_dout_194[QUAN_SIZE-1:0 ] = dout_reg_1[194 ];
assign second_dout_195[QUAN_SIZE-1:0 ] = dout_reg_1[195 ];
assign second_dout_196[QUAN_SIZE-1:0 ] = dout_reg_1[196 ];
assign second_dout_197[QUAN_SIZE-1:0 ] = dout_reg_1[197 ];
assign second_dout_198[QUAN_SIZE-1:0 ] = dout_reg_1[198 ];
assign second_dout_199[QUAN_SIZE-1:0 ] = dout_reg_1[199 ];
assign second_dout_200[QUAN_SIZE-1:0 ] = dout_reg_1[200 ];
assign second_dout_201[QUAN_SIZE-1:0 ] = dout_reg_1[201 ];
assign second_dout_202[QUAN_SIZE-1:0 ] = dout_reg_1[202 ];
assign second_dout_203[QUAN_SIZE-1:0 ] = dout_reg_1[203 ];
assign second_dout_204[QUAN_SIZE-1:0 ] = dout_reg_1[204 ];
assign second_dout_205[QUAN_SIZE-1:0 ] = dout_reg_1[205 ];
assign second_dout_206[QUAN_SIZE-1:0 ] = dout_reg_1[206 ];
assign second_dout_207[QUAN_SIZE-1:0 ] = dout_reg_1[207 ];
assign second_dout_208[QUAN_SIZE-1:0 ] = dout_reg_1[208 ];
assign second_dout_209[QUAN_SIZE-1:0 ] = dout_reg_1[209 ];
assign second_dout_210[QUAN_SIZE-1:0 ] = dout_reg_1[210 ];
assign second_dout_211[QUAN_SIZE-1:0 ] = dout_reg_1[211 ];
assign second_dout_212[QUAN_SIZE-1:0 ] = dout_reg_1[212 ];
assign second_dout_213[QUAN_SIZE-1:0 ] = dout_reg_1[213 ];
assign second_dout_214[QUAN_SIZE-1:0 ] = dout_reg_1[214 ];
assign second_dout_215[QUAN_SIZE-1:0 ] = dout_reg_1[215 ];
assign second_dout_216[QUAN_SIZE-1:0 ] = dout_reg_1[216 ];
assign second_dout_217[QUAN_SIZE-1:0 ] = dout_reg_1[217 ];
assign second_dout_218[QUAN_SIZE-1:0 ] = dout_reg_1[218 ];
assign second_dout_219[QUAN_SIZE-1:0 ] = dout_reg_1[219 ];
assign second_dout_220[QUAN_SIZE-1:0 ] = dout_reg_1[220 ];
assign second_dout_221[QUAN_SIZE-1:0 ] = dout_reg_1[221 ];
assign second_dout_222[QUAN_SIZE-1:0 ] = dout_reg_1[222 ];
assign second_dout_223[QUAN_SIZE-1:0 ] = dout_reg_1[223 ];
assign second_dout_224[QUAN_SIZE-1:0 ] = dout_reg_1[224 ];
assign second_dout_225[QUAN_SIZE-1:0 ] = dout_reg_1[225 ];
assign second_dout_226[QUAN_SIZE-1:0 ] = dout_reg_1[226 ];
assign second_dout_227[QUAN_SIZE-1:0 ] = dout_reg_1[227 ];
assign second_dout_228[QUAN_SIZE-1:0 ] = dout_reg_1[228 ];
assign second_dout_229[QUAN_SIZE-1:0 ] = dout_reg_1[229 ];
assign second_dout_230[QUAN_SIZE-1:0 ] = dout_reg_1[230 ];
assign second_dout_231[QUAN_SIZE-1:0 ] = dout_reg_1[231 ];
assign second_dout_232[QUAN_SIZE-1:0 ] = dout_reg_1[232 ];
assign second_dout_233[QUAN_SIZE-1:0 ] = dout_reg_1[233 ];
assign second_dout_234[QUAN_SIZE-1:0 ] = dout_reg_1[234 ];
assign second_dout_235[QUAN_SIZE-1:0 ] = dout_reg_1[235 ];
assign second_dout_236[QUAN_SIZE-1:0 ] = dout_reg_1[236 ];
assign second_dout_237[QUAN_SIZE-1:0 ] = dout_reg_1[237 ];
assign second_dout_238[QUAN_SIZE-1:0 ] = dout_reg_1[238 ];
assign second_dout_239[QUAN_SIZE-1:0 ] = dout_reg_1[239 ];
assign second_dout_240[QUAN_SIZE-1:0 ] = dout_reg_1[240 ];
assign second_dout_241[QUAN_SIZE-1:0 ] = dout_reg_1[241 ];
assign second_dout_242[QUAN_SIZE-1:0 ] = dout_reg_1[242 ];
assign second_dout_243[QUAN_SIZE-1:0 ] = dout_reg_1[243 ];
assign second_dout_244[QUAN_SIZE-1:0 ] = dout_reg_1[244 ];
assign second_dout_245[QUAN_SIZE-1:0 ] = dout_reg_1[245 ];
assign second_dout_246[QUAN_SIZE-1:0 ] = dout_reg_1[246 ];
assign second_dout_247[QUAN_SIZE-1:0 ] = dout_reg_1[247 ];
assign second_dout_248[QUAN_SIZE-1:0 ] = dout_reg_1[248 ];
assign second_dout_249[QUAN_SIZE-1:0 ] = dout_reg_1[249 ];
assign second_dout_250[QUAN_SIZE-1:0 ] = dout_reg_1[250 ];
assign second_dout_251[QUAN_SIZE-1:0 ] = dout_reg_1[251 ];
assign second_dout_252[QUAN_SIZE-1:0 ] = dout_reg_1[252 ];
assign second_dout_253[QUAN_SIZE-1:0 ] = dout_reg_1[253 ];
assign second_dout_254[QUAN_SIZE-1:0 ] = dout_reg_1[254 ];

assign din_reg_0[0] = first_din_0[QUAN_SIZE-1:0];
assign din_reg_0[1] = first_din_1[QUAN_SIZE-1:0];
assign din_reg_0[2] = first_din_2[QUAN_SIZE-1:0];
assign din_reg_0[3] = first_din_3[QUAN_SIZE-1:0];
assign din_reg_0[4] = first_din_4[QUAN_SIZE-1:0];
assign din_reg_0[5] = first_din_5[QUAN_SIZE-1:0];
assign din_reg_0[6] = first_din_6[QUAN_SIZE-1:0];
assign din_reg_0[7] = first_din_7[QUAN_SIZE-1:0];
assign din_reg_0[8] = first_din_8[QUAN_SIZE-1:0];
assign din_reg_0[9] = first_din_9[QUAN_SIZE-1:0];
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
assign din_reg_0[85] = first_din_85[QUAN_SIZE-1:0];
assign din_reg_0[86] = first_din_86[QUAN_SIZE-1:0];
assign din_reg_0[87] = first_din_87[QUAN_SIZE-1:0];
assign din_reg_0[88] = first_din_88[QUAN_SIZE-1:0];
assign din_reg_0[89] = first_din_89[QUAN_SIZE-1:0];
assign din_reg_0[90] = first_din_90[QUAN_SIZE-1:0];
assign din_reg_0[91] = first_din_91[QUAN_SIZE-1:0];
assign din_reg_0[92] = first_din_92[QUAN_SIZE-1:0];
assign din_reg_0[93] = first_din_93[QUAN_SIZE-1:0];
assign din_reg_0[94] = first_din_94[QUAN_SIZE-1:0];
assign din_reg_0[95] = first_din_95[QUAN_SIZE-1:0];
assign din_reg_0[96] = first_din_96[QUAN_SIZE-1:0];
assign din_reg_0[97] = first_din_97[QUAN_SIZE-1:0];
assign din_reg_0[98] = first_din_98[QUAN_SIZE-1:0];
assign din_reg_0[99] = first_din_99[QUAN_SIZE-1:0];
assign din_reg_0[100] = first_din_100[QUAN_SIZE-1:0];
assign din_reg_0[101] = first_din_101[QUAN_SIZE-1:0];
assign din_reg_0[102] = first_din_102[QUAN_SIZE-1:0];
assign din_reg_0[103] = first_din_103[QUAN_SIZE-1:0];
assign din_reg_0[104] = first_din_104[QUAN_SIZE-1:0];
assign din_reg_0[105] = first_din_105[QUAN_SIZE-1:0];
assign din_reg_0[106] = first_din_106[QUAN_SIZE-1:0];
assign din_reg_0[107] = first_din_107[QUAN_SIZE-1:0];
assign din_reg_0[108] = first_din_108[QUAN_SIZE-1:0];
assign din_reg_0[109] = first_din_109[QUAN_SIZE-1:0];
assign din_reg_0[110] = first_din_110[QUAN_SIZE-1:0];
assign din_reg_0[111] = first_din_111[QUAN_SIZE-1:0];
assign din_reg_0[112] = first_din_112[QUAN_SIZE-1:0];
assign din_reg_0[113] = first_din_113[QUAN_SIZE-1:0];
assign din_reg_0[114] = first_din_114[QUAN_SIZE-1:0];
assign din_reg_0[115] = first_din_115[QUAN_SIZE-1:0];
assign din_reg_0[116] = first_din_116[QUAN_SIZE-1:0];
assign din_reg_0[117] = first_din_117[QUAN_SIZE-1:0];
assign din_reg_0[118] = first_din_118[QUAN_SIZE-1:0];
assign din_reg_0[119] = first_din_119[QUAN_SIZE-1:0];
assign din_reg_0[120] = first_din_120[QUAN_SIZE-1:0];
assign din_reg_0[121] = first_din_121[QUAN_SIZE-1:0];
assign din_reg_0[122] = first_din_122[QUAN_SIZE-1:0];
assign din_reg_0[123] = first_din_123[QUAN_SIZE-1:0];
assign din_reg_0[124] = first_din_124[QUAN_SIZE-1:0];
assign din_reg_0[125] = first_din_125[QUAN_SIZE-1:0];
assign din_reg_0[126] = first_din_126[QUAN_SIZE-1:0];
assign din_reg_0[127] = first_din_127[QUAN_SIZE-1:0];
assign din_reg_0[128] = first_din_128[QUAN_SIZE-1:0];
assign din_reg_0[129] = first_din_129[QUAN_SIZE-1:0];
assign din_reg_0[130] = first_din_130[QUAN_SIZE-1:0];
assign din_reg_0[131] = first_din_131[QUAN_SIZE-1:0];
assign din_reg_0[132] = first_din_132[QUAN_SIZE-1:0];
assign din_reg_0[133] = first_din_133[QUAN_SIZE-1:0];
assign din_reg_0[134] = first_din_134[QUAN_SIZE-1:0];
assign din_reg_0[135] = first_din_135[QUAN_SIZE-1:0];
assign din_reg_0[136] = first_din_136[QUAN_SIZE-1:0];
assign din_reg_0[137] = first_din_137[QUAN_SIZE-1:0];
assign din_reg_0[138] = first_din_138[QUAN_SIZE-1:0];
assign din_reg_0[139] = first_din_139[QUAN_SIZE-1:0];
assign din_reg_0[140] = first_din_140[QUAN_SIZE-1:0];
assign din_reg_0[141] = first_din_141[QUAN_SIZE-1:0];
assign din_reg_0[142] = first_din_142[QUAN_SIZE-1:0];
assign din_reg_0[143] = first_din_143[QUAN_SIZE-1:0];
assign din_reg_0[144] = first_din_144[QUAN_SIZE-1:0];
assign din_reg_0[145] = first_din_145[QUAN_SIZE-1:0];
assign din_reg_0[146] = first_din_146[QUAN_SIZE-1:0];
assign din_reg_0[147] = first_din_147[QUAN_SIZE-1:0];
assign din_reg_0[148] = first_din_148[QUAN_SIZE-1:0];
assign din_reg_0[149] = first_din_149[QUAN_SIZE-1:0];
assign din_reg_0[150] = first_din_150[QUAN_SIZE-1:0];
assign din_reg_0[151] = first_din_151[QUAN_SIZE-1:0];
assign din_reg_0[152] = first_din_152[QUAN_SIZE-1:0];
assign din_reg_0[153] = first_din_153[QUAN_SIZE-1:0];
assign din_reg_0[154] = first_din_154[QUAN_SIZE-1:0];
assign din_reg_0[155] = first_din_155[QUAN_SIZE-1:0];
assign din_reg_0[156] = first_din_156[QUAN_SIZE-1:0];
assign din_reg_0[157] = first_din_157[QUAN_SIZE-1:0];
assign din_reg_0[158] = first_din_158[QUAN_SIZE-1:0];
assign din_reg_0[159] = first_din_159[QUAN_SIZE-1:0];
assign din_reg_0[160] = first_din_160[QUAN_SIZE-1:0];
assign din_reg_0[161] = first_din_161[QUAN_SIZE-1:0];
assign din_reg_0[162] = first_din_162[QUAN_SIZE-1:0];
assign din_reg_0[163] = first_din_163[QUAN_SIZE-1:0];
assign din_reg_0[164] = first_din_164[QUAN_SIZE-1:0];
assign din_reg_0[165] = first_din_165[QUAN_SIZE-1:0];
assign din_reg_0[166] = first_din_166[QUAN_SIZE-1:0];
assign din_reg_0[167] = first_din_167[QUAN_SIZE-1:0];
assign din_reg_0[168] = first_din_168[QUAN_SIZE-1:0];
assign din_reg_0[169] = first_din_169[QUAN_SIZE-1:0];
assign din_reg_0[170] = first_din_170[QUAN_SIZE-1:0];
assign din_reg_0[171] = first_din_171[QUAN_SIZE-1:0];
assign din_reg_0[172] = first_din_172[QUAN_SIZE-1:0];
assign din_reg_0[173] = first_din_173[QUAN_SIZE-1:0];
assign din_reg_0[174] = first_din_174[QUAN_SIZE-1:0];
assign din_reg_0[175] = first_din_175[QUAN_SIZE-1:0];
assign din_reg_0[176] = first_din_176[QUAN_SIZE-1:0];
assign din_reg_0[177] = first_din_177[QUAN_SIZE-1:0];
assign din_reg_0[178] = first_din_178[QUAN_SIZE-1:0];
assign din_reg_0[179] = first_din_179[QUAN_SIZE-1:0];
assign din_reg_0[180] = first_din_180[QUAN_SIZE-1:0];
assign din_reg_0[181] = first_din_181[QUAN_SIZE-1:0];
assign din_reg_0[182] = first_din_182[QUAN_SIZE-1:0];
assign din_reg_0[183] = first_din_183[QUAN_SIZE-1:0];
assign din_reg_0[184] = first_din_184[QUAN_SIZE-1:0];
assign din_reg_0[185] = first_din_185[QUAN_SIZE-1:0];
assign din_reg_0[186] = first_din_186[QUAN_SIZE-1:0];
assign din_reg_0[187] = first_din_187[QUAN_SIZE-1:0];
assign din_reg_0[188] = first_din_188[QUAN_SIZE-1:0];
assign din_reg_0[189] = first_din_189[QUAN_SIZE-1:0];
assign din_reg_0[190] = first_din_190[QUAN_SIZE-1:0];
assign din_reg_0[191] = first_din_191[QUAN_SIZE-1:0];
assign din_reg_0[192] = first_din_192[QUAN_SIZE-1:0];
assign din_reg_0[193] = first_din_193[QUAN_SIZE-1:0];
assign din_reg_0[194] = first_din_194[QUAN_SIZE-1:0];
assign din_reg_0[195] = first_din_195[QUAN_SIZE-1:0];
assign din_reg_0[196] = first_din_196[QUAN_SIZE-1:0];
assign din_reg_0[197] = first_din_197[QUAN_SIZE-1:0];
assign din_reg_0[198] = first_din_198[QUAN_SIZE-1:0];
assign din_reg_0[199] = first_din_199[QUAN_SIZE-1:0];
assign din_reg_0[200] = first_din_200[QUAN_SIZE-1:0];
assign din_reg_0[201] = first_din_201[QUAN_SIZE-1:0];
assign din_reg_0[202] = first_din_202[QUAN_SIZE-1:0];
assign din_reg_0[203] = first_din_203[QUAN_SIZE-1:0];
assign din_reg_0[204] = first_din_204[QUAN_SIZE-1:0];
assign din_reg_0[205] = first_din_205[QUAN_SIZE-1:0];
assign din_reg_0[206] = first_din_206[QUAN_SIZE-1:0];
assign din_reg_0[207] = first_din_207[QUAN_SIZE-1:0];
assign din_reg_0[208] = first_din_208[QUAN_SIZE-1:0];
assign din_reg_0[209] = first_din_209[QUAN_SIZE-1:0];
assign din_reg_0[210] = first_din_210[QUAN_SIZE-1:0];
assign din_reg_0[211] = first_din_211[QUAN_SIZE-1:0];
assign din_reg_0[212] = first_din_212[QUAN_SIZE-1:0];
assign din_reg_0[213] = first_din_213[QUAN_SIZE-1:0];
assign din_reg_0[214] = first_din_214[QUAN_SIZE-1:0];
assign din_reg_0[215] = first_din_215[QUAN_SIZE-1:0];
assign din_reg_0[216] = first_din_216[QUAN_SIZE-1:0];
assign din_reg_0[217] = first_din_217[QUAN_SIZE-1:0];
assign din_reg_0[218] = first_din_218[QUAN_SIZE-1:0];
assign din_reg_0[219] = first_din_219[QUAN_SIZE-1:0];
assign din_reg_0[220] = first_din_220[QUAN_SIZE-1:0];
assign din_reg_0[221] = first_din_221[QUAN_SIZE-1:0];
assign din_reg_0[222] = first_din_222[QUAN_SIZE-1:0];
assign din_reg_0[223] = first_din_223[QUAN_SIZE-1:0];
assign din_reg_0[224] = first_din_224[QUAN_SIZE-1:0];
assign din_reg_0[225] = first_din_225[QUAN_SIZE-1:0];
assign din_reg_0[226] = first_din_226[QUAN_SIZE-1:0];
assign din_reg_0[227] = first_din_227[QUAN_SIZE-1:0];
assign din_reg_0[228] = first_din_228[QUAN_SIZE-1:0];
assign din_reg_0[229] = first_din_229[QUAN_SIZE-1:0];
assign din_reg_0[230] = first_din_230[QUAN_SIZE-1:0];
assign din_reg_0[231] = first_din_231[QUAN_SIZE-1:0];
assign din_reg_0[232] = first_din_232[QUAN_SIZE-1:0];
assign din_reg_0[233] = first_din_233[QUAN_SIZE-1:0];
assign din_reg_0[234] = first_din_234[QUAN_SIZE-1:0];
assign din_reg_0[235] = first_din_235[QUAN_SIZE-1:0];
assign din_reg_0[236] = first_din_236[QUAN_SIZE-1:0];
assign din_reg_0[237] = first_din_237[QUAN_SIZE-1:0];
assign din_reg_0[238] = first_din_238[QUAN_SIZE-1:0];
assign din_reg_0[239] = first_din_239[QUAN_SIZE-1:0];
assign din_reg_0[240] = first_din_240[QUAN_SIZE-1:0];
assign din_reg_0[241] = first_din_241[QUAN_SIZE-1:0];
assign din_reg_0[242] = first_din_242[QUAN_SIZE-1:0];
assign din_reg_0[243] = first_din_243[QUAN_SIZE-1:0];
assign din_reg_0[244] = first_din_244[QUAN_SIZE-1:0];
assign din_reg_0[245] = first_din_245[QUAN_SIZE-1:0];
assign din_reg_0[246] = first_din_246[QUAN_SIZE-1:0];
assign din_reg_0[247] = first_din_247[QUAN_SIZE-1:0];
assign din_reg_0[248] = first_din_248[QUAN_SIZE-1:0];
assign din_reg_0[249] = first_din_249[QUAN_SIZE-1:0];
assign din_reg_0[250] = first_din_250[QUAN_SIZE-1:0];
assign din_reg_0[251] = first_din_251[QUAN_SIZE-1:0];
assign din_reg_0[252] = first_din_252[QUAN_SIZE-1:0];
assign din_reg_0[253] = first_din_253[QUAN_SIZE-1:0];
assign din_reg_0[254] = first_din_254[QUAN_SIZE-1:0];

assign din_reg_1[0] = second_din_0[QUAN_SIZE-1:0];
assign din_reg_1[1] = second_din_1[QUAN_SIZE-1:0];
assign din_reg_1[2] = second_din_2[QUAN_SIZE-1:0];
assign din_reg_1[3] = second_din_3[QUAN_SIZE-1:0];
assign din_reg_1[4] = second_din_4[QUAN_SIZE-1:0];
assign din_reg_1[5] = second_din_5[QUAN_SIZE-1:0];
assign din_reg_1[6] = second_din_6[QUAN_SIZE-1:0];
assign din_reg_1[7] = second_din_7[QUAN_SIZE-1:0];
assign din_reg_1[8] = second_din_8[QUAN_SIZE-1:0];
assign din_reg_1[9] = second_din_9[QUAN_SIZE-1:0];
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
assign din_reg_1[85] = second_din_85[QUAN_SIZE-1:0];
assign din_reg_1[86] = second_din_86[QUAN_SIZE-1:0];
assign din_reg_1[87] = second_din_87[QUAN_SIZE-1:0];
assign din_reg_1[88] = second_din_88[QUAN_SIZE-1:0];
assign din_reg_1[89] = second_din_89[QUAN_SIZE-1:0];
assign din_reg_1[90] = second_din_90[QUAN_SIZE-1:0];
assign din_reg_1[91] = second_din_91[QUAN_SIZE-1:0];
assign din_reg_1[92] = second_din_92[QUAN_SIZE-1:0];
assign din_reg_1[93] = second_din_93[QUAN_SIZE-1:0];
assign din_reg_1[94] = second_din_94[QUAN_SIZE-1:0];
assign din_reg_1[95] = second_din_95[QUAN_SIZE-1:0];
assign din_reg_1[96] = second_din_96[QUAN_SIZE-1:0];
assign din_reg_1[97] = second_din_97[QUAN_SIZE-1:0];
assign din_reg_1[98] = second_din_98[QUAN_SIZE-1:0];
assign din_reg_1[99] = second_din_99[QUAN_SIZE-1:0];
assign din_reg_1[100] = second_din_100[QUAN_SIZE-1:0];
assign din_reg_1[101] = second_din_101[QUAN_SIZE-1:0];
assign din_reg_1[102] = second_din_102[QUAN_SIZE-1:0];
assign din_reg_1[103] = second_din_103[QUAN_SIZE-1:0];
assign din_reg_1[104] = second_din_104[QUAN_SIZE-1:0];
assign din_reg_1[105] = second_din_105[QUAN_SIZE-1:0];
assign din_reg_1[106] = second_din_106[QUAN_SIZE-1:0];
assign din_reg_1[107] = second_din_107[QUAN_SIZE-1:0];
assign din_reg_1[108] = second_din_108[QUAN_SIZE-1:0];
assign din_reg_1[109] = second_din_109[QUAN_SIZE-1:0];
assign din_reg_1[110] = second_din_110[QUAN_SIZE-1:0];
assign din_reg_1[111] = second_din_111[QUAN_SIZE-1:0];
assign din_reg_1[112] = second_din_112[QUAN_SIZE-1:0];
assign din_reg_1[113] = second_din_113[QUAN_SIZE-1:0];
assign din_reg_1[114] = second_din_114[QUAN_SIZE-1:0];
assign din_reg_1[115] = second_din_115[QUAN_SIZE-1:0];
assign din_reg_1[116] = second_din_116[QUAN_SIZE-1:0];
assign din_reg_1[117] = second_din_117[QUAN_SIZE-1:0];
assign din_reg_1[118] = second_din_118[QUAN_SIZE-1:0];
assign din_reg_1[119] = second_din_119[QUAN_SIZE-1:0];
assign din_reg_1[120] = second_din_120[QUAN_SIZE-1:0];
assign din_reg_1[121] = second_din_121[QUAN_SIZE-1:0];
assign din_reg_1[122] = second_din_122[QUAN_SIZE-1:0];
assign din_reg_1[123] = second_din_123[QUAN_SIZE-1:0];
assign din_reg_1[124] = second_din_124[QUAN_SIZE-1:0];
assign din_reg_1[125] = second_din_125[QUAN_SIZE-1:0];
assign din_reg_1[126] = second_din_126[QUAN_SIZE-1:0];
assign din_reg_1[127] = second_din_127[QUAN_SIZE-1:0];
assign din_reg_1[128] = second_din_128[QUAN_SIZE-1:0];
assign din_reg_1[129] = second_din_129[QUAN_SIZE-1:0];
assign din_reg_1[130] = second_din_130[QUAN_SIZE-1:0];
assign din_reg_1[131] = second_din_131[QUAN_SIZE-1:0];
assign din_reg_1[132] = second_din_132[QUAN_SIZE-1:0];
assign din_reg_1[133] = second_din_133[QUAN_SIZE-1:0];
assign din_reg_1[134] = second_din_134[QUAN_SIZE-1:0];
assign din_reg_1[135] = second_din_135[QUAN_SIZE-1:0];
assign din_reg_1[136] = second_din_136[QUAN_SIZE-1:0];
assign din_reg_1[137] = second_din_137[QUAN_SIZE-1:0];
assign din_reg_1[138] = second_din_138[QUAN_SIZE-1:0];
assign din_reg_1[139] = second_din_139[QUAN_SIZE-1:0];
assign din_reg_1[140] = second_din_140[QUAN_SIZE-1:0];
assign din_reg_1[141] = second_din_141[QUAN_SIZE-1:0];
assign din_reg_1[142] = second_din_142[QUAN_SIZE-1:0];
assign din_reg_1[143] = second_din_143[QUAN_SIZE-1:0];
assign din_reg_1[144] = second_din_144[QUAN_SIZE-1:0];
assign din_reg_1[145] = second_din_145[QUAN_SIZE-1:0];
assign din_reg_1[146] = second_din_146[QUAN_SIZE-1:0];
assign din_reg_1[147] = second_din_147[QUAN_SIZE-1:0];
assign din_reg_1[148] = second_din_148[QUAN_SIZE-1:0];
assign din_reg_1[149] = second_din_149[QUAN_SIZE-1:0];
assign din_reg_1[150] = second_din_150[QUAN_SIZE-1:0];
assign din_reg_1[151] = second_din_151[QUAN_SIZE-1:0];
assign din_reg_1[152] = second_din_152[QUAN_SIZE-1:0];
assign din_reg_1[153] = second_din_153[QUAN_SIZE-1:0];
assign din_reg_1[154] = second_din_154[QUAN_SIZE-1:0];
assign din_reg_1[155] = second_din_155[QUAN_SIZE-1:0];
assign din_reg_1[156] = second_din_156[QUAN_SIZE-1:0];
assign din_reg_1[157] = second_din_157[QUAN_SIZE-1:0];
assign din_reg_1[158] = second_din_158[QUAN_SIZE-1:0];
assign din_reg_1[159] = second_din_159[QUAN_SIZE-1:0];
assign din_reg_1[160] = second_din_160[QUAN_SIZE-1:0];
assign din_reg_1[161] = second_din_161[QUAN_SIZE-1:0];
assign din_reg_1[162] = second_din_162[QUAN_SIZE-1:0];
assign din_reg_1[163] = second_din_163[QUAN_SIZE-1:0];
assign din_reg_1[164] = second_din_164[QUAN_SIZE-1:0];
assign din_reg_1[165] = second_din_165[QUAN_SIZE-1:0];
assign din_reg_1[166] = second_din_166[QUAN_SIZE-1:0];
assign din_reg_1[167] = second_din_167[QUAN_SIZE-1:0];
assign din_reg_1[168] = second_din_168[QUAN_SIZE-1:0];
assign din_reg_1[169] = second_din_169[QUAN_SIZE-1:0];
assign din_reg_1[170] = second_din_170[QUAN_SIZE-1:0];
assign din_reg_1[171] = second_din_171[QUAN_SIZE-1:0];
assign din_reg_1[172] = second_din_172[QUAN_SIZE-1:0];
assign din_reg_1[173] = second_din_173[QUAN_SIZE-1:0];
assign din_reg_1[174] = second_din_174[QUAN_SIZE-1:0];
assign din_reg_1[175] = second_din_175[QUAN_SIZE-1:0];
assign din_reg_1[176] = second_din_176[QUAN_SIZE-1:0];
assign din_reg_1[177] = second_din_177[QUAN_SIZE-1:0];
assign din_reg_1[178] = second_din_178[QUAN_SIZE-1:0];
assign din_reg_1[179] = second_din_179[QUAN_SIZE-1:0];
assign din_reg_1[180] = second_din_180[QUAN_SIZE-1:0];
assign din_reg_1[181] = second_din_181[QUAN_SIZE-1:0];
assign din_reg_1[182] = second_din_182[QUAN_SIZE-1:0];
assign din_reg_1[183] = second_din_183[QUAN_SIZE-1:0];
assign din_reg_1[184] = second_din_184[QUAN_SIZE-1:0];
assign din_reg_1[185] = second_din_185[QUAN_SIZE-1:0];
assign din_reg_1[186] = second_din_186[QUAN_SIZE-1:0];
assign din_reg_1[187] = second_din_187[QUAN_SIZE-1:0];
assign din_reg_1[188] = second_din_188[QUAN_SIZE-1:0];
assign din_reg_1[189] = second_din_189[QUAN_SIZE-1:0];
assign din_reg_1[190] = second_din_190[QUAN_SIZE-1:0];
assign din_reg_1[191] = second_din_191[QUAN_SIZE-1:0];
assign din_reg_1[192] = second_din_192[QUAN_SIZE-1:0];
assign din_reg_1[193] = second_din_193[QUAN_SIZE-1:0];
assign din_reg_1[194] = second_din_194[QUAN_SIZE-1:0];
assign din_reg_1[195] = second_din_195[QUAN_SIZE-1:0];
assign din_reg_1[196] = second_din_196[QUAN_SIZE-1:0];
assign din_reg_1[197] = second_din_197[QUAN_SIZE-1:0];
assign din_reg_1[198] = second_din_198[QUAN_SIZE-1:0];
assign din_reg_1[199] = second_din_199[QUAN_SIZE-1:0];
assign din_reg_1[200] = second_din_200[QUAN_SIZE-1:0];
assign din_reg_1[201] = second_din_201[QUAN_SIZE-1:0];
assign din_reg_1[202] = second_din_202[QUAN_SIZE-1:0];
assign din_reg_1[203] = second_din_203[QUAN_SIZE-1:0];
assign din_reg_1[204] = second_din_204[QUAN_SIZE-1:0];
assign din_reg_1[205] = second_din_205[QUAN_SIZE-1:0];
assign din_reg_1[206] = second_din_206[QUAN_SIZE-1:0];
assign din_reg_1[207] = second_din_207[QUAN_SIZE-1:0];
assign din_reg_1[208] = second_din_208[QUAN_SIZE-1:0];
assign din_reg_1[209] = second_din_209[QUAN_SIZE-1:0];
assign din_reg_1[210] = second_din_210[QUAN_SIZE-1:0];
assign din_reg_1[211] = second_din_211[QUAN_SIZE-1:0];
assign din_reg_1[212] = second_din_212[QUAN_SIZE-1:0];
assign din_reg_1[213] = second_din_213[QUAN_SIZE-1:0];
assign din_reg_1[214] = second_din_214[QUAN_SIZE-1:0];
assign din_reg_1[215] = second_din_215[QUAN_SIZE-1:0];
assign din_reg_1[216] = second_din_216[QUAN_SIZE-1:0];
assign din_reg_1[217] = second_din_217[QUAN_SIZE-1:0];
assign din_reg_1[218] = second_din_218[QUAN_SIZE-1:0];
assign din_reg_1[219] = second_din_219[QUAN_SIZE-1:0];
assign din_reg_1[220] = second_din_220[QUAN_SIZE-1:0];
assign din_reg_1[221] = second_din_221[QUAN_SIZE-1:0];
assign din_reg_1[222] = second_din_222[QUAN_SIZE-1:0];
assign din_reg_1[223] = second_din_223[QUAN_SIZE-1:0];
assign din_reg_1[224] = second_din_224[QUAN_SIZE-1:0];
assign din_reg_1[225] = second_din_225[QUAN_SIZE-1:0];
assign din_reg_1[226] = second_din_226[QUAN_SIZE-1:0];
assign din_reg_1[227] = second_din_227[QUAN_SIZE-1:0];
assign din_reg_1[228] = second_din_228[QUAN_SIZE-1:0];
assign din_reg_1[229] = second_din_229[QUAN_SIZE-1:0];
assign din_reg_1[230] = second_din_230[QUAN_SIZE-1:0];
assign din_reg_1[231] = second_din_231[QUAN_SIZE-1:0];
assign din_reg_1[232] = second_din_232[QUAN_SIZE-1:0];
assign din_reg_1[233] = second_din_233[QUAN_SIZE-1:0];
assign din_reg_1[234] = second_din_234[QUAN_SIZE-1:0];
assign din_reg_1[235] = second_din_235[QUAN_SIZE-1:0];
assign din_reg_1[236] = second_din_236[QUAN_SIZE-1:0];
assign din_reg_1[237] = second_din_237[QUAN_SIZE-1:0];
assign din_reg_1[238] = second_din_238[QUAN_SIZE-1:0];
assign din_reg_1[239] = second_din_239[QUAN_SIZE-1:0];
assign din_reg_1[240] = second_din_240[QUAN_SIZE-1:0];
assign din_reg_1[241] = second_din_241[QUAN_SIZE-1:0];
assign din_reg_1[242] = second_din_242[QUAN_SIZE-1:0];
assign din_reg_1[243] = second_din_243[QUAN_SIZE-1:0];
assign din_reg_1[244] = second_din_244[QUAN_SIZE-1:0];
assign din_reg_1[245] = second_din_245[QUAN_SIZE-1:0];
assign din_reg_1[246] = second_din_246[QUAN_SIZE-1:0];
assign din_reg_1[247] = second_din_247[QUAN_SIZE-1:0];
assign din_reg_1[248] = second_din_248[QUAN_SIZE-1:0];
assign din_reg_1[249] = second_din_249[QUAN_SIZE-1:0];
assign din_reg_1[250] = second_din_250[QUAN_SIZE-1:0];
assign din_reg_1[251] = second_din_251[QUAN_SIZE-1:0];
assign din_reg_1[252] = second_din_252[QUAN_SIZE-1:0];
assign din_reg_1[253] = second_din_253[QUAN_SIZE-1:0];
assign din_reg_1[254] = second_din_254[QUAN_SIZE-1:0];
endmodule

module ram_unit #(
	parameter QUAN_SIZE = 4,
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
localparam PAGE_MSG_NUM = DATA_WIDTH / QUAN_SIZE;
 reg [DATA_WIDTH-1:0] ram_block [0:DEPTH-1];
 genvar i;
 generate
 	for(i=0;i<DEPTH;i=i+1) begin : ram_block_zeroInit_inst
 		initial ram_block[i] <= {PAGE_MSG_NUM{1'b0, {(QUAN_SIZE-1){1'b1}}}};
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
	parameter QUAN_SIZE = 4,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 12,
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
localparam PAGE_MSG_NUM = DATA_WIDTH / QUAN_SIZE;
 reg [DATA_WIDTH-1:0] ram_block [0:DEPTH-1];
 genvar i;
 generate
 	for(i=0;i<DEPTH;i=i+1) begin : ram_block_zeroInit_inst
 		initial ram_block[i] <= {PAGE_MSG_NUM{1'b0, {(QUAN_SIZE-1){1'b1}}}};
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