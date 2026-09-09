module counter #(parameter int WIDTH, int MAXCOUNT = (1<<WIDTH) - 1) (
  input logic clk,
  input logic enable,
  input logic reset,
  output logic [WIDTH-1:0] value
);
  always_ff @(posedge clk or posedge reset) begin
    if (reset) value <= 0;
    else if (enable) begin
      if (value < MAXCOUNT - 1) value <= value + 1;
      else value <= 0;
    end
  end
endmodule