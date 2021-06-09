`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2020 04:18:16 PM
// Design Name: 
// Module Name: sys_control_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "define.vh"

module vnu_control_unit #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter RESET_CYCLE = 100, // once rstn is deasserted, the system goes into reset mode for 100 clock cycles
	parameter VN_PIPELINE_BUBBLE = 1, // the number of halt instructions within vnu pipelining

	parameter VN_LOAD_CYCLE = 64, // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update

	parameter VNU_FUNC_CYCLE = 3, // the latency of one VNU 2-LUT function based on symmetrical design
	parameter DNU_FUNC_CYCLE = 3, // the latency of one DNU 2-LUT function based on symmetrical design

	parameter VNU_FUNC_MEM_END = 2, // the Memory Read ends at rising edge of 2nd clock (indexed from 0th cycle)
	parameter DNU_FUNC_MEM_END = 2, // the Memory Read ends at rising edge of 2nd clock (indexed from 0th cycle)

	parameter VNU_WR_HANDSHAKE_RESPONSE = 2, // response time from assertion of pipe_load_start until rising edge of vnu_wr
	parameter DNU_WR_HANDSHAKE_RESPONSE = 2, // response time from assertion of pipe_load_start until rising edge of vnu_wr
	
	parameter VNU_PIPELINE_LEVEL = 2*VNU_FUNC_CYCLE+VN_PIPELINE_BUBBLE, // the last pipeline register is actually shared with P2P_V
	parameter DNU_PIPELINE_LEVEL = 1*DNU_FUNC_CYCLE, 
   
    parameter PERMUTATION_LEVEL = 2, // every circular shifter takes 2 clock cycles
    parameter PAGE_ALIGN_LEVEL  = 1,
	parameter MEM_RD_LEVEL      = 2, // every memory fetching process take 2 clock cycles
	parameter FSM_STATE_NUM     = 9,
	parameter [$clog2(FSM_STATE_NUM)-1:0] INIT_LOAD     = 0,
	parameter [$clog2(FSM_STATE_NUM)-1:0] MEM_FETCH     = 1,
	parameter [$clog2(FSM_STATE_NUM)-1:0] VNU_IB_RAM_PEND   = 2,
	parameter [$clog2(FSM_STATE_NUM)-1:0] VNU_PIPE      = 3,
	parameter [$clog2(FSM_STATE_NUM)-1:0] VNU_OUT       = 4,
	parameter [$clog2(FSM_STATE_NUM)-1:0] BS_WB 		= 5,
	parameter [$clog2(FSM_STATE_NUM)-1:0] PAGE_ALIGN 	= 6,
	parameter [$clog2(FSM_STATE_NUM)-1:0] MEM_WB 		= 7,
	parameter [$clog2(FSM_STATE_NUM)-1:0] IDLE  		= 8
)(
	// output port for IB-ROM update
	output wire [`IB_VNU_DECOMP_funNum-1:0] vnu_wr,
	output wire dnu_wr,
	output wire vnu_update_pend,

    output wire v2c_src,
    output wire last_layer,
    output wire v2c_mem_we,

    output wire [`IB_VNU_DECOMP_funNum-1:0] vnu_rd,
	output wire dnu_rd,
	output reg [$clog2(FSM_STATE_NUM)-1:0] state,
	output reg hard_decision_done, // State Signal - hard decision is going to be done one clock cycle later
/*--------------------------------------------------------------------------------------------------------*/  
	// Input port acknowledging from Write/Update FSMs
	input wire [`IB_VNU_DECOMP_funNum-1:0] vn_iter_update,
	input wire dn_iter_update,
   
    input wire layer_finish,
	input wire termination, // finish deocding process of the current frame 
	input wire fsm_en,
	input wire read_clk,
	input wire rstn
);

