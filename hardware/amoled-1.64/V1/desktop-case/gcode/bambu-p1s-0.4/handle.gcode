; HEADER_BLOCK_START
; BambuStudio 02.05.00.66
; model printing time: 10m 35s; total estimated time: 17m 47s
; total layer number: 118
; total filament length [mm] : 1007.03
; total filament volume [cm^3] : 2422.19
; total filament weight [g] : 3.17
; filament_density: 1.31,1.26,1.26,1.26,1.26,1.25,1.26,1.26,1.26,1.26,1.26,1.26,1.26,1.26,1.26
; filament_diameter: 1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75
; max_z_height: 23.60
; filament: 1
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; additional_cooling_fan_speed = 70,70,70,70,70,70,70,70,70,70,70,70,70,70,70
; apply_scarf_seam_on_circles = 1
; apply_top_surface_compensation = 0
; auxiliary_fan = 1
; avoid_crossing_wall_includes_support = 0
; bed_custom_model = 
; bed_custom_texture = 
; bed_exclude_area = 0x0,18x0,18x28,0x28
; bed_temperature_formula = by_first_filament
; before_layer_change_gcode = 
; best_object_pos = 0.5,0.5
; bottom_color_penetration_layers = 3
; bottom_shell_layers = 3
; bottom_shell_thickness = 0
; bottom_surface_density = 100%
; bottom_surface_pattern = monotonic
; bridge_angle = 0
; bridge_flow = 1
; bridge_no_support = 0
; bridge_speed = 50
; brim_object_gap = 0.1
; brim_type = auto_brim
; brim_width = 3
; chamber_temperatures = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; change_filament_gcode = ;=P1S 20251031=\nM620 S[next_extruder]A\nM204 S9000\nG1 Z{max_layer_z + 3.0} F1200\n\nG1 X70 F21000\nG1 Y245\nG1 Y265 F3000\nM400\nM106 P1 S0\nM106 P2 S0\n{if old_filament_temp > 142 && next_extruder < 255}\nM104 S[old_filament_temp]\n{endif}\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E-{retraction_distances_when_cut[previous_extruder]} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\n{else}\nM620.11 S0\n{endif}\nM400\nG1 X90 F3000\nG1 Y255 F4000\nG1 X100 F5000\nG1 X120 F15000\nG1 X20 Y50 F21000\nG1 Y-3\n{if toolchange_count == 2}\n; get travel path for change filament\nM620.1 X[travel_point_1_x] Y[travel_point_1_y] F21000 P0\nM620.1 X[travel_point_2_x] Y[travel_point_2_y] F21000 P1\nM620.1 X[travel_point_3_x] Y[travel_point_3_y] F21000 P2\n{endif}\nM620.1 E F{flush_volumetric_speeds[previous_extruder]/2.4053*60} T{flush_temperatures[previous_extruder]}\nT[next_extruder]\nM620.1 E F{flush_volumetric_speeds[next_extruder]/2.4053*60} T{flush_temperatures[next_extruder]}\n\n{if next_extruder < 255}\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E{retraction_distances_when_cut[previous_extruder]} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\nM628 S1\nG92 E0\nG1 E{retraction_distances_when_cut[previous_extruder]} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\nM400\nM629 S1\n{else}\nM620.11 S0\n{endif}\nG92 E0\n{if flush_length_1 > 1}\nM83\n; FLUSH_START\n; always use highest temperature to flush\nM400\n{if filament_type[next_extruder] == "PETG"}\nM109 S260\n{elsif filament_type[next_extruder] == "PVA"}\nM109 S210\n{else}\nM109 S{flush_temperatures[next_extruder]}\n{endif}\n{if flush_length_1 > 23.7}\nG1 E23.7 F{flush_volumetric_speeds[previous_extruder]/2.4053*60} ; do not need pulsatile flushing for start part\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\n{else}\nG1 E{flush_length_1} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\n{endif}\n; FLUSH_END\nG1 E-[old_retract_length_toolchange] F1800\nG1 E[old_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_2 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_3 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_4 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\n; FLUSH_END\n{endif}\n; FLUSH_START\nM400\nM109 S[new_filament_temp]\nG1 E2 F{flush_volumetric_speeds[next_extruder]/2.4053*60} ;Compensate for filament spillage during waiting temperature\n; FLUSH_END\nM400\nG92 E0\nG1 E-[new_retract_length_toolchange] F1800\nM106 P1 S255\nM400 S3\n\nG1 X70 F5000\nG1 X90 F3000\nG1 Y255 F4000\nG1 X105 F5000\nG1 Y265 F5000\nG1 X70 F10000\nG1 X100 F5000\nG1 X70 F10000\nG1 X100 F5000\n\nG1 X70 F10000\nG1 X80 F15000\nG1 X60\nG1 X80\nG1 X60\nG1 X80 ; shake to put down garbage\nG1 X100 F5000\nG1 X165 F15000; wipe and shake\nG1 Y256 ; move Y to aside, prevent collision\nM400\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\nM621 S[next_extruder]A\n
; circle_compensation_manual_offset = 0
; circle_compensation_speed = 200,200,200,200,200,200,200,200,200,200,200,200,200,200,200
; close_fan_the_first_x_layers = 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
; complete_print_exhaust_fan_speed = 70,70,70,70,70,70,70,70,70,70,70,70,70,70,70
; cool_plate_temp = 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
; cool_plate_temp_initial_layer = 35,35,35,35,35,35,35,35,35,35,35,35,35,35,35
; cooling_filter_enabled = 0
; cooling_perimeter_transition_distance = 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
; cooling_slowdown_logic = uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling,uniform_cooling
; counter_coef_1 = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; counter_coef_2 = 0.008,0.008,0.008,0.008,0.008,0.008,0.008,0.008,0.008,0.008,0.008,0.008,0.008,0.008,0.008
; counter_coef_3 = -0.041,-0.041,-0.041,-0.041,-0.041,-0.041,-0.041,-0.041,-0.041,-0.041,-0.041,-0.041,-0.041,-0.041,-0.041
; counter_limit_max = 0.033,0.033,0.033,0.033,0.033,0.033,0.033,0.033,0.033,0.033,0.033,0.033,0.033,0.033,0.033
; counter_limit_min = -0.035,-0.035,-0.035,-0.035,-0.035,-0.035,-0.035,-0.035,-0.035,-0.035,-0.035,-0.035,-0.035,-0.035,-0.035
; curr_bed_type = Textured PEI Plate
; default_acceleration = 10000
; default_filament_colour = ;;;;;;;;;;;;;;
; default_filament_profile = "Bambu PLA Basic @BBL P1S 0.4 nozzle"
; default_jerk = 0
; default_nozzle_volume_type = Standard
; default_print_profile = 0.20mm Standard @BBL X1C
; deretraction_speed = 30
; detect_floating_vertical_shell = 1
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; diameter_limit = 50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
; different_settings_to_system = brim_width;enable_support;support_type;;;;;;;;;;;;;;;;
; draft_shield = disabled
; during_print_exhaust_fan_speed = 70,70,70,70,70,70,70,70,70,70,70,70,70,70,70
; elefant_foot_compensation = 0.15
; embedding_wall_into_infill = 0
; enable_arc_fitting = 1
; enable_circle_compensation = 0
; enable_height_slowdown = 0
; enable_long_retraction_when_cut = 2
; enable_overhang_bridge_fan = 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
; enable_overhang_speed = 1
; enable_pre_heating = 0
; enable_pressure_advance = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; enable_prime_tower = 0
; enable_support = 1
; enable_support_ironing = 0
; enable_tower_interface_features = 0
; enable_wrapping_detection = 0
; enforce_support_layers = 0
; eng_plate_temp = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; eng_plate_temp_initial_layer = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; ensure_vertical_shell_thickness = enabled
; exclude_object = 1
; extruder_ams_count = 1#0|4#0;1#0|4#0
; extruder_clearance_dist_to_rod = 33
; extruder_clearance_height_to_lid = 90
; extruder_clearance_height_to_rod = 34
; extruder_clearance_max_radius = 68
; extruder_colour = #018001
; extruder_max_nozzle_count = 1
; extruder_nozzle_stats = Standard#1
; extruder_offset = 0x2
; extruder_printable_area = 
; extruder_type = Direct Drive
; extruder_variant_list = "Direct Drive Standard,Direct Drive High Flow"
; fan_cooling_layer_time = 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100
; fan_direction = left
; fan_max_speed = 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100
; fan_min_speed = 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100
; filament_adaptive_volumetric_speed = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filament_adhesiveness_category = 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100
; filament_bridge_speed = 25,25,25,25,25,25,25,25,25,25,25,25,25,25,25
; filament_change_length = 10,5,5,5,5,10,5,5,5,5,5,5,5,5,5
; filament_change_length_nc = 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
; filament_colour = #000000;#57D20D;#C0C0C0;#8000FF;#FF8000;#AC95D5;#0080FF;#00FFFF;#FFFF00;#FF0000;#FFFFFF;#FFC1E0;#008000;#000000;#D3B7A7
; filament_colour_type = 0;1;1;1;1;0;1;1;1;1;0;1;1;1;0
; filament_cooling_before_tower = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filament_cost = 25.4,24.99,24.99,24.99,24.99,22.99,24.99,24.99,24.99,24.99,24.99,24.99,24.99,24.99,24.99
; filament_density = 1.31,1.26,1.26,1.26,1.26,1.25,1.26,1.26,1.26,1.26,1.26,1.26,1.26,1.26,1.26
; filament_dev_ams_drying_ams_limitations = 1;0;1;0;1;0;1;0;1;0;1;0;1;0;1;0;1;0;1;0;1;0;1;0;1;0;1;0;1;0
; filament_dev_ams_drying_heat_distortion_temperature = 45,45,45,45,45,45,45,45,45,45,45,45,45,45,45
; filament_dev_ams_drying_temperature = 45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45,45
; filament_dev_ams_drying_time = 12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12
; filament_dev_chamber_drying_bed_temperature = 70,70,70,70,70,70,70,70,70,70,70,70,70,70,70
; filament_dev_chamber_drying_time = 12,12,12,12,12,12,12,12,12,12,12,12,12,12,12
; filament_dev_drying_cooling_temperature = 45,45,45,45,45,45,45,45,45,45,45,45,45,45,45
; filament_dev_drying_softening_temperature = 50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
; filament_diameter = 1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75
; filament_enable_overhang_speed = 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
; filament_end_gcode = "; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n";"; filament end gcode \n\n"
; filament_extruder_variant = "Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard";"Direct Drive Standard"
; filament_flow_ratio = 0.98,0.98,0.98,0.98,0.98,0.98,0.98,0.98,0.98,0.98,0.98,0.98,0.98,0.98,0.98
; filament_flush_temp = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filament_flush_volumetric_speed = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filament_ids = GFL01;GFA00;GFA00;GFA00;GFA00;GFL03;GFA00;GFA00;GFA00;GFA00;GFA00;GFA00;GFA00;GFA00;GFA00
; filament_is_support = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filament_long_retractions_when_cut = nil,1,1,1,1,nil,1,1,1,1,1,1,1,1,1
; filament_map = 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
; filament_map_2 = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filament_map_mode = Auto For Flush
; filament_max_volumetric_speed = 22,21,21,21,21,16,21,21,21,21,21,21,21,21,21
; filament_minimal_purge_on_wipe_tower = 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
; filament_multi_colour = #000000;#57D20D;#C0C0C0;#8000FF;#FF8000;#AC95D5;#0080FF;#00FFFF;#FFFF00;#FF0000;#FFFFFF;#FFC1E0;#008000;#000000;#D3B7A7
; filament_notes = 
; filament_nozzle_map = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filament_overhang_1_4_speed = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filament_overhang_2_4_speed = 50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
; filament_overhang_3_4_speed = 30,30,30,30,30,30,30,30,30,30,30,30,30,30,30
; filament_overhang_4_4_speed = 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
; filament_overhang_totally_speed = 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
; filament_pre_cooling_temperature = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filament_pre_cooling_temperature_nc = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filament_prime_volume = 45,30,30,30,30,45,30,30,30,30,30,30,30,30,30
; filament_prime_volume_nc = 60,60,60,60,60,60,60,60,60,60,60,60,60,60,60
; filament_printable = 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
; filament_ramming_travel_time = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filament_ramming_travel_time_nc = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filament_ramming_volumetric_speed = -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
; filament_ramming_volumetric_speed_nc = -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
; filament_retract_length_nc = 14,14,14,14,14,14,14,14,14,14,14,14,14,14,14
; filament_retraction_distances_when_cut = nil,18,18,18,18,nil,18,18,18,18,18,18,18,18,18
; filament_scarf_gap = 15%,0%,0%,0%,0%,15%,0%,0%,0%,0%,0%,0%,0%,0%,0%
; filament_scarf_height = 10%,10%,10%,10%,10%,10%,10%,10%,10%,10%,10%,10%,10%,10%,10%
; filament_scarf_length = 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
; filament_scarf_seam_type = none,none,none,none,none,none,none,none,none,none,none,none,none,none,none
; filament_self_index = 1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15
; filament_settings_id = "PolyTerra PLA @BBL X1C";"Bambu PLA Basic @BBL P1S 0.4 nozzle";"Bambu PLA Basic @BBL P1S 0.4 nozzle";"Bambu PLA Basic @BBL P1S 0.4 nozzle";"Bambu PLA Basic @BBL P1S 0.4 nozzle";"eSUN PLA+ @BBL X1C";"Bambu PLA Basic @BBL P1S 0.4 nozzle";"Bambu PLA Basic @BBL P1S 0.4 nozzle";"Bambu PLA Basic @BBL P1S 0.4 nozzle";"Bambu PLA Basic @BBL P1S 0.4 nozzle";"Bambu PLA Basic @BBL P1S 0.4 nozzle";"Bambu PLA Basic @BBL P1S 0.4 nozzle";"Bambu PLA Basic @BBL P1S 0.4 nozzle";"Bambu PLA Basic @BBL P1S 0.4 nozzle";"Bambu PLA Basic @BBL P1S 0.4 nozzle"
; filament_shrink = 100%,100%,100%,100%,100%,100%,100%,100%,100%,100%,100%,100%,100%,100%,100%
; filament_soluble = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filament_start_gcode = "; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\nM142 P1 R35 S40\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\nM142 P1 R35 S40\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\nM142 P1 R35 S40\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\nM142 P1 R35 S40\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\nM142 P1 R35 S40\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\nM142 P1 R35 S40\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\nM142 P1 R35 S40\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\nM142 P1 R35 S40\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\nM142 P1 R35 S40\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\nM142 P1 R35 S40\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\nM142 P1 R35 S40\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\nM142 P1 R35 S40\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}";"; filament start gcode\n{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200\n{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150\n{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50\n{endif}\nM142 P1 R35 S40\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}"
; filament_tower_interface_pre_extrusion_dist = 10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
; filament_tower_interface_pre_extrusion_length = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filament_tower_interface_print_temp = -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
; filament_tower_interface_purge_volume = 20,20,20,20,20,20,20,20,20,20,20,20,20,20,20
; filament_tower_ironing_area = 4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
; filament_type = PLA;PLA;PLA;PLA;PLA;PLA;PLA;PLA;PLA;PLA;PLA;PLA;PLA;PLA;PLA
; filament_velocity_adaptation_factor = 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
; filament_vendor = Polymaker;"Bambu Lab";"Bambu Lab";"Bambu Lab";"Bambu Lab";eSUN;"Bambu Lab";"Bambu Lab";"Bambu Lab";"Bambu Lab";"Bambu Lab";"Bambu Lab";"Bambu Lab";"Bambu Lab";"Bambu Lab"
; filament_volume_map = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; filename_format = {input_filename_base}_{filament_type[0]}_{print_time}.gcode
; fill_multiline = 1
; filter_out_gap_fill = 0
; first_layer_print_sequence = 0
; first_x_layer_fan_speed = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; flush_into_infill = 0
; flush_into_objects = 0
; flush_into_support = 1
; flush_multiplier = 1
; flush_volumes_matrix = 0,608,566,495,649,547,565,693,557,515,667,634,420,167,583,158,0,351,294,297,334,287,408,394,292,479,433,160,158,340,123,247,0,296,280,125,289,276,183,294,273,203,200,123,123,151,526,560,0,527,462,391,575,656,372,665,582,369,151,570,170,265,396,307,0,368,300,410,377,195,520,425,229,170,356,201,299,266,297,326,0,316,383,531,339,414,330,263,201,281,159,455,493,299,456,410,0,377,594,297,604,562,220,159,523,177,270,335,312,297,270,194,0,456,310,471,432,234,177,366,183,216,260,321,194,278,314,300,0,319,370,294,244,183,269,153,508,542,294,379,502,412,557,603,0,649,547,216,153,509,143,258,123,327,310,139,320,305,297,325,0,126,214,143,123,170,276,123,297,281,136,312,298,338,271,250,0,242,170,123,123,353,457,256,494,438,396,495,580,344,568,535,0,123,461,123,564,522,451,605,503,521,649,513,471,623,590,376,0,539,149,241,123,301,259,152,294,281,364,276,301,201,211,149,0
; flush_volumes_vector = 140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140,140
; full_fan_speed_layer = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; fuzzy_skin = none
; fuzzy_skin_point_distance = 0.8
; fuzzy_skin_thickness = 0.3
; gap_infill_speed = 250
; gcode_add_line_number = 0
; gcode_flavor = marlin
; grab_length = 0
; group_algo_with_time = 0
; has_scarf_joint_seam = 0
; head_wrap_detect_zone = 
; hole_coef_1 = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; hole_coef_2 = -0.008,-0.008,-0.008,-0.008,-0.008,-0.008,-0.008,-0.008,-0.008,-0.008,-0.008,-0.008,-0.008,-0.008,-0.008
; hole_coef_3 = 0.23415,0.23415,0.23415,0.23415,0.23415,0.23415,0.23415,0.23415,0.23415,0.23415,0.23415,0.23415,0.23415,0.23415,0.23415
; hole_limit_max = 0.22,0.22,0.22,0.22,0.22,0.22,0.22,0.22,0.22,0.22,0.22,0.22,0.22,0.22,0.22
; hole_limit_min = 0.088,0.088,0.088,0.088,0.088,0.088,0.088,0.088,0.088,0.088,0.088,0.088,0.088,0.088,0.088
; host_type = octoprint
; hot_plate_temp = 55,55,55,55,55,55,55,55,55,55,55,55,55,55,55
; hot_plate_temp_initial_layer = 55,55,55,55,55,55,55,55,55,55,55,55,55,55,55
; hotend_cooling_rate = 2
; hotend_heating_rate = 2
; impact_strength_z = 10,13.8,13.8,13.8,13.8,10,13.8,13.8,13.8,13.8,13.8,13.8,13.8,13.8,13.8
; independent_support_layer_height = 1
; infill_combination = 0
; infill_direction = 45
; infill_instead_top_bottom_surfaces = 0
; infill_jerk = 9
; infill_lock_depth = 1
; infill_rotate_step = 0
; infill_shift_step = 0.4
; infill_wall_overlap = 15%
; initial_layer_acceleration = 500
; initial_layer_flow_ratio = 1
; initial_layer_infill_speed = 105
; initial_layer_jerk = 9
; initial_layer_line_width = 0.5
; initial_layer_print_height = 0.2
; initial_layer_speed = 50
; initial_layer_travel_acceleration = 6000
; inner_wall_acceleration = 0
; inner_wall_jerk = 9
; inner_wall_line_width = 0.45
; inner_wall_speed = 300
; interface_shells = 0
; interlocking_beam = 0
; interlocking_beam_layer_count = 2
; interlocking_beam_width = 0.8
; interlocking_boundary_avoidance = 2
; interlocking_depth = 2
; interlocking_orientation = 22.5
; internal_bridge_support_thickness = 0.8
; internal_solid_infill_line_width = 0.42
; internal_solid_infill_pattern = zig-zag
; internal_solid_infill_speed = 250
; ironing_direction = 45
; ironing_flow = 10%
; ironing_inset = 0.21
; ironing_pattern = zig-zag
; ironing_spacing = 0.15
; ironing_speed = 30
; ironing_type = no ironing
; is_infill_first = 0
; layer_change_gcode = ; layer num/total_layer_count: {layer_num+1}/[total_layer_count]\n; update layer progress\nM73 L{layer_num+1}\nM991 S0 P{layer_num} ;notify layer change
; layer_height = 0.2
; line_width = 0.42
; locked_skeleton_infill_pattern = zigzag
; locked_skin_infill_pattern = crosszag
; long_retractions_when_cut = 0
; long_retractions_when_ec = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; machine_end_gcode = ;===== date: 20230428 =====================\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nG1 E-0.8 F1800 ; retract\nG1 Z{max_layer_z + 0.5} F900 ; lower z a little\nG1 X65 Y245 F12000 ; move to safe pos \nG1 Y265 F3000\n\nG1 X65 Y245 F12000\nG1 Y265 F3000\nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\n\nG1 X100 F12000 ; wipe\n; pull back filament to AMS\nM620 S255\nG1 X20 Y50 F12000\nG1 Y-3\nT255\nG1 X65 F12000\nG1 Y265\nG1 X100 F12000 ; wipe\nM621 S255\nM104 S0 ; turn off hotend\n\nM622.1 S1 ; for prev firware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\n    M400 ; wait all motion done\n    M991 S0 P-1 ;end smooth timelapse at safe pos\n    M400 S3 ;wait for last picture to be taken\nM623; end of "timelapse_record_flag"\n\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (max_layer_z + 100.0) < 250}\n    G1 Z{max_layer_z + 100.0} F600\n    G1 Z{max_layer_z +98.0}\n{else}\n    G1 Z250 F600\n    G1 Z248\n{endif}\nM400 P100\nM17 R ; restore z current\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 0\n\nM17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power\n
; machine_hotend_change_time = 0
; machine_load_filament_time = 29
; machine_max_acceleration_e = 5000,5000
; machine_max_acceleration_extruding = 20000,20000
; machine_max_acceleration_retracting = 5000,5000
; machine_max_acceleration_travel = 9000,9000
; machine_max_acceleration_x = 20000,20000
; machine_max_acceleration_y = 20000,20000
; machine_max_acceleration_z = 500,500
; machine_max_jerk_e = 2.5,2.5
; machine_max_jerk_x = 9,9
; machine_max_jerk_y = 9,9
; machine_max_jerk_z = 3,3
; machine_max_speed_e = 30,30
; machine_max_speed_x = 500,500
; machine_max_speed_y = 500,500
; machine_max_speed_z = 20,20
; machine_min_extruding_rate = 0
; machine_min_travel_rate = 0
; machine_pause_gcode = M400 U1
; machine_prepare_compensation_time = 260
; machine_start_gcode = ;===== machine: P1S-0.4 ========================\n;===== date: 20251031 =====================\n;===== turn on the HB fan & MC board fan =================\nM104 S75 ;set extruder temp to turn on the HB fan and prevent filament oozing from nozzle\nM710 A1 S255 ;turn on MC fan by default(P1S)\n;===== reset machine status =================\nM290 X40 Y40 Z2.6666666\nG91\nM17 Z0.4 ; lower the z-motor current\nG380 S2 Z30 F300 ; G380 is same as G38; lower the hotbed , to prevent the nozzle is below the hotbed\nG380 S2 Z-25 F300 ;\nG1 Z5 F300;\nG90\nM17 X1.2 Y1.2 Z0.75 ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 5\nM221 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem\nG29.1 Z{+0.0} ; clear z-trim value first\nM204 S10000 ; init ACC set to 10m/s^2\n\n;===== heatbed preheat ====================\nM1002 gcode_claim_action:54\nM140 S[bed_temperature_initial_layer_single] ;set bed temp\nM190 S[bed_temperature_initial_layer_single] ;wait for bed temp\n\n\n\n;=============turn on fans to prevent PLA jamming=================\n{if filament_type[initial_extruder]=="PLA"}\n    {if (bed_temperature[initial_extruder] >45)||(bed_temperature_initial_layer[initial_extruder] >45)}\n    M106 P3 S180\n    {endif};Prevent PLA from jamming\n{endif}\nM106 P2 S100 ; turn on big fan ,to cool down toolhead\n\n;===== prepare print temperature and material ==========\nM104 S[nozzle_temperature_initial_layer] ;set extruder temp\nG91\nG0 Z10 F1200\nG90\nG28 X\nM975 S1 ; turn on\nG1 X60 F12000\nG1 Y245\nG1 Y265 F3000\nM620 M\nM620 S[initial_extruder]A   ; switch material if AMS exist\n    M109 S[nozzle_temperature_initial_layer]\n    G1 X120 F12000\n\n    G1 X20 Y50 F12000\n    G1 Y-3\n    T[initial_extruder]\n    G1 X54 F12000\n    G1 Y265\n    M400\nM621 S[initial_extruder]A\nM620.1 E F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60} T{flush_temperatures[initial_no_support_extruder]}\n\n\nM412 S1 ; ===turn on filament runout detection===\n\nM109 S250 ;set nozzle to common flush temp\nM106 P1 S0\nG92 E0\nG1 E50 F200\nM400\nM104 S[nozzle_temperature_initial_layer]\nG92 E0\nG1 E50 F200\nM400\nM106 P1 S255\nG92 E0\nG1 E5 F300\nM109 S{nozzle_temperature_initial_layer[initial_extruder]-20} ; drop nozzle temp, make filament shink a bit\nG92 E0\nG1 E-0.5 F300\n\nG1 X70 F9000\nG1 X76 F15000\nG1 X65 F15000\nG1 X76 F15000\nG1 X65 F15000; shake to put down garbage\nG1 X80 F6000\nG1 X95 F15000\nG1 X80 F15000\nG1 X165 F15000; wipe and shake\nM400\nM106 P1 S0\n;===== prepare print temperature and material end =====\n\n\n;===== wipe nozzle ===============================\nM1002 gcode_claim_action : 14\nM975 S1\nM106 S255\nG1 X65 Y230 F18000\nG1 Y264 F6000\nM109 S{nozzle_temperature_initial_layer[initial_extruder]-20}\nG1 X100 F18000 ; first wipe mouth\n\nG0 X135 Y253 F20000  ; move to exposed steel surface edge\nG28 Z P0 T300; home z with low precision,permit 300deg temperature\nG29.2 S0 ; turn off ABL\nG0 Z5 F20000\n\nG1 X60 Y265\nG92 E0\nG1 E-0.5 F300 ; retrack more\nG1 X100 F5000; second wipe mouth\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X90 F5000\nG0 X128 Y261 Z-1.5 F20000  ; move to exposed steel surface and stop the nozzle\nM104 S140 ; set temp down to heatbed acceptable\nM106 S255 ; turn on fan (G28 has turn off fan)\n\nM221 S; push soft endstop status\nM221 Z0 ;turn off Z axis endstop\nG0 Z0.5 F20000\nG0 X125 Y259.5 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y262.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y260.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y262.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y260.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y261.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y261.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 X128\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\n\nM109 S140 ; wait nozzle temp down to heatbed acceptable\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\n\nM221 R; pop softend status\nG1 Z10 F1200\nM400\nG1 Z10\nG1 F30000\nG1 X230 Y15\nG29.2 S1 ; turn on ABL\n;G28 ; home again after hard wipe mouth\nM106 S0 ; turn off fan , too noisy\n;===== wipe nozzle end ================================\n\n\n;===== bed leveling ==================================\nM1002 judge_flag g29_before_print_flag\nM622 J1\n\n    M1002 gcode_claim_action : 1\n    G29 A X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    M400\n    M500 ; save cali data\n\nM623\n;===== bed leveling end ================================\n\n;===== home after wipe mouth============================\nM1002 judge_flag g29_before_print_flag\nM622 J0\n\n    M1002 gcode_claim_action : 13\n    G28\n\nM623\n;===== home after wipe mouth end =======================\n\nM975 S1 ; turn on vibration supression\n\n\n;=============turn on fans to prevent PLA jamming=================\n{if filament_type[initial_extruder]=="PLA"}\n    {if (bed_temperature[initial_extruder] >45)||(bed_temperature_initial_layer[initial_extruder] >45)}\n    M106 P3 S180\n    {endif};Prevent PLA from jamming\n{endif}\nM106 P2 S100 ; turn on big fan ,to cool down toolhead\n\n\nM104 S{nozzle_temperature_initial_layer[initial_extruder]} ; set extrude temp earlier, to reduce wait time\n\n;===== mech mode fast check============================\nG1 X128 Y128 Z10 F20000\nM400 P200\nM970.3 Q1 A7 B30 C80  H15 K0\nM974 Q1 S2 P0\n\nG1 X128 Y128 Z10 F20000\nM400 P200\nM970.3 Q0 A7 B30 C90 Q0 H15 K0\nM974 Q0 S2 P0\n\nM975 S1\nG1 F30000\nG1 X230 Y15\nG28 X ; re-home XY\n;===== fmech mode fast check============================\n\n\n;===== nozzle load line ===============================\nM975 S1\nG90\nM83\nT1000\nG1 X18.0 Y1.0 Z0.8 F18000;Move to start position\nM109 S{nozzle_temperature_initial_layer[initial_extruder]}\nG1 Z0.2\nG0 E2 F300\nG0 X240 E15 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\nG0 Y11 E0.700 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\nG0 X239.5\nG0 E0.2\nG0 Y1.5 E0.700\nG0 X18 E15 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\nM400\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n;curr_bed_type={curr_bed_type}\n{if curr_bed_type=="Textured PEI Plate"}\nG29.1 Z{-0.04} ; for Textured PEI Plate\n{endif}\n;========turn off light and wait extrude temperature =============\nM1002 gcode_claim_action : 0\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off big fan\nM106 P3 S0 ; turn off chamber fan\n\nM975 S1 ; turn on mech mode supression\n
; machine_switch_extruder_time = 0
; machine_unload_filament_time = 28
; master_extruder_id = 1
; max_bridge_length = 0
; max_layer_height = 0.28
; max_travel_detour_distance = 0
; min_bead_width = 85%
; min_feature_size = 25%
; min_layer_height = 0.08
; minimum_sparse_infill_area = 15
; mmu_segmented_region_interlocking_depth = 0
; mmu_segmented_region_max_width = 0
; no_slow_down_for_cooling_on_outwalls = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; nozzle_diameter = 0.4
; nozzle_flush_dataset = 0
; nozzle_height = 4.2
; nozzle_temperature = 220,220,220,220,220,220,220,220,220,220,220,220,220,220,220
; nozzle_temperature_initial_layer = 220,220,220,220,220,220,220,220,220,220,220,220,220,220,220
; nozzle_temperature_range_high = 240,240,240,240,240,240,240,240,240,240,240,240,240,240,240
; nozzle_temperature_range_low = 190,190,190,190,190,190,190,190,190,190,190,190,190,190,190
; nozzle_type = stainless_steel
; nozzle_volume = 107
; nozzle_volume_type = Standard
; only_one_wall_first_layer = 0
; ooze_prevention = 0
; other_layers_print_sequence = 0
; other_layers_print_sequence_nums = 0
; outer_wall_acceleration = 5000
; outer_wall_jerk = 9
; outer_wall_line_width = 0.42
; outer_wall_speed = 200
; overhang_1_4_speed = 0
; overhang_2_4_speed = 50
; overhang_3_4_speed = 30
; overhang_4_4_speed = 10
; overhang_fan_speed = 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100
; overhang_fan_threshold = 50%,50%,50%,50%,50%,50%,50%,50%,50%,50%,50%,50%,50%,50%,50%
; overhang_threshold_participating_cooling = 95%,95%,95%,95%,95%,95%,95%,95%,95%,95%,95%,95%,95%,95%,95%
; overhang_totally_speed = 10
; override_filament_scarf_seam_setting = 0
; override_process_overhang_speed = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; physical_extruder_map = 0
; post_process = 
; pre_start_fan_time = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; precise_outer_wall = 0
; precise_z_height = 0
; pressure_advance = 0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02
; prime_tower_brim_width = 3
; prime_tower_enable_framework = 0
; prime_tower_extra_rib_length = 0
; prime_tower_fillet_wall = 1
; prime_tower_flat_ironing = 0
; prime_tower_infill_gap = 150%
; prime_tower_lift_height = -1
; prime_tower_lift_speed = 90
; prime_tower_max_speed = 90
; prime_tower_rib_wall = 1
; prime_tower_rib_width = 8
; prime_tower_skip_points = 1
; prime_tower_width = 35
; prime_volume_mode = Default
; print_compatible_printers = "Bambu Lab X1 Carbon 0.4 nozzle";"Bambu Lab X1 0.4 nozzle";"Bambu Lab P1S 0.4 nozzle";"Bambu Lab X1E 0.4 nozzle"
; print_extruder_id = 1
; print_extruder_variant = "Direct Drive Standard"
; print_flow_ratio = 1
; print_sequence = by layer
; print_settings_id = 0.20mm Standard @BBL X1C
; printable_area = 0x0,256x0,256x256,0x256
; printable_height = 250
; printer_extruder_id = 1
; printer_extruder_variant = "Direct Drive Standard"
; printer_model = Bambu Lab P1S
; printer_notes = 
; printer_settings_id = Bambu Lab P1S 0.4 nozzle
; printer_structure = corexy
; printer_technology = FFF
; printer_variant = 0.4
; printhost_authorization_type = key
; printhost_ssl_ignore_revoke = 0
; printing_by_object_gcode = 
; process_notes = 
; raft_contact_distance = 0.1
; raft_expansion = 1.5
; raft_first_layer_density = 90%
; raft_first_layer_expansion = -1
; raft_layers = 0
; reduce_crossing_wall = 0
; reduce_fan_stop_start_freq = 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
; reduce_infill_retraction = 1
; required_nozzle_HRC = 3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
; resolution = 0.012
; retract_before_wipe = 0%
; retract_length_toolchange = 2
; retract_lift_above = 0
; retract_lift_below = 249
; retract_restart_extra = 0
; retract_restart_extra_toolchange = 0
; retract_when_changing_layer = 1
; retraction_distances_when_cut = 18
; retraction_distances_when_ec = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; retraction_length = 0.8
; retraction_minimum_travel = 1
; retraction_speed = 30
; role_base_wipe_speed = 1
; scan_first_layer = 0
; scarf_angle_threshold = 155
; seam_gap = 15%
; seam_placement_away_from_overhangs = 0
; seam_position = aligned
; seam_slope_conditional = 1
; seam_slope_entire_loop = 0
; seam_slope_gap = 0
; seam_slope_inner_walls = 1
; seam_slope_min_length = 10
; seam_slope_start_height = 10%
; seam_slope_steps = 10
; seam_slope_type = none
; silent_mode = 0
; single_extruder_multi_material = 1
; skeleton_infill_density = 15%
; skeleton_infill_line_width = 0.45
; skin_infill_density = 15%
; skin_infill_depth = 2
; skin_infill_line_width = 0.45
; skirt_distance = 2
; skirt_height = 1
; skirt_loops = 0
; slice_closing_radius = 0.049
; slicing_mode = regular
; slow_down_for_layer_cooling = 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
; slow_down_layer_time = 4,4,4,4,4,6,4,4,4,4,4,4,4,4,4
; slow_down_min_speed = 20,20,20,20,20,20,20,20,20,20,20,20,20,20,20
; slowdown_end_acc = 100000
; slowdown_end_height = 400
; slowdown_end_speed = 1000
; slowdown_start_acc = 100000
; slowdown_start_height = 0
; slowdown_start_speed = 1000
; small_perimeter_speed = 50%
; small_perimeter_threshold = 0
; smooth_coefficient = 150
; smooth_speed_discontinuity_area = 1
; solid_infill_filament = 0
; sparse_infill_acceleration = 100%
; sparse_infill_anchor = 400%
; sparse_infill_anchor_max = 20
; sparse_infill_density = 15%
; sparse_infill_filament = 0
; sparse_infill_lattice_angle_1 = -45
; sparse_infill_lattice_angle_2 = 45
; sparse_infill_line_width = 0.45
; sparse_infill_pattern = grid
; sparse_infill_speed = 270
; spiral_mode = 0
; spiral_mode_max_xy_smoothing = 200%
; spiral_mode_smooth = 0
; standby_temperature_delta = -5
; start_end_points = 30x-3,54x245
; supertack_plate_temp = 45,45,45,45,45,45,45,45,45,45,45,45,45,45,45
; supertack_plate_temp_initial_layer = 45,45,45,45,45,45,45,45,45,45,45,45,45,45,45
; support_air_filtration = 0
; support_angle = 0
; support_base_pattern = default
; support_base_pattern_spacing = 2.5
; support_bottom_interface_spacing = 0.5
; support_bottom_z_distance = 0.2
; support_chamber_temp_control = 0
; support_cooling_filter = 0
; support_critical_regions_only = 0
; support_expansion = 0
; support_filament = 0
; support_interface_bottom_layers = 2
; support_interface_filament = 0
; support_interface_loop_pattern = 0
; support_interface_not_for_body = 1
; support_interface_pattern = auto
; support_interface_spacing = 0.5
; support_interface_speed = 80
; support_interface_top_layers = 2
; support_ironing_direction = 0
; support_ironing_flow = 10%
; support_ironing_inset = 0
; support_ironing_pattern = zig-zag
; support_ironing_spacing = 0.15
; support_ironing_speed = 30
; support_line_width = 0.42
; support_object_first_layer_gap = 0.2
; support_object_skip_flush = 0
; support_object_xy_distance = 0.35
; support_on_build_plate_only = 0
; support_remove_small_overhang = 1
; support_speed = 150
; support_style = default
; support_threshold_angle = 30
; support_top_z_distance = 0.2
; support_type = tree(manual)
; symmetric_infill_y_axis = 0
; temperature_vitrification = 45,45,45,45,45,45,45,45,45,45,45,45,45,45,45
; template_custom_gcode = 
; textured_plate_temp = 55,55,55,55,55,55,55,55,55,55,55,55,55,55,55
; textured_plate_temp_initial_layer = 55,55,55,55,55,55,55,55,55,55,55,55,55,55,55
; thick_bridges = 0
; thumbnail_size = 50x50
; time_lapse_gcode = ;========Date 20250206========\n; SKIPPABLE_START\n; SKIPTYPE: timelapse\nM622.1 S1 ; for prev firmware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\n{if timelapse_type == 0} ; timelapse without wipe tower\nM971 S11 C10 O0\nM1004 S5 P1  ; external shutter\n{elsif timelapse_type == 1} ; timelapse with wipe tower\nG92 E0\nG1 X65 Y245 F20000 ; move to safe pos\nG17\nG2 Z{layer_z} I0.86 J0.86 P1 F20000\nG1 Y265 F3000\nM400\nM1004 S5 P1  ; external shutter\nM400 P300\nM971 S11 C11 O0\nG92 E0\nG1 X100 F5000\nG1 Y255 F20000\n{endif}\nM623\n; SKIPPABLE_END
; timelapse_type = 0
; top_area_threshold = 200%
; top_color_penetration_layers = 5
; top_one_wall_type = all top
; top_shell_layers = 5
; top_shell_thickness = 1
; top_solid_infill_flow_ratio = 1
; top_surface_acceleration = 2000
; top_surface_density = 100%
; top_surface_jerk = 9
; top_surface_line_width = 0.42
; top_surface_pattern = monotonicline
; top_surface_speed = 200
; top_z_overrides_xy_distance = 0
; travel_acceleration = 10000
; travel_jerk = 9
; travel_short_distance_acceleration = 250
; travel_speed = 500
; travel_speed_z = 0
; tree_support_branch_angle = 45
; tree_support_branch_diameter = 2
; tree_support_branch_diameter_angle = 5
; tree_support_branch_distance = 5
; tree_support_wall_count = -1
; upward_compatible_machine = "Bambu Lab P1P 0.4 nozzle";"Bambu Lab X1 0.4 nozzle";"Bambu Lab X1 Carbon 0.4 nozzle";"Bambu Lab X1E 0.4 nozzle";"Bambu Lab A1 0.4 nozzle";"Bambu Lab H2D 0.4 nozzle";"Bambu Lab H2D Pro 0.4 nozzle";"Bambu Lab H2S 0.4 nozzle";"Bambu Lab P2S 0.4 nozzle";"Bambu Lab H2C 0.4 nozzle"
; use_firmware_retraction = 0
; use_relative_e_distances = 1
; vertical_shell_speed = 80%
; volumetric_speed_coefficients = "0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0";"0 0 0 0 0 0"
; wall_distribution_count = 1
; wall_filament = 0
; wall_generator = classic
; wall_loops = 2
; wall_sequence = inner wall/outer wall
; wall_transition_angle = 10
; wall_transition_filter_deviation = 25%
; wall_transition_length = 100%
; wipe = 1
; wipe_distance = 2
; wipe_speed = 80%
; wipe_tower_no_sparse_layers = 0
; wipe_tower_rotation_angle = 0
; wipe_tower_x = 165
; wipe_tower_y = 216.972
; wrapping_detection_gcode = 
; wrapping_detection_layers = 20
; wrapping_exclude_area = 
; xy_contour_compensation = 0
; xy_hole_compensation = 0
; z_direction_outwall_speed_continuous = 0
; z_hop = 0.4
; z_hop_types = Auto Lift
; CONFIG_BLOCK_END

; EXECUTABLE_BLOCK_START
M73 P0 R17
M201 X20000 Y20000 Z500 E5000
M203 X500 Y500 Z20 E30
M204 P20000 R5000 T20000
M205 X9.00 Y9.00 Z3.00 E2.50
M106 S0
M106 P2 S0
; FEATURE: Custom
;===== machine: P1S-0.4 ========================
;===== date: 20251031 =====================
;===== turn on the HB fan & MC board fan =================
M104 S75 ;set extruder temp to turn on the HB fan and prevent filament oozing from nozzle
M710 A1 S255 ;turn on MC fan by default(P1S)
;===== reset machine status =================
M290 X40 Y40 Z2.6666666
G91
M17 Z0.4 ; lower the z-motor current
G380 S2 Z30 F300 ; G380 is same as G38; lower the hotbed , to prevent the nozzle is below the hotbed
G380 S2 Z-25 F300 ;
G1 Z5 F300;
G90
M17 X1.2 Y1.2 Z0.75 ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 5
M221 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem
G29.1 Z0 ; clear z-trim value first
M204 S10000 ; init ACC set to 10m/s^2

;===== heatbed preheat ====================
M1002 gcode_claim_action:54
M140 S55 ;set bed temp
M190 S55 ;wait for bed temp



;=============turn on fans to prevent PLA jamming=================

    
    M106 P3 S180
    ;Prevent PLA from jamming

M106 P2 S100 ; turn on big fan ,to cool down toolhead

;===== prepare print temperature and material ==========
M104 S220 ;set extruder temp
G91
G0 Z10 F1200
G90
G28 X
M975 S1 ; turn on
G1 X60 F12000
G1 Y245
G1 Y265 F3000
M620 M
M620 S0A   ; switch material if AMS exist
    M109 S220
    G1 X120 F12000

    G1 X20 Y50 F12000
    G1 Y-3
    T0
    G1 X54 F12000
    G1 Y265
    M400
M621 S0A
M620.1 E F548.788 T240


M412 S1 ; ===turn on filament runout detection===

M109 S250 ;set nozzle to common flush temp
M106 P1 S0
G92 E0
M73 P8 R16
G1 E50 F200
M400
M104 S220
G92 E0
M73 P32 R11
G1 E50 F200
M400
M106 P1 S255
G92 E0
M73 P33 R11
G1 E5 F300
M109 S200 ; drop nozzle temp, make filament shink a bit
G92 E0
M73 P34 R11
G1 E-0.5 F300

M73 P35 R11
G1 X70 F9000
G1 X76 F15000
G1 X65 F15000
G1 X76 F15000
G1 X65 F15000; shake to put down garbage
G1 X80 F6000
G1 X95 F15000
G1 X80 F15000
M73 P36 R11
G1 X165 F15000; wipe and shake
M400
M106 P1 S0
;===== prepare print temperature and material end =====


;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14
M975 S1
M106 S255
G1 X65 Y230 F18000
G1 Y264 F6000
M109 S200
G1 X100 F18000 ; first wipe mouth

G0 X135 Y253 F20000  ; move to exposed steel surface edge
G28 Z P0 T300; home z with low precision,permit 300deg temperature
G29.2 S0 ; turn off ABL
G0 Z5 F20000

G1 X60 Y265
G92 E0
G1 E-0.5 F300 ; retrack more
G1 X100 F5000; second wipe mouth
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X90 F5000
G0 X128 Y261 Z-1.5 F20000  ; move to exposed steel surface and stop the nozzle
M104 S140 ; set temp down to heatbed acceptable
M106 S255 ; turn on fan (G28 has turn off fan)

M221 S; push soft endstop status
M221 Z0 ;turn off Z axis endstop
G0 Z0.5 F20000
G0 X125 Y259.5 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 X128
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300

M109 S140 ; wait nozzle temp down to heatbed acceptable
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000

M221 R; pop softend status
G1 Z10 F1200
M400
G1 Z10
G1 F30000
G1 X230 Y15
G29.2 S1 ; turn on ABL
;G28 ; home again after hard wipe mouth
M106 S0 ; turn off fan , too noisy
;===== wipe nozzle end ================================


;===== bed leveling ==================================
M1002 judge_flag g29_before_print_flag
M622 J1

    M1002 gcode_claim_action : 1
    G29 A X109.449 Y113.603 I37.1843 J25.0998
    M400
    M500 ; save cali data

M623
;===== bed leveling end ================================

;===== home after wipe mouth============================
M1002 judge_flag g29_before_print_flag
M622 J0

    M1002 gcode_claim_action : 13
    G28

M623
;===== home after wipe mouth end =======================

M975 S1 ; turn on vibration supression


;=============turn on fans to prevent PLA jamming=================

    
    M106 P3 S180
    ;Prevent PLA from jamming

M106 P2 S100 ; turn on big fan ,to cool down toolhead


M104 S220 ; set extrude temp earlier, to reduce wait time

;===== mech mode fast check============================
G1 X128 Y128 Z10 F20000
M400 P200
M970.3 Q1 A7 B30 C80  H15 K0
M974 Q1 S2 P0

G1 X128 Y128 Z10 F20000
M400 P200
M970.3 Q0 A7 B30 C90 Q0 H15 K0
M974 Q0 S2 P0

M975 S1
M73 P37 R11
G1 F30000
G1 X230 Y15
G28 X ; re-home XY
;===== fmech mode fast check============================


;===== nozzle load line ===============================
M975 S1
G90
M83
T1000
G1 X18.0 Y1.0 Z0.8 F18000;Move to start position
M109 S220
G1 Z0.2
G0 E2 F300
G0 X240 E15 F6033.27
G0 Y11 E0.700 F1508.32
G0 X239.5
G0 E0.2
G0 Y1.5 E0.700
G0 X18 E15 F6033.27
M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type=Textured PEI Plate

G29.1 Z-0.04 ; for Textured PEI Plate

;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
; MACHINE_START_GCODE_END
; filament start gcode
M106 P3 S150


;VT0
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
G1 E-.8 F1800
; layer num/total_layer_count: 1/118
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
M106 P2 S0
M204 S6000
G1 Z.4 F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X113.532 Y111.855
G1 Z.2
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G2 X112.25 Y119.208 I-.055 J3.779 E.39773
M73 P38 R11
G1 X112.541 Y119.27 E.01105
G1 X112.542 Y118.065 E.04489
G1 X112.807 Y117.802 E.0139
G1 X117.535 Y117.814 E.1761
G1 X117.798 Y118.08 E.01393
M73 P38 R10
G1 X117.785 Y119.691 E.05999
G2 X119.219 Y118.792 I-.881 J-2.998 E.06381
G2 X120.209 Y116.799 I-2.258 J-2.364 E.0846
G3 X120.393 Y115.632 I1.948 J-.291 E.04469
G1 X120.017 Y114.464 E.0457
G2 X116.159 Y112.176 I-3.58 J1.641 E.17773
G2 X114.408 Y111.904 I-1.438 J3.483 E.06661
G3 X113.601 Y111.856 I-.195 J-3.494 E.0302
M204 S6000
G1 X110.225 Y117.105 F30000
G1 F3000
M204 S500
M73 P39 R10
G1 X110.225 Y114.746 E.08785
G3 X110.733 Y113.687 I4.461 J1.487 E.04387
G1 X110.733 Y117.557 E.14416
G2 X111.241 Y118.127 I1.436 J-.768 E.0287
G1 X111.241 Y113.117 E.18663
G3 X111.749 Y112.731 I1.051 J.857 E.02398
G1 X111.749 Y118.513 E.21534
G1 X112.13 Y118.695 E.01576
G1 X112.131 Y117.894 E.02984
G1 X112.256 Y117.769 E.00658
G1 X112.256 Y112.49 E.19664
G3 X112.764 Y112.347 I.549 J.979 E.01983
G1 X112.764 Y117.39 E.18783
G1 X113.272 Y117.391 E.01892
G1 X113.272 Y112.265 E.19092
G3 X113.78 Y112.278 I.137 J4.563 E.01893
G1 X113.78 Y117.393 E.19049
G1 X114.288 Y117.394 E.01892
G1 X114.288 Y112.347 E.188
G3 X114.796 Y112.329 I.291 J1.093 E.01909
G1 X114.796 Y117.395 E.18869
G1 X115.304 Y117.397 E.01892
G1 X115.304 Y112.364 E.18743
M73 P40 R10
G1 X115.811 Y112.506 E.01964
G1 X115.811 Y117.398 E.18221
G1 X116.319 Y117.399 E.01892
G1 X116.319 Y112.579 E.17955
G3 X116.827 Y112.591 I.226 J1.196 E.01906
G1 X116.827 Y117.401 E.17916
G1 X117.335 Y117.402 E.01892
G1 X117.335 Y112.68 E.1759
G3 X117.843 Y112.862 I-.54 J2.299 E.02015
G1 X117.843 Y117.541 E.17426
G1 X118.21 Y117.912 E.01947
G1 X118.202 Y119.064 E.0429
G2 X118.351 Y118.966 I-.1 J-.314 E.00673
G1 X118.351 Y113.142 E.21692
G3 X118.859 Y113.532 I-1.546 J2.535 E.02391
G1 X118.859 Y118.555 E.18706
G2 X119.366 Y117.944 I-1.111 J-1.441 E.02982
G1 X119.366 Y114.147 E.14144
G3 X119.874 Y115.363 I-2.981 J1.959 E.04939
G1 X119.874 Y117.344 E.07378
; WIPE_START
; WIPE_END
G1 E-.8 F1800
M204 S6000
G1 X127.356 Y115.832 Z.6 F30000
G1 X136.634 Y113.958 Z.6
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X136.634 Y117.198 E.12068
G2 X137.142 Y117.983 I2.382 J-.984 E.03502
G1 X137.142 Y113.63 E.16212
G3 X137.649 Y113.152 I1.24 J.809 E.02623
G1 X137.649 Y118.461 E.19775
G1 X137.838 Y118.615 E.00907
G1 X137.837 Y117.964 E.02423
G1 X138.157 Y117.644 E.01689
G1 X138.157 Y112.828 E.17937
G3 X138.665 Y112.599 I.726 J.935 E.02094
G1 X138.665 Y117.459 E.181
G1 X139.173 Y117.46 E.01892
G1 X139.173 Y112.493 E.18502
G3 X139.681 Y112.45 I.354 J1.173 E.01912
G1 X139.681 Y117.462 E.18665
G1 X140.189 Y117.463 E.01892
G1 X140.189 Y112.474 E.18582
G3 X140.697 Y112.604 I-2.343 J10.211 E.01953
G1 X140.697 Y117.464 E.18103
G1 X141.204 Y117.466 E.01892
G1 X141.204 Y112.757 E.17537
G1 X141.712 Y112.617 E.01963
G1 X141.712 Y117.467 E.18065
G1 X142.22 Y117.468 E.01892
G1 X142.22 Y112.571 E.18242
G3 X142.728 Y112.581 I.226 J1.398 E.01902
G1 X142.728 Y117.47 E.18208
G1 X143.236 Y117.471 E.01892
G1 X143.236 Y112.669 E.17887
G1 X143.744 Y112.808 E.01962
G1 X143.744 Y117.805 E.18611
G1 X143.916 Y117.978 E.0091
G1 X143.911 Y119.145 E.04346
G2 X144.252 Y118.982 I-.1 J-.645 E.01427
G1 X144.252 Y113.108 E.21877
G3 X144.759 Y113.505 I-.627 J1.325 E.02422
G1 X144.759 Y118.565 E.18846
G2 X145.267 Y117.969 I-1.06 J-1.417 E.02943
G1 X145.267 Y114.053 E.14583
G3 X145.775 Y115.204 I-2.876 J1.956 E.04713
G1 X145.775 Y117.437 E.08315
M204 S6000
G1 X139.821 Y112.039 F30000
G1 F3000
M204 S500
G3 X141.231 Y112.336 I-.24 J4.646 E.05388
G3 X146.018 Y114.6 I1.17 J3.719 E.21682
G1 X146.362 Y115.708 E.04323
G1 X146.151 Y116.077 E.01584
G3 X145.897 Y117.828 I-4.344 J.264 E.06635
G3 X144.41 Y119.384 I-4.168 J-2.497 E.08083
G1 X143.497 Y119.762 E.0368
G1 X143.504 Y118.147 E.06015
G1 X143.241 Y117.882 E.0139
G1 X138.513 Y117.87 E.1761
G1 X138.248 Y118.134 E.01393
G1 X138.251 Y119.286 E.04289
G3 X139.753 Y112.039 I1.44 J-3.481 E.38801
; WIPE_START
G1 X140.262 Y112.066 E-.19382
G1 X141.231 Y112.336 E-.38225
G1 X141.653 Y112.205 E-.16775
M73 P41 R10
G1 X141.695 Y112.201 E-.01618
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X140.028 Y119.649 Z.6 F30000
G1 X138.272 Y127.495 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X138.303 Y127.472 E.00143
G2 X138.637 Y127.129 I-1.423 J-1.721 E.01785
G2 X139.369 Y125.269 I-2.739 J-2.154 E.07554
G2 X139.57 Y123.924 I-28.028 J-4.859 E.05063
G1 X139.558 Y119.18 E.17672
G1 X142.193 Y119.187 E.09813
G1 X142.174 Y123.905 E.17574
G3 X142.263 Y126.243 I-41.51 J2.744 E.08713
G1 X142.25 Y130.879 E.17269
G3 X142.025 Y132.23 I-3.714 J.076 E.05132
G3 X141.261 Y132.878 I-1.08 J-.499 E.03853
G3 X140.209 Y133.008 I-1.001 J-3.783 E.0396
G1 X115.758 Y132.943 E.9107
G3 X114.483 Y132.717 I-.074 J-3.299 E.04856
G3 X113.857 Y131.915 I.566 J-1.087 E.03911
G3 X113.728 Y130.803 I4.282 J-1.058 E.04179
G1 X113.74 Y126.167 E.17267
G3 X113.841 Y123.83 I41.606 J.627 E.08716
G1 X113.848 Y119.111 E.17573
G1 X116.483 Y119.118 E.09813
G1 X116.446 Y123.863 E.17672
G3 X116.696 Y125.674 I-394.789 J55.49 E.0681
G2 X117.362 Y127.073 I4.176 J-1.13 E.05801
G1 X117.692 Y127.419 E.01783
G2 X118.821 Y127.926 I1.51 J-1.855 E.04661
G2 X119.653 Y128.025 I.793 J-3.094 E.03131
G1 X136.34 Y128.07 E.62152
G2 X137.314 Y127.936 I-.049 J-3.974 E.03669
G1 X137.519 Y127.89 E.00785
G2 X137.917 Y127.728 I-.64 J-2.14 E.01601
G1 X138.222 Y127.528 E.0136
M204 S6000
G1 X137.977 Y127.142 F30000
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X138.011 Y127.12 E.0015
G2 X138.28 Y126.84 I-1.08 J-1.309 E.0145
G2 X138.917 Y125.203 I-2.387 J-1.871 E.06637
G2 X139.112 Y123.894 I-27.259 J-4.737 E.04931
G1 X139.1 Y118.721 E.19266
G1 X142.651 Y118.731 E.13229
G1 X142.631 Y123.896 E.19237
G3 X142.72 Y126.239 I-41.638 J2.747 E.08737
G1 X142.707 Y130.888 E.17315
G3 X142.441 Y132.424 I-4.131 J.074 E.0584
G3 X141.401 Y133.315 I-1.502 J-.702 E.05259
G3 X140.217 Y133.465 I-1.141 J-4.247 E.04459
G1 X115.748 Y133.4 E.91136
G3 X114.278 Y133.128 I-.072 J-3.717 E.05606
G3 X113.418 Y132.046 I.78 J-1.503 E.05305
G3 X113.271 Y130.81 I4.747 J-1.19 E.04647
G1 X113.283 Y126.162 E.17313
G3 X113.384 Y123.818 I41.734 J.625 E.08739
G1 X113.392 Y118.653 E.19237
G1 X113.589 Y118.654 E.00736
G1 X116.943 Y118.662 E.12493
G1 X116.903 Y123.835 E.19266
G3 X117.144 Y125.573 I-445.635 J62.709 E.06534
G2 X117.72 Y126.786 I3.65 J-.988 E.05027
G2 X118.793 Y127.444 I1.381 J-1.047 E.04798
G2 X119.666 Y127.568 I.929 J-3.386 E.03297
G1 X136.329 Y127.613 E.62062
G2 X137.703 Y127.322 I-.045 J-3.607 E.05265
G1 X137.927 Y127.175 E.00997
; WIPE_START
G1 X138.011 Y127.12 E-.03807
G1 X138.28 Y126.84 E-.14762
G1 X138.513 Y126.498 E-.15728
G1 X138.706 Y126.09 E-.17157
G1 X138.862 Y125.63 E-.18435
G1 X138.883 Y125.471 E-.06109
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X142.005 Y120.291 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50064
G1 F6300
M204 S500
G1 X141.288 Y119.573 E.03787
G1 X140.638 Y119.571 E.02421
G1 X141.798 Y120.731 E.06116
G1 X141.795 Y121.375 E.02405
G1 X139.989 Y119.569 E.09527
G1 X139.947 Y119.569 E.00157
G1 X139.949 Y120.176 E.02264
G1 X141.793 Y122.02 E.09727
G1 X141.79 Y122.665 E.02405
G1 X139.951 Y120.825 E.09705
G1 X139.952 Y121.474 E.0242
G1 X141.788 Y123.31 E.09684
G2 X141.787 Y123.956 I7.709 J.331 E.02413
G1 X139.954 Y122.123 E.09672
G1 X139.955 Y122.772 E.0242
G1 X141.813 Y124.629 E.09798
G1 X141.838 Y125.302 E.02511
G1 X139.957 Y123.421 E.09924
G1 X139.958 Y123.951 E.0198
G1 X139.943 Y124.054 E.00388
G1 X141.864 Y125.975 E.1013
G3 X141.873 Y126.632 I-8.086 J.444 E.0245
G1 X139.862 Y124.62 E.10608
G1 X139.781 Y125.186 E.02133
G1 X141.871 Y127.277 E.11028
G1 X141.87 Y127.923 E.02408
G1 X139.699 Y125.752 E.11448
G1 X139.546 Y126.246 E.01928
G1 X141.868 Y128.568 E.12249
G1 X141.866 Y129.214 E.02408
G1 X139.354 Y126.701 E.13254
G3 X139.117 Y127.112 I-1.512 J-.594 E.01775
G1 X141.865 Y129.86 E.1449
G1 X141.863 Y130.505 E.02408
G1 X138.838 Y127.48 E.15956
G1 X138.512 Y127.802 E.01707
G1 X141.851 Y131.141 E.17611
G3 X141.781 Y131.718 I-3.594 J-.146 E.0217
G1 X138.122 Y128.059 E.19301
G1 X137.666 Y128.25 E.01844
G1 X141.604 Y132.188 E.20771
G3 X141.238 Y132.469 I-.608 J-.412 E.01751
G1 X137.137 Y128.368 E.21633
G3 X136.568 Y128.447 I-.532 J-1.747 E.02149
G1 X140.712 Y132.591 E.21855
G3 X140.093 Y132.619 I-.613 J-6.56 E.02311
G1 X135.931 Y128.457 E.21953
G1 X135.282 Y128.455 E.02421
G1 X139.444 Y132.617 E.21953
G1 X138.795 Y132.616 E.02421
G1 X134.633 Y128.454 E.21953
G1 X133.984 Y128.452 E.02421
G1 X138.146 Y132.614 E.21953
G1 X137.497 Y132.612 E.02421
G1 X133.335 Y128.45 E.21953
G1 X132.686 Y128.449 E.02421
G1 X136.848 Y132.61 E.21953
G1 X136.199 Y132.609 E.02421
G1 X132.037 Y128.447 E.21953
G1 X131.388 Y128.445 E.02421
G1 X135.55 Y132.607 E.21953
G1 X134.901 Y132.605 E.02421
G1 X130.739 Y128.443 E.21953
G1 X130.09 Y128.442 E.02421
G1 X134.252 Y132.604 E.21953
G1 X133.602 Y132.602 E.02421
G1 X129.441 Y128.44 E.21953
G1 X128.792 Y128.438 E.02421
G1 X132.953 Y132.6 E.21953
M73 P42 R10
G1 X132.304 Y132.598 E.02421
G1 X128.142 Y128.436 E.21953
G1 X127.493 Y128.435 E.02421
G1 X131.655 Y132.597 E.21953
G1 X131.006 Y132.595 E.02421
G1 X126.844 Y128.433 E.21953
G1 X126.195 Y128.431 E.02421
G1 X130.357 Y132.593 E.21953
G1 X129.708 Y132.591 E.02421
G1 X125.546 Y128.43 E.21953
G1 X124.897 Y128.428 E.02421
G1 X129.059 Y132.59 E.21953
G1 X128.41 Y132.588 E.02421
G1 X124.248 Y128.426 E.21953
G1 X123.599 Y128.424 E.02421
G1 X127.761 Y132.586 E.21953
G1 X127.112 Y132.585 E.02421
G1 X122.95 Y128.423 E.21953
G1 X122.301 Y128.421 E.02421
G1 X126.463 Y132.583 E.21953
G1 X125.814 Y132.581 E.02421
G1 X121.652 Y128.419 E.21953
G1 X121.003 Y128.417 E.02421
G1 X125.165 Y132.579 E.21953
G1 X124.516 Y132.578 E.02421
G1 X120.354 Y128.416 E.21953
G1 X119.705 Y128.414 E.02421
G1 X123.867 Y132.576 E.21953
G1 X123.218 Y132.574 E.02421
G1 X118.737 Y128.093 E.23637
; WIPE_START
G1 X120.151 Y129.507 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X117.327 Y122.417 Z.6 F30000
G1 X116.294 Y119.825 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X115.975 Y119.505 E.01685
G1 X115.326 Y119.504 E.02421
G1 X116.085 Y120.263 E.04005
G1 X116.08 Y120.905 E.02396
G1 X114.677 Y119.502 E.07403
G1 X114.236 Y119.501 E.01644
G1 X114.236 Y119.708 E.00773
G1 X116.075 Y121.548 E.09704
G1 X116.07 Y122.19 E.02396
G1 X114.235 Y120.355 E.09682
G1 X114.234 Y121.001 E.02411
G1 X116.065 Y122.832 E.09661
G1 X116.06 Y123.475 E.02396
G1 X114.233 Y121.647 E.09639
G1 X114.232 Y122.294 E.02411
G1 X116.094 Y124.156 E.09822
G1 X116.198 Y124.907 E.02828
G1 X114.231 Y122.94 E.10375
G1 X114.23 Y123.587 E.02411
G1 X116.597 Y125.953 E.12483
; WIPE_START
G1 X115.183 Y124.539 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X114.016 Y124.02 Z.6 F30000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X122.569 Y132.573 E.45113
G1 X121.92 Y132.571 E.02421
G1 X114.187 Y124.838 E.4079
G1 X114.16 Y125.458 E.02317
G1 X121.271 Y132.569 E.37508
G1 X120.622 Y132.567 E.02421
G1 X114.133 Y126.079 E.34226
G2 X114.127 Y126.72 I7.914 J.391 E.02394
G1 X119.973 Y132.566 E.30832
G1 X119.324 Y132.564 E.02421
G1 X114.126 Y127.366 E.27418
G1 X114.124 Y128.012 E.02408
G1 X118.675 Y132.562 E.24003
G1 X118.026 Y132.56 E.02421
G1 X114.122 Y128.657 E.20589
G1 X114.121 Y129.303 E.02408
G1 X117.376 Y132.559 E.17174
G1 X116.727 Y132.557 E.02421
G1 X114.119 Y129.948 E.1376
G1 X114.117 Y130.594 E.02408
G1 X116.078 Y132.555 E.10345
G3 X115.416 Y132.54 I-.133 J-8.463 E.02474
G1 X113.919 Y131.043 E.07893
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X115.333 Y132.458 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 2/118
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
M106 S255
M106 P2 S178
; open powerlost recovery
M1003 S1
M204 S10000
G17
G3 Z.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X112.205 Y115.159
G1 Z.4
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
G1 F9000
G3 X113.339 Y114.272 I1.29 J.482 E.04654
G1 X113.341 Y113.852 E.01291
G3 X114.193 Y113.984 I.15 J1.853 E.02675
G3 X115.784 Y114.245 I.528 J1.76 E.05126
G3 X116.301 Y114.139 I.332 J.302 E.01735
G3 X118.297 Y115.447 I.177 J1.905 E.07918
G1 X118.211 Y115.925 E.01492
G3 X117.902 Y117.325 I-2.116 J.267 E.04494
G3 X117.136 Y117.843 I-1.525 J-1.432 E.02863
G1 X115.782 Y117.839 E.04161
G1 X114.988 Y117.447 E.02721
G3 X113.99 Y117.316 I-.246 J-1.988 E.03125
G3 X113.284 Y113.852 I-.508 J-1.701 E.18107
; WIPE_START
G1 X113.704 Y113.857 E-.15948
G1 X114.193 Y113.984 E-.19208
G1 X114.537 Y113.91 E-.13355
G1 X114.964 Y113.918 E-.16243
G1 X115.25 Y113.994 E-.11246
; WIPE_END
G1 E-.04 F1800
G17
G3 Z.8 I-.069 J1.215 P1  F30000
G1 X138.447 Y115.305 Z.8
G1 Z.4
G1 E.8 F1800
G1 F9000
M73 P43 R10
G3 X139.563 Y114.458 I1.274 J.519 E.04519
G1 X139.564 Y114.038 E.01291
G3 X140.76 Y114.37 I.052 J2.134 E.03869
G3 X141.392 Y114.385 I.305 J.446 E.02075
G3 X144.154 Y115.258 I.988 J1.68 E.10031
G2 X144.165 Y116.069 I.892 J.394 E.02571
G3 X142.77 Y117.911 I-1.67 J.184 E.07828
G3 X141.16 Y117.484 I-.365 J-1.869 E.05294
G2 X140.3 Y117.482 I-.433 J1.283 E.02692
G3 X139.508 Y114.038 I-.587 J-1.678 E.18367
; WIPE_START
G1 X139.928 Y114.042 E-.15961
G1 X140.346 Y114.15 E-.16408
G1 X140.76 Y114.37 E-.17817
G1 X141.036 Y114.276 E-.11079
G1 X141.392 Y114.385 E-.14151
G1 X141.407 Y114.38 E-.00583
; WIPE_END
G1 E-.04 F1800
G17
G3 Z.8 I-1.181 J-.294 P1  F30000
G1 X138.273 Y126.96 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16213.044
G1 X138.325 Y126.884 E.00307
G2 X138.64 Y126.159 I-1.91 J-1.258 E.02635
G2 X138.803 Y125.251 I-3.086 J-1.024 E.0307
G3 X138.945 Y123.897 I48.465 J4.386 E.04516
G1 X138.948 Y118.923 E.165
G1 X142.534 Y118.932 E.11894
G1 X142.505 Y130.937 E.39823
G3 X142.257 Y132.392 I-3.945 J.075 E.04922
G3 X141.339 Y133.175 I-1.315 J-.612 E.04129
G3 X140.213 Y133.316 I-1.079 J-4.041 E.03775
G1 X115.752 Y133.251 E.81141
G3 X114.369 Y133 I-.073 J-3.531 E.04697
G3 X113.612 Y132.041 I.685 J-1.319 E.04175
G3 X113.473 Y130.86 I4.541 J-1.132 E.03956
G1 X113.508 Y118.855 E.39823
G1 X117.094 Y118.865 E.11894
G1 X117.071 Y123.839 E.165
G2 X117.254 Y125.663 I746.526 J-73.972 E.06082
G2 X117.671 Y126.832 I4.009 J-.771 E.04131
G2 X119.25 Y127.797 I1.772 J-1.126 E.0636
G1 X119.661 Y127.82 E.01362
G1 X136.334 Y127.864 E.55309
G2 X137.509 Y127.634 I.025 J-2.996 E.03999
G2 X138.09 Y127.183 I-1.094 J-2.009 E.02451
G1 X138.235 Y127.007 E.00758
M204 S250
G1 X137.802 Y126.93 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6969.985
M204 S5000
G1 X137.808 Y126.926 E.00021
G1 F6860.201
G1 X137.993 Y126.681 E.00944
G1 F2880
G1 X138.048 Y126.567 E.00386
G1 F2640
G1 X138.143 Y126.391 E.00617
G1 F2040
G1 X138.264 Y126.045 E.01124
G1 F1440
G1 X138.365 Y125.65 E.01254
G1 F840
G1 X138.413 Y125.212 E.01353
G1 F600
G1 X138.465 Y124.629 E.01799
G1 X138.508 Y124.297 E.01029
G1 X138.553 Y123.876 E.013
G1 X138.553 Y123.276 E.01844
G1 X138.555 Y121.203 E.0637
G1 X138.556 Y118.53 E.08214
G1 F2280
G1 X138.868 Y118.53 E.00958
G1 F7343.921
G1 X139.268 Y118.532 E.01229
G1 F12000
G1 X139.668 Y118.533 E.01229
G1 X142.483 Y118.54 E.08649
G1 X142.883 Y118.541 E.01229
G1 F11990.753
G1 X142.927 Y118.541 E.00134
G1 F11100
G1 X142.914 Y122.888 E.13357
G1 X142.913 Y123.288 E.01229
G1 F10200
G1 X142.911 Y123.888 E.01844
G1 F11100
G1 X142.915 Y124.151 E.00806
G1 F12000
G1 X142.914 Y124.551 E.01229
G1 X142.913 Y125.031 E.01476
G1 X142.897 Y130.945 E.18174
G3 X142.736 Y132.232 I-5.099 J.015 E.03995
G3 X142.06 Y133.248 I-1.894 J-.527 E.03812
G1 X142.04 Y133.266 E.00084
G1 X141.772 Y133.425 E.00958
G3 X141.097 Y133.638 I-1.115 J-2.354 E.02181
G3 X139.62 Y133.707 I-1.131 J-8.433 E.0455
G1 X116.344 Y133.645 E.71521
G3 X114.867 Y133.568 I-.301 J-8.505 E.0455
G3 X114.193 Y133.352 I.455 J-2.567 E.02181
G1 X113.926 Y133.191 E.00958
G1 X113.905 Y133.173 E.00084
G3 X113.235 Y132.154 I1.226 J-1.536 E.03812
G3 X113.081 Y130.866 I4.942 J-1.245 E.03995
G1 X113.097 Y124.952 E.18173
G1 X113.098 Y124.472 E.01475
G1 X113.099 Y124.072 E.01229
G1 F11100
G1 X113.105 Y123.809 E.00808
G1 F10200
G1 X113.106 Y123.209 E.01844
G1 F11100
G1 X113.107 Y122.809 E.01229
G1 X113.117 Y118.462 E.13357
G1 F11990.754
G1 X113.161 Y118.462 E.00134
G1 F12000
G1 X113.561 Y118.463 E.01229
G1 X116.376 Y118.471 E.08649
G1 X116.776 Y118.472 E.01229
G1 F7343.921
G1 X117.176 Y118.473 E.01229
G1 F2280
G1 X117.488 Y118.474 E.00958
G1 F600
G1 X117.485 Y119.074 E.01844
G1 X117.475 Y121.147 E.0637
G1 X117.463 Y123.82 E.08214
G1 X117.506 Y124.241 E.01301
G1 X117.546 Y124.573 E.01029
G1 X117.596 Y125.157 E.018
G1 F840
G1 X117.641 Y125.595 E.01353
G1 F1440
G1 X117.74 Y125.991 E.01254
G1 F2040
G1 X117.859 Y126.337 E.01125
G1 F2640
G1 X117.953 Y126.514 E.00616
G1 F2880
G1 X118.008 Y126.628 E.00387
G1 F6860.789
G1 X118.192 Y126.874 E.00945
G1 F11756.012
G1 X118.39 Y127.057 E.00829
G1 F12000
G1 X118.407 Y127.072 E.00069
G2 X119.298 Y127.407 I1.11 J-1.601 E.02956
G1 X119.672 Y127.428 E.0115
G1 X136.324 Y127.472 E.51168
G2 X137.337 Y127.28 I.036 J-2.577 E.03187
G1 X137.608 Y127.108 E.00989
G1 X137.758 Y126.971 E.00624
; WIPE_START
M204 S10000
G1 X137.808 Y126.926 E-.02545
G1 X137.993 Y126.681 E-.11681
G1 X138.048 Y126.567 E-.04779
G1 X138.143 Y126.391 E-.07632
G1 X138.264 Y126.045 E-.13905
G1 X138.365 Y125.65 E-.15511
G1 X138.413 Y125.212 E-.16735
G1 X138.42 Y125.128 E-.03212
; WIPE_END
G1 E-.04 F1800
G1 X140.62 Y126.053 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.3972
G1 F15000
G1 X140.633 Y125.848 E.00592
G1 X139.405 Y130.111 F30000
; LINE_WIDTH: 0.63404
G1 F11165.245
G2 X139.412 Y130.227 I-.034 J.06 E.01419
G1 X137.229 Y130.564 F30000
; LINE_WIDTH: 0.577753
G1 F12340.313
G1 X137.338 Y130.586 E.00484
; LINE_WIDTH: 0.532678
G1 F13476.058
G1 X137.447 Y130.609 E.00444
; LINE_WIDTH: 0.487603
G1 F14842.051
G1 X137.556 Y130.632 E.00403
; LINE_WIDTH: 0.420387
G1 F15000
G1 X137.664 Y130.655 E.00342
G1 X139.851 Y130.661 E.06727
G1 X139.855 Y129.182 E.04548
G1 X139.238 Y129.687 E.02454
G1 X138.447 Y130.118 E.0277
G1 X137.639 Y130.377 E.02608
; LINE_WIDTH: 0.442528
G1 X137.551 Y130.418 E.00318
; LINE_WIDTH: 0.487603
G1 F14842.051
G1 X137.462 Y130.458 E.00354
; LINE_WIDTH: 0.532678
G1 F13476.058
G1 X137.373 Y130.498 E.0039
; LINE_WIDTH: 0.577753
G1 F12340.313
G1 X137.284 Y130.539 E.00425
G1 X119.654 Y128.212 F30000
; LINE_WIDTH: 0.41999
G1 F15000
G3 X118.296 Y127.927 I.005 J-3.407 E.04292
G3 X117.13 Y126.627 I1.168 J-2.221 E.05484
G1 X116.872 Y125.751 E.02803
G3 X116.679 Y123.848 I229.107 J-24.215 E.0588
G1 X116.7 Y119.256 E.14109
G1 X113.899 Y119.248 E.08606
G1 X113.865 Y130.85 E.3565
G1 X113.923 Y131.641 E.02435
G1 X114.072 Y132.15 E.01629
G1 X114.269 Y132.447 E.01095
G1 X114.545 Y132.646 E.01048
G1 X115.017 Y132.797 E.01519
G1 X115.765 Y132.859 E.02307
G1 X140.202 Y132.924 E.75088
G1 X140.951 Y132.865 E.02308
G1 X141.423 Y132.718 E.01519
G1 X141.701 Y132.52 E.01048
G1 X141.9 Y132.224 E.01095
G1 X142.051 Y131.716 E.01631
G1 X142.113 Y130.926 E.02435
G1 X142.141 Y119.323 E.3565
G1 X139.34 Y119.316 E.08606
G1 X139.336 Y123.928 E.1417
G1 X139.14 Y125.776 E.05711
G1 X138.871 Y126.684 E.02911
G3 X138.377 Y127.468 I-2.418 J-.978 E.02862
G1 X137.928 Y127.837 E.01785
G1 X137.664 Y127.995 E.00946
G3 X136.338 Y128.256 I-1.315 J-3.188 E.04178
G1 X119.714 Y128.212 E.5108
G1 X119.653 Y128.589 F30000
G1 F15000
G3 X118.097 Y128.247 I-.043 J-3.519 E.04938
G1 X117.66 Y127.963 E.01602
G3 X116.768 Y126.733 I2.12 J-2.476 E.04713
G1 X116.51 Y125.858 E.02803
G3 X116.302 Y123.846 I85.145 J-9.843 E.06215
G1 X116.321 Y119.632 E.12948
G1 X114.275 Y119.626 E.06286
G1 X114.242 Y130.837 E.34447
G1 X114.296 Y131.574 E.02268
G1 X114.474 Y132.074 E.01631
G1 X114.637 Y132.247 E.00732
G1 X115.09 Y132.424 E.01496
G1 X115.781 Y132.482 E.02129
G1 X140.188 Y132.547 E.74995
G1 X140.879 Y132.493 E.0213
G1 X141.334 Y132.318 E.01496
G1 X141.498 Y132.146 E.00732
G1 X141.678 Y131.646 E.01632
G1 X141.736 Y130.91 E.02268
G1 X141.763 Y119.699 E.34448
G1 X139.717 Y119.694 E.06286
G1 X139.711 Y123.967 E.1313
G1 X139.515 Y125.816 E.05711
G1 X139.232 Y126.793 E.03126
G3 X137.391 Y128.498 I-2.658 J-1.024 E.07983
G3 X136.337 Y128.633 I-1.222 J-5.343 E.03271
G1 X119.713 Y128.589 E.5108
G1 X119.652 Y128.966 F30000
G1 F15000
G3 X117.898 Y128.567 I-.041 J-3.88 E.05579
G1 X117.404 Y128.24 E.01819
G1 X116.993 Y127.839 E.01765
G1 X116.658 Y127.368 E.01777
G1 X116.406 Y126.839 E.01798
G1 X116.149 Y125.964 E.02803
G3 X115.925 Y123.844 I56.704 J-7.06 E.06551
G1 X115.942 Y120.008 E.11788
G1 X114.651 Y120.004 E.03967
G1 X114.619 Y130.824 E.33245
G1 X114.669 Y131.506 E.02102
G1 X114.821 Y131.915 E.01341
G1 X115.164 Y132.052 E.01135
G1 X115.797 Y132.105 E.01951
G1 X140.174 Y132.17 E.74901
G1 X140.807 Y132.12 E.01952
G1 X141.151 Y131.985 E.01135
G1 X141.306 Y131.577 E.01342
G1 X141.359 Y130.895 E.02101
G1 X141.385 Y120.075 E.33246
G1 X140.094 Y120.072 E.03967
G1 X140.086 Y124.007 E.1209
G1 X139.89 Y125.855 E.05711
G1 X139.594 Y126.901 E.0334
G1 X139.339 Y127.428 E.01798
G1 X139.001 Y127.898 E.01777
G1 X138.588 Y128.297 E.01765
G1 X138.093 Y128.621 E.01819
G1 X137.522 Y128.851 E.01892
G3 X136.336 Y129.01 I-1.143 J-4.028 E.03688
G1 X119.712 Y128.966 E.5108
G1 X119.651 Y129.343 F30000
; LINE_WIDTH: 0.41999
G1 F15000
G1 X118.98 Y129.296 E.02068
G1 X118.335 Y129.154 E.02028
G1 X117.698 Y128.887 E.02121
G1 X117.148 Y128.517 E.02036
G1 X116.691 Y128.065 E.01976
G1 X116.322 Y127.539 E.01974
G1 X116.044 Y126.946 E.02013
G1 X115.787 Y126.071 E.02803
; LINE_WIDTH: 0.444767
G1 X115.728 Y125.812 E.00868
; LINE_WIDTH: 0.49434
G1 F14620.531
G1 X115.67 Y125.554 E.00975
; LINE_WIDTH: 0.536366
G1 F13375.327
G1 X115.611 Y125.295 E.01065
G1 X115.514 Y123.984 E.05287
; LINE_WIDTH: 0.498306
G1 F14493.21
G1 X115.524 Y120.423 E.13213
G1 X115.067 Y120.422 E.01696
G1 X115.066 Y120.65 E.00847
G2 X115.057 Y124.006 I127.843 J2.025 E.12454
; LINE_WIDTH: 0.517918
G1 F13894.81
G1 X115.072 Y124.664 E.02545
; LINE_WIDTH: 0.551773
G1 F12970.36
G1 X115.087 Y125.321 E.02726
; LINE_WIDTH: 0.543915
G1 F13173.785
G1 X115.062 Y125.502 E.00748
; LINE_WIDTH: 0.494345
G1 F14620.368
G1 X115.036 Y125.684 E.00674
; LINE_WIDTH: 0.420111
G1 F15000
G1 X115.011 Y125.865 E.00563
G1 X114.996 Y130.811 E.15201
G1 X115.042 Y131.439 E.01935
G1 X115.1 Y131.636 E.00631
G1 X115.317 Y131.686 E.00685
G1 X115.848 Y131.728 E.01637
G1 X140.16 Y131.793 E.74726
G1 X140.735 Y131.748 E.01775
G1 X140.874 Y131.704 E.00447
G1 X140.935 Y131.475 E.00728
G1 X140.982 Y130.88 E.01835
G1 X140.994 Y125.789 E.15648
; LINE_WIDTH: 0.444772
G1 X140.97 Y125.656 E.00444
; LINE_WIDTH: 0.494335
G1 F14620.693
G1 X140.945 Y125.523 E.00498
; LINE_WIDTH: 0.535677
G1 F13394.029
G1 X140.921 Y125.39 E.00544
G1 X140.958 Y124.075 E.05279
; LINE_WIDTH: 0.498292
G1 F14493.666
G2 X140.967 Y120.491 I-1520.902 J-5.726 E.133
G1 X140.51 Y120.49 E.01695
G1 X140.501 Y124.051 E.13213
; LINE_WIDTH: 0.517905
G1 F13895.176
G1 X140.449 Y124.706 E.02544
; LINE_WIDTH: 0.551755
G1 F12970.807
G1 X140.396 Y125.361 E.02726
; LINE_WIDTH: 0.543899
G1 F13174.224
G1 X140.353 Y125.539 E.00748
; LINE_WIDTH: 0.494335
G1 F14620.693
G1 X140.309 Y125.717 E.00674
; LINE_WIDTH: 0.420191
G1 F15000
G3 X139.955 Y127.01 I-21.192 J-5.114 E.04121
G1 X139.674 Y127.601 E.02013
G1 X139.302 Y128.125 E.01975
G1 X138.842 Y128.575 E.01977
G1 X138.291 Y128.942 E.02037
G1 X137.652 Y129.205 E.02122
G1 X137.006 Y129.344 E.02031
G3 X136.335 Y129.387 I-.813 J-7.338 E.02069
G1 X119.711 Y129.343 E.51107
G1 X119.65 Y129.72 F30000
; LINE_WIDTH: 0.419789
G1 F15000
G3 X117.801 Y129.356 I-.013 J-4.817 E.05826
G3 X116.389 Y128.291 I1.793 J-3.844 E.05471
G1 X115.986 Y127.711 E.0217
G1 X115.683 Y127.052 E.02226
G1 X115.384 Y125.986 E.03401
G3 X115.373 Y130.798 I-759.192 J.726 E.14777
G1 X115.411 Y131.316 E.01596
G1 X115.946 Y131.351 E.01645
G1 X140.146 Y131.416 E.74318
G1 X140.564 Y131.383 E.0129
G1 X140.605 Y130.865 E.01596
G3 X140.62 Y126.053 I633.701 J-.439 E.14778
G1 X140.316 Y127.118 E.03402
G1 X140.009 Y127.774 E.02225
G1 X139.603 Y128.353 E.0217
G1 X139.097 Y128.853 E.02186
G1 X138.488 Y129.263 E.02252
G1 X137.783 Y129.559 E.0235
G1 X137.075 Y129.715 E.02226
G3 X136.334 Y129.764 I-.876 J-7.506 E.0228
G1 X119.71 Y129.72 E.51053
G1 X119.649 Y130.097 F30000
; LINE_WIDTH: 0.41999
G1 F15000
G3 X118.412 Y129.956 I.012 J-5.588 E.03835
G1 X117.668 Y129.709 E.02407
G1 X117.069 Y129.384 E.02094
G1 X116.637 Y129.071 E.0164
G1 X116.087 Y128.517 E.02398
G1 X115.759 Y128.057 E.01738
G1 X115.751 Y130.784 E.08382
G1 X115.764 Y130.967 E.00563
G1 X140.214 Y131.032 E.75126
G2 X140.234 Y128.122 I-89.504 J-2.095 E.08943
G1 X139.903 Y128.58 E.01737
G1 X139.351 Y129.132 E.02399
G1 X138.917 Y129.442 E.0164
G1 X138.316 Y129.764 E.02094
G1 X137.571 Y130.007 E.02407
G3 X136.333 Y130.141 I-1.22 J-5.454 E.03834
G1 X119.709 Y130.097 E.5108
G1 X118.75 Y130.505 F30000
; LINE_WIDTH: 0.594282
G1 F11970.373
G1 X118.648 Y130.46 E.00501
; LINE_WIDTH: 0.544484
G1 F13158.846
G1 X118.546 Y130.416 E.00456
; LINE_WIDTH: 0.494687
G1 F14609.325
G1 X118.444 Y130.371 E.00411
; LINE_WIDTH: 0.42043
G1 F15000
G1 X117.536 Y130.062 E.02949
G1 X116.87 Y129.704 E.02327
G3 X116.133 Y129.119 I2.128 J-3.439 E.02902
G1 X116.128 Y130.598 E.04549
M73 P43 R9
G1 X118.315 Y130.603 E.06727
; LINE_WIDTH: 0.444889
G1 X118.409 Y130.582 E.00316
; LINE_WIDTH: 0.494687
G1 F14609.325
G1 X118.503 Y130.561 E.00356
; LINE_WIDTH: 0.544484
G1 F13158.846
G1 X118.598 Y130.54 E.00395
; LINE_WIDTH: 0.594282
G1 F11970.373
G1 X118.692 Y130.518 E.00434
G1 X118.75 Y130.505 F30000
; LINE_WIDTH: 0.6035
G1 F11773.52
G1 X119.132 Y130.522 E.01745
; LINE_WIDTH: 0.553728
G1 F12920.728
G2 X119.648 Y130.541 I.597 J-9.277 E.02149
G1 X136.332 Y130.585 E.69447
G1 X136.895 Y130.573 E.02346
; LINE_WIDTH: 0.59669
G1 F11918.306
G1 X137.141 Y130.56 E.01111
G1 X116.651 Y130.051 F30000
; LINE_WIDTH: 0.63406
G1 F11164.868
G2 X116.658 Y130.167 I-.034 J.06 E.01419
G1 X115.369 Y125.721 F30000
; LINE_WIDTH: 0.39724
G1 F15000
G1 X115.381 Y125.926 E.00592
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X115.369 Y125.721 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 3/118
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
G17
G3 Z.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X112.234 Y115.278
G1 Z.6
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
G1 F9000
G3 X113.293 Y114.357 I1.192 J.302 E.04587
G1 X113.293 Y113.937 E.01291
G3 X114.097 Y114.051 I.175 J1.669 E.02519
G3 X115.492 Y114.154 I.588 J1.54 E.04439
G2 X116.851 Y114.176 I2.994 J-142.286 E.04176
G3 X118.162 Y115.198 I-.502 J1.994 E.05259
G1 X118.099 Y115.306 E.00382
G2 X118.192 Y116.346 I1.355 J.403 E.03286
G3 X117.051 Y117.842 I-1.63 J-.06 E.06162
G1 X115.861 Y117.839 E.03657
G3 X114.865 Y117.249 I1.209 J-3.179 E.03574
G3 X114.104 Y117.152 I-.165 J-1.723 E.02376
G3 X113.237 Y113.937 I-.657 J-1.547 E.17646
; WIPE_START
G1 X113.646 Y113.938 E-.15568
G1 X114.097 Y114.051 E-.17649
G1 X114.51 Y113.952 E-.16126
G1 X114.929 Y113.957 E-.15931
G1 X115.195 Y114.05 E-.10727
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1 I-.068 J1.215 P1  F30000
G1 X138.463 Y115.351 Z1
G1 Z.6
G1 E.8 F1800
G1 F9000
G3 X139.548 Y114.492 I1.243 J.455 E.04472
G1 X139.548 Y114.072 E.01291
G3 X140.833 Y114.482 I.158 J1.723 E.04258
G2 X141.755 Y114.239 I.116 J-1.432 E.02984
G3 X144.015 Y115.027 I.631 J1.825 E.07932
G2 X143.882 Y115.67 I1.501 J.645 E.02031
G3 X144.111 Y116.389 I-1.858 J.986 E.02332
G3 X143.563 Y117.54 I-2.356 J-.415 E.03965
G3 X141.043 Y117.409 I-1.177 J-1.655 E.08365
G1 X140.518 Y117.366 E.01621
G3 X139.492 Y114.071 I-.805 J-1.557 E.18804
; WIPE_START
G1 X140.036 Y114.088 E-.20691
G1 X140.324 Y114.173 E-.11429
G1 X140.833 Y114.482 E-.22621
G1 X141.37 Y114.423 E-.20521
G1 X141.388 Y114.415 E-.00738
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1 I-1.179 J-.301 P1  F30000
G1 X138.136 Y127.165 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16213.044
G1 X138.317 Y126.866 E.0116
G2 X138.377 Y126.717 I-1.533 J-.699 E.00533
G2 X138.645 Y125.425 I-3.499 J-1.401 E.04401
G2 X138.764 Y123.885 I-50.676 J-4.696 E.05123
G1 X138.773 Y118.922 E.16463
G1 X142.537 Y118.932 E.12486
G1 X142.505 Y130.99 E.4
G3 X142.257 Y132.445 I-3.946 J.075 E.04923
G3 X141.339 Y133.228 I-1.315 J-.612 E.04129
G3 X140.213 Y133.369 I-1.079 J-4.041 E.03775
G1 X115.752 Y133.304 E.81141
G3 X114.368 Y133.053 I-.073 J-3.531 E.04697
G3 X113.611 Y132.094 I.685 J-1.319 E.04175
G3 X113.473 Y130.913 I4.542 J-1.132 E.03956
G1 X113.505 Y118.855 E.4
G1 X117.269 Y118.865 E.12486
G1 X117.252 Y123.828 E.16463
G3 X117.378 Y125.669 I-316.521 J22.746 E.06122
G2 X117.68 Y126.813 I4.086 J-.465 E.03937
G2 X118.859 Y127.776 I1.608 J-.765 E.05218
G2 X119.66 Y127.873 I.768 J-2.981 E.02687
G1 X136.334 Y127.917 E.55309
G2 X137.512 Y127.686 I.024 J-3.001 E.04011
G2 X138.103 Y127.215 I-.728 J-1.519 E.02529
M204 S250
M73 P44 R9
G1 X137.795 Y126.965 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X137.797 Y126.947 E.00057
G2 X138.062 Y126.455 I-1.206 J-.968 E.01728
G1 X138.085 Y126.402 E.00176
G1 X138.147 Y126.153 E.00789
G1 F10977.926
G1 X138.172 Y126.068 E.0027
G1 F9300
G1 X138.237 Y125.681 E.01207
G1 F3900
G1 X138.254 Y125.397 E.00876
G1 F2880
G1 X138.304 Y124.825 E.01762
G1 F2640
G1 X138.372 Y123.871 E.02941
G1 F2400
G1 X138.373 Y123.271 E.01844
G1 F2520
G1 X138.382 Y118.529 E.1457
G1 F3952.789
G1 X138.515 Y118.529 E.0041
G1 F10164.378
G1 X138.915 Y118.53 E.01229
G1 F12000
G1 X139.315 Y118.531 E.01229
G1 X142.93 Y118.541 E.11107
G1 X142.897 Y130.999 E.38279
G3 X142.736 Y132.285 I-5.097 J.015 E.03995
G3 X142.06 Y133.301 I-1.894 J-.527 E.03812
G1 X142.04 Y133.319 E.00083
G1 X141.772 Y133.478 E.00958
G3 X141.097 Y133.691 I-1.115 J-2.354 E.02181
G3 X139.619 Y133.76 I-1.131 J-8.433 E.0455
G1 X116.343 Y133.698 E.71521
G3 X114.867 Y133.622 I-.301 J-8.505 E.0455
G3 X114.193 Y133.405 I.455 J-2.567 E.02181
G1 X113.926 Y133.244 E.00958
G1 X113.905 Y133.226 E.00084
G3 X113.235 Y132.207 I1.226 J-1.536 E.03812
G3 X113.081 Y130.919 I4.943 J-1.246 E.03995
G1 X113.114 Y118.462 E.38279
G1 X116.729 Y118.471 E.11107
G1 X117.129 Y118.472 E.01229
G1 F10164.187
G1 X117.529 Y118.473 E.01229
G1 F3952.669
G1 X117.662 Y118.474 E.0041
G1 F2520
G1 X117.647 Y122.815 E.13341
G1 X117.646 Y123.215 E.01229
G1 F2400
G1 X117.644 Y123.815 E.01844
G1 F2640
G1 X117.707 Y124.771 E.02941
G1 F2880
G1 X117.754 Y125.342 E.01762
G1 F3900
G1 X117.769 Y125.627 E.00876
G1 F9300
G1 X117.832 Y126.014 E.01207
G1 F10971.834
G1 X117.857 Y126.098 E.00269
G1 F12000
G1 X117.917 Y126.348 E.0079
G1 X117.94 Y126.401 E.00175
G2 X118.964 Y127.397 I1.397 J-.413 E.04589
G2 X119.672 Y127.481 I.672 J-2.632 E.02196
G1 X136.324 Y127.525 E.51168
G2 X137.338 Y127.333 I.036 J-2.578 E.03191
G2 X137.589 Y127.16 I-.747 J-1.354 E.00937
G1 X137.751 Y127.006 E.00688
; WIPE_START
M204 S10000
G1 X137.797 Y126.947 E-.02857
G1 X137.966 Y126.694 E-.11576
G1 X138.062 Y126.455 E-.09796
G1 X138.085 Y126.402 E-.02177
G1 X138.147 Y126.153 E-.09758
G1 X138.172 Y126.068 E-.0334
G1 X138.237 Y125.681 E-.14925
G1 X138.254 Y125.397 E-.10832
G1 X138.278 Y125.115 E-.10739
; WIPE_END
G1 E-.04 F1800
G1 X140.559 Y126.058 Z1 F30000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.52763
G1 F13616.39
G1 X140.57 Y125.879 E.00707
; LINE_WIDTH: 0.494457
G1 F14616.753
G1 X140.594 Y125.258 E.02285
; LINE_WIDTH: 0.45005
G1 F15000
G1 X140.618 Y124.638 E.02061
; LINE_WIDTH: 0.384605
G2 X140.644 Y123.896 I-20.435 J-1.096 E.02067
G1 X140.651 Y120.868 E.0843
G1 X139.405 Y130.164 F30000
; LINE_WIDTH: 0.63582
G1 F11131.726
G2 X139.412 Y130.28 I-.034 J.06 E.01429
G1 X137.229 Y130.617 F30000
; LINE_WIDTH: 0.577604
G1 F12343.745
G1 X137.338 Y130.64 E.00484
; LINE_WIDTH: 0.532572
G1 F13478.981
G1 X137.447 Y130.663 E.00444
; LINE_WIDTH: 0.487539
G1 F14844.178
G1 X137.556 Y130.685 E.00403
; LINE_WIDTH: 0.420384
G1 F15000
G1 X137.665 Y130.708 E.00342
G1 X139.851 Y130.714 E.06725
G1 X139.855 Y129.216 E.04607
G1 X139.285 Y129.706 E.02313
G1 X138.451 Y130.169 E.02934
G1 X137.64 Y130.431 E.02621
; LINE_WIDTH: 0.442507
G1 X137.551 Y130.471 E.00318
; LINE_WIDTH: 0.487539
G1 F14844.178
G1 X137.462 Y130.511 E.00354
; LINE_WIDTH: 0.532572
G1 F13478.981
G1 X137.373 Y130.552 E.0039
; LINE_WIDTH: 0.577604
G1 F12343.745
G1 X137.284 Y130.592 E.00426
G1 X116.651 Y130.103 F30000
; LINE_WIDTH: 0.63586
G1 F11130.975
G2 X116.658 Y130.219 I-.034 J.06 E.01429
G1 X118.75 Y130.558 F30000
; LINE_WIDTH: 0.603485
G1 F11773.835
G1 X119.132 Y130.575 E.01745
; LINE_WIDTH: 0.553727
G1 F12920.741
G2 X119.648 Y130.594 I.597 J-9.276 E.02149
G1 X136.332 Y130.638 E.69447
G1 X136.895 Y130.626 E.02345
; LINE_WIDTH: 0.59667
G1 F11918.736
G1 X137.141 Y130.613 E.01111
G1 X118.75 Y130.558 F30000
; LINE_WIDTH: 0.594264
G1 F11970.753
G1 X118.65 Y130.514 E.00495
; LINE_WIDTH: 0.544472
G1 F13159.174
G1 X118.549 Y130.469 E.0045
; LINE_WIDTH: 0.494679
G1 F14609.568
G1 X118.448 Y130.425 E.00406
; LINE_WIDTH: 0.420421
G1 F15000
G1 X117.539 Y130.117 E.02953
G3 X116.132 Y129.153 I1.691 J-3.977 E.05281
G1 X116.128 Y130.651 E.04607
G1 X118.321 Y130.657 E.06746
; LINE_WIDTH: 0.444887
G1 X118.414 Y130.635 E.00312
; LINE_WIDTH: 0.494679
G1 F14609.568
G1 X118.506 Y130.614 E.0035
; LINE_WIDTH: 0.544472
G1 F13159.174
G1 X118.599 Y130.593 E.00389
; LINE_WIDTH: 0.594264
G1 F11970.753
G1 X118.692 Y130.572 E.00428
G1 X119.649 Y130.15 F30000
; LINE_WIDTH: 0.41999
G1 F15000
G3 X118.417 Y130.01 I.011 J-5.573 E.03816
G1 X117.67 Y129.764 E.02418
G1 X117.079 Y129.441 E.02069
G1 X116.526 Y129.019 E.02137
G1 X115.949 Y128.349 E.02718
G1 X115.758 Y128.035 E.01129
G1 X115.75 Y130.837 E.0861
G1 X115.764 Y131.02 E.00564
G1 X140.214 Y131.085 E.75126
G2 X140.235 Y128.1 I-92.057 J-2.165 E.09172
G1 X139.766 Y128.767 E.02507
G1 X139.462 Y129.08 E.01339
G1 X138.907 Y129.499 E.02137
G1 X138.321 Y129.816 E.02047
G1 X137.571 Y130.06 E.02421
G3 X136.333 Y130.195 I-1.22 J-5.451 E.03836
G1 X119.709 Y130.15 E.5108
G1 X119.65 Y129.773 F30000
G1 F15000
G3 X117.801 Y129.41 I-.013 J-4.822 E.05826
G3 X116.798 Y128.758 I1.771 J-3.823 E.03689
G1 X116.271 Y128.152 E.02467
G1 X115.921 Y127.532 E.0219
G1 X115.688 Y126.877 E.02133
; LINE_WIDTH: 0.436919
G1 X115.614 Y126.6 E.00922
; LINE_WIDTH: 0.470775
G1 X115.539 Y126.323 E.01001
; LINE_WIDTH: 0.504632
G1 F14294.635
G1 X115.465 Y126.046 E.0108
; LINE_WIDTH: 0.53009
G1 F13547.633
G1 X115.446 Y125.991 E.00229
; LINE_WIDTH: 0.518849
G1 F13867.635
G1 X115.425 Y126.297 E.01188
; LINE_WIDTH: 0.479305
G1 F15000
G1 X115.404 Y126.602 E.01089
; LINE_WIDTH: 0.420167
G1 X115.384 Y126.908 E.00942
G1 X115.373 Y130.851 E.1212
G1 X115.411 Y131.369 E.01599
G1 X115.946 Y131.405 E.01647
G1 X140.145 Y131.469 E.74391
G1 X140.564 Y131.436 E.01292
G1 X140.605 Y130.918 E.01599
G1 X140.615 Y126.975 E.12119
; LINE_WIDTH: 0.436917
G1 X140.599 Y126.688 E.00922
; LINE_WIDTH: 0.47077
G1 X140.583 Y126.402 E.01001
; LINE_WIDTH: 0.504624
G1 F14294.895
G1 X140.567 Y126.115 E.0108
; LINE_WIDTH: 0.530075
G1 F13548.049
G1 X140.559 Y126.058 E.0023
; LINE_WIDTH: 0.518832
G1 F13868.119
G1 X140.476 Y126.353 E.01188
; LINE_WIDTH: 0.479295
G1 F15000
G1 X140.394 Y126.648 E.01089
; LINE_WIDTH: 0.420263
G3 X140.075 Y127.596 I-6.528 J-1.665 E.03077
G1 X139.721 Y128.215 E.02193
G1 X139.191 Y128.817 E.02468
G3 X138.19 Y129.462 I-2.764 J-3.194 E.03674
G1 X137.503 Y129.689 E.02225
G3 X136.334 Y129.818 I-1.147 J-5.042 E.03624
G1 X119.71 Y129.773 E.51117
G1 X119.651 Y129.396 F30000
; LINE_WIDTH: 0.41999
G1 F15000
G1 X118.98 Y129.349 E.02068
G1 X118.344 Y129.21 E.01999
G1 X117.681 Y128.931 E.02211
G1 X117.07 Y128.497 E.02303
G1 X116.593 Y127.956 E.02216
G1 X116.271 Y127.392 E.01994
G1 X116.057 Y126.801 E.01931
G1 X115.859 Y125.783 E.03187
G1 X115.728 Y123.83 E.06015
G1 X115.74 Y120.384 E.10588
G1 X115.024 Y120.382 E.022
G1 X114.996 Y130.864 E.32207
G1 X115.042 Y131.492 E.01935
G1 X115.1 Y131.689 E.0063
G1 X115.317 Y131.74 E.00684
G1 X115.848 Y131.781 E.01636
G1 X140.16 Y131.846 E.74702
G1 X140.735 Y131.801 E.01775
G1 X140.874 Y131.758 E.00446
G1 X140.935 Y131.529 E.00728
G1 X140.982 Y130.933 E.01836
G1 X141.01 Y120.451 E.32207
G1 X140.294 Y120.449 E.022
G1 X140.287 Y123.896 E.10591
G1 X140.146 Y125.848 E.06012
G1 X139.942 Y126.865 E.03187
G1 X139.726 Y127.454 E.0193
G1 X139.401 Y128.016 E.01995
G1 X138.921 Y128.555 E.02215
G3 X137.435 Y129.318 I-2.468 J-2.976 E.05174
G3 X136.335 Y129.441 I-1.072 J-4.632 E.03408
G1 X119.711 Y129.396 E.5108
G1 X119.652 Y129.019 F30000
; LINE_WIDTH: 0.41999
G1 F15000
G3 X117.884 Y128.613 I-.042 J-3.872 E.05625
G1 X117.342 Y128.235 E.02032
G1 X116.915 Y127.759 E.01966
G1 X116.621 Y127.253 E.01798
G1 X116.427 Y126.725 E.01728
G1 X116.253 Y125.883 E.02642
G1 X116.105 Y123.831 E.0632
G1 X116.119 Y120.008 E.11747
G1 X114.648 Y120.004 E.04519
G1 X114.619 Y130.877 E.33409
G1 X114.669 Y131.559 E.02102
G1 X114.821 Y131.969 E.01341
G1 X115.164 Y132.105 E.01135
G1 X115.797 Y132.158 E.01951
G1 X140.174 Y132.223 E.74901
G1 X140.807 Y132.174 E.01952
G1 X141.151 Y132.039 E.01135
G1 X141.305 Y131.63 E.01341
G1 X141.359 Y130.948 E.02102
G1 X141.388 Y120.075 E.33409
G1 X139.917 Y120.071 E.04519
G1 X139.908 Y123.963 E.11957
G1 X139.77 Y125.82 E.05722
G1 X139.573 Y126.787 E.03032
G1 X139.376 Y127.313 E.01728
G1 X139.08 Y127.818 E.01799
G1 X138.65 Y128.292 E.01965
G1 X138.107 Y128.667 E.02028
G1 X137.522 Y128.905 E.01941
G3 X136.336 Y129.063 I-1.143 J-4.027 E.03689
G1 X119.712 Y129.019 E.5108
G1 X119.653 Y128.642 F30000
; LINE_WIDTH: 0.41999
G1 F15000
G3 X118.088 Y128.296 I-.044 J-3.515 E.0497
G1 X117.614 Y127.974 E.0176
G1 X117.237 Y127.562 E.01715
G3 X116.796 Y126.649 I2.419 J-1.73 E.03132
G1 X116.612 Y125.731 E.02876
G1 X116.484 Y123.873 E.05722
G1 X116.497 Y119.632 E.13033
G1 X114.272 Y119.626 E.06837
G1 X114.242 Y130.89 E.34612
G1 X114.296 Y131.627 E.02269
G1 X114.473 Y132.127 E.01631
G1 X114.637 Y132.301 E.00732
G1 X115.09 Y132.478 E.01496
G1 X115.781 Y132.535 E.02129
G1 X140.188 Y132.6 E.74995
G1 X140.879 Y132.546 E.0213
G1 X141.334 Y132.372 E.01496
G1 X141.498 Y132.199 E.00732
G1 X141.678 Y131.7 E.01631
G1 X141.736 Y130.963 E.02269
G1 X141.766 Y119.699 E.34611
G1 X139.541 Y119.693 E.06837
G1 X139.533 Y123.894 E.12908
G1 X139.394 Y125.792 E.05846
G1 X139.205 Y126.708 E.02876
G1 X138.983 Y127.257 E.01818
G1 X138.684 Y127.716 E.01685
G1 X138.277 Y128.113 E.01746
G1 X137.799 Y128.401 E.01714
G3 X136.337 Y128.686 I-1.469 J-3.631 E.04604
G1 X119.713 Y128.642 E.5108
G1 X119.654 Y128.265 F30000
; LINE_WIDTH: 0.41999
G1 F15000
G3 X118.291 Y127.978 I.005 J-3.41 E.0431
G1 X117.885 Y127.713 E.01489
G1 X117.558 Y127.366 E.01465
G3 X117.165 Y126.573 I2.111 J-1.54 E.02734
G1 X116.988 Y125.705 E.0272
G1 X116.86 Y123.847 E.05722
G1 X116.875 Y119.256 E.14108
G1 X113.896 Y119.248 E.09155
G1 X113.865 Y130.904 E.35814
G1 X113.923 Y131.694 E.02436
G1 X114.072 Y132.203 E.01629
G1 X114.269 Y132.5 E.01095
G1 X114.545 Y132.699 E.01047
G1 X115.016 Y132.85 E.0152
G1 X115.765 Y132.912 E.02307
G1 X140.202 Y132.977 E.75088
G1 X140.951 Y132.919 E.02308
G1 X141.423 Y132.771 E.01519
G1 X141.701 Y132.573 E.01048
G1 X141.899 Y132.277 E.01095
G1 X142.051 Y131.769 E.0163
G1 X142.113 Y130.979 E.02436
G1 X142.144 Y119.323 E.35814
G1 X139.165 Y119.315 E.09155
G1 X139.156 Y123.907 E.14108
G1 X139.018 Y125.764 E.05722
G1 X138.836 Y126.63 E.0272
G3 X137.668 Y128.047 I-2.237 J-.654 E.05798
G3 X136.338 Y128.309 I-1.321 J-3.191 E.04193
G1 X119.714 Y128.265 E.5108
; WIPE_START
G1 X121.714 Y128.27 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1 I.931 J-.783 P1  F30000
G1 X115.381 Y120.741 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.380484
G1 F15000
G1 X115.373 Y123.95 E.08827
; LINE_WIDTH: 0.405677
G1 X115.394 Y124.571 E.01836
; LINE_WIDTH: 0.45007
G1 X115.414 Y125.191 E.02061
; LINE_WIDTH: 0.494464
G1 F14616.537
G1 X115.435 Y125.812 E.02285
; LINE_WIDTH: 0.52764
G1 F13616.109
G1 X115.442 Y125.931 E.0047
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F13616.109
G1 X115.435 Y125.812 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 4/118
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
G17
G3 Z1 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X112.425 Y115.158
G1 Z.8
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
G1 F9000
G3 X113.61 Y114.399 I1.337 J.783 E.04488
G1 X113.621 Y113.98 E.01291
G3 X114.241 Y114.144 I-.107 J1.649 E.01982
G3 X115.696 Y114.344 I.415 J2.383 E.04587
G3 X118.027 Y115.043 I.729 J1.804 E.08077
G2 X117.929 Y115.693 I.361 J.387 E.02179
G2 X118.058 Y116.684 I25.52 J-2.828 E.03072
G3 X116.936 Y117.842 I-1.739 J-.563 E.05131
G1 X115.988 Y117.839 E.02914
G3 X114.835 Y117.157 I1.846 J-4.435 E.04128
G3 X114.19 Y117.054 I-.059 J-1.705 E.02022
G3 X113.467 Y117.31 I-1.778 J-3.869 E.02358
G3 X112.812 Y114.192 I.117 J-1.653 E.13161
G3 X113.565 Y113.978 I1.065 J2.31 E.02416
; WIPE_START
G1 X114.241 Y114.144 E-.26455
G1 X114.852 Y114.089 E-.23311
G1 X115.513 Y114.288 E-.26234
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1.2 I-.049 J1.216 P1  F30000
G1 X138.54 Y115.221 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F9000
G3 X139.685 Y114.472 I1.292 J.725 E.0437
G1 X139.784 Y114.064 E.01291
G3 X140.893 Y114.562 I-.279 J2.103 E.03787
G2 X142.141 Y114.181 I-3.67 J-14.274 E.04012
G3 X143.793 Y114.785 I.225 J1.945 E.05603
G1 X143.645 Y115.367 E.01846
G3 X143.98 Y116.681 I-2.983 J1.46 E.04195
G3 X141.155 Y117.384 I-1.617 J-.468 E.10807
G1 X140.615 Y117.281 E.01689
G3 X139.064 Y114.172 I-.916 J-1.484 E.17797
G3 X139.729 Y114.05 I.532 J1.025 E.0211
; WIPE_START
G1 X140.305 Y114.19 E-.22509
G1 X140.893 Y114.562 E-.26424
G1 X141.427 Y114.446 E-.20788
G1 X141.576 Y114.374 E-.06279
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1.2 I-1.176 J-.315 P1  F30000
G1 X138.139 Y127.213 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F7690
G1 X138.322 Y126.908 E.01179
G2 X138.451 Y126.539 I-1.631 J-.778 E.01299
G2 X138.592 Y125.157 I-6.062 J-1.318 E.04618
G2 X138.665 Y123.878 I-58.973 J-3.974 E.04252
G1 X138.675 Y118.921 E.16441
G1 X142.537 Y118.932 E.1281
G1 X142.505 Y131.044 E.40178
G3 X142.257 Y132.498 I-3.946 J.075 E.04923
G3 X141.338 Y133.281 I-1.315 J-.612 E.04129
G3 X140.213 Y133.423 I-1.079 J-4.041 E.03776
G1 X115.752 Y133.358 E.81141
G3 X114.368 Y133.106 I-.073 J-3.531 E.04697
G3 X113.611 Y132.148 I.685 J-1.319 E.04175
G3 X113.473 Y130.967 I4.542 J-1.132 E.03955
G1 X113.506 Y118.854 E.40178
G1 X117.366 Y118.865 E.12806
G1 X117.351 Y123.821 E.16441
G2 X117.474 Y126.09 I50.08 J-1.585 E.07537
G2 X117.878 Y127.193 I2.56 J-.312 E.0393
G2 X118.853 Y127.828 I1.521 J-1.268 E.03918
G2 X119.66 Y127.926 I.775 J-2.999 E.02705
G1 X136.334 Y127.97 E.55309
G2 X137.512 Y127.74 I.025 J-3 E.0401
G2 X138.101 Y127.26 I-.821 J-1.61 E.02541
M204 S250
G1 X137.8 Y127.013 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F7690
M204 S5000
G1 X137.802 Y127.002 E.00034
G2 X138.072 Y126.436 I-1.121 J-.882 E.01944
G2 X138.155 Y125.922 I-3.013 J-.751 E.01602
G1 X138.18 Y125.718 E.00631
G1 X138.201 Y125.138 E.01783
G1 X138.229 Y124.695 E.01362
G1 X138.252 Y124.266 E.0132
G1 X138.273 Y123.867 E.01229
G1 X138.284 Y118.528 E.16404
G1 X138.341 Y118.528 E.00174
G1 X138.741 Y118.53 E.01229
G1 X142.93 Y118.541 E.12873
G1 X142.897 Y131.052 E.38444
G3 X142.736 Y132.338 I-5.098 J.015 E.03995
G3 X142.06 Y133.354 I-1.893 J-.527 E.03812
G1 X142.039 Y133.372 E.00084
G1 X141.771 Y133.531 E.00958
G3 X141.097 Y133.745 I-1.115 J-2.356 E.02181
G3 X139.619 Y133.813 I-1.131 J-8.433 E.0455
G1 X116.343 Y133.751 E.71521
G3 X114.867 Y133.675 I-.301 J-8.505 E.0455
G3 X114.193 Y133.458 I.454 J-2.566 E.02181
G1 X113.926 Y133.297 E.00958
G1 X113.905 Y133.28 E.00083
G3 X113.235 Y132.26 I1.226 J-1.536 E.03812
G3 X113.081 Y130.973 I4.944 J-1.245 E.03995
G1 X113.115 Y118.461 E.38444
G1 X117.303 Y118.473 E.1287
G1 X117.703 Y118.474 E.01229
G1 X117.76 Y118.474 E.00174
G1 X117.743 Y123.812 E.16404
G1 X117.762 Y124.212 E.01229
G1 X117.782 Y124.641 E.0132
G1 X117.808 Y125.084 E.01364
G1 X117.826 Y125.664 E.01782
G1 X117.85 Y125.868 E.00632
G2 X118.192 Y126.954 I2.187 J-.093 E.03539
G2 X118.959 Y127.449 I1.185 J-.994 E.02847
G2 X119.672 Y127.534 I.678 J-2.649 E.02211
G1 X136.324 Y127.578 E.51168
G2 X137.337 Y127.386 I.036 J-2.577 E.03191
G2 X137.592 Y127.218 I-.656 J-1.266 E.0094
G1 X137.757 Y127.055 E.00711
; WIPE_START
G1 F12000
M204 S10000
G1 X137.802 Y127.002 E-.02643
G1 X137.965 Y126.741 E-.11699
G1 X138.072 Y126.436 E-.12289
G1 X138.14 Y126.093 E-.13292
G1 X138.155 Y125.922 E-.06523
G1 X138.18 Y125.718 E-.0781
G1 X138.2 Y125.146 E-.21744
; WIPE_END
G1 E-.04 F1800
G1 X140.769 Y119.275 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F7690
G1 X142.188 Y119.279 E.04706
G1 X142.187 Y119.489 E.00695
G1 X139.016 Y122.66 E.14879
G1 X139.018 Y121.666 E.03299
G1 X142.173 Y124.821 E.14803
G1 X142.167 Y127.185 E.07841
G1 X138.493 Y130.859 E.17235
G1 X140.54 Y130.864 E.06791
G1 X137.705 Y128.029 E.13299
G3 X136.342 Y128.319 I-1.759 J-4.934 E.04638
G1 X133.365 Y128.311 E.09874
G1 X130.837 Y130.839 E.11858
G1 X132.844 Y130.844 E.06656
G1 X130.303 Y128.303 E.11921
G1 X125.71 Y128.29 E.15237
G1 X123.182 Y130.818 E.11858
G1 X125.148 Y130.823 E.06521
G1 X122.606 Y128.282 E.11921
G3 X119.208 Y128.25 I-1.393 J-31.944 E.11279
G3 X118.324 Y128.001 I.62 J-3.896 E.03055
G1 X115.526 Y130.798 E.13123
G1 X117.451 Y130.803 E.06386
G1 X113.831 Y127.183 E.16982
G1 X113.838 Y124.81 E.07871
G1 X117.01 Y121.639 E.14879
G1 X117.006 Y122.682 E.03462
G1 X113.852 Y119.528 E.14796
G1 X113.853 Y119.204 E.01076
G1 X115.157 Y119.207 E.04325
G1 X115.185 Y132.052 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.685581
G1 F7690
G1 X115.803 Y132.078 E.03236
G1 X140.169 Y132.143 E1.27601
G1 X140.727 Y132.122 E.02924
G1 X115.781 Y132.589 F30000
; LINE_WIDTH: 0.41999
G1 F7690
G1 X140.188 Y132.653 E.74995
G1 X140.879 Y132.599 E.0213
G1 X141.311 Y132.441 E.01412
G2 X141.57 Y132.114 I-.373 J-.563 E.01306
G1 X141.679 Y131.742 E.0119
G1 X141.688 Y131.637 E.00325
G1 X114.287 Y131.564 E.84193
G1 X114.417 Y132.096 E.01683
G1 X114.607 Y132.333 E.00933
G1 X114.784 Y132.433 E.00626
G1 X115.145 Y132.535 E.01152
G1 X115.721 Y132.584 E.01776
G1 X115.765 Y132.966 F30000
G1 F7690
G1 X140.202 Y133.031 E.75088
G1 X140.951 Y132.972 E.02308
G1 X141.423 Y132.824 E.01519
G1 X141.701 Y132.626 E.01048
G1 X141.899 Y132.331 E.01095
G1 X142.051 Y131.822 E.01631
G1 X142.096 Y131.261 E.01731
G1 X113.881 Y131.186 E.86696
G1 X113.923 Y131.747 E.01731
G1 X114.071 Y132.257 E.0163
G1 X114.269 Y132.553 E.01095
G1 X114.545 Y132.753 E.01047
G1 X115.114 Y132.911 E.01813
G1 X115.705 Y132.961 E.01823
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X115.114 Y132.911 E-.22546
G1 X114.545 Y132.753 E-.22422
G1 X114.269 Y132.553 E-.12955
G1 X114.071 Y132.257 E-.13541
G1 X114.038 Y132.142 E-.04537
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 5/118
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
G17
G3 Z1.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X112.422 Y115.241
G1 Z1
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
G1 F9000
G3 X113.74 Y114.378 I1.376 J.664 E.05083
G1 X113.852 Y113.974 E.01291
G2 X114.952 Y114.027 I.66 J-2.247 E.03415
G3 X115.783 Y114.356 I-.928 J3.557 E.02753
M73 P45 R9
G3 X117.89 Y114.957 I.66 J1.682 E.07234
G1 X117.817 Y115.132 E.00583
G3 X117.867 Y116.118 I-1.861 J.588 E.03067
G3 X117.823 Y116.989 I-2.238 J.324 E.02698
G3 X115.318 Y117.305 I-1.37 J-.774 E.09003
G2 X113.701 Y117.335 I-.78 J1.551 E.0517
G3 X112.349 Y116.7 I-.238 J-1.248 E.04903
G3 X112.866 Y114.197 I1.17 J-1.064 E.09147
G3 X113.797 Y113.958 I.809 J1.219 E.0301
; WIPE_START
G1 X114.147 Y114.06 E-.13847
G1 X114.952 Y114.027 E-.30584
G1 X115.724 Y114.333 E-.31569
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1.4 I-.056 J1.216 P1  F30000
G1 X138.503 Y115.378 Z1.4
G1 Z1
G1 E.8 F1800
G1 F9000
G3 X139.512 Y114.455 I1.421 J.54 E.04357
G1 X139.515 Y114.035 E.01291
G3 X140.844 Y114.554 I.01 J1.935 E.04489
G2 X141.812 Y114.326 I.179 J-1.408 E.03122
G3 X143.455 Y114.561 I.589 J1.745 E.05289
G1 X143.42 Y114.974 E.01276
G3 X143.752 Y116.966 I-2.798 J1.49 E.06316
G3 X141.276 Y117.314 I-1.371 J-.775 E.08876
G1 X140.741 Y117.162 E.01709
G3 X139.735 Y117.63 I-1.36 J-1.605 E.0345
G3 X138.594 Y117.096 I.025 J-1.54 E.03987
G3 X139.458 Y114.035 I1.236 J-1.304 E.12002
; WIPE_START
G1 X139.984 Y114.081 E-.2003
G1 X140.844 Y114.554 E-.37315
G1 X141.334 Y114.523 E-.18655
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1.4 I-1.18 J-.299 P1  F30000
G1 X138.093 Y127.327 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F9179
G1 X138.114 Y127.296 E.00127
G2 X138.453 Y126.586 I-1.43 J-1.118 E.02628
G2 X138.559 Y125.128 I-6.474 J-1.204 E.04861
G1 X138.603 Y123.871 E.0417
G1 X138.615 Y118.921 E.16421
G1 X142.537 Y118.931 E.1301
G1 X142.505 Y131.097 E.40356
G3 X142.257 Y132.551 I-3.946 J.075 E.04923
G3 X141.338 Y133.335 I-1.315 J-.612 E.0413
G3 X140.213 Y133.476 I-1.079 J-4.041 E.03775
G1 X115.752 Y133.411 E.81141
G3 X114.368 Y133.159 I-.073 J-3.531 E.04697
G3 X113.611 Y132.201 I.685 J-1.319 E.04175
G3 X113.473 Y131.02 I4.542 J-1.132 E.03955
G1 X113.505 Y118.854 E.40356
G1 X117.427 Y118.865 E.1301
G1 X117.412 Y123.815 E.1642
G2 X117.48 Y126.131 I107.077 J-1.941 E.07688
G2 X117.878 Y127.246 I2.45 J-.247 E.03965
G2 X118.853 Y127.881 I1.521 J-1.269 E.03918
G2 X120.221 Y127.981 I1.077 J-5.338 E.04562
G1 X136.333 Y128.024 E.53449
G2 X137.512 Y127.793 I.025 J-3 E.04011
G2 X137.84 Y127.577 I-.827 J-1.616 E.01307
G1 X138.05 Y127.369 E.00978
M204 S250
G1 X137.803 Y127.062 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9179
M204 S5000
G1 X137.802 Y127.055 E.00023
G2 X138.073 Y126.487 I-1.123 J-.884 E.01952
G2 X138.167 Y125.118 I-6.129 J-1.111 E.04223
G1 X138.175 Y124.902 E.00663
G1 X138.211 Y123.864 E.03193
G1 X138.224 Y118.528 E.16396
G1 X138.243 Y118.528 E.00059
G1 X142.93 Y118.54 E.14402
G1 X142.897 Y131.105 E.38609
G3 X142.736 Y132.392 I-5.098 J.015 E.03995
G3 X142.06 Y133.408 I-1.894 J-.527 E.03812
G1 X142.039 Y133.425 E.00083
G1 X141.771 Y133.585 E.00958
G3 X141.097 Y133.798 I-1.115 J-2.355 E.02181
G3 X139.619 Y133.866 I-1.131 J-8.434 E.04551
G1 X116.343 Y133.805 E.71521
G3 X114.866 Y133.728 I-.301 J-8.506 E.0455
G3 X114.193 Y133.511 I.454 J-2.567 E.02181
G1 X113.926 Y133.351 E.00958
G1 X113.905 Y133.333 E.00084
G3 X113.235 Y132.313 I1.226 J-1.536 E.03812
G3 X113.08 Y131.026 I4.943 J-1.245 E.03995
G1 X113.114 Y118.461 E.38609
G1 X117.801 Y118.474 E.14402
G1 X117.82 Y118.474 E.00059
G1 X117.805 Y123.809 E.16396
G1 X117.835 Y124.848 E.03193
G2 X117.87 Y126.087 I34.068 J-.321 E.03807
G2 X118.192 Y127.007 I2.021 J-.191 E.03027
G2 X118.959 Y127.502 I1.185 J-.994 E.02847
G2 X120.222 Y127.589 I.976 J-4.98 E.039
G1 X136.324 Y127.632 E.49477
G2 X137.337 Y127.44 I.036 J-2.578 E.03191
G2 X137.592 Y127.271 I-.659 J-1.268 E.0094
G1 X137.761 Y127.104 E.00728
; WIPE_START
G1 F12000
M204 S10000
G1 X137.802 Y127.055 E-.02431
G1 X137.965 Y126.794 E-.11696
G1 X138.073 Y126.487 E-.12392
G1 X138.134 Y126.14 E-.13359
G1 X138.165 Y125.19 E-.36123
; WIPE_END
G1 E-.04 F1800
G1 X130.778 Y123.269 Z1.4 F30000
G1 X115.157 Y119.207 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F9179
G1 X113.852 Y119.203 E.04327
G1 X113.851 Y119.527 E.01074
G1 X117.067 Y122.743 E.15087
G1 X117.071 Y121.577 E.03867
G1 X113.837 Y124.811 E.15168
G1 X113.831 Y127.183 E.07868
G1 X116.679 Y130.031 E.13361
G1 X116.294 Y130.03 E.01276
G1 X118.291 Y128.033 E.09367
G2 X119.65 Y128.328 I1.794 J-4.994 E.04626
G1 X122.66 Y128.336 E.09984
G1 X124.377 Y130.053 E.08057
G1 X123.948 Y130.052 E.01423
G1 X125.656 Y128.344 E.08013
G1 X130.356 Y128.356 E.1559
G1 X132.075 Y130.075 E.08064
G1 X131.602 Y130.074 E.01569
G1 X133.312 Y128.364 E.08021
G2 X136.784 Y128.35 I1.602 J-32.599 E.11523
G2 X137.738 Y128.062 I-.361 J-2.925 E.03321
G1 X139.773 Y130.097 E.09548
G1 X139.256 Y130.096 E.01715
G1 X142.167 Y127.185 E.13655
G1 X142.173 Y124.821 E.07841
G1 X138.957 Y121.605 E.15088
G1 X138.954 Y122.722 E.03704
G1 X142.187 Y119.489 E.15167
G1 X142.188 Y119.279 E.00696
G1 X140.77 Y119.275 E.04705
; WIPE_START
G1 F16200
G1 X142.188 Y119.279 E-.539
G1 X142.187 Y119.489 E-.07977
G1 X141.925 Y119.751 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X134.841 Y122.594 Z1.4 F30000
G1 X113.865 Y131.01 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F9179
G1 X113.922 Y131.801 E.02436
G1 X114.071 Y132.31 E.0163
G1 X114.268 Y132.607 E.01095
G1 X114.545 Y132.806 E.01047
G1 X115.016 Y132.956 E.0152
G1 X115.764 Y133.019 E.02307
G1 X140.202 Y133.084 E.75088
G1 X140.951 Y133.025 E.02309
G1 X141.423 Y132.877 E.01519
G1 X141.7 Y132.68 E.01047
G1 X141.899 Y132.384 E.01095
G1 X142.051 Y131.875 E.0163
G1 X142.113 Y131.085 E.02436
G1 X142.114 Y130.496 E.0181
G1 X113.866 Y130.415 E.86797
G1 X113.865 Y130.95 E.01645
G1 X114.289 Y131.649 F30000
G1 F9179
G1 X114.417 Y132.149 E.01585
G1 X114.545 Y132.341 E.00708
G1 X114.826 Y132.5 E.00993
G1 X115.192 Y132.593 E.01158
G1 X115.781 Y132.642 E.01816
G1 X140.188 Y132.707 E.74995
G1 X140.879 Y132.653 E.02131
G1 X141.334 Y132.478 E.01496
G1 X141.498 Y132.305 E.00732
G1 X141.678 Y131.806 E.01631
G1 X141.736 Y130.872 E.02876
G1 X114.242 Y130.793 E.8448
G1 X114.286 Y131.589 E.0245
G1 X114.681 Y131.709 F30000
G1 F9179
G1 X114.821 Y132.075 E.01205
G1 X115.164 Y132.212 E.01135
G1 X115.797 Y132.265 E.01951
G1 X140.174 Y132.33 E.74901
G1 X140.807 Y132.28 E.01953
G1 X141.151 Y132.145 E.01135
G1 X141.305 Y131.737 E.01341
G1 X141.344 Y131.248 E.01506
G1 X114.633 Y131.171 E.82074
G1 X114.676 Y131.649 E.01474
G1 X115.015 Y131.528 F30000
; LINE_WIDTH: 0.397164
G1 F9179
G1 X115.082 Y131.812 E.00843
G1 X115.253 Y131.862 E.00513
G2 X115.82 Y131.898 I1.166 J-14.023 E.01641
G1 X140.153 Y131.964 E.7024
G1 X140.721 Y131.931 E.01643
G1 X140.892 Y131.882 E.00515
G1 X140.96 Y131.601 E.00835
G1 X115.821 Y131.541 E.72569
G2 X115.075 Y131.528 I-.702 J18.447 E.02153
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F12000
G1 X115.821 Y131.541 E-.28337
G1 X117.075 Y131.544 E-.47663
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 6/118
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
G17
G3 Z1.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X116.598 Y117.825
G1 Z1.2
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F4800
G1 X116.598 Y114.171 E.11227
G2 X116.037 Y114.274 I-.108 J.996 E.01777
G1 X115.721 Y114.195 E.01001
G1 X115.721 Y117.471 E.10068
G2 X114.844 Y117.145 I-1.049 J1.478 E.02908
G1 X114.844 Y113.933 E.09868
G2 X114.389 Y114.071 I-.056 J.64 E.01497
G1 X113.967 Y113.974 E.01329
G1 X113.967 Y117.27 E.10128
G3 X113.09 Y117.385 I-.568 J-.93 E.02799
G1 X113.09 Y113.82 E.10953
G1 X112.461 Y114.566 F30000
; FEATURE: Support
G1 F9000
G1 X112.46 Y116.85 E.07019
G3 X111.974 Y115.462 I1.798 J-1.408 E.04599
G3 X112.461 Y114.509 I2.286 J.567 E.03318
G1 X117.735 Y115.035 F30000
G1 F9000
G3 X117.706 Y116.466 I-1.441 J.687 E.04562
G1 X117.714 Y114.982 E.0456
; WIPE_START
G1 X117.896 Y115.635 E-.25738
G1 X117.882 Y115.913 E-.10578
G1 X117.706 Y116.466 E-.22082
G1 X117.708 Y116.003 E-.17602
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1.6 I.06 J1.215 P1  F30000
G1 X138.349 Y114.977 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F9000
G1 X138.349 Y116.7 E.05294
G3 X138.349 Y114.921 I1.423 J-.89 E.05763
; WIPE_START
G1 X138.349 Y116.7 E-.6762
G1 X138.252 Y116.503 E-.0838
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1.6 I1.117 J.484 P1  F30000
G1 X139.402 Y113.847 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Support interface
G1 F4800
G1 X139.402 Y117.664 E.11726
G2 X140.279 Y117.475 I.233 J-1.049 E.02844
G1 X140.279 Y114.205 E.10049
G3 X141.103 Y114.961 I-1.421 J2.374 E.03462
G1 X141.156 Y114.945 E.00171
G1 X141.181 Y117.192 E.06904
G2 X142.033 Y117.603 I28.981 J-58.991 E.02908
G1 X142.033 Y114.453 E.09678
G2 X142.193 Y114.293 I-.132 J-.292 E.0071
G3 X142.91 Y114.392 I.241 J.902 E.02284
G1 X142.91 Y117.725 E.10242
G1 X143.626 Y115.82 F30000
; FEATURE: Support
G1 F9000
G3 X143.596 Y116.51 I-1.446 J.284 E.02142
G1 X143.6 Y115.769 E.02276
; WIPE_START
G1 X143.673 Y116.209 E-.22621
G1 X143.596 Y116.51 E-.15778
G1 X143.6 Y115.769 E-.376
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1.6 I-1.1 J-.522 P1  F30000
G1 X138.093 Y127.38 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F10178
G1 X138.114 Y127.349 E.00127
G2 X138.453 Y126.64 I-1.429 J-1.117 E.02625
G2 X138.548 Y125.233 I-5.877 J-1.104 E.0469
G2 X138.583 Y118.921 I-250.45 J-4.573 E.2094
G1 X142.537 Y118.931 E.13115
G1 X142.505 Y131.15 E.40533
G3 X142.257 Y132.605 I-3.946 J.075 E.04923
G3 X141.338 Y133.388 I-1.316 J-.612 E.0413
G3 X140.212 Y133.529 I-1.079 J-4.042 E.03775
G1 X115.752 Y133.464 E.81141
G3 X114.368 Y133.213 I-.073 J-3.531 E.04697
G3 X113.611 Y132.254 I.685 J-1.319 E.04175
G3 X113.472 Y131.073 I4.543 J-1.132 E.03955
G1 X113.505 Y118.854 E.40533
G1 X117.459 Y118.864 E.13115
G1 X117.444 Y123.813 E.16417
G2 X117.479 Y126.182 I139.704 J-.861 E.07857
G2 X117.878 Y127.299 I2.486 J-.258 E.03975
G2 X118.853 Y127.934 I1.521 J-1.269 E.03917
G2 X119.66 Y128.033 I.775 J-3 E.02705
G1 X136.333 Y128.077 E.55309
G2 X137.512 Y127.846 I.025 J-3 E.04011
G2 X137.84 Y127.63 I-.827 J-1.615 E.01306
G1 X138.05 Y127.423 E.00979
M204 S250
G1 X137.801 Y127.109 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F10178
M204 S5000
G2 X138.072 Y126.541 I-1.123 J-.884 E.01949
G2 X138.156 Y125.23 I-5.527 J-1.01 E.04044
G2 X138.192 Y118.527 I-336.618 J-5.192 E.20596
G1 X142.93 Y118.54 E.14558
G1 X142.897 Y131.158 E.38773
G3 X142.736 Y132.445 I-5.098 J.015 E.03995
G3 X142.06 Y133.461 I-1.894 J-.527 E.03812
G1 X142.039 Y133.479 E.00083
G1 X141.771 Y133.638 E.00958
G3 X141.096 Y133.851 I-1.115 J-2.354 E.02181
G3 X139.619 Y133.92 I-1.131 J-8.435 E.0455
G1 X116.343 Y133.858 E.71521
G3 X114.866 Y133.781 I-.301 J-8.506 E.0455
G3 X114.193 Y133.565 I.455 J-2.567 E.02181
G1 X113.925 Y133.404 E.00958
G1 X113.905 Y133.386 E.00084
G3 X113.235 Y132.367 I1.227 J-1.536 E.03812
G3 X113.08 Y131.079 I4.943 J-1.245 E.03995
G1 X113.114 Y118.461 E.38773
G1 X117.852 Y118.473 E.14558
G1 X117.836 Y123.808 E.16393
G2 X117.869 Y126.139 I150.483 J-.971 E.07163
G2 X118.192 Y127.061 I2.055 J-.203 E.03029
G2 X118.959 Y127.555 I1.186 J-.995 E.02846
G2 X119.671 Y127.641 I.678 J-2.649 E.02211
G1 X136.324 Y127.685 E.51168
G2 X137.337 Y127.493 I.036 J-2.577 E.03191
G2 X137.763 Y127.155 I-.658 J-1.268 E.01681
; WIPE_START
G1 F12000
M204 S10000
G1 X137.965 Y126.847 E-.13972
G1 X138.072 Y126.541 E-.12349
G1 X138.134 Y126.193 E-.13411
G1 X138.155 Y125.239 E-.36268
; WIPE_END
G1 E-.04 F1800
G1 X142.113 Y131.115 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F10178
G1 X142.114 Y130.496 E.01902
G1 X113.866 Y130.415 E.86797
G2 X113.922 Y131.854 I9.517 J.35 E.0443
G1 X114.071 Y132.363 E.0163
G1 X114.268 Y132.66 E.01095
G1 X114.545 Y132.859 E.01047
G1 X115.016 Y133.01 E.0152
G1 X115.764 Y133.072 E.02307
G1 X140.202 Y133.137 E.75088
G1 X140.951 Y133.078 E.02308
G1 X141.423 Y132.931 E.01519
G1 X141.7 Y132.733 E.01048
G1 X141.899 Y132.437 E.01095
G1 X142.051 Y131.929 E.0163
G1 X142.11 Y131.175 E.02324
G1 X141.736 Y131.114 F30000
G1 F10178
G1 X141.736 Y130.872 E.00743
G1 X114.242 Y130.793 E.8448
G1 X114.289 Y131.698 E.02783
G1 X114.417 Y132.202 E.016
G1 X114.544 Y132.394 E.00708
G1 X114.826 Y132.553 E.00993
G1 X115.195 Y132.646 E.01168
G1 X115.78 Y132.695 E.01807
G1 X140.188 Y132.76 E.74995
G1 X140.879 Y132.706 E.02131
G1 X141.333 Y132.531 E.01496
G1 X141.497 Y132.359 E.00732
G1 X141.678 Y131.859 E.01631
G1 X141.732 Y131.174 E.02113
G1 X141.348 Y131.248 F30000
G1 F10178
G1 X114.628 Y131.171 E.82098
G1 X114.669 Y131.719 E.01688
G1 X114.821 Y132.128 E.01341
G1 X115.164 Y132.265 E.01136
G1 X115.797 Y132.318 E.01951
G1 X140.173 Y132.383 E.74901
G1 X140.807 Y132.333 E.01953
G1 X141.151 Y132.198 E.01135
G1 X141.305 Y131.79 E.01341
G1 X141.343 Y131.308 E.01486
G1 X140.95 Y131.615 F30000
; LINE_WIDTH: 0.423797
G1 F10178
G1 X115.822 Y131.555 E.7799
G2 X115.026 Y131.541 I-.729 J19.729 E.02472
G1 X115.093 Y131.855 E.00996
G1 X115.257 Y131.903 E.00529
G2 X115.821 Y131.938 I1.172 J-14.151 E.01755
G1 X140.151 Y132.004 E.75514
G1 X140.717 Y131.972 E.01757
M73 P46 R9
G1 X140.881 Y131.925 E.00531
G1 X140.937 Y131.673 E.008
G1 X140.77 Y119.275 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F10178
G1 X142.188 Y119.278 E.04704
G1 X142.187 Y119.489 E.00697
G1 X138.922 Y122.754 E.15316
G1 X138.925 Y121.573 E.03915
G1 X142.173 Y124.821 E.15237
G1 X142.167 Y127.185 E.07841
G1 X139.256 Y130.096 E.13655
G1 X139.773 Y130.097 E.01715
G1 X137.771 Y128.095 E.09395
G3 X136.342 Y128.425 I-1.683 J-4.02 E.04889
G1 X133.259 Y128.417 E.10226
G1 X131.602 Y130.074 E.07772
G1 X132.075 Y130.075 E.01569
G1 X130.41 Y128.409 E.07814
G1 X125.603 Y128.397 E.15943
G1 X123.948 Y130.052 E.07764
G1 X124.377 Y130.053 E.01423
G1 X122.713 Y128.389 E.07806
G3 X119.208 Y128.356 I-1.444 J-32.948 E.11634
G3 X118.258 Y128.066 I.382 J-2.945 E.03309
G1 X116.294 Y130.03 E.09214
G1 X116.679 Y130.031 E.01276
G1 X113.831 Y127.183 E.13361
G1 X113.837 Y124.811 E.07868
G1 X117.102 Y121.546 E.15318
G1 X117.099 Y122.775 E.04078
G1 X113.851 Y119.527 E.15235
G1 X113.852 Y119.203 E.01075
G1 X115.156 Y119.207 E.04326
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X113.852 Y119.203 E-.49557
G1 X113.851 Y119.527 E-.12319
G1 X114.114 Y119.79 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 7/118
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
G17
G3 Z1.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.361 Y117.229
G1 Z1.4
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F4800
G1 X112.77 Y117.229 E.14108
G1 X112.581 Y117.052 E.00796
G1 X112.581 Y116.352 E.02151
G1 X117.583 Y116.352 E.15371
G1 X117.587 Y115.475 E.02695
G1 X112.582 Y115.475 E.1538
G3 X112.764 Y114.598 I1.588 J-.128 E.0279
G1 X117.562 Y114.598 E.14745
G1 X112.184 Y115.101 F30000
; FEATURE: Support
G1 F9000
G1 X112.182 Y116.236 E.03488
G3 X112.184 Y115.044 I1.227 J-.595 E.0379
; WIPE_START
G1 X112.182 Y116.236 E-.45289
G1 X112.081 Y115.953 E-.11454
G1 X112.046 Y115.573 E-.14496
G1 X112.077 Y115.451 E-.04762
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1.8 I-.069 J1.215 P1  F30000
G1 X143.347 Y117.229 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Support interface
G1 F4800
G1 X138.648 Y117.229 E.14438
G3 X138.472 Y116.352 I1.165 J-.69 E.02801
G1 X143.475 Y116.352 E.15372
G1 X143.478 Y115.635 E.02205
G1 X143.474 Y115.475 E.0049
G1 X138.473 Y115.475 E.15366
G3 X138.669 Y114.598 I2.814 J.17 E.02774
G1 X143.443 Y114.598 E.14667
; WIPE_START
; WIPE_END
G1 E-.8 F1800
G17
G3 Z1.8 I-1.124 J-.467 P1  F30000
G1 X138.139 Y127.373 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F10631
G1 X138.317 Y127.075 E.01151
G2 X138.454 Y126.687 I-1.639 J-.796 E.0137
G2 X138.546 Y125.871 I-3.246 J-.779 E.02729
G3 X138.557 Y123.862 I91.702 J-.496 E.06667
G1 X138.57 Y118.92 E.16392
G1 X142.537 Y118.931 E.1316
G1 X142.505 Y131.203 E.40711
G3 X142.436 Y132.061 I-5.021 J.033 E.02859
G1 X113.536 Y131.985 E.95869
G3 X113.472 Y131.126 I4.951 J-.798 E.02858
G1 X113.507 Y118.854 E.40711
G1 X117.472 Y118.864 E.13153
G1 X117.459 Y123.806 E.16392
G2 X117.479 Y126.236 I90.674 J.46 E.08062
G2 X117.878 Y127.352 I2.455 J-.247 E.03972
G2 X118.853 Y127.988 I1.521 J-1.269 E.03919
G2 X119.66 Y128.086 I.775 J-3 E.02705
G1 X136.333 Y128.13 E.55309
G2 X137.512 Y127.899 I.024 J-3 E.04011
G2 X138.1 Y127.419 I-.834 J-1.62 E.02539
M204 S250
G1 X137.801 Y127.161 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F10631
M204 S5000
G2 X138.074 Y126.587 I-1.128 J-.888 E.01972
G2 X138.154 Y125.86 I-2.891 J-.688 E.0225
G3 X138.165 Y123.859 I91.418 J-.493 E.06151
G1 X138.179 Y118.527 E.16382
G1 X142.93 Y118.54 E.146
G1 X142.897 Y131.212 E.38938
G3 X142.735 Y132.498 I-5.097 J.015 E.03995
G3 X142.06 Y133.514 I-1.894 J-.527 E.03812
G1 X142.039 Y133.532 E.00084
G1 X141.771 Y133.691 E.00958
G1 X141.769 Y133.692 E.00006
G1 X141.746 Y133.692 E.0007
G1 X114.217 Y133.619 E.8459
G1 X114.194 Y133.619 E.0007
G1 X114.193 Y133.618 E.00006
G1 X113.925 Y133.457 E.00959
G1 X113.905 Y133.439 E.00084
G3 X113.234 Y132.42 I1.226 J-1.536 E.03812
G3 X113.08 Y131.132 I4.943 J-1.245 E.03995
G1 X113.116 Y118.46 E.38938
G1 X117.865 Y118.473 E.14593
G1 X117.851 Y123.805 E.16384
G2 X117.869 Y126.193 I95.536 J.448 E.07338
G2 X118.192 Y127.114 I2.023 J-.192 E.03027
G2 X118.959 Y127.609 I1.185 J-.994 E.02847
G2 X119.671 Y127.694 I.678 J-2.65 E.02211
G1 X136.324 Y127.738 E.51168
G2 X137.337 Y127.546 I.036 J-2.578 E.03191
G2 X137.763 Y127.208 I-.665 J-1.273 E.0168
; WIPE_START
G1 F12000
M204 S10000
G1 X137.96 Y126.908 E-.13643
G1 X138.074 Y126.587 E-.12953
G1 X138.134 Y126.247 E-.13113
G1 X138.154 Y125.86 E-.14698
G1 X138.157 Y125.292 E-.21593
; WIPE_END
G1 E-.04 F1800
G1 X142.113 Y131.082 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F10631
G1 X142.114 Y130.496 E.01801
G1 X113.866 Y130.415 E.86796
G2 X113.894 Y131.593 I9.148 J.377 E.03625
G1 X142.081 Y131.668 E.86609
G1 X142.109 Y131.142 E.0162
G1 X141.725 Y131.081 F30000
; LINE_WIDTH: 0.442172
G1 F10631
G1 X141.726 Y130.882 E.00647
G1 X114.254 Y130.805 E.89377
G1 X114.259 Y131.206 E.01304
G1 X141.718 Y131.28 E.89335
G1 X141.723 Y131.141 E.00452
; WIPE_START
G1 F12000
G1 X141.718 Y131.28 E-.05283
G1 X139.857 Y131.275 E-.70717
; WIPE_END
G1 E-.04 F1800
G1 X142.015 Y132.283 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F10631
M204 S2000
G1 X142.436 Y132.704 E.01831
G1 X142.239 Y133.041
G1 X141.48 Y132.281 E.03299
G1 X140.946 Y132.28
G1 X141.977 Y133.312 E.04483
G1 X141.617 Y133.484
G1 X140.411 Y132.279 E.05239
G1 X139.876 Y132.277
G1 X141.082 Y133.483 E.05239
G1 X140.547 Y133.481
G1 X139.342 Y132.276 E.05239
G1 X138.807 Y132.274
G1 X140.013 Y133.48 E.05239
G1 X139.478 Y133.478
G1 X138.272 Y132.273 E.05239
G1 X137.738 Y132.271
G1 X138.943 Y133.477 E.05239
G1 X138.408 Y133.476
G1 X137.203 Y132.27 E.05239
G1 X136.668 Y132.269
G1 X137.874 Y133.474 E.05239
G1 X137.339 Y133.473
G1 X136.134 Y132.267 E.05239
G1 X135.599 Y132.266
G1 X136.804 Y133.471 E.05239
G1 X136.27 Y133.47
G1 X135.064 Y132.264 E.05239
G1 X134.53 Y132.263
G1 X135.735 Y133.468 E.05239
G1 X135.2 Y133.467
G1 X133.995 Y132.261 E.05239
G1 X133.46 Y132.26
G1 X134.666 Y133.466 E.05239
G1 X134.131 Y133.464
G1 X132.925 Y132.259 E.05239
G1 X132.391 Y132.257
G1 X133.596 Y133.463 E.05239
G1 X133.062 Y133.461
G1 X131.856 Y132.256 E.05239
G1 X131.321 Y132.254
G1 X132.527 Y133.46 E.05239
G1 X131.992 Y133.459
G1 X130.787 Y132.253 E.05239
G1 X130.252 Y132.252
G1 X131.458 Y133.457 E.05239
G1 X130.923 Y133.456
G1 X129.717 Y132.25 E.05239
G1 X129.183 Y132.249
G1 X130.388 Y133.454 E.05239
G1 X129.854 Y133.453
G1 X128.648 Y132.247 E.05239
G1 X128.113 Y132.246
G1 X129.319 Y133.451 E.05239
G1 X128.784 Y133.45
G1 X127.579 Y132.244 E.05239
G1 X127.044 Y132.243
G1 X128.25 Y133.449 E.05239
G1 X127.715 Y133.447
G1 X126.509 Y132.242 E.05239
G1 X125.975 Y132.24
G1 X127.18 Y133.446 E.05239
G1 X126.646 Y133.444
G1 X125.44 Y132.239 E.05239
G1 X124.905 Y132.237
G1 X126.111 Y133.443 E.05239
G1 X125.576 Y133.441
G1 X124.371 Y132.236 E.05239
G1 X123.836 Y132.234
G1 X125.042 Y133.44 E.05239
G1 X124.507 Y133.439
G1 X123.301 Y132.233 E.05239
G1 X122.767 Y132.232
G1 X123.972 Y133.437 E.05239
G1 X123.437 Y133.436
G1 X122.232 Y132.23 E.05239
G1 X121.697 Y132.229
G1 X122.903 Y133.434 E.05239
G1 X122.368 Y133.433
G1 X121.163 Y132.227 E.05239
G1 X120.628 Y132.226
G1 X121.833 Y133.432 E.05239
G1 X121.299 Y133.43
G1 X120.093 Y132.224 E.05239
G1 X119.558 Y132.223
G1 X120.764 Y133.429 E.05239
G1 X120.229 Y133.427
G1 X119.024 Y132.222 E.05239
G1 X118.489 Y132.22
G1 X119.695 Y133.426 E.05239
G1 X119.16 Y133.424
G1 X117.954 Y132.219 E.05239
G1 X117.42 Y132.217
G1 X118.625 Y133.423 E.05239
G1 X118.091 Y133.422
G1 X116.885 Y132.216 E.05239
G1 X116.35 Y132.215
G1 X117.556 Y133.42 E.05239
G1 X117.021 Y133.419
G1 X115.816 Y132.213 E.05239
G1 X115.281 Y132.212
G1 X116.487 Y133.417 E.05239
G1 X115.952 Y133.416
G1 X114.746 Y132.21 E.05239
G1 X114.212 Y132.209
G1 X115.417 Y133.414 E.05239
G1 X114.883 Y133.413
G1 X113.677 Y132.207 E.05239
; WIPE_START
G1 F12000
M204 S10000
G1 X114.883 Y133.413 E-.6479
G1 X115.178 Y133.414 E-.1121
; WIPE_END
G1 E-.04 F1800
G1 X114.471 Y133.431 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.353444
G1 F10631
G1 X114.135 Y133.168 E.01079
; LINE_WIDTH: 0.382795
G3 X113.802 Y132.829 I1.727 J-2.025 E.01318
; LINE_WIDTH: 0.348716
G1 X113.591 Y132.548 E.00876
; LINE_WIDTH: 0.311445
G1 X113.379 Y132.267 E.00769
; WIPE_START
G1 F15000
G1 X113.591 Y132.548 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X114.48 Y124.968 Z1.8 F30000
G1 X115.156 Y119.206 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F10631
G1 X113.854 Y119.203 E.04319
G1 X113.853 Y119.529 E.01083
G1 X117.116 Y122.792 E.15308
G1 X117.119 Y121.529 E.04189
G1 X113.838 Y124.81 E.15389
G1 X113.832 Y127.183 E.07874
G1 X116.679 Y130.031 E.13358
G1 X116.294 Y130.03 E.01276
G1 X118.226 Y128.098 E.09062
G2 X119.65 Y128.434 I1.706 J-4.044 E.04875
G1 X122.767 Y128.442 E.1034
G1 X124.377 Y130.053 E.07556
G1 X123.948 Y130.052 E.01423
G1 X125.55 Y128.45 E.07515
G1 X130.463 Y128.463 E.16297
G1 X132.075 Y130.075 E.07563
G1 X131.602 Y130.074 E.01569
G1 X133.206 Y128.47 E.07523
G2 X136.784 Y128.456 I1.657 J-33.61 E.11874
G2 X137.803 Y128.127 I-.3 J-2.674 E.03577
G1 X139.773 Y130.097 E.09242
G1 X139.256 Y130.096 E.01715
G1 X142.167 Y127.185 E.13655
G1 X142.173 Y124.821 E.07841
G1 X138.909 Y121.557 E.15312
G1 X138.905 Y122.771 E.04026
G1 X142.187 Y119.489 E.15398
G1 X142.188 Y119.278 E.00698
G1 X140.77 Y119.274 E.04703
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X142.188 Y119.278 E-.53876
G1 X142.187 Y119.489 E-.08001
G1 X141.925 Y119.751 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 8/118
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
G17
G3 Z1.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X142.91 Y117.744
G1 Z1.6
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F4800
G1 X142.91 Y114.354 E.10416
G2 X142.033 Y114.405 I-.388 J.887 E.02802
G1 X142.033 Y117.524 E.09582
G1 X141.156 Y117.521 E.02695
G1 X141.156 Y114.762 E.0848
G1 X140.663 Y114.76 E.01514
G2 X140.279 Y114.304 I-.847 J.323 E.01869
G1 X140.279 Y117.519 E.0988
G2 X139.76 Y117.659 I.04 J1.179 E.01666
G3 X139.402 Y117.641 I-.152 J-.556 E.0112
G1 X139.402 Y114.103 E.10872
G2 X138.525 Y114.669 I.064 J1.062 E.03352
G1 X138.525 Y117.371 E.08302
; WIPE_START
; WIPE_END
G1 E-.8 F1800
G17
G3 Z2 I.034 J-1.216 P1  F30000
G1 X117.475 Y116.788 Z2
M73 P47 R9
G1 Z1.6
G1 E.8 F1800
G1 F4800
G1 X117.475 Y114.86 E.05926
G2 X116.598 Y114.128 I-1.285 J.65 E.03608
G1 X116.598 Y117.456 E.10224
G1 X115.721 Y117.453 E.02695
G1 X115.721 Y114.12 E.10244
G2 X114.852 Y113.888 I-6.062 J21.014 E.02763
G1 X114.844 Y117.451 E.10948
G1 X113.967 Y117.449 E.02695
G1 X113.967 Y114.012 E.10562
G2 X113.09 Y113.968 I-.482 J.857 E.02797
G1 X113.09 Y117.646 E.11299
; WIPE_START
; WIPE_END
G1 E-.8 F1800
G17
G3 Z2 I-.443 J1.134 P1  F30000
G1 X138.139 Y127.426 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F9548
G1 X138.321 Y127.121 E.01181
G2 X138.452 Y126.748 I-1.636 J-.782 E.01312
G2 X138.546 Y125.924 I-3.242 J-.787 E.02757
G1 X138.565 Y118.92 E.23235
G1 X142.537 Y118.93 E.13178
G1 X142.504 Y131.297 E.41023
G1 X113.472 Y131.22 E.96306
G1 X113.505 Y118.853 E.41023
G1 X117.477 Y118.864 E.13178
G1 X117.459 Y125.868 E.23234
G2 X117.683 Y127.076 I3.176 J.036 E.04101
G2 X118.852 Y128.041 I1.602 J-.75 E.05199
G2 X119.66 Y128.139 I.775 J-3.002 E.02705
G1 X136.333 Y128.183 E.55309
G2 X137.512 Y127.953 I.025 J-3 E.04011
G2 X138.101 Y127.472 I-.826 J-1.614 E.0254
M204 S250
G1 X137.808 Y127.216 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9548
M204 S5000
G1 X137.965 Y126.954 E.00939
G2 X138.072 Y126.648 I-1.285 J-.622 E.00997
G2 X138.154 Y125.913 I-2.892 J-.696 E.02277
G1 X138.173 Y118.527 E.22697
G1 X142.93 Y118.539 E.14616
G1 X142.896 Y131.265 E.39102
G3 X142.735 Y132.552 I-5.097 J.015 E.03995
G3 X142.583 Y132.93 I-1.311 J-.308 E.01257
G1 X113.384 Y132.852 E.89721
G3 X113.096 Y131.669 I3.04 J-1.367 E.03762
G1 X113.08 Y131.186 E.01486
G1 X113.114 Y118.46 E.39102
G1 X117.871 Y118.473 E.14616
G1 X117.851 Y125.859 E.22697
G2 X118.04 Y126.91 I2.753 J.047 E.03302
G2 X118.959 Y127.662 I1.251 J-.591 E.03769
G2 X119.671 Y127.747 I.678 J-2.65 E.02211
G1 X136.324 Y127.791 E.51168
G2 X137.337 Y127.599 I.036 J-2.577 E.03191
G2 X137.767 Y127.256 I-.658 J-1.267 E.01702
; WIPE_START
G1 F12000
M204 S10000
G1 X137.965 Y126.954 E-.13724
G1 X138.072 Y126.648 E-.123
G1 X138.134 Y126.301 E-.13417
G1 X138.154 Y125.913 E-.14728
G1 X138.155 Y125.339 E-.21829
; WIPE_END
G1 E-.04 F1800
G1 X142.106 Y130.7 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.436962
G1 F9548
G1 X142.107 Y130.504 E.0063
G1 X113.875 Y130.424 E.90649
G1 X113.874 Y130.82 E.0127
G1 X142.106 Y130.896 E.90649
G1 X142.106 Y130.76 E.00438
; WIPE_START
G1 F12000
G1 X142.106 Y130.896 E-.05179
G1 X140.242 Y130.891 E-.70822
; WIPE_END
G1 E-.04 F1800
G1 X141.81 Y132.72 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F9548
M204 S2000
G1 X142.652 Y131.878 E.03658
G1 X142.478 Y131.52
G1 X141.278 Y132.719 E.05211
G1 X140.747 Y132.717
G1 X141.946 Y131.518 E.05211
G1 X141.414 Y131.517
G1 X140.215 Y132.716 E.05211
G1 X139.683 Y132.715
G1 X140.882 Y131.515 E.05211
G1 X140.35 Y131.514
G1 X139.151 Y132.713 E.05211
G1 X138.619 Y132.712
G1 X139.818 Y131.512 E.05211
G1 X139.286 Y131.511
G1 X138.087 Y132.71 E.05211
G1 X137.555 Y132.709
G1 X138.755 Y131.51 E.05211
G1 X138.223 Y131.508
G1 X137.024 Y132.707 E.05211
G1 X136.492 Y132.706
G1 X137.691 Y131.507 E.05211
G1 X137.159 Y131.505
G1 X135.96 Y132.705 E.05211
G1 X135.428 Y132.703
G1 X136.627 Y131.504 E.05211
G1 X136.095 Y131.503
G1 X134.896 Y132.702 E.05211
G1 X134.364 Y132.7
G1 X135.564 Y131.501 E.05211
G1 X135.032 Y131.5
G1 X133.833 Y132.699 E.05211
G1 X133.301 Y132.698
G1 X134.5 Y131.498 E.05211
G1 X133.968 Y131.497
G1 X132.769 Y132.696 E.05211
G1 X132.237 Y132.695
G1 X133.436 Y131.496 E.05211
G1 X132.904 Y131.494
G1 X131.705 Y132.693 E.05211
G1 X131.173 Y132.692
G1 X132.373 Y131.493 E.05211
G1 X131.841 Y131.491
G1 X130.641 Y132.69 E.05211
G1 X130.11 Y132.689
G1 X131.309 Y131.49 E.05211
G1 X130.777 Y131.488
G1 X129.578 Y132.688 E.05211
G1 X129.046 Y132.686
G1 X130.245 Y131.487 E.05211
G1 X129.713 Y131.486
G1 X128.514 Y132.685 E.05211
G1 X127.982 Y132.683
G1 X129.181 Y131.484 E.05211
G1 X128.65 Y131.483
G1 X127.45 Y132.682 E.05211
G1 X126.919 Y132.681
G1 X128.118 Y131.481 E.05211
G1 X127.586 Y131.48
G1 X126.387 Y132.679 E.05211
G1 X125.855 Y132.678
G1 X127.054 Y131.479 E.05211
G1 X126.522 Y131.477
G1 X125.323 Y132.676 E.05211
G1 X124.791 Y132.675
G1 X125.99 Y131.476 E.05211
G1 X125.459 Y131.474
G1 X124.259 Y132.674 E.05211
G1 X123.728 Y132.672
G1 X124.927 Y131.473 E.05211
G1 X124.395 Y131.471
G1 X123.196 Y132.671 E.05211
G1 X122.664 Y132.669
G1 X123.863 Y131.47 E.05211
G1 X123.331 Y131.469
G1 X122.132 Y132.668 E.05211
G1 X121.6 Y132.666
G1 X122.799 Y131.467 E.05211
G1 X122.267 Y131.466
G1 X121.068 Y132.665 E.05211
G1 X120.536 Y132.664
G1 X121.736 Y131.464 E.05211
G1 X121.204 Y131.463
G1 X120.005 Y132.662 E.05211
G1 X119.473 Y132.661
G1 X120.672 Y131.462 E.05211
G1 X120.14 Y131.46
G1 X118.941 Y132.659 E.05211
G1 X118.409 Y132.658
G1 X119.608 Y131.459 E.05211
G1 X119.076 Y131.457
G1 X117.877 Y132.657 E.05211
G1 X117.345 Y132.655
G1 X118.545 Y131.456 E.05211
G1 X118.013 Y131.455
G1 X116.814 Y132.654 E.05211
G1 X116.282 Y132.652
G1 X117.481 Y131.453 E.05211
G1 X116.949 Y131.452
G1 X115.75 Y132.651 E.05211
G1 X115.218 Y132.649
G1 X116.417 Y131.45 E.05211
G1 X115.885 Y131.449
G1 X114.686 Y132.648 E.05211
G1 X114.154 Y132.647
G1 X115.354 Y131.447 E.05211
G1 X114.822 Y131.446
G1 X113.623 Y132.645 E.05211
G1 X113.412 Y132.322
G1 X114.29 Y131.445 E.03813
G1 X113.758 Y131.443
G1 X113.33 Y131.872 E.01861
M204 S10000
G1 X132.53 Y131.601 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.112088
G1 F9548
G1 X132.403 Y131.474 E.00102
G1 X134.741 Y131.523 F30000
; LINE_WIDTH: 0.129901
G1 F9548
G1 X134.525 Y131.523 E.00154
G1 X136.88 Y131.518 F30000
; LINE_WIDTH: 0.107854
G1 F9548
G1 X136.641 Y131.518 E.00126
; WIPE_START
G1 F15000
G1 X136.88 Y131.518 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X139.191 Y124.244 Z2 F30000
G1 X140.77 Y119.274 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F9548
G1 X142.188 Y119.278 E.04702
G1 X142.187 Y119.489 E.00699
G1 X138.903 Y122.773 E.1541
G1 X138.906 Y121.554 E.04046
G1 X142.173 Y124.821 E.15328
G1 X142.167 Y127.185 E.07841
G1 X139.256 Y130.096 E.13655
G1 X139.773 Y130.097 E.01715
G1 X137.836 Y128.16 E.09089
G3 X136.341 Y128.532 I-1.681 J-3.565 E.05142
G1 X133.153 Y128.523 E.10577
G1 X131.602 Y130.074 E.07274
G1 X132.075 Y130.075 E.01569
G1 X130.516 Y128.516 E.07313
G1 X125.497 Y128.503 E.1665
G1 X123.948 Y130.052 E.07266
G1 X124.377 Y130.053 E.01423
G1 X122.82 Y128.496 E.07305
G3 X119.207 Y128.463 I-1.495 J-33.915 E.1199
G3 X118.193 Y128.131 I.316 J-2.679 E.03563
G1 X116.294 Y130.03 E.08909
G1 X116.679 Y130.031 E.01276
G1 X113.831 Y127.183 E.13361
G1 X113.837 Y124.811 E.07868
G1 X117.122 Y121.526 E.1541
G1 X117.119 Y122.795 E.04208
G1 X113.851 Y119.527 E.15328
G1 X113.852 Y119.202 E.01078
G1 X115.156 Y119.206 E.04324
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X113.852 Y119.202 E-.49533
G1 X113.851 Y119.527 E-.12344
G1 X114.114 Y119.79 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 9/118
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
G17
G3 Z2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X114.153 Y117.229
G1 Z1.8
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F4800
G1 X112.722 Y117.229 E.04398
G3 X112.636 Y116.986 I.429 J-.289 E.00802
G3 X112.405 Y116.356 I.926 J-.697 E.0209
G1 X114.054 Y116.352 E.05067
G1 X114.054 Y115.584 E.02361
G1 X114.12 Y115.475 E.00391
G1 X112.401 Y115.475 E.05284
G3 X112.442 Y114.975 I.587 J-.204 E.01589
G2 X112.604 Y114.598 I-.463 J-.423 E.01283
G1 X117.457 Y114.598 E.14911
G1 X117.815 Y115.475 F30000
G1 F4800
G1 X116.117 Y115.475 E.05217
G1 X116.112 Y116.352 E.02695
G1 X117.584 Y116.352 E.04521
G3 X116.743 Y116.84 I-.853 J-.501 E.03122
G3 X116.738 Y117.229 I-3.246 J.157 E.01197
G1 X116.343 Y117.229 E.01216
; WIPE_START
; WIPE_END
G1 E-.8 F1800
G17
G3 Z2.2 I0 J1.217 P1  F30000
G1 X140.113 Y117.229 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F4800
G1 X138.636 Y117.229 E.04538
G3 X138.527 Y116.352 I1.353 J-.613 E.02757
G1 X139.943 Y116.352 E.0435
G1 X139.943 Y115.6 E.02312
G1 X140.029 Y115.475 E.00466
G1 X138.47 Y115.475 E.04789
G1 X138.501 Y115.363 E.00359
G3 X138.6 Y114.598 I1.324 J-.217 E.02403
G1 X143.405 Y114.598 E.14762
G1 X143.696 Y115.475 F30000
G1 F4800
G1 X141.939 Y115.475 E.05397
G1 X142.001 Y115.539 E.00273
G1 X142.003 Y116.352 E.02497
G1 X143.652 Y116.352 E.05067
G2 X143.278 Y117.179 I658.393 J298.639 E.0279
G1 X143.241 Y117.229 E.0019
G1 X142.091 Y117.229 E.03535
; WIPE_START
; WIPE_END
G1 E-.8 F1800
G17
G3 Z2.2 I-1.135 J-.44 P1  F30000
G1 X138.092 Y127.54 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F7695
G1 X138.114 Y127.509 E.00127
G2 X138.452 Y126.802 I-1.428 J-1.116 E.02619
G2 X138.546 Y125.977 I-3.232 J-.787 E.02761
G1 X138.565 Y118.92 E.23412
G1 X142.537 Y118.93 E.13178
G1 X142.506 Y130.533 E.38488
G1 X113.474 Y130.449 E.96306
G1 X113.505 Y118.853 E.38467
G1 X117.477 Y118.863 E.13178
G1 X117.459 Y125.921 E.23411
G2 X117.677 Y127.119 I3.232 J.031 E.04063
G2 X118.852 Y128.094 I1.609 J-.743 E.05239
G2 X119.66 Y128.192 I.775 J-2.999 E.02705
G1 X136.333 Y128.237 E.55309
G2 X137.511 Y128.006 I.025 J-3 E.04011
G2 X137.84 Y127.79 I-.825 J-1.614 E.01306
G1 X138.05 Y127.582 E.00979
M204 S250
G1 X137.809 Y127.267 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F7695
M204 S5000
G1 X137.964 Y127.007 E.00932
G2 X138.071 Y126.702 I-1.285 J-.621 E.00994
G2 X138.154 Y125.966 I-2.884 J-.696 E.0228
G1 X138.173 Y118.526 E.22861
G1 X142.93 Y118.539 E.14616
G1 X142.896 Y131.318 E.39267
G3 X142.832 Y132.166 I-4.951 J.048 E.02615
G1 X113.14 Y132.087 E.91234
G3 X113.08 Y131.239 I4.893 J-.774 E.02615
G1 X113.114 Y118.46 E.39267
G1 X117.871 Y118.472 E.14616
G1 X117.851 Y125.912 E.22861
G2 X118.034 Y126.954 I2.81 J.041 E.03269
G2 X118.958 Y127.715 I1.258 J-.585 E.03804
G2 X119.671 Y127.8 I.678 J-2.648 E.02211
G1 X136.323 Y127.845 E.51168
G2 X137.337 Y127.653 I.036 J-2.578 E.03191
G2 X137.768 Y127.309 I-.657 J-1.267 E.01706
; WIPE_START
G1 F12000
M204 S10000
G1 X137.964 Y127.007 E-.13679
G1 X138.071 Y126.702 E-.1227
G1 X138.133 Y126.354 E-.13423
G1 X138.154 Y125.966 E-.1476
G1 X138.155 Y125.391 E-.21868
; WIPE_END
G1 E-.04 F1800
G1 X142.086 Y130.754 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Top surface
M73 P48 R9
G1 F7695
M204 S2000
G1 X142.687 Y131.355 E.02613
G1 X142.661 Y131.862
G1 X141.551 Y130.753 E.04821
G1 X141.017 Y130.751
G1 X142.222 Y131.957 E.05239
G1 X141.688 Y131.955
G1 X140.482 Y130.75 E.05239
G1 X139.947 Y130.748
G1 X141.153 Y131.954 E.05239
G1 X140.618 Y131.953
G1 X139.413 Y130.747 E.05239
G1 X138.878 Y130.746
G1 X140.084 Y131.951 E.05239
G1 X139.549 Y131.95
G1 X138.343 Y130.744 E.05239
G1 X137.809 Y130.743
G1 X139.014 Y131.948 E.05239
G1 X138.48 Y131.947
G1 X137.274 Y130.741 E.05239
G1 X136.739 Y130.74
G1 X137.945 Y131.945 E.05239
G1 X137.41 Y131.944
G1 X136.205 Y130.738 E.05239
G1 X135.67 Y130.737
G1 X136.875 Y131.943 E.05239
G1 X136.341 Y131.941
G1 X135.135 Y130.736 E.05239
G1 X134.601 Y130.734
G1 X135.806 Y131.94 E.05239
G1 X135.271 Y131.938
G1 X134.066 Y130.733 E.05239
G1 X133.531 Y130.731
G1 X134.737 Y131.937 E.05239
G1 X134.202 Y131.935
G1 X132.997 Y130.73 E.05239
G1 X132.462 Y130.728
G1 X133.667 Y131.934 E.05239
G1 X133.133 Y131.933
G1 X131.927 Y130.727 E.05239
G1 X131.392 Y130.726
G1 X132.598 Y131.931 E.05239
G1 X132.063 Y131.93
G1 X130.858 Y130.724 E.05239
G1 X130.323 Y130.723
G1 X131.529 Y131.928 E.05239
G1 X130.994 Y131.927
G1 X129.788 Y130.721 E.05239
G1 X129.254 Y130.72
G1 X130.459 Y131.926 E.05239
G1 X129.925 Y131.924
G1 X128.719 Y130.719 E.05239
G1 X128.184 Y130.717
G1 X129.39 Y131.923 E.0524
G1 X128.855 Y131.921
G1 X127.649 Y130.715 E.05241
G1 X127.114 Y130.714
G1 X128.321 Y131.92 E.05242
G1 X127.786 Y131.918
G1 X126.579 Y130.712 E.05243
G1 X126.045 Y130.71
G1 X127.251 Y131.917 E.05244
G1 X126.717 Y131.916
G1 X125.51 Y130.709 E.05245
G1 X124.975 Y130.707
G1 X126.182 Y131.914 E.05246
G1 X125.647 Y131.913
G1 X124.44 Y130.705 E.05246
G1 X123.905 Y130.704
G1 X125.113 Y131.911 E.05247
G1 X124.578 Y131.91
G1 X123.37 Y130.702 E.05248
G1 X122.835 Y130.7
G1 X124.043 Y131.908 E.05249
G1 X123.509 Y131.907
G1 X122.3 Y130.699 E.0525
G1 X121.765 Y130.697
G1 X122.974 Y131.906 E.05251
G1 X122.439 Y131.904
G1 X121.23 Y130.696 E.05252
G1 X120.696 Y130.694
G1 X121.904 Y131.903 E.05253
G1 X121.37 Y131.901
G1 X120.161 Y130.692 E.05254
G1 X119.626 Y130.691
G1 X120.835 Y131.9 E.05255
G1 X120.3 Y131.899
G1 X119.091 Y130.689 E.05256
G1 X118.556 Y130.687
G1 X119.766 Y131.897 E.05257
G1 X119.231 Y131.896
G1 X118.021 Y130.686 E.05258
G1 X117.486 Y130.684
G1 X118.696 Y131.894 E.05259
G1 X118.162 Y131.893
G1 X116.951 Y130.682 E.0526
G1 X116.416 Y130.681
G1 X117.627 Y131.891 E.05261
G1 X117.092 Y131.89
G1 X115.881 Y130.679 E.05262
G1 X115.347 Y130.677
G1 X116.558 Y131.889 E.05263
G1 X116.023 Y131.887
G1 X114.812 Y130.676 E.05264
G1 X114.277 Y130.674
G1 X115.488 Y131.886 E.05265
G1 X114.954 Y131.884
G1 X113.742 Y130.673 E.05266
G1 X113.289 Y130.752
G1 X114.419 Y131.883 E.04912
G1 X113.884 Y131.881
G1 X113.289 Y131.286 E.02587
; WIPE_START
G1 F12000
M204 S10000
G1 X113.884 Y131.881 E-.31994
G1 X114.419 Y131.883 E-.20318
G1 X113.978 Y131.442 E-.23688
; WIPE_END
G1 E-.04 F1800
G1 X114.709 Y123.845 Z2.2 F30000
G1 X115.155 Y119.206 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F7695
G1 X113.852 Y119.202 E.04323
G1 X113.851 Y119.527 E.01079
G1 X117.119 Y122.795 E.15328
G1 X117.122 Y121.526 E.04208
G1 X113.837 Y124.811 E.1541
G1 X113.831 Y127.183 E.07868
G1 X116.759 Y130.11 E.13734
G1 X116.215 Y130.109 E.01802
G1 X118.161 Y128.163 E.09127
G2 X119.649 Y128.541 I1.699 J-3.575 E.05126
G1 X122.873 Y128.549 E.10695
G1 X124.457 Y130.133 E.07428
G1 X123.869 Y130.131 E.01949
G1 X125.444 Y128.556 E.07388
G1 X130.57 Y128.57 E.17003
G1 X132.155 Y130.155 E.07435
G1 X131.523 Y130.153 E.02095
G1 X133.1 Y128.576 E.07395
G2 X136.783 Y128.563 I1.713 J-34.588 E.12226
G2 X137.868 Y128.192 I-.282 J-2.599 E.03834
G1 X139.853 Y130.177 E.0931
G1 X139.177 Y130.175 E.02241
G1 X142.167 Y127.185 E.14026
G1 X142.173 Y124.821 E.07841
G1 X138.906 Y121.554 E.15328
G1 X138.903 Y122.773 E.04046
G1 X142.187 Y119.489 E.1541
G1 X142.188 Y119.277 E.007
G1 X140.771 Y119.274 E.04701
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X142.188 Y119.277 E-.53852
G1 X142.187 Y119.489 E-.08024
G1 X141.925 Y119.751 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 10/118
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
G17
G3 Z2.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X142.91 Y117.855
G1 Z2
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 F4800
G1 X142.91 Y114.489 E.10341
G2 X142.595 Y114.384 I-.286 J.331 E.01049
G1 X142.033 Y114.43 E.01731
G1 X142.033 Y115.209 E.02395
G1 X141.705 Y114.976 E.01238
G1 X141.156 Y114.946 E.01688
G1 X141.156 Y114.425 E.016
; WIPE_START
; WIPE_END
G1 E-.8 F1800
G17
G3 Z2.4 I-.77 J-.942 P1  F30000
G1 X140.279 Y115.142 Z2.4
G1 Z2
G1 E.8 F1800
G1 F4800
G1 X140.279 Y114.565 E.01773
G2 X139.402 Y114.246 I-1.271 J2.129 E.02885
G1 X139.402 Y117.733 E.10716
; WIPE_START
; WIPE_END
G1 E-.8 F1800
G17
G3 Z2.4 I.06 J-1.215 P1  F30000
G1 X117.475 Y116.642 Z2.4
G1 Z2
G1 E.8 F1800
G1 F4800
G1 X117.475 Y115.42 E.03756
G2 X116.948 Y114.612 I-.975 J.06 E.03101
G2 X116.598 Y114.301 I-.428 J.129 E.01513
G1 X116.598 Y116.715 E.07419
G3 X116.386 Y116.701 I-.043 J-.942 E.00653
G1 X116.391 Y115.547 E.03546
G1 X116.197 Y115.1 E.01499
G1 X115.721 Y114.913 E.01571
G1 X115.721 Y114.134 E.02394
G2 X114.844 Y114.001 I-1.271 J5.434 E.02729
G1 X114.844 Y114.905 E.02775
G2 X114.002 Y115.036 I-.166 J1.701 E.02647
G1 X113.967 Y115.117 E.0027
G1 X113.967 Y114.055 E.03262
G2 X113.09 Y114.074 I-.41 J1.322 E.02743
G1 X113.09 Y117.861 E.11634
; WIPE_START
; WIPE_END
G1 E-.8 F1800
G17
G3 Z2.4 I-.441 J1.134 P1  F30000
G1 X138.092 Y127.593 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F15978
G1 X138.114 Y127.562 E.00127
G2 X138.451 Y126.855 I-1.428 J-1.116 E.02618
G2 X138.546 Y126.03 I-3.229 J-.787 E.02762
G1 X138.565 Y118.919 E.23589
G1 X140.039 Y118.923 E.04891
G1 X140.439 Y118.924 E.01327
G1 F14772.344
G1 X140.839 Y118.925 E.01327
G1 F6987.99
G1 X140.839 Y118.506 E.01391
G1 F1920
G1 X140.839 Y118.124 E.01269
; FEATURE: Overhang wall
G1 F600
M204 S5000
G1 X140.838 Y115.974 E.0713
G1 X141.11 Y115.975 E.00902
G1 X141.099 Y118.124 E.0713
; FEATURE: Inner wall
G1 F1920
M204 S10000
G1 X141.096 Y118.507 E.01269
G1 F6987.924
G1 X141.094 Y118.926 E.01391
G1 F14772.247
G1 X141.494 Y118.927 E.01327
G1 F15978
G1 X141.894 Y118.928 E.01327
G1 X142.537 Y118.93 E.02133
G1 X142.505 Y131.008 E.40067
G1 X113.473 Y130.925 E.96306
G1 X113.505 Y118.853 E.40046
G1 X114.147 Y118.854 E.02131
G1 X114.547 Y118.855 E.01327
G1 F14771.654
G1 X114.947 Y118.856 E.01327
G1 F6987.516
G1 X114.948 Y118.437 E.01391
G1 F1920
G1 X114.948 Y118.055 E.01269
; FEATURE: Overhang wall
G1 F600
M204 S5000
G1 X114.949 Y115.905 E.0713
G1 X115.22 Y115.906 E.00896
G1 F3000
G1 X115.208 Y118.055 E.0713
; FEATURE: Inner wall
G1 F1920
M204 S10000
G1 X115.205 Y118.438 E.01269
G1 F6987.3
G1 X115.203 Y118.857 E.01391
G1 F14771.341
G1 X115.603 Y118.858 E.01327
G1 F15978
G1 X116.003 Y118.859 E.01327
G1 X117.477 Y118.863 E.04891
G1 X117.459 Y125.974 E.23588
G2 X117.676 Y127.172 I3.231 J.031 E.04064
G2 X118.852 Y128.147 I1.609 J-.743 E.05239
G2 X119.659 Y128.246 I.775 J-3 E.02705
G1 X136.333 Y128.29 E.55309
G2 X137.511 Y128.059 I.025 J-3 E.04011
G2 X137.84 Y127.843 I-.826 J-1.614 E.01306
G1 X138.05 Y127.635 E.0098
M204 S250
G1 X137.81 Y127.319 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X137.964 Y127.06 E.00928
G2 X138.071 Y126.755 I-1.285 J-.621 E.00993
G2 X138.154 Y126.019 I-2.881 J-.696 E.02282
G1 X138.173 Y118.526 E.23025
G1 X139.647 Y118.53 E.04527
G1 X140.047 Y118.531 E.01229
G1 F7331.859
G1 X140.447 Y118.532 E.01229
G1 F2273.282
G1 X140.447 Y118.491 E.00125
G1 F1920
G1 X140.447 Y118.122 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X140.446 Y115.581 E.08431
G1 X141.504 Y115.584 E.0351
G1 X141.491 Y118.125 E.08431
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1920
G1 X141.489 Y118.494 E.01134
G1 F2273.287
G1 X141.488 Y118.535 E.00125
G1 F7331.868
G1 X141.888 Y118.536 E.01229
G1 F12000
G1 X142.288 Y118.537 E.01229
G1 X142.93 Y118.539 E.01972
G1 X142.895 Y131.401 E.39524
G1 X113.081 Y131.316 E.91612
G1 X113.114 Y118.459 E.39504
G1 X113.756 Y118.461 E.01972
G1 X114.156 Y118.462 E.01229
G1 F7331.535
G1 X114.556 Y118.463 E.01229
G1 F2273.101
G1 X114.556 Y118.423 E.00125
G1 F1920
G1 X114.556 Y118.054 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X114.558 Y115.512 E.0843
G1 X115.614 Y115.515 E.03503
G1 F3000
G1 X115.6 Y118.056 E.0843
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1920
G1 X115.598 Y118.425 E.01134
G1 F2273.107
G1 X115.597 Y118.466 E.00125
G1 F7331.545
G1 X115.997 Y118.467 E.01229
G1 F12000
G1 X116.397 Y118.468 E.01229
G1 X117.871 Y118.472 E.04527
G1 X117.851 Y125.965 E.23024
G2 X118.034 Y127.007 I2.809 J.042 E.03269
G2 X118.958 Y127.768 I1.258 J-.585 E.03804
G2 X119.671 Y127.854 I.678 J-2.649 E.02211
G1 X136.323 Y127.898 E.51168
G2 X137.337 Y127.706 I.036 J-2.578 E.03191
G2 X137.769 Y127.361 I-.658 J-1.267 E.01709
; WIPE_START
M204 S10000
G1 X137.964 Y127.06 E-.13646
G1 X138.071 Y126.755 E-.12255
G1 X138.133 Y126.408 E-.1341
G1 X138.154 Y126.019 E-.1479
G1 X138.155 Y125.443 E-.219
; WIPE_END
G1 E-.04 F1800
G1 X140.771 Y119.273 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F15978
G1 X142.188 Y119.277 E.047
G1 X142.187 Y119.489 E.00701
G1 X138.903 Y122.773 E.1541
G1 X138.906 Y121.554 E.04046
G1 X142.173 Y124.821 E.15328
G1 X142.167 Y127.185 E.07841
G1 X139.256 Y130.096 E.13655
G1 X139.773 Y130.097 E.01715
G1 X137.901 Y128.225 E.08784
M73 P49 R9
G3 X136.341 Y128.638 I-1.711 J-3.307 E.05396
G1 X133.046 Y128.63 E.10929
G1 X131.602 Y130.074 E.06775
G1 X132.075 Y130.075 E.01569
G1 X130.623 Y128.623 E.06812
G1 X125.391 Y128.609 E.17356
G1 X123.948 Y130.052 E.06768
G1 X124.377 Y130.053 E.01423
G1 X122.927 Y128.603 E.06804
G3 X119.207 Y128.569 I-1.546 J-34.961 E.12345
G3 X118.128 Y128.196 I.296 J-2.601 E.03818
G1 X116.294 Y130.03 E.08604
G1 X116.679 Y130.031 E.01276
G1 X113.831 Y127.183 E.13361
G1 X113.837 Y124.811 E.07868
G1 X117.122 Y121.526 E.1541
G1 X117.119 Y122.795 E.04208
G1 X113.851 Y119.527 E.15328
G1 X113.852 Y119.202 E.0108
G1 X115.155 Y119.205 E.04322
G1 X113.926 Y130.475 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.53911
G1 F12000
G1 X141.995 Y130.555 E1.13492
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F12000
G1 X139.995 Y130.55 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 11/118
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
G17
G3 Z2.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X142.902 Y116.546
G1 Z2.2
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
G1 F9000
G2 X142.713 Y114.618 I-5.914 J-.395 E.05979
G3 X143.247 Y115.548 I-.71 J1.026 E.03409
G3 X143.384 Y116.46 I-1.127 J.636 E.02898
G3 X142.96 Y117.606 I-10.822 J-3.363 E.03755
G1 X142.747 Y117.861 E.0102
G3 X142.542 Y117.809 I-.057 J-.21 E.00678
G3 X142.478 Y117.51 I.859 J-.339 E.00946
G1 X142.485 Y115.665 E.05668
G1 X142.409 Y115.242 E.0132
G1 X142.002 Y115.003 E.0145
G3 X142.406 Y114.636 I1.837 J1.617 E.01681
G1 X142.658 Y114.603 E.00781
; WIPE_START
G1 X142.93 Y114.756 E-.11842
G1 X143.138 Y115.106 E-.15459
G1 X143.247 Y115.548 E-.17331
G1 X143.446 Y116.174 E-.24957
G1 X143.41 Y116.339 E-.06411
; WIPE_END
G1 E-.04 F1800
G17
G3 Z2.6 I.364 J-1.161 P1  F30000
G1 X139.124 Y114.994 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F9000
G1 X139.202 Y115.14 E.00508
G1 X139.143 Y115.197 E.00253
G3 X139.124 Y114.994 I.225 J-.123 E.00642
G1 X139.454 Y114.403 E.02081
G3 X140.212 Y114.95 I-.168 J1.032 E.02978
G1 X139.576 Y114.948 E.01955
G1 X139.723 Y115.223 E.00957
G1 X139.464 Y115.471 E.01101
G3 X139.435 Y117.507 I-19.25 J.74 E.0626
G3 X139.127 Y117.625 I-.182 J-.015 E.01262
G3 X139.008 Y116.427 I.449 J-.649 E.04207
G1 X138.89 Y115.83 E.0187
G1 X138.841 Y115.827 E.00152
G3 X138.687 Y114.955 I6.688 J-1.626 E.02725
G3 X139.398 Y114.397 I.708 J.17 E.02994
; WIPE_START
G1 X139.942 Y114.583 E-.21858
G1 X140.212 Y114.95 E-.17314
G1 X139.576 Y114.948 E-.24178
G1 X139.723 Y115.223 E-.11831
G1 X139.707 Y115.238 E-.00819
; WIPE_END
G1 E-.04 F1800
G17
G3 Z2.6 I.051 J-1.216 P1  F30000
G1 X114.509 Y114.172 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F9000
G1 X114.625 Y114.199 E.00367
G2 X115.537 Y114.386 I.99 J-2.513 E.02872
G3 X116.826 Y114.689 I.483 J.84 E.04481
G3 X117.274 Y115.411 I-.549 J.841 E.02696
G3 X117.159 Y116.492 I-.515 J.492 E.03801
G3 X116.707 Y116.806 I-.486 J-.218 E.01776
G3 X116.591 Y116.648 I.342 J-.371 E.00603
G2 X116.492 Y115.032 I-4.358 J-.543 E.05005
G1 X115.93 Y114.886 E.01783
G1 X113.74 Y114.88 E.06731
G1 X113.845 Y115.143 E.00872
G1 X113.58 Y115.403 E.01139
G3 X113.491 Y117.318 I-8.352 J.57 E.05903
G3 X113.05 Y117.794 I-1.01 J-.492 E.02023
G3 X112.796 Y117.248 I.281 J-.463 E.01962
G1 X112.818 Y116.759 E.01505
G3 X112.76 Y115.946 I1.019 J-.48 E.02562
G3 X112.903 Y115.119 I1.119 J-.233 E.0264
G3 X113.356 Y114.552 I.675 J.075 E.02354
G1 X113.533 Y114.589 E.00556
G3 X114.454 Y114.158 I1.153 J1.266 E.03172
; WIPE_START
G1 X114.625 Y114.199 E-.06689
G1 X115.028 Y114.349 E-.16339
G1 X115.537 Y114.386 E-.19365
G1 X115.81 Y114.269 E-.11297
G1 X116.254 Y114.253 E-.16898
G1 X116.373 Y114.333 E-.05413
; WIPE_END
G1 E-.04 F1800
G17
G3 Z2.6 I-.633 J1.039 P1  F30000
G1 X138.138 Y127.586 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6779
G1 X138.321 Y127.28 E.01183
G2 X138.451 Y126.909 I-1.636 J-.781 E.01305
G2 X138.545 Y126.083 I-3.222 J-.787 E.02765
G1 X138.565 Y118.919 E.23765
G1 X140.56 Y118.924 E.06621
G1 X140.563 Y115.973 E.09789
G1 X141.386 Y115.975 E.02729
G1 X141.373 Y118.926 E.09789
G1 X142.537 Y118.929 E.03861
G1 X142.506 Y130.675 E.38963
G1 X113.474 Y130.598 E.96306
G1 X113.505 Y118.852 E.38963
G1 X114.669 Y118.855 E.03861
G1 X114.672 Y115.904 E.09789
G1 X115.053 Y115.905 E.01265
G1 X115.495 Y115.906 E.01464
G1 X115.482 Y118.858 E.0979
G1 X117.477 Y118.863 E.06621
G1 X117.458 Y126.027 E.23764
G2 X117.676 Y127.225 I3.232 J.031 E.04064
G2 X118.852 Y128.201 I1.609 J-.742 E.0524
G2 X119.659 Y128.299 I.775 J-2.999 E.02705
G1 X136.333 Y128.343 E.55309
G2 X137.511 Y128.113 I.024 J-3 E.04011
G2 X138.1 Y127.632 I-.826 J-1.614 E.0254
M204 S250
G1 X137.81 Y127.372 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6779
M204 S5000
G1 X137.964 Y127.113 E.00926
G2 X138.071 Y126.809 I-1.285 J-.621 E.00991
G2 X138.153 Y126.072 I-2.874 J-.696 E.02284
G1 X138.174 Y118.526 E.23189
G1 X139.369 Y118.529 E.03673
G1 X139.769 Y118.53 E.01229
G1 F5843.944
G1 X140.169 Y118.531 E.01229
G1 F1482.124
G1 X140.169 Y118.49 E.00125
G1 F1200
G1 X140.171 Y115.58 E.08943
G1 F2760
G1 X140.405 Y115.581 E.00717
G1 F6779
G1 X140.805 Y115.582 E.01229
G1 X141.205 Y115.583 E.01229
G1 X141.545 Y115.584 E.01045
G1 F2760
G1 X141.779 Y115.584 E.0072
G1 F1200
G1 X141.767 Y118.495 E.08943
G1 F1482.053
G1 X141.767 Y118.535 E.00125
G1 F5843.804
G1 X142.167 Y118.536 E.01229
G1 F6779
G1 X142.567 Y118.537 E.01229
G1 X142.93 Y118.538 E.01117
G1 X142.897 Y131.068 E.38501
G1 X113.081 Y130.989 E.91618
G1 X113.114 Y118.459 E.38501
G1 X113.477 Y118.46 E.01117
G1 X113.877 Y118.461 E.01229
G1 F5844.09
G1 X114.277 Y118.462 E.01229
G1 F1482.197
G1 X114.277 Y118.422 E.00125
G1 F1200
G1 X114.28 Y115.511 E.08943
G1 F2760
G1 X114.517 Y115.512 E.00726
G1 F6779
G1 X114.917 Y115.513 E.01229
G1 X115.317 Y115.514 E.01229
G1 X115.655 Y115.515 E.01039
G1 F2760
G1 X115.888 Y115.515 E.00718
G1 F1200
G1 X115.876 Y118.426 E.08943
G1 F1482.419
G1 X115.875 Y118.467 E.00125
G1 F5844.53
G1 X116.275 Y118.468 E.01229
G1 F6779
M73 P49 R8
G1 X116.675 Y118.469 E.01229
G1 X117.871 Y118.472 E.03673
G1 X117.851 Y126.018 E.23188
G2 X118.034 Y127.06 I2.809 J.042 E.0327
G2 X118.958 Y127.822 I1.258 J-.584 E.03805
G2 X119.671 Y127.907 I.678 J-2.649 E.02211
G1 X136.323 Y127.951 E.51168
G2 X137.337 Y127.759 I.036 J-2.578 E.03191
G2 X137.769 Y127.414 I-.658 J-1.267 E.01711
; WIPE_START
G1 F12000
M204 S10000
G1 X137.964 Y127.113 E-.13628
G1 X138.071 Y126.809 E-.12236
G1 X138.133 Y126.462 E-.13408
G1 X138.153 Y126.072 E-.14817
G1 X138.155 Y125.496 E-.21911
; WIPE_END
G1 E-.04 F1800
G1 X140.966 Y119.129 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.452782
G1 F6779
G1 X140.974 Y116.178 E.09856
; WIPE_START
G1 F15000
G1 X140.969 Y118.178 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z2.6 I.087 J-1.214 P1  F30000
G1 X115.082 Y116.316 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.442114
G1 F6779
G1 X114.979 Y116.212 E.00477
; LINE_WIDTH: 0.412226
G1 X114.875 Y116.108 E.00441
G1 X115.082 Y116.316 F30000
; LINE_WIDTH: 0.452797
G1 F6779
G1 X115.075 Y119.06 E.09165
G1 X114.951 Y119.408 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F6779
G1 X114.499 Y119.407 E.01499
G1 X114.499 Y119.203 E.00675
G1 X113.852 Y119.201 E.02147
G1 X113.851 Y119.527 E.01081
G1 X117.119 Y122.795 E.15328
G1 X117.122 Y121.526 E.04208
G1 X113.837 Y124.811 E.1541
G1 X113.831 Y127.183 E.07868
G1 X116.907 Y130.259 E.1443
G1 X116.068 Y130.257 E.02784
G1 X118.096 Y128.228 E.09515
G2 X119.649 Y128.647 I1.726 J-3.311 E.05378
G1 X122.98 Y128.656 E.1105
G1 X124.603 Y130.279 E.07615
G1 X123.723 Y130.277 E.0292
G1 X125.338 Y128.662 E.07575
G1 X130.677 Y128.676 E.1771
G1 X132.3 Y130.3 E.07615
G1 X131.379 Y130.297 E.03055
G1 X132.993 Y128.683 E.07574
G2 X136.783 Y128.669 I1.768 J-35.581 E.12577
G2 X137.933 Y128.257 I-.282 J-2.6 E.04091
G1 X139.996 Y130.32 E.09677
G1 X139.034 Y130.318 E.03191
G1 X142.167 Y127.185 E.14696
G1 X142.173 Y124.821 E.07841
G1 X138.906 Y121.554 E.15328
G1 X138.903 Y122.773 E.04046
G1 X142.187 Y119.489 E.1541
G1 X142.188 Y119.277 E.00703
G1 X141.541 Y119.275 E.02147
G1 X141.54 Y119.478 E.00675
G1 X140.974 Y119.477 E.01877
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X141.54 Y119.478 E-.21501
G1 X141.541 Y119.275 E-.0773
G1 X142.188 Y119.277 E-.24597
G1 X142.187 Y119.489 E-.08048
G1 X141.925 Y119.751 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 12/118
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
G17
G3 Z2.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.092 Y127.7
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F5209
G1 X138.114 Y127.668 E.00127
G2 X138.451 Y126.963 I-1.428 J-1.116 E.02614
G2 X138.545 Y126.136 I-3.213 J-.786 E.02767
G1 X138.565 Y118.919 E.23942
G1 X140.376 Y118.923 E.0601
G1 X140.38 Y115.972 E.09789
G1 X141.567 Y115.975 E.03935
G1 X141.555 Y118.927 E.09789
G1 X142.537 Y118.929 E.03256
G1 X142.506 Y130.728 E.3914
G1 X113.473 Y130.651 E.96306
G1 X113.505 Y118.852 E.3914
G1 X114.487 Y118.855 E.03256
G1 X114.491 Y115.903 E.09789
G1 X115.677 Y115.907 E.03935
G1 X115.666 Y118.858 E.0979
G1 X117.477 Y118.863 E.0601
G1 X117.458 Y126.08 E.23941
G2 X117.676 Y127.278 I3.23 J.032 E.04064
G2 X118.852 Y128.254 I1.609 J-.742 E.0524
G2 X119.659 Y128.352 I.775 J-3.001 E.02705
G1 X136.332 Y128.397 E.55309
G2 X137.511 Y128.166 I.025 J-3 E.04011
G2 X137.839 Y127.95 I-.825 J-1.613 E.01306
G1 X138.049 Y127.742 E.0098
M204 S250
G1 X137.81 Y127.425 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5209
M204 S5000
G1 X137.964 Y127.166 E.00926
G2 X138.07 Y126.863 I-1.285 J-.62 E.0099
G2 X138.153 Y126.125 I-2.866 J-.695 E.02286
G1 X138.173 Y118.525 E.23352
G1 X139.185 Y118.528 E.03107
G1 X139.585 Y118.529 E.01229
G1 X139.985 Y118.53 E.01229
G1 F2792.921
G1 X139.985 Y118.49 E.00125
G1 F2400
G1 X139.989 Y115.579 E.08943
G1 F3896.3
G1 X140.13 Y115.58 E.00435
G1 F5209
G1 X140.53 Y115.581 E.01229
G1 X140.93 Y115.582 E.01229
G1 X141.42 Y115.583 E.01506
G1 X141.82 Y115.584 E.01229
G1 F3876.074
G1 X141.96 Y115.584 E.0043
G1 F2400
G1 X141.949 Y118.495 E.08943
G1 F2792.823
G1 X141.949 Y118.536 E.00125
G1 F5209
G1 X142.349 Y118.537 E.01229
G1 X142.93 Y118.538 E.01786
G1 X142.897 Y131.109 E.38628
G1 X142.897 Y131.121 E.00038
G1 X113.08 Y131.042 E.91618
G1 X113.08 Y131.03 E.00038
G1 X113.114 Y118.459 E.38628
G1 X113.695 Y118.46 E.01786
G1 X114.095 Y118.461 E.01229
G1 F2792.821
G1 X114.095 Y118.421 E.00125
G1 F2400
G1 X114.099 Y115.51 E.08943
G1 F3875.956
G1 X114.239 Y115.511 E.0043
G1 F5209
G1 X114.639 Y115.512 E.01229
G1 X115.039 Y115.513 E.01229
G1 X115.529 Y115.514 E.01506
G1 X115.929 Y115.515 E.01229
G1 F3896.3
G1 X116.071 Y115.516 E.00435
G1 F2400
G1 X116.059 Y118.426 E.08943
G1 F2792.924
G1 X116.059 Y118.467 E.00125
G1 F5209
G1 X116.459 Y118.468 E.01229
G1 X116.859 Y118.469 E.01229
G1 X117.871 Y118.471 E.03107
G1 X117.85 Y126.071 E.23352
G2 X118.034 Y127.113 I2.808 J.042 E.0327
G2 X118.958 Y127.875 I1.258 J-.584 E.03805
G2 X119.671 Y127.96 I.678 J-2.65 E.02211
G1 X136.323 Y128.004 E.51168
G2 X137.336 Y127.812 I.036 J-2.577 E.03191
G2 X137.769 Y127.467 I-.657 J-1.266 E.01711
; WIPE_START
G1 F12000
M204 S10000
G1 X137.964 Y127.166 E-.1363
G1 X138.07 Y126.863 E-.12217
G1 X138.133 Y126.516 E-.13404
G1 X138.153 Y126.125 E-.14847
G1 X138.155 Y125.549 E-.21902
; WIPE_END
G1 E-.04 F1800
G1 X140.913 Y119.556 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5209
G1 X141.378 Y119.557 E.01544
G1 X141.62 Y119.275 E.01233
G1 X142.188 Y119.276 E.01884
G1 X142.187 Y119.489 E.00704
G1 X138.903 Y122.773 E.1541
G1 X138.906 Y121.554 E.04046
G1 X142.173 Y124.821 E.15328
G1 X142.167 Y127.185 E.07841
G1 X138.981 Y130.371 E.14945
G1 X140.05 Y130.374 E.03544
G1 X137.966 Y128.29 E.09774
G3 X136.341 Y128.745 I-1.758 J-3.151 E.05651
G1 X132.94 Y128.736 E.1128
G1 X131.326 Y130.35 E.07575
G1 X132.353 Y130.353 E.03409
M73 P50 R8
G1 X130.73 Y128.73 E.07615
G1 X125.285 Y128.715 E.18063
G1 X123.67 Y130.33 E.07575
G1 X124.657 Y130.333 E.03273
G1 X123.034 Y128.709 E.07615
G3 X119.207 Y128.676 I-1.597 J-35.923 E.127
G3 X118.063 Y128.261 I.296 J-2.598 E.04073
G1 X116.014 Y130.31 E.09612
G1 X116.96 Y130.312 E.03138
G1 X113.831 Y127.183 E.1468
G1 X113.837 Y124.811 E.07868
G1 X117.122 Y121.526 E.1541
G1 X117.119 Y122.795 E.04208
G1 X113.851 Y119.527 E.15328
G1 X113.852 Y119.201 E.01082
G1 X114.42 Y119.203 E.01884
G1 X114.42 Y119.245 E.00139
G2 X115.012 Y119.487 I.417 J-.175 E.02356
G1 X115.278 Y119.092 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.430406
G1 F5209
G1 X115.278 Y116.304 E.08803
G1 X114.888 Y116.302 E.0123
G1 X114.872 Y119.09 E.08803
G1 X115.218 Y119.091 E.01091
; WIPE_START
G1 F12000
G1 X114.872 Y119.09 E-.13136
G1 X114.882 Y117.436 E-.62864
; WIPE_END
G1 E-.04 F1800
G1 X122.498 Y117.936 Z2.8 F30000
G1 X141.168 Y119.16 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.430391
G1 F5209
G1 X141.167 Y116.372 E.08803
G1 X140.778 Y116.371 E.01229
G1 X140.763 Y119.159 E.08803
G1 X141.108 Y119.16 E.01092
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F12000
G1 X140.763 Y119.159 E-.13137
G1 X140.772 Y117.505 E-.62863
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 13/118
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
G17
G3 Z2.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.138 Y127.693
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F5094
G1 X138.321 Y127.386 E.01184
G2 X138.45 Y127.017 I-1.635 J-.78 E.01301
G2 X138.545 Y126.189 I-3.205 J-.786 E.0277
G1 X138.565 Y118.918 E.24119
G1 X140.247 Y118.923 E.05582
G1 X140.253 Y115.972 E.09789
G1 X141.695 Y115.975 E.04784
G1 X141.684 Y118.926 E.09789
G1 X142.537 Y118.929 E.02829
G1 X142.506 Y130.782 E.39318
G1 X113.473 Y130.704 E.96306
G1 X113.505 Y118.852 E.39318
G1 X114.357 Y118.854 E.02827
G1 X114.365 Y115.903 E.0979
G1 X115.805 Y115.907 E.04778
G1 X115.795 Y118.858 E.09789
G1 X117.477 Y118.862 E.05582
G1 X117.458 Y126.133 E.24118
G2 X117.676 Y127.331 I3.23 J.032 E.04065
G2 X118.852 Y128.307 I1.609 J-.742 E.05241
G2 X119.659 Y128.405 I.775 J-3 E.02705
G1 X136.332 Y128.45 E.55309
G2 X137.511 Y128.219 I.025 J-3 E.04011
G2 X138.1 Y127.739 I-.825 J-1.613 E.0254
M204 S250
G1 X137.809 Y127.479 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5094
M204 S5000
G1 X137.964 Y127.219 E.00928
G2 X138.07 Y126.916 I-1.285 J-.62 E.00988
G2 X138.153 Y126.178 I-2.859 J-.695 E.02288
G1 X138.174 Y118.525 E.23516
G1 X139.056 Y118.528 E.02712
G1 X139.456 Y118.529 E.01229
G1 X139.856 Y118.53 E.01229
G1 F4396.914
G1 X139.856 Y118.489 E.00125
G1 F3900
G1 X139.861 Y115.579 E.08943
G1 F4994.433
G1 X139.948 Y115.579 E.00266
G1 F5094
G1 X140.348 Y115.58 E.01229
G1 X140.748 Y115.581 E.01229
G1 X141.201 Y115.582 E.01393
G1 X141.601 Y115.583 E.01229
G1 X142.001 Y115.584 E.01229
G1 F4996.042
G1 X142.088 Y115.584 E.00267
G1 F3900
G1 X142.078 Y118.495 E.08943
G1 F4396.287
G1 X142.078 Y118.535 E.00125
G1 F5094
G1 X142.478 Y118.537 E.01229
G1 X142.93 Y118.538 E.0139
G1 X142.897 Y131.162 E.38792
G1 X142.897 Y131.175 E.00038
G1 X113.08 Y131.095 E.91618
G1 X113.08 Y131.083 E.00038
G1 X113.114 Y118.459 E.38792
G1 X113.566 Y118.46 E.0139
G1 X113.966 Y118.461 E.01229
G1 F4397.544
G1 X113.966 Y118.42 E.00125
G1 F3900
G1 X113.968 Y117.82 E.01844
G1 F4800
G1 X113.969 Y117.42 E.01229
G1 X113.973 Y115.51 E.0587
G1 F5094
G1 X114.058 Y115.51 E.00261
G1 X114.458 Y115.511 E.01229
G1 X115.312 Y115.513 E.02622
G1 X115.712 Y115.514 E.01229
G1 X116.112 Y115.515 E.01229
G1 F4994.298
G1 X116.199 Y115.516 E.00266
G1 F3900
G1 X116.188 Y118.426 E.08943
G1 F4396.665
G1 X116.188 Y118.467 E.00125
G1 F5094
G1 X116.588 Y118.468 E.01229
G1 X116.988 Y118.469 E.01229
G1 X117.871 Y118.471 E.02712
G1 X117.85 Y126.124 E.23516
G2 X118.034 Y127.166 I2.808 J.043 E.03271
G2 X118.958 Y127.928 I1.258 J-.584 E.03806
G2 X119.67 Y128.013 I.678 J-2.65 E.02211
G1 X136.323 Y128.058 E.51168
G2 X137.336 Y127.866 I.036 J-2.577 E.03191
G2 X137.768 Y127.521 I-.657 J-1.266 E.0171
; WIPE_START
G1 F12000
M204 S10000
G1 X137.964 Y127.219 E-.13653
G1 X138.07 Y126.916 E-.12194
G1 X138.133 Y126.569 E-.13405
G1 X138.153 Y126.178 E-.14874
G1 X138.155 Y125.603 E-.21874
; WIPE_END
G1 E-.04 F1800
G1 X140.646 Y118.388 Z3 F30000
G1 X141.23 Y116.695 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.55889
G1 F5094
G1 X141.231 Y116.436 E.01088
G1 X140.714 Y116.435 E.02175
G1 X140.709 Y118.837 E.10101
G1 X140.726 Y119.077 E.01009
G1 X141.188 Y119.096 E.01942
G1 X141.223 Y119.036 E.00292
G1 X141.23 Y116.755 E.09591
; WIPE_START
G1 F12000
G1 X141.224 Y118.755 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3 I.1 J-1.213 P1  F30000
G1 X115.341 Y116.626 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.558706
G1 F5094
G1 X115.342 Y116.367 E.01086
G1 X114.825 Y116.366 E.02171
G1 X114.819 Y118.768 E.10097
G1 X114.836 Y119.008 E.0101
G1 X115.297 Y119.027 E.0194
G1 X115.333 Y118.965 E.00301
G1 X115.341 Y116.686 E.09582
G1 X115.035 Y119.487 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5094
G3 X114.427 Y119.25 I-.186 J-.421 E.02407
G1 X114.379 Y119.202 E.00225
G1 X113.852 Y119.201 E.01749
G1 X113.851 Y119.527 E.01083
G1 X117.119 Y122.795 E.15328
G1 X117.122 Y121.526 E.04208
G1 X113.837 Y124.811 E.1541
G1 X113.831 Y127.183 E.07868
G1 X117.014 Y130.366 E.14931
G1 X115.961 Y130.363 E.03491
G1 X118.031 Y128.293 E.09708
G2 X119.649 Y128.754 I1.771 J-3.151 E.05632
G1 X123.087 Y128.763 E.11405
G1 X124.71 Y130.386 E.07615
G1 X123.617 Y130.383 E.03626
G1 X125.232 Y128.768 E.07575
G1 X130.783 Y128.783 E.18416
G1 X132.407 Y130.406 E.07615
G1 X131.272 Y130.403 E.03762
G1 X132.887 Y128.789 E.07575
G1 X136.341 Y128.798 E.11456
G2 X137.999 Y128.323 I-.127 J-3.572 E.05779
G1 X140.103 Y130.427 E.09872
G1 X138.928 Y130.424 E.03897
G1 X142.167 Y127.185 E.15194
G1 X142.173 Y124.821 E.07841
G1 X138.906 Y121.554 E.15328
G1 X138.903 Y122.773 E.04046
G1 X142.187 Y119.489 E.1541
G1 X142.188 Y119.276 E.00705
G1 X141.66 Y119.275 E.0175
G1 X141.613 Y119.322 E.00223
G3 X140.89 Y119.556 I-.532 J-.408 E.02681
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X141.378 Y119.557 E-.18569
G1 X141.613 Y119.322 E-.12627
G1 X141.66 Y119.275 E-.02553
G1 X142.188 Y119.276 E-.20044
G1 X142.187 Y119.489 E-.08074
G1 X141.924 Y119.752 E-.14134
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 14/118
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
G17
G3 Z3 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.092 Y127.806
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4695
G1 X138.113 Y127.775 E.00127
G2 X138.45 Y127.07 I-1.428 J-1.115 E.02611
G2 X138.545 Y126.242 I-3.2 J-.786 E.02773
G1 X138.565 Y118.918 E.24295
G1 X140.158 Y118.922 E.05287
G1 X140.165 Y115.971 E.09789
G1 X141.784 Y115.975 E.0537
G1 X141.774 Y118.927 E.0979
G1 X142.537 Y118.929 E.02531
G1 X142.505 Y130.835 E.39496
G1 X113.473 Y130.758 E.96306
G1 X113.505 Y118.851 E.39496
G1 X114.268 Y118.853 E.02531
G1 X114.274 Y115.902 E.09789
G1 X115.893 Y115.907 E.0537
G1 X115.884 Y118.858 E.09789
G1 X117.477 Y118.862 E.05287
G1 X117.458 Y126.186 E.24295
G2 X117.676 Y127.384 I3.231 J.032 E.04065
G2 X118.852 Y128.36 I1.609 J-.742 E.05242
G2 X119.659 Y128.459 I.775 J-3 E.02705
G1 X136.332 Y128.503 E.55309
G2 X137.511 Y128.272 I.025 J-3 E.04011
G2 X137.839 Y128.056 I-.825 J-1.613 E.01306
G1 X138.049 Y127.848 E.0098
M204 S250
G1 X137.809 Y127.533 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4695
M204 S5000
G1 X137.964 Y127.272 E.00932
G2 X138.07 Y126.97 I-1.285 J-.62 E.00987
G2 X138.153 Y126.231 I-2.854 J-.695 E.0229
G1 X138.173 Y118.525 E.2368
G1 X139.367 Y118.528 E.03668
G1 X139.767 Y118.529 E.01229
G1 X139.767 Y118.488 E.00125
G1 X139.773 Y115.578 E.08943
G1 X139.82 Y115.578 E.00144
G1 X142.129 Y115.584 E.07094
G1 X142.177 Y115.584 E.00147
G1 X142.176 Y115.784 E.00615
G1 X142.175 Y116.184 E.01229
G1 X142.168 Y118.495 E.07099
G1 X142.167 Y118.535 E.00125
G1 X142.567 Y118.537 E.01229
G1 X142.93 Y118.538 E.01115
G1 X142.897 Y131.216 E.38957
G1 X142.897 Y131.228 E.00038
G1 X113.08 Y131.149 E.91618
G1 X113.08 Y131.136 E.00038
G1 X113.114 Y118.458 E.38957
G1 X113.477 Y118.459 E.01115
G1 X113.877 Y118.46 E.01229
G1 X113.877 Y118.42 E.00125
G1 X113.883 Y115.509 E.08943
G1 X113.932 Y115.509 E.00152
G1 X114.332 Y115.51 E.01229
G1 X116.24 Y115.515 E.0586
G1 X116.286 Y115.516 E.00144
G1 X116.277 Y118.426 E.08943
G1 X116.277 Y118.467 E.00125
G1 X116.677 Y118.468 E.01229
G1 X117.871 Y118.471 E.03668
G1 X117.85 Y126.177 E.23679
G2 X118.034 Y127.219 I2.808 J.043 E.03271
G2 X118.958 Y127.981 I1.258 J-.584 E.03806
G2 X119.67 Y128.067 I.678 J-2.649 E.02211
G1 X136.323 Y128.111 E.51168
G2 X137.336 Y127.919 I.036 J-2.578 E.03191
G2 X137.768 Y127.574 I-.657 J-1.266 E.01707
; WIPE_START
G1 F12000
M204 S10000
G1 X137.964 Y127.272 E-.13688
G1 X138.07 Y126.97 E-.12177
G1 X138.133 Y126.623 E-.13397
G1 X138.153 Y126.231 E-.14904
G1 X138.155 Y125.657 E-.21833
; WIPE_END
G1 E-.04 F1800
G1 X141.373 Y118.736 Z3.2 F30000
G1 X141.427 Y118.621 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4695
G1 X141.425 Y119.274 E.02164
G1 X142.188 Y119.276 E.02532
G1 X142.187 Y119.489 E.00706
G1 X138.903 Y122.773 E.1541
G1 X138.906 Y121.554 E.04046
G1 X142.173 Y124.821 E.15328
G1 X142.167 Y127.185 E.07841
G1 X138.875 Y130.477 E.15443
G1 X140.156 Y130.48 E.04251
G1 X138.031 Y128.355 E.0997
G3 X136.34 Y128.851 I-1.814 J-3.053 E.05907
G1 X132.834 Y128.842 E.11631
G1 X131.219 Y130.457 E.07575
G1 X132.46 Y130.46 E.04115
G1 X130.837 Y128.837 E.07615
G1 X125.178 Y128.822 E.1877
G1 X123.564 Y130.436 E.07575
G1 X124.764 Y130.439 E.0398
G1 X123.14 Y128.816 E.07615
G1 X119.649 Y128.807 E.11583
G3 X117.998 Y128.326 I.147 J-3.576 E.05759
G1 X115.908 Y130.416 E.09805
G1 X117.067 Y130.419 E.03844
G1 X113.831 Y127.183 E.15181
G1 X113.837 Y124.811 E.07868
G1 X117.122 Y121.526 E.1541
G1 X117.119 Y122.795 E.04208
G1 X113.851 Y119.527 E.15328
G1 X113.852 Y119.201 E.01084
G1 X114.615 Y119.203 E.02531
G1 X114.616 Y118.664 E.01786
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X114.615 Y119.203 E-.20462
G1 X113.852 Y119.201 E-.28999
G1 X113.851 Y119.527 E-.12415
G1 X114.114 Y119.79 E-.14125
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 15/118
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
G17
G3 Z3.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.092 Y127.859
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4797
G1 X138.113 Y127.828 E.00127
G2 X138.45 Y127.124 I-1.427 J-1.115 E.0261
G2 X138.545 Y126.295 I-3.19 J-.785 E.02775
G1 X138.565 Y118.918 E.24472
G1 X140.102 Y118.922 E.05099
G1 X140.108 Y115.971 E.09789
G1 X141.84 Y115.975 E.05744
G1 X141.831 Y118.926 E.09789
G1 X142.537 Y118.928 E.02342
G1 X142.505 Y130.888 E.39673
G1 X113.473 Y130.811 E.96306
G1 X113.505 Y118.851 E.39673
M73 P51 R8
G1 X114.211 Y118.853 E.02342
G1 X114.218 Y115.902 E.09789
G1 X115.949 Y115.906 E.05744
G1 X115.94 Y118.857 E.09789
G1 X117.477 Y118.862 E.05099
G1 X117.458 Y126.239 E.24471
G2 X117.676 Y127.437 I3.23 J.033 E.04066
G2 X118.851 Y128.414 I1.609 J-.742 E.05242
G2 X119.659 Y128.512 I.775 J-3 E.02705
G1 X136.332 Y128.556 E.55309
G2 X137.511 Y128.326 I.025 J-3 E.04011
G2 X137.839 Y128.11 I-.824 J-1.612 E.01306
G1 X138.049 Y127.902 E.0098
M204 S250
G1 X137.808 Y127.587 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4797
M204 S5000
G1 X137.964 Y127.326 E.00937
G2 X138.07 Y127.024 I-1.284 J-.619 E.00985
G2 X138.153 Y126.284 I-2.846 J-.695 E.02292
G1 X138.173 Y118.525 E.23844
G1 X139.71 Y118.529 E.04723
G1 X139.711 Y118.488 E.00125
G1 X139.717 Y115.578 E.08943
G1 X139.732 Y115.578 E.00046
G1 X142.218 Y115.584 E.07637
G1 X142.233 Y115.584 E.00048
G1 X142.225 Y118.495 E.08943
G1 X142.224 Y118.535 E.00125
G1 X142.93 Y118.537 E.02169
G1 X142.896 Y131.269 E.39121
G1 X142.896 Y131.281 E.00038
G1 X113.08 Y131.202 E.91618
G1 X113.08 Y131.19 E.00038
G1 X113.114 Y118.458 E.39121
G1 X113.82 Y118.46 E.02169
G1 X113.82 Y118.419 E.00125
G1 X113.826 Y115.509 E.08943
G1 X113.842 Y115.509 E.00048
G1 X116.327 Y115.515 E.07637
G1 X116.342 Y115.515 E.00046
G1 X116.334 Y118.426 E.08943
G1 X116.334 Y118.466 E.00125
G1 X117.871 Y118.471 E.04723
G1 X117.85 Y126.23 E.23843
G2 X118.033 Y127.272 I2.807 J.043 E.03272
G2 X118.958 Y128.035 I1.258 J-.584 E.03806
G2 X119.67 Y128.12 I.678 J-2.65 E.02211
G1 X136.323 Y128.164 E.51168
G2 X137.336 Y127.972 I.036 J-2.578 E.03191
G2 X137.767 Y127.628 I-.657 J-1.266 E.01704
; WIPE_START
G1 F12000
M204 S10000
G1 X137.964 Y127.326 E-.13729
G1 X138.07 Y127.024 E-.12159
G1 X138.132 Y126.677 E-.13393
G1 X138.153 Y126.284 E-.14933
G1 X138.154 Y125.711 E-.21786
; WIPE_END
G1 E-.04 F1800
G1 X130.846 Y123.511 Z3.4 F30000
G1 X114.56 Y118.607 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4797
G1 X114.558 Y119.202 E.01974
G1 X113.852 Y119.2 E.02342
G1 X113.851 Y119.527 E.01085
G1 X117.119 Y122.795 E.15328
G1 X117.122 Y121.526 E.04208
G1 X113.837 Y124.811 E.1541
G1 X113.831 Y127.183 E.07868
G1 X117.12 Y130.472 E.15432
G1 X115.855 Y130.469 E.04198
G1 X117.966 Y128.358 E.09902
G2 X119.648 Y128.86 I1.826 J-3.049 E.05886
G1 X123.194 Y128.87 E.1176
G1 X124.817 Y130.493 E.07615
G1 X123.511 Y130.489 E.04333
G1 X125.125 Y128.875 E.07575
G1 X130.89 Y128.89 E.19123
G1 X132.513 Y130.513 E.07615
G1 X131.166 Y130.51 E.04468
G1 X132.781 Y128.895 E.07575
G1 X136.34 Y128.905 E.11807
G2 X138.064 Y128.388 I-.121 J-3.536 E.06035
G1 X140.21 Y130.534 E.10068
G1 X138.822 Y130.53 E.04604
G1 X142.167 Y127.185 E.15692
G1 X142.173 Y124.821 E.07841
G1 X138.906 Y121.554 E.15328
G1 X138.903 Y122.773 E.04046
G1 X142.187 Y119.489 E.1541
G1 X142.188 Y119.276 E.00707
G1 X141.482 Y119.274 E.02342
G1 X141.484 Y118.564 E.02353
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X141.482 Y119.274 E-.26949
G1 X142.188 Y119.276 E-.26831
G1 X142.187 Y119.489 E-.08096
G1 X141.925 Y119.751 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 16/118
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
G17
G3 Z3.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.138 Y127.852
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4792
G1 X138.321 Y127.545 E.01185
G2 X138.45 Y127.178 I-1.635 J-.779 E.01295
G2 X138.545 Y126.348 I-3.185 J-.786 E.02778
G1 X138.565 Y118.917 E.24649
G1 X140.072 Y118.921 E.05002
G1 X140.08 Y115.97 E.09789
G1 X141.867 Y115.975 E.05928
G1 X141.859 Y118.926 E.0979
G1 X142.537 Y118.928 E.0225
G1 X142.505 Y130.941 E.39851
G1 X113.473 Y130.864 E.96306
G1 X113.505 Y118.851 E.39851
G1 X114.183 Y118.853 E.0225
G1 X114.191 Y115.901 E.09789
G1 X115.978 Y115.906 E.05927
G1 X115.97 Y118.857 E.09789
G1 X117.477 Y118.861 E.05002
G1 X117.458 Y126.292 E.24648
G2 X117.675 Y127.491 I3.23 J.033 E.04066
G2 X118.851 Y128.467 I1.609 J-.742 E.05242
G2 X119.659 Y128.565 I.775 J-3 E.02705
G1 X136.332 Y128.61 E.55309
G2 X137.51 Y128.379 I.025 J-3 E.04011
G2 X138.1 Y127.898 I-.824 J-1.612 E.0254
M204 S250
G1 X137.807 Y127.642 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4792
M204 S5000
G1 X137.964 Y127.379 E.00944
G2 X138.069 Y127.077 I-1.284 J-.619 E.00983
G2 X138.153 Y126.337 I-2.841 J-.695 E.02294
G1 X138.173 Y118.524 E.24007
G1 X139.681 Y118.528 E.04633
G1 X139.689 Y115.577 E.09068
G1 X142.26 Y115.584 E.079
G1 X142.252 Y118.535 E.09068
G1 X142.93 Y118.537 E.02084
G1 X142.896 Y131.322 E.39286
G1 X142.896 Y131.334 E.00038
G1 X113.08 Y131.255 E.91618
G1 X113.08 Y131.243 E.00038
G1 X113.114 Y118.458 E.39286
G1 X113.792 Y118.459 E.02084
G1 X113.8 Y115.508 E.09068
G1 X116.371 Y115.515 E.079
G1 X116.363 Y118.466 E.09068
G1 X117.871 Y118.47 E.04633
G1 X117.85 Y126.283 E.24007
G2 X118.033 Y127.326 I2.807 J.044 E.03272
G2 X118.957 Y128.088 I1.258 J-.584 E.03807
G2 X119.67 Y128.173 I.678 J-2.65 E.02211
G1 X136.322 Y128.217 E.51168
G2 X137.336 Y128.025 I.036 J-2.577 E.03191
G2 X137.766 Y127.682 I-.656 J-1.266 E.01702
; WIPE_START
G1 F12000
M204 S10000
G1 X137.964 Y127.379 E-.13768
G1 X138.069 Y127.077 E-.12135
G1 X138.132 Y126.73 E-.13391
G1 X138.153 Y126.337 E-.14962
G1 X138.154 Y125.765 E-.21743
; WIPE_END
G1 E-.04 F1800
G1 X141.369 Y118.843 Z3.6 F30000
G1 X141.512 Y118.537 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4792
G1 X141.51 Y119.273 E.02443
G1 X142.188 Y119.275 E.0225
G1 X142.187 Y119.489 E.00708
G1 X138.903 Y122.773 E.1541
G1 X138.906 Y121.554 E.04046
G1 X142.173 Y124.821 E.15328
G1 X142.167 Y127.185 E.07841
G1 X138.769 Y130.583 E.15941
G1 X140.263 Y130.587 E.04957
G1 X138.09 Y128.414 E.10195
G3 X136.34 Y128.958 I-1.632 J-2.166 E.062
G1 X132.728 Y128.948 E.11983
G1 X131.113 Y130.563 E.07575
G1 X132.567 Y130.567 E.04822
G1 X130.943 Y128.943 E.07615
G1 X125.072 Y128.928 E.19476
G1 X123.458 Y130.542 E.07575
G1 X124.87 Y130.546 E.04686
G1 X123.247 Y128.923 E.07615
G1 X119.648 Y128.913 E.11938
G3 X117.933 Y128.391 I.141 J-3.538 E.06013
G1 X115.802 Y130.522 E.09998
G1 X117.174 Y130.526 E.04551
G1 X113.831 Y127.183 E.15682
G1 X113.837 Y124.811 E.07868
G1 X117.122 Y121.526 E.1541
G1 X117.119 Y122.795 E.04208
G1 X113.851 Y119.527 E.15328
G1 X113.852 Y119.2 E.01086
G1 X114.531 Y119.202 E.0225
G1 X114.538 Y116.435 E.09179
G1 X114.721 Y116.251 E.00861
G1 X115.628 Y116.253 E.0301
G1 X115.626 Y116.975 E.02392
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X115.628 Y116.253 E-.274
G1 X114.721 Y116.251 E-.34476
G1 X114.538 Y116.435 E-.09862
G1 X114.537 Y116.547 E-.04261
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 17/118
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
G17
G3 Z3.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.138 Y127.905
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4898
G1 X138.321 Y127.599 E.01185
G2 X138.449 Y127.231 I-1.635 J-.779 E.01294
G2 X138.545 Y126.401 I-3.179 J-.785 E.0278
G1 X138.565 Y118.917 E.24825
G1 X140.072 Y118.921 E.05
G1 X140.08 Y115.97 E.09789
G1 X141.868 Y115.975 E.05931
G1 X141.86 Y118.926 E.0979
G1 X142.537 Y118.928 E.02245
G1 X142.505 Y130.995 E.40028
G1 X113.473 Y130.917 E.96306
G1 X113.505 Y118.85 E.40029
G1 X114.182 Y118.852 E.02245
G1 X114.19 Y115.901 E.09789
G1 X115.978 Y115.906 E.05931
G1 X115.97 Y118.857 E.0979
G1 X117.477 Y118.861 E.05
G1 X117.458 Y126.345 E.24825
G2 X117.675 Y127.544 I3.23 J.033 E.04067
G2 X118.851 Y128.52 I1.609 J-.742 E.05243
G2 X119.658 Y128.618 I.775 J-3 E.02705
G1 X136.332 Y128.663 E.55309
G2 X137.51 Y128.432 I.025 J-3 E.04011
G2 X138.099 Y127.952 I-.824 J-1.612 E.02541
M204 S250
G1 X137.805 Y127.697 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4898
M204 S5000
G1 X137.964 Y127.432 E.00951
G2 X138.069 Y127.131 I-1.284 J-.619 E.00982
G2 X138.153 Y126.39 I-2.835 J-.695 E.02296
G1 X138.173 Y118.524 E.24171
G1 X139.681 Y118.528 E.04631
G1 X139.689 Y115.577 E.09068
G1 X142.261 Y115.584 E.07903
G1 X142.253 Y118.535 E.09069
G1 X142.93 Y118.537 E.0208
G1 X142.896 Y131.375 E.3945
G1 X142.896 Y131.388 E.00038
G1 X113.08 Y131.308 E.91618
G1 X113.08 Y131.296 E.00038
G1 X113.114 Y118.457 E.39451
G1 X113.791 Y118.459 E.0208
G1 X113.799 Y115.508 E.09067
G1 X116.371 Y115.515 E.07903
G1 X116.363 Y118.466 E.09068
G1 X117.871 Y118.47 E.04631
G1 X117.85 Y126.336 E.24171
G2 X118.033 Y127.379 I2.808 J.044 E.03272
M73 P52 R8
G2 X118.957 Y128.141 I1.258 J-.583 E.03807
G2 X119.67 Y128.226 I.678 J-2.649 E.02211
G1 X136.322 Y128.271 E.51168
G2 X137.336 Y128.079 I.036 J-2.578 E.03191
G2 X137.766 Y127.736 I-.656 J-1.266 E.01701
; WIPE_START
G1 F12000
M204 S10000
G1 X137.964 Y127.432 E-.13788
G1 X138.069 Y127.131 E-.12118
G1 X138.132 Y126.784 E-.13387
G1 X138.153 Y126.39 E-.1499
G1 X138.154 Y125.819 E-.21718
; WIPE_END
G1 E-.04 F1800
G1 X131.05 Y123.029 Z3.8 F30000
G1 X115.627 Y116.974 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4898
G1 X115.629 Y116.253 E.02392
G1 X114.721 Y116.251 E.0301
G1 X114.537 Y116.435 E.00867
G1 X114.529 Y119.201 E.09174
G1 X113.852 Y119.199 E.02245
G1 X113.851 Y119.527 E.01087
G1 X117.119 Y122.795 E.15328
G1 X117.122 Y121.526 E.04208
G1 X113.837 Y124.811 E.1541
G1 X113.831 Y127.183 E.07868
G1 X117.227 Y130.579 E.15933
G1 X115.749 Y130.575 E.04904
G1 X117.906 Y128.418 E.10119
G2 X119.648 Y128.967 I1.641 J-2.173 E.06179
G1 X123.3 Y128.976 E.12116
G1 X124.924 Y130.6 E.07615
G1 X123.404 Y130.596 E.0504
G1 X125.019 Y128.981 E.07575
G1 X130.997 Y128.997 E.1983
G1 X132.62 Y130.62 E.07615
G1 X131.06 Y130.616 E.05175
G1 X132.675 Y129.001 E.07575
G1 X136.34 Y129.011 E.12159
G2 X138.116 Y128.44 I.127 J-2.655 E.06323
G1 X140.317 Y130.641 E.10322
G1 X138.716 Y130.636 E.0531
G1 X142.167 Y127.185 E.16191
G1 X142.173 Y124.821 E.07841
G1 X138.906 Y121.554 E.15328
G1 X138.903 Y122.773 E.04046
G1 X142.187 Y119.489 E.1541
G1 X142.188 Y119.275 E.00708
G1 X141.511 Y119.273 E.02245
G1 X141.513 Y118.535 E.02448
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X141.511 Y119.273 E-.28048
G1 X142.188 Y119.275 E-.25716
G1 X142.187 Y119.489 E-.08112
G1 X141.925 Y119.751 E-.14125
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 18/118
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
G17
G3 Z3.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.138 Y127.959
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F5252
G1 X138.321 Y127.652 E.01185
G2 X138.449 Y127.285 I-1.634 J-.778 E.01292
G2 X138.544 Y126.454 I-3.171 J-.785 E.02783
G1 X138.565 Y118.917 E.25002
G1 X140.098 Y118.921 E.05086
G1 X140.107 Y115.97 E.09789
G1 X141.842 Y115.974 E.05758
G1 X141.835 Y118.925 E.09789
G1 X142.537 Y118.927 E.02328
G1 X142.505 Y131.048 E.40206
G1 X113.473 Y130.971 E.96306
G1 X113.505 Y118.85 E.40206
G1 X114.207 Y118.852 E.02328
G1 X114.215 Y115.901 E.09789
G1 X115.951 Y115.905 E.05759
G1 X115.944 Y118.857 E.09789
G1 X117.477 Y118.861 E.05086
G1 X117.457 Y126.398 E.25002
G2 X117.675 Y127.597 I3.23 J.033 E.04067
G2 X118.851 Y128.573 I1.609 J-.741 E.05243
G2 X119.658 Y128.672 I.775 J-2.999 E.02705
G1 X136.332 Y128.716 E.55309
G2 X137.51 Y128.485 I.024 J-3 E.04011
G2 X138.099 Y128.005 I-.824 J-1.612 E.02541
M204 S250
G1 X137.8 Y127.748 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5252
M204 S5000
G2 X138.069 Y127.184 I-1.12 J-.881 E.01933
G2 X138.152 Y126.443 I-2.828 J-.694 E.02298
G1 X138.173 Y118.524 E.24335
G1 X139.707 Y118.528 E.04712
G1 X139.716 Y115.577 E.09068
G1 X142.235 Y115.583 E.07742
G1 X142.228 Y118.534 E.09068
G1 X142.93 Y118.536 E.02157
G1 X142.896 Y131.429 E.39615
G1 X142.896 Y131.441 E.00038
G1 X113.08 Y131.362 E.91618
G1 X113.08 Y131.349 E.00038
G1 X113.114 Y118.457 E.39615
G1 X113.816 Y118.459 E.02157
G1 X113.824 Y115.508 E.09068
G1 X116.344 Y115.514 E.07743
G1 X116.337 Y118.466 E.09068
G1 X117.871 Y118.47 E.04712
G1 X117.85 Y126.389 E.24334
G2 X118.033 Y127.432 I2.807 J.044 E.03273
G2 X118.957 Y128.194 I1.258 J-.583 E.03808
G2 X119.67 Y128.28 I.678 J-2.649 E.02211
G1 X136.322 Y128.324 E.51168
G2 X137.336 Y128.132 I.036 J-2.578 E.03191
G2 X137.762 Y127.794 I-.656 J-1.265 E.01682
; WIPE_START
G1 F12000
M204 S10000
G1 X137.964 Y127.485 E-.14023
G1 X138.069 Y127.184 E-.121
G1 X138.132 Y126.838 E-.13384
G1 X138.152 Y126.443 E-.15018
G1 X138.154 Y125.878 E-.21475
; WIPE_END
G1 E-.04 F1800
G1 X138.848 Y127.038 Z4 F30000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5252
G3 X138.142 Y128.466 I-2.291 J-.244 E.05395
G1 X140.37 Y130.694 E.1045
G1 X138.663 Y130.689 E.05664
G1 X142.167 Y127.185 E.1644
G1 X142.173 Y124.821 E.07841
G1 X138.906 Y121.554 E.15328
G1 X138.903 Y122.773 E.04046
G1 X142.187 Y119.489 E.1541
G1 X142.188 Y119.275 E.0071
G1 X141.81 Y119.274 E.01253
G3 X141.597 Y119.352 I-.146 J-.067 E.00838
G1 X141.393 Y119.554 E.00951
G1 X140.89 Y119.553 E.01671
G1 X141.449 Y116.365 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F5252
G1 X140.497 Y116.363 E.02925
G1 X140.49 Y118.996 E.0809
G1 X140.69 Y119.16 E.00797
G1 X141.232 Y119.162 E.01665
G1 X141.443 Y118.994 E.00829
G1 X141.449 Y116.425 E.07892
G1 X140.967 Y118.684 F30000
; LINE_WIDTH: 0.61922
G1 F5252
G1 X140.972 Y116.9 E.08378
; WIPE_START
G1 F11452.37
G1 X140.967 Y118.684 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X134.485 Y122.713 Z4 F30000
G1 X121.723 Y130.644 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5252
G1 X123.351 Y130.649 E.05401
G1 X124.966 Y129.034 E.07575
G1 X123.354 Y129.03 E.05348
G1 X124.977 Y130.653 E.07615
G1 X131.007 Y130.669 E.20002
G1 X132.622 Y129.054 E.07574
G1 X131.05 Y129.05 E.05212
G1 X132.674 Y130.673 E.07615
G1 X134.302 Y130.678 E.05401
; WIPE_START
G1 F16200
G1 X132.674 Y130.673 E-.61876
G1 X132.411 Y130.411 E-.14125
; WIPE_END
G1 E-.03999 F1800
G1 X125.95 Y126.348 Z4 F30000
G1 X115.035 Y119.484 Z4
G1 Z3.6
G1 E.8 F1800
G1 F5252
G1 X114.645 Y119.483 E.01293
G1 X114.443 Y119.279 E.00953
G2 X113.852 Y119.199 I-.607 J2.262 E.01983
G1 X113.851 Y119.527 E.01088
G1 X117.119 Y122.795 E.15328
G1 X117.122 Y121.526 E.04208
G1 X113.837 Y124.811 E.1541
G1 X113.831 Y127.183 E.07868
G1 X117.281 Y130.633 E.16183
G1 X115.696 Y130.628 E.05258
G1 X117.88 Y128.444 E.10245
G3 X117.159 Y127.024 I1.521 J-1.665 E.05399
G1 X115.557 Y116.772 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F5252
G1 X115.558 Y116.296 E.01463
G1 X114.606 Y116.294 E.02925
G1 X114.599 Y118.926 E.08089
G1 X114.8 Y119.091 E.00801
G1 X115.342 Y119.093 E.01665
G1 X115.552 Y118.925 E.00825
G1 X115.557 Y116.832 E.06431
G1 X115.076 Y118.615 F30000
; LINE_WIDTH: 0.61924
G1 F5252
G1 X115.081 Y116.831 E.08378
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F11451.971
G1 X115.076 Y118.615 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 19/118
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
G17
G3 Z4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.091 Y128.072
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F5290
G1 X138.113 Y128.041 E.00127
G2 X138.449 Y127.339 I-1.426 J-1.114 E.02603
G2 X138.544 Y126.507 I-3.165 J-.785 E.02785
G1 X138.565 Y118.916 E.25179
G1 X140.151 Y118.921 E.05264
G1 X140.161 Y115.97 E.09789
G1 X141.787 Y115.974 E.05393
G1 X141.78 Y118.925 E.09789
G1 X142.537 Y118.927 E.0251
G1 X142.505 Y131.101 E.40384
G1 X113.472 Y131.024 E.96306
G1 X113.505 Y118.85 E.40384
G1 X114.262 Y118.852 E.0251
G1 X114.271 Y115.901 E.09789
G1 X115.897 Y115.905 E.05393
G1 X115.891 Y118.856 E.09789
G1 X117.477 Y118.86 E.05264
G1 X117.457 Y126.451 E.25178
G2 X117.675 Y127.65 I3.228 J.034 E.04068
G2 X118.851 Y128.627 I1.609 J-.741 E.05244
G2 X119.658 Y128.725 I.775 J-3.001 E.02705
G1 X136.331 Y128.769 E.55309
G2 X137.51 Y128.539 I.025 J-2.999 E.04011
G2 X137.839 Y128.323 I-.824 J-1.612 E.01306
G1 X138.048 Y128.115 E.0098
M204 S250
G1 X137.803 Y127.806 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5290
M204 S5000
G1 X137.8 Y127.801 E.0002
G2 X138.069 Y127.238 I-1.12 J-.881 E.01932
G2 X138.152 Y126.496 I-2.823 J-.694 E.023
G1 X138.174 Y118.523 E.24499
G1 X139.761 Y118.528 E.04877
G1 X139.77 Y115.576 E.09068
G1 X142.18 Y115.583 E.07404
G1 X142.173 Y118.534 E.09068
G1 X142.93 Y118.536 E.02326
G1 X142.896 Y131.482 E.3978
G1 X142.896 Y131.494 E.00038
G1 X113.079 Y131.415 E.91618
G1 X113.079 Y131.403 E.00038
G1 X113.114 Y118.457 E.3978
G1 X113.871 Y118.459 E.02326
G1 X113.88 Y115.508 E.09068
G1 X116.29 Y115.514 E.07404
G1 X116.284 Y118.465 E.09068
G1 X117.871 Y118.469 E.04877
G1 X117.849 Y126.442 E.24498
G2 X118.033 Y127.485 I2.806 J.044 E.03273
G2 X118.957 Y128.248 I1.258 J-.583 E.03808
G2 X119.67 Y128.333 I.678 J-2.65 E.02211
G1 X136.322 Y128.377 E.51168
G2 X137.335 Y128.185 I.036 J-2.577 E.03191
G2 X137.59 Y128.016 I-.656 J-1.265 E.0094
G1 X137.76 Y127.848 E.00736
; WIPE_START
G1 F12000
M204 S10000
G1 X137.8 Y127.801 E-.02342
G1 X137.963 Y127.538 E-.11767
G1 X138.069 Y127.238 E-.1208
G1 X138.132 Y126.892 E-.1338
G1 X138.152 Y126.496 E-.15047
G1 X138.154 Y125.933 E-.21383
; WIPE_END
M73 P53 R8
G1 E-.04 F1800
G1 X134.355 Y130.731 Z4.2 F30000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5290
G1 X132.727 Y130.727 E.05401
G1 X131.104 Y129.104 E.07615
G1 X132.568 Y129.108 E.04859
G1 X130.954 Y130.722 E.07575
G1 X125.03 Y130.706 E.19649
G1 X123.407 Y129.083 E.07615
G1 X124.913 Y129.087 E.04994
G1 X123.298 Y130.702 E.07575
G1 X121.67 Y130.697 E.05401
; WIPE_START
G1 F16200
G1 X123.298 Y130.702 E-.61876
G1 X123.561 Y130.439 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X117.152 Y127.041 Z4.2 F30000
G1 Z3.8
G1 E.8 F1800
G1 F5290
G2 X117.853 Y128.471 I2.286 J-.235 E.05395
G1 X115.643 Y130.681 E.10372
G1 X117.334 Y130.686 E.05611
G1 X113.831 Y127.183 E.16434
G1 X113.837 Y124.811 E.07868
G1 X117.122 Y121.526 E.1541
G1 X117.119 Y122.795 E.04208
G1 X113.851 Y119.527 E.15328
G1 X113.852 Y119.199 E.01089
G1 X114.285 Y119.2 E.01436
G3 X114.645 Y119.483 I-1.103 J1.776 E.01522
G1 X115.035 Y119.484 E.01292
G1 X115.503 Y116.717 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F5290
G1 X115.504 Y116.296 E.01294
G1 X114.662 Y116.294 E.02588
G1 X114.653 Y118.965 E.08207
G1 X114.8 Y119.091 E.00596
G1 X115.342 Y119.093 E.01665
G1 X115.498 Y118.951 E.00649
G1 X115.503 Y116.777 E.06679
G1 X115.077 Y118.67 F30000
; LINE_WIDTH: 0.50954
G1 F5290
G1 X115.082 Y116.776 E.072
; WIPE_START
G1 F12000
G1 X115.077 Y118.67 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.705 Y118.931 Z4.2 F30000
G1 X140.89 Y119.553 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5290
G1 X141.393 Y119.554 E.0167
G1 X141.597 Y119.352 E.00951
G3 X142.188 Y119.274 I.456 J1.186 E.01997
G1 X142.187 Y119.489 E.00711
G1 X138.903 Y122.773 E.1541
G1 X138.906 Y121.554 E.04046
G1 X142.173 Y124.821 E.15328
G1 X142.167 Y127.185 E.07841
G1 X138.609 Y130.743 E.16689
G1 X140.423 Y130.747 E.06017
G1 X138.169 Y128.493 E.10578
G2 X138.855 Y127.055 I-1.655 J-1.672 E.05392
G1 X141.393 Y116.786 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F5290
G1 X141.394 Y116.365 E.01294
G1 X140.552 Y116.363 E.02588
G1 X140.543 Y119.033 E.08207
G1 X140.69 Y119.16 E.00597
G1 X141.232 Y119.162 E.01665
G1 X141.388 Y119.02 E.00648
G1 X141.393 Y116.846 E.06679
G1 X140.966 Y118.738 F30000
; LINE_WIDTH: 0.50953
G1 F5290
G1 X140.971 Y116.845 E.07199
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F12000
G1 X140.966 Y118.738 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 20/118
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
G17
G3 Z4.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.137 Y128.065
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F5173
G1 X138.32 Y127.758 E.01186
G2 X138.449 Y127.391 I-1.635 J-.779 E.01292
G2 X138.544 Y126.56 I-3.254 J-.794 E.02783
G1 X138.565 Y118.916 E.25356
G1 X140.237 Y118.921 E.05546
G1 X140.247 Y115.969 E.09789
G1 X141.7 Y115.973 E.04819
G1 X141.694 Y118.924 E.09789
G1 X142.537 Y118.927 E.02796
G1 X142.505 Y131.154 E.40562
G1 X113.472 Y131.077 E.96306
G1 X113.505 Y118.849 E.40562
G1 X114.348 Y118.852 E.02796
G1 X114.358 Y115.901 E.09789
G1 X115.811 Y115.904 E.04819
G1 X115.805 Y118.856 E.09789
G1 X117.477 Y118.86 E.05546
G1 X117.457 Y126.504 E.25355
G2 X117.675 Y127.703 I3.228 J.034 E.04068
G2 X118.851 Y128.68 I1.609 J-.741 E.05244
G2 X119.658 Y128.778 I.775 J-3 E.02705
G1 X136.331 Y128.823 E.55309
G2 X137.51 Y128.592 I.025 J-3 E.04011
G2 X138.099 Y128.111 I-.825 J-1.612 E.02541
M204 S250
G1 X137.801 Y127.861 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5173
M204 S5000
G1 X137.799 Y127.854 E.00022
G2 X138.068 Y127.291 I-1.12 J-.881 E.01932
G2 X138.152 Y126.549 I-2.904 J-.703 E.02301
G1 X138.174 Y118.523 E.24662
G1 X139.846 Y118.527 E.05139
G1 X139.856 Y115.576 E.09068
G1 X142.093 Y115.582 E.06871
G1 X142.087 Y118.533 E.09068
G1 X142.93 Y118.536 E.02591
G1 X142.896 Y131.535 E.39944
G1 X142.896 Y131.548 E.00038
G1 X113.079 Y131.468 E.91618
G1 X113.079 Y131.456 E.00038
G1 X113.114 Y118.456 E.39944
G1 X113.957 Y118.459 E.02591
G1 X113.967 Y115.507 E.09068
G1 X116.203 Y115.513 E.06871
G1 X116.198 Y118.465 E.09068
G1 X117.871 Y118.469 E.05139
G1 X117.849 Y126.495 E.24662
G2 X118.032 Y127.538 I2.806 J.045 E.03274
G2 X118.957 Y128.301 I1.258 J-.583 E.03808
G2 X119.669 Y128.386 I.678 J-2.65 E.02211
G1 X136.322 Y128.43 E.51168
G2 X137.335 Y128.238 I.036 J-2.577 E.03191
G2 X137.59 Y128.07 I-.656 J-1.265 E.00939
G1 X137.759 Y127.903 E.00729
; WIPE_START
G1 F12000
M204 S10000
G1 X137.799 Y127.854 E-.02429
G1 X137.963 Y127.591 E-.11771
G1 X138.068 Y127.291 E-.12078
G1 X138.132 Y126.935 E-.13756
G1 X138.152 Y126.549 E-.14677
G1 X138.154 Y125.989 E-.21289
; WIPE_END
G1 E-.04 F1800
G1 X138.86 Y127.07 Z4.4 F30000
G1 Z4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5173
G3 X138.195 Y128.519 I-2.373 J-.213 E.05391
G1 X140.477 Y130.801 E.10706
G1 X138.556 Y130.796 E.0637
G1 X142.167 Y127.185 E.16938
G1 X142.173 Y124.821 E.07841
G1 X138.906 Y121.554 E.15328
G1 X138.903 Y122.773 E.04046
G1 X142.187 Y119.489 E.1541
G1 X142.188 Y119.274 E.00712
G1 X141.669 Y119.273 E.01721
G3 X141.393 Y119.554 I-4.818 J-4.447 E.01307
G1 X140.893 Y119.553 E.01658
G1 X141.233 Y116.699 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.567269
G1 F5173
G1 X141.234 Y116.437 E.01117
G1 X140.711 Y116.436 E.02235
G1 X140.703 Y118.823 E.102
G1 X140.717 Y119.071 E.01059
G1 X141.199 Y119.087 E.02062
G1 X141.228 Y119.038 E.00246
G1 X141.233 Y116.759 E.09737
; WIPE_START
G1 F12000
G1 X141.229 Y118.759 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X134.717 Y122.74 Z4.4 F30000
G1 X121.617 Y130.751 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5173
G1 X123.245 Y130.755 E.05401
G1 X124.86 Y129.14 E.07575
G1 X123.461 Y129.137 E.04641
G1 X125.084 Y130.76 E.07615
G1 X130.901 Y130.775 E.19296
G1 X132.515 Y129.161 E.07575
G1 X131.157 Y129.157 E.04506
G1 X132.78 Y130.78 E.07615
G1 X134.409 Y130.785 E.05401
; WIPE_START
G1 F16200
G1 X132.78 Y130.78 E-.61876
G1 X132.517 Y130.517 E-.14125
; WIPE_END
G1 E-.03999 F1800
G1 X126.063 Y126.445 Z4.4 F30000
G1 X115.031 Y119.484 Z4.4
G1 Z4
G1 E.8 F1800
G1 F5173
G1 X114.645 Y119.483 E.0128
G3 X114.371 Y119.2 I4.279 J-4.425 E.01307
G1 X113.852 Y119.199 E.01721
G1 X113.851 Y119.527 E.0109
G1 X117.119 Y122.795 E.15328
G1 X117.122 Y121.526 E.04208
G1 X113.837 Y124.811 E.1541
G1 X113.831 Y127.183 E.07868
G1 X117.387 Y130.739 E.16684
G1 X115.59 Y130.735 E.05964
G1 X117.827 Y128.497 E.10498
G3 X117.145 Y127.057 I1.653 J-1.665 E.05392
G1 X115.344 Y116.63 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.567269
G1 F5173
G1 X115.345 Y116.368 E.01117
G1 X114.822 Y116.367 E.02235
G1 X114.814 Y118.754 E.10201
G1 X114.827 Y119.002 E.0106
G1 X115.31 Y119.019 E.02061
G1 X115.339 Y118.968 E.00251
G1 X115.344 Y116.69 E.09732
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F12000
G1 X115.34 Y118.69 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 21/118
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
G17
G3 Z4.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.137 Y128.118
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F5196
G1 X138.32 Y127.811 E.01186
G2 X138.448 Y127.446 I-1.634 J-.777 E.01286
G2 X138.544 Y126.613 I-3.15 J-.785 E.0279
G1 X138.565 Y118.916 E.25532
G1 X140.361 Y118.921 E.05959
G1 X140.373 Y115.969 E.09789
G1 X141.574 Y115.973 E.03986
G1 X141.57 Y118.924 E.0979
G1 X142.537 Y118.926 E.0321
G1 X142.504 Y131.208 E.40739
G1 X113.472 Y131.13 E.96306
G1 X113.505 Y118.849 E.40739
G1 X114.472 Y118.852 E.0321
G1 X114.484 Y115.901 E.09789
G1 X115.685 Y115.904 E.03985
G1 X115.681 Y118.855 E.0979
G1 X117.477 Y118.86 E.05959
G1 X117.457 Y126.557 E.25532
G2 X117.674 Y127.756 I3.227 J.035 E.04069
G2 X118.851 Y128.733 I1.609 J-.741 E.05245
G2 X119.658 Y128.831 I.775 J-2.999 E.02705
G1 X136.331 Y128.876 E.55309
G2 X137.51 Y128.645 I.024 J-3 E.04011
G2 X138.099 Y128.164 I-.823 J-1.611 E.02542
M204 S250
G1 X137.8 Y127.916 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5196
M204 S5000
G1 X137.799 Y127.907 E.00026
G2 X138.068 Y127.345 I-1.12 J-.881 E.0193
G2 X138.152 Y126.602 I-2.81 J-.694 E.02304
G1 X138.174 Y118.523 E.24826
G1 X139.97 Y118.527 E.05521
G1 X139.982 Y115.576 E.09068
G1 X141.967 Y115.582 E.06098
G1 X141.962 Y118.533 E.09068
G1 X142.93 Y118.535 E.02974
G1 X142.896 Y131.588 E.40109
G1 X142.896 Y131.601 E.00038
G1 X113.079 Y131.521 E.91618
G1 X113.079 Y131.509 E.00038
G1 X113.114 Y118.456 E.40109
G1 X114.082 Y118.459 E.02974
G1 X114.093 Y115.507 E.09068
G1 X116.078 Y115.513 E.06098
G1 X116.074 Y118.464 E.09068
G1 X117.871 Y118.469 E.05522
G1 X117.849 Y126.548 E.24826
G2 X118.032 Y127.591 I2.806 J.045 E.03274
G2 X118.957 Y128.354 I1.258 J-.583 E.03809
G2 X119.669 Y128.439 I.678 J-2.649 E.02211
G1 X136.322 Y128.484 E.51168
G2 X137.335 Y128.292 I.036 J-2.578 E.03191
G2 X137.589 Y128.123 I-.656 J-1.265 E.0094
G1 X137.757 Y127.958 E.00722
; WIPE_START
G1 F12000
M204 S10000
G1 X137.799 Y127.907 E-.02512
G1 X137.963 Y127.644 E-.11777
G1 X138.068 Y127.345 E-.1204
G1 X138.131 Y126.999 E-.13373
G1 X138.152 Y126.602 E-.15105
G1 X138.154 Y126.044 E-.21193
; WIPE_END
G1 E-.04 F1800
G1 X134.462 Y130.838 Z4.6 F30000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5196
G1 X132.834 Y130.834 E.05401
M73 P54 R8
G1 X131.21 Y129.21 E.07615
G1 X132.462 Y129.214 E.04152
G1 X130.848 Y130.828 E.07575
G1 X125.137 Y130.813 E.18942
G1 X123.514 Y129.19 E.07615
G1 X124.807 Y129.193 E.04288
G1 X123.192 Y130.808 E.07575
G1 X121.564 Y130.804 E.05401
; WIPE_START
G1 F16200
G1 X123.192 Y130.808 E-.61876
G1 X123.455 Y130.545 E-.14125
; WIPE_END
G1 E-.03999 F1800
G1 X117.138 Y127.073 Z4.6 F30000
G1 Z4.2
G1 E.8 F1800
G1 F5196
G2 X117.801 Y128.523 I2.389 J-.216 E.0539
G1 X115.536 Y130.788 E.10624
G1 X117.441 Y130.793 E.06317
G1 X113.831 Y127.183 E.16935
G1 X113.837 Y124.811 E.07868
G1 X117.122 Y121.526 E.1541
G1 X117.119 Y122.795 E.04208
G1 X113.851 Y119.527 E.15328
G1 X113.852 Y119.198 E.01091
G1 X114.405 Y119.2 E.01834
G1 X114.405 Y119.241 E.00138
G2 X115.01 Y119.484 I.424 J-.181 E.024
G1 X115.284 Y119.081 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.442275
G1 F5196
G1 X115.277 Y118.88 E.00653
G2 X115.282 Y116.305 I-1984.612 J-5.172 E.08379
G1 X114.885 Y116.304 E.01293
G1 X114.876 Y118.879 E.08379
G1 X114.899 Y119.08 E.00657
G1 X115.224 Y119.081 E.01059
; WIPE_START
G1 F12000
G1 X114.899 Y119.08 E-.12369
G1 X114.876 Y118.879 E-.07674
G1 X114.881 Y117.406 E-.55956
; WIPE_END
G1 E-.04 F1800
G1 X122.488 Y118.034 Z4.6 F30000
G1 X140.915 Y119.553 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5196
G1 X141.393 Y119.554 E.01587
G1 X141.635 Y119.272 E.01232
G1 X142.188 Y119.274 E.01834
G1 X142.187 Y119.489 E.00713
G1 X138.903 Y122.773 E.1541
G1 X138.906 Y121.554 E.04046
G1 X142.173 Y124.821 E.15328
G1 X142.167 Y127.185 E.07841
G1 X138.503 Y130.849 E.17187
G1 X140.53 Y130.854 E.06724
G1 X138.221 Y128.545 E.10833
G2 X138.868 Y127.087 I-1.812 J-1.677 E.05389
G1 X141.173 Y119.15 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.44231
G1 F5196
G1 X141.171 Y116.374 E.09033
G1 X140.773 Y116.373 E.01294
G1 X140.765 Y118.948 E.0838
G1 X140.787 Y119.148 E.00657
G1 X141.113 Y119.149 E.0106
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F12000
G1 X140.787 Y119.148 E-.12382
G1 X140.765 Y118.948 E-.07675
G1 X140.77 Y117.476 E-.55943
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 22/118
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
G17
G3 Z4.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.091 Y128.232
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F5146
G1 X138.112 Y128.201 E.00127
G2 X138.448 Y127.5 I-1.426 J-1.113 E.02598
G2 X138.544 Y126.666 I-3.143 J-.785 E.02792
G1 X138.565 Y118.915 E.25709
G1 X140.539 Y118.921 E.06551
G1 X140.552 Y115.97 E.09789
G1 X141.396 Y115.972 E.02798
G1 X141.393 Y118.923 E.09789
G1 X142.537 Y118.926 E.03796
G1 X142.504 Y131.261 E.40917
G1 X113.472 Y131.184 E.96306
G1 X113.505 Y118.849 E.40917
G1 X114.649 Y118.852 E.03796
G1 X114.662 Y115.901 E.0979
G1 X115.505 Y115.903 E.02798
G1 X115.503 Y118.854 E.09789
G1 X117.477 Y118.859 E.06551
G1 X117.457 Y126.61 E.25709
G2 X117.674 Y127.809 I3.227 J.035 E.04069
G2 X118.85 Y128.786 I1.609 J-.74 E.05245
G2 X119.658 Y128.885 I.775 J-2.999 E.02705
G1 X136.331 Y128.929 E.55309
G2 X137.51 Y128.698 I.024 J-3 E.04011
G2 X137.838 Y128.482 I-.823 J-1.611 E.01306
G1 X138.048 Y128.274 E.0098
M204 S250
G1 X137.798 Y127.971 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5146
M204 S5000
G1 X137.799 Y127.961 E.00031
G2 X138.068 Y127.399 I-1.12 J-.88 E.01928
G2 X138.152 Y126.655 I-2.804 J-.694 E.02306
G1 X138.174 Y118.522 E.2499
G1 X140.149 Y118.528 E.0607
G1 X140.162 Y115.576 E.09068
G1 X141.788 Y115.581 E.04997
G1 X141.785 Y118.532 E.09068
G1 X142.93 Y118.535 E.03519
G1 X142.895 Y131.642 E.40274
G1 X142.895 Y131.654 E.00038
G1 X113.079 Y131.575 E.91618
G1 X113.079 Y131.562 E.00038
G1 X113.114 Y118.456 E.40273
G1 X114.259 Y118.459 E.03519
G1 X114.272 Y115.508 E.09068
G1 X115.898 Y115.512 E.04997
G1 X115.895 Y118.463 E.09068
G1 X117.871 Y118.468 E.0607
G1 X117.849 Y126.601 E.24989
G2 X118.032 Y127.644 I2.805 J.046 E.03275
G2 X118.957 Y128.407 I1.258 J-.582 E.03809
G2 X119.669 Y128.493 I.678 J-2.649 E.02211
G1 X136.322 Y128.537 E.51168
G2 X137.335 Y128.345 I.036 J-2.578 E.03191
G2 X137.589 Y128.176 I-.655 J-1.264 E.00939
G1 X137.755 Y128.013 E.00716
; WIPE_START
G1 F12000
M204 S10000
G1 X137.799 Y127.961 E-.02591
G1 X137.963 Y127.697 E-.1178
G1 X138.068 Y127.399 E-.1202
G1 X138.131 Y127.053 E-.1337
G1 X138.152 Y126.655 E-.15133
G1 X138.153 Y126.1 E-.21105
; WIPE_END
G1 E-.04 F1800
G1 X136.807 Y129.25 Z4.8 F30000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5146
G2 X138.247 Y128.571 I-.204 J-2.298 E.05391
G1 X140.584 Y130.908 E.10961
G1 X138.45 Y130.902 E.07077
G1 X142.167 Y127.185 E.17436
G1 X142.173 Y124.821 E.07841
G1 X138.906 Y121.554 E.15328
G1 X138.903 Y122.773 E.04046
G1 X142.187 Y119.489 E.1541
G1 X142.188 Y119.273 E.00714
G1 X141.556 Y119.272 E.02097
G1 X141.555 Y119.475 E.00675
G1 X140.978 Y119.474 E.01916
G1 X140.965 Y119.125 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.484889
G1 F5146
G1 X140.974 Y116.174 E.10628
; WIPE_START
G1 F14933.172
G1 X140.968 Y118.174 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X134.574 Y122.342 Z4.8 F30000
G1 X121.511 Y130.857 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5146
G1 X123.139 Y130.861 E.05401
G1 X124.754 Y129.247 E.07575
G1 X123.567 Y129.243 E.03934
G1 X125.191 Y130.867 E.07615
G1 X130.794 Y130.881 E.18589
G1 X132.409 Y129.267 E.07575
G1 X131.264 Y129.264 E.03799
G1 X132.887 Y130.887 E.07615
G1 X134.515 Y130.891 E.05401
; WIPE_START
G1 F16200
G1 X132.887 Y130.887 E-.61876
G1 X132.624 Y130.624 E-.14125
; WIPE_END
G1 E-.03999 F1800
G1 X126.18 Y126.534 Z4.8 F30000
G1 X114.947 Y119.404 Z4.8
G1 Z4.4
G1 E.8 F1800
G1 F5146
G1 X114.484 Y119.403 E.01538
G1 X114.484 Y119.2 E.00675
G1 X113.852 Y119.198 E.02097
G1 X113.851 Y119.527 E.01092
G1 X117.119 Y122.795 E.15328
G1 X117.122 Y121.526 E.04208
G1 X113.837 Y124.811 E.1541
G1 X113.831 Y127.183 E.07868
G1 X117.494 Y130.846 E.17185
G1 X115.483 Y130.841 E.06671
G1 X117.775 Y128.549 E.10751
G2 X119.224 Y129.209 I1.68 J-1.768 E.05382
; WIPE_START
G1 F16200
G1 X118.756 Y129.123 E-.18092
G1 X118.324 Y128.961 E-.17552
G1 X117.775 Y128.549 E-.26069
G1 X117.509 Y128.815 E-.14287
; WIPE_END
G1 E-.04 F1800
G1 X115.662 Y121.409 Z4.8 F30000
G1 X115.075 Y119.056 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.484859
G1 F5146
G1 X115.083 Y116.105 E.10627
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F14934.21
G1 X115.078 Y118.105 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 23/118
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
G17
G3 Z4.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.137 Y128.225
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F4909
G1 X138.32 Y127.917 E.01187
G2 X138.448 Y127.553 I-1.634 J-.776 E.01282
G2 X138.544 Y126.719 I-3.136 J-.784 E.02795
G1 X138.565 Y118.915 E.25886
G1 X140.804 Y118.921 E.07428
G1 X140.82 Y115.97 E.0979
G1 X141.126 Y115.971 E.01016
G1 X141.126 Y118.922 E.0979
G1 X142.537 Y118.926 E.0468
G1 X142.504 Y131.314 E.41095
G1 X113.472 Y131.237 E.96306
G1 X113.505 Y118.849 E.41095
G1 X114.916 Y118.852 E.0468
G1 X114.931 Y115.901 E.0979
G1 X115.238 Y115.902 E.01016
G1 X115.238 Y118.853 E.0979
G1 X117.477 Y118.859 E.07428
G1 X117.457 Y126.662 E.25885
G2 X117.674 Y127.862 I3.227 J.035 E.04069
G2 X118.85 Y128.84 I1.609 J-.74 E.05246
G2 X119.658 Y128.938 I.775 J-3 E.02705
G1 X136.331 Y128.982 E.55309
G2 X137.509 Y128.752 I.025 J-2.999 E.04011
G2 X138.099 Y128.271 I-.823 J-1.611 E.02542
M204 S250
G1 X137.797 Y128.025 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4909
M204 S5000
G1 X137.799 Y128.014 E.00036
G2 X138.067 Y127.452 I-1.12 J-.88 E.01927
G2 X138.152 Y126.708 I-2.797 J-.694 E.02308
G1 X138.174 Y118.522 E.25154
G1 X140.414 Y118.528 E.06884
G1 X140.43 Y115.577 E.09068
G1 X141.518 Y115.58 E.03344
G1 X141.518 Y118.531 E.09068
G1 X142.93 Y118.535 E.04338
G1 X142.895 Y131.695 E.40438
G1 X142.895 Y131.707 E.00038
G1 X113.079 Y131.628 E.91618
G1 X113.079 Y131.616 E.00038
G1 X113.114 Y118.455 E.40438
G1 X114.526 Y118.459 E.04338
G1 X114.541 Y115.508 E.09068
G1 X115.63 Y115.511 E.03344
G1 X115.63 Y118.462 E.09068
G1 X117.871 Y118.468 E.06884
G1 X117.849 Y126.654 E.25153
G2 X118.032 Y127.698 I2.805 J.046 E.03275
G2 X118.956 Y128.461 I1.258 J-.582 E.03809
G2 X119.669 Y128.546 I.678 J-2.651 E.02211
G1 X136.321 Y128.59 E.51168
G2 X137.335 Y128.398 I.036 J-2.577 E.03191
G2 X137.589 Y128.229 I-.655 J-1.264 E.0094
G1 X137.754 Y128.067 E.0071
; WIPE_START
G1 F12000
M204 S10000
G1 X137.799 Y128.014 E-.02659
G1 X137.963 Y127.751 E-.11785
G1 X138.067 Y127.452 E-.12002
G1 X138.131 Y127.107 E-.13366
G1 X138.152 Y126.708 E-.15162
G1 X138.153 Y126.155 E-.21025
; WIPE_END
G1 E-.04 F1800
G1 X134.569 Y130.945 Z5 F30000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4909
G1 X132.94 Y130.94 E.05401
G1 X131.317 Y129.317 E.07615
G1 X132.356 Y129.32 E.03446
G1 X130.741 Y130.935 E.07575
G1 X125.244 Y130.92 E.18236
G1 X123.621 Y129.297 E.07615
G1 X124.7 Y129.3 E.03581
G1 X123.086 Y130.914 E.07575
M73 P55 R8
G1 X121.457 Y130.91 E.05401
G1 X119.187 Y129.258 F30000
G1 F4909
G3 X117.749 Y128.575 I.215 J-2.308 E.05391
G1 X115.43 Y130.894 E.10877
G1 X117.548 Y130.9 E.07024
G1 X113.831 Y127.183 E.17436
G1 X113.837 Y124.811 E.07868
G1 X117.122 Y121.526 E.1541
G1 X117.119 Y122.795 E.04208
G1 X113.851 Y119.527 E.15328
G1 X113.852 Y119.198 E.01093
G1 X115.151 Y119.201 E.04308
; WIPE_START
G1 F16200
G1 X113.852 Y119.198 E-.49354
M73 P55 R7
G1 X113.851 Y119.527 E-.12522
G1 X114.114 Y119.79 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X121.745 Y119.641 Z5 F30000
G1 X140.775 Y119.269 Z5
G1 Z4.6
G1 E.8 F1800
G1 F4909
G1 X142.188 Y119.273 E.04686
G1 X142.187 Y119.489 E.00715
G1 X138.903 Y122.773 E.1541
G1 X138.906 Y121.554 E.04046
G1 X142.173 Y124.821 E.15328
G1 X142.167 Y127.185 E.07841
G1 X138.397 Y130.955 E.17686
G1 X140.637 Y130.961 E.0743
G1 X138.273 Y128.597 E.11089
G3 X136.844 Y129.297 I-1.642 J-1.546 E.05393
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X137.665 Y129.066 E-.32382
G1 X138.063 Y128.813 E-.17932
G1 X138.273 Y128.597 E-.11444
G1 X138.538 Y128.862 E-.14242
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 24/118
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
G17
G3 Z5 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.137 Y128.278
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4567
G1 X138.321 Y127.969 E.01193
G2 X138.452 Y127.587 I-1.634 J-.775 E.01343
G2 X138.544 Y126.772 I-3.83 J-.842 E.02726
G1 X138.565 Y118.915 E.26062
G1 X142.537 Y118.925 E.13178
G1 X142.504 Y131.367 E.41273
G1 X113.472 Y131.29 E.96306
G1 X113.505 Y118.848 E.41273
G1 X115.018 Y118.852 E.0502
G1 X117.477 Y118.859 E.08158
G1 X117.457 Y126.715 E.26062
G2 X117.674 Y127.915 I3.227 J.036 E.0407
G2 X118.85 Y128.893 I1.609 J-.74 E.05246
G2 X119.657 Y128.991 I.775 J-3.001 E.02705
G1 X136.331 Y129.036 E.55309
G2 X137.509 Y128.805 I.025 J-3 E.04011
G2 X138.099 Y128.324 I-.823 J-1.611 E.02542
M204 S250
G1 X137.796 Y128.079 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4567
M204 S5000
G1 X137.799 Y128.067 E.0004
G2 X138.072 Y127.488 I-1.121 J-.882 E.01985
G2 X138.152 Y126.761 I-3.409 J-.742 E.0225
G1 X138.174 Y118.522 E.25317
G1 X142.93 Y118.534 E.14616
G1 X142.895 Y131.748 E.40603
G1 X142.895 Y131.761 E.00038
G1 X113.079 Y131.681 E.91618
G1 X113.079 Y131.669 E.00038
G1 X113.114 Y118.455 E.40603
G1 X115.019 Y118.46 E.05855
G1 X117.871 Y118.468 E.08762
G1 X117.849 Y126.707 E.25317
G2 X118.032 Y127.751 I2.805 J.046 E.03276
G2 X118.956 Y128.514 I1.258 J-.582 E.0381
G2 X119.669 Y128.599 I.678 J-2.65 E.02212
G1 X136.321 Y128.643 E.51168
G2 X137.335 Y128.451 I.036 J-2.577 E.03191
G2 X137.589 Y128.283 I-.657 J-1.266 E.00939
G1 X137.753 Y128.122 E.00706
; WIPE_START
G1 F12000
M204 S10000
G1 X137.799 Y128.067 E-.02716
G1 X137.963 Y127.803 E-.11813
G1 X138.072 Y127.488 E-.12681
G1 X138.131 Y127.16 E-.12648
G1 X138.152 Y126.761 E-.15181
G1 X138.153 Y126.209 E-.20961
; WIPE_END
G1 E-.04 F1800
G1 X136.881 Y129.343 Z5.2 F30000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4567
G2 X138.299 Y128.623 I-.224 J-2.198 E.05396
G1 X140.69 Y131.014 E.11216
G1 X138.344 Y131.008 E.07784
G1 X142.167 Y127.185 E.17935
G1 X142.173 Y124.821 E.07841
G1 X138.906 Y121.554 E.15328
G1 X138.903 Y122.773 E.04046
G1 X142.187 Y119.489 E.1541
G1 X142.188 Y119.273 E.00716
G1 X140.775 Y119.269 E.04685
; WIPE_START
G1 F16200
G1 X142.188 Y119.273 E-.53674
G1 X142.187 Y119.489 E-.08203
G1 X141.925 Y119.751 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X135.227 Y123.411 Z5.2 F30000
G1 X121.404 Y130.963 Z5.2
G1 Z4.8
G1 E.8 F1800
G1 F4567
G1 X123.033 Y130.967 E.05401
G1 X124.647 Y129.353 E.07575
G1 X123.674 Y129.35 E.03228
G1 X125.297 Y130.973 E.07615
G1 X130.688 Y130.988 E.17882
G1 X132.303 Y129.373 E.07575
G1 X131.371 Y129.371 E.03092
G1 X132.994 Y130.994 E.07615
G1 X134.622 Y130.998 E.05401
; WIPE_START
G1 F16200
G1 X132.994 Y130.994 E-.61876
G1 X132.731 Y130.731 E-.14125
; WIPE_END
G1 E-.03999 F1800
G1 X126.349 Y126.545 Z5.2 F30000
G1 X115.151 Y119.201 Z5.2
G1 Z4.8
G1 E.8 F1800
G1 F4567
G1 X113.852 Y119.197 E.04307
G1 X113.851 Y119.527 E.01094
G1 X117.119 Y122.795 E.15328
G1 X117.122 Y121.526 E.04208
G1 X113.837 Y124.811 E.1541
G1 X113.831 Y127.183 E.07868
G1 X117.601 Y130.953 E.17686
G1 X115.377 Y130.947 E.07377
G1 X117.723 Y128.601 E.11004
G2 X119.15 Y129.304 I1.651 J-1.552 E.05393
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X118.323 Y129.067 E-.3268
G1 X117.926 Y128.813 E-.17929
G1 X117.723 Y128.601 E-.11148
G1 X117.458 Y128.866 E-.14243
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 25/118
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
G17
G3 Z5.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.137 Y128.331
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4502
G1 X138.32 Y128.024 E.01187
G2 X138.447 Y127.661 I-1.633 J-.776 E.01278
G2 X138.543 Y126.825 I-3.121 J-.784 E.028
G1 X138.565 Y118.915 E.26239
G1 X142.537 Y118.925 E.13178
G1 X142.504 Y131.421 E.4145
G1 X113.472 Y131.343 E.96306
G1 X113.505 Y118.848 E.4145
G1 X117.477 Y118.858 E.13178
G1 X117.456 Y126.768 E.26239
G2 X117.674 Y127.969 I3.226 J.036 E.0407
G2 X118.85 Y128.946 I1.609 J-.74 E.05247
G2 X119.657 Y129.044 I.775 J-2.999 E.02705
G1 X136.331 Y129.089 E.55309
G2 X137.509 Y128.858 I.025 J-3 E.04011
G2 X138.099 Y128.377 I-.822 J-1.61 E.02542
M204 S250
G1 X137.795 Y128.134 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4502
M204 S5000
G1 X137.799 Y128.12 E.00043
G2 X138.067 Y127.56 I-1.119 J-.88 E.01925
G2 X138.151 Y126.814 I-2.785 J-.693 E.02312
G1 X138.174 Y118.521 E.25481
G1 X142.93 Y118.534 E.14616
G1 X142.895 Y131.802 E.40767
G1 X142.895 Y131.814 E.00038
G1 X113.079 Y131.734 E.91618
G1 X113.079 Y131.722 E.00038
G1 X113.114 Y118.455 E.40767
G1 X117.871 Y118.467 E.14616
G1 X117.849 Y126.76 E.25481
G2 X118.032 Y127.804 I2.804 J.046 E.03276
G2 X118.956 Y128.567 I1.258 J-.582 E.0381
G2 X119.669 Y128.652 I.678 J-2.649 E.02211
G1 X136.321 Y128.697 E.51168
G2 X137.335 Y128.505 I.036 J-2.578 E.03191
G2 X137.589 Y128.336 I-.655 J-1.264 E.0094
G1 X137.752 Y128.176 E.00702
; WIPE_START
G1 F12000
M204 S10000
G1 X137.799 Y128.12 E-.02763
G1 X137.963 Y127.857 E-.11793
G1 X138.067 Y127.56 E-.11964
G1 X138.131 Y127.214 E-.13358
G1 X138.151 Y126.814 E-.15219
G1 X138.153 Y126.264 E-.20904
; WIPE_END
G1 E-.04 F1800
G1 X136.918 Y129.389 Z5.4 F30000
G1 Z5
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4502
G2 X138.326 Y128.65 I-.236 J-2.156 E.054
G1 X140.744 Y131.068 E.11344
G1 X138.291 Y131.061 E.08137
G1 X142.167 Y127.185 E.18184
G1 X142.173 Y124.821 E.07841
G1 X138.906 Y121.554 E.15328
G1 X138.903 Y122.773 E.04046
G1 X142.187 Y119.489 E.1541
G1 X142.188 Y119.272 E.00717
G1 X140.776 Y119.269 E.04684
; WIPE_START
G1 F16200
G1 X142.188 Y119.272 E-.53661
G1 X142.187 Y119.489 E-.08216
G1 X141.925 Y119.751 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X137.803 Y126.176 Z5.4 F30000
G1 X134.676 Y131.052 Z5.4
G1 Z5
G1 E.8 F1800
G1 F4502
G1 X133.047 Y131.047 E.05401
G1 X131.424 Y129.424 E.07615
G1 X132.25 Y129.426 E.02739
G1 X130.635 Y131.041 E.07575
G1 X125.351 Y131.027 E.17529
G1 X123.728 Y129.404 E.07615
G1 X124.594 Y129.406 E.02875
G1 X122.98 Y131.02 E.07575
G1 X121.351 Y131.016 E.05401
G1 X119.113 Y129.351 F30000
M73 P56 R7
G1 F4502
G3 X117.696 Y128.628 I.234 J-2.207 E.05395
G1 X115.324 Y131 E.1113
G1 X117.654 Y131.006 E.07731
G1 X113.831 Y127.183 E.17937
G1 X113.837 Y124.811 E.07868
G1 X117.122 Y121.526 E.1541
G1 X117.119 Y122.795 E.04208
G1 X113.851 Y119.527 E.15328
G1 X113.852 Y119.197 E.01095
G1 X115.15 Y119.201 E.04306
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X113.852 Y119.197 E-.4933
G1 X113.851 Y119.527 E-.12547
G1 X114.114 Y119.79 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 26/118
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change
G17
G3 Z5.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.09 Y128.445
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4513
G1 X138.112 Y128.414 E.00128
G2 X138.447 Y127.714 I-1.425 J-1.112 E.02591
G2 X138.543 Y126.878 I-3.115 J-.784 E.02803
G1 X138.565 Y118.914 E.26416
G1 X142.537 Y118.925 E.13178
G1 X142.504 Y131.474 E.41628
G1 X113.472 Y131.397 E.96306
G1 X113.505 Y118.848 E.41628
G1 X117.477 Y118.858 E.13178
G1 X117.456 Y126.821 E.26416
G2 X117.673 Y128.022 I3.225 J.036 E.04071
G2 X118.85 Y128.999 I1.609 J-.739 E.05247
G2 X119.657 Y129.098 I.775 J-2.999 E.02705
G1 X136.33 Y129.142 E.55309
G2 X137.509 Y128.911 I.024 J-3.001 E.04011
G2 X137.838 Y128.696 I-.822 J-1.61 E.01306
G1 X138.047 Y128.487 E.00981
M204 S250
G1 X137.794 Y128.187 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4513
M204 S5000
G1 X137.799 Y128.174 E.00045
G2 X138.067 Y127.613 I-1.119 J-.879 E.01923
G2 X138.151 Y126.867 I-2.779 J-.693 E.02315
G1 X138.174 Y118.521 E.25645
G1 X142.93 Y118.534 E.14616
G1 X142.895 Y131.855 E.40932
G1 X142.895 Y131.867 E.00038
G1 X113.078 Y131.788 E.91618
G1 X113.078 Y131.775 E.00038
G1 X113.114 Y118.454 E.40932
G1 X117.871 Y118.467 E.14616
G1 X117.848 Y126.813 E.25644
G2 X118.031 Y127.857 I2.803 J.047 E.03277
G2 X118.956 Y128.62 I1.258 J-.582 E.03811
G2 X119.669 Y128.706 I.678 J-2.649 E.02211
G1 X136.321 Y128.75 E.51168
G2 X137.334 Y128.558 I.036 J-2.578 E.03191
G2 X137.589 Y128.389 I-.655 J-1.264 E.0094
G1 X137.751 Y128.229 E.007
; WIPE_START
G1 F12000
M204 S10000
G1 X137.799 Y128.174 E-.02789
G1 X137.963 Y127.91 E-.11798
G1 X138.067 Y127.613 E-.11941
G1 X138.131 Y127.268 E-.13358
G1 X138.151 Y126.867 E-.15248
G1 X138.153 Y126.318 E-.20867
; WIPE_END
G1 E-.04 F1800
G1 X140.776 Y119.268 Z5.6 F30000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4513
G1 X142.188 Y119.272 E.04683
G1 X142.187 Y119.489 E.00718
G1 X138.903 Y122.773 E.1541
G1 X138.906 Y121.554 E.04046
G1 X142.173 Y124.821 E.15328
G1 X142.167 Y127.185 E.07841
G1 X138.238 Y131.114 E.18433
G1 X140.797 Y131.121 E.0849
G1 X138.352 Y128.676 E.11472
G3 X136.955 Y129.436 I-1.644 J-1.358 E.05404
G1 X121.298 Y131.069 F30000
G1 F4513
G1 X122.926 Y131.074 E.05401
G1 X124.541 Y129.459 E.07575
G1 X123.781 Y129.457 E.02521
G1 X125.404 Y131.08 E.07615
G1 X130.582 Y131.094 E.17176
G1 X132.197 Y129.479 E.07575
G1 X131.477 Y129.477 E.02386
G1 X133.101 Y131.101 E.07615
G1 X134.729 Y131.105 E.05401
G1 X119.076 Y129.397 F30000
G1 F4513
G3 X117.67 Y128.654 I.245 J-2.164 E.05399
G1 X115.271 Y131.053 E.11256
G1 X117.708 Y131.06 E.08084
G1 X113.831 Y127.183 E.18187
G1 X113.837 Y124.811 E.07868
G1 X117.122 Y121.526 E.1541
G1 X117.119 Y122.795 E.04208
G1 X113.851 Y119.527 E.15328
G1 X113.852 Y119.197 E.01096
G1 X115.15 Y119.2 E.04305
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X113.852 Y119.197 E-.49318
G1 X113.851 Y119.527 E-.12559
G1 X114.114 Y119.79 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 27/118
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change
G17
G3 Z5.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.09 Y128.498
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F4613
G1 X138.112 Y128.467 E.00127
G2 X138.446 Y127.768 I-1.425 J-1.112 E.0259
G2 X138.543 Y126.931 I-3.109 J-.784 E.02805
G3 X138.56 Y123.838 I139.458 J-.788 E.10258
G1 X138.573 Y118.914 E.16336
G1 X142.537 Y118.924 E.13148
G1 X142.504 Y131.527 E.41806
G1 X113.471 Y131.45 E.96306
G1 X113.505 Y118.847 E.41806
G1 X117.469 Y118.858 E.13148
G2 X117.456 Y126.874 I1476.883 J6.289 E.26593
G2 X117.673 Y128.075 I3.226 J.037 E.04071
G2 X118.85 Y129.053 I1.609 J-.739 E.05247
G2 X119.657 Y129.151 I.775 J-3 E.02705
G1 X136.33 Y129.195 E.55309
G2 X137.509 Y128.965 I.025 J-3 E.04011
G2 X137.837 Y128.749 I-.822 J-1.61 E.01306
G1 X138.047 Y128.541 E.0098
M204 S250
G1 X137.794 Y128.241 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4613
M204 S5000
G1 X137.799 Y128.227 E.00045
G2 X138.066 Y127.667 I-1.119 J-.879 E.01922
G2 X138.151 Y126.92 I-2.774 J-.693 E.02317
G3 X138.168 Y123.835 I139.17 J-.785 E.09479
G1 X138.182 Y118.521 E.1633
G1 X142.93 Y118.533 E.14589
G1 X142.895 Y131.908 E.41097
G1 X142.895 Y131.92 E.00038
G1 X113.078 Y131.841 E.91618
G1 X113.078 Y131.829 E.00038
G1 X113.114 Y118.454 E.41097
G1 X117.862 Y118.467 E.14589
G1 X117.848 Y123.782 E.16332
G3 X117.848 Y126.866 I-138.808 J1.56 E.09477
G2 X118.031 Y127.91 I2.804 J.047 E.03277
G2 X118.956 Y128.674 I1.258 J-.582 E.03811
G2 X119.668 Y128.759 I.678 J-2.65 E.02211
G1 X136.321 Y128.803 E.51168
G2 X137.334 Y128.611 I.036 J-2.577 E.03191
G2 X137.589 Y128.442 I-.655 J-1.264 E.0094
G1 X137.751 Y128.283 E.00699
; WIPE_START
G1 F12000
M204 S10000
G1 X137.799 Y128.227 E-.02794
G1 X137.963 Y127.963 E-.11802
G1 X138.066 Y127.667 E-.11922
G1 X138.13 Y127.321 E-.13353
G1 X138.151 Y126.92 E-.15277
G1 X138.154 Y126.371 E-.20851
; WIPE_END
G1 E-.04 F1800
G1 X136.992 Y129.482 Z5.8 F30000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4613
G2 X138.378 Y128.702 I-.26 J-2.082 E.0541
G1 X140.85 Y131.174 E.116
G1 X138.185 Y131.167 E.08844
G1 X142.167 Y127.185 E.18682
G1 X142.173 Y124.821 E.07841
G1 X138.912 Y121.56 E.153
G1 X138.907 Y122.769 E.0401
G1 X142.187 Y119.489 E.15388
G1 X142.188 Y119.272 E.00719
G1 X140.776 Y119.268 E.04682
; WIPE_START
G1 F16200
G1 X142.188 Y119.272 E-.53638
G1 X142.187 Y119.489 E-.08239
G1 X141.925 Y119.751 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X137.874 Y126.22 Z5.8 F30000
G1 X134.782 Y131.158 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F4613
G1 X133.154 Y131.154 E.05401
G1 X131.531 Y129.531 E.07615
G1 X132.144 Y129.532 E.02032
G1 X130.529 Y131.147 E.07575
G1 X125.458 Y131.134 E.16822
G1 X123.834 Y129.51 E.07615
G1 X124.488 Y129.512 E.02168
G1 X122.873 Y131.127 E.07575
G1 X121.245 Y131.122 E.05401
; WIPE_START
G1 F16200
G1 X122.873 Y131.127 E-.61876
G1 X123.136 Y130.864 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X118.824 Y124.566 Z5.8 F30000
G1 X115.15 Y119.2 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F4613
G1 X113.852 Y119.196 E.04304
G1 X113.851 Y119.527 E.01097
G1 X117.114 Y122.79 E.15307
G1 X117.116 Y121.532 E.04174
G1 X113.837 Y124.811 E.15382
G1 X113.831 Y127.183 E.07868
G1 X117.761 Y131.113 E.18438
G1 X115.218 Y131.106 E.08437
G1 X117.644 Y128.68 E.11383
G2 X119.039 Y129.443 I1.651 J-1.361 E.05403
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X118.323 Y129.227 E-.28416
G1 X117.925 Y128.973 E-.17933
G1 X117.644 Y128.68 E-.15429
G1 X117.379 Y128.945 E-.14222
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 28/118
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change
G17
G3 Z5.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.09 Y128.552
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F5155
G1 X138.112 Y128.52 E.00127
G2 X138.446 Y127.822 I-1.425 J-1.112 E.02588
G2 X138.543 Y126.984 I-3.1 J-.784 E.02808
G2 X138.595 Y118.914 I-1270.153 J-12.19 E.2677
G1 X142.53 Y118.924 E.13053
G2 X142.518 Y126.231 I656.837 J4.747 E.24238
G1 X142.503 Y131.58 E.17745
G1 X113.471 Y131.503 E.96306
G3 X113.495 Y124.938 I585.396 J-1.119 E.21778
G1 X113.512 Y118.847 E.20205
G1 X117.447 Y118.857 E.13053
G1 X117.435 Y123.788 E.16357
G3 X117.456 Y126.927 I-73.578 J2.056 E.10414
G2 X117.673 Y128.128 I3.225 J.037 E.04072
G2 X118.85 Y129.106 I1.609 J-.739 E.05248
G2 X119.657 Y129.204 I.775 J-3 E.02705
G1 X136.33 Y129.249 E.55309
G2 X137.509 Y129.018 I.024 J-3.001 E.04011
G2 X137.837 Y128.802 I-.822 J-1.609 E.01307
G1 X138.047 Y128.594 E.00981
M204 S250
M73 P57 R7
G1 X137.794 Y128.294 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5155
M204 S5000
G1 X137.798 Y128.28 E.00044
G2 X138.066 Y127.721 I-1.119 J-.879 E.01921
G2 X138.151 Y126.973 I-2.766 J-.693 E.02319
G2 X138.204 Y118.521 I-1261.303 J-12.123 E.25972
G1 X142.923 Y118.533 E.145
G2 X142.91 Y126.231 I692.158 J5.034 E.23653
G1 X142.895 Y131.961 E.17608
G1 X142.895 Y131.974 E.00038
G1 X113.078 Y131.894 E.91618
G1 X113.078 Y131.882 E.00038
G3 X113.103 Y124.936 I619.289 J-1.218 E.21342
G1 X113.121 Y118.454 E.19919
G1 X117.84 Y118.466 E.145
G1 X117.827 Y123.783 E.16335
G3 X117.848 Y126.919 I-73.785 J2.057 E.09638
G2 X118.031 Y127.963 I2.802 J.047 E.03278
G2 X118.956 Y128.727 I1.258 J-.582 E.03811
G2 X119.668 Y128.812 I.678 J-2.649 E.02212
G1 X136.321 Y128.856 E.51168
G2 X137.334 Y128.664 I.036 J-2.578 E.03191
G2 X137.588 Y128.496 I-.654 J-1.263 E.0094
G1 X137.751 Y128.336 E.00701
; WIPE_START
G1 F12000
M204 S10000
G1 X137.798 Y128.28 E-.02778
G1 X137.963 Y128.016 E-.11807
G1 X138.066 Y127.721 E-.11899
G1 X138.13 Y127.375 E-.13353
G1 X138.151 Y126.973 E-.15306
G1 X138.152 Y126.424 E-.20857
; WIPE_END
G1 E-.04 F1800
G1 X138.881 Y127.195 Z6 F30000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5155
G3 X138.402 Y128.726 I-3.699 J-.317 E.05363
G1 X140.904 Y131.228 E.11738
G1 X138.131 Y131.221 E.09197
G1 X142.164 Y127.188 E.18919
G1 X142.165 Y126.767 E.01394
G1 X141.788 Y126.782 E.01252
G1 X141.79 Y125.924 E.02845
G2 X141.773 Y124.421 I-505.8 J4.938 E.04987
G1 X139.436 Y122.084 E.10963
G1 X139.435 Y122.241 E.0052
G1 X141.776 Y119.9 E.10982
G1 X141.776 Y119.647 E.00837
G1 X140.4 Y119.644 E.04564
G1 X138.907 Y126.532 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.38292
G1 F5155
G3 X138.918 Y124.965 I62.271 J-.368 E.04342
; LINE_WIDTH: 0.40792
G1 X138.961 Y124.422 E.0162
; LINE_WIDTH: 0.459251
G2 X139.004 Y123.848 I-4.355 J-.617 E.01954
; LINE_WIDTH: 0.486818
G1 X139.029 Y119.351 E.16268
; LINE_WIDTH: 0.48657
G1 X139.101 Y119.326 E.00274
; LINE_WIDTH: 0.44511
G1 X139.173 Y119.302 E.00249
; LINE_WIDTH: 0.385291
G1 X139.245 Y119.278 E.00212
G1 X141.98 Y119.285 E.07631
G1 X142.131 Y119.321 E.00432
G1 X142.153 Y119.445 E.00349
G1 X142.145 Y125.009 E.15524
G3 X142.152 Y126.345 I-20.217 J.771 E.03728
; WIPE_START
G1 F12000
G1 X142.145 Y125.009 E-.50768
G1 X142.146 Y124.345 E-.25232
; WIPE_END
G1 E-.04 F1800
G1 X134.889 Y126.71 Z6 F30000
G1 X121.192 Y131.175 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5155
G1 X122.82 Y131.18 E.05401
G1 X124.435 Y129.565 E.07575
G1 X123.888 Y129.564 E.01815
G1 X125.511 Y131.187 E.07615
G1 X130.476 Y131.2 E.16469
G1 X132.09 Y129.586 E.07575
G1 X131.584 Y129.584 E.01679
G1 X133.207 Y131.207 E.07615
G1 X134.836 Y131.212 E.05401
; WIPE_START
G1 F16200
G1 X133.207 Y131.207 E-.61876
G1 X132.945 Y130.945 E-.14125
; WIPE_END
G1 E-.03999 F1800
G1 X125.512 Y129.208 Z6 F30000
G1 X113.85 Y126.483 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.385106
G1 F5155
G2 X113.887 Y119.369 I-1207.113 J-9.74 E.19836
G1 X113.909 Y119.246 E.00349
G1 X114.06 Y119.211 E.00431
G1 X116.795 Y119.218 E.07627
; LINE_WIDTH: 0.40365
G1 X116.867 Y119.243 E.00223
; LINE_WIDTH: 0.44511
G1 X116.939 Y119.267 E.00249
; LINE_WIDTH: 0.487204
G1 X117.01 Y119.292 E.00275
G1 X117.018 Y119.378 E.00311
G2 X117.012 Y123.807 I252.423 J2.599 E.16037
; LINE_WIDTH: 0.46677
G1 X117.039 Y124.174 E.01269
; LINE_WIDTH: 0.43323
G1 X117.065 Y124.54 E.01169
; LINE_WIDTH: 0.38618
G3 X117.095 Y125.197 I-5.323 J.574 E.01841
G1 X117.094 Y126.429 E.03447
G1 X115.528 Y119.578 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F5155
G1 X114.262 Y119.574 E.04201
G1 X114.26 Y119.936 E.012
G1 X116.589 Y122.265 E.10925
G1 X116.589 Y122.059 E.00684
G1 X114.24 Y124.409 E.11023
G2 X114.212 Y126.846 I121.241 J2.604 E.08088
G1 X113.835 Y126.846 E.01251
G1 X113.833 Y127.185 E.01127
G1 X117.815 Y131.166 E.18677
G1 X115.165 Y131.159 E.08791
G1 X117.618 Y128.706 E.11509
G3 X117.119 Y127.184 I2.234 J-1.575 E.05392
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X117.211 Y127.854 E-.25706
G1 X117.355 Y128.274 E-.1688
G1 X117.618 Y128.706 E-.19209
G1 X117.354 Y128.97 E-.14205
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 29/118
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change
G17
G3 Z6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.136 Y128.544
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F11083
G1 X138.32 Y128.236 E.01189
G2 X138.446 Y127.875 I-1.633 J-.774 E.0127
G2 X138.543 Y127.037 I-3.097 J-.784 E.0281
G3 X138.619 Y123.851 I48.126 J-.437 E.10573
G1 X138.635 Y118.913 E.16377
G1 X142.507 Y118.924 E.12845
G1 X142.493 Y125.01 E.20191
G3 X142.503 Y131.634 I-276.568 J3.76 E.21971
G1 X113.471 Y131.556 E.96306
G1 X113.484 Y126.742 E.15972
G2 X113.535 Y118.847 I-361.425 J-6.277 E.2619
G1 X117.407 Y118.857 E.12845
G1 X117.396 Y123.794 E.16377
G3 X117.456 Y126.98 I-48.061 J2.493 E.10573
G2 X117.673 Y128.181 I3.224 J.037 E.04072
G2 X118.849 Y129.159 I1.609 J-.739 E.05248
G2 X119.657 Y129.257 I.775 J-2.999 E.02705
G1 X136.33 Y129.302 E.55309
G2 X137.509 Y129.071 I.024 J-3.001 E.04011
G2 X138.098 Y128.59 I-.822 J-1.609 E.02543
M204 S250
G1 X137.794 Y128.346 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F11083
M204 S5000
G1 X137.798 Y128.333 E.00041
G2 X138.066 Y127.774 I-1.119 J-.879 E.0192
G2 X138.151 Y127.026 I-2.763 J-.693 E.02321
G3 X138.227 Y123.838 I48.4 J-.432 E.09799
G1 X138.244 Y118.52 E.16341
G1 X142.9 Y118.533 E.14307
G1 X142.885 Y125.01 E.19903
G3 X142.894 Y132.015 I-288.791 J3.903 E.21523
G1 X142.894 Y132.027 E.00038
G1 X113.078 Y131.947 E.91618
G1 X113.078 Y131.935 E.00038
G1 X113.092 Y126.738 E.15969
G2 X113.144 Y118.454 I-374.493 J-6.494 E.25458
G1 X117.8 Y118.466 E.14307
G1 X117.788 Y123.784 E.16341
G3 X117.848 Y126.972 I-48.346 J2.498 E.09799
G2 X118.031 Y128.016 I2.802 J.048 E.03278
G2 X118.956 Y128.78 I1.258 J-.581 E.03812
G2 X119.668 Y128.865 I.678 J-2.649 E.02211
G1 X136.321 Y128.91 E.51168
G2 X137.334 Y128.718 I.036 J-2.578 E.03191
G2 X137.588 Y128.549 I-.654 J-1.263 E.0094
G1 X137.752 Y128.388 E.00704
; WIPE_START
G1 F12000
M204 S10000
G1 X137.798 Y128.333 E-.02737
G1 X137.962 Y128.069 E-.11811
G1 X138.066 Y127.774 E-.11885
G1 X138.13 Y127.429 E-.13344
G1 X138.151 Y127.026 E-.15335
G1 X138.155 Y126.476 E-.20889
; WIPE_END
G1 E-.04 F1800
G1 X137.068 Y129.575 Z6.2 F30000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F11083
G2 X138.422 Y128.746 I-.408 J-2.186 E.05385
G1 X140.957 Y131.281 E.11895
G1 X138.078 Y131.274 E.0955
G1 X142.167 Y127.185 E.19181
G2 X142.167 Y126.767 I-13.208 J-.217 E.01386
G1 X140.958 Y126.815 E.04015
G1 X138.715 Y126.46 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.42698
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X142.14 Y126.326 E.19998
G1 X142.134 Y125.849 E.02784
G1 X138.921 Y125.975 E.18757
G1 X138.925 Y125.497 E.02786
G1 X142.128 Y125.371 E.18699
G3 X142.123 Y124.894 I15.422 J-.38 E.02784
G1 X138.937 Y125.019 E.18605
G1 X138.958 Y124.541 E.02793
G1 X142.124 Y124.417 E.18485
G1 X142.125 Y123.94 E.02785
G1 X138.98 Y124.063 E.18365
G2 X138.99 Y123.585 I-6.525 J-.377 E.02788
G1 X142.127 Y123.462 E.18313
G1 X142.128 Y122.985 E.02785
G1 X138.992 Y123.108 E.18311
G1 X138.993 Y122.63 E.02785
G1 X142.129 Y122.507 E.18309
G1 X142.13 Y122.03 E.02785
G1 X138.995 Y122.153 E.18306
G1 X138.996 Y121.675 E.02785
G1 X142.131 Y121.553 E.18304
G1 X142.132 Y121.075 E.02785
G1 X138.998 Y121.198 E.18302
G1 X138.999 Y120.721 E.02785
G1 X142.134 Y120.598 E.183
G1 X142.135 Y120.12 E.02785
G1 X139.001 Y120.243 E.18298
G1 X139.002 Y119.766 E.02785
G1 X142.136 Y119.643 E.18296
G1 X142.137 Y119.292 E.02045
G1 X138.801 Y119.296 E.1946
; WIPE_START
G1 X140.801 Y119.294 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.421 Y126.137 Z6.2 F30000
G1 X134.889 Y131.265 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F11083
G1 X133.261 Y131.261 E.05401
G1 X131.638 Y129.638 E.07615
G1 X132.037 Y129.639 E.01326
G1 X130.423 Y131.253 E.07574
G1 X125.564 Y131.24 E.16116
G1 X123.941 Y129.617 E.07615
G1 X124.382 Y129.618 E.01461
G1 X122.767 Y131.233 E.07575
G1 X121.139 Y131.229 E.05401
G1 X115.123 Y126.848 F30000
G1 F11083
G1 X113.832 Y126.846 E.04283
G1 X113.831 Y127.183 E.01119
G1 X117.868 Y131.22 E.18939
G1 X115.112 Y131.213 E.09144
G1 X117.592 Y128.732 E.11639
G2 X118.965 Y129.535 I1.767 J-1.443 E.05389
G1 X113.657 Y126.402 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.42811
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X117.085 Y126.409 E.20101
G1 X117.083 Y125.931 E.02804
G1 X113.869 Y125.925 E.18855
G1 X113.877 Y125.447 E.02804
G1 X117.082 Y125.453 E.18796
G2 X117.074 Y124.975 I-6.388 J-.124 E.02805
G1 X113.886 Y124.969 E.18694
G2 X113.888 Y124.491 I-15.65 J-.3 E.02804
G1 X117.054 Y124.497 E.1857
G1 X117.035 Y124.019 E.02807
G1 X113.889 Y124.012 E.1845
G1 X113.891 Y123.534 E.02804
G1 X117.027 Y123.541 E.18394
G1 X117.028 Y123.063 E.02804
G1 X113.892 Y123.056 E.18392
G1 X113.894 Y122.578 E.02804
G1 X117.029 Y122.584 E.1839
G1 X117.03 Y122.106 E.02804
G1 X113.895 Y122.1 E.18388
G1 X113.896 Y121.622 E.02804
G1 X117.031 Y121.628 E.18386
G1 X117.032 Y121.15 E.02804
G1 X113.898 Y121.144 E.18384
G1 X113.899 Y120.666 E.02804
G1 X117.033 Y120.672 E.18382
G1 X117.034 Y120.194 E.02804
G1 X113.901 Y120.188 E.18379
G1 X113.902 Y119.709 E.02804
G1 X117.035 Y119.716 E.18377
G1 X117.036 Y119.238 E.02804
G1 X113.701 Y119.231 E.19563
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X115.701 Y119.235 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 30/118
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change
G17
G3 Z6.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.09 Y128.658
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6671
G1 X138.111 Y128.626 E.00127
G2 X138.446 Y127.929 I-1.424 J-1.111 E.02585
G2 X138.543 Y127.089 I-3.088 J-.783 E.02812
G3 X138.611 Y125.034 I17.68 J-.441 E.06825
G3 X138.687 Y123.857 I24.41 J.985 E.03914
G1 X138.704 Y118.913 E.16399
G1 X142.459 Y118.923 E.12456
G1 X142.446 Y125.007 E.20182
G2 X142.515 Y127.21 I337.717 J-9.472 E.07311
G1 X142.503 Y131.687 E.1485
G1 X113.471 Y131.61 E.96306
G1 X113.483 Y127.133 E.1485
G2 X113.564 Y124.931 I-332.847 J-13.298 E.07311
G1 X113.583 Y118.847 E.20182
G1 X117.338 Y118.856 E.12456
G1 X117.329 Y123.8 E.16399
G3 X117.459 Y125.981 I-116.122 J8.013 E.07246
G2 X117.476 Y127.473 I15.3 J.567 E.04953
G2 X117.874 Y128.577 I2.466 J-.265 E.03929
G2 X118.849 Y129.212 I1.522 J-1.269 E.0392
G2 X119.657 Y129.311 I.775 J-3 E.02705
G1 X136.33 Y129.355 E.55309
G2 X137.508 Y129.124 I.025 J-3 E.04011
G2 X137.837 Y128.909 I-.821 J-1.609 E.01306
G1 X138.047 Y128.7 E.00982
M204 S250
G1 X137.798 Y128.387 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6671
M204 S5000
G2 X138.066 Y127.828 I-1.118 J-.879 E.01918
G2 X138.151 Y127.079 I-2.755 J-.693 E.02323
G3 X138.22 Y125.001 I18.203 J-.431 E.06392
G3 X138.295 Y123.84 I24.077 J.968 E.03575
G1 X138.314 Y118.52 E.16346
G1 X142.852 Y118.532 E.13946
G1 X142.838 Y125.005 E.19889
G2 X142.907 Y127.207 I360.448 J-10.187 E.06771
G1 X142.894 Y132.068 E.14934
G1 X142.894 Y132.08 E.00038
M73 P58 R7
G1 X113.078 Y132.001 E.91618
G1 X113.078 Y131.988 E.00038
G1 X113.091 Y127.128 E.14934
G2 X113.171 Y124.926 I-356.518 J-14.166 E.06772
G1 X113.192 Y118.453 E.19888
G1 X117.731 Y118.465 E.13946
G1 X117.721 Y123.785 E.16347
G3 X117.851 Y125.977 I-114.119 J7.864 E.06746
G2 X117.866 Y127.429 I14.881 J.564 E.04464
G2 X118.188 Y128.338 I2.03 J-.207 E.02992
G2 X118.955 Y128.834 I1.186 J-.995 E.02848
G2 X119.668 Y128.919 I.678 J-2.651 E.02211
G1 X136.32 Y128.963 E.51168
G2 X137.334 Y128.771 I.036 J-2.577 E.03191
G2 X137.76 Y128.433 I-.654 J-1.263 E.01682
; WIPE_START
G1 F12000
M204 S10000
G1 X137.962 Y128.122 E-.14077
G1 X138.066 Y127.828 E-.11863
G1 X138.13 Y127.483 E-.13344
G1 X138.151 Y127.079 E-.15363
G1 X138.155 Y126.517 E-.21353
; WIPE_END
G1 E-.04 F1800
G1 X142.162 Y128.948 Z6.4 F30000
G1 Z6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F6671
G1 X142.165 Y127.728 E.04046
G1 X141.794 Y127.558 E.01356
G1 X138.025 Y131.327 E.1768
G1 X141.011 Y131.335 E.09903
G1 X138.441 Y128.765 E.12053
G3 X137.106 Y129.621 I-1.772 J-1.295 E.05383
G1 X142.123 Y127.281 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F6671
G1 X142.054 Y125.01 E.06981
G1 X142.066 Y119.314 E.17501
G1 X139.095 Y119.306 E.0913
G1 X139.079 Y123.865 E.14008
G1 X138.946 Y125.743 E.05784
G1 X138.933 Y127.138 E.04288
G1 X141.778 Y127.146 E.08743
G1 X142.067 Y127.259 E.00953
G1 X141.732 Y126.769 F30000
G1 F6671
G3 X141.677 Y125.009 I53.21 J-2.538 E.05409
G1 X141.689 Y119.69 E.16343
G1 X139.471 Y119.684 E.06815
G1 X139.456 Y123.867 E.1285
G1 X139.323 Y125.758 E.05825
G1 X139.315 Y126.762 E.03087
G1 X141.672 Y126.769 E.07243
G1 X141.343 Y126.391 F30000
G1 F6671
G3 X141.3 Y125.008 I41.267 J-1.968 E.04249
G1 X141.311 Y120.066 E.15185
G1 X139.846 Y120.063 E.04499
G1 X139.833 Y123.868 E.11692
G1 X139.7 Y125.773 E.05867
G1 X139.695 Y126.386 E.01885
G1 X141.283 Y126.39 E.04879
G1 X140.954 Y126.013 F30000
G1 F6671
G3 X140.923 Y125.008 I29.827 J-1.415 E.0309
G1 X140.933 Y120.443 E.14027
G1 X140.222 Y120.441 E.02183
G1 X140.21 Y123.869 E.10535
G1 X140.077 Y125.788 E.05909
G1 X140.075 Y126.01 E.00684
G1 X140.894 Y126.012 E.02515
G1 X140.577 Y120.797 F30000
; LINE_WIDTH: 0.378942
G1 F6671
G1 X140.566 Y123.984 E.08726
; LINE_WIDTH: 0.40239
G1 X140.547 Y124.495 E.01499
; LINE_WIDTH: 0.43761
G1 X140.528 Y125.007 E.01646
; LINE_WIDTH: 0.46984
G1 X140.523 Y125.267 E.00906
; LINE_WIDTH: 0.49908
G1 X140.517 Y125.527 E.00968
; WIPE_START
G1 F12000
G1 X140.523 Y125.267 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.231 Y127.523 Z6.4 F30000
G1 X121.086 Y131.282 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F6671
G1 X122.714 Y131.286 E.05401
G1 X124.329 Y129.671 E.07575
G1 X123.995 Y129.671 E.01108
G1 X125.618 Y131.294 E.07615
G1 X130.37 Y131.306 E.15762
G1 X131.984 Y129.692 E.07575
G1 X131.691 Y129.691 E.00973
G1 X133.314 Y131.314 E.07615
G1 X134.943 Y131.319 E.05401
G1 X118.926 Y129.582 F30000
G1 F6671
G3 X117.573 Y128.751 I.414 J-2.194 E.05385
G1 X115.058 Y131.266 E.11795
G1 X117.921 Y131.273 E.09497
G1 X114.154 Y127.506 E.17673
G1 X113.83 Y127.653 E.01182
G1 X113.826 Y128.925 E.0422
G1 X117.06 Y125.685 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F6671
G1 X116.937 Y123.806 E.05784
G1 X116.945 Y119.248 E.14008
G1 X113.973 Y119.24 E.0913
G1 X113.955 Y124.942 E.17521
G1 X113.875 Y127.206 E.06961
G1 X114.22 Y127.073 E.01137
G1 X117.065 Y127.08 E.08743
G1 X117.06 Y125.745 E.04104
G1 X116.683 Y125.698 F30000
G1 F6671
G1 X116.559 Y123.806 E.05825
G1 X116.567 Y119.624 E.1285
G1 X114.349 Y119.618 E.06815
G1 X114.333 Y124.937 E.16343
G3 X114.269 Y126.696 I-1502.688 J-53.911 E.05409
G1 X116.686 Y126.702 E.07427
G1 X116.683 Y125.758 E.02902
G1 X116.306 Y125.711 F30000
G1 F6671
G1 X116.182 Y123.805 E.05867
G1 X116.189 Y120 E.11693
G1 X114.725 Y119.996 E.04499
G1 X114.71 Y124.938 E.15185
G3 X114.66 Y126.32 I-719.777 J-25.41 E.04249
G1 X116.307 Y126.324 E.05063
G1 X116.306 Y125.771 E.01701
G1 X115.929 Y125.946 F30000
G1 F6671
G2 X115.805 Y123.804 I-241.825 J12.92 E.06592
G1 X115.812 Y120.376 E.10535
G1 X115.101 Y120.374 E.02183
G1 X115.087 Y124.939 E.14027
G3 X115.051 Y125.944 I-389.565 J-13.488 E.03089
G1 X115.869 Y125.946 E.02515
G1 X115.456 Y120.73 F30000
; LINE_WIDTH: 0.378991
G1 F6671
G1 X115.449 Y123.917 E.08727
; LINE_WIDTH: 0.40242
G1 X115.465 Y124.429 E.015
; LINE_WIDTH: 0.43766
G1 X115.482 Y124.94 E.01646
; LINE_WIDTH: 0.469895
G1 X115.486 Y125.201 E.00906
; LINE_WIDTH: 0.499125
G1 X115.49 Y125.461 E.00968
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F12000
G1 X115.486 Y125.201 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 31/118
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change
G17
G3 Z6.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.09 Y128.711
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F6350
G1 X138.111 Y128.68 E.00127
G2 X138.445 Y127.983 I-1.424 J-1.111 E.02584
G2 X138.543 Y127.142 I-3.082 J-.783 E.02814
G3 X138.69 Y125.051 I9.847 J-.357 E.06967
G3 X138.802 Y123.864 I23.791 J1.643 E.03956
G1 X138.821 Y118.913 E.16423
G1 X142.372 Y118.923 E.11778
G1 X142.361 Y125.005 E.20175
G2 X142.474 Y126.646 I16.484 J-.311 E.05459
G3 X142.514 Y127.545 I-15.53 J1.147 E.02985
G1 X142.503 Y131.74 E.13918
G1 X113.471 Y131.663 E.96306
G1 X113.482 Y127.467 E.13919
G3 X113.629 Y125.541 I32.674 J1.519 E.06408
G1 X113.649 Y124.929 E.02032
G1 X113.67 Y118.846 E.20176
G1 X117.221 Y118.856 E.11778
G1 X117.214 Y123.807 E.16423
G3 X117.319 Y124.994 I-23.665 J2.701 E.03955
G3 X117.456 Y127.086 I-9.711 J1.683 E.06967
G2 X117.874 Y128.63 I2.593 J.126 E.05392
G2 X118.849 Y129.266 I1.522 J-1.268 E.03921
G2 X119.656 Y129.364 I.775 J-3 E.02705
G1 X136.33 Y129.408 E.55309
G2 X137.508 Y129.178 I.025 J-2.999 E.04011
G2 X137.837 Y128.962 I-.821 J-1.609 E.01306
G1 X138.047 Y128.754 E.00981
M204 S250
G1 X137.797 Y128.449 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6350
M204 S5000
G1 X137.798 Y128.44 E.00029
G2 X138.065 Y127.881 I-1.118 J-.879 E.01918
G2 X138.151 Y127.132 I-2.751 J-.693 E.02325
G3 X138.301 Y125.003 I10.196 J-.351 E.0657
G3 X138.41 Y123.842 I23.27 J1.605 E.03583
G1 X138.431 Y118.52 E.16353
G1 X142.765 Y118.532 E.13317
G1 X142.753 Y125 E.19874
G2 X142.865 Y126.615 I16.289 J-.317 E.04978
G3 X142.906 Y127.541 I-15.931 J1.177 E.02848
G1 X142.894 Y132.121 E.14073
G1 X142.894 Y132.133 E.00038
G1 X113.078 Y132.054 E.91618
G1 X113.078 Y132.042 E.00038
G1 X113.09 Y127.461 E.14074
G3 X113.237 Y125.515 I22.124 J.694 E.06001
G1 X113.257 Y124.921 E.01824
G1 X113.279 Y118.453 E.19874
G1 X117.613 Y118.465 E.13317
G1 X117.606 Y123.787 E.16353
G2 X117.769 Y125.33 I28.178 J-2.207 E.04768
G3 X117.848 Y127.078 I-8.798 J1.27 E.05386
G2 X118.03 Y128.123 I2.818 J.045 E.03279
G2 X118.955 Y128.887 I1.258 J-.581 E.03813
G2 X119.668 Y128.972 I.678 J-2.649 E.02211
G1 X136.32 Y129.016 E.51168
G2 X137.334 Y128.824 I.036 J-2.577 E.03191
G2 X137.588 Y128.655 I-.654 J-1.263 E.0094
G1 X137.755 Y128.491 E.00718
; WIPE_START
G1 F12000
M204 S10000
G1 X137.798 Y128.44 E-.02564
G1 X137.962 Y128.176 E-.1182
G1 X138.065 Y127.881 E-.11846
G1 X138.13 Y127.536 E-.13337
G1 X138.151 Y127.132 E-.15392
G1 X138.156 Y126.578 E-.2104
; WIPE_END
G1 E-.04 F1800
G1 X137.144 Y129.667 Z6.6 F30000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F6350
G2 X138.461 Y128.785 I-.471 J-2.127 E.05381
G1 X141.064 Y131.388 E.12211
G1 X137.972 Y131.38 E.10257
G1 X141.794 Y127.558 E.1793
G3 X142.156 Y127.768 I-.28 J.901 E.01401
G1 X142.156 Y128.975 E.04004
G1 X142.113 Y127.124 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F6350
G2 X141.987 Y125.645 I-600.158 J50.472 E.0456
G1 X141.969 Y125.013 E.01944
G1 X141.979 Y119.314 E.17511
G1 X139.212 Y119.306 E.08503
G1 X139.194 Y123.875 E.14037
G3 X138.943 Y126.143 I-42.371 J-3.536 E.07012
G1 X138.935 Y127.148 E.0309
G1 X141.8 Y127.156 E.08804
G1 X142.113 Y127.287 E.01042
G1 X142.113 Y127.184 E.00316
G1 X141.705 Y126.779 F30000
G1 F6350
G3 X141.594 Y124.024 I20.607 J-2.215 E.08476
G1 X141.602 Y119.69 E.13318
G1 X139.588 Y119.684 E.06188
G1 X139.571 Y123.876 E.1288
G3 X139.32 Y126.169 I-41.304 J-3.361 E.07087
G1 X139.315 Y126.772 E.01854
G1 X141.645 Y126.778 E.0716
G1 X141.294 Y126.4 F30000
G1 F6350
G3 X141.216 Y124.024 I19.482 J-1.829 E.07312
G1 X141.224 Y120.066 E.1216
G1 X139.963 Y120.063 E.03874
G1 X139.948 Y123.878 E.11723
G3 X139.697 Y126.195 I-40.417 J-3.208 E.07162
G1 X139.695 Y126.396 E.00618
G1 X141.234 Y126.4 E.04729
G1 X140.794 Y125.94 F30000
; LINE_WIDTH: 0.56966
G1 F6350
G1 X140.777 Y125.281 E.0283
; LINE_WIDTH: 0.539033
G1 X140.79 Y124.652 E.02543
; LINE_WIDTH: 0.488527
G2 X140.813 Y120.475 I-415.492 J-4.372 E.15168
G1 X140.371 Y120.473 E.01605
G1 X140.36 Y123.879 E.12368
; LINE_WIDTH: 0.512985
G1 X140.286 Y124.981 E.0423
; LINE_WIDTH: 0.574316
G3 X140.194 Y125.938 I-9.641 J-.443 E.04164
G1 X140.734 Y125.94 E.02339
; WIPE_START
G1 F12000
G1 X140.194 Y125.938 E-.27345
G1 X140.286 Y124.981 E-.48655
; WIPE_END
G1 E-.04 F1800
G1 X135.419 Y130.861 Z6.6 F30000
G1 X134.996 Y131.372 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F6350
G1 X133.368 Y131.368 E.05401
G1 X131.744 Y129.744 E.07615
G1 X131.931 Y129.745 E.00619
G1 X130.316 Y131.359 E.07575
G1 X125.671 Y131.347 E.15409
G1 X124.048 Y129.724 E.07615
G1 X124.276 Y129.725 E.00755
G1 X122.661 Y131.339 E.07575
G1 X121.033 Y131.335 E.05401
; WIPE_START
G1 F16200
G1 X122.661 Y131.339 E-.61876
G1 X122.924 Y131.076 E-.14125
; WIPE_END
G1 E-.03999 F1800
G1 X117.063 Y127.09 Z6.6 F30000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F6350
G1 X117.04 Y125.822 E.03896
G3 X116.822 Y123.815 I33.124 J-4.622 E.06204
G1 X116.828 Y119.247 E.14037
G1 X114.061 Y119.24 E.08503
G1 X114.041 Y124.938 E.17511
G3 X114.02 Y125.571 I-11.036 J-.055 E.01944
G1 X113.886 Y127.045 E.04549
G1 X113.885 Y127.202 E.00481
G1 X114.198 Y127.083 E.01031
G1 X117.003 Y127.09 E.08619
G1 X116.679 Y126.712 F30000
G1 F6350
G1 X116.664 Y125.852 E.02642
G3 X116.445 Y123.815 I32.091 J-4.48 E.06297
G1 X116.45 Y119.623 E.1288
G1 X114.436 Y119.618 E.06188
G1 X114.418 Y124.934 E.16336
G3 X114.295 Y126.706 I-15.713 J-.201 E.05459
G1 X116.619 Y126.712 E.07142
G1 X116.295 Y126.334 F30000
G1 F6350
G1 X116.283 Y125.857 E.01466
G3 X116.068 Y123.814 I31.407 J-4.352 E.06313
G1 X116.073 Y119.999 E.11723
G1 X114.812 Y119.996 E.03874
G1 X114.795 Y124.935 E.15178
G3 X114.708 Y126.33 I-12.626 J-.09 E.04295
G1 X116.235 Y126.334 E.04694
G1 X115.82 Y125.872 F30000
; LINE_WIDTH: 0.57211
G1 F6350
G1 X115.742 Y125.212 E.02867
; LINE_WIDTH: 0.540668
G1 X115.701 Y124.574 E.02593
; LINE_WIDTH: 0.488595
G3 X115.656 Y123.814 I10.868 J-1.025 E.02765
G1 X115.662 Y120.408 E.12369
G1 X115.22 Y120.407 E.01605
G1 X115.21 Y123.813 E.1237
; LINE_WIDTH: 0.512995
G1 X115.231 Y124.937 E.04308
; LINE_WIDTH: 0.54981
G1 X115.233 Y125.263 E.01348
; LINE_WIDTH: 0.583807
G3 X115.212 Y125.87 I-3.514 J.185 E.0268
G1 X115.76 Y125.872 E.02416
G1 X113.832 Y128.931 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F6350
G1 X113.839 Y127.649 E.04253
G1 X114.154 Y127.506 E.01149
G1 X117.975 Y131.327 E.17923
G1 X115.005 Y131.319 E.09851
G1 X117.553 Y128.771 E.11951
G2 X118.888 Y129.628 I1.776 J-1.299 E.05383
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F16200
G1 X118.322 Y129.44 E-.22646
G1 X117.925 Y129.186 E-.17934
G1 X117.553 Y128.771 E-.21165
G1 X117.288 Y129.036 E-.14254
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 32/118
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change
G17
G3 Z6.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.136 Y128.704
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F6200
G1 X138.321 Y128.393 E.01199
G2 X138.452 Y128.008 I-1.634 J-.772 E.01352
G2 X138.544 Y126.562 I-6.056 J-1.113 E.04817
G3 X138.69 Y125.695 I3.28 J.107 E.02925
G3 X138.834 Y125.1 I4.501 J.773 E.02034
G1 X139 Y123.872 E.0411
G1 X139.023 Y118.914 E.16448
G1 X142.205 Y118.922 E.10554
G1 X142.2 Y125.01 E.20195
G2 X142.35 Y126.292 I8.518 J-.348 E.04284
G3 X142.514 Y127.775 I-8.23 J1.657 E.04956
G1 X142.503 Y131.793 E.13331
G1 X113.471 Y131.716 E.96306
G1 X113.481 Y127.697 E.13332
G3 X113.669 Y126.159 I7.703 J.157 E.05151
G2 X113.809 Y124.935 I-7.047 J-1.431 E.04092
G1 X113.838 Y118.847 E.20195
G1 X117.019 Y118.855 E.10554
G1 X117.016 Y123.813 E.16448
G1 X117.175 Y125.042 E.0411
G3 X117.453 Y126.356 I-8.861 J2.563 E.04459
G2 X117.476 Y127.578 I33.282 J-.009 E.04054
G2 X117.672 Y128.34 I2.87 J-.333 E.02621
G2 X118.849 Y129.319 I1.609 J-.738 E.0525
G2 X119.656 Y129.417 I.775 J-2.999 E.02705
G1 X136.33 Y129.462 E.55309
G2 X137.508 Y129.231 I.025 J-3 E.04011
G2 X138.098 Y128.75 I-.821 J-1.609 E.02542
M204 S250
G1 X137.8 Y128.5 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6200
M204 S5000
G1 X137.798 Y128.493 E.00023
G2 X138.071 Y127.909 I-1.121 J-.881 E.01998
G2 X138.152 Y126.555 I-5.745 J-1.022 E.04177
G3 X138.312 Y125.591 I3.659 J.111 E.03013
G2 X138.608 Y123.845 I-11.659 J-2.875 E.05447
G1 X138.633 Y118.52 E.1636
G1 X142.597 Y118.531 E.12181
G1 X142.592 Y124.997 E.19869
M73 P59 R7
G2 X142.733 Y126.205 I8.007 J-.322 E.0374
G3 X142.906 Y127.77 I-8.62 J1.743 E.04844
G1 X142.894 Y132.174 E.13533
G1 X142.894 Y132.187 E.00038
G1 X113.078 Y132.107 E.91618
G1 X113.078 Y132.095 E.00038
G1 X113.089 Y127.69 E.13534
G3 X113.285 Y126.074 I8.133 J.165 E.05011
G2 X113.417 Y124.92 I-6.647 J-1.347 E.03575
G1 X113.447 Y118.453 E.19869
G1 X117.411 Y118.464 E.12181
G1 X117.408 Y123.788 E.1636
G1 X117.56 Y124.961 E.03635
G3 X117.844 Y126.331 I-9.243 J2.637 E.04301
G2 X117.866 Y127.535 I36.407 J-.056 E.03703
G2 X118.188 Y128.445 I2.082 J-.226 E.02991
G2 X118.955 Y128.94 I1.186 J-.995 E.02848
G2 X119.668 Y129.025 I.678 J-2.649 E.02211
G1 X136.32 Y129.069 E.51168
G2 X137.334 Y128.877 I.036 J-2.578 E.03191
G2 X137.588 Y128.709 I-.657 J-1.266 E.00939
G1 X137.757 Y128.542 E.00729
; WIPE_START
G1 F12000
M204 S10000
G1 X137.798 Y128.493 E-.02428
G1 X137.963 Y128.228 E-.11856
G1 X138.071 Y127.909 E-.128
G1 X138.13 Y127.59 E-.12343
G1 X138.15 Y127.185 E-.15403
G1 X138.152 Y126.628 E-.2117
; WIPE_END
G1 E-.04 F1800
G1 X142.032 Y127.496 Z6.8 F30000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F6200
G1 X142.112 Y127.519 E.00258
G1 X142.112 Y127.46 E.00181
G2 X141.878 Y125.826 I-15.168 J1.345 E.05074
G3 X141.809 Y124.421 I9.113 J-1.152 E.04328
G1 X141.812 Y119.313 E.15694
G1 X139.413 Y119.307 E.07371
G1 X139.392 Y123.887 E.14073
G3 X139.089 Y125.741 I-14.261 J-1.383 E.05777
G1 X138.955 Y126.318 E.01819
G1 X138.917 Y127.474 E.03554
G1 X141.972 Y127.496 E.09384
G1 X141.694 Y127.116 F30000
G1 F6200
G3 X141.447 Y125.277 I16.038 J-3.094 E.05705
G1 X141.431 Y124.42 E.02633
G1 X141.435 Y119.689 E.14538
G1 X139.789 Y119.685 E.05059
G1 X139.769 Y123.889 E.12917
G3 X139.456 Y125.826 I-14.426 J-1.338 E.06035
G1 X139.331 Y126.367 E.01705
G1 X139.307 Y127.099 E.02252
G1 X141.634 Y127.116 E.07152
G1 X141.266 Y126.736 F30000
G1 F6200
G1 X141.108 Y125.8 E.02918
G3 X141.054 Y124.42 I9.8 J-1.074 E.04246
G1 X141.057 Y120.065 E.13381
G1 X140.164 Y120.063 E.02746
G1 X140.146 Y123.89 E.11761
G3 X139.858 Y125.761 I-14.83 J-1.327 E.05821
G1 X139.706 Y126.416 E.02064
G1 X139.696 Y126.725 E.00951
G1 X141.206 Y126.736 E.04639
G1 X140.759 Y126.304 F30000
; LINE_WIDTH: 0.508435
G1 F6200
G1 X140.729 Y126.018 E.01091
; LINE_WIDTH: 0.479405
G1 X140.699 Y125.732 E.01023
; LINE_WIDTH: 0.44517
G1 X140.698 Y125.417 E.01031
; LINE_WIDTH: 0.40573
G1 X140.697 Y125.102 E.0093
; LINE_WIDTH: 0.375335
G1 X140.705 Y124.819 E.00768
; LINE_WIDTH: 0.387029
G1 X140.682 Y124.752 E.00197
; LINE_WIDTH: 0.431765
G1 X140.66 Y124.686 E.00222
; LINE_WIDTH: 0.476502
G1 X140.638 Y124.619 E.00248
; LINE_WIDTH: 0.521239
G1 X140.615 Y124.553 E.00274
; LINE_WIDTH: 0.565975
G1 X140.593 Y124.486 E.00299
; LINE_WIDTH: 0.610712
G1 X140.571 Y124.42 E.00325
G1 X140.54 Y124.483 E.00325
; LINE_WIDTH: 0.565975
G1 X140.509 Y124.546 E.00299
; LINE_WIDTH: 0.521239
G1 X140.478 Y124.609 E.00274
; LINE_WIDTH: 0.476502
G1 X140.447 Y124.671 E.00248
; LINE_WIDTH: 0.431765
G1 X140.415 Y124.734 E.00222
; LINE_WIDTH: 0.386621
G1 X140.384 Y124.797 E.00197
G1 X140.337 Y125.314 E.01454
; LINE_WIDTH: 0.429423
G1 X140.299 Y125.584 E.0086
; LINE_WIDTH: 0.471328
G1 X140.26 Y125.855 E.00953
; LINE_WIDTH: 0.515846
G1 X140.173 Y126.3 E.01748
G1 X140.699 Y126.304 E.02025
G1 X140.609 Y120.512 F30000
; LINE_WIDTH: 0.56782
G1 F6200
G1 X140.6 Y123.892 E.1446
; LINE_WIDTH: 0.58907
G1 X140.587 Y124.126 E.01042
; LINE_WIDTH: 0.61841
G1 X140.574 Y124.36 E.01098
G1 X142.156 Y128.9 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F6200
G1 X142.132 Y128.028 E.02895
G2 X141.984 Y127.884 I-.215 J.073 E.00709
G1 X141.471 Y127.881 E.01702
G1 X137.919 Y131.433 E.16665
G1 X141.117 Y131.441 E.1061
G1 X138.481 Y128.805 E.12369
G3 X137.182 Y129.713 I-1.811 J-1.206 E.05381
G1 X120.979 Y131.388 F30000
G1 F6200
G1 X122.608 Y131.392 E.05401
G1 X124.222 Y129.778 E.07575
G1 X124.101 Y129.777 E.00401
G1 X125.725 Y131.401 E.07615
G1 X130.263 Y131.413 E.15056
G1 X131.878 Y129.798 E.07575
G1 X131.798 Y129.798 E.00266
G1 X133.421 Y131.421 E.07615
G1 X135.049 Y131.425 E.05401
G1 X118.85 Y129.674 F30000
G1 F6200
G3 X117.533 Y128.791 I.473 J-2.129 E.05382
G1 X114.952 Y131.372 E.12107
G1 X118.028 Y131.38 E.10204
G1 X114.447 Y127.799 E.168
G2 X114.002 Y127.812 I.084 J10.437 E.01479
G1 X113.838 Y127.942 E.00694
G1 X113.833 Y128.901 E.03179
G1 X117.05 Y126.341 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F6200
G2 X116.791 Y125.125 I-7.863 J1.036 E.03825
G3 X116.624 Y123.826 I122.645 J-16.51 E.04024
G1 X116.627 Y119.246 E.14073
G1 X114.228 Y119.24 E.07371
G1 X114.202 Y124.943 E.17525
G1 X114.156 Y125.582 E.01969
G1 X113.973 Y126.643 E.03307
G1 X113.903 Y127.439 E.02458
G1 X114.403 Y127.407 E.01541
G1 X117.079 Y127.414 E.08222
G1 X117.052 Y126.401 E.03112
G1 X116.673 Y126.352 F30000
G1 F6200
G2 X116.425 Y125.216 I-10.975 J1.797 E.03574
G3 X116.246 Y123.826 I47.951 J-6.88 E.04306
G1 X116.249 Y119.622 E.12917
G1 X114.603 Y119.618 E.05059
G1 X114.579 Y124.945 E.16368
G1 X114.532 Y125.609 E.02046
G1 X114.345 Y126.707 E.03423
G1 X114.316 Y127.035 E.01012
G3 X116.692 Y127.036 I1.099 J263.168 E.073
G1 X116.675 Y126.412 E.01919
G1 X116.296 Y126.362 F30000
G1 F6200
G2 X116.059 Y125.307 I-12.08 J2.155 E.03325
G3 X115.869 Y123.826 I33.39 J-5.037 E.04588
G1 X115.872 Y119.998 E.11761
G1 X114.978 Y119.996 E.02746
G1 X114.956 Y124.947 E.15212
G1 X114.909 Y125.636 E.02123
G1 X114.737 Y126.654 E.03171
G1 X116.304 Y126.658 E.04816
G1 X116.298 Y126.422 E.00725
G1 X115.836 Y126.226 F30000
; LINE_WIDTH: 0.511643
G1 F6200
G1 X115.781 Y125.927 E.01161
; LINE_WIDTH: 0.482248
G1 X115.726 Y125.628 E.01088
; LINE_WIDTH: 0.447165
G1 X115.69 Y125.327 E.01001
; LINE_WIDTH: 0.406395
G1 X115.654 Y125.025 E.009
; LINE_WIDTH: 0.37535
G1 X115.626 Y124.731 E.00799
; LINE_WIDTH: 0.38706
G1 X115.596 Y124.668 E.00197
; LINE_WIDTH: 0.431798
G1 X115.565 Y124.605 E.00222
; LINE_WIDTH: 0.476536
G1 X115.534 Y124.542 E.00248
; LINE_WIDTH: 0.521275
G1 X115.503 Y124.479 E.00274
; LINE_WIDTH: 0.566013
G1 X115.473 Y124.416 E.00299
; LINE_WIDTH: 0.610751
G1 X115.442 Y124.353 E.00325
G1 X115.419 Y124.419 E.00325
; LINE_WIDTH: 0.566013
G1 X115.397 Y124.486 E.00299
; LINE_WIDTH: 0.521275
G1 X115.374 Y124.552 E.00274
; LINE_WIDTH: 0.476536
G1 X115.351 Y124.619 E.00248
; LINE_WIDTH: 0.431798
G1 X115.329 Y124.685 E.00222
; LINE_WIDTH: 0.386634
G1 X115.306 Y124.751 E.00197
G1 X115.308 Y125.259 E.01422
; LINE_WIDTH: 0.430518
G1 X115.307 Y125.53 E.00856
; LINE_WIDTH: 0.474633
G1 X115.306 Y125.801 E.00954
; LINE_WIDTH: 0.519705
G1 X115.248 Y126.225 E.01662
G1 X115.776 Y126.226 E.02051
G1 X115.424 Y120.445 F30000
; LINE_WIDTH: 0.56783
G1 F6200
G1 X115.415 Y123.825 E.1446
; LINE_WIDTH: 0.58908
G1 X115.427 Y124.059 E.01042
; LINE_WIDTH: 0.61844
G1 X115.439 Y124.293 E.01098
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F11467.89
G1 X115.427 Y124.059 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 33/118
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change
G17
G3 Z6.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.135 Y128.757
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F7054
G1 X138.316 Y128.445 E.01198
G2 X138.445 Y128.09 I-1.677 J-.807 E.01253
G2 X138.543 Y127.122 I-4.566 J-.952 E.03232
G1 X138.708 Y127.102 E.00553
G1 X141.844 Y127.111 E.10403
G1 X142.476 Y127.401 E.02307
G3 X142.513 Y128.003 I-4.046 J.548 E.02003
G1 X142.503 Y131.847 E.12751
G1 X113.471 Y131.769 E.96306
G1 X113.481 Y127.926 E.12751
G3 X113.521 Y127.324 I4.077 J-.032 E.02002
G1 X114.154 Y127.037 E.02307
G1 X114.379 Y127.037 E.00747
G1 X117.29 Y127.045 E.09656
G1 X117.456 Y127.066 E.00554
G2 X117.549 Y128.035 I4.657 J.042 E.03232
G2 X118.849 Y129.372 I1.77 J-.42 E.06498
G2 X119.656 Y129.47 I.775 J-3 E.02705
G1 X136.329 Y129.515 E.55309
G2 X137.508 Y129.284 I.024 J-3.001 E.04011
G2 X138.093 Y128.8 I-.869 J-1.646 E.02538
M204 S250
G1 X137.804 Y128.548 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F7054
M204 S5000
G1 X137.96 Y128.28 E.00954
G2 X138.065 Y127.989 I-1.312 J-.637 E.00953
G2 X138.152 Y126.746 I-5.137 J-.983 E.03836
G3 X138.317 Y126.038 I2.001 J.093 E.02248
G3 X138.55 Y125.609 I1.588 J.585 E.01504
G3 X138.823 Y125.04 I2.845 J1.017 E.01942
G1 X139.049 Y123.851 E.03719
G3 X139.101 Y118.521 I553.368 J2.689 E.16378
G1 X142.189 Y118.53 E.09489
G1 X142.205 Y125.003 E.19892
G1 X142.319 Y125.606 E.01884
G1 X142.357 Y125.668 E.00224
G2 X142.634 Y126.392 I9.09 J-3.055 E.02382
G3 X142.905 Y127.998 I-4.586 J1.601 E.05031
G1 X142.894 Y132.228 E.12995
G1 X142.894 Y132.24 E.00038
G1 X113.077 Y132.161 E.91618
G1 X113.077 Y132.148 E.00038
G1 X113.089 Y127.919 E.12996
G3 X113.503 Y125.977 I4.889 J.027 E.06145
G1 X113.649 Y125.591 E.01266
G1 X113.688 Y125.529 E.00224
G1 X113.805 Y124.928 E.01884
G1 X113.855 Y118.454 E.19892
G1 X116.943 Y118.462 E.09489
G3 X116.966 Y123.793 I-553.383 J5.074 E.16378
G1 X117.187 Y124.983 E.0372
G2 X117.582 Y125.749 I6.498 J-2.867 E.02652
G3 X117.845 Y126.585 I-2.32 J1.189 E.02705
G2 X117.866 Y127.59 I26.953 J-.067 E.03088
G2 X118.188 Y128.498 I2.031 J-.209 E.02988
G2 X118.955 Y128.993 I1.186 J-.995 E.02848
G2 X119.668 Y129.078 I.678 J-2.65 E.02211
G1 X136.32 Y129.123 E.51168
G2 X137.333 Y128.931 I.036 J-2.578 E.03191
G2 X137.763 Y128.583 I-.686 J-1.287 E.01708
; WIPE_START
G1 F12000
M204 S10000
G1 X137.96 Y128.28 E-.13737
G1 X138.065 Y127.989 E-.11765
G1 X138.129 Y127.644 E-.13332
G1 X138.152 Y126.746 E-.34116
G1 X138.161 Y126.667 E-.03051
; WIPE_END
G1 E-.04 F1800
G1 X137.504 Y130.059 Z7 F30000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F7054
G2 X138.776 Y129.1 I-.591 J-2.107 E.05409
G1 X140.846 Y131.17 E.09712
G1 X138.519 Y131.164 E.07718
G1 X138.539 Y131.111 E.00188
G1 X138.242 Y131.11 E.00984
G1 X141.244 Y128.108 E.14084
G1 X141.787 Y128.111 E.01801
G1 X141.784 Y129.196 E.036
G1 X134.719 Y129.873 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.385094
G1 F7054
G1 X136.338 Y129.878 E.04515
G2 X137.684 Y129.602 I.01 J-3.376 E.03856
G1 X138.084 Y129.344 E.01329
G1 X138.415 Y128.997 E.01337
G1 X138.656 Y128.586 E.01328
G2 X138.917 Y127.721 I-5.607 J-2.169 E.0252
; LINE_WIDTH: 0.457015
G1 X138.943 Y127.691 E.00135
; LINE_WIDTH: 0.505645
G1 X138.968 Y127.66 E.0015
; LINE_WIDTH: 0.554275
G1 X138.994 Y127.629 E.00166
; LINE_WIDTH: 0.602905
G1 X139.019 Y127.599 E.00182
; LINE_WIDTH: 0.63177
G1 X141.734 Y127.61 E.13027
; LINE_WIDTH: 0.614884
G1 X141.842 Y127.636 E.00516
; LINE_WIDTH: 0.57201
G1 X141.95 Y127.662 E.00477
; LINE_WIDTH: 0.529137
G1 X142.057 Y127.688 E.00438
; LINE_WIDTH: 0.486904
G1 X142.088 Y127.796 E.00408
; LINE_WIDTH: 0.44531
G1 X142.119 Y127.905 E.0037
; LINE_WIDTH: 0.383328
G1 X142.15 Y128.013 E.00313
G1 X142.141 Y131.377 E.0933
G1 X142.127 Y131.469 E.00258
G1 X141.98 Y131.509 E.00422
G1 X138.228 Y131.499 E.10408
G1 X138.017 Y131.478 E.00588
G1 X136.598 Y131.468 F30000
; Slow Down Start
; LINE_WIDTH: 0.38292
G1 F3000;_EXTRUDE_SET_SPEED
G1 X136.135 Y131.494 E.01285
G1 X133.073 Y131.485 E.08484
G1 X132.83 Y131.463 E.00674
; Slow Down End
G1 X134.637 Y131.153 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F7054
G1 X133.41 Y131.15 E.04069
G1 X133.438 Y131.097 E.00199
G1 X133.096 Y131.096 E.01133
G1 X131.825 Y129.851 E.05903
G1 X130.21 Y131.466 E.07575
G1 X125.778 Y131.454 E.14703
G1 X124.155 Y129.831 E.07615
G1 X122.555 Y131.445 E.07541
G1 X120.926 Y131.441 E.05401
G1 X118.695 Y131.421 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.383001
G1 F7054
G1 X118.41 Y131.446 E.00792
G1 X113.993 Y131.435 E.12239
G1 X113.848 Y131.394 E.00419
G1 X113.835 Y131.301 E.0026
G1 X113.846 Y127.938 E.09321
; LINE_WIDTH: 0.401754
G1 X113.874 Y127.843 E.00291
; LINE_WIDTH: 0.43942
G1 X113.902 Y127.747 E.00321
; LINE_WIDTH: 0.477087
G1 X113.93 Y127.652 E.00352
; LINE_WIDTH: 0.51322
G1 X114.025 Y127.607 E.00401
; LINE_WIDTH: 0.54782
G1 X114.119 Y127.563 E.00431
; LINE_WIDTH: 0.580415
G1 X114.19 Y127.548 E.00316
; LINE_WIDTH: 0.625584
G1 X114.26 Y127.532 E.00342
G1 X116.977 Y127.539 E.129
; LINE_WIDTH: 0.601368
G1 X117.009 Y127.592 E.0028
; LINE_WIDTH: 0.552824
G1 X117.041 Y127.644 E.00256
; LINE_WIDTH: 0.50428
G1 X117.073 Y127.697 E.00232
; LINE_WIDTH: 0.455736
G1 X117.105 Y127.75 E.00207
; LINE_WIDTH: 0.383223
G1 X117.137 Y127.802 E.00171
G2 X117.931 Y129.314 I2.342 J-.266 E.04844
G1 X118.331 Y129.566 E.01311
G2 X119.65 Y129.833 I1.326 J-3.149 E.03755
G1 X120.957 Y129.837 E.03624
G1 X114.203 Y129.185 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F7054
G1 X114.206 Y128.027 E.03842
G1 X114.676 Y128.028 E.0156
G1 X117.757 Y131.109 E.14452
G1 X115.222 Y131.102 E.08408
G1 X117.238 Y129.086 E.09455
G2 X118.527 Y130.026 I1.894 J-1.244 E.05408
; WIPE_START
G1 F16200
G1 X118.152 Y129.886 E-.15194
G1 X117.684 Y129.586 E-.21146
G1 X117.238 Y129.086 E-.25443
G1 X116.973 Y129.351 E-.14216
; WIPE_END
G1 E-.04 F1800
G1 X116.376 Y121.742 Z7 F30000
G1 X116.135 Y118.668 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F7054
M204 S2000
G1 X116.742 Y119.274 E.02636
G1 X116.745 Y119.811
G1 X115.6 Y118.666 E.04976
G1 X115.066 Y118.665
G1 X116.749 Y120.349 E.07317
G1 X116.752 Y120.884
G1 X114.531 Y118.663 E.09651
G1 X114.06 Y118.726
G1 X116.753 Y121.419 E.11702
G1 X116.754 Y121.953
G1 X114.056 Y119.255 E.11726
G1 X114.052 Y119.784
G1 X116.756 Y122.488 E.11749
G1 X116.757 Y123.023
G1 X114.048 Y120.313 E.11773
G1 X114.044 Y120.842
G1 X116.758 Y123.557 E.11796
G1 X116.822 Y124.154
G1 X114.04 Y121.372 E.12092
G1 X114.035 Y121.901
G1 X116.943 Y124.809 E.12636
G1 X117.31 Y125.709
G1 X114.031 Y122.43 E.14247
G1 X114.027 Y122.959
G1 X117.634 Y126.566 E.15674
G1 X117.366 Y126.831
G1 X114.023 Y123.488 E.14524
G1 X114.019 Y124.017
G1 X116.823 Y126.821 E.12185
G1 X116.289 Y126.82
G1 X114.015 Y124.547 E.0988
G1 X113.991 Y125.056
G1 X115.754 Y126.819 E.07661
G1 X115.219 Y126.817
G1 X113.904 Y125.502 E.05714
G1 X113.758 Y125.889
G1 X114.684 Y126.816 E.04027
G1 X114.15 Y126.814
G1 X113.611 Y126.276 E.02341
G1 X113.479 Y126.676
G1 X113.769 Y126.967 E.01263
M204 S10000
G1 X117.542 Y126.175 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.155911
G1 F7054
G1 X117.44 Y126.028 E.00164
; LINE_WIDTH: 0.196716
G1 X117.339 Y125.881 E.00224
; LINE_WIDTH: 0.222542
G1 X117.249 Y125.769 E.0021
G1 X117.538 Y126.177 F30000
; LINE_WIDTH: 0.099755
G1 F7054
G3 X117.264 Y125.755 I6.948 J-4.81 E.00233
; WIPE_START
G1 F15000
G1 X117.538 Y126.177 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.821 Y123.893 Z7 F30000
G1 X141.265 Y118.734 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F7054
M204 S2000
G1 X141.984 Y119.454 E.03126
G1 X141.985 Y119.988
G1 X140.73 Y118.733 E.05455
G1 X140.196 Y118.732
G1 X141.987 Y120.523 E.07784
G1 X141.988 Y121.057
G1 X139.661 Y118.73 E.10113
G1 X139.304 Y118.906
G1 X141.989 Y121.592 E.11671
G1 X141.991 Y122.127
G1 X139.297 Y119.433 E.11705
G1 X139.29 Y119.96
G1 X141.992 Y122.661 E.1174
G1 X141.993 Y123.196
G1 X139.284 Y120.486 E.11774
G1 X139.279 Y121.015
G1 X141.995 Y123.73 E.11801
G1 X141.996 Y124.265
G1 X139.275 Y121.544 E.11825
G1 X139.271 Y122.073
G1 X141.997 Y124.799 E.11848
G1 X142.07 Y125.405
G1 X139.267 Y122.602 E.12182
G1 X139.262 Y123.131
G1 X142.322 Y126.191 E.13296
G1 X142.59 Y126.992
G1 X139.258 Y123.66 E.14479
G1 X139.205 Y124.141
G1 X142.004 Y126.939 E.12159
G1 X141.418 Y126.887
G1 X139.12 Y124.589 E.09987
G1 X139.035 Y125.036
G1 X140.884 Y126.885 E.08035
G1 X140.349 Y126.884
G1 X138.869 Y125.404 E.06432
G1 X138.696 Y125.764
G1 X139.814 Y126.883 E.04859
M73 P60 R7
G1 X139.28 Y126.881
G1 X138.511 Y126.112 E.03341
G1 X138.381 Y126.515
G1 X138.745 Y126.88 E.01583
; WIPE_START
G1 F12000
M204 S10000
G1 X138.381 Y126.515 E-.19582
G1 X138.511 Y126.112 E-.16097
G1 X139.261 Y126.863 E-.40321
; WIPE_END
G1 E-.04 F1800
G1 X142.141 Y125.715 Z7 F30000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.092399
G1 F7054
G3 X141.989 Y125.487 I1.126 J-.916 E.00111
; WIPE_START
G1 F15000
G1 X142.141 Y125.715 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X142.658 Y127.178 Z7 F30000
G1 Z6.6
G1 E.8 F1800
; LINE_WIDTH: 0.0911209
G1 F7054
G1 X142.443 Y127.14 E.00086
; LINE_WIDTH: 0.104388
G1 X142.317 Y127.052 E.00077
; LINE_WIDTH: 0.148259
G1 X142.191 Y126.964 E.00132
; LINE_WIDTH: 0.19213
G1 X142.065 Y126.877 E.00186
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X142.191 Y126.964 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 34/118
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change
G17
G3 Z7 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.135 Y128.811
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8172
G1 X138.316 Y128.498 E.01198
G2 X138.444 Y128.144 I-1.677 J-.806 E.01251
G2 X138.543 Y126.915 I-5.131 J-1.031 E.04098
G3 X138.63 Y126.626 I.488 J-.011 E.01018
G1 X141.87 Y126.635 E.10747
G3 X142.195 Y126.883 I-.028 J.373 E.01435
G3 X142.433 Y127.416 I-1.128 J.825 E.01951
G3 X142.513 Y128.177 I-3.559 J.757 E.0254
G1 X142.503 Y131.9 E.12351
G1 X113.47 Y131.823 E.96306
G1 X113.48 Y128.099 E.12352
G3 X113.773 Y126.84 I2.352 J-.117 E.04344
G3 X113.973 Y126.597 I2.361 J1.732 E.01044
G3 X114.381 Y126.562 I.273 J.784 E.01372
G1 X117.371 Y126.57 E.09919
G3 X117.456 Y126.859 I-.402 J.276 E.01018
G2 X117.552 Y128.097 I4.161 J.302 E.04134
G2 X118.849 Y129.425 I1.765 J-.426 E.06466
G2 X119.656 Y129.524 I.775 J-3.002 E.02705
G1 X136.329 Y129.568 E.55309
G2 X137.508 Y129.337 I.025 J-3 E.04011
G2 X138.093 Y128.853 I-.868 J-1.645 E.02538
M204 S250
G1 X137.807 Y128.596 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F8172
M204 S5000
G1 X137.96 Y128.333 E.00933
G2 X138.065 Y128.042 I-1.311 J-.636 E.00952
G2 X138.151 Y126.907 I-4.789 J-.937 E.03507
G3 X138.463 Y126.281 I.767 J-.008 E.0223
G3 X138.657 Y126.234 I.189 J.358 E.00619
G1 X141.897 Y126.243 E.09956
G3 X142.499 Y126.634 I-.016 J.684 E.02324
G3 X142.813 Y127.315 I-1.482 J1.094 E.02318
G3 X142.905 Y128.171 I-3.966 J.86 E.02649
G1 X142.894 Y132.281 E.12629
G1 X142.894 Y132.293 E.00038
G1 X113.077 Y132.214 E.91618
G1 X113.077 Y132.201 E.00038
G1 X113.088 Y128.091 E.1263
G3 X113.356 Y126.765 I3.019 J-.08 E.04193
G3 X113.757 Y126.264 I1.674 J.928 E.01981
G3 X114.382 Y126.17 I.473 J1.02 E.01967
G1 X117.346 Y126.178 E.0911
G3 X117.793 Y126.549 I-.05 J.514 E.01896
G3 X117.847 Y127.237 I-1.829 J.491 E.02131
G2 X118.03 Y128.282 I2.817 J.046 E.0328
G2 X118.955 Y129.047 I1.258 J-.581 E.03814
G2 X119.667 Y129.132 I.678 J-2.651 E.02211
G1 X136.32 Y129.176 E.51168
G2 X137.333 Y128.984 I.036 J-2.577 E.03191
G2 X137.765 Y128.634 I-.685 J-1.287 E.01716
M204 S10000
G1 X138.434 Y128.634 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.42279
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X140.955 Y127.452 E.15924
G1 X139.855 Y127.445 E.06289
G1 X138.638 Y128.016 E.07688
G1 X138.937 Y127.023 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.43216
; LAYER_HEIGHT: 0.2
G1 F8172
G1 X141.749 Y127.035 E.0892
G1 X140.745 Y131.728 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.42279
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X142.133 Y131.077 E.08771
G1 X142.133 Y130.555 E.02987
G1 X140.067 Y131.524 E.13054
G1 X138.96 Y131.521 E.06333
G1 X142.133 Y130.032 E.2005
G1 X142.133 Y129.51 E.02987
G1 X138.044 Y131.428 E.25839
G1 X138.204 Y130.99 E.0267
G1 X137.46 Y131.18 E.04393
G1 X142.134 Y128.988 E.29528
G1 X142.134 Y128.466 E.02987
G1 X135.638 Y131.512 E.41037
G1 X134.531 Y131.509 E.06333
G1 X142.134 Y127.943 E.48033
G1 X142.056 Y127.459 E.02809
G1 X133.424 Y131.506 E.54534
G1 X132.82 Y131.505 E.03452
G1 X132.987 Y131.189 E.02042
G1 X136.088 Y129.735 E.19591
G1 X137.647 Y131.532 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.38292
; LAYER_HEIGHT: 0.2
G1 F8172
G1 X137.626 Y131.568 E.00118
G1 X137.562 Y131.532 E.00204
G1 X137.574 Y131.525 E.00038
G1 X133.709 Y129.944 F30000
; LINE_WIDTH: 0.401945
G1 F8172
G1 X121.38 Y129.911 E.36069
G1 X121.459 Y130.271 E.01077
G1 X133.748 Y130.303 E.35951
G1 X134.403 Y129.996 E.02116
G1 X134.388 Y129.965 E.00099
G1 X133.769 Y129.946 E.01814
G1 X121.366 Y131.002 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F8172
G1 X122.994 Y131.006 E.05401
G1 X123.341 Y130.659 E.0163
G1 X124.987 Y130.663 E.05459
G1 X125.336 Y131.012 E.01639
G1 X130.65 Y131.026 E.17625
G1 X130.997 Y130.679 E.0163
G1 X132.684 Y130.684 E.05595
G1 X132.746 Y130.746 E.00295
G1 X132.585 Y131.032 E.01086
G1 X131.288 Y131.028 E.04305
G1 X119.591 Y131.418 F30000
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.47784
G1 F3000;_EXTRUDE_SET_SPEED
G1 X132.288 Y131.452 E.44998
; Slow Down End
G1 X117.992 Y131.668 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.41897
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X121.038 Y130.239 E.18896
G1 X120.962 Y129.897 E.0197
G1 X120.665 Y129.896 E.01668
G1 X117.324 Y131.463 E.20733
G1 X116.225 Y131.46 E.06169
G1 X119.575 Y129.889 E.20783
G3 X118.721 Y129.772 I.151 J-4.269 E.04853
G1 X115.127 Y131.457 E.22295
G1 X114.029 Y131.455 E.06169
G1 X118.156 Y129.519 E.25605
G3 X117.748 Y129.192 I.476 J-1.013 E.02964
G1 X113.842 Y131.024 E.24231
G1 X113.844 Y130.506 E.02913
G1 X117.457 Y128.811 E.22419
G3 X117.26 Y128.385 I.955 J-.701 E.02652
G1 X113.845 Y129.987 E.21187
G1 X113.846 Y129.468 E.02913
G1 X117.143 Y127.922 E.20456
G3 X117.099 Y127.425 I1.768 J-.407 E.02814
G1 X113.848 Y128.95 E.20175
G1 X113.849 Y128.431 E.02913
G1 X116.095 Y127.378 E.13932
G1 X114.996 Y127.375 E.06169
G1 X113.655 Y128.004 E.08323
G1 X114.168 Y126.967 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42518
; LAYER_HEIGHT: 0.2
G1 F8172
G1 X117.003 Y126.964 E.0883
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X115.003 Y126.966 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 35/118
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change
G17
G3 Z7.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.135 Y128.864
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F5539
G1 X138.319 Y128.555 E.01193
G2 X138.441 Y128.206 I-1.624 J-.765 E.01228
G2 X138.544 Y127.112 I-3.881 J-.919 E.03658
G1 X141.881 Y127.121 E.11069
G3 X142.326 Y127.386 I.009 J.489 E.0181
G3 X142.512 Y128.338 I-1.799 J.846 E.03249
G1 X142.503 Y131.953 E.11994
G1 X113.47 Y131.876 E.96306
G1 X113.48 Y128.26 E.11994
G3 X113.671 Y127.31 I1.986 J-.095 E.03249
G3 X114.117 Y127.047 I.434 J.226 E.0181
G1 X114.94 Y127.049 E.02729
G1 X117.454 Y127.056 E.0834
G2 X117.672 Y128.5 I3.405 J.225 E.04883
G2 X118.849 Y129.479 I1.609 J-.738 E.05251
G2 X119.656 Y129.577 I.775 J-2.999 E.02705
G1 X136.329 Y129.621 E.55309
G2 X137.508 Y129.391 I.025 J-3 E.04011
G2 X138.097 Y128.91 I-.813 J-1.6 E.02542
M204 S250
G1 X137.811 Y128.642 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5539
M204 S5000
G1 X137.962 Y128.388 E.00907
G2 X138.063 Y128.099 I-1.279 J-.61 E.00944
G2 X138.16 Y126.949 I-5.457 J-1.037 E.03552
G3 X138.421 Y126.719 I.249 J.02 E.01183
G1 X141.9 Y126.729 E.10689
G3 X142.57 Y127.065 I.044 J.748 E.02414
G3 X142.894 Y128.037 I-1.351 J.99 E.03199
G1 X142.894 Y132.334 E.13203
G1 X142.894 Y132.346 E.00038
G1 X113.077 Y132.267 E.91618
G1 X113.077 Y132.255 E.00038
G1 X113.088 Y128.252 E.12299
G3 X113.344 Y127.091 I2.346 J-.092 E.03695
G3 X113.587 Y126.808 I1.782 J1.288 E.01148
G3 X114.1 Y126.655 I.497 J.728 E.01673
G1 X114.941 Y126.657 E.02582
G1 X117.579 Y126.664 E.08106
G3 X117.845 Y126.937 I.012 J.255 E.01323
G2 X117.93 Y128.045 I3.768 J.27 E.03429
G2 X118.955 Y129.1 I1.381 J-.317 E.0475
G2 X119.667 Y129.185 I.678 J-2.649 E.02211
G1 X136.32 Y129.229 E.51168
G2 X137.333 Y129.037 I.036 J-2.577 E.03191
G2 X137.771 Y128.686 I-.65 J-1.259 E.01736
; WIPE_START
G1 F12000
M204 S10000
G1 X137.962 Y128.388 E-.1344
G1 X138.063 Y128.099 E-.1165
G1 X138.129 Y127.75 E-.13484
M73 P60 R6
G1 X138.16 Y126.949 E-.30467
G1 X138.189 Y126.852 E-.03851
G1 X138.235 Y126.784 E-.03109
; WIPE_END
G1 E-.04 F1800
G1 X142.111 Y128.169 Z7.4 F30000
G1 Z7
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F5539
G1 X142.013 Y127.642 E.01645
G1 X141.931 Y127.53 E.00427
G1 X141.456 Y127.511 E.01463
G1 X138.922 Y127.505 E.07784
G3 X138.414 Y129.153 I-2.739 J.057 E.05391
G1 X138.071 Y129.498 E.01497
G1 X137.664 Y129.751 E.01471
G3 X136.334 Y130.013 I-1.32 J-3.19 E.04193
G1 X119.649 Y129.969 E.51264
G3 X118.285 Y129.682 I.005 J-3.405 E.04314
G1 X117.881 Y129.417 E.01486
G1 X117.547 Y129.062 E.01497
G1 X117.303 Y128.633 E.01516
G3 X117.074 Y127.447 I3.171 J-1.228 E.03733
G1 X114.163 Y127.439 E.08943
G1 X114.051 Y127.476 E.00364
G1 X113.934 Y127.749 E.00913
G1 X113.872 Y128.276 E.01629
G1 X113.863 Y131.485 E.09861
G1 X142.111 Y131.56 E.86794
G1 X142.111 Y128.229 E.10236
G1 X141.734 Y128.169 F30000
G1 F5539
G1 X141.681 Y127.889 E.00875
G1 X139.283 Y127.883 E.07368
G1 X139.172 Y128.446 E.01763
G1 X138.991 Y128.93 E.01589
G1 X138.684 Y129.415 E.01763
G1 X138.272 Y129.817 E.01768
G1 X137.794 Y130.105 E.01714
G3 X136.333 Y130.39 I-1.469 J-3.63 E.04604
G1 X119.648 Y130.346 E.51264
G3 X118.082 Y129.999 I-.044 J-3.513 E.04973
G1 X117.609 Y129.678 E.01757
G1 X117.222 Y129.253 E.01767
G1 X116.951 Y128.769 E.01702
G3 X116.712 Y127.823 I3.188 J-1.31 E.0301
G1 X114.306 Y127.816 E.07392
G1 X114.249 Y128.328 E.01582
G1 X114.241 Y131.109 E.08545
G1 X141.733 Y131.182 E.84474
G1 X141.734 Y128.229 E.09074
G1 X141.357 Y128.265 F30000
G1 F5539
G1 X139.598 Y128.261 E.05406
G1 X139.4 Y128.937 E.02164
G1 X139.089 Y129.503 E.01984
G1 X138.646 Y129.996 E.02038
G1 X138.102 Y130.371 E.02028
G1 X137.517 Y130.609 E.01941
; LINE_WIDTH: 0.4347
G1 X137.228 Y130.685 E.00954
; LINE_WIDTH: 0.454238
G1 X136.939 Y130.761 E.01002
G1 X137.55 Y130.794 E.0205
; LINE_WIDTH: 0.41999
G1 X141.356 Y130.804 E.11696
G1 X141.357 Y128.325 E.07616
G1 X140.98 Y128.641 F30000
G1 F5539
G1 X139.899 Y128.639 E.03321
G1 X139.639 Y129.315 E.02228
G1 X139.225 Y129.941 E.02305
G1 X138.718 Y130.42 E.02143
G1 X140.979 Y130.426 E.06949
G1 X140.98 Y128.701 E.05299
G1 X140.603 Y129.017 F30000
G1 F5539
G1 X140.171 Y129.016 E.01327
G1 X139.963 Y129.508 E.0164
G1 X139.617 Y130.045 E.01964
G1 X140.602 Y130.048 E.03028
G1 X140.603 Y129.077 E.02981
G1 X140.274 Y129.664 F30000
; LINE_WIDTH: 0.3619
G1 F5539
G1 X140.215 Y129.699 E.00179
G1 X140.257 Y129.723 E.00127
G1 X136.928 Y130.762 F30000
; LINE_WIDTH: 0.445984
G1 F5539
G1 X136.331 Y130.779 E.01961
G1 X133.174 Y130.771 E.10371
; Slow Down Start
; LINE_WIDTH: 0.443012
G1 F3000;_EXTRUDE_SET_SPEED
G1 X120.529 Y130.737 E.41225
; Slow Down End
; LINE_WIDTH: 0.450871
G1 F5539
G3 X119.1 Y130.716 I-.387 J-21.813 E.04753
G1 X119.04 Y130.713 F30000
; LINE_WIDTH: 0.466828
G1 F5539
G1 X118.751 Y130.636 E.01032
; LINE_WIDTH: 0.420383
G1 X118.463 Y130.558 E.00919
G1 X117.879 Y130.317 E.01943
G1 X117.337 Y129.939 E.02031
G1 X116.897 Y129.444 E.0204
G1 X116.595 Y128.892 E.01934
G1 X116.427 Y128.374 E.01675
M73 P61 R6
G1 X116.395 Y128.199 E.00547
G1 X114.641 Y128.194 E.05395
G2 X114.619 Y130.733 I87.296 J2.007 E.07809
G1 X118.604 Y130.743 E.12257
; LINE_WIDTH: 0.435603
G1 X118.792 Y130.73 E.00602
; LINE_WIDTH: 0.466828
G1 X118.98 Y130.717 E.0065
G1 X117.263 Y130.363 F30000
; LINE_WIDTH: 0.41999
G1 F5539
G1 X116.758 Y129.881 E.02144
G1 X116.354 Y129.264 E.02268
G1 X116.091 Y128.575 E.02263
G1 X115.002 Y128.572 E.03346
G1 X114.998 Y130.357 E.05483
G1 X117.203 Y130.363 E.06776
G1 X116.366 Y129.983 F30000
G1 F5539
G1 X116.029 Y129.454 E.01928
G1 X115.818 Y128.952 E.01675
G1 X115.378 Y128.95 E.01349
G1 X115.376 Y129.981 E.03166
G1 X116.306 Y129.983 E.02858
G1 X115.747 Y129.597 F30000
; LINE_WIDTH: 0.366
G1 F5539
G1 X115.686 Y129.632 E.00184
G1 X115.73 Y129.657 E.00132
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F12000
G1 X115.686 Y129.632 E-.31799
G1 X115.747 Y129.597 E-.44201
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 36/118
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change
G17
G3 Z7.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.089 Y128.977
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F5349
G1 X138.111 Y128.946 E.00125
G2 X138.439 Y128.266 I-1.41 J-1.097 E.02524
G2 X138.541 Y127.435 I-3.742 J-.881 E.02781
G1 X141.887 Y127.444 E.111
G3 X142.275 Y127.553 I.023 J.669 E.01359
G3 X142.503 Y128.228 I-.898 J.679 E.02408
G1 X142.502 Y132.006 E.12532
G1 X113.47 Y131.929 E.96306
G1 X113.479 Y128.412 E.11667
G3 X113.668 Y127.541 I1.547 J-.121 E.02999
G3 X113.942 Y127.382 I.339 J.268 E.01075
G3 X114.413 Y127.371 I.311 J3.379 E.01567
G1 X117.456 Y127.379 E.10094
G2 X117.873 Y128.896 I2.576 J.108 E.05302
G2 X118.849 Y129.532 I1.522 J-1.269 E.03921
G2 X119.656 Y129.63 I.775 J-2.999 E.02705
G1 X136.329 Y129.675 E.55309
G2 X137.508 Y129.444 I.024 J-3.001 E.04011
G2 X137.837 Y129.229 I-.807 J-1.595 E.01307
G1 X138.047 Y129.019 E.00984
M204 S250
G1 X137.816 Y128.687 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5349
M204 S5000
G1 X137.958 Y128.439 E.00877
G2 X138.073 Y128.11 I-1.328 J-.65 E.01073
G2 X138.153 Y127.11 I-4.79 J-.885 E.03091
G1 X138.163 Y127.069 E.0013
G1 X138.191 Y127.05 E.00102
G3 X138.252 Y127.043 I.055 J.199 E.00191
G1 X141.901 Y127.052 E.11213
G3 X142.744 Y127.563 I.075 J.827 E.03241
G3 X142.904 Y128.483 I-2.222 J.86 E.02889
G1 X142.893 Y132.387 E.11997
G1 X142.893 Y132.4 E.00038
G1 X113.077 Y132.32 E.91618
G1 X113.077 Y132.308 E.00038
G1 X113.087 Y128.404 E.11997
G3 X113.342 Y127.32 I1.934 J-.117 E.0347
G3 X114.097 Y126.978 I.678 J.494 E.02664
G1 X114.414 Y126.979 E.00974
G1 X117.747 Y126.988 E.10239
G3 X117.848 Y127.094 I.026 J.076 E.00565
G2 X118.03 Y128.388 I2.985 J.24 E.04047
G2 X118.955 Y129.153 I1.258 J-.58 E.03814
G2 X119.667 Y129.238 I.678 J-2.649 E.02211
G1 X136.32 Y129.282 E.51168
G2 X137.333 Y129.09 I.036 J-2.578 E.03191
G2 X137.773 Y128.728 I-.704 J-1.3 E.01762
; WIPE_START
G1 F12000
M204 S10000
G1 X137.958 Y128.439 E-.13017
G1 X138.073 Y128.11 E-.13241
G1 X138.129 Y127.805 E-.11821
G1 X138.153 Y127.11 E-.2642
G1 X138.163 Y127.069 E-.01609
G1 X138.191 Y127.05 E-.01258
G1 X138.252 Y127.043 E-.02349
G1 X138.417 Y127.043 E-.06286
; WIPE_END
G1 E-.04 F1800
G1 X140.274 Y129.718 Z7.6 F30000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.36182
G1 F5349
G1 X140.214 Y129.752 E.00179
G1 X140.257 Y129.777 E.00127
G1 X139.617 Y130.098 F30000
; LINE_WIDTH: 0.41999
G1 F5349
G1 X140.602 Y130.101 E.03028
G1 X140.602 Y129.348 E.02313
G1 X140.065 Y129.345 E.0165
G1 X139.737 Y129.941 E.0209
G1 X139.653 Y130.051 E.00425
G1 X138.718 Y130.473 F30000
G1 F5349
G1 X140.979 Y130.479 E.06949
G1 X140.979 Y128.973 E.04626
G1 X139.807 Y128.966 E.03602
G1 X139.631 Y129.382 E.01387
G1 X139.225 Y129.994 E.02257
G1 X138.761 Y130.432 E.01959
G1 X136.939 Y130.814 F30000
; LINE_WIDTH: 0.46412
G1 F5349
G1 X137.244 Y130.831 E.01049
; LINE_WIDTH: 0.420386
G1 X137.55 Y130.847 E.0094
G1 X141.356 Y130.857 E.11708
G1 X141.357 Y128.599 E.06947
G1 X139.536 Y128.588 E.056
G1 X139.329 Y129.15 E.01843
G1 X138.955 Y129.731 E.02127
G1 X138.474 Y130.189 E.02041
G1 X137.924 Y130.512 E.0196
G1 X137.362 Y130.705 E.0183
; LINE_WIDTH: 0.4347
G1 X137.179 Y130.752 E.00601
; LINE_WIDTH: 0.46412
G1 X136.997 Y130.799 E.00646
G1 X119.649 Y130.022 F30000
; LINE_WIDTH: 0.41999
G1 F5349
G3 X118.285 Y129.735 I.005 J-3.405 E.04314
G1 X117.881 Y129.47 E.01486
G1 X117.547 Y129.115 E.01497
G1 X117.306 Y128.694 E.01492
G1 X117.143 Y128.163 E.01705
G1 X117.094 Y127.771 E.01216
G1 X114.418 Y127.763 E.08223
G1 X113.986 Y127.795 E.01331
G1 X113.9 Y128.063 E.00864
G1 X113.871 Y128.454 E.01205
G1 X113.863 Y131.538 E.09477
G1 X142.11 Y131.613 E.86794
G1 X142.111 Y128.3 E.1018
G1 X142.024 Y127.894 E.01276
G1 X141.952 Y127.848 E.00263
G1 X138.897 Y127.83 E.09388
G1 X138.822 Y128.346 E.01604
G1 X138.658 Y128.804 E.01494
G1 X138.414 Y129.206 E.01445
G1 X138.07 Y129.552 E.01497
G1 X137.663 Y129.804 E.01472
G3 X136.333 Y130.067 I-1.32 J-3.191 E.04193
G1 X119.709 Y130.022 E.5108
G1 X119.648 Y130.399 F30000
G1 F5349
G3 X118.082 Y130.053 I-.044 J-3.513 E.04973
G1 X117.609 Y129.731 E.01757
G1 X117.222 Y129.306 E.01767
G1 X116.945 Y128.804 E.0176
G2 X116.731 Y128.147 I-4.079 J.963 E.02128
G1 X114.272 Y128.144 E.07556
G1 X114.248 Y128.455 E.00959
G1 X114.241 Y131.162 E.08318
G1 X141.733 Y131.235 E.84474
G1 X141.722 Y128.224 E.09253
G1 X139.223 Y128.209 E.07677
G1 X139.169 Y128.506 E.00929
G1 X138.991 Y128.983 E.01565
G1 X138.684 Y129.469 E.01764
G1 X138.272 Y129.87 E.01768
G1 X137.794 Y130.158 E.01715
G3 X136.332 Y130.444 I-1.469 J-3.631 E.04604
G1 X119.708 Y130.399 E.5108
G1 X119.04 Y130.767 F30000
; LINE_WIDTH: 0.444213
G1 F5349
G2 X119.647 Y130.788 I.815 J-14.559 E.01989
G1 X136.331 Y130.832 E.54558
G1 X136.868 Y130.817 E.01757
G1 X119.04 Y130.767 F30000
; LINE_WIDTH: 0.466813
G1 F5349
G1 X118.751 Y130.689 E.01032
; LINE_WIDTH: 0.420399
G1 X118.463 Y130.611 E.00919
G1 X117.879 Y130.37 E.01943
G1 X117.337 Y129.993 E.02031
G1 X116.896 Y129.497 E.0204
G1 X116.585 Y128.915 E.0203
G1 X116.464 Y128.523 E.01262
G1 X114.625 Y128.518 E.05656
G1 X114.619 Y130.786 E.06976
G1 X118.604 Y130.797 E.12257
; LINE_WIDTH: 0.435598
G1 X118.792 Y130.784 E.00602
; LINE_WIDTH: 0.466813
G1 X118.98 Y130.771 E.0065
G1 X117.263 Y130.416 F30000
; LINE_WIDTH: 0.41999
G1 F5349
G1 X116.758 Y129.934 E.02144
G1 X116.354 Y129.317 E.02268
G1 X116.185 Y128.899 E.01383
G1 X115.001 Y128.896 E.03638
G1 X114.997 Y130.41 E.04652
G1 X117.203 Y130.416 E.06776
G1 X116.366 Y130.037 F30000
G1 F5349
G1 X116.028 Y129.508 E.01928
G1 X115.922 Y129.276 E.00784
G1 X115.377 Y129.274 E.01673
G1 X115.375 Y130.034 E.02334
G1 X116.306 Y130.036 E.02858
G1 X115.747 Y129.65 F30000
; LINE_WIDTH: 0.36604
G1 F5349
G1 X115.686 Y129.685 E.00184
G1 X115.73 Y129.71 E.00133
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X115.686 Y129.685 E-.31809
G1 X115.747 Y129.65 E-.44191
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 37/118
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change
G17
G3 Z7.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.135 Y128.971
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F5259
G1 X138.319 Y128.661 E.01194
G2 X138.441 Y128.313 I-1.624 J-.764 E.01225
G2 X138.531 Y127.664 I-3.239 J-.784 E.02178
G1 X141.886 Y127.673 E.11128
G3 X142.395 Y127.907 I.059 J.542 E.01952
G3 X142.511 Y128.606 I-2.101 J.71 E.02362
G1 X142.502 Y132.06 E.11456
G1 X113.47 Y131.982 E.96306
G1 X113.479 Y128.529 E.11456
G3 X113.643 Y127.762 I1.407 J-.101 E.02637
G3 X114.109 Y127.599 I.407 J.416 E.01694
G1 X116.993 Y127.606 E.09566
G1 X117.464 Y127.608 E.01561
G2 X117.873 Y128.949 I2.401 J.002 E.04721
G2 X118.848 Y129.585 I1.522 J-1.268 E.03921
G2 X119.656 Y129.683 I.775 J-3.001 E.02705
G1 X136.329 Y129.728 E.55309
G2 X137.507 Y129.497 I.025 J-3 E.04011
G2 X138.097 Y129.017 I-.813 J-1.6 E.02542
M204 S250
G1 X137.822 Y128.73 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5259
M204 S5000
G1 X137.962 Y128.494 E.00843
G2 X138.063 Y128.206 I-1.279 J-.61 E.00941
G2 X138.15 Y127.271 I-3.327 J-.783 E.02896
G1 X141.901 Y127.281 E.11524
G3 X142.864 Y128.11 I.065 J.898 E.04335
G3 X142.904 Y128.6 I-2.543 J.453 E.01512
G1 X142.893 Y132.441 E.11802
G1 X142.893 Y132.453 E.00038
G1 X113.077 Y132.374 E.91618
G1 X113.077 Y132.361 E.00038
G1 X113.087 Y128.52 E.11802
G3 X113.333 Y127.518 I1.757 J-.1 E.03219
G3 X114.097 Y127.207 I.712 J.654 E.02618
G1 X116.994 Y127.214 E.08903
G1 X117.846 Y127.217 E.02618
G2 X118.029 Y128.441 I2.932 J.188 E.03834
G2 X118.954 Y129.206 I1.258 J-.58 E.03815
G2 X119.667 Y129.291 I.678 J-2.65 E.02211
G1 X136.319 Y129.336 E.51168
G2 X137.333 Y129.144 I.036 J-2.577 E.03191
G2 X137.784 Y128.777 I-.65 J-1.259 E.01799
; WIPE_START
G1 F12000
M204 S10000
G1 X137.962 Y128.494 E-.12682
G1 X138.063 Y128.206 E-.11614
G1 X138.129 Y127.858 E-.13475
G1 X138.15 Y127.271 E-.22319
G1 X138.569 Y127.272 E-.15911
; WIPE_END
G1 E-.04 F1800
G1 X139.718 Y130.101 Z7.8 F30000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.520923
G1 F5259
G1 X140.552 Y130.104 E.03246
G1 X140.552 Y129.627 E.01858
G1 X140.014 Y129.624 E.02094
G1 X139.75 Y130.05 E.01955
G1 X138.718 Y130.526 F30000
; LINE_WIDTH: 0.41999
G1 F5259
G1 X140.979 Y130.532 E.06949
G1 X140.979 Y129.202 E.04089
G1 X139.745 Y129.194 E.03793
G1 X139.413 Y129.801 E.02125
G1 X138.916 Y130.365 E.0231
G1 X138.764 Y130.489 E.006
G1 X136.939 Y130.867 F30000
; LINE_WIDTH: 0.464128
G1 F5259
G1 X137.244 Y130.884 E.0105
; LINE_WIDTH: 0.420397
G1 X137.55 Y130.9 E.00941
G1 X141.356 Y130.91 E.11709
G1 X141.356 Y128.827 E.06409
G1 X139.479 Y128.816 E.05775
G1 X139.254 Y129.331 E.01728
G1 X138.954 Y129.785 E.01673
G1 X138.473 Y130.242 E.02042
G1 X137.924 Y130.565 E.01959
G1 X137.361 Y130.758 E.0183
; LINE_WIDTH: 0.434703
G1 X137.179 Y130.805 E.00601
; LINE_WIDTH: 0.464128
G1 X136.997 Y130.852 E.00646
G1 X119.649 Y130.076 F30000
; LINE_WIDTH: 0.41999
G1 F5259
G3 X118.285 Y129.788 I.005 J-3.405 E.04314
G1 X117.881 Y129.523 E.01486
G1 X117.547 Y129.168 E.01497
G1 X117.305 Y128.748 E.01489
G1 X117.152 Y128.269 E.01547
G1 X117.109 Y127.999 E.0084
G1 X114.139 Y127.991 E.09125
G1 X113.969 Y128.021 E.0053
G2 X113.871 Y128.586 I1.521 J.555 E.01769
G1 X113.863 Y131.591 E.09236
G1 X142.11 Y131.667 E.86794
G1 X142.111 Y128.463 E.09845
G1 X142.028 Y128.101 E.0114
G1 X141.725 Y128.075 E.00935
G1 X138.883 Y128.058 E.08734
G1 X138.816 Y128.428 E.01157
G1 X138.606 Y128.946 E.01715
G1 X138.414 Y129.259 E.0113
G1 X138.07 Y129.605 E.01497
G1 X137.663 Y129.857 E.01471
G3 X136.333 Y130.12 I-1.32 J-3.191 E.04193
G1 X119.709 Y130.076 E.5108
G1 X119.648 Y130.453 F30000
G1 F5259
G3 X118.082 Y130.106 I-.044 J-3.513 E.04973
G1 X117.609 Y129.784 E.01757
G1 X117.222 Y129.359 E.01767
G1 X116.947 Y128.865 E.01738
G1 X116.791 Y128.375 E.01579
G1 X114.273 Y128.368 E.07735
G1 X114.248 Y128.587 E.00675
G1 X114.241 Y131.215 E.08077
G1 X141.733 Y131.288 E.84474
G1 X141.734 Y128.462 E.08683
G1 X139.2 Y128.437 E.07787
G1 X139.038 Y128.934 E.01607
G1 X138.765 Y129.416 E.01702
G1 X138.375 Y129.84 E.01768
G1 X137.901 Y130.159 E.01756
G1 X137.386 Y130.361 E.01698
G3 X136.332 Y130.497 I-1.223 J-5.344 E.03271
G1 X119.708 Y130.453 E.5108
G1 X119.039 Y130.82 F30000
; LINE_WIDTH: 0.444214
G1 F5259
G2 X119.647 Y130.841 I.815 J-14.538 E.01989
G1 X136.331 Y130.886 E.54558
G1 X136.868 Y130.87 E.01757
G1 X119.039 Y130.82 F30000
; LINE_WIDTH: 0.466813
G1 F5259
G1 X118.751 Y130.742 E.01032
; LINE_WIDTH: 0.42041
G1 X118.462 Y130.665 E.00919
G1 X117.878 Y130.423 E.01944
G1 X117.337 Y130.046 E.02031
G1 X116.896 Y129.55 E.0204
G1 X116.588 Y128.981 E.01989
G1 X116.513 Y128.751 E.00744
G1 X114.625 Y128.746 E.0581
G1 X114.619 Y130.839 E.06438
G1 X118.604 Y130.85 E.12258
; LINE_WIDTH: 0.435598
G1 X118.792 Y130.837 E.00602
; LINE_WIDTH: 0.466813
G1 X118.98 Y130.824 E.0065
G1 X117.263 Y130.469 F30000
; LINE_WIDTH: 0.41999
G1 F5259
G1 X116.758 Y129.988 E.02144
G1 X116.405 Y129.457 E.01957
G1 X116.243 Y129.128 E.01128
G1 X115.001 Y129.124 E.03817
G1 X114.997 Y130.463 E.04114
G1 X117.203 Y130.469 E.06776
G1 X116.261 Y130.038 F30000
; LINE_WIDTH: 0.523795
G1 F5259
G1 X115.976 Y129.575 E.0213
G1 X115.429 Y129.555 E.02148
G1 X115.427 Y130.035 E.01884
G1 X116.201 Y130.037 E.03033
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F13724.977
G1 X115.427 Y130.035 E-.29416
G1 X115.429 Y129.555 E-.18274
G1 X115.976 Y129.575 E-.20826
G1 X116.08 Y129.742 E-.07484
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 38/118
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change
G17
G3 Z7.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X116.813 Y130.965
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F5561
G1 X116.81 Y132.045 E.03582
G1 X113.47 Y132.036 E.11079
G1 X113.479 Y128.645 E.11247
G3 X113.642 Y127.923 I1.173 J-.114 E.02499
G3 X113.927 Y127.794 I.336 J.364 E.01053
G1 X115.409 Y127.788 E.04917
G1 X117.457 Y127.793 E.06793
G2 X117.671 Y128.659 I3.286 J-.355 E.02969
G2 X118.848 Y129.638 I1.609 J-.737 E.05252
G2 X119.655 Y129.737 I.775 J-3 E.02705
M73 P62 R6
G1 X136.329 Y129.781 E.55309
G2 X137.507 Y129.55 I.025 J-3 E.04011
G2 X138.44 Y128.367 I-.812 J-1.6 E.0516
G2 X138.538 Y127.849 I-6.408 J-1.475 E.01747
G1 X141.889 Y127.858 E.11115
G3 X142.31 Y127.957 I.02 J.866 E.01453
G3 X142.502 Y128.486 I-.611 J.521 E.01909
G1 X142.502 Y132.113 E.1203
G1 X139.162 Y132.104 E.11079
G1 X139.167 Y130.273 E.06074
G1 X116.815 Y130.214 E.74147
G1 X116.813 Y130.905 E.02293
; WIPE_START
G1 F16213.044
G1 X116.81 Y132.045 E-.43319
G1 X115.95 Y132.042 E-.32681
; WIPE_END
G1 E-.04 F1800
G1 X117.678 Y131.835 Z8 F30000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5561
M204 S5000
G1 X117.677 Y132.427 E.01819
G1 X117.676 Y132.439 E.00038
G1 X113.077 Y132.427 E.14134
G1 X113.077 Y132.414 E.00038
G1 X113.087 Y128.637 E.11609
G3 X113.333 Y127.679 I1.553 J-.112 E.03091
G3 X114.095 Y127.392 I.671 J.626 E.02594
G1 X115.41 Y127.396 E.0404
G1 X117.847 Y127.402 E.07488
G2 X118.029 Y128.495 I2.835 J.088 E.03425
G2 X118.954 Y129.26 I1.258 J-.58 E.03815
G2 X119.667 Y129.345 I.678 J-2.649 E.02211
G1 X136.319 Y129.389 E.51168
G2 X137.333 Y129.197 I.036 J-2.578 E.03191
G2 X138.062 Y128.26 I-.65 J-1.259 E.03766
G2 X138.15 Y127.456 I-3.249 J-.759 E.02489
G1 X141.901 Y127.466 E.11527
G3 X142.662 Y127.757 I.087 J.913 E.02595
G3 X142.903 Y128.716 I-1.311 J.839 E.03091
G1 X142.893 Y132.494 E.11609
G1 X142.893 Y132.506 E.00038
G1 X138.293 Y132.494 E.14134
G1 X138.293 Y132.482 E.00038
G1 X138.295 Y131.89 E.01819
G1 X117.738 Y131.835 E.63166
; WIPE_START
G1 F12000
M204 S10000
G1 X117.677 Y132.427 E-.22611
G1 X117.676 Y132.439 E-.00466
G1 X116.284 Y132.435 E-.52923
; WIPE_END
G1 E-.04 F1800
G1 X118.751 Y130.015 Z8 F30000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.148809
G1 F5561
G1 X118.359 Y129.727 E.0042
; LINE_WIDTH: 0.121895
G1 X118.173 Y129.575 E.00154
G1 X118.414 Y129.859 F30000
; LINE_WIDTH: 0.268313
G1 F5561
G1 X118.587 Y129.891 E.00324
; LINE_WIDTH: 0.242003
G1 X118.76 Y129.922 E.00286
; LINE_WIDTH: 0.205904
G2 X118.994 Y129.945 I.384 J-2.706 E.00311
; LINE_WIDTH: 0.164057
G1 X119.211 Y129.966 E.00216
; LINE_WIDTH: 0.120763
G1 X136.765 Y130.013 E.11135
; LINE_WIDTH: 0.16345
G1 X136.989 Y129.993 E.00221
; LINE_WIDTH: 0.204385
G1 X137.207 Y129.973 E.00288
; LINE_WIDTH: 0.240727
G2 X137.396 Y129.941 I-.291 J-2.237 E.0031
; LINE_WIDTH: 0.268311
G1 X137.57 Y129.91 E.00324
G1 X137.626 Y129.778 F30000
; LINE_WIDTH: 0.148798
G1 F5561
G1 X137.231 Y130.064 E.00421
G1 X137.626 Y129.778 F30000
; LINE_WIDTH: 0.121902
G1 F5561
G1 X137.812 Y129.627 E.00154
G1 X140.447 Y129.382 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.395249
G1 F5561
G1 X140.616 Y129.634 E.00869
G3 X140.667 Y130.607 I-7.184 J.871 E.02799
G1 X141.001 Y130.608 E.00958
G2 X140.98 Y129.385 I-19.449 J-.279 E.0351
G1 X140.507 Y129.383 E.01357
G1 X139.433 Y129.001 F30000
; LINE_WIDTH: 0.41999
G1 F5561
G1 X139.405 Y129.128 E.00401
G1 X139.999 Y129.367 E.01967
G1 X140.261 Y129.758 E.01448
G1 X140.314 Y130.072 E.00979
G1 X140.311 Y130.961 E.0273
G1 X141.356 Y130.964 E.0321
G1 X141.356 Y129.011 E.05999
G1 X139.493 Y129.001 E.05725
G1 X138.739 Y129.503 F30000
G1 F5561
G1 X139.373 Y129.504 E.01946
G1 X139.748 Y129.648 E.01234
G1 X139.905 Y129.883 E.00869
G3 X139.933 Y131.337 I-12.478 J.972 E.04471
G1 X141.733 Y131.342 E.0553
G1 X141.733 Y128.636 E.08312
G1 X139.166 Y128.622 E.07889
G1 X138.99 Y129.089 E.01534
G1 X138.77 Y129.451 E.01302
G1 X138.222 Y129.51 F30000
G1 F5561
G1 X138.317 Y129.65 E.0052
G1 X138.272 Y129.879 E.00717
G1 X139.372 Y129.881 E.03379
G1 X139.497 Y129.929 E.00411
G1 X139.56 Y130.07 E.00475
G1 X139.555 Y131.713 E.05047
G1 X142.11 Y131.72 E.0785
G1 X142.11 Y128.55 E.09739
G1 X142.056 Y128.28 E.00846
G1 X141.822 Y128.26 E.00722
G1 X138.863 Y128.243 E.09092
G1 X138.705 Y128.796 E.01766
G1 X138.44 Y129.277 E.01688
G1 X138.263 Y129.466 E.00797
; WIPE_START
G1 F15000
G1 X138.44 Y129.277 E-.09853
G1 X138.705 Y128.796 E-.20882
G1 X138.863 Y128.243 E-.21835
G1 X139.479 Y128.247 E-.2343
; WIPE_END
G1 E-.04 F1800
G1 X138.511 Y132.287 Z8 F30000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F5561
M204 S2000
G1 X138.94 Y131.857 E.01867
G1 X138.893 Y131.371
G1 X138.503 Y131.762 E.01698
G1 X138.05 Y131.682
G1 X138.895 Y130.836 E.03673
G1 X138.704 Y130.494
G1 X137.518 Y131.68 E.05153
G1 X136.986 Y131.679
G1 X138.172 Y130.493 E.05153
G1 X137.64 Y130.491
G1 X136.454 Y131.677 E.05153
G1 X135.922 Y131.676
G1 X137.108 Y130.49 E.05153
G1 X136.576 Y130.489
G1 X135.39 Y131.674 E.05153
G1 X134.858 Y131.673
G1 X136.044 Y130.487 E.05153
G1 X135.513 Y130.486
G1 X134.327 Y131.672 E.05153
G1 X133.795 Y131.67
G1 X134.981 Y130.484 E.05153
G1 X134.449 Y130.483
G1 X133.263 Y131.669 E.05153
G1 X132.731 Y131.667
G1 X133.917 Y130.482 E.05153
G1 X133.385 Y130.48
G1 X132.199 Y131.666 E.05153
G1 X131.667 Y131.665
G1 X132.853 Y130.479 E.05153
G1 X132.321 Y130.477
G1 X131.136 Y131.663 E.05153
G1 X130.604 Y131.662
G1 X131.79 Y130.476 E.05153
G1 X131.258 Y130.474
G1 X130.072 Y131.66 E.05153
G1 X129.54 Y131.659
G1 X130.726 Y130.473 E.05153
G1 X130.194 Y130.472
G1 X129.008 Y131.657 E.05153
G1 X128.476 Y131.656
G1 X129.662 Y130.47 E.05153
G1 X129.13 Y130.469
G1 X127.944 Y131.655 E.05153
G1 X127.413 Y131.653
G1 X128.599 Y130.467 E.05153
G1 X128.067 Y130.466
G1 X126.881 Y131.652 E.05153
G1 X126.349 Y131.65
G1 X127.535 Y130.465 E.05153
G1 X127.003 Y130.463
G1 X125.817 Y131.649 E.05153
G1 X125.285 Y131.648
G1 X126.471 Y130.462 E.05153
G1 X125.939 Y130.46
G1 X124.753 Y131.646 E.05153
G1 X124.222 Y131.645
G1 X125.407 Y130.459 E.05153
G1 X124.876 Y130.457
G1 X123.69 Y131.643 E.05153
G1 X123.158 Y131.642
G1 X124.344 Y130.456 E.05153
G1 X123.812 Y130.455
G1 X122.626 Y131.641 E.05153
G1 X122.094 Y131.639
G1 X123.28 Y130.453 E.05153
G1 X122.748 Y130.452
G1 X121.562 Y131.638 E.05153
G1 X121.031 Y131.636
G1 X122.216 Y130.45 E.05153
G1 X121.685 Y130.449
G1 X120.499 Y131.635 E.05153
G1 X119.967 Y131.633
G1 X121.153 Y130.448 E.05153
G1 X120.621 Y130.446
G1 X119.435 Y131.632 E.05153
G1 X118.903 Y131.631
G1 X120.089 Y130.445 E.05153
G1 X119.557 Y130.443
G1 X118.371 Y131.629 E.05153
G1 X117.839 Y131.628
G1 X119.025 Y130.442 E.05153
G1 X118.494 Y130.44
G1 X117.033 Y131.901 E.06348
G1 X117.082 Y131.318
G1 X117.962 Y130.439 E.03821
G1 X117.43 Y130.438
G1 X117.084 Y130.784 E.01504
M204 S10000
G1 X117.489 Y132.098 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.279775
G1 F5561
G1 X117.124 Y132.138 E.00708
; LINE_WIDTH: 0.243567
G1 X117.014 Y131.934 E.00379
; WIPE_START
G1 F15000
G1 X117.124 Y132.138 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X121.394 Y130.473 Z8 F30000
G1 Z7.6
G1 E.8 F1800
; LINE_WIDTH: 0.13008
G1 F5561
G1 X121.178 Y130.473 E.00153
G1 X135.236 Y130.495 F30000
; LINE_WIDTH: 0.102297
G1 F5561
G1 X134.992 Y130.495 E.00118
; WIPE_START
G1 F15000
G1 X135.236 Y130.495 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.617 Y130.037 Z8 F30000
G1 X115.545 Y129.312 Z8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.395914
G1 F5561
G1 X115.001 Y129.314 E.01566
G2 X114.976 Y130.537 I19.549 J1.01 E.03522
G1 X115.311 Y130.538 E.00964
G3 X115.368 Y129.566 I3.994 J-.255 E.0281
G1 X115.451 Y129.38 E.00586
G1 X115.497 Y129.347 E.00161
G1 X116.439 Y129.009 F30000
; LINE_WIDTH: 0.540782
G1 F5561
G1 X116.096 Y128.984 E.01393
; LINE_WIDTH: 0.492465
G1 X115.754 Y128.959 E.01258
; LINE_WIDTH: 0.421503
G2 X114.624 Y128.937 I-.704 J7.262 E.0349
G1 X114.619 Y130.893 E.06032
G1 X115.667 Y130.895 E.03232
G1 X115.669 Y130.007 E.02741
G1 X115.783 Y129.56 E.01424
; LINE_WIDTH: 0.444149
G1 X115.986 Y129.389 E.00868
; LINE_WIDTH: 0.492465
G1 X116.19 Y129.218 E.00972
; LINE_WIDTH: 0.540782
G1 X116.393 Y129.048 E.01077
G1 X117.246 Y129.446 F30000
; LINE_WIDTH: 0.41999
G1 F5561
G1 X116.957 Y128.946 E.01774
G1 X116.824 Y128.561 E.01253
G2 X114.258 Y128.562 I-1.186 J180.45 E.07885
G2 X114.241 Y131.269 I133.262 J2.176 E.08317
G1 X116.043 Y131.273 E.05536
G1 X116.046 Y130.008 E.03888
G1 X116.114 Y129.74 E.00851
G1 X116.553 Y129.447 E.01619
G1 X117.186 Y129.445 E.01947
G1 X117.764 Y129.455 F30000
G1 F5561
G1 X117.547 Y129.222 E.00981
G1 X117.283 Y128.737 E.01694
G1 X117.13 Y128.184 E.01763
G2 X113.981 Y128.186 I-1.448 J221.457 E.09675
G1 X113.897 Y128.358 E.00587
G2 X113.863 Y131.645 I75.36 J2.414 E.10102
G1 X116.419 Y131.652 E.07853
G1 X116.423 Y130.009 E.05047
G1 X116.446 Y129.92 E.00284
G1 X116.612 Y129.821 E.00594
G1 X117.761 Y129.824 E.03529
G1 X117.668 Y129.595 E.0076
G1 X117.73 Y129.505 E.00336
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X117.668 Y129.595 E-.04153
G1 X117.761 Y129.824 E-.09398
G1 X116.612 Y129.821 E-.43648
G1 X116.446 Y129.92 E-.07344
G1 X116.423 Y130.009 E-.03507
G1 X116.423 Y130.218 E-.07949
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 39/118
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change
G17
G3 Z8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X116.815 Y130.214
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F5010
G1 X116.81 Y132.098 E.06251
G1 X113.47 Y132.089 E.11079
G1 X113.479 Y128.753 E.11065
G3 X113.623 Y128.08 I1.148 J-.106 E.02318
G3 X114.105 Y127.945 I.401 J.501 E.01708
G1 X117.475 Y127.954 E.11178
G2 X117.872 Y129.056 I2.134 J-.148 E.03935
G1 X118.319 Y129.521 E.02139
G1 X116.817 Y129.517 E.04985
G1 X116.815 Y130.154 E.02113
; WIPE_START
G1 F16213.044
G1 X116.81 Y132.098 E-.73885
G1 X116.754 Y132.098 E-.02115
; WIPE_END
G1 E-.04 F1800
G1 X124.331 Y131.183 Z8.2 F30000
G1 X137.666 Y129.572 Z8.2
G1 Z7.8
G1 E.8 F1800
G1 F5010
G1 X138.115 Y129.11 E.02139
G2 X138.519 Y128.01 I-1.73 J-1.258 E.03935
G1 X141.888 Y128.019 E.11177
G3 X142.37 Y128.157 I.079 J.637 E.01709
G3 X142.502 Y128.603 I-.949 J.523 E.01555
G1 X142.502 Y132.166 E.1182
G1 X139.162 Y132.157 E.1108
G1 X139.169 Y129.576 E.08563
G1 X137.726 Y129.572 E.04786
; WIPE_START
G1 F16213.044
G1 X138.115 Y129.11 E-.22976
G1 X138.319 Y128.767 E-.15129
G1 X138.44 Y128.42 E-.13971
G1 X138.519 Y128.01 E-.15868
G1 X138.731 Y128.011 E-.08057
; WIPE_END
G1 E-.04 F1800
G1 X131.178 Y129.113 Z8.2 F30000
G1 X117.68 Y131.084 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5010
M204 S5000
G1 X117.676 Y132.48 E.04291
G1 X117.676 Y132.492 E.00038
G1 X113.077 Y132.48 E.14134
G1 X113.077 Y132.468 E.00038
G1 X113.086 Y128.744 E.11441
G3 X113.326 Y127.821 I1.45 J-.117 E.02985
G3 X114.095 Y127.553 I.689 J.741 E.02576
G1 X117.486 Y127.562 E.10421
G1 X117.849 Y127.564 E.01116
G2 X118.187 Y128.817 I2.148 J.093 E.04053
G2 X118.954 Y129.313 I1.186 J-.995 E.02848
G2 X119.667 Y129.398 I.678 J-2.65 E.02211
G1 X136.319 Y129.442 E.51168
G2 X137.333 Y129.25 I.036 J-2.578 E.03191
G2 X138.062 Y128.313 I-.65 J-1.259 E.03765
G2 X138.148 Y127.617 I-3.156 J-.742 E.02159
G1 X141.901 Y127.627 E.11531
G3 X142.669 Y127.899 I.075 J1.009 E.02576
G3 X142.903 Y128.823 I-1.215 J.8 E.02985
G1 X142.893 Y132.547 E.11442
G1 X142.893 Y132.559 E.00038
G1 X138.293 Y132.547 E.14134
G1 X138.293 Y132.535 E.00038
G1 X138.297 Y131.138 E.04291
G1 X117.74 Y131.084 E.63166
; WIPE_START
G1 F12000
M204 S10000
G1 X117.676 Y132.48 E-.53111
G1 X117.676 Y132.492 E-.00466
G1 X117.086 Y132.491 E-.22423
; WIPE_END
G1 E-.04 F1800
G1 X117.229 Y132.069 Z8.2 F30000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42646
G1 F5010
G1 X117.157 Y132.111 E.0026
G1 X117.218 Y132.146 E.00222
G1 X117.108 Y129.751 F30000
; LINE_WIDTH: 0.38292
G1 F5010
G1 X117.044 Y129.788 E.00204
G1 X117.093 Y129.816 E.00155
G1 X117.459 Y129.126 F30000
; LINE_WIDTH: 0.41999
G1 F5010
G1 X117.304 Y128.849 E.00978
G1 X117.163 Y128.345 E.01605
G1 X114.13 Y128.337 E.09317
G1 X113.92 Y128.369 E.00655
G1 X113.87 Y128.801 E.01337
G1 X113.863 Y131.698 E.08901
G1 X116.419 Y131.705 E.07853
G1 X116.425 Y129.312 E.07352
G1 X116.614 Y129.124 E.00819
G1 X117.399 Y129.126 E.02413
G1 X116.514 Y128.738 F30000
; LINE_WIDTH: 0.423208
G1 F5010
G2 X114.258 Y128.715 I-1.839 J68.759 E.06994
G2 X114.241 Y131.322 I120.648 J2.075 E.08079
G1 X116.043 Y131.327 E.05583
G1 X116.048 Y129.311 E.06246
G1 X116.477 Y128.785 E.02103
G1 X116.514 Y128.738 F30000
; LINE_WIDTH: 0.45031
G1 F5010
G1 X116.807 Y128.735 E.0097
G1 X115.852 Y129.096 F30000
; LINE_WIDTH: 0.41999
G1 F5010
G1 X114.624 Y129.093 E.03772
G1 X114.619 Y130.946 E.05694
G1 X115.666 Y130.949 E.03219
G1 X115.671 Y129.31 E.05035
G1 X115.813 Y129.142 E.00676
G1 X115.314 Y129.451 F30000
; LINE_WIDTH: 0.378185
G1 F5010
G1 X114.979 Y129.45 E.00916
G1 X114.976 Y130.591 E.03116
G1 X115.311 Y130.592 E.00916
G1 X115.314 Y129.511 E.02952
; WIPE_START
G1 F15000
G1 X115.311 Y130.592 E-.41067
G1 X114.976 Y130.591 E-.1274
G1 X114.978 Y130.007 E-.22194
; WIPE_END
G1 E-.04 F1800
G1 X118.429 Y129.317 Z8.2 F30000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.123643
G1 F5010
G2 X118.961 Y129.718 I4.014 J-4.771 E.00439
G1 X119.068 Y129.627 F30000
; LINE_WIDTH: 0.245188
G1 F5010
G3 X118.862 Y129.607 I.137 J-2.429 E.00342
; LINE_WIDTH: 0.271441
G1 X118.634 Y129.565 E.00432
G1 X119.068 Y129.627 F30000
; LINE_WIDTH: 0.208641
G1 F5010
G1 X119.255 Y129.645 E.00254
; LINE_WIDTH: 0.169647
G2 X119.658 Y129.657 I.387 J-6.189 E.00416
G1 X136.72 Y129.692 E.17619
; LINE_WIDTH: 0.207772
G1 X136.917 Y129.675 E.00266
; LINE_WIDTH: 0.243372
G1 X137.104 Y129.658 E.00307
; LINE_WIDTH: 0.270846
G2 X137.351 Y129.615 I-.382 J-2.926 E.00466
G1 X137.558 Y129.368 F30000
; LINE_WIDTH: 0.123663
G1 F5010
G3 X137.023 Y129.766 I-3.975 J-4.776 E.00439
G1 X138.511 Y129.845 F30000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F5010
M204 S2000
G1 X138.945 Y130.279 E.01885
G1 X138.895 Y130.763
G1 X137.928 Y129.795 E.04204
G1 X137.393 Y129.794
G1 X138.894 Y131.294 E.06521
G1 X138.503 Y131.438
G1 X138.892 Y131.826 E.01689
; WIPE_START
G1 F12000
M204 S10000
G1 X138.503 Y131.438 E-.20891
G1 X138.894 Y131.294 E-.15792
G1 X138.162 Y130.563 E-.39317
; WIPE_END
G1 E-.04 F1800
G1 X137.996 Y130.93 Z8.2 F30000
G1 Z7.8
G1 E.8 F1800
G1 F5010
M204 S2000
M73 P63 R6
G1 X136.858 Y129.792 E.04945
G1 X136.324 Y129.791
G1 X137.462 Y130.929 E.04945
G1 X136.927 Y130.927
G1 X135.789 Y129.79 E.04945
G1 X135.254 Y129.788
G1 X136.392 Y130.926 E.04945
G1 X135.857 Y130.925
G1 X134.72 Y129.787 E.04945
G1 X134.185 Y129.785
G1 X135.323 Y130.923 E.04945
G1 X134.788 Y130.922
G1 X133.65 Y129.784 E.04945
G1 X133.116 Y129.782
G1 X134.253 Y130.92 E.04945
G1 X133.719 Y130.919
G1 X132.581 Y129.781 E.04945
G1 X132.046 Y129.78
G1 X133.184 Y130.917 E.04944
G1 X132.649 Y130.916
G1 X131.512 Y129.778 E.04944
G1 X130.977 Y129.777
G1 X132.115 Y130.915 E.04945
G1 X131.58 Y130.913
G1 X130.442 Y129.775 E.04944
G1 X129.908 Y129.774
G1 X131.045 Y130.912 E.04945
G1 X130.511 Y130.91
G1 X129.373 Y129.772 E.04945
G1 X128.838 Y129.771
G1 X129.976 Y130.909 E.04945
G1 X129.441 Y130.908
G1 X128.303 Y129.77 E.04945
G1 X127.769 Y129.768
G1 X128.907 Y130.906 E.04945
G1 X128.372 Y130.905
G1 X127.234 Y129.767 E.04945
G1 X126.699 Y129.765
G1 X127.837 Y130.903 E.04945
G1 X127.303 Y130.902
G1 X126.165 Y129.764 E.04945
G1 X125.63 Y129.763
G1 X126.768 Y130.9 E.04945
G1 X126.233 Y130.899
G1 X125.095 Y129.761 E.04945
G1 X124.561 Y129.76
G1 X125.699 Y130.898 E.04945
G1 X125.164 Y130.896
G1 X124.026 Y129.758 E.04945
G1 X123.491 Y129.757
G1 X124.629 Y130.895 E.04945
G1 X124.095 Y130.893
G1 X122.957 Y129.755 E.04945
G1 X122.422 Y129.754
G1 X123.56 Y130.892 E.04945
G1 X123.025 Y130.89
G1 X121.887 Y129.753 E.04945
G1 X121.353 Y129.751
G1 X122.49 Y130.889 E.04945
G1 X121.956 Y130.888
G1 X120.818 Y129.75 E.04944
G1 X120.283 Y129.748
G1 X121.421 Y130.886 E.04945
G1 X120.886 Y130.885
G1 X119.749 Y129.747 E.04944
G1 X119.214 Y129.745
G1 X120.352 Y130.883 E.04945
G1 X119.817 Y130.882
G1 X118.679 Y129.744 E.04945
G1 X118.145 Y129.743
G1 X119.282 Y130.88 E.04945
G1 X118.748 Y130.879
G1 X117.658 Y129.789 E.04735
G1 X117.16 Y129.825
G1 X118.213 Y130.878 E.04575
G1 X117.678 Y130.876
G1 X117.037 Y130.235 E.02787
G1 X117.084 Y130.815
G1 X117.472 Y131.203 E.01689
G1 X117.471 Y131.735
G1 X117.082 Y131.347 E.01689
M204 S10000
G1 X117.393 Y131.973 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.204341
G1 F5010
G3 X117.115 Y131.772 I1.616 J-2.526 E.00451
G1 X117.091 Y131.622 E.002
G1 X117.49 Y131.858 F30000
; LINE_WIDTH: 0.178264
G1 F5010
G1 X117.378 Y131.914 E.00137
; LINE_WIDTH: 0.151207
G1 X117.106 Y131.871 E.00243
; WIPE_START
G1 F15000
G1 X117.378 Y131.914 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.974 Y131.172 Z8.2 F30000
G1 X138.919 Y129.809 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.38292
G1 F5010
G1 X138.855 Y129.846 E.00204
G1 X138.903 Y129.874 E.00155
; WIPE_START
G1 F15000
G1 X138.855 Y129.846 E-.32873
G1 X138.919 Y129.809 E-.43127
; WIPE_END
G1 E-.04 F1800
G1 X140.671 Y129.518 Z8.2 F30000
G1 Z7.8
G1 E.8 F1800
; LINE_WIDTH: 0.378141
G1 F5010
G1 X140.668 Y130.659 E.03116
G1 X141.004 Y130.66 E.00916
G1 X141.007 Y129.519 E.03116
G1 X140.731 Y129.518 E.00752
G1 X140.102 Y129.161 F30000
; LINE_WIDTH: 0.41999
G1 F5010
G1 X140.316 Y129.376 E.00932
G1 X140.311 Y131.014 E.05035
G1 X141.359 Y131.017 E.03219
G1 X141.364 Y129.164 E.05694
G1 X140.162 Y129.161 E.03693
G1 X139.375 Y128.795 F30000
; LINE_WIDTH: 0.422578
G1 F5010
G1 X139.939 Y129.375 E.02503
G1 X139.933 Y131.39 E.06236
G1 X141.735 Y131.395 E.05574
G1 X141.736 Y128.788 E.08066
G2 X139.435 Y128.794 I-.876 J102.846 E.0712
G1 X139.123 Y128.794 F30000
; LINE_WIDTH: 0.44588
G1 F5010
G1 X139.315 Y128.794 E.0063
G1 X138.528 Y129.182 F30000
; LINE_WIDTH: 0.41999
G1 F5010
G1 X139.374 Y129.185 E.02598
G1 X139.562 Y129.374 E.00819
G1 X139.555 Y131.766 E.07352
G1 X142.111 Y131.773 E.07853
G1 X142.119 Y128.864 E.08938
G1 X142.07 Y128.453 E.01273
G1 X141.667 Y128.411 E.01243
G1 X138.829 Y128.403 E.08721
G1 X138.685 Y128.906 E.01606
G1 X138.558 Y129.13 E.00793
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X138.685 Y128.906 E-.09812
G1 X138.829 Y128.403 E-.19861
G1 X140.048 Y128.406 E-.46327
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 40/118
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change
G17
G3 Z8.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.291 Y129.994
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3358
G1 X117.285 Y132.152 E.07161
G1 X113.47 Y132.142 E.12657
G1 X113.478 Y128.838 E.1096
G3 X113.622 Y128.197 I1.055 J-.1 E.02218
G3 X113.918 Y128.08 I.346 J.445 E.01069
G1 X115.445 Y128.075 E.05064
G1 X117.487 Y128.08 E.06774
G2 X117.872 Y129.109 I2.408 J-.315 E.03676
G2 X118.848 Y129.745 I1.522 J-1.269 E.03921
G1 X119.014 Y129.776 E.00561
G1 X118.993 Y129.998 E.00739
G1 X117.351 Y129.994 E.05447
; WIPE_START
G1 F16213.044
G1 X117.29 Y131.993 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.877 Y131.157 Z8.4 F30000
G1 X136.97 Y129.824 Z8.4
G1 Z8
G1 E.8 F1800
G1 F3358
G2 X137.84 Y129.446 I-.412 J-2.139 E.03172
G2 X138.472 Y128.329 I-1.276 J-1.459 E.04341
G1 X138.506 Y128.136 E.00649
G1 X141.89 Y128.145 E.11225
G3 X142.37 Y128.273 I.088 J.634 E.01693
G3 X142.511 Y128.916 I-.914 J.537 E.02219
G1 X142.502 Y132.219 E.10959
G1 X138.686 Y132.209 E.12657
G1 X138.692 Y130.05 E.07161
G1 X136.99 Y130.046 E.05646
G1 X136.975 Y129.884 E.0054
; WIPE_START
G1 F16213.044
G1 X137.136 Y129.794 E-.07017
G1 X137.507 Y129.657 E-.15019
G1 X137.84 Y129.446 E-.14966
G1 X138.115 Y129.163 E-.15017
G1 X138.318 Y128.82 E-.15134
G1 X138.395 Y128.601 E-.08848
; WIPE_END
G1 E-.04 F1800
G1 X130.791 Y129.256 Z8.4 F30000
G1 X117.682 Y130.387 Z8.4
G1 Z8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3358
M204 S5000
G1 X117.676 Y132.533 E.06596
G1 X117.676 Y132.545 E.00038
G1 X113.076 Y132.533 E.14134
G1 X113.076 Y132.521 E.00038
G1 X113.086 Y128.829 E.11344
G3 X113.325 Y127.937 I1.411 J-.1 E.0289
G3 X114.094 Y127.679 I.669 J.719 E.02569
G1 X115.446 Y127.683 E.04154
G1 X117.852 Y127.689 E.07394
G2 X118.187 Y128.871 I2.086 J.048 E.03831
G2 X118.954 Y129.366 I1.186 J-.995 E.02848
G2 X119.667 Y129.451 I.678 J-2.65 E.02211
G1 X136.319 Y129.495 E.51168
G2 X137.332 Y129.303 I.036 J-2.578 E.03191
G2 X138.062 Y128.367 I-.65 J-1.259 E.03764
G2 X138.143 Y127.743 I-2.879 J-.689 E.01936
G1 X141.901 Y127.753 E.11549
G3 X142.668 Y128.015 I.094 J.978 E.02568
G3 X142.903 Y128.908 I-1.176 J.786 E.0289
G1 X142.893 Y132.6 E.11344
G1 X142.893 Y132.613 E.00038
G1 X138.293 Y132.6 E.14134
G1 X138.293 Y132.588 E.00038
G1 X138.299 Y130.442 E.06596
G1 X117.742 Y130.387 E.63166
M204 S10000
G1 X118.173 Y129.681 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107455
G1 F3358
G2 X118.325 Y129.773 I.185 J-.133 E.00096
G1 X119.199 Y129.908 F30000
; LINE_WIDTH: 0.591861
G1 F3358
G1 X119.66 Y129.922 E.02066
G1 X136.785 Y129.955 E.76601
G1 X137.659 Y129.825 F30000
; LINE_WIDTH: 0.107453
G1 F3358
G2 X137.811 Y129.733 I-.031 J-.226 E.00096
G1 X140.599 Y130.307 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.43496
G1 F3358
G1 X140.6 Y130.109 E.0063
G1 X140.103 Y129.663 F30000
; LINE_WIDTH: 0.41999
G1 F3358
G1 X140.216 Y129.851 E.00673
G1 X140.213 Y130.69 E.02578
G1 X140.983 Y130.692 E.02363
G1 X140.985 Y129.666 E.03153
G1 X140.163 Y129.664 E.02527
G1 X139.498 Y129.285 F30000
G1 F3358
G1 X139.839 Y129.85 E.02027
G1 X139.835 Y131.066 E.03737
G1 X141.359 Y131.07 E.0468
G1 X141.363 Y129.29 E.05471
G1 X139.558 Y129.285 E.05546
G1 X138.936 Y129.287 F30000
G1 F3358
G1 X139.159 Y129.347 E.0071
G1 X139.462 Y129.849 E.01801
G1 X139.457 Y131.442 E.04895
G1 X141.735 Y131.448 E.06998
G1 X141.741 Y128.948 E.07681
G1 X141.707 Y128.914 E.00151
G1 X139.094 Y128.907 E.08027
G1 X138.959 Y129.231 E.01081
G1 X138.221 Y129.616 F30000
G1 F3358
G1 X138.273 Y129.657 E.00203
G1 X138.896 Y129.659 E.01915
G1 X138.984 Y129.681 E.00276
G1 X139.084 Y129.848 E.006
G1 X139.079 Y131.818 E.06054
G1 X142.111 Y131.826 E.09315
G1 X142.118 Y128.949 E.0884
G1 X142.072 Y128.573 E.01165
G1 X141.708 Y128.537 E.01125
G1 X138.814 Y128.529 E.08892
G1 X138.666 Y129.003 E.01526
G1 X138.413 Y129.419 E.01495
G1 X138.263 Y129.573 E.00662
; WIPE_START
G1 F15000
G1 X138.413 Y129.419 E-.08183
G1 X138.666 Y129.003 E-.18488
G1 X138.814 Y128.529 E-.18874
G1 X139.615 Y128.531 E-.30456
; WIPE_END
G1 E-.04 F1800
G1 X132.002 Y129.068 Z8.4 F30000
G1 X115.382 Y130.239 Z8.4
G1 Z8
G1 E.8 F1800
; LINE_WIDTH: 0.43498
G1 F3358
G1 X115.383 Y130.043 E.00629
G1 X115.882 Y129.599 F30000
; LINE_WIDTH: 0.41999
G1 F3358
G2 X115 Y129.6 I-.396 J78.422 E.02712
G1 X114.997 Y130.623 E.03145
G1 X115.766 Y130.625 E.02363
G1 X115.768 Y129.786 E.02578
G1 X115.851 Y129.65 E.00488
G1 X116.489 Y129.224 F30000
G1 F3358
G2 X114.623 Y129.224 I-.908 J145.287 E.05731
G1 X114.619 Y130.999 E.05454
G1 X116.142 Y131.003 E.0468
G1 X116.145 Y129.787 E.03737
G1 X116.457 Y129.275 E.01843
G1 X117.051 Y129.229 F30000
G1 F3358
G1 X116.895 Y128.848 E.01265
G2 X114.25 Y128.848 I-1.271 J205.597 E.08127
G1 X114.241 Y131.375 E.07764
G1 X116.518 Y131.381 E.06998
G1 X116.522 Y129.788 E.04895
G1 X116.827 Y129.288 E.01801
G1 X116.993 Y129.244 E.00526
G1 X117.74 Y129.537 F30000
G1 F3358
G1 X117.546 Y129.328 E.00875
G1 X117.304 Y128.904 E.01501
G1 X117.177 Y128.471 E.01385
G2 X113.967 Y128.472 I-1.53 J249.651 E.09863
G1 X113.897 Y128.554 E.0033
G1 X113.87 Y128.874 E.00987
G1 X113.863 Y131.751 E.08841
G1 X116.894 Y131.759 E.09315
G1 X116.899 Y129.789 E.06054
G1 X117.043 Y129.606 E.00714
G1 X117.734 Y129.592 E.02124
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X117.043 Y129.606 E-.26269
G1 X116.899 Y129.789 E-.08829
G1 X116.897 Y130.865 E-.40902
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 41/118
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change
G17
G3 Z8.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.291 Y130.047
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3232
G1 X117.285 Y132.206 E.07161
G1 X113.469 Y132.196 E.12657
G1 X113.478 Y128.923 E.10855
G3 X113.611 Y128.319 I.976 J-.102 E.02088
G3 X113.918 Y128.197 I.37 J.483 E.01111
G1 X117.174 Y128.195 E.10801
G1 X117.499 Y128.196 E.01076
G2 X118.146 Y129.447 I2.004 J-.244 E.04773
G2 X119.014 Y129.83 I1.291 J-1.754 E.03172
G1 X118.993 Y130.051 E.00739
G1 X117.351 Y130.047 E.05447
; WIPE_START
G1 F16213.044
G1 X117.29 Y132.046 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.876 Y131.21 Z8.6 F30000
G1 X136.97 Y129.877 Z8.6
G1 Z8.2
G1 E.8 F1800
G1 F3232
G2 X137.84 Y129.499 I-.413 J-2.14 E.03172
G2 X138.495 Y128.252 I-1.25 J-1.452 E.04785
G1 X141.889 Y128.261 E.11262
G3 X142.381 Y128.395 I.086 J.651 E.01736
G3 X142.502 Y128.784 I-.777 J.455 E.01361
G1 X142.502 Y132.273 E.11573
G1 X138.686 Y132.263 E.12657
G1 X138.692 Y130.104 E.07161
G1 X136.99 Y130.099 E.05646
G1 X136.975 Y129.937 E.00539
; WIPE_START
G1 F16213.044
G1 X137.136 Y129.847 E-.07014
G1 X137.507 Y129.71 E-.15021
G1 X137.84 Y129.499 E-.14967
G1 X138.115 Y129.216 E-.15014
G1 X138.318 Y128.873 E-.1514
G1 X138.395 Y128.654 E-.08843
; WIPE_END
G1 E-.04 F1800
G1 X130.791 Y129.31 Z8.6 F30000
G1 X117.682 Y130.44 Z8.6
G1 Z8.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3232
M204 S5000
G1 X117.676 Y132.586 E.06596
G1 X117.676 Y132.599 E.00038
G1 X113.076 Y132.587 E.14134
G1 X113.076 Y132.574 E.00038
G1 X113.086 Y128.914 E.11247
G3 X113.321 Y128.052 I1.285 J-.113 E.02805
G3 X114.094 Y127.795 I.678 J.75 E.02575
G1 X117.175 Y127.803 E.09468
G1 X117.854 Y127.805 E.02087
G2 X118.187 Y128.924 I2.007 J.012 E.03639
G2 X118.954 Y129.419 I1.186 J-.995 E.02848
G2 X119.666 Y129.504 I.678 J-2.651 E.02211
G1 X136.319 Y129.549 E.51168
G2 X137.332 Y129.357 I.036 J-2.577 E.03191
G2 X138.062 Y128.42 I-.65 J-1.258 E.03763
G2 X138.139 Y127.859 I-2.766 J-.669 E.01744
G1 X141.901 Y127.869 E.11558
G3 X142.672 Y128.13 I.09 J1.007 E.02574
G3 X142.902 Y128.993 I-1.054 J.744 E.02805
G1 X142.893 Y132.654 E.11247
G1 X142.893 Y132.666 E.00038
G1 X138.293 Y132.654 E.14134
G1 X138.293 Y132.641 E.00038
G1 X138.299 Y130.495 E.06596
G1 X138.258 Y130.495 E.00126
G1 X117.742 Y130.44 E.6304
M204 S10000
G1 X118.173 Y129.734 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107447
G1 F3232
G2 X118.325 Y129.827 I.185 J-.133 E.00096
G1 X117.74 Y129.59 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3232
G1 X117.546 Y129.381 E.00876
G1 X117.304 Y128.959 E.01495
G1 X117.191 Y128.588 E.01193
G1 X114.123 Y128.579 E.09428
M73 P64 R6
G1 X113.911 Y128.612 E.00659
G1 X113.87 Y128.968 E.01099
G1 X113.862 Y131.804 E.08717
G1 X116.894 Y131.813 E.09315
G1 X116.899 Y129.842 E.06054
G1 X117.043 Y129.66 E.00714
G1 X117.734 Y129.645 E.02124
G1 X117.051 Y129.282 F30000
G1 F3232
G1 X116.912 Y128.964 E.01066
G1 X114.248 Y128.957 E.08183
G1 X114.241 Y131.428 E.07594
G1 X116.518 Y131.434 E.06998
G1 X116.522 Y129.841 E.04895
G1 X116.851 Y129.329 E.01869
G1 X116.992 Y129.296 E.00447
G1 X116.466 Y129.34 F30000
G1 F3232
G1 X114.623 Y129.335 E.05663
G1 X114.619 Y131.052 E.05277
G1 X116.142 Y131.056 E.0468
G1 X116.145 Y129.84 E.03737
G1 X116.434 Y129.39 E.01643
G1 X115.848 Y129.715 F30000
G1 F3232
G1 X114.999 Y129.713 E.02607
G1 X114.997 Y130.676 E.0296
G1 X115.766 Y130.678 E.02363
G1 X115.768 Y129.839 E.02578
G1 X115.815 Y129.766 E.00269
G1 X115.382 Y130.293 F30000
; LINE_WIDTH: 0.43498
G1 F3232
G1 X115.383 Y130.158 E.00429
; WIPE_START
G1 F15000
G1 X115.382 Y130.293 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X119.198 Y129.962 Z8.6 F30000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591851
G1 F3232
G1 X136.323 Y130.019 E.766
G1 X136.785 Y130.008 E.02065
G1 X137.659 Y129.878 F30000
; LINE_WIDTH: 0.107442
G1 F3232
G2 X137.811 Y129.787 I-.031 J-.225 E.00096
G1 X138.221 Y129.67 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3232
G1 X138.273 Y129.711 E.00203
G1 X138.896 Y129.712 E.01916
G1 X138.976 Y129.73 E.0025
G1 X139.084 Y129.901 E.00623
G1 X139.079 Y131.872 E.06054
G1 X142.111 Y131.88 E.09315
G1 X142.118 Y129.033 E.08747
G1 X142.068 Y128.691 E.01061
G1 X141.74 Y128.653 E.01015
G1 X138.8 Y128.645 E.09035
G1 X138.666 Y129.056 E.01329
G1 X138.413 Y129.472 E.01495
G1 X138.263 Y129.627 E.00662
G1 X138.936 Y129.34 F30000
G1 F3232
G1 X139.136 Y129.389 E.00631
G1 X139.461 Y129.902 E.01869
G1 X139.457 Y131.495 E.04895
G1 X141.735 Y131.502 E.06998
G2 X141.739 Y129.032 I-728.256 J-2.606 E.07589
G2 X139.077 Y129.023 I-3.979 J783.16 E.08181
G1 X138.96 Y129.285 E.00882
G1 X139.52 Y129.401 F30000
G1 F3232
G1 X139.838 Y129.903 E.01827
G1 X139.835 Y131.119 E.03737
G1 X141.358 Y131.123 E.0468
G1 X141.363 Y129.406 E.05277
G1 X139.58 Y129.401 E.05479
G1 X140.137 Y129.78 F30000
G1 F3232
G1 X140.216 Y129.904 E.00453
G1 X140.213 Y130.743 E.02578
G1 X140.982 Y130.745 E.02363
G1 X140.985 Y129.782 E.0296
G1 X140.197 Y129.78 E.02423
G1 X140.599 Y130.36 F30000
; LINE_WIDTH: 0.43495
G1 F3232
G1 X140.599 Y130.226 E.00429
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.599 Y130.36 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 42/118
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change
G17
G3 Z8.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.291 Y130.1
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3244
G1 X117.285 Y132.259 E.07161
G1 X113.469 Y132.249 E.12657
G1 X113.478 Y129.007 E.10752
G3 X113.61 Y128.405 I.977 J-.102 E.02081
G3 X113.913 Y128.295 I.355 J.504 E.01085
G3 X114.916 Y128.288 I.569 J10.04 E.03328
G1 X117.502 Y128.295 E.08578
G2 X117.872 Y129.215 I2.404 J-.431 E.03314
G2 X118.848 Y129.851 I1.522 J-1.269 E.03922
G1 X119.014 Y129.883 E.00561
G1 X118.993 Y130.105 E.00739
G1 X117.351 Y130.1 E.05447
; WIPE_START
G1 F16213.044
G1 X117.29 Y132.099 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.876 Y131.263 Z8.8 F30000
G1 X136.97 Y129.931 Z8.8
G1 Z8.4
G1 E.8 F1800
G1 F3244
G2 X137.84 Y129.553 I-.413 J-2.14 E.03172
G2 X138.439 Y128.581 I-1.356 J-1.508 E.0384
G1 X138.49 Y128.351 E.00782
G1 X141.89 Y128.36 E.1128
G3 X142.382 Y128.481 I.09 J.69 E.01719
G3 X142.502 Y128.869 I-.782 J.454 E.01357
G1 X142.502 Y132.326 E.11467
G1 X138.686 Y132.316 E.12657
G1 X138.692 Y130.157 E.07161
G1 X136.99 Y130.152 E.05646
G1 X136.975 Y129.99 E.00539
; WIPE_START
G1 F16213.044
G1 X137.136 Y129.9 E-.07012
G1 X137.507 Y129.763 E-.15023
G1 X137.84 Y129.553 E-.14964
G1 X138.115 Y129.269 E-.15021
G1 X138.318 Y128.927 E-.15143
G1 X138.395 Y128.707 E-.08839
; WIPE_END
G1 E-.04 F1800
G1 X130.791 Y129.363 Z8.8 F30000
G1 X117.682 Y130.493 Z8.8
G1 Z8.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3244
M204 S5000
G1 X117.676 Y132.64 E.06596
G1 X117.676 Y132.652 E.00038
G1 X113.076 Y132.64 E.14134
G1 X113.076 Y132.628 E.00038
G1 X113.086 Y128.998 E.11152
G3 X113.32 Y128.137 I1.285 J-.113 E.02801
G3 X114.093 Y127.894 I.67 J.78 E.02558
G1 X114.917 Y127.896 E.02532
G1 X117.857 Y127.904 E.09033
G2 X118.187 Y128.977 I2.018 J-.032 E.03496
G2 X118.954 Y129.473 I1.186 J-.994 E.02848
G2 X119.666 Y129.558 I.678 J-2.649 E.02211
G1 X136.319 Y129.602 E.51168
G2 X137.332 Y129.41 I.036 J-2.577 E.03191
G2 X138.061 Y128.474 I-.649 J-1.258 E.03762
G2 X138.137 Y127.958 I-2.712 J-.66 E.01605
G1 X141.901 Y127.968 E.11566
G3 X142.672 Y128.215 I.097 J1.023 E.02558
G3 X142.902 Y129.077 I-1.054 J.743 E.02801
G1 X142.893 Y132.707 E.11152
G1 X142.893 Y132.719 E.00038
G1 X138.293 Y132.707 E.14134
G1 X138.293 Y132.695 E.00038
G1 X138.298 Y130.548 E.06596
G1 X138.257 Y130.548 E.00126
G1 X117.742 Y130.493 E.6304
M204 S10000
G1 X118.173 Y129.788 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10746
G1 F3244
G2 X118.325 Y129.88 I.185 J-.133 E.00096
G1 X117.739 Y129.643 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3244
G1 X117.546 Y129.434 E.00875
G1 X117.305 Y129.015 E.01487
G1 X117.2 Y128.686 E.0106
G2 X113.964 Y128.686 I-1.601 J172.911 E.09942
G1 X113.913 Y128.74 E.00228
G1 X113.87 Y129.054 E.00973
G1 X113.862 Y131.858 E.08616
G1 X116.894 Y131.866 E.09315
G1 X116.899 Y129.896 E.06054
G1 X117.043 Y129.713 E.00714
G1 X117.734 Y129.698 E.02124
G1 X117.051 Y129.335 F30000
G1 F3244
G1 X116.924 Y129.062 E.00923
G2 X114.247 Y129.062 I-1.384 J143.253 E.08227
G1 X114.24 Y131.482 E.07436
G1 X116.518 Y131.488 E.06998
G1 X116.522 Y129.895 E.04895
G1 X116.87 Y129.374 E.01924
G1 X116.992 Y129.348 E.00383
G1 X116.449 Y129.438 F30000
G1 F3244
G2 X114.623 Y129.436 I-1.025 J97.533 E.05612
G1 X114.618 Y131.106 E.05129
G1 X116.142 Y131.11 E.0468
G1 X116.145 Y129.894 E.03737
G1 X116.416 Y129.488 E.01498
G1 X115.821 Y129.814 F30000
G1 F3244
G1 X114.999 Y129.812 E.02525
G1 X114.997 Y130.73 E.02821
G1 X115.766 Y130.732 E.02363
G1 X115.768 Y129.893 E.02578
G1 X115.787 Y129.864 E.00107
G1 X115.382 Y130.346 F30000
; LINE_WIDTH: 0.43497
G1 F3244
G1 X115.382 Y130.257 E.00284
; WIPE_START
G1 F15000
G1 X115.382 Y130.346 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X119.198 Y130.015 Z8.8 F30000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3244
G1 X136.323 Y130.072 E.76601
G1 X136.784 Y130.062 E.02066
G1 X137.658 Y129.931 F30000
; LINE_WIDTH: 0.107475
G1 F3244
G2 X137.811 Y129.84 I-.031 J-.226 E.00096
G1 X138.221 Y129.723 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3244
G1 X138.273 Y129.764 E.00204
G1 X138.896 Y129.765 E.01914
G1 X138.969 Y129.78 E.00229
G1 X139.084 Y129.955 E.00641
G1 X139.079 Y131.925 E.06054
G1 X142.11 Y131.933 E.09315
G1 X142.118 Y129.138 E.08587
G1 X142.067 Y128.787 E.01092
G1 X141.733 Y128.751 E.01032
G1 X138.79 Y128.744 E.09043
G1 X138.593 Y129.232 E.01617
G3 X138.263 Y129.68 I-1.164 J-.513 E.01724
G1 X138.936 Y129.393 F30000
G1 F3244
G1 X139.116 Y129.433 E.00567
G1 X139.461 Y129.956 E.01924
G1 X139.457 Y131.549 E.04895
G1 X141.734 Y131.555 E.06998
G1 X141.732 Y129.128 E.07455
G1 X139.063 Y129.121 E.082
G1 X138.961 Y129.339 E.00738
G1 X139.536 Y129.5 F30000
G1 F3244
G1 X139.838 Y129.957 E.01682
G1 X139.835 Y131.173 E.03737
G1 X141.358 Y131.177 E.0468
G1 X141.363 Y129.505 E.05138
G1 X139.596 Y129.5 E.05428
G1 X140.163 Y129.878 F30000
G1 F3244
G1 X140.215 Y129.958 E.00291
G1 X140.213 Y130.797 E.02578
G1 X140.982 Y130.799 E.02363
G1 X140.985 Y129.881 E.02821
G1 X140.223 Y129.879 E.0234
G1 X140.599 Y130.413 F30000
; LINE_WIDTH: 0.43497
G1 F3244
G1 X140.599 Y130.324 E.00284
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X140.599 Y130.413 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 43/118
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change
G17
G3 Z8.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.29 Y130.153
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3242
G1 X117.285 Y132.312 E.07161
G1 X113.469 Y132.302 E.12657
G1 X113.478 Y129.07 E.1072
G3 X113.609 Y128.49 I.902 J-.1 E.02011
G3 X113.913 Y128.38 I.355 J.503 E.01085
G1 X116.392 Y128.377 E.08224
G1 X117.509 Y128.38 E.03703
G2 X119.014 Y129.936 I1.802 J-.237 E.07693
G1 X118.993 Y130.158 E.00739
G1 X117.35 Y130.153 E.05447
; WIPE_START
G1 F16213.044
G1 X117.29 Y132.153 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.876 Y131.317 Z9 F30000
G1 X136.969 Y129.984 Z9
G1 Z8.6
G1 E.8 F1800
G1 F3242
G2 X137.839 Y129.606 I-.413 J-2.14 E.03172
G2 X138.483 Y128.436 I-1.345 J-1.501 E.04515
G1 X141.89 Y128.445 E.11302
G3 X142.381 Y128.566 I.09 J.69 E.01719
G3 X142.51 Y129.148 I-.773 J.476 E.02012
G1 X142.501 Y132.379 E.1072
G1 X138.686 Y132.369 E.12657
G1 X138.691 Y130.21 E.07161
G1 X136.989 Y130.206 E.05646
G1 X136.975 Y130.044 E.00539
; WIPE_START
G1 F16213.044
G1 X137.136 Y129.953 E-.07014
G1 X137.507 Y129.817 E-.1502
G1 X137.839 Y129.606 E-.14966
G1 X138.115 Y129.322 E-.15021
G1 X138.318 Y128.98 E-.15147
G1 X138.395 Y128.76 E-.08833
; WIPE_END
G1 E-.04 F1800
G1 X130.791 Y129.416 Z9 F30000
G1 X117.682 Y130.546 Z9
G1 Z8.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3242
M204 S5000
G1 X117.676 Y132.693 E.06596
G1 X117.676 Y132.705 E.00038
G1 X113.076 Y132.693 E.14134
G1 X113.076 Y132.681 E.00038
G1 X113.086 Y129.061 E.11124
G3 X113.32 Y128.222 I1.258 J-.101 E.02733
G3 X114.093 Y127.979 I.67 J.779 E.02558
G1 X116.394 Y127.985 E.07069
G1 X117.858 Y127.989 E.04501
G2 X118.187 Y129.03 I2.007 J-.06 E.03399
G2 X118.954 Y129.526 I1.186 J-.995 E.02848
G2 X119.666 Y129.611 I.678 J-2.649 E.02212
G1 X136.319 Y129.655 E.51168
G2 X137.332 Y129.463 I.036 J-2.578 E.03191
G2 X138.061 Y128.527 I-.649 J-1.258 E.03761
G2 X138.135 Y128.043 I-2.707 J-.661 E.01509
G1 X141.901 Y128.053 E.1157
G3 X142.672 Y128.3 I.097 J1.023 E.02558
G3 X142.902 Y129.14 I-1.027 J.733 E.02733
G1 X142.892 Y132.76 E.11124
G1 X142.892 Y132.772 E.00038
G1 X138.293 Y132.76 E.14134
G1 X138.293 Y132.748 E.00038
G1 X138.298 Y130.601 E.06596
G1 X138.257 Y130.601 E.00126
G1 X117.742 Y130.547 E.6304
M204 S10000
G1 X118.173 Y129.841 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10744
G1 F3242
G2 X118.325 Y129.933 I.185 J-.133 E.00096
G1 X117.74 Y129.697 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3242
G1 X117.546 Y129.488 E.00877
G1 X117.305 Y129.069 E.01483
G1 X117.207 Y128.771 E.00962
G1 X113.959 Y128.772 E.09982
G1 X113.896 Y128.806 E.00221
G1 X113.87 Y129.104 E.00917
G1 X113.862 Y131.911 E.08626
G1 X116.894 Y131.919 E.09315
G1 X116.899 Y129.949 E.06054
G1 X117.042 Y129.766 E.00714
G1 X117.734 Y129.752 E.02125
G1 X117.05 Y129.388 F30000
G1 F3242
G1 X116.894 Y129.149 E.00879
G1 X114.247 Y129.149 E.08135
G1 X114.24 Y131.535 E.07332
G1 X116.518 Y131.541 E.06998
G1 X116.522 Y129.948 E.04895
G1 X116.886 Y129.421 E.01967
G1 X116.992 Y129.4 E.00332
G1 X116.436 Y129.526 F30000
G1 F3242
G1 X114.623 Y129.526 E.05571
G1 X114.618 Y131.159 E.05018
G1 X116.142 Y131.163 E.0468
G1 X116.145 Y129.947 E.03737
G1 X116.402 Y129.575 E.01388
G1 X115.797 Y129.903 F30000
G1 F3242
G1 X114.999 Y129.903 E.02454
G1 X114.996 Y130.783 E.02704
G1 X115.766 Y130.785 E.02363
G1 X115.768 Y129.954 E.02554
G1 X115.382 Y130.399 F30000
; LINE_WIDTH: 0.43497
M73 P65 R6
G1 F3242
G1 X115.382 Y130.347 E.00166
; WIPE_START
G1 F15000
G1 X115.382 Y130.399 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X119.198 Y130.068 Z9 F30000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3242
G1 X119.66 Y130.081 E.02066
G1 X136.784 Y130.115 E.76601
G1 X137.658 Y129.985 F30000
; LINE_WIDTH: 0.107474
G1 F3242
G2 X137.811 Y129.893 I-.031 J-.226 E.00096
G1 X138.221 Y129.776 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3242
G1 X138.273 Y129.817 E.00204
G1 X138.964 Y129.832 E.02124
G1 X139.084 Y130.008 E.00655
G1 X139.079 Y131.978 E.06054
G1 X142.11 Y131.986 E.09315
G1 X142.118 Y129.202 E.08556
G1 X142.068 Y128.872 E.01025
G1 X141.754 Y128.836 E.00971
G1 X138.782 Y128.828 E.09134
G3 X138.413 Y129.578 I-2.538 J-.783 E.02579
G1 X138.263 Y129.733 E.00661
G1 X138.936 Y129.446 F30000
G1 F3242
G1 X139.101 Y129.48 E.00518
G1 X139.461 Y130.009 E.01966
G1 X139.457 Y131.602 E.04895
G1 X141.734 Y131.608 E.06998
G1 X141.741 Y129.213 E.07358
G1 X139.053 Y129.206 E.08258
G1 X138.962 Y129.393 E.00637
G1 X139.548 Y129.585 F30000
G1 F3242
G1 X139.838 Y130.01 E.01581
G1 X139.835 Y131.226 E.03737
G1 X141.358 Y131.23 E.0468
G1 X141.363 Y129.589 E.05041
G1 X139.608 Y129.585 E.0539
G1 X140.183 Y129.963 F30000
G1 F3242
G1 X140.215 Y130.011 E.00176
G1 X140.213 Y130.85 E.02578
G1 X140.982 Y130.852 E.02363
G1 X140.985 Y129.966 E.02723
G1 X140.243 Y129.964 E.02279
G1 X140.599 Y130.466 F30000
; LINE_WIDTH: 0.43497
G1 F3242
G1 X140.599 Y130.409 E.00183
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.599 Y130.466 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 44/118
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change
G17
G3 Z9 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.29 Y130.207
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3222
G1 X117.285 Y132.365 E.07161
G1 X113.469 Y132.355 E.12657
G1 X113.478 Y129.133 E.1069
G3 X113.602 Y128.572 I.884 J-.098 E.01938
G3 X113.912 Y128.465 I.364 J.548 E.01101
G1 X117.512 Y128.465 E.11942
G2 X117.872 Y129.322 I2.452 J-.524 E.03101
G2 X118.847 Y129.958 I1.522 J-1.269 E.03922
G1 X119.014 Y129.99 E.00561
G1 X118.992 Y130.211 E.00739
G1 X117.35 Y130.207 E.05447
; WIPE_START
G1 F16213.044
G1 X117.289 Y132.206 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.876 Y131.37 Z9.2 F30000
G1 X136.969 Y130.037 Z9.2
G1 Z8.8
G1 E.8 F1800
G1 F3222
G2 X137.839 Y129.659 I-.412 J-2.139 E.03172
G2 X138.476 Y128.52 I-1.303 J-1.475 E.0441
G1 X141.89 Y128.53 E.11325
G3 X142.388 Y128.649 I.088 J.733 E.01738
G3 X142.501 Y129.004 I-.693 J.416 E.01247
G1 X142.501 Y132.432 E.11373
G1 X138.686 Y132.422 E.12657
G1 X138.691 Y130.264 E.07161
G1 X136.989 Y130.259 E.05646
G1 X136.975 Y130.097 E.00539
; WIPE_START
G1 F16213.044
G1 X137.136 Y130.007 E-.07016
G1 X137.506 Y129.87 E-.15017
G1 X137.839 Y129.659 E-.14968
G1 X138.115 Y129.376 E-.15021
G1 X138.318 Y129.033 E-.15151
G1 X138.395 Y128.814 E-.08827
; WIPE_END
G1 E-.04 F1800
G1 X130.791 Y129.469 Z9.2 F30000
G1 X117.681 Y130.6 Z9.2
G1 Z8.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3222
M204 S5000
G1 X117.676 Y132.746 E.06596
G1 X117.676 Y132.759 E.00038
G1 X113.076 Y132.746 E.14134
G1 X113.076 Y132.734 E.00038
G1 X113.085 Y129.123 E.11096
G3 X113.317 Y128.299 I1.195 J-.108 E.02689
G3 X114.093 Y128.064 I.673 J.822 E.02554
G1 X117.859 Y128.074 E.11574
G2 X118.186 Y129.084 I1.957 J-.076 E.03304
G2 X118.953 Y129.579 I1.186 J-.995 E.02848
G2 X119.666 Y129.664 I.678 J-2.649 E.02211
G1 X136.318 Y129.709 E.51168
G2 X137.332 Y129.516 I.036 J-2.578 E.03191
G2 X138.061 Y128.581 I-.649 J-1.258 E.0376
G2 X138.133 Y128.127 I-2.758 J-.673 E.01413
G1 X141.9 Y128.138 E.11575
G3 X142.674 Y128.377 I.096 J1.058 E.02554
G3 X142.902 Y129.202 I-.967 J.711 E.02689
G1 X142.892 Y132.813 E.11096
G1 X142.892 Y132.826 E.00038
G1 X138.292 Y132.813 E.14134
G1 X138.292 Y132.801 E.00038
G1 X138.298 Y130.655 E.06596
G1 X138.257 Y130.654 E.00126
G1 X117.741 Y130.6 E.6304
M204 S10000
G1 X118.173 Y129.894 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10744
G1 F3222
G2 X118.325 Y129.986 I.185 J-.133 E.00096
G1 X117.74 Y129.75 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3222
G1 X117.545 Y129.541 E.00877
G1 X117.302 Y129.116 E.01505
G1 X117.222 Y128.856 E.00835
G1 X114.12 Y128.848 E.09534
G1 X113.905 Y128.868 E.00663
G1 X113.869 Y129.174 E.00944
G1 X113.862 Y131.964 E.08574
G1 X116.894 Y131.972 E.09315
G1 X116.899 Y130.002 E.06054
G1 X117.041 Y129.82 E.00711
G1 X117.734 Y129.805 E.02128
G1 X117.05 Y129.442 F30000
G1 F3222
G1 X116.944 Y129.232 E.00721
G1 X114.246 Y129.225 E.08289
G1 X114.24 Y131.588 E.07261
G1 X116.518 Y131.594 E.06998
G1 X116.522 Y130.001 E.04895
G1 X116.901 Y129.468 E.02009
G1 X116.991 Y129.452 E.00282
G1 X116.424 Y129.608 F30000
G1 F3222
G1 X114.622 Y129.603 E.05535
G1 X114.618 Y131.212 E.04944
G1 X116.141 Y131.216 E.0468
G1 X116.145 Y130 E.03737
G1 X116.389 Y129.657 E.01294
G1 X115.779 Y129.983 F30000
G1 F3222
G1 X114.999 Y129.981 E.02397
G1 X114.996 Y130.836 E.02626
G1 X115.765 Y130.838 E.02363
G1 X115.768 Y130.04 E.02453
; WIPE_START
G1 F15000
G1 X115.765 Y130.838 E-.30333
G1 X114.996 Y130.836 E-.29227
G1 X114.997 Y130.403 E-.1644
; WIPE_END
G1 E-.04 F1800
G1 X119.198 Y130.121 Z9.2 F30000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3222
G1 X136.322 Y130.179 E.76601
G1 X136.784 Y130.168 E.02066
G1 X137.658 Y130.038 F30000
; LINE_WIDTH: 0.107436
G1 F3222
G2 X137.811 Y129.946 I-.031 J-.225 E.00096
G1 X138.221 Y129.829 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3222
G1 X138.272 Y129.87 E.00202
G1 X138.958 Y129.883 E.02109
G1 X139.084 Y130.061 E.0067
G1 X139.079 Y132.031 E.06054
G1 X142.11 Y132.039 E.09315
G1 X142.118 Y129.259 E.08542
G1 X142.075 Y128.957 E.00938
G1 X141.782 Y128.921 E.00907
G1 X138.775 Y128.913 E.09237
G3 X138.413 Y129.632 I-2.649 J-.887 E.02481
G1 X138.262 Y129.786 E.00663
G1 X138.935 Y129.5 F30000
G1 F3222
G1 X139.084 Y129.527 E.00465
G1 X139.461 Y130.062 E.0201
G1 X139.457 Y131.655 E.04895
G1 X141.734 Y131.661 E.06998
G1 X141.74 Y129.298 E.07261
G1 X139.043 Y129.291 E.0829
G1 X138.963 Y129.446 E.00536
G1 X139.561 Y129.67 F30000
G1 F3222
G1 X139.838 Y130.063 E.01479
G1 X139.835 Y131.279 E.03737
G1 X141.358 Y131.283 E.0468
G1 X141.362 Y129.674 E.04943
G1 X139.621 Y129.67 E.05351
G1 X140.204 Y130.048 F30000
G1 F3222
G1 X140.213 Y130.903 E.02626
G1 X140.982 Y130.905 E.02363
G1 X140.984 Y130.05 E.02626
G1 X140.264 Y130.049 E.02213
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.984 Y130.05 E-.27368
G1 X140.982 Y130.905 E-.32478
G1 X140.557 Y130.904 E-.16155
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 45/118
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change
G17
G3 Z9.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.29 Y130.26
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3223
G1 X117.284 Y132.419 E.07161
G1 X113.469 Y132.409 E.12657
G1 X113.477 Y129.195 E.1066
G3 X113.602 Y128.635 I.883 J-.098 E.01938
G3 X113.911 Y128.528 I.361 J.541 E.01096
G1 X115.311 Y128.522 E.04645
G1 X117.514 Y128.528 E.0731
G2 X117.871 Y129.375 I2.439 J-.529 E.03067
G2 X118.847 Y130.011 I1.522 J-1.269 E.03922
G1 X119.013 Y130.043 E.00561
G1 X118.992 Y130.264 E.00739
G1 X117.35 Y130.26 E.05447
; WIPE_START
G1 F16213.044
G1 X117.289 Y132.259 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.876 Y131.423 Z9.4 F30000
G1 X136.969 Y130.091 Z9.4
G1 Z9
G1 E.8 F1800
G1 F3223
G2 X137.839 Y129.713 I-.413 J-2.14 E.03172
G2 X138.436 Y128.748 I-1.351 J-1.504 E.03814
G1 X138.476 Y128.584 E.00561
G1 X141.89 Y128.593 E.11324
G3 X142.388 Y128.711 I.091 J.726 E.01736
G3 X142.501 Y129.066 I-.693 J.416 E.01247
G1 X142.501 Y132.486 E.11343
G1 X138.685 Y132.476 E.12657
G1 X138.691 Y130.317 E.07161
G1 X136.989 Y130.312 E.05646
G1 X136.975 Y130.15 E.00539
; WIPE_START
G1 F16213.044
G1 X137.135 Y130.06 E-.07014
G1 X137.506 Y129.923 E-.15019
G1 X137.839 Y129.713 E-.14966
G1 X138.115 Y129.429 E-.15022
G1 X138.318 Y129.086 E-.15156
G1 X138.395 Y128.867 E-.08823
; WIPE_END
G1 E-.04 F1800
G1 X130.791 Y129.523 Z9.4 F30000
G1 X117.681 Y130.653 Z9.4
G1 Z9
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3223
M204 S5000
G1 X117.676 Y132.799 E.06596
G1 X117.676 Y132.812 E.00038
G1 X113.076 Y132.8 E.14134
G1 X113.076 Y132.787 E.00038
G1 X113.085 Y129.185 E.11068
G3 X113.317 Y128.361 I1.195 J-.108 E.02689
G3 X114.092 Y128.127 I.67 J.817 E.02553
G1 X115.312 Y128.13 E.03747
G1 X117.86 Y128.137 E.0783
G2 X118.186 Y129.137 I1.948 J-.082 E.03273
G2 X118.953 Y129.632 I1.186 J-.995 E.02848
G2 X119.666 Y129.717 I.678 J-2.65 E.02211
G1 X136.318 Y129.762 E.51168
G2 X137.332 Y129.57 I.036 J-2.577 E.03191
G2 X138.06 Y128.637 I-.647 J-1.256 E.03751
G2 X138.133 Y128.191 I-3.358 J-.776 E.0139
G1 X141.9 Y128.201 E.11578
G3 X142.674 Y128.44 I.099 J1.052 E.02553
G3 X142.902 Y129.264 I-.967 J.711 E.02689
G1 X142.892 Y132.867 E.11068
G1 X142.892 Y132.879 E.00038
G1 X138.292 Y132.867 E.14134
G1 X138.292 Y132.854 E.00038
G1 X138.298 Y130.708 E.06596
G1 X138.257 Y130.708 E.00126
G1 X117.741 Y130.653 E.6304
M204 S10000
G1 X118.172 Y129.947 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10747
G1 F3223
G2 X118.325 Y130.04 I.185 J-.133 E.00096
G1 X117.739 Y129.803 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3223
G1 X117.545 Y129.594 E.00875
G1 X117.302 Y129.169 E.01504
G1 X117.225 Y128.919 E.00804
G2 X113.954 Y128.919 I-1.623 J250.294 E.10051
G1 X113.903 Y128.971 E.00223
G1 X113.869 Y129.235 E.00817
G1 X113.862 Y132.017 E.0855
G1 X116.893 Y132.026 E.09315
G1 X116.899 Y130.055 E.06054
G1 X117.041 Y129.873 E.00711
G1 X117.733 Y129.858 E.02128
G1 X117.05 Y129.495 F30000
G1 F3223
G1 X116.948 Y129.296 E.00688
G2 X114.246 Y129.295 I-1.369 J206.582 E.08301
G1 X114.24 Y131.641 E.07208
G1 X116.517 Y131.647 E.06998
G1 X116.522 Y130.054 E.04895
G1 X116.907 Y129.52 E.02024
G1 X116.991 Y129.505 E.00264
G1 X116.42 Y129.671 F30000
G1 F3223
G2 X114.622 Y129.671 I-.92 J137.35 E.05523
G1 X114.618 Y131.265 E.04899
G1 X116.141 Y131.269 E.0468
G1 X116.145 Y130.053 E.03737
G1 X116.385 Y129.72 E.01262
G1 X115.772 Y130.047 F30000
G1 F3223
G1 X114.998 Y130.047 E.02376
G1 X114.996 Y130.889 E.02589
G1 X115.765 Y130.891 E.02363
G1 X115.767 Y130.105 E.02415
; WIPE_START
G1 F15000
G1 X115.765 Y130.891 E-.29867
G1 X114.996 Y130.889 E-.29227
G1 X114.997 Y130.444 E-.16907
; WIPE_END
G1 E-.04 F1800
G1 X119.198 Y130.175 Z9.4 F30000
G1 Z9
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591851
G1 F3223
G1 X136.322 Y130.232 E.766
G1 X136.784 Y130.221 E.02066
G1 X137.658 Y130.091 F30000
; LINE_WIDTH: 0.107473
G1 F3223
G2 X137.811 Y130 I-.031 J-.226 E.00096
G1 X138.221 Y129.882 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3223
G1 X138.273 Y129.924 E.00204
G1 X138.956 Y129.935 E.02101
G1 X139.084 Y130.114 E.00675
G1 X139.079 Y132.085 E.06054
G1 X142.11 Y132.093 E.09315
G1 X142.117 Y129.321 E.08515
G1 X142.074 Y129.02 E.00937
G1 X141.782 Y128.985 E.00904
G1 X138.764 Y128.977 E.09276
G3 X138.413 Y129.685 I-2.374 J-.735 E.02439
M73 P66 R6
G1 X138.263 Y129.839 E.00662
G1 X138.935 Y129.553 F30000
G1 F3223
G1 X139.079 Y129.579 E.00448
G1 X139.461 Y130.115 E.02024
G1 X139.457 Y131.708 E.04895
G1 X141.734 Y131.715 E.06998
G1 X141.74 Y129.362 E.0723
G1 X139.039 Y129.354 E.08301
G1 X138.963 Y129.5 E.00504
G1 X139.565 Y129.733 F30000
G1 F3223
G1 X139.838 Y130.116 E.01446
G1 X139.835 Y131.332 E.03737
G1 X141.358 Y131.336 E.0468
G1 X141.362 Y129.738 E.04913
G1 X139.625 Y129.733 E.05338
G1 X140.211 Y130.112 F30000
G1 F3223
G1 X140.213 Y130.956 E.02595
G1 X140.982 Y130.958 E.02363
G1 X140.984 Y130.114 E.02595
G1 X140.271 Y130.112 E.02191
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.984 Y130.114 E-.271
G1 X140.982 Y130.958 E-.32097
G1 X140.54 Y130.957 E-.16803
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 46/118
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change
G17
G3 Z9.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.29 Y130.313
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3221
G1 X117.284 Y132.472 E.07161
G1 X113.469 Y132.462 E.12657
G1 X113.477 Y129.251 E.1065
G3 X113.601 Y128.697 I.842 J-.102 E.01922
G3 X113.91 Y128.59 I.36 J.54 E.01096
G1 X116.593 Y128.588 E.089
G1 X117.516 Y128.59 E.03062
G2 X117.871 Y129.428 I2.431 J-.535 E.03036
G2 X118.847 Y130.064 I1.522 J-1.269 E.03922
G1 X119.013 Y130.096 E.00561
G1 X118.992 Y130.318 E.00739
G1 X117.35 Y130.313 E.05447
; WIPE_START
G1 F16213.044
G1 X117.289 Y132.312 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.876 Y131.476 Z9.6 F30000
G1 X136.969 Y130.144 Z9.6
G1 Z9.2
G1 E.8 F1800
G1 F3221
G2 X137.839 Y129.766 I-.413 J-2.14 E.03172
G2 X138.436 Y128.802 I-1.352 J-1.504 E.03813
G1 X138.474 Y128.646 E.00531
G1 X141.89 Y128.655 E.11332
G3 X142.388 Y128.773 I.091 J.726 E.01736
G3 X142.501 Y129.125 I-.695 J.417 E.01236
G1 X142.501 Y132.539 E.11324
G1 X138.685 Y132.529 E.12657
G1 X138.691 Y130.37 E.07161
G1 X136.989 Y130.365 E.05646
G1 X136.974 Y130.204 E.00539
; WIPE_START
G1 F16213.044
G1 X137.135 Y130.113 E-.07014
G1 X137.506 Y129.976 E-.15021
G1 X137.839 Y129.766 E-.14964
G1 X138.114 Y129.482 E-.15022
G1 X138.318 Y129.139 E-.15161
G1 X138.395 Y128.92 E-.08818
; WIPE_END
G1 E-.04 F1800
G1 X130.79 Y129.576 Z9.6 F30000
G1 X117.681 Y130.706 Z9.6
G1 Z9.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3221
M204 S5000
G1 X117.675 Y132.853 E.06596
G1 X117.675 Y132.865 E.00038
G1 X113.076 Y132.853 E.14134
G1 X113.076 Y132.841 E.00038
G1 X113.085 Y129.242 E.11058
G3 X113.317 Y128.424 I1.192 J-.104 E.02671
G3 X114.092 Y128.189 I.67 J.816 E.02553
G1 X116.594 Y128.196 E.07688
G1 X117.86 Y128.199 E.0389
G2 X118.186 Y129.19 I1.948 J-.091 E.03245
G2 X118.953 Y129.686 I1.186 J-.995 E.02848
G2 X119.666 Y129.771 I.678 J-2.65 E.02211
G1 X136.318 Y129.815 E.51168
G2 X137.332 Y129.623 I.036 J-2.577 E.03191
G2 X138.072 Y128.638 I-.605 J-1.226 E.03929
G2 X138.132 Y128.253 I-1.426 J-.418 E.012
G1 X141.9 Y128.263 E.11579
G3 X142.674 Y128.502 I.099 J1.052 E.02553
G3 X142.902 Y129.321 I-.964 J.709 E.02671
G1 X142.892 Y132.92 E.11058
G1 X142.892 Y132.932 E.00038
G1 X138.292 Y132.92 E.14134
G1 X138.292 Y132.908 E.00038
G1 X138.298 Y130.761 E.06596
G1 X138.257 Y130.761 E.00126
G1 X117.741 Y130.706 E.6304
M204 S10000
G1 X118.172 Y130.001 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107458
G1 F3221
G2 X118.324 Y130.093 I.185 J-.133 E.00096
G1 X117.739 Y129.856 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3221
G1 X117.545 Y129.647 E.00876
G1 X117.302 Y129.223 E.01503
G1 X117.227 Y128.982 E.00775
G1 X114.118 Y128.973 E.09553
G1 X113.904 Y128.993 E.00661
G1 X113.869 Y129.293 E.00926
G1 X113.862 Y132.071 E.08536
G1 X116.893 Y132.079 E.09315
G1 X116.899 Y130.109 E.06054
G1 X117.041 Y129.926 E.00711
G1 X117.733 Y129.912 E.02128
G1 X117.05 Y129.548 F30000
G1 F3221
G1 X116.952 Y129.358 E.00658
G1 X114.246 Y129.351 E.08313
G1 X114.24 Y131.695 E.07202
G1 X116.517 Y131.701 E.06998
G1 X116.521 Y130.108 E.04895
G1 X116.912 Y129.571 E.02038
G1 X116.991 Y129.558 E.00247
G1 X116.416 Y129.734 F30000
G1 F3221
G1 X114.622 Y129.729 E.05511
G1 X114.618 Y131.319 E.04885
G1 X116.141 Y131.323 E.0468
G1 X116.144 Y130.107 E.03737
G1 X116.38 Y129.782 E.01233
G1 X115.767 Y130.109 F30000
M73 P66 R5
G1 F3221
G1 X114.998 Y130.107 E.02363
G1 X114.996 Y130.943 E.02568
G1 X115.765 Y130.945 E.02363
G1 X115.767 Y130.169 E.02383
; WIPE_START
G1 F15000
G1 X115.765 Y130.945 E-.29475
G1 X114.996 Y130.943 E-.29227
G1 X114.997 Y130.487 E-.17299
; WIPE_END
G1 E-.04 F1800
G1 X119.198 Y130.228 Z9.6 F30000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591851
G1 F3221
G1 X136.322 Y130.285 E.766
G1 X136.784 Y130.275 E.02066
G1 X137.658 Y130.144 F30000
; LINE_WIDTH: 0.107471
G1 F3221
G2 X137.811 Y130.053 I-.031 J-.226 E.00096
G1 X138.221 Y129.936 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3221
G1 X138.272 Y129.977 E.00203
G1 X138.955 Y129.988 E.02096
G1 X139.084 Y130.168 E.00679
G1 X139.078 Y132.138 E.06054
G1 X142.11 Y132.146 E.09315
G1 X142.117 Y129.378 E.08503
G1 X142.075 Y129.082 E.00921
G1 X141.788 Y129.047 E.00888
G1 X138.761 Y129.039 E.093
G3 X138.262 Y129.893 I-1.977 J-.582 E.03068
G1 X138.935 Y129.606 F30000
G1 F3221
G1 X139.073 Y129.63 E.00431
G1 X139.461 Y130.169 E.02038
G1 X139.456 Y131.762 E.04895
G1 X141.734 Y131.768 E.06998
G1 X141.74 Y129.424 E.07202
G1 X139.035 Y129.417 E.08313
G1 X138.963 Y129.553 E.00474
G1 X139.568 Y129.795 F30000
G1 F3221
G1 X139.838 Y130.17 E.01417
G1 X139.835 Y131.386 E.03737
G1 X141.358 Y131.39 E.0468
G1 X141.362 Y129.8 E.04885
G1 X139.628 Y129.795 E.05327
G1 X140.215 Y130.174 F30000
G1 F3221
G1 X140.213 Y131.01 E.02568
G1 X140.982 Y131.012 E.02363
G1 X140.984 Y130.176 E.02568
G1 X140.275 Y130.174 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.984 Y130.176 E-.26947
G1 X140.982 Y131.012 E-.31754
G1 X140.526 Y131.01 E-.17299
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 47/118
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change
G17
G3 Z9.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.29 Y130.366
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.284 Y132.525 E.07161
G1 X113.469 Y132.515 E.12657
G1 X113.477 Y129.305 E.10649
G3 X113.599 Y128.759 I.854 J-.096 E.01891
G3 X113.91 Y128.652 I.364 J.557 E.01102
G1 X117.519 Y128.653 E.1197
G2 X117.871 Y129.482 I2.422 J-.541 E.03005
G2 X118.847 Y130.118 I1.522 J-1.269 E.03922
G1 X119.013 Y130.149 E.00561
G1 X118.992 Y130.371 E.00739
G1 X117.35 Y130.367 E.05447
; WIPE_START
G1 F16213.044
G1 X117.289 Y132.366 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.876 Y131.53 Z9.8 F30000
G1 X136.969 Y130.197 Z9.8
G1 Z9.4
G1 E.8 F1800
G1 F3230
G2 X137.839 Y129.819 I-.412 J-2.139 E.03172
G2 X138.436 Y128.855 I-1.351 J-1.504 E.03811
G1 X138.471 Y128.708 E.00502
G1 X141.89 Y128.717 E.11339
G3 X142.39 Y128.835 I.09 J.742 E.01742
G3 X142.501 Y129.18 I-.665 J.403 E.01212
G1 X142.501 Y132.592 E.1132
G1 X138.685 Y132.582 E.12657
G1 X138.691 Y130.423 E.07161
G1 X136.989 Y130.419 E.05646
G1 X136.974 Y130.257 E.0054
; WIPE_START
G1 F16213.044
G1 X137.135 Y130.166 E-.07013
G1 X137.506 Y130.03 E-.1502
G1 X137.839 Y129.819 E-.14968
G1 X138.114 Y129.535 E-.15021
G1 X138.318 Y129.192 E-.15166
G1 X138.394 Y128.973 E-.08812
; WIPE_END
G1 E-.04 F1800
G1 X130.79 Y129.629 Z9.8 F30000
G1 X117.681 Y130.759 Z9.8
G1 Z9.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.675 Y132.906 E.06596
G1 X117.675 Y132.918 E.00038
G1 X113.075 Y132.906 E.14134
G1 X113.075 Y132.894 E.00038
G1 X113.085 Y129.295 E.11058
G3 X113.316 Y128.484 I1.167 J-.106 E.02652
G3 X114.092 Y128.251 I.672 J.831 E.02552
G1 X117.86 Y128.261 E.11579
G2 X118.186 Y129.243 I1.957 J-.104 E.03217
G2 X118.953 Y129.739 I1.186 J-.995 E.02848
G2 X119.666 Y129.824 I.678 J-2.65 E.02211
G1 X136.318 Y129.868 E.51168
G2 X137.331 Y129.676 I.036 J-2.578 E.03191
G2 X138.059 Y128.744 I-.647 J-1.255 E.03749
G2 X138.131 Y128.315 I-3.513 J-.81 E.01337
G1 X141.9 Y128.325 E.1158
G3 X142.675 Y128.562 I.098 J1.064 E.02552
G3 X142.901 Y129.374 I-.94 J.7 E.02652
G1 X142.892 Y132.973 E.11058
G1 X142.892 Y132.985 E.00038
G1 X138.292 Y132.973 E.14134
G1 X138.292 Y132.961 E.00038
G1 X138.298 Y130.814 E.06596
G1 X138.257 Y130.814 E.00126
G1 X117.741 Y130.76 E.6304
M204 S10000
G1 X118.172 Y130.054 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107453
G1 F3230
G2 X118.324 Y130.146 I.185 J-.133 E.00096
G1 X117.739 Y129.91 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.545 Y129.701 E.00876
G1 X117.302 Y129.276 E.01503
G1 X117.23 Y129.044 E.00747
G1 X114.124 Y129.036 E.09542
G1 X113.912 Y129.069 E.00659
G1 X113.869 Y129.356 E.00892
G1 X113.862 Y132.124 E.08504
G1 X116.893 Y132.132 E.09315
G1 X116.898 Y130.162 E.06054
G1 X117.041 Y129.979 E.00711
G1 X117.733 Y129.965 E.02128
G1 X117.05 Y129.601 F30000
G1 F3230
G1 X116.955 Y129.42 E.00628
G1 X114.246 Y129.413 E.08325
G1 X114.24 Y131.748 E.07174
G1 X116.517 Y131.754 E.06998
G1 X116.521 Y130.161 E.04895
G1 X116.917 Y129.623 E.02052
G1 X116.991 Y129.611 E.0023
G1 X116.412 Y129.796 F30000
G1 F3230
G1 X114.622 Y129.791 E.055
G1 X114.618 Y131.372 E.04857
G1 X116.141 Y131.376 E.0468
G1 X116.144 Y130.16 E.03737
G1 X116.376 Y129.844 E.01204
G1 X115.767 Y130.171 F30000
G1 F3230
G1 X114.998 Y130.169 E.02363
G1 X114.996 Y130.996 E.0254
G1 X115.765 Y130.998 E.02363
G1 X115.767 Y130.231 E.02356
; WIPE_START
G1 F15000
G1 X115.765 Y130.998 E-.29132
G1 X114.996 Y130.996 E-.29227
G1 X114.997 Y130.532 E-.17641
; WIPE_END
G1 E-.04 F1800
G1 X119.198 Y130.281 Z9.8 F30000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.659 Y130.294 E.02066
G1 X136.784 Y130.328 E.76601
G1 X137.658 Y130.198 F30000
; LINE_WIDTH: 0.107428
G1 F3230
G2 X137.81 Y130.106 I-.031 J-.225 E.00096
G1 X138.22 Y129.989 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.272 Y130.03 E.00202
G1 X138.953 Y130.041 E.02092
G1 X139.083 Y130.221 E.00684
G1 X139.078 Y132.191 E.06054
G1 X142.11 Y132.199 E.09315
G1 X142.117 Y129.43 E.08509
G1 X142.077 Y129.144 E.00886
G1 X141.798 Y129.109 E.00862
G1 X138.758 Y129.101 E.09342
G3 X138.262 Y129.946 I-1.978 J-.593 E.0304
G1 X138.935 Y129.66 F30000
G1 F3230
G1 X139.068 Y129.682 E.00414
G1 X139.461 Y130.222 E.02052
G1 X139.456 Y131.815 E.04895
G1 X141.734 Y131.821 E.06998
G1 X141.74 Y129.486 E.07174
G1 X139.031 Y129.479 E.08325
G1 X138.963 Y129.607 E.00444
G1 X139.572 Y129.857 F30000
G1 F3230
G1 X139.838 Y130.223 E.01388
G1 X139.834 Y131.439 E.03737
G1 X141.358 Y131.443 E.0468
G1 X141.362 Y129.862 E.04857
G1 X139.632 Y129.858 E.05315
G1 X140.215 Y130.236 F30000
G1 F3230
G1 X140.212 Y131.063 E.0254
G1 X140.982 Y131.065 E.02363
G1 X140.984 Y130.238 E.0254
G1 X140.275 Y130.236 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X140.984 Y130.238 E-.26947
G1 X140.982 Y131.065 E-.31412
G1 X140.517 Y131.064 E-.17642
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 48/118
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change
G17
G3 Z9.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.29 Y130.42
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.284 Y132.578 E.07161
G1 X113.468 Y132.568 E.12657
G1 X113.477 Y129.358 E.10649
M73 P67 R5
G3 X113.599 Y128.812 I.854 J-.096 E.0189
G3 X113.909 Y128.706 I.362 J.553 E.01099
G1 X117.519 Y128.706 E.11973
G2 X117.871 Y129.535 I2.418 J-.539 E.03003
G2 X118.847 Y130.171 I1.522 J-1.268 E.03922
G1 X119.013 Y130.203 E.00561
G1 X118.992 Y130.424 E.00739
G1 X117.35 Y130.42 E.05447
; WIPE_START
G1 F16213.044
G1 X117.289 Y132.419 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.875 Y131.583 Z10 F30000
G1 X136.969 Y130.25 Z10
G1 Z9.6
G1 E.8 F1800
G1 F3218
G2 X137.839 Y129.872 I-.413 J-2.14 E.03172
G2 X138.436 Y128.909 I-1.352 J-1.504 E.0381
G1 X138.471 Y128.762 E.00502
G1 X141.89 Y128.771 E.1134
G3 X142.39 Y128.888 I.091 J.738 E.01741
G3 X142.501 Y129.233 I-.666 J.404 E.01212
G1 X142.501 Y132.645 E.11319
G1 X138.685 Y132.635 E.12657
G1 X138.691 Y130.477 E.07161
G1 X136.989 Y130.472 E.05646
G1 X136.974 Y130.31 E.00539
; WIPE_START
G1 F16213.044
G1 X137.135 Y130.22 E-.07012
G1 X137.506 Y130.083 E-.15022
G1 X137.839 Y129.872 E-.14965
G1 X138.114 Y129.589 E-.15026
G1 X138.318 Y129.245 E-.15169
G1 X138.394 Y129.027 E-.08806
; WIPE_END
G1 E-.04 F1800
G1 X130.79 Y129.682 Z10 F30000
G1 X117.681 Y130.813 Z10
G1 Z9.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.675 Y132.959 E.06596
G1 X117.675 Y132.972 E.00038
G1 X113.075 Y132.959 E.14134
G1 X113.075 Y132.947 E.00038
G1 X113.085 Y129.348 E.11058
G3 X113.316 Y128.537 I1.167 J-.106 E.02652
G3 X114.096 Y128.305 I.671 J.831 E.02564
G1 X117.861 Y128.315 E.11569
G2 X118.396 Y129.515 I1.701 J-.039 E.04144
G2 X119.292 Y129.856 I1.102 J-1.545 E.0298
G1 X119.665 Y129.877 E.0115
G1 X136.318 Y129.922 E.51168
G2 X137.331 Y129.729 I.036 J-2.577 E.03191
G2 X138.059 Y128.798 I-.647 J-1.255 E.03748
G2 X138.131 Y128.369 I-3.489 J-.807 E.01337
G1 X141.9 Y128.379 E.11581
G3 X142.674 Y128.615 I.1 J1.062 E.02552
G3 X142.901 Y129.428 I-.94 J.7 E.02651
G1 X142.892 Y133.026 E.11058
G1 X142.892 Y133.039 E.00038
G1 X138.292 Y133.026 E.14134
G1 X138.292 Y133.014 E.00038
G1 X138.298 Y130.868 E.06596
G1 X138.257 Y130.867 E.00126
G1 X117.741 Y130.813 E.6304
M204 S10000
G1 X118.172 Y130.107 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107478
G1 F3218
G2 X118.324 Y130.199 I.185 J-.133 E.00096
G1 X117.739 Y129.963 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.545 Y129.754 E.00876
G1 X117.302 Y129.329 E.01503
G1 X117.23 Y129.098 E.00745
G1 X114.127 Y129.089 E.09533
G1 X113.912 Y129.123 E.00668
G1 X113.869 Y129.409 E.00891
G1 X113.862 Y132.177 E.08505
G1 X116.893 Y132.185 E.09315
G1 X116.898 Y130.215 E.06054
G1 X117.041 Y130.033 E.00711
G1 X117.733 Y130.018 E.02128
G1 X117.05 Y129.655 F30000
G1 F3218
G1 X116.955 Y129.474 E.00627
G1 X114.246 Y129.467 E.08325
G1 X114.24 Y131.801 E.07173
G1 X116.517 Y131.807 E.06998
G1 X116.521 Y130.214 E.04895
G1 X116.917 Y129.676 E.02052
G1 X116.991 Y129.664 E.00229
G1 X116.412 Y129.85 F30000
G1 F3218
G1 X114.622 Y129.845 E.05499
G1 X114.618 Y131.425 E.04856
G1 X116.141 Y131.429 E.0468
G1 X116.144 Y130.213 E.03737
G1 X116.376 Y129.898 E.01202
G1 X115.767 Y130.225 F30000
G1 F3218
G1 X114.998 Y130.223 E.02363
G1 X114.996 Y131.049 E.02539
G1 X115.765 Y131.051 E.02363
G1 X115.767 Y130.285 E.02354
; WIPE_START
G1 F15000
G1 X115.765 Y131.051 E-.29116
G1 X114.996 Y131.049 E-.29226
G1 X114.997 Y130.584 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.197 Y130.334 Z10 F30000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591852
G1 F3218
G1 X136.322 Y130.392 E.766
G1 X136.784 Y130.381 E.02066
G1 X137.658 Y130.251 F30000
; LINE_WIDTH: 0.107454
G1 F3218
G2 X137.81 Y130.159 I-.031 J-.226 E.00096
G1 X138.22 Y130.042 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.272 Y130.083 E.00203
G1 X138.952 Y130.094 E.02091
G1 X139.083 Y130.274 E.00684
G1 X139.078 Y132.244 E.06054
G1 X142.11 Y132.252 E.09315
G1 X142.117 Y129.483 E.08509
G1 X142.077 Y129.198 E.00885
G1 X141.799 Y129.163 E.00861
G1 X138.758 Y129.155 E.09343
G3 X138.262 Y129.999 I-1.978 J-.594 E.03038
G1 X138.935 Y129.713 F30000
G1 F3218
G1 X139.068 Y129.735 E.00414
G1 X139.46 Y130.275 E.02052
G1 X139.456 Y131.868 E.04895
G1 X141.734 Y131.874 E.06998
G1 X141.74 Y129.54 E.07173
G1 X139.03 Y129.533 E.08325
G1 X138.963 Y129.66 E.00443
G1 X139.572 Y129.911 F30000
G1 F3218
G1 X139.837 Y130.276 E.01387
G1 X139.834 Y131.492 E.03737
G1 X141.358 Y131.496 E.0468
G1 X141.362 Y129.916 E.04856
G1 X139.632 Y129.911 E.05315
G1 X140.215 Y130.29 F30000
G1 F3218
G1 X140.212 Y131.116 E.02539
G1 X140.981 Y131.118 E.02363
G1 X140.984 Y130.292 E.02539
G1 X140.275 Y130.29 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.984 Y130.292 E-.26947
G1 X140.981 Y131.118 E-.31396
G1 X140.517 Y131.117 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 49/118
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change
G17
G3 Z10 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.29 Y130.473
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.284 Y132.632 E.07161
G1 X113.468 Y132.622 E.12657
G1 X113.477 Y129.411 E.10649
G3 X113.599 Y128.865 I.854 J-.096 E.0189
G3 X113.909 Y128.759 I.362 J.553 E.011
G1 X117.518 Y128.76 E.11973
G2 X117.871 Y129.588 I2.42 J-.54 E.03003
G2 X118.847 Y130.224 I1.522 J-1.268 E.03922
G1 X119.013 Y130.256 E.00561
G1 X118.992 Y130.477 E.00739
G1 X117.35 Y130.473 E.05447
; WIPE_START
G1 F16213.044
G1 X117.289 Y132.472 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.875 Y131.636 Z10.2 F30000
G1 X136.969 Y130.304 Z10.2
G1 Z9.8
G1 E.8 F1800
G1 F3218
G2 X137.839 Y129.926 I-.413 J-2.14 E.03172
G2 X138.435 Y128.962 I-1.351 J-1.504 E.03809
G1 X138.471 Y128.815 E.00503
G1 X141.89 Y128.824 E.1134
G3 X142.39 Y128.942 I.091 J.738 E.01741
G3 X142.501 Y129.286 I-.666 J.404 E.01212
G1 X142.501 Y132.699 E.1132
G1 X138.685 Y132.689 E.12657
G1 X138.691 Y130.53 E.07161
G1 X136.989 Y130.525 E.05646
G1 X136.974 Y130.363 E.00539
; WIPE_START
G1 F16213.044
G1 X137.135 Y130.273 E-.07014
G1 X137.506 Y130.136 E-.15021
G1 X137.839 Y129.926 E-.14964
G1 X138.114 Y129.642 E-.15027
G1 X138.318 Y129.298 E-.15175
G1 X138.394 Y129.08 E-.08799
; WIPE_END
G1 E-.04 F1800
G1 X130.79 Y129.736 Z10.2 F30000
G1 X117.681 Y130.866 Z10.2
G1 Z9.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.675 Y133.013 E.06596
G1 X117.675 Y133.025 E.00038
G1 X113.075 Y133.013 E.14134
G1 X113.075 Y133 E.00038
G1 X113.085 Y129.402 E.11058
G3 X113.316 Y128.59 I1.167 J-.106 E.02651
G3 X114.094 Y128.358 I.671 J.83 E.02559
G1 X117.86 Y128.368 E.11574
G2 X118.395 Y129.568 I1.701 J-.039 E.04144
G2 X119.292 Y129.91 I1.102 J-1.545 E.0298
G1 X119.665 Y129.93 E.0115
G1 X136.318 Y129.975 E.51168
G2 X137.331 Y129.783 I.036 J-2.577 E.03191
G2 X138.059 Y128.851 I-.646 J-1.255 E.03747
G2 X138.131 Y128.422 I-3.465 J-.804 E.01338
G1 X141.9 Y128.432 E.11581
G3 X142.674 Y128.668 I.1 J1.061 E.02552
G3 X142.901 Y129.481 I-.94 J.7 E.02651
G1 X142.892 Y133.08 E.11058
G1 X142.892 Y133.092 E.00038
G1 X138.292 Y133.08 E.14134
G1 X138.292 Y133.067 E.00038
G1 X138.297 Y130.921 E.06596
G1 X138.256 Y130.921 E.00126
G1 X117.741 Y130.866 E.6304
M204 S10000
G1 X118.172 Y130.16 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107468
G1 F3218
G2 X118.324 Y130.253 I.185 J-.133 E.00096
G1 X117.738 Y130.016 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.545 Y129.807 E.00876
G1 X117.302 Y129.382 E.01503
G1 X117.23 Y129.151 E.00745
G1 X114.125 Y129.143 E.09538
G1 X113.912 Y129.176 E.00664
G1 X113.869 Y129.463 E.00891
G1 X113.861 Y132.23 E.08505
G1 X116.893 Y132.239 E.09315
G1 X116.898 Y130.268 E.06054
G1 X117.04 Y130.086 E.00711
G1 X117.733 Y130.071 E.02128
G1 X117.05 Y129.708 F30000
G1 F3218
G1 X116.955 Y129.527 E.00627
G1 X114.246 Y129.52 E.08325
G1 X114.239 Y131.854 E.07173
G1 X116.517 Y131.86 E.06998
G1 X116.521 Y130.267 E.04895
G1 X116.917 Y129.729 E.02052
G1 X116.991 Y129.717 E.00229
G1 X116.411 Y129.903 F30000
G1 F3218
G1 X114.622 Y129.898 E.05499
G1 X114.618 Y131.478 E.04856
G1 X116.141 Y131.482 E.0468
G1 X116.144 Y130.266 E.03737
G1 X116.376 Y129.951 E.01202
G1 X115.767 Y130.278 F30000
G1 F3218
G1 X114.998 Y130.276 E.02363
G1 X114.996 Y131.102 E.02539
G1 X115.765 Y131.104 E.02363
G1 X115.767 Y130.338 E.02354
; WIPE_START
G1 F15000
G1 X115.765 Y131.104 E-.29116
G1 X114.996 Y131.102 E-.29226
G1 X114.997 Y130.638 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.197 Y130.388 Z10.2 F30000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591851
G1 F3218
G1 X136.322 Y130.445 E.766
G1 X136.783 Y130.434 E.02066
G1 X137.657 Y130.304 F30000
; LINE_WIDTH: 0.107471
G1 F3218
G2 X137.81 Y130.213 I-.031 J-.226 E.00096
G1 X138.22 Y130.095 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.272 Y130.137 E.00203
G1 X138.952 Y130.147 E.0209
G1 X139.083 Y130.327 E.00684
G1 X139.078 Y132.298 E.06054
G1 X142.11 Y132.306 E.09315
G1 X142.117 Y129.536 E.08509
G1 X142.076 Y129.251 E.00885
G1 X141.798 Y129.216 E.00861
G1 X138.758 Y129.208 E.09343
G3 X138.262 Y130.052 I-1.979 J-.594 E.03037
G1 X138.935 Y129.766 F30000
G1 F3218
G1 X139.067 Y129.788 E.00414
G1 X139.46 Y130.328 E.02052
G1 X139.456 Y131.921 E.04895
G1 X141.733 Y131.928 E.06998
G1 X141.74 Y129.593 E.07173
G1 X139.03 Y129.586 E.08325
G1 X138.963 Y129.713 E.00443
G1 X139.572 Y129.964 F30000
G1 F3218
G1 X139.837 Y130.329 E.01387
G1 X139.834 Y131.545 E.03737
G1 X141.357 Y131.549 E.0468
G1 X141.362 Y129.969 E.04856
G1 X139.632 Y129.965 E.05315
G1 X140.214 Y130.343 F30000
G1 F3218
G1 X140.212 Y131.169 E.02539
G1 X140.981 Y131.171 E.02363
G1 X140.984 Y130.345 E.02539
G1 X140.274 Y130.343 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.984 Y130.345 E-.26947
G1 X140.981 Y131.171 E-.31396
G1 X140.517 Y131.17 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 50/118
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change
G17
G3 Z10.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.29 Y130.526
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.284 Y132.685 E.07161
G1 X113.468 Y132.675 E.12657
G1 X113.477 Y129.464 E.1065
G3 X113.598 Y128.918 I.854 J-.096 E.0189
G3 X113.909 Y128.812 I.363 J.553 E.011
G1 X117.518 Y128.813 E.11973
G2 X117.871 Y129.641 I2.418 J-.539 E.03003
G2 X118.847 Y130.277 I1.522 J-1.268 E.03922
G1 X119.013 Y130.309 E.00561
G1 X118.992 Y130.531 E.00739
G1 X117.35 Y130.526 E.05447
; WIPE_START
G1 F16213.044
G1 X117.289 Y132.525 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.875 Y131.689 Z10.4 F30000
G1 X136.968 Y130.357 Z10.4
G1 Z10
G1 E.8 F1800
G1 F3230
G2 X137.838 Y129.979 I-.413 J-2.14 E.03172
G2 X138.435 Y129.016 I-1.352 J-1.504 E.03808
G1 X138.471 Y128.868 E.00504
G1 X141.89 Y128.878 E.1134
G3 X142.39 Y128.995 I.091 J.738 E.01741
G3 X142.501 Y129.34 I-.666 J.403 E.01212
G1 X142.5 Y132.752 E.1132
G1 X138.685 Y132.742 E.12657
G1 X138.69 Y130.583 E.07161
G1 X136.988 Y130.578 E.05646
G1 X136.974 Y130.417 E.00539
; WIPE_START
G1 F16213.044
G1 X137.135 Y130.326 E-.07017
G1 X137.506 Y130.189 E-.15018
G1 X137.838 Y129.979 E-.14966
G1 X138.114 Y129.695 E-.15029
G1 X138.318 Y129.351 E-.15177
G1 X138.394 Y129.133 E-.08793
; WIPE_END
G1 E-.04 F1800
G1 X130.79 Y129.789 Z10.4 F30000
G1 X117.681 Y130.919 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.675 Y133.066 E.06596
G1 X117.675 Y133.078 E.00038
G1 X113.075 Y133.066 E.14134
G1 X113.075 Y133.054 E.00038
M73 P68 R5
G1 X113.085 Y129.455 E.11058
G3 X113.316 Y128.643 I1.167 J-.106 E.02651
G3 X114.095 Y128.412 I.671 J.831 E.02562
G1 X117.86 Y128.422 E.11571
G2 X118.395 Y129.621 I1.7 J-.039 E.04144
G2 X119.292 Y129.963 I1.102 J-1.545 E.0298
G1 X119.665 Y129.984 E.0115
G1 X136.318 Y130.028 E.51168
G2 X137.331 Y129.836 I.036 J-2.578 E.03191
G2 X138.059 Y128.905 I-.647 J-1.255 E.03746
G2 X138.131 Y128.475 I-3.437 J-.8 E.01339
G1 X141.9 Y128.486 E.11581
G3 X142.674 Y128.722 I.1 J1.061 E.02552
G3 X142.901 Y129.534 I-.94 J.7 E.02651
G1 X142.891 Y133.133 E.11058
G1 X142.891 Y133.145 E.00038
G1 X138.292 Y133.133 E.14134
G1 X138.292 Y133.121 E.00038
G1 X138.297 Y130.974 E.06596
G1 X138.256 Y130.974 E.00126
G1 X117.741 Y130.919 E.6304
M204 S10000
G1 X118.172 Y130.214 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107459
G1 F3230
G2 X118.324 Y130.306 I.185 J-.133 E.00096
G1 X117.738 Y130.069 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.544 Y129.86 E.00877
G1 X117.302 Y129.435 E.01503
G1 X117.23 Y129.204 E.00744
G1 X114.126 Y129.196 E.09535
G1 X113.912 Y129.229 E.00667
G1 X113.869 Y129.516 E.0089
G1 X113.861 Y132.284 E.08505
G1 X116.893 Y132.292 E.09315
G1 X116.898 Y130.322 E.06054
G1 X117.04 Y130.139 E.0071
G1 X117.733 Y130.125 E.02128
G1 X117.05 Y129.761 F30000
G1 F3230
G1 X116.955 Y129.58 E.00627
G1 X114.246 Y129.573 E.08325
G1 X114.239 Y131.908 E.07173
G1 X116.517 Y131.914 E.06998
G1 X116.521 Y130.321 E.04895
G1 X116.917 Y129.783 E.02052
G1 X116.99 Y129.771 E.00229
G1 X116.411 Y129.956 F30000
G1 F3230
G1 X114.622 Y129.951 E.05499
G1 X114.617 Y131.532 E.04856
G1 X116.141 Y131.536 E.0468
G1 X116.144 Y130.32 E.03737
G1 X116.376 Y130.004 E.01202
G1 X115.767 Y130.331 F30000
G1 F3230
G1 X114.998 Y130.329 E.02363
G1 X114.995 Y131.156 E.02539
G1 X115.765 Y131.158 E.02363
G1 X115.767 Y130.391 E.02354
; WIPE_START
G1 F15000
G1 X115.765 Y131.158 E-.29116
G1 X114.995 Y131.156 E-.29226
G1 X114.997 Y130.691 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.197 Y130.441 Z10.4 F30000
G1 Z10
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.659 Y130.454 E.02066
G1 X136.783 Y130.488 E.76601
G1 X137.657 Y130.357 F30000
; LINE_WIDTH: 0.107445
G1 F3230
G2 X137.81 Y130.266 I-.031 J-.225 E.00096
G1 X138.22 Y130.149 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.272 Y130.19 E.00203
G1 X138.952 Y130.2 E.02091
G1 X139.083 Y130.381 E.00684
G1 X139.078 Y132.351 E.06054
G1 X142.109 Y132.359 E.09315
G1 X142.117 Y129.589 E.08509
G1 X142.076 Y129.304 E.00885
G1 X141.798 Y129.269 E.00861
G1 X138.758 Y129.261 E.09343
G3 X138.262 Y130.106 I-1.979 J-.594 E.03038
G1 X138.934 Y129.819 F30000
G1 F3230
G1 X139.067 Y129.841 E.00414
G1 X139.46 Y130.382 E.02052
G1 X139.456 Y131.975 E.04895
G1 X141.733 Y131.981 E.06998
G1 X141.74 Y129.646 E.07173
G1 X139.03 Y129.639 E.08325
G1 X138.962 Y129.766 E.00443
G1 X139.572 Y130.018 F30000
G1 F3230
G1 X139.837 Y130.383 E.01387
G1 X139.834 Y131.599 E.03737
G1 X141.357 Y131.603 E.0468
G1 X141.361 Y130.022 E.04856
G1 X139.632 Y130.018 E.05315
G1 X140.214 Y130.396 F30000
G1 F3230
G1 X140.212 Y131.223 E.02539
G1 X140.981 Y131.225 E.02363
G1 X140.983 Y130.398 E.02539
G1 X140.274 Y130.397 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 10.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.983 Y130.398 E-.26947
G1 X140.981 Y131.225 E-.31396
G1 X140.517 Y131.223 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 51/118
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change
G17
G3 Z10.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.289 Y130.579
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.284 Y132.738 E.07161
G1 X113.468 Y132.728 E.12657
G1 X113.477 Y129.518 E.1065
G3 X113.598 Y128.972 I.854 J-.096 E.0189
G3 X113.909 Y128.866 I.363 J.554 E.01099
G1 X117.518 Y128.866 E.11973
G2 X117.87 Y129.695 I2.418 J-.539 E.03003
G2 X118.846 Y130.331 I1.522 J-1.268 E.03922
G1 X119.013 Y130.362 E.00561
G1 X118.991 Y130.584 E.00739
G1 X117.349 Y130.58 E.05447
; WIPE_START
G1 F16213.044
G1 X117.288 Y132.579 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.875 Y131.743 Z10.6 F30000
G1 X136.968 Y130.41 Z10.6
G1 Z10.2
G1 E.8 F1800
G1 F3230
G2 X137.838 Y130.032 I-.412 J-2.139 E.03172
G2 X138.435 Y129.07 I-1.352 J-1.504 E.03807
G1 X138.471 Y128.922 E.00505
G1 X141.889 Y128.931 E.11341
G3 X142.39 Y129.048 I.091 J.738 E.01741
G3 X142.5 Y129.393 I-.665 J.403 E.01212
G1 X142.5 Y132.805 E.1132
G1 X138.685 Y132.795 E.12657
G1 X138.69 Y130.636 E.07161
G1 X136.988 Y130.632 E.05646
G1 X136.974 Y130.47 E.0054
; WIPE_START
G1 F16213.044
G1 X137.135 Y130.379 E-.07017
G1 X137.505 Y130.243 E-.15018
G1 X137.838 Y130.032 E-.14967
G1 X138.114 Y129.748 E-.15029
G1 X138.317 Y129.405 E-.1518
G1 X138.394 Y129.186 E-.08789
; WIPE_END
G1 E-.04 F1800
G1 X130.79 Y129.842 Z10.6 F30000
G1 X117.68 Y130.972 Z10.6
G1 Z10.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.675 Y133.119 E.06596
G1 X117.675 Y133.131 E.00038
G1 X113.075 Y133.119 E.14134
G1 X113.075 Y133.107 E.00038
G1 X113.084 Y129.508 E.11058
G3 X113.316 Y128.697 I1.167 J-.106 E.02652
G3 X114.096 Y128.465 I.672 J.831 E.02565
G1 X117.86 Y128.475 E.11567
G2 X118.395 Y129.675 I1.7 J-.039 E.04144
G2 X119.291 Y130.016 I1.102 J-1.545 E.0298
G1 X119.665 Y130.037 E.0115
G1 X136.317 Y130.081 E.51168
G2 X137.331 Y129.889 I.036 J-2.578 E.03191
G2 X138.058 Y128.958 I-.646 J-1.255 E.03745
G2 X138.131 Y128.529 I-3.414 J-.797 E.0134
G1 X141.9 Y128.539 E.11581
G3 X142.674 Y128.775 I.1 J1.062 E.02552
G3 X142.901 Y129.587 I-.94 J.7 E.02652
G1 X142.891 Y133.186 E.11058
G1 X142.891 Y133.198 E.00038
G1 X138.291 Y133.186 E.14134
G1 X138.291 Y133.174 E.00038
G1 X138.297 Y131.027 E.06596
G1 X138.256 Y131.027 E.00126
G1 X117.74 Y130.973 E.6304
M204 S10000
G1 X118.171 Y130.267 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107466
G1 F3230
G2 X118.324 Y130.359 I.185 J-.133 E.00096
G1 X117.738 Y130.123 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.544 Y129.913 E.00877
G1 X117.301 Y129.488 E.01504
G1 X117.229 Y129.257 E.00744
G1 X114.127 Y129.249 E.09533
G1 X113.912 Y129.283 E.00669
G1 X113.868 Y129.569 E.00891
G1 X113.861 Y132.337 E.08505
G1 X116.893 Y132.345 E.09315
G1 X116.898 Y130.375 E.06054
G1 X117.04 Y130.193 E.0071
G1 X117.733 Y130.178 E.02128
G1 X117.05 Y129.814 F30000
G1 F3230
G1 X116.955 Y129.634 E.00627
G1 X114.245 Y129.626 E.08325
G1 X114.239 Y131.961 E.07173
G1 X116.517 Y131.967 E.06998
G1 X116.521 Y130.374 E.04895
G1 X116.917 Y129.836 E.02052
G1 X116.99 Y129.824 E.00229
G1 X116.411 Y130.009 F30000
G1 F3230
G1 X114.621 Y130.005 E.05499
G1 X114.617 Y131.585 E.04856
G1 X116.14 Y131.589 E.0468
G1 X116.144 Y130.373 E.03737
G1 X116.376 Y130.058 E.01202
G1 X115.767 Y130.385 F30000
G1 F3230
G1 X114.997 Y130.383 E.02363
G1 X114.995 Y131.209 E.02539
G1 X115.764 Y131.211 E.02363
G1 X115.766 Y130.445 E.02354
; WIPE_START
G1 F15000
G1 X115.764 Y131.211 E-.29116
G1 X114.995 Y131.209 E-.29226
G1 X114.997 Y130.744 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.197 Y130.494 Z10.6 F30000
G1 Z10.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.659 Y130.507 E.02066
G1 X136.783 Y130.541 E.76601
G1 X137.657 Y130.411 F30000
; LINE_WIDTH: 0.107438
G1 F3230
G2 X137.81 Y130.319 I-.031 J-.225 E.00096
G1 X138.22 Y130.202 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.271 Y130.243 E.00202
G1 X138.952 Y130.254 E.02092
G1 X139.083 Y130.434 E.00684
G1 X139.078 Y132.404 E.06054
G1 X142.109 Y132.412 E.09315
G1 X142.117 Y129.643 E.08509
G1 X142.076 Y129.357 E.00885
G1 X141.798 Y129.323 E.00861
G1 X138.757 Y129.315 E.09343
G3 X138.261 Y130.159 I-1.979 J-.594 E.03038
G1 X138.934 Y129.873 F30000
G1 F3230
G1 X139.067 Y129.895 E.00414
G1 X139.46 Y130.435 E.02052
G1 X139.456 Y132.028 E.04895
G1 X141.733 Y132.034 E.06998
G1 X141.739 Y129.7 E.07173
G1 X139.03 Y129.692 E.08325
G1 X138.962 Y129.82 E.00443
G1 X139.572 Y130.071 F30000
G1 F3230
G1 X139.837 Y130.436 E.01387
G1 X139.834 Y131.652 E.03737
G1 X141.357 Y131.656 E.0468
G1 X141.361 Y130.076 E.04856
G1 X139.632 Y130.071 E.05315
G1 X140.214 Y130.45 F30000
G1 F3230
G1 X140.212 Y131.276 E.02539
G1 X140.981 Y131.278 E.02363
G1 X140.983 Y130.452 E.02539
G1 X140.274 Y130.45 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 10.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.983 Y130.452 E-.26947
G1 X140.981 Y131.278 E-.31396
G1 X140.516 Y131.277 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 52/118
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change
G17
G3 Z10.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.289 Y130.633
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.283 Y132.791 E.07161
G1 X113.468 Y132.781 E.12657
G1 X113.476 Y129.571 E.10649
G3 X113.598 Y129.025 I.855 J-.096 E.0189
G3 X113.908 Y128.919 I.362 J.553 E.01099
G1 X117.518 Y128.919 E.11974
G2 X117.87 Y129.748 I2.416 J-.538 E.03003
G2 X118.846 Y130.384 I1.522 J-1.268 E.03923
G1 X119.012 Y130.415 E.00561
G1 X118.991 Y130.637 E.00739
G1 X117.349 Y130.633 E.05447
; WIPE_START
G1 F16213.044
G1 X117.288 Y132.632 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.875 Y131.796 Z10.8 F30000
G1 X136.968 Y130.463 Z10.8
G1 Z10.4
G1 E.8 F1800
G1 F3218
G2 X137.838 Y130.085 I-.413 J-2.14 E.03172
G2 X138.435 Y129.123 I-1.352 J-1.504 E.03806
G1 X138.47 Y128.975 E.00506
G1 X141.889 Y128.984 E.11341
G3 X142.39 Y129.101 I.091 J.738 E.01741
G3 X142.5 Y129.446 I-.665 J.403 E.01212
G1 X142.5 Y132.858 E.1132
G1 X138.684 Y132.848 E.12657
G1 X138.69 Y130.69 E.07161
G1 X136.988 Y130.685 E.05646
G1 X136.974 Y130.523 E.00539
; WIPE_START
G1 F16213.044
G1 X137.134 Y130.433 E-.07012
G1 X137.505 Y130.296 E-.15023
G1 X137.838 Y130.085 E-.14966
G1 X138.114 Y129.802 E-.15025
G1 X138.317 Y129.458 E-.15188
G1 X138.394 Y129.24 E-.08786
; WIPE_END
G1 E-.04 F1800
G1 X130.79 Y129.895 Z10.8 F30000
G1 X117.68 Y131.026 Z10.8
G1 Z10.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.675 Y133.172 E.06596
G1 X117.675 Y133.185 E.00038
G1 X113.075 Y133.172 E.14134
G1 X113.075 Y133.16 E.00038
G1 X113.084 Y129.561 E.11058
G3 X113.315 Y128.75 I1.167 J-.106 E.02651
G3 X114.097 Y128.518 I.672 J.831 E.02569
G1 X117.86 Y128.528 E.11564
G2 X118.395 Y129.728 I1.699 J-.039 E.04144
G2 X119.291 Y130.069 I1.102 J-1.545 E.0298
G1 X119.665 Y130.09 E.0115
G1 X136.317 Y130.135 E.51168
G2 X137.331 Y129.942 I.036 J-2.577 E.03191
G2 X138.072 Y128.954 I-.605 J-1.226 E.03939
G2 X138.131 Y128.582 I-1.363 J-.405 E.01161
G1 X141.899 Y128.592 E.11581
G3 X142.674 Y128.828 I.1 J1.061 E.02552
G3 X142.901 Y129.641 I-.94 J.7 E.02651
G1 X142.891 Y133.239 E.11058
G1 X142.891 Y133.252 E.00038
G1 X138.291 Y133.239 E.14134
G1 X138.291 Y133.227 E.00038
G1 X138.297 Y131.081 E.06596
G1 X138.256 Y131.08 E.00126
G1 X117.74 Y131.026 E.6304
M204 S10000
G1 X118.171 Y130.32 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107461
G1 F3218
G2 X118.324 Y130.412 I.185 J-.133 E.00096
G1 X117.738 Y130.176 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.544 Y129.967 E.00877
G1 X117.301 Y129.542 E.01504
G1 X117.229 Y129.311 E.00743
G1 X114.128 Y129.302 E.09529
G1 X113.912 Y129.336 E.00673
G1 X113.868 Y129.622 E.0089
G1 X113.861 Y132.39 E.08505
G1 X116.892 Y132.398 E.09315
G1 X116.898 Y130.428 E.06054
G1 X117.04 Y130.246 E.0071
M73 P69 R5
G1 X117.733 Y130.231 E.02129
G1 X117.049 Y129.868 F30000
G1 F3218
G1 X116.955 Y129.687 E.00627
G1 X114.245 Y129.68 E.08325
G1 X114.239 Y132.014 E.07173
G1 X116.516 Y132.02 E.06998
G1 X116.521 Y130.427 E.04895
G1 X116.917 Y129.889 E.02053
G1 X116.99 Y129.877 E.00229
G1 X116.411 Y130.063 F30000
G1 F3218
G1 X114.621 Y130.058 E.05499
G1 X114.617 Y131.638 E.04856
G1 X116.14 Y131.642 E.0468
G1 X116.144 Y130.426 E.03737
G1 X116.375 Y130.111 E.01202
G1 X115.766 Y130.438 F30000
G1 F3218
G1 X114.997 Y130.436 E.02363
G1 X114.995 Y131.262 E.02539
G1 X115.764 Y131.264 E.02363
G1 X115.766 Y130.498 E.02354
; WIPE_START
G1 F15000
G1 X115.764 Y131.264 E-.29116
G1 X114.995 Y131.262 E-.29227
G1 X114.996 Y130.797 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.197 Y130.547 Z10.8 F30000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591852
G1 F3218
G1 X136.321 Y130.605 E.766
G1 X136.783 Y130.594 E.02066
G1 X137.657 Y130.464 F30000
; LINE_WIDTH: 0.107456
G1 F3218
G2 X137.81 Y130.372 I-.031 J-.226 E.00096
G1 X138.22 Y130.255 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.271 Y130.296 E.00203
G1 X138.952 Y130.307 E.02091
G1 X139.083 Y130.487 E.00684
G1 X139.078 Y132.457 E.06054
G1 X142.109 Y132.465 E.09315
G1 X142.116 Y129.696 E.08509
G1 X142.076 Y129.411 E.00885
G1 X141.798 Y129.376 E.00861
G1 X138.757 Y129.368 E.09343
G3 X138.261 Y130.212 I-1.98 J-.595 E.03038
G1 X138.934 Y129.926 F30000
G1 F3218
G1 X139.067 Y129.948 E.00414
G1 X139.46 Y130.488 E.02052
G1 X139.456 Y132.081 E.04895
G1 X141.733 Y132.087 E.06998
G1 X141.739 Y129.753 E.07173
G1 X139.03 Y129.746 E.08325
G1 X138.962 Y129.873 E.00443
G1 X139.571 Y130.124 F30000
G1 F3218
G1 X139.837 Y130.489 E.01387
G1 X139.834 Y131.705 E.03737
G1 X141.357 Y131.709 E.0468
G1 X141.361 Y130.129 E.04856
G1 X139.631 Y130.124 E.05315
G1 X140.214 Y130.503 F30000
G1 F3218
G1 X140.212 Y131.329 E.02539
G1 X140.981 Y131.331 E.02363
G1 X140.983 Y130.505 E.02539
G1 X140.274 Y130.503 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 10.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X140.983 Y130.505 E-.26947
G1 X140.981 Y131.331 E-.31396
G1 X140.516 Y131.33 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 53/118
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change
G17
G3 Z10.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.289 Y130.686
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.283 Y132.845 E.07161
G1 X113.468 Y132.835 E.12657
G1 X113.476 Y129.624 E.10649
G3 X113.598 Y129.078 I.854 J-.096 E.0189
G3 X113.908 Y128.972 I.362 J.552 E.01099
G1 X117.518 Y128.973 E.11974
G2 X117.87 Y129.801 I2.415 J-.538 E.03003
G2 X118.846 Y130.437 I1.523 J-1.269 E.03922
G1 X119.012 Y130.469 E.00561
G1 X118.991 Y130.69 E.00739
G1 X117.349 Y130.686 E.05447
; WIPE_START
G1 F16213.044
G1 X117.288 Y132.685 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.875 Y131.849 Z11 F30000
G1 X136.968 Y130.517 Z11
G1 Z10.6
G1 E.8 F1800
G1 F3218
G2 X137.838 Y130.139 I-.413 J-2.14 E.03172
G2 X138.434 Y129.177 I-1.352 J-1.504 E.03804
G1 X138.47 Y129.028 E.00507
G1 X141.889 Y129.037 E.11341
G3 X142.39 Y129.155 I.091 J.738 E.01741
G3 X142.5 Y129.499 I-.666 J.403 E.01211
G1 X142.5 Y132.912 E.1132
G1 X138.684 Y132.902 E.12657
G1 X138.69 Y130.743 E.07161
G1 X136.988 Y130.738 E.05646
G1 X136.973 Y130.576 E.00539
; WIPE_START
G1 F16213.044
G1 X137.134 Y130.486 E-.07015
G1 X137.505 Y130.349 E-.15019
G1 X137.838 Y130.139 E-.14966
G1 X138.114 Y129.855 E-.1503
G1 X138.317 Y129.511 E-.15193
G1 X138.394 Y129.293 E-.08777
; WIPE_END
G1 E-.04 F1800
G1 X130.789 Y129.949 Z11 F30000
G1 X117.68 Y131.079 Z11
G1 Z10.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.674 Y133.226 E.06596
G1 X117.674 Y133.238 E.00038
G1 X113.075 Y133.226 E.14134
G1 X113.075 Y133.213 E.00038
G1 X113.084 Y129.615 E.11058
G3 X113.315 Y128.803 I1.167 J-.106 E.02651
G3 X114.098 Y128.571 I.672 J.832 E.02572
G1 X117.86 Y128.581 E.1156
G2 X118.395 Y129.781 I1.698 J-.038 E.04144
G2 X119.291 Y130.123 I1.102 J-1.545 E.02979
G1 X119.665 Y130.143 E.0115
G1 X136.317 Y130.188 E.51168
G2 X137.331 Y129.996 I.036 J-2.578 E.03191
G2 X138.058 Y129.066 I-.646 J-1.254 E.03743
G2 X138.13 Y128.635 I-3.364 J-.79 E.01342
G1 X141.899 Y128.645 E.11581
G3 X142.674 Y128.881 I.1 J1.061 E.02552
G3 X142.901 Y129.694 I-.94 J.7 E.02651
G1 X142.891 Y133.293 E.11058
G1 X142.891 Y133.305 E.00038
G1 X138.291 Y133.293 E.14134
G1 X138.291 Y133.28 E.00038
G1 X138.297 Y131.134 E.06596
G1 X138.256 Y131.134 E.00126
G1 X117.74 Y131.079 E.6304
M204 S10000
G1 X118.171 Y130.373 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10746
G1 F3218
G2 X118.323 Y130.466 I.185 J-.133 E.00096
G1 X117.738 Y130.229 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.544 Y130.02 E.00877
G1 X117.301 Y129.595 E.01505
G1 X117.229 Y129.364 E.00743
G1 X114.129 Y129.356 E.09526
G1 X113.911 Y129.389 E.00676
G1 X113.868 Y129.676 E.0089
G1 X113.861 Y132.444 E.08505
G1 X116.892 Y132.452 E.09315
G1 X116.898 Y130.481 E.06054
G1 X117.04 Y130.299 E.0071
G1 X117.732 Y130.284 E.02129
G1 X117.049 Y129.921 F30000
G1 F3218
G1 X116.955 Y129.74 E.00627
G1 X114.245 Y129.733 E.08325
G1 X114.239 Y132.067 E.07173
G1 X116.516 Y132.073 E.06998
G1 X116.52 Y130.48 E.04895
G1 X116.916 Y129.942 E.02053
G1 X116.99 Y129.93 E.00229
G1 X116.411 Y130.116 F30000
G1 F3218
G1 X114.621 Y130.111 E.05499
G1 X114.617 Y131.691 E.04856
G1 X116.14 Y131.695 E.0468
G1 X116.143 Y130.479 E.03737
G1 X116.375 Y130.164 E.01202
G1 X115.766 Y130.491 F30000
G1 F3218
G1 X114.997 Y130.489 E.02363
G1 X114.995 Y131.315 E.02539
G1 X115.764 Y131.317 E.02363
G1 X115.766 Y130.551 E.02354
; WIPE_START
G1 F15000
G1 X115.764 Y131.317 E-.29116
G1 X114.995 Y131.315 E-.29227
G1 X114.996 Y130.851 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.197 Y130.601 Z11 F30000
G1 Z10.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591851
G1 F3218
G1 X136.321 Y130.658 E.766
G1 X136.783 Y130.647 E.02066
G1 X137.657 Y130.517 F30000
; LINE_WIDTH: 0.107467
G1 F3218
G2 X137.81 Y130.426 I-.031 J-.226 E.00096
G1 X138.22 Y130.308 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.272 Y130.35 E.00204
G1 X138.952 Y130.36 E.0209
G1 X139.083 Y130.54 E.00684
G1 X139.077 Y132.511 E.06054
G1 X142.109 Y132.519 E.09315
G1 X142.116 Y129.749 E.08509
G1 X142.076 Y129.464 E.00885
G1 X141.798 Y129.429 E.00861
G1 X138.757 Y129.421 E.09343
G3 X138.261 Y130.265 I-1.981 J-.595 E.03037
G1 X138.934 Y129.979 F30000
G1 F3218
G1 X139.067 Y130.001 E.00414
G1 X139.46 Y130.541 E.02053
G1 X139.455 Y132.134 E.04895
G1 X141.733 Y132.141 E.06998
G1 X141.739 Y129.806 E.07173
G1 X139.03 Y129.799 E.08325
G1 X138.962 Y129.926 E.00443
G1 X139.571 Y130.177 F30000
G1 F3218
G1 X139.837 Y130.542 E.01387
G1 X139.834 Y131.758 E.03737
G1 X141.357 Y131.762 E.0468
G1 X141.361 Y130.182 E.04856
G1 X139.631 Y130.178 E.05315
G1 X140.214 Y130.556 F30000
G1 F3218
G1 X140.212 Y131.382 E.02539
G1 X140.981 Y131.384 E.02363
G1 X140.983 Y130.558 E.02539
G1 X140.274 Y130.556 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 10.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.983 Y130.558 E-.26947
G1 X140.981 Y131.384 E-.31396
G1 X140.516 Y131.383 E-.17658
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 54/118
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change
G17
G3 Z11 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.289 Y130.739
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.283 Y132.898 E.07161
G1 X113.468 Y132.888 E.12657
G1 X113.476 Y129.677 E.10649
G3 X113.598 Y129.131 I.854 J-.096 E.0189
G3 X113.908 Y129.025 I.362 J.553 E.01098
G1 X117.518 Y129.026 E.11975
G2 X117.87 Y129.854 I2.414 J-.537 E.03003
G2 X118.846 Y130.491 I1.522 J-1.269 E.03923
G1 X119.012 Y130.522 E.00561
G1 X118.991 Y130.744 E.00739
G1 X117.349 Y130.739 E.05447
; WIPE_START
G1 F16213.044
G1 X117.288 Y132.738 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.875 Y131.902 Z11.2 F30000
G1 X136.968 Y130.57 Z11.2
G1 Z10.8
G1 E.8 F1800
G1 F3230
G2 X137.838 Y130.192 I-.412 J-2.139 E.03172
G2 X138.434 Y129.23 I-1.352 J-1.504 E.03803
G1 X138.47 Y129.081 E.00508
G1 X141.889 Y129.091 E.11341
G3 X142.389 Y129.208 I.091 J.738 E.01741
G3 X142.5 Y129.553 I-.666 J.404 E.01212
G1 X142.5 Y132.965 E.1132
G1 X138.684 Y132.955 E.12657
G1 X138.69 Y130.796 E.07161
G1 X136.988 Y130.792 E.05646
G1 X136.973 Y130.63 E.0054
; WIPE_START
G1 F16213.044
G1 X137.134 Y130.539 E-.07017
G1 X137.505 Y130.402 E-.15019
G1 X137.838 Y130.192 E-.14966
G1 X138.114 Y129.908 E-.15032
G1 X138.317 Y129.564 E-.15197
G1 X138.393 Y129.346 E-.0877
; WIPE_END
G1 E-.04 F1800
G1 X130.789 Y130.002 Z11.2 F30000
G1 X117.68 Y131.132 Z11.2
G1 Z10.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.674 Y133.279 E.06596
G1 X117.674 Y133.291 E.00038
G1 X113.074 Y133.279 E.14134
G1 X113.074 Y133.267 E.00038
G1 X113.084 Y129.668 E.11058
G3 X113.315 Y128.857 I1.167 J-.106 E.02652
G3 X114.099 Y128.625 I.672 J.832 E.02576
G1 X117.86 Y128.635 E.11557
G2 X118.395 Y129.834 I1.697 J-.038 E.04144
G2 X119.291 Y130.176 I1.102 J-1.545 E.0298
G1 X119.665 Y130.197 E.0115
G1 X136.317 Y130.241 E.51168
G2 X137.33 Y130.049 I.036 J-2.578 E.03191
G2 X138.058 Y129.119 I-.646 J-1.254 E.03742
G2 X138.13 Y128.689 I-3.341 J-.786 E.01343
G1 X141.899 Y128.699 E.11581
G3 X142.674 Y128.935 I.1 J1.062 E.02552
G3 X142.9 Y129.747 I-.94 J.7 E.02652
G1 X142.891 Y133.346 E.11058
G1 X142.891 Y133.358 E.00038
G1 X138.291 Y133.346 E.14134
G1 X138.291 Y133.334 E.00038
G1 X138.297 Y131.187 E.06596
G1 X138.256 Y131.187 E.00126
G1 X117.74 Y131.132 E.6304
M204 S10000
G1 X118.171 Y130.427 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107458
G1 F3230
G2 X118.323 Y130.519 I.185 J-.133 E.00096
G1 X117.738 Y130.282 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.544 Y130.073 E.00877
G1 X117.301 Y129.648 E.01505
G1 X117.229 Y129.417 E.00742
G1 X114.13 Y129.409 E.09523
G1 X113.911 Y129.443 E.00679
G1 X113.868 Y129.729 E.0089
G1 X113.861 Y132.497 E.08505
G1 X116.892 Y132.505 E.09315
G1 X116.897 Y130.535 E.06054
G1 X117.039 Y130.352 E.0071
G1 X117.732 Y130.338 E.02129
G1 X117.049 Y129.974 F30000
G1 F3230
G1 X116.954 Y129.793 E.00627
G1 X114.245 Y129.786 E.08325
G1 X114.239 Y132.121 E.07173
G1 X116.516 Y132.127 E.06998
G1 X116.52 Y130.534 E.04895
G1 X116.916 Y129.995 E.02053
G1 X116.99 Y129.984 E.00229
G1 X116.411 Y130.169 F30000
G1 F3230
G1 X114.621 Y130.164 E.05499
G1 X114.617 Y131.745 E.04856
G1 X116.14 Y131.749 E.0468
G1 X116.143 Y130.533 E.03737
G1 X116.375 Y130.217 E.01202
G1 X115.766 Y130.544 F30000
G1 F3230
G1 X114.997 Y130.542 E.02363
G1 X114.995 Y131.369 E.02539
G1 X115.764 Y131.371 E.02363
G1 X115.766 Y130.604 E.02354
; WIPE_START
G1 F15000
G1 X115.764 Y131.371 E-.29116
G1 X114.995 Y131.369 E-.29227
M73 P70 R5
G1 X114.996 Y130.904 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.197 Y130.654 Z11.2 F30000
G1 Z10.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591871
G1 F3230
G1 X119.658 Y130.667 E.02066
G1 X136.783 Y130.701 E.76602
G1 X137.657 Y130.57 F30000
; LINE_WIDTH: 0.107434
G1 F3230
G2 X137.809 Y130.479 I-.031 J-.225 E.00096
G1 X138.219 Y130.362 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.271 Y130.403 E.00202
G1 X138.951 Y130.413 E.02092
G1 X139.082 Y130.594 E.00684
G1 X139.077 Y132.564 E.06054
G1 X142.109 Y132.572 E.09315
G1 X142.116 Y129.803 E.08509
G1 X142.076 Y129.517 E.00885
G1 X141.798 Y129.482 E.00861
G1 X138.757 Y129.474 E.09343
G3 X138.261 Y130.319 I-1.981 J-.595 E.03038
G1 X138.934 Y130.032 F30000
G1 F3230
G1 X139.067 Y130.054 E.00414
G1 X139.46 Y130.595 E.02053
G1 X139.455 Y132.188 E.04895
G1 X141.733 Y132.194 E.06998
G1 X141.739 Y129.859 E.07173
G1 X139.029 Y129.852 E.08325
G1 X138.962 Y129.979 E.00443
G1 X139.571 Y130.231 F30000
G1 F3230
G1 X139.837 Y130.596 E.01387
G1 X139.833 Y131.812 E.03737
G1 X141.357 Y131.816 E.0468
G1 X141.361 Y130.235 E.04856
G1 X139.631 Y130.231 E.05315
G1 X140.214 Y130.609 F30000
G1 F3230
G1 X140.211 Y131.436 E.02539
G1 X140.981 Y131.438 E.02363
G1 X140.983 Y130.611 E.02539
G1 X140.274 Y130.61 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 11
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.983 Y130.611 E-.26947
G1 X140.981 Y131.438 E-.31396
G1 X140.516 Y131.436 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 55/118
; update layer progress
M73 L55
M991 S0 P54 ;notify layer change
G17
G3 Z11.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.289 Y130.792
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.283 Y132.951 E.07161
G1 X113.467 Y132.941 E.12657
G1 X113.476 Y129.731 E.1065
G3 X113.598 Y129.185 I.854 J-.096 E.0189
G3 X113.908 Y129.079 I.362 J.552 E.01099
G1 X117.518 Y129.079 E.11975
G2 X117.87 Y129.907 I2.411 J-.536 E.03003
G2 X118.846 Y130.544 I1.522 J-1.268 E.03923
G1 X119.012 Y130.575 E.00561
G1 X118.991 Y130.797 E.00739
G1 X117.349 Y130.793 E.05447
; WIPE_START
G1 F16213.044
G1 X117.288 Y132.792 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.874 Y131.956 Z11.4 F30000
G1 X136.968 Y130.623 Z11.4
G1 Z11
G1 E.8 F1800
G1 F3230
G2 X137.838 Y130.245 I-.413 J-2.14 E.03172
G2 X138.434 Y129.284 I-1.352 J-1.504 E.03802
G1 X138.47 Y129.135 E.00509
G1 X141.889 Y129.144 E.11341
G3 X142.389 Y129.261 I.091 J.738 E.01742
G3 X142.5 Y129.606 I-.666 J.404 E.01211
G1 X142.5 Y133.018 E.1132
G1 X138.684 Y133.008 E.12657
G1 X138.69 Y130.849 E.07161
G1 X136.988 Y130.845 E.05646
G1 X136.973 Y130.683 E.00539
; WIPE_START
G1 F16213.044
G1 X137.134 Y130.592 E-.07016
G1 X137.505 Y130.456 E-.1502
G1 X137.838 Y130.245 E-.14965
G1 X138.113 Y129.961 E-.15034
G1 X138.317 Y129.617 E-.15199
G1 X138.393 Y129.399 E-.08766
; WIPE_END
G1 E-.04 F1800
G1 X130.789 Y130.055 Z11.4 F30000
G1 X117.68 Y131.185 Z11.4
G1 Z11
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.674 Y133.332 E.06596
G1 X117.674 Y133.344 E.00038
G1 X113.074 Y133.332 E.14134
G1 X113.074 Y133.32 E.00038
G1 X113.084 Y129.721 E.11058
G3 X113.315 Y128.91 I1.167 J-.106 E.02652
G3 X114.099 Y128.678 I.673 J.833 E.02579
G1 X117.86 Y128.688 E.11554
G2 X118.395 Y129.888 I1.697 J-.038 E.04144
G2 X119.291 Y130.229 I1.102 J-1.545 E.0298
G1 X119.664 Y130.25 E.0115
G1 X136.317 Y130.294 E.51168
G2 X137.33 Y130.102 I.036 J-2.578 E.03191
G2 X138.072 Y129.112 I-.605 J-1.226 E.03943
G2 X138.13 Y128.742 I-1.349 J-.402 E.01156
G1 X141.899 Y128.752 E.11581
G3 X142.674 Y128.988 I.1 J1.061 E.02552
G3 X142.9 Y129.8 I-.94 J.7 E.02651
G1 X142.891 Y133.399 E.11058
G1 X142.891 Y133.411 E.00038
G1 X138.291 Y133.399 E.14134
G1 X138.291 Y133.387 E.00038
G1 X138.297 Y131.24 E.06596
G1 X138.256 Y131.24 E.00126
G1 X117.74 Y131.186 E.6304
M204 S10000
G1 X118.171 Y130.48 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10744
G1 F3230
G2 X118.323 Y130.572 I.185 J-.133 E.00096
G1 X117.738 Y130.336 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.544 Y130.126 E.00879
G1 X117.301 Y129.701 E.01506
G1 X117.229 Y129.47 E.00741
G1 X114.13 Y129.462 E.0952
G1 X113.911 Y129.496 E.00682
G1 X113.868 Y129.782 E.0089
G1 X113.861 Y132.55 E.08505
G1 X116.892 Y132.558 E.09315
G1 X116.897 Y130.588 E.06054
G1 X117.039 Y130.406 E.0071
G1 X117.732 Y130.391 E.02129
G1 X117.049 Y130.027 F30000
G1 F3230
G1 X116.954 Y129.847 E.00627
G1 X114.245 Y129.839 E.08325
G1 X114.239 Y132.174 E.07173
G1 X116.516 Y132.18 E.06998
G1 X116.52 Y130.587 E.04895
G1 X116.916 Y130.049 E.02053
G1 X116.99 Y130.037 E.00229
G1 X116.411 Y130.222 F30000
G1 F3230
G1 X114.621 Y130.218 E.05499
G1 X114.617 Y131.798 E.04856
G1 X116.14 Y131.802 E.0468
G1 X116.143 Y130.586 E.03737
G1 X116.375 Y130.271 E.01202
G1 X115.766 Y130.598 F30000
G1 F3230
G1 X114.997 Y130.596 E.02363
G1 X114.995 Y131.422 E.02539
G1 X115.764 Y131.424 E.02363
G1 X115.766 Y130.658 E.02354
; WIPE_START
G1 F15000
G1 X115.764 Y131.424 E-.29116
G1 X114.995 Y131.422 E-.29226
G1 X114.996 Y130.957 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.196 Y130.707 Z11.4 F30000
G1 Z11
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.658 Y130.72 E.02066
G1 X136.783 Y130.754 E.76601
G1 X137.657 Y130.624 F30000
; LINE_WIDTH: 0.107452
G1 F3230
G2 X137.809 Y130.532 I-.031 J-.225 E.00096
G1 X138.219 Y130.415 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.271 Y130.456 E.00203
G1 X138.951 Y130.467 E.02091
G1 X139.082 Y130.647 E.00684
G1 X139.077 Y132.617 E.06054
G1 X142.109 Y132.625 E.09315
G1 X142.116 Y129.856 E.08509
G1 X142.076 Y129.57 E.00885
G1 X141.798 Y129.536 E.00861
G1 X138.757 Y129.528 E.09344
G3 X138.261 Y130.372 I-1.98 J-.595 E.03037
G1 X138.934 Y130.086 F30000
G1 F3230
G1 X139.066 Y130.108 E.00414
G1 X139.459 Y130.648 E.02053
G1 X139.455 Y132.241 E.04895
G1 X141.733 Y132.247 E.06998
G1 X141.739 Y129.913 E.07173
G1 X139.029 Y129.905 E.08325
G1 X138.962 Y130.033 E.00443
G1 X139.571 Y130.284 F30000
G1 F3230
G1 X139.836 Y130.649 E.01387
G1 X139.833 Y131.865 E.03737
G1 X141.357 Y131.869 E.0468
G1 X141.361 Y130.289 E.04856
G1 X139.631 Y130.284 E.05315
G1 X140.214 Y130.663 F30000
G1 F3230
G1 X140.211 Y131.489 E.02539
G1 X140.98 Y131.491 E.02363
G1 X140.983 Y130.665 E.02539
G1 X140.274 Y130.663 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 11.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.983 Y130.665 E-.26947
G1 X140.98 Y131.491 E-.31396
G1 X140.516 Y131.49 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 56/118
; update layer progress
M73 L56
M991 S0 P55 ;notify layer change
G17
G3 Z11.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.289 Y130.846
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.283 Y133.004 E.07161
G1 X113.467 Y132.994 E.12657
G1 X113.476 Y129.784 E.1065
G3 X113.598 Y129.238 I.854 J-.096 E.0189
G3 X113.908 Y129.132 I.362 J.553 E.01098
G1 X117.518 Y129.132 E.11975
G2 X117.87 Y129.961 I2.411 J-.536 E.03002
G2 X118.846 Y130.597 I1.523 J-1.268 E.03923
G1 X119.012 Y130.629 E.00561
G1 X118.991 Y130.85 E.00739
G1 X117.349 Y130.846 E.05447
; WIPE_START
G1 F16213.044
G1 X117.288 Y132.845 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.874 Y132.009 Z11.6 F30000
G1 X136.968 Y130.676 Z11.6
G1 Z11.2
G1 E.8 F1800
G1 F3218
G2 X137.838 Y130.298 I-.413 J-2.14 E.03172
G2 X138.433 Y129.338 I-1.352 J-1.504 E.03801
G1 X138.47 Y129.188 E.0051
G1 X141.889 Y129.197 E.11341
G3 X142.389 Y129.314 I.091 J.738 E.01741
G3 X142.5 Y129.659 I-.666 J.404 E.01212
G1 X142.5 Y133.071 E.1132
G1 X138.684 Y133.061 E.12657
G1 X138.69 Y130.903 E.07161
G1 X136.988 Y130.898 E.05646
G1 X136.973 Y130.736 E.00539
; WIPE_START
G1 F16213.044
G1 X137.134 Y130.646 E-.07012
G1 X137.505 Y130.509 E-.15019
G1 X137.838 Y130.298 E-.14966
G1 X138.113 Y130.015 E-.15033
G1 X138.317 Y129.67 E-.15207
G1 X138.393 Y129.453 E-.08761
; WIPE_END
G1 E-.04 F1800
G1 X130.789 Y130.108 Z11.6 F30000
G1 X117.68 Y131.239 Z11.6
G1 Z11.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.674 Y133.385 E.06596
G1 X117.674 Y133.398 E.00038
G1 X113.074 Y133.385 E.14134
G1 X113.074 Y133.373 E.00038
G1 X113.084 Y129.774 E.11058
G3 X113.315 Y128.963 I1.167 J-.106 E.02652
G3 X114.1 Y128.731 I.673 J.834 E.02582
G1 X117.859 Y128.741 E.11551
G2 X118.394 Y129.941 I1.697 J-.038 E.04144
G2 X119.291 Y130.282 I1.102 J-1.545 E.0298
G1 X119.664 Y130.303 E.0115
G1 X136.317 Y130.348 E.51168
G2 X137.33 Y130.155 I.036 J-2.578 E.03191
G2 X138.057 Y129.226 I-.645 J-1.254 E.0374
G2 X138.13 Y128.795 I-3.294 J-.78 E.01345
G1 X141.899 Y128.805 E.11581
G3 X142.673 Y129.041 I.1 J1.062 E.02552
G3 X142.9 Y129.854 I-.94 J.7 E.02651
G1 X142.891 Y133.452 E.11058
G1 X142.891 Y133.465 E.00038
G1 X138.291 Y133.452 E.14134
G1 X138.291 Y133.44 E.00038
G1 X138.296 Y131.294 E.06596
G1 X138.255 Y131.293 E.00126
G1 X117.74 Y131.239 E.6304
M204 S10000
G1 X118.171 Y130.533 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107464
G1 F3218
G2 X118.323 Y130.625 I.185 J-.133 E.00096
G1 X117.738 Y130.389 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.543 Y130.179 E.00877
G1 X117.3 Y129.754 E.01506
G1 X117.229 Y129.524 E.00741
G1 X114.131 Y129.515 E.09517
G1 X113.911 Y129.549 E.00685
G1 X113.868 Y129.835 E.0089
G1 X113.86 Y132.603 E.08505
G1 X116.892 Y132.611 E.09315
G1 X116.897 Y130.641 E.06054
G1 X117.039 Y130.459 E.0071
G1 X117.732 Y130.444 E.02129
G1 X117.049 Y130.081 F30000
G1 F3218
G1 X116.954 Y129.9 E.00627
G1 X114.245 Y129.893 E.08326
G1 X114.238 Y132.227 E.07173
G1 X116.516 Y132.233 E.06998
G1 X116.52 Y130.64 E.04895
G1 X116.916 Y130.102 E.02053
G1 X116.99 Y130.09 E.00229
G1 X116.41 Y130.276 F30000
G1 F3218
G1 X114.621 Y130.271 E.05499
G1 X114.617 Y131.851 E.04856
G1 X116.14 Y131.855 E.0468
G1 X116.143 Y130.639 E.03737
G1 X116.375 Y130.324 E.01202
G1 X115.766 Y130.651 F30000
G1 F3218
G1 X114.997 Y130.649 E.02363
G1 X114.995 Y131.475 E.02539
G1 X115.764 Y131.477 E.02363
G1 X115.766 Y130.711 E.02354
; WIPE_START
G1 F15000
G1 X115.764 Y131.477 E-.29116
G1 X114.995 Y131.475 E-.29226
G1 X114.996 Y131.01 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.196 Y130.76 Z11.6 F30000
G1 Z11.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591851
G1 F3218
G1 X136.321 Y130.818 E.766
G1 X136.783 Y130.807 E.02066
G1 X137.656 Y130.677 F30000
; LINE_WIDTH: 0.10747
G1 F3218
G2 X137.809 Y130.585 I-.031 J-.226 E.00096
G1 X138.219 Y130.468 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.271 Y130.509 E.00203
G1 X138.951 Y130.52 E.0209
G1 X139.082 Y130.7 E.00684
G1 X139.077 Y132.67 E.06054
G1 X142.109 Y132.678 E.09315
G1 X142.116 Y129.909 E.08509
G1 X142.075 Y129.624 E.00885
G1 X141.797 Y129.589 E.00861
G1 X138.757 Y129.581 E.09344
G3 X138.261 Y130.425 I-1.981 J-.595 E.03037
G1 X138.933 Y130.139 F30000
G1 F3218
G1 X139.066 Y130.161 E.00414
M73 P71 R5
G1 X139.459 Y130.701 E.02053
G1 X139.455 Y132.294 E.04895
G1 X141.732 Y132.3 E.06998
G1 X141.739 Y129.966 E.07173
G1 X139.029 Y129.959 E.08325
G1 X138.961 Y130.086 E.00443
G1 X139.571 Y130.337 F30000
G1 F3218
G1 X139.836 Y130.702 E.01387
G1 X139.833 Y131.918 E.03737
G1 X141.356 Y131.922 E.0468
G1 X141.361 Y130.342 E.04856
G1 X139.631 Y130.337 E.05315
G1 X140.213 Y130.716 F30000
G1 F3218
G1 X140.211 Y131.542 E.02539
G1 X140.98 Y131.544 E.02363
G1 X140.983 Y130.718 E.02539
G1 X140.273 Y130.716 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 11.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.983 Y130.718 E-.26947
G1 X140.98 Y131.544 E-.31396
G1 X140.516 Y131.543 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 57/118
; update layer progress
M73 L57
M991 S0 P56 ;notify layer change
G17
G3 Z11.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.289 Y130.899
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.283 Y133.058 E.07161
G1 X113.467 Y133.048 E.12657
G1 X113.476 Y129.837 E.1065
G3 X113.597 Y129.291 I.854 J-.096 E.0189
G3 X113.907 Y129.185 I.362 J.553 E.01098
G1 X117.518 Y129.186 E.11976
G2 X117.87 Y130.014 I2.41 J-.535 E.03002
G2 X118.846 Y130.65 I1.523 J-1.269 E.03923
G1 X119.012 Y130.682 E.00561
G1 X118.991 Y130.903 E.00739
G1 X117.349 Y130.899 E.05447
; WIPE_START
G1 F16213.044
G1 X117.288 Y132.898 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.874 Y132.062 Z11.8 F30000
G1 X136.967 Y130.73 Z11.8
G1 Z11.4
G1 E.8 F1800
G1 F3230
G2 X137.837 Y130.352 I-.413 J-2.14 E.03172
G2 X138.433 Y129.391 I-1.352 J-1.504 E.038
G1 X138.47 Y129.241 E.00512
G1 X141.889 Y129.25 E.11341
G3 X142.389 Y129.368 I.091 J.738 E.01741
G3 X142.5 Y129.712 I-.666 J.404 E.01211
G1 X142.499 Y133.125 E.1132
G1 X138.684 Y133.115 E.12657
G1 X138.689 Y130.956 E.07161
G1 X136.987 Y130.951 E.05646
G1 X136.973 Y130.789 E.00539
; WIPE_START
G1 F16213.044
G1 X137.134 Y130.699 E-.07016
G1 X137.505 Y130.562 E-.15018
G1 X137.837 Y130.352 E-.14966
G1 X138.113 Y130.068 E-.15034
G1 X138.317 Y129.723 E-.15209
G1 X138.393 Y129.506 E-.08756
; WIPE_END
G1 E-.04 F1800
G1 X130.789 Y130.162 Z11.8 F30000
G1 X117.68 Y131.292 Z11.8
G1 Z11.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.674 Y133.439 E.06596
G1 X117.674 Y133.451 E.00038
G1 X113.074 Y133.439 E.14134
G1 X113.074 Y133.426 E.00038
G1 X113.084 Y129.828 E.11058
G3 X113.315 Y129.016 I1.167 J-.106 E.02652
G3 X114.101 Y128.784 I.673 J.834 E.02586
G1 X117.859 Y128.794 E.11547
G2 X118.394 Y129.994 I1.696 J-.037 E.04144
G2 X119.291 Y130.336 I1.102 J-1.545 E.0298
G1 X119.664 Y130.357 E.0115
G1 X136.317 Y130.401 E.51168
G2 X137.33 Y130.209 I.036 J-2.578 E.03191
G2 X138.072 Y129.218 I-.605 J-1.226 E.03947
G2 X138.13 Y128.848 I-1.343 J-.4 E.01153
G1 X141.899 Y128.858 E.11581
G3 X142.673 Y129.094 I.1 J1.062 E.02552
G3 X142.9 Y129.907 I-.94 J.7 E.02651
G1 X142.89 Y133.506 E.11058
G1 X142.89 Y133.518 E.00038
G1 X138.291 Y133.506 E.14134
G1 X138.291 Y133.493 E.00038
G1 X138.296 Y131.347 E.06596
G1 X138.255 Y131.347 E.00126
G1 X117.74 Y131.292 E.6304
M204 S10000
G1 X118.171 Y130.586 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10745
G1 F3230
G2 X118.323 Y130.679 I.185 J-.133 E.00096
G1 X117.738 Y130.442 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.543 Y130.233 E.00879
G1 X117.3 Y129.807 E.01506
G1 X117.229 Y129.577 E.0074
G1 X114.132 Y129.569 E.09515
G1 X113.911 Y129.602 E.00688
G1 X113.868 Y129.889 E.00889
G1 X113.86 Y132.657 E.08505
G1 X116.892 Y132.665 E.09315
G1 X116.897 Y130.694 E.06054
G1 X117.039 Y130.512 E.00709
G1 X117.732 Y130.497 E.0213
G1 X117.049 Y130.134 F30000
G1 F3230
G1 X116.954 Y129.953 E.00627
G1 X114.245 Y129.946 E.08326
G1 X114.238 Y132.28 E.07173
G1 X116.516 Y132.287 E.06998
G1 X116.52 Y130.693 E.04895
G1 X116.916 Y130.155 E.02053
G1 X116.99 Y130.143 E.00229
G1 X116.41 Y130.329 F30000
G1 F3230
G1 X114.621 Y130.324 E.05499
G1 X114.616 Y131.904 E.04856
G1 X116.14 Y131.908 E.0468
G1 X116.143 Y130.692 E.03737
G1 X116.375 Y130.377 E.01202
G1 X115.766 Y130.704 F30000
G1 F3230
G1 X114.997 Y130.702 E.02363
G1 X114.994 Y131.528 E.02539
G1 X115.764 Y131.53 E.02363
G1 X115.766 Y130.764 E.02354
; WIPE_START
G1 F15000
G1 X115.764 Y131.53 E-.29116
G1 X114.994 Y131.528 E-.29226
G1 X114.996 Y131.064 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.196 Y130.814 Z11.8 F30000
G1 Z11.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.658 Y130.827 E.02066
G1 X136.782 Y130.86 E.76601
G1 X137.656 Y130.73 F30000
; LINE_WIDTH: 0.107455
G1 F3230
G2 X137.809 Y130.639 I-.031 J-.225 E.00096
G1 X138.219 Y130.522 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.271 Y130.563 E.00203
G1 X138.951 Y130.573 E.02091
G1 X139.082 Y130.753 E.00684
G1 X139.077 Y132.724 E.06054
G1 X142.108 Y132.732 E.09315
G1 X142.116 Y129.962 E.08509
G1 X142.075 Y129.677 E.00885
G1 X141.797 Y129.642 E.00861
G1 X138.756 Y129.634 E.09344
G3 X138.261 Y130.478 I-1.982 J-.595 E.03037
G1 X138.933 Y130.192 F30000
G1 F3230
G1 X139.066 Y130.214 E.00414
G1 X139.459 Y130.754 E.02053
G1 X139.455 Y132.348 E.04895
G1 X141.732 Y132.354 E.06998
G1 X141.739 Y130.019 E.07173
G1 X139.029 Y130.012 E.08326
G1 X138.961 Y130.139 E.00443
G1 X139.571 Y130.39 F30000
G1 F3230
G1 X139.836 Y130.755 E.01387
G1 X139.833 Y131.971 E.03737
G1 X141.356 Y131.975 E.0468
G1 X141.36 Y130.395 E.04856
G1 X139.631 Y130.391 E.05315
G1 X140.213 Y130.769 F30000
G1 F3230
G1 X140.211 Y131.595 E.02539
G1 X140.98 Y131.597 E.02363
G1 X140.982 Y130.771 E.02539
G1 X140.273 Y130.769 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 11.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X140.982 Y130.771 E-.26947
G1 X140.98 Y131.597 E-.31396
G1 X140.516 Y131.596 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 58/118
; update layer progress
M73 L58
M991 S0 P57 ;notify layer change
G17
G3 Z11.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.288 Y130.952
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.283 Y133.111 E.07161
G1 X113.467 Y133.101 E.12657
G1 X113.476 Y129.89 E.10649
G3 X113.597 Y129.344 I.854 J-.096 E.0189
G3 X113.907 Y129.238 I.362 J.552 E.01098
G1 X117.517 Y129.239 E.11976
G2 X117.869 Y130.067 I2.408 J-.534 E.03002
G2 X118.845 Y130.704 I1.523 J-1.269 E.03923
G1 X119.012 Y130.735 E.00561
G1 X118.99 Y130.957 E.00739
G1 X117.348 Y130.952 E.05447
; WIPE_START
G1 F16213.044
G1 X117.288 Y132.951 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.874 Y132.115 Z12 F30000
G1 X136.967 Y130.783 Z12
G1 Z11.6
G1 E.8 F1800
G1 F3230
G2 X137.837 Y130.405 I-.413 J-2.14 E.03172
G2 X138.433 Y129.445 I-1.352 J-1.504 E.03799
G1 X138.469 Y129.294 E.00513
G1 X141.888 Y129.304 E.11341
G3 X142.389 Y129.421 I.091 J.738 E.01741
G3 X142.499 Y129.765 I-.666 J.404 E.01211
G1 X142.499 Y133.178 E.1132
G1 X138.684 Y133.168 E.12657
G1 X138.689 Y131.009 E.07161
G1 X136.987 Y131.005 E.05646
G1 X136.973 Y130.843 E.00539
; WIPE_START
G1 F16213.044
G1 X137.134 Y130.752 E-.07015
G1 X137.504 Y130.615 E-.1502
G1 X137.837 Y130.405 E-.14966
G1 X138.113 Y130.121 E-.15035
G1 X138.317 Y129.776 E-.1521
G1 X138.393 Y129.559 E-.08754
; WIPE_END
G1 E-.04 F1800
G1 X130.789 Y130.215 Z12 F30000
G1 X117.679 Y131.345 Z12
G1 Z11.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.674 Y133.492 E.06596
G1 X117.674 Y133.504 E.00038
G1 X113.074 Y133.492 E.14134
G1 X113.074 Y133.48 E.00038
G1 X113.083 Y129.881 E.11058
G3 X113.315 Y129.069 I1.167 J-.106 E.02652
G3 X114.102 Y128.838 I.674 J.835 E.02589
G1 X117.859 Y128.848 E.11543
G2 X118.394 Y130.047 I1.696 J-.037 E.04144
G2 X119.29 Y130.389 I1.102 J-1.545 E.02979
G1 X119.664 Y130.41 E.0115
G1 X136.316 Y130.454 E.51168
G2 X137.33 Y130.262 I.036 J-2.578 E.03191
G2 X138.057 Y129.333 I-.645 J-1.254 E.03737
G2 X138.13 Y128.902 I-3.251 J-.774 E.01347
G1 X141.899 Y128.912 E.11581
G3 X142.673 Y129.148 I.1 J1.062 E.02552
G3 X142.9 Y129.96 I-.94 J.7 E.02651
G1 X142.89 Y133.559 E.11058
G1 X142.89 Y133.571 E.00038
G1 X138.29 Y133.559 E.14134
G1 X138.291 Y133.547 E.00038
G1 X138.296 Y131.4 E.06596
G1 X138.255 Y131.4 E.00126
G1 X117.739 Y131.345 E.6304
M204 S10000
G1 X118.171 Y130.64 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107445
G1 F3230
G2 X118.323 Y130.732 I.185 J-.133 E.00096
G1 X117.737 Y130.496 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.543 Y130.286 E.00879
G1 X117.3 Y129.86 E.01507
G1 X117.228 Y129.63 E.0074
G1 X114.133 Y129.622 E.09511
G1 X113.911 Y129.656 E.00691
G1 X113.867 Y129.942 E.00889
G1 X113.86 Y132.71 E.08505
G1 X116.892 Y132.718 E.09315
G1 X116.897 Y130.748 E.06054
G1 X117.039 Y130.565 E.00709
G1 X117.732 Y130.551 E.0213
G1 X117.049 Y130.187 F30000
G1 F3230
G1 X116.954 Y130.006 E.00627
G1 X114.244 Y129.999 E.08326
G1 X114.238 Y132.334 E.07173
G1 X116.516 Y132.34 E.06998
G1 X116.52 Y130.747 E.04895
G1 X116.916 Y130.208 E.02053
G1 X116.99 Y130.197 E.00229
G1 X116.41 Y130.382 F30000
G1 F3230
G1 X114.62 Y130.377 E.05499
G1 X114.616 Y131.958 E.04856
G1 X116.139 Y131.962 E.0468
G1 X116.143 Y130.746 E.03737
G1 X116.375 Y130.43 E.01202
G1 X115.766 Y130.757 F30000
G1 F3230
G1 X114.996 Y130.755 E.02363
G1 X114.994 Y131.582 E.02539
G1 X115.763 Y131.584 E.02363
G1 X115.765 Y130.817 E.02354
; WIPE_START
G1 F15000
G1 X115.763 Y131.584 E-.29116
G1 X114.994 Y131.582 E-.29227
G1 X114.996 Y131.117 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.196 Y130.867 Z12 F30000
G1 Z11.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.658 Y130.88 E.02066
G1 X136.782 Y130.914 E.76601
G1 X137.656 Y130.783 F30000
; LINE_WIDTH: 0.107453
G1 F3230
G2 X137.809 Y130.692 I-.031 J-.226 E.00096
G1 X138.219 Y130.575 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.27 Y130.616 E.00203
G1 X138.951 Y130.627 E.02091
G1 X139.082 Y130.807 E.00684
G1 X139.077 Y132.777 E.06054
G1 X142.108 Y132.785 E.09315
G1 X142.116 Y130.016 E.08509
G1 X142.075 Y129.73 E.00885
G1 X141.797 Y129.695 E.00861
G1 X138.756 Y129.687 E.09344
G3 X138.261 Y130.532 I-1.982 J-.595 E.03038
G1 X138.933 Y130.245 F30000
G1 F3230
G1 X139.066 Y130.267 E.00414
G1 X139.459 Y130.808 E.02053
G1 X139.455 Y132.401 E.04895
G1 X141.732 Y132.407 E.06998
G1 X141.738 Y130.072 E.07173
G1 X139.029 Y130.065 E.08326
G1 X138.961 Y130.192 E.00443
G1 X139.57 Y130.444 F30000
G1 F3230
G1 X139.836 Y130.809 E.01387
G1 X139.833 Y132.025 E.03737
G1 X141.356 Y132.029 E.0468
G1 X141.36 Y130.448 E.04856
G1 X139.63 Y130.444 E.05315
G1 X140.213 Y130.822 F30000
G1 F3230
G1 X140.211 Y131.649 E.02539
G1 X140.98 Y131.651 E.02363
G1 X140.982 Y130.824 E.02539
G1 X140.273 Y130.823 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 11.8
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P71 R4
G1 F15000
G1 X140.982 Y130.824 E-.26947
G1 X140.98 Y131.651 E-.31396
G1 X140.515 Y131.649 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 59/118
; update layer progress
M73 L59
M991 S0 P58 ;notify layer change
G17
G3 Z12 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.288 Y131.005
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.283 Y133.164 E.07161
G1 X113.467 Y133.154 E.12657
G1 X113.475 Y129.944 E.10649
G3 X113.597 Y129.398 I.854 J-.096 E.0189
G3 X113.907 Y129.292 I.362 J.553 E.01097
G1 X117.517 Y129.292 E.11976
G2 X117.869 Y130.12 I2.406 J-.533 E.03002
G2 X118.845 Y130.757 I1.523 J-1.269 E.03923
G1 X119.011 Y130.788 E.00561
G1 X118.99 Y131.01 E.00739
G1 X117.348 Y131.006 E.05447
; WIPE_START
G1 F16213.044
M73 P72 R4
G1 X117.287 Y133.005 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.874 Y132.169 Z12.2 F30000
G1 X136.967 Y130.836 Z12.2
G1 Z11.8
G1 E.8 F1800
G1 F3218
G2 X137.837 Y130.458 I-.413 J-2.14 E.03172
G2 X138.433 Y129.498 I-1.352 J-1.504 E.03798
G1 X138.469 Y129.348 E.00513
G1 X141.888 Y129.357 E.11342
G3 X142.389 Y129.474 I.091 J.738 E.01742
G3 X142.499 Y129.819 I-.666 J.403 E.01211
G1 X142.499 Y133.231 E.1132
G1 X138.683 Y133.221 E.12657
G1 X138.689 Y131.062 E.07161
G1 X136.987 Y131.058 E.05646
G1 X136.973 Y130.896 E.00539
; WIPE_START
G1 F16213.044
G1 X137.133 Y130.805 E-.07014
G1 X137.504 Y130.669 E-.15021
G1 X137.837 Y130.458 E-.14964
G1 X138.113 Y130.174 E-.15037
G1 X138.317 Y129.83 E-.15215
G1 X138.393 Y129.612 E-.08748
; WIPE_END
G1 E-.04 F1800
G1 X130.789 Y130.268 Z12.2 F30000
G1 X117.679 Y131.399 Z12.2
G1 Z11.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.674 Y133.545 E.06596
G1 X117.674 Y133.557 E.00038
G1 X113.074 Y133.545 E.14134
G1 X113.074 Y133.533 E.00038
G1 X113.083 Y129.934 E.11058
G3 X113.314 Y129.123 I1.167 J-.106 E.02651
G3 X114.103 Y128.891 I.674 J.835 E.02593
G1 X117.859 Y128.901 E.1154
G2 X118.394 Y130.101 I1.695 J-.037 E.04145
G2 X119.29 Y130.442 I1.102 J-1.545 E.02979
G1 X119.664 Y130.463 E.0115
G1 X136.316 Y130.507 E.51168
G2 X137.33 Y130.315 I.036 J-2.577 E.03191
G2 X138.056 Y129.387 I-.645 J-1.253 E.03736
G2 X138.13 Y128.955 I-3.23 J-.771 E.01348
G1 X141.898 Y128.965 E.11581
G3 X142.673 Y129.201 I.1 J1.062 E.02552
G3 X142.9 Y130.013 I-.94 J.7 E.02651
G1 X142.89 Y133.612 E.11058
G1 X142.89 Y133.624 E.00038
G1 X138.29 Y133.612 E.14134
G1 X138.29 Y133.6 E.00038
G1 X138.296 Y131.453 E.06596
G1 X138.255 Y131.453 E.00126
G1 X117.739 Y131.399 E.6304
M204 S10000
G1 X118.17 Y130.693 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107468
G1 F3218
G2 X118.323 Y130.785 I.185 J-.133 E.00096
G1 X117.737 Y130.549 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.543 Y130.339 E.00878
G1 X117.3 Y129.913 E.01507
G1 X117.228 Y129.683 E.00739
G1 X114.134 Y129.675 E.09508
G1 X113.91 Y129.709 E.00694
G1 X113.867 Y129.995 E.00889
G1 X113.86 Y132.763 E.08505
G1 X116.891 Y132.771 E.09315
G1 X116.897 Y130.801 E.06054
G1 X117.039 Y130.619 E.00709
G1 X117.731 Y130.604 E.0213
G1 X117.049 Y130.24 F30000
G1 F3218
G1 X116.954 Y130.06 E.00627
G1 X114.244 Y130.052 E.08326
G1 X114.238 Y132.387 E.07173
G1 X116.515 Y132.393 E.06998
G1 X116.52 Y130.8 E.04895
G1 X116.916 Y130.262 E.02053
G1 X116.989 Y130.25 E.00229
G1 X116.41 Y130.435 F30000
G1 F3218
G1 X114.62 Y130.431 E.055
G1 X114.616 Y132.011 E.04856
G1 X116.139 Y132.015 E.0468
G1 X116.143 Y130.799 E.03737
G1 X116.375 Y130.484 E.01202
G1 X115.765 Y130.811 F30000
G1 F3218
G1 X114.996 Y130.809 E.02363
G1 X114.994 Y131.635 E.02539
G1 X115.763 Y131.637 E.02363
G1 X115.765 Y130.871 E.02354
; WIPE_START
G1 F15000
G1 X115.763 Y131.637 E-.29115
G1 X114.994 Y131.635 E-.29227
G1 X114.995 Y131.17 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.196 Y130.92 Z12.2 F30000
G1 Z11.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591851
G1 F3218
G1 X136.32 Y130.978 E.766
G1 X136.782 Y130.967 E.02066
G1 X137.656 Y130.837 F30000
; LINE_WIDTH: 0.107453
G1 F3218
G2 X137.809 Y130.745 I-.031 J-.226 E.00096
G1 X138.219 Y130.628 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.27 Y130.669 E.00203
G1 X138.951 Y130.68 E.02091
G1 X139.082 Y130.86 E.00684
G1 X139.077 Y132.83 E.06054
G1 X142.108 Y132.838 E.09315
G1 X142.115 Y130.069 E.08509
G1 X142.075 Y129.784 E.00885
G1 X141.797 Y129.749 E.00861
G1 X138.756 Y129.741 E.09344
G3 X138.26 Y130.585 I-1.982 J-.596 E.03038
G1 X138.933 Y130.299 F30000
G1 F3218
G1 X139.066 Y130.321 E.00414
G1 X139.459 Y130.861 E.02053
G1 X139.455 Y132.454 E.04895
G1 X141.732 Y132.46 E.06998
G1 X141.738 Y130.126 E.07173
G1 X139.029 Y130.118 E.08326
G1 X138.961 Y130.246 E.00443
G1 X139.57 Y130.497 F30000
G1 F3218
G1 X139.836 Y130.862 E.01387
G1 X139.833 Y132.078 E.03737
G1 X141.356 Y132.082 E.0468
G1 X141.36 Y130.502 E.04856
G1 X139.63 Y130.497 E.05315
G1 X140.213 Y130.876 F30000
G1 F3218
G1 X140.211 Y131.702 E.02539
G1 X140.98 Y131.704 E.02363
G1 X140.982 Y130.878 E.02539
G1 X140.273 Y130.876 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 12
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.982 Y130.878 E-.26947
G1 X140.98 Y131.704 E-.31395
G1 X140.515 Y131.703 E-.17658
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 60/118
; update layer progress
M73 L60
M991 S0 P59 ;notify layer change
G17
G3 Z12.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.288 Y131.059
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.282 Y133.217 E.07161
G1 X113.467 Y133.207 E.12657
G1 X113.475 Y129.997 E.10649
G3 X113.597 Y129.451 I.854 J-.096 E.0189
G3 X113.907 Y129.345 I.362 J.552 E.01098
G1 X117.517 Y129.345 E.11976
G2 X117.869 Y130.174 I2.406 J-.533 E.03002
G2 X118.845 Y130.81 I1.523 J-1.269 E.03923
G1 X119.011 Y130.842 E.00561
G1 X118.99 Y131.063 E.00739
G1 X117.348 Y131.059 E.05447
; WIPE_START
G1 F16213.044
G1 X117.287 Y133.058 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.874 Y132.222 Z12.4 F30000
G1 X136.967 Y130.889 Z12.4
G1 Z12
G1 E.8 F1800
G1 F3218
G2 X137.837 Y130.511 I-.413 J-2.14 E.03172
G2 X138.432 Y129.552 I-1.352 J-1.504 E.03796
G1 X138.469 Y129.401 E.00515
G1 X141.888 Y129.41 E.11342
G3 X142.389 Y129.527 I.091 J.738 E.01741
G3 X142.499 Y129.872 I-.665 J.403 E.01212
G1 X142.499 Y133.284 E.1132
G1 X138.683 Y133.274 E.12657
G1 X138.689 Y131.116 E.07161
G1 X136.987 Y131.111 E.05646
G1 X136.972 Y130.949 E.00539
; WIPE_START
G1 F16213.044
G1 X137.133 Y130.859 E-.07012
G1 X137.504 Y130.722 E-.15023
G1 X137.837 Y130.511 E-.14966
G1 X138.113 Y130.227 E-.15035
G1 X138.317 Y129.883 E-.15223
G1 X138.393 Y129.666 E-.08742
; WIPE_END
G1 E-.04 F1800
G1 X130.788 Y130.321 Z12.4 F30000
G1 X117.679 Y131.452 Z12.4
G1 Z12
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.673 Y133.598 E.06596
G1 X117.673 Y133.611 E.00038
G1 X113.074 Y133.598 E.14134
G1 X113.074 Y133.586 E.00038
G1 X113.083 Y129.987 E.11058
G3 X113.314 Y129.176 I1.167 J-.106 E.02652
G3 X113.867 Y128.954 I.611 J.723 E.01862
G1 X117.859 Y128.954 E.12265
G2 X118.394 Y130.154 I1.694 J-.036 E.04145
G2 X119.29 Y130.495 I1.102 J-1.545 E.0298
G1 X119.664 Y130.516 E.0115
G1 X136.316 Y130.561 E.51168
G2 X137.33 Y130.368 I.036 J-2.577 E.03191
G2 X138.056 Y129.441 I-.645 J-1.253 E.03735
G2 X138.129 Y129.008 I-3.209 J-.768 E.01349
G1 X141.898 Y129.018 E.11581
G3 X142.673 Y129.254 I.1 J1.061 E.02552
G3 X142.9 Y130.067 I-.94 J.7 E.02652
G1 X142.89 Y133.665 E.11058
G1 X142.89 Y133.678 E.00038
G1 X138.29 Y133.665 E.14134
G1 X138.29 Y133.653 E.00038
G1 X138.296 Y131.507 E.06596
G1 X138.255 Y131.506 E.00126
G1 X117.739 Y131.452 E.6304
M204 S10000
G1 X118.17 Y130.746 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10746
G1 F3218
G2 X118.322 Y130.838 I.185 J-.133 E.00096
G1 X117.737 Y130.602 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.543 Y130.392 E.00878
G1 X117.3 Y129.966 E.01507
G1 X117.228 Y129.737 E.00739
G1 X114.135 Y129.728 E.09505
G1 X113.91 Y129.762 E.00697
G1 X113.867 Y130.048 E.00889
G1 X113.86 Y132.816 E.08505
G1 X116.891 Y132.824 E.09315
G1 X116.897 Y130.854 E.06054
G1 X117.038 Y130.672 E.00709
G1 X117.731 Y130.657 E.0213
G1 X117.049 Y130.294 F30000
G1 F3218
G1 X116.954 Y130.113 E.00627
G1 X114.244 Y130.106 E.08326
G1 X114.238 Y132.44 E.07173
G1 X116.515 Y132.446 E.06998
G1 X116.52 Y130.853 E.04895
G1 X116.916 Y130.315 E.02053
G1 X116.989 Y130.303 E.00229
G1 X116.41 Y130.489 F30000
G1 F3218
G1 X114.62 Y130.484 E.055
G1 X114.616 Y132.064 E.04856
G1 X116.139 Y132.068 E.0468
G1 X116.142 Y130.852 E.03737
G1 X116.374 Y130.537 E.01202
G1 X115.765 Y130.864 F30000
G1 F3218
G1 X114.996 Y130.862 E.02363
G1 X114.994 Y131.688 E.02539
G1 X115.763 Y131.69 E.02363
G1 X115.765 Y130.924 E.02354
; WIPE_START
G1 F15000
G1 X115.763 Y131.69 E-.29116
G1 X114.994 Y131.688 E-.29227
G1 X114.995 Y131.223 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.196 Y130.973 Z12.4 F30000
G1 Z12
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591852
G1 F3218
G1 X136.32 Y131.031 E.766
G1 X136.782 Y131.02 E.02066
G1 X137.656 Y130.89 F30000
; LINE_WIDTH: 0.107447
G1 F3218
G2 X137.808 Y130.798 I-.031 J-.225 E.00096
G1 X138.218 Y130.681 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.27 Y130.722 E.00203
G1 X138.951 Y130.733 E.02091
G1 X139.082 Y130.913 E.00684
G1 X139.076 Y132.883 E.06054
G1 X142.108 Y132.891 E.09315
G1 X142.115 Y130.122 E.08509
G1 X142.075 Y129.837 E.00885
G1 X141.797 Y129.802 E.00861
G1 X138.756 Y129.794 E.09344
G3 X138.26 Y130.638 I-1.983 J-.596 E.03038
G1 X138.933 Y130.352 F30000
G1 F3218
G1 X139.066 Y130.374 E.00414
G1 X139.459 Y130.914 E.02053
G1 X139.454 Y132.507 E.04895
G1 X141.732 Y132.513 E.06998
G1 X141.738 Y130.179 E.07173
G1 X139.028 Y130.172 E.08326
G1 X138.961 Y130.299 E.00443
G1 X139.57 Y130.55 F30000
G1 F3218
G1 X139.836 Y130.915 E.01387
G1 X139.833 Y132.131 E.03737
G1 X141.356 Y132.135 E.0468
G1 X141.36 Y130.555 E.04856
G1 X139.63 Y130.55 E.05315
G1 X140.213 Y130.929 F30000
G1 F3218
G1 X140.211 Y131.755 E.02539
G1 X140.98 Y131.757 E.02363
G1 X140.982 Y130.931 E.02539
G1 X140.273 Y130.929 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 12.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.982 Y130.931 E-.26947
G1 X140.98 Y131.757 E-.31396
G1 X140.515 Y131.756 E-.17658
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 61/118
; update layer progress
M73 L61
M991 S0 P60 ;notify layer change
G17
G3 Z12.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.288 Y131.112
G1 Z12.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.282 Y133.271 E.07161
G1 X113.467 Y133.261 E.12657
G1 X113.475 Y130.05 E.10649
G3 X113.597 Y129.504 I.854 J-.096 E.0189
G3 X113.907 Y129.398 I.362 J.552 E.01097
G1 X117.517 Y129.399 E.11977
G2 X117.869 Y130.227 I2.402 J-.531 E.03002
G2 X118.845 Y130.863 I1.523 J-1.269 E.03923
G1 X119.011 Y130.895 E.00561
G1 X118.99 Y131.116 E.00738
G1 X117.348 Y131.112 E.05447
; WIPE_START
G1 F16213.044
G1 X117.287 Y133.111 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.874 Y132.275 Z12.6 F30000
G1 X136.967 Y130.943 Z12.6
G1 Z12.2
G1 E.8 F1800
G1 F3230
G2 X137.837 Y130.565 I-.412 J-2.14 E.03172
G2 X138.317 Y129.936 I-1.061 J-1.306 E.02648
G2 X138.469 Y129.454 I-2.343 J-1.006 E.01678
G1 X141.888 Y129.463 E.11342
G3 X142.388 Y129.581 I.091 J.738 E.01741
G3 X142.499 Y129.925 I-.666 J.404 E.01211
G1 X142.499 Y133.338 E.1132
G1 X138.683 Y133.328 E.12657
G1 X138.689 Y131.169 E.07161
G1 X136.987 Y131.164 E.05646
G1 X136.972 Y131.002 E.00539
; WIPE_START
G1 F16213.044
G1 X137.133 Y130.912 E-.07016
G1 X137.504 Y130.775 E-.15019
G1 X137.837 Y130.565 E-.14967
G1 X138.113 Y130.281 E-.15038
G1 X138.317 Y129.936 E-.15226
G1 X138.386 Y129.717 E-.08733
; WIPE_END
G1 E-.04 F1800
G1 X130.782 Y130.373 Z12.6 F30000
G1 X117.679 Y131.505 Z12.6
G1 Z12.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.673 Y133.652 E.06596
G1 X117.673 Y133.664 E.00038
G1 X113.073 Y133.652 E.14134
G1 X113.073 Y133.639 E.00038
G1 X113.083 Y130.041 E.11058
G3 X113.314 Y129.229 I1.167 J-.106 E.02652
M73 P73 R4
G3 X113.867 Y129.007 I.611 J.723 E.01862
G1 X117.859 Y129.007 E.12265
G2 X118.394 Y130.207 I1.694 J-.036 E.04145
G2 X119.29 Y130.549 I1.102 J-1.545 E.0298
G1 X119.664 Y130.57 E.0115
G1 X136.316 Y130.614 E.51168
G2 X137.329 Y130.422 I.036 J-2.578 E.03191
G2 X138.056 Y129.494 I-.645 J-1.253 E.03734
G2 X138.129 Y129.061 I-3.187 J-.764 E.01351
G1 X141.898 Y129.071 E.11581
G3 X142.673 Y129.307 I.1 J1.062 E.02552
G3 X142.899 Y130.12 I-.94 J.7 E.02651
G1 X142.89 Y133.719 E.11058
G1 X142.89 Y133.731 E.00038
G1 X138.29 Y133.719 E.14134
G1 X138.29 Y133.706 E.00038
G1 X138.296 Y131.56 E.06596
G1 X138.255 Y131.56 E.00126
G1 X117.739 Y131.505 E.6304
M204 S10000
G1 X118.17 Y130.799 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107458
G1 F3230
G2 X118.322 Y130.892 I.185 J-.133 E.00096
G1 X117.737 Y130.655 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.543 Y130.446 E.00879
G1 X117.299 Y130.019 E.01508
G1 X117.228 Y129.79 E.00738
G1 X114.135 Y129.782 E.09503
G1 X113.91 Y129.816 E.007
G1 X113.867 Y130.102 E.00889
G1 X113.86 Y132.87 E.08505
G1 X116.891 Y132.878 E.09315
G1 X116.896 Y130.907 E.06054
G1 X117.038 Y130.725 E.00709
G1 X117.731 Y130.71 E.0213
G1 X117.048 Y130.347 F30000
G1 F3230
G1 X116.954 Y130.166 E.00627
G1 X114.244 Y130.159 E.08326
G1 X114.238 Y132.493 E.07173
G1 X116.515 Y132.5 E.06998
G1 X116.519 Y130.906 E.04895
G1 X116.915 Y130.368 E.02053
G1 X116.989 Y130.356 E.00229
G1 X116.41 Y130.542 F30000
G1 F3230
G1 X114.62 Y130.537 E.055
G1 X114.616 Y132.117 E.04856
G1 X116.139 Y132.121 E.0468
G1 X116.142 Y130.905 E.03737
G1 X116.374 Y130.59 E.01202
G1 X115.765 Y130.917 F30000
G1 F3230
G1 X114.996 Y130.915 E.02363
G1 X114.994 Y131.741 E.02539
G1 X115.763 Y131.743 E.02363
G1 X115.765 Y130.977 E.02354
; WIPE_START
G1 F15000
G1 X115.763 Y131.743 E-.29116
G1 X114.994 Y131.741 E-.29226
G1 X114.995 Y131.277 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.196 Y131.027 Z12.6 F30000
G1 Z12.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.59187
G1 F3230
G1 X119.657 Y131.04 E.02066
G1 X136.782 Y131.073 E.76602
G1 X137.656 Y130.943 F30000
; LINE_WIDTH: 0.10744
G1 F3230
G2 X137.808 Y130.852 I-.031 J-.225 E.00096
G1 X138.218 Y130.735 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.27 Y130.776 E.00203
G1 X138.95 Y130.786 E.02091
G1 X139.081 Y130.966 E.00684
G1 X139.076 Y132.937 E.06054
G1 X142.108 Y132.945 E.09315
G1 X142.115 Y130.175 E.08509
G1 X142.075 Y129.89 E.00885
G1 X141.797 Y129.855 E.00861
G1 X138.756 Y129.847 E.09344
G3 X138.26 Y130.692 I-1.983 J-.596 E.03038
G1 X138.933 Y130.405 F30000
G1 F3230
G1 X139.065 Y130.427 E.00414
G1 X139.459 Y130.967 E.02053
G1 X139.454 Y132.561 E.04895
G1 X141.732 Y132.567 E.06998
G1 X141.738 Y130.232 E.07173
G1 X139.028 Y130.225 E.08326
G1 X138.961 Y130.352 E.00443
G1 X139.57 Y130.603 F30000
G1 F3230
G1 X139.836 Y130.968 E.01387
G1 X139.832 Y132.184 E.03737
G1 X141.356 Y132.189 E.0468
G1 X141.36 Y130.608 E.04856
G1 X139.63 Y130.604 E.05315
G1 X140.213 Y130.982 F30000
G1 F3230
G1 X140.21 Y131.808 E.02539
G1 X140.98 Y131.81 E.02363
G1 X140.982 Y130.984 E.02539
G1 X140.273 Y130.982 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 12.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.982 Y130.984 E-.26947
G1 X140.98 Y131.81 E-.31396
G1 X140.515 Y131.809 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 62/118
; update layer progress
M73 L62
M991 S0 P61 ;notify layer change
G17
G3 Z12.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.288 Y131.165
G1 Z12.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.282 Y133.324 E.07161
G1 X113.466 Y133.314 E.12657
G1 X113.475 Y130.103 E.1065
G3 X113.597 Y129.557 I.854 J-.096 E.0189
G3 X113.906 Y129.451 I.362 J.552 E.01097
G1 X117.517 Y129.452 E.11978
G2 X117.869 Y130.28 I2.402 J-.531 E.03002
G2 X118.845 Y130.917 I1.523 J-1.268 E.03923
G1 X119.011 Y130.948 E.00561
G1 X118.99 Y131.17 E.00739
G1 X117.348 Y131.165 E.05447
; WIPE_START
G1 F16213.044
G1 X117.287 Y133.164 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.873 Y132.328 Z12.8 F30000
G1 X136.967 Y130.996 Z12.8
G1 Z12.4
G1 E.8 F1800
G1 F3230
G2 X137.837 Y130.618 I-.412 J-2.139 E.03172
G2 X138.316 Y129.989 I-1.061 J-1.306 E.02649
G2 X138.469 Y129.507 I-2.344 J-1.006 E.01678
G1 X141.888 Y129.517 E.11342
G3 X142.388 Y129.634 I.091 J.738 E.01741
G3 X142.499 Y129.978 I-.666 J.404 E.01211
G1 X142.499 Y133.391 E.1132
G1 X138.683 Y133.381 E.12657
G1 X138.689 Y131.222 E.07161
G1 X136.987 Y131.218 E.05646
G1 X136.972 Y131.056 E.0054
; WIPE_START
G1 F16213.044
G1 X137.133 Y130.965 E-.07017
G1 X137.504 Y130.828 E-.15018
G1 X137.837 Y130.618 E-.14966
G1 X138.113 Y130.334 E-.15039
G1 X138.316 Y129.989 E-.1523
G1 X138.386 Y129.77 E-.08729
; WIPE_END
G1 E-.04 F1800
G1 X130.782 Y130.427 Z12.8 F30000
G1 X117.679 Y131.558 Z12.8
G1 Z12.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.673 Y133.705 E.06596
G1 X117.673 Y133.717 E.00038
G1 X113.073 Y133.705 E.14134
G1 X113.073 Y133.693 E.00038
G1 X113.083 Y130.094 E.11058
G3 X113.314 Y129.283 I1.167 J-.106 E.02651
G3 X113.867 Y129.061 I.611 J.723 E.01862
G1 X117.859 Y129.061 E.12266
G2 X118.394 Y130.26 I1.693 J-.036 E.04145
G2 X119.29 Y130.602 I1.102 J-1.545 E.0298
G1 X119.663 Y130.623 E.0115
G1 X136.316 Y130.667 E.51168
G2 X137.329 Y130.475 I.036 J-2.578 E.03191
G2 X138.055 Y129.548 I-.645 J-1.253 E.03733
G2 X138.129 Y129.115 I-3.166 J-.762 E.01352
G1 X141.898 Y129.125 E.11581
G3 X142.673 Y129.361 I.1 J1.062 E.02552
G3 X142.899 Y130.173 I-.94 J.7 E.02651
G1 X142.89 Y133.772 E.11058
G1 X142.89 Y133.784 E.00038
G1 X138.29 Y133.772 E.14134
G1 X138.29 Y133.76 E.00038
G1 X138.296 Y131.613 E.06596
G1 X138.255 Y131.613 E.00126
G1 X117.739 Y131.558 E.6304
M204 S10000
G1 X118.17 Y130.853 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10744
G1 F3230
G2 X118.322 Y130.945 I.185 J-.133 E.00096
G1 X117.737 Y130.709 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.542 Y130.499 E.0088
G1 X117.299 Y130.072 E.01508
G1 X117.228 Y129.843 E.00738
G1 X114.136 Y129.835 E.095
G1 X113.91 Y129.869 E.00703
G1 X113.867 Y130.155 E.00888
G1 X113.86 Y132.923 E.08505
G1 X116.891 Y132.931 E.09315
G1 X116.896 Y130.961 E.06054
G1 X117.038 Y130.778 E.00709
G1 X117.731 Y130.764 E.0213
G1 X117.048 Y130.4 F30000
G1 F3230
G1 X116.953 Y130.219 E.00627
G1 X114.244 Y130.212 E.08326
G1 X114.238 Y132.547 E.07173
G1 X116.515 Y132.553 E.06998
G1 X116.519 Y130.96 E.04895
G1 X116.915 Y130.421 E.02053
G1 X116.989 Y130.41 E.00229
G1 X116.41 Y130.595 F30000
G1 F3230
G1 X114.62 Y130.59 E.055
G1 X114.616 Y132.171 E.04856
G1 X116.139 Y132.175 E.0468
G1 X116.142 Y130.959 E.03737
G1 X116.374 Y130.643 E.01202
G1 X115.765 Y130.97 F30000
G1 F3230
G1 X114.996 Y130.968 E.02363
G1 X114.994 Y131.795 E.02539
G1 X115.763 Y131.797 E.02363
G1 X115.765 Y131.03 E.02354
; WIPE_START
G1 F15000
G1 X115.763 Y131.797 E-.29115
G1 X114.994 Y131.795 E-.29226
G1 X114.995 Y131.33 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.195 Y131.08 Z12.8 F30000
G1 Z12.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.657 Y131.093 E.02066
G1 X136.782 Y131.127 E.76601
G1 X137.656 Y130.996 F30000
; LINE_WIDTH: 0.107438
G1 F3230
G2 X137.808 Y130.905 I-.031 J-.225 E.00096
G1 X138.218 Y130.788 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.27 Y130.829 E.00202
G1 X138.95 Y130.839 E.02091
G1 X139.081 Y131.02 E.00684
G1 X139.076 Y132.99 E.06054
G1 X142.108 Y132.998 E.09315
G1 X142.115 Y130.229 E.08508
G1 X142.075 Y129.943 E.00886
G1 X141.796 Y129.908 E.00862
G1 X138.756 Y129.9 E.09343
G3 X138.26 Y130.745 I-1.984 J-.596 E.03038
G1 X138.932 Y130.458 F30000
G1 F3230
G1 X139.065 Y130.48 E.00414
G1 X139.458 Y131.021 E.02053
G1 X139.454 Y132.614 E.04895
G1 X141.732 Y132.62 E.06998
G1 X141.738 Y130.285 E.07173
G1 X139.028 Y130.278 E.08326
G1 X138.961 Y130.405 E.00443
G1 X139.57 Y130.657 F30000
G1 F3230
G1 X139.835 Y131.022 E.01387
G1 X139.832 Y132.238 E.03737
G1 X141.356 Y132.242 E.0468
G1 X141.36 Y130.661 E.04856
G1 X139.63 Y130.657 E.05315
G1 X140.213 Y131.035 F30000
G1 F3230
G1 X140.21 Y131.862 E.02539
G1 X140.979 Y131.864 E.02363
G1 X140.982 Y131.037 E.02539
G1 X140.273 Y131.036 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 12.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X140.982 Y131.037 E-.26947
G1 X140.979 Y131.864 E-.31396
G1 X140.515 Y131.862 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 63/118
; update layer progress
M73 L63
M991 S0 P62 ;notify layer change
G17
G3 Z12.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.288 Y131.218
G1 Z12.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.282 Y133.377 E.07161
G1 X113.466 Y133.367 E.12657
G1 X113.475 Y130.157 E.1065
G3 X113.597 Y129.611 I.854 J-.096 E.0189
G3 X113.906 Y129.505 I.362 J.552 E.01097
G1 X117.517 Y129.505 E.11977
G2 X117.869 Y130.333 I2.402 J-.531 E.03002
G2 X118.845 Y130.97 I1.523 J-1.269 E.03924
G1 X119.011 Y131.001 E.00561
G1 X118.99 Y131.223 E.00739
G1 X117.348 Y131.219 E.05447
; WIPE_START
G1 F16213.044
G1 X117.287 Y133.218 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.873 Y132.382 Z13 F30000
G1 X136.967 Y131.049 Z13
G1 Z12.6
G1 E.8 F1800
G1 F3218
G2 X137.837 Y130.671 I-.413 J-2.14 E.03172
G2 X138.316 Y130.042 I-1.06 J-1.306 E.02649
G2 X138.468 Y129.561 I-2.339 J-1.004 E.01677
G1 X141.888 Y129.57 E.11342
G3 X142.388 Y129.687 I.091 J.738 E.01741
G3 X142.499 Y130.032 I-.666 J.404 E.01211
G1 X142.499 Y133.444 E.1132
G1 X138.683 Y133.434 E.12657
G1 X138.689 Y131.275 E.07161
G1 X136.987 Y131.271 E.05646
G1 X136.972 Y131.109 E.00539
; WIPE_START
G1 F16213.044
G1 X137.133 Y131.018 E-.07012
G1 X137.504 Y130.882 E-.15022
G1 X137.837 Y130.671 E-.14964
G1 X138.112 Y130.387 E-.15042
G1 X138.316 Y130.042 E-.15237
G1 X138.386 Y129.823 E-.08724
; WIPE_END
G1 E-.04 F1800
G1 X130.781 Y130.48 Z13 F30000
G1 X117.679 Y131.612 Z13
G1 Z12.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.673 Y133.758 E.06596
G1 X117.673 Y133.77 E.00038
G1 X113.073 Y133.758 E.14134
G1 X113.073 Y133.746 E.00038
G1 X113.083 Y130.147 E.11058
G3 X113.314 Y129.336 I1.167 J-.106 E.02651
G3 X113.867 Y129.114 I.611 J.723 E.01862
G1 X117.858 Y129.114 E.12266
G2 X118.393 Y130.314 I1.692 J-.035 E.04145
G2 X119.29 Y130.655 I1.102 J-1.545 E.02979
G1 X119.663 Y130.676 E.0115
G1 X136.316 Y130.72 E.51168
G2 X137.329 Y130.528 I.036 J-2.577 E.03191
G2 X138.055 Y129.601 I-.645 J-1.253 E.03732
G2 X138.129 Y129.168 I-3.147 J-.759 E.01353
G1 X141.898 Y129.178 E.11581
G3 X142.672 Y129.414 I.1 J1.061 E.02552
G3 X142.899 Y130.226 I-.94 J.7 E.02651
G1 X142.89 Y133.825 E.11058
G1 X142.89 Y133.837 E.00038
G1 X138.29 Y133.825 E.14134
G1 X138.29 Y133.813 E.00038
G1 X138.296 Y131.666 E.06596
G1 X138.255 Y131.666 E.00126
G1 X117.739 Y131.612 E.6304
M204 S10000
G1 X118.17 Y130.906 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10744
G1 F3218
G2 X118.322 Y130.998 I.185 J-.133 E.00096
G1 X117.737 Y130.762 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.542 Y130.552 E.0088
G1 X117.299 Y130.125 E.01508
G1 X117.228 Y129.896 E.00737
G1 X114.137 Y129.888 E.09496
G1 X113.91 Y129.922 E.00706
G1 X113.867 Y130.208 E.00888
G1 X113.859 Y132.976 E.08505
G1 X116.891 Y132.984 E.09315
G1 X116.896 Y131.014 E.06054
G1 X117.038 Y130.832 E.00709
G1 X117.731 Y130.817 E.02131
G1 X117.048 Y130.453 F30000
G1 F3218
G1 X116.953 Y130.273 E.00627
G1 X114.244 Y130.266 E.08326
G1 X114.237 Y132.6 E.07173
M73 P74 R4
G1 X116.515 Y132.606 E.06998
G1 X116.519 Y131.013 E.04895
G1 X116.915 Y130.475 E.02053
G1 X116.989 Y130.463 E.00229
G1 X116.41 Y130.648 F30000
G1 F3218
G1 X114.62 Y130.644 E.055
G1 X114.616 Y132.224 E.04856
G1 X116.139 Y132.228 E.0468
G1 X116.142 Y131.012 E.03737
G1 X116.374 Y130.697 E.01203
G1 X115.765 Y131.024 F30000
G1 F3218
G1 X114.996 Y131.022 E.02363
G1 X114.994 Y131.848 E.02539
G1 X115.763 Y131.85 E.02363
G1 X115.765 Y131.084 E.02354
; WIPE_START
G1 F15000
G1 X115.763 Y131.85 E-.29116
G1 X114.994 Y131.848 E-.29226
G1 X114.995 Y131.383 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.195 Y131.133 Z13 F30000
G1 Z12.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591852
G1 F3218
G1 X136.32 Y131.191 E.766
G1 X136.781 Y131.18 E.02066
G1 X137.655 Y131.05 F30000
; LINE_WIDTH: 0.107441
G1 F3218
G2 X137.808 Y130.958 I-.031 J-.225 E.00096
G1 X138.218 Y130.841 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.269 Y130.882 E.00202
G1 X138.95 Y130.893 E.02092
G1 X139.081 Y131.073 E.00684
G1 X139.076 Y133.043 E.06054
G1 X142.108 Y133.051 E.09315
G1 X142.115 Y130.282 E.08509
G1 X142.074 Y129.997 E.00885
G1 X141.796 Y129.962 E.00861
G1 X138.755 Y129.954 E.09344
G3 X138.26 Y130.798 I-1.984 J-.597 E.03038
G1 X138.932 Y130.512 F30000
G1 F3218
G1 X139.065 Y130.534 E.00414
G1 X139.458 Y131.074 E.02053
G1 X139.454 Y132.667 E.04895
G1 X141.731 Y132.673 E.06998
G1 X141.738 Y130.339 E.07173
G1 X139.028 Y130.331 E.08326
G1 X138.96 Y130.459 E.00443
G1 X139.57 Y130.71 F30000
G1 F3218
G1 X139.835 Y131.075 E.01387
G1 X139.832 Y132.291 E.03737
G1 X141.355 Y132.295 E.0468
G1 X141.36 Y130.715 E.04856
G1 X139.63 Y130.71 E.05315
G1 X140.212 Y131.089 F30000
G1 F3218
G1 X140.21 Y131.915 E.02539
G1 X140.979 Y131.917 E.02363
G1 X140.982 Y131.091 E.02539
G1 X140.272 Y131.089 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 12.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.982 Y131.091 E-.26947
G1 X140.979 Y131.917 E-.31396
G1 X140.515 Y131.916 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 64/118
; update layer progress
M73 L64
M991 S0 P63 ;notify layer change
G17
G3 Z13 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.288 Y131.272
G1 Z12.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.282 Y133.43 E.07161
G1 X113.466 Y133.42 E.12657
G1 X113.475 Y130.21 E.10649
G3 X113.596 Y129.664 I.854 J-.096 E.0189
G3 X113.906 Y129.558 I.362 J.552 E.01097
G1 X117.517 Y129.558 E.11978
G2 X117.868 Y130.387 I2.4 J-.53 E.03002
G2 X118.845 Y131.023 I1.523 J-1.269 E.03923
G1 X119.011 Y131.055 E.00561
G1 X118.99 Y131.276 E.00739
G1 X117.348 Y131.272 E.05447
; WIPE_START
G1 F16213.044
G1 X117.287 Y133.271 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.873 Y132.435 Z13.2 F30000
G1 X136.966 Y131.102 Z13.2
G1 Z12.8
G1 E.8 F1800
G1 F3230
G2 X137.836 Y130.724 I-.412 J-2.139 E.03172
G2 X138.316 Y130.095 I-1.061 J-1.307 E.02649
G2 X138.468 Y129.614 I-2.336 J-1.003 E.01677
G1 X141.888 Y129.623 E.11342
G3 X142.388 Y129.74 I.091 J.738 E.01741
G3 X142.499 Y130.085 I-.666 J.403 E.01211
G1 X142.498 Y133.498 E.1132
G1 X138.683 Y133.487 E.12657
G1 X138.688 Y131.329 E.07161
G1 X136.986 Y131.324 E.05646
G1 X136.972 Y131.162 E.00539
; WIPE_START
G1 F16213.044
G1 X137.133 Y131.072 E-.07016
G1 X137.504 Y130.935 E-.15018
G1 X137.836 Y130.724 E-.14968
G1 X138.112 Y130.44 E-.15038
G1 X138.316 Y130.095 E-.15241
G1 X138.385 Y129.876 E-.08719
; WIPE_END
G1 E-.04 F1800
G1 X130.781 Y130.533 Z13.2 F30000
G1 X117.679 Y131.665 Z13.2
G1 Z12.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.673 Y133.811 E.06596
G1 X117.673 Y133.824 E.00038
G1 X113.073 Y133.811 E.14134
G1 X113.073 Y133.799 E.00038
G1 X113.083 Y130.2 E.11058
G3 X113.314 Y129.389 I1.167 J-.106 E.02651
G3 X113.866 Y129.167 I.611 J.722 E.01862
G1 X117.858 Y129.167 E.12266
G2 X118.393 Y130.367 I1.692 J-.035 E.04145
G2 X119.29 Y130.708 I1.102 J-1.545 E.02979
G1 X119.663 Y130.729 E.0115
G1 X136.316 Y130.774 E.51168
G2 X137.329 Y130.581 I.036 J-2.578 E.03191
G2 X138.055 Y129.655 I-.644 J-1.253 E.03731
G2 X138.129 Y129.221 I-3.129 J-.756 E.01354
G1 X141.898 Y129.231 E.11581
G3 X142.672 Y129.467 I.1 J1.062 E.02552
G3 X142.899 Y130.28 I-.94 J.7 E.02652
G1 X142.889 Y133.878 E.11058
G1 X142.889 Y133.891 E.00038
G1 X138.29 Y133.878 E.14134
G1 X138.29 Y133.866 E.00038
G1 X138.295 Y131.72 E.06596
G1 X138.254 Y131.719 E.00126
G1 X117.739 Y131.665 E.6304
M204 S10000
G1 X118.17 Y130.959 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107451
G1 F3230
G2 X118.322 Y131.051 I.185 J-.133 E.00096
G1 X117.737 Y130.815 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.542 Y130.605 E.0088
G1 X117.299 Y130.179 E.01509
G1 X117.228 Y129.95 E.00736
G1 X114.138 Y129.941 E.09494
G1 X113.91 Y129.976 E.00709
G1 X113.867 Y130.261 E.00888
G1 X113.859 Y133.029 E.08505
G1 X116.891 Y133.037 E.09315
G1 X116.896 Y131.067 E.06054
G1 X117.038 Y130.885 E.00709
G1 X117.731 Y130.87 E.02131
G1 X117.048 Y130.507 F30000
G1 F3230
G1 X116.953 Y130.326 E.00627
G1 X114.244 Y130.319 E.08326
G1 X114.237 Y132.653 E.07173
G1 X116.515 Y132.659 E.06998
G1 X116.519 Y131.066 E.04895
G1 X116.915 Y130.528 E.02053
G1 X116.989 Y130.516 E.00229
G1 X116.409 Y130.702 F30000
G1 F3230
G1 X114.62 Y130.697 E.055
G1 X114.615 Y132.277 E.04856
G1 X116.139 Y132.281 E.0468
G1 X116.142 Y131.065 E.03737
G1 X116.374 Y130.75 E.01203
G1 X115.765 Y131.077 F30000
G1 F3230
G1 X114.996 Y131.075 E.02363
G1 X114.993 Y131.901 E.02539
G1 X115.763 Y131.903 E.02363
G1 X115.765 Y131.137 E.02354
; WIPE_START
G1 F15000
G1 X115.763 Y131.903 E-.29116
G1 X114.993 Y131.901 E-.29227
G1 X114.995 Y131.436 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.195 Y131.186 Z13.2 F30000
G1 Z12.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.657 Y131.2 E.02066
G1 X136.781 Y131.233 E.76601
G1 X137.655 Y131.103 F30000
; LINE_WIDTH: 0.107463
G1 F3230
G2 X137.808 Y131.011 I-.031 J-.226 E.00096
G1 X138.218 Y130.894 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.27 Y130.935 E.00204
G1 X138.95 Y130.946 E.0209
G1 X139.081 Y131.126 E.00684
G1 X139.076 Y133.096 E.06054
G1 X142.107 Y133.104 E.09315
G1 X142.115 Y130.335 E.08509
G1 X142.074 Y130.05 E.00885
G1 X141.796 Y130.015 E.00861
G1 X138.755 Y130.007 E.09344
G3 X138.26 Y130.851 I-1.984 J-.597 E.03037
G1 X138.932 Y130.565 F30000
G1 F3230
G1 X139.065 Y130.587 E.00414
G1 X139.458 Y131.127 E.02053
G1 X139.454 Y132.72 E.04895
G1 X141.731 Y132.726 E.06998
G1 X141.738 Y130.392 E.07173
G1 X139.028 Y130.385 E.08326
G1 X138.96 Y130.512 E.00443
G1 X139.57 Y130.763 F30000
G1 F3230
G1 X139.835 Y131.128 E.01387
G1 X139.832 Y132.344 E.03737
G1 X141.355 Y132.348 E.0468
G1 X141.359 Y130.768 E.04856
G1 X139.63 Y130.763 E.05315
G1 X140.212 Y131.142 F30000
G1 F3230
G1 X140.21 Y131.968 E.02539
G1 X140.979 Y131.97 E.02363
G1 X140.981 Y131.144 E.02539
G1 X140.272 Y131.142 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 13
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.981 Y131.144 E-.26947
G1 X140.979 Y131.97 E-.31396
G1 X140.515 Y131.969 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 65/118
; update layer progress
M73 L65
M991 S0 P64 ;notify layer change
G17
G3 Z13.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.287 Y131.325
G1 Z13
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.282 Y133.484 E.07161
G1 X113.466 Y133.474 E.12657
G1 X113.475 Y130.263 E.10649
G3 X113.596 Y129.717 I.855 J-.096 E.0189
G3 X113.906 Y129.611 I.362 J.551 E.01096
G1 X117.517 Y129.612 E.11978
G2 X117.868 Y130.44 I2.398 J-.529 E.03002
G2 X118.844 Y131.076 I1.523 J-1.269 E.03923
G1 X119.011 Y131.108 E.00561
G1 X118.989 Y131.329 E.00738
G1 X117.347 Y131.325 E.05447
; WIPE_START
G1 F16213.044
G1 X117.287 Y133.324 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.873 Y132.488 Z13.4 F30000
G1 X136.966 Y131.156 Z13.4
G1 Z13
G1 E.8 F1800
G1 F3230
G2 X137.836 Y130.778 I-.412 J-2.139 E.03172
G1 X138.112 Y130.494 E.01313
G2 X138.468 Y129.667 I-2.038 J-1.368 E.03002
G1 X141.887 Y129.676 E.11342
G3 X142.388 Y129.794 I.091 J.738 E.01741
G3 X142.498 Y130.138 I-.665 J.403 E.01212
G1 X142.498 Y133.551 E.1132
G1 X138.683 Y133.541 E.12657
G1 X138.688 Y131.382 E.07161
G1 X136.986 Y131.377 E.05646
G1 X136.972 Y131.215 E.00539
; WIPE_START
G1 F16213.044
G1 X137.133 Y131.125 E-.07019
G1 X137.503 Y130.988 E-.15016
G1 X137.836 Y130.778 E-.14969
G1 X138.112 Y130.494 E-.15039
G1 X138.316 Y130.148 E-.15247
G1 X138.385 Y129.93 E-.0871
; WIPE_END
G1 E-.04 F1800
G1 X130.781 Y130.586 Z13.4 F30000
G1 X117.678 Y131.718 Z13.4
G1 Z13
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.673 Y133.865 E.06596
G1 X117.673 Y133.877 E.00038
G1 X113.073 Y133.865 E.14134
G1 X113.073 Y133.852 E.00038
G1 X113.082 Y130.254 E.11058
G3 X113.314 Y129.442 I1.167 J-.106 E.02651
G3 X113.866 Y129.22 I.611 J.722 E.01862
G1 X117.858 Y129.22 E.12266
G2 X118.393 Y130.42 I1.691 J-.035 E.04145
G2 X119.289 Y130.762 I1.102 J-1.545 E.0298
G1 X119.663 Y130.783 E.0115
G1 X136.315 Y130.827 E.51168
G2 X137.329 Y130.635 I.036 J-2.578 E.03191
G2 X138.055 Y129.709 I-.644 J-1.252 E.0373
G2 X138.129 Y129.274 I-3.108 J-.753 E.01355
G1 X141.898 Y129.284 E.11581
G3 X142.672 Y129.52 I.1 J1.062 E.02552
G3 X142.899 Y130.333 I-.94 J.7 E.02651
G1 X142.889 Y133.932 E.11058
G1 X142.889 Y133.944 E.00038
G1 X138.289 Y133.932 E.14134
G1 X138.29 Y133.919 E.00038
G1 X138.295 Y131.773 E.06596
G1 X138.254 Y131.773 E.00126
G1 X117.738 Y131.718 E.6304
M204 S10000
G1 X118.17 Y131.013 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107442
G1 F3230
G2 X118.322 Y131.105 I.185 J-.133 E.00096
G1 X117.737 Y130.869 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.542 Y130.658 E.0088
G1 X117.299 Y130.232 E.0151
G1 X117.228 Y130.003 E.00736
G1 X114.139 Y129.995 E.0949
G1 X113.91 Y130.029 E.00713
G1 X113.866 Y130.315 E.00888
G1 X113.859 Y133.083 E.08505
G1 X116.891 Y133.091 E.09315
G1 X116.896 Y131.12 E.06054
G1 X117.037 Y130.938 E.00708
G1 X117.731 Y130.924 E.02131
G1 X117.048 Y130.56 F30000
G1 F3230
G1 X116.953 Y130.379 E.00627
G1 X114.243 Y130.372 E.08326
G1 X114.237 Y132.706 E.07173
G1 X116.515 Y132.713 E.06998
G1 X116.519 Y131.119 E.04895
G1 X116.915 Y130.581 E.02053
G1 X116.989 Y130.569 E.00229
G1 X116.409 Y130.755 F30000
G1 F3230
G1 X114.619 Y130.75 E.055
G1 X114.615 Y132.33 E.04856
G1 X116.138 Y132.334 E.0468
G1 X116.142 Y131.118 E.03737
G1 X116.374 Y130.803 E.01203
G1 X115.765 Y131.13 F30000
G1 F3230
G1 X114.995 Y131.128 E.02363
G1 X114.993 Y131.954 E.02539
G1 X115.762 Y131.956 E.02363
G1 X115.764 Y131.19 E.02354
; WIPE_START
G1 F15000
G1 X115.762 Y131.956 E-.29115
G1 X114.993 Y131.954 E-.29227
G1 X114.995 Y131.49 E-.17658
; WIPE_END
G1 E-.04 F1800
G1 X119.195 Y131.24 Z13.4 F30000
M73 P75 R4
G1 Z13
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591871
G1 F3230
G1 X119.657 Y131.253 E.02066
G1 X136.781 Y131.286 E.76602
G1 X137.655 Y131.156 F30000
; LINE_WIDTH: 0.107472
G1 F3230
G2 X137.808 Y131.065 I-.031 J-.226 E.00096
G1 X138.218 Y130.947 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.27 Y130.989 E.00204
G1 X138.95 Y130.999 E.0209
G1 X139.081 Y131.179 E.00684
G1 X139.076 Y133.15 E.06054
G1 X142.107 Y133.158 E.09315
G1 X142.115 Y130.388 E.08509
G1 X142.074 Y130.103 E.00885
G1 X141.796 Y130.068 E.00861
G1 X138.755 Y130.06 E.09344
G3 X138.26 Y130.904 I-1.984 J-.597 E.03037
G1 X138.932 Y130.618 F30000
G1 F3230
G1 X139.065 Y130.64 E.00414
G1 X139.458 Y131.18 E.02053
G1 X139.454 Y132.774 E.04895
G1 X141.731 Y132.78 E.06998
G1 X141.737 Y130.445 E.07173
G1 X139.028 Y130.438 E.08326
G1 X138.96 Y130.565 E.00443
G1 X139.569 Y130.816 F30000
G1 F3230
G1 X139.835 Y131.181 E.01387
G1 X139.832 Y132.397 E.03737
G1 X141.355 Y132.402 E.0468
G1 X141.359 Y130.821 E.04856
G1 X139.629 Y130.817 E.05315
G1 X140.212 Y131.195 F30000
G1 F3230
G1 X140.21 Y132.021 E.02539
G1 X140.979 Y132.023 E.02363
G1 X140.981 Y131.197 E.02539
G1 X140.272 Y131.195 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 13.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.981 Y131.197 E-.26947
G1 X140.979 Y132.023 E-.31396
G1 X140.514 Y132.022 E-.17658
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 66/118
; update layer progress
M73 L66
M991 S0 P65 ;notify layer change
G17
G3 Z13.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.287 Y131.378
G1 Z13.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.282 Y133.537 E.07161
G1 X113.466 Y133.527 E.12657
G1 X113.474 Y130.316 E.10649
G3 X113.596 Y129.77 I.854 J-.096 E.01891
G3 X113.906 Y129.664 I.362 J.553 E.01096
G1 X117.517 Y129.665 E.11978
G2 X117.868 Y130.493 I2.396 J-.528 E.03001
G2 X118.844 Y131.13 I1.523 J-1.268 E.03924
G1 X119.01 Y131.161 E.00561
G1 X118.989 Y131.383 E.00739
G1 X117.347 Y131.378 E.05447
; WIPE_START
G1 F16213.044
G1 X117.286 Y133.377 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.873 Y132.541 Z13.6 F30000
G1 X136.966 Y131.209 Z13.6
G1 Z13.2
G1 E.8 F1800
G1 F3230
G2 X137.836 Y130.831 I-.412 J-2.139 E.03172
G1 X138.112 Y130.547 E.01313
G2 X138.468 Y129.721 I-2.039 J-1.368 E.03002
G1 X141.887 Y129.73 E.11342
G3 X142.388 Y129.847 I.091 J.738 E.01741
G3 X142.498 Y130.192 I-.665 J.403 E.01212
G1 X142.498 Y133.604 E.1132
G1 X138.682 Y133.594 E.12657
G1 X138.688 Y131.435 E.07161
G1 X136.986 Y131.431 E.05646
G1 X136.972 Y131.269 E.0054
; WIPE_START
G1 F16213.044
G1 X137.133 Y131.178 E-.07017
G1 X137.503 Y131.041 E-.15019
G1 X137.836 Y130.831 E-.14967
G1 X138.112 Y130.547 E-.15042
G1 X138.316 Y130.201 E-.15248
G1 X138.385 Y129.983 E-.08707
; WIPE_END
G1 E-.04 F1800
G1 X130.781 Y130.64 Z13.6 F30000
G1 X117.678 Y131.771 Z13.6
G1 Z13.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.673 Y133.918 E.06596
G1 X117.673 Y133.93 E.00038
G1 X113.073 Y133.918 E.14134
G1 X113.073 Y133.906 E.00038
G1 X113.082 Y130.307 E.11058
G3 X113.314 Y129.495 I1.167 J-.106 E.02652
G3 X113.866 Y129.274 I.611 J.722 E.01862
G1 X117.858 Y129.274 E.12266
G2 X118.393 Y130.473 I1.691 J-.035 E.04145
G2 X119.289 Y130.815 I1.102 J-1.545 E.02979
G1 X119.663 Y130.836 E.0115
G1 X136.315 Y130.88 E.51168
G2 X137.329 Y130.688 I.036 J-2.578 E.03191
G2 X138.054 Y129.762 I-.644 J-1.252 E.03729
G2 X138.129 Y129.328 I-3.088 J-.751 E.01356
G1 X141.897 Y129.338 E.1158
G3 X142.672 Y129.574 I.1 J1.062 E.02552
G3 X142.899 Y130.386 I-.94 J.7 E.02651
G1 X142.889 Y133.985 E.11058
G1 X142.889 Y133.997 E.00038
G1 X138.289 Y133.985 E.14134
G1 X138.289 Y133.973 E.00038
G1 X138.295 Y131.826 E.06596
G1 X138.254 Y131.826 E.00126
G1 X117.738 Y131.771 E.6304
M204 S10000
G1 X118.169 Y131.066 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107468
G1 F3230
G2 X118.322 Y131.158 I.185 J-.133 E.00096
G1 X117.736 Y130.921 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.542 Y130.712 E.00879
G1 X117.298 Y130.285 E.0151
G1 X117.227 Y130.056 E.00735
G1 X114.14 Y130.048 E.09487
G1 X113.909 Y130.082 E.00715
G1 X113.866 Y130.368 E.00888
G1 X113.859 Y133.136 E.08505
G1 X116.89 Y133.144 E.09315
G1 X116.896 Y131.174 E.06054
G1 X117.037 Y130.992 E.00708
G1 X117.731 Y130.977 E.02131
G1 X117.048 Y130.613 F30000
G1 F3230
G1 X116.953 Y130.432 E.00627
G1 X114.243 Y130.425 E.08326
G1 X114.237 Y132.76 E.07173
G1 X116.514 Y132.766 E.06998
G1 X116.519 Y131.173 E.04895
G1 X116.915 Y130.634 E.02053
G1 X116.989 Y130.623 E.00229
G1 X116.409 Y130.808 F30000
G1 F3230
G1 X114.619 Y130.803 E.055
G1 X114.615 Y132.384 E.04856
G1 X116.138 Y132.388 E.0468
G1 X116.142 Y131.172 E.03737
G1 X116.374 Y130.856 E.01203
G1 X115.764 Y131.183 F30000
G1 F3230
G1 X114.995 Y131.181 E.02363
G1 X114.993 Y132.008 E.02539
G1 X115.762 Y132.01 E.02363
G1 X115.764 Y131.243 E.02354
; WIPE_START
G1 F15000
G1 X115.762 Y132.01 E-.29115
G1 X114.993 Y132.008 E-.29227
G1 X114.994 Y131.543 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.195 Y131.293 Z13.6 F30000
G1 Z13.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.657 Y131.306 E.02066
G1 X136.781 Y131.34 E.76601
G1 X137.655 Y131.209 F30000
; LINE_WIDTH: 0.107422
G1 F3230
G2 X137.807 Y131.118 I-.031 J-.225 E.00096
G1 X138.217 Y131.001 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.269 Y131.042 E.00202
G1 X138.95 Y131.052 E.02092
G1 X139.081 Y131.233 E.00684
G1 X139.076 Y133.203 E.06054
G1 X142.107 Y133.211 E.09315
G1 X142.114 Y130.442 E.08509
G1 X142.074 Y130.156 E.00885
G1 X141.796 Y130.121 E.00861
G1 X138.755 Y130.113 E.09344
G3 X138.259 Y130.958 I-1.985 J-.597 E.03038
G1 X138.932 Y130.671 F30000
G1 F3230
G1 X139.065 Y130.693 E.00414
G1 X139.458 Y131.234 E.02053
G1 X139.454 Y132.827 E.04895
G1 X141.731 Y132.833 E.06998
G1 X141.737 Y130.498 E.07173
G1 X139.028 Y130.491 E.08326
G1 X138.96 Y130.618 E.00443
G1 X139.569 Y130.87 F30000
G1 F3230
G1 X139.835 Y131.235 E.01387
G1 X139.832 Y132.451 E.03737
G1 X141.355 Y132.455 E.0468
G1 X141.359 Y130.874 E.04856
G1 X139.629 Y130.87 E.05316
G1 X140.212 Y131.248 F30000
G1 F3230
G1 X140.21 Y132.075 E.02539
G1 X140.979 Y132.077 E.02363
G1 X140.981 Y131.25 E.02539
G1 X140.272 Y131.249 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 13.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.981 Y131.25 E-.26947
G1 X140.979 Y132.077 E-.31396
G1 X140.514 Y132.075 E-.17658
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 67/118
; update layer progress
M73 L67
M991 S0 P66 ;notify layer change
G17
G3 Z13.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.287 Y131.431
G1 Z13.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.281 Y133.59 E.07161
G1 X113.466 Y133.58 E.12657
G1 X113.474 Y130.37 E.10649
G3 X113.596 Y129.824 I.854 J-.096 E.0189
G3 X113.905 Y129.718 I.362 J.552 E.01095
G1 X117.516 Y129.718 E.11979
G2 X117.868 Y130.546 I2.396 J-.528 E.03001
G2 X118.844 Y131.183 I1.523 J-1.269 E.03924
G1 X119.01 Y131.214 E.00561
G1 X118.989 Y131.436 E.00739
G1 X117.347 Y131.432 E.05447
; WIPE_START
G1 F16213.044
G1 X117.286 Y133.431 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.873 Y132.595 Z13.8 F30000
G1 X136.966 Y131.262 Z13.8
G1 Z13.4
G1 E.8 F1800
G1 F3218
G2 X137.836 Y130.884 I-.413 J-2.14 E.03172
G1 X138.112 Y130.6 E.01313
G2 X138.468 Y129.774 I-2.037 J-1.367 E.03002
G1 X141.887 Y129.783 E.11343
G3 X142.388 Y129.9 I.091 J.738 E.01741
G3 X142.498 Y130.245 I-.666 J.403 E.01211
G1 X142.498 Y133.657 E.1132
G1 X138.682 Y133.647 E.12657
G1 X138.688 Y131.488 E.07161
G1 X136.986 Y131.484 E.05646
G1 X136.971 Y131.322 E.00539
; WIPE_START
G1 F16213.044
G1 X137.132 Y131.231 E-.07014
G1 X137.503 Y131.095 E-.15019
G1 X137.836 Y130.884 E-.14966
G1 X138.112 Y130.6 E-.15045
G1 X138.316 Y130.254 E-.15253
G1 X138.385 Y130.036 E-.08703
; WIPE_END
G1 E-.04 F1800
G1 X130.781 Y130.693 Z13.8 F30000
G1 X117.678 Y131.825 Z13.8
G1 Z13.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.672 Y133.971 E.06596
G1 X117.672 Y133.983 E.00038
G1 X113.073 Y133.971 E.14134
G1 X113.073 Y133.959 E.00038
G1 X113.082 Y130.36 E.11058
G3 X113.313 Y129.549 I1.167 J-.106 E.02652
G3 X113.866 Y129.327 I.611 J.723 E.01861
G1 X117.858 Y129.327 E.12266
G2 X118.393 Y130.527 I1.69 J-.035 E.04145
G2 X119.289 Y130.868 I1.102 J-1.545 E.0298
G1 X119.663 Y130.889 E.0115
G1 X136.315 Y130.933 E.51168
G2 X137.329 Y130.741 I.036 J-2.578 E.03191
G2 X138.054 Y129.816 I-.644 J-1.252 E.03728
G2 X138.128 Y129.381 I-3.066 J-.748 E.01357
G1 X141.897 Y129.391 E.11581
G3 X142.672 Y129.627 I.1 J1.061 E.02552
G3 X142.899 Y130.439 I-.94 J.7 E.02651
G1 X142.889 Y134.038 E.11058
G1 X142.889 Y134.05 E.00038
G1 X138.289 Y134.038 E.14134
G1 X138.289 Y134.026 E.00038
G1 X138.295 Y131.879 E.06596
G1 X138.254 Y131.879 E.00126
G1 X117.738 Y131.825 E.6304
M204 S10000
G1 X118.169 Y131.119 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107456
G1 F3218
G2 X118.321 Y131.211 I.185 J-.133 E.00096
G1 X117.736 Y130.975 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.542 Y130.765 E.00879
G1 X117.298 Y130.338 E.0151
G1 X117.227 Y130.109 E.00735
G1 X114.141 Y130.101 E.09484
G1 X113.909 Y130.136 E.00718
G1 X113.866 Y130.421 E.00888
G1 X113.859 Y133.189 E.08505
G1 X116.89 Y133.197 E.09315
G1 X116.896 Y131.227 E.06054
G1 X117.037 Y131.045 E.00708
G1 X117.73 Y131.03 E.02131
G1 X117.048 Y130.667 F30000
G1 F3218
G1 X116.953 Y130.486 E.00627
G1 X114.243 Y130.479 E.08326
G1 X114.237 Y132.813 E.07173
G1 X116.514 Y132.819 E.06998
G1 X116.519 Y131.226 E.04895
G1 X116.915 Y130.688 E.02053
G1 X116.988 Y130.676 E.00229
G1 X116.409 Y130.861 F30000
G1 F3218
G1 X114.619 Y130.857 E.055
G1 X114.615 Y132.437 E.04856
G1 X116.138 Y132.441 E.0468
G1 X116.141 Y131.225 E.03737
G1 X116.373 Y130.91 E.01203
G1 X115.764 Y131.237 F30000
G1 F3218
G1 X114.995 Y131.235 E.02363
G1 X114.993 Y132.061 E.02539
G1 X115.762 Y132.063 E.02363
G1 X115.764 Y131.297 E.02354
; WIPE_START
G1 F15000
G1 X115.762 Y132.063 E-.29115
G1 X114.993 Y132.061 E-.29226
G1 X114.994 Y131.596 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.195 Y131.346 Z13.8 F30000
G1 Z13.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591851
G1 F3218
G1 X136.319 Y131.404 E.766
G1 X136.781 Y131.393 E.02066
G1 X137.655 Y131.263 F30000
; LINE_WIDTH: 0.107461
G1 F3218
G2 X137.808 Y131.171 I-.031 J-.226 E.00096
G1 X138.218 Y131.054 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.269 Y131.095 E.00203
G1 X138.95 Y131.106 E.02091
G1 X139.081 Y131.286 E.00684
G1 X139.075 Y133.256 E.06054
G1 X142.107 Y133.264 E.09315
G1 X142.114 Y130.495 E.08509
G1 X142.074 Y130.21 E.00885
G1 X141.796 Y130.175 E.00861
G1 X138.755 Y130.167 E.09344
G3 X138.259 Y131.011 I-1.985 J-.597 E.03037
G1 X138.932 Y130.725 F30000
G1 F3218
G1 X139.064 Y130.747 E.00414
G1 X139.458 Y131.287 E.02053
G1 X139.453 Y132.88 E.04895
G1 X141.731 Y132.886 E.06998
G1 X141.737 Y130.552 E.07173
M73 P76 R4
G1 X139.027 Y130.544 E.08326
G1 X138.96 Y130.672 E.00443
G1 X139.569 Y130.923 F30000
G1 F3218
G1 X139.835 Y131.288 E.01387
G1 X139.832 Y132.504 E.03737
G1 X141.355 Y132.508 E.0468
G1 X141.359 Y130.928 E.04856
G1 X139.629 Y130.923 E.05316
G1 X140.212 Y131.302 F30000
G1 F3218
G1 X140.21 Y132.128 E.02539
G1 X140.979 Y132.13 E.02363
G1 X140.981 Y131.304 E.02539
G1 X140.272 Y131.302 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 13.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X140.981 Y131.304 E-.26947
G1 X140.979 Y132.13 E-.31396
G1 X140.514 Y132.129 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 68/118
; update layer progress
M73 L68
M991 S0 P67 ;notify layer change
G17
G3 Z13.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.287 Y131.485
G1 Z13.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.281 Y133.643 E.07161
G1 X113.466 Y133.633 E.12657
G1 X113.474 Y130.423 E.1065
G3 X113.596 Y129.877 I.854 J-.096 E.0189
G3 X113.905 Y129.771 I.362 J.553 E.01095
G1 X117.516 Y129.771 E.11979
G2 X117.868 Y130.599 I2.394 J-.527 E.03001
G2 X118.844 Y131.236 I1.523 J-1.269 E.03924
G1 X119.01 Y131.268 E.00561
G1 X118.989 Y131.489 E.00739
G1 X117.347 Y131.485 E.05447
; WIPE_START
G1 F16213.044
G1 X117.286 Y133.484 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.873 Y132.648 Z14 F30000
G1 X136.966 Y131.315 Z14
G1 Z13.6
G1 E.8 F1800
G1 F3230
G2 X137.836 Y130.937 I-.412 J-2.139 E.03172
G1 X138.112 Y130.653 E.01313
G2 X138.468 Y129.827 I-2.036 J-1.366 E.03001
G1 X141.887 Y129.836 E.11343
G3 X142.387 Y129.954 I.091 J.738 E.01741
G3 X142.498 Y130.298 I-.666 J.403 E.01211
G1 X142.498 Y133.711 E.1132
G1 X138.682 Y133.7 E.12657
G1 X138.688 Y131.542 E.07161
G1 X136.986 Y131.537 E.05646
G1 X136.971 Y131.375 E.0054
; WIPE_START
G1 F16213.044
G1 X137.132 Y131.285 E-.07015
G1 X137.503 Y131.148 E-.1502
G1 X137.836 Y130.937 E-.14968
G1 X138.112 Y130.653 E-.15043
G1 X138.316 Y130.308 E-.15257
G1 X138.385 Y130.089 E-.08697
; WIPE_END
G1 E-.04 F1800
G1 X130.781 Y130.746 Z14 F30000
G1 X117.678 Y131.878 Z14
G1 Z13.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.672 Y134.024 E.06596
G1 X117.672 Y134.037 E.00038
G1 X113.072 Y134.024 E.14134
G1 X113.072 Y134.012 E.00038
G1 X113.082 Y130.413 E.11058
G3 X113.313 Y129.602 I1.167 J-.106 E.02652
G3 X113.866 Y129.38 I.611 J.723 E.01861
G1 X117.858 Y129.38 E.12266
G2 X118.393 Y130.58 I1.69 J-.034 E.04145
G2 X119.289 Y130.921 I1.102 J-1.545 E.0298
G1 X119.663 Y130.942 E.0115
G1 X136.315 Y130.987 E.51168
G2 X137.328 Y130.794 I.036 J-2.578 E.03191
G2 X138.054 Y129.869 I-.644 J-1.252 E.03727
G2 X138.128 Y129.434 I-3.054 J-.746 E.01358
G1 X141.897 Y129.444 E.11581
G3 X142.672 Y129.68 I.1 J1.061 E.02552
G3 X142.898 Y130.493 I-.94 J.7 E.02651
G1 X142.889 Y134.091 E.11058
G1 X142.889 Y134.104 E.00038
G1 X138.289 Y134.091 E.14134
G1 X138.289 Y134.079 E.00038
G1 X138.295 Y131.933 E.06596
G1 X138.254 Y131.932 E.00126
G1 X117.738 Y131.878 E.6304
M204 S10000
G1 X118.169 Y131.172 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10746
G1 F3230
G2 X118.321 Y131.264 I.185 J-.133 E.00096
G1 X117.736 Y131.028 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.541 Y130.818 E.0088
G1 X117.298 Y130.391 E.0151
G1 X117.227 Y130.163 E.00734
G1 X114.141 Y130.154 E.09482
G1 X113.909 Y130.189 E.00721
G1 X113.866 Y130.474 E.00887
G1 X113.859 Y133.242 E.08505
G1 X116.89 Y133.25 E.09315
G1 X116.895 Y131.28 E.06054
G1 X117.037 Y131.098 E.00708
G1 X117.73 Y131.083 E.02131
G1 X117.048 Y130.72 F30000
G1 F3230
G1 X116.953 Y130.539 E.00627
G1 X114.243 Y130.532 E.08326
G1 X114.237 Y132.866 E.07173
G1 X116.514 Y132.872 E.06998
G1 X116.518 Y131.279 E.04895
G1 X116.915 Y130.741 E.02053
G1 X116.988 Y130.729 E.00229
G1 X116.409 Y130.915 F30000
G1 F3230
G1 X114.619 Y130.91 E.055
G1 X114.615 Y132.49 E.04856
G1 X116.138 Y132.494 E.0468
G1 X116.141 Y131.278 E.03737
G1 X116.373 Y130.963 E.01203
G1 X115.764 Y131.29 F30000
G1 F3230
G1 X114.995 Y131.288 E.02363
G1 X114.993 Y132.114 E.02539
G1 X115.762 Y132.116 E.02363
G1 X115.764 Y131.35 E.02354
; WIPE_START
G1 F15000
G1 X115.762 Y132.116 E-.29115
G1 X114.993 Y132.114 E-.29226
G1 X114.994 Y131.649 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.195 Y131.399 Z14 F30000
G1 Z13.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591871
G1 F3230
G1 X119.656 Y131.413 E.02066
G1 X136.781 Y131.446 E.76602
G1 X137.655 Y131.316 F30000
; LINE_WIDTH: 0.107429
G1 F3230
G2 X137.807 Y131.225 I-.031 J-.225 E.00096
G1 X138.217 Y131.107 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.269 Y131.148 E.00202
G1 X138.949 Y131.159 E.02092
G1 X139.081 Y131.339 E.00684
G1 X139.075 Y133.309 E.06054
G1 X142.107 Y133.317 E.09315
G1 X142.114 Y130.548 E.08509
G1 X142.074 Y130.263 E.00885
G1 X141.796 Y130.228 E.00861
G1 X138.755 Y130.22 E.09344
G3 X138.259 Y131.064 I-1.985 J-.597 E.03038
G1 X138.931 Y130.778 F30000
G1 F3230
G1 X139.064 Y130.8 E.00414
G1 X139.458 Y131.34 E.02053
G1 X139.453 Y132.933 E.04895
G1 X141.731 Y132.939 E.06998
G1 X141.737 Y130.605 E.07173
G1 X139.027 Y130.598 E.08326
G1 X138.96 Y130.725 E.00443
G1 X139.569 Y130.976 F30000
G1 F3230
G1 X139.835 Y131.341 E.01387
G1 X139.831 Y132.557 E.03737
G1 X141.355 Y132.561 E.0468
G1 X141.359 Y130.981 E.04856
G1 X139.629 Y130.976 E.05316
G1 X140.212 Y131.355 F30000
G1 F3230
G1 X140.209 Y132.181 E.02539
G1 X140.979 Y132.183 E.02363
G1 X140.981 Y131.357 E.02539
G1 X140.272 Y131.355 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 13.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.981 Y131.357 E-.26947
G1 X140.979 Y132.183 E-.31396
G1 X140.514 Y132.182 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 69/118
; update layer progress
M73 L69
M991 S0 P68 ;notify layer change
G17
G3 Z14 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.287 Y131.538
G1 Z13.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.281 Y133.697 E.07161
G1 X113.465 Y133.687 E.12657
G1 X113.474 Y130.476 E.1065
G3 X113.596 Y129.93 I.854 J-.096 E.0189
G3 X113.905 Y129.824 I.362 J.552 E.01096
G1 X117.516 Y129.825 E.11979
G2 X117.868 Y130.653 I2.393 J-.527 E.03001
G2 X118.844 Y131.289 I1.523 J-1.269 E.03924
G1 X119.01 Y131.321 E.00561
G1 X118.989 Y131.542 E.00738
G1 X117.347 Y131.538 E.05447
; WIPE_START
G1 F16213.044
G1 X117.286 Y133.537 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.872 Y132.701 Z14.2 F30000
G1 X136.966 Y131.369 Z14.2
G1 Z13.8
G1 E.8 F1800
G1 F3230
G2 X137.836 Y130.991 I-.413 J-2.14 E.03172
G1 X138.112 Y130.707 E.01314
G2 X138.467 Y129.88 I-2.035 J-1.366 E.03001
G1 X141.887 Y129.889 E.11343
G3 X142.387 Y130.007 I.091 J.738 E.01741
G3 X142.498 Y130.351 I-.666 J.404 E.01211
G1 X142.498 Y133.764 E.1132
G1 X138.682 Y133.754 E.12657
G1 X138.688 Y131.595 E.07161
G1 X136.986 Y131.59 E.05646
G1 X136.971 Y131.428 E.00539
; WIPE_START
G1 F16213.044
G1 X137.132 Y131.338 E-.07015
G1 X137.503 Y131.201 E-.1502
G1 X137.836 Y130.991 E-.14965
G1 X138.112 Y130.707 E-.1505
G1 X138.316 Y130.361 E-.15258
G1 X138.385 Y130.143 E-.08693
; WIPE_END
G1 E-.04 F1800
G1 X130.78 Y130.799 Z14.2 F30000
G1 X117.678 Y131.931 Z14.2
G1 Z13.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.672 Y134.078 E.06596
G1 X117.672 Y134.09 E.00038
G1 X113.072 Y134.078 E.14134
G1 X113.072 Y134.065 E.00038
G1 X113.082 Y130.467 E.11058
G3 X113.313 Y129.655 I1.167 J-.106 E.02651
G3 X113.866 Y129.433 I.611 J.722 E.01861
G1 X117.858 Y129.433 E.12266
G2 X118.393 Y130.633 I1.689 J-.034 E.04145
G2 X119.289 Y130.975 I1.102 J-1.545 E.0298
G1 X119.663 Y130.996 E.0115
G1 X136.315 Y131.04 E.51168
G2 X137.328 Y130.848 I.036 J-2.578 E.03191
G2 X138.054 Y129.923 I-.644 J-1.252 E.03725
G2 X138.128 Y129.487 I-3.029 J-.742 E.01359
G1 X141.897 Y129.497 E.11581
G3 X142.672 Y129.733 I.1 J1.062 E.02552
G3 X142.898 Y130.546 I-.94 J.7 E.02651
G1 X142.889 Y134.145 E.11058
G1 X142.889 Y134.157 E.00038
G1 X138.289 Y134.145 E.14134
G1 X138.289 Y134.132 E.00038
G1 X138.295 Y131.986 E.06596
G1 X138.254 Y131.986 E.00126
G1 X117.738 Y131.931 E.6304
M204 S10000
G1 X118.169 Y131.225 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107461
G1 F3230
G2 X118.321 Y131.318 I.185 J-.133 E.00096
G1 X117.736 Y131.081 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.541 Y130.871 E.0088
G1 X117.298 Y130.444 E.01511
G1 X117.227 Y130.216 E.00734
G1 X114.142 Y130.208 E.09478
G1 X113.909 Y130.242 E.00725
G1 X113.866 Y130.528 E.00887
G1 X113.859 Y133.296 E.08505
G1 X116.89 Y133.304 E.09315
G1 X116.895 Y131.333 E.06054
G1 X117.037 Y131.151 E.00708
G1 X117.73 Y131.136 E.02132
G1 X117.047 Y130.773 F30000
G1 F3230
G1 X116.953 Y130.592 E.00627
G1 X114.243 Y130.585 E.08326
G1 X114.237 Y132.919 E.07173
G1 X116.514 Y132.926 E.06998
G1 X116.518 Y131.332 E.04895
G1 X116.914 Y130.794 E.02053
G1 X116.988 Y130.782 E.00229
G1 X116.409 Y130.968 F30000
G1 F3230
G1 X114.619 Y130.963 E.055
G1 X114.615 Y132.543 E.04856
G1 X116.138 Y132.547 E.0468
G1 X116.141 Y131.331 E.03737
G1 X116.373 Y131.016 E.01203
G1 X115.764 Y131.343 F30000
G1 F3230
G1 X114.995 Y131.341 E.02363
G1 X114.993 Y132.167 E.02539
G1 X115.762 Y132.169 E.02363
G1 X115.764 Y131.403 E.02354
; WIPE_START
G1 F15000
G1 X115.762 Y132.169 E-.29115
G1 X114.993 Y132.167 E-.29226
G1 X114.994 Y131.703 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.194 Y131.453 Z14.2 F30000
G1 Z13.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.656 Y131.466 E.02066
G1 X136.781 Y131.499 E.76601
G1 X137.655 Y131.369 F30000
; LINE_WIDTH: 0.107463
G1 F3230
G2 X137.807 Y131.278 I-.031 J-.226 E.00096
G1 X138.217 Y131.16 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.269 Y131.202 E.00204
G1 X138.949 Y131.212 E.0209
G1 X139.08 Y131.392 E.00684
G1 X139.075 Y133.363 E.06054
G1 X142.107 Y133.371 E.09315
G1 X142.114 Y130.601 E.08509
G1 X142.074 Y130.316 E.00885
G1 X141.796 Y130.281 E.00861
G1 X138.755 Y130.273 E.09344
G3 X138.259 Y131.117 I-1.986 J-.598 E.03037
G1 X138.931 Y130.831 F30000
G1 F3230
G1 X139.064 Y130.853 E.00414
G1 X139.457 Y131.393 E.02053
G1 X139.453 Y132.987 E.04895
G1 X141.731 Y132.993 E.06998
G1 X141.737 Y130.658 E.07173
G1 X139.027 Y130.651 E.08326
G1 X138.959 Y130.778 E.00443
G1 X139.569 Y131.029 F30000
G1 F3230
G1 X139.835 Y131.394 E.01387
G1 X139.831 Y132.61 E.03737
G1 X141.355 Y132.615 E.0468
G1 X141.359 Y131.034 E.04856
G1 X139.629 Y131.03 E.05316
G1 X140.212 Y131.408 F30000
G1 F3230
G1 X140.209 Y132.234 E.02539
G1 X140.978 Y132.236 E.02363
G1 X140.981 Y131.41 E.02539
G1 X140.272 Y131.408 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 14
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.981 Y131.41 E-.26947
G1 X140.978 Y132.236 E-.31396
G1 X140.514 Y132.235 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 70/118
; update layer progress
M73 L70
M991 S0 P69 ;notify layer change
G17
G3 Z14.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.287 Y131.591
G1 Z14
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.281 Y133.75 E.07161
G1 X113.465 Y133.74 E.12657
G1 X113.474 Y130.529 E.10649
G3 X113.596 Y129.983 I.855 J-.096 E.0189
G3 X113.905 Y129.878 I.362 J.551 E.01095
G1 X117.516 Y129.878 E.1198
G2 X117.867 Y130.706 I2.393 J-.527 E.03001
G2 X118.844 Y131.343 I1.523 J-1.269 E.03924
G1 X119.01 Y131.374 E.00561
G1 X118.989 Y131.596 E.00739
G1 X117.347 Y131.591 E.05447
; WIPE_START
G1 F16213.044
G1 X117.286 Y133.59 E-.76
; WIPE_END
M73 P77 R4
G1 E-.04 F1800
G1 X124.872 Y132.754 Z14.4 F30000
G1 X136.966 Y131.422 Z14.4
G1 Z14
G1 E.8 F1800
G1 F3218
G2 X137.836 Y131.044 I-.413 J-2.14 E.03172
G1 X138.112 Y130.76 E.01313
G2 X138.467 Y129.934 I-2.031 J-1.364 E.03001
G1 X141.887 Y129.943 E.11343
G3 X142.387 Y130.06 I.091 J.738 E.01741
G3 X142.498 Y130.405 I-.666 J.403 E.01211
G1 X142.498 Y133.817 E.1132
G1 X138.682 Y133.807 E.12657
G1 X138.688 Y131.648 E.07161
G1 X136.986 Y131.644 E.05646
G1 X136.971 Y131.482 E.00539
; WIPE_START
G1 F16213.044
G1 X137.132 Y131.391 E-.07012
G1 X137.503 Y131.254 E-.15022
G1 X137.836 Y131.044 E-.14966
G1 X138.112 Y130.76 E-.15045
G1 X138.316 Y130.414 E-.15267
G1 X138.384 Y130.196 E-.08688
; WIPE_END
G1 E-.04 F1800
G1 X130.78 Y130.853 Z14.4 F30000
G1 X117.678 Y131.984 Z14.4
G1 Z14
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.672 Y134.131 E.06596
G1 X117.672 Y134.143 E.00038
G1 X113.072 Y134.131 E.14134
G1 X113.072 Y134.119 E.00038
G1 X113.082 Y130.52 E.11058
G3 X113.313 Y129.709 I1.167 J-.106 E.02651
G3 X113.865 Y129.487 I.611 J.722 E.01861
G1 X117.857 Y129.487 E.12266
G2 X118.392 Y130.686 I1.688 J-.034 E.04146
G2 X119.289 Y131.028 I1.102 J-1.545 E.02979
G1 X119.662 Y131.049 E.0115
G1 X136.315 Y131.093 E.51168
G2 X137.328 Y130.901 I.036 J-2.577 E.03191
G2 X138.053 Y129.976 I-.644 J-1.252 E.03724
G2 X138.128 Y129.541 I-3.018 J-.741 E.0136
G1 X141.897 Y129.551 E.11581
G3 X142.671 Y129.787 I.1 J1.061 E.02552
G3 X142.898 Y130.599 I-.94 J.7 E.02651
G1 X142.889 Y134.198 E.11058
G1 X142.889 Y134.21 E.00038
G1 X138.289 Y134.198 E.14134
G1 X138.289 Y134.186 E.00038
G1 X138.295 Y132.039 E.06596
G1 X138.254 Y132.039 E.00126
G1 X117.738 Y131.984 E.6304
M204 S10000
G1 X118.169 Y131.279 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.10745
G1 F3218
G2 X118.321 Y131.371 I.185 J-.133 E.00096
G1 X117.736 Y131.135 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.541 Y130.924 E.00881
G1 X117.298 Y130.497 E.01511
G1 X117.227 Y130.269 E.00733
G1 X114.143 Y130.261 E.09475
G1 X113.909 Y130.296 E.00728
G1 X113.866 Y130.581 E.00887
G1 X113.858 Y133.349 E.08505
G1 X116.89 Y133.357 E.09315
G1 X116.895 Y131.387 E.06054
G1 X117.036 Y131.205 E.00708
G1 X117.73 Y131.19 E.02132
G1 X117.047 Y130.826 F30000
G1 F3218
G1 X116.952 Y130.645 E.00627
G1 X114.243 Y130.638 E.08326
G1 X114.236 Y132.973 E.07173
G1 X116.514 Y132.979 E.06998
G1 X116.518 Y131.386 E.04895
G1 X116.914 Y130.847 E.02054
G1 X116.988 Y130.836 E.00229
G1 X116.409 Y131.021 F30000
G1 F3218
G1 X114.619 Y131.016 E.055
G1 X114.615 Y132.597 E.04856
G1 X116.138 Y132.601 E.0468
G1 X116.141 Y131.385 E.03737
G1 X116.373 Y131.069 E.01203
G1 X115.764 Y131.396 F30000
G1 F3218
G1 X114.995 Y131.394 E.02363
G1 X114.993 Y132.221 E.02539
G1 X115.762 Y132.223 E.02363
G1 X115.764 Y131.456 E.02354
; WIPE_START
G1 F15000
G1 X115.762 Y132.223 E-.29115
G1 X114.993 Y132.221 E-.29227
G1 X114.994 Y131.756 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.194 Y131.506 Z14.4 F30000
G1 Z14
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591852
G1 F3218
G1 X136.319 Y131.563 E.766
G1 X136.781 Y131.553 E.02066
G1 X137.654 Y131.422 F30000
; LINE_WIDTH: 0.10745
G1 F3218
G2 X137.807 Y131.331 I-.031 J-.225 E.00096
G1 X138.217 Y131.214 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.269 Y131.255 E.00203
G1 X138.949 Y131.266 E.02091
G1 X139.08 Y131.446 E.00684
G1 X139.075 Y133.416 E.06054
G1 X142.107 Y133.424 E.09315
G1 X142.114 Y130.655 E.08509
G1 X142.073 Y130.369 E.00885
G1 X141.795 Y130.334 E.00861
G1 X138.754 Y130.326 E.09344
G3 X138.259 Y131.171 I-1.986 J-.598 E.03037
G1 X138.931 Y130.884 F30000
G1 F3218
G1 X139.064 Y130.906 E.00414
G1 X139.457 Y131.447 E.02053
G1 X139.453 Y133.04 E.04895
G1 X141.73 Y133.046 E.06998
G1 X141.737 Y130.711 E.07173
G1 X139.027 Y130.704 E.08326
G1 X138.959 Y130.831 E.00443
G1 X139.569 Y131.083 F30000
G1 F3218
G1 X139.834 Y131.448 E.01387
G1 X139.831 Y132.664 E.03737
G1 X141.354 Y132.668 E.0468
G1 X141.359 Y131.087 E.04856
G1 X139.629 Y131.083 E.05316
G1 X140.211 Y131.461 F30000
G1 F3218
G1 X140.209 Y132.288 E.02539
G1 X140.978 Y132.29 E.02363
G1 X140.981 Y131.463 E.02539
G1 X140.271 Y131.462 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 14.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.981 Y131.463 E-.26947
G1 X140.978 Y132.29 E-.31396
G1 X140.514 Y132.288 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 71/118
; update layer progress
M73 L71
M991 S0 P70 ;notify layer change
G17
G3 Z14.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.287 Y131.644
G1 Z14.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.281 Y133.803 E.07161
G1 X113.465 Y133.793 E.12657
G1 X113.474 Y130.583 E.10649
G3 X113.595 Y130.037 I.854 J-.096 E.0189
G3 X113.905 Y129.931 I.362 J.552 E.01095
G1 X117.516 Y129.931 E.1198
G2 X117.867 Y130.759 I2.39 J-.525 E.03001
G2 X118.844 Y131.396 I1.523 J-1.269 E.03924
G1 X119.01 Y131.427 E.00561
G1 X118.989 Y131.649 E.00738
G1 X117.347 Y131.645 E.05447
; WIPE_START
G1 F16213.044
G1 X117.286 Y133.644 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.872 Y132.808 Z14.6 F30000
G1 X136.965 Y131.475 Z14.6
G1 Z14.2
G1 E.8 F1800
G1 F3218
G2 X137.835 Y131.097 I-.413 J-2.14 E.03172
G1 X138.111 Y130.813 E.01314
G2 X138.467 Y129.987 I-2.032 J-1.364 E.03001
G1 X141.887 Y129.996 E.11343
G3 X142.387 Y130.113 I.091 J.738 E.01741
G3 X142.498 Y130.458 I-.666 J.404 E.01211
G1 X142.497 Y133.87 E.1132
G1 X138.682 Y133.86 E.12657
G1 X138.687 Y131.701 E.07161
G1 X136.985 Y131.697 E.05646
G1 X136.971 Y131.535 E.0054
; WIPE_START
G1 F16213.044
G1 X137.132 Y131.444 E-.07014
G1 X137.503 Y131.308 E-.15022
G1 X137.835 Y131.097 E-.14964
G1 X138.111 Y130.813 E-.15049
G1 X138.316 Y130.467 E-.1527
G1 X138.384 Y130.249 E-.08681
; WIPE_END
G1 E-.04 F1800
G1 X130.78 Y130.906 Z14.6 F30000
G1 X117.678 Y132.038 Z14.6
G1 Z14.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.672 Y134.184 E.06596
G1 X117.672 Y134.196 E.00038
G1 X113.072 Y134.184 E.14134
G1 X113.072 Y134.172 E.00038
G1 X113.082 Y130.573 E.11058
G3 X113.313 Y129.762 I1.167 J-.106 E.02652
G3 X113.865 Y129.54 I.611 J.722 E.01861
G1 X117.857 Y129.54 E.12266
G2 X118.392 Y130.74 I1.688 J-.033 E.04146
G2 X119.289 Y131.081 I1.102 J-1.545 E.02979
G1 X119.662 Y131.102 E.0115
G1 X136.315 Y131.146 E.51168
G2 X137.328 Y130.954 I.036 J-2.577 E.03191
G2 X138.053 Y130.03 I-.643 J-1.251 E.03723
G2 X138.128 Y129.594 I-2.994 J-.738 E.01361
M73 P77 R3
G1 X141.897 Y129.604 E.11581
G3 X142.671 Y129.84 I.1 J1.061 E.02552
G3 X142.898 Y130.652 I-.94 J.7 E.02651
G1 X142.888 Y134.251 E.11058
G1 X142.888 Y134.263 E.00038
G1 X138.289 Y134.251 E.14134
G1 X138.289 Y134.239 E.00038
G1 X138.294 Y132.092 E.06596
G1 X138.253 Y132.092 E.00126
G1 X117.738 Y132.038 E.6304
M204 S10000
G1 X118.169 Y131.332 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107444
G1 F3218
G2 X118.321 Y131.424 I.185 J-.133 E.00096
G1 X117.736 Y131.188 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.541 Y130.978 E.00881
G1 X117.297 Y130.55 E.01512
G1 X117.227 Y130.322 E.00733
G1 X114.144 Y130.314 E.09472
G1 X113.909 Y130.349 E.00731
G1 X113.866 Y130.634 E.00887
G1 X113.858 Y133.402 E.08505
G1 X116.89 Y133.41 E.09315
G1 X116.895 Y131.44 E.06054
G1 X117.036 Y131.258 E.00708
G1 X117.73 Y131.243 E.02132
G1 X117.047 Y130.88 F30000
G1 F3218
G1 X116.952 Y130.699 E.00627
G1 X114.243 Y130.692 E.08326
G1 X114.236 Y133.026 E.07173
G1 X116.514 Y133.032 E.06998
G1 X116.518 Y131.439 E.04895
G1 X116.914 Y130.901 E.02054
G1 X116.988 Y130.889 E.00229
G1 X116.409 Y131.074 F30000
G1 F3218
G1 X114.619 Y131.07 E.055
G1 X114.614 Y132.65 E.04856
G1 X116.138 Y132.654 E.0468
G1 X116.141 Y131.438 E.03737
G1 X116.373 Y131.123 E.01203
G1 X115.764 Y131.45 F30000
G1 F3218
G1 X114.995 Y131.448 E.02363
G1 X114.992 Y132.274 E.02539
G1 X115.762 Y132.276 E.02363
G1 X115.764 Y131.51 E.02354
; WIPE_START
G1 F15000
G1 X115.762 Y132.276 E-.29115
G1 X114.992 Y132.274 E-.29227
G1 X114.994 Y131.809 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.194 Y131.559 Z14.6 F30000
G1 Z14.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591871
G1 F3218
G1 X136.319 Y131.617 E.76602
G1 X136.78 Y131.606 E.02066
G1 X137.654 Y131.476 F30000
; LINE_WIDTH: 0.107472
G1 F3218
G2 X137.807 Y131.384 I-.031 J-.226 E.00096
G1 X138.217 Y131.267 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.269 Y131.308 E.00204
G1 X138.949 Y131.319 E.02089
G1 X139.08 Y131.499 E.00685
G1 X139.075 Y133.469 E.06054
G1 X142.106 Y133.477 E.09315
G1 X142.114 Y130.708 E.08509
G1 X142.073 Y130.423 E.00885
G1 X141.795 Y130.388 E.00861
G1 X138.754 Y130.38 E.09344
G3 X138.259 Y131.224 I-1.986 J-.598 E.03036
G1 X138.931 Y130.938 F30000
G1 F3218
G1 X139.064 Y130.96 E.00414
G1 X139.457 Y131.5 E.02054
G1 X139.453 Y133.093 E.04895
G1 X141.73 Y133.099 E.06998
G1 X141.737 Y130.765 E.07173
G1 X139.027 Y130.757 E.08326
G1 X138.959 Y130.885 E.00443
G1 X139.568 Y131.136 F30000
G1 F3218
G1 X139.834 Y131.501 E.01387
G1 X139.831 Y132.717 E.03737
G1 X141.354 Y132.721 E.0468
G1 X141.358 Y131.141 E.04856
G1 X139.628 Y131.136 E.05316
G1 X140.211 Y131.515 F30000
G1 F3218
G1 X140.209 Y132.341 E.02539
G1 X140.978 Y132.343 E.02363
G1 X140.98 Y131.517 E.02539
G1 X140.271 Y131.515 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 14.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.98 Y131.517 E-.26947
G1 X140.978 Y132.343 E-.31396
G1 X140.514 Y132.342 E-.17658
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 72/118
; update layer progress
M73 L72
M991 S0 P71 ;notify layer change
G17
G3 Z14.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.286 Y131.698
G1 Z14.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.281 Y133.856 E.07161
G1 X113.465 Y133.846 E.12657
G1 X113.474 Y130.636 E.10649
G3 X113.595 Y130.09 I.855 J-.096 E.0189
G3 X113.904 Y129.984 I.362 J.552 E.01095
G1 X117.516 Y129.984 E.11981
G2 X117.867 Y130.812 I2.388 J-.524 E.03001
G2 X118.843 Y131.449 I1.523 J-1.269 E.03924
G1 X119.01 Y131.481 E.00561
G1 X118.988 Y131.702 E.00739
G1 X117.346 Y131.698 E.05447
; WIPE_START
G1 F16213.044
G1 X117.286 Y133.697 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.872 Y132.861 Z14.8 F30000
G1 X136.965 Y131.528 Z14.8
G1 Z14.4
G1 E.8 F1800
G1 F3230
G2 X137.835 Y131.15 I-.412 J-2.139 E.03172
G1 X138.111 Y130.866 E.01313
G2 X138.467 Y130.04 I-2.03 J-1.364 E.03001
G1 X141.886 Y130.049 E.11343
G3 X142.387 Y130.166 I.091 J.738 E.01741
G3 X142.497 Y130.511 I-.666 J.403 E.01212
G1 X142.497 Y133.924 E.1132
G1 X138.682 Y133.913 E.12657
G1 X138.687 Y131.755 E.07161
G1 X136.985 Y131.75 E.05646
G1 X136.971 Y131.588 E.0054
; WIPE_START
G1 F16213.044
G1 X137.132 Y131.498 E-.07015
G1 X137.502 Y131.361 E-.15019
G1 X137.835 Y131.15 E-.14969
G1 X138.111 Y130.866 E-.15045
G1 X138.315 Y130.52 E-.15278
G1 X138.384 Y130.302 E-.08675
; WIPE_END
G1 E-.04 F1800
G1 X130.78 Y130.959 Z14.8 F30000
G1 X117.677 Y132.091 Z14.8
G1 Z14.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.672 Y134.237 E.06596
G1 X117.672 Y134.25 E.00038
G1 X113.072 Y134.237 E.14134
G1 X113.072 Y134.225 E.00038
G1 X113.081 Y130.626 E.11058
G3 X113.313 Y129.815 I1.167 J-.106 E.02652
G3 X113.865 Y129.593 I.611 J.722 E.01861
G1 X117.857 Y129.593 E.12266
G2 X118.392 Y130.793 I1.687 J-.033 E.04146
M73 P78 R3
G2 X119.288 Y131.134 I1.102 J-1.545 E.0298
G1 X119.662 Y131.155 E.0115
G1 X136.314 Y131.2 E.51168
G2 X137.328 Y131.007 I.036 J-2.578 E.03191
G2 X138.053 Y130.084 I-.643 J-1.251 E.03722
G2 X138.128 Y129.647 I-2.981 J-.736 E.01362
G1 X141.897 Y129.657 E.11581
G3 X142.671 Y129.893 I.1 J1.061 E.02552
G3 X142.898 Y130.706 I-.94 J.7 E.02651
G1 X142.888 Y134.304 E.11058
G1 X142.888 Y134.317 E.00038
G1 X138.288 Y134.304 E.14134
G1 X138.289 Y134.292 E.00038
G1 X138.294 Y132.146 E.06596
G1 X138.253 Y132.146 E.00126
G1 X117.737 Y132.091 E.6304
M204 S10000
G1 X118.169 Y131.385 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107439
G1 F3230
G2 X118.321 Y131.477 I.184 J-.133 E.00096
G1 X117.736 Y131.241 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.541 Y131.031 E.00882
G1 X117.297 Y130.603 E.01512
G1 X117.227 Y130.376 E.00732
G1 X114.145 Y130.367 E.09469
G1 X113.909 Y130.402 E.00734
G1 X113.865 Y130.687 E.00887
G1 X113.858 Y133.455 E.08505
G1 X116.89 Y133.463 E.09315
G1 X116.895 Y131.493 E.06054
G1 X117.036 Y131.311 E.00707
G1 X117.73 Y131.296 E.02132
G1 X117.047 Y130.933 F30000
G1 F3230
G1 X116.952 Y130.752 E.00627
G1 X114.242 Y130.745 E.08326
G1 X114.236 Y133.079 E.07173
G1 X116.514 Y133.085 E.06998
G1 X116.518 Y131.492 E.04895
G1 X116.914 Y130.954 E.02054
G1 X116.988 Y130.942 E.00229
G1 X116.408 Y131.128 F30000
G1 F3230
G1 X114.618 Y131.123 E.055
G1 X114.614 Y132.703 E.04856
G1 X116.138 Y132.707 E.0468
G1 X116.141 Y131.491 E.03737
G1 X116.373 Y131.176 E.01203
G1 X115.764 Y131.503 F30000
G1 F3230
G1 X114.995 Y131.501 E.02363
G1 X114.992 Y132.327 E.02539
G1 X115.761 Y132.329 E.02363
G1 X115.763 Y131.563 E.02354
; WIPE_START
G1 F15000
G1 X115.761 Y132.329 E-.29115
G1 X114.992 Y132.327 E-.29227
G1 X114.994 Y131.862 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.194 Y131.612 Z14.8 F30000
G1 Z14.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591871
G1 F3230
G1 X119.656 Y131.626 E.02066
G1 X136.78 Y131.659 E.76602
G1 X137.654 Y131.529 F30000
; LINE_WIDTH: 0.107454
G1 F3230
G2 X137.807 Y131.437 I-.031 J-.226 E.00096
G1 X138.217 Y131.32 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.269 Y131.361 E.00203
G1 X138.949 Y131.372 E.0209
G1 X139.08 Y131.552 E.00685
G1 X139.075 Y133.522 E.06054
G1 X142.106 Y133.53 E.09315
G1 X142.114 Y130.761 E.08509
G1 X142.073 Y130.476 E.00885
G1 X141.795 Y130.441 E.00861
G1 X138.754 Y130.433 E.09344
G3 X138.259 Y131.277 I-1.987 J-.598 E.03037
G1 X138.931 Y130.991 F30000
G1 F3230
G1 X139.064 Y131.013 E.00414
G1 X139.457 Y131.553 E.02054
G1 X139.453 Y133.146 E.04895
G1 X141.73 Y133.152 E.06998
G1 X141.736 Y130.818 E.07173
G1 X139.027 Y130.811 E.08326
G1 X138.959 Y130.938 E.00443
G1 X139.568 Y131.189 F30000
G1 F3230
G1 X139.834 Y131.554 E.01387
G1 X139.831 Y132.77 E.03737
G1 X141.354 Y132.774 E.0468
G1 X141.358 Y131.194 E.04856
G1 X139.628 Y131.189 E.05316
G1 X140.211 Y131.568 F30000
G1 F3230
G1 X140.209 Y132.394 E.02539
G1 X140.978 Y132.396 E.02363
G1 X140.98 Y131.57 E.02539
G1 X140.271 Y131.568 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 14.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X140.98 Y131.57 E-.26947
G1 X140.978 Y132.396 E-.31396
G1 X140.513 Y132.395 E-.17658
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 73/118
; update layer progress
M73 L73
M991 S0 P72 ;notify layer change
G17
G3 Z14.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.286 Y131.751
G1 Z14.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.281 Y133.91 E.07161
G1 X113.465 Y133.9 E.12657
G1 X113.473 Y130.689 E.10649
G3 X113.595 Y130.143 I.854 J-.096 E.0189
G3 X113.904 Y130.037 I.362 J.552 E.01095
G1 X117.516 Y130.038 E.11981
G2 X117.867 Y130.866 I2.388 J-.524 E.03001
G2 X118.843 Y131.502 I1.523 J-1.268 E.03924
G1 X119.009 Y131.534 E.00561
G1 X118.988 Y131.755 E.00739
G1 X117.346 Y131.751 E.05447
; WIPE_START
G1 F16213.044
G1 X117.285 Y133.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.872 Y132.914 Z15 F30000
G1 X136.965 Y131.582 Z15
G1 Z14.6
G1 E.8 F1800
G1 F3230
G2 X137.835 Y131.204 I-.412 J-2.139 E.03172
G1 X138.111 Y130.92 E.01314
G2 X138.467 Y130.093 I-2.029 J-1.363 E.03001
G1 X141.886 Y130.102 E.11343
G3 X142.387 Y130.22 I.091 J.738 E.01741
G3 X142.497 Y130.564 I-.666 J.404 E.01212
G1 X142.497 Y133.977 E.1132
G1 X138.681 Y133.967 E.12657
G1 X138.687 Y131.808 E.07161
G1 X136.985 Y131.803 E.05646
G1 X136.971 Y131.641 E.0054
; WIPE_START
G1 F16213.044
G1 X137.132 Y131.551 E-.07017
G1 X137.502 Y131.414 E-.15018
G1 X137.835 Y131.204 E-.14967
G1 X138.111 Y130.92 E-.15049
G1 X138.315 Y130.573 E-.15279
G1 X138.384 Y130.356 E-.08669
; WIPE_END
G1 E-.04 F1800
G1 X130.78 Y131.012 Z15 F30000
G1 X117.677 Y132.144 Z15
G1 Z14.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.672 Y134.291 E.06596
G1 X117.672 Y134.303 E.00038
G1 X113.072 Y134.291 E.14134
G1 X113.072 Y134.278 E.00038
G1 X113.081 Y130.68 E.11058
G3 X113.312 Y129.868 I1.167 J-.106 E.02652
G3 X113.865 Y129.646 I.611 J.722 E.01861
G1 X117.857 Y129.646 E.12266
G2 X118.392 Y130.846 I1.687 J-.033 E.04146
G2 X119.288 Y131.188 I1.102 J-1.545 E.02979
G1 X119.662 Y131.209 E.0115
G1 X136.314 Y131.253 E.51168
G2 X137.328 Y131.061 I.036 J-2.578 E.03191
G2 X138.053 Y130.137 I-.643 J-1.251 E.03721
G2 X138.128 Y129.7 I-2.965 J-.734 E.01364
G1 X141.896 Y129.71 E.11581
G3 X142.671 Y129.946 I.1 J1.062 E.02552
G3 X142.898 Y130.759 I-.94 J.7 E.02651
G1 X142.888 Y134.358 E.11058
G1 X142.888 Y134.37 E.00038
G1 X138.288 Y134.358 E.14134
G1 X138.288 Y134.345 E.00038
G1 X138.294 Y132.199 E.06596
G1 X138.253 Y132.199 E.00126
G1 X117.737 Y132.144 E.6304
M204 S10000
G1 X118.168 Y131.438 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107457
G1 F3230
G2 X118.321 Y131.531 I.185 J-.133 E.00096
G1 X117.735 Y131.294 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.54 Y131.084 E.00881
G1 X117.297 Y130.656 E.01512
G1 X117.227 Y130.429 E.00732
G1 X114.146 Y130.421 E.09466
G1 X113.908 Y130.455 E.00737
G1 X113.865 Y130.741 E.00886
G1 X113.858 Y133.509 E.08505
G1 X116.889 Y133.517 E.09315
G1 X116.895 Y131.546 E.06054
G1 X117.036 Y131.364 E.00707
G1 X117.73 Y131.349 E.02132
G1 X117.047 Y130.986 F30000
G1 F3230
G1 X116.952 Y130.805 E.00627
G1 X114.242 Y130.798 E.08326
G1 X114.236 Y133.132 E.07173
G1 X116.513 Y133.139 E.06998
G1 X116.518 Y131.545 E.04895
G1 X116.914 Y131.007 E.02054
G1 X116.988 Y130.995 E.00229
G1 X116.408 Y131.181 F30000
G1 F3230
G1 X114.618 Y131.176 E.055
G1 X114.614 Y132.756 E.04856
G1 X116.137 Y132.76 E.0468
G1 X116.141 Y131.544 E.03737
G1 X116.373 Y131.229 E.01203
G1 X115.763 Y131.556 F30000
G1 F3230
G1 X114.994 Y131.554 E.02363
G1 X114.992 Y132.38 E.02539
G1 X115.761 Y132.382 E.02363
G1 X115.763 Y131.616 E.02354
; WIPE_START
G1 F15000
G1 X115.761 Y132.382 E-.29115
G1 X114.992 Y132.38 E-.29226
G1 X114.993 Y131.916 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.194 Y131.666 Z15 F30000
G1 Z14.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.656 Y131.679 E.02066
G1 X136.78 Y131.712 E.76601
G1 X137.654 Y131.582 F30000
; LINE_WIDTH: 0.107441
G1 F3230
G2 X137.807 Y131.491 I-.031 J-.225 E.00096
G1 X138.217 Y131.374 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.268 Y131.415 E.00202
G1 X138.949 Y131.425 E.02091
G1 X139.08 Y131.605 E.00685
G1 X139.075 Y133.576 E.06054
G1 X142.106 Y133.584 E.09315
G1 X142.113 Y130.814 E.08509
G1 X142.073 Y130.529 E.00885
G1 X141.795 Y130.494 E.00861
G1 X138.754 Y130.486 E.09344
G3 X138.258 Y131.331 I-1.987 J-.598 E.03038
G1 X138.931 Y131.044 F30000
G1 F3230
G1 X139.063 Y131.066 E.00414
G1 X139.457 Y131.606 E.02054
G1 X139.453 Y133.2 E.04895
G1 X141.73 Y133.206 E.06998
G1 X141.736 Y130.871 E.07173
G1 X139.026 Y130.864 E.08326
G1 X138.959 Y130.991 E.00443
G1 X139.568 Y131.242 F30000
G1 F3230
G1 X139.834 Y131.607 E.01387
G1 X139.831 Y132.823 E.03737
G1 X141.354 Y132.828 E.0468
G1 X141.358 Y131.247 E.04856
G1 X139.628 Y131.243 E.05316
G1 X140.211 Y131.621 F30000
G1 F3230
G1 X140.209 Y132.447 E.02539
G1 X140.978 Y132.449 E.02363
G1 X140.98 Y131.623 E.02539
G1 X140.271 Y131.621 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 14.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.98 Y131.623 E-.26947
G1 X140.978 Y132.449 E-.31396
G1 X140.513 Y132.448 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 74/118
; update layer progress
M73 L74
M991 S0 P73 ;notify layer change
G17
G3 Z15 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.286 Y131.804
G1 Z14.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.28 Y133.963 E.07161
G1 X113.465 Y133.953 E.12657
G1 X113.473 Y130.742 E.1065
G3 X113.595 Y130.196 I.854 J-.096 E.0189
G3 X113.904 Y130.091 I.362 J.552 E.01095
G1 X117.516 Y130.091 E.11981
G2 X117.867 Y130.919 I2.388 J-.524 E.03001
G2 X118.843 Y131.556 I1.523 J-1.268 E.03924
G1 X119.009 Y131.587 E.00561
G1 X118.988 Y131.809 E.00739
G1 X117.346 Y131.804 E.05447
; WIPE_START
G1 F16213.044
G1 X117.285 Y133.803 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.872 Y132.967 Z15.2 F30000
G1 X136.965 Y131.635 Z15.2
G1 Z14.8
G1 E.8 F1800
G1 F3230
G2 X137.835 Y131.257 I-.413 J-2.14 E.03172
G1 X138.111 Y130.973 E.01314
G2 X138.467 Y130.147 I-2.03 J-1.363 E.03001
G1 X141.886 Y130.156 E.11343
G3 X142.387 Y130.273 I.091 J.738 E.01741
G3 X142.497 Y130.618 I-.667 J.404 E.01211
G1 X142.497 Y134.03 E.1132
G1 X138.681 Y134.02 E.12657
G1 X138.687 Y131.861 E.07161
G1 X136.985 Y131.857 E.05646
G1 X136.97 Y131.695 E.00539
; WIPE_START
G1 F16213.044
G1 X137.131 Y131.604 E-.07014
G1 X137.502 Y131.467 E-.15021
G1 X137.835 Y131.257 E-.14964
G1 X138.111 Y130.973 E-.15053
G1 X138.315 Y130.626 E-.1528
G1 X138.384 Y130.409 E-.08668
; WIPE_END
G1 E-.04 F1800
G1 X130.78 Y131.066 Z15.2 F30000
G1 X117.677 Y132.197 Z15.2
G1 Z14.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.671 Y134.344 E.06596
G1 X117.671 Y134.356 E.00038
G1 X113.072 Y134.344 E.14134
G1 X113.072 Y134.332 E.00038
G1 X113.081 Y130.733 E.11058
G3 X113.312 Y129.922 I1.167 J-.106 E.02652
G3 X113.865 Y129.7 I.611 J.723 E.01861
G1 X117.857 Y129.7 E.12266
G2 X118.392 Y130.899 I1.686 J-.033 E.04146
G2 X119.288 Y131.241 I1.102 J-1.545 E.0298
G1 X119.662 Y131.262 E.0115
G1 X136.314 Y131.306 E.51168
G2 X137.328 Y131.114 I.036 J-2.577 E.03191
G2 X138.052 Y130.191 I-.643 J-1.251 E.0372
G2 X138.127 Y129.754 I-2.943 J-.73 E.01365
G1 X141.896 Y129.764 E.11581
G3 X142.671 Y130 I.1 J1.061 E.02552
G3 X142.898 Y130.812 I-.94 J.7 E.02651
G1 X142.888 Y134.411 E.11058
G1 X142.888 Y134.423 E.00038
G1 X138.288 Y134.411 E.14134
G1 X138.288 Y134.399 E.00038
G1 X138.294 Y132.252 E.06596
G1 X138.253 Y132.252 E.00126
G1 X117.737 Y132.197 E.6304
M204 S10000
G1 X118.168 Y131.492 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107452
G1 F3230
G2 X118.32 Y131.584 I.185 J-.133 E.00096
G1 X117.735 Y131.348 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.54 Y131.137 E.00881
G1 X117.297 Y130.709 E.01513
G1 X117.226 Y130.482 E.00731
G1 X114.147 Y130.474 E.09463
G1 X113.908 Y130.509 E.0074
G1 X113.865 Y130.794 E.00886
G1 X113.858 Y133.562 E.08505
G1 X116.889 Y133.57 E.09315
G1 X116.895 Y131.6 E.06054
G1 X117.036 Y131.418 E.00707
G1 X117.729 Y131.403 E.02133
G1 X117.047 Y131.039 F30000
G1 F3230
G1 X116.952 Y130.859 E.00627
G1 X114.242 Y130.851 E.08326
G1 X114.236 Y133.186 E.07173
G1 X116.513 Y133.192 E.06998
G1 X116.518 Y131.599 E.04895
M73 P79 R3
G1 X116.914 Y131.06 E.02054
G1 X116.988 Y131.049 E.00229
G1 X116.408 Y131.234 F30000
G1 F3230
G1 X114.618 Y131.229 E.055
G1 X114.614 Y132.81 E.04856
G1 X116.137 Y132.814 E.0468
G1 X116.14 Y131.598 E.03737
G1 X116.373 Y131.282 E.01203
G1 X115.763 Y131.609 F30000
G1 F3230
G1 X114.994 Y131.607 E.02363
G1 X114.992 Y132.434 E.02539
G1 X115.761 Y132.436 E.02363
G1 X115.763 Y131.669 E.02354
; WIPE_START
G1 F15000
G1 X115.761 Y132.436 E-.29115
G1 X114.992 Y132.434 E-.29226
G1 X114.993 Y131.969 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.194 Y131.719 Z15.2 F30000
G1 Z14.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.655 Y131.732 E.02066
G1 X136.78 Y131.766 E.76601
G1 X137.654 Y131.635 F30000
; LINE_WIDTH: 0.107477
G1 F3230
G2 X137.807 Y131.544 I-.031 J-.226 E.00096
G1 X138.217 Y131.427 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.269 Y131.468 E.00204
G1 X138.949 Y131.479 E.02089
G1 X139.08 Y131.659 E.00685
G1 X139.074 Y133.629 E.06054
G1 X142.106 Y133.637 E.09315
G1 X142.113 Y130.868 E.08509
G1 X142.073 Y130.582 E.00885
G1 X141.795 Y130.547 E.00861
G1 X138.754 Y130.539 E.09344
G3 X138.258 Y131.384 I-1.987 J-.598 E.03036
G1 X138.93 Y131.097 F30000
G1 F3230
G1 X139.063 Y131.119 E.00414
G1 X139.457 Y131.66 E.02054
G1 X139.453 Y133.253 E.04895
G1 X141.73 Y133.259 E.06998
G1 X141.736 Y130.924 E.07173
G1 X139.026 Y130.917 E.08326
G1 X138.959 Y131.045 E.00443
G1 X139.568 Y131.296 F30000
G1 F3230
G1 X139.834 Y131.661 E.01387
G1 X139.831 Y132.877 E.03737
G1 X141.354 Y132.881 E.0468
G1 X141.358 Y131.3 E.04856
G1 X139.628 Y131.296 E.05316
G1 X140.211 Y131.674 F30000
G1 F3230
G1 X140.209 Y132.501 E.02539
G1 X140.978 Y132.503 E.02363
G1 X140.98 Y131.677 E.02539
G1 X140.271 Y131.675 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 15
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.98 Y131.677 E-.26947
G1 X140.978 Y132.503 E-.31396
G1 X140.513 Y132.501 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 75/118
; update layer progress
M73 L75
M991 S0 P74 ;notify layer change
G17
G3 Z15.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.286 Y131.857
G1 Z15
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.28 Y134.016 E.07161
G1 X113.465 Y134.006 E.12657
G1 X113.473 Y130.796 E.1065
G3 X113.595 Y130.25 I.854 J-.096 E.0189
G3 X113.904 Y130.144 I.362 J.552 E.01094
G1 X117.516 Y130.144 E.11981
G2 X117.867 Y130.972 I2.386 J-.523 E.03
G2 X118.843 Y131.609 I1.523 J-1.269 E.03925
G1 X119.009 Y131.64 E.00561
G1 X118.988 Y131.862 E.00739
G1 X117.346 Y131.858 E.05447
; WIPE_START
G1 F16213.044
G1 X117.285 Y133.857 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.872 Y133.021 Z15.4 F30000
G1 X136.965 Y131.688 Z15.4
G1 Z15
G1 E.8 F1800
G1 F3230
G2 X137.835 Y131.31 I-.413 J-2.14 E.03172
G1 X138.111 Y131.026 E.01314
G2 X138.466 Y130.2 I-2.026 J-1.361 E.03001
G1 X141.886 Y130.209 E.11343
G3 X142.386 Y130.326 I.091 J.738 E.01741
G3 X142.497 Y130.671 I-.666 J.403 E.01211
G1 X142.497 Y134.083 E.1132
G1 X138.681 Y134.073 E.12657
G1 X138.687 Y131.914 E.07161
G1 X136.985 Y131.91 E.05646
G1 X136.97 Y131.748 E.00539
; WIPE_START
G1 F16213.044
G1 X137.131 Y131.657 E-.07015
G1 X137.502 Y131.521 E-.15021
G1 X137.835 Y131.31 E-.14964
G1 X138.111 Y131.026 E-.15052
G1 X138.315 Y130.679 E-.1529
G1 X138.384 Y130.462 E-.08657
; WIPE_END
G1 E-.04 F1800
G1 X130.78 Y131.119 Z15.4 F30000
G1 X117.677 Y132.251 Z15.4
G1 Z15
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.671 Y134.397 E.06596
G1 X117.671 Y134.409 E.00038
G1 X113.071 Y134.397 E.14134
G1 X113.071 Y134.385 E.00038
G1 X113.081 Y130.786 E.11058
G3 X113.312 Y129.975 I1.167 J-.106 E.02652
G3 X113.865 Y129.753 I.611 J.722 E.01861
G1 X117.857 Y129.753 E.12266
G2 X118.392 Y130.953 I1.686 J-.033 E.04146
G2 X119.288 Y131.294 I1.102 J-1.545 E.0298
G1 X119.662 Y131.315 E.0115
G1 X136.314 Y131.359 E.51168
G2 X137.328 Y131.167 I.036 J-2.577 E.03191
G2 X138.052 Y130.244 I-.643 J-1.251 E.03719
G2 X138.127 Y129.807 I-2.925 J-.728 E.01366
G1 X141.896 Y129.817 E.11581
G3 X142.671 Y130.053 I.1 J1.061 E.02552
G3 X142.897 Y130.865 I-.94 J.7 E.02651
G1 X142.888 Y134.464 E.11058
G1 X142.888 Y134.476 E.00038
G1 X138.288 Y134.464 E.14134
G1 X138.288 Y134.452 E.00038
G1 X138.294 Y132.305 E.06596
G1 X138.253 Y132.305 E.00126
G1 X117.737 Y132.251 E.6304
M204 S10000
G1 X118.168 Y131.545 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107451
G1 F3230
G2 X118.32 Y131.637 I.185 J-.133 E.00096
G1 X117.735 Y131.401 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.54 Y131.19 E.00881
G1 X117.297 Y130.763 E.01513
G1 X117.226 Y130.535 E.0073
G1 X114.148 Y130.527 E.0946
G1 X113.908 Y130.562 E.00744
G1 X113.865 Y130.847 E.00886
G1 X113.858 Y133.615 E.08505
G1 X116.889 Y133.623 E.09315
G1 X116.894 Y131.653 E.06054
G1 X117.035 Y131.471 E.00707
G1 X117.729 Y131.456 E.02133
G1 X117.047 Y131.093 F30000
G1 F3230
G1 X116.952 Y130.912 E.00627
G1 X114.242 Y130.905 E.08326
G1 X114.236 Y133.239 E.07173
G1 X116.513 Y133.245 E.06998
G1 X116.517 Y131.652 E.04895
G1 X116.914 Y131.114 E.02054
G1 X116.988 Y131.102 E.00229
G1 X116.408 Y131.287 F30000
G1 F3230
G1 X114.618 Y131.283 E.055
G1 X114.614 Y132.863 E.04856
G1 X116.137 Y132.867 E.0468
G1 X116.14 Y131.651 E.03737
G1 X116.372 Y131.336 E.01203
G1 X115.763 Y131.663 F30000
G1 F3230
G1 X114.994 Y131.661 E.02363
G1 X114.992 Y132.487 E.02539
G1 X115.761 Y132.489 E.02363
G1 X115.763 Y131.723 E.02354
; WIPE_START
G1 F15000
G1 X115.761 Y132.489 E-.29115
G1 X114.992 Y132.487 E-.29226
G1 X114.993 Y132.022 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.194 Y131.772 Z15.4 F30000
G1 Z15
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.59187
G1 F3230
G1 X119.655 Y131.785 E.02066
G1 X136.78 Y131.819 E.76602
G1 X137.654 Y131.689 F30000
; LINE_WIDTH: 0.107472
G1 F3230
G2 X137.807 Y131.597 I-.031 J-.226 E.00096
G1 X138.217 Y131.48 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.268 Y131.521 E.00204
G1 X138.948 Y131.532 E.02089
G1 X139.08 Y131.712 E.00685
G1 X139.074 Y133.682 E.06054
G1 X142.106 Y133.69 E.09315
G1 X142.113 Y130.921 E.08509
G1 X142.073 Y130.636 E.00885
G1 X141.795 Y130.601 E.00861
G1 X138.754 Y130.593 E.09344
G3 X138.258 Y131.437 I-1.988 J-.599 E.03036
G1 X138.93 Y131.151 F30000
G1 F3230
G1 X139.063 Y131.173 E.00414
G1 X139.457 Y131.713 E.02054
G1 X139.452 Y133.306 E.04895
G1 X141.73 Y133.312 E.06998
G1 X141.736 Y130.978 E.07173
G1 X139.026 Y130.97 E.08326
G1 X138.958 Y131.098 E.00443
G1 X139.568 Y131.349 F30000
G1 F3230
G1 X139.834 Y131.714 E.01387
G1 X139.83 Y132.93 E.03737
G1 X141.354 Y132.934 E.0468
G1 X141.358 Y131.354 E.04856
G1 X139.628 Y131.349 E.05316
G1 X140.211 Y131.728 F30000
G1 F3230
G1 X140.209 Y132.554 E.02539
G1 X140.978 Y132.556 E.02363
G1 X140.98 Y131.73 E.02539
G1 X140.271 Y131.728 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 15.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.98 Y131.73 E-.26947
G1 X140.978 Y132.556 E-.31396
G1 X140.513 Y132.555 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 76/118
; update layer progress
M73 L76
M991 S0 P75 ;notify layer change
G17
G3 Z15.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.286 Y131.911
G1 Z15.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.28 Y134.069 E.07161
G1 X113.464 Y134.059 E.12657
G1 X113.473 Y130.849 E.1065
G3 X113.595 Y130.303 I.854 J-.096 E.0189
G3 X113.903 Y130.197 I.362 J.551 E.01094
G1 X117.516 Y130.197 E.11982
G2 X117.866 Y131.025 I2.384 J-.522 E.03
G2 X118.843 Y131.662 I1.523 J-1.269 E.03925
G1 X119.009 Y131.694 E.00561
G1 X118.988 Y131.915 E.00739
G1 X117.346 Y131.911 E.05447
; WIPE_START
G1 F16213.044
G1 X117.285 Y133.91 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.871 Y133.074 Z15.6 F30000
G1 X136.965 Y131.741 Z15.6
G1 Z15.2
G1 E.8 F1800
G1 F3230
G2 X137.835 Y131.363 I-.412 J-2.14 E.03172
G1 X138.111 Y131.079 E.01314
G2 X138.466 Y130.253 I-2.025 J-1.361 E.03001
G1 X141.886 Y130.262 E.11344
G3 X142.386 Y130.379 I.091 J.738 E.01741
G3 X142.497 Y130.724 I-.666 J.404 E.01211
G1 X142.497 Y134.137 E.1132
G1 X138.681 Y134.126 E.12657
G1 X138.687 Y131.968 E.07161
G1 X136.985 Y131.963 E.05646
G1 X136.97 Y131.801 E.00539
; WIPE_START
G1 F16213.044
G1 X137.131 Y131.711 E-.07018
G1 X137.502 Y131.574 E-.15018
G1 X137.835 Y131.363 E-.14968
G1 X138.111 Y131.079 E-.1505
G1 X138.315 Y130.733 E-.15292
G1 X138.384 Y130.515 E-.08654
; WIPE_END
G1 E-.04 F1800
G1 X130.779 Y131.172 Z15.6 F30000
G1 X117.677 Y132.304 Z15.6
G1 Z15.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.671 Y134.45 E.06596
G1 X117.671 Y134.463 E.00038
G1 X113.071 Y134.45 E.14134
G1 X113.071 Y134.438 E.00038
G1 X113.081 Y130.839 E.11058
G3 X113.312 Y130.028 I1.167 J-.106 E.02651
G3 X113.864 Y129.806 I.611 J.722 E.01861
G1 X117.857 Y129.806 E.12267
G2 X118.392 Y131.006 I1.685 J-.032 E.04146
G2 X119.288 Y131.347 I1.102 J-1.545 E.0298
G1 X119.662 Y131.368 E.0115
G1 X136.314 Y131.413 E.51168
G2 X137.327 Y131.22 I.036 J-2.578 E.03191
G2 X138.052 Y130.298 I-.642 J-1.25 E.03718
G2 X138.127 Y129.86 I-2.912 J-.726 E.01367
G1 X141.896 Y129.87 E.11581
G3 X142.671 Y130.106 I.1 J1.061 E.02552
G3 X142.897 Y130.919 I-.94 J.7 E.02651
G1 X142.888 Y134.517 E.11058
G1 X142.888 Y134.53 E.00038
G1 X138.288 Y134.517 E.14134
G1 X138.288 Y134.505 E.00038
G1 X138.294 Y132.359 E.06596
G1 X138.253 Y132.359 E.00126
G1 X117.737 Y132.304 E.6304
M204 S10000
G1 X118.168 Y131.598 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107451
G1 F3230
G2 X118.32 Y131.69 I.185 J-.133 E.00096
G1 X117.735 Y131.454 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.54 Y131.244 E.00881
G1 X117.296 Y130.816 E.01513
G1 X117.226 Y130.589 E.0073
G1 X114.149 Y130.581 E.09456
G1 X113.908 Y130.615 E.00747
G1 X113.865 Y130.9 E.00886
G1 X113.858 Y133.668 E.08505
G1 X116.889 Y133.676 E.09315
G1 X116.894 Y131.706 E.06054
G1 X117.035 Y131.524 E.00707
G1 X117.729 Y131.509 E.02133
G1 X117.047 Y131.146 F30000
G1 F3230
G1 X116.952 Y130.965 E.00628
G1 X114.242 Y130.958 E.08326
G1 X114.236 Y133.292 E.07173
G1 X116.513 Y133.298 E.06998
G1 X116.517 Y131.705 E.04895
G1 X116.914 Y131.167 E.02054
G1 X116.987 Y131.155 E.00229
G1 X116.408 Y131.341 F30000
G1 F3230
G1 X114.618 Y131.336 E.055
G1 X114.614 Y132.916 E.04856
G1 X116.137 Y132.92 E.0468
G1 X116.14 Y131.704 E.03737
G1 X116.372 Y131.389 E.01203
G1 X115.763 Y131.716 F30000
G1 F3230
G1 X114.994 Y131.714 E.02363
G1 X114.992 Y132.54 E.02539
G1 X115.761 Y132.542 E.02363
G1 X115.763 Y131.776 E.02354
; WIPE_START
G1 F15000
G1 X115.761 Y132.542 E-.29115
G1 X114.992 Y132.54 E-.29226
G1 X114.993 Y132.075 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.193 Y131.825 Z15.6 F30000
G1 Z15.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
M73 P80 R3
G1 F3230
G1 X119.655 Y131.839 E.02066
G1 X136.78 Y131.872 E.76601
G1 X137.654 Y131.742 F30000
; LINE_WIDTH: 0.107469
G1 F3230
G2 X137.806 Y131.65 I-.031 J-.226 E.00096
G1 X138.216 Y131.533 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.268 Y131.574 E.00203
G1 X138.948 Y131.585 E.0209
G1 X139.079 Y131.765 E.00685
G1 X139.074 Y133.735 E.06054
G1 X142.106 Y133.743 E.09315
G1 X142.113 Y130.974 E.08509
G1 X142.073 Y130.689 E.00885
G1 X141.795 Y130.654 E.00861
G1 X138.753 Y130.646 E.09344
G3 X138.258 Y131.49 I-1.988 J-.599 E.03037
G1 X138.93 Y131.204 F30000
G1 F3230
G1 X139.063 Y131.226 E.00414
G1 X139.456 Y131.766 E.02054
G1 X139.452 Y133.359 E.04895
G1 X141.73 Y133.365 E.06998
G1 X141.736 Y131.031 E.07173
G1 X139.026 Y131.024 E.08326
G1 X138.958 Y131.151 E.00443
G1 X139.568 Y131.402 F30000
G1 F3230
G1 X139.834 Y131.767 E.01387
G1 X139.83 Y132.983 E.03737
G1 X141.354 Y132.987 E.0468
G1 X141.358 Y131.407 E.04856
G1 X139.628 Y131.402 E.05316
G1 X140.211 Y131.781 F30000
G1 F3230
G1 X140.208 Y132.607 E.02539
G1 X140.977 Y132.609 E.02363
G1 X140.98 Y131.783 E.02539
G1 X140.271 Y131.781 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 15.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.98 Y131.783 E-.26947
G1 X140.977 Y132.609 E-.31396
G1 X140.513 Y132.608 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 77/118
; update layer progress
M73 L77
M991 S0 P76 ;notify layer change
G17
G3 Z15.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.286 Y131.964
G1 Z15.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.28 Y134.123 E.07161
G1 X113.464 Y134.113 E.12657
G1 X113.473 Y130.902 E.10649
G3 X113.595 Y130.356 I.854 J-.096 E.0189
G3 X113.903 Y130.25 I.361 J.551 E.01094
G1 X117.515 Y130.251 E.11982
G2 X117.866 Y131.079 I2.383 J-.522 E.03
G2 X118.843 Y131.715 I1.523 J-1.269 E.03925
G1 X119.009 Y131.747 E.00561
G1 X118.988 Y131.968 E.00739
G1 X117.346 Y131.964 E.05447
; WIPE_START
G1 F16213.044
G1 X117.285 Y133.963 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.871 Y133.127 Z15.8 F30000
G1 X136.965 Y131.795 Z15.8
G1 Z15.4
G1 E.8 F1800
G1 F3218
G2 X137.835 Y131.417 I-.413 J-2.14 E.03172
G1 X138.111 Y131.132 E.01314
G2 X138.466 Y130.306 I-2.024 J-1.36 E.03
G1 X141.886 Y130.315 E.11344
G3 X142.386 Y130.433 I.091 J.738 E.01741
G3 X142.497 Y130.777 I-.666 J.403 E.01212
G1 X142.497 Y134.19 E.1132
G1 X138.681 Y134.18 E.12657
G1 X138.687 Y132.021 E.07161
G1 X136.985 Y132.016 E.05646
G1 X136.97 Y131.854 E.00539
; WIPE_START
G1 F16213.044
G1 X137.131 Y131.764 E-.07012
G1 X137.502 Y131.627 E-.15023
G1 X137.835 Y131.417 E-.14965
G1 X138.111 Y131.132 E-.15054
G1 X138.315 Y130.786 E-.15298
G1 X138.383 Y130.569 E-.08649
; WIPE_END
G1 E-.04 F1800
G1 X130.779 Y131.225 Z15.8 F30000
G1 X117.677 Y132.357 Z15.8
G1 Z15.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.671 Y134.504 E.06596
G1 X117.671 Y134.516 E.00038
G1 X113.071 Y134.504 E.14134
G1 X113.071 Y134.491 E.00038
G1 X113.081 Y130.893 E.11058
G3 X113.312 Y130.081 I1.167 J-.106 E.02652
G3 X113.864 Y129.86 I.611 J.722 E.01861
G1 X117.856 Y129.859 E.12267
G2 X118.391 Y131.059 I1.684 J-.032 E.04146
G2 X119.288 Y131.401 I1.102 J-1.545 E.0298
G1 X119.661 Y131.422 E.0115
G1 X136.314 Y131.466 E.51168
G2 X137.327 Y131.274 I.036 J-2.577 E.03191
G2 X138.052 Y130.352 I-.643 J-1.25 E.03717
G2 X138.127 Y129.913 I-2.893 J-.724 E.01368
G1 X141.896 Y129.923 E.11581
G3 X142.67 Y130.159 I.1 J1.062 E.02552
G3 X142.897 Y130.972 I-.94 J.7 E.02652
G1 X142.888 Y134.571 E.11058
G1 X142.888 Y134.583 E.00038
G1 X138.288 Y134.571 E.14134
G1 X138.288 Y134.558 E.00038
G1 X138.294 Y132.412 E.06596
G1 X138.253 Y132.412 E.00126
G1 X117.737 Y132.357 E.6304
M204 S10000
G1 X118.168 Y131.652 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107454
G1 F3218
G2 X118.32 Y131.744 I.185 J-.133 E.00096
G1 X117.735 Y131.507 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.54 Y131.297 E.00882
G1 X117.296 Y130.869 E.01514
G1 X117.226 Y130.642 E.00729
G1 X114.149 Y130.634 E.09454
G1 X113.908 Y130.669 E.0075
G1 X113.865 Y130.954 E.00886
G1 X113.857 Y133.722 E.08505
G1 X116.889 Y133.73 E.09315
G1 X116.894 Y131.759 E.06054
G1 X117.035 Y131.577 E.00707
G1 X117.729 Y131.563 E.02133
G1 X117.047 Y131.199 F30000
G1 F3218
G1 X116.952 Y131.018 E.00627
G1 X114.242 Y131.011 E.08327
G1 X114.235 Y133.346 E.07173
G1 X116.513 Y133.352 E.06998
G1 X116.517 Y131.758 E.04895
G1 X116.914 Y131.22 E.02054
G1 X116.987 Y131.208 E.00229
G1 X116.408 Y131.394 F30000
G1 F3218
G1 X114.618 Y131.389 E.055
G1 X114.614 Y132.969 E.04856
G1 X116.137 Y132.973 E.0468
G1 X116.14 Y131.757 E.03737
G1 X116.372 Y131.442 E.01203
G1 X115.763 Y131.769 F30000
G1 F3218
G1 X114.994 Y131.767 E.02363
G1 X114.992 Y132.593 E.02539
G1 X115.761 Y132.595 E.02363
G1 X115.763 Y131.829 E.02354
; WIPE_START
G1 F15000
G1 X115.761 Y132.595 E-.29115
G1 X114.992 Y132.593 E-.29227
G1 X114.993 Y132.129 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.193 Y131.879 Z15.8 F30000
G1 Z15.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591852
G1 F3218
G1 X136.318 Y131.936 E.766
G1 X136.78 Y131.925 E.02066
G1 X137.653 Y131.795 F30000
; LINE_WIDTH: 0.107457
G1 F3218
G2 X137.806 Y131.704 I-.031 J-.226 E.00096
G1 X138.216 Y131.587 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.268 Y131.628 E.00203
G1 X138.948 Y131.638 E.02091
G1 X139.079 Y131.818 E.00685
G1 X139.074 Y133.789 E.06054
G1 X142.106 Y133.797 E.09315
G1 X142.113 Y131.027 E.08509
G1 X142.072 Y130.742 E.00885
G1 X141.794 Y130.707 E.00861
G1 X138.753 Y130.699 E.09344
G3 X138.258 Y131.544 I-1.989 J-.599 E.03037
G1 X138.93 Y131.257 F30000
G1 F3218
G1 X139.063 Y131.279 E.00414
G1 X139.456 Y131.819 E.02054
G1 X139.452 Y133.413 E.04895
G1 X141.729 Y133.419 E.06998
G1 X141.736 Y131.084 E.07173
G1 X139.026 Y131.077 E.08327
G1 X138.958 Y131.204 E.00443
G1 X139.568 Y131.455 F30000
G1 F3218
G1 X139.833 Y131.82 E.01387
G1 X139.83 Y133.036 E.03737
G1 X141.353 Y133.041 E.0468
G1 X141.358 Y131.46 E.04856
G1 X139.628 Y131.456 E.05316
G1 X140.21 Y131.834 F30000
G1 F3218
G1 X140.208 Y132.66 E.02539
G1 X140.977 Y132.662 E.02363
G1 X140.98 Y131.836 E.02539
G1 X140.27 Y131.834 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 15.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X140.98 Y131.836 E-.26947
G1 X140.977 Y132.662 E-.31395
G1 X140.513 Y132.661 E-.17658
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 78/118
; update layer progress
M73 L78
M991 S0 P77 ;notify layer change
G17
G3 Z15.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.286 Y132.017
G1 Z15.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.28 Y134.176 E.07161
G1 X113.464 Y134.166 E.12657
G1 X113.473 Y130.955 E.10649
G3 X113.594 Y130.409 I.854 J-.096 E.0189
G3 X113.903 Y130.304 I.362 J.551 E.01094
G1 X117.515 Y130.304 E.11982
G2 X117.866 Y131.132 I2.381 J-.521 E.03
G2 X118.843 Y131.769 I1.523 J-1.269 E.03925
G1 X119.009 Y131.8 E.00561
G1 X118.988 Y132.022 E.00739
G1 X117.346 Y132.017 E.05447
; WIPE_START
G1 F16213.044
G1 X117.285 Y134.016 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.871 Y133.18 Z16 F30000
G1 X136.964 Y131.848 Z16
G1 Z15.6
G1 E.8 F1800
G1 F3218
G2 X137.834 Y131.47 I-.412 J-2.139 E.03172
G1 X138.111 Y131.186 E.01314
G2 X138.466 Y130.36 I-2.023 J-1.36 E.03
G1 X141.886 Y130.369 E.11344
G3 X142.386 Y130.486 I.091 J.738 E.01741
G3 X142.497 Y130.831 I-.666 J.403 E.01212
G1 X142.496 Y134.243 E.1132
G1 X138.681 Y134.233 E.12657
G1 X138.687 Y132.074 E.07161
G1 X136.984 Y132.07 E.05646
G1 X136.97 Y131.908 E.0054
; WIPE_START
G1 F16213.044
G1 X137.131 Y131.817 E-.07017
G1 X137.502 Y131.68 E-.15019
G1 X137.834 Y131.47 E-.14967
G1 X138.111 Y131.186 E-.15053
G1 X138.315 Y130.839 E-.15303
G1 X138.383 Y130.622 E-.08641
; WIPE_END
G1 E-.04 F1800
G1 X130.779 Y131.279 Z16 F30000
G1 X117.677 Y132.41 Z16
G1 Z15.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.671 Y134.557 E.06596
G1 X117.671 Y134.569 E.00038
G1 X113.071 Y134.557 E.14134
G1 X113.071 Y134.545 E.00038
G1 X113.081 Y130.946 E.11058
G3 X113.312 Y130.135 I1.167 J-.106 E.02652
G3 X113.864 Y129.913 I.611 J.722 E.01861
G1 X117.856 Y129.913 E.12267
G2 X118.391 Y131.112 I1.683 J-.031 E.04146
G2 X119.288 Y131.454 I1.102 J-1.545 E.02979
G1 X119.661 Y131.475 E.0115
G1 X136.314 Y131.519 E.51168
G2 X137.327 Y131.327 I.036 J-2.578 E.03191
G2 X138.051 Y130.405 I-.642 J-1.25 E.03716
G2 X138.127 Y129.967 I-2.878 J-.722 E.01369
G1 X141.896 Y129.977 E.11581
G3 X142.67 Y130.213 I.1 J1.061 E.02552
G3 X142.897 Y131.025 I-.94 J.7 E.02651
G1 X142.887 Y134.624 E.11058
G1 X142.887 Y134.636 E.00038
G1 X138.288 Y134.624 E.14134
G1 X138.288 Y134.612 E.00038
G1 X138.293 Y132.465 E.06596
G1 X138.252 Y132.465 E.00126
G1 X117.737 Y132.41 E.6304
M204 S10000
G1 X118.168 Y131.705 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107448
G1 F3218
G2 X118.32 Y131.797 I.185 J-.133 E.00096
G1 X117.735 Y131.561 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.54 Y131.35 E.00882
G1 X117.296 Y130.922 E.01514
G1 X117.226 Y130.695 E.00729
G1 X114.15 Y130.687 E.0945
G1 X113.908 Y130.722 E.00753
G1 X113.865 Y131.007 E.00885
G1 X113.857 Y133.775 E.08505
G1 X116.889 Y133.783 E.09315
G1 X116.894 Y131.813 E.06054
G1 X117.035 Y131.631 E.00707
G1 X117.729 Y131.616 E.02133
G1 X117.046 Y131.252 F30000
G1 F3218
G1 X116.951 Y131.072 E.00628
G1 X114.242 Y131.064 E.08327
G1 X114.235 Y133.399 E.07173
G1 X116.513 Y133.405 E.06998
G1 X116.517 Y131.812 E.04895
G1 X116.913 Y131.273 E.02054
G1 X116.987 Y131.262 E.00229
G1 X116.408 Y131.447 F30000
G1 F3218
G1 X114.618 Y131.442 E.055
G1 X114.613 Y133.023 E.04856
G1 X116.137 Y133.027 E.0468
G1 X116.14 Y131.811 E.03737
G1 X116.372 Y131.495 E.01203
G1 X115.763 Y131.823 F30000
G1 F3218
G1 X114.994 Y131.82 E.02363
G1 X114.991 Y132.647 E.02539
G1 X115.761 Y132.649 E.02363
G1 X115.763 Y131.882 E.02354
; WIPE_START
G1 F15000
G1 X115.761 Y132.649 E-.29115
G1 X114.991 Y132.647 E-.29227
G1 X114.993 Y132.182 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.193 Y131.932 Z16 F30000
G1 Z15.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591871
G1 F3218
G1 X136.318 Y131.989 E.76602
G1 X136.779 Y131.979 E.02065
G1 X137.653 Y131.848 F30000
; LINE_WIDTH: 0.107457
G1 F3218
G2 X137.806 Y131.757 I-.031 J-.226 E.00096
G1 X138.216 Y131.64 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.268 Y131.681 E.00203
G1 X138.948 Y131.692 E.02091
G1 X139.079 Y131.872 E.00685
G1 X139.074 Y133.842 E.06054
G1 X142.105 Y133.85 E.09315
G1 X142.113 Y131.081 E.08509
G1 X142.072 Y130.795 E.00885
G1 X141.794 Y130.76 E.00861
G1 X138.753 Y130.752 E.09344
G3 X138.258 Y131.597 I-1.989 J-.599 E.03037
G1 X138.93 Y131.311 F30000
G1 F3218
G1 X139.063 Y131.332 E.00414
G1 X139.456 Y131.873 E.02054
G1 X139.452 Y133.466 E.04895
G1 X141.729 Y133.472 E.06998
G1 X141.736 Y131.137 E.07173
G1 X139.026 Y131.13 E.08327
G1 X138.958 Y131.258 E.00443
M73 P81 R3
G1 X139.567 Y131.509 F30000
G1 F3218
G1 X139.833 Y131.874 E.01387
G1 X139.83 Y133.09 E.03737
G1 X141.353 Y133.094 E.0468
G1 X141.357 Y131.513 E.04856
G1 X139.627 Y131.509 E.05316
G1 X140.21 Y131.887 F30000
G1 F3218
G1 X140.208 Y132.714 E.02539
G1 X140.977 Y132.716 E.02363
G1 X140.979 Y131.89 E.02539
G1 X140.27 Y131.888 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 15.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.979 Y131.89 E-.26947
G1 X140.977 Y132.716 E-.31395
G1 X140.513 Y132.714 E-.17658
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 79/118
; update layer progress
M73 L79
M991 S0 P78 ;notify layer change
G17
G3 Z16 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.285 Y132.07
G1 Z15.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.28 Y134.229 E.07161
G1 X113.464 Y134.219 E.12657
G1 X113.473 Y131.009 E.10649
G3 X113.594 Y130.463 I.854 J-.096 E.0189
G3 X113.903 Y130.357 I.362 J.552 E.01093
G1 X117.515 Y130.357 E.11982
G2 X117.866 Y131.185 I2.379 J-.52 E.03
G2 X118.842 Y131.822 I1.523 J-1.269 E.03925
G1 X119.009 Y131.853 E.00561
G1 X118.987 Y132.075 E.00739
G1 X117.345 Y132.071 E.05447
; WIPE_START
G1 F16213.044
G1 X117.285 Y134.07 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.871 Y133.234 Z16.2 F30000
G1 X136.964 Y131.901 Z16.2
G1 Z15.8
G1 E.8 F1800
G1 F3230
G2 X137.834 Y131.523 I-.413 J-2.14 E.03172
G1 X138.11 Y131.239 E.01314
G2 X138.466 Y130.413 I-2.022 J-1.359 E.03
G1 X141.885 Y130.422 E.11344
G3 X142.386 Y130.539 I.091 J.738 E.01741
G3 X142.496 Y130.884 I-.666 J.403 E.01212
G1 X142.496 Y134.296 E.1132
G1 X138.681 Y134.286 E.12657
G1 X138.686 Y132.127 E.07161
G1 X136.984 Y132.123 E.05646
G1 X136.97 Y131.961 E.00539
; WIPE_START
G1 F16213.044
G1 X137.131 Y131.87 E-.07018
G1 X137.502 Y131.734 E-.1502
G1 X137.834 Y131.523 E-.14964
G1 X138.11 Y131.239 E-.15057
G1 X138.315 Y130.892 E-.15302
G1 X138.383 Y130.675 E-.08639
; WIPE_END
G1 E-.04 F1800
G1 X130.779 Y131.332 Z16.2 F30000
G1 X117.676 Y132.464 Z16.2
G1 Z15.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.671 Y134.61 E.06596
G1 X117.671 Y134.622 E.00038
G1 X113.071 Y134.61 E.14134
G1 X113.071 Y134.598 E.00038
G1 X113.08 Y130.999 E.11058
G3 X113.312 Y130.188 I1.167 J-.106 E.02652
G3 X113.864 Y129.966 I.611 J.722 E.01861
G1 X117.856 Y129.966 E.12267
G2 X118.391 Y131.166 I1.682 J-.031 E.04146
G2 X119.287 Y131.507 I1.102 J-1.545 E.0298
G1 X119.661 Y131.528 E.0115
G1 X136.313 Y131.572 E.51168
G2 X137.327 Y131.38 I.036 J-2.578 E.03191
G2 X138.051 Y130.459 I-.642 J-1.25 E.03714
G2 X138.127 Y130.02 I-2.862 J-.72 E.0137
G1 X141.896 Y130.03 E.11581
G3 X142.67 Y130.266 I.1 J1.061 E.02552
G3 X142.897 Y131.078 I-.94 J.7 E.02651
G1 X142.887 Y134.677 E.11058
G1 X142.887 Y134.689 E.00038
G1 X138.287 Y134.677 E.14134
G1 X138.288 Y134.665 E.00038
G1 X138.293 Y132.518 E.06596
G1 X138.252 Y132.518 E.00126
G1 X117.736 Y132.464 E.6304
M204 S10000
G1 X118.168 Y131.758 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107437
G1 F3230
G2 X118.32 Y131.85 I.184 J-.133 E.00096
G1 X117.735 Y131.614 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.539 Y131.403 E.00883
G1 X117.296 Y130.975 E.01514
G1 X117.226 Y130.748 E.00728
G1 X114.151 Y130.74 E.09448
G1 X113.907 Y130.775 E.00756
G1 X113.864 Y131.06 E.00885
G1 X113.857 Y133.828 E.08505
G1 X116.889 Y133.836 E.09315
G1 X116.894 Y131.866 E.06054
G1 X117.035 Y131.684 E.00707
G1 X117.729 Y131.669 E.02133
G1 X117.046 Y131.306 F30000
G1 F3230
G1 X116.951 Y131.125 E.00628
G1 X114.241 Y131.118 E.08327
G1 X114.235 Y133.452 E.07173
G1 X116.513 Y133.458 E.06998
G1 X116.517 Y131.865 E.04895
G1 X116.913 Y131.327 E.02054
G1 X116.987 Y131.315 E.00229
G1 X116.407 Y131.5 F30000
G1 F3230
G1 X114.617 Y131.496 E.055
G1 X114.613 Y133.076 E.04856
G1 X116.137 Y133.08 E.0468
G1 X116.14 Y131.864 E.03737
G1 X116.372 Y131.549 E.01203
G1 X115.763 Y131.876 F30000
G1 F3230
G1 X114.994 Y131.874 E.02363
G1 X114.991 Y132.7 E.02539
G1 X115.76 Y132.702 E.02363
G1 X115.762 Y131.936 E.02354
; WIPE_START
G1 F15000
G1 X115.76 Y132.702 E-.29115
G1 X114.991 Y132.7 E-.29226
G1 X114.993 Y132.235 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.193 Y131.985 Z16.2 F30000
G1 Z15.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591871
G1 F3230
G1 X119.655 Y131.998 E.02066
G1 X136.779 Y132.032 E.76602
G1 X137.653 Y131.902 F30000
; LINE_WIDTH: 0.107445
G1 F3230
G2 X137.806 Y131.81 I-.031 J-.225 E.00096
G1 X138.216 Y131.693 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.267 Y131.734 E.00203
G1 X138.948 Y131.745 E.02091
G1 X139.079 Y131.925 E.00685
G1 X139.074 Y133.895 E.06054
G1 X142.105 Y133.903 E.09315
G1 X142.113 Y131.134 E.08509
G1 X142.072 Y130.849 E.00885
G1 X141.794 Y130.814 E.00861
G1 X138.753 Y130.806 E.09344
G3 X138.257 Y131.65 I-1.988 J-.599 E.03037
G1 X138.93 Y131.364 F30000
G1 F3230
G1 X139.062 Y131.386 E.00414
G1 X139.456 Y131.926 E.02054
G1 X139.452 Y133.519 E.04895
G1 X141.729 Y133.525 E.06998
G1 X141.735 Y131.191 E.07173
G1 X139.025 Y131.183 E.08327
G1 X138.958 Y131.311 E.00443
G1 X139.567 Y131.562 F30000
G1 F3230
G1 X139.833 Y131.927 E.01387
G1 X139.83 Y133.143 E.03737
G1 X141.353 Y133.147 E.0468
G1 X141.357 Y131.567 E.04856
G1 X139.627 Y131.562 E.05316
G1 X140.21 Y131.941 F30000
G1 F3230
G1 X140.208 Y132.767 E.02539
G1 X140.977 Y132.769 E.02363
G1 X140.979 Y131.943 E.02539
G1 X140.27 Y131.941 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 16
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X140.979 Y131.943 E-.26947
G1 X140.977 Y132.769 E-.31396
G1 X140.512 Y132.768 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 80/118
; update layer progress
M73 L80
M991 S0 P79 ;notify layer change
G17
G3 Z16.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.285 Y132.124
G1 Z16
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.28 Y134.282 E.07161
G1 X113.464 Y134.272 E.12657
G1 X113.472 Y131.062 E.10649
G3 X113.594 Y130.516 I.854 J-.096 E.0189
G3 X113.903 Y130.41 I.362 J.551 E.01094
G1 X117.515 Y130.41 E.11983
G2 X117.866 Y131.238 I2.379 J-.52 E.03
G2 X118.842 Y131.875 I1.523 J-1.268 E.03925
G1 X119.008 Y131.907 E.00561
G1 X118.987 Y132.128 E.00739
G1 X117.345 Y132.124 E.05447
; WIPE_START
G1 F16213.044
G1 X117.284 Y134.123 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.871 Y133.287 Z16.4 F30000
G1 X136.964 Y131.954 Z16.4
G1 Z16
G1 E.8 F1800
G1 F3230
G2 X137.834 Y131.576 I-.412 J-2.14 E.03172
G1 X138.11 Y131.292 E.01314
G2 X138.466 Y130.466 I-2.022 J-1.359 E.03
G1 X141.885 Y130.475 E.11344
G3 X142.386 Y130.593 I.091 J.738 E.01741
G3 X142.496 Y130.937 I-.666 J.404 E.01211
G1 X142.496 Y134.35 E.1132
G1 X138.68 Y134.339 E.12657
G1 X138.686 Y132.181 E.07161
G1 X136.984 Y132.176 E.05646
G1 X136.97 Y132.014 E.00539
; WIPE_START
G1 F16213.044
G1 X137.131 Y131.924 E-.07018
G1 X137.501 Y131.787 E-.15017
G1 X137.834 Y131.576 E-.14966
G1 X138.11 Y131.292 E-.15057
G1 X138.315 Y130.945 E-.15309
G1 X138.383 Y130.728 E-.08632
; WIPE_END
G1 E-.04 F1800
G1 X130.779 Y131.385 Z16.4 F30000
G1 X117.676 Y132.517 Z16.4
G1 Z16
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.671 Y134.663 E.06596
G1 X117.671 Y134.676 E.00038
G1 X113.071 Y134.663 E.14134
G1 X113.071 Y134.651 E.00038
G1 X113.08 Y131.052 E.11058
G3 X113.311 Y130.241 I1.167 J-.106 E.02651
G3 X113.864 Y130.019 I.611 J.722 E.01861
G1 X117.856 Y130.019 E.12267
G2 X118.391 Y131.219 I1.682 J-.031 E.04146
G2 X119.287 Y131.56 I1.102 J-1.545 E.0298
G1 X119.661 Y131.581 E.0115
G1 X136.313 Y131.626 E.51168
G2 X137.327 Y131.433 I.036 J-2.578 E.03191
G2 X138.051 Y130.512 I-.642 J-1.25 E.03714
G2 X138.127 Y130.073 I-2.847 J-.717 E.01371
G1 X141.895 Y130.083 E.11581
G3 X142.67 Y130.319 I.1 J1.061 E.02552
G3 X142.897 Y131.132 I-.94 J.7 E.02651
G1 X142.887 Y134.73 E.11058
G1 X142.887 Y134.743 E.00038
G1 X138.287 Y134.73 E.14134
G1 X138.287 Y134.718 E.00038
G1 X138.293 Y132.572 E.06596
G1 X138.252 Y132.572 E.00126
G1 X117.736 Y132.517 E.6304
M204 S10000
G1 X118.167 Y131.811 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107456
G1 F3230
G2 X118.32 Y131.903 I.185 J-.133 E.00096
G1 X117.734 Y131.667 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.539 Y131.456 E.00882
G1 X117.296 Y131.028 E.01515
G1 X117.226 Y130.802 E.00728
G1 X114.152 Y130.794 E.09445
G1 X113.907 Y130.829 E.00759
G1 X113.864 Y131.113 E.00885
G1 X113.857 Y133.881 E.08505
G1 X116.889 Y133.889 E.09315
G1 X116.894 Y131.919 E.06054
G1 X117.034 Y131.737 E.00706
G1 X117.729 Y131.722 E.02133
G1 X117.046 Y131.359 F30000
G1 F3230
G1 X116.951 Y131.178 E.00628
G1 X114.241 Y131.171 E.08327
G1 X114.235 Y133.505 E.07173
G1 X116.512 Y133.511 E.06998
G1 X116.517 Y131.918 E.04895
G1 X116.913 Y131.38 E.02054
G1 X116.987 Y131.368 E.00229
G1 X116.407 Y131.554 F30000
G1 F3230
G1 X114.617 Y131.549 E.055
G1 X114.613 Y133.129 E.04856
G1 X116.136 Y133.133 E.0468
G1 X116.14 Y131.917 E.03737
G1 X116.372 Y131.602 E.01203
G1 X115.762 Y131.929 F30000
G1 F3230
G1 X114.993 Y131.927 E.02363
G1 X114.991 Y132.753 E.02538
G1 X115.76 Y132.755 E.02363
G1 X115.762 Y131.989 E.02354
; WIPE_START
G1 F15000
G1 X115.76 Y132.755 E-.29115
G1 X114.991 Y132.753 E-.29226
G1 X114.992 Y132.288 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.193 Y132.038 Z16.4 F30000
G1 Z16
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.655 Y132.052 E.02066
G1 X136.779 Y132.085 E.76601
G1 X137.653 Y131.955 F30000
; LINE_WIDTH: 0.107452
G1 F3230
G2 X137.806 Y131.863 I-.031 J-.226 E.00096
G1 X138.216 Y131.746 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.267 Y131.787 E.00203
G1 X138.948 Y131.798 E.0209
G1 X139.079 Y131.978 E.00685
G1 X139.074 Y133.948 E.06054
G1 X142.105 Y133.956 E.09315
G1 X142.112 Y131.187 E.08509
G1 X142.072 Y130.902 E.00885
G1 X141.794 Y130.867 E.00861
G1 X138.753 Y130.859 E.09345
G3 X138.257 Y131.703 I-1.989 J-.599 E.03037
G1 X138.929 Y131.417 F30000
G1 F3230
G1 X139.062 Y131.439 E.00414
G1 X139.456 Y131.979 E.02054
G1 X139.452 Y133.572 E.04895
G1 X141.729 Y133.578 E.06998
G1 X141.735 Y131.244 E.07173
G1 X139.025 Y131.237 E.08327
G1 X138.958 Y131.364 E.00443
G1 X139.567 Y131.615 F30000
G1 F3230
G1 X139.833 Y131.98 E.01387
G1 X139.83 Y133.196 E.03737
G1 X141.353 Y133.2 E.0468
G1 X141.357 Y131.62 E.04856
G1 X139.627 Y131.615 E.05316
G1 X140.21 Y131.994 F30000
G1 F3230
G1 X140.208 Y132.82 E.02539
G1 X140.977 Y132.822 E.02363
G1 X140.979 Y131.996 E.02539
G1 X140.27 Y131.994 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 16.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X140.979 Y131.996 E-.26947
G1 X140.977 Y132.822 E-.31396
G1 X140.512 Y132.821 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 81/118
; update layer progress
M73 L81
M991 S0 P80 ;notify layer change
G17
G3 Z16.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.285 Y132.177
G1 Z16.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.279 Y134.336 E.07161
G1 X113.464 Y134.326 E.12657
G1 X113.472 Y131.115 E.1065
G3 X113.594 Y130.569 I.854 J-.096 E.0189
G3 X113.903 Y130.463 I.362 J.551 E.01094
G1 X117.515 Y130.464 E.11983
G2 X117.866 Y131.292 I2.377 J-.519 E.03
G2 X118.842 Y131.928 I1.523 J-1.269 E.03925
G1 X119.008 Y131.96 E.00561
G1 X118.987 Y132.181 E.00739
G1 X117.345 Y132.177 E.05447
; WIPE_START
G1 F16213.044
G1 X117.284 Y134.176 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.871 Y133.34 Z16.6 F30000
G1 X136.964 Y132.008 Z16.6
M73 P82 R3
G1 Z16.2
G1 E.8 F1800
G1 F3230
G2 X137.834 Y131.63 I-.412 J-2.139 E.03172
G1 X138.11 Y131.345 E.01315
G2 X138.465 Y130.519 I-2.02 J-1.358 E.03
G1 X141.885 Y130.528 E.11344
G3 X142.386 Y130.646 I.091 J.738 E.01741
G3 X142.496 Y130.99 I-.666 J.404 E.01211
G1 X142.496 Y134.403 E.1132
G1 X138.68 Y134.393 E.12657
G1 X138.686 Y132.234 E.07161
G1 X136.984 Y132.229 E.05646
G1 X136.969 Y132.067 E.00539
; WIPE_START
G1 F16213.044
G1 X137.13 Y131.977 E-.07015
G1 X137.501 Y131.84 E-.15018
G1 X137.834 Y131.63 E-.14967
G1 X138.11 Y131.345 E-.15059
G1 X138.315 Y130.998 E-.15315
G1 X138.383 Y130.782 E-.08627
; WIPE_END
G1 E-.04 F1800
G1 X130.779 Y131.438 Z16.6 F30000
G1 X117.676 Y132.57 Z16.6
G1 Z16.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.67 Y134.717 E.06596
G1 X117.67 Y134.729 E.00038
G1 X113.071 Y134.717 E.14134
G1 X113.071 Y134.704 E.00038
G1 X113.08 Y131.106 E.11058
G3 X113.311 Y130.294 I1.167 J-.106 E.02651
G3 X113.864 Y130.073 I.611 J.722 E.01861
G1 X117.856 Y130.072 E.12267
G2 X118.391 Y131.272 I1.682 J-.031 E.04146
G2 X119.287 Y131.614 I1.102 J-1.545 E.0298
G1 X119.661 Y131.635 E.0115
G1 X136.313 Y131.679 E.51168
G2 X137.327 Y131.487 I.036 J-2.578 E.03191
G2 X138.051 Y130.566 I-.642 J-1.25 E.03712
G2 X138.127 Y130.126 I-2.831 J-.715 E.01372
G1 X141.895 Y130.136 E.11581
G3 X142.67 Y130.372 I.1 J1.061 E.02552
G3 X142.897 Y131.185 I-.94 J.7 E.02651
G1 X142.887 Y134.784 E.11058
G1 X142.887 Y134.796 E.00038
G1 X138.287 Y134.784 E.14134
G1 X138.287 Y134.771 E.00038
G1 X138.293 Y132.625 E.06596
G1 X138.252 Y132.625 E.00126
G1 X117.736 Y132.57 E.6304
M204 S10000
G1 X118.167 Y131.864 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107468
G1 F3230
G2 X118.32 Y131.957 I.185 J-.133 E.00096
G1 X117.734 Y131.72 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.539 Y131.51 E.00881
G1 X117.295 Y131.081 E.01515
G1 X117.226 Y130.855 E.00727
G1 X114.153 Y130.847 E.09441
G1 X113.907 Y130.882 E.00762
G1 X113.864 Y131.167 E.00885
G1 X113.857 Y133.935 E.08505
G1 X116.888 Y133.943 E.09315
G1 X116.894 Y131.972 E.06054
G1 X117.034 Y131.791 E.00706
G1 X117.728 Y131.775 E.02133
G1 X117.046 Y131.412 F30000
G1 F3230
G1 X116.951 Y131.231 E.00628
G1 X114.241 Y131.224 E.08327
G1 X114.235 Y133.559 E.07173
G1 X116.512 Y133.565 E.06998
G1 X116.517 Y131.971 E.04895
G1 X116.913 Y131.433 E.02054
G1 X116.987 Y131.421 E.00229
G1 X116.407 Y131.607 F30000
G1 F3230
G1 X114.617 Y131.602 E.055
G1 X114.613 Y133.182 E.04856
G1 X116.136 Y133.187 E.0468
G1 X116.139 Y131.97 E.03737
G1 X116.372 Y131.655 E.01203
G1 X115.762 Y131.982 F30000
G1 F3230
G1 X114.993 Y131.98 E.02363
G1 X114.991 Y132.806 E.02538
G1 X115.76 Y132.808 E.02363
G1 X115.762 Y132.042 E.02354
; WIPE_START
G1 F15000
G1 X115.76 Y132.808 E-.29115
G1 X114.991 Y132.806 E-.29226
G1 X114.992 Y132.342 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.193 Y132.092 Z16.6 F30000
G1 Z16.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.654 Y132.105 E.02066
G1 X136.779 Y132.138 E.76601
G1 X137.653 Y132.008 F30000
; LINE_WIDTH: 0.107457
G1 F3230
G2 X137.806 Y131.917 I-.031 J-.226 E.00096
G1 X138.216 Y131.8 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.267 Y131.841 E.00203
G1 X138.947 Y131.851 E.0209
G1 X139.079 Y132.031 E.00685
G1 X139.073 Y134.002 E.06054
G1 X142.105 Y134.01 E.09315
G1 X142.112 Y131.24 E.08509
G1 X142.072 Y130.955 E.00885
G1 X141.794 Y130.92 E.00861
G1 X138.753 Y130.912 E.09345
G3 X138.257 Y131.757 I-1.99 J-.6 E.03037
G1 X138.929 Y131.47 F30000
G1 F3230
G1 X139.062 Y131.492 E.00414
G1 X139.456 Y132.032 E.02054
G1 X139.452 Y133.626 E.04895
G1 X141.729 Y133.632 E.06998
G1 X141.735 Y131.297 E.07173
G1 X139.025 Y131.29 E.08327
G1 X138.957 Y131.417 E.00443
G1 X139.567 Y131.668 F30000
G1 F3230
G1 X139.833 Y132.033 E.01387
G1 X139.83 Y133.25 E.03737
G1 X141.353 Y133.254 E.0468
G1 X141.357 Y131.673 E.04856
G1 X139.627 Y131.669 E.05316
G1 X140.21 Y132.047 F30000
G1 F3230
G1 X140.208 Y132.873 E.02539
G1 X140.977 Y132.875 E.02363
G1 X140.979 Y132.049 E.02539
G1 X140.27 Y132.047 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 16.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X140.979 Y132.049 E-.26947
G1 X140.977 Y132.875 E-.31396
G1 X140.512 Y132.874 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 82/118
; update layer progress
M73 L82
M991 S0 P81 ;notify layer change
G17
G3 Z16.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.285 Y132.23
G1 Z16.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.279 Y134.389 E.07161
G1 X113.464 Y134.379 E.12657
G1 X113.472 Y131.168 E.1065
G3 X113.594 Y130.622 I.854 J-.096 E.0189
G3 X113.902 Y130.517 I.362 J.551 E.01093
G1 X117.515 Y130.517 E.11983
G2 X117.866 Y131.345 I2.377 J-.518 E.03
G2 X118.842 Y131.982 I1.523 J-1.269 E.03925
G1 X119.008 Y132.013 E.00561
G1 X118.987 Y132.235 E.00739
G1 X117.345 Y132.23 E.05447
; WIPE_START
G1 F16213.044
G1 X117.284 Y134.229 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.871 Y133.393 Z16.8 F30000
G1 X136.964 Y132.061 Z16.8
G1 Z16.4
G1 E.8 F1800
G1 F3218
G2 X137.834 Y131.683 I-.413 J-2.14 E.03172
G1 X138.11 Y131.399 E.01315
G2 X138.465 Y130.573 I-2.019 J-1.357 E.03
G1 X141.885 Y130.582 E.11344
G3 X142.385 Y130.699 I.091 J.738 E.01741
G3 X142.496 Y131.044 I-.666 J.403 E.01211
G1 X142.496 Y134.456 E.1132
G1 X138.68 Y134.446 E.12657
G1 X138.686 Y132.287 E.07161
G1 X136.984 Y132.283 E.05646
G1 X136.969 Y132.121 E.00539
; WIPE_START
G1 F16213.044
G1 X137.13 Y132.03 E-.07014
G1 X137.501 Y131.893 E-.15022
G1 X137.834 Y131.683 E-.14965
G1 X138.11 Y131.399 E-.1506
G1 X138.315 Y131.051 E-.15317
G1 X138.383 Y130.835 E-.08622
; WIPE_END
G1 E-.04 F1800
G1 X130.778 Y131.492 Z16.8 F30000
G1 X117.676 Y132.623 Z16.8
G1 Z16.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.67 Y134.77 E.06596
G1 X117.67 Y134.782 E.00038
G1 X113.07 Y134.77 E.14134
G1 X113.07 Y134.758 E.00038
G1 X113.08 Y131.159 E.11058
G3 X113.311 Y130.348 I1.167 J-.106 E.02651
G3 X113.864 Y130.126 I.611 J.722 E.01861
G1 X117.856 Y130.126 E.12267
G2 X118.391 Y131.325 I1.681 J-.031 E.04147
G2 X119.287 Y131.667 I1.102 J-1.545 E.0298
G1 X119.661 Y131.688 E.0115
G1 X136.313 Y131.732 E.51168
G2 X137.327 Y131.54 I.036 J-2.578 E.03191
G2 X138.05 Y130.62 I-.642 J-1.25 E.03711
G2 X138.126 Y130.18 I-2.817 J-.713 E.01373
G1 X141.895 Y130.19 E.11581
G3 X142.67 Y130.426 I.1 J1.061 E.02552
G3 X142.896 Y131.238 I-.94 J.7 E.02652
G1 X142.887 Y134.837 E.11058
G1 X142.887 Y134.849 E.00038
G1 X138.287 Y134.837 E.14134
G1 X138.287 Y134.825 E.00038
G1 X138.293 Y132.678 E.06596
G1 X138.252 Y132.678 E.00126
G1 X117.736 Y132.623 E.6304
M204 S10000
G1 X118.167 Y131.918 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107461
G1 F3218
G2 X118.319 Y132.01 I.185 J-.133 E.00096
G1 X117.734 Y131.774 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.539 Y131.563 E.00882
G1 X117.295 Y131.134 E.01516
G1 X117.225 Y130.908 E.00727
G1 X114.153 Y130.9 E.09439
G1 X113.907 Y130.935 E.00765
G1 X113.864 Y131.22 E.00885
G1 X113.857 Y133.988 E.08505
G1 X116.888 Y133.996 E.09315
G1 X116.893 Y132.026 E.06054
G1 X117.034 Y131.844 E.00706
G1 X117.728 Y131.829 E.02134
G1 X117.046 Y131.465 F30000
G1 F3218
G1 X116.951 Y131.285 E.00628
G1 X114.241 Y131.277 E.08327
G1 X114.235 Y133.612 E.07173
G1 X116.512 Y133.618 E.06998
G1 X116.516 Y132.025 E.04895
G1 X116.913 Y131.486 E.02054
G1 X116.987 Y131.475 E.00229
G1 X116.407 Y131.66 F30000
G1 F3218
G1 X114.617 Y131.655 E.055
G1 X114.613 Y133.236 E.04856
G1 X116.136 Y133.24 E.0468
G1 X116.139 Y132.024 E.03737
G1 X116.372 Y131.708 E.01203
G1 X115.762 Y132.036 F30000
G1 F3218
G1 X114.993 Y132.033 E.02363
G1 X114.991 Y132.86 E.02538
G1 X115.76 Y132.862 E.02363
G1 X115.762 Y132.096 E.02354
; WIPE_START
G1 F15000
G1 X115.76 Y132.862 E-.29115
G1 X114.991 Y132.86 E-.29226
G1 X114.992 Y132.395 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.193 Y132.145 Z16.8 F30000
G1 Z16.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591871
G1 F3218
G1 X136.317 Y132.203 E.76602
G1 X136.779 Y132.192 E.02066
G1 X137.653 Y132.061 F30000
; LINE_WIDTH: 0.10744
G1 F3218
G2 X137.805 Y131.97 I-.031 J-.225 E.00096
G1 X138.215 Y131.853 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.267 Y131.894 E.00202
G1 X138.947 Y131.905 E.02091
G1 X139.079 Y132.085 E.00685
G1 X139.073 Y134.055 E.06054
G1 X142.105 Y134.063 E.09315
G1 X142.112 Y131.294 E.08509
G1 X142.072 Y131.008 E.00885
G1 X141.794 Y130.973 E.00861
G1 X138.753 Y130.965 E.09345
G3 X138.257 Y131.81 I-1.99 J-.6 E.03037
G1 X138.929 Y131.524 F30000
G1 F3218
G1 X139.062 Y131.545 E.00414
G1 X139.456 Y132.086 E.02054
G1 X139.451 Y133.679 E.04895
G1 X141.729 Y133.685 E.06998
G1 X141.735 Y131.35 E.07173
G1 X139.025 Y131.343 E.08327
G1 X138.957 Y131.471 E.00443
G1 X139.567 Y131.722 F30000
G1 F3218
G1 X139.833 Y132.087 E.01387
G1 X139.829 Y133.303 E.03737
G1 X141.353 Y133.307 E.0468
G1 X141.357 Y131.726 E.04856
G1 X139.627 Y131.722 E.05316
G1 X140.21 Y132.1 F30000
G1 F3218
G1 X140.208 Y132.927 E.02539
G1 X140.977 Y132.929 E.02363
G1 X140.979 Y132.103 E.02539
G1 X140.27 Y132.101 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 16.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X140.979 Y132.103 E-.26947
G1 X140.977 Y132.929 E-.31396
G1 X140.512 Y132.928 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 83/118
; update layer progress
M73 L83
M991 S0 P82 ;notify layer change
G17
G3 Z16.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.285 Y132.283
G1 Z16.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.279 Y134.442 E.07161
G1 X113.463 Y134.432 E.12657
G1 X113.472 Y131.222 E.10649
G3 X113.594 Y130.676 I.854 J-.096 E.0189
G3 X113.902 Y130.57 I.362 J.552 E.01093
G1 X117.515 Y130.57 E.11984
G2 X117.865 Y131.398 I2.375 J-.518 E.03
G2 X118.842 Y132.035 I1.523 J-1.269 E.03925
G1 X119.008 Y132.066 E.00561
G1 X118.987 Y132.288 E.00739
G1 X117.345 Y132.284 E.05447
; WIPE_START
G1 F16213.044
G1 X117.284 Y134.283 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.87 Y133.447 Z17 F30000
G1 X136.964 Y132.114 Z17
G1 Z16.6
G1 E.8 F1800
G1 F3218
G2 X137.834 Y131.736 I-.412 J-2.139 E.03172
G1 X138.11 Y131.452 E.01315
G2 X138.465 Y130.626 I-2.017 J-1.356 E.03
G1 X141.885 Y130.635 E.11344
G3 X142.385 Y130.752 I.091 J.738 E.01741
G3 X142.496 Y131.097 I-.667 J.404 E.01211
G1 X142.496 Y134.509 E.1132
G1 X138.68 Y134.499 E.12657
G1 X138.686 Y132.34 E.07161
G1 X136.984 Y132.336 E.05646
G1 X136.969 Y132.174 E.00539
; WIPE_START
G1 F16213.044
G1 X137.13 Y132.083 E-.07014
G1 X137.501 Y131.947 E-.1502
G1 X137.834 Y131.736 E-.14967
G1 X138.11 Y131.452 E-.15061
G1 X138.314 Y131.104 E-.15323
G1 X138.382 Y130.888 E-.08615
; WIPE_END
G1 E-.04 F1800
G1 X130.778 Y131.545 Z17 F30000
G1 X117.676 Y132.677 Z17
G1 Z16.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.67 Y134.823 E.06596
G1 X117.67 Y134.835 E.00038
G1 X113.07 Y134.823 E.14134
G1 X113.07 Y134.811 E.00038
G1 X113.08 Y131.212 E.11058
G3 X113.311 Y130.401 I1.167 J-.106 E.02652
G3 X113.863 Y130.179 I.611 J.722 E.0186
G1 X117.856 Y130.179 E.12267
G2 X118.391 Y131.379 I1.68 J-.03 E.04147
G2 X119.287 Y131.72 I1.102 J-1.545 E.0298
M73 P83 R3
G1 X119.661 Y131.741 E.0115
G1 X136.313 Y131.785 E.51168
G2 X137.326 Y131.593 I.036 J-2.578 E.03191
G2 X138.05 Y130.673 I-.642 J-1.249 E.0371
G2 X138.126 Y130.233 I-2.804 J-.712 E.01374
G1 X141.895 Y130.243 E.11581
G3 X142.67 Y130.479 I.1 J1.061 E.02552
G3 X142.896 Y131.291 I-.94 J.7 E.02651
G1 X142.887 Y134.89 E.11058
G1 X142.887 Y134.902 E.00038
G1 X138.287 Y134.89 E.14134
G1 X138.287 Y134.878 E.00038
G1 X138.293 Y132.731 E.06596
G1 X138.252 Y132.731 E.00126
G1 X117.736 Y132.677 E.6304
M204 S10000
G1 X118.167 Y131.971 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107462
G1 F3218
G2 X118.319 Y132.063 I.185 J-.133 E.00096
G1 X117.734 Y131.827 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.539 Y131.616 E.00881
G1 X117.295 Y131.187 E.01516
G1 X117.225 Y130.961 E.00726
G1 X114.154 Y130.953 E.09435
G1 X113.907 Y130.989 E.00768
G1 X113.864 Y131.273 E.00885
G1 X113.857 Y134.041 E.08505
G1 X116.888 Y134.049 E.09315
G1 X116.893 Y132.079 E.06054
G1 X117.034 Y131.897 E.00706
G1 X117.728 Y131.882 E.02134
G1 X117.046 Y131.519 F30000
G1 F3218
G1 X116.951 Y131.338 E.00628
G1 X114.241 Y131.331 E.08327
G1 X114.235 Y133.665 E.07173
G1 X116.512 Y133.671 E.06998
G1 X116.516 Y132.078 E.04895
G1 X116.913 Y131.54 E.02054
G1 X116.987 Y131.528 E.00229
G1 X116.407 Y131.713 F30000
G1 F3218
G1 X114.617 Y131.709 E.055
G1 X114.613 Y133.289 E.04856
G1 X116.136 Y133.293 E.0468
G1 X116.139 Y132.077 E.03737
G1 X116.371 Y131.762 E.01203
G1 X115.762 Y132.089 F30000
G1 F3218
G1 X114.993 Y132.087 E.02363
G1 X114.991 Y132.913 E.02538
G1 X115.76 Y132.915 E.02363
G1 X115.762 Y132.149 E.02354
; WIPE_START
G1 F15000
G1 X115.76 Y132.915 E-.29115
G1 X114.991 Y132.913 E-.29227
G1 X114.992 Y132.448 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.192 Y132.198 Z17 F30000
G1 Z16.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591871
G1 F3218
G1 X136.317 Y132.256 E.76603
M73 P83 R2
G1 X136.779 Y132.245 E.02066
G1 X137.653 Y132.115 F30000
; LINE_WIDTH: 0.107446
G1 F3218
G2 X137.805 Y132.023 I-.031 J-.225 E.00096
G1 X138.215 Y131.906 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.267 Y131.947 E.00203
G1 X138.947 Y131.958 E.02091
G1 X139.078 Y132.138 E.00685
G1 X139.073 Y134.108 E.06054
G1 X142.105 Y134.116 E.09315
G1 X142.112 Y131.347 E.08509
G1 X142.072 Y131.062 E.00885
G1 X141.794 Y131.027 E.00861
G1 X138.752 Y131.019 E.09345
G3 X138.257 Y131.863 I-1.99 J-.6 E.03037
G1 X138.929 Y131.577 F30000
G1 F3218
G1 X139.062 Y131.599 E.00414
G1 X139.455 Y132.139 E.02054
G1 X139.451 Y133.732 E.04895
G1 X141.729 Y133.738 E.06998
G1 X141.735 Y131.404 E.07173
G1 X139.025 Y131.396 E.08327
G1 X138.957 Y131.524 E.00443
G1 X139.567 Y131.775 F30000
G1 F3218
G1 X139.833 Y132.14 E.01387
G1 X139.829 Y133.356 E.03737
G1 X141.353 Y133.36 E.0468
G1 X141.357 Y131.78 E.04856
G1 X139.627 Y131.775 E.05316
G1 X140.21 Y132.154 F30000
G1 F3218
G1 X140.207 Y132.98 E.02539
G1 X140.976 Y132.982 E.02363
G1 X140.979 Y132.156 E.02539
G1 X140.27 Y132.154 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 16.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X140.979 Y132.156 E-.26947
G1 X140.976 Y132.982 E-.31396
G1 X140.512 Y132.981 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 84/118
; update layer progress
M73 L84
M991 S0 P83 ;notify layer change
G17
G3 Z17 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.285 Y132.337
G1 Z16.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.279 Y134.495 E.07161
G1 X113.463 Y134.485 E.12657
G1 X113.472 Y131.275 E.10649
G3 X113.594 Y130.729 I.854 J-.096 E.01891
G3 X113.902 Y130.623 I.361 J.551 E.01093
G1 X117.515 Y130.623 E.11984
G2 X117.865 Y131.451 I2.373 J-.517 E.03
G2 X118.842 Y132.088 I1.523 J-1.269 E.03925
G1 X119.008 Y132.12 E.00561
G1 X118.987 Y132.341 E.00739
G1 X117.345 Y132.337 E.05447
; WIPE_START
G1 F16213.044
G1 X117.284 Y134.336 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.87 Y133.5 Z17.2 F30000
G1 X136.964 Y132.167 Z17.2
G1 Z16.8
G1 E.8 F1800
G1 F3230
G2 X137.834 Y131.789 I-.412 J-2.139 E.03172
G1 X138.11 Y131.505 E.01315
G2 X138.465 Y130.679 I-2.016 J-1.356 E.03
G1 X141.885 Y130.688 E.11344
G3 X142.385 Y130.806 I.091 J.738 E.01742
G3 X142.496 Y131.15 I-.666 J.404 E.01211
G1 X142.496 Y134.563 E.1132
G1 X138.68 Y134.552 E.12657
G1 X138.686 Y132.394 E.07161
G1 X136.984 Y132.389 E.05646
G1 X136.969 Y132.227 E.0054
; WIPE_START
G1 F16213.044
G1 X137.13 Y132.137 E-.07017
G1 X137.501 Y132 E-.15017
G1 X137.834 Y131.789 E-.14969
G1 X138.11 Y131.505 E-.15058
G1 X138.314 Y131.157 E-.15329
G1 X138.382 Y130.941 E-.08609
; WIPE_END
G1 E-.04 F1800
G1 X130.778 Y131.598 Z17.2 F30000
G1 X117.676 Y132.73 Z17.2
G1 Z16.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.67 Y134.876 E.06596
G1 X117.67 Y134.889 E.00038
G1 X113.07 Y134.876 E.14134
G1 X113.07 Y134.864 E.00038
G1 X113.08 Y131.265 E.11058
G3 X113.311 Y130.454 I1.167 J-.106 E.02652
G3 X113.863 Y130.232 I.61 J.722 E.0186
G1 X117.855 Y130.232 E.12267
G2 X118.39 Y131.432 I1.68 J-.03 E.04147
G2 X119.287 Y131.773 I1.102 J-1.545 E.02979
G1 X119.66 Y131.794 E.0115
G1 X136.313 Y131.839 E.51168
G2 X137.326 Y131.646 I.036 J-2.578 E.03191
G2 X138.05 Y130.727 I-.641 J-1.249 E.03709
G2 X138.126 Y130.286 I-2.784 J-.709 E.01376
G1 X141.895 Y130.296 E.1158
G3 X142.669 Y130.532 I.1 J1.061 E.02552
G3 X142.896 Y131.345 I-.94 J.7 E.02651
G1 X142.887 Y134.943 E.11058
G1 X142.887 Y134.956 E.00038
G1 X138.287 Y134.943 E.14134
G1 X138.287 Y134.931 E.00038
G1 X138.293 Y132.785 E.06596
G1 X138.252 Y132.785 E.00126
G1 X117.736 Y132.73 E.6304
M204 S10000
G1 X118.167 Y132.024 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107447
G1 F3230
G2 X118.319 Y132.116 I.185 J-.133 E.00096
G1 X117.734 Y131.88 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.539 Y131.669 E.00882
G1 X117.295 Y131.24 E.01516
G1 X117.225 Y131.015 E.00726
G1 X114.155 Y131.007 E.09432
G1 X113.907 Y131.042 E.00772
G1 X113.864 Y131.327 E.00885
G1 X113.856 Y134.094 E.08505
G1 X116.888 Y134.102 E.09315
G1 X116.893 Y132.132 E.06054
G1 X117.034 Y131.95 E.00706
G1 X117.728 Y131.935 E.02134
G1 X117.046 Y131.572 F30000
G1 F3230
G1 X116.951 Y131.391 E.00628
G1 X114.241 Y131.384 E.08327
G1 X114.234 Y133.718 E.07173
G1 X116.512 Y133.724 E.06998
G1 X116.516 Y132.131 E.04895
G1 X116.913 Y131.593 E.02054
G1 X116.986 Y131.581 E.00229
G1 X116.407 Y131.767 F30000
G1 F3230
G1 X114.617 Y131.762 E.055
G1 X114.613 Y133.342 E.04856
G1 X116.136 Y133.346 E.0468
G1 X116.139 Y132.13 E.03737
G1 X116.371 Y131.815 E.01203
G1 X115.762 Y132.142 F30000
G1 F3230
G1 X114.993 Y132.14 E.02363
G1 X114.991 Y132.966 E.02538
G1 X115.76 Y132.968 E.02363
G1 X115.762 Y132.202 E.02354
; WIPE_START
G1 F15000
G1 X115.76 Y132.968 E-.29114
G1 X114.991 Y132.966 E-.29227
G1 X114.992 Y132.501 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.192 Y132.251 Z17.2 F30000
G1 Z16.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
G1 F3230
G1 X119.654 Y132.265 E.02066
G1 X136.778 Y132.298 E.76601
G1 X137.652 Y132.168 F30000
; LINE_WIDTH: 0.10744
G1 F3230
G2 X137.805 Y132.076 I-.031 J-.225 E.00096
G1 X138.215 Y131.959 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.267 Y132 E.00203
G1 X138.947 Y132.011 E.02091
G1 X139.078 Y132.191 E.00685
G1 X139.073 Y134.161 E.06054
G1 X142.105 Y134.169 E.09315
G1 X142.112 Y131.4 E.08509
G1 X142.071 Y131.115 E.00885
G1 X141.793 Y131.08 E.00861
G1 X138.752 Y131.072 E.09345
G3 X138.257 Y131.916 I-1.991 J-.6 E.03037
G1 X138.929 Y131.63 F30000
G1 F3230
G1 X139.062 Y131.652 E.00414
G1 X139.455 Y132.192 E.02054
G1 X139.451 Y133.785 E.04895
G1 X141.728 Y133.791 E.06998
G1 X141.735 Y131.457 E.07173
G1 X139.025 Y131.45 E.08327
G1 X138.957 Y131.577 E.00443
G1 X139.567 Y131.828 F30000
G1 F3230
G1 X139.832 Y132.193 E.01387
G1 X139.829 Y133.409 E.03737
G1 X141.352 Y133.413 E.0468
G1 X141.357 Y131.833 E.04856
G1 X139.626 Y131.828 E.05316
G1 X140.209 Y132.207 F30000
G1 F3230
G1 X140.207 Y133.033 E.02539
G1 X140.976 Y133.035 E.02363
G1 X140.979 Y132.209 E.02539
G1 X140.269 Y132.207 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 17
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X140.979 Y132.209 E-.26947
G1 X140.976 Y133.035 E-.31395
G1 X140.512 Y133.034 E-.17658
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 85/118
; update layer progress
M73 L85
M991 S0 P84 ;notify layer change
G17
G3 Z17.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.285 Y132.39
G1 Z17
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.279 Y134.549 E.07161
G1 X113.463 Y134.539 E.12657
G1 X113.472 Y131.328 E.10649
G3 X113.593 Y130.782 I.854 J-.096 E.0189
G3 X113.902 Y130.676 I.361 J.551 E.01093
G1 X117.515 Y130.677 E.11984
G2 X117.865 Y131.504 I2.371 J-.516 E.02999
G2 X118.842 Y132.141 I1.523 J-1.268 E.03925
G1 X119.008 Y132.173 E.00561
G1 X118.987 Y132.394 E.00739
G1 X117.345 Y132.39 E.05447
; WIPE_START
G1 F16213.044
G1 X117.284 Y134.389 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.87 Y133.553 Z17.4 F30000
G1 X136.963 Y132.221 Z17.4
G1 Z17
G1 E.8 F1800
G1 F3218
G2 X137.833 Y131.843 I-.413 J-2.14 E.03172
G1 X138.11 Y131.558 E.01315
G2 X138.465 Y130.732 I-2.015 J-1.355 E.03
G1 X141.885 Y130.741 E.11345
G3 X142.385 Y130.859 I.091 J.738 E.01741
G3 X142.496 Y131.203 I-.665 J.403 E.01212
G1 X142.495 Y134.616 E.1132
G1 X138.68 Y134.606 E.12657
G1 X138.686 Y132.447 E.07161
G1 X136.983 Y132.442 E.05646
G1 X136.969 Y132.28 E.0054
; WIPE_START
G1 F16213.044
G1 X137.13 Y132.19 E-.07014
G1 X137.501 Y132.053 E-.15022
G1 X137.833 Y131.843 E-.14965
G1 X138.11 Y131.558 E-.15061
G1 X138.314 Y131.211 E-.15333
G1 X138.382 Y130.995 E-.08605
; WIPE_END
G1 E-.04 F1800
G1 X130.778 Y131.651 Z17.4 F30000
G1 X117.676 Y132.783 Z17.4
G1 Z17
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.67 Y134.93 E.06596
G1 X117.67 Y134.942 E.00038
G1 X113.07 Y134.93 E.14134
G1 X113.07 Y134.917 E.00038
G1 X113.08 Y131.319 E.11058
G3 X113.311 Y130.507 I1.167 J-.106 E.02652
G3 X113.863 Y130.286 I.611 J.722 E.0186
G1 X117.855 Y130.285 E.12267
G2 X118.39 Y131.485 I1.679 J-.03 E.04147
G2 X119.287 Y131.827 I1.102 J-1.545 E.02979
G1 X119.66 Y131.848 E.0115
G1 X136.313 Y131.892 E.51168
G2 X137.326 Y131.7 I.036 J-2.577 E.03191
G2 X138.05 Y130.78 I-.641 J-1.249 E.03708
G2 X138.126 Y130.339 I-2.771 J-.707 E.01377
G1 X141.895 Y130.349 E.11581
G3 X142.669 Y130.585 I.1 J1.062 E.02552
G3 X142.896 Y131.398 I-.94 J.7 E.02651
G1 X142.886 Y134.997 E.11058
G1 X142.886 Y135.009 E.00038
G1 X138.287 Y134.997 E.14134
G1 X138.287 Y134.984 E.00038
G1 X138.292 Y132.838 E.06596
G1 X138.251 Y132.838 E.00126
G1 X117.736 Y132.783 E.6304
M204 S10000
G1 X118.167 Y132.077 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107468
G1 F3218
G2 X118.319 Y132.17 I.185 J-.133 E.00096
G1 X117.733 Y131.933 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.538 Y131.723 E.00882
G1 X117.295 Y131.293 E.01517
G1 X117.225 Y131.068 E.00725
G1 X114.156 Y131.06 E.09429
G1 X113.907 Y131.095 E.00775
G1 X113.864 Y131.38 E.00884
G1 X113.856 Y134.148 E.08505
G1 X116.888 Y134.156 E.09315
G1 X116.893 Y132.185 E.06054
G1 X117.033 Y132.004 E.00706
G1 X117.728 Y131.988 E.02134
G1 X117.046 Y131.625 F30000
G1 F3218
G1 X116.951 Y131.444 E.00628
G1 X114.241 Y131.437 E.08327
G1 X114.234 Y133.772 E.07173
G1 X116.512 Y133.778 E.06998
G1 X116.516 Y132.184 E.04895
G1 X116.913 Y131.646 E.02054
G1 X116.986 Y131.634 E.00229
G1 X116.407 Y131.82 F30000
M73 P84 R2
G1 F3218
G1 X114.617 Y131.815 E.055
G1 X114.612 Y133.395 E.04856
G1 X116.136 Y133.4 E.0468
G1 X116.139 Y132.183 E.03737
G1 X116.371 Y131.868 E.01203
G1 X115.762 Y132.195 F30000
G1 F3218
G1 X114.993 Y132.193 E.02363
G1 X114.99 Y133.019 E.02538
G1 X115.76 Y133.021 E.02363
G1 X115.762 Y132.255 E.02354
; WIPE_START
G1 F15000
G1 X115.76 Y133.021 E-.29115
G1 X114.99 Y133.019 E-.29227
G1 X114.992 Y132.555 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.192 Y132.305 Z17.4 F30000
G1 Z17
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591871
G1 F3218
G1 X136.317 Y132.362 E.76602
G1 X136.778 Y132.351 E.02066
G1 X137.652 Y132.221 F30000
; LINE_WIDTH: 0.107471
G1 F3218
G2 X137.805 Y132.13 I-.031 J-.226 E.00096
G1 X138.215 Y132.013 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.267 Y132.054 E.00203
G1 X138.947 Y132.064 E.0209
G1 X139.078 Y132.244 E.00685
G1 X139.073 Y134.215 E.06054
G1 X142.104 Y134.223 E.09315
G1 X142.112 Y131.453 E.08509
G1 X142.071 Y131.168 E.00885
G1 X141.793 Y131.133 E.00861
G1 X138.752 Y131.125 E.09345
G3 X138.257 Y131.969 I-1.991 J-.601 E.03036
G1 X138.929 Y131.683 F30000
G1 F3218
G1 X139.061 Y131.705 E.00414
G1 X139.455 Y132.245 E.02054
G1 X139.451 Y133.839 E.04895
G1 X141.728 Y133.845 E.06998
G1 X141.735 Y131.51 E.07173
G1 X139.025 Y131.503 E.08327
G1 X138.957 Y131.63 E.00443
G1 X139.566 Y131.881 F30000
G1 F3218
G1 X139.832 Y132.246 E.01387
G1 X139.829 Y133.463 E.03737
G1 X141.352 Y133.467 E.0468
G1 X141.356 Y131.886 E.04856
G1 X139.626 Y131.882 E.05316
G1 X140.209 Y132.26 F30000
G1 F3218
G1 X140.207 Y133.086 E.02539
G1 X140.976 Y133.088 E.02363
G1 X140.978 Y132.262 E.02539
G1 X140.269 Y132.26 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 17.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X140.978 Y132.262 E-.26947
G1 X140.976 Y133.088 E-.31396
G1 X140.512 Y133.087 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 86/118
; update layer progress
M73 L86
M991 S0 P85 ;notify layer change
G17
G3 Z17.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.284 Y132.443
G1 Z17.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3218
G1 X117.279 Y134.602 E.07161
G1 X113.463 Y134.592 E.12657
G1 X113.472 Y131.381 E.1065
G3 X113.593 Y130.835 I.854 J-.096 E.0189
G3 X113.902 Y130.73 I.361 J.551 E.01092
G1 X117.514 Y130.73 E.11985
G2 X117.865 Y131.558 I2.371 J-.516 E.02999
G2 X118.841 Y132.195 I1.523 J-1.268 E.03925
G1 X119.008 Y132.226 E.00561
G1 X118.987 Y132.448 E.00739
G1 X117.344 Y132.443 E.05447
; WIPE_START
G1 F16213.044
G1 X117.284 Y134.442 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.87 Y133.606 Z17.6 F30000
G1 X136.963 Y132.274 Z17.6
G1 Z17.2
G1 E.8 F1800
G1 F3218
G2 X137.833 Y131.896 I-.413 J-2.14 E.03172
G1 X138.11 Y131.612 E.01315
G2 X138.464 Y130.786 I-2.014 J-1.354 E.03
G1 X141.884 Y130.795 E.11345
G3 X142.385 Y130.912 I.091 J.738 E.01741
G3 X142.495 Y131.257 I-.666 J.403 E.01211
G1 X142.495 Y134.669 E.1132
G1 X138.68 Y134.659 E.12657
G1 X138.685 Y132.5 E.07161
G1 X136.983 Y132.496 E.05646
G1 X136.969 Y132.334 E.00539
; WIPE_START
G1 F16213.044
G1 X137.13 Y132.243 E-.07016
G1 X137.501 Y132.106 E-.15021
G1 X137.833 Y131.896 E-.14966
G1 X138.11 Y131.612 E-.15061
G1 X138.314 Y131.264 E-.15336
G1 X138.382 Y131.048 E-.086
; WIPE_END
G1 E-.04 F1800
G1 X130.778 Y131.705 Z17.6 F30000
G1 X117.675 Y132.836 Z17.6
G1 Z17.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3218
M204 S5000
G1 X117.67 Y134.983 E.06596
G1 X117.67 Y134.995 E.00038
G1 X113.07 Y134.983 E.14134
G1 X113.07 Y134.971 E.00038
G1 X113.079 Y131.372 E.11058
G3 X113.311 Y130.561 I1.167 J-.106 E.02652
G3 X113.863 Y130.339 I.611 J.722 E.0186
G1 X117.855 Y130.339 E.12267
G2 X118.39 Y131.538 I1.678 J-.029 E.04147
G2 X119.286 Y131.88 I1.102 J-1.545 E.0298
G1 X119.66 Y131.901 E.0115
G1 X136.312 Y131.945 E.51168
G2 X137.326 Y131.753 I.036 J-2.577 E.03191
G2 X138.049 Y130.834 I-.641 J-1.249 E.03707
G2 X138.126 Y130.393 I-2.757 J-.705 E.01378
G1 X141.895 Y130.403 E.11581
G3 X142.669 Y130.639 I.1 J1.061 E.02552
G3 X142.896 Y131.451 I-.94 J.7 E.02651
G1 X142.886 Y135.05 E.11058
G1 X142.886 Y135.062 E.00038
G1 X138.287 Y135.05 E.14134
G1 X138.287 Y135.038 E.00038
G1 X138.292 Y132.891 E.06596
G1 X138.251 Y132.891 E.00126
G1 X117.735 Y132.836 E.6304
M204 S10000
G1 X118.166 Y132.131 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107476
G1 F3218
G2 X118.319 Y132.223 I.185 J-.133 E.00096
G1 X117.733 Y131.986 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X117.538 Y131.776 E.00882
G1 X117.294 Y131.346 E.01517
G1 X117.225 Y131.121 E.00724
G1 X114.157 Y131.113 E.09427
G1 X113.906 Y131.148 E.00777
G1 X113.863 Y131.433 E.00884
G1 X113.856 Y134.201 E.08505
G1 X116.888 Y134.209 E.09315
G1 X116.893 Y132.239 E.06054
G1 X117.033 Y132.057 E.00706
G1 X117.728 Y132.042 E.02134
G1 X117.045 Y131.678 F30000
G1 F3218
G1 X116.95 Y131.498 E.00628
G1 X114.24 Y131.49 E.08327
G1 X114.234 Y133.825 E.07173
G1 X116.512 Y133.831 E.06998
G1 X116.516 Y132.238 E.04895
G1 X116.912 Y131.699 E.02054
G1 X116.986 Y131.688 E.00229
G1 X116.407 Y131.873 F30000
G1 F3218
G1 X114.616 Y131.868 E.055
G1 X114.612 Y133.449 E.04856
G1 X116.136 Y133.453 E.0468
G1 X116.139 Y132.237 E.03737
G1 X116.371 Y131.921 E.01203
G1 X115.762 Y132.249 F30000
G1 F3218
G1 X114.993 Y132.247 E.02363
G1 X114.99 Y133.073 E.02538
G1 X115.759 Y133.075 E.02363
G1 X115.761 Y132.309 E.02354
; WIPE_START
G1 F15000
G1 X115.759 Y133.075 E-.29115
G1 X114.99 Y133.073 E-.29226
G1 X114.992 Y132.608 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.192 Y132.358 Z17.6 F30000
G1 Z17.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591871
G1 F3218
G1 X136.317 Y132.416 E.76602
G1 X136.778 Y132.405 E.02065
G1 X137.652 Y132.274 F30000
; LINE_WIDTH: 0.107466
G1 F3218
G2 X137.805 Y132.183 I-.031 J-.226 E.00096
G1 X138.215 Y132.066 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3218
G1 X138.267 Y132.107 E.00203
G1 X138.947 Y132.118 E.0209
G1 X139.078 Y132.298 E.00685
G1 X139.073 Y134.268 E.06054
G1 X142.104 Y134.276 E.09315
G1 X142.112 Y131.507 E.08509
G1 X142.071 Y131.221 E.00885
G1 X141.793 Y131.187 E.00861
G1 X138.752 Y131.178 E.09345
G3 X138.257 Y132.023 I-1.991 J-.601 E.03036
G1 X138.928 Y131.737 F30000
G1 F3218
G1 X139.061 Y131.758 E.00414
G1 X139.455 Y132.299 E.02054
G1 X139.451 Y133.892 E.04895
G1 X141.728 Y133.898 E.06998
G1 X141.734 Y131.563 E.07173
G1 X139.024 Y131.556 E.08327
G1 X138.957 Y131.684 E.00443
G1 X139.566 Y131.935 F30000
G1 F3218
G1 X139.832 Y132.3 E.01387
G1 X139.829 Y133.516 E.03737
G1 X141.352 Y133.52 E.0468
G1 X141.356 Y131.939 E.04856
G1 X139.626 Y131.935 E.05316
G1 X140.209 Y132.313 F30000
G1 F3218
G1 X140.207 Y133.14 E.02539
G1 X140.976 Y133.142 E.02363
G1 X140.978 Y132.316 E.02539
G1 X140.269 Y132.314 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 17.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X140.978 Y132.316 E-.26947
G1 X140.976 Y133.142 E-.31396
G1 X140.511 Y133.141 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 87/118
; update layer progress
M73 L87
M991 S0 P86 ;notify layer change
G17
G3 Z17.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.284 Y132.496
G1 Z17.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3230
G1 X117.279 Y134.655 E.07161
G1 X113.463 Y134.645 E.12657
G1 X113.471 Y131.435 E.10649
G3 X113.593 Y130.889 I.854 J-.096 E.0189
G3 X113.901 Y130.783 I.361 J.551 E.01092
G1 X117.514 Y130.783 E.11985
G2 X117.865 Y131.611 I2.37 J-.515 E.02999
G2 X118.841 Y132.248 I1.523 J-1.269 E.03925
G1 X119.007 Y132.279 E.00561
G1 X118.986 Y132.501 E.00739
G1 X117.344 Y132.497 E.05447
; WIPE_START
G1 F16213.044
G1 X117.283 Y134.496 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.87 Y133.66 Z17.8 F30000
G1 X136.963 Y132.327 Z17.8
G1 Z17.4
G1 E.8 F1800
G1 F3230
G2 X137.833 Y131.949 I-.412 J-2.14 E.03172
G1 X138.109 Y131.665 E.01315
G2 X138.464 Y130.839 I-2.012 J-1.353 E.02999
G1 X141.884 Y130.848 E.11345
G3 X142.385 Y130.965 I.091 J.738 E.01741
G3 X142.495 Y131.31 I-.666 J.404 E.01211
G1 X142.495 Y134.722 E.1132
G1 X138.679 Y134.712 E.12657
G1 X138.685 Y132.553 E.07161
G1 X136.983 Y132.549 E.05646
G1 X136.969 Y132.387 E.00539
; WIPE_START
G1 F16213.044
G1 X137.13 Y132.296 E-.07018
G1 X137.5 Y132.16 E-.15017
G1 X137.833 Y131.949 E-.14968
G1 X138.109 Y131.665 E-.15065
G1 X138.314 Y131.317 E-.15338
G1 X138.382 Y131.101 E-.08593
; WIPE_END
G1 E-.04 F1800
G1 X130.778 Y131.758 Z17.8 F30000
G1 X117.675 Y132.89 Z17.8
G1 Z17.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3230
M204 S5000
G1 X117.67 Y135.036 E.06596
G1 X117.67 Y135.048 E.00038
G1 X113.072 Y135.036 E.14128
G1 X113.071 Y135.024 E.00038
G1 X113.079 Y131.425 E.11058
G3 X113.31 Y130.614 I1.167 J-.106 E.02651
G3 X113.863 Y130.392 I.611 J.722 E.01861
G1 X117.855 Y130.392 E.12267
G2 X118.39 Y131.592 I1.679 J-.029 E.04147
G2 X119.286 Y131.933 I1.102 J-1.545 E.02979
G1 X119.66 Y131.954 E.0115
G1 X136.312 Y131.998 E.51168
G2 X137.326 Y131.806 I.036 J-2.578 E.03191
G2 X138.049 Y130.887 I-.641 J-1.249 E.03706
G2 X138.126 Y130.446 I-2.743 J-.703 E.01379
G1 X141.894 Y130.456 E.11581
G3 X142.669 Y130.692 I.1 J1.062 E.02552
G3 X142.896 Y131.504 I-.94 J.7 E.02651
G1 X142.885 Y135.103 E.11058
G1 X142.884 Y135.115 E.00038
G1 X138.286 Y135.103 E.14128
G1 X138.286 Y135.091 E.00038
G1 X138.292 Y132.944 E.06596
G1 X138.251 Y132.944 E.00126
G1 X117.735 Y132.89 E.6304
M204 S10000
G1 X118.166 Y132.184 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107472
G1 F3230
G2 X118.319 Y132.276 I.185 J-.133 E.00096
G1 X117.733 Y132.04 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X117.538 Y131.829 E.00882
G1 X117.294 Y131.4 E.01518
G1 X117.225 Y131.174 E.00724
G1 X114.158 Y131.166 E.09423
G1 X113.906 Y131.202 E.00781
G1 X113.863 Y131.486 E.00884
G1 X113.856 Y134.254 E.08505
G1 X116.888 Y134.262 E.09315
G1 X116.893 Y132.292 E.06054
G1 X117.033 Y132.11 E.00705
G1 X117.727 Y132.095 E.02134
G1 X117.045 Y131.732 F30000
G1 F3230
G1 X116.95 Y131.551 E.00628
G1 X114.24 Y131.544 E.08327
G1 X114.234 Y133.878 E.07173
G1 X116.511 Y133.884 E.06998
G1 X116.516 Y132.291 E.04895
G1 X116.912 Y131.753 E.02054
G1 X116.986 Y131.741 E.00229
G1 X116.406 Y131.926 F30000
G1 F3230
G1 X114.616 Y131.922 E.055
G1 X114.612 Y133.502 E.04856
G1 X116.135 Y133.506 E.0468
G1 X116.139 Y132.29 E.03737
G1 X116.371 Y131.975 E.01203
G1 X115.761 Y132.302 F30000
G1 F3230
G1 X114.992 Y132.3 E.02363
G1 X114.99 Y133.126 E.02538
G1 X115.759 Y133.128 E.02363
G1 X115.761 Y132.362 E.02354
; WIPE_START
G1 F15000
G1 X115.759 Y133.128 E-.29114
G1 X114.99 Y133.126 E-.29227
G1 X114.991 Y132.661 E-.17659
; WIPE_END
G1 E-.04 F1800
G1 X119.192 Y132.411 Z17.8 F30000
G1 Z17.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.591861
M73 P85 R2
G1 F3230
G1 X119.654 Y132.424 E.02066
G1 X136.778 Y132.458 E.76601
G1 X137.652 Y132.328 F30000
; LINE_WIDTH: 0.10745
G1 F3230
G2 X137.805 Y132.236 I-.031 J-.225 E.00096
G1 X138.215 Y132.119 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3230
G1 X138.266 Y132.16 E.00203
G1 X138.947 Y132.171 E.0209
G1 X139.078 Y132.351 E.00685
G1 X139.073 Y134.321 E.06054
G1 X142.104 Y134.329 E.09315
G1 X142.111 Y131.56 E.08509
G1 X142.071 Y131.275 E.00885
G1 X141.793 Y131.24 E.00861
G1 X138.752 Y131.232 E.09345
G3 X138.256 Y132.076 I-1.992 J-.601 E.03037
G1 X138.928 Y131.79 F30000
G1 F3230
G1 X139.061 Y131.812 E.00414
G1 X139.455 Y132.352 E.02054
G1 X139.451 Y133.945 E.04895
G1 X141.728 Y133.951 E.06998
G1 X141.734 Y131.617 E.07173
G1 X139.024 Y131.609 E.08327
G1 X138.956 Y131.737 E.00443
G1 X139.566 Y131.988 F30000
G1 F3230
G1 X139.832 Y132.353 E.01387
G1 X139.829 Y133.569 E.03737
G1 X141.352 Y133.573 E.0468
G1 X141.356 Y131.993 E.04856
G1 X139.626 Y131.988 E.05316
G1 X140.209 Y132.367 F30000
G1 F3230
G1 X140.207 Y133.193 E.02539
G1 X140.976 Y133.195 E.02363
G1 X140.978 Y132.369 E.02539
G1 X140.269 Y132.367 E.02179
; CHANGE_LAYER
; Z_HEIGHT: 17.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X140.978 Y132.369 E-.26948
G1 X140.976 Y133.195 E-.31395
G1 X140.511 Y133.194 E-.17657
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 88/118
; update layer progress
M73 L88
M991 S0 P87 ;notify layer change
G17
G3 Z17.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.514 Y130.836
G1 Z17.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F4554
G2 X117.865 Y131.664 I2.368 J-.514 E.02999
G2 X118.841 Y132.301 I1.523 J-1.269 E.03926
G1 X119.007 Y132.333 E.00561
G1 X118.986 Y132.554 E.00739
G1 X117.284 Y132.55 E.05646
G1 X117.278 Y134.709 E.07161
G1 X113.472 Y134.698 E.12627
G3 X113.481 Y131.286 I160.561 J-1.283 E.1132
G3 X113.626 Y130.914 I.467 J-.031 E.01367
G3 X114.138 Y130.827 I.452 J1.114 E.01734
G1 X117.454 Y130.836 E.11002
; WIPE_START
G1 F16213.044
G1 X117.662 Y131.315 E-.19828
G1 X117.865 Y131.664 E-.15345
G1 X118.139 Y131.95 E-.1507
G1 X118.471 Y132.162 E-.14964
G1 X118.737 Y132.262 E-.10794
; WIPE_END
G1 E-.04 F1800
G1 X117.675 Y132.943 Z18 F30000
G1 Z17.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4554
M204 S5000
G1 X117.716 Y132.943 E.00126
G1 X138.251 Y132.998 E.63098
G1 X138.292 Y132.998 E.00126
G1 X138.29 Y133.781 E.02406
G1 X138.289 Y134.181 E.01229
G1 X138.288 Y134.581 E.01229
G1 F2145.086
G1 X138.247 Y134.581 E.00126
G1 F1800
G1 X137.878 Y134.58 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F3000
G1 X118.081 Y134.527 E.6567
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1800
G1 X117.712 Y134.526 E.01134
G1 F2145.086
G1 X117.671 Y134.526 E.00126
G1 F4554
G1 X117.672 Y134.126 E.01229
G1 X117.673 Y133.726 E.01229
G1 X117.674 Y133.213 E.01577
G1 X117.675 Y133.003 E.00645
; WIPE_START
G1 F12000
M204 S10000
G1 X117.716 Y132.943 E-.02761
G1 X119.643 Y132.948 E-.73239
; WIPE_END
G1 E-.04 F1800
G1 X127.272 Y132.698 Z18 F30000
G1 X136.963 Y132.38 Z18
G1 Z17.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F4554
G2 X137.833 Y132.002 I-.413 J-2.14 E.03172
G1 X138.109 Y131.718 E.01315
G2 X138.464 Y130.892 I-2.011 J-1.353 E.02999
G1 X141.884 Y130.901 E.11345
G3 X142.385 Y131.019 I.091 J.738 E.01742
G3 X142.495 Y131.363 I-.666 J.404 E.01211
G1 X142.504 Y131.565 E.00671
G3 X142.486 Y134.776 I-92.137 J1.1 E.1065
G1 X138.679 Y134.765 E.12627
G1 X138.685 Y132.607 E.07161
G1 X136.983 Y132.602 E.05646
G1 X136.968 Y132.44 E.00539
; WIPE_START
G1 F16213.044
G1 X137.129 Y132.35 E-.07012
G1 X137.5 Y132.213 E-.15023
G1 X137.833 Y132.002 E-.14965
G1 X138.109 Y131.718 E-.15064
G1 X138.314 Y131.37 E-.15347
G1 X138.382 Y131.154 E-.0859
; WIPE_END
G1 E-.04 F1800
G1 X130.754 Y130.891 Z18 F30000
G1 X117.855 Y130.445 Z18
G1 Z17.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4554
M204 S5000
G2 X118.39 Y131.645 I1.678 J-.029 E.04147
G2 X119.286 Y131.986 I1.102 J-1.545 E.02979
G1 X119.66 Y132.007 E.0115
G1 X136.312 Y132.052 E.51168
G2 X137.326 Y131.859 I.036 J-2.577 E.03191
G2 X138.049 Y130.941 I-.641 J-1.248 E.03705
G2 X138.126 Y130.499 I-2.726 J-.701 E.0138
G1 X141.894 Y130.509 E.11581
G3 X142.669 Y130.745 I.1 J1.062 E.02552
G3 X142.896 Y131.558 I-.94 J.7 E.02651
G3 X142.87 Y135.156 I-103.256 J1.077 E.11059
G1 X142.87 Y135.169 E.00038
G1 X113.085 Y135.089 E.91521
G1 X113.085 Y135.077 E.00038
G3 X113.09 Y131.246 I142.607 J-1.734 E.11771
G3 X113.407 Y130.587 I.85 J.002 E.02325
G3 X114.131 Y130.435 I.642 J1.262 E.02299
G1 X117.795 Y130.445 E.11258
; WIPE_START
G1 F12000
M204 S10000
G1 X117.908 Y130.799 E-.1411
G1 X118.02 Y131.151 E-.14053
G1 X118.18 Y131.426 E-.12098
G1 X118.39 Y131.645 E-.11512
G1 X118.648 Y131.81 E-.11624
G1 X118.947 Y131.922 E-.12164
G1 X118.959 Y131.924 E-.00438
; WIPE_END
G1 E-.04 F1800
G1 X117.733 Y132.093 Z18 F30000
G1 Z17.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F4554
G1 X117.538 Y131.882 E.00884
G1 X117.294 Y131.453 E.01518
G1 X117.225 Y131.228 E.00723
G1 X114.159 Y131.22 E.09421
G1 X113.906 Y131.255 E.00783
G1 X113.863 Y131.539 E.00883
G1 X113.864 Y134.307 E.08505
G1 X116.887 Y134.315 E.0929
G1 X116.893 Y132.345 E.06054
G1 X117.033 Y132.163 E.00705
G1 X117.727 Y132.148 E.02135
G1 X117.045 Y131.785 F30000
G1 F4554
G1 X116.95 Y131.604 E.00628
G1 X114.24 Y131.597 E.08326
G1 X114.241 Y133.931 E.07173
G1 X116.511 Y133.937 E.06977
G1 X116.516 Y132.344 E.04895
G1 X116.912 Y131.806 E.02055
G1 X116.986 Y131.794 E.00229
G1 X116.406 Y131.98 F30000
G1 F4554
G1 X114.618 Y131.975 E.05496
G1 X114.618 Y133.555 E.04856
G1 X116.135 Y133.559 E.04663
G1 X116.138 Y132.343 E.03737
G1 X116.371 Y132.028 E.01203
G1 X115.761 Y132.355 F30000
G1 F4554
G1 X114.995 Y132.353 E.02356
G1 X114.995 Y133.179 E.02538
G1 X115.759 Y133.181 E.02349
G1 X115.761 Y132.415 E.02354
G1 X118.167 Y132.237 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107423
G1 F4554
G2 X118.319 Y132.329 I.185 J-.133 E.00096
G1 X119.192 Y132.464 F30000
; LINE_WIDTH: 0.591861
G1 F4554
G1 X136.316 Y132.522 E.76601
G1 X136.778 Y132.511 E.02066
G1 X137.652 Y132.381 F30000
; LINE_WIDTH: 0.107472
G1 F4554
G2 X137.805 Y132.289 I-.031 J-.226 E.00096
G1 X138.215 Y132.172 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F4554
G1 X138.267 Y132.213 E.00204
G1 X138.946 Y132.224 E.02089
G1 X139.078 Y132.404 E.00685
G1 X139.072 Y134.374 E.06054
G1 X142.096 Y134.382 E.09291
G1 X142.111 Y131.613 E.0851
G1 X142.071 Y131.328 E.00885
G1 X141.794 Y131.293 E.00858
G1 X138.752 Y131.285 E.09348
G3 X138.256 Y132.129 I-1.992 J-.601 E.03036
G1 X138.928 Y131.843 F30000
G1 F4554
G1 X139.061 Y131.865 E.00414
G1 X139.455 Y132.405 E.02055
G1 X139.45 Y133.998 E.04895
G1 X141.721 Y134.004 E.06977
G1 X141.734 Y131.67 E.07173
G1 X139.024 Y131.663 E.08326
G1 X138.956 Y131.79 E.00443
G1 X139.566 Y132.041 F30000
G1 F4554
G1 X139.832 Y132.406 E.01388
G1 X139.829 Y133.622 E.03737
G1 X141.346 Y133.626 E.04663
G1 X141.355 Y132.046 E.04856
G1 X139.626 Y132.041 E.05312
G1 X140.209 Y132.42 F30000
G1 F4554
G1 X140.207 Y133.246 E.02539
G1 X140.971 Y133.248 E.02349
G1 X140.976 Y132.422 E.02539
G1 X140.269 Y132.42 E.02171
; WIPE_START
G1 F15000
G1 X140.976 Y132.422 E-.26854
G1 X140.971 Y133.248 E-.31396
G1 X140.504 Y133.247 E-.1775
; WIPE_END
G1 E-.04 F1800
G1 X138.483 Y134.869 Z18 F30000
G1 Z17.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.226662
G1 F4554
G1 X117.474 Y134.813 E.31456
; CHANGE_LAYER
; Z_HEIGHT: 17.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X119.474 Y134.819 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 89/118
; update layer progress
M73 L89
M991 S0 P88 ;notify layer change
G17
G3 Z18 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X117.845 Y131.684
G1 Z17.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F12477
G1 X117.864 Y131.717 E.0013
G2 X118.841 Y132.354 I1.524 J-1.269 E.03925
G1 X119.007 Y132.386 E.00561
G1 X118.986 Y132.608 E.00738
G1 X117.284 Y132.603 E.05646
G1 X117.282 Y133.366 E.0253
G1 X117.281 Y133.766 E.01327
G1 F10454.107
G1 X117.28 Y134.166 E.01327
G1 F4134.232
G1 X117.699 Y134.167 E.01392
G1 F600
G1 X138.261 Y134.222 E.68208
G1 F4134.232
G1 X138.681 Y134.223 E.01392
G1 F10454.107
G1 X138.682 Y133.823 E.01327
G1 F12477
G1 X138.683 Y133.423 E.01327
G1 X138.685 Y132.66 E.0253
G1 X136.983 Y132.655 E.05646
G1 X136.963 Y132.434 E.00739
G2 X137.833 Y132.056 I-.412 J-2.139 E.03172
G1 X138.109 Y131.771 E.01315
G2 X138.464 Y130.945 I-2.01 J-1.352 E.02999
G1 X141.884 Y130.954 E.11345
G3 X142.384 Y131.072 I.091 J.738 E.01741
G3 X142.495 Y131.416 I-.665 J.403 E.01211
G1 X142.503 Y131.618 E.00671
G3 X142.472 Y134.829 I-92.215 J.698 E.1065
G1 X113.486 Y134.752 E.96153
G3 X113.481 Y131.339 I94.897 J-1.846 E.11321
G3 X113.626 Y130.968 I.466 J-.031 E.01367
G3 X114.139 Y130.881 I.452 J1.114 E.01738
G1 X117.514 Y130.89 E.11197
G2 X117.67 Y131.364 I2.366 J-.513 E.0166
G1 X117.816 Y131.631 E.01009
; WIPE_START
G1 F16213.044
G1 X117.864 Y131.717 E-.03764
G1 X118.139 Y132.003 E-.15066
G1 X118.471 Y132.216 E-.14967
G1 X118.841 Y132.354 E-.15018
G1 X119.007 Y132.386 E-.06429
G1 X118.986 Y132.608 E-.0846
G1 X118.663 Y132.607 E-.12295
; WIPE_END
G1 E-.04 F1800
G1 X117.675 Y132.996 Z18.2 F30000
G1 Z17.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X117.716 Y132.996 E.00126
G1 X138.251 Y133.051 E.63098
G1 X138.292 Y133.051 E.00126
G1 X138.291 Y133.43 E.01163
G1 F7100.153
G1 X138.29 Y133.83 E.01229
G1 F2145.086
G1 X138.249 Y133.829 E.00126
G1 F1800
G1 X137.88 Y133.828 E.01134
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F3000
G1 X118.083 Y133.776 E.6567
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1800
G1 X117.714 Y133.775 E.01134
G1 F2145.086
G1 X117.673 Y133.775 E.00126
G1 F7100.153
G1 X117.674 Y133.375 E.01229
G1 F12000
G1 X117.675 Y133.056 E.00979
; WIPE_START
M204 S10000
G1 X117.716 Y132.996 E-.02761
G1 X119.643 Y133.001 E-.73239
; WIPE_END
G1 E-.04 F1800
G1 X118.188 Y131.474 Z18.2 F30000
G1 Z17.8
G1 E.8 F1800
G1 F12000
M204 S5000
G2 X118.39 Y131.698 I1.344 J-1.004 E.00929
G2 X119.286 Y132.04 I1.102 J-1.545 E.0298
G1 X119.66 Y132.061 E.0115
G1 X136.312 Y132.105 E.51168
G2 X137.326 Y131.913 I.036 J-2.577 E.03191
G2 X138.049 Y130.995 I-.641 J-1.248 E.03704
G2 X138.125 Y130.552 I-2.715 J-.7 E.01381
G1 X141.894 Y130.562 E.11581
G3 X142.669 Y130.798 I.1 J1.062 E.02552
G3 X142.895 Y131.611 I-.94 J.7 E.02652
G3 X142.856 Y135.21 I-103.339 J.674 E.11059
G1 X142.856 Y135.222 E.00038
G1 X113.099 Y135.143 E.91435
G1 X113.099 Y135.13 E.00038
G3 X113.09 Y131.3 I96.302 J-2.145 E.11772
G3 X113.407 Y130.64 I.85 J.002 E.02325
G3 X114.132 Y130.489 I.642 J1.263 E.02302
G1 X117.855 Y130.498 E.11439
G2 X118.153 Y131.425 I1.677 J-.029 E.03034
M204 S10000
G1 X117.733 Y132.146 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F12477
G1 X117.538 Y131.935 E.00882
G1 X117.294 Y131.506 E.01518
G1 X117.224 Y131.281 E.00723
G1 X114.159 Y131.273 E.09418
G1 X113.906 Y131.308 E.00786
G1 X113.863 Y131.593 E.00884
M73 P86 R2
G2 X113.872 Y134.361 I79.576 J1.128 E.08505
G1 X116.684 Y134.368 E.0864
G1 X116.722 Y134.03 E.01045
G1 X116.888 Y133.94 E.00582
G1 X116.892 Y132.398 E.04736
G1 X117.033 Y132.217 E.00705
G1 X117.727 Y132.201 E.02135
G1 X117.045 Y131.838 F30000
G1 F12477
G1 X116.95 Y131.657 E.00628
G1 X114.24 Y131.65 E.08327
G2 X114.244 Y133.985 I67.291 J1.065 E.07173
G1 X116.358 Y133.99 E.06497
G1 X116.42 Y133.804 E.00603
G1 X116.512 Y133.758 E.00315
G1 X116.515 Y132.397 E.04182
G1 X116.912 Y131.859 E.02055
G1 X116.986 Y131.847 E.00229
G1 X116.406 Y132.033 F30000
G1 F12477
G1 X114.616 Y132.028 E.055
G2 X114.615 Y133.608 I45.469 J.817 E.04856
G1 X116.107 Y133.612 E.04584
G1 X116.135 Y133.527 E.00276
G1 X116.138 Y132.396 E.03475
G1 X116.371 Y132.081 E.01203
G1 X115.761 Y132.408 F30000
G1 F12477
G1 X114.992 Y132.406 E.02363
G1 X114.99 Y133.232 E.02538
G1 X115.759 Y133.234 E.02363
G1 X115.761 Y132.468 E.02354
G1 X117.076 Y134.463 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.231918
G1 F12477
G1 X138.883 Y134.521 E.33586
; WIPE_START
G1 F15000
G1 X136.883 Y134.516 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.214 Y132.226 Z18.2 F30000
G1 Z17.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F12477
G1 X138.266 Y132.267 E.00203
G1 X138.946 Y132.277 E.0209
G1 X139.078 Y132.457 E.00686
G1 X139.073 Y134.014 E.04782
G1 X139.239 Y134.09 E.00561
G1 X139.276 Y134.428 E.01045
G1 X142.088 Y134.436 E.0864
G2 X142.103 Y131.48 I-68.119 J-1.834 E.09084
G1 X142.077 Y131.367 E.00356
G1 X141.979 Y131.356 E.00301
G1 X138.751 Y131.339 E.09919
G3 X138.256 Y132.183 I-1.993 J-.602 E.03034
G1 X138.928 Y131.896 F30000
G1 F12477
G1 X139.06 Y131.918 E.00411
G1 X139.455 Y132.458 E.02057
G1 X139.451 Y133.819 E.04182
G1 X139.542 Y133.866 E.00315
G1 X139.604 Y134.052 E.00603
G1 X141.718 Y134.058 E.06497
G2 X141.726 Y131.731 I-53.591 J-1.356 E.07149
G1 X139.023 Y131.717 E.08306
G1 X138.956 Y131.843 E.00439
G1 X139.567 Y132.097 F30000
G1 F12477
G1 X139.832 Y132.459 E.01378
G1 X139.829 Y133.633 E.03605
G1 X139.914 Y133.676 E.00293
G1 X141.348 Y133.68 E.04408
G2 X141.35 Y132.106 I-148.135 J-.925 E.04834
G1 X139.627 Y132.098 E.05293
G1 X140.209 Y132.478 F30000
G1 F12477
G1 X140.207 Y133.299 E.02525
G1 X140.975 Y133.302 E.02361
G1 X140.973 Y132.482 E.02519
G1 X140.269 Y132.478 E.02165
G1 X137.804 Y132.343 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.107449
G1 F12477
G3 X137.652 Y132.434 I-.184 J-.134 E.00096
G1 X136.778 Y132.564 F30000
; LINE_WIDTH: 0.591871
G1 F12022.943
G1 X136.316 Y132.575 E.02065
G1 X119.192 Y132.518 E.76602
G1 X118.318 Y132.383 F30000
; LINE_WIDTH: 0.107464
G1 F12477
G3 X118.166 Y132.29 I.033 J-.226 E.00096
; CHANGE_LAYER
; Z_HEIGHT: 18
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X118.256 Y132.364 E-.48886
G1 X118.318 Y132.383 E-.27114
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 90/118
; update layer progress
M73 L90
M991 S0 P89 ;notify layer change
G17
G3 Z18.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.111 Y132.028
G1 Z18
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F8010
G1 X118.146 Y132.048 E.00134
G2 X118.841 Y132.408 I1.242 J-1.546 E.02612
G2 X119.648 Y132.506 I.775 J-2.999 E.02705
G1 X136.321 Y132.55 E.55309
G2 X137.5 Y132.319 I.025 J-3 E.04011
G2 X138.425 Y131.159 I-.8 J-1.586 E.05077
G1 X138.464 Y130.999 E.00549
G1 X141.884 Y131.008 E.11345
G3 X142.384 Y131.125 I.091 J.738 E.01742
G3 X142.495 Y131.47 I-.666 J.404 E.01211
G3 X142.458 Y134.882 I-65.776 J.99 E.11321
G1 X113.499 Y134.805 E.9606
G3 X113.48 Y131.392 I65.828 J-2.073 E.11321
G3 X113.626 Y131.021 I.467 J-.031 E.01367
G3 X114.14 Y130.934 I.453 J1.115 E.01742
G1 X117.514 Y130.943 E.11193
G2 X117.864 Y131.771 I2.366 J-.513 E.02999
G1 X118.07 Y131.984 E.00983
M204 S250
G1 X118.437 Y131.782 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F8010
M204 S5000
G1 X118.651 Y131.908 E.00764
G2 X119.286 Y132.093 I.84 J-1.701 E.02041
G1 X119.66 Y132.114 E.0115
G1 X136.312 Y132.158 E.51168
G2 X137.325 Y131.966 I.036 J-2.578 E.03191
G2 X138.048 Y131.048 I-.64 J-1.248 E.03703
G2 X138.125 Y130.606 I-2.703 J-.698 E.01382
G1 X141.894 Y130.616 E.11581
G3 X142.669 Y130.852 I.1 J1.062 E.02552
G3 X142.895 Y131.664 I-.94 J.7 E.02651
G3 X142.842 Y135.263 I-103.341 J.272 E.11059
G1 X142.842 Y135.275 E.00038
G1 X113.113 Y135.196 E.91349
G1 X113.113 Y135.184 E.00038
G3 X113.09 Y131.353 I76.111 J-2.375 E.11773
G3 X113.407 Y130.693 I.85 J.002 E.02325
G3 X114.133 Y130.542 I.642 J1.264 E.02306
G1 X117.855 Y130.552 E.11436
G2 X118.387 Y131.749 I1.676 J-.028 E.04136
M204 S10000
G1 X117.674 Y132.138 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F8010
G1 X117.538 Y131.989 E.00622
G1 X117.294 Y131.559 E.01519
G1 X117.224 Y131.334 E.00722
G1 X114.16 Y131.326 E.09414
G1 X113.906 Y131.362 E.0079
G1 X113.863 Y131.646 E.00884
G2 X113.886 Y134.414 I79.554 J.726 E.08506
G1 X116.675 Y134.421 E.08571
G3 X116.709 Y134.121 I.383 J-.108 E.00952
G1 X116.868 Y133.937 E.00747
G1 X116.872 Y132.446 E.04581
G1 X116.928 Y132.313 E.00443
G1 X117.115 Y132.149 E.00766
G1 X117.614 Y132.139 E.01532
G1 X116.949 Y131.711 F30000
G1 F8010
G1 X114.24 Y131.703 E.08324
G2 X114.257 Y134.038 I67.137 J.662 E.07174
G1 X116.362 Y134.043 E.06466
G3 X116.491 Y133.797 I.394 J.05 E.00875
G1 X116.495 Y132.445 E.04152
G1 X116.662 Y132.046 E.0133
G1 X116.935 Y131.817 E.01096
G1 X116.989 Y131.796 E.00179
G1 X116.975 Y131.765 E.00105
G1 X116.267 Y132.086 F30000
G1 F8010
G1 X114.616 Y132.081 E.05075
G2 X114.629 Y133.662 I45.851 J.411 E.04856
G1 X116.11 Y133.666 E.04552
G2 X116.118 Y132.444 I-109.681 J-1.273 E.03753
G1 X116.244 Y132.141 E.0101
G1 X115.741 Y132.462 F30000
G1 F8010
G1 X114.992 Y132.46 E.023
G1 X115.001 Y133.286 E.02539
G1 X115.738 Y133.288 E.02267
G1 X115.741 Y132.521 E.02354
G1 X117.041 Y134.083 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.42013
G1 F3000
G1 X117.04 Y134.443 E.01108
G1 X117.084 Y134.481 E.00179
G1 X117.418 Y134.482 E.01024
G1 X117.423 Y132.515 E.06048
G1 X117.8 Y132.516 E.01159
G1 X117.795 Y134.483 E.06047
G1 X118.172 Y134.484 E.01159
G1 X118.177 Y132.477 E.06171
G2 X118.554 Y132.656 I.607 J-.79 E.01292
G1 X118.549 Y134.485 E.05622
G1 X118.926 Y134.486 E.01159
G1 X118.931 Y132.764 E.05294
G2 X119.308 Y132.821 I.403 J-1.395 E.01175
G1 X119.304 Y134.487 E.05122
G1 X119.681 Y134.488 E.01159
G1 X119.685 Y132.839 E.05068
G1 X120.062 Y132.84 E.01159
G1 X120.058 Y134.489 E.05068
G1 X120.435 Y134.49 E.01159
G1 X120.44 Y132.841 E.05068
G1 X120.817 Y132.842 E.01159
G1 X120.812 Y134.491 E.05068
G1 X121.19 Y134.492 E.01159
G1 X121.194 Y132.843 E.05068
G1 X121.571 Y132.844 E.01159
G1 X121.567 Y134.493 E.05068
G1 X121.944 Y134.494 E.01159
G1 X121.948 Y132.845 E.05068
G1 X122.326 Y132.846 E.01159
G1 X122.321 Y134.495 E.05068
G1 X122.698 Y134.496 E.01159
G1 X122.703 Y132.847 E.05068
G1 X123.08 Y132.848 E.01159
G1 X123.076 Y134.497 E.05068
G1 X123.453 Y134.498 E.01159
G1 X123.457 Y132.849 E.05068
G1 X123.834 Y132.85 E.01159
G1 X123.83 Y134.499 E.05068
G1 X124.207 Y134.5 E.01159
G1 X124.212 Y132.851 E.05068
G1 X124.589 Y132.852 E.01159
G1 X124.584 Y134.501 E.05068
G1 X124.962 Y134.502 E.01159
G1 X124.966 Y132.853 E.05068
G1 X125.343 Y132.854 E.01159
G1 X125.339 Y134.503 E.05068
G1 X125.716 Y134.504 E.01159
G1 X125.72 Y132.855 E.05068
G1 X126.098 Y132.856 E.01159
G1 X126.093 Y134.505 E.05068
G1 X126.471 Y134.506 E.01159
G1 X126.475 Y132.857 E.05068
G1 X126.852 Y132.858 E.01159
G1 X126.848 Y134.507 E.05068
G1 X127.225 Y134.508 E.01159
G1 X127.229 Y132.859 E.05068
G1 X127.607 Y132.86 E.01159
G1 X127.602 Y134.509 E.05068
G1 X127.979 Y134.51 E.01159
G1 X127.984 Y132.861 E.05068
G1 X128.361 Y132.862 E.01159
G1 X128.357 Y134.511 E.05068
G1 X128.734 Y134.512 E.01159
G1 X128.738 Y132.863 E.05068
G1 X129.115 Y132.864 E.01159
G1 X129.111 Y134.513 E.05068
G1 X129.488 Y134.514 E.01159
G1 X129.493 Y132.865 E.05068
G1 X129.87 Y132.866 E.01159
G1 X129.865 Y134.515 E.05068
G1 X130.243 Y134.516 E.01159
G1 X130.247 Y132.867 E.05068
G1 X130.624 Y132.868 E.01159
G1 X130.62 Y134.517 E.05068
G1 X130.997 Y134.518 E.01159
G1 X131.001 Y132.869 E.05068
G1 X131.379 Y132.87 E.01159
G1 X131.374 Y134.519 E.05068
G1 X131.751 Y134.52 E.01159
G1 X131.756 Y132.871 E.05068
G1 X132.133 Y132.872 E.01159
G1 X132.129 Y134.521 E.05068
G1 X132.506 Y134.522 E.01159
G1 X132.51 Y132.873 E.05068
G1 X132.887 Y132.874 E.01159
G1 X132.883 Y134.523 E.05068
G1 X133.26 Y134.524 E.01159
G1 X133.265 Y132.875 E.05068
G1 X133.642 Y132.876 E.01159
G1 X133.637 Y134.525 E.05068
G1 X134.015 Y134.526 E.01159
G1 X134.019 Y132.877 E.05068
G1 X134.396 Y132.878 E.01159
G1 X134.392 Y134.527 E.05068
G1 X134.769 Y134.528 E.01159
G1 X134.773 Y132.879 E.05068
G1 X135.151 Y132.88 E.01159
G1 X135.146 Y134.529 E.05068
G1 X135.524 Y134.53 E.01159
G1 X135.528 Y132.881 E.05068
G1 X135.905 Y132.882 E.01159
G1 X135.901 Y134.531 E.05068
G1 X136.278 Y134.532 E.01159
G1 X136.282 Y132.883 E.05068
G2 X136.66 Y132.867 I.033 J-3.561 E.01161
G1 X136.655 Y134.533 E.05122
G1 X137.032 Y134.534 E.01159
G1 X137.037 Y132.812 E.05294
G2 X137.414 Y132.706 I-.118 J-1.145 E.01211
G1 X137.41 Y134.535 E.05622
G1 X137.787 Y134.536 E.01159
G1 X137.792 Y132.529 E.0617
G1 X137.959 Y132.423 E.00607
G2 X138.169 Y132.57 I.363 J-.297 E.00798
G1 X138.164 Y134.537 E.06048
G1 X138.541 Y134.538 E.01159
G1 X138.546 Y132.571 E.06048
G1 X138.709 Y132.571 E.00501
G1 X138.716 Y134.102 E.04706
G1 X138.769 Y134.23 E.00424
G1 X138.919 Y134.381 E.00654
G1 X138.918 Y134.709 E.01009
G1 X138.298 Y132.193 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F8010
G1 X138.856 Y132.207 E.01716
G1 X139.043 Y132.372 E.00766
G1 X139.098 Y132.506 E.00443
G1 X139.094 Y133.996 E.0458
G1 X139.257 Y134.188 E.00772
G1 X139.296 Y134.482 E.00911
G1 X142.073 Y134.489 E.08534
G2 X142.103 Y131.533 I-60.583 J-2.086 E.09083
G1 X142.077 Y131.42 E.00357
G1 X141.979 Y131.409 E.00303
G1 X138.751 Y131.392 E.09917
G1 X138.664 Y131.655 E.00851
G1 X138.407 Y132.08 E.01526
G1 X138.339 Y132.15 E.003
G1 X139.024 Y131.771 F30000
G1 F8010
G1 X138.992 Y131.855 E.00279
G3 X139.31 Y132.106 I-.431 J.874 E.01254
G1 X139.475 Y132.507 E.0133
G1 X139.471 Y133.858 E.04152
G3 X139.605 Y134.105 I-.251 J.296 E.00884
G1 X141.704 Y134.111 E.06449
G2 X141.727 Y131.785 I-47.671 J-1.639 E.07149
G1 X139.084 Y131.771 E.08121
G1 X139.705 Y132.151 F30000
G1 F8010
G1 X139.852 Y132.508 E.01184
G1 X139.849 Y133.721 E.03728
G2 X141.334 Y133.733 I1.301 J-69.081 E.04565
G2 X141.352 Y132.16 I-32.229 J-1.141 E.04834
G1 X139.765 Y132.152 E.04874
G1 X140.229 Y132.531 F30000
G1 F8010
G1 X140.227 Y133.353 E.02525
G1 X140.965 Y133.355 E.02267
G2 X140.976 Y132.535 I-16.921 J-.646 E.0252
G1 X140.289 Y132.531 E.02112
; CHANGE_LAYER
; Z_HEIGHT: 18.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X140.976 Y132.535 E-.26114
G1 X140.965 Y133.355 E-.31159
G1 X140.472 Y133.353 E-.18728
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 91/118
; update layer progress
M73 L91
M991 S0 P90 ;notify layer change
G17
G3 Z18.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.174 Y132.132
G1 Z18.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F5094
G1 X118.474 Y132.315 E.01166
G2 X118.841 Y132.461 I.913 J-1.76 E.0131
G2 X119.648 Y132.559 I.775 J-2.999 E.02705
G1 X136.321 Y132.603 E.55309
G2 X137.5 Y132.373 I.024 J-3.001 E.04011
G2 X138.424 Y131.213 I-.8 J-1.586 E.05075
G1 X138.464 Y131.052 E.0055
G1 X141.884 Y131.061 E.11345
G3 X142.386 Y131.181 I.092 J.726 E.01752
G3 X142.495 Y131.523 I-.679 J.403 E.012
G3 X142.502 Y132.002 I-5.401 J.326 E.01591
G1 X142.444 Y134.935 E.09731
G1 X113.513 Y134.858 E.95967
G3 X113.471 Y131.648 I92.163 J-2.826 E.10651
G3 X113.593 Y131.102 I.854 J-.096 E.0189
G3 X113.901 Y130.996 I.361 J.55 E.01091
G1 X117.514 Y130.996 E.11986
G2 X117.864 Y131.824 I2.365 J-.512 E.02999
G2 X118.132 Y132.09 I1.523 J-1.269 E.01254
M204 S250
G1 X118.432 Y131.832 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F5094
M204 S5000
G1 X118.651 Y131.961 E.00783
G2 X119.286 Y132.146 I.84 J-1.701 E.02041
G1 X119.659 Y132.167 E.0115
G1 X136.312 Y132.211 E.51168
G2 X137.325 Y132.019 I.036 J-2.578 E.03191
G2 X138.048 Y131.102 I-.64 J-1.248 E.03702
G2 X138.125 Y130.659 I-2.69 J-.696 E.01383
G1 X141.894 Y130.669 E.1158
G3 X142.671 Y130.909 I.101 J1.053 E.02566
G3 X142.895 Y131.717 I-.944 J.696 E.02636
G1 X142.828 Y135.316 E.1106
G1 X142.828 Y135.328 E.00038
G1 X113.127 Y135.249 E.91262
G1 X113.127 Y135.237 E.00038
G1 X113.078 Y131.928 E.10169
G3 X113.168 Y131.054 I2.967 J-.137 E.02708
G3 X113.862 Y130.605 I.695 J.312 E.02687
G1 X117.854 Y130.605 E.12267
G2 X118.382 Y131.798 I1.675 J-.028 E.04118
; WIPE_START
G1 F12000
M204 S10000
G1 X118.651 Y131.961 E-.11948
G1 X118.947 Y132.082 E-.12134
G1 X119.286 Y132.146 E-.13106
G1 X119.659 Y132.167 E-.14223
G1 X120.306 Y132.169 E-.24589
; WIPE_END
G1 E-.04 F1800
G1 X127.932 Y132.493 Z18.6 F30000
G1 X139.692 Y132.993 Z18.6
G1 Z18.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.48791
G1 F5094
G1 X140.488 Y132.996 E.02889
G1 X138.71 Y133.402 F30000
; LINE_WIDTH: 0.41999
G1 F5094
G1 X140.951 Y133.408 E.06885
G1 X140.967 Y132.588 E.0252
G1 X139.463 Y132.58 E.04622
G1 X139.219 Y132.922 E.0129
G1 X138.754 Y133.361 E.01966
G1 X136.931 Y133.743 F30000
; LINE_WIDTH: 0.464135
G1 F5094
G1 X137.237 Y133.76 E.01049
; LINE_WIDTH: 0.420431
G1 X137.542 Y133.776 E.00941
G1 X141.32 Y133.786 E.11623
G1 X141.352 Y132.213 E.0484
G1 X139.248 Y132.202 E.06472
G1 X138.948 Y132.659 E.0168
G1 X138.466 Y133.118 E.02048
G1 X137.917 Y133.441 E.0196
G1 X137.354 Y133.634 E.0183
; LINE_WIDTH: 0.434705
G1 X137.172 Y133.681 E.00601
; LINE_WIDTH: 0.464135
G1 X136.989 Y133.728 E.00646
G1 X119.641 Y132.951 F30000
; LINE_WIDTH: 0.41999
G1 F5094
G3 X118.277 Y132.664 I.005 J-3.405 E.04314
G1 X117.873 Y132.399 E.01486
G1 X117.537 Y132.042 E.01505
G1 X117.293 Y131.612 E.01519
G1 X117.224 Y131.387 E.00722
G1 X114.161 Y131.379 E.09411
G1 X113.906 Y131.415 E.00794
G1 X113.864 Y131.703 E.00895
G1 X113.9 Y134.467 E.08494
G1 X142.059 Y134.542 E.86523
G1 X142.11 Y132.001 E.07808
G1 X142.104 Y131.586 E.01278
G1 X142.079 Y131.477 E.00341
G1 X141.572 Y131.46 E.01558
G1 X138.751 Y131.445 E.0867
G1 X138.663 Y131.708 E.0085
G1 X138.407 Y132.133 E.01526
G1 X138.063 Y132.481 E.01503
G1 X137.656 Y132.733 E.01472
G3 X136.326 Y132.996 I-1.321 J-3.191 E.04193
G1 X119.701 Y132.951 E.5108
G1 X119.64 Y133.328 F30000
G1 F5094
G3 X118.074 Y132.982 I-.044 J-3.513 E.04973
G1 X117.601 Y132.66 E.01757
G1 X117.234 Y132.268 E.0165
G1 X116.951 Y131.764 E.01777
G1 X114.241 Y131.757 E.08325
G1 X114.272 Y134.091 E.07174
G1 X141.69 Y134.164 E.84244
G1 X141.731 Y131.838 E.07149
G1 X139.022 Y131.824 E.08323
G1 X138.76 Y132.288 E.01639
G1 X138.367 Y132.715 E.01781
G1 X137.893 Y133.034 E.01757
G1 X137.379 Y133.237 E.01698
G3 X136.325 Y133.373 I-1.222 J-5.343 E.03271
G1 X119.7 Y133.328 E.5108
G1 X119.032 Y133.696 F30000
; LINE_WIDTH: 0.444223
G1 F5094
G2 X119.639 Y133.717 I.815 J-14.559 E.01989
G1 X136.324 Y133.761 E.54559
G1 X136.861 Y133.746 E.01757
G1 X119.032 Y133.696 F30000
; LINE_WIDTH: 0.466813
G1 F5094
G1 X118.743 Y133.618 E.01032
; LINE_WIDTH: 0.420447
G1 X118.455 Y133.54 E.00919
G1 X117.871 Y133.299 E.01944
G1 X117.329 Y132.921 E.02031
G1 X116.924 Y132.481 E.01841
G1 X116.722 Y132.14 E.01219
G1 X114.624 Y132.135 E.06457
G1 X114.645 Y133.715 E.04862
G1 X118.596 Y133.726 E.12158
; LINE_WIDTH: 0.435598
G1 X118.784 Y133.713 E.00602
; LINE_WIDTH: 0.466813
G1 X118.972 Y133.7 E.0065
M73 P87 R2
G1 X117.255 Y133.345 F30000
; LINE_WIDTH: 0.41999
G1 F5094
G1 X116.749 Y132.862 E.0215
G1 X116.505 Y132.517 E.01299
G1 X115.006 Y132.513 E.04607
G1 X115.017 Y133.339 E.02539
G1 X117.195 Y133.345 E.06693
G1 X115.424 Y132.927 F30000
; LINE_WIDTH: 0.49199
G1 F5094
G1 X116.213 Y132.929 E.02885
; CHANGE_LAYER
; Z_HEIGHT: 18.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F14697.042
G1 X115.424 Y132.927 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 92/118
; update layer progress
M73 L92
M991 S0 P91 ;notify layer change
G17
G3 Z18.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.175 Y132.186
G1 Z18.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3143
G1 X118.474 Y132.368 E.01161
G2 X118.841 Y132.514 I.913 J-1.76 E.0131
G2 X119.648 Y132.612 I.775 J-3.001 E.02705
G1 X136.321 Y132.657 E.55309
G2 X137.5 Y132.426 I.025 J-3 E.04011
G2 X138.424 Y131.267 I-.799 J-1.586 E.05074
G1 X138.463 Y131.105 E.00551
G1 X141.884 Y131.114 E.11346
G3 X142.384 Y131.232 I.091 J.738 E.01741
G3 X142.489 Y131.566 I-.593 J.37 E.01175
G1 X142.429 Y134.988 E.11355
G1 X113.527 Y134.912 E.95874
G1 X113.48 Y131.691 E.10685
G3 X113.593 Y131.155 I.788 J-.114 E.01854
G3 X113.9 Y131.049 I.361 J.551 E.01091
G1 X117.514 Y131.049 E.11986
G2 X117.864 Y131.877 I2.362 J-.511 E.02999
G2 X118.133 Y132.144 I1.523 J-1.269 E.01259
M204 S250
G1 X118.427 Y131.882 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3143
M204 S5000
G1 X118.651 Y132.014 E.00801
G2 X119.286 Y132.199 I.84 J-1.701 E.02041
G1 X119.659 Y132.22 E.0115
G1 X136.312 Y132.265 E.51168
G2 X137.325 Y132.072 I.036 J-2.577 E.03191
G2 X138.048 Y131.155 I-.64 J-1.248 E.037
G2 X138.125 Y130.712 I-2.676 J-.694 E.01384
G1 X141.894 Y130.722 E.11581
G3 X142.668 Y130.958 I.1 J1.061 E.02552
G3 X142.886 Y131.767 I-.892 J.674 E.02638
G1 X142.814 Y135.369 E.11071
G1 X142.814 Y135.382 E.00038
G1 X113.141 Y135.303 E.91176
G1 X113.141 Y135.29 E.00038
G1 X113.088 Y131.688 E.11071
G3 X113.31 Y130.88 I1.112 J-.128 E.02638
G3 X113.862 Y130.658 I.611 J.722 E.0186
G1 X117.854 Y130.658 E.12267
G2 X118.378 Y131.847 I1.675 J-.028 E.04099
; WIPE_START
G1 F12000
M204 S10000
G1 X118.651 Y132.014 E-.12174
G1 X118.947 Y132.135 E-.12134
G1 X119.286 Y132.199 E-.13107
G1 X119.659 Y132.22 E-.14223
G1 X120.3 Y132.222 E-.24363
; WIPE_END
G1 E-.04 F1800
G1 X118.063 Y133.386 Z18.8 F30000
G1 Z18.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.59759
G1 F3143
G1 X137.841 Y133.439 E.89395
; WIPE_START
G1 F11898.967
G1 X135.841 Y133.434 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.251 Y132.631 Z18.8 F30000
G1 X116.562 Y131.395 Z18.8
G1 Z18.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3143
G1 X114.933 Y131.391 E.05401
G1 X113.84 Y132.484 E.0513
G1 X113.87 Y134.564 E.069
G1 X119.421 Y134.579 E.18413
G1 X120.127 Y133.873 E.03313
G1 X120.522 Y133.874 E.01309
G1 X121.232 Y134.584 E.03331
G1 X127.077 Y134.599 E.19388
G1 X127.783 Y133.893 E.03313
G1 X128.218 Y133.894 E.01445
G1 X128.928 Y134.604 E.03331
G1 X134.732 Y134.62 E.19253
G1 X135.438 Y133.914 E.03313
G1 X135.915 Y133.915 E.0158
G1 X136.625 Y134.625 E.03331
G1 X142.087 Y134.639 E.1812
G1 X142.125 Y132.449 E.07265
G1 X141.143 Y131.467 E.04607
G1 X139.515 Y131.459 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 18.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X141.143 Y131.467 E-.61876
G1 X141.406 Y131.73 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 93/118
; update layer progress
M73 L93
M991 S0 P92 ;notify layer change
G17
G3 Z18.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.108 Y132.184
G1 Z18.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2968
G1 X118.146 Y132.207 E.00148
G2 X118.84 Y132.567 I1.242 J-1.546 E.02612
G2 X119.648 Y132.666 I.775 J-3 E.02705
G1 X136.321 Y132.71 E.55309
G2 X137.5 Y132.479 I.025 J-3 E.04011
G2 X138.424 Y131.32 I-.8 J-1.586 E.05073
G1 X138.463 Y131.158 E.00553
G1 X141.881 Y131.167 E.11337
G3 X142.374 Y131.281 I.092 J.728 E.01713
G3 X142.475 Y131.619 I-.656 J.381 E.01181
G1 X142.404 Y135.042 E.11356
G1 X113.553 Y134.965 E.95704
G1 X113.494 Y131.744 E.10686
G3 X113.603 Y131.205 I.838 J-.111 E.01859
G3 X113.903 Y131.103 I.351 J.538 E.01063
G1 X117.514 Y131.103 E.11978
G2 X117.864 Y131.93 I2.362 J-.511 E.02998
G1 X118.066 Y132.141 E.00969
M204 S250
G1 X118.421 Y131.932 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2968
M204 S5000
G1 X118.651 Y132.068 E.0082
G2 X119.285 Y132.253 I.84 J-1.702 E.02041
G1 X119.659 Y132.274 E.0115
G1 X136.311 Y132.318 E.51168
G2 X137.325 Y132.126 I.036 J-2.578 E.03191
G2 X138.047 Y131.209 I-.64 J-1.248 E.03699
G2 X138.125 Y130.765 I-2.664 J-.693 E.01385
G1 X141.891 Y130.775 E.11573
G3 X142.66 Y131.01 I.101 J1.045 E.02536
G3 X142.872 Y131.82 I-.933 J.677 E.02633
G1 X142.813 Y134.765 E.09049
G1 X142.774 Y135.422 E.02025
G1 X142.773 Y135.435 E.00038
G1 X113.181 Y135.356 E.90926
G1 X113.181 Y135.344 E.00038
G1 X113.145 Y134.686 E.02025
G1 X113.101 Y131.741 E.09049
G3 X113.318 Y130.932 I1.145 J-.127 E.02633
G3 X113.864 Y130.712 I.603 J.707 E.01844
G1 X117.854 Y130.711 E.1226
G2 X118.373 Y131.896 I1.675 J-.028 E.04081
; WIPE_START
G1 F12000
M204 S10000
G1 X118.651 Y132.068 E-.12399
G1 X118.947 Y132.188 E-.12134
G1 X119.285 Y132.253 E-.13107
G1 X119.659 Y132.274 E-.14222
G1 X120.294 Y132.275 E-.24138
; WIPE_END
G1 E-.04 F1800
G1 X127.921 Y131.973 Z19 F30000
G1 X139.568 Y131.512 Z19
G1 Z18.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2968
G1 X141.197 Y131.521 E.05401
G1 X142.11 Y132.434 E.04282
G1 X142.063 Y134.692 E.07495
G1 X136.678 Y134.678 E.17861
G1 X135.055 Y133.055 E.07615
G1 X136.294 Y133.058 E.0411
G1 X134.679 Y134.673 E.07575
G1 X128.982 Y134.658 E.18899
G1 X127.358 Y133.034 E.07615
G1 X128.638 Y133.038 E.04245
G1 X127.024 Y134.652 E.07575
G1 X121.285 Y134.637 E.19035
G1 X119.662 Y133.014 E.07615
G1 X120.983 Y133.017 E.0438
G1 X119.368 Y134.632 E.07575
G1 X113.895 Y134.618 E.18156
G1 X113.855 Y132.469 E.07129
G1 X114.88 Y131.444 E.04808
G1 X116.508 Y131.448 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 18.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X114.88 Y131.444 E-.61877
G1 X114.617 Y131.707 E-.14123
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 94/118
; update layer progress
M73 L94
M991 S0 P93 ;notify layer change
G17
G3 Z19 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.177 Y132.294
G1 Z18.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2900
G1 X118.474 Y132.475 E.01152
G2 X118.84 Y132.621 I.913 J-1.76 E.0131
G2 X119.647 Y132.719 I.775 J-2.999 E.02705
G1 X136.321 Y132.763 E.55309
G2 X137.499 Y132.533 I.025 J-3 E.04011
G2 X138.424 Y131.374 I-.799 J-1.586 E.05072
G1 X138.463 Y131.212 E.00554
G1 X141.867 Y131.221 E.11291
G3 X142.36 Y131.334 I.092 J.727 E.01712
G3 X142.461 Y131.672 I-.656 J.381 E.01181
G1 X142.423 Y133.998 E.07716
G1 X142.357 Y135.095 E.03645
G1 X113.599 Y135.018 E.95398
G1 X113.539 Y133.921 E.03646
G1 X113.507 Y131.797 E.07044
G3 X113.616 Y131.258 I.838 J-.111 E.01859
G3 X113.917 Y131.156 I.351 J.539 E.01065
G1 X117.514 Y131.156 E.11929
G2 X117.864 Y131.984 I2.361 J-.51 E.02998
G2 X118.135 Y132.252 I1.524 J-1.269 E.01268
M204 S250
G1 X118.416 Y131.982 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2900
M204 S5000
G1 X118.651 Y132.121 E.00838
G2 X119.285 Y132.306 I.84 J-1.701 E.02041
G1 X119.659 Y132.327 E.0115
G1 X136.311 Y132.371 E.51168
G2 X137.325 Y132.179 I.036 J-2.578 E.03191
G2 X138.047 Y131.263 I-.64 J-1.247 E.03698
G2 X138.125 Y130.819 I-2.648 J-.691 E.01386
G1 X141.877 Y130.829 E.1153
G3 X142.646 Y131.063 I.101 J1.045 E.02535
G3 X142.858 Y131.873 I-.933 J.677 E.02633
G1 X142.815 Y134.013 E.06577
G1 X142.727 Y135.476 E.04501
G1 X142.727 Y135.488 E.00038
G1 X113.227 Y135.409 E.90643
M73 P88 R2
G1 X113.227 Y135.397 E.00038
G1 X113.147 Y133.934 E.04501
G1 X113.115 Y131.794 E.06577
G3 X113.331 Y130.985 I1.145 J-.127 E.02633
G3 X113.878 Y130.765 I.603 J.708 E.01844
G1 X117.854 Y130.765 E.12216
G2 X118.369 Y131.945 I1.674 J-.027 E.04062
; WIPE_START
G1 F12000
M204 S10000
G1 X118.651 Y132.121 E-.12622
G1 X118.946 Y132.242 E-.12134
G1 X119.285 Y132.306 E-.13107
G1 X119.659 Y132.327 E-.14222
G1 X120.288 Y132.329 E-.23915
; WIPE_END
G1 E-.04 F1800
G1 X116.455 Y131.501 Z19.2 F30000
G1 Z18.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2900
G1 X114.827 Y131.497 E.05401
G1 X113.865 Y132.459 E.04511
G2 X113.928 Y134.671 I27.83 J.315 E.07344
G1 X119.315 Y134.685 E.17868
G1 X120.929 Y133.071 E.07575
G1 X119.715 Y133.067 E.04027
G1 X121.339 Y134.691 E.07615
G1 X126.97 Y134.706 E.18681
G1 X128.585 Y133.091 E.07575
G1 X127.412 Y133.088 E.03892
G1 X129.035 Y134.711 E.07615
G1 X134.626 Y134.726 E.18546
G1 X136.241 Y133.111 E.07575
G1 X135.108 Y133.108 E.03756
G1 X136.732 Y134.732 E.07615
G1 X142.029 Y134.746 E.17574
G2 X142.1 Y132.424 I-26.542 J-1.972 E.07706
G1 X141.25 Y131.574 E.03987
G1 X139.622 Y131.566 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 19
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X141.25 Y131.574 E-.61876
G1 X141.513 Y131.837 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 95/118
; update layer progress
M73 L95
M991 S0 P94 ;notify layer change
G17
G3 Z19.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.107 Y132.29
G1 Z19
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2937
G1 X118.146 Y132.314 E.00152
G2 X118.84 Y132.674 I1.241 J-1.546 E.02612
G2 X119.647 Y132.772 I.775 J-2.999 E.02705
G1 X136.321 Y132.816 E.55309
G2 X137.499 Y132.586 I.024 J-3 E.04011
G2 X138.423 Y131.427 I-.799 J-1.586 E.0507
G1 X138.463 Y131.265 E.00555
G1 X141.853 Y131.274 E.11246
G3 X142.345 Y131.388 I.091 J.727 E.01711
G3 X142.447 Y131.725 I-.656 J.381 E.01181
G1 X142.452 Y131.927 E.0067
G3 X142.311 Y135.148 I-40.545 J-.154 E.10696
G1 X113.645 Y135.072 E.95093
G3 X113.527 Y131.649 I42.765 J-3.178 E.11365
G3 X113.661 Y131.286 I.447 J-.042 E.01326
G3 X114.146 Y131.2 I.443 J1.094 E.01645
G1 X117.514 Y131.209 E.11172
G2 X117.863 Y132.037 I2.359 J-.51 E.02998
G1 X118.065 Y132.247 E.00965
M204 S250
G1 X118.411 Y132.032 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2937
M204 S5000
G1 X118.651 Y132.174 E.00856
G2 X119.285 Y132.359 I.84 J-1.701 E.02041
G1 X119.659 Y132.38 E.0115
G1 X136.311 Y132.424 E.51168
G2 X137.325 Y132.232 I.036 J-2.578 E.03191
G2 X138.047 Y131.316 I-.64 J-1.247 E.03697
G2 X138.125 Y130.872 I-2.642 J-.69 E.01388
G1 X141.863 Y130.882 E.11488
G3 X142.632 Y131.117 I.101 J1.045 E.02534
G3 X142.844 Y131.927 I-.933 J.677 E.02633
G1 X142.817 Y133.262 E.04105
G1 X142.681 Y135.529 E.06976
G1 X142.68 Y135.541 E.00038
G1 X113.273 Y135.463 E.9036
G1 X113.273 Y135.45 E.00038
G1 X113.149 Y133.183 E.06977
G1 X113.129 Y131.848 E.04105
G3 X113.345 Y131.039 I1.145 J-.127 E.02633
G3 X113.892 Y130.818 I.603 J.707 E.01845
G1 X117.854 Y130.818 E.12173
G2 X118.365 Y131.995 I1.673 J-.027 E.04045
; WIPE_START
G1 F12000
M204 S10000
G1 X118.651 Y132.174 E-.12838
G1 X118.946 Y132.295 E-.12135
G1 X119.285 Y132.359 E-.13106
G1 X119.659 Y132.38 E-.14223
G1 X120.282 Y132.382 E-.23698
; WIPE_END
G1 E-.04 F1800
G1 X127.909 Y132.082 Z19.4 F30000
G1 X139.676 Y131.619 Z19.4
G1 Z19
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2937
G1 X141.304 Y131.628 E.05401
G1 X142.089 Y132.413 E.03681
G3 X141.983 Y134.799 I-26.156 J.04 E.07926
G1 X136.785 Y134.785 E.17244
G1 X135.162 Y133.162 E.07615
G1 X136.188 Y133.164 E.03403
G1 X134.573 Y134.779 E.07575
G1 X129.089 Y134.764 E.18193
G1 X127.465 Y133.141 E.07615
G1 X128.532 Y133.144 E.03538
G1 X126.917 Y134.759 E.07575
G1 X121.392 Y134.744 E.18328
G1 X119.769 Y133.121 E.07615
G1 X120.876 Y133.124 E.03674
G1 X119.262 Y134.738 E.07575
G1 X113.974 Y134.724 E.17539
G3 X113.878 Y132.446 I28.592 J-2.346 E.07567
G1 X114.774 Y131.55 E.04201
G1 X116.402 Y131.554 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 19.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X114.774 Y131.55 E-.61877
G1 X114.511 Y131.813 E-.14123
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 96/118
; update layer progress
M73 L96
M991 S0 P95 ;notify layer change
G17
G3 Z19.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.176 Y132.4
G1 Z19.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2869
G1 X118.474 Y132.581 E.01157
G2 X118.84 Y132.727 I.913 J-1.76 E.0131
G2 X119.647 Y132.825 I.775 J-3 E.02705
G1 X136.321 Y132.87 E.55309
G2 X137.499 Y132.639 I.025 J-3 E.04011
G2 X138.423 Y131.481 I-.799 J-1.585 E.0507
G1 X138.463 Y131.318 E.00555
G1 X141.839 Y131.327 E.112
G3 X142.331 Y131.441 I.091 J.726 E.01711
G3 X142.432 Y131.779 I-.656 J.381 E.01181
G3 X142.427 Y132.496 I-8.049 J.298 E.02379
G1 X142.265 Y135.201 E.0899
G1 X113.69 Y135.125 E.94787
G1 X113.543 Y132.418 E.08992
G3 X113.589 Y131.458 I3.375 J-.317 E.032
G3 X113.946 Y131.262 I.322 J.163 E.01435
G1 X117.513 Y131.262 E.11833
G2 X117.863 Y132.09 I2.359 J-.509 E.02998
G2 X118.134 Y132.358 I1.524 J-1.269 E.01263
M204 S250
G1 X118.406 Y132.082 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2869
M204 S5000
G1 X118.65 Y132.227 E.00873
G2 X119.285 Y132.412 I.84 J-1.701 E.02041
G1 X119.659 Y132.433 E.0115
G1 X136.311 Y132.478 E.51168
G2 X137.325 Y132.285 I.036 J-2.578 E.03191
G2 X138.047 Y131.37 I-.64 J-1.247 E.03696
G2 X138.124 Y130.925 I-2.627 J-.688 E.01388
G1 X141.849 Y130.935 E.11446
G3 X142.618 Y131.17 I.101 J1.044 E.02533
G3 X142.83 Y131.98 I-.933 J.677 E.02633
G1 X142.819 Y132.511 E.01633
G1 X142.635 Y135.582 E.09452
G1 X142.634 Y135.594 E.00038
M73 P88 R1
G1 X113.319 Y135.516 E.90077
G1 X113.318 Y135.504 E.00038
G1 X113.151 Y132.432 E.09452
G3 X113.177 Y131.476 I4.58 J-.355 E.02943
G3 X113.723 Y130.901 I.678 J.097 E.02601
G3 X114.14 Y130.861 I.376 J1.74 E.01288
G1 X117.854 Y130.871 E.11413
G2 X118.36 Y132.044 I1.673 J-.027 E.04027
; WIPE_START
G1 F12000
M204 S10000
G1 X118.65 Y132.227 E-.13048
G1 X118.946 Y132.348 E-.12134
G1 X119.285 Y132.412 E-.13107
G1 X119.659 Y132.433 E-.14222
G1 X120.277 Y132.435 E-.23489
; WIPE_END
G1 E-.04 F1800
G1 X116.349 Y131.608 Z19.6 F30000
G1 Z19.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2869
G1 X114.721 Y131.603 E.05401
G1 X113.892 Y132.432 E.03887
G1 X114.02 Y134.778 E.07793
G1 X119.209 Y134.791 E.17211
G1 X120.823 Y133.177 E.07575
G1 X119.822 Y133.174 E.0332
G1 X121.446 Y134.797 E.07615
G1 X126.864 Y134.812 E.17975
G1 X128.479 Y133.197 E.07575
G1 X127.519 Y133.195 E.03185
G1 X129.142 Y134.818 E.07615
G1 X134.52 Y134.832 E.17839
G1 X136.134 Y133.218 E.07575
G1 X135.215 Y133.215 E.0305
G1 X136.838 Y134.838 E.07615
G1 X141.937 Y134.852 E.16913
G2 X142.08 Y132.404 I-23.293 J-2.584 E.08139
G1 X141.357 Y131.681 E.03387
G1 X139.729 Y131.673 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 19.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X141.357 Y131.681 E-.61877
G1 X141.62 Y131.944 E-.14123
; WIPE_END
M73 P89 R1
G1 E-.04 F1800
; layer num/total_layer_count: 97/118
; update layer progress
M73 L97
M991 S0 P96 ;notify layer change
G17
G3 Z19.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.175 Y132.453
G1 Z19.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2904
G1 X118.474 Y132.634 E.0116
G2 X118.84 Y132.78 I.913 J-1.76 E.0131
G2 X119.647 Y132.879 I.775 J-2.999 E.02705
G1 X136.32 Y132.923 E.55309
G2 X137.499 Y132.692 I.025 J-3 E.04011
G2 X138.423 Y131.535 I-.799 J-1.585 E.05068
G1 X138.462 Y131.371 E.00557
G1 X141.822 Y131.38 E.11143
G3 X142.317 Y131.494 I.094 J.729 E.01721
G3 X142.413 Y132.01 I-.62 J.382 E.01782
G1 X142.219 Y135.254 E.1078
G1 X113.736 Y135.178 E.94482
G1 X113.559 Y131.934 E.1078
G3 X113.658 Y131.418 I.717 J-.13 E.01782
G3 X113.96 Y131.315 I.352 J.54 E.0107
G3 X114.286 Y131.307 I.244 J3.336 E.01079
G1 X117.513 Y131.316 E.10707
G2 X117.863 Y132.143 I2.357 J-.509 E.02998
G2 X118.133 Y132.41 I1.524 J-1.268 E.0126
M204 S250
G1 X118.402 Y132.132 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2904
M204 S5000
G1 X118.65 Y132.281 E.0089
G2 X119.285 Y132.466 I.84 J-1.702 E.02041
G1 X119.659 Y132.487 E.0115
G1 X136.311 Y132.531 E.51168
G2 X137.324 Y132.339 I.036 J-2.577 E.03191
G2 X138.046 Y131.423 I-.639 J-1.247 E.03695
G2 X138.124 Y130.978 I-2.614 J-.686 E.0139
G1 X141.832 Y130.988 E.11392
G3 X142.604 Y131.223 I.103 J1.046 E.02544
G3 X142.805 Y132.025 I-.872 J.645 E.02606
G1 X142.586 Y135.635 E.11113
G1 X142.585 Y135.647 E.00038
G1 X113.368 Y135.569 E.89776
G1 X113.367 Y135.557 E.00038
G1 X113.167 Y131.946 E.11113
G3 X113.373 Y131.145 I1.074 J-.151 E.02606
G3 X114.146 Y130.915 I.664 J.815 E.02543
G1 X114.287 Y130.915 E.00434
G1 X117.854 Y130.924 E.1096
G2 X118.356 Y132.093 I1.672 J-.026 E.04011
; WIPE_START
G1 F12000
M204 S10000
G1 X118.65 Y132.281 E-.13248
G1 X118.946 Y132.401 E-.12136
G1 X119.285 Y132.466 E-.13105
G1 X119.659 Y132.487 E-.14222
G1 X120.271 Y132.488 E-.2329
; WIPE_END
G1 E-.04 F1800
G1 X127.898 Y132.191 Z19.8 F30000
G1 X139.783 Y131.727 Z19.8
G1 Z19.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2904
G1 X141.411 Y131.735 E.05401
G1 X142.036 Y132.36 E.02931
G1 X141.89 Y134.905 E.08456
G1 X136.892 Y134.892 E.1658
G1 X135.268 Y133.268 E.07615
G1 X136.081 Y133.271 E.02696
G1 X134.467 Y134.885 E.07575
G1 X129.195 Y134.871 E.17486
G1 X127.572 Y133.248 E.07615
G1 X128.426 Y133.25 E.02832
G1 X126.811 Y134.865 E.07575
G1 X121.499 Y134.851 E.17622
G1 X119.876 Y133.228 E.07615
G1 X120.77 Y133.23 E.02967
G1 X119.155 Y134.845 E.07575
G1 X114.066 Y134.831 E.16882
G1 X113.933 Y132.391 E.08106
G1 X114.667 Y131.657 E.03445
G1 X116.296 Y131.661 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 19.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X114.667 Y131.657 E-.61877
G1 X114.405 Y131.919 E-.14123
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 98/118
; update layer progress
M73 L98
M991 S0 P97 ;notify layer change
G17
G3 Z19.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.109 Y132.452
G1 Z19.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2831
G1 X118.145 Y132.474 E.00141
G2 X118.84 Y132.834 I1.241 J-1.546 E.02612
G2 X119.647 Y132.932 I.775 J-2.999 E.02705
G1 X136.32 Y132.976 E.55309
G2 X137.499 Y132.746 I.024 J-3 E.04011
G2 X138.423 Y131.588 I-.799 J-1.585 E.05067
G1 X138.462 Y131.425 E.00558
G1 X141.777 Y131.434 E.10995
G3 X142.287 Y131.546 I.097 J.773 E.01765
G3 X142.37 Y131.863 I-.604 J.328 E.011
G1 X142.203 Y134.803 E.09765
G1 X142.148 Y135.307 E.01684
G1 X113.807 Y135.232 E.94012
G1 X113.755 Y134.727 E.01683
G1 X113.605 Y131.987 E.09103
G3 X113.688 Y131.47 I.771 J-.141 E.01772
G3 X113.999 Y131.369 I.359 J.579 E.01094
G3 X114.29 Y131.361 I.231 J3.036 E.00964
G1 X117.513 Y131.369 E.10693
G2 X117.863 Y132.197 I2.354 J-.507 E.02998
G1 X118.067 Y132.409 E.00976
M204 S250
G1 X118.397 Y132.183 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2831
M204 S5000
G1 X118.65 Y132.334 E.00905
G2 X119.285 Y132.519 I.84 J-1.702 E.02041
G1 X119.658 Y132.54 E.0115
G1 X136.311 Y132.584 E.51168
G2 X137.324 Y132.392 I.036 J-2.578 E.03191
G2 X138.046 Y131.477 I-.639 J-1.247 E.03694
G2 X138.124 Y131.032 I-2.599 J-.684 E.01391
G1 X141.787 Y131.042 E.11254
G3 X142.574 Y131.276 I.103 J1.097 E.02587
G3 X142.762 Y131.847 I-.768 J.569 E.01879
G1 X142.594 Y134.836 E.09198
G1 X142.501 Y135.688 E.02635
G1 X142.499 Y135.7 E.00038
G1 X113.453 Y135.623 E.89251
G1 X113.452 Y135.611 E.00038
G1 X113.364 Y134.758 E.02635
G1 X113.213 Y131.999 E.08488
G3 X113.402 Y131.198 I1.094 J-.165 E.02592
G3 X113.96 Y130.978 I.61 J.73 E.01875
G3 X114.291 Y130.969 I.265 J3.455 E.01017
G1 X117.853 Y130.978 E.10947
G2 X118.353 Y132.143 I1.671 J-.026 E.03996
; WIPE_START
G1 F12000
M204 S10000
G1 X118.65 Y132.334 E-.13435
G1 X118.946 Y132.455 E-.12134
G1 X119.285 Y132.519 E-.13106
G1 X119.658 Y132.54 E-.14223
G1 X120.266 Y132.541 E-.23101
; WIPE_END
G1 E-.04 F1800
G1 X116.243 Y131.714 Z20 F30000
G1 Z19.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2831
G1 X114.614 Y131.71 E.05401
G1 X113.974 Y132.35 E.03004
G2 X114.121 Y134.884 I26.101 J-.246 E.08424
G1 X119.102 Y134.898 E.16524
G1 X120.717 Y133.283 E.07575
G1 X119.929 Y133.281 E.02614
G1 X121.552 Y134.904 E.07615
G1 X126.758 Y134.918 E.17268
G1 X128.373 Y133.303 E.07575
G1 X127.625 Y133.301 E.02478
G1 X129.249 Y134.925 E.07615
G1 X134.414 Y134.938 E.17133
G1 X136.028 Y133.324 E.07575
G1 X135.322 Y133.322 E.02343
G1 X136.945 Y134.945 E.07615
G1 X141.836 Y134.958 E.16223
G2 X141.995 Y132.319 I-25.375 J-2.857 E.08774
G1 X141.465 Y131.789 E.02487
G1 X139.837 Y131.78 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 19.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X141.465 Y131.789 E-.61877
G1 X141.728 Y132.052 E-.14123
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 99/118
; update layer progress
M73 L99
M991 S0 P98 ;notify layer change
G17
G3 Z20 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.109 Y132.506
G1 Z19.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2863
G1 X118.145 Y132.527 E.00138
G2 X118.84 Y132.887 I1.241 J-1.545 E.02612
G2 X119.647 Y132.985 I.775 J-3.001 E.02705
G1 X136.32 Y133.029 E.55309
G2 X137.499 Y132.799 I.025 J-3 E.04011
G2 X138.422 Y131.642 I-.799 J-1.585 E.05066
G1 X138.462 Y131.478 E.0056
G1 X141.732 Y131.487 E.10845
G3 X142.24 Y131.599 I.097 J.772 E.01762
G3 X142.324 Y131.917 I-.604 J.328 E.011
G1 X142.205 Y134.051 E.07093
G1 X142.062 Y135.36 E.04367
G1 X113.892 Y135.285 E.93445
G1 X113.757 Y133.976 E.04367
G1 X113.651 Y132.04 E.0643
G3 X113.734 Y131.523 I.77 J-.141 E.01772
G3 X114.042 Y131.423 I.357 J.575 E.01083
G1 X117.513 Y131.422 E.11515
G2 X117.863 Y132.25 I2.354 J-.507 E.02998
G1 X118.067 Y132.463 E.00979
M204 S250
G1 X118.393 Y132.234 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2863
M204 S5000
G1 X118.65 Y132.387 E.0092
G2 X119.285 Y132.572 I.84 J-1.701 E.02041
G1 X119.658 Y132.593 E.0115
G1 X136.311 Y132.637 E.51168
G2 X137.324 Y132.445 I.036 J-2.577 E.03191
G2 X138.046 Y131.531 I-.639 J-1.247 E.03693
G2 X138.124 Y131.085 I-2.591 J-.683 E.01392
G1 X141.742 Y131.095 E.11116
M73 P90 R1
G3 X142.528 Y131.329 I.102 J1.095 E.02584
G3 X142.716 Y131.9 I-.767 J.569 E.01879
G1 X142.596 Y134.084 E.06723
G1 X142.415 Y135.741 E.0512
G1 X142.414 Y135.753 E.00038
G1 X113.539 Y135.676 E.88726
G1 X113.537 Y135.664 E.00038
G1 X113.366 Y134.007 E.0512
G1 X113.259 Y132.053 E.06013
G3 X113.448 Y131.252 I1.093 J-.165 E.02592
G3 X114.005 Y131.032 I.609 J.728 E.01871
G1 X117.853 Y131.031 E.11826
G2 X118.349 Y132.193 I1.671 J-.026 E.03981
; WIPE_START
G1 F12000
M204 S10000
G1 X118.65 Y132.387 E-.13608
G1 X118.946 Y132.508 E-.12135
G1 X119.285 Y132.572 E-.13107
G1 X119.658 Y132.593 E-.14223
G1 X120.262 Y132.595 E-.22929
; WIPE_END
G1 E-.04 F1800
G1 X127.888 Y132.299 Z20.2 F30000
G1 X139.89 Y131.834 Z20.2
G1 Z19.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2863
G1 X141.519 Y131.843 E.05401
G1 X141.955 Y132.279 E.02045
G3 X141.75 Y135.011 I-25.871 J-.564 E.09094
G1 X136.999 Y134.998 E.15761
G1 X135.375 Y133.375 E.07615
G1 X135.975 Y133.377 E.0199
G1 X134.36 Y134.991 E.07575
G1 X129.302 Y134.978 E.1678
G1 X127.679 Y133.355 E.07615
G1 X128.319 Y133.356 E.02125
G1 X126.705 Y134.971 E.07575
G1 X121.606 Y134.958 E.16915
G1 X119.982 Y133.334 E.07615
G1 X120.664 Y133.336 E.0226
G1 X119.049 Y134.951 E.07575
G1 X114.206 Y134.938 E.16064
G3 X114.015 Y132.309 I26.89 J-3.284 E.08746
G1 X114.561 Y131.763 E.02564
G1 X116.189 Y131.767 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 20
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X114.561 Y131.763 E-.61877
G1 X114.298 Y132.026 E-.14123
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 100/118
; update layer progress
M73 L100
M991 S0 P99 ;notify layer change
G17
G3 Z20.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.172 Y132.611
G1 Z20
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2790
G1 X118.473 Y132.794 E.01169
G2 X118.839 Y132.94 I.913 J-1.76 E.0131
G2 X119.647 Y133.038 I.775 J-3 E.02705
G1 X136.32 Y133.083 E.55309
G2 X137.499 Y132.852 I.025 J-3 E.04011
G2 X138.422 Y131.695 I-.799 J-1.585 E.05065
G1 X138.462 Y131.531 E.0056
G1 X141.686 Y131.54 E.10696
G3 X142.194 Y131.652 I.097 J.771 E.01759
G3 X142.277 Y131.97 I-.605 J.328 E.011
G3 X142.207 Y133.3 I-14.502 J-.101 E.04422
G1 X141.977 Y135.413 E.07051
G1 X113.978 Y135.339 E.92878
G1 X113.759 Y133.225 E.0705
G3 X113.695 Y131.894 I14.45 J-1.356 E.04423
G3 X113.807 Y131.554 I.521 J-.017 E.01212
G3 X114.311 Y131.467 I.46 J1.173 E.01706
G1 X117.513 Y131.475 E.10623
G2 X117.863 Y132.303 I2.353 J-.507 E.02998
G2 X118.13 Y132.568 I1.524 J-1.269 E.01252
M204 S250
G1 X118.389 Y132.285 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2790
M204 S5000
G1 X118.65 Y132.44 E.00933
G2 X119.284 Y132.625 I.84 J-1.701 E.02041
G1 X119.658 Y132.646 E.0115
G1 X136.31 Y132.691 E.51168
G2 X137.324 Y132.499 I.036 J-2.578 E.03191
G2 X138.046 Y131.584 I-.639 J-1.246 E.03691
G2 X138.124 Y131.138 I-2.578 J-.682 E.01393
G1 X141.696 Y131.148 E.10977
G3 X142.482 Y131.382 I.102 J1.094 E.02581
G3 X142.67 Y131.953 I-.768 J.569 E.01879
G3 X142.598 Y133.333 I-15.041 J-.093 E.04249
G1 X142.33 Y135.794 E.07606
G1 X142.328 Y135.806 E.00038
G1 X113.624 Y135.73 E.88201
G1 X113.623 Y135.718 E.00038
G1 X113.368 Y133.256 E.07606
G3 X113.303 Y131.875 I14.988 J-1.395 E.04249
G3 X113.587 Y131.226 I.773 J-.048 E.0226
G3 X114.303 Y131.075 I.646 J1.29 E.02274
G1 X117.853 Y131.084 E.10907
G2 X118.346 Y132.243 I1.671 J-.026 E.03968
; WIPE_START
G1 F12000
M204 S10000
G1 X118.65 Y132.44 E-.13769
G1 X118.946 Y132.561 E-.12134
G1 X119.284 Y132.625 E-.13107
G1 X119.658 Y132.646 E-.14223
G1 X120.257 Y132.648 E-.22767
; WIPE_END
G1 E-.04 F1800
G1 X116.136 Y131.82 Z20.4 F30000
G1 Z20
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2790
G1 X114.508 Y131.816 E.05401
G1 X114.055 Y132.269 E.02124
G2 X114.292 Y134.991 I28.074 J-1.067 E.09069
G1 X118.996 Y135.004 E.15605
G1 X120.611 Y133.389 E.07575
G1 X120.036 Y133.388 E.01907
G1 X121.659 Y135.011 E.07615
G1 X126.652 Y135.024 E.16562
G1 X128.266 Y133.41 E.07575
G1 X127.732 Y133.408 E.01772
G1 X129.356 Y135.031 E.07615
G1 X134.307 Y135.045 E.16426
G1 X135.922 Y133.43 E.07575
G1 X135.429 Y133.429 E.01636
G1 X137.052 Y135.052 E.07615
G1 X141.664 Y135.064 E.153
G2 X141.914 Y132.238 I-25.28 J-3.661 E.09415
G1 X141.572 Y131.896 E.01605
G1 X139.944 Y131.887 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 20.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X141.572 Y131.896 E-.61877
G1 X141.835 Y132.159 E-.14123
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 101/118
; update layer progress
M73 L101
M991 S0 P100 ;notify layer change
G17
G3 Z20.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.171 Y132.664
G1 Z20.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2697
G1 X118.473 Y132.847 E.01171
G2 X118.839 Y132.993 I.913 J-1.76 E.0131
G2 X119.646 Y133.092 I.775 J-3 E.02705
G1 X136.32 Y133.136 E.55309
G2 X137.498 Y132.905 I.024 J-3.001 E.04011
G2 X138.422 Y131.749 I-.799 J-1.585 E.05064
G1 X138.462 Y131.584 E.00561
G1 X141.625 Y131.593 E.10495
G3 X142.121 Y131.682 I.031 J1.254 E.01681
G3 X142.231 Y132.023 I-.41 J.321 E.01212
G3 X142.209 Y132.549 I-5.732 J.02 E.01749
G1 X141.891 Y135.466 E.09734
G1 X114.063 Y135.392 E.92311
G1 X113.761 Y132.474 E.09733
G3 X113.78 Y131.712 I2.758 J-.312 E.02535
G3 X113.997 Y131.551 I.226 J.079 E.00951
G3 X114.359 Y131.521 I.31 J1.52 E.01208
G1 X117.513 Y131.529 E.10463
G2 X117.863 Y132.356 I2.352 J-.506 E.02998
G2 X118.13 Y132.621 I1.524 J-1.269 E.0125
M204 S250
G1 X118.388 Y132.337 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2697
M204 S5000
G2 X119.284 Y132.679 I1.102 J-1.545 E.02979
G1 X119.658 Y132.7 E.0115
G1 X136.31 Y132.744 E.51168
G2 X137.324 Y132.552 I.036 J-2.578 E.03191
G2 X138.045 Y131.638 I-.639 J-1.246 E.0369
G2 X138.124 Y131.191 I-2.567 J-.68 E.01394
G1 X141.635 Y131.201 E.10789
G3 X142.343 Y131.356 I.057 J1.433 E.0225
G3 X142.624 Y132.006 I-.492 J.598 E.0226
G3 X142.6 Y132.582 I-6.272 J.029 E.01772
G1 X142.244 Y135.847 E.10091
G1 X142.243 Y135.859 E.00038
G1 X113.709 Y135.783 E.87675
G1 X113.708 Y135.771 E.00038
G1 X113.37 Y132.504 E.10091
G3 X113.369 Y131.737 I3.653 J-.388 E.02363
G3 X113.907 Y131.168 I.636 J.063 E.02589
G3 X114.352 Y131.129 I.391 J1.866 E.01374
G1 X117.853 Y131.137 E.10759
G2 X118.345 Y132.296 I1.67 J-.026 E.03964
; WIPE_START
G1 F12000
M204 S10000
G1 X118.646 Y132.502 E-.13868
G1 X118.945 Y132.614 E-.12165
G1 X119.284 Y132.679 E-.13106
G1 X119.658 Y132.7 E-.14222
G1 X120.254 Y132.701 E-.22639
; WIPE_END
G1 E-.04 F1800
G1 X127.822 Y133.688 Z20.6 F30000
G1 X138.734 Y135.11 Z20.6
G1 Z20.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2697
G1 X137.105 Y135.105 E.05401
G1 X135.482 Y133.482 E.07615
G1 X135.869 Y133.483 E.01283
G1 X134.254 Y135.098 E.07575
G1 X129.409 Y135.085 E.16073
G1 X127.786 Y133.462 E.07615
G1 X128.213 Y133.463 E.01418
G1 X126.599 Y135.077 E.07575
G1 X121.712 Y135.064 E.16208
M73 P91 R1
G1 X120.089 Y133.441 E.07615
G1 X120.558 Y133.442 E.01554
G1 X118.943 Y135.057 E.07575
G1 X114.377 Y135.045 E.15146
G3 X114.1 Y132.224 I21.168 J-3.504 E.09409
G1 X114.455 Y131.869 E.01665
G1 X116.083 Y131.873 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 20.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X114.455 Y131.869 E-.61877
G1 X114.192 Y132.132 E-.14123
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 102/118
; update layer progress
M73 L102
M991 S0 P101 ;notify layer change
G17
G3 Z20.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.171 Y132.717
G1 Z20.4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2508
G1 X118.473 Y132.901 E.01173
G2 X118.839 Y133.047 I.913 J-1.76 E.0131
G2 X119.646 Y133.145 I.775 J-3 E.02705
G1 X136.32 Y133.189 E.55309
G2 X137.498 Y132.959 I.024 J-3 E.04011
G2 X138.458 Y131.638 I-.846 J-1.624 E.05614
G1 X141.542 Y131.646 E.1023
G3 X142.079 Y131.74 I.017 J1.493 E.01819
G3 X142.174 Y132.051 I-.243 J.244 E.01123
G1 X141.846 Y135.152 E.10343
G1 X141.782 Y135.519 E.01238
G1 X114.172 Y135.446 E.91589
G1 X114.11 Y135.078 E.01238
G1 X113.809 Y132.172 E.0969
G3 X113.851 Y131.712 I1.039 J-.139 E.01546
G3 X114.055 Y131.606 I.251 J.235 E.00779
G3 X114.464 Y131.574 I.348 J1.823 E.01363
G1 X117.513 Y131.582 E.10113
G2 X117.862 Y132.409 I2.35 J-.505 E.02998
G2 X118.129 Y132.674 I1.524 J-1.269 E.01248
M204 S250
G1 X118.388 Y132.39 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2508
M204 S5000
G2 X119.284 Y132.732 I1.102 J-1.545 E.0298
G1 X119.658 Y132.753 E.0115
G1 X136.31 Y132.797 E.51168
G2 X137.324 Y132.605 I.036 J-2.578 E.03191
G2 X138.046 Y131.689 I-.641 J-1.248 E.03698
G2 X138.124 Y131.245 I-1.355 J-.465 E.0139
G1 X141.551 Y131.254 E.10533
G3 X142.297 Y131.411 I.051 J1.61 E.02363
G3 X142.566 Y132.051 I-.453 J.567 E.02224
G1 X142.234 Y135.206 E.09749
G1 X142.114 Y135.9 E.02164
G1 X142.112 Y135.912 E.00038
G1 X113.839 Y135.837 E.86875
G1 X113.837 Y135.825 E.00038
G1 X113.721 Y135.13 E.02164
G1 X113.418 Y132.203 E.09043
G3 X113.512 Y131.51 I1.255 J-.184 E.02178
G3 X113.971 Y131.222 I.573 J.405 E.01708
G3 X114.458 Y131.182 I.424 J2.169 E.01503
G1 X117.853 Y131.191 E.10433
G2 X118.345 Y132.349 I1.669 J-.025 E.03964
; WIPE_START
G1 F12000
M204 S10000
G1 X118.646 Y132.555 E-.1387
G1 X118.945 Y132.668 E-.12164
G1 X119.284 Y132.732 E-.13106
G1 X119.658 Y132.753 E-.14222
G1 X120.254 Y132.754 E-.22637
; WIPE_END
G1 E-.04 F1800
G1 X117.262 Y135.106 Z20.8 F30000
G1 Z20.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2508
G1 X118.89 Y135.11 E.05401
G1 X120.505 Y133.495 E.07575
G1 X120.143 Y133.494 E.01201
G1 X121.766 Y135.118 E.07615
G1 X126.546 Y135.13 E.15855
G1 X128.16 Y133.516 E.07575
G1 X127.839 Y133.515 E.01065
G1 X129.462 Y135.138 E.07615
G1 X134.201 Y135.151 E.1572
G1 X135.816 Y133.536 E.07575
G1 X135.535 Y133.535 E.0093
G1 X137.159 Y135.159 E.07615
G1 X138.787 Y135.163 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 20.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X137.159 Y135.159 E-.61876
G1 X136.896 Y134.896 E-.14125
; WIPE_END
G1 E-.03999 F1800
; layer num/total_layer_count: 103/118
; update layer progress
M73 L103
M991 S0 P102 ;notify layer change
G17
G3 Z20.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.17 Y132.77
G1 Z20.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2525
G1 X118.473 Y132.954 E.01174
G2 X118.839 Y133.1 I.913 J-1.76 E.0131
G2 X119.646 Y133.198 I.775 J-3.001 E.02705
G1 X136.32 Y133.243 E.55309
G2 X137.498 Y133.012 I.025 J-3 E.04011
G2 X138.458 Y131.691 I-.847 J-1.625 E.05613
G1 X141.458 Y131.7 E.09953
G3 X141.996 Y131.795 I.018 J1.472 E.01824
G3 X142.08 Y131.97 I-.151 J.179 E.00664
G3 X142.076 Y132.3 I-1.358 J.151 E.01099
G1 X141.848 Y134.4 E.07007
G1 X141.646 Y135.572 E.03944
G1 X114.308 Y135.499 E.90684
G1 X114.112 Y134.327 E.03945
G1 X113.895 Y132.226 E.07006
G3 X113.939 Y131.751 I1.059 J-.141 E.01595
G3 X114.295 Y131.637 I.401 J.639 E.01255
G1 X117.513 Y131.635 E.10672
G2 X117.862 Y132.463 I2.349 J-.505 E.02997
G2 X118.129 Y132.727 I1.524 J-1.269 E.01247
M204 S250
G1 X118.386 Y132.441 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2525
M204 S5000
G1 X118.388 Y132.444 E.00009
G2 X119.284 Y132.785 I1.102 J-1.545 E.02979
G1 X119.658 Y132.806 E.0115
G1 X136.31 Y132.85 E.51168
G2 X137.324 Y132.658 I.036 J-2.577 E.03191
G2 X138.046 Y131.742 I-.641 J-1.248 E.03697
G2 X138.124 Y131.298 I-1.408 J-.476 E.01391
G1 X141.468 Y131.307 E.10274
G3 X142.212 Y131.465 I.051 J1.604 E.02361
G3 X142.481 Y132.104 I-.433 J.558 E.02226
G1 X142.236 Y134.455 E.07264
G1 X141.978 Y135.953 E.04671
G1 X141.976 Y135.965 E.00038
G1 X113.976 Y135.891 E.86036
G1 X113.974 Y135.878 E.00038
G1 X113.723 Y134.379 E.04671
G1 X113.504 Y132.257 E.06557
G3 X113.594 Y131.563 I1.289 J-.185 E.02176
G3 X114.056 Y131.276 I.58 J.42 E.01715
G3 X114.564 Y131.236 I.429 J2.202 E.01568
G1 X117.853 Y131.244 E.10106
G2 X118.186 Y132.219 I1.668 J-.025 E.03219
G1 X118.345 Y132.397 E.00734
; WIPE_START
G1 F12000
M204 S10000
G1 X118.388 Y132.444 E-.02396
G1 X118.645 Y132.609 E-.11625
G1 X118.945 Y132.721 E-.12165
G1 X119.284 Y132.785 E-.13106
G1 X119.658 Y132.806 E-.14223
G1 X120.249 Y132.808 E-.22485
; WIPE_END
G1 E-.04 F1800
G1 X127.819 Y133.788 Z21 F30000
G1 X138.84 Y135.216 Z21
G1 Z20.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2525
G1 X137.212 Y135.212 E.05401
G1 X135.589 Y133.589 E.07615
G1 X135.763 Y133.589 E.00576
G1 X134.148 Y135.204 E.07575
G1 X129.516 Y135.192 E.15366
G1 X127.892 Y133.568 E.07615
G1 X128.107 Y133.569 E.00712
G1 X126.492 Y135.184 E.07575
G1 X121.819 Y135.171 E.15502
G1 X120.196 Y133.548 E.07615
G1 X120.451 Y133.549 E.00847
G1 X118.837 Y135.163 E.07575
G1 X117.208 Y135.159 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 20.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F16200
G1 X118.837 Y135.163 E-.61876
G1 X119.1 Y134.9 E-.14125
; WIPE_END
G1 E-.03999 F1800
; layer num/total_layer_count: 104/118
; update layer progress
M73 L104
M991 S0 P103 ;notify layer change
G17
G3 Z21 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.17 Y132.823
G1 Z20.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2463
G1 X118.473 Y133.007 E.01175
G2 X118.839 Y133.153 I.913 J-1.759 E.0131
G2 X119.646 Y133.251 I.775 J-2.999 E.02705
G1 X136.319 Y133.296 E.55309
G2 X137.498 Y133.065 I.025 J-2.999 E.04011
G2 X138.458 Y131.744 I-.848 J-1.625 E.05613
G1 X141.368 Y131.753 E.09653
G3 X141.911 Y131.848 I.023 J1.47 E.0184
G3 X141.994 Y132.023 I-.152 J.18 E.00664
G3 X141.991 Y132.354 I-1.357 J.151 E.01099
G1 X141.85 Y133.649 E.04323
G1 X141.509 Y135.625 E.06651
G1 X114.444 Y135.553 E.89779
M73 P92 R1
G1 X114.114 Y133.575 E.06651
G1 X113.98 Y132.279 E.04323
G3 X114.024 Y131.805 I1.058 J-.14 E.01595
G3 X114.379 Y131.691 I.4 J.636 E.0125
G1 X117.513 Y131.689 E.10394
G2 X117.862 Y132.516 I2.347 J-.504 E.02997
G2 X118.128 Y132.78 I1.523 J-1.268 E.01246
M204 S250
G1 X118.38 Y132.489 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2463
M204 S5000
G1 X118.388 Y132.497 E.00035
G2 X119.284 Y132.838 I1.102 J-1.545 E.0298
G1 X119.658 Y132.859 E.0115
G1 X136.31 Y132.904 E.51168
G2 X137.323 Y132.711 I.036 J-2.577 E.03191
G2 X138.046 Y131.796 I-.641 J-1.248 E.03696
G2 X138.123 Y131.351 I-1.359 J-.467 E.01393
G1 X141.377 Y131.361 E.09998
G3 X142.127 Y131.518 I.055 J1.606 E.02376
G3 X142.395 Y132.157 I-.434 J.558 E.02226
G1 X142.238 Y133.704 E.04778
G1 X141.841 Y136.006 E.07178
G1 X141.839 Y136.018 E.00038
G1 X114.112 Y135.944 E.85197
G1 X114.11 Y135.932 E.00038
G1 X113.725 Y133.628 E.07178
G1 X113.589 Y132.31 E.04071
G3 X113.679 Y131.616 I1.288 J-.185 E.02176
G3 X114.141 Y131.33 I.58 J.42 E.01715
G3 X114.67 Y131.29 I.435 J2.242 E.01634
G1 X117.853 Y131.297 E.09779
G2 X118.185 Y132.273 I1.668 J-.025 E.03219
G1 X118.34 Y132.444 E.00709
; WIPE_START
G1 F12000
M204 S10000
G1 X118.388 Y132.497 E-.02708
G1 X118.645 Y132.662 E-.11624
G1 X118.945 Y132.774 E-.12168
G1 X119.284 Y132.838 E-.13105
G1 X119.658 Y132.859 E-.14222
G1 X120.241 Y132.861 E-.22173
; WIPE_END
G1 E-.04 F1800
G1 X117.155 Y135.212 Z21.2 F30000
G1 Z20.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2463
G1 X118.784 Y135.216 E.05401
G1 X120.398 Y133.602 E.07575
G1 X120.249 Y133.601 E.00494
G1 X121.873 Y135.225 E.07615
G1 X126.439 Y135.237 E.15148
G1 X128.054 Y133.622 E.07575
G1 X127.946 Y133.622 E.00359
G1 X129.569 Y135.245 E.07615
G1 X134.095 Y135.257 E.15013
G1 X135.71 Y133.642 E.07575
G1 X135.642 Y133.642 E.00223
G1 X137.266 Y135.265 E.07615
G1 X138.894 Y135.27 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 21
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X137.266 Y135.265 E-.61876
G1 X137.003 Y135.003 E-.14125
; WIPE_END
G1 E-.03999 F1800
; layer num/total_layer_count: 105/118
; update layer progress
M73 L105
M991 S0 P104 ;notify layer change
G17
G3 Z21.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.169 Y132.876
G1 Z21
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2482
G1 X118.472 Y133.06 E.01176
G2 X118.839 Y133.206 I.913 J-1.759 E.0131
G2 X119.646 Y133.305 I.775 J-3 E.02705
G1 X136.319 Y133.349 E.55309
G2 X137.498 Y133.118 I.025 J-3 E.04011
G2 X138.457 Y131.797 I-.849 J-1.626 E.05612
G1 X141.235 Y131.806 E.09215
G3 X141.825 Y131.901 I.042 J1.617 E.01994
G3 X141.909 Y132.076 I-.152 J.18 E.00664
G3 X141.852 Y132.898 I-3.722 J.155 E.02738
G1 X141.372 Y135.678 E.09358
G1 X114.581 Y135.607 E.88873
G1 X114.116 Y132.824 E.09358
G3 X114.083 Y131.917 I2.901 J-.559 E.03025
G3 X114.307 Y131.768 I.251 J.135 E.00927
G3 X114.782 Y131.735 I.395 J2.272 E.01583
G1 X117.512 Y131.742 E.09057
G2 X117.862 Y132.569 I2.346 J-.503 E.02997
G2 X118.128 Y132.833 I1.523 J-1.268 E.01245
M204 S250
G1 X118.374 Y132.537 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2482
M204 S5000
G1 X118.387 Y132.55 E.00058
G2 X119.284 Y132.892 I1.102 J-1.545 E.0298
G1 X119.657 Y132.913 E.0115
G1 X136.31 Y132.957 E.51168
G2 X137.323 Y132.765 I.036 J-2.578 E.03191
G2 X138.045 Y131.849 I-.641 J-1.248 E.03694
G2 X138.124 Y131.404 I-1.403 J-.476 E.01394
G1 X141.244 Y131.414 E.09588
G3 X142.041 Y131.571 I.069 J1.753 E.0252
G3 X142.31 Y132.21 I-.434 J.558 E.02225
G3 X142.24 Y132.953 I-7.632 J-.341 E.02294
G1 X141.74 Y135.855 E.09052
G1 X141.687 Y136.059 E.00645
G1 X141.684 Y136.071 E.00039
G1 X114.267 Y135.998 E.84243
G1 X114.264 Y135.986 E.00039
G1 X114.212 Y135.782 E.00645
G1 X113.727 Y132.877 E.09051
G3 X113.674 Y131.944 I3.992 J-.695 E.02876
G3 X114.225 Y131.384 I.627 J.064 E.02608
G3 X114.777 Y131.343 I.47 J2.639 E.01703
G1 X117.852 Y131.351 E.09451
G2 X118.185 Y132.326 I1.667 J-.024 E.03219
G1 X118.334 Y132.492 E.00686
; WIPE_START
G1 F12000
M204 S10000
G1 X118.387 Y132.55 E-.02993
G1 X118.645 Y132.715 E-.11625
G1 X118.945 Y132.827 E-.12166
G1 X119.284 Y132.892 E-.13106
G1 X119.657 Y132.913 E-.14222
G1 X120.233 Y132.914 E-.21889
; WIPE_END
G1 E-.04 F1800
G1 X127.803 Y133.889 Z21.4 F30000
G1 X138.947 Y135.323 Z21.4
G1 Z21
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2482
G1 X137.319 Y135.319 E.05401
G1 X135.696 Y133.696 E.07615
G1 X134.042 Y135.31 E.07667
G1 X129.622 Y135.298 E.1466
G1 X128.001 Y133.675 E.07611
G1 X126.386 Y135.29 E.07575
G1 X121.926 Y135.278 E.14795
G1 X120.303 Y133.655 E.07615
G1 X120.345 Y133.655 E.00141
G1 X118.731 Y135.269 E.07575
G1 X117.102 Y135.265 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 21.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F16200
G1 X118.731 Y135.269 E-.61876
G1 X118.993 Y135.007 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 106/118
; update layer progress
M73 L106
M991 S0 P105 ;notify layer change
G17
G3 Z21.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.169 Y132.929
G1 Z21.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F2709
G1 X118.472 Y133.114 E.01177
G2 X118.839 Y133.26 I.913 J-1.76 E.0131
G2 X119.646 Y133.358 I.775 J-3.001 E.02705
G1 X136.319 Y133.402 E.55309
G2 X137.498 Y133.172 I.024 J-3.001 E.04011
G2 X138.457 Y131.851 I-.85 J-1.627 E.05612
G1 X141.102 Y131.859 E.08773
G3 X141.774 Y131.976 I.026 J1.83 E.02276
G3 X141.806 Y132.424 I-.763 J.28 E.01509
G1 X141.358 Y135.022 E.08743
G1 X141.173 Y135.731 E.0243
G1 X114.779 Y135.66 E.87555
G1 X114.598 Y134.95 E.02431
G1 X114.164 Y132.35 E.08744
G3 X114.199 Y131.903 I.796 J-.164 E.01508
G3 X114.89 Y131.789 I.639 J1.722 E.02336
G1 X117.512 Y131.795 E.087
G2 X117.862 Y132.622 I2.346 J-.503 E.02997
G2 X118.128 Y132.886 I1.524 J-1.269 E.01245
M204 S250
G1 X118.369 Y132.585 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2709
M204 S5000
G1 X118.387 Y132.603 E.00079
G2 X119.284 Y132.945 I1.102 J-1.545 E.02979
G1 X119.657 Y132.966 E.0115
G1 X136.31 Y133.01 E.51168
G2 X137.323 Y132.818 I.036 J-2.578 E.03191
G2 X138.045 Y131.903 I-.64 J-1.247 E.03693
G2 X138.123 Y131.458 I-1.345 J-.465 E.01395
G1 X141.11 Y131.467 E.09179
G3 X141.954 Y131.627 I.058 J1.987 E.02659
G3 X142.22 Y132.255 I-.402 J.541 E.02196
G1 X141.742 Y135.104 E.08878
G1 X141.48 Y136.111 E.03197
G1 X141.476 Y136.124 E.00039
G1 X114.474 Y136.052 E.82971
G1 X114.471 Y136.039 E.00039
G1 X114.214 Y135.031 E.03197
G1 X113.776 Y132.404 E.08183
G3 X113.921 Y131.63 I.866 J-.239 E.02506
G3 X114.585 Y131.407 I.709 J1.009 E.02184
G1 X117.852 Y131.404 E.10039
G2 X118.185 Y132.379 I1.667 J-.024 E.03219
G1 X118.329 Y132.54 E.00665
; WIPE_START
G1 F12000
M204 S10000
G1 X118.387 Y132.603 E-.03257
G1 X118.645 Y132.768 E-.11624
G1 X118.945 Y132.881 E-.12165
G1 X119.284 Y132.945 E-.13107
G1 X119.657 Y132.966 E-.14223
G1 X120.226 Y132.967 E-.21624
; WIPE_END
G1 E-.04 F1800
G1 X117.049 Y135.318 Z21.6 F30000
G1 Z21.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2709
G1 X118.677 Y135.323 E.05401
G1 X120.292 Y133.708 E.07575
G1 X120.356 Y133.708 E.00213
G1 X121.979 Y135.331 E.07615
G1 X126.333 Y135.343 E.14442
G1 X127.948 Y133.728 E.07575
G1 X128.053 Y133.729 E.00348
M73 P93 R1
G1 X129.676 Y135.352 E.07615
G1 X133.989 Y135.363 E.14306
G1 X135.603 Y133.749 E.07575
G1 X135.749 Y133.749 E.00483
G1 X137.372 Y135.372 E.07615
G1 X139.001 Y135.377 E.05401
G1 X140.825 Y132.202 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.391207
G1 F2709
G3 X141.295 Y132.372 I-.016 J.783 E.01444
; LINE_WIDTH: 0.64144
G1 X141.205 Y132.907 E.02648
G1 X141.196 Y132.966 F30000
; LINE_WIDTH: 0.616724
G1 F2709
G1 X141.156 Y133.025 E.0033
; LINE_WIDTH: 0.569853
G1 X141.117 Y133.083 E.00303
; LINE_WIDTH: 0.522981
G1 X141.077 Y133.142 E.00276
; LINE_WIDTH: 0.47611
G1 X141.038 Y133.201 E.00249
; LINE_WIDTH: 0.429238
G1 X140.998 Y133.259 E.00222
; LINE_WIDTH: 0.382234
G1 X140.959 Y133.318 E.00195
G1 X140.712 Y134.359 E.02959
; LINE_WIDTH: 0.421515
G1 X140.6 Y134.69 E.01078
; LINE_WIDTH: 0.464592
G3 X140.374 Y135.312 I-6.637 J-2.064 E.02273
G1 X140.851 Y135.313 E.0164
; LINE_WIDTH: 0.454308
G1 X140.955 Y134.895 E.01442
; LINE_WIDTH: 0.422373
G2 X141.067 Y134.435 I-5.967 J-1.696 E.01466
; LINE_WIDTH: 0.382225
G1 X141.268 Y133.384 E.02959
; LINE_WIDTH: 0.382366
G1 X141.257 Y133.324 E.00168
; LINE_WIDTH: 0.429238
G1 X141.247 Y133.264 E.00191
; LINE_WIDTH: 0.47611
G1 X141.237 Y133.205 E.00214
; LINE_WIDTH: 0.522981
G1 X141.226 Y133.145 E.00237
; LINE_WIDTH: 0.569853
G1 X141.216 Y133.085 E.0026
; LINE_WIDTH: 0.616724
G1 X141.206 Y133.025 E.00283
; WIPE_START
G1 F11502.183
G1 X141.216 Y133.085 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.584 Y132.998 Z21.6 F30000
G1 X114.746 Y132.782 Z21.6
G1 Z21.2
G1 E.8 F1800
; LINE_WIDTH: 0.618126
G1 F2709
G1 X114.731 Y132.691 E.00436
; LINE_WIDTH: 0.572418
G1 X114.715 Y132.599 E.00402
; LINE_WIDTH: 0.52671
G1 X114.699 Y132.507 E.00367
; LINE_WIDTH: 0.481002
G1 X114.684 Y132.415 E.00332
; LINE_WIDTH: 0.435294
G1 X114.668 Y132.323 E.00298
; LINE_WIDTH: 0.617385
G1 X114.704 Y132.3 E.00201
; LINE_WIDTH: 0.574755
G1 X114.74 Y132.276 E.00186
; LINE_WIDTH: 0.532125
G1 X114.775 Y132.252 E.00171
; LINE_WIDTH: 0.489495
G1 X114.811 Y132.228 E.00156
; LINE_WIDTH: 0.446865
G1 X114.847 Y132.205 E.00141
; LINE_WIDTH: 0.404235
G1 X114.883 Y132.181 E.00126
; LINE_WIDTH: 0.435294
G1 X114.934 Y132.172 E.00166
; LINE_WIDTH: 0.481002
G1 X114.985 Y132.163 E.00185
; LINE_WIDTH: 0.52671
G1 X115.036 Y132.154 E.00204
; LINE_WIDTH: 0.572418
G1 X115.087 Y132.145 E.00223
; LINE_WIDTH: 0.618126
G1 X115.138 Y132.136 E.00243
G1 X115.581 Y135.246 F30000
; LINE_WIDTH: 0.46282
G1 F2709
G1 X115.395 Y134.749 E.01815
; LINE_WIDTH: 0.43169
G1 X115.25 Y134.3 E.01494
; LINE_WIDTH: 0.382705
G1 X114.981 Y133.135 E.0331
; LINE_WIDTH: 0.381839
G1 X114.942 Y133.076 E.00195
; LINE_WIDTH: 0.428955
G1 X114.903 Y133.018 E.00222
; LINE_WIDTH: 0.476072
G1 X114.863 Y132.959 E.00249
; LINE_WIDTH: 0.523189
G1 X114.824 Y132.9 E.00277
; LINE_WIDTH: 0.570305
G1 X114.785 Y132.841 E.00304
; LINE_WIDTH: 0.617422
G1 X114.746 Y132.782 E.00331
G1 X114.734 Y132.852 E.00331
; LINE_WIDTH: 0.570305
G1 X114.722 Y132.922 E.00304
; LINE_WIDTH: 0.523189
G1 X114.709 Y132.991 E.00277
; LINE_WIDTH: 0.476072
G1 X114.697 Y133.061 E.00249
; LINE_WIDTH: 0.428955
G1 X114.685 Y133.13 E.00222
; LINE_WIDTH: 0.382657
G1 X114.672 Y133.2 E.00196
G1 X114.893 Y134.375 E.0331
; LINE_WIDTH: 0.43169
G1 X115 Y134.866 E.01592
; LINE_WIDTH: 0.466207
G1 X115.103 Y135.245 E.01354
G1 X115.521 Y135.246 E.0144
; CHANGE_LAYER
; Z_HEIGHT: 21.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F12000
G1 X115.103 Y135.245 E-.39171
G1 X115 Y134.866 E-.36829
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 107/118
; update layer progress
M73 L107
M991 S0 P106 ;notify layer change
G17
G3 Z21.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.11 Y132.934
G1 Z21.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2741
G1 X118.144 Y132.953 E.00127
G2 X118.838 Y133.313 I1.242 J-1.546 E.02612
G2 X119.646 Y133.411 I.775 J-3 E.02705
G1 X136.319 Y133.456 E.55309
G2 X137.498 Y133.225 I.025 J-3 E.04011
G2 X138.457 Y131.904 I-.851 J-1.627 E.05612
G1 X140.949 Y131.912 E.08266
G3 X141.615 Y132.019 I.034 J1.913 E.02248
G3 X141.689 Y132.164 I-.093 J.139 E.00566
G3 X141.669 Y132.477 I-1.149 J.084 E.01043
G1 X141.36 Y134.27 E.06037
G1 X140.966 Y135.783 E.05186
G1 X114.986 Y135.714 E.86182
G1 X114.6 Y134.199 E.05186
G1 X114.301 Y132.404 E.06037
G3 X114.317 Y131.977 I.866 J-.181 E.01433
G3 X114.752 Y131.852 I.492 J.893 E.01514
G1 X117.512 Y131.848 E.09156
G2 X117.862 Y132.676 I2.345 J-.503 E.02996
G1 X118.069 Y132.891 E.00991
M204 S250
G1 X118.365 Y132.633 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2741
M204 S5000
G1 X118.387 Y132.657 E.00099
G2 X119.283 Y132.998 I1.102 J-1.545 E.0298
G1 X119.657 Y133.019 E.0115
G1 X136.31 Y133.063 E.51168
G2 X137.323 Y132.871 I.036 J-2.577 E.03191
G2 X138.045 Y131.957 I-.64 J-1.247 E.03692
G2 X138.123 Y131.511 I-1.344 J-.465 E.01396
G1 X140.957 Y131.52 E.08709
G3 X141.818 Y131.681 I.071 J1.998 E.02713
G3 X142.084 Y132.305 I-.352 J.519 E.02202
G1 X141.744 Y134.353 E.0638
G1 X141.272 Y136.164 E.05749
G1 X141.269 Y136.176 E.00039
G1 X114.681 Y136.105 E.81699
G1 X114.678 Y136.093 E.00039
G1 X114.216 Y134.28 E.05749
G1 X113.912 Y132.458 E.05675
G3 X113.976 Y131.78 I1.104 J-.239 E.02126
G3 X114.488 Y131.491 I.623 J.507 E.0185
G3 X115.031 Y131.451 I.475 J2.696 E.01676
G1 X117.852 Y131.457 E.08669
G2 X118.185 Y132.432 I1.666 J-.024 E.03219
G1 X118.325 Y132.589 E.00645
; WIPE_START
G1 F12000
M204 S10000
G1 X118.387 Y132.657 E-.03508
G1 X118.645 Y132.822 E-.11625
G1 X118.945 Y132.934 E-.12164
G1 X119.283 Y132.998 E-.13107
G1 X119.657 Y133.019 E-.14222
G1 X120.22 Y133.021 E-.21374
; WIPE_END
G1 E-.04 F1800
G1 X115.139 Y132.221 Z21.8 F30000
G1 Z21.4
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.380762
G1 F2741
G1 X114.662 Y132.245 E.01317
G1 X114.695 Y132.547 E.00836
G1 X114.893 Y133.612 E.02982
; LINE_WIDTH: 0.418903
G1 X114.947 Y133.859 E.00775
; LINE_WIDTH: 0.444833
G1 X115.005 Y134.123 E.00885
; LINE_WIDTH: 0.47184
G1 X115.144 Y134.61 E.01769
; LINE_WIDTH: 0.512672
G3 X115.329 Y135.274 I-10.941 J3.401 E.02642
G1 X115.86 Y135.276 E.02034
G1 X115.735 Y134.952 E.0133
; LINE_WIDTH: 0.50234
G1 X115.566 Y134.475 E.01894
; LINE_WIDTH: 0.47184
G1 X115.398 Y133.997 E.01769
; LINE_WIDTH: 0.444028
G1 X115.323 Y133.768 E.00788
; LINE_WIDTH: 0.418903
G1 X115.249 Y133.539 E.00739
; LINE_WIDTH: 0.383722
G1 X115.011 Y132.482 E.03008
G3 X115.101 Y132.267 I.218 J-.035 E.00681
; WIPE_START
G1 F12000
G1 X115.03 Y132.352 E-.06357
G1 X115.011 Y132.482 E-.07525
G1 X115.249 Y133.539 E-.62118
; WIPE_END
G1 E-.04 F1800
G1 X122.857 Y134.143 Z21.8 F30000
G1 X139.054 Y135.43 Z21.8
G1 Z21.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2741
G1 X137.426 Y135.426 E.05401
G1 X135.802 Y133.802 E.07615
G1 X135.55 Y133.802 E.00837
G1 X133.936 Y135.416 E.07575
G1 X129.729 Y135.405 E.13953
G1 X128.106 Y133.782 E.07615
G1 X127.895 Y133.781 E.00701
G1 X126.28 Y135.396 E.07575
G1 X122.033 Y135.385 E.14088
G1 X120.41 Y133.761 E.07615
G1 X120.239 Y133.761 E.00566
G1 X118.624 Y135.376 E.07575
G1 X116.996 Y135.371 E.05401
G1 X140.626 Y135.342 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.51718
G1 F2741
G1 X140.672 Y135.164 E.0071
; LINE_WIDTH: 0.502018
G1 X140.814 Y134.679 E.01891
; LINE_WIDTH: 0.471693
G1 X140.956 Y134.194 E.01766
; LINE_WIDTH: 0.443673
G1 X141.012 Y133.938 E.00853
; LINE_WIDTH: 0.417958
G1 X141.068 Y133.683 E.00798
; LINE_WIDTH: 0.377264
G2 X141.314 Y132.314 I-19.812 J-4.272 E.0379
G1 X140.83 Y132.287 E.01322
G1 X140.964 Y132.479 E.00639
G1 X140.944 Y132.633 E.00421
G1 X140.714 Y133.608 E.02731
; LINE_WIDTH: 0.417958
G1 X140.639 Y133.837 E.00737
; LINE_WIDTH: 0.443673
G1 X140.563 Y134.066 E.00787
; LINE_WIDTH: 0.471693
G1 X140.393 Y134.542 E.01766
; LINE_WIDTH: 0.511389
G3 X140.095 Y135.34 I-13.458 J-4.559 E.03254
G1 X140.566 Y135.342 E.01797
; CHANGE_LAYER
; Z_HEIGHT: 21.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F12000
G1 X140.095 Y135.34 E-.27044
G1 X140.393 Y134.542 E-.48956
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 108/118
; update layer progress
M73 L108
M991 S0 P107 ;notify layer change
G17
G3 Z21.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.169 Y133.036
G1 Z21.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2656
G1 X118.472 Y133.22 E.01178
G2 X118.838 Y133.366 I.914 J-1.76 E.01311
G2 X119.646 Y133.464 I.775 J-3 E.02705
G1 X136.319 Y133.509 E.55309
G2 X137.497 Y133.278 I.025 J-2.999 E.04011
G2 X138.457 Y131.957 I-.851 J-1.627 E.05611
G1 X140.748 Y131.965 E.07599
G3 X141.478 Y132.072 I.088 J1.945 E.02462
G3 X141.552 Y132.217 I-.093 J.14 E.00566
G3 X141.533 Y132.53 I-1.15 J.084 E.01043
G1 X141.362 Y133.519 E.03331
G1 X140.759 Y135.836 E.07941
G1 X115.193 Y135.768 E.84809
G1 X114.602 Y133.448 E.07941
G3 X114.416 Y132.267 I10.802 J-2.312 E.03969
G3 X114.453 Y132.031 I.457 J-.048 E.00802
G3 X114.912 Y131.906 I.48 J.863 E.0159
G1 X117.512 Y131.902 E.08627
G2 X117.861 Y132.729 I2.343 J-.502 E.02996
G2 X118.127 Y132.993 I1.524 J-1.269 E.01244
M204 S250
G1 X118.36 Y132.682 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2656
M204 S5000
G1 X118.387 Y132.71 E.00119
G2 X119.283 Y133.052 I1.102 J-1.545 E.0298
G1 X119.657 Y133.072 E.0115
G1 X136.309 Y133.117 E.51168
G2 X137.323 Y132.925 I.036 J-2.577 E.03191
G2 X138.045 Y132.01 I-.64 J-1.247 E.03691
G2 X138.123 Y131.564 I-1.342 J-.465 E.01398
G1 X140.755 Y131.573 E.08089
G3 X141.538 Y131.667 I.073 J2.678 E.02432
G3 X141.947 Y132.358 I-.2 J.585 E.02685
G3 X141.746 Y133.602 I-11.599 J-1.244 E.03875
G1 X141.119 Y136.011 E.0765
G1 X141.038 Y136.217 E.00677
G1 X141.033 Y136.229 E.0004
G1 X114.917 Y136.159 E.80249
G1 X114.912 Y136.147 E.0004
G1 X114.832 Y135.941 E.00678
G1 X114.218 Y133.529 E.0765
G3 X114.023 Y132.284 I11.391 J-2.424 E.03875
G3 X114.436 Y131.595 I.609 J-.103 E.02685
G3 X115.279 Y131.505 I.712 J2.666 E.02614
G1 X117.852 Y131.51 E.07907
G2 X118.185 Y132.486 I1.665 J-.024 E.03219
G1 X118.32 Y132.637 E.00625
; WIPE_START
G1 F12000
M204 S10000
G1 X118.387 Y132.71 E-.03751
G1 X118.645 Y132.875 E-.11625
G1 X118.944 Y132.987 E-.12166
G1 X119.283 Y133.052 E-.13105
G1 X119.657 Y133.072 E-.14223
G1 X120.213 Y133.074 E-.2113
; WIPE_END
G1 E-.04 F1800
G1 X115.294 Y132.289 Z22 F30000
G1 Z21.6
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.404087
G1 F2656
G1 X114.812 Y132.313 E.0142
G1 X114.9 Y132.866 E.01647
; LINE_WIDTH: 0.417845
G1 X114.952 Y133.111 E.00765
; LINE_WIDTH: 0.444549
G1 X115.007 Y133.375 E.00882
; LINE_WIDTH: 0.479183
G1 X115.214 Y134.095 E.02666
; LINE_WIDTH: 0.524488
G1 X115.421 Y134.816 E.02943
; LINE_WIDTH: 0.574092
G1 X115.562 Y135.294 E.02158
G1 X116.249 Y135.296 E.02973
G1 X115.9 Y134.663 E.0313
; LINE_WIDTH: 0.524488
G1 X115.65 Y133.956 E.02943
; LINE_WIDTH: 0.479183
G1 X115.4 Y133.249 E.02666
; LINE_WIDTH: 0.441605
G1 X115.303 Y132.902 E.0117
; LINE_WIDTH: 0.407852
G1 X115.205 Y132.556 E.01071
G3 X115.266 Y132.343 I.35 J-.015 E.00671
G1 X116.943 Y135.424 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F2656
G1 X118.571 Y135.429 E.05401
G1 X120.186 Y133.814 E.07575
G1 X120.463 Y133.815 E.00919
G1 X122.086 Y135.438 E.07615
G1 X126.227 Y135.449 E.13735
G1 X127.841 Y133.834 E.07575
G1 X128.159 Y133.835 E.01055
G1 X129.783 Y135.459 E.07615
G1 X133.882 Y135.469 E.136
G1 X135.497 Y133.855 E.07575
G1 X135.856 Y133.856 E.0119
G1 X137.479 Y135.479 E.07615
G1 X139.093 Y135.458 E.05354
M73 P94 R1
G1 X140.392 Y135.36 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.565595
G1 F2656
G1 X140.54 Y134.87 E.02181
; LINE_WIDTH: 0.523515
G1 X140.749 Y134.157 E.0291
; LINE_WIDTH: 0.478985
G1 X140.958 Y133.444 E.0264
; LINE_WIDTH: 0.443568
G1 X141.014 Y133.183 E.0087
; LINE_WIDTH: 0.406081
G2 X141.158 Y132.386 I-7.774 J-1.818 E.02397
G1 X140.646 Y132.357 E.01519
G1 X140.771 Y132.562 E.00711
G1 X140.71 Y132.88 E.0096
; LINE_WIDTH: 0.432285
G1 X140.565 Y133.316 E.01458
; LINE_WIDTH: 0.478985
G1 X140.314 Y134.015 E.0264
; LINE_WIDTH: 0.523515
G1 X140.063 Y134.715 E.0291
; LINE_WIDTH: 0.574708
G1 X139.706 Y135.358 E.0319
G1 X140.332 Y135.36 E.02716
; CHANGE_LAYER
; Z_HEIGHT: 21.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F12000
G1 X139.706 Y135.358 E-.34951
G1 X140.063 Y134.715 E-.41049
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 109/118
; update layer progress
M73 L109
M991 S0 P108 ;notify layer change
G17
G3 Z22 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.168 Y133.089
G1 Z21.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3465
G1 X118.472 Y133.273 E.01178
G2 X118.838 Y133.419 I.913 J-1.76 E.0131
G2 X119.645 Y133.518 I.775 J-3 E.02705
G1 X136.319 Y133.562 E.55309
G2 X137.497 Y133.331 I.024 J-3 E.04011
G2 X138.457 Y132.011 I-.852 J-1.628 E.05611
G1 X140.546 Y132.017 E.06929
G3 X141.337 Y132.122 I-.017 J3.182 E.02656
G3 X141.416 Y132.27 I-.089 J.142 E.00583
G3 X141.364 Y132.768 I-2.244 J.018 E.01664
G1 X140.747 Y135.139 E.08125
G1 X140.452 Y135.888 E.02673
G1 X115.499 Y135.822 E.82774
G1 X115.209 Y135.071 E.02673
G1 X114.604 Y132.697 E.08125
G3 X114.57 Y132.127 I1.956 J-.403 E.019
G3 X114.694 Y132.028 I.151 J.06 E.00549
G3 X115.523 Y131.951 I.773 J3.833 E.02769
G1 X117.512 Y131.955 E.06597
G2 X117.861 Y132.782 I2.342 J-.501 E.02996
G2 X118.127 Y133.046 I1.524 J-1.269 E.01244
M204 S250
G1 X118.356 Y132.731 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3465
M204 S5000
G1 X118.387 Y132.763 E.00139
G2 X119.283 Y133.105 I1.102 J-1.545 E.02979
G1 X119.657 Y133.126 E.0115
G1 X136.309 Y133.17 E.51168
G2 X137.323 Y132.978 I.036 J-2.578 E.03191
G2 X138.044 Y132.064 I-.64 J-1.247 E.0369
G2 X138.123 Y131.617 I-1.344 J-.466 E.01399
G1 X140.553 Y131.625 E.07468
G3 X141.545 Y131.787 I.147 J2.226 E.03115
G3 X141.811 Y132.411 I-.353 J.519 E.02202
G3 X141.748 Y132.851 I-4.101 J-.365 E.01367
G1 X141.121 Y135.26 E.07649
G1 X140.724 Y136.269 E.03331
G1 X140.719 Y136.281 E.0004
G1 X115.23 Y136.213 E.7832
G1 X115.226 Y136.201 E.0004
G1 X114.834 Y135.19 E.03331
G1 X114.22 Y132.778 E.0765
G3 X114.164 Y132.153 I2.578 J-.547 E.01933
G3 X114.578 Y131.652 I.56 J.041 E.02128
G3 X115.524 Y131.559 I.885 J4.147 E.02928
G1 X117.852 Y131.564 E.07153
G2 X118.184 Y132.539 I1.665 J-.023 E.03219
G1 X118.316 Y132.686 E.00605
; WIPE_START
G1 F12000
M204 S10000
G1 X118.387 Y132.763 E-.03997
G1 X118.645 Y132.928 E-.11625
G1 X118.944 Y133.04 E-.12164
G1 X119.283 Y133.105 E-.13105
G1 X119.657 Y133.126 E-.14224
G1 X120.206 Y133.127 E-.20886
; WIPE_END
G1 E-.04 F1800
G1 X127.816 Y133.719 Z22.2 F30000
G1 X138.146 Y134.522 Z22.2
G1 Z21.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F3465
G1 X136.518 Y134.518 E.05401
G1 X135.909 Y133.909 E.02855
G1 X135.444 Y133.908 E.01543
G1 X134.839 Y134.513 E.02839
G1 X128.821 Y134.497 E.19961
G1 X128.213 Y133.889 E.02855
G1 X127.788 Y133.888 E.01408
G1 X127.183 Y134.493 E.02839
G1 X121.125 Y134.477 E.20096
G1 X120.516 Y133.868 E.02855
G1 X120.133 Y133.867 E.01273
G1 X119.528 Y134.472 E.02839
G1 X117.899 Y134.468 E.05401
; WIPE_START
G1 F16200
G1 X119.528 Y134.472 E-.61876
G1 X119.79 Y134.21 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X127.391 Y133.511 Z22.2 F30000
G1 X139.992 Y132.352 Z22.2
G1 Z21.8
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.38292
G1 F3465
G1 X140.202 Y132.371 E.00586
G1 X139.876 Y135.495 F30000
; LINE_WIDTH: 0.41999
G1 F3465
G1 X140.186 Y135.496 E.0095
G1 X140.374 Y135.017 E.0158
; LINE_WIDTH: 0.43828
G1 X140.426 Y134.745 E.00892
; LINE_WIDTH: 0.47486
G1 X140.477 Y134.473 E.00974
; LINE_WIDTH: 0.51144
G1 X140.529 Y134.201 E.01057
; LINE_WIDTH: 0.537735
G1 X140.542 Y134.119 E.00336
; LINE_WIDTH: 0.526155
G1 X140.725 Y133.494 E.02564
; LINE_WIDTH: 0.480359
G2 X140.977 Y132.467 I-4.355 J-1.613 E.03776
; LINE_WIDTH: 0.458888
G1 X140.697 Y132.434 E.00958
; LINE_WIDTH: 0.432383
G1 X140.416 Y132.4 E.00897
; LINE_WIDTH: 0.401025
G1 X140.262 Y132.376 E.00455
G1 X140.392 Y132.442 E.00424
; LINE_WIDTH: 0.432383
G1 X140.457 Y132.552 E.00407
; LINE_WIDTH: 0.462968
G1 X140.522 Y132.663 E.00439
G1 X140.505 Y132.738 E.00264
; LINE_WIDTH: 0.486985
G1 X140.285 Y133.351 E.02357
; LINE_WIDTH: 0.526155
G1 X140.065 Y133.964 E.02564
; LINE_WIDTH: 0.524782
G1 X139.904 Y134.195 E.01106
; LINE_WIDTH: 0.482865
G1 X139.743 Y134.426 E.0101
; LINE_WIDTH: 0.439687
G2 X139.446 Y134.867 I6.157 J4.464 E.0172
; LINE_WIDTH: 0.472293
G1 X139.358 Y134.917 E.00353
; LINE_WIDTH: 0.51948
G1 X139.271 Y134.967 E.00391
G1 X116.686 Y134.907 E.87704
; LINE_WIDTH: 0.49466
G1 X116.569 Y134.815 E.00548
; LINE_WIDTH: 0.44488
G1 X116.452 Y134.723 E.00488
; LINE_WIDTH: 0.438434
G1 X116.277 Y134.464 E.01008
; LINE_WIDTH: 0.47532
G1 X116.102 Y134.204 E.01102
; LINE_WIDTH: 0.512207
G1 X115.927 Y133.945 E.01196
; LINE_WIDTH: 0.53887
G1 X115.902 Y133.912 E.00167
; LINE_WIDTH: 0.527175
G1 X115.683 Y133.292 E.02596
; LINE_WIDTH: 0.48548
G1 X115.446 Y132.594 E.02658
; LINE_WIDTH: 0.45931
G1 X115.513 Y132.485 E.00432
; LINE_WIDTH: 0.427642
G3 X115.635 Y132.338 I.235 J.07 E.00616
; LINE_WIDTH: 0.43231
G1 X115.314 Y132.37 E.01023
; LINE_WIDTH: 0.465316
M73 P94 R0
G1 X114.994 Y132.403 E.01109
G1 X115.06 Y132.801 E.01386
; LINE_WIDTH: 0.487345
G1 X115.241 Y133.433 E.02382
; LINE_WIDTH: 0.527175
G1 X115.423 Y134.065 E.02596
; LINE_WIDTH: 0.525907
G1 X115.474 Y134.352 E.01147
; LINE_WIDTH: 0.48354
G1 X115.525 Y134.639 E.01046
; LINE_WIDTH: 0.427383
G1 X115.576 Y134.926 E.00913
G1 X115.768 Y135.431 E.01693
G1 X116.349 Y135.425 E.01819
; LINE_WIDTH: 0.455913
G1 X116.517 Y135.404 E.0057
; LINE_WIDTH: 0.519393
G1 X116.685 Y135.383 E.00657
G1 X139.269 Y135.443 E.87688
; LINE_WIDTH: 0.49466
G1 X139.543 Y135.467 E.01011
; LINE_WIDTH: 0.44488
G1 X139.817 Y135.49 E.009
G1 X139.878 Y135.042 F30000
; LINE_WIDTH: 0.55557
G1 F3465
G1 X139.931 Y134.935 E.00499
G1 X116 Y134.818 F30000
; LINE_WIDTH: 0.55547
G1 F3465
G1 X116.052 Y134.925 E.00499
G1 X115.979 Y132.288 F30000
; LINE_WIDTH: 0.38292
G1 F3465
G1 X115.768 Y132.307 E.00587
; CHANGE_LAYER
; Z_HEIGHT: 22
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F12000
G1 X115.979 Y132.288 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 110/118
; update layer progress
M73 L110
M991 S0 P109 ;notify layer change
G17
G3 Z22.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.168 Y133.142
G1 Z22
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F4354
G1 X118.472 Y133.327 E.01179
G2 X118.838 Y133.473 I.913 J-1.76 E.0131
G2 X119.645 Y133.571 I.775 J-3.001 E.02705
G1 X136.319 Y133.615 E.55309
G2 X137.497 Y133.385 I.025 J-3 E.04011
G2 X138.457 Y132.064 I-.853 J-1.629 E.05611
G3 X140.653 Y132.082 I.75 J43.592 E.07287
G3 X141.243 Y132.236 I-.035 J1.334 E.02041
G3 X141.217 Y132.588 I-.696 J.126 E.01182
G1 X140.749 Y134.387 E.06167
G1 X140.138 Y135.941 E.05537
G1 X115.813 Y135.876 E.80691
G1 X115.211 Y134.32 E.05537
G1 X114.752 Y132.518 E.06168
G3 X114.728 Y132.166 I.671 J-.222 E.01183
G3 X115.318 Y132.014 I.618 J1.181 E.02038
G3 X117.512 Y132.008 I1.232 J49.413 E.07279
G2 X117.861 Y132.835 I2.34 J-.501 E.02996
G2 X118.127 Y133.099 I1.524 J-1.268 E.01243
M204 S250
G1 X118.351 Y132.779 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4354
M204 S5000
G1 X118.387 Y132.816 E.00159
G2 X119.283 Y133.158 I1.102 J-1.545 E.0298
G1 X119.657 Y133.179 E.0115
G1 X136.309 Y133.223 E.51168
G2 X137.323 Y133.031 I.036 J-2.577 E.03191
G2 X138.044 Y132.117 I-.64 J-1.247 E.03689
G2 X138.122 Y131.671 I-1.341 J-.466 E.014
G3 X140.682 Y131.69 I.896 J50.735 E.07865
G3 X141.364 Y131.846 I-.106 J2.034 E.0216
G3 X141.644 Y132.45 I-.248 J.482 E.02205
G1 X141.6 Y132.675 E.00703
G1 X141.123 Y134.509 E.05823
G1 X140.41 Y136.321 E.05984
G1 X140.405 Y136.334 E.0004
G1 X115.544 Y136.268 E.76391
G1 X115.539 Y136.255 E.0004
G1 X114.836 Y134.439 E.05984
G1 X114.369 Y132.603 E.05823
G3 X114.35 Y132.059 I1.042 J-.309 E.0169
G3 X114.784 Y131.706 I.579 J.268 E.01781
G3 X115.775 Y131.613 I.824 J3.46 E.03068
G1 X117.852 Y131.617 E.06381
G2 X118.184 Y132.592 I1.664 J-.023 E.03219
G1 X118.311 Y132.734 E.00585
; WIPE_START
G1 F12000
M204 S10000
G1 X118.387 Y132.816 E-.04246
G1 X118.644 Y132.981 E-.11626
G1 X118.944 Y133.094 E-.12166
G1 X119.283 Y133.158 E-.13105
G1 X119.657 Y133.179 E-.14223
G1 X120.2 Y133.18 E-.20634
; WIPE_END
G1 E-.04 F1800
G1 X115.35 Y132.406 Z22.4 F30000
G1 Z22
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F4354
G1 X115.137 Y132.441 E.00662
G1 X115.585 Y134.2 E.05578
G1 X116.082 Y135.485 E.04233
G1 X139.872 Y135.548 E.73097
G1 X140.376 Y134.266 E.04233
G2 X140.829 Y132.512 I-51.55 J-14.244 E.05568
G1 X140.605 Y132.473 E.00698
G1 X138.755 Y132.458 E.05683
G1 X138.66 Y132.72 E.00854
G1 X138.405 Y133.145 E.01524
G1 X138.06 Y133.492 E.01505
G1 X137.653 Y133.745 E.01472
G3 X136.323 Y134.007 I-1.32 J-3.19 E.04193
G1 X119.639 Y133.963 E.51264
G3 X118.275 Y133.676 I.005 J-3.406 E.04314
G1 X117.837 Y133.376 E.01631
G1 X117.534 Y133.053 E.0136
G1 X117.29 Y132.621 E.01526
G1 X117.222 Y132.401 E.00706
G1 X115.41 Y132.406 E.05569
G1 X115.613 Y132.783 F30000
; LINE_WIDTH: 0.41999
G1 F4354
G1 X115.944 Y134.085 E.04129
G1 X116.341 Y135.108 E.03372
G1 X139.615 Y135.17 E.71514
G1 X140.017 Y134.149 E.03372
G1 X140.355 Y132.848 E.0413
G1 X139.019 Y132.838 E.04105
G1 X138.758 Y133.299 E.0163
G1 X138.399 Y133.692 E.01636
G1 X137.89 Y134.046 E.01903
G1 X137.376 Y134.249 E.01698
G3 X136.322 Y134.384 I-1.222 J-5.343 E.03271
G1 X119.638 Y134.34 E.51264
G3 X118.071 Y133.993 I-.044 J-3.513 E.04973
G1 X117.598 Y133.672 E.01758
G1 X117.208 Y133.242 E.01785
G1 X116.95 Y132.779 E.01628
G1 X115.673 Y132.782 E.03923
; WIPE_START
G1 F12000
G1 X116.95 Y132.779 E-.48521
G1 X117.208 Y133.242 E-.20131
G1 X117.338 Y133.385 E-.07347
; WIPE_END
G1 E-.04 F1800
G1 X124.96 Y133.78 Z22.4 F30000
G1 X137.914 Y134.452 Z22.4
G1 Z22
G1 E.8 F1800
; LINE_WIDTH: 0.41999
G1 F4354
G1 X137.351 Y134.645 E.01829
; LINE_WIDTH: 0.434708
G1 X137.14 Y134.7 E.00697
; LINE_WIDTH: 0.453295
G1 X136.929 Y134.755 E.0073
G1 X137.539 Y134.788 E.02046
; LINE_WIDTH: 0.41999
G1 X139.358 Y134.793 E.05589
G1 X139.657 Y134.032 E.02511
G1 X139.868 Y133.221 E.02574
G1 X139.243 Y133.216 E.01921
G1 X138.974 Y133.64 E.01543
G1 X138.463 Y134.13 E.02174
G1 X137.966 Y134.422 E.01773
G1 X139.061 Y134.233 F30000
; LINE_WIDTH: 0.65194
G1 F4354
G2 X139.069 Y134.351 I-.035 J.062 E.01515
G1 X119.029 Y134.707 F30000
; LINE_WIDTH: 0.444234
G1 F4354
G2 X119.637 Y134.729 I.819 J-14.674 E.01989
G1 X136.321 Y134.773 E.5456
G1 X136.858 Y134.758 E.01757
G1 X116.599 Y134.732 F30000
; LINE_WIDTH: 0.41999
G1 F4354
G1 X118.594 Y134.737 E.06128
; LINE_WIDTH: 0.435608
G1 X118.811 Y134.722 E.00698
; LINE_WIDTH: 0.455403
G1 X119.029 Y134.707 E.00733
G1 X118.452 Y134.552 E.02008
; LINE_WIDTH: 0.41999
G1 X117.868 Y134.311 E.01941
G1 X117.326 Y133.933 E.02029
G1 X116.881 Y133.431 E.02063
G1 X116.723 Y133.157 E.00972
G1 X116.098 Y133.158 E.01921
G1 X116.304 Y133.97 E.02574
G1 X116.578 Y134.676 E.02326
G1 X116.976 Y134.174 F30000
; LINE_WIDTH: 0.65192
G1 F4354
G2 X116.984 Y134.292 I-.035 J.062 E.01515
; CHANGE_LAYER
; Z_HEIGHT: 22.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F10837.439
G1 X116.976 Y134.306 E-.03821
G1 X116.899 Y134.306 E-.18045
G1 X116.861 Y134.24 E-.18044
G1 X116.899 Y134.174 E-.18044
G1 X116.976 Y134.174 E-.18045
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 111/118
; update layer progress
M73 L111
M991 S0 P110 ;notify layer change
G17
G3 Z22.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.168 Y133.195
G1 Z22.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F4200
G1 X118.472 Y133.38 E.01179
G2 X118.838 Y133.526 I.913 J-1.76 E.0131
G2 X119.645 Y133.624 I.775 J-2.999 E.02705
G1 X136.318 Y133.669 E.55309
G2 X137.497 Y133.438 I.025 J-2.999 E.04011
G2 X138.457 Y132.117 I-.854 J-1.629 E.0561
G3 X140.357 Y132.134 I.608 J38.257 E.06306
G3 X141.036 Y132.289 I.032 J1.424 E.02333
G3 X141.01 Y132.641 I-.694 J.126 E.01183
G1 X140.751 Y133.636 E.03412
G1 X140.026 Y135.479 E.06569
G1 X139.719 Y135.993 E.01986
G1 X116.232 Y135.931 E.7791
G1 X115.928 Y135.415 E.01986
G1 X115.213 Y133.569 E.06569
G1 X114.959 Y132.572 E.03413
G3 X114.935 Y132.22 I.667 J-.222 E.01183
G3 X115.614 Y132.068 I.639 J1.271 E.02332
G3 X116.473 Y132.06 I.608 J17.353 E.02848
G1 X117.512 Y132.062 E.03447
G2 X117.861 Y132.889 I2.338 J-.5 E.02996
G2 X118.126 Y133.152 I1.524 J-1.269 E.01243
M204 S250
G1 X118.346 Y132.827 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P95 R0
G1 F4200
M204 S5000
G1 X118.387 Y132.87 E.00181
G2 X119.283 Y133.211 I1.102 J-1.545 E.0298
G1 X119.657 Y133.232 E.0115
G1 X136.309 Y133.276 E.51168
G2 X137.322 Y133.084 I.036 J-2.577 E.03191
G2 X138.044 Y132.171 I-.64 J-1.247 E.03687
G2 X138.122 Y131.724 I-1.335 J-.465 E.01401
G3 X140.381 Y131.743 I.753 J45.419 E.06941
G3 X141.157 Y131.899 I-.013 J2.072 E.02446
G3 X141.436 Y132.503 I-.248 J.482 E.02205
G1 X141.125 Y133.758 E.03973
G1 X140.379 Y135.653 E.06257
G1 X139.948 Y136.373 E.0258
G1 X139.941 Y136.386 E.00044
G1 X116.008 Y136.322 E.73538
G1 X116.001 Y136.31 E.00044
G1 X115.574 Y135.587 E.0258
G1 X114.838 Y133.688 E.06257
G1 X114.576 Y132.656 E.03271
G3 X114.557 Y132.113 I1.04 J-.309 E.0169
G3 X114.99 Y131.76 I.577 J.267 E.01776
G3 X116.023 Y131.667 I.916 J4.374 E.03195
G1 X116.474 Y131.668 E.01385
G1 X117.852 Y131.67 E.04234
G2 X118.184 Y132.645 I1.663 J-.023 E.03219
G1 X118.306 Y132.782 E.00564
; WIPE_START
G1 F12000
M204 S10000
G1 X118.387 Y132.87 E-.04512
G1 X118.644 Y133.035 E-.11625
G1 X118.944 Y133.147 E-.12166
G1 X119.283 Y133.211 E-.13105
G1 X119.657 Y133.232 E-.14222
G1 X120.193 Y133.234 E-.2037
; WIPE_END
G1 E-.04 F1800
G1 X127.81 Y133.712 Z22.6 F30000
G1 X138.801 Y134.403 Z22.6
G1 Z22.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45828
G1 F4200
G2 X138.793 Y134.493 I-.026 J.043 E.00688
G1 X136.928 Y134.808 F30000
; LINE_WIDTH: 0.464143
G1 F4200
G1 X137.234 Y134.825 E.0105
; LINE_WIDTH: 0.427824
G1 X137.539 Y134.841 E.00959
G1 X139.044 Y134.845 E.04721
G3 X139.649 Y133.283 I322.617 J124.008 E.05253
G1 X139.248 Y133.279 E.01259
G1 X139.089 Y133.567 E.0103
G1 X138.635 Y134.043 E.02064
G1 X138.092 Y134.418 E.0207
G1 X137.506 Y134.656 E.01982
; LINE_WIDTH: 0.434708
G1 X137.246 Y134.724 E.00858
; LINE_WIDTH: 0.464143
G1 X136.987 Y134.793 E.00923
G1 X119.639 Y134.016 F30000
; LINE_WIDTH: 0.41999
G1 F4200
G3 X118.275 Y133.729 I.005 J-3.406 E.04314
G1 X117.87 Y133.464 E.01486
G1 X117.534 Y133.106 E.01508
G1 X117.289 Y132.674 E.01527
G1 X117.222 Y132.453 E.00709
G2 X115.64 Y132.46 I-.489 J65.889 E.04859
G1 X115.347 Y132.508 E.00913
G1 X115.587 Y133.449 E.02984
G1 X116.281 Y135.244 E.05913
G1 X116.456 Y135.539 E.01055
G1 X139.497 Y135.6 E.70796
G1 X139.689 Y135.265 E.01188
G1 X140.378 Y133.515 E.05779
G1 X140.624 Y132.567 E.03009
G1 X140.317 Y132.526 E.00954
G1 X138.755 Y132.512 E.04798
G1 X138.66 Y132.773 E.00853
G1 X138.405 Y133.198 E.01524
G1 X138.06 Y133.546 E.01506
G1 X137.653 Y133.798 E.01471
G3 X136.323 Y134.061 I-1.32 J-3.189 E.04193
G1 X119.699 Y134.016 E.5108
G1 X119.638 Y134.393 F30000
G1 F4200
G3 X118.071 Y134.047 I-.044 J-3.513 E.04973
G1 X117.598 Y133.725 E.01757
G1 X117.213 Y133.304 E.01754
G1 X116.949 Y132.83 E.01669
G2 X115.82 Y132.836 I-.234 J63.321 E.03469
G1 X115.946 Y133.334 E.0158
G1 X116.622 Y135.078 E.05748
G1 X116.672 Y135.163 E.003
G1 X139.284 Y135.223 E.69479
G2 X140.019 Y133.398 I-29.986 J-13.137 E.06045
G1 X140.148 Y132.902 E.01576
G1 X139.019 Y132.891 E.03469
G1 X138.758 Y133.352 E.01627
G1 X138.365 Y133.78 E.01786
G1 X137.89 Y134.099 E.01756
G1 X137.376 Y134.302 E.01699
G3 X136.322 Y134.438 I-1.222 J-5.341 E.03271
G1 X119.698 Y134.393 E.5108
G1 X119.029 Y134.761 F30000
; LINE_WIDTH: 0.466828
G1 F4200
G1 X118.74 Y134.683 E.01032
; LINE_WIDTH: 0.427688
G1 X118.452 Y134.605 E.00937
G1 X117.868 Y134.364 E.01981
G1 X117.428 Y134.078 E.01646
G1 X117.013 Y133.669 E.01825
G3 X116.716 Y133.215 I3.067 J-2.335 E.01704
G1 X116.315 Y133.216 E.01257
G3 X116.913 Y134.786 I-73.612 J28.958 E.05268
G1 X118.594 Y134.791 E.05269
; LINE_WIDTH: 0.435603
G1 X118.781 Y134.778 E.00602
; LINE_WIDTH: 0.466828
G1 X118.969 Y134.765 E.0065
G1 X119.029 Y134.761 F30000
; LINE_WIDTH: 0.444224
G1 F4200
G2 X119.637 Y134.782 I.815 J-14.541 E.01989
G1 X136.321 Y134.826 E.54559
G1 X136.858 Y134.811 E.01757
G1 X117.211 Y134.346 F30000
; LINE_WIDTH: 0.45828
G1 F4200
G2 X117.203 Y134.436 I-.026 J.043 E.00688
; CHANGE_LAYER
; Z_HEIGHT: 22.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X117.159 Y134.436 E-.16693
G1 X117.133 Y134.391 E-.19768
G1 X117.159 Y134.346 E-.19768
G1 X117.211 Y134.346 E-.1977
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 112/118
; update layer progress
M73 L112
M991 S0 P111 ;notify layer change
G17
G3 Z22.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.11 Y133.201
G1 Z22.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F4128
G1 X118.143 Y133.219 E.00126
G2 X118.838 Y133.579 I1.242 J-1.546 E.02612
G2 X119.645 Y133.677 I.775 J-3 E.02705
G1 X136.318 Y133.722 E.55309
G2 X137.497 Y133.491 I.024 J-3.001 E.04011
G2 X138.456 Y132.171 I-.855 J-1.63 E.0561
G3 X140.381 Y132.218 I.515 J18.171 E.06391
G3 X140.844 Y132.331 I-.209 J1.855 E.01585
G3 X140.753 Y132.885 I-1.898 J-.028 E.01869
G1 X140.028 Y134.728 E.06569
G1 X139.24 Y136.045 E.05091
G1 X116.711 Y135.985 E.74734
G1 X115.93 Y134.664 E.05091
G1 X115.215 Y132.817 E.06569
G3 X115.126 Y132.263 I1.813 J-.572 E.0187
G3 X115.922 Y132.123 I.883 J2.688 E.02691
G3 X117.512 Y132.115 I1.049 J50.651 E.05272
G2 X117.861 Y132.942 I2.338 J-.499 E.02995
G1 X118.068 Y133.158 E.00993
M204 S250
G1 X118.341 Y132.875 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4128
M204 S5000
G1 X118.386 Y132.923 E.00204
G2 X119.283 Y133.265 I1.102 J-1.545 E.02979
G1 X119.656 Y133.285 E.0115
G1 X136.309 Y133.33 E.51168
G2 X137.322 Y133.138 I.036 J-2.578 E.03191
G2 X138.043 Y132.225 I-.639 J-1.246 E.03686
G2 X138.122 Y131.777 I-1.334 J-.465 E.01402
G3 X140.435 Y131.829 I.588 J25.277 E.07112
G3 X141.073 Y132.033 I-.09 J1.381 E.02078
G3 X141.229 Y132.556 I-.433 J.414 E.01739
G3 X141.127 Y133.007 I-3.658 J-.595 E.01422
G1 X140.381 Y134.902 E.06257
G1 X139.535 Y136.316 E.05064
G1 X139.419 Y136.425 E.00489
G1 X139.406 Y136.438 E.00055
G1 X116.543 Y136.377 E.70252
G1 X116.53 Y136.364 E.00055
G1 X116.415 Y136.255 E.00489
G1 X115.576 Y134.836 E.05065
G1 X114.84 Y132.937 E.06257
G3 X114.735 Y132.307 I2.194 J-.69 E.01969
G3 X115.018 Y131.886 I.493 J.025 E.01638
G3 X115.903 Y131.731 I.992 J3.065 E.02767
G3 X117.851 Y131.723 I1.22 J62.077 E.05989
G2 X118.184 Y132.699 I1.663 J-.023 E.03219
G1 X118.301 Y132.83 E.0054
; WIPE_START
G1 F12000
M204 S10000
G1 X118.386 Y132.923 E-.04798
G1 X118.644 Y133.088 E-.11625
G1 X118.944 Y133.2 E-.12164
G1 X119.283 Y133.265 E-.13107
G1 X119.656 Y133.285 E-.14222
G1 X120.185 Y133.287 E-.20084
; WIPE_END
G1 E-.04 F1800
G1 X127.816 Y133.433 Z22.8 F30000
G1 X139.139 Y133.651 Z22.8
G1 Z22.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.54845
G1 F4128
G1 X139.245 Y133.432 E.01004
G1 X136.928 Y134.861 F30000
; LINE_WIDTH: 0.518001
G1 F4128
G3 X138.562 Y134.845 I1.057 J24.386 E.06327
G1 X138.95 Y134.198 E.02922
; LINE_WIDTH: 0.533496
G1 X139.139 Y133.651 E.02313
G3 X138.491 Y134.28 I-4.152 J-3.631 E.03615
G1 X137.932 Y134.607 E.0259
G1 X137.36 Y134.803 E.02414
; LINE_WIDTH: 0.502495
G1 X136.988 Y134.853 E.01407
G1 X119.638 Y134.069 F30000
; LINE_WIDTH: 0.41999
G1 F4128
G3 X118.274 Y133.782 I.004 J-3.404 E.04314
G1 X117.795 Y133.439 E.0181
G1 X117.534 Y133.159 E.01177
G1 X117.289 Y132.727 E.01527
G1 X117.222 Y132.508 E.00702
G1 X115.945 Y132.515 E.03926
G1 X115.56 Y132.565 E.01192
G2 X116.283 Y134.492 I50.901 J-18.007 E.06325
G1 X116.935 Y135.594 E.03931
G1 X139.018 Y135.652 E.67855
G1 X139.675 Y134.555 E.03931
G1 X140.378 Y132.769 E.05894
G1 X140.409 Y132.631 E.00435
G1 X140.004 Y132.579 E.01254
G1 X138.755 Y132.566 E.0384
G3 X138.06 Y133.599 I-2.211 J-.737 E.03873
G1 X137.653 Y133.851 E.01472
G3 X136.323 Y134.114 I-1.321 J-3.191 E.04193
G1 X119.698 Y134.07 E.5108
G1 X119.637 Y134.447 F30000
; LINE_WIDTH: 0.41999
G1 F4128
G3 X118.071 Y134.1 I-.044 J-3.512 E.04973
G1 X117.598 Y133.778 E.01757
G1 X117.213 Y133.357 E.01754
G1 X116.95 Y132.887 E.01655
G1 X116.068 Y132.891 E.02711
G1 X116.624 Y134.327 E.04731
G1 X117.15 Y135.217 E.03177
G1 X138.805 Y135.275 E.66537
G1 X139.336 Y134.388 E.03177
G1 X139.9 Y132.955 E.04731
G1 X139.018 Y132.946 E.02708
G1 X138.758 Y133.405 E.01624
G1 X138.365 Y133.834 E.01786
G1 X137.89 Y134.152 E.01757
G1 X137.376 Y134.355 E.01699
G3 X136.322 Y134.491 I-1.222 J-5.342 E.0327
G1 X119.697 Y134.447 E.5108
G1 X119.029 Y134.814 F30000
; LINE_WIDTH: 0.516895
G1 F4128
G1 X118.434 Y134.707 E.02336
G1 X117.84 Y134.461 E.02482
G1 X117.289 Y134.076 E.02596
; LINE_WIDTH: 0.532755
G1 X116.825 Y133.591 E.02677
G1 X117.007 Y134.13 E.02269
G2 X117.395 Y134.789 I120.108 J-70.244 E.03053
G1 X118.594 Y134.792 E.04784
; LINE_WIDTH: 0.50288
G1 X118.969 Y134.811 E.01408
G1 X119.029 Y134.814 F30000
; LINE_WIDTH: 0.444233
G1 F4128
G2 X119.636 Y134.835 I.815 J-14.559 E.01989
G1 X136.321 Y134.88 E.54561
G1 X136.857 Y134.864 E.01756
; WIPE_START
G1 F15000
G1 X136.321 Y134.88 E-.2041
G1 X134.858 Y134.876 E-.5559
; WIPE_END
G1 E-.04 F1800
G1 X127.253 Y134.223 Z22.8 F30000
G1 X116.694 Y133.318 Z22.8
G1 Z22.4
G1 E.8 F1800
; LINE_WIDTH: 0.54843
G1 F4128
G1 X116.799 Y133.537 E.01003
; CHANGE_LAYER
; Z_HEIGHT: 22.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F13056.122
G1 X116.694 Y133.318 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 113/118
; update layer progress
M73 L113
M991 S0 P112 ;notify layer change
G17
G3 Z22.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.168 Y133.302
G1 Z22.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F4295
G1 X118.471 Y133.486 E.01179
G2 X118.838 Y133.632 I.913 J-1.76 E.0131
G2 X119.645 Y133.731 I.775 J-2.999 E.02705
G1 X136.318 Y133.775 E.55309
G2 X137.497 Y133.544 I.024 J-3 E.04011
G2 X138.456 Y132.224 I-.855 J-1.63 E.05609
G3 X140.067 Y132.272 I.138 J22.519 E.05348
G3 X140.616 Y132.437 I-.115 J1.378 E.01913
G1 X140.541 Y132.68 E.00845
G1 X140.03 Y133.977 E.04624
G1 X139.446 Y134.953 E.03773
G1 X116.511 Y134.892 E.76082
G1 X115.932 Y133.913 E.03773
G1 X115.428 Y132.613 E.04624
G1 X115.354 Y132.369 E.00845
G3 X115.904 Y132.208 I.657 J1.217 E.01914
G3 X117.512 Y132.168 I1.369 J23.098 E.05337
G2 X117.861 Y132.995 I2.336 J-.499 E.02994
G2 X118.126 Y133.259 I1.524 J-1.269 E.01243
M204 S250
G1 X118.335 Y132.922 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F4295
M204 S5000
G1 X118.386 Y132.976 E.00229
G2 X119.283 Y133.318 I1.102 J-1.545 E.0298
G1 X119.656 Y133.339 E.0115
G1 X136.309 Y133.383 E.51168
G2 X137.322 Y133.191 I.036 J-2.578 E.03191
G2 X138.043 Y132.278 I-.639 J-1.246 E.03685
G2 X138.122 Y131.831 I-1.331 J-.465 E.01403
G3 X140.116 Y131.882 I.324 J25.984 E.0613
G3 X140.815 Y132.098 I-.167 J1.779 E.02264
G3 X140.979 Y132.59 I-.269 J.363 E.01696
G1 X140.911 Y132.81 E.00708
G1 X140.383 Y134.151 E.04427
G1 X139.537 Y135.565 E.05064
G1 X138.844 Y136.218 E.02926
G1 X138.37 Y136.476 E.01658
G1 X138.347 Y136.488 E.00079
G1 X117.601 Y136.433 E.63748
G1 X117.579 Y136.42 E.00079
G1 X117.106 Y136.161 E.01658
G1 X116.417 Y135.503 E.02926
G1 X115.578 Y134.085 E.05065
G1 X115.057 Y132.741 E.04427
G3 X114.999 Y132.226 I.744 J-.345 E.0162
G3 X115.32 Y131.944 I.503 J.248 E.01347
G3 X116.359 Y131.786 I1 J3.076 E.03245
G3 X117.851 Y131.777 I1.085 J56.805 E.04585
G2 X118.184 Y132.752 I1.662 J-.022 E.03219
G1 X118.295 Y132.877 E.00515
; WIPE_START
G1 F12000
M204 S10000
G1 X118.386 Y132.976 E-.05111
G1 X118.644 Y133.141 E-.11627
G1 X118.944 Y133.254 E-.12168
G1 X119.283 Y133.318 E-.13104
G1 X119.656 Y133.339 E-.14222
G1 X120.177 Y133.34 E-.19769
; WIPE_END
G1 E-.04 F1800
G1 X127.802 Y133.669 Z23 F30000
G1 X138.154 Y134.116 Z23
G1 Z22.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.53114
G1 F4295
G1 X138.974 Y134.118 E.03264
G1 X139.279 Y133.631 E.02283
G1 X139.519 Y133.051 E.025
G1 X139.044 Y133.044 E.01889
G1 X138.803 Y133.485 E.02
G1 X138.411 Y133.932 E.02366
G1 X138.203 Y134.081 E.01017
G1 X119.638 Y134.125 F30000
; LINE_WIDTH: 0.423273
G1 F4295
G3 X117.87 Y133.57 I-.115 J-2.73 E.05861
G1 X117.533 Y133.213 E.01522
G1 X117.289 Y132.78 E.0154
G1 X117.223 Y132.565 E.00696
M73 P96 R0
G1 X115.95 Y132.598 E.03947
G1 X115.855 Y132.618 E.003
G1 X116.286 Y133.742 E.03729
G1 X116.735 Y134.501 E.02733
G2 X119.637 Y134.506 I3.191 J-901.866 E.08997
G1 X136.321 Y134.551 E.51711
G3 X139.224 Y134.56 I.545 J267.511 E.08997
G1 X139.677 Y133.804 E.02733
G1 X140.111 Y132.688 E.0371
G2 X138.754 Y132.62 I-1.042 J7.207 E.04217
G1 X138.619 Y132.949 E.01101
G1 X138.332 Y133.379 E.01604
G1 X138.059 Y133.652 E.01195
G1 X137.653 Y133.905 E.01484
G3 X136.322 Y134.169 I-1.298 J-3.051 E.04233
G1 X119.698 Y134.125 E.51525
G1 X117.807 Y134.061 F30000
; LINE_WIDTH: 0.531734
G1 F4295
G1 X117.551 Y133.877 E.01258
G1 X117.164 Y133.433 E.02344
G1 X116.926 Y132.994 E.0199
G1 X116.455 Y133.006 E.01879
G1 X116.667 Y133.535 E.0227
G1 X116.987 Y134.059 E.02447
G1 X117.747 Y134.061 E.03029
; WIPE_START
G1 F13502.065
G1 X116.987 Y134.059 E-.28893
G1 X116.667 Y133.535 E-.23342
G1 X116.455 Y133.006 E-.21655
G1 X116.51 Y133.005 E-.02109
; WIPE_END
G1 E-.04 F1800
G1 X124.107 Y133.736 Z23 F30000
G1 X139.041 Y135.174 Z23
G1 Z22.6
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F4295
M204 S2000
G1 X139.336 Y135.469 E.01282
G1 X139.061 Y135.728
G1 X138.506 Y135.173 E.02413
G1 X137.971 Y135.172
G1 X138.787 Y135.987 E.03544
G1 X138.458 Y136.192
G1 X137.437 Y135.17 E.04439
G1 X136.902 Y135.169
G1 X138.013 Y136.28 E.04827
G1 X137.478 Y136.278
G1 X136.367 Y135.167 E.04828
G1 X135.833 Y135.166
G1 X136.944 Y136.277 E.04828
G1 X136.409 Y136.275
G1 X135.298 Y135.164 E.04828
G1 X134.763 Y135.163
G1 X135.874 Y136.274 E.04828
G1 X135.34 Y136.273
G1 X134.229 Y135.162 E.04828
G1 X133.694 Y135.16
G1 X134.805 Y136.271 E.04828
G1 X134.27 Y136.27
G1 X133.159 Y135.159 E.04828
G1 X132.625 Y135.157
G1 X133.736 Y136.268 E.04827
G1 X133.201 Y136.267
G1 X132.09 Y135.156 E.04827
G1 X131.555 Y135.155
G1 X132.666 Y136.265 E.04828
G1 X132.132 Y136.264
G1 X131.021 Y135.153 E.04828
G1 X130.486 Y135.152
G1 X131.597 Y136.263 E.04828
G1 X131.062 Y136.261
G1 X129.951 Y135.15 E.04828
G1 X129.417 Y135.149
G1 X130.528 Y136.26 E.04828
G1 X129.993 Y136.258
G1 X128.882 Y135.147 E.04828
G1 X128.347 Y135.146
G1 X129.458 Y136.257 E.04828
G1 X128.923 Y136.256
G1 X127.813 Y135.145 E.04828
G1 X127.278 Y135.143
G1 X128.389 Y136.254 E.04828
G1 X127.854 Y136.253
G1 X126.743 Y135.142 E.04828
G1 X126.209 Y135.14
G1 X127.319 Y136.251 E.04828
G1 X126.785 Y136.25
G1 X125.674 Y135.139 E.04828
G1 X125.139 Y135.137
G1 X126.25 Y136.248 E.04828
G1 X125.715 Y136.247
G1 X124.604 Y135.136 E.04828
G1 X124.07 Y135.135
G1 X125.181 Y136.246 E.04828
G1 X124.646 Y136.244
G1 X123.535 Y135.133 E.04828
G1 X123 Y135.132
G1 X124.111 Y136.243 E.04828
G1 X123.577 Y136.241
G1 X122.466 Y135.13 E.04828
G1 X121.931 Y135.129
G1 X123.042 Y136.24 E.04828
G1 X122.507 Y136.238
G1 X121.396 Y135.128 E.04828
G1 X120.862 Y135.126
G1 X121.973 Y136.237 E.04828
G1 X121.438 Y136.236
G1 X120.327 Y135.125 E.04828
G1 X119.792 Y135.123
G1 X120.903 Y136.234 E.04828
G1 X120.369 Y136.233
G1 X119.258 Y135.122 E.04828
G1 X118.723 Y135.12
G1 X119.834 Y136.231 E.04828
G1 X119.299 Y136.23
G1 X118.188 Y135.119 E.04828
G1 X117.654 Y135.118
G1 X118.765 Y136.228 E.04828
G1 X118.23 Y136.227
G1 X117.119 Y135.116 E.04828
G1 X116.584 Y135.115
G1 X117.695 Y136.226 E.04828
; CHANGE_LAYER
; Z_HEIGHT: 22.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F12000
M204 S10000
G1 X116.584 Y135.115 E-.59702
G1 X117.013 Y135.116 E-.16299
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 114/118
; update layer progress
M73 L114
M991 S0 P113 ;notify layer change
G17
G3 Z23 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.11 Y133.307
G1 Z22.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3569
G1 X118.143 Y133.326 E.00126
G2 X118.837 Y133.686 I1.157 J-1.385 E.02616
G2 X119.645 Y133.784 I.775 J-3 E.02705
G1 X136.318 Y133.828 E.55308
G2 X137.497 Y133.598 I.025 J-3 E.04011
G2 X138.454 Y132.285 I-.85 J-1.626 E.05585
G3 X140.185 Y132.426 I.262 J7.461 E.05772
G1 X140.302 Y132.489 E.00441
G3 X140.032 Y133.226 I-5.058 J-1.431 E.02606
G1 X139.448 Y134.202 E.03773
G1 X116.513 Y134.141 E.76082
G1 X115.933 Y133.162 E.03773
G3 X115.668 Y132.423 I4.8 J-2.143 E.02606
G3 X115.978 Y132.314 I.383 J.591 E.011
G3 X117.513 Y132.229 I1.347 J10.412 E.05107
G1 X117.552 Y132.39 E.0055
G2 X117.869 Y133.042 I1.748 J-.449 E.02421
G1 X118.069 Y133.263 E.0099
M204 S250
G1 X118.328 Y132.969 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3569
M204 S5000
G1 X118.392 Y133.022 E.00255
G2 X118.944 Y133.307 I.971 J-1.206 E.0192
G2 X119.656 Y133.392 I.678 J-2.649 E.02212
G1 X136.309 Y133.436 E.51168
G2 X137.322 Y133.244 I.036 J-2.578 E.03191
G2 X138.043 Y132.332 I-.639 J-1.246 E.03684
G2 X138.122 Y131.889 I-1.368 J-.473 E.0139
G3 X140.065 Y131.992 I.313 J12.44 E.05985
G3 X140.601 Y132.244 I-.125 J.961 E.01851
G3 X140.665 Y132.642 I-.426 J.272 E.01273
G3 X140.385 Y133.4 I-5.204 J-1.49 E.02483
G1 X139.539 Y134.814 E.05065
G1 X138.846 Y135.467 E.02926
G1 X138.201 Y135.818 E.02256
G1 X117.751 Y135.763 E.62836
G1 X117.108 Y135.409 E.02256
G1 X116.419 Y134.752 E.02926
G1 X115.58 Y133.334 E.05065
G3 X115.304 Y132.575 I4.934 J-2.22 E.02483
G3 X115.633 Y131.998 I.471 J-.114 E.02248
G3 X116.968 Y131.84 I1.274 J5.059 E.0414
G1 X117.851 Y131.835 E.02714
G1 X117.857 Y131.942 E.00331
G2 X118.176 Y132.811 I2.245 J-.333 E.02864
G1 X118.287 Y132.926 E.0049
M204 S10000
G1 X118.163 Y133.622 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.121896
G1 F3569
G1 X118.348 Y133.774 E.00154
; LINE_WIDTH: 0.148811
G1 X118.578 Y133.943 E.00246
G1 X118.625 Y133.885 F30000
; LINE_WIDTH: 0.159388
G1 F3569
G1 X118.478 Y133.858 E.00142
; LINE_WIDTH: 0.195055
G1 X118.331 Y133.831 E.00185
G1 X118.625 Y133.885 F30000
; LINE_WIDTH: 0.123721
G1 F3569
G1 X118.771 Y133.912 E.00098
; LINE_WIDTH: 0.101003
G1 X118.844 Y133.919 E.00035
G1 X117.217 Y132.623 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3569
G2 X116.174 Y132.689 I-.151 J5.862 E.03216
G1 X116.298 Y133.009 E.01054
G1 X116.737 Y133.749 E.02644
G1 X117.697 Y133.752 E.0295
G1 X117.666 Y133.619 E.0042
G1 X117.753 Y133.502 E.00447
G1 X117.533 Y133.266 E.00992
G1 X117.29 Y132.834 E.01525
G1 X117.237 Y132.68 E.00501
G1 X116.895 Y133.098 F30000
; LINE_WIDTH: 0.60159
G1 F3569
G1 X116.973 Y133.231 E.00702
; WIPE_START
G1 F11813.772
G1 X116.895 Y133.098 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.521 Y133.426 Z23.2 F30000
G1 X137.118 Y133.968 Z23.2
G1 Z22.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.116246
G1 F3569
G1 X137.337 Y133.935 E.00133
; LINE_WIDTH: 0.159388
G1 X137.484 Y133.909 E.00142
; LINE_WIDTH: 0.195055
G1 X137.631 Y133.883 E.00185
G1 X137.615 Y133.825 F30000
; LINE_WIDTH: 0.121901
G1 F3569
G1 X137.801 Y133.674 E.00154
G1 X137.615 Y133.825 F30000
; LINE_WIDTH: 0.148816
G1 F3569
G1 X137.384 Y133.993 E.00246
; WIPE_START
G1 F15000
G1 X137.615 Y133.825 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X139.041 Y134.423 Z23.2 F30000
G1 Z22.8
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F3569
M204 S2000
G1 X137.855 Y135.609 E.05153
G1 X137.323 Y135.608
G1 X138.509 Y134.422 E.05153
G1 X137.977 Y134.42
G1 X136.791 Y135.606 E.05153
G1 X136.259 Y135.605
G1 X137.445 Y134.419 E.05153
G1 X136.913 Y134.418
G1 X135.727 Y135.604 E.05153
G1 X135.195 Y135.602
G1 X136.381 Y134.416 E.05153
G1 X135.85 Y134.415
G1 X134.664 Y135.601 E.05153
G1 X134.132 Y135.599
G1 X135.318 Y134.413 E.05153
G1 X134.786 Y134.412
G1 X133.6 Y135.598 E.05153
G1 X133.068 Y135.596
G1 X134.254 Y134.411 E.05153
G1 X133.722 Y134.409
G1 X132.536 Y135.595 E.05153
G1 X132.004 Y135.594
G1 X133.19 Y134.408 E.05153
G1 X132.658 Y134.406
G1 X131.473 Y135.592 E.05153
G1 X130.941 Y135.591
G1 X132.127 Y134.405 E.05153
G1 X131.595 Y134.403
G1 X130.409 Y135.589 E.05153
G1 X129.877 Y135.588
G1 X131.063 Y134.402 E.05153
G1 X130.531 Y134.401
G1 X129.345 Y135.587 E.05153
G1 X128.813 Y135.585
G1 X129.999 Y134.399 E.05153
G1 X129.467 Y134.398
G1 X128.281 Y135.584 E.05153
G1 X127.75 Y135.582
G1 X128.936 Y134.396 E.05153
G1 X128.404 Y134.395
G1 X127.218 Y135.581 E.05153
G1 X126.686 Y135.579
G1 X127.872 Y134.394 E.05153
G1 X127.34 Y134.392
G1 X126.154 Y135.578 E.05153
G1 X125.622 Y135.577
G1 X126.808 Y134.391 E.05153
G1 X126.276 Y134.389
G1 X125.09 Y135.575 E.05153
G1 X124.559 Y135.574
G1 X125.744 Y134.388 E.05153
G1 X125.213 Y134.387
G1 X124.027 Y135.572 E.05153
G1 X123.495 Y135.571
G1 X124.681 Y134.385 E.05153
G1 X124.149 Y134.384
G1 X122.963 Y135.57 E.05153
G1 X122.431 Y135.568
G1 X123.617 Y134.382 E.05153
G1 X123.085 Y134.381
G1 X121.899 Y135.567 E.05153
G1 X121.368 Y135.565
G1 X122.553 Y134.379 E.05153
G1 X122.022 Y134.378
G1 X120.836 Y135.564 E.05153
G1 X120.304 Y135.563
G1 X121.49 Y134.377 E.05153
G1 X120.958 Y134.375
G1 X119.772 Y135.561 E.05153
G1 X119.24 Y135.56
G1 X120.426 Y134.374 E.05153
G1 X119.894 Y134.372
G1 X118.708 Y135.558 E.05153
G1 X118.176 Y135.557
G1 X119.362 Y134.371 E.05153
G1 X118.831 Y134.37
G1 X117.701 Y135.499 E.04908
G1 X117.357 Y135.31
G1 X118.299 Y134.368 E.04092
G1 X117.767 Y134.367
G1 X117.058 Y135.075 E.0308
G1 X116.785 Y134.815
G1 X117.235 Y134.365 E.01955
M204 S10000
G1 X117.295 Y135.275 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.0978732
G1 F3569
G3 X117.203 Y135.198 I.249 J-.391 E.00054
; WIPE_START
G1 F15000
G1 X117.295 Y135.275 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X120.678 Y134.388 Z23.2 F30000
G1 Z22.8
G1 E.8 F1800
; LINE_WIDTH: 0.108101
G1 F3569
G1 X120.44 Y134.388 E.00126
G1 X128.035 Y134.497 F30000
; LINE_WIDTH: 0.127386
G1 F3569
G1 X127.913 Y134.375 E.00119
G1 X139.109 Y134.405 F30000
; LINE_WIDTH: 0.240617
G1 F3569
G1 X139.18 Y134.454 E.0014
; LINE_WIDTH: 0.280534
G1 X139.252 Y134.504 E.00168
; LINE_WIDTH: 0.31803
G1 X139.323 Y134.554 E.00195
G1 X139.262 Y134.645 E.00245
; LINE_WIDTH: 0.279722
G1 X138.668 Y135.221 E.01598
; LINE_WIDTH: 0.245228
G1 X138.538 Y135.318 E.00267
; LINE_WIDTH: 0.200351
G1 X138.409 Y135.415 E.00208
; LINE_WIDTH: 0.155475
G1 X138.279 Y135.512 E.00149
; LINE_WIDTH: 0.110599
G1 X138.149 Y135.609 E.00089
; WIPE_START
G1 F15000
G1 X138.279 Y135.512 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.751 Y132.684 Z23.2 F30000
G1 Z22.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F3569
G3 X138.211 Y133.557 I-2.354 J-.852 E.03177
G1 X138.298 Y133.674 E.00447
G1 X138.266 Y133.807 E.0042
G1 X139.226 Y133.809 E.02951
G1 X139.679 Y133.053 E.02708
G1 X139.795 Y132.752 E.00991
G2 X138.81 Y132.686 I-1.338 J12.596 E.03031
G1 X138.962 Y133.341 F30000
; LINE_WIDTH: 0.60145
G1 F3569
G1 X139.036 Y133.216 E.00661
; CHANGE_LAYER
; Z_HEIGHT: 23
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F11816.734
G1 X138.962 Y133.341 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 115/118
; update layer progress
M73 L115
M991 S0 P114 ;notify layer change
G17
G3 Z23.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.109 Y133.361
G1 Z23
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2853
G1 X118.141 Y133.394 E.00153
G1 X116.515 Y133.39 E.05397
G1 X116.004 Y132.501 E.03401
G3 X116.98 Y132.319 I1.039 J2.878 E.03308
G1 X117.519 Y132.304 E.01787
G1 X117.551 Y132.444 E.00474
G2 X117.863 Y133.099 I1.763 J-.436 E.02424
M73 P97 R0
G1 X118.068 Y133.317 E.00993
; WIPE_START
G1 F16213.044
G1 X118.141 Y133.394 E-.04038
G1 X116.515 Y133.39 E-.61824
G1 X116.382 Y133.158 E-.10138
; WIPE_END
G1 E-.04 F1800
G1 X124.013 Y133.261 Z23.4 F30000
G1 X137.823 Y133.446 Z23.4
G1 Z23
G1 E.8 F1800
G1 F2853
G1 X138.106 Y133.155 E.01347
G2 X138.45 Y132.359 I-1.874 J-1.281 E.02895
G1 X138.989 Y132.378 E.01792
G3 X139.965 Y132.564 I-.079 J3.061 E.03311
G1 X139.45 Y133.451 E.03401
G1 X137.883 Y133.447 E.05198
; WIPE_START
G1 F16213.044
G1 X138.106 Y133.155 E-.13942
G1 X138.311 Y132.804 E-.15458
G1 X138.45 Y132.359 E-.17713
G1 X138.989 Y132.378 E-.20523
G1 X139.209 Y132.399 E-.08364
; WIPE_END
G1 E-.04 F1800
G1 X131.579 Y132.624 Z23.4 F30000
G1 X118.321 Y133.015 Z23.4
G1 Z23
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2853
M204 S5000
G1 X118.386 Y133.083 E.00289
G2 X119.282 Y133.424 I1.102 J-1.546 E.0298
G1 X119.656 Y133.445 E.0115
G1 X136.308 Y133.489 E.51168
G2 X137.322 Y133.297 I.036 J-2.577 E.03191
G2 X138.043 Y132.386 I-.639 J-1.246 E.03682
G2 X138.121 Y131.959 I-1.319 J-.463 E.0134
G3 X139.59 Y132.044 I-.002 J12.727 E.04524
G3 X140.292 Y132.316 I-.198 J1.551 E.02336
G3 X140.35 Y132.669 I-.348 J.239 E.01136
G1 X140.246 Y132.884 E.00734
G1 X139.541 Y134.063 E.0422
G1 X138.848 Y134.716 E.02926
G1 X138.203 Y135.066 E.02256
G1 X117.753 Y135.012 E.62836
G1 X117.11 Y134.658 E.02256
G1 X116.421 Y134.001 E.02926
G1 X115.721 Y132.819 E.0422
G1 X115.619 Y132.604 E.00734
G3 X115.82 Y132.152 I.329 J-.124 E.01686
G3 X116.959 Y131.928 I1.187 J3.03 E.03586
G3 X117.852 Y131.905 I.857 J15.861 E.02744
G2 X118.183 Y132.858 I1.661 J-.043 E.03152
G1 X118.281 Y132.97 E.00456
M204 S10000
G1 X118.418 Y133.364 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.12092
G1 F2853
G2 X118.714 Y133.592 I2.249 J-2.621 E.00238
G1 X118.7 Y133.537 F30000
; LINE_WIDTH: 0.15718
G1 F2853
G1 X118.519 Y133.504 E.00172
G1 X118.7 Y133.537 F30000
; LINE_WIDTH: 0.117007
G1 F2853
G1 X118.882 Y133.57 E.00111
; WIPE_START
G1 F15000
G1 X118.7 Y133.537 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X117.633 Y133.189 Z23.4 F30000
G1 Z23
G1 E.8 F1800
; LINE_WIDTH: 0.103747
G1 F2853
G1 X117.576 Y133.066 E.00067
G1 X117.244 Y132.68 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.367076
G1 F2853
G1 X116.56 Y132.74 E.01813
G1 X116.725 Y133.027 E.00875
G1 X117.11 Y133.023 E.01016
G1 X117.124 Y132.893 E.00346
G1 X117.283 Y132.795 E.00494
G1 X117.263 Y132.737 E.00163
; WIPE_START
G1 F15000
G1 X117.283 Y132.795 E-.02631
G1 X117.124 Y132.893 E-.07981
G1 X117.11 Y133.023 E-.05586
G1 X116.725 Y133.027 E-.16403
G1 X116.56 Y132.74 E-.14124
G1 X117.244 Y132.68 E-.29276
; WIPE_END
G1 E-.04 F1800
G1 X124.868 Y133.041 Z23.4 F30000
G1 X137.082 Y133.618 Z23.4
G1 Z23
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.116991
G1 F2853
G1 X137.264 Y133.586 E.00111
; LINE_WIDTH: 0.157136
G1 X137.445 Y133.554 E.00172
G1 X137.547 Y133.415 F30000
; LINE_WIDTH: 0.120839
G1 F2853
G3 X137.25 Y133.641 I-2.279 J-2.688 E.00237
G1 X138.604 Y133.671 F30000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F2853
M204 S2000
G1 X139.114 Y134.181 E.02215
G1 X138.839 Y134.439
G1 X138.069 Y133.67 E.03346
G1 X137.534 Y133.668
G1 X138.523 Y134.657 E.04295
G1 X138.177 Y134.844
G1 X137 Y133.667 E.05117
G1 X136.488 Y133.688
G1 X137.657 Y134.858 E.05082
G1 X137.123 Y134.856
G1 X135.963 Y133.696 E.05042
G1 X135.428 Y133.695
G1 X136.588 Y134.855 E.05041
G1 X136.053 Y134.853
G1 X134.893 Y133.693 E.05041
G1 X134.359 Y133.692
G1 X135.519 Y134.852 E.05041
G1 X134.984 Y134.85
G1 X133.824 Y133.69 E.05041
G1 X133.289 Y133.689
G1 X134.449 Y134.849 E.05042
G1 X133.915 Y134.848
G1 X132.754 Y133.687 E.05042
G1 X132.22 Y133.686
G1 X133.38 Y134.846 E.05042
G1 X132.845 Y134.845
G1 X131.685 Y133.685 E.05042
G1 X131.15 Y133.683
G1 X132.311 Y134.843 E.05042
G1 X131.776 Y134.842
G1 X130.616 Y133.682 E.05042
G1 X130.081 Y133.68
G1 X131.241 Y134.84 E.05042
G1 X130.707 Y134.839
G1 X129.546 Y133.679 E.05042
G1 X129.012 Y133.677
G1 X130.172 Y134.838 E.05042
G1 X129.637 Y134.836
G1 X128.477 Y133.676 E.05042
G1 X127.942 Y133.675
G1 X129.103 Y134.835 E.05042
G1 X128.568 Y134.833
G1 X127.408 Y133.673 E.05042
G1 X126.873 Y133.672
G1 X128.033 Y134.832 E.05042
G1 X127.498 Y134.83
G1 X126.338 Y133.67 E.05042
G1 X125.804 Y133.669
G1 X126.964 Y134.829 E.05042
G1 X126.429 Y134.828
G1 X125.269 Y133.667 E.05042
G1 X124.734 Y133.666
G1 X125.894 Y134.826 E.05042
G1 X125.36 Y134.825
G1 X124.2 Y133.665 E.05042
G1 X123.665 Y133.663
G1 X124.825 Y134.823 E.05042
G1 X124.29 Y134.822
G1 X123.13 Y133.662 E.05042
G1 X122.596 Y133.66
G1 X123.756 Y134.821 E.05042
G1 X123.221 Y134.819
G1 X122.061 Y133.659 E.05042
G1 X121.526 Y133.658
G1 X122.686 Y134.818 E.05042
G1 X122.152 Y134.816
G1 X120.992 Y133.656 E.05042
G1 X120.457 Y133.655
G1 X121.617 Y134.815 E.05042
G1 X121.082 Y134.813
G1 X119.922 Y133.653 E.05042
G1 X119.373 Y133.637
G1 X120.548 Y134.812 E.05106
G1 X120.013 Y134.811
G1 X118.821 Y133.618 E.05181
G1 X118.286 Y133.617
G1 X119.478 Y134.809 E.05181
G1 X118.944 Y134.808
G1 X117.751 Y133.615 E.05181
G1 X117.217 Y133.614
G1 X118.409 Y134.806 E.05181
G1 X117.874 Y134.805
G1 X116.682 Y133.613 E.05181
M204 S10000
G1 X116.486 Y133.593 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.217945
G1 F2853
G1 X116.487 Y133.685 E.00131
; LINE_WIDTH: 0.193652
G1 X116.503 Y133.73 E.00059
; LINE_WIDTH: 0.149424
G1 X116.519 Y133.776 E.00042
; LINE_WIDTH: 0.113926
G1 X117.301 Y134.526 E.00627
; WIPE_START
G1 F15000
G1 X116.519 Y133.776 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.143 Y133.421 Z23.4 F30000
G1 X138.717 Y132.742 Z23.4
G1 Z23
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.367526
G1 F2853
G1 X138.577 Y133.08 E.00968
G2 X139.242 Y133.087 I.715 J-35.56 E.01758
G1 X139.416 Y132.786 E.00921
G3 X138.777 Y132.746 I1.768 J-33.234 E.01696
; CHANGE_LAYER
; Z_HEIGHT: 23.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X139.416 Y132.786 E-.24363
G1 X139.242 Y133.087 E-.13225
G1 X138.577 Y133.08 E-.2525
G1 X138.709 Y132.76 E-.13162
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 116/118
; update layer progress
M73 L116
M991 S0 P115 ;notify layer change
G17
G3 Z23.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.313 Y133.06
G1 Z23.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1573
M204 S5000
G1 X118.392 Y133.129 E.00322
G2 X118.943 Y133.413 I.971 J-1.206 E.0192
G2 X119.656 Y133.498 I.678 J-2.649 E.02212
G1 X136.308 Y133.543 E.51169
G2 X137.322 Y133.351 I.036 J-2.578 E.03191
G2 X138.042 Y132.439 I-.639 J-1.246 E.03681
G2 X138.118 Y132.059 I-1.193 J-.436 E.01197
G3 X139.495 Y132.196 I.029 J6.683 E.04258
G3 X139.88 Y132.464 I-.158 J.638 E.01476
G3 X139.871 Y132.721 I-.311 J.118 E.00811
G3 X139.543 Y133.312 I-3.468 J-1.544 E.02079
G1 X138.85 Y133.965 E.02926
G1 X138.205 Y134.315 E.02256
G1 X117.755 Y134.261 E.62836
G1 X117.112 Y133.907 E.02256
G1 X116.423 Y133.25 E.02926
G3 X116.097 Y132.658 I3.148 J-2.116 E.02079
G3 X116.297 Y132.206 I.323 J-.127 E.01689
G3 X116.541 Y132.119 I.439 J.841 E.00801
G3 X117.803 Y132.005 I1.482 J9.367 E.03894
G1 X117.854 Y132.005 E.00158
G1 X117.856 Y132.051 E.00141
G2 X118.176 Y132.917 I2.069 J-.27 E.02862
G1 X118.271 Y133.017 E.00423
M204 S10000
G1 X117.766 Y132.519 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.654333
G1 F1573
G1 X117.142 Y132.535 E.03111
; LINE_WIDTH: 0.627092
G1 X116.886 Y132.553 E.01223
; LINE_WIDTH: 0.588804
G2 X116.617 Y132.572 I.065 J2.755 E.01199
; LINE_WIDTH: 0.556445
G1 X116.557 Y132.584 E.00255
; LINE_WIDTH: 0.52147
G1 X116.544 Y132.611 E.00117
; LINE_WIDTH: 0.474643
G1 X116.531 Y132.638 E.00105
; LINE_WIDTH: 0.427817
G1 X116.518 Y132.665 E.00094
; LINE_WIDTH: 0.380991
G1 X116.505 Y132.691 E.00082
; LINE_WIDTH: 0.334164
G1 X116.492 Y132.718 E.00071
; LINE_WIDTH: 0.291834
G1 X116.485 Y132.795 E.00156
; LINE_WIDTH: 0.254028
G1 X116.478 Y132.871 E.00132
; LINE_WIDTH: 0.216222
G1 X116.472 Y132.948 E.00108
; WIPE_START
G1 F15000
G1 X116.478 Y132.871 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.098 Y133.314 Z23.6 F30000
G1 X137.757 Y134.107 Z23.6
G1 Z23.2
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F1573
M204 S2000
G1 X138.943 Y132.921 E.05153
G1 X138.412 Y132.919
G1 X137.226 Y134.105 E.05153
; WIPE_START
G1 F12000
M204 S10000
G1 X138.412 Y132.919 E-.63731
G1 X138.734 Y132.92 E-.12269
; WIPE_END
G1 E-.04 F1800
G1 X131.105 Y133.145 Z23.6 F30000
G1 X118.62 Y133.514 Z23.6
G1 Z23.2
G1 E.8 F1800
G1 F1573
M204 S2000
G1 X118.079 Y134.054 E.0235
G1 X117.64 Y133.961
G1 X118.284 Y133.317 E.02798
G1 X118.016 Y133.051
G1 X117.296 Y133.771 E.03132
G1 X117.01 Y133.524
G1 X117.67 Y132.864 E.02866
G1 X117.138 Y132.863
G1 X116.737 Y133.263 E.01741
; WIPE_START
G1 F12000
M204 S10000
G1 X117.138 Y132.863 E-.21531
G1 X117.67 Y132.864 E-.2021
G1 X117.032 Y133.502 E-.34259
; WIPE_END
G1 E-.04 F1800
G1 X117.969 Y132.975 Z23.6 F30000
G1 Z23.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.113447
G1 F1573
G2 X117.895 Y132.883 I-.446 J.278 E.00068
G1 X117.71 Y132.905 E.00107
; WIPE_START
G1 F15000
G1 X117.895 Y132.883 E-.46533
G1 X117.969 Y132.975 E-.29467
; WIPE_END
G1 E-.04 F1800
G1 X125.591 Y133.366 Z23.6 F30000
G1 X136.918 Y133.947 Z23.6
G1 Z23.2
G1 E.8 F1800
; LINE_WIDTH: 0.39569
G1 F1573
G1 X118.779 Y133.887 E.52142
; LINE_WIDTH: 0.396197
G1 X118.783 Y133.851 E.00103
; LINE_WIDTH: 0.350849
G1 X118.786 Y133.816 E.0009
; LINE_WIDTH: 0.305501
G1 X118.79 Y133.78 E.00077
; LINE_WIDTH: 0.260153
G1 X118.793 Y133.745 E.00063
; LINE_WIDTH: 0.214805
G1 X118.797 Y133.709 E.0005
; LINE_WIDTH: 0.165858
G2 X118.819 Y133.638 I-.143 J-.083 E.00075
G1 X118.69 Y133.52 E.00175
G1 X137.47 Y133.594 F30000
; LINE_WIDTH: 0.297998
G1 F1573
G1 X137.286 Y133.711 E.00454
; LINE_WIDTH: 0.337052
G1 X137.102 Y133.829 E.00524
; LINE_WIDTH: 0.376105
G1 X136.918 Y133.947 E.00594
; LINE_WIDTH: 0.373754
G1 X136.974 Y133.991 E.00193
; LINE_WIDTH: 0.330012
G1 X137.03 Y134.035 E.00168
; LINE_WIDTH: 0.286269
G1 X137.087 Y134.08 E.00142
; LINE_WIDTH: 0.242527
G1 X137.143 Y134.124 E.00116
; WIPE_START
G1 F15000
G1 X137.087 Y134.08 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.102 Y132.9 Z23.6 F30000
G1 Z23.2
G1 E.8 F1800
; LINE_WIDTH: 0.103597
G1 F1573
G1 X137.985 Y133.051 E.00095
G1 X139.027 Y132.902 F30000
; LINE_WIDTH: 0.24298
G1 F1573
G1 X139.083 Y132.947 E.00117
; LINE_WIDTH: 0.287627
G1 X139.14 Y132.991 E.00144
; LINE_WIDTH: 0.332273
G1 X139.196 Y133.036 E.0017
; LINE_WIDTH: 0.378979
G1 X139.253 Y133.081 E.00197
G1 X139.189 Y133.167 E.00292
; LINE_WIDTH: 0.350558
G1 X138.651 Y133.69 E.01882
; LINE_WIDTH: 0.316875
G1 X138.505 Y133.799 E.00407
; LINE_WIDTH: 0.27134
G1 X138.359 Y133.908 E.0034
; LINE_WIDTH: 0.225804
G1 X138.212 Y134.017 E.00272
; LINE_WIDTH: 0.180268
G1 X138.066 Y134.126 E.00204
; WIPE_START
G1 F15000
G1 X138.212 Y134.017 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.101 Y132.892 Z23.6 F30000
G1 Z23.2
G1 E.8 F1800
; LINE_WIDTH: 0.653964
G1 F1573
G1 X138.528 Y132.583 E.02625
G1 X138.827 Y132.593 E.01492
; LINE_WIDTH: 0.6271
G1 X139.084 Y132.612 E.01223
; LINE_WIDTH: 0.589757
G1 X139.34 Y132.631 E.01145
; LINE_WIDTH: 0.558956
G1 X139.411 Y132.644 E.00303
; LINE_WIDTH: 0.522588
G1 X139.425 Y132.671 E.0012
; LINE_WIDTH: 0.474664
G1 X139.438 Y132.698 E.00105
; LINE_WIDTH: 0.427847
G1 X139.451 Y132.725 E.00094
; LINE_WIDTH: 0.38103
G1 X139.464 Y132.752 E.00082
; LINE_WIDTH: 0.334213
G1 X139.477 Y132.779 E.00071
; LINE_WIDTH: 0.29188
G1 X139.483 Y132.856 E.00156
; LINE_WIDTH: 0.254056
G1 X139.489 Y132.932 E.00132
; LINE_WIDTH: 0.216231
G1 X139.496 Y133.009 E.00108
; CHANGE_LAYER
; Z_HEIGHT: 23.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X139.489 Y132.932 E-.76
; WIPE_END
M73 P98 R0
G1 E-.04 F1800
; layer num/total_layer_count: 117/118
; update layer progress
M73 L117
M991 S0 P116 ;notify layer change
G17
G3 Z23.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X118.304 Y133.104
G1 Z23.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X118.386 Y133.189 E.00365
G2 X119.187 Y133.513 I1.06 J-1.466 E.02681
G1 X117.757 Y133.51 E.04392
G1 X117.114 Y133.156 E.02256
G3 X116.643 Y132.669 I2.217 J-2.612 E.02084
G1 X116.595 Y132.547 E.00402
G1 X116.612 Y132.484 E.00202
G1 X116.715 Y132.387 E.00434
G3 X117.105 Y132.241 I.61 J1.036 E.01285
G3 X117.868 Y132.159 I.762 J3.475 E.02362
G2 X118.181 Y132.966 I1.578 J-.147 E.02696
G1 X118.264 Y133.059 E.00381
; WIPE_START
G1 F12000
M204 S10000
G1 X118.386 Y133.189 E-.06788
G1 X118.643 Y133.354 E-.11612
G1 X118.943 Y133.467 E-.12165
G1 X119.187 Y133.513 E-.09438
G1 X118.239 Y133.511 E-.35996
; WIPE_END
G1 E-.04 F1800
G1 X125.856 Y133.013 Z23.8 F30000
G1 X138.104 Y132.211 Z23.8
G1 Z23.4
G1 E.8 F1800
G1 F1200
M204 S5000
G1 X138.245 Y132.212 E.00435
G3 X139.001 Y132.333 I-.545 J5.824 E.02354
G1 X139.255 Y132.447 E.00854
G1 X139.357 Y132.544 E.00434
G1 X139.374 Y132.608 E.00202
G1 X139.325 Y132.729 E.00402
G3 X138.852 Y133.214 I-2.676 J-2.14 E.02084
G1 X138.207 Y133.564 E.02256
G1 X136.777 Y133.56 E.04392
G2 X138.069 Y132.38 I-.118 J-1.426 E.05785
G3 X138.089 Y132.269 I1.1 J.137 E.00345
; WIPE_START
G1 F12000
M204 S10000
G1 X138.245 Y132.212 E-.06333
G1 X138.446 Y132.232 E-.07655
G1 X139.001 Y132.333 E-.21458
G1 X139.255 Y132.447 E-.10563
G1 X139.357 Y132.544 E-.05372
G1 X139.374 Y132.608 E-.02499
G1 X139.325 Y132.729 E-.04977
G1 X139.14 Y132.942 E-.10708
G1 X139.017 Y133.058 E-.06436
; WIPE_END
G1 E-.04 F1800
G1 X138.891 Y132.892 Z23.8 F30000
G1 Z23.4
G1 E.8 F1800
; FEATURE: Top surface
G1 F1200
M204 S2000
G1 X138.44 Y132.441 E.0196
G1 X138.183 Y132.717
G1 X138.588 Y133.121 E.01757
M204 S10000
G1 X139.145 Y132.678 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.0954184
G1 F1200
G1 X138.78 Y132.492 E.00175
G1 X138.762 Y133.04 F30000
; LINE_WIDTH: 0.10068
G1 F1200
G1 X138.721 Y133.034 E.0002
G1 X138.649 Y133.088 E.00042
; WIPE_START
G1 F15000
G1 X138.721 Y133.034 E-.52024
G1 X138.762 Y133.04 E-.23976
; WIPE_END
G1 E-.04 F1800
G1 X131.132 Y132.832 Z23.8 F30000
G1 X117.12 Y132.451 Z23.8
G1 Z23.4
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F1200
M204 S2000
G1 X117.925 Y133.256 E.03497
; WIPE_START
G1 F12000
M204 S10000
G1 X117.12 Y132.451 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X117.053 Y132.448 Z23.8 F30000
G1 Z23.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.181684
G1 F1200
G1 X116.901 Y132.574 E.00223
G1 X116.938 Y132.633 E.00078
G1 X117.264 Y132.951 E.00515
; LINE_WIDTH: 0.149224
G1 X117.388 Y133.045 E.00135
; LINE_WIDTH: 0.108518
G1 X117.513 Y133.138 E.00083
G1 X117.936 Y132.973 F30000
; LINE_WIDTH: 0.101297
G1 F1200
G1 X117.868 Y132.884 E.00053
; LINE_WIDTH: 0.139758
G3 X117.505 Y132.37 I5.161 J-4.032 E.00497
; CHANGE_LAYER
; Z_HEIGHT: 23.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X117.868 Y132.884 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 118/118
; update layer progress
M73 L118
M991 S0 P117 ;notify layer change
G17
G3 Z23.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 1964
G1 X138.062 Y132.512
G1 Z23.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.378512
G1 F1200
M204 S5000
G1 X138.207 Y132.514 E.00397
G1 X138.365 Y132.609 E.00504
G1 X138.374 Y132.642 E.00095
G3 X138.205 Y132.81 I-.309 J-.143 E.00665
G1 X137.944 Y132.809 E.00716
G2 X138.042 Y132.569 I-2.734 J-1.26 E.0071
; WIPE_START
G1 F12000
M204 S10000
G1 X138.207 Y132.514 E-.11426
G1 X138.365 Y132.609 E-.12107
G1 X138.374 Y132.642 E-.02285
G1 X138.294 Y132.751 E-.08917
G1 X138.205 Y132.81 E-.06975
G1 X137.944 Y132.809 E-.17216
G1 X138.042 Y132.569 E-.17074
; WIPE_END
G1 E-.04 F1800
G1 X130.41 Y132.64 Z24 F30000
G1 X118.025 Y132.756 Z24
G1 Z23.6
G1 E.8 F1800
G1 F1200
M204 S5000
G1 X117.763 Y132.755 E.00716
G3 X117.595 Y132.587 I.142 J-.31 E.00665
G1 X117.605 Y132.553 E.00095
G1 X117.763 Y132.459 E.00504
G1 X117.908 Y132.459 E.00397
G1 X117.919 Y132.481 E.00067
G2 X118 Y132.701 I2.3 J-.726 E.00643
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F12000
M204 S10000
G1 X117.763 Y132.755 E-.167
G1 X117.674 Y132.697 E-.07269
G1 X117.595 Y132.587 E-.09293
G1 X117.605 Y132.553 E-.02379
G1 X117.763 Y132.459 E-.12619
G1 X117.908 Y132.459 E-.09945
G1 X117.919 Y132.481 E-.01681
G1 X118 Y132.701 E-.16115
; WIPE_END
G1 E-.04 F1800
M106 S0
M106 P2 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; MACHINE_END_GCODE_START
; filament end gcode 

;===== date: 20230428 =====================
M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G1 E-0.8 F1800 ; retract
G1 Z24.1 F900 ; lower z a little
G1 X65 Y245 F12000 ; move to safe pos 
G1 Y265 F3000

G1 X65 Y245 F12000
G1 Y265 F3000
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

G1 X100 F12000 ; wipe
; pull back filament to AMS
M620 S255
G1 X20 Y50 F12000
G1 Y-3
T255
G1 X65 F12000
G1 Y265
G1 X100 F12000 ; wipe
M621 S255
M104 S0 ; turn off hotend

M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S3 ;wait for last picture to be taken
M623; end of "timelapse_record_flag"

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom

    G1 Z123.6 F600
    G1 Z121.6

M400 P100
M17 R ; restore z current

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M73 P100 R0
; EXECUTABLE_BLOCK_END

