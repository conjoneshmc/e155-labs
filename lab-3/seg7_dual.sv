module seg7_dual #(parameter int PERIOD) (
  input logic clk,
  input logic reset,
  input logic [3:0] digit_1,
  input logic [3:0] digit_0,
  output logic [1:0] anodes,
  output logic [6:0] segments
);
  // Internal counter used to multiplex the two digits of the display
  logic [$clog2(PERIOD)-1:0] value;
  counter #(.WIDTH($clog2(PERIOD)), .MAX_COUNT(PERIOD)) ctr(
    .clk,
    .reset,
    .enable(1'b1),
    .value
  );

  // Combinational logic for anode and cathodes of seven segment display
  logic mux_select;
  logic [3:0] mux_digit;
  always_comb begin
    mux_select = (value >= (PERIOD / 2));
    mux_digit = mux_select ? digit_1 : digit_0;
    anodes = {~mux_select, mux_select}; // Anodes are active LOW
  end

  // Only instantiate one 7-segment module
  seg7 display(.digit(mux_digit), .segments);
endmodule