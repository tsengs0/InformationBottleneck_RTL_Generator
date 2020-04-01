module c6ibAddr_ram_sel 
#(
    parameter RAM_DEPTH = 32,
    parameter RAM_NUM = 4
)
(
	output reg [4:0] page_addr_ram0, 
	output reg [4:0] page_addr_ram1, 
	output reg [4:0] page_addr_ram2,
	output reg [4:0] page_addr_ram3,
	output reg [RAM_NUM-1:0] we,
     

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
    if(en_reg == 1'b1) begin
        if(cnt[4:0] == RAM_DEPTH-1) cnt[4:0] <= 5'd0;
        else cnt[4:0] <= cnt[4:0] + 1'b1;
	end
end

initial begin
    page_addr_ram0[4:0] <= 5'd0;
    page_addr_ram1[4:0] <= 5'd0;
    page_addr_ram2[4:0] <= 5'd0;
    page_addr_ram3[4:0] <= 5'd0;
    we[RAM_NUM-1:0] <= 'd0;
end

always @(posedge ram_clk) begin
    if(ram_sel[1:0] == 2'd0) begin
        page_addr_ram0[4:0] <= cnt[4:0];
        we[0] <= en; 
    end
	else begin
	   page_addr_ram0[4:0] <= 5'd0;
	   we[0] <= 1'b0;
	end
end

always @(posedge ram_clk) begin
    if(ram_sel[1:0] == 2'd1) begin
        page_addr_ram1[4:0] <= cnt[4:0];
        we[1] <= en; 
    end
	else begin
	   page_addr_ram1[4:0] <= 5'd0;
	   we[1] <= 1'b0;
	end
end

always @(posedge ram_clk) begin
    if(ram_sel[1:0] == 2'd2) begin
        page_addr_ram2[4:0] <= cnt[4:0];
        we[2] <= en; 
    end
	else begin
	   page_addr_ram2[4:0] <= 5'd0;
	   we[2] <= 1'b0;
	end
end

always @(posedge ram_clk) begin
    if(ram_sel[1:0] == 2'd3) begin
        page_addr_ram3[4:0] <= cnt[4:0];
        we[3] <= en; 
    end
	else begin
	   page_addr_ram3[4:0] <= 5'd0;
	   we[3] <= 1'b0;
	end
end
endmodule
