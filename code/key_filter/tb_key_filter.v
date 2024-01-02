`timescale 1ns / 1ps
module tb_key_filter;
	reg clk;
	reg rst_n;
	reg [3:0] key_in;
	wire [3:0] led;
	key_filter uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.key_in(key_in), 
		.led(led)
	);
always #10 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		key_in = 4'b1111;
		#100;
        rst_n = 4'b01;
        #3000;
        key_in = 4'b1110;
        #1000;
        key_in = 4'b1111;
        #140;
        key_in = 4'b1110;
        #2000;
        key_in = 4'b1111;
        #3000;
        key_in = 4'b1110;
        #100;
        key_in = 4'b1111;
        #20;
        key_in = 4'b1110;
        #(20*10000000);
        key_in = 4'b1111;
        #1000;
        key_in = 4'b1110;
        #140;
        key_in = 4'b1111;
        #2000;
        key_in = 4'b1110;
        #3000;
        key_in = 4'b1111;
        #100;
        key_in = 4'b1110;
        #20;
        key_in = 4'b1111;
        #20;
        key_in = 4'b1111;
	end
      
endmodule

