(* dont_touch = "true" *)

import hazard_io::*;

`timescale 1ns/1ps

module hazard (
    
        input logic  [4:0] Rs1D, Rs2D,
        input logic  [4:0] Rs1E, Rs2E, RdE,
        input logic        PCSrcE, 
        input logic        ResultSrcE_zero,
        input logic  [4:0] RdM,
        input logic        RegWriteM,
        input logic  [4:0] RdW,
        input logic        RegWriteW,

        output logic       StallF,
        output logic       StallD, FlushD,
        output logic       FlushE,
        output logic [1:0] ForwardAE, ForwardBE

);

    logic lwStall;

    always_comb begin

        // Source A forwarding
        if ( ( ( Rs1E == RdM ) && RegWriteM ) && ( Rs1E != 0 ) )
            ForwardAE = 2'b10;

        else if ( ( ( Rs1E == RdW ) && RegWriteW ) && ( Rs1E != 0 ) )
            ForwardAE = 2'b01;

        else
            ForwardAE = 2'b00;

        // Source B forwarding
        if ( ( ( Rs2E == RdM ) && RegWriteM ) && ( Rs2E != 0 ) )
            ForwardBE = 2'b10;

        else if ( ( ( Rs2E == RdW ) && RegWriteW ) && ( Rs2E != 0 ) )
            ForwardBE = 2'b01;

        else
            ForwardBE = 2'b00;
        
    end

    // Load-use hazard
    assign lwStall = ResultSrcE_zero & ( ( Rs1D == RdE ) | ( Rs2D == RdE ) );

    // Stall IF & ID when a load hazard occurs
    assign StallF = lwStall;
    assign StallD = lwStall;

    // Flush when a branch is taken, jump occurs, or a load introduces a bubble
    assign FlushD = PCSrcE;
    assign FlushE = lwStall | PCSrcE;
    
endmodule