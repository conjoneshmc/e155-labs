module keypad_entry(
  input logic clk,
  input logic reset,
  input logic [3:0] [3:0] buttons,
  output logic [3:0] digit_1,
  output logic [3:0] digit_0
);
  logic [3:0] next_digit;
  logic [3:0] num_pressed;
  logic should_update;

  // Decodes the keypad button being pressed into a hexadecimal digit
  keypad_decoder decoder(
    .buttons,
    .digit(next_digit),
    .num_pressed
  );

  // Handles multipress conditions
  keypad_multipress mp(
    .clk,
    .reset,
    .num_pressed,
    .should_update
  );

  always_ff @(posedge clk) begin
    if (reset) begin
      digit_1 <= 4'h0;
      digit_0 <= 4'h0;
    end
    else begin
      if (should_update) begin
        digit_1 <= digit_0;
        digit_0 <= next_digit;
      end
    end
  end
endmodule