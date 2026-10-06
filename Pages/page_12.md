# Page 12 — Install LibreLane and prove the ASIC environment works

## What you are learning

Before running your own ALU through physical design, make sure the complete open-source ASIC environment works on your machine.

LibreLane provides a reproducible environment containing compatible versions of the tools used by the default flow.

The goal of this page is:

```text
install
→ enter environment
→ run smoke test
→ understand what was verified
```

Do not start debugging your own design until the reference environment itself works.

## 1. Why not install every ASIC tool separately?

You could separately install:

```text
Yosys
OpenROAD
Magic
KLayout
Netgen
OpenRCX
PDK utilities
```

but compatible version combinations matter.

For beginners, that creates unnecessary failure modes.

LibreLane's recommended Nix environment provides a matched, reproducible toolchain.

## 2. Hardware requirements

LibreLane's current Linux documentation lists:

```text
minimum: 8 GiB RAM
recommended: 16 GiB RAM
```

A multicore machine is strongly preferred.

Small designs such as this ALU are much lighter than large chips, but the environment itself still contains substantial EDA software and PDK data.

## 3. Supported environment

For the smoothest course experience, use a recent Ubuntu Linux environment.

Windows students can use WSL2.

LibreLane also supports recent macOS through Nix.

These instructions show the Linux/WSL path.

## 4. Install basic prerequisites

Ubuntu/WSL:

```bash
sudo apt update
sudo apt install -y git curl
```

## 5. Install Nix

Do **not** use Ubuntu's `apt` package for Nix for this course.

Follow LibreLane's official Nix installation documentation:

https://librelane.readthedocs.io/en/stable/installation/nix_installation/

The current LibreLane Linux instructions use the official Nix installer and configure the FOSSi binary cache.

Because installation commands can change, copy the current command from the LibreLane documentation rather than preserving an old command in your notes forever.

After Nix installs:

```text
close the terminal
open a new terminal
```

This ensures the environment changes are loaded.

## 6. Clone LibreLane

Run:

```bash
cd ~
git clone https://github.com/librelane/librelane
```

You should now have:

```text
~/librelane
```

## 7. Enter the LibreLane environment

Run:

```bash
nix-shell ~/librelane/shell.nix
```

The first run may download several gigabytes of tools and dependencies.

Once the shell is ready, commands such as:

```text
librelane
yosys
openroad
klayout
magic
netgen
```

are provided by the environment.

## 8. Run the smoke test

Inside the Nix shell:

```bash
librelane --smoke-test
```

LibreLane's smoke test is specifically intended to confirm that the installation works.

A successful smoke test is much more meaningful than checking only:

```text
does the executable launch?
```

It verifies that the flow can actually run a small design and access the required open PDK environment.

## 9. Record tool versions

Create:

```text
reports/asic_environment.txt
```

from the course project.

You can capture basic environment information with commands such as:

```bash
{
  echo "Date:"
  date
  echo

  echo "LibreLane:"
  librelane --version
  echo

  echo "Yosys:"
  yosys -V
  echo

  echo "OpenROAD:"
  openroad -version
} > ~/asic_101/reports/asic_environment.txt
```

If a particular tool uses a slightly different version flag in your release, run:

```bash
toolname --help
```

and use the documented version option.

The point is to make your run reproducible.

## 10. Why version recording matters

EDA results can change when tools change.

Two people may use the same RTL but get somewhat different:

```text
cell counts
timing
placement
routing
warnings
```

if their tool versions differ.

Recording the environment gives future readers context.

## 11. Prepare the ASIC project area

Inside the ASIC 101 project:

```bash
cd ~/asic_101
mkdir -p asic
```

Your project should now look like:

```text
asic_101/
├── rtl/
│   ├── adder8.v
│   ├── alu_core.v
│   └── alu_top.v
├── sim/
├── scripts/
├── asic/
├── build/
├── reports/
└── screenshots/
```

Do not duplicate the RTL into another directory yet.

Keeping one source of truth reduces the chance that you simulate one version and physically implement a different version.

## 12. What comes next

The next page should create the LibreLane configuration for:

```text
DESIGN_NAME       = alu_top
CLOCK_PORT        = clk
CLOCK_PERIOD      = 10 ns
PDK               = sky130A
STD_CELL_LIBRARY  = sky130_fd_sc_hd
```

and then run a baseline implementation.

From there, the remainder of ASIC 101 should teach each physical stage separately:

```text
13 — Configure and run the first RTL-to-GDS flow
14 — Read the synthesis result and standard-cell netlist
15 — Floorplanning
16 — Power distribution
17 — Placement
18 — Clock tree synthesis
19 — Routing
20 — Parasitics and static timing analysis
21 — Power, performance, and area
22 — DRC, LVS, antenna, and physical verification
23 — Inspect all major ASIC file formats and intermediate states
24 — Compare adder architectures under identical ASIC constraints
25 — Final reproducibility and tapeout-readiness package
```

That preserves the strongest part of the existing curriculum—the stage-by-stage physical-design walkthrough—while making the front half genuinely accessible to someone starting from zero.

## Checkpoint

Do not move on until:

- [ ] Nix is installed using the current LibreLane instructions
- [ ] `~/librelane` exists
- [ ] `nix-shell ~/librelane/shell.nix` works
- [ ] `librelane --smoke-test` succeeds
- [ ] you saved basic tool versions
- [ ] `~/asic_101/asic/` exists
- [ ] your verified RTL from Pages 7–9 is still the same source you will implement

## References

- LibreLane installation: https://librelane.readthedocs.io/en/stable/installation/
- LibreLane Nix installation: https://librelane.readthedocs.io/en/stable/installation/nix_installation/
- LibreLane newcomers tutorial: https://librelane.readthedocs.io/en/stable/getting_started/newcomers/
- OpenROAD documentation: https://openroad.readthedocs.io/
- SKY130 PDK documentation: https://skywater-pdk.readthedocs.io/
