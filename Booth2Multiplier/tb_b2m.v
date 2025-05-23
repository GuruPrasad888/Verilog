`timescale 1ns/1ps

module tb_b2m;
reg [15:0] A;
reg [15:0] B;
reg clk, reset_n;
wire [31:0] OUT;

booth2multiplier DUT(.A(A), .B(B), .OUT(OUT), .clk(clk), .reset_n(reset_n));

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset_n = 0;
    A = 16'd345;
    B = 16'd123;
    #10;
    reset_n = 1;
    #10;
    A = 16'd789;
    B = 16'd987;
    #10;
    A = 16'd32245;
    B = 16'd32235;
    #10;
    A = 16'd31978;
    B = 16'd23961;
    #20;
    $finish;
end
endmodule