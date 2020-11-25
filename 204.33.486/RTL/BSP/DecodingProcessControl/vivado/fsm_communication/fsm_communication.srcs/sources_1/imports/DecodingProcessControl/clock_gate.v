// Add an additional latch to prevent clock glitching
module clock_gate (
	output wire gclk,

	input wire en,
	input wire clk_in
);

reg en_out;
always @(enable, clk_in) begin
	if(clk_en == 1'b0) en_out = en; // build a latch 
end

assign gclk = en_out && clk_in;
endmodule
