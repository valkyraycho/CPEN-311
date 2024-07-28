`timescale 1 ps / 1 ps
module tb_syn_task3 ();

    reg CLOCK_50;
    reg [3:0] KEY;
    reg [9:0] SW;
    wire [9:0] LEDR;
    wire [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

    task3 dut (
        .CLOCK_50,
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

    task en;
        KEY[0] <= 1'b0;
        #10;
        KEY[0] <= 1'b1;
    endtask
    task reset;
        KEY[3] <= 1'b0;
        #10;
        KEY[3] <= 1'b1;
    endtask

    initial begin
        CLOCK_50 <= 1'b1;
        forever #5 CLOCK_50 = ~CLOCK_50;
    end

    initial begin
        KEY[0] <= 1'b1;
        KEY[3] <= 1'b1;
        #10;  // initialize mem module so no race condition
        reset();

        SW <= 10'b0000011000;
        $readmemh("test2.memh", \ct|altsyncram_component|auto_generated|altsyncram1|ram_block3a0 .ram_core0.ram_core0.mem);
        #20;

        en();

        for (int i = 0; i <= 6000; i++) begin
            #10;
        end

        $displayh("pt: %p", \pt|altsyncram_component|auto_generated|altsyncram1|ram_block3a0 .ram_core0.ram_core0.mem);
        $display(
            "expected: 4D 72 73 2E 20 44 61 6C 6C 6F 77 61 79 20 73 61 69 64 20 73 68 65 20 77 6F 75 6C 64 20 62 75 79 20 74 68 65 20 66 6C 6F 77 65 72 73 20 68 65 72 73 65 6C 66 2E");

        $stop;
    end

endmodule : tb_syn_task3
