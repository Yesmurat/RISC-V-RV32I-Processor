module wb_stage (
    
        input logic         clk,
        input logic         reset,

        // MEM stage control signals
        input logic         RegWriteM,
        input logic  [1:0]  ResultSrcM,

        // WB stage signals
        output logic        RegWriteW,

        // datapath inputs & outputs
        input logic  [31:0] ALUResultM,
        input logic  [31:0] load_data,
        input logic  [4:0]  RdM,
        input logic  [31:0] ImmExtM,
        input logic  [31:0] PCPlus4M,

        output logic [4:0]  RdW,
        output logic ResultW,

);

    logic [1:0] ResultSrcW;

    logic [31:0] ALUResultW;
    logic [31:0] ReadDataW;
    logic [31:0] PCPlus4W;
    logic [31:0] ImmExtW;

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin
            
            RegWriteW <= 1'b0;
            ResultSrcW <= 2'b0;

            ALUResultW <= 32'b0;
            ReadDataW <= 32'b0;
            RdW <= 5'b0;
            ImmExtW <= 32'b0;
            PCPlus4W <= 32'b0;

        end
        
        else begin

            RegWriteW <= RegWriteM;
            ResultSrcW <= ResultSrcM;

            ALUResultW <= ALUResultM;
            ReadDataW <= load_data;
            RdW <= RdM;
            ImmExtW <= ImmExtM;
            PCPlus4W <= PCPlus4M;

        end

    end

    mux4 ResultWmux(

        .d0     (ALUResultW),
        .d1     (ReadDataW),
        .d2     (PCPlus4W),
        .d3     (ImmExtW),
        .s      (ResultSrcW),
        .y      (ResultW)

    );

endmodule