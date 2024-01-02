`timescale 1ps / 1ps
//-----------------------------------------------------------------------------------
// Copyright :This file is used to reference and study.

// Module:  smg_demo
// File:    smg_demo.v
// Author:  meng guodong
// E-mail:  823300630@qq.com
// Time : 	2020.05.21
// Description: 数码管设计适用于AX309，预留输入有效接口只有数据，即为给什么数据，数码管显示什么数据
//              
// 
// 
// 
// Revision: 1.0
//-------------------------------------------------------------------------------------------------
module smg_demo (
	input  						clk			,
	input  						rst_n		,
	input 			[23: 0] 	Number_Sig	,
	output 	reg 	[ 5: 0] 	Scan_Sig 	,//需要显示的第几个数码管
	output 	reg  	[ 7: 0]		SMG_Data 	 //需要显示的数据
);
//parameter Number_Sig = 24'h123456;_a为黑的，全部是暗的
parameter T1MS=16'd50000;
parameter 	_0 = 8'b1100_0000, _1 = 8'b1111_1001, _2 = 8'b1010_0100,
			_3 = 8'b1011_0000, _4 = 8'b1001_1001, _5 = 8'b1001_0010,
			_6 = 8'b1000_0010, _7 = 8'b1111_1000, _8 = 8'b1000_0000,
			_9 = 8'b1001_0000, _a = 8'b1111_1111;
reg[15:0] cnt;//动态扫描计数器
reg [3:0] N_data;//数据寄存
//这个时间其实可以自己控制，只要在人眼不能观察到间隔就行
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
			cnt <=  'd0;
		else if (cnt == T1MS-1)
				cnt <= 1'b0;
			else 
				cnt <= cnt + 1;			
end		
/*动态扫描	选择要显示的数码管（第一个要显示），当速度快到人眼无法区分的时候就是“所有”数码管一//起显示了*/
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) 
		Scan_Sig<=6'b011111;
	else if(cnt == T1MS-1) 
		Scan_Sig<={Scan_Sig[0],Scan_Sig[5:1]};
end
//reg [3:0] N_data;
//当某一个数码管被点亮的时候，赋予其对应位置的数据
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		N_data <= 4'd0;
	else 
		case(Scan_Sig)
			6'b111110:	N_data <= Number_Sig[ 3: 0];
			6'b111101:	N_data <= Number_Sig[ 7: 4];
			6'b111011:	N_data <= Number_Sig[11: 8];
			6'b110111:	N_data <= Number_Sig[15:12];
			6'b101111:	N_data <= Number_Sig[19:16];
			6'b011111:	N_data <= Number_Sig[23:20];	
			default:	N_data <= 4'd0;
		endcase 					
end
//七段译码器（显示器）
always@(*)
begin
	case(N_data)
		4'b0000: SMG_Data = _0 ;
		4'b0001: SMG_Data = _1 ;
		4'b0010: SMG_Data = _2 ;
		4'b0011: SMG_Data = _3 ;
		4'b0100: SMG_Data = _4 ;
		4'b0101: SMG_Data = _5 ;
		4'b0110: SMG_Data = _6 ;
		4'b0111: SMG_Data = _7 ;
		4'b1000: SMG_Data = _8 ;
		4'b1001: SMG_Data = _9 ;
		4'b1010: SMG_Data = _a ;
		default: SMG_Data = _0 ;
	endcase
end
endmodule