# ASIC 101: from an 8-bit ALU to GDSII

A hands-on Stone Arch Silicon course built around one design: an **8-bit ALU**. Write RTL, choose an adder architecture, verify the result, implement it on an FPGA, then take the design through an open-source ASIC flow.

**Status:** course material in development. The repository contains 25 lessons; completing the lessons produces a design and an evidence package, not a fabricated or measured chip.

## Start here

1. Read [orientation and prerequisites](Pages/page_1.md).
2. Follow the [project brief](Pages/page_2.md) and [ALU specification](Pages/page_3.md).
3. Choose **one** adder: [ripple carry](Pages/page_4.md), [carry lookahead](Pages/page_5.md), or [carry select](Pages/page_6.md).
4. Rejoin at [verification](Pages/page_7.md), then finish the FPGA track.
5. Continue to the ASIC track at [RTL to GDSII](Pages/page_10.md).

You should know basic Verilog modules, always blocks, and testbenches, and be comfortable with Git and a Linux shell (WSL is fine). The FPGA track uses Vivado and a selected AMD/Xilinx part; programming a physical board is not required. Follow lesson 11 for the ASIC environment.

## Course map

| Stage | Lessons | What you produce |
| --- | --- | --- |
| Orientation | [1: What an ASIC is](Pages/page_1.md), [2: Project brief](Pages/page_2.md) | Project workspace and an understood specification |
| RTL | [3: ALU](Pages/page_3.md), then one of [4: RCA](Pages/page_4.md), [5: CLA](Pages/page_5.md), [6: Carry select](Pages/page_6.md) | ALU RTL with a custom adder |
| Verification | [7: Verify the complete ALU](Pages/page_7.md) | Self-checking testbench and simulation evidence |
| FPGA implementation | [8: Synthesis and implementation](Pages/page_8.md), [9: Analysis and submission](Pages/page_9.md) | Timing, utilization, power estimates, and interpretation |
| ASIC setup | [10: Flow overview](Pages/page_10.md), [11: Toolchain](Pages/page_11.md), [12: PDK](Pages/page_12.md), [13: Baseline run](Pages/page_13.md) | Recorded environment, constraints, and a baseline run |
| Physical design | [14: Synthesis](Pages/page_14.md), [15: Floorplan](Pages/page_15.md), [16: Power](Pages/page_16.md), [17: Placement](Pages/page_17.md), [18: CTS](Pages/page_18.md), [19: Routing](Pages/page_19.md) | Intermediate physical views and stage reports |
| Analysis and signoff | [20: Parasitics and STA](Pages/page_20.md), [21: PPA](Pages/page_21.md), [22: Physical checks](Pages/page_22.md), [23: Inspect the artifacts](Pages/page_23.md) | Evidence for timing, connectivity, and physical-rule checks |
| Capstone | [24: Compare architectures](Pages/page_24.md), [25: Final submission](Pages/page_25.md) | Reproducible comparison and a documented handoff |

## Completion milestones

- **RTL:** the selected adder obeys the common interface; ADD and SUB use it.
- **Verification:** capture the testbench result and failures, with the exact RTL revision. Lesson 7 covers all 524,288 combinations of the combinational ALU inputs.
- **FPGA:** record the target part, constraints, utilization, timing, and power assumptions. FPGA estimates are not ASIC measurements.
- **ASIC:** record the tool and PDK versions, configuration, reports, and final layout. State which checks passed and which remain unresolved.
- **Handoff:** use lesson 25's submission checklist. A hardened block is not a completed tapeout or measured silicon.

## Repository guide

| Path | Purpose |
| --- | --- |
| [Pages/](Pages/) | Lesson Markdown and lesson images |
| [files/](files/) | Supporting course files |
| [Pages/TEMPLATE.md](Pages/TEMPLATE.md) | Starting point for lesson authors |
| [app.js](app.js) | Course configuration, navigation, and Markdown renderer |
| [index.html](index.html), [style.css](style.css) | Static course site |

To preview the site, serve the repository root over HTTP:

```sh
python3 -m http.server 8000
```

Open http://localhost:8000. No package installation or build step is needed for the static site. EDA setup is separate and is documented in the lessons.

## Contributing

Choose a lesson or a reproducibility problem, make one focused change, and explain how you checked it. Preserve existing lesson filenames so inbound links keep working. Use relative links between lesson files and preview both GitHub Markdown and the course site.

When adding technical instructions, include prerequisites, commands, expected results, troubleshooting, and a completion checklist. Add an **Authors and reviewers** section with contributor-approved GitHub handles; do not assign authorship or review credit without their agreement.

Near-term priorities: validate the course from a clean environment; record a reference ALU run; verify internal links and downloads; add lesson ownership and review dates; publish comparable RCA/CLA/carry-select results with identical constraints.

## Related Stone Arch Silicon work

- [Club website and project directory](https://github.com/Stone-Arch-Silicon/stone-arch-silicon)
- [ASIC documentation book](https://github.com/Stone-Arch-Silicon/ASIC-docs)
- [Systolic matrix multiplier](https://github.com/Stone-Arch-Silicon/Mat_Mul_Systolic_Arrays)
- [8-bit posit research documentation](https://github.com/Stone-Arch-Silicon/8-Bit_Posit)

Course contributors are recorded in the [repository history](https://github.com/Stone-Arch-Silicon/ASIC_101/graphs/contributors).
