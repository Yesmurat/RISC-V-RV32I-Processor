`timescale 1ns/1ps

module loadext #(
    
    parameter XLEN = 32
    
) (

    input logic  [2:0]  funct3,
    input logic  [XLEN-1:0] RD_data,
    input logic  [ $clog2(XLEN/8)-1 : 0 ]  byteAddrM,
    
    output logic [XLEN-1:0] load_data

);

    localparam int BYTE_W = 8;
    localparam int HWORD_W = 16;

    logic [BYTE_W-1:0] byte_value;
    logic [HWORD_W-1:0] hword_value;

    always_comb begin

        load_data = '0;

        byte_value  = RD_data[ byteAddrM * 8 +: 8 ];

        hword_value = RD_data[ {byteAddrM[$clog2(XLEN/8)-1:1], 1'b0} * BYTE_W +: HWORD_W ];

        unique case (funct3)

            3'b000: load_data = $signed(byte_value); // load byte

            3'b001: load_data = $signed(hword_value); // load half

            3'b010: load_data = RD_data[31:0]; // load word

            3'b100: load_data = $unsigned(byte_value); // load byte unsigned

            3'b101: load_data = $unsigned(hword_value); // load half unsigned

            3'b011: load_data = RD_data; // load double word

            3'b110: load_data = $unsigned(RD_data); // load word unsigned

            default: load_data = '0;

        endcase

    end
    
endmodule