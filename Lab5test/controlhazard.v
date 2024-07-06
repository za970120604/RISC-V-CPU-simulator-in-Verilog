`timescale 1ns/1ps

module Control_Hazard_Detection(
    input [31:0] IFID_rs1_data,
    input [31:0] IFID_rs2_data,
    input Branch,
    input Jump,
    output reg flush
);
    always@(*)begin
        flush = ((Branch&&(IFID_rs1_data == IFID_rs2_data)) || Jump) ;
    end
     
endmodule