`timescale 1ns/1ps

import pipeline_pkg::memwb_t;

module memwb_reg (
    
    input logic clk,
    input logic en,
    input logic reset,

    input memwb_t inputs,
    output memwb_t outputs
);

    always_ff @( posedge clk or posedge reset ) begin : memwb_register
        
        if (reset) begin
            outputs <= '0;
        end

        else if (en) begin
            outputs <= inputs;
        end

    end
    
endmodule