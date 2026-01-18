(* keep_hierarchy = "yes" *)

import hazard_io::*;

`timescale 1ns/1ps

module riscv #(

    parameter XLEN = 64,
    parameter ADDR_WIDTH = 8

) (

        input logic         clk,
        input logic         reset,

        output logic [4:0]  Rs1D,
        output logic [4:0]  Rs2D

        // output logic [XLEN-1:0] dbg_PCF,
        // output logic [31:0]     dbg_InstrD,
        // output logic [XLEN-1:0] dbg_ALUResultE,
        // output logic [XLEN-1:0] dbg_load_data,
        // output logic [XLEN-1:0] dbg_ResultW
    
    );

    hazard_in hazard_inputs;
    hazard_out hazard_outputs;

    datapath #(
        
        .XLEN           (XLEN),
        .ADDR_WIDTH     (ADDR_WIDTH)

    ) datapath (

        .clk                (clk),
        .reset              (reset),

        .StallF             ( hazard_outputs.StallF ),
        .StallD             ( hazard_outputs.StallD ),
        .FlushD             ( hazard_outputs.FlushD ),
        .FlushE             ( hazard_outputs.FlushE ),
        .ForwardAE          ( hazard_outputs.ForwardAE ),
        .ForwardBE          ( hazard_outputs.ForwardBE ),

        .Rs1D               ( hazard_inputs.Rs1D ),
        .Rs2D               ( hazard_inputs.Rs2D ),
        .Rs1E               ( hazard_inputs.Rs1E ),
        .Rs2E               ( hazard_inputs.Rs2E ),
        .RdE                ( hazard_inputs.RdE ),
        .RdM                ( hazard_inputs.RdM ),
        .RdW                ( hazard_inputs.RdW ),

        .ResultSrcE_zero    ( hazard_inputs.ResultSrcE_zero ),
        .RegWriteM          ( hazard_inputs.RegWriteM ),
        .RegWriteW          ( hazard_inputs.RegWriteW ),
        .PCSrcE             ( hazard_inputs.PCSrcE )

        // Debug signals
        // .dbg_PCF            (dbg_PCF),
        // .dbg_InstrD         (dbg_InstrD),
        // .dbg_ALUResultE     (dbg_ALUResultE),
        // .dbg_load_data      (dbg_load_data),
        // .dbg_ResultW        (dbg_ResultW)

    );

    (* dont_touch = "true" *) hazard hazard (

        .StallF             ( hazard_outputs.StallF ),
        .StallD             ( hazard_outputs.StallD ),
        .FlushD             ( hazard_outputs.FlushD ),
        .FlushE             ( hazard_outputs.FlushE ),
        .ForwardAE          ( hazard_outputs.ForwardAE ),
        .ForwardBE          ( hazard_outputs.ForwardBE ),

        .Rs1D               ( hazard_inputs.Rs1D ),
        .Rs2D               ( hazard_inputs.Rs2D ),
        .Rs1E               ( hazard_inputs.Rs1E ),
        .Rs2E               ( hazard_inputs.Rs2E ),
        .RdE                ( hazard_inputs.RdE ),
        .PCSrcE             ( hazard_inputs.PCSrcE ),
        .ResultSrcE_zero    ( hazard_inputs.ResultSrcE_zero ),
        .RdM                ( hazard_inputs.RdM ),
        .RegWriteM          ( hazard_inputs.RegWriteM ),
        .RdW                ( hazard_inputs.RdW ),
        .RegWriteW          ( hazard_inputs.RegWriteW )

    );

    assign Rs1D = hazard_inputs.Rs1D;
    assign Rs2D = hazard_inputs.Rs2D;
    
endmodule