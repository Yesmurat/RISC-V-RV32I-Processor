`timescale 1ns/1ps

module datapath (
    
                input logic         clk,
                input logic         reset,
                
                // Control signals
                input logic         RegWriteD,
                input logic  [1:0]  ResultSrcD,
                input logic         MemWriteD,
                input logic         JumpD,
                input logic         BranchD,
                input logic  [3:0]  ALUControlD,
                input logic         ALUSrcD,
                input logic  [2:0]  ImmSrcD,
                input logic         SrcAsrcD,
                input logic         jumpRegD,
                
                // input signals from Hazard Unit
                input logic         StallF,
                input logic         StallD,
                input logic         FlushD,
                input logic         FlushE,
                input logic  [1:0]  ForwardAE,
                input logic  [1:0]  ForwardBE,

                input logic  [31:0] RD_instr,
                input logic  [31:0] RD_data,

                // outputs to instr & data memories
                output logic [31:0] PCF,

                output logic [31:0] ALUResultM,
                output logic [31:0] WriteDataM,
                output logic        MemWriteM,
                output logic [3:0]  byteEnable,

                // outputs to controller
                output logic [6:0] opcode,
                output logic [2:0] funct3,
                output logic       funct7b5,

                // outputs to Hazard Unit
                output logic [4:0]  Rs1D,
                output logic [4:0]  Rs2D,
                output logic [4:0]  Rs1E,
                output logic [4:0]  Rs2E,
                output logic [4:0]  RdE,

                output logic        PCSrcE,
                output logic        ResultSrcE_zero,
                output logic        RegWriteM,
                output logic        RegWriteW,

                output logic [4:0]  RdM,
                output logic [4:0]  RdW

);

    // PC mux
    logic [31:0] PCPlus4F, PCTargetE, PCF_new;

    mux2 pcmux(

        .d0 (PCPlus4F),
        .d1 (PCTargetE),
        .s  (PCSrcE),
        .y  (PCF_new)

    );

    // Instruction Fetch (IF) stage
    IFregister ifreg(
        
        .clk    (clk),
        .en     (~StallF),
        .reset  (reset),
        .d      (PCF_new),
        .q      (PCF)

    );

    assign PCPlus4F = PCF + 32'd4;

    // Instruction Decode (ID) stage
    logic [31:0] PCD, PCPlus4D;
    logic [31:0] RD1, RD2;
    logic [31:0] ResultW;
    logic [31:0] ImmExtD;
    logic [4:0] RdD;
    logic [31:0] InstrD;

    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD = InstrD[11:7];

    assign opcode = InstrD[6:0];
    assign funct3 = InstrD[14:12];
    assign funct7b5 = InstrD[30];

    IFIDregister ifidreg(

        .clk        (clk),
        .reset      (FlushD | reset),
        .en         (~StallD),
        .RD_instr   (RD_instr),
        .PCF        (PCF),
        .PCPlus4F   (PCPlus4F),
        .InstrD     (InstrD),
        .PCD        (PCD),
        .PCPlus4D   (PCPlus4D)

    );

    regfile regfile(

        .clk    (clk),
        .we3    (RegWriteW),
        .reset  (reset),
        .a1     (Rs1D),
        .a2     (Rs2D),
        .a3     (RdW),
        .wd3    (ResultW),
        .rd1    (RD1),
        .rd2    (RD2)

    );

    extend extender(

        .instr_31_7  (InstrD[31:7]),
        .immsrc      (ImmSrcD),
        .immext      (ImmExtD)

    );

    // Execute (EX) stage
    logic [31:0] RD1E, RD2E, PCE;
    logic [31:0] ImmExtE;
    logic [31:0] PCPlus4E;

    logic [31:0] SrcAE, SrcBE;
    logic [31:0] WriteDataE;
    logic [31:0] ALUResultE;

    logic RegWriteE;
    logic [1:0] ResultSrcE;
    logic MemWriteE, JumpE, BranchE;
    logic [3:0] ALUControlE;
    logic [2:0] funct3E;
    logic branchTakenE;
    logic jumpRegE;
    logic SrcAsrcE, ALUSrcE;

    IDEXregister idexreg(

        .clk            (clk),
        .reset          (FlushE | reset),

        // ID stage control signals
        .RegWriteD      (RegWriteD),
        .ResultSrcD     (ResultSrcD),
        .MemWriteD      (MemWriteD),
        .JumpD          (JumpD),
        .BranchD        (BranchD),
        .ALUControlD    (ALUControlD),
        .ALUSrcD        (ALUSrcD),
        .SrcAsrcD       (SrcAsrcD),
        .funct3D        (funct3),
        .jumpRegD       (jumpRegD),

        // EX stage control signals
        .RegWriteE      (RegWriteE),
        .ResultSrcE     (ResultSrcE),
        .MemWriteE      (MemWriteE),
        .JumpE          (JumpE),
        .BranchE        (BranchE),
        .ALUControlE    (ALUControlE),
        .ALUSrcE        (ALUSrcE),
        .SrcAsrcE       (SrcAsrcE),
        .funct3E        (funct3E),
        .jumpRegE       (jumpRegE),

        // datapath inputs & outputs
        .RD1            (RD1),
        .RD2            (RD2),
        .PCD            (PCD),
        .Rs1D           (Rs1D),
        .Rs2D           (Rs2D),
        .RdD            (RdD),
        .ImmExtD        (ImmExtD),
        .PCPlus4D       (PCPlus4D),

        .RD1E           (RD1E),
        .RD2E           (RD2E),
        .PCE            (PCE),
        .Rs1E           (Rs1E),
        .Rs2E           (Rs2E),
        .RdE            (RdE),
        .ImmExtE        (ImmExtE),
        .PCPlus4E       (PCPlus4E)

    );

    assign PCSrcE = (BranchE & branchTakenE) | JumpE;
    assign ResultSrcE_zero = ResultSrcE[0];

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

    // --------------------------------------------------------------//
    // Memory write (MEM) stage
    logic [31:0] PCPlus4M;
    logic [2:0] funct3M;
    logic [1:0] ResultSrcM;
    logic [1:0] byteAddrM;
    logic [31:0] load_data;
    logic [31:0] ImmExtM;

    assign byteAddrM = ALUResultM[1:0];

    EXMEMregister exmemreg(

        .clk        (clk),
        .reset      (reset),

        // EX stage control signals
        .RegWriteE  (RegWriteE),
        .ResultSrcE (ResultSrcE),
        .MemWriteE  (MemWriteE),
        .funct3E    (funct3E),

        // MEM stage control signals
        .RegWriteM  (RegWriteM),
        .ResultSrcM (ResultSrcM),
        .MemWriteM  (MemWriteM),
        .funct3M    (funct3M),

        // datapath inputs & outputs
        .ALUResultE (ALUResultE),
        .WriteDataE (WriteDataE),
        .RdE        (RdE),
        .ImmExtE    (ImmExtE),
        .PCPlus4E   (PCPlus4E),

        .ALUResultM (ALUResultM),
        .WriteDataM (WriteDataM),
        .RdM        (RdM),
        .ImmExtM    (ImmExtM),
        .PCPlus4M   (PCPlus4M)

    );

    // byte loads
    always_comb begin

        unique case (funct3M) // funct3 determines store type

            3'b000: begin
                
                unique case (byteAddrM)

                    2'b00: byteEnable = 4'b0001; // enable byte 0 
                    2'b01: byteEnable = 4'b0010; // enable byte 1
                    2'b10: byteEnable = 4'b0100; // enable byte 2
                    2'b11: byteEnable = 4'b1000; // enable byte 3
                
                endcase
                
            end

            3'b001: begin

                byteEnable = (byteAddrM[1] == 0) // sh
                                ? 4'b0011 // low half
                                : 4'b1100; // high half
                
            end

            3'b010: begin

                byteEnable = 4'b1111;
                
            end

        endcase

    end

    loadext loadext(

        .LoadTypeM  (funct3M),
        .RD_data    (RD_data),
        .byteAddrM  (byteAddrM),
        .load_data  (load_data)

    );

    // -------------------------------------------------------------//
    // Register file writeback (WB) stage
    logic [31:0] ALUResultW;
    logic [31:0] ReadDataW;
    logic [31:0] PCPlus4W;
    logic [31:0] ImmExtW;
    logic [1:0] ResultSrcW;

    MEMWBregister memwbreg(

        .clk        (clk),
        .reset      (reset),

        // MEM stage control signals
        .RegWriteM  (RegWriteM),
        .ResultSrcM (ResultSrcM),

        // WB stage control signals
        .RegWriteW  (RegWriteW),
        .ResultSrcW (ResultSrcW),

        // datapath inputs & outputs
        .ALUResultM (ALUResultM),
        .load_data  (load_data),
        .RdM        (RdM),
        .ImmExtM    (ImmExtM),
        .PCPlus4M   (PCPlus4M),

        .ALUResultW (ALUResultW),
        .ReadDataW  (ReadDataW),
        .RdW        (RdW),
        .ImmExtW    (ImmExtW),
        .PCPlus4W   (PCPlus4W)

    );

    mux4 ResultWmux(

        .d0 (ALUResultW),
        .d1 (ReadDataW),
        .d2 (PCPlus4W),
        .d3 (ImmExtW),
        .s  (ResultSrcW),
        .y  (ResultW)

    );

endmodule