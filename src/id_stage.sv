module ID_stage (
    
        input logic         clk,
        input logic         reset,
        input logic         en,

        input logic [31:0]  InstrF,
        input logic [31:0]  PCF,
        input logic [31:0]  PCPlus4F,

        input logic          RegWriteW,
        input logic          RdW,
        input logic [31:0]   ResultW,

        // control outputs
        output logic         RegWriteD,
        output logic [1:0]   ResultSrcD,
        output logic         MemWriteD,
        output logic         JumpD,
        output logic         BranchD,
        output logic [3:0]   ALUControlD,
        output logic         ALUSrcD,
        output logic         SrcAsrcD,
        output logic [2:0]   funct3D,
        output logic         jumpRegD,

        // datapath outputs
        output logic [31:0] RD1D,
        output logic [31:0] RD2D,
        output logic [31:0] PCD,
        output logic [4:0]  Rs1D,
        output logic [4:0]  Rs2D,
        output logic [4:0]  RdD,
        output logic [31:0] ImmExtD,
        output logic [31:0] PCPlus4D

);

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin

            InstrD <= 32'b0;
            PCD <= 32'b0;
            PCPlus4D <= 32'b0;

        end
        
        else if (en) begin

            InstrD <= InstrF;
            PCD <= PCF;
            PCPlus4D <= PCPlus4F;

        end

    end

    logic [1:0] ImmSrcD;

    controller control_unit(

        .opcode(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7b5(InstrD[30]),

        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD),
        .SrcAsrcD(SrcAsrcD),
        .jumpRegD(jumpRegD)

    );

    regfile register_file(

        .clk    (clk),
        .we3    (RegWriteW),
        .reset  (reset),

        .a1     (InstrD[19:15]),
        .a2     (InstrD[24:20]),

        .a3     (RdW),
        .wd3    (ResultW),

        .rd1    (RD1D),
        .rd2    (RD2D)

    );

    extend immediate_extend(

        .instr_31_7     (InstrD[31:7]),
        .immsrc         (ImmSrcD),

        .immext         (ImmExtD)

    );

end