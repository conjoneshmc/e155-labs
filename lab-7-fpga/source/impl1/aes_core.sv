module aes_core(
  input  logic         clk, 
  input  logic         load,
  input  logic [127:0] key, 
  input  logic [127:0] plaintext, 
  output logic         done, 
  output logic [127:0] cyphertext
);
  logic state_update;
  logic state_select;
  logic [31:0] round_const;
  logic only_add_round_key;
  logic skip_mix_columns;

  aes_controller controller(
    .clk,
    .load,
    .done,
    .state_update,
    .state_select,
    .round_const,
    .only_add_round_key,
    .skip_mix_columns
  );

  aes_datapath datapath(
    .clk,
    .key,
    .plaintext,
    .state_update,
    .state_select,
    .round_const,
    .only_add_round_key,
    .skip_mix_columns,
    .cipher_state(cyphertext)
  );
endmodule