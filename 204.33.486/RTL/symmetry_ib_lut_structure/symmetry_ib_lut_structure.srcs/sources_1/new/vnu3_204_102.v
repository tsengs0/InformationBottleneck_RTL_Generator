`include "define.vh"

module vnu3_204_102 #(
	parameter QUAN_SIZE  = 4,
	parameter ENTRY_ADDR = 7, // regardless of bank interleaving here
	parameter BANK_NUM   = 2,
	parameter LUT_PORT_SIZE = 4
)(
    output wire [`VN_NUM-1:0] vnu_out,
	output wire read_addr_offset_out,
				
    input wire [QUAN_SIZE-1:0] vnu0_0,
    input wire [QUAN_SIZE-1:0] vnu0_1,
    input wire [QUAN_SIZE-1:0] vnu0_2,
	input wire [QUAN_SIZE-1:0] vnu0_ch_llr,
    input wire [QUAN_SIZE-1:0] vnu1_0,
    input wire [QUAN_SIZE-1:0] vnu1_1,
    input wire [QUAN_SIZE-1:0] vnu1_2,
	input wire [QUAN_SIZE-1:0] vnu1_ch_llr,
    input wire [QUAN_SIZE-1:0] vnu2_0,
    input wire [QUAN_SIZE-1:0] vnu2_1,
    input wire [QUAN_SIZE-1:0] vnu2_2,
	input wire [QUAN_SIZE-1:0] vnu2_ch_llr,
    input wire [QUAN_SIZE-1:0] vnu3_0,
    input wire [QUAN_SIZE-1:0] vnu3_1,
    input wire [QUAN_SIZE-1:0] vnu3_2,
	input wire [QUAN_SIZE-1:0] vnu3_ch_llr,

//==============================================================//
// Variable Node Units
	// Iteration-Update Page Address Offset
	input wire read_addr_offset,
    // Iteration-Update Page Address 
    input wire [ENTRY_ADDR-1:0] page_addr_ram_0,
	input wire [ENTRY_ADDR-1:0] page_addr_ram_1,
    // Iteration-Update Data
    input wire [LUT_PORT_SIZE*BANK_NUM-1:0] ram_write_data_0,
    input wire [LUT_PORT_SIZE*BANK_NUM-1:0] ram_write_data_1,
// Decision Node Units
	// Iteration-Update Page Address Offset
	input wire dnu_read_addr_offset,
    // Iteration-Update Page Address 
    input wire [ENTRY_ADDR-1:0] dnu_page_addr_ram,
    // Iteration-Update Data
    input wire [BANK_NUM-1:0] dnu_ram_write_data,
//==============================================================//
    // Clock source and Enable signals
    input wire CLK_300_N,
    input wire CLK_300_P,
    input wire rstn,
    input wire [`VN_DEGREE+1-2-1:0] ib_ram_we
	input wire ib_dnu_ram_we
);

wire clk_lock, read_clk, write_clk, clk_rd_gate, clk_wr_gate;
clock_domain_wrapper system_clock(
	.clk_300mhz_clk_n (CLK_300_N),
    .clk_300mhz_clk_p (CLK_300_P),
    .locked_0 (clk_lock),
    .read_clk_0 (clk_rd_gate),
    .reset (~rstn),
    .write_clk_0 (clk_wr_gate)
);
assign read_clk  = clk_rd_gate & clk_lock;
assign write_clk = clk_wr_gate & clk_lock; 

reg [3:0] vnu_cnt;
initial vnu_cnt <= 4'd0;
always @(posedge read_clk) begin
  if(vnu_cnt[3:0] == 11) vnu_cnt[3:0] <= 4'd0;
  else vnu_cnt[3:0] <= vnu_cnt[3:0]+1'b1;
end 

// Dummy instantiation just for area overhead evaluation
wire [`VNU3_INSTANTIATE_NUM-1:0] read_addr_offset_outSet;
assign read_addr_offset_out = (read_addr_offset_outSet == 0) ? 1'b0 : 1'b1;

