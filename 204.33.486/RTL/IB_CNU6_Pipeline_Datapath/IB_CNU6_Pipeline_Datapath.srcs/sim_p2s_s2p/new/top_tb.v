`include "define.v"

module top_tb;

reg serial_clk;
reg serial_en;
reg rstn, rstn_reg;
reg [`DATAPATH_WIDTH-1:0] data_in;
wire serial_data;
wire [`DATAPATH_WIDTH-1:0] parallel_data;

parallel2serial u0(
	.serial_data (serial_data),

	.serial_clk (serial_clk),
	.rstn (rstn),
	.data_in (data_in[`DATAPATH_WIDTH-1:0])
);

serial2parallel u1(
	.parallel_data (parallel_data[`DATAPATH_WIDTH-1:0]),

	.serial_clk (serial_clk), // phase shift of +180 degree
	.rstn (rstn_reg),
	.data_in (serial_data)
);

initial #0 rstn_reg <= 1'b0;
always @(negedge serial_clk) rstn_reg <= rstn;

initial begin
       $dumpfile("p2s_s2p_tb.vcd");
       $dumpvars;
end

initial
begin
	#0;
	serial_clk <= 1'b0;
	
	#20;
	forever #10 serial_clk <= ~serial_clk;
end

initial
begin
	#0;
	rstn <= 1'b0;
	
	#10;
	rstn <= 1'b1;
end

reg [`DATAPATH_WIDTH-1:0] read_data [0:(1<<`DATAPATH_WIDTH)-1];
integer i, j;
initial begin
	#0;
	$readmemb("incoming_msg.txt", read_data);
	data_in <= {`DATAPATH_WIDTH{1'bx}};
	serial_en  <= 1'b0;

	#10;
	serial_en <= 1'b1;
	#10;
	for(i=0; i <= (1<<`DATAPATH_WIDTH); i=i+1) 
	begin
		data_in[`DATAPATH_WIDTH-1:0] <= read_data[i];
            	$display("Loading Message = %b", read_data[i]);
		
		for(j=0;j<`DATAPATH_WIDTH; j=j+1) 
		begin
			#20;
		end
	end
end

integer sim_timeout = 20+(20*`DATAPATH_WIDTH)*(1<<`DATAPATH_WIDTH);
initial #(sim_timeout+30) $finish;
endmodule