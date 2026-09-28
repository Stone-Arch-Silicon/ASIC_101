// SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
// SPDX-License-Identifier: Apache-2.0
//
// Formal properties for alu_core. Each assert is a rule that must hold for every
// possible a, b and op. The solver either proves all of them or hands back a
// counterexample: concrete inputs that break a rule.

module alu_props (
  input wire [7:0] a,
  input wire [7:0] b,
  input wire [2:0] op
);

  wire [7:0] y;
  wire       carry, overflow, zero, negative;

  alu_core dut (
    .a(a), .b(b), .op(op),
    .y(y), .carry(carry), .overflow(overflow), .zero(zero), .negative(negative)
  );

  // 9-bit signed sum and difference: if bit 8 and bit 7 disagree, the true
  // answer does not fit in 8 signed bits, which is exactly what overflow means.
  wire [8:0] ssum  = {a[7], a} + {b[7], b};
  wire [8:0] sdiff = {a[7], a} - {b[7], b};

  always @* begin
    // flags that hold for every operation
    assert (zero     == (y == 8'h00));
    assert (negative == y[7]);

    case (op)
      3'b000: begin
        assert ({carry, y} == a + b);
        assert (overflow   == (ssum[8] != ssum[7]));
      end
      3'b001: begin
        assert (y        == a - b);
        assert (carry    == (a >= b));            // carry = 1 means no borrow
        assert (overflow == (sdiff[8] != sdiff[7]));
      end
      default: begin
        assert (carry == 1'b0 && overflow == 1'b0);
      end
    endcase

    if (op == 3'b010) assert (y == (a & b));
    if (op == 3'b011) assert (y == (a | b));
    if (op == 3'b100) assert (y == (a ^ b));
    if (op == 3'b101) assert (y == ~a);
    if (op == 3'b110) assert (y == {a[6:0], 1'b0});
    if (op == 3'b111) assert (y == {1'b0, a[7:1]});
  end

endmodule
