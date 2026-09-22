module lab3_cj_dut(
  input logic clk,
  input logic n_reset,
  input logic [3:0] n_keypad_cols,
  output logic [3:0] keypad_rows,
  output logic [1:0] seg7_anodes,
  output logic [6:0] seg7_segments
);
  logic [3:0] keypad_cols;
  logic [3:0] [3:0] keypad_buttons;
  logic [3:0] keypad_digit_1;
  logic [3:0] keypad_digit_0;

  // Synchronize async inputs
  sync #(.WIDTH(4)) keypad_sync(
    .clk,
    .reset(~n_reset),
    .in(~n_keypad_cols),
    .out(keypad_cols)
  );

  // Keypad scanner and digit entry handler
  keypad #(
    .POLL_DELAY(6),
    .SETTLE_DELAY(2),
    .DEBOUNCE_DELAY(40)
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
    .DELAY(15)
  ) display(
    .clk,
    .reset(~n_reset),
    .digit_1(keypad_digit_1),
    .digit_0(keypad_digit_0),
    .anodes(seg7_anodes),
    .segments(seg7_segments)
  );
endmodule