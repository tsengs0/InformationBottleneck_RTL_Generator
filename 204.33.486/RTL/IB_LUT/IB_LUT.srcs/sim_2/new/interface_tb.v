`timescale 1ns/1ps

module interface_tb;

reg en;
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

wire m_clk;
decomp_clk_gen u0 (
	.m_clk   (m_clk),
	.en      (en),
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

	.en (en),
	.ram_clk (ram_clk)
);

wire [1:0] ram_sel;
ram_sel_counter u2 (
	.ram_sel (ram_sel[1:0]),
	.en      (en),
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
/*reg [31:0] dataIn_ram0_reg;
reg [31:0] dataIn_ram1_reg;
reg [31:0] dataIn_ram2_reg;
reg [31:0] dataIn_ram3_reg;
always @(negedge ram_clk) begin
	dataIn_ram0_reg[31:0] <= interBank_data_ram0[31:0];
	dataIn_ram1_reg[31:0] <= interBank_data_ram1[31:0];
	dataIn_ram2_reg[31:0] <= interBank_data_ram2[31:0];
	dataIn_ram3_reg[31:0] <= interBank_data_ram3[31:0];
end
*/
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

initial #(20*15*5) $finish;
endmodule