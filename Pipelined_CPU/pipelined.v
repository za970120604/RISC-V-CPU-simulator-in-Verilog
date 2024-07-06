`timescale 1ns/1ps

module Pipeline_CPU(
    clk_i,
    rst_i
);

input clk_i ;
input rst_i ;

// IF

wire [31:0] PC_Add4 ; 
wire [31:0] Branch_Target ; 
wire is_control_hazard ;
wire [31:0] Mux_to_PC ;  

Mux2to1 leftmost_mux( // choose between PC+4 and branch target
    .src0_i(PC_Add4),
    .src1_i(Branch_Target),
    .sel(is_control_hazard), // if it is a branch/jump in ID in current cycle, we need to go to Target Address in IF at the next cycle
    .src_o(Mux_to_PC)
);

wire is_not_IF_redo ; 
wire [31:0] PC_to_InstrMem ; 

ProgramCounter PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .IF_redo(~is_not_IF_redo), // for the load-use hazard, we need to redo IF, ID stage on the next cycle when load is in currently in EXE stage
    .pc_i(Mux_to_PC),
    .pc_o(PC_to_InstrMem)
);

Adder Adder_PC_Add4(
    .src0_i(PC_to_InstrMem),
    .src1_i(32'd4),
    .adder_result(PC_Add4)
);

wire [31:0] instr_to_IFID_register ; 

Instr_Memory Instr_Mem(
    .addr_i(PC_to_InstrMem),
    .instr_o(instr_to_IFID_register)
);

// IFID registers

wire is_not_ID_redo ;
wire [31:0] PC_to_ID ; 
wire [31:0] instr_to_ID ; 
wire [31:0] PC_add4_to_ID ; 

IFID_register IFID_reg(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .branch_flush(is_control_hazard),
    .ID_redo(~is_not_ID_redo),
    .pc_i(PC_to_InstrMem),
    .instr_i(instr_to_IFID_register),
    .pc_add4_i(PC_Add4), // for jal
    .pc_o(PC_to_ID),
    .instr_o(instr_to_ID),
    .pc_add4_o(PC_add4_to_ID) // for jal
);

// ID

wire is_Branch_decode ; 
wire is_RegWrite_decode ; 
wire [1:0] ALUOp_decode ; 
wire is_MemRead_decode ; 
wire is_MemWrite_decode ; 
wire [1:0] MemtoReg_decode ; 
wire is_Jump_decode ; 

Decoder Decoder_(
    .instr_i(instr_to_ID),
    .Branch(is_Branch_decode),
    .RegWrite(is_RegWrite_decode),
    .ALUOp(ALUOp_decode),
    .MemRead(is_MemRead_decode),
    .MemWrite(is_MemWrite_decode),
    .MemtoReg(MemtoReg_decode),
    .Jump(is_Jump_decode)
);

wire [31:0] instr_to_EXE ; // belongs to IDEXE register output 
wire is_not_IF_redo ; 
wire is_EXE_flush ; 

Load_Hazard_Detection Load_Hazard(
    .IFID_rs1(instr_to_ID[19:15]),
    .IFID_rs2(instr_to_ID[24:20]),
    .IDEXE_rd(instr_to_EXE[11:7]),
    .IDEXE_MemRead(EXE_ctrl_to_EXE[1]),
    .IF_redo(~is_not_IF_redo),
    .ID_redo(~is_not_ID_redo),
    .EXE_flush(is_EXE_flush)
);

Control_Hazard_Detection Control_Hazard(
    .IFID_rs1(rs_data_regfile),
    .IFID_rs2(rt_data_regfile),
    .Branch(is_Branch_decode),
    .Jump(is_Jump_decode),
    .flush(is_control_hazard)
);

wire [7:0] ctrl_to_EXEMEMWB_from_mux ; 

Mux2to1_Ctrl ctrl_nop_mux(
    .src0_i({is_RegWrite_decode, // 1'b // ctrl lines order is the same as the one in decoder
            ALUOp_decode, // 2'b
            is_MemRead_decode, // 1'b
            is_MemWrite_decode, // 1'b
            MemtoReg_decode, // 2'b
            is_Jump_decode // 1'b
            }),
    .src1_i(8'd0),
    .sel(is_EXE_flush),
    .src_o(ctrl_to_EXEMEMWB_from_mux)
); 

wire [31:0] imm_o ;
wire [31:0] imm_slt1_o ; 

ImmGen ImmGenerator(
    .instr_i(instr_to_ID),
    .immediate_o(imm_o)
);

ShiftLeft1 SLT1(
    .data_i(imm_o),
    .shift_left_1_data_o(imm_slt1_o)
);

Adder Adder_Target_Address(
    .src0_i(imm_slt1_o),
    .src1_i(PC_to_ID),
    .adder_result(Branch_Target)
);

wire [31:0] rs_data_regfile ; 
wire [31:0] rt_data_regfile ; 

Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .rs_index(instr_to_ID[19:15]),
    .rt_index(instr_to_ID[24:20]),
    .rd_index(rd_index_to_WB),
    .wb_data(WB_to_Regfile), // need to modify
    .RegWrite_i(WB_ctrl_to_WB[3]),
    .rs_data(rs_data_regfile),
    .rt_data(rt_data_regfile)
);


wire [31:0] rs_data_to_EXE ; 
wire [31:0] rt_data_to_EXE ; 
wire [31:0] PC_add4_to_EXE ;
wire [1:0] EXE_ctrl_to_EXE ; 
wire [1:0] MEM_ctrl_to_EXE ;
wire [3:0] WB_ctrl_to_EXE ; 
wire [31:0] imm_to_EXE ;
wire [4:0] rs_index_to_EXE ; 
wire [4:0] rt_index_to_EXE ;
wire [4:0] rd_index_to_EXE ; 

// IDEXE registers

IDEXE_register IDEXE_reg(
    .clk_i.(clk_i),
    .rst_i(rst_i),
    .instr_i(instr_to_ID), 
    .EXE_ctrl_i(ctrl_to_EXEMEMWB_from_mux[6:5]), // 2 bit ALU op 
    .MEM_ctrl_i(ctrl_to_EXEMEMWB_from_mux[4:3]), // MemRead & MemWrite
    .WB_ctrl_i({ctrl_to_EXEMEMWB_from_mux[7], ctrl_to_EXEMEMWB_from_mux[2:0]}), // RegWrite & MemtoReg[1:0] & Jump (for jal && jalr) ? 
    .rs_data_i(rs_data_regfile),
    .rt_data_i(rt_data_regfile),
    .pc_add4_i(PC_add4_to_ID),
    .immediate_i(imm_o),
    .rs_index_i(instr_to_ID[19:15]),
    .rt_index_i(instr_to_ID[24:20]),
    .rd_index_i(instr_to_ID[11:7]),

    .instr_o(instr_to_EXE), 
    .EXE_ctrl_o(EXE_ctrl_to_EXE),
    .MEM_ctrl_o(MEM_ctrl_to_EXE),
    .WB_ctrl_o(WB_ctrl_to_EXE), 
    .rs_data_o(rs_data_to_EXE),
    .rt_data_o(rt_data_to_EXE),
    .pc_add4_o(PC_add4_to_EXE),
    .immediate_o(imm_to_EXE),
    .rs_index_o(rs_index_to_EXE),
    .rt_index_o(rt_index_to_EXE),
    .rd_index_o(rd_index_to_EXE),
);

// EXE

wire [1:0] ForwardA_ctrl,
wire [1:0] ForwardB_ctrl

ForwardingUnit FWD_Unit(
    .IDEXE_rs1(rs_index_to_EXE),
    .IDEXE_rs2(rt_index_to_EXE),
    .EXEMEM_rd(instr_to_MEM[11:7]),
    .MEMWB_rd(rd_index_to_WB),
    .EXEMEM_RegWrite(WB_ctrl_to_MEM[3]),
    .MEMWB_RegWrite(WB_ctrl_to_WB[3]),
    .ForwardA(ForwardA_ctrl),
    .ForwardB(ForwardB_ctrl)
);

wire [31:0] ALUSrc0_final ; 
wire [31:0] ALUSrc1_not_final ; 
wire [31:0] ALUSrc1_final ; 

Mux3to1 ALUSrc0(
    .src0_i(rs_data_to_EXE),
    .src1_i(WB_to_Regfile),
    .src2_i(ALU_result_to_MEM),
    .sel(ForwardA_ctrl),
    .src_o(ALUSrc0_final)
);

Mux3to1 ALUSrc1_no_imm(
    .src0_i(rt_data_to_EXE),
    .src1_i(WB_to_Regfile),
    .src2_i(ALU_result_to_MEM),
    .sel(ForwardB_ctrl),
    .src_o(ALUSrc1_not_final)
);

wire instr_to_EXE_is_Itype ; 
assign instr_to_EXE_is_Itype = (instr_to_EXE[6:0] == 7'b0010011 || instr_to_EXE[6:0] == 7'b0000011 || instr_to_EXE[6:0] == 7'b1100111) ; 

Mux2to1 HandleItype_Mux(
    .src0_i(ALUSrc1_not_final),
    .src1_i(imm_to_EXE),
    .sel(instr_to_EXE_is_Itype),
    .src_o(ALUSrc1_final)
);

wire [3:0] alu_ctrl_line;

ALU_Ctrl ALU_Ctrl_Unit(
    .ALUop(EXE_ctrl_to_EXE),
    .funct3(instr_to_EXE[14:12]),
    .funct7(instr_to_EXE[31:25]),
    .opcode(instr_to_EXE[6:0]),
    .alu_ctrl(alu_ctrl_line)
);

wire [31:0] ALU_result ;
wire ALU_result_is_zero ; 

ALU ALU_(
    .src0_i(ALUSrc0_final),
    .src1_i(ALUSrc1_final),
    .alu_ctrl(alu_ctrl_line),
    .alu_result(ALU_result),
    .zero(ALU_result_is_zero)
);

// EXEMEM registers

wire [31:0] instr_to_MEM ;  
wire [1:0] MEM_ctrl_to_MEM ; 
wire [3:0] WB_ctrl_to_MEM ;
wire is_zero_to_MEM ;  
wire [31:0] ALU_result_to_MEM ;
wire [31:0] rt_data_to_MEM ; 
wire [4:0] rd_index_to_MEM ;  
wire [31:0] PC_add4_to_MEM ; 

EXEMEM_register EXEMEM_reg(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .instr_i(instr_to_EXE), 
    .MEM_ctrl_i(MEM_ctrl_to_EXE), // MemRead & MemWrite
    .WB_ctrl_i(WB_ctrl_to_EXE), // RegWrite & MemtoReg[1:0] & Jump (for jal && jalr)
	.zero_i(ALU_result_is_zero),
	.alu_result_i(ALU_result),
    .rt_data_i(rt_data_to_EXE),
	.rd_index_i(rd_index_to_EXE),
	.pc_add4_i(PC_add4_to_EXE),

    .instr_o(instr_to_MEM), 
    .MEM_ctrl_o(MEM_ctrl_to_MEM),
    .WB_ctrl_o(WB_ctrl_to_MEM), 
	.zero_o(is_zero_to_MEM),
	.alu_result_o(ALU_result_to_MEM),
    .rt_data_o(rt_data_to_MEM),
	.rd_index_o(rd_index_to_MEM),
	.pc_add4_o(PC_add4_to_MEM),
);

// MEM

wire [31:0] Memory_Content_From_DM ; 

Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(ALU_result_to_MEM)
    .data_i(rt_data_to_MEM),
    .MemRead_i(MEM_ctrl_to_MEM[1]),
    .MemWrite_i(MEM_ctrl_to_MEM[0]),
    .data_o(Memory_Content_From_DM) ; 
);

// MEMWB registers

wire [3:0] WB_ctrl_to_WB ; 
wire [31:0] Memory_Content_to_WB ; 
wire [31:0] ALU_result_to_WB ; 
wire [4:0] rd_index_to_WB ; 
wire [31:0] PC_add4_to_WB ; 

MEMWB_register MEMWB_reg(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .WB_ctrl_i(WB_ctrl_to_MEM), 
    .DM_i(Memory_Content_From_DM),
    .alu_result_i(ALU_result_to_MEM),
    .rd_index_i(rd_index_to_MEM),
    .pc_add4_i(PC_add4_to_MEM),

    .WB_ctrl_o(WB_ctrl_to_WB),
    .DM_o(Memory_Content_to_WB),
    .alu_result_o(ALU_result_to_WB),
    .rd_index_o(rd_index_to_WB),
    .pc_add4_o(PC_add4_to_WB)
);

// WB
wire [31:0] WB_to_Regfile ;  

Mux3to1 WriteBack_Data_Choose(
    .src0_i(Memory_Content_to_WB),
    .src1_i(ALU_result_to_WB),
    .src2_i(PC_add4_to_WB),
    .sel(WB_ctrl_to_WB[2:1]),
    .src_o(WB_to_Regfile)
); 

endmodule