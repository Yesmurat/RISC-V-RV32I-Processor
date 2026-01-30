(* dont_touch = "true" *)
`timescale 1ns/1ps

// Instruction memory
module imem #(

        parameter XLEN       = 32,
        parameter ADDR_WIDTH = 8 // 256 instructions

    )
    
    (
        // input logic                   clk,
        input logic  [XLEN-1:0] address,

        output logic [31:0]           rd
        
    );
    
    logic [31:0] Imem[ 2**ADDR_WIDTH-1 : 0 ];
    
    initial $readmemh("./imem.mem", Imem);

    // always_ff @(posedge clk) begin

    //     rd <= Imem[address];

    // end

    assign rd = Imem[address];

endmodule // Instruction memory