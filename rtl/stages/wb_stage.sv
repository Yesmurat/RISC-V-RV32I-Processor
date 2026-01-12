(* dont_touch = "true" *)

import pipeline_pkg::memwb_t;

module wb_stage (

        input memwb_t inputs,
        
        output logic        RegWriteW,
        output logic [4:0]  RdW,
        output logic [31:0] ResultW

);

    mux4 ResultWmux(

        .d0     ( inputs.ALUResult ),
        .d1     ( inputs.load_data ),
        .d2     ( inputs.PCPlus4    ),
        .d3     ( inputs.ImmExt    ),
        .s      ( inputs.ResultSrc ),
        .y      ( ResultW               )

    );

    assign RdW = inputs.Rd;
    assign RegWriteW = inputs.RegWrite;

endmodule