// top module combines riscv with data and instruction memories

`timescale 1ns/1ps

module top (
    
        input logic        clk,
        input logic        reset,
        output logic [3:0] LED

    );

    logic [31:0] ALUResultM;
    logic [31:0] PCF;
    logic [31:0] RD_instr;
    logic [31:0] RD_data;
    logic [31:0] WriteDataM;
    logic MemWriteM;
    logic [3:0] byteEnable; 

    riscv riscv(

        .clk        (clk),
        .reset      (reset),
        .RD_instr   (RD_instr),
        .RD_data    (RD_data),
        .PCF        (PCF),
        .ALUResultM (ALUResultM),
        .WriteDataM (WriteDataM),
        .MemWriteM  (MemWriteM),
        .byteEnable (byteEnable)

    );

    imem imem(
        
        .a  (PCF),
        .rd (RD_instr)
        
    );

    dmem dmem(
        
        .clk        (clk),
        .we         (MemWriteM),
        .byteEnable (byteEnable),
        .a          (ALUResultM),
        .wd         (WriteDataM),
        .rd         (RD_data)
        
    );

    assign LED = PCF[3:0];
    
endmodule