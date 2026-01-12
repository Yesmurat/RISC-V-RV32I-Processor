import pipeline_pkg::ifid_t;

module if_stage
    #( parameter XLEN = 32 ) (
    
        input logic  [XLEN-1:0] PC,
        output logic [XLEN-1:0] PCPlus4F,
        
        output ifid_t outputs
        
    );

    always_comb begin

        outputs.PC      = PC;
        outputs.PCPlus4 = PC + 'd4;
        PCPlus4F        = PC + 'd4;
        
    end

    (* dont_touch = "true" *) imem instr_mem(

        .address    ( PC[XLEN-1:2] ),
        .rd         (outputs.instr)

    );

endmodule // IF stage