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
/*-----------------------------------------------------------------------------------------------------------*/
/*
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
*/
/*----------------------------------------------------------------------------------------------*/
/*
integer ber_log_fd; initial ber_log_fd = $fopen("ber_log.8.aug.2021.rev1.csv", "w");
always @(posedge eval_u0.read_clk) begin
	if(eval_u0.decode_termination == 1'b1) begin

			$fwrite(ber_log_fd, "snr,%d,errBit_acc,%d,block_cnt,%d,errFrame_cnt,%d,iter_cnt_acc,%d\n",
				$unsigned(eval_u0.snr_packet-20),
				$unsigned(eval_u0.err_cnt_acc),
				$unsigned(eval_u0.block_cnt),
				$unsigned(eval_u0.errFrame_cnt),
				$unsigned(eval_u0.iter_cnt_acc)
			);


			$write(ber_log_fd, "snr,%d,errBit_acc,%d,block_cnt,%d,errFrame_cnt,%d,iter_cnt_acc,%d\n",
				$unsigned(eval_u0.snr_packet-20),
				$unsigned(eval_u0.err_cnt_acc),
				$unsigned(eval_u0.block_cnt),
				$unsigned(eval_u0.errFrame_cnt),
				$unsigned(eval_u0.iter_cnt_acc)
			); 
	end
end
*/
/*----------------------------------------------------------------------------------------------*/
integer noise_vector_fd [0:9]; 
initial begin
	noise_vector_fd[0] = $fopen("noise_vector_sub0.csv", "w");
	noise_vector_fd[1] = $fopen("noise_vector_sub1.csv", "w");
	noise_vector_fd[2] = $fopen("noise_vector_sub2.csv", "w");
	noise_vector_fd[3] = $fopen("noise_vector_sub3.csv", "w");
	noise_vector_fd[4] = $fopen("noise_vector_sub4.csv", "w");
	noise_vector_fd[5] = $fopen("noise_vector_sub5.csv", "w");
	noise_vector_fd[6] = $fopen("noise_vector_sub6.csv", "w");
	noise_vector_fd[7] = $fopen("noise_vector_sub7.csv", "w");
	noise_vector_fd[8] = $fopen("noise_vector_sub8.csv", "w");
	noise_vector_fd[9] = $fopen("noise_vector_sub9.csv", "w");
end

