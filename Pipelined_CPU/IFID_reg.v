`timescale 1ns/1ps

module IFID_register(
    input clk_i,
    input rst_i,
    input branch_flush,
    input ID_redo,
    input [31:0] pc_i,
    input [31:0] instr_i,
    input [31:0] pc_add4_i, // for jal
    
    output reg [31:0] pc_o,
    output reg [31:0] instr_o,
    output reg [31:0] pc_add4_o // for jal
);

    always@(posedge clk)begin
        if(~rst_i)begin
            pc_o <= 32'd0 ; 
            instr_o <= 32'd0 ; 
            pc_add4_o <= 32'd0 ; 
        end
        else if(branch_flush)begin
            pc_o <= 32'd0 ;
            instr_o <= 32'd0 ; 
            pc_add4_o <= 32'd0 ; 
        end
        else if(ID_redo)begin
            pc_o <= pc_o ;
            instr_o <= instr_o ; 
            pc_add4_o <= pc_add4_o ;
        end
        else begin
            pc_o <= pc_i ;
            instr_o <= instr_i ; 
            pc_add4_o <= pc_add4_i ;
        end
    end

endmodule