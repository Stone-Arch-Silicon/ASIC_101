# Page 13 — Run your ALU from RTL to GDS in Vulkos

## What you are learning

Make one complete baseline implementation of your verified ALU. Do not optimize yet. LibreLane still coordinates synthesis, placement, routing and checks; Vulkos supplies the hosted workspace and runner.

## 1. Verify the exact source

Open your ASIC 101 project. Run the self-checking ALU testbench using the verification workflow configured for your project. Preserve its output. Fix mismatches before starting physical design.

Keep `adder8.v`, `alu_core.v` and `alu_top.v` under `src/`. Keep testbenches under `tb/`; never put them in `VERILOG_FILES`. Select only one adder implementation.

## 2. Edit the project configuration

Open the root `config.json`. Start from the supported SKY130 template and set the following baseline values in JSON or the guided form. Preserve template fields required by the hosted runner. These values are a course starting point, not a claim of a validated timing-clean result.

```json
{
  "DESIGN_NAME": "alu_top",

  "VERILOG_FILES": [
    "dir::src/adder8.v",
    "dir::src/alu_core.v",
    "dir::src/alu_top.v"
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

## 3. Understand the settings

| Field | Why it matters |
| --- | --- |
| `DESIGN_NAME` | Must match the top-level module `alu_top` exactly |
| `VERILOG_FILES` | Explicit list of synthesizable files; `dir::` resolves relative to `config.json` |
| `CLOCK_PORT` | Uses the wrapper's real `clk` input |
| `CLOCK_PERIOD` | 10 ns is a 100 MHz target, not a measured achievement |
| `PDK` / `STD_CELL_LIBRARY` | Select the process and standard-cell library |
| `DIE_AREA` / `CORE_AREA` | Outer block and inner placement region, in micrometers |
| `FP_CORE_UTIL` / `PL_TARGET_DENSITY_PCT` | Density settings; interpret them with the chosen sizing mode |

The roomy 150 µm square baseline favors inspection over compact area. Compare variants using identical constraints and flow settings.

## 4. Start the physical run

Check your remaining compute allowance. Save the exact configuration and source you intend to build, then click **Run** in the top bar.

Watch the stage status and terminal logs. A failed stage needs diagnosis, not repeated identical runs. Record the first actionable error, fix it, verify again if RTL changed, and start a new run.

You do not need a local `librelane` command or Nix shell.

## 5. Inspect one completed run

Open the completed run's **Analysis** workspace. Inspect:

- Synthesis and area: mapped cell counts and area.
- Timing: setup/hold results and the clock target.
- Power: estimates and their assumptions.
- Signoff: available DRC and LVS results and unresolved checks.

Use the **GDS viewer** for layout and the schematic viewer for connectivity. A successful build or an attractive layout does not establish functional correctness or complete tapeout readiness.

### Recognize the results screens

![Vulkos LibreLane run analysis with timing metrics across process corners](https://www.vulkos.co.uk/images/Landing/Analysis.webp)

*Timing analysis: select a stage on the left, then read its metrics across corners. Values shown belong to Vulkos's published example, not the course ALU.* [View full-size screenshot](https://www.vulkos.co.uk/images/Landing/Analysis.webp) · [Source: Vulkos](https://www.vulkos.co.uk/)

![Vulkos GDS viewer showing an example adder layout and the layer visibility controls](https://www.vulkos.co.uk/images/Landing/GDS.webp)

*GDS viewer: inspect the layout and toggle layers with the controls on the right. This is Vulkos's example adder; your ALU layout will differ.* [View full-size screenshot](https://www.vulkos.co.uk/images/Landing/GDS.webp) · [Source: Vulkos](https://www.vulkos.co.uk/)

## 6. Save your baseline evidence

Preserve the exact RTL, `config.json`, verification log, run identifier/date, available environment versions, metrics and signoff results. Save layout screenshots and download important outputs offered by the platform before retention expires.

If an intermediate ODB/DEF, a detailed report, or an interactive OpenROAD feature is not exposed, mark it unavailable in this hosted run. A lead can provide a reference artifact or the optional desktop exercise. Do not claim a screenshot of final GDS represents an intermediate stage.

## Checkpoint

- [ ] Verification passed for the exact sources used in the run.
- [ ] `DESIGN_NAME`, source paths and clock settings match the RTL.
- [ ] The run completed, or its blocking failure is documented.
- [ ] I can reopen the run and locate Analysis and its layout.
- [ ] I recorded actual timing/signoff status, including failures.
- [ ] I saved source, configuration and baseline evidence.

Continue to [Page 14](page_14.md) to interpret the synthesis result.

## References

- [Vulkos configuration](https://www.vulkos.co.uk/docs/config/librelane)
- [Vulkos run workflow](https://www.vulkos.co.uk/docs/run/running)
- [Vulkos Analysis](https://www.vulkos.co.uk/docs/analysis/overview)
- [Vulkos layout viewer](https://www.vulkos.co.uk/docs/viewers/gds)
  
