`timescale 1ns/1ps

module ALU_Ctrl(
    input [1:0] ALUop,
    input [2:0] funct3,
    input [6:0] funct7,
    input [6:0] opcode,
    output [3:0] alu_ctrl
); 

    wire [3:0] alu_ctrl_default ; 
    assign alu_ctrl_default = 4'b0000 ; 
    always@(*)begin
        case(ALUop) 
            2'b00: begin // Itype, Stype, NOP
                case(opcode): 
                    7'b0010011: begin
                        case(funct3): 
                            3'h0: alu_ctrl = 4'b0010 ; // addi
                            3'h1: alu_ctrl = 4'b0110 ; // slli
                            3'h2: alu_ctrl = 4'b0100 ; // slti
                            default: alu_ctrl = alu_ctrl_default ; 
                        endcase
                    end
                    7'b0000011: alu_ctrl = 4'b0010 ; // lw
                    7'b1100111: alu_ctrl = 4'b0010 ; // jalr
                    7'b0100011: alu_ctrl = 4'b0010 ; // sw
                    default: alu_ctrl = alu_ctrl_default ;
                endcase
            end
            2'b01: begin // Btype
                alu_ctrl = 4'b0011 ; // beq
            end
            2'b10: begin // Rtype
                case(funct3): 
                    3'h0: begin
                        case(funct7): 
                            7'h00: alu_ctrl = 4'b0010 ; // add
                            7'h20: alu_ctrl = 4'b0011 ; // sub
                            default: alu_ctrl = alu_ctrl_default ; 
                        endcase
                    end
                    3'h4: alu_ctrl = 4'b0101 ; // xor
                    3'h6: alu_ctrl = 4'b0001 ; // or
                    3'h7: alu_ctrl = 4'b0111 ; // and
                    3'h2: alu_ctrl = 4'b0100 ; // slt
                    default: alu_ctrl = alu_ctrl_default ;
                endcase
            end
            2'b11: begin // Jtype
                alu_ctrl = 4'b0010 ; // jal
            end
        endcase
    end

endmodule