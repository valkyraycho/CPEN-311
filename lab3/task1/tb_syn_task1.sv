`timescale 1 ps / 1 ps
module tb_syn_task1 ();
    // vsim -L altera_mf_ver work.tb_rtl_task1
    integer failed_count = 0;

    reg CLOCK_50;
    reg [3:0] KEY;
    reg [9:0] SW;
    wire [9:0] LEDR;
    wire [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

    task1 dut (
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

    task clock;
        CLOCK_50 <= 1'b1;
        #5;
        CLOCK_50 <= 1'b0;
        #5;
    endtask
    task reset;
        KEY[3] <= 1'b0;
        #5;
        KEY[3] <= 1'b1;
        #5;
    endtask

    task check_output(integer out, integer expected_out, string msg);
        assert (out === expected_out) begin
            $display("[PASS] %s: output is %7b (expected: %7b)", msg, out, expected_out);
        end
        else begin
            $error("[FAIL] %s: output is %7b (expected: %7b)", msg, out, expected_out);
            failed_count = failed_count + 1;
        end
    endtask

    initial begin
        KEY[0] <= 1'b1;

        reset();

        KEY[0] <= 1'b0;
        clock();
        KEY[0] <= 1'b1;

        for (int i = 0; i <= 255; i++) begin
            $display("-- i = %d --", i);
            clock();
            check_output(LEDR[0], 1'b0, "checking init RDY while processing");
        end

        KEY[0] <= 1'b0;
        clock();

        for (int i = 0; i <= 255; i++) begin
            $display("-- i = %d --", i);
            clock();
            check_output(LEDR[0], 1'b1, "checking init RDY while done and make sure it does not execute more than once");
        end

        $displayh("s: %p", \s|altsyncram_component|auto_generated|altsyncram1|ram_block3a0 .ram_core0.ram_core0.mem);
        $display("Total number of tests failed is: %d", failed_count);

    end

endmodule : tb_syn_task1
