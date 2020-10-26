`include "define.vh"

module sys_fsm_tb;
parameter CONFIG        = 4'b0000;
parameter LLR_FETCH     = 4'b0001;  
parameter LLR_FETCH_OUT = 4'b0010;
parameter CNU_PIPE      = 4'b0011;
parameter CNU_OUT       = 4'b0100;
parameter P2P_C         = 4'b0101;
parameter P2P_C_OUT     = 4'b0110;
parameter VNU_PIPE      = 4'b0111;
parameter VNU_OUT       = 4'b1000;
parameter P2P_V         = 4'b1001;
parameter P2P_V_OUT     = 4'b1010;
localparam INTER_FRAME_LEVEL = 2;

wire [INTER_FRAME_LEVEL-1:0] llr_fetch;
wire [INTER_FRAME_LEVEL-1:0] v2c_src;
wire [INTER_FRAME_LEVEL-1:0] v2c_msg_en;
wire [INTER_FRAME_LEVEL-1:0] cnu_rd;
wire [INTER_FRAME_LEVEL-1:0] c2v_msg_en;
wire [INTER_FRAME_LEVEL-1:0] vnu_rd;
wire [INTER_FRAME_LEVEL-1:0] de_frame_start;
wire [INTER_FRAME_LEVEL-1:0] inter_frame_en;
wire [3:0] state [0:INTER_FRAME_LEVEL-1];
wire [INTER_FRAME_LEVEL-1:0] fsm_en;
wire [`IB_CNU_DECOMP_funNum-1:0] fsm_cn_ram_we [0:1];
wire [`IB_CNU_DECOMP_funNum-1:0] fsm_vn_ram_we [0:1];
reg [INTER_FRAME_LEVEL-1:0] termination;
reg sys_clk, rstn; // shared with all FSMs
sys_control_unit #(
    .CNU_PIPELINE_LEVEL  (5-1), // the last pipeline register is actually shared with P2P_C
    .VNU_PIPELINE_LEVEL  (3-1), // the last pipeline register is actually shared with P2P_V
    .INIT_INTER_FRAME_EN (0)
) frame_fsm_0 (
    .llr_fetch  (llr_fetch[0]),
    .v2c_src    (v2c_src[0]),
    .v2c_msg_en (v2c_msg_en[0]),
    .cnu_rd     (cnu_rd[0]),
    .c2v_msg_en (c2v_msg_en[0]),
    .vnu_rd     (vnu_rd[0]),
    .inter_frame_en (inter_frame_en[0]),
    .de_frame_start (de_frame_start[0]),
    .cn_ram_we (fsm_cn_ram_we[0]),
    .vn_ram_we (fsm_vn_ram_we[0]),
    .state (state[0]),
    
    .termination (termination[0]),
    .inter_frame_align (termination[1]),
    .sys_clk (sys_clk),
    .fsm_en (fsm_en[0]), // enable this FSM only when IB-CNU and VNU RAMs stop write operation
    .rstn (rstn)
);
and and0(fsm_en[0], rstn, inter_frame_en[1]);

sys_control_unit #(
    .CNU_PIPELINE_LEVEL  (5-1), // the last pipeline register is actually shared with P2P_C
    .VNU_PIPELINE_LEVEL  (3-1), // the last pipeline register is actually shared with P2P_V
    .INIT_INTER_FRAME_EN (1)
) frame_fsm_1 (
    .llr_fetch  (llr_fetch[1]),
    .v2c_src    (v2c_src[1]),
    .v2c_msg_en (v2c_msg_en[1]),
    .cnu_rd     (cnu_rd[1]),
    .c2v_msg_en (c2v_msg_en[1]),
    .vnu_rd     (vnu_rd[1]),
    .inter_frame_en (inter_frame_en[1]),
    .de_frame_start (de_frame_start[1]),
    .cn_ram_we (fsm_cn_ram_we[1]),
    .vn_ram_we (fsm_vn_ram_we[1]),
    .state (state[1]),
    
    .termination (termination[1]),
    .inter_frame_align (termination[0]),
    .sys_clk (sys_clk),
    .fsm_en (fsm_en[1]), // enable this FSM only when IB-CNU and VNU RAMs stop write operation
    .rstn (rstn)
);
and and1(fsm_en[1], rstn, inter_frame_en[0]);

initial begin
       $dumpfile("sys_fsm.vcd");
       $dumpvars;
end

initial
begin
	#0;
	sys_clk <= 1'b0;
	
	forever #2.5 sys_clk <= ~sys_clk;
end

initial begin
	#0;
	rstn <= 1'b0;
	
	#10;
	rstn <= 1'b1;
end

reg [3:0] iter_cnt [0:1];
initial #0 iter_cnt[0] <= 4'd0;
always @(posedge sys_clk) begin
	if(state[0] == P2P_V_OUT) iter_cnt[0] <= iter_cnt[0] + 1'b1;
	else if(iter_cnt[0] == 5) iter_cnt[0] <= 4'd0;
end 
initial #0 iter_cnt[1] <= 4'd0;
always @(posedge sys_clk) begin
	if(state[1] == P2P_V_OUT) iter_cnt[1] <= iter_cnt[1] + 1'b1;
	else if(iter_cnt[1] == 5) iter_cnt[1] <= 4'd0;
end 
initial #0 termination[INTER_FRAME_LEVEL-1:0] <= 'd0;
always @(posedge sys_clk) begin
	if(iter_cnt[0] == 5 && state[0] == CNU_PIPE && de_frame_start[0]) termination[0] <= 1'b1;
	else if(de_frame_start[0] == 1'b1 && termination[0] == 1'b1) termination[0] <= 1'b0;  
end
always @(posedge sys_clk) begin
	if(iter_cnt[1] == 5 && state[1] == CNU_PIPE && de_frame_start[1]) termination[1] <= 1'b1;
	else if(de_frame_start[1] == 1'b1 && termination[1] == 1'b1) termination[1] <= 1'b0;  
end

integer fsm_log;
initial fsm_log = $fopen("fsm_log.txt","w");
always @(posedge sys_clk) begin
    if(rstn) begin
	case (state[0])
		CONFIG: $fwrite(fsm_log,"CONFIG\t\t");
		LLR_FETCH: $fwrite(fsm_log,"LLR_FETCH\t");
		LLR_FETCH_OUT: $fwrite(fsm_log,"LLR_FETCH_OUT\t");
		CNU_PIPE: $fwrite(fsm_log,"CNU_PIPE\t");
		CNU_OUT: $fwrite(fsm_log,"CNU_OUT\t\t");
		P2P_C: $fwrite(fsm_log,"P2P_C\t\t");
		P2P_C_OUT: $fwrite(fsm_log,"P2P_C_OUT\t");
		VNU_PIPE: $fwrite(fsm_log,"VNU_PIPE\t");
		VNU_OUT: $fwrite(fsm_log,"VNU_OUT\t\t");
		P2P_V: $fwrite(fsm_log,"P2P_V\t\t");
		P2P_V_OUT: $fwrite(fsm_log,"(Iter%d)P2P_V_OUT\t", iter_cnt[0]);
	endcase
	case (state[1])
		CONFIG: $fwrite(fsm_log,"CONFIG");
		LLR_FETCH: $fwrite(fsm_log,"LLR_FETCH");
		LLR_FETCH_OUT: $fwrite(fsm_log,"LLR_FETCH_OUT");
		CNU_PIPE: $fwrite(fsm_log,"CNU_PIPE");
		CNU_OUT: $fwrite(fsm_log,"CNU_OUT");
		P2P_C: $fwrite(fsm_log,"P2P_C");
		P2P_C_OUT: $fwrite(fsm_log,"P2P_C_OUT");
		VNU_PIPE: $fwrite(fsm_log,"VNU_PIPE");
		VNU_OUT: $fwrite(fsm_log,"VNU_OUT");
		P2P_V: $fwrite(fsm_log,"P2P_V");
		P2P_V_OUT: $fwrite(fsm_log,"(Iter%d)P2P_V_OUT", iter_cnt[1]);
	endcase
	$fwrite(fsm_log, "\tcn_we: (%b, %b)\tvn_we: (%b, %b)\n", fsm_cn_ram_we[0], fsm_cn_ram_we[1], fsm_vn_ram_we[0], fsm_vn_ram_we[1]);
    end 
end

integer fsm_out [0:1];
initial begin
	fsm_out[0] = $fopen("fsm_out.0.txt", "w");
	fsm_out[1] = $fopen("fsm_out.1.txt", "w");
end
always @(posedge sys_clk) begin
	if(rstn) begin
	    $fwrite(fsm_out[0], "termination:%d, llr_fetch:%d, v2c_src:%d, v2c_msg:%d, cnu_rd:%d, c2v_msg_en:%d, vnu_rd:%d, inter_frame_en:%d, de_frame_start:%d\n", 
			termination[0], 
			llr_fetch[0],
			v2c_src[0],
			v2c_msg_en[0],
			cnu_rd[0],
			c2v_msg_en[0],
			vnu_rd[0],
			inter_frame_en[0],
			de_frame_start[0]
	    );
	    $fwrite(fsm_out[1], "termination:%d, llr_fetch:%d, v2c_src:%d, v2c_msg:%d, cnu_rd:%d, c2v_msg_en:%d, vnu_rd:%d, inter_frame_en:%d, de_frame_start:%d\n", 
			termination[1], 
			llr_fetch[1],
			v2c_src[1],
			v2c_msg_en[1],
			cnu_rd[1],
			c2v_msg_en[1],
			vnu_rd[1],
			inter_frame_en[1],
			de_frame_start[1]
	    );
	end
end

// Log files of write-enable signals for IB-CNU and IB-VNU RAMs
integer fsm_we_out [0:1];
initial begin
	fsm_we_out[0] = $fopen("cnu_we.txt", "w");
	fsm_we_out[1] = $fopen("vnu_we.txt", "w");
end
always @(posedge sys_clk) begin
	if(rstn) begin
	    $fwrite(fsm_we_out[0], "(%b, %b)\n", fsm_cn_ram_we[0], fsm_cn_ram_we[1]);
	    $fwrite(fsm_we_out[1], "(%b, %b)\n", fsm_vn_ram_we[0], fsm_vn_ram_we[1]);
	end
end

initial begin
    #(5*144);
    $fclose(fsm_log);
	$fclose(fsm_out[0]);
	$fclose(fsm_out[1]);
	$fclose(fsm_we_out[0]);
	$fclose(fsm_we_out[1]);
    $finish;
end
endmodule
