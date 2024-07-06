`timescale 1ns/1ps

module Reg_File(
    input                clk_i,
    input                rst_i,
    input       [5-1:0]  rs_index,
    input       [5-1:0]  rt_index,
    input       [5-1:0]  rd_index,
    input       [32-1:0] wb_data,
    input                RegWrite_i,
    output wire [32-1:0] rs_data,
    output wire [32-1:0] rt_data
);

reg signed [32-1:0] Reg_File [0:32-1];

assign rs_data = Reg_File[rs_index] ;
assign rt_data = Reg_File[rt_index] ;

always @(negedge clk_i) begin
    if(~rst_i) begin
        Reg_File[0]  <= 0; Reg_File[1]  <= 0; Reg_File[2]  <= 0; Reg_File[3]  <= 0;
        Reg_File[4]  <= 0; Reg_File[5]  <= 0; Reg_File[6]  <= 0; Reg_File[7]  <= 0;
        Reg_File[8]  <= 0; Reg_File[9]  <= 0; Reg_File[10] <= 0; Reg_File[11] <= 0;
        Reg_File[12] <= 0; Reg_File[13] <= 0; Reg_File[14] <= 0; Reg_File[15] <= 0;
        Reg_File[16] <= 0; Reg_File[17] <= 0; Reg_File[18] <= 0; Reg_File[19] <= 0;
        Reg_File[20] <= 0; Reg_File[21] <= 0; Reg_File[22] <= 0; Reg_File[23] <= 0;
        Reg_File[24] <= 0; Reg_File[25] <= 0; Reg_File[26] <= 0; Reg_File[27] <= 0;
        Reg_File[28] <= 0; Reg_File[29] <= 0; Reg_File[30] <= 0; Reg_File[31] <= 0;
    end
    else begin
        if(RegWrite_i)
            Reg_File[rd_index] <= wb_data;
        else
            Reg_File[rd_index] <= Reg_File[rd_index];
    end
end

endmodule