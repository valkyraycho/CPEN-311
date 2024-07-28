module task3 (
    input  logic       CLOCK_50,
    input  logic [3:0] KEY,
    input  logic [9:0] SW,
    output logic [9:0] LEDR,
    output logic [6:0] HEX0,
    output logic [6:0] HEX1,
    output logic [6:0] HEX2,
    output logic [6:0] HEX3,
    output logic [6:0] HEX4,
    output logic [6:0] HEX5,
    output logic [7:0] VGA_R,
    output logic [7:0] VGA_G,
    output logic [7:0] VGA_B,
    output logic       VGA_HS,
    output logic       VGA_VS,
    output logic       VGA_CLK,
    output logic [7:0] VGA_X,
    output logic [6:0] VGA_Y,
    output logic [2:0] VGA_COLOUR,
    output logic       VGA_PLOT
);

    // instantiate and connect the VGA adapter and your module

    logic start_fillscreen, start_circle;
    logic done_fillscreen, done_circle;

    logic [7:0] FS_VGA_X, CIRC_VGA_X;
    logic [6:0] FS_VGA_Y, CIRC_VGA_Y;
    logic [2:0] FS_VGA_COLOUR, CIRC_VGA_COLOUR;
    logic FS_VGA_PLOT, CIRC_VGA_PLOT;

    logic [9:0] VGA_R_10;
    logic [9:0] VGA_G_10;
    logic [9:0] VGA_B_10;
    logic VGA_BLANK, VGA_SYNC;

    assign VGA_R = VGA_R_10[9:2];
    assign VGA_G = VGA_G_10[9:2];
    assign VGA_B = VGA_B_10[9:2];

    typedef enum {
        FILLSCREEN,
        WAIT_FILLSCREEN,
        CIRCLE,
        WAIT_CIRCLE,
        DONE
    } state_t;

    state_t state, next_state;

    fillscreen fs (
        .clk(CLOCK_50),
        .rst_n(KEY[3]),
        .colour(3'b000),
        .start(start_fillscreen),
        .done(done_fillscreen),
        .vga_x(FS_VGA_X),
        .vga_y(FS_VGA_Y),
        .vga_colour(FS_VGA_COLOUR),
        .vga_plot(FS_VGA_PLOT)
    );


    circle circ (
        .clk(CLOCK_50),
        .rst_n(KEY[3]),
        .colour(3'b010),
        .centre_x(8'd80),
        .centre_y(7'd60),
        .radius(8'd40),
        .start(start_circle),
        .done(done_circle),
        .vga_x(CIRC_VGA_X),
        .vga_y(CIRC_VGA_Y),
        .vga_colour(CIRC_VGA_COLOUR),
        .vga_plot(CIRC_VGA_PLOT)
    );


    vga_adapter #(
        .RESOLUTION("160x120")
    ) vga_u0 (
        .resetn(KEY[3]),
        .clock(CLOCK_50),
        .colour(VGA_COLOUR),
        .x(VGA_X),
        .y(VGA_Y),
        .plot(VGA_PLOT),
        .VGA_R(VGA_R_10),
        .VGA_G(VGA_G_10),
        .VGA_B(VGA_B_10),
        .*
    );

    always_ff @(posedge CLOCK_50) begin
        if (!KEY[3]) begin
            state <= FILLSCREEN;
        end
        else begin
            state <= next_state;
        end
    end

    always_comb begin
        start_fillscreen = 1'b0;
        start_circle     = 1'b0;
        next_state       = state;
        case (state)
            FILLSCREEN: begin
                start_fillscreen = 1'b1;
                next_state       = WAIT_FILLSCREEN;
            end
            WAIT_FILLSCREEN: if (done_fillscreen) next_state = CIRCLE;
            CIRCLE: begin
                start_circle = 1'b1;
                next_state   = WAIT_CIRCLE;
            end
            WAIT_CIRCLE: if (done_circle) next_state = DONE;
        endcase
    end

endmodule : task3
