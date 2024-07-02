module flash_reader(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
                    output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
                    output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
                    output logic [9:0] LEDR);

// You may use the SW/HEX/LEDR ports for debugging. DO NOT delete or rename any ports or signals.

logic clk, rst_n;

assign clk = CLOCK_50;
assign rst_n = KEY[3];

logic flash_mem_read, flash_mem_waitrequest, flash_mem_readdatavalid;
logic [22:0] flash_mem_address;
logic [31:0] flash_mem_readdata;
logic [3:0] flash_mem_byteenable;

reg [7:0] s_address;
reg [15:0] s_data;
reg s_wren;
reg [15:0] s_q;
reg [7:0] index;
reg [3:0] flash_state;
reg [31:0] read32;

flash flash_inst(.clk_clk(clk), .reset_reset_n(rst_n), .flash_mem_write(1'b0), .flash_mem_burstcount(1'b1),
                 .flash_mem_waitrequest(flash_mem_waitrequest), .flash_mem_read(flash_mem_read), .flash_mem_address(flash_mem_address),
                 .flash_mem_readdata(flash_mem_readdata), .flash_mem_readdatavalid(flash_mem_readdatavalid), .flash_mem_byteenable(flash_mem_byteenable), .flash_mem_writedata());

s_mem samples(.address(s_address),.clock(clk),
                .data(s_data),.wren(s_wren),.q(s_q)); //All outputs except q, don't need q

assign flash_mem_byteenable = 4'b1111;

// the rest of your code goes here.  don't forget to instantiate the on-chip memory
always_ff @(posedge clk) begin
    if(rst_n == 0)begin //Reset State
        flash_mem_read <= 0;
        s_wren <= 0;
        index <= 0;
        flash_state <= 0;
    end

    else begin
        if(index < 128) begin

            case (flash_state)
                0: begin //Set read high, assert read-address
                    s_wren <= 0;
                    flash_mem_address <= index;
                    flash_mem_read <= 1;
                    flash_state <= 5;
                end

                 5: begin //Set read high, assert read-address
                    if(flash_mem_waitrequest==0)
                    flash_state <= 1;
                    else 
                    flash_state <= 5;
                end

                1: begin //Wait for readdatavalid to be asserted
                    if(flash_mem_readdatavalid == 1) begin //Data valid, set read to 0 and load data into read32
                        flash_mem_read <= 0;
                        read32 <= flash_mem_readdata;
                        flash_state <= 2;
                    end

                    else begin //Data not valid yet, wait for assertion
                        //read32 <= 3942621438; //TESTING
                        flash_state <= 1; //TESTING
                    end
                end
                2: begin //Load first set of 16 bits into s_mem
                    s_address <= index * 2;
                    s_data <= read32[15:0];
                    s_wren <= 1;
                    flash_state <= 3;
                
                end
                3: begin
                    s_address <= index * 2 + 1;
                    s_data <= read32[31:16];
                    s_wren <= 1;
                    flash_state <= 4;
                end

                4: begin //Increment index
                    index <= index + 1;
                    flash_state <= 0;
                end
                


                default: begin
                    //State out of bounds 
                end 
            endcase

        end

        else begin
            //Done transfering
        end
    
    end


end


always_comb begin



end

endmodule: flash_reader