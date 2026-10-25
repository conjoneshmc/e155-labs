module aes_datapath(
  input  logic         clk,
  input  logic [127:0] key,
  input  logic [127:0] plaintext,

  input  logic         state_update,
  input  logic         state_select,

  input  logic [31:0]  round_const,
  input  logic         only_add_round_key,
  input  logic         skip_mix_columns,

  output logic [127:0] cipher_state
);
  // Internal ports
  logic [0:3][31:0] key_state;
  logic [0:3][31:0] next_key_state;
  logic [127:0] after_sub_bytes;
  logic [127:0] after_shift_rows;
  logic [127:0] after_mix_columns;
  logic [127:0] next_cipher_state;

  // Modules
  key_expansion_step f1(.clk, .round_const, .words(key_state), .next_words(next_key_state));
  sub_bytes f2(.clk, .a(cipher_state), .y(after_sub_bytes));
  shift_rows f3(.a(after_sub_bytes), .y(after_shift_rows));
  mix_columns f4(.a(after_shift_rows), .y(after_mix_columns));
  add_round_key f5(
    .a(
      only_add_round_key
      ? cipher_state
      : (
        skip_mix_columns
        ? after_shift_rows
        : after_mix_columns
      )
    ),
    .w(key_state),
    .y(next_cipher_state)
  );

  // Register logic
  always_ff @(posedge clk) begin
    if (state_update) begin
      cipher_state <= (state_select ? plaintext : next_cipher_state);
      key_state <= (state_select ? '{key[127:96], key[95:64], key[63:32], key[31:0]} : next_key_state);
    end
  end
endmodule