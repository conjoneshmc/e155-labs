module keypad_poller #(parameter int POLL_DELAY) (
  input logic clk,
  input logic reset,
  input logic enable,
  output logic [3:0] rows
);
  logic [$clog2(4*POLL_DELAY)-1:0] poll_timer;

  counter #(.WIDTH($clog2(4*POLL_DELAY)), .MAX_COUNT(4*POLL_DELAY)) ctr(
    .clk,
    .reset,
    .enable,
    .value(poll_timer)
  );

  always_comb begin
    // Rotate between the different outputs every DELAY cycles
    if      (poll_timer < POLL_DELAY)   rows = 4'b0001;
    else if (poll_timer < 2*POLL_DELAY) rows = 4'b0010;
    else if (poll_timer < 3*POLL_DELAY) rows = 4'b0100;
    else                                rows = 4'b1000;
  end
endmodule