genvar j;
generate
  for (j=0; j<`VNU3_INSTANTIATE_NUM; j=j+1) begin : vnu3_204_102_inst
    // Instantiation of F_0
    // Instantiation of F_0
    wire [`QUAN_SIZE-1:0] f0_out[0:7];
    wire [`QUAN_SIZE-1:0] vnu0_c2v [0:1]; // c2v[1] and c2v[2]
    wire [`QUAN_SIZE-1:0] vnu1_c2v [0:1]; // c2v[1] and c2v[2]
    wire [`QUAN_SIZE-1:0] vnu2_c2v [0:1]; // c2v[1] and c2v[2]
    wire [`QUAN_SIZE-1:0] vnu3_c2v [0:1]; // c2v[1] and c2v[2]	
	wire [1:0] vnu0_tranEn_out;
	wire [1:0] vnu1_tranEn_out;
	wire [1:0] vnu2_tranEn_out;
	wire [1:0] vnu3_tranEn_out;
	
	// Dummy instantiation just for area overhead evaluation
	wire [`VN_DEGREE+1-2-1-1:0] read_addr_offset_internal;
	vnu3_f0 u_f0(
		.read_addr_offset_out (read_addr_offset_internal[0]), // to forward the current multi-frame offset signal to the next sub-datapath	
		// For the first VNU
		.vnu0_tPort0 (f0_out[0]  ), // internal signals accounting for each 128-entry partial LUT's output
		.vnu0_tPort1 (f0_out[1]  ), // internal signals accounting for each 128-entry partial LUT's output
		.vnu0_c2v1   (vnu0_c2v[0]),
		.vnu0_c2v2   (vnu0_c2v[1]),
		// For the second VNU       
		.vnu1_tPort0 (f0_out[2]  ), // internal signals accounting for each 128-entry partial LUT's output
		.vnu1_tPort1 (f0_out[3]  ), // internal signals accounting for each 128-entry partial LUT's output
		.vnu1_c2v1   (vnu1_c2v[0]),
		.vnu1_c2v2   (vnu1_c2v[1]),
		// For the third VNU        
		.vnu2_tPort0 (f0_out[4]  ), // internal signals accounting for each 128-entry partial LUT's output
		.vnu2_tPort1 (f0_out[5]  ), // internal signals accounting for each 128-entry partial LUT's output
		.vnu2_c2v1   (vnu2_c2v[0]),
		.vnu2_c2v2   (vnu2_c2v[1]),
		// For the fourth VNU       
		.vnu3_tPort0 (f0_out[6]  ), // internal signals accounting for each 128-entry partial LUT's output
		.vnu3_tPort1 (f0_out[7]  ), // internal signals accounting for each 128-entry partial LUT's output	
		.vnu3_c2v1   (vnu3_c2v[0]),
		.vnu3_c2v2   (vnu3_c2v[1]),
		// For first to fourth VNUs (output port)
		.vnu0_tranEn_out0 (vnu0_tranEn_out[0]),
		.vnu0_tranEn_out1 (vnu0_tranEn_out[1]),
		.vnu1_tranEn_out0 (vnu1_tranEn_out[0]),
		.vnu1_tranEn_out1 (vnu1_tranEn_out[1]),
		.vnu2_tranEn_out0 (vnu2_tranEn_out[0]),
		.vnu2_tranEn_out1 (vnu2_tranEn_out[1]),
		.vnu3_tranEn_out0 (vnu3_tranEn_out[0]),
		.vnu3_tranEn_out1 (vnu3_tranEn_out[1]),
		
		// From the first VNU
		.vnu0_c2v_0  (vnu0_0[QUAN_SIZE-1:0]    ),
		.vnu0_c2v_1  (vnu0_1[QUAN_SIZE-1:0]    ),
		.vnu0_c2v_2  (vnu0_2[QUAN_SIZE-1:0]    ),
		.vnu0_ch_llr (vnu0_ch_llr[QUAN_SIZE-1:0]),
	
		// From the second VNU
		.vnu1_c2v_0  (vnu1_0[QUAN_SIZE-1:0]    ),
		.vnu1_c2v_1  (vnu1_1[QUAN_SIZE-1:0]    ),
		.vnu1_c2v_2  (vnu1_2[QUAN_SIZE-1:0]    ),
		.vnu1_ch_llr (vnu1_ch_llr[QUAN_SIZE-1:0]),
	
		// From the third VNU
		.vnu2_c2v_0  (vnu2_0[QUAN_SIZE-1:0]    ),
		.vnu2_c2v_1  (vnu2_1[QUAN_SIZE-1:0]    ),
		.vnu2_c2v_2  (vnu2_2[QUAN_SIZE-1:0]    ),
		.vnu2_ch_llr (vnu2_ch_llr[QUAN_SIZE-1:0]),
	
		// From the fourth VNU
		.vnu3_c2v_0  (vnu3_0[QUAN_SIZE-1:0]    ),
		.vnu3_c2v_1  (vnu3_1[QUAN_SIZE-1:0]    ),
		.vnu3_c2v_2  (vnu3_2[QUAN_SIZE-1:0]    ),
		.vnu3_ch_llr (vnu3_ch_llr[QUAN_SIZE-1:0]),
		
		.read_clk (read_clk),
		.read_addr_offset (read_addr_offset), // offset determing the switch between multi-frame
		
		// Iteration-Update Page Address 
		.page_addr_ram (page_addr_ram_0[ENTRY_ADDR-1:0]),
		// Ieration-Update Data
		.ram_write_data_0 (ram_write_data_0[LUT_PORT_SIZE*BANK_NUM-1:0]),
	
		.write_clk (write_clk),
		.ib_ram_we (ib_ram_we[0])
	);

    // Instantiation of F_1
	wire [`QUAN_SIZE-1:0] vnu0_v2c[0:2];
	wire [`QUAN_SIZE-1:0] vnu1_v2c[0:2];
	wire [`QUAN_SIZE-1:0] vnu2_v2c[0:2];
	wire [`QUAN_SIZE-1:0] vnu3_v2c[0:2];
	vnu3_f1 u_f1(
		.read_addr_offset_out (read_addr_offset_outSet[j]), // to forward the current multi-frame offset signal to the next sub-datapath	
		// For the first VNU
		.vnu0_v2c0 (vnu0_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
		.vnu0_v2c1 (vnu0_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
		.vnu0_v2c2 (vnu0_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
		// For the second VNU       
		.vnu1_v2c0 (vnu1_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
		.vnu1_v2c1 (vnu1_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
		.vnu1_v2c2 (vnu1_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
		// For the third VNU        
		.vnu2_v2c0 (vnu2_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
		.vnu2_v2c1 (vnu2_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
		.vnu2_v2c2 (vnu2_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
		// For the fourth VNU       
		.vnu3_v2c0 (vnu3_v2c[0]), // internal signals accounting for each 128-entry partial LUT's output
		.vnu3_v2c1 (vnu3_v2c[1]), // internal signals accounting for each 128-entry partial LUT's output
		.vnu3_v2c2 (vnu3_v2c[2]), // internal signals accounting for each 128-entry partial LUT's output
			
		// From the first VNU
		.vnu0_t00   (f0_out[0]  ),
		.vnu0_t01   (f0_out[1]  ),
		.vnu0_c2v_1 (vnu0_c2v[0]),
		.vnu0_c2v_2 (vnu0_c2v[1]),
		.vnu0_tranEn_in0 (vnu0_tranEn_out[0]),
		.vnu0_tranEn_in1 (vnu0_tranEn_out[1]),
	
		// From the second VNU
		.vnu1_t00   (f0_out[2]  ),
		.vnu1_t01   (f0_out[3]  ),
		.vnu1_c2v_1 (vnu1_c2v[0]),
		.vnu1_c2v_2 (vnu1_c2v[1]), 
		.vnu1_tranEn_in0 (vnu1_tranEn_out[0]),
		.vnu1_tranEn_in1 (vnu1_tranEn_out[1]),	
	
		// From the third VNU
		.vnu2_t00   (f0_out[4]  ),
		.vnu2_t01   (f0_out[5]  ),
		.vnu2_c2v_1 (vnu2_c2v[0]),
		.vnu2_c2v_2 (vnu2_c2v[1]),
		.vnu2_tranEn_in0 (vnu2_tranEn_out[0]),
		.vnu2_tranEn_in1 (vnu2_tranEn_out[1]),
	
		// From the fourth VNU
		.vnu3_t00   (f0_out[6]  ),
		.vnu3_t01   (f0_out[7]  ),
		.vnu3_c2v_1 (vnu3_c2v[0]),
		.vnu3_c2v_2 (vnu3_c2v[1]),
		.vnu3_tranEn_in0 (vnu3_tranEn_out[0]),
		.vnu3_tranEn_in1 (vnu3_tranEn_out[1]),
		
		.read_clk (read_clk),
		.read_addr_offset (read_addr_offset_internal[0]), // offset determing the switch between multi-frame
		
		// Iteration-Update Page Address 
		.page_addr_ram (page_addr_ram_1[ENTRY_ADDR-1:0]),
		// Ieration-Update Data
		.ram_write_data_1 (ram_write_data_1[LUT_PORT_SIZE*BANK_NUM-1:0]),
	
		.write_clk (write_clk),
		.ib_ram_we (ib_ram_we[1])
	);	
	
	dnu_f0 u_f2(
		output wire read_addr_offset_out, // to forward the current multi-frame offset signal to the next sub-datapath	
		output wire dnu0_hard_decision, // internal signals accounting for each 128-entry partial LUT's output
		output wire dnu1_hard_decision, // internal signals accounting for each 128-entry partial LUT's output		        
		output wire dnu2_hard_decision, // internal signals accounting for each 128-entry partial LUT's output
		output wire dnu3_hard_decision, // internal signals accounting for each 128-entry partial LUT's output
		
		// From the first DNU
		input wire [QUAN_SIZE-1:0] vnu0_t10,
		input wire [QUAN_SIZE-1:0] vnu0_c2v_2,
		input wire vnu0_tranEn_in0,
	
		// From the second DNU
		input wire [QUAN_SIZE-1:0] vnu1_t10,
		input wire [QUAN_SIZE-1:0] vnu1_c2v_2,
		input wire vnu1_tranEn_in0,
		
		// From the third DNU
		input wire [QUAN_SIZE-1:0] vnu2_t10,
		input wire [QUAN_SIZE-1:0] vnu2_c2v_2,
		input wire vnu2_tranEn_in0,
		
		// From the fourth DNU
		input wire [QUAN_SIZE-1:0] vnu3_t10,
		input wire [QUAN_SIZE-1:0] vnu3_c2v_2,
		input wire vnu3_tranEn_in0,
		
		.read_clk (read_clk),
		.read_addr_offset (read_addr_offset_outSet[j]), // offset determing the switch between multi-frame 
		.page_addr_ram (dnu_page_addr_ram),
		.ram_write_data_1 (dnu_ram_write_data[BANK_NUM-1:0]),
		.write_clk (write_clk),
		.ib_ram_we (ib_dnu_ram_we)
	);

    reg [`QUAN_SIZE*`VN_DEGREE-1:0] vnu0_v2c_fifo;
    initial vnu0_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:0] <= {vnu0_v2c[0], vnu0_v2c[1], vnu0_v2c[2]};
    always @(posedge read_clk) begin
        if(vnu_cnt[3:0] == 11)
            vnu0_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:0] <= {vnu0_v2c[0], vnu0_v2c[1], vnu0_v2c[2]};
        else
            vnu0_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:0] <= {vnu0_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-2:0], 1'b0};
    end
	hulfDuplex_parallel2serial vnu0_c2v_p2s (
		.serial_inout (vnu_out[j*`VNU3_INSTANTIATE_UNIT]),
		//output wire [MSG_WIDTH-1:0] parallel_out,
		
		.parallel_in (vnu0_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:`QUAN_SIZE*`VN_DEGREE-4]),
		.load (read_addr_offset_out),
		.parallel_en (1'b0),
		.sys_clk (read_clk)
    );
    reg [`QUAN_SIZE*`VN_DEGREE-1:0] vnu1_v2c_fifo;
    initial vnu1_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:0] <= {vnu1_v2c[0], vnu1_v2c[1], vnu1_v2c[2]};
    always @(posedge read_clk) begin
        if(vnu_cnt[3:0] == 11)
            vnu1_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:0] <= {vnu1_v2c[0], vnu1_v2c[1], vnu1_v2c[2]};
        else
            vnu1_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:0] <= {vnu1_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-2:0], 1'b0};
    end
	hulfDuplex_parallel2serial vnu1_c2v_p2s (
		.serial_inout (vnu_out[j*`VNU3_INSTANTIATE_UNIT+1]),
		//output wire [MSG_WIDTH-1:0] parallel_out,
		
		.parallel_in (vnu1_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:`QUAN_SIZE*`VN_DEGREE-4]),
		.load (read_addr_offset_out),
		.parallel_en (1'b0),
		.sys_clk (read_clk)
    );
    reg [`QUAN_SIZE*`VN_DEGREE-1:0] vnu2_v2c_fifo;
    initial vnu2_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:0] <= {vnu2_v2c[0], vnu2_v2c[1], vnu2_v2c[2]};
    always @(posedge read_clk) begin
        if(vnu_cnt[3:0] == 11)
            vnu2_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:0] <= {vnu2_v2c[0], vnu2_v2c[1], vnu2_v2c[2]};
        else
            vnu2_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:0] <= {vnu2_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-2:0], 1'b0};
    end
	hulfDuplex_parallel2serial vnu2_c2v_p2s (
		.serial_inout (vnu_out[j*`VNU3_INSTANTIATE_UNIT+2]),
		//output wire [MSG_WIDTH-1:0] parallel_out,
		
		.parallel_in (vnu2_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:`QUAN_SIZE*`VN_DEGREE-4]),
		.load (read_addr_offset_out),
		.parallel_en (1'b0),
		.sys_clk (read_clk)
    );
    reg [`QUAN_SIZE*`VN_DEGREE-1:0] vnu3_v2c_fifo;
    initial vnu3_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:0] <= {vnu3_v2c[0], vnu3_v2c[1], vnu3_v2c[2]};
    always @(posedge read_clk) begin
        if(vnu_cnt[3:0] == 11)
            vnu3_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:0] <= {vnu3_v2c[0], vnu3_v2c[1], vnu3_v2c[2]};
        else
            vnu3_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:0] <= {vnu3_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-2:0], 1'b0};
    end
	hulfDuplex_parallel2serial vnu3_c2v_p2s (
		.serial_inout (vnu_out[j*`VNU3_INSTANTIATE_UNIT+3]),
		//output wire [MSG_WIDTH-1:0] parallel_out,
		
		.parallel_in (vnu3_v2c_fifo[`QUAN_SIZE*`VN_DEGREE-1:`QUAN_SIZE*`VN_DEGREE-4]),
		.load (read_addr_offset_out),
		.parallel_en (1'b0),
		.sys_clk (read_clk)
    );
  end
endgenerate
endmodule