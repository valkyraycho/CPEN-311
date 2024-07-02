`timescale 1 ps / 1 ps

module tb_rtl_task3();

// Your testbench goes here. Our toplevel will give up after 1,000,000 ticks.
reg sim_clk;
reg rst_n;
reg [9:0] LEDR;
reg [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
reg [7:0] VGA_R,VGA_G,VGA_B;
reg VGA_HS;
reg VGA_VS;
reg VGA_CLK;
reg [7:0] VGA_X;
reg [6:0] VGA_Y;
reg [2:0] VGA_COLOUR;
reg VGA_PLOT;

task3 DUT(
    .CLOCK_50(sim_clk),.KEY({rst_n,3'b0}),.SW(0),.LEDR(LEDR),.HEX0(HEX0),.HEX1(HEX1),.HEX2(HEX2),.HEX3(HEX3),
    .HEX4(HEX4),.HEX5(HEX5),.VGA_R(VGA_R),.VGA_G(VGA_G),.VGA_B(VGA_B),.VGA_HS(VGA_HS),.VGA_VS(VGA_VS),
    .VGA_CLK(VGA_CLK),.VGA_X(VGA_X),.VGA_Y(VGA_Y),.VGA_COLOUR(VGA_COLOUR),.VGA_PLOT(VGA_PLOT)
);

initial begin 
forever begin
    sim_clk = 1;
    #1;
    sim_clk = 0;
    #1;
end

end 

initial begin
    #100;
    rst_n = 1;
    #5;
    rst_n = 0;
    #5;
    rst_n = 1;
#38421;

assert((VGA_X === 7'd79) && (VGA_Y === 8'd61))begin
	$display("[PASS], The coordinates are correct after the 19265th cycle");
end else begin
	$error("[FAIL], The coordinates are incorrect after the 19265th cycle");
end
#2;
assert((VGA_X === 7'd81) && (VGA_Y === 8'd59))begin
	$display("[PASS], The coordinates are correct after the 19266th cycle");
end else begin
	$error("[FAIL], The coordinates are incorrect after the 19266th cycle");
end
#2;
assert((VGA_X === 7'd81) && (VGA_Y === 8'd61))begin
	$display("[PASS], The coordinates are correct after the 19267th cycle");
end else begin
	$error("[FAIL], The coordinates are incorrect after the 19267th cycle");
end
#12;
assert((VGA_X === 7'd79) && (VGA_Y === 8'd62))begin
	$display("[PASS], The coordinates are correct after the 19273th cycle");
end else begin
	$error("[FAIL], The coordinates are incorrect after the 19273th cycle");
end
#10000;
$stop;

end
endmodule: tb_rtl_task3