reg [3:0] ch_msg_temp [0:9];
always @(posedge eval_u0.read_clk) begin
	if(eval_u0.inst_entire_layer_decoder_tb.ch_ram_fetch == 1'b1) begin
for(int j=0;j<85;j+=1) begin ch_msg_temp[0] = eval_u0.inst_entire_layer_decoder_tb.ib_proc_u0.inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_0_unit.ch_msg_fetchOut_1[j]; ch_msg_temp[0] = {ch_msg_temp[0][3], ~(ch_msg_temp[0][3]^ch_msg_temp[0][2]),~(ch_msg_temp[0][3]^ch_msg_temp[0][1]),~(ch_msg_temp[0][3]^ch_msg_temp[0][0])}; $fwrite(noise_vector_fd[0], "%d,", $unsigned(ch_msg_temp[0])); end 
$fwrite(noise_vector_fd[0], "\n");
for(int j=0;j<85;j+=1) begin ch_msg_temp[1] = eval_u0.inst_entire_layer_decoder_tb.ib_proc_u0.inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_1_unit.ch_msg_fetchOut_1[j]; ch_msg_temp[1] = {ch_msg_temp[1][3], ~(ch_msg_temp[1][3]^ch_msg_temp[1][2]),~(ch_msg_temp[1][3]^ch_msg_temp[1][1]),~(ch_msg_temp[1][3]^ch_msg_temp[1][0])}; $fwrite(noise_vector_fd[1], "%d,", $unsigned(ch_msg_temp[1])); end 
$fwrite(noise_vector_fd[1], "\n");
for(int j=0;j<85;j+=1) begin ch_msg_temp[2] = eval_u0.inst_entire_layer_decoder_tb.ib_proc_u0.inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_2_unit.ch_msg_fetchOut_1[j]; ch_msg_temp[2] = {ch_msg_temp[2][3], ~(ch_msg_temp[2][3]^ch_msg_temp[2][2]),~(ch_msg_temp[2][3]^ch_msg_temp[2][1]),~(ch_msg_temp[2][3]^ch_msg_temp[2][0])}; $fwrite(noise_vector_fd[2], "%d,", $unsigned(ch_msg_temp[2])); end 
$fwrite(noise_vector_fd[2], "\n");
for(int j=0;j<85;j+=1) begin ch_msg_temp[3] = eval_u0.inst_entire_layer_decoder_tb.ib_proc_u0.inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_3_unit.ch_msg_fetchOut_1[j]; ch_msg_temp[3] = {ch_msg_temp[3][3], ~(ch_msg_temp[3][3]^ch_msg_temp[3][2]),~(ch_msg_temp[3][3]^ch_msg_temp[3][1]),~(ch_msg_temp[3][3]^ch_msg_temp[3][0])}; $fwrite(noise_vector_fd[3], "%d,", $unsigned(ch_msg_temp[3])); end 
$fwrite(noise_vector_fd[3], "\n");
for(int j=0;j<85;j+=1) begin ch_msg_temp[4] = eval_u0.inst_entire_layer_decoder_tb.ib_proc_u0.inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_4_unit.ch_msg_fetchOut_1[j]; ch_msg_temp[4] = {ch_msg_temp[4][3], ~(ch_msg_temp[4][3]^ch_msg_temp[4][2]),~(ch_msg_temp[4][3]^ch_msg_temp[4][1]),~(ch_msg_temp[4][3]^ch_msg_temp[4][0])}; $fwrite(noise_vector_fd[4], "%d,", $unsigned(ch_msg_temp[4])); end 
$fwrite(noise_vector_fd[4], "\n");
for(int j=0;j<85;j+=1) begin ch_msg_temp[5] = eval_u0.inst_entire_layer_decoder_tb.ib_proc_u0.inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_5_unit.ch_msg_fetchOut_1[j]; ch_msg_temp[5] = {ch_msg_temp[5][3], ~(ch_msg_temp[5][3]^ch_msg_temp[5][2]),~(ch_msg_temp[5][3]^ch_msg_temp[5][1]),~(ch_msg_temp[5][3]^ch_msg_temp[5][0])}; $fwrite(noise_vector_fd[5], "%d,", $unsigned(ch_msg_temp[5])); end 
$fwrite(noise_vector_fd[5], "\n");
for(int j=0;j<85;j+=1) begin ch_msg_temp[6] = eval_u0.inst_entire_layer_decoder_tb.ib_proc_u0.inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_6_unit.ch_msg_fetchOut_1[j]; ch_msg_temp[6] = {ch_msg_temp[6][3], ~(ch_msg_temp[6][3]^ch_msg_temp[6][2]),~(ch_msg_temp[6][3]^ch_msg_temp[6][1]),~(ch_msg_temp[6][3]^ch_msg_temp[6][0])}; $fwrite(noise_vector_fd[6], "%d,", $unsigned(ch_msg_temp[6])); end 
$fwrite(noise_vector_fd[6], "\n");
for(int j=0;j<85;j+=1) begin ch_msg_temp[7] = eval_u0.inst_entire_layer_decoder_tb.ib_proc_u0.inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_7_unit.ch_msg_fetchOut_1[j]; ch_msg_temp[7] = {ch_msg_temp[7][3], ~(ch_msg_temp[7][3]^ch_msg_temp[7][2]),~(ch_msg_temp[7][3]^ch_msg_temp[7][1]),~(ch_msg_temp[7][3]^ch_msg_temp[7][0])}; $fwrite(noise_vector_fd[7], "%d,", $unsigned(ch_msg_temp[7])); end 
$fwrite(noise_vector_fd[7], "\n");
for(int j=0;j<85;j+=1) begin ch_msg_temp[8] = eval_u0.inst_entire_layer_decoder_tb.ib_proc_u0.inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_8_unit.ch_msg_fetchOut_1[j]; ch_msg_temp[8] = {ch_msg_temp[8][3], ~(ch_msg_temp[8][3]^ch_msg_temp[8][2]),~(ch_msg_temp[8][3]^ch_msg_temp[8][1]),~(ch_msg_temp[8][3]^ch_msg_temp[8][0])}; $fwrite(noise_vector_fd[8], "%d,", $unsigned(ch_msg_temp[8])); end 
$fwrite(noise_vector_fd[8], "\n");
for(int j=0;j<85;j+=1) begin ch_msg_temp[9] = eval_u0.inst_entire_layer_decoder_tb.ib_proc_u0.inst_entire_message_passing_wrapper.inst_msg_pass_submatrix_9_unit.ch_msg_fetchOut_1[j]; ch_msg_temp[9] = {ch_msg_temp[9][3], ~(ch_msg_temp[9][3]^ch_msg_temp[9][2]),~(ch_msg_temp[9][3]^ch_msg_temp[9][1]),~(ch_msg_temp[9][3]^ch_msg_temp[9][0])}; $fwrite(noise_vector_fd[9], "%d,", $unsigned(ch_msg_temp[9])); end 	
$fwrite(noise_vector_fd[9], "\n");
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
	wait(eval_u0.errFrame_cnt == 1);
	//$fclose(ber_log_fd);
	$fclose(noise_vector_fd[0]);
	$fclose(noise_vector_fd[1]);
	$fclose(noise_vector_fd[2]);
	$fclose(noise_vector_fd[3]);
	$fclose(noise_vector_fd[4]);
	$fclose(noise_vector_fd[5]);
	$fclose(noise_vector_fd[6]);
	$fclose(noise_vector_fd[7]);
	$fclose(noise_vector_fd[8]);
	$fclose(noise_vector_fd[9]);
	$finish;
end
endmodule
