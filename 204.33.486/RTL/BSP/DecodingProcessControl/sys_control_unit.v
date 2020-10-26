`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2020 04:18:16 PM
// Design Name: 
// Module Name: cnu6ib_control_unit
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

module sys_control_unit #(
	parameter RESET_CYCLE = 100, // once rstn is deasserted, the system goes into reset mode for 100 clock cycles
	
	parameter CN_LOAD_CYCLE = 32, // 64-entry with two interleaving banks requires 32 clock cycle to finish iteration update
	parameter VN_LOAD_CYCLE = 64, // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
	parameter DN_LOAD_CYCLE = 64, // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
	
	parameter CNU_PIPELINE_LEVEL = 5-1, // the last pipeline register is actually shared with P2P_C
	parameter VNU_PIPELINE_LEVEL = 3-1, // the last pipeline register is actually shared with P2P_V
	parameter INIT_INTER_FRAME_EN = 0,
      
	parameter [3:0] CONFIG        = 4'b0000,
	parameter [3:0] LLR_FETCH     = 4'b0001,  
	parameter [3:0] LLR_FETCH_OUT = 4'b0010,
	parameter [3:0] CNU_PIPE      = 4'b0011,
	parameter [3:0] CNU_OUT       = 4'b0100,
	parameter [3:0] P2P_C         = 4'b0101,
	parameter [3:0] P2P_C_OUT     = 4'b0110,
	parameter [3:0] VNU_PIPE      = 4'b0111,
	parameter [3:0] VNU_OUT       = 4'b1000,
	parameter [3:0] P2P_V         = 4'b1001,
	parameter [3:0] P2P_V_OUT     = 4'b1010
)(
	// output port for IB-ROM update
	output reg [`IB_CNU_DECOMP_funNum-1:0] cnu_wr,
	output reg [`IB_VNU_DECOMP_funNum-1:0] vnu_wr,
	output reg dnu_wr,

    output wire llr_fetch,
    output wire v2c_src,
    output wire v2c_msg_en,
    output wire cnu_rd,
    output wire c2v_msg_en,
    output wire vnu_rd,
    output wire c2v_load, // load enable signal to parallel-to-serial converter
    output wire v2c_load, // load enable signal to parallel-to-serial converter
    output reg inter_frame_en, // to enable the next frame's decoding process
    output reg de_frame_start, // to inform system that decoding process of current frame has already started. The given "termination" signal will be thereby deasserted by system 
    output reg [`IB_CNU_DECOMP_funNum-1:0] cn_ram_we, // enable the pipelining of IB-CNU RAMs Iteration Update
    output reg [`IB_VNU_DECOMP_funNum-1:0] vn_ram_we, // enable the pipelining of IB-VNU RAMs Iteration Update
    output reg [3:0] state,
   
	// Input port acknowledging from Write/Update FSMs
	input wire [`IB_CNU_DECOMP_funNum-1:0] cn_iter_update,
	input wire [1:0] cn_f0_wr_busy,
	input wire [1:0] cn_f1_wr_busy,
	input wire [1:0] cn_f2_wr_busy,
	input wire [1:0] cn_f3_wr_busy,
	input wire [`IB_VNU_DECOMP_funNum-1:0] vn_iter_update,
	input wire [1:0] vn_f0_wr_busy,
	input wire [1:0] vn_f1_wr_busy,
	input wire dn_iter_update,
	input wire [1:0] dn_f2_wr_busy,
   
	input wire termination, // finish deocding process of the current frame
	input wire inter_frame_align, // the notification of termination staus from the other frame's decoding process 
	input wire fsm_en,
	input wire update_finish,
	input wire read_clk,
	input wire cn_write_clk,
	input wire vn_write_clk,
	input wire dn_write_clk
	input wire rstn
);

//------------------------------------------------------------------------------------
The initial process to enter the Initial Load State
localparam RESET_CYCLE_BITWIDTH = $clog2(RESET_CYCLE);
reg [RESET_CYCLE_BITWIDTH-1:0] rest_cnt;
initial rest_cnt <= 0;
always @(posedge sys_clk, negedge rstn) begin
	if(rstn == 1'b0) rest_cnt <= 0;
	else reset_cnt <= reset_cnt + 1'b1;
end

reg decode_start;
initial decode_start <= 1'b0;
always @(posedge sys_clk, negedge rstn) begin
	if(rstn == 1'b0) decode_start <= 1'b0;
	else if(reset_cnt[RESET_CYCLE_BITWIDTH-1:0] == RESET_CYCLE) decode_start <= 1'b1;
	else decode_start <= decode_start;
end
//------------------------------------------------------------------------------------
// IB-ROMs data fetching process 

// To keep track the status CN_WR_FSMs by their Acknowledgements
localparam [2:0] ROM_IDLE  = 3'b000;
localparam [2:0] ROM_FETCH = 3'b101;
localparam [2:0] ROM_UPDATE_FINISH = 3'b010;
localparam ITER_UPDATE_STATUS = 2; // 2nd bit accounts for the status of iter_update
localparam ITER_UPDATE BUSY = 1:0 // [1:0] bits account for the busy status of IB-ROM updatin process
// CNU IB-ROMs
wire [2:0] cn_wr_fsm_decode [0:`IB_CNU_DECOMP_funNum-1];
wire cn_slave_wr_rdy [0:`IB_CNU_DECOMP_funNum-1];
wire cn_master_wr_valid [0:`IB_CNU_DECOMP_funNum-1]; 
assign cn_wr_fsm_decode[0] = {cn_iter_update[0], cn_f0_wr_busy[1:0]};
assign cn_wr_fsm_decode[1] = {cn_iter_update[1], cn_f1_wr_busy[1:0]};
assign cn_wr_fsm_decode[2] = {cn_iter_update[2], cn_f2_wr_busy[1:0]};
assign cn_wr_fsm_decode[3] = {cn_iter_update[3], cn_f3_wr_busy[1:0]};
// VNU IB-ROMs
wire [2:0] vn_wr_fsm_decode [0:`IB_VNU_DECOMP_funNum-1]; 
wire vn_slave_wr_rdy [0:`IB_VNU_DECOMP_funNum-1];
wire vn_master_wr_valid [0:`IB_VNU_DECOMP_funNum-1];
assign vn_wr_fsm_decode[0] = {vn_iter_update[0], vn_f0_wr_busy[1:0]};
assign vn_wr_fsm_decode[1] = {vn_iter_update[1], vn_f1_wr_busy[1:0]};
// DNU IB-ROMs
wire [2:0] dn_wr_fsm_decode; 
wire dn_slave_wr_rdy;
wire dn_master_wr_valid;
assign dn_wr_fsm_decode = {dn_iter_update, dn_f2_wr_busy[1:0]};

generate
genvar i, j;
	for(i=0;i<`IB_CNU_DECOMP_funNum;i=i+1) begin : cn_slave_wr_handshake_inst
		assign cn_slave_wr_rdy[i] = (cn_wr_fsm_decode[i][ITER_UPDATE_STATUS] == ROM_IDLE[ITER_UPDATE_STATUS]) ? = 1'b1 : 1'b0;
		assign cn_master_wr_valid[i] = (cn_wr_fsm_decode[i][ITER_UPDATE] == )
	end
	
	for(j=0;j<`IB_VNU_DECOMP_funNum;j=j+1) begin : cn_slave_wr_handshake_inst
		end
	end
endgenerate
always @(posedge sys_clk, negedge rstn) begin
	if(rstn == 1'b0) dn_load_cycle <= 0;
	else if(dn_wr_fsm_decode == ROM_FETCH) dn_load_cycle <= dn_load_cycle + 1'b1;
	else if(dn_wr_fsm_decode[0] == 1'b0) dn_load_cycle <= 0; // simplify both ROM_IDLE and ROM_UPDATE_FINISH status by K-Map
	else if(dn_load_cycle == DN_LOAD_CYCLE) dn_load_cycle <= 0;
	else dn_load_cycle <= dn_load_cycle;
end


//localparam CN_LOAD_CYCLE_BITWIDTH = $clog2(CN_LOAD_CYCLE);
//localparam VN_LOAD_CYCLE_BITWIDTH = $clog2(VN_LOAD_CYCLE);
//localparam DN_LOAD_CYCLE_BITWIDTH = $clog2(DN_LOAD_CYCLE);
//reg [CN_LOAD_CYCLE_BITWIDTH-1:0] cn_load_cycle [0:`IB_CNU_DECOMP_funNum-1]; 
//reg [VN_LOAD_CYCLE_BITWIDTH-1:0] vn_load_cycle [0:`IB_VNU_DECOMP_funNum-1];
//reg [DN_LOAD_CYCLE_BITWIDTH-1:0] dn_load_cycle;

