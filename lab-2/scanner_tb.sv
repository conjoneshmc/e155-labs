`timescale 1ns/1ns

module scanner_tb();
  logic clk;
  logic reset;
  logic enable;
  logic [3:0] out;
  scanner #(.SCAN_DELAY(12)) dut(.clk, .reset, .enable, .out);

  task clk_toggle(input int cycles);
    for (int i = 0; i < cycles; i++) begin
      clk = 1; #5;
      clk = 0; #5;
    end
  endtask

  initial begin
    $dumpvars(0, clk, reset, enable, out);

    clk = 0;
    reset = 1;
    enable = 1;
    #10;
    reset = 0;
    #10;

    // Check initial state after reset
    assert(out == 4'b1000) else
      $error("FAILED! Scanner does not output 0b1000 after being reset");

    // Check SCAN_DELAY
    clk_toggle(7);
    assert(out == 4'b1000) else
      $error("FAILED! Expected scanner output to be 0b1000, but got something else");

    // Check each of the different states
    clk_toggle(5);
    assert(out == 4'b0100) else
      $error("FAILED! Expected scanner output to be 0b0100, but got something else");

    clk_toggle(15);
    assert(out == 4'b0010) else
      $error("FAILED! Expected scanner output to be 0b0010, but got something else");

    clk_toggle(10);
    assert(out == 4'b0001) else
      $error("FAILED! Expected scanner output to be 0b0001, but got something else");

    // Check reset feature
    reset = 1;
    #5;
    reset = 0;
    #5;
    assert(out == 4'b1000) else
      $error("FAILED! Scanner does not output 0b1000 after being reset");

    // Check enable feature
    // We set enable=0 after 1 SCAN_DELAY period, so the state should be 0b0100
    clk_toggle(17);
    enable = 0;
    #5;
    clk_toggle(14);
    assert(out == 4'b0100) else
      $error("FAILED! Expected scanner output to be 0b0100, but got something else");
  end
endmodule