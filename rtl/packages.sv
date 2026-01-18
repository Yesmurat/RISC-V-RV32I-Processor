package pipeline_pkg;

    localparam XLEN = 64;
    
    // IFID
    typedef struct packed {

        logic [31:0] instr;
        logic [XLEN-1:0] PC;
        logic [XLEN-1:0] PCPlus4;

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
        logic       is_word_op;

        // data
        logic [XLEN-1:0] RD1, RD2;
        logic [XLEN-1:0] PC;
        logic [XLEN-1:0] ImmExt;
        logic [XLEN-1:0] PCPlus4;
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
        logic [XLEN-1:0] ALUResult;
        logic [XLEN-1:0] WriteData;
        logic [XLEN-1:0] PCPlus4;
        logic [XLEN-1:0] ImmExt;
        logic [4:0]  Rd;

    } exmem_t;

    // MEMWB
    typedef struct packed {

        // control
        logic       RegWrite;
        logic [1:0] ResultSrc;

        // data
        logic [XLEN-1:0] ALUResult;
        logic [XLEN-1:0] load_data;
        logic [XLEN-1:0] ImmExt;
        logic [XLEN-1:0] PCPlus4;
        logic [4:0]  Rd;

    } memwb_t;

endpackage

package hazard_io;

    typedef struct packed {

        logic [4:0] Rs1D;
        logic [4:0] Rs2D;
        logic [4:0] Rs1E;
        logic [4:0] Rs2E;
        logic [4:0] RdE;
        logic [4:0] RdM;
        logic [4:0] RdW;

        logic       ResultSrcE_zero;
        logic       PCSrcE;
        logic       RegWriteM;
        logic       RegWriteW;

    } hazard_in;

    typedef struct packed {
        
        logic       StallF;
        logic       StallD;
        logic       FlushD;
        logic       FlushE;
        logic [1:0] ForwardAE;
        logic [1:0] ForwardBE;

    } hazard_out;

endpackage

package control_pkg;

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
        logic       is_word_op;
        
    } control_signals;

    typedef enum logic {

        // rv32
        load   = 7'b0000011, // same for rv32 & rv64
        store  = 7'b0100011, // same for rv32 & rv64
        r_type  = 7'b0110011,
        i_type  = 7'b0010011,
        branch = 7'b1100011,
        lui    = 7'b0110111,
        auipc  = 7'b0010111,
        jal    = 7'b1101111,
        jalr   = 7'b1100111,

        // rv64
        i_type64 = 7'b0011011,
        sd       = 7'b0100011,
        r_type64 = 7'b0111011


    } opcodes;

    localparam [3:0]

        ADD = 4'b0000,
        SUB = 4'b0001,
        AND = 4'b0010,
        OR = 4'b0011,
        XOR = 4'b0100,
        SLT = 4'b0101,
        SLTU = 4'b0110,
        SLL = 4'b0111,
        SRL = 4'b1000,
        SRA = 4'b1001;

endpackage