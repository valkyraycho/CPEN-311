module init (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       en,
    output logic       rdy,
    output logic [7:0] addr,
    output logic [7:0] wrdata,
    output logic       wren
);

    //INPUTS: clk, rst_n, en
    //OUTPUTS: rdy, addr, wrdata, wren 

    logic [7:0] i;
    logic flag;

    always_ff @(posedge clk) begin
        if (rst_n == 1'b0) begin  //If reset is asserted load 0 into addr 0
            rdy  <= 1'b0;
            i    <= 8'b0;
            wren <= 1'b0;
            flag <= 1'b0;
        end

        else if (en == 1'b1) begin
            if (i < 255 && !flag) begin  //increment loading 1 into addr 1, 2 into addr2....
                rdy  <= 1'b0;
                i    <= i + 1;
                wren <= 1'b1;
            end

            else if (i == 255) begin
                i   <= i + 1;
                rdy <= 1'b1;
                flag = 1'b1;
            end

            else begin
                rdy  <= 1'b0;
                wren <= 1'b0;
            end
        end
    end

    always_comb begin
        addr   = i;
        wrdata = i;

    end



endmodule : init
