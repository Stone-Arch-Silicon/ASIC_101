# Option C: Carry Select Adder

The Carry Select Adder trades extra hardware for reduced waiting on part of the carry path. The upper half computes both possible answers in advance and selects the correct one when the lower-half carry arrives.

## Overview

Split the 8-bit addition into two four-bit halves.

The lower half computes normally:

```text
bits 3:0
```

At the same time, the upper half computes twice:

```text
bits 7:4 assuming carry-in = 0
bits 7:4 assuming carry-in = 1
```

When the lower-half carry is finally known, a mux selects the correct upper result.

Conceptually:

```text
                       +--> upper add, cin=0 --+
lower add --> carry ---|                       |--> mux --> final upper sum
                       +--> upper add, cin=1 --+
```

## Prerequisites

- [ALU specification](page_3.md)
- Ripple Carry Adder concept
- multiplexers

## Steps

### 1. Create a four-bit Ripple Carry helper

Create `rtl/adder8.v`.

```verilog
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
    for (i = 0; i < 4; i = i + 1) begin : GEN_FA
      assign sum[i] = a[i] ^ b[i] ^ c[i];

      assign c[i+1] =
          (a[i] & b[i]) |
          (a[i] & c[i]) |
          (b[i] & c[i]);
    end
  endgenerate

  assign cout = c[4];

endmodule
```

### 2. Compute the upper half twice

Add the top-level module below it:

```verilog
module adder8 (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire       cin,
  output wire [7:0] sum,
  output wire       cout
);

  wire [3:0] sum_low;
  wire       carry_low;

  wire [3:0] sum_high_0;
  wire [3:0] sum_high_1;
  wire       carry_high_0;
  wire       carry_high_1;

  rca4 u_low (
    .a    (a[3:0]),
    .b    (b[3:0]),
    .cin  (cin),
    .sum  (sum_low),
    .cout (carry_low)
  );

  rca4 u_high_if_0 (
    .a    (a[7:4]),
    .b    (b[7:4]),
    .cin  (1'b0),
    .sum  (sum_high_0),
    .cout (carry_high_0)
  );

  rca4 u_high_if_1 (
    .a    (a[7:4]),
    .b    (b[7:4]),
    .cin  (1'b1),
    .sum  (sum_high_1),
    .cout (carry_high_1)
  );

  assign sum[3:0] = sum_low;

  assign sum[7:4] =
      carry_low ? sum_high_1 : sum_high_0;

  assign cout =
      carry_low ? carry_high_1 : carry_high_0;

endmodule
```

### 3. Understand the tradeoff

The upper arithmetic is duplicated.

That means the source design contains more logic than a simple ripple structure, but the upper half does not need to wait before beginning its arithmetic.

The final selection still waits for `carry_low`.

### 4. Add it to the ALU

Your files should now be:

```text
rtl/
├── adder8.v
├── alu_core.v
└── alu_top.v
```

### 5. Continue to the common flow

You are done with the adder branch.

Continue to [Verify the complete ALU — page 7](page_7.md).

## Results

Later, inspect whether the duplicated structure survives synthesis and how Vivado maps it to FPGA resources.

Do not assume source-code area equals physical area. Synthesis can remove, merge, or transform logic.

## Checklist

- [ ] Created the `rca4` helper
- [ ] Computed both upper-half carry cases
- [ ] Added the output mux
- [ ] Did not use `a + b` inside the adder
- [ ] Connected the adder to `alu_core`
- [ ] Continued to page 7

---

*Questions? Ask in the network Discord.*
