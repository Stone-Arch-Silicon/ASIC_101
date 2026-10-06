# Page 10 — Synthesis with Yosys

## What you are learning

Simulation answers:

```text
Does my HDL behave correctly?
```

Synthesis asks:

```text
What hardware structure implements this HDL?
```

On this page you will use Yosys to transform your RTL into a synthesized logic netlist.

This is your first step from behavioral source code toward an actual implementation.

## 1. What synthesis does

Synthesis performs transformations such as:

```text
Verilog processes
        ↓
muxes, registers, arithmetic logic
        ↓
optimized Boolean network
        ↓
logic cells
```

At this page, we are still doing **generic synthesis**.

We are not yet mapping to SKY130 standard cells.

That happens in the ASIC flow.

## 2. RTL is not a literal gate drawing

Suppose your RTL says:

```verilog
assign y = (a & b) | (a & c);
```

A synthesis tool may realize that this is equivalent to:

```text
a AND (b OR c)
```

and implement the smaller equivalent structure.

Synthesis is allowed to optimize the logic as long as the implementation preserves the intended behavior.

## 3. Create a Yosys script

Create:

```text
scripts/synth.ys
```

with:

```tcl
read_verilog -sv \
  rtl/adder8.v \
  rtl/alu_core.v \
  rtl/alu_top.v

hierarchy -check -top alu_top

check

synth -top alu_top

stat

write_verilog -noattr build/alu_top_synth.v

show \
  -format svg \
  -viewer none \
  -prefix build/alu_top_synth \
  alu_top
```

## 4. Run synthesis

From the project root:

```bash
cd ~/asic_101
yosys -s scripts/synth.ys | tee reports/yosys_synthesis.log
```

Yosys will print many messages.

Do not panic because the log is long.

EDA tools are verbose.

## 5. Find the important parts of the log

Search:

```bash
grep -n "=== alu_top ===" reports/yosys_synthesis.log
```

Also inspect the end:

```bash
tail -80 reports/yosys_synthesis.log
```

The `stat` command reports information such as:

```text
number of wires
number of wire bits
number of cells
cell types
```

Exact numbers may change with tool versions and optimizations.

Do not memorize the numbers.

Understand what they represent.

## 6. Open the synthesized Verilog

Inspect:

```text
build/alu_top_synth.v
```

You should see that it looks very different from your source RTL.

Your clean behavioral code has been transformed into a more structural representation.

That is expected.

Do not edit the synthesized netlist by hand.

Treat the source RTL as the design source of truth.

## 7. Open the schematic

The script should produce something similar to:

```text
build/alu_top_synth.svg
```

Open that SVG in a browser or image viewer.

For a larger design, the full schematic may become visually busy.

That is normal.

The important lesson is that RTL can be transformed into an interconnected hardware graph.

## 8. What happened to `always` blocks?

Synthesis does not manufacture an “always block.”

An `always` block is HDL syntax used to describe behavior.

For example:

```verilog
always @(posedge clk)
  q <= d;
```

is recognized as sequential storage behavior.

The synthesized design contains register elements representing that behavior.

Similarly:

```verilog
case (op)
```

may synthesize into muxing and logic.

## 9. What happened to the ripple-carry adder?

Search the synthesized output:

```bash
grep -n "u_adder" build/alu_top_synth.v
```

Depending on synthesis optimizations and hierarchy handling, the original source structure may be transformed, flattened, renamed, or optimized.

Source-code hierarchy is useful to humans.

The synthesis tool is allowed to change internal implementation structure while preserving functionality.

## 10. Generic synthesis is not ASIC technology mapping

This page has **not yet** answered:

```text
How large is the ASIC?
How fast is it in SKY130?
How much power does it use?
Which exact standard cells are used?
Where are the cells physically placed?
How long are the wires?
```

Those questions require:

```text
a process design kit
a standard-cell library
timing models
physical models
constraints
place and route
parasitic extraction
timing analysis
```

That is the next half of ASIC 101.

## 11. Synthesis sanity checks

Search the log for obvious problems:

```bash
grep -i "error" reports/yosys_synthesis.log
grep -i "warning" reports/yosys_synthesis.log
```

Not every warning means the design is broken.

But do not ignore warnings automatically.

Read them and decide what they mean.

A good engineering habit is:

```text
understand warnings
rather than normalize warnings
```

## 12. Save the result

Keep:

```text
reports/yosys_synthesis.log
build/alu_top_synth.v
build/alu_top_synth.svg
```

The `build/` directory is disposable generated output.

The report is worth preserving.

Commit the synthesis script and report:

```bash
git add scripts reports
git commit -m "Add open-source Yosys synthesis flow"
```

## Checkpoint

You should now be able to explain this transformation:

```text
RTL
 ↓
Yosys
 ↓
synthesized logic netlist
```

and also explain why this is **not yet** a physically implemented ASIC.

## References

- Yosys synthesis introduction: https://yosyshq.readthedocs.io/projects/yosys/en/latest/getting_started/example_synth.html
- Yosys `show` command: https://yosyshq.readthedocs.io/projects/yosys/en/latest/cmd/show.html
- Yosys command reference: https://yosyshq.readthedocs.io/
