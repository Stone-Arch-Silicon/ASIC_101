#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
# SPDX-License-Identifier: Apache-2.0
#
# Gate-level simulation: run the clocked alu_top testbench against the final
# routed netlist, using the SKY130 standard-cell simulation models.
#   bash gl_sim.sh <run-dir> <log-file>
set -eu
RUN="$1"
LOG="$2"
HERE="$(cd "$(dirname "$0")" && pwd)"
MODELS=$(find "${PDK_ROOT:-$HOME/.ciel}" -path "*sky130A/libs.ref/sky130_fd_sc_hd/verilog" -type d | head -1)
NETLIST=$(ls "$RUN"/final/nl/*.nl.v | head -1)
echo "netlist: $NETLIST"
echo "models:  $MODELS"
iverilog -g2012 -DFUNCTIONAL -DUNIT_DELAY= -o gl_sim.vvp \
  "$HERE/../tb/alu_top_tb.v" "$NETLIST" "$MODELS/primitives.v" "$MODELS/sky130_fd_sc_hd.v"
vvp -n gl_sim.vvp | tee "$LOG"
grep -q "^PASS" "$LOG"
