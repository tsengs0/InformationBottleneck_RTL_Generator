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

module sys_control_unit #(
	parameter RESET_CYCLE = 100, // once rstn is deasserted, the system goes into reset mode for 100 clock cycles
	
	parameter CN_LOAD_CYCLE = 32, // 64-entry with two interleaving banks requires 32 clock cycle to finish iteration update
	parameter VN_LOAD_CYCLE = 64, // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
	parameter DN_LOAD_CYCLE = 64, // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update
	
	parameter CNU_PIPELINE_LEVEL = 5-1, // the last pipeline register is actually shared with P2P_C
	parameter VNU_PIPELINE_LEVEL = 3-1, // the last pipeline register is actually shared with P2P_V
	parameter INIT_INTER_FRAME_EN = 0,
      
	parameter [3:0] INIT_LOAD     = 4'b0000,
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
	output wire [`IB_CNU_DECOMP_funNum-1:0] cnu_wr,
	output wire [`IB_VNU_DECOMP_funNum-1:0] vnu_wr,
	output wire dnu_wr,

    output wire llr_fetch,
    output wire v2c_src,
    output wire v2c_msg_en,
    output wire [`IB_CNU_DECOMP_funNum-1:0] cnu_rd,
    output wire c2v_msg_en,
    output wire [`IB_VNU_DECOMP_funNum-1:0] vnu_rd,
	output wire dnu_rd,
    output wire c2v_load, // load enable signal to parallel-to-serial converter
    output wire v2c_load, // load enable signal to parallel-to-serial converter
    output reg inter_frame_en, // to enable the next frame's decoding process
    output reg de_frame_start, // to inform system that decoding process of current frame has already started. The given "termination" signal will be thereby deasserted by system 
    output reg [`IB_CNU_DECOMP_funNum-1:0] cn_ram_we, // enable the pipelining of IB-CNU RAMs Iteration Update
    output reg [`IB_VNU_DECOMP_funNum-1:0] vn_ram_we, // enable the pipelining of IB-VNU RAMs Iteration Update
    output reg dn_ram_we, // enable the pipelining of IB-DNU RAMs Iteration Update
	output reg [3:0] state,
   
	// Input port acknowledging from Write/Update FSMs
	input wire [`IB_CNU_DECOMP_funNum-1:0] cn_iter_update,
	input wire [`IB_VNU_DECOMP_funNum-1:0] vn_iter_update,
	input wire dn_iter_update,
   
	input wire termination, // finish deocding process of the current frame
	input wire inter_frame_align, // the notification of termination staus from the other frame's decoding process 
	input wire fsm_en,
	//input wire update_finish,
	input wire read_clk,
	//input wire cn_write_clk,
	//input wire vn_write_clk,
	//input wire dn_write_clk,
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
//------------------------------------------------------------------------------------
// IB-ROMs data fetching process 
// CNU IB-ROMs
wire [`IB_CNU_DECOMP_funNum-1:0] cn_slave_wr_rdy;
wire [`IB_CNU_DECOMP_funNum-1:0] cn_master_wr_valid;
reg  [`IB_CNU_DECOMP_funNum-1:0] cnu_pipe_load_en;      // to be controlled by the main FSM
reg  [`IB_CNU_DECOMP_funNum-1:0] cnu_init_load_en;   // to be controlled by the main FSM
wire [`IB_CNU_DECOMP_funNum-1:0] cnu_init_load_busy; // the progress of the initial-load operation
wire [`IB_CNU_DECOMP_funNum-1:0] cnu_pipe_load_busy;        // the progress of the IB-RAM write operation
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
	for(i=0;i<`IB_CNU_DECOMP_funNum;i=i+1) begin : cn_slave_wr_handshake_inst
		cnu_wr_update_handshake cn_wr_handshake(
			.cnu_wr_o			(cn_master_wr_valid[i]), // wr_valid_o
			.init_load_o		(cnu_init_load_busy[i]),
			.pipe_load_o	    (cnu_pipe_load_busy[i]),
		
			.iter_update_i      (cn_slave_wr_rdy[i]), // wr_rdy_i
			.cnu_rd_finish_i    (cnu_pipe_load_en[i]), 
			.cnu_init_load_en_i (cnu_init_load_en[i]), 
			.read_clk           (read_clk),
			.rstn 	            (rstn) 
		);
		assign cnu_wr[i] = cnu_init_load_busy[i] || cnu_pipe_load_busy[i];//cn_master_wr_valid[i];
		assign cn_slave_wr_rdy[i] = cn_iter_update[i];
	end
	
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
localparam interFrame_enStart = 2**(`QUAN_SIZE-1); // to make inter_frame_en be asserted at (Q-1)th bit transfer of priori LLR and 
						   // the INIT_LOAD state can thereby start at LLR_FETCH_OUT state of first frame's decoding process 
