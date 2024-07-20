module task2 (
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
    logic init_en, init_rdy;
    logic ksa_en, ksa_rdy;

    logic [23:0] key;
    assign key = {14'd0, SW};

    logic [7:0] addr, addr_init, addr_ksa;
    logic [7:0] wrdata, wrdata_init, wrdata_ksa;
    logic [7:0] rddata;
    logic wren, wren_init, wren_ksa;


    logic clk;
    assign clk = CLOCK_50;

    logic rst_n;
    assign rst_n = KEY[3];

    typedef enum {
        INIT,
        WAIT_INIT,
        KSA,
        WAIT_KSA,
        DONE
    } state_t;

    state_t state, next_state;

    always_comb begin
        if (state == INIT || state == WAIT_INIT) begin
            addr   = addr_init;
            wren   = wren_init;
            wrdata = wrdata_init;
        end

        else if (state == KSA || state == WAIT_KSA) begin
            addr   = addr_ksa;
            wren   = wren_ksa;
            wrdata = wrdata_ksa;
        end
    end

    always_comb begin 
        init_en    = 1'b0;
        ksa_en     = 1'b0;
        next_state = state;
        case (state)
            INIT: begin
                if (init_rdy) begin
                    init_en    = 1'b1;
                    next_state = WAIT_INIT;
                end
            end
            WAIT_INIT: if (init_rdy) next_state = KSA;
            KSA: begin
                init_en = 1'b0;
                if (ksa_rdy) begin
                    ksa_en = 1'b1;
                    next_state = WAIT_KSA;
                end
            end
            WAIT_KSA: if (ksa_rdy) next_state = DONE;
            DONE: ksa_en = 1'b0;
        endcase
    end

    init init_inst (
        .clk,
        .rst_n,
        .en(init_en),
        .rdy(init_rdy),
        .addr(addr_init),
        .wrdata(wrdata_init),
        .wren(wren_init)
    );

    ksa ksa_inst (
        .clk,
        .rst_n,
        .en(ksa_en),
        .rdy(ksa_rdy),
        .key,
        .addr(addr_ksa),
        .rddata,
        .wrdata(wrdata_ksa),
        .wren(wren_ksa)
    );

    s_mem s (
        .address(addr),
        .clock(CLOCK_50),
        .data(wrdata),
        .wren(wren),
        .q(rddata)
    );

    always_ff @(posedge clk) begin
        if (!rst_n) state <= INIT;
        else state <= next_state;
    end

endmodule : task2
