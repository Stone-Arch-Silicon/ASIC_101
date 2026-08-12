# Power, performance, area, and efficiency

A physical design is not judged by one number. Power, performance, area, routability, and correctness interact, and improving one can make another worse.

## Overview

The common shorthand is:

```text
PPA
```

meaning:

```text
Power
Performance
Area
```

### Power

Digital power is often discussed as:

```text
dynamic power
static/leakage power
```

A common intuition for switching power is:

```text
P_dynamic ∝ α C V² f
```

where:

- `α` is switching activity
- `C` is capacitance
- `V` is supply voltage
- `f` is switching frequency

This is an intuition, not a complete chip-power equation.

### Performance

For this synchronous block, performance is constrained by timing.

A smaller achievable clock period means a higher possible clock frequency:

```text
f = 1 / T
```

### Area

ASIC area may refer to different things:

```text
standard-cell area
core area
die/block area
```

Do not mix them.

### Efficiency is not one universal metric

Examples include:

```text
area efficiency
energy per operation
performance per area
power density
```

Choose a metric that matches the design goal.

## Prerequisites

- [post-route timing](page_20.md)

## Steps

### 1. Open final metrics

```bash
RUN=$(ls -dt runs/* | head -1)

cat "$RUN/final/metrics.csv"
```

For machine-readable inspection:

```bash
python3 -m json.tool "$RUN/final/metrics.json" | less
```

### 2. Search useful metrics

```bash
grep -iE \
'area|util|power|slack|tns|wns|wire|cell|drc|lvs|antenna|ir' \
"$RUN/final/metrics.csv"
```

Metric names can change as the flow evolves.

Use the semantic meaning, not a memorized line number.

### 3. Record physical area

Record separately:

```text
standard-cell area
core area
die/block area
```

For our explicit floorplan:

```text
die = 150 µm × 150 µm
```

but your actual reports are the authority.

### 4. Calculate area utilization

A useful conceptual metric is:

```text
cell utilization =
standard-cell area / core area
```

Do not confuse this with placement target density.

### 5. Record performance

Use post-route timing.

If your clock period is:

```text
10 ns
```

the requested frequency is:

```text
100 MHz
```

But if setup timing fails, the design has not demonstrated operation at that target.

A rough period estimate based only on worst setup slack can help intuition:

```text
approximate required period
≈ constrained period - worst setup slack
```

when WNS is negative under the same assumptions.

Treat this as an approximation, not a complete signoff calculation.

### 6. Inspect power reports

Find power reports:

```bash
find "$RUN" -type f -iname '*power*' -o -iname '*irdrop*'
```

Search:

```bash
grep -RniE "total|internal|switch|leak|power" \
  "$RUN"/*sta* "$RUN"/*power* 2>/dev/null | head -120
```

Record the categories that the current flow actually reports.

### 7. Interpret power carefully

Power accuracy depends on switching-activity assumptions.

If the flow does not have realistic activity information, treat power as an estimate suitable for learning and relative comparison.

Do not present a vectorless estimate as measured silicon power.

### 8. Define one project efficiency metric

For example:

```text
performance density =
frequency target / core area
```

or:

```text
cell packing efficiency =
standard-cell area / core area
```

State exactly what you calculated and its units.

Do not invent a vague single "chip efficiency percentage."

### 9. Think in tradeoffs

Examples:

```text
smaller core
→ less area
→ possibly more congestion
→ potentially worse timing
```

```text
larger drive cells
→ potentially better timing
→ more area
→ more load/power
```

```text
more buffers
→ may fix slew/timing
→ adds area and power
```

```text
lower clock frequency
→ easier setup timing
→ lower throughput
```

### 10. Save your PPA table

Add to the project README:

```markdown
## ASIC PPA

| metric | value |
|--------|------:|
| Standard-cell area | |
| Core area | |
| Die/block area | |
| Cell utilization | |
| Clock period | |
| Requested frequency | |
| Worst setup slack | |
| Worst hold slack | |
| Total power estimate | |
| Dynamic/switching power | |
| Leakage/static power | |
| Worst IR drop | |
| Total routed wirelength | |
```

## Results

You should be able to explain why this statement is wrong:

> Design A is better because it has fewer cells.

A complete comparison needs the design objective and physical results.

## Checklist

- [ ] Recorded standard-cell area
- [ ] Recorded core and die area
- [ ] Calculated utilization
- [ ] Recorded timing
- [ ] Recorded power estimate
- [ ] Recorded IR drop
- [ ] Recorded wirelength
- [ ] Defined any efficiency metric explicitly
- [ ] Continued to page 22

---

*Questions? Ask in the network Discord.*