localparam interFrame_enStart_v = 2**(VNU_PIPELINE_LEVEL-1-1);
localparam msg_overflow = 2**(`QUAN_SIZE-1);
localparam cnu_shift_overflow = 2**(CNU_PIPELINE_LEVEL-1); 
localparam vnu_shift_overflow = 2**(VNU_PIPELINE_LEVEL-1);
reg [CNU_PIPELINE_LEVEL-1:0] cnu_pipeline_level;
reg [VNU_PIPELINE_LEVEL-1:0] vnu_pipeline_level;
reg [`QUAN_SIZE:0] v2c_msg_psp;
reg [`QUAN_SIZE:0] c2v_msg_psp;
/*(no longer be used)*///reg [2:0] cnu_init_load_cnt; // to account for the remaining clock cycles until the "BUSY" signal is asserted
/*(no longer be used)*///reg [2:0] vnu_init_load_cnt; // to account for the remaining clock cycles until the "BUSY" signal is asserted
/*(no longer be used)*///reg [2:0] dnu_init_load_cnt; // to account for the remaining clock cycles until the "BUSY" signal is asserted
//------------------------------------------------------------------------------------
// Control signals for handshaking scheme between System.FSM and WR.FSM
// Inital-Load operation
reg [2:0] init_load_cnt;
reg init_load_start;  // to signal the "START" status of "Initial-Load" operation
reg init_load_finish; // to enable the CNU_PIPE whilst "Initial-Load" operation completed
// Pipe-Load operation for CNUs
reg [2:0] cnu_pipe_load_cnt [0:`IB_CNU_DECOMP_funNum-1];
reg [`IB_CNU_DECOMP_funNum-1:0] cnu_pipe_load_start;  // to signal the "START" status of "PIPE-Load" operation
reg [`IB_CNU_DECOMP_funNum-1:0] cnu_pipe_load_finish; // to enable the CNU_PIPE of next iteration whilst "PIPE-Load" operation completed
// Pipe-Load operation for VNUs
reg [2:0] vnu_pipe_load_cnt [0:`IB_VNU_DECOMP_funNum-1];
reg [`IB_VNU_DECOMP_funNum-1:0] vnu_pipe_load_start;  // to signal the "START" status of "PIPE-Load" operation
reg [`IB_VNU_DECOMP_funNum-1:0] vnu_pipe_load_finish; // to enable the CNU_PIPE of next iteration whilst "PIPE-Load" operation completed
// Pipe-Load operation for DNUs
reg [2:0] dnu_pipe_load_cnt;
reg dnu_pipe_load_start;  // to signal the "START" status of "PIPE-Load" operation
reg dnu_pipe_load_finish; // to enable the CNU_PIPE of next iteration whilst "PIPE-Load" operation completed
//------------------------------------------------------------------------------------
initial v2c_msg_psp[`QUAN_SIZE:0] <= 0;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) v2c_msg_psp[`QUAN_SIZE:0] <= 0;
    else if(state == INIT_LOAD) v2c_msg_psp[`QUAN_SIZE:0] <= 1;
    else if(state == VNU_OUT) v2c_msg_psp[`QUAN_SIZE:0] <= 1;
    else if(state == LLR_FETCH) v2c_msg_psp[`QUAN_SIZE:0] <= {v2c_msg_psp[`QUAN_SIZE-1:0], 1'b0};
    else if(state == P2P_V) v2c_msg_psp[`QUAN_SIZE:0] <= {v2c_msg_psp[`QUAN_SIZE-1:0], 1'b0};
end
initial c2v_msg_psp[`QUAN_SIZE:0] <= 0;
always @(posedge read_clk) begin
    if(state == CNU_OUT) c2v_msg_psp[`QUAN_SIZE:0] <= 1;
    else if(state == P2P_C) c2v_msg_psp[`QUAN_SIZE:0] <= {c2v_msg_psp[`QUAN_SIZE-1:0], 1'b0};
end

always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) 
		cnu_pipeline_level <= 0;
    else if(state == CNU_PIPE) begin
		if(cnu_pipeline_level[CNU_PIPELINE_LEVEL-1:0] == 0)
			cnu_pipeline_level[CNU_PIPELINE_LEVEL-1:0] <= 1;
		//else if({cn_ram_we && cnu_pipe_load_finish} == 0)
		//	cnu_pipeline_level[CNU_PIPELINE_LEVEL-1:0] <= cnu_pipeline_level[CNU_PIPELINE_LEVEL-1:0];
		else
			cnu_pipeline_level[CNU_PIPELINE_LEVEL-1:0] <= {cnu_pipeline_level[CNU_PIPELINE_LEVEL-2:0], 1'b0};
	end
    else //if(state == CNU_OUT) 
		cnu_pipeline_level[CNU_PIPELINE_LEVEL-1:0] <= 0;
end

always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0)
		vnu_pipeline_level <= 0;
	else if(state == VNU_PIPE) begin
		if(vnu_pipeline_level[VNU_PIPELINE_LEVEL-1:0] == 0)
			vnu_pipeline_level[VNU_PIPELINE_LEVEL-1:0] <= 1;
		//else if({vn_ram_we && vnu_pipe_load_finish} == 0)
		//	vnu_pipeline_level[VNU_PIPELINE_LEVEL-1:0] <= vnu_pipeline_level[VNU_PIPELINE_LEVEL-1:0];
		else
			vnu_pipeline_level[VNU_PIPELINE_LEVEL-1:0] <= {vnu_pipeline_level[VNU_PIPELINE_LEVEL-2:0], 1'b0};
	end
    else //if(state == VNU_OUT) 
		vnu_pipeline_level[VNU_PIPELINE_LEVEL-1:0] <= 0;
end

always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) 
		init_load_cnt <= 0;
	else if(init_load_start == 1'b1) begin
		if(init_load_cnt == 0) 
			init_load_cnt <= 1;
		else if(init_load_cnt <= LOAD_HANDSHAKE_LATENCY) 
			init_load_cnt <= init_load_cnt + 1;
		else if(init_load_finish == 1'b1)
			init_load_cnt <= 0;
	end
	else 
		init_load_cnt <= 0;
end

generate
	//genvar i;
	for(i=0;i<`IB_CNU_DECOMP_funNum;i=i+1) begin : cnu_pipe_load_cnt_inst
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) 
				cnu_pipe_load_cnt[i] <= 0;
			else if(cnu_pipe_load_start[i] == 1'b1) begin
				if(cnu_pipe_load_cnt[i] == 0) 
					cnu_pipe_load_cnt[i] <= 1;
				else if(cnu_pipe_load_cnt[i] <= LOAD_HANDSHAKE_LATENCY) 
					cnu_pipe_load_cnt[i] <= cnu_pipe_load_cnt[i] + 1;
			end
			else 
				cnu_pipe_load_cnt[i] <= 0;
		end
	end
	
	for(i=0;i<`IB_VNU_DECOMP_funNum;i=i+1) begin : vnu_pipe_load_cnt_inst
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) 
				vnu_pipe_load_cnt[i] <= 0;
			else if(vnu_pipe_load_start[i] == 1'b1) begin
				if(vnu_pipe_load_cnt[i] == 0) 
					vnu_pipe_load_cnt[i] <= 1;
				else if(vnu_pipe_load_cnt[i] <= LOAD_HANDSHAKE_LATENCY) 
					vnu_pipe_load_cnt[i] <= vnu_pipe_load_cnt[i] + 1;
			end
			else 
				vnu_pipe_load_cnt[i] <= 0;
		end
	end
endgenerate
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) 
		dnu_pipe_load_cnt <= 0;
	else if(dnu_pipe_load_start == 1'b1) begin
		if(dnu_pipe_load_cnt == 0) 
			dnu_pipe_load_cnt <= 1;
		else if(dnu_pipe_load_cnt <= LOAD_HANDSHAKE_LATENCY) 
			dnu_pipe_load_cnt <= dnu_pipe_load_cnt + 1;
	end
	else 
		dnu_pipe_load_cnt <= 0;
end
//////////////////////////////////////////////////////////////////////////////////////////////////////
initial state <= INIT_LOAD;
always @(posedge read_clk) begin
	if (!fsm_en) 
        state <= INIT_LOAD;
	else if(termination == 1'b1)
		state <= INIT_LOAD;
	else
      case (state[3:0])
//////////////////////////////////////////////////////////////////////////////////////////////////////
        INIT_LOAD : begin
			//if(inter_frame_en == 1'b1) state <= LLR_FETCH;
			//else state <= INIT_LOAD; // keep idling until inter_frame_en is asserted
			
			// The inital-load and channel fetching can be operated concurrently
			state <= LLR_FETCH;
		end
//////////////////////////////////////////////////////////////////////////////////////////////////////    
        LLR_FETCH : begin
            if(v2c_msg_psp == msg_overflow)
                state <= LLR_FETCH_OUT;
            else
                state <= LLR_FETCH;
         end
//////////////////////////////////////////////////////////////////////////////////////////////////////        
		// Proceeding to the CNU IB-RAM read operation if inital-load operation is completed,
		// otherwise waiting for the completion of initial-load operation 
		LLR_FETCH_OUT : begin
			if(init_load_start == 1'b0 || init_load_finish == 1'b1) 
				state <= CNU_PIPE;
			else begin 
				state <= LLR_FETCH_OUT;
			end
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
		CNU_PIPE : begin
			if(cnu_pipeline_level == cnu_shift_overflow)
                state <= CNU_OUT;
            else
				state <= CNU_PIPE;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
        CNU_OUT: begin
            state <= P2P_C;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
        P2P_C: begin
            if(c2v_msg_psp == msg_overflow)
                state <= P2P_C_OUT;
            else
                state <= P2P_C;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
        P2P_C_OUT: begin
			if(vnu_pipe_load_finish[0] == 1'b1 || vnu_pipe_load_start[0] == 1'b0)
				state <= VNU_PIPE;
			else
				state <= P2P_C_OUT;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
        VNU_PIPE: begin
            if(vnu_pipeline_level == vnu_shift_overflow)
                state <= VNU_OUT;
            else
                state <= VNU_PIPE;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
        VNU_OUT: begin
            state <= P2P_V;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
        P2P_V: begin
            if(v2c_msg_psp == msg_overflow)
                state <= P2P_V_OUT;
            else
                state <= P2P_V;
        end
//////////////////////////////////////////////////////////////////////////////////////////////////////
        P2P_V_OUT: begin
			if(cnu_pipe_load_finish[0] == 1'b1 || cnu_pipe_load_start[0] == 1'b0)
				state <= CNU_PIPE;
			else
				state <= P2P_V_OUT;
        end   
//////////////////////////////////////////////////////////////////////////////////////////////////////
		default: begin
			state <= INIT_LOAD;
		end
    endcase
end	

initial inter_frame_en <= INIT_INTER_FRAME_EN;
always @(posedge read_clk) begin
	if (!fsm_en) inter_frame_en <= INIT_INTER_FRAME_EN;
 	else if(state[3:0] == LLR_FETCH && v2c_msg_psp == interFrame_enStart) inter_frame_en <= 1'b1; // for the first iteration only
	else if(state[3:0] == P2P_V && v2c_msg_psp == interFrame_enStart) inter_frame_en <= 1'b1; // for the iteration > 0, and it is for second frame
	else if(state[3:0] == VNU_PIPE && vnu_pipeline_level == interFrame_enStart_v) inter_frame_en <= 1'b1; // for the iteration > 0, and it is for first frame
	else if(inter_frame_align == 1'b1) inter_frame_en <= 1'b0;
end

initial de_frame_start <= 1'b0;
always @(posedge read_clk) begin
	//if(state[3:0] == LLR_FETCH) 
	if(state[3:0] == INIT_LOAD) 
		de_frame_start <= 1'b1;
	else if(state[3:0] == CNU_PIPE && termination == 1'b1) 
		de_frame_start <= 1'b0;
	else 
		de_frame_start <= de_frame_start;
end

initial cn_ram_we[`IB_CNU_DECOMP_funNum-1:0] <= `IB_CNU_DECOMP_funNum'd0;
always @(posedge read_clk) begin
    if (!fsm_en) 
        cn_ram_we[0] <= 1'b0;
    else if(state[3:0] == CNU_PIPE && cnu_pipeline_level[CNU_PIPELINE_LEVEL-1:0] == 1)
        cn_ram_we[0] <= 1'b1;
    else if(state[3:0] == P2P_V_OUT)
        cn_ram_we[0] <= 1'b0;
end
initial vn_ram_we[`IB_VNU_DECOMP_funNum-1:0] <= `IB_VNU_DECOMP_funNum'd0;
always @(posedge read_clk) begin
    if (!fsm_en) 
        vn_ram_we[0] <= 1'b0;
    else if(state[3:0] == VNU_PIPE && vnu_pipeline_level[VNU_PIPELINE_LEVEL-1:0] == 1)
        vn_ram_we[0] <= 1'b1;
    else if(state[3:0] == P2P_C_OUT)
        vn_ram_we[0] <= 1'b0;
end
initial dn_ram_we <= 0;
always @(posedge read_clk) begin
	if(!fsm_en)
		dn_ram_we <= 1'b0;
	else 
		dn_ram_we <= vn_ram_we[`IB_VNU_DECOMP_funNum-1];
end

generate
	//genvar i;
    // for check nodes
    for(i=1;i<`IB_CNU_DECOMP_funNum;i=i+1) begin : gen_cn_ram_we
        always @(posedge read_clk) begin
	    if(!fsm_en) cn_ram_we[i] <= 1'b0;
            else cn_ram_we[i] <= cn_ram_we[i-1];
        end
    end
    // for variable nodes
    for(i=1;i<`IB_VNU_DECOMP_funNum;i=i+1) begin : gen_vn_ram_we
        always @(posedge read_clk) begin
	    if(!fsm_en) vn_ram_we[i] <= 1'b0;
            else vn_ram_we[i] <= vn_ram_we[i-1];
        end
    end
endgenerate

always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) 
		init_load_start <= 0;
	else if(state == INIT_LOAD)
		init_load_start <= 1'b1;
	else 
		init_load_start <= init_load_start^init_load_finish;					
