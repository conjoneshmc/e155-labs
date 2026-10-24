module aes_core(
  input  logic         clk, 
  input  logic         load,
  input  logic [127:0] key, 
  input  logic [127:0] plaintext, 
  output logic         done, 
  output logic [127:0] cyphertext
);
  logic load_inputs;
  logic load_cipher_state;
  logic cipher_state_sel;
  logic only_add_round_key;
  logic skip_mix_columns;
  logic [3:0] round_num;

  aes_controller controller(
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

  aes_datapath datapath(
    .clk,
    .key,
    .plaintext,
    .load_inputs,
    .load_cipher_state,
    .cipher_state_sel,
    .only_add_round_key,
    .skip_mix_columns,
    .round_num,
    .state(cyphertext)
  );
endmodule