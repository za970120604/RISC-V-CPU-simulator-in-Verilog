`timescale 1ns/1ps

module Decoder(
    input [31:0] instr_i,
    output reg Branch,
    output reg RegWrite,
    output reg [1:0] ALUOp,
    output reg MemRead,
    output reg MemWrite,
    output reg [1:0] MemtoReg,
    output reg Jump
);

    wire [6:0] opcode ; 
    assign opcode = instr_i[6:0] ; 

    always@(*)begin
        case(opcode)
            7'b0110011: begin // Rtype
                Branch = 1'b0 ; 
                RegWrite = 1'b1 ; 
                ALUOp = 2'b10 ; 
                MemRead = 1'b0 ; 
                MemWrite = 1'b0 ; 
                MemtoReg = 2'b01 ; // choose alu result
                Jump = 1'b0 ; 
            end
            7'b0010011: begin // Itype
                Branch = 1'b0 ; 
                RegWrite = 1'b1 ; 
                ALUOp = 2'b00 ; 
                MemRead = 1'b0 ; 
                MemWrite = 1'b0 ; 
                MemtoReg = 2'b01 ; // choose alu result
                Jump = 1'b0 ;
            end
            7'b0000011: begin // Itype but load related
                Branch = 1'b0 ; 
                RegWrite = 1'b1 ; 
                ALUOp = 2'b00 ; 
                MemRead = 1'b1 ; 
                MemWrite = 1'b0 ; 
                MemtoReg = 2'b00 ; // choose memory result
                Jump = 1'b0 ;
            end
            7'b0100011: begin // Stype
                Branch = 1'b0 ; 
                RegWrite = 1'b0 ; 
                ALUOp = 2'b00 ; 
                MemRead = 1'b0 ; 
                MemWrite = 1'b1 ; 
                MemtoReg = 2'b00 ; // x (don't care)
                Jump = 1'b0 ;
            end
            7'b1100011: begin // Btype
                Branch = 1'b1 ; 
                RegWrite = 1'b0 ; 
                ALUOp = 2'b01 ; 
                MemRead = 1'b0 ; 
                MemWrite = 1'b0 ; 
                MemtoReg = 2'b00 ; // x
                Jump = 1'b0 ;
            end
            7'b1101111: begin // jal, Jtype
                Branch = 1'b0 ; 
                RegWrite = 1'b1 ; 
                ALUOp = 2'b11 ; 
                MemRead = 1'b0 ; 
                MemWrite = 1'b0 ; 
                MemtoReg = 2'b10 ; // choose pc+4 result
                Jump = 1'b1 ;
            end
            7'b1100111: begin // jalr, Itype
                Branch = 1'b0 ; 
                RegWrite = 1'b1 ; 
                ALUOp = 2'b00 ; 
                MemRead = 1'b0 ; 
                MemWrite = 1'b0 ; 
                MemtoReg = 2'b01 ; // choose alu result
                Jump = 1'b1 ;
            end
            default: begin // nop
                Branch = 1'b0 ; 
                RegWrite = 1'b0 ; 
                ALUOp = 2'b00 ; 
                MemRead = 1'b0 ; 
                MemWrite = 1'b0 ; 
                MemtoReg = 2'b00 ; // x
                Jump = 1'b0 ;
            end
        endcase
    end
endmodule