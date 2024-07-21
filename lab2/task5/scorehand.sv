module scorehand(input [3:0] card1, input [3:0] card2, input [3:0] card3, output [3:0] total);

// The code describing scorehand will go here.  Remember this is a combinational
// block. The function is described in the handout.  Be sure to review the section
// on representing numbers in the lecture notes.

// Score of hand = (Value1 + Value2 + Value3) mod 10
// Each Ace, 2, 3, 4, 5, 6, 7, 8, and 9 has a value equal to the face value
// Tens, Jacks, Queens, and Kings have a value of 0

//Manipulatable regs
reg [3:0] rcard1;
reg [3:0] rcard2;
reg [3:0] rcard3;
reg [3:0] rtotal;

assign total = rtotal;

always @(*)
begin

    case(card1[3:0])
    10: rcard1 = 0;
    11: rcard1 = 0;
    12: rcard1 = 0;
    13: rcard1 = 0;
    14: rcard1 = 0;
    15: rcard1 = 0;
    default: rcard1 = card1;
    endcase

    case(card2[3:0])
    10: rcard2 = 0;
    11: rcard2 = 0;
    12: rcard2 = 0;
    13: rcard2 = 0;
    14: rcard2 = 0;
    15: rcard2 = 0;
    default: rcard2 = card2;
    endcase

    case(card3[3:0])
    10: rcard3 = 0;
    11: rcard3 = 0;
    12: rcard3 = 0;
    13: rcard3 = 0;
    14: rcard3 = 0;
    15: rcard3 = 0;
    default: rcard3 = card3;
    endcase

    rtotal = (rcard1+rcard2+rcard3)%10;

end
endmodule

