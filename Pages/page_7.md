# Page 7 — Build an 8-bit adder and learn subtraction

## What you are learning

Arithmetic looks simple in software:

```text
a + b
```

Hardware still has to implement the addition.

This page teaches:

- half adders
- full adders
- carry
- ripple-carry addition
- two's-complement subtraction
- carry versus borrow
- signed overflow

You will build the arithmetic block used by the ALU.

## 1. One-bit addition

Start with:

```text
0 + 0 = 0
0 + 1 = 1
1 + 0 = 1
1 + 1 = 10
```

The result of `1 + 1` needs two bits:

```text
sum bit   = 0
carry bit = 1
```

## 2. Full adder

When adding multi-bit numbers, each bit may also receive a carry from the previous bit.

A full adder has:

```text
a
b
cin
```

and produces:

```text
sum
cout
```

The equations are:

```text
sum  = a XOR b XOR cin

cout = (a AND b) OR (a AND cin) OR (b AND cin)
```

## 3. Ripple-carry addition

To add 8-bit numbers, connect eight full-adder stages.

```text
cin -> bit 0 -> carry -> bit 1 -> carry -> bit 2 -> ... -> bit 7
```

The carry can “ripple” through the chain.

That is why this architecture is called a **Ripple Carry Adder**.

It is not always the fastest possible adder, but it is an excellent first architecture because its behavior is easy to understand.

## 4. Create `adder8`

Create:

```text
rtl/adder8.v
```

with:

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

      assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
    end
  endgenerate

  assign cout = c[8];

endmodule
```

Notice that the RTL does not use:

```verilog
a + b
```

inside the design.

We are explicitly describing the full-adder structure.

## 5. Trace one example

Try:

```text
a   = 01111111
b   = 00000001
cin = 0
```

The expected sum is:

```text
10000000
```

The carry has to propagate through many low-order bits before the final result is known.

That long dependency is why ripple-carry adders become slower as width increases.

## 6. Subtraction using the same adder

Two's-complement arithmetic gives us:

```text
a - b = a + (~b) + 1
```

That means we can reuse the adder for subtraction.

Create a signal:

```text
sub
```

If:

```text
sub = 0
```

we want:

```text
a + b + 0
```

If:

```text
sub = 1
```

we want:

```text
a + ~b + 1
```

A convenient hardware trick is:

```verilog
b_arith = b ^ {8{sub}};
```

Why?

When `sub = 0`:

```text
b XOR 00000000 = b
```

When `sub = 1`:

```text
b XOR 11111111 = ~b
```

Then connect:

```text
cin = sub
```

One control bit gives us both ADD and SUB.

## 7. Carry-out during subtraction

When subtraction is implemented as:

```text
a + (~b) + 1
```

the carry-out has a convention that sometimes surprises beginners.

For this implementation:

```text
carry = 1
```

generally corresponds to:

```text
no borrow
```

Do not assume “carry” and “borrow” are identical concepts.

The meaning of a status flag must be defined by the interface specification.

## 8. Signed overflow

Carry-out is not the same as signed overflow.

Example:

```text
127 + 1
```

in 8-bit signed arithmetic:

```text
01111111
+00000001
---------
10000000
```

The bit pattern `10000000` represents `-128`.

Two positive numbers produced a negative result.

That is signed overflow.

For 8-bit addition:

```verilog
overflow_add = (~(a[7] ^ b[7])) & (sum[7] ^ a[7]);
```

For subtraction:

```verilog
overflow_sub = (a[7] ^ b[7]) & (sum[7] ^ a[7]);
```

You will use these expressions in the ALU.

## 9. Exhaustively test the adder

Create:

```text
sim/adder8_tb.v
```

with:

```verilog
`timescale 1ns/1ps

module adder8_tb;

  reg  [7:0] a;
  reg  [7:0] b;
  reg        cin;

  wire [7:0] sum;
  wire       cout;

  reg  [8:0] expected;

  integer ia;
  integer ib;
  integer ic;
  integer errors;

  adder8 dut (
    .a    (a),
    .b    (b),
    .cin  (cin),
    .sum  (sum),
    .cout (cout)
  );

  initial begin
    errors = 0;

    for (ic = 0; ic < 2; ic = ic + 1) begin
      for (ia = 0; ia < 256; ia = ia + 1) begin
        for (ib = 0; ib < 256; ib = ib + 1) begin

          a   = ia[7:0];
          b   = ib[7:0];
          cin = ic[0];

          expected = {1'b0, a} + {1'b0, b} + cin;

          #1;

          if ({cout, sum} !== expected) begin
            if (errors < 20) begin
              $display(
                "FAIL a=%h b=%h cin=%b got=%b_%h expected=%h",
                a, b, cin, cout, sum, expected
              );
            end
            errors = errors + 1;
          end

        end
      end
    end

    if (errors == 0)
      $display("PASS: all adder input combinations passed.");
    else
      $display("FAIL: %0d adder cases failed.", errors);

    $finish;
  end

endmodule
```

Compile and run:

```bash
iverilog \
  -g2012 \
  -Wall \
  -s adder8_tb \
  -o build/adder8_tb.vvp \
  rtl/adder8.v \
  sim/adder8_tb.v

vvp build/adder8_tb.vvp
```

You want:

```text
PASS: all adder input combinations passed.
```

There are:

```text
256 × 256 × 2 = 131,072
```

possible combinations of `a`, `b`, and `cin`.

This testbench checks all of them.

## Before continuing

You should understand:

- how a full adder works
- why carry ripples through this architecture
- how one adder can implement subtraction
- why carry and signed overflow are different
- why exhaustive verification is practical for a small block
