module sub_word(
  input  logic        clk,
  input  logic [31:0] a,
  output logic [31:0] y
);
  sbox_sync sub_a0(.clk, .a(a[31:24]), .y(y[31:24]));
  sbox_sync sub_a1(.clk, .a(a[23:16]), .y(y[23:16]));
  sbox_sync sub_a2(.clk, .a(a[15:8]),  .y(y[15:8]));
  sbox_sync sub_a3(.clk, .a(a[7:0]),   .y(y[7:0]));
endmodule