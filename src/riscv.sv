`timescale 1ns/1ps

module riscv (

        input logic         clk,
        input logic         reset,

        // inputs from Instruction and Data memories
        input logic [31:0]  RD_instr,
        input logic [31:0]  RD_data,

        // outputs to Instruction and Data memories
        output logic [31:0] PCF,
        output logic [31:0] ALUResultM,
        output logic [31:0] WriteDataM,
        output logic        MemWriteM,
        output logic [3:0]  byteEnable
    
    );

    // control signals
    logic RegWriteD;
    logic [1:0] ResultSrcD;
    logic MemWriteD;
    logic JumpD;
    logic BranchD;
    logic [3:0] ALUControlD;
    logic ALUSrcD;
    logic [2:0] ImmSrcD;
    logic SrcAsrcD;
    logic ResultSrcE_zero;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic funct7b5;

    // Hazard unit wires
    logic StallF;
    logic StallD, FlushD;
    logic FlushE;
    logic [1:0] ForwardAE, ForwardBE;
    logic PCSrcE;

    logic [4:0] Rs1D, Rs2D;
    logic [4:0] Rs1E, Rs2E, RdE;
    logic [4:0] RdM, RdW;
    logic RegWriteM, RegWriteW;
    logic jumpRegD;

    controller controller(

        .opcode         (opcode),
        .funct3         (funct3), // input
        .funct7b5       (funct7b5),
        
        .RegWriteD      (RegWriteD),
        .ResultSrcD     (ResultSrcD),
        .MemWriteD      (MemWriteD),
        .JumpD          (JumpD),
        .BranchD        (BranchD),
        .ALUControlD    (ALUControlD),
        .ALUSrcD        (ALUSrcD),
        .ImmSrcD        (ImmSrcD),
        .SrcAsrcD       (SrcAsrcD),
        .jumpRegD       (jumpRegD)
    );

    datapath datapath(
        
        .clk                (clk),
        .reset              (reset),

        // Control signals
        .RegWriteD          (RegWriteD),
        .ResultSrcD         (ResultSrcD),
        .MemWriteD          (MemWriteD),
        .JumpD              (JumpD),
        .BranchD            (BranchD),
        .ALUControlD        (ALUControlD),
        .ALUSrcD            (ALUSrcD),
        .ImmSrcD            (ImmSrcD),
        .SrcAsrcD           (SrcAsrcD),
        .jumpRegD           (jumpRegD),

        // inputs from Hazard unit
        .StallF             (StallF),
        .StallD             (StallD),
        .FlushD             (FlushD),
        .FlushE             (FlushE),
        .ForwardAE          (ForwardAE),
        .ForwardBE          (ForwardBE),

        .RD_instr           (RD_instr),
        .RD_data            (RD_data),

        // outputs to Instruction and Data memories
        .PCF                (PCF),
        .ALUResultM         (ALUResultM),
        .WriteDataM         (WriteDataM),
		.MemWriteM          (MemWriteM),
        .byteEnable         (byteEnable),

        // outputs to controller
        .opcode             (opcode),
        .funct3             (funct3), // output
        .funct7b5           (funct7b5),

        // outputs to hazard unit
        .Rs1D               (Rs1D),
        .Rs2D               (Rs2D),
        .Rs1E               (Rs1E),
        .Rs2E               (Rs2E),
        .PCSrcE             (PCSrcE),
        .ResultSrcE_zero    (ResultSrcE_zero),
        .RegWriteM          (RegWriteM),
        .RegWriteW          (RegWriteW),
        .RdE                (RdE),
        .RdM                (RdM),
        .RdW                (RdW)
        
    );

    hazard hazard(

        .Rs1D               (Rs1D),
        .Rs2D               (Rs2D),
        .Rs1E               (Rs1E),
        .Rs2E               (Rs2E),
        .RdE                (RdE),
        .PCSrcE             (PCSrcE),
        .ResultSrcE_zero    (ResultSrcE_zero),
        .RdM                (RdM),
        .RegWriteM          (RegWriteM),
        .RdW                (RdW),
        .RegWriteW          (RegWriteW),

        .StallF             (StallF),
        .StallD             (StallD),
        .FlushD             (FlushD),
        .FlushE             (FlushE),
        .ForwardAE          (ForwardAE),
        .ForwardBE          (ForwardBE)

    );
    
endmodule