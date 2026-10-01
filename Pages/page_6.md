# Page 6 — Registers, clocks, and sequential logic

## What you are learning

So far, everything has been combinational.

Now you will build hardware that remembers a value.

You will learn:

- clocks
- rising edges
- registers
- synchronous reset
- nonblocking assignment
- latency
- the basic idea behind register-to-register timing

## 1. What is a register?

A register stores bits.

An 8-bit register stores one 8-bit value.

A common synchronous design rule is:

```text
capture new state on a clock edge
```

Between clock edges, the register keeps its previous value.

## 2. What is a clock?

A clock is a periodic signal.

Conceptually:

```text
0 1 0 1 0 1 0 1 ...
```

A **rising edge** is a transition from:

```text
0 → 1
```

Many synchronous circuits update state on rising edges.

## 3. Create an 8-bit register

Create:

```text
rtl/register8.v
```

with:

```verilog
module register8 (
  input  wire       clk,
  input  wire       rst_n,
  input  wire [7:0] d,
  output reg  [7:0] q
);

  always @(posedge clk) begin
    if (!rst_n)
      q <= 8'h00;
    else
      q <= d;
  end

endmodule
```

## 4. Understand the `always` block

This line:

```verilog
always @(posedge clk)
```

means:

> Execute this sequential behavior when a rising clock edge occurs.

The register does not continuously copy `d` to `q`.

It samples `d` on the clock edge.

## 5. Why `<=` instead of `=`

Inside clocked sequential logic we use **nonblocking assignment**:

```verilog
q <= d;
```

This is a core RTL convention.

Use:

```text
<=
```

for clocked registers.

Use blocking assignment:

```text
=
```

for ordinary combinational procedural logic.

The distinction matters when several state elements update on the same edge.

Nonblocking assignments model simultaneous register updates much more naturally.

## 6. What does `rst_n` mean?

The suffix `_n` commonly means the signal is active-low.

So:

```text
rst_n = 0
```

means reset is active.

Our reset is **synchronous** because it is checked only inside:

```verilog
always @(posedge clk)
```

Therefore, `q` resets on a clock edge while `rst_n` is low.

## 7. Create a testbench

Create:

```text
sim/register8_tb.v
```

with:

```verilog
`timescale 1ns/1ps

module register8_tb;

  reg        clk;
  reg        rst_n;
  reg  [7:0] d;
  wire [7:0] q;

  integer errors;

  register8 dut (
    .clk   (clk),
    .rst_n (rst_n),
    .d     (d),
    .q     (q)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("build/register8.vcd");
    $dumpvars(0, register8_tb);

    errors = 0;
    rst_n  = 0;
    d      = 8'hA5;

    @(posedge clk);
    #1;
    if (q !== 8'h00) begin
      $display("FAIL: reset did not clear q");
      errors = errors + 1;
    end

    rst_n = 1;
    d     = 8'h12;

    @(posedge clk);
    #1;
    if (q !== 8'h12) begin
      $display("FAIL: expected q=12, got q=%h", q);
      errors = errors + 1;
    end

    d = 8'hF0;

    // Before another rising edge, q must still hold the previous value.
    #2;
    if (q !== 8'h12) begin
      $display("FAIL: q changed without a rising edge");
      errors = errors + 1;
    end

    @(posedge clk);
    #1;
    if (q !== 8'hF0) begin
      $display("FAIL: expected q=F0, got q=%h", q);
      errors = errors + 1;
    end

    if (errors == 0)
      $display("PASS: register8 passed.");
    else
      $display("FAIL: %0d checks failed.", errors);

    $finish;
  end

endmodule
```

## 8. Compile and run

```bash
iverilog \
  -g2012 \
  -Wall \
  -s register8_tb \
  -o build/register8_tb.vvp \
  rtl/register8.v \
  sim/register8_tb.v

vvp build/register8_tb.vvp
```

You want:

```text
PASS: register8 passed.
```

Open the waveform:

```bash
gtkwave build/register8.vcd
```

Add:

```text
clk
rst_n
d
q
```

Observe that `q` changes only after rising edges.

## 9. The beginning of timing intuition

Imagine:

```text
register A
   ↓
combinational logic
   ↓
register B
```

After register A launches data, the data must propagate through the logic and reach register B in time.

The requested clock period controls how much time is available.

If the clock is too fast for the logic path, timing fails.

Later, **static timing analysis** will calculate this using cell and wire delays.

For now, keep the mental model:

```text
register → logic → register
```

## 10. Latency

If data is stored in a register, the output may appear one or more clock cycles after an input was presented.

That delay in cycles is called **latency**.

Latency is not automatically bad.

Registers are one of the main ways digital systems divide long operations into manageable timing stages.

## Before continuing

You should be able to explain:

- what a rising edge is
- why a register remembers data
- why clocked RTL uses `<=`
- what synchronous reset means
- why register-to-register paths matter for timing
