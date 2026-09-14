module lab2_cj_display (
  input logic n_reset,
  input logic [3:0] n_digit_1,
  input logic [3:0] n_digit_0,
  output logic [1:0] seg7_anodes,
  output logic [6:0] seg7_segments
);
  // Internal clock @ 24 MHz
  logic hf_osc_clk;
  SB_HFOSC #(.CLKHF_DIV("0b01")) hf_osc (
    .CLKHFPU(1'b1),
    .CLKHFEN(1'b1),
    .CLKHF(hf_osc_clk)
  );

  // Multiplexed dual 7-segment display
  dual_seg7 #(.MULTIPLEX_PERIOD(200000)) display(
    .clk(hf_osc_clk),
    .reset(~n_reset),
    .digit_1(~n_digit_1),
    .digit_0(~n_digit_0),
    .anodes(seg7_anodes),
    .segments(seg7_segments)
  );
endmodule