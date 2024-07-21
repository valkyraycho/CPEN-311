module circle(input logic clk, input logic rst_n, input logic [2:0] colour,
              input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] radius,
              input logic start, output logic done,
              output logic [7:0] vga_x, output logic [6:0] vga_y,
              output logic [2:0] vga_colour, output logic vga_plot);
     // draw the circle
     reg [7:0] offset_x;
     reg [7:0] offset_y;
     reg [7:0] new_offset_x;
     reg [7:0] new_offset_y;
     reg [3:0] state;
     reg signed [10:0] crit;
     reg [9:0] rvga_x;
     reg [9:0] rvga_y;
     reg [2:0] rvga_colour;
     reg rvga_plot;
     reg [8:0] pixel; //TODO: REMOVE
     reg flag;

     assign vga_x = rvga_x[7:0];
     assign vga_y = rvga_y[6:0];
     assign vga_plot = rvga_plot;
     assign vga_colour = rvga_colour;

     

always_ff @(posedge clk)begin
     if(rst_n == 0)begin
          state <= 0;
          offset_y <= 0;
          offset_x <= radius; 
          crit <= 1 - radius;
          done <= 0;
          pixel <= 0; //TODO: REMOVE
     end

     else if(start == 1 && done == 0)begin

          case (state)
               0:begin //Check offset_y is less than or equal to offset_x
                    if(offset_y <= offset_x)begin
                         state <= 1;
                    end 

                    else begin

                         state <= 0;
                    end

               end 
               1:begin
                    pixel <= pixel+8; //TODO: Debugging, maybe keep to show 
                    state <= 2;
               end
               2:begin
                    state <= 3;
               end

               3:begin
                    state <= 4;
               end

               4:begin
                    state <= 5;
               end

               5:begin
                    state <= 6;
               end
               6:begin
                    state <= 7;
                    new_offset_y <= offset_y + 1;
                    
               end

               7:begin
                    state <= 8;
                    if(crit <= 0)begin 
                         crit <= crit + (2 * new_offset_y) + 1;
                         new_offset_x <= offset_x;
                         flag <= 1;
                    end
                    else begin
                         new_offset_x <= offset_x - 1;
                         flag <= 0;
                         
                    end
               end
               8:begin
                    if(flag == 0) begin
                         crit <= crit + 2 * (new_offset_y - new_offset_x) + 1;
                    end
                    if(new_offset_y <= new_offset_x)begin
                         state <= 1;
                         offset_y <= new_offset_y;
                         offset_x <= new_offset_x;
                    end
                    else begin
                         done <= 1;
                         state <= 0;
                    end
               end
               
               default: begin
                    state <= 0;
               end
          endcase

     end 

end     


always_comb begin
     case (state)
          1: begin
               rvga_colour = colour;
       
               rvga_x = centre_x + offset_x;
               rvga_y = centre_y + offset_y;
          end 
          2: begin
               rvga_colour = colour;

               rvga_x = centre_x + offset_y;
               rvga_y = centre_y + offset_x;
          end 
          3: begin
               rvga_colour = colour;
               rvga_x = centre_x - offset_x;
               rvga_y = centre_y + offset_y;
          end 
          4: begin
               rvga_colour = colour;
               rvga_x = centre_x - offset_y;
               rvga_y = centre_y + offset_x;
          end 
          5: begin
               rvga_colour = colour;
               rvga_x = centre_x - offset_x;
               rvga_y = centre_y - offset_y;
          end 
          6: begin
               rvga_colour = colour;
               rvga_x = centre_x - offset_y;
               rvga_y = centre_y - offset_x;
          end 
          7: begin
               rvga_colour = colour;
               rvga_x = centre_x + offset_x;
               rvga_y = centre_y - offset_y;
          end 
          8: begin
               rvga_colour = colour;
               rvga_x = centre_x + offset_y;
               rvga_y = centre_y - offset_x;
          end 
          default: begin
          rvga_colour = 0;
          rvga_x = 0;
          rvga_y = 0;

          end

     endcase

          if((state > 0) && (state <= 8)) begin //Handles plotting outside of the screen
               if((rvga_x <= 159) && (rvga_x >= 0) && (rvga_y <= 119) && (rvga_y >= 0)) begin 
                    rvga_plot = 1;
               end
               else begin
                    rvga_plot = 0;
               end       
          end 
          else begin
               rvga_plot = 0;
          end

end
     



    
endmodule

