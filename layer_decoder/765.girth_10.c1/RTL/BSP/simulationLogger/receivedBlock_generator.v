`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2020 01:24:31 PM
// Design Name: 
// Module Name: receivedBlock_generator
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

module receivedBlock_generator #(
	parameter N = 7650, // block length
	parameter NG_NUM = 10, // 10 codeword segments
	parameter NG_SIZE = N / NG_NUM, // the number of codebits in each codeword segment
	parameter QUAN_SIZE = 4 // 4-bit quantisation for each channel message
)(
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_0,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_1,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_2,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_3,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_4,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_5,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_6,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_7,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_8,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_9,
	output wire tvalid_master,
	
	input wire [15:0] sigma_in,
	//input wire [63:0] seed_base_0,
	//input wire [63:0] seed_base_1,
	//input wire [63:0] seed_base_2,
	input wire ready_slave,
	input wire rstn,
	input sys_clk
);

localparam [64*17-1:0] rand_seedIn_0 = {64'd5030521883283424767, 64'd1152920406437395203, 64'd2305840812874790407, 64'd3458761219312185611, 64'd4611681625749580815, 64'd5764602032186976019, 64'd6917522438624371223, 64'd8070442845061766427, 64'd9223363251499161631, 64'd10376283657936556834, 64'd11529204064373952038, 64'd12682124470811347242, 64'd13835044877248742446, 64'd14987965283686137650, 64'd16140885690123532854, 64'd17293806096560928058, 64'd18446726502998323262};
localparam [64*17-1:0] rand_seedIn_1 = {64'd18445829279364155008, 64'd287527058078059776, 64'd286823740002834945, 64'd286121212203684611, 64'd285417103854482434, 64'd284713098585532674, 64'd284012048255133190, 64'd283308833259104007, 64'd282603831558825989, 64'd281899688849847556, 64'd281195821019877892, 64'd280496866633489164, 64'd279793720356981773, 64'd279090814600708367, 64'd278387290368069135, 64'd277682975860399886, 64'd276977286965415946};
localparam [64*17-1:0] rand_seedIn_2 = {64'd18436106298727503359, 64'd16717088381179615568, 64'd14987714163643036320, 64'd13258322079042759729, 64'd11528965728570139969, 64'd9799556601539378833, 64'd8070181559369324642, 64'd6340852421809500658, 64'd4611468858424085123, 64'd2882032518480757971, 64'd1152650604362824995, 64'd17870029531506677684, 64'd16140644593732006084, 64'd14411253058887313684, 64'd12681986318612358117, 64'd10952609902052719733, 64'd9223219191841789190};

wire [NG_NUM-1:0] valid_i;
wire [NG_NUM-1:0] ready_o;
wire [NG_NUM-1:0] valid_o;
wire [NG_NUM-1:0] ready_i;
wire [NG_SIZE*QUAN_SIZE-1:0] codeword_segment_master [0:NG_NUM-1];
wire [NG_SIZE*QUAN_SIZE-1:0] codeword_segment [0:NG_NUM-1];
assign tvalid_master = {&valid_o[NG_NUM-1:0]};
generate
    genvar i;
	for(i = 0; i < NG_NUM; i = i+1) begin : block_gen_inst
		subblock_generator #(
			.N (NG_SIZE), // block length, e.g., 765
			.QUAN_SIZE (QUAN_SIZE), // 4-bit quantisation for each channel message
	        .RAND_SEED_0 (rand_seedIn_0[(64*(i+1+4))-1:64*(i+4)]),
	        .RAND_SEED_1 (rand_seedIn_1[(64*(i+1+4))-1:64*(i+4)]),
	        .RAND_SEED_2 (rand_seedIn_2[(64*(i+1+4))-1:64*(i+4)]),
			.PIPELINE_DELAY (24)
	    ) subblock_gen_u (
			.sub_block (codeword_segment[i]),
			.tvalid (valid_i[i]),
			
			.sigma_in (sigma_in[15:0]),
			//.seed_offset (),
			.ready (ready_o[i]),
			.rstn (rstn),
			.sys_clk (sys_clk)
		);
		
		Handshake_Protocol #(.N(NG_SIZE), .QUAN_SIZE(QUAN_SIZE)) handshake_interface_u (
			.ready_o (ready_o[i]),//to pre-stage
			.valid_o (valid_o[i]), //to post-stage
			.data_o  (codeword_segment_master[i]), //to post-stage
		
			.valid_i (valid_i[i]), //from pre-stage
			.data_i  (codeword_segment[i]), //from pre-stage
			.ready_i (ready_i[i]), //from post-stage	
			.clk (sys_clk),
			.rstn (rstn)
		);
		assign ready_i[i] = ready_slave;
		//assign coded_block[(i+1)*NG_SIZE*QUAN_SIZE-1:i*NG_SIZE*QUAN_SIZE] = codeword_segment_master[i];  
	end
endgenerate
assign coded_block_0 = codeword_segment_master[0];
assign coded_block_1 = codeword_segment_master[1];
assign coded_block_2 = codeword_segment_master[2];
assign coded_block_3 = codeword_segment_master[3];
assign coded_block_4 = codeword_segment_master[4];
assign coded_block_5 = codeword_segment_master[5];
assign coded_block_6 = codeword_segment_master[6];
assign coded_block_7 = codeword_segment_master[7];
assign coded_block_8 = codeword_segment_master[8];
assign coded_block_9 = codeword_segment_master[9];
endmodule

module subblock_generator #(
	parameter N = 765, // block length
	parameter QUAN_SIZE = 4, // 4-bit quantisation for each channel message
	parameter RAND_SEED_0 = 64'd5030521883283424767,
    parameter RAND_SEED_1 = 64'd18445829279364155008,
    parameter RAND_SEED_2 = 64'd18436106298727503359,
	
	// The latency (clock cycle) of producing firt symbol, 
	// equal to the pipeline depth of symbol generator 
	parameter PIPELINE_DELAY = 25
	)(
	output reg [N*QUAN_SIZE-1:0] sub_block,
	output reg tvalid,
	
	input wire [15:0] sigma_in,
	//input wire [63:0] seed_offset,
	input wire ready,
	input wire rstn,
	input sys_clk
);
wire [QUAN_SIZE-1:0] ch_msg;
wire tran_cntR;
assign tran_cntR = ready & ~tvalid;
localparam pipeline_bitwidth = $clog2(PIPELINE_DELAY);
reg [pipeline_bitwidth-1:0] pipeline_cycle;
reg sampleGeneratorEnR;
initial pipeline_cycle <= 0;
always @(posedge sys_clk, negedge rstn) begin
	if(rstn == 1'b0) pipeline_cycle <= 0;
	else if(!tran_cntR) pipeline_cycle <= 0;
	else pipeline_cycle <= pipeline_cycle + 1'b1;
end 
initial sampleGeneratorEnR <=1'b 0;
always @(posedge sys_clk, negedge rstn) begin
	if(rstn == 1'b0) sampleGeneratorEnR <= 1'b0;
	else if(!tran_cntR) sampleGeneratorEnR <= 1'b0;
	else if(pipeline_cycle == PIPELINE_DELAY) sampleGeneratorEnR <= 1'b1;
end

localparam  CNT_WIDTH = $clog2(N);
reg [CNT_WIDTH-1:0] symbol_cnt;
initial symbol_cnt[CNT_WIDTH-1:0] <= 0;
always @(posedge sys_clk, negedge rstn) begin
	if(rstn == 1'b0) 
		symbol_cnt[CNT_WIDTH-1:0] <= 0;
	else if(sampleGeneratorEnR == 1'b0) 
		symbol_cnt[CNT_WIDTH-1:0] <= 0;
	else if(sampleGeneratorEnR == 1'b1)
		symbol_cnt[CNT_WIDTH-1:0] <= symbol_cnt[CNT_WIDTH-1:0] + 1'b1;
end

initial tvalid <= 1'b0;
always @(posedge sys_clk, negedge rstn) begin
	if(!rstn)
		tvalid <= 1'b0;
	else if(symbol_cnt[CNT_WIDTH-1:0] == N-1) 
		tvalid <= 1'b1; // completion timing of symbols generation
	else if(ready == 1'b0) 
		tvalid <= 1'b0; // reset valid assertion
	else 
		tvalid <= 1'b0;
end

initial sub_block[N*QUAN_SIZE-1:0] <= 0;
always @(posedge sys_clk, negedge rstn) begin
	if(!rstn) sub_block[N*QUAN_SIZE-1:0] <= 0;
	else if(sampleGeneratorEnR == 1'b1) 
		sub_block[N*QUAN_SIZE-1:0] <= {sub_block[(N-1)*QUAN_SIZE-1:0], ch_msg[QUAN_SIZE-1:0]};
end

	symbol_generator #(
	   .QUAN_SIZE   (QUAN_SIZE),
	   .RAND_SEED_0 (RAND_SEED_0),
	   .RAND_SEED_1 (RAND_SEED_1),
	   .RAND_SEED_2 (RAND_SEED_2)
	) symbol_gnerator_u0(
    .ch_msg (ch_msg[QUAN_SIZE-1:0]),

    .sigma_in (sigma_in[15:0]), // standard deviation of underlying AWGN channel
    //.coded_bit (coded_bit), // without BPSK modulation
    .sys_clk (sys_clk),
    .rstn (rstn),
    .ce (tran_cntR)
    );   
endmodule
/*================================================================================================================*/
module receivedBlock_generator_boxMuller #(
	parameter N = 7650, // block length
	parameter NG_NUM = 10, // 10 codeword segments
	parameter NG_SIZE = N / NG_NUM, // the number of codebits in each codeword segment
	parameter QUAN_SIZE = 4 // 4-bit quantisation for each channel message
)(
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_0,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_1,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_2,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_3,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_4,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_5,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_6,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_7,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_8,
	output wire [NG_SIZE*QUAN_SIZE-1:0] coded_block_9,
	output wire tvalid_master,
	
	input wire [15:0] sigma_in,
	//input wire [63:0] seed_base_0,
	//input wire [63:0] seed_base_1,
	//input wire [63:0] seed_base_2,
	input wire ready_slave,
	input wire rstn,
	input sys_clk
);

localparam [64*17-1:0] rand_seedIn_0 = {64'd5030521883283424767, 64'd1152920406437395203, 64'd2305840812874790407, 64'd3458761219312185611, 64'd4611681625749580815, 64'd5764602032186976019, 64'd6917522438624371223, 64'd8070442845061766427, 64'd9223363251499161631, 64'd10376283657936556834, 64'd11529204064373952038, 64'd12682124470811347242, 64'd13835044877248742446, 64'd14987965283686137650, 64'd16140885690123532854, 64'd17293806096560928058, 64'd18446726502998323262};
localparam [64*17-1:0] rand_seedIn_1 = {64'd18445829279364155008, 64'd287527058078059776, 64'd286823740002834945, 64'd286121212203684611, 64'd285417103854482434, 64'd284713098585532674, 64'd284012048255133190, 64'd283308833259104007, 64'd282603831558825989, 64'd281899688849847556, 64'd281195821019877892, 64'd280496866633489164, 64'd279793720356981773, 64'd279090814600708367, 64'd278387290368069135, 64'd277682975860399886, 64'd276977286965415946};
localparam [64*17-1:0] rand_seedIn_2 = {64'd18436106298727503359, 64'd16717088381179615568, 64'd14987714163643036320, 64'd13258322079042759729, 64'd11528965728570139969, 64'd9799556601539378833, 64'd8070181559369324642, 64'd6340852421809500658, 64'd4611468858424085123, 64'd2882032518480757971, 64'd1152650604362824995, 64'd17870029531506677684, 64'd16140644593732006084, 64'd14411253058887313684, 64'd12681986318612358117, 64'd10952609902052719733, 64'd9223219191841789190};

wire [(NG_NUM/2)-1:0] valid_i;
wire [NG_NUM-1:0] ready_o;
wire [NG_NUM-1:0] valid_o;
wire [NG_NUM-1:0] ready_i;
wire [NG_SIZE*QUAN_SIZE-1:0] codeword_segment_master [0:NG_NUM-1];
wire [NG_SIZE*QUAN_SIZE-1:0] codeword_segment [0:NG_NUM-1];
assign tvalid_master = {&valid_o[NG_NUM-1:0]};
generate
    genvar i;
	for(i = 0; i < (NG_NUM/2/*since each Box-Muller Method generates two independent samples*/); i = i+1) begin : block_gen_inst
		subblock_generator_boxMuller #(
			.N (NG_SIZE), // block length, e.g., 765
			.QUAN_SIZE (QUAN_SIZE), // 4-bit quantisation for each channel message
	        .RAND_SEED_0 (rand_seedIn_0[(64*(i+1))-1:64*(i)]),
	        .RAND_SEED_1 (rand_seedIn_1[(64*(i+1))-1:64*(i)]),
	        .RAND_SEED_2 (rand_seedIn_2[(64*(i+1))-1:64*(i)]),
	        .RAND_SEED_3 (rand_seedIn_0[(64*(i+4))-1:64*(i+3)]),
	        .RAND_SEED_4 (rand_seedIn_1[(64*(i+4))-1:64*(i+3)]),
	        .RAND_SEED_5 (rand_seedIn_2[(64*(i+4))-1:64*(i+3)]),
			.PIPELINE_DELAY (24)
	    ) subblock_gen_u (
			.sub_block_0 (codeword_segment[(i*2)+0]),
			.sub_block_1 (codeword_segment[(i*2)+1]),
			.tvalid (valid_i[i]),
			
			.sigma_in (sigma_in[15:0]),
			//.seed_offset (),
			.ready (ready_o[i]),
			.rstn (rstn),
			.sys_clk (sys_clk)
		);
		
		Handshake_Protocol #(.N(NG_SIZE), .QUAN_SIZE(QUAN_SIZE)) handshake_interface_u0 (
			.ready_o (ready_o[(i*2)+0]),//to pre-stage
			.valid_o (valid_o[(i*2)+0]), //to post-stage
			.data_o  (codeword_segment_master[(i*2)+0]), //to post-stage
		
			.valid_i (valid_i[i]), //from pre-stage
			.data_i  (codeword_segment[(i*2)+0]), //from pre-stage
			.ready_i (ready_i[(i*2)+0]), //from post-stage	
			.clk (sys_clk),
			.rstn (rstn)
		);
		Handshake_Protocol #(.N(NG_SIZE), .QUAN_SIZE(QUAN_SIZE)) handshake_interface_u1 (
			.ready_o (ready_o[(i*2)+1]),//to pre-stage
			.valid_o (valid_o[(i*2)+1]), //to post-stage
			.data_o  (codeword_segment_master[(i*2)+1]), //to post-stage
		
			.valid_i (valid_i[i]), //from pre-stage
			.data_i  (codeword_segment[(i*2)+1]), //from pre-stage
			.ready_i (ready_i[(i*2)+1]), //from post-stage	
			.clk (sys_clk),
			.rstn (rstn)
		);
		assign ready_i[(i*2)+0] = ready_slave;
		assign ready_i[(i*2)+1] = ready_slave;
		//assign coded_block[(i+1)*NG_SIZE*QUAN_SIZE-1:i*NG_SIZE*QUAN_SIZE] = codeword_segment_master[i];  
	end
endgenerate
assign coded_block_0 = codeword_segment_master[0];
assign coded_block_1 = codeword_segment_master[1];
assign coded_block_2 = codeword_segment_master[2];
assign coded_block_3 = codeword_segment_master[3];
assign coded_block_4 = codeword_segment_master[4];
assign coded_block_5 = codeword_segment_master[5];
assign coded_block_6 = codeword_segment_master[6];
assign coded_block_7 = codeword_segment_master[7];
assign coded_block_8 = codeword_segment_master[8];
assign coded_block_9 = codeword_segment_master[9];
endmodule

module subblock_generator_boxMuller #(
	parameter N = 765, // block length
	parameter QUAN_SIZE = 4, // 4-bit quantisation for each channel message
	parameter [63:0] RAND_SEED_0 = 64'd5030521883283424767,
    parameter [63:0] RAND_SEED_1 = 64'd18445829279364155008,
    parameter [63:0] RAND_SEED_2 = 64'd18436106298727503359,
	parameter [63:0] RAND_SEED_3 = 64'd5030521883283424767,
    parameter [63:0] RAND_SEED_4 = 64'd18445829279364155008,
    parameter [63:0] RAND_SEED_5 = 64'd18436106298727503359,
	
	// The latency (clock cycle) of producing firt symbol, 
	// equal to the pipeline depth of symbol generator 
	parameter PIPELINE_DELAY = 25
	)(
	output reg [N*QUAN_SIZE-1:0] sub_block_0,
	output reg [N*QUAN_SIZE-1:0] sub_block_1,
	output reg tvalid,
	
	input wire [15:0] sigma_in,
	//input wire [63:0] seed_offset,
	input wire ready,
	input wire rstn,
	input sys_clk
);
wire [QUAN_SIZE-1:0] ch_msg [0:1];
wire tran_cntR;
assign tran_cntR = ready & ~tvalid;
localparam pipeline_bitwidth = $clog2(PIPELINE_DELAY);
reg [pipeline_bitwidth-1:0] pipeline_cycle;
reg sampleGeneratorEnR;
initial pipeline_cycle <= 0;
always @(posedge sys_clk, negedge rstn) begin
	if(rstn == 1'b0) pipeline_cycle <= 0;
	else if(!tran_cntR) pipeline_cycle <= 0;
	else pipeline_cycle <= pipeline_cycle + 1'b1;
end 
initial sampleGeneratorEnR <=1'b 0;
always @(posedge sys_clk, negedge rstn) begin
	if(rstn == 1'b0) sampleGeneratorEnR <= 1'b0;
	else if(!tran_cntR) sampleGeneratorEnR <= 1'b0;
	else if(pipeline_cycle == PIPELINE_DELAY) sampleGeneratorEnR <= 1'b1;
end

localparam  CNT_WIDTH = $clog2(N);
reg [CNT_WIDTH-1:0] symbol_cnt;
initial symbol_cnt[CNT_WIDTH-1:0] <= 0;
always @(posedge sys_clk, negedge rstn) begin
	if(rstn == 1'b0) 
		symbol_cnt[CNT_WIDTH-1:0] <= 0;
	else if(sampleGeneratorEnR == 1'b0) 
		symbol_cnt[CNT_WIDTH-1:0] <= 0;
	else if(sampleGeneratorEnR == 1'b1)
		symbol_cnt[CNT_WIDTH-1:0] <= symbol_cnt[CNT_WIDTH-1:0] + 1'b1;
end

initial tvalid <= 1'b0;
always @(posedge sys_clk, negedge rstn) begin
	if(!rstn)
		tvalid <= 1'b0;
	else if(symbol_cnt[CNT_WIDTH-1:0] == N-1) 
		tvalid <= 1'b1; // completion timing of symbols generation
	else if(ready == 1'b0) 
		tvalid <= 1'b0; // reset valid assertion
	else 
		tvalid <= 1'b0;
end

initial sub_block_0[N*QUAN_SIZE-1:0] <= 0;
always @(posedge sys_clk, negedge rstn) begin
	if(!rstn) sub_block_0[N*QUAN_SIZE-1:0] <= 0;
	else if(sampleGeneratorEnR == 1'b1) 
		sub_block_0[N*QUAN_SIZE-1:0] <= {sub_block_0[(N-1)*QUAN_SIZE-1:0], ch_msg[0]};
end
initial sub_block_1[N*QUAN_SIZE-1:0] <= 0;
always @(posedge sys_clk, negedge rstn) begin
	if(!rstn) sub_block_1[N*QUAN_SIZE-1:0] <= 0;
	else if(sampleGeneratorEnR == 1'b1) 
		sub_block_1[N*QUAN_SIZE-1:0] <= {sub_block_1[(N-1)*QUAN_SIZE-1:0], ch_msg[1]};
end
	symbol_generator #(
	   .QUAN_SIZE   (QUAN_SIZE),
	   .RAND_SEED_0 (RAND_SEED_0[63:32]),
	   .RAND_SEED_1 (RAND_SEED_1[63:32]),
	   .RAND_SEED_2 (RAND_SEED_2[63:32]),
	   .RAND_SEED_3 (RAND_SEED_3[63:32]),
	   .RAND_SEED_4 (RAND_SEED_4[63:32]),
	   .RAND_SEED_5 (RAND_SEED_5[63:32])
	) symbol_gnerator_u0(
    .ch_msg_0 (ch_msg[0]),
    .ch_msg_1 (ch_msg[1]),

    .sigma_in (sigma_in[15:0]), // standard deviation of underlying AWGN channel
    //.coded_bit (coded_bit), // without BPSK modulation
    .sys_clk (sys_clk),
    .rstn (rstn),
    .ce (tran_cntR)
    );   
endmodule
/*================================================================================================================*/
module Handshake_Protocol #(
	parameter N = 51,
	parameter QUAN_SIZE = 4
)(
	input 	wire		 valid_i, //from pre-stage
	input   wire [N*QUAN_SIZE-1:0] data_i, //from pre-stage
	input 	wire		 ready_i, //from post-stage

	output 	wire		 ready_o,//to pre-stage
	output 	wire		 valid_o, //to post-stage
	output  wire [N*QUAN_SIZE-1:0] data_o, //to post-stage

	input wire clk,
	input wire rstn
);

	reg 	valid_o_r;
	reg [N*QUAN_SIZE-1:0] data_o_r;

    always @(posedge clk, negedge rstn) begin
		if(~rstn)
			valid_o_r <= 1'b0;
		else if(valid_i)
			valid_o_r <= 1'b1;
		else if(~valid_i)
			valid_o_r <= 1'b0;
	end

	always @(posedge clk, negedge rstn) begin
		if(~rstn)
			data_o_r[N*QUAN_SIZE-1:0] <= 0;
		else if(valid_i)
			data_o_r[N*QUAN_SIZE-1:0] <= data_i[N*QUAN_SIZE-1:0];
	end

	assign ready_o = ready_i;
	assign valid_o = valid_o_r;
	assign data_o[N*QUAN_SIZE-1:0] = data_o_r[N*QUAN_SIZE-1:0];
endmodule
