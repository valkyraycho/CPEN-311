module fillscreen_colour(input logic clk, input logic rst_n, input logic [2:0] colour,
                  input logic start, output logic done,
                  output logic [7:0] vga_x, output logic [6:0] vga_y,
                  output logic [2:0] vga_colour, output logic vga_plot);
     
	 reg [3:0] state;
	 reg [7:0] x;
	 reg [6:0] y;
	 reg plot;
	 
	 wire [7:0] x_wire;
	 wire [6:0] y_wire;
	 
	 assign x_wire = x;
	 assign y_wire = y;
	 assign vga_x = x_wire;
	 assign vga_y = y_wire;
	 assign vga_plot = plot;
	 
	 always_ff @(posedge clk) begin
			if(rst_n == 1'b0) begin
				x <= 8'd0;
				y <= 7'd0;
				state <= 4'd0;
			end
			
			if(x == 8'd160) begin //X is at 160 so we done here
				state <= 4'd3;
			end
			
			else if ((state == 4'd0)&&(start == 1'b1)) begin //||STATE 0||
				state <= 4'd1;
			end
			
			else if ((state == 4'd1)&&(y == 7'd119)&&(start == 1'b1)) begin //Y at max so reset it and jump to X increment 
				y <= 7'd0;
				x <= x + 8'd1;
			end
			
			else if ((state == 4'd1)&&(y != 7'd119)&&(start == 1'b1))begin 
				y <= y + 7'd1; 
			end
			
			else begin 
				state <= 4'd0; 
			end
	 end
	 
	 always_comb begin	 
		if(start == 1'b1 && ((state == 4'd0)||(state == 4'd1))) begin
			vga_colour = colour; 
			plot = 1'b1;
			done = 1'b0; 
		end	
		else if (state == 4'd3) begin
			plot = 1'b0;
			done = 1'b1;
			vga_colour = 3'd0;
		end
		else begin
			plot = 1'b0;
			vga_colour = 3'd0;
			done = 1'b0;
		end
	 end
	 
endmodule
