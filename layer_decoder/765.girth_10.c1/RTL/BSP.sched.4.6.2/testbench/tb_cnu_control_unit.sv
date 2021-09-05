`timescale 1ns/1ps
`include "define.vh"
module tb_cnu_control_unit (); /* this is automatically generated */

	// clock
	logic read_clk;
	initial begin
		read_clk = 0;
		forever #(10) read_clk = ~read_clk;
	end

	// asynchronous reset
	logic rstn;
	initial begin
		rstn <= 0;
		#100
		rstn <= 1;
	end

	// (*NOTE*) replace reset, clock, others

	parameter                              QUAN_SIZE = 4;
	parameter 							   LAYER_NUM = 3;
	parameter                            RESET_CYCLE = 100;
	parameter                          VN_LOAD_CYCLE = 64;
	parameter                          DN_LOAD_CYCLE = 64;
	parameter                         MSG_PASS_CYCLE = 5;
	parameter                         CNU_FUNC_CYCLE = 4;
	parameter                         VNU_FUNC_CYCLE = 3;
	parameter                         DNU_FUNC_CYCLE = 3;
	parameter                       VNU_FUNC_MEM_END = 2;
	parameter                       DNU_FUNC_MEM_END = 2;
	parameter              VNU_WR_HANDSHAKE_RESPONSE = 2;
	parameter              DNU_WR_HANDSHAKE_RESPONSE = 2;
	parameter                     CNU_PIPELINE_LEVEL = 1*CNU_FUNC_CYCLE;
	parameter                     VNU_PIPELINE_LEVEL = 2*VNU_FUNC_CYCLE;
	parameter                     DNU_PIPELINE_LEVEL = 1*DNU_FUNC_CYCLE;
	parameter                      PERMUTATION_LEVEL = 2;
	parameter                       PAGE_ALIGN_LEVEL = 1;
	parameter                           MEM_RD_LEVEL = 2;
	parameter                          FSM_STATE_NUM = 8;
	parameter  [$clog2(FSM_STATE_NUM)-1:0] INIT_LOAD = 0;
	parameter  [$clog2(FSM_STATE_NUM)-1:0] MEM_FETCH = 1;
	parameter   [$clog2(FSM_STATE_NUM)-1:0] CNU_PIPE = 2;
	parameter    [$clog2(FSM_STATE_NUM)-1:0] CNU_OUT = 3;
	parameter      [$clog2(FSM_STATE_NUM)-1:0] BS_WB = 4;
	parameter [$clog2(FSM_STATE_NUM)-1:0] PAGE_ALIGN = 5;
	parameter     [$clog2(FSM_STATE_NUM)-1:0] MEM_WB = 6;
	parameter [$clog2(FSM_STATE_NUM)-1:0] IDLE 		 = 7;
	localparam                  RESET_CYCLE_BITWIDTH = $clog2(RESET_CYCLE);
	localparam                     bs_shift_overflow = 2**(PERMUTATION_LEVEL-1);
	localparam                    cnu_shift_overflow = 2**(CNU_PIPELINE_LEVEL-1-1);
	localparam                  fetch_shift_overflow = 2**(MEM_RD_LEVEL-1);

	logic                             cnu_rd;
	logic                             c2v_mem_we;
	logic                             v2c_src;
	logic                             de_frame_start;
	logic [$clog2(FSM_STATE_NUM)-1:0] state;
	logic                             layer_finish;
	logic                             termination;
	logic                             fsm_en;

	cnu_control_unit #(
			.QUAN_SIZE(QUAN_SIZE),
			.LAYER_NUM(LAYER_NUM),
			.RESET_CYCLE(RESET_CYCLE),
			.CNU_FUNC_CYCLE(CNU_FUNC_CYCLE),
			.CNU_PIPELINE_LEVEL(CNU_PIPELINE_LEVEL),
			.PERMUTATION_LEVEL(PERMUTATION_LEVEL),
			.PAGE_ALIGN_LEVEL(PAGE_ALIGN_LEVEL),
			.MEM_RD_LEVEL(MEM_RD_LEVEL),
			.FSM_STATE_NUM(FSM_STATE_NUM),
			.INIT_LOAD(INIT_LOAD),
			.MEM_FETCH(MEM_FETCH),
			.CNU_PIPE(CNU_PIPE),
			.CNU_OUT(CNU_OUT),
			.BS_WB(BS_WB),
			.PAGE_ALIGN(PAGE_ALIGN),
			.MEM_WB(MEM_WB),
			.IDLE (IDLE)
		) inst_cnu_control_unit (
			.cnu_rd             (cnu_rd),
			.c2v_mem_we         (c2v_mem_we),
			.v2c_src            (v2c_src),
			.de_frame_start     (de_frame_start),
			.state              (state),
			.layer_finish       (layer_finish),
			.termination        (termination),
			.fsm_en             (fsm_en),
			.read_clk           (read_clk),
			.rstn               (rstn)
		);

	reg [4:0] sys_cnt;
	always @(posedge read_clk) begin
		if(rstn == 1'b0) sys_cnt <= 0;
		else if(fsm_en == 1'b1 && sys_cnt == 0) sys_cnt <= 1;
		else if(sys_cnt == 20) sys_cnt <= 1'b0;
		else if(sys_cnt > 0) sys_cnt <= sys_cnt+1;
	end
	always @(posedge read_clk) begin
		if(rstn == 1'b0) layer_finish <= 0;
		else if(sys_cnt == 20) layer_finish <= 1;
		else layer_finish <= 0;
	end

	always @(posedge read_clk) begin
			if(rstn == 1'b0) termination <= 0;
			else if(
				inst_cnu_control_unit.iter_cnt[`MAX_ITER-1] == 1'b1 && 
				state[$clog2(FSM_STATE_NUM)-1:0] == CNU_PIPE
			) 
				termination <= 1'b1;
	end

	task init();
		termination  <= 0;
		fsm_en       <= 0;
	endtask

	task drive(int iter);

	endtask

	initial begin
		// do something

		init();
		repeat(10)@(posedge read_clk);
		fsm_en       <= 1;

		//drive(20);

		wait(termination == 1'b1);
		repeat(1)@(posedge read_clk);
		$finish;
	end


endmodule
