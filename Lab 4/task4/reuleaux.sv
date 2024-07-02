module reuleaux(input logic clk, input logic rst_n, input logic [2:0] colour,
                input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] diameter,
                input logic start, output logic done,
                output logic [7:0] vga_x, output logic [6:0] vga_y,
                output logic [2:0] vga_colour, output logic vga_plot);
     // draw the Reuleaux triangle

     reg [2:0] state; //Max 8 states
     reg padding;
     reg [13:0] rounding;

     reg [7:0] radius_circ;
     reg [7:0] radius_tri;

     reg [2:0] top_colour;
     reg [2:0] left_colour;
     reg [2:0] right_colour;

     reg [7:0] top_centre_x;
     reg [7:0] left_centre_x;
     reg [7:0] right_centre_x;

     reg [7:0] top_centre_y;
     reg [7:0] left_centre_y;
     reg [7:0] right_centre_y;

     reg top_start;
     reg left_start;
     reg right_start;

     reg top_done;
     reg left_done;
     reg right_done;
     reg rdone;

     reg [7:0] top_vga_x;
     reg [7:0] left_vga_x;
     reg [7:0] right_vga_x;
     reg [7:0] rvga_x;

     reg [6:0] top_vga_y;
     reg [6:0] left_vga_y;
     reg [6:0] right_vga_y;
     reg [6:0] rvga_y;

     reg [2:0] top_vga_colour;
     reg [2:0] left_vga_colour;
     reg [2:0] right_vga_colour;
     reg [2:0] rvga_colour;

     reg top_vga_plot;
     reg left_vga_plot;
     reg right_vga_plot;
     reg rvga_plot;

     assign done = rdone;
     assign vga_x = rvga_x;
     assign vga_y = rvga_y;
     assign vga_colour = rvga_colour;
     assign vga_plot = rvga_plot;

   //  assign top_centre_x = centre_x;
    // assign left_centre_x = centre_x - (diameter / 2); 
    // assign right_centre_x = centre_x + (diameter / 2);

    // assign top_centre_y = centre_y + (diameter / 2);
     //assign left_centre_y = centre_y - (diameter / 2);
    // assign right_centre_y = centre_y - (diameter / 2);

     assign top_colour = 4;
     assign left_colour = 2;
     assign right_colour = 1;
     assign radius_circ = diameter >> 1; //radius of reuleaux triangle
     assign radius_tri = ((radius_circ << 1) * 57735) / 100000;
     assign rounding = ((radius_circ << 1) * 5773) % 10000;

     circle topcircle(
          .clk(clk),.rst_n(rst_n),.colour(colour),.centre_x(top_centre_x),.centre_y(top_centre_y),
          .radius(radius_circ << 1),.start(top_start),.done(top_done),.vga_x(top_vga_x),.vga_y(top_vga_y),
          .vga_colour(top_vga_colour),.vga_plot(top_vga_plot)
     );

      circle leftcircle(
          .clk(clk),.rst_n(rst_n),.colour(colour),.centre_x(left_centre_x),.centre_y(left_centre_y),
          .radius(radius_circ << 1),.start(left_start),.done(left_done),.vga_x(left_vga_x),.vga_y(left_vga_y),
          .vga_colour(left_vga_colour),.vga_plot(left_vga_plot)
     );

      circle rightcircle(
          .clk(clk),.rst_n(rst_n),.colour(colour),.centre_x(right_centre_x),.centre_y(right_centre_y),
          .radius(radius_circ << 1),.start(right_start),.done(right_done),.vga_x(right_vga_x),.vga_y(right_vga_y),
          .vga_colour(right_vga_colour),.vga_plot(right_vga_plot)
     );

      always_ff @(posedge clk) begin

            if(rst_n == 0)begin
                top_start <= 0;
                left_start <= 0;
                right_start <= 0;
                rdone <= 0;
                state <= 0;
               top_centre_x <= centre_x; 
               left_centre_x <= centre_x - (866 * radius_tri) / 1000; //sqrt(3)/2 * r
               right_centre_x <= centre_x + (866 * radius_tri) / 1000; //sqrt(3)/2 * r
               top_centre_y <= ((centre_y - radius_tri) * 2) / 2; 
               left_centre_y <= centre_y + radius_tri / 2; 
               right_centre_y <= centre_y + radius_tri / 2; 
               if(rounding >= 5000) begin 
                    padding <= 1;
               end
               else begin
                    padding <= 0;
               end
            end
            if(start == 1 && done == 0) begin
               if(top_start == 0 && left_start == 0 && right_start == 0)begin //Plot the top state=1
                    top_start <= 1;
                    state <= 1;
               end

               else if(top_done == 1 && left_start == 0 && right_start == 0)begin //Plot the left state=2
                    top_start <= 0;
                    left_start <= 1;
                    state <= 2;
               end

               else if(left_done == 1 && top_start == 0 && right_start == 0)begin //Plot the right state=3
                    left_start <= 0;
                    right_start <= 1;
                    state <= 3;
               end
               else if(left_done == 1 && top_done == 1 && right_done == 1)begin //Plot the right state=3
                    left_start <= 0;
                    right_start <= 0;
                    top_start <= 0;
                    rdone <= 1;
                    state <= 4;
               end

            end
        end

     always_comb begin
               case (state)
                1: begin
                    rvga_x = top_vga_x;
                    rvga_y = top_vga_y;
                    rvga_colour = top_vga_colour;
                    if((rvga_x <= right_centre_x + 2) && (rvga_x >= left_centre_x - 2) && (rvga_y >= top_centre_y))begin
                         rvga_plot = top_vga_plot;
                    end
                    else begin
                         rvga_plot = 0;
                    end
                end

                2:begin
                    rvga_x = left_vga_x;
                    rvga_y = left_vga_y;
                    rvga_colour = left_vga_colour;
                    if((rvga_x <= right_centre_x + 2) && (rvga_x >= left_centre_x - 2) && (rvga_y <= left_centre_y) && (rvga_y >= top_centre_y - (1+padding)))begin
                         rvga_plot = left_vga_plot;
                    end
                    else begin
                         rvga_plot = 0;
                    end
                end

               3:begin
                    rvga_x = right_vga_x;
                    rvga_y = right_vga_y;
                    rvga_colour = right_vga_colour;
                    if((rvga_x <= right_centre_x + 2) && (rvga_x >= left_centre_x - 2) && (rvga_y <= left_centre_y) && (rvga_y >= top_centre_y - (1+ padding)))begin
                         rvga_plot = right_vga_plot;
                    end
                    else begin
                         rvga_plot = 0;
                    end
                end
                default: begin
                    rvga_x = 0;
                    rvga_y = 0;
                    rvga_colour = 0;
                    rvga_plot = 0;
                end
            endcase

     end


endmodule

