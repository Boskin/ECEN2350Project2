module buttonToggleRegister(
    output reg q,
    input btn,
    input clk
);
    wire debouncedSignal;
    
    reg delay0;
    reg delay1;
    reg delay2;
    
    initial begin
        q = 0;
    end
    
    always@(posedge clk) begin
        delay0 <= ~btn; // Invert btn since the buttons are active low
        delay1 <= delay0;
        delay2 <= delay1;
    end
    
    assign debouncedSignal = delay0 & delay1 & delay2;
    
    always@(posedge debouncedSignal) begin
        q <= ~q; // Toggle register
    end
endmodule
