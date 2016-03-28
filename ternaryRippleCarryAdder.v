/* Ternary ripple carry adder that operates on N-ternary digit
   numbers */
module ternaryRippleCarryAdder#(parameter N = 1)(
    output [N * 2 - 1:0] sum,
    output cOut,
    input [N * 2 - 1:0] a,
    input [N * 2 - 1:0] b,
    input cIn
);
    /* Carry signals, note: half of the indices are not used, 
       this index scheme is used to make the code easier to read
       since unused signals won't be synthesized */
    wire [N * 2:0] c;
    
    /* All carry operations will be on the vector declared above,
       so connect input and output signals to the according indices
       of the vector */
    assign c[0] = cIn;
    assign cOut = c[N * 2];
    
    genvar i;
    generate
        // Chain the full adders with their carry signals
        for(i = 0; i < N * 2; i = i + 1) begin: fullAdders
            ternaryFullAdder(
                sum[i + 1:i],
                c[i + 2],
                a[i + 1:i],
                b[i + 1:i],
                c[i]
            );
        end
    endgenerate
endmodule
