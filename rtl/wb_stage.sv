module wb_stage (

        memwb_if.rd inputs,
        
        output logic        RegWriteW,
        output logic [4:0]  RdW,
        output logic        ResultW

);

    mux4 ResultWmux(

        .d0     ( inputs.data.ALUResult ),
        .d1     ( inputs.data.load_data ),
        .d2     ( inputs.data.PClus4    ),
        .d3     ( inputs.data.ImmExt    ),
        .s      ( inputs.ctrl.ResultSrc ),
        .y      ( ResultW               )

    );

    assign RdW = inputs.data.Rd;
    assign RegWriteW = inputs.ctrl.RegWrite;

endmodule