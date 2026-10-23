`timescale 10ns/1ns

module key_expansion_tb();
  logic clk;
  logic [127:0] key;
  logic [0:43][31:0] words;

  key_expansion dut(.clk, .key, .words);

  always #5 clk = ~clk;
  initial begin
    clk = 0;
    key = 128'h2b7e151628aed2a6abf7158809cf4f3c;

    repeat (15) @(posedge clk); // requires at least 10 clock cycles to become valid
    #20;
    $stop();
  end
endmodule