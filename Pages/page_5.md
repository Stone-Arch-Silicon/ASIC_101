# Page 5 — Simulation and testbenches from zero

## What you are learning

Writing RTL is not enough.

You must test it.

On this page you will:

- create a testbench
- instantiate your design
- drive inputs
- check outputs automatically
- generate a waveform
- open the waveform in GTKWave

## 1. What is a testbench?

A testbench is HDL used to test another HDL module.

The module being tested is often called the:

```text
DUT
```

meaning:

```text
Design Under Test
```

Testbenches are not normally synthesized into the chip.

They are allowed to do simulation-only things such as:

```text
wait
print text
stop the simulator
generate arbitrary input patterns
compare actual and expected answers
```

## 2. Create the testbench

Create:

```text
sim/logic_demo_tb.v
```

with:

```verilog
`timescale 1ns/1ps

module logic_demo_tb;

  reg a;
  reg b;
  reg sel;

  wire y_and;
  wire y_or;
  wire y_xor;
  wire y_not;
  wire y_mux;

  integer errors;

  logic_demo dut (
    .a     (a),
    .b     (b),
    .sel   (sel),
    .y_and (y_and),
    .y_or  (y_or),
    .y_xor (y_xor),
    .y_not (y_not),
    .y_mux (y_mux)
  );

  task check_outputs;
    input exp_and;
    input exp_or;
    input exp_xor;
    input exp_not;
    input exp_mux;
    begin
      #1;

      if (
        y_and !== exp_and ||
        y_or  !== exp_or  ||
        y_xor !== exp_xor ||
        y_not !== exp_not ||
        y_mux !== exp_mux
      ) begin
        $display(
          "FAIL a=%b b=%b sel=%b | and=%b or=%b xor=%b not=%b mux=%b",
          a, b, sel,
          y_and, y_or, y_xor, y_not, y_mux
        );
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    $dumpfile("build/logic_demo.vcd");
    $dumpvars(0, logic_demo_tb);

    errors = 0;

    a = 0; b = 0; sel = 0;
    check_outputs(0, 0, 0, 1, 0);

    a = 0; b = 1; sel = 0;
    check_outputs(0, 1, 1, 1, 0);

    a = 0; b = 1; sel = 1;
    check_outputs(0, 1, 1, 1, 1);

    a = 1; b = 0; sel = 0;
    check_outputs(0, 1, 1, 0, 1);

    a = 1; b = 0; sel = 1;
    check_outputs(0, 1, 1, 0, 0);

    a = 1; b = 1; sel = 0;
    check_outputs(1, 1, 0, 0, 1);

    a = 1; b = 1; sel = 1;
    check_outputs(1, 1, 0, 0, 1);

    if (errors == 0)
      $display("PASS: logic_demo passed.");
    else
      $display("FAIL: %0d test cases failed.", errors);

    $finish;
  end

endmodule
```

## 3. Understand DUT instantiation

This:

```verilog
logic_demo dut (
```

creates one instance of your RTL module inside the testbench.

The port connection:

```verilog
.a(a)
```

means:

```text
connect testbench signal a
to DUT port a
```

Named port connections are recommended because they are easier to read and harder to mix up than positional connections.

## 4. Why inputs are `reg` in this testbench

The testbench assigns values procedurally:

```verilog
a = 0;
b = 1;
```

In classic Verilog syntax, these procedurally assigned testbench signals are declared as `reg`.

That does **not** automatically mean a physical flip-flop exists.

Remember:

```text
testbench code is simulation code
```

## 5. Compile the design and testbench together

Run:

```bash
cd ~/asic_101

iverilog \
  -g2012 \
  -Wall \
  -s logic_demo_tb \
  -o build/logic_demo_tb.vvp \
  rtl/logic_demo.v \
  sim/logic_demo_tb.v
```

Then execute the simulation:

```bash
vvp build/logic_demo_tb.vvp
```

You want to see:

```text
PASS: logic_demo passed.
```

## 6. What `#1` means here

Inside the testbench:

```verilog
#1;
```

advances simulation time.

We use it to allow combinational outputs to settle in the simulator before checking them.

It is a **simulation construct**.

It is not a statement that should be placed into normal synthesizable RTL.

## 7. Generate a waveform

These lines:

```verilog
$dumpfile("build/logic_demo.vcd");
$dumpvars(0, logic_demo_tb);
```

tell the simulator to record signals into:

```text
build/logic_demo.vcd
```

VCD means **Value Change Dump**.

## 8. Open GTKWave

Run:

```bash
gtkwave build/logic_demo.vcd
```

In GTKWave:

1. expand the `logic_demo_tb` hierarchy
2. find `a`, `b`, and `sel`
3. add them to the signal view
4. add `y_and`, `y_or`, `y_xor`, `y_not`, and `y_mux`
5. zoom to fit

You should see the inputs change and the outputs respond.

Save a screenshot as:

```text
screenshots/logic_demo_waveform.png
```

## 9. Text checks and waveforms have different jobs

A self-checking testbench tells you:

```text
PASS
or
FAIL
```

A waveform helps you answer:

```text
why?
```

For larger designs, you generally want both.

## 10. Learn what an `x` means

HDL simulators can represent:

```text
x = unknown
```

An `x` often appears because:

- a register was never reset
- a signal was never assigned
- multiple conflicting drivers exist
- unknown data propagated through logic

Do not automatically ignore `x`.

It is often telling you that the testbench or RTL has a real problem.

## Checkpoint

You should have:

```text
sim/logic_demo_tb.v
build/logic_demo_tb.vvp
build/logic_demo.vcd
screenshots/logic_demo_waveform.png
```

and:

```bash
vvp build/logic_demo_tb.vvp
```

should report PASS.

## Before continuing

You should understand:

- DUT
- testbench
- simulation-only code
- self-checking tests
- VCD waveforms
- why waveforms help debug failures
