`timescale 1ns/1ns

module keypad_decoder_tb();
  logic [3:0] [3:0] buttons;
  logic [3:0] digit;
  logic [3:0] num_pressed;

  keypad_decoder dut(.buttons, .digit, .num_pressed);

  initial begin
    buttons = '{4'b0000, 4'b0000, 4'b0000, 4'b0000}; #1;
    assert(digit == 4'h0) else $error();
    assert(num_pressed == 0) else $error();

    // Test button to digit logic
    buttons = '{4'b0000, 4'b0000, 4'b0000, 4'b0001}; #1;
    assert(digit == 4'hD) else $error();
    assert(num_pressed == 1) else $error();

    buttons = '{4'b0000, 4'b0000, 4'b0000, 4'b0010}; #1;
    assert(digit == 4'hE) else $error();
    assert(num_pressed == 1) else $error();

    buttons = '{4'b0000, 4'b0000, 4'b0000, 4'b0100}; #1;
    assert(digit == 4'h0) else $error();
    assert(num_pressed == 1) else $error();

    buttons = '{4'b0000, 4'b0000, 4'b0000, 4'b1000}; #1;
    assert(digit == 4'hF) else $error();
    assert(num_pressed == 1) else $error();


    buttons = '{4'b0000, 4'b0000, 4'b0001, 4'b0000}; #1;
    assert(digit == 4'hC) else $error();
    assert(num_pressed == 1) else $error();

    buttons = '{4'b0000, 4'b0000, 4'b0010, 4'b0000}; #1;
    assert(digit == 4'h9) else $error();
    assert(num_pressed == 1) else $error();

    buttons = '{4'b0000, 4'b0000, 4'b0100, 4'b0000}; #1;
    assert(digit == 4'h8) else $error();
    assert(num_pressed == 1) else $error();

    buttons = '{4'b0000, 4'b0000, 4'b1000, 4'b0000}; #1;
    assert(digit == 4'h7) else $error();
    assert(num_pressed == 1) else $error();


    buttons = '{4'b0000, 4'b0001, 4'b0000, 4'b0000}; #1;
    assert(digit == 4'hB) else $error();
    assert(num_pressed == 1) else $error();

    buttons = '{4'b0000, 4'b0010, 4'b0000, 4'b0000}; #1;
    assert(digit == 4'h6) else $error();
    assert(num_pressed == 1) else $error();

    buttons = '{4'b0000, 4'b0100, 4'b0000, 4'b0000}; #1;
    assert(digit == 4'h5) else $error();
    assert(num_pressed == 1) else $error();

    buttons = '{4'b0000, 4'b1000, 4'b0000, 4'b0000}; #1;
    assert(digit == 4'h4) else $error();
    assert(num_pressed == 1) else $error();


    buttons = '{4'b0001, 4'b0000, 4'b0000, 4'b0000}; #1;
    assert(digit == 4'hA) else $error();
    assert(num_pressed == 1) else $error();

    buttons = '{4'b0010, 4'b0000, 4'b0000, 4'b0000}; #1;
    assert(digit == 4'h3) else $error();
    assert(num_pressed == 1) else $error();

    buttons = '{4'b0100, 4'b0000, 4'b0000, 4'b0000}; #1;
    assert(digit == 4'h2) else $error();
    assert(num_pressed == 1) else $error();

    buttons = '{4'b1000, 4'b0000, 4'b0000, 4'b0000}; #1;
    assert(digit == 4'h1) else $error();
    assert(num_pressed == 1) else $error();

    // Test number of pressed buttons logic
    buttons = '{4'b1000, 4'b0100, 4'b0011, 4'b1001}; #1;
    assert(num_pressed == 6) else $error();
    buttons = '{4'b1011, 4'b0000, 4'b0000, 4'b0000}; #1;
    assert(num_pressed == 3) else $error();
    buttons = '{4'b1111, 4'b0111, 4'b1111, 4'b1000}; #1;
    assert(num_pressed == 12) else $error();
  end
endmodule