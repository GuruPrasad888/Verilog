`timescale 1ns/1ps

// Moore machine to detect the sequence '1011' with 1 bit overlap
module moore_overlap (
    input clk,
    input rst,
    input in,
    output reg detected
);

    parameter S0 = 3'b000, // Start
              S1 = 3'b001, // 1
              S2 = 3'b010, // 10
              S3 = 3'b011, // 101
              S4 = 3'b100; // 1011 (detection)

    reg [2:0] current_state, next_state;

    always @(posedge clk or negedge rst) begin
        if (~rst)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Combinational: Next state logic
    always @(*) begin
        case (current_state)
            S0: next_state = (in == 1) ? S1 : S0;
            S1: next_state = (in == 0) ? S2 : S1;
            S2: next_state = (in == 1) ? S3 : S0;
            S3: next_state = (in == 1) ? S4 : S2;
            S4: next_state = (in == 1) ? S1 : S2; // 1-bit overlap
            default: next_state = S0;
        endcase
    end

    always @(posedge clk or negedge rst) begin
        if (~rst)
            detected <= 1'b0;
        else if (current_state == S4)
            detected <= 1'b1;
        else
            detected <= 1'b0;
    end

endmodule
