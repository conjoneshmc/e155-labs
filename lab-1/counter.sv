module counter #(parameter WIDTH = 16, MAXCOUNT = (1<<WIDTH) - 1) (
  input logic clk,
  input logic enable,
  input logic reset,
  output logic [WIDTH-1:0] value
);
  always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
      value <= 0;
    end
    else if (enable) begin
      if (value < MAXCOUNT - 1)
        value <= value + 1;
      else begin
        value <= 0;
      end
    end
	end
endmodule