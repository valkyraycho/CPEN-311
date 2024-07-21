module arc4 (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        en,
    output logic        rdy,
    input  logic [23:0] key,
    output logic [ 7:0] ct_addr,
    input  logic [ 7:0] ct_rddata,
    output logic [ 7:0] pt_addr,
    input  logic [ 7:0] pt_rddata,
    output logic [ 7:0] pt_wrdata,
    output logic        pt_wren
);
    logic en_init, rdy_init;
    logic en_ksa, rdy_ksa;
    logic en_prga, rdy_prga;

    logic [7:0] s_addr, s_addr_init, s_addr_ksa, s_addr_prga;
    logic [7:0] s_wrdata, s_wrdata_init, s_wrdata_ksa, s_wrdata_prga;
    logic [7:0] s_rddata;
    logic s_wren, s_wren_init, s_wren_ksa, s_wren_prga;

    typedef enum {
        IDLE,
        INIT,
        WAIT_INIT,
        KSA,
        WAIT_KSA,
        PRGA,
        WAIT_PRGA,
        DONE
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!rst_n) state <= IDLE;
        else state <= next_state;
    end

    always_comb begin
        if (state == INIT || state == WAIT_INIT) begin
            s_addr   = s_addr_init;
            s_wren   = s_wren_init;
            s_wrdata = s_wrdata_init;
        end

        else if (state == KSA || state == WAIT_KSA) begin
            s_addr   = s_addr_ksa;
            s_wren   = s_wren_ksa;
            s_wrdata = s_wrdata_ksa;
        end

        else if (state == PRGA || state == WAIT_PRGA) begin
            s_addr   = s_addr_prga;
            s_wren   = s_wren_prga;
            s_wrdata = s_wrdata_prga;
        end
    end

    always_comb begin
        en_init    = 1'b0;
        en_ksa     = 1'b0;
        en_prga    = 1'b0;
        next_state = state;
        rdy        = 1'b0;
        case (state)
            IDLE: begin
                rdy = 1'b1;
                if (en) next_state = INIT;
            end
            INIT: begin
                if (rdy_init) begin
                    en_init    = 1'b1;
                    next_state = WAIT_INIT;
                end
            end
            WAIT_INIT: if (rdy_init) next_state = KSA;
            KSA: begin
                en_init = 1'b0;
                if (rdy_ksa) begin
                    en_ksa     = 1'b1;
                    next_state = WAIT_KSA;
                end
            end
            WAIT_KSA:  if (rdy_ksa) next_state = PRGA;
            PRGA: begin
                en_ksa = 1'b0;
                if (rdy_prga) begin
                    en_prga    = 1'b1;
                    next_state = WAIT_PRGA;
                end
            end
            WAIT_PRGA: if (rdy_prga) next_state = DONE;
            DONE: begin
                rdy        = 1'b1;
                next_state = IDLE;
            end
        endcase
    end

    init init_inst (
        .clk,
        .rst_n,
        .en(en_init),
        .rdy(rdy_init),
        .addr(s_addr_init),
        .wrdata(s_wrdata_init),
        .wren(s_wren_init)
    );

    ksa ksa_inst (
        .clk,
        .rst_n,
        .en(en_ksa),
        .rdy(rdy_ksa),
        .key,
        .addr(s_addr_ksa),
        .rddata(s_rddata),
        .wrdata(s_wrdata_ksa),
        .wren(s_wren_ksa)

    );

    prga prga_inst (
        .clk,
        .rst_n,
        .en(en_prga),
        .rdy(rdy_prga),
        .key,
        .s_addr(s_addr_prga),
        .s_rddata(s_rddata),
        .s_wrdata(s_wrdata_prga),
        .s_wren(s_wren_prga),
        .ct_addr,
        .ct_rddata,
        .pt_addr,
        .pt_rddata,
        .pt_wrdata,
        .pt_wren
    );

    s_mem s (
        .address(s_addr),
        .clock(clk),
        .data(s_wrdata),
        .wren(s_wren),
        .q(s_rddata)
    );

endmodule : arc4
