`timescale 1 ns / 1 ps
`include "define.vh"
//`define MSG_DUT_FILE
//`define PRINT_DEBUG
module layer_decoder_tb_top;

// Local variables
parameter ClkPeriod = 3.333; // 300 MHz
reg CLK_300_N;
reg CLK_300_P;
reg GPIO_PB_SW2, GPIO_PB_SW3;
wire ready_work, is_awgn_out;

// System signals
initial begin
    CLK_300_N <= 1'b0;
    #(ClkPeriod*1);
    forever #(ClkPeriod/2) CLK_300_N = ~CLK_300_N;
end
initial begin
    CLK_300_P <= 1'b1;
    #(ClkPeriod*1);
    forever #(ClkPeriod/2) CLK_300_P = ~CLK_300_P;
end

initial begin
    #0;
    GPIO_PB_SW2 <= 0;
    
    #10;
    GPIO_PB_SW2 <= 1;
    
    #100;
    GPIO_PB_SW2 <= 0;
end

initial begin
    #0 GPIO_PB_SW3 <= 1'b1;
    
    wait(ready_work == 1'b1);
    #100 GPIO_PB_SW3 <= 1'b0;
    
    //#100 GPIO_PB_SW3 <= 1'0;
end

logic                       a;
logic                       b;
logic [`AXI_FRAME_SIZE-1:0] c;
logic                       d;
logic                       e;
logic                       f;
logic                       g;
logic                       h;
ib_layer_decoder_ber_eval #(
	.N(7650),
	.QUAN_SIZE(4),
	.MAGNITUDE_SIZE(3),
	.ERR_FRAME_HALT(`ERR_FRAME_HALT),
	.MAX_ITER(`MAX_ITER),
	.ITER_ADDR_BW($clog2(10)),
	.SNR_SET_NUM(`SNR_SET_NUM),
	.START_SNR(`START_SNR)
) eval_u0 (
	.ready_work  (ready_work),
	.is_awgn_out (is_awgn_out),
	.CLK_300_N   (CLK_300_N),
	.CLK_300_P   (CLK_300_P),
	.GPIO_PB_SW2 (GPIO_PB_SW2),
	.GPIO_PB_SW3 (GPIO_PB_SW3),
	.a           (a),
	.b           (b),
	.c           (c),
	.d           (d),
	.e           (e),
	.f           (f),
	.g           (g),
	.h           (h)
);

always @(posedge eval_u0.read_clk) begin
	if(eval_u0.decoder_rstn == 1'b0) 
		$write("RESET\n");
	else if(eval_u0.errBit_cnt_top_u0.busy == 1'b1 && eval_u0.errBit_cnt_top_u0.busy_cnt >= 4) begin
		$write("Iter_%d, layer_%d, state_%d -> errBit_cnt:%d\n", 
					$unsigned($clog2(eval_u0.inst_entire_layer_decoder_tb.inst_vnu_control_unit.iter_cnt)), 
					$unsigned(eval_u0.inst_entire_layer_decoder_tb.inst_vnu_control_unit.layer_cnt), 
					$unsigned(eval_u0.inst_entire_layer_decoder_tb.inst_vnu_control_unit.state), 
					$unsigned(eval_u0.errBit_cnt_top_u0.err_count)
		);
	end
end
/*----------------------------------------------------------------------------------------------*/
// Termination Control of Simulation
reg entire_sim_termination; initial entire_sim_termination <= 1'b0;
reg count_done_sync; initial count_done_sync <= 0;
always @(posedge eval_u0.read_clk) count_done_sync <= eval_u0.count_done;
always @(posedge eval_u0.read_clk, negedge GPIO_PB_SW3) begin
	if(GPIO_PB_SW3 == 1'b1)
		entire_sim_termination <= 1'b0;
	else if(count_done_sync == 1'b1 && eval_u0.errFrame_cnt == `ERR_FRAME_HALT && eval_u0.snr_packet == `SNR_SET_NUM-1)
		entire_sim_termination <= 1'b1;
end
initial begin
    //wait(eval_u0.entire_decoder_u0.iter_cnt == 50);
	//#88_4780000;
	//wait(entire_sim_termination == 1'b1);
	wait(eval_u0.block_cnt >= 5);
	$finish;
end
endmodule