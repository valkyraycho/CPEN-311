module tb_task5();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 100,000 ticks (equivalent to "initial #100000 $finish();").

reg sim_CLOCK_50;
reg [3:0] sim_KEY;
wire [9:0] sim_LEDR;
wire [6:0] sim_HEX0, sim_HEX1, sim_HEX2, sim_HEX3, sim_HEX4, sim_HEX5;


task5 DUT(
    .CLOCK_50(sim_CLOCK_50),
    .KEY(sim_KEY),
    .LEDR(sim_LEDR),
    .HEX0(sim_HEX0),
    .HEX1(sim_HEX1),
    .HEX2(sim_HEX2),
    .HEX3(sim_HEX3),
    .HEX4(sim_HEX4),
    .HEX5(sim_HEX5)
);


initial begin   
//Test Natural win for player, deal 3 and 5 to player, assert light is illuminated
reset();
clock50(); //2
clock50(); //3
clockslow(); //Deal to player (3)
clockslow(); //Deal to dealer (3)

//Check that both cards were dealt correctly and appear on the HEX displays

assert(sim_HEX0 === 7'b0110000) begin 
    $display("[PASS] HEX0 displays 3 after player is dealt card 1");
end else begin
       
        $error("[FAIL] HEX0 display is not 3");
    end

assert(sim_HEX3 === 7'b0110000) begin 
    $display("[PASS] HEX3 displays 3 after dealer is dealt card 1");
end else begin
       
        $error("[FAIL] HEX3 display is not 3");
    end


clock50(); //4
clock50(); //5
clockslow(); //Deal card 2 to player

assert(sim_HEX1 === 7'b0010010) begin 
    $display("[PASS] HEX1 displays 5 after player is dealt card 2");
end else begin
       
        $error("[FAIL] HEX1 display is not 5");
    end


clock50(); //6
clock50(); //7

clockslow(); //Deal card 2 to dealer

assert(sim_HEX4 === 7'b1111000) begin 
    $display("[PASS] HEX4 displays 7 after dealer is dealt card 2");
end else begin
       
        $error("[FAIL] HEX4 display is not 7");
    end



assert(sim_LEDR[3:0] === 8) begin //Assert the LEDs show the right score for player
    $display("[PASS] Player score is 8 for cards 3 and 5");
end else begin
       
        $error("[FAIL] Player score is not 8");
    end


assert(sim_LEDR[7:4] === 0) begin //Assert the LEDs show the right score for player
    $display("[PASS] Dealer score is 0 for cards 3 and 7");
end else begin
       
        $error("[FAIL] Dealer score is not 0");
    end    

clockslow();


assert(sim_LEDR[8] === 1 && sim_LEDR[9] === 0) begin //Assert player light is on and dealer light is off
    $display("[PASS] Player has won and dealer has lost");
end else begin
       
        $error("[FAIL] Win lights are not asserted properly");
    end  

end

task clock50; sim_CLOCK_50 = 0; #5; sim_CLOCK_50 = 1; #5; sim_CLOCK_50 = 0; #5;  endtask
task clockslow; sim_KEY[0] = 0; #5; sim_KEY[0] = 1; #5; sim_KEY[0] = 0; #5;  endtask
task reset; sim_KEY[3] = 0; clockslow(); clock50(); sim_KEY[3] = 1; endtask
endmodule



