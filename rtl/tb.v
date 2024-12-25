
`timescale 1ns/1ps



module tb();

   reg clk;//50MHZ
   reg reset_n;//sw0
  
  reg  key_up;//bnt0
  reg key_down;//bnt1
  reg key_left;//bnt2
  reg key_right;//bnt3

  wire    [15:0]  rgb_tft    ;   //输出像素信息
  wire            hsync      ;   //输出行同步信号
  wire            vsync      ;   //输出场同步信号
  wire            tft_clk    ;   //输出TFT时钟信号
  wire            tft_de     ;   //输出TFT使能信号
  wire            tft_bl     ;    //输出背光信号
  
 wire            stcp  ;  //输出数据存储寄时钟
 wire            shcp  ;  //移位寄存器的时钟输入
 wire            ds    ;  //串行数据输入
 wire            oe    ;  //输出使能信号
 
 
 
 initial begin
   clk =0;
	reset_n=0;
	key_up=1;
	key_down=1;
	key_left=1;
	key_right=1;
	#1000;
	reset_n=1;
 
 end
 
 always #(10) clk =~clk;

YH_SNAKE_GAME YH_SNAKE_GAME(
              .clk(clk),//50MHZ
              .reset_n(reset_n),//sw0
  
              .key_up(key_up),//bnt0
              .key_down(key_down),//bnt1
              .key_left(key_left),//bnt2
              .key_right(key_right),//bnt3
  
              .rgb_tft   (rgb_tft),   //输出像素信息
              .hsync     (hsync),   //输出行同步信号
              .vsync     (vsync),   //输出场同步信号
              .tft_clk   (tft_clk),   //输出TFT时钟信号
              .tft_de    (tft_de),   //输出TFT使能信号
              .tft_bl    (tft_bl),    //输出背光信号
  
              .stcp      (stcp),   //输出数据存储寄时钟
              .shcp      (shcp),   //移位寄存器的时钟输入
              .ds        (ds),   //串行数据输入
              .oe        (oe)      //输出使能信号
        
		  );
		  

endmodule 
