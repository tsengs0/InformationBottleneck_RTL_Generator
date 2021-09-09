//`default_nettype none
`include "revision_def.vh"

module partial_cnu_10 #(
	parameter CN_DEGREE = 10,
	parameter QUAN_SIZE = 4,
	parameter MAG_SIZE = 3,
	parameter ROW_SPLIT_FACTOR = 5
) (
	output wire [QUAN_SIZE-1:0] ch_to_var_0,
	output wire [QUAN_SIZE-1:0] ch_to_var_1,

	input wire [QUAN_SIZE-1:0] var_to_ch_0,
	input wire [QUAN_SIZE-1:0] var_to_ch_1,

	input wire first_comp, // comparison for first set of v2c incoming messages
	input sys_clk,
	input rstn
);

localparam EXT_MSG_PARALLELISM = CN_DEGREE/ROW_SPLIT_FACTOR;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//wire [EXT_MSG_PARALLELISM-1:0] Q_signs;
wire [MAG_SIZE-1:0] Q_mag [0:EXT_MSG_PARALLELISM-1];

// Product-Sign
wire common_reduction_parity;
assign common_reduction_parity = var_to_ch_0[QUAN_SIZE-1]^var_to_ch_1[QUAN_SIZE-1];

`ifdef SYM_NO_IO_CONV
assign Q_mag[0] = var_to_ch_0[MAG_SIZE-1:0];
assign Q_mag[1] = var_to_ch_1[MAG_SIZE-1:0];
`else
// Sign-Magnitude conversion of all var-to-ch messages
assign Q_mag[0] = (var_to_ch_0[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_0[MAG_SIZE-1:0] : var_to_ch_0[MAG_SIZE-1:0];
assign Q_mag[1] = (var_to_ch_1[QUAN_SIZE-1] == 1'b0) ? ~var_to_ch_1[MAG_SIZE-1:0] : var_to_ch_1[MAG_SIZE-1:0];
`endif
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pipeline Stage 0
reg common_reduction_parity_reg0; initial common_reduction_parity_reg0 <= 1'b0;
reg [ROW_SPLIT_FACTOR-1:0] y_v0_sign_reg;
reg [ROW_SPLIT_FACTOR-1:0] y_v1_sign_reg;
always @(posedge sys_clk) begin if(!rstn) y_v0_sign_reg[0] <= 1'b0; else y_v0_sign_reg[0] <= var_to_ch_0[QUAN_SIZE-1]; end
always @(posedge sys_clk) begin if(!rstn) y_v1_sign_reg[0] <= 1'b0; else y_v1_sign_reg[0] <= var_to_ch_1[QUAN_SIZE-1]; end
genvar sign_propagate_id;
generate
	for(sign_propagate_id=1;sign_propagate_id<ROW_SPLIT_FACTOR;sign_propagate_id=sign_propagate_id+1) begin : y0_y1_sign_propagation
		always @(posedge sys_clk) begin if(!rstn) y_v0_sign_reg[sign_propagate_id] <= 1'b0; else y_v0_sign_reg[sign_propagate_id] <= y_v0_sign_reg[sign_propagate_id-1]; end
		always @(posedge sys_clk) begin if(!rstn) y_v1_sign_reg[sign_propagate_id] <= 1'b0; else y_v1_sign_reg[sign_propagate_id] <= y_v1_sign_reg[sign_propagate_id-1]; end
	end
endgenerate

reg [MAG_SIZE-1:0] feedback_Q_mag [0:EXT_MSG_PARALLELISM-1];
reg feedback_min_index_level_0;
wire [1:0] is_min_0_in;
wire [1:0] is_min_1_in;
wire min_index_newIn_set;
partial_base_cnu_min_10 #(
	.CN_DEGREE        (CN_DEGREE       ),
	.QUAN_SIZE        (MAG_SIZE        ),
	.ROW_SPLIT_FACTOR (ROW_SPLIT_FACTOR)
) u0 (
	//output wire [QUAN_SIZE-1:0] m1,
	//output wire [QUAN_SIZE-1:0] m2,
	.is_min_0_in (is_min_0_in[1:0]),
	.is_min_1_in (is_min_1_in[1:0]),
	.min_index_newIn_set (min_index_newIn_set),

	.de_msg_0 (Q_mag[0]),
	.de_msg_1 (Q_mag[1]),
	.de_msg_2 (feedback_Q_mag[0]),
	.de_msg_3 (feedback_Q_mag[1]),
	.feedback_min_index_level_0 (feedback_min_index_level_0),
	.first_comp (first_comp) // comparison for first set of v2c incoming messages
);
always @(sys_clk) begin if(!rstn) feedback_min_index_level_0 <= 1'b0; else feedback_min_index_level_0 <= min_index_newIn_set; end
// Registers to keep the local minimum and local second minimum (at this moment)
// Updating the latest local minimum
wire [MAG_SIZE-1:0] min_0_in0 = (is_min_0_in[0] == 1'b1 && min_index_newIn_set == 1'b0) ? Q_mag[0] : 
							    (is_min_0_in[0] == 1'b1 && min_index_newIn_set == 1'b1) ? Q_mag[1] : 0;
