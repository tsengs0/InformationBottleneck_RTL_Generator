`include "define.vh"

module cnu6_204_102 (
    output wire [`CN_NUM-1:0] cnu_out,
	output wire read_addr_offset_out,
				
    input wire [`QUAN_SIZE-1:0] cnu0_0,
    input wire [`QUAN_SIZE-1:0] cnu0_1,
    input wire [`QUAN_SIZE-1:0] cnu0_2,
    input wire [`QUAN_SIZE-1:0] cnu0_3,
    input wire [`QUAN_SIZE-1:0] cnu0_4,
    input wire [`QUAN_SIZE-1:0] cnu0_5,
    input wire [`QUAN_SIZE-1:0] cnu1_0,
    input wire [`QUAN_SIZE-1:0] cnu1_1,
    input wire [`QUAN_SIZE-1:0] cnu1_2,
    input wire [`QUAN_SIZE-1:0] cnu1_3,
    input wire [`QUAN_SIZE-1:0] cnu1_4,
    input wire [`QUAN_SIZE-1:0] cnu1_5, 
	input wire read_addr_offset,
    // Iteration-Update Page Address 
    input wire [`IB_ROM_ADDR_WIDTH-1:0] page_addr_ram,
    // Iteration-Update Data
    input wire [`IB_ROM_SIZE-1:0] ram_write_data_0,
    input wire [`IB_ROM_SIZE-1:0] ram_write_data_1,
    input wire [`IB_ROM_SIZE-1:0] ram_write_data_2,
    input wire [`IB_ROM_SIZE-1:0] ram_write_data_3,
    // Clock source and Enable signals
    input wire CLK_300_N,
    input wire CLK_300_P,
    input wire rstn,
    input wire [`CN_DEGREE-2-1:0] ib_ram_we
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

reg [4:0] cnu_cnt;
initial cnu_cnt <= 5'd0;
always @(posedge read_clk) begin
  if(cnu_cnt[4:0] == 23) cnu_cnt[4:0] <= 5'd0;
  else cnu_cnt[4:0] <= cnu_cnt[4:0]+1'b1;
end 

