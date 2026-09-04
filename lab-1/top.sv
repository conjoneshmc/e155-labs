module top(
	input logic [3:0] s,
	output logic [2:0] led
);
	logic int_osc;
	logic [24:0] counter = 0;
	
	// Internal high-speed oscillator
	SB_HFOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
	
	// Simple clock divider
	always_ff @(posedge int_osc) begin
		counter <= counter + 1;
	end

	assign led[0] = s[1] ^ s[0];
	assign led[1] = s[3] & s[2];
	assign led[2] = counter[24];
endmodule