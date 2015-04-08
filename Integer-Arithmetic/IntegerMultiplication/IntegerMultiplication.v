`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:22:09 04/08/2015 
// Design Name: 
// Module Name:    IntegerMultiplication 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module IntegerMultiplication(
	input [31:0] A,
	input [31:0] B,
	output [63:0] product,
	/*
	output [65:0] accu,
	output [63:0] res,
	output [6:0] count,
	output [32:0] bn2,
	output [32:0] bn1,
	output [32:0] bp1,
	output [32:0] bp2,
	output [32:0] adden,
*/
	input start,
	input clk
	);
	reg [65:0] accumulator;
	reg [6:0] cnt;
	wire [32:0] B2n,B1n,B1,B2,addend;
	wire [63:0] result;
/*
assign accu=accumulator,
		res=result,
		count =cnt,
		bn2 = B2n,
		bn1 = B1n,
		bp1 = B1,
		bp2 = B2,
		adden = addend;
*/
assign 	B1n[31:0] = -B,
		B2n[31:0] = (-B)<<1,
		B1[31:0] = B,
		B2[31:0] = B<<1,
		B1n[32] = ~B[31],
		B2n[32] = ~B[31],
		B1[32] = B[31],
		B2[32] = B[31];

initial begin
	accumulator[65:33] <= 0;
	accumulator[32:1] <= A;
	accumulator[0] <=0;
	cnt <= 32;
end

AdderAndSubber64 adder({31'b0,accumulator[65:33]},{31'b0,addend},1'b0,result,SF,CF,OF,PF,ZF);

assign addend =	{33{~accumulator[2]&~accumulator[1]&~accumulator[0]}}&33'b0|
						{33{~accumulator[2]&~accumulator[1]& accumulator[0]}}&B1|
						{33{~accumulator[2]& accumulator[1]&~accumulator[0]}}&B1|
						{33{~accumulator[2]& accumulator[1]& accumulator[0]}}&B2|
						{33{ accumulator[2]&~accumulator[1]&~accumulator[0]}}&B2n|
						{33{ accumulator[2]&~accumulator[1]& accumulator[0]}}&B1n|
						{33{ accumulator[2]& accumulator[1]&~accumulator[0]}}&B1n|
						{33{ accumulator[2]& accumulator[1]& accumulator[0]}}&33'b0
						;
//	case(accumulator[2:0])
//		3'b000: 0;
//		3'b001: B1;
//		3'b010: B1;
//		3'b011: B2;
//		3'b100: B2n;
//		3'b101: B1n;
//		3'b110: B1n;
//		3'b111: 0;
//	endcase

always @(posedge clk) begin
	if (cnt < 32) begin //accmulating
		if(cnt[0]) begin
			accumulator[63:0] <= accumulator>>>2;
			accumulator[64] <= accumulator[65];
			accumulator[65] <= accumulator[65];
		end
		else begin
			accumulator[65:33] <= result[32:0];
		end
		cnt <= cnt + 1;
	end
	else if ( cnt == 32 && start) begin //initial
		accumulator[65:33] <= 0;
		accumulator[32:1] <= A;
		accumulator[0] <=0;
		cnt <= 0;
	end
	else begin
		accumulator <= accumulator;
		cnt <= 6'd32;
	end
end

assign product = accumulator[64:1];

endmodule
