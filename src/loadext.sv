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

                    2'b00: load_data = {{24{RD_data[7]}}, RD_data[7:0]};

                    2'b01: load_data = {{24{RD_data[15]}}, RD_data[15:8]};

                    2'b10: load_data = {{24{RD_data[23]}}, RD_data[23:16]};

                    2'b11: load_data = {{24{RD_data[31]}}, RD_data[31:24]};

                endcase
                
            end

            3'b100: begin // lbu

                case (byteAddrM)

                    2'b00: load_data = {24'b0, RD_data[7:0]};

                    2'b01: load_data = {24'b0, RD_data[15:8]};

                    2'b10: load_data = {24'b0, RD_data[23:16]};

                    2'b11: load_data = {24'b0, RD_data[31:24]};

                endcase
                
            end

            3'b001: begin

                if (byteAddrM[1] == 1'b0) begin // lh

                    load_data = {{16{RD_data[15]}}, RD_data[15:0]};
                    
                end


                else begin

                    load_data = {{16{RD_data[31]}}, RD_data[31:16]};
                    
                end
                
            end

            3'b101: begin

                if (byteAddrM[1] == 1'b0) begin // lhu

                    load_data = {16'b0, RD_data[15:0]};

                end
                    
                else begin

                    load_data = {16'b0, RD_data[31:16]};
                    
                end

            end

            3'b010: begin

                load_data = RD_data; // lw
                
            end

            default: begin

                load_data = 32'b0;
                
            end

        endcase

    end
    
endmodule