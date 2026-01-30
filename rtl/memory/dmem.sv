`timescale 1ns/1ps

module dmem #(

        parameter XLEN = 32,
        parameter ADDR_WIDTH = 8 // 256 words

        ) (
    
        input logic                     clk,
        input logic                     we,
        input logic  [XLEN/8-1:0]       byteEnable,
        
        input logic  [ADDR_WIDTH-1:0]   address,
        input logic  [XLEN-1:0]         wd, // WriteDataM

        output logic [XLEN-1:0]         rd

    );

    logic [XLEN-1:0] Dmem[ 2**ADDR_WIDTH-1 : 0 ];
    
    initial $readmemh("./dmem.mem", Dmem);

    always_ff @(posedge clk) begin

        if (we) begin

            integer i;
            for (i = 0; i < XLEN/8; i = i + 1) begin

                if (byteEnable[i])
                    Dmem[address][8*i +: 8] <= wd[8*i +: 8];

            end

        end

        else begin

            rd <= Dmem[ address ];
            
        end

    end

endmodule // Data memory