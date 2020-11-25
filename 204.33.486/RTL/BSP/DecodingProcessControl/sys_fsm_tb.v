`timescale 1ns / 1ps
`include "define.vh"

module sys_fsm_tb;

// FSM steps for Sys.FSMs
localparam [3:0] INIT_LOAD     = 4'b0000;
localparam [3:0] LLR_FETCH     = 4'b0001;  
localparam [3:0] LLR_FETCH_OUT = 4'b0010;
localparam [3:0] CNU_PIPE      = 4'b0011;
localparam [3:0] CNU_OUT       = 4'b0100;
localparam [3:0] P2P_C         = 4'b0101;
localparam [3:0] P2P_C_OUT     = 4'b0110;
localparam [3:0] VNU_PIPE      = 4'b0111;
localparam [3:0] VNU_OUT       = 4'b1000;
localparam [3:0] P2P_V         = 4'b1001;
localparam [3:0] P2P_V_OUT     = 4'b1010;

// FSM steps for Write.FSMs
localparam IDLE       = 3'b000;
localparam ROM_FETCH0 = 3'b001; // only for the first write or non-pipeline fashion
localparam RAM_LOAD0  = 3'b010;
localparam RAM_LOAD1  = 3'b011;
localparam FINISH     = 3'b100;

localparam INTER_FRAME_LEVEL = 2;
localparam simulate_iteration = 10; // only simulating unitl 9th iterations
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Global Simulation Nets
reg cn_write_clk, vn_write_clk, dn_write_clk;
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Nets of Sys.FSMs
wire [INTER_FRAME_LEVEL-1:0] llr_fetch;
wire [INTER_FRAME_LEVEL-1:0] v2c_src;
wire [INTER_FRAME_LEVEL-1:0] v2c_msg_en;
wire [`IB_CNU_DECOMP_funNum-1:0] cnu_rd [0:INTER_FRAME_LEVEL-1];
wire [INTER_FRAME_LEVEL-1:0] c2v_msg_en;
wire [`IB_VNU_DECOMP_funNum-1:0] vnu_rd [0:INTER_FRAME_LEVEL-1];
wire dnu_rd [0:INTER_FRAME_LEVEL-1];
wire [INTER_FRAME_LEVEL-1:0] de_frame_start;
wire [INTER_FRAME_LEVEL-1:0] inter_frame_en;
wire [3:0] sys_fsm_state [0:INTER_FRAME_LEVEL-1];
wire [INTER_FRAME_LEVEL-1:0] fsm_en;
wire [`IB_CNU_DECOMP_funNum-1:0] fsm_cn_ram_re [0:INTER_FRAME_LEVEL-1];
wire [`IB_VNU_DECOMP_funNum-1:0] fsm_vn_ram_re [0:INTER_FRAME_LEVEL-1];
wire [INTER_FRAME_LEVEL-1:0] fsm_dn_ram_re;
reg [INTER_FRAME_LEVEL-1:0] iter_termination;
reg read_clk, rstn; // shared with all FSMs
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Nets for handshaking protocol between Sys.FSM and Write.FSM
// Input port for Write FSMs from Sys.FSMs
wire [`IB_CNU_DECOMP_funNum-1:0] cnu_wr [0:INTER_FRAME_LEVEL-1];
wire [`IB_VNU_DECOMP_funNum-1:0] vnu_wr [0:INTER_FRAME_LEVEL-1];
wire [INTER_FRAME_LEVEL-1:0] dnu_wr;
// Output port from Write FSMs to Sys.FSMs
wire [`IB_CNU_DECOMP_funNum-1:0] cn_iter_update [0:INTER_FRAME_LEVEL-1];
wire [`IB_VNU_DECOMP_funNum-1:0] vn_iter_update [0:INTER_FRAME_LEVEL-1];
wire [INTER_FRAME_LEVEL-1:0] dn_iter_update;
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Nets of Write.FSMs
wire [2:0] cn_write_fsm_state [0:INTER_FRAME_LEVEL-1];
wire [2:0] vn_write_fsm_state [0:INTER_FRAME_LEVEL-1];
wire [2:0] dn_write_fsm_state [0:INTER_FRAME_LEVEL-1];
wire [`IB_CNU_DECOMP_funNum-1:0] cn_ram_write_en;
wire [`IB_VNU_DECOMP_funNum-1:0] vn_ram_write_en;
wire dn_ram_write_en;
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Instantiation of Sys.FSMs
sys_control_unit #(
    .CNU_PIPELINE_LEVEL  (5-1), // the last pipeline register is actually shared with P2P_C
    .VNU_PIPELINE_LEVEL  (3-1), // the last pipeline register is actually shared with P2P_V
    .INIT_INTER_FRAME_EN (0)
) frame_fsm_0 (
	// output port for IB-ROM update
	.cnu_wr (cnu_wr[0]),
	.vnu_wr (vnu_wr[0]),
	.dnu_wr (dnu_wr[0]),

    .llr_fetch  (llr_fetch[0]),
    .v2c_src    (v2c_src[0]),
    .v2c_msg_en (v2c_msg_en[0]),
    .cnu_rd     (cnu_rd[0]),
    .c2v_msg_en (c2v_msg_en[0]),
    .vnu_rd     (vnu_rd[0]),
	.dnu_rd		(dnu_rd[0]),
	//.c2v_load	(), // load enable signal to parallel-to-serial converter
	//.v2c_load	(), // load enable signal to parallel-to-serial converter
    .inter_frame_en (inter_frame_en[0]),
    .de_frame_start (de_frame_start[0]),
    .cn_ram_re (fsm_cn_ram_re[0]),
    .vn_ram_re (fsm_vn_ram_re[0]),
	.dn_ram_re (fsm_dn_ram_re[0]),
    .state (sys_fsm_state[0]),
    
	// Input port acknowledging from Write/Update FSMs
	.cn_iter_update (cn_iter_update[0]),
	.vn_iter_update (vn_iter_update[0]),
	.dn_iter_update (dn_iter_update[0]),
	
    .termination (iter_termination[0]),
    //.inter_frame_align (iter_termination[1]),
    .read_clk (read_clk),
    .fsm_en (fsm_en[0]), // enable this FSM only when IB-CNU and VNU RAMs stop write operation
    .rstn (rstn)
);
and and0(fsm_en[0], rstn, inter_frame_en[1]);
assign inter_frame_en[1] = 1'b1;
/*
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
    .state (sys_fsm_state[1]),
    
    .termination (iter_termination[1]),
    .inter_frame_align (iter_termination[0]),
    .read_clk (read_clk),
    .fsm_en (fsm_en[1]), // enable this FSM only when IB-CNU and VNU RAMs stop write operation
    .rstn (rstn)
);
and and1(fsm_en[1], rstn, inter_frame_en[0]);
*/
//////////////////////////////////////////////////////////////////////////////////////////////////////
// Instantiation of Write.FSMs (for simulation only)
generate
		genvar i, j;
		for(i=0;i<`IB_CNU_DECOMP_funNum;i=i+1) begin : cn_wr_fsm_inst
			cnu6_wr_fsm cnu6_wr_fsm_u0 (
				// FSM - Output
				//.rom_port_fetch (rom_port_fetch[i]), // to enable the ib-map starting to fetch data from read port of IB ROM
				.ram_write_en (cn_ram_write_en[i]),
				//.ram_mux_en (ram_mux_en[i]),
				.iter_update (cn_iter_update[0][i]),
				//.c6ib_rom_rst (c6ib_rom_rst[i]),
				//.busy (busy[i]),
				.state (cn_write_fsm_state[0]),
				// FSM - Input
				.write_clk (cn_write_clk),
				.rstn (rstn),
				.iter_rqst (cnu_wr[0][i]),
				.iter_termination (iter_termination[0])
				//.pipeline_en (pipeline_en[i])	// deprecated
			);
		end
		
		for(j=0;j<`IB_VNU_DECOMP_funNum;j=j+1) begin : vn_wr_fsm_inst
			vnu3_wr_fsm vnu3_wr_fsm_u0 (
				// FSM - Output
				//.rom_port_fetch (rom_port_fetch[j]), // to enable the ib-map starting to fetch data from read port of IB ROM
				.ram_write_en (vn_ram_write_en[j]),
				//.ram_mux_en (ram_mux_en[j]),
				.iter_update (vn_iter_update[0][j]),
				//.c6ib_rom_rst (c6ib_rom_rst[j]),
				//.busy (busy[j]),
				.state (vn_write_fsm_state[0]),
				// FSM - Input
				.write_clk (vn_write_clk),
				.rstn (rstn),
				.iter_rqst (vnu_wr[0][j]),
				.iter_termination (iter_termination[0])
				//.pipeline_en (pipeline_en[j])	// deprecated
			);
		end
