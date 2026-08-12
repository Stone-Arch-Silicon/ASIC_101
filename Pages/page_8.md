# Synthesize and implement the ALU in Vivado

Now turn the verified RTL into an FPGA implementation. You will constrain the design, run synthesis, place and route it, and export the reports used for the final analysis.

## Overview

Simulation answered:

```text
Does the logic behave correctly?
```

Synthesis and implementation answer different questions:

```text
What hardware did the tool build?
How many FPGA resources does it use?
Can it meet the requested clock?
What paths limit performance?
What power does Vivado estimate?
```

For this project, `alu_top` is the synthesis top.

The registered wrapper creates internal register-to-register timing paths through the ALU.

## Prerequisites

- [Verification complete](page_7.md)
- all tests passing
- target FPGA selected in Vivado

## Steps

### 1. Set the synthesis top

Under **Sources**:

```text
right-click alu_top
→ Set as Top
```

Your design sources should contain:

```text
adder8.v
alu_core.v
alu_top.v
```

Your testbench remains under **Simulation Sources** only.

### 2. Add a timing constraint

Create:

```text
constr/alu.xdc
```

Start with a 100 MHz clock:

```tcl
create_clock -name clk -period 10.000 [get_ports clk]
```

The period is in nanoseconds.

```text
10 ns = 100 MHz
```

Add simple external interface assumptions:

```tcl
set_input_delay  -clock clk 2.000 \
  [get_ports -filter {DIRECTION == IN && NAME != clk}]

set_output_delay -clock clk 2.000 \
  [get_ports -filter {DIRECTION == OUT}]
```

These are educational interface assumptions, not board-specific numbers.

If your team provides real board timing requirements, use those instead.

### 3. Run synthesis

In Flow Navigator:

```text
Synthesis
→ Run Synthesis
```

When it finishes:

```text
Open Synthesized Design
```

Inspect:

```text
Schematic
Report Utilization
```

Look for:

- LUTs
- flip-flops
- carry resources
- whether the adder hierarchy is still recognizable

Save:

```text
screenshots/synthesized_schematic.png
```

### 4. Run implementation

In Flow Navigator:

```text
Implementation
→ Run Implementation
```

Then:

```text
Open Implemented Design
```

Vivado will place and route the synthesized FPGA resources onto the target device.

You do **not** need to generate a bitstream for this assignment.

### 5. Create a reports folder

Make sure this exists:

```text
reports/
```

If the Vivado working directory is not your repository root, use absolute file paths in the commands below.

### 6. Export utilization

In the Vivado Tcl Console:

```tcl
report_utilization -file reports/utilization.rpt
```

### 7. Export timing

```tcl
report_timing_summary -file reports/timing_summary.rpt
```

Also run:

```tcl
check_timing -verbose -file reports/check_timing.rpt
```

### 8. Export power

With the implemented design open:

```tcl
report_power -file reports/power.rpt
```

### 9. Export a DRC report

```tcl
report_drc -file reports/drc.rpt
```

### 10. Save implementation evidence

Save screenshots of:

```text
screenshots/implemented_device.png
screenshots/timing_summary.png
screenshots/power_summary.png
```

Your screenshots do not need to contain every number. The `.rpt` files are the actual source of the final metrics.

## Results

After implementation, your repository should contain:

```text
reports/
├── check_timing.rpt
├── drc.rpt
├── power.rpt
├── timing_summary.rpt
└── utilization.rpt
```

and:

```text
screenshots/
├── simulation.png
├── synthesized_schematic.png
├── implemented_device.png
├── timing_summary.png
└── power_summary.png
```

## Checklist

- [ ] `alu_top` is synthesis top
- [ ] Added the clock constraint
- [ ] Synthesis completed
- [ ] Inspected the synthesized schematic
- [ ] Implementation completed
- [ ] Exported utilization report
- [ ] Exported timing report
- [ ] Exported timing-check report
- [ ] Exported power report
- [ ] Exported DRC report
- [ ] Saved implementation screenshots
- [ ] Continued to page 9

Continue to [Analyze and submit the design](page_9.md).

---

*Questions? Ask in the network Discord.*
