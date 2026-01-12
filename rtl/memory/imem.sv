(* dont_touch = "true" *)

`timescale 1ns/1ps
// Instruction Memory 256 words

module imem (
    
        input logic  [29:0] address,
        output logic [31:0] rd

    );

    (* ram_style = "distributed" *) logic [31:0] ROM[255:0];
    
    initial $readmemh("./imem.mem", ROM);

    assign rd = ROM[ address ];

endmodule // Instruction memory