`timescale 1ps / 1ps
module tb_syn_fillscreen ();
    //vsim -L altera_mf_ver -L cyclonev_ver -L altera_ver -L altera_lnsim_ver work.tb_rtl_fillscreen
    logic clk, rst_n, VGA_HS, VGA_VS, VGA_CLK, VGA_PLOT;
    logic [2:0] VGA_COLOUR;
    logic [6:0] VGA_Y;
    logic [7:0] VGA_R, VGA_G, VGA_B, VGA_X;

    reg start;
    wire done;
    reg [2:0] fill_colour = 3'bzzz;  //ignored for task2

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

    fillscreen fs (
        .clk,
        .rst_n,
        .colour(fill_colour),
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
        rst_n = 1'b0;
        #2;
        rst_n = 1'b1;
        #2;
        start = 1'b1;
        #3;
        start = 1'b0;

        for (int i = 0; i < 19210; i++) begin  // this is max allotted time
            if (done != 1'b1) begin
                #10;
                clock_cycles = clock_cycles + 1;
                if (VGA_PLOT == 1 && (VGA_X < 0 || VGA_X >= 160 || VGA_Y < 0 || VGA_Y >= 120)) begin
                    $error("[FAIL] WRITE TO OUT OF BOUNDS X: %d, Y: %d", VGA_X, VGA_Y);
                end
            end
            else start = 0;
        end

        check_output(done, 1, "checking if done in allotted time");
        $display("Clock cycles: %d", clock_cycles);

        $stop;
    end
endmodule : tb_syn_fillscreen
