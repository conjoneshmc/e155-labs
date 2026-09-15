module keypad_poller #(parameter int DELAY) (
  input logic clk,
  input logic reset,
  input logic enable,
  output logic [3:0] rows
);
  // Internal logic used to toggle between different states
  logic [$clog2(4*DELAY)-1:0] value;
  counter #(.WIDTH($clog2(4*DELAY)), .MAX_COUNT(4*DELAY)) ctr(
    .clk,
    .reset,
    .enable,
    .value
  );

  // Rotate between the different outputs every SCAN_DELAY cycles
  always_comb begin
    if      (value < DELAY)       rows = 4'b1000;
    else if (value < 2*DELAY)     rows = 4'b0100;
    else if (value < 3*DELAY)     rows = 4'b0010;
    else                          rows = 4'b0001;
  end
endmodule