module errBit_cnt_128b #(
  parameter ERR_WIDTH   = 128, // bitwidth of target bits vector 
  parameter COUNT_WIDTH = 8   // bitwidth of error bit counter
)(
    output wire [COUNT_WIDTH-1:0] err_count,
    input  wire [ERR_WIDTH-1:0] A
    );
    
    assign err_count = 
          (
            ((((A[ 0] + A[ 1] + A[ 2] + A[ 3]) + (A[ 4] + A[ 5] + A[ 6] + A[ 7]))
            +  ((A[ 8] + A[ 9] + A[10] + A[11]) + (A[12] + A[13] + A[14] + A[15])))
            + (((A[16] + A[17] + A[18] + A[19]) + (A[20] + A[21] + A[22] + A[23]))
            +  ((A[24] + A[25] + A[26] + A[27]) + (A[28] + A[29] + A[30] + A[31]))))
  
              +  ((((A[32] + A[33] + A[34] + A[35]) + (A[36] + A[37] + A[38] + A[39]))
              +  ((A[40] + A[41] + A[42] + A[43]) + (A[44] + A[45] + A[46] + A[47])))
              + (((A[48] + A[49] + A[50] + A[51]) + (A[52] + A[53] + A[54] + A[55]))
              + ((A[56] + A[57] + A[58] + A[59]) + (A[60] + A[61] + A[62] + A[63]))))
          )

          +

          (
             ((((A[ 0+64] + A[ 1+64] + A[ 2+64] + A[ 3+64]) + (A[ 4+64] + A[ 5+64] + A[ 6+64] + A[ 7+64]))
            +  ((A[ 8+64] + A[ 9+64] + A[10+64] + A[11+64]) + (A[12+64] + A[13+64] + A[14+64] + A[15+64])))
            + (((A[16+64] + A[17+64] + A[18+64] + A[19+64]) + (A[20+64] + A[21+64] + A[22+64] + A[23+64]))
            +  ((A[24+64] + A[25+64] + A[26+64] + A[27+64]) + (A[28+64] + A[29+64] + A[30+64] + A[31+64]))))
  
              +  ((((A[32+64] + A[33+64] + A[34+64] + A[35+64]) + (A[36+64] + A[37+64] + A[38+64] + A[39+64]))
              +    ((A[40+64] + A[41+64] + A[42+64] + A[43+64]) + (A[44+64] + A[45+64] + A[46+64] + A[47+64])))
              +   (((A[48+64] + A[49+64] + A[50+64] + A[51+64]) + (A[52+64] + A[53+64] + A[54+64] + A[55+64]))
              +    ((A[56+64] + A[57+64] + A[58+64] + A[59+64]) + (A[60+64] + A[61+64] + A[62+64] + A[63+64]))))
          );
endmodule

module errBit_cnt_96b #(
  parameter ERR_WIDTH   = 96, // bitwidth of target bits vector 
  parameter COUNT_WIDTH = 7   // bitwidth of error bit counter
)(
    output wire [COUNT_WIDTH-1:0] err_count,
    input  wire [ERR_WIDTH-1:0] A
    );
    
    assign err_count = 
          (
            ((((A[ 0] + A[ 1] + A[ 2] + A[ 3]) + (A[ 4] + A[ 5] + A[ 6] + A[ 7]))
            +  ((A[ 8] + A[ 9] + A[10] + A[11]) + (A[12] + A[13] + A[14] + A[15])))
            + (((A[16] + A[17] + A[18] + A[19]) + (A[20] + A[21] + A[22] + A[23]))
            +  ((A[24] + A[25] + A[26] + A[27]) + (A[28] + A[29] + A[30] + A[31]))))
  
              +  ((((A[32] + A[33] + A[34] + A[35]) + (A[36] + A[37] + A[38] + A[39]))
              +  ((A[40] + A[41] + A[42] + A[43]) + (A[44] + A[45] + A[46] + A[47])))
              + (((A[48] + A[49] + A[50] + A[51]) + (A[52] + A[53] + A[54] + A[55]))
              + ((A[56] + A[57] + A[58] + A[59]) + (A[60] + A[61] + A[62] + A[63]))))
          )

          +

             ((((A[ 0+64] + A[ 1+64] + A[ 2+64] + A[ 3+64]) + (A[ 4+64] + A[ 5+64] + A[ 6+64] + A[ 7+64]))
            +  ((A[ 8+64] + A[ 9+64] + A[10+64] + A[11+64]) + (A[12+64] + A[13+64] + A[14+64] + A[15+64])))
            + (((A[16+64] + A[17+64] + A[18+64] + A[19+64]) + (A[20+64] + A[21+64] + A[22+64] + A[23+64]))
            +  ((A[24+64] + A[25+64] + A[26+64] + A[27+64]) + (A[28+64] + A[29+64] + A[30+64] + A[31+64]))));
endmodule

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