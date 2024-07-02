module reg4(input[3:0] new_card, input resetb, input load_card, input slow_clock, output[3:0] card_out);
//4-Bit register with active-low reset
reg [3:0] card;
assign card_out = card;

always_ff @(posedge slow_clock)
begin 
 if(resetb)
    begin   
    if(load_card)
        card <= new_card;
    else 
        card <= card;
    end
   else
    card <= 0;
end 
endmodule: reg4