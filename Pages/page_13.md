# Page 13 — Configure and run your first RTL-to-GDS flow

## What you are learning

Until now, your ALU has existed as:

```text
Verilog source
simulation behavior
synthesized logical structure
```

Now you will ask an ASIC flow to create an actual physical implementation using the SKY130 process.

The first goal is intentionally simple:

```text
make one complete baseline run
```

Do not optimize anything yet.

A baseline gives you something concrete to inspect on the next pages.

## 1. What LibreLane is doing for you

You *could* manually invoke every ASIC tool yourself:

```text
Yosys
OpenROAD floorplan
OpenROAD placement
OpenROAD CTS
OpenROAD routing
OpenRCX
OpenSTA
Magic
KLayout
Netgen
...
```

but that would require you to manually pass dozens of files and settings from one program to the next.

LibreLane is a **flow orchestrator**.

Conceptually:

```text
configuration + RTL + PDK
            ↓
        LibreLane
            ↓
ordered sequence of EDA steps
            ↓
final physical implementation + reports
```

LibreLane does not replace Yosys or OpenROAD.

It coordinates them.

## 2. Enter the ASIC environment

Open a terminal and enter the LibreLane Nix environment you installed on Page 12:

```bash
nix-shell ~/librelane/shell.nix
```

Check that the command exists:

```bash
librelane --version
```

Then move to the ASIC configuration directory:

```bash
cd ~/asic_101/asic
```

## 3. Create `config.json`

Create:

```text
~/asic_101/asic/config.json
```

with:

