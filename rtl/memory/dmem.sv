`timescale 1ns/1ps

module dmem (
    
        input logic             clk,
        input logic             we,
        input logic  [3:0]      byteEnable,

        input logic  [29:0]     address,
        input logic  [31:0]     wd, // WriteDataM

        output logic [31:0]     rd

    );

    logic [31:0] RAM[255:0];
    
    initial $readmemh("./dmem.mem", RAM);

    always_ff @(posedge clk) begin

        if (we) begin

            if (byteEnable[0])
                RAM[ address ] [7:0] <= wd[7:0];

            if (byteEnable[1])
                RAM[ address ] [15:8] <= wd[15:8];

            if (byteEnable[2])
                RAM[ address ] [23:16] <= wd[23:16];

            if (byteEnable[3])
                RAM[ address ] [31:24] <= wd[31:24];

        end

        else begin

            rd <= RAM[ address ];
            
        end

    end

endmodule // Data memory