module ifid_reg (

    input logic clk,
    input logic en,
    input logic reset,

    input if_data_t inputs,
    output if_data_t outputs
    
);

    always_ff @( posedge clk or posedge reset ) begin : ifid_register
        
        if (reset) begin
            outputs <= '0;
        end

        else if (en) begin
            outputs <= inputs;    
        end

    end
    
endmodule