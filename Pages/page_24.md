# Optimize the design and compare the adder architectures

Now repeat the flow as an engineering experiment. Compare the Ripple Carry, Carry Lookahead, and Carry Select versions using the same process, clock constraint, floorplan methodology, and reporting method.

## Overview

A fair comparison changes **one primary design variable at a time**.

For the adder experiment:

```text
same ALU
same top-level registers
same PDK
same standard-cell library
same clock period
same physical constraints
same tool flow
different adder RTL
```

Then compare:

```text
area
timing
power estimate
wirelength
cell count
buffer count
routing
congestion
```

### Why FPGA results and ASIC results can disagree

An FPGA has:

```text
LUTs
dedicated carry chains
fixed routing architecture
fixed programmable resources
```

An ASIC has:

```text
standard cells
custom placement
custom routing
different wire RC
different cell choices
```

An architecture that performs well on an FPGA is not guaranteed to rank the same way in an ASIC.

## Prerequisites

- [inspection and file formats](page_23.md)
- one complete clean baseline run

## Steps

### 1. Create three design copies

For example:

```text
experiments/
├── ripple/
├── lookahead/
└── carry_select/
```

Each folder should use the appropriate `adder8.v`.

### 2. Keep the baseline configuration identical

Use the same:

```text
CLOCK_PERIOD
PDK
STD_CELL_LIBRARY
DIE_AREA
CORE_AREA
placement density
flow version
```

for the first comparison.

Do not secretly give one architecture more area.

### 3. Run all three

Example:

```bash
cd experiments/ripple
librelane config.json

cd ../lookahead
librelane config.json

cd ../carry_select
librelane config.json
```

### 4. Record synthesis results

For each version, record:

```text
mapped cell count
estimated cell area
major cell types
```

### 5. Record physical results

For each version:

```text
standard-cell area
die/core area
utilization
wirelength
buffer count
```

### 6. Record timing

For each version:

```text
worst setup slack
worst hold slack
critical path
critical-path corner
```

### 7. Record power

Use the same analysis assumptions for all three.

Record the power categories reported by the flow.

Relative comparison is much more meaningful when the methodology is identical.

### 8. Record signoff quality

Do not rank a design with violations above a clean design just because one PPA number looks attractive.

Record:

```text
DRC
LVS
antenna
setup
hold
routing violations
```

### 9. Build the comparison table

```markdown
| metric | Ripple | Lookahead | Carry Select |
|--------|-------:|----------:|-------------:|
| Mapped cells | | | |
| Standard-cell area | | | |
| Core area | | | |
| Utilization | | | |
| Wirelength | | | |
| Worst setup slack | | | |
| Worst hold slack | | | |
| Power estimate | | | |
| Worst IR drop | | | |
| DRC clean | | | |
| LVS clean | | | |
```

### 10. Explain the result physically

Do not stop at:

```text
Lookahead was faster.
```

Explain:

```text
what did synthesis map?
what is the critical path?
how many cells were inserted?
what happened to wirelength?
did routing become harder?
did the architecture survive optimization?
```

### 11. Experiment with utilization

After the fair baseline comparison, pick **one** adder and vary floorplan size or utilization methodology.

For example, compare:

```text
roomy core
moderate core
tight core
```

Do not choose values that make the design trivially impossible.

Observe:

```text
cell density
congestion
wirelength
timing
area
```

### 12. Experiment with clock period

Try a more aggressive clock target.

Example progression:

```text
10 ns
8 ns
6 ns
```

Do not assume the tool will close timing.

The point is to find where implementation becomes difficult and understand why.

### 13. Optional synthesis exploration

LibreLane provides a synthesis-exploration flow that can try multiple synthesis strategies.

Use:

```bash
librelane --flow SynthesisExploration config.json
```

Treat this as an optimization experiment after you understand the baseline.

### 14. Keep reproducibility information

Save:

```text
resolved.json
metrics.csv
metrics.json
tool version
PDK version
```

for each run.

If another student cannot reproduce your comparison, it is not a strong engineering comparison.

## Results

Your conclusion should answer:

1. Which adder used the least cell area?
2. Which had the best setup timing?
3. Which had the most routing/wirelength?
4. Which used the most estimated power?
5. Did the original RTL structure remain recognizable?
6. Did the ranking match your Vivado/FPGA result?
7. What tradeoff would you choose for a real design?

## Checklist

- [ ] Ran all three adder architectures
- [ ] Used identical baseline physical constraints
- [ ] Compared cell area
- [ ] Compared timing
- [ ] Compared power
- [ ] Compared wirelength
- [ ] Compared signoff status
- [ ] Performed one density/area experiment
- [ ] Performed one clock-period experiment
- [ ] Wrote a physical explanation, not only a ranking
- [ ] Continued to page 25

---

*Questions? Ask in the network Discord.*
