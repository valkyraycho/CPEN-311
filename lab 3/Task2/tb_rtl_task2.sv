`timescale 1ps / 1ps
module tb_rtl_task2();

reg rst_n_s;
reg clk_s = 1'b0;
wire[3:0] KEY_s;
reg[9:0] SW_s, LEDR_s;
reg[6:0] HEX0_s,HEX1_s,HEX2_s,HEX3_s,HEX4_s,HEX5_s;
assign KEY_s[3] = rst_n_s;

task2 DUT(.CLOCK_50(clk_s), .KEY(KEY_s), .SW(SW_s),
             .HEX0(HEX0_s), .HEX1(HEX1_s), .HEX2(HEX2_s),
             .HEX3(HEX3_s), .HEX4(HEX4_s), .HEX5(HEX5_s),
             .LEDR(LEDR_s));
			 
initial begin
	forever begin
		clk_s = ~clk_s;
		#1;
	end
end


initial begin //Success case
SW_s = 10'h00033C;
rst_n_s = 1'b0;
#2;
rst_n_s = 1'b1;
#6000;
$stop;
//No automated test. Verification done via comparing the final s memory to our expected result in memory viewer.
end
endmodule: tb_rtl_task2
