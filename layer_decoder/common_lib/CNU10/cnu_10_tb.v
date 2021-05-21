`define QUAN_SIZE 4
`define CN_DEGREE 6

module cnu_6_tb;

localparam PATTERN_NUM = 20;

wire [`QUAN_SIZE-1:0] E [0:`CN_DEGREE-1];
reg [`QUAN_SIZE-1:0] M [0:`CN_DEGREE-1];
reg sys_clk, rstn, en;

integer f;
initial begin
  f = $fopen("cnu_6.txt","w");
  $dumpfile("tb.vcd");
  $dumpvars;
end

cnu_6 #(
	.CN_DEGREE (`CN_DEGREE),
	.QUAN_SIZE (`QUAN_SIZE),
	.MAG_SIZE (`QUAN_SIZE-1),
	.alpha_2  (2), // 0.25 -> x >> 2
	.gamma    (1)  // 0.50 -> x >> 1 
) u0(
	.ch_to_var_0 (E[0]),
	.ch_to_var_1 (E[1]),
	.ch_to_var_2 (E[2]),
	.ch_to_var_3 (E[3]),
	.ch_to_var_4 (E[4]),
	.ch_to_var_5 (E[5]),

	.var_to_ch_0 (M[0]),
	.var_to_ch_1 (M[1]),
	.var_to_ch_2 (M[2]),
	.var_to_ch_3 (M[3]),
	.var_to_ch_4 (M[4]),
	.var_to_ch_5 (M[5]),

	.sys_clk (sys_clk),
	.rstn (rstn)
);


integer MsgFile, i, p;

initial begin
	#0 sys_clk <= 0;
	forever #10 sys_clk <= ~sys_clk;
end
initial begin
	#0 rstn <= 0;
	#200 rstn <= 1;
end

reg [1:0] cnu_pipe_cnt;
initial cnu_pipe_cnt <= 0;
always @(posedge sys_clk) begin
	if(rstn == 0) cnu_pipe_cnt <= 0;
	else if(cnu_pipe_cnt == 2) cnu_pipe_cnt <= 0;
	else cnu_pipe_cnt <= cnu_pipe_cnt + 1;
end
reg [31:0] p;
always @(posedge sys_clk) begin
	if(rstn == 0) p <= 0;
	else if(cnu_pipe_cnt == 2) p <= p + 1;
	else p <= p;
end

reg [`QUAN_SIZE-1:0] tmp_msg[0:`CN_DEGREE*PATTERN_NUM-1];
initial begin
	$readmemb("in_msg.txt", tmp_msg);
end

always @(posedge sys_clk) begin
	if(rstn != 0) begin
			M[i] <= tmp_msg[p+i];
            $display("v2c[%02d]: %02d (%bB)\t", i, M[i], M[i]);
			$fwrite(f, "(M%d): %d, ", cnt, M[i]);
	end
end

	for(p=0;p<PATTERN_NUM;p=p+1) begin
		for(i=0;i<`CN_DEGREE;i=i+1) begin
			cnt[2:0] = i;

		end
		$display("\n");
		$fwrite(f, "\n");

		for(i=0;i<`CN_DEGREE;i=i+1) begin
			cnt[2:0] = i;
			$display("c2v[%02d]: %02d (%bB)\t", i, E[i], E[i]);
			$fwrite(f, "(E%d): %d, ", cnt, E[i]);
		end
		$display("\n\n");
		$fwrite(f, "\n\n");
	end




initial begin
	#5000000 $finish;
	$fclose(MsgFile);
  	$fclose(f);  
end
endmodule
