import pipeline_pkg::ifid_t;

module if_stage (
    
        input logic  [31:0] PC,
        
        output ifid_t outputs
        
    );

    assign outputs.PC = PC;
    assign outputs.PCPlus4 = PC + 32'd4;

    imem instr_mem(

        .address    (PC),
        .rd         (outputs.instr)

    );

endmodule // IF stage