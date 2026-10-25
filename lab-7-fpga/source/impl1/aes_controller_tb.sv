`timescale 10ns/1ns

module aes_controller_tb();
  logic clk;
  logic load;
  logic done;
  logic cipher_state_update;
  logic key_state_update;
  logic state_select;
  logic [31:0] round_const;
  logic only_add_round_key;
  logic skip_mix_columns;

  aes_controller dut(
    .clk,
    .load,
    .done,
    .cipher_state_update,
    .key_state_update,
    .state_select,
    .round_const,
    .only_add_round_key,
    .skip_mix_columns
  );

  always #5 clk = ~clk;
  initial begin
    clk = 0;
    load = 1;
    repeat (5) @(posedge clk); #2;
    load = 0;
    repeat (50) @(posedge clk);
    $stop();
  end
endmodule