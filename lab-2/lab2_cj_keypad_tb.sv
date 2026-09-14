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

    $finish();
  end
endmodule