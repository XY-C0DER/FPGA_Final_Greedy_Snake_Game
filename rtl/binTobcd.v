// 二进制码转BCD码
module binTobcd(
	input [7:0] bin,
	output [3:0] bcdH,
	output [3:0] bcdL
);

assign bcdH = bin/10;
assign bcdL = bin%10;

endmodule
