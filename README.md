# ASIC 101: an 8-bit ALU from Verilog to GDS

Stone Arch Silicon’s 25-lesson course now uses **[Vulkos](https://www.vulkos.co.uk/) as the default browser lab**. Write RTL, verify an ALU, run hosted LibreLane on SKY130, and interpret physical-design results without installing the EDA stack locally.

[Open the course](https://stone-arch-silicon.github.io/ASIC_101/#page_1) · [Start the browser lab](Pages/page_2.md) · [First ALU physical run](Pages/page_13.md)

## Workflow

1. Create a Vulkos project; use `src/` for RTL, `tb/` for testbenches and root `config.json` for the physical flow.
2. Work through the Verilog and self-checking verification lessons. The ALU core test exercises all 524,288 input combinations; verify the registered wrapper separately.
3. Follow Pages 12–13 for a hosted reference baseline and your ALU build.
4. Use logs, Analysis, run history and available viewers to interpret synthesis through signoff.
5. Preserve exact source/configuration, test results, run IDs, reports and layout evidence before output retention expires.

Check account compute availability before physical runs. The course does not require purchasing a plan; ask a lead if access or allocation blocks you. Simulation controls and artifact availability depend on project setup. This documentation migration has not yet been validated by a complete signed-in Vulkos ALU run.

## Course map

| Lesson | Topic |
| --- | --- |
| 1 | [What are we actually building?](Pages/page_1.md) |
| 2 | [Start ASIC 101 in Vulkos](Pages/page_2.md) |
| 3 | [Bits, gates, binary numbers, and the two kinds of digital logic](Pages/page_3.md) |
| 4 | [Your first Verilog hardware](Pages/page_4.md) |
| 5 | [Simulation and testbenches from zero](Pages/page_5.md) |
| 6 | [Registers, clocks, and sequential logic](Pages/page_6.md) |
| 7 | [Build an 8-bit adder and learn subtraction](Pages/page_7.md) |
| 8 | [Build the complete 8-bit ALU](Pages/page_8.md) |
| 9 | [Verify the ALU properly](Pages/page_9.md) |
| 10 | [Synthesis with Yosys](Pages/page_10.md) |
| 11 | [From synthesized logic to real silicon: PDKs and standard cells](Pages/page_11.md) |
| 12 | [Check the hosted ASIC environment in Vulkos](Pages/page_12.md) |
| 13 | [Run your ALU from RTL to GDS in Vulkos](Pages/page_13.md) |
| 14 | [Synthesis again, but now with real SKY130 standard cells](Pages/page_14.md) |
| 15 | [Floorplanning: give the circuit a physical home](Pages/page_15.md) |
| 16 | [Power distribution: VDD and ground are physical networks](Pages/page_16.md) |
| 17 | [Placement: decide where every standard cell goes](Pages/page_17.md) |
| 18 | [Clock tree synthesis: distribute time across the chip](Pages/page_18.md) |
| 19 | [Routing: turn logical nets into legal metal and vias](Pages/page_19.md) |
| 20 | [Parasitics and static timing analysis](Pages/page_20.md) |
| 21 | [Power, performance, and area: read the implementation like an engineer](Pages/page_21.md) |
| 22 | [Signoff checks: DRC, LVS, antenna, and “is this layout actually legal?”](Pages/page_22.md) |
| 23 | [Learn the ASIC file formats and inspect the flow as a timeline](Pages/page_23.md) |
| 24 | [Engineering experiment: compare three adder architectures fairly](Pages/page_24.md) |
| 25 | [Final submission: reproducibility, engineering handoff, and tapeout readiness](Pages/page_25.md) |

## Local tooling is optional

The course site labels and collapses local shell/Tcl/Yosys command examples. The older command walkthroughs remain for advanced reproduction. In the browser route, the older `rtl/` and `sim/` paths map to `src/` and `tb/`; update file references accordingly. Local commands use their original local paths.

Vulkos does not necessarily expose every intermediate ODB/DEF, clock-tree or congestion view used in desktop OpenROAD exercises. Record unavailable outputs explicitly; use lead-provided reference artifacts or the optional desktop route for deeper inspection. Never label final GDS as an intermediate-stage screenshot.

## Completion evidence

Preserve RTL and config, self-checking verification output, run status/date/identifier, actual PDK/library and available tool versions, timing/power/area assumptions and units, signoff outcomes, and layout screenshots. State unrun, failed and unavailable checks. A completed flow is not a fabricated chip or a complete tapeout qualification.

## Repository

`Pages/` contains the lessons. `files/alu/` contains reference RTL and optional advanced tooling; select only one `adder8` implementation. `app.js` renders the Markdown and supplies lesson-specific browser workflow guidance. `index.html` and `style.css` form the static site. No site build is required.

For site contributors only, preview with `python3 -m http.server 8000`; students can use the published course directly.

## Sources

- [Vulkos quickstart](https://www.vulkos.co.uk/docs/quickstart)
- [Files and workspace](https://www.vulkos.co.uk/docs/ide/files)
- [Verification](https://www.vulkos.co.uk/docs/ide/testbench)
- [Running LibreLane](https://www.vulkos.co.uk/docs/run/running)
- [Analysis](https://www.vulkos.co.uk/docs/analysis/overview)
- [Run history](https://www.vulkos.co.uk/docs/projects/run-history)

Contributor credit remains in repository history. Preserve lesson URLs when editing; do not assign review credit without agreement.
  
