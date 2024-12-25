
module YH_SNAKE_GAME(
 input clk,//50MHZ
  input reset_n,//sw0
  
  input key_up,//bnt0
  input key_down,//bnt1
  input key_left,//bnt2
  input key_right,//bnt3
  
   output                  beep,           //输出蜂鸣器控制信号
	output  wire    [3:0]   led_out,        //输出控制led灯
  
   output  wire    [15:0]  rgb_tft     ,   //输出像素信息
   output  wire            hsync       ,   //输出行同步信号
   output  wire            vsync       ,   //输出场同步信号
   output  wire            tft_clk     ,   //输出TFT时钟信号
   output  wire            tft_de      ,   //输出TFT使能信号
   output  wire            tft_bl      ,    //输出背光信号
  
    output  wire            stcp        ,   //输出数据存储寄时钟
    output  wire            shcp        ,   //移位寄存器的时钟输入
    output  wire            ds          ,   //串行数据输入
    output  wire            oe              //输出使能信号
        
		  );


   wire left_key_press;
	wire right_key_press;
	wire up_key_press;
	wire down_key_press;
	wire [1:0]snake;
	wire [11:0]x_pos;
	wire [11:0]y_pos;
	wire [5:0]apple_x;
	wire [4:0]apple_y;
	wire [5:0]head_x;
	wire [5:0]head_y;
	
	wire add_cube;
	wire[1:0]game_status;
	wire hit_wall;
	wire hit_body;
	wire die_flash;
	wire restart;
	wire [6:0]cube_num;
	
	wire [3:0] sel;
	
	wire  [23:0] vga_rgb;
	wire  [23:0] rgb;
	wire  [23:0] st_rgb;
	wire  [23:0] go_rgb;
  
	 
	 wire tft_clk_9m;
	 wire  locked;
	 
	 //wire  define
   wire    [19:0]  data    ;   //数码管要显示的值
   wire    [5:0]   point   ;   //小数点显示,高电平有效top_seg_595
   wire            seg_en  ;   //数码管使能信号，高电平有效
   wire            sign    ;   //符号位，高电平显示负号

	wire     [7:0]  num;
