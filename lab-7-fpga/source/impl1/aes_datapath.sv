module aes_datapath();
  // TODO
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