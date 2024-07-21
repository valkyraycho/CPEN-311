module tb_datapath();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").
reg error;
reg sim_slow_clock;
reg sim_fast_clock;
reg sim_resetb;
reg sim_load_pcard1;
reg sim_load_pcard2;
reg sim_load_pcard3;
reg sim_load_dcard1;
reg sim_load_dcard2;
reg sim_load_dcard3;
wire [3:0] sim_pcard3_out;
wire [3:0] sim_pscore_out;
wire [3:0] sim_dscore_out;
wire [6:0] sim_HEX5;
wire [6:0] sim_HEX4;
wire [6:0] sim_HEX3;
wire [6:0] sim_HEX2;
wire [6:0] sim_HEX1;
wire [6:0] sim_HEX0;

datapath DUT(
    .slow_clock(sim_slow_clock),
    .fast_clock(sim_fast_clock),
    .resetb(sim_resetb),
    .load_pcard1(sim_load_pcard1),
    .load_pcard2(sim_load_pcard2),
    .load_pcard3(sim_load_pcard3),
    .load_dcard1(sim_load_dcard1),
    .load_dcard2(sim_load_dcard2),
    .load_dcard3(sim_load_dcard3),
    .pcard3_out(sim_pcard3_out),
    .pscore_out(sim_pscore_out),
    .dscore_out(sim_dscore_out),
    .HEX5(sim_HEX5),
    .HEX4(sim_HEX4),
    .HEX3(sim_HEX3),
    .HEX2(sim_HEX2),
    .HEX1(sim_HEX1),
    .HEX0(sim_HEX0)
);

initial begin
   // initialize
