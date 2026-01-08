`timescale 1ns/1ps

module alu (
    
        input logic  [31:0]     d0,
        input logic  [31:0]     d1,
        input logic  [3:0]      s,
        
        output logic [31:0]     y
        
    );

    always_comb begin

        case (s)

            4'b0000: y = d0 + d1; // add/addi

            4'b0001: y = d0 - d1; // sub

            4'b0111: y = d0 << d1[4:0]; // sll/slli

            4'b0101: y = ($signed(d0) < $signed(d1)) ? 32'b1 : 32'b0; // slt/slti (signed)
            
            4'b0110: y = (d0 < d1) ? 32'b1 : 32'b0; // sltu/sltiu (unsigned)

            4'b0100: y = d0 ^ d1; // xor/xori 

            4'b1001: y = $signed(d0) >>> d1[4:0]; // sra/srai

            4'b1000: y = d0 >> d1[4:0]; // srl/srli
            
            4'b0011: y = d0 | d1; // or/ori

            4'b0010: y = d0 & d1; // and/andi

            default: y = 32'b0;

        endcase

    end

endmodule // ALU