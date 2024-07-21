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
        FETCH_SI,
        CALC_J,
        FETCH_SJ,
        WRITE_SJ2SI,
        WRITE_SI2SJ,
        DONE
    } state_t;

    state_t state, next_state;
    logic [7:0] i, j, si, sj, key_value;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            i     <= 8'b0;
            j     <= 8'b0;
        end
        else begin
            state <= next_state;
            if (state == IDLE) begin
                i <= 8'b0;
                j <= 8'b0;
            end
            else if (state == WRITE_SI2SJ && next_state == FETCH_SI) i <= i + 1;
            else if (state == CALC_J) j <= (j + rddata + key_value) % 256;
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
                if (en) next_state = FETCH_SI;
            end

            FETCH_SI: begin
                addr       = i;
                next_state = CALC_J;
            end

            CALC_J: begin
                si         = rddata;
                next_state = FETCH_SJ;
            end

            FETCH_SJ: begin
                addr       = j;
                next_state = WRITE_SJ2SI;
            end

            WRITE_SJ2SI: begin
                sj         = rddata;
                addr       = i;
                wrdata     = sj;
                wren       = 1'b1;
                next_state = WRITE_SI2SJ;
            end

            WRITE_SI2SJ: begin
                addr   = j;
                wrdata = si;
                wren   = 1'b1;

                if (i == 8'd255) next_state = DONE;
                else next_state = FETCH_SI;

            end

            DONE: begin
                rdy        = 1'b1;
                next_state = IDLE;
            end
        endcase
    end
endmodule : ksa
