module cnu_wr_update_handshake_tb;

	initial begin
		$dumpfile("cnu_wr_update.vcd");
		$dumpvars(0, cnu_wr_update_handshake_tb);
	end

	logic read_clk;
 	initial begin
		#0 read_clk <= 1'b0;
		forever #5 read_clk <= ~read_clk;
	end
	logic write_clk;
	initial begin
		#0 write_clk <= 1'b0;
		forever #2 write_clk <= ~write_clk;
	end

	logic rstn;
	initial begin
		#0 rstn <= 1'b0;
		#20 rstn <= 1'b1;
	end

	default clocking cb@(posedge write_clk);
	endclocking

	logic cnu_wr_o, iter_update_i, cnu_rd_finish_i, cnu_init_load_en_i, init_load_o, pipe_load_o;
	cnu_wr_update_handshake handshake_u0 (.*);
    
	initial begin
		#0  begin
			cnu_init_load_en_i <= 1'b0;
			cnu_rd_finish_i <= 1'b0;
		end

		#(20+10+5) cnu_init_load_en_i <= 1'b1;
		wait(init_load_o == 1) #10;
		wait(init_load_o == 0) #10;
		cnu_init_load_en_i <= 1'b0;

		#(10*6) cnu_rd_finish_i <= 1'b1;
		wait(pipe_load_o == 1) #10;
		wait(pipe_load_o == 0) #10;
		cnu_rd_finish_i <= 1'b0;
	end

/*
	initial begin
		#0 iter_update_i <= 1'b0;
	
		// CNU Init Load
		wait(cnu_wr_o == 1'b1);
		iter_update_i <= 1'b1;
		for(int i = 0; i < 32; i=i+1) ##1;

		iter_update_i <= 1'b1;

		##1 iter_update_i <= 1'b0;

		// CNU PIPE Update
		wait(cnu_wr_o == 1'b1);
		iter_update_i <= 1'b1;
		for(int i = 0; i < 32; i=i+1) ##1;

		iter_update_i <= 1'b1;

		##1 iter_update_i <= 1'b0;
	end
*/
	initial iter_update_i <= 1'b0;
	logic [4:0] update_cnt; initial update_cnt <= 0;
	always @(posedge write_clk) begin
		if(cnu_wr_o == 1'b1) begin
			if(update_cnt == 31) begin
				iter_update_i <= 1'b0;
			end
			else begin
				update_cnt <= update_cnt + 1;
				iter_update_i <= 1'b1;
			end
		end
		else begin 
			iter_update_i <= 1'b0;
		end
	end
	
	initial begin
		##200 $finish;
	end
endmodule
