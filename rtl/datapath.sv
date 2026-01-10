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

    // pipeline interfaces
    ifid_if  ifid();
    idex_if  idex();
    exmem_if exmem();
    memwb_if memwb();

    logic [31:0] PCF_new;
    logic [31:0] PCPlus4F;
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

    if_stage IF (

        .clk        (clk),
        .reset      (reset),
        .en         (~StallF),
        .PCF_new    (PCF_new),
        .outputs    (ifid)

    );

    assign PCPlus4F = ifid.data.PCPlus4;

    id_stage ID (

        .clk            (clk),
        .reset          (reset | FlushD),
        // .en             (~StallD),
        
        .RegWriteW      (RegWriteW),
        .RdW            (RdW),
        .ResultW        (ResultW),
        
        .inputs         (ifid),
        .outputs        (idex)

    );

    assign Rs1D = idex.data.Rs1;
    assign Rs2D = idex.data.Rs2;

    ex_stage EX (

        .ResultW        (ResultW),
        .ALUResultM     (ALUResultM),
        .ForwardAE      (ForwardAE),
        .ForwardBE      (ForwardBE),

        .PCSrcE         (PCSrcE),
        .PCTargetE      (PCTargetE),

        .Rs1E           (Rs1E),
        .Rs2E           (Rs2E),

        .inputs         (idex),
        .outputs        (exmem)

    );


    assign RdE = idex.data.Rd;
    assign ResultSrcE_zero = idex.ctrl.ResultSrc[0];

    mem_stage MEM (

        .clk        (clk),
        .inputs     (exmem),
        .outputs    (memwb)

    );

    assign RdM = exmem.data.Rd;
    assign RegWriteM = exmem.ctrl.RegWrite;
    assign ALUResultM = memwb.data.ALUResult;

    wb_stage WB (

        .inputs         (memwb.rd),

        .RegWriteW      (RegWriteW),
        .RdW            (RdW),
        .ResultW        (ResultW)

    );

endmodule