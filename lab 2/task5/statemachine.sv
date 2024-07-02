module statemachine(input slow_clock, input resetb,
                    input [3:0] dscore, input [3:0] pscore, input [3:0] pcard3,
                    output load_pcard1, output load_pcard2,output load_pcard3,
                    output load_dcard1, output load_dcard2, output load_dcard3,
                    output player_win_light, output dealer_win_light);

// The code describing your state machine will go here.  Remember that
// a state machine consists of next state logic, output logic, and the 
// registers that hold the state.  You will want to review your notes from
// CPEN 211 or equivalent if you have forgotten how to write a state machine.

reg load_pcard1_r, load_pcard2_r ,load_pcard3_r ,load_dcard1_r ,load_dcard2_r ,load_dcard3_r, player_win_light_r, dealer_win_light_r;

assign load_pcard1 = load_pcard1_r;
assign load_pcard2 = load_pcard2_r;
assign load_pcard3 = load_pcard3_r;
assign load_dcard1 = load_dcard1_r;
assign load_dcard2 = load_dcard2_r;
assign load_dcard3 = load_dcard3_r;
assign player_win_light = player_win_light_r; 
assign dealer_win_light = dealer_win_light_r;

//Below is logic that can be filled in with syntax later

reg[3:0] State;
wire[3:0] State_comb;
assign State_comb = State;

