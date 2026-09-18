module seg7_dual #(parameter int DELAY) (
  input logic clk,
  input logic reset,
  input logic [3:0] digit_1,
  input logic [3:0] digit_0,
  output logic [1:0] anodes,
  output logic [6:0] segments
);
  logic [$clog2(2*DELAY)-1:0] mux_timer;
  logic mux_select;
  logic [3:0] mux_digit;

  counter #(.WIDTH($clog2(2*DELAY)), .MAX_COUNT(2*DELAY)) ctr(
    .clk,
    .reset,
    .enable(1'b1),
    .value(mux_timer)
  );

  seg7 display(.digit(mux_digit), .segments);

  always_comb begin
    mux_select = (mux_timer >= DELAY);
    mux_digit = mux_select ? digit_1 : digit_0;
    anodes = {~mux_select, mux_select}; // Anodes are active LOW
  end
endmodule