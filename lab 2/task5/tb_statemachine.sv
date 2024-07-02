module tb_statemachine();

// 10,000 ticks (equivalent to "initial #10000 $finish();").
    reg slow_clock_s, resetb_s, load_pcard1_s, load_pcard2_s, load_pcard3_s, load_dcard1_s,
    load_dcard2_s, load_dcard3_s;

    wire player_win_light_s, dealer_win_light_s;

    reg sim_SW; //DELETE

    reg [3:0] pscore_s, dscore_s, pcard3_s;

 statemachine DUT (.slow_clock(slow_clock_s), .resetb(resetb_s),
                    .dscore(dscore_s), .pscore(pscore_s), .pcard3(pcard3_s),
                    .load_pcard1(load_pcard1_s), .load_pcard2(load_pcard2_s),.load_pcard3(load_pcard3_s),
                    .load_dcard1(load_dcard1_s), .load_dcard2(load_dcard2_s), .load_dcard3(load_dcard3_s),
                    .player_win_light(player_win_light_s), .dealer_win_light(dealer_win_light_s));


task reset();
    slow_clock_s = 1'b0;
    #1;
    resetb_s = 1'b0;
    slow_clock_s = 1'b1;
    #1;
endtask

task deal4();
slow_clock_s = 1'b0;
#1;
resetb_s = 1'b1;
slow_clock_s = 1'b1;
#1;
slow_clock_s = 1'b0;
#1;
slow_clock_s = 1'b1;
#1;
slow_clock_s = 1'b0;
#1;
slow_clock_s = 1'b1;
#1;
slow_clock_s = 1'b0;
#1;
slow_clock_s = 1'b1;
#1;
endtask

