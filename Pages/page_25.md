# Page 25 — Final submission: reproducibility, engineering handoff, and tapeout readiness

## What you are learning

The final product of ASIC 101 is not merely:

```text
alu_top.gds
```

A professional hardware project must be understandable and reproducible by another engineer.

Your final submission should answer:

```text
What did you design?
How do we know the logic is correct?
How was it implemented?
Which tools and PDK were used?
What timing/area/power results were obtained?
Which physical checks passed?
What failed or remains uncertain?
Can another person reproduce it?
What remains before real fabrication?
```

## 1. Final repository structure

A strong repository may look like:

```text
asic_101/
├── rtl/
│   ├── adder8.v
│   ├── alu_core.v
│   └── alu_top.v
├── rtl_variants/
│   ├── ripple/
│   ├── cla/
│   └── carry_select/
├── sim/
│   ├── adder8_tb.v
│   ├── alu_tb.v
│   └── alu_wave_tb.v
├── scripts/
│   └── synth.ys
├── asic/
│   └── config.json
├── asic_variants/
│   ├── ripple/
│   ├── cla/
│   └── carry_select/
├── build/
├── reports/
│   ├── asic_environment.txt
│   ├── baseline_config.json
│   ├── baseline_run_tag.txt
│   ├── sky130_cell_counts.txt
│   ├── ppa_baseline.md
│   ├── signoff_summary.md
│   ├── file_format_cheatsheet.md
│   └── adder_architecture_comparison.md
├── screenshots/
│   ├── 01_floorplan.png
│   ├── 02_pdn.png
│   ├── 03_placement.png
│   ├── 04_clock_tree.png
│   ├── 05_routing.png
│   └── 06_final_gds.png
└── README.md
```

You do **not** need to commit every huge temporary run artifact if that makes the repository impractical.

But another engineer must have enough source, configuration, versions, and evidence to reproduce the flow.

## 2. Record the exact source revision

Before final submission:

```bash
cd ~/asic_101
git status
git rev-parse HEAD
```

Store the commit hash in your final report.

If you have uncommitted design changes, the hash alone does not describe what you ran.

A reproducible result should correspond to a clean, identifiable source state.

## 3. Record the tool environment

Your Page 12 file:

```text
reports/asic_environment.txt
```

should include at least:

```text
LibreLane version
Yosys version
OpenROAD version
date
```

Also record the PDK and SCL:

```text
sky130A
sky130_fd_sc_hd
```

If your LibreLane run records a resolved configuration or PDK revision, preserve that information too.

## 4. Record the exact configuration

Never report physical results without keeping the configuration that produced them.

Your final handoff should make it possible to answer:

```text
What clock period?
What die/core size?
What PDK?
What standard-cell library?
What RTL files?
What density/utilization settings?
```

## 5. Verification evidence

Your README should state the functional verification status explicitly.

For example:

```text
Adder unit test: PASS
ALU directed waveform test: PASS
ALU exhaustive combinational regression: PASS — 524,288 vectors
```

If you changed adder architectures, each one should pass the same functional contract before its physical metrics are considered.

## 6. PPA evidence

Include your baseline table and architecture-comparison table.

For each metric, identify:

```text
value
unit
corner/assumption where relevant
source report or metric file
```

Do not write:

```text
power = 0.42
```

Write something more defensible:

```text
estimated power = 0.42 mW
source = <report>
corner/activity assumptions = <what the flow used>
```

if that information is available.

## 7. Timing evidence

Record:

```text
clock period
worst setup slack
worst hold slack
critical-path startpoint
critical-path endpoint
whether timing closed
```

If setup or hold fails, say so.

A failed timing result does not make the educational project worthless.

Hiding it does.

## 8. Physical-verification evidence

Include a table like:

```markdown
| Check | Result | Evidence |
|---|---|---|
| Detailed routing | PASS/FAIL | |
| Antenna | PASS/FAIL | |
| DRC | PASS/FAIL | |
| LVS | PASS/FAIL | |
| Setup timing | PASS/FAIL | |
| Hold timing | PASS/FAIL | |
```

Do not use the word `PASS` unless you can point to evidence.

## 9. Explain the critical path

A strong final report does not only state slack.

Explain what the path physically contains.

For example:

```text
input register
→ arithmetic/carry logic
→ result-selection muxing
→ output register
```

Then explain whether cell delay or wire delay is significant.

If your architectural experiment changed the critical path, explain that too.

## 10. Explain the final layout

Use your chronological screenshots to explain:

```text
floorplan
power grid
placement
clock tree
routing
final GDS
```

Someone looking at the pictures should understand what changed from one stage to the next.

## 11. Explain what the final GDS actually contains

Your final GDS is a physical layout representation of the hardened block.

It includes detailed geometry for the block and instantiated cells according to the flow's stream-out process.

