module top(
	input logic [3:0] switches,
	output logic [2:0] leds,
	output logic [6:0] seven_segment_leds
);
	// Internal high-speed oscillator
	logic clk;
	SB_HFOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

	logic [23:0] clk_counter = 0;
	counter ctr (.clk, .enable(1'b1), .reset(1'b1), .num(clk_counter));

	assign leds[0] = switches[1] ^ switches[0];
	assign leds[1] = switches[3] & switches[2];
	assign leds[2] = clk_counter[23];

	seven_segment_encoder encoder (.digit(switches), .segments(seven_segment_leds));
endmodule