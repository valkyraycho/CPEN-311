`timescale 1 ps / 1 ps
module tb_syn_task2();

reg CLOCK_50;   
reg [3:0] KEY;
reg [9:0] SW;
wire [9:0] LEDR;
wire [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

integer failed_count = 0;

task2 dut(.CLOCK_50, .KEY, .SW, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .LEDR);

task clock; CLOCK_50 <= 1'b1; #5; CLOCK_50 <= 1'b0; #5; endtask
task reset; KEY[3] <= 1'b0; #5; KEY[3] <= 1'b1; #5; endtask

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
    
SW <= 10'b1100111100;
KEY[0] <= 1'b1;

reset();

KEY[0] <= 1'b0;
clock();
KEY[0] <= 1'b1;
//clock();

$display("------INIT STATE-------");
for (int i = 0; i <= 255; i++) begin    
    $display("-- i = %d --", i);  
    #2;
    check_output(LEDR[0], 1'b0, "check for init state");
    check_output(LEDR[1], 1'b1, "check for ksa state");
    clock();
end
 
clock();
$display("------KSA STATE-------");
for (int i = 0; i <= 3000; i++) begin    
    if (LEDR[1] != 1'b1) begin
        $display("-- i = %d --", i); 
        check_output(LEDR[0], 1'b1, "check for init state");
        check_output(LEDR[1], 1'b0, "check for ksa state");
        clock();
    end
end
   
$displayh("s: %p", \s|altsyncram_component|auto_generated|altsyncram1|ram_block3a0 .ram_core0.ram_core0.mem);
$display("expected: 0000: b4 04 2b e5 49 0a 90 9a e4 17 f4 10 3a 36 13 77\n0010: 11 c4 bc 38 4f 6d 98 06 6e 3d 2c ae cd 26 40 a2\n0020: c2 da 67 68 5d 3e 02 73 03 aa 94 69 6a 97 6f 33\n0030: 63 5b 8a 58 d9 61 f5 46 96 55 7d 53 5f ab 07 9c\n0040: a7 72 31 a9 c6 3f f9 91 f2 f6 7c c7 b3 1d 20 88\n0050: a0 ba 0c 85 e1 cf cb 51 c0 2e ef 80 76 b2 d6 71\n0060: 24 ad 6b db ff fe ed 84 4e 8c bb d3 a5 2f be c8\n0070: 0e 8f d1 a6 86 e3 62 b0 87 ec b9 78 81 e0 4d 5a\n0080: 7a 79 14 29 56 e8 4a 8e 18 c5 ca b7 25 de 99 c3\n0090: 2a 65 30 1a ea fb a1 89 35 a4 09 a3 c1 d8 2d b8\n00a0: 60 47 39 bd 1f 05 5e 43 b1 dd e9 1c af 9b fa 01\n00b0: f7 08 75 b6 82 ce 42 e2 cc 9e eb 27 22 df bf fc\n00c0: 0d d0 95 23 d2 a8 7e 74 4c d7 12 7f fd 83 1e 28\n00d0: 64 54 3c 21 dc f3 93 59 8b 7b 00 48 e7 6c d5 c9\n00e0: 70 9f ac 41 0b f0 19 b5 8d 16 d4 f1 92 9d 66 44\n00f0: 4b 15 45 f8 0f 57 34 32 50 52 ee 3b 5c 37 e6 1b");
   
$display("Total number of tests failed is: %d", failed_count);
$stop;
end

endmodule: tb_syn_task2

