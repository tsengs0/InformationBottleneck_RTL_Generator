`timescale 1ns/1ps

module top;

reg ram_clk;
initial begin
  $dumpfile("tb.vcd");
  $dumpvars();
end

initial begin
	#0;
	ram_clk <= 1'b0;

	forever #10 ram_clk <= ~ram_clk;
end

reg rstn_cnu_fsm, iter_rqst, iter_termination;
wire ram_write_en, iter_update, c6ib_rom_rst;
wire [2:0] state;
cnu6ib_control_unit control_unit (
    .ram_write_en (ram_write_en),
    .iter_update  (iter_update),
    .c6ib_rom_rst (c6ib_rom_rst),
    .state (state[2:0]),
    
    .sys_clk (ram_clk),
    .rstn (rstn_cnu_fsm),
    .iter_rqst (iter_rqst),
    .iter_termination (iter_termination)
);

wire m_clk;
decom_clk_gen u0 (
	.m_clk   (m_clk),
	.en      (ram_write_en),
	.ram_clk (ram_clk)
);

wire [31:0] port_out;
reg [31:0] in_portA;
reg [31:0] in_portB;
reg [31:0] in_portC;
c6ibm_port_shifter u1 (
	.port_out (port_out[31:0]),

	.in_portA (in_portA[31:0]),	
	.in_portB (in_portB[31:0]),	
	.in_portC (in_portC[31:0]),	

	.en (ram_write_en),
	.ram_clk (ram_clk)
);

wire [1:0] ram_sel;
ram_sel_counter u2 (
	.ram_sel (ram_sel[1:0]),
	.en      (ram_write_en),
	.m_clk   (m_clk)
);
reg [1:0] ram_sel_reg;
always @(negedge m_clk) ram_sel_reg[1:0] <= ram_sel[1:0];
wire [31:0] interBank_data_ram0;
wire [31:0] interBank_data_ram1;
wire [31:0] interBank_data_ram2;
wire [31:0] interBank_data_ram3;
c6ibwr_ram_sel u3 (
	.interBank_data_ram0 (interBank_data_ram0[31:0]),
	.interBank_data_ram1 (interBank_data_ram1[31:0]),
	.interBank_data_ram2 (interBank_data_ram2[31:0]),
	.interBank_data_ram3 (interBank_data_ram3[31:0]),
    
	.interBank_write_data (port_out[31:0]),
	.ram_sel (ram_sel[1:0])
);

wire [4:0] page_addr_ram0;
wire [4:0] page_addr_ram1;
wire [4:0] page_addr_ram2;
wire [4:0] page_addr_ram3;
c6ibAddr_ram_sel c6ibAddr_ram_sel_0 (
	.page_addr_ram0 (page_addr_ram0[4:0]),
	.page_addr_ram1 (page_addr_ram1[4:0]),
	.page_addr_ram2 (page_addr_ram2[4:0]),
	.page_addr_ram3 (page_addr_ram3[4:0]),

	.en      (ram_write_en),
	.ram_sel (ram_sel[1:0]),
	.ram_clk (ram_clk)
);
reg [11:0] wavegen_cnt;
initial begin
	#0;
	wavegen_cnt[11:0] <= 12'd0;
end
always @(negedge ram_clk) begin
	if(iter_rqst == 1'b1)
		wavegen_cnt[11:0] <= wavegen_cnt[11:0] + 1'b1;
end
always @(negedge ram_clk) begin
	if(iter_rqst == 1'b1) begin
		if(wavegen_cnt[11:0] == 12'd0) 
			{in_portA, in_portB, in_portC} <= {32'd1, 32'd2, 32'd3};
		else if((wavegen_cnt[11:0] % 3) == 0) 
			{in_portA, in_portB, in_portC} <= {in_portA+1, in_portB+1, in_portC+1};
	end
	else {in_portA, in_portB, in_portC} <= {32'd0, 32'd0, 32'd0};
end

initial begin
	#0;
	{rstn_cnu_fsm, iter_rqst, iter_termination} <= 3'b000;

	#10;
	{rstn_cnu_fsm, iter_rqst, iter_termination} <= 3'b110;

	#(30+20*3*60);
	{rstn_cnu_fsm, iter_rqst, iter_termination} <= 3'b001;
end

/*
initial begin
	#0;
	en <= 1'b0;
	{in_portA, in_portB, in_portC} <= 96'd0;

	#30;
	{in_portA, in_portB, in_portC} <= {32'd1, 32'd2, 32'd3};

	#10;
	en <= 1'b1;
	
	forever #(20*3) {in_portA, in_portB, in_portC} <= {in_portA+1, in_portB+1, in_portC+1};
end
*/
initial #(30+10+20*3*60+20) $finish;
endmodule
