module tb_reg4();

reg [3:0] sim_new_card;
reg sim_resetb;
reg sim_load_card;
reg sim_slow_clock;
wire [3:0] sim_card_out;

reg4 DUT(
    .new_card(sim_new_card),
    .resetb(sim_resetb),
    .load_card(sim_load_card),
    .slow_clock(sim_slow_clock),
    .card_out(sim_card_out)
);


initial begin
//Load random value
sim_resetb = 1;
sim_load_card = 1;
sim_slow_clock = 0;
sim_new_card = 10;
clock();
assert(sim_card_out === 10) $display("[PASS] standard write");
    else $error("[FAIL] standard write failed");
//Try to load with enable off
sim_load_card = 0;
sim_new_card = 5;
clock();
assert(sim_card_out !== 5) $display("[PASS] register does not write when enable is 0");
    else $error("[FAIL] register fails write without enable");
//Reset test
sim_resetb = 0;
clock();
assert(sim_card_out === 0) $display("[PASS] register reset successful");
    else $error("[FAIL] register reset failed");



end


//Task clocks low,high,low
task clock; sim_slow_clock = 0; #5; sim_slow_clock = 1; #5; sim_slow_clock = 0; #5;  endtask

endmodule: tb_reg4