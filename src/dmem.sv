/*
    Everything seems fine, but dmem cannot be made completely out of LUTs.
    Hence, Vivado optimizes away everything since dmem is connected to the core logic of cpu.
*/

`timescale 1ns/1ps
// Data memory 256 words

module dmem (
    
        input logic         clk,
        input logic         we,
        input logic  [3:0]  byteEnable,
        input logic  [31:0] a,
        input logic  [31:0] wd, // WriteDataM

        output logic [31:0] rd

    );

    logic [31:0] RAM[255:0];
    
    initial $readmemh("./memory/dmem.mem", RAM);

    assign rd = RAM[ a[31:2] ];

    always_ff @(posedge clk) begin

        if (we) begin

            for (int i = 0; i < 4; i++) begin

                if (byteEnable[i])
                    RAM[a[31:2]][i*8 +: 8] <= wd[i*8 +: 8];

            end

        end

    end

    // always_ff @(posedge clk) begin

    //     if (we) 
        
    //         assert(byteEnable != 4'b0000);

    //         if (byteEnable[0])
    //             RAM[ a[31:2] ][7:0] <= wd[7:0];

    //         if (byteEnable[1])
    //             RAM[ a[31:2] ][15:8] <= wd[15:8];

    //         if (byteEnable[2])
    //             RAM[ a[31:2] ][23:16] <= wd[23:16];

    //         if (byteEnable[3])
    //             RAM[ a[31:2] ][31:24] <= wd[31:24];

    //         rd <= RAM[ a[31:2] ];

    // end

endmodule // Data memory