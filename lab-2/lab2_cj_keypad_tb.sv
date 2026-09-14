`timescale 1ns/1ns

module lab2_cj_keypad_tb();
  logic reset;
  logic [3:0] keypad_cols;
  logic [3:0] keypad_rows;
  logic [3:0] leds;
  lab2_cj_keypad dut(
    .n_reset(~reset),
    .keypad_cols,
    .keypad_rows,
    .leds
  );

  task clk_toggle(input int cycles);
    for (int i = 0; i < cycles; i++) begin
      dut.hf_osc_clk = 1; #5;
      dut.hf_osc_clk = 0; #5;
    end
  endtask

  initial begin
    $dumpvars(0, dut.hf_osc_clk, reset, keypad_cols, keypad_rows, leds);

    dut.hf_osc_clk = 0;
    reset = 1;
    keypad_cols = 4'b0000;
    #10;
    reset = 0;
    #10;

    assert (leds == 4'b1111) else
      $error("FAILED! leds has wrong value");

    keypad_cols = 4'b0010;
    #5;
    assert (leds == 4'b1101) else
      $error("FAILED! leds has wrong value");

    keypad_cols = 4'b1100;
    #5;
    assert (leds == 4'b0011) else
      $error("FAILED! leds has wrong value");

    clk_toggle(18);
    assert(keypad_rows == 4'b0010) else
      $error("FAILED! keypad_rows has wrong value");

    #20;
    $finish();
  end
endmodule