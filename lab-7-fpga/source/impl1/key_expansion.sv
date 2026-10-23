module key_expansion(
  input  logic              clk,
  input  logic [127:0]      key,
  output logic [0:43][31:0] words
);
  /*
  For the key expansion routine, the first 4 words are THE EXACT SAME AS THE KEY. All the other words follow
  this pattern as noted in the key expansion procedure of the spec:

  w[4] = w[0] ^ sub_word(rot_word(w[3])) ^ Rcon[1]
  w[5] = w[1] ^ w[4]
  w[6] = w[2] ^ w[5]
  w[7] = w[3] ^ w[6]

  w[8]  = w[4] ^ sub_word(rot_word(w[7])) ^ Rcon[2]
  w[9]  = w[5] ^ w[8]
  w[10] = w[6] ^ w[9]
  w[11] = w[7] ^ w[10]

  w[12] = w[8] ^ sub_word(rot_word(w[11])) ^ Rcon[3]
  w[13] = w[9] ^ w[12]
  w[14] = w[10] ^ w[13]
  w[15] = w[11] ^ w[14]

  ...
  */

  // Round constant lookup table (please synthesize correctly)
  // Also, j here is zero-indexed, but in the spec it starts at 1
  // So we will need to account for that in the rest of the module
  logic [0:9][31:0] Rcon = '{
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

  // The first four words are the same as the key
  assign words[0] = key[127:96];
  assign words[1] = key[95:64];
  assign words[2] = key[63:32];
  assign words[3] = key[31:0];

  // Now the fun begins!
  for (genvar i = 4; i < 44; i++) begin : gen_i
    if (i % 4 == 0) begin
      /*
      i is a multiple of Nk (= 4), so we need to compute:
      w[i] = w[i - 4] ^ sub_word(rot_word(w[i - 1])) ^ Rcon[i/4 - 1]
      
      Note that sub_word is SYNCHRONOUS, so it needs 1 CLOCK CYCLE to be valid
      Therefore, this word, and all words that depend on it, need a clock cycle to be valid
      If this word depends on another word that has its own clock cycle of latency, then this
      word will require a total of 2 CLOCK CYCLES to be valid, because you need to wait for all
      the other words to become valid as well
      */
      logic [31:0] after_rot_word;
      logic [31:0] after_sub_word;
      rot_word t1(.a(words[i - 1]), .y(after_rot_word));
      sub_word t2(.clk, .a(after_rot_word), .y(after_sub_word));

      assign words[i] = words[i - 4] ^ after_sub_word ^ Rcon[i/4 - 1];
    end
    else begin
      /*
      i is NOT a multiple of Nk, so we just need to compute:
      w[i] = w[i - 4] ^ w[i - 1]

      Note that although this operation itself is purely combinational, it might depend on other
      words that require a cycle of latency to compute. So this word might also require some clock
      cycles of latency
      */
      assign words[i] = words[i - 4] ^ words[i - 1];
    end
  end
endmodule


module rot_word(
  input  logic [31:0] a,
  output logic [31:0] y
);
  assign y[31:24] = a[23:16]; // y[0] = a[1]
  assign y[23:16] = a[15:8];  // y[1] = a[2]
  assign y[15:8]  = a[7:0];   // y[2] = a[3]
  assign y[7:0]   = a[31:24]; // y[3] = a[0]
endmodule


module sub_word(
  input  logic        clk,
  input  logic [31:0] a,
  output logic [31:0] y
);
  sbox_sync sub_a0(.clk, .a(a[31:24]), .y(y[31:24]));
  sbox_sync sub_a1(.clk, .a(a[23:16]), .y(y[23:16]));
  sbox_sync sub_a2(.clk, .a(a[15:8]),  .y(y[15:8]));
  sbox_sync sub_a3(.clk, .a(a[7:0]),   .y(y[7:0]));
endmodule