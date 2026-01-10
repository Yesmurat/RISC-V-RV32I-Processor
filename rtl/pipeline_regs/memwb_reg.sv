module memwb_reg (
    
    input logic clk,
    input logic en,
    input logic reset,

    memwb_if.rd inputs,
    memwb_if.wr outputs
);

    always_ff @( posedge clk ) begin : memwb_register
        
        if (reset) begin
            outputs <= '0;
        end

        else if (en) begin
            outputs <= inputs;
        end

    end
    
endmodule