//`include "define.v"
`define QUAN_SIZE 4
`define IB_ADDR 8
`define CARDINALITY 16
`define RAM_DEPTH 256
module cnu_ib_ram (
    output reg [`QUAN_SIZE-1:0] ib_ram_out,
    
    input wire [`IB_ADDR-1:0] ib_ram_addr,
    input sys_clk 
);

wire [`QUAN_SIZE-1:0] ram [0:`RAM_DEPTH-1];

genvar i;
generate 
  for (i = 0; i < `RAM_DEPTH; i = i + 1) begin
        assign ram[i] = i;
  end
endgenerate

always @(negedge sys_clk) begin
    ib_ram_out[`QUAN_SIZE-1:0] <= ram[ib_ram_addr];
end

endmodule