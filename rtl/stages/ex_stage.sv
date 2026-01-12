import pipeline_pkg::idex_t;
import pipeline_pkg::exmem_t;

module ex_stage
    #( parameter XLEN = 32 ) (

        input logic [XLEN-1:0]  ResultW,
        input logic [XLEN-1:0]  ALUResultM,
        input logic [1:0]   ForwardAE,
        input logic [1:0]   ForwardBE,

        output logic        PCSrcE,
        output logic [XLEN-1:0] PCTargetE,

        input idex_t inputs,
        output exmem_t outputs,

        // outputs to hazard unit
        output logic [4:0]  Rs1E, Rs2E, RdE,
        output logic ResultSrcE_zero

);

    logic        branchTakenE;
    logic [XLEN-1:0] SrcAE, SrcBE;
    logic [XLEN-1:0] SrcAE_input1;

    assign PCSrcE = (inputs.Branch & branchTakenE) | inputs.Jump;

    // Forwarding A

    (* dont_touch = "true" *) mux3 #(.XLEN(XLEN)) SrcAE_input1mux(

        .d0 (inputs.RD1),
        .d1 (ResultW),
        .d2 (ALUResultM),
        .s  (ForwardAE),
        .y  (SrcAE_input1)

    );

    (* dont_touch = "true" *) mux2 #(.XLEN(XLEN)) SrcAEmux(

        .d0 (SrcAE_input1),
        .d1 (inputs.PC),
        .s  (inputs.SrcAsrc),
        .y  (SrcAE)

    );

    // Forwarding B

    (* dont_touch = "true" *) mux3 #(.XLEN(XLEN)) WriteDataEmux(

        .d0 (inputs.RD2),
        .d1 (ResultW),
        .d2 (ALUResultM),
        .s  (ForwardBE),
        .y  (outputs.WriteData)

    );

    (* dont_touch = "true" *) mux2 #(.XLEN(XLEN)) SrcBEmux(

        .d0 (outputs.WriteData),
        .d1 (inputs.ImmExt),
        .s  (inputs.ALUSrc),
        .y  (SrcBE)

    );

    (* dont_touch = "true" *) branch_unit #(.XLEN(XLEN)) branch_unit(

        .SrcAE          (SrcAE),
        .SrcBE          (outputs.WriteData),
        .funct3E        (inputs.funct3),
        .branchTakenE   (branchTakenE)

    );

    assign PCTargetE = ( inputs.jumpReg ? SrcAE : inputs.PC ) +
                        inputs.ImmExt;

    (* dont_touch = "true" *) alu #(.XLEN(XLEN)) ALU(

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
    assign RdE =  inputs.Rd;

    assign ResultSrcE_zero = inputs.ResultSrc[0];

endmodule