module tb_scorehand();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").

// Score of hand = (Value1 + Value2 + Value3) mod 10
// Each Ace, 2, 3, 4, 5, 6, 7, 8, and 9 has a value equal to the face value
// Tens, Jacks(11), Queens(12), and Kings(13) have a value of 0
reg [3:0] sim_card1;
reg [3:0] sim_card2;
reg [3:0] sim_card3;
wire [3:0] sim_total;

scorehand DUT (
    .card1(sim_card1),
    .card2(sim_card2),
    .card3(sim_card3),
    .total(sim_total)
);

// Variable declarations
integer c1;
integer c2;
integer c3;
integer total;
integer fail;


initial begin 
fail = 0;

    for(c3 = 0; c3<16; c3=c3+1)
    begin
        for(c2 = 0; c2<16; c2=c2+1)
        begin
            for(c1 = 0; c1<16; c1=c1+1)
            begin
                sim_card1 = c1;
                sim_card2 = c2;
                sim_card3 = c3;

                if(sim_card1>9)
                sim_card1 = 0;
                if(sim_card2>9)
                sim_card2 = 0;
                if(sim_card3>9)
                sim_card3 = 0;
               // #1;
                total = sim_total;
                #1;
                if((sim_card1+sim_card2+sim_card3)%10 === sim_total)
                $display ("[PASS], %0d + %0d + %0d = %0d", c1,c2,c3,total);
                else 
                begin
                $display ("[FAIL], %0d + %0d + %0d != %0d", c1,c2,c3,total);
                fail = 1;
                end
            
            end
        end
    end

if(fail === 1)
$display ("[MODULE FAIL] 1 or more tests failed");
else 
$display ("[MODULE PASS] all tests passed successfully");


end

endmodule

