`timescale 1 ps / 1 ps
module tb_syn_prga();

reg clk, rst_n, en;
reg [23:0] key;
reg [7:0] s_rddata, ct_rddata, pt_rddata;
wire [7:0] s_addr, s_wrdata, ct_addr, pt_addr, pt_wrdata;
wire s_wren, pt_wren, rdy;

prga dut(.clk, .rst_n, .en, .rdy, .key, .s_addr, .s_rddata, .s_wrdata, .s_wren, .ct_addr, 
            .ct_rddata, .pt_addr, .pt_rddata, .pt_wrdata, .pt_wren);

integer failed_count = 0;
integer i;
integer j = 0;

task clock; clk <= 1'b0; #5; clk <= 1'b1; #5; endtask
task reset; rst_n <= 1'b0; #5; rst_n <= 1'b1; #5; endtask

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
    $display("----BEGIN PRGA TB----");
    reset();
    check_output(rdy, 1'b1, "check rdy high after reset");

    //RDY state
    check_output(s_addr, 8'd0, "check s_addr in RDY state");
    check_output(s_wrdata, 8'd0, "check s_wrdata in RDY state");
    check_output(s_wren, 1'd0, "check s_wren in RDY state");
    check_output(ct_addr, 8'd0, "check ct_addr in RDY state");
    check_output(pt_addr, 8'd0, "check pt_addr in RDY state");
    check_output(pt_wrdata, 8'd0, "check pt_wrdata in RDY state");
    check_output(pt_wren, 1'd0, "check pt_wren in RDY state");

    en <= 1'b1;
    ct_rddata <= 8'd16;  //input some number as ct rddata input (this is like the ct length)

    clock();
    check_output(rdy, 1'b0, "check rdy low after enable");

    //READ_MSGLEN state
    check_output(s_addr, 8'd0, "check s_addr in READ_MSGLEN state");
    check_output(s_wrdata, 8'd0, "check s_wrdata in READ_MSGLEN state");
    check_output(s_wren, 1'd0, "check s_wren in READ_MSGLEN state");
    check_output(ct_addr, 8'd0, "check ct_addr in READ_MSGLEN state");
    check_output(pt_addr, 8'd0, "check pt_addr in READ_MSGLEN state");
    check_output(pt_wrdata, 8'd0, "check pt_wrdata in READ_MSGLEN state");
    check_output(pt_wren, 1'd0, "check pt_wren in READ_MSGLEN state");

    clock();
    //WAIT1 state
    check_output(s_addr, 8'd0, "check s_addr in WAIT1 state");
    check_output(s_wrdata, 8'd0, "check s_wrdata in WAIT1 state");
    check_output(s_wren, 1'd0, "check s_wren in WAIT1 state");
    check_output(ct_addr, 8'd0, "check ct_addr in WAIT1 state");
    check_output(pt_addr, 8'd0, "check pt_addr in WAIT1 state");
    check_output(pt_wrdata, ct_rddata, "check pt_wrdata in WAIT1 state");
    check_output(pt_wren, 1'd1, "check pt_wren in WAIT1 state");

    clock();
    
    for (i = 0; i <= (ct_rddata - 1); i++) begin 
        $display("---ITERATION i = %d---", i);
    //CALC_I state
    //i <= (i+1)%256;
    check_output(s_addr, 8'd0, "check s_wrdata in CALC_I state");
    check_output(s_wrdata, 8'd0, "check s_wrdata in CALC_I state");
    check_output(s_wren, 1'd0, "check s_wren in CALC_I state");
    check_output(ct_addr, 8'd0, "check ct_addr in CALC_I state");
    check_output(pt_addr, 8'd0, "check pt_addr in CALC_I state");
    check_output(pt_wrdata, 8'd0, "check pt_wrdata in CALC_I state");
    check_output(pt_wren, 1'd0, "check pt_wren in CALC_I state");

    clock();
    //READ_SI state
    check_output(s_addr, (i+1)%256, "check s_addr in READ_SI state");
    check_output(s_wrdata, 8'd0, "check s_wrdata in READ_SI state");
    check_output(s_wren, 1'd0, "check s_wren in READ_SI state");
    check_output(ct_addr, 8'd0, "check ct_addr in READ_SI state");
    check_output(pt_addr, 8'd0, "check pt_addr in READ_SI state");
    check_output(pt_wrdata, 8'd0, "check pt_wrdata in READ_SI state");
    check_output(pt_wren, 1'd0, "check pt_wren in READ_SI state");

    s_rddata <= 8'd255 - i;   //input (s[i])
    clock();
    //CALC_J state
    j <= (j +s_rddata) % 256;
    check_output(s_addr, 8'd0, "check s_addr in CALC_J state");
    check_output(s_wrdata, 8'd0, "check s_wrdata in CALC_J state");
    check_output(s_wren, 1'd0, "check s_wren in CALC_J state");
    check_output(ct_addr, 8'd0, "check ct_addr in CALC_J state");
    check_output(pt_addr, 8'd0, "check pt_addr in CALC_J state");
    check_output(pt_wrdata, 8'd0, "check pt_wrdata in CALC_J state");
    check_output(pt_wren, 1'd0, "check pt_wren in CALC_J state");

    clock();
    //READ_SJ state
    check_output(s_addr, j, "check s_addr in READ_SJ state");
    check_output(s_wrdata, 8'd0, "check s_wrdata in READ_SJ state");
    check_output(s_wren, 1'd0, "check s_wren in READ_SJ state");
    check_output(ct_addr, 8'd0, "check ct_addr in READ_SJ state");
    check_output(pt_addr, 8'd0, "check pt_addr in READ_SJ state");
    check_output(pt_wrdata, 8'd0, "check pt_wrdata in READ_SJ state");
    check_output(pt_wren, 1'd0, "check pt_wren in READ_SJ state");

    s_rddata <= i;  //input (s[j])
    clock();
    //WRITE_SJ state
    check_output(s_addr, j, "check s_addr in WRITE_SJ state");
    check_output(s_wrdata, 8'd255 - i, "check s_wrdata in WRITE_SJ state"); //this is s[i]
    check_output(s_wren, 1'd1, "check s_wren in WRITE_SJ state");
    check_output(ct_addr, 8'd0, "check ct_addr in WRITE_SJ state");
    check_output(pt_addr, 8'd0, "check pt_addr in WRITE_SJ state");
    check_output(pt_wrdata, 8'd0, "check pt_wrdata in WRITE_SJ state");
    check_output(pt_wren, 1'd0, "check pt_wren in WRITE_SJ state");

    clock();
    //WRITE_SI state
    check_output(s_addr, (i+1)%256, "check s_addr in WRITE_SI state");
    check_output(s_wrdata, i, "check s_wrdata in WRITE_SI state"); //this is s[j]
    check_output(s_wren, 1'd1, "check s_wren in WRITE_SI state");
    check_output(ct_addr, 8'd0, "check ct_addr in WRITE_SI state");
    check_output(pt_addr, 8'd0, "check pt_addr in WRITE_SI state");
    check_output(pt_wrdata, 8'd0, "check pt_wrdata in WRITE_SI state");
    check_output(pt_wren, 1'd0, "check pt_wren in WRITE_SI state");

    clock();
    //WAIT2 state
    check_output(s_addr, 8'd0, "check s_addr in WAIT2 state");
    check_output(s_wrdata, 8'd0, "check s_wrdata in WAIT2 state");
    check_output(s_wren, 1'd0, "check s_wren in WAIT2 state");
    check_output(ct_addr, 8'd0, "check ct_addr in WAIT2 state");
    check_output(pt_addr, 8'd0, "check pt_addr in WAIT2 state");
    check_output(pt_wrdata, 8'd0, "check pt_wrdata in WAIT2 state");
    check_output(pt_wren, 1'd0, "check pt_wren in WAIT2 state");

    clock();
    //READ_S_IJ state
    check_output(s_addr, (i+(255-i))%256, "check s_addr in READ_S_IJ state");   //si+sj mod 256
    check_output(s_wrdata, 8'd0, "check s_wrdata in READ_S_IJ state");
    check_output(s_wren, 1'd0, "check s_wren in READ_S_IJ state");
    check_output(ct_addr, 8'd0, "check ct_addr in READ_S_IJ state");
    check_output(pt_addr, 8'd0, "check pt_addr in READ_S_IJ state");
    check_output(pt_wrdata, 8'd0, "check pt_wrdata in READ_S_IJ state");
    check_output(pt_wren, 1'd0, "check pt_wren in READ_S_IJ state");

    s_rddata <= (i+3)%256;  //arbirary input for s_i
    clock();
    //READ_CT state
    check_output(s_addr, 8'd0, "check s_addr in READ_CT state");   //si+sj mod 256
    check_output(s_wrdata, 8'd0, "check s_wrdata in READ_CT state");
    check_output(s_wren, 1'd0, "check s_wren in READ_CT state");
    check_output(ct_addr, i+1, "check ct_addr in READ_CT state");
    check_output(pt_addr, 8'd0, "check pt_addr in READ_CT state");
    check_output(pt_wrdata, 8'd0, "check pt_wrdata in READ_CT state");
    check_output(pt_wren, 1'd0, "check pt_wren in READ_CT state");

    clock();
    //WAIT3 state
    check_output(s_addr, 8'd0, "check s_addr in WAIT3 state");   //si+sj mod 256
    check_output(s_wrdata, 8'd0, "check s_wrdata in WAIT3 state");
    check_output(s_wren, 1'd0, "check s_wren in WAIT3 state");
    check_output(ct_addr, 8'd0, "check ct_addr in WAIT3 state");
    check_output(pt_addr, 8'd0, "check pt_addr in WAIT3 state");
    check_output(pt_wrdata, 8'd0, "check pt_wrdata in WAIT3 state");
    check_output(pt_wren, 1'd0, "check pt_wren in WAIT3 state");

    clock();
    //WRITE_PT state
    check_output(s_addr, 8'd0, "check s_addr in WRITE_PT state");   //si+sj mod 256
    check_output(s_wrdata, 8'd0, "check s_wrdata in WRITE_PT state");
    check_output(s_wren, 1'd0, "check s_wren in WRITE_PT state");
    check_output(ct_addr, 8'd0, "check ct_addr in WRITE_PT state");
    check_output(pt_addr, i+1, "check pt_addr in WRITE_PT state");
    check_output(pt_wrdata, (i+3)%256 ^ ct_rddata, "check pt_wrdata in WRITE_PT state");
    check_output(pt_wren, 1'd1, "check pt_wren in WRITE_PT state");

    clock();
    //INC_K state
    check_output(s_addr, 8'd0, "check s_addr in INC_K state");   //si+sj mod 256
    check_output(s_wrdata, 8'd0, "check s_wrdata in INC_K state");
    check_output(s_wren, 1'd0, "check s_wren in INC_K state");
    check_output(ct_addr, 8'd0, "check ct_addr in INC_K state");
    check_output(pt_addr, 8'd0, "check pt_addr in INC_K state");
    check_output(pt_wrdata, 8'd0, "check pt_wrdata in INC_K state");
    check_output(pt_wren, 1'd0, "check pt_wren in INC_K state");
    clock();
    end 
    $display("Total number of tests failed is: %d", failed_count);
    $stop;
end

endmodule: tb_syn_prga
