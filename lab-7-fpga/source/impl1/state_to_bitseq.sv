module state_to_bitseq(
  input  logic [0:3][0:3][7:0] state,
  output logic [127:0]         bitseq
);
  /*
  See comment in bitseq_to_state.sv for an explanation of the bit-packing structure.
  */
  
  for (genvar col = 3; col >= 0; col--) begin : gen_cols
    for (genvar row = 3; row >= 0; row--) begin : gen_rows
      assign bitseq[(3 - col)*32 + (3 - row)*8 +: 8] = state[row][col];
    end
  end
endmodule