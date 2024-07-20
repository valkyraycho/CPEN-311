module init (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       en,
    output logic       rdy,
    output logic [7:0] addr,
    output logic [7:0] wrdata,
    output logic       wren
);

    // State machine states
    typedef enum logic [1:0] {
        IDLE,
        WRITE,
        DONE
    } state_t;

    state_t state, next_state;
    logic [7:0] i;

    // State transition logic
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            i     <= 8'b0;
        end
        else begin
            state <= next_state;
            if (state == WRITE) i <= i + 1;
            else i <= 8'b0;
        end
    end

    // State machine
    always_comb begin
        // Default values
        rdy        = 1'b1;
        addr       = 8'b0;
        wrdata     = 8'b0;
        wren       = 0;
        next_state = state;

        case (state)
            IDLE: begin
                if (en) begin
                    next_state = WRITE;
                end
            end
            WRITE: begin
                rdy    = 1'b0;
                addr   = i;
                wrdata = i;
                wren   = 1'b1;

                if (i == 8'd255) begin
                    next_state = DONE;
                end
                else begin
                    next_state = WRITE;
                end
            end
            DONE: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule
