module counter #(parameter int WIDTH, parameter int MAX_COUNT = (1<<WIDTH) - 1) (
  input logic clk,
  input logic reset,
  input logic enable,
  output logic [WIDTH-1:0] value,
  output logic overflow
);
  always_ff @(posedge clk) begin
    if (reset) value <= 0;
    else if (enable) begin
      if (value < MAX_COUNT - 1) value <= value + 1;
      else value <= 0;
    end
  end

  always_ff @(posedge clk) begin
    if (reset) overflow <= 0;
    else if (value >= MAX_COUNT - 1) overflow <= 1;
    else overflow <= 0;
  end
endmodule