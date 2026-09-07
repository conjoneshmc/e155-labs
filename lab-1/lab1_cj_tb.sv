`timescale 1ns/1ns

module lab1_cj_tb();
  logic reset_bar;
  logic [3:0] switches_bar;
  logic [2:0] leds;
  logic [6:0] seven_segment_leds;
  int hf_osc_clk_cycles = 0;
  lab1_cj dut(.reset_bar, .switches_bar, .leds, .seven_segment_leds);
  
  // Test HSOSC clock
  always @(posedge dut.hf_osc_clk) begin
		hf_osc_clk_cycles = hf_osc_clk_cycles + 1;  
  end
  
  // Test submodule connections
  always @(reset_bar) begin
	assert (dut.led_counter.reset == ~reset_bar)
	  else $error("FAILED! led_counter.reset is not connected to reset_bar properly");
  end
  
  always @(switches_bar) begin
	assert (dut.encoder.digit == ~switches_bar)
	  else $error("FAILED! encoder.digit is not connected to switches_bar properly");
  end
  
  always @(dut.hf_osc_clk) begin
	assert (dut.led_counter.clk == dut.hf_osc_clk)
	  else $error("FAILED! led_counter.clk is not connected to hf_osc_clk properly");
  end
  
  always @(dut.led_counter.value) begin
	assert (dut.led_counter.value == dut.led_counter_value)
	  else $error("FAILED! led_counter.value is not connected to led_counter_value properly");
  end
  
  always @(dut.encoder.segments) begin
	assert (dut.encoder.segments == seven_segment_leds)
	  else $error("FAILED! encoder.segments is not connected to seven_segment_leds properly");
  end

  // Test top-level assignments
  initial begin
	switches_bar = ~4'b0000;
    reset_bar = ~1; #5; reset_bar = ~0; #5;
	
	// Test led[0] and s[1:0]
    switches_bar[1:0] = ~2'b00; #10;
	assert (leds[0] == 0)
		$display("led[0] is correct for s[1:0] = 00 (1/4)");
	else
		$error("FAILED! led[0] is incorrect for s[1:0] = 00");
		
	switches_bar[1:0] = ~2'b01; #10;
	assert (leds[0] == 1)
		$display("led[0] is correct for s[1:0] = 01 (2/4)");
	else
		$error("FAILED! led[0] is incorrect for s[1:0] = 01");
		
	switches_bar[1:0] = ~2'b10; #10;
	assert (leds[0] == 1)
		$display("led[0] is correct for s[1:0] = 10 (3/4)");
	else
		$error("FAILED! led[0] is incorrect for s[1:0] = 10");
		
	switches_bar[1:0] = ~2'b11; #10;
	assert (leds[0] == 0)
		$display("led[0] is correct for s[1:0] = 11 (4/4)");
	else
		$error("FAILED! led[0] is incorrect for s[1:0] = 11");
		
	// Test led[1] and s[3:2]
    switches_bar[3:2] = ~2'b00; #10;
	assert (leds[1] == 0)
		$display("led[1] is correct for s[3:2] = 00 (1/4)");
	else
		$error("FAILED! led[1] is incorrect for s[3:2] = 00");
		
	switches_bar[3:2] = ~2'b01; #10;
	assert (leds[1] == 0)
		$display("led[1] is correct for s[3:2] = 01 (2/4)");
	else
		$error("FAILED! led[1] is incorrect for s[3:2] = 01");
		
	switches_bar[3:2] = ~2'b10; #10;
	assert (leds[1] == 0)
		$display("led[1] is correct for s[3:2] = 10 (3/4)");
	else
		$error("FAILED! led[1] is incorrect for s[3:2] = 10");
		
	switches_bar[3:2] = ~2'b11; #10;
	assert (leds[1] == 1)
		$display("led[1] is correct for s[3:2] = 11 (4/4)");
	else
		$error("FAILED! led[1] is incorrect for s[3:2] = 11");
		
	// Make sure HSOSC is working
	#500;
	assert (hf_osc_clk_cycles >= 10)
	  else $error("FAILED! Should have seen at least 10 clock cycles by now");
  end
endmodule