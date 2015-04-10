module divider(divident,divisor,quotient);
     
input wire [31:0] divident;
input wire [31:0] divisor;
output reg [31:0] quotient;
reg [47:0]tmpDivident;
reg [23:0]tmpDivisor;
reg [25:0]tmpQuotient;
reg [25:0] remainder;
reg [8:0]exponent;
reg [8:0]tmp;

integer i;             // 整数,用于计数
always @(divident or divisor)               // 被除数,除数
	begin
		quotient=0;
		remainder=0;
		tmpDivident={1,divident[22:0],24'b0};
		tmpDivisor={1,divisor[22:0]};
		exponent=divident[30:23]+128-divisor[30:23];
		tmpQuotient=0;
		// 开始余数和商清零
		tmp=divident[30:23]+127;
		if(tmp<divisor[30:23])
			begin
				quotient=0;
			end
		else if(tmp-divisor[30:23]>254)
			begin
				quotient={divident[31]^divisor[31],8'b1,23'b0};
			end
		else if(divident==0||divisor[30:23]-255==0)
			begin
				quotient=0;
			end	// 若除数为0则显示错误
		else if(divident[30:23]==255)
			begin
				quotient=divident;
			end
		else if(divisor==0)
			begin                    // 商0,余数为除数
            quotient={divident[31],8'b1,23'b0};
			end
		else
			begin
				for (i=48;i>0;i=i-1) // 循环48次
					begin
						remainder={remainder[25:0],tmpDivident[i-1]}; // 把did[i-1]连接到rem后
						tmpQuotient=tmpQuotient<<1;   // 商左移一位    
						if(remainder>=tmpDivisor)   // 若拼接后rem>=除数dis      
							begin
								tmpQuotient=tmpQuotient+1; // 商值自加1          
								remainder=remainder-tmpDivisor;  // 新余数变为旧余数减除数     
							end
					end
				for(i=3;i>0;i=i-1)
					begin
						if(tmpQuotient[25]!=1)
							begin
								tmpQuotient=tmpQuotient*2;//左移
								exponent=exponent-1;
							end
					end
				quotient={divident[31]^divisor[31],exponent[7:0],tmpQuotient[24:2]};
			end
	end                                // 结束
endmodule
