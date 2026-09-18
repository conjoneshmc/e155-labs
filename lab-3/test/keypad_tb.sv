`timescale 1ns/1ns

module keypad_tb();
  logic clk;
  logic reset;
  logic enable;
  logic [3:0] cols;
  logic [3:0] rows;
  logic [3:0] buttons [4];
  logic [3:0] buttons_pressed [4];
  keypad #(.POLL_DELAY(2), .DEBOUNCE_DELAY(20)) dut(.clk, .reset, .enable, .cols, .rows, .buttons);

  always #10 clk = ~clk;

  always begin
    // Simulates a keypad
    if      (rows == 4'b0001) cols = buttons_pressed[0];
    else if (rows == 4'b0010) cols = buttons_pressed[1];
    else if (rows == 4'b0100) cols = buttons_pressed[2];
    else if (rows == 4'b1000) cols = buttons_pressed[3];
    #1;
  end

  initial begin
    $dumpvars(0, clk, reset, enable, cols, rows, buttons[0], buttons[1], buttons[2], buttons[3],
      dut.buttons_raw[0], dut.buttons_raw[1], dut.buttons_raw[2], dut.buttons_raw[3]);

    // Reset hardware to initial state
    clk = 0;
    reset = 1;
    enable = 1;
    cols = 4'b0000;
    buttons_pressed = '{4'b0000, 4'b0000, 4'b0000, 4'b0000}; #25;
    reset = 0;

    // Start faking some button presses
    buttons_pressed[0][3] = 1; #40;
    buttons_pressed[3][1] = 1; #60;
    buttons_pressed[3][3] = 1; #20;
    buttons_pressed[1][0] = 1; #80;
    buttons_pressed[2][3] = 1;
    buttons_pressed[2][2] = 1; #500;

    // We're done!
    $finish();
  end
endmodule