assign rgb=	(game_status==2'b01)?st_rgb:
            (game_status==2'b11)?go_rgb:vga_rgb;
				
				
assign led_out={4{die_flash}};
assign point=6'b000000;
assign seg_en=1'b1;
assign sign=1'b0;

assign data={12'b0,num};

//------------- clk_gen_inst -------------
clk_gen clk_gen_inst
(
    .areset     (~reset_n ),  //输入复位信号,高电平有效,1bit
    .inclk0     (clk    ),  //输入50MHz晶振时钟,1bit
    .c0         (tft_clk_9m ),  //输出TFT工作时钟,频率9Mhz,1bit

    .locked     (locked     )   //输出pll locked信号,1bit
);

/*
Key Ukey(
		.clk(clk),
		.rst(reset_n),
		.left(~key_left),
		.right(~key_right),
		.up(~key_up),
		.down(~key_down),
		.left_key_press(left_key_press),
		.right_key_press(right_key_press),
		.up_key_press(up_key_press),
		.down_key_press(down_key_press)		
	); 
*/
	
BTN_TOP UBTN_TOP(
        .CLK100MHZ(clk),
        .CPU_RESETN(reset_n),
     
        .BTNC(),
        .BTNU(key_up),
        .BTNL(key_left),
        .BTNR(key_right),
        .BTND(key_down),
     
        .key_enC(),
        .key_enU(up_key_press),
        .key_enL(left_key_press),
        .key_enR(right_key_press),
        .key_enD(down_key_press)
    );
	
   Game_Ctrl_Unit UGame_Ctrl_Unit (
        .clk(clk),
	    .rst_n(reset_n),
	    .key1_press(left_key_press),
	    .key2_press(right_key_press),
	    .key3_press(up_key_press),
	    .key4_press(down_key_press),
        .game_status(game_status),
		.hit_wall(hit_wall),
		.hit_body(hit_body),
		.die_flash(die_flash),
		.restart(restart)		
	);
	
	Snake_Eatting_Apple USnake_Eatting_Apple (
        .clk(clk),
		.rst(reset_n&restart),
		.apple_x(apple_x),
		.apple_y(apple_y),
		.head_x(head_x),
		.head_y(head_y),
		.add_cube(add_cube)	
	);
	
	Snake USnake (
	    .clk(clk),
		.rst(reset_n&restart),
		.left_press(left_key_press),
		.right_press(right_key_press),
		.up_press(up_key_press),
		.down_press(down_key_press),
		.snake(snake),
		.x_pos(x_pos),
		.y_pos(y_pos),
		.head_x(head_x),
		.head_y(head_y),
		.add_cube(add_cube),
		.game_status(game_status),
		.cube_num(cube_num),
		.hit_body(hit_body),
		.hit_wall(hit_wall),
		.die_flash(die_flash)
	);
          
Snake_VGA USnake_VGA(
       .clk(tft_clk_9m),
       .rst_n(reset_n),
       .snake(snake),
	   .apple_x(apple_x),
	   .apple_y(apple_y),
	   .x_pos(x_pos),
	   .y_pos(y_pos),
	   .vga_rgb(vga_rgb)
       ); 

		 tft_ctrl    tft_ctrl_inst
(
    .tft_clk_9m  (tft_clk_9m),   //输入时钟,频率9MHz,1bit
    .sys_rst_n   (reset_n     ),   //系统复位,低电平有效,1bit
    .pix_data    ({rgb[23:19],rgb[15:10],rgb[7:3]}  ),   //待显示数据,16bit

    .pix_x       (x_pos     ),   //输出TFT有效显示区域像素点X轴坐标,10bit
    .pix_y       (y_pos     ),   //输出TFT有效显示区域像素点Y轴坐标,10bit
    .rgb_tft     (rgb_tft   ),   //输出TFT显示数据,16bit
    .hsync       (hsync     ),   //输出TFT行同步信号,1bit
    .vsync       (vsync     ),   //输出TFT场同步信号,1bit
    .tft_clk     (tft_clk   ),   //输出TFT像素时钟,1bit
    .tft_de      (tft_de    ),   //输出TFT数据使能,1bit
    .tft_bl      (tft_bl    )    //输出TFT背光信号,1bit

);


game_start Ugame_start(
           .tft_clk_9m(tft_clk_9m),   //输入时钟,频率9MHz
           .sys_rst_n(reset_n)  ,   //系统复位,低电平有效

           .pix_x(x_pos),   //输出TFT有效显示区域像素点X轴坐标
           .pix_y(y_pos)      ,   //输出TFT有效显示区域像素点Y轴坐标
           .rgb_data(st_rgb),   //TFT显示数据
           .hsync(hsync) ,   //TFT行同步信号
           .vsync(vsync)         //TFT场同步信号

       );

game_over Ugame_over(
           .tft_clk_9m(tft_clk_9m),   //输入时钟,频率9MHz
           .sys_rst_n(reset_n)  ,   //系统复位,低电平有效

           .pix_x(x_pos),   //输出TFT有效显示区域像素点X轴坐标
           .pix_y(y_pos)      ,   //输出TFT有效显示区域像素点Y轴坐标
           .rgb_data(go_rgb),   //TFT显示数据
           .hsync(hsync) ,   //TFT行同步信号
           .vsync(vsync)         //TFT场同步信号

       );
		 
//----------------------------------------------------

eat_beep_cnt Ueat_beep_cnt(
             .clk(clk),//50MHZ
	          .rst_n(reset_n&restart),
		 
		       .add_cube(add_cube),
		       .game_status(game_status),
		 
             .num(num),
		       .beep(beep)
       );
		 
//-------------seg7_dynamic_inst--------------
seg_595_dynamic    seg_595_dynamic_inst
(
    .sys_clk    (clk   ),   //系统时钟，频率50MHz
    .sys_rst_n  (reset_n ),   //复位信号，低有效
    .data       (data      ),   //数码管要显示的值
    .point      (point     ),   //小数点显示,高电平有效
    .seg_en     (seg_en    ),   //数码管使能信号，高电平有效
    .sign       (sign      ),   //符号位，高电平显示负号

    .stcp       (stcp      ),   //输出数据存储寄时钟
    .shcp       (shcp      ),   //移位寄存器的时钟输入
    .ds         (ds        ),   //串行数据输入
    .oe         (oe        )    //输出使能信号
);
/*		 
vga_ctl U_vga_ctl(
        .pix_clk(pixel_clk),
        .reset_n(reset_n),
        .VGA_RGB(vga_rgb),
        .hcount(x_pos),
        .vcount(y_pos),
		.VGA_CLK(),
        .VGA_R(R),
        .VGA_G(G),
        .VGA_B(B),
        .VGA_HS(HS),
        .VGA_VS(VS),
        .VGA_DE(VGA_DE),
        .BLK()
        );  
 */
/* 
Seg_Display USeg_Display(
	        .clk(clk_100m),
	        .rst(reset_n),
	
	        .add_cube(add_cube),
	        .game_status(game_status),
	
	        .seg_out(seg),
	        .sel(sel)
);
*/



endmodule
