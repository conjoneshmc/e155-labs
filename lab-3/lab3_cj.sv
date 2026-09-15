module lab3_cj(
  input logic n_reset,
  input logic n_in,
  output logic out
);
  // Internal clock @ 24 MHz
  logic hf_osc_clk;
  SB_HFOSC #(.CLKHF_DIV("0b01")) hf_osc (
    .CLKHFPU(1'b1),
    .CLKHFEN(1'b1),
    .CLKHF(hf_osc_clk)
  );

  debouncer #(.DELAY(720000)) button (
    .clk(hf_osc_clk),
    .reset(~n_reset),
    .enable(1'b1),
    .in(~n_in),
    .out
  );
endmodule