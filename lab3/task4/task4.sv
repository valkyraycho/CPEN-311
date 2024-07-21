module task4 (
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
    logic [7:0] ct_addr, ct_wrdata, ct_rddata;
    logic ct_wren, en_crack, rdy_crack;
    logic [23:0] key;
    logic key_valid;

    typedef enum {
        CRACK,
        WAIT_CRACK,
        DONE
    } state_t;

    state_t state, next_state;

    logic clk;
    assign clk = CLOCK_50;

    logic rst_n;
    assign rst_n = KEY[3];

    always_ff @(posedge clk) begin
        if (!rst_n) state <= CRACK;
        else state <= next_state;
    end

    always_comb begin
        en_crack   = 1'b0;
        next_state = state;
        case (state)
            CRACK: begin
                if (rdy_crack) begin
                    en_crack   = 1'b1;
                    next_state = WAIT_CRACK;
                end
            end
            WAIT_CRACK: if (rdy_crack) next_state = DONE;
            DONE: en_crack = 1'b0;
        endcase
    end


    ct_mem ct (
        .address(ct_addr),
        .clock(clk),
        .data(ct_wrdata),
        .wren(ct_wren),
        .q(ct_rddata)
    );

    crack crk (
        .clk,
        .rst_n,
        .en(en_crack),
        .rdy(rdy_crack),
        .key,
        .key_valid,
        .ct_addr,
        .ct_rddata
    );

endmodule
