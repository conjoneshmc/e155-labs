`timescale 10ns/1ns

module sub_bytes_tb();
  logic clk;
  logic [127:0] a;
  logic [127:0] y;

  sub_bytes dut(.clk, .a, .y);

  task check(
    input string name,
    input logic [127:0] in,
    input logic [127:0] expected
  );
    if ($isunknown(in) || $isunknown(expected)) begin
      $error("%s: input or expected value contains unknown bits (x)", name);
    end
    else begin
      a = in;
      @(posedge clk); #1;
      if (y === expected) begin
        $display("%s: PASSED successfully", name);
      end
      else begin
        $error("%s: expected result does not match output", name);
        $error("  input: %h", in);
        $error("  output: %h", y);
        $error("  expected: %h", expected);
      end
    end
  endtask

  always #5 clk = ~clk;
  initial begin
    clk = 0;

    check(
      "after sub_bytes round 1",
      128'h193de3bea0f4e22b9ac68d2ae9f84808,
      128'hd42711aee0bf98f1b8b45de51e415230
    );

    check(
      "after sub_bytes round 4",
      128'h486c4eee671d9d0d4de3b138d65f58e7,
      128'h52502f2885a45ed7e311c807f6cf6a94
    );

    check(
      "after sub_bytes round 9",
      128'hea835cf00445332d655d98ad8596b0c5,
      128'h87ec4a8cf26ec3d84d4c46959790e7a6
    );

    $stop();
  end
endmodule