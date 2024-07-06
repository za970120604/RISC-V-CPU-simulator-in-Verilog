`timescale 1ns/1ps

module IDEXE_register(
    input clk_i,
    input rst_i,
    input [31:0] instr_i, 
    input [1:0] EXE_ctrl_i, // 2 bit ALU op 
    input [1:0] MEM_ctrl_i, // MemRead & MemWrite
    input [3:0] WB_ctrl_i, // MemtoReg[1:0] & RegWrite & Jump (for jal && jalr) ? 
    input [31:0] rs_data_i,
    input [31:0] rt_data_i,
    input [31:0] pc_add4_i,
    input [31:0] immediate_i,
    input [4:0] rs_index_i,
    input [4:0] rt_index_i,
    input [4:0] rd_index_i,

    output reg [31:0] instr_o, 
    output reg [1:0] EXE_ctrl_o,
    output reg [1:0] MEM_ctrl_o,
    output reg [3:0] WB_ctrl_o, 
    output reg [31:0] rs_data_o,
    output reg [31:0] rt_data_o,
    output reg [31:0] pc_add4_o,
    output reg [31:0] immediate_o,
    output reg [4:0] rs_index_o,
    output reg [4:0] rt_index_o,
    output reg [4:0] rd_index_o
);

    always@(posedge clk_i)begin
        if(~rst_i)begin
            instr_o <= 32'd0 ; 
            EXE_ctrl_o <= 2'd0 ; 
            MEM_ctrl_o <= 2'd0 ; 
            WB_ctrl_o <= 4'd0 ; 
            rs_data_o <= 32'd0 ; 
            rt_data_o <= 32'd0 ; 
            pc_add4_o <= 32'd0 ; 
            immediate_o <= 32'd0 ; 
            rs_index_o <= 5'd0 ; 
            rt_index_o <= 5'd0 ; 
            rd_index_o <= 5'd0 ; 
        end
        else begin
            instr_o <= instr_i ; 
            EXE_ctrl_o <= EXE_ctrl_i ; 
            MEM_ctrl_o <= MEM_ctrl_i ; 
            WB_ctrl_o <= WB_ctrl_i ; 
            rs_data_o <= rs_data_i ; 
            rt_data_o <= rt_data_i ; 
            pc_add4_o <= pc_add4_i ; 
            immediate_o <= immediate_i ; 
            rs_index_o <= rs_index_i ; 
            rt_index_o <= rt_index_i ; 
            rd_index_o <= rd_index_i ;
        end
    end

endmodule