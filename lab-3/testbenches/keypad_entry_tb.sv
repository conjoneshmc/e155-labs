`timescale 1ns/1ns

module keypad_entry_tb();
  logic clk;
  logic reset;
  logic [3:0] [3:0] buttons;
  logic [3:0] digit_1;
  logic [3:0] digit_0;

  keypad_entry dut(.clk, .reset, .buttons, .digit_1, .digit_0);

  always #10 clk = ~clk;

  initial begin
    clk = 0;
    reset = 1;
    buttons = '{4'b0000, 4'b0000, 4'b0000, 4'b0000};
    @(posedge clk); #5;
    reset = 0;

    // Initial state check
    assert(digit_1 == 4'h0) else $error();
    assert(digit_0 == 4'h0) else $error();

    // Keypad stimulus
    buttons[3][1] = 1; // button 3
    @(posedge clk); #5;
    assert(digit_1 == 4'h0) else $error();
    assert(digit_0 == 4'h3) else $error();

    // Check multipress conditions
    buttons[2][0] = 1; // button B
    @(posedge clk); #5;
    // Should not update the display with more than one press
    assert(digit_1 == 4'h0) else $error();
    assert(digit_0 == 4'h3) else $error();
    buttons[3][1] = 0; // button 3 released, B is still held down
    @(posedge clk); #5;
    // B should be registered as a keypress
    assert(digit_1 == 4'h3) else $error();
    assert(digit_0 == 4'hB) else $error();
    buttons[2][0] = 0;

    // Check single press conditions
    repeat (3) @(posedge clk); #5;
    buttons[0][1] = 1; // button E
    @(posedge clk); #5;
    assert(digit_1 == 4'hB) else $error();
    assert(digit_0 == 4'hE) else $error();
    repeat (7) @(posedge clk); #5;
    // Button holds should only register as one keypress
    assert(digit_1 == 4'hB) else $error();
    assert(digit_0 == 4'hE) else $error();
    buttons[0][1] = 0;

    // Check reset condition
    reset = 1;
    @(posedge clk); #5;
    assert(digit_1 == 4'h0) else $error();
    assert(digit_0 == 4'h0) else $error();
    reset = 0;
  end
endmodule