always_ff @(posedge slow_clock) begin

    if(~resetb) begin
        State <= 4'b0000;
    end

    else if (State == 4'b0000) begin //DEAL CARD 1 TO PLAYER
        State <= 4'b0001;
    end

    else if (State == 4'b0001) begin //DEAL CARD 1 TO DEALER
        State <= 4'b0010;
    end

    else if (State == 4'b0010) begin //DEAL CARD 2 TO PLAYER
        State <= 4'b0011;
    end

    else if (State == 4'b0011) begin //DEAL CARD 2 TO DEALER
        State <= 4'b0101;
        //Try to implement winner logic here so we don't have an extra clock that does nothing on the UI
    end

    else if ((State == 4'b0101)&&((pscore >= 4'b1000)||(dscore >= 4'b1000))) begin //Winner off the bat?
        State <= 4'b0110; //Declare winner state
    end

    else if ((State == 4'b0101)&&(pscore <= 4'd5)) begin //Player score in range of 0->5?
        State <= 4'b1111; //Load extra card
    end

    else if (State == 4'b1111) begin
        State <= 4'b0111;
    end

    else if (State == 4'b0111) begin //Player gets card and dealer maybe gets card
        State <= 4'b0110; //declare winner
    end

    else if ((State == 4'b0101)&&((4'd6 <= pscore) && (pscore <= 4'd7))) begin //Player score in range 6->7?
        State <= 4'b1000; //Deal card
    end

    else if (State == 4'b1000) begin 
        State <= 4'b0110; //Declare winner
    end

end




always_comb begin 

    if(State_comb == 4'b0000) begin //Deal PCard1
        load_pcard1_r = 1'b1;
        load_pcard2_r = 1'b0;
        load_pcard3_r = 1'b0;
        load_dcard1_r = 1'b0;
        load_dcard2_r = 1'b0;
        load_dcard3_r = 1'b0;
        player_win_light_r = 1'b0;
        dealer_win_light_r = 1'b0;
    end

    else if(State_comb == 4'b0001) begin //Deal DCard1
        load_pcard1_r = 1'b0;
        load_pcard2_r = 1'b0;
        load_pcard3_r = 1'b0;
        load_dcard1_r = 1'b1;
        load_dcard2_r = 1'b0;
        load_dcard3_r = 1'b0;
        player_win_light_r = 1'b0;
        dealer_win_light_r = 1'b0;
    end

    else if(State_comb == 4'b0010) begin //Deal PCard2
        load_pcard1_r = 1'b0;
        load_pcard2_r = 1'b1;
        load_pcard3_r = 1'b0;
        load_dcard1_r = 1'b0;
        load_dcard2_r = 1'b0;
        load_dcard3_r = 1'b0;
        player_win_light_r = 1'b0;
        dealer_win_light_r = 1'b0;
    end

    else if(State_comb == 4'b0011) begin //Deal DCard2
        load_pcard1_r = 1'b0;
        load_pcard2_r = 1'b0;
        load_pcard3_r = 1'b0;
        load_dcard1_r = 1'b0;
        load_dcard2_r = 1'b1;
        load_dcard3_r = 1'b0;
        player_win_light_r = 1'b0;
        dealer_win_light_r = 1'b0; 
    end


    else if(State_comb == 4'b0101) begin //Logic to find if someone won, do nothing
        load_pcard1_r = 1'b0; //Anyway to do this state implicitely instead of clicking an extra time?
        load_pcard2_r = 1'b0;
        load_pcard3_r = 1'b0;
        load_dcard1_r = 1'b0;
        load_dcard2_r = 1'b0;
        load_dcard3_r = 1'b0;
        player_win_light_r = 1'b0;
        dealer_win_light_r = 1'b0;
    end

    
    else if(State_comb == 4'b0110) begin //Declare Winner
        
        if(pscore > dscore) begin
            player_win_light_r = 1'b1;
            dealer_win_light_r = 1'b0;
        end
        else if (dscore > pscore) begin
            player_win_light_r = 1'b0;
            dealer_win_light_r = 1'b1;
        end 
        else begin
            player_win_light_r = 1'b1;
            dealer_win_light_r = 1'b1; 
        end
        load_pcard1_r = 1'b0;
        load_pcard2_r = 1'b0;
        load_pcard3_r = 1'b0;
        load_dcard1_r = 1'b0;
        load_dcard2_r = 1'b0;
        load_dcard3_r = 1'b0;
    end

    else if(State_comb == 4'b0111) begin //Does dealer get a card? Pscore 0->5
 
        if (dscore == 4'd7) begin
            load_dcard3_r = 1'b0;
        end
        
        else if((dscore == 4'd6)&&((pcard3 == 4'd6)||(pcard3 == 4'd7))) begin
           load_dcard3_r = 1'b1;
        end

        else if ((dscore == 4'd5)&&((4'd4 <= pcard3) && (pcard3 <=4'd7))) begin
            load_dcard3_r = 1'b1;
        end

        else if ((dscore == 4'd4)&&((4'd2 <= pcard3) && (pcard3 <= 4'd7))) begin
            load_dcard3_r = 1'b1;
        end

        else if ((dscore == 4'd3)&&(pcard3 !== 4'd8)) begin
            load_dcard3_r = 1'b1;
        end

        else if ((4'd0 <= dscore) && (dscore <= 4'd2)) begin
            load_dcard3_r = 1'b1;
        end

        else begin
            load_dcard3_r = 1'b0; 
        end
        
        load_pcard1_r = 1'b0;
        load_pcard2_r = 1'b0;
        load_pcard3_r = 1'b0;
        load_dcard1_r = 1'b0;
        load_dcard2_r = 1'b0;
        player_win_light_r = 1'b0;
        dealer_win_light_r = 1'b0;
    end
    
    else if(State_comb == 4'b1000) begin //player score 6->7
        if ((0 <= dscore) && (dscore <= 5 )) begin
            load_dcard3_r = 1'b1;
        end

        else begin
            load_dcard3_r = 1'b0;
        end
        
        dealer_win_light_r = 1'b0;
        load_pcard1_r = 1'b0;
        load_pcard2_r = 1'b0;
        load_pcard3_r = 1'b0;
        load_dcard1_r = 1'b0;
        load_dcard2_r = 1'b0;
        player_win_light_r = 1'b0;
    end

    else if (State_comb == 4'b1111) begin //player gets card (0->5 score)
        load_pcard1_r = 1'b0;
        load_pcard2_r = 1'b0;
        load_pcard3_r = 1'b1;
        load_dcard1_r = 1'b0;
        load_dcard2_r = 1'b0;
        load_dcard3_r = 1'b0;
        player_win_light_r = 1'b0;
        dealer_win_light_r = 1'b0;
    end

    else begin
        load_pcard1_r = 1'b0;
        load_pcard2_r = 1'b0;
        load_pcard3_r = 1'b0;
        load_dcard1_r = 1'b0;
        load_dcard2_r = 1'b0;
        load_dcard3_r = 1'b0;
        player_win_light_r = 1'b0;
        dealer_win_light_r = 1'b0;
    end
end
endmodule

