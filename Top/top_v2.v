`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:51:52 04/07/2015 
// Design Name: 
// Module Name:    top 
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
`include "defines.v"
module top(
input wire clk,
input wire [5:0] switch,
input wire [7:0]btn_in,
output wire [7:0]anode,
output wire [7:0]segment
    );
wire[31:0] displaynum32;
wire[63:0] adderResult;
wire[63:0] minusResult;
wire[63:0] multiResult;
wire[63:0] divResult;
wire[31:0] intRemainder;
wire[63:0] fadderResult;
wire[63:0] fminusResult;
wire[63:0] fmultiResult;
wire[63:0] fdivResult;
wire[63:0] andResult;
wire[63:0] orResult;
wire[63:0] notResult;
wire[63:0] tempA,tempB;
wire[7:0] btn_out;
wire aSF,aCF,aOF,aPF,aZF;
wire mSF,mCF,mOF,mPF,mZF;
reg addMode;
reg minusMode;
reg[31:0] A,B;
reg[63:0] result;
initial  begin 
	A=32'b0;
	B=32'b0;
	addMode=1'b0;
	minusMode=1'b1;
end
pbdebounce p0(clk,btn_in[0],btn_out[0]);//去抖程序
pbdebounce p1(clk,btn_in[1],btn_out[1]);
pbdebounce p2(clk,btn_in[2],btn_out[2]);
pbdebounce p3(clk,btn_in[3],btn_out[3]);
pbdebounce p4(clk,btn_in[4],btn_out[4]);
pbdebounce p5(clk,btn_in[5],btn_out[5]);
pbdebounce p6(clk,btn_in[6],btn_out[6]);
pbdebounce p7(clk,btn_in[7],btn_out[7]);
always @(posedge btn_out[0]) begin //switch[0]高电平是A，低电平是B
if(switch[0])A[ 3: 0]<= A[ 3: 0] + 4'd1;
	else B[ 3: 0]<= B[ 3: 0] + 4'd1;
end

always @(posedge btn_out[1]) begin  
if(switch[0])A[ 7: 4]<= A[ 7: 4] + 4'd1;
	else B[ 7: 4]<= B[ 7: 4] + 4'd1;
end

always @(posedge btn_out[2]) begin  
if(switch[0])A[ 11: 8]<= A[ 11: 8] + 4'd1;
	else B[ 11: 8]<= B[ 11: 8] + 4'd1;
end

always @(posedge btn_out[3]) begin  
if(switch[0])A[ 15: 12]<= A[ 15: 12] + 4'd1;
	else B[ 15: 12]<= B[ 15: 12] + 4'd1;
end

always @(posedge btn_out[4]) begin  
if(switch[0])A[ 19: 16]<= A[ 19: 16] + 4'd1;
	else B[ 19: 16]<= B[ 19: 16] + 4'd1;
end

always @(posedge btn_out[5]) begin  
if(switch[0])A[ 23: 20]<= A[ 23: 20] + 4'd1;
	else B[ 23: 20]<= B[ 23: 20] + 4'd1;
end

always @(posedge btn_out[6]) begin  
if(switch[0])A[ 27: 24]<= A[ 27: 24] + 4'd1;
	else B[ 27: 24]<= B[ 27: 24] + 4'd1;
end

always @(posedge btn_out[7]) begin  
if(switch[0])A[ 31: 28]<= A[ 31: 28] + 4'd1;
	else B[ 31: 28]<= B[ 31: 28] + 4'd1;
end
assign tempA={32'b0,A};
assign tempB={32'b0,B};
AdderAndSubber64 add64(.A(tempA),
						 .B(tempB),
						 .mode(addMode),
						 .result(adderResult),
						 .SF(aSF),
						 .CF(aCF),
						 .OF(aOF),
						 .PF(aPF),
						 .ZF(aZF)
							 );
AdderAndSubber64 minus64(.A(tempA),
						 .B(tempB),
						 .mode(minusMode),
						 .result(minusResult),
						 .SF(mSF),
						 .CF(mCF),
						 .OF(mOF),
						 .PF(mPF),
						 .ZF(mZF)
							 );
IntegerMultiplication multi32(.A(A),
							 .B(B),
							 .start(switch[1]),
							 .clk(clk),
							 .product(multiResult)
							 );
IntegerDivision div64(
							.Dividend(tempA),
							.Divisor(B),
							.start(switch[1]),
							.clk(clk),
							.quotient(divResult),
							.remainder(intRemainder)
	);
floatadder fadd64(.op1(tempA),
						.op2(tempB),
						.res(fadderResult)
						);
floatsub fsub64(.op1(tempA),
					 .op2(tempB),
					 .res(fminusResult)
					 );
floatingMulti fmulti32(.multiplierA(A),
                       .multiplierB(B),
							  .start(switch[1]),
							  .clk(clk),
							  .product(fmultiResult)
							  );
divider fdivider32(.divident(A),
						 .divisor(B),
						 .quotient(fdivResult)
						 );
always @(*) begin
	case (switch[5:2])
	`Plus:begin
	result = adderResult;
	end
	`Minus:begin
	result = minusResult;
	end
	`Multi:begin
	result = multiResult;
	end
	`Div:begin
	result = divResult;
	end 
	`FloatPlus:begin
	result = fadderResult;
	end
	`FloatMinus:begin
	result = fminusResult;
	end 
	`FloatMulti:begin
	result = fmultiResult;
	end 
	`FloatDiv:begin
	result = fdivResult;
	end 
	`AndLogic:begin
	result = andResult;
	end
	`OrLogic:begin
	result = orResult;
	end
	`NotLogic:begin
	result = notResult;
	end
	default:begin
	result = 64'b0;
	end
	endcase
end
assign displaynum32 = (A&{32{switch[0]}}&{32{~switch[1]}})
							|(B&{32{~switch[0]}}&{32{~switch[1]}})
							|(result[31:0]&{32{switch[1]}});
display32 dis32(
	.clk(clk),
	.disp_num(displaynum32),
	.digit_anode(anode),
	.segment(segment)
	);
endmodule
