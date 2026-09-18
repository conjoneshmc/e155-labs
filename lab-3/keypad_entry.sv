module keypad_entry(
  input logic clk,
  input logic reset,
  input logic [3:0] [3:0] buttons,
  output logic [3:0] digit_1,
  output logic [3:0] digit_0
);
  logic pressed; // To filter out additional keypresses
  logic [3:0] next_digit;

  keypad_decoder decoder(.buttons, .digit(next_digit));

  always_ff @(posedge clk) begin
    if (reset) begin
      pressed <= 0;
      digit_1 <= 4'h0;
      digit_0 <= 4'h0;
    end
    else begin
      // `pressed` stores whether any buttons were pressed during the previous clock cycle
      // If no buttons were pressed on the previous clock cycle, but there ARE buttons being pressed
      // on this clock cycle, we need to update the display
      pressed <= (|buttons != 0);
      if (~pressed & (|buttons != 0)) begin
        digit_1 <= digit_0;
        digit_0 <= next_digit;
      end
    end
  end
endmodule