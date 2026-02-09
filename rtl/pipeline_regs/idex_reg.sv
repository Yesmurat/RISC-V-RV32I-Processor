`timescale 1ns/1ps

import pipeline_pkg::idex_t;

module idex_reg (
    
    input logic clk,
    // input logic en,
    input logic reset,

    input idex_t inputs,
    output idex_t outputs

);

    always_ff @( posedge clk or posedge reset ) begin : EX_register

        if (reset) begin
            outputs <= '0;
        end

        else begin
            outputs <= inputs;
        end
        
    end
    
endmodule