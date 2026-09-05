module clk_freq_divider #(parameter WIDTH = 16, MAXCOUNT = (1<<WIDTH) - 1) (
  input logic clk_in,
  input logic enable,
  input logic reset,
  output logic clk_out
);
  logic [WIDTH-1:0] counter;
  always_ff @(posedge clk_in or posedge reset) begin
		if (reset) begin
      counter <= 0;
      clk_out <= 0;
    end
    else if (enable) begin
      if (counter < MAXCOUNT)
        counter <= counter + 1;
      else begin
        counter <= 0;
        clk_out <= !clk_out;
      end
    end
	end
endmodule