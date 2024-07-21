`timescale 1ps / 1ps
module tb_rtl_arc4 ();

    reg  rst_n;
    reg  clk = 1'b0;
    reg  en;
    wire rdy;
    reg [7:0] ct_addr, ct_wrdata, ct_rddata, pt_addr, pt_wrdata, pt_rddata;
    reg ct_wren, pt_wren, en_arc4, rdy_arc4;
    reg [23:0] key;

    arc4 DUT (
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
        forever begin
            #1;
            clk = ~clk;
        end
    end


    initial begin  //Success case
        rst_n = 1'b0;
        #2;
        rst_n = 1'b1;
        #500;
        $stop;
        //No automated test. Verification done via comparing the final s memory to our expected result in memory viewer.
    end

endmodule : tb_rtl_arc4
