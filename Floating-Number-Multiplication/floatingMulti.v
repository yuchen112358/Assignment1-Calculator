`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:21:29 04/11/2015 
// Design Name: 
// Module Name:    floatingMulti 
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
module floatingMulti(
input wire [31:0] multiplierA,
input wire [31:0] multiplierB,
input wire start,
input wire clk,
output wire [31:0] product
    );
reg [31:0] m1;
reg [31:0] m2;
reg [31:0] m;
reg s;
reg [7:0] e1;
reg [7:0] e2;
reg [7:0] e;
reg [63:0] multiRes;
reg [63:0] intRes;
initial begin
	e1<=multiplierA[30:23];
	e2<=multiplierB[30:23];
	m1<={8'b0,1'b1,multiplierA[22:0]};
	m2<={8'b0,1'b1,multiplierB[22:0]};
	s<=multiplierA[31]^multiplierB[31];
end
IntegerMultiplication intMulti32(.A(m1),
											.B(m2),
											.start(start),
											.clk(clk),
											.procuct(intRes)
											);
always @(*) begin
	if((multiplierA==32'b0)||(multiplierB==32'b0))
	begin
	multiRes <= 64'b0;
	end
	else begin
	e=e1+e2-127;
	while(intRes[31:24]!=8'b0)begin
	intRes<=intRes>>1;
	e=e+1;
	end
	while(~intRes[23]) begin
	intRes<=intRes<<1;
	e=e-1;
	end//考虑输入非格式化数
	if(e>=1&&e<=254)begin
	multiRes[31]=s;
	multiRes[30:23]=e;
	multiRes[22:0]=intRes[22:0];
	end
	else begin
	multiRes[31]=s;
	multiRes[30:23]=255;
	multiRes[22:0]=1;//溢出，结果为NaN
	end
	end
end
endmodule
