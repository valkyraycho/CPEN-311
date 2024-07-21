`timescale 1ps / 1ps
module tb_syn_circle();

reg clk_s = 1'b0;
reg rst_n_s, start_s;
reg[2:0] colour_s;
reg [7:0] centre_x_s;
reg[6:0] centre_y_s;
reg[7:0] radius_s;
wire done_s, vga_plot_s;
wire[7:0] vga_x_s;
wire[6:0] vga_y_s;
wire[2:0]vga_colour_s;

circle DUT(.clk(clk_s), .rst_n(rst_n_s), .colour(colour_s),
              .centre_x(centre_x_s), .centre_y(centre_y_s), .radius(radius_s),
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

radius_s = 8'd40;
centre_x_s = 8'd80;
centre_y_s = 7'd60;
colour_s = 3'd2; // NOT SURE IF THIS IS GREEN OR NOT
start_s = 1'b1;
rst_n_s = 1'b0;
#5;
rst_n_s = 1'b1;

#2;
assert((vga_y_s === 7'd60) && (vga_x_s === 8'd120))begin
	$display("[PASS], The coordinates are correct after the 1st cycle");
end else begin
	$error("[FAIL], The coordinates are incorrect after the 1st cycle");
end
#8;
assert((vga_y_s === 7'd60) && (vga_x_s === 8'd40))begin
	$display("[PASS], The coordinates are correct after the 5th cycle");
end else begin
	$error("[FAIL], The coordinates are incorrect after the 5th cycle");
end
#6;
assert((vga_y_s === 7'd20) && (vga_x_s === 8'd80))begin
	$display("[PASS], The coordinates are correct after the 8th cycle");
end else begin
	$error("[FAIL], The coordinates are incorrect after the 8th cycle");
end
#38166;
assert(done_s === 1'b1)begin
	$display("[PASS], The module asserts done when it is finished");
end else begin
	$error("[FAIL], The module does not assert done when it is finished");
end

//No automated test. Verification done via comparing the final s memory to our expected result in memory viewer.
$stop;

end

endmodule: tb_syn_circle
