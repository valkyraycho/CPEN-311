`timescale 1ps / 1ps
module tb_syn_task2();


reg[3:0] KEY_s;
reg[9:0] SW_s;
wire[9:0] LEDR_s;
wire[6:0] HEX0_s, HEX1_s, HEX2_s, HEX3_s, HEX4_s, HEX5_s, VGA_Y_s;
wire[7:0] VGA_R_s, VGA_G_s, VGA_B_s, VGA_X_s;
wire VGA_HS_s, VGA_VS_s, VGA_PLOT_s;
wire[2:0] VGA_COLOUR_s;
reg CLOCK_50_s = 1'b0;
reg VGA_CLK_s;
reg [18:0] clkticks = 19'd0;
reg[7:0] xcoord;
reg [6:0] ycoord;
task2 DUT(.CLOCK_50(CLOCK_50_s), .KEY(KEY_s),
             .SW(SW_s), .LEDR(LEDR_s),
             .HEX0(HEX0_s), .HEX1(HEX1_s), .HEX2(HEX2_s),
             .HEX3(HEX3_s), .HEX4(HEX4_s), .HEX5(HEX5_s),
             .VGA_R(VGA_R_s), .VGA_G(VGA_G_s), .VGA_B(VGA_B_s),
             .VGA_HS(VGA_HS_s), .VGA_VS(VGA_VS_s), .VGA_CLK(VGA_CLK_s),
             .VGA_X(VGA_X_s), .VGA_Y(VGA_Y_s),
             .VGA_COLOUR(VGA_COLOUR_s), .VGA_PLOT(VGA_PLOT_s));

initial begin
	forever begin
		CLOCK_50_s = ~CLOCK_50_s;
		#1;
	end
end

initial begin //Success case
KEY_s[3] = 1'b0;
#1;
KEY_s[3] = 1'b1;
#1;
xcoord = 8'd0;
ycoord = 8'd0;
#1;
while (xcoord < 160) begin  
    assert((VGA_COLOUR_s === (xcoord % 8)) && (VGA_Y_s === ycoord) && (VGA_X_s === xcoord))begin
	$display("[PASS], The colour and coordinates are correct after the %d cycle",clkticks/2);
    end else begin
	$error("[FAIL], The colour and coordinates are incorrect after the %d cycle",clkticks/2);
    end
    #2;
    if(ycoord == 7'd119) begin
        xcoord = xcoord + 8'd1;
        ycoord = 7'd0;
    end
    else begin
        ycoord = ycoord + 7'd1;
    end
    clkticks = clkticks+2;
end
#5;

//No automated test. Verification done via comparing the final s memory to our expected result in memory viewer.
$stop;

end
endmodule: tb_syn_task2
