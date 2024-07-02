module ksa(input logic clk, input logic rst_n,
           input logic en, output logic rdy,
           input logic [23:0] key,
           output logic [7:0] addr, input logic [7:0] rddata, output logic [7:0] wrdata, output logic wren);

    reg rdy_h,wren_h; 
	reg[7:0] addr_h, wrdata_h, i, j, si, sj, temp, key_value;
	reg[4:0] state;
	wire[4:0] state_comb;
	wire[7:0] i_wire, j_wire, si_wire, sj_wire;
	assign addr = addr_h;
	assign wren = wren_h;
	assign rdy = rdy_h;
	assign wrdata = wrdata_h;
	assign state_comb = state;
	assign i_wire = i;
	assign j_wire = j;
	assign si_wire = si;
	assign sj_wire = sj;

	
    always @(posedge clk) begin
		if(rst_n == 1'b0) begin
			rdy_h = 1'b1;
			i = 8'd0;
			j = 8'd0;
			
		end
		
		else if ((en == 1'b1) && (rdy == 1'b1))begin
			rdy_h = 1'b0;
			state = 5'd0;
		end
		
			
		else if((i == 8'd255) && (state!=5'd10)) begin
			rdy_h = 1'b1;
			state = 5'd10;
		end
		
		else if (state == 5'd0) begin
			state = 5'd1;
			i = 8'd0;
			j = 8'd0;
		end
		
		else if (state == 5'd1) begin //load si and calculate j
			state = 5'd2;
		end
		
		else if (state == 5'd2) begin //load sj
			si = rddata;
			j = (j + rddata + key_value) % 256;
			state = 5'd8;
		end
		
		else if (state == 5'd8) begin //load si and calculate j
			state = 5'd9;
		end
		
		else if (state == 5'd9)begin
			sj = rddata;
			state = 5'd3;
		end
		
		else if (state == 5'd3) begin //send si back
			state = 5'd4;
		end
		
		else if (state == 5'd4) begin//send sj back
			state = 5'd5;
		end
		
		else if (state == 5'd5) begin//increment i
			i <= i+1;
			state = 5'd6;
		end
		
		else if (state == 5'd6) begin //State that determines if process is completed or not
			if (i == 8'd0) begin
				state = 5'd7;
			end
			
			else begin 
				state = 5'd1;
			end
		end

		else if (state == 5'd10)begin
			rdy_h = 1'b0;
		end
		else begin
			state = 5'd7;
		end
		
    end
	
	always_comb begin
			case (i%3) 
				2'd0: begin key_value = key[23:16]; end
				2'd1: begin key_value = key[15:8]; end
				2'd2: begin key_value = key[7:0]; end
				default begin key_value = 8'b11111111; end
			
			endcase
	end
	
	always_comb begin
	
		if(rst_n == 1'b0)begin
			wren_h = 1'b0;
			wrdata_h = 8'd255;
			addr_h = 8'd255;
		end
		
		if(state_comb == 5'd0)begin
			wren_h = 1'b0;
			wrdata_h = 8'd255;//salient value to make waveform analysis easier
			addr_h = 8'd255;//salient value to make waveform analysis easier
		end
		
		else if (state_comb == 5'd1)begin //Load si
			wren_h = 1'b0; 
			wrdata_h = 8'd255;
			addr_h = i;
		end
		
		else if(state_comb == 5'd2)begin //Load sj
			wren_h = 1'b0;
			wrdata_h = 8'd255;
			addr_h = j;
		end
		
		else if (state_comb == 5'd3)begin //send si to j address
			wren_h = 1'b1;
			wrdata_h = si_wire;
			addr_h = j;
		end
		
		else if(state_comb == 5'd4)begin //send sj to i
			wren_h = 1'b1;
			wrdata_h = sj_wire;
			addr_h = i;
		end
		
		else if(state_comb == 5'd5)begin //increment i
			wren_h = 1'b0;
			wrdata_h = 8'd255;
			addr_h = 8'd255;
		end
		
		else if(state_comb == 5'd6)begin //nothing to do in combinational logic
			wren_h = 1'b0;
			wrdata_h = 8'd255;
			addr_h = 8'd255;
		end
		
		else if(state_comb == 5'd8)begin //nothing to do in combinational logic
			wren_h = 1'b0;
			wrdata_h = 8'd255;
			addr_h = j;
		end
		
		else begin
			wren_h = 1'b0;
			wrdata_h = 8'd255;
			addr_h = i;
		end
	end

endmodule: ksa
