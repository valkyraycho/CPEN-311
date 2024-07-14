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

    // your code here
    reg [7:0] i, j, si, sj, sa, ctk, plaintextk;
    reg [8:0] k;  //K is negative
    reg [7:0] message_length;
    reg [7:0] r_s_addr, r_s_wrdata, r_ct_addr, r_pt_addr, r_pt_wrdata;
    reg [4:0] state, state_comb;  //State machine state
    reg r_s_wren, r_pt_wren, r_rdy, first_pass;

    assign rdy        = r_rdy;
    assign s_addr     = r_s_addr;
    assign s_wrdata   = r_s_wrdata;
    assign s_wren     = r_s_wren;
    assign ct_addr    = r_ct_addr;
    assign pt_addr    = r_pt_addr;
    assign pt_wrdata  = r_pt_wrdata;
    assign pt_wren    = r_pt_wren;
    assign state_comb = state;

    always @(posedge clk) begin
        if (rst_n == 0) begin  //Reset 
            k          <= 1;
            i          <= 0;
            j          <= 0;
            r_rdy      <= 1;  //Assert ready on reset
            first_pass <= 1;

        end

        else begin  //Not reset

            if ((en == 1) && (rdy == 1)) begin  //Find message length
                r_rdy      <= 0;  //Deassert ready, execution begin
                state      <= 13;  //Start executing prga
                k          <= 1;
                i          <= 0;
                j          <= 0;
                first_pass <= 1;
            end

            else begin
                //Do nothing
            end


            case (state)

                13: begin  //Extra state to read from mem
                    state <= 0;
                end
                0: begin  //Load ct_rddata at address 0 into message length
                    message_length <= ct_rddata;
                    state          <= 1;
                end

                1: begin  //Increment k,i, can't read s[i] yet, set state to 2
                    if (k < message_length) begin
                        if (first_pass != 1) begin
                            k <= k + 9'b000000001;
                        end
                        i          <= (i + 8'd1) % 256;
                        first_pass <= 0;
                        state      <= 2;
                    end

                    else begin
                        //k <= -1;
                        i     <= 0;
                        j     <= 0;
                        r_rdy <= 1;  //prga execution done, reassart ready (enable should deassert)
                        state <= 14;  //Send to state to de-assert ready
                    end

                end

                14: begin
                    r_rdy <= 0;
                end

                2: begin  //Read s[i] from mem
                    //No seq logic
                    state <= 3;
                end

                3: begin  //Put s[i] in si
                    si    <= s_rddata;
                    state <= 4;
                end

                4: begin  //j=(j+si)
                    j     <= (j + si) % 256;
                    state <= 5;
                end

                5: begin  //Read s[j] from mem
                    //No seq logic
                    state <= 6;
                end

                6: begin  //Put s[j] in sj
                    sj    <= s_rddata;
                    state <= 7;
                end

                7: begin  //s[i]=sj (write to mem)
                    //No seq logic
                    state <= 16;
                end

                16: begin
                    state <= 8;
                end

                8: begin  //s[j]=si (write to mem)
                    //No seq logic
                    state <= 9;
                end

                9: begin  //Read s[(si+sj)%256] and ciphertext[k] from mem
                    //No seq logic
                    state <= 10;
                end

                10: begin  //sa=s[(si+sj)%256] and ctk=ciphertext[k]
                    sa    <= s_rddata;
                    ctk   <= ct_rddata;
                    state <= 11;
                end

                11: begin  //Plaintextk <= sa XOR ctk
                    plaintextk <= sa ^ ctk;
                    state      <= 12;
                end

                12: begin  //Plaintext[k] = plaintextk (write to mem)
                    //No seq logic
                    state <= 15;
                end

                15: begin
                    state <= 1;
                end

                default: begin
                    //Do nothing, not enabled
                end

            endcase

        end
    end


    always_comb begin

        case (state_comb)

            13: begin
                r_s_wren    = 0;
                r_pt_wren   = 0;
                r_s_addr    = 255;
                r_ct_addr   = 0;  //Read from address 0 for message length
                r_pt_addr   = 255;
                r_s_wrdata  = 255;
                r_pt_wrdata = 255;

            end

            0: begin
                r_s_wren    = 0;
                r_pt_wren   = 0;
                r_s_addr    = 255;
                r_ct_addr   = 255;
                r_pt_addr   = 255;
                r_s_wrdata  = 255;
                r_pt_wrdata = 255;

            end

            1: begin
                //No comb logic
                r_s_wren    = 0;
                r_pt_wren   = 0;
                r_s_addr    = 255;
                r_ct_addr   = 255;
                r_pt_addr   = 255;
                r_s_wrdata  = 255;
                r_pt_wrdata = 255;
            end

            2: begin  //Read s[i] from mem
                r_s_addr    = i;
                r_s_wren    = 0;
                r_pt_wren   = 0;
                r_ct_addr   = 255;
                r_pt_addr   = 255;
                r_s_wrdata  = 255;
                r_pt_wrdata = 255;
            end

            3: begin  //Put s[i] in si
                //No comb logic
                r_s_wren    = 0;
                r_pt_wren   = 0;
                r_s_addr    = 255;
                r_ct_addr   = 255;
                r_pt_addr   = 255;
                r_s_wrdata  = 255;
                r_pt_wrdata = 255;
            end

            4: begin  //j=(j+si)
                //No comb logic
                r_s_wren    = 0;
                r_pt_wren   = 0;
                r_s_addr    = 255;
                r_ct_addr   = 255;
                r_pt_addr   = 255;
                r_s_wrdata  = 255;
                r_pt_wrdata = 255;
            end

            5: begin  //Read s[j] from mem
                r_s_addr    = j;
                r_s_wren    = 0;
                r_pt_wren   = 0;
                r_ct_addr   = 255;
                r_pt_addr   = 255;
                r_s_wrdata  = 255;
                r_pt_wrdata = 255;
            end

            6: begin  //Put s[j] in sj
                //No comb logic
                r_s_wren    = 0;
                r_pt_wren   = 0;
                r_s_addr    = 255;
                r_ct_addr   = 255;
                r_pt_addr   = 255;
                r_s_wrdata  = 255;
                r_pt_wrdata = 255;
            end

            7: begin  //s[i]=sj (write to mem)
                r_pt_wren   = 0;
                r_s_wren    = 1;
                r_s_addr    = i;
                r_s_wrdata  = sj;
                r_pt_addr   = 255;
                r_ct_addr   = 255;
                r_pt_wrdata = 255;
            end

            16: begin  //s[j]=si (write to mem)
                r_pt_wren   = 0;
                r_s_wren    = 0;
                r_s_addr    = j;
                r_s_wrdata  = si;
                r_pt_addr   = 255;
                r_ct_addr   = 255;
                r_pt_wrdata = 255;
            end

            8: begin  //s[j]=si (write to mem)
                r_pt_wren   = 0;
                r_s_wren    = 1;
                r_s_addr    = j;
                r_s_wrdata  = si;
                r_pt_addr   = 255;
                r_ct_addr   = 255;
                r_pt_wrdata = 255;
            end

            9: begin  //Read s[(si+sj)%256] and ciphertext[k] from mem
                r_s_wren    = 0;
                r_pt_wren   = 0;
                r_s_addr    = (si + sj) % 256;
                r_ct_addr   = k;
                r_pt_addr   = 255;
                r_s_wrdata  = 255;
                r_pt_wrdata = 255;
            end

            10: begin  //sa=s[(si+sj)%256] and ctk=ciphertext[k]
                r_s_wren    = 0;
                r_pt_wren   = 0;
                r_s_addr    = 255;
                r_ct_addr   = 255;
                r_pt_addr   = 255;
                r_s_wrdata  = 255;
                r_pt_wrdata = 255;
            end

            11: begin  //Plaintextk <= sa XOR ctk
                r_s_wren    = 0;
                r_pt_wren   = 0;
                r_s_addr    = 255;
                r_ct_addr   = 255;
                r_pt_addr   = 255;
                r_s_wrdata  = 255;
                r_pt_wrdata = 255;
            end

            12: begin  //Plaintext[k] = plaintextk (write to mem)
                r_s_wren    = 0;
                r_pt_wren   = 1;
                r_s_addr    = 255;
                r_ct_addr   = 255;
                r_pt_wrdata = plaintextk;
                r_pt_addr   = k;
                r_s_wrdata  = 255;
            end

            default: begin
                r_s_wren    = 0;
                r_pt_wren   = 0;
                r_s_addr    = 255;
                r_pt_addr   = 255;
                r_ct_addr   = 255;
                r_s_wrdata  = 255;
                r_pt_wrdata = 255;

            end



        endcase

    end

endmodule : prga
