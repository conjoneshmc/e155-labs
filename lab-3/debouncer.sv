module debouncer #(parameter int DELAY) (
  input logic clk,
  input logic reset,
  input logic enable,
  input logic in,
  output logic out
);
  logic [$clog2(DELAY)-1:0] value;
  counter #(.WIDTH($clog2(DELAY)), .MAX_COUNT(DELAY)) ctr(
    .clk,
    // If the debouncer inputs and outputs are equal, the debounce timer should be stopped
    .reset(reset | (in == out)),
    .enable,
    .value
  );

  always_ff @(posedge clk) begin
    if (reset) begin
      out <= 0;
    end else if (value >= DELAY - 1) begin
      // The counter is about to overflow, so we've waited the debouncing delay
      // The new input can be accepted as legitimate and not just noise
      out <= in;
    end
  end
endmodule