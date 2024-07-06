`timescale 1ns/1ps

module ForwardingUnit (
    input [4:0] IDEXE_rs1,
    input [4:0] IDEXE_rs2,
    input [4:0] EXEMEM_rd,
    input [4:0] MEMWB_rd,
    input EXEMEM_RegWrite,
    input MEMWB_RegWrite,
    output [1:0] ForwardA,
    output [1:0] ForwardB
)

    always@(*)begin
        if((EXEMEM_RegWrite) && (EXEMEM_rd != 5'b0) && (EXEMEM_rd == IDEXE_rs1))begin
            ForwardA = 2'b10 ; 
        end
        else if((MEMWB_RegWrite) && (MEMWB_rd != 5'b0) && (MEMWB_rd == IDEXE_rs1))begin
            ForwardA = 2'b01 ; 
        end
        else begin
            ForwardA = 2'b00 ; 
        end

        if((EXEMEM_RegWrite) && (EXEMEM_rd != 5'b0) && (EXEMEM_rd == IDEXE_rs2))begin
            ForwardB = 2'b10 ; 
        end
        else if((MEMWB_RegWrite) && (MEMWB_rd != 5'b0) && (MEMWB_rd == IDEXE_rs2))begin
            ForwardB = 2'b01 ; 
        end
        else begin
            ForwardB = 2'b00 ; 
        end
    end

endmodule