end
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0)
		init_load_finish <= 1'b0;
	else if({init_load_start, init_load_finish} == 2'b11) // to make init_load_finish only assert for one clock cycle
		init_load_finish <= 1'b0;
	else if(init_load_cnt > LOAD_HANDSHAKE_LATENCY)
		init_load_finish <= ~{|cnu_init_load_busy}; // Reduction NOR
	else 
		init_load_finish <= 1'b0;
end

generate 
	//genvar i, j;
	for(i=0;i<`IB_CNU_DECOMP_funNum;i=i+1) begin : cn_load_en_inst
		// Enable signal control of "Initial-Load" operation
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) cnu_init_load_en[i] <= 1'b0;
			else if(init_load_cnt > LOAD_HANDSHAKE_LATENCY) cnu_init_load_en[i] <= cnu_init_load_busy[i];
			else if(init_load_start && ~init_load_finish) cnu_init_load_en[i] <= 1'b1;
			else cnu_init_load_en[i] <= 1'b0;
		end

		// Enable signal controls of "Pipe-Load" operation
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) cnu_pipe_load_en[i] <= 1'b0;
			else if(cnu_pipe_load_start[i] && ~cnu_pipe_load_finish[i]) cnu_pipe_load_en[i] <= 1'b1;
			else cnu_pipe_load_en[i] <= 1'b0;
		end
		
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) cnu_pipe_load_start[i] <= 1'b0;
			else if(state == CNU_PIPE && cnu_pipeline_level >= (2**(i+0))) cnu_pipe_load_start[i] <= 1'b1; 
			else cnu_pipe_load_start[i] <= (cnu_pipe_load_start[i]^cnu_pipe_load_finish[i]);
		end								 
										 
		always @(posedge read_clk, negedge rstn) begin		
			if(rstn == 1'b0) cnu_pipe_load_finish[i] <= 1'b0;
			else if(cnu_pipe_load_cnt[i] > LOAD_HANDSHAKE_LATENCY) cnu_pipe_load_finish[i] <= ~cnu_pipe_load_busy[i];
			else cnu_pipe_load_finish[i] <= 1'b0;
		end
	end
	
	for(j=0;j<`IB_VNU_DECOMP_funNum;j=j+1) begin : vn_load_en_inst
		// Enable signal control of "Initial-Load" operation
		always @(posedge read_clk, negedge rstn) begin	
			if(rstn == 1'b0) vnu_init_load_en[j] <= 1'b0;
			else if(init_load_cnt > LOAD_HANDSHAKE_LATENCY) vnu_init_load_en[j] <= vnu_init_load_busy[j];
			
			// Two cases:
			// 1) start=1, finish=0 but wr_o=0 -> beginning of Init-Load operation
			// 2) start=1, finish=0 buy wr_o=1 -> finish tim of Init-Load Opeartion for VNUs however the reset of IB-RAMs may not complete yet
			else if(init_load_start && ~init_load_finish) vnu_init_load_en[j] <= 1'b1; 
			else vnu_init_load_en[j] <= 1'b0;
		end
		
		// Enable signal controls of "Pipe-Load" operation
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) vnu_pipe_load_en[j] <= 1'b0;
			else if(vnu_pipe_load_start[j] && ~vnu_pipe_load_finish[j]) vnu_pipe_load_en[j] <= 1'b1;
			else vnu_pipe_load_en[j] <= 1'b0;
		end
		
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) vnu_pipe_load_start[j] <= 1'b0;
			else if(state == VNU_PIPE && vnu_pipeline_level >= (2**(j+0))) vnu_pipe_load_start[j] <= 1'b1;
			else vnu_pipe_load_start[j] <= vnu_pipe_load_start[j]^vnu_pipe_load_finish[j];
		end
		
		always @(posedge read_clk, negedge rstn) begin
			if(rstn == 1'b0) vnu_pipe_load_finish[j] <= 1'b0;
			else if(vnu_pipe_load_cnt[j] > LOAD_HANDSHAKE_LATENCY) vnu_pipe_load_finish[j] <= ~vnu_pipe_load_busy[j];
			else vnu_pipe_load_finish[j] <= 1'b0;
		end
	end
endgenerate
// Enable signal control of "Initial-Load" operation
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) dnu_init_load_en <= 1'b0;
	else if(init_load_cnt > LOAD_HANDSHAKE_LATENCY) dnu_init_load_en <= dnu_init_load_busy;
	else if(init_load_start && ~init_load_finish) dnu_init_load_en <= 1'b1;
	else dnu_init_load_en <= 1'b0;