But it does **not** magically mean you possess a complete consumer chip.

## 12. What remains before a real standalone tapeout?

Depending on the fabrication program and integration strategy, additional work can include:

```text
chip-level integration
pad ring or bump planning
I/O cells
ESD structures
power/ground pads
package planning
clock/reset entry strategy
analog interfaces if needed
foundry/shuttle-specific rules
waivers and signoff requirements
final top-level DRC/LVS/timing/power-integrity checks
manufacturing submission requirements
```

If the block is integrated into a wrapper such as a shuttle harness, the wrapper supplies some of these functions.

The integration rules are program-specific.

## 13. Hardened macro vs fabricated silicon

Use precise language.

These statements mean different things:

```text
“I wrote RTL.”
“I synthesized the RTL.”
“I completed place and route.”
“I generated GDS.”
“My block passed the listed open-source checks.”
“My design was submitted for fabrication.”
“My silicon was fabricated.”
“My packaged silicon was electrically tested.”
```

Do not collapse them into one claim.

## 14. Final README structure

A recommended final `README.md` outline is:

```markdown
# ASIC 101 — 8-bit ALU

## What this project is

## Architecture

## RTL hierarchy

## Verification

## Open-source toolchain

## PDK and standard-cell library

## LibreLane configuration

## Physical-design flow

### Synthesis
### Floorplan
### PDN
### Placement
### CTS
### Routing
### Parasitics and STA
### Signoff

## Baseline PPA

## Adder architecture experiment

## Critical-path analysis

## Physical verification summary

## Visual progression

## Reproduction instructions

## Known issues / unresolved warnings

## What remains before fabrication
```

## 15. Reproduction instructions should be short and exact

A new engineer should not need to reverse-engineer your environment from screenshots.

At minimum, document something like:

```bash
# enter LibreLane environment
nix-shell ~/librelane/shell.nix

# run baseline
cd ~/asic_101/asic
librelane config.json

# inspect final layout
librelane --last-run --flow OpenInKLayout config.json
```

Also document how to rerun the functional verification from Part 1.

## 16. Final concept check

You are ready to finish ASIC 101 when you can answer all of these without guessing:

1. What is RTL?
2. What does a testbench do?
3. What is synthesis?
4. What is a standard cell?
5. What is a PDK?
6. What is the difference between die and core?
7. What is placement?
8. Why does a chip need a PDN?
9. Why is the clock given special physical treatment?
10. What is global vs detailed routing?
11. What are parasitic resistance and capacitance?
12. What does STA do?
13. What is setup slack?
14. What is hold timing?
15. What is DRC?
16. What is LVS?
17. What is the difference between LEF and GDS?
18. Why can two functionally identical adders have different PPA?
19. Why is a generated GDS not automatically a tapeout-ready standalone chip?
20. What evidence would you hand another engineer so they could reproduce your result?

If you can explain those questions and show the corresponding evidence from your project, you have completed the intended ASIC 101 learning loop.

## 17. Final completion checklist

### Functional design

- [ ] RTL is committed and identifiable by Git revision
- [ ] adder verification passes
- [ ] ALU directed verification passes
- [ ] exhaustive ALU regression passes
- [ ] any architecture variants also pass the same tests

### Reproducibility

- [ ] LibreLane version recorded
- [ ] Yosys version recorded
- [ ] OpenROAD version recorded
- [ ] PDK recorded
- [ ] standard-cell library recorded
- [ ] exact configuration preserved
- [ ] reproduction commands documented

### Physical design

- [ ] technology-mapped standard-cell netlist inspected
- [ ] floorplan inspected
- [ ] PDN inspected
- [ ] placement inspected
- [ ] clock tree inspected
- [ ] routing inspected
- [ ] parasitics located
- [ ] timing reports inspected
- [ ] final GDS opened in KLayout

### Engineering analysis

- [ ] baseline PPA table complete
- [ ] critical path documented
- [ ] setup status documented
- [ ] hold status documented
- [ ] DRC status documented
- [ ] LVS status documented
- [ ] antenna status documented
- [ ] unresolved warnings listed
- [ ] architecture comparison completed fairly

### Handoff

- [ ] file-format cheat sheet complete
- [ ] stage screenshots organized chronologically
- [ ] README explains the flow in your own words
- [ ] claims distinguish estimates from measurements
- [ ] claims distinguish hardened macro from fabricated silicon
- [ ] known limitations are explicit

## References

- LibreLane documentation: https://librelane.readthedocs.io/
- OpenROAD documentation: https://openroad.readthedocs.io/
- Yosys documentation: https://yosyshq.readthedocs.io/
- SKY130 PDK documentation: https://skywater-pdk.readthedocs.io/
- KLayout: https://www.klayout.de/
- Magic: http://opencircuitdesign.com/magic/
- Netgen: http://opencircuitdesign.com/netgen/
