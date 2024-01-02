`timescale 1ns / 1ps
module key_filter(clk,rst_n,key_in,led 
    );
input clk;
input rst_n;
input [3:0] key_in;

output [3:0] led;
//20ms计数器
reg cnt_full;
reg [19:0] cnt;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt <= 20'd0;
	else if(cnt == 20'd999_999)
			cnt <= 20'd0;
		 else 
			cnt <= cnt + 1'b1; 	 
end
//计数满信号
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_full <= 1'b0;
	else if(cnt == 20'd999_999)
			cnt_full <= 1'b1;
		 else 
		 	cnt_full <= 1'b0;
end

reg [3:0] key_in_r;
reg [3:0] key_in_r_next;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		key_in_r_next <= 4'b1111;
	else if(cnt_full)
			key_in_r_next <= key_in;
		 else 
		 	key_in_r_next <= key_in_r_next;
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		key_in_r <= 4'b1111;
	else
		key_in_r <= key_in_r_next;
end


assign led = key_in_r & (~key_in_r_next);


endmodule
