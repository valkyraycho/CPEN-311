`timescale 1 ps / 1 ps
module tb_syn_task3 ();

    logic CLOCK_50, VGA_HS, VGA_VS, VGA_CLK, VGA_PLOT;
    logic [3:0] KEY;
    logic [2:0] VGA_COLOUR;
    logic [9:0] SW, LEDR;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, VGA_Y;
    logic [7:0] VGA_R, VGA_G, VGA_B, VGA_X;

    task3 dut (
        .CLOCK_50,
        .KEY,
        .SW,
        .LEDR,
        .HEX0,
        .HEX1,
        .HEX2,
        .HEX3,
        .HEX4,
        .HEX5,
        .VGA_R,
        .VGA_G,
        .VGA_B,
        .VGA_HS,
        .VGA_VS,
        .VGA_CLK,
        .VGA_X,
        .VGA_Y,
        .VGA_COLOUR,
        .VGA_PLOT
    );
    de1_gui gui (
        .SW,
        .KEY,
        .LEDR,
        .HEX5,
        .HEX4,
        .HEX3,
        .HEX2,
        .HEX1,
        .HEX0
    );


    initial begin
        CLOCK_50 = 0;
        forever #1 CLOCK_50 = ~CLOCK_50;
    end

endmodule : tb_syn_task3
