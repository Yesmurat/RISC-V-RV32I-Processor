module mem_stage (
    
        input logic clk,
        input logic reset,

        exmem_if.rd inputs,
        memwb_if.wr outputs

);

    logic [3:0] byteEnable;
    logic [31:0] RD_data;

    wdext wdext(

        .MemWriteM  (inputs.ctrl.MemWrite),
        .byteAddrM  (inputs.data.ALUResult[1:0]),
        .funct3M    (inputs.ctrl.funct3),
        
        .byteEnable (byteEnable)

    );

    dmem data_memory(

        .clk        (clk),
        .we         (inputs.ctrl.MemWrite),
        .byteEnable (byteEnable),
        .a          (inputs.data.ALUResult),
        .wd         (inputs.data.WriteData), // WriteDataM

        .rd         (RD_data)

    );

    loadext loadext(

        .LoadTypeM  (inputs.ctrl.funct3),
        .RD_data    (RD_data),
        .byteAddrM  (inputs.data.ALUResult[1:0]),

        .load_data  (outputs.data.load_data)

    );

    assign outputs.ctrl.RegWrite = inputs.ctrl.RegWrite;
    assign outputs.ctrl.ResultSrc = inputs.ctrl.ResultSrc;

    assign outputs.data.ALUResult = inputs.data.ALUResult;
    assign outputs.data.Rd = inputs.data.Rd;
    assign outputs.data.PCPlus4 = inputs.data.PCPlus4;
    assign outputs.data.ImmExt = inputs.data.ImmExt;

endmodule