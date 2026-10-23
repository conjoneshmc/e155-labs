module shift_rows(
  input  logic [127:0] a,
  output logic [127:0] y
);
  // Conversion to and from state vector
  logic [0:3][0:3][7:0] a_state;
  logic [0:3][0:3][7:0] y_state;
  block_to_state input_reshaper(.block(a), .state(a_state));
  state_to_block output_reshaper(.block(y), .state(y_state));

  // Row 0 remains unchanged
  // Row 1 gets cyclically shifted left by 1
  // Row 2 gets cyclically shifted left by 2
  // Row 3 gets cyclically shifted left by 3
  assign y_state[0] = a_state[0];
  assign y_state[1] = {a_state[1][1], a_state[1][2], a_state[1][3], a_state[1][0]};
  assign y_state[2] = {a_state[2][2], a_state[2][3], a_state[2][0], a_state[2][1]};
  assign y_state[3] = {a_state[3][3], a_state[3][0], a_state[3][1], a_state[3][2]};
endmodule