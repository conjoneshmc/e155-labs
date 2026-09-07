`timescale 1ns/1ns

module counter_tb();
  logic clk;
  logic enable;
  logic reset;
  logic [7:0] value;
  counter #(.WIDTH(8), .MAXCOUNT(48)) dut(.clk, .enable, .reset, .value);

  // We want manual control over the clock cycle, so we will trigger it by hand
  initial begin
    $dumpvars(0, clk, enable, reset, value);

    clk = 0;
    enable = 1;
    reset = 1; #10;

    for (int i = 0; i < 5; i++) begin
      clk = 1; #5;
      clk = 0; #5;
    end
    
    // Reset should force counter value to 0
    assert (value == 0)
      $display("Reset feature works (1/2)");
    else
      $error("FAILED! Reset is high, but counter value is not 0");

    reset = 0; #10;
    
    for (int i = 0; i < 5; i++) begin
      clk = 1; #5;
      clk = 0; #5;
    end

    clk = 1; #5;
    reset = 1; #10;

    // Reset should be asynchronous
    assert (value == 0)
      $display("Reset feature works (2/2)");
    else
      $error("FAILED! Reset is high, but counter value is not 0");

    clk = 0;
    reset = 0; #20;
    enable = 0; #10;

    for (int i = 0; i < 5; i++) begin
      clk = 1; #5;
      clk = 0; #5;
    end

    // Enable being zero should prevent the counter from updating
    assert (value == 0)
      $display("Enable setting works (1/2)");
    else
      $error("FAILED! Enable is low, but counter value did not remain at 0");

    reset = 1; #10;
    reset = 0;
    enable = 1; #10;

    for (int i = 0; i < 32; i++) begin
      clk = 1; #5;
      clk = 0; #5;
    end

    // Check that the counter has incremented to the appropriate value
    assert (value == 32)
      $display("Counter increments properly (1/2)");
    else
      $error("FAILED! There have been 32 rising clock edges, but counter value is not 32");

    for (int i = 0; i < 20; i++) begin
      clk = 1; #5;
      clk = 0; #5;
    end

    // Counter should wrap back to 4 since MAXCOUNT is 48
    assert (value == 4)
      $display("Counter increments properly (2/2)");
    else
      $error("FAILED! MAXCOUNT was set to 48 and there have been 52 rising clock edges, but counter value did not wrap back to 4");

    enable = 0; #10;

    for (int i = 0; i < 17; i++) begin
      clk = 1; #5;
      clk = 0; #5;
    end

    // Counter should not change since enable is low
    assert (value == 4)
      $display("Enable setting works (2/2)");
    else
      $error("FAILED! Enable is low, but counter value changed from previous value of 4");
  end
endmodule