`timescale 1ps / 1ps
module tb_syn_ksa();



reg rst_n_s, wren_s, en_s;
reg clk_s = 1'b0;
wire[3:0] KEY_s;
reg[9:0] SW_s, LEDR_s;
reg[6:0] HEX0_s,HEX1_s,HEX2_s,HEX3_s,HEX4_s,HEX5_s;
reg[23:0] key_s;
reg[7:0] addr_s, wrdata_s, i;
wire[7:0] rddata_s;
wire rdy_s;
assign KEY_s[3] = rst_n_s;

ksa DUT(.clk(clk_s), .rst_n(rst_n_s),
           .en(en_s), .rdy(rdy_s),
           .key(key_s),
           .addr(addr_s), .rddata(rddata_s), .wrdata(wrdata_s), .wren(wren_s));
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
en_s = 1'b1;
assert((addr_s === 8'd0))begin
	$display("[PASS], ksa resets properly");
end else begin
	$error("[FAIL], ksa does not reset properly");
end
#1;
en_s = 1'b0;
#4082;
assert((rdy_s === 1'b1))begin
	$display("[PASS], ksa enables next module after finishing");
end else begin
	$error("[FAIL], ksa does not enable next module after finishing");
end
#200;

$stop;

end

endmodule: tb_syn_ksa
