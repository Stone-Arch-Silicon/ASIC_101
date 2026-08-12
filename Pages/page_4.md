# Option A: Ripple Carry Adder

The Ripple Carry Adder is the simplest adder option. Each bit waits for the carry from the bit before it, making the structure easy to understand and easy to verify.

## Overview

A one-bit full adder has three inputs:

```text
a
b
carry-in
```

and two outputs:

```text
sum
carry-out
```

The logic is

```text
sum  = a XOR b XOR cin

cout = (a AND b)
     OR (a AND cin)
     OR (b AND cin)
```

An 8-bit Ripple Carry Adder chains eight of these stages.

```text
cin -> bit 0 -> bit 1 -> bit 2 -> ... -> bit 7 -> cout
```

The important idea is that a carry may have to propagate through every stage.

## Prerequisites

- [ALU specification](page_3.md)
- Boolean AND, OR, XOR
- one-bit full adders

## Steps

### 1. Create `rtl/adder8.v`

```verilog
module adder8 (
  input  wire [7:0] a,
  input  wire [7:0] b,
  input  wire       cin,
  output wire [7:0] sum,
  output wire       cout
);

  wire [8:0] c;

  assign c[0] = cin;

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : GEN_FULL_ADDER
      assign sum[i] = a[i] ^ b[i] ^ c[i];

      assign c[i+1] =
          (a[i] & b[i]) |
          (a[i] & c[i]) |
          (b[i] & c[i]);
    end
  endgenerate

  assign cout = c[8];

endmodule
```

### 2. Trace one carry by hand

Try:

```text
a   = 01111111
b   = 00000001
cin = 0
```

The result should be

```text
sum  = 10000000
cout = 0
```

Several carry signals must ripple through the design before the final sum settles.

### 3. Add it to the ALU

Make sure your files are

```text
rtl/
├── adder8.v
├── alu_core.v
└── alu_top.v
```

Do not rename the module. `alu_core.v` expects a module named `adder8`.

### 4. Continue to the common flow

You are done with the adder branch.

Continue to [Verify the complete ALU — page 7](page_7.md).

## Results

The Ripple Carry Adder is a useful baseline because it uses a simple repeated structure.

Later, record what Vivado actually maps it into. FPGA synthesis may transform your RTL and use device-specific carry resources, so do not assume the post-synthesis hardware will look exactly like the source code.

## Checklist

- [ ] Created `adder8.v`
- [ ] Did not use `a + b` inside the adder
- [ ] Understand how the carry ripples
- [ ] Connected the adder to `alu_core`
- [ ] Continued to page 7

---

*Questions? Ask in the network Discord.*
