module task3(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);

    // instantiate and connect the VGA adapter and your module

        reg start_background;
        reg start_circle;
        reg done_background;
        reg done_circle;
        reg [2:0] circle_colour;
        reg [2:0] background;
        reg [7:0] centre_x;
        reg [6:0] centre_y;
        reg [7:0] radius;
        reg [1:0] state;

        reg [7:0] rVGA_X;
        reg [7:0] VGA_X_circle;
        reg [7:0] VGA_X_background;
        reg [6:0] rVGA_Y;
        reg [6:0] VGA_Y_circle;
        reg [6:0] VGA_Y_background;
        reg [2:0] rVGA_COLOUR;
        reg [2:0] VGA_COLOUR_circle;
        reg [2:0] VGA_COLOUR_background;
        reg rVGA_PLOT;
        reg VGA_PLOT_background;
        reg VGA_PLOT_circle;

        logic [9:0] VGA_R_10;
        logic [9:0] VGA_G_10;
        logic [9:0] VGA_B_10;
        logic VGA_BLANK, VGA_SYNC;

        assign VGA_R = VGA_R_10[9:2];
        assign VGA_G = VGA_G_10[9:2];
        assign VGA_B = VGA_B_10[9:2];

        assign VGA_X = rVGA_X;
        assign VGA_Y = rVGA_Y;
        assign VGA_COLOUR = rVGA_COLOUR;
        assign VGA_PLOT = rVGA_PLOT;

        assign background = 0; //0:Black, 1:Dark blue, 2:Green, 3:Light Blue, 4:Red, 5:Purple, 6:Yelow, 7:White
        assign circle_colour = SW[9:7]; //Set to green from lab instructions
        assign centre_x = 80; //As per lab instructions 80
        assign centre_y = 60; //As per lab instructions 60
        assign radius = SW[6:0]; //As per lab instructions 40


        circle circ(
            .clk(CLOCK_50),.rst_n(KEY[3]),.colour(circle_colour),.centre_x(centre_x),
            .centre_y(centre_y),.radius(radius),.start(start_circle),.done(done_circle),
            .vga_x(VGA_X_circle),.vga_y(VGA_Y_circle),.vga_colour(VGA_COLOUR_circle),.vga_plot(VGA_PLOT_circle)
        );


        vga_adapter#(.RESOLUTION("160x120")) vga_u0(.resetn(KEY[3]), .clock(CLOCK_50), .colour(VGA_COLOUR),
                                            .x(VGA_X), .y(VGA_Y), .plot(VGA_PLOT),
                                            .VGA_R(VGA_R_10), .VGA_G(VGA_G_10), .VGA_B(VGA_B_10),
                                            .*);

        fillscreen_colour fsb(.clk(CLOCK_50),.rst_n(KEY[3]),.colour(background),
                        .start(start_background),.done(done_background),.vga_x(VGA_X_background),.vga_y(VGA_Y_background),
                        .vga_colour(VGA_COLOUR_background),.vga_plot(VGA_PLOT_background)

        ); 

        always_ff @(posedge CLOCK_50) begin

            if(KEY[3] == 0)begin
                start_background <= 1;
                start_circle <= 0;
                state <= 1;
            end

            else if(done_background === 1 && start_background == 1)begin
                start_background <= 0;
                start_circle <= 1;
                state <= 2;
            end

            else if(done_circle == 1 && start_circle == 1)begin
                start_circle <= 0;
                state <= 3;
            end


        end


        always_comb begin

             case (state)
                1: begin
                    rVGA_X = VGA_X_background;
                    rVGA_Y = VGA_Y_background;
                    rVGA_COLOUR = VGA_COLOUR_background;
                    rVGA_PLOT = VGA_PLOT_background;
                end

                2:begin
                    rVGA_X = VGA_X_circle;
                    rVGA_Y = VGA_Y_circle;
                    rVGA_COLOUR = VGA_COLOUR_circle;
                    rVGA_PLOT = VGA_PLOT_circle;
                end

                default: begin
                    rVGA_X = 0;
                    rVGA_Y = 0;
                    rVGA_COLOUR = 0;
                    rVGA_PLOT = 0;
                end
            endcase


        end


endmodule: task3