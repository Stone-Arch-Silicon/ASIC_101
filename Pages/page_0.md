# ASIC 101 — Beginner Track, Open-Source Edition

## Course philosophy

You should not need to arrive knowing Verilog, simulation, synthesis, timing, PDKs, or physical design.

Every page follows the same pattern:

1. **What you are learning**
2. **Why it matters**
3. **Exactly what to type or build**
4. **What you should see**
5. **What can go wrong**
6. **A checklist before moving on**

The project used throughout the course is an **8-bit arithmetic logic unit (ALU)**. It is intentionally small enough that you can understand every signal, verify every possible input combination, synthesize it quickly, and later push it through a complete RTL-to-GDSII ASIC flow.

## Open-source toolchain used in these pages

- **Icarus Verilog** — Verilog compiler and simulator
- **GTKWave** — waveform viewer
- **Yosys** — RTL synthesis
- **Graphviz** — schematic rendering used by Yosys
- **Git** — version control
- **LibreLane** — open-source RTL-to-GDS flow controller
- **OpenROAD** — physical design, timing, placement, clock tree synthesis, routing, and optimization
- **SKY130** — open PDK used for the ASIC implementation
- **KLayout / Magic / Netgen** — layout viewing and physical verification tools used later in the course

For the first ten pages, the easiest installation path is **OSS CAD Suite**, a distribution of open-source digital-design tools maintained by YosysHQ.
