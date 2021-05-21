module column_ram_pc85 #(
	parameter QUAN_SIZE = 4,
	parameter CHECK_PARALLELISM = 85,
	parameter RAM_UNIT_MSG_NUM = 17, // each RAM unit contributes 17 messages of size 4-bit
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 8, // 8 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 5,
	parameter DEPTH = 1024,
	parameter WIDTH = 36,
	parameter ADDR = $clog2(DEPTH)
) (
	output wire [QUAN_SIZE-1:0] Dout_0,
	output wire [QUAN_SIZE-1:0] Dout_1,
	output wire [QUAN_SIZE-1:0] Dout_2,
	output wire [QUAN_SIZE-1:0] Dout_3,
	output wire [QUAN_SIZE-1:0] Dout_4,
	output wire [QUAN_SIZE-1:0] Dout_5,
	output wire [QUAN_SIZE-1:0] Dout_6,
	output wire [QUAN_SIZE-1:0] Dout_7,
	output wire [QUAN_SIZE-1:0] Dout_8,
	output wire [QUAN_SIZE-1:0] Dout_9,
	output wire [QUAN_SIZE-1:0] Dout_10,
	output wire [QUAN_SIZE-1:0] Dout_11,
	output wire [QUAN_SIZE-1:0] Dout_12,
	output wire [QUAN_SIZE-1:0] Dout_13,
	output wire [QUAN_SIZE-1:0] Dout_14,
	output wire [QUAN_SIZE-1:0] Dout_15,
	output wire [QUAN_SIZE-1:0] Dout_16,
	output wire [QUAN_SIZE-1:0] Dout_17,
	output wire [QUAN_SIZE-1:0] Dout_18,
	output wire [QUAN_SIZE-1:0] Dout_19,
	output wire [QUAN_SIZE-1:0] Dout_20,
	output wire [QUAN_SIZE-1:0] Dout_21,
	output wire [QUAN_SIZE-1:0] Dout_22,
	output wire [QUAN_SIZE-1:0] Dout_23,
	output wire [QUAN_SIZE-1:0] Dout_24,
	output wire [QUAN_SIZE-1:0] Dout_25,
	output wire [QUAN_SIZE-1:0] Dout_26,
	output wire [QUAN_SIZE-1:0] Dout_27,
	output wire [QUAN_SIZE-1:0] Dout_28,
	output wire [QUAN_SIZE-1:0] Dout_29,
	output wire [QUAN_SIZE-1:0] Dout_30,
	output wire [QUAN_SIZE-1:0] Dout_31,
	output wire [QUAN_SIZE-1:0] Dout_32,
	output wire [QUAN_SIZE-1:0] Dout_33,
	output wire [QUAN_SIZE-1:0] Dout_34,
	output wire [QUAN_SIZE-1:0] Dout_35,
	output wire [QUAN_SIZE-1:0] Dout_36,
	output wire [QUAN_SIZE-1:0] Dout_37,
	output wire [QUAN_SIZE-1:0] Dout_38,
	output wire [QUAN_SIZE-1:0] Dout_39,
	output wire [QUAN_SIZE-1:0] Dout_40,
	output wire [QUAN_SIZE-1:0] Dout_41,
	output wire [QUAN_SIZE-1:0] Dout_42,
	output wire [QUAN_SIZE-1:0] Dout_43,
	output wire [QUAN_SIZE-1:0] Dout_44,
	output wire [QUAN_SIZE-1:0] Dout_45,
	output wire [QUAN_SIZE-1:0] Dout_46,
	output wire [QUAN_SIZE-1:0] Dout_47,
	output wire [QUAN_SIZE-1:0] Dout_48,
	output wire [QUAN_SIZE-1:0] Dout_49,
	output wire [QUAN_SIZE-1:0] Dout_50,
	output wire [QUAN_SIZE-1:0] Dout_51,
	output wire [QUAN_SIZE-1:0] Dout_52,
	output wire [QUAN_SIZE-1:0] Dout_53,
	output wire [QUAN_SIZE-1:0] Dout_54,
	output wire [QUAN_SIZE-1:0] Dout_55,
	output wire [QUAN_SIZE-1:0] Dout_56,
	output wire [QUAN_SIZE-1:0] Dout_57,
	output wire [QUAN_SIZE-1:0] Dout_58,
	output wire [QUAN_SIZE-1:0] Dout_59,
	output wire [QUAN_SIZE-1:0] Dout_60,
	output wire [QUAN_SIZE-1:0] Dout_61,
	output wire [QUAN_SIZE-1:0] Dout_62,
	output wire [QUAN_SIZE-1:0] Dout_63,
	output wire [QUAN_SIZE-1:0] Dout_64,
	output wire [QUAN_SIZE-1:0] Dout_65,
	output wire [QUAN_SIZE-1:0] Dout_66,
	output wire [QUAN_SIZE-1:0] Dout_67,
	output wire [QUAN_SIZE-1:0] Dout_68,
	output wire [QUAN_SIZE-1:0] Dout_69,
	output wire [QUAN_SIZE-1:0] Dout_70,
	output wire [QUAN_SIZE-1:0] Dout_71,
	output wire [QUAN_SIZE-1:0] Dout_72,
	output wire [QUAN_SIZE-1:0] Dout_73,
	output wire [QUAN_SIZE-1:0] Dout_74,
	output wire [QUAN_SIZE-1:0] Dout_75,
	output wire [QUAN_SIZE-1:0] Dout_76,
	output wire [QUAN_SIZE-1:0] Dout_77,
	output wire [QUAN_SIZE-1:0] Dout_78,
	output wire [QUAN_SIZE-1:0] Dout_79,
	output wire [QUAN_SIZE-1:0] Dout_80,
	output wire [QUAN_SIZE-1:0] Dout_81,
	output wire [QUAN_SIZE-1:0] Dout_82,
	output wire [QUAN_SIZE-1:0] Dout_83,
	output wire [QUAN_SIZE-1:0] Dout_84,

	input wire [QUAN_SIZE-1:0] Din_0,
	input wire [QUAN_SIZE-1:0] Din_1,
	input wire [QUAN_SIZE-1:0] Din_2,
	input wire [QUAN_SIZE-1:0] Din_3,
	input wire [QUAN_SIZE-1:0] Din_4,
	input wire [QUAN_SIZE-1:0] Din_5,
	input wire [QUAN_SIZE-1:0] Din_6,
	input wire [QUAN_SIZE-1:0] Din_7,
	input wire [QUAN_SIZE-1:0] Din_8,
	input wire [QUAN_SIZE-1:0] Din_9,
	input wire [QUAN_SIZE-1:0] Din_10,
	input wire [QUAN_SIZE-1:0] Din_11,
	input wire [QUAN_SIZE-1:0] Din_12,
	input wire [QUAN_SIZE-1:0] Din_13,
	input wire [QUAN_SIZE-1:0] Din_14,
	input wire [QUAN_SIZE-1:0] Din_15,
	input wire [QUAN_SIZE-1:0] Din_16,
	input wire [QUAN_SIZE-1:0] Din_17,
	input wire [QUAN_SIZE-1:0] Din_18,
	input wire [QUAN_SIZE-1:0] Din_19,
	input wire [QUAN_SIZE-1:0] Din_20,
	input wire [QUAN_SIZE-1:0] Din_21,
	input wire [QUAN_SIZE-1:0] Din_22,
	input wire [QUAN_SIZE-1:0] Din_23,
	input wire [QUAN_SIZE-1:0] Din_24,
	input wire [QUAN_SIZE-1:0] Din_25,
	input wire [QUAN_SIZE-1:0] Din_26,
	input wire [QUAN_SIZE-1:0] Din_27,
	input wire [QUAN_SIZE-1:0] Din_28,
	input wire [QUAN_SIZE-1:0] Din_29,
	input wire [QUAN_SIZE-1:0] Din_30,
	input wire [QUAN_SIZE-1:0] Din_31,
	input wire [QUAN_SIZE-1:0] Din_32,
	input wire [QUAN_SIZE-1:0] Din_33,
	input wire [QUAN_SIZE-1:0] Din_34,
	input wire [QUAN_SIZE-1:0] Din_35,
	input wire [QUAN_SIZE-1:0] Din_36,
	input wire [QUAN_SIZE-1:0] Din_37,
	input wire [QUAN_SIZE-1:0] Din_38,
	input wire [QUAN_SIZE-1:0] Din_39,
	input wire [QUAN_SIZE-1:0] Din_40,
	input wire [QUAN_SIZE-1:0] Din_41,
	input wire [QUAN_SIZE-1:0] Din_42,
	input wire [QUAN_SIZE-1:0] Din_43,
	input wire [QUAN_SIZE-1:0] Din_44,
	input wire [QUAN_SIZE-1:0] Din_45,
	input wire [QUAN_SIZE-1:0] Din_46,
	input wire [QUAN_SIZE-1:0] Din_47,
	input wire [QUAN_SIZE-1:0] Din_48,
	input wire [QUAN_SIZE-1:0] Din_49,
	input wire [QUAN_SIZE-1:0] Din_50,
	input wire [QUAN_SIZE-1:0] Din_51,
	input wire [QUAN_SIZE-1:0] Din_52,
	input wire [QUAN_SIZE-1:0] Din_53,
	input wire [QUAN_SIZE-1:0] Din_54,
	input wire [QUAN_SIZE-1:0] Din_55,
	input wire [QUAN_SIZE-1:0] Din_56,
	input wire [QUAN_SIZE-1:0] Din_57,
	input wire [QUAN_SIZE-1:0] Din_58,
	input wire [QUAN_SIZE-1:0] Din_59,
	input wire [QUAN_SIZE-1:0] Din_60,
	input wire [QUAN_SIZE-1:0] Din_61,
	input wire [QUAN_SIZE-1:0] Din_62,
	input wire [QUAN_SIZE-1:0] Din_63,
	input wire [QUAN_SIZE-1:0] Din_64,
	input wire [QUAN_SIZE-1:0] Din_65,
	input wire [QUAN_SIZE-1:0] Din_66,
	input wire [QUAN_SIZE-1:0] Din_67,
	input wire [QUAN_SIZE-1:0] Din_68,
	input wire [QUAN_SIZE-1:0] Din_69,
	input wire [QUAN_SIZE-1:0] Din_70,
	input wire [QUAN_SIZE-1:0] Din_71,
	input wire [QUAN_SIZE-1:0] Din_72,
	input wire [QUAN_SIZE-1:0] Din_73,
	input wire [QUAN_SIZE-1:0] Din_74,
	input wire [QUAN_SIZE-1:0] Din_75,
	input wire [QUAN_SIZE-1:0] Din_76,
	input wire [QUAN_SIZE-1:0] Din_77,
	input wire [QUAN_SIZE-1:0] Din_78,
	input wire [QUAN_SIZE-1:0] Din_79,
	input wire [QUAN_SIZE-1:0] Din_80,
	input wire [QUAN_SIZE-1:0] Din_81,
	input wire [QUAN_SIZE-1:0] Din_82,
	input wire [QUAN_SIZE-1:0] Din_83,
	input wire [QUAN_SIZE-1:0] Din_84,

	input wire [ADDR-1:0] sync_addr,
	input wire we,
	input wire sys_clk
);

