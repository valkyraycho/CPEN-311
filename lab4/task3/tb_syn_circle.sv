`timescale 1 ps / 1 ps
module tb_rtl_circle ();
    // vsim -L altera_mf_ver -L cyclonev_ver -L altera_ver -L altera_lnsim_ver work.tb_rtl_circle
    // allocation of clock cycles: 232 + 10 = 244 cycles

    logic clk, rst_n, VGA_HS, VGA_VS, VGA_CLK, VGA_PLOT;
    logic [2:0] VGA_COLOUR;
    logic [6:0] VGA_Y;
    logic [7:0] VGA_R, VGA_G, VGA_B, VGA_X;

    reg start;
    wire done;
    reg [2:0] colour;
    reg [7:0] centre_x = 8'd80;
    reg [6:0] centre_y = 7'd60;
    reg [7:0] radius = 8'd40;

    // for vga module
    logic [9:0] VGA_R_10;
    logic [9:0] VGA_G_10;
    logic [9:0] VGA_B_10;
    logic VGA_BLANK, VGA_SYNC;

    assign VGA_R = VGA_R_10[9:2];
    assign VGA_G = VGA_G_10[9:2];
    assign VGA_B = VGA_B_10[9:2];

    integer clock_cycles = 0;
    integer failed_count = 0;

    circle dut (
        .clk,
        .rst_n,
        .colour,
        .centre_x,
        .centre_y,
        .radius,
        .start,
        .done,
        .vga_x(VGA_X),
        .vga_y(VGA_Y),
        .vga_colour(VGA_COLOUR),
        .vga_plot(VGA_PLOT)
    );

    vga_adapter #(
        .RESOLUTION("160x120")
    ) vga_u0 (
        .resetn(rst_n),
        .clock(clk),
        .colour(VGA_COLOUR),
        .x(VGA_X),
        .y(VGA_Y),
        .plot(VGA_PLOT),
        .VGA_R(VGA_R_10),
        .VGA_G(VGA_G_10),
        .VGA_B(VGA_B_10),
        .*
    );

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
        clk = 0;
        forever #1 clk = ~clk;
    end

    initial begin

        colour   = 3'b010;  //green
        // actual task 3 circle dimensions
        centre_x = 8'd80;
        centre_y = 7'd60;
        radius   = 8'd40;

        //TEST 1: GREEN CIRCLE W/ GIVEN DIMENSIONS  
        rst_n    = 1'b0;
        #2;
        rst_n = 1'b1;
        #2;
        start = 1'b1;
        #3;
        start = 1'b0;

        $display("TEST 1: GREEN CIRCLE W/ GIVEN DIMENSIONS");

        for (int i = 0; i < 244; i++) begin  // this is max allotted time
            if (!done) begin
                clock_cycles = clock_cycles + 1;

                if (VGA_PLOT == 1 && (VGA_X < 0 || VGA_X >= 160 || VGA_Y < 0 || VGA_Y >= 120)) begin
                    $error("[FAIL] WRITE TO OUT OF BOUNDS X: %d, Y: %d", VGA_X, VGA_Y);
                end
                else begin
                    if (clock_cycles != 0 && clock_cycles <= 232) begin
                        check_output(VGA_PLOT, 1, "checking if plot is high in OCT1-OCT7 states");
                    end
                    else begin
                        check_output(VGA_PLOT, 0, "checking if plot is low in RDY and DONE");
                    end
                end
                #2;
            end
        end

        check_output(done, 1, "checking if done in allotted time");
        $display("Clock cycles for test 1: %d", clock_cycles);

        //TEST 2: RED CIRCLE WITH DIMENSIONS C_X = 70, C_Y = 50, R = 30

        clock_cycles = 0;

        // circle dimensions
        centre_x     = 8'd70;
        centre_y     = 7'd50;
        radius       = 8'd30;
        colour       = 3'b100;  //red

        rst_n        = 1'b0;
        #2;
        rst_n = 1'b1;
        #2;
        start = 1'b1;
        #3;
        start = 1'b0;


        $display("TEST 2: RED CIRCLE W/ NEW DIMENSIONS");

        for (int i = 0; i < 186; i++) begin  // this is max allotted time
            if (done != 1'b1) begin
                clock_cycles = clock_cycles + 1;

                if (VGA_PLOT == 1 && (VGA_X < 0 || VGA_X >= 160 || VGA_Y < 0 || VGA_Y >= 120)) begin
                    $error("[FAIL] WRITE TO OUT OF BOUNDS X: %d, Y: %d", VGA_X, VGA_Y);
                end
                else begin
                    if (clock_cycles != 0 && clock_cycles <= 176) begin
                        check_output(VGA_PLOT, 1, "checking if plot is high in OCT1-OCT7 states");
                    end
                    else begin
                        check_output(VGA_PLOT, 0, "checking if plot is low in RDY and DONE");
                    end
                end
                #2;
            end
        end

        check_output(done, 1, "checking if done in allotted time");
        $display("Clock cycles for test 2: %d", clock_cycles);



        //TEST 3: BLUE CIRCLE WITH OUT-OF-BOUNDS DIMENSIONS C_X = 150, C_Y = 120, R = 90
        clock_cycles = 0;

        colour       = 3'b001;  //blue
        // actual task 3 circle dimensions
        centre_x     = 8'd150;
        centre_y     = 7'd120;
        radius       = 8'd90;

        rst_n        = 1'b0;
        #2;
        rst_n = 1'b1;
        #2;
        start = 1'b1;
        #3;
        start = 1'b0;


        $display("TEST 3: RED CIRCLE W/ OUT-OF-BOUNDS DIMENSIONS");

        for (int i = 0; i < 512; i++) begin  // this is max allotted time
            if (done != 1'b1) begin
                clock_cycles = clock_cycles + 1;

                if (VGA_PLOT == 1'b1 && (VGA_X < 0 || VGA_X >= 160 || VGA_Y < 0 || VGA_Y >= 120)) begin
                    $error("[FAIL] WRITE TO OUT OF BOUNDS X: %d, Y: %d", VGA_X, VGA_Y);
                end
                else if (VGA_PLOT == 1'b1) begin
                    if (clock_cycles != 0 && clock_cycles <= 512) begin
                        check_output(VGA_PLOT, 1, "checking if plot is high in OCT1-OCT7 states");
                    end
                    else begin
                        check_output(VGA_PLOT, 0, "checking if plot is low in RDY and DONE");
                    end
                end
                #2;
            end
        end

        check_output(done, 1, "checking if done in allotted time");
        $display("Clock cycles for test 3: %d", clock_cycles);


        $display("Failed count: %d", failed_count);

        $stop;
    end
endmodule : tb_rtl_circle
