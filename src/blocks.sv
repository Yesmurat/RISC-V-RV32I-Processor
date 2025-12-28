module mux2 (
    
        input logic  [31:0] d0, d1,
        input logic         s,
        output logic [31:0] y

    );
    
    assign y = s ? d1: d0;
    
endmodule // 2-to-1 multiplexer

module mux3 (
    
        input logic  [31:0] d0, d1, d2,
        input logic  [1:0]  s,
        output logic [31:0] y
        
    );
    
    assign y = s[1] ? d2 : (s[0] ? d1 : d0);

endmodule // 3-to-1 mux

module mux4 (
    
        input logic  [31:0] d0, d1, d2, d3,
        input logic  [1:0]  s,
        output logic [31:0] y
        
    );
    
    always_comb begin

        case (s)

            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            2'b11: y = d3;
            default: y = 32'b0;
            
        endcase

    end

endmodule // 4-to-1 mux

module branch_unit (
    
        input logic [31:0] SrcAE, SrcBE,
        input logic [2:0]  funct3E,
        output logic       branchTakenE

);

    logic eqE, ltE, ltuE;

    assign eqE = (SrcAE == SrcBE);
    assign ltE = $signed(SrcAE) < $signed(SrcBE);
    assign ltuE = $unsigned(SrcAE) < $unsigned(SrcBE);

    always_comb begin

        case (funct3E)

            3'b000: branchTakenE = eqE; // beq

            3'b001: branchTakenE = !eqE; // bne

            3'b100: branchTakenE = ltE; // blt

            3'b101: branchTakenE = !ltE; // bge

            3'b110: branchTakenE = ltuE; // bltu

            3'b111: branchTakenE = !ltuE; // bgeu

            default: branchTakenE =  1'b0;

        endcase

    end
    
endmodule // Branch unit