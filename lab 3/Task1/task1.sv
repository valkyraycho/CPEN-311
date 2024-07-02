module task1(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

wire rdy, en, wren;
wire [7:0] wrdata, addr, rdata; //rdata was named by me and is the data we read from memory

init initmodule (
.clk(CLOCK_50),.rst_n(KEY[3]),
            .en(en), .rdy(rdy),
            .addr(addr), .wrdata(wrdata), .wren(wren)
);

s_mem s(
	.address(addr),
	.clock(CLOCK_50),
	.data(wrdata),
	.wren(wren),
	.q(rdata));

    // your code here

endmodule: task1
