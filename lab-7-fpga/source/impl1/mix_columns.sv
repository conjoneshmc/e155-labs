module mix_columns(
  input  logic [127:0] a,
  output logic [127:0] y
);
  mix_column mc0(a[127:96], y[127:96]);
  mix_column mc1(a[95:64],  y[95:64]);
  mix_column mc2(a[63:32],  y[63:32]);
  mix_column mc3(a[31:0],   y[31:0]);
endmodule


module mix_column(
  input  logic [31:0] a,
  output logic [31:0] y
);                      
  logic [7:0] a0, a1, a2, a3, y0, y1, y2, y3, t0, t1, t2, t3, tmp;
  
  assign {a0, a1, a2, a3} = a;
  assign tmp = a0 ^ a1 ^ a2 ^ a3;

  galois_mult gm0(a0^a1, t0);
  galois_mult gm1(a1^a2, t1);
  galois_mult gm2(a2^a3, t2);
  galois_mult gm3(a3^a0, t3);
  
  assign y0 = a0 ^ tmp ^ t0;
  assign y1 = a1 ^ tmp ^ t1;
  assign y2 = a2 ^ tmp ^ t2;
  assign y3 = a3 ^ tmp ^ t3;
  assign y = {y0, y1, y2, y3};    
endmodule


module galois_mult(
  input  logic [7:0] a,
  output logic [7:0] y
);
  logic [7:0] ashift;
  assign ashift = {a[6:0], 1'b0};
  assign y = a[7] ? (ashift ^ 8'b00011011) : ashift;
endmodule