//------------------------------------------------------------------------------------
// Gloable Parameters
localparam LOAD_HANDSHAKE_LATENCY = 3;
//------------------------------------------------------------------------------------
// The initial process to enter the Initial Load State
localparam RESET_CYCLE_BITWIDTH = $clog2(RESET_CYCLE);
reg [RESET_CYCLE_BITWIDTH-1:0] reset_cnt;
initial reset_cnt <= 0;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) reset_cnt <= 0;
	else reset_cnt <= reset_cnt + 1'b1;
end

reg decode_start;
initial decode_start <= 1'b0;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) decode_start <= 1'b0;
	else if(reset_cnt[RESET_CYCLE_BITWIDTH-1:0] == RESET_CYCLE) decode_start <= 1'b1;
	else decode_start <= decode_start;
end

reg [LAYER_NUM-1:0] layer_cnt;
always @(posedge read_clk) begin
	if(rstn == 1'b0) layer_cnt <= 1;
	else if(layer_finish == 1'b1) layer_cnt[LAYER_NUM-1:0] <= {layer_cnt[LAYER_NUM-2:0], layer_cnt[LAYER_NUM-1]};
	else layer_cnt <= layer_cnt;
end
reg [`MAX_ITER-1:0] iter_cnt;
always @(posedge read_clk) begin
	if(rstn == 1'b0) iter_cnt <= 1;
	else if(layer_cnt[LAYER_NUM-1] == 1'b1 && layer_finish == 1'b1) iter_cnt[`MAX_ITER-1:0] <= {iter_cnt[`MAX_ITER-2:0], 1'b0};
	else iter_cnt <= iter_cnt;
end
assign last_layer = layer_cnt[LAYER_NUM-1];
//------------------------------------------------------------------------------------
// IB-ROMs data fetching process 
// VNU IB-ROMs
wire [`IB_VNU_DECOMP_funNum-1:0] vn_slave_wr_rdy;
wire [`IB_VNU_DECOMP_funNum-1:0] vn_master_wr_valid;
reg  [`IB_VNU_DECOMP_funNum-1:0] vnu_pipe_load_en;      // to be controlled by the main FSM
reg  [`IB_VNU_DECOMP_funNum-1:0] vnu_init_load_en;   // to be controlled by the main FSM
wire [`IB_VNU_DECOMP_funNum-1:0] vnu_init_load_busy; // the progress of the initial-load operation
wire [`IB_VNU_DECOMP_funNum-1:0] vnu_pipe_load_busy;        // the progress of the IB-RAM write operation
// DNU IB-ROMs
wire dn_slave_wr_rdy;
wire dn_master_wr_valid;
reg dnu_pipe_load_en;      // to be controlled by the main FSM
reg dnu_init_load_en;   // to be controlled by the main FSM
wire dnu_init_load_busy; // the progress of the initial-load operation
wire dnu_pipe_load_busy;        // the progress of the IB-RAM write operation
generate
	genvar i, j;
	for(i=0;i<`IB_VNU_DECOMP_funNum;i=i+1) begin : vn_slave_wr_handshake_inst
		vnu_wr_update_handshake vn_wr_handshake(
			.vnu_wr_o			(vn_master_wr_valid[i]),
			.init_load_o		(vnu_init_load_busy[i]),
			.pipe_load_o	    (vnu_pipe_load_busy[i]),
		
			.iter_update_i      (vn_slave_wr_rdy[i]),
			.vnu_rd_finish_i    (vnu_pipe_load_en[i]), 
			.vnu_init_load_en_i (vnu_init_load_en[i]), 
			.read_clk           (read_clk),
			.rstn 	            (rstn) 
		);
		assign vnu_wr[i] = vnu_init_load_busy[i] || vnu_pipe_load_busy[i];//vn_master_wr_valid[i];
		assign vn_slave_wr_rdy[i] = vn_iter_update[i];
	end
endgenerate
vnu_wr_update_handshake dn_wr_handshake(
	.vnu_wr_o			(dn_master_wr_valid),
	.init_load_o		(dnu_init_load_busy),
	.pipe_load_o	    (dnu_pipe_load_busy),

	.iter_update_i      (dn_slave_wr_rdy),
	.vnu_rd_finish_i    (dnu_pipe_load_en), 
	.vnu_init_load_en_i (dnu_init_load_en), 
	.read_clk           (read_clk),
	.rstn 	            (rstn) 
);
assign dnu_wr = dnu_init_load_busy || dnu_pipe_load_busy;//dn_master_wr_valid;
assign dn_slave_wr_rdy = dn_iter_update;
//------------------------------------------------------------------------------------
//  IB-ROM Update Strategies

//------------------------------------------------------------------------------------
// since the FSM is driven by clock, the one more additional decrement is necessary; otherwise the overflow will be actually detected from one more clock cycle later
localparam bs_shift_overflow = 2**(PERMUTATION_LEVEL-1);
localparam fetch_shift_overflow = 2**(MEM_RD_LEVEL-1);
localparam vnu_shift_overflow = 2**(VNU_PIPELINE_LEVEL-1-1);
reg [VNU_PIPELINE_LEVEL-1:0] vnu_pipeline_level;
reg [DNU_PIPELINE_LEVEL-1:0] dnu_pipeline_level;
reg [PERMUTATION_LEVEL-1:0] bs_pipeline_level;
reg [MEM_RD_LEVEL-1:0] fetch_pipeline_level;
reg v2c_msg_busy; // Assertion whenever the message passing is done
`ifdef SCHED_4_6 // only one clock cycle delay of page alignment when schedule 4.6 is configured
	reg page_align_pipeline_level;
`endif
//------------------------------------------------------------------------------------
// Control signals for handshaking scheme between System.FSM and WR.FSM
// Inital-Load operation
reg [2:0] vnu_init_load_cnt [0:`IB_VNU_DECOMP_funNum-1];
reg [`IB_VNU_DECOMP_funNum-1:0] vnu_init_load_start;  // to signal the "START" status of "Initial-Load" operation
reg [`IB_VNU_DECOMP_funNum-1:0] vnu_init_load_finish; // to enable the VNU_PIPE whilst "Initial-Load" operation completed
reg [2:0] dnu_init_load_cnt;
reg dnu_init_load_start;  // to signal the "START" status of "Initial-Load" operation
reg dnu_init_load_finish; // to enable the DNU_PIPE whilst "Initial-Load" operation completed
// Pipe-Load operation for VNUs
reg [2:0] vnu_pipe_load_cnt [0:`IB_VNU_DECOMP_funNum-1];
reg [`IB_VNU_DECOMP_funNum-1:0] vnu_pipe_load_start;  // to signal the "START" status of "PIPE-Load" operation
reg [`IB_VNU_DECOMP_funNum-1:0] vnu_pipe_load_finish; // to enable the CNU_PIPE of next iteration whilst "PIPE-Load" operation completed
// Pipe-Load operation for DNUs
reg [2:0] dnu_pipe_load_cnt;
reg dnu_pipe_load_start;  // to signal the "START" status of "PIPE-Load" operation
reg dnu_pipe_load_finish; // to enable the CNU_PIPE of next iteration whilst "PIPE-Load" operation completed
//------------------------------------------------------------------------------------
initial fetch_pipeline_level[MEM_RD_LEVEL-1:0] <= 0;
always @(posedge read_clk) begin
    if(rstn == 0) 
    	fetch_pipeline_level <= 1;
    else if(state == MEM_FETCH) begin
    	fetch_pipeline_level[MEM_RD_LEVEL-1:0] <= {fetch_pipeline_level[MEM_RD_LEVEL-2:0], fetch_pipeline_level[MEM_RD_LEVEL-1]};
	end
	else fetch_pipeline_level <= 1;
end

initial bs_pipeline_level[PERMUTATION_LEVEL-1:0] <= 0;
always @(posedge read_clk) begin
    if(rstn == 1'b0) 
    	bs_pipeline_level <= 1;
    else if(state == BS_WB) begin 
    	bs_pipeline_level[PERMUTATION_LEVEL-1:0] <= {bs_pipeline_level[PERMUTATION_LEVEL-2:0], bs_pipeline_level[PERMUTATION_LEVEL-1]};
	end
	else 
		bs_pipeline_level[PERMUTATION_LEVEL-1:0] <= 1;
end

initial page_align_pipeline_level <= 0;
always @(posedge read_clk) begin
	if(rstn == 1'b0) page_align_pipeline_level <= 0;
`ifdef SCHED_4_6
	else page_align_pipeline_level <= bs_pipeline_level[PERMUTATION_LEVEL-1];
`else
	else page_align_pipeline_level[PAGE_ALIGN_LEVEL-1:0] <= {page_align_pipeline_level[PAGE_ALIGN_LEVEL-2:0], bs_pipeline_level[PERMUTATION_LEVEL-1]};
`endif
end

initial v2c_msg_busy <= 1'b0;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) v2c_msg_busy <= 1'b0;
`ifdef SCHED_4_6
	else v2c_msg_busy <= ~page_align_pipeline_level;
`else
	else v2c_msg_busy <= ~page_align_pipeline_level[PAGE_ALIGN_LEVEL-1];
`endif
end

initial vnu_pipeline_level <= 0;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0)
		vnu_pipeline_level <= 1;
	else if(state == VNU_PIPE)
		vnu_pipeline_level[VNU_PIPELINE_LEVEL-1:0] <= {vnu_pipeline_level[VNU_PIPELINE_LEVEL-2:0], vnu_pipeline_level[VNU_PIPELINE_LEVEL-1]};
    else //if(state == VNU_OUT) 
		vnu_pipeline_level[VNU_PIPELINE_LEVEL-1:0] <= 1;
end
initial dnu_pipeline_level <= 0;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0)
		dnu_pipeline_level <= 0;
	else if(state == BS_WB || state == PAGE_ALIGN) begin // the Decision Node Operation starts from BS_WB till PAGE_ALIGN
		if(dnu_pipeline_level[DNU_PIPELINE_LEVEL-1:0] == 0)
			dnu_pipeline_level[DNU_PIPELINE_LEVEL-1:0] <= 1;
		else
			dnu_pipeline_level[DNU_PIPELINE_LEVEL-1:0] <= {dnu_pipeline_level[DNU_PIPELINE_LEVEL-2:0], 1'b0};
	end
    else //if(state == MEM_WB) 
		dnu_pipeline_level[DNU_PIPELINE_LEVEL-1:0] <= 0;
end

generate
	for(i=0;i<`IB_VNU_DECOMP_funNum;i=i+1) begin : vnu_load_cnt_inst
		// Init CNT
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) 
				vnu_init_load_cnt[i] <= 0;
			else if(vnu_init_load_start[i] == 1'b1) begin
				if(vnu_init_load_cnt[i] == 0) 
					vnu_init_load_cnt[i] <= 1;
				else if(vnu_init_load_cnt[i] <= LOAD_HANDSHAKE_LATENCY) 
					vnu_init_load_cnt[i] <= vnu_init_load_cnt[i] + 1;
				else if(vnu_init_load_finish[i] == 1'b1)
					vnu_init_load_cnt[i] <= 0;
			end
			else 
				vnu_init_load_cnt[i] <= 0;
		end	
		// Pipe Load CNT
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) 
				vnu_pipe_load_cnt[i] <= 0;
			else if(vnu_pipe_load_start[i] == 1'b1) begin
				if(vnu_pipe_load_cnt[i] == 0) 
					vnu_pipe_load_cnt[i] <= 1;
				else if(vnu_pipe_load_cnt[i] <= LOAD_HANDSHAKE_LATENCY) 
					vnu_pipe_load_cnt[i] <= vnu_pipe_load_cnt[i] + 1;
				else if(vnu_pipe_load_finish[i] == 1'b1)
					vnu_pipe_load_cnt[i] <= 0;
			end
			else 
				vnu_pipe_load_cnt[i] <= 0;
		end
	end
endgenerate
// Init DNT
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) 
		dnu_init_load_cnt <= 0;
	else if(dnu_init_load_start == 1'b1) begin
		if(dnu_init_load_cnt == 0) 
			dnu_init_load_cnt <= 1;
		else if(dnu_init_load_cnt <= LOAD_HANDSHAKE_LATENCY) 
			dnu_init_load_cnt <= dnu_init_load_cnt + 1;
		else if(dnu_init_load_finish == 1'b1)
			dnu_init_load_cnt <= 0;
	end
	else 
		dnu_init_load_cnt <= 0;
end
// Pipe Load CNT
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) 
		dnu_pipe_load_cnt <= 0;
	else if(dnu_pipe_load_start == 1'b1) begin
		if(dnu_pipe_load_cnt == 0) 
			dnu_pipe_load_cnt <= 1;
		else if(dnu_pipe_load_cnt <= LOAD_HANDSHAKE_LATENCY) 
			dnu_pipe_load_cnt <= dnu_pipe_load_cnt + 1;
		else if(dnu_pipe_load_finish == 1'b1)
			dnu_pipe_load_cnt <= 0;
	end
	else 
		dnu_pipe_load_cnt <= 0;
end
/*---------------------------------------------------------------------------------------------------*/
// FSM
//////////////////////////////////////////////////////////////////////////////////////////////////////
initial state <= INIT_LOAD;
always @(posedge read_clk) begin
	if (fsm_en == 1'b0) 
        state <= INIT_LOAD;
	else if(termination == 1'b1)
		state <= INIT_LOAD;
	else
      case (state[$clog2(FSM_STATE_NUM)-1:0])
//////////////////////////////////////////////////////////////////////////////////////////////////////
        INIT_LOAD : begin
			state <= MEM_FETCH;
		end 
//////////////////////////////////////////////////////////////////////////////////////////////////////
		MEM_FETCH : begin
			if(fetch_pipeline_level[MEM_RD_LEVEL-1] == 1'b1)
				if(
				  (vnu_pipe_load_finish[0] == 1'b1 || vnu_pipe_load_start[0] == 1'b0) &&
				  (vnu_init_load_start == {`IB_VNU_DECOMP_funNum{1'b0}} || vnu_init_load_finish == {`IB_VNU_DECOMP_funNum{1'b1}})
				) 
					state <= VNU_PIPE;
				else
                	state <= VNU_IB_RAM_PEND; // VNU IB-RAM pending
            else
				state <= MEM_FETCH;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Halting the following process unitl VNU IB-RAMs are completely updated.
		VNU_IB_RAM_PEND : begin
			if(
			  (vnu_pipe_load_finish[0] == 1'b1 || vnu_pipe_load_start[0] == 1'b0) &&
			  (vnu_init_load_start == {`IB_VNU_DECOMP_funNum{1'b0}} || vnu_init_load_finish == {`IB_VNU_DECOMP_funNum{1'b1}})
			)
				state <= VNU_PIPE;
			else
				state <= VNU_IB_RAM_PEND;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
		VNU_PIPE : begin
			if(vnu_pipeline_level[VNU_PIPELINE_LEVEL-2] == 1'b1)
                state <= VNU_OUT;
            else
				state <= VNU_PIPE;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
        VNU_OUT: begin
            state <= BS_WB;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
        BS_WB: begin
            if(bs_pipeline_level[PERMUTATION_LEVEL-1:0] == bs_shift_overflow)
                state <= PAGE_ALIGN;
            else
                state <= BS_WB;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
        PAGE_ALIGN: begin
        	state <= MEM_WB;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
        MEM_WB: begin
        	state <= IDLE;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
        IDLE: begin
            if(layer_finish == 1'b1)
                state <= MEM_FETCH;
            else
                state <= IDLE;
        end  
//////////////////////////////////////////////////////////////////////////////////////////////////////
		default: begin
			state <= INIT_LOAD;
		end
    endcase
end	
/*---------------------------------------------------------------------------------------------------*/
generate 
	for(j=0;j<`IB_VNU_DECOMP_funNum;j=j+1) begin : vn_load_en_inst
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) 
				vnu_init_load_start[j] <= 0;
			else if(state == INIT_LOAD)
				vnu_init_load_start[j] <= 1'b1;
			else 
				vnu_init_load_start[j] <= vnu_init_load_start[j]^vnu_init_load_finish[j];					
		end
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0)
				vnu_init_load_finish[j] <= 1'b0;
			else if({vnu_init_load_start[j], vnu_init_load_finish[j]} == 2'b11) // to make init_load_finish only assert for one clock cycle
				vnu_init_load_finish[j] <= 1'b0;
			else if(vnu_init_load_cnt[j] > LOAD_HANDSHAKE_LATENCY)
				vnu_init_load_finish[j] <= ~vnu_init_load_busy[j];
			else 
				vnu_init_load_finish[j] <= 1'b0;
		end	
		
		// Enable signal control of "Initial-Load" operation
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) vnu_init_load_en[j] <= 1'b0;
			else if(vnu_init_load_cnt[j] > LOAD_HANDSHAKE_LATENCY) vnu_init_load_en[j] <= vnu_init_load_busy[j];
			else if(vnu_init_load_start[j] && ~vnu_init_load_finish[j]) vnu_init_load_en[j] <= 1'b1;
			else vnu_init_load_en[j] <= 1'b0;
		end	
		
		// Enable signal controls of "Pipe-Load" operation
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) vnu_pipe_load_en[j] <= 1'b0;
			else if(vnu_pipe_load_start[j] && ~vnu_pipe_load_finish[j]) begin
				if(vnu_pipe_load_cnt[j] > LOAD_HANDSHAKE_LATENCY) vnu_pipe_load_en[j] <= vnu_pipe_load_busy[j];
				else vnu_pipe_load_en[j] <= 1'b1;
			end
			else vnu_pipe_load_en[j] <= 1'b0;
		end
		
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) vnu_pipe_load_start[j] <= 1'b0;
			else if(
				(state == VNU_PIPE || state == VNU_OUT) && 
				vnu_pipeline_level > ((2**(VNU_FUNC_CYCLE*(j+1))) >> (VNU_FUNC_MEM_END)) &&
				last_layer == 1'b1
			) vnu_pipe_load_start[j] <= 1'b1;
			else vnu_pipe_load_start[j] <= vnu_pipe_load_start[j]^vnu_pipe_load_finish[j];
		end
		
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) vnu_pipe_load_finish[j] <= 1'b0;
			else if({vnu_pipe_load_start[j], vnu_pipe_load_finish[j]} == 2'b11) vnu_pipe_load_finish[j] <= 1'b0; // to make pipe_load_finish only assert for one clock cycle
			else if(vnu_pipe_load_cnt[j] > LOAD_HANDSHAKE_LATENCY) vnu_pipe_load_finish[j] <= ~vnu_pipe_load_busy[j];
			else vnu_pipe_load_finish[j] <= 1'b0;
		end
	end
endgenerate
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) 
		dnu_init_load_start <= 0;
	else if(state == INIT_LOAD)
		dnu_init_load_start <= 1'b1;
	else 
		dnu_init_load_start <= dnu_init_load_start^dnu_init_load_finish;					
end
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0)
		dnu_init_load_finish <= 1'b0;
	else if({dnu_init_load_start, dnu_init_load_finish} == 2'b11) // to make init_load_finish only assert for one clock cycle
		dnu_init_load_finish <= 1'b0;
	else if(dnu_init_load_cnt > LOAD_HANDSHAKE_LATENCY)
		dnu_init_load_finish <= ~dnu_init_load_busy; // Reduction NOR
	else 
		dnu_init_load_finish <= 1'b0;
end
// Enable signal control of "Initial-Load" operation
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) dnu_init_load_en <= 1'b0;
	else if(dnu_init_load_cnt > LOAD_HANDSHAKE_LATENCY) dnu_init_load_en <= dnu_init_load_busy;
	else if(dnu_init_load_start && ~dnu_init_load_finish) dnu_init_load_en <= 1'b1;
	else dnu_init_load_en <= 1'b0;
end

// Enable signal controls of "Pipe-Load" operation
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) dnu_pipe_load_en <= 1'b0;
	else if(dnu_pipe_load_start && ~dnu_pipe_load_finish) begin
		if(dnu_pipe_load_cnt > LOAD_HANDSHAKE_LATENCY) dnu_pipe_load_en <= dnu_pipe_load_busy;
		else dnu_pipe_load_en <= 1'b1;
	end
	else dnu_pipe_load_en <= 1'b0;
end

always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0)
		dnu_pipe_load_start <= 1'b0;
	else if(
			state > VNU_OUT && 
			dnu_pipeline_level >= ((2**(DNU_FUNC_CYCLE)) >> (DNU_FUNC_MEM_END)) &&
			last_layer == 1'b1
	)
		dnu_pipe_load_start <= 1'b1;
	else 
		dnu_pipe_load_start <= dnu_pipe_load_start^dnu_pipe_load_finish;
end

always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) dnu_pipe_load_finish <= 1'b0;
	else if({dnu_pipe_load_start, dnu_pipe_load_finish} == 2'b11) dnu_pipe_load_finish <= 1'b0; // to make pipe_load_finish only assert for one clock cycle
	else if(dnu_pipe_load_cnt > LOAD_HANDSHAKE_LATENCY) dnu_pipe_load_finish <= ~dnu_pipe_load_busy;
	else dnu_pipe_load_finish <= 1'b0;
end							  
//////////////////////////////////////////////////////////////////////////////////////////////////////		
generate
	// VNU RD
	for(j=0;j<`IB_VNU_DECOMP_funNum;j=j+1) begin : vn_rd_inst
		assign vnu_rd[j] = |vnu_pipeline_level[VNU_FUNC_CYCLE*(j+1)-1:VNU_FUNC_CYCLE*j];//(state == VNU_PIPE || VNU_OUT) ? 1'b1 : 1'b0;
	end
endgenerate
/*-------------------------------------------------------------------------------------------------------------------*/
// DNU RD
assign dnu_rd = (state == BS_WB || state == PAGE_ALIGN) ? 1'b1 : 1'b0; // DNUs are enabled since BS_WB till PAGE_ALIGN
/*-------------------------------------------------------------------------------------------------------------------*/
assign v2c_src = (state == MEM_FETCH && fetch_pipeline_level == fetch_shift_overflow) ? 1'b1 : 1'b0;
assign v2c_mem_we = (state == MEM_WB) ? ~v2c_msg_busy : 1'b0; 
assign 	vnu_update_pend = ( (state == MEM_FETCH || state == VNU_IB_RAM_PEND) &&
							(vnu_pipe_load_finish[0] == 1'b1 || vnu_pipe_load_start[0] == 1'b0) &&
			  			    (vnu_init_load_start == {`IB_VNU_DECOMP_funNum{1'b0}} || vnu_init_load_finish == {`IB_VNU_DECOMP_funNum{1'b1}})
						  ) ? 1'b0 : 
						  ( (state == MEM_FETCH || state == VNU_IB_RAM_PEND) &&
							!((vnu_pipe_load_finish[0] == 1'b1 || vnu_pipe_load_start[0] == 1'b0) && (vnu_init_load_start == {`IB_VNU_DECOMP_funNum{1'b0}} || vnu_init_load_finish == {`IB_VNU_DECOMP_funNum{1'b1}}))
						  ) ? 1'b1 : 1'b0;
/*-------------------------------------------------------------------------------------------------------------------*/
// State Signal - hard decision is going to be done one clock cycle later
initial hard_decision_done <= 1'b0;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0)
		hard_decision_done <= 1'b0;
	else if(
			state > VNU_OUT && 
			dnu_pipeline_level == ((2**(DNU_FUNC_CYCLE)) >> (DNU_FUNC_MEM_END)) &&
			last_layer == 1'b1
	)
		hard_decision_done <= 1'b1;
	else
		hard_decision_done <= 1'b0;
end
/*-------------------------------------------------------------------------------------------------------------------*/
endmodule