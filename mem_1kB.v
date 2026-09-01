`timescale 1ns/1ns

module mem_1kB (
    input        clk,
    input        rst,
    input        wr,
    input  [7:0] data_in,
    input  [9:0] address,
    output reg [7:0] data_out
);

    reg [7:0] mem [0:1023];

    always @(posedge clk) begin

        if (rst) begin
            data_out <= 8'b0;
        end
        else begin

            if (wr) begin
                mem[address] <= data_in;
            end
            else begin
                data_out <= mem[address];
            end

        end

    end

endmodule