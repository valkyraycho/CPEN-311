module tb_card7seg();
// 10,000 ticks (equivalent to "initial #10000 $finish();").

reg [6:0] sim_HEX0;
reg [3:0] sim_SW;

card7seg DUT (
.SW(sim_SW),
.HEX0(sim_HEX0)
);

initial begin //Success case

sim_SW = 4'b0000;
#5
assert(sim_HEX0 === 7'b1111111) begin

$display("[PASS], No input is displayed correctly");

end else begin

$error("[FAIL], No input is not displayed correctly");

end
#5
sim_SW = 4'b0001;
#5
assert(sim_HEX0 === 7'b0001000) begin

$display("[PASS], ACE is displayed when expected");

end else begin

$error("[FAIL], ACE is not displayed when expected");

end

#5
sim_SW = 4'b0010;
#5
assert(sim_HEX0 === 7'b0100100) begin

$display("[PASS], TWO is displayed when expected");

end else begin

$error("[FAIL], TWO is not displayed when expected");

end

#5
sim_SW = 4'b0011;
#5
assert(sim_HEX0 === 7'b0110000) begin

$display("[PASS], THREE is not displayed when expected");

end else begin

$error("[FAIL], THREE is displayed when expected");

end

#5
sim_SW = 4'b0100;
#5
assert(sim_HEX0 === 7'b0011001) begin

$display("[PASS], FOUR is displayed when expected");

end else begin

$error("[FAIL], FOUR is not displayed when expected");

end

#5
sim_SW = 4'b0101;
#5
assert(sim_HEX0 === 7'b0010010) begin

$display("[PASS], FIVE is displayed when expected");

end else begin

$error("[FAIL], FIVE is not displayed when expected");

end

#5
sim_SW = 4'b0110;
#5
assert(sim_HEX0 === 7'b0000010) begin

$display("[PASS], SIX is displayed when expected");

end else begin

$error("[FAIL], SIX is not displayed when expected");

end

#5
sim_SW = 4'b0111;
#5
assert(sim_HEX0 === 7'b1111000) begin

$display("[PASS], SEVEN is displayed when expected");

end else begin

$error("[FAIL], SEVEN is not displayed when expected");

end

#5
sim_SW = 4'b1000;
#5
assert(sim_HEX0 === 7'b0000000) begin

$display("[PASS], EIGHT is displayed when expected");

end else begin

$error("[FAIL], EIGHT is not displayed when expected");

end

#5
sim_SW = 4'b1001;
#5
assert(sim_HEX0 === 7'b0010000) begin

$display("[PASS], NINE is displayed when expected");

end else begin

$error("[FAIL], NINE is not displayed when expected");

end

#5
sim_SW = 4'b1010;
#5
assert(sim_HEX0 === 7'b1000000) begin

$display("[PASS], ZERO is displayed when 10 is entered");

end else begin

$error("[FAIL], ZERO is not displayed when 10 is entered");

end

#5
sim_SW = 4'b1011;
#5
assert(sim_HEX0 === 7'b1100001) begin

$display("[PASS], JACK is displayed when expected");

end else begin

$error("[FAIL], JACK is not displayed when expected");

end

#5
sim_SW = 4'b1100;
#5
assert(sim_HEX0 === 7'b0011000) begin

$display("[PASS], QUEEN is displayed when expected");

end else begin

$error("[FAIL], QUEEN is not displayed when expected");

end

#5
sim_SW = 4'b1101;
#5
assert(sim_HEX0 === 7'b0001001) begin

$display("[PASS], KING is displayed when expected");

end else begin

$error("[FAIL], KING is not displayed when expected");

end

#5
sim_SW = 4'b1110;
#5
assert(sim_HEX0 === 7'b1111111) begin

$display("[PASS], Nothing is displayed when 1110 is entered");

end else begin

$error("[FAIL], Something is displayed when 1110 is entered");

end

#5
sim_SW = 4'b1111;
#5
assert(sim_HEX0 === 7'b1111111) begin

$display("[PASS], Nothing is displayed when 1111 is entered");

end else begin

$error("[FAIL], Something is displayed when 1111 is entered");

end

end
endmodule

