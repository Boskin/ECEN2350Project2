/* Module that finds the two's compliment of an N-digit ternary
   number */
module ternaryTwosCompliment#(parameter N = 1)(
    output [N * 2 - 1:0] out,
    input [N * 2 - 1:0] in
);
    genvar i;
    generate
        for(i = 0; i < 2 * N; i = i + 2) begin: complimentDigits
            assign out[i + 1] = ~in[i + 1] & ~in[i];
            assign out[i] = in[i];
        end
    endgenerate
endmodule
