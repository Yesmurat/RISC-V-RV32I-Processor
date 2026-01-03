module mem_stage (
    
        input logic clk,
        input logic reset,

        // control IO
        input logic         RegWriteE,
        input logic  [1:0]  ResultSrcE,
        input logic         MemWriteE,
        input logic  [2:0]  funct3E,

        output logic        RegWriteM,
        output logic [1:0]  ResultSrcM,

        // datapath IO
        input logic  [31:0] ALUResultE,
        input logic  [31:0] WriteDataE,
        input logic  [4:0]  RdE,
        input logic  [31:0] ImmExtE,
        input logic  [31:0] PCPlus4E,

        output logic [31:0] ALUResultM,
        output logic [31:0] load_data,
        output logic [4:0]  RdM,
        output logic [31:0] ImmExtM,
        output logic [31:0] PCPlus4M

);

    logic [31:0] WriteDataM;
    logic        MemWriteM;
    logic [2:0]  funct3M;
    logic [3:0]  byteEnable;

    logic [31:0] RD_data;

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin
            
            RegWriteM <= 1'b0;
            ResultSrcM <= 2'b0;
            MemWriteM <= 1'b0;
            funct3M <= 3'b0;

            ALUResultM <= 32'b0;
            WriteDataM <= 32'b0;
            RdM <= 5'b0;
            ImmExtM <= 32'b0;
            PCPlus4M <= 32'b0;

        end
        
        else begin

            RegWriteM <= RegWriteE;
            ResultSrcM <= ResultSrcE;
            MemWriteM <= MemWriteE;
            funct3M <= funct3E;

            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
            RdM <= RdE;
            ImmExtM <= ImmExtE;
            PCPlus4M <= PCPlus4E;

        end

    end

    // wdext

    wdext wdext(

        .MemWriteM  (MemWriteM),
        .byteAddrM  (ALUResultM[1:0]),
        .funct3M    (funct3M),
        
        .byteEnable (byteEnable)

    );

    // dmem

    dmem data_memory(

        .clk        (clk),
        .we         (MemWriteM),
        .byteEnable (byteEnable),
        .a          (ALUResultM),
        .wd         (WriteDataM), // WriteDataM

        .rd         (RD_data)

    );

    // loadext

    loadext loadext(

        .LoadTypeM(funct3M), // funct3M
        .RD_data(RD_data),
        .byteAddrM(ALUResultM[1:0]),

        .load_data(load_data)

    );

endmodule