module EX_stage (
    
        input logic         clk,
        input logic         reset,

        // control IO
        input logic         RegWriteD,
        input logic [1:0]   ResultSrcD,
        input logic         MemWriteD,
        input logic         JumpD,
        input logic         BranchD,
        input logic [3:0]   ALUControlD,
        input logic         ALUSrcD,
        input logic         SrcAsrcD,
        input logic [2:0]   funct3D,
        input logic         jumpRegD,

        output logic        RegWriteE,
        output logic [1:0]  ResultSrcE,
        output logic        MemWriteE,
        output logic [2:0]  funct3E,
        output logic        jumpRegE,

        // datapath IO
        input logic  [31:0] RD1D,
        input logic  [31:0] RD2D,
        input logic  [31:0] PCD,
        input logic  [4:0]  Rs1D,
        input logic  [4:0]  Rs2D,
        input logic  [4:0]  RdD,
        input logic  [31:0] ImmExtD,
        input logic  [31:0] PCPlus4D,

        output logic [31:0] PCPlus4E,
        output logic [31:0] ALUResultE,
        output logic [31:0] WriteDataE,
        output logic [4:0]  Rs1E,
        output logic [4:0]  Rs2E,
        output logic [4:0]  RdE,
        output logic [31:0] ImmExtE,

        // others...
        input logic [31:0]  ResultW,
        input logic [31:0]  ALUResultM,
        input logic [1:0]   ForwardAE,
        input logic [1:0]   ForwardBE,
        output logic        PCSrcE,


);

    logic        JumpE;
    logic        BranchE;
    logic [3:0]  ALUControlE;
    logic        ALUSrcE;
    logic        SrcAsrcE;
    logic        branchTakenE;

    logic [31:0] RD1E;
    logic [31:0] RD2E;
    logic [31:0] PCE;

    logic [31:0] SrcAE, SrcBE;

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin

            RegWriteE <= 1'b0;
            ResultSrcE <= 2'b0;
            MemWriteE <= 1'b0;
            JumpE <= 1'b0;
            BranchE <= 1'b0;
            ALUControlE <= 4'b0;
            ALUSrcE <= 1'b0;
            SrcAsrcE <= 1'b0;
            funct3E <= 3'b0;
            jumpRegE <= 1'b0;


            RD1E <= 32'b0;
            RD2E <= 32'b0;
            PCE <= 32'b0;
            Rs1E <= 5'b0;
            Rs2E <= 5'b0;
            RdE <= 5'b0;
            ImmExtE <= 32'b0;
            PCPlus4E <= 32'b0;

        end
        
        else begin

            RegWriteE <= RegWriteD;
            ResultSrcE <= ResultSrcD;
            MemWriteE <= MemWriteD;
            JumpE <= JumpD;
            BranchE <= BranchD;
            ALUControlE <= ALUControlD;
            ALUSrcE <= ALUSrcD;
            SrcAsrcE <= SrcAsrcD;
            funct3E <= funct3D;
            jumpRegE <= jumpRegD;

            RD1E <= RD1D;
            RD2E <= RD2D;
            PCE <= PCD;
            Rs1E <= Rs1D;
            Rs2E <= Rs2D;
            RdE <= RdD;
            ImmExtE <= ImmExtD;
            PCPlus4E <= PCPlus4D;

        end

    end

    assign PCSrcE = (BranchE & branchTakenE) | JumpE;

    // Source A logic
    logic [31:0] SrcAE_input1;

    mux3 SrcAE_input1mux(

        .d0 (RD1E),
        .d1 (ResultW),
        .d2 (ALUResultM),
        .s  (ForwardAE),
        .y  (SrcAE_input1)

    );

    mux2 SrcAEmux(

        .d0 (SrcAE_input1),
        .d1 (PCE),
        .s  (SrcAsrcE),
        .y  (SrcAE)

    );

    // Source B logic

    mux3 WriteDataEmux(

        .d0 (RD2E),
        .d1 (ResultW),
        .d2 (ALUResultM),
        .s  (ForwardBE),
        .y  (WriteDataE)

    );

    mux2 SrcBEmux(

        .d0 (WriteDataE),
        .d1 (ImmExtE),
        .s  (ALUSrcE),
        .y  (SrcBE)

    );

    branch_unit branch_unit(

        .SrcAE          (SrcAE),
        .SrcBE          (SrcBE),
        .funct3E        (funct3E),
        .branchTakenE   (branchTakenE)

    );

    logic [31:0] adder_base;
    assign adder_base = jumpRegE ? SrcAE : PCE;

    assign PCTargetE = adder_base + ImmExtE;

    alu ALU(

        .d0 (SrcAE),
        .d1 (SrcBE),
        .s  (ALUControlE),
        .y  (ALUResultE)

    );

endmodule