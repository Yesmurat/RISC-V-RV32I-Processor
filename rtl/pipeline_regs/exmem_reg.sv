`timescale 1ns/1ps

import pipeline_pkg::exmem_t;

module exmem_reg (

    input logic clk,
    input logic en,
    input logic reset,

    input exmem_t inputs,
    output exmem_t outputs
    
);

    always_ff @( posedge clk or posedge reset ) begin : exmem_register
        
        if (reset) begin
            outputs <= '0;
        end

        else if (en) begin
            outputs <= inputs;
        end
        
    end
    
endmodule