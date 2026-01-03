`timescale 1ns/1ps

module datapath (
    
                input logic         clk,
                input logic         reset,
                
                // input signals from Hazard Unit
                input logic         StallF,
                input logic         StallD,
                input logic         FlushD,
                input logic         FlushE,
                input logic  [1:0]  ForwardAE,
                input logic  [1:0]  ForwardBE,

                // outputs to Hazard Unit
                output logic [4:0]  Rs1D,
                output logic [4:0]  Rs2D,
                output logic [4:0]  Rs1E,
                output logic [4:0]  Rs2E,
                output logic [4:0]  RdE,
                output logic [4:0]  RdM,
                output logic [4:0]  RdW,

                output logic        ResultSrcE_zero,
                output logic        RegWriteM,
                output logic        RegWriteW

);

    // PC mux
    logic [31:0] PCPlus4F, PCTargetE, PCF_new;
    logic PCSrcE;

    mux2 pcmux(

        .d0 (PCPlus4F),
        .d1 (PCTargetE),
        .s  (PCSrcE),
        .y  (PCF_new)

    );

    // IF stage

    logic [31:0] RD_instr;

    if_stage if_stage (
        
        .clk          (clk),
        .en           (~StallF),
        .reset        (reset),
        .PCF_new      (PCF_new),
        .PCF          (PCF)
        .RD_instr     (RD_instr),
        .PCPlus4F     (PCPlus4F)

    );

    // ID stage

    logic           RegWriteW;
    logic [31:0]    ResultW;

    logic           RegWriteD;
    logic [1:0]     ResultSrcD;
    logic           MemWriteD;
    logic           JumpD;
    logic           BranchD;
    logic [2:0]     ALUControlD;
    logic           ALUSrcD;
    logic           SrcAsrcD;
    logic [2:0]     funct3D;
    logic [1:0]     ImmSrcD;
    logic           jumpRegD;

    logic [31:0] RD1D, RD2D, PCD, ImmExtD, PCPlus4D;
    logic [4:0] RdD;

    id_stage id_stage (

        .clk        (clk),
        .reset      (FlushD | reset),
        .en         (~StallD),

        .InstrF     (RD_instr),
        .PCF        (PCF),
        .PCPlus4F   (PCPlus4F),

        .RegWriteW  (RegWriteW),
        .RdW        (RdW),
        .ResultW    (ResultW),


        .RegWriteD  (RegWriteD),
        .ResultSrcD (ResultSrcD),
        .MemWriteD  (MemWriteD),
        .JumpD      (JumpD),
        .BranchD    (BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD    (ALUSrcD),
        .SrcAsrcD   (SrcAsrcD),
        .funct3D    (funct3D),
        .jumpRegD   (jumpRegD),

        .RD1D       (RD1D),
        .RD2D       (RD2D),
        .PCD        (PCD),
        .Rs1D       (Rs1D),
        .Rs2D       (Rs2D),
        .RdD        (RdD),
        .ImmExtD    (ImmExtD),
        .PCPlus4D   (PCPlus4D)

    );

    // EX stage

    logic RegWriteE;
    logic ResultSrcE;
    logic MemWriteE;
    logic [2:0] funct3E;
    logic jumpRegE;

    logic [31:0] PCPlus4E, ALUResultE, WriteDataE, ImmExtE;

    logic [31:0] ResultW, ALUResultM;

    logic [4:0] RdE;

    ex_stage ex_stage(

        .clk            (clk),
        .reset          (FlushE | reset),

        // control IO
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

        .RegWriteE      (RegWriteE),
        .ResultSrcE     (ResultSrcE),
        .MemWriteE      (MemWriteE),
        .funct3E        (funct3E),
        .jumpRegE       (jumpRegE),

        // datapath IO
        .RD1D           (RD1D),
        .RD2D           (RD2D),
        .PCD            (PCD),
        .Rs1D           (Rs1D),
        .Rs2D           (Rs2D),
        .RdD            (RdD),
        .ImmExtD        (ImmExtD),
        .PCPlus4D       (PCPlus4D),

        .PCPlus4E       (PCPlus4E),
        .ALUResultE     (ALUResultE),
        .WriteDataE     (WriteDataE),
        .Rs1E           (Rs1E),
        .Rs2E           (Rs2E),
        .RdE            (RdE),
        .ImmExtE        (ImmExtE),

        // others
        .ResultW        (ResultW),
        .ALUResultM     (ALUResultM),
        .ForwardAE      (ForwardAE),
        .ForwardBE      (ForwardBE),
        .PCSrcE         (PCSrcE) // output

    );

    assign ResultSrcE_zero = ResultSrcE[0];

    // MEM stage

    logic RegWriteM;
    logic [1:0] ResultSrcM;
    logic [31:0] load_data, PCPlus4M;

    mem_stage mem_stage (

        .clk        (clk),
        .reset      (reset),

        // control IO
        .RegWriteE  (RegWriteE),
        .ResultSrcE (ResultSrcE),
        .MemWriteE  (MemWriteE),
        .funct3E    (funct3E),

        .RegWriteM  (RegWriteM),
        .ResultSrcM (ResultSrcM),

        // datapath IO
        .ALUResultE (ALUResultE),
        .WriteDataE (WriteDataE),
        .RdE        (RdE),
        .ImmExtE    (ImmExtE),
        .PCPlus4E   (PCPlus4E),

        .ALUResultM (ALUResultM),
        .load_data  (load_data),
        .RdM        (RdM),
        .ImmExtM    (ImmExtM),
        .PCPlus4M   (PCPlus4M)

    );

    // WB stage

    wb_stage wb_stage (

        .clk        (clk),
        .reset      (reset),

        // control IO
        .RegWriteM  (RegWriteM),
        .ResultSrcM (ResultSrcM),

        .RegWriteW  (RegWriteW),

        // datapath IO
        .ALUResultM (ALUResultM),
        .load_data  (load_data),
        .RdM        (RdM),
        .ImmExtM    (ImmExtM),
        .PCPlus4M   (PCPlus4M),

        .RdW        (RdW),
        .ResultW    (ResultW)

    );

endmodule