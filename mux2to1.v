/* An N-bit wide 2 to 1 multiplexer */
module mux2to1#(parameter N = 1)(
    output [N - 1:0] out, // Selected output
    input [N - 1:0] a, // Choice 0
    input [N - 1:0] b, // Choice 1
    input select // Selector bit
);
    assign out = select ? b : a;
endmodule
