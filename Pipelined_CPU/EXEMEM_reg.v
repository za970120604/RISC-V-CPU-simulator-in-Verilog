`timescale 1ns/1ps

module EXEMEM_register(
    input clk_i,
    input rst_i,
    input [31:0] instr_i, 
    input [1:0] MEM_ctrl_i, // MemRead & MemWrite
    input [3:0] WB_ctrl_i, // MemtoReg & RegWrite & Jump (for jal && jalr) ?
	input zero_i,
	input [31:0] alu_result_i,
    input [31:0] rt_data_i ;
	input [4:0] rd_index_i,
	input [31:0] pc_add4_i,

    output reg [31:0] instr_o, 
    output reg [1:0] MEM_ctrl_o,
    output reg [3:0] WB_ctrl_o, 
	output reg zero_o,
	output reg [31:0] alu_result_o,
    output reg [31:0] rt_data_o,
	output reg [4:0] rd_index_o,
	output reg [31:0] pc_add4_o,
);

    always@(posedge clk_i)begin
        if(~rst_i)begin
            instr_o <= 32'd0 ; 
            MEM_ctrl_o <= 2'd0 ; 
            WB_ctrl_o <= 4'd0 ; 
            zero_o <= 1'd0 ; 
            alu_result_o <= 32'd0 ;  
            rt_data_o <= 32'd0 ; 
            rd_index_o <= 5'd0 ; 
            pc_add4_o <= 32'd0 ;  
        end
        else begin
            instr_o <= instr_i ; 
            MEM_ctrl_o <= MEM_ctrl_i ; 
            WB_ctrl_o <= WB_ctrl_i ; 
            zero_o <= zero_i ; 
            alu_result_o <= alu_result_i ;  
            rt_data_o <= rt_data_i ;
            rd_index_o <= rd_index_i ;
            pc_add4_o <= pc_add4_i ;
        end
    end

endmodule