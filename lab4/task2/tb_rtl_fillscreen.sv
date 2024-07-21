`timescale 1ps / 1ps
module tb_rtl_fillscreen();

reg rst_n_s, start_s, done_s, vga_plot_s;
reg clk_s = 1'b0;
reg[2:0] colour_s, vga_colour_s;
reg[7:0] vga_x_s, xcoord;
reg[6:0] vga_y_s, ycoord;

reg [17:0] clkticks = 18'd0;


fillscreen DUT(.clk(clk_s), .rst_n(rst_n_s), .colour(colour_s),
                  .start(start_s), .done(done_s),
                  .vga_x(vga_x_s),.vga_y(vga_y_s),
                  .vga_colour(vga_colour_s), .vga_plot(vga_plot_s));
				  
initial begin
	forever begin
		clk_s = ~clk_s;
		#1;
	end
end

initial begin //Success case
rst_n_s = 1'b0;
#1;
rst_n_s = 1'b1;
#1;
start_s = 1'b1;
#3;
assert((vga_colour_s === 3'd0) && (vga_y_s === 7'd1) && (vga_x_s === 8'd0))begin
	$display("[PASS], The colour and coordinates are correct after the 1st cycle");
end else begin
	$error("[FAIL], The colour and coordinates are incorrect after the 1st cycle");
end
#2;
assert((vga_colour_s === 3'd0) && (vga_y_s === 7'd2) && (vga_x_s === 8'd0))begin
	$display("[PASS], The colour and coordinates are correct after the 2nd cycle");
end else begin
	$error("[FAIL], The colour and coordinates are incorrect after the 2nd cycle");
end
#2;
assert((vga_colour_s === 3'd0) && (vga_y_s === 7'd3) && (vga_x_s === 8'd0))begin
	$display("[PASS], The colour and coordinates are correct after the 3rd cycle");
end else begin
	$error("[FAIL], The colour and coordinates are incorrect after the 3rd cycle");
end
#2;
assert((vga_colour_s === 3'd0) && (vga_y_s === 7'd4) && (vga_x_s === 8'd0))begin
	$display("[PASS], The colour and coordinates are correct after the 4th cycle");
end else begin
	$error("[FAIL], The colour and coordinates are incorrect after the 4th cycle");
end
#2;
assert((vga_colour_s === 3'd0) && (vga_y_s === 7'd5) && (vga_x_s === 8'd0))begin
	$display("[PASS], The colour and coordinates are correct after the 5th cycle");
end else begin
	$error("[FAIL], The colour and coordinates are incorrect after the 5th cycle");
end
#2;
assert((vga_colour_s === 3'd0) && (vga_y_s === 7'd6) && (vga_x_s === 8'd0))begin
	$display("[PASS], The colour and coordinates are correct after the 6th cycle");
end else begin
	$error("[FAIL], The colour and coordinates are incorrect after the 6th cycle");
end
#2;
assert((vga_colour_s === 3'd0) && (vga_y_s === 7'd7) && (vga_x_s === 8'd0))begin
	$display("[PASS], The colour and coordinates are correct after the 7th cycle");
end else begin
	$error("[FAIL], The colour and coordinates are incorrect after the 7th cycle");
end
#500;
assert((vga_colour_s === 3'd2) && (vga_y_s === 7'd17) && (vga_x_s === 8'd2))begin
	$display("[PASS], The colour and coordinates are correct after the 258th cycle");
end else begin
	$error("[FAIL], The colour and coordinates are incorrect after the 258th cycle");
end
#2;
assert((vga_colour_s === 3'd2) && (vga_y_s === 7'd18) && (vga_x_s === 8'd2))begin
	$display("[PASS], The colour and coordinates are correct after the 259th cycle");
end else begin
	$error("[FAIL], The colour and coordinates are incorrect after the 259th cycle");
end
#2;
assert((vga_colour_s === 3'd2) && (vga_y_s === 7'd19) && (vga_x_s === 8'd2))begin
	$display("[PASS], The colour and coordinates are correct after the 260th cycle");
end else begin
	$error("[FAIL], The colour and coordinates are incorrect after the 260th cycle");
end
#2;
assert((vga_colour_s === 3'd2) && (vga_y_s === 7'd20) && (vga_x_s === 8'd2))begin
	$display("[PASS], The colour and coordinates are correct after the 261th cycle");
end else begin
	$error("[FAIL], The colour and coordinates are incorrect after the 261th cycle");
end
#2;
assert((vga_colour_s === 3'd2) && (vga_y_s === 7'd21) && (vga_x_s === 8'd2))begin
	$display("[PASS], The colour and coordinates are correct after the 262th cycle");
end else begin
	$error("[FAIL], The colour and coordinates are incorrect after the 262th cycle");
end
#38166;
assert((done_s === 1'd1))begin
	$display("[PASS], Done is asserted after module finishes");
end else begin
	$error("[FAIL], Done is not asserted after module finishes");
end
//No automated test. Verification done via comparing the final s memory to our expected result in memory viewer.
$stop;

end

endmodule: tb_rtl_fillscreen
