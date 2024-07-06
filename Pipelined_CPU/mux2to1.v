`timescale 1ns/1ps

module Mux2to1(
    input [31:0] src0_i, // in risc-v architecture, instr is 32 bits, and immediate will be extended to 32 bits also, 
                        // and the address is fixed to 32 bits (assume code is tested on 32 bits system) to make the design logic simple
    input [31:0] src1_i,
    input  sel,
    output [31:0] src_o
);

    always@(*)begin
        src_o = (sel == 1'b0) ? src0_i : src1_i ; 
    end

endmodule
