module mux2to1#(parameter N = 1)(
    output [N - 1:0] out,
    input [N - 1:0] a,
    input [N - 1:0] b,
    input select
);
    assign out = select ? b : a;
endmodule
