`include "define.vh"

module qsn_controller_85b #(
	parameter [$clog2(85)-1:0] PERMUTATION_LENGTH = 85
) (
`ifdef SCHED_4_6
	output wire [6:0] left_sel,
	output wire [6:0] right_sel,
	output wire [83:0] merge_sel,
`else
	output reg [6:0] left_sel,
	output reg [6:0] right_sel,
	output reg [83:0] merge_sel,
`endif
	input wire sys_clk,
	input wire rstn,
	input wire [6:0] shift_factor
);

	wire shifter_nonzero;
	assign shifter_nonzero = (|shift_factor[6:0]);

`ifdef SCHED_4_6
	assign left_sel  = (shifter_nonzero == 1'b1) ? shift_factor : 0;
	assign right_sel = (shifter_nonzero == 1'b1) ? 85-shift_factor : 0;

	assign merge_sel[83:0] = f(shift_factor[6:0]);
	function [83:0] f(input [6:0] shift_in);
			case(shift_in[6:0])
				1	:	 f = 84'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
				2	:	 f = 84'b011111111111111111111111111111111111111111111111111111111111111111111111111111111111;
				3	:	 f = 84'b001111111111111111111111111111111111111111111111111111111111111111111111111111111111;
				4	:	 f = 84'b000111111111111111111111111111111111111111111111111111111111111111111111111111111111;
				5	:	 f = 84'b000011111111111111111111111111111111111111111111111111111111111111111111111111111111;
				6	:	 f = 84'b000001111111111111111111111111111111111111111111111111111111111111111111111111111111;
				7	:	 f = 84'b000000111111111111111111111111111111111111111111111111111111111111111111111111111111;
				8	:	 f = 84'b000000011111111111111111111111111111111111111111111111111111111111111111111111111111;
				9	:	 f = 84'b000000001111111111111111111111111111111111111111111111111111111111111111111111111111;
				10	:	 f = 84'b000000000111111111111111111111111111111111111111111111111111111111111111111111111111;
				11	:	 f = 84'b000000000011111111111111111111111111111111111111111111111111111111111111111111111111;
				12	:	 f = 84'b000000000001111111111111111111111111111111111111111111111111111111111111111111111111;
				13	:	 f = 84'b000000000000111111111111111111111111111111111111111111111111111111111111111111111111;
				14	:	 f = 84'b000000000000011111111111111111111111111111111111111111111111111111111111111111111111;
				15	:	 f = 84'b000000000000001111111111111111111111111111111111111111111111111111111111111111111111;
				16	:	 f = 84'b000000000000000111111111111111111111111111111111111111111111111111111111111111111111;
				17	:	 f = 84'b000000000000000011111111111111111111111111111111111111111111111111111111111111111111;
				18	:	 f = 84'b000000000000000001111111111111111111111111111111111111111111111111111111111111111111;
				19	:	 f = 84'b000000000000000000111111111111111111111111111111111111111111111111111111111111111111;
				20	:	 f = 84'b000000000000000000011111111111111111111111111111111111111111111111111111111111111111;
				21	:	 f = 84'b000000000000000000001111111111111111111111111111111111111111111111111111111111111111;
				22	:	 f = 84'b000000000000000000000111111111111111111111111111111111111111111111111111111111111111;
				23	:	 f = 84'b000000000000000000000011111111111111111111111111111111111111111111111111111111111111;
				24	:	 f = 84'b000000000000000000000001111111111111111111111111111111111111111111111111111111111111;
				25	:	 f = 84'b000000000000000000000000111111111111111111111111111111111111111111111111111111111111;
				26	:	 f = 84'b000000000000000000000000011111111111111111111111111111111111111111111111111111111111;
				27	:	 f = 84'b000000000000000000000000001111111111111111111111111111111111111111111111111111111111;
				28	:	 f = 84'b000000000000000000000000000111111111111111111111111111111111111111111111111111111111;
				29	:	 f = 84'b000000000000000000000000000011111111111111111111111111111111111111111111111111111111;
				30	:	 f = 84'b000000000000000000000000000001111111111111111111111111111111111111111111111111111111;
				31	:	 f = 84'b000000000000000000000000000000111111111111111111111111111111111111111111111111111111;
				32	:	 f = 84'b000000000000000000000000000000011111111111111111111111111111111111111111111111111111;
				33	:	 f = 84'b000000000000000000000000000000001111111111111111111111111111111111111111111111111111;
				34	:	 f = 84'b000000000000000000000000000000000111111111111111111111111111111111111111111111111111;
				35	:	 f = 84'b000000000000000000000000000000000011111111111111111111111111111111111111111111111111;
				36	:	 f = 84'b000000000000000000000000000000000001111111111111111111111111111111111111111111111111;
				37	:	 f = 84'b000000000000000000000000000000000000111111111111111111111111111111111111111111111111;
				38	:	 f = 84'b000000000000000000000000000000000000011111111111111111111111111111111111111111111111;
				39	:	 f = 84'b000000000000000000000000000000000000001111111111111111111111111111111111111111111111;
				40	:	 f = 84'b000000000000000000000000000000000000000111111111111111111111111111111111111111111111;
				41	:	 f = 84'b000000000000000000000000000000000000000011111111111111111111111111111111111111111111;
				42	:	 f = 84'b000000000000000000000000000000000000000001111111111111111111111111111111111111111111;
				43	:	 f = 84'b000000000000000000000000000000000000000000111111111111111111111111111111111111111111;
				44	:	 f = 84'b000000000000000000000000000000000000000000011111111111111111111111111111111111111111;
				45	:	 f = 84'b000000000000000000000000000000000000000000001111111111111111111111111111111111111111;
				46	:	 f = 84'b000000000000000000000000000000000000000000000111111111111111111111111111111111111111;
				47	:	 f = 84'b000000000000000000000000000000000000000000000011111111111111111111111111111111111111;
				48	:	 f = 84'b000000000000000000000000000000000000000000000001111111111111111111111111111111111111;
				49	:	 f = 84'b000000000000000000000000000000000000000000000000111111111111111111111111111111111111;
				50	:	 f = 84'b000000000000000000000000000000000000000000000000011111111111111111111111111111111111;
				51	:	 f = 84'b000000000000000000000000000000000000000000000000001111111111111111111111111111111111;
				52	:	 f = 84'b000000000000000000000000000000000000000000000000000111111111111111111111111111111111;
				53	:	 f = 84'b000000000000000000000000000000000000000000000000000011111111111111111111111111111111;
				54	:	 f = 84'b000000000000000000000000000000000000000000000000000001111111111111111111111111111111;
				55	:	 f = 84'b000000000000000000000000000000000000000000000000000000111111111111111111111111111111;
				56	:	 f = 84'b000000000000000000000000000000000000000000000000000000011111111111111111111111111111;
				57	:	 f = 84'b000000000000000000000000000000000000000000000000000000001111111111111111111111111111;
				58	:	 f = 84'b000000000000000000000000000000000000000000000000000000000111111111111111111111111111;
				59	:	 f = 84'b000000000000000000000000000000000000000000000000000000000011111111111111111111111111;
				60	:	 f = 84'b000000000000000000000000000000000000000000000000000000000001111111111111111111111111;
				61	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000111111111111111111111111;
				62	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000011111111111111111111111;
				63	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000001111111111111111111111;
				64	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000111111111111111111111;
				65	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000011111111111111111111;
				66	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000001111111111111111111;
				67	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000111111111111111111;
				68	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000011111111111111111;
				69	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000001111111111111111;
				70	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000111111111111111;
				71	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000011111111111111;
				72	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000001111111111111;
				73	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000000111111111111;
				74	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000000011111111111;
				75	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000000001111111111;
				76	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000111111111;
				77	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000011111111;
				78	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000001111111;
				79	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000000111111;
				80	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000000011111;
				81	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000000001111;
				82	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000000000111;
				83	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000000000011;
				84	:	 f = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
				default	:	f = 0;
			endcase // shift_factor
		endfunction


`else
	always @(posedge sys_clk) begin

		if(!rstn) left_sel <= 0;
		else if(shifter_nonzero == 1'b1) begin
			left_sel  <= shift_factor;
		end
		else begin
			left_sel  <= 0;
		end
	end
	always @(posedge sys_clk) begin

		if(!rstn) right_sel <= 0;
		else if(shifter_nonzero == 1'b1) begin
			right_sel <=  85-shift_factor;
		end
		else begin
			right_sel <= 0;
		end
	end
	always @(posedge sys_clk) begin
		if(!rstn) merge_sel <= 0;
		else if(shifter_nonzero == 1'b1) begin
			case(shift_factor[6:0])
				1	:	 merge_sel[83:0] = 84'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
				2	:	 merge_sel[83:0] = 84'b011111111111111111111111111111111111111111111111111111111111111111111111111111111111;
				3	:	 merge_sel[83:0] = 84'b001111111111111111111111111111111111111111111111111111111111111111111111111111111111;
				4	:	 merge_sel[83:0] = 84'b000111111111111111111111111111111111111111111111111111111111111111111111111111111111;
				5	:	 merge_sel[83:0] = 84'b000011111111111111111111111111111111111111111111111111111111111111111111111111111111;
				6	:	 merge_sel[83:0] = 84'b000001111111111111111111111111111111111111111111111111111111111111111111111111111111;
				7	:	 merge_sel[83:0] = 84'b000000111111111111111111111111111111111111111111111111111111111111111111111111111111;
				8	:	 merge_sel[83:0] = 84'b000000011111111111111111111111111111111111111111111111111111111111111111111111111111;
				9	:	 merge_sel[83:0] = 84'b000000001111111111111111111111111111111111111111111111111111111111111111111111111111;
				10	:	 merge_sel[83:0] = 84'b000000000111111111111111111111111111111111111111111111111111111111111111111111111111;
				11	:	 merge_sel[83:0] = 84'b000000000011111111111111111111111111111111111111111111111111111111111111111111111111;
				12	:	 merge_sel[83:0] = 84'b000000000001111111111111111111111111111111111111111111111111111111111111111111111111;
				13	:	 merge_sel[83:0] = 84'b000000000000111111111111111111111111111111111111111111111111111111111111111111111111;
				14	:	 merge_sel[83:0] = 84'b000000000000011111111111111111111111111111111111111111111111111111111111111111111111;
				15	:	 merge_sel[83:0] = 84'b000000000000001111111111111111111111111111111111111111111111111111111111111111111111;
				16	:	 merge_sel[83:0] = 84'b000000000000000111111111111111111111111111111111111111111111111111111111111111111111;
				17	:	 merge_sel[83:0] = 84'b000000000000000011111111111111111111111111111111111111111111111111111111111111111111;
				18	:	 merge_sel[83:0] = 84'b000000000000000001111111111111111111111111111111111111111111111111111111111111111111;
				19	:	 merge_sel[83:0] = 84'b000000000000000000111111111111111111111111111111111111111111111111111111111111111111;
				20	:	 merge_sel[83:0] = 84'b000000000000000000011111111111111111111111111111111111111111111111111111111111111111;
				21	:	 merge_sel[83:0] = 84'b000000000000000000001111111111111111111111111111111111111111111111111111111111111111;
				22	:	 merge_sel[83:0] = 84'b000000000000000000000111111111111111111111111111111111111111111111111111111111111111;
				23	:	 merge_sel[83:0] = 84'b000000000000000000000011111111111111111111111111111111111111111111111111111111111111;
				24	:	 merge_sel[83:0] = 84'b000000000000000000000001111111111111111111111111111111111111111111111111111111111111;
				25	:	 merge_sel[83:0] = 84'b000000000000000000000000111111111111111111111111111111111111111111111111111111111111;
				26	:	 merge_sel[83:0] = 84'b000000000000000000000000011111111111111111111111111111111111111111111111111111111111;
				27	:	 merge_sel[83:0] = 84'b000000000000000000000000001111111111111111111111111111111111111111111111111111111111;
				28	:	 merge_sel[83:0] = 84'b000000000000000000000000000111111111111111111111111111111111111111111111111111111111;
				29	:	 merge_sel[83:0] = 84'b000000000000000000000000000011111111111111111111111111111111111111111111111111111111;
				30	:	 merge_sel[83:0] = 84'b000000000000000000000000000001111111111111111111111111111111111111111111111111111111;
				31	:	 merge_sel[83:0] = 84'b000000000000000000000000000000111111111111111111111111111111111111111111111111111111;
				32	:	 merge_sel[83:0] = 84'b000000000000000000000000000000011111111111111111111111111111111111111111111111111111;
				33	:	 merge_sel[83:0] = 84'b000000000000000000000000000000001111111111111111111111111111111111111111111111111111;
				34	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000111111111111111111111111111111111111111111111111111;
				35	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000011111111111111111111111111111111111111111111111111;
				36	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000001111111111111111111111111111111111111111111111111;
				37	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000111111111111111111111111111111111111111111111111;
				38	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000011111111111111111111111111111111111111111111111;
				39	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000001111111111111111111111111111111111111111111111;
				40	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000111111111111111111111111111111111111111111111;
				41	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000011111111111111111111111111111111111111111111;
				42	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000001111111111111111111111111111111111111111111;
				43	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000111111111111111111111111111111111111111111;
				44	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000011111111111111111111111111111111111111111;
				45	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000001111111111111111111111111111111111111111;
				46	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000111111111111111111111111111111111111111;
				47	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000011111111111111111111111111111111111111;
				48	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000001111111111111111111111111111111111111;
				49	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000111111111111111111111111111111111111;
				50	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000011111111111111111111111111111111111;
				51	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000001111111111111111111111111111111111;
				52	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000111111111111111111111111111111111;
				53	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000011111111111111111111111111111111;
				54	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000001111111111111111111111111111111;
				55	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000111111111111111111111111111111;
				56	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000011111111111111111111111111111;
				57	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000001111111111111111111111111111;
				58	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000111111111111111111111111111;
				59	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000011111111111111111111111111;
				60	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000001111111111111111111111111;
				61	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000111111111111111111111111;
				62	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000011111111111111111111111;
				63	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000001111111111111111111111;
				64	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000111111111111111111111;
				65	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000011111111111111111111;
				66	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000001111111111111111111;
				67	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000111111111111111111;
				68	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000011111111111111111;
				69	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000001111111111111111;
				70	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000111111111111111;
				71	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000011111111111111;
				72	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000001111111111111;
				73	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000000111111111111;
				74	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000000011111111111;
				75	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000000001111111111;
				76	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000111111111;
				77	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000011111111;
				78	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000001111111;
				79	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000000111111;
				80	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000000011111;
				81	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000000001111;
				82	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000000000111;
				83	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000000000011;
				84	:	 merge_sel[83:0] = 84'b000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
				default	:	merge_sel[83:0] = 0;
			endcase // shift_factor
		end
		else begin
			merge_sel[83:0] <= {84{1'b1}};
		end
	end
`endif
endmodule