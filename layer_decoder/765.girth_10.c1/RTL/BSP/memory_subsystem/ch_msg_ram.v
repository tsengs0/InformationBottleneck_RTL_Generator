module ch_msg_ram #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter ROW_CHUNK_NUM = 9,
	parameter CHECK_PARALLELISM = 85,

	parameter DEPTH = ROW_CHUNK_NUM,
	parameter DATA_WIDTH = CHECK_PARALLELISM*QUAN_SIZE,
	parameter ADDR_WIDTH = $clog2(DEPTH),
	parameter FETCH_LATENCY = 2
) (
	output wire [QUAN_SIZE-1:0] dout_0,
	output wire [QUAN_SIZE-1:0] dout_1,
	output wire [QUAN_SIZE-1:0] dout_2,
	output wire [QUAN_SIZE-1:0] dout_3,
	output wire [QUAN_SIZE-1:0] dout_4,
	output wire [QUAN_SIZE-1:0] dout_5,
	output wire [QUAN_SIZE-1:0] dout_6,
	output wire [QUAN_SIZE-1:0] dout_7,
	output wire [QUAN_SIZE-1:0] dout_8,
	output wire [QUAN_SIZE-1:0] dout_9,
	output wire [QUAN_SIZE-1:0] dout_10,
	output wire [QUAN_SIZE-1:0] dout_11,
	output wire [QUAN_SIZE-1:0] dout_12,
	output wire [QUAN_SIZE-1:0] dout_13,
	output wire [QUAN_SIZE-1:0] dout_14,
	output wire [QUAN_SIZE-1:0] dout_15,
	output wire [QUAN_SIZE-1:0] dout_16,
	output wire [QUAN_SIZE-1:0] dout_17,
	output wire [QUAN_SIZE-1:0] dout_18,
	output wire [QUAN_SIZE-1:0] dout_19,
	output wire [QUAN_SIZE-1:0] dout_20,
	output wire [QUAN_SIZE-1:0] dout_21,
	output wire [QUAN_SIZE-1:0] dout_22,
	output wire [QUAN_SIZE-1:0] dout_23,
	output wire [QUAN_SIZE-1:0] dout_24,
	output wire [QUAN_SIZE-1:0] dout_25,
	output wire [QUAN_SIZE-1:0] dout_26,
	output wire [QUAN_SIZE-1:0] dout_27,
	output wire [QUAN_SIZE-1:0] dout_28,
	output wire [QUAN_SIZE-1:0] dout_29,
	output wire [QUAN_SIZE-1:0] dout_30,
	output wire [QUAN_SIZE-1:0] dout_31,
	output wire [QUAN_SIZE-1:0] dout_32,
	output wire [QUAN_SIZE-1:0] dout_33,
	output wire [QUAN_SIZE-1:0] dout_34,
	output wire [QUAN_SIZE-1:0] dout_35,
	output wire [QUAN_SIZE-1:0] dout_36,
	output wire [QUAN_SIZE-1:0] dout_37,
	output wire [QUAN_SIZE-1:0] dout_38,
	output wire [QUAN_SIZE-1:0] dout_39,
	output wire [QUAN_SIZE-1:0] dout_40,
	output wire [QUAN_SIZE-1:0] dout_41,
	output wire [QUAN_SIZE-1:0] dout_42,
	output wire [QUAN_SIZE-1:0] dout_43,
	output wire [QUAN_SIZE-1:0] dout_44,
	output wire [QUAN_SIZE-1:0] dout_45,
	output wire [QUAN_SIZE-1:0] dout_46,
	output wire [QUAN_SIZE-1:0] dout_47,
	output wire [QUAN_SIZE-1:0] dout_48,
	output wire [QUAN_SIZE-1:0] dout_49,
	output wire [QUAN_SIZE-1:0] dout_50,
	output wire [QUAN_SIZE-1:0] dout_51,
	output wire [QUAN_SIZE-1:0] dout_52,
	output wire [QUAN_SIZE-1:0] dout_53,
	output wire [QUAN_SIZE-1:0] dout_54,
	output wire [QUAN_SIZE-1:0] dout_55,
	output wire [QUAN_SIZE-1:0] dout_56,
	output wire [QUAN_SIZE-1:0] dout_57,
	output wire [QUAN_SIZE-1:0] dout_58,
	output wire [QUAN_SIZE-1:0] dout_59,
	output wire [QUAN_SIZE-1:0] dout_60,
	output wire [QUAN_SIZE-1:0] dout_61,
	output wire [QUAN_SIZE-1:0] dout_62,
	output wire [QUAN_SIZE-1:0] dout_63,
	output wire [QUAN_SIZE-1:0] dout_64,
	output wire [QUAN_SIZE-1:0] dout_65,
	output wire [QUAN_SIZE-1:0] dout_66,
	output wire [QUAN_SIZE-1:0] dout_67,
	output wire [QUAN_SIZE-1:0] dout_68,
	output wire [QUAN_SIZE-1:0] dout_69,
	output wire [QUAN_SIZE-1:0] dout_70,
	output wire [QUAN_SIZE-1:0] dout_71,
	output wire [QUAN_SIZE-1:0] dout_72,
	output wire [QUAN_SIZE-1:0] dout_73,
	output wire [QUAN_SIZE-1:0] dout_74,
	output wire [QUAN_SIZE-1:0] dout_75,
	output wire [QUAN_SIZE-1:0] dout_76,
	output wire [QUAN_SIZE-1:0] dout_77,
	output wire [QUAN_SIZE-1:0] dout_78,
	output wire [QUAN_SIZE-1:0] dout_79,
	output wire [QUAN_SIZE-1:0] dout_80,
	output wire [QUAN_SIZE-1:0] dout_81,
	output wire [QUAN_SIZE-1:0] dout_82,
	output wire [QUAN_SIZE-1:0] dout_83,
	output wire [QUAN_SIZE-1:0] dout_84,

	input wire [QUAN_SIZE-1:0] din_0 ,
	input wire [QUAN_SIZE-1:0] din_1 ,
	input wire [QUAN_SIZE-1:0] din_2 ,
	input wire [QUAN_SIZE-1:0] din_3 ,
	input wire [QUAN_SIZE-1:0] din_4 ,
	input wire [QUAN_SIZE-1:0] din_5 ,
	input wire [QUAN_SIZE-1:0] din_6 ,
	input wire [QUAN_SIZE-1:0] din_7 ,
	input wire [QUAN_SIZE-1:0] din_8 ,
	input wire [QUAN_SIZE-1:0] din_9 ,
	input wire [QUAN_SIZE-1:0] din_10,
	input wire [QUAN_SIZE-1:0] din_11,
	input wire [QUAN_SIZE-1:0] din_12,
	input wire [QUAN_SIZE-1:0] din_13,
	input wire [QUAN_SIZE-1:0] din_14,
	input wire [QUAN_SIZE-1:0] din_15,
	input wire [QUAN_SIZE-1:0] din_16,
	input wire [QUAN_SIZE-1:0] din_17,
	input wire [QUAN_SIZE-1:0] din_18,
	input wire [QUAN_SIZE-1:0] din_19,
	input wire [QUAN_SIZE-1:0] din_20,
	input wire [QUAN_SIZE-1:0] din_21,
	input wire [QUAN_SIZE-1:0] din_22,
	input wire [QUAN_SIZE-1:0] din_23,
	input wire [QUAN_SIZE-1:0] din_24,
	input wire [QUAN_SIZE-1:0] din_25,
	input wire [QUAN_SIZE-1:0] din_26,
	input wire [QUAN_SIZE-1:0] din_27,
	input wire [QUAN_SIZE-1:0] din_28,
	input wire [QUAN_SIZE-1:0] din_29,
	input wire [QUAN_SIZE-1:0] din_30,
	input wire [QUAN_SIZE-1:0] din_31,
	input wire [QUAN_SIZE-1:0] din_32,
	input wire [QUAN_SIZE-1:0] din_33,
	input wire [QUAN_SIZE-1:0] din_34,
	input wire [QUAN_SIZE-1:0] din_35,
	input wire [QUAN_SIZE-1:0] din_36,
	input wire [QUAN_SIZE-1:0] din_37,
	input wire [QUAN_SIZE-1:0] din_38,
	input wire [QUAN_SIZE-1:0] din_39,
	input wire [QUAN_SIZE-1:0] din_40,
	input wire [QUAN_SIZE-1:0] din_41,
	input wire [QUAN_SIZE-1:0] din_42,
	input wire [QUAN_SIZE-1:0] din_43,
	input wire [QUAN_SIZE-1:0] din_44,
	input wire [QUAN_SIZE-1:0] din_45,
	input wire [QUAN_SIZE-1:0] din_46,
	input wire [QUAN_SIZE-1:0] din_47,
	input wire [QUAN_SIZE-1:0] din_48,
	input wire [QUAN_SIZE-1:0] din_49,
	input wire [QUAN_SIZE-1:0] din_50,
	input wire [QUAN_SIZE-1:0] din_51,
	input wire [QUAN_SIZE-1:0] din_52,
	input wire [QUAN_SIZE-1:0] din_53,
	input wire [QUAN_SIZE-1:0] din_54,
	input wire [QUAN_SIZE-1:0] din_55,
	input wire [QUAN_SIZE-1:0] din_56,
	input wire [QUAN_SIZE-1:0] din_57,
	input wire [QUAN_SIZE-1:0] din_58,
	input wire [QUAN_SIZE-1:0] din_59,
	input wire [QUAN_SIZE-1:0] din_60,
	input wire [QUAN_SIZE-1:0] din_61,
	input wire [QUAN_SIZE-1:0] din_62,
	input wire [QUAN_SIZE-1:0] din_63,
	input wire [QUAN_SIZE-1:0] din_64,
	input wire [QUAN_SIZE-1:0] din_65,
	input wire [QUAN_SIZE-1:0] din_66,
	input wire [QUAN_SIZE-1:0] din_67,
	input wire [QUAN_SIZE-1:0] din_68,
	input wire [QUAN_SIZE-1:0] din_69,
	input wire [QUAN_SIZE-1:0] din_70,
	input wire [QUAN_SIZE-1:0] din_71,
	input wire [QUAN_SIZE-1:0] din_72,
	input wire [QUAN_SIZE-1:0] din_73,
	input wire [QUAN_SIZE-1:0] din_74,
	input wire [QUAN_SIZE-1:0] din_75,
	input wire [QUAN_SIZE-1:0] din_76,
	input wire [QUAN_SIZE-1:0] din_77,
	input wire [QUAN_SIZE-1:0] din_78,
	input wire [QUAN_SIZE-1:0] din_79,
	input wire [QUAN_SIZE-1:0] din_80,
	input wire [QUAN_SIZE-1:0] din_81,
	input wire [QUAN_SIZE-1:0] din_82,
	input wire [QUAN_SIZE-1:0] din_83,
	input wire [QUAN_SIZE-1:0] din_84,

	input wire [DATA_WIDTH-1:0] Din_a,
	input wire [DATA_WIDTH-1:0] Din_b,
	input wire [ADDR_WIDTH-1:0] read_addr,
	input wire [ADDR_WIDTH-1:0] write_addr,
	input wire we,

	input wire read_clk,
	input wire write_clk,
	input wire rstn
);