wire [MAG_SIZE-1:0] min_0_in1 = (is_min_0_in[1] == 1'b1) ? feedback_Q_mag[0] : 0;
always @(posedge sys_clk) begin if(!rstn) feedback_Q_mag[0] <= 0; else feedback_Q_mag[0] <= min_0_in0^min_0_in1; end
// Updating the lateset local second minimum
wire [MAG_SIZE-1:0] min_1_in0 = (is_min_0_in[0] == 1'b1 && is_min_1_in[0] == 1'b1) ? Q_mag[~min_index_newIn_set] : 
								(is_min_0_in[0] == 1'b0 && is_min_1_in[0] == 1'b1) ? Q_mag[min_index_newIn_set]  : 0;
wire [MAG_SIZE-1:0] min_1_in1 = (is_min_0_in[1] == 1'b1 && is_min_1_in[1] == 1'b1) ? feedback_Q_mag[1] : 
								(is_min_0_in[1] == 1'b0 && is_min_1_in[1] == 1'b1) ? feedback_Q_mag[0] : 0;
always @(posedge sys_clk) begin if(!rstn) feedback_Q_mag[1] <= 0; else feedback_Q_mag[1] <= min_1_in0^min_1_in1; end

// State Change
wire [ROW_SPLIT_FACTOR-1:0] pipeline_level_in;
reg [ROW_SPLIT_FACTOR-2:0] pipeline_level_in_reg;
// For both In0 and In1
always @(posedge sys_clk) begin 
	if(!rstn) pipeline_level_in_reg[0] <= 0;
	else pipeline_level_in_reg[0] <= first_comp; 
end
genvar propagate_id;
generate
	for(propagate_id=1;propagate_id<ROW_SPLIT_FACTOR-1;propagate_id=propagate_id+1) begin : state_change_shfiter
		// For both In0 and In1
		always @(posedge sys_clk) begin 
			if(!rstn) pipeline_level_in_reg[propagate_id] <= 0;
			else pipeline_level_in_reg[propagate_id] <= pipeline_level_in_reg[propagate_id-1]; 
		end
	end
endgenerate
assign pipeline_level_in = {pipeline_level_in_reg[ROW_SPLIT_FACTOR-2:0], first_comp};
///////////////////////////////////////////////////////////////////////////////////
// To point out the index of global minimum
///////////////////////////////////////////////////////////////////////////////////
wire state_change_min_0 = is_min_0_in[0];// & is_min_0_in[1];
reg [ROW_SPLIT_FACTOR-1:0] is_minimum_pointers_in [0:EXT_MSG_PARALLELISM-1];
generate
	for(propagate_id=0;propagate_id<ROW_SPLIT_FACTOR-1;propagate_id=propagate_id+1) begin : control_of_minimum_pointer
		// For In0
		always @(posedge sys_clk) begin
			if(rstn == 1'b0) is_minimum_pointers_in[0][propagate_id] <= 0;
			else if(pipeline_level_in[ROW_SPLIT_FACTOR-1] == 1'b1) is_minimum_pointers_in[0][propagate_id] <= 1'b0;
			else if(state_change_min_0 == 1'b1) is_minimum_pointers_in[0][propagate_id] <= ~min_index_newIn_set & pipeline_level_in[propagate_id];
		end
		// For In1
		always @(posedge sys_clk) begin
			if(rstn == 1'b0) is_minimum_pointers_in[1][propagate_id] <= 0;
			else if(pipeline_level_in[ROW_SPLIT_FACTOR-1] == 1'b1) is_minimum_pointers_in[1][propagate_id] <= 1'b0;
			else if(state_change_min_0 == 1'b1) is_minimum_pointers_in[1][propagate_id] <= min_index_newIn_set & pipeline_level_in[propagate_id];
		end
	end
endgenerate
// For In0
always @(posedge sys_clk) begin
	if(rstn == 1'b0) is_minimum_pointers_in[0][ROW_SPLIT_FACTOR-1] <= 0;
	else if(state_change_min_0 == 1'b1) is_minimum_pointers_in[0][ROW_SPLIT_FACTOR-1] <= ~min_index_newIn_set & pipeline_level_in[ROW_SPLIT_FACTOR-1];
end
// For In1
always @(posedge sys_clk) begin
	if(rstn == 1'b0) is_minimum_pointers_in[1][ROW_SPLIT_FACTOR-1] <= 0;
	else if(state_change_min_0 == 1'b1) is_minimum_pointers_in[1][ROW_SPLIT_FACTOR-1] <= min_index_newIn_set & pipeline_level_in[ROW_SPLIT_FACTOR-1];
end
///////////////////////////////////////////////////////////////////////////////////
reg [ROW_SPLIT_FACTOR-1:0] is_minimum_pointers_out [0:EXT_MSG_PARALLELISM-1];
wire [ROW_SPLIT_FACTOR-1:0] mag_0_sel;
wire [ROW_SPLIT_FACTOR-1:0] mag_1_sel;
generate
	for(propagate_id=0;propagate_id<ROW_SPLIT_FACTOR;propagate_id=propagate_id+1) begin : output_propagate_of_minimum_pointer
		// For In0
		always @(posedge sys_clk) begin
			if(rstn == 1'b0) is_minimum_pointers_out[0][propagate_id] <= 0;
			else if(pipeline_level_in[ROW_SPLIT_FACTOR-1] == 1'b1) is_minimum_pointers_out[0][propagate_id] <= is_minimum_pointers_in[0][propagate_id];
		end
		// For In1
		always @(posedge sys_clk) begin
			if(rstn == 1'b0) is_minimum_pointers_out[1][propagate_id] <= 0;
			else if(pipeline_level_in[ROW_SPLIT_FACTOR-1] == 1'b1) is_minimum_pointers_out[1][propagate_id] <= is_minimum_pointers_in[1][propagate_id];
		end

		// Assigning magnitudes of outgoing (extrinsic) msssages - datapath portion 0
		assign mag_0_sel[propagate_id] = (pipeline_level_in[propagate_id] == 1'b1) ? is_minimum_pointers_out[0][propagate_id] : 0;
		assign mag_1_sel[propagate_id] = (pipeline_level_in[propagate_id] == 1'b1) ? is_minimum_pointers_out[1][propagate_id] : 0;
	end
endgenerate
always @(posedge sys_clk) begin if(!rstn) common_reduction_parity_reg0 <= 1'b0; else if(pipeline_level_in[ROW_SPLIT_FACTOR-1] == 1'b1) common_reduction_parity_reg0 <= 1'b0; else common_reduction_parity_reg0 <= common_reduction_parity^common_reduction_parity_reg0; end
reg common_reduction_parity_out_reg0; initial common_reduction_parity_out_reg0 <= 1'b0;
wire common_reduction_parity_out;
always @(posedge sys_clk) begin if(!rstn) common_reduction_parity_out_reg0 <= 1'b0; else if(pipeline_level_in[0] == 1'b1) common_reduction_parity_out_reg0 <= common_reduction_parity_reg0; end
assign common_reduction_parity_out = (pipeline_level_in[0] & common_reduction_parity_reg0) | (~pipeline_level_in[0] & common_reduction_parity_out_reg0);
///////////////////////////////////////////////////////////////////////////////////
// Assigning magnitudes of outgoing (extrinsic) msssages - datapath portion 1
///////////////////////////////////////////////////////////////////////////////////
wire mag_0_sel_final = ^mag_0_sel[ROW_SPLIT_FACTOR-1:0];
wire mag_1_sel_final = ^mag_1_sel[ROW_SPLIT_FACTOR-1:0];
wire [MAG_SIZE-1:0] min_0_mag [0:EXT_MSG_PARALLELISM-1];
wire [MAG_SIZE-1:0] min_1_mag [0:EXT_MSG_PARALLELISM-1];
reg [MAG_SIZE-1:0] feedback_Q_mag_out [0:EXT_MSG_PARALLELISM-1];
always @(posedge sys_clk) begin if(!rstn) feedback_Q_mag_out[0] <= 0; else if(pipeline_level_in[ROW_SPLIT_FACTOR-1] == 1'b1) feedback_Q_mag_out[0] <= feedback_Q_mag[0]; end
always @(posedge sys_clk) begin if(!rstn) feedback_Q_mag_out[1] <= 0; else if(pipeline_level_in[ROW_SPLIT_FACTOR-1] == 1'b1) feedback_Q_mag_out[1] <= feedback_Q_mag[1]; end
assign min_0_mag[0] = (mag_0_sel_final == 1'b0) ? feedback_Q_mag_out[0] : 0;
assign min_1_mag[0] = (mag_0_sel_final == 1'b1) ? feedback_Q_mag_out[1] : 0;
assign ch_to_var_0[MAG_SIZE-1:0] = min_0_mag[0]^min_1_mag[0];

assign min_0_mag[1] = (mag_1_sel_final == 1'b0) ? feedback_Q_mag_out[0] : 0;
assign min_1_mag[1] = (mag_1_sel_final == 1'b1) ? feedback_Q_mag_out[1] : 0;
assign ch_to_var_1[MAG_SIZE-1:0] = min_0_mag[1]^min_1_mag[1];

assign ch_to_var_0[QUAN_SIZE-1] = y_v0_sign_reg[ROW_SPLIT_FACTOR-1]^common_reduction_parity_out;
assign ch_to_var_1[QUAN_SIZE-1] = y_v1_sign_reg[ROW_SPLIT_FACTOR-1]^common_reduction_parity_out;
endmodule