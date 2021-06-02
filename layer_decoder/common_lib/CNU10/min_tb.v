`include "define.v"

module min_tb;

localparam PATTERN_NUM = 16;

wire [`QUAN_SIZE-1:0] min1_8, opt_min1_8;
wire [`QUAN_SIZE-1:0] min1_6, opt_min1_6;
wire [`QUAN_SIZE-1:0] min2_8, opt_min2_8;
wire [`QUAN_SIZE-1:0] min2_6, opt_min2_6;
wire [2:0] min_index_8, opt_min_index_8;
wire [2:0] min_index_6, opt_min_index_6;
reg [`QUAN_SIZE-1:0] de_msg [0:`CN_DEGREE-1];

initial begin
       $dumpfile("tb.vcd");
       $dumpvars;
end

integer f [0:3];
initial begin
  f[0] = $fopen("min_8.txt","w");
  f[1] = $fopen("opt_min_8.txt","w");
  f[2] = $fopen("min_6.txt","w");
  f[3] = $fopen("opt_min_6.txt","w");
end

cnu_min_8 #() u0(
	.m1 (min1_8[`QUAN_SIZE-1:0]),
	.m2 (min2_8[`QUAN_SIZE-1:0]),
	.min_index (min_index_8),

	.de_msg_0 (de_msg[0]),
	.de_msg_1 (de_msg[1]),
	.de_msg_2 (de_msg[2]),
	.de_msg_3 (de_msg[3]),
	.de_msg_4 (de_msg[4]),
	.de_msg_5 (de_msg[5]),
	.de_msg_6 (de_msg[6]),
	.de_msg_7 (de_msg[7])
);

cnu_min_6 #() u1(
	.m1 (min1_6[`QUAN_SIZE-1:0]),
	.m2 (min2_6[`QUAN_SIZE-1:0]),
	.min_index (min_index_6),

	.de_msg_0 (de_msg[0]),
	.de_msg_1 (de_msg[1]),
	.de_msg_2 (de_msg[2]),
	.de_msg_3 (de_msg[3]),
	.de_msg_4 (de_msg[4]),
	.de_msg_5 (de_msg[5])
);

opt_cnu_min_8 #(.alpha_2(2), .gamma(3)) u2(
	.m1 (opt_min1_8[`QUAN_SIZE-1:0]),
	.m2 (opt_min2_8[`QUAN_SIZE-1:0]),
	.min_index (opt_min_index_8),

	.de_msg_0 (de_msg[0]),
	.de_msg_1 (de_msg[1]),
	.de_msg_2 (de_msg[2]),
	.de_msg_3 (de_msg[3]),
	.de_msg_4 (de_msg[4]),
	.de_msg_5 (de_msg[5]),
	.de_msg_6 (de_msg[6]),
	.de_msg_7 (de_msg[7])
);

opt_cnu_min_6 #(.alpha_2(2), .gamma(3)) u3(
	.m1 (opt_min1_6[`QUAN_SIZE-1:0]),
	.m2 (opt_min2_6[`QUAN_SIZE-1:0]),
	.min_index (opt_min_index_6),

	.de_msg_0 (de_msg[0]),
	.de_msg_1 (de_msg[1]),
	.de_msg_2 (de_msg[2]),
	.de_msg_3 (de_msg[3]),
	.de_msg_4 (de_msg[4]),
	.de_msg_5 (de_msg[5])
);

reg [`QUAN_SIZE-1:0] tmp_msg[0:`CN_DEGREE*PATTERN_NUM-1];
integer MsgFile, i, p;
initial begin
	$readmemb("in_msg.txt", tmp_msg);
	for(p=0;p<PATTERN_NUM;p=p+1) begin
		for(i=0;i<`CN_DEGREE;i=i+1) begin
			de_msg[i] <= tmp_msg[p+i];
            		$display("%b ", de_msg[i]);
			$fwrite(f[0], "(%d): %d, ", i, de_msg[i]);
			$fwrite(f[1], "(%d): %d, ", i, de_msg[i]);
			if(i<=5) begin
				$fwrite(f[2], "(%d): %d, ", i, de_msg[i]);
				$fwrite(f[3], "(%d): %d, ", i, de_msg[i]);
			end
		end
		$display("\n");
		$fwrite(f[0], "\nmin1=%d, min2=%d, MinIndex=%d\n\n", min1_8, min2_8, min_index_8);
		$fwrite(f[1], "\nmin1=%d, min2=%d, MinIndex=%d\n\n", opt_min1_8, opt_min2_8, opt_min_index_8);
		$fwrite(f[2], "\nmin1=%d, min2=%d, MinIndex=%d\n\n", min1_6, min2_6, min_index_6);
		$fwrite(f[3], "\nmin1=%d, min2=%d, MinIndex=%d\n\n", opt_min1_6, opt_min2_6, opt_min_index_6);
		#50;
	end
	$fclose(MsgFile);
  	$fclose(f[0]);  
 	 $fclose(f[1]);  
 	 $fclose(f[2]);  
 	 $fclose(f[3]);  
end

endmodule