sim_load_pcard1 = 1;
sim_load_pcard2 = 0;
sim_load_pcard3 = 0;
sim_load_dcard1 = 0;
sim_load_dcard2 = 0;
sim_load_dcard3 = 0;
error = 0;
//Reset
sim_resetb = 0;
clockfast();
clockslow();
sim_resetb = 1;
clockslow();
//Load 1 into PCard1 and check HEX0 for 1
assert(sim_HEX0 === 7'b0001000) begin
    $display("[PASS] HEX0 displays 1 after loading into PCard1 successfully");
end else begin
        error = 1;
        $error("[FAIL] HEX0 display is not 1");

    end

sim_load_pcard1 = 0;
sim_load_pcard2 = 0;
//Load 5 into PCard, then check HEX1 for 5 and pscore for 6
clockfast();
clockfast();
clockfast();
clockfast();
sim_load_pcard2 = 1;
clockslow();

assert(sim_HEX1 === 7'b0010010) begin
    $display("[PASS] HEX1 displays 5 after loading into PCard2 successfully");
end else begin
            error = 1;
        $error("[FAIL] HEX1 display is not 5");
    end

assert(sim_pscore_out === 6) begin
    $display("[PASS] pscore displays 6 successfuly");
end else begin  
        error = 1;
        $error("[FAIL] pscore does not display 6");
    end

//Add a King to PCard3 and ensure the score has not changed
clockfast();
clockfast();
clockfast();
clockfast();
clockfast();
clockfast();
clockfast();
clockfast();
sim_load_pcard2 = 0;
sim_load_pcard3 = 1;
#10;
clockslow();

assert(sim_HEX2 === 7'b0001001) begin 
    $display("[PASS] HEX2 displays king after loading into PCard3 successfully");
end else begin
        error = 1;
        $error("[FAIL] HEX2 display is not king");
    end

assert(sim_pscore_out === 6) begin
    $display("[PASS] pscore displays 6 successfuly");
end else begin
        error = 1;
        $error("[FAIL] pscore does not display 6");
    end

   
//Do the same for DCards
sim_resetb = 0;
sim_load_pcard3 = 0;
clockslow();
clockfast(); //1
sim_resetb = 1;
//Deal 2 to DCard1, 8 to DCard2, 7 to DCard3 to test scorehand overflow, result should be 7 on dscore
sim_load_dcard1 = 1;
clockfast(); //2
clockslow();
sim_load_dcard1 = 0;
sim_load_dcard2 = 1;
clockfast(); //3
clockfast(); //4
clockfast(); //5
clockfast(); //6
clockfast(); //7
clockfast(); //8
clockslow();
sim_load_dcard2 = 0;
sim_load_dcard3 = 1;
clockfast(); //9
clockfast(); //10
clockfast(); //11
clockfast(); //12
clockfast(); //13
clockfast(); //1
clockfast(); //2
clockfast(); //3
clockfast(); //4
clockfast(); //5
clockfast(); //6
clockfast(); //7
clockslow();
	

assert(sim_HEX3 === 7'b0100100) begin 
    $display("[PASS] HEX3 displays 2 after loading into DCard1 successfully");
end else begin
        error = 1;
        $error("[FAIL] HEX3 display is not 2");
    end

assert(sim_HEX4 === 7'b0000000) begin 
    $display("[PASS] HEX4 displays 8 after loading into DCard2 successfully");
end else begin
        error = 1;
        $error("[FAIL] HEX4 display is not 8");
    end

assert(sim_HEX5 === 7'b1111000) begin 
    $display("[PASS] HEX5 displays 7 after loading into DCard3 successfully");
end else begin
        error = 1;
        $error("[FAIL] HEX5 display is not 7");
    end





assert(sim_dscore_out === 7) begin
    $display("[PASS] dscore displays 7 successfuly");
end else begin
        error = 1;
        $error("[FAIL] dscore does not display 7");
    end

//Reset all and ensure all is 0
sim_resetb = 0;
clockfast();
clockslow();

assert(sim_pscore_out === 0) begin
    $display("[PASS] pscore 0 after reset");
end else begin
        error = 1;
        $error("[FAIL] pscore not 0 after reset");
    end

assert(sim_dscore_out === 0) begin
    $display("[PASS] dscore 0 after reset");
end else begin
        error = 1;
        $error("[FAIL] dscore not 0 after reset");
    end


assert(sim_HEX0 === 7'b1111111) begin 
    $display("[PASS] HEX0 displays nothing after reset");
end else begin
        error = 1;
        $error("[FAIL] HEX0 displays something after reset");
    end

assert(sim_HEX1 === 7'b1111111) begin 
    $display("[PASS] HEX1 displays nothing after reset");
end else begin
        error = 1;
        $error("[FAIL] HEX1 displays something after reset");
    end


assert(sim_HEX2 === 7'b1111111) begin 
    $display("[PASS] HEX2 displays nothing after reset");
end else begin
        error = 1;
        $error("[FAIL] HEX2 displays something after reset");
    end

assert(sim_HEX3 === 7'b1111111) begin 
    $display("[PASS] HEX3 displays nothing after reset");
end else begin
        error = 1;
       $error("[FAIL] HEX3 displays something after reset");
    end

assert(sim_HEX4 === 7'b1111111) begin 
    $display("[PASS] HEX4 displays nothing after reset");
end else begin
        error = 1;
        $error("[FAIL] HEX4 displays something after reset");
    end

assert(sim_HEX5 === 7'b1111111) begin 
    $display("[PASS] HEX5 displays nothing after reset");
end else begin
        error = 1;
        $error("[FAIL] HEX5 displays something after reset");
    end






assert(error === 0) begin
    $display("[MODULE PASS] All tests passed with 0 errors");
end else begin
    $error("[MODULE FAIL] 1 or more tests failed");
end







end  

//Task clocks low,high,low
task clockslow; sim_slow_clock = 0; #5; sim_slow_clock = 1; #5; sim_slow_clock = 0; #5;  endtask
task clockfast; sim_fast_clock = 0; #5; sim_fast_clock = 1; #5; sim_fast_clock = 0; #5;  endtask
endmodule

