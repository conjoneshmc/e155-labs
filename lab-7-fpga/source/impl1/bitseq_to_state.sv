module bitseq_to_state(
  input  logic [127:0]         bitseq,
  output logic [0:3][0:3][7:0] state
);
  /*
  The state array indices are:
  [0:3] [0:3]   [7:0]
  ^row  ^column ^bits (in each byte)
  
  When SystemVerilog packs a 1D array into a multi-dimensional array, the rightmost indices vary the fastest, while
  the leftmost indices vary the slowest. So bits (in each byte) would vary the fastest, followed by the columns, then
  the rows would vary the slowest.
  
  This is a problem! According to the packing used throughout the starter code, the bits (in each byte) vary the fastest,
  followed by the ROWS, and then the COLUMNS are supposed to vary the slowest. This is backwards from what SystemVerilog
  does! If we just assigned state to bitseq, we would be packing in row major order, not column major order.
  
  ... ~~~~~~~~~~~~~~~~~~~~  3 ~~~~~~~~~~~~~~~~~~~~  0 ~~~~~~~~~~~~~~~~~~~~  1 ~~~~~~~~~~~~~~~~~~~~  2 ~~~~~~~~~~~~~~~~~~~~  3    [0:3] row
  ... ~~~~~~~~~~~~~~~~~~~~  2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  3    [0:3] column
  ...  7  6  5  4  3  2  1  0  7  6  5  4  3  2  1  0  7  6  5  4  3  2  1  0  7  6  5  4  3  2  1  0  7  6  5  4  3  2  1  0    [7:0] bit
  ... 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0  [127:0] bitseq
  
  To solve this issue, we will use generate blocks and pack the state vector manually. Given the row r, column c, and bit
  position b, we can find the bitseq index n using the following formula:
  
  n = (3 - c)*32 + (3 - r)*8 + b
  */
  
  for (genvar col = 3; col >= 0; col--) begin : gen_cols
    for (genvar row = 3; row >= 0; row--) begin : gen_rows
      assign state[row][col] = bitseq[(3 - col)*32 + (3 - row)*8 +: 8];
    end
  end
endmodule