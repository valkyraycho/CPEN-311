`timescale 1ps / 1ps
module tb_rtl_ksa ();
    logic rst_n, wren;
    logic clk = 1'b0;
    logic [3:0] KEY;
    logic [9:0] SW, LEDR;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [23:0] key;
    logic [7:0] addr, wrdata, i;
    logic [7:0] rddata;
    logic rdy;
    assign KEY[3] = rst_n;
    logic en = 1'b1;

    ksa DUT (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .rdy(rdy),
        .key(key),
        .addr(addr),
        .rddata(rddata),
        .wrdata(wrdata),
        .wren(wren)
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
        #2;
        assert ((addr === 8'd0)) begin
            $display("[PASS], ksa resets properly");
        end
        else begin
            $error("[FAIL], ksa does not reset properly");
        end
        #1;
        #4082;
        assert ((rdy === 1'b1)) begin
            $display("[PASS], ksa enables next module after finishing");
        end
        else begin
            $error("[FAIL], ksa does not enable next module after finishing");
        end
        #200;

        $stop;

    end


endmodule : tb_rtl_ksa
