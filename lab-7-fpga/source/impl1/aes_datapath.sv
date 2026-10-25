module aes_datapath(
  input  logic         clk,
  input  logic [127:0] key,
  input  logic [127:0] plaintext,

  input  logic         cipher_state_update,
  input  logic         key_state_update,
  input  logic         state_select,

  input  logic [31:0]  round_const,
  input  logic         only_add_round_key,
  input  logic         skip_mix_columns,

  output logic [127:0] state
);
  //
endmodule