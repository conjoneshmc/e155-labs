module counter #(parameter WIDTH = 24, MAXCOUNT = (1<<WIDTH) - 1) (
  input logic clk,
  input logic enable,
  input logic reset,
  output logic [WIDTH-1:0] num
);
  always_ff @(posedge clk or posedge reset) begin
		if (reset) num <= 0;
    else if (enable) begin
      if (num < MAXCOUNT) num <= num + 1;
      else num <= 0;
    end
	end
endmodule