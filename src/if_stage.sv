module if_stage (
    
        input logic         clk,
        input logic         en,
        input logic         reset,
        input logic  [31:0] PCF_new,

        output logic [31:0] PCF,
        output logic [31:0] RD_instr,
        output logic [31:0] PCPlus4F
        
    );

    assign PCPlus4F = PCF + 32'd4;
    
    always_ff @(posedge clk or posedge reset) begin

        if (reset)
            PCF <= 32'b0;

        else if (en)
            PCF <= PCF_new;

        else
            PCF <= 32'b0;
        
    end

    imem instr_mem(

        .a  (PCF),
        .rd (RD_instr)

    );

endmodule // IF stage