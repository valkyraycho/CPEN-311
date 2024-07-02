module task2(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

reg wren_s, init_en, wren_s_init, wren_s_ksa;
reg[7:0] wrdata_s, addr_s;
wire ksa_rdy, init_rdy;
wire[7:0] rddata_s, addr_s_ksa, addr_s_init, wrdata_s_ksa, wrdata_s_init;
reg[23:0] key_s;

assign key_s = {14'd0,SW};


always_comb begin
	if((init_rdy == 1'b1)||(ksa_rdy == 1'b0))begin
		addr_s = addr_s_ksa;
		wren_s = wren_s_ksa;
		wrdata_s = wrdata_s_ksa;
	end
	
	else begin
		addr_s = addr_s_init;
		wren_s = wren_s_init;
		wrdata_s = wrdata_s_init;
	end
end

init initmodule (
.clk(CLOCK_50),.rst_n(KEY[3]),
            .en(init_en), .rdy(init_rdy),
            .addr(addr_s_init), .wrdata(wrdata_s_init), .wren(wren_s_init)
);

ksa ksamodule(.clk(CLOCK_50), .rst_n(KEY[3]),
		   .en(init_rdy), .rdy(ksa_rdy),
		   .key(key_s),
           .addr(addr_s_ksa), .rddata(rddata_s), .wrdata(wrdata_s_ksa), .wren(wren_s_ksa)); 
 
s_mem s(
	.address(addr_s), 
	.clock(CLOCK_50),
	.data(wrdata_s),
	.wren(wren_s),
	.q(rddata_s));

endmodule: task2
