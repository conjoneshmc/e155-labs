`timescale 1ns/1ns

module lab2_cj_display_tb();
  logic reset;
  logic [3:0] digit_1;
  logic [3:0] digit_0;
  logic [1:0] seg7_anodes;
  logic [6:0] seg7_segments;
  lab2_cj_display dut(
    .n_reset(~reset),
    .n_digit_1(~digit_1),
    .n_digit_0(~digit_0),
    .seg7_anodes,
    .seg7_segments
  );
endmodule