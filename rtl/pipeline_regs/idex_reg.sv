module idex_reg (
    
    input logic clk,
    input logic en,
    input logic reset,

    idex_if.rd inputs,
    idex_if.wr outputs

);

    always_ff @( posedge clk or posedge reset ) begin : EX_register

        if (reset) begin
            outputs <= '0;
        end

        else if (en) begin
            outputs <= inputs;
        end
        
    end
    
endmodule