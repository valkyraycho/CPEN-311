`timescale 1 ps / 1 ps
module tb_syn_init ();

    reg clk, rst_n, en;
    wire rdy, wren;
    wire [7:0] addr, wrdata;

    integer failed_count = 0;

    init dut (
        .clk,
        .rst_n,
        .en,
        .rdy,
        .addr,
        .wrdata,
        .wren
    );

    task clock;
        clk <= 1'b0;
        #5;
        clk <= 1'b1;
        #5;
    endtask
    task reset;
        rst_n <= 1'b0;
        #5;
        rst_n <= 1'b1;
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
        reset();
        check_output(rdy, 1'b1, "Checking rdy when reset");

        en <= 1;
        clock();
        en <= 0;

        check_output(rdy, 1'b0, "Checking rdy when en = 1");

        $display("one full uninterrupted cycle");

        for (int i = 0; i < 255; i++) begin
            $display("-- i = %d --", i);
            clock();
            check_output(addr, i, "Checking addr");
            check_output(wrdata, i, "Checking wrdata");
            check_output(wren, 1'b1, "Checking wren");
            check_output(rdy, 1'b0, "Checking rdy");
        end

        clock();

        //255th iteration
        check_output(rdy, 1'b1, "Checking ready after completing loop");
        check_output(wren, 1'b1, "Checking not wren after completing loop");

        for (int i = 0; i < 5; i++) clock();

        check_output(rdy, 1'b1, "Checking ready after completing loop");
        check_output(wren, 1'b0, "Checking not wren after completing loop");

        reset();

        $display("Total number of tests failed is: %d", failed_count);
        $stop;
    end

endmodule : tb_syn_init
