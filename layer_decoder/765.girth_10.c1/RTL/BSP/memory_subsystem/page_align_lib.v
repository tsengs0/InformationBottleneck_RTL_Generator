module ram_pageAlign_interface #(
	parameter QUAN_SIZE = 4,
	parameter CHECK_PARALLELISM = 85,
	parameter LAYER_NUM = 3
) (
	output wire [QUAN_SIZE-1:0] msg_out_0,
	output wire [QUAN_SIZE-1:0] msg_out_1,
	output wire [QUAN_SIZE-1:0] msg_out_2,
	output wire [QUAN_SIZE-1:0] msg_out_3,
	output wire [QUAN_SIZE-1:0] msg_out_4,
	output wire [QUAN_SIZE-1:0] msg_out_5,
	output wire [QUAN_SIZE-1:0] msg_out_6,
	output wire [QUAN_SIZE-1:0] msg_out_7,
	output wire [QUAN_SIZE-1:0] msg_out_8,
	output wire [QUAN_SIZE-1:0] msg_out_9,
	output wire [QUAN_SIZE-1:0] msg_out_10,
	output wire [QUAN_SIZE-1:0] msg_out_11,
	output wire [QUAN_SIZE-1:0] msg_out_12,
	output wire [QUAN_SIZE-1:0] msg_out_13,
	output wire [QUAN_SIZE-1:0] msg_out_14,
	output wire [QUAN_SIZE-1:0] msg_out_15,
	output wire [QUAN_SIZE-1:0] msg_out_16,
	output wire [QUAN_SIZE-1:0] msg_out_17,
	output wire [QUAN_SIZE-1:0] msg_out_18,
	output wire [QUAN_SIZE-1:0] msg_out_19,
	output wire [QUAN_SIZE-1:0] msg_out_20,
	output wire [QUAN_SIZE-1:0] msg_out_21,
	output wire [QUAN_SIZE-1:0] msg_out_22,
	output wire [QUAN_SIZE-1:0] msg_out_23,
	output wire [QUAN_SIZE-1:0] msg_out_24,
	output wire [QUAN_SIZE-1:0] msg_out_25,
	output wire [QUAN_SIZE-1:0] msg_out_26,
	output wire [QUAN_SIZE-1:0] msg_out_27,
	output wire [QUAN_SIZE-1:0] msg_out_28,
	output wire [QUAN_SIZE-1:0] msg_out_29,
	output wire [QUAN_SIZE-1:0] msg_out_30,
	output wire [QUAN_SIZE-1:0] msg_out_31,
	output wire [QUAN_SIZE-1:0] msg_out_32,
	output wire [QUAN_SIZE-1:0] msg_out_33,
	output wire [QUAN_SIZE-1:0] msg_out_34,
	output wire [QUAN_SIZE-1:0] msg_out_35,
	output wire [QUAN_SIZE-1:0] msg_out_36,
	output wire [QUAN_SIZE-1:0] msg_out_37,
	output wire [QUAN_SIZE-1:0] msg_out_38,
	output wire [QUAN_SIZE-1:0] msg_out_39,
	output wire [QUAN_SIZE-1:0] msg_out_40,
	output wire [QUAN_SIZE-1:0] msg_out_41,
	output wire [QUAN_SIZE-1:0] msg_out_42,
	output wire [QUAN_SIZE-1:0] msg_out_43,
	output wire [QUAN_SIZE-1:0] msg_out_44,
	output wire [QUAN_SIZE-1:0] msg_out_45,
	output wire [QUAN_SIZE-1:0] msg_out_46,
	output wire [QUAN_SIZE-1:0] msg_out_47,
	output wire [QUAN_SIZE-1:0] msg_out_48,
	output wire [QUAN_SIZE-1:0] msg_out_49,
	output wire [QUAN_SIZE-1:0] msg_out_50,
	output wire [QUAN_SIZE-1:0] msg_out_51,
	output wire [QUAN_SIZE-1:0] msg_out_52,
	output wire [QUAN_SIZE-1:0] msg_out_53,
	output wire [QUAN_SIZE-1:0] msg_out_54,
	output wire [QUAN_SIZE-1:0] msg_out_55,
	output wire [QUAN_SIZE-1:0] msg_out_56,
	output wire [QUAN_SIZE-1:0] msg_out_57,
	output wire [QUAN_SIZE-1:0] msg_out_58,
	output wire [QUAN_SIZE-1:0] msg_out_59,
	output wire [QUAN_SIZE-1:0] msg_out_60,
	output wire [QUAN_SIZE-1:0] msg_out_61,
	output wire [QUAN_SIZE-1:0] msg_out_62,
	output wire [QUAN_SIZE-1:0] msg_out_63,
	output wire [QUAN_SIZE-1:0] msg_out_64,
	output wire [QUAN_SIZE-1:0] msg_out_65,
	output wire [QUAN_SIZE-1:0] msg_out_66,
	output wire [QUAN_SIZE-1:0] msg_out_67,
	output wire [QUAN_SIZE-1:0] msg_out_68,
	output wire [QUAN_SIZE-1:0] msg_out_69,
	output wire [QUAN_SIZE-1:0] msg_out_70,
	output wire [QUAN_SIZE-1:0] msg_out_71,
	output wire [QUAN_SIZE-1:0] msg_out_72,
	output wire [QUAN_SIZE-1:0] msg_out_73,
	output wire [QUAN_SIZE-1:0] msg_out_74,
	output wire [QUAN_SIZE-1:0] msg_out_75,
	output wire [QUAN_SIZE-1:0] msg_out_76,
	output wire [QUAN_SIZE-1:0] msg_out_77,
	output wire [QUAN_SIZE-1:0] msg_out_78,
	output wire [QUAN_SIZE-1:0] msg_out_79,
	output wire [QUAN_SIZE-1:0] msg_out_80,
	output wire [QUAN_SIZE-1:0] msg_out_81,
	output wire [QUAN_SIZE-1:0] msg_out_82,
	output wire [QUAN_SIZE-1:0] msg_out_83,
	output wire [QUAN_SIZE-1:0] msg_out_84,

	input wire [QUAN_SIZE-1:0] vnu_msg_in_0,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_1,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_2,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_3,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_4,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_5,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_6,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_7,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_8,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_9,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_10,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_11,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_12,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_13,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_14,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_15,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_16,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_17,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_18,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_19,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_20,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_21,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_22,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_23,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_24,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_25,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_26,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_27,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_28,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_29,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_30,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_31,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_32,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_33,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_34,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_35,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_36,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_37,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_38,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_39,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_40,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_41,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_42,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_43,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_44,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_45,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_46,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_47,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_48,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_49,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_50,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_51,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_52,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_53,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_54,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_55,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_56,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_57,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_58,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_59,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_60,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_61,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_62,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_63,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_64,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_65,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_66,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_67,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_68,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_69,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_70,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_71,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_72,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_73,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_74,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_75,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_76,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_77,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_78,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_79,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_80,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_81,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_82,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_83,
	input wire [QUAN_SIZE-1:0] vnu_msg_in_84,
							   
	input wire [QUAN_SIZE-1:0] cnu_msg_in_0,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_1,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_2,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_3,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_4,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_5,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_6,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_7,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_8,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_9,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_10,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_11,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_12,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_13,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_14,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_15,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_16,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_17,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_18,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_19,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_20,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_21,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_22,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_23,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_24,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_25,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_26,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_27,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_28,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_29,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_30,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_31,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_32,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_33,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_34,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_35,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_36,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_37,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_38,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_39,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_40,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_41,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_42,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_43,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_44,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_45,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_46,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_47,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_48,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_49,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_50,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_51,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_52,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_53,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_54,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_55,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_56,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_57,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_58,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_59,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_60,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_61,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_62,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_63,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_64,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_65,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_66,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_67,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_68,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_69,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_70,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_71,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_72,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_73,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_74,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_75,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_76,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_77,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_78,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_79,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_80,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_81,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_82,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_83,
	input wire [QUAN_SIZE-1:0] cnu_msg_in_84,

	input wire sched_cmd, // 1'b0: align_in from variable msg; 1'b1: align_in from check msg
	input wire [CHECK_PARALLELISM-1:0] delay_cmd,
	input wire [LAYER_NUM-1:0] layer_status,
	input wire sys_clk,
	input wire rstn
);

