`timescale 1ns / 1ps
module top(
	input 			 			s_clk 		,
	input 						s_rst_n 	,
	input 			[3:0]		key_in		,
	output 	 	  	[3:0] 		Led 		,
	output 			[ 5: 0] 	Scan_Sig 	,
	output 		 	[ 7: 0]		SMG_Data 	 
    );

wire	 	[23: 0] 	Number_Sig	;
wire 		[ 3: 0] 	key_flag 	;
wire 		clk_1s 					;
//always@(posedge s_clk or negedge s_rst_n)
//begin
//	if(!s_rst_n)
//		Led <= 4'b0000;
//	else 
//		begin
//			if(key_flag == 4'b0001) Led[0] <= ~Led[0];
//			if(key_flag == 4'b0010) Led[1] <= ~Led[1];
//			if(key_flag == 4'b0100) Led[2] <= ~Led[2];
//			if(key_flag == 4'b1000) Led[3] <= ~Led[3];
//		end 
//end
key_filter key_filter_0 (
    .clk(s_clk), 
    .rst_n(s_rst_n), 
    .key_in(key_in), 
    .led(key_flag)
    );

smg_demo smg_demo_0 (
    .clk(s_clk), 
    .rst_n(s_rst_n), 
    .Number_Sig(Number_Sig), 
    .Scan_Sig(Scan_Sig), 
    .SMG_Data(SMG_Data)
    );
ESM_top ESM_top_0 (
    .s_clk(s_clk), 
    .s_rst_n(s_rst_n), 
    .key_in(key_flag),
    .Led(Led), 
    .Number_Sig(Number_Sig)
    );

endmodule
