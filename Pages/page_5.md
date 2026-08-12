# Option B: Carry Lookahead Adder

The Carry Lookahead Adder reduces the amount of strictly serial carry logic by computing carry conditions from propagate and generate signals.

## Overview

For bit `i`, define

```text
p[i] = a[i] XOR b[i]
g[i] = a[i] AND b[i]
```

`p` means the stage can propagate a carry.

`g` means the stage generates a carry regardless of the incoming carry.

For one bit,

```text
c[i+1] = g[i] OR (p[i] AND c[i])
```

Instead of waiting for each carry sequentially, a lookahead block expands the equations so multiple carry conditions can be evaluated in parallel.

This project uses two 4-bit lookahead blocks to build the 8-bit adder.

## Prerequisites

- [ALU specification](page_3.md)
- Boolean algebra
- propagate and generate signals

## Steps

### 1. Build a four-bit lookahead block

Create `rtl/adder8.v` and begin with:

```verilog
module cla4 (
  input  wire [3:0] a,
  input  wire [3:0] b,
  input  wire       cin,
  output wire [3:0] sum,
  output wire       cout
);

  wire [3:0] p;
  wire [3:0] g;
  wire [4:0] c;

  assign p = a ^ b;
  assign g = a & b;

  assign c[0] = cin;

  assign c[1] =
      g[0] |
      (p[0] & c[0]);

  assign c[2] =
      g[1] |
      (p[1] & g[0]) |
      (p[1] & p[0] & c[0]);

  assign c[3] =
      g[2] |
      (p[2] & g[1]) |
      (p[2] & p[1] & g[0]) |
      (p[2] & p[1] & p[0] & c[0]);

  assign c[4] =
      g[3] |
      (p[3] & g[2]) |
      (p[3] & p[2] & g[1]) |
      (p[3] & p[2] & p[1] & g[0]) |
      (p[3] & p[2] & p[1] & p[0] & c[0]);

  assign sum[0] = p[0] ^ c[0];
  assign sum[1] = p[1] ^ c[1];
  assign sum[2] = p[2] ^ c[2];
  assign sum[3] = p[3] ^ c[3];

  assign cout = c[4];

endmodule
```

### 2. Build the 8-bit adder from two blocks

Add this below `cla4` in the same file:

```verilog
module adder8 (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire       cin,
  output wire [7:0] sum,
  output wire       cout
);

  wire carry4;

  cla4 u_low (
    .a    (a[3:0]),
    .b    (b[3:0]),
    .cin  (cin),
    .sum  (sum[3:0]),
    .cout (carry4)
  );

  cla4 u_high (
    .a    (a[7:4]),
    .b    (b[7:4]),
    .cin  (carry4),
    .sum  (sum[7:4]),
    .cout (cout)
  );

endmodule
```

This is a **block carry-lookahead** design: carry logic is expanded inside each four-bit block, while the carry between the lower and upper blocks still forms one block-level dependency.

### 3. Test a carry-heavy input by hand

Try:

```text
a   = 11111111
b   = 00000001
cin = 0
```

Expected:

```text
sum  = 00000000
cout = 1
```

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

Compared with the source structure of a Ripple Carry Adder, the lookahead equations expose more carry logic in parallel.

Do not assume that means it will always win on an FPGA. Vivado is free to optimize both designs for the target device, and dedicated FPGA carry hardware can strongly affect the result.

Your job later is to report what the tool actually produced.

## Checklist

- [ ] Created the `cla4` block
- [ ] Created the top-level `adder8`
- [ ] Did not use `a + b` inside the adder
- [ ] Connected the adder to `alu_core`
- [ ] Continued to page 7

---

*Questions? Ask in the network Discord.*
