typedef struct packed {

    logic [1:0] ResultSrcD;
    logic       MemWriteD;
    logic       BranchD;
    logic       ALUSrcD;
    logic       RegWriteD;
    logic       JumpD;
    logic [2:0] ImmSrcD;
    logic [1:0] ALUOp;
    logic       SrcAsrcD;
    logic       jumpRegD;
    
} control_signals;