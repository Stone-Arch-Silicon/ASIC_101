# Clock tree synthesis: build the physical clock network

Clock Tree Synthesis, or CTS, turns the logical clock connection into a physical network designed to reach every sequential element with controlled delay and skew.

## Overview

Before CTS, the netlist conceptually says:

```text
clk → every flip-flop
```

A single ideal driver cannot physically drive a large chip.

Real clock routing has:

```text
wire resistance
wire capacitance
sink capacitance
buffer delay
different path lengths
```

CTS inserts a tree of clock buffers.

Conceptually:

```text
             clk
              |
          clock buffer
          /          \
      buffer        buffer
      /   \          /   \
    FF    FF       FF    FF
```

### Clock latency

Clock latency is the time required for the clock edge to travel from its source to a sink.

### Clock skew

Clock skew is the difference in clock arrival time between sinks.

If:

```text
FF_A clock arrives at 1.0 ns
FF_B clock arrives at 1.2 ns
```

then the difference is:

```text
0.2 ns
```

Skew affects setup and hold timing.

### Why clocks receive special treatment

The clock controls when state changes.

Clock quality affects essentially every register-to-register timing path in the block.

## Prerequisites

- [placement](page_17.md)

## Steps

### 1. Find the CTS step

```bash
RUN=$(ls -dt runs/* | head -1)

CTS_DIR=$(find "$RUN" -maxdepth 1 -type d \
  -name '*openroad-cts*' | head -1)

echo "$CTS_DIR"
```

### 2. Open the post-CTS design

```bash
librelane \
  --with-initial-state "$CTS_DIR/state_out.json" \
  --flow OpenInOpenROAD \
  "$RUN/resolved.json"
```

### 3. Highlight the clock net

Use OpenROAD's GUI to select or search for:

```text
clk
```

Trace the network.

Look for clock buffers added by CTS.

### 4. Compare pre-CTS and post-CTS cell counts

Compare an earlier placement state with the CTS state.

CTS normally increases the number of cells because it inserts clock-tree elements.

### 5. Find clock reports

Search the CTS and later STA directories:

```bash
grep -RniE "skew|latency|clock" "$CTS_DIR" | head -100
```

Later multi-corner STA reports may provide more complete clock information.

### 6. Understand insertion delay

The clock at a register is not an ideal zero-delay event.

The tree contributes real delay.

This is why post-CTS timing is more physically realistic than pre-CTS timing.

### 7. Setup intuition

For a simplified register-to-register path:

```text
launch FF
→ combinational logic
→ capture FF
```

the data must arrive early enough before the capture clock edge.

A setup violation means the data path is too slow for the required cycle after accounting for clock timing and constraints.

### 8. Hold intuition

Data must not change too soon after the capture clock edge.

A hold violation is dangerous because simply lowering clock frequency does not automatically fix it.

Hold is about **minimum delay**, not maximum cycle time.

### 9. Save evidence

Save:

```text
screenshots/clock_tree.png
```

Try to make the highlighted clock network visible.

## Results

Record:

| CTS item | value/observation |
|----------|------------------:|
| Clock period | |
| Clock buffers inserted | |
| Reported skew | |
| Clock latency/insertion delay | |
| Post-CTS setup status | |
| Post-CTS hold status | |

## Checklist

- [ ] Understand CTS
- [ ] Understand clock latency
- [ ] Understand clock skew
- [ ] Can visually identify the clock network
- [ ] Understand setup vs hold at a high level
- [ ] Saved clock-tree screenshot
- [ ] Continued to page 19

---

*Questions? Ask in the network Discord.*
