`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2020 09:57:34 AM
// Design Name: 
// Module Name: sym_lut_cn_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module sym_lut_cn_tb;
// Parameters
parameter ClkPeriod = 3.333; // 300MHz
parameter Dly = 1.0;
parameter N = 10;
parameter pipeline_levels = 6;
parameter sample_num = 10;

// Local variables
// For read operation
logic [3:0] c2vA;
logic [3:0] c2vB;
logic [3:0] c2vC;
logic [3:0] c2vD;
// Port A
logic [3:0] v2c_A0,
logic [3:0] v2c_A1,
logic [3:0] v2c_A2,
logic [3:0] v2c_A3,
logic [3:0] v2c_A4,
logic read_addr_offset_out;
logic read_addr_offset;

// For write operation
logic [2:0] lut_in_bank0; // input data
logic [2:0] lut_in_bank1; // input data 
logic [4:0] page_write_addr; // write address
logic write_addr_offset; // write address offset
logic we;
logic rstn;
logic CLK_300_N;
logic CLK_300_P;

logic rstn;
initial begin
    CLK_300_N <= 1'b0;
    #(ClkPeriod*100);
    forever #(ClkPeriod/2) CLK_300_N = ~CLK_300_N;
end

initial begin
    CLK_300_P <= 1'b1;
    #(ClkPeriod*100);
    forever #(ClkPeriod/2) CLK_300_P = ~CLK_300_P;
end

initial begin
    rstn <= 1'b0;
    #(ClkPeriod*100);
    #(ClkPeriod*2) rstn = 1'b1;
end
// Instances
top u0 (.*);

// Main process
int fpOut_ib_ch;
reg [3:0] v2c_samples [0:sample_num-1];
reg [3:0] c2v_samples [0:sample_num-1];
initial begin
    fpOut_ib_ch = $fopen("hw_gng_data_out.ib_ch.txt", "w");

    $readmemb("/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/symmetry_ib_lut_structure/symmetry_ib_lut_structure.sim/ch_msg.mem", v2c_samples);
	$readmemb("/home/s1820419/LDPC_MinorResearch/GeneratedDecoders/204.33.486/RTL/symmetry_ib_lut_structure/symmetry_ib_lut_structure.sim/c2v_pattern.mem", c2v_samples);

    #(ClkPeriod*100)
    repeat (N) begin
        @(posedge u0.read_clk);
        #(Dly);
    end
    @(posedge u0.read_clk);
    #(Dly);
end

// Record data
reg [3:0] cnt;
initial cnt[3:0] <= 0;
always_ff @ (posedge u0.read_clk, negedge rstn) begin
    if(!rstn) cnt[3:0] <= 0;
    else if(cnt[3:0] == (sample_num+4)) cnt[3:0] <= 0;
    else cnt[3:0] <= cnt[3:0] + 1'b1;
end

always @ (posedge u0.read_clk, negedge rstn) begin
    if(!rstn) begin
        y_int[4:0]  <= {(15-11+1){1'bz}};
        y_dec[10:0] <= {(10-0+1){1'bz}};
    end
    else begin
        y_int[4:0]  <= samples[cnt[19:0]][15:11];
        y_dec[10:0] <= samples[cnt[19:0]][10:0];
    end
end

always_ff @ (posedge u0.read_clk, negedge rstn) begin
    if(!rstn)
        $display("Sitll undergoing reset state\n");
    else
        //$fwrite(fpOut_ib_ch, "%d -> %d\n", $signed(samples[cnt[7:0]]), $unsigned(ch_msg));
        if(cnt >= pipeline_levels) // the first output value will come 5 clock cycles later
            $fwrite(fpOut_ib_ch, "%d\n", $unsigned(ch_msg));

end

initial begin
    wait(cnt[3:0] >= (sample_num+4));
    $fclose(fpOut_ib_ch);
    $finish;
end
endmodule