#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
# SPDX-License-Identifier: Apache-2.0
"""Copy the interesting parts of a LibreLane run into a small folder that can be
committed: one layout snapshot per major stage, the final views, metrics and the
signoff reports. Used by .github/workflows/reference-run.yml.

    python3 collect_run.py runs/<tag> <output-dir>
"""
import gzip
import json
import os
import pathlib
import re
import shutil
import sys

run = pathlib.Path(sys.argv[1]).resolve()
out = pathlib.Path(sys.argv[2]).resolve()
out.mkdir(parents=True, exist_ok=True)

# stage name in the course  ->  LibreLane step directory suffix
STAGES = [
    ("01-synthesis", "yosys-synthesis"),
    ("02-floorplan", "openroad-floorplan"),
    ("03-tapcells", "openroad-tapendcapinsertion"),
    ("04-pdn", "openroad-generatepdn"),
    ("05-global-placement", "openroad-globalplacement"),
    ("06-detailed-placement", "openroad-detailedplacement"),
    ("07-cts", "openroad-cts"),
    ("08-global-routing", "openroad-globalrouting"),
    ("09-detailed-routing", "openroad-detailedrouting"),
    ("10-fill", "openroad-fillinsertion"),
    ("11-rcx", "openroad-rcx"),
    ("12-sta-post-pnr", "openroad-stapostpnr"),
    ("13-ir-drop", "openroad-irdropreport"),
    ("14-klayout-render", "klayout-render"),
    ("15-magic-drc", "magic-drc"),
    ("16-klayout-drc", "klayout-drc"),
    ("17-lvs", "netgen-lvs"),
    ("18-manufacturability", "misc-reportmanufacturability"),
]

step_dirs = sorted(p for p in run.iterdir() if p.is_dir() and re.match(r"^\d+-", p.name))
(out / "step-directories.txt").write_text("\n".join(p.name for p in step_dirs) + "\n")


def find_step(suffix):
    hits = [p for p in step_dirs if p.name.split("-", 1)[1] == suffix]
    return hits[-1] if hits else None


def copy(src, dst, compress=False):
    dst.parent.mkdir(parents=True, exist_ok=True)
    if compress:
        with open(src, "rb") as fi, gzip.open(str(dst) + ".gz", "wb", compresslevel=9) as fo:
            shutil.copyfileobj(fi, fo)
    else:
        shutil.copy2(src, dst)


manifest = {}
for name, suffix in STAGES:
    step = find_step(suffix)
    if step is None:
        manifest[name] = None
        continue
    manifest[name] = step.name
    dest = out / "stages" / name
    for f in step.iterdir():
        if not f.is_file():
            continue
        if f.suffix in (".def", ".odb"):
            copy(f, dest / f.name, compress=True)
        elif f.suffix in (".rpt", ".log", ".png", ".csv", ".json", ".txt", ".sdc", ".v", ".spef") or f.name == "COMMANDS":
            if f.stat().st_size < 3_000_000:
                copy(f, dest / f.name)
    for sub in ("reports", "nom_tt_025C_1v80", "max_ss_100C_1v60", "min_ff_n40C_1v95"):
        d = step / sub
        if d.is_dir():
            for f in d.rglob("*"):
                if f.is_file() and f.stat().st_size < 3_000_000:
                    copy(f, dest / sub / f.relative_to(d))

final = run / "final"
if final.is_dir():
    for f in final.rglob("*"):
        if not f.is_file():
            continue
        rel = f.relative_to(final)
        if f.suffix in (".gds", ".def", ".odb", ".spef", ".mag", ".sdf"):
            copy(f, out / "final" / rel, compress=True)
        elif f.stat().st_size < 3_000_000:
            copy(f, out / "final" / rel)

for name in ("resolved.json", "error.log", "warning.log", "info.log"):
    if (run / name).exists():
        copy(run / name, out / name)

(out / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
print(json.dumps(manifest, indent=2))
