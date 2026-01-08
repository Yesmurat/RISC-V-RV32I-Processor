module if_stage (
    
        input logic         clk,
        input logic         en,
        input logic         reset,
        input logic  [31:0] PCF_new,
        
        ifid_if.wr outputs
        
    );

    assign outputs.data.PCPlus4 = outputs.data.PC + 32'd4;
    
    always_ff @(posedge clk or posedge reset) begin

        if (reset)
            outputs.data.PC <= 32'b0;

        else if (en)
            outputs.data.PC <= PCF_new;
        
    end

    imem instr_mem(

        .a  (outputs.data.PC),
        .rd (outputs.data.instr)

    );

endmodule // IF stage