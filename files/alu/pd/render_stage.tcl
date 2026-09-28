# SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
# SPDX-License-Identifier: Apache-2.0
#
# Headless OpenROAD snapshot of one saved design state.
#   ODB=<state.odb> OUT_PREFIX=<path/prefix> VIEWS=<render_views.tcl> \
#   QT_QPA_PLATFORM=offscreen openroad -exit render_stage.tcl
read_db $::env(ODB)
gui::show "source $::env(VIEWS)" false
