module c6ibAddr_ram_sel (
	output reg [4:0] page_addr_ram0, 
	output reg [4:0] page_addr_ram1, 
	output reg [4:0] page_addr_ram2,
	output reg [4:0] page_addr_ram3, 

	input wire en,
	input wire [1:0] ram_sel, 
	input wire ram_clk 
);

reg en_reg;
initial en_reg <= 1'b0;
always @(posedge ram_clk) en_reg <= en;

reg [4:0] cnt;
initial cnt[4:0] <= 5'd0;
always @(negedge ram_clk) begin
	if(!en_reg) cnt[4:0] <= 5'd0;
	else if(cnt[4:0] == 5'd14) cnt[4:0] <= 5'd0;
	else cnt[4:0] <= cnt[4:0] + 1'b1;
end

always @(negedge ram_clk) begin
	if(!en_reg) page_addr_ram0[4:0] <= 5'd0;
	else if(ram_sel[1:0] == 2'd0) page_addr_ram0[4:0] <= cnt[4:0];
	else                          page_addr_ram0[4:0] <= 5'd0;
end

always @(negedge ram_clk) begin
	if(!en_reg) page_addr_ram1[4:0] <= 5'd0;
	else if(ram_sel[1:0] == 2'd1) page_addr_ram1[4:0] <= cnt[4:0];
	else                          page_addr_ram1[4:0] <= 5'd0;
end

always @(negedge ram_clk) begin
	if(!en_reg) page_addr_ram2[4:0] <= 5'd0;
	else if(ram_sel[1:0] == 2'd2) page_addr_ram2[4:0] <= cnt[4:0];
	else                          page_addr_ram2[4:0] <= 5'd0;
end

always @(negedge ram_clk) begin
	if(!en_reg) page_addr_ram3[4:0] <= 5'd0;
	else if(ram_sel[1:0] == 2'd3) page_addr_ram3[4:0] <= cnt[4:0];
	else                          page_addr_ram3[4:0] <= 5'd0;
end
endmodule
