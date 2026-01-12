import pipeline_pkg::ifid_t;

module if_stage #(
    
        parameter XLEN = 32,
        parameter ADDR_WIDTH = 8
        
    ) (
    
        input logic  [XLEN-1:0] PC,

        output logic [XLEN-1:0] PCPlus4F,
        output ifid_t outputs
        
    );

    always_comb begin

        outputs.PC      = PC;
        outputs.PCPlus4 = PC + 'd4;
        PCPlus4F        = PC + 'd4;
        
    end

    (* dont_touch = "true" *) imem #(

        .XLEN(XLEN),
        .ADDR_WIDTH(ADDR_WIDTH)

    ) instr_mem(

        .address    ( PC[ADDR_WIDTH-1:0] ),
        .rd         (outputs.instr)

    );

endmodule // IF stage