module keypad_multipress(
  input logic clk,
  input logic reset,
  input logic [3:0] num_pressed,
  output logic should_update
);
  // 0 = nothing being pressed
  // 1 = exactly one button being pressed
  // 2 = multipress condition
  logic [1:0] state;

  // Next state logic
  always_ff @(posedge clk) begin
    if (reset) begin
      state <= 0;
    end
    else begin
      if      (num_pressed == 0) state <= 0;
      else if (num_pressed == 1) state <= 1;
      else                       state <= 2;
    end
  end

  // Output logic (mealy state machine)
  // We should only update the display if we're entering a state of a single button press
  // from a multi-press condition or a nothing-pressed condition
  assign should_update = (state == 0 | state == 2) & (num_pressed == 1);
endmodule