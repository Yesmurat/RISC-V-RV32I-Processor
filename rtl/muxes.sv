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

        unique case (s)

            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            2'b11: y = d3;
            
        endcase

    end

endmodule // 4-to-1 mux