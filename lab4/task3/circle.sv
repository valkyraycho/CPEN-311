module circle (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [2:0] colour,
    input  logic [7:0] centre_x,
    input  logic [6:0] centre_y,
    input  logic [7:0] radius,
    input  logic       start,
    output logic       done,
    output logic [7:0] vga_x,
    output logic [6:0] vga_y,
    output logic [2:0] vga_colour,
    output logic       vga_plot
);
    logic [7:0] offset_x, offset_y;
    logic signed [7:0] crit;

    typedef enum {
        IDLE,
        OCT1,
        OCT2,
        OCT3,
        OCT4,
        OCT5,
        OCT6,
        OCT7,
        OCT8,
        DONE
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state    <= IDLE;
            offset_x <= radius;
            offset_y <= 8'b0;
            crit     <= 8'b1 - radius;
        end
        else begin
            state <= next_state;
            if (state == OCT7) begin
                offset_y <= offset_y + 1;
                if (crit <= 8'b0) crit <= crit + 2 * offset_y + 1;
                else begin
                    offset_x <= offset_x - 1;
                    crit     <= crit + 2 * (offset_y - offset_x) + 1;
                end
            end
        end
    end

    // function automatic void update_vga(input logic signed [7:0] x_offset, input logic signed [6:0] y_offset);
    //     vga_x      = centre_x + x_offset;
    //     vga_y      = centre_y + y_offset;
    //     vga_colour = colour;
    //     if (vga_x >= 0 && vga_x <= 159 && vga_y >= 0 && vga_y <= 119) begin
    //         vga_plot = 1;
    //     end
    // endfunction


    always_comb begin
        done       = 1'b0;
        vga_x      = 8'b0;
        vga_y      = 7'b0;
        vga_colour = 3'b0;
        vga_plot   = 1'b0;
        next_state = state;
        case (state)
            IDLE: if (start) next_state = OCT1;
            OCT1: begin
                vga_x      = centre_x + offset_x;
                vga_y      = centre_y + offset_y;
                vga_colour = colour;
                if (vga_x >= 0 && vga_x <= 159 && vga_y >= 0 && vga_y <= 119) vga_plot = 1;
                next_state = OCT2;
            end
            OCT2: begin
                vga_x      = centre_x + offset_y;
                vga_y      = centre_y + offset_x;
                vga_colour = colour;
                if (vga_x >= 0 && vga_x <= 159 && vga_y >= 0 && vga_y <= 119) vga_plot = 1;
                next_state = OCT4;
            end
            OCT4: begin
                vga_x      = centre_x - offset_x;
                vga_y      = centre_y + offset_y;
                vga_colour = colour;
                if (vga_x >= 0 && vga_x <= 159 && vga_y >= 0 && vga_y <= 119) vga_plot = 1;
                next_state = OCT3;
            end
            OCT3: begin
                vga_x      = centre_x - offset_y;
                vga_y      = centre_y + offset_x;
                vga_colour = colour;
                if (vga_x >= 0 && vga_x <= 159 && vga_y >= 0 && vga_y <= 119) vga_plot = 1;
                next_state = OCT5;
            end
            OCT5: begin
                vga_x      = centre_x - offset_x;
                vga_y      = centre_y - offset_y;
                vga_colour = colour;
                if (vga_x >= 0 && vga_x <= 159 && vga_y >= 0 && vga_y <= 119) vga_plot = 1;
                next_state = OCT6;
            end
            OCT6: begin
                vga_x      = centre_x - offset_y;
                vga_y      = centre_y - offset_x;
                vga_colour = colour;
                if (vga_x >= 0 && vga_x <= 159 && vga_y >= 0 && vga_y <= 119) vga_plot = 1;
                next_state = OCT8;
            end
            OCT8: begin
                vga_x      = centre_x + offset_x;
                vga_y      = centre_y - offset_y;
                vga_colour = colour;
                if (vga_x >= 0 && vga_x <= 159 && vga_y >= 0 && vga_y <= 119) vga_plot = 1;
                next_state = OCT7;
            end
            OCT7: begin
                vga_x      = centre_x + offset_y;
                vga_y      = centre_y - offset_x;
                vga_colour = colour;
                if (vga_x >= 0 && vga_x <= 159 && vga_y >= 0 && vga_y <= 119) vga_plot = 1;
                if (offset_y <= offset_x) next_state = OCT1;
                else next_state = DONE;
            end
            DONE: begin
                done       = 1'b1;
                next_state = IDLE;
            end
        endcase
    end

endmodule

