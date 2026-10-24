module aes_datapath(
  input  logic         clk,
  input  logic [127:0] key,
  input  logic [127:0] plaintext,
  input  logic         load_inputs,
  input  logic         load_cipher_state,
  input  logic         cipher_state_sel,
  input  logic         only_add_round_key,
  input  logic         skip_mix_columns,
  input  logic [3:0]   round_num,
  output logic [127:0] state
);
  // Internal nets
  logic [127:0] loaded_key;
  logic [127:0] loaded_plaintext;
  logic [0:43][31:0] words;
  logic [0:3][31:0] round_words;
  logic [127:0] after_sub_bytes;
  logic [127:0] after_shift_rows;
  logic [127:0] after_mix_columns;
  logic [127:0] after_add_round_key;

  // Modules
  key_expansion f1(.clk, .key(loaded_key), .words);
  word_selector f2(.words, .round_num, .round_words);
  sub_bytes     f3(.clk, .a(state), .y(after_sub_bytes));
  shift_rows    f4(.a(after_sub_bytes), .y(after_shift_rows));
  mix_columns   f5(.a(after_shift_rows), .y(after_mix_columns));
  add_round_key f6(
    .a(
      only_add_round_key ?
      state :
      (
        skip_mix_columns ?
        after_shift_rows :
        after_mix_columns
      )
    ),
    .w(round_words),
    .y(after_add_round_key)
  );

  // Register logic
  always_ff @(posedge clk) begin
    if (load_inputs) begin
      loaded_key <= key;
      loaded_plaintext <= plaintext;
    end

    if (load_cipher_state) begin
      state <= (cipher_state_sel ? loaded_plaintext : after_add_round_key);
    end
  end
endmodule


module word_selector(
  input logic  [0:43][31:0] words,
  input logic  [3:0] round_num,
  output logic [0:3][31:0] round_words
);
  /*
  This module is responsible for determining which words to use during the current round. The key expansion
  routine generates a list of 44 words, but we only use 4 of them at a time, and they change each round
  */
  always_comb begin
    case (round_num)
      0:  round_words = words[ 0: 3];
      1:  round_words = words[ 4: 7];
      2:  round_words = words[ 8:11];
      3:  round_words = words[12:15];
      4:  round_words = words[16:19];
      5:  round_words = words[20:23];
      6:  round_words = words[24:27];
      7:  round_words = words[28:31];
      8:  round_words = words[32:35];
      9:  round_words = words[36:39];
      10: round_words = words[40:43];
      default: round_words = '{32'h0, 32'h0, 32'h0, 32'h0}; // not supposed to happen
    endcase
  end
endmodule