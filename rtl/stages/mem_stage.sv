import pipeline_pkg::exmem_t;
import pipeline_pkg::memwb_t;

module mem_stage (
    
        input logic clk,

        input exmem_t inputs,
        output memwb_t outputs,

        output logic [31:0] ALUResultM,

        // outputs to hazard unit
        output logic [4:0] RdM,
        output logic RegWriteM

);

    logic [3:0] byteEnable;
    logic [31:0] RD_data;

    (* dont_touch = "true" *) wdext wdext(

        .MemWriteM  ( inputs.MemWrite ),
        .byteAddrM  ( inputs.ALUResult[1:0] ),
        .funct3M    ( inputs.funct3 ),
        
        .byteEnable ( byteEnable )

    );

    dmem data_memory(

        .clk            ( clk ),
        .we             ( inputs.MemWrite ),
        .byteEnable     ( byteEnable ),
        .address        ( inputs.ALUResult[31:2] ),
        .wd             ( inputs.WriteData ), // WriteDataM

        .rd             ( RD_data )

    );

    (* dont_touch = "true" *) loadext loadext(

        .LoadTypeM  ( inputs.funct3 ),
        .RD_data    ( RD_data ),
        .byteAddrM  ( inputs.ALUResult[1:0] ),

        .load_data  ( outputs.load_data )

    );

    assign outputs.RegWrite = inputs.RegWrite;
    assign outputs.ResultSrc = inputs.ResultSrc;

    assign outputs.ALUResult = inputs.ALUResult;
    assign outputs.Rd = inputs.Rd;
    assign outputs.PCPlus4 = inputs.PCPlus4;
    assign outputs.ImmExt = inputs.ImmExt;

    assign RdM = inputs.Rd;
    assign RegWriteM = inputs.RegWrite;

    assign ALUResultM = inputs.ALUResult;

endmodule