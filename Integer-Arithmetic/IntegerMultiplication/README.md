乘法器模块：

module IntegerMultiplication(
	input [31:0] A,
	input [31:0] B,
	output [63:0] product,
	input start,
	input clk
	);
	
	输入A，B是乘数，各32位;
	输出product是积，64位;
	
	因为这个模块是时序逻辑电路，最后还需要两个输入，
	一个是start，每次给新的乘数后，都需要将start由0置为1，
	start的上升沿时会开始进行乘法运算，经过32个时钟周期后，输出product才是正确的结果，
	未到32个周期时，输出product都是中间累加期间的结果。
	另外一个是clk，时钟信号。
	
	注：本想做成组合逻辑，但是那样就只能做加法阵列，输出64位结果，就需要一个64*64的阵列，我们的板子上的门明显不够用。
