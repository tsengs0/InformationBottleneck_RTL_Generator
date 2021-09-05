module ch_mem_submatrix_top #(
	parameter QUAN_SIZE = 4,
	parameter CHECK_PARALLELISM = 85,
	parameter ROW_CHUNK_NUM = 9,
	parameter LAYER_NUM = 3
) (
	output wire [QUAN_SIZE-1:0] ch_msg_out_0,
	output wire [QUAN_SIZE-1:0] ch_msg_out_1,
	output wire [QUAN_SIZE-1:0] ch_msg_out_2,
	output wire [QUAN_SIZE-1:0] ch_msg_out_3,
	output wire [QUAN_SIZE-1:0] ch_msg_out_4,
	output wire [QUAN_SIZE-1:0] ch_msg_out_5,
	output wire [QUAN_SIZE-1:0] ch_msg_out_6,
	output wire [QUAN_SIZE-1:0] ch_msg_out_7,
	output wire [QUAN_SIZE-1:0] ch_msg_out_8,
	output wire [QUAN_SIZE-1:0] ch_msg_out_9,
	output wire [QUAN_SIZE-1:0] ch_msg_out_10,
	output wire [QUAN_SIZE-1:0] ch_msg_out_11,
	output wire [QUAN_SIZE-1:0] ch_msg_out_12,
	output wire [QUAN_SIZE-1:0] ch_msg_out_13,
	output wire [QUAN_SIZE-1:0] ch_msg_out_14,
	output wire [QUAN_SIZE-1:0] ch_msg_out_15,
	output wire [QUAN_SIZE-1:0] ch_msg_out_16,
	output wire [QUAN_SIZE-1:0] ch_msg_out_17,
	output wire [QUAN_SIZE-1:0] ch_msg_out_18,
	output wire [QUAN_SIZE-1:0] ch_msg_out_19,
	output wire [QUAN_SIZE-1:0] ch_msg_out_20,
	output wire [QUAN_SIZE-1:0] ch_msg_out_21,
	output wire [QUAN_SIZE-1:0] ch_msg_out_22,
	output wire [QUAN_SIZE-1:0] ch_msg_out_23,
	output wire [QUAN_SIZE-1:0] ch_msg_out_24,
	output wire [QUAN_SIZE-1:0] ch_msg_out_25,
	output wire [QUAN_SIZE-1:0] ch_msg_out_26,
	output wire [QUAN_SIZE-1:0] ch_msg_out_27,
	output wire [QUAN_SIZE-1:0] ch_msg_out_28,
	output wire [QUAN_SIZE-1:0] ch_msg_out_29,
	output wire [QUAN_SIZE-1:0] ch_msg_out_30,
	output wire [QUAN_SIZE-1:0] ch_msg_out_31,
	output wire [QUAN_SIZE-1:0] ch_msg_out_32,
	output wire [QUAN_SIZE-1:0] ch_msg_out_33,
	output wire [QUAN_SIZE-1:0] ch_msg_out_34,
	output wire [QUAN_SIZE-1:0] ch_msg_out_35,
	output wire [QUAN_SIZE-1:0] ch_msg_out_36,
	output wire [QUAN_SIZE-1:0] ch_msg_out_37,
	output wire [QUAN_SIZE-1:0] ch_msg_out_38,
	output wire [QUAN_SIZE-1:0] ch_msg_out_39,
	output wire [QUAN_SIZE-1:0] ch_msg_out_40,
	output wire [QUAN_SIZE-1:0] ch_msg_out_41,
	output wire [QUAN_SIZE-1:0] ch_msg_out_42,
	output wire [QUAN_SIZE-1:0] ch_msg_out_43,
	output wire [QUAN_SIZE-1:0] ch_msg_out_44,
	output wire [QUAN_SIZE-1:0] ch_msg_out_45,
	output wire [QUAN_SIZE-1:0] ch_msg_out_46,
	output wire [QUAN_SIZE-1:0] ch_msg_out_47,
	output wire [QUAN_SIZE-1:0] ch_msg_out_48,
	output wire [QUAN_SIZE-1:0] ch_msg_out_49,
	output wire [QUAN_SIZE-1:0] ch_msg_out_50,
	output wire [QUAN_SIZE-1:0] ch_msg_out_51,
	output wire [QUAN_SIZE-1:0] ch_msg_out_52,
	output wire [QUAN_SIZE-1:0] ch_msg_out_53,
	output wire [QUAN_SIZE-1:0] ch_msg_out_54,
	output wire [QUAN_SIZE-1:0] ch_msg_out_55,
	output wire [QUAN_SIZE-1:0] ch_msg_out_56,
	output wire [QUAN_SIZE-1:0] ch_msg_out_57,
	output wire [QUAN_SIZE-1:0] ch_msg_out_58,
	output wire [QUAN_SIZE-1:0] ch_msg_out_59,
	output wire [QUAN_SIZE-1:0] ch_msg_out_60,
	output wire [QUAN_SIZE-1:0] ch_msg_out_61,
	output wire [QUAN_SIZE-1:0] ch_msg_out_62,
	output wire [QUAN_SIZE-1:0] ch_msg_out_63,
	output wire [QUAN_SIZE-1:0] ch_msg_out_64,
	output wire [QUAN_SIZE-1:0] ch_msg_out_65,
	output wire [QUAN_SIZE-1:0] ch_msg_out_66,
	output wire [QUAN_SIZE-1:0] ch_msg_out_67,
	output wire [QUAN_SIZE-1:0] ch_msg_out_68,
	output wire [QUAN_SIZE-1:0] ch_msg_out_69,
	output wire [QUAN_SIZE-1:0] ch_msg_out_70,
	output wire [QUAN_SIZE-1:0] ch_msg_out_71,
	output wire [QUAN_SIZE-1:0] ch_msg_out_72,
	output wire [QUAN_SIZE-1:0] ch_msg_out_73,
	output wire [QUAN_SIZE-1:0] ch_msg_out_74,
	output wire [QUAN_SIZE-1:0] ch_msg_out_75,
	output wire [QUAN_SIZE-1:0] ch_msg_out_76,
	output wire [QUAN_SIZE-1:0] ch_msg_out_77,
	output wire [QUAN_SIZE-1:0] ch_msg_out_78,
	output wire [QUAN_SIZE-1:0] ch_msg_out_79,
	output wire [QUAN_SIZE-1:0] ch_msg_out_80,
	output wire [QUAN_SIZE-1:0] ch_msg_out_81,
	output wire [QUAN_SIZE-1:0] ch_msg_out_82,
	output wire [QUAN_SIZE-1:0] ch_msg_out_83,
	output wire [QUAN_SIZE-1:0] ch_msg_out_84,

	input wire [QUAN_SIZE-1:0] ch_msg_in_0,
	input wire [QUAN_SIZE-1:0] ch_msg_in_1,
	input wire [QUAN_SIZE-1:0] ch_msg_in_2,
	input wire [QUAN_SIZE-1:0] ch_msg_in_3,
	input wire [QUAN_SIZE-1:0] ch_msg_in_4,
	input wire [QUAN_SIZE-1:0] ch_msg_in_5,
	input wire [QUAN_SIZE-1:0] ch_msg_in_6,
	input wire [QUAN_SIZE-1:0] ch_msg_in_7,
	input wire [QUAN_SIZE-1:0] ch_msg_in_8,
	input wire [QUAN_SIZE-1:0] ch_msg_in_9,
	input wire [QUAN_SIZE-1:0] ch_msg_in_10,
	input wire [QUAN_SIZE-1:0] ch_msg_in_11,
	input wire [QUAN_SIZE-1:0] ch_msg_in_12,
	input wire [QUAN_SIZE-1:0] ch_msg_in_13,
	input wire [QUAN_SIZE-1:0] ch_msg_in_14,
	input wire [QUAN_SIZE-1:0] ch_msg_in_15,
	input wire [QUAN_SIZE-1:0] ch_msg_in_16,
	input wire [QUAN_SIZE-1:0] ch_msg_in_17,
	input wire [QUAN_SIZE-1:0] ch_msg_in_18,
	input wire [QUAN_SIZE-1:0] ch_msg_in_19,
	input wire [QUAN_SIZE-1:0] ch_msg_in_20,
	input wire [QUAN_SIZE-1:0] ch_msg_in_21,
	input wire [QUAN_SIZE-1:0] ch_msg_in_22,
	input wire [QUAN_SIZE-1:0] ch_msg_in_23,
	input wire [QUAN_SIZE-1:0] ch_msg_in_24,
	input wire [QUAN_SIZE-1:0] ch_msg_in_25,
	input wire [QUAN_SIZE-1:0] ch_msg_in_26,
	input wire [QUAN_SIZE-1:0] ch_msg_in_27,
	input wire [QUAN_SIZE-1:0] ch_msg_in_28,
	input wire [QUAN_SIZE-1:0] ch_msg_in_29,
	input wire [QUAN_SIZE-1:0] ch_msg_in_30,
	input wire [QUAN_SIZE-1:0] ch_msg_in_31,
	input wire [QUAN_SIZE-1:0] ch_msg_in_32,
	input wire [QUAN_SIZE-1:0] ch_msg_in_33,
	input wire [QUAN_SIZE-1:0] ch_msg_in_34,
	input wire [QUAN_SIZE-1:0] ch_msg_in_35,
	input wire [QUAN_SIZE-1:0] ch_msg_in_36,
	input wire [QUAN_SIZE-1:0] ch_msg_in_37,
	input wire [QUAN_SIZE-1:0] ch_msg_in_38,
	input wire [QUAN_SIZE-1:0] ch_msg_in_39,
	input wire [QUAN_SIZE-1:0] ch_msg_in_40,
	input wire [QUAN_SIZE-1:0] ch_msg_in_41,
	input wire [QUAN_SIZE-1:0] ch_msg_in_42,
	input wire [QUAN_SIZE-1:0] ch_msg_in_43,
	input wire [QUAN_SIZE-1:0] ch_msg_in_44,
	input wire [QUAN_SIZE-1:0] ch_msg_in_45,
	input wire [QUAN_SIZE-1:0] ch_msg_in_46,
	input wire [QUAN_SIZE-1:0] ch_msg_in_47,
	input wire [QUAN_SIZE-1:0] ch_msg_in_48,
	input wire [QUAN_SIZE-1:0] ch_msg_in_49,
	input wire [QUAN_SIZE-1:0] ch_msg_in_50,
	input wire [QUAN_SIZE-1:0] ch_msg_in_51,
	input wire [QUAN_SIZE-1:0] ch_msg_in_52,
	input wire [QUAN_SIZE-1:0] ch_msg_in_53,
	input wire [QUAN_SIZE-1:0] ch_msg_in_54,
	input wire [QUAN_SIZE-1:0] ch_msg_in_55,
	input wire [QUAN_SIZE-1:0] ch_msg_in_56,
	input wire [QUAN_SIZE-1:0] ch_msg_in_57,
	input wire [QUAN_SIZE-1:0] ch_msg_in_58,
	input wire [QUAN_SIZE-1:0] ch_msg_in_59,
	input wire [QUAN_SIZE-1:0] ch_msg_in_60,
	input wire [QUAN_SIZE-1:0] ch_msg_in_61,
	input wire [QUAN_SIZE-1:0] ch_msg_in_62,
	input wire [QUAN_SIZE-1:0] ch_msg_in_63,
	input wire [QUAN_SIZE-1:0] ch_msg_in_64,
	input wire [QUAN_SIZE-1:0] ch_msg_in_65,
	input wire [QUAN_SIZE-1:0] ch_msg_in_66,
	input wire [QUAN_SIZE-1:0] ch_msg_in_67,
	input wire [QUAN_SIZE-1:0] ch_msg_in_68,
	input wire [QUAN_SIZE-1:0] ch_msg_in_69,
	input wire [QUAN_SIZE-1:0] ch_msg_in_70,
	input wire [QUAN_SIZE-1:0] ch_msg_in_71,
	input wire [QUAN_SIZE-1:0] ch_msg_in_72,
	input wire [QUAN_SIZE-1:0] ch_msg_in_73,
	input wire [QUAN_SIZE-1:0] ch_msg_in_74,
	input wire [QUAN_SIZE-1:0] ch_msg_in_75,
	input wire [QUAN_SIZE-1:0] ch_msg_in_76,
	input wire [QUAN_SIZE-1:0] ch_msg_in_77,
	input wire [QUAN_SIZE-1:0] ch_msg_in_78,
	input wire [QUAN_SIZE-1:0] ch_msg_in_79,
	input wire [QUAN_SIZE-1:0] ch_msg_in_80,
	input wire [QUAN_SIZE-1:0] ch_msg_in_81,
	input wire [QUAN_SIZE-1:0] ch_msg_in_82,
	input wire [QUAN_SIZE-1:0] ch_msg_in_83,
	input wire [QUAN_SIZE-1:0] ch_msg_in_84,
	input wire v2c_src,
	input wire en,
	input wire sys_clk,
	input wire rstn
);

