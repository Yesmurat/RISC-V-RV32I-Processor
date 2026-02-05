`timescale 1ns/1ps

import alu_pkg::*;

module alu
    #( parameter XLEN = 32 ) (
    
        input logic  [ XLEN-1 : 0 ]     d0,
        input logic  [ XLEN-1 : 0 ]     d1,
        input logic  [3:0]              s,
        input logic                     is_word_op,
        
        output logic [ XLEN-1 : 0 ]     y
        
    );

    localparam SHAMT_WIDTH_XLEN = $clog2(XLEN);
    localparam SHAMT_WIDTH_WORD = 5; // RV32/RV64 word operations use 5-bit shifts

    logic [XLEN-1:0] alu_raw;

    always_comb begin

        unique case (s)

            ADD: alu_raw = d0 + d1;
            SUB: alu_raw = d0 - d1;
            AND: alu_raw = d0 & d1;
            OR: alu_raw = d0 | d1;
            XOR: alu_raw = d0 ^ d1;

            SLT: alu_raw = ( $signed(d0) < $signed(d1) ) ? '1 : '0;
            SLTU: alu_raw = (d0 < d1) ? '1 : '0;

            SLL: alu_raw = d0 << (
                        is_word_op
                        ? d1[SHAMT_WIDTH_WORD-1:0]
                        : d1[SHAMT_WIDTH_XLEN-1:0]
                    );

            SRL: alu_raw = d0 >> (
                        is_word_op
                        ? d1[SHAMT_WIDTH_WORD-1:0]
                        : d1[SHAMT_WIDTH_XLEN-1:0]
                    );

            SRA: alu_raw = $signed(d0) >>> (
                        is_word_op
                        ? d1[SHAMT_WIDTH_WORD-1:0]
                        : d1[SHAMT_WIDTH_XLEN-1:0]
                    );

            default: alu_raw = '0;

        endcase
        
    end

    // Word op: take lower 32 bits and sign-extend to XLEN
    assign y = is_word_op ? { { (XLEN-32){alu_raw[31]} }, alu_raw[31:0] } : alu_raw;

endmodule // ALU