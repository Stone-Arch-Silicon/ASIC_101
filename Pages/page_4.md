# Page 4 — Your first Verilog hardware

## What you are learning

This page teaches enough Verilog to describe simple combinational hardware.

You will create and compile your first RTL module.

## 1. Create the file

From the course root:

```bash
cd ~/asic_101
```

Create:

```text
rtl/logic_demo.v
```

Put this inside:

```verilog
module logic_demo (
  input  wire a,
  input  wire b,
  input  wire sel,

  output wire y_and,
  output wire y_or,
  output wire y_xor,
  output wire y_not,
  output wire y_mux
);

  assign y_and = a & b;
  assign y_or  = a | b;
  assign y_xor = a ^ b;
  assign y_not = ~a;

  assign y_mux = sel ? b : a;

endmodule
```

Save the file.

## 2. Understand the module

A module is a reusable hardware block.

This line starts the definition:

```verilog
module logic_demo (
```

The signals listed inside the parentheses are **ports**.

For example:

```verilog
input wire a
```

means:

```text
a is a one-bit input to this module
```

and:

```verilog
output wire y_and
```

means:

```text
y_and is a one-bit output
```

## 3. `assign` describes continuous hardware

This line:

```verilog
assign y_and = a & b;
```

means that `y_and` is continuously driven by combinational logic.

If `a` or `b` changes, the logical value of `y_and` changes accordingly.

These lines all describe hardware that conceptually exists at the same time:

```verilog
assign y_and = a & b;
assign y_or  = a | b;
assign y_xor = a ^ b;
assign y_not = ~a;
```

Verilog source order does not mean “execute the first assignment, then the second.”

This is one of the biggest mental shifts from software programming.

## 4. The conditional operator is a mux

This line:

```verilog
assign y_mux = sel ? b : a;
```

means:

```text
if sel = 0, connect a to y_mux
if sel = 1, connect b to y_mux
```

That describes a 2-to-1 multiplexer.

A mux is a hardware selector.

## 5. Compile the module

Run:

```bash
mkdir -p build

iverilog \
  -g2012 \
  -Wall \
  -s logic_demo \
  -o build/logic_demo.vvp \
  rtl/logic_demo.v
```

If everything is correct, the command may print nothing.

That is good.

The compiler created:

```text
build/logic_demo.vvp
```

At this point we have only checked that the module compiles.

We have not tested whether its behavior is correct.

That is the job of a testbench.

## 6. Make an intentional syntax error

This is worth doing once.

Temporarily change:

```verilog
assign y_and = a & b;
```

to something invalid, for example:

```verilog
assign y_and = a & ;
```

Run the compile command again.

Icarus should report an error and point near the broken line.

Restore the correct code afterward.

Hardware designers spend a lot of time reading tool errors. Learning to make one on purpose makes them less mysterious.

## 7. Comments

Use:

```verilog
// one-line comment
```

or:

```verilog
/*
multi-line
comment
*/
```

Comments do not create hardware.

Use comments to explain **why** something is implemented a certain way, not to repeat obvious syntax.

## 8. Buses

One-bit signals are useful, but most real datapaths use buses.

Example:

```verilog
input wire [7:0] a;
```

means an 8-bit input.

Bit selection:

```verilog
a[0]
a[7]
```

Slice selection:

```verilog
a[3:0]
a[7:4]
```

You will use this in the adder and ALU.

## 9. A rule for this course

Keep **synthesizable RTL** inside `rtl/`.

Keep **simulation-only code** inside `sim/`.

For now, do not put delays such as:

```verilog
#10
```

inside your RTL modules.

Delays are useful in testbenches, but they are not how we describe the physical delay of real synthesized hardware.

## Checkpoint

Your project should now include:

```text
asic_101/
├── rtl/
│   └── logic_demo.v
├── sim/
├── scripts/
├── build/
├── reports/
└── screenshots/
```

and this should compile:

```bash
iverilog -g2012 -Wall -s logic_demo \
  -o build/logic_demo.vvp \
  rtl/logic_demo.v
```

## Before continuing

You should be able to explain:

- what a module is
- what an input and output port are
- why multiple `assign` statements describe simultaneous hardware
- what the mux expression does
- what `[7:0]` means

Next: actually test the hardware.
