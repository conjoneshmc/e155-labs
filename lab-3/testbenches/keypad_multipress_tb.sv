`timescale 1ns/1ns

module keypad_multipress_tb();
  logic clk;
  logic reset;
  logic [3:0] num_pressed;
  logic should_update;

  keypad_multipress dut(.clk, .reset, .num_pressed, .should_update);

  always #10 clk = ~clk;

  initial begin
    clk = 0;
    reset = 1;
    num_pressed = 0;
    #25; reset = 0;
    #10;

    // Initial state check
    assert(!should_update) else $error();
    #60; assert(!should_update) else $error();

    // Test single keypress condition
    num_pressed = 1;
    #1; assert(should_update) else $error();
    #19; assert(!should_update) else $error();
    num_pressed = 0;
    #20; assert(!should_update) else $error();

    // Test multi-keypress condition
    num_pressed = 1;
    #20; num_pressed = 2;
    #20; num_pressed = 1;
    #1; assert(should_update) else $error();
    #19; assert(!should_update) else $error();
  end
endmodule