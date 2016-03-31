/* Finds the 3's compliment of an N-digit ternary number */
module ternaryThreesCompliment#(parameter N = 1)(
    output [N * 2 - 1:0] out,
    input [N * 2 - 1:0] in
);
    wire [N * 2 - 1:0] twosComp;
    
    // Find the 2's compliment of the input
    ternaryTwosCompliment#(N)(twosComp, in);
    // Simply add 1 by setting cIn to 1 to get the three's compliment
    ternaryCarryLookAhead#(N)(out, /* NC */, /* NC */, twosComp, 0, 1);
endmodule
