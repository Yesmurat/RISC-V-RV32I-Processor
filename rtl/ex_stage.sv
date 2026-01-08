module ex_stage (

        input logic [31:0]  ResultW,
        input logic [31:0]  ALUResultM,
        input logic [1:0]   ForwardAE,
        input logic [1:0]   ForwardBE,

        output logic        PCSrcE,
        output logic [31:0] PCTargetE,


        idex_if.rd inputs,
        exmem_if.wr outputs

);

    logic        branchTakenE;
    logic [31:0] SrcAE, SrcBE;
    logic [31:0] SrcAE_input1;

    assign PCSrcE = (inputs.ctrl.Branch & branchTakenE) | inputs.ctrl.Jump;

    // Forwarding A

    mux3 SrcAE_input1mux(

        .d0 (inputs.data.RD1),
        .d1 (ResultW),
        .d2 (ALUResultM),
        .s  (ForwardAE),
        .y  (SrcAE_input1)

    );

    mux2 SrcAEmux(

        .d0 (SrcAE_input1),
        .d1 (inputs.data.PC),
        .s  (inputs.ctrl.SrcAsrc),
        .y  (SrcAE)

    );

    // Forwarding B

    mux3 WriteDataEmux(

        .d0 (inputs.data.RD2),
        .d1 (ResultW),
        .d2 (ALUResultM),
        .s  (ForwardBE),
        .y  (outputs.data.WriteData)

    );

    mux2 SrcBEmux(

        .d0 (outputs.data.WriteData),
        .d1 (inputs.data.ImmExt),
        .s  (inputs.ctrl.ALUSrc),
        .y  (SrcBE)

    );

    branch_unit branch_unit(

        .SrcAE          (SrcAE),
        .SrcBE          (outputs.data.WriteData),
        .funct3E        (inputs.ctrl.funct3),
        .branchTakenE   (branchTakenE)

    );

    assign PCTargetE = ( inputs.ctrl.jumpReg ? SrcAE : inputs.data.PC ) +
                        inputs.data.ImmExt;

    alu ALU(

        .d0 (SrcAE),
        .d1 (SrcBE),
        .s  (inputs.ctrl.ALUControl),
        .y  (outputs.data.ALUResult)

    );

    assign outputs.ctrl.RegWrite = inputs.ctrl.RegWrite;
    assign outputs.ctrl.ResultSrc = inputs.ctrl.ResultSrc;
    assign outputs.ctrl.MemWrite = inputs.ctrl.MemWrite;
    assign outputs.ctrl.funct3 = inputs.ctrl.funct3;

    assign outputs.data.PCPlus4 = inputs.data.PCPlus4;
    assign outputs.data.Rd = inputs.data.Rd;
    assign outputs.data.ImmExt = inputs.data.ImmExt;

endmodule