// Dummy instantiation just for area overhead evaluation
wire [`CNU6_INSTANTIATE_NUM-1:0] read_addr_offset_outSet;
assign read_addr_offset_out = (read_addr_offset_outSet == 0) ? 1'b0 : 1'b1;

genvar j;
generate
  for (j=0; j<`CNU6_INSTANTIATE_NUM; j=j+1) begin : cnu6_204_102_inst
    // Instantiation of F_0
    wire [`QUAN_SIZE-1:0] f0_out[0:3];
    wire [`QUAN_SIZE-1:0] cnu0_f0_M_reg [0:`CN_DEGREE-1];
    wire [`QUAN_SIZE-1:0] cnu1_f0_M_reg [0:`CN_DEGREE-1];

	// Dummy instantiation just for area overhead evaluation
	wire [`CN_DEGREE-2-1-1:0] read_addr_offset_internal;
    cnu6_f0 u_f0(
		.read_addr_offset_out (read_addr_offset_internal[0]), // to forward the current multi-frame offset signal to the next sub-datapath
        // For the first CNU
        .t_portA (f0_out[0]), // internal signals accounting for each 256-entry partial LUT's output
        .t_portB (f0_out[1]), // internal signals accounting for each 256-entry partial LUT's output
        // For the second CNU
        .t_portC (f0_out[2]), // internal signals accounting for each 256-entry partial LUT's output
        .t_portD (f0_out[3]), // internal signals accounting for each 256-entry partial LUT's output
        // For the first CNU
        .cnu0_M_reg0 (cnu0_f0_M_reg[0]),
        .cnu0_M_reg1 (cnu0_f0_M_reg[1]),
        .cnu0_M_reg2 (cnu0_f0_M_reg[2]),
        .cnu0_M_reg3 (cnu0_f0_M_reg[3]),
        .cnu0_M_reg4 (cnu0_f0_M_reg[4]),
        .cnu0_M_reg5 (cnu0_f0_M_reg[5]),
        // For the second CNU
        .cnu1_M_reg0 (cnu1_f0_M_reg[0]),
        .cnu1_M_reg1 (cnu1_f0_M_reg[1]),
        .cnu1_M_reg2 (cnu1_f0_M_reg[2]),
        .cnu1_M_reg3 (cnu1_f0_M_reg[3]),
        .cnu1_M_reg4 (cnu1_f0_M_reg[4]),
        .cnu1_M_reg5 (cnu1_f0_M_reg[5]),

        // From the first CNU
        .cnu0_v2c_0 (cnu0_0[`QUAN_SIZE-1:0]),
        .cnu0_v2c_1 (cnu0_1[`QUAN_SIZE-1:0]),
        .cnu0_v2c_2 (cnu0_2[`QUAN_SIZE-1:0]),
        .cnu0_v2c_3 (cnu0_3[`QUAN_SIZE-1:0]),
        .cnu0_v2c_4 (cnu0_4[`QUAN_SIZE-1:0]),
        .cnu0_v2c_5 (cnu0_5[`QUAN_SIZE-1:0]),
        // From the second CNU
        .cnu1_v2c_0 (cnu1_0[`QUAN_SIZE-1:0]),
        .cnu1_v2c_1 (cnu1_1[`QUAN_SIZE-1:0]),
        .cnu1_v2c_2 (cnu1_2[`QUAN_SIZE-1:0]),
        .cnu1_v2c_3 (cnu1_3[`QUAN_SIZE-1:0]),
        .cnu1_v2c_4 (cnu1_4[`QUAN_SIZE-1:0]),
        .cnu1_v2c_5 (cnu1_5[`QUAN_SIZE-1:0]),

		.read_clk (read_clk),
        .read_addr_offset (read_addr_offset), // offset determing the switch between multi-frame under the following sub-datapath
      
		// Iteration-Update Page Address 
        .page_addr_ram (page_addr_ram[`IB_ROM_ADDR_WIDTH-1:0]),
        // Iteration-Update Data
        .ram_write_data_0 (ram_write_data_0[`IB_ROM_SIZE-1:0]),

        .write_clk (write_clk),
        .ib_ram_we (ib_ram_we[0])
    );
    // Instantiation of F_1
    wire [`QUAN_SIZE-1:0] f1_out[0:3];
    wire [`QUAN_SIZE-1:0] cnu0_f1_M_reg [0:`CN_DEGREE-1];
    wire [`QUAN_SIZE-1:0] cnu1_f1_M_reg [0:`CN_DEGREE-1];
    cnu6_f1 u_f1(
		.read_addr_offset_out (read_addr_offset_internal[1]), // to forward the current multi-frame offset signal to the next sub-datapath
        // For the first CNU
        .t_portA (f1_out[0]), // internal signals accounting for each 256-entry partial LUT's output
        .t_portB (f1_out[1]), // internal signals accounting for each 256-entry partial LUT's output
        // For the second CNU
        .t_portC (f1_out[2]), // internal signals accounting for each 256-entry partial LUT's output
        .t_portD (f1_out[3]), // internal signals accounting for each 256-entry partial LUT's output
        // For the first CNU
        .cnu0_M_reg0 (cnu0_f1_M_reg[0]),
        .cnu0_M_reg1 (cnu0_f1_M_reg[1]),
        .cnu0_M_reg2 (cnu0_f1_M_reg[2]),
        .cnu0_M_reg3 (cnu0_f1_M_reg[3]),
        .cnu0_M_reg4 (cnu0_f1_M_reg[4]),
        .cnu0_M_reg5 (cnu0_f1_M_reg[5]),
        // For the second CNU
        .cnu1_M_reg0 (cnu1_f1_M_reg[0]),
        .cnu1_M_reg1 (cnu1_f1_M_reg[1]),
        .cnu1_M_reg2 (cnu1_f1_M_reg[2]),
        .cnu1_M_reg3 (cnu1_f1_M_reg[3]),
        .cnu1_M_reg4 (cnu1_f1_M_reg[4]),
        .cnu1_M_reg5 (cnu1_f1_M_reg[5]),

        // From the first CNU
        .t_00 (f0_out[0]),
        .t_01 (f0_out[1]),
        .cnu0_v2c_0 (cnu0_f0_M_reg[0]),
        .cnu0_v2c_1 (cnu0_f0_M_reg[1]),
        .cnu0_v2c_2 (cnu0_f0_M_reg[2]),
        .cnu0_v2c_3 (cnu0_f0_M_reg[3]),
        .cnu0_v2c_4 (cnu0_f0_M_reg[4]),
        .cnu0_v2c_5 (cnu0_f0_M_reg[5]),
        // From the second CNU
        .t_02 (f0_out[2]),
        .t_03 (f0_out[3]),
        .cnu1_v2c_0 (cnu1_f0_M_reg[0]),
        .cnu1_v2c_1 (cnu1_f0_M_reg[1]),
        .cnu1_v2c_2 (cnu1_f0_M_reg[2]),
        .cnu1_v2c_3 (cnu1_f0_M_reg[3]),
        .cnu1_v2c_4 (cnu1_f0_M_reg[4]),
        .cnu1_v2c_5 (cnu1_f0_M_reg[5]),

		.read_clk (read_clk),
        .read_addr_offset (read_addr_offset_internal[0]), // offset determing the switch between multi-frame under the following sub-datapath

        // Iteration-Update Page Address 
        .page_addr_ram (page_addr_ram[`IB_ROM_ADDR_WIDTH-1:0]),
        // Iteration-Update Data
        .ram_write_data_1 (ram_write_data_1[`IB_ROM_SIZE-1:0]),

        .write_clk (write_clk),
        .ib_ram_we (ib_ram_we[1])
    );
    // Instantiation of F_2
    wire [`QUAN_SIZE-1:0] cnu0_f2_out[0:3];
    wire [`QUAN_SIZE-1:0] cnu1_f2_out[0:3];
    wire [`QUAN_SIZE-1:0] cnu0_f2_M_reg [0:3];
    wire [`QUAN_SIZE-1:0] cnu1_f2_M_reg [0:3];
    cnu6_f2 u_f2(
		.read_addr_offset_out (read_addr_offset_internal[2]), // to forward the current multi-frame offset signal to the next sub-datapath
        // For the first CNU
        .cnu0_t_portA (cnu0_f2_out[0]), // internal signals accounting for each 256-entry partial LUT's output
        .cnu0_t_portB (cnu0_f2_out[1]), // internal signals accounting for each 256-entry partial LUT's output
        .cnu0_t_portC (cnu0_f2_out[2]), // internal signals accounting for each 256-entry partial LUT's output
        .cnu0_t_portD (cnu0_f2_out[3]), // internal signals accounting for each 256-entry partial LUT's output
        // For the second CNU
        .cnu1_t_portA (cnu1_f2_out[0]), // internal signals accounting for each 256-entry partial LUT's output
        .cnu1_t_portB (cnu1_f2_out[1]), // internal signals accounting for each 256-entry partial LUT's output
        .cnu1_t_portC (cnu1_f2_out[2]), // internal signals accounting for each 256-entry partial LUT's output
        .cnu1_t_portD (cnu1_f2_out[3]), // internal signals accounting for each 256-entry partial LUT's output
        // For the first CNU
        .cnu0_M_reg1 (cnu0_f2_M_reg[0]),
        .cnu0_M_reg2 (cnu0_f2_M_reg[1]),
        .cnu0_M_reg4 (cnu0_f2_M_reg[2]),
        .cnu0_M_reg5 (cnu0_f2_M_reg[3]),
        // For the second CNU
        .cnu1_M_reg1 (cnu1_f2_M_reg[0]),
        .cnu1_M_reg2 (cnu1_f2_M_reg[1]),
        .cnu1_M_reg4 (cnu1_f2_M_reg[2]),
        .cnu1_M_reg5 (cnu1_f2_M_reg[3]),

		.read_clk (read_clk),
        .read_addr_offset (read_addr_offset_internal[1]), // offset determing the switch between multi-frame under the following sub-datapath

        // From the first CNU
        .t_10 (f1_out[0]),
        .t_11 (f1_out[1]),
        .cnu0_v2c_0 (cnu0_f1_M_reg[0]),
        .cnu0_v2c_1 (cnu0_f1_M_reg[1]),
        .cnu0_v2c_2 (cnu0_f1_M_reg[2]),
        .cnu0_v2c_3 (cnu0_f1_M_reg[3]),
        .cnu0_v2c_4 (cnu0_f1_M_reg[4]),
        .cnu0_v2c_5 (cnu0_f1_M_reg[5]),
        // From the second CNU
        .t_12 (f1_out[1]),
        .t_13 (f1_out[2]),
        .cnu1_v2c_0 (cnu1_f1_M_reg[0]),
        .cnu1_v2c_1 (cnu1_f1_M_reg[1]),
        .cnu1_v2c_2 (cnu1_f1_M_reg[2]),
        .cnu1_v2c_3 (cnu1_f1_M_reg[3]),
        .cnu1_v2c_4 (cnu1_f1_M_reg[4]),
        .cnu1_v2c_5 (cnu1_f1_M_reg[5]),

        // Iteration-Update Page Address 
        .page_addr_ram (page_addr_ram[`IB_ROM_ADDR_WIDTH-1:0]),
        // Iteration-Update Data
        .ram_write_data_2 (ram_write_data_2[`IB_ROM_SIZE-1:0]),

        .write_clk (write_clk),
        .ib_ram_we (ib_ram_we[2])
    );
    // Instantiation of F_3
    wire [`QUAN_SIZE-1:0] cnu0_c2v [0:`CN_DEGREE-1];
    wire [`QUAN_SIZE-1:0] cnu1_c2v [0:`CN_DEGREE-1];
    cnu6_f3 u_f3(
		.read_addr_offset_out (read_addr_offset_outSet[j]), // to forward the current multi-frame offset signal to the next sub-datapath
        // For the first CNU
        .cnu0_c2v_0 (cnu0_c2v[0]), 
        .cnu0_c2v_1 (cnu0_c2v[1]), 
        .cnu0_c2v_2 (cnu0_c2v[2]), 
        .cnu0_c2v_3 (cnu0_c2v[3]),
        .cnu0_c2v_4 (cnu0_c2v[4]),
        .cnu0_c2v_5 (cnu0_c2v[5]), 
        // For the second CNU
        .cnu1_c2v_0 (cnu1_c2v[0]), 
        .cnu1_c2v_1 (cnu1_c2v[1]), 
        .cnu1_c2v_2 (cnu1_c2v[2]), 
        .cnu1_c2v_3 (cnu1_c2v[3]),
        .cnu1_c2v_4 (cnu1_c2v[4]),
        .cnu1_c2v_5 (cnu1_c2v[5]),

        // From the first CNU
        .cnu0_t_20 (cnu0_f2_out[0]),
        .cnu0_t_21 (cnu0_f2_out[1]),
        .cnu0_t_22 (cnu0_f2_out[2]),
        .cnu0_t_23 (cnu0_f2_out[3]),
        .cnu0_v2c_1 (cnu0_f2_M_reg[0]),
        .cnu0_v2c_2 (cnu0_f2_M_reg[1]),
        .cnu0_v2c_4 (cnu0_f2_M_reg[2]),
        .cnu0_v2c_5 (cnu0_f2_M_reg[3]),
        // From the second CNU
        .cnu1_t_20 (cnu1_f2_out[0]),
        .cnu1_t_21 (cnu1_f2_out[1]),
        .cnu1_t_22 (cnu1_f2_out[2]),
        .cnu1_t_23 (cnu1_f2_out[3]),
        .cnu1_v2c_1 (cnu1_f2_M_reg[0]),
        .cnu1_v2c_2 (cnu1_f2_M_reg[1]),
        .cnu1_v2c_4 (cnu1_f2_M_reg[2]),
        .cnu1_v2c_5 (cnu1_f2_M_reg[3]),

		.read_clk (read_clk),
        .read_addr_offset (read_addr_offset_internal[2]), // offset determing the switch between multi-frame under the following sub-datapath

        // Iteration-Update Page Address 
        .page_addr_ram (page_addr_ram[`IB_ROM_ADDR_WIDTH-1:0]),
        // Iteration-Update Data
        .ram_write_data_3 (ram_write_data_3[`IB_ROM_SIZE-1:0]),

        .write_clk (write_clk),
        .ib_ram_we (ib_ram_we[3])
    );

    reg [`QUAN_SIZE*`CN_DEGREE-1:0] cnu0_c2v_fifo;
    initial cnu0_c2v_fifo[`QUAN_SIZE*`CN_DEGREE-1:0] <= {cnu0_c2v[0], cnu0_c2v[1], cnu0_c2v[2], cnu0_c2v[3], cnu0_c2v[4], cnu0_c2v[5]};
    always @(posedge read_clk) begin
        if(cnu_cnt[4:0] == 23)
            cnu0_c2v_fifo[`QUAN_SIZE*`CN_DEGREE-1:0] <= {cnu0_c2v[0], cnu0_c2v[1], cnu0_c2v[2], cnu0_c2v[3], cnu0_c2v[4], cnu0_c2v[5]};
        else
            cnu0_c2v_fifo[`QUAN_SIZE*`CN_DEGREE-1:0] <= {cnu0_c2v_fifo[`QUAN_SIZE*`CN_DEGREE-2:0], 1'b0};
    end
	
	hulfDuplex_parallel2serial cnu0_c2v_p2s (
		.serial_inout (cnu_out[j*2]),
		//output wire [MSG_WIDTH-1:0] parallel_out,
		
		.parallel_in (cnu0_c2v_fifo[`QUAN_SIZE*`CN_DEGREE-1:`QUAN_SIZE*`CN_DEGREE-4]),
		.load (read_addr_offset_out),
		.parallel_en (1'b0),
		.sys_clk (read_clk)
    );

    reg [`QUAN_SIZE*`CN_DEGREE-1:0] cnu1_c2v_fifo;
    initial cnu1_c2v_fifo[`QUAN_SIZE*`CN_DEGREE-1:0] <= {cnu1_c2v[0], cnu1_c2v[1], cnu1_c2v[2], cnu1_c2v[3], cnu1_c2v[4], cnu1_c2v[5]};
    always @(posedge read_clk) begin
        if(cnu_cnt[4:0] == 23)
            cnu1_c2v_fifo[`QUAN_SIZE*`CN_DEGREE-1:0] <= {cnu1_c2v[0], cnu1_c2v[1], cnu1_c2v[2], cnu1_c2v[3], cnu1_c2v[4], cnu1_c2v[5]};
        else
            cnu1_c2v_fifo[`QUAN_SIZE*`CN_DEGREE-1:0] <= {cnu1_c2v_fifo[`QUAN_SIZE*`CN_DEGREE-2:0], 1'b0};
    end

	hulfDuplex_parallel2serial cnu1_c2v_p2s (
		.serial_inout (cnu_out[j*2+1]),
		//output wire [MSG_WIDTH-1:0] parallel_out,
		
		.parallel_in (cnu1_c2v_fifo[`QUAN_SIZE*`CN_DEGREE-1:`QUAN_SIZE*`CN_DEGREE-4]),
		.load (read_addr_offset_out),
		.parallel_en (1'b0),
		.sys_clk (read_clk)
    );	
  end
endgenerate
endmodule