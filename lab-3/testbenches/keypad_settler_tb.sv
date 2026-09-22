`timescale 1ns/1ns

module keypad_settler_tb();
  logic clk;
  logic reset;
  logic enable;
  logic settled;

  keypad_settler #(
    .POLL_DELAY(10),
    .SETTLE_DELAY(3)
  ) dut(.clk, .reset, .enable, .settled);

  always #10 clk = ~clk;

  initial begin
    clk = 0;
    reset = 1;
    enable = 1;
    @(posedge clk); #5;
    reset = 0;

    // Basic state transition checks
    assert(!settled) else $error();
    repeat (3) @(posedge clk); #5;
    assert(settled) else $error();
    repeat (6) @(posedge clk); #5;
    assert(settled) else $error();
    repeat (2) @(posedge clk); #5;
    assert(!settled) else $error();
  end
endmodule