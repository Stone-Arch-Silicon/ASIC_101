// SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
// SPDX-License-Identifier: Apache-2.0
//
// Formal harness: prove that adder8 adds correctly for ALL inputs,
// without writing a single test vector.

module adder8_props (
  input wire [7:0] a,
  input wire [7:0] b,
  input wire       cin
);

  wire [7:0] sum;
  wire       cout;

  adder8 dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

  always @* begin
    assert ({cout, sum} == a + b + cin);
  end

endmodule