generate
genvar i, j;
	for(i=0;i<`IB_CNU_DECOMP_funNum;i=i+1) begin : cn_load_cycle_inst
		always @(posedge sys_clk, negedge rstn) begin
			if(rstn == 1'b0) cn_load_cycle[i] <= 0;
			else if(cn_wr_fsm_decode[i] == ROM_FETCH) cn_load_cycle[i] <= cn_load_cycle[i] + 1'b1;
			else if(cn_wr_fsm_decode[i][0] == 1'b0) cn_load_cycle[i] <= 0; // simplify both ROM_IDLE and ROM_UPDATE_FINISH status by K-Map
			else if(cn_load_cycle[i] == CN_LOAD_CYCLE) cn_load_cycle[i] <= 0;
			else cn_load_cycle[i] <= cn_load_cycle[i];
		end
	end
	
	for(j=0;j<`IB_VNU_DECOMP_funNum;j=j+1) begin : vn_load_cycle_inst
		always @(posedge sys_clk, negedge rstn) begin
			if(rstn == 1'b0) vn_load_cycle[j] <= 0;
			else if(vn_wr_fsm_decode[j] == ROM_FETCH) vn_load_cycle[j] <= vn_load_cycle[j] + 1'b1;
			else if(vn_wr_fsm_decode[j][0] == 1'b0) vn_load_cycle[j] <= 0; // simplify both ROM_IDLE and ROM_UPDATE_FINISH status by K-Map
			else if(vn_load_cycle[j] == VN_LOAD_CYCLE) vn_load_cycle[j] <= 0;
			else vn_load_cycle[j] <= vn_load_cycle[j];
		end
	end
endgenerate
always @(posedge sys_clk, negedge rstn) begin
	if(rstn == 1'b0) dn_load_cycle <= 0;
	else if(dn_wr_fsm_decode == ROM_FETCH) dn_load_cycle <= dn_load_cycle + 1'b1;
	else if(dn_wr_fsm_decode[0] == 1'b0) dn_load_cycle <= 0; // simplify both ROM_IDLE and ROM_UPDATE_FINISH status by K-Map
	else if(dn_load_cycle == DN_LOAD_CYCLE) dn_load_cycle <= 0;
	else dn_load_cycle <= dn_load_cycle;
end
//------------------------------------------------------------------------------------
//  IB-ROM Update Strategies



//------------------------------------------------------------------------------------
// since the FSM is driven by clock, the one more additional decrement is necessary; otherwise the overflow will be actually detected from one more clock cycle later
localparam interFrame_enStart = 2**(`QUAN_SIZE-1); // to make inter_frame_en be asserted at (Q-1)th bit transfer of priori LLR and 
						   // the CONFIG state can thereby start at LLR_FETCH_OUT state of first frame's decoding process 
localparam interFrame_enStart_v = 2**(VNU_PIPELINE_LEVEL-1-1);
localparam msg_overflow = 2**(`QUAN_SIZE-1);
localparam cnu_shift_overflow = 2**(CNU_PIPELINE_LEVEL-1-1); 
localparam vnu_shift_overflow = 2**(VNU_PIPELINE_LEVEL-1-1);
reg [CNU_PIPELINE_LEVEL-1:0] cnu_pipeline_level;
reg [VNU_PIPELINE_LEVEL-1:0] vnu_pipeline_level;
reg [`QUAN_SIZE:0] v2c_msg_psp;
reg [`QUAN_SIZE:0] c2v_msg_psp;

initial v2c_msg_psp[`QUAN_SIZE:0] <= 1;
always @(posedge sys_clk) begin
    if(state == CONFIG) v2c_msg_psp[`QUAN_SIZE:0] <= 1;
    else if(state == VNU_OUT) v2c_msg_psp[`QUAN_SIZE:0] <= 1;
    else if(state == LLR_FETCH) v2c_msg_psp[`QUAN_SIZE:0] <= {v2c_msg_psp[`QUAN_SIZE-1:0], 1'b0};
    else if(state == P2P_V) v2c_msg_psp[`QUAN_SIZE:0] <= {v2c_msg_psp[`QUAN_SIZE-1:0], 1'b0};
end
initial c2v_msg_psp[`QUAN_SIZE:0] <= 0;
always @(posedge sys_clk) begin
    if(state == CNU_OUT) c2v_msg_psp[`QUAN_SIZE:0] <= 1;
    else if(state == P2P_C) c2v_msg_psp[`QUAN_SIZE:0] <= {c2v_msg_psp[`QUAN_SIZE-1:0], 1'b0};
end

always @(posedge sys_clk) begin
    if(state == LLR_FETCH_OUT) cnu_pipeline_level[CNU_PIPELINE_LEVEL-1:0] <= 1;
    else if(state == CNU_PIPE) cnu_pipeline_level[CNU_PIPELINE_LEVEL-1:0] <= {cnu_pipeline_level[CNU_PIPELINE_LEVEL-2:0], 1'b0};
    else if(state == CNU_OUT) cnu_pipeline_level[CNU_PIPELINE_LEVEL-1:0] <= 1;
end

always @(posedge sys_clk) begin
    if(state == P2P_C_OUT) vnu_pipeline_level[VNU_PIPELINE_LEVEL-1:0] <= 1;
    else if(state == VNU_PIPE) vnu_pipeline_level[VNU_PIPELINE_LEVEL-1:0] <= {vnu_pipeline_level[VNU_PIPELINE_LEVEL-2:0], 1'b0};
    else if(state == VNU_OUT) vnu_pipeline_level[VNU_PIPELINE_LEVEL-1:0] <= 1;
end

initial state <= CONFIG;
always @(posedge sys_clk) begin
   if (!fsm_en) 
        state <= CONFIG;
   else
      case (state[3:0])
        CONFIG : begin
	    //if(inter_frame_en == 1'b1) state <= LLR_FETCH;
	    //else state <= CONFIG; // keep idling until inter_frame_en is asserted
	    state <= LLR_FETCH;
        end
    
        LLR_FETCH : begin
            if(v2c_msg_psp == msg_overflow)
                state <= LLR_FETCH_OUT;
            else
                state <= LLR_FETCH;
         end
        
        LLR_FETCH_OUT : begin
            state <= CNU_PIPE;
        end

        CNU_PIPE : begin
	   if(termination == 1'b1)
		state <= CONFIG;
           else if(cnu_pipeline_level == cnu_shift_overflow)
                state <= CNU_OUT;
            else
                state <= CNU_PIPE;
        end

        CNU_OUT: begin
            state <= P2P_C;
        end

        P2P_C: begin
            if(c2v_msg_psp == msg_overflow)
                state <= P2P_C_OUT;
            else
                state <= P2P_C;
        end

        P2P_C_OUT: begin
            state <= VNU_PIPE;
        end

        VNU_PIPE: begin
            if(vnu_pipeline_level == vnu_shift_overflow)
                state <= VNU_OUT;
            else
                state <= VNU_PIPE;
        end

        VNU_OUT: begin
            state <= P2P_V;
        end

        P2P_V: begin
            if(v2c_msg_psp == msg_overflow)
                state <= P2P_V_OUT;
            else
                state <= P2P_V;
        end

        P2P_V_OUT: begin
            state <= CNU_PIPE;
        end       
      endcase	
end	

initial inter_frame_en <= INIT_INTER_FRAME_EN;
always @(posedge sys_clk) begin
	if (!fsm_en) inter_frame_en <= INIT_INTER_FRAME_EN;
 	else if(state[3:0] == LLR_FETCH && v2c_msg_psp == interFrame_enStart) inter_frame_en <= 1'b1; // for the first iteration only
	else if(state[3:0] == P2P_V && v2c_msg_psp == interFrame_enStart) inter_frame_en <= 1'b1; // for the iteration > 0, and it is for second frame
	else if(state[3:0] == VNU_PIPE && vnu_pipeline_level == interFrame_enStart_v) inter_frame_en <= 1'b1; // for the iteration > 0, and it is for first frame
	else if(inter_frame_align == 1'b1) inter_frame_en <= 1'b0;
end

initial de_frame_start <= 1'b0;
always @(posedge sys_clk) begin
	//if(state[3:0] == LLR_FETCH) 
	if(state[3:0] == CONFIG) 
		de_frame_start <= 1'b1;
	else if(state[3:0] == CNU_PIPE && termination == 1'b1) 
		de_frame_start <= 1'b0;
	else 
		de_frame_start <= de_frame_start;
end

initial cn_ram_we[`IB_CNU_DECOMP_funNum-1:0] <= `IB_CNU_DECOMP_funNum'd0;
always @(posedge sys_clk) begin
    if (!fsm_en) 
        cn_ram_we[0] <= 1'b0;
    else if(state[3:0] == CNU_PIPE && cnu_pipeline_level[CNU_PIPELINE_LEVEL-1:0] == 1)
        cn_ram_we[0] <= 1'b1;
    else if(state[3:0] == P2P_V_OUT)
        cn_ram_we[0] <= 1'b0;
end
initial vn_ram_we[`IB_VNU_DECOMP_funNum-1:0] <= `IB_VNU_DECOMP_funNum'd0;
always @(posedge sys_clk) begin
    if (!fsm_en) 
        vn_ram_we[0] <= 1'b0;
    else if(state[3:0] == VNU_PIPE && vnu_pipeline_level[VNU_PIPELINE_LEVEL-1:0] == 1)
        vn_ram_we[0] <= 1'b1;
    else if(state[3:0] == P2P_C_OUT)
        vn_ram_we[0] <= 1'b0;
end
genvar i;
generate
    // for check nodes
    for(i=1;i<`IB_CNU_DECOMP_funNum;i=i+1) begin : gen_cn_ram_we
        always @(posedge sys_clk) begin
	    if(!fsm_en) cn_ram_we[i] <= 1'b0;
            else cn_ram_we[i] <= cn_ram_we[i-1];
        end
    end
    // for variable nodes
    for(i=1;i<`IB_VNU_DECOMP_funNum;i=i+1) begin : gen_vn_ram_we
        always @(posedge sys_clk) begin
	    if(!fsm_en) vn_ram_we[i] <= 1'b0;
            else vn_ram_we[i] <= vn_ram_we[i-1];
        end
    end
endgenerate

assign llr_fetch = (state == CONFIG || state == LLR_FETCH) ? 1'b1 : 1'b0;
assign v2c_src = (state == CONFIG || state == LLR_FETCH) ? 1'b1 : 1'b0; 
assign v2c_msg_en = (state == CONFIG || state == LLR_FETCH) ? 1'b1 : 
                    (state == VNU_OUT || state == P2P_V) ? 1'b1 : 1'b0;
assign cnu_rd = (state == LLR_FETCH_OUT || state == CNU_PIPE) ? 1'b1 : 
                (state == P2P_V_OUT) ? 1'b1 : 1'b0;
assign c2v_msg_en = (state == CNU_OUT || state == P2P_C) ? 1'b1 : 1'b0;
assign vnu_rd = (state == P2P_C_OUT || state == VNU_PIPE) ? 1'b1 : 1'b0;

assign v2c_load = v2c_msg_psp[0];
assign c2v_load = c2v_msg_psp[0];   
endmodule
