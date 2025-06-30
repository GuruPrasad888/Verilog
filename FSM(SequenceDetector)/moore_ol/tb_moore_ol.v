`timescale 1ns/1ps

module tb_moore_overlap;

    reg clk, rst, in;
    wire detected;

    moore_overlap uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .detected(detected)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;
        in = 0;
        #10

        rst = 1;

        // Input: 1011011 — detects twice with 1-bit overlap
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 1; // Detected: 1011

        #10 in = 0;
        #10 in = 1;
        #10 in = 1; // Detected again: 1011

        #20 $finish;
    end

endmodule
