`timescale 1 ps / 1 ps
module tb_syn_task4();

reg CLOCK_50;   
reg [3:0] KEY;
reg [9:0] SW;
wire [9:0] LEDR;
wire [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;

integer clock_cycles = 0;

task4 dut(.CLOCK_50, .KEY, .SW, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .LEDR);

task en; KEY[0] <= 1'b0; #10; KEY[0] <= 1'b1; endtask
task reset; KEY[3] <= 1'b0; #10; KEY[3] <= 1'b1; endtask

initial begin
    CLOCK_50 <= 1'b1;
    forever #5 CLOCK_50 = ~CLOCK_50;
end

initial begin
    KEY[0] <= 1'b1;
    KEY[3] <= 1'b1;
    #10; // initialize mem module so no race condition
    reset();

    $readmemh("test1.memh", \ct|altsyncram_component|auto_generated|altsyncram1|ram_block3a0 .ram_core0.ram_core0.mem);
    #20;

    en();

    #10;

    for (int i = 0; i <= 60000; i++) begin
        if (LEDR[0] == 1'b0) begin
            #10;
            clock_cycles = clock_cycles + 1;
        end
    end

    #40;

    $display("crack time: %d cycles", clock_cycles);

    $displayh("pt: %p", \c|pt|altsyncram_component|auto_generated|altsyncram1|ram_block3a0 .ram_core0.ram_core0.mem);
    $display("expected: 49 6e 20 61 20 68 6f 6c 65 20 69 6e 20 74 68\n65 20 67 72 6f 75 6e 64 20 74 68 65 72 65 20 6c\n69 76 65 64 20 61 20 68 6f 62 62 69 74 2e");

    check_output(HEX5, 7'b1000000, "CHECKING HEX5");
    check_output(HEX4, 7'b1000000, "CHECKING HEX4");
    check_output(HEX3, 7'b1000000, "CHECKING HEX3");
    check_output(HEX2, 7'b1000000, "CHECKING HEX2");
    check_output(HEX1, 7'b1000000, "CHECKING HEX1");
    check_output(HEX0, 7'b1111001, "CHECKING HEX0");

    reset();
    clock_cycles <= 0;

    $readmemh("test2.memh", \ct|altsyncram_component|auto_generated|altsyncram1|ram_block3a0 .ram_core0.ram_core0.mem);
    #20;

    en();

    #10;

    for (int i = 0; i <= 60000; i++) begin
        if (LEDR[0] == 1'b0) begin
            #10;
            clock_cycles = clock_cycles + 1;
        end
    end

    #40;

    $display("crack time: %d cycles", clock_cycles);

    $displayh("pt: %p", \c|pt|altsyncram_component|auto_generated|altsyncram1|ram_block3a0 .ram_core0.ram_core0.mem);
    $display("expected: 54 68 65 20 73 6b 79 20 61 62 6f 76 65 20 74\n68 65 20 70 6f 72 74 20 77 61 73 20 74 68 65 20\n63 6f 6c 6f 72 20 6f 66 20 74 65 6c 65 76 69 73\n69 6f 6e 2c 20 74 75 6e 65 64 20 74 6f 20 61 20\n64 65 61 64 20 63 68 61 6e 6e 65 6c 2e");

    check_output(HEX5, 7'b1000000, "CHECKING HEX5");
    check_output(HEX4, 7'b1000000, "CHECKING HEX4");
    check_output(HEX3, 7'b1000000, "CHECKING HEX3");
    check_output(HEX2, 7'b1000000, "CHECKING HEX2");
    check_output(HEX1, 7'b1000000, "CHECKING HEX1");
    check_output(HEX0, 7'b1111000, "CHECKING HEX0");

    $stop;
end
endmodule: tb_syn_task4
