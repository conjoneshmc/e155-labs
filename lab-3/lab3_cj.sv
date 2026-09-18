module lab3_cj(
  input logic n_reset,
  input logic [3:0] n_keypad_cols,
  output logic [3:0] keypad_rows,
  output logic [1:0] seg7_anodes,
  output logic [6:0] seg7_segments,
  output logic [2:0] leds
);
  logic clk;
  logic [3:0] [3:0] keypad_buttons;

  // Internal clock @ 24 MHz
  SB_HFOSC #(.CLKHF_DIV("0b01")) hf_osc(
    .CLKHFPU(1'b1),
    .CLKHFEN(1'b1),
    .CLKHF(clk)
  );

  // Temporarily disable display
  assign seg7_anodes = 2'b11;
  assign seg7_segments = 7'b1111111;

  // Keypad
  keypad #(
    .POLL_DELAY(240000),    // 10ms
    .SETTLE_DELAY(24000),   // 1ms
    .DEBOUNCE_DELAY(960000) // 40ms
  ) inputs(
    .clk,
    .reset(~n_reset),
    .enable(1'b1),
    .cols(~n_keypad_cols),
    .rows(keypad_rows),
    .buttons(keypad_buttons)
  );

  assign leds[2] = keypad_buttons[3][3]; // Button 1
  assign leds[1] = keypad_buttons[3][2]; // Button 2
  assign leds[0] = keypad_buttons[3][1]; // Button 3
endmodule