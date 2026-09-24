module sync #(parameter int WIDTH) (
  input logic clk,
  input logic reset,
  input logic [WIDTH-1:0] in,
  output logic [WIDTH-1:0] out
);
  logic [WIDTH-1:0] temp;

  always_ff @(posedge clk) begin
    if (reset) begin
      out <= 0;
      temp <= 0;
    end
    else begin
      out <= temp;
      temp <= in;
    end
  end
endmodule