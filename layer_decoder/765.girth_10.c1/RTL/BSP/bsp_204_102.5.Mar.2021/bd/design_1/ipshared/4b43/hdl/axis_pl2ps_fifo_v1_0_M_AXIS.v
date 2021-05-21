
`timescale 1 ns / 1 ps

	module axis_pl2ps_fifo_v1_0_M_AXIS #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 32,
		// Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
		parameter integer C_M_START_COUNT	= 32
	)
	(
		// Users to add ports here
		input wire [7:0] FrameSize,
		input wire 	 En,
		// User ports ends
		// Do not modify the ports beyond this line

		// Global ports
		input wire  M_AXIS_ACLK,
		// 
		input wire  M_AXIS_ARESETN,
		// Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		output wire  M_AXIS_TVALID,
		// TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
		// TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
		output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB,
		// TLAST indicates the boundary of a packet.
		output wire  M_AXIS_TLAST,
		// TREADY indicates that the slave can accept a transfer in the current cycle.
		input wire  M_AXIS_TREADY,
		
		input wire [C_M_AXIS_TDATA_WIDTH-1:0] result_fifo_in,
		input wire result_fifo_we,
		input wire pl_fifo_wr_clk
	);

 reg sampleGeneratorEnR;
 reg [7:0] reset_cycle;

 wire [C_M_AXIS_TDATA_WIDTH-1:0] result_fifo_out;
 wire result_fifo_empty, read_valid, result_fifo_re;
 /*
 fifo_generator_0 result_fifo_u0 (
    // Output data port
    .dout (result_fifo_out[C_M_AXIS_TDATA_WIDTH-1:0]),
    // Output status port
    .valid (read_valid),
    .empty (result_fifo_empty),
    //.FIFO_WRITE_0_full (buffer_full),
    //.rd_rst_busy (rd_locked_set),
    //.wr_rst_busy (wr_locked_set),
    //.full(),
    
     // Input data port
    .din (result_fifo_in[C_M_AXIS_TDATA_WIDTH-1:0]),
    // Input control port
    .rd_en  (result_fifo_re),
    .wr_en (result_fifo_we),
    .srst (~M_AXIS_ARESETN),
    .rd_clk (M_AXIS_ACLK),
    .wr_clk (pl_fifo_wr_clk)
 );
 */
  result_fifo_wrapper result_fifo_u0 (
    // Output data port
    .FIFO_READ_0_rd_data (result_fifo_out[C_M_AXIS_TDATA_WIDTH-1:0]),
    // Output status port
    .valid_0 (read_valid),
    .FIFO_READ_0_empty (result_fifo_empty),
    //.FIFO_WRITE_0_full (buffer_full),
    //.rd_rst_busy_0 (rd_locked_set),
    //.wr_rst_busy_0 (wr_locked_set),
    
     // Input data port
    .FIFO_WRITE_0_wr_data (result_fifo_in[C_M_AXIS_TDATA_WIDTH-1:0]),
    // Input control port
    .FIFO_READ_0_rd_en  (result_fifo_re),
    .FIFO_WRITE_0_wr_en (result_fifo_we),
    .srst_0 (~M_AXIS_ARESETN),
    .rd_clk_0 (M_AXIS_ACLK),
    .wr_clk_0 (pl_fifo_wr_clk)
 );
assign result_fifo_re = (sampleGeneratorEnR & M_AXIS_TREADY); // C_M_START_COUNT clock cycles after M_AXIS_ARESETN is activated @ M_AXIS_ACLK
                                                            // and REDEAY is asserted by Master, i.e., Zynq PS

assign M_AXIS_TDATA = result_fifo_out[C_M_AXIS_TDATA_WIDTH-1:0];
assign M_AXIS_TSTRB = {(C_M_AXIS_TDATA_WIDTH/8){1'b1}};

always @(posedge M_AXIS_ACLK) begin
	if(!M_AXIS_ARESETN) 
		reset_cycle <= 0;
	else 
		reset_cycle <= reset_cycle+1;
end
always @(posedge M_AXIS_ACLK) begin
	if(!M_AXIS_ARESETN) 
		sampleGeneratorEnR <= 0;
	else if(reset_cycle == C_M_START_COUNT)
		sampleGeneratorEnR <= 1;
end

// M_AXIS_TVALID circuit
reg	tValidR;
assign M_AXIS_TVALID = tValidR;
always @(posedge M_AXIS_ACLK) begin
	if(!M_AXIS_ARESETN) 
		tValidR <= 0;
	else begin
		if(!En) tValidR <= 0;
		else if(sampleGeneratorEnR && read_valid && !result_fifo_empty) tValidR <= 1;
	end	
end

// M_AXIS_TLAST circuit
reg [7:0] packetCounter;
always @(posedge M_AXIS_ACLK) begin
	if(!M_AXIS_ARESETN)
		packetCounter <= 8'hff;
	else begin
		if(M_AXIS_TVALID && M_AXIS_TREADY) begin
			if(packetCounter == (FrameSize-1))
				packetCounter <= 8'hff;
			else
				packetCounter <= packetCounter+1;
		end
	end
end
assign M_AXIS_TLAST = (packetCounter[7:0] == (FrameSize-1))? 1 : 0;
endmodule