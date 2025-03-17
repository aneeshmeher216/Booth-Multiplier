`timescale 1ns / 1ps

module booth_tb;
    parameter N = 5;
     
    reg clk, rst, start;
    reg [N-1:0] M, Q;
    
    wire [2*N-1:0] result;
    
booth_multiplier #(N) dut (.clk(clk),   //passing parameter
                          .rst(rst), 
                          .start(start),
                          .M(M), 
                          .Q(Q),
                          .result(result));


always #5 clk = ~clk;

initial begin
         clk <= 0; rst <= 1'b1; start = 1'b0;
     #20 rst <= 1'b0; start <= 1'b1;
         M <= -5'd12;
         Q <= 5'd7;
         
     #100 $finish;
end  
endmodule
