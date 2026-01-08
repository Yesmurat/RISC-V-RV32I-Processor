`timescale 1ns/1ps

module riscv (

        input logic         clk,
        input logic         reset,

        output logic [4:0] Rs1, Rs2
    
    );

    logic StallF, StallD, FlushD, FlushE;
    logic [1:0] ForwardAE, ForwardBE;
    logic [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW;
    logic ResultSrcE_zero, RegWriteM, RegWriteW, PCSrcE;

    datapath datapath (

        .clk                (clk),
        .reset              (reset),

        .StallF             (StallF),
        .StallD             (StallD),
        .FlushD             (FlushD),
        .FlushE             (FlushE),
        .ForwardAE          (ForwardAE),
        .ForwardBE          (ForwardBE),

        .Rs1D               (Rs1D),
        .Rs2D               (Rs2D),
        .Rs1E               (Rs1E),
        .Rs2E               (Rs2E),
        .RdE                (RdE),
        .RdM                (RdM),
        .RdW                (RdW),

        .ResultSrcE_zero    (ResultSrcE_zero),
        .RegWriteM          (RegWriteM),
        .RegWriteW          (RegWriteW),
        .PCSrcE             (PCSrcE)

    );

    hazard hazard (

        .StallF             (StallF),
        .StallD             (StallD),
        .FlushD             (FlushD),
        .FlushE             (FlushE),
        .ForwardAE          (ForwardAE),
        .ForwardBE          (ForwardBE),

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
        .RegWriteW          (RegWriteW)

    );

    assign Rs1 = Rs1D;
    assign Rs2 = Rs2D;
    
endmodule