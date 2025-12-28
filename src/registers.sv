module IFregister (
    
        input logic         clk,
        input logic         en,
        input logic         reset,
        input logic  [31:0] d,
        output logic [31:0] q
        
    );
    
    always_ff @(posedge clk or posedge reset) begin

        if (reset) q <= 32'b0;

        else if (en) q <= d;

        else q <= 32'b0;
        
    end

endmodule // IF stage register

module IFIDregister (
    
        input logic         clk,
        input logic         reset,
        input logic         en,
        input logic  [31:0] RD_instr,
        input logic  [31:0] PCF,
        input logic  [31:0] PCPlus4F,
        output logic [31:0] InstrD,
        output logic [31:0] PCD,
        output logic [31:0] PCPlus4D
        
    );
    
    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin

            InstrD <= 32'b0;
            PCD <= 32'b0;
            PCPlus4D <= 32'b0;

        end

        else if (en) begin

            InstrD <= RD_instr;
            PCD <= PCF;
            PCPlus4D <= PCPlus4F;

        end
    
    end
    
endmodule // ID stage register

module IDEXregister (
    
        input logic         clk,
        input logic         reset,

        // ID stage controls signals
        input logic         RegWriteD,
        input logic [1:0]   ResultSrcD,
        input logic         MemWriteD,
        input logic         JumpD,
        input logic         BranchD,
        input logic [3:0]   ALUControlD,
        input logic         ALUSrcD,
        input logic         SrcAsrcD,
        input logic [2:0]   funct3D,
        input logic         jumpRegD,

        // EX stage control signals
        output logic        RegWriteE,
        output logic [1:0]  ResultSrcE,
        output logic        MemWriteE,
        output logic        JumpE,
        output logic        BranchE,
        output logic [3:0]  ALUControlE,
        output logic        ALUSrcE,
        output logic        SrcAsrcE,
        output logic [2:0]  funct3E,
        output logic        jumpRegE,

        // Datapath inputs & outputs
        input logic  [31:0] RD1,
        input logic  [31:0] RD2,
        input logic  [31:0] PCD,
        input logic  [4:0]  Rs1D,
        input logic  [4:0]  Rs2D,
        input logic  [4:0]  RdD,
        input logic  [31:0] ImmExtD,
        input logic  [31:0] PCPlus4D,

        output logic [31:0] RD1E,
        output logic [31:0] RD2E,
        output logic [31:0] PCE,
        output logic [4:0]  Rs1E,
        output logic [4:0]  Rs2E,
        output logic [4:0]  RdE,
        output logic [31:0] ImmExtE,
        output logic [31:0] PCPlus4E

);

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin

            RegWriteE <= 1'b0;
            ResultSrcE <= 2'b0;
            MemWriteE <= 1'b0;
            JumpE <= 1'b0;
            BranchE <= 1'b0;
            ALUControlE <= 4'b0;
            ALUSrcE <= 1'b0;
            SrcAsrcE <= 1'b0;
            funct3E <= 3'b0;
            jumpRegE <= 1'b0;


            RD1E <= 32'b0; RD2E <= 32'b0; PCE <= 32'b0;
            Rs1E <= 5'b0; Rs2E <= 5'b0; RdE <= 5'b0;
            ImmExtE <= 32'b0;
            PCPlus4E <= 32'b0;

        end
        
        else begin

            RegWriteE <= RegWriteD;
            ResultSrcE <= ResultSrcD;
            MemWriteE <= MemWriteD;
            JumpE <= JumpD;
            BranchE <= BranchD;
            ALUControlE <= ALUControlD;
            ALUSrcE <= ALUSrcD;
            SrcAsrcE <= SrcAsrcD;
            funct3E <= funct3D;
            jumpRegE <= jumpRegD;

            RD1E <= RD1; RD2E <= RD2; PCE <= PCD;
            Rs1E <= Rs1D; Rs2E <= Rs2D; RdE <= RdD;
            ImmExtE <= ImmExtD;
            PCPlus4E <= PCPlus4D;

        end

    end

endmodule

module EXMEMregister (
    
        input logic clk,
        input logic reset,

        // EX stage control signals
        input logic         RegWriteE,
        input logic  [1:0] ResultSrcE,
        input logic         MemWriteE,
        input logic  [2:0] funct3E,

        // MEM stage control signals
        output logic        RegWriteM,
        output logic [1:0]  ResultSrcM,
        output logic        MemWriteM,
        output logic [2:0]  funct3M,

        // datapath inputs & outputs
        input logic  [31:0] ALUResultE,
        input logic  [31:0] WriteDataE,
        input logic  [4:0]  RdE,
        input logic  [31:0] ImmExtE,
        input logic  [31:0] PCPlus4E,

        output logic [31:0] ALUResultM,
        output logic [31:0] WriteDataM,
        output logic [4:0]  RdM,
        output logic [31:0] ImmExtM,
        output logic [31:0] PCPlus4M

);

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

endmodule

module MEMWBregister (
    
        input logic         clk,
        input logic         reset,

        // MEM stage control signals
        input logic         RegWriteM,
        input logic  [1:0]  ResultSrcM,

        // WB stage signals
        output logic        RegWriteW,
        output logic [1:0]  ResultSrcW,

        // datapath inputs & outputs
        input logic  [31:0] ALUResultM,
        input logic  [31:0] load_data,
        input logic  [4:0]  RdM,
        input logic  [31:0] ImmExtM,
        input logic  [31:0] PCPlus4M,

        output logic [31:0] ALUResultW,
        output logic [31:0] ReadDataW,
        output logic [4:0]  RdW,
        output logic [31:0] ImmExtW,
        output logic [31:0] PCPlus4W

);

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

endmodule