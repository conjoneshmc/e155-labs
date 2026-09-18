module keypad #(parameter int POLL_DELAY, parameter int DEBOUNCE_DELAY) (
  input logic clk,
  input logic reset,
  input logic enable,
  input logic [3:0] cols,
  output logic [3:0] rows,
  output logic [3:0] buttons [3]
);
  keypad_poller #(.DELAY(POLL_DELAY)) poller(
    .clk,
    .reset,
    .enable,
    .rows
  );

  logic [3:0] buttons_raw [3];
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

  always_ff @(posedge clk) begin
    if (reset) begin
      buttons <= '{default: '0};
      buttons_raw <= '{default: '0};
    end
    // Based on the row being interrogated, update the appropriate inputs
    else if (rows == 4'b0001) buttons_raw[0] <= cols;
    else if (rows == 4'b0010) buttons_raw[1] <= cols;
    else if (rows == 4'b0100) buttons_raw[2] <= cols;
    else if (rows == 4'b1000) buttons_raw[3] <= cols;
    // For invalid row outputs, don't update anything
  end
endmodule