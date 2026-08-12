# Understand the PDK and standard-cell library

Before running the ALU, understand what a PDK actually gives the tools. The RTL is process-independent; the PDK is what turns that logic into geometry and electrical models for a real manufacturing process.

## Overview

A **PDK**, or Process Design Kit, is the interface between chip designers and a semiconductor manufacturing process.

For this tutorial we use:

```text
sky130A
```

with the default high-density standard-cell library:

```text
sky130_fd_sc_hd
```

Sky130A contains five main metal routing layers plus local interconnect.

### RTL does not contain transistor geometry

This Verilog:

```verilog
assign y = a & b;
```

does not tell a foundry:

```text
where to draw diffusion
where to draw polysilicon
how wide metal should be
what spacing is legal
how fast the gate is
how much capacitance it presents
```

The PDK and standard-cell library provide those facts.

### Standard cells

A standard cell is a pre-designed physical implementation of a small logic function.

Examples include:

```text
inverter
NAND
NOR
AND
OR
XOR
multiplexer
buffer
flip-flop
clock buffer
tie cell
tap cell
filler cell
```

A synthesized ASIC is mostly a large number of these cells placed in rows and connected with metal.

### Different views of one cell

The same cell can have several representations.

| file/view | contains |
|-----------|----------|
| `.lib` Liberty | delay, slew, capacitance, power, timing arcs |
| LEF | abstract size, pins, routing blockages |
| GDS | full physical geometry |
| SPICE | transistor-level electrical representation |
| Verilog | functional model |

The tool uses the cheapest useful view for each task.

For example:

- synthesis needs logic/timing information
- placement needs cell dimensions
- routing needs pins and obstructions
- stream-out needs full GDS geometry
- LVS needs connectivity/electrical information

### FEOL and BEOL

**FEOL**, front end of line, creates devices such as transistors.

**BEOL**, back end of line, creates the interconnect stack above those devices.

A routed digital block contains many BEOL shapes:

```text
metal wires
vias
power straps
clock routes
signal routes
```

## Prerequisites

- [toolchain installed](page_11.md)

## Steps

### 1. Find your PDK root

LibreLane/Volare normally manages the PDK under your home directory.

Try:

```bash
echo "${PDK_ROOT:-$HOME/.volare}"
```

You can also inspect:

```bash
ls ~/.volare
```

Do not modify PDK files for this tutorial.

### 2. Understand `sky130A`

`sky130A` is the fully qualified PDK variant name.

Use:

```text
sky130A
```

not:

```text
sky130
```

The variant matters because the backend metal stack and extracted interconnect behavior are part of the process definition.

### 3. Understand the standard-cell library name

The default Sky130 standard-cell library used by the flow is:

```text
sky130_fd_sc_hd
```

Break the name apart conceptually:

```text
sky130
fd
sc
hd
```

The important part for this class is that `hd` is a high-density digital standard-cell library.

### 4. Look at cell names after synthesis

Later you will see names similar to:

```text
sky130_fd_sc_hd__and2_1
sky130_fd_sc_hd__mux2_1
sky130_fd_sc_hd__dfxtp_1
sky130_fd_sc_hd__buf_2
```

The suffix often represents a drive-strength variant.

A stronger cell can drive more load or improve slew, but usually consumes more area and power.

This is one of the basic physical-design tradeoffs:

```text
stronger drive
→ possibly faster
→ usually larger
→ usually more power/capacitance
```

### 5. Understand PVT corners

Real silicon is not one perfect device.

Timing changes with:

```text
Process
Voltage
Temperature
```

Together these are often called **PVT** conditions.

Physical interconnect also has corners, so LibreLane's reports may use fully qualified interconnect/process/voltage/temperature corners.

Do not report only the best corner and pretend it represents every chip.

### 6. Know what the PDK controls

The PDK provides or constrains things such as:

- legal metal layers
- routing directions
- widths
- spacings
- via definitions
- design rules
- standard-cell dimensions
- timing models
- power models
- RC extraction information
- IO routing layers
- well tap cells
- endcap cells
- filler and decap cells

The PDK is why a layout for one process cannot simply be fabricated in another process.

## Results

You should now be able to explain this sentence:

> Yosys maps the ALU into the logic cells available in the selected standard-cell library, and OpenROAD physically places and connects those cells using the geometry, routing, timing, and extraction information supplied by the PDK.

## Checklist

- [ ] Know what a PDK is
- [ ] Know what a standard cell is
- [ ] Know the difference between Liberty, LEF, GDS, SPICE, and Verilog cell views
- [ ] Know the difference between FEOL and BEOL
- [ ] Know what PVT means
- [ ] Continued to page 13

---

*Questions? Ask in the network Discord.*
