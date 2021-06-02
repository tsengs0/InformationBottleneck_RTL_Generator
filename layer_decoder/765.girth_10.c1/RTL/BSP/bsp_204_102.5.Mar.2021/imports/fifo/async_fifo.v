module async_fifo #(
	parameter WA = 2,
	parameter WD = 204
) (
	output reg[WD-1:0] rdat,   // read data
	output reg rempty,  // read empty
	output reg wfull,   // write full
	
	input wire [WD-1:0] wdat, // write data
	input wire wen,         // write enable
	input wire ren,         // read enable
	
	input wire wclk,        // write clock
	input wire rclk,        // read clock
	input wire rstn         // reset
);

reg[WA:0] wadr_reg;
reg[WA:0] radr_reg;
reg[WA:0] wptr_reg,wptr0_reg,wptr1_reg;
reg[WA:0] rptr_reg,rptr0_reg,rptr1_reg;
wire[WA:0] next_wadr,next_wptr;
wire[WA:0] next_radr,next_rptr;
reg[WD-1:0] ram[0:2**WA-1];
/************************************************************
 * DPM
 ***********************************************************/
always @(posedge wclk)
  if(wen) ram[wadr_reg[WA-1:0]] <= wdat;

always @(posedge rclk)
  if(ren) rdat <= ram[radr_reg[WA-1:0]];
/************************************************************
 * wclk domain
 ***********************************************************/
/* write address */
always @(posedge wclk, negedge rstn) begin
  if(rstn == 1'b0)
    {wadr_reg,wptr_reg} <= {{(WA+1){1'b0}},{(WA+1){1'b0}}};
  else if(wen)
    {wadr_reg,wptr_reg} <= {next_wadr,next_wptr};
end
assign next_wadr = wadr_reg + (wen & ~wfull);     // binary
assign next_wptr = next_wadr ^ (next_wadr>>1'b1); // grey

/* cdc transfer of rptr */
always @(posedge wclk, negedge rstn) begin
	if(rstn == 1'b0)
		{rptr1_reg,rptr0_reg} <= {{(WA+1){1'b0}},{(WA+1){1'b0}}};
	else
		{rptr1_reg,rptr0_reg} <= {rptr0_reg,rptr_reg};
end

/* full flag */
always @(posedge wclk, negedge rstn) begin
	if(rstn == 1'b0)
		wfull <= 1'b0;
	else if(next_wptr=={~rptr1_reg[WA:WA-1],rptr1_reg[WA-2:0]})
		wfull <= 1'b1;
	else
		wfull <= 1'b0;
end
/************************************************************
 * rclk domain
 ***********************************************************/
/* read address */
always @(posedge rclk, negedge rstn) begin
	if(rstn == 1'b0)
		{radr_reg,rptr_reg} <= {{(WA+1){1'b0}},{(WA+1){1'b0}}};
	else if(ren)
		{radr_reg,rptr_reg} <= {next_radr,next_rptr};
end
assign next_radr = radr_reg + (ren & ~rempty);    // binary
assign next_rptr = next_radr ^ (next_radr >> 1);  // grey

/* cdc transfer of wptr */
always @(posedge rclk, negedge rstn ) begin
	if(rstn == 1'b0)
		{wptr1_reg,wptr0_reg} <= {{(WA+1){1'b0}},{(WA+1){1'b0}}};
	else
		{wptr1_reg,wptr0_reg} <= {wptr0_reg,wptr_reg};
end

/* empty flag */
always @(posedge rclk, negedge rstn) begin
	if(rstn == 1'b0)
		rempty <= 1'b1;
	else if(next_rptr==wptr1_reg)
		rempty <= 1'b1;
	else
		rempty <= 1'b0;
end
endmodule