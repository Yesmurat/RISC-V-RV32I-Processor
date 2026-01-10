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

    ifid_if ifid_d();
    ifid_if ifid_q();

    idex_if idex_d();
    idex_if idex_q();

    exmem_if exmem_d();
    exmem_if exmem_q();

    memwb_if memwb_d();
    memwb_if memwb_q();

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
        .outputs    (ifid_d)

    );

    ifid_reg IFID_reg (

        .clk        (clk),
        .en         (~StallD),
        .reset      (reset | FlushD),

        .inputs     (ifid_d),
        .outputs    (ifid_q)

    );

    id_stage ID (

        .clk            (clk),
        .reset          (reset | FlushD),
        
        .RegWriteW      (RegWriteW),
        .RdW            (RdW),
        .ResultW        (ResultW),
        
        .inputs         (ifid_q),
        .outputs        (idex_d)

    );

    idex_reg IDEX_reg (

        .clk        (clk),
        .en         (1'b1),
        .reset      (reset | FlushE),

        .inputs     (idex_d),
        .outputs    (idex_q)

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

        .inputs         (idex_q),
        .outputs        (exmem_d)

    );

    exmem_reg EXMEM_reg (

        .clk        (clk),
        .en         (1'b1),
        .reset      (reset),

        .inputs     (exmem_d),
        .outputs    (exmem_q)

    );

    mem_stage MEM (

        .clk        (clk),
        .inputs     (exmem_q),
        .outputs    (memwb_d)

    );

    memwb_reg MEMWB_reg (

        .clk        (clk),
        .en         (1'b1),
        .reset      (reset),

        .inputs     (memwb_d),
        .outputs    (memwb_q)

    );

    wb_stage WB (

        .inputs         (memwb_q),

        .RegWriteW      (RegWriteW),
        .RdW            (RdW),
        .ResultW        (ResultW)

    );

    assign PCPlus4F = ifid_d.data.PCPlus4;

    assign Rs1D = ifid_q.data.Rs1;
    assign Rs2D = ifid_q.data.Rs2;

    assign RdE = idex_q.data.Rd;
    assign ResultSrcE_zero = idex_q.ctrl.ResultSrc[0];

    assign RdM = exmem_q.data.Rd;
    assign RegWriteM = exmem_q.ctrl.RegWrite;
    assign ALUResultM = exmem_q.data.ALUResult;

endmodule