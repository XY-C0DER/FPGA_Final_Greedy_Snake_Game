module clk_unit(
	input clk,
	input rst,
	output reg clk_n  //div4
	);
	
    reg clk_tmp;//div2
    always @(posedge clk_tmp or posedge rst) begin
       if (rst)
        clk_n <= 0;
      else
        clk_n <= ~clk_n;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            clk_tmp <= 0;
        else
            clk_tmp <= ~clk_tmp;
    end
endmodule