wire [QUAN_SIZE-1:0] msg_mux_out [0:CHECK_PARALLELISM-1];
/////////////////////////////////////////////////////////////////////////////////////////////
// Main structure of Page Alignment Mechanism
wire delay_cmd_39;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_39(.delay_cmd(delay_cmd_39), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u39(.align_out (msg_out_39), .align_target_in (msg_mux_out[39]), .delay_cmd(delay_cmd_39), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_40;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_40(.delay_cmd(delay_cmd_40), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u40(.align_out (msg_out_40), .align_target_in (msg_mux_out[40]), .delay_cmd(delay_cmd_40), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_41;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_41(.delay_cmd(delay_cmd_41), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u41(.align_out (msg_out_41), .align_target_in (msg_mux_out[41]), .delay_cmd(delay_cmd_41), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_42;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_42(.delay_cmd(delay_cmd_42), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u42(.align_out (msg_out_42), .align_target_in (msg_mux_out[42]), .delay_cmd(delay_cmd_42), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_43;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_43(.delay_cmd(delay_cmd_43), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u43(.align_out (msg_out_43), .align_target_in (msg_mux_out[43]), .delay_cmd(delay_cmd_43), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_44;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_44(.delay_cmd(delay_cmd_44), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u44(.align_out (msg_out_44), .align_target_in (msg_mux_out[44]), .delay_cmd(delay_cmd_44), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_45;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_45(.delay_cmd(delay_cmd_45), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u45(.align_out (msg_out_45), .align_target_in (msg_mux_out[45]), .delay_cmd(delay_cmd_45), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_46;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_46(.delay_cmd(delay_cmd_46), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u46(.align_out (msg_out_46), .align_target_in (msg_mux_out[46]), .delay_cmd(delay_cmd_46), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_47;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_47(.delay_cmd(delay_cmd_47), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u47(.align_out (msg_out_47), .align_target_in (msg_mux_out[47]), .delay_cmd(delay_cmd_47), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_48;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_48(.delay_cmd(delay_cmd_48), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u48(.align_out (msg_out_48), .align_target_in (msg_mux_out[48]), .delay_cmd(delay_cmd_48), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_49;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_49(.delay_cmd(delay_cmd_49), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u49(.align_out (msg_out_49), .align_target_in (msg_mux_out[49]), .delay_cmd(delay_cmd_49), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_50;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_50(.delay_cmd(delay_cmd_50), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u50(.align_out (msg_out_50), .align_target_in (msg_mux_out[50]), .delay_cmd(delay_cmd_50), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_51;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_51(.delay_cmd(delay_cmd_51), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u51(.align_out (msg_out_51), .align_target_in (msg_mux_out[51]), .delay_cmd(delay_cmd_51), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_52;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_52(.delay_cmd(delay_cmd_52), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u52(.align_out (msg_out_52), .align_target_in (msg_mux_out[52]), .delay_cmd(delay_cmd_52), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_53;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_53(.delay_cmd(delay_cmd_53), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u53(.align_out (msg_out_53), .align_target_in (msg_mux_out[53]), .delay_cmd(delay_cmd_53), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_54;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_54(.delay_cmd(delay_cmd_54), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u54(.align_out (msg_out_54), .align_target_in (msg_mux_out[54]), .delay_cmd(delay_cmd_54), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_55;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_55(.delay_cmd(delay_cmd_55), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u55(.align_out (msg_out_55), .align_target_in (msg_mux_out[55]), .delay_cmd(delay_cmd_55), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_56;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_56(.delay_cmd(delay_cmd_56), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u56(.align_out (msg_out_56), .align_target_in (msg_mux_out[56]), .delay_cmd(delay_cmd_56), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_57;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_57(.delay_cmd(delay_cmd_57), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u57(.align_out (msg_out_57), .align_target_in (msg_mux_out[57]), .delay_cmd(delay_cmd_57), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_58;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_58(.delay_cmd(delay_cmd_58), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u58(.align_out (msg_out_58), .align_target_in (msg_mux_out[58]), .delay_cmd(delay_cmd_58), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_59;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_59(.delay_cmd(delay_cmd_59), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u59(.align_out (msg_out_59), .align_target_in (msg_mux_out[59]), .delay_cmd(delay_cmd_59), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_60;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_60(.delay_cmd(delay_cmd_60), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u60(.align_out (msg_out_60), .align_target_in (msg_mux_out[60]), .delay_cmd(delay_cmd_60), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_61;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_61(.delay_cmd(delay_cmd_61), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u61(.align_out (msg_out_61), .align_target_in (msg_mux_out[61]), .delay_cmd(delay_cmd_61), .sys_clk(sys_clk), .rstn(rstn));

wire delay_cmd_62;
align_cmd_gen_5 #(.LAYER_NUM (LAYER_NUM)) delay_cmd_62(.delay_cmd(delay_cmd_62), .layer_status(layer_status[LAYER_NUM-1:0]));
page_align_depth_1_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u62(.align_out (msg_out_62), .align_target_in (msg_mux_out[62]), .delay_cmd(delay_cmd_62), .sys_clk(sys_clk), .rstn(rstn));

page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u0(.align_out(msg_out_0), .align_target_in (msg_mux_out[0]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u1(.align_out(msg_out_1), .align_target_in (msg_mux_out[1]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u2(.align_out(msg_out_2), .align_target_in (msg_mux_out[2]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u3(.align_out(msg_out_3), .align_target_in (msg_mux_out[3]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u4(.align_out(msg_out_4), .align_target_in (msg_mux_out[4]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u5(.align_out(msg_out_5), .align_target_in (msg_mux_out[5]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u6(.align_out(msg_out_6), .align_target_in (msg_mux_out[6]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u7(.align_out(msg_out_7), .align_target_in (msg_mux_out[7]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u8(.align_out(msg_out_8), .align_target_in (msg_mux_out[8]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u9(.align_out(msg_out_9), .align_target_in (msg_mux_out[9]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u10(.align_out(msg_out_10), .align_target_in (msg_mux_out[10]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u11(.align_out(msg_out_11), .align_target_in (msg_mux_out[11]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u12(.align_out(msg_out_12), .align_target_in (msg_mux_out[12]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u13(.align_out(msg_out_13), .align_target_in (msg_mux_out[13]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u14(.align_out(msg_out_14), .align_target_in (msg_mux_out[14]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u15(.align_out(msg_out_15), .align_target_in (msg_mux_out[15]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u16(.align_out(msg_out_16), .align_target_in (msg_mux_out[16]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u17(.align_out(msg_out_17), .align_target_in (msg_mux_out[17]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u18(.align_out(msg_out_18), .align_target_in (msg_mux_out[18]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u19(.align_out(msg_out_19), .align_target_in (msg_mux_out[19]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u20(.align_out(msg_out_20), .align_target_in (msg_mux_out[20]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u21(.align_out(msg_out_21), .align_target_in (msg_mux_out[21]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u22(.align_out(msg_out_22), .align_target_in (msg_mux_out[22]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u23(.align_out(msg_out_23), .align_target_in (msg_mux_out[23]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u24(.align_out(msg_out_24), .align_target_in (msg_mux_out[24]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u25(.align_out(msg_out_25), .align_target_in (msg_mux_out[25]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u26(.align_out(msg_out_26), .align_target_in (msg_mux_out[26]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u27(.align_out(msg_out_27), .align_target_in (msg_mux_out[27]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u28(.align_out(msg_out_28), .align_target_in (msg_mux_out[28]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u29(.align_out(msg_out_29), .align_target_in (msg_mux_out[29]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u30(.align_out(msg_out_30), .align_target_in (msg_mux_out[30]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u31(.align_out(msg_out_31), .align_target_in (msg_mux_out[31]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u32(.align_out(msg_out_32), .align_target_in (msg_mux_out[32]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u33(.align_out(msg_out_33), .align_target_in (msg_mux_out[33]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u34(.align_out(msg_out_34), .align_target_in (msg_mux_out[34]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u35(.align_out(msg_out_35), .align_target_in (msg_mux_out[35]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u36(.align_out(msg_out_36), .align_target_in (msg_mux_out[36]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u37(.align_out(msg_out_37), .align_target_in (msg_mux_out[37]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_2 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u38(.align_out(msg_out_38), .align_target_in (msg_mux_out[38]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u63(.align_out(msg_out_63), .align_target_in (msg_mux_out[63]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u64(.align_out(msg_out_64), .align_target_in (msg_mux_out[64]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u65(.align_out(msg_out_65), .align_target_in (msg_mux_out[65]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u66(.align_out(msg_out_66), .align_target_in (msg_mux_out[66]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u67(.align_out(msg_out_67), .align_target_in (msg_mux_out[67]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u68(.align_out(msg_out_68), .align_target_in (msg_mux_out[68]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u69(.align_out(msg_out_69), .align_target_in (msg_mux_out[69]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u70(.align_out(msg_out_70), .align_target_in (msg_mux_out[70]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u71(.align_out(msg_out_71), .align_target_in (msg_mux_out[71]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u72(.align_out(msg_out_72), .align_target_in (msg_mux_out[72]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u73(.align_out(msg_out_73), .align_target_in (msg_mux_out[73]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u74(.align_out(msg_out_74), .align_target_in (msg_mux_out[74]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u75(.align_out(msg_out_75), .align_target_in (msg_mux_out[75]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u76(.align_out(msg_out_76), .align_target_in (msg_mux_out[76]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u77(.align_out(msg_out_77), .align_target_in (msg_mux_out[77]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u78(.align_out(msg_out_78), .align_target_in (msg_mux_out[78]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u79(.align_out(msg_out_79), .align_target_in (msg_mux_out[79]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u80(.align_out(msg_out_80), .align_target_in (msg_mux_out[80]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u81(.align_out(msg_out_81), .align_target_in (msg_mux_out[81]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u82(.align_out(msg_out_82), .align_target_in (msg_mux_out[82]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u83(.align_out(msg_out_83), .align_target_in (msg_mux_out[83]), .sys_clk(sys_clk), .rstn(rstn));
page_align_depth_1 #(.QUAN_SIZE (QUAN_SIZE)) page_align_u84(.align_out(msg_out_84), .align_target_in (msg_mux_out[84]), .sys_clk(sys_clk), .rstn(rstn));
/////////////////////////////////////////////////////////////////////////////////////////////
assign msg_mux_out[0 ] = (sched_cmd == 1'b0) ? vnu_msg_in_0  : cnu_msg_in_0 ;
assign msg_mux_out[1 ] = (sched_cmd == 1'b0) ? vnu_msg_in_1  : cnu_msg_in_1 ; 
assign msg_mux_out[2 ] = (sched_cmd == 1'b0) ? vnu_msg_in_2  : cnu_msg_in_2 ; 
assign msg_mux_out[3 ] = (sched_cmd == 1'b0) ? vnu_msg_in_3  : cnu_msg_in_3 ; 
assign msg_mux_out[4 ] = (sched_cmd == 1'b0) ? vnu_msg_in_4  : cnu_msg_in_4 ; 
assign msg_mux_out[5 ] = (sched_cmd == 1'b0) ? vnu_msg_in_5  : cnu_msg_in_5 ; 
assign msg_mux_out[6 ] = (sched_cmd == 1'b0) ? vnu_msg_in_6  : cnu_msg_in_6 ; 
assign msg_mux_out[7 ] = (sched_cmd == 1'b0) ? vnu_msg_in_7  : cnu_msg_in_7 ; 
assign msg_mux_out[8 ] = (sched_cmd == 1'b0) ? vnu_msg_in_8  : cnu_msg_in_8 ; 
assign msg_mux_out[9 ] = (sched_cmd == 1'b0) ? vnu_msg_in_9  : cnu_msg_in_9 ; 
assign msg_mux_out[10] = (sched_cmd == 1'b0) ? vnu_msg_in_10 : cnu_msg_in_10;
assign msg_mux_out[11] = (sched_cmd == 1'b0) ? vnu_msg_in_11 : cnu_msg_in_11;
assign msg_mux_out[12] = (sched_cmd == 1'b0) ? vnu_msg_in_12 : cnu_msg_in_12;
assign msg_mux_out[13] = (sched_cmd == 1'b0) ? vnu_msg_in_13 : cnu_msg_in_13;
assign msg_mux_out[14] = (sched_cmd == 1'b0) ? vnu_msg_in_14 : cnu_msg_in_14;
assign msg_mux_out[15] = (sched_cmd == 1'b0) ? vnu_msg_in_15 : cnu_msg_in_15;
assign msg_mux_out[16] = (sched_cmd == 1'b0) ? vnu_msg_in_16 : cnu_msg_in_16;
assign msg_mux_out[17] = (sched_cmd == 1'b0) ? vnu_msg_in_17 : cnu_msg_in_17;
assign msg_mux_out[18] = (sched_cmd == 1'b0) ? vnu_msg_in_18 : cnu_msg_in_18;
assign msg_mux_out[19] = (sched_cmd == 1'b0) ? vnu_msg_in_19 : cnu_msg_in_19;
assign msg_mux_out[20] = (sched_cmd == 1'b0) ? vnu_msg_in_20 : cnu_msg_in_20;
assign msg_mux_out[21] = (sched_cmd == 1'b0) ? vnu_msg_in_21 : cnu_msg_in_21;
assign msg_mux_out[22] = (sched_cmd == 1'b0) ? vnu_msg_in_22 : cnu_msg_in_22;
assign msg_mux_out[23] = (sched_cmd == 1'b0) ? vnu_msg_in_23 : cnu_msg_in_23;
assign msg_mux_out[24] = (sched_cmd == 1'b0) ? vnu_msg_in_24 : cnu_msg_in_24;
assign msg_mux_out[25] = (sched_cmd == 1'b0) ? vnu_msg_in_25 : cnu_msg_in_25;
assign msg_mux_out[26] = (sched_cmd == 1'b0) ? vnu_msg_in_26 : cnu_msg_in_26;
assign msg_mux_out[27] = (sched_cmd == 1'b0) ? vnu_msg_in_27 : cnu_msg_in_27;
assign msg_mux_out[28] = (sched_cmd == 1'b0) ? vnu_msg_in_28 : cnu_msg_in_28;
assign msg_mux_out[29] = (sched_cmd == 1'b0) ? vnu_msg_in_29 : cnu_msg_in_29;
assign msg_mux_out[30] = (sched_cmd == 1'b0) ? vnu_msg_in_30 : cnu_msg_in_30;
assign msg_mux_out[31] = (sched_cmd == 1'b0) ? vnu_msg_in_31 : cnu_msg_in_31;
assign msg_mux_out[32] = (sched_cmd == 1'b0) ? vnu_msg_in_32 : cnu_msg_in_32;
assign msg_mux_out[33] = (sched_cmd == 1'b0) ? vnu_msg_in_33 : cnu_msg_in_33;
assign msg_mux_out[34] = (sched_cmd == 1'b0) ? vnu_msg_in_34 : cnu_msg_in_34;
assign msg_mux_out[35] = (sched_cmd == 1'b0) ? vnu_msg_in_35 : cnu_msg_in_35;
assign msg_mux_out[36] = (sched_cmd == 1'b0) ? vnu_msg_in_36 : cnu_msg_in_36;
assign msg_mux_out[37] = (sched_cmd == 1'b0) ? vnu_msg_in_37 : cnu_msg_in_37;
assign msg_mux_out[38] = (sched_cmd == 1'b0) ? vnu_msg_in_38 : cnu_msg_in_38;
assign msg_mux_out[39] = (sched_cmd == 1'b0) ? vnu_msg_in_39 : cnu_msg_in_39;
assign msg_mux_out[40] = (sched_cmd == 1'b0) ? vnu_msg_in_40 : cnu_msg_in_40;
assign msg_mux_out[41] = (sched_cmd == 1'b0) ? vnu_msg_in_41 : cnu_msg_in_41;
assign msg_mux_out[42] = (sched_cmd == 1'b0) ? vnu_msg_in_42 : cnu_msg_in_42;
assign msg_mux_out[43] = (sched_cmd == 1'b0) ? vnu_msg_in_43 : cnu_msg_in_43;
assign msg_mux_out[44] = (sched_cmd == 1'b0) ? vnu_msg_in_44 : cnu_msg_in_44;
assign msg_mux_out[45] = (sched_cmd == 1'b0) ? vnu_msg_in_45 : cnu_msg_in_45;
assign msg_mux_out[46] = (sched_cmd == 1'b0) ? vnu_msg_in_46 : cnu_msg_in_46;
assign msg_mux_out[47] = (sched_cmd == 1'b0) ? vnu_msg_in_47 : cnu_msg_in_47;
assign msg_mux_out[48] = (sched_cmd == 1'b0) ? vnu_msg_in_48 : cnu_msg_in_48;
assign msg_mux_out[49] = (sched_cmd == 1'b0) ? vnu_msg_in_49 : cnu_msg_in_49;
assign msg_mux_out[50] = (sched_cmd == 1'b0) ? vnu_msg_in_50 : cnu_msg_in_50;
assign msg_mux_out[51] = (sched_cmd == 1'b0) ? vnu_msg_in_51 : cnu_msg_in_51;
assign msg_mux_out[52] = (sched_cmd == 1'b0) ? vnu_msg_in_52 : cnu_msg_in_52;
assign msg_mux_out[53] = (sched_cmd == 1'b0) ? vnu_msg_in_53 : cnu_msg_in_53;
assign msg_mux_out[54] = (sched_cmd == 1'b0) ? vnu_msg_in_54 : cnu_msg_in_54;
assign msg_mux_out[55] = (sched_cmd == 1'b0) ? vnu_msg_in_55 : cnu_msg_in_55;
assign msg_mux_out[56] = (sched_cmd == 1'b0) ? vnu_msg_in_56 : cnu_msg_in_56;
assign msg_mux_out[57] = (sched_cmd == 1'b0) ? vnu_msg_in_57 : cnu_msg_in_57;
assign msg_mux_out[58] = (sched_cmd == 1'b0) ? vnu_msg_in_58 : cnu_msg_in_58;
assign msg_mux_out[59] = (sched_cmd == 1'b0) ? vnu_msg_in_59 : cnu_msg_in_59;
assign msg_mux_out[60] = (sched_cmd == 1'b0) ? vnu_msg_in_60 : cnu_msg_in_60;
assign msg_mux_out[61] = (sched_cmd == 1'b0) ? vnu_msg_in_61 : cnu_msg_in_61;
assign msg_mux_out[62] = (sched_cmd == 1'b0) ? vnu_msg_in_62 : cnu_msg_in_62;
assign msg_mux_out[63] = (sched_cmd == 1'b0) ? vnu_msg_in_63 : cnu_msg_in_63;
assign msg_mux_out[64] = (sched_cmd == 1'b0) ? vnu_msg_in_64 : cnu_msg_in_64;
assign msg_mux_out[65] = (sched_cmd == 1'b0) ? vnu_msg_in_65 : cnu_msg_in_65;
assign msg_mux_out[66] = (sched_cmd == 1'b0) ? vnu_msg_in_66 : cnu_msg_in_66;
assign msg_mux_out[67] = (sched_cmd == 1'b0) ? vnu_msg_in_67 : cnu_msg_in_67;
assign msg_mux_out[68] = (sched_cmd == 1'b0) ? vnu_msg_in_68 : cnu_msg_in_68;
assign msg_mux_out[69] = (sched_cmd == 1'b0) ? vnu_msg_in_69 : cnu_msg_in_69;
assign msg_mux_out[70] = (sched_cmd == 1'b0) ? vnu_msg_in_70 : cnu_msg_in_70;
assign msg_mux_out[71] = (sched_cmd == 1'b0) ? vnu_msg_in_71 : cnu_msg_in_71;
assign msg_mux_out[72] = (sched_cmd == 1'b0) ? vnu_msg_in_72 : cnu_msg_in_72;
assign msg_mux_out[73] = (sched_cmd == 1'b0) ? vnu_msg_in_73 : cnu_msg_in_73;
assign msg_mux_out[74] = (sched_cmd == 1'b0) ? vnu_msg_in_74 : cnu_msg_in_74;
assign msg_mux_out[75] = (sched_cmd == 1'b0) ? vnu_msg_in_75 : cnu_msg_in_75;
assign msg_mux_out[76] = (sched_cmd == 1'b0) ? vnu_msg_in_76 : cnu_msg_in_76;
assign msg_mux_out[77] = (sched_cmd == 1'b0) ? vnu_msg_in_77 : cnu_msg_in_77;
assign msg_mux_out[78] = (sched_cmd == 1'b0) ? vnu_msg_in_78 : cnu_msg_in_78;
assign msg_mux_out[79] = (sched_cmd == 1'b0) ? vnu_msg_in_79 : cnu_msg_in_79;
assign msg_mux_out[80] = (sched_cmd == 1'b0) ? vnu_msg_in_80 : cnu_msg_in_80;
assign msg_mux_out[81] = (sched_cmd == 1'b0) ? vnu_msg_in_81 : cnu_msg_in_81;
assign msg_mux_out[82] = (sched_cmd == 1'b0) ? vnu_msg_in_82 : cnu_msg_in_82;
assign msg_mux_out[83] = (sched_cmd == 1'b0) ? vnu_msg_in_83 : cnu_msg_in_83;
assign msg_mux_out[84] = (sched_cmd == 1'b0) ? vnu_msg_in_84 : cnu_msg_in_84;
endmodule

/*----------Without (z/Pc)-cycle delay option----------------------------------*/
module align_cmd_gen_0 #(
	parameter LAYER_NUM = 3
)(
	output wire delay_cmd,
	input wire [LAYER_NUM-1:0] layer_status,
);

//0) Two-delay-only inseration on Layer A
assign delay_cmd = (layer_status[0] == 1'b1) ? 1'b1 : 1'b0;
endmodule

module align_cmd_gen_1 #(
	parameter LAYER_NUM = 3
)(
	output wire delay_cmd,
	input wire [LAYER_NUM-1:0] layer_status
);

// 1) Two-delay-only inseration on Layer B:
assign delay_cmd = (layer_status[1] == 1'b1) ? 1'b1 : 1'b0;
endmodule

module align_cmd_gen_2 #(
	parameter LAYER_NUM = 3
)(
	output wire delay_cmd,
	input wire [LAYER_NUM-1:0] layer_status
);

// 2) Two-delay-only inseration on Layer A and B:
assign delay_cmd = (layer_status[0] == 1'b1 || layer_status[1] == 1'b1) ? 1'b1 : 1'b0;
endmodule

module align_cmd_gen_3 #(
	parameter LAYER_NUM = 3
)(
	output wire delay_cmd,
	input wire [LAYER_NUM-1:0] layer_status
);

// 3) Two-delay-only inseration on Layer C:
assign delay_cmd = (layer_status[2] == 1'b1) ? 1'b1 : 1'b0;
endmodule

module align_cmd_gen_4 #(
	parameter LAYER_NUM = 3
)(
	output wire delay_cmd,
	input wire [LAYER_NUM-1:0] layer_status
);

// 4) Two-delay-only inseration on Layer A and C:
assign delay_cmd = (layer_status[0] == 1'b1 || layer_status[2] == 1'b1) ? 1'b1 : 1'b0;
endmodule

module align_cmd_gen_5 #(
	parameter LAYER_NUM = 3
)(
	output wire delay_cmd,
	input wire [LAYER_NUM-1:0] layer_status
);

// 5) Two-delay-only inseration on Layer B and C:
assign delay_cmd = (layer_status[1] == 1'b1 || layer_status[2] == 1'b1) ? 1'b1 : 1'b0;
endmodule

module page_align_depth_1_2 #(
	parameter QUAN_SIZE = 4
) (
	output wire [QUAN_SIZE-1:0] align_out,

	input wire [QUAN_SIZE-1:0] align_target_in,
	input wire delay_cmd,
	input wire sys_clk,
	input wire rstn
);

reg [QUAN_SIZE-1:0] delay_insert_0;
reg [QUAN_SIZE-1:0] delay_insert_1;
always @(posedge sys_clk) begin
	if(rstn == 1'b0) delay_insert_0 <= 0;
	else delay_insert_0[QUAN_SIZE-1:0] <= align_target_in[QUAN_SIZE-1:0];
end

always @(posedge sys_clk) begin
	if(rstn == 1'b0) delay_insert_1 <= 0;
	else delay_insert_1[QUAN_SIZE-1:0] <= delay_insert_0[QUAN_SIZE-1:0];
end

assign align_out[QUAN_SIZE-1:0] = (delay_cmd == 1'b0) ? delay_insert_0[QUAN_SIZE-1:0] : delay_insert_1[QUAN_SIZE-1:0];
endmodule

module page_align_depth_1 #(
	parameter QUAN_SIZE = 4
) (
	output wire [QUAN_SIZE-1:0] align_out,

	input wire [QUAN_SIZE-1:0] align_target_in,
	input wire sys_clk,
	input wire rstn
);

reg [QUAN_SIZE-1:0] delay_insert_0;
always @(posedge sys_clk) begin
	if(rstn == 1'b0) delay_insert_0 <= 0;
	else delay_insert_0[QUAN_SIZE-1:0] <= align_target_in[QUAN_SIZE-1:0];
end

assign align_out[QUAN_SIZE-1:0] = delay_insert_0[QUAN_SIZE-1:0];
endmodule

module page_align_depth_2 #(
	parameter QUAN_SIZE = 4
) (
	output wire [QUAN_SIZE-1:0] align_out,

	input wire [QUAN_SIZE-1:0] align_target_in,
	input wire sys_clk,
	input wire rstn
);

reg [QUAN_SIZE-1:0] delay_insert_0;
reg [QUAN_SIZE-1:0] delay_insert_1;
always @(posedge sys_clk) begin
	if(rstn == 1'b0) delay_insert_0 <= 0;
	else delay_insert_0[QUAN_SIZE-1:0] <= align_target_in[QUAN_SIZE-1:0];
end
always @(posedge sys_clk) begin
	if(rstn == 1'b0) delay_insert_1 <= 0;
	else delay_insert_1[QUAN_SIZE-1:0] <= delay_insert_0[QUAN_SIZE-1:0];
end
assign align_out[QUAN_SIZE-1:0] = delay_insert_1[QUAN_SIZE-1:0];
endmodule
/*----------With (z/Pc)-cycle delay option----------------------------------*/
module circular_align_cmd_gen_0 #(
	parameter LAYER_NUM = 3
)(
	output wire [1:0] delay_cmd, // '0': 1-cycle delay cmd; '1': 2-cycle delay cmd; '2':(z/Pc)-cycle delay cmd - circular case
	input wire [LAYER_NUM-1:0] layer_status,
	input wire first_row_chunk
);

//0) Two-delay-only inseration on Layer A
assign delay_cmd = (layer_status[0] == 1'b1 && first_row_chunk == 1'b1) ? 2'b10 :
				   (layer_status[0] == 1'b1 && first_row_chunk == 1'b0) ? 2'b01 : 2'b00;
endmodule

module circular_align_cmd_gen_1 #(
	parameter LAYER_NUM = 3
)(
	output wire [1:0] delay_cmd, // '0': 1-cycle delay cmd; '1': 2-cycle delay cmd; '2':(z/Pc)-cycle delay cmd - circular case
	input wire [LAYER_NUM-1:0] layer_status,
	input wire first_row_chunk
);

// 1) Two-delay-only inseration on Layer B:
assign delay_cmd = (layer_status[1] == 1'b1 && first_row_chunk == 1'b1) ? 2'b10 :
				   (layer_status[1] == 1'b1 && first_row_chunk == 1'b0) ? 2'b01 : 2'b00;
endmodule

module circular_align_cmd_gen_2 #(
	parameter LAYER_NUM = 3
)(
	output wire [1:0] delay_cmd, // '0': 1-cycle delay cmd; '1': 2-cycle delay cmd; '2':(z/Pc)-cycle delay cmd - circular case
	input wire [LAYER_NUM-1:0] layer_status,
	input wire first_row_chunk
);

// 2) Two-delay-only inseration on Layer A and B:
assign delay_cmd = ((layer_status[0] == 1'b1 || layer_status[1] == 1'b1) && first_row_chunk == 1'b1) ? 2'b10
				   ((layer_status[0] == 1'b1 || layer_status[1] == 1'b1) && first_row_chunk == 1'b0) ? 2'b01 : 2'b00;
endmodule

module circular_align_cmd_gen_3 #(
	parameter LAYER_NUM = 3
)(
	output wire [1:0] delay_cmd, // '0': 1-cycle delay cmd; '1': 2-cycle delay cmd; '2':(z/Pc)-cycle delay cmd - circular case
	input wire [LAYER_NUM-1:0] layer_status,
	input wire first_row_chunk
);

// 3) Two-delay-only inseration on Layer C:
assign delay_cmd = (layer_status[2] == 1'b1 && first_row_chunk == 1'b1) ? 2'b10 :
				   (layer_status[2] == 1'b1 && first_row_chunk == 1'b0) ? 2'b01 : 2'b00;
endmodule

module circular_align_cmd_gen_4 #(
	parameter LAYER_NUM = 3
)(
	output wire [1:0] delay_cmd, // '0': 1-cycle delay cmd; '1': 2-cycle delay cmd; '2':(z/Pc)-cycle delay cmd - circular case
	input wire [LAYER_NUM-1:0] layer_status,
	input wire first_row_chunk
);

// 4) Two-delay-only inseration on Layer A and C:
assign delay_cmd = ((layer_status[0] == 1'b1 || layer_status[2] == 1'b1) && first_row_chunk == 1'b1) ? 2'b10 : 
			       ((layer_status[0] == 1'b1 || layer_status[2] == 1'b1) && first_row_chunk == 1'b0) ? 2'b01 : 2'b00;
endmodule

module circular_align_cmd_gen_5 #(
	parameter LAYER_NUM = 3
)(
	output wire [1:0] delay_cmd, // '0': 1-cycle delay cmd; '1': 2-cycle delay cmd; '2':(z/Pc)-cycle delay cmd - circular case
	input wire [LAYER_NUM-1:0] layer_status,
	input wire first_row_chunk
);

// 5) Two-delay-only inseration on Layer B and C:
assign delay_cmd = ((layer_status[1] == 1'b1 || layer_status[2] == 1'b1) && first_row_chunk == 1'b1) ? 2'b10
                   ((layer_status[1] == 1'b1 || layer_status[2] == 1'b1) && first_row_chunk == 1'b0) ? 2'b01 : 2'b00;
endmodule

module circular_page_align_depth_1_2 #(
	parameter QUAN_SIZE = 4
) (
	output wire [QUAN_SIZE-1:0] align_out,

	input wire [QUAN_SIZE-1:0] align_target_in,
	input wire [1:0] delay_cmd, // '0': 1-cycle delay cmd; '1': 2-cycle delay cmd; '2':(z/Pc)-cycle delay cmd - circular case
	input wire sys_clk,
	input wire rstn
);

reg [QUAN_SIZE-1:0] delay_insert_0; reg [QUAN_SIZE-1:0] delay_insert_1; reg [QUAN_SIZE-1:0] delay_insert_2;
reg [QUAN_SIZE-1:0] delay_insert_3; reg [QUAN_SIZE-1:0] delay_insert_4; reg [QUAN_SIZE-1:0] delay_insert_5;
reg [QUAN_SIZE-1:0] delay_insert_6; reg [QUAN_SIZE-1:0] delay_insert_7; reg [QUAN_SIZE-1:0] delay_insert_8;
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_0 <= 0; else delay_insert_0[QUAN_SIZE-1:0] <= align_target_in[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_1 <= 0; else delay_insert_1[QUAN_SIZE-1:0] <= delay_insert_0[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_2 <= 0; else delay_insert_2[QUAN_SIZE-1:0] <= delay_insert_1[QUAN_SIZE-1:0]; end 
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_3 <= 0; else delay_insert_3[QUAN_SIZE-1:0] <= delay_insert_2[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_4 <= 0; else delay_insert_4[QUAN_SIZE-1:0] <= delay_insert_3[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_5 <= 0; else delay_insert_5[QUAN_SIZE-1:0] <= delay_insert_4[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_6 <= 0; else delay_insert_6[QUAN_SIZE-1:0] <= delay_insert_5[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_7 <= 0; else delay_insert_7[QUAN_SIZE-1:0] <= delay_insert_6[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_8 <= 0; else delay_insert_8[QUAN_SIZE-1:0] <= delay_insert_7[QUAN_SIZE-1:0]; end

assign align_out[QUAN_SIZE-1:0] = (delay_cmd == 2'b00) ? delay_insert_0[QUAN_SIZE-1:0] : 
								  (delay_cmd == 2'b01) ? delay_insert_1[QUAN_SIZE-1:0] : 
								  						 delay_insert_8[QUAN_SIZE-1:0] ; // delay_cmd == 2'b10
endmodule

module circular_page_align_depth_1 #(
	parameter QUAN_SIZE = 4
) (
	output wire [QUAN_SIZE-1:0] align_out,

	input wire [QUAN_SIZE-1:0] align_target_in,
	input wire first_row_chunk,
	input wire sys_clk,
	input wire rstn
);

reg [QUAN_SIZE-1:0] delay_insert_0; reg [QUAN_SIZE-1:0] delay_insert_1; reg [QUAN_SIZE-1:0] delay_insert_2;
reg [QUAN_SIZE-1:0] delay_insert_3; reg [QUAN_SIZE-1:0] delay_insert_4; reg [QUAN_SIZE-1:0] delay_insert_5;
reg [QUAN_SIZE-1:0] delay_insert_6; reg [QUAN_SIZE-1:0] delay_insert_7; reg [QUAN_SIZE-1:0] delay_insert_8;
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_0 <= 0; else delay_insert_0[QUAN_SIZE-1:0] <= align_target_in[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_1 <= 0; else delay_insert_1[QUAN_SIZE-1:0] <= delay_insert_0[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_2 <= 0; else delay_insert_2[QUAN_SIZE-1:0] <= delay_insert_1[QUAN_SIZE-1:0]; end 
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_3 <= 0; else delay_insert_3[QUAN_SIZE-1:0] <= delay_insert_2[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_4 <= 0; else delay_insert_4[QUAN_SIZE-1:0] <= delay_insert_3[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_5 <= 0; else delay_insert_5[QUAN_SIZE-1:0] <= delay_insert_4[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_6 <= 0; else delay_insert_6[QUAN_SIZE-1:0] <= delay_insert_5[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_7 <= 0; else delay_insert_7[QUAN_SIZE-1:0] <= delay_insert_6[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_8 <= 0; else delay_insert_8[QUAN_SIZE-1:0] <= delay_insert_7[QUAN_SIZE-1:0]; end

assign align_out[QUAN_SIZE-1:0] = (first_row_chunk == 1'b1) ? delay_insert_8[QUAN_SIZE-1:0] : delay_insert_0[QUAN_SIZE-1:0];
endmodule

module circular_page_align_depth_2 #(
	parameter QUAN_SIZE = 4
) (
	output wire [QUAN_SIZE-1:0] align_out,

	input wire [QUAN_SIZE-1:0] align_target_in,
	input wire first_row_chunk,
	input wire sys_clk,
	input wire rstn
);

reg [QUAN_SIZE-1:0] delay_insert_0; reg [QUAN_SIZE-1:0] delay_insert_1; reg [QUAN_SIZE-1:0] delay_insert_2;
reg [QUAN_SIZE-1:0] delay_insert_3; reg [QUAN_SIZE-1:0] delay_insert_4; reg [QUAN_SIZE-1:0] delay_insert_5;
reg [QUAN_SIZE-1:0] delay_insert_6; reg [QUAN_SIZE-1:0] delay_insert_7; reg [QUAN_SIZE-1:0] delay_insert_8;
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_0 <= 0; else delay_insert_0[QUAN_SIZE-1:0] <= align_target_in[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_1 <= 0; else delay_insert_1[QUAN_SIZE-1:0] <= delay_insert_0[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_2 <= 0; else delay_insert_2[QUAN_SIZE-1:0] <= delay_insert_1[QUAN_SIZE-1:0]; end 
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_3 <= 0; else delay_insert_3[QUAN_SIZE-1:0] <= delay_insert_2[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_4 <= 0; else delay_insert_4[QUAN_SIZE-1:0] <= delay_insert_3[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_5 <= 0; else delay_insert_5[QUAN_SIZE-1:0] <= delay_insert_4[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_6 <= 0; else delay_insert_6[QUAN_SIZE-1:0] <= delay_insert_5[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_7 <= 0; else delay_insert_7[QUAN_SIZE-1:0] <= delay_insert_6[QUAN_SIZE-1:0]; end
always @(posedge sys_clk) begin if(rstn == 1'b0) delay_insert_8 <= 0; else delay_insert_8[QUAN_SIZE-1:0] <= delay_insert_7[QUAN_SIZE-1:0]; end

assign align_out[QUAN_SIZE-1:0] = (first_row_chunk == 1'b1) ? delay_insert_8[QUAN_SIZE-1:0] : delay_insert_1[QUAN_SIZE-1:0];//delay_insert_1[QUAN_SIZE-1:0];
endmodule