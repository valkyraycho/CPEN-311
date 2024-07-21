`timescale 1ps / 1ps
module tb_flash_reader();
reg clk_s;
reg [3:0] KEY_s;
reg [9:0] SW_s;
wire [6:0] HEX0_s, HEX1_s, HEX2_s, HEX3_s, HEX4_s, HEX5_s;
wire [9:0] LEDR_s;

initial begin
	forever begin
		clk_s = ~clk_s;
		#1;
	end
end

flash_reader DUT (.CLOCK_50(clk_s), .KEY(KEY_s), .SW(SW_s),
                    .HEX0(HEX0_s), .HEX1(HEX1_s), .HEX2(HEX2_s),
                    .HEX3(HEX3_s), .HEX4(HEX4_s), .HEX5(HEX5_s),
                    .LEDR(LEDR_s));

 initial begin
    clk_s = 1'b1;
	KEY_s[3] = 1'b0;//reset
    #5;
    KEY_s[3] = 1'b1;
    #5;

    #2000;
end   
endmodule: tb_flash_reader

module flash(input logic clk_clk, input logic reset_reset_n,
             input logic flash_mem_write, input logic [6:0] flash_mem_burstcount,
             output logic flash_mem_waitrequest, input logic flash_mem_read,
             input logic [22:0] flash_mem_address, output logic [31:0] flash_mem_readdata,
             output logic flash_mem_readdatavalid, input logic [3:0] flash_mem_byteenable,
             input logic [31:0] flash_mem_writedata);

    assign flash_mem_readdata = {9'd0,flash_mem_address};
    assign flash_mem_readdatavalid = 1'b1;
    assign flash_mem_waitrequest = 1'b1;
endmodule: flash

