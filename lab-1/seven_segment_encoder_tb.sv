`timescale 1ns/1ns

module seven_segment_encoder_tb();
  logic [3:0] digit;
  logic [6:0] segments;
  seven_segment_encoder dut(.digit, .segments);

  // We're testing combination logic, so we don't need a clock
  initial begin
    $dumpvars(0, digit, segments);

    digit = 0; #10;
    assert (segments == 7'b0000001)
      $display("The seven-segment encoder works for digit: 0");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: 0");

    digit = 1; #10;
    assert (segments == 7'b1001111)
      $display("The seven-segment encoder works for digit: 1");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: 1");

    digit = 2; #10;
    assert (segments == 7'b0010010)
      $display("The seven-segment encoder works for digit: 2");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: 2");

    digit = 3; #10;
    assert (segments == 7'b0000110)
      $display("The seven-segment encoder works for digit: 3");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: 3");

    digit = 4; #10;
    assert (segments == 7'b1001100)
      $display("The seven-segment encoder works for digit: 4");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: 4");

    digit = 5; #10;
    assert (segments == 7'b0100100)
      $display("The seven-segment encoder works for digit: 5");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: 5");

    digit = 6; #10;
    assert (segments == 7'b0100000)
      $display("The seven-segment encoder works for digit: 6");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: 6");

    digit = 7; #10;
    assert (segments == 7'b0001111)
      $display("The seven-segment encoder works for digit: 7");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: 7");

    digit = 8; #10;
    assert (segments == 7'b0000000)
      $display("The seven-segment encoder works for digit: 8");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: 8");

    digit = 9; #10;
    assert (segments == 7'b0000100)
      $display("The seven-segment encoder works for digit: 9");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: 9");

    digit = 10; #10;
    assert (segments == 7'b0001000)
      $display("The seven-segment encoder works for digit: A");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: A");

    digit = 11; #10;
    assert (segments == 7'b1100000)
      $display("The seven-segment encoder works for digit: B");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: B");

    digit = 12; #10;
    assert (segments == 7'b0110001)
      $display("The seven-segment encoder works for digit: C");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: C");

    digit = 13; #10;
    assert (segments == 7'b1000010)
      $display("The seven-segment encoder works for digit: D");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: D");

    digit = 14; #10;
    assert (segments == 7'b0110000)
      $display("The seven-segment encoder works for digit: E");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: E");

    digit = 15; #10;
    assert (segments == 7'b0111000)
      $display("The seven-segment encoder works for digit: F");
    else
      $error("FAILED! The seven-segment encoder displays the wrong segments for digit: F");
  end
endmodule