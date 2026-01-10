module exmem_reg (

    input logic clk,
    input logic en,
    input logic reset,

    exmem_if.rd inputs,
    exmem_if.wr outputs
    
);

    always_ff @( posedge clk ) begin : exmem_register
        
        if (reset) begin
            outputs <= '0;
        end

        else if (en) begin
            outputs <= inputs;
        end
        
    end
    
endmodule