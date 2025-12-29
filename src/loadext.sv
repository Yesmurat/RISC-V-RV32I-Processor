`timescale 1ns/1ps

module loadext (

    input logic  [2:0]  LoadTypeM, // funct3M
    input logic  [31:0] RD_data,
    input logic  [1:0]  byteAddrM,
    output logic [31:0] load_data

);

    always_comb begin

        unique case (LoadTypeM)

            3'b000: begin // lb

                unique case (byteAddrM)

                    2'b00: load_data = {{24{RD_data[7]}}, RD_data[7:0]}; // sign-extended bits 7:0

                    2'b01: load_data = {{24{RD_data[15]}}, RD_data[15:8]}; // sign-extended bits 15:8

                    2'b10: load_data = {{24{RD_data[23]}}, RD_data[23:16]}; // sign-extended bits 23:16

                    2'b11: load_data = {{24{RD_data[31]}}, RD_data[31:24]}; // sign-extended bits 31:24

                endcase
                
            end

            3'b100: begin // lbu

                case (byteAddrM)

                    2'b00: load_data = {24'b0, RD_data[7:0]}; // zero-extended bits 7:0

                    2'b01: load_data = {24'b0, RD_data[15:8]}; // zero-extended bits 15:8

                    2'b10: load_data = {24'b0, RD_data[23:16]}; // zero-extended bits 23:16

                    2'b11: load_data = {24'b0, RD_data[31:24]}; // zero-extended bits 31:24

                endcase
                
            end

            3'b001: begin // lh

                if (byteAddrM[1] == 1'b0) begin

                    load_data = {{16{RD_data[15]}}, RD_data[15:0]};
                    
                end // first half


                else begin

                    load_data = {{16{RD_data[31]}}, RD_data[31:16]};
                    
                end // second half
                
            end

            3'b101: begin // lhu

                if (byteAddrM[1] == 1'b0) begin

                    load_data = {16'b0, RD_data[15:0]};

                end // first half
                    
                else begin

                    load_data = {16'b0, RD_data[31:16]};
                    
                end // second half

            end

            3'b010: begin

                load_data = RD_data; // lw
                
            end

        endcase

    end
    
endmodule