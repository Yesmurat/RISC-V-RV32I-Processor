`timescale 1ns/1ps

module alu
    #( parameter XLEN = 32 ) (
    
        input logic  [ XLEN-1 : 0 ]     d0,
        input logic  [ XLEN-1 : 0 ]     d1,
        input logic  [3:0]              s,
        input logic                     is_word_op,
        
        output logic [ XLEN-1 : 0 ]     y
        
    );

    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLT  = 4'b0101;  // signed
    localparam ALU_SLTU = 4'b0110;  // unsigned
    localparam ALU_SLL  = 4'b0111;
    localparam ALU_SRL  = 4'b1000;
    localparam ALU_SRA  = 4'b1001;

    localparam SHAMT_WIDTH_XLEN = $clog2(XLEN);
    localparam SHAMT_WIDTH_WORD = 5; // RV32/RV64 word operations use 5-bit shifts

    logic [XLEN-1:0] alu_raw;

    always_comb begin

        unique case (s)

            ALU_ADD: alu_raw = d0 + d1;
            ALU_SUB: alu_raw = d0 - d1;
            ALU_AND: alu_raw = d0 & d1;
            ALU_OR: alu_raw = d0 | d1;
            ALU_XOR: alu_raw = d0 ^ d1;

            ALU_SLT: alu_raw = ( $signed(d0) < $signed(d1) ) ? '1 : '0;
            ALU_SLTU: alu_raw = (d0 < d1) ? '1 : '0;

            ALU_SLL: alu_raw = d0 << (
                        is_word_op
                        ? d1[SHAMT_WIDTH_WORD-1:0]
                        : d1[SHAMT_WIDTH_XLEN-1:0]
                    );

            ALU_SRL: alu_raw = d0 >> (
                        is_word_op
                        ? d1[SHAMT_WIDTH_WORD-1:0]
                        : d1[SHAMT_WIDTH_XLEN-1:0]
                    );

            ALU_SRA: alu_raw = $signed(d0) >> (
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