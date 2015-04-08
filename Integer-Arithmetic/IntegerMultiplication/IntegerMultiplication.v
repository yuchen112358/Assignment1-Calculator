module IntegerMultiplication(
	input [31:0] A,
	input [31:0] B,
	output [63:0] product,
	input start,
	input clk
	);
	reg [65:0] accumulator;
	unsigned reg [5:0] count;
	wire [32:0] B2n,B1n,B1,B2,addend;
	reg [63:0] result;

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
	count <= 0;
end

AdderAndSubber64 adder({31'0,accumulator[65:33]},{31'0,addend},0,result,SF,CF,OF,PF,ZF);

assign addend = 
	case(accumulator[2:0])
		3'000: 0;
		3'001: B1;
		3'010: B1;
		3'011: B2;
		3'100: B2n;
		3'101: B1n;
		3'110: B1n;
		3'111: 0;
;

always @(posedge clk) begin
	if (count < 32) begin //accmulating
		if(count[0]) begin
			accumulator[65:33] <= result[32:0];
		end
		else begin
			accumulator <= accumulator>>>2;
		end
		count <= count + 1;
	end
	else if ( count == 32 && start) begin //initial
		accumulator[65:33] <= 0;
		accumulator[32:1] <= A;
		accumulator[0] <=0;
		count <= 0;
	end
	else begin
		accumulator <= accumulator;
		count <= 32;
	end
end

assign product = accumulator[64:1];

endmodule