endgenerate
dnu3_wr_fsm dnu3_wr_fsm_u0 (
	// FSM - Output
	//.rom_port_fetch (dn_rom_port_fetch), // to enable the ib-map starting to fetch data from read port of IB ROM
	.ram_write_en   (dn_ram_write_en),
	//.ram_mux_en     (dn_ram_mux_en),
	.iter_update    (dn_iter_update[0]),
	//.v3ib_rom_rst   (d3ib_rom_rst),
	//.busy           (dn_busy),
	.state          (dn_write_fsm_state[0]),
	// FSM - Input
	.write_clk        (dn_write_clk),
	.rstn             (rstn),
	.iter_rqst        (dnu_wr[0]),
	.iter_termination (iter_termination[0])
	//.pipeline_en    (vn_pipeline_en[i])	// deprecated
);
//////////////////////////////////////////////////////////////////////////////////////////////////////
initial begin
       $dumpfile("sys_fsm.vcd");
       $dumpvars;
end

initial begin
	#0 read_clk     <= 1'b0;
	#2.5;
	forever #5   read_clk     <= ~read_clk;
end
initial begin
	#0 cn_write_clk <= 1'b0;
	#2.5;
	forever #5   cn_write_clk <= ~cn_write_clk;
end
initial begin
	#0 vn_write_clk <= 1'b0;
	forever #2.5 vn_write_clk <= ~vn_write_clk;
