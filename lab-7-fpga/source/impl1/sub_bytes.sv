module sub_bytes(
  input  logic         clk,
  input  logic [127:0] a,
  output logic [127:0] y
);
  // Conversion to and from state vector
  logic [0:3][0:3][7:0] a_state;
  logic [0:3][0:3][7:0] y_state;
  block_to_state input_reshaper(.block(a), .state(a_state));
  state_to_block output_reshaper(.block(y), .state(y_state));

  // Perform s-box substitution on each byte of the state vector
  for (genvar col = 0; col < 4; col++) begin : gen_col
    for (genvar row = 0; row < 4; row++) begin : gen_row
      sbox_sync byte_sub(.clk, .a(a_state[row][col]), .y(y_state[row][col]));
    end
  end
endmodule