`timescale 1ps / 1ps
module tb_rtl_task3();

reg rst_n_s;
reg clk_s = 1'b0;
wire[3:0] KEY_s;
reg[9:0] SW_s, LEDR_s;
reg[6:0] HEX0_s,HEX1_s,HEX2_s,HEX3_s,HEX4_s,HEX5_s;
assign KEY_s[3] = rst_n_s;

 task3 DUT(.CLOCK_50(clk_s), .KEY(KEY_s), .SW(SW_s),
             .HEX0(HEX0_s), .HEX1(HEX1_s), .HEX2(HEX2_s),
             .HEX3(HEX3_s), .HEX4(HEX4_s), .HEX5(HEX5_s),
             .LEDR(LEDR_s));
			 
    initial begin
        forever begin
            clk_s = ~clk_s;
            #1;
        end
    end

    initial begin
    #50;
    $readmemh("C:/Users/lucrw/Desktop/School/CPEN 311/CPEN311_Lab_3/task3/test2.memh",DUT.ct.altsyncram_component.m_default.altsyncram_inst.mem_data);
    SW_s = 10'h000018;
    rst_n_s = 1'b0;
    #2;
    rst_n_s = 1'b1;
    #12000;
    $stop;
  
    end 

endmodule: tb_rtl_task3
