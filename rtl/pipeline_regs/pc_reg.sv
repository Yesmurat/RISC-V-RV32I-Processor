module pc_reg (

    input logic         clk,
    input logic         en,
    input logic         reset,

    input logic [31:0]  PC_new,
    output logic [31:0] PC
    
);

    always_ff @( posedge clk or posedge reset ) begin : pc_register

        if (reset) begin
            PC <= '0;
        end

        else if (en) begin
            PC <= PC_new;    
        end

    end
    
endmodule