end
initial begin
	#0 dn_write_clk <= 1'b0;
	forever #2.5 dn_write_clk <= ~dn_write_clk;
end
initial begin
	#0;
	rstn <= 1'b0;
	
	#(15*100);
	rstn <= 1'b1;
end

/*
reg [3:0] iter_cnt [0:1];
initial #0 iter_cnt[0] <= 4'd0;
always @(posedge read_clk) begin
	if(sys_fsm_state[0] == P2P_V_OUT) iter_cnt[0] <= iter_cnt[0] + 1'b1;
	else if(iter_cnt[0] == 5) iter_cnt[0] <= 4'd0;
end 
initial #0 iter_cnt[1] <= 4'd0;
always @(posedge read_clk) begin
	if(sys_fsm_state[1] == P2P_V_OUT) iter_cnt[1] <= iter_cnt[1] + 1'b1;
	else if(iter_cnt[1] == 5) iter_cnt[1] <= 4'd0;
end 
initial #0 iter_termination[INTER_FRAME_LEVEL-1:0] <= 'd0;
always @(posedge read_clk) begin
	if(iter_cnt[0] == 5 && sys_fsm_state[0] == CNU_PIPE && de_frame_start[0]) iter_termination[0] <= 1'b1;
	else if(de_frame_start[0] == 1'b1 && iter_termination[0] == 1'b1) iter_termination[0] <= 1'b0;  
end
always @(posedge read_clk) begin
	if(iter_cnt[1] == 5 && sys_fsm_state[1] == CNU_PIPE && de_frame_start[1]) iter_termination[1] <= 1'b1;
	else if(de_frame_start[1] == 1'b1 && iter_termination[1] == 1'b1) iter_termination[1] <= 1'b0;  
end
*/