wire [QUAN_SIZE-1:0] ch_msg_out [CHECK_PARALLELISM-1:0];
wire [QUAN_SIZE-1:0] ch_msg_in [CHECK_PARALLELISM-1:0];
generate
	genvar i;
	for(i=0;i<CHECK_PARALLELISM;i=i+1) begin : ch_mem_inst
		ch_mem #(
			.QUAN_SIZE         (QUAN_SIZE        ),
			.CHECK_PARALLELISM (CHECK_PARALLELISM),
			.ROW_CHUNK_NUM     (ROW_CHUNK_NUM    ),
			.LAYER_NUM         (LAYER_NUM        )
		) ch_mem_u0 (
			.ch_msg_out (ch_msg_out[i]),
		
			.ch_msg_in (ch_msg_in[i]),
			.v2c_src   (v2c_src  ),
			.en        (en       ),
			.sys_clk   (sys_clk  ),
			.rstn      (rstn     )
		);
	end
endgenerate

assign ch_msg_out_0 = ch_msg_out[0];
assign ch_msg_in[0] = ch_msg_in_0;
assign ch_msg_out_1 = ch_msg_out[1];
assign ch_msg_in[1] = ch_msg_in_1;
assign ch_msg_out_2 = ch_msg_out[2];
assign ch_msg_in[2] = ch_msg_in_2;
assign ch_msg_out_3 = ch_msg_out[3];
assign ch_msg_in[3] = ch_msg_in_3;
assign ch_msg_out_4 = ch_msg_out[4];
assign ch_msg_in[4] = ch_msg_in_4;
assign ch_msg_out_5 = ch_msg_out[5];
assign ch_msg_in[5] = ch_msg_in_5;
assign ch_msg_out_6 = ch_msg_out[6];
assign ch_msg_in[6] = ch_msg_in_6;
assign ch_msg_out_7 = ch_msg_out[7];
assign ch_msg_in[7] = ch_msg_in_7;
assign ch_msg_out_8 = ch_msg_out[8];
assign ch_msg_in[8] = ch_msg_in_8;
assign ch_msg_out_9 = ch_msg_out[9];
assign ch_msg_in[9] = ch_msg_in_9;
assign ch_msg_out_10 = ch_msg_out[10];
assign ch_msg_in[10] = ch_msg_in_10;
assign ch_msg_out_11 = ch_msg_out[11];
assign ch_msg_in[11] = ch_msg_in_11;
assign ch_msg_out_12 = ch_msg_out[12];
assign ch_msg_in[12] = ch_msg_in_12;
assign ch_msg_out_13 = ch_msg_out[13];
assign ch_msg_in[13] = ch_msg_in_13;
assign ch_msg_out_14 = ch_msg_out[14];
assign ch_msg_in[14] = ch_msg_in_14;
assign ch_msg_out_15 = ch_msg_out[15];
assign ch_msg_in[15] = ch_msg_in_15;
assign ch_msg_out_16 = ch_msg_out[16];
assign ch_msg_in[16] = ch_msg_in_16;
assign ch_msg_out_17 = ch_msg_out[17];
assign ch_msg_in[17] = ch_msg_in_17;
assign ch_msg_out_18 = ch_msg_out[18];
assign ch_msg_in[18] = ch_msg_in_18;
assign ch_msg_out_19 = ch_msg_out[19];
assign ch_msg_in[19] = ch_msg_in_19;
assign ch_msg_out_20 = ch_msg_out[20];
assign ch_msg_in[20] = ch_msg_in_20;
assign ch_msg_out_21 = ch_msg_out[21];
assign ch_msg_in[21] = ch_msg_in_21;
assign ch_msg_out_22 = ch_msg_out[22];
assign ch_msg_in[22] = ch_msg_in_22;
assign ch_msg_out_23 = ch_msg_out[23];
assign ch_msg_in[23] = ch_msg_in_23;
assign ch_msg_out_24 = ch_msg_out[24];
assign ch_msg_in[24] = ch_msg_in_24;
assign ch_msg_out_25 = ch_msg_out[25];
assign ch_msg_in[25] = ch_msg_in_25;
assign ch_msg_out_26 = ch_msg_out[26];
assign ch_msg_in[26] = ch_msg_in_26;
assign ch_msg_out_27 = ch_msg_out[27];
assign ch_msg_in[27] = ch_msg_in_27;
assign ch_msg_out_28 = ch_msg_out[28];
assign ch_msg_in[28] = ch_msg_in_28;
assign ch_msg_out_29 = ch_msg_out[29];
assign ch_msg_in[29] = ch_msg_in_29;
assign ch_msg_out_30 = ch_msg_out[30];
assign ch_msg_in[30] = ch_msg_in_30;
assign ch_msg_out_31 = ch_msg_out[31];
assign ch_msg_in[31] = ch_msg_in_31;
assign ch_msg_out_32 = ch_msg_out[32];
assign ch_msg_in[32] = ch_msg_in_32;
assign ch_msg_out_33 = ch_msg_out[33];
assign ch_msg_in[33] = ch_msg_in_33;
assign ch_msg_out_34 = ch_msg_out[34];
assign ch_msg_in[34] = ch_msg_in_34;
assign ch_msg_out_35 = ch_msg_out[35];
assign ch_msg_in[35] = ch_msg_in_35;
assign ch_msg_out_36 = ch_msg_out[36];
assign ch_msg_in[36] = ch_msg_in_36;
assign ch_msg_out_37 = ch_msg_out[37];
assign ch_msg_in[37] = ch_msg_in_37;
assign ch_msg_out_38 = ch_msg_out[38];
assign ch_msg_in[38] = ch_msg_in_38;
assign ch_msg_out_39 = ch_msg_out[39];
assign ch_msg_in[39] = ch_msg_in_39;
assign ch_msg_out_40 = ch_msg_out[40];
assign ch_msg_in[40] = ch_msg_in_40;
assign ch_msg_out_41 = ch_msg_out[41];
assign ch_msg_in[41] = ch_msg_in_41;
assign ch_msg_out_42 = ch_msg_out[42];
assign ch_msg_in[42] = ch_msg_in_42;
assign ch_msg_out_43 = ch_msg_out[43];
assign ch_msg_in[43] = ch_msg_in_43;
assign ch_msg_out_44 = ch_msg_out[44];
assign ch_msg_in[44] = ch_msg_in_44;
assign ch_msg_out_45 = ch_msg_out[45];
assign ch_msg_in[45] = ch_msg_in_45;
assign ch_msg_out_46 = ch_msg_out[46];
assign ch_msg_in[46] = ch_msg_in_46;
assign ch_msg_out_47 = ch_msg_out[47];
assign ch_msg_in[47] = ch_msg_in_47;
assign ch_msg_out_48 = ch_msg_out[48];
assign ch_msg_in[48] = ch_msg_in_48;
assign ch_msg_out_49 = ch_msg_out[49];
assign ch_msg_in[49] = ch_msg_in_49;
assign ch_msg_out_50 = ch_msg_out[50];
assign ch_msg_in[50] = ch_msg_in_50;
assign ch_msg_out_51 = ch_msg_out[51];
assign ch_msg_in[51] = ch_msg_in_51;
assign ch_msg_out_52 = ch_msg_out[52];
assign ch_msg_in[52] = ch_msg_in_52;
assign ch_msg_out_53 = ch_msg_out[53];
assign ch_msg_in[53] = ch_msg_in_53;
assign ch_msg_out_54 = ch_msg_out[54];
assign ch_msg_in[54] = ch_msg_in_54;
assign ch_msg_out_55 = ch_msg_out[55];
assign ch_msg_in[55] = ch_msg_in_55;
assign ch_msg_out_56 = ch_msg_out[56];
assign ch_msg_in[56] = ch_msg_in_56;
assign ch_msg_out_57 = ch_msg_out[57];
assign ch_msg_in[57] = ch_msg_in_57;
assign ch_msg_out_58 = ch_msg_out[58];
assign ch_msg_in[58] = ch_msg_in_58;
assign ch_msg_out_59 = ch_msg_out[59];
assign ch_msg_in[59] = ch_msg_in_59;
assign ch_msg_out_60 = ch_msg_out[60];
assign ch_msg_in[60] = ch_msg_in_60;
assign ch_msg_out_61 = ch_msg_out[61];
assign ch_msg_in[61] = ch_msg_in_61;
assign ch_msg_out_62 = ch_msg_out[62];
assign ch_msg_in[62] = ch_msg_in_62;
assign ch_msg_out_63 = ch_msg_out[63];
assign ch_msg_in[63] = ch_msg_in_63;
assign ch_msg_out_64 = ch_msg_out[64];
assign ch_msg_in[64] = ch_msg_in_64;
assign ch_msg_out_65 = ch_msg_out[65];
assign ch_msg_in[65] = ch_msg_in_65;
assign ch_msg_out_66 = ch_msg_out[66];
assign ch_msg_in[66] = ch_msg_in_66;
assign ch_msg_out_67 = ch_msg_out[67];
assign ch_msg_in[67] = ch_msg_in_67;
assign ch_msg_out_68 = ch_msg_out[68];
assign ch_msg_in[68] = ch_msg_in_68;
assign ch_msg_out_69 = ch_msg_out[69];
assign ch_msg_in[69] = ch_msg_in_69;
assign ch_msg_out_70 = ch_msg_out[70];
assign ch_msg_in[70] = ch_msg_in_70;
assign ch_msg_out_71 = ch_msg_out[71];
assign ch_msg_in[71] = ch_msg_in_71;
assign ch_msg_out_72 = ch_msg_out[72];
assign ch_msg_in[72] = ch_msg_in_72;
assign ch_msg_out_73 = ch_msg_out[73];
assign ch_msg_in[73] = ch_msg_in_73;
assign ch_msg_out_74 = ch_msg_out[74];
assign ch_msg_in[74] = ch_msg_in_74;
assign ch_msg_out_75 = ch_msg_out[75];
assign ch_msg_in[75] = ch_msg_in_75;
assign ch_msg_out_76 = ch_msg_out[76];
assign ch_msg_in[76] = ch_msg_in_76;
assign ch_msg_out_77 = ch_msg_out[77];
assign ch_msg_in[77] = ch_msg_in_77;
assign ch_msg_out_78 = ch_msg_out[78];
assign ch_msg_in[78] = ch_msg_in_78;
assign ch_msg_out_79 = ch_msg_out[79];
assign ch_msg_in[79] = ch_msg_in_79;
assign ch_msg_out_80 = ch_msg_out[80];
assign ch_msg_in[80] = ch_msg_in_80;
assign ch_msg_out_81 = ch_msg_out[81];
assign ch_msg_in[81] = ch_msg_in_81;
assign ch_msg_out_82 = ch_msg_out[82];
assign ch_msg_in[82] = ch_msg_in_82;
assign ch_msg_out_83 = ch_msg_out[83];
assign ch_msg_in[83] = ch_msg_in_83;
assign ch_msg_out_84 = ch_msg_out[84];
assign ch_msg_in[84] = ch_msg_in_84;
endmodule

