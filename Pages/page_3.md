# Build the 8-bit ALU

The ALU is the common project used by everyone in ASIC 101. You will implement eight operations and route ADD and SUB through the custom adder architecture you choose.

## Overview

Your ALU accepts two 8-bit operands and a 3-bit operation code.

| `op` | operation | result |
|------|-----------|--------|
| `000` | ADD | `a + b` |
| `001` | SUB | `a - b` |
| `010` | AND | `a & b` |
| `011` | OR | `a | b` |
| `100` | XOR | `a ^ b` |
| `101` | NOT | `~a` |
| `110` | Shift left | `a << 1` |
| `111` | Shift right | `a >> 1` |

The ALU also produces four status flags:

- `zero`: result is zero
- `negative`: most-significant bit of the result is one
- `carry`: carry-out from ADD or SUB
- `overflow`: signed two's-complement overflow on ADD or SUB

The core is combinational. A small registered wrapper is added so Vivado has a clean register-to-register timing path to analyze later.

## Prerequisites

- prior page: [ASIC 101 project setup](page_2.md)
- basic combinational Verilog
- understanding of two's-complement subtraction

## Steps

### 1. Use one common adder interface

Whichever adder you choose later, it must use this exact module interface:

```verilog
module adder8 (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire       cin,
  output wire [7:0] sum,
  output wire       cout
);
  // your architecture goes here
endmodule
```

This lets every adder plug into the exact same ALU.

### 2. Reuse the adder for subtraction

Two's-complement subtraction is

```text
a - b = a + (~b) + 1
```

That means the same adder can perform both operations.

```verilog
wire sub;
wire [7:0] b_arith;

assign sub     = (op == 3'b001);
assign b_arith = b ^ {8{sub}};
```

For ADD:

```text
sub = 0
b_arith = b
cin = 0
```

For SUB:

```text
sub = 1
b_arith = ~b
cin = 1
```

### 3. Create `rtl/alu_core.v`

Use this as the project skeleton:

```verilog
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

  wire       sub;
  wire [7:0] b_arith;
  wire [7:0] arithmetic_result;
  wire       arithmetic_cout;

  assign sub     = (op == 3'b001);
  assign b_arith = b ^ {8{sub}};

  adder8 u_adder (
    .a    (a),
    .b    (b_arith),
    .cin  (sub),
    .sum  (arithmetic_result),
    .cout (arithmetic_cout)
  );

  always @* begin
    y        = 8'h00;
    carry    = 1'b0;
    overflow = 1'b0;

    case (op)
      3'b000: begin
        y        = arithmetic_result;
        carry    = arithmetic_cout;
        overflow = (~(a[7] ^ b[7])) & (y[7] ^ a[7]);
      end

      3'b001: begin
        y        = arithmetic_result;
        carry    = arithmetic_cout;
        overflow = (a[7] ^ b[7]) & (y[7] ^ a[7]);
      end

      3'b010: y = a & b;
      3'b011: y = a | b;
      3'b100: y = a ^ b;
      3'b101: y = ~a;
      3'b110: y = a << 1;
      3'b111: y = a >> 1;

      default: y = 8'h00;
    endcase

    zero     = (y == 8'h00);
    negative = y[7];
  end

endmodule
```

For subtraction, `carry = 1` generally corresponds to **no borrow** in this two's-complement implementation.

### 4. Create a registered top level

Create `rtl/alu_top.v`.

```verilog
module alu_top (
  input  wire       clk,
  input  wire       rst_n,
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire [2:0] op,

  output reg  [7:0] y,
  output reg        carry,
  output reg        overflow,
  output reg        zero,
  output reg        negative
);

  reg [7:0] a_q;
  reg [7:0] b_q;
  reg [2:0] op_q;

  wire [7:0] y_comb;
  wire       carry_comb;
  wire       overflow_comb;
  wire       zero_comb;
  wire       negative_comb;

  alu_core u_core (
    .a        (a_q),
    .b        (b_q),
    .op       (op_q),
    .y        (y_comb),
    .carry    (carry_comb),
    .overflow (overflow_comb),
    .zero     (zero_comb),
    .negative (negative_comb)
  );

  always @(posedge clk) begin
    if (!rst_n) begin
      a_q      <= 8'h00;
      b_q      <= 8'h00;
      op_q     <= 3'b000;
      y        <= 8'h00;
      carry    <= 1'b0;
      overflow <= 1'b0;
      zero     <= 1'b1;
      negative <= 1'b0;
    end
    else begin
      a_q      <= a;
      b_q      <= b;
      op_q     <= op;

      y        <= y_comb;
      carry    <= carry_comb;
      overflow <= overflow_comb;
      zero     <= zero_comb;
      negative <= negative_comb;
    end
  end

endmodule
```

The input registers launch data through `alu_core`, and the output registers capture the result on the next rising clock edge. That gives Vivado a meaningful internal timing path.

### 5. Choose your adder

Now choose **one** path:

- simplest: [Ripple Carry Adder — page 4](page_4.md)
- more logic, less serial carry propagation: [Carry Lookahead Adder — page 5](page_5.md)
- duplicated upper-half arithmetic with a mux: [Carry Select Adder — page 6](page_6.md)

You only complete one page.

## Results

Before moving on, you should have:

```text
rtl/
├── alu_core.v
└── alu_top.v
```

Your `adder8.v` comes from whichever adder page you choose.

## Checklist

- [ ] Understand the eight ALU operations
- [ ] Understand how ADD and SUB share one adder
- [ ] Created `alu_core.v`
- [ ] Created `alu_top.v`
- [ ] Selected one adder architecture
- [ ] Continued to page 4, 5, or 6

---

*Questions? Ask in the network Discord.*
