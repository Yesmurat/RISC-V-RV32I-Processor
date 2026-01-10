/*
Try to instantiate this moduel inside dmem.sv so that all bits of ALUResultM are read by memory and wdext
*/

module wdext (

    input logic MemWriteM,
    input logic [1:0] byteAddrM,
    input logic [2:0] funct3M,
    output logic [3:0] byteEnable

);

    always_comb begin

        byteEnable = 4'b0000;

        if (MemWriteM) begin

            unique case (funct3M)

                3'b000: begin // sb

                    case (byteAddrM)

                        2'b00: byteEnable = 4'b0001;
                        2'b01: byteEnable = 4'b0010;
                        2'b10: byteEnable = 4'b0100;
                        2'b11: byteEnable = 4'b1000;

                    endcase

                end

                3'b001: begin // sh

                    byteEnable = (byteAddrM[1] == 1'b0) ? 4'b0011 : 4'b1100;

                end

                3'b010: begin // SW

                    byteEnable = 4'b1111;

                end

                default: begin

                    byteEnable = 4'b0000;
                    
                end

            endcase

        end

    end
    
endmodule