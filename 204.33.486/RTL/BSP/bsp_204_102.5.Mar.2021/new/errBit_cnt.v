module errBit_cnt_32b #(
	parameter ERR_WIDTH   = 32, // bitwidth of target bits vector 
	parameter COUNT_WIDTH = 6,  // bitwidth of error bit counter
	parameter ERR_SIGN    = 1   // definition of "error bit", i.e., '1' or '0'
)(
    output wire [COUNT_WIDTH-1:0] err_count,
    input  wire [ERR_WIDTH-1:0] A
    );
    
    assign err_count = (((A[ 0] + A[ 1] + A[ 2] + A[ 3]) + (A[ 4] + A[ 5] + A[ 6] + A[ 7]))
          +  ((A[ 8] + A[ 9] + A[10] + A[11]) + (A[12] + A[13] + A[14] + A[15])))
          + (((A[16] + A[17] + A[18] + A[19]) + (A[20] + A[21] + A[22] + A[23]))
          +  ((A[24] + A[25] + A[26] + A[27]) + (A[28] + A[29] + A[30] + A[31])));
endmodule

module errBit_cnt_12b #(
	parameter ERR_WIDTH   = 12, // bitwidth of target bits vector 
	parameter COUNT_WIDTH = 4,  // bitwidth of error bit counter
	parameter ERR_SIGN    = 1   // definition of "error bit", i.e., '1' or '0'
)(
    output wire [COUNT_WIDTH-1:0] err_count,
    input  wire [ERR_WIDTH-1:0] A
    );
    
    assign err_count = (((A[ 0] + A[ 1] + A[ 2] + A[ 3]) + (A[ 4] + A[ 5] + A[ 6] + A[ 7]))
          +  (A[ 8] + A[ 9] + A[10] + A[11]));
endmodule

module errBit_cnt_8b #(
	parameter ERR_WIDTH   = 8, // bitwidth of target bits vector 
	parameter COUNT_WIDTH = 4,  // bitwidth of error bit counter
	parameter ERR_SIGN    = 1   // definition of "error bit", i.e., '1' or '0'
)(
    output wire [COUNT_WIDTH-1:0] err_count,
    input  wire [ERR_WIDTH-1:0] A
    );
    
    assign err_count = ((A[ 0] + A[ 1] + A[ 2] + A[ 3]) + (A[ 4] + A[ 5] + A[ 6] + A[ 7]));
endmodule