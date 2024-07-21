`timescale 1ps / 1ps
module tb_music();
reg clk_s,AUD_DACLRCK_s,AUD_ADCLRCK_s,AUD_BCLK_s,AUD_ADCDAT_s,FPGA_I2C_SCLK_s,AUD_DACDAT_s,AUD_XCK_s;
reg [3:0] KEY_s;
reg [9:0] SW_s;
wire [6:0] HEX0_s, HEX1_s, HEX2_s, HEX3_s, HEX4_s, HEX5_s;
wire [9:0] LEDR_s;
wire FPGA_I2C_SDAT_s;
assign reset = ~(KEY_s[3]);
reg [4:0] state;
initial begin
	forever begin
		clk_s = ~clk_s;
		#40000;
	end
end

initial begin
	forever begin
		AUD_DACLRCK_s = ~AUD_DACLRCK_s;
        AUD_ADCLRCK_s = ~AUD_ADCLRCK_s;
        AUD_BCLK_s = ~ AUD_BCLK_s;
        AUD_ADCDAT_s = ~AUD_ADCDAT_s;
	//#11360000;
  #100000;
	end
end

music DUT(.CLOCK_50(clk_s), .KEY(KEY_s), .SW(SW_s),
             .AUD_DACLRCK(AUD_DACLRCK_s), .AUD_ADCLRCK(AUD_ADCLRCK_s), .AUD_BCLK(AUD_BCLK_s), .AUD_ADCDAT(AUD_ADCDAT_s),
             .FPGA_I2C_SDAT(FPGA_I2C_SDAT_s), .FPGA_I2C_SCLK(FPGA_I2C_SCLK_s), .AUD_DACDAT(AUD_DACDAT_s), .AUD_XCK(AUD_XCK_s),
             .HEX0(HEX0_s), .HEX1(HEX1_s), .HEX2(HEX2_s),
             .HEX3(HEX3_s), .HEX4(HEX4_s), .HEX5(HEX5_s),
             .LEDR(LEDR_s));

initial begin
    AUD_DACLRCK_s = 1'b1;
    AUD_ADCLRCK_s = 1'b1;
    AUD_BCLK_s = 1'b1;
    AUD_ADCDAT_s = 1'b1;
    clk_s = 1'b1;
	KEY_s[3] = 1'b0;//reset
    #22720000;
    KEY_s[3] = 1'b1;
    #5;
end

endmodule: tb_music

// Any other simulation-only modules you need
module flash(input logic clk_clk, input logic reset_reset_n,
             input logic flash_mem_write, input logic [6:0] flash_mem_burstcount,
             output logic flash_mem_waitrequest, input logic flash_mem_read,
             input logic [22:0] flash_mem_address, output logic [31:0] flash_mem_readdata,
             output logic flash_mem_readdatavalid, input logic [3:0] flash_mem_byteenable,
             input logic [31:0] flash_mem_writedata);

    assign flash_mem_readdata = {9'd0,flash_mem_address};
    assign flash_mem_readdatavalid = 1'b1;
    assign flash_mem_waitrequest = 1'b0;
endmodule: flash

