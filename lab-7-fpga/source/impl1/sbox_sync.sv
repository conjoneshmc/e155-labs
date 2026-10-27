module sbox_sync(
	input	 	logic 			clk,
	input		logic [7:0] a,
	output 	logic [7:0] y
);
  // sbox implemented as a ROM
  // This module is synchronous and will be inferred using BRAMs (Block RAMs)
  logic [7:0] sbox [0:255];
  initial $readmemh("sbox.txt", sbox);

	always_ff @(posedge clk) begin
		y <= sbox[a];
	end
endmodule