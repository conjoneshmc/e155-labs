module lab3_cj(
  input logic n_reset,
  input logic [3:0] n_keypad_cols,
  output logic [3:0] keypad_rows,
  output logic [1:0] seg7_anodes,
  output logic [6:0] seg7_segments
);
  logic clk;
  logic [3:0] keypad_cols;
  logic [3:0] [3:0] keypad_buttons;
  logic [3:0] keypad_digit_1;
  logic [3:0] keypad_digit_0;

  // Internal clock @ 24 MHz
  SB_HFOSC #(.CLKHF_DIV("0b01")) hf_osc(
    .CLKHFPU(1'b1),
    .CLKHFEN(1'b1),
    .CLKHF(clk)
  );

  // Synchronize async inputs
  sync #(.WIDTH(4)) keypad_sync(
    .clk,
    .reset(~n_reset),
    .in(~n_keypad_cols),
    .out(keypad_cols)
  );

  // Keypad scanner and digit entry handler
  keypad #(
    .POLL_DELAY(48000),     // 2ms
    .SETTLE_DELAY(12000),   // 0.5ms
    .DEBOUNCE_DELAY(576000) // 24ms
  ) keys(
    .clk,
    .reset(~n_reset),
    .enable(1'b1),
    .cols(keypad_cols),
    .rows(keypad_rows),
    .buttons(keypad_buttons)
  );

  keypad_entry entry(
    .clk,
    .reset(~n_reset),
    .buttons(keypad_buttons),
    .digit_1(keypad_digit_1),
    .digit_0(keypad_digit_0)
  );

  // Dual 7-segment display
  seg7_dual #(
    .DELAY(120000) // 5ms
  ) display(
    .clk,
    .reset(~n_reset),
    .digit_1(keypad_digit_1),
    .digit_0(keypad_digit_0),
    .anodes(seg7_anodes),
    .segments(seg7_segments)
  );
endmodule