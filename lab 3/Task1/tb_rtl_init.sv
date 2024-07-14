`timescale 1ps / 1ps
module tb_rtl_init ();
    logic rst_n, en, rdy, wren;
    logic [7:0] wrdata, addr;
    logic clk = 1'b1;
    init DUT (
        .clk,
        .rst_n,
        .en,
        .rdy,
        .addr,
        .wrdata,
        .wren
    );
    initial begin
        forever begin
            clk = ~clk;
            #1;
        end
    end


    initial begin  //Success case

        rst_n = 1'b0;
        en    = 1'b1;
        #2;
        rst_n = 1'b1;
        #2;
        assert ((wren === 1'b1) && (rdy === 1'b0) && (wrdata === 8'd1)) begin
            $display("[PASS], Init starts loading memory as expected");
        end
        else begin
            $error("[FAIL], Init does not start loading memory as expected");
        end
        #100;
        assert ((wren === 1'b1) && (rdy === 1'b0) && (wrdata === 8'd51)) begin
            $display("[PASS], Init is loading 51 when expected");
        end
        else begin
            $error("[FAIL], Init is not loading 51 when expected");
        end
        #600;
        assert ((wren === 1'b0) && (rdy === 1'b0)) begin
            $display("[PASS], After running once, Init has turned off rdy and wren signals");
        end
        else begin
            $error("[FAIL], After running once, Init has not turned off rdy and wren signals");
        end


        $stop;
    end




endmodule : tb_rtl_init
