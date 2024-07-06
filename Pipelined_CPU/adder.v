`timescale 1ns/1ps

module Adder(
    input [31:0] src0_i,
    input [31:0] src1_i,
    output [31:0] adder_result
); 

    assign adder_result = src0_i + src1_i ; 

endmodule