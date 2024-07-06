`timescale 1ns/1ps

module ShiftLeft1(
    input [31:0] data_i,
    output [31:0] shift_left_1_data_o,
);

    assign shift_left_1_data_o = data_i << 1 ; 
    
endmodule