module lab2_cj_keypad (
  input logic n_reset,
  input logic [3:0] keypad_cols,
  output logic [3:0] keypad_rows,
  output logic [3:0] leds
);
  // Internal clock @ 24 MHz
  logic hf_osc_clk;
  SB_HFOSC #(.CLKHF_DIV("0b01")) hf_osc (
    .CLKHFPU(1'b1),
    .CLKHFEN(1'b1),
    .CLKHF(hf_osc_clk)
  );

  // Keypad scanner module
  assign leds = ~keypad_cols;
  scanner #(.SCAN_DELAY(3000000)) keypad(
    .clk(hf_osc_clk),
    .reset(~n_reset),
    .enable(1'b1),
    .out(keypad_rows)
  );
endmodule