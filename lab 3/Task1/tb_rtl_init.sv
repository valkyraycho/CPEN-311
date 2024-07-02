`timescale 1ps / 1ps
module tb_rtl_init();



reg rst_n_s, en_s, rdy_s, wren_s;
reg[7:0] wrdata_s, addr_s;
reg clk_s = 1'b0;
init DUT (
.clk(clk_s),.rst_n(rst_n_s),
            .en(en_s), .rdy(rdy_s),
            .addr(addr_s), .wrdata(wrdata_s), .wren(wren_s)
);
initial begin
	forever begin
		clk_s = ~clk_s;
		#1;
	end
end


initial begin //Success case

rst_n_s = 1'b0;
#2;
rst_n_s = 1'b1;
#2;
assert((wren_s === 1'b1) && (rdy_s === 1'b0)&&(wrdata_s === 8'd1))begin
	$display("[PASS], Init starts loading memory as expected");
end else begin
	$error("[FAIL], Init does not start loading memory as expected");
end
#100;
assert((wren_s === 1'b1) && (rdy_s === 1'b0)&&(wrdata_s === 8'd51))begin
	$display("[PASS], Init is loading 51 when expected");
end else begin
	$error("[FAIL], Init is not loading 51 when expected");
end
#600;
assert((wren_s === 1'b0) && (rdy_s === 1'b0))begin
	$display("[PASS], After running once, Init has turned off rdy and wren signals");
end else begin
	$error("[FAIL], After running once, Init has not turned off rdy and wren signals");
end


$stop;
end




endmodule: tb_rtl_init
