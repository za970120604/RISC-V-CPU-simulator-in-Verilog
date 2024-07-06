`timescale 1ns/1ps

module ShiftLeft1(
    input [31:0] data_i,
    output reg [31:0] shift_left_1_data_o
);
    always@(*)begin
        shift_left_1_data_o = data_i << 1 ; 
    end
    
endmodule