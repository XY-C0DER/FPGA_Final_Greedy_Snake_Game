module BTN_TOP(
     input CLK100MHZ,
     input CPU_RESETN,
     
     input BTNC,
     input BTNU,
     input BTNL,
     input BTNR,
     input BTND,
     
     output key_enC,
     output key_enU,
     output key_enL,
     output key_enR,
     output key_enD
    );
    
key_filter U1key_filter(
			.Clk(CLK100MHZ),      //50M时钟输入
			.Rst_n(CPU_RESETN),    //模块复位
			.key_in(BTNC),   //按键输入
		    .key_en(key_enC)
		);

key_filter U2key_filter(
			.Clk(CLK100MHZ),      //50M时钟输入
			.Rst_n(CPU_RESETN),    //模块复位
			.key_in(BTNU),   //按键输入
		    .key_en(key_enU)
		);
		
key_filter U3key_filter(
			.Clk(CLK100MHZ),      //50M时钟输入
			.Rst_n(CPU_RESETN),    //模块复位
			.key_in(BTNL),   //按键输入
		    .key_en(key_enL)
		);
		
key_filter U4key_filter(
			.Clk(CLK100MHZ),      //50M时钟输入
			.Rst_n(CPU_RESETN),    //模块复位
			.key_in(BTNR),   //按键输入
		    .key_en(key_enR)
		);
		
key_filter U5key_filter(
			.Clk(CLK100MHZ),      //50M时钟输入
			.Rst_n(CPU_RESETN),    //模块复位
			.key_in(BTND),   //按键输入
		    .key_en(key_enD)
		);    
endmodule
