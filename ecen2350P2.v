/* Top module of this project, displays the result of an arithmetic
   addition/subtraction of 2 signed ternary numbers, ternary numbers
   are entered in sign-and-magnitude form, outputs the result, the
   carry-out, overflow indication, and an indicator that the two
   different adder circuits computed the same result, note: there is
   an adder toggle button that toggles which adder's result is displayed
   in case the results are not equal */
module ecen2350P2(
    output [20:0] sumDisp,
    output cOut,
    output overflow,
    output sumsEqual,
    input [3:0] a,
    input [3:0] b,
    input aSign,
    input bSign,
    input adderButton,
    input opButton,
    input clk
);
    // Actual inputs to adders translated
    wire [5:0] aActual;
    wire [5:0] bActual;
    
    // Negative 3's compliment of a
    wire [5:0] aNeg;
    // 2's compliment of b
    wire [5:0] bComp;
    
    // Selected sum
    wire [5:0] sum;
    
    // Ripple carry results
    wire [5:0] rippleCarrySum;  
    wire rippleCarryCout;
    wire rippleCarryOverflow;
    
    // Carry lookahead results
    wire [5:0] carryLookAheadSum;
    wire carryLookAheadCout;
    wire carryLookAheadOverflow;
    
    // These connect to registers that store the current options
    wire adderSelect;
    wire opSelect;
    
    // Will be used to complete 3's compliments for opperand b if necessary
    wire carryIn;
    
    // Use the three's compliment of a if a is indicated to be negative
    ternaryThreesCompliment#(3)(aNeg, {2'b00, a});
    mux2to1#(6)(aActual, {2'b00, a}, aNeg, aSign);
    
    /* Compute the carryIn based on what the operation is and the sign of b,
       if b is negative and subtraction is selected, just perform a + b,
       if one or the other is selected, then perform a - b,
       if neither is selected, again, perform a + b */
    xor(carryIn, opSelect, bSign);
    // Compute the 2's compliment
    ternaryTwosCompliment#(3)(bComp, {2'b00, b});
    // Select the 2's compliment if necessary
    mux2to1#(6)(bActual, {2'b00, b}, bComp, carryIn);
    
    // Set up the toggle registers for the user to configure what is outputted
    buttonToggleRegister tog0(adderSelect, adderButton, clk);
    buttonToggleRegister tog1(opSelect, opButton, clk);
    
    // Compute results with the different adders
    ternaryRippleCarryAdder#(3) add0(rippleCarrySum, rippleCarryCout, 
        rippleCarryOverflow, aActual, bActual, carryIn);
    ternaryCarryLookAhead#(3) add1(carryLookAheadSum, carryLookAheadCout, 
        carryLookAheadOverflow, aActual, bActual, carryIn);
    
    // Check if the adder results are equal, if not, there is a problem
    assign sumsEqual = 
        rippleCarrySum == carryLookAheadSum && 
        rippleCarryCout == carryLookAheadCout &&
        rippleCarryOverflow == carryLookAheadOverflow;
    
    // Choose the result to be displayed from the selected adder
    mux2to1#(6) mux1(sum, rippleCarrySum, carryLookAheadSum, adderSelect);
    mux2to1#(1) mux2(cOut, rippleCarryCout, carryLookAheadCout, adderSelect);
    mux2to1#(1) mux3(overflow, rippleCarryOverflow, carryLookAheadOverflow, adderSelect);
    
    // Display the three-digit result
    hexDisplayDecoder disp0(sumDisp[6:0], sum[1:0]); // Least significant
    hexDisplayDecoder disp1(sumDisp[13:7], sum[3:2]);
    hexDisplayDecoder disp2(sumDisp[20:14], sum[5:4]); // Most significant (sign digit)
endmodule
