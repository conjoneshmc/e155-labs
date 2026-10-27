`timescale 10ns/1ns

module add_round_key_tb();
  logic [127:0] a;
  logic [0:3][31:0] w;
  logic [127:0] y;

  add_round_key dut(.a, .w, .y);

  task check(
    input string name,
    input logic [127:0] in_a,
    input logic [0:3][31:0] in_w,
    input logic [127:0] expected
  );
    if ($isunknown(in_a) || $isunknown(in_w) || $isunknown(expected)) begin
      $error("%s: input or expected value contains unknown bits (x)", name);
    end
    else begin
      a = in_a;
      w = in_w; #1;
      if (y === expected) begin
        $display("%s: PASSED successfully", name);
      end
      else begin
        $error("%s: expected result does not match output", name);
        $error("  input: %h", in_a);
        $error("  w[0]: %h", in_w[0]);
        $error("  w[1]: %h", in_w[1]);
        $error("  w[2]: %h", in_w[2]);
        $error("  w[3]: %h", in_w[3]);
        $error("  output: %h", y);
        $error("  expected: %h", expected);
      end
    end
  endtask

  initial begin
    check(
      "start round 1",
      128'h3243f6a8885a308d313198a2e0370734,
      '{32'h2b7e1516, 32'h28aed2a6, 32'habf71588, 32'h09cf4f3c},
      128'h193de3bea0f4e22b9ac68d2ae9f84808
    );

    check(
      "start round 2",
      128'h046681e5e0cb199a48f8d37a2806264c,
      '{32'ha0fafe17, 32'h88542cb1, 32'h23a33939, 32'h2a6c7605},
      128'ha49c7ff2689f352b6b5bea43026a5049
    );

    check(
      "start round 8",
      128'h1415b5bf461615ec274656d7342ad843,
      '{32'h4e54f70e, 32'h5f5fc9f3, 32'h84a64fb2, 32'h4ea6dc4f},
      128'h5a4142b11949dc1fa3e019657a8c040c
    );

    $stop();
  end
endmodule