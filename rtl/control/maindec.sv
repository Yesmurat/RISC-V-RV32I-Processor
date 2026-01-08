`timescale 1ns/1ps

module maindec (
    
            input logic   [6:0]     opcode,
            output logic  [1:0]     ResultSrcD,
            output logic            MemWriteD,
            output logic            BranchD,
            output logic            ALUSrcD,
            output logic            RegWriteD,
            output logic            JumpD,
            output logic  [2:0]     ImmSrcD,
            output logic  [1:0]     ALUOp,
            output logic            SrcAsrcD,
            output logic            jumpRegD
            
    );

    always_comb begin

        // {RegWrite, ImmSrc[2:0], ALUSrc, MemWrite, ResultSrc[1:0], Branch, ALUOp[1:0], Jump, SrcAsrc, jumpReg}

        unique case (opcode)

            7'b0000011: begin

                // 1'b1, 3'b000, 1'b1, 1'b0, 2'b01, 1'b0, 2'b00, 1'b0, 1'b1, 1'b1
                RegWriteD = 1'b1;
                ImmSrcD = 3'b000;
                ALUSrcD = 1'b1;
                MemWriteD = 1'b0;
                ResultSrcD = 2'b01;
                BranchD = 1'b0;
                ALUOp = 2'b00;
                JumpD = 1'b0;
                SrcAsrcD = 1'b0;
                jumpRegD = 1'b1;
                
            end // I-type (loads)

            7'b0100011: begin

            
                // 1'b0, 3'b001, 1'b1, 1'b1, 2'b00, 1'b0, 2'b00, 1'b0, 1'b1, 1'b1
                RegWriteD = 1'b0;
                ImmSrcD = 3'b001;
                ALUSrcD = 1'b1;
                MemWriteD = 1'b1;
                ResultSrcD = 2'b00;
                BranchD = 1'b0;
                ALUOp = 2'b00;
                JumpD = 1'b0;
                SrcAsrcD = 1'b0;
                jumpRegD = 1'b1;
                
            end // S-type

            7'b0110011: begin

            
                // 1'b1, 3'b000, 1'b0, 1'b0, 2'b00, 1'b0, 2'b10, 1'b0, 1'b1, 1'b1
                RegWriteD = 1'b1;
                ImmSrcD = 3'b000;
                ALUSrcD = 1'b0;
                MemWriteD = 1'b0;
                ResultSrcD = 2'b00;
                BranchD = 1'b0;
                ALUOp = 2'b10;
                JumpD = 1'b0;
                SrcAsrcD = 1'b0;
                jumpRegD = 1'b1;
                
            end // R-type

            7'b0010011: begin

                
                // 1'b1, 3'b000, 1'b1, 1'b0, 2'b00, 1'b0, 2'b10, 1'b0, 1'b1, 1'b1
                RegWriteD = 1'b1;
                ImmSrcD = 3'b000;
                ALUSrcD = 1'b1;
                MemWriteD = 1'b0;
                ResultSrcD = 2'b00;
                BranchD = 1'b0;
                ALUOp = 2'b10;
                JumpD = 1'b0;
                SrcAsrcD = 1'b0;
                jumpRegD = 1'b1;
                
            end // I-type (immediates)

            7'b1100011: begin

                // 1'b0, 3'b010, 1'b0, 1'b0, 2'b00, 1'b1, 2'b01, 1'b0, 1'b1, 1'b1
                RegWriteD = 1'b0;
                ImmSrcD = 3'b010;
                ALUSrcD = 1'b0;
                MemWriteD = 1'b0;
                ResultSrcD = 2'b00;
                BranchD = 1'b1;
                ALUOp = 2'b01;
                JumpD = 1'b0;
                SrcAsrcD = 1'b0;
                jumpRegD = 1'b1;
                
            end // B-type

            7'b0110111: begin // lui

                // 1'b1, 3'b100, 1'b1, 1'b0, 2'b11, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1
                RegWriteD = 1'b1;
                ImmSrcD = 3'b100;
                ALUSrcD = 1'b1;
                MemWriteD = 1'b0;
                ResultSrcD = 2'b11;
                BranchD = 1'b0;
                ALUOp = 2'b00;
                JumpD = 1'b0;
                SrcAsrcD = 1'b0;
                jumpRegD = 1'b1;
                
            end // U-type

            7'b0010111: begin

                // 1'b1, 3'b100, 1'b1, 1'b0, 2'b00, 1'b0, 2'b00, 1'b0, 1'b0, 1'b1
                RegWriteD = 1'b1;
                ImmSrcD = 3'b100;
                ALUSrcD = 1'b1;
                MemWriteD = 1'b0;
                ResultSrcD = 2'b00;
                BranchD = 1'b0;
                ALUOp = 2'b00;
                JumpD = 1'b0;
                SrcAsrcD = 1'b1;
                jumpRegD = 1'b1;
                
            end // auipc

            7'b1101111: begin // jal

                // 1'b1, 3'b011, 1'b0, 1'b0, 2'b10, 1'b0, 2'b00, 1'b1, 1'b1, 1'b1
                RegWriteD = 1'b1;
                ImmSrcD = 3'b011;
                ALUSrcD = 1'b0;
                MemWriteD = 1'b0;
                ResultSrcD = 2'b10;
                BranchD = 1'b0;
                ALUOp = 2'b00;
                JumpD = 1'b1;
                SrcAsrcD = 1'b1;
                jumpRegD = 1'b1;
                
            end

            7'b1100111: begin // jalr

                // 1'b1, 3'b000, 1'b0, 1'b0, 2'b10, 1'b0, 2'b00, 1'b1, 1'b1, 1'b0
                RegWriteD = 1'b1;
                ImmSrcD = 3'b000;
                ALUSrcD = 1'b0;
                MemWriteD = 1'b0;
                ResultSrcD = 2'b10;
                BranchD = 1'b0;
                ALUOp = 2'b00;
                JumpD = 1'b1;
                SrcAsrcD = 1'b0;
                jumpRegD = 1'b0;
                
            end
            
            default: begin

                RegWriteD = 1'b0;
                ImmSrcD = 3'b000;
                ALUSrcD = 1'b0;
                MemWriteD = 1'b0;
                ResultSrcD = 2'b00;
                BranchD = 1'b0;
                ALUOp = 2'b00;
                JumpD = 1'b0;
                SrcAsrcD = 1'b0;
                jumpRegD = 1'b0;
                
            end

        endcase
        
    end
    
endmodule