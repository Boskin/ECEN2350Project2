module ternaryCarryLookAhead#(parameter N)(
    output [N * 2 - 1:0] s,
    output cOut,
    output overflow,
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
    
    assign overflow = c[N * 2] ^ c[N * 2 - 2];
    
    genvar i;
    genvar j;
    generate
        for(i = 0; i < N * 2; i = i + 2) begin: generateAndPropagate
            assign g[i] = a[i + 1] & b[i + 1] | a[i] & b[i + 1] | a[i + 1] & b[i];
            assign p[i] = a[i + 1] | b[i + 1] | a[i] & b[i];
        end
        
        for(i = 1; i < N * 2 - 1; i = i + 2) begin: remainingGenerateAndPropagate
            assign g[i] = 1;
            assign p[i] = 1;
        end
        
        for(i = 2; i <= N * 2; i = i + 2) begin: remainingCarryTerms
            for(j = 1; j < N * 2; j = j + 2) begin: otherRemaining
                assign carryTerms[i][j] = 0;
            end
        end
        
        for(i = 2; i <= N * 2; i = i + 2) begin: carryGenerate
            assign carryTerms[i][0] = cIn & (&p[i - 2:0]);
            assign carryTerms[i][i] = g[i - 2];
            for(j = 2; j < i; j = j + 2) begin: carryProductTermGenerate
                assign carryTerms[i][j] = g[j - 2] & (&p[i - 2:j]);
            end
            
            assign c[i] = |carryTerms[i][i:0];
        end
        
        for(i = 0; i < N * 2; i = i + 2) begin: sums
            // MSb of sum digit
            assign s[i + 1] = ~c[i] & a[i] & b[i] | c[i] & a[i + 1] & b[i + 1] |
                ~c[i] & a[i + 1] & ~b[i + 1] & ~b[i] | ~c[i] & ~a[i + 1] & ~a[i] & b[i + 1] |
                c[i] & a[i] & ~b[i + 1] & ~b[i] | c[i] & ~a[i + 1] & ~a[i] & b[i];
            
            // LSb of sum digit
            assign s[i] = ~c[i] & a[i + 1] & b[i + 1] | c[i] & a[i + 1] & b[i] |
                c[i] & a[i] & b[i + 1] | ~c[i] & ~a[i + 1] & ~a[i] & b[i] |
                ~c[i] & a[i] & ~b[i + 1] & ~b[i] | c[i] & ~a[i + 1] & ~a[i] & ~b[i + 1] & ~b[i];
        end
    endgenerate
endmodule
