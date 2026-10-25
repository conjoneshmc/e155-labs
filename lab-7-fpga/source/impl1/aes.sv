module aes(
  input  logic sck, 
  input  logic sdi,
  output logic sdo,
  input  logic load,
  output logic done
);
  // Internal clock @ 6 MHz
  logic clk;
  HSOSC #(.CLKHF_DIV(2'b11)) hf_osc(
    .CLKHFPU(1'b1),
    .CLKHFEN(1'b1),
    .CLKHF(clk)
  );

  logic [127:0] key, plaintext, cyphertext;
  aes_spi spi(sck, sdi, sdo, done, key, plaintext, cyphertext);   
  aes_core core(clk, load, key, plaintext, done, cyphertext);
endmodule