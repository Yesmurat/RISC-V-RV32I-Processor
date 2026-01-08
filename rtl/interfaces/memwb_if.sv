interface memwb_if;

    typedef struct packed {

        logic       RegWrite;
        logic [1:0] ResultSrc;

    } ctrl_t;

    typedef struct packed {

        logic [31:0] ALUResult;
        logic [31:0] load_data;
        logic [31:0] ImmExt;
        logic [31:0] PCPlus4;
        logic [4:0]  Rd;

    } data_t;

    ctrl_t ctrl;
    data_t data;

    modport wr (output ctrl, output data);

    modport rd (input ctrl, input data);

endinterface