end

// Enable signal controls of "Pipe-Load" operation
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) dnu_pipe_load_en <= 1'b0;
	else if(dnu_pipe_load_start && ~dnu_pipe_load_finish) dnu_pipe_load_en <= 1'b1;
	else dnu_pipe_load_en <= 1'b0;
end

always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) dnu_pipe_load_start <= 1'b0;
	else if(state == P2P_V && v2c_msg_psp >= 2) dnu_pipe_load_start <= 1'b1;
	else dnu_pipe_load_start <= dnu_pipe_load_start^dnu_pipe_load_finish;
end

always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) dnu_pipe_load_finish <= 1'b0;
	else if(dnu_pipe_load_cnt > LOAD_HANDSHAKE_LATENCY) dnu_pipe_load_finish <= ~dnu_pipe_load_busy;
	else dnu_pipe_load_finish <= 1'b0;
end							  
//////////////////////////////////////////////////////////////////////////////////////////////////////		

assign llr_fetch = (state == INIT_LOAD || state == LLR_FETCH) ? 1'b1 : 1'b0;
assign v2c_src = (state == INIT_LOAD || state == LLR_FETCH) ? 1'b1 : 1'b0; 
assign v2c_msg_en = (state == INIT_LOAD || state == LLR_FETCH) ? 1'b1 : 
                    (state == VNU_OUT || state == P2P_V) ? 1'b1 : 1'b0;
assign cnu_rd = (state == LLR_FETCH_OUT || state == CNU_PIPE) ? 1'b1 : 
                (state == P2P_V_OUT) ? 1'b1 : 1'b0;
assign c2v_msg_en = (state == CNU_OUT || state == P2P_C) ? 1'b1 : 1'b0;
assign vnu_rd = (state == P2P_C_OUT || state == VNU_PIPE) ? 1'b1 : 1'b0;
assign dnu_rd = (state == P2P_V) ? 1'b1 : 1'b0; 

assign v2c_load = v2c_msg_psp[0];
assign c2v_load = c2v_msg_psp[0];   
endmodule