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
                output logic        RegWriteW,
                output logic        PCSrcE

);

    logic [31:0] PCF_new;
    logic [31:0] PCPlus4F;
    logic [31:0] PCF;
    logic [31:0] PCTargetE;

    logic [31:0] ResultW;
    logic [31:0] ALUResultM;

    // PC mux
    mux2 pcmux(

        .d0     (PCPlus4F),
        .d1     (PCTargetE),
        .s      (PCSrcE),
        .y      (PCF_new)

    );

    pc_reg PC_reg (

        .clk        (clk),
        .en         (~StallF),
        .reset      (reset),

        .PC_new     (PCF_new),
        .PC         (PCF)

    );

    if_stage IF (

        .PC         (PCF),
        .outputs    ()

    );

    ifid_reg IFID_reg (

        .clk        (clk),
        .en         (~StallD),
        .reset      (reset | FlushD),

        .inputs     (),
        .outputs    ()

    );

    id_stage ID (

        .clk            (clk),
        .reset          (reset | FlushD),
        
        .RegWriteW      (RegWriteW),
        .RdW            (RdW),
        .ResultW        (ResultW),
        
        .inputs         (),
        .outputs        ()

    );

    idex_reg IDEX_reg (

        .clk        (clk),
        .en         (1'b1),
        .reset      (reset | FlushE),

        .inputs     (),
        .outputs    ()

    );

    ex_stage EX (

        .ResultW        (ResultW),
        .ALUResultM     (ALUResultM),
        .ForwardAE      (ForwardAE),
        .ForwardBE      (ForwardBE),

        .PCSrcE         (PCSrcE),
        .PCTargetE      (PCTargetE),

        .Rs1E           (Rs1E),
        .Rs2E           (Rs2E),

        .inputs         (),
        .outputs        ()

    );

    exmem_reg EXMEM_reg (

        .clk        (clk),
        .en         (1'b1),
        .reset      (reset),

        .inputs     (),
        .outputs    ()

    );

    mem_stage MEM (

        .clk        (clk),
        .inputs     (),
        .outputs    ()

    );

    memwb_reg MEMWB_reg (

        .clk        (clk),
        .en         (1'b1),
        .reset      (reset),

        .inputs     (),
        .outputs    ()

    );

    wb_stage WB (

        .inputs         (),

        .RegWriteW      (RegWriteW),
        .RdW            (RdW),
        .ResultW        (ResultW)

    );

    assign PCPlus4F = ...;

    assign Rs1D = ...;
    assign Rs2D = ...;

    assign RdE = ...;
    assign ResultSrcE_zero = ...;

    assign RdM = ...;
    assign RegWriteM = ...;
    assign ALUResultM = ...;

endmodule