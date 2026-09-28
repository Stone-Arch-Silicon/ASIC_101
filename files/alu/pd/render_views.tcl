# SPDX-FileCopyrightText: 2026 Stone Arch Silicon contributors
# SPDX-License-Identifier: Apache-2.0
#
# Runs inside the OpenROAD GUI (started offscreen by render_stage.tcl) and saves
# several views of the loaded design. A view that does not apply to this stage
# is skipped instead of stopping the script.

proc try {args} {
  if {[catch {uplevel 1 $args} err]} { puts "render_views: skipped '$args' ($err)" }
}

set out $::env(OUT_PREFIX)
set w 1600

try gui::fit
try gui::set_display_controls "Misc/Scale bar" visible true

# 1. Everything the database holds at this stage.
try save_image -width $w ${out}_all.png

# 2. Cells only: hide routing and the power grid.
try gui::set_display_controls "Shape Types/Routing/*" visible false
try gui::set_display_controls "Nets/Power" visible false
try gui::set_display_controls "Nets/Ground" visible false
try save_image -width $w ${out}_cells.png

# 3. Power grid only.
try gui::set_display_controls "Shape Types/Routing/*" visible true
try gui::set_display_controls "Nets/*" visible false
try gui::set_display_controls "Nets/Power" visible true
try gui::set_display_controls "Nets/Ground" visible true
try gui::set_display_controls "Instances/*" visible false
try save_image -width $w ${out}_pdn.png

# 4. Clock network: clock nets, clock buffers and flip-flops.
try gui::set_display_controls "Nets/*" visible false
try gui::set_display_controls "Nets/Clock" visible true
try gui::set_display_controls "Instances/*" visible false
try gui::set_display_controls "Instances/StdCells/Clock tree/*" visible true
try gui::set_display_controls "Instances/StdCells/Sequential" visible true
try save_image -width $w ${out}_clock.png

# 5. Placement density heat map.
try gui::set_display_controls "Instances/*" visible true
try gui::set_display_controls "Heat Maps/Placement Density" visible true
try save_image -width $w ${out}_density.png
try gui::set_display_controls "Heat Maps/Placement Density" visible false

# 6. Routing congestion heat map (only meaningful after global routing).
try gui::set_display_controls "Heat Maps/Routing Congestion" visible true
try save_image -width $w ${out}_congestion.png
try gui::set_display_controls "Heat Maps/Routing Congestion" visible false
