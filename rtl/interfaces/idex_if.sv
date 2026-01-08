interface idex_if;

    typedef struct packed {

        logic       RegWrite;
        logic [1:0] ResultSrc;
        logic       MemWrite;
        logic       Jump;
        logic       Branch;
        logic [2:0] ALUControl;
        logic       ALUSrc;
        logic       SrcAsrc;
        logic [2:0] funct3;
        logic       jumpReg;

    } ctrl_t;

    typedef struct packed {

        logic [31:0] RD1, RD2;
        logic [31:0] PC;
        logic [31:0] ImmExt;
        logic [31:0] PCPlus4;
        logic [4:0]  Rs1, Rs2, Rd;

    } data_t;

    ctrl_t ctrl;
    data_t data;

    modport wr ( output ctrl, data );

    modport rd ( input ctrl, data );

endinterface