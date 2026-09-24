module debouncer #(parameter int DELAY) (
  input logic clk,
  input logic reset,
  input logic enable,
  input logic in,
  output logic out
);
  logic [$clog2(DELAY)-1:0] debounce_timer;

  counter #(.WIDTH($clog2(DELAY)), .MAX_COUNT(DELAY)) ctr(
    .clk,
    // If the debouncer inputs and outputs are equal, the debounce timer should be reset
    // This trigger should not apply if the device is disabled
    .reset(reset | (enable & (in == out))),
    .enable,
    .value(debounce_timer)
  );

  always_ff @(posedge clk) begin
    if (reset) begin
      out <= 0;
    end
    else if (debounce_timer >= DELAY - 1) begin
      // The counter is about to overflow, so we've waited the debouncing delay
      // The new input can be accepted as legitimate
      out <= in;
    end
  end
endmodule