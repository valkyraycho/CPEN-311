module task1 (
    input  logic       CLOCK_50,
    input  logic [3:0] KEY,
    input  logic [9:0] SW,
    output logic [6:0] HEX0,
    output logic [6:0] HEX1,
    output logic [6:0] HEX2,
    output logic [6:0] HEX3,
    output logic [6:0] HEX4,
    output logic [6:0] HEX5,
    output logic [9:0] LEDR
);

    logic en, rdy, wren;
    logic [7:0] wrdata, addr, rdata;

    logic rst_n;
    assign rst_n = KEY[3];

    logic clk;
    assign clk = CLOCK_50;


    init initmodule (
        .clk,
        .rst_n,
        .en,
        .rdy,
        .addr,
        .wrdata,
        .wren
    );

    s_mem s (
        .address(addr),
        .clock(CLOCK_50),
        .data(wrdata),
        .wren(wren),
        .q(rdata)
    );

    typedef enum {
        INIT,
        WAIT_INIT,
        DONE
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!rst_n) state <= INIT;
        else state <= next_state;
    end

    always_comb begin
        en         = 1'b0;
        next_state = state;
        case (state)
            INIT: begin
                if (rdy) begin
                    en         = 1'b1;
                    next_state = WAIT_INIT;
                end
            end
            WAIT_INIT: if (rdy) next_state = DONE;
            DONE: en = 1'b0;
        endcase
    end


    // your code here

endmodule : task1
