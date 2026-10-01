# Page 11 — From synthesized logic to real silicon: PDKs and standard cells

## What you are learning

The first ten pages were mostly technology-independent.

Now we need to connect the RTL to a manufacturing process.

This page introduces:

- PDKs
- standard cells
- Liberty
- LEF
- DEF
- GDSII
- SDC
- SPEF
- process corners
- the physical-design flow

You are not expected to memorize every file format immediately.

The goal is to understand why each category exists.

## 1. RTL does not contain geometry

This RTL:

```verilog
assign y = a & b;
```

does not tell a foundry:

```text
where transistors are
how wide the metal is
which routing layer to use
where the cell sits
how much delay the gate has
how much capacitance the pins have
```

RTL describes logical behavior.

A manufacturing process requires physical and electrical information.

## 2. What is a PDK?

PDK means:

```text
Process Design Kit
```

A PDK contains data and rules needed to design for a particular semiconductor process.

Depending on the PDK and flow, this can include:

- layer definitions
- design rules
- transistor models
- extraction rules
- technology files
- device models
- standard-cell libraries
- timing information
- layout information

ASIC 101 uses the open SKY130 ecosystem.

## 3. What is a standard cell?

A standard cell is a predesigned, characterized logic building block.

Examples include:

```text
inverter
NAND
NOR
XOR
mux
buffer
flip-flop
clock buffer
```

Instead of drawing every transistor in your synthesized design manually, synthesis maps logic onto cells from a library.

The physical-design tools then place instances of those cells and connect them with metal.

## 4. One cell has multiple views

Different tools need different information about the same cell.

For example, a NAND gate may have:

```text
logical function
timing delay
input capacitance
physical width and height
pin locations
transistor-level connectivity
final mask geometry
```

One file format is not ideal for all of those jobs.

That is why ASIC flows use several views.

## 5. Liberty (`.lib`)

A Liberty file commonly provides timing and power characterization.

It may describe:

```text
cell delays
transition behavior
setup and hold constraints
input capacitance
power models
operating conditions
```

Timing analysis needs this information.

## 6. LEF (`.lef`)

LEF is an abstract physical view.

For a standard cell, it can describe things such as:

```text
cell dimensions
pin shapes
routing obstructions
placement information
```

LEF is much lighter than full mask geometry, so place-and-route tools can work efficiently.

## 7. GDSII (`.gds`)

GDSII contains detailed layout geometry.

This is the kind of final geometric representation associated with mask-layout data.

A final GDS can be visually impressive, but remember:

```text
having a GDS file does not automatically mean the design is correct
```

Timing, DRC, LVS, antenna, power integrity, integration requirements, and other checks still matter.

## 8. DEF (`.def`)

DEF describes a physical implementation in an exchange format.

It can contain information such as:

```text
die area
rows
placed components
pins
routing
vias
```

Think of it as a structured description of the placed/routed design state.

## 9. SDC (`.sdc`)

SDC contains timing constraints.

A basic clock constraint says something like:

```text
this port is a clock
the desired period is 10 ns
```

Constraints describe what the design must satisfy.

A 10 ns period means:

```text
100 MHz
```

because:

```text
frequency = 1 / period
```

The clock constraint is a requirement.

It is not proof that the design can actually run at that frequency.

## 10. SPEF (`.spef`)

After routing, wires have real physical length and geometry.

Those wires create parasitic:

```text
resistance
capacitance
```

SPEF is a common format for extracted parasitic information.

Post-route timing analysis can use those parasitics to estimate delays more realistically.

## 11. Process, voltage, and temperature

Cell delay changes with conditions.

Designers often discuss:

```text
PVT
```

meaning:

```text
Process
Voltage
Temperature
```

A design that works under one condition may not have identical timing under another.

That is why timing libraries and signoff flows use defined operating corners.

You do not need to master multi-corner signoff yet.

You only need to understand why “the delay of this gate” is not one universal constant.

## 12. The physical-design sequence

The ASIC flow will look approximately like:

```text
RTL
 ↓
lint
 ↓
synthesis
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
routing
 ↓
parasitic extraction
 ↓
static timing analysis
 ↓
physical verification
 ↓
GDSII
```

### Floorplan

Defines physical boundaries, core area, placement rows, and major structural assumptions.

### Power distribution

Creates the network that delivers supply and ground to cells.

### Placement

Chooses physical cell locations.

### Clock tree synthesis

Builds a real buffered clock-distribution network.

### Routing

Connects signal pins with legal metal and vias.

### Extraction

Models wire resistance and capacitance.

### Static timing analysis

Checks timing paths using constraints and delay models.

### Physical verification

Checks whether the layout obeys physical and connectivity rules.

## 13. Why we made `alu_top`

The registered wrapper from Page 8 gives us:

```text
input registers
   ↓
ALU combinational path
   ↓
output registers
```

That makes timing analysis much easier to understand than a purely combinational block with undefined external timing assumptions.

The main setup path will be some version of:

```text
launch flip-flop
   ↓
ALU logic
   ↓
capture flip-flop
```

This is the path you will later inspect in static timing analysis.

## 14. Our process and library

For the introductory ASIC flow, use:

```text
PDK: sky130A
standard-cell library: sky130_fd_sc_hd
```

Do not interpret the `130` in SKY130 as a direct performance comparison to modern leading-edge processors.

The value of SKY130 here is that it gives students an accessible open ecosystem in which the entire physical-design flow can be inspected and reproduced.

## Before continuing

You should be able to explain, at a high level:

- why RTL alone is not enough to fabricate a chip
- what a PDK provides
- what a standard cell is
- the difference between Liberty and LEF
- what GDSII represents
- why routed wires affect timing
- why timing depends on constraints and operating conditions

## References

- SKY130 PDK documentation: https://skywater-pdk.readthedocs.io/
- OpenROAD documentation: https://openroad.readthedocs.io/
- LibreLane documentation: https://librelane.readthedocs.io/
