# Page 21 — Power, performance, and area: read the implementation like an engineer

## What you are learning

A chip is rarely optimized for one number.

Engineers usually reason about tradeoffs between:

```text
Power
Performance
Area
```

often shortened to:

```text
PPA
```

This page teaches you to build a defensible PPA summary without pretending that estimates are measurements.

## 1. Area

For a hardened block, useful area-related quantities include:

```text
die area
core area
standard-cell area
utilization
cell count
```

These are related but not interchangeable.

### Die area

Using the baseline configuration:

```text
150 µm × 150 µm = 22,500 µm²
```

That is the deliberately oversized teaching boundary.

### Core area

Using:

```text
[10, 10, 140, 140]
```

the core dimensions are approximately:

```text
130 µm × 130 µm = 16,900 µm²
```

Again, this is not saying the logic intrinsically needs that much area.

It is the floorplan we gave it.

### Cell area

Cell area is the sum of standard-cell physical footprints according to the implementation.

This is much closer to the actual area occupied by logic cells than counting Verilog lines.

## 2. Performance

For a synchronous block, one obvious performance constraint is the clock period.

Our baseline target is:

```text
10 ns = 100 MHz
```

But you cannot simply claim:

```text
performance = 100 MHz
```

unless timing actually closes at that period.

A constraint is a request.

Timing reports tell you whether the implementation met the request.

## 3. Estimating a maximum frequency

If a design is timed at a period `T_constraint` and the worst setup slack is `S`, a rough educational estimate of the limiting period is:

```text
T_limit ≈ T_constraint - S
```

Be careful with signs.

Example:

```text
constraint = 10.0 ns
WNS       = +2.0 ns

rough limiting period ≈ 8.0 ns
rough frequency ≈ 125 MHz
```

This is an approximation for intuition, not a substitute for rerunning timing at the tighter constraint.

For a real result, tighten the clock constraint and rerun the flow.

## 4. Power

Digital power is often divided into two broad categories:

```text
dynamic power
static/leakage power
```

### Dynamic power

A common first-order intuition is:

```text
P_dynamic ∝ α C V² f
```

where:

```text
α = switching activity
C = switched capacitance
V = supply voltage
f = frequency
```

This is not a complete power model, but it explains useful trends.

### Leakage/static power

Transistors consume some current even when they are not intentionally switching.

That component depends strongly on process, voltage, temperature, transistor choices, and cell composition.

## 5. Power estimates depend on activity assumptions

A power tool needs to know or assume how often signals toggle.

If it does not have realistic activity from a workload, it may use default assumptions.

Therefore always ask:

```text
Where did the switching activity come from?
```

A power number without assumptions is easy to misuse.

## 6. Find final metrics

Run:

```bash
cd ~/asic_101/asic
RUN="$(ls -dt runs/*/ | head -1)"

ls "$RUN/final/metrics."*
```

LibreLane normally provides:

```text
metrics.csv
metrics.json
```

## 7. Explore `metrics.json` without memorizing key names

Use Python to print metrics whose names contain relevant concepts:

```bash
python3 - "$RUN/final/metrics.json" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path) as f:
    metrics = json.load(f)

keywords = (
    "area", "util", "cell", "power", "slack", "wns", "tns",
    "wire", "route", "drc", "lvs", "clock", "viol"
)

for key in sorted(metrics):
    low = key.lower()
    if any(word in low for word in keywords):
        print(f"{key}: {metrics[key]}")
PY
```

LibreLane metric naming evolves.

This method teaches you to inspect the data instead of assuming one frozen schema.

## 8. Build your PPA table

Create:

```text
reports/ppa_baseline.md
```

with a table like:

```markdown
| Metric | Baseline result | Notes |
|---|---:|---|
| PDK | sky130A | |
| Standard-cell library | sky130_fd_sc_hd | |
| Clock constraint | 10.0 ns | 100 MHz target |
| Worst setup slack | | corner/report: |
| Worst hold slack | | corner/report: |
| Die area | 22,500 µm² | teaching floorplan |
| Core area | 16,900 µm² | teaching floorplan |
| Standard-cell area | | from flow metrics |
| Cell count | | from flow metrics/netlist |
| Utilization | | from flow metrics |
| Estimated power | | include assumptions/corner |
| Routed wirelength | | if reported |
| DRC violations | | final signoff summary |
| LVS status | | final signoff summary |
```

If a metric is unavailable, write:

```text
not available / not reported
```

Do not invent it.

## 9. PPA is a trade space

Suppose you increase drive strengths to improve timing.

Possible consequences:

```text
performance improves
area increases
power increases
input capacitance increases
routing changes
```

Suppose you shrink the floorplan aggressively.

Possible consequences:

```text
die/core area decreases
placement density increases
routing congestion increases
timing may worsen
DRC/routing failures may increase
```

There is no universal “best PPA” without a design objective.

## 10. Efficiency needs a defined denominator

You may eventually define useful metrics such as:

```text
throughput / area
operations / joule
frequency / area
```

But ASIC 101's ALU does not have a meaningful workload throughput model that justifies pretending one scalar metric captures everything.

For this course, keep the raw engineering quantities visible.

## 11. Do not compare FPGA LUT count with ASIC cell area

These are different implementation fabrics.

FPGA logic uses programmable LUTs, switches, routing, and vendor primitives.

ASIC logic uses standard cells and custom-routed metal.

Numbers from the two domains can be educationally compared at a high level, but they are not the same area/power/timing units.

This course intentionally stays in the ASIC domain.

## Checkpoint

- [ ] you can define PPA
- [ ] you distinguish die, core, and cell area
- [ ] you understand that a clock constraint is not proof of achieved frequency
- [ ] you understand dynamic vs leakage power
- [ ] you understand why switching assumptions matter
- [ ] you inspected `metrics.json`
- [ ] you created a baseline PPA table
- [ ] you did not invent missing metrics

## References

- LibreLane final results and metrics: https://librelane.readthedocs.io/en/stable/getting_started/newcomers/
- LibreLane timing closure: https://librelane.readthedocs.io/en/stable/usage/timing_closure/
