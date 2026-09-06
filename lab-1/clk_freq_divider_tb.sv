`timescale 1ns/1ns

module clk_freq_divider_tb();
  logic clk_in;
  logic enable;
  logic reset;
  logic clk_out;
  clk_freq_divider #(.WIDTH(8), .MAXCOUNT(48)) dut(.clk_in, .enable, .reset, .clk_out);

  // We want manual control over the clock cycle, so we will trigger it by hand
  initial begin
    $dumpvars(0, clk_in, reset, clk_out, dut.counter);

    clk_in = 0;
    enable = 1;
    reset = 1; #10;
    
    // Reset should be asynchronous
    assert (clk_out == 0 && dut.counter == 0)
      $display("Asynchronous reset works (1/2)");
    else
      $error("FAILED! Reset is high, but either clk_out or dut.counter are not zero");

    reset = 0; #10;
    reset = 1; #10;
    
    for (int i = 0; i < 5; i++) begin
      clk_in = 1; #5;
      clk_in = 0; #5;
    end

    // Reset should work even when the clock is going
    assert (clk_out == 0 && dut.counter == 0)
      $display("Asynchronous reset works (2/2)");
    else
      $error("FAILED! Reset is high, but either clk_out or dut.counter are not zero");

    reset = 0; #20;
    enable = 0; #10;

    for (int i = 0; i < 5; i++) begin
      clk_in = 1; #5;
      clk_in = 0; #5;
    end

    // Enable being zero should prevent the counter from updating
    assert (dut.counter == 0)
      $display("Enable setting works");
    else
      $error("FAILED! Enable is low, but the counter did not remain at 0");

    reset = 1; #10;
    reset = 0;
    enable = 1; #10;

    for (int i = 0; i < 32; i++) begin
      clk_in = 1; #5;
      clk_in = 0; #5;
    end

    // Check that the counter has incremented to the appropriate value
    assert (dut.counter == 32)
      $display("Counter increments properly (1/2)");
    else
      $error("FAILED! There have been 32 rising clock edges, but the counter is not 32");

    // Check that clk_out is low since we have not reached max_count yet
    assert (clk_out == 0)
      $display("MAXCOUNT setting works properly (1/2)");
    else
      $error("FAILED! MAXCOUNT was set to 48 and there have only been 32 rising clock edges so far, but clk_out is not low");

    for (int i = 0; i < 20; i++) begin
      clk_in = 1; #5;
      clk_in = 0; #5;
    end

    assert (dut.counter == 4)
      $display("Counter increments properly (2/2)");
    else
      $error("FAILED! MAXCOUNT was set to 48 and there have been 52 rising clock edges, but the counter did not wrap back to 4");

    // Check that clk_out is now high since we have reached max_count
    assert (clk_out == 1)
      $display("MAXCOUNT setting works properly (2/2)");
    else
      $error("FAILED! MAXCOUNT was set to 48 and there have been 52 rising clock edges so far, but clk_out is not high");

    #10;
    reset = 1; #10;
    reset = 0;
  end
endmodule