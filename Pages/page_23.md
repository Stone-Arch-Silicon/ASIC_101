# Page 23 — Learn the ASIC file formats and inspect the flow as a timeline

## What you are learning

An ASIC flow produces many files because different tools need different views of the same design.

The goal is not to memorize file extensions in isolation.

The goal is to understand this idea:

```text
one design
→ many representations
→ each representation answers a different engineering need
```

## 1. The most important formats

### RTL Verilog — `.v`

Human-authored behavioral/structural design source.

Example:

```text
rtl/alu_top.v
```

This is your primary design source of truth.

### Gate-level netlist — `.v`, `.nl.v`, `.pnl.v`

Describes connectivity between instantiated cells instead of high-level behavioral RTL.

A physical/power-aware netlist may include explicit supply connections.

### SDC — `.sdc`

**Synopsys Design Constraints** format.

Describes timing intent such as:

```text
clocks
input/output delays
timing exceptions
```

### Liberty — `.lib`

Contains characterized cell information used for timing and often power modeling.

For a standard cell, Liberty can describe relationships such as:

```text
input transition
output load
cell delay
setup/hold constraints
power information
```

### LEF — `.lef`

A physical **abstract** view.

For place-and-route, a cell does not always need every transistor polygon.

It needs key physical information such as:

```text
cell size
pin locations
routing obstructions
```

### DEF — `.def`

Describes an implemented design at the placement/routing level.

It can represent information such as:

```text
die/core area
placed instances
pins
special nets
routing
```

### ODB — `.odb`

OpenROAD/OpenDB database representation.

This is especially useful for reopening an implemented state in OpenROAD.

### SPEF — `.spef`

Extracted parasitic resistance/capacitance information.

Used for post-route electrical/timing analysis.

### SDF — `.sdf`

Standard Delay Format.

Can represent timing delays for back-annotated timing simulation or other downstream use.

### SPICE — `.spice`

Electrical/transistor-level netlist representation.

Useful for circuit-level verification or downstream electrical analysis depending on the view.

### GDSII — `.gds`

Geometric mask-layout representation.

This is the famous “GDS” people refer to near tapeout.

It contains polygons, layers, hierarchy, and physical geometry—not your original Verilog behavior.

## 2. LEF vs GDS

This distinction is especially important.

### LEF asks:

```text
What does place-and-route need to know about this cell/block?
```

It is an abstraction.

### GDS asks:

```text
What is the actual detailed layout geometry?
```

It is much more geometrically complete.

Think:

```text
LEF = physical interface/obstruction abstraction
GDS = detailed mask geometry
```

## 3. DEF vs GDS

DEF is primarily an implementation exchange format for placement/routing information.

GDS is a layout geometry format.

A routed DEF can describe where cells and routes are, while GDS represents the detailed geometry streamed for layout/manufacturing workflows.

They describe related physical reality in different ways.

## 4. Inspect the final view directory

Run:

```bash
cd ~/asic_101/asic
RUN="$(ls -dt runs/*/ | head -1)"

tree -L 2 "$RUN/final"
```

If `tree` is not installed:

```bash
find "$RUN/final" -maxdepth 2 -type f | sort
```

LibreLane's final directory commonly organizes views into directories such as:

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
```

The exact set can vary.

## 5. The run directory is a time machine

Each flow step receives a design state and produces another state.

Conceptually:

```text
state 0: RTL
   ↓ synthesis
state 1: netlist
   ↓ floorplan
state 2: floorplanned database
   ↓ placement
state 3: placed database
   ↓ CTS
state 4: clocked database
   ↓ routing
state 5: routed database
   ↓ extraction/signoff
state 6: final views
```

This means debugging does not have to be:

```text
final result is bad, guess why
```

You can ask:

```text
At what stage did the problem first appear?
```

## 6. Build a stage inventory

Create:

```bash
find "$RUN" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' \
  | sort \
  > ../reports/run_stage_inventory.txt
```

Open the file and annotate major stages in your own notes.

For example:

```text
synthesis
pre-PNR timing
floorplan
PDN
placement
CTS
routing
RC extraction
post-route timing
DRC/LVS
GDS generation
```

## 7. Find every ODB state

Run:

```bash
find "$RUN" -type f -name '*.odb' | sort \
  > ../reports/odb_states.txt
```

This shows how many physical checkpoints the flow created.

You do not need to open every one.

Open at least three representing clearly different stages, for example:

```text
floorplan-ish state
placement/CTS-ish state
final routed state
```

## 8. Create a visual progression

Save screenshots with names that tell a story:

```text
screenshots/01_floorplan.png
screenshots/02_pdn.png
screenshots/03_placement.png
screenshots/04_clock_tree.png
screenshots/05_routing.png
screenshots/06_final_gds.png
```

Then place them in chronological order in your final README/report.

This transforms the course from a pile of reports into a visual explanation of how a chip is constructed.

## 9. Do not infer electrical meaning from GUI color alone

KLayout and OpenROAD assign colors to layers for visualization.

A bright red shape is not “high voltage” because it is red.

A blue layer is not “ground” because it is blue.

Colors are display choices.

Use:

```text
layer names
net names
object properties
PDK documentation
```

for meaning.

## 10. Make a one-page format cheat sheet

Create:

```text
reports/file_format_cheatsheet.md
```

containing your own short definitions for:

```text
RTL
netlist
SDC
Liberty
LEF
DEF
ODB
SPEF
SDF
SPICE
GDSII
```

If you can explain each in one or two sentences, you have the right level of understanding for ASIC 101.

## 11. A useful mental model

Think of the file formats as different questions:

```text
RTL      → what should the logic do?
netlist  → which cells connect to which?
SDC      → what timing must be met?
Liberty  → how do cells behave electrically/timing-wise?
LEF      → what does P&R need to know physically about cells/macros?
DEF/ODB  → where is everything placed/routed right now?
SPEF     → what parasitics did the wires create?
GDS      → what detailed geometry will be handed downstream?
```

That mental model is more useful than memorizing extensions.

## Checkpoint

- [ ] you can explain the major file formats
- [ ] you understand LEF vs GDS
- [ ] you understand DEF/ODB vs RTL/netlist
- [ ] you created a stage inventory
- [ ] you found multiple ODB checkpoints
- [ ] you created a visual progression of the design
- [ ] you created a file-format cheat sheet

## References

- LibreLane architecture/states: https://librelane.readthedocs.io/en/stable/reference/architecture.html
- LibreLane final results: https://librelane.readthedocs.io/en/stable/getting_started/newcomers/
- OpenROAD documentation: https://openroad.readthedocs.io/
