module dnu3_wr_fsm #(
	parameter LOAD_CYCLE = 64 // 128-entry with two interleaving banks requires 64 clock cycle to finish iteration update 
) (
	output wire rom_port_fetch, // to enable the ib-map starting to fetch data from read port of IB ROM
    output wire ram_write_en,
    output wire ram_mux_en,
    output wire iter_update,
    output wire v3ib_rom_rst,
	output wire [1:0] busy, // 00b: not busy at IDLE state; 01b: busy with update operations; 10b: not busy at FINISH state
    output reg [2:0] state,
    
    input wire write_clk,
    input wire rstn,
    input wire iter_rqst,
    input wire iter_termination
);

localparam IDLE       = 3'b000;
localparam ROM_FETCH0 = 3'b001; // only for the first write or non-pipeline fashion
localparam RAM_LOAD0  = 3'b010;
localparam RAM_LOAD1  = 3'b011;
localparam FINISH     = 3'b100;

localparam CNT_WIDTH = $clog2(LOAD_CYCLE);
reg [CNT_WIDTH-1:0] write_cnt;
initial write_cnt[CNT_WIDTH-1:0] <= 0;
always @(posedge write_clk, negedge rstn) begin
	if(!rstn) 
		write_cnt[CNT_WIDTH-1:0] <= 0;
	else if(!ram_write_en)
		write_cnt[CNT_WIDTH-1:0] <= 0;
	else
		write_cnt[CNT_WIDTH-1:0] <= write_cnt[CNT_WIDTH-1:0] + 1'b1;
end

initial state[2:0] <= IDLE;
wire idle_cond, finish_cond;
wire [2:0] in_cond;
assign in_cond[2:0] = {rstn, iter_rqst, iter_termination};
or u0 (idle_cond, rstn, iter_rqst, iter_termination);
or u1 (finish_cond, ~iter_rqst, iter_termination);

always @(posedge write_clk) begin
   if (!idle_cond) begin
      state <= IDLE;
   end
   else
      case (state[2:0])
         IDLE : begin
            if (!idle_cond)
               state <= IDLE;
            else if (in_cond[2:0] == 3'b110) begin // negedge
                state <= ROM_FETCH0;
            end
            else
               state <= IDLE;
         end
         
         ROM_FETCH0 : begin
            if (in_cond[2:0] == 3'b110)
               state <= RAM_LOAD0;
            else
               state <= ROM_FETCH0;
         end
         
         RAM_LOAD0 : begin 
            if (finish_cond)
               state <= FINISH;         
            else if (in_cond[2:0] == 3'b110)
               state <= RAM_LOAD1;
            else
               state <= RAM_LOAD0;
         end
         RAM_LOAD1 : begin
            if (finish_cond)
               state <= FINISH;
            else if (write_cnt[CNT_WIDTH-1:0] == LOAD_CYCLE-1)
				state <= FINISH;
            else
				state <= RAM_LOAD1;
         end
        FINISH : begin
			if(iter_rqst == 1'b1) state <= FINISH; // intentionally suspending at current state when iter_rqst is still asserted due to the asynchronous timing
            else state <= IDLE;
        end                   
      endcase	
end	
/*
reg ram_write_en_latch;
initial ram_write_en_latch <= 1'b0;
always @(posedge sys_clk) begin
    ram_write_en_latch <= rom_port_fetch;
end
assign {rom_port_fetch, iter_update, v3ib_rom_rst, ram_write_en} = (state[2:0] == IDLE        ) ? {3'b001, ram_write_en_latch} :
                                                                   (state[2:0] == PRELOAD_ADDR) ? {3'b110, ram_write_en_latch} :
                                                                   (state[2:0] == PRELOAD_DATA) ? {3'b110, ram_write_en_latch} :
                                                                   (state[2:0] == RAM_LOAD    ) ? {3'b110, ram_write_en_latch} :
                                                                   (state[2:0] == BATCH_WRITE ) ? {3'b110, ram_write_en_latch} : 
                                                                                                  {3'b001, ram_write_en_latch};
*/
assign {rom_port_fetch, ram_mux_en, ram_write_en, iter_update, v3ib_rom_rst, busy[1:0]} = 
                                                                   /*State 0*/ (state[2:0] == IDLE      ) ? 7'b0000100 :
                                                                   /*State 1*/ (state[2:0] == ROM_FETCH0) ? 7'b1001001 :
                                                                   /*State 2*/ (state[2:0] == RAM_LOAD0 ) ? 7'b1101001 :
                                                                   /*State 3*/ (state[2:0] == RAM_LOAD1 ) ? 7'b1111001 :
                                                                   /*State 4*/                              7'b0000110; // FINISH state	
/* 
// Optimisation by Karnaugh maps                                                  
assign ram_write_en = ~state[2] & state[1];
assign iter_update = (state[2] & ~state[1] & ~state[0]) | (~state[2] & state[1]) | (~state[2] & state[0]);
assign v3ib_rom_rst = (~state[2] & ~state[1] & ~state[0]) | (state[2] & ~state[1] & state[0]); 
*/     
endmodule