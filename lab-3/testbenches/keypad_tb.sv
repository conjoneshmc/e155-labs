`timescale 1ns/1ns

module keypad_tb();
  logic clk;
  logic reset;
  logic enable;
  logic [3:0] cols;
  logic [3:0] rows;
  logic [3:0] [3:0] buttons;
  logic [3:0] [3:0] buttons_pressed;

  keypad #(
    .POLL_DELAY(5),
    .SETTLE_DELAY(1),
    .DEBOUNCE_DELAY(10)
  ) dut(.clk, .reset, .enable, .cols, .rows, .buttons);

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
    // Reset hardware to initial state
    clk = 0;
    reset = 1;
    enable = 1;
    cols = 4'b0000;
    buttons_pressed = '{4'b0000, 4'b0000, 4'b0000, 4'b0000};
    #25; reset = 0;

    // Nothing is pressed
    assert(buttons == '{4'b0000, 4'b0000, 4'b0000, 4'b0000}) else $error();

    // Basic keypress stimulus
    // After at least 30 clock cycles (4*5 for the polling and 10 for the debouncing), or
    // 600ns, the keypad should have recognized the button pressed
    buttons_pressed[0] = 4'b0100;
    buttons_pressed[2] = 4'b1001;
    #600; assert(buttons == '{4'b0000, 4'b1001, 4'b0000, 4'b0100}) else $error();

    // Test keypress debouncing
    // The keypad should not recognize a new keypress until the debounce delay has passed,
    // which is longer than 150ns
    // We release the button before the debounce delay has elapsed, so the keypad should never
    // register it as a keypress
    buttons_pressed[1][2] = 1;
    #150; assert(buttons[1][2] == 0) else $error();
    buttons_pressed[1][2] = 0;
    #450; assert(buttons[1][2] == 0) else $error();

    // Test enable
    // Never used, but a disabled keypad should not update anything
    enable = 0;
    buttons_pressed[1] = 4'b1111;
    #600; assert(buttons[1] == 4'b0000) else $error();

    // Test reset
    enable = 1;
    reset = 1;
    #20; assert(buttons == '{4'b0000, 4'b0000, 4'b0000, 4'b0000}) else $error();
  end
endmodule