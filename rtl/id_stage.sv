module id_stage (
    
        input logic         clk,
        input logic         reset,

        input logic          RegWriteW,
        input logic [4:0]    RdW,
        input logic [31:0]   ResultW,

        ifid_if.rd inputs,
        idex_if.wr outputs

);

    logic [31:0] Instr;
    logic [31:0] PC;
    logic [31:0] PCPlus4;
    logic [1:0] ImmSrc;

    assign Instr = inputs.data.instr;

    controller control_unit(

        .opcode         ( Instr[6:0]              ),
        .funct3         ( Instr[14:12]            ),
        .funct7b5       ( Instr[30]               ),

        .RegWriteD      ( outputs.ctrl.RegWrite   ),
        .ResultSrcD     ( outputs.ctrl.ResultSrc  ),
        .MemWriteD      ( outputs.ctrl.MemWrite   ),
        .JumpD          ( outputs.ctrl.Jump       ),
        .BranchD        ( outputs.ctrl.Branch     ),
        .ALUControlD    ( outputs.ctrl.ALUControl ),
        .ALUSrcD        ( outputs.ctrl.ALUSrc     ),
        .ImmSrcD        ( ImmSrc                  ),
        .SrcAsrcD       ( outputs.ctrl.SrcAsrc    ),
        .jumpRegD       ( outputs.ctrl.jumpReg    )

    );

    regfile register_file(

        .clk    ( clk              ),
        .we3    ( RegWriteW        ),
        .reset  ( reset            ),

        .a1     ( Instr[19:15]     ),
        .a2     ( Instr[24:20]     ),

        .a3     ( RdW              ),
        .wd3    ( ResultW          ),

        .rd1    ( outputs.data.RD1 ),
        .rd2    ( outputs.data.RD2 )

    );

    extend immediate_extend(

        .instr_31_7     ( Instr[31:7]         ),
        .immsrc         ( ImmSrc              ),

        .immext         ( outputs.data.ImmExt )

    );

    assign outputs.data.PC = inputs.data.PC;
    assign outputs.data.PCPlus4 = inputs.data.PCPlus4;

    assign outputs.data.Rs1 = Instr[19:15];
    assign outputs.data.Rs2 = Instr[24:20];
    assign outputs.data.Rd =  Instr[11:7];

endmodule