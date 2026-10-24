`timescale 10ns/1ns

module key_expansion_tb();
  logic clk;
  logic [31:0] round_const;
  logic [0:3][31:0] words;
  logic [0:3][31:0] next_words;

  logic [0:9][31:0] round_constants = '{
    32'h01000000,
    32'h02000000,
    32'h04000000,
    32'h08000000,
    32'h10000000,
    32'h20000000,
    32'h40000000,
    32'h80000000,
    32'h1b000000,
    32'h36000000
  };

  key_expansion_step dut(.clk, .round_const, .words, .next_words);

  always #5 clk = ~clk;
  initial begin
    clk = 0;
    words = '{32'h2b7e1516, 32'h28aed2a6, 32'habf71588, 32'h09cf4f3c};
    
    for (int round_num = 0; round_num < 10; round_num++) begin
      round_const = round_constants[round_num];
      repeat (2) @(posedge clk);
      words = next_words;
    end

    $stop();
  end
endmodule