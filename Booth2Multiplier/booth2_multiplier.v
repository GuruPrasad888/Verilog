`timescale 1ns/1ps

module booth2multiplier #(
    parameter bit_width = 16
    )(
    input wire [bit_width-1:0] A,   // Multiplicand
    input wire [bit_width-1:0] B,   // Multiplier
    input wire clk, reset_n,
    output wire [2*bit_width-1:0] OUT
);
reg [bit_width:0] extended_multiplier;
reg [bit_width:0] extended_multiplicand;
reg [bit_width:0] neg_multiplicand;
reg [bit_width:0] PP;
reg [bit_width+3:0] sign_extended_PP;
reg [2:0] recoded_bits;
reg [2*bit_width-1:0] ff_out;
reg [2*bit_width-1:0] product;
integer i;

always @(posedge clk) begin
    if(~reset_n) begin
        ff_out <= {2*bit_width{1'b0}};
    end else begin
        ff_out <= product;
    end 
end

assign OUT = ff_out;

always @(*) begin
    extended_multiplier = {B, 1'b0};    // Extend Multiplier by appending 0 at  LSB
    extended_multiplicand = {A[bit_width-1], A};    // Extend Multiplicand at MSB by replicating currect MSB
    neg_multiplicand = ~extended_multiplicand +1;   // 2's Complement
    product = 0;

    for (i=0; i<(bit_width/2); i=i+1) begin
        recoded_bits = extended_multiplier[2:0];    // Calulate the recoded digits
        PP = 0;
        sign_extended_PP = 0;
        case (recoded_bits)
            3'b000, 3'b111:PP = 0;
            3'b001, 3'b010:PP = extended_multiplicand;
            3'b011:PP = {A, 1'b0};
            3'b100:PP = {~A+1, 1'b0};
            3'b101, 3'b110:PP = neg_multiplicand;
        endcase
        if (i == 0) begin
            sign_extended_PP = {~PP[bit_width], PP[bit_width], PP[bit_width], PP};  // Sign extension for firsr Partial Product
        end else if (i == (bit_width/2)-1) begin
            sign_extended_PP = {2'b0, ~PP[bit_width], PP};  // Sign extension for last Partial Product
        end else begin
            sign_extended_PP = {1'b0, 1'b1, ~PP[bit_width], PP};    // Sign extension for other Partial Products
        end
        product = product + (sign_extended_PP << (2*i));    // Left shift Partial Product twice since 2 bits are taken at once
        extended_multiplier = extended_multiplier  >>> 2;   // Arithmetic right shift the multiplier after every iteration
    end
end
endmodule