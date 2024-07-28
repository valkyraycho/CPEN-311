`timescale 1 ps / 1 ps
module tb_syn_crack ();

    reg clk, rst_n, en;
    reg [7:0] ct_rddata;
    wire rdy, key_valid;
    wire [23:0] key;
    wire [7:0] ct_addr;

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

    crack dut (
        .clk,
        .rst_n,
        .en,
        .rdy,
        .key,
        .key_valid,
        .ct_addr,
        .ct_rddata
    );

    initial begin

        $display("-----BEGIN CRACK TB------");
        reset();

        ct_rddata <= 8'd16;  //this is the message length
        check_output(rdy, 1'b1, "check rdy high after reset");

        en <= 1'b1;
        clock();
        check_output(rdy, 1'b0, "check rdy low after enable");

        //RDY state
        check_output(key, 24'd0, "check key in RDY state");
        check_output(key_valid, 1'b0, "check key_valid in RDY state");
        check_output(ct_addr, 8'b0, "check ct_addr in RDY state");

        clock();
        //READ_MSGLEN state
        check_output(key, 24'd0, "check key in READ_MSGLEN state");
        check_output(key_valid, 1'b0, "check key_valid in READ_MSGLEN state");
        check_output(ct_addr, 8'b0, "check ct_addr in READ_MSGLEN state");

        clock();

        //WAIT1 state
        check_output(key, 24'd0, "check key in WAIT1 state");
        check_output(key_valid, 1'b0, "check key_valid in WAIT1 state");
        check_output(ct_addr, 8'b0, "check ct_addr in WAIT1 state");

        clock();

        ct_rddata <= 8'hff;  //xor with this to get invalid characters in the 

        //START_ARC4 state
        check_output(key, 24'd0, "check key in START_ARC4 state");
        check_output(key_valid, 1'b0, "check key_valid in START_ARC4 state");

        clock();

        //WAIT11 state
        check_output(key, 24'd0, "check key in WAIT11 state");
        check_output(key_valid, 1'b0, "check key_valid in WAIT11 state");

        clock();

        //ARC4 state
        check_output(key, 24'd0, "check key in ARC4 state");
        check_output(key_valid, 1'b0, "check key_valid in ARC4 state");
        check_output(ct_addr, 8'b0, "check ct_addr in ARC4 state");

        for (int i = 0; i < 200000; i++) begin
            clock();
        end

        //stays in ARC4
        check_output(key_valid, 1'b0, "check key valid at the end");
        check_output(key, 24'd0, "check key at the end");

        $display("Total number of tests failed is: %d", failed_count);
        $stop;

    end

endmodule : tb_syn_crack
