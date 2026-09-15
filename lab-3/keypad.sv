module keypad #(parameter int POLL_DELAY) (
  input logic clk,
  input logic reset,
  input logic enable,
  input logic [3:0] cols,
  output logic [3:0] rows,
  output logic [3:0] buttons [3]
);

endmodule