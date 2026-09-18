module keypad_decoder(
  input logic [3:0] [3:0] buttons,
  output logic [3:0] digit
);
  always_comb begin
    if      (buttons[3][3]) digit = 4'h1;
    else if (buttons[3][2]) digit = 4'h2;
    else if (buttons[3][1]) digit = 4'h3;
    else if (buttons[3][0]) digit = 4'hA;
    else if (buttons[2][3]) digit = 4'h4;
    else if (buttons[2][2]) digit = 4'h5;
    else if (buttons[2][1]) digit = 4'h6;
    else if (buttons[2][0]) digit = 4'hB;
    else if (buttons[1][3]) digit = 4'h7;
    else if (buttons[1][2]) digit = 4'h8;
    else if (buttons[1][1]) digit = 4'h9;
    else if (buttons[1][0]) digit = 4'hC;
    else if (buttons[0][3]) digit = 4'hF;
    else if (buttons[0][2]) digit = 4'h0;
    else if (buttons[0][1]) digit = 4'hE;
    else if (buttons[0][0]) digit = 4'hD;
    else                    digit = 4'h0;
  end
endmodule