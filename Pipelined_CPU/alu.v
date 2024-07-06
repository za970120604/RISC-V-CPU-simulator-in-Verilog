`timescale 1ns/1ps

module ALU(
    input signed [31:0] src0_i,
    input signed [31:0] src1_i,
    input [3:0] alu_ctrl,
    output signed [31:0] alu_result,
    output wire zero
);

    assign zero = ~(|alu_result) ; 
    always@(*)begin
        case(alu_ctrl)
            4'b0111: alu_result = src0_i & src1_i ; // src0 bitwise and src1
            4'b0001: alu_result = src0_i | src1_i ; // src0 bitwise or src1
            4'b0010: alu_result = src0_i + src1_i ; // src0 add src1
            4'b0011: alu_result = src0_i - src1_i ; // src0 substract src1
            4'b0100: begin // src0 < src1 or not
                if(src0_i < src1_i)begin
                    alu_result = {{31{1'b0}} , 1'b1} ;
                end
                else begin
                    alu_result = {{31{1'b0}} , 1'b0} ;
                end
            end
            4'b0101: alu_result = src0_i ^ src1_i ; // src0 bitwise xor src1
            4'b0110: alu_result = src0_i << src1_i ; // src0 shift left src1 bits, it's logical shift but not arithmetic shift
            default: alu_result = src1_i ; 
        endcase
    end

endmodule