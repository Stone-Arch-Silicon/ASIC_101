# Final RTL-to-GDS submission and tapeout-readiness checklist

Package the complete project so another engineer can reproduce the design, inspect every major stage, verify the signoff results, and understand what remains before actual fabrication.

## Overview

A successful tutorial result is not just:

```text
alu_top.gds
```

A strong ASIC deliverable includes:

```text
source
constraints
configuration
run metadata
physical views
timing data
parasitics
verification reports
PPA metrics
engineering interpretation
```

### Hardened macro vs full chip

Your `alu_top` is a hardened digital block.

It is not automatically a full standalone chip with:

```text
pad ring
ESD
package
power pads
clock pad
reset pad
bond wires
bumps
shuttle wrapper
foundry delivery package
```

A higher-level design can integrate the macro using abstract views such as LEF plus timing models and connect it into a full-chip implementation.

### "GDS exists" is not signoff

Before a fabrication submission, the relevant project must satisfy the actual foundry/shuttle signoff requirements.

For this class, you will demonstrate the corresponding open-source checks and clearly state their status.

## Prerequisites

- [adder and optimization experiments](page_24.md)

## Steps

### 1. Final repository structure

A good repository looks like:

```text
asic_101_gds/
├── rtl/
│   ├── adder8.v
│   ├── alu_core.v
│   └── alu_top.v
├── screenshots/
│   ├── baseline_gds.png
│   ├── synthesis_cells.png
│   ├── floorplan.png
│   ├── tap_endcap.png
│   ├── pdn.png
│   ├── global_placement.png
│   ├── detailed_placement.png
│   ├── congestion_heatmap.png
│   ├── clock_tree.png
│   ├── global_routing.png
│   ├── detailed_routing.png
│   ├── metal_layers.png
│   ├── worst_setup_path.png
│   ├── worst_hold_path.png
│   ├── drc_clean.png
│   └── lvs_clean.png
├── config.json
└── README.md
```

Do not commit giant disposable run directories unless your team specifically wants them in Git.

Instead, archive or publish the required final reports/views according to the network submission instructions.

### 2. Record reproducibility metadata

In README:

```bash
librelane --version
yosys -V
openroad -version
```

Also record:

```text
PDK
standard-cell library
clock period
adder architecture
date of run
```

Keep the run's:

```text
resolved.json
```

with your archived submission when requested.

### 3. Final PPA table

```markdown
| metric | value |
|--------|------:|
| Adder architecture | |
| PDK | sky130A |
| Standard-cell library | sky130_fd_sc_hd |
| Clock period | |
| Requested frequency | |
| Mapped cells | |
| Standard-cell area | |
| Core dimensions | |
| Core area | |
| Die dimensions | |
| Die area | |
| Utilization | |
| Total routed wirelength | |
| Worst setup slack | |
| Worst hold slack | |
| Total negative setup slack | |
| Power estimate | |
| Worst IR drop | |
```

### 4. Final signoff table

```markdown
| check | status |
|-------|--------|
| RTL simulation | |
| Lint | |
| Synthesis | |
| Detailed routing | |
| Routing DRC | |
| Antenna | |
| Magic DRC | |
| KLayout DRC | |
| LVS | |
| Setup timing | |
| Hold timing | |
| XOR/stream comparison | |
| IR-drop report | |
```

Never write `PASS` unless you actually inspected the report.

### 5. Include the stage progression

Your README should show or link to:

```text
floorplan
→ PDN
→ placement
→ CTS
→ routing
→ final GDS
```

For each image, write one sentence explaining what physically changed.

### 6. Explain the critical path

Include:

```text
startpoint
endpoint
clock corner
logic/network path
worst slack
```

Then explain whether the delay is dominated by:

```text
logic depth
cell delay
wire delay
routing distance
fanout
```

### 7. Explain your area

Distinguish:

```text
cell area
core area
die area
```

and explain why they are different.

### 8. Explain your power result

State:

```text
what report produced it
what switching/activity assumptions were available
whether the value is measured or estimated
```

For this project it is an estimate.

### 9. Explain what GDS contains

Your final GDS contains physical geometric structures for the hardened block.

You should be able to point out:

- die/block boundary
- standard-cell rows
- standard cells
- PDN
- clock network
- signal routing
- vias
- filler structures
- pins

### 10. Explain what still remains for a real chip

A real product/shuttle integration may still require:

- top-level SoC integration
- hardened memory/analog macros
- padframe
- IO cells
- ESD
- package/bump/bond planning
- full-chip power integrity
- full-chip clock/reset planning
- shuttle wrapper
- density/fill requirements
- foundry-specific signoff decks
- final tapeout package review

The exact checklist depends on the fabrication program.

### 11. Write the final engineering conclusion

Answer:

1. What did you build?
2. Which adder did you choose?
3. What happened to it during synthesis?
4. What limited performance?
5. What determined area?
6. Where did routing consume space?
7. Did the design pass DRC and LVS?
8. Did setup and hold timing pass?
9. What would you optimize next?
10. What is the next step between this macro and manufactured silicon?

### 12. Final concept check

You should be able to explain the entire sentence below without hand-waving:

> The RTL was synthesized by Yosys into Sky130 standard cells, floorplanned and placed into a die/core geometry by OpenROAD, connected to a generated PDN, clock-buffered during CTS, routed with legal metal and vias, extracted into parasitic RC, analyzed with multi-corner STA and power/IR-drop estimation, physically checked with DRC/antenna/LVS-related signoff steps, and streamed into GDSII for physical integration or fabrication preparation.

## Results

You have completed an end-to-end introductory digital ASIC flow:

```text
RTL
→ GATES
→ FLOORPLAN
→ PDN
→ PLACEMENT
→ CTS
→ ROUTING
→ EXTRACTION
→ STA
→ POWER
→ DRC/LVS
→ GDSII
```

The important result is not the colorful GDS screenshot.

The important result is that you understand what changed at each stage, what each artifact means, and what evidence is required before claiming the design is physically correct.

## Checklist

- [ ] Repository is organized
- [ ] Tool and PDK information recorded
- [ ] PPA table complete
- [ ] Signoff table complete
- [ ] Stage screenshots complete
- [ ] Critical path explained
- [ ] Area explained
- [ ] Power estimate explained
- [ ] DRC checked
- [ ] LVS checked
- [ ] Setup checked
- [ ] Hold checked
- [ ] Final GDS inspected
- [ ] Hardened macro vs complete chip distinction understood
- [ ] Final engineering conclusion written
- [ ] ASIC 101 RTL-to-GDS complete

---

*Questions? Ask in the network Discord.*
