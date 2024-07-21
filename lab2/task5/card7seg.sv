module card7seg(input [3:0] SW, output [6:0] HEX0);	
   // your code goes here
   reg [6:0] rHEX0;
	assign HEX0 = rHEX0;

always @* begin 
			case(SW[3:0])
			0 : begin
			rHEX0 = 7'b1111111;
			
			end
			1 : begin
			rHEX0 = 7'b0001000;
			
			end
			2 : begin
			rHEX0 = 7'b0100100;
			
			end
			3 : begin 
			rHEX0 = 7'b0110000;
			
			end
			4 : begin 
			rHEX0 = 7'b0011001;
			
			end
			5 : begin 
			rHEX0 = 7'b0010010;
			
			end
			6 : begin 
			rHEX0 = 7'b0000010;
			
			end
			7 : begin 
			rHEX0 = 7'b1111000;
			
			end
			8 : begin 
			rHEX0 = 7'b0000000;
			
			end
			9 : begin
			rHEX0 = 7'b0010000;
			
			end
         10 : begin
			rHEX0 = 7'b1000000;
			
			end
         11 : begin //JACK
			rHEX0 = 7'b1100001;
			
			end
         12 : begin //QUEEN
			rHEX0 = 7'b0011000;
			
			end
         13 : begin //KING
			rHEX0 = 7'b0001001;
			
			end
			default : begin 
				rHEX0 = 7'b1111111; 
				
				end
			endcase
end

endmodule

