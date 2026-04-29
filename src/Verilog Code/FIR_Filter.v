`timescale 1ns / 1ps

module FIR_Filter(clk, reset, data_in, data_out);

parameter N = 16;
parameter COEFF_W = 8;
parameter SCALE_BITS = 7;

input  clk, reset;
input  signed [N-1:0] data_in;
output reg signed [N-1:0] data_out;

// Symmetric 4-tap low-pass FIR coefficients in Q1.7 format.
// h = [0.125, 0.375, 0.375, 0.125] => [16, 48, 48, 16]
localparam signed [COEFF_W-1:0] b0 = 8'sd16;
localparam signed [COEFF_W-1:0] b1 = 8'sd48;
localparam signed [COEFF_W-1:0] b2 = 8'sd48;
localparam signed [COEFF_W-1:0] b3 = 8'sd16;

wire signed [N-1:0] x1, x2, x3;

DFF DFF0(clk, reset, data_in, x1);
DFF DFF1(clk, reset, x1, x2);
DFF DFF2(clk, reset, x2, x3);

wire signed [N+COEFF_W-1:0] mul0, mul1, mul2, mul3;
wire signed [N+COEFF_W+1:0] acc_sum;
wire signed [N+COEFF_W+1:0] scaled_sum;

assign mul0 = data_in * b0;
assign mul1 = x1      * b1;
assign mul2 = x2      * b2;
assign mul3 = x3      * b3;

assign acc_sum    = mul0 + mul1 + mul2 + mul3;
assign scaled_sum = acc_sum >>> SCALE_BITS;

always @(posedge clk or posedge reset) begin
    if (reset)
        data_out <= '0;
    else
        data_out <= scaled_sum[N-1:0];
end

endmodule


module DFF(clk, reset, data_in, data_delayed);
parameter N = 16;

input  clk, reset;
input  signed [N-1:0] data_in;
output reg signed [N-1:0] data_delayed;

always @(posedge clk or posedge reset) begin
    if (reset)
        data_delayed <= '0;
    else
        data_delayed <= data_in;
end

endmodule
