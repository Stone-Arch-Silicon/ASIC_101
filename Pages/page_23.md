# Inspect every stage and every major ASIC file

The run directory is a history of the chip being constructed. Use intermediate states to visually inspect what changed at each step instead of treating the flow as a black box.

## Overview

Each LibreLane step receives a design state and produces a new state.

A typical step directory contains files such as:

```text
COMMANDS
config.json
*.log
*.odb
*.def
*.nl.v
*.pnl.v
*.sdc
state_in.json
state_out.json
```

### Important formats

| format | purpose |
|--------|---------|
| `.v` RTL | behavioral/source logic |
| `.nl.v` | gate-level netlist without explicit power connections |
| `.pnl.v` | gate-level netlist with power connections |
| `.sdc` | timing constraints |
| `.def` | physical implementation exchange: rows, components, pins, routing |
| `.lef` | abstract macro physical view |
| `.odb` | OpenROAD/OpenDB design database |
| `.spef` | extracted parasitic resistance/capacitance |
| `.sdf` | timing delays for timing-aware simulation |
| `.lib` | Liberty timing/power model |
| `.spice` | electrical/transistor-level netlist |
| `.gds` | final geometric mask-layout stream |

### LEF vs GDS

LEF is intentionally abstract.

A macro LEF tells a parent design things such as:

```text
block dimensions
pin shapes
routing obstructions
```

without requiring the parent router to understand every transistor polygon.

GDS contains the detailed physical geometry.

### DEF vs GDS

DEF describes an implementation using design objects and physical coordinates.

GDS is a lower-level geometric layout stream.

### ODB

ODB is OpenROAD's database representation.

It is especially useful because OpenROAD can reopen the design with rich knowledge of:

```text
instances
nets
timing
routing
layers
parasitics
```

## Prerequisites

- [signoff checks](page_22.md)

## Steps

### 1. Find the latest run

```bash
RUN=$(ls -dt runs/* | head -1)
echo "$RUN"
```

### 2. List all step directories

```bash
find "$RUN" -maxdepth 1 -mindepth 1 -type d \
  -printf '%f\n' | sort
```

### 3. Make a stage table

For each of these stages, find the matching directory:

```text
Yosys synthesis
floorplan
tap/endcap insertion
PDN generation
global placement
detailed placement
CTS
global routing
detailed routing
RC extraction
post-PNR STA
GDS stream-out
DRC
LVS
```

Write the actual folder names into your README.

### 4. Generic command to open an intermediate OpenROAD state

Suppose:

```bash
STEP_DIR="$RUN/<step-folder>"
```

Then:

```bash
librelane \
  --with-initial-state "$STEP_DIR/state_out.json" \
  --flow OpenInOpenROAD \
  "$RUN/resolved.json"
```

Use this repeatedly.

### 5. Open detailed routing in KLayout

```bash
DRT_DIR=$(find "$RUN" -maxdepth 1 -type d \
  -name '*detailedrouting*' | head -1)

librelane \
  --with-initial-state "$DRT_DIR/state_out.json" \
  --flow OpenInKLayout \
  "$RUN/resolved.json"
```

If a GDS does not exist yet for that state, the viewer can use the physical DEF view.

### 6. Open final GDS in KLayout

```bash
librelane --last-run --flow OpenInKLayout config.json
```

### 7. Open final design in OpenROAD

```bash
librelane --last-run --flow OpenInOpenROAD config.json
```

### 8. Use KLayout layer controls

In KLayout:

- zoom into one standard cell
- toggle metal layers
- toggle via layers
- identify the PDN
- identify signal routes
- locate block pins
- inspect the die boundary
- inspect repeated standard-cell geometry

At very high zoom you are no longer looking at "gates" as schematic symbols.

You are looking at physical layout polygons.

### 9. Do not confuse colors with electrical meaning

EDA viewers assign display colors to layers.

The color is a visualization choice.

The **layer name and datatype** define the physical meaning.

### 10. Inspect final deliverables

List final files:

```bash
find "$RUN/final" -type f -printf '%p\n' | sort
```

Then answer:

```text
Which file would a parent block use for abstract placement?
Which file contains final layout geometry?
Which file contains parasitics?
Which file contains delays?
Which file contains powered connectivity?
Which file contains timing constraints?
```

### 11. Build a visual progression

Save one screenshot from each major stage:

```text
01_synthesis_or_netlist.png
02_floorplan.png
03_pdn.png
04_global_placement.png
05_detailed_placement.png
06_cts.png
07_global_routing.png
08_detailed_routing.png
09_final_gds.png
```

Put them in order.

This progression is one of the best ways to understand RTL-to-GDS.

## Results

You should now be able to look at an arbitrary file from a digital ASIC flow and explain why it exists.

## Checklist

- [ ] Opened multiple intermediate states
- [ ] Understand RTL vs gate-level netlist
- [ ] Understand powered vs unpowered netlist
- [ ] Understand LEF
- [ ] Understand DEF
- [ ] Understand ODB
- [ ] Understand SPEF
- [ ] Understand SDF
- [ ] Understand Liberty
- [ ] Understand SPICE
- [ ] Understand GDSII
- [ ] Built the visual stage progression
- [ ] Continued to page 24

---

*Questions? Ask in the network Discord.*