// Core Memory
reg [DATA_WIDTH-1:0] ram_block [0:DEPTH-1];
wire [DATA_WIDTH-1:0] din; 

 // Port-A
always @(posedge read_clk) begin
	if(we == 1'b1)
		ram_block[write_addr] <= din;
end

reg [DATA_WIDTH-1:0] do_a;
always @(*) begin
	do_a <= ram_block[read_addr];
end

reg [DATA_WIDTH-1:0] dout_pipe [0:FETCH_LATENCY-1];
always @(posedge read_clk) begin
	if(rstn == 1'b0) dout_pipe[0] <= 0;
	else dout_pipe[0] <= do_a;
end

genvar i;
generate
	for(i=1;i<FETCH_LATENCY;i=i+1) begin : dout_pipeline_inst
		always @(posedge read_clk) begin
			if(rstn == 1'b0) dout_pipe[i] <= 0;
			else dout_pipe[i] <= dout_pipe[i-1];
		end
	end
endgenerate

assign din[DATA_WIDTH-1:0] = {din_0[QUAN_SIZE-1:0],din_1[QUAN_SIZE-1:0],din_2[QUAN_SIZE-1:0],din_3[QUAN_SIZE-1:0],din_4[QUAN_SIZE-1:0],din_5[QUAN_SIZE-1:0],din_6[QUAN_SIZE-1:0],din_7[QUAN_SIZE-1:0],din_8[QUAN_SIZE-1:0],din_9[QUAN_SIZE-1:0],din_10[QUAN_SIZE-1:0],din_11[QUAN_SIZE-1:0],din_12[QUAN_SIZE-1:0],din_13[QUAN_SIZE-1:0],din_14[QUAN_SIZE-1:0],din_15[QUAN_SIZE-1:0],din_16[QUAN_SIZE-1:0],din_17[QUAN_SIZE-1:0],din_18[QUAN_SIZE-1:0],din_19[QUAN_SIZE-1:0],din_20[QUAN_SIZE-1:0],din_21[QUAN_SIZE-1:0],din_22[QUAN_SIZE-1:0],din_23[QUAN_SIZE-1:0],din_24[QUAN_SIZE-1:0],din_25[QUAN_SIZE-1:0],din_26[QUAN_SIZE-1:0],din_27[QUAN_SIZE-1:0],din_28[QUAN_SIZE-1:0],din_29[QUAN_SIZE-1:0],din_30[QUAN_SIZE-1:0],din_31[QUAN_SIZE-1:0],din_32[QUAN_SIZE-1:0],din_33[QUAN_SIZE-1:0],din_34[QUAN_SIZE-1:0],din_35[QUAN_SIZE-1:0],din_36[QUAN_SIZE-1:0],din_37[QUAN_SIZE-1:0],din_38[QUAN_SIZE-1:0],din_39[QUAN_SIZE-1:0],din_40[QUAN_SIZE-1:0],din_41[QUAN_SIZE-1:0],din_42[QUAN_SIZE-1:0],din_43[QUAN_SIZE-1:0],din_44[QUAN_SIZE-1:0],din_45[QUAN_SIZE-1:0],din_46[QUAN_SIZE-1:0],din_47[QUAN_SIZE-1:0],din_48[QUAN_SIZE-1:0],din_49[QUAN_SIZE-1:0],din_50[QUAN_SIZE-1:0],din_51[QUAN_SIZE-1:0],din_52[QUAN_SIZE-1:0],din_53[QUAN_SIZE-1:0],din_54[QUAN_SIZE-1:0],din_55[QUAN_SIZE-1:0],din_56[QUAN_SIZE-1:0],din_57[QUAN_SIZE-1:0],din_58[QUAN_SIZE-1:0],din_59[QUAN_SIZE-1:0],din_60[QUAN_SIZE-1:0],din_61[QUAN_SIZE-1:0],din_62[QUAN_SIZE-1:0],din_63[QUAN_SIZE-1:0],din_64[QUAN_SIZE-1:0],din_65[QUAN_SIZE-1:0],din_66[QUAN_SIZE-1:0],din_67[QUAN_SIZE-1:0],din_68[QUAN_SIZE-1:0],din_69[QUAN_SIZE-1:0],din_70[QUAN_SIZE-1:0],din_71[QUAN_SIZE-1:0],din_72[QUAN_SIZE-1:0],din_73[QUAN_SIZE-1:0],din_74[QUAN_SIZE-1:0],din_75[QUAN_SIZE-1:0],din_76[QUAN_SIZE-1:0],din_77[QUAN_SIZE-1:0],din_78[QUAN_SIZE-1:0],din_79[QUAN_SIZE-1:0],din_80[QUAN_SIZE-1:0],din_81[QUAN_SIZE-1:0],din_82[QUAN_SIZE-1:0],din_83[QUAN_SIZE-1:0],din_84[QUAN_SIZE-1:0]};
assign dout_0[QUAN_SIZE-1:0]  = dout_pipe[FETCH_LATENCY-1][1*QUAN_SIZE-1:0*QUAN_SIZE];
assign dout_1[QUAN_SIZE-1:0]  = dout_pipe[FETCH_LATENCY-1][2*QUAN_SIZE-1:1*QUAN_SIZE];
assign dout_2[QUAN_SIZE-1:0]  = dout_pipe[FETCH_LATENCY-1][3*QUAN_SIZE-1:2*QUAN_SIZE];
assign dout_3[QUAN_SIZE-1:0]  = dout_pipe[FETCH_LATENCY-1][4*QUAN_SIZE-1:3*QUAN_SIZE];
assign dout_4[QUAN_SIZE-1:0]  = dout_pipe[FETCH_LATENCY-1][5*QUAN_SIZE-1:4*QUAN_SIZE];
assign dout_5[QUAN_SIZE-1:0]  = dout_pipe[FETCH_LATENCY-1][6*QUAN_SIZE-1:5*QUAN_SIZE];
assign dout_6[QUAN_SIZE-1:0]  = dout_pipe[FETCH_LATENCY-1][7*QUAN_SIZE-1:6*QUAN_SIZE];
assign dout_7[QUAN_SIZE-1:0]  = dout_pipe[FETCH_LATENCY-1][8*QUAN_SIZE-1:7*QUAN_SIZE];
assign dout_8[QUAN_SIZE-1:0]  = dout_pipe[FETCH_LATENCY-1][9*QUAN_SIZE-1:8*QUAN_SIZE];
assign dout_9[QUAN_SIZE-1:0]  = dout_pipe[FETCH_LATENCY-1][10*QUAN_SIZE-1:9*QUAN_SIZE];
assign dout_10[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][11*QUAN_SIZE-1:10*QUAN_SIZE];
assign dout_11[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][12*QUAN_SIZE-1:11*QUAN_SIZE];
assign dout_12[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][13*QUAN_SIZE-1:12*QUAN_SIZE];
assign dout_13[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][14*QUAN_SIZE-1:13*QUAN_SIZE];
assign dout_14[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][15*QUAN_SIZE-1:14*QUAN_SIZE];
assign dout_15[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][16*QUAN_SIZE-1:15*QUAN_SIZE];
assign dout_16[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][17*QUAN_SIZE-1:16*QUAN_SIZE];
assign dout_17[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][18*QUAN_SIZE-1:17*QUAN_SIZE];
assign dout_18[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][19*QUAN_SIZE-1:18*QUAN_SIZE];
assign dout_19[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][20*QUAN_SIZE-1:19*QUAN_SIZE];
assign dout_20[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][21*QUAN_SIZE-1:20*QUAN_SIZE];
assign dout_21[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][22*QUAN_SIZE-1:21*QUAN_SIZE];
assign dout_22[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][23*QUAN_SIZE-1:22*QUAN_SIZE];
assign dout_23[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][24*QUAN_SIZE-1:23*QUAN_SIZE];
assign dout_24[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][25*QUAN_SIZE-1:24*QUAN_SIZE];
assign dout_25[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][26*QUAN_SIZE-1:25*QUAN_SIZE];
assign dout_26[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][27*QUAN_SIZE-1:26*QUAN_SIZE];
assign dout_27[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][28*QUAN_SIZE-1:27*QUAN_SIZE];
assign dout_28[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][29*QUAN_SIZE-1:28*QUAN_SIZE];
assign dout_29[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][30*QUAN_SIZE-1:29*QUAN_SIZE];
assign dout_30[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][31*QUAN_SIZE-1:30*QUAN_SIZE];
assign dout_31[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][32*QUAN_SIZE-1:31*QUAN_SIZE];
assign dout_32[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][33*QUAN_SIZE-1:32*QUAN_SIZE];
assign dout_33[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][34*QUAN_SIZE-1:33*QUAN_SIZE];
assign dout_34[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][35*QUAN_SIZE-1:34*QUAN_SIZE];
assign dout_35[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][36*QUAN_SIZE-1:35*QUAN_SIZE];
assign dout_36[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][37*QUAN_SIZE-1:36*QUAN_SIZE];
assign dout_37[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][38*QUAN_SIZE-1:37*QUAN_SIZE];
assign dout_38[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][39*QUAN_SIZE-1:38*QUAN_SIZE];
assign dout_39[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][40*QUAN_SIZE-1:39*QUAN_SIZE];
assign dout_40[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][41*QUAN_SIZE-1:40*QUAN_SIZE];
assign dout_41[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][42*QUAN_SIZE-1:41*QUAN_SIZE];
assign dout_42[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][43*QUAN_SIZE-1:42*QUAN_SIZE];
assign dout_43[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][44*QUAN_SIZE-1:43*QUAN_SIZE];
assign dout_44[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][45*QUAN_SIZE-1:44*QUAN_SIZE];
assign dout_45[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][46*QUAN_SIZE-1:45*QUAN_SIZE];
assign dout_46[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][47*QUAN_SIZE-1:46*QUAN_SIZE];
assign dout_47[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][48*QUAN_SIZE-1:47*QUAN_SIZE];
assign dout_48[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][49*QUAN_SIZE-1:48*QUAN_SIZE];
assign dout_49[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][50*QUAN_SIZE-1:49*QUAN_SIZE];
assign dout_50[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][51*QUAN_SIZE-1:50*QUAN_SIZE];
assign dout_51[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][52*QUAN_SIZE-1:51*QUAN_SIZE];
assign dout_52[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][53*QUAN_SIZE-1:52*QUAN_SIZE];
assign dout_53[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][54*QUAN_SIZE-1:53*QUAN_SIZE];
assign dout_54[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][55*QUAN_SIZE-1:54*QUAN_SIZE];
assign dout_55[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][56*QUAN_SIZE-1:55*QUAN_SIZE];
assign dout_56[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][57*QUAN_SIZE-1:56*QUAN_SIZE];
assign dout_57[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][58*QUAN_SIZE-1:57*QUAN_SIZE];
assign dout_58[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][59*QUAN_SIZE-1:58*QUAN_SIZE];
assign dout_59[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][60*QUAN_SIZE-1:59*QUAN_SIZE];
assign dout_60[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][61*QUAN_SIZE-1:60*QUAN_SIZE];
assign dout_61[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][62*QUAN_SIZE-1:61*QUAN_SIZE];
assign dout_62[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][63*QUAN_SIZE-1:62*QUAN_SIZE];
assign dout_63[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][64*QUAN_SIZE-1:63*QUAN_SIZE];
assign dout_64[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][65*QUAN_SIZE-1:64*QUAN_SIZE];
assign dout_65[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][66*QUAN_SIZE-1:65*QUAN_SIZE];
assign dout_66[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][67*QUAN_SIZE-1:66*QUAN_SIZE];
assign dout_67[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][68*QUAN_SIZE-1:67*QUAN_SIZE];
assign dout_68[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][69*QUAN_SIZE-1:68*QUAN_SIZE];
assign dout_69[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][70*QUAN_SIZE-1:69*QUAN_SIZE];
assign dout_70[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][71*QUAN_SIZE-1:70*QUAN_SIZE];
assign dout_71[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][72*QUAN_SIZE-1:71*QUAN_SIZE];
assign dout_72[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][73*QUAN_SIZE-1:72*QUAN_SIZE];
assign dout_73[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][74*QUAN_SIZE-1:73*QUAN_SIZE];
assign dout_74[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][75*QUAN_SIZE-1:74*QUAN_SIZE];
assign dout_75[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][76*QUAN_SIZE-1:75*QUAN_SIZE];
assign dout_76[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][77*QUAN_SIZE-1:76*QUAN_SIZE];
assign dout_77[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][78*QUAN_SIZE-1:77*QUAN_SIZE];
assign dout_78[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][79*QUAN_SIZE-1:78*QUAN_SIZE];
assign dout_79[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][80*QUAN_SIZE-1:79*QUAN_SIZE];
assign dout_80[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][81*QUAN_SIZE-1:80*QUAN_SIZE];
assign dout_81[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][82*QUAN_SIZE-1:81*QUAN_SIZE];
assign dout_82[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][83*QUAN_SIZE-1:82*QUAN_SIZE];
assign dout_83[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][84*QUAN_SIZE-1:83*QUAN_SIZE];
assign dout_84[QUAN_SIZE-1:0] = dout_pipe[FETCH_LATENCY-1][85*QUAN_SIZE-1:84*QUAN_SIZE];
endmodule