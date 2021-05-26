ib_proc_wrapper #(
	.CN_ROM_RD_BW          (CN_ROM_RD_BW         ),
	.CN_ROM_ADDR_BW        (CN_ROM_ADDR_BW       ),
	.CN_PAGE_ADDR_BW       (CN_PAGE_ADDR_BW      ),
	.CN_DEGREE             (CN_DEGREE            ),
	.IB_CNU_DECOMP_funNum  (IB_CNU_DECOMP_funNum ),
	.CN_NUM                (CN_NUM               ),
	.CNU6_INSTANTIATE_NUM  (CNU6_INSTANTIATE_NUM ),
	.CNU6_INSTANTIATE_UNIT (CNU6_INSTANTIATE_UNIT),

	.VN_ROM_RD_BW          (VN_ROM_RD_BW         ),
	.VN_ROM_ADDR_BW        (VN_ROM_ADDR_BW       ),
	.VN_PAGE_ADDR_BW       (VN_PAGE_ADDR_BW      ),
	.DN_ROM_RD_BW          (DN_ROM_RD_BW         ),
	.DN_ROM_ADDR_BW        (DN_ROM_ADDR_BW       ),
	.DN_PAGE_ADDR_BW       (DN_PAGE_ADDR_BW      ),
	.VN_DEGREE             (VN_DEGREE            ),
	.IB_VNU_DECOMP_funNum  (IB_VNU_DECOMP_funNum ),
	.VN_NUM                (VN_NUM               ),
	.VNU3_INSTANTIATE_NUM  (VNU3_INSTANTIATE_NUM ),
	.VNU3_INSTANTIATE_UNIT (VNU3_INSTANTIATE_UNIT),
	.QUAN_SIZE             (QUAN_SIZE            ),
	.DATAPATH_WIDTH        (DATAPATH_WIDTH       )
) ib_proc_u0 (
	.hard_decision (hard_decision[VN_NUM-1:0]),

	.ch_msg_0 (ch_msg_0[QUAN_SIZE-1:0]),
	.ch_msg_1 (ch_msg_1[QUAN_SIZE-1:0]),
	.ch_msg_2 (ch_msg_2[QUAN_SIZE-1:0]),
	.ch_msg_3 (ch_msg_3[QUAN_SIZE-1:0]),
	.ch_msg_4 (ch_msg_4[QUAN_SIZE-1:0]),
	.ch_msg_5 (ch_msg_5[QUAN_SIZE-1:0]),
	.ch_msg_6 (ch_msg_6[QUAN_SIZE-1:0]),
	.ch_msg_7 (ch_msg_7[QUAN_SIZE-1:0]),
	.ch_msg_8 (ch_msg_8[QUAN_SIZE-1:0]),
	.ch_msg_9 (ch_msg_9[QUAN_SIZE-1:0]),
	.ch_msg_10 (ch_msg_10[QUAN_SIZE-1:0]),
	.ch_msg_11 (ch_msg_11[QUAN_SIZE-1:0]),
	.ch_msg_12 (ch_msg_12[QUAN_SIZE-1:0]),
	.ch_msg_13 (ch_msg_13[QUAN_SIZE-1:0]),
	.ch_msg_14 (ch_msg_14[QUAN_SIZE-1:0]),
	.ch_msg_15 (ch_msg_15[QUAN_SIZE-1:0]),
	.ch_msg_16 (ch_msg_16[QUAN_SIZE-1:0]),
	.ch_msg_17 (ch_msg_17[QUAN_SIZE-1:0]),
	.ch_msg_18 (ch_msg_18[QUAN_SIZE-1:0]),
	.ch_msg_19 (ch_msg_19[QUAN_SIZE-1:0]),
	.ch_msg_20 (ch_msg_20[QUAN_SIZE-1:0]),
	.ch_msg_21 (ch_msg_21[QUAN_SIZE-1:0]),
	.ch_msg_22 (ch_msg_22[QUAN_SIZE-1:0]),
	.ch_msg_23 (ch_msg_23[QUAN_SIZE-1:0]),
	.ch_msg_24 (ch_msg_24[QUAN_SIZE-1:0]),
	.ch_msg_25 (ch_msg_25[QUAN_SIZE-1:0]),
	.ch_msg_26 (ch_msg_26[QUAN_SIZE-1:0]),
	.ch_msg_27 (ch_msg_27[QUAN_SIZE-1:0]),
	.ch_msg_28 (ch_msg_28[QUAN_SIZE-1:0]),
	.ch_msg_29 (ch_msg_29[QUAN_SIZE-1:0]),
	.ch_msg_30 (ch_msg_30[QUAN_SIZE-1:0]),
	.ch_msg_31 (ch_msg_31[QUAN_SIZE-1:0]),
	.ch_msg_32 (ch_msg_32[QUAN_SIZE-1:0]),
	.ch_msg_33 (ch_msg_33[QUAN_SIZE-1:0]),
	.ch_msg_34 (ch_msg_34[QUAN_SIZE-1:0]),
	.ch_msg_35 (ch_msg_35[QUAN_SIZE-1:0]),
	.ch_msg_36 (ch_msg_36[QUAN_SIZE-1:0]),
	.ch_msg_37 (ch_msg_37[QUAN_SIZE-1:0]),
	.ch_msg_38 (ch_msg_38[QUAN_SIZE-1:0]),
	.ch_msg_39 (ch_msg_39[QUAN_SIZE-1:0]),
	.ch_msg_40 (ch_msg_40[QUAN_SIZE-1:0]),
	.ch_msg_41 (ch_msg_41[QUAN_SIZE-1:0]),
	.ch_msg_42 (ch_msg_42[QUAN_SIZE-1:0]),
	.ch_msg_43 (ch_msg_43[QUAN_SIZE-1:0]),
	.ch_msg_44 (ch_msg_44[QUAN_SIZE-1:0]),
	.ch_msg_45 (ch_msg_45[QUAN_SIZE-1:0]),
	.ch_msg_46 (ch_msg_46[QUAN_SIZE-1:0]),
	.ch_msg_47 (ch_msg_47[QUAN_SIZE-1:0]),
	.ch_msg_48 (ch_msg_48[QUAN_SIZE-1:0]),
	.ch_msg_49 (ch_msg_49[QUAN_SIZE-1:0]),
	.ch_msg_50 (ch_msg_50[QUAN_SIZE-1:0]),
	.ch_msg_51 (ch_msg_51[QUAN_SIZE-1:0]),
	.ch_msg_52 (ch_msg_52[QUAN_SIZE-1:0]),
	.ch_msg_53 (ch_msg_53[QUAN_SIZE-1:0]),
	.ch_msg_54 (ch_msg_54[QUAN_SIZE-1:0]),
	.ch_msg_55 (ch_msg_55[QUAN_SIZE-1:0]),
	.ch_msg_56 (ch_msg_56[QUAN_SIZE-1:0]),
	.ch_msg_57 (ch_msg_57[QUAN_SIZE-1:0]),
	.ch_msg_58 (ch_msg_58[QUAN_SIZE-1:0]),
	.ch_msg_59 (ch_msg_59[QUAN_SIZE-1:0]),
	.ch_msg_60 (ch_msg_60[QUAN_SIZE-1:0]),
	.ch_msg_61 (ch_msg_61[QUAN_SIZE-1:0]),
	.ch_msg_62 (ch_msg_62[QUAN_SIZE-1:0]),
	.ch_msg_63 (ch_msg_63[QUAN_SIZE-1:0]),
	.ch_msg_64 (ch_msg_64[QUAN_SIZE-1:0]),
	.ch_msg_65 (ch_msg_65[QUAN_SIZE-1:0]),
	.ch_msg_66 (ch_msg_66[QUAN_SIZE-1:0]),
	.ch_msg_67 (ch_msg_67[QUAN_SIZE-1:0]),
	.ch_msg_68 (ch_msg_68[QUAN_SIZE-1:0]),
	.ch_msg_69 (ch_msg_69[QUAN_SIZE-1:0]),
	.ch_msg_70 (ch_msg_70[QUAN_SIZE-1:0]),
	.ch_msg_71 (ch_msg_71[QUAN_SIZE-1:0]),
	.ch_msg_72 (ch_msg_72[QUAN_SIZE-1:0]),
	.ch_msg_73 (ch_msg_73[QUAN_SIZE-1:0]),
	.ch_msg_74 (ch_msg_74[QUAN_SIZE-1:0]),
	.ch_msg_75 (ch_msg_75[QUAN_SIZE-1:0]),
	.ch_msg_76 (ch_msg_76[QUAN_SIZE-1:0]),
	.ch_msg_77 (ch_msg_77[QUAN_SIZE-1:0]),
	.ch_msg_78 (ch_msg_78[QUAN_SIZE-1:0]),
	.ch_msg_79 (ch_msg_79[QUAN_SIZE-1:0]),
	.ch_msg_80 (ch_msg_80[QUAN_SIZE-1:0]),
	.ch_msg_81 (ch_msg_81[QUAN_SIZE-1:0]),
	.ch_msg_82 (ch_msg_82[QUAN_SIZE-1:0]),
	.ch_msg_83 (ch_msg_83[QUAN_SIZE-1:0]),
	.ch_msg_84 (ch_msg_84[QUAN_SIZE-1:0]),
	.ch_msg_85 (ch_msg_85[QUAN_SIZE-1:0]),
	.ch_msg_86 (ch_msg_86[QUAN_SIZE-1:0]),
	.ch_msg_87 (ch_msg_87[QUAN_SIZE-1:0]),
	.ch_msg_88 (ch_msg_88[QUAN_SIZE-1:0]),
	.ch_msg_89 (ch_msg_89[QUAN_SIZE-1:0]),
	.ch_msg_90 (ch_msg_90[QUAN_SIZE-1:0]),
	.ch_msg_91 (ch_msg_91[QUAN_SIZE-1:0]),
	.ch_msg_92 (ch_msg_92[QUAN_SIZE-1:0]),
	.ch_msg_93 (ch_msg_93[QUAN_SIZE-1:0]),
	.ch_msg_94 (ch_msg_94[QUAN_SIZE-1:0]),
	.ch_msg_95 (ch_msg_95[QUAN_SIZE-1:0]),
	.ch_msg_96 (ch_msg_96[QUAN_SIZE-1:0]),
	.ch_msg_97 (ch_msg_97[QUAN_SIZE-1:0]),
	.ch_msg_98 (ch_msg_98[QUAN_SIZE-1:0]),
	.ch_msg_99 (ch_msg_99[QUAN_SIZE-1:0]),
	.ch_msg_100 (ch_msg_100[QUAN_SIZE-1:0]),
	.ch_msg_101 (ch_msg_101[QUAN_SIZE-1:0]),
	.ch_msg_102 (ch_msg_102[QUAN_SIZE-1:0]),
	.ch_msg_103 (ch_msg_103[QUAN_SIZE-1:0]),
	.ch_msg_104 (ch_msg_104[QUAN_SIZE-1:0]),
	.ch_msg_105 (ch_msg_105[QUAN_SIZE-1:0]),
	.ch_msg_106 (ch_msg_106[QUAN_SIZE-1:0]),
	.ch_msg_107 (ch_msg_107[QUAN_SIZE-1:0]),
	.ch_msg_108 (ch_msg_108[QUAN_SIZE-1:0]),
	.ch_msg_109 (ch_msg_109[QUAN_SIZE-1:0]),
	.ch_msg_110 (ch_msg_110[QUAN_SIZE-1:0]),
	.ch_msg_111 (ch_msg_111[QUAN_SIZE-1:0]),
	.ch_msg_112 (ch_msg_112[QUAN_SIZE-1:0]),
	.ch_msg_113 (ch_msg_113[QUAN_SIZE-1:0]),
	.ch_msg_114 (ch_msg_114[QUAN_SIZE-1:0]),
	.ch_msg_115 (ch_msg_115[QUAN_SIZE-1:0]),
	.ch_msg_116 (ch_msg_116[QUAN_SIZE-1:0]),
	.ch_msg_117 (ch_msg_117[QUAN_SIZE-1:0]),
	.ch_msg_118 (ch_msg_118[QUAN_SIZE-1:0]),
	.ch_msg_119 (ch_msg_119[QUAN_SIZE-1:0]),
	.ch_msg_120 (ch_msg_120[QUAN_SIZE-1:0]),
	.ch_msg_121 (ch_msg_121[QUAN_SIZE-1:0]),
	.ch_msg_122 (ch_msg_122[QUAN_SIZE-1:0]),
	.ch_msg_123 (ch_msg_123[QUAN_SIZE-1:0]),
	.ch_msg_124 (ch_msg_124[QUAN_SIZE-1:0]),
	.ch_msg_125 (ch_msg_125[QUAN_SIZE-1:0]),
	.ch_msg_126 (ch_msg_126[QUAN_SIZE-1:0]),
	.ch_msg_127 (ch_msg_127[QUAN_SIZE-1:0]),
	.ch_msg_128 (ch_msg_128[QUAN_SIZE-1:0]),
	.ch_msg_129 (ch_msg_129[QUAN_SIZE-1:0]),
	.ch_msg_130 (ch_msg_130[QUAN_SIZE-1:0]),
	.ch_msg_131 (ch_msg_131[QUAN_SIZE-1:0]),
	.ch_msg_132 (ch_msg_132[QUAN_SIZE-1:0]),
	.ch_msg_133 (ch_msg_133[QUAN_SIZE-1:0]),
	.ch_msg_134 (ch_msg_134[QUAN_SIZE-1:0]),
	.ch_msg_135 (ch_msg_135[QUAN_SIZE-1:0]),
	.ch_msg_136 (ch_msg_136[QUAN_SIZE-1:0]),
	.ch_msg_137 (ch_msg_137[QUAN_SIZE-1:0]),
	.ch_msg_138 (ch_msg_138[QUAN_SIZE-1:0]),
	.ch_msg_139 (ch_msg_139[QUAN_SIZE-1:0]),
	.ch_msg_140 (ch_msg_140[QUAN_SIZE-1:0]),
	.ch_msg_141 (ch_msg_141[QUAN_SIZE-1:0]),
	.ch_msg_142 (ch_msg_142[QUAN_SIZE-1:0]),
	.ch_msg_143 (ch_msg_143[QUAN_SIZE-1:0]),
	.ch_msg_144 (ch_msg_144[QUAN_SIZE-1:0]),
	.ch_msg_145 (ch_msg_145[QUAN_SIZE-1:0]),
	.ch_msg_146 (ch_msg_146[QUAN_SIZE-1:0]),
	.ch_msg_147 (ch_msg_147[QUAN_SIZE-1:0]),
	.ch_msg_148 (ch_msg_148[QUAN_SIZE-1:0]),
	.ch_msg_149 (ch_msg_149[QUAN_SIZE-1:0]),
	.ch_msg_150 (ch_msg_150[QUAN_SIZE-1:0]),
	.ch_msg_151 (ch_msg_151[QUAN_SIZE-1:0]),
	.ch_msg_152 (ch_msg_152[QUAN_SIZE-1:0]),
	.ch_msg_153 (ch_msg_153[QUAN_SIZE-1:0]),
	.ch_msg_154 (ch_msg_154[QUAN_SIZE-1:0]),
	.ch_msg_155 (ch_msg_155[QUAN_SIZE-1:0]),
	.ch_msg_156 (ch_msg_156[QUAN_SIZE-1:0]),
	.ch_msg_157 (ch_msg_157[QUAN_SIZE-1:0]),
	.ch_msg_158 (ch_msg_158[QUAN_SIZE-1:0]),
	.ch_msg_159 (ch_msg_159[QUAN_SIZE-1:0]),
	.ch_msg_160 (ch_msg_160[QUAN_SIZE-1:0]),
	.ch_msg_161 (ch_msg_161[QUAN_SIZE-1:0]),
	.ch_msg_162 (ch_msg_162[QUAN_SIZE-1:0]),
	.ch_msg_163 (ch_msg_163[QUAN_SIZE-1:0]),
	.ch_msg_164 (ch_msg_164[QUAN_SIZE-1:0]),
	.ch_msg_165 (ch_msg_165[QUAN_SIZE-1:0]),
	.ch_msg_166 (ch_msg_166[QUAN_SIZE-1:0]),
	.ch_msg_167 (ch_msg_167[QUAN_SIZE-1:0]),
	.ch_msg_168 (ch_msg_168[QUAN_SIZE-1:0]),
	.ch_msg_169 (ch_msg_169[QUAN_SIZE-1:0]),
	.ch_msg_170 (ch_msg_170[QUAN_SIZE-1:0]),
	.ch_msg_171 (ch_msg_171[QUAN_SIZE-1:0]),
	.ch_msg_172 (ch_msg_172[QUAN_SIZE-1:0]),
	.ch_msg_173 (ch_msg_173[QUAN_SIZE-1:0]),
	.ch_msg_174 (ch_msg_174[QUAN_SIZE-1:0]),
	.ch_msg_175 (ch_msg_175[QUAN_SIZE-1:0]),
	.ch_msg_176 (ch_msg_176[QUAN_SIZE-1:0]),
	.ch_msg_177 (ch_msg_177[QUAN_SIZE-1:0]),
	.ch_msg_178 (ch_msg_178[QUAN_SIZE-1:0]),
	.ch_msg_179 (ch_msg_179[QUAN_SIZE-1:0]),
	.ch_msg_180 (ch_msg_180[QUAN_SIZE-1:0]),
	.ch_msg_181 (ch_msg_181[QUAN_SIZE-1:0]),
	.ch_msg_182 (ch_msg_182[QUAN_SIZE-1:0]),
	.ch_msg_183 (ch_msg_183[QUAN_SIZE-1:0]),
	.ch_msg_184 (ch_msg_184[QUAN_SIZE-1:0]),
	.ch_msg_185 (ch_msg_185[QUAN_SIZE-1:0]),
	.ch_msg_186 (ch_msg_186[QUAN_SIZE-1:0]),
	.ch_msg_187 (ch_msg_187[QUAN_SIZE-1:0]),
	.ch_msg_188 (ch_msg_188[QUAN_SIZE-1:0]),
	.ch_msg_189 (ch_msg_189[QUAN_SIZE-1:0]),
	.ch_msg_190 (ch_msg_190[QUAN_SIZE-1:0]),
	.ch_msg_191 (ch_msg_191[QUAN_SIZE-1:0]),
	.ch_msg_192 (ch_msg_192[QUAN_SIZE-1:0]),
	.ch_msg_193 (ch_msg_193[QUAN_SIZE-1:0]),
	.ch_msg_194 (ch_msg_194[QUAN_SIZE-1:0]),
	.ch_msg_195 (ch_msg_195[QUAN_SIZE-1:0]),
	.ch_msg_196 (ch_msg_196[QUAN_SIZE-1:0]),
	.ch_msg_197 (ch_msg_197[QUAN_SIZE-1:0]),
	.ch_msg_198 (ch_msg_198[QUAN_SIZE-1:0]),
	.ch_msg_199 (ch_msg_199[QUAN_SIZE-1:0]),
	.ch_msg_200 (ch_msg_200[QUAN_SIZE-1:0]),
	.ch_msg_201 (ch_msg_201[QUAN_SIZE-1:0]),
	.ch_msg_202 (ch_msg_202[QUAN_SIZE-1:0]),
	.ch_msg_203 (ch_msg_203[QUAN_SIZE-1:0]),
	.read_clk (read_clk),
	.cnu_read_addr_offset (cnu_read_addr_offset),
	.vnu_read_addr_offset (vnu_read_addr_offset),
	.v2c_src (v2c_src[0]),
	.load({v2c_load[0], c2v_load[0]}),
	.parallel_en({v2c_msg_en[0], c2v_msg_en[0]}),

	// Iteration-Refresh Page Address
	.cnu_page_addr_ram_0 ({1'b0, cn_wr_page_addr[0]}),
	.cnu_page_addr_ram_1 ({1'b0, cn_wr_page_addr[1]}),
	.cnu_page_addr_ram_2 ({1'b0, cn_wr_page_addr[2]}),
	.cnu_page_addr_ram_3 ({1'b0, cn_wr_page_addr[3]}),
	.vnu_page_addr_ram_0 ({1'b0, vn_wr_page_addr[0]}),
	.vnu_page_addr_ram_1 ({1'b0, vn_wr_page_addr[1]}),
	.vnu_page_addr_ram_2 ({1'b0, dn_wr_page_addr[DN_PAGE_ADDR_BW-1:0]}), // the last one is for decision node
	//Iteration-Refresh Page Data
	.cnu_ram_write_dataA_0 (cn_latch_outA[0]), // from portA of IB-ROM
	.cnu_ram_write_dataB_0 (cn_latch_outB[0]), // from portB of IB-ROM
	.cnu_ram_write_dataA_1 (cn_latch_outA[1]), // from portA of IB-ROM
	.cnu_ram_write_dataB_1 (cn_latch_outB[1]), // from portB of IB-ROM
	.cnu_ram_write_dataA_2 (cn_latch_outA[2]), // from portA of IB-ROM
	.cnu_ram_write_dataB_2 (cn_latch_outB[2]), // from portB of IB-ROM
	.cnu_ram_write_dataA_3 (cn_latch_outA[3]), // from portA of IB-ROM
	.cnu_ram_write_dataB_3 (cn_latch_outB[3]), // from portB of IB-ROM
	.vnu_ram_write_dataA_0 (vn_latch_outA[0]), // from portA of IB-ROM
	.vnu_ram_write_dataB_0 (vn_latch_outB[0]), // from portB of IB-ROM
	.vnu_ram_write_dataA_1 (vn_latch_outA[1]), // from portA of IB-ROM
	.vnu_ram_write_dataB_1 (vn_latch_outB[1]), // from portB of IB-ROM
	.vnu_ram_write_dataA_2 (dn_latch_outA[DN_ROM_RD_BW-1:0]), // from portA of IB-ROM (for decision node)
	.vnu_ram_write_dataB_2 (dn_latch_outB[DN_ROM_RD_BW-1:0]), // from portB of IB-ROM (for decision node)

	.cnu_ib_ram_we (cn_ram_write_en[IB_CNU_DECOMP_funNum-1:0]),
	.vnu_ib_ram_we ({dn_ram_write_en, vn_ram_write_en[IB_VNU_DECOMP_funNum-1:0]}),
	.cn_write_clk (cn_write_clk),
	.vn_write_clk (vn_write_clk),
	.dn_write_clk (dn_write_clk)
);