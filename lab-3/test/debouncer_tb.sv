// `timescale 1ns/1ns

// module debouncer_tb();
//   logic clk;
//   logic reset;
//   logic enable;
//   logic in;
//   logic out;
//   debouncer #(.DELAY(10)) dut(.clk, .reset, .enable, .in, .out);

//   task clk_toggle(input int cycles);
//     for (int i = 0; i < cycles; i++) begin
//       clk = 1; #5;
//       clk = 0; #5;
//     end
//   endtask

//   initial begin
//     $dumpvars(0, clk, reset, enable, in, out, dut.value);

//     clk = 0;
//     enable = 1;
//     in = 0;

//     reset = 1; #5;
//     clk_toggle(1);
//     reset = 0; #5;

//     in = 1; #5;
//     clk_toggle(3);
//     in = 0; #5;
//     clk_toggle(1);

//     in = 1; #5;
//     clk_toggle(7);
//     in = 0; #5;
//     clk_toggle(4);

//     in = 1; #5;
//     clk_toggle(15);

//     in = 0; #5;
//     clk_toggle(6);
//     in = 1; #5;
//     clk_toggle(2);

//     in = 0; #5;
//     clk_toggle(17);

//     in = 1; #5;
//     clk_toggle(10);
//     in = 0; #5;
//     clk_toggle(12);

//     $finish();
//   end
// endmodule