wire [QUAN_SIZE-1:0] dummy_dout_reg;
wire [QUAN_SIZE-1:0] dout_reg [0:CHECK_PARALLELISM-1];
wire [QUAN_SIZE-1:0] din_reg [0:CHECK_PARALLELISM-1];
genvar i;
generate
	for(i=0;i<MEM_DEVICE_NUM;i=i+1) begin : mem_device_inst
		ram_unit #(
			.DEPTH (DEPTH), //1024
			.WIDTH (WIDTH), //36
			.ADDR  (ADDR )  //$clog2(DEPTH)
		) ram_unit_u0(
			//.Dout_b (dout_reg[ (i+1)*RAM_UNIT_MSG_NUM-1 : (i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE] ),
			//.Dout_a (dout_reg[ (i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-1 : i*RAM_UNIT_MSG_NUM]),
			.Dout_b ({dummy_dout_reg[QUAN_SIZE-1:0], dout_reg[(i+1)*RAM_UNIT_MSG_NUM-1], dout_reg[(i+1)*RAM_UNIT_MSG_NUM-2], dout_reg[(i+1)*RAM_UNIT_MSG_NUM-3], dout_reg[(i+1)*RAM_UNIT_MSG_NUM-4], dout_reg[(i+1)*RAM_UNIT_MSG_NUM-5], dout_reg[(i+1)*RAM_UNIT_MSG_NUM-6], dout_reg[(i+1)*RAM_UNIT_MSG_NUM-7], dout_reg[(i+1)*RAM_UNIT_MSG_NUM-8]}),
			.Dout_a ({dout_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-1], dout_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-2], dout_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-3], dout_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-4], dout_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-5], dout_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-6], dout_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-7], dout_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-8], dout_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-9]}),
			
			//.Din_a (din_reg[ (i+1)*RAM_UNIT_MSG_NUM-1 : (i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE] ),
			//.Din_b (din_reg[ (i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-1 : i*RAM_UNIT_MSG_NUM]),
			.Din_b ({4'b0000, din_reg[(i+1)*RAM_UNIT_MSG_NUM-1], din_reg[(i+1)*RAM_UNIT_MSG_NUM-2], din_reg[(i+1)*RAM_UNIT_MSG_NUM-3], din_reg[(i+1)*RAM_UNIT_MSG_NUM-4], din_reg[(i+1)*RAM_UNIT_MSG_NUM-5], din_reg[(i+1)*RAM_UNIT_MSG_NUM-6], din_reg[(i+1)*RAM_UNIT_MSG_NUM-7], din_reg[(i+1)*RAM_UNIT_MSG_NUM-8]}),
			.Din_a ({din_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-1], din_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-2], din_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-3], din_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-4], din_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-5], din_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-6], din_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-7], din_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-8], din_reg[(i*RAM_UNIT_MSG_NUM)+RAM_PORTA_RANGE-9]}),			

			.AddrIn_a (sync_addr[ADDR-1:0]  ),
			.AddrIn_b (sync_addr[ADDR-1:0]+1),
			.we_a (we),
			.we_b (we),
			.sys_clk (sys_clk)
		);
	end
