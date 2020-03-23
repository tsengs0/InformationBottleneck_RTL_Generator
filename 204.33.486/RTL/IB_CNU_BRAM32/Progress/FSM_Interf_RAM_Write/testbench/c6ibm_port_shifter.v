module c6ibm_port_shifter(
    output reg [31:0] port_out,
    
    input wire [31:0] in_portA,
    input wire [31:0] in_portB,
    input wire [31:0] in_portC,
    
    input wire en,
    input wire ram_clk
);

/*
reg en_reg;
initial en_reg <= 1'b0;
always @(posedge ram_clk) en_reg <= en;
*/
reg [1:0] cnt;
initial cnt[1:0] <= 2'b00;
always @(negedge ram_clk) begin
    if(!en) 
	cnt[1:0] <= 2'b00;
    else if(cnt[1:0] == 2'b10) 
	cnt[1:0] <= 2'b00;
    else 
	cnt[1:0] <= cnt[1:0]+1'b1;
end

reg [95:0] ports_data = 96'd0;
always @(posedge ram_clk) begin
    if(!en) 
	ports_data[95:0] <= 96'd0;
    else if(cnt[1:0] == 2'b00) 
        ports_data[95:0] <= {in_portA[31:0], in_portB[31:0], in_portC[31:0]};
    else begin
	ports_data[95:64] <= ports_data[63:32];
	ports_data[63:32] <= ports_data[31: 0];
	ports_data[31: 0] <= in_portA[31:0];
    end
end

initial port_out[31:0] <= 32'd0;
always @(negedge ram_clk) begin
    if(!en) 
	port_out[31:0] <= 32'd0;
    else
        port_out[31:0] <= ports_data[95:64];
end
endmodule
