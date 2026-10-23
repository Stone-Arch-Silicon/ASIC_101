# Page 12 — Check the hosted ASIC environment in Vulkos

## What you are learning

Vulkos runs LibreLane on managed hardware. You do not install the tools or download a PDK locally for the default ASIC 101 route.

Your job is to establish a known baseline before debugging your ALU.

## 1. Complete the reference quickstart

Open the seeded example project and follow the [Vulkos quickstart](https://www.vulkos.co.uk/docs/quickstart). Review its design, testbench and configuration. Run its verification first, then use **Run** for the physical flow when compute is available.

A successful example shows that this hosted project can complete the flow. It does not prove that your ALU is correct.

If the reference run fails, save the run identifier, failing stage and first useful error. Ask a lead to help distinguish a service/configuration problem from an RTL error before spending more compute.

## 2. Prepare your ALU project

In your ASIC 101 project, create these source files from the work in Pages 7–9:

- `src/adder8.v`
- `src/alu_core.v`
- `src/alu_top.v`

Keep self-checking testbenches in `tb/`. Include only synthesizable source files in the physical configuration. Remove the example counter from the physical file list when switching to the ALU.

If you use the repository's reference RTL, select exactly one `adder8` implementation. RCA, CLA and carry-select files all define the same module and must not be compiled together.

## 3. Confirm the intended environment

For this introductory exercise, use `sky130A` with `sky130_fd_sc_hd`. Confirm these settings against the project's supported template. Record the actual library, process and tool versions shown in run metadata or logs. If a version is unavailable, record that limitation.

The open SKY130 exercise is separate from the club's TSMC 180 nm work. Use only the open course RTL and public process data in this workspace.

## 4. Preserve a baseline

Record the reference project/run, status, date and available environment metadata. Copy the exact ALU RTL and configuration into your project archive. Hosted run outputs have a retention window, so preserve important results before they expire.

## Checkpoint

- [ ] The reference example completes, or I have documented the blocking failure.
- [ ] My ALU sources are under `src/`, with tests under `tb/`.
- [ ] Only one `adder8` implementation is selected.
- [ ] I know the actual PDK/library and have recorded available versions.
- [ ] I can find run history, logs and Analysis.

Continue to [Page 13](page_13.md) for your ALU configuration and first physical run.

## Optional desktop route

A local smoke test, Nix setup and desktop OpenROAD/KLayout are not required for this track. Use the [official LibreLane installation documentation](https://librelane.readthedocs.io/en/stable/installation/) if you choose to reproduce the flow locally or inspect an artifact that the browser does not expose.

## References

- [Vulkos running LibreLane](https://www.vulkos.co.uk/docs/run/running)
- [Vulkos run history](https://www.vulkos.co.uk/docs/projects/run-history)
  
