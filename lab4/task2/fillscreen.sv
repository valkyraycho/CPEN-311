module fillscreen (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [2:0] colour,
    input  logic       start,
    output logic       done,
    output logic [7:0] vga_x,
    output logic [6:0] vga_y,
    output logic [2:0] vga_colour,
    output logic       vga_plot
);
    logic [7:0] x;
    logic [6:0] y;

    // State machine states
    typedef enum logic [1:0] {
        IDLE,
        COLOR,
        DONE
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            x     <= 8'b0;
            y     <= 7'b0;
        end
        else begin
            state <= next_state;
            if (state == COLOR) begin
                if (next_state == DONE) begin
                    x <= 8'b0;
                    y <= 7'b0;
                end
                else if (y < 7'd119) y <= y + 1;
                else begin
                    y <= 7'b0;
                    x <= x + 1;
                end

            end
        end
    end

    always_comb begin
        done       = 1'b1;
        vga_x      = 8'b0;
        vga_y      = 7'b0;
        vga_colour = 3'b0;
        vga_plot   = 1'b0;
        next_state = state;
        case (state)
            IDLE: if (start) next_state = COLOR;
            COLOR: begin
                done       = 1'b0;
                vga_plot   = 1'b1;
                vga_x      = x;
                vga_y      = y;
                vga_colour = colour == 3'bzzz ? x % 8 : colour;
                if (x == 8'd159 && y == 7'd119) next_state = DONE;
            end
            DONE: begin
                done       = 1'b1;
                next_state = IDLE;
            end
        endcase
    end
endmodule

