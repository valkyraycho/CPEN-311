module doublecrack (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        en,
    output logic        rdy,
    output logic [23:0] key,
    output logic        key_valid,
    output logic [ 7:0] ct_addr,
    input  logic [ 7:0] ct_rddata
);
    logic en_crack, en_arc4;
    logic rdy_crack, rdy_crack_0, rdy_crack_1, rdy_arc4;

    logic [7:0] pt_addr, pt_wrdata, pt_rddata, pt_rddata_crack_0, pt_rddata_crack_1, pt_addr_crack_0, pt_addr_crack_1;
    logic pt_wren;

    logic [7:0] ct2_addr, ct2_wrdata, ct2_rddata;
    logic ct2_wren;

    logic [7:0] ct_addr_crack_0, ct_addr_crack_1;

    logic [23:0] key_0, key_1;
    logic [7:0] msg_len;
    logic [7:0] i;

    logic stop;

    typedef enum {
        IDLE,
        FETCH_MSG_LEN,
        STORE_MSG_LEN,
        COPY_CT,
        FETCH_CT,
        CRACK,
        WAIT_CRACK,
        FETCH_PT_FROM_CRACK,
        COPY_PT,
        DONE
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state   <= IDLE;
            key     <= 24'b0;
            i       <= 8'b0;
            msg_len <= 8'b0;
            stop    <= 1'b0;
        end
        else begin
            state <= next_state;
            if (state == STORE_MSG_LEN) msg_len <= ct_rddata;
            else if (state == COPY_CT && next_state == FETCH_CT) i <= i + 1;
            else if (state == WAIT_CRACK && next_state == FETCH_PT_FROM_CRACK) begin
                stop <= 1'b1;
                if (rdy_crack) key <= key_1;
                else key <= key_0;
            end
            else if (state == COPY_PT && next_state == FETCH_PT_FROM_CRACK) i <= i - 1;
        end
    end

    always_comb begin
        rdy        = 1'b0;
        key_valid  = 1'b1;
        ct2_wren   = 1'b0;
        en_crack   = 1'b0;
        next_state = state;
        case (state)
            IDLE: begin
                rdy = 1'b1;
                if (en) next_state = FETCH_MSG_LEN;
            end
            FETCH_MSG_LEN: begin
                ct_addr    = 8'b0;
                next_state = STORE_MSG_LEN;
            end
            STORE_MSG_LEN: next_state = COPY_CT;
            COPY_CT: begin
                ct2_addr   = i;
                ct2_wrdata = ct_rddata;
                ct2_wren   = 1'b1;
                if (i < msg_len) next_state = FETCH_CT;
                else next_state = CRACK;
            end
            FETCH_CT: begin
                ct_addr    = i;
                next_state = COPY_CT;
            end
            CRACK: begin
                ct_addr  = ct_addr_crack_0;
                ct2_addr = ct_addr_crack_1;
                if (rdy_crack_0 && rdy_crack_1) begin
                    en_crack   = 1'b1;
                    next_state = WAIT_CRACK;
                end
            end
            WAIT_CRACK: begin
                ct_addr  = ct_addr_crack_0;
                ct2_addr = ct_addr_crack_1;
                if (rdy_crack_0 || rdy_crack_1) begin
                    rdy_crack  = rdy_crack_1 ? 1'b1 : 1'b0;
                    next_state = FETCH_PT_FROM_CRACK;
                end
                else key_valid = 1'b0;
            end
            FETCH_PT_FROM_CRACK: begin
                if (rdy_crack) pt_addr_crack_1 = i;
                else pt_addr_crack_0 = i;
                next_state = COPY_PT;
            end
            COPY_PT: begin
                pt_addr = i;
                if (rdy_crack) pt_wrdata = pt_rddata_crack_1;
                else pt_wrdata = pt_rddata_crack_0;
                pt_wren = 1'b1;
                if (i > 0) next_state = FETCH_PT_FROM_CRACK;
                else next_state = DONE;
            end
            DONE: begin
                rdy        = 1'b1;
                next_state = IDLE;
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

    ct_mem ct2 (
        .address(ct2_addr),
        .clock(clk),
        .data(ct2_wrdata),
        .wren(ct2_wren),
        .q(ct2_rddata)
    );

    crack crack_from_1 (
        .clk,
        .rst_n,
        .en(en_crack),
        .rdy(rdy_crack_1),
        .key(key_1),
        .key_valid(key_valid_1),
        .ct_addr(ct_addr_crack_1),
        .ct_rddata(ct2_rddata),
        .pt_rddata(pt_rddata_crack_1),
        .pt_addr_crack(pt_addr_crack_1),
        .start(1'b1),
        .stop
    );

    crack crack_from_0 (
        .clk,
        .rst_n,
        .en(en_crack),
        .rdy(rdy_crack_0),
        .key(key_0),
        .key_valid(key_valid_0),
        .ct_addr(ct_addr_crack_0),
        .ct_rddata(ct_rddata),
        .pt_rddata(pt_rddata_crack_0),
        .pt_addr_crack(pt_addr_crack_0),
        .start(1'b0),
        .stop
    );
endmodule
