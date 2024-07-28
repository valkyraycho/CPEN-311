module task5 (
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
    logic ct_wren, en_doublecrack, rdy_doublecrack;
    logic [23:0] key;
    logic key_valid;

    typedef enum {
        DOUBLE_CRACK,
        WAIT_DOUBLE_CRACK,
        DONE
    } state_t;

    state_t state, next_state;

    logic clk;
    assign clk = CLOCK_50;

    logic rst_n;
    assign rst_n = KEY[3];

    always_ff @(posedge clk) begin
        if (!rst_n) state <= DOUBLE_CRACK;
        else state <= next_state;
    end

    always_comb begin
        en_doublecrack = 1'b0;
        next_state     = state;
        case (state)
            DOUBLE_CRACK: begin
                if (rdy_doublecrack) begin
                    en_doublecrack = 1'b1;
                    next_state     = WAIT_DOUBLE_CRACK;
                end
            end
            WAIT_DOUBLE_CRACK: if (rdy_doublecrack) next_state = DONE;
            DONE: en_doublecrack = 1'b0;
        endcase
    end


    ct_mem ct (
        .address(ct_addr),
        .clock(clk),
        .data(ct_wrdata),
        .wren(ct_wren),
        .q(ct_rddata)
    );

    doublecrack doublecrack (
        .clk,
        .rst_n,
        .en(en_doublecrack),
        .rdy(rdy_doublecrack),
        .key,
        .key_valid,
        .ct_addr,
        .ct_rddata
    );

endmodule
