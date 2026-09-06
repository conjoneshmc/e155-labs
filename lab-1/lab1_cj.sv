module lab1_cj(
	input logic reset_bar, // Push buttons on dev board are active LOW
	input logic [3:0] switches,
	output logic [2:0] leds,
	output logic [6:0] seven_segment_leds
);
	// Internal high-speed oscillator
	logic hf_osc_clk;
	SB_HFOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(hf_osc_clk));

	// Clock counter to divide frequency
	logic led_clk;
	clk_freq_divider #(.WIDTH(32), .MAXCOUNT(10000000)) ctr (
		.clk_in(hf_osc_clk),
		.enable(1'b1),
		.reset(!reset_bar),
		.clk_out(led_clk)
	);

	// Combinational logic for switches
	// NOTE: The switch pins are pulled HIGH when the switches are off, so we have
	// to invert them in our code
	assign leds[0] = (~switches[1]) ^ (~switches[0]);
	assign leds[1] = (~switches[3]) & (~switches[2]);
	assign leds[2] = led_clk;

	// Combinational logic for 7-segment display
	// Same note as above, switch pins are active low
	seven_segment_encoder encoder (.digit(~switches), .segments(seven_segment_leds));
endmodule