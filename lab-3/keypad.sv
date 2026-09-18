module keypad #(parameter int POLL_DELAY, parameter int DEBOUNCE_DELAY) (
  input logic clk,
  input logic reset,
  input logic enable,
  input logic [3:0] cols,
  output logic [3:0] rows,
  output logic [3:0] buttons [4]
);
  logic [3:0] cols_prev; // To fix a timing error
  logic [3:0] buttons_raw [4]; // Un-debounced inputs for each of the buttons

  // Responsible for interrogating the different keypad rows
  // Canonical FSM that just rotates between pulling each row pin high
  keypad_poller #(.DELAY(POLL_DELAY)) poller(
    .clk,
    .reset,
    .enable,
    .rows
  );

  // Each button on the keypad needs its own debouncer
  genvar row, col;
  generate
    for (row = 0; row < 4; row++) begin : gen_keypad_rows
      for (col = 0; col < 4; col++) begin : gen_keypad_cols
        debouncer #(.DELAY(DEBOUNCE_DELAY)) button(
          .clk,
          .reset,
          .enable,
          .in(buttons_raw[row][col]),
          .out(buttons[row][col])
        );
      end
    end
  endgenerate

  // Logic responsible for updating `buttons_raw`
  always_ff @(posedge clk) begin
    if (reset) begin
      cols_prev <= 4'b0000;
      buttons_raw[0] <= 4'b0000;
      buttons_raw[1] <= 4'b0000;
      buttons_raw[2] <= 4'b0000;
      buttons_raw[3] <= 4'b0000;
    end else begin
      // Because `rows` is also updated on the rising edge of the clock, the value of `rows` read in
      // the if statement is actually the one from the PREVIOUS clock cycle
      // Therefore, we need the value of `cols` from the previous clock cycle too, so we can update
      // the `buttons_raw` array correctly
      // This extra register addresses this timing error
      // Note that since this is a non-blocking assignment, the value of `cols_prev` is actually from
      // the previous clock cycle. The assignment doesn't affect the if statements below
      cols_prev <= cols;

      // Update the row currently being interrogated with the buttons being pressed in this row
      if      (rows == 4'b0001) buttons_raw[0] <= cols_prev;
      else if (rows == 4'b0010) buttons_raw[1] <= cols_prev;
      else if (rows == 4'b0100) buttons_raw[2] <= cols_prev;
      else if (rows == 4'b1000) buttons_raw[3] <= cols_prev;
      // For invalid row outputs, don't update anything
    end
  end
endmodule