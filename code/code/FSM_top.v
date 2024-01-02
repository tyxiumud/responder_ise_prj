`timescale 1ns / 1ps
//-----------------------------------------------------------------------------------
// Copyright :This file is used to reference and study.

// Module:  ESM_top
// File:    ESM_top.v
// Author:  meng guodong
// E-mail:  823300630@qq.com
// Time : 	2020.05.21
// Description: 抢答器设计总模块
//              
// 
// 
// 
// Revision: 1.0
//-------------------------------------------------------------------------------------------------
module ESM_top (
	input 			 			s_clk 		,
	input 						s_rst_n 	,
	input 			[3:0]		key_in		,
	output 		 	[3:0] 		Led 		,
	output 	reg 	[23: 0] 	Number_Sig	
);
parameter 	S0 = 5'b00_001,S1 = 5'b00_010,S2 = 5'b00_100, 
			S3 = 5'b01_000,S4 = 5'b10_000;
assign Led = option;
reg [4:0] q_number; //最多30题
reg [7:0] secound_set;//设置的倒计时时间
reg [5:0] time_secound;//用来倒计时的时间
reg [4:0] pre_state;
reg [4:0] next_state;
reg set_end; //设置时间结束，进入下一状态
reg [8:0] score1;//最多500分
reg [8:0] score2;//最多500分
reg [8:0] score3;//最多500分
reg [8:0] score4;//最多500分
reg [3:0] option;//记录哪一位选手抢到了题目
reg S3_end;//进入S3停留2s显示选手分数。然后进入下一阶段
reg [1:0] S3_cnt_full	;//S3状态计数跳转
reg S3_cnt_en	;//S3状态计数打开
reg [25:0]  S3_cnt 	;//计数器S3
reg [25:0]  S2_cnt 	;//计数器S2
reg contend_continue;//选择继续还是停止
reg contend_end;	//选择继续还是停止
reg [1:0] S4_cnt; //第四个状态用来显示选手的分数
reg [8: 0] data2;//显示的数据
reg [3: 0] data3;//显示的数据
reg [8: 0] data4;//显示的数据
//第一段
always @(posedge s_clk or negedge s_rst_n)begin
    if(!s_rst_n)
        pre_state[4:0] <= S0;
    else 
        pre_state[4:0] <= next_state;
end
//第二段
always @(*)begin
        case(pre_state)
        S0:begin
            if(set_end)
                next_state = S1;
            else
            	next_state = S0;
        end
        S1:
        begin	
        if(time_secound == 'd0)
            next_state = S1;
        	else
        		if(key_in[0] == 1'b1 || key_in[1] == 1'b1 || key_in[2]  == 1'b1 || key_in[3]== 1'b1 ) 
            		next_state = S2;  
            	else 
            		next_state = pre_state;
        end
        S2:begin
            if(key_in[0] || key_in[1])
                next_state = S3 ;
            else
            	next_state = pre_state;
        end
        S3:
        	begin
          	 	if(S3_end)
          	      	next_state = S4 ;
          	    else
          	    	next_state	= pre_state;  	
        	end
        S4:begin
        	S3_cnt_en = 1'b0;
            if(contend_continue)
                next_state = S1  ;
            else  
            	if (contend_end)
            		next_state = S0;
            	else
            		next_state = pre_state;
            		
        end
        default: next_state = S0  ;
        endcase
end
//第三段
//组合逻辑或时序逻辑赋值用pre_state做条件
//S0状态
always @ (posedge s_clk or negedge s_rst_n) 
begin  
	if(!s_rst_n)
		secound_set <= 8'd10;
	else
		if(pre_state == S0)
			begin
				if(key_in[0] == 1'b1)
					secound_set <= secound_set + 1'b1;
				else 
					if(key_in[1] == 1'b1)
						secound_set <= secound_set - 1'b1;
					else
						secound_set <= secound_set;
			end
end 

always @ (posedge s_clk or negedge s_rst_n) 
begin  
	if(!s_rst_n)
		set_end <= 1'b0;
	else
		if(key_in[2] == 1'b1)
			set_end <= 1'b1;
		else 
			set_end <= 1'b0;
end 

always @ (posedge s_clk or negedge s_rst_n) 
begin
	if (!s_rst_n)
		q_number <= 5'd1;
	else 
		if(pre_state == S0)
			q_number <= 'd1;
		else 
			if ( pre_state == S1 && (key_in[0] == 1'b1 || key_in[1] == 1'b1 || key_in[2]  == 1'b1 || key_in[3]== 1'b1 ) )//无人选择或任意选择//倒计时为1意味着没有人选择抢答
				q_number <= q_number + 1'b1;
			else 
				if( time_secound == 'd0 )
					q_number <= q_number + 1'b1;
end
always @ (posedge s_clk or negedge s_rst_n) 
begin  
	if(!s_rst_n)
		begin
			S2_cnt <= 'd0;	
		end
	else
		if(pre_state == S1) 
			if(S2_cnt == 26'd49_999_999)
				S2_cnt <= 'd0;
			else 
				S2_cnt <= S2_cnt + 1'b1;
		else
			S2_cnt <= 'd0;	
end
always @ (posedge s_clk or negedge s_rst_n)
begin
	if(!s_rst_n)
		time_secound <= secound_set;
	else 
		if(pre_state != S1)
			time_secound <= secound_set;
		else 
			if(time_secound == 'd0)
				time_secound <= secound_set;
			else if(S2_cnt == 26'd49_999_999)
					time_secound <= time_secound - 1'b1;
end

//S1状态判断那位选手抢到了题目
always @ (posedge s_clk or negedge s_rst_n) 
begin  
	if(!s_rst_n)
		option <= 4'b0;
	else
		if(pre_state == S1)
			if(key_in[0])  
            		option <= 4'b0001;  
            	else 
            		if(key_in[1])  
            			option <= 4'b0010;  
            		else 
            			if (key_in[2])  
            				option <= 4'b0100;            			
            			else 
            				if(key_in[3])  
            					option <= 4'b1000;
            				else 
            					option <= option;
        else 
        	if(pre_state == S4)
        		option <= 4'b0;
        	else 	
        		option <= option;
end 
//S2状态加减分数
always @ (posedge s_clk or negedge s_rst_n)
begin
	if(!s_rst_n)
		begin
			score1 <= 8'd100;							
			score2 <= 8'd100;				
			score3 <= 8'd100;				
			score4 <= 8'd100;	
		end
	else 
		if(pre_state == S2)
			case(option)
			4'b0001:
					if(key_in[0] == 1'b1) 
						score1 <= score1 + 4'd10;
					else 
						if(key_in[1] == 1'b1) 
							score1 <= score1 - 4'd10;
			4'b0010:
					if(key_in[0] == 1'b1) 
						score2 <= score2 + 4'd10;
					else 
						if(key_in[1] == 1'b1) 
							score2 <= score2 - 4'd10;
			4'b0100:
					if(key_in[0] == 1'b1) 
						score3 <= score3 + 4'd10;
					else 
						if(key_in[1] == 1'b1) 
							score3 <= score3 - 4'd10;
			4'b1000:
					if(key_in[0] == 1'b1) 
						score4 <= score4 + 4'd10;
					else 
						if(key_in[1] == 1'b1) 
							score4 <= score4 - 4'd10;
			default:
				begin
					score1 <= 8'd100;							
					score2 <= 8'd100;				
					score3 <= 8'd100;				
					score4 <= 8'd100;	
				end
			endcase
		else 
			if(pre_state == S0)
				begin
					score1 <= 8'd100;							
					score2 <= 8'd100;				
					score3 <= 8'd100;				
					score4 <= 8'd100;	
				end
			else 
				begin
					score1 <= score1;		
					score2 <= score2;		
					score3 <= score3;		
					score4 <= score4;	
				end
end


//S3状态//显示加减分后的数据两秒自动跳转到下一状态
//S3_end
always @ (posedge s_clk or negedge s_rst_n) 
begin  
	if(!s_rst_n)
		S3_end <= 1'b0;	
	else
		if(S3_cnt_full == 2'd2)
			S3_end <= 1'b1;
		else 
			S3_end <= 1'b0;
end 
always @ (posedge s_clk or negedge s_rst_n) 
begin  
	if(!s_rst_n)
		begin
			S3_cnt <= 'd0;	
			S3_cnt_full <= 'd0;
		end
	else
		if(pre_state == S3)
				if(S3_cnt == 26'd49_999_999)
					begin
						S3_cnt <= 'd0;
						S3_cnt_full <= S3_cnt_full + 1'b1;
					end
				else 
					begin
						S3_cnt <= S3_cnt + 1'b1;
						S3_cnt_full <= S3_cnt_full;
					end
		else
			begin
				S3_cnt <= 'd0;	
				S3_cnt_full <= 'd0;
			end
end
//S4状态//通过按键进行选择哪一个选手的信息是需要查询的
always @ (posedge s_clk or negedge s_rst_n) 
begin  
	if(!s_rst_n)
		contend_continue <= 1'b0;
	else
		if(pre_state == S4 && key_in[0] == 1'b1)
			contend_continue <= 1'b1;
		else 
			contend_continue <= 1'b0;
end 

always @ (posedge s_clk or negedge s_rst_n) 
begin  
	if(!s_rst_n)
		contend_end <= 1'b0;
	else
		if(pre_state == S4 && key_in[1] == 1'b1)
			contend_end <= 1'b1;
		else 
			contend_end <= 1'b0;
end 
//S4_cnt
always @ (posedge s_clk or negedge s_rst_n) 
begin  
	if(!s_rst_n)
		S4_cnt <= 'd0;
	else
		if(S4_cnt == 'd3)
			S4_cnt <= 'd0;
		else 
			if(pre_state == S4 && key_in[2] == 1'b1)
				S4_cnt <= S4_cnt + 'd1;
			else
				S4_cnt <= S4_cnt; 	
end 


reg [2:0] number;
wire [3:0] tens_data_S0;
wire [3:0] unit_data_S0;
wire [3:0] tens_data_S1;
wire [3:0] unit_data_S1;
wire [3:0] tens_data_q_number;
wire [3:0] unit_data_q_number;
wire [3:0] tens_data_data2;
wire [3:0] unit_data_data2;
wire [3:0] hund_data_data2;
wire [3:0] tens_data_data4;
wire [3:0] unit_data_data4;
wire [3:0] hund_data_data4;
//选择需要显示的信息，这里理解可以先忽略二进制转BCD，然后先设置好需要显示的信息，然后进行码制的转换，进行显示，以下数据均为显示的数据转换
always @ (*) 
begin
		case (pre_state) 
		 	S0 		:    Number_Sig = {8'haa,4'ha,4'ha,tens_data_S0,unit_data_S0}; //设置倒计时时间
		 	S1 		:    Number_Sig = {tens_data_q_number,unit_data_q_number,4'ha,4'ha,tens_data_S1,unit_data_S1}; //显示题号，开始倒计时
		 	S2 		:    Number_Sig = {data3,4'ha,4'ha,hund_data_data2,tens_data_data2,unit_data_data2};
		 	S3 		: 	 Number_Sig = {data3,4'ha,4'ha,hund_data_data2,tens_data_data2,unit_data_data2};	
		 	S4 		:    Number_Sig = {number,4'ha,4'ha,hund_data_data4,tens_data_data4,unit_data_data4};
		    default :    Number_Sig = 'd0; 
		endcase
end
always @ (posedge s_clk or negedge s_rst_n) 
begin
	if(!s_rst_n)
		number <= 'd1;
	else 
		if(pre_state == S4 && key_in[2] == 1'b1)
			if(number <= 3)
				number <= number + 1'b1;
			else 
				number <= 'd1;
end 
//选手的分数
always @ (posedge s_clk) 
begin
	case (option) 
	 	4'b0001 :    data2 <= score1; 
	 	4'b0010 :    data2 <= score2; 
	 	4'b0100 :    data2 <= score3; 
	 	4'b1000 :    data2 <= score4; 
	    default :    data2 <= 'd0 ; 
	endcase
end
//那位选手抢到题目
always @ (posedge s_clk) 
begin
	case (option) 
	 	4'b0001 :    data3 <= 4'd1; 
	 	4'b0010 :    data3 <= 4'd2; 
	 	4'b0100 :    data3 <= 4'd3; 
	 	4'b1000 :    data3 <= 4'd4; 
	    default :    data3 <= 'd0 ; 
	endcase
end
always @ (*) 
begin
	case (number) 
	 	3'd1 :    data4 = score1; 
	 	3'd2 :    data4 = score2; 
	 	3'd3 :    data4 = score3; 
	 	3'd4 :    data4 = score4; 
	    default :    data4 = 'd0 ; 
	endcase
end
Binary2BCD Binary2BCD_0 (
    .clk(s_clk), 
    .rst_n(s_rst_n), 
    .tran_en(1'b1), 
    .data_in({8'd0,secound_set}), 
    .tran_done( ), 
    .thou_data( ), 
    .hund_data( ), 
    .tens_data(tens_data_S0), 
    .unit_data(unit_data_S0)
    );
Binary2BCD Binary2BCD_1 (
    .clk(s_clk), 
    .rst_n(s_rst_n), 
    .tran_en(1'b1), 
    .data_in({10'd0,time_secound}), //倒计时时间
    .tran_done( ), 
    .thou_data( ), 
    .hund_data( ), 
    .tens_data(tens_data_S1), 
    .unit_data(unit_data_S1)
    );
Binary2BCD Binary2BCD_2 (
    .clk(s_clk), 
    .rst_n(s_rst_n), 
    .tran_en(1'b1), 
    .data_in({11'd0,q_number}), 
    .tran_done( ), 
    .thou_data( ), 
    .hund_data( ), 
    .tens_data(tens_data_q_number), 
    .unit_data(unit_data_q_number)
    );
//分数
Binary2BCD Binary2BCD_3 (
    .clk(s_clk), 
    .rst_n(s_rst_n), 
    .tran_en(1'b1), 
    .data_in({7'd0,data2}), //得分
    .tran_done( ), 
    .thou_data( ), 
    .hund_data(hund_data_data2), 
    .tens_data(tens_data_data2), 
    .unit_data(unit_data_data2)
    );
//查看分数
Binary2BCD Binary2BCD_4 (
    .clk(s_clk), 
    .rst_n(s_rst_n), 
    .tran_en(1'b1), 
    .data_in({7'd0,data4}), //得分
    .tran_done( ), 
    .thou_data( ), 
    .hund_data(hund_data_data4), 
    .tens_data(tens_data_data4), 
    .unit_data(unit_data_data4)
    );
endmodule
