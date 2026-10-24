module key_expansion_step(
  input  logic             clk,
  input  logic [31:0]      round_const,
  input  logic [0:3][31:0] words,
  output logic [0:3][31:0] next_words
);
  /*
  The entire key expansion routine is WAY TOO BIG to fit onto the FPGA (I tried and it takes about 9000 LUTs). Fortunately, we don't need to know the entire key schedule at once, we only need to know 4 at a time. This module takes a group of 4 words and computes the next 4 words in the key schedule. Note that the first word must be aligned on a multiple of 4

  For example, if words contains w[0], w[1], w[2], and w[3], then next_words will contain w[4], w[5], w[6], w[7]
  */

  logic [31:0] after_rot_word;
  logic [31:0] after_sub_word;
  rot_word f1(.a(words[3]), .y(after_rot_word));
  sub_word f2(.clk, .a(after_rot_word), .y(after_sub_word));

  assign next_words[0] = words[0] ^ after_sub_word ^ round_const;
  assign next_words[1] = words[1] ^ next_words[0];
  assign next_words[2] = words[2] ^ next_words[1];
  assign next_words[3] = words[3] ^ next_words[2];
endmodule