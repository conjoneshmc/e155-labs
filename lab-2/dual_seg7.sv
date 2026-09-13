module dual_seg7 #(parameter int MULTIPLEX_PERIOD) (
  input logic clk,
  input logic reset,
  input logic [3:0] digit_1,
  input logic [3:0] digit_0,
  output logic [1:0] anodes,
  output logic [6:0] segments
);
  // Internal counter used to multiplex the two digits of the display
  logic [$clog2(MULTIPLEX_PERIOD)-1:0] multiplex_ctr_value;
  counter #(.WIDTH($clog2(MULTIPLEX_PERIOD)), .MAXCOUNT(MULTIPLEX_PERIOD)) multiplex_ctr(
    .clk,
    .reset,
    .enable(1'b1),
    .value(multiplex_ctr_value)
  );

  // Combinational logic for anode and cathodes of seven segment display
  logic anode_select;
  logic [3:0] digit_to_use;
  always_comb begin
    anode_select = (multiplex_ctr_value >= (MULTIPLEX_PERIOD / 2));
    anodes = {~anode_select, anode_select}; // Anodes are active LOW
    digit_to_use = anode_select ? digit_1 : digit_0;
  end

  // Only instantiate one 7-segment module
  seg7 display(.digit(digit_to_use), .segments);
endmodule