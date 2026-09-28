# ASIC 101 reference ALU

This folder holds the reference design that all three ASIC 101 tracks share: the 8-bit ALU from the RTL track, the testbenches and proofs from the Verification track, and the LibreLane configuration from the Physical Design track. Every command in the tutorials can be run from here.

Try to write your own version first. Use these files to check your work or to get unstuck.

| Folder | What is in it | Used in |
| --- | --- | --- |
| `rtl/` | `adder8_rca.v`, `adder8_cla.v`, `adder8_csel.v` (three versions of the same `adder8` module), `alu_core.v`, `alu_top.v`, lint waivers | RTL track |
| `tb/` | Verilog testbenches: directed adder tests, the exhaustive ALU test, the clocked scoreboard test | Verification track |
| `cocotb/` | Python testbenches with a reference model, constrained-random stimulus and functional coverage | Verification track |
| `formal/` | SymbiYosys proofs, plus one deliberately broken ALU for the counterexample exercise | Verification track |
| `tt/` | Tiny Tapeout wrapper (`tt_um_sasi_alu`) and its test | RTL and PD tracks |
| `pd/` | LibreLane `config.json` and the scripts the reference CI run uses | PD track |

## Run the checks

You need Icarus Verilog, Verilator, Yosys, SymbiYosys with z3, and Python with cocotb. The setup pages of the RTL and Verification tracks explain how to install them.

```bash
make check              # everything, ripple-carry adder
make check ADDER=cla    # carry-lookahead adder
make check ADDER=csel   # carry-select adder
make sim-alu            # just the exhaustive ALU test
```

The same checks run on every push in `.github/workflows/alu-checks.yml`.

## Run the physical design flow

Inside a LibreLane environment (see the PD track):

```bash
cd pd
librelane config.json
```

`.github/workflows/reference-run.yml` hardens all three adders at several clock periods and publishes the results to the `reference-run` branch. The layout pictures in the PD track come from that run.

## License

The Verilog, Python, Tcl, Makefiles and scripts in this folder are licensed under Apache-2.0. See the repository README for details.
