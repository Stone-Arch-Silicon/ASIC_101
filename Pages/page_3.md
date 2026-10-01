# Page 3 — Bits, gates, binary numbers, and the two kinds of digital logic

## What you are learning

Before writing HDL, you need the vocabulary that HDL describes.

By the end of this page, you should understand:

- bits
- buses
- binary and hexadecimal
- Boolean logic
- truth tables
- combinational logic
- sequential logic
- unsigned and two's-complement numbers

## 1. One bit

A **bit** stores or represents one binary value:

```text
0
or
1
```

A single hardware signal may therefore be:

```text
a = 0
```

or:

```text
a = 1
```

HDL simulators also have values such as `x` and `z`, which we will discuss when debugging. For now, begin with `0` and `1`.

## 2. Logic gates

### NOT

NOT inverts a bit.

| `a` | `~a` |
| ---: | ---: |
| 0 | 1 |
| 1 | 0 |

### AND

AND produces `1` only when both inputs are `1`.

| `a` | `b` | `a & b` |
| ---: | ---: | ---: |
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

### OR

OR produces `1` when either input is `1`.

| `a` | `b` | `a \| b` |
| ---: | ---: | ---: |
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 1 |

### XOR

XOR produces `1` when the two inputs are different.

| `a` | `b` | `a ^ b` |
| ---: | ---: | ---: |
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

These operations will appear constantly in RTL.

## 3. More than one bit: buses

An 8-bit value is a group of eight signals.

Example:

```text
10110110
```

In Verilog, an 8-bit signal can be declared as:

```verilog
wire [7:0] data;
```

The bits are numbered:

```text
data[7] data[6] ... data[1] data[0]
```

`data[7]` is the most-significant bit.

`data[0]` is the least-significant bit.

## 4. Binary and hexadecimal

Binary becomes difficult to read once values get wider.

Four binary bits correspond exactly to one hexadecimal digit.

```text
binary    hex
0000      0
0001      1
0010      2
...
1001      9
1010      A
1011      B
1100      C
1101      D
1110      E
1111      F
```

So:

```text
1010 0101
```

is:

```text
0xA5
```

In Verilog:

```verilog
8'b10100101
```

and:

```verilog
8'hA5
```

represent the same 8-bit pattern.

The notation is:

```text
width ' base value
```

Examples:

```verilog
1'b0
4'b1010
8'hFF
16'd1000
```

## 5. Unsigned numbers

An 8-bit unsigned number can represent:

```text
0 through 255
```

because:

```text
2^8 = 256
```

Examples:

```text
00000000 = 0
00000001 = 1
00001101 = 13
11111111 = 255
```

## 6. Two's-complement signed numbers

The same 8 bits can instead be interpreted as a signed two's-complement number.

For 8 bits:

```text
-128 through +127
```

Examples:

```text
00000000 =   0
00000001 =   1
01111111 = 127
11111111 =  -1
10000000 = -128
```

A useful way to compute the negative of an `N`-bit two's-complement number is:

```text
invert all bits
then add 1
```

For example, starting from `5`:

```text
5          = 00000101
invert     = 11111010
add 1      = 11111011
```

So `11111011` represents `-5` in 8-bit two's complement.

We will use this exact trick to build subtraction from an adder.

## 7. Combinational logic

A combinational circuit has outputs determined by its **current inputs**.

Examples:

```text
AND gate
mux
adder
ALU core
decoder
```

Conceptually:

```text
inputs → logic → outputs
```

There is no memory of previous input values.

## 8. Sequential logic

Sequential logic contains state.

The most important basic storage element for this course is a **flip-flop**.

A register made from flip-flops stores a value across time.

Conceptually:

```text
input logic
    ↓
register
    ↓
more logic
    ↓
register
```

A clock tells registers when to capture new values.

Later, timing analysis will ask whether data can travel from one register to another fast enough before the next required clock edge.

## 9. Why both matter

Most real synchronous digital designs contain both:

```text
combinational logic
+
registers
```

The ALU operation itself is combinational.

We will also wrap it with registers so that later synthesis and timing analysis have a clean register-to-register path.

## Mini exercises

Do these without a simulator.

### Exercise 1

Convert decimal `13` to 8-bit binary.

Answer:

```text
00001101
```

### Exercise 2

Convert:

```text
10100101
```

to hexadecimal.

Answer:

```text
A5
```

### Exercise 3

What is:

```text
1 XOR 1
```

Answer:

```text
0
```

### Exercise 4

What 8-bit pattern represents `-1`?

Answer:

```text
11111111
```

### Exercise 5

Which type of circuit remembers a previous value?

Answer:

```text
sequential logic
```

## Before continuing

You are ready for Page 4 when you can explain:

- what `[7:0]` means
- why `8'hA5` is eight bits
- AND, OR, XOR, and NOT
- the difference between combinational and sequential logic
- why two's complement is useful for subtraction
