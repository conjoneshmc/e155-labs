module sync(
  input logic clk,
  input logic reset,
  input logic in,
  output logic out
);
  logic temp;

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