endgenerate

assign Dout_0[QUAN_SIZE-1:0] = dout_reg[0];
assign Dout_1[QUAN_SIZE-1:0] = dout_reg[1];
assign Dout_2[QUAN_SIZE-1:0] = dout_reg[2];
assign Dout_3[QUAN_SIZE-1:0] = dout_reg[3];
assign Dout_4[QUAN_SIZE-1:0] = dout_reg[4];
assign Dout_5[QUAN_SIZE-1:0] = dout_reg[5];
assign Dout_6[QUAN_SIZE-1:0] = dout_reg[6];
assign Dout_7[QUAN_SIZE-1:0] = dout_reg[7];
assign Dout_8[QUAN_SIZE-1:0] = dout_reg[8];
assign Dout_9[QUAN_SIZE-1:0] = dout_reg[9];
assign Dout_10[QUAN_SIZE-1:0] = dout_reg[10];
assign Dout_11[QUAN_SIZE-1:0] = dout_reg[11];
assign Dout_12[QUAN_SIZE-1:0] = dout_reg[12];
assign Dout_13[QUAN_SIZE-1:0] = dout_reg[13];
assign Dout_14[QUAN_SIZE-1:0] = dout_reg[14];
assign Dout_15[QUAN_SIZE-1:0] = dout_reg[15];
assign Dout_16[QUAN_SIZE-1:0] = dout_reg[16];
assign Dout_17[QUAN_SIZE-1:0] = dout_reg[17];
assign Dout_18[QUAN_SIZE-1:0] = dout_reg[18];
assign Dout_19[QUAN_SIZE-1:0] = dout_reg[19];
assign Dout_20[QUAN_SIZE-1:0] = dout_reg[20];
assign Dout_21[QUAN_SIZE-1:0] = dout_reg[21];
assign Dout_22[QUAN_SIZE-1:0] = dout_reg[22];
assign Dout_23[QUAN_SIZE-1:0] = dout_reg[23];
assign Dout_24[QUAN_SIZE-1:0] = dout_reg[24];
assign Dout_25[QUAN_SIZE-1:0] = dout_reg[25];
assign Dout_26[QUAN_SIZE-1:0] = dout_reg[26];
assign Dout_27[QUAN_SIZE-1:0] = dout_reg[27];
assign Dout_28[QUAN_SIZE-1:0] = dout_reg[28];
assign Dout_29[QUAN_SIZE-1:0] = dout_reg[29];
assign Dout_30[QUAN_SIZE-1:0] = dout_reg[30];
assign Dout_31[QUAN_SIZE-1:0] = dout_reg[31];
assign Dout_32[QUAN_SIZE-1:0] = dout_reg[32];
assign Dout_33[QUAN_SIZE-1:0] = dout_reg[33];
assign Dout_34[QUAN_SIZE-1:0] = dout_reg[34];
assign Dout_35[QUAN_SIZE-1:0] = dout_reg[35];
assign Dout_36[QUAN_SIZE-1:0] = dout_reg[36];
assign Dout_37[QUAN_SIZE-1:0] = dout_reg[37];
assign Dout_38[QUAN_SIZE-1:0] = dout_reg[38];
assign Dout_39[QUAN_SIZE-1:0] = dout_reg[39];
assign Dout_40[QUAN_SIZE-1:0] = dout_reg[40];
assign Dout_41[QUAN_SIZE-1:0] = dout_reg[41];
assign Dout_42[QUAN_SIZE-1:0] = dout_reg[42];
assign Dout_43[QUAN_SIZE-1:0] = dout_reg[43];
assign Dout_44[QUAN_SIZE-1:0] = dout_reg[44];
assign Dout_45[QUAN_SIZE-1:0] = dout_reg[45];
assign Dout_46[QUAN_SIZE-1:0] = dout_reg[46];
assign Dout_47[QUAN_SIZE-1:0] = dout_reg[47];
assign Dout_48[QUAN_SIZE-1:0] = dout_reg[48];
assign Dout_49[QUAN_SIZE-1:0] = dout_reg[49];
assign Dout_50[QUAN_SIZE-1:0] = dout_reg[50];
assign Dout_51[QUAN_SIZE-1:0] = dout_reg[51];
assign Dout_52[QUAN_SIZE-1:0] = dout_reg[52];
assign Dout_53[QUAN_SIZE-1:0] = dout_reg[53];
assign Dout_54[QUAN_SIZE-1:0] = dout_reg[54];
assign Dout_55[QUAN_SIZE-1:0] = dout_reg[55];
assign Dout_56[QUAN_SIZE-1:0] = dout_reg[56];
assign Dout_57[QUAN_SIZE-1:0] = dout_reg[57];
assign Dout_58[QUAN_SIZE-1:0] = dout_reg[58];
assign Dout_59[QUAN_SIZE-1:0] = dout_reg[59];
assign Dout_60[QUAN_SIZE-1:0] = dout_reg[60];
assign Dout_61[QUAN_SIZE-1:0] = dout_reg[61];
assign Dout_62[QUAN_SIZE-1:0] = dout_reg[62];
assign Dout_63[QUAN_SIZE-1:0] = dout_reg[63];
assign Dout_64[QUAN_SIZE-1:0] = dout_reg[64];
assign Dout_65[QUAN_SIZE-1:0] = dout_reg[65];
assign Dout_66[QUAN_SIZE-1:0] = dout_reg[66];
assign Dout_67[QUAN_SIZE-1:0] = dout_reg[67];
assign Dout_68[QUAN_SIZE-1:0] = dout_reg[68];
assign Dout_69[QUAN_SIZE-1:0] = dout_reg[69];
assign Dout_70[QUAN_SIZE-1:0] = dout_reg[70];
assign Dout_71[QUAN_SIZE-1:0] = dout_reg[71];
assign Dout_72[QUAN_SIZE-1:0] = dout_reg[72];
assign Dout_73[QUAN_SIZE-1:0] = dout_reg[73];
assign Dout_74[QUAN_SIZE-1:0] = dout_reg[74];
assign Dout_75[QUAN_SIZE-1:0] = dout_reg[75];
assign Dout_76[QUAN_SIZE-1:0] = dout_reg[76];
assign Dout_77[QUAN_SIZE-1:0] = dout_reg[77];
assign Dout_78[QUAN_SIZE-1:0] = dout_reg[78];
assign Dout_79[QUAN_SIZE-1:0] = dout_reg[79];
assign Dout_80[QUAN_SIZE-1:0] = dout_reg[80];
assign Dout_81[QUAN_SIZE-1:0] = dout_reg[81];
assign Dout_82[QUAN_SIZE-1:0] = dout_reg[82];
assign Dout_83[QUAN_SIZE-1:0] = dout_reg[83];
assign Dout_84[QUAN_SIZE-1:0] = dout_reg[84];

