module keypad #(
  parameter int POLL_DELAY,
  parameter int SETTLE_DELAY,
  parameter int DEBOUNCE_DELAY
) (
  input logic clk,
  input logic reset,
  input logic enable,
  input logic [3:0] cols,
  output logic [3:0] rows,
  output logic [3:0] [3:0] buttons
);
  logic enable_debouncers;
  logic [3:0] [3:0] buttons_raw; // Un-debounced inputs for each of the buttons

  // Responsible for interrogating the different keypad rows
  // This state machine just rotates between pulling each row pin high
  keypad_poller #(.POLL_DELAY(POLL_DELAY)) poller(
    .clk,
    .reset,
    .enable,
    .rows
  );

  // We don't want to look at the column pins right after a row has changed, so we can wait for
  // everything to settle
  // This state machine disables all the debouncers for a certain period after each row change,
  // then turns them back on
  keypad_settler #(.POLL_DELAY(POLL_DELAY), .SETTLE_DELAY(SETTLE_DELAY)) settler(
    .clk,
    .reset,
    .enable,
    .settled(enable_debouncers)
  );

  // Each button on the keypad needs its own debouncer
  genvar row, col;
  generate
    for (row = 0; row < 4; row++) begin : gen_keypad_rows
      for (col = 0; col < 4; col++) begin : gen_keypad_cols
        debouncer #(.DELAY(DEBOUNCE_DELAY)) button(
          .clk,
          .reset,
          .enable(enable & enable_debouncers),
          .in(buttons_raw[row][col]),
          .out(buttons[row][col])
        );
      end
    end
  endgenerate

  // Logic responsible for updating `buttons_raw`
  always_ff @(posedge clk) begin
    if (reset) begin
      buttons_raw[0] <= 4'b0000;
      buttons_raw[1] <= 4'b0000;
      buttons_raw[2] <= 4'b0000;
      buttons_raw[3] <= 4'b0000;
    end else begin
      // Update the row currently being interrogated with the buttons being pressed in this row
      if      (rows == 4'b0001) buttons_raw[0] <= cols;
      else if (rows == 4'b0010) buttons_raw[1] <= cols;
      else if (rows == 4'b0100) buttons_raw[2] <= cols;
      else if (rows == 4'b1000) buttons_raw[3] <= cols;
      // For invalid row outputs, don't update anything
    end
  end
endmodule