`timescale 1ns/1ns

module lab1_cj_tb();
  logic reset_bar;
  logic [3:0] switches;
  logic [2:0] leds;
  logic [6:0] seven_segment_leds;
  lab1_cj dut(.reset_bar, .switches, .leds, .seven_segment_leds);

  initial begin
    $dumpvars(0, dut.hf_osc_clk);

    reset_bar = 1;
    switches = 4'b0000;
    #300;
  end
endmodule