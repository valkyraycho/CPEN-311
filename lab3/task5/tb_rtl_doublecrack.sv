
`timescale 1 ps / 1 ps
module tb_rtl_doublecrack ();
    reg clk, rst_n;
    integer failed_count = 0;

    doublecrack dut (
        .clk,
        .rst_n,
        .en,
        .rdy,
        .key,
        .key_valid,
        .ct_addr,
        .ct_rddata
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
        $display("-----BEGIN CRACK TB------");

        for (int i = 0; i < 10000; i++) begin
            clock();
            $display("---ITERATION i = %d---", i);
        end

        $stop;
    end
endmodule : tb_rtl_doublecrack
