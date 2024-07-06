`timescale 1ns/1ps

module ImmGen(
    input [31:0] instr_i,
    output [31:0] immediate_o,
);
    wire [6:0] opcode ; 
    wire [2:0] funct3 ; 
    assign opcode = instr[6:0] ; 
    assign funct3 = instr[14:12] ; 
    always@(*)begin
        if(opcode == 7'b0010011 || opcode == 7'b0000011 || (opcode == 7'b1100111 && funct3 == 3'h0))begin 
            // I-type, including jalr & lw, but how about slli that only use imm[0:4] ?? ; 
            immediate_o = {{20{instr_i[31]}} , instr_i[31 : 20]} ; 
        end
        else if(opcode == 7'b0100011)begin // S-type
            immediate_o = {{20{instr_i[31]}} , instr_i[31 : 25] , instr_i[11 : 7]} ;
        end
        else if(opcode == 7'b1100011)begin // B-type
            immediate_o = {1'b0 , {19{instr_i[31]}} , instr_i[31] , instr_i[7] , instr_i[30 : 25] , instr_i[11 : 8]} ; //19 sign + 12 original + 1.0(by def) 
        end
        else if(opcode == 7'b1101111)begin // J-type
            immediate_o = {1'b0 , {11{instr_i[31]}} , instr_i[31] , instr_i[19 : 12] , instr_i[20] , instr_i[30 : 21]} ; //11 sign + 20 original + 1.0(by def)} ; 
        end
        else begin
            immediate_o = 32'd0 ; 
        end
    end
endmodule