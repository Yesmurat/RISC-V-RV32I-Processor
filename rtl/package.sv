package pipeline_pkg;
    
    // IFID
    typedef struct packed {

        logic [31:0] instr;
        logic [31:0] PC;
        logic [31:0] PCPlus4;

    } ifid_t;

    // IDEX
    typedef struct packed {

        // control
        logic       RegWrite;
        logic [1:0] ResultSrc;
        logic       MemWrite;
        logic       Jump;
        logic       Branch;
        logic [3:0] ALUControl;
        logic       ALUSrc;
        logic       SrcAsrc;
        logic [2:0] funct3;
        logic       jumpReg;

        // data
        logic [31:0] RD1, RD2;
        logic [31:0] PC;
        logic [31:0] ImmExt;
        logic [31:0] PCPlus4;
        logic [4:0]  Rs1, Rs2, Rd;

    } idex_t;

    // EXMEM
    typedef struct packed {

        // control
        logic       RegWrite;
        logic [1:0] ResultSrc;
        logic       MemWrite;
        logic [2:0] funct3;

        // data
        logic [31:0] ALUResult;
        logic [31:0] WriteData;
        logic [31:0] PCPlus4;
        logic [31:0] ImmExt;
        logic [4:0]  Rd;

    } exmem_t;

    // MEMWB
    typedef struct packed {

        // control
        logic       RegWrite;
        logic [1:0] ResultSrc;

        // data
        logic [31:0] ALUResult;
        logic [31:0] load_data;
        logic [31:0] ImmExt;
        logic [31:0] PCPlus4;
        logic [4:0]  Rd;

    } memwb_t;

endpackage