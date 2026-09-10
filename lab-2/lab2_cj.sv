module lab2_cj (
  input logic n_reset,
  output logic [1:0] seg7_anode,
  output logic [6:0] seg7_segments
);
  logic hf_osc_clk; // 24 MHz
  SB_HFOSC #(.CLKHF_DIV("0b01")) hf_osc (
    .CLKHFPU(1'b1),
    .CLKHFEN(1'b1),
    .CLKHF(hf_osc_clk)
  );

  logic [23:0] display_timer;
  logic [7:0] display_value;
  counter #(.WIDTH(24)) display_value_counter(
    .clk(hf_osc_clk),
    .enable(1'b1),
    .reset(~n_reset),
    .value(display_timer)
  );

  always_ff @(posedge display_timer[23] or negedge n_reset) begin
    if (!n_reset) begin
      display_value <= 0;
    end else begin
      display_value <= display_value + 1;
    end
  end

  logic seg7_anode_select;
  dual_seg7 #(.SWITCH_CYCLES(200000)) display(
    .clk(hf_osc_clk),
    .reset(~n_reset),
    .digit_0(display_value[3:0]),
    .digit_1(display_value[7:4]),
    .anode_select(seg7_anode_select),
    .segments(seg7_segments)
  );
  assign seg7_anode[1] = ~seg7_anode_select;
  assign seg7_anode[0] = seg7_anode_select;
endmodule