module ch_mem #(
	parameter QUAN_SIZE = 4,
	parameter CHECK_PARALLELISM = 85,
	parameter ROW_CHUNK_NUM = 9,
	parameter LAYER_NUM = 3
) (
	output wire [QUAN_SIZE-1:0] ch_msg_out,

	input wire [QUAN_SIZE-1:0] ch_msg_in,
	input wire v2c_src,
	input wire en,
	input wire sys_clk,
	input wire rstn
);

reg [QUAN_SIZE-1:0] ch_buffer [(ROW_CHUNK_NUM*LAYER_NUM)-1:0];
initial ch_buffer[0] <= 0;
always @(posedge sys_clk) begin
	if(rstn == 1'b0) ch_buffer[0] <= 0;
	else if(en == 1'b1) ch_buffer[0] <= ch_buffer[(ROW_CHUNK_NUM*LAYER_NUM)-1];
end
generate
	genvar i;
	for(i = 1; i < (ROW_CHUNK_NUM*LAYER_NUM)-1; i=i+1) begin : ch_mem_unit_inst
		initial ch_buffer[i] <= 0;
		always @(posedge sys_clk) begin
			if(rstn == 1'b0) ch_buffer[i] <= 0; 
			else if(en == 1'b1) ch_buffer[i] <= ch_buffer[i-1];
		end
	end
endgenerate
initial ch_buffer[(ROW_CHUNK_NUM*LAYER_NUM)-1] <= 0;
always @(posedge sys_clk) begin
	if(rstn == 1'b0) 
		ch_buffer[(ROW_CHUNK_NUM*LAYER_NUM)-1] <= 0;
	else if(en == 1'b1) begin
		if(v2c_src == 1'b1)
			ch_buffer[(ROW_CHUNK_NUM*LAYER_NUM)-1] <= ch_msg_in[QUAN_SIZE-1:0];
		else 
			ch_buffer[(ROW_CHUNK_NUM*LAYER_NUM)-1] <= ch_buffer[(ROW_CHUNK_NUM*LAYER_NUM)-2];
	end
end
assign ch_msg_out[QUAN_SIZE-1:0] = ch_buffer[(ROW_CHUNK_NUM*LAYER_NUM)-1];
endmodule