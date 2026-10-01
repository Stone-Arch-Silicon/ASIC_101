# Page 1 — What are we actually building?

## What you are learning

By the end of this page, you should understand:

- what a digital chip is
- what an ASIC is
- what RTL means
- why simulation and synthesis are different
- what “RTL to GDSII” means
- what you will build during ASIC 101

No prior chip-design knowledge is assumed.

## 1. Start with the physical thing

A modern digital chip contains enormous numbers of **transistors**.

A transistor can be used as an electrically controlled switch. Digital designers usually do not design a processor by drawing millions of transistors one at a time. Instead, we build layers of abstraction:

```text
transistors
    ↓
logic gates
    ↓
registers, adders, muxes
    ↓
datapaths and control
    ↓
processors, accelerators, interfaces
    ↓
complete chips
```

At the beginning of ASIC 101, you work mostly at the **logic** and **RTL** levels.

Later, the physical-design tools translate that logic into actual standard cells, metal wires, vias, and layout geometry.

## 2. Bits and logic

Digital hardware represents information using signals that we usually treat as two logical states:

```text
0
1
```

Physically, those states are represented by voltage ranges. At the RTL level, we normally reason about the logical values instead of the exact analog voltage.

A few basic logic operations are:

```text
AND
OR
XOR
NOT
```

For example:

```text
0 AND 0 = 0
0 AND 1 = 0
1 AND 0 = 0
1 AND 1 = 1
```

A circuit is built by connecting many operations like these.

## 3. What is an ASIC?

**ASIC** stands for **Application-Specific Integrated Circuit**.

An ASIC is a chip whose circuit structure is manufactured into silicon.

Examples of things that may be implemented as ASICs include:

- processors
- AI accelerators
- network switches
- image-processing chips
- storage controllers
- cryptographic accelerators
- mixed-signal controllers
- custom interfaces

The important idea is that after fabrication, the digital logic is physically fixed.

An FPGA is different: its internal logic can be reconfigured after manufacturing.

ASIC 101 is about the ASIC path.

## 4. What is RTL?

RTL means **Register-Transfer Level**.

RTL is a hardware description of:

- combinational logic
- registers
- movement of data between registers
- operations performed on that data
- control behavior

We will write RTL in **Verilog**.

Example:

```verilog
assign y = a & b;
```

This does **not** mean “run an AND instruction.”

It means:

> Create hardware whose output `y` continuously represents the AND of signals `a` and `b`.

That distinction matters.

Verilog can look like software, but synthesizable Verilog describes circuits.

## 5. The complete ASIC flow

The course eventually follows this path:

```text
idea / specification
        ↓
RTL
        ↓
simulation and verification
        ↓
logic synthesis
        ↓
standard-cell netlist
        ↓
floorplanning
        ↓
power distribution
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
DRC / LVS / other checks
        ↓
GDSII
        ↓
fabrication, if submitted to a foundry/shuttle
```

Each stage answers a different question.

### RTL

What circuit do we want?

### Simulation

Does the RTL behave correctly?

### Synthesis

What logic gates and registers implement that RTL?

### Physical design

Where should the cells and wires physically go?

### Signoff checks

Does the final implementation satisfy the required timing and physical rules?

### GDSII

What geometry would be sent toward fabrication?

## 6. Simulation is not synthesis

This is one of the first ideas you should get comfortable with.

A **simulator** executes the behavior described by your HDL so you can test it.

A **synthesis tool** converts synthesizable RTL into a hardware netlist.

For example, a testbench may contain:

```verilog
#10;
$display("hello");
```

That is useful in simulation.

It does not mean we want silicon containing a magical “wait exactly 10 ns and print hello” circuit.

Testbench code and design RTL serve different purposes.

## 7. The ASIC 101 project

You will build an **8-bit ALU**.

An ALU is a circuit that performs operations on binary numbers.

Ours will support:

```text
ADD
SUB
AND
OR
XOR
NOT
SHIFT LEFT
SHIFT RIGHT
```

It will also produce status flags:

```text
zero
negative
carry
overflow
```

The project is intentionally small, but it contains many ideas that appear in larger designs:

- module hierarchy
- arithmetic
- combinational logic
- registers
- clocks
- testbenches
- exhaustive verification
- synthesis
- timing constraints
- standard-cell mapping
- place and route
- physical verification

## 8. What “success” means

At the end of ASIC 101, you should be able to explain the path from:

```text
Verilog source
```

to:

```text
a physically routed layout
```

and you should be able to identify the important intermediate artifacts rather than treating the tools as a black box.

A `.gds` file alone is not the goal.

Understanding how and why it was produced is the goal.

## Before continuing

You should be able to answer:

1. What is the difference between an ASIC and an FPGA?
2. What does RTL describe?
3. What is the difference between simulation and synthesis?
4. What does a physical-design tool add that is not present in RTL?
5. What is the final project in this course?

If those answers are clear, continue to Page 2.

## References

- Yosys documentation: https://yosyshq.readthedocs.io/
- OpenROAD documentation: https://openroad.readthedocs.io/
- LibreLane documentation: https://librelane.readthedocs.io/
