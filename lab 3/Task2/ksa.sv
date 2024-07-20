module ksa (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        en,
    input  logic [23:0] key,
    input  logic [ 7:0] rddata,
    output logic        rdy,
    output logic [ 7:0] addr,
    output logic [ 7:0] wrdata,
    output logic        wren
);
    typedef enum {
        IDLE,
        INIT,
        FETCHSI,
        CALCJ,
        FETCHSJ,
        WRITESJ2SI,
        WRITESI2SJ,
        DONE
    } state_t;

    state_t state, next_state;
    logic [7:0] i, j, si, sj, key_value, prev_j;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            i     <= 8'b0;
            j     <= 8'b0;
        end
        else begin
            state <= next_state;
            if (state == WRITESI2SJ && next_state == FETCHSI) i <= i + 1;
            if (state == CALCJ) j <= (j + rddata + key_value) % 256;
        end
    end

    always_comb begin
        // defaults
        rdy        = 1'b0;
        addr       = 8'b0;
        wrdata     = 8'b0;
        wren       = 1'b0;
        next_state = state;
        key_value  = key[23-8*(i%3)-:8];

        case (state)
            IDLE: begin
                rdy = 1'b1;
                if (en) next_state = FETCHSI;
            end

            FETCHSI: begin
                addr       = i;
                next_state = CALCJ;
            end

            CALCJ: begin
                si         = rddata;
                next_state = FETCHSJ;
            end

            FETCHSJ: begin
                addr       = j;
                next_state = WRITESJ2SI;
            end

            WRITESJ2SI: begin
                sj         = rddata;
                addr       = i;
                wrdata     = sj;
                wren       = 1'b1;
                next_state = WRITESI2SJ;
            end

            WRITESI2SJ: begin
                addr   = j;
                wrdata = si;
                wren   = 1'b1;

                if (i == 8'd255) begin
                    next_state = DONE;
                end
                else begin
                    next_state = FETCHSI;
                end
            end

            DONE: begin
                rdy        = 1'b1;
                next_state = IDLE;
            end
        endcase
    end
endmodule : ksa
