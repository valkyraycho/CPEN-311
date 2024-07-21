module prga (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        en,
    output logic        rdy,
    input  logic [23:0] key,
    output logic [ 7:0] s_addr,
    input  logic [ 7:0] s_rddata,
    output logic [ 7:0] s_wrdata,
    output logic        s_wren,
    output logic [ 7:0] ct_addr,
    input  logic [ 7:0] ct_rddata,
    output logic [ 7:0] pt_addr,
    input  logic [ 7:0] pt_rddata,
    output logic [ 7:0] pt_wrdata,
    output logic        pt_wren
);
    typedef enum {
        IDLE,
        FETCH_MSG_LEN,
        STORE_MSG_LEN,
        MODIFY_I,
        FETCH_SI,
        MODIFY_J,
        FETCH_SJ,
        WRITE_SJ2SI,
        WRITE_SI2SJ,
        FETCH_PAD_CT,
        WRITE_PT,
        DONE
    } state_t;

    state_t state, next_state;
    logic [7:0] i, j, k, si, sj;
    logic [7:0] msg_len, pad, ct;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            i     <= 8'b0;
            j     <= 8'b0;
            k     <= 8'b1;
        end
        else begin
            state <= next_state;
            if (state == IDLE) begin
                i <= 8'b0;
                j <= 8'b0;
                k <= 8'b1;
            end
            else if (state == WRITE_PT && next_state == MODIFY_I) k <= k + 1;
            else if (state == MODIFY_I) i <= (i + 1) % 256;
            else if (state == MODIFY_J) j <= (j + si) % 256;

        end
    end

    always_comb begin
        rdy        = 1'b0;
        s_addr     = 8'b0;
        s_wrdata   = 8'b0;
        s_wren     = 1'b0;
        ct_addr    = 8'b0;
        pt_addr    = 8'b0;
        pt_wrdata  = 8'b0;
        pt_wren    = 1'b0;
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

            STORE_MSG_LEN: begin
                msg_len    = ct_rddata;
                next_state = MODIFY_I;
            end

            MODIFY_I: next_state = FETCH_SI;

            FETCH_SI: begin
                s_addr     = i;
                next_state = MODIFY_J;
            end

            MODIFY_J: begin
                si         = s_rddata;
                next_state = FETCH_SJ;
            end

            FETCH_SJ: begin
                s_addr     = j;
                next_state = WRITE_SJ2SI;
            end

            WRITE_SJ2SI: begin
                sj         = s_rddata;
                s_addr     = i;
                s_wrdata   = sj;
                s_wren     = 1'b1;
                next_state = WRITE_SI2SJ;
            end

            WRITE_SI2SJ: begin
                s_addr     = j;
                s_wrdata   = si;
                s_wren     = 1'b1;
                next_state = FETCH_PAD_CT;
            end

            FETCH_PAD_CT: begin
                s_addr     = (si + sj) % 256;
                ct_addr    = k;
                next_state = WRITE_PT;
            end

            WRITE_PT: begin
                pad       = s_rddata;
                ct        = ct_rddata;
                pt_addr   = k;
                pt_wren   = 1'b1;
                pt_wrdata = pad ^ ct;

                if (k == msg_len) next_state = DONE;
                else next_state = MODIFY_I;
            end

            DONE: begin
                rdy        = 1'b1;
                next_state = IDLE;
            end
        endcase
    end
endmodule : prga
