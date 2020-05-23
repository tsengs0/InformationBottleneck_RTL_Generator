module bidir_port (
    input sys_clk,
    input we, // '1' => write enable; '0' => read enable
    input [2:0] address,
    inout [7:0] data 
    );

    reg [7:0] data_out;
    reg [7:0] mem [0:7];
    assign data = (!we)? data_out : {8{1'hz}};
    
    always @(posedge sys_clk) begin
        if(we) 
            mem[address] <= data;
        else
            data_out <= mem[address];
    end
endmodule