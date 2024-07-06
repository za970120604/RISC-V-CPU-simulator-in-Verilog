`timescale 1ns/1ps

module MEMWB_register (
    input clk_i,
    input rst_i,
    input [2:0] WB_ctrl_i, 
    input [31:0] DM_i,
    input [31:0] alu_result_i,
    input [4:0] rd_index_i,
    input [31:0] pc_add4_i,

    output reg [2:0] WB_ctrl_o,
    output reg [31:0] DM_o,
    output reg [31:0] alu_result_o,
    output reg [4:0] rd_index_o,
    output reg [31:0] pc_add4_o
);
    
    always@(posedge clk_i) begin
        if(~rst_i) begin
            WB_ctrl_o <= 3'd0 ;
            DM_o <= 32'd0 ;
            alu_result_o <= 32'd0 ;
            rd_index_o <= 5'd0 ;
            pc_add4_o <= 32'd0 ;
        end
        else begin
            WB_ctrl_o <= WB_ctrl_i ;
            DM_o <= DM_i ;
            alu_result_o <= alu_result_i ;
            rd_index_o <= rd_index_i ;
            pc_add4_o <= pc_add4_i ;   
        end
    end
    
endmodule
