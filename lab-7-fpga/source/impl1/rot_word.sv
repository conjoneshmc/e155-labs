module rot_word(
  input  logic [31:0] a,
  output logic [31:0] y
);
  assign y[31:24] = a[23:16]; // y[0] = a[1]
  assign y[23:16] = a[15:8];  // y[1] = a[2]
  assign y[15:8]  = a[7:0];   // y[2] = a[3]
  assign y[7:0]   = a[31:24]; // y[3] = a[0]
endmodule