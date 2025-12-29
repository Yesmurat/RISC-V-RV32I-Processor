`timescale 1ns/1ps
// Instruction Memory 256 words

module imem (
    
        input logic  [31:0] a,
        output logic [31:0] rd

    );

    (* ram_style = "distributed" *) logic [31:0] ROM[255:0];
    
    initial $readmemh("./memory/imem.mem", ROM);

    assign rd = ROM[ a[31:2] ];

endmodule // Instruction memory