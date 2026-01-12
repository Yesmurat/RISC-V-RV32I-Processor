(* dont_touch = "true" *)

`timescale 1ns/1ps
// Instruction Memory 256 words

module imem #(

        parameter XLEN = 32,
        parameter ADDR_WIDTH = 8 // 256 instructions
) (
    
        input logic  [ADDR_WIDTH-1:0] address,
        output logic [31:0] rd

    );

    (* ram_style = "distributed" *) logic [31:0] ROM[ 2**ADDR_WIDTH-1 : 0 ];
    
    initial $readmemh("./imem.mem", ROM);

    assign rd = ROM[ address ];

endmodule // Instruction memory