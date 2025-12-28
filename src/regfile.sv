`timescale 1ns/1ps

module regfile (
    
        input logic          clk, we3, reset,
        input logic  [4:0]   a1, a2, a3,
        input logic  [31:0]  wd3,

        output logic [31:0]  rd1, rd2
        
    );

    logic [31:0] rf[31:0];

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin

            integer i;
            for (i = 0; i < 32; i=i+1)
                rf[i] <= 32'b0;
        end
        
        else if (we3) begin

            rf[a3] <= wd3;
            
        end

    end

    // The register file is write-first and read occurs after write
    always_comb begin

        // port 1
        if ( we3 && (a3 == a1) ) rd1 = wd3;

        else if ( a1 == 0 ) rd1 = 32'b0;

        else rd1 = rf[a1];

        // port 2
        if ( we3 && (a3 == a2) ) rd2 = wd3;

        else if ( a2 == 0 ) rd2 = 32'b0;

        else rd2 = rf[a2];

    end

endmodule // Register file