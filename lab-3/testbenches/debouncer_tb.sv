module debouncer_tb();
  logic clk;
  logic reset;
  logic enable;
  logic in;
  logic out;

  debouncer #(.DELAY(14)) dut(.clk, .reset, .enable, .in, .out);

  always #10 clk = ~clk;

  initial begin
    clk = 0;
    reset = 1;
    enable = 1;
    in = 0;
    @(posedge clk); #5;
    reset = 0;

    // Initial state check
    assert (out == 0) else $error();

    // Test inputs arriving at different positions relative to clock
    @(posedge clk); #17;
    in = 1;
    repeat (14) @(posedge clk); #5;
    assert (out == 1) else $error();
    @(posedge clk); #6;
    in = 0;
    repeat (2) @(posedge clk); #12;
    // Should still be high, haven't waited out the debounce delay yet
    assert (out == 1) else $error();
    in = 1;
    @(posedge clk); #2;
    in = 0; #7;
    in = 1; #4;
    in = 0; #6;
    in = 1;
    assert (out == 1) else $error();
    repeat (3) @(posedge clk); #5;
    in = 0;
    repeat (13) @(posedge clk); #5;
    assert (out == 1) else $error();
    @(posedge clk); #5;
    assert (out == 0) else $error();

    // Test inputs arriving right on top of system clock
    // It may or may not register the input changing on this clock cycle, so we give it an
    // extra one to update the output
    @(posedge clk);
    in = 1;
    repeat (15) @(posedge clk); #5;
    assert (out == 1) else $error();

    // Test reset condition
    in = 0;
    reset = 1;
    @(posedge clk); #5;
    assert (out == 0) else $error();
    reset = 0;
    @(posedge clk);

    // Simulate switch bounce
    for (int i = 0; i < 50; i++) begin
      in = ~in;
      #($urandom_range(42, 3));
    end
    assert (out == 0) else $error();

    // Test enable feature
    @(posedge clk); #5;
    in = 1;
    repeat (15) @(posedge clk); #5;
    enable = 0;
    in = 0;
    repeat (15) @(posedge clk); #5;
    // The device is disabled, so it should not recognize the new output
    assert (out == 1) else $error();
  end
endmodule