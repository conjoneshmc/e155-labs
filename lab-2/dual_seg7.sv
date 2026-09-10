module dual_seg7 #(parameter int SWITCH_CYCLES) (
  input logic clk,
  input logic reset,
  input logic [3:0] digit_1,
  input logic [3:0] digit_0,
  output logic anode_select, // 1 if we're displaying digit_1, 0 otherwise
  output logic [6:0] segments
);
  logic [$clog2(SWITCH_CYCLES)-1:0] switch_ctr_val;
  logic [3:0] digit_to_use;

  // Internal counter used to multiplex the two digits of the display
  counter #(
    .WIDTH($clog2(SWITCH_CYCLES)),
    .MAXCOUNT(SWITCH_CYCLES)
  ) switch_ctr(
    .clk,
    .reset,
    .enable(1'b1),
    .value(switch_ctr_val)
  );

  // Output CL for anode and cathodes of seven segment display
  always_comb begin
    anode_select = (switch_ctr_val >= (SWITCH_CYCLES / 2));
    digit_to_use = anode_select ? digit_1 : digit_0;

    unique case (digit_to_use)
      // Format of segments[6:0] is ABCDEFG
      // Display is common anode so a 0 turns the segment ON
      4'b0000: segments = 7'b0000001; // 0
      4'b0001: segments = 7'b1001111; // 1
      4'b0010: segments = 7'b0010010; // 2
      4'b0011: segments = 7'b0000110; // 3
      4'b0100: segments = 7'b1001100; // 4
      4'b0101: segments = 7'b0100100; // 5
      4'b0110: segments = 7'b0100000; // 6
      4'b0111: segments = 7'b0001111; // 7
      4'b1000: segments = 7'b0000000; // 8
      4'b1001: segments = 7'b0000100; // 9
      4'b1010: segments = 7'b0001000; // A
      4'b1011: segments = 7'b1100000; // B
      4'b1100: segments = 7'b0110001; // C
      4'b1101: segments = 7'b1000010; // D
      4'b1110: segments = 7'b0110000; // E
      4'b1111: segments = 7'b0111000; // F
    endcase
  end
endmodule