import pipeline_pkg::idex_t;
import pipeline_pkg::exmem_t;

module ex_stage (

        input logic [31:0]  ResultW,
        input logic [31:0]  ALUResultM,
        input logic [1:0]   ForwardAE,
        input logic [1:0]   ForwardBE,

        output logic        PCSrcE,
        output logic [31:0] PCTargetE,

        output logic [4:0]  Rs1E, Rs2E,

        input ifid_t inputs,
        output exmem_t outputs

);

    logic        branchTakenE;
    logic [31:0] SrcAE, SrcBE;
    logic [31:0] SrcAE_input1;

    assign PCSrcE = (inputs.Branch & branchTakenE) | inputs.Jump;

    // Forwarding A

    mux3 SrcAE_input1mux(

        .d0 (inputs.RD1),
        .d1 (ResultW),
        .d2 (ALUResultM),
        .s  (ForwardAE),
        .y  (SrcAE_input1)

    );

    mux2 SrcAEmux(

        .d0 (SrcAE_input1),
        .d1 (inputs.PC),
        .s  (inputs.SrcAsrc),
        .y  (SrcAE)

    );

    // Forwarding B

    mux3 WriteDataEmux(

        .d0 (inputs.RD2),
        .d1 (ResultW),
        .d2 (ALUResultM),
        .s  (ForwardBE),
        .y  (outputs.WriteData)

    );

    mux2 SrcBEmux(

        .d0 (outputs.WriteData),
        .d1 (inputs.ImmExt),
        .s  (inputs.ALUSrc),
        .y  (SrcBE)

    );

    branch_unit branch_unit(

        .SrcAE          (SrcAE),
        .SrcBE          (outputs.WriteData),
        .funct3E        (inputs.funct3),
        .branchTakenE   (branchTakenE)

    );

    assign PCTargetE = ( inputs.jumpReg ? SrcAE : inputs.PC ) +
                        inputs.ImmExt;

    alu ALU(

        .d0 (SrcAE),
        .d1 (SrcBE),
        .s  (inputs.ALUControl),
        .y  (outputs.ALUResult)

    );

    assign outputs.RegWrite = inputs.RegWrite;
    assign outputs.ResultSrc = inputs.ResultSrc;
    assign outputs.MemWrite = inputs.MemWrite;
    assign outputs.funct3 = inputs.funct3;

    assign outputs.PCPlus4 = inputs.PCPlus4;
    assign outputs.Rd = inputs.Rd;
    assign outputs.ImmExt = inputs.ImmExt;

    assign Rs1E = inputs.Rs1;
    assign Rs2E = inputs.Rs2;

endmodule