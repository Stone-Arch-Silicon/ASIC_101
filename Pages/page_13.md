# Configure and run the ALU flow

Create the LibreLane design configuration and run a complete baseline RTL-to-GDS implementation before tuning individual stages.

## Overview

LibreLane is a flow orchestrator.

Instead of manually invoking every program, you provide:

```text
RTL
constraints
PDK choice
physical-design settings
```

LibreLane creates a sequence of steps and passes the design state from one tool to the next.

A configuration file is not HDL.

It describes **how the EDA flow should implement the HDL**.

## Prerequisites

- [PDK and standard cells](page_12.md)
- working `adder8.v`
- working `alu_core.v`
- working `alu_top.v`
- inside the LibreLane environment

## Steps

### 1. Prepare the project

Your folder should look like:

```text
asic_101_gds/
├── rtl/
│   ├── adder8.v
│   ├── alu_core.v
│   └── alu_top.v
├── screenshots/
└── config.json
```

### 2. Create `config.json`

Start with:

```json
{
  "DESIGN_NAME": "alu_top",

  "VERILOG_FILES": [
    "dir::rtl/adder8.v",
    "dir::rtl/alu_core.v",
    "dir::rtl/alu_top.v"
  ],

  "CLOCK_PORT": "clk",
  "CLOCK_PERIOD": 10.0,

  "PDK": "sky130A",
  "STD_CELL_LIBRARY": "sky130_fd_sc_hd",

  "FP_SIZING": "absolute",
  "DIE_AREA": [0, 0, 150, 150],
  "CORE_AREA": [10, 10, 140, 140],

  "FP_CORE_UTIL": 35,
  "PL_TARGET_DENSITY_PCT": 45
}
```

### 3. Understand every field

`DESIGN_NAME`

```text
alu_top
```

must match the top-level Verilog module.

`VERILOG_FILES`

tells synthesis which RTL files belong to the design.

`CLOCK_PORT`

identifies the top-level clock port.

`CLOCK_PERIOD`

is in nanoseconds.

```text
10 ns = 100 MHz
```

The period is a **constraint**, not a promise.

The flow tries to produce a physical implementation that satisfies it.

`PDK`

selects the manufacturing-process configuration.

`STD_CELL_LIBRARY`

selects the standard-cell library.

`FP_SIZING`

set to `absolute` means we are explicitly choosing physical dimensions.

`DIE_AREA`

is the outer physical block boundary:

```text
x0 y0 x1 y1
```

in micrometers.

`CORE_AREA`

is the region inside the die where standard-cell rows are created.

Our starting geometry is intentionally roomy because the ALU is tiny and we want enough space to clearly inspect the PDN and routing.

`FP_CORE_UTIL`

is still useful as an educational reference for utilization-oriented experiments, although explicit die/core geometry fixes the available physical region.

`PL_TARGET_DENSITY_PCT`

controls the target cell-placement density.

Do not optimize these numbers yet.

First make a baseline run.

### 4. Run the full flow

From the project directory:

```bash
librelane config.json
```

The default flow is `Classic`.

This is equivalent to explicitly writing:

```bash
librelane --flow Classic config.json
```

### 5. Watch the step names

You should see steps corresponding to stages such as:

```text
Verilator lint
Yosys synthesis
pre-PNR STA
floorplan
tap/endcap insertion
PDN generation
global placement
IO placement
detailed placement
CTS
global routing
antenna checking/repair
detailed routing
RC extraction
post-PNR STA
IR-drop reporting
GDS stream-out
DRC
LVS
manufacturability checks
```

The exact numbering can change between releases.

The **step names** matter more than the numeric prefixes.

### 6. Find the run directory

After the run:

```bash
ls runs
```

A run directory will contain individual step folders.

A typical run contains:

```text
runs/<run-tag>/
├── 01-...
├── 02-...
├── ...
├── final/
├── error.log
├── info.log
├── warning.log
└── resolved.json
```

### 7. Find the final views

```bash
find runs -path "*/final/*" -maxdepth 4 -type f | head -50
```

The final directory may contain:

```text
def/
gds/
lef/
lib/
nl/
odb/
pnl/
sdc/
sdf/
spef/
spice/
metrics.csv
metrics.json
```

### 8. Open the final layout in KLayout

```bash
librelane --last-run --flow OpenInKLayout config.json
```

### 9. Open it in OpenROAD

```bash
librelane --last-run --flow OpenInOpenROAD config.json
```

KLayout is excellent for viewing final geometric layers.

OpenROAD is better for understanding the physical-design database, timing paths, cells, nets, congestion, and routing.

### 10. Save a baseline screenshot

Save:

```text
screenshots/baseline_gds.png
```

Do not worry if it looks mostly like colored rectangles right now.

The next pages explain what every major structure is.

## Results

You should now have your first ASIC implementation of the ALU.

Do not call the project finished merely because a `.gds` file exists.

You still need to understand:

- what synthesis built
- what the floorplan means
- how power is delivered
- why cells are where they are
- how the clock is distributed
- where routing congestion appears
- whether timing closes
- whether DRC/LVS/signoff checks pass

## Checklist

- [ ] Created `config.json`
- [ ] Understand every configuration field
- [ ] Full flow completed
- [ ] Located the run directory
- [ ] Located final GDS
- [ ] Opened KLayout
- [ ] Opened OpenROAD
- [ ] Saved baseline screenshot
- [ ] Continued to page 14

---

*Questions? Ask in the network Discord.*
