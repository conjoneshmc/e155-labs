module lab1_cj(
	input logic reset_bar, // Push buttons on dev board are active LOW
	input logic [3:0] switches_bar,
	output logic [2:0] leds,
	output logic [6:0] seven_segment_leds
);
	// Internal high-speed oscillator
	// Have to run the clock at a lower frequency because I was getting timing violations
	// The clock runs at 24MHz, I adjusted MAXCOUNT to compensate
	logic hf_osc_clk;
	SB_HFOSC #(.CLKHF_DIV("0b01")) hf_osc (
		.CLKHFPU(1'b1),
		.CLKHFEN(1'b1),
		.CLKHF(hf_osc_clk)
	);

	// Clock counter to divide frequency
	logic led_clk;
	clk_freq_divider #(.WIDTH(32), .MAXCOUNT(5000000)) ctr (
		.clk_in(hf_osc_clk),
		.enable(1'b1),
		.reset(~reset_bar),
		.clk_out(led_clk)
	);

	// Combinational logic for switches
	// NOTE: The switch pins are pulled HIGH when the switches are off, so we have
	// to invert them in our code
	assign leds[0] = (~switches_bar[1]) ^ (~switches_bar[0]);
	assign leds[1] = (~switches_bar[3]) & (~switches_bar[2]);
	assign leds[2] = led_clk;

	// Combinational logic for 7-segment display
	// Same note as above, switch pins are active low
	seven_segment_encoder encoder (.digit(~switches_bar), .segments(seven_segment_leds));
endmodule