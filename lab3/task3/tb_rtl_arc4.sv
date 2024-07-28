`timescale 1 ps / 1 ps
module tb_rtl_arc4 ();


    reg clk, rst_n, en;
    reg [23:0] key;
    reg [7:0] ct_rddata, pt_rddata;
    wire rdy, pt_wren;
    wire [7:0] ct_addr, pt_addr, pt_wrdata;

    integer failed_count = 0;

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

    arc4 dut (
        .clk,
        .rst_n,
        .en,
        .rdy,
        .key,
        .ct_addr,
        .ct_rddata,
        .pt_addr,
        .pt_rddata,
        .pt_wrdata,
        .pt_wren
    );

    initial begin
        $display("-----BEGIN ARC4 TESTBENCH-----");
        reset();
        ct_rddata <= 8'hFF;  //arbirary random input

        check_output(rdy, 1'b1, "check rdy high after reset");

        en <= 1'b1;
        clock();

        for (int i = 0; i < 10000; i++) begin
            clock();
        end

        check_output(rdy, 1'b1, "check rdy at the end");



        $display("Total number of tests failed is: %d", failed_count);
        $stop;
    end
endmodule : tb_rtl_arc4