initial begin //Success case
//Test if the initial cards are dealt correctly 
reset();
//DID PLAYER CARD 1 LOAD?
assert(load_pcard1_s === 1'b1) begin

$display("[PASS], Game deals player card 1");

end else begin

$error("[FAIL], Game does not deal player card 1");

end
/////////////////////////
slow_clock_s = 1'b0;
#5;
resetb_s = 1'b1;
slow_clock_s = 1'b1;
#5;
//DID DEALER CARD 1 LOAD?
assert(load_dcard1_s === 1'b1) begin

$display("[PASS], Game deals dealer card 1");

end else begin

$error("[FAIL], Game does not deal dealer card 1");

end
/////////////////////////
slow_clock_s = 1'b0;
#5;
slow_clock_s = 1'b1;
#5;
//DID PLAYER CARD 2 LOAD?
assert(load_pcard2_s === 1'b1) begin

$display("[PASS], Game deals player card 2");

end else begin

$error("[FAIL], Game does not deal player card 2");

end
/////////////////////////
slow_clock_s = 1'b0;
#5;
slow_clock_s = 1'b1;
#5;
//DID DEALER CARD 2 LOAD?
assert(load_dcard2_s === 1'b1) begin

$display("[PASS], Game deals dealer card 2");

end else begin

$error("[FAIL], Game does not deal dealer card 2");

end
/////////////////////////
slow_clock_s = 1'b0;
#5;
pscore_s = 4'd9;
dscore_s = 4'd8;
slow_clock_s = 1'b1;
#5;
slow_clock_s = 1'b0;
#5;
slow_clock_s = 1'b1;
#5;
//Does the game declare instant winner on 9?
assert((player_win_light_s === 1'b1) && (dealer_win_light_s === 1'b0)) begin

$display("[PASS], Game declares winner for player when pscore = 9 and dscore = 8");

end else begin

$error("[FAIL], Game does not declare winner for player when pscore = 9 and dscore = 8");

end
/////////////////////////
reset();
deal4();
pscore_s = 4'd8;
dscore_s = 4'd8;
slow_clock_s = 1'b0;
#5;
slow_clock_s = 1'b1;
#5;

//Does the game declare TIE on 8-8?
assert((player_win_light_s === 1'b1) && (dealer_win_light_s === 1'b1)) begin

$display("[PASS], Game declares TIE when pscore = 8 and dscore = 8");

end else begin

$error("[FAIL], Game does not declare TIE when pscore = 8 and dscore = 8");

end
/////////////////////////
reset();
deal4();
pscore_s = 4'd9;
dscore_s = 4'd9;
slow_clock_s = 1'b0;
#5;
slow_clock_s = 1'b1;
#5;

//Does the game declare TIE on 8-8?
assert((player_win_light_s === 1'b1) && (dealer_win_light_s === 1'b1)) begin

$display("[PASS], Game declares TIE when pscore = 9 and dscore = 9");

end else begin

$error("[FAIL], Game does not declare TIE when pscore = 9 and dscore = 9");

end
/////////////////////////
reset();
deal4();
pscore_s = 4'd8;
dscore_s = 4'd9;
slow_clock_s = 1'b0;
#5;
slow_clock_s = 1'b1;
#5;

//Does the game declare TIE on 8-8?
assert((player_win_light_s === 1'b0) && (dealer_win_light_s === 1'b1)) begin

$display("[PASS], Game declares WIN for dealer when pscore = 8 and dscore = 9");

end else begin

$error("[FAIL], Game does not declare WIN for dealer when pscore = 8 and dscore = 9");

end
/////////////////////////
#5
$display("\n------------------------------------------------------");
$display("|BELOW ARE ALL THE TESTS FOR PLAYER SCORE BEING 0->5|");
$display("------------------------------------------------------\n");
for (pscore_s = 0; pscore_s < 6; pscore_s++) begin //checks all possibilities for pcard 0->5
    dscore_s = 7;
    reset();
    deal4();
    slow_clock_s = 1'b0;
    #2;
    slow_clock_s = 1'b1;
    #2;

    assert(load_dcard3_s === 1'b0) begin //Checks proper cards dealt for every possibility when dscore = 7 and pcard 0->5

    $display("[PASS], Game does not deal when pscore = %d and dscore = %d", pscore_s, dscore_s);

    end else begin

    $error("[FAIL], Game deals when pscore = %d and dscore = %d", pscore_s, dscore_s);

    end
    #2
    dscore_s = 6;
    #2
    for(pcard3_s = 6; pcard3_s < 8; pcard3_s++) begin //checks proper cards dealt for every possibility when dscore = 6 && pcard 0->5
        reset();
        deal4();
        slow_clock_s = 1'b0; /////////////////////
        #2;
        slow_clock_s = 1'b1;
        #2;
        assert(load_dcard3_s === 1'b0 && load_pcard3_s === 1'b1) begin

        $display("[PASS], Game deals to player when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end else begin

        $error("[FAIL], Game does not deal to player when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end 
        slow_clock_s = 1'b0; 
        #2;
        slow_clock_s = 1'b1;
        #2;
        assert(load_dcard3_s === 1'b1 && load_pcard3_s === 1'b0) begin

        $display("[PASS], Game deals to dealer when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end else begin

        $error("[FAIL], Game does not deal to dealer when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end 
    end

    #2
    dscore_s = 5;
    #2
    for(pcard3_s = 4; pcard3_s < 8; pcard3_s++) begin //checks proper cards dealt for every possibility when dscore = 5 && pcard 0->5
        reset();
        deal4();
        slow_clock_s = 1'b0;
        #2;
        slow_clock_s = 1'b1;
        #2;
        assert(load_dcard3_s === 1'b0 && load_pcard3_s === 1'b1) begin

        $display("[PASS], Game deals to player when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end else begin

        $error("[FAIL], Game does not deal to player when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end 
        slow_clock_s = 1'b0;
        #2;
        slow_clock_s = 1'b1;
        #2;
        assert(load_dcard3_s === 1'b1 && load_pcard3_s === 1'b0) begin

        $display("[PASS], Game deals to dealer when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end else begin

        $error("[FAIL], Game does not deal to dealer when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end 
    end

    #2
    dscore_s = 4;
    #2
    for(pcard3_s = 2; pcard3_s < 8; pcard3_s++) begin //checks proper cards dealt for every possibility when dscore = 4 && pcard 0->5
        reset();
        deal4();
        slow_clock_s = 1'b0;
        #2;
        slow_clock_s = 1'b1;
        #2;
        assert(load_dcard3_s === 1'b0 && load_pcard3_s === 1'b1) begin

        $display("[PASS], Game deals to player when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end else begin

        $error("[FAIL], Game does not deal to player when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end 
        slow_clock_s = 1'b0;
        #2;
        slow_clock_s = 1'b1;
        #2;
        assert(load_dcard3_s === 1'b1 && load_pcard3_s === 1'b0) begin

        $display("[PASS], Game deals to dealer when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end else begin

        $error("[FAIL], Game does not deal to dealer when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end 
    end

    #2
    dscore_s = 3;
    #2
    for(pcard3_s = 0; pcard3_s < 8; pcard3_s++) begin //checks proper cards dealt for every possibility when dscore = 3 && pcard 0->5
        reset();
        deal4();
        slow_clock_s = 1'b0;
        #2;
        slow_clock_s = 1'b1;
        #2
        assert(load_dcard3_s === 1'b0 && load_pcard3_s === 1'b1) begin

        $display("[PASS], Game deals to player when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end else begin

        $error("[FAIL], Game does not deal to player expected when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end 
        slow_clock_s = 1'b0;
        #2;
        slow_clock_s = 1'b1;
        #2;
        assert(load_dcard3_s === 1'b1 && load_pcard3_s === 1'b0) begin

        $display("[PASS], Game deals to dealer when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end else begin

        $error("[FAIL], Game does not deal to dealer when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end 
    end

    #2
    dscore_s = 2;
    #2
    for(pcard3_s = 0; pcard3_s < 10; pcard3_s++) begin //checks proper cards dealt for every possibility when dscore = 3 && pcard 0->5
        reset();
        deal4();
        slow_clock_s = 1'b0;
        #2;
        slow_clock_s = 1'b1;
        #2;
        assert(load_dcard3_s === 1'b0 && load_pcard3_s === 1'b1) begin

        $display("[PASS], Game deals to player when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end else begin

        $error("[FAIL], Game does not deal to player when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end
        slow_clock_s = 1'b0;
        #2;
        slow_clock_s = 1'b1;
        #2;
        assert(load_dcard3_s === 1'b1 && load_pcard3_s === 1'b0) begin

        $display("[PASS], Game deals to dealer when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end else begin

        $error("[FAIL], Game does not deal to dealer when pscore = %d and dscore = %d and pcard3 = %d", pscore_s, dscore_s, pcard3_s);

        end 
    end

end

    
    $display("\n------------------------------------------------------");
    $display("|BELOW ARE ALL THE TESTS FOR PLAYER SCORE BEING 6->7|");
    $display("------------------------------------------------------\n");

    for (pscore_s = 6; pscore_s < 8; pscore_s++) begin //checks all possibilities for pscore 6-7
    reset();
    deal4();
    slow_clock_s = 1'b0;
    #2;
    slow_clock_s = 1'b1;
    #2;

        for(dscore_s = 0; dscore_s < 6; dscore_s++) begin
        reset();
        deal4();
        slow_clock_s = 1'b0;
        #2;
        slow_clock_s = 1'b1;
        #2;
        assert(load_dcard3_s === 1'b1 && load_pcard3_s === 1'b0) begin

        $display("[PASS], Game deals a card to dealer when when pscore = %d and dscore = %d", pscore_s, dscore_s);

        end else begin

        $error("[FAIL], Game does not deal a card to dealer when pscore = %d and dscore = %d", pscore_s, dscore_s);

        end 
        end

        for(dscore_s = 6; dscore_s < 14; dscore_s++) begin
        reset();
        deal4();
        slow_clock_s = 1'b0;
        #2;
        slow_clock_s = 1'b1;
        #2;
        assert(load_dcard3_s === 1'b0 && load_pcard3_s === 1'b0) begin

        $display("[PASS], Game does not deal a card to dealer when pscore = %d and dscore = %d", pscore_s, dscore_s);

        end else begin

        $error("[FAIL], Game deals a card to dealer when pscore = %d and dscore = %d", pscore_s, dscore_s);

        end 
        end

    end

    $display("\n------------------------------------------------------");
    $display("|BELOW ARE ALL THE TESTS FOR FINAL SCORE COMPUTATION|");
    $display("------------------------------------------------------\n");

    for (pscore_s = 0; pscore_s < 10; pscore_s++) begin //checks all possibilities for pscore 6-7
        for(dscore_s = 0; dscore_s < 10; dscore_s++) begin
         reset();
         deal4();
         slow_clock_s = 1'b0;
         #1;
         slow_clock_s = 1'b1;
         #1;
         slow_clock_s = 1'b0;
         #1;
         slow_clock_s = 1'b1;
         #1;
         slow_clock_s = 1'b0;
         #1;
         slow_clock_s = 1'b1;
         #1;
        if (pscore_s > dscore_s) begin
            assert((player_win_light_s) === 1'b1 && (dealer_win_light_s === 1'b0))begin

            $display("[PASS], PLAYER WIN when final score is: pscore = %d and dscore = %d", pscore_s, dscore_s);

            end else begin

            $error("[FAIL], NOT A PLAYER WIN when final score is: pscore = %d and dscore = %d", pscore_s, dscore_s);

            end 
        end

        else if (pscore_s < dscore_s) begin
            assert((player_win_light_s === 1'b0) && (dealer_win_light_s === 1'b1)) begin

            $display("[PASS], DEALER WIN when final score is: pscore = %d and dscore = %d", pscore_s, dscore_s);

            end else begin

            $error("[FAIL], NOT A DEALER WIN when final score is: pscore = %d and dscore = %d", pscore_s, dscore_s);

            end 
        end

        else if (pscore_s === dscore_s) begin
            assert((player_win_light_s === 1'b1) && (dealer_win_light_s === 1'b1)) begin

            $display("[PASS], TIE when final score is: pscore = %d and dscore = %d", pscore_s, dscore_s);

            end else begin

            $error("[FAIL], NOT A TIE when final score is: pscore = %d and dscore = %d", pscore_s, dscore_s);

            end 
        end
                end
    end
end
endmodule

