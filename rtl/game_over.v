`define RED    24'hFF0000//red    
`define GREEN  24'h00FF00//green        
`define BLUE   24'h0000FF//blue         
`define PURPLE 24'hFF00FF//purple       
`define YELLOW 24'hFFFF00//yellow       
`define CYAN   24'h00FFFF//cyan         
`define ORANGE 24'hFFC125//orange       
`define WHITE  24'hFFFFFF//white        
`define BLACK  24'h000000//black    

`define S_POS  (pix_x>90&&pix_x<391&&pix_y>85&&pix_y<236) //150*300

module game_over(
    input   wire            tft_clk_9m  ,   //输入时钟,频率9MHz
    input   wire            sys_rst_n   ,   //系统复位,低电平有效

    input  wire    [11:0]   pix_x       ,   //输出TFT有效显示区域像素点X轴坐标
    input  wire    [11:0]   pix_y       ,   //输出TFT有效显示区域像素点Y轴坐标
    output  reg    [23:0]    rgb_data     ,   //TFT显示数据
    input  wire             hsync       ,   //TFT行同步信号
    input  wire             vsync         //TFT场同步信号

   );

reg [15:0] s_addr;
wire [0:0] s;

always @(posedge tft_clk_9m or negedge sys_rst_n) begin
  if(!sys_rst_n) begin
     rgb_data <= `WHITE;
	  s_addr<=0;
  end
  else begin
    if(vsync == 1'b0)
      if(`S_POS)begin
		  s_addr <= s_addr + 1;
	     rgb_data <= {24{s}};
	   end
      
	   else begin
	     rgb_data <= `WHITE; 
		end
	 else begin
	   s_addr<=0;
	   rgb_data <= `WHITE;
	 end
  end
end

rom_go  Urom_go(
        .clock(tft_clk_9m), 
		  .address(s_addr), 
		  .q(s));
endmodule