assign din_reg[0] = Din_0[QUAN_SIZE-1:0];
assign din_reg[1] = Din_1[QUAN_SIZE-1:0];
assign din_reg[2] = Din_2[QUAN_SIZE-1:0];
assign din_reg[3] = Din_3[QUAN_SIZE-1:0];
assign din_reg[4] = Din_4[QUAN_SIZE-1:0];
assign din_reg[5] = Din_5[QUAN_SIZE-1:0];
assign din_reg[6] = Din_6[QUAN_SIZE-1:0];
assign din_reg[7] = Din_7[QUAN_SIZE-1:0];
assign din_reg[8] = Din_8[QUAN_SIZE-1:0];
assign din_reg[9] = Din_9[QUAN_SIZE-1:0];
assign din_reg[10] = Din_10[QUAN_SIZE-1:0];
assign din_reg[11] = Din_11[QUAN_SIZE-1:0];
assign din_reg[12] = Din_12[QUAN_SIZE-1:0];
assign din_reg[13] = Din_13[QUAN_SIZE-1:0];
assign din_reg[14] = Din_14[QUAN_SIZE-1:0];
assign din_reg[15] = Din_15[QUAN_SIZE-1:0];
assign din_reg[16] = Din_16[QUAN_SIZE-1:0];
assign din_reg[17] = Din_17[QUAN_SIZE-1:0];
assign din_reg[18] = Din_18[QUAN_SIZE-1:0];
assign din_reg[19] = Din_19[QUAN_SIZE-1:0];
assign din_reg[20] = Din_20[QUAN_SIZE-1:0];
assign din_reg[21] = Din_21[QUAN_SIZE-1:0];
assign din_reg[22] = Din_22[QUAN_SIZE-1:0];
assign din_reg[23] = Din_23[QUAN_SIZE-1:0];
assign din_reg[24] = Din_24[QUAN_SIZE-1:0];
assign din_reg[25] = Din_25[QUAN_SIZE-1:0];
assign din_reg[26] = Din_26[QUAN_SIZE-1:0];
assign din_reg[27] = Din_27[QUAN_SIZE-1:0];
assign din_reg[28] = Din_28[QUAN_SIZE-1:0];
assign din_reg[29] = Din_29[QUAN_SIZE-1:0];
assign din_reg[30] = Din_30[QUAN_SIZE-1:0];
assign din_reg[31] = Din_31[QUAN_SIZE-1:0];
assign din_reg[32] = Din_32[QUAN_SIZE-1:0];
assign din_reg[33] = Din_33[QUAN_SIZE-1:0];
assign din_reg[34] = Din_34[QUAN_SIZE-1:0];
assign din_reg[35] = Din_35[QUAN_SIZE-1:0];
assign din_reg[36] = Din_36[QUAN_SIZE-1:0];
assign din_reg[37] = Din_37[QUAN_SIZE-1:0];
assign din_reg[38] = Din_38[QUAN_SIZE-1:0];
assign din_reg[39] = Din_39[QUAN_SIZE-1:0];
assign din_reg[40] = Din_40[QUAN_SIZE-1:0];
assign din_reg[41] = Din_41[QUAN_SIZE-1:0];
assign din_reg[42] = Din_42[QUAN_SIZE-1:0];
assign din_reg[43] = Din_43[QUAN_SIZE-1:0];
assign din_reg[44] = Din_44[QUAN_SIZE-1:0];
assign din_reg[45] = Din_45[QUAN_SIZE-1:0];
assign din_reg[46] = Din_46[QUAN_SIZE-1:0];
assign din_reg[47] = Din_47[QUAN_SIZE-1:0];
assign din_reg[48] = Din_48[QUAN_SIZE-1:0];
assign din_reg[49] = Din_49[QUAN_SIZE-1:0];
assign din_reg[50] = Din_50[QUAN_SIZE-1:0];
assign din_reg[51] = Din_51[QUAN_SIZE-1:0];
assign din_reg[52] = Din_52[QUAN_SIZE-1:0];
assign din_reg[53] = Din_53[QUAN_SIZE-1:0];
assign din_reg[54] = Din_54[QUAN_SIZE-1:0];
assign din_reg[55] = Din_55[QUAN_SIZE-1:0];
assign din_reg[56] = Din_56[QUAN_SIZE-1:0];
assign din_reg[57] = Din_57[QUAN_SIZE-1:0];
assign din_reg[58] = Din_58[QUAN_SIZE-1:0];
assign din_reg[59] = Din_59[QUAN_SIZE-1:0];
assign din_reg[60] = Din_60[QUAN_SIZE-1:0];
assign din_reg[61] = Din_61[QUAN_SIZE-1:0];
assign din_reg[62] = Din_62[QUAN_SIZE-1:0];
assign din_reg[63] = Din_63[QUAN_SIZE-1:0];
assign din_reg[64] = Din_64[QUAN_SIZE-1:0];
assign din_reg[65] = Din_65[QUAN_SIZE-1:0];
assign din_reg[66] = Din_66[QUAN_SIZE-1:0];
assign din_reg[67] = Din_67[QUAN_SIZE-1:0];
assign din_reg[68] = Din_68[QUAN_SIZE-1:0];
assign din_reg[69] = Din_69[QUAN_SIZE-1:0];
assign din_reg[70] = Din_70[QUAN_SIZE-1:0];
assign din_reg[71] = Din_71[QUAN_SIZE-1:0];
assign din_reg[72] = Din_72[QUAN_SIZE-1:0];
assign din_reg[73] = Din_73[QUAN_SIZE-1:0];
assign din_reg[74] = Din_74[QUAN_SIZE-1:0];
assign din_reg[75] = Din_75[QUAN_SIZE-1:0];
assign din_reg[76] = Din_76[QUAN_SIZE-1:0];
assign din_reg[77] = Din_77[QUAN_SIZE-1:0];
assign din_reg[78] = Din_78[QUAN_SIZE-1:0];
assign din_reg[79] = Din_79[QUAN_SIZE-1:0];
assign din_reg[80] = Din_80[QUAN_SIZE-1:0];
assign din_reg[81] = Din_81[QUAN_SIZE-1:0];
assign din_reg[82] = Din_82[QUAN_SIZE-1:0];
assign din_reg[83] = Din_83[QUAN_SIZE-1:0];
assign din_reg[84] = Din_84[QUAN_SIZE-1:0];
endmodule

