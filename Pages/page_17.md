# Placement: where the standard cells physically go

Placement assigns physical coordinates to the synthesized standard cells while trying to satisfy wirelength, density, routability, and timing goals.

## Overview

Before placement, the netlist says:

```text
cell A connects to cell B
cell B connects to cell C
```

but it does not say:

```text
cell A is at x=43.2 µm, y=71.4 µm
```

Placement creates those coordinates.

### Global placement

Global placement finds good approximate locations.

Cells may not yet be perfectly legal on placement sites.

It tries to optimize objectives such as:

```text
wirelength
density
routability
sometimes timing
```

### Detailed placement

Detailed placement legalizes cells:

```text
inside legal rows
on legal sites
without illegal overlaps
```

while trying not to destroy the global-placement solution.

### Why placement affects timing

Wire delay depends on physical distance and load.

A net that was "just a wire" in RTL may become:

```text
a long RC interconnect
```

in silicon.

Moving connected cells closer can reduce wire delay and capacitance.

### Why placement affects routing

If too many nets need the same region:

```text
routing demand > routing capacity
```

and congestion appears.

## Prerequisites

- [PDN](page_16.md)

## Steps

### 1. Find global placement

```bash
RUN=$(ls -dt runs/* | head -1)

GPL_DIR=$(find "$RUN" -maxdepth 1 -type d \
  -name '*openroad-globalplacement' | tail -1)

echo "$GPL_DIR"
```

There may be an earlier `globalplacementskipio` stage.

For this page use the later main global-placement state when available.

### 2. Open global placement in OpenROAD

```bash
librelane \
  --with-initial-state "$GPL_DIR/state_out.json" \
  --flow OpenInOpenROAD \
  "$RUN/resolved.json"
```

### 3. Identify cell clusters

Zoom in.

Try to distinguish:

```text
flip-flops
combinational cells
buffers
physical-only cells
```

Use instance selection/properties in the GUI.

### 4. Find detailed placement

```bash
DPL_DIR=$(find "$RUN" -maxdepth 1 -type d \
  -name '*detailedplacement*' | head -1)

echo "$DPL_DIR"
```

Open it:

```bash
librelane \
  --with-initial-state "$DPL_DIR/state_out.json" \
  --flow OpenInOpenROAD \
  "$RUN/resolved.json"
```

### 5. Compare global vs detailed placement

Look for:

- cells snapped to rows
- overlap removal
- local movement
- row alignment

### 6. Open heatmaps

In OpenROAD GUI, inspect available heatmaps such as:

```text
placement density
routing congestion
power/IR-drop views if available for the state
```

A heatmap converts a huge physical dataset into spatial information.

For congestion:

```text
hot region
= lots of routing demand relative to capacity
```

### 7. Understand density

If placement is too dense:

```text
cells compete for routing access
buffers have nowhere to go
routing detours increase
timing can worsen
```

If placement is too sparse:

```text
die/core becomes larger
wirelength can grow
area efficiency decreases
```

The goal is not maximum density.

The goal is a design that closes:

```text
timing
routing
power
physical verification
```

at acceptable area.

### 8. Inspect optimization cells

Physical design may insert or resize cells that were not obvious in the original RTL:

```text
buffers
stronger/slower drive variants
timing repair cells
```

This is normal.

The physical netlist evolves during implementation.

### 9. Save screenshots

Save:

```text
screenshots/global_placement.png
screenshots/detailed_placement.png
screenshots/congestion_heatmap.png
```

## Results

Record:

| placement item | observation |
|----------------|-------------|
| Placement density | |
| Visible whitespace | |
| Congestion hotspots | |
| Added buffers visible | |
| Legalized rows | yes/no |

## Checklist

- [ ] Understand global placement
- [ ] Understand detailed placement
- [ ] Can see legal standard-cell rows
- [ ] Can explain why density is not simply "higher is better"
- [ ] Inspected congestion
- [ ] Saved placement screenshots
- [ ] Continued to page 18

---

*Questions? Ask in the network Discord.*
