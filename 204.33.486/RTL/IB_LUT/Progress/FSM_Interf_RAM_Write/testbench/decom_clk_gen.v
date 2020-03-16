module decom_clk_gen(
    output reg m_clk,
    input wire en,
    input wire ram_clk
);

reg en_reg;
initial en_reg <= 1'b0;
always @(posedge ram_clk) en_reg <= en;
reg [3:0] cnt = 4'b0000; // counting from 0 to 14
always @(posedge ram_clk) begin
    if(!en_reg) 
	cnt[3:0] <= 4'd0;
    else if(cnt[3:0] == 4'd14)
        cnt[3:0] <= 4'b0000;
    else
        cnt[3:0] <= cnt[3:0] + 1'b1;
end
always @(ram_clk) begin
	if(!en_reg) m_clk <= 1'b0;
	else if(cnt[3:0] == 4'd14) begin
		if(ram_clk == 1'b1) m_clk <= 1'b1;
		else m_clk <= 1'b0;
	end
	else m_clk <= 1'b0;
end
endmodule
