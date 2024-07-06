`timescale 1ns/1ps

module Control_Hazard_Detection(
    input [4:0] IFID_rs1,
    input [4:0] IFID_rs2,
    input Branch,
    input Jump,
    output wire flush
);

    assign flush = ((Branch&&(IFID_rs1 == IFID_rs2)) || Jump) ;
     
endmodule