`timescale 1 ps / 1 ps
module tb_rtl_ksa();    

reg clk, rst_n, en;
reg [23:0] key;
reg [7:0] rddata;
wire rdy, wren;
wire [7:0] addr, wrdata;
reg[7:0] checking;
integer j = 0;

wire [7:0] keybyte [0:2];
assign keybyte[0] = key[23:16];
assign keybyte[1] = key[15:8];
assign keybyte[2] = key[7:0];

integer failed_count = 0;

ksa dut(.clk, .rst_n, .en, .rdy, .key, .addr, .rddata, .wrdata, .wren);

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

    key[23:10] <= 14'b00000000000000;
    key[9:0] <= 10'b1100111100;

    $display("--TESTING ONE FULL ITERATION--");
    reset();
    check_output(rdy, 1'b1, "check ready high after reset"); 
    en <= 1'b1;
    clock();
    check_output(rdy, 1'b0, "check ready low after enable"); 

    //READ_SI state
    rddata <= 8'b00000000;
    check_output(addr, 8'd0, "READ_SI read address");
    check_output(wrdata, 8'd0, "READ_SI write data");
    check_output(wren, 1'b0, "READ_SI write en");
    
    clock();
    check_output(rdy, 1'b0, "check rdy low after en");

    //WAIT1 state
    check_output(addr, 8'd0, "WAIT1 read address");
    check_output(wrdata, 8'd0, "WAIT1 write data");
    check_output(wren, 1'b0, "WAIT1 write en");

    clock();

    //COMPUTE_J state
    check_output(addr, 8'd0, "COMPUTE_J read address");
    check_output(wrdata, 8'd0, "COMPUTE_J write data");
    check_output(wren, 1'b0, "COMPUTE_J write en");

    clock();    //now the value of index "j" known


    //READ_SJ state
    check_output(addr, (keybyte[1'b0 % 3] % 256), "READ_SJ read address");
    check_output(wrdata, 8'd0, "READ_SJ write data");
    check_output(wren, 1'b0, "READ_SJ write en");

    clock();

    //WAIT2 state
    check_output(addr, (keybyte[1'b0 % 3] % 256), "WAIT2 read address");
    check_output(wrdata, 8'd0, "WAIT2 write data");
    check_output(wren, 1'b0, "WAIT2 write en");

        rddata <= (keybyte[1'b0 % 3] % 256);

    clock();

    //WRITE_SJ state
    check_output(addr, (keybyte[1'b0 % 3] % 256), "WRITE_SJ read address");
    check_output(wrdata, (keybyte[1'b0 % 3] % 256), "WRITE_SJ write data");
    check_output(wren, 1'b1, "WRITE_SJ write en");

    clock();

    //WRITE_SI state
    check_output(addr, 8'd0, "WRITE_SJ read address");
   check_output(wrdata, (keybyte[1'b0 % 3] % 256), "WRITE_SJ write data");
    check_output(wren, 1'b1, "WRITE_SJ write en");

    clock();

    //INC_I state
    check_output(addr, 8'd0, "INC_I read address");
    check_output(wrdata, 8'd0, "INC_I write data");
    check_output(wren, 1'b0, "INC_I write en");

    clock();

    $display("--ITERATE THROUGH 255 VALUES--");

    for (int i = 1; i <= 255; i++) begin
        $display("---ITERATION i = %d---", i);
        //READ_SI state
        rddata <= i;
        check_output(addr, i, "READ_SI read address");
        check_output(wrdata, 8'd0, "READ_SI write data");
        check_output(wren, 1'b0, "READ_SI write en");
        
        clock();
        check_output(rdy, 1'b0, "check rdy low after en");

        //WAIT1 state
        check_output(addr, i, "WAIT1 read address");
        check_output(wrdata, 8'd0, "WAIT1 write data");
        check_output(wren, 1'b0, "WAIT1 write en");

        clock();

        //COMPUTE_J state
        check_output(addr, i, "COMPUTE_J read address");
        check_output(wrdata, 8'd0, "COMPUTE_J write data");
        check_output(wren, 1'b0, "COMPUTE_J write en");

        clock();    //now the value of index "j" known

        //READ_SJ state
        //check_output(addr, (keybyte[i % 3] % 256), "READ_SJ read address");
        check_output(wrdata, 8'd0, "READ_SJ write data");
        check_output(wren, 1'b0, "READ_SJ write en");

        clock();

        //WAIT2 state
       // check_output(addr, (keybyte[i % 3] % 256), "WAIT2 read address");
        check_output(wrdata, 8'd0, "WAIT2 write data");
        check_output(wren, 1'b0, "WAIT2 write en");

         //   rddata <= (keybyte[i % 3] % 256);

        clock();

        //WRITE_SJ state
       // check_output(addr, (keybyte[i % 3] % 256), "WRITE_SJ read address");
       // check_output(wrdata, (keybyte[i % 3] % 256), "WRITE_SJ write data");
        check_output(wren, 1'b1, "WRITE_SJ write en");

        clock();

        //WRITE_SI state
        check_output(addr, i, "WRITE_SI read address");
       // check_output(wrdata, (keybyte[i % 3] % 256), "WRITE_SI write data");
        check_output(wren, 1'b1, "WRITE_SI write en");

        clock();

        //INC_I state
        check_output(addr, 8'd0, "INC_I read address");
        check_output(wrdata, 8'd0, "INC_I write data");
        check_output(wren, 1'b0, "INC_I write en");

        clock();

    end
  
    $display("Total number of tests failed is: %d", failed_count);
    $stop;
end
endmodule: tb_rtl_ksa
