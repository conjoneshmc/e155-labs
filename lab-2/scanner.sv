module scanner #(parameter int SCAN_DELAY) (
  input logic clk,
  input logic reset,
  input logic enable,
  output logic [3:0] out
);
  // Internal logic used to toggle between different states
  logic [$clog2(4*SCAN_DELAY)-1:0] state_ctr_value;
  counter #(.WIDTH($clog2(4*SCAN_DELAY)), .MAXCOUNT(4*SCAN_DELAY)) state_ctr(
    .clk,
    .reset,
    .enable,
    .value(state_ctr_value)
  );

  // Rotate between the different outputs every SCAN_DELAY cycles
  always_comb begin
    if      (state_ctr_value < SCAN_DELAY)   out = 4'b1000;
    else if (state_ctr_value < 2*SCAN_DELAY) out = 4'b0100;
    else if (state_ctr_value < 3*SCAN_DELAY) out = 4'b0010;
    else                                     out = 4'b0001;
  end
endmodule