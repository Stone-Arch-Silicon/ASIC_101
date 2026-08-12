# Parasitics and static timing analysis

After routing, the wires are no longer abstract connections. Their physical geometry creates resistance and capacitance that must be extracted and included in timing analysis.

## Overview

An RTL wire looks ideal:

```verilog
wire carry;
```

A silicon interconnect behaves more like a distributed electrical network containing:

```text
resistance
capacitance
coupling
driver resistance
receiver capacitance
```

Longer wires generally mean more parasitic effects.

### RC extraction

OpenRCX extracts physical interconnect parasitics from the routed design.

These may be written into:

```text
SPEF
```

files.

SPEF stands for Standard Parasitic Exchange Format.

### Static Timing Analysis

STA analyzes timing mathematically without applying every possible simulation vector.

For each timing path it uses:

```text
cell delays
wire parasitics
clock timing
constraints
slew
load
PVT corner
```

to calculate arrival and required times.

### Slack

Simplified:

```text
slack = required arrival time - actual arrival time
```

For setup:

```text
positive slack = passes
zero slack     = exactly at limit
negative slack = violation
```

## Prerequisites

- [routing](page_19.md)

## Steps

### 1. Find RC extraction

```bash
RUN=$(ls -dt runs/* | head -1)

RCX_DIR=$(find "$RUN" -maxdepth 1 -type d \
  -name '*openroad-rcx*' | head -1)

echo "$RCX_DIR"
```

Inspect output files:

```bash
find "$RCX_DIR" -maxdepth 2 -type f -printf '%p\n' | sort
```

### 2. Find SPEF

```bash
find "$RUN" -type f -iname '*.spef' | head -20
```

Do not try to manually understand an entire SPEF file.

Open the beginning:

```bash
SPEF=$(find "$RUN" -type f -iname '*.spef' | head -1)
head -80 "$SPEF"
```

Notice:

```text
nets
capacitances
resistances
connections
```

### 3. Find post-PNR STA

```bash
STA_DIR=$(find "$RUN" -maxdepth 1 -type d \
  -name '*stapostpnr*' | head -1)

echo "$STA_DIR"
```

List reports:

```bash
find "$STA_DIR" -type f -printf '%p\n' | sort
```

### 4. Open the timing summary

Look for:

```text
summary.rpt
```

For example:

```bash
cat "$STA_DIR/summary.rpt"
```

Record:

- worst setup slack
- worst hold slack
- total negative setup slack
- total negative hold slack if reported
- violating endpoints
- corner

### 5. Inspect the worst setup path

Search the corner reports:

```bash
grep -Rni "slack" "$STA_DIR" | head -100
```

Open the report containing the worst max/setup timing path.

Identify:

```text
launch register
logic cells
net delays
capture register
clock arrival information
final slack
```

### 6. Inspect the worst hold path

Find the min/hold report.

Notice that the worst hold path may be very short.

That is expected.

Hold analysis asks whether data changes **too early**.

### 7. Understand cell delay vs net delay

A timing path is not just logic gates.

It contains:

```text
cell delay + interconnect delay
```

After route, net delay can become a major part of the critical path.

This is one reason post-route STA is more meaningful than an RTL-level timing guess.

### 8. Understand timing corners

A design should be checked across the PVT/interconnect corners configured by the PDK.

Different corners can dominate:

```text
setup
hold
slew
power
```

Do not assume the same corner is worst for everything.

### 9. Open timing paths graphically

Open final OpenROAD:

```bash
librelane --last-run --flow OpenInOpenROAD config.json
```

Use the timing-path viewer to inspect the worst path spatially.

Ask:

```text
Is it physically long?
Does it cross the ALU?
Is most delay cell delay or net delay?
Does it contain buffering?
```

### 10. Save evidence

Save:

```text
screenshots/worst_setup_path.png
screenshots/worst_hold_path.png
```

## Results

Record:

| timing metric | result |
|---------------|-------:|
| Clock period | |
| Worst setup slack | |
| Total negative setup slack | |
| Worst hold slack | |
| Setup-violating endpoints | |
| Hold-violating endpoints | |
| Worst setup corner | |
| Worst hold corner | |
| Critical path startpoint | |
| Critical path endpoint | |

## Checklist

- [ ] Found SPEF
- [ ] Understand resistance and capacitance parasitics
- [ ] Found post-route STA
- [ ] Recorded worst setup slack
- [ ] Recorded worst hold slack
- [ ] Inspected the worst timing path
- [ ] Understand cell delay vs net delay
- [ ] Understand multi-corner analysis
- [ ] Continued to page 21

---

*Questions? Ask in the network Discord.*
