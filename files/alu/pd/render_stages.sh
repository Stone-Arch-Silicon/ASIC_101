#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
# SPDX-License-Identifier: Apache-2.0
#
# Save OpenROAD GUI snapshots of each major stage of a LibreLane run, headless,
# using the same container image LibreLane itself runs in.
#   bash render_stages.sh <run-dir> <output-dir>
set -u
RUN="$(realpath "$1")"
OUT="$(realpath -m "$2")"
mkdir -p "$OUT"
HERE="$(cd "$(dirname "$0")" && pwd)"
IMAGE="ghcr.io/librelane/librelane:${LIBRELANE_VERSION:-3.0.14}"

for step in floorplan tapendcapinsertion generatepdn globalplacement detailedplacement \
            cts globalrouting detailedrouting fillinsertion; do
  dir=$(ls -d "$RUN"/*-openroad-"$step" 2>/dev/null | tail -1)
  [ -n "$dir" ] || continue
  odb=$(ls "$dir"/*.odb 2>/dev/null | head -1)
  [ -n "$odb" ] || continue
  echo "== $step: $odb"
  docker run --rm -u "$(id -u):$(id -g)" -v "$HOME:$HOME" -w "$PWD" \
    -e QT_QPA_PLATFORM=offscreen -e ODB="$odb" -e OUT_PREFIX="$OUT/$step" \
    -e VIEWS="$HERE/render_views.tcl" \
    "$IMAGE" openroad -exit "$HERE/render_stage.tcl" || echo "render failed for $step"
done
ls -la "$OUT"
