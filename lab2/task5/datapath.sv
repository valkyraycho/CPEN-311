module datapath(input slow_clock, input fast_clock, input resetb,
                input load_pcard1, input load_pcard2, input load_pcard3,
                input load_dcard1, input load_dcard2, input load_dcard3,
                output [3:0] pcard3_out,
                output [3:0] pscore_out, output [3:0] dscore_out,
                output[6:0] HEX5, output[6:0] HEX4, output[6:0] HEX3,
                output[6:0] HEX2, output[6:0] HEX1, output[6:0] HEX0);
						
// The code describing your datapath will go here.  Your datapath 
// will hierarchically instantiate six card7seg blocks, two scorehand
// blocks, and a dealcard block.  The registers may either be instatiated
// or included as sequential always blocks directly in this file.
//
// Follow the block diagram in the Lab 1 handout closely as you write this code.


wire [3:0] new_card;
wire [3:0] pcard_out_1;//Output of PCard1, input of card7seg on HEX0
wire [3:0] pcard_out_2;//Output of PCard2, input of card7seg on HEX1
//wire [3:0] pcard_out_3;//Output of PCard3, input of card7seg on HEX2

wire [3:0] dcard_out_1;//DCard1 -> card7segHex3
wire [3:0] dcard_out_2;//DCard2 -> card7segHex4
wire [3:0] dcard_out_3;//DCard3 -> card7segHex5

reg [3:0] rpcard3_out;
reg [3:0] rpscore_out;
reg [3:0] rdscore_out;
reg [6:0] rHEX5;
reg [6:0] rHEX4;
reg [6:0] rHEX3;
reg [6:0] rHEX2;
reg [6:0] rHEX1;
reg [6:0] rHEX0;

assign pcard3_out = rpcard3_out;
assign pscore_out = rpscore_out;
assign dscore_out = rdscore_out;
assign HEX5 = rHEX5;
assign HEX4 = rHEX4;
assign HEX3 = rHEX3;
assign HEX2 = rHEX2;
assign HEX1 = rHEX1;
assign HEX0 = rHEX0;


//Only outputs need to be assigned to Reg?
//How to assign LEDR to score out for player and banker?

//assign slow_clock = KEY(0);
//assign resetb = KEY(3);
//Don't know how to assign LEDR  


//Don't need statemachine instantiated, already done in task5.sv
//statemachine statemachineinst(.slow_clock(slow_clock),.resetb(resetb),.dscore(rdscore_out),.pscore(rpscore_out),
//.pcard3(rpcard3_out),.load_pcard1(load_pcard1),.load_pcard2(load_pcard2),.load_pcard3(load_pcard3),
//.load_dcard1(load_dcard1),.load_dcard2(load_dcard2),.load_dcard3(load_dcard3),.player_win_light(rpscore_out),.dealer_win_light(rdscore_out));

//Player reg4's
reg4 PCard1(.new_card(new_card),.resetb(resetb),.load_card(load_pcard1),.slow_clock(slow_clock),.card_out(pcard_out_1));
reg4 PCard2(.new_card(new_card),.resetb(resetb),.load_card(load_pcard2),.slow_clock(slow_clock),.card_out(pcard_out_2));
reg4 PCard3(.new_card(new_card),.resetb(resetb),.load_card(load_pcard3),.slow_clock(slow_clock),.card_out(rpcard3_out));//Pcard3 needs to be a reg, is an output
//Dealer reg4's
reg4 DCard1(.new_card(new_card),.resetb(resetb),.load_card(load_dcard1),.slow_clock(slow_clock),.card_out(dcard_out_1));
reg4 DCard2(.new_card(new_card),.resetb(resetb),.load_card(load_dcard2),.slow_clock(slow_clock),.card_out(dcard_out_2));
reg4 DCard3(.new_card(new_card),.resetb(resetb),.load_card(load_dcard3),.slow_clock(slow_clock),.card_out(dcard_out_3));
//Player card7seg's
card7seg segHex0(.SW(pcard_out_1),.HEX0(rHEX0));
card7seg segHex1(.SW(pcard_out_2),.HEX0(rHEX1));
card7seg segHex2(.SW(rpcard3_out),.HEX0(rHEX2));

//Dealer card7seg's
card7seg segHex3(.SW(dcard_out_1),.HEX0(rHEX3));
card7seg segHex4(.SW(dcard_out_2),.HEX0(rHEX4));
card7seg segHex5(.SW(dcard_out_3),.HEX0(rHEX5));
//Dealcard 
dealcard dealcardinst(.clock(fast_clock),.resetb(resetb),.new_card(new_card));
//Player scorehand
scorehand playerscorehand(.card1(pcard_out_1),.card2(pcard_out_2),.card3(rpcard3_out),.total(rpscore_out));
//Dealer scorehand
scorehand dealerscorehand(.card1(dcard_out_1),.card2(dcard_out_2),.card3(dcard_out_3),.total(rdscore_out));

endmodule

