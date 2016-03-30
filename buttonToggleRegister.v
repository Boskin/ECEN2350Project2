/* One bit register that is toggled on button press, module includes
   button debounce */
module buttonToggleRegister(
    output reg q, // Value of the register
    input btn, // Button input
    input clk // Clock signal
);
    // Debounced button signal, will be active high
    wire debouncedSignal;
    
    // Delay registers to help debounce the button
    reg delay0;
    reg delay1;
    reg delay2;
    
    // The register will initially store 0
    initial begin
        q = 0;
    end
    
    // Use non-blocking assignment see if the button is pressed for long enough
    always@(posedge clk) begin
        delay0 <= ~btn; // Invert btn since the buttons are active low
        delay1 <= delay0;
        delay2 <= delay1;
    end
    
    /* If all three delay signals are high, then assume the button is 
       being held down and not bouncing */
    assign debouncedSignal = delay0 & delay1 & delay2;
    
    // Toggle the value in the register on rising edge
    always@(posedge debouncedSignal) begin
        q <= ~q;
    end
endmodule
