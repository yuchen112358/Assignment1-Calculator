 module IntegerDivision(
	input [63:0] Dividend,
	input [31:0] Divisor,
	output[63:0] quotient,
	output[31:0] remainder,
	input start,
	input clk
	);

	reg [8:0] count;
	reg [96:0] tmp;
	reg oldStart;
	wire [33:0] nDivisor;
	wire [33:0] pDivisor;
	wire [63:0] result;
	wire [33:0] addend;

initial begin
	count <= 129;
	tmp <= 0;
end

assign	pDivisor[33] = 0, 	
				pDivisor[32] = 0,
				pDivisor[31:0] = Divisor;
assign	nDivisor = -pDivisor;
assign 	addend = {34{tmp[96]}} & pDivisor | {34{!tmp[96]}} & nDivisor;


AdderAndSubber64 adder({30'b0,tmp[96:63]},{30'b0,addend},1'b0,result,SF,CF,OF,PF,ZF);

always @(posedge clk) begin
	if (count <= 128) begin
		if (count < 127) begin
			if (count[0]) begin
				tmp[96:1] <= tmp[95:0];
				tmp[0] <= ~tmp[96];
			end
			else begin
				tmp[96:63] <= result[33:0];
			end
		end
		else if ( count == 127 ) begin
			if ( tmp[96] ) begin
				tmp[95:63] <= result[32:0];
			end
		end
		else if ( count == 128 ) begin
			tmp[96:1] <= tmp[95:0];
			tmp[0] <= ~tmp[96];
		end
		count <= count + 1;

	end	
	else if ( count > 128 && (start != oldStart)) begin
		tmp[63:0] <= Dividend;
		tmp[96:64] <= 0;
		count <= 0;
	end
	else begin
		tmp <= tmp;
		count <= 129;
	end
	oldStart <= start;
end

assign quotient = tmp[63:0];
assign remainder = tmp[95:64];

endmodule
