`timescale 1ns/1ps

module regfile
    #( parameter XLEN = 32 ) (
    
        input logic          clk,
        input logic          we3,
        input logic          reset,

        input logic  [4:0]   a1,
        input logic  [4:0]   a2,

        input logic  [4:0]   a3,
        input logic  [XLEN-1:0]  wd3,

        output logic [XLEN-1:0]  rd1,
        output logic [XLEN-1:0]  rd2
        
    );

    logic [XLEN-1:0] rf[31:0];

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin

            integer i;
            for (i = 0; i < 32; i=i+1)
                rf[i] <= { XLEN{1'b0} };

        end
        
        else if ( we3 && (a3 != 5'b0) ) begin

            rf[a3] <= wd3;
            
        end

    end

    always_comb begin

        // port 1
        if ( we3 && ( a3 == a1 ) )
            rd1 = wd3;

        else if (a1 == 0)
            rd1 = { XLEN{1'b0} };

        else
            rd1 = rf[a1];

        // port 2
        if (we3 && (a3 == a2))
            rd2 = wd3;
            
        else if (a2 == 0)
            rd2 = { XLEN{1'b0} };

        else
            rd2 = rf[a2];

    end


endmodule // Register file