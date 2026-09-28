// SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
// SPDX-License-Identifier: Apache-2.0
//
// Combinational 8-bit ALU. ADD and SUB share one adder8 instance.
//
//   op   operation     y
//   000  ADD           a + b
//   001  SUB           a - b
//   010  AND           a & b
//   011  OR            a | b
//   100  XOR           a ^ b
//   101  NOT           ~a
//   110  shift left    a << 1
//   111  shift right   a >> 1

module alu_core (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire [2:0] op,
  output reg  [7:0] y,
  output reg        carry,
  output reg        overflow,
  output reg        zero,
  output reg        negative
);

  wire       sub     = (op == 3'b001);
  wire [7:0] b_arith = b ^ {8{sub}};   // invert b for subtraction
  wire [7:0] arith_y;
  wire       arith_cout;

  adder8 u_adder (
    .a    (a),
    .b    (b_arith),
    .cin  (sub),                         // +1 completes the two's complement
    .sum  (arith_y),
    .cout (arith_cout)
  );

  always @* begin
    y        = 8'h00;
    carry    = 1'b0;
    overflow = 1'b0;

    case (op)
      3'b000: begin
        y        = arith_y;
        carry    = arith_cout;
        overflow = (~(a[7] ^ b[7])) & (arith_y[7] ^ a[7]);
      end
      3'b001: begin
        y        = arith_y;
        carry    = arith_cout;               // 1 means "no borrow"
        overflow = (a[7] ^ b[7]) & (arith_y[7] ^ a[7]);
      end
      3'b010:  y = a & b;
      3'b011:  y = a | b;
      3'b100:  y = a ^ b;
      3'b101:  y = ~a;
      3'b110:  y = {a[6:0], 1'b0};
      default: y = {1'b0, a[7:1]};
    endcase

    zero     = (y == 8'h00);
    negative = y[7];
  end

endmodule
