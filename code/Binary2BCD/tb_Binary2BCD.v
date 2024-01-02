`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:11:16 05/25/2020
// Design Name:   Binary2BCD
// Module Name:   C:/Users/Admin/Desktop/FPGA_ISE_code/FPGA_design/Binary2BCD/tb_Binary2BCD.v
// Project Name:  Binary2BCD
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Binary2BCD
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_Binary2BCD;

	// Inputs
	reg clk;
	reg rst_n;
	reg tran_en;
	reg [15:0] data_in;

	// Outputs
	wire tran_done;
	wire [3:0] thou_data;
	wire [3:0] hund_data;
	wire [3:0] tens_data;
	wire [3:0] unit_data;

	// Instantiate the Unit Under Test (UUT)
	Binary2BCD uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.tran_en(tran_en), 
		.data_in(data_in), 
		.tran_done(tran_done), 
		.thou_data(thou_data), 
		.hund_data(hund_data), 
		.tens_data(tens_data), 
		.unit_data(unit_data)
	);
always #10 clk = !clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		tran_en = 1;
		data_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        rst_n = 1'b1;
        #320;
        data_in = 15'b1101010;
        
		// Add stimulus here

	end
      
endmodule

