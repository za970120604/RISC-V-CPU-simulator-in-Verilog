`timescale 1ns/1ps

module ProgramCounter(
    input clk_i,
    input rst_i,
    input IF_redo,
    input [31:0] pc_i,
    output reg [31:0] pc_o
);

    always @(posedge clk_i) begin
        if(~rst_i)begin
            pc_o <= 32'd0 ;
        end
        else if(IF_redo)begin
            pc_o <= pc_o ;
        end
        else begin
            pc_o <= pc_i ; 
        end
    end

endmodule