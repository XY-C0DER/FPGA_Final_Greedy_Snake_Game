


module eat_beep_cnt(
       input clk,//50MHZ
	    input rst_n,
		 
		 input add_cube,
		 input  [1:0]game_status,
		 
       output [7:0] num,
		 output beep
       );



reg [31:0] cnt;
reg        flag_add;

reg [7:0] cnt_num;
wire [3:0] numH,numL;

assign beep= flag_add;
//assign num ={numH,numL};
assign num =cnt_num;
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt<=0;
	 flag_add<=1'b0;
  end
  else begin
    if(cnt==24_999_999) begin
	   cnt<=0;
	 end
	 else if(flag_add==1'b1) begin
	   cnt<=cnt+1;
	 end
	 
	 if(cnt==24_999_999)
	   flag_add<=1'b0;
    else if(add_cube==1'b1)
	   flag_add<=1'b1;
  end
end

reg add_cube_r;
reg add_cude_pose;
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_num<=0;
  end
  else begin
    add_cube_r<=add_cube;
	 add_cude_pose<=(!add_cube_r&add_cube);
    if(game_status==2'b00)
	    cnt_num<=0;
	 else begin
	   if(add_cude_pose==1'b1)
		    cnt_num<=cnt_num+1;
	 end
  end
end

binTobcd UbinTobcd(
         .bin(cnt_num),
	      .bcdH(numH), 
			.bcdL(numL)
);

endmodule
