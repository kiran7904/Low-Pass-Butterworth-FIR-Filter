`timescale 1ns / 1ps

module FIR_TB;

parameter N = 16;

reg clk, reset;
reg signed [N-1:0] data_in;
wire signed [N-1:0] data_out;

reg signed [N-1:0] stimulus [0:15];
reg signed [N-1:0] expected [0:15];

integer idx;
integer errors;

FIR_Filter dut(
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .data_out(data_out)
);

initial begin
    stimulus[0]  = 16'sd0;
    stimulus[1]  = 16'sd32;
    stimulus[2]  = 16'sd64;
    stimulus[3]  = 16'sd96;
    stimulus[4]  = 16'sd64;
    stimulus[5]  = 16'sd32;
    stimulus[6]  = -16'sd32;
    stimulus[7]  = -16'sd64;
    stimulus[8]  = -16'sd96;
    stimulus[9]  = -16'sd64;
    stimulus[10] = -16'sd32;
    stimulus[11] = 16'sd0;
    stimulus[12] = 16'sd16;
    stimulus[13] = 16'sd0;
    stimulus[14] = -16'sd16;
    stimulus[15] = 16'sd0;

    expected[0]  = 16'sd0;
    expected[1]  = 16'sd4;
    expected[2]  = 16'sd20;
    expected[3]  = 16'sd48;
    expected[4]  = 16'sd72;
    expected[5]  = 16'sd68;
    expected[6]  = 16'sd36;
    expected[7]  = -16'sd8;
    expected[8]  = -16'sd48;
    expected[9]  = -16'sd72;
    expected[10] = -16'sd68;
    expected[11] = -16'sd36;
    expected[12] = -16'sd4;
    expected[13] = 16'sd4;
    expected[14] = 16'sd4;
    expected[15] = -16'sd2;
end

initial clk = 1'b0;
always #10 clk = ~clk;

initial begin
    errors = 0;
    data_in = '0;
    reset = 1'b1;

    repeat (2) @(posedge clk);
    reset = 1'b0;

    for (idx = 0; idx < 16; idx = idx + 1) begin
        data_in = stimulus[idx];
        @(posedge clk);
        #1;
        if (data_out !== expected[idx]) begin
            $display("FAIL idx=%0d in=%0d out=%0d exp=%0d", idx, stimulus[idx], data_out, expected[idx]);
            errors = errors + 1;
        end
    end

    if (errors == 0)
        $display("TEST PASSED: FIR filter matches expected low-pass response.");
    else
        $display("TEST FAILED: error_count=%0d", errors);

    #20 $finish;
end

endmodule
