`timescale 1ns/1ns

module sync_tb();
  logic clk;
  logic reset;
  logic in;
  logic out;

  sync #(.WIDTH(1)) dut(.clk, .reset, .in, .out);

  always #10 clk = ~clk;

  initial begin
    clk = 0;
    reset = 1;
    in = 0;
    @(posedge clk); #5;
    reset = 0;
    @(posedge clk); #5;

    in = 1;
    repeat (2) @(posedge clk); #5;
    assert (out == 1) else $error();
  end
endmodule