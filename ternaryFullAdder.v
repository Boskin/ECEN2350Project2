/* Single full adder module for one ternary digit,
   each digit must be represented with 2 bits and
   binary 11 represents an invalid "don't care" case 
   for any ternary digit, carries are still represented
   with single bits */
module ternaryFullAdder(
    output [1:0] s,
    output cOut,
    input [1:0] a,
    input [1:0] b,
    input cIn
);
    // MSb of sum digit
    assign s[1] = ~cin & x[0] & y[0] | cIn & x[1] & y[1] |
        ~cIn & x[1] & ~y[1] & ~y[0] | ~cIn & ~x[1] & ~x[0] & y[1] |
        cIn & x[0] & ~y[1] & ~y[0] | cIn & ~x[1] & ~x[0] & y[0];
    
    // LSb of sum digit
    assign s[0] = ~cIn & x[1] & y[1] | cIn & x[1] & y[0] |
        cIn & x[0] & y[1] | ~cIn & ~x[1] & ~x[0] & y[0] |
        ~cIn & x[0] & ~y[1] & ~y[0] | cIn & ~x[1] & ~x[0] & ~y[1] & ~y[0];
    
    // Carry out
    assign cOut = x[1] & y[1] | x[0] & y[0] | 
        cIn & x[1] | cIn & y[1] | cIn & x[0] & y[0];
endmodule
