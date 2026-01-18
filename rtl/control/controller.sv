`timescale 1ns/1ps

import control_pkg::control_signals;

module controller (
    
    input logic  [6:0] opcode,
    input logic  [2:0] funct3,
    input logic        funct7b5,

    output logic       RegWriteD,
    output logic [1:0] ResultSrcD,
    output logic       MemWriteD,
    output logic       JumpD,
    output logic       BranchD,
    output logic [3:0] ALUControlD,
    output logic       ALUSrcD,
    output logic [2:0] ImmSrcD,
    output logic       SrcAsrcD,
    output logic       jumpRegD
                   
    );

    logic [1:0] ALUOp;

    control_signals ctrls;

    (* dont_touch = "true" *) maindec md(

        .opcode     (opcode),
        .funct3     (funct3)
        .ctrl       (ctrls)

    );

    (* dont_touch = "true" *) aludec ad(

        .opb5       (opcode[5]),
        .funct3     (funct3),
        .funct7b5   (funct7b5),
        .ALUOp      (ALUOp),
        .ALUControl (ALUControlD)

    );

    assign RegWriteD = ctrls.RegWriteD;
    assign ResultSrcD = ctrls.ResultSrcD;
    assign MemWriteD = ctrls.MemWriteD;
    assign JumpD = ctrls.JumpD;
    assign BranchD = ctrls.BranchD;
    assign ALUControlD = ctrls.ALUControlD;
    assign ImmSrcD = ctrls.ImmSrcD;
    assign SrcAsrcD = ctrls.SrcAsrcD;
    assign jumpRegD = ctrls.jumpRegD;
    
endmodule
