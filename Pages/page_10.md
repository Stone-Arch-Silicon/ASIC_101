# Open-source ASIC flow: RTL to GDSII

This half of ASIC 101 takes the verified ALU from RTL all the way through an open-source ASIC physical-design flow. You will synthesize into real standard cells, create a die and core, build a power grid, place cells, build the clock tree, route metal, extract parasitics, run timing and physical verification, and inspect the final GDSII.

## Overview

The flow in the first half of ASIC 101 used Vivado to implement the ALU on an FPGA.

This half targets an ASIC process.

The conceptual flow is:

```text
RTL
 ↓
lint
 ↓
logic synthesis
 ↓
standard-cell netlist
 ↓
floorplan
 ↓
power distribution network
 ↓
placement
 ↓
clock tree synthesis
 ↓
global routing
 ↓
detailed routing
 ↓
parasitic extraction
 ↓
static timing analysis
 ↓
physical verification
 ↓
GDSII
```

The main tools are:

| tool | job |
|------|-----|
| LibreLane | orchestrates the complete RTL-to-GDS flow |
| Yosys | RTL synthesis and technology mapping |
| OpenROAD | floorplan, placement, CTS, routing, STA, optimization |
| OpenRCX | resistance/capacitance extraction |
| Magic | layout processing, extraction, DRC, stream-out |
| KLayout | layout viewing, stream-out, DRC |
| Netgen | LVS |
| Volare | obtains compatible open-source PDK builds |

### Why does this say LibreLane instead of OpenLane?

OpenLane 2 was continued by its original authors as **LibreLane**. Current installations and commands use:

```bash
librelane
```

The architecture is still the OpenLane 2 lineage, and OpenROAD is still the main physical-design engine.

If you see tutorials using:

```bash
./flow.tcl
```

or:

```bash
openlane
```

check their date before copying commands.

### What are we physically building?

We are hardening the `alu_top` design as a small digital macro.

The result contains:

- a die boundary
- a core area
- rows of standard cells
- combinational cells
- flip-flops
- clock buffers
- tap and endcap cells
- power rails and straps
- signal routing
- vias
- filler cells
- physical verification data
- GDSII geometry

This is **not automatically a complete packaged chip**.

A standalone tapeout normally also needs top-level integration such as:

- IO/pad cells
- ESD structures
- pad ring or bump planning
- package connections
- foundry-specific signoff requirements
- shuttle-specific wrapper/integration requirements

Think of this project as creating a hardened digital block that could later be integrated into a larger chip.

## Prerequisites

- completed [ASIC 101 ALU project](page_9.md)
- working Verilog for `adder8`, `alu_core`, and `alu_top`
- Git
- Linux, WSL2, or macOS
- at least 8 GiB RAM; 16 GiB is strongly preferred
- comfort using a terminal

## Steps

1. Keep your working RTL from the Vivado project.

2. Create a new physical-design directory:

```bash
mkdir -p asic_101_gds
cd asic_101_gds

mkdir -p rtl
mkdir -p docs
mkdir -p screenshots
```

3. Copy your RTL into:

```text
asic_101_gds/
└── rtl/
    ├── adder8.v
    ├── alu_core.v
    └── alu_top.v
```

4. Continue to [install the open-source toolchain](page_11.md).

## Results

At the end of this section you will have multiple views of the same design:

| view | what it represents |
|------|--------------------|
| RTL Verilog | behavioral hardware description |
| gate-level Verilog | standard-cell connectivity |
| LEF | abstract physical macro view |
| DEF | placed/routed implementation data |
| ODB | OpenROAD database |
| SDC | timing constraints |
| SPEF | extracted parasitic RC |
| SDF | annotated delays |
| Liberty | timing/power models |
| SPICE | transistor/electrical netlist |
| GDSII | final mask-layout geometry |

## Checklist

- [ ] Understand the complete RTL-to-GDS flow
- [ ] Understand that this project is a hardened macro, not automatically a complete packaged chip
- [ ] Created the new project directory
- [ ] Copied the working ALU RTL
- [ ] Continued to page 11

---

*Questions? Ask in the network Discord.*
