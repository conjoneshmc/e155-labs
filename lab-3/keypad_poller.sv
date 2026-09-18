module keypad_poller #(parameter int DELAY) (
  input logic clk,
  input logic reset,
  input logic enable,
  output logic [3:0] rows
);
  logic [$clog2(4*DELAY)-1:0] mux_timer;

  counter #(.WIDTH($clog2(4*DELAY)), .MAX_COUNT(4*DELAY)) ctr(
    .clk,
    .reset,
    .enable,
    .value(mux_timer)
  );

  always_comb begin
    // Rotate between the different outputs every DELAY cycles
    if      (mux_timer < DELAY)   rows = 4'b0001;
    else if (mux_timer < 2*DELAY) rows = 4'b0010;
    else if (mux_timer < 3*DELAY) rows = 4'b0100;
    else                          rows = 4'b1000;
  end
endmodule