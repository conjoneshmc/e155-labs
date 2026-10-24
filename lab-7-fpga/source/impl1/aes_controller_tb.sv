`timescale 10ns/1ns

module aes_controller_tb();
  logic clk;
  logic load;
  logic done;
  logic load_inputs;
  logic load_cipher_state;
  logic cipher_state_sel;
  logic only_add_round_key;
  logic skip_mix_columns;
  logic [3:0] round_num;

  aes_controller dut(
    .clk,
    .load,
    .done,
    .load_inputs,
    .load_cipher_state,
    .cipher_state_sel,
    .only_add_round_key,
    .skip_mix_columns,
    .round_num
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