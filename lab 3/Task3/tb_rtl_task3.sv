`timescale 1ps / 1ps
module tb_rtl_task3 ();

    reg rst_n;
    reg clk = 1'b0;
    wire [3:0] KEY;
    reg [9:0] SW, LEDR;
    reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    assign KEY[3] = rst_n;

    task3 DUT (
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
            clk = ~clk;
            #1;
        end
    end

    initial begin
        $readmemh("C:/CPEN-x11/CPEN-311/lab 3/Task3/test1.memh", DUT.ct.altsyncram_component.m_default.altsyncram_inst.mem_data);
        rst_n = 1'b0;
        #2;
        rst_n = 1'b1;
        #5000;
        $stop;

    end

endmodule : tb_rtl_task3
