module lab3_cj_tb();
  logic clk;
  logic n_reset;
  logic [3:0] n_keypad_cols;
  logic [3:0] keypad_rows;
  logic [1:0] seg7_anodes;
  logic [6:0] seg7_segments;

  lab3_cj_dut dut(.clk, .n_reset, .n_keypad_cols, .keypad_rows, .seg7_anodes, .seg7_segments);

  always #10 clk = ~clk;

  // Assert module interconnections
  assert property(@(posedge clk) clk == dut.keypad_sync.clk) else $error();
  assert property(@(posedge clk) clk == dut.keys.clk) else $error();
  assert property(@(posedge clk) clk == dut.entry.clk) else $error();
  assert property(@(posedge clk) clk == dut.display.clk) else $error();
  assert property(@(posedge clk) dut.keypad_cols == dut.keys.cols) else $error();
  assert property(@(posedge clk) keypad_rows == dut.keys.rows) else $error();
  assert property(@(posedge clk) dut.keypad_buttons == dut.entry.buttons) else $error();
  assert property(@(posedge clk) dut.keypad_digit_1 == dut.entry.digit_1) else $error();
  assert property(@(posedge clk) dut.keypad_digit_1 == dut.display.digit_1) else $error();
  assert property(@(posedge clk) dut.keypad_digit_0 == dut.entry.digit_0) else $error();
  assert property(@(posedge clk) dut.keypad_digit_0 == dut.display.digit_0) else $error();
  assert property(@(posedge clk) seg7_anodes == dut.display.anodes) else $error();

  initial begin
    clk = 0;
    n_reset = 0;
    n_keypad_cols = 4'b1111;
    @(posedge clk); #5;
    n_reset = 1;

    // Provide a very basic stimulus just to verify module interconnections
    repeat (12) @(posedge clk); #5;
    n_keypad_cols = 4'b1001;
  end
endmodule