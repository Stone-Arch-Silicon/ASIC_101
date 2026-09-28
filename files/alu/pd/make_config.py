#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
# SPDX-License-Identifier: Apache-2.0
"""Write a variant of config.json with a different adder and/or clock period.

    python3 make_config.py cla 5.0      ->  config-cla-5.0.json
"""
import json
import pathlib
import sys

here = pathlib.Path(__file__).resolve().parent
adder = sys.argv[1] if len(sys.argv) > 1 else "rca"
period = float(sys.argv[2]) if len(sys.argv) > 2 else 10.0

cfg = json.loads((here / "config.json").read_text())
cfg["VERILOG_FILES"][0] = f"dir::../rtl/adder8_{adder}.v"
cfg["CLOCK_PERIOD"] = period
out = here / f"config-{adder}-{period:g}.json"
out.write_text(json.dumps(cfg, indent=2) + "\n")
print(out.name)
