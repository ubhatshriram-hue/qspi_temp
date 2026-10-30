`timescale 1ns / 1ps

`default_nettype none
module Sync #(
    parameter WIDTH = 9
)(
    input  wire             clk,
    input  wire             rst,
    input  wire [WIDTH-1:0] din,
    output wire [WIDTH-1:0] q
);

    reg [WIDTH-1:0] ff1;
    reg [WIDTH-1:0] ff2;

    always @(posedge clk or negedge rst) begin

        if (!rst) begin
            ff1 <= {WIDTH{1'b0}};
            ff2 <= {WIDTH{1'b0}};
        end
        else begin
            ff1 <= din;
            ff2 <= ff1;
        end

    end

    assign q = ff2;

endmodule





