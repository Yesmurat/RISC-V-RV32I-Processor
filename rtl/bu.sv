`timescale 1ns/1ps

module branch_unit
    #( parameter XLEN = 32 ) (
    
        input logic [XLEN-1:0] SrcAE, SrcBE,
        input logic [2:0]  funct3E,
        output logic       branchTakenE

);

    logic eqE, ltE, ltuE;

    assign eqE = (SrcAE == SrcBE);
    assign ltE = $signed(SrcAE) < $signed(SrcBE);
    assign ltuE = $unsigned(SrcAE) < $unsigned(SrcBE);

    always_comb begin

        unique case (funct3E)

            3'b000: branchTakenE = eqE; // beq

            3'b001: branchTakenE = !eqE; // bne

            3'b100: branchTakenE = ltE; // blt

            3'b101: branchTakenE = !ltE; // bge

            3'b110: branchTakenE = ltuE; // bltu

            3'b111: branchTakenE = !ltuE; // bgeu

            default: branchTakenE =  1'b0;

        endcase

    end
    
endmodule // Branch unit