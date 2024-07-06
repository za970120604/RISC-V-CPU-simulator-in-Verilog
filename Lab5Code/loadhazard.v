`timescale 1ns/1ps

module Load_Hazard_Detection(
    input [4:0] IFID_rs1,
    input [4:0] IFID_rs2,
    input [4:0] IDEXE_rd,
    input IDEXE_MemRead,
    output reg IF_redo,
    output reg ID_redo,
    output reg EXE_flush
);

    always@(*)begin
        if(IDEXE_MemRead && ((IFID_rs1 == IDEXE_rd) || (IFID_rs2 == IDEXE_rd)))begin
            IF_redo = 1'b1 ;
            ID_redo = 1'b1 ;  
            EXE_flush = 1'b1 ; 
        end
        else begin
            IF_redo = 1'b0 ;
            ID_redo = 1'b0 ; 
            EXE_flush = 1'b0 ; 
        end
    end

endmodule