module ram_unit #(
	parameter DEPTH = 1024,
	parameter WIDTH = 36,
	parameter ADDR = $clog2(DEPTH)
) (
	output wire [WIDTH-1:0] Dout_a,
	output wire [WIDTH-1:0] Dout_b,

	input wire [WIDTH-1:0] Din_a,
	input wire [WIDTH-1:0] Din_b,
	input wire [ADDR-1:0] AddrIn_a,
	input wire [ADDR-1:0] AddrIn_b,
	input wire we_a,
	input wire we_b,
	input wire sys_clk
);

mem_subsys_wrapper ram_unit_u0 (
	.BRAM_PORTA_0_addr (AddrIn_a[ADDR-1:0]),
	.BRAM_PORTA_0_clk (sys_clk),
	.BRAM_PORTA_0_din (Din_a[WIDTH-1:0]),
	.BRAM_PORTA_0_dout (Dout_a[WIDTH-1:0]),
	.BRAM_PORTA_0_we (we_a),
	
	.BRAM_PORTB_0_addr (AddrIn_b[ADDR-1:0]),
	.BRAM_PORTB_0_clk (sys_clk),
	.BRAM_PORTB_0_din (Din_b[WIDTH-1:0]),
	.BRAM_PORTB_0_dout (Dout_b[WIDTH-1:0]),
	.BRAM_PORTB_0_we (we_b)
);
endmodule