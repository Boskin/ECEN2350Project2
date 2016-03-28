module ternaryCarryLookAhead#(parameter N)(
    output [N * 2 - 1:0] s,
    output cOut,
    input [N * 2 - 1:0] a,
    input [N * 2 - 1:0] b,
    input cIn
);
    wire [N * 2:0] c;
    wire [N * 2 - 2:0] g;
    wire [N * 2 - 2:0] p;
    
    wire [N * 2:0] carryTerms [N * 2:2];
    
    assign c[0] = cIn;
    assign cOut = c[N * 2];
    
    genvar i;
    genvar j;
    generate
        for(i = 0; i < N * 2; i = i + 2) begin: generateAndPropagate
            assign g[i] = a[i + 1] & b[i + 1] | a[i] & b[i + 1] | a[i + 1] & b[0];
            assign p[i] = a[i + 1] | b[i + 1] | a[i] & b[i];
        end
        
        for(i = 1; i < N * 2 - 1; i = i + 2) begin: remainingGenerateAndPropagate
            assign g[i] = 1;
            assign p[i] = 1;
            assign carryTerms[i] = 1;
        end
        assign carryTerms[N * 2 - 1] = 1;
        
        for(i = 2; i <= N * 2; i = i + 2) begin: carries
            assign carryTerms[i][2] = c[0] & (&p[i - 2:0]);
            assign carryTerms[i][N * 2] = g[i - 2];
            for(j = i - 2; j >= 4; j = j - 2) begin: carryTerms
                assign carryTerms[i][j] = g[j - 2] & (&p[N * 2 - 2:j]);
            end
            assign c[i] = &carryTerms[i];
        end
        
        for(i = 0; i < N * 2; i = i + 2) begin: sums
            // MSb of sum digit
            assign s[i + 1] = ~c[i] & a[i] & b[i] | c[i] & a[i + 1] & b[i + 1] |
                ~c[i] & a[i + 1] & ~b[i + 1] & ~b[i] | ~c[i] & ~a[i + 1] & ~a[i] & b[i + 1] |
                c[i] & a[i] & ~b[i + 1] & ~b[i] | c[i] & ~a[i + 1] & ~a[i] & b[0];
            
            // LSb of sum digit
            assign s[i] = ~c[i] & a[i + 1] & b[i + 1] | c[i] & a[i + 1] & b[i] |
                c[i] & a[i] & b[i + 1] | ~c[i] & ~a[i + 1] & ~a[i] & b[i] |
                ~c[i] & a[i] & ~b[i + 1] & ~b[i] | c[i] & ~a[i + 1] & ~a[i] & ~b[i + 1] & ~b[i];
        end
    endgenerate
endmodule
