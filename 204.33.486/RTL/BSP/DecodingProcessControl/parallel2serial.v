`include "define.v"

module parallel2serial (
	output reg serial_data,

	input wire serial_clk,
	input wire rstn,
	input wire [`DATAPATH_WIDTH-1:0] data_in
);
function integer log2;
	input integer addr;
	begin
        	addr = addr - 1;
        	for (log2=0; addr>0; log2=log2+1)
                	addr = addr >> 1;
	end
endfunction
        localparam serial_cnt_width = log2(`DATAPATH_WIDTH);
	reg [serial_cnt_width-1:0] serial_cnt; // one more count for loading state
	reg [`DATAPATH_WIDTH-1:0] shift_data; 
	// serial counter
	initial serial_cnt[serial_cnt_width-1:0] <= 'd0;
	always @(negedge serial_clk) begin
		if(!rstn) serial_cnt[serial_cnt_width-1:0] <= 'd0;
		else if(serial_cnt[serial_cnt_width-1:0] == (`DATAPATH_WIDTH-1)) serial_cnt[serial_cnt_width-1:0] <= 'd0;
		else serial_cnt <= serial_cnt + 1'b1;
	end

	// D FF
	initial shift_data[`DATAPATH_WIDTH-1:0] <= {`DATAPATH_WIDTH{1'b0}};
	always @(posedge serial_clk) begin
		if(!rstn) shift_data[`DATAPATH_WIDTH-1:0] <= {`DATAPATH_WIDTH{1'b0}};
		else if(serial_cnt == 0) shift_data[`DATAPATH_WIDTH-1:0] <= data_in[`DATAPATH_WIDTH-1:0];
		else shift_data[`DATAPATH_WIDTH-1:0] <= {shift_data[`DATAPATH_WIDTH-2:0], 1'b0};
	end

	// Output port
	initial serial_data <= 1'b0;
	always @(negedge serial_clk) begin
		serial_data <= shift_data[`DATAPATH_WIDTH-1];
	end
endmodule
