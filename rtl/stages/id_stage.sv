import pipeline_pkg::ifid_t;
import pipeline_pkg::idex_t;

module id_stage (
    
        input logic         clk,
        input logic         reset,

        input logic          RegWriteW,
        input logic [4:0]    RdW,
        input logic [31:0]   ResultW,

        input ifid_t inputs,
        output idex_t outputs

);

    logic [31:0] Instr;
    logic [2:0] ImmSrc;

    assign Instr = inputs.instr;

    controller control_unit(

        .opcode         ( Instr[6:0]              ),
        .funct3         ( Instr[14:12]            ),
        .funct7b5       ( Instr[30]               ),

        .RegWriteD      ( outputs.RegWrite   ),
        .ResultSrcD     ( outputs.ResultSrc  ),
        .MemWriteD      ( outputs.MemWrite   ),
        .JumpD          ( outputs.Jump       ),
        .BranchD        ( outputs.Branch     ),
        .ALUControlD    ( outputs.ALUControl ),
        .ALUSrcD        ( outputs.ALUSrc     ),
        .ImmSrcD        ( ImmSrc             ),
        .SrcAsrcD       ( outputs.SrcAsrc    ),
        .jumpRegD       ( outputs.jumpReg    )

    );

    regfile register_file(

        .clk    ( clk              ),
        .we3    ( RegWriteW        ),
        .reset  ( reset            ),

        .a1     ( Instr[19:15]     ),
        .a2     ( Instr[24:20]     ),

        .a3     ( RdW              ),
        .wd3    ( ResultW          ),

        .rd1    ( outputs.RD1      ),
        .rd2    ( outputs.RD2      )

    );

    extend immediate_extend(

        .instr_31_7     ( Instr[31:7]         ),
        .immsrc         ( ImmSrc              ),

        .immext         ( outputs.ImmExt      )

    );

    assign outputs.PC = inputs.PC;
    assign outputs.PCPlus4 = inputs.PCPlus4;

    assign outputs.Rs1 = Instr[19:15];
    assign outputs.Rs2 = Instr[24:20];
    assign outputs.Rd =  Instr[11:7];

    assign outputs.funct3 = Instr[14:12];

endmodule