import pipeline_pkg::exmem_t;
import pipeline_pkg::memwb_t;

module mem_stage #(
    
    parameter XLEN = 32,
    parameter ADDR_WIDTH = 8
    
    ) (
    
        input logic clk,

        input exmem_t inputs,
        output memwb_t outputs,

        output logic [XLEN-1:0] ALUResultM,

        // outputs to hazard unit
        output logic [4:0] RdM,
        output logic RegWriteM

);

    logic [XLEN/8-1:0] byteEnable;
    logic [XLEN-1:0] RD_data;

    (* dont_touch = "true" *) wdext #(.XLEN(XLEN)) wdext(

        .MemWriteM  ( inputs.MemWrite ),
        .byteAddrM  ( inputs.ALUResult[ $clog2(XLEN/8)-1 : 0 ] ),
        .funct3M    ( inputs.funct3 ),
        
        .byteEnable ( byteEnable )

    );

    dmem #(

        .XLEN(XLEN),
        .ADDR_WIDTH(ADDR_WIDTH)

    ) data_memory(

        .clk            ( clk ),
        .we             ( inputs.MemWrite ),
        .byteEnable     ( byteEnable ),
        .address        ( inputs.ALUResult[ADDR_WIDTH-1:0] ),
        .wd             ( inputs.WriteData ), // WriteDataM

        .rd             ( RD_data )

    );

    (* dont_touch = "true" *) loadext #(.XLEN(XLEN)) loadext(

        .LoadTypeM  ( inputs.funct3 ),
        .RD_data    ( RD_data ),
        .byteAddrM  ( inputs.ALUResult[ $clog2(XLEN/8)-1 : 0 ] ),

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