```json
{
  "DESIGN_NAME": "alu_top",

  "VERILOG_FILES": [
    "dir::../rtl/adder8.v",
    "dir::../rtl/alu_core.v",
    "dir::../rtl/alu_top.v"
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

This is deliberately roomy for such a tiny ALU.

We are optimizing for **visibility and learning**, not minimum die area.

## 4. Understand every field before running it

### `DESIGN_NAME`

```json
"DESIGN_NAME": "alu_top"
```

This must match your top-level Verilog module:

```verilog
module alu_top (...);
```

LibreLane needs to know where the design hierarchy begins.

### `VERILOG_FILES`

These are your design source files.

The prefix:

```text
dir::
```

means the path is relative to the directory containing the configuration file.

Because `config.json` is inside:

```text
~/asic_101/asic/
```

then:

```text
dir::../rtl/adder8.v
```

points to:

```text
~/asic_101/rtl/adder8.v
```

This is why we kept a single copy of the RTL.

### `CLOCK_PORT`

```json
"CLOCK_PORT": "clk"
```

This tells the timing and physical-design tools which top-level input is the clock.

A clock is not treated like an ordinary signal.

It receives special timing analysis and, later, a dedicated physical distribution network.

### `CLOCK_PERIOD`

```json
"CLOCK_PERIOD": 10.0
```

LibreLane interprets this in nanoseconds.

Therefore:

```text
period = 10 ns
frequency = 1 / 10 ns = 100 MHz
```

This is a **target constraint**.

It does not mean the design automatically runs at 100 MHz.

The physical implementation must still satisfy timing.

### `PDK`

```json
"PDK": "sky130A"
```

This selects the open SKY130 process configuration used by LibreLane.

### `STD_CELL_LIBRARY`

```json
"STD_CELL_LIBRARY": "sky130_fd_sc_hd"
```

This selects the high-density SKY130 standard-cell library.

Your synthesized gates and registers will be mapped to cells from this library.

### `FP_SIZING`

```json
"FP_SIZING": "absolute"
```

This means we are giving LibreLane explicit physical dimensions rather than asking it to derive the dimensions only from utilization.

### `DIE_AREA`

```json
"DIE_AREA": [0, 0, 150, 150]
```

This describes an outer rectangle in micrometers:

```text
x0 =   0 µm
y0 =   0 µm
x1 = 150 µm
y1 = 150 µm
```

So the block is approximately:

```text
150 µm × 150 µm
```

### `CORE_AREA`

```json
"CORE_AREA": [10, 10, 140, 140]
```

The core is the inner region where the standard-cell rows live.

The 10 µm margin around it leaves space between the core and die boundary.

### `FP_CORE_UTIL`

Core utilization is roughly the fraction of available standard-cell area occupied by cells.

A very dense design can be difficult to route.

A very sparse design uses more area than necessary.

For this tiny educational block we begin conservatively.

### `PL_TARGET_DENSITY_PCT`

This gives the global placer a target placement density.

You do not need to tune it yet.

## 5. Run the flow

From:

```text
~/asic_101/asic
```

run:

```bash
librelane config.json
```

The default flow is the LibreLane **Classic** flow.

You can also write it explicitly:

```bash
librelane --flow Classic config.json
```

## 6. Do not panic when the terminal becomes noisy

ASIC tools print a lot of output.

A normal run may mention stages related to:

```text
lint
synthesis
STA
floorplan
tap/endcap insertion
power distribution
placement
clock tree synthesis
routing
RC extraction
post-route timing
GDS stream-out
DRC
LVS
```

Your first question is not:

```text
Do I understand every log line?
```

Your first question is:

```text
Did the flow complete successfully?
```

Then you inspect it stage by stage.

## 7. Find the run directory

LibreLane places runs underneath the design directory.

After the run:

```bash
ls runs
```

To identify the most recently modified run:

```bash
RUN="$(ls -dt runs/*/ | head -1)"
echo "$RUN"
```

Keep that shell variable for the commands on this page.

## 8. Inspect the stage list

Run:

```bash
find "$RUN" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort
```

You should see many step directories.

The exact numbering can vary.

Look at the **names**.

You should be able to recognize concepts such as:

```text
yosys
floorplan
pdn
placement
cts
routing
sta
magic
klayout
netgen
```

## 9. Find the final views

LibreLane provides a convenient final directory.

Run:

```bash
find "$RUN/final" -maxdepth 2 -type f | sort | head -100
```

You should find physical and logical views such as:

```text
DEF
GDSII
LEF
Liberty
Verilog netlists
ODB
SDC
SDF
SPEF
SPICE
metrics.csv
metrics.json
```

Do not worry about understanding every file yet.

Page 23 will tie the formats together.

## 10. Open the final layout in KLayout

Run:

```bash
librelane --last-run --flow OpenInKLayout config.json
```

If your release expects lowercase flow names, the documented form is also commonly shown as:

```bash
librelane --last-run --flow openinklayout config.json
```

You should see a tiny physical layout made of many colored geometric shapes.

At first it may look like visual noise.

That is okay.

By the end of this course you should be able to point at the major structures and explain what they do.

## 11. Open the design in OpenROAD

Run:

```bash
librelane --last-run --flow OpenInOpenROAD config.json
```

OpenROAD is especially useful for inspecting:

```text
standard cells
nets
clock network
routing
congestion
timing paths
```

KLayout is excellent for geometric layout inspection.

OpenROAD is excellent for understanding the implementation database.

## 12. Save your baseline configuration

Copy the exact configuration used for this first run:

```bash
cp config.json ../reports/baseline_config.json
```

Also record the latest run name:

```bash
basename "$RUN" | tee ../reports/baseline_run_tag.txt
```

## Checkpoint

Do not move on until:

- [ ] `config.json` points to the RTL from Part 1
- [ ] you understand what `CLOCK_PERIOD = 10.0` means
- [ ] you understand the difference between die and core at a high level
- [ ] `librelane config.json` completes successfully
- [ ] you can find the run directory
- [ ] you can find the `final` directory
- [ ] you opened the final design in KLayout
- [ ] you opened the final design in OpenROAD
- [ ] you saved the baseline configuration and run tag

## References

- LibreLane configuration: https://librelane.readthedocs.io/en/stable/reference/configuration/
- LibreLane flow variables: https://librelane.readthedocs.io/en/stable/reference/common_flow_vars.html
- LibreLane newcomers tutorial: https://librelane.readthedocs.io/en/stable/getting_started/newcomers/