localparam iter_cnt_bitwidth = $clog2(simulate_iteration);
reg [iter_cnt_bitwidth-1:0] iter_cnt;
always @(posedge read_clk, negedge rstn) begin
	if(rstn == 1'b0) 
		iter_cnt <= 0;
	else if(sys_fsm_state[0] == VNU_OUT)
		iter_cnt <= iter_cnt + 1'b1;
	else
		iter_cnt <= iter_cnt;
end

//////////////////////////////////////////////////////////////////////////////////////////////////////
// Log File
//integer fsm_log;
//initial fsm_log = $fopen("fsm_log.txt","w");
//always @(posedge read_clk) begin
//    if(rstn) begin
//		case (sys_fsm_state[0])
//			INIT_LOAD: $fwrite(fsm_log,"INIT_LOAD\t\t");
//			LLR_FETCH: $fwrite(fsm_log,"LLR_FETCH\t");
//			LLR_FETCH_OUT: $fwrite(fsm_log,"LLR_FETCH_OUT\t");
//			CNU_PIPE: $fwrite(fsm_log,"CNU_PIPE\t");
//			CNU_OUT: $fwrite(fsm_log,"CNU_OUT\t\t");
//			P2P_C: $fwrite(fsm_log,"P2P_C\t\t");
//			P2P_C_OUT: $fwrite(fsm_log,"P2P_C_OUT\t");
//			VNU_PIPE: $fwrite(fsm_log,"VNU_PIPE\t");
//			VNU_OUT: $fwrite(fsm_log,"VNU_OUT\t\t");
//			P2P_V: $fwrite(fsm_log,"P2P_V\t\t");
//			P2P_V_OUT: $fwrite(fsm_log,"(Iter%d)P2P_V_OUT\t", iter_cnt[0]);
//		endcase
//		/*
//		case (sys_fsm_state[1])
//			INIT_LOAD: $fwrite(fsm_log,"CONFIG");
//			LLR_FETCH: $fwrite(fsm_log,"LLR_FETCH");
//			LLR_FETCH_OUT: $fwrite(fsm_log,"LLR_FETCH_OUT");
//			CNU_PIPE: $fwrite(fsm_log,"CNU_PIPE");
//			CNU_OUT: $fwrite(fsm_log,"CNU_OUT");
//			P2P_C: $fwrite(fsm_log,"P2P_C");
//			P2P_C_OUT: $fwrite(fsm_log,"P2P_C_OUT");
//			VNU_PIPE: $fwrite(fsm_log,"VNU_PIPE");
//			VNU_OUT: $fwrite(fsm_log,"VNU_OUT");
//			P2P_V: $fwrite(fsm_log,"P2P_V");
//			P2P_V_OUT: $fwrite(fsm_log,"(Iter%d)P2P_V_OUT", iter_cnt[1]);
//		endcase
//		*/
//		$fwrite(fsm_log, "\tcn_we: (%b)\tvn_we: (%b)\tdn_we: (%b)\n", fsm_cn_ram_we[0], fsm_vn_ram_we[0], fsm_dn_ram_we[0]);
//    end 
//end
//
//integer fsm_out [0:1];
//initial begin
//	fsm_out[0] = $fopen("fsm_out.0.txt", "w");
//	fsm_out[1] = $fopen("fsm_out.1.txt", "w");
//end
//always @(posedge read_clk) begin
//	if(rstn) begin
//	    $fwrite(fsm_out[0], "iter_termination:%d, llr_fetch:%d, v2c_src:%d, v2c_msg:%d, cnu_rd:%d, c2v_msg_en:%d, vnu_rd:%d, inter_frame_en:%d, de_frame_start:%d\n", 
//			iter_termination[0], 
//			llr_fetch[0],
//			v2c_src[0],
//			v2c_msg_en[0],
//			cnu_rd[0],
//			c2v_msg_en[0],
//			vnu_rd[0],
//			inter_frame_en[0],
//			de_frame_start[0]
//	    );
//		/*
//	    $fwrite(fsm_out[1], "iter_termination:%d, llr_fetch:%d, v2c_src:%d, v2c_msg:%d, cnu_rd:%d, c2v_msg_en:%d, vnu_rd:%d, inter_frame_en:%d, de_frame_start:%d\n", 
//			iter_termination[1], 
//			llr_fetch[1],
//			v2c_src[1],
//			v2c_msg_en[1],
//			cnu_rd[1],
//			c2v_msg_en[1],
//			vnu_rd[1],
//			inter_frame_en[1],
//			de_frame_start[1]
//	    );
//		*/
//	end
//end
//
//// Log files of write-enable signals for IB-CNU and IB-VNU RAMs
//integer fsm_we_out [0:1];
//initial begin
//	fsm_we_out[0] = $fopen("cnu_we.txt", "w");
//	//fsm_we_out[1] = $fopen("vnu_we.txt", "w");
//end
//always @(posedge read_clk) begin
//	if(rstn) begin
//	    $fwrite(fsm_we_out[0], "(%b, %b)\n", fsm_cn_ram_we[0], fsm_cn_ram_we[1]);
//	    //$fwrite(fsm_we_out[1], "(%b, %b)\n", fsm_vn_ram_we[0], fsm_vn_ram_we[1]);
//	end
//end
//////////////////////////////////////////////////////////////////////////////////////////////////////

initial begin
	#0 iter_termination <= 0;
	//wait(iter_cnt == simulate_iteration);  //#(10*144);
	#5000;
	iter_termination <= 2'b11;
	#100;
	//$fclose(fsm_log);
	//$fclose(fsm_out[0]);
	////$fclose(fsm_out[1]);
	//$fclose(fsm_we_out[0]);
	////$fclose(fsm_we_out[1]);
    $finish;
end
endmodule
