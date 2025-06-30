`timescale 1ns/1ps

module tb_moore_non_ol;

    reg clk;
    reg rst;
    reg in;
    wire detected;

    moore_non_ol uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .detected(detected)
    );

    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        in = 0;

        #10 rst = 1;

        #10 in = 1; // S1
        #10 in = 0; // S2
        #10 in = 1; // S3
        #10 in = 1; // S4 (detected)

        // Apply overlapping sequence: 1 0 1 1 (should not detect)
        #10 in = 1; // S1
        #10 in = 0; // S2
        #10 in = 1; // S3
        #10 in = 1; // should go to S4 but not detect (already reset)

        #10 in = 0;
        #10 in = 0;

        // Another sequence: 1 0 1 1 (should detect again)
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 1;

        #20 $finish;
    end

endmodule