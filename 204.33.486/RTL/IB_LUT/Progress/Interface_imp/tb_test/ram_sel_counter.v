module ram_sel_counter(
    output reg [1:0] ram_sel,
    input wire en,
    input wire m_clk
);

wire clk_gate;
assign clk_gate = m_clk & en;
initial ram_sel[1:0] <= 2'b00;
always @(negedge clk_gate) begin
	if(m_clk == 1'b0)
		ram_sel[1:0] <= ram_sel[1:0] + 2'b01;  
end
endmodule
