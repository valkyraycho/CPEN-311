`timescale 1ps / 1ps
module tb_rtl_task1 ();


    reg rst_n;
    reg clk = 1'b0;
    wire [3:0] KEY;
    reg [9:0] SW, LEDR;
    reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    assign KEY[3] = rst_n;
    task1 DUT (
        .CLOCK_50(clk),
        .KEY,
        .SW,
        .HEX0,
        .HEX1,
        .HEX2,
        .HEX3,
        .HEX4,
        .HEX5,
        .LEDR
    );
    initial begin
        forever begin
            #1;
            clk = ~clk;
        end
    end


    initial begin  //Success case

        rst_n = 1'b0;
        #2;
        rst_n = 1'b1;
        #600;

        //No automated test. Verification done via comparing the final s memory to our expected result in memory viewer.
        $stop;

    end

endmodule : tb_rtl_task1
