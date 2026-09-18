`timescale 1ns/1ns

module keypad_tb();
  logic clk;
  logic reset;
  logic enable;
  logic [3:0] cols;
  logic [3:0] rows;
  logic [3:0] buttons [4];
  keypad #(.POLL_DELAY(2), .DEBOUNCE_DELAY(20)) dut(.clk, .reset, .enable, .cols, .rows, .buttons);

  always #10 clk = ~clk;

  initial begin
    $dumpvars(0, clk, reset, enable, cols, rows, buttons[0], buttons[1], buttons[2], buttons[3],
      dut.buttons_raw[0], dut.buttons_raw[1], dut.buttons_raw[2], dut.buttons_raw[3]);

    clk = 0;
    reset = 1;
    enable = 1;
    cols = 4'b0000; #25;
    reset = 0;

    // Row 0 of the keypad should be under interrogation
    // Press row 0 column 2
    cols = 4'b0100; #20;
    cols = 4'b0000; #120;
    for (int i = 0; i < 2; i++) begin
      cols = 4'b0100; #40;
      cols = 4'b0000; #120;
    end

    $finish();
  end
endmodule