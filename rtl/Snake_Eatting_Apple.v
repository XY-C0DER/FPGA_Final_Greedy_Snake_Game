//ƻ����������ģ��
module Snake_Eatting_Apple
(
	input clk,
	input rst,
	
	input [5:0]head_x,
	input [5:0]head_y,
	
	output reg [5:0]apple_x,
	output reg [4:0]apple_y,

	output reg add_cube
);

	reg [31:0]clk_cnt;
	reg [8:0]random_num;
	
	always@(posedge clk)
		random_num <= random_num + 99;  
	
	always@(posedge clk or negedge rst) begin
		if(!rst) begin
			clk_cnt <= 0;
			apple_x <= 24;
			apple_y <= 10;
			add_cube <= 0;
		end
		else begin
			clk_cnt <= clk_cnt+1;
			if(clk_cnt == 250_000) begin
				clk_cnt <= 0;
				if(apple_x == head_x && apple_y == head_y) begin
					add_cube <= 1;
					apple_x <= (random_num[8:4] > 18) ? (random_num[8:4] - 7) :
					           (random_num[8:4] == 0) ? 1 :
					            random_num[8:4];
					apple_y <= (random_num[3:0] > 8) ? (random_num[3:0] - 3) : 
					           (random_num[3:0] == 0) ? 1:
					           random_num[3:0];
				end   
				else
					add_cube <= 0;
			end
		end
	end
endmodule
