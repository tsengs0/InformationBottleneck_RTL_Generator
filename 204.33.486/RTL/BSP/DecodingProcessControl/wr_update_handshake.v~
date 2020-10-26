module cnu_wr_update_handshake #(
	parameter CDC_DEPTH = 2 // two flip-flops synchroniser for CDC
)(
	output wire cnu_wr_o,
	output wire init_load_o,
	output wire pipe_load_o,

	input wire iter_update_i,
	input wire cnu_rd_finish_i, // whether the 2-input decomposed LUT (F_{0} - F_{dc-2-1}) is finished read operation in the current iteration
	input wire cnu_init_load_en_i, // the FSM is at "initial load" state when assertion is given
	//input wire write_clk,
	input wire read_clk,
	input wire rstn 
);
	wire iter_update;
	reg [CDC_DEPTH-1:0] syncIterUp;
	initial syncIterUp <= 0;
	always @(posedge read_clk, negedge rstn) begin
		if(rstn == 1'b0) syncIterUp[0] <= 1'b0;
		else syncIterUp[0] <= iter_update_i;
	end
	generate
		genvar i;
		for(i=1;i<CDC_DEPTH;i=i+1) begin : cnu_cdc_inst
			always @(posedge read_clk, negedge rstn) begin
				if(rstn == 1'b0) syncIterUp[i] <= 1'b0;
				else syncIterUp[i] <= syncIterUp[i-1];
			end
		end
	endgenerate
	//assign iter_update = syncIterUp[CDC_DEPTH-1];
	assign iter_update = iter_update_i;

	// The inputs source of both "init load" and "cnu pipe" update state
	// signals ought to be latched to synchronise with the timing our
	// init_load_o, pipe_load_o and cnu_wr_o
	reg cnu_rd_finish; //initial cnu_rd_finish <= 1'b0;
	always @(posedge read_clk, negedge rstn) begin
		if(rstn == 1'b0) cnu_rd_finish <= 1'b0;
		else cnu_rd_finish <= cnu_rd_finish_i;
	end
	reg cnu_init_load_en; //initial cnu_init_load_en <= 1'b0;
	always @(posedge read_clk, negedge rstn) begin
		if(rstn == 1'b0) cnu_init_load_en <= 1'b0;
		else cnu_init_load_en <= cnu_init_load_en_i;
	end
	
	wire sig_0, sig_1, sig_2, sig_3, sig_4, sig_5, sig_6, sig_7, sig_8;
	xnor u0(sig_0, iter_update, cnu_wr_o);
	or   u1(sig_1, init_load_o, pipe_load_o);
	//or   u1(sig_1, cnu_rd_finish, cnu_init_load_en);
	and  u2(sig_2, sig_0, sig_1);
	xnor u3(sig_3, sig_2, cnu_wr_o);
	and  u4(sig_4, sig_3, cnu_rd_finish);
	
	and  u6(sig_6, sig_2, ~cnu_wr_o);
	or   u7(sig_7, sig_3, sig_6);

	and  u5(sig_5, sig_7, cnu_init_load_en);
	and  u8(sig_8, sig_7, cnu_rd_finish);

	reg cnu_wr_reg; initial cnu_wr_reg <= 0;
	always @(posedge read_clk, negedge rstn) begin
		if(rstn == 1'b0)
			cnu_wr_reg <= 1'b0;
		else
			cnu_wr_reg <= sig_2;
	end
	assign cnu_wr_o = cnu_wr_reg;

	reg init_load_reg; initial init_load_reg <= 0;
	always @(posedge read_clk, negedge rstn) begin
		if(rstn == 1'b0)
			init_load_reg <= 1'b0;
		else
			init_load_reg <= sig_5;
	end
	assign init_load_o = init_load_reg;
	
	reg pipe_load_reg; initial pipe_load_reg <= 0;
	always @(posedge read_clk, negedge rstn) begin
		if(rstn == 1'b0)
			pipe_load_reg <= 1'b0;
		else
			pipe_load_reg <= sig_8;
	end
	assign pipe_load_o = pipe_load_reg;
endmodule
