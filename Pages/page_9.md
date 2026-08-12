# Analyze and submit the ALU

The final step is to turn Vivado's reports into an engineering summary. Record area proxies, timing, and power, explain what limits the design, and submit the complete repository.

## Overview

This page is intentionally **PPA-style**:

```text
Power
Performance
Area
```

But remember what you implemented.

Vivado mapped your RTL to an **FPGA**, not to ASIC standard cells.

That means:

- LUT count is an FPGA area proxy, not ASIC cell area
- Vivado FPGA power is not ASIC power
- FPGA routing and dedicated carry chains affect timing
- the same RTL may behave very differently in an ASIC physical-design flow

The point is to learn how to read implementation reports and reason about hardware tradeoffs.

## Prerequisites

- [Vivado implementation complete](page_8.md)
- all report files exported

## Steps

### 1. Record the adder you chose

In your README:

```text
Adder architecture: Ripple Carry
```

or:

```text
Adder architecture: Carry Lookahead
```

or:

```text
Adder architecture: Carry Select
```

### 2. Read the utilization report

Open:

```text
reports/utilization.rpt
```

Record at least:

- LUTs
- flip-flops/registers
- dedicated carry resources if present

Depending on the target device, the exact carry primitive name may differ.

Do not report the number of lines of Verilog as area.

### 3. Read the timing summary

Open:

```text
reports/timing_summary.rpt
```

Record:

- requested clock period
- Worst Negative Slack, or WNS
- Total Negative Slack, or TNS
- the startpoint and endpoint of the worst setup path

Interpret WNS:

```text
WNS >= 0  → requested setup timing is met
WNS < 0   → at least one setup path misses the constraint
```

Then inspect the worst path.

Ask:

- Does it pass through the adder?
- Does it pass through the final ALU output mux?
- Which operation appears to dominate the path?
- Did Vivado map the arithmetic into dedicated carry hardware?

### 4. Read the power report

Open:

```text
reports/power.rpt
```

Record:

- Total On-Chip Power
- Dynamic Power
- Device Static Power
- power-analysis confidence level, if shown

Dynamic power is associated with switching activity.

Static power exists even when logic is not actively toggling.

For the base assignment, the normal post-route Vivado power report is enough.

### 5. Optional: improve power estimation with switching activity

For a more advanced result, generate a SAIF file from simulation and use that switching activity in the power report.

A typical Vivado Simulator flow uses commands such as:

```tcl
open_saif alu.saif
log_saif [get_objects -r *]
run all
close_saif
```

Then, with the synthesized or implemented design open, read the activity file before generating power:

```tcl
read_saif alu.saif
report_power -file reports/power_saif.rpt
```

Hierarchy names often differ between the testbench and implemented design. If Vivado reports poor SAIF matching, use the appropriate `-strip_path` when reading the file.

This section is optional unless your team specifically requires activity-based power analysis.

### 6. Check implementation health

Open:

```text
reports/check_timing.rpt
reports/drc.rpt
```

Do not blindly ignore warnings.

For each serious warning or error, decide whether it is:

- expected for this educational setup
- caused by an incomplete constraint
- caused by an RTL problem
- caused by a project configuration problem

If the design has unresolved timing or DRC problems, mention them in the README.

### 7. Create the final results table

Put this in `README.md`:

```markdown
## ASIC 101 ALU results

| metric | result |
|--------|-------:|
| Adder architecture | |
| Target FPGA | |
| Clock period | |
| LUTs | |
| Flip-flops | |
| Carry resources | |
| WNS | |
| TNS | |
| Total On-Chip Power | |
| Dynamic Power | |
| Device Static Power | |
| Power confidence | |
```

### 8. Write a short interpretation

Under the table, answer these questions in your own words:

1. What adder architecture did you choose, and why?
2. What is the critical timing path?
3. Did the design meet the 100 MHz clock constraint?
4. What resource appears most important to the arithmetic implementation?
5. How much of the estimated power is dynamic versus static?
6. What would you change if you wanted to optimize the design for speed?
7. Why are these FPGA measurements not the same thing as ASIC PPA?

Keep this section short. A few sentences or bullets are enough.

### 9. Final repository structure

Your submission should look approximately like:

```text
asic_101/
├── rtl/
│   ├── adder8.v
│   ├── alu_core.v
│   └── alu_top.v
├── sim/
│   └── alu_tb.v
├── constr/
│   └── alu.xdc
├── reports/
│   ├── check_timing.rpt
│   ├── drc.rpt
│   ├── power.rpt
│   ├── timing_summary.rpt
│   └── utilization.rpt
├── screenshots/
│   ├── simulation.png
│   ├── synthesized_schematic.png
│   ├── implemented_device.png
│   ├── timing_summary.png
│   └── power_summary.png
└── README.md
```

### 10. Push to GitHub

Before submitting:

```bash
git status
git add .
git commit -m "Complete ASIC 101 ALU"
git push
```

Make sure the reports and screenshots actually made it into the repository.

## Results

A complete ASIC 101 submission demonstrates the entire introductory RTL-to-FPGA implementation loop:

```text
specification
→ RTL
→ custom arithmetic architecture
→ exhaustive verification
→ synthesis
→ implementation
→ timing analysis
→ utilization analysis
→ power analysis
→ engineering interpretation
```

The next ASIC-specific step is to take verified RTL into a standard-cell physical-design flow and measure actual ASIC area, timing, and power.

## Checklist

- [ ] Recorded adder architecture
- [ ] Recorded LUT and register utilization
- [ ] Recorded carry resources
- [ ] Recorded WNS and TNS
- [ ] Inspected the critical path
- [ ] Recorded total, dynamic, and static power
- [ ] Checked timing warnings
- [ ] Checked DRC warnings
- [ ] Completed the README results table
- [ ] Wrote the short engineering interpretation
- [ ] Included reports
- [ ] Included screenshots
- [ ] Pushed the final repository

---

*PS: Anything past this page is not a required deliverable. However it dosen't mean it's redundant, rather it can be used by new members for reference*
