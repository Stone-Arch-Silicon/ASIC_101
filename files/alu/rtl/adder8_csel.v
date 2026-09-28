// SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
// SPDX-License-Identifier: Apache-2.0
//
// Option C: 8-bit carry-select adder.
// The upper nibble is computed twice (carry-in 0 and 1); the lower carry picks one.

module rca4 (
  input  wire [3:0] a,
  input  wire [3:0] b,
  input  wire       cin,
  output wire [3:0] sum,
  output wire       cout
);

  wire [4:0] c;
  assign c[0] = cin;

  genvar i;
  generate
    for (i = 0; i < 4; i = i + 1) begin : g_fa
      assign sum[i] = a[i] ^ b[i] ^ c[i];
      assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
    end
  endgenerate

  assign cout = c[4];

endmodule

module adder8 (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire       cin,
  output wire [7:0] sum,
  output wire       cout
);

  wire [3:0] sum_low, sum_high_0, sum_high_1;
  wire       carry_low, carry_high_0, carry_high_1;

  rca4 u_low       (.a(a[3:0]), .b(b[3:0]), .cin(cin),  .sum(sum_low),    .cout(carry_low));
  rca4 u_high_if_0 (.a(a[7:4]), .b(b[7:4]), .cin(1'b0), .sum(sum_high_0), .cout(carry_high_0));
  rca4 u_high_if_1 (.a(a[7:4]), .b(b[7:4]), .cin(1'b1), .sum(sum_high_1), .cout(carry_high_1));

  assign sum[3:0] = sum_low;
  assign sum[7:4] = carry_low ? sum_high_1   : sum_high_0;
  assign cout     = carry_low ? carry_high_1 : carry_high_0;

endmodule
