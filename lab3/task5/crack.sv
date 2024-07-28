module crack (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        en,
    output logic        rdy,
    output logic [23:0] key,
    output logic        key_valid,
    output logic [ 7:0] ct_addr,
    input  logic [ 7:0] ct_rddata,
    output logic [ 7:0] pt_rddata,
    input  logic [ 7:0] pt_addr_crack,
    input  logic        start,
    input  logic        stop
);

    logic [7:0] pt_addr, pt_addr_arc4;
    logic [7:0] pt_wrdata;
    logic pt_wren;

    logic [7:0] ct_addr_arc4;

    logic en_arc4, rdy_arc4;

    logic [7:0] msg_len;

    logic [7:0] i;

    typedef enum {
        IDLE,
        FETCH_MSG_LEN,
        ARC4,
        WAIT_ARC4,
        FETCH_PT,
        VALIDATE,
        VALIDATE_FIN
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            if (start) key <= 'h000001;
            else key <= 'h000000;
        end
        else begin
            if (stop) state <= IDLE;
            else state <= next_state;
            if (state == WAIT_ARC4 && next_state == FETCH_PT) i <= 8'b1;
            else if (state == VALIDATE && next_state == FETCH_PT) i <= i + 1;
            else if (state == VALIDATE && next_state == ARC4) key <= key + 2;
        end
    end

    always_comb begin
        rdy        = 1'b0;
        key_valid  = 1'b1;
        en_arc4    = 1'b0;
        ct_addr    = 8'b0;
        next_state = state;
        case (state)
            IDLE: begin
                rdy     = 1'b1;
                pt_addr = pt_addr_crack;
                if (en) next_state = FETCH_MSG_LEN;
            end
            FETCH_MSG_LEN: begin
                ct_addr    = 8'b0;
                next_state = ARC4;
            end
            ARC4: begin
                msg_len = ct_rddata;
                if (rdy_arc4) begin
                    en_arc4    = 1'b1;
                    next_state = WAIT_ARC4;
                end
            end
            WAIT_ARC4: begin
                ct_addr = ct_addr_arc4;
                pt_addr = pt_addr_arc4;
                if (rdy_arc4) next_state = FETCH_PT;
            end
            FETCH_PT: begin
                if (i <= msg_len) begin
                    pt_addr    = i;
                    next_state = VALIDATE;
                end
                else next_state = VALIDATE_FIN;
            end
            VALIDATE: begin
                if (pt_rddata < 'h20 || pt_rddata > 'h7e) begin
                    key_valid  = 1'b0;
                    next_state = ARC4;
                end
                else next_state = FETCH_PT;
            end
            VALIDATE_FIN: begin
                if (key_valid) begin
                    rdy        = 1'b1;
                    next_state = IDLE;
                end
                else next_state = ARC4;
            end
        endcase
    end

    pt_mem pt (
        .address(pt_addr),
        .clock(clk),
        .data(pt_wrdata),
        .wren(pt_wren),
        .q(pt_rddata)
    );

    arc4 a4 (
        .clk,
        .rst_n,
        .en(en_arc4),
        .rdy(rdy_arc4),
        .key,
        .ct_addr(ct_addr_arc4),
        .ct_rddata,
        .pt_addr(pt_addr_arc4),
        .pt_rddata,
        .pt_wrdata,
        .pt_wren
    );
endmodule
