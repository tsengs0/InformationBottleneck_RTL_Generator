
`timescale 1 ns / 1 ps

	module axis_pl2ps_fifo_v1_0 #
	(
		// Users to add parameters here
		
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S_AXIS
		parameter integer C_S_AXIS_TDATA_WIDTH	= 32,

		// Parameters of Axi Master Bus Interface M_AXIS
		parameter integer C_M_AXIS_TDATA_WIDTH	= 32,
		parameter integer C_M_AXIS_START_COUNT	= 32
	)
	(
		// Users to add ports here
		input wire [7:0] FrameSize,
		input wire	 En,
		input wire 	 AXI_En, // 1: Slave; 0: Master
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S_AXIS
		input wire  s_axis_aclk,
		input wire  s_axis_aresetn,
		output wire  s_axis_tready,
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] s_axis_tdata,
		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] s_axis_tstrb,
		input wire  s_axis_tlast,
		input wire  s_axis_tvalid,

		// Ports of Axi Master Bus Interface M_AXIS
		input wire  m_axis_aclk,
		input wire  m_axis_aresetn,
		output wire  m_axis_tvalid,
		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] m_axis_tdata,
		output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] m_axis_tstrb,
		output wire  m_axis_tlast,
		input wire  m_axis_tready,
		
		input wire [C_M_AXIS_TDATA_WIDTH-1:0] result_fifo_in,
		input wire result_fifo_we,
		input wire pl_fifo_wr_clk
	);

	wire  m_axis_tvalidW;
	wire [C_M_AXIS_TDATA_WIDTH-1 : 0] m_axis_tdataW;
	wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] m_axis_tstrbW;
	wire  m_axis_tlastW;

// Instantiation of Axi Bus Interface S_AXIS
/*
	axis_pl2ps_fifo_v1_0_S_AXIS #(
		.C_S_AXIS_TDATA_WIDTH(C_S_AXIS_TDATA_WIDTH)
	) pl_to_ps_fifo_v1_0_S_AXIS_inst (
		.En (En),
		.S_AXIS_ACLK(s_axis_aclk),
		.S_AXIS_ARESETN(s_axis_aresetn),
		.S_AXIS_TREADY(s_axis_tready),
		.S_AXIS_TDATA(s_axis_tdata),
		.S_AXIS_TSTRB(s_axis_tstrb),
		.S_AXIS_TLAST(s_axis_tlast),
		.S_AXIS_TVALID(s_axis_tvalid)
	);
*/

// Instantiation of Axi Bus Interface M_AXIS
	axis_pl2ps_fifo_v1_0_M_AXIS #(
		.C_M_AXIS_TDATA_WIDTH(C_M_AXIS_TDATA_WIDTH),
		.C_M_START_COUNT(C_M_AXIS_START_COUNT)
	) pl_to_ps_fifo_v1_0_M_AXIS_inst (
		.FrameSize (FrameSize[7:0]),
		.En (En),
		.M_AXIS_ACLK(m_axis_aclk),
		.M_AXIS_ARESETN(m_axis_aresetn),
		.M_AXIS_TVALID(m_axis_tvalidW),
		.M_AXIS_TDATA(m_axis_tdataW),
		.M_AXIS_TSTRB(m_axis_tstrbW),
		.M_AXIS_TLAST(m_axis_tlastW),
		.M_AXIS_TREADY(m_axis_tready),
	   
	    .result_fifo_in (result_fifo_in[C_M_AXIS_TDATA_WIDTH-1:0] ),
		.result_fifo_we (result_fifo_we),
		.pl_fifo_wr_clk (pl_fifo_wr_clk)
	);

	// Add user logic here
	assign m_axis_tdata[C_M_AXIS_TDATA_WIDTH-1 : 0] = (AXI_En == 1'b1)? s_axis_tdata : m_axis_tdataW; 
	assign m_axis_tstrb = (AXI_En)? s_axis_tstrb : m_axis_tstrbW;
	assign m_axis_tlast = (AXI_En)? s_axis_tlast : m_axis_tlastW;
	assign m_axis_tvalid = (AXI_En)? s_axis_tvalid : m_axis_tvalidW;

	assign s_axis_tready = m_axis_tready;

	// User logic ends

	endmodule