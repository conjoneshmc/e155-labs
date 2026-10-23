module add_round_key(
  input  logic [127:0]     a,
  input  logic [0:3][31:0] w,
  output logic [127:0]     y
);
  // Conversion to and from state vector
  logic [0:3][0:3][7:0] a_state;
  logic [0:3][0:3][7:0] y_state;
  block_to_state input_reshaper(.block(a), .state(a_state));
  state_to_block output_reshaper(.block(y), .state(y_state));

  // XOR each column of the state with the four different words
  for (genvar col = 0; col < 4; col++) begin : gen_col
    assign y_state[0][col] = a_state[0][col] ^ w[col][31:24];
    assign y_state[1][col] = a_state[1][col] ^ w[col][23:16];
    assign y_state[2][col] = a_state[2][col] ^ w[col][15:8];
    assign y_state[3][col] = a_state[3][col] ^ w[col][7:0];
  end
endmodule