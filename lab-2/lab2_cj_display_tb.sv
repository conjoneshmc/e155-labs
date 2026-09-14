`timescale 1ns/1ns

module lab2_cj_display_tb();
  logic reset;
  logic [3:0] digit_1;
  logic [3:0] digit_0;
  logic [1:0] seg7_anodes;
  logic [6:0] seg7_segments;
  lab2_cj_display dut(
    .n_reset(~reset),
    .n_digit_1(~digit_1),
    .n_digit_0(~digit_0),
    .seg7_anodes,
    .seg7_segments
  );

  task clk_toggle(input int cycles);
    for (int i = 0; i < cycles; i++) begin
      dut.hf_osc_clk = 1; #5;
      dut.hf_osc_clk = 0; #5;
    end
  endtask

  initial begin
    $dumpvars(0, dut.hf_osc_clk, reset, digit_1, digit_0, seg7_anodes, seg7_segments);

    dut.hf_osc_clk = 0;
    reset = 1;
    digit_1 = 4'b0010; // 2
    digit_0 = 4'b1001; // 9
    #10;
    reset = 0;
    #10;

    for (int i = 0; i < 2; i++) begin
      assert (seg7_anodes == 2'b10) else
        $error("FAILED! seg7_anodes has wrong value");
      assert (seg7_segments == 7'b0000100) else
        $error("FAILED! seg7_segments has wrong value");

      clk_toggle(4);

      assert (seg7_anodes == 2'b01) else
        $error("FAILED! seg7_anodes has wrong value");
      assert (seg7_segments == 7'b0010010) else
        $error("FAILED! seg7_segments has wrong value");

      clk_toggle(4);
    end

    digit_1 = 4'b0111; // 7
    digit_0 = 4'b1100; // C
    #5;

    clk_toggle(2);
    assert (seg7_segments == 7'b0110001) else
      $error("FAILED! seg7_segments has wrong value");
    clk_toggle(10);
    #20;

    $finish();
  end
endmodule