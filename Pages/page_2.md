# Page 2 — Start ASIC 101 in Vulkos

## Your browser is the lab

Use [Vulkos](https://www.vulkos.co.uk/) for ASIC 101. You do not need to install Linux, WSL, OSS CAD Suite, Nix, or a PDK to start the browser track.

The design work stays the same: write RTL, test it, read synthesis and timing reports, and inspect a layout. Vulkos hosts the tools; you still make and explain the engineering decisions.

## 1. Open a project

1. Open Vulkos and sign in, or create your own account.
2. From the dashboard, create a project called `ASIC 101`, or open the seeded example.
3. Keep the example intact until you have completed the guided quickstart. Do not run a full physical build for every early Verilog exercise.

Use the [official quickstart](https://www.vulkos.co.uk/docs/quickstart) if the interface differs from this guide.

## 2. Know where files go

| Vulkos location | What belongs there |
| --- | --- |
| `src/` | Synthesizable Verilog modules |
| `tb/` | Testbenches, excluded from physical-design sources |
| `config.json` | Top module, source file list, clock and process settings |
| Run history and Analysis | Build status, logs, reports, metrics and layout outputs |

Create files with the explorer's new-file control. The editor autosaves. In the older local examples, `rtl/` corresponds to `src/`, and `sim/` corresponds to `tb/`. Change file references accordingly; the Verilog itself is unchanged.

### What the workspace looks like

![Vulkos example workspace showing the file explorer, Verilog editor and schematic panel](https://www.vulkos.co.uk/images/Landing/IDE.webp)

*Official Vulkos example project. Explorer on the left, RTL editor in the center, analysis below. The pictured adder is a UI example; use the ASIC 101 sources for your lab.* [View full-size screenshot](https://www.vulkos.co.uk/images/Landing/IDE.webp) · [Source: Vulkos](https://www.vulkos.co.uk/)

## 3. Follow the learning sequence

- Pages 3–4: logic and a first Verilog module.
- Pages 5–6: a self-checking testbench and a register.
- Pages 7–9: an adder, the complete ALU, and exhaustive verification.
- Pages 10–11: synthesis, PDKs and standard cells.
- Pages 12–13: the hosted environment and the first ALU physical run.
- Pages 14–25: interpret each stage, compare architectures, and prepare a handoff.

For each exercise, create the named design in `src/` and its testbench in `tb/`. Configure verification for that exercise's DUT and testbench. Do not mix unrelated testbench top modules in one simulation. The exact simulation controls depend on project setup; follow [Vulkos verification documentation](https://www.vulkos.co.uk/docs/ide/testbench), and ask a lead if your project has no verification action.

## 4. Keep an engineering record

For each milestone, save the exact source and configuration, test result, date and available run identifier. Keep copies of important outputs outside the platform before its retention window expires. Record tool/PDK versions from the run when available; write `not exposed by platform` when unavailable rather than guessing.

Check your account's compute allowance before a physical run. This course does not require purchasing a plan; contact a lead if your allocation blocks the next step.

## Checkpoint

- [ ] I can open my Vulkos project and edit a file.
- [ ] I know the difference between `src/` and `tb/`.
- [ ] I know that verification comes before physical implementation.
- [ ] I have somewhere to preserve source, results and screenshots.

## Optional local tools

Local tooling is an advanced alternative, not a prerequisite. The remaining lessons retain local command examples in expandable sections on the course site. Use the [OSS CAD Suite instructions](https://github.com/YosysHQ/oss-cad-suite-build) and [LibreLane installation guide](https://librelane.readthedocs.io/en/stable/installation/) if you deliberately choose that route. Do not run local installation commands for the Vulkos track.

## References

- [Vulkos files and workspace](https://www.vulkos.co.uk/docs/ide/files)
- [Vulkos testbench workflow](https://www.vulkos.co.uk/docs/ide/testbench)
  
