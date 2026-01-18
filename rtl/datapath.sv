import pipeline_pkg::*;
import hazard_io::*;

`timescale 1ns/1ps

module datapath # (

    parameter XLEN = 32,
    parameter ADDR_WIDTH = 8

) (
    
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

                // Debug signals
                // output logic [XLEN-1:0] dbg_PCF,
                // output logic [31:0] dbg_InstrD,
                // output logic [XLEN-1:0] dbg_ALUResultE,
                // output logic [XLEN-1:0] dbg_load_data,
                // output logic [XLEN-1:0] dbg_ResultW

);

    logic [XLEN-1:0] PCF_new;
    logic [XLEN-1:0] PCPlus4F;
    logic [XLEN-1:0] PCF;
    logic [XLEN-1:0] PCTargetE;

    logic [XLEN-1:0] ResultW;
    logic [XLEN-1:0] ALUResultM;

    ifid_t ifid_d, ifid_q;
    idex_t idex_d, idex_q;
    exmem_t exmem_d, exmem_q;
    memwb_t memwb_d, memwb_q;

    // PC mux
    assign PCF_new = PCSrcE ? PCTargetE : PCPlus4F;

    pc_reg #(
        
        .XLEN(XLEN)
        
    ) PC_reg (

        .clk        ( clk ),
        .en         ( ~StallF ),
        .reset      ( reset ),

        .PC_new     ( PCF_new ),
        .PC         ( PCF )

    );

    if_stage #(

        .XLEN(XLEN),
        .ADDR_WIDTH(ADDR_WIDTH)

    ) IF (

        .PC         ( PCF ),
        .PCPlus4F   ( PCPlus4F ),

        .outputs    ( ifid_d )

    );

    ifid_reg IFID_reg  (

        .clk        ( clk ),
        .en         ( ~StallD ),
        .reset      ( reset | FlushD ),

        .inputs     ( ifid_d ),
        .outputs    ( ifid_q )

    );

    id_stage #(.XLEN(XLEN)) ID (

        .clk            ( clk ),
        .reset          ( reset | FlushD ),
        
        .RegWriteW      ( RegWriteW ),
        .RdW            ( RdW ),
        .ResultW        ( ResultW ),
        
        .inputs         ( ifid_q ),
        .outputs        ( idex_d ),

        .Rs1D           ( Rs1D ),
        .Rs2D           ( Rs2D )

    );

    idex_reg IDEX_reg (

        .clk        ( clk ),
        .en         ( 1'b1 ),
        .reset      ( reset | FlushE ),

        .inputs     ( idex_d ),
        .outputs    ( idex_q )

    );

    ex_stage #(.XLEN(XLEN)) EX (

        .ResultW         ( ResultW ),
        .ALUResultM      ( ALUResultM ),
        .ForwardAE       ( ForwardAE ),
        .ForwardBE       ( ForwardBE ),

        .PCSrcE          ( PCSrcE ),
        .PCTargetE       ( PCTargetE ),

        .Rs1E            ( Rs1E ),
        .Rs2E            ( Rs2E ),
        .RdE             ( RdE ),
        .ResultSrcE_zero ( ResultSrcE_zero),

        .inputs          ( idex_q ),
        .outputs         ( exmem_d )

    );

    exmem_reg EXMEM_reg (

        .clk        ( clk ),
        .en         ( 1'b1 ),
        .reset      ( reset ),

        .inputs     ( exmem_d ),
        .outputs    ( exmem_q )

    );

    mem_stage #(

        .XLEN(XLEN),
        .ADDR_WIDTH(ADDR_WIDTH)

    ) MEM (

        .clk        ( clk ),
        .inputs     ( exmem_q ),
        .outputs    ( memwb_d ),

        .ALUResultM ( ALUResultM ),

        .RdM        ( RdM ),
        .RegWriteM  ( RegWriteM )

    );

    memwb_reg MEMWB_reg (

        .clk        ( clk ),
        .en         ( 1'b1 ),
        .reset      ( reset ),

        .inputs     ( memwb_d ),
        .outputs    ( memwb_q )

    );

    (* dont_touch = "true" *) wb_stage #(.XLEN(XLEN)) WB (

        .inputs         ( memwb_q ),

        .RegWriteW      ( RegWriteW ),
        .RdW            ( RdW ),
        .ResultW        ( ResultW )

    );

    // assign dbg_PCF = PCF;
    // assign dbg_InstrD = ifid_q.instr;
    // assign dbg_ALUResultE = exmem_d.ALUResult;
    // assign dbg_load_data = memwb_d.load_data;
    // assign dbg_ResultW = ResultW;

endmodule