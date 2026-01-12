`timescale 1ns/1ps

module alu
    #( parameter XLEN = 32 ) (
    
        input logic  [ XLEN-1 : 0 ]     d0,
        input logic  [ XLEN-1 : 0 ]     d1,
        input logic  [3:0]      s,
        
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
    localparam SHAMT_WIDTH = $clog2(XLEN);

    always_comb begin

        case (s)

            ALU_ADD: y = d0 + d1; // add/addi

            ALU_SUB: y = d0 - d1; // sub

            ALU_SLL: y = d0 << d1[ SHAMT_WIDTH-1:0 ]; // sll/slli

            ALU_SLT: y = ($signed(d0) < $signed(d1)) ? { XLEN{1'b1} } : { XLEN{1'b0} }; // slt/slti (signed)
            
            ALU_SLTU: y = (d0 < d1) ? { XLEN{1'b1} } : { XLEN{1'b0} }; // sltu/sltiu (unsigned)

            ALU_XOR: y = d0 ^ d1; // xor/xori 

            ALU_SRA: y = $signed(d0) >>> d1[ SHAMT_WIDTH-1:0 ]; // sra/srai

            ALU_SRA: y = d0 >> d1[ SHAMT_WIDTH-1:0 ]; // srl/srli
            
            ALU_OR: y = d0 | d1; // or/ori

            ALU_AND: y = d0 & d1; // and/andi

            default: y = { XLEN{1'b0} };

        endcase

    end

endmodule // ALU