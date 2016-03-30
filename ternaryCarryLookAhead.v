/* Ternary adder that uses the carry look ahead approach */
module ternaryCarryLookAhead#(parameter N)(
    output [N * 2 - 1:0] s, // Sum
    output cOut, // Carry out
    output overflow, // Overflow indicator
    input [N * 2 - 1:0] a, // Opperand 1 (a + b)
    input [N * 2 - 1:0] b, // Opperand 2
    input cIn // Carry in
);
    // All of these signals have extra terms to make the indexing easier
    // All carry signals
    wire [N * 2:0] c;
    // Generate and propagate
    wire [N * 2 - 2:0] g;
    wire [N * 2 - 2:0] p;
    
    /* SOP terms for each carry, like the carry signals,
       some are unused and are simply made to make indexing easier */
    wire [N * 2:0] carryTerms [N * 2:2];
    
    // Store the given input and output carries in the carry vector
    assign c[0] = cIn;
    assign cOut = c[N * 2];
    
    /* Indicate whether arithmetic overflow occurred by XORing the
       last 2 carries */
    assign overflow = c[N * 2] ^ c[N * 2 - 2];
    
    // Loop iterators
    genvar i;
    genvar j;
    generate
        // Connect the generate and propagate signals
        for(i = 0; i < N * 2; i = i + 2) begin: generateAndPropagate
            assign g[i] = a[i + 1] & b[i + 1] | a[i] & b[i + 1] | a[i + 1] & b[i];
            assign p[i] = a[i + 1] | b[i + 1] | a[i] & b[i];
        end
        
        /* Left over generate and propagate signals should be set to 1 
           since all of these signals will be ANDed together and a 1
           will not affect the result */
        for(i = 1; i < N * 2 - 1; i = i + 2) begin: remainingGenerateAndPropagate
            assign g[i] = 1;
            assign p[i] = 1;
        end
        
        /* Left over SOP carry terms should be set to 0 since SOP carry terms
           will be ORed together and 0 will not affect the result */
        for(i = 2; i <= N * 2; i = i + 2) begin: remainingCarryTerms
            for(j = 1; j < N * 2; j = j + 2) begin: otherRemaining
                assign carryTerms[i][j] = 0;
            end
        end
        
        /* Calculate each carry by determining and ORing together all of the
           necessary carry terms */
        for(i = 2; i <= N * 2; i = i + 2) begin: carryGenerate
            assign carryTerms[i][0] = cIn & (&p[i - 2:0]);
            assign carryTerms[i][i] = g[i - 2];
            for(j = 2; j < i; j = j + 2) begin: carryProductTermGenerate
                assign carryTerms[i][j] = g[j - 2] & (&p[i - 2:j]);
            end
            
            // OR all of the SOP terms together to produce the carry
            assign c[i] = |carryTerms[i][i:0];
        end
        
        // Compute each sum using the opperands and the carries
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
