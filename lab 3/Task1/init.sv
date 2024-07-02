module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

    //INPUTS: clk, rst_n, en
    //OUTPUTS: rdy, addr, wrdata, wren 
    
    reg rdy_h, wren_h, flag;
	reg[7:0] addr_h, wrdata_h, i;
	
    assign rdy = rdy_h;
	assign wren = wren_h;
	assign addr = addr_h;
	assign wrdata = wrdata_h;



always @(posedge clk) begin
		if(rst_n == 1'b0) begin //If reset is asserted load 0 into addr 0
			rdy_h = 1'b0;
			i = 8'b0;
			wren_h = 1'b1;
			addr_h = i;
			wrdata_h = i;
			flag = 1'b0;
		end
		
		else if((i < 255)&&(flag == 1'b0)) begin //increment loading 1 into addr 1, 2 into addr2....
			rdy_h = 1'b0;
			i = i+1;
			wren_h = 1'b1;
			addr_h = i;
			wrdata_h = i; 
		end
		
		else if (i == 255)begin
			flag = 1'b1;
			i = i+1;
			rdy_h = 1'b1;
		end
		
		else begin
			rdy_h = 1'b0;
			wren_h = 1'b0;
		end
end
    


endmodule: init