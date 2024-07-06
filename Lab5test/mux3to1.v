`timescale 1ns/1ps

module Mux3to1(
    input [31:0] src0_i, // in risc-v architecture, instr is 32 bits, and immediate will be extended to 32 bits also, 
                        // and the address is fixed to 32 bits (assume code is tested on 32 bits system) to make the design logic simple
    input [31:0] src1_i,
    input [31:0] src2_i,
    input [1:0] sel,
    output reg [31:0] src_o
);

    always@(*)begin
        case(sel)
            2'b00: src_o = src0_i ; 
            2'b01: src_o = src1_i ; 
            2'b10: src_o = src2_i ; 
            default: src_o = src2_i ; 
        endcase
    end

endmodule