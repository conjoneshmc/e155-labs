module keypad_settler #(
  parameter int POLL_DELAY,
  parameter int SETTLE_DELAY
) (
  input logic clk,
  input logic reset,
  input logic enable,
  output logic settled
);
  logic [$clog2(POLL_DELAY)-1:0] poll_timer;

  counter #(.WIDTH($clog2(POLL_DELAY)), .MAX_COUNT(POLL_DELAY)) ctr(
    .clk,
    .reset,
    .enable,
    .value(poll_timer)
  );

  assign settled = (poll_timer >= SETTLE_DELAY);
endmodule