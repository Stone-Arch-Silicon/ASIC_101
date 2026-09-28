// SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
// SPDX-License-Identifier: Apache-2.0
//
// Tiny Tapeout wrapper for the ASIC 101 ALU.
//
// Tiny Tapeout gives every project the same 24 pins: 8 inputs (ui_in),
// 8 outputs (uo_out) and 8 bidirectional pins (uio). The ALU needs 19 input
// bits, so operands are loaded one byte at a time through ui_in:
//
//   uio[0]  in   load_a   on a rising clock edge with load_a = 1, a  <= ui_in
//   uio[1]  in   load_b   on a rising clock edge with load_b = 1, b  <= ui_in
//   uio[2]  in   load_op  on a rising clock edge with load_op = 1, op <= ui_in[2:0]
//   uio[3]  in   (unused)
//   uio[4]  out  carry
//   uio[5]  out  overflow
//   uio[6]  out  zero
//   uio[7]  out  negative
//   uo_out  out  y, registered: it updates one clock edge after a, b or op changes

`default_nettype none

module tt_um_sasi_alu (
  input  wire [7:0] ui_in,
  output wire [7:0] uo_out,
  input  wire [7:0] uio_in,
  output wire [7:0] uio_out,
  output wire [7:0] uio_oe,
  input  wire       ena,      // high whenever this design is selected; unused
  input  wire       clk,
  input  wire       rst_n
);

  reg  [7:0] a_q, b_q, y_q;
  reg  [2:0] op_q;
  reg  [3:0] flags_q;

  wire [7:0] y;
  wire       carry, overflow, zero, negative;

  alu_core u_alu (
    .a(a_q), .b(b_q), .op(op_q),
    .y(y), .carry(carry), .overflow(overflow), .zero(zero), .negative(negative)
  );

  always @(posedge clk) begin
    if (!rst_n) begin
      a_q     <= 8'h00;
      b_q     <= 8'h00;
      op_q    <= 3'b000;
      y_q     <= 8'h00;
      flags_q <= 4'b0100;             // y = 0, so the zero flag starts at 1
    end else begin
      if (uio_in[0]) a_q  <= ui_in;
      if (uio_in[1]) b_q  <= ui_in;
      if (uio_in[2]) op_q <= ui_in[2:0];
      y_q     <= y;
      flags_q <= {negative, zero, overflow, carry};
    end
  end

  assign uo_out  = y_q;
  assign uio_out = {flags_q, 4'b0000};
  assign uio_oe  = 8'b1111_0000;      // top four uio pins drive, bottom four listen

  // Tell lint that these inputs are unused on purpose.
  wire _unused = &{ena, uio_in[7:3], 1'b0};

endmodule
