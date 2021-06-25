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

module cnu_control_unit #(
	parameter QUAN_SIZE = 4,
	parameter LAYER_NUM = 3,
	parameter RESET_CYCLE = 100, // once rstn is deasserted, the system goes into reset mode for 100 clock cycles	
	parameter CNU_FUNC_CYCLE = 4, // the latency of one CNU (min approximation)
	parameter CNU_PIPELINE_LEVEL = 1*CNU_FUNC_CYCLE, // the last pipeline register is actually shared with P2P_C
    parameter PERMUTATION_LEVEL = 2, // every circular shifter takes 2 clock cycles
    parameter PAGE_ALIGN_LEVEL  = 1,
	parameter MEM_RD_LEVEL      = 2, // every memory fetching process take 2 clock cycles
	parameter FSM_STATE_NUM     = 9,
	parameter [$clog2(FSM_STATE_NUM)-1:0] INIT_LOAD        = 0,
	parameter [$clog2(FSM_STATE_NUM)-1:0] VNU_IB_RAM_PEND  = 1,
	parameter [$clog2(FSM_STATE_NUM)-1:0] MEM_FETCH        = 2,
	parameter [$clog2(FSM_STATE_NUM)-1:0] CNU_PIPE         = 3,
	parameter [$clog2(FSM_STATE_NUM)-1:0] CNU_OUT          = 4,
	parameter [$clog2(FSM_STATE_NUM)-1:0] BS_WB 		   = 5,
	parameter [$clog2(FSM_STATE_NUM)-1:0] PAGE_ALIGN 	   = 6,
	parameter [$clog2(FSM_STATE_NUM)-1:0] MEM_WB 		   = 7,
	parameter [$clog2(FSM_STATE_NUM)-1:0] IDLE 			   = 8
)(
    output wire cnu_rd,
    output wire c2v_mem_we,
    output wire c2v_pa_en,
    output wire c2v_bs_en,
    output wire v2c_mem_fetch,
    //output wire v2c_src,
    output wire last_layer,

    output reg de_frame_start, // to inform system that decoding process of current frame has already started. The given "termination" signal will be thereby deasserted by system 
 	output reg [$clog2(FSM_STATE_NUM)-1:0] state,

 	input wire vnu_update_pend,
    input wire layer_finish,
	input wire termination, // finish deocding process of the current frame
	input wire fsm_en,
	input wire read_clk,
	input wire rstn
);

//------------------------------------------------------------------------------------
// Gloable Parameters

//------------------------------------------------------------------------------------
// The initial process to enter the Initial Load State
localparam RESET_CYCLE_BITWIDTH = $clog2(RESET_CYCLE);
reg [RESET_CYCLE_BITWIDTH-1:0] reset_cnt;
initial reset_cnt <= 0;
always @(posedge read_clk) begin
	if(rstn == 1'b0) reset_cnt <= 0;
	else reset_cnt <= reset_cnt + 1'b1;
end

reg decode_start;
initial decode_start <= 1'b0;
always @(posedge read_clk) begin
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
// since the FSM is driven by clock, the one more additional decrement is necessary; otherwise the overflow will be actually detected from one more clock cycle later
localparam bs_shift_overflow = 2**(PERMUTATION_LEVEL-1);
localparam cnu_shift_overflow = 2**(CNU_PIPELINE_LEVEL-1-1);
localparam fetch_shift_overflow = 2**(MEM_RD_LEVEL-1); 
reg [MEM_RD_LEVEL-1:0] fetch_pipeline_level;
reg [CNU_PIPELINE_LEVEL-1:0] cnu_pipeline_level;
reg [PERMUTATION_LEVEL-1:0] bs_pipeline_level;
`ifdef SCHED_4_6 // only one clock cycle delay of page alignment when schedule 4.6 is configured
	reg page_align_pipeline_level;
`endif
reg c2v_msg_busy; // Assertion whenever the message passing is done
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

initial c2v_msg_busy <= 1'b0;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) c2v_msg_busy <= 1'b0;
`ifdef SCHED_4_6
	else c2v_msg_busy <= ~page_align_pipeline_level;
`else
	else c2v_msg_busy <= ~page_align_pipeline_level[PAGE_ALIGN_LEVEL-1];
`endif
end

initial cnu_pipeline_level <= 0;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) 
		cnu_pipeline_level <= 1;
    else if(state == CNU_PIPE) begin
		cnu_pipeline_level[CNU_PIPELINE_LEVEL-1:0] <= {cnu_pipeline_level[CNU_PIPELINE_LEVEL-2:0], cnu_pipeline_level[CNU_PIPELINE_LEVEL-1]};
	end
    else //if(state == CNU_OUT) 
		cnu_pipeline_level[CNU_PIPELINE_LEVEL-1:0] <= 1;
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
			state <= VNU_IB_RAM_PEND;
		end
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Halting the following process unitl VNU IB-RAMs are completely updated.
		VNU_IB_RAM_PEND : begin
			if(vnu_update_pend == 1'b0)
				state <= MEM_FETCH;
			else
				state <= VNU_IB_RAM_PEND;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
		MEM_FETCH : begin
			if(fetch_pipeline_level[MEM_RD_LEVEL-1] == 1'b1) 
				state <= CNU_PIPE;
            else
				state <= MEM_FETCH;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
		CNU_PIPE : begin
			if(cnu_pipeline_level[CNU_PIPELINE_LEVEL-2] == 1'b1)
                state <= CNU_OUT;
            else
				state <= CNU_PIPE;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
        CNU_OUT: begin
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
            if(layer_finish == 1'b1) begin
            	if(vnu_update_pend == 1'b0)
            		state <= MEM_FETCH;
            	else
            		state <= VNU_IB_RAM_PEND;
            end
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
initial de_frame_start <= 1'b0;
always @(posedge read_clk) begin 
	if(state[$clog2(FSM_STATE_NUM)-1:0] == INIT_LOAD) 
		de_frame_start <= 1'b1;
	else if(state[$clog2(FSM_STATE_NUM)-1:0] == CNU_PIPE && termination == 1'b1) 
		de_frame_start <= 1'b0;
	else 
		de_frame_start <= de_frame_start;
end					  
//////////////////////////////////////////////////////////////////////////////////////////////////////		
//assign v2c_src = (state == MEM_FETCH && fetch_pipeline_level == fetch_shift_overflow) ? 1'b1 : 1'b0;
assign c2v_mem_we = (state == MEM_WB) ? 1'b1 : 1'b0; 
assign c2v_pa_en = (state == PAGE_ALIGN) ? 1'b1 : 1'b0;
assign c2v_bs_en = (state == BS_WB && bs_pipeline_level[0] == 1'b1) ? 1'b1 : 1'b0; // only enable at first pipeline stage over all BS_WB
// CNU RD
assign cnu_rd = (state == CNU_PIPE || state == CNU_OUT) ? 1'b1 : 1'b0;
assign v2c_mem_fetch = (state == MEM_FETCH && fetch_pipeline_level[0] == 1'b1) ? 1'b1 : 1'b0;
endmodule