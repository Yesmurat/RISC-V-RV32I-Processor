interface ifid_if;

    typedef struct packed {

        logic [31:0] instr;
        logic [31:0] PC;
        logic [31:0] PCPlus4;

    } if_data_t;

    if_data_t data;

    modport wr (output data);
    modport rd (input data);
    
endinterface