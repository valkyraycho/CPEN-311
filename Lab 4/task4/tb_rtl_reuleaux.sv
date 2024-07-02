`timescale 1ps / 1ps
module tb_rtl_reuleaux();
reg clk_s = 1'b0;
reg rst_n_s, start_s;
reg[2:0] colour_s;
reg [7:0] centre_x_s;
reg[6:0] centre_y_s;
reg[7:0] diameter_s;
wire done_s, vga_plot_s;
wire[7:0] vga_x_s;
wire[6:0] vga_y_s;
wire[2:0]vga_colour_s;

reuleaux DUT(.clk(clk_s), .rst_n(rst_n_s), .colour(colour_s),
              .centre_x(centre_x_s), .centre_y(centre_y_s), .diameter(diameter_s),
              .start(start_s), .done(done_s),
              .vga_x(vga_x_s), .vga_y(vga_y_s),
              .vga_colour(vga_colour_s), .vga_plot(vga_plot_s));
initial begin
	forever begin
		clk_s = ~clk_s;
		#1;
	end
end

initial begin //Success case

diameter_s = 8'd80;
centre_x_s = 8'd80;
centre_y_s = 7'd60;
colour_s = 3'd0; // NOT SURE IF THIS IS GREEN OR NOT
start_s = 1'b1;
rst_n_s = 1'b0;
#5;
rst_n_s = 1'b1;

#4;
assert((vga_x_s === 8'd160) && (vga_y_s === 7'd14))begin
	$display("[PASS], The coordinates are correct after the 1st cycle");
end else begin
	$error("[FAIL], The  are incorrect after the 1st cycle");
end
#2;
assert((vga_x_s === 8'd80) && (vga_y_s === 7'd94))begin
	$display("[PASS], The coordinates are correct after the 2nd cycle");
end else begin
	$error("[FAIL], The  are incorrect after the 2nd cycle");
end
#2;
assert((vga_x_s === 8'd0) && (vga_y_s === 7'd14))begin
	$display("[PASS], The coordinates are correct after the 3rd cycle");
end else begin
	$error("[FAIL], The  are incorrect after the 3rd cycle");
end
#2;
assert((vga_x_s === 8'd80) && (vga_y_s === 7'd94))begin
	$display("[PASS], The coordinates are correct after the 4th cycle");
end else begin
	$error("[FAIL], The  are incorrect after the 4th cycle");
end
#2;
assert((vga_x_s === 8'd0) && (vga_y_s === 7'd14))begin
	$display("[PASS], The coordinates are correct after the 5th cycle");
end else begin
	$error("[FAIL], The  are incorrect after the 5th cycle");
end
#2;
assert((vga_x_s === 8'd80) && (vga_y_s === 7'd62))begin
	$display("[PASS], The coordinates are correct after the 6th cycle");
end else begin
	$error("[FAIL], The  are incorrect after the 6th cycle");
end
#2;
assert((vga_x_s === 8'd160) && (vga_y_s === 7'd14))begin
	$display("[PASS], The coordinates are correct after the 7th cycle");
end else begin
	$error("[FAIL], The  are incorrect after the 7th cycle");
end
#20;
assert((vga_x_s === 8'd160) && (vga_y_s === 7'd16))begin
	$display("[PASS], The coordinates are correct after the 17th cycle");
end else begin
	$error("[FAIL], The  are incorrect after the 17th cycle");
end
#2;
assert((vga_x_s === 8'd82) && (vga_y_s === 7'd94))begin
	$display("[PASS], The coordinates are correct after the 18th cycle");
end else begin
	$error("[FAIL], The  are incorrect after the 18th cycle");
end
#2;
assert((vga_x_s === 8'd0) && (vga_y_s === 7'd16))begin
	$display("[PASS], The coordinates are correct after the 19th cycle");
end else begin
	$error("[FAIL], The  are incorrect after the 19th cycle");
end
#2;
assert((vga_x_s === 8'd78) && (vga_y_s === 7'd94))begin
	$display("[PASS], The coordinates are correct after the 20th cycle");
end else begin
	$error("[FAIL], The  are incorrect after the 20th cycle");
end

//No automated test. Verification done via comparing the final s memory to our expected result in memory viewer.
#50000;
assert(done_s === 1'b1)begin
	$display("[PASS], The module asserts done upon completion");
end else begin
	$error("[FAIL], The module does not assert done upon completion");
end
$stop;

end
endmodule: tb_rtl_reuleaux
