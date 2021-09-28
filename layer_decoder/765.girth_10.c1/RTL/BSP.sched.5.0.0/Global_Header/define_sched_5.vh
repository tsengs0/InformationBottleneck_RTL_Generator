`define SCHED_5_0_0

`define CHECK_PARALLELISM 255
//==========================================================================//
// Starting page address of base-matrix colmumn 0 and BS shift control
`define shift_factor_0_0 `CHECK_PARALLELISM-0
`define shift_factor_0_1 `CHECK_PARALLELISM-0
`define shift_factor_0_2 `CHECK_PARALLELISM-0	
`define START_PAGE_0_0  0 // starting page address of layer 0 of submatrix_1
`define START_PAGE_0_1  0 // starting page address of layer 1 of submatrix_1
`define START_PAGE_0_2  0 // starting page address of layer 2 of submatrix_1
//==========================================================================//
// Starting page address of base-matrix colmumn 1 and BS shift control
`define shift_factor_1_0 `CHECK_PARALLELISM-109
`define shift_factor_1_1 `CHECK_PARALLELISM-124
`define shift_factor_1_2 `CHECK_PARALLELISM-22	
`define START_PAGE_1_0  1 // starting page address of layer 0 of submatrix_1
`define START_PAGE_1_1  0 // starting page address of layer 1 of submatrix_1
`define START_PAGE_1_2  1 // starting page address of layer 2 of submatrix_1
//==========================================================================//
// Starting page address of base-matrix colmumn 2 and BS shift control
`define shift_factor_2_0 `CHECK_PARALLELISM-179
`define shift_factor_2_1 `CHECK_PARALLELISM-191
`define shift_factor_2_2 `CHECK_PARALLELISM-140	
`define START_PAGE_2_0  0 // starting page address of layer 0 of submatrix_1
`define START_PAGE_2_1  1 // starting page address of layer 1 of submatrix_1
`define START_PAGE_2_2  0 // starting page address of layer 2 of submatrix_1
//==========================================================================//
// Starting page address of base-matrix colmumn 3 and BS shift control
`define shift_factor_3_0 `CHECK_PARALLELISM-123
`define shift_factor_3_1 `CHECK_PARALLELISM-28
`define shift_factor_3_2 `CHECK_PARALLELISM-104	
`define START_PAGE_3_0  0 // starting page address of layer 0 of submatrix_1
`define START_PAGE_3_1  0 // starting page address of layer 1 of submatrix_1
`define START_PAGE_3_2  2 // starting page address of layer 2 of submatrix_1
//==========================================================================//
// Starting page address of base-matrix colmumn 4 and BS shift control
`define shift_factor_4_0 `CHECK_PARALLELISM-71
`define shift_factor_4_1 `CHECK_PARALLELISM-107
`define shift_factor_4_2 `CHECK_PARALLELISM-77
`define START_PAGE_4_0  0 // starting page address of layer 0 of submatrix_1
`define START_PAGE_4_1  2 // starting page address of layer 1 of submatrix_1
`define START_PAGE_4_2  0 // starting page address of layer 2 of submatrix_1
//==========================================================================//
// Starting page address of base-matrix colmumn 5 and BS shift control
`define shift_factor_5_0 `CHECK_PARALLELISM-22
`define shift_factor_5_1 `CHECK_PARALLELISM-168
`define shift_factor_5_2 `CHECK_PARALLELISM-65	
`define START_PAGE_5_0  0 // starting page address of layer 0 of submatrix_1
`define START_PAGE_5_1  1 // starting page address of layer 1 of submatrix_1
`define START_PAGE_5_2  1 // starting page address of layer 2 of submatrix_1
//==========================================================================//
// Starting page address of base-matrix colmumn 6 and BS shift control
`define shift_factor_6_0 `CHECK_PARALLELISM-39
`define shift_factor_6_1 `CHECK_PARALLELISM-8
`define shift_factor_6_2 `CHECK_PARALLELISM-208
`define START_PAGE_6_0  0 // starting page address of layer 0 of submatrix_1
`define START_PAGE_6_1  0 // starting page address of layer 1 of submatrix_1
`define START_PAGE_6_2  2 // starting page address of layer 2 of submatrix_1
//==========================================================================//
// Starting page address of base-matrix colmumn 7 and BS shift control
`define shift_factor_7_0 `CHECK_PARALLELISM-20
`define shift_factor_7_1 `CHECK_PARALLELISM-110
`define shift_factor_7_2 `CHECK_PARALLELISM-125
`define START_PAGE_7_0  2 // starting page address of layer 0 of submatrix_1
`define START_PAGE_7_1  0 // starting page address of layer 1 of submatrix_1
`define START_PAGE_7_2  0 // starting page address of layer 2 of submatrix_1
//==========================================================================//
// Starting page address of base-matrix colmumn 8 and BS shift control
`define shift_factor_8_0 `CHECK_PARALLELISM-51
`define shift_factor_8_1 `CHECK_PARALLELISM-113
`define shift_factor_8_2 `CHECK_PARALLELISM-91
`define START_PAGE_8_0  1 // starting page address of layer 0 of submatrix_1
`define START_PAGE_8_1  0 // starting page address of layer 1 of submatrix_1
`define START_PAGE_8_2  1 // starting page address of layer 2 of submatrix_1
//==========================================================================//
// Starting page address of base-matrix colmumn 9 and BS shift control
`define shift_factor_9_0 `CHECK_PARALLELISM-50
`define shift_factor_9_1 `CHECK_PARALLELISM-105
`define shift_factor_9_2 `CHECK_PARALLELISM-100
`define START_PAGE_9_0  1 // starting page address of layer 0 of submatrix_1
`define START_PAGE_9_1  0 // starting page address of layer 1 of submatrix_1
`define START_PAGE_9_2  1 // starting page address of layer 2 of submatrix_1
//==========================================================================//
`ifdef SCHED_5_0_0
	// BS_0 shift control
	`define SHIFT_FACTOR_BS_0_0_0 `shift_factor_0_0 // relative col_0 @ layer 0
	`define SHIFT_FACTOR_BS_0_0_1 `shift_factor_0_1 // relative col_0 @ layer 1
	`define SHIFT_FACTOR_BS_0_0_2 `shift_factor_0_2 // relative col_0 @ layer 2
	`define SHIFT_FACTOR_BS_0_1_0 `shift_factor_2_0 // relative col_1 @ layer 0
	`define SHIFT_FACTOR_BS_0_1_1 `shift_factor_2_1 // relative col_1 @ layer 1
	`define SHIFT_FACTOR_BS_0_1_2 `shift_factor_2_2 // relative col_1 @ layer 2
	`define SHIFT_FACTOR_BS_0_2_0 `shift_factor_4_0 // relative col_2 @ layer 0
	`define SHIFT_FACTOR_BS_0_2_1 `shift_factor_4_1 // relative col_2 @ layer 1
	`define SHIFT_FACTOR_BS_0_2_2 `shift_factor_4_2 // relative col_2 @ layer 2
	`define SHIFT_FACTOR_BS_0_3_0 `shift_factor_6_0 // relative col_3 @ layer 0
	`define SHIFT_FACTOR_BS_0_3_1 `shift_factor_6_1 // relative col_3 @ layer 1
	`define SHIFT_FACTOR_BS_0_3_2 `shift_factor_6_2 // relative col_3 @ layer 2
	`define SHIFT_FACTOR_BS_0_4_0 `shift_factor_8_0 // relative col_4 @ layer 0
	`define SHIFT_FACTOR_BS_0_4_1 `shift_factor_8_1 // relative col_4 @ layer 1
	`define SHIFT_FACTOR_BS_0_4_2 `shift_factor_8_2 // relative col_4 @ layer 2
	// Relative Column Location 0 of BS_0 
	`define START_PAGE_BS_0_0_0  `START_PAGE_0_0 // starting page address of layer 0 of BS_0
	`define START_PAGE_BS_0_0_1  `START_PAGE_0_1 // starting page address of layer 1 of BS_0
	`define START_PAGE_BS_0_0_2  `START_PAGE_0_2 // starting page address of layer 2 of BS_0
	// Relative Column Location 1 of BS_0
	`define START_PAGE_BS_0_1_0  `START_PAGE_2_0 // starting page address of layer 0 of BS_0
	`define START_PAGE_BS_0_1_1  `START_PAGE_2_1 // starting page address of layer 1 of BS_0
	`define START_PAGE_BS_0_1_2  `START_PAGE_2_2 // starting page address of layer 2 of BS_0
	// Relative Column Location 2 of BS_0
	`define START_PAGE_BS_0_2_0  `START_PAGE_4_0 // starting page address of layer 0 of BS_0
	`define START_PAGE_BS_0_2_1  `START_PAGE_4_1 // starting page address of layer 1 of BS_0
	`define START_PAGE_BS_0_2_2  `START_PAGE_4_2 // starting page address of layer 2 of BS_0
	// Relative Column Location 3 of BS_0
	`define START_PAGE_BS_0_3_0  `START_PAGE_6_0 // starting page address of layer 0 of BS_0
	`define START_PAGE_BS_0_3_1  `START_PAGE_6_1 // starting page address of layer 1 of BS_0
	`define START_PAGE_BS_0_3_2  `START_PAGE_6_2 // starting page address of layer 2 of BS_0
	// Relative Column Location 4 of BS_0
	`define START_PAGE_BS_0_4_0  `START_PAGE_8_0 // starting page address of layer 0 of BS_0
	`define START_PAGE_BS_0_4_1  `START_PAGE_8_1 // starting page address of layer 1 of BS_0
	`define START_PAGE_BS_0_4_2  `START_PAGE_8_2 // starting page address of layer 2 of BS_0
	//--------------------------------------------------------------------------------------//
	// BS_1 shift control
	`define SHIFT_FACTOR_BS_1_0_0 `shift_factor_1_0 // relative col_0 @ layer 0
	`define SHIFT_FACTOR_BS_1_0_1 `shift_factor_1_1 // relative col_0 @ layer 1
	`define SHIFT_FACTOR_BS_1_0_2 `shift_factor_1_2 // relative col_0 @ layer 2
	`define SHIFT_FACTOR_BS_1_1_0 `shift_factor_3_0 // relative col_1 @ layer 0
	`define SHIFT_FACTOR_BS_1_1_1 `shift_factor_3_1 // relative col_1 @ layer 1
	`define SHIFT_FACTOR_BS_1_1_2 `shift_factor_3_2 // relative col_1 @ layer 2
	`define SHIFT_FACTOR_BS_1_2_0 `shift_factor_5_0 // relative col_2 @ layer 0
	`define SHIFT_FACTOR_BS_1_2_1 `shift_factor_5_1 // relative col_2 @ layer 1
	`define SHIFT_FACTOR_BS_1_2_2 `shift_factor_5_2 // relative col_2 @ layer 2
	`define SHIFT_FACTOR_BS_1_3_0 `shift_factor_7_0 // relative col_3 @ layer 0
	`define SHIFT_FACTOR_BS_1_3_1 `shift_factor_7_1 // relative col_3 @ layer 1
	`define SHIFT_FACTOR_BS_1_3_2 `shift_factor_7_2 // relative col_3 @ layer 2
	`define SHIFT_FACTOR_BS_1_4_0 `shift_factor_9_0 // relative col_4 @ layer 0
	`define SHIFT_FACTOR_BS_1_4_1 `shift_factor_9_1 // relative col_4 @ layer 1
	`define SHIFT_FACTOR_BS_1_4_2 `shift_factor_9_2 // relative col_4 @ layer 2
	// Relative Column Location 0 of BS_1
	`define START_PAGE_BS_1_0_0  `START_PAGE_1_0 // starting page address of layer 0 of BS_1
	`define START_PAGE_BS_1_0_1  `START_PAGE_1_1 // starting page address of layer 1 of BS_1
	`define START_PAGE_BS_1_0_2  `START_PAGE_1_2 // starting page address of layer 2 of BS_1
	// Relative Column Location 1 of BS_1
	`define START_PAGE_BS_1_1_0  `START_PAGE_3_0 // starting page address of layer 0 of BS_1
	`define START_PAGE_BS_1_1_1  `START_PAGE_3_1 // starting page address of layer 1 of BS_1
	`define START_PAGE_BS_1_1_2  `START_PAGE_3_2 // starting page address of layer 2 of BS_1
	// Relative Column Location 2 of BS_1
	`define START_PAGE_BS_1_2_0  `START_PAGE_5_0 // starting page address of layer 0 of BS_1
	`define START_PAGE_BS_1_2_1  `START_PAGE_5_1 // starting page address of layer 1 of BS_1
	`define START_PAGE_BS_1_2_2  `START_PAGE_5_2 // starting page address of layer 2 of BS_1
	// Relative Column Location 3 of BS_1
	`define START_PAGE_BS_1_3_0  `START_PAGE_7_0 // starting page address of layer 0 of BS_1
	`define START_PAGE_BS_1_3_1  `START_PAGE_7_1 // starting page address of layer 1 of BS_1
	`define START_PAGE_BS_1_3_2  `START_PAGE_7_2 // starting page address of layer 2 of BS_1
	// Relative Column Location 4 of BS_1
	`define START_PAGE_BS_1_4_0  `START_PAGE_9_0 // starting page address of layer 0 of BS_1
	`define START_PAGE_BS_1_4_1  `START_PAGE_9_1 // starting page address of layer 1 of BS_1
	`define START_PAGE_BS_1_4_2  `START_PAGE_9_2 // starting page address of layer 2 of BS_1
`endif // SCHED_5_0_0
