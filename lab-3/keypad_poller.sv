module keypad_poller #(parameter int DELAY) (
  input logic clk,
  input logic reset,
  input logic enable,
  output logic [3:0] rows
);
  // There are 4 different states, so the counter needs to hold a maximum
  // value of 4*DELAY
  logic [$clog2(4*DELAY)-1:0] value;
  counter #(.WIDTH($clog2(4*DELAY)), .MAX_COUNT(4*DELAY)) ctr(
    .clk,
    .reset,
    .enable,
    .value
  );

  // Rotate between the different outputs every DELAY cycles
  always_comb begin
    if      (value < DELAY)   rows = 4'b0001;
    else if (value < 2*DELAY) rows = 4'b0010;
    else if (value < 3*DELAY) rows = 4'b0100;
    else                      rows = 4'b1000;
  end
endmodule