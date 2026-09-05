; HEADER_BLOCK_START
; BambuStudio 02.05.00.66
; model printing time: 11m 54s; total estimated time: 19m 7s
; total layer number: 33
; total filament length [mm] : 1677.67
; total filament volume [cm^3] : 4035.26
; total filament weight [g] : 5.29
; filament_density: 1.31,1.26,1.26,1.26,1.26,1.25,1.26,1.26,1.26,1.26,1.26,1.26,1.26,1.26,1.26
; filament_diameter: 1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75,1.75
; max_z_height: 5.01
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
; brim_type = outer_only
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
; different_settings_to_system = brim_type;brim_width;enable_support;ironing_flow;outer_wall_speed;support_type;wall_sequence;textured_plate_temp;textured_plate_temp_initial_layer;;;;;;;;;;;;;;;
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
; ironing_flow = 31%
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
; outer_wall_speed = 150
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
; textured_plate_temp = 45,55,55,55,55,55,55,55,55,55,55,55,55,55,55
; textured_plate_temp_initial_layer = 45,55,55,55,55,55,55,55,55,55,55,55,55,55,55
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
; wall_sequence = outer wall/inner wall
; wall_transition_angle = 10
; wall_transition_filter_deviation = 25%
; wall_transition_length = 100%
; wipe = 1
; wipe_distance = 2
; wipe_speed = 80%
; wipe_tower_no_sparse_layers = 0
; wipe_tower_rotation_angle = 0
; wipe_tower_x = 165,165
; wipe_tower_y = 216.972,216.972
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
M73 P0 R19
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
M140 S45 ;set bed temp
M190 S45 ;wait for bed temp



;=============turn on fans to prevent PLA jamming=================

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
M73 P7 R17
G1 E50 F200
M400
M104 S220
G92 E0
M73 P30 R13
G1 E50 F200
M400
M106 P1 S255
G92 E0
G1 E5 F300
M109 S200 ; drop nozzle temp, make filament shink a bit
G92 E0
M73 P32 R13
G1 E-0.5 F300

M73 P33 R12
G1 X70 F9000
G1 X76 F15000
G1 X65 F15000
G1 X76 F15000
G1 X65 F15000; shake to put down garbage
G1 X80 F6000
G1 X95 F15000
G1 X80 F15000
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
M73 P34 R12
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
    G29 A X102.721 Y106.684 I54.6848 J37.6845
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
G0 X240 E15 F4524.96
G0 Y11 E0.700 F1131.24
G0 X239.5
G0 E0.2
G0 Y1.5 E0.700
G0 X18 E15 F4524.96
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


;VT0
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
G1 E-.8 F1800
; layer num/total_layer_count: 1/33
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
; OBJECT_ID: 1237
M73 P35 R12
G1 X106.903 Y108.356
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X107.348 Y107.955 E.02229
G1 X108.194 Y107.29 E.04009
G1 X108.687 Y106.952 E.02226
G1 X109.308 Y106.573 E.02709
G1 X110.282 Y106.072 E.0408
G1 X110.931 Y105.795 E.02627
G1 X111.947 Y105.443 E.04006
G1 X112.653 Y105.253 E.02725
G1 X113.25 Y105.127 E.02271
G1 X114.299 Y104.977 E.03948
G1 X115.023 Y104.925 E.02703
M73 P36 R12
G1 X152.566 Y104.913 E1.39832
G1 X152.9 Y104.927 E.01247
G1 X153.377 Y104.987 E.01789
G1 X153.847 Y105.097 E.01797
G1 X154.303 Y105.255 E.01798
G1 X154.74 Y105.46 E.01798
G1 X155.155 Y105.711 E.01807
G1 X155.372 Y105.869 E.00999
G1 X155.739 Y106.183 E.01798
G1 X156.207 Y106.699 E.02595
G1 X156.481 Y107.093 E.01789
G1 X156.714 Y107.516 E.01798
G1 X156.901 Y107.961 E.01797
G1 X157.042 Y108.425 E.01808
G1 X157.098 Y108.688 E.01
G1 X157.161 Y109.171 E.01816
G1 X157.177 Y109.526 E.01322
G1 X157.173 Y111.672 E.07993
G1 X157.133 Y112.144 E.01765
G1 X157.048 Y112.603 E.01741
G1 X156.912 Y113.061 E.01777
G1 X156.634 Y113.694 E.02576
G1 X156.388 Y114.103 E.01775
G1 X156.221 Y114.334 E.01064
M73 P37 R12
G1 X155.864 Y114.747 E.02033
G1 X155.809 Y114.897 E.00594
G1 X155.8 Y132.147 E.64251
G1 X155.856 Y132.297 E.00597
M73 P37 R11
G1 X156.207 Y132.7 E.01989
G1 X156.375 Y132.93 E.01059
G1 X156.62 Y133.333 E.01758
G1 X156.899 Y133.955 E.0254
G1 X157.042 Y134.427 E.01835
G1 X157.13 Y134.886 E.01741
G1 X157.172 Y135.367 E.018
G1 X157.177 Y137.522 E.08024
G1 X157.163 Y137.863 E.01273
G1 X157.102 Y138.342 E.01799
G1 X157.047 Y138.605 E.00999
G1 X156.909 Y139.07 E.01808
G1 X156.724 Y139.516 E.01798
G1 X156.493 Y139.94 E.01799
G1 X156.219 Y140.338 E.01797
G1 X155.906 Y140.704 E.01797
G1 X155.555 Y141.036 E.01799
G1 X155.174 Y141.328 E.01788
G1 X154.569 Y141.679 E.02606
G1 X154.326 Y141.788 E.0099
G1 X153.871 Y141.949 E.01797
G1 X153.191 Y142.095 E.02591
G1 X152.56 Y142.14 E.02356
G1 X115.567 Y142.14 E1.37787
G1 X114.902 Y142.122 E.02477
G1 X114.305 Y142.077 E.02228
G1 X113.24 Y141.924 E.04008
G1 X112.636 Y141.795 E.02301
G1 X111.951 Y141.611 E.02643
G1 X111.38 Y141.426 E.02235
G1 X110.815 Y141.212 E.02251
G1 X110.256 Y140.968 E.02272
G1 X109.313 Y140.482 E.03951
G1 X108.801 Y140.174 E.02225
G1 X108.197 Y139.765 E.02718
G1 X107.719 Y139.403 E.02234
G1 X107.257 Y139.018 E.02238
G1 X106.815 Y138.613 E.02234
G1 X106.39 Y138.183 E.02252
G1 X105.982 Y137.729 E.02271
G1 X105.327 Y136.896 E.0395
G1 X104.989 Y136.402 E.02227
G1 X104.609 Y135.779 E.02717
G1 X104.324 Y135.25 E.02241
G1 X103.878 Y134.275 E.03992
G1 X103.625 Y133.595 E.02702
G1 X103.321 Y132.563 E.04006
G1 X103.187 Y131.96 E.02302
G1 X103.07 Y131.26 E.02642
G1 X103.002 Y130.664 E.02235
G1 X102.949 Y129.526 E.04246
G1 X102.949 Y117.53 E.4468
G1 X102.968 Y116.851 E.02528
G1 X103.069 Y115.796 E.03951
G1 X103.165 Y115.205 E.02227
G1 X103.295 Y114.599 E.0231
G1 X103.479 Y113.914 E.02643
G1 X103.664 Y113.343 E.02233
G1 X103.876 Y112.782 E.02237
G1 X104.115 Y112.231 E.02235
G1 X104.379 Y111.694 E.02228
G1 X104.917 Y110.762 E.0401
G1 X105.25 Y110.265 E.02229
G1 X105.607 Y109.783 E.02233
G1 X106.071 Y109.22 E.02718
G1 X106.477 Y108.778 E.02233
G1 X106.861 Y108.398 E.02012
M204 S6000
G1 X107.182 Y108.723 F30000
G1 F3000
M204 S500
G1 X107.215 Y108.69 E.00171
G1 X107.646 Y108.302 E.02161
G1 X108.461 Y107.661 E.03862
G1 X108.933 Y107.338 E.02129
G1 X109.537 Y106.97 E.02634
G1 X110.482 Y106.484 E.03958
G1 X111.1 Y106.22 E.02506
G1 X112.076 Y105.882 E.03847
M73 P38 R11
G1 X112.756 Y105.699 E.02623
G1 X113.334 Y105.577 E.022
G1 X114.343 Y105.432 E.03796
G1 X115.034 Y105.382 E.02582
G1 X152.851 Y105.382 E1.40851
G1 X153.303 Y105.439 E.01697
G1 X153.726 Y105.539 E.0162
G1 X154.136 Y105.682 E.01619
G1 X154.53 Y105.868 E.0162
G1 X154.898 Y106.09 E.016
G1 X155.426 Y106.517 E.02531
G1 X155.853 Y106.991 E.02377
G1 X156.096 Y107.341 E.01585
G1 X156.305 Y107.722 E.01619
G1 X156.473 Y108.123 E.01618
G1 X156.597 Y108.535 E.01602
G1 X156.706 Y109.217 E.02573
G1 X156.72 Y109.538 E.01199
G1 X156.716 Y111.647 E.07853
G1 X156.68 Y112.076 E.01603
G1 X156.604 Y112.489 E.01567
G1 X156.479 Y112.911 E.0164
G1 X156.222 Y113.491 E.02361
G1 X156.009 Y113.846 E.01541
G1 X155.866 Y114.046 E.00917
G1 X155.526 Y114.439 E.01935
G1 X155.432 Y114.599 E.00693
G1 X155.384 Y114.726 E.00502
G1 X155.351 Y114.909 E.00693
G1 X155.343 Y132.134 E.6416
G1 X155.377 Y132.319 E.00696
G1 X155.424 Y132.446 E.00505
G1 X155.52 Y132.606 E.00697
G1 X155.857 Y132.996 E.01919
G1 X156.218 Y133.554 E.02475
G1 X156.466 Y134.108 E.02262
G1 X156.599 Y134.544 E.01696
G1 X156.678 Y134.956 E.01563
G1 X156.715 Y135.394 E.01638
G1 X156.707 Y137.814 E.09013
G1 X156.606 Y138.48 E.02508
G1 X156.48 Y138.91 E.01671
G1 X156.314 Y139.312 E.01619
G1 X156.106 Y139.694 E.0162
G1 X155.861 Y140.053 E.01619
G1 X155.579 Y140.383 E.01619
G1 X155.252 Y140.692 E.01674
G1 X154.912 Y140.952 E.01595
G1 X154.346 Y141.278 E.0243
G1 X153.758 Y141.504 E.02346
G1 X153.136 Y141.639 E.02373
G1 X152.539 Y141.683 E.02229
G1 X115.575 Y141.683 E1.37678
G1 X114.929 Y141.666 E.02407
G1 X114.36 Y141.622 E.02125
G1 X113.325 Y141.474 E.03893
G1 X112.746 Y141.351 E.02204
G1 X112.084 Y141.174 E.02554
G1 X111.535 Y140.995 E.02151
G1 X110.984 Y140.787 E.02193
G1 X110.448 Y140.553 E.02179
G1 X109.54 Y140.085 E.03806
G1 X109.05 Y139.79 E.02127
G1 X108.466 Y139.395 E.02628
G1 X108.005 Y139.047 E.0215
G1 X107.556 Y138.672 E.0218
G1 X107.13 Y138.281 E.02154
G1 X106.725 Y137.872 E.02145
G1 X106.33 Y137.431 E.02204
G1 X105.698 Y136.629 E.03804
G1 X105.375 Y136.157 E.02129
G1 X105.008 Y135.555 E.02627
G1 X104.731 Y135.042 E.0217
G1 X104.303 Y134.104 E.03841
G1 X104.06 Y133.455 E.0258
G1 X103.765 Y132.454 E.03889
G1 X103.637 Y131.876 E.02205
G1 X103.523 Y131.2 E.02554
G1 X103.458 Y130.633 E.02127
G1 X103.406 Y129.512 E.04178
G1 X103.406 Y117.538 E.44597
G1 X103.425 Y116.875 E.02472
G1 X103.523 Y115.859 E.03803
G1 X103.615 Y115.287 E.02158
G1 X103.74 Y114.703 E.02224
G1 X103.916 Y114.047 E.02528
G1 X104.096 Y113.492 E.02173
G1 X104.301 Y112.951 E.02157
G1 X104.532 Y112.42 E.02154
G1 X104.785 Y111.906 E.02136
G1 X105.308 Y111 E.03897
G1 X105.626 Y110.525 E.02128
G1 X105.969 Y110.062 E.02149
G1 X106.414 Y109.523 E.02602
G1 X106.808 Y109.093 E.02172
G1 X107.14 Y108.765 E.01737
M204 S6000
G1 X107.461 Y109.09 F30000
G1 F3000
M204 S500
G1 X107.531 Y109.021 E.00367
G1 X107.944 Y108.65 E.02068
G1 X108.728 Y108.033 E.03716
G1 X109.184 Y107.72 E.02057
G1 X109.765 Y107.367 E.02533
G1 X110.68 Y106.896 E.03835
G1 X111.27 Y106.645 E.02386
G1 X112.206 Y106.32 E.0369
G1 X112.859 Y106.145 E.0252
G1 X113.419 Y106.027 E.02129
G1 X114.387 Y105.888 E.03644
G1 X115.046 Y105.84 E.02461
G1 X152.831 Y105.84 E1.40733
G1 X153.214 Y105.888 E.01441
G1 X153.591 Y105.976 E.01441
G1 X153.97 Y106.109 E.01494
G1 X154.307 Y106.268 E.0139
G1 X154.626 Y106.46 E.01387
G1 X155.118 Y106.858 E.02355
G1 X155.499 Y107.283 E.02128
G1 X155.71 Y107.588 E.01381
G1 X155.895 Y107.928 E.01442
G1 X156.039 Y108.271 E.01387
G1 X156.148 Y108.628 E.0139
G1 X156.251 Y109.271 E.02422
G1 X156.259 Y111.622 E.08758
G1 X156.227 Y112.008 E.01444
G1 X156.157 Y112.389 E.01443
G1 X156.045 Y112.761 E.01446
G1 X155.811 Y113.288 E.02145
G1 X155.619 Y113.606 E.01386
G1 X155.188 Y114.132 E.02532
G1 X155.044 Y114.358 E.00999
G1 X154.933 Y114.654 E.01179
G1 X154.894 Y114.918 E.00994
G1 X154.886 Y132.124 E.64085
G1 X154.925 Y132.39 E.00999
G1 X155.037 Y132.688 E.01186
G1 X155.181 Y132.913 E.00995
G1 X155.495 Y133.279 E.01799
G1 X155.81 Y133.764 E.02152
G1 X156.034 Y134.261 E.02031
G1 X156.156 Y134.661 E.01557
G1 X156.225 Y135.025 E.01383
G1 X156.258 Y135.419 E.01472
G1 X156.251 Y137.769 E.08752
G1 X156.161 Y138.371 E.02269
G1 X156.05 Y138.751 E.01473
G1 X155.903 Y139.108 E.0144
G1 X155.719 Y139.449 E.01442
G1 X155.493 Y139.78 E.01493
G1 X155.241 Y140.073 E.01439
G1 X154.95 Y140.348 E.01492
G1 X154.65 Y140.575 E.014
G1 X154.158 Y140.859 E.02115
G1 X153.637 Y141.061 E.02083
G1 X153.08 Y141.184 E.02125
G1 X152.517 Y141.226 E.02101
G1 X115.583 Y141.226 E1.37567
G1 X114.956 Y141.209 E.02336
G1 X114.414 Y141.168 E.02023
G1 X113.41 Y141.025 E.03779
G1 X112.857 Y140.907 E.02106
G1 X112.217 Y140.736 E.02465
G1 X111.69 Y140.565 E.02066
G1 X111.16 Y140.365 E.02109
G1 X110.64 Y140.138 E.02112
G1 X109.767 Y139.687 E.03661
G1 X109.299 Y139.407 E.02031
G1 X108.735 Y139.025 E.02537
G1 X108.292 Y138.691 E.02066
G1 X107.854 Y138.326 E.02124
G1 X107.445 Y137.95 E.02072
G1 X107.06 Y137.561 E.02038
G1 X106.677 Y137.134 E.02136
G1 X106.07 Y136.361 E.0366
G1 X105.757 Y135.906 E.02058
G1 X105.406 Y135.33 E.0251
G1 X105.139 Y134.834 E.02099
G1 X104.727 Y133.933 E.0369
G1 X104.496 Y133.315 E.02458
G1 X104.21 Y132.344 E.03771
G1 X104.087 Y131.792 E.02108
G1 X103.977 Y131.139 E.02464
G1 X103.914 Y130.601 E.0202
G1 X103.864 Y129.498 E.04111
G1 X103.864 Y117.547 E.44514
G1 X103.882 Y116.899 E.02416
G1 X103.976 Y115.922 E.03656
G1 X104.064 Y115.374 E.02064
G1 X104.186 Y114.806 E.02164
G1 X104.354 Y114.18 E.02414
G1 X104.529 Y113.641 E.02113
G1 X104.724 Y113.126 E.02051
G1 X104.948 Y112.609 E.02097
G1 X105.191 Y112.117 E.02043
G1 X105.699 Y111.238 E.03784
G1 X106.002 Y110.786 E.02026
G1 X106.332 Y110.34 E.02065
G1 X106.757 Y109.826 E.02486
G1 X107.14 Y109.408 E.02112
G1 X107.419 Y109.132 E.0146
M204 S6000
G1 X107.75 Y109.45 F30000
G1 F3000
M204 S500
G1 X107.811 Y109.386 E.00331
G1 X108.561 Y108.733 E.03704
G1 X109.099 Y108.33 E.02503
G1 X110.004 Y107.756 E.0399
G1 X110.9 Y107.299 E.03747
G1 X111.824 Y106.926 E.03713
G1 X112.849 Y106.618 E.03985
G1 X113.895 Y106.41 E.03973
G1 X114.561 Y106.33 E.02498
G1 X115.531 Y106.285 E.03615
G1 X152.556 Y106.284 E1.37906
G1 X153.192 Y106.352 E.02381
G1 X153.726 Y106.507 E.02071
G1 X154.224 Y106.747 E.02057
G1 X154.69 Y107.086 E.02148
G1 X155.074 Y107.485 E.02062
G1 X155.431 Y108.026 E.02414
G1 X155.594 Y108.39 E.01485
G1 X155.711 Y108.762 E.01453
G1 X155.806 Y109.543 E.0293
G1 X155.802 Y111.619 E.07732
G1 X155.76 Y112.028 E.01534
G1 X155.646 Y112.519 E.01875
G1 X155.464 Y112.964 E.01793
G1 X155.228 Y113.366 E.01736
G1 X154.95 Y113.714 E.01657
G1 X154.474 Y114.141 E.02382
G1 X154.429 Y114.243 E.00416
G1 X154.429 Y132.811 E.69159
G1 X154.475 Y132.914 E.00421
G1 X154.912 Y133.298 E.02165
G1 X155.191 Y133.631 E.01619
G1 X155.402 Y133.972 E.01494
G1 X155.681 Y134.657 E.02754
G1 X155.774 Y135.108 E.01715
G1 X155.805 Y135.533 E.01588
G1 X155.763 Y138.014 E.09242
G1 X155.663 Y138.464 E.01716
G1 X155.518 Y138.854 E.01549
G1 X155.293 Y139.268 E.01756
G1 X155.066 Y139.579 E.01434
G1 X154.504 Y140.114 E.02888
G1 X153.925 Y140.46 E.02515
G1 X153.279 Y140.68 E.02541
G1 X152.546 Y140.769 E.02751
G1 X115.095 Y140.758 E1.39492
G1 X114.427 Y140.71 E.02492
G1 X113.398 Y140.558 E.03874
G1 X112.831 Y140.43 E.02165
G1 X111.82 Y140.126 E.03932
G1 X110.892 Y139.75 E.03729
G1 X110.002 Y139.295 E.03723
G1 X109.428 Y138.945 E.02505
G1 X108.559 Y138.318 E.03994
G1 X107.795 Y137.651 E.03778
G1 X107.065 Y136.884 E.03941
G1 X106.411 Y136.053 E.03938
G1 X105.835 Y135.157 E.03968
G1 X105.359 Y134.239 E.03851
G1 X104.962 Y133.265 E.03917
G1 X104.655 Y132.241 E.03984
G1 X104.447 Y131.194 E.03973
G1 X104.367 Y130.528 E.025
G1 X104.321 Y129.52 E.03759
G1 X104.321 Y117.534 E.44644
G1 X104.38 Y116.391 E.04261
G1 X104.539 Y115.328 E.04003
G1 X104.782 Y114.345 E.03771
G1 X105.123 Y113.36 E.03883
G1 X105.542 Y112.434 E.03787
G1 X106.068 Y111.509 E.03962
G1 X106.685 Y110.632 E.03994
G1 X107.112 Y110.114 E.02501
G1 X107.708 Y109.493 E.03205
M204 S6000
G1 X108.037 Y109.808 F30000
G1 F3000
M204 S500
G1 X108.107 Y109.735 E.00377
G1 X108.865 Y109.074 E.03746
G1 X109.341 Y108.718 E.02212
G1 X110.207 Y108.166 E.03828
G1 X111.065 Y107.725 E.03593
G1 X112.001 Y107.347 E.03759
G1 X112.985 Y107.054 E.03823
G1 X113.988 Y106.857 E.03808
G1 X114.578 Y106.787 E.02212
G1 X115.528 Y106.742 E.03541
G1 X152.564 Y106.741 E1.37946
G1 X153.053 Y106.788 E.01832
G1 X153.61 Y106.95 E.02159
G1 X153.952 Y107.115 E.01414
G1 X154.359 Y107.402 E.01857
G1 X154.69 Y107.734 E.01746
G1 X155.01 Y108.203 E.02112
G1 X155.181 Y108.584 E.01556
G1 X155.276 Y108.903 E.01243
G1 X155.349 Y109.534 E.02365
G1 X155.347 Y111.574 E.07599
G1 X155.317 Y111.916 E.01275
G1 X155.198 Y112.425 E.01948
G1 X155.072 Y112.73 E.0123
G1 X154.87 Y113.082 E.01511
G1 X154.647 Y113.371 E.0136
G1 X154.241 Y113.745 E.02056
G1 X154.034 Y113.88 E.0092
G1 X153.971 Y113.995 E.00488
G1 X153.971 Y133.052 E.7098
G1 X154.031 Y133.165 E.00476
G1 X154.27 Y133.329 E.0108
G1 X154.559 Y133.588 E.01443
G1 X154.804 Y133.875 E.01407
G1 X154.978 Y134.142 E.01186
G1 X155.232 Y134.742 E.0243
G1 X155.317 Y135.136 E.01501
G1 X155.348 Y135.522 E.01441
G1 X155.319 Y137.907 E.08884
G1 X155.234 Y138.304 E.01512
G1 X155.118 Y138.633 E.013
G1 X154.928 Y138.992 E.01512
G1 X154.689 Y139.321 E.01514
G1 X154.274 Y139.719 E.02145
G1 X153.78 Y140.027 E.02166
G1 X153.235 Y140.225 E.02162
G1 X152.554 Y140.312 E.02554
G1 X115.09 Y140.301 E1.39541
G1 X114.498 Y140.258 E.0221
G1 X113.502 Y140.113 E.03748
G1 X112.966 Y139.993 E.02046
G1 X111.996 Y139.704 E.0377
G1 X111.106 Y139.346 E.03575
G1 X110.206 Y138.886 E.03765
G1 X109.699 Y138.577 E.02212
G1 X108.864 Y137.978 E.03827
G1 X108.091 Y137.302 E.03825
G1 X107.393 Y136.565 E.03779
G1 X106.767 Y135.767 E.03779
G1 X106.216 Y134.906 E.03807
G1 X105.762 Y134.025 E.03691
M73 P39 R11
G1 X105.384 Y133.088 E.03762
G1 X105.091 Y132.104 E.03823
G1 X104.894 Y131.101 E.03808
G1 X104.824 Y130.512 E.02212
G1 X104.778 Y129.523 E.03686
G1 X104.778 Y117.53 E.4467
G1 X104.831 Y116.464 E.03975
G1 X104.982 Y115.444 E.03841
G1 X105.227 Y114.449 E.03818
G1 X105.557 Y113.505 E.03723
G1 X105.961 Y112.618 E.03631
G1 X106.468 Y111.731 E.03806
G1 X107.061 Y110.891 E.03828
G1 X107.439 Y110.433 E.02213
G1 X107.996 Y109.851 E.02999
M204 S6000
G1 X108.326 Y110.167 F30000
G1 F3000
M204 S500
G1 X108.442 Y110.046 E.00624
G1 X109.168 Y109.416 E.0358
G1 X109.583 Y109.105 E.0193
G1 X110.411 Y108.575 E.03661
G1 X111.28 Y108.129 E.0364
G1 X112.177 Y107.769 E.036
G1 X113.12 Y107.491 E.03662
G1 X114.08 Y107.305 E.03641
G1 X114.595 Y107.244 E.01931
G1 X115.552 Y107.198 E.03571
G1 X152.57 Y107.198 E1.37877
G1 X153.019 Y107.244 E.01679
G1 X153.483 Y107.388 E.0181
G1 X153.752 Y107.526 E.01126
G1 X154.099 Y107.778 E.01597
G1 X154.312 Y107.991 E.01123
G1 X154.588 Y108.378 E.01771
G1 X154.767 Y108.779 E.01635
G1 X154.839 Y109.036 E.00993
G1 X154.892 Y109.526 E.01837
G1 X154.891 Y111.54 E.075
G1 X154.873 Y111.81 E.01007
G1 X154.776 Y112.249 E.01676
G1 X154.679 Y112.495 E.00984
G1 X154.469 Y112.862 E.01578
G1 X154.284 Y113.093 E.011
G1 X153.929 Y113.411 E.01776
G1 X153.514 Y113.653 E.01788
G1 X153.514 Y133.403 E.7356
G1 X153.706 Y133.499 E.00799
G1 X153.958 Y133.663 E.01122
G1 X154.26 Y133.934 E.0151
G1 X154.456 Y134.171 E.01144
G1 X154.596 Y134.394 E.00982
G1 X154.783 Y134.826 E.01754
G1 X154.873 Y135.242 E.01583
G1 X154.891 Y135.513 E.01012
G1 X154.875 Y137.799 E.08514
G1 X154.786 Y138.218 E.01596
G1 X154.687 Y138.479 E.01041
G1 X154.564 Y138.715 E.00991
G1 X154.312 Y139.062 E.01596
G1 X153.955 Y139.392 E.0181
G1 X153.537 Y139.64 E.01812
G1 X153.076 Y139.796 E.01812
G1 X152.563 Y139.855 E.01923
G1 X115.085 Y139.844 E1.39592
G1 X114.568 Y139.807 E.0193
G1 X113.605 Y139.667 E.03623
G1 X113.1 Y139.556 E.01927
G1 X112.173 Y139.282 E.03602
G1 X111.27 Y138.92 E.03622
G1 X110.411 Y138.477 E.03601
G1 X109.968 Y138.208 E.0193
G1 X109.169 Y137.637 E.0366
G1 X108.426 Y136.992 E.03663
G1 X107.756 Y136.287 E.03621
G1 X107.155 Y135.524 E.03618
G1 X106.625 Y134.702 E.03643
G1 X106.166 Y133.81 E.03739
G1 X105.806 Y132.912 E.03601
G1 X105.528 Y131.969 E.03661
G1 X105.342 Y131.01 E.03642
G1 X105.281 Y130.495 E.01931
G1 X105.235 Y129.526 E.03612
G1 X105.235 Y117.526 E.44694
G1 X105.283 Y116.536 E.03694
G1 X105.424 Y115.558 E.0368
G1 X105.657 Y114.604 E.03659
G1 X105.97 Y113.7 E.03562
G1 X106.379 Y112.801 E.03678
G1 X106.867 Y111.954 E.03644
G1 X107.437 Y111.152 E.03661
G1 X107.766 Y110.753 E.0193
G1 X108.285 Y110.21 E.02794
; WIPE_START
G1 X108.442 Y110.046 E-.08645
G1 X109.168 Y109.416 E-.36528
G1 X109.583 Y109.105 E-.19692
G1 X109.83 Y108.947 E-.11135
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X117.426 Y109.689 Z.6 F30000
G1 X152.786 Y113.143 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X152.786 Y133.904 E.77329
G3 X153.74 Y134.444 I-.547 J2.08 E.04129
G3 X154.163 Y135.538 I-1.217 J1.099 E.04467
G1 X154.163 Y137.516 E.07368
G3 X152.553 Y139.126 I-1.607 J.004 E.09428
G1 X115.568 Y139.126 E1.37753
G3 X105.963 Y129.521 I.002 J-9.607 E.56193
G1 X105.963 Y117.531 E.44657
G3 X115.568 Y107.926 I9.607 J.002 E.56193
G1 X116.057 Y107.926 E.0182
G1 X152.56 Y107.927 E1.3596
G3 X154.163 Y109.537 I-.003 J1.606 E.09401
G1 X154.163 Y111.515 E.07368
G3 X153.115 Y113.027 I-1.648 J-.023 E.0727
G1 X152.842 Y113.123 E.01077
; WIPE_START
G1 X152.837 Y115.123 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X153.057 Y122.752 Z.6 F30000
G1 X153.483 Y137.505 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X153.71 Y137.575 E.00884
G3 X152.974 Y138.597 I-1.207 J-.094 E.04932
G1 X152.837 Y138.405 E.00878
G2 X153.46 Y137.56 I-1.599 J-1.831 E.03942
; WIPE_START
G1 X153.71 Y137.575 E-.09531
G1 X153.649 Y137.879 E-.11779
G1 X153.606 Y137.991 E-.04538
G1 X153.487 Y138.197 E-.09072
G1 X153.412 Y138.29 E-.04543
G1 X153.234 Y138.45 E-.09068
G1 X152.974 Y138.597 E-.11362
G1 X152.837 Y138.405 E-.08955
G1 X152.971 Y138.274 E-.07153
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X152.98 Y134.461 Z.6 F30000
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X153.118 Y134.529 E.00574
G3 X153.708 Y135.468 I-.578 J1.019 E.04304
G1 X153.491 Y135.543 E.00857
G2 X152.843 Y134.643 I-2.898 J1.402 E.0415
G1 X152.944 Y134.509 E.00623
; WIPE_START
G1 X153.118 Y134.529 E-.06663
G1 X153.329 Y134.679 E-.0983
G1 X153.492 Y134.863 E-.0934
G1 X153.554 Y134.959 E-.04383
G1 X153.65 Y135.178 E-.09057
G1 X153.708 Y135.468 E-.11245
G1 X153.491 Y135.543 E-.08743
G1 X153.293 Y135.185 E-.15544
G1 X153.274 Y135.159 E-.01195
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X152.958 Y137.539 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X152.839 Y137.723 E.00816
G3 X151.053 Y134.482 I-1.665 J-1.196 E.30768
G1 X151.296 Y134.482 E.00905
G3 X152.986 Y137.486 I-.122 J2.046 E.15254
; WIPE_START
G1 X152.839 Y137.723 E-.10597
G1 X152.691 Y137.909 E-.09042
G1 X152.514 Y138.082 E-.09396
G1 X152.32 Y138.23 E-.09256
G1 X152.111 Y138.353 E-.09237
G1 X151.889 Y138.451 E-.09228
G1 X151.656 Y138.522 E-.09228
G1 X151.417 Y138.565 E-.09236
G1 X151.397 Y138.566 E-.00781
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X151.821 Y130.946 Z.6 F30000
G1 X152.851 Y112.439 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X152.83 Y112.409 E.00137
G2 X153.484 Y111.501 I-1.593 J-1.837 E.04206
G1 X153.711 Y111.572 E.00884
G3 X152.967 Y112.601 I-1.22 J-.098 E.04973
G1 X152.886 Y112.488 E.00518
; WIPE_START
G1 X152.83 Y112.409 E-.0368
G1 X153.025 Y112.22 E-.10354
G1 X153.213 Y111.989 E-.1129
G1 X153.371 Y111.738 E-.11295
G1 X153.484 Y111.501 E-.09943
G1 X153.711 Y111.572 E-.0902
G1 X153.65 Y111.878 E-.11854
G1 X153.607 Y111.988 E-.04508
G1 X153.554 Y112.081 E-.04055
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X152.846 Y108.644 Z.6 F30000
G1 Z.2
G1 E.8 F1800
G1 F3000
M204 S500
G1 X152.985 Y108.461 E.00853
G1 X153.134 Y108.538 E.00624
G3 X153.708 Y109.465 I-.595 J1.01 E.04224
G1 X153.49 Y109.54 E.00858
G2 X152.889 Y108.686 I-2.877 J1.388 E.03907
; WIPE_START
G1 X152.985 Y108.461 E-.09282
G1 X153.134 Y108.538 E-.0637
G1 X153.327 Y108.678 E-.09068
G1 X153.487 Y108.855 E-.09071
G1 X153.552 Y108.955 E-.04541
G1 X153.649 Y109.174 E-.0907
G1 X153.708 Y109.465 E-.11294
G1 X153.49 Y109.54 E-.08753
G1 X153.381 Y109.343 E-.08551
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X150.335 Y108.656 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X150.348 Y108.65 E.00056
G3 X151.053 Y108.479 I.827 J1.875 E.02716
G1 X151.296 Y108.479 E.00905
G3 X150.132 Y108.761 I-.122 J2.045 E.43423
G1 X150.281 Y108.684 E.00626
; WIPE_START
G1 X150.348 Y108.65 E-.0285
G1 X150.576 Y108.565 E-.09227
G1 X150.812 Y108.508 E-.09231
M73 P40 R11
G1 X151.053 Y108.479 E-.09234
G1 X151.296 Y108.479 E-.09235
G1 X151.537 Y108.508 E-.09235
G1 X151.773 Y108.565 E-.0923
G1 X152.001 Y108.65 E-.09232
G1 X152.201 Y108.752 E-.08525
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X152.329 Y112.881 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X152.329 Y134.286 E.79726
G2 X150.163 Y134.233 I-1.141 J2.359 E.08317
G2 X149.324 Y138.222 I1.012 J2.296 E.17721
G1 X149.784 Y138.669 E.02392
G1 X115.574 Y138.669 E1.27422
G3 X106.42 Y129.516 I-.004 J-9.15 E.53559
G1 X106.42 Y117.537 E.44616
G3 X115.574 Y108.383 I9.15 J-.004 E.53561
G1 X116.057 Y108.383 E.01799
G1 X149.825 Y108.384 E1.25773
G2 X148.798 Y109.723 I1.678 J2.35 E.06379
G2 X152.329 Y112.754 I2.38 J.799 E.22171
G1 X152.329 Y112.821 E.00249
; WIPE_START
G1 X152.329 Y114.821 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X146.221 Y119.399 Z.6 F30000
G1 X125.495 Y134.933 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F3000
M204 S500
G1 X125.475 Y134.95 E.00095
G3 X125.169 Y135.248 I-.783 J-.496 E.01607
G3 X120.461 Y110.982 I-4.459 J-11.725 E1.62839
G3 X132.492 Y127.86 I.234 J12.56 E.90787
G3 X132.004 Y128.368 I-.866 J-.343 E.0269
G3 X130.973 Y128.172 I-.353 J-.952 E.04105
G3 X130.625 Y127.141 I.498 J-.743 E.04359
G2 X113.956 Y115.426 I-9.92 J-3.602 E1.02711
G1 X115.091 Y116.561 E.05978
G3 X115.828 Y116.024 I6.577 J8.265 E.03396
G3 X119.554 Y114.629 I5.242 J8.323 E.14921
G1 X119.636 Y115.094 E.01761
G2 X121.711 Y115.338 I1.078 J-.221 E.10259
G2 X121.872 Y114.63 I-2.293 J-.895 E.02713
G1 X122.677 Y114.792 E.03057
G3 X128.443 Y119.009 I-2.047 J8.85 E.27345
G3 X129.611 Y122.367 I-8.839 J4.957 E.13312
G1 X129.145 Y122.449 E.01762
G2 X128.902 Y124.524 I.221 J1.078 E.10261
G2 X129.611 Y124.686 I.897 J-2.297 E.02719
G1 X129.434 Y125.549 E.03282
G3 X125.999 Y130.753 I-8.879 J-2.126 E.23702
G3 X121.872 Y132.423 I-5.531 J-7.733 E.16736
G1 X121.791 Y131.958 E.01756
G2 X119.716 Y131.715 I-1.078 J.222 E.10257
G2 X119.554 Y132.424 I2.297 J.897 E.02719
G1 X118.691 Y132.247 E.03282
G3 X113.487 Y128.812 I2.116 J-8.864 E.23705
G3 X111.817 Y124.685 I7.735 J-5.531 E.16735
G1 X112.278 Y124.605 E.01744
G2 X112.526 Y122.529 I-.217 J-1.078 E.10268
G2 X111.815 Y122.367 I-.91 J2.348 E.02724
G1 X111.989 Y121.516 E.03236
G3 X113.748 Y117.904 I9.108 J2.2 E.15078
G1 X112.613 Y116.769 E.05978
G2 X124.335 Y133.436 I8.113 J6.749 E1.0274
G3 X124.771 Y133.4 I.297 J.943 E.01643
G3 X125.505 Y134.009 I-.214 J1.004 E.03695
G3 X125.543 Y134.821 I-.813 J.445 E.03133
G1 X125.518 Y134.878 E.00233
M204 S6000
G1 X125.711 Y135.399 F30000
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X125.573 Y135.524 E.00694
G3 X125.219 Y135.729 I-.853 J-1.063 E.0153
G3 X120.452 Y110.525 I-4.505 J-12.201 E1.68344
G3 X132.916 Y128.031 I.259 J13.006 E.94188
G3 X132.38 Y128.687 I-1.259 J-.482 E.03211
G3 X130.708 Y128.545 I-.737 J-1.241 E.06669
G3 X130.188 Y127.008 I.757 J-1.113 E.06487
G2 X114.641 Y115.464 I-9.484 J-3.469 E.96491
G1 X115.131 Y115.954 E.0258
G3 X118.601 Y114.357 I5.619 J7.64 E.14326
G1 X119.923 Y114.087 E.05026
G1 X120.083 Y114.998 E.03445
G2 X121.345 Y114.991 I.63 J-.124 E.06616
G1 X121.503 Y114.09 E.03408
G1 X122.778 Y114.346 E.04843
G3 X129.88 Y121.4 I-2.068 J9.184 E.39309
G1 X130.153 Y122.736 E.0508
G1 X129.242 Y122.896 E.03447
G2 X129.249 Y124.158 I.124 J.63 E.06613
G1 X130.153 Y124.317 E.0342
G1 X129.88 Y125.651 E.05073
G3 X123.247 Y132.589 I-9.181 J-2.138 E.3751
G3 X121.503 Y132.963 I-4.738 J-17.828 E.06645
G1 X121.344 Y132.055 E.03435
G2 X120.082 Y132.062 I-.63 J.124 E.06617
G1 X119.923 Y132.966 E.0342
G1 X118.588 Y132.693 E.05074
G3 X111.651 Y126.059 I2.138 J-9.181 E.37511
G3 X111.276 Y124.316 I17.865 J-4.746 E.06644
G1 X112.178 Y124.158 E.03409
G2 X112.185 Y122.896 I-.117 J-.632 E.06612
G1 X111.274 Y122.736 E.03447
G1 X111.544 Y121.414 E.05028
G3 X113.141 Y117.944 I9.236 J2.149 E.14325
G1 X112.651 Y117.454 E.02581
G2 X123.277 Y133.288 I8.075 J6.063 E.92907
G2 X124.382 Y132.95 I-57.479 J-189.752 E.04306
G3 X125.905 Y133.787 I.211 J1.419 E.06952
G3 X125.75 Y135.353 I-1.185 J.673 E.06248
; WIPE_START
G1 X125.573 Y135.524 E-.09345
G1 X125.394 Y135.648 E-.08275
G1 X125.219 Y135.729 E-.07335
G1 X124.658 Y135.921 E-.22527
G1 X124.113 Y136.082 E-.21602
G1 X123.936 Y136.125 E-.06914
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X124.606 Y132.675 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.123533
G1 F3000
M204 S500
G1 X124.471 Y132.664 E.00089
; LINE_WIDTH: 0.182897
G2 X123.861 Y132.635 I-.631 J6.967 E.00696
M204 S6000
G1 X124.363 Y132.587 F30000
; LINE_WIDTH: 0.26683
G1 F3000
M204 S500
M73 P41 R11
G1 X123.871 Y132.751 E.00946
G3 X121.878 Y133.222 I-3.618 J-10.855 E.03742
; LINE_WIDTH: 0.218113
G1 X121.436 Y133.287 E.00638
; LINE_WIDTH: 0.192983
G1 X121.33 Y133.301 E.0013
M204 S6000
G1 X121.217 Y132.39 F30000
; FEATURE: Bottom surface
; LINE_WIDTH: 0.5914
G1 F6300
M204 S500
G1 X120.76 Y131.933 E.02889
G2 X120.458 Y132.165 I-.035 J.267 E.01894
G1 X120.422 Y132.37 E.0093
G1 X121.117 Y133.065 E.04394
; WIPE_START
G1 X120.422 Y132.37 E-.37357
G1 X120.458 Y132.165 E-.07911
G1 X120.505 Y132.04 E-.05099
G1 X120.585 Y131.962 E-.04246
G1 X120.63 Y131.942 E-.01842
G1 X120.76 Y131.933 E-.04966
G1 X121.031 Y132.204 E-.14579
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X120.096 Y133.304 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.207954
G1 F3000
M204 S500
G1 X119.647 Y133.239 E.00609
; LINE_WIDTH: 0.267521
G3 X113.442 Y130.023 I1.243 J-9.994 E.13062
G1 X113.146 Y129.677 E.00834
G3 X111.038 Y124.81 I7.711 J-6.231 E.09827
; LINE_WIDTH: 0.230656
G1 X110.972 Y124.392 E.00648
; LINE_WIDTH: 0.200491
G1 X110.939 Y124.143 E.00322
; WIPE_START
G1 X110.972 Y124.392 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X110.937 Y122.909 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.200337
G1 F3000
M204 S500
G1 X110.979 Y122.604 E.00395
; LINE_WIDTH: 0.234518
G1 X111.05 Y122.163 E.00698
; LINE_WIDTH: 0.26827
G3 X112.76 Y117.886 I9.828 J1.451 E.08534
; WIPE_START
G1 X112.412 Y118.413 E-.23988
G1 X112.186 Y118.798 E-.16952
G1 X111.979 Y119.193 E-.16955
G1 X111.785 Y119.628 E-.18105
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X115.073 Y115.573 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.268102
G1 F3000
M204 S500
G3 X119.371 Y113.86 I5.732 J8.129 E.08569
; LINE_WIDTH: 0.233875
G1 X119.79 Y113.793 E.00659
; LINE_WIDTH: 0.200729
G1 X120.096 Y113.751 E.00398
M204 S6000
G1 X120.297 Y113.875 F30000
; FEATURE: Bottom surface
; LINE_WIDTH: 0.5914
G1 F6300
M204 S500
G1 X121.02 Y114.597 E.04566
G3 X120.925 Y115.003 I-1.098 J-.043 E.01875
G3 X120.766 Y115.119 I-.261 J-.189 E.00893
G1 X120.188 Y114.541 E.03654
; WIPE_START
G1 X120.766 Y115.119 E-.31069
G1 X120.854 Y115.082 E-.03607
G1 X120.925 Y115.003 E-.04045
G1 X120.969 Y114.887 E-.04697
G1 X121.02 Y114.597 E-.11205
G1 X120.622 Y114.199 E-.21376
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X121.33 Y113.753 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.201137
G1 F3000
M204 S500
G1 X121.6 Y113.789 E.00351
; LINE_WIDTH: 0.232573
G1 X122.019 Y113.854 E.00655
; LINE_WIDTH: 0.267559
G3 X126.864 Y115.959 I-1.384 J9.813 E.09788
G1 X127.207 Y116.252 E.00826
G3 X130.425 Y122.455 I-6.765 J7.445 E.13064
; LINE_WIDTH: 0.208247
G1 X130.491 Y122.909 E.00617
; WIPE_START
G1 X130.425 Y122.455 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X130.357 Y123.943 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.5914
G1 F6300
M204 S500
G1 X129.636 Y123.221 E.04561
G2 X129.255 Y123.301 I.079 J1.326 E.01746
G2 X129.12 Y123.481 I.112 J.224 E.01044
G1 X129.689 Y124.05 E.03592
M204 S6000
G1 X130.49 Y124.144 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.188744
G1 F3000
M204 S500
G1 X130.477 Y124.242 E.00118
; LINE_WIDTH: 0.214489
G1 X130.411 Y124.684 E.00625
; LINE_WIDTH: 0.265409
G3 X129.858 Y126.912 I-10.853 J-1.514 E.04169
; LINE_WIDTH: 0.292447
G1 X129.795 Y127.11 E.00423
G2 X129.728 Y127.367 I3.049 J.928 E.0054
M204 S6000
G1 X129.821 Y127.413 F30000
; LINE_WIDTH: 0.181223
G1 F3000
M204 S500
G1 X129.726 Y126.936 E.00548
M204 S6000
G1 X129.821 Y127.413 F30000
; LINE_WIDTH: 0.159792
G1 F3000
M204 S500
G1 X129.852 Y127.537 E.00122
; LINE_WIDTH: 0.121876
G1 X129.882 Y127.662 E.00083
; WIPE_START
G1 X129.852 Y127.537 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X122.449 Y125.681 Z.6 F30000
G1 X111.844 Y123.022 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.5914
G1 F6300
M204 S500
G1 X112.306 Y123.484 E.02919
G3 X112.074 Y123.782 I-.268 J.031 E.0187
G1 X111.865 Y123.818 E.00948
G1 X111.173 Y123.126 E.04376
; WIPE_START
G1 X111.865 Y123.818 E-.3721
G1 X112.074 Y123.782 E-.08062
G1 X112.232 Y123.709 E-.06591
G1 X112.295 Y123.617 E-.04243
G1 X112.306 Y123.484 E-.05087
G1 X112.031 Y123.208 E-.14806
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X119.15 Y120.456 Z.6 F30000
G1 X150.08 Y108.5 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.121811
G1 F3000
M204 S500
G1 X150.238 Y108.394 E.00123
; LINE_WIDTH: 0.165491
G1 X150.357 Y108.324 E.00137
; LINE_WIDTH: 0.213982
G1 X150.475 Y108.255 E.00191
; LINE_WIDTH: 0.221846
G1 X150.621 Y108.236 E.00215
; LINE_WIDTH: 0.188282
G1 X150.756 Y108.22 E.00161
; LINE_WIDTH: 0.14939
G1 X151.039 Y108.203 E.00246
G1 X151.585 Y108.219 E.00474
; LINE_WIDTH: 0.18735
G1 X151.728 Y108.236 E.00169
; LINE_WIDTH: 0.22041
G1 X151.863 Y108.252 E.00197
; LINE_WIDTH: 0.238221
G1 X151.875 Y108.254 E.00019
; LINE_WIDTH: 0.26421
G1 X152.01 Y108.278 E.00247
; LINE_WIDTH: 0.312722
G1 X152.145 Y108.302 E.00302
; LINE_WIDTH: 0.340701
G1 X152.726 Y108.425 E.01441
M204 S6000
G1 X152.704 Y108.453 F30000
; LINE_WIDTH: 0.484755
G1 F3000
M204 S500
G2 X151.642 Y108.155 I-5.521 J17.614 E.0397
; WIPE_START
G1 X152.704 Y108.453 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X153.351 Y109.829 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.558062
G1 F3000
M204 S500
G1 X153.667 Y110.003 E.01516
G1 X153.689 Y110.287 E.01196
; LINE_WIDTH: 0.532593
G3 X153.682 Y110.88 I-7.171 J.213 E.02367
; LINE_WIDTH: 0.565484
G3 X153.638 Y111.31 I-7.48 J-.538 E.01839
; WIPE_START
G1 X153.682 Y110.88 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X152.146 Y113.584 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50183
G1 F6300
M204 S500
G1 X151.894 Y113.331 E.01335
G3 X151.328 Y113.415 I-.776 J-3.289 E.02139
G1 X151.94 Y114.027 E.03236
G1 X151.94 Y114.676 E.02427
G1 X150.348 Y113.083 E.08422
; WIPE_START
G1 X151.762 Y114.497 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X148.92 Y109.059 Z.6 F30000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X148.633 Y108.772 E.0152
G1 X147.984 Y108.772 E.02427
G1 X148.539 Y109.328 E.02938
G2 X148.372 Y109.809 I1.935 J.943 E.01911
G1 X147.335 Y108.772 E.05485
G1 X146.686 Y108.772 E.02427
G1 X148.285 Y110.372 E.0846
G2 X148.333 Y111.068 I2.98 J.147 E.02616
G1 X146.037 Y108.772 E.12142
G1 X145.388 Y108.772 E.02427
G1 X151.94 Y115.325 E.34654
G1 X151.94 Y115.974 E.02427
G1 X144.739 Y108.772 E.38086
G1 X144.09 Y108.772 E.02427
G1 X151.94 Y116.623 E.41519
G1 X151.94 Y117.272 E.02427
G1 X143.441 Y108.772 E.44951
G1 X142.792 Y108.772 E.02427
G1 X151.94 Y117.921 E.48383
G1 X151.94 Y118.57 E.02427
G1 X142.143 Y108.772 E.51815
G1 X141.494 Y108.772 E.02427
G1 X151.94 Y119.219 E.55248
G1 X151.94 Y119.868 E.02427
G1 X140.845 Y108.772 E.5868
G1 X140.196 Y108.772 E.02427
G1 X151.94 Y120.517 E.62112
G1 X151.94 Y121.166 E.02427
G1 X139.547 Y108.772 E.65545
G1 X138.898 Y108.772 E.02427
G1 X151.94 Y121.815 E.68977
G1 X151.94 Y122.464 E.02427
G1 X138.249 Y108.772 E.72409
G1 X137.6 Y108.772 E.02427
G1 X151.94 Y123.113 E.75841
G1 X151.94 Y123.762 E.02427
G1 X136.951 Y108.772 E.79273
G1 X136.302 Y108.772 E.02427
G1 X151.94 Y124.411 E.82706
G1 X151.94 Y125.06 E.02427
G1 X135.653 Y108.772 E.86138
G1 X135.004 Y108.772 E.02427
G1 X151.94 Y125.709 E.8957
G1 X151.94 Y126.358 E.02427
G1 X134.355 Y108.772 E.93003
G1 X133.706 Y108.772 E.02427
G1 X151.94 Y127.007 E.96435
G1 X151.94 Y127.656 E.02427
G1 X133.057 Y108.772 E.99867
G1 X132.408 Y108.772 E.02427
G1 X151.94 Y128.305 E1.03299
G1 X151.94 Y128.954 E.02427
G1 X131.759 Y108.772 E1.06732
G1 X131.11 Y108.772 E.02427
G1 X151.94 Y129.603 E1.10164
G1 X151.94 Y130.252 E.02427
G1 X130.461 Y108.772 E1.13596
G1 X129.812 Y108.772 E.02427
G1 X151.94 Y130.901 E1.17028
G1 X151.94 Y131.55 E.02427
G1 X129.163 Y108.772 E1.20461
G1 X128.514 Y108.772 E.02427
G1 X151.94 Y132.199 E1.23893
G1 X151.94 Y132.848 E.02427
G1 X127.865 Y108.772 E1.27325
G1 X127.216 Y108.772 E.02427
G1 X151.94 Y133.497 E1.30757
G1 X151.94 Y133.738 E.00902
G2 X151.442 Y133.647 I-.637 J2.093 E.01898
G1 X126.567 Y108.772 E1.31554
G1 X125.918 Y108.772 E.02427
G1 X150.805 Y133.66 E1.31619
G2 X150.274 Y133.777 I.433 J3.208 E.02037
G1 X125.269 Y108.772 E1.32242
G1 X124.62 Y108.772 E.02427
M73 P42 R11
G1 X149.82 Y133.972 E1.33273
G2 X149.421 Y134.222 I.848 J1.798 E.01765
G1 X132.651 Y117.452 E.8869
G3 X133.178 Y118.629 I-12.521 J6.323 E.04825
G1 X149.081 Y134.531 E.84101
G2 X148.79 Y134.89 I1.357 J1.399 E.01729
G1 X133.527 Y119.626 E.80722
G3 X133.755 Y120.503 I-7.412 J2.395 E.0339
G1 X148.551 Y135.3 E.78253
G2 X148.381 Y135.778 I1.922 J.955 E.01904
G1 X133.915 Y121.313 E.76501
G3 X134.027 Y122.073 I-6.673 J1.366 E.02875
G1 X148.286 Y136.333 E.75412
G2 X148.321 Y137.017 I3.27 J.176 E.02565
G1 X134.085 Y122.781 E.75286
G3 X134.107 Y123.451 I-7.641 J.581 E.02509
G1 X148.729 Y138.073 E.77328
G2 X148.871 Y138.281 I.942 J-.494 E.00943
G1 X148.287 Y138.28 E.02184
G1 X134.096 Y124.089 E.75049
G3 X134.056 Y124.698 I-6.67 J-.134 E.02283
G1 X147.638 Y138.28 E.71828
G1 X146.989 Y138.28 E.02428
G1 X133.993 Y125.284 E.68729
G3 X133.906 Y125.846 I-6.477 J-.714 E.02128
G1 X146.339 Y138.28 E.65755
G1 X145.69 Y138.28 E.02428
G1 X133.798 Y126.388 E.6289
G3 X133.672 Y126.911 I-6.048 J-1.182 E.02012
G1 X145.041 Y138.279 E.60124
M73 P42 R10
G1 X144.392 Y138.279 E.02428
G1 X133.529 Y127.416 E.57449
G3 X133.37 Y127.906 I-5.675 J-1.577 E.01926
G1 X143.743 Y138.279 E.54858
G1 X143.094 Y138.279 E.02428
G1 X133.186 Y128.372 E.52393
G3 X132.91 Y128.745 I-1.781 J-1.031 E.01739
G1 X142.444 Y138.279 E.50421
G1 X141.795 Y138.278 E.02428
G1 X132.552 Y129.035 E.48883
G3 X132.096 Y129.228 I-.815 J-1.287 E.01859
G1 X141.146 Y138.278 E.4786
G1 X140.497 Y138.278 E.02428
G1 X131.245 Y129.026 E.48928
; WIPE_START
G1 X132.659 Y130.44 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X129.318 Y127.748 Z.6 F30000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X139.848 Y138.278 E.55687
M73 P43 R10
G1 X139.198 Y138.278 E.02428
G1 X129.248 Y128.327 E.52622
G3 X129.008 Y128.737 I-2.871 J-1.407 E.01775
G1 X138.549 Y138.277 E.50457
G1 X137.9 Y138.277 E.02428
G1 X128.75 Y129.127 E.48391
G3 X128.475 Y129.502 I-3.783 J-2.484 E.01737
G1 X137.251 Y138.277 E.46409
G1 X136.602 Y138.277 E.02428
G1 X128.185 Y129.861 E.4451
G3 X127.88 Y130.204 I-3.504 J-2.803 E.0172
G1 X135.952 Y138.277 E.4269
G1 X135.303 Y138.276 E.02428
G1 X127.56 Y130.533 E.40951
G3 X127.224 Y130.847 I-3.224 J-3.111 E.01718
G1 X134.654 Y138.276 E.39291
G1 X134.005 Y138.276 E.02428
G1 X126.874 Y131.145 E.37713
G1 X126.5 Y131.42 E.01736
G1 X133.356 Y138.276 E.36258
G1 X132.706 Y138.276 E.02428
G1 X126.124 Y131.694 E.34809
G1 X125.725 Y131.944 E.01761
G1 X132.057 Y138.275 E.33485
G1 X131.408 Y138.275 E.02428
G1 X125.31 Y132.177 E.32249
G3 X125.024 Y132.322 I-1.559 J-2.723 E.012
G1 X125.008 Y132.524 E.00756
G2 X125.202 Y132.638 I.193 J-.108 E.00882
G3 X126.089 Y133.341 I-.571 J1.631 E.04313
G1 X126.346 Y133.795 E.01952
G1 X126.376 Y133.892 E.00381
G1 X130.759 Y138.275 E.23178
G1 X130.11 Y138.275 E.02428
G1 X126.468 Y134.634 E.19257
G3 X126.336 Y135.15 I-1.822 J-.192 E.02001
G1 X129.46 Y138.275 E.16523
G1 X128.811 Y138.274 E.02428
G1 X126.089 Y135.553 E.14395
G3 X125.759 Y135.871 I-1.438 J-1.163 E.01721
G1 X128.162 Y138.274 E.1271
G1 X127.513 Y138.274 E.02428
G1 X125.338 Y136.099 E.11504
G1 X124.854 Y136.264 E.01911
G1 X126.864 Y138.274 E.10627
G1 X126.214 Y138.274 E.02428
G1 X124.356 Y136.415 E.0983
G3 X123.841 Y136.549 I-1.789 J-5.815 E.0199
G1 X125.565 Y138.273 E.0912
G1 X124.916 Y138.273 E.02428
G1 X123.308 Y136.665 E.08504
G3 X122.75 Y136.756 I-.972 J-4.2 E.02116
G1 X124.267 Y138.273 E.08021
G1 X123.618 Y138.273 E.02428
G1 X122.178 Y136.833 E.07614
G3 X121.586 Y136.89 I-.734 J-4.485 E.02224
G1 X122.968 Y138.273 E.0731
G1 X122.319 Y138.272 E.02428
G1 X120.964 Y136.917 E.07169
G3 X120.311 Y136.914 I-.29 J-7.455 E.0244
G1 X121.67 Y138.272 E.07185
G1 X121.021 Y138.272 E.02428
G1 X119.626 Y136.877 E.07378
G3 X118.896 Y136.796 I1.948 J-21.02 E.02744
G1 X120.372 Y138.272 E.07802
G1 X119.722 Y138.272 E.02428
G1 X118.115 Y136.665 E.08499
G3 X117.275 Y136.473 I1.769 J-9.718 E.03223
M73 P44 R10
G1 X119.073 Y138.271 E.09509
G1 X118.424 Y138.271 E.02428
G1 X116.337 Y136.184 E.11038
G3 X115.248 Y135.744 I3.479 J-10.181 E.04393
G1 X117.981 Y138.477 E.14451
; WIPE_START
G1 X116.566 Y137.063 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X119.58 Y130.05 Z.6 F30000
G1 X127.295 Y112.097 Z.6
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X123.971 Y108.772 E.17583
G1 X123.322 Y108.772 E.02427
G1 X125.611 Y111.061 E.12108
G2 X124.614 Y110.714 I-5.134 J13.113 E.03949
G1 X122.673 Y108.772 E.10269
G1 X122.024 Y108.772 E.02427
G1 X123.728 Y110.476 E.09013
G2 X122.918 Y110.316 I-3.571 J15.89 E.03086
G1 X121.375 Y108.772 E.08164
G1 X120.726 Y108.772 E.02427
G1 X122.166 Y110.213 E.07621
G2 X121.458 Y110.154 I-1.031 J8.087 E.02658
G1 X120.077 Y108.772 E.07308
G1 X119.428 Y108.772 E.02427
G1 X120.795 Y110.139 E.07232
G2 X120.157 Y110.151 I-.222 J5.475 E.02386
G1 X118.779 Y108.772 E.07291
G1 X118.13 Y108.772 E.02427
G1 X119.54 Y110.182 E.07459
G2 X118.955 Y110.247 I.441 J6.676 E.022
G1 X117.48 Y108.772 E.078
G1 X116.831 Y108.772 E.02427
G1 X118.393 Y110.333 E.08257
G1 X117.851 Y110.441 E.02065
G1 X116.182 Y108.772 E.08825
G2 X115.539 Y108.778 I-.062 J28.169 E.02405
G1 X117.328 Y110.567 E.09461
G2 X116.823 Y110.71 I1.39 J5.858 E.01966
G1 X114.917 Y108.804 E.1008
G1 X114.325 Y108.861 E.02225
G1 X116.334 Y110.87 E.10624
G2 X115.859 Y111.044 I1.759 J5.514 E.01891
G1 X113.78 Y108.965 E.10996
G2 X113.251 Y109.085 I.577 J3.761 E.0203
G1 X115.399 Y111.234 E.11361
G2 X114.952 Y111.435 I1.982 J5.001 E.01836
G1 X112.76 Y109.244 E.1159
G2 X112.281 Y109.413 I.647 J2.599 E.01905
G1 X114.518 Y111.65 E.1183
G1 X114.098 Y111.88 E.01788
G1 X111.835 Y109.616 E.11969
G2 X111.402 Y109.832 I.914 J2.377 E.01812
G1 X113.697 Y112.128 E.12139
G1 X113.301 Y112.38 E.01758
G1 X110.991 Y110.07 E.12218
G2 X110.594 Y110.322 I1.565 J2.9 E.0176
G1 X112.912 Y112.64 E.12258
G2 X112.538 Y112.915 I2.961 J4.409 E.01736
G1 X110.218 Y110.595 E.12268
G2 X109.866 Y110.893 I1.903 J2.607 E.01724
G1 X112.178 Y113.204 E.12224
G2 X111.829 Y113.504 I3.258 J4.136 E.01721
G1 X109.519 Y111.194 E.12217
G1 X109.202 Y111.527 E.01717
G1 X111.491 Y113.815 E.12102
G2 X111.163 Y114.136 I3.508 J3.915 E.01717
G1 X108.892 Y111.865 E.1201
G1 X108.606 Y112.228 E.01728
G1 X110.845 Y114.468 E.11843
G2 X110.542 Y114.813 I3.798 J3.644 E.0172
G1 X108.333 Y112.604 E.11682
G1 X108.079 Y112.999 E.01756
G1 X110.248 Y115.169 E.11474
G2 X109.966 Y115.535 I4.055 J3.422 E.01731
G1 X107.845 Y113.415 E.11213
G1 X107.625 Y113.843 E.01802
G1 X109.694 Y115.912 E.10942
G1 X109.434 Y116.301 E.0175
G1 X107.435 Y114.303 E.1057
G2 X107.258 Y114.774 I2.393 J1.167 E.01888
G1 X109.188 Y116.704 E.10205
G2 X108.953 Y117.118 I4.607 J2.882 E.01781
G1 X107.111 Y115.276 E.09744
G2 X106.991 Y115.805 I2.731 J.897 E.02032
G1 X108.731 Y117.545 E.09201
G2 X108.52 Y117.984 I4.923 J2.628 E.0182
G1 X106.891 Y116.355 E.08614
G1 X106.835 Y116.947 E.02225
G1 X108.323 Y118.435 E.07873
G1 X108.142 Y118.903 E.01875
G1 X106.809 Y117.57 E.07049
G1 X106.809 Y118.219 E.02427
G1 X107.976 Y119.386 E.06172
G2 X107.825 Y119.884 I5.613 J1.97 E.01947
G1 X106.809 Y118.868 E.05375
G1 X106.809 Y119.517 E.02427
G1 X107.691 Y120.399 E.04665
G2 X107.574 Y120.932 I6.027 J1.596 E.02039
G1 X106.809 Y120.166 E.04049
G1 X106.809 Y120.815 E.02427
G1 X107.477 Y121.484 E.03536
G2 X107.402 Y122.057 I6.514 J1.153 E.02163
G1 X106.809 Y121.464 E.03135
G1 X106.809 Y122.113 E.02427
G1 X107.355 Y122.659 E.02888
G1 X107.328 Y123.281 E.02329
G1 X106.809 Y122.762 E.02747
G1 X106.809 Y123.411 E.02427
G1 X107.326 Y123.929 E.02737
G2 X107.363 Y124.615 I7.863 J-.081 E.0257
G1 X106.809 Y124.06 E.02934
G1 X106.809 Y124.709 E.02427
G1 X107.442 Y125.342 E.0335
G2 X107.575 Y126.124 I9.027 J-1.131 E.02966
G1 X106.809 Y125.358 E.04053
G1 X106.809 Y126.007 E.02427
G1 X107.767 Y126.966 E.0507
G2 X108.056 Y127.903 I16.054 J-4.427 E.03668
G1 X106.809 Y126.656 E.06596
G1 X106.809 Y127.305 E.02427
G1 X108.91 Y129.406 E.1111
; WIPE_START
G1 X107.495 Y127.991 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X106.603 Y127.748 Z.6 F30000
G1 Z.2
G1 E.8 F1800
G1 F6300
M204 S500
G1 X109.163 Y130.308 E.13536
G2 X110.461 Y132.149 I12.154 J-7.195 E.08435
G2 X113.93 Y135.075 I10.228 J-8.605 E.17053
G1 X117.126 Y138.271 E.169
G1 X116.476 Y138.271 E.02428
G1 X106.809 Y128.603 E.51128
G1 X106.809 Y129.252 E.02427
G1 X115.827 Y138.27 E.47695
G1 X115.178 Y138.27 E.02428
G1 X106.818 Y129.91 E.44211
G2 X106.885 Y130.626 I5.035 J-.106 E.02689
G1 X114.46 Y138.202 E.40065
G3 X113.676 Y138.066 I.318 J-4.178 E.02982
G1 X107.022 Y131.412 E.35189
G1 X107.056 Y131.591 E.0068
G1 X107.266 Y132.305 E.02785
G1 X112.775 Y137.814 E.29133
G3 X111.668 Y137.356 I1.951 J-6.281 E.04488
G1 X107.736 Y133.424 E.20792
G1 X107.982 Y133.903 E.02015
G2 X109.203 Y135.54 I8.963 J-5.41 E.07646
G1 X110.706 Y137.043 E.07951
; WIPE_START
M73 P45 R10
G1 X109.292 Y135.629 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X116.906 Y136.164 Z.6 F30000
G1 X149.962 Y138.486 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.121822
G1 F3000
M204 S500
G1 X150.114 Y138.602 E.00123
; LINE_WIDTH: 0.165538
G1 X150.228 Y138.678 E.00137
; LINE_WIDTH: 0.214073
G1 X150.341 Y138.755 E.00191
; LINE_WIDTH: 0.250397
G2 X150.505 Y138.803 I.152 J-.217 E.00293
; LINE_WIDTH: 0.216301
G1 X150.616 Y138.819 E.00159
; LINE_WIDTH: 0.19858
G1 X150.625 Y138.821 E.00012
; LINE_WIDTH: 0.173389
G1 X150.896 Y138.845 E.00288
; LINE_WIDTH: 0.140575
G1 X151.447 Y138.845 E.00439
; LINE_WIDTH: 0.172835
G1 X151.724 Y138.821 E.00294
; LINE_WIDTH: 0.218499
G1 X151.868 Y138.799 E.00209
; LINE_WIDTH: 0.260165
G1 X152.003 Y138.779 E.00242
; LINE_WIDTH: 0.28287
G1 X152.73 Y138.649 E.01444
M204 S6000
G1 X152.708 Y138.618 F30000
; LINE_WIDTH: 0.404229
G1 F3000
M204 S500
G1 X151.552 Y138.898 E.03501
; WIPE_START
G1 X152.708 Y138.618 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X153.638 Y137.314 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.565602
G1 F3000
M204 S500
G2 X153.682 Y136.882 I-7.389 J-.963 E.01846
; LINE_WIDTH: 0.532584
G2 X153.689 Y136.29 I-7.162 J-.38 E.02365
; LINE_WIDTH: 0.557204
G1 X153.667 Y136.007 E.0119
G1 X153.352 Y135.833 E.01511
; CHANGE_LAYER
; Z_HEIGHT: 0.35
; LAYER_HEIGHT: 0.15
; WIPE_START
G1 F3000
G1 X153.667 Y136.007 E-.42504
G1 X153.689 Y136.29 E-.33496
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 2/33
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
; OBJECT_ID: 1237
G1 X153.365 Y113.14
G1 Z.35
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F888.227
M204 S5000
G1 X153.365 Y113.171 E.00074
G1 F720
G1 X153.365 Y113.371 E.00474
G1 X153.365 Y113.771 E.00948
G1 F600
G1 X153.364 Y114.926 E.02738
G1 X153.364 Y117.446 E.05972
G1 X153.364 Y118.766 E.03128
G1 X153.364 Y121.405 E.06256
G1 X153.364 Y122.725 E.03128
G1 X153.364 Y125.365 E.06256
G1 X153.364 Y126.685 E.03128
G1 X153.364 Y129.324 E.06256
G1 X153.365 Y131.964 E.06256
G1 F720
G1 X153.365 Y133.883 E.0455
G1 F877.741
G1 X153.365 Y133.913 E.0007
G1 F5802.592
G1 X153.764 Y134.199 E.01163
G1 F9000
G1 X153.907 Y134.354 E.00501
G3 X154.353 Y135.532 I-1.44 J1.219 E.03044
G1 X154.353 Y137.521 E.04714
G3 X152.558 Y139.316 I-1.797 J-.001 E.06684
G1 X115.566 Y139.316 E.87674
G3 X105.773 Y129.523 I.004 J-9.797 E.36455
G1 X105.773 Y117.529 E.28427
G3 X115.566 Y107.736 I9.797 J.004 E.36456
G1 X152.577 Y107.737 E.87719
G3 X154.353 Y109.532 I-.019 J1.795 E.06638
G1 X154.353 Y111.521 E.04714
G3 X153.417 Y113.11 I-1.886 J-.04 E.04569
; WIPE_START
M204 S10000
G1 X153.365 Y113.171 E-.03035
G1 X153.365 Y113.371 E-.076
G1 X153.365 Y113.771 E-.152
G1 X153.364 Y114.926 E-.43903
G1 X153.364 Y115.091 E-.06262
; WIPE_END
G1 E-.04 F1800
G1 X150.239 Y108.466 Z.75 F30000
G1 Z.35
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X150.01 Y108.582 E.00657
G2 X151.796 Y108.346 I1.165 J1.941 E.31586
G1 X151.833 Y108.14 E.00535
G3 X152.708 Y108.148 I.366 J8.352 E.02236
G3 X153.95 Y109.543 I-.168 J1.4 E.05213
G1 X153.95 Y111.51 E.05025
G3 X153.386 Y112.642 I-1.454 J-.019 E.03341
G1 X152.962 Y112.923 E.01299
G1 X152.962 Y134.129 E.54148
G3 X153.494 Y134.499 I-1.587 J2.854 E.01657
G3 X153.95 Y135.542 I-1.019 J1.067 E.02986
G1 X153.95 Y137.51 E.05025
G3 X152.547 Y138.914 I-1.394 J.009 E.0564
G1 X151.834 Y138.914 E.01821
G1 X151.802 Y138.7 E.00552
G2 X150.547 Y138.7 I-.628 J-2.171 E.33012
G1 X150.515 Y138.914 E.00552
G1 X115.571 Y138.914 E.89228
G3 X106.176 Y129.518 I-.001 J-9.394 E.37684
G1 X106.176 Y117.535 E.30599
G3 X115.571 Y108.139 I9.394 J-.002 E.37687
G1 X150.516 Y108.14 E.89231
G1 X150.553 Y108.346 E.00535
G2 X150.292 Y108.438 I.621 J2.177 E.00706
; WIPE_START
G1 X150.01 Y108.582 E-.1204
G1 X149.801 Y108.727 E-.09668
G1 X149.598 Y108.902 E-.10193
G1 X149.417 Y109.1 E-.10192
G1 X149.26 Y109.318 E-.10194
G1 X149.131 Y109.553 E-.10191
G1 X149.03 Y109.801 E-.10191
G1 X149.007 Y109.886 E-.03331
; WIPE_END
G1 E-.04 F1800
G1 X143.755 Y115.424 Z.75 F30000
G1 X125.287 Y134.898 Z.75
G1 Z.35
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.249 Y134.937 E.00128
G3 X125.076 Y135.082 I-.551 J-.482 E.00538
G3 X120.26 Y111.176 I-4.365 J-11.559 E1.01502
G3 X132.315 Y127.79 I.45 J12.354 E.57398
G3 X131.819 Y128.229 I-.724 J-.317 E.01622
G3 X131.084 Y128.017 I-.143 J-.886 E.01874
G3 X130.807 Y127.196 I.439 J-.605 E.02192
G2 X113.677 Y115.416 I-10.1 J-3.658 E.67001
G1 X114.543 Y116.281 E.02902
G1 X114.826 Y116.564 E.00948
G1 F8596.922
G1 X115.109 Y116.847 E.00948
G1 F3000
G1 X115.246 Y116.984 E.0046
G1 F1800
G3 X119.175 Y115.138 I5.554 J6.716 E.10399
G1 F2760
G1 X119.401 Y115.096 E.00545
G1 F2971.996
G1 X119.422 Y115.092 E.00049
G1 F6748.348
G1 X119.52 Y115.366 E.0069
G1 F9000
G1 X119.61 Y115.545 E.00474
G2 X120.804 Y116.162 I1.139 J-.74 E.03332
G2 X121.612 Y115.789 I-.142 J-1.368 E.0215
G1 X121.816 Y115.545 E.00754
G1 F8312.611
G1 X121.906 Y115.366 E.00473
G1 F5216.205
G1 X122.005 Y115.09 E.00696
G1 F1969.002
G1 X122.025 Y115.094 E.00049
G1 F1800
G3 X129.146 Y122.214 I-1.364 J8.484 E.25499
G1 F1968.887
G1 X129.15 Y122.234 E.00049
G1 F5213.769
G1 X128.873 Y122.334 E.00695
G1 F8311.159
G1 X128.695 Y122.423 E.00474
G1 F9000
G1 X128.555 Y122.531 E.00418
G2 X128.077 Y123.617 I.853 J1.024 E.02915
G2 X128.451 Y124.425 I1.368 J-.142 E.0215
G1 X128.695 Y124.629 E.00754
G1 F8311.193
G1 X128.873 Y124.719 E.00474
G1 F5213.796
G1 X129.15 Y124.818 E.00695
G1 F1968.904
G1 X129.146 Y124.839 E.00049
G1 F1800
G3 X122.025 Y131.959 I-8.462 J-1.342 E.2551
G1 F1969.002
G1 X122.005 Y131.963 E.00049
G1 F5216.205
G1 X121.906 Y131.686 E.00696
G1 F8312.611
G1 X121.816 Y131.508 E.00473
G1 F9000
G1 X121.709 Y131.368 E.00418
G2 X120.647 Y130.889 I-1.025 J.854 E.02858
G2 X119.814 Y131.264 I.116 J1.369 E.02207
G1 X119.61 Y131.508 E.00754
G1 F8312.441
G1 X119.521 Y131.686 E.00473
G1 F5216.071
G1 X119.421 Y131.963 E.00696
G1 F1968.92
G1 X119.401 Y131.959 E.00049
G1 F1800
G3 X112.281 Y124.839 I1.342 J-8.462 E.2551
G1 F1968.92
G1 X112.277 Y124.818 E.00049
G1 F5213.822
G1 X112.553 Y124.719 E.00695
G1 F8311.227
G1 X112.732 Y124.629 E.00474
G1 F9000
G1 X112.976 Y124.425 E.00754
G2 X113.349 Y123.617 I-.995 J-.95 E.02149
G2 X112.732 Y122.423 I-1.357 J-.054 E.03332
G1 X112.553 Y122.334 E.00474
G1 F6749.173
G1 X112.279 Y122.235 E.00691
G1 F2971.59
G1 X112.283 Y122.214 E.00049
G1 F2760
G1 X112.325 Y121.989 E.00544
G1 F1800
G3 X114.171 Y118.059 I8.562 J1.624 E.104
G1 F3000
G1 X114.034 Y117.922 E.0046
G1 F8596.922
G1 X113.751 Y117.639 E.00948
G1 F9000
G1 X113.468 Y117.356 E.00948
G1 X112.603 Y116.49 E.02902
G2 X124.39 Y133.618 I8.113 J7.036 E.67054
G3 X124.739 Y133.588 I.24 J.748 E.00838
G3 X125.339 Y134.101 I-.218 J.861 E.01938
G3 X125.317 Y134.846 I-.641 J.354 E.01854
M204 S10000
G1 X125.532 Y135.232 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X125.422 Y135.335 E.00382
G3 X125.274 Y135.435 I-.694 J-.87 E.00457
G3 X120.251 Y110.773 I-4.565 J-11.912 E1.13085
G3 X132.689 Y127.94 I.458 J12.757 E.63868
G3 X132.248 Y128.48 I-1.033 J-.393 E.01812
G3 X130.85 Y128.346 I-.606 J-1.042 E.03829
G3 X130.421 Y127.079 I.618 J-.915 E.03668
G2 X114.274 Y115.443 I-9.708 J-3.55 E.68462
G1 X115.275 Y116.444 E.03615
G3 X119.685 Y114.633 I5.686 J7.572 E.12304
G1 X119.895 Y115.216 E.01582
G2 X121.515 Y115.255 I.819 J-.352 E.05192
G2 X121.744 Y114.627 I-4.336 J-1.938 E.01709
G1 X122.623 Y114.802 E.0229
G3 X128.658 Y119.446 I-1.926 J8.746 E.20083
G3 X129.612 Y122.496 I-9.379 J4.607 E.08192
G1 X129.023 Y122.708 E.01598
G2 X128.984 Y124.328 I.352 J.819 E.05192
G2 X129.612 Y124.557 I1.939 J-4.338 E.01708
G1 X129.438 Y125.432 E.02279
G3 X124.376 Y131.672 I-8.773 J-1.944 E.2127
G3 X121.744 Y132.425 I-4.244 J-9.857 E.07011
G1 X121.532 Y131.836 E.01598
G2 X119.912 Y131.797 I-.819 J.343 E.05213
G2 X119.683 Y132.425 I4.336 J1.938 E.01708
G1 X118.808 Y132.252 E.02279
G3 X112.568 Y127.189 I1.914 J-8.737 E.21279
G3 X111.814 Y124.557 I9.851 J-4.242 E.07011
G1 X112.403 Y124.345 E.01598
G2 X112.442 Y122.725 I-.352 J-.819 E.05192
G2 X111.82 Y122.498 I-1.924 J4.307 E.01693
G3 X113.631 Y118.088 I9.383 J1.276 E.12304
G1 X112.63 Y117.087 E.03615
G2 X124.273 Y133.232 I8.086 J6.439 E.68483
G3 X124.616 Y133.174 I.339 J.959 E.00892
G3 X125.691 Y133.906 I-.037 J1.211 E.03506
G3 X125.573 Y135.189 I-.963 J.559 E.0351
; WIPE_START
G1 X125.422 Y135.335 E-.07966
G1 X125.274 Y135.435 E-.0679
G1 X125.128 Y135.502 E-.06112
G1 X124.584 Y135.688 E-.21856
G1 X124.049 Y135.846 E-.21186
G1 X123.74 Y135.922 E-.12091
; WIPE_END
G1 E-.04 F1800
G1 X129.095 Y130.484 Z.75 F30000
M73 P46 R10
G1 X150.421 Y108.825 Z.75
G1 Z.35
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.424 Y108.824 E.00007
G3 X151.064 Y108.669 I.751 J1.701 E.0157
G1 X151.285 Y108.669 E.00522
G3 X150.218 Y108.931 I-.11 J1.856 E.25051
G1 X150.368 Y108.853 E.00402
; WIPE_START
M204 S10000
G1 X150.424 Y108.824 E-.0239
G1 X150.631 Y108.747 E-.084
G1 X150.845 Y108.695 E-.08377
G1 X151.064 Y108.669 E-.08377
G1 X151.285 Y108.669 E-.08374
G1 X151.504 Y108.695 E-.08378
G1 X151.718 Y108.747 E-.08377
G1 X151.924 Y108.824 E-.08374
G1 X152.121 Y108.925 E-.08378
G1 X152.264 Y109.021 E-.06574
; WIPE_END
G1 E-.04 F1800
G1 X152.407 Y116.652 Z.75 F30000
G1 X152.798 Y137.436 Z.75
G1 Z.35
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.684 Y137.612 E.00496
G3 X151.064 Y134.672 I-1.51 J-1.085 E.17757
G1 X151.285 Y134.672 E.00524
G3 X152.825 Y137.383 I-.111 J1.856 E.08766
M204 S10000
G1 X153.569 Y137.628 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.381088
G1 F15000
G1 X153.532 Y137.747 E.00267
; LINE_WIDTH: 0.433287
G3 X153.148 Y138.319 I-1.363 J-.5 E.01703
G1 X153.131 Y138.334 E.00056
; LINE_WIDTH: 0.380918
G3 X152.627 Y138.7 I-3.75 J-4.631 E.01329
G1 X152.419 Y138.693 F30000
; LINE_WIDTH: 0.174767
G1 F15000
G1 X153.383 Y138.37 E.00886
G1 X153.569 Y137.628 F30000
; LINE_WIDTH: 0.338399
G1 F15000
G1 X153.601 Y137.501 E.00244
; LINE_WIDTH: 0.290257
G1 X153.625 Y137.356 E.00232
; LINE_WIDTH: 0.242413
G1 X153.648 Y137.21 E.00189
; LINE_WIDTH: 0.217019
G1 X153.65 Y137.199 E.00012
; LINE_WIDTH: 0.200151
G1 X153.665 Y137.051 E.00153
; LINE_WIDTH: 0.168587
G1 X153.681 Y136.896 E.0013
; LINE_WIDTH: 0.136183
G1 X153.689 Y136.301 E.00378
; LINE_WIDTH: 0.158876
G1 X153.667 Y135.999 E.00234
; LINE_WIDTH: 0.201459
G1 X153.647 Y135.853 E.00153
; LINE_WIDTH: 0.242645
G1 X153.625 Y135.693 E.00208
; LINE_WIDTH: 0.278728
G1 X153.611 Y135.622 E.00109
; LINE_WIDTH: 0.306343
G1 X153.598 Y135.551 E.00121
; LINE_WIDTH: 0.345457
G2 X153.563 Y135.402 I-1.46 J.256 E.00294
; LINE_WIDTH: 0.383197
G1 X153.535 Y135.318 E.0019
; LINE_WIDTH: 0.426662
G2 X153.407 Y135.049 I-1.258 J.436 E.00719
; LINE_WIDTH: 0.443042
G2 X153.146 Y134.736 I-1.179 J.719 E.01027
; LINE_WIDTH: 0.401195
G2 X153.008 Y134.619 I-1.959 J2.168 E.00407
; LINE_WIDTH: 0.373964
G1 X152.921 Y134.554 E.00229
; LINE_WIDTH: 0.345102
G1 X152.898 Y134.564 E.00047
; LINE_WIDTH: 0.2993
G1 X152.869 Y134.57 E.00049
; LINE_WIDTH: 0.25245
G1 X152.839 Y134.575 E.00041
; LINE_WIDTH: 0.2056
G1 X152.81 Y134.581 E.00032
; LINE_WIDTH: 0.15875
G1 X152.78 Y134.586 E.00023
; LINE_WIDTH: 0.1119
G1 X152.75 Y134.592 E.00015
; LINE_WIDTH: 0.0769809
G1 X152.738 Y134.56 E.00009
G1 X152.794 Y133.663 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.422
G1 F15000
G1 X152.284 Y134.173 E.01718
G2 X151.883 Y134.023 I-1.334 J2.947 E.01021
G1 X152.619 Y133.286 E.02481
G1 X152.619 Y132.735 E.01313
G1 X151.418 Y133.937 E.04049
G2 X150.857 Y133.947 I-.236 J2.619 E.01339
G1 X152.619 Y132.184 E.05938
G1 X152.619 Y131.633 E.01313
G1 X145.681 Y138.571 E.23377
G1 X146.232 Y138.571 E.01313
G1 X148.591 Y136.213 E.07946
G2 X148.584 Y136.771 I2.68 J.313 E.01333
G1 X146.783 Y138.571 E.06065
G1 X147.335 Y138.571 E.01313
G1 X148.667 Y137.238 E.0449
G2 X148.82 Y137.637 I1.749 J-.441 E.01019
G1 X147.886 Y138.571 E.03147
G1 X148.437 Y138.571 E.01313
G1 X149.019 Y137.989 E.0196
G2 X149.262 Y138.298 I1.346 J-.806 E.00938
G1 X148.814 Y138.746 E.01508
G1 X149.602 Y138.464 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.108742
G1 F15000
G1 X149.763 Y138.619 E.00105
; LINE_WIDTH: 0.139221
G1 X149.862 Y138.705 E.00086
G1 X144.955 Y138.746 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.422
G1 F15000
G1 X152.619 Y131.081 E.25822
G1 X152.619 Y130.53 E.01313
G1 X144.578 Y138.571 E.27092
G1 X144.027 Y138.571 E.01313
G1 X152.619 Y129.979 E.28949
G1 X152.619 Y129.428 E.01313
G1 X143.476 Y138.571 E.30806
G1 X142.925 Y138.571 E.01313
G1 X152.619 Y128.876 E.32664
G1 X152.619 Y128.325 E.01313
G1 X142.373 Y138.571 E.34521
G1 X141.822 Y138.571 E.01313
G1 X152.619 Y127.774 E.36378
G1 X152.619 Y127.222 E.01313
G1 X141.271 Y138.571 E.38236
G1 X140.719 Y138.571 E.01313
G1 X152.619 Y126.671 E.40093
G1 X152.619 Y126.12 E.01313
G1 X140.168 Y138.571 E.4195
G1 X139.617 Y138.571 E.01313
G1 X152.619 Y125.569 E.43807
G1 X152.619 Y125.017 E.01313
G1 X139.066 Y138.571 E.45665
G1 X138.514 Y138.571 E.01313
G1 X152.619 Y124.466 E.47522
G1 X152.619 Y123.915 E.01313
G1 X137.963 Y138.571 E.49379
G1 X137.412 Y138.571 E.01313
G1 X152.619 Y123.363 E.51237
G1 X152.619 Y122.812 E.01313
G1 X136.861 Y138.571 E.53094
G1 X136.309 Y138.571 E.01313
G1 X152.619 Y122.261 E.54951
G1 X152.619 Y121.71 E.01313
G1 X135.758 Y138.571 E.56809
G1 X135.207 Y138.571 E.01313
G1 X152.619 Y121.158 E.58666
G1 X152.619 Y120.607 E.01313
G1 X134.655 Y138.571 E.60523
G1 X134.104 Y138.571 E.01313
G1 X152.619 Y120.056 E.62381
G1 X152.62 Y119.505 E.01313
G1 X133.553 Y138.571 E.64238
G1 X133.002 Y138.571 E.01313
G1 X152.62 Y118.953 E.66095
G1 X152.62 Y118.402 E.01313
G1 X132.45 Y138.571 E.67953
G1 X131.899 Y138.571 E.01313
G1 X152.62 Y117.851 E.6981
G1 X152.62 Y117.299 E.01313
G1 X131.348 Y138.571 E.71667
G1 X130.797 Y138.571 E.01313
G1 X152.62 Y116.748 E.73525
G1 X152.62 Y116.197 E.01313
G1 X130.245 Y138.571 E.75382
G1 X129.694 Y138.571 E.01313
G1 X152.62 Y115.646 E.77239
G1 X152.62 Y115.094 E.01313
G1 X129.143 Y138.571 E.79097
G1 X128.591 Y138.571 E.01313
G1 X152.62 Y114.543 E.80954
G1 X152.62 Y113.992 E.01313
G1 X128.04 Y138.571 E.82811
G1 X127.489 Y138.571 E.01313
G1 X152.62 Y113.441 E.84669
G1 X152.62 Y113.105 E.00799
G1 X152.475 Y113.034 E.00385
G1 X126.938 Y138.571 E.86038
G1 X126.386 Y138.571 E.01313
G1 X151.946 Y113.012 E.86113
G3 X151.279 Y113.127 I-.778 J-2.513 E.01616
G1 X125.835 Y138.571 E.85725
G1 X125.284 Y138.571 E.01313
G1 X150.759 Y113.096 E.85831
G3 X150.318 Y112.986 I.24 J-1.905 E.01086
G1 X124.732 Y138.571 E.86201
G1 X124.181 Y138.571 E.01313
G1 X149.936 Y112.817 E.8677
G3 X149.602 Y112.599 I.746 J-1.511 E.00951
G1 X123.63 Y138.571 E.87502
G1 X123.079 Y138.571 E.01313
G1 X149.308 Y112.342 E.88371
G3 X149.055 Y112.044 I3.927 J-3.598 E.00932
G1 X122.527 Y138.571 E.89375
G1 X121.976 Y138.571 E.01313
G1 X124.468 Y136.079 E.08396
G3 X123.715 Y136.281 I-2.684 J-8.509 E.01858
G1 X121.425 Y138.571 E.07716
G1 X120.874 Y138.571 E.01313
G1 X123.017 Y136.428 E.07222
G3 X122.368 Y136.525 I-1.441 J-7.374 E.01564
G1 X120.322 Y138.571 E.06893
G1 X119.771 Y138.571 E.01313
G1 X121.754 Y136.588 E.06681
G3 X121.17 Y136.621 I-.673 J-6.665 E.01395
G1 X119.22 Y138.571 E.06569
G1 X118.668 Y138.571 E.01313
G1 X120.611 Y136.629 E.06543
G3 X120.074 Y136.614 I-.1 J-6.141 E.01279
G1 X118.117 Y138.571 E.06593
G1 X117.566 Y138.571 E.01313
G1 X119.558 Y136.58 E.0671
G1 X119.062 Y136.524 E.01187
G1 X117.015 Y138.571 E.06899
G1 X116.463 Y138.571 E.01313
G1 X118.587 Y136.448 E.07155
G1 X118.118 Y136.365 E.01134
G1 X115.912 Y138.571 E.07433
G3 X115.371 Y138.561 I-.167 J-5.711 E.0129
G1 X117.663 Y136.269 E.07724
G3 X117.224 Y136.156 I1.063 J-5.074 E.0108
G1 X114.844 Y138.536 E.08018
G3 X114.351 Y138.479 I.053 J-2.609 E.01186
G1 X116.797 Y136.033 E.08241
G1 X116.384 Y135.894 E.01037
G1 X113.869 Y138.41 E.08476
G3 X113.424 Y138.303 I.336 J-2.389 E.01092
G1 X115.982 Y135.745 E.08621
G3 X115.59 Y135.586 I1.617 J-4.571 E.01009
G1 X112.983 Y138.193 E.08783
G1 X112.573 Y138.051 E.01032
G1 X115.206 Y135.418 E.08871
G3 X114.836 Y135.237 I1.851 J-4.251 E.00982
G1 X112.166 Y137.907 E.08996
G1 X111.781 Y137.741 E.00999
G1 X114.475 Y135.047 E.09076
G1 X114.12 Y134.85 E.00966
G1 X111.417 Y137.553 E.09107
G1 X111.054 Y137.365 E.00975
G1 X113.783 Y134.637 E.09194
G1 X113.446 Y134.422 E.00951
G1 X110.71 Y137.158 E.09216
G3 X110.386 Y136.93 I1.427 J-2.379 E.00944
G1 X113.115 Y134.202 E.09193
G1 X112.796 Y133.969 E.0094
G1 X110.064 Y136.701 E.09205
G3 X109.761 Y136.453 I1.148 J-1.71 E.00935
G1 X112.489 Y133.726 E.09188
G3 X112.187 Y133.476 I2.708 J-3.572 E.00933
G1 X109.466 Y136.197 E.09168
G3 X109.184 Y135.927 I1.27 J-1.611 E.0093
G1 X111.893 Y133.219 E.09126
G3 X111.61 Y132.95 I2.93 J-3.37 E.00929
G1 X108.915 Y135.645 E.0908
G3 X108.652 Y135.357 I1.78 J-1.886 E.00931
G1 X111.334 Y132.675 E.09034
G1 X111.064 Y132.394 E.00929
G1 X108.406 Y135.052 E.08954
G1 X108.177 Y134.729 E.00942
G1 X110.806 Y132.101 E.08856
G3 X110.554 Y131.801 I3.311 J-3.032 E.00933
G1 X107.949 Y134.407 E.08779
G1 X107.74 Y134.064 E.00956
G1 X110.309 Y131.495 E.08657
G1 X110.076 Y131.177 E.00939
G1 X107.552 Y133.701 E.08504
G1 X107.364 Y133.337 E.00975
G1 X109.85 Y130.852 E.08375
G3 X109.631 Y130.519 I3.691 J-2.668 E.00948
G1 X107.202 Y132.948 E.08183
G1 X107.044 Y132.554 E.0101
G1 X109.422 Y130.176 E.08012
G3 X109.224 Y129.824 I3.932 J-2.45 E.00964
G1 X106.914 Y132.134 E.07783
G1 X106.788 Y131.708 E.01058
G1 X109.033 Y129.464 E.07561
G1 X108.85 Y129.095 E.0098
G1 X106.687 Y131.258 E.07289
G3 X106.616 Y130.778 I3.333 J-.733 E.01159
G1 X108.681 Y128.713 E.06956
G3 X108.52 Y128.322 I4.388 J-2.031 E.01007
G1 X106.555 Y130.287 E.0662
G1 X106.53 Y129.761 E.01255
G1 X108.369 Y127.922 E.06195
G1 X108.229 Y127.511 E.01035
G1 X106.518 Y129.221 E.05763
G1 X106.518 Y128.67 E.01313
G1 X108.103 Y127.086 E.05339
G3 X107.989 Y126.649 I4.938 J-1.529 E.01076
G1 X106.518 Y128.119 E.04953
G1 X106.518 Y127.568 E.01313
G1 X107.886 Y126.2 E.04608
G3 X107.797 Y125.738 I5.241 J-1.248 E.01122
G1 X106.518 Y127.016 E.04309
G1 X106.518 Y126.465 E.01313
G1 X107.723 Y125.26 E.04059
G3 X107.668 Y124.764 I5.659 J-.882 E.01189
G1 X106.518 Y125.914 E.03873
G1 X106.518 Y125.363 E.01313
G1 X107.63 Y124.251 E.03746
G3 X107.612 Y123.718 I6.092 J-.476 E.01271
G1 X106.518 Y124.811 E.03684
G1 X106.518 Y124.26 E.01313
G1 X107.616 Y123.163 E.03697
G3 X107.645 Y122.583 I6.65 J.041 E.01384
G1 X106.518 Y123.709 E.03794
G1 X106.518 Y123.157 E.01313
G1 X107.703 Y121.973 E.0399
G3 X107.798 Y121.327 I6.577 J.64 E.01558
G1 X106.518 Y122.606 E.04311
G1 X106.518 Y122.055 E.01313
G1 X107.943 Y120.63 E.04801
G3 X108.123 Y119.899 I5.818 J1.043 E.01794
G1 X106.518 Y121.504 E.05406
G1 X106.518 Y120.952 E.01313
G1 X108.383 Y119.087 E.06283
G3 X108.76 Y118.159 I15.432 J5.726 E.02387
G1 X106.518 Y120.401 E.07553
G1 X106.518 Y119.85 E.01313
G1 X109.876 Y116.492 E.11312
; WIPE_START
G1 X108.462 Y117.907 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X111.456 Y119.323 Z.75 F30000
G1 Z.35
G1 E.8 F1800
G1 F15000
G1 X112.918 Y117.86 E.04927
G1 X113.183 Y118.125 E.00893
G1 X113.129 Y118.201 E.00222
G1 X111.383 Y119.946 E.05881
G1 X111.106 Y120.775 E.02083
G1 X112.351 Y119.53 E.04197
G2 X111.963 Y120.469 I6.194 J3.11 E.02424
G1 X110.934 Y121.499 E.03468
G2 X110.813 Y122.17 I7.791 J1.744 E.01626
G1 X111.724 Y121.26 E.03068
G2 X111.574 Y121.961 I6.911 J1.842 E.01708
G1 X110.755 Y122.779 E.02758
G2 X110.722 Y123.364 I4.234 J.535 E.01396
G1 X111.444 Y122.642 E.02432
G1 X111.429 Y122.721 E.00191
G1 X111.787 Y122.85 E.00908
G1 X110.727 Y123.91 E.03573
G2 X110.769 Y124.419 I3.712 J-.053 E.01217
G1 X112.193 Y122.996 E.04796
G3 X112.512 Y123.228 I-.272 J.708 E.00951
G1 X110.819 Y124.921 E.05702
G1 X110.904 Y125.387 E.01129
G1 X111.51 Y124.781 E.02041
G1 X111.601 Y125.241 E.01117
G1 X110.994 Y125.849 E.02046
G2 X111.11 Y126.284 I3.219 J-.628 E.01073
G1 X111.7 Y125.694 E.01986
G2 X111.818 Y126.127 I2.829 J-.544 E.0107
G1 X111.247 Y126.698 E.01927
G2 X111.385 Y127.112 I3.072 J-.798 E.01039
G1 X111.955 Y126.541 E.01922
G2 X112.098 Y126.95 I2.036 J-.48 E.01033
G1 X111.544 Y127.503 E.01864
G1 X111.725 Y127.873 E.00982
G1 X112.269 Y127.33 E.0183
G1 X112.44 Y127.711 E.00993
G1 X111.906 Y128.244 E.01796
G2 X112.109 Y128.592 I2 J-.929 E.00962
G1 X112.631 Y128.07 E.0176
G2 X112.841 Y128.411 I2.298 J-1.179 E.00956
G1 X112.317 Y128.935 E.01765
G2 X112.539 Y129.265 I1.906 J-1.044 E.00948
G1 X113.059 Y128.745 E.01751
G2 X113.285 Y129.071 I1.678 J-.92 E.00946
G1 X112.774 Y129.581 E.0172
G2 X113.013 Y129.893 I1.82 J-1.15 E.00938
G1 X113.531 Y129.375 E.01745
G1 X113.778 Y129.679 E.00934
G1 X113.274 Y130.184 E.01701
G1 X113.534 Y130.475 E.0093
G1 X114.049 Y129.96 E.01735
G1 X114.324 Y130.236 E.00929
G1 X113.815 Y130.745 E.01715
G1 X114.101 Y131.011 E.00929
G1 X114.61 Y130.502 E.01716
G1 X114.914 Y130.749 E.00934
M73 P47 R10
G1 X114.399 Y131.264 E.01737
G1 X114.71 Y131.505 E.00936
G1 X115.219 Y130.995 E.01715
G2 X115.543 Y131.223 I1.616 J-1.962 E.00944
G1 X115.025 Y131.74 E.01745
G1 X115.362 Y131.955 E.00951
G1 X115.879 Y131.437 E.01744
G2 X116.231 Y131.637 I1.456 J-2.161 E.00965
G1 X115.699 Y132.169 E.01795
G2 X116.06 Y132.36 I1.218 J-1.87 E.00973
G1 X116.596 Y131.824 E.01806
G2 X116.964 Y132.007 I1.363 J-2.274 E.0098
G1 X116.423 Y132.547 E.0182
G2 X116.806 Y132.716 I1.109 J-1.999 E.00998
G1 X117.352 Y132.17 E.0184
G2 X117.766 Y132.307 I1.098 J-2.622 E.0104
G1 X117.199 Y132.874 E.01912
G2 X117.607 Y133.018 I.984 J-2.15 E.01032
G1 X118.181 Y132.444 E.01934
G2 X118.618 Y132.558 I.948 J-2.742 E.01078
G1 X118.03 Y133.145 E.01979
G2 X118.469 Y133.258 I.834 J-2.329 E.0108
G1 X119.073 Y132.653 E.02037
G1 X119.533 Y132.745 E.01117
G1 X118.927 Y133.351 E.02044
G2 X119.398 Y133.431 I.818 J-3.387 E.0114
G1 X121.063 Y131.767 E.05609
G3 X121.268 Y132.113 I-.545 J.556 E.0097
G1 X119.902 Y133.479 E.04601
G1 X120.42 Y133.512 E.01237
G1 X121.413 Y132.519 E.03346
G1 X121.521 Y132.818 E.00759
G1 X121.7 Y132.783 E.00435
G1 X120.977 Y133.507 E.02438
G2 X121.554 Y133.481 I.149 J-3.157 E.01378
G1 X122.388 Y132.646 E.02812
G2 X123.1 Y132.486 I-1.419 J-7.961 E.01738
G1 X122.18 Y133.406 E.03098
G2 X122.86 Y133.277 I-.363 J-3.772 E.01652
G1 X123.911 Y132.226 E.0354
G2 X124.877 Y131.811 I-2.514 J-7.183 E.02508
G1 X123.34 Y133.348 E.0518
; WIPE_START
G1 X124.754 Y131.934 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.006 Y134.542 Z.75 F30000
G1 Z.35
G1 E.8 F1800
G1 F15000
G1 X131.555 Y128.992 E.18698
G3 X131.107 Y128.889 I.154 J-1.697 E.01099
G1 X126.079 Y133.914 E.16935
G2 X125.878 Y133.567 I-1.617 J.701 E.00957
G1 X130.756 Y128.689 E.16433
G3 X130.444 Y128.45 I.785 J-1.344 E.00939
G1 X125.641 Y133.253 E.16182
G2 X125.329 Y133.013 I-1.389 J1.488 E.00938
G1 X130.206 Y128.136 E.16432
G3 X130.057 Y127.734 I1.532 J-.796 E.01025
G1 X124.925 Y132.866 E.17291
G2 X124.389 Y132.851 I-.313 J1.567 E.01283
G1 X130.04 Y127.2 E.19039
G1 X130.272 Y126.417 E.01945
G1 X128.994 Y127.694 E.04305
G1 X129.357 Y126.887 E.02109
G1 X129.41 Y126.727 E.00401
G1 X130.464 Y125.673 E.0355
G2 X130.598 Y124.988 I-4.915 J-1.318 E.01665
G1 X129.673 Y125.913 E.03116
G2 X129.833 Y125.201 I-7.803 J-2.132 E.01738
G1 X130.662 Y124.373 E.02791
G2 X130.704 Y123.779 I-4.314 J-.606 E.01419
G1 X129.97 Y124.514 E.02475
G1 X130.005 Y124.336 E.00432
G1 X129.706 Y124.226 E.00759
G1 X130.699 Y123.233 E.03347
G1 X130.666 Y122.715 E.01237
G1 X129.302 Y124.079 E.04595
G3 X128.954 Y123.876 I.19 J-.725 E.00972
G1 X130.614 Y122.216 E.05593
G1 X130.539 Y121.739 E.01149
G1 X129.932 Y122.347 E.02046
G1 X129.84 Y121.887 E.01117
G1 X130.444 Y121.283 E.02034
G1 X130.333 Y120.843 E.01082
G1 X129.745 Y121.431 E.01982
G2 X129.632 Y120.992 I-4.264 J.861 E.01079
G1 X130.204 Y120.42 E.01928
G1 X130.061 Y120.012 E.0103
G1 X129.502 Y120.571 E.01881
G1 X129.357 Y120.165 E.01027
G1 X129.908 Y119.614 E.01857
G2 X129.737 Y119.234 I-4.237 J1.676 E.00994
G1 X129.194 Y119.777 E.01829
G2 X129.011 Y119.409 I-2.457 J.995 E.0098
G1 X129.551 Y118.868 E.01822
G1 X129.35 Y118.518 E.00962
G1 X128.824 Y119.044 E.01774
G2 X128.624 Y118.692 I-2.359 J1.103 E.00965
G1 X129.149 Y118.168 E.01768
G2 X128.929 Y117.837 I-2.511 J1.432 E.00948
G1 X128.409 Y118.356 E.01749
G2 X128.183 Y118.031 I-3.255 J2.03 E.00944
G1 X128.691 Y117.523 E.01713
G1 X128.451 Y117.212 E.00936
G1 X127.943 Y117.72 E.01711
G2 X127.691 Y117.421 I-3.008 J2.285 E.00932
G1 X128.198 Y116.914 E.01709
G1 X127.932 Y116.628 E.00929
G1 X127.424 Y117.136 E.01712
G1 X127.15 Y116.859 E.00929
G1 X127.664 Y116.346 E.0173
G1 X127.379 Y116.079 E.00929
G1 X126.863 Y116.594 E.01736
G1 X126.57 Y116.336 E.00931
G1 X127.075 Y115.831 E.01701
G1 X126.771 Y115.584 E.00934
G1 X126.253 Y116.103 E.01747
G1 X125.934 Y115.87 E.0094
G1 X126.455 Y115.349 E.01757
G2 X126.122 Y115.13 I-1.754 J2.311 E.00949
G1 X125.599 Y115.653 E.01762
G1 X125.251 Y115.451 E.00961
G1 X125.779 Y114.922 E.01781
G2 X125.431 Y114.719 I-1.278 J1.797 E.00962
G1 X124.897 Y115.253 E.01797
G1 X124.517 Y115.082 E.00993
G1 X125.06 Y114.538 E.0183
G1 X124.69 Y114.358 E.00982
G1 X124.137 Y114.911 E.01864
G2 X123.735 Y114.761 I-1.157 J2.497 E.01022
G1 X124.298 Y114.198 E.01898
G2 X123.885 Y114.06 I-1.209 J2.928 E.01039
G1 X123.31 Y114.635 E.01938
G1 X122.877 Y114.516 E.01069
G1 X123.47 Y113.923 E.01998
G2 X123.028 Y113.814 I-.815 J2.353 E.01086
G1 X122.428 Y114.414 E.02021
G1 X121.968 Y114.323 E.01117
G1 X122.58 Y113.711 E.0206
G2 X122.101 Y113.639 I-.632 J2.573 E.01156
G1 X120.413 Y115.327 E.05687
G3 X120.183 Y115.006 I.351 J-.494 E.00959
G1 X121.615 Y113.574 E.04825
G2 X121.088 Y113.549 I-.395 J2.846 E.01259
G1 X120.037 Y114.6 E.03541
G1 X119.908 Y114.242 E.00908
G1 X119.829 Y114.257 E.00191
G1 X120.547 Y113.539 E.0242
G1 X119.968 Y113.567 E.01383
G1 X119.148 Y114.387 E.02764
G2 X118.447 Y114.537 I1.141 J7.059 E.01708
G1 X119.359 Y113.625 E.03073
G2 X118.683 Y113.749 I.568 J4.982 E.01638
G1 X117.656 Y114.776 E.0346
G2 X116.717 Y115.164 I2.17 J6.582 E.02424
G1 X117.948 Y113.933 E.04149
G2 X117.117 Y114.213 I1.108 J4.668 E.02092
G1 X115.388 Y115.942 E.05826
G1 X115.312 Y115.996 E.00222
G1 X115.047 Y115.731 E.00893
G1 X116.51 Y114.269 E.04927
; WIPE_START
G1 X115.095 Y115.683 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X120.703 Y115.588 Z.75 F30000
G1 Z.35
G1 E.8 F1800
G1 F15000
G1 X121.508 Y114.783 E.02712
; WIPE_START
G1 X120.703 Y115.588 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.672 Y120.345 Z.75 F30000
G1 X129.599 Y122.679 Z.75
G1 Z.35
G1 E.8 F1800
G1 F15000
G1 X128.656 Y123.622 E.03177
; WIPE_START
G1 X129.599 Y122.679 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.002 Y127.546 Z.75 F30000
G1 Z.35
G1 E.8 F1800
G1 F15000
G1 X148.85 Y111.697 E.53395
G3 X148.691 Y111.305 I1.564 J-.863 E.01011
G1 X133.468 Y126.528 E.51288
G2 X133.615 Y125.83 I-7.942 J-2.034 E.017
G1 X148.591 Y110.854 E.50458
G3 X148.577 Y110.316 I2.249 J-.327 E.01284
G1 X133.701 Y125.192 E.50119
G2 X133.772 Y124.57 I-5.018 J-.887 E.01493
G1 X148.742 Y109.6 E.50435
G3 X149.369 Y108.647 I2.528 J.98 E.02739
G1 X149.265 Y108.526 E.0038
G1 X133.808 Y123.983 E.52075
G2 X133.816 Y123.424 I-6.392 J-.367 E.01332
G1 X148.757 Y108.483 E.50337
G1 X148.205 Y108.483 E.01314
G1 X133.801 Y122.887 E.48529
G2 X133.767 Y122.37 I-5.923 J.137 E.01234
G1 X147.654 Y108.483 E.46788
G1 X147.102 Y108.483 E.01314
G1 X133.713 Y121.873 E.4511
G2 X133.642 Y121.393 I-5.498 J.574 E.01156
G1 X146.551 Y108.484 E.43493
G1 X146 Y108.484 E.01314
G1 X133.555 Y120.928 E.41926
G2 X133.456 Y120.476 I-5.225 J.918 E.01102
G1 X145.448 Y108.484 E.40404
G1 X144.897 Y108.484 E.01314
G1 X133.343 Y120.037 E.38925
G1 X133.22 Y119.61 E.0106
G1 X144.345 Y108.484 E.37484
G1 X143.794 Y108.484 E.01314
G1 X133.081 Y119.197 E.36094
G2 X132.932 Y118.795 I-4.68 J1.506 E.01022
G1 X143.242 Y108.484 E.34739
G1 X142.691 Y108.485 E.01314
G1 X132.773 Y118.403 E.33415
G1 X132.605 Y118.019 E.00997
G1 X142.14 Y108.485 E.32123
G1 X141.588 Y108.485 E.01314
G1 X132.424 Y117.649 E.30875
G2 X132.235 Y117.287 I-4.246 J1.989 E.00974
G1 X141.037 Y108.485 E.29655
G1 X140.485 Y108.485 E.01314
G1 X132.038 Y116.933 E.28461
G1 X131.83 Y116.589 E.00956
G1 X139.934 Y108.485 E.27303
G1 X139.382 Y108.486 E.01314
G1 X131.609 Y116.259 E.26191
G1 X131.383 Y115.934 E.00944
G1 X138.831 Y108.486 E.25095
G1 X138.28 Y108.486 E.01314
G1 X131.155 Y115.61 E.24004
G1 X130.912 Y115.303 E.00935
G1 X137.728 Y108.486 E.22966
G1 X137.177 Y108.486 E.01314
G1 X130.663 Y115 E.21947
G1 X130.406 Y114.706 E.00931
G1 X136.625 Y108.486 E.20955
G1 X136.074 Y108.486 E.01314
G1 X130.137 Y114.423 E.20002
G2 X129.862 Y114.147 I-3.304 J3.01 E.00929
G1 X135.522 Y108.487 E.1907
G1 X134.971 Y108.487 E.01314
G1 X129.581 Y113.877 E.1816
G1 X129.288 Y113.619 E.00931
G1 X134.42 Y108.487 E.1729
G1 X133.868 Y108.487 E.01314
G1 X128.985 Y113.37 E.16452
G1 X128.674 Y113.13 E.00936
G1 X133.317 Y108.487 E.15642
G1 X132.765 Y108.487 E.01314
G1 X128.363 Y112.89 E.14832
G2 X128.037 Y112.664 I-1.994 J2.535 E.00945
G1 X132.214 Y108.488 E.14072
G1 X131.662 Y108.488 E.01314
G1 X127.706 Y112.444 E.1333
G1 X127.363 Y112.236 E.00956
G1 X131.111 Y108.488 E.12626
G1 X130.56 Y108.488 E.01314
G1 X127.011 Y112.037 E.11956
G2 X126.651 Y111.846 I-2.37 J4.033 E.00972
G1 X130.008 Y108.488 E.11312
G1 X129.457 Y108.488 E.01314
G1 X126.282 Y111.663 E.10697
G2 X125.9 Y111.494 I-2.152 J4.337 E.00996
G1 X128.905 Y108.488 E.10125
G1 X128.354 Y108.489 E.01314
G1 X125.509 Y111.333 E.09584
G2 X125.109 Y111.182 I-1.929 J4.501 E.01019
G1 X127.802 Y108.489 E.09074
G1 X127.251 Y108.489 E.01314
G1 X124.698 Y111.042 E.08602
G2 X124.273 Y110.916 I-1.656 J4.811 E.01057
G1 X126.7 Y108.489 E.08177
G1 X126.148 Y108.489 E.01314
G1 X123.836 Y110.802 E.07791
G2 X123.387 Y110.699 I-1.397 J5.098 E.01097
G1 X125.597 Y108.489 E.07445
G1 X125.045 Y108.49 E.01314
G1 X122.925 Y110.61 E.07145
G1 X122.447 Y110.536 E.01151
G1 X124.494 Y108.49 E.06896
G1 X123.942 Y108.49 E.01314
G1 X121.951 Y110.481 E.06709
G2 X121.438 Y110.443 I-.69 J5.865 E.01227
G1 X123.391 Y108.49 E.06581
G1 X122.84 Y108.49 E.01314
G1 X120.897 Y110.433 E.06544
G1 X120.347 Y110.431 E.0131
G1 X122.288 Y108.49 E.06539
G1 X121.737 Y108.49 E.01314
G1 X119.768 Y110.459 E.06632
G2 X119.16 Y110.516 I.27 J6.172 E.01456
G1 X121.185 Y108.491 E.06823
G1 X120.634 Y108.491 E.01314
G1 X118.517 Y110.608 E.07132
G2 X117.83 Y110.743 I3.931 J21.751 E.01667
G1 X120.082 Y108.491 E.07588
G1 X119.531 Y108.491 E.01314
G1 X117.086 Y110.936 E.08238
G2 X116.274 Y111.196 I2.573 J9.417 E.02031
G1 X118.98 Y108.491 E.09114
G1 X118.428 Y108.491 E.01314
G1 X115.346 Y111.573 E.10383
G2 X114.229 Y112.139 I5.751 J12.74 E.02984
G1 X117.877 Y108.492 E.12289
G1 X117.325 Y108.492 E.01314
G1 X106.518 Y119.299 E.3641
G1 X106.518 Y118.747 E.01313
G1 X116.774 Y108.492 E.34552
G1 X116.222 Y108.492 E.01314
G1 X106.518 Y118.196 E.32694
G1 X106.518 Y117.645 E.01313
G1 X115.671 Y108.492 E.30836
G1 X115.118 Y108.494 E.01317
G1 X106.541 Y117.071 E.28898
G3 X106.588 Y116.473 I3.148 J-.054 E.01432
G1 X114.509 Y108.552 E.26687
G2 X113.867 Y108.643 I.314 J4.536 E.01546
G1 X106.68 Y115.829 E.24212
G1 X106.855 Y115.103 E.01779
G1 X113.134 Y108.824 E.21154
G2 X112.308 Y109.098 I1.021 J4.455 E.02075
G1 X107.127 Y114.28 E.17456
G3 X107.602 Y113.253 I6.719 J2.487 E.02697
G1 X111.299 Y109.557 E.12453
G2 X109.051 Y111.253 I4.069 J7.729 E.06738
G1 X107.925 Y112.379 E.03794
; WIPE_START
G1 X109.051 Y111.253 E-.60518
G1 X109.346 Y110.972 E-.15482
; WIPE_END
G1 E-.04 F1800
G1 X110.818 Y118.461 Z.75 F30000
G1 X111.97 Y124.321 Z.75
G1 Z.35
G1 E.8 F1800
G1 F15000
G1 X112.775 Y123.516 E.02712
; WIPE_START
G1 X111.97 Y124.321 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X117.906 Y129.119 Z.75 F30000
G1 X120.812 Y131.467 Z.75
G1 Z.35
G1 E.8 F1800
G1 F15000
G1 X119.866 Y132.412 E.03184
; WIPE_START
G1 X120.812 Y131.467 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.788 Y126.719 Z.75 F30000
G1 X149.704 Y108.511 Z.75
G1 Z.35
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.102601
G1 F15000
G1 X149.84 Y108.394 E.00077
G1 X149.928 Y108.37 E.00039
; WIPE_START
G1 X149.84 Y108.394 E-.25592
G1 X149.704 Y108.511 E-.50408
; WIPE_END
G1 E-.04 F1800
G1 X153.514 Y108.833 Z.75 F30000
G1 Z.35
G1 E.8 F1800
; LINE_WIDTH: 0.259698
M73 P47 R9
G1 F15000
G2 X152.449 Y108.349 I-8.72 J17.801 E.01627
G1 X152.553 Y108.349 F30000
; LINE_WIDTH: 0.344592
G1 F15000
G3 X153.008 Y108.624 I-2.397 J4.488 E.01015
; LINE_WIDTH: 0.3971
G3 X153.141 Y108.731 I-.886 J1.234 E.00382
; LINE_WIDTH: 0.441344
G3 X153.431 Y109.088 I-.912 J1.038 E.01154
; LINE_WIDTH: 0.422222
G3 X153.536 Y109.32 I-1.926 J1.015 E.00607
; LINE_WIDTH: 0.382091
G1 X153.563 Y109.4 E.0018
; LINE_WIDTH: 0.344817
G3 X153.598 Y109.552 I-1.433 J.41 E.00298
; LINE_WIDTH: 0.305565
G1 X153.612 Y109.621 E.00118
; LINE_WIDTH: 0.278474
G1 X153.625 Y109.691 E.00107
; LINE_WIDTH: 0.242649
G1 X153.647 Y109.851 E.00208
; LINE_WIDTH: 0.201459
G1 X153.667 Y109.997 E.00153
; LINE_WIDTH: 0.158876
G1 X153.689 Y110.299 E.00234
; LINE_WIDTH: 0.136183
G1 X153.681 Y110.894 E.00378
; LINE_WIDTH: 0.168587
G1 X153.665 Y111.049 E.0013
; LINE_WIDTH: 0.200151
G1 X153.65 Y111.197 E.00153
; LINE_WIDTH: 0.217019
G1 X153.648 Y111.208 E.00012
; LINE_WIDTH: 0.242594
G1 X153.624 Y111.355 E.00191
; LINE_WIDTH: 0.290803
G1 X153.6 Y111.501 E.00235
; LINE_WIDTH: 0.317755
G1 X153.597 Y111.518 E.0003
; LINE_WIDTH: 0.343342
G1 X153.568 Y111.631 E.00222
; LINE_WIDTH: 0.381754
G1 X153.536 Y111.735 E.00233
; LINE_WIDTH: 0.434586
G3 X153.149 Y112.317 I-1.377 J-.495 E.01736
; LINE_WIDTH: 0.401894
G1 X153.024 Y112.419 E.00364
; LINE_WIDTH: 0.374114
G1 X152.916 Y112.506 E.00289
; LINE_WIDTH: 0.348435
G1 X152.772 Y112.799 E.00631
; CHANGE_LAYER
; Z_HEIGHT: 0.464804
; LAYER_HEIGHT: 0.114805
; WIPE_START
G1 F15000
G1 X152.916 Y112.506 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 3/33
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
G17
G3 Z.75 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
M204 S250
G1 X153.562 Y113.02
M204 S10000
G1 Z.465
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2636.392
M204 S5000
G1 X153.562 Y113.058 E.0007
G1 F2280
G1 X153.561 Y114.926 E.03456
G2 X153.56 Y116.126 I600 J.83 E.02219
G1 X153.562 Y133.995 E.33045
G1 F2636.002
G1 X153.562 Y134.033 E.0007
G1 F5813.298
G1 X153.765 Y134.2 E.00485
G1 F9000
G1 X153.923 Y134.361 E.00418
G3 X154.353 Y135.532 I-1.402 J1.179 E.02354
G1 X154.353 Y137.521 E.03678
G3 X152.558 Y139.316 I-1.797 J-.001 E.05215
G1 X115.566 Y139.316 E.68409
G3 X105.773 Y129.523 I.004 J-9.797 E.28445
G1 X105.773 Y117.529 E.22181
G3 X115.566 Y107.736 I9.797 J.004 E.28445
G1 X152.586 Y107.738 E.68462
G3 X154.353 Y109.532 I-.046 J1.813 E.05148
G1 X154.353 Y111.521 E.03678
G3 X153.611 Y112.985 I-1.831 J-.008 E.03148
; WIPE_START
M204 S10000
G1 X153.562 Y113.058 E-.03329
G1 X153.561 Y114.926 E-.71004
G1 X153.561 Y114.97 E-.01668
; WIPE_END
G1 E-.04 F1800
G1 X150.234 Y108.46 Z.865 F30000
G1 Z.465
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X150.002 Y108.582 E.00522
G2 X151.849 Y108.358 I1.172 J1.944 E.24561
G1 X151.887 Y108.148 E.00425
G3 X152.707 Y108.155 I.344 J7.847 E.01633
G3 X153.943 Y109.543 I-.167 J1.393 E.04041
G1 X153.943 Y111.51 E.03914
G3 X153.491 Y112.547 I-1.426 J-.005 E.02315
G1 X153.152 Y112.826 E.00873
G1 X153.152 Y134.226 E.42578
G3 X153.763 Y134.847 I-1.172 J1.765 E.01746
G3 X153.943 Y135.543 I-1.269 J.699 E.01445
G1 X153.943 Y137.51 E.03914
G3 X152.547 Y138.906 I-1.386 J.01 E.04372
G1 X151.898 Y138.906 E.01291
G1 X151.865 Y138.688 E.00438
G2 X150.137 Y138.549 I-.696 J-2.159 E.24822
G1 X150.487 Y138.703 E.0076
G1 X150.444 Y138.906 E.00412
G1 X115.571 Y138.906 E.69385
G3 X106.184 Y129.518 I-.001 J-9.387 E.29341
G1 X106.184 Y117.534 E.23844
G3 X115.571 Y108.147 I9.387 J-.001 E.29341
G1 X150.462 Y108.148 E.69421
G1 X150.5 Y108.358 E.00425
G2 X150.289 Y108.435 I.675 J2.167 E.00447
; WIPE_START
G1 X150.002 Y108.582 E-.12243
G1 X149.796 Y108.721 E-.09441
G1 X149.592 Y108.897 E-.10229
G1 X149.411 Y109.095 E-.10222
G1 X149.254 Y109.314 E-.10228
G1 X149.124 Y109.549 E-.1023
G1 X149.023 Y109.799 E-.10228
G1 X149.001 Y109.88 E-.0318
; WIPE_END
G1 E-.04 F1800
G1 X143.75 Y115.419 Z.865 F30000
G1 X125.281 Y134.905 Z.865
M73 P48 R9
G1 Z.465
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.253 Y134.94 E.00084
G3 X125.076 Y135.082 I-.529 J-.478 E.00421
G3 X120.295 Y111.175 I-4.365 J-11.559 E.79263
G3 X132.315 Y127.79 I.416 J12.355 E.44721
G3 X131.867 Y128.214 I-.725 J-.318 E.01172
G1 X131.819 Y128.229 E.00093
G3 X131.084 Y128.017 I-.143 J-.885 E.01462
G3 X130.807 Y127.196 I.439 J-.605 E.0171
G2 X113.677 Y115.416 I-10.094 J-3.667 E.52305
G1 X114.992 Y116.73 E.03439
G1 X115.275 Y117.013 E.0074
G1 F3990.014
G1 X115.372 Y117.11 E.00253
G1 F2520
G3 X117.758 Y115.717 I5.37 J6.461 E.05133
G1 X118.184 Y115.579 E.00829
G1 X118.565 Y115.456 E.0074
G1 F2400
G1 X118.976 Y115.358 E.00782
G1 F2520
G3 X119.442 Y115.269 I2.915 J14.044 E.00877
G1 F2855.785
G1 X119.476 Y115.263 E.00063
G1 F5252.908
G1 X119.557 Y115.447 E.00371
G1 F8991.576
G1 X119.68 Y115.648 E.00436
G1 F9000
G1 X119.902 Y115.879 E.00594
G2 X121.749 Y115.649 I.811 J-1.017 E.03835
G1 X121.87 Y115.447 E.00436
G1 F5275.696
G1 X121.951 Y115.262 E.00374
G1 F2854.356
G1 X121.985 Y115.268 E.00063
G1 F2520
G3 X128.971 Y122.255 I-1.313 J8.299 E.19533
G1 F2854.138
G1 X128.978 Y122.288 E.00063
G1 F5274.91
G1 X128.793 Y122.37 E.00374
G1 F9000
G1 X128.588 Y122.492 E.00441
G2 X128.59 Y124.562 I.79 J1.034 E.04426
G1 X128.793 Y124.683 E.00436
G1 F5274.91
G1 X128.978 Y124.765 E.00374
G1 F2854.138
G1 X128.971 Y124.798 E.00063
G1 F2520
G1 X128.879 Y125.274 E.00897
G1 F2400
G1 X128.777 Y125.697 E.00805
G1 F2520
G3 X121.985 Y131.785 I-8.122 J-2.229 E.17825
G1 F2854.356
G1 X121.951 Y131.791 E.00063
G1 F5275.696
G1 X121.87 Y131.606 E.00374
G1 F9000
G1 X121.748 Y131.401 E.00441
G2 X119.677 Y131.403 I-1.034 J.788 E.04429
G1 X119.557 Y131.606 E.00436
G1 F5275.56
G1 X119.475 Y131.791 E.00374
G1 F2854.257
G1 X119.442 Y131.785 E.00063
G1 F2520
G3 X112.455 Y124.798 I1.297 J-8.283 E.1954
G1 F2852.507
G1 X112.449 Y124.765 E.00063
G1 F5271.974
G1 X112.634 Y124.683 E.00374
G1 F9000
G1 X112.836 Y124.562 E.00436
G2 X112.839 Y122.492 I-.788 J-1.036 E.04426
G1 X112.634 Y122.37 E.00442
G1 F5269.864
G1 X112.449 Y122.288 E.00374
G1 F2852.469
G1 X112.455 Y122.255 E.00063
G1 F2520
G3 X114.297 Y118.185 I8.34 J1.322 E.08361
G1 F3990.014
G1 X114.2 Y118.088 E.00253
G1 F9000
G1 X113.917 Y117.805 E.0074
G1 X112.603 Y116.49 E.03439
G2 X124.39 Y133.618 I8.113 J7.036 E.5232
G3 X124.739 Y133.588 I.24 J.748 E.00654
G3 X125.338 Y134.101 I-.218 J.861 E.01512
G3 X125.322 Y134.85 I-.615 J.361 E.01458
G1 X125.317 Y134.856 E.00015
M204 S10000
G1 X125.537 Y135.238 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X125.427 Y135.34 E.00299
G3 X125.278 Y135.441 I-.705 J-.877 E.00358
G3 X114.245 Y134.535 I-4.578 J-11.882 E.22787
G3 X120.286 Y110.765 I6.469 J-11.009 E.65465
G3 X132.696 Y127.943 I.424 J12.765 E.49726
G3 X132.252 Y128.486 I-1.04 J-.396 E.01421
G3 X130.846 Y128.352 I-.61 J-1.048 E.03002
G3 X130.414 Y127.077 I.623 J-.921 E.02877
G2 X114.286 Y115.444 I-9.708 J-3.538 E.53263
G1 X115.402 Y116.56 E.03142
G3 X119.72 Y114.801 I5.546 J7.433 E.09378
G1 X119.925 Y115.265 E.01009
G2 X121.466 Y115.331 I.789 J-.4 E.03727
G2 X121.708 Y114.797 I-3.01 J-1.688 E.01168
G1 X122.548 Y114.959 E.01703
G3 X128.299 Y119.142 I-1.915 J8.678 E.14557
G3 X129.443 Y122.532 I-8.623 J4.798 E.07157
G1 X128.974 Y122.738 E.0102
G2 X128.909 Y124.279 I.4 J.789 E.03727
G2 X129.443 Y124.521 I1.687 J-3.009 E.01168
G1 X129.28 Y125.361 E.01703
G3 X124.697 Y131.33 I-8.635 J-1.887 E.15468
G3 X121.708 Y132.256 I-4.557 J-9.425 E.06249
G1 X121.501 Y131.787 E.0102
G2 X119.961 Y131.722 I-.789 J.4 E.03726
G2 X119.719 Y132.256 I3.015 J1.69 E.01168
G1 X118.881 Y132.094 E.01696
G3 X112.909 Y127.51 I1.848 J-8.589 E.15481
G3 X111.984 Y124.522 I9.44 J-4.562 E.06248
G1 X112.452 Y124.315 E.01019
G2 X112.518 Y122.774 I-.407 J-.789 E.03717
G2 X111.984 Y122.531 I-1.711 J3.056 E.01168
G1 X112.143 Y121.706 E.01671
G3 X113.746 Y118.215 I8.6 J1.835 E.07707
G1 X112.631 Y117.099 E.0314
G2 X124.271 Y133.225 I8.095 J6.421 E.5328
G3 X124.616 Y133.166 I.342 J.967 E.00699
G3 X125.698 Y133.902 I-.037 J1.218 E.02748
G3 X125.577 Y135.194 I-.976 J.561 E.02752
; WIPE_START
G1 X125.427 Y135.34 E-.07983
G1 X125.278 Y135.441 E-.06833
G1 X125.131 Y135.509 E-.06152
G1 X124.586 Y135.695 E-.21877
G1 X124.051 Y135.853 E-.21194
G1 X123.745 Y135.929 E-.11962
; WIPE_END
G1 E-.04 F1800
G1 X129.099 Y130.489 Z.865 F30000
G1 X150.422 Y108.825 Z.865
G1 Z.465
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.424 Y108.824 E.00003
G3 X151.063 Y108.669 I.75 J1.701 E.01224
G1 X151.285 Y108.669 E.00409
G3 X150.046 Y109.048 I-.111 J1.856 E.19156
G1 X150.371 Y108.855 E.00698
; WIPE_START
M204 S10000
G1 X150.424 Y108.824 E-.02338
G1 X150.631 Y108.747 E-.08412
G1 X151.063 Y108.669 E-.16686
G1 X151.285 Y108.669 E-.08413
G1 X151.504 Y108.695 E-.08378
G1 X151.718 Y108.747 E-.08377
G1 X151.924 Y108.824 E-.08373
G1 X152.121 Y108.925 E-.08379
G1 X152.266 Y109.022 E-.06644
; WIPE_END
G1 E-.04 F1800
G1 X152.409 Y116.653 Z.865 F30000
G1 X152.798 Y137.435 Z.865
G1 Z.465
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.684 Y137.612 E.00389
G3 X151.063 Y134.672 I-1.51 J-1.084 E.13855
G1 X151.285 Y134.672 E.00409
G3 X152.825 Y137.381 I-.111 J1.856 E.06837
M204 S10000
G1 X153.597 Y137.519 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.312543
G1 F15000
G1 X153.568 Y137.632 E.00156
; LINE_WIDTH: 0.361943
G3 X153.502 Y137.824 I-1.984 J-.57 E.00321
; LINE_WIDTH: 0.406578
G1 X153.5 Y137.831 E.00012
G3 X153.132 Y138.333 I-1.362 J-.611 E.01122
; LINE_WIDTH: 0.350841
G3 X152.644 Y138.688 I-3.63 J-4.479 E.0092
G1 X153.355 Y138.381 F30000
; LINE_WIDTH: 0.133348
G1 F15000
G3 X152.46 Y138.676 I-5.457 J-15.072 E.0048
G1 X152.51 Y138.693 F30000
; LINE_WIDTH: 0.28093
G1 F15000
G1 X152.883 Y138.51 E.00498
G1 X153.593 Y138.07 E.01001
G1 X153.597 Y137.519 F30000
; LINE_WIDTH: 0.287322
G1 F15000
G1 X153.6 Y137.504 E.00019
; LINE_WIDTH: 0.260417
G1 X153.625 Y137.355 E.00166
; LINE_WIDTH: 0.212015
G1 X153.649 Y137.21 E.00129
; LINE_WIDTH: 0.170949
G1 X153.665 Y137.051 E.00109
; LINE_WIDTH: 0.138854
G1 X153.681 Y136.902 E.0008
; LINE_WIDTH: 0.106281
G1 X153.69 Y136.307 E.00227
; LINE_WIDTH: 0.127639
G1 X153.668 Y136.008 E.00144
; LINE_WIDTH: 0.170144
G1 X153.647 Y135.853 E.00106
; LINE_WIDTH: 0.210629
G1 X153.627 Y135.706 E.00129
; LINE_WIDTH: 0.245946
G1 X153.612 Y135.623 E.00088
; LINE_WIDTH: 0.275972
G1 X153.598 Y135.552 E.00085
; LINE_WIDTH: 0.311836
G1 X153.569 Y135.422 E.00178
; LINE_WIDTH: 0.339496
G1 X153.556 Y135.377 E.00069
; LINE_WIDTH: 0.371089
G2 X153.498 Y135.228 I-1.487 J.486 E.00259
; LINE_WIDTH: 0.409167
G2 X153.112 Y134.703 I-1.412 J.636 E.01182
; LINE_WIDTH: 0.371856
G1 X153.048 Y134.534 E.00294
; LINE_WIDTH: 0.341744
G1 X152.985 Y134.364 E.00269
; WIPE_START
G1 X153.048 Y134.534 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.799 Y134.515 Z.865 F30000
G1 Z.465
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.420737
G1 F15000
G1 X131.806 Y116.523 E.47144
G3 X132.504 Y117.781 I-11.784 J7.362 E.02668
G1 X149.361 Y134.638 E.44168
G2 X149.098 Y134.935 I2.941 J2.868 E.00736
G1 X132.939 Y118.776 E.4234
G3 X133.243 Y119.64 I-15.214 J5.833 E.01697
G1 X148.878 Y135.275 E.40968
G2 X148.703 Y135.661 I1.53 J.926 E.00786
G1 X133.45 Y120.408 E.39966
G1 X133.605 Y121.123 E.01356
G1 X148.592 Y136.109 E.39268
G2 X148.557 Y136.635 I3.202 J.476 E.00977
G1 X133.717 Y121.795 E.38884
G3 X133.786 Y122.424 I-39.42 J4.643 E.01173
G1 X148.679 Y137.317 E.39024
G2 X149.266 Y138.322 I2.563 J-.823 E.02173
G1 X149.197 Y138.395 E.00186
G1 X133.822 Y123.02 E.40285
G3 X133.832 Y123.59 I-6.529 J.396 E.01056
G1 X148.799 Y138.557 E.39217
G1 X148.239 Y138.557 E.01038
G1 X133.818 Y124.137 E.37785
G1 X133.783 Y124.661 E.00974
G1 X147.679 Y138.557 E.3641
G1 X147.118 Y138.557 E.01038
G1 X133.728 Y125.167 E.35086
G3 X133.656 Y125.655 I-5.629 J-.578 E.00915
G1 X146.558 Y138.557 E.33807
G1 X145.998 Y138.557 E.01038
G1 X133.569 Y126.128 E.32567
G3 X133.468 Y126.587 I-5.307 J-.929 E.00871
G1 X145.438 Y138.557 E.31365
G1 X144.878 Y138.557 E.01038
G1 X133.354 Y127.033 E.30196
G1 X133.226 Y127.466 E.00836
G1 X144.318 Y138.557 E.29062
G1 X143.757 Y138.557 E.01038
G1 X133.085 Y127.885 E.27965
G3 X132.921 Y128.281 I-2.192 J-.677 E.00795
G1 X143.197 Y138.557 E.26927
G1 X142.637 Y138.557 E.01038
G1 X132.673 Y128.593 E.26108
G3 X132.349 Y128.83 I-1.069 J-1.124 E.00745
G1 X142.077 Y138.557 E.25489
G1 X141.517 Y138.557 E.01038
G1 X131.939 Y128.979 E.25097
G3 X131.381 Y128.982 I-.286 J-1.476 E.01039
G1 X140.957 Y138.557 E.2509
G1 X140.396 Y138.557 E.01038
G1 X129.038 Y127.199 E.29762
G1 X128.865 Y127.586 E.00786
G1 X139.836 Y138.557 E.28747
G1 X139.276 Y138.557 E.01038
G1 X128.673 Y127.954 E.27783
G3 X128.461 Y128.302 I-2.321 J-1.173 E.00756
G1 X138.716 Y138.557 E.2687
G1 X138.156 Y138.557 E.01038
G1 X128.24 Y128.642 E.25981
G3 X128.011 Y128.973 I-1.69 J-.926 E.00747
G1 X137.596 Y138.557 E.25114
G1 X137.035 Y138.557 E.01038
G1 X127.76 Y129.282 E.24303
G1 X127.51 Y129.592 E.00738
G1 X136.475 Y138.557 E.23492
G1 X135.915 Y138.557 E.01038
G1 X127.233 Y129.875 E.2275
G1 X126.953 Y130.155 E.00734
G1 X135.355 Y138.557 E.22016
G1 X134.795 Y138.557 E.01038
G1 X126.661 Y130.424 E.21311
G3 X126.354 Y130.676 I-2.038 J-2.168 E.00738
G1 X134.235 Y138.557 E.20649
G1 X133.674 Y138.557 E.01038
G1 X126.033 Y130.915 E.20023
G3 X125.699 Y131.142 I-1.735 J-2.191 E.00748
G1 X133.114 Y138.557 E.19429
G1 X132.554 Y138.557 E.01038
G1 X125.357 Y131.361 E.18857
G3 X124.999 Y131.563 I-1.624 J-2.456 E.00762
G1 X131.994 Y138.557 E.18327
G1 X131.434 Y138.557 E.01038
G1 X124.627 Y131.75 E.17836
G3 X124.238 Y131.922 I-1.507 J-2.893 E.00788
G1 X130.874 Y138.557 E.17387
G1 X130.313 Y138.557 E.01038
G1 X126.196 Y134.439 E.10789
G3 X126.121 Y134.925 I-1.501 J.017 E.00914
G1 X129.753 Y138.557 E.09518
G1 X129.193 Y138.557 E.01038
G1 X125.936 Y135.3 E.08535
G3 X125.668 Y135.593 I-1.038 J-.679 E.00738
G1 X128.633 Y138.557 E.07768
G1 X128.073 Y138.557 E.01038
G1 X125.321 Y135.805 E.0721
G3 X124.909 Y135.954 I-.929 J-1.936 E.00813
G1 X127.513 Y138.557 E.06822
G1 X126.952 Y138.557 E.01038
G1 X124.484 Y136.089 E.06467
G3 X124.048 Y136.213 I-1.639 J-4.937 E.0084
G1 X126.392 Y138.557 E.06142
G1 X125.832 Y138.557 E.01038
G1 X123.599 Y136.324 E.05851
G3 X123.133 Y136.419 I-1.318 J-5.3 E.00881
G1 X125.272 Y138.557 E.05604
G1 X124.712 Y138.557 E.01038
G1 X122.653 Y136.499 E.05394
G3 X122.157 Y136.563 I-.982 J-5.637 E.00927
G1 X124.151 Y138.557 E.05226
G1 X123.591 Y138.557 E.01038
G1 X121.644 Y136.61 E.05103
G3 X121.111 Y136.637 I-.578 J-6.093 E.00989
G1 X123.031 Y138.557 E.05032
G1 X122.471 Y138.557 E.01038
G1 X120.556 Y136.642 E.05018
G3 X119.976 Y136.622 I-.063 J-6.642 E.01076
G1 X121.911 Y138.557 E.0507
G1 X121.351 Y138.557 E.01038
G1 X119.365 Y136.571 E.05203
G3 X118.719 Y136.486 I.386 J-5.381 E.01208
G1 X120.79 Y138.557 E.05428
G1 X120.23 Y138.557 E.01038
G1 X118.038 Y136.365 E.05743
G3 X117.308 Y136.195 I3.015 J-14.61 E.01389
G1 X119.67 Y138.557 E.06188
G1 X119.11 Y138.557 E.01038
G1 X116.5 Y135.948 E.06838
G3 X115.597 Y135.605 I4.506 J-13.227 E.0179
G1 X118.55 Y138.557 E.07736
G1 X117.99 Y138.557 E.01038
G1 X114.048 Y134.616 E.10327
; WIPE_START
G1 X115.463 Y136.03 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X115.726 Y132.372 Z.865 F30000
G1 Z.465
G1 E.8 F1800
G1 F15000
G1 X112.404 Y129.05 E.08705
G3 X111.697 Y127.783 I6.548 J-4.484 E.02692
G1 X116.806 Y132.893 E.13388
; WIPE_START
G1 X115.392 Y131.478 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X117.607 Y138.735 Z.865 F30000
G1 Z.465
G1 E.8 F1800
G1 F15000
G1 X106.532 Y127.66 E.29019
G1 X106.532 Y128.22 E.01038
G1 X116.869 Y138.557 E.27085
G1 X116.309 Y138.557 E.01038
G1 X106.532 Y128.78 E.25617
G1 X106.532 Y129.341 E.01038
G1 X115.749 Y138.557 E.24149
G3 X115.169 Y138.538 I-.085 J-6.119 E.01075
G1 X106.552 Y129.92 E.2258
G2 X106.594 Y130.522 I3.165 J.083 E.0112
G1 X114.567 Y138.496 E.20893
G1 X113.913 Y138.402 E.01225
G1 X106.688 Y131.176 E.18932
G2 X106.863 Y131.912 I6.568 J-1.176 E.01401
G1 X113.178 Y138.227 E.16547
G3 X112.345 Y137.954 I1.012 J-4.497 E.01627
G1 X107.135 Y132.744 E.13651
G2 X107.594 Y133.763 I7.243 J-2.65 E.02073
G1 X111.315 Y137.484 E.0975
G3 X109.337 Y136.067 I3.988 J-7.652 E.04524
G1 X107.919 Y134.648 E.03716
G1 X109.623 Y130.191 F30000
G1 F15000
G1 X106.532 Y127.1 E.08098
G1 X106.532 Y126.54 E.01038
G1 X108.634 Y128.641 E.05506
G3 X108.292 Y127.739 I13.621 J-5.677 E.01787
G1 X106.532 Y125.98 E.0461
G1 X106.532 Y125.419 E.01038
G1 X108.043 Y126.93 E.03959
G3 X107.872 Y126.199 I8.291 J-2.33 E.01393
G1 X106.532 Y124.859 E.03509
G1 X106.532 Y124.299 E.01038
G1 X107.749 Y125.515 E.03187
G3 X107.666 Y124.872 I7.311 J-1.268 E.01201
G1 X106.532 Y123.739 E.0297
G1 X106.532 Y123.179 E.01038
G1 X107.617 Y124.263 E.02842
G3 X107.597 Y123.683 I6.636 J-.518 E.01076
G1 X106.532 Y122.619 E.0279
G1 X106.532 Y122.058 E.01038
G1 X107.602 Y123.129 E.02804
G3 X107.63 Y122.596 I6.121 J.047 E.00989
G1 X106.532 Y121.498 E.02875
M73 P49 R9
G1 X106.532 Y120.938 E.01038
G1 X107.677 Y122.082 E.02998
G3 X107.743 Y121.588 I4.825 J.393 E.00924
G1 X106.532 Y120.378 E.03171
G1 X106.532 Y119.818 E.01038
G1 X107.822 Y121.107 E.03379
G1 X107.924 Y120.649 E.00869
G1 X106.532 Y119.258 E.03647
G1 X106.532 Y118.697 E.01038
G1 X108.027 Y120.192 E.03915
G3 X108.15 Y119.755 I3.533 J.765 E.00841
G1 X106.532 Y118.137 E.04239
G1 X106.532 Y117.577 E.01038
G1 X108.286 Y119.331 E.04595
G3 X108.433 Y118.917 I4.807 J1.47 E.00813
G1 X106.556 Y117.041 E.04917
G3 X106.595 Y116.52 I2.743 J-.057 E.0097
G1 X108.589 Y118.514 E.05225
G1 X108.76 Y118.124 E.00788
G1 X106.666 Y116.03 E.05488
G3 X106.753 Y115.557 I3.353 J.372 E.00892
G1 X108.94 Y117.744 E.05732
G3 X109.129 Y117.373 I4.346 J1.972 E.00772
G1 X106.871 Y115.114 E.05917
G1 X106.998 Y114.681 E.00836
G1 X109.327 Y117.011 E.06104
G3 X109.537 Y116.661 I4.119 J2.232 E.00757
G1 X107.15 Y114.273 E.06256
G1 X107.31 Y113.873 E.00798
G1 X109.755 Y116.318 E.06407
G3 X109.98 Y115.983 I3.956 J2.414 E.00748
G1 X107.493 Y113.496 E.06517
G1 X107.683 Y113.126 E.0077
G1 X110.217 Y115.66 E.06638
G3 X110.462 Y115.344 I3.727 J2.641 E.0074
G1 X107.889 Y112.771 E.06742
G3 X108.114 Y112.437 I2.451 J1.409 E.00748
G1 X110.713 Y115.036 E.06811
G1 X110.975 Y114.738 E.00735
G1 X108.347 Y112.11 E.06886
G3 X108.59 Y111.792 I2.341 J1.539 E.00741
G1 X111.246 Y114.448 E.0696
G3 X111.524 Y114.166 I3.375 J3.041 E.00734
G1 X108.852 Y111.494 E.07001
G1 X109.125 Y111.207 E.00734
G1 X111.81 Y113.892 E.07034
G3 X112.107 Y113.629 I3.155 J3.255 E.00735
G1 X109.405 Y110.927 E.07078
G1 X109.705 Y110.667 E.00736
G1 X112.41 Y113.372 E.07088
G1 X112.721 Y113.123 E.00738
G1 X110.008 Y110.409 E.0711
G1 X110.335 Y110.176 E.00744
G1 X113.044 Y112.885 E.07099
G3 X113.374 Y112.655 I2.799 J3.665 E.00746
G1 X110.662 Y109.943 E.07106
G3 X111.016 Y109.737 I1.261 J1.751 E.0076
G1 X113.712 Y112.433 E.07065
G1 X114.06 Y112.221 E.00756
G1 X111.371 Y109.531 E.07048
G3 X111.744 Y109.345 I1.492 J2.518 E.00774
G1 X114.419 Y112.019 E.07008
G3 X114.785 Y111.825 I2.399 J4.091 E.00768
G1 X112.14 Y109.181 E.0693
G1 X112.54 Y109.021 E.00798
G1 X115.16 Y111.64 E.06865
G3 X115.549 Y111.469 I2.158 J4.364 E.00787
G1 X112.968 Y108.888 E.06763
G1 X113.401 Y108.761 E.00836
G1 X115.947 Y111.307 E.06672
G3 X116.355 Y111.154 I1.948 J4.593 E.00807
G1 X113.859 Y108.659 E.0654
G1 X114.349 Y108.588 E.00917
G1 X116.773 Y111.013 E.06353
G1 X117.207 Y110.886 E.00837
G1 X114.847 Y108.526 E.06183
G3 X115.387 Y108.506 I.412 J3.779 E.01002
G1 X117.653 Y110.772 E.05937
G3 X118.112 Y110.671 I1.392 J5.211 E.00871
G1 X115.947 Y108.506 E.05672
G1 X116.507 Y108.506 E.01038
G1 X118.584 Y110.583 E.05443
G3 X119.072 Y110.511 I1.068 J5.551 E.00915
G1 X117.067 Y108.506 E.05255
G1 X117.627 Y108.506 E.01038
G1 X119.578 Y110.456 E.05111
G1 X120.107 Y110.426 E.00983
G1 X118.187 Y108.505 E.05032
G1 X118.747 Y108.505 E.01038
G1 X120.659 Y110.418 E.0501
G1 X121.221 Y110.419 E.01041
G1 X119.307 Y108.505 E.05016
G1 X119.867 Y108.505 E.01038
G1 X121.817 Y110.454 E.05108
G3 X122.444 Y110.522 I-4.078 J40.959 E.01169
G1 X120.427 Y108.505 E.05285
G1 X120.987 Y108.505 E.01038
G1 X123.113 Y110.63 E.05569
G3 X123.828 Y110.785 I-1.417 J8.268 E.01356
G1 X121.547 Y108.505 E.05976
G1 X122.107 Y108.504 E.01038
G1 X124.6 Y110.997 E.06532
G3 X125.463 Y111.3 I-4.604 J14.498 E.01695
G1 X122.667 Y108.504 E.07326
G1 X123.227 Y108.504 E.01038
G1 X126.458 Y111.735 E.08465
G3 X127.731 Y112.447 I-5.539 J11.384 E.02705
G1 X123.787 Y108.504 E.10333
G1 X124.347 Y108.504 E.01038
G1 X150.023 Y134.179 E.67276
G3 X150.422 Y134.019 I1.535 J3.24 E.00798
G1 X124.907 Y108.504 E.66855
G1 X125.467 Y108.504 E.01038
G1 X150.892 Y133.928 E.66618
G3 X151.451 Y133.927 I.286 J2.578 E.01037
G1 X126.027 Y108.503 E.66615
G1 X126.587 Y108.503 E.01038
G1 X152.204 Y134.12 E.67122
G3 X152.392 Y134.213 I-.295 J.834 E.00389
G1 X152.731 Y134.086 E.0067
G1 X127.147 Y108.503 E.67034
G1 X127.707 Y108.503 E.01038
G1 X152.803 Y133.599 E.65757
G1 X152.803 Y133.039 E.01038
G1 X128.267 Y108.503 E.64289
G1 X128.827 Y108.503 E.01038
G1 X152.803 Y132.478 E.62822
G1 X152.803 Y131.918 E.01038
G1 X129.388 Y108.503 E.61355
G1 X129.948 Y108.502 E.01038
G1 X152.803 Y131.358 E.59887
G1 X152.803 Y130.798 E.01038
G1 X130.508 Y108.502 E.5842
G1 X131.068 Y108.502 E.01038
G1 X152.803 Y130.238 E.56952
G1 X152.803 Y129.678 E.01038
G1 X131.628 Y108.502 E.55485
G1 X132.188 Y108.502 E.01038
G1 X152.803 Y129.117 E.54018
G1 X152.803 Y128.557 E.01038
G1 X132.748 Y108.502 E.5255
G1 X133.308 Y108.501 E.01038
G1 X152.803 Y127.997 E.51083
G1 X152.803 Y127.437 E.01038
G1 X133.868 Y108.501 E.49616
G1 X134.428 Y108.501 E.01038
G1 X152.803 Y126.877 E.48148
G1 X152.803 Y126.317 E.01038
G1 X134.988 Y108.501 E.46681
G1 X135.548 Y108.501 E.01038
G1 X152.803 Y125.756 E.45214
G1 X152.803 Y125.196 E.01038
G1 X136.108 Y108.501 E.43746
G1 X136.668 Y108.501 E.01038
G1 X152.803 Y124.636 E.42279
G1 X152.803 Y124.076 E.01038
G1 X137.228 Y108.5 E.40811
G1 X137.788 Y108.5 E.01038
G1 X152.803 Y123.516 E.39344
G1 X152.803 Y122.956 E.01038
G1 X138.348 Y108.5 E.37877
G1 X138.908 Y108.5 E.01038
G1 X152.803 Y122.395 E.36409
G1 X152.803 Y121.835 E.01038
G1 X139.468 Y108.5 E.34942
G1 X140.028 Y108.5 E.01038
G1 X152.803 Y121.275 E.33475
G1 X152.803 Y120.715 E.01038
G1 X140.588 Y108.5 E.32007
G1 X141.148 Y108.499 E.01038
G1 X152.803 Y120.155 E.3054
G1 X152.803 Y119.595 E.01038
G1 X141.708 Y108.499 E.29073
G1 X142.268 Y108.499 E.01038
G1 X152.803 Y119.034 E.27605
G1 X152.803 Y118.474 E.01038
G1 X142.828 Y108.499 E.26138
G1 X143.388 Y108.499 E.01038
G1 X152.803 Y117.914 E.2467
G1 X152.803 Y117.354 E.01038
G1 X143.948 Y108.499 E.23203
G1 X144.508 Y108.498 E.01038
G1 X152.803 Y116.794 E.21736
G1 X152.803 Y116.234 E.01038
G1 X145.068 Y108.498 E.20268
G1 X145.628 Y108.498 E.01038
G1 X152.803 Y115.674 E.18801
G1 X152.803 Y115.113 E.01038
G1 X150.809 Y113.119 E.05226
G2 X151.385 Y113.135 I.367 J-2.864 E.0107
G1 X152.803 Y114.553 E.03717
G1 X152.803 Y113.993 E.01038
G1 X151.862 Y113.052 E.02466
G2 X152.272 Y112.902 I-.427 J-1.8 E.00811
G1 X152.981 Y113.611 E.01858
; WIPE_START
G1 X152.272 Y112.902 E-.38109
G1 X152.087 Y112.983 E-.0769
G1 X151.862 Y113.052 E-.0893
G1 X152.258 Y113.448 E-.21271
; WIPE_END
G1 E-.04 F1800
G1 X153.73 Y111.105 Z.865 F30000
G1 Z.465
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.353934
G1 F15000
G3 X153.503 Y111.822 I-6.172 J-1.564 E.01159
; LINE_WIDTH: 0.40724
G1 X153.501 Y111.825 E.00006
G3 X153.119 Y112.346 I-1.394 J-.624 E.01165
; LINE_WIDTH: 0.374561
G1 X152.958 Y112.711 E.00654
G1 X153.419 Y112.316 F30000
; LINE_WIDTH: 0.287496
G1 F15000
G1 X153.6 Y111.501 E.01026
; LINE_WIDTH: 0.260549
G1 X153.624 Y111.354 E.00164
; LINE_WIDTH: 0.212221
G1 X153.649 Y111.207 E.00131
; LINE_WIDTH: 0.186762
G1 X153.65 Y111.198 E.00007
; LINE_WIDTH: 0.169931
G1 X153.665 Y111.049 E.00102
; LINE_WIDTH: 0.138209
G1 X153.681 Y110.893 E.00083
; LINE_WIDTH: 0.106102
G1 X153.689 Y110.3 E.00226
; LINE_WIDTH: 0.128556
G1 X153.667 Y109.998 E.00147
; LINE_WIDTH: 0.171126
G1 X153.647 Y109.851 E.00102
; LINE_WIDTH: 0.212302
G1 X153.625 Y109.691 E.00141
; LINE_WIDTH: 0.248027
G1 X153.612 Y109.622 E.00074
; LINE_WIDTH: 0.275234
G1 X153.598 Y109.552 E.00083
; LINE_WIDTH: 0.311087
G1 X153.569 Y109.421 E.0018
; LINE_WIDTH: 0.34838
G1 X153.536 Y109.32 E.00161
; LINE_WIDTH: 0.394599
G2 X153.42 Y109.07 I-2.382 J.956 E.00478
; LINE_WIDTH: 0.41113
G2 X153.141 Y108.731 I-1.179 J.687 E.00796
; LINE_WIDTH: 0.366919
G2 X153.008 Y108.624 I-1.023 J1.132 E.00273
; LINE_WIDTH: 0.314467
G2 X152.573 Y108.361 I-2.729 J4.029 E.0069
G1 X152.476 Y108.361 F30000
; LINE_WIDTH: 0.229507
G1 F15000
G3 X153.491 Y108.822 I-7.359 J17.544 E.01068
; WIPE_START
G1 X152.476 Y108.361 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.888 Y108.38 Z.865 F30000
G1 Z.465
G1 E.8 F1800
; LINE_WIDTH: 0.0936005
G1 F15000
G2 X149.696 Y108.503 I.044 J.278 E.00075
G1 X149.374 Y108.883 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.420737
G1 F15000
G1 X148.988 Y108.497 E.0101
G1 X148.428 Y108.497 E.01038
G1 X149 Y109.069 E.01498
G2 X148.797 Y109.427 I3.068 J1.976 E.00762
G1 X147.868 Y108.498 E.02434
G1 X147.308 Y108.498 E.01038
G1 X148.65 Y109.84 E.03516
G2 X148.563 Y110.313 I3.236 J.836 E.00893
G1 X146.748 Y108.498 E.04756
G1 X146.188 Y108.498 E.01038
G1 X148.807 Y111.117 E.06862
; WIPE_START
G1 X147.393 Y109.703 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.242 Y114.222 Z.865 F30000
G1 X128.663 Y123.463 Z.865
G1 Z.465
G1 E.8 F1800
G1 F15000
G1 X129.609 Y124.409 E.02478
G1 X130.262 Y127.862 F30000
G1 F15000
G1 X129.211 Y126.811 E.02754
G2 X129.358 Y126.398 I-2.55 J-1.141 E.00813
G1 X130.051 Y127.091 E.01815
G1 X130.182 Y126.662 E.00831
G1 X129.489 Y125.969 E.01817
G2 X129.601 Y125.521 I-4.219 J-1.295 E.00856
G1 X130.313 Y126.233 E.01867
G2 X130.425 Y125.785 I-2.513 J-.867 E.00857
G1 X129.695 Y125.055 E.01914
G1 X129.786 Y124.586 E.00886
G1 X130.524 Y125.324 E.01934
G2 X130.604 Y124.844 I-3.45 J-.823 E.00902
G1 X128.955 Y123.195 E.04321
G3 X129.298 Y122.977 I.582 J.535 E.0076
G1 X130.651 Y124.33 E.03546
G1 X130.689 Y123.808 E.0097
G1 X129.686 Y122.806 E.02628
G1 X129.838 Y122.739 E.00308
G1 X129.757 Y122.316 E.00798
G1 X130.681 Y123.24 E.02422
G2 X130.651 Y122.65 I-4.635 J-.061 E.01095
G1 X129.622 Y121.621 E.02696
G2 X129.41 Y120.849 I-8.74 J1.984 E.01484
G1 X130.566 Y122.005 E.0303
G2 X130.438 Y121.317 I-3.813 J.355 E.013
G1 X129.088 Y119.967 E.03536
G2 X128.503 Y118.822 I-5.745 J2.213 E.02388
G1 X130.237 Y120.555 E.04543
G1 X129.92 Y119.678 E.01728
G1 X124.562 Y114.32 E.14041
G3 X125.682 Y114.88 I-3.564 J8.527 E.02324
G1 X129.808 Y119.006 E.10811
G1 X126.037 Y116.355 F30000
G1 F15000
G1 X123.693 Y114.011 E.06143
G2 X122.927 Y113.805 I-1.504 J4.071 E.01472
G1 X124.266 Y115.144 E.03509
G1 X123.535 Y114.864 E.0145
G1 X123.384 Y114.823 E.0029
G1 X122.232 Y113.671 E.03018
G1 X121.586 Y113.585 E.01209
G1 X122.619 Y114.618 E.02707
G1 X121.924 Y114.483 E.01311
G1 X121.001 Y113.56 E.0242
G2 X120.439 Y113.558 I-.29 J3.061 E.01042
G1 X121.435 Y114.554 E.0261
G1 X121.26 Y114.94 E.00784
G1 X119.905 Y113.584 E.03552
G2 X119.395 Y113.635 I.113 J3.732 E.0095
G1 X121.046 Y115.286 E.04327
G3 X120.59 Y115.389 I-.345 J-.462 E.00894
G1 X120.181 Y114.981 E.01071
G1 X119.928 Y114.407 E.01161
G1 X119.658 Y114.458 E.00509
G1 X118.919 Y113.719 E.01936
G1 X118.448 Y113.808 E.00889
G1 X119.186 Y114.546 E.01935
G2 X118.719 Y114.639 I.708 J4.798 E.00883
G1 X118.01 Y113.93 E.01858
G1 X117.574 Y114.054 E.0084
G1 X118.271 Y114.751 E.01827
G2 X117.843 Y114.883 I.778 J3.295 E.00831
G1 X117.168 Y114.208 E.01769
G1 X116.764 Y114.364 E.00802
G1 X117.433 Y115.033 E.01753
G2 X117.036 Y115.197 I.91 J2.767 E.00795
G1 X116.384 Y114.545 E.01709
G1 X116.01 Y114.731 E.00774
G1 X116.651 Y115.372 E.0168
G2 X116.285 Y115.566 I1.334 J2.959 E.00768
G1 X115.648 Y114.929 E.01668
G2 X115.302 Y115.143 I2.158 J3.884 E.00754
G1 X115.932 Y115.773 E.01651
G2 X115.597 Y115.998 I1.402 J2.455 E.00749
G1 X114.842 Y115.244 E.01977
; WIPE_START
G1 X115.597 Y115.998 E-.40554
G1 X115.932 Y115.773 E-.15342
G1 X115.558 Y115.399 E-.20104
; WIPE_END
G1 E-.04 F1800
G1 X113.223 Y118.666 Z.865 F30000
G1 Z.465
G1 E.8 F1800
G1 F15000
G1 X112.465 Y117.908 E.01986
G2 X112.244 Y118.247 I2.609 J1.935 E.00751
G1 X112.879 Y118.882 E.01662
G2 X112.681 Y119.244 I2.267 J1.471 E.00766
G1 X112.036 Y118.599 E.01691
G2 X111.845 Y118.969 I2.59 J1.571 E.00771
G1 X112.494 Y119.618 E.01701
G2 X112.316 Y119.999 I2.417 J1.365 E.00781
G1 X111.659 Y119.343 E.0172
G2 X111.486 Y119.73 I2.729 J1.457 E.00786
G1 X112.159 Y120.403 E.01765
G1 X112.023 Y120.827 E.00825
G1 X111.334 Y120.138 E.01806
G1 X111.193 Y120.558 E.0082
G1 X111.892 Y121.256 E.01831
G2 X111.787 Y121.711 I5.119 J1.423 E.00865
G1 X111.068 Y120.992 E.01885
G1 X110.961 Y121.445 E.00863
G1 X111.848 Y122.333 E.02325
G1 X110.712 Y121.757 F30000
G1 F15000
G1 X112.577 Y123.622 E.04888
G3 X112.357 Y123.962 I-.497 J-.08 E.00772
G1 X110.805 Y122.409 E.04069
G1 X110.756 Y122.921 E.00952
G1 X111.977 Y124.142 E.03198
G1 X111.591 Y124.317 E.00784
G1 X110.734 Y123.459 E.02247
G2 X110.756 Y124.042 I4.26 J.127 E.01081
G1 X111.722 Y125.008 E.02531
G2 X111.874 Y125.719 I7.929 J-1.314 E.01348
G1 X110.798 Y124.644 E.02818
G2 X110.904 Y125.31 I4.896 J-.439 E.01251
G1 X112.122 Y126.528 E.0319
M73 P50 R9
G1 X112.21 Y126.799 E.0053
G1 X112.514 Y127.48 E.01381
G1 X111.051 Y126.017 E.03833
G2 X111.305 Y126.831 I6.048 J-1.439 E.01581
G1 X117.421 Y132.947 E.16026
G1 X118.222 Y133.188 E.01551
G1 X116.756 Y131.722 E.03842
G2 X117.712 Y132.118 I2.848 J-5.526 E.01919
G1 X118.932 Y133.338 E.03198
G2 X119.598 Y133.444 I1.103 J-4.796 E.0125
G1 X118.52 Y132.366 E.02825
G2 X119.232 Y132.517 I2.018 J-7.732 E.01349
G1 X120.198 Y133.484 E.02532
G2 X120.773 Y133.498 I.368 J-3.126 E.01067
G1 X119.926 Y132.651 E.02221
G1 X120.097 Y132.262 E.00787
G1 X121.318 Y133.483 E.03199
G2 X121.829 Y133.434 I-.014 J-2.811 E.00952
G1 X120.283 Y131.888 E.04051
G3 X120.615 Y131.66 I.454 J.306 E.00765
G1 X122.481 Y133.526 E.04889
G1 X121.907 Y132.392 F30000
G1 F15000
G1 X122.792 Y133.277 E.0232
G2 X123.253 Y133.178 I-.335 J-2.677 E.00875
G1 X122.528 Y132.453 E.019
G2 X122.983 Y132.347 I-.933 J-5.07 E.00865
G1 X123.682 Y133.046 E.01831
G1 X124.111 Y132.915 E.00831
G1 X123.415 Y132.219 E.01823
G2 X123.838 Y132.082 I-.695 J-2.864 E.00825
G1 X124.763 Y133.006 E.02423
G1 X149.601 Y138.478 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.108264
G1 F15000
G1 X149.834 Y138.693 E.00124
G1 X150.728 Y138.556 F30000
; LINE_WIDTH: 0.457898
G1 F15000
G1 X150.822 Y138.687 E.00327
; LINE_WIDTH: 0.48689
G1 X150.916 Y138.818 E.00349
; LINE_WIDTH: 0.51475
G1 X150.927 Y138.832 E.0004
; LINE_WIDTH: 0.541499
G1 X150.937 Y138.846 E.00043
; LINE_WIDTH: 0.548629
G2 X151.68 Y138.836 I.287 J-6.087 E.01821
; CHANGE_LAYER
; Z_HEIGHT: 0.563959
; LAYER_HEIGHT: 0.0991543
; WIPE_START
G1 F15000
G1 X150.937 Y138.846 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 4/33
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
G17
G3 Z.865 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X153.692 Y112.966
G1 Z.564
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3600
M204 S5000
G1 X153.692 Y134.087 E.34021
G1 F4107.134
G1 X153.692 Y134.13 E.00069
G1 F9000
G1 X153.965 Y134.413 E.00635
G3 X154.353 Y135.532 I-1.459 J1.132 E.01941
G1 X154.353 Y137.521 E.03204
G3 X152.558 Y139.316 I-1.815 J-.019 E.0453
G1 X115.566 Y139.316 E.59586
G3 X105.773 Y129.523 I.004 J-9.797 E.24776
G1 X105.773 Y117.529 E.1932
G3 X115.566 Y107.736 I9.797 J.004 E.24776
G1 X152.593 Y107.738 E.59643
G3 X154.353 Y109.532 I-.034 J1.794 E.04484
G1 X154.353 Y111.521 E.03204
G3 X153.705 Y112.912 I-1.847 J-.014 E.0255
; WIPE_START
M204 S10000
G1 X153.704 Y114.912 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.232 Y108.458 Z.964 F30000
G1 Z.564
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X149.996 Y108.583 E.00462
G2 X151.874 Y108.364 I1.178 J1.944 E.21362
G1 X151.912 Y108.152 E.00373
G3 X152.707 Y108.158 I.335 J7.623 E.01378
G3 X153.94 Y109.543 I-.167 J1.389 E.03509
G1 X153.94 Y111.51 E.03407
G3 X153.539 Y112.496 I-1.447 J-.013 E.01888
G1 X153.278 Y112.747 E.00627
G1 X153.278 Y134.306 E.3734
G3 X153.873 Y135.107 I-1.218 J1.526 E.01747
G3 X153.94 Y135.543 I-1.517 J.454 E.00767
G1 X153.94 Y137.51 E.03407
G3 X152.547 Y138.903 I-1.383 J.01 E.03796
G1 X151.916 Y138.903 E.01092
G1 X151.883 Y138.685 E.00382
G2 X150.136 Y138.552 I-.715 J-2.156 E.21607
G1 X150.467 Y138.698 E.00627
G1 X150.424 Y138.903 E.00361
G1 X115.571 Y138.903 E.60365
G3 X106.187 Y129.518 I-.001 J-9.383 E.25532
G1 X106.187 Y117.534 E.20756
G3 X115.571 Y108.15 I9.383 J-.001 E.25532
G1 X150.438 Y108.152 E.60388
G1 X150.476 Y108.364 E.00373
G2 X150.287 Y108.434 I.699 J2.163 E.00349
; WIPE_START
G1 X149.996 Y108.583 E-.12407
G1 X149.794 Y108.718 E-.0925
G1 X149.59 Y108.894 E-.10243
G1 X149.408 Y109.093 E-.10237
G1 X149.251 Y109.312 E-.10247
G1 X149.121 Y109.548 E-.10242
G1 X149.02 Y109.798 E-.10238
G1 X148.998 Y109.877 E-.03137
; WIPE_END
G1 E-.04 F1800
G1 X143.748 Y115.418 Z.964 F30000
G1 X125.277 Y134.91 Z.964
G1 Z.564
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.252 Y134.939 E.00062
G3 X125.124 Y135.05 I-.525 J-.478 E.00273
G1 X125.076 Y135.082 E.00094
G3 X120.323 Y111.175 I-4.367 J-11.558 E.69094
G3 X132.315 Y127.79 I.387 J12.355 E.38906
G3 X131.875 Y128.211 I-.727 J-.319 E.01007
G1 X131.819 Y128.229 E.00095
G3 X131.084 Y128.017 I-.143 J-.886 E.01273
G3 X130.807 Y127.196 I.439 J-.605 E.01489
G2 X113.677 Y115.416 I-10.1 J-3.658 E.45536
G1 X115.118 Y116.856 E.03282
G1 X115.401 Y117.139 E.00644
G1 F4018.783
G1 X115.473 Y117.212 E.00165
G1 F2880
G3 X118.629 Y115.587 I5.268 J6.358 E.05762
G1 F3000
G3 X119.038 Y115.491 I2.22 J8.521 E.00677
G1 F2880
G3 X119.494 Y115.407 I2.635 J12.917 E.00747
G1 F3100.72
G1 X119.515 Y115.403 E.00034
G1 F8283.958
G1 X119.728 Y115.708 E.006
G1 F9000
G1 X119.903 Y115.874 E.00389
G2 X120.31 Y116.101 I.898 J-1.135 E.00752
G2 X121.613 Y115.8 I.386 J-1.302 E.02253
G1 X121.75 Y115.643 E.00336
G1 F6922.06
G1 X121.912 Y115.402 E.00468
G1 F3097.73
G1 X121.933 Y115.406 E.00034
G1 F2880
G3 X128.834 Y122.307 I-1.253 J8.154 E.16822
G1 F3097.71
G1 X128.838 Y122.327 E.00034
G1 F8303.58
G1 X128.531 Y122.541 E.00602
G1 F9000
G1 X128.365 Y122.716 E.00389
G2 X128.139 Y123.123 I1.136 J.899 E.00752
G2 X128.44 Y124.426 I1.301 J.386 E.02253
G1 X128.597 Y124.564 E.00336
G1 F6922.862
G1 X128.838 Y124.725 E.00468
G1 F3097.71
G1 X128.834 Y124.746 E.00034
G1 F2880
G3 X121.933 Y131.647 I-8.174 J-1.273 E.16814
G1 F3097.73
G1 X121.912 Y131.651 E.00034
G1 F6922.06
G1 X121.75 Y131.41 E.00468
G1 F9000
G1 X121.608 Y131.258 E.00335
G2 X121.225 Y130.993 I-1.082 J1.153 E.00753
G2 X119.813 Y131.253 I-.498 J1.258 E.02437
G1 X119.676 Y131.41 E.00336
G1 F6922.696
G1 X119.514 Y131.651 E.00468
G1 F3097.834
G1 X119.494 Y131.647 E.00034
G1 F2880
G3 X112.593 Y124.746 I1.242 J-8.143 E.16826
G1 F3098.268
G1 X112.589 Y124.725 E.00034
G1 F8280.448
G1 X112.894 Y124.512 E.006
G1 F9000
G1 X113.082 Y124.301 E.00455
G2 X113.3 Y123.891 I-1.207 J-.905 E.00751
G2 X112.957 Y122.596 I-1.318 J-.344 E.02256
G1 X112.83 Y122.489 E.00268
G1 F6922.23
G1 X112.589 Y122.327 E.00468
G1 F3098.664
G1 X112.593 Y122.307 E.00034
G1 F2880
G3 X114.398 Y118.286 I8.194 J1.265 E.07186
G1 F4018.783
G1 X114.326 Y118.214 E.00165
G1 F9000
G1 X114.043 Y117.931 E.00644
G1 X112.603 Y116.49 E.03282
G2 X124.39 Y133.618 I8.113 J7.036 E.45572
G3 X124.739 Y133.588 I.24 J.748 E.00569
G3 X125.339 Y134.101 I-.218 J.861 E.01317
G3 X125.321 Y134.849 I-.612 J.36 E.0127
G1 X125.312 Y134.862 E.00024
M204 S10000
G1 X125.525 Y135.25 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X125.355 Y135.393 E.00383
G1 X125.279 Y135.444 E.00158
G3 X120.314 Y110.761 I-4.573 J-11.921 E.76894
G3 X130.243 Y115.024 I.399 J12.765 E.19322
G3 X132.699 Y127.944 I-9.543 J8.508 E.23925
G3 X132.254 Y128.489 I-1.044 J-.397 E.01241
G3 X130.843 Y128.355 I-.612 J-1.051 E.0262
G3 X130.411 Y127.076 I.625 J-.924 E.02511
G2 X114.291 Y115.444 I-9.704 J-3.537 E.46345
G1 X115.505 Y116.658 E.02974
G3 X119.708 Y114.948 I5.343 J7.112 E.07947
G1 X120.011 Y115.399 E.00941
G2 X121.385 Y115.437 I.703 J-.542 E.02725
G2 X121.721 Y114.945 I-2.898 J-2.332 E.01033
G1 X122.486 Y115.089 E.01349
G3 X127.416 Y118.103 I-1.798 J8.48 E.10204
G3 X129.295 Y122.519 I-7.155 J5.651 E.0841
G1 X128.841 Y122.824 E.00947
G2 X128.802 Y124.199 I.542 J.703 E.02725
G2 X129.295 Y124.534 I2.33 J-2.895 E.01033
G1 X129.151 Y125.299 E.01349
G3 X126.136 Y130.23 I-8.479 J-1.798 E.10204
G3 X121.721 Y132.108 I-5.65 J-7.151 E.08411
G1 X121.416 Y131.654 E.00947
G2 X120.041 Y131.615 I-.703 J.537 E.02729
G2 X119.706 Y132.108 I2.914 J2.343 E.01033
G1 X118.942 Y131.964 E.01346
G3 X114.01 Y128.95 I1.795 J-8.479 E.10208
G3 X112.132 Y124.534 I7.151 J-5.649 E.08411
G1 X112.586 Y124.229 E.00947
G2 X112.627 Y122.856 I-.542 J-.703 E.02719
G2 X112.132 Y122.519 I-2.344 J2.91 E.01039
G3 X113.844 Y118.317 I9.025 J1.228 E.07942
G1 X112.631 Y117.104 E.02973
G2 X124.27 Y133.221 I8.095 J6.416 E.46358
G3 X124.616 Y133.163 I.343 J.969 E.0061
G3 X125.701 Y133.9 I-.037 J1.221 E.02399
G3 X125.567 Y135.208 I-.973 J.561 E.02432
; WIPE_START
G1 X125.355 Y135.393 E-.10684
G1 X125.279 Y135.444 E-.03475
G1 X125.132 Y135.512 E-.06161
G1 X124.587 Y135.699 E-.21894
G1 X124.052 Y135.856 E-.212
G1 X123.73 Y135.936 E-.12585
; WIPE_END
G1 E-.04 F1800
G1 X129.085 Y130.497 Z.964 F30000
G1 X150.422 Y108.825 Z.964
G1 Z.564
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.423 Y108.824 E.00002
G3 X151.063 Y108.669 I.751 J1.701 E.01066
G1 X151.285 Y108.669 E.00357
G3 X150.046 Y109.047 I-.111 J1.856 E.16685
G1 X150.371 Y108.855 E.00608
; WIPE_START
M204 S10000
G1 X150.423 Y108.824 E-.02327
G1 X150.631 Y108.747 E-.08421
G1 X151.063 Y108.669 E-.16678
G1 X151.285 Y108.669 E-.08422
G1 X151.504 Y108.695 E-.08379
G1 X151.718 Y108.747 E-.08377
G1 X151.924 Y108.824 E-.08375
G1 X152.121 Y108.925 E-.08377
G1 X152.266 Y109.022 E-.06645
; WIPE_END
G1 E-.04 F1800
G1 X152.409 Y116.653 Z.964 F30000
G1 X152.799 Y137.434 Z.964
G1 Z.564
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.684 Y137.612 E.00341
G3 X151.063 Y134.672 I-1.51 J-1.084 E.1207
G1 X151.285 Y134.672 E.00357
G3 X152.826 Y137.381 I-.111 J1.856 E.05953
M204 S10000
G1 X153.597 Y137.519 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.273902
G1 F15000
G1 X153.6 Y137.504 E.00015
; LINE_WIDTH: 0.247009
G1 X153.625 Y137.355 E.00138
; LINE_WIDTH: 0.198485
G1 X153.649 Y137.209 E.00106
; LINE_WIDTH: 0.15769
G1 X153.665 Y137.053 E.00087
; LINE_WIDTH: 0.126017
G1 X153.681 Y136.905 E.00063
; LINE_WIDTH: 0.0924627
G1 X153.69 Y136.306 E.00172
; LINE_WIDTH: 0.114239
G1 X153.668 Y136.007 E.00113
; LINE_WIDTH: 0.156741
G1 X153.647 Y135.853 E.00085
; LINE_WIDTH: 0.197229
G1 X153.627 Y135.706 E.00106
; LINE_WIDTH: 0.232525
G1 X153.612 Y135.623 E.00072
; LINE_WIDTH: 0.262502
G1 X153.598 Y135.552 E.00071
; LINE_WIDTH: 0.298355
G1 X153.569 Y135.422 E.00148
; LINE_WIDTH: 0.325272
G1 X153.558 Y135.383 E.0005
; LINE_WIDTH: 0.356968
G2 X153.498 Y135.224 I-1.578 J.505 E.00231
; LINE_WIDTH: 0.391333
G2 X153.258 Y134.846 I-1.303 J.56 E.00672
G1 X153.095 Y134.427 E.00671
G1 X151.805 Y133.98 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X150.208 Y134.086 I-.607 J2.937 E.02807
G1 X152.526 Y131.767 E.05679
G1 X152.526 Y130.637 E.01958
G1 X130.402 Y108.513 E.54192
G1 X129.725 Y108.513 E.01172
G1 X126.496 Y111.742 E.07909
G2 X125.527 Y111.314 I-5.819 J11.866 E.01835
G1 X122.728 Y108.515 E.06857
G1 X122.047 Y108.515 E.01179
G1 X120.148 Y110.414 E.04652
G2 X117.368 Y110.831 I.547 J13.126 E.04878
G1 X115.059 Y108.522 E.05656
G2 X114.277 Y108.609 I.219 J5.508 E.01364
G1 X106.646 Y116.24 E.18691
G3 X106.759 Y115.574 I4.709 J.46 E.0117
G1 X108.929 Y117.744 E.05314
G2 X107.595 Y122.966 I12.3 J5.922 E.09397
G1 X106.543 Y124.019 E.02578
G1 X106.543 Y123.034 E.01706
G1 X107.596 Y124.087 E.0258
G2 X108.929 Y129.309 I13.181 J-.583 E.09401
G1 X106.765 Y131.473 E.05301
G3 X106.646 Y130.813 I3.396 J-.951 E.01164
G1 X114.277 Y138.444 E.18691
G2 X115.067 Y138.522 I.807 J-4.091 E.01378
G1 X117.375 Y136.214 E.05654
G2 X120.153 Y136.644 I3.327 J-12.314 E.04878
G1 X122.056 Y138.547 E.04661
G1 X122.719 Y138.547 E.01148
G1 X125.626 Y135.64 E.0712
G2 X132.566 Y128.699 I-226.192 J-233.133 E.17001
G2 X132.824 Y128.442 I-1.091 J-1.349 E.00632
G1 X149.112 Y112.153 E.39897
G3 X148.726 Y111.485 I4.875 J-3.263 E.01338
G1 X145.75 Y108.509 E.0729
G1 X145.081 Y108.509 E.01159
G1 X133.409 Y120.181 E.28588
G3 X133.408 Y126.871 I-12.759 J3.344 E.11716
G1 X145.084 Y138.547 E.28598
G1 X145.747 Y138.547 E.01148
G1 X148.733 Y135.561 E.07314
G3 X149.111 Y134.898 I2.677 J1.091 E.01326
G1 X132.926 Y118.713 E.39645
G2 X130.789 Y115.124 I-12.638 J5.094 E.07262
G1 X137.403 Y108.511 E.16199
G1 X138.076 Y108.511 E.01166
G1 X152.526 Y122.961 E.35395
G1 X152.526 Y124.091 E.01958
G1 X138.071 Y138.547 E.35407
G1 X137.408 Y138.547 E.01148
G1 X128.114 Y129.253 E.22764
G2 X130.072 Y124.478 I-7.985 J-6.063 E.09041
G2 X129.481 Y124.109 I-.526 J.184 E.01304
G1 X130.662 Y122.928 E.02893
G3 X130.656 Y124.119 I-12.308 J.534 E.02064
G1 X129.478 Y122.941 E.02885
G1 X129.55 Y122.982 E.00142
G2 X130.072 Y122.576 I.025 J-.507 E.01249
G2 X128.119 Y117.795 I-9.846 J1.233 E.09049
G1 X128.543 Y117.371 E.01039
G2 X124.085 Y114.153 I-8.049 J6.455 E.09639
G1 X123.616 Y114.622 E.01147
G2 X121.665 Y114.167 I-4.195 J13.607 E.03473
G2 X121.296 Y114.759 I.185 J.526 E.01304
G1 X120.121 Y113.584 E.02877
G2 X115.573 Y114.988 I.614 J10.053 E.08322
G1 X114.956 Y115.606 E.01513
G1 X115.546 Y116.196 E.01445
G3 X116.21 Y115.762 I3.357 J4.415 E.01376
; WIPE_START
G1 X115.546 Y116.196 E-.30159
G1 X114.956 Y115.606 E-.31699
G1 X115.219 Y115.343 E-.14143
; WIPE_END
G1 E-.04 F1800
G1 X121.727 Y114.558 Z.964 F30000
G1 Z.564
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.362505
G1 F15000
G3 X123.466 Y114.96 I-2.043 J12.804 E.02463
G3 X126.871 Y116.969 I-3.074 J9.099 E.05488
G3 X128.729 Y119.447 I-6.414 J6.745 E.0429
G1 X129.256 Y120.7 E.01874
G1 X129.44 Y121.346 E.00926
G1 X129.67 Y122.454 E.0156
; WIPE_START
G1 X129.44 Y121.346 E-.43004
G1 X129.256 Y120.7 E-.25525
G1 X129.18 Y120.519 E-.07471
; WIPE_END
G1 E-.04 F1800
G1 X125.146 Y126.999 Z.964 F30000
G1 X121.725 Y132.495 Z.964
G1 Z.564
G1 E.8 F1800
; LINE_WIDTH: 0.361729
G1 F15000
G2 X123.699 Y132.013 I-2.55 J-14.711 E.02796
G1 X124.357 Y131.755 E.00972
G1 X125.197 Y131.329 E.01295
G1 X125.779 Y130.959 E.00949
G1 X126.728 Y130.221 E.01653
G1 X127.397 Y129.554 E.013
G2 X128.502 Y128.024 I-8.271 J-7.14 E.02599
G1 X129.102 Y126.784 E.01895
G1 X129.399 Y125.84 E.01361
G1 X129.669 Y124.599 E.01747
G1 X126.126 Y134.941 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G1 X129.732 Y138.547 E.08832
G1 X130.395 Y138.547 E.01148
G1 X152.526 Y116.415 E.54209
G1 X152.526 Y115.285 E.01957
G1 X150.214 Y112.974 E.05662
G2 X151.813 Y113.078 I.966 J-2.508 E.02818
G1 X152.552 Y112.775 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.361846
G1 F15000
G1 X152.87 Y112.952 E.005
G1 X152.897 Y113.093 E.00198
G1 X152.897 Y134.034 E.28812
; WIPE_START
G1 X152.897 Y132.034 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X153.597 Y137.519 Z.964 F30000
G1 Z.564
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.299053
G1 F15000
G1 X153.568 Y137.632 E.0013
; LINE_WIDTH: 0.34844
G3 X153.503 Y137.824 I-1.993 J-.573 E.00268
; LINE_WIDTH: 0.39317
G1 X153.5 Y137.831 E.00011
G3 X153.132 Y138.333 I-1.363 J-.612 E.00942
; LINE_WIDTH: 0.337505
G3 X152.652 Y138.682 I-3.566 J-4.398 E.00758
G1 X152.523 Y138.687 F30000
; LINE_WIDTH: 0.267598
G1 F15000
G1 X152.883 Y138.51 E.00399
G1 X153.585 Y138.074 E.00823
G1 X153.334 Y138.394 F30000
; LINE_WIDTH: 0.120511
G1 F15000
G1 X152.478 Y138.672 E.00361
G1 X151.653 Y138.554 F30000
; LINE_WIDTH: 0.495699
G1 F15000
G1 X151.544 Y138.697 E.00346
; LINE_WIDTH: 0.537699
G1 X151.431 Y138.845 E.00388
G3 X150.915 Y138.842 I-.228 J-4.122 E.01078
; LINE_WIDTH: 0.526236
G1 X150.812 Y138.698 E.0036
; LINE_WIDTH: 0.494556
G1 X150.709 Y138.555 E.00337
G1 X149.822 Y138.688 F30000
; LINE_WIDTH: 0.102742
G1 F15000
G1 X149.602 Y138.485 E.00098
; WIPE_START
G1 X149.822 Y138.688 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.779 Y131.116 Z.964 F30000
G1 X153.119 Y112.603 Z.964
G1 Z.564
G1 E.8 F1800
; LINE_WIDTH: 0.352352
G1 F15000
G1 X153.18 Y112.413 E.00268
; LINE_WIDTH: 0.383499
G1 X153.242 Y112.222 E.00293
; LINE_WIDTH: 0.398011
G2 X153.5 Y111.829 I-.985 J-.927 E.00719
G1 X153.503 Y111.822 E.00012
; LINE_WIDTH: 0.340441
G2 X153.725 Y111.121 I-5.868 J-2.247 E.00949
G1 X153.665 Y111.051 F30000
; LINE_WIDTH: 0.125474
G1 F15000
G1 X153.681 Y110.898 E.00065
; LINE_WIDTH: 0.0923052
G1 X153.69 Y110.3 E.00172
; LINE_WIDTH: 0.115065
G1 X153.667 Y109.998 E.00115
; LINE_WIDTH: 0.157644
G1 X153.647 Y109.851 E.00082
; LINE_WIDTH: 0.198819
G1 X153.625 Y109.692 E.00115
; LINE_WIDTH: 0.23451
G1 X153.612 Y109.622 E.00061
; LINE_WIDTH: 0.261782
M73 P51 R9
G1 X153.598 Y109.552 E.00069
; LINE_WIDTH: 0.301325
G2 X153.563 Y109.398 I-1.482 J.261 E.00178
; LINE_WIDTH: 0.338593
G1 X153.536 Y109.32 E.00107
; LINE_WIDTH: 0.378497
G2 X153.431 Y109.088 I-2.068 J.799 E.00366
; LINE_WIDTH: 0.397656
G2 X153.141 Y108.731 I-1.203 J.681 E.00703
; LINE_WIDTH: 0.35356
G2 X153.009 Y108.624 I-1.028 J1.137 E.00229
; LINE_WIDTH: 0.301092
G2 X152.582 Y108.367 I-2.676 J3.95 E.00564
G1 X152.489 Y108.366 F30000
; LINE_WIDTH: 0.216105
G1 F15000
G3 X153.481 Y108.817 I-7.061 J16.848 E.00858
G1 X153.665 Y111.051 F30000
; LINE_WIDTH: 0.156733
G1 F15000
G1 X153.65 Y111.198 E.00081
; LINE_WIDTH: 0.173295
G1 X153.649 Y111.207 E.00006
; LINE_WIDTH: 0.198689
G1 X153.624 Y111.354 E.00107
; LINE_WIDTH: 0.247069
G1 X153.6 Y111.501 E.00136
; LINE_WIDTH: 0.273979
G1 X153.421 Y112.308 E.00844
; WIPE_START
G1 X153.6 Y111.501 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.871 Y108.385 Z.964 F30000
G1 Z.564
G1 E.8 F1800
; LINE_WIDTH: 0.0887671
G1 F15000
G2 X149.694 Y108.499 I.04 J.257 E.00059
; WIPE_START
G1 X149.801 Y108.407 E-.50043
G1 X149.871 Y108.385 E-.25957
; WIPE_END
G1 E-.04 F1800
G1 X144.231 Y113.528 Z.964 F30000
G1 X122.521 Y133.324 Z.964
G1 Z.564
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X124.094 Y132.909 I-1.605 J-9.263 E.02821
G1 X123.613 Y132.428 E.0118
G3 X121.664 Y132.885 I-3.915 J-12.285 E.0347
G3 X121.295 Y132.295 I.187 J-.527 E.01302
G1 X120.121 Y133.468 E.02875
G3 X115.563 Y132.054 I.601 J-9.99 E.08346
G1 X112.194 Y128.685 E.08253
G3 X111.338 Y126.899 I12.549 J-7.111 E.03431
G1 X111.817 Y126.421 E.01173
G3 X111.354 Y124.478 I10.924 J-3.628 E.03464
G3 X112.043 Y124.164 I.449 J.073 E.01548
G2 X112.573 Y123.436 I-.18 J-.687 E.0169
G2 X112.361 Y123.101 I-.589 J.139 E.00698
G1 X111.739 Y122.684 E.01297
G3 X112.126 Y120.941 I10.951 J1.52 E.03096
G1 X111.339 Y120.154 E.01927
G3 X112.175 Y118.387 I10.143 J3.714 E.03391
G1 X112.793 Y117.769 E.01513
G1 X113.382 Y118.358 E.01444
G2 X112.949 Y119.024 I4.486 J3.399 E.01377
; WIPE_START
G1 X113.382 Y118.358 E-.30178
G1 X112.793 Y117.769 E-.3168
G1 X112.53 Y118.032 E-.14142
; WIPE_END
G1 E-.04 F1800
G1 X111.745 Y124.539 Z.964 F30000
G1 Z.564
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.36202
G1 F15000
G2 X112.329 Y126.792 I13.127 J-2.201 E.03209
G1 X112.909 Y128.006 E.01852
G1 X113.424 Y128.804 E.01307
G1 X114.018 Y129.541 E.01303
G1 X114.683 Y130.208 E.01297
G1 X115.413 Y130.8 E.01294
G1 X116.194 Y131.309 E.01283
G1 X117.018 Y131.731 E.01275
G1 X118.387 Y132.208 E.01996
G1 X119.641 Y132.482 E.01767
G1 X116.354 Y131.804 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G3 X114.986 Y130.927 I3.194 J-6.484 E.0282
G1 X114.558 Y131.356 E.0105
; WIPE_START
G1 X114.986 Y130.927 E-.23042
G1 X115.598 Y131.374 E-.28789
G1 X116.151 Y131.689 E-.24169
; WIPE_END
G1 E-.04 F1800
G1 X113.617 Y134.571 Z.964 F30000
G1 Z.564
G1 E.8 F1800
G1 F16200
G3 X112.304 Y133.609 I7.839 J-12.073 E.0282
G1 X109.611 Y136.302 E.06596
G3 X108.491 Y135.124 I8.258 J-8.973 E.02819
; WIPE_START
G1 X109.611 Y136.302 E-.61803
G1 X109.875 Y136.038 E-.14198
; WIPE_END
G1 E-.04 F1800
G1 X109.438 Y128.418 Z.964 F30000
G1 X108.491 Y111.93 Z.964
G1 Z.564
G1 E.8 F1800
G1 F16200
G3 X109.613 Y110.752 I6.73 J5.282 E.02821
G1 X112.305 Y113.444 E.06594
G3 X113.617 Y112.481 I9.15 J11.097 E.0282
; CHANGE_LAYER
; Z_HEIGHT: 0.662922
; LAYER_HEIGHT: 0.098963
; WIPE_START
G1 F16200
G1 X112.305 Y113.444 E-.61838
G1 X112.041 Y113.18 E-.14162
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 5/33
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
G17
G3 Z.964 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.191 Y138.251
G1 Z.663
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G3 X152.558 Y139.316 I-1.653 J-.75 E.0331
G1 X115.566 Y139.316 E.59477
G3 X105.773 Y129.523 I.024 J-9.817 E.24717
G1 X105.773 Y117.529 E.19284
G3 X115.566 Y107.736 I9.797 J.004 E.24731
G1 X152.6 Y107.739 E.59545
G3 X154.353 Y109.532 I-.041 J1.793 E.04465
G1 X154.353 Y111.521 E.03198
G3 X154.039 Y112.539 I-1.825 J-.006 E.01738
G1 X153.793 Y112.832 E.00615
G1 F7419.994
G1 X153.793 Y112.883 E.00083
G1 F6600
G1 X153.792 Y113.483 E.00965
G1 F7200
G1 X153.792 Y113.883 E.00643
G1 X153.792 Y114.926 E.01677
G2 X153.791 Y116.126 I1058.823 J.829 E.01929
G1 X153.792 Y133.17 E.27403
G1 X153.793 Y133.569 E.00643
G1 F6600
G1 X153.793 Y134.169 E.00965
G1 F7419.667
G1 X153.793 Y134.221 E.00083
G1 F9000
G1 X154.039 Y134.514 E.00615
G3 X154.353 Y135.532 I-1.511 J1.024 E.01738
G1 X154.353 Y137.521 E.03198
G3 X154.215 Y138.196 I-1.815 J-.019 E.01115
; WIPE_START
M204 S10000
G1 X154.011 Y138.578 E-.16459
G1 X153.761 Y138.856 E-.14218
G1 X153.458 Y139.076 E-.14217
G1 X153.116 Y139.228 E-.14219
G1 X152.75 Y139.306 E-.14219
G1 X152.68 Y139.31 E-.02668
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1.063 I1.213 J-.094 P1  F30000
G1 X150.279 Y108.437 Z1.063
G1 Z.663
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X150.258 Y108.446 E.00039
G2 X151.875 Y108.364 I.916 J2.079 E.21817
G1 X151.913 Y108.152 E.00372
G3 X152.707 Y108.158 I.338 J7.611 E.01374
G3 X153.94 Y109.543 I-.167 J1.389 E.03502
G1 X153.94 Y111.51 E.03401
G3 X153.619 Y112.407 I-1.405 J.004 E.0168
G1 X153.379 Y112.671 E.00618
G1 X153.379 Y134.381 E.37533
G3 X153.91 Y135.247 I-1.19 J1.326 E.0178
G3 X153.94 Y135.542 I-1.423 J.291 E.00514
G1 X153.94 Y137.51 E.03401
G3 X152.547 Y138.903 I-1.397 J-.004 E.03779
G1 X151.925 Y138.903 E.01075
G1 X151.882 Y138.698 E.00361
G1 X152.025 Y138.635 E.0027
G2 X151.514 Y134.282 I-.852 J-2.107 E.10241
G2 X150.467 Y138.698 I-.335 J2.253 E.11699
G1 X150.424 Y138.903 E.00361
G1 X115.571 Y138.903 E.60254
G3 X106.187 Y129.518 I.018 J-9.402 E.25471
G1 X106.187 Y117.534 E.20718
G3 X115.571 Y108.15 I9.383 J-.001 E.25485
G1 X150.436 Y108.152 E.60275
G1 X150.474 Y108.364 E.00372
G1 X150.335 Y108.416 E.00257
; WIPE_START
G1 X150.258 Y108.446 E-.03135
G1 X150.018 Y108.568 E-.10239
G1 X149.794 Y108.718 E-.10237
G1 X149.59 Y108.894 E-.10248
G1 X149.408 Y109.093 E-.10238
G1 X149.251 Y109.312 E-.10242
G1 X149.121 Y109.548 E-.10244
G1 X149.019 Y109.798 E-.10244
G1 X149.011 Y109.828 E-.01174
; WIPE_END
G1 E-.04 F1800
G1 X143.765 Y115.371 Z1.063 F30000
G1 X125.272 Y134.913 Z1.063
G1 Z.663
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.249 Y134.937 E.00053
G3 X125.076 Y135.082 I-.551 J-.482 E.00365
G3 X120.349 Y111.174 I-4.365 J-11.558 E.69001
G3 X132.315 Y127.79 I.362 J12.355 E.38793
G3 X131.883 Y128.208 I-.73 J-.321 E.00992
G1 X131.819 Y128.229 E.00108
G3 X131.084 Y128.017 I-.143 J-.886 E.01271
G3 X130.807 Y127.196 I.439 J-.605 E.01487
G2 X113.677 Y115.416 I-10.1 J-3.658 E.45453
G1 X115.502 Y117.241 E.0415
G1 F4722.161
G1 X115.567 Y117.306 E.00148
G1 F3600
G1 X115.737 Y117.166 E.00353
G1 F3000
G1 X116.114 Y116.889 E.00753
G1 F3600
G3 X117.139 Y116.285 I5.092 J7.465 E.01914
G1 F3000
G1 X117.565 Y116.09 E.00753
G1 F3600
G3 X118.293 Y115.822 I3.1 J7.296 E.01248
G1 F3000
G3 X119.552 Y115.532 I2.828 J9.408 E.02079
G1 F3342.116
G1 X119.584 Y115.527 E.00052
G1 F8453.515
G1 X119.816 Y115.802 E.00578
G1 F9000
G1 X120.065 Y115.992 E.00504
G2 X121.615 Y115.806 I.649 J-1.151 E.02687
G1 X121.843 Y115.526 E.0058
G1 F3972.493
G1 X121.874 Y115.532 E.00051
G1 F3600
G3 X122.757 Y115.725 I-1.954 J11.019 E.01453
G1 X123.14 Y115.834 E.00641
G1 X123.521 Y115.955 E.00643
G1 F3000
G1 X123.969 Y116.136 E.00776
G1 F3600
G3 X125.049 Y116.714 I-3.703 J8.217 E.01973
G1 F3000
G1 X125.449 Y116.984 E.00775
G1 F3600
G3 X127.255 Y118.791 I-4.776 J6.582 E.04125
G1 F3000
G1 X127.525 Y119.19 E.00775
G1 F3600
G3 X128.266 Y120.667 I-9.313 J5.594 E.02659
G1 F3000
G3 X128.539 Y121.534 I-7.657 J2.89 E.01463
G1 F3600
G3 X128.708 Y122.365 I-8.816 J2.223 E.01364
G1 F3972.729
G1 X128.714 Y122.397 E.00051
G1 F9000
G1 X128.433 Y122.624 E.00581
G2 X128.434 Y124.429 I.965 J.902 E.03193
G1 X128.714 Y124.656 E.0058
G1 F3972.729
G1 X128.708 Y124.687 E.00051
G1 F3600
G3 X128.515 Y125.569 I-11.02 J-1.954 E.01452
G1 X128.405 Y125.953 E.00641
G1 X128.285 Y126.334 E.00643
G1 F3000
G1 X128.104 Y126.782 E.00776
G1 F3600
G3 X127.287 Y128.216 I-9.804 J-4.635 E.02658
G1 F3000
G1 X126.995 Y128.601 E.00776
G1 F3600
G3 X126.423 Y129.237 I-6.282 J-5.075 E.01376
G1 F3000
G1 X126.072 Y129.567 E.00775
G1 F3600
G3 X123.969 Y130.917 I-5.902 J-6.882 E.04031
G1 F3000
G1 X123.521 Y131.098 E.00776
G1 F3600
G3 X121.874 Y131.521 I-3.601 J-10.596 E.02737
G1 F3972.493
G1 X121.843 Y131.527 E.00051
G1 F9000
G1 X121.615 Y131.246 E.00581
G2 X119.811 Y131.247 I-.902 J.966 E.03192
G1 X119.584 Y131.527 E.0058
G1 F3972.376
G1 X119.552 Y131.521 E.00051
G1 F3600
G1 X119.113 Y131.432 E.00721
G1 X118.721 Y131.352 E.00643
G1 F3000
G1 X118.257 Y131.22 E.00775
G1 F3600
G3 X112.719 Y124.687 I2.518 J-7.749 E.14499
G1 F3972.75
G1 X112.713 Y124.656 E.00051
G1 F9000
G1 X112.993 Y124.429 E.0058
G2 X112.993 Y122.625 I-.965 J-.902 E.03193
G1 X112.713 Y122.397 E.0058
G1 F3974.338
G1 X112.719 Y122.366 E.00052
G1 F3600
G1 X112.803 Y121.949 E.00682
G1 X112.881 Y121.557 E.00643
G1 F3000
G1 X113.009 Y121.106 E.00754
G1 F3600
G3 X113.277 Y120.379 I7.561 J2.37 E.01247
G1 F3000
G1 X113.472 Y119.952 E.00754
G1 F3600
G3 X114.076 Y118.927 I8.067 J4.066 E.01914
G1 F3000
G1 X114.353 Y118.55 E.00753
G1 F3600
G1 X114.493 Y118.38 E.00353
G1 F4722.345
G1 X114.428 Y118.315 E.00148
G1 F9000
G1 X114.145 Y118.033 E.00643
G1 X112.603 Y116.49 E.03507
G2 X124.39 Y133.618 I8.113 J7.036 E.45488
G3 X124.739 Y133.588 I.24 J.748 E.00568
G3 X125.338 Y134.101 I-.218 J.861 E.01315
G3 X125.369 Y134.747 I-.64 J.354 E.01077
G1 X125.302 Y134.861 E.00214
M204 S10000
G1 X125.543 Y135.237 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X125.429 Y135.343 E.00269
G3 X125.279 Y135.444 I-.701 J-.879 E.00312
G3 X120.341 Y110.761 I-4.57 J-11.921 E.76787
G3 X132.699 Y127.944 I.371 J12.769 E.43124
G3 X132.013 Y128.601 I-1.03 J-.389 E.01698
G3 X130.844 Y128.355 I-.364 J-1.174 E.02158
G3 X130.411 Y127.076 I.625 J-.924 E.02507
G2 X114.291 Y115.444 I-9.698 J-3.546 E.46283
G1 X115.6 Y116.753 E.03201
G3 X119.755 Y115.076 I5.327 J7.212 E.07829
G1 X120.047 Y115.444 E.00811
G2 X121.261 Y115.559 I.669 J-.595 E.02319
G2 X121.673 Y115.075 I-1.601 J-1.779 E.01104
G1 X122.428 Y115.212 E.01326
G3 X127.026 Y117.849 I-1.74 J8.36 E.09318
G3 X129.165 Y122.567 I-6.688 J5.877 E.09086
G1 X128.796 Y122.86 E.00815
G2 X128.68 Y124.074 I.595 J.669 E.0232
G2 X129.165 Y124.486 I1.779 J-1.601 E.01103
G1 X129.028 Y125.241 E.01326
G3 X126.347 Y129.876 I-8.509 J-1.829 E.09409
G3 X121.673 Y131.978 I-5.822 J-6.696 E.08989
G1 X121.38 Y131.609 E.00815
G2 X120.166 Y131.493 I-.669 J.596 E.02319
G2 X119.754 Y131.978 I1.603 J1.781 E.01104
G3 X114.401 Y129.203 I1.122 J-8.715 E.10639
G3 X112.261 Y124.486 I6.663 J-5.866 E.09087
G1 X112.634 Y124.191 E.00822
G2 X112.689 Y122.915 I-.598 J-.665 E.02459
G2 X112.263 Y122.568 I-2.219 J2.291 E.0095
G3 X113.94 Y118.413 I8.658 J1.078 E.07834
G1 X112.631 Y117.104 E.03201
G2 X124.27 Y133.221 I8.095 J6.416 E.46273
G3 X124.616 Y133.163 I.343 J.969 E.00609
G3 X125.701 Y133.9 I-.037 J1.221 E.02394
G3 X125.584 Y135.193 I-.972 J.564 E.02393
; WIPE_START
G1 X125.429 Y135.343 E-.08192
G1 X125.279 Y135.444 E-.06856
G1 X125.132 Y135.512 E-.0616
G1 X124.587 Y135.699 E-.21894
G1 X124.052 Y135.856 E-.21199
G1 X123.753 Y135.93 E-.11699
; WIPE_END
G1 E-.04 F1800
G1 X129.106 Y130.49 Z1.063 F30000
G1 X150.421 Y108.825 Z1.063
G1 Z.663
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.425 Y108.824 E.00006
G3 X151.064 Y108.669 I.75 J1.701 E.01064
G1 X151.285 Y108.669 E.00354
G3 X150.229 Y108.925 I-.11 J1.856 E.1701
G1 X150.368 Y108.853 E.00252
; WIPE_START
M204 S10000
G1 X150.425 Y108.824 E-.02412
G1 X150.631 Y108.747 E-.08373
G1 X150.845 Y108.695 E-.08377
G1 X151.064 Y108.669 E-.08378
G1 X151.285 Y108.669 E-.08373
G1 X151.504 Y108.695 E-.08379
G1 X151.718 Y108.747 E-.08377
G1 X151.924 Y108.824 E-.08373
G1 X152.121 Y108.924 E-.08377
G1 X152.264 Y109.021 E-.06582
; WIPE_END
G1 E-.04 F1800
G1 X152.408 Y116.652 Z1.063 F30000
G1 X152.8 Y137.433 Z1.063
G1 Z.663
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.684 Y137.612 E.00342
G3 X151.064 Y134.672 I-1.509 J-1.085 E.12044
G1 X151.285 Y134.672 E.00354
G3 X152.826 Y137.38 I-.11 J1.855 E.05941
M204 S10000
G1 X153.597 Y137.519 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.273707
G1 F15000
G1 X153.6 Y137.504 E.00015
; LINE_WIDTH: 0.246842
G1 X153.625 Y137.355 E.00137
; LINE_WIDTH: 0.198338
G1 X153.649 Y137.209 E.00106
; LINE_WIDTH: 0.157542
G1 X153.665 Y137.053 E.00086
; LINE_WIDTH: 0.12586
G1 X153.681 Y136.905 E.00063
; LINE_WIDTH: 0.0922974
G1 X153.69 Y136.306 E.00172
; LINE_WIDTH: 0.114088
G1 X153.668 Y136.007 E.00112
; LINE_WIDTH: 0.156593
G1 X153.647 Y135.853 E.00085
; LINE_WIDTH: 0.197072
G1 X153.627 Y135.706 E.00105
; LINE_WIDTH: 0.232393
G1 X153.611 Y135.622 E.00072
; LINE_WIDTH: 0.262443
G1 X153.598 Y135.551 E.00071
; LINE_WIDTH: 0.298204
G1 X153.569 Y135.423 E.00147
; LINE_WIDTH: 0.325064
G1 X153.558 Y135.383 E.00051
; LINE_WIDTH: 0.356558
G2 X153.498 Y135.226 I-1.565 J.501 E.00226
; LINE_WIDTH: 0.396568
G2 X153.334 Y134.92 I-2.905 J1.36 E.00526
; LINE_WIDTH: 0.364216
G1 X153.328 Y134.888 E.00046
; LINE_WIDTH: 0.343488
G1 X153.183 Y134.484 E.00557
; WIPE_START
G1 X153.328 Y134.888 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X153.597 Y137.519 Z1.063 F30000
G1 Z.663
G1 E.8 F1800
; LINE_WIDTH: 0.298866
G1 F15000
G1 X153.568 Y137.632 E.0013
; LINE_WIDTH: 0.348256
G3 X153.503 Y137.824 I-1.99 J-.572 E.00268
; LINE_WIDTH: 0.392979
G1 X153.5 Y137.831 E.00011
G3 X153.132 Y138.333 I-1.363 J-.612 E.0094
; LINE_WIDTH: 0.337339
G3 X152.652 Y138.682 I-3.573 J-4.407 E.00756
G1 X152.523 Y138.687 F30000
; LINE_WIDTH: 0.267461
G1 F15000
G1 X152.883 Y138.51 E.00398
G1 X153.585 Y138.074 E.00821
G1 X153.334 Y138.393 F30000
; LINE_WIDTH: 0.120309
G1 F15000
G1 X152.479 Y138.672 E.0036
G1 X151.64 Y138.555 F30000
; LINE_WIDTH: 0.49494
G1 F15000
G1 X151.537 Y138.699 E.00337
; LINE_WIDTH: 0.537931
G1 X151.432 Y138.845 E.00377
G3 X150.915 Y138.842 I-.229 J-4.259 E.01078
; LINE_WIDTH: 0.526656
G1 X150.812 Y138.699 E.0036
; LINE_WIDTH: 0.494941
G1 X150.709 Y138.555 E.00337
G1 X149.87 Y138.672 F30000
; LINE_WIDTH: 0.124908
G1 F15000
G1 X149.752 Y138.635 E.00052
; LINE_WIDTH: 0.113892
G1 X149.664 Y138.55 E.00046
; LINE_WIDTH: 0.088126
G1 X149.576 Y138.465 E.00033
; WIPE_START
G1 X149.664 Y138.55 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.306 Y130.945 Z1.063 F30000
G1 X151.813 Y113.078 Z1.063
G1 Z.663
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G3 X150.214 Y112.974 I-.633 J-2.612 E.02813
G1 X153.023 Y115.782 E.06867
G1 X153.023 Y115.918 E.00235
G1 X130.395 Y138.547 E.55324
G1 X129.732 Y138.547 E.01146
G1 X126.126 Y134.941 E.08816
; WIPE_START
G1 X127.54 Y136.355 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.521 Y133.324 Z1.063 F30000
G1 Z.663
G1 E.8 F1800
G1 F16200
G2 X124.094 Y132.909 I-1.606 J-9.265 E.02816
G1 X123.478 Y132.293 E.01506
G3 X121.634 Y132.717 I-3.586 J-11.371 E.03274
G3 X121.261 Y132.329 I.057 J-.428 E.01006
G1 X120.121 Y133.468 E.02786
G3 X115.563 Y132.054 I.601 J-9.989 E.08331
G1 X112.194 Y128.685 E.08238
G3 X111.338 Y126.899 I12.543 J-7.108 E.03425
G1 X112.232 Y126.006 E.02185
G2 X115.358 Y130.556 I8.387 J-2.413 E.09711
G1 X114.558 Y131.356 E.01956
; WIPE_START
G1 X115.358 Y130.556 E-.42994
G1 X114.798 Y130.104 E-.2734
G1 X114.693 Y129.998 E-.05667
; WIPE_END
G1 E-.04 F1800
G1 X108.809 Y134.861 Z1.063 F30000
G1 X108.492 Y135.123 Z1.063
G1 Z.663
G1 E.8 F1800
G1 F16200
G2 X109.618 Y136.296 I6.254 J-4.879 E.02815
G1 X112.304 Y133.609 E.06568
G2 X113.621 Y134.564 I7.711 J-9.253 E.02815
; WIPE_START
G1 X112.304 Y133.609 E-.61821
G1 X112.04 Y133.873 E-.14179
; WIPE_END
G1 E-.04 F1800
G1 X119.579 Y132.68 Z1.063 F30000
G1 X121.687 Y132.346 Z1.063
G1 Z.663
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.361238
G1 F12000
G2 X124.278 Y131.626 I-1.891 J-11.828 E.03694
G1 X124.904 Y131.326 E.00953
G1 X125.746 Y130.801 E.0136
G2 X128.961 Y126.702 I-5.04 J-7.263 E.07249
G1 X129.139 Y126.228 E.00694
G2 X129.522 Y124.561 I-11.312 J-3.474 E.02347
; WIPE_START
G1 X129.363 Y125.391 E-.3214
G1 X129.139 Y126.228 E-.32909
G1 X129.037 Y126.498 E-.10951
; WIPE_END
G1 E-.04 F1800
G1 X123.144 Y121.648 Z1.063 F30000
G1 X116.191 Y115.928 Z1.063
G1 Z.663
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X115.641 Y116.291 I2.221 J3.958 E.0114
G1 X114.956 Y115.606 E.01675
G3 X116.281 Y114.596 I2.426 J1.808 E.02919
G3 X120.121 Y113.584 I4.664 J9.908 E.06903
G1 X121.392 Y114.856 E.03109
G1 X121.529 Y114.687 E.00375
G3 X123.193 Y115.044 I-1.513 J11.089 E.02947
G1 X124.086 Y114.151 E.02183
G3 X128.543 Y117.371 I-3.291 J9.249 E.09633
G1 X127.743 Y118.171 E.01956
G3 X129.553 Y122.713 I-7.342 J5.558 E.08556
G1 X129.384 Y122.847 E.00374
G1 X130.656 Y124.119 E.0311
G2 X130.661 Y122.928 I-11.565 J-.646 E.02059
G1 X129.517 Y124.073 E.02798
G3 X129.904 Y124.449 I-.045 J.433 E.01006
G1 X129.786 Y125.054 E.01067
G3 X127.995 Y129.134 I-8.967 J-1.503 E.07783
G1 X137.408 Y138.547 E.23012
G1 X138.071 Y138.547 E.01146
G1 X153.023 Y123.594 E.36557
G1 X153.023 Y123.458 E.00236
G1 X138.076 Y108.511 E.36545
G1 X137.402 Y108.511 E.01164
G1 X130.796 Y115.117 E.16151
G3 X132.926 Y118.713 I-10.871 J8.867 E.07252
G1 X149.111 Y134.898 E.39572
G2 X148.732 Y135.561 I2.178 J1.685 E.01324
G1 X145.747 Y138.547 E.073
G1 X145.084 Y138.547 E.01146
G1 X133.408 Y126.871 E.28546
G2 X133.405 Y120.185 I-12.677 J-3.337 E.11689
G1 X145.08 Y108.509 E.28545
G1 X145.75 Y108.509 E.01158
G1 X148.726 Y111.485 E.07276
G2 X149.112 Y112.153 I5.263 J-2.596 E.01335
G1 X132.824 Y128.441 E.39823
G3 X125.891 Y135.375 I-217.845 J-210.912 E.16952
G3 X122.719 Y138.547 I-54.193 J-51.021 E.07756
G1 X122.056 Y138.547 E.01146
G1 X120.153 Y136.644 E.04653
G3 X117.368 Y136.222 I1.169 J-17.124 E.04876
G1 X115.067 Y138.522 E.05625
G3 X114.277 Y138.444 I.017 J-4.169 E.01375
G1 X106.646 Y130.813 E.18656
G2 X106.765 Y131.473 I3.516 J-.291 E.01161
G1 X108.929 Y129.309 E.05291
G3 X107.596 Y124.087 I11.848 J-5.805 E.09383
G1 X106.543 Y123.034 E.02575
G1 X106.543 Y124.019 E.01703
G1 X107.595 Y122.964 E.02576
G3 X108.929 Y117.744 I13.178 J.585 E.09381
G1 X106.765 Y115.58 E.05291
G2 X106.646 Y116.24 I3.398 J.951 E.01161
G1 X114.277 Y108.609 E.18657
G3 X115.059 Y108.522 I1.001 J5.422 E.01362
G1 X117.368 Y110.831 E.05645
G3 X120.147 Y110.415 I3.315 J12.652 E.04868
G1 X122.047 Y108.515 E.04644
G1 X122.728 Y108.515 E.01177
G1 X125.527 Y111.314 E.06844
G3 X126.496 Y111.742 I-4.847 J12.287 E.01832
G1 X129.725 Y108.513 E.07894
G1 X130.402 Y108.513 E.01171
G1 X153.023 Y131.134 E.55307
G1 X153.023 Y131.27 E.00236
G1 X150.208 Y134.086 E.06883
G3 X151.805 Y133.979 I.988 J2.778 E.02803
G1 X153.199 Y112.55 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.359094
G1 F15000
G1 X153.339 Y112.134 E.00599
; LINE_WIDTH: 0.392478
G3 X153.501 Y111.827 I2.954 J1.361 E.00519
G1 X153.511 Y111.803 E.00039
; LINE_WIDTH: 0.339322
G2 X153.725 Y111.121 I-6.586 J-2.446 E.00917
G1 X153.665 Y111.051 F30000
; LINE_WIDTH: 0.125329
M73 P52 R9
G1 F15000
G1 X153.681 Y110.898 E.00064
; LINE_WIDTH: 0.0921502
G1 X153.69 Y110.3 E.00171
; LINE_WIDTH: 0.114903
G1 X153.667 Y109.998 E.00114
; LINE_WIDTH: 0.157487
G1 X153.647 Y109.851 E.00082
; LINE_WIDTH: 0.19867
G1 X153.625 Y109.692 E.00115
; LINE_WIDTH: 0.234339
G1 X153.612 Y109.622 E.00061
; LINE_WIDTH: 0.261618
G1 X153.598 Y109.552 E.00069
; LINE_WIDTH: 0.301154
G2 X153.563 Y109.398 I-1.48 J.26 E.00178
; LINE_WIDTH: 0.338441
G1 X153.536 Y109.319 E.00107
; LINE_WIDTH: 0.378332
G2 X153.432 Y109.089 I-2.07 J.8 E.00365
; LINE_WIDTH: 0.397489
G2 X153.141 Y108.731 I-1.203 J.681 E.00702
; LINE_WIDTH: 0.353377
G2 X153.009 Y108.624 I-1.03 J1.14 E.00228
; LINE_WIDTH: 0.300932
G2 X152.582 Y108.367 I-2.672 J3.944 E.00562
G1 X152.49 Y108.367 F30000
; LINE_WIDTH: 0.215919
G1 F15000
G3 X153.48 Y108.817 I-7.173 J17.092 E.00854
G1 X153.665 Y111.051 F30000
; LINE_WIDTH: 0.156576
G1 F15000
G1 X153.65 Y111.198 E.00081
; LINE_WIDTH: 0.173138
G1 X153.649 Y111.207 E.00006
; LINE_WIDTH: 0.198572
G1 X153.624 Y111.354 E.00107
; LINE_WIDTH: 0.247
G1 X153.6 Y111.502 E.00136
; LINE_WIDTH: 0.273872
G1 X153.422 Y112.306 E.00839
; WIPE_START
G1 X153.6 Y111.502 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.87 Y108.386 Z1.063 F30000
G1 Z.663
G1 E.8 F1800
; LINE_WIDTH: 0.0886783
G1 F15000
G2 X149.693 Y108.499 I.04 J.257 E.00059
; WIPE_START
G1 X149.8 Y108.407 E-.50037
G1 X149.87 Y108.386 E-.25963
; WIPE_END
G1 E-.04 F1800
G1 X142.286 Y109.242 Z1.063 F30000
G1 X113.617 Y112.481 Z1.063
G1 Z.663
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X112.305 Y113.444 I7.47 J11.563 E.02815
G1 X109.613 Y110.752 E.06582
G2 X108.491 Y111.93 I5.611 J6.462 E.02816
; WIPE_START
G1 X109.613 Y110.752 E-.61806
G1 X109.877 Y111.016 E-.14194
; WIPE_END
G1 E-.04 F1800
G1 X111.178 Y118.536 Z1.063 F30000
G1 X111.888 Y122.634 Z1.063
G1 Z.663
G1 E.8 F1800
G1 F16200
G3 X112.227 Y121.042 I9.819 J1.262 E.02817
G1 X111.339 Y120.154 E.0217
G3 X112.168 Y118.394 I15.024 J5.995 E.03366
G1 X112.793 Y117.769 E.01527
G1 X113.478 Y118.454 E.01675
G2 X113.114 Y119.004 I3.592 J2.769 E.0114
; CHANGE_LAYER
; Z_HEIGHT: 0.769148
; LAYER_HEIGHT: 0.106227
; WIPE_START
G1 F16200
G1 X113.478 Y118.454 E-.25044
G1 X112.793 Y117.769 E-.36817
G1 X112.53 Y118.032 E-.14139
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 6/33
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
G17
G3 Z1.063 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.197 Y138.254
G1 Z.769
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G3 X152.558 Y139.316 I-1.64 J-.734 E.0355
G1 X115.566 Y139.316 E.63593
G3 X105.773 Y129.523 I.024 J-9.817 E.26427
G1 X105.773 Y117.529 E.20619
G3 X115.566 Y107.736 I9.797 J.004 E.26442
G1 X152.602 Y107.739 E.63669
G3 X154.353 Y109.532 I-.061 J1.812 E.04758
G1 X154.353 Y111.521 E.03419
G3 X154.062 Y112.505 I-1.858 J-.014 E.01787
G1 X153.886 Y112.739 E.00505
G1 F8680.672
G1 X153.886 Y112.79 E.00088
G1 F7800
G1 X153.884 Y114.926 E.03672
G2 X153.884 Y116.126 I720 J.828 E.02063
G1 X153.886 Y134.262 E.31178
G1 F8679.788
G1 X153.886 Y134.313 E.00088
G1 F9000
G1 X154.062 Y134.548 E.00505
G3 X154.353 Y135.532 I-1.568 J.998 E.01787
G1 X154.353 Y137.521 E.03419
G3 X154.22 Y138.198 I-1.797 J-.001 E.01195
; WIPE_START
M204 S10000
G1 X154.011 Y138.578 E-.16473
G1 X153.761 Y138.856 E-.14216
G1 X153.458 Y139.076 E-.14224
G1 X153.116 Y139.228 E-.14214
G1 X152.75 Y139.306 E-.14218
G1 X152.681 Y139.31 E-.02655
; WIPE_END
G1 E-.04 F1800
G1 X152.089 Y131.7 Z1.169 F30000
G1 X150.279 Y108.438 Z1.169
G1 Z.769
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X150.259 Y108.447 E.00042
G2 X151.858 Y108.359 I.916 J2.078 E.23358
G1 X151.896 Y108.149 E.00396
G3 X152.85 Y108.179 I.325 J4.68 E.01767
G3 X153.941 Y109.543 I-.314 J1.37 E.03484
G1 X153.941 Y111.51 E.03638
G3 X153.473 Y112.6 I-1.672 J-.072 E.02241
G1 X153.473 Y134.452 E.40404
G3 X153.941 Y135.542 I-1.204 J1.162 E.02242
G1 X153.941 Y137.51 E.03638
G3 X152.547 Y138.904 I-1.385 J.01 E.04057
G1 X151.916 Y138.904 E.01167
G1 X151.873 Y138.701 E.00385
G1 X152.028 Y138.632 E.00314
G2 X150.706 Y134.307 I-.855 J-2.103 E.12437
G2 X150.476 Y138.701 I.477 J2.228 E.11015
G1 X150.433 Y138.904 E.00385
G1 X115.571 Y138.904 E.64458
G3 X106.185 Y129.518 I.018 J-9.404 E.27246
G1 X106.185 Y117.534 E.22158
G3 X115.571 Y108.149 I9.385 J-.001 E.27261
G1 X150.453 Y108.149 E.64495
G1 X150.491 Y108.359 E.00396
G1 X150.335 Y108.417 E.00307
; WIPE_START
G1 X150.259 Y108.447 E-.03133
G1 X150.018 Y108.569 E-.1023
G1 X149.795 Y108.719 E-.10235
G1 X149.591 Y108.895 E-.10238
G1 X149.409 Y109.094 E-.1023
G1 X149.252 Y109.313 E-.10234
G1 X149.122 Y109.549 E-.10242
G1 X149.021 Y109.798 E-.10231
G1 X149.012 Y109.829 E-.01227
; WIPE_END
G1 E-.04 F1800
G1 X143.766 Y115.373 Z1.169 F30000
G1 X125.267 Y134.92 Z1.169
G1 Z.769
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.249 Y134.937 E.00042
G3 X125.076 Y135.082 I-.551 J-.482 E.0039
G3 X120.377 Y111.174 I-4.365 J-11.558 E.73822
G3 X132.315 Y127.79 I.335 J12.356 E.41431
G3 X131.891 Y128.206 I-.734 J-.324 E.01046
G1 X131.819 Y128.229 E.0013
G3 X131.084 Y128.017 I-.143 J-.886 E.01359
G3 X130.807 Y127.196 I.439 J-.605 E.0159
G2 X113.677 Y115.416 I-10.093 J-3.668 E.48626
G1 X115.314 Y117.052 E.03978
G1 X115.597 Y117.335 E.00688
G1 F6497.996
G1 X115.65 Y117.388 E.00129
G1 F5400
G3 X118.741 Y115.819 I5.209 J6.431 E.06004
G1 X119.145 Y115.722 E.00715
G1 F4800
G1 X119.621 Y115.639 E.00831
G1 F5259.522
G1 X119.655 Y115.633 E.00059
G1 F9000
G1 X119.937 Y115.909 E.00677
G2 X121.613 Y115.808 I.776 J-1.078 E.03124
G1 X121.772 Y115.633 E.00406
G1 F5886.523
G1 X121.805 Y115.639 E.00059
G1 F5400
G3 X128.6 Y122.434 I-1.14 J7.935 E.17715
G1 F5885.924
G1 X128.606 Y122.468 E.00059
G1 F9000
G1 X128.431 Y122.627 E.00406
G2 X128.331 Y124.303 I.978 J.9 E.03124
G1 X128.606 Y124.585 E.00677
G1 F5885.924
G1 X128.6 Y124.618 E.00059
G1 F5400
G3 X121.805 Y131.413 I-7.935 J-1.14 E.17715
G1 F5886.379
G1 X121.772 Y131.419 E.00059
G1 F9000
G1 X121.613 Y131.244 E.00406
G2 X119.937 Y131.144 I-.9 J.978 E.03125
G1 X119.655 Y131.419 E.00677
G1 F5886.236
G1 X119.621 Y131.413 E.00059
G1 F5400
G3 X112.826 Y124.618 I1.14 J-7.935 E.17715
G1 F5885.949
G1 X112.82 Y124.585 E.00059
G1 F9000
G1 X112.997 Y124.427 E.00406
G2 X113.098 Y122.748 I-.964 J-.901 E.03137
G1 X112.82 Y122.468 E.00678
G1 F5259.386
G1 X112.826 Y122.434 E.00059
G1 F4800
G1 X112.909 Y121.958 E.00831
G1 F5400
G1 X113.008 Y121.57 E.00688
G1 X113.119 Y121.165 E.00723
G3 X114.575 Y118.463 I7.881 J2.504 E.05307
G1 F6497.996
G1 X114.522 Y118.41 E.00129
G1 F9000
G1 X114.239 Y118.127 E.00688
G1 X112.603 Y116.49 E.03978
G2 X124.39 Y133.618 I8.113 J7.036 E.48636
G3 X124.739 Y133.588 I.24 J.748 E.00608
G3 X125.339 Y134.101 I-.218 J.861 E.01406
G3 X125.369 Y134.747 I-.64 J.354 E.01151
G1 X125.297 Y134.869 E.00243
M204 S10000
G1 X125.541 Y135.236 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X125.428 Y135.342 E.00287
G3 X125.279 Y135.443 I-.7 J-.878 E.00333
G3 X120.368 Y110.761 I-4.57 J-11.92 E.82163
G3 X132.698 Y127.943 I.344 J12.768 E.46065
G3 X132.253 Y128.488 I-1.042 J-.397 E.01323
G3 X130.844 Y128.353 I-.611 J-1.05 E.02794
G3 X130.412 Y127.076 I.624 J-.923 E.02677
G2 X114.288 Y115.444 I-9.699 J-3.547 E.49511
G1 X115.682 Y116.837 E.03644
G3 X119.801 Y115.19 I5.239 J7.124 E.08291
G1 X120.101 Y115.504 E.00803
G2 X121.152 Y115.635 I.616 J-.663 E.02091
G2 X121.626 Y115.189 I-1.131 J-1.679 E.01208
G3 X126.31 Y117.3 I-1.072 J8.635 E.09643
G3 X129.05 Y122.614 I-5.844 J6.377 E.11287
G1 X128.736 Y122.914 E.00804
G2 X128.605 Y123.965 I.663 J.616 E.02091
G2 X129.05 Y124.439 I1.679 J-1.131 E.01208
G3 X126.94 Y129.123 I-8.64 J-1.075 E.09643
G3 X121.626 Y131.863 I-6.377 J-5.844 E.11287
G1 X121.325 Y131.549 E.00804
G2 X120.275 Y131.418 I-.616 J.663 E.02091
G2 X119.801 Y131.863 I1.131 J1.679 E.01208
G3 X115.116 Y129.753 I1.072 J-8.634 E.09643
G3 X112.376 Y124.439 I5.844 J-6.377 E.11287
G1 X112.691 Y124.139 E.00804
G2 X112.857 Y123.153 I-.656 J-.617 E.01959
G2 X112.377 Y122.614 I-1.637 J.974 E.01343
G3 X114.024 Y118.495 I8.77 J1.12 E.08291
G1 X112.631 Y117.101 E.03644
G2 X124.27 Y133.223 I8.095 J6.418 E.49499
G3 X124.616 Y133.164 I.342 J.968 E.00651
G3 X125.699 Y133.901 I-.037 J1.22 E.02558
G3 X125.583 Y135.193 I-.971 J.563 E.02556
; WIPE_START
G1 X125.428 Y135.342 E-.08174
G1 X125.279 Y135.443 E-.06845
G1 X125.132 Y135.511 E-.06154
G1 X124.587 Y135.697 E-.21892
G1 X124.052 Y135.855 E-.2119
G1 X123.752 Y135.929 E-.11745
; WIPE_END
G1 E-.04 F1800
G1 X129.105 Y130.489 Z1.169 F30000
G1 X150.422 Y108.825 Z1.169
G1 Z.769
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.425 Y108.824 E.00006
G3 X151.064 Y108.669 I.75 J1.696 E.01137
G1 X151.285 Y108.669 E.00379
G3 X150.229 Y108.925 I-.11 J1.851 E.18136
G1 X150.368 Y108.853 E.0027
; WIPE_START
M204 S10000
G1 X150.425 Y108.824 E-.02408
G1 X150.631 Y108.747 E-.08372
G1 X150.845 Y108.695 E-.08378
G1 X151.064 Y108.669 E-.08377
G1 X151.285 Y108.669 E-.08374
G1 X151.504 Y108.695 E-.08378
G1 X151.718 Y108.747 E-.08376
G1 X151.924 Y108.824 E-.08374
G1 X152.121 Y108.924 E-.08377
G1 X152.264 Y109.021 E-.06586
; WIPE_END
G1 E-.04 F1800
G1 X152.408 Y116.652 Z1.169 F30000
G1 X152.8 Y137.432 Z1.169
G1 Z.769
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.679 Y137.608 E.00367
G3 X151.064 Y134.672 I-1.504 J-1.085 E.12842
G1 X151.285 Y134.672 E.00379
G3 X152.82 Y137.379 I-.11 J1.851 E.06348
M204 S10000
G1 X153.597 Y137.519 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.30515
G1 F15000
G1 X153.568 Y137.632 E.00142
; LINE_WIDTH: 0.354538
G3 X153.503 Y137.824 I-1.992 J-.573 E.00292
; LINE_WIDTH: 0.39923
G1 X153.5 Y137.83 E.00012
G3 X153.132 Y138.333 I-1.363 J-.611 E.01023
; LINE_WIDTH: 0.343551
G3 X152.649 Y138.684 I-3.588 J-4.427 E.00829
G1 X152.519 Y138.689 F30000
; LINE_WIDTH: 0.273651
G1 F15000
G1 X152.883 Y138.51 E.0044
G1 X153.589 Y138.072 E.00902
G1 X153.339 Y138.393 F30000
; LINE_WIDTH: 0.126455
G1 F15000
G1 X152.47 Y138.674 E.0041
G1 X151.632 Y138.555 F30000
; LINE_WIDTH: 0.478088
G1 F15000
G1 X151.533 Y138.693 E.00334
; LINE_WIDTH: 0.508561
G1 X151.434 Y138.831 E.00357
; LINE_WIDTH: 0.544043
G1 X151.423 Y138.846 E.00042
G3 X150.926 Y138.846 I-.248 J-4.454 E.0112
G1 X150.915 Y138.831 E.00042
; LINE_WIDTH: 0.508551
G1 X150.816 Y138.693 E.00357
; LINE_WIDTH: 0.47809
G1 X150.717 Y138.556 E.00334
G1 X149.88 Y138.671 F30000
; LINE_WIDTH: 0.129467
G1 F15000
G1 X149.753 Y138.633 E.00061
; LINE_WIDTH: 0.115385
G1 X149.665 Y138.548 E.00049
; LINE_WIDTH: 0.089661
G1 X149.577 Y138.463 E.00035
; WIPE_START
G1 X149.665 Y138.548 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X153.597 Y137.519 Z1.169 F30000
G1 Z.769
G1 E.8 F1800
; LINE_WIDTH: 0.279961
G1 F15000
G1 X153.6 Y137.504 E.00017
; LINE_WIDTH: 0.253063
G1 X153.625 Y137.355 E.0015
; LINE_WIDTH: 0.204582
G1 X153.649 Y137.209 E.00116
; LINE_WIDTH: 0.163754
G1 X153.665 Y137.053 E.00096
; LINE_WIDTH: 0.132093
G1 X153.68 Y136.905 E.0007
; LINE_WIDTH: 0.0985258
G1 X153.69 Y136.307 E.00196
; LINE_WIDTH: 0.120292
G1 X153.668 Y136.007 E.00127
; LINE_WIDTH: 0.162811
G1 X153.647 Y135.853 E.00094
; LINE_WIDTH: 0.203303
G1 X153.627 Y135.706 E.00116
; LINE_WIDTH: 0.238646
G1 X153.611 Y135.622 E.00079
; LINE_WIDTH: 0.268743
G1 X153.598 Y135.551 E.00077
; LINE_WIDTH: 0.304418
G1 X153.569 Y135.423 E.00159
; LINE_WIDTH: 0.341565
G1 X153.537 Y135.322 E.00147
; LINE_WIDTH: 0.394029
G2 X153.26 Y134.765 I-3.867 J1.573 E.01001
G1 X153.333 Y134.621 F30000
; LINE_WIDTH: 0.367593
G1 F15000
G3 X153.44 Y135.105 I-3.086 J.934 E.00739
; LINE_WIDTH: 0.385136
G1 X153.423 Y135.107 E.00026
; LINE_WIDTH: 0.355022
G1 X153.407 Y135.109 E.00024
; LINE_WIDTH: 0.315788
G1 X153.372 Y135.102 E.00044
; LINE_WIDTH: 0.267453
G1 X153.338 Y135.096 E.00037
; LINE_WIDTH: 0.219119
G1 X153.304 Y135.09 E.0003
; LINE_WIDTH: 0.170784
G1 X153.27 Y135.083 E.00022
; LINE_WIDTH: 0.122449
G1 X153.235 Y135.077 E.00015
; LINE_WIDTH: 0.0875377
G1 X153.156 Y134.99 E.00033
G1 X151.801 Y133.98 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X150.204 Y134.089 I-.605 J2.883 E.02997
G1 X153.118 Y131.175 E.07619
G1 X153.118 Y131.229 E.001
G1 X130.399 Y108.51 E.59407
G1 X129.728 Y108.51 E.01241
G1 X126.494 Y111.743 E.08454
G2 X125.531 Y111.318 I-5.821 J11.872 E.01949
G1 X122.725 Y108.512 E.07335
G1 X122.049 Y108.513 E.0125
G1 X120.144 Y110.418 E.04981
G2 X117.37 Y110.833 I.527 J13.003 E.05197
G1 X115.057 Y108.52 E.06047
G2 X114.279 Y108.607 I.217 J5.476 E.01448
G1 X106.632 Y116.254 E.19996
G3 X106.763 Y115.578 I7.764 J1.152 E.01273
G1 X108.93 Y117.745 E.05668
G2 X107.598 Y122.964 I12.298 J5.92 E.10025
G1 X106.546 Y124.015 E.02749
G1 X106.546 Y123.036 E.0181
G1 X107.598 Y124.089 E.02752
G2 X108.93 Y129.307 I13.178 J-.585 E.10029
G1 X106.763 Y131.475 E.05668
G3 X106.644 Y130.81 I3.418 J-.957 E.0125
G1 X114.279 Y138.446 E.19966
G2 X115.065 Y138.524 I.802 J-4.067 E.01463
G1 X117.369 Y136.22 E.06025
G2 X120.151 Y136.642 I3.416 J-13.165 E.05211
G1 X122.058 Y138.549 E.04987
G1 X122.717 Y138.549 E.01218
G1 X125.633 Y135.632 E.07626
G2 X132.577 Y128.689 I-316.653 J-323.597 E.18157
G2 X132.816 Y128.449 I-1.232 J-1.471 E.00627
G1 X149.114 Y112.152 E.42615
G3 X148.729 Y111.488 I5.015 J-3.348 E.01419
G1 X145.746 Y108.505 E.07801
G1 X145.084 Y108.505 E.01224
G1 X133.407 Y120.182 E.30533
G3 X133.406 Y126.87 I-12.757 J3.342 E.12501
G1 X145.086 Y138.549 E.30539
G1 X145.745 Y138.549 E.01218
G1 X148.736 Y135.557 E.07823
G3 X149.113 Y134.9 I2.554 J1.026 E.01405
G1 X132.922 Y118.709 E.42335
G2 X130.795 Y115.119 I-12.299 J4.862 E.07749
G1 X137.406 Y108.508 E.17287
G1 X138.072 Y108.508 E.01233
G1 X153.118 Y123.553 E.39342
G1 X153.118 Y123.499 E.001
G1 X138.069 Y138.549 E.39352
G1 X137.41 Y138.549 E.01218
G1 X127.658 Y128.797 E.25499
G2 X129.433 Y124.313 I-7.285 J-5.477 E.09023
G1 X129.353 Y124.237 E.00205
G1 X130.662 Y122.927 E.03424
G3 X130.658 Y124.121 I-10.89 J.556 E.02209
G1 X129.352 Y122.815 E.03416
G1 X129.432 Y122.735 E.0021
G2 X127.658 Y118.256 I-9.158 J1.037 E.09012
G1 X128.544 Y117.369 E.02318
G2 X124.088 Y114.15 I-7.749 J6.032 E.10303
G1 X123.103 Y115.135 E.02577
G2 X121.5 Y114.807 I-3.202 J11.548 E.03027
G1 X121.424 Y114.887 E.00205
G1 X120.113 Y113.576 E.03427
G2 X115.562 Y115 I.623 J9.982 E.08902
G1 X114.954 Y115.607 E.01589
G1 X115.724 Y116.376 E.02011
G3 X116.172 Y116.075 I2.313 J2.962 E.01
; WIPE_START
G1 X115.724 Y116.376 E-.20533
G1 X114.954 Y115.607 E-.41335
G1 X115.217 Y115.344 E-.14132
; WIPE_END
G1 E-.04 F1800
G1 X108.49 Y111.927 Z1.169 F30000
G1 Z.769
G1 E.8 F1800
G1 F16200
G3 X109.616 Y110.755 I8.058 J6.62 E.03009
G1 X112.306 Y113.445 E.07033
G3 X113.621 Y112.487 I8.127 J9.781 E.0301
; WIPE_START
G1 X112.306 Y113.445 E-.61827
G1 X112.042 Y113.181 E-.14173
; WIPE_END
G1 E-.04 F1800
G1 X113.984 Y120.562 Z1.169 F30000
G1 X116.819 Y131.336 Z1.169
G1 Z.769
G1 E.8 F1800
G1 F16200
G3 X115.443 Y130.471 I5.535 J-10.337 E.03008
G1 X114.556 Y131.358 E.02318
; WIPE_START
G1 X115.443 Y130.471 E-.47641
G1 X115.985 Y130.863 E-.25424
G1 X116.052 Y130.901 E-.02935
; WIPE_END
G1 E-.04 F1800
G1 X113.618 Y134.57 Z1.169 F30000
G1 Z.769
G1 E.8 F1800
G1 F16200
G3 X112.306 Y133.608 I7.838 J-12.072 E.0301
G1 X109.61 Y136.304 E.07049
G3 X108.49 Y135.124 I6.196 J-7.005 E.03011
; WIPE_START
G1 X109.61 Y136.304 E-.618
G1 X109.874 Y136.04 E-.142
; WIPE_END
G1 E-.04 F1800
G1 X117.337 Y134.439 Z1.169 F30000
G1 X122.523 Y133.326 Z1.169
G1 Z.769
G1 E.8 F1800
G1 F16200
G2 X124.096 Y132.911 I-1.607 J-9.269 E.03012
G1 X123.098 Y131.913 E.02608
G3 X121.5 Y132.246 I-2.876 J-9.813 E.03021
G1 X121.424 Y132.166 E.00205
G1 X120.119 Y133.47 E.03411
G3 X115.57 Y132.061 I.581 J-9.924 E.08893
M73 P52 R8
G1 X112.187 Y128.678 E.08844
G3 X111.337 Y126.901 I12.614 J-7.131 E.03646
G1 X112.322 Y125.916 E.02577
G3 X111.994 Y124.313 I11.558 J-3.204 E.03027
G2 X112.573 Y123.615 I-.644 J-1.124 E.01715
G2 X112.48 Y123.219 I-.564 J-.076 E.00768
M73 P53 R8
G1 X111.995 Y122.735 E.01268
G3 X112.322 Y121.137 I11.848 J1.593 E.03018
G1 X111.338 Y120.153 E.02573
G3 X112.162 Y118.4 I15.106 J6.033 E.03584
G1 X112.794 Y117.768 E.01653
G1 X113.563 Y118.537 E.02011
G2 X113.262 Y118.985 I2.953 J2.308 E.01
; WIPE_START
G1 X113.563 Y118.537 E-.20532
G1 X112.794 Y117.768 E-.41336
G1 X112.531 Y118.03 E-.14132
; WIPE_END
G1 E-.04 F1800
G1 X117.313 Y123.979 Z1.169 F30000
G1 X126.124 Y134.939 Z1.169
G1 Z.769
G1 E.8 F1800
G1 F16200
G1 X129.734 Y138.549 E.09438
G1 X130.393 Y138.549 E.01218
G1 X153.118 Y115.823 E.59423
G1 X153.118 Y115.877 E.001
G1 X150.21 Y112.97 E.07603
G2 X151.809 Y113.077 I.971 J-2.504 E.03008
G1 X153.302 Y112.473 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.328517
G1 F15000
G1 X153.417 Y112.058 E.00571
; LINE_WIDTH: 0.354689
G1 X153.427 Y112.005 E.00077
; LINE_WIDTH: 0.392649
G3 X153.503 Y111.822 I.431 J.071 E.00319
G1 X153.505 Y111.819 E.00006
; LINE_WIDTH: 0.346483
G2 X153.727 Y111.113 I-6.24 J-2.358 E.01038
G1 X153.665 Y111.051 F30000
; LINE_WIDTH: 0.131529
G1 F15000
G1 X153.681 Y110.898 E.00072
; LINE_WIDTH: 0.0983591
G1 X153.69 Y110.3 E.00196
; LINE_WIDTH: 0.121149
G1 X153.667 Y109.998 E.00129
; LINE_WIDTH: 0.163736
G1 X153.647 Y109.851 E.00091
; LINE_WIDTH: 0.204923
G1 X153.625 Y109.691 E.00127
; LINE_WIDTH: 0.240613
G1 X153.612 Y109.622 E.00067
; LINE_WIDTH: 0.267869
G1 X153.598 Y109.552 E.00076
; LINE_WIDTH: 0.307333
G2 X153.563 Y109.399 I-1.489 J.263 E.00193
; LINE_WIDTH: 0.344604
G1 X153.536 Y109.32 E.00116
; LINE_WIDTH: 0.384571
G2 X153.431 Y109.088 I-2.062 J.797 E.00398
; LINE_WIDTH: 0.403736
G2 X153.141 Y108.731 I-1.202 J.68 E.00763
; LINE_WIDTH: 0.359606
G2 X153.009 Y108.624 I-1.027 J1.136 E.00248
; LINE_WIDTH: 0.307118
G2 X152.578 Y108.364 I-2.71 J4.003 E.00619
G1 X152.479 Y108.362 F30000
; LINE_WIDTH: 0.222113
G1 F15000
G3 X153.485 Y108.819 I-7.271 J17.343 E.00953
G1 X153.665 Y111.051 F30000
; LINE_WIDTH: 0.162785
G1 F15000
G1 X153.65 Y111.198 E.0009
; LINE_WIDTH: 0.179362
G1 X153.649 Y111.207 E.00006
; LINE_WIDTH: 0.204834
G1 X153.624 Y111.354 E.00118
; LINE_WIDTH: 0.253269
G1 X153.6 Y111.502 E.00149
; LINE_WIDTH: 0.280108
G1 X153.418 Y112.32 E.00934
; WIPE_START
G1 X153.6 Y111.502 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.881 Y108.381 Z1.169 F30000
G1 Z.769
G1 E.8 F1800
; LINE_WIDTH: 0.0912136
G1 F15000
G2 X149.695 Y108.501 I.043 J.271 E.00067
; CHANGE_LAYER
; Z_HEIGHT: 0.9009
; LAYER_HEIGHT: 0.131752
; WIPE_START
G1 F15000
G1 X149.808 Y108.404 E-.50235
G1 X149.881 Y108.381 E-.25765
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 7/33
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
G17
G3 Z1.169 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.197 Y138.254
G1 Z.901
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G3 X152.558 Y139.316 I-1.64 J-.734 E.04343
G1 X115.566 Y139.316 E.77785
G3 X105.773 Y129.523 I.024 J-9.817 E.32326
G1 X105.773 Y117.529 E.25221
G3 X115.566 Y107.736 I9.797 J.004 E.32344
G1 X152.61 Y107.739 E.77896
G3 X154.353 Y109.532 I-.05 J1.792 E.05818
G1 X154.353 Y111.521 E.04183
G3 X154.134 Y112.38 I-1.82 J-.007 E.01884
G1 X153.976 Y112.623 E.00608
G1 F8924.188
G1 X153.976 Y112.688 E.00136
G1 F7800
G1 X153.976 Y134.365 E.45583
G1 F8924.188
G1 X153.976 Y134.43 E.00136
G1 F9000
G1 X154.134 Y134.672 E.00608
G3 X154.353 Y135.532 I-1.6 J.866 E.01884
G1 X154.353 Y137.521 E.04183
G3 X154.22 Y138.198 I-1.797 J-.001 E.01461
; WIPE_START
M204 S10000
G1 X154.011 Y138.578 E-.16474
G1 X153.761 Y138.856 E-.14215
G1 X153.458 Y139.076 E-.14224
G1 X153.116 Y139.228 E-.14216
G1 X152.75 Y139.306 E-.14216
G1 X152.681 Y139.31 E-.02655
; WIPE_END
G1 E-.04 F1800
G1 X152.089 Y131.7 Z1.301 F30000
G1 X150.281 Y108.443 Z1.301
G1 Z.901
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X150.26 Y108.45 E.00049
G2 X151.82 Y108.351 I.915 J2.074 E.2863
G1 X151.858 Y108.143 E.00479
G3 X152.708 Y108.151 I.342 J8.354 E.01925
G3 X153.947 Y109.543 I-.168 J1.396 E.04609
G1 X153.947 Y111.51 E.04455
G3 X153.57 Y112.491 I-1.485 J-.009 E.0243
G1 X153.57 Y134.562 E.49966
G3 X153.947 Y135.542 I-1.108 J.989 E.0243
G1 X153.947 Y137.51 E.04455
G3 X152.547 Y138.91 I-1.39 J.01 E.04987
G1 X151.867 Y138.91 E.01539
G1 X151.835 Y138.694 E.00494
G2 X150.514 Y138.694 I-.66 J-2.166 E.29179
G1 X150.482 Y138.91 E.00494
G1 X115.571 Y138.91 E.79032
G3 X106.18 Y129.518 I.018 J-9.41 E.33378
G1 X106.18 Y117.534 E.2713
G3 X115.571 Y108.143 I9.39 J-.001 E.33397
G1 X150.491 Y108.143 E.79053
G1 X150.529 Y108.351 E.00479
G1 X150.337 Y108.423 E.00463
; WIPE_START
G1 X150.26 Y108.45 E-.03108
G1 X150.021 Y108.574 E-.10212
G1 X149.798 Y108.724 E-.10213
G1 X149.595 Y108.899 E-.10212
G1 X149.414 Y109.097 E-.10207
G1 X149.257 Y109.316 E-.10211
G1 X149.127 Y109.551 E-.1021
G1 X149.026 Y109.8 E-.10212
G1 X149.016 Y109.836 E-.01415
; WIPE_END
G1 E-.04 F1800
G1 X143.768 Y115.377 Z1.301 F30000
G1 X125.316 Y134.86 Z1.301
G1 Z.901
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.249 Y134.937 E.00215
G3 X125.076 Y135.082 I-.551 J-.482 E.00478
G3 X120.408 Y111.173 I-4.365 J-11.558 E.90364
G3 X132.315 Y127.79 I.305 J12.356 E.50613
G3 X131.819 Y128.229 I-.722 J-.315 E.01439
G3 X131.084 Y128.017 I-.143 J-.885 E.01662
G3 X130.807 Y127.196 I.439 J-.605 E.01944
G2 X113.677 Y115.416 I-10.1 J-3.658 E.59444
G1 X115.65 Y117.388 E.05865
G3 X119.655 Y115.634 I5.104 J6.203 E.09312
G2 X121.772 Y115.633 I1.059 J-.793 E.05162
G3 X128.606 Y122.468 I-1.11 J7.944 E.21812
G2 X128.606 Y124.585 I.793 J1.059 E.05162
G3 X121.772 Y131.419 I-7.944 J-1.11 E.21812
G2 X119.655 Y131.419 I-1.059 J.793 E.05162
G3 X112.82 Y124.585 I1.11 J-7.944 E.21812
G2 X112.82 Y122.468 I-.793 J-1.059 E.05162
G3 X114.575 Y118.463 I7.957 J1.099 E.09312
G1 X112.603 Y116.49 E.05865
G2 X124.39 Y133.618 I8.123 J7.03 E.59461
G3 X124.739 Y133.588 I.24 J.748 E.00743
G3 X125.338 Y134.101 I-.218 J.861 E.01719
G3 X125.34 Y134.806 I-.64 J.354 E.01547
M204 S10000
G1 X125.679 Y135.047 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X125.665 Y135.073 E.00067
G3 X125.276 Y135.438 I-.938 J-.609 E.01219
G3 X120.4 Y110.766 I-4.567 J-11.915 E1.00625
G3 X132.693 Y127.941 I.313 J12.763 E.56307
G3 X132.25 Y128.483 I-1.07 J-.422 E.0161
G3 X130.848 Y128.349 I-.608 J-1.045 E.03406
G3 X130.418 Y127.078 I.621 J-.918 E.03263
G2 X114.28 Y115.443 I-9.711 J-3.539 E.60634
G1 X115.682 Y116.845 E.04487
G3 X119.798 Y115.196 I5.238 J7.114 E.10148
G1 X120.1 Y115.51 E.00986
G2 X121.152 Y115.641 I.614 J-.639 E.02573
G2 X121.629 Y115.195 I-1.114 J-1.67 E.01484
G3 X125.246 Y116.494 I-1.19 J9.007 E.08767
G3 X129.044 Y122.611 I-4.677 J7.142 E.16828
G1 X128.73 Y122.913 E.00987
G2 X128.599 Y123.965 I.639 J.614 E.02573
G2 X129.044 Y124.442 I1.67 J-1.115 E.01484
G3 X127.746 Y128.059 I-9.006 J-1.19 E.08767
G3 X121.629 Y131.857 I-7.142 J-4.678 E.16828
G1 X121.327 Y131.543 E.00987
G2 X120.275 Y131.412 I-.614 J.639 E.02573
G2 X119.798 Y131.857 I1.114 J1.67 E.01484
G3 X115.12 Y129.749 I1.035 J-8.541 E.11795
G3 X112.382 Y124.442 I5.837 J-6.371 E.13804
G1 X112.697 Y124.14 E.00987
G2 X112.859 Y123.145 I-.634 J-.614 E.02428
G2 X112.383 Y122.611 I-1.665 J1.006 E.01629
G3 X114.032 Y118.495 I8.754 J1.119 E.10148
G1 X112.63 Y117.093 E.04488
G2 X124.272 Y133.228 I8.086 J6.433 E.60682
G3 X124.616 Y133.17 I.341 J.963 E.00793
G3 X125.694 Y133.904 I-.037 J1.214 E.03118
G3 X125.75 Y134.915 I-.968 J.56 E.0238
G1 X125.708 Y134.994 E.00203
; WIPE_START
G1 X125.665 Y135.073 E-.03408
G1 X125.556 Y135.215 E-.06814
G1 X125.425 Y135.338 E-.06815
G1 X125.276 Y135.438 E-.06816
G1 X125.13 Y135.505 E-.06124
G1 X124.585 Y135.692 E-.21871
G1 X124.05 Y135.849 E-.21196
G1 X123.974 Y135.868 E-.02957
; WIPE_END
G1 E-.04 F1800
G1 X129.311 Y130.411 Z1.301 F30000
G1 X150.422 Y108.825 Z1.301
G1 Z.901
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.425 Y108.824 E.00006
G3 X151.064 Y108.669 I.75 J1.701 E.01391
G1 X151.285 Y108.669 E.00463
G3 X150.187 Y108.95 I-.11 J1.855 E.22137
G1 X150.369 Y108.853 E.00434
; WIPE_START
M204 S10000
G1 X150.425 Y108.824 E-.02387
G1 X150.798 Y108.707 E-.14873
G1 X151.064 Y108.669 E-.10219
G1 X151.285 Y108.669 E-.08373
G1 X151.504 Y108.695 E-.08379
G1 X151.718 Y108.747 E-.08376
G1 X151.924 Y108.824 E-.08375
G1 X152.121 Y108.924 E-.08375
G1 X152.266 Y109.022 E-.06644
; WIPE_END
G1 E-.04 F1800
G1 X152.409 Y116.653 Z1.301 F30000
G1 X152.801 Y137.431 Z1.301
G1 Z.901
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.684 Y137.612 E.00453
G3 X151.064 Y134.672 I-1.509 J-1.085 E.15751
G1 X151.285 Y134.672 E.00463
G3 X152.827 Y137.377 I-.11 J1.855 E.07765
M204 S10000
G1 X153.597 Y137.52 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.327179
G1 F15000
G1 X153.568 Y137.632 E.00186
; LINE_WIDTH: 0.376538
G3 X153.502 Y137.825 I-1.982 J-.569 E.00381
; LINE_WIDTH: 0.421149
G1 X153.5 Y137.831 E.00014
G3 X153.131 Y138.334 I-1.362 J-.611 E.01325
; LINE_WIDTH: 0.365346
G3 X152.636 Y138.694 I-3.701 J-4.57 E.01109
G1 X152.499 Y138.699 F30000
; LINE_WIDTH: 0.295431
G1 F15000
G1 X152.883 Y138.51 E.00614
G1 X153.602 Y138.065 E.01213
G1 X153.369 Y138.375 F30000
; LINE_WIDTH: 0.147708
G1 F15000
G3 X152.44 Y138.682 I-5.453 J-14.975 E.00627
G1 X153.597 Y137.52 F30000
; LINE_WIDTH: 0.301895
G1 F15000
G1 X153.6 Y137.504 E.00024
; LINE_WIDTH: 0.274943
G1 X153.625 Y137.355 E.00199
; LINE_WIDTH: 0.226645
G1 X153.648 Y137.21 E.00157
; LINE_WIDTH: 0.185763
G1 X153.665 Y137.053 E.00134
; LINE_WIDTH: 0.1541
G1 X153.68 Y136.906 E.001
; LINE_WIDTH: 0.120486
G1 X153.69 Y136.307 E.00297
; LINE_WIDTH: 0.142149
G1 X153.668 Y136.008 E.00183
; LINE_WIDTH: 0.184672
G1 X153.647 Y135.853 E.00131
; LINE_WIDTH: 0.225138
G1 X153.627 Y135.706 E.00157
; LINE_WIDTH: 0.260512
G1 X153.611 Y135.622 E.00107
; LINE_WIDTH: 0.290705
G1 X153.598 Y135.551 E.00102
; LINE_WIDTH: 0.329939
G2 X153.563 Y135.401 I-1.487 J.263 E.00249
; LINE_WIDTH: 0.386497
G2 X153.359 Y134.875 I-4.543 J1.46 E.01087
G1 X153.438 Y134.74 F30000
; LINE_WIDTH: 0.327274
G1 F15000
G1 X153.509 Y135.144 E.00659
; LINE_WIDTH: 0.35367
G1 X153.513 Y135.226 E.00143
; LINE_WIDTH: 0.388755
G1 X153.509 Y135.253 E.00053
; LINE_WIDTH: 0.377825
G1 X153.478 Y135.242 E.00062
; LINE_WIDTH: 0.334268
G1 X153.447 Y135.231 E.00054
; LINE_WIDTH: 0.290711
G1 X153.416 Y135.22 E.00046
; LINE_WIDTH: 0.247154
G1 X153.385 Y135.208 E.00039
; LINE_WIDTH: 0.203598
G1 X153.354 Y135.197 E.00031
; LINE_WIDTH: 0.152554
G3 X153.314 Y135.175 I.002 J-.051 E.00032
; LINE_WIDTH: 0.120638
G1 X153.231 Y135.085 E.0006
; LINE_WIDTH: 0.095055
G1 X153.149 Y134.995 E.00044
; WIPE_START
G1 X153.231 Y135.085 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.841 Y138.699 Z1.301 F30000
G1 Z.901
G1 E.8 F1800
; LINE_WIDTH: 0.13809
G1 F15000
G1 X149.758 Y138.626 E.00065
; LINE_WIDTH: 0.12058
G1 X149.671 Y138.542 E.0006
; LINE_WIDTH: 0.0950432
G1 X149.583 Y138.457 E.00044
G1 X130.912 Y138.535 F30000
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.368274
G1 F3000;_EXTRUDE_SET_SPEED
G1 X116.475 Y138.534 E.2635
; Slow Down End
G1 X115.608 Y138.53 F30000
G1 F12000
G3 X114.896 Y138.499 I.321 J-15.407 E.01301
G1 X116.966 Y136.12 F30000
G1 F12000
G2 X123.344 Y136.399 I3.752 J-12.746 E.11766
G1 X126.226 Y135.556 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G3 X125.511 Y136.143 I-2.029 J-1.74 E.02106
G1 X124.891 Y136.375 E.01499
G1 X123.095 Y138.171 E.05749
G1 X121.68 Y138.171 E.03204
G1 X120.537 Y137.028 E.03658
G3 X117.356 Y136.605 I.195 J-13.629 E.07283
G1 X117.058 Y136.532 E.00695
G1 X115.433 Y138.157 E.05203
G1 X115.083 Y138.14 E.00791
G3 X114.267 Y138.056 I.034 J-4.312 E.01861
G1 X114.141 Y138.308 E.00637
G1 X106.729 Y130.911 E.23704
G2 X106.635 Y130.802 I-.347 J.202 E.00329
G2 X106.757 Y131.481 I3.619 J-.299 E.01565
G1 X108.652 Y129.586 E.06068
G2 X112.033 Y133.881 I12.162 J-6.094 E.12459
G1 X109.611 Y136.303 E.07753
G3 X108.485 Y135.13 I5.131 J-6.055 E.03687
G1 X106.578 Y130.034 F30000
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.368994
G1 F3000;_EXTRUDE_SET_SPEED
G1 X106.564 Y129.473 E.01027
G1 X106.563 Y125.342 E.07555
; Slow Down End
G1 X107.959 Y126.677 F30000
; LINE_WIDTH: 0.368274
G1 F12000
G2 X109.939 Y131.05 I12.987 J-3.247 E.08809
G1 X110.002 Y131.209 E.00313
G2 X111.432 Y132.828 I36.503 J-30.81 E.03942
G2 X113.063 Y134.261 I24.314 J-26.025 E.03965
G1 X113.195 Y134.304 E.00252
G2 X114.397 Y135.047 I8.575 J-12.529 E.02581
; WIPE_START
G1 X113.673 Y134.621 E-.31925
G1 X113.195 Y134.304 E-.21803
G1 X113.063 Y134.261 E-.05243
G1 X112.719 Y133.974 E-.17029
; WIPE_END
G1 E-.04 F1800
G1 X114.551 Y131.363 Z1.301 F30000
G1 Z.901
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G1 X115.447 Y130.467 E.02869
G2 X116.824 Y131.33 I12.948 J-19.126 E.0368
G1 X121.541 Y133.445 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.368612
G1 F12000
G2 X123.251 Y133.157 I-.655 J-9.115 E.03171
G1 X124.336 Y132.824 E.02074
G1 X124.841 Y132.825 E.00923
G1 X125.113 Y132.89 E.00511
G1 X125.556 Y133.138 E.00928
G1 X125.84 Y133.445 E.00764
G1 X126.1 Y133.88 E.00926
G1 X126.214 Y134.404 E.0098
G1 X126.158 Y134.864 E.00846
G1 X125.956 Y135.292 E.00865
G1 X125.632 Y135.636 E.00864
G3 X124.825 Y136.002 I-1.458 J-2.142 E.01627
; WIPE_START
G1 X125.257 Y135.849 E-.17417
G1 X125.632 Y135.636 E-.16391
G1 X125.956 Y135.292 E-.17968
G1 X126.158 Y134.864 E-.17996
G1 X126.178 Y134.701 E-.06229
; WIPE_END
G1 E-.04 F1800
G1 X129.328 Y127.749 Z1.301 F30000
G1 X130.544 Y125.065 Z1.301
G1 Z.901
G1 E.8 F1800
; LINE_WIDTH: 0.368274
G1 F12000
G3 X130.347 Y126.051 I-17.372 J-2.951 E.01835
G1 X130.014 Y127.138 E.02075
G1 X130.014 Y127.656 E.00946
G1 X130.171 Y128.125 E.00903
G1 X130.473 Y128.517 E.00901
G1 X131.022 Y128.891 E.01213
G1 X131.52 Y129.029 E.00943
G1 X132.03 Y128.982 E.00935
G1 X132.47 Y128.782 E.00882
G1 X132.821 Y128.462 E.00867
G2 X133.217 Y127.557 I-2.253 J-1.525 E.01813
; WIPE_START
G1 X133.064 Y128.019 E-.18487
G1 X132.821 Y128.462 E-.19203
G1 X132.47 Y128.782 E-.18041
G1 X132.03 Y128.982 E-.18367
G1 X131.98 Y128.986 E-.01903
; WIPE_END
G1 E-.04 F1800
G1 X129.393 Y124.255 Z1.301 F30000
G1 Z.901
G1 E.8 F1800
; LINE_WIDTH: 0.369847
G1 F12000
G1 X129.438 Y124.312 E.00133
G3 X128.758 Y126.922 I-10.582 J-1.363 E.04959
G1 X128.516 Y127.447 E.0106
G1 X128.057 Y128.25 E.01695
G1 X127.514 Y129.003 E.01703
G3 X126.56 Y130.023 I-9.591 J-8.016 E.02562
G3 X122.9 Y131.976 I-6.054 J-6.94 E.07671
G1 X121.582 Y132.244 E.02467
G1 X121.458 Y132.216 E.00234
G1 X121.079 Y131.839 E.0098
G1 X120.863 Y131.697 E.00473
G1 X120.582 Y131.691 E.00515
G1 X120.339 Y131.832 E.00516
G1 X120.039 Y132.148 E.00797
; WIPE_START
G1 X120.339 Y131.832 E-.16527
G1 X120.582 Y131.691 E-.10688
G1 X120.863 Y131.697 E-.10683
G1 X121.079 Y131.839 E-.09812
G1 X121.458 Y132.216 E-.20316
G1 X121.582 Y132.244 E-.04842
G1 X121.663 Y132.228 E-.03131
; WIPE_END
G1 E-.04 F1800
G1 X117.58 Y125.779 Z1.301 F30000
G1 X113.275 Y118.979 Z1.301
G1 Z.901
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G3 X113.573 Y118.536 I3.169 J1.815 E.01209
G1 X112.799 Y117.762 E.02477
G1 X112.141 Y118.42 E.02107
G2 X111.332 Y120.147 I14.611 J7.903 E.0432
G1 X112.332 Y121.147 E.03203
G2 X112.003 Y122.731 I9.686 J2.841 E.03666
G3 X112.548 Y123.321 I-.838 J1.321 E.01837
G3 X112.431 Y123.905 I-.492 J.206 E.01431
G1 X112.002 Y124.317 E.01348
G2 X112.328 Y125.91 I11.864 J-1.601 E.03683
G1 X111.331 Y126.907 E.03193
G2 X112.165 Y128.656 I13.709 J-5.467 E.04391
G1 X115.594 Y132.085 E.10977
G2 X120.112 Y133.477 I5.136 J-8.64 E.10805
G1 X121.157 Y132.432 E.03345
G1 X121.369 Y132.653 E.00693
G2 X123.405 Y132.22 I-2.542 J-16.949 E.04714
G1 X123.793 Y132.608 E.01243
G3 X125.373 Y132.594 I.806 J1.771 E.03684
; WIPE_START
G1 X124.93 Y132.454 E-.1768
G1 X124.612 Y132.428 E-.12118
G1 X124.281 Y132.458 E-.12618
G1 X123.793 Y132.608 E-.19404
G1 X123.529 Y132.344 E-.1418
; WIPE_END
G1 E-.04 F1800
G1 X128.837 Y126.86 Z1.301 F30000
G1 X134.058 Y121.466 Z1.301
G1 Z.901
G1 E.8 F1800
G1 F16200
G2 X133.715 Y119.875 I-14.246 J2.241 E.03686
G1 X145.092 Y108.498 E.36423
G1 X145.739 Y108.498 E.01465
G1 X148.741 Y111.5 E.09612
G2 X149.119 Y112.147 I5.99 J-3.068 E.01696
G1 X133.562 Y127.704 E.49806
G2 X133.646 Y127.432 I-3.059 J-1.093 E.00644
G1 X133.724 Y127.187 E.00582
G1 X145.093 Y138.556 E.364
G1 X145.737 Y138.556 E.01458
G1 X148.75 Y135.544 E.09645
G3 X149.118 Y134.905 I2.536 J1.038 E.01674
G1 X133.573 Y119.36 E.49768
G1 X133.53 Y119.205 E.00364
G1 X133.474 Y119.261 E.0018
G1 X132.909 Y118.696 E.01809
G1 X132.842 Y118.524 E.00419
G1 X132.959 Y118.64 E.00372
G1 X133.237 Y118.45 E.00764
G2 X131.063 Y114.85 I-12.852 J5.305 E.09557
G1 X137.413 Y108.5 E.20329
G1 X138.065 Y108.5 E.01476
G1 X153.216 Y123.651 E.48507
G1 X153.216 Y123.401 E.00566
G1 X138.061 Y138.556 E.48519
G1 X137.417 Y138.556 E.01458
G1 X127.928 Y129.067 E.30381
G2 X129.723 Y124.849 I-7.588 J-5.72 E.10481
G1 X129.847 Y124.179 E.01543
G1 X129.624 Y123.965 E.00698
G1 X130.669 Y122.921 E.03344
G3 X130.665 Y124.128 I-10.209 J.571 E.02734
G1 X129.346 Y122.809 E.04222
G1 X129.424 Y122.731 E.0025
G2 X127.653 Y118.261 I-9.175 J1.049 E.11012
G1 X128.55 Y117.364 E.02872
G2 X124.094 Y114.144 I-7.88 J6.21 E.12607
G1 X123.096 Y115.142 E.03196
G2 X121.504 Y114.815 I-3.129 J11.188 E.03682
G1 X121.429 Y114.892 E.00244
G1 X120.107 Y113.57 E.04234
G2 X115.585 Y114.977 I.62 J9.965 E.10825
G1 X114.949 Y115.613 E.02035
G1 X115.723 Y116.386 E.02476
G3 X116.166 Y116.088 I2.279 J2.907 E.0121
; WIPE_START
G1 X115.723 Y116.386 E-.20299
G1 X114.949 Y115.613 E-.41569
G1 X115.212 Y115.35 E-.14132
; WIPE_END
G1 E-.04 F1800
G1 X113.693 Y108.726 Z1.301 F30000
G1 Z.901
G1 E.8 F1800
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.368413
G1 F3000;_EXTRUDE_SET_SPEED
G3 X115.136 Y108.527 I2.329 J11.535 E.02662
G1 X126.022 Y108.527 E.19877
; Slow Down End
G1 X122.178 Y110.472 F30000
; LINE_WIDTH: 0.368274
M73 P54 R8
G1 F12000
G3 X127.788 Y112.453 I-1.483 J13.132 E.10952
G1 X127.97 Y112.536 E.00365
G3 X130.412 Y114.661 I-9.078 J12.896 E.05919
G3 X131.483 Y115.994 I-11.679 J10.484 E.03122
G1 X131.729 Y116.31 E.00731
G3 X132.411 Y117.551 I-46.709 J26.484 E.02583
G1 X133.343 Y119.914 F30000
G1 F12000
G3 X133.552 Y126.311 I-12.619 J3.613 E.118
G1 X151.794 Y113.074 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G3 X150.196 Y112.955 I-.609 J-2.609 E.03683
G1 X153.216 Y115.975 E.0967
G1 X153.216 Y115.725 E.00566
G1 X130.777 Y138.164 E.7184
G1 X129.356 Y138.171 E.03218
G1 X126.419 Y135.234 E.09403
G2 X126.577 Y134.689 I-1.931 J-.856 E.01288
G1 X131.879 Y129.386 E.16976
G3 X131.081 Y129.331 I-.243 J-2.264 E.01821
G1 X131.101 Y129.311 E.00064
G3 X130.403 Y128.939 I1.322 J-3.325 E.01795
; WIPE_START
G1 X131.101 Y129.311 E-.30063
G1 X131.081 Y129.331 E-.01068
G1 X131.879 Y129.386 E-.30406
G1 X131.61 Y129.655 E-.14463
; WIPE_END
G1 E-.04 F1800
G1 X124.338 Y127.338 Z1.301 F30000
G1 X107.661 Y122.025 Z1.301
G1 Z.901
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.368274
G1 F12000
G3 X120.564 Y110.397 I13.046 J1.504 E.34638
G1 X108.759 Y112.197 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G3 X109.884 Y111.023 I6.401 J5.011 E.03686
G1 X112.043 Y113.182 E.0691
G2 X108.648 Y117.463 I9.346 J10.897 E.12445
G1 X107.081 Y115.896 E.05016
G1 X107.111 Y115.775 E.00282
G1 X113.812 Y109.074 E.21456
G3 X115.43 Y108.893 I1.826 J9.008 E.03689
G1 X117.063 Y110.526 E.05228
G3 X120.54 Y110.022 I3.876 J14.503 E.07972
G1 X121.671 Y108.891 E.03622
G1 X123.103 Y108.89 E.03242
G1 X124.911 Y110.699 E.05789
G3 X126.777 Y111.461 I-5.378 J15.814 E.04564
G1 X129.735 Y108.503 E.09471
G1 X130.391 Y108.503 E.01486
G1 X153.216 Y131.327 E.73075
G1 X153.216 Y131.077 E.00566
G1 X150.192 Y134.102 E.09683
G3 X151.788 Y133.984 I1.006 J2.764 E.0367
G1 X153.438 Y112.313 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.336795
G1 F15000
G1 X153.519 Y111.854 E.00771
; LINE_WIDTH: 0.366233
G2 X153.521 Y111.775 I-.24 J-.046 E.00145
G2 X153.736 Y111.085 I-6.739 J-2.478 E.01311
G1 X153.665 Y111.051 F30000
; LINE_WIDTH: 0.15343
G1 F15000
G1 X153.681 Y110.897 E.00104
; LINE_WIDTH: 0.120285
G1 X153.689 Y110.299 E.00295
; LINE_WIDTH: 0.143161
G1 X153.667 Y109.998 E.00187
; LINE_WIDTH: 0.185735
G1 X153.647 Y109.851 E.00125
; LINE_WIDTH: 0.226901
G1 X153.625 Y109.691 E.00172
; LINE_WIDTH: 0.262659
G1 X153.612 Y109.621 E.00089
; LINE_WIDTH: 0.289802
G1 X153.598 Y109.552 E.001
; LINE_WIDTH: 0.329189
G2 X153.563 Y109.399 I-1.467 J.257 E.00253
; LINE_WIDTH: 0.366479
G1 X153.536 Y109.32 E.00152
; LINE_WIDTH: 0.406524
G2 X153.431 Y109.088 I-2.043 J.788 E.00517
; LINE_WIDTH: 0.425648
G2 X153.141 Y108.731 I-1.202 J.681 E.00986
; LINE_WIDTH: 0.381453
G2 X153.008 Y108.624 I-1.017 J1.124 E.00324
; LINE_WIDTH: 0.329008
G2 X152.564 Y108.356 I-2.781 J4.106 E.00838
G1 X152.461 Y108.354 F30000
; LINE_WIDTH: 0.244007
G1 F15000
G3 X153.502 Y108.827 I-7.664 J18.262 E.01324
G1 X153.665 Y111.051 F30000
; LINE_WIDTH: 0.184673
G1 F15000
G1 X153.65 Y111.197 E.00124
; LINE_WIDTH: 0.201327
G1 X153.648 Y111.208 E.0001
; LINE_WIDTH: 0.226861
G1 X153.624 Y111.354 E.00159
; LINE_WIDTH: 0.275156
G1 X153.6 Y111.501 E.00197
; LINE_WIDTH: 0.302045
G1 X153.597 Y111.517 E.00024
; WIPE_START
G1 X153.6 Y111.501 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.878 Y108.354 Z1.301 F30000
G1 Z.901
G1 E.8 F1800
; LINE_WIDTH: 0.098937
G1 F15000
G1 X149.7 Y108.507 E.00089
; WIPE_START
G1 X149.878 Y108.354 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X142.294 Y109.215 Z1.301 F30000
G1 X107.698 Y113.143 Z1.301
G1 Z.901
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.369387
G1 F12000
G3 X108.488 Y111.962 I6.75 J3.66 E.02605
G1 X109.341 Y111.012 E.02339
G1 X109.988 Y110.462 E.01555
G1 X107.352 Y121.548 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X107.267 Y122.219 I5.89 J1.093 E.01534
G1 X107.639 Y122.438 E.00978
G1 X107.606 Y122.956 E.01175
G1 X106.539 Y124.023 E.03415
G1 X106.538 Y123.029 E.0225
G1 X107.606 Y124.097 E.03418
G2 X107.779 Y125.715 I26.197 J-1.982 E.03684
G1 X106.558 Y121.377 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.368274
G1 F12000
G3 X106.553 Y117.577 I280.376 J-2.226 E.06936
G1 X106.645 Y116.245 E.02435
G1 X106.754 Y115.689 E.01034
; CHANGE_LAYER
; Z_HEIGHT: 1.04529
; LAYER_HEIGHT: 0.144391
; WIPE_START
G1 F12000
G1 X106.645 Y116.245 E-.21526
G1 X106.553 Y117.577 E-.50702
G1 X106.553 Y117.676 E-.03772
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 8/33
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
G17
G3 Z1.301 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.191 Y138.251
G1 Z1.045
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G3 X152.558 Y139.316 I-1.653 J-.749 E.04712
G1 X115.566 Y139.316 E.84658
G3 X105.773 Y129.523 I.004 J-9.797 E.35201
G1 X105.773 Y117.529 E.27449
G3 X115.566 Y107.736 I9.797 J.004 E.35201
G1 X152.62 Y107.74 E.848
G3 X154.353 Y109.532 I-.06 J1.792 E.0631
G1 X154.353 Y111.521 E.04552
G3 X154.067 Y112.495 I-2.003 J-.06 E.02349
G1 X154.067 Y112.568 E.00168
G1 F7800
G1 X154.067 Y134.484 E.50156
G1 F9000
G1 X154.067 Y134.558 E.00168
G3 X154.353 Y135.532 I-1.717 J1.034 E.02349
G1 X154.353 Y137.521 E.04552
G3 X154.215 Y138.196 I-1.815 J-.019 E.01587
; WIPE_START
M204 S10000
G1 X154.011 Y138.578 E-.16464
G1 X153.761 Y138.856 E-.14218
G1 X153.458 Y139.076 E-.14218
G1 X153.116 Y139.228 E-.14219
G1 X152.75 Y139.306 E-.14217
G1 X152.68 Y139.31 E-.02664
; WIPE_END
G1 E-.04 F1800
G1 X152.066 Y131.702 Z1.445 F30000
G1 X150.192 Y108.489 Z1.445
G1 Z1.045
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X150.022 Y108.575 E.00469
G2 X148.95 Y110.938 I1.159 J1.95 E.06807
G2 X151.802 Y108.347 I2.225 J-.415 E.23701
G1 X151.839 Y108.14 E.00518
G3 X152.708 Y108.149 I.351 J8.591 E.02143
G3 X153.949 Y109.542 I-.168 J1.399 E.05028
G1 X153.949 Y111.511 E.04852
G3 X153.663 Y112.383 I-1.609 J-.046 E.02295
G1 X153.663 Y134.67 E.5494
G3 X153.949 Y135.542 I-1.322 J.918 E.02295
G1 X153.949 Y137.51 E.04852
G3 X152.547 Y138.912 I-1.406 J-.004 E.05425
G1 X151.844 Y138.912 E.01733
G1 X151.812 Y138.698 E.00534
G2 X151.497 Y134.29 I-.636 J-2.17 E.15128
G2 X148.95 Y136.94 I-.321 J2.24 E.10574
G2 X150.537 Y138.698 I2.216 J-.405 E.06146
G1 X150.505 Y138.912 E.00534
G1 X115.571 Y138.912 E.86114
G3 X106.177 Y129.518 I-.001 J-9.393 E.36375
G1 X106.177 Y117.534 E.29542
G3 X115.571 Y108.14 I9.393 J-.001 E.36375
G1 X150.51 Y108.14 E.86127
G1 X150.547 Y108.347 E.00518
G2 X150.261 Y108.452 I.634 J2.178 E.00752
G1 X150.245 Y108.461 E.00045
; WIPE_START
G1 X150.022 Y108.575 E-.09511
G1 X149.8 Y108.726 E-.10202
G1 X149.597 Y108.901 E-.10194
G1 X149.416 Y109.099 E-.10202
G1 X149.259 Y109.317 E-.10194
G1 X149.13 Y109.552 E-.102
G1 X149.029 Y109.801 E-.102
G1 X148.992 Y109.935 E-.05297
; WIPE_END
G1 E-.04 F1800
G1 X143.735 Y115.469 Z1.445 F30000
G1 X125.292 Y134.881 Z1.445
G1 Z1.045
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.249 Y134.937 E.00161
G3 X125.076 Y135.082 I-.551 J-.482 E.0052
G3 X120.445 Y111.172 I-4.365 J-11.558 E.98432
G3 X132.315 Y127.79 I.257 J12.364 E.54983
G3 X131.819 Y128.229 I-.724 J-.317 E.01565
G3 X131.084 Y128.017 I-.143 J-.885 E.0181
G3 X130.807 Y127.196 I.439 J-.605 E.02116
G2 X113.677 Y115.416 I-10.1 J-3.658 E.64696
G1 X115.65 Y117.388 E.06383
G3 X119.654 Y115.634 I5.104 J6.203 E.10134
G2 X121.772 Y115.633 I1.059 J-.794 E.05619
G3 X128.606 Y122.467 I-1.081 J7.915 E.23754
G2 X128.606 Y124.585 I.794 J1.059 E.05619
G3 X121.772 Y131.419 I-7.944 J-1.11 E.23738
G2 X119.654 Y131.419 I-1.059 J.794 E.05619
G3 X112.82 Y124.585 I1.11 J-7.944 E.23738
G2 X112.82 Y122.467 I-.794 J-1.059 E.05619
G3 X114.575 Y118.463 I8.162 J1.189 E.10127
G1 X112.603 Y116.49 E.06383
G2 X124.39 Y133.618 I8.123 J7.03 E.64714
G3 X124.739 Y133.588 I.24 J.748 E.00809
G3 X125.339 Y134.101 I-.218 J.861 E.01871
G3 X125.369 Y134.747 I-.641 J.354 E.01533
G1 X125.322 Y134.829 E.00218
M204 S10000
G1 X125.734 Y134.941 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X125.663 Y135.072 E.00366
G3 X125.275 Y135.436 I-.934 J-.607 E.01325
G3 X120.436 Y110.768 I-4.566 J-11.913 E1.09635
G3 X132.69 Y127.94 I.265 J12.769 E.61189
G3 X132.249 Y128.481 I-1.034 J-.394 E.01751
G3 X130.849 Y128.347 I-.606 J-1.043 E.03701
G3 X130.42 Y127.078 I.619 J-.916 E.03545
G2 X114.276 Y115.443 I-9.707 J-3.549 E.66081
G1 X115.681 Y116.848 E.04899
G3 X119.797 Y115.199 I5.238 J7.109 E.11047
G1 X120.1 Y115.514 E.0108
G2 X121.24 Y115.587 I.613 J-.637 E.03061
G2 X121.63 Y115.198 I-1.632 J-2.029 E.01359
G3 X126.305 Y117.306 I-1.036 J8.536 E.12835
G3 X129.041 Y122.609 I-5.833 J6.368 E.15022
G1 X128.725 Y122.913 E.01081
G2 X128.653 Y124.053 I.638 J.613 E.03061
G2 X129.041 Y124.443 I2.028 J-1.63 E.01358
G3 X127.797 Y127.969 I-9.01 J-1.196 E.09284
G1 X127.744 Y128.057 E.00254
G3 X121.63 Y131.854 I-7.144 J-4.684 E.18312
G1 X121.326 Y131.538 E.01081
G2 X120.186 Y131.466 I-.613 J.637 E.03061
G2 X119.796 Y131.854 I1.632 J2.029 E.01359
G3 X115.122 Y129.747 I1.036 J-8.536 E.12835
G3 X112.385 Y124.443 I5.833 J-6.368 E.15022
G1 X112.701 Y124.139 E.01081
G2 X112.773 Y122.999 I-.638 J-.613 E.03061
G2 X112.386 Y122.61 I-2.025 J1.628 E.01358
G3 X112.833 Y120.728 I11.589 J1.762 E.04773
G3 X114.035 Y118.494 I7.924 J2.824 E.06277
G1 X112.63 Y117.089 E.04899
G2 X124.273 Y133.231 I8.086 J6.437 E.66101
G3 X124.616 Y133.172 I.34 J.961 E.00862
G3 X125.692 Y133.905 I-.037 J1.212 E.03388
G3 X125.76 Y134.887 I-.964 J.559 E.02513
; WIPE_START
G1 X125.663 Y135.072 E-.07924
G1 X125.554 Y135.213 E-.06799
G1 X125.423 Y135.336 E-.068
G1 X125.275 Y135.436 E-.06803
G1 X125.128 Y135.503 E-.06115
G1 X124.584 Y135.689 E-.21867
G1 X124.087 Y135.836 E-.19693
; WIPE_END
G1 E-.04 F1800
G1 X129.416 Y130.371 Z1.445 F30000
G1 X150.421 Y108.831 Z1.445
G1 Z1.045
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.631 Y108.747 E.00518
G3 X151.064 Y108.669 I.543 J1.773 E.0101
G1 X151.285 Y108.669 E.00504
G3 X150.365 Y108.852 I-.11 J1.851 E.24501
; WIPE_START
M204 S10000
G1 X150.631 Y108.747 E-.10874
G1 X150.845 Y108.695 E-.08376
G1 X151.064 Y108.669 E-.08378
G1 X151.285 Y108.669 E-.08374
G1 X151.504 Y108.695 E-.08378
G1 X151.718 Y108.747 E-.08377
G1 X151.924 Y108.824 E-.08374
G1 X152.121 Y108.924 E-.08374
G1 X152.262 Y109.02 E-.06495
; WIPE_END
G1 E-.04 F1800
G1 X152.407 Y116.651 Z1.445 F30000
G1 X152.802 Y137.43 Z1.445
G1 Z1.045
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.684 Y137.612 E.00496
G3 X151.064 Y134.672 I-1.509 J-1.085 E.17142
G3 X151.449 Y134.691 I.11 J1.627 E.00884
G1 X151.504 Y134.698 E.00125
G3 X152.828 Y137.376 I-.329 J1.829 E.07943
M204 S10000
G1 X153.596 Y137.52 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.312754
G1 F15000
G1 X153.6 Y137.503 E.00028
; LINE_WIDTH: 0.285766
G1 X153.625 Y137.356 E.00225
; LINE_WIDTH: 0.237535
G1 X153.648 Y137.21 E.00179
; LINE_WIDTH: 0.196621
G1 X153.665 Y137.053 E.00154
; LINE_WIDTH: 0.16495
G1 X153.68 Y136.906 E.00116
; LINE_WIDTH: 0.131319
G1 X153.69 Y136.307 E.00354
; LINE_WIDTH: 0.152941
G1 X153.668 Y136.008 E.00215
; LINE_WIDTH: 0.195473
G1 X153.647 Y135.853 E.00152
; LINE_WIDTH: 0.235966
G1 X153.627 Y135.706 E.00178
; LINE_WIDTH: 0.271359
G1 X153.611 Y135.622 E.00121
; LINE_WIDTH: 0.301586
G1 X153.598 Y135.551 E.00115
; LINE_WIDTH: 0.337091
G1 X153.569 Y135.424 E.00234
; LINE_WIDTH: 0.371261
G2 X153.453 Y135.076 I-3.581 J1.002 E.00734
G1 X153.314 Y135.182 F30000
; LINE_WIDTH: 0.13685
G1 F15000
G1 X153.31 Y135.177 E.00004
; LINE_WIDTH: 0.123191
G1 X153.228 Y135.088 E.00066
; LINE_WIDTH: 0.0977206
G1 X153.146 Y134.998 E.00048
G1 X153.314 Y135.182 F30000
; LINE_WIDTH: 0.162535
G1 F15000
G1 X153.402 Y135.29 E.00108
; LINE_WIDTH: 0.210677
G1 X153.44 Y135.31 E.00045
; LINE_WIDTH: 0.257452
G1 X153.478 Y135.331 E.00057
; LINE_WIDTH: 0.304227
G1 X153.516 Y135.351 E.00069
; LINE_WIDTH: 0.351002
G1 X153.553 Y135.371 E.00081
; LINE_WIDTH: 0.349968
G1 X153.57 Y135.32 E.00099
; LINE_WIDTH: 0.312479
G1 X153.572 Y135.276 E.00074
; LINE_WIDTH: 0.286349
G1 X153.574 Y135.231 E.00067
; LINE_WIDTH: 0.251211
G2 X153.5 Y134.806 I-4.332 J.537 E.00559
G1 X151.769 Y133.983 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X150.175 Y134.118 I-.564 J2.817 E.03995
G1 X153.31 Y130.983 E.1093
G1 X153.31 Y131.421 E.0108
G1 X130.388 Y108.499 E.79911
G1 X129.739 Y108.499 E.016
G1 X128.475 Y109.762 E.04403
G1 X128.049 Y109.335 E.01488
G1 X127.73 Y109.654 E.01109
G1 X127.324 Y109.247 E.01416
G1 X127.904 Y109.8 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.40341
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X135.971 Y117.866 E.59411
G1 X135.65 Y118.187 E.02361
G1 X125.985 Y108.522 E.71184
G1 X125.344 Y108.522 E.03338
G1 X135.33 Y118.508 E.73544
G1 X135.018 Y118.82 E.02298
G1 X138.856 Y122.658 E.28266
G1 X138.847 Y122.666 E.00064
G1 X124.5 Y108.32 E1.0566
G1 X121.105 Y110.238 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.565727
; LAYER_HEIGHT: 0.144391
G1 F12000
G2 X121.108 Y110.348 I-.029 J.056 E.00822
; WIPE_START
G1 X121.038 Y110.354 E-.19773
G1 X121.005 Y110.296 E-.18743
G1 X121.038 Y110.238 E-.18743
G1 X121.105 Y110.238 E-.18742
; WIPE_END
G1 E-.04 F1800
G1 X119.324 Y113.693 Z1.445 F30000
G1 Z1.045
G1 E.8 F1800
; LINE_WIDTH: 0.419435
G1 F12000
G2 X117.56 Y114.109 I1.387 J9.821 E.04148
G1 X116.301 Y114.629 E.03113
G1 X115.122 Y115.318 E.03121
G1 X114.893 Y115.488 E.00652
G1 X115.732 Y116.328 E.02712
G1 X116.44 Y115.87 E.01926
G1 X117.251 Y115.47 E.02067
G3 X119.498 Y114.841 I4.178 J10.581 E.05341
G1 X119.854 Y114.78 E.00825
G1 X120.005 Y114.836 E.00368
G1 X120.422 Y115.251 E.01346
G1 X120.758 Y115.345 E.00797
G1 X120.954 Y115.288 E.00466
G1 X121.416 Y114.838 E.01475
G1 X121.59 Y114.781 E.00418
G3 X124.221 Y115.49 I-1.352 J10.253 E.06246
G1 X125.285 Y116.06 E.02757
G3 X128.666 Y119.859 I-4.561 J7.464 E.11793
G3 X129.084 Y121.006 I-4.166 J2.165 E.02796
G3 X129.45 Y122.6 I-7.38 J2.533 E.03744
G1 X129.435 Y122.778 E.00409
G1 X128.982 Y123.221 E.01447
G1 X128.908 Y123.359 E.00359
; LINE_WIDTH: 0.360207
G1 X128.871 Y123.652 E.00571
G1 X128.933 Y123.792 E.00297
G1 X129.113 Y123.983 E.00507
G1 X129.222 Y123.485 E.00987
; LINE_WIDTH: 0.419812
G1 X129.473 Y123.486 E.00576
G1 X130.577 Y124.59 E.0357
G1 X130.642 Y123.369 E.02797
G1 X130.603 Y122.728 E.01469
G1 X130.453 Y121.6 E.02602
G1 X130.231 Y120.696 E.02129
G2 X129.74 Y119.385 I-108.838 J40.036 E.03203
G2 X128.282 Y117.097 I-10.079 J4.811 E.06222
G1 X127.328 Y116.119 E.03125
M73 P55 R8
G2 X125.074 Y114.604 I-7.307 J8.438 E.06228
G1 X123.812 Y114.091 E.03116
G1 X122.49 Y113.755 E.0312
G2 X120.684 Y113.595 I-1.775 J9.759 E.04153
G1 X119.384 Y113.688 E.02983
; WIPE_START
G1 X120.684 Y113.595 E-.49556
G1 X121.38 Y113.625 E-.26444
; WIPE_END
G1 E-.04 F1800
G1 X126.452 Y119.328 Z1.445 F30000
G1 X129.757 Y123.044 Z1.445
G1 Z1.045
G1 E.8 F1800
; LINE_WIDTH: 0.474957
G1 F12000
G1 X129.701 Y123.134 E.00276
G1 X130.218 Y123.642 E.01894
G1 X130.226 Y123.357 E.00744
; LINE_WIDTH: 0.458892
G1 X130.223 Y123.055 E.00761
; LINE_WIDTH: 0.415826
G1 X130.22 Y122.752 E.00685
G1 X130.071 Y121.66 E.02496
G2 X127.479 Y116.821 I-9.435 J1.939 E.12602
G2 X125.919 Y115.537 I-6.387 J6.169 E.04585
G1 X124.915 Y114.965 E.02615
G1 X123.703 Y114.466 E.02968
G1 X122.656 Y114.194 E.0245
G1 X121.713 Y114.035 E.02164
G1 X120.906 Y113.994 E.0183
G1 X119.8 Y114.037 E.02505
G1 X118.857 Y114.173 E.02159
G1 X117.921 Y114.408 E.02184
G2 X116.487 Y114.975 I5.399 J15.748 E.03492
G2 X115.498 Y115.547 I10.944 J20.059 E.02587
G1 X115.785 Y115.833 E.00917
G1 X116.232 Y115.549 E.012
G1 X117.083 Y115.127 E.0215
G3 X119.827 Y114.403 I4.019 J9.67 E.06445
G1 X120.279 Y114.56 E.01085
G1 X120.638 Y114.917 E.01146
G1 X120.771 Y114.939 E.00305
G1 X121.136 Y114.568 E.01179
G1 X121.544 Y114.395 E.01003
G1 X122.346 Y114.519 E.01838
G1 X123.447 Y114.791 E.02569
G1 X124.356 Y115.132 E.02198
G1 X125.47 Y115.715 E.02847
G3 X129.463 Y120.897 I-4.706 J7.755 E.15151
G3 X129.842 Y122.744 I-9.2 J2.849 E.04275
; LINE_WIDTH: 0.426762
G1 X129.807 Y122.865 E.00294
; LINE_WIDTH: 0.458892
G1 X129.773 Y122.987 E.00318
; WIPE_START
G1 X129.807 Y122.865 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.243 Y117.641 Z1.445 F30000
G1 X120.742 Y114.356 Z1.445
G1 Z1.045
G1 E.8 F1800
; LINE_WIDTH: 0.477487
G1 F12000
G2 X120.738 Y114.452 I-.028 J.047 E.00594
; WIPE_START
G1 X120.687 Y114.452 E-.17914
G1 X120.659 Y114.404 E-.19362
G1 X120.687 Y114.356 E-.19364
G1 X120.742 Y114.356 E-.1936
; WIPE_END
G1 E-.04 F1800
G1 X127.848 Y117.143 Z1.445 F30000
G1 X133.298 Y119.281 Z1.445
G1 Z1.045
G1 E.8 F1800
; LINE_WIDTH: 0.659407
G1 F12000
G1 X133.243 Y119.116 E.00647
; WIPE_START
G1 X133.298 Y119.281 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X130.693 Y125.413 Z1.445 F30000
G1 Z1.045
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.40341
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X129.466 Y124.186 E.09037
G1 X129.37 Y124.731 E.02885
G1 X130.415 Y125.776 E.07696
G3 X130.279 Y126.281 I-4 J-.807 E.02726
G1 X129.274 Y125.276 E.07402
G3 X129.15 Y125.794 I-4.914 J-.902 E.02772
G1 X130.129 Y126.772 E.07206
G1 X130.012 Y127.154 E.02079
G1 X129.999 Y127.284 E.00681
G1 X128.842 Y126.127 E.08524
; WIPE_START
G1 X129.999 Y127.284 E-.62198
G1 X130.012 Y127.154 E-.04966
G1 X130.08 Y126.932 E-.08836
; WIPE_END
G1 E-.04 F1800
G1 X133.466 Y127.043 Z1.445 F30000
G1 Z1.045
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.528787
; LAYER_HEIGHT: 0.144391
G1 F12000
G2 X133.467 Y127.149 I-.026 J.053 E.00702
G1 X133.177 Y136.619 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G1 X134.328 Y135.467 E.04014
G1 X137.421 Y138.56 E.10782
G1 X138.058 Y138.56 E.01569
G1 X153.31 Y123.307 E.53173
G1 X153.31 Y123.745 E.0108
G1 X138.061 Y108.497 E.5316
G1 X137.417 Y108.497 E.01589
G1 X132.313 Y113.6 E.17791
G1 X136.151 Y117.438 E.1338
G1 X145.095 Y108.494 E.31179
G1 X145.735 Y108.494 E.01577
G1 X148.747 Y111.506 E.105
G2 X149.121 Y112.144 I6.385 J-3.32 E.01824
G1 X139.035 Y122.231 E.35164
G1 X139.462 Y122.658 E.01488
G1 X138.166 Y123.953 E.04517
G1 X149.121 Y134.908 E.38189
G2 X148.756 Y135.537 I2.168 J1.676 E.01798
G1 X145.734 Y138.56 E.10538
G1 X145.097 Y138.56 E.01569
G1 X138.166 Y131.629 E.24161
G1 X140.118 Y129.678 E.06803
G1 X139.691 Y129.251 E.01488
G1 X153.31 Y115.631 E.47479
G1 X153.31 Y116.07 E.0108
G1 X150.189 Y112.948 E.10882
G2 X151.786 Y113.072 I1.022 J-2.817 E.03997
G1 X153.453 Y112.16 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.313003
G1 F15000
G1 X153.6 Y111.501 E.0112
; LINE_WIDTH: 0.285966
G1 X153.624 Y111.355 E.00223
; LINE_WIDTH: 0.237726
G1 X153.648 Y111.208 E.00181
; LINE_WIDTH: 0.212165
G1 X153.65 Y111.197 E.00012
; LINE_WIDTH: 0.195462
G1 X153.665 Y111.051 E.00143
; LINE_WIDTH: 0.164228
G1 X153.681 Y110.897 E.00121
; LINE_WIDTH: 0.13111
G1 X153.689 Y110.299 E.00352
; LINE_WIDTH: 0.154024
G1 X153.667 Y109.997 E.00219
; LINE_WIDTH: 0.196601
G1 X153.647 Y109.851 E.00144
; LINE_WIDTH: 0.237797
G1 X153.625 Y109.691 E.00197
; LINE_WIDTH: 0.273605
G1 X153.612 Y109.621 E.00101
; LINE_WIDTH: 0.300726
G1 X153.598 Y109.552 E.00112
; LINE_WIDTH: 0.340046
G2 X153.563 Y109.399 I-1.478 J.26 E.00284
; LINE_WIDTH: 0.377334
G1 X153.536 Y109.319 E.00172
; LINE_WIDTH: 0.417406
G2 X153.431 Y109.088 I-2.039 J.786 E.00578
; LINE_WIDTH: 0.436501
G2 X153.141 Y108.731 I-1.201 J.68 E.01102
; LINE_WIDTH: 0.392292
G2 X153.008 Y108.624 I-1.018 J1.125 E.00364
; LINE_WIDTH: 0.339798
G2 X152.557 Y108.352 I-2.825 J4.173 E.00957
G1 X152.451 Y108.35 F30000
; LINE_WIDTH: 0.254826
G1 F15000
G3 X153.51 Y108.83 I-7.79 J18.576 E.01531
G1 X153.74 Y111.071 F30000
; LINE_WIDTH: 0.361598
G1 F15000
G1 X153.566 Y111.636 E.01149
; LINE_WIDTH: 0.346276
G1 X153.575 Y111.685 E.00094
; LINE_WIDTH: 0.30724
G3 X153.583 Y111.757 I-.129 J.049 E.00119
; LINE_WIDTH: 0.279152
G1 X153.572 Y111.839 E.00121
; LINE_WIDTH: 0.250336
G1 X153.5 Y112.246 E.00533
; WIPE_START
G1 X153.572 Y111.839 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.889 Y108.35 Z1.445 F30000
G1 Z1.045
G1 E.8 F1800
; LINE_WIDTH: 0.102692
G1 F15000
G1 X149.703 Y108.51 E.00103
; WIPE_START
G1 X149.889 Y108.35 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.851 Y115.921 Z1.445 F30000
G1 X153.596 Y137.52 Z1.445
G1 Z1.045
G1 E.8 F1800
; LINE_WIDTH: 0.338069
G1 F15000
G1 X153.568 Y137.632 E.00209
; LINE_WIDTH: 0.387402
G3 X153.502 Y137.825 I-1.972 J-.566 E.00427
; LINE_WIDTH: 0.431989
G1 X153.5 Y137.831 E.00015
G3 X153.131 Y138.334 I-1.362 J-.611 E.01482
; LINE_WIDTH: 0.376142
G3 X152.629 Y138.698 I-3.732 J-4.608 E.0126
G1 X152.425 Y138.686 F30000
; LINE_WIDTH: 0.158387
G1 F15000
G2 X153.376 Y138.374 I-4.768 J-16.116 E.0075
; WIPE_START
G1 X152.425 Y138.686 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.852 Y138.703 Z1.445 F30000
G1 Z1.045
G1 E.8 F1800
; LINE_WIDTH: 0.14219
G1 F15000
G1 X149.76 Y138.623 E.0008
; LINE_WIDTH: 0.123169
G1 X149.673 Y138.539 E.00066
; LINE_WIDTH: 0.0977166
G1 X149.586 Y138.454 E.00048
G1 X124.832 Y133.018 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.40341
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X123.586 Y131.771 E.09182
G3 X123.1 Y131.927 I-1.303 J-3.23 E.02658
G1 X124.078 Y132.905 E.07205
G1 X123.588 Y133.056 E.02673
G1 X122.59 Y132.058 E.07349
G3 X122.051 Y132.16 I-1.229 J-5.012 E.02858
G1 X123.086 Y133.195 E.07622
G1 X122.558 Y133.308 E.02813
G1 X121.044 Y131.795 E.11146
G2 X120.398 Y131.783 I-.33 J.365 E.03674
G1 X122.01 Y133.402 E.11897
G3 X121.656 Y133.435 I-.419 J-2.554 E.01852
G1 X121.147 Y133.18 E.02963
G1 X119.93 Y131.963 E.08967
G1 X115.002 Y131.651 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.419997
; LAYER_HEIGHT: 0.144391
G1 F12000
G2 X120.758 Y133.45 I5.74 J-8.258 E.14017
G3 X119.584 Y132.284 I63.844 J-65.48 E.03785
G1 X119.583 Y132.227 E.00131
G3 X115.659 Y130.686 I1.253 J-8.959 E.09738
G1 X114.86 Y130.054 E.02332
G1 X114.199 Y129.395 E.02135
G3 X113.35 Y128.287 I274.158 J-210.715 E.03195
G1 X112.885 Y127.476 E.0214
G1 X112.51 Y126.622 E.02135
G3 X112.123 Y125.283 I307.472 J-89.42 E.03189
G1 X111.968 Y124.403 E.02044
G1 X112.025 Y124.229 E.00418
G1 X112.391 Y123.877 E.01163
G1 X112.511 Y123.684 E.00521
G1 X112.531 Y123.452 E.00532
G1 X112.441 Y123.238 E.00531
G1 X112.023 Y122.818 E.01356
G1 X111.97 Y122.644 E.00416
G1 X112.215 Y121.367 E.02976
G3 X112.651 Y120.078 I11.21 J3.075 E.03115
G3 X113.288 Y118.863 I133.906 J69.381 E.03141
G1 X113.511 Y118.541 E.00894
G1 X112.675 Y117.706 E.02704
G2 X111.048 Y121.243 I8.332 J5.976 E.08965
G1 X110.826 Y122.589 E.03123
G2 X113.94 Y130.79 I9.888 J.937 E.20793
G1 X114.955 Y131.613 E.0299
G1 X113.57 Y129.851 F30000
; LINE_WIDTH: 0.418422
G1 F12000
G1 X114.195 Y130.494 E.02044
G1 X115.087 Y131.224 E.02628
G1 X115.934 Y131.785 E.02316
G2 X119.763 Y133.012 I4.862 J-8.583 E.09229
G1 X119.327 Y132.576 E.01406
G3 X115.448 Y131.013 I1.56 J-9.466 E.09608
G1 X114.618 Y130.354 E.02417
G1 X113.925 Y129.669 E.0222
G3 X112.549 Y127.667 I8.412 J-7.256 E.05548
G1 X112.154 Y126.777 E.0222
G3 X111.592 Y124.469 I12.314 J-4.22 E.05423
G1 X111.582 Y124.358 E.00254
G1 X111.755 Y123.949 E.01013
G1 X112.112 Y123.589 E.01155
G1 X112.121 Y123.48 E.00249
G1 X111.747 Y123.092 E.01227
G1 X111.585 Y122.753 E.00857
G1 X111.595 Y122.572 E.00414
G1 X111.811 Y121.408 E.02698
G3 X112.723 Y119.09 I8.835 J2.14 E.05695
G3 X113.01 Y118.586 I2.654 J1.179 E.01323
G1 X112.73 Y118.306 E.00904
G2 X111.427 Y121.339 I8.395 J5.403 E.07559
G1 X111.227 Y122.506 E.02698
G2 X111.324 Y125.227 I10.295 J.994 E.06225
G2 X113.532 Y129.804 I9.52 J-1.772 E.11719
G1 X111.619 Y123.479 F30000
; LINE_WIDTH: 0.477567
G1 F12000
G2 X111.614 Y123.576 I-.028 J.047 E.00594
; WIPE_START
G1 X111.563 Y123.576 E-.17913
G1 X111.535 Y123.528 E-.19362
G1 X111.563 Y123.479 E-.19362
G1 X111.619 Y123.479 E-.19363
; WIPE_END
G1 E-.04 F1800
G1 X107.427 Y123.543 Z1.445 F30000
G1 Z1.045
G1 E.8 F1800
; LINE_WIDTH: 0.654331
G1 F12000
G2 X107.594 Y125.584 I12.627 J-.003 E.0752
G1 X107.601 Y123.118 F30000
; LINE_WIDTH: 0.351747
G1 F12000
G3 X107.641 Y122.389 I70.202 J3.485 E.01378
G1 X107.341 Y122.212 E.00658
G1 X107.28 Y123.101 E.01681
; LINE_WIDTH: 0.373864
G1 X107.301 Y123.164 E.00134
; LINE_WIDTH: 0.4172
G1 X107.322 Y123.227 E.00151
; LINE_WIDTH: 0.460536
G1 X107.343 Y123.29 E.00168
; LINE_WIDTH: 0.503872
G1 X107.364 Y123.353 E.00185
; LINE_WIDTH: 0.547207
G1 X107.385 Y123.417 E.00202
; LINE_WIDTH: 0.590543
G1 X107.406 Y123.48 E.00219
; LINE_WIDTH: 0.633879
G1 X107.427 Y123.543 E.00236
G1 X107.449 Y123.49 E.00202
; LINE_WIDTH: 0.590543
G1 X107.471 Y123.437 E.00187
; LINE_WIDTH: 0.547207
G1 X107.492 Y123.385 E.00173
; LINE_WIDTH: 0.503872
G1 X107.514 Y123.332 E.00158
; LINE_WIDTH: 0.460536
G1 X107.535 Y123.279 E.00144
; LINE_WIDTH: 0.4172
G1 X107.557 Y123.226 E.00129
; LINE_WIDTH: 0.373864
G1 X107.578 Y123.174 E.00115
G1 X107.491 Y122.089 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.40341
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X106.554 Y121.152 E.06901
G1 X106.554 Y120.51 E.03342
G1 X107.71 Y121.667 E.08516
G3 X107.801 Y121.116 I6.344 J.76 E.02907
G1 X106.553 Y119.868 E.09187
G1 X106.553 Y119.227 E.03342
G1 X107.911 Y120.585 E.10003
G3 X108.039 Y120.072 I5.917 J1.205 E.02755
G1 X106.552 Y118.585 E.1095
G1 X106.551 Y117.943 E.03342
G1 X108.184 Y119.575 E.12021
G1 X108.346 Y119.096 E.02633
G1 X106.557 Y117.307 E.13178
G3 X106.599 Y116.708 I4.203 J-.003 E.03129
G1 X108.523 Y118.632 E.14171
G3 X108.714 Y118.182 I5.251 J1.965 E.02547
G1 X106.662 Y116.13 E.15114
G3 X106.745 Y115.696 I3.073 J.36 E.02302
G1 X106.869 Y115.696 E.00646
G1 X108.919 Y117.746 E.15097
G3 X109.077 Y117.428 I3.73 J1.663 E.01851
G1 X109.136 Y117.321 E.00631
G1 X107.226 Y115.412 E.14063
G1 X107.547 Y115.091 E.02361
G1 X109.365 Y116.91 E.13392
G1 X109.612 Y116.515 E.02423
G1 X107.867 Y114.771 E.12849
G1 X108.188 Y114.45 E.02361
G1 X109.865 Y116.127 E.12349
G1 X110.131 Y115.752 E.02395
G1 X108.113 Y113.733 E.14865
G1 X107.73 Y113.073 E.03976
G3 X107.867 Y112.847 I1.984 J1.051 E.01376
G1 X110.405 Y115.385 E.18692
G3 X110.693 Y115.031 I4.182 J3.107 E.02374
G1 X108.119 Y112.457 E.18956
G1 X108.387 Y112.084 E.02393
G1 X110.992 Y114.69 E.19187
G3 X111.305 Y114.36 I3.903 J3.387 E.02363
G1 X108.669 Y111.725 E.19406
G3 X108.828 Y111.546 I1.333 J1.019 E.0125
G1 X108.976 Y111.391 E.01115
G1 X111.627 Y114.041 E.19522
G3 X111.961 Y113.734 I2.814 J2.727 E.02365
G1 X109.289 Y111.063 E.19678
G3 X109.627 Y110.759 I1.759 J1.622 E.02368
G1 X112.307 Y113.439 E.19738
G3 X112.663 Y113.154 I2.627 J2.901 E.02376
G1 X109.971 Y110.462 E.19825
G1 X111.336 Y111.302 E.08349
G1 X111.394 Y111.244 E.00425
G1 X113.028 Y112.877 E.12031
G3 X113.206 Y112.745 I1.219 J1.457 E.01159
G1 X113.404 Y112.613 E.01239
G1 X111.715 Y110.923 E.12443
G1 X112.035 Y110.603 E.02361
G1 X113.794 Y112.361 E.1295
G3 X114.195 Y112.121 I2.947 J4.461 E.02435
G1 X112.356 Y110.282 E.13542
G1 X112.677 Y109.961 E.02361
G1 X114.609 Y111.894 E.1423
G3 X115.037 Y111.68 I2.651 J4.785 E.02491
G1 X112.997 Y109.641 E.15021
G1 X113.318 Y109.32 E.02361
G1 X115.477 Y111.48 E.15906
G3 X115.932 Y111.293 I2.37 J5.105 E.02558
G1 X113.638 Y109 E.16888
G1 X113.753 Y108.885 E.00846
G1 X113.759 Y108.702 E.00954
G3 X113.945 Y108.665 I.284 J.955 E.0099
G1 X116.4 Y111.12 E.18077
G3 X116.883 Y110.961 I2.045 J5.426 E.02648
G1 X114.506 Y108.584 E.17505
G3 X115.09 Y108.528 I.688 J4.058 E.03061
G1 X117.382 Y110.819 E.16875
G3 X117.898 Y110.694 I15.067 J61.066 E.02766
G1 X115.728 Y108.525 E.15976
G1 X116.369 Y108.525 E.03338
G1 X118.433 Y110.588 E.15196
G3 X118.832 Y110.526 I.884 J4.412 E.02106
G1 X118.988 Y110.502 E.00823
G1 X117.01 Y108.524 E.14567
G1 X117.651 Y108.524 E.03338
G1 X119.566 Y110.439 E.141
G3 X120.176 Y110.407 I.574 J5.184 E.03181
G1 X118.293 Y108.524 E.13869
G1 X118.934 Y108.524 E.03338
G1 X120.589 Y110.179 E.12192
G1 X120.652 Y109.601 E.03028
G1 X119.575 Y108.524 E.07937
G1 X120.216 Y108.523 E.03338
G1 X121.949 Y110.257 E.12767
G1 X122.329 Y110.49 E.02323
G3 X122.908 Y110.575 I-.715 J6.907 E.03047
G1 X120.857 Y108.523 E.15109
G1 X121.498 Y108.523 E.03338
G1 X123.715 Y110.74 E.16331
G3 X124.6 Y110.984 I-1.65 J7.714 E.04784
G1 X122.139 Y108.523 E.18129
G1 X122.78 Y108.523 E.03338
G1 X125.585 Y111.328 E.20659
G3 X126.616 Y111.792 I-5.047 J12.585 E.05889
G1 X126.763 Y111.865 E.00857
G1 X123.421 Y108.522 E.24617
G1 X124.062 Y108.522 E.03338
G1 X138.526 Y122.987 E1.06529
G1 X138.206 Y123.308 E.02361
G1 X134.12 Y119.222 E.3009
G1 X133.799 Y119.542 E.02361
G1 X137.885 Y123.628 E.30091
G1 X137.565 Y123.949 E.02361
G1 X133.479 Y119.863 E.3009
G1 X133.361 Y119.981 E.00867
G3 X133.501 Y120.527 I-6.179 J1.88 E.02937
G1 X137.244 Y124.269 E.27562
G1 X136.923 Y124.59 E.02361
G1 X133.666 Y121.332 E.23993
G3 X133.768 Y122.076 I-8.437 J1.54 E.0391
G1 X136.603 Y124.911 E.20878
G1 X136.282 Y125.231 E.02361
G1 X133.827 Y122.776 E.18082
G3 X133.849 Y123.439 I-7.603 J.585 E.03457
G1 X135.962 Y125.552 E.15558
G1 X135.674 Y125.84 E.0212
G1 X139.512 Y129.678 E.28266
G1 X139.479 Y129.71 E.00241
G1 X133.839 Y124.07 E.41537
G3 X133.801 Y124.673 I-6.887 J-.135 E.03147
G1 X139.158 Y130.031 E.39458
G1 X138.838 Y130.352 E.02361
G1 X133.737 Y125.251 E.37564
G3 X133.651 Y125.806 I-6.382 J-.703 E.02927
G1 X138.517 Y130.672 E.35836
G1 X138.196 Y130.993 E.02361
G1 X133.645 Y126.441 E.33523
G1 X134.209 Y127.613 E.06774
G1 X134.174 Y127.611 E.00183
G1 X137.876 Y131.313 E.27266
G1 X137.555 Y131.634 E.02361
G1 X133.496 Y127.575 E.29895
G1 X133.216 Y127.56 E.01462
G1 X133.12 Y127.84 E.01542
G1 X137.235 Y131.955 E.30304
G1 X136.914 Y132.275 E.02361
G1 X132.934 Y128.295 E.29315
G3 X132.646 Y128.649 I-1.217 J-.695 E.02384
G1 X136.593 Y132.596 E.29071
G1 X136.273 Y132.916 E.02361
G1 X132.256 Y128.9 E.29582
G3 X131.741 Y129.026 I-.657 J-1.569 E.02774
G1 X135.952 Y133.237 E.31016
G1 X135.632 Y133.558 E.02361
G1 X128.824 Y126.75 E.50138
G3 X128.633 Y127.2 I-2.204 J-.667 E.02552
G1 X135.311 Y133.878 E.49181
G1 X134.99 Y134.199 E.02361
G1 X128.419 Y127.627 E.484
G3 X128.188 Y128.037 I-2.034 J-.875 E.02456
G1 X134.67 Y134.519 E.4774
G1 X134.349 Y134.84 E.02361
G1 X127.936 Y128.427 E.4723
G3 X127.669 Y128.802 I-1.886 J-1.062 E.02399
G1 X134.029 Y135.161 E.46834
G1 X133.708 Y135.481 E.02361
G1 X127.383 Y129.156 E.46581
G3 X127.083 Y129.497 I-1.745 J-1.234 E.02371
G1 X133.387 Y135.802 E.46431
G1 X133.067 Y136.123 E.02361
G1 X126.762 Y129.818 E.46431
G3 X126.432 Y130.129 I-2.111 J-1.907 E.02365
G1 X132.746 Y136.443 E.465
G1 X132.426 Y136.764 E.02361
G1 X126.078 Y130.416 E.4675
G1 X125.705 Y130.685 E.02392
G1 X132.105 Y137.084 E.4713
G1 X131.784 Y137.405 E.02361
G1 X125.322 Y130.943 E.47591
G1 X124.914 Y131.176 E.02447
G1 X131.464 Y137.726 E.48235
G1 X131.143 Y138.046 E.02361
G1 X124.497 Y131.4 E.48949
M73 P56 R8
G3 X124.05 Y131.595 I-1.497 J-2.819 E.02539
G1 X130.855 Y138.399 E.50114
G1 X130.851 Y138.539 E.00725
G1 X130.353 Y138.539 E.02594
G1 X126.215 Y134.4 E.30476
G3 X126.164 Y134.856 I-1.897 J.021 E.02394
G1 X126.129 Y134.956 E.00552
G1 X129.712 Y138.539 E.26383
G1 X129.071 Y138.539 E.03339
G1 X125.904 Y135.372 E.23324
G3 X125.621 Y135.653 I-1.286 J-1.009 E.0208
G1 X125.575 Y135.684 E.00291
G1 X128.429 Y138.539 E.21022
G1 X127.788 Y138.539 E.03339
G1 X125.143 Y135.893 E.19482
G1 X124.843 Y135.996 E.0165
G1 X124.932 Y136.085 E.00659
G1 X124.813 Y136.205 E.0088
G1 X127.147 Y138.539 E.17188
G1 X126.506 Y138.539 E.03339
G1 X124.492 Y136.525 E.14827
G1 X124.165 Y136.84 E.02362
G1 X125.864 Y138.539 E.12513
G1 X125.223 Y138.539 E.03339
G1 X123.124 Y136.439 E.15459
G3 X122.573 Y136.53 I-1.31 J-6.251 E.02907
G1 X124.582 Y138.539 E.14793
G1 X123.941 Y138.539 E.03339
G1 X122.001 Y136.599 E.14283
G3 X121.406 Y136.645 I-.818 J-6.804 E.03113
G1 X123.3 Y138.539 E.13949
G1 X122.658 Y138.539 E.03339
G1 X120.783 Y136.663 E.1381
G3 X120.211 Y136.654 I-.178 J-6.562 E.02979
G1 X120.129 Y136.651 E.00429
G1 X122.017 Y138.539 E.13905
G1 X121.376 Y138.539 E.03339
G1 X119.437 Y136.6 E.14279
G3 X118.697 Y136.501 I.664 J-7.798 E.03889
G1 X120.735 Y138.539 E.15006
G1 X120.093 Y138.539 E.03339
G1 X117.908 Y136.353 E.16097
G3 X117.055 Y136.142 I2.514 J-11.966 E.04575
G1 X119.452 Y138.539 E.17653
G1 X118.811 Y138.539 E.03339
G1 X116.807 Y136.535 E.14758
G1 X116.487 Y136.855 E.02361
G1 X118.17 Y138.539 E.12397
G1 X117.529 Y138.539 E.03339
G1 X113.145 Y134.155 E.32285
G1 X115.992 Y135.944 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.658347
; LAYER_HEIGHT: 0.144391
G1 F12000
G1 X116.404 Y136.091 E.01613
G1 X110.917 Y137.27 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G3 X109.608 Y136.305 I5.49 J-8.812 E.04011
G1 X110.865 Y135.048 E.04381
G1 X107.027 Y131.211 E.1338
G1 X106.754 Y131.484 E.00953
G2 X107.248 Y133.032 I7.533 J-1.551 E.04014
G1 X106.359 Y129.934 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.40341
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X114.933 Y138.508 E.63143
G1 X115.546 Y138.537 E.03193
G1 X115.544 Y138.478 E.00309
G1 X106.561 Y129.495 E.66154
G1 X106.561 Y128.853 E.03342
G1 X115.925 Y138.217 E.68963
G1 X116.557 Y138.539 E.03694
G1 X116.887 Y138.539 E.0172
G1 X106.56 Y128.212 E.76056
G1 X106.56 Y127.57 E.03342
G1 X109.748 Y130.758 E.23478
G3 X108.906 Y129.275 I13.421 J-8.599 E.08885
G1 X106.559 Y126.928 E.17282
G1 X106.559 Y126.286 E.03342
G1 X108.415 Y128.143 E.13672
G3 X108.098 Y127.184 I13.287 J-4.929 E.05258
G1 X106.355 Y125.442 E.12833
G1 X106.988 Y124.972 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.144391
G1 F16200
G1 X107.015 Y125.213 E.00599
G1 X106.536 Y124.734 E.01671
G1 X106.535 Y124.026 E.01744
G1 X106.91 Y123.651 E.01307
G1 X106.913 Y123.404 E.0061
G1 X106.534 Y123.025 E.01319
G1 X106.533 Y121.788 E.0305
G1 X106.87 Y121.986 E.00964
; WIPE_START
G1 X106.533 Y121.788 E-.14854
G1 X106.534 Y123.025 E-.47022
G1 X106.797 Y123.288 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X112.909 Y127.86 Z1.445 F30000
G1 X124.114 Y136.241 Z1.445
G1 Z1.045
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.488787
G1 F12000
G2 X124.111 Y136.341 I-.029 J.049 E.00632
; CHANGE_LAYER
; Z_HEIGHT: 1.19866
; LAYER_HEIGHT: 0.153374
; WIPE_START
G1 F12000
G1 X124.056 Y136.341 E-.183
G1 X124.028 Y136.291 E-.19233
G1 X124.056 Y136.241 E-.19233
G1 X124.114 Y136.241 E-.19234
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 9/33
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
G17
G3 Z1.445 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.148 Y134.696
G1 Z1.199
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G2 X154.215 Y134.837 I.27 J-.041 E.00385
G3 X154.353 Y135.532 I-2.243 J.807 E.01719
G1 X154.353 Y137.521 E.04811
G3 X152.558 Y139.316 I-1.815 J-.019 E.06803
G1 X115.566 Y139.316 E.89478
G3 X105.773 Y129.523 I.004 J-9.797 E.37206
G1 X105.773 Y117.529 E.29012
G3 X115.566 Y107.736 I9.817 J.024 E.37185
G1 X152.63 Y107.74 E.89654
G3 X154.353 Y109.532 I-.07 J1.791 E.06644
G1 X154.353 Y111.521 E.04811
G3 X154.148 Y112.357 I-1.857 J-.013 E.02102
G1 X154.148 Y112.44 E.002
G1 X154.148 Y134.613 E.53634
G2 X154.145 Y134.635 I.27 J.041 E.00055
; WIPE_START
M204 S10000
G1 X154.215 Y134.837 E-.08121
G1 X154.317 Y135.17 E-.13223
G1 X154.353 Y135.532 E-.13809
G1 X154.353 Y136.607 E-.40847
; WIPE_END
G1 E-.04 F1800
G1 X153.25 Y129.054 Z1.599 F30000
G1 X150.243 Y108.465 Z1.599
G1 Z1.199
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X150.022 Y108.576 E.00642
G2 X150.727 Y112.741 I1.155 J1.947 E.14194
G2 X151.788 Y108.344 I.445 J-2.219 E.1807
G1 X151.825 Y108.138 E.00545
G3 X152.708 Y108.147 I.357 J8.801 E.02302
G3 X153.951 Y109.542 I-.168 J1.401 E.05324
G1 X153.951 Y111.511 E.0513
G3 X153.746 Y112.266 I-1.544 J-.014 E.02063
G1 X153.746 Y134.786 E.58695
G3 X153.951 Y135.542 I-1.339 J.77 E.02063
G1 X153.951 Y137.51 E.0513
G3 X152.547 Y138.914 I-1.408 J-.004 E.05744
G1 X151.828 Y138.914 E.01875
G1 X151.796 Y138.701 E.00562
G2 X150.553 Y138.701 I-.622 J-2.172 E.33718
G1 X150.521 Y138.914 E.00562
G1 X115.571 Y138.914 E.91093
G3 X106.175 Y129.519 I-.001 J-9.395 E.38468
G1 X106.175 Y117.534 E.31236
G3 X115.571 Y108.138 I9.414 J.018 E.38446
G1 X150.524 Y108.138 E.91099
G1 X150.561 Y108.344 E.00545
G2 X150.296 Y108.438 I.617 J2.178 E.00733
; WIPE_START
G1 X150.022 Y108.576 E-.11628
G1 X149.801 Y108.727 E-.10195
G1 X149.598 Y108.903 E-.1019
G1 X149.417 Y109.1 E-.10187
G1 X149.261 Y109.318 E-.10191
G1 X149.131 Y109.553 E-.10192
G1 X149.031 Y109.802 E-.10188
G1 X149.008 Y109.884 E-.03229
; WIPE_END
G1 E-.04 F1800
G1 X143.756 Y115.421 Z1.599 F30000
G1 X125.296 Y134.885 Z1.599
G1 Z1.199
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.249 Y134.937 E.00169
G3 X125.076 Y135.082 I-.55 J-.481 E.00549
G3 X120.484 Y111.171 I-4.365 J-11.558 E1.04133
G3 X132.315 Y127.79 I.216 J12.366 E.58017
G3 X131.819 Y128.229 I-.724 J-.317 E.01655
G3 X131.084 Y128.017 I-.143 J-.885 E.01912
G3 X130.807 Y127.196 I.439 J-.605 E.02237
G2 X113.677 Y115.416 I-10.1 J-3.658 E.6838
G1 X115.65 Y117.388 E.06747
G3 X119.654 Y115.634 I5.194 J6.408 E.10703
G2 X121.772 Y115.633 I1.059 J-.794 E.05939
G3 X128.606 Y122.467 I-1.111 J7.945 E.25088
G2 X128.606 Y124.585 I.794 J1.059 E.0594
G3 X121.772 Y131.419 I-7.915 J-1.081 E.25106
G2 X119.654 Y131.419 I-1.059 J.794 E.0594
G3 X112.82 Y124.586 I1.111 J-7.944 E.25088
G2 X112.821 Y122.467 I-.794 J-1.059 E.05939
G3 X114.575 Y118.463 I7.957 J1.099 E.1071
G1 X112.603 Y116.49 E.06747
G2 X124.39 Y133.618 I8.123 J7.03 E.68399
G3 X124.739 Y133.588 I.24 J.748 E.00855
G3 X125.338 Y134.101 I-.218 J.861 E.01978
G3 X125.326 Y134.833 I-.639 J.355 E.01855
M204 S10000
G1 X125.679 Y135.038 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X125.663 Y135.066 E.00084
G3 X125.274 Y135.434 I-.938 J-.602 E.01411
G3 X120.476 Y110.769 I-4.565 J-11.911 E1.16005
G3 X132.689 Y127.94 I.224 J12.769 E.64581
G3 X132.248 Y128.479 I-1.033 J-.393 E.01848
G3 X130.85 Y128.345 I-.605 J-1.042 E.03906
G3 X130.422 Y127.079 I.618 J-.914 E.03742
G2 X114.273 Y115.443 I-9.709 J-3.55 E.69888
G1 X115.681 Y116.851 E.05189
G3 X119.795 Y115.201 I5.226 J7.077 E.11679
G1 X120.102 Y115.518 E.0115
G2 X121.239 Y115.59 I.611 J-.642 E.03224
G2 X121.631 Y115.201 I-1.6 J-2.006 E.01445
G3 X125.965 Y117.019 I-1.041 J8.554 E.12404
G3 X129.039 Y122.608 I-5.408 J6.615 E.17039
G1 X128.721 Y122.915 E.01152
G2 X128.649 Y124.052 I.643 J.611 E.03223
G2 X129.039 Y124.445 I2.006 J-1.6 E.01445
G3 X126.933 Y129.116 I-8.532 J-1.036 E.13563
G3 X121.632 Y131.852 I-6.329 J-5.761 E.15881
G1 X121.325 Y131.534 E.01152
G2 X120.188 Y131.463 I-.611 J.643 E.03223
G2 X119.795 Y131.852 I1.6 J2.007 E.01445
G3 X115.123 Y129.746 I1.036 J-8.532 E.13563
G3 X112.388 Y124.445 I5.761 J-6.329 E.15881
G1 X112.705 Y124.138 E.01152
G2 X112.777 Y123.001 I-.641 J-.611 E.03224
G2 X112.388 Y122.608 I-2.01 J1.603 E.01444
G3 X114.038 Y118.494 I8.755 J1.123 E.11678
G1 X112.63 Y117.086 E.05189
M73 P57 R8
G2 X124.273 Y133.233 I8.087 J6.44 E.69908
G3 X124.616 Y133.174 I.339 J.959 E.0091
G3 X125.69 Y133.906 I-.037 J1.21 E.03577
G3 X125.751 Y134.899 I-.965 J.558 E.02689
G1 X125.707 Y134.984 E.0025
; WIPE_START
G1 X125.663 Y135.066 E-.03502
G1 X125.552 Y135.212 E-.0699
G1 X125.422 Y135.334 E-.06789
G1 X125.274 Y135.434 E-.06783
G1 X125.128 Y135.501 E-.06107
G1 X124.584 Y135.688 E-.21856
G1 X124.049 Y135.845 E-.21184
G1 X123.978 Y135.863 E-.02789
; WIPE_END
G1 E-.04 F1800
G1 X129.314 Y130.406 Z1.599 F30000
G1 X150.422 Y108.825 Z1.599
G1 Z1.199
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.425 Y108.824 E.00007
G3 X151.064 Y108.669 I.75 J1.697 E.016
G1 X151.285 Y108.669 E.00533
G3 X150.229 Y108.925 I-.11 J1.852 E.25524
G1 X150.369 Y108.853 E.00381
; WIPE_START
M204 S10000
G1 X150.425 Y108.824 E-.02392
G1 X150.631 Y108.747 E-.08373
G1 X150.845 Y108.695 E-.08378
G1 X151.064 Y108.669 E-.08377
G1 X151.285 Y108.669 E-.08374
G1 X151.504 Y108.695 E-.08377
G1 X151.718 Y108.747 E-.08376
G1 X151.924 Y108.824 E-.08375
G1 X152.121 Y108.924 E-.08374
G1 X152.265 Y109.022 E-.06603
; WIPE_END
G1 E-.04 F1800
G1 X152.409 Y116.653 Z1.599 F30000
G1 X152.803 Y137.428 Z1.599
G1 Z1.199
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.684 Y137.612 E.00529
G3 X151.064 Y134.672 I-1.51 J-1.085 E.1812
G1 X151.285 Y134.672 E.00533
G3 X152.829 Y137.375 I-.11 J1.856 E.08926
M204 S10000
G1 X153.596 Y137.52 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.345816
G1 F15000
G1 X153.568 Y137.632 E.00226
; LINE_WIDTH: 0.395162
G3 X153.502 Y137.825 I-1.963 J-.563 E.00462
; LINE_WIDTH: 0.439702
G1 X153.5 Y137.83 E.00015
G3 X153.131 Y138.334 I-1.362 J-.611 E.01597
; LINE_WIDTH: 0.383812
G3 X152.625 Y138.701 I-3.77 J-4.656 E.01372
G1 X152.415 Y138.689 F30000
; LINE_WIDTH: 0.165983
G1 F15000
G2 X153.383 Y138.371 I-4.78 J-16.178 E.00847
G1 X153.596 Y137.52 F30000
; LINE_WIDTH: 0.320461
G1 F15000
G1 X153.6 Y137.503 E.00031
; LINE_WIDTH: 0.293459
G1 X153.625 Y137.356 E.00243
; LINE_WIDTH: 0.24531
G1 X153.648 Y137.21 E.00195
; LINE_WIDTH: 0.204379
G1 X153.665 Y137.053 E.0017
; LINE_WIDTH: 0.172689
G1 X153.68 Y136.906 E.00129
; LINE_WIDTH: 0.139049
G1 X153.69 Y136.307 E.00397
; LINE_WIDTH: 0.160635
G1 X153.668 Y136.008 E.00239
; LINE_WIDTH: 0.203155
G1 X153.647 Y135.853 E.00167
; LINE_WIDTH: 0.243641
G1 X153.627 Y135.707 E.00195
; LINE_WIDTH: 0.289344
G2 X153.537 Y135.242 I-7.91 J1.295 E.00759
G1 X153.615 Y135.202 F30000
; LINE_WIDTH: 0.169696
G1 F15000
G1 X153.566 Y134.925 E.0024
G1 X153.615 Y135.202 F30000
; LINE_WIDTH: 0.215644
G1 F15000
G3 X153.638 Y135.455 I-2.355 J.338 E.00291
; LINE_WIDTH: 0.257854
G1 X153.618 Y135.55 E.00136
; LINE_WIDTH: 0.297214
G1 X153.603 Y135.579 E.00053
; LINE_WIDTH: 0.293528
G1 X153.575 Y135.559 E.00056
; LINE_WIDTH: 0.25597
G1 X153.546 Y135.539 E.00048
; LINE_WIDTH: 0.218412
G1 X153.518 Y135.519 E.0004
; LINE_WIDTH: 0.180854
G1 X153.49 Y135.499 E.00032
; LINE_WIDTH: 0.14975
G1 X153.452 Y135.44 E.00051
; LINE_WIDTH: 0.12505
G1 X153.382 Y135.342 E.0007
; LINE_WIDTH: 0.099625
G1 X153.311 Y135.244 E.0005
; WIPE_START
G1 X153.382 Y135.342 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.86 Y138.706 Z1.599 F30000
G1 Z1.199
G1 E.8 F1800
; LINE_WIDTH: 0.145167
G1 F15000
G1 X149.762 Y138.621 E.00091
; LINE_WIDTH: 0.125058
G1 X149.675 Y138.536 E.0007
; LINE_WIDTH: 0.0996316
G1 X149.588 Y138.452 E.0005
G1 X132.246 Y131.107 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G1 X132.163 Y131.236 E.00399
G3 X131.273 Y132.412 I-12.252 J-8.351 E.03845
G1 X131.513 Y132.652 E.00886
G3 X127.251 Y136.066 I-11.166 J-9.574 E.14316
G1 X126.999 Y135.814 E.00929
G1 X126.558 Y136.031 E.01281
G3 X124.453 Y136.812 I-6.147 J-13.336 E.05857
G1 X123.981 Y137.284 E.0174
G3 X121.168 Y137.659 I-3.591 J-16.233 E.07406
G1 X120.836 Y137.327 E.01223
G1 X120.431 Y137.327 E.01056
G3 X116.822 Y136.767 I.32 J-13.972 E.09544
G1 X116.551 Y137.039 E.01002
G3 X115.026 Y136.471 I7.483 J-22.415 E.04242
G1 X113.132 Y135.058 F30000
G1 F16200
G1 X112.877 Y134.89 E.00797
G3 X111.828 Y134.086 I8.69 J-12.436 E.03447
G1 X111.587 Y134.326 E.00885
G3 X108.175 Y130.062 I9.536 J-11.129 E.14317
G1 X108.425 Y129.812 E.00923
G1 X108.393 Y129.751 E.00181
G3 X107.772 Y128.322 I13.342 J-6.646 E.04063
G1 X108.481 Y135.135 F30000
G1 F16200
G2 X109.607 Y136.307 I6.257 J-4.881 E.04244
G1 X110.982 Y134.932 E.05069
G1 X117.439 Y138.159 F30000
G1 F16200
G1 X117.367 Y138.143 E.00191
G3 X115.873 Y137.717 I3.598 J-15.429 E.04052
G1 X115.052 Y138.538 E.03026
G3 X114.295 Y138.462 I.015 J-3.992 E.01985
G1 X106.627 Y130.794 E.28264
G2 X106.752 Y131.486 I3.686 J-.304 E.01835
G1 X107.544 Y130.694 E.0292
G1 X107.329 Y130.289 E.01195
G3 X106.843 Y129.225 I12.616 J-6.395 E.03049
G1 X106.53 Y121.395 F30000
G1 F16200
G1 X106.532 Y123.023 E.04244
G1 X106.913 Y123.404 E.01406
G1 X106.911 Y123.651 E.00643
G1 X106.533 Y124.029 E.01393
G1 X106.534 Y125.657 E.04244
G1 X107.772 Y118.731 F30000
G1 F16200
G1 X108.029 Y118.083 E.01818
G3 X108.427 Y117.242 I18.28 J8.136 E.02426
G1 X108.175 Y116.99 E.00929
G3 X111.586 Y112.725 I12.595 J6.58 E.14323
G1 X111.827 Y112.966 E.00887
G1 X112.144 Y112.706 E.0107
G3 X113.131 Y111.992 I11.418 J14.745 E.03174
G1 X110.98 Y112.119 F30000
G1 F16200
G1 X109.601 Y110.74 E.0508
G2 X108.48 Y111.919 I5.612 J6.463 E.04246
G1 X106.845 Y117.829 F30000
G1 F16200
G1 X106.933 Y117.612 E.0061
G3 X107.545 Y116.36 I14.522 J6.321 E.03633
G1 X106.752 Y115.567 E.02923
G2 X106.617 Y116.269 I7.081 J1.722 E.01865
G1 X114.295 Y108.59 E.28302
G3 X115.044 Y108.507 I.957 J5.191 E.01965
G1 X115.88 Y109.343 E.03083
G3 X117.444 Y108.894 I4.285 J11.951 E.04243
G1 X115.024 Y110.58 F30000
G1 F16200
G3 X116.55 Y110.013 I6.048 J13.953 E.04244
G1 X116.821 Y110.284 E.00999
G1 X117.298 Y110.152 E.0129
G3 X120.835 Y109.727 I3.417 J13.505 E.09309
G1 X121.168 Y109.394 E.01227
G3 X123.983 Y109.771 I-.746 J16.303 E.07414
G1 X124.457 Y110.244 E.01745
G1 X124.672 Y110.303 E.00581
G3 X126.998 Y111.24 I-4.111 J13.563 E.06544
G1 X127.249 Y110.989 E.00926
G3 X131.514 Y114.399 I-6.56 J12.575 E.14323
G1 X131.274 Y114.64 E.00886
G3 X132.246 Y115.945 I-11.186 J9.344 E.04244
G1 X133.659 Y117.839 F30000
G1 F16200
G3 X134.226 Y119.364 I-22.85 J9.358 E.04242
G1 X133.955 Y119.634 E.00997
G1 X133.996 Y119.783 E.00403
G1 X134.471 Y120.258 E.0175
G3 X134.469 Y126.796 I-14.14 J3.265 E.17189
G1 X133.997 Y127.269 E.01741
G1 X133.954 Y127.417 E.00403
G1 X134.228 Y127.691 E.01008
G3 X133.658 Y129.215 I-26.006 J-8.849 E.04242
G1 X135.695 Y122.954 F30000
G1 F16200
G2 X135.546 Y121.333 I-13.195 J.395 E.04245
G1 X149.123 Y134.91 E.50043
G2 X148.761 Y135.532 I2.17 J1.676 E.01882
G1 X145.731 Y138.563 E.11169
G1 X145.099 Y138.563 E.01646
G1 X134.904 Y128.367 E.37581
G1 X135.031 Y127.987 E.01044
G2 X135.544 Y125.722 I-14.905 J-4.568 E.06059
G1 X149.125 Y112.14 E.5006
G3 X148.751 Y111.511 I2.054 J-1.645 E.01915
G1 X145.732 Y108.492 E.11128
G1 X145.098 Y108.492 E.01654
G1 X134.905 Y118.685 E.37571
G2 X134.296 Y117.176 I-15.011 J5.179 E.04244
G1 X123.289 Y109.193 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.499971
G1 F15000
G3 X123.025 Y108.737 I.124 J-.376 E.01684
G1 X122.911 Y108.598 E.00523
G1 X121.949 Y108.575 E.0281
; LINE_WIDTH: 0.455073
G2 X119.492 Y108.575 I-1.22 J78.666 E.06481
; LINE_WIDTH: 0.498108
G3 X118.509 Y108.599 I-3.572 J-124.837 E.02859
G1 X118.398 Y108.734 E.00507
G3 X118.356 Y109.021 I-.338 J.096 E.00868
G1 X118.169 Y109.186 E.00725
G1 X118.688 Y109.082 E.01538
G1 X119.497 Y109.013 E.0236
; LINE_WIDTH: 0.455053
G3 X121.917 Y109.012 I1.219 J25.948 E.06387
; LINE_WIDTH: 0.491203
G3 X123.23 Y109.179 I-.443 J8.734 E.03796
G1 X123.289 Y109.193 F30000
; LINE_WIDTH: 0.479342
G1 F15000
G3 X123.101 Y137.897 I-2.574 J14.335 E1.13739
; WIPE_START
G1 X124.024 Y137.714 E-.35742
G1 X124.612 Y137.564 E-.23046
G1 X125.045 Y137.434 E-.17213
; WIPE_END
G1 E-.04 F1800
G1 X119.848 Y131.844 Z1.599 F30000
G1 X107.156 Y118.194 Z1.599
G1 Z1.199
G1 E.8 F1800
; LINE_WIDTH: 0.47905
G1 F15000
G3 X118.11 Y109.197 I13.553 J5.334 E.41274
; WIPE_START
G1 X117.107 Y109.411 E-.38955
G1 X116.521 Y109.574 E-.23109
G1 X116.175 Y109.694 E-.13936
; WIPE_END
G1 E-.04 F1800
G1 X110.621 Y114.929 Z1.599 F30000
G1 X107.156 Y118.194 Z1.599
G1 Z1.199
G1 E.8 F1800
; LINE_WIDTH: 0.46013
G1 F15000
G1 X106.97 Y118.321 E.006
G3 X106.597 Y118.305 I-.161 J-.624 E.01012
G1 X106.598 Y119.977 E.04464
G3 X107.136 Y118.251 I26.507 J7.309 E.04827
G1 X107.171 Y128.895 F30000
; LINE_WIDTH: 0.479868
G1 F15000
G2 X118.293 Y137.889 I13.542 J-5.372 E.41756
; WIPE_START
G1 X117.46 Y137.726 E-.32253
G1 X116.82 Y137.566 E-.25053
G1 X116.349 Y137.424 E-.18694
; WIPE_END
G1 E-.04 F1800
G1 X110.758 Y132.229 Z1.599 F30000
G1 X107.171 Y128.895 Z1.599
G1 Z1.199
G1 E.8 F1800
; LINE_WIDTH: 0.455572
G1 F15000
G3 X106.602 Y127.072 I19.476 J-7.08 E.05047
G1 X106.604 Y128.754 E.04444
G1 X106.839 Y128.716 E.00631
G1 X107.074 Y128.793 E.00653
G1 X107.13 Y128.852 E.00214
; WIPE_START
G1 X107.074 Y128.793 E-.03078
G1 X106.839 Y128.716 E-.09395
G1 X106.604 Y128.754 E-.09073
G1 X106.602 Y127.321 E-.54454
; WIPE_END
G1 E-.04 F1800
G1 X113.02 Y131.453 Z1.599 F30000
G1 X123.042 Y137.907 Z1.599
G1 Z1.199
G1 E.8 F1800
; LINE_WIDTH: 0.49043
G1 F15000
G1 X122.534 Y137.993 E.01474
G1 X121.628 Y138.059 E.02597
; LINE_WIDTH: 0.460994
G3 X119.207 Y138.022 I-.814 J-25.994 E.0648
; LINE_WIDTH: 0.493339
G3 X118.352 Y137.9 I.277 J-4.992 E.02488
G1 X118.57 Y138.071 E.00799
G1 X118.624 Y138.232 E.00488
G1 X118.61 Y138.467 E.0068
G3 X119.784 Y138.49 I-2.31 J151.625 E.03379
; LINE_WIDTH: 0.46102
G2 X122.242 Y138.477 I.829 J-78.775 E.06576
; LINE_WIDTH: 0.501185
G1 X122.817 Y138.467 E.01682
G1 X122.802 Y138.223 E.00717
G1 X122.887 Y138.036 E.00603
G1 X122.996 Y137.945 E.00414
; WIPE_START
G1 X122.887 Y138.036 E-.09216
G1 X122.802 Y138.223 E-.13411
G1 X122.817 Y138.467 E-.15942
G1 X122.242 Y138.477 E-.3743
; WIPE_END
G1 E-.04 F1800
G1 X121.768 Y130.86 Z1.599 F30000
G1 X120.743 Y114.36 Z1.599
G1 Z1.199
G1 E.8 F1800
; LINE_WIDTH: 0.486674
G1 F15000
G2 X120.74 Y114.458 I-.028 J.048 E.00656
; WIPE_START
G1 X120.686 Y114.458 E-.18164
G1 X120.658 Y114.409 E-.19279
G1 X120.686 Y114.36 E-.19279
G1 X120.743 Y114.36 E-.19279
; WIPE_END
G1 E-.04 F1800
G1 X115.344 Y119.755 Z1.599 F30000
G1 X111.62 Y123.478 Z1.599
G1 Z1.199
G1 E.8 F1800
; LINE_WIDTH: 0.493514
G1 F15000
G2 X111.617 Y123.577 I-.029 J.049 E.00681
; WIPE_START
G1 X111.562 Y123.577 E-.18395
G1 X111.533 Y123.527 E-.19202
G1 X111.562 Y123.478 E-.19204
G1 X111.62 Y123.478 E-.19199
; WIPE_END
G1 E-.04 F1800
G1 X117.02 Y128.871 Z1.599 F30000
G1 X120.741 Y132.587 Z1.599
G1 Z1.199
G1 E.8 F1800
; LINE_WIDTH: 0.477014
G1 F15000
G2 X120.737 Y132.684 I-.028 J.047 E.00622
G1 X129.283 Y130.555 F30000
; LINE_WIDTH: 0.423191
G1 F15000
G3 X127.798 Y132.049 I-11.287 J-9.74 E.05141
G1 X129.208 Y130.012 F30000
; LINE_WIDTH: 0.419994
G1 F15000
G3 X127.207 Y132.02 I-8.798 J-6.765 E.06874
G3 X127.651 Y132.659 I-2.472 J2.191 E.01887
G2 X129.845 Y130.463 I-6.827 J-9.016 E.07532
G3 X129.254 Y130.05 I1.672 J-3.021 E.01748
G1 X129.155 Y129.403 F30000
G1 F15000
G3 X127.565 Y131.218 I-6.949 J-4.483 E.05858
G3 X126.607 Y131.977 I-4.686 J-4.938 E.0296
G1 X127.004 Y132.363 E.01341
G3 X127.526 Y133.23 I-6.406 J4.444 E.02449
G2 X130.422 Y130.329 I-6.712 J-9.599 E.09966
G1 X130.159 Y130.206 E.00704
G1 X129.627 Y129.857 E.01538
G1 X129.192 Y129.451 E.01441
G1 X129.152 Y128.721 F30000
G1 F15000
G1 X128.5 Y129.675 E.02794
G3 X125.931 Y131.963 I-8.039 J-6.442 E.08361
G1 X126.471 Y132.365 E.0163
G1 X126.775 Y132.713 E.01116
G1 X127.106 Y133.249 E.01525
G1 X127.272 Y133.655 E.01061
G1 X127.314 Y133.838 E.00453
G2 X131.025 Y130.125 I-6.886 J-10.593 E.1279
G3 X130.371 Y129.882 I.365 J-1.984 E.01696
G1 X129.839 Y129.534 E.01538
G1 X129.51 Y129.23 E.01083
G1 X129.187 Y128.77 E.01359
G1 X129.23 Y127.794 F30000
G1 F15000
G1 X128.968 Y128.305 E.01389
G3 X128.181 Y129.457 I-1582.327 J-1079.721 E.03374
G3 X125.152 Y131.962 I-7.63 J-6.14 E.09573
G1 X125.047 Y132.038 E.00312
G1 X125.588 Y132.22 E.01381
G1 X125.899 Y132.399 E.00868
G1 X126.388 Y132.832 E.01579
G3 X126.855 Y133.612 I-6.614 J4.484 E.022
G1 X126.991 Y134.16 E.01365
G1 X127.015 Y134.47 E.00752
G2 X131.664 Y129.818 I-6.478 J-11.125 E.16087
G3 X130.583 Y129.558 I.052 J-2.599 E.02711
G1 X130.051 Y129.21 E.01538
G3 X129.246 Y127.852 I1.44 J-1.771 E.03898
G1 X129.861 Y123.478 F30000
; LINE_WIDTH: 0.489394
G1 F15000
G2 X129.858 Y123.577 I-.029 J.049 E.00666
G1 X130.249 Y123.716 F30000
; LINE_WIDTH: 0.422935
G1 F15000
G1 X130.222 Y122.75 E.02354
G1 X130.073 Y121.66 E.02684
G2 X126.752 Y116.135 I-9.544 J1.976 E.16012
G2 X125.657 Y115.366 I-11.992 J15.921 E.03261
G1 X124.609 Y114.819 E.02882
G1 X123.636 Y114.455 E.02532
G1 X122.653 Y114.186 E.02482
G2 X121.131 Y113.989 I-2.699 J14.84 E.03742
G2 X118.856 Y114.171 I-.269 J10.967 E.05573
G1 X117.771 Y114.45 E.02731
G2 X116.033 Y115.226 I3.296 J9.708 E.04645
G1 X115.494 Y115.546 E.01528
G1 X115.784 Y115.836 E.00999
G1 X116.233 Y115.551 E.01296
G3 X118.618 Y114.626 I4.646 J8.437 E.06252
G3 X119.811 Y114.404 I2.826 J11.909 E.0296
G1 X120.14 Y114.465 E.00814
G1 X120.587 Y114.875 E.01478
G1 X120.717 Y114.954 E.00371
G1 X120.852 Y114.872 E.00387
G1 X121.247 Y114.486 E.01344
G1 X121.523 Y114.402 E.00703
G3 X123.162 Y114.715 I-.936 J9.373 E.04072
G1 X124.427 Y115.163 E.03272
G1 X125.471 Y115.719 E.02882
G1 X126.436 Y116.385 E.02858
G3 X129.461 Y120.898 I-5.709 J7.096 E.13445
G3 X129.839 Y122.742 I-9.185 J2.845 E.04595
G1 X129.654 Y123.108 E.01001
G1 X129.302 Y123.475 E.01239
G1 X129.307 Y123.57 E.00231
G1 X129.667 Y123.954 E.01282
G1 X129.837 Y124.25 E.00833
G3 X129.227 Y126.882 I-10.465 J-1.04 E.06603
G3 X128.673 Y128.041 I-14.501 J-6.214 E.0313
G3 X127.861 Y129.238 I-108.316 J-72.568 E.03527
G3 X124.96 Y131.626 I-7.312 J-5.927 E.0922
G3 X123.514 Y132.238 I-7.899 J-16.65 E.03826
G3 X121.658 Y132.644 I-3.25 J-10.423 E.04638
G1 X121.447 Y132.651 E.00515
G1 X121.141 Y132.48 E.00854
G1 X120.761 Y132.117 E.0128
G1 X120.666 Y132.117 E.00232
G1 X120.286 Y132.48 E.0128
G1 X120.045 Y132.628 E.00689
G1 X119.769 Y132.644 E.00674
G3 X116.2 Y131.484 I1.223 J-9.833 E.09201
G1 X115.379 Y130.962 E.02372
G1 X114.618 Y130.353 E.02373
G1 X113.927 Y129.668 E.02373
G1 X113.356 Y128.968 E.02201
G3 X112.558 Y127.677 I17.535 J-11.738 E.037
G1 X112.156 Y126.776 E.02403
G3 X111.595 Y124.471 I12.303 J-4.217 E.05791
G1 X111.584 Y124.358 E.00276
G1 X111.76 Y123.954 E.01075
G1 X112.119 Y123.57 E.01282
G1 X112.124 Y123.475 E.00231
G1 X111.751 Y123.087 E.01311
G1 X111.587 Y122.751 E.00912
G3 X112.289 Y119.95 I9.746 J.952 E.07063
G3 X113.013 Y118.586 I14.016 J6.571 E.03766
G1 X112.729 Y118.302 E.00978
G2 X111.175 Y123.308 I8.189 J5.287 E.12935
G1 X111.201 Y124.362 E.02569
G2 X112.941 Y129.058 I9.734 J-.937 E.12342
G1 X113.581 Y129.869 E.02518
G2 X116.732 Y132.199 I7.47 J-6.803 E.09613
G2 X120.53 Y133.052 I3.901 J-8.49 E.09559
G2 X123.645 Y132.605 I.298 J-8.988 E.07708
G1 X124.211 Y132.417 E.01452
G1 X124.837 Y132.403 E.01528
G1 X125.033 Y132.436 E.00484
G1 X125.592 Y132.652 E.0146
G1 X125.984 Y132.967 E.01225
G1 X126.116 Y133.118 E.0049
G1 X126.446 Y133.655 E.01537
G1 X126.614 Y134.247 E.01498
G1 X126.586 Y134.853 E.0148
G1 X126.464 Y135.203 E.00904
G2 X132.393 Y129.273 I-5.88 J-11.807 E.20799
G1 X132.009 Y129.404 E.0099
G1 X131.41 Y129.424 E.01459
G1 X130.808 Y129.243 E.01532
G3 X130.122 Y128.756 I1.832 J-3.307 E.02055
G1 X129.766 Y128.25 E.01509
G1 X129.59 Y127.624 E.01582
G1 X129.593 Y127.077 E.01334
G2 X130.246 Y123.776 I-9.982 J-3.689 E.08237
G1 X130.647 Y123.344 F30000
; LINE_WIDTH: 0.419898
G1 F15000
G2 X130.227 Y120.662 I-11.168 J.376 E.0658
G1 X129.743 Y119.383 E.03307
G2 X126.986 Y115.822 I-9.35 J4.391 E.10979
G1 X125.873 Y115.036 E.03294
G1 X124.663 Y114.41 E.03295
G1 X123.377 Y113.955 E.03301
G1 X122.493 Y113.752 E.02192
G1 X121.137 Y113.6 E.033
G2 X117.558 Y114.105 I-.423 J9.925 E.08789
G1 X116.299 Y114.626 E.03295
G1 X115.12 Y115.315 E.03303
G1 X114.887 Y115.488 E.00702
G1 X115.732 Y116.333 E.02889
G1 X116.442 Y115.874 E.02045
G1 X117.253 Y115.474 E.02185
G3 X118.719 Y115.005 I3.138 J7.277 E.03729
G3 X119.847 Y114.784 I4.026 J17.605 E.0278
G1 X120.002 Y114.839 E.00397
G1 X120.422 Y115.256 E.01431
G1 X120.741 Y115.349 E.00803
G1 X121.068 Y115.205 E.00865
G1 X121.419 Y114.842 E.01221
G1 X121.58 Y114.784 E.00413
G3 X124.22 Y115.494 I-1.777 J11.868 E.06626
G1 X125.45 Y116.153 E.03374
G1 X126.209 Y116.699 E.02261
G3 X128.913 Y120.432 I-5.834 J7.072 E.11269
G3 X129.301 Y121.777 I-223.877 J65.295 E.03383
G1 X129.455 Y122.7 E.02263
G1 X129.379 Y122.836 E.00378
G1 X128.982 Y123.237 E.01366
G1 X128.89 Y123.539 E.00764
G2 X129.1 Y123.944 I.84 J-.178 E.01116
G1 X129.398 Y124.232 E.01002
G1 X129.454 Y124.405 E.00439
G3 X128.327 Y127.867 I-9.703 J-1.243 E.08856
G3 X127.542 Y129.02 I-293.13 J-198.904 E.03375
G3 X125.813 Y130.64 I-7.638 J-6.419 E.05742
G3 X124.661 Y131.351 I-6.586 J-9.374 E.03277
G3 X123.368 Y131.878 I-87.032 J-211.604 E.03375
G3 X121.592 Y132.267 I-3.283 J-10.748 E.04403
G1 X121.419 Y132.211 E.00439
G1 X121.067 Y131.846 E.01227
G1 X120.841 Y131.717 E.00629
G1 X120.585 Y131.718 E.0062
G1 X120.303 Y131.905 E.00817
G1 X119.927 Y132.261 E.01252
G3 X115.588 Y130.636 I.945 J-9.131 E.11326
G1 X114.862 Y130.051 E.02255
G1 X114.202 Y129.393 E.02255
G1 X113.66 Y128.723 E.02084
G3 X112.89 Y127.476 I43.083 J-27.467 E.03545
G1 X112.513 Y126.62 E.0226
G3 X112.127 Y125.282 I307.601 J-89.462 E.03368
G1 X111.972 Y124.405 E.02154
G1 X112.029 Y124.232 E.00439
G1 X112.392 Y123.882 E.01221
G1 X112.533 Y123.617 E.00727
G1 X112.511 Y123.399 E.00528
G1 X112.375 Y123.167 E.00652
G1 X112.026 Y122.815 E.01198
G1 X111.973 Y122.645 E.0043
G3 X112.653 Y120.084 I10.256 J1.352 E.06425
G3 X113.292 Y118.865 I123.827 J64.048 E.03329
G1 X113.516 Y118.541 E.00952
G1 X112.675 Y117.7 E.02876
G2 X115.376 Y131.906 I8.059 J5.827 E.39151
G1 X116.574 Y132.558 E.033
G2 X120.08 Y133.441 I4.138 J-9.031 E.08792
G1 X121.445 Y133.435 E.03301
G2 X124.328 Y132.801 I-1.122 J-11.98 E.07156
G1 X124.84 Y132.79 E.01237
G1 X125.331 Y132.951 E.01251
G1 X125.74 Y133.267 E.01251
G3 X126.14 Y133.916 I-4.7 J3.347 E.01844
G1 X126.238 Y134.427 E.01258
G1 X126.185 Y134.875 E.01091
G1 X125.984 Y135.309 E.01155
G1 X125.637 Y135.647 E.01173
; LINE_WIDTH: 0.348114
G3 X124.739 Y136.021 I-1.728 J-2.887 E.01923
G3 X120.171 Y110.416 I-4.018 J-12.493 E.88166
G1 X121.267 Y110.411 E.02159
G3 X133.073 Y127.948 I-.559 J13.119 E.48402
G1 X132.85 Y128.42 E.01028
; LINE_WIDTH: 0.418584
G1 X132.489 Y128.8 E.01263
G1 X131.979 Y129.018 E.01336
G1 X131.487 Y129.045 E.01187
G1 X131.007 Y128.911 E.012
G1 X130.475 Y128.562 E.01533
G1 X130.158 Y128.169 E.01217
G1 X129.987 Y127.693 E.01219
G1 X129.983 Y127.184 E.01227
G2 X130.514 Y125.157 I-17.016 J-5.539 E.05053
G2 X130.645 Y123.404 I-9.486 J-1.592 E.04243
; WIPE_START
G1 X130.622 Y124.252 E-.3226
G1 X130.514 Y125.157 E-.34615
G1 X130.464 Y125.392 E-.09125
; WIPE_END
G1 E-.04 F1800
G1 X134.155 Y123.672 Z1.599 F30000
G1 Z1.199
G1 E.8 F1800
; LINE_WIDTH: 0.348804
G1 F15000
G2 X125.358 Y136.141 I-13.436 J-.142 E1.34627
G1 X125.876 Y135.916 E.01113
; LINE_WIDTH: 0.418129
G2 X131.813 Y131.044 I-5.488 J-12.741 E.18734
G2 X133.131 Y128.628 I-13.582 J-8.979 E.06632
; LINE_WIDTH: 0.349652
G2 X134.153 Y123.732 I-11.871 J-5.032 E.09962
G1 X151.78 Y113.07 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G3 X150.184 Y112.943 I-.57 J-2.931 E.04226
G1 X153.394 Y116.153 E.11833
G1 X153.394 Y115.548 E.01578
G1 X130.379 Y138.563 E.84832
G1 X129.748 Y138.563 E.01646
G1 X127.88 Y136.695 E.06882
G1 X128.163 Y136.541 E.00838
G2 X132.119 Y133.258 I-7.539 J-13.111 E.13465
G1 X137.423 Y138.563 E.19551
G1 X138.055 Y138.563 E.01646
G1 X153.394 Y123.224 E.56539
G1 X153.394 Y123.829 E.01578
G1 X138.059 Y108.494 E.56525
G1 X137.419 Y108.494 E.01666
G1 X132.113 Y113.801 E.19561
G2 X127.883 Y110.355 I-11.218 J9.452 E.14304
G1 X129.741 Y108.497 E.06851
G1 X130.385 Y108.496 E.01679
G1 X153.394 Y131.505 E.84809
G1 X153.394 Y130.9 E.01578
G1 X150.17 Y134.124 E.11884
G2 X149.257 Y134.757 I.937 J2.327 E.0292
G1 X153.566 Y112.128 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.169669
G1 F15000
G1 X153.615 Y111.851 E.0024
; LINE_WIDTH: 0.209301
G2 X153.634 Y111.672 I-1.8 J-.281 E.00198
; LINE_WIDTH: 0.232355
G1 X153.633 Y111.635 E.00046
; LINE_WIDTH: 0.261468
G1 X153.613 Y111.584 E.00078
; LINE_WIDTH: 0.307156
G1 X153.592 Y111.534 E.00093
; LINE_WIDTH: 0.307668
G1 X153.555 Y111.56 E.00079
; LINE_WIDTH: 0.26301
G1 X153.518 Y111.587 E.00066
; LINE_WIDTH: 0.218351
G1 X153.48 Y111.613 E.00053
; LINE_WIDTH: 0.181889
G1 X153.434 Y111.678 E.00074
; LINE_WIDTH: 0.152551
G1 X153.384 Y111.748 E.00064
; LINE_WIDTH: 0.124985
G1 X153.307 Y111.842 E.0007
; LINE_WIDTH: 0.099603
G1 X153.231 Y111.936 E.0005
G1 X153.537 Y111.752 F30000
; LINE_WIDTH: 0.326326
G1 F15000
G2 X153.6 Y111.501 I-4.05 J-1.148 E.00476
; LINE_WIDTH: 0.293599
G1 X153.624 Y111.354 E.00242
; LINE_WIDTH: 0.245476
G1 X153.648 Y111.208 E.00197
; LINE_WIDTH: 0.219917
G1 X153.65 Y111.197 E.00013
; LINE_WIDTH: 0.203184
G1 X153.665 Y111.051 E.00157
; LINE_WIDTH: 0.171931
G1 X153.681 Y110.897 E.00134
; LINE_WIDTH: 0.138821
G1 X153.689 Y110.299 E.00396
; LINE_WIDTH: 0.16177
G1 X153.667 Y109.997 E.00244
; LINE_WIDTH: 0.204329
G1 X153.647 Y109.851 E.00158
; LINE_WIDTH: 0.245519
G1 X153.625 Y109.691 E.00215
; LINE_WIDTH: 0.281374
G1 X153.612 Y109.621 E.0011
; LINE_WIDTH: 0.308494
M73 P58 R8
G1 X153.598 Y109.552 E.00122
; LINE_WIDTH: 0.34775
G2 X153.563 Y109.399 I-1.461 J.256 E.00307
; LINE_WIDTH: 0.385012
G1 X153.536 Y109.319 E.00186
; LINE_WIDTH: 0.425141
G2 X153.431 Y109.088 I-2.034 J.785 E.00624
; LINE_WIDTH: 0.444211
G2 X153.141 Y108.731 I-1.202 J.681 E.01187
; LINE_WIDTH: 0.399959
G2 X153.008 Y108.624 I-1.016 J1.123 E.00393
; LINE_WIDTH: 0.347481
G2 X152.553 Y108.349 I-2.829 J4.177 E.01045
G1 X152.443 Y108.347 F30000
; LINE_WIDTH: 0.262506
G1 F15000
G3 X153.516 Y108.834 I-7.306 J17.552 E.01691
; WIPE_START
G1 X152.443 Y108.347 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.898 Y108.347 Z1.599 F30000
G1 Z1.199
G1 E.8 F1800
; LINE_WIDTH: 0.106368
G1 F15000
G1 X149.705 Y108.512 E.00117
; CHANGE_LAYER
; Z_HEIGHT: 1.37069
; LAYER_HEIGHT: 0.172028
; WIPE_START
G1 F15000
G1 X149.898 Y108.347 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 10/33
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
G17
G3 Z1.599 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.197 Y138.254
G1 Z1.371
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G3 X152.558 Y139.316 I-1.64 J-.734 E.05545
G1 X115.566 Y139.316 E.99323
G3 X105.773 Y129.523 I.024 J-9.817 E.41276
G1 X105.773 Y117.529 E.32204
G3 X115.566 Y107.736 I9.797 J.004 E.41299
G1 X152.642 Y107.741 E.99549
G3 X154.353 Y109.532 I-.081 J1.79 E.07344
G1 X154.347 Y111.655 E.057
G3 X154.219 Y112.205 I-2.714 J-.34 E.01519
G1 X154.219 Y112.303 E.00262
G1 X154.218 Y114.926 E.07045
G2 X154.218 Y116.126 I1894.737 J.805 E.03222
G1 X154.219 Y134.75 E.50005
G2 X154.275 Y135.004 I.382 J.049 E.00712
G3 X154.353 Y135.532 I-2.242 J.602 E.01436
G1 X154.353 Y137.521 E.05341
G3 X154.22 Y138.198 I-1.797 J-.001 E.01866
; WIPE_START
M204 S10000
G1 X154.011 Y138.578 E-.16472
G1 X153.761 Y138.856 E-.14216
G1 X153.458 Y139.076 E-.1422
G1 X153.116 Y139.228 E-.14214
G1 X152.75 Y139.306 E-.14222
G1 X152.681 Y139.31 E-.02657
; WIPE_END
G1 E-.04 F1800
G1 X152.09 Y131.7 Z1.771 F30000
G1 X150.284 Y108.451 Z1.771
G1 Z1.371
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X150.262 Y108.454 E.00065
G2 X150.734 Y112.739 I.919 J2.067 E.16532
G2 X151.761 Y108.338 I.436 J-2.218 E.20102
G1 X151.797 Y108.134 E.006
G3 X152.709 Y108.143 I.371 J9.127 E.02639
G3 X153.955 Y109.542 I-.168 J1.405 E.05931
G1 X153.949 Y111.636 E.0606
G3 X153.821 Y112.136 I-2.221 J-.303 E.01498
G1 X153.821 Y134.917 E.65958
G3 X153.955 Y135.541 I-1.468 J.642 E.01862
G1 X153.955 Y137.51 E.05701
G3 X152.547 Y138.918 I-1.399 J.009 E.06415
G1 X151.794 Y138.918 E.02181
G1 X151.763 Y138.707 E.00618
G2 X150.586 Y138.707 I-.588 J-2.178 E.37595
G1 X150.555 Y138.918 E.00618
G1 X115.571 Y138.918 E1.01289
G3 X106.171 Y129.519 I.018 J-9.418 E.42726
G1 X106.171 Y117.534 E.34699
G3 X115.571 Y108.134 I9.399 J-.001 E.4275
G1 X150.552 Y108.134 E1.0128
G1 X150.588 Y108.338 E.006
G1 X150.34 Y108.43 E.00765
; WIPE_START
G1 X150.262 Y108.454 E-.03122
G1 X150.026 Y108.581 E-.10182
G1 X149.804 Y108.731 E-.10172
G1 X149.601 Y108.905 E-.10171
G1 X149.42 Y109.103 E-.1017
G1 X149.264 Y109.32 E-.10174
M73 P58 R7
G1 X149.135 Y109.555 E-.1017
G1 X149.034 Y109.803 E-.10172
G1 X149.023 Y109.845 E-.01668
; WIPE_END
G1 E-.04 F1800
G1 X143.773 Y115.386 Z1.771 F30000
G1 X125.289 Y134.895 Z1.771
G1 Z1.371
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.249 Y134.937 E.00154
G3 X125.076 Y135.082 I-.551 J-.482 E.0061
G3 X120.528 Y111.17 I-4.365 J-11.558 E1.15708
G3 X132.315 Y127.789 I.172 J12.368 E.64282
G3 X131.857 Y128.217 I-.724 J-.316 E.01729
G1 X131.819 Y128.229 E.00109
G3 X131.084 Y128.017 I-.143 J-.885 E.02123
G3 X130.807 Y127.196 I.439 J-.605 E.02483
G2 X113.677 Y115.416 I-10.094 J-3.667 E.75943
G1 X115.65 Y117.388 E.07489
G3 X119.654 Y115.634 I5.104 J6.202 E.11888
G2 X121.773 Y115.634 I1.059 J-.792 E.06598
G3 X128.606 Y122.467 I-1.081 J7.915 E.27867
G2 X128.606 Y124.586 I.792 J1.059 E.06598
G3 X121.773 Y131.419 I-7.944 J-1.111 E.27847
G2 X119.654 Y131.419 I-1.059 J.791 E.06598
G3 X112.82 Y124.586 I1.111 J-7.944 E.27848
G2 X112.821 Y122.467 I-.791 J-1.059 E.06598
G3 X114.575 Y118.463 I7.957 J1.1 E.11888
G1 X112.603 Y116.49 E.07489
G2 X124.39 Y133.618 I8.113 J7.036 E.75963
G3 X124.739 Y133.588 I.24 J.748 E.00949
G3 X125.339 Y134.101 I-.218 J.861 E.02196
G3 X125.319 Y134.843 I-.641 J.354 E.02091
M204 S10000
G1 X125.672 Y135.042 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X125.658 Y135.068 E.00086
G3 X125.272 Y135.43 I-.929 J-.604 E.01548
G3 X120.519 Y110.772 I-4.563 J-11.908 E1.28951
G3 X132.685 Y127.938 I.18 J12.767 E.7159
G3 X131.983 Y128.594 I-1.017 J-.384 E.02883
G3 X130.853 Y128.342 I-.332 J-1.171 E.03495
G3 X130.426 Y127.08 I.616 J-.911 E.04142
G2 X114.267 Y115.442 I-9.719 J-3.542 E.77638
G1 X115.681 Y116.856 E.05788
G3 X119.793 Y115.205 I5.237 J7.099 E.12969
G1 X120.102 Y115.524 E.01287
G2 X121.238 Y115.596 I.611 J-.652 E.03571
G2 X121.634 Y115.205 I-1.564 J-1.979 E.01613
G3 X125.069 Y116.396 I-1.201 J9.014 E.10599
G1 X125.241 Y116.501 E.00584
G3 X129.035 Y122.606 I-4.66 J7.126 E.21484
G1 X128.715 Y122.916 E.01288
G2 X128.644 Y124.051 I.652 J.611 E.03571
G2 X129.035 Y124.447 I1.982 J-1.566 E.01613
G3 X127.488 Y128.422 I-8.855 J-1.157 E.12469
G3 X121.634 Y131.848 I-6.878 J-5.038 E.20198
G1 X121.324 Y131.528 E.01287
G2 X120.189 Y131.457 I-.611 J.652 E.03571
G2 X119.793 Y131.848 I1.564 J1.979 E.01613
G3 X115.818 Y130.301 I1.052 J-8.585 E.12478
G3 X112.392 Y124.447 I5.038 J-6.878 E.20199
G1 X112.711 Y124.137 E.01288
G2 X112.783 Y123.002 I-.652 J-.611 E.03571
G2 X112.392 Y122.606 I-1.98 J1.564 E.01612
G3 X114.043 Y118.494 I8.749 J1.124 E.12969
G1 X112.629 Y117.08 E.05788
G2 X124.275 Y133.236 I8.096 J6.439 E.77662
G3 X124.616 Y133.178 I.338 J.956 E.01007
G3 X125.687 Y133.908 I-.037 J1.206 E.03961
G3 X125.742 Y134.912 I-.958 J.556 E.03022
G1 X125.701 Y134.989 E.00255
; WIPE_START
G1 X125.658 Y135.068 E-.0341
G1 X125.549 Y135.209 E-.06766
G1 X125.419 Y135.331 E-.0676
G1 X125.272 Y135.43 E-.06768
G1 X125.126 Y135.497 E-.06079
G1 X124.582 Y135.684 E-.21847
G1 X124.048 Y135.841 E-.21182
G1 X123.966 Y135.861 E-.03188
; WIPE_END
G1 E-.04 F1800
G1 X129.304 Y130.406 Z1.771 F30000
G1 X150.422 Y108.825 Z1.771
G1 Z1.371
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.425 Y108.824 E.00008
G3 X151.064 Y108.669 I.75 J1.701 E.01777
G1 X151.285 Y108.669 E.00592
G3 X150.229 Y108.925 I-.11 J1.855 E.28397
G1 X150.369 Y108.853 E.00423
; WIPE_START
M204 S10000
G1 X150.425 Y108.824 E-.02388
G1 X150.631 Y108.747 E-.08372
G1 X150.845 Y108.695 E-.08377
G1 X151.064 Y108.669 E-.08379
G1 X151.285 Y108.669 E-.08373
G1 X151.504 Y108.695 E-.08379
G1 X151.718 Y108.747 E-.08376
G1 X151.924 Y108.824 E-.08375
G1 X152.121 Y108.924 E-.08375
G1 X152.265 Y109.022 E-.06607
; WIPE_END
G1 E-.04 F1800
G1 X152.408 Y116.653 Z1.771 F30000
G1 X152.797 Y137.423 Z1.771
G1 Z1.371
G1 E.8 F1800
G1 F9000
M204 S5000
G3 X151.064 Y134.672 I-1.622 J-.9 E.20653
G1 X151.285 Y134.672 E.00592
G3 X152.825 Y137.37 I-.11 J1.852 E.09889
M204 S10000
G1 X153.596 Y137.521 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.361874
G1 F15000
G1 X153.568 Y137.632 E.00261
; LINE_WIDTH: 0.411147
G3 X153.502 Y137.825 I-1.961 J-.562 E.00536
; LINE_WIDTH: 0.455701
G1 X153.5 Y137.83 E.00017
G3 X153.131 Y138.334 I-1.361 J-.611 E.01846
; LINE_WIDTH: 0.407373
G3 X152.975 Y138.451 I-1.197 J-1.43 E.00507
; LINE_WIDTH: 0.372648
G1 X152.569 Y138.71 E.01132
G1 X153.596 Y137.521 F30000
; LINE_WIDTH: 0.336513
G1 F15000
G1 X153.6 Y137.503 E.00038
; LINE_WIDTH: 0.309435
G1 X153.624 Y137.356 E.00285
; LINE_WIDTH: 0.261368
G1 X153.648 Y137.211 E.00231
; LINE_WIDTH: 0.220385
G1 X153.665 Y137.053 E.00204
; LINE_WIDTH: 0.188721
G1 X153.68 Y136.907 E.00156
; LINE_WIDTH: 0.155057
G1 X153.69 Y136.308 E.00496
; LINE_WIDTH: 0.176582
G1 X153.668 Y136.009 E.00293
; LINE_WIDTH: 0.219113
G1 X153.647 Y135.853 E.00201
; LINE_WIDTH: 0.259567
G1 X153.628 Y135.707 E.0023
; LINE_WIDTH: 0.28682
G1 X153.592 Y135.525 E.00325
G1 X153.5 Y135.528 F30000
; LINE_WIDTH: 0.158867
G1 F15000
G1 X153.447 Y135.443 E.00086
; LINE_WIDTH: 0.128832
G1 X153.376 Y135.345 E.00078
; LINE_WIDTH: 0.103554
G1 X153.306 Y135.247 E.00056
G1 X153.5 Y135.528 F30000
; LINE_WIDTH: 0.193284
G1 F15000
G1 X153.551 Y135.607 E.00103
; LINE_WIDTH: 0.256831
G1 X153.622 Y135.675 E.00152
G1 X153.642 Y135.633 E.00072
; LINE_WIDTH: 0.230872
G1 X153.662 Y135.591 E.00063
; LINE_WIDTH: 0.191049
G1 X153.682 Y135.549 E.0005
; LINE_WIDTH: 0.167862
G1 X153.678 Y135.415 E.00123
; LINE_WIDTH: 0.145152
G2 X153.656 Y135.193 I-2.273 J.114 E.0017
; LINE_WIDTH: 0.105598
G1 X153.637 Y135.082 E.00054
G1 X151.767 Y133.991 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X150.172 Y134.122 I-.568 J2.882 E.04694
G1 X153.47 Y130.823 E.13507
G1 X153.47 Y131.582 E.02197
G1 X130.38 Y108.491 E.94547
G1 X129.747 Y108.491 E.01833
G1 X127.89 Y110.36 E.07628
G3 X132.112 Y113.802 I-7.094 J13.013 E.15863
G1 X137.425 Y108.489 E.21754
G1 X138.053 Y108.489 E.0182
G1 X153.47 Y123.906 E.63127
G1 X153.471 Y123.147 E.02197
G1 X138.05 Y138.568 E.63142
G1 X137.429 Y138.568 E.01797
G1 X132.119 Y133.258 E.21743
G1 X132.012 Y133.386 E.00483
G3 X127.88 Y136.695 I-11.355 J-9.945 E.15406
G1 X129.753 Y138.568 E.0767
G1 X130.374 Y138.568 E.01797
G1 X153.471 Y115.471 E.94572
G1 X153.471 Y116.23 E.02197
G1 X150.173 Y112.932 E.13502
G2 X151.769 Y113.067 I1.038 J-2.778 E.04695
G1 X153.378 Y111.679 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.103558
G1 F15000
G1 X153.443 Y111.577 E.00056
; LINE_WIDTH: 0.128827
G1 X153.507 Y111.476 E.00078
; LINE_WIDTH: 0.160234
G1 X153.559 Y111.381 E.00093
; LINE_WIDTH: 0.202269
G1 X153.595 Y111.346 E.00059
; LINE_WIDTH: 0.248065
G1 X153.632 Y111.31 E.00075
; LINE_WIDTH: 0.254307
G1 X153.648 Y111.349 E.00064
; LINE_WIDTH: 0.220967
G1 X153.665 Y111.387 E.00054
; LINE_WIDTH: 0.187627
G1 X153.682 Y111.426 E.00044
; LINE_WIDTH: 0.168919
G3 X153.678 Y111.638 I-4.271 J.039 E.00196
; LINE_WIDTH: 0.14506
G3 X153.656 Y111.86 I-2.275 J-.114 E.0017
; LINE_WIDTH: 0.105568
G1 X153.637 Y111.971 E.00054
G1 X153.612 Y111.429 F30000
; LINE_WIDTH: 0.253308
G1 F15000
G1 X153.65 Y111.197 E.00357
; LINE_WIDTH: 0.219127
G1 X153.665 Y111.051 E.00188
; LINE_WIDTH: 0.187896
G1 X153.681 Y110.896 E.00164
; LINE_WIDTH: 0.154816
G1 X153.689 Y110.298 E.00494
; LINE_WIDTH: 0.177824
G1 X153.667 Y109.997 E.00299
; LINE_WIDTH: 0.220396
G1 X153.647 Y109.851 E.0019
; LINE_WIDTH: 0.261602
G1 X153.625 Y109.69 E.00255
; LINE_WIDTH: 0.297483
G1 X153.612 Y109.621 E.00129
; LINE_WIDTH: 0.324466
G1 X153.598 Y109.552 E.00142
; LINE_WIDTH: 0.363635
G2 X153.563 Y109.4 I-1.458 J.255 E.00357
; LINE_WIDTH: 0.400933
G1 X153.536 Y109.319 E.00216
; LINE_WIDTH: 0.441134
G2 X153.431 Y109.087 I-2.013 J.775 E.00723
; LINE_WIDTH: 0.46023
G2 X153.141 Y108.731 I-1.202 J.681 E.01369
; LINE_WIDTH: 0.415911
G2 X153.007 Y108.623 I-1.016 J1.123 E.00457
; LINE_WIDTH: 0.363402
G2 X152.539 Y108.341 I-2.938 J4.342 E.01252
G1 X152.43 Y108.341 F30000
; LINE_WIDTH: 0.278545
G1 F15000
G3 X153.527 Y108.838 I-8.053 J19.214 E.02039
; WIPE_START
G1 X152.43 Y108.341 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.956 Y108.362 Z1.771 F30000
G1 Z1.371
G1 E.8 F1800
; LINE_WIDTH: 0.109515
G1 F15000
G1 X149.858 Y108.388 E.00051
G1 X149.709 Y108.517 E.001
G1 X134.295 Y117.176 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G1 X134.49 Y117.605 E.01362
G3 X134.904 Y118.686 I-20.209 J8.365 E.03352
G1 X145.103 Y108.486 E.41761
G1 X145.727 Y108.486 E.01806
G1 X148.763 Y111.522 E.1243
G2 X149.129 Y112.136 I2.385 J-1.005 E.02078
G1 X135.543 Y125.723 E.5563
G1 X135.476 Y126.157 E.01273
G3 X134.903 Y128.366 I-15.521 J-2.847 E.06613
G1 X145.105 Y138.568 E.41772
G1 X145.726 Y138.568 E.01797
G1 X148.771 Y135.523 E.12469
G3 X149.126 Y134.914 I2.528 J1.068 E.02047
G1 X135.545 Y121.332 E.5561
G3 X135.694 Y122.953 I-13.041 J2.016 E.04716
G1 X135.394 Y125.144 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.421087
G1 F15000
G1 X133.257 Y127.28 E.08137
G2 X133.456 Y126.538 I-8.405 J-2.653 E.02071
G1 X135.261 Y124.733 E.06872
G2 X135.298 Y124.153 I-6.956 J-.732 E.01566
G1 X133.602 Y125.849 E.06458
G2 X133.7 Y125.207 I-31.649 J-5.187 E.01748
G1 X135.312 Y123.596 E.06136
G1 X135.306 Y123.059 E.01446
G1 X133.764 Y124.6 E.0587
G2 X133.799 Y124.023 I-6.58 J-.684 E.01559
G1 X135.269 Y122.553 E.05598
G1 X135.232 Y122.046 E.01367
G1 X133.808 Y123.47 E.05421
G2 X133.796 Y122.939 I-6.071 J-.124 E.0143
G1 X135.177 Y121.558 E.05259
G1 X135.105 Y121.086 E.01285
G1 X133.763 Y122.428 E.0511
G2 X133.711 Y121.937 I-5.642 J.35 E.01331
G1 X135.022 Y120.626 E.0499
G1 X134.923 Y120.181 E.01226
G1 X133.643 Y121.461 E.04874
G2 X133.561 Y121.001 I-5.312 J.713 E.01261
G1 X134.807 Y119.754 E.04747
G1 X134.686 Y119.332 E.01182
G1 X133.465 Y120.553 E.04648
G2 X133.357 Y120.117 I-5.02 J1.011 E.01209
G1 X134.564 Y118.911 E.04595
G1 X134.422 Y118.51 E.01145
G1 X133.235 Y119.696 E.04517
G2 X133.101 Y119.287 I-4.745 J1.328 E.0116
G1 X134.271 Y118.117 E.04454
G1 X134.113 Y117.731 E.01122
G1 X132.958 Y118.887 E.04401
G2 X132.805 Y118.497 I-4.549 J1.558 E.01129
G1 X133.944 Y117.358 E.04337
G1 X133.766 Y116.992 E.01095
G1 X132.639 Y118.119 E.04292
G2 X132.464 Y117.751 I-4.299 J1.819 E.01098
G1 X133.582 Y116.632 E.04259
G1 X133.388 Y116.284 E.01075
G1 X132.281 Y117.39 E.04214
G1 X132.089 Y117.039 E.01078
G1 X133.186 Y115.943 E.04176
G1 X132.988 Y115.622 E.01014
G1 X132.978 Y115.607 E.00049
G1 X131.883 Y116.702 E.04171
G1 X131.675 Y116.367 E.01062
G1 X132.76 Y115.282 E.0413
G1 X132.649 Y115.118 E.00533
G1 X132.535 Y114.963 E.00517
G1 X131.452 Y116.046 E.04125
G1 X131.227 Y115.728 E.0105
G1 X132.305 Y114.65 E.04103
G1 X132.059 Y114.353 E.01039
G1 X130.994 Y115.418 E.04053
G2 X130.752 Y115.116 I-3.523 J2.577 E.01041
G1 X131.811 Y114.058 E.04031
G1 X131.563 Y113.762 E.01038
G1 X130.499 Y114.826 E.04053
G2 X130.239 Y114.543 I-3.366 J2.825 E.01036
G1 X131.302 Y113.479 E.04049
G1 X131.09 Y113.256 E.00829
G1 X131.036 Y113.203 E.00205
G1 X129.973 Y114.265 E.04046
G1 X129.696 Y113.999 E.01035
G1 X130.76 Y112.936 E.04051
G1 X130.477 Y112.675 E.01035
G1 X129.412 Y113.74 E.04055
G2 X129.122 Y113.487 I-3.045 J3.193 E.01037
G1 X130.189 Y112.42 E.04064
G1 X129.891 Y112.175 E.0104
G1 X128.821 Y113.244 E.04073
G2 X128.511 Y113.011 I-2.26 J2.682 E.01045
G1 X129.587 Y111.935 E.04096
G1 X129.277 Y111.702 E.01045
G1 X128.195 Y112.784 E.0412
G2 X127.869 Y112.567 I-2.013 J2.669 E.01056
G1 X128.955 Y111.48 E.04139
G2 X128.63 Y111.262 I-3.015 J4.134 E.01054
G1 X127.536 Y112.357 E.04169
G2 X127.199 Y112.15 I-1.865 J2.666 E.01064
G1 X128.297 Y111.052 E.04182
G1 X127.954 Y110.852 E.0107
G1 X126.848 Y111.957 E.0421
G2 X126.487 Y111.775 I-2.272 J4.042 E.01089
G1 X127.605 Y110.657 E.04256
G1 X127.247 Y110.472 E.01085
G1 X126.119 Y111.6 E.04297
G1 X125.742 Y111.434 E.01109
G1 X126.88 Y110.296 E.04333
G2 X126.506 Y110.127 I-2.217 J4.401 E.01106
G1 X125.351 Y111.281 E.04397
G2 X124.949 Y111.14 I-1.474 J3.562 E.01148
G1 X126.122 Y109.967 E.04469
G1 X125.728 Y109.818 E.01135
G1 X124.54 Y111.006 E.04525
G2 X124.114 Y110.889 I-1.21 J3.563 E.0119
G1 X125.326 Y109.677 E.04616
G1 X124.915 Y109.544 E.01162
G1 X123.684 Y110.775 E.04689
G2 X123.237 Y110.678 I-1.022 J3.628 E.01231
G1 X124.489 Y109.427 E.04766
G1 X124.056 Y109.317 E.01204
G1 X122.776 Y110.596 E.04871
G2 X122.301 Y110.529 I-1.012 J5.401 E.01294
G1 X123.609 Y109.221 E.04981
G1 X123.225 Y109.156 E.01048
G1 X123.184 Y109.102 E.00181
G1 X121.809 Y110.477 E.05235
G1 X121.3 Y110.443 E.01375
G1 X123.052 Y108.691 E.06673
G1 X122.88 Y108.481 E.0073
G1 X122.718 Y108.481 E.00436
G1 X120.763 Y110.437 E.07447
G2 X120.207 Y110.449 I-.176 J4.731 E.01496
G1 X122.175 Y108.481 E.07492
G1 X121.631 Y108.482 E.01463
G1 X119.637 Y110.476 E.07595
G2 X119.031 Y110.539 I.212 J5.011 E.01641
G1 X121.088 Y108.482 E.07833
G1 X120.544 Y108.482 E.01463
G1 X118.387 Y110.639 E.08215
G2 X117.699 Y110.784 I1.317 J7.954 E.01895
G1 X120.001 Y108.482 E.08767
G1 X119.457 Y108.482 E.01463
G1 X116.957 Y110.983 E.09523
G2 X116.14 Y111.256 I4.333 J14.307 E.02319
G1 X118.914 Y108.482 E.10562
G1 X118.54 Y108.482 E.01007
G1 X118.346 Y108.719 E.00824
G1 X118.367 Y108.936 E.00586
G1 X118.198 Y109.156 E.00747
G1 X117.586 Y109.267 E.01676
G1 X115.21 Y111.643 E.09046
G2 X114.06 Y112.25 I3.573 J8.164 E.03505
G1 X116.864 Y109.446 E.10676
G1 X116.519 Y109.542 E.00965
G1 X116.069 Y109.697 E.0128
G1 X106.511 Y119.255 E.36398
G1 X106.512 Y119.798 E.01462
G1 X109.439 Y116.871 E.11146
G2 X108.83 Y118.024 I7.508 J4.706 E.03513
G1 X106.512 Y120.341 E.08825
G1 X106.513 Y120.884 E.01462
G1 X108.443 Y118.953 E.07352
G2 X108.17 Y119.77 I13.992 J5.136 E.02319
G1 X106.513 Y121.427 E.06309
G1 X106.513 Y121.97 E.01462
G1 X107.971 Y120.512 E.05551
G2 X107.826 Y121.2 I7.797 J2.002 E.01895
G1 X106.514 Y122.512 E.04997
G1 X106.514 Y123.055 E.01462
G1 X107.726 Y121.844 E.04612
G2 X107.662 Y122.451 I6.93 J1.032 E.01643
G1 X106.515 Y123.598 E.04369
G1 X106.515 Y124.141 E.01462
G1 X107.627 Y123.029 E.04235
G2 X107.618 Y123.582 I6.329 J.387 E.0149
G1 X106.516 Y124.684 E.04196
G1 X106.516 Y125.226 E.01462
G1 X107.63 Y124.113 E.04241
G1 X107.664 Y124.622 E.01375
G1 X106.517 Y125.769 E.04368
G1 X106.517 Y126.312 E.01462
G1 X107.716 Y125.114 E.04563
G2 X107.787 Y125.586 I4.299 J-.406 E.01286
G1 X106.518 Y126.855 E.04832
G1 X106.518 Y127.398 E.01462
G1 X107.866 Y126.05 E.05132
G1 X107.967 Y126.492 E.01222
M73 P59 R7
G1 X106.519 Y127.941 E.05515
G1 X106.519 Y128.483 E.01462
G1 X108.068 Y126.935 E.05898
G1 X108.191 Y127.355 E.01179
G1 X106.807 Y128.739 E.05271
G1 X106.903 Y128.723 E.00263
G1 X107.12 Y128.849 E.00675
G1 X107.154 Y128.936 E.0025
G1 X108.325 Y127.764 E.04459
G2 X108.468 Y128.164 I4.657 J-1.444 E.01144
G1 X107.314 Y129.318 E.04393
G1 X107.482 Y129.694 E.01108
G1 X108.621 Y128.555 E.04336
G1 X108.787 Y128.932 E.01109
G1 X107.658 Y130.061 E.04299
G1 X107.845 Y130.417 E.01084
G1 X108.964 Y129.298 E.0426
G1 X109.147 Y129.658 E.01088
G1 X108.038 Y130.768 E.04224
G1 X108.239 Y131.11 E.01069
G1 X109.342 Y130.007 E.04202
G1 X109.543 Y130.349 E.01069
G1 X108.449 Y131.443 E.04165
G1 X108.665 Y131.77 E.01056
G1 X109.75 Y130.686 E.04129
G1 X109.968 Y131.011 E.01054
G1 X108.89 Y132.089 E.04104
G2 X109.123 Y132.399 I3.851 J-2.644 E.01045
G1 X110.196 Y131.326 E.04088
G2 X110.431 Y131.634 I3.65 J-2.539 E.01044
G1 X109.36 Y132.705 E.04078
G1 X109.608 Y133.001 E.01038
G1 X110.674 Y131.935 E.04058
G2 X110.927 Y132.225 I3.438 J-2.747 E.01037
G1 X109.862 Y133.29 E.04055
G1 X110.121 Y133.574 E.01036
G1 X111.186 Y132.509 E.04057
G1 X111.452 Y132.786 E.01035
G1 X110.391 Y133.848 E.04042
G1 X110.552 Y134.01 E.00616
G1 X110.666 Y134.116 E.00419
G1 X111.73 Y133.052 E.04051
G2 X112.013 Y133.312 I3.115 J-3.113 E.01036
G1 X110.947 Y134.378 E.04059
G2 X111.238 Y134.63 I3.164 J-3.352 E.01037
G1 X112.303 Y133.565 E.04055
G2 X112.605 Y133.807 I2.942 J-3.359 E.01041
G1 X111.534 Y134.878 E.04077
G1 X111.838 Y135.117 E.01042
G1 X112.912 Y134.043 E.0409
G2 X113.227 Y134.272 I2.827 J-3.547 E.01047
G1 X112.15 Y135.348 E.04098
G2 X112.468 Y135.574 I2.86 J-3.677 E.01049
G1 X113.553 Y134.489 E.04132
G2 X113.886 Y134.699 I2.566 J-3.698 E.01061
G1 X112.795 Y135.79 E.04154
G1 X113.129 Y135.999 E.01062
G1 X114.226 Y134.902 E.04176
G1 X114.577 Y135.094 E.01078
G1 X113.469 Y136.202 E.0422
G1 X113.821 Y136.394 E.01078
G1 X114.938 Y135.277 E.04253
G2 X115.306 Y135.452 I2.186 J-4.121 E.01098
G1 X114.179 Y136.579 E.04292
G1 X114.543 Y136.758 E.01093
G1 X115.684 Y135.618 E.04344
G2 X116.074 Y135.771 I1.951 J-4.401 E.01129
G1 X114.92 Y136.925 E.04395
G1 X115.304 Y137.084 E.01119
G1 X116.474 Y135.914 E.04454
G2 X116.883 Y136.049 I1.742 J-4.625 E.0116
G1 X115.695 Y137.236 E.04523
G1 X116.099 Y137.376 E.0115
G1 X117.304 Y136.17 E.0459
G2 X117.744 Y136.274 I1.156 J-3.904 E.01216
G1 X116.512 Y137.506 E.04689
G1 X116.935 Y137.627 E.01183
G1 X118.189 Y136.372 E.04777
G1 X118.654 Y136.451 E.01269
G1 X117.369 Y137.736 E.04893
G1 X117.815 Y137.833 E.01229
G1 X119.123 Y136.524 E.04984
G2 X119.615 Y136.576 I.842 J-5.593 E.0133
G1 X118.273 Y137.918 E.05108
G1 X118.415 Y137.942 E.00388
G1 X118.582 Y138.152 E.00723
G1 X120.126 Y136.609 E.05877
G2 X120.657 Y136.621 I.407 J-6.058 E.0143
G1 X118.698 Y138.58 E.07459
G1 X119.241 Y138.58 E.01463
G1 X121.209 Y136.612 E.07496
G2 X121.787 Y136.577 I-.107 J-6.621 E.01559
G1 X119.784 Y138.58 E.07628
G1 X120.328 Y138.58 E.01463
G1 X122.394 Y136.513 E.0787
G2 X123.036 Y136.415 I-4.597 J-32.111 E.01748
G1 X120.871 Y138.58 E.08244
G1 X121.414 Y138.58 E.01463
G1 X123.725 Y136.269 E.08798
G2 X124.467 Y136.07 I-1.909 J-8.597 E.02071
G1 X121.958 Y138.58 E.09557
G1 X122.501 Y138.58 E.01463
G1 X135.104 Y125.977 E.47993
G1 X134.975 Y126.65 E.01844
G1 X123.839 Y137.785 E.42404
G2 X124.557 Y137.61 I-1.743 J-8.715 E.01991
G1 X134.796 Y127.371 E.38991
G1 X134.558 Y128.153 E.02202
G1 X125.339 Y137.372 E.35105
G1 X126.2 Y137.054 E.02473
G1 X134.245 Y129.009 E.30633
G1 X133.797 Y130 E.02926
G1 X127.189 Y136.608 E.25165
G1 X127.969 Y136.196 E.02377
G1 X128.409 Y135.932 E.01381
G1 X133.12 Y131.22 E.17941
G3 X131.711 Y133.129 I-12.326 J-7.626 E.06396
G3 X129.446 Y135.438 I-52.861 J-49.592 E.08712
G1 X125.999 Y134.539 F30000
G1 F15000
G1 X131.554 Y128.983 E.21155
G3 X131.113 Y128.882 I.156 J-1.694 E.01224
G1 X126.072 Y133.922 E.19195
G1 X125.877 Y133.574 E.01075
G1 X130.766 Y128.685 E.18616
G3 X130.457 Y128.451 I.801 J-1.377 E.01047
G1 X125.642 Y133.266 E.18336
G2 X125.336 Y133.028 I-.839 J.763 E.01048
G1 X130.221 Y128.143 E.18601
G3 X130.07 Y127.751 I1.415 J-.769 E.01135
G1 X124.942 Y132.879 E.1953
G2 X124.421 Y132.856 I-.326 J1.477 E.01409
G1 X130.046 Y127.232 E.21418
G1 X130.053 Y127.162 E.00189
G1 X130.265 Y126.47 E.0195
G1 X123.656 Y133.078 E.25165
G3 X122.918 Y133.273 I-1.494 J-4.152 E.0206
G1 X125.261 Y130.93 E.08923
G3 X124.142 Y131.506 I-3.251 J-4.946 E.03394
G1 X122.24 Y133.407 E.07241
G1 X121.623 Y133.482 E.01675
G1 X123.269 Y131.836 E.06267
G1 X122.536 Y132.025 E.02038
G1 X121.038 Y133.524 E.05705
G3 X120.501 Y133.517 I-.219 J-3.918 E.01446
G1 X121.868 Y132.15 E.05205
G1 X121.515 Y132.212 E.00964
G1 X121.391 Y132.084 E.00481
G1 X119.977 Y133.498 E.05387
G1 X119.487 Y133.444 E.01326
G1 X121.124 Y131.808 E.06233
G2 X120.757 Y131.631 I-.402 J.368 E.01124
G1 X119.011 Y133.377 E.06648
G1 X118.559 Y133.285 E.0124
G1 X119.674 Y132.17 E.04247
G1 X119.212 Y132.089 E.01264
G1 X118.12 Y133.181 E.04158
G1 X117.703 Y133.056 E.01174
G1 X118.765 Y131.993 E.04047
G1 X118.334 Y131.881 E.01201
G1 X117.293 Y132.922 E.03962
G1 X116.906 Y132.766 E.01124
G1 X117.918 Y131.754 E.03853
G1 X117.523 Y131.605 E.01136
G1 X116.521 Y132.607 E.03816
G1 X116.162 Y132.423 E.01086
G1 X117.136 Y131.449 E.03709
G1 X116.775 Y131.267 E.0109
G1 X115.804 Y132.238 E.03698
G3 X115.466 Y132.032 I.954 J-1.94 E.01066
G1 X116.413 Y131.085 E.03606
G3 X116.082 Y130.873 I.823 J-1.656 E.01061
G1 X115.135 Y131.821 E.03607
G3 X114.812 Y131.6 I1.442 J-2.46 E.01054
G1 X115.751 Y130.661 E.03578
G3 X115.439 Y130.43 I.924 J-1.578 E.01048
G1 X114.505 Y131.364 E.03557
G1 X114.211 Y131.114 E.01038
G1 X115.138 Y130.187 E.0353
G3 X114.843 Y129.939 I1.016 J-1.503 E.0104
G1 X113.917 Y130.865 E.03527
G3 X113.641 Y130.598 I1.802 J-2.147 E.01035
G1 X114.572 Y129.667 E.03546
G1 X114.3 Y129.395 E.01034
G1 X113.375 Y130.321 E.03524
G3 X113.122 Y130.03 I1.99 J-1.98 E.01038
G1 X114.052 Y129.1 E.03539
G1 X113.809 Y128.8 E.0104
G1 X112.878 Y129.73 E.03543
G3 X112.639 Y129.426 I1.535 J-1.456 E.01043
G1 X113.578 Y128.487 E.03577
G1 X113.365 Y128.157 E.01058
G1 X112.421 Y129.102 E.03598
G1 X112.202 Y128.777 E.01054
G1 X113.154 Y127.825 E.03624
G1 X112.964 Y127.471 E.0108
G1 X112.006 Y128.43 E.0365
G1 X111.814 Y128.079 E.01078
G1 X112.796 Y127.096 E.0374
G1 X112.63 Y126.719 E.01111
G1 X111.637 Y127.712 E.03784
G1 X111.472 Y127.333 E.01112
G1 X112.488 Y126.318 E.03866
G1 X112.357 Y125.905 E.01166
G1 X111.315 Y126.947 E.03967
G3 X111.177 Y126.542 I4.365 J-1.713 E.01153
G1 X112.241 Y125.478 E.04053
G3 X112.15 Y125.026 I4.191 J-1.084 E.01242
G1 X111.056 Y126.12 E.04165
G1 X110.955 Y125.678 E.01221
G1 X112.069 Y124.563 E.04244
G1 X112.028 Y124.328 E.00643
G1 X112.455 Y123.914 E.01602
G2 X112.608 Y123.481 I-.475 J-.41 E.01265
G1 X110.86 Y125.229 E.06656
G1 X110.795 Y124.751 E.013
G1 X112.425 Y123.121 E.06206
G1 X112.155 Y122.847 E.01034
G1 X110.743 Y124.26 E.05378
G1 X110.721 Y123.739 E.01404
G1 X112.09 Y122.369 E.05216
G3 X112.212 Y121.704 I6.491 J.844 E.01821
G1 X110.718 Y123.198 E.0569
G3 X110.763 Y122.61 I4.302 J.033 E.0159
G1 X112.401 Y120.972 E.06239
G1 X112.714 Y120.115 E.02454
G1 X110.833 Y121.996 E.07162
G1 X110.959 Y121.327 E.01834
G1 X113.295 Y118.991 E.08896
G3 X113.604 Y118.533 I3.298 J1.892 E.01488
G1 X113.407 Y118.336 E.00751
G1 X111.162 Y120.58 E.08547
G3 X111.466 Y119.733 I4.768 J1.233 E.02427
G1 X113.135 Y118.064 E.06355
G1 X112.863 Y117.793 E.01034
G1 X111.568 Y119.088 E.04934
; WIPE_START
G1 X112.863 Y117.793 E-.69635
G1 X112.982 Y117.911 E-.06366
; WIPE_END
G1 E-.04 F1800
G1 X114.858 Y115.798 Z1.771 F30000
G1 Z1.371
G1 E.8 F1800
G1 F15000
G1 X115.871 Y114.785 E.03857
G3 X116.922 Y114.277 I3.296 J5.476 E.0315
G1 X115.251 Y115.948 E.06364
G1 X115.523 Y116.22 E.01034
G1 X117.768 Y113.974 E.08551
G3 X118.514 Y113.772 I2.189 J6.597 E.02081
G1 X116.178 Y116.108 E.08896
G1 X116.488 Y115.925 E.00969
G1 X117.302 Y115.527 E.02442
G1 X119.183 Y113.646 E.07162
G3 X119.807 Y113.566 I1.4 J8.432 E.01693
G1 X118.159 Y115.214 E.06276
G3 X118.891 Y115.025 I2.2 J7.006 E.02038
G1 X120.378 Y113.538 E.05662
G3 X120.926 Y113.534 I.298 J2.98 E.01477
G1 X119.556 Y114.903 E.05215
G1 X119.907 Y114.842 E.00959
G1 X120.034 Y114.968 E.00483
G1 X121.447 Y113.556 E.05378
G3 X121.939 Y113.607 I-.047 J2.862 E.01335
G1 X120.308 Y115.238 E.06212
G2 X120.666 Y115.423 I.382 J-.301 E.0112
G1 X122.416 Y113.673 E.06663
G1 X122.871 Y113.761 E.01249
G1 X121.75 Y114.882 E.04268
G1 X122.213 Y114.963 E.01264
G1 X123.302 Y113.874 E.04146
G1 X123.727 Y113.992 E.01188
G1 X122.664 Y115.055 E.04044
G3 X123.097 Y115.166 I-.829 J4.116 E.01202
G1 X124.134 Y114.128 E.03951
G3 X124.52 Y114.285 I-.949 J2.885 E.01123
G1 X123.507 Y115.298 E.03858
G1 X123.902 Y115.447 E.01136
G1 X124.899 Y114.45 E.03798
G3 X125.266 Y114.627 I-.781 J2.085 E.01097
G1 X124.291 Y115.602 E.03713
G3 X124.658 Y115.778 I-.918 J2.387 E.01098
G1 X125.617 Y114.819 E.03652
G3 X125.964 Y115.015 I-.898 J1.987 E.01075
G1 X125.004 Y115.975 E.03656
G1 X125.349 Y116.173 E.01072
G1 X126.289 Y115.234 E.03577
G1 X126.613 Y115.452 E.01054
G1 X125.671 Y116.394 E.03588
G1 X125.987 Y116.622 E.01048
G1 X126.917 Y115.692 E.03543
G1 X127.217 Y115.935 E.0104
G1 X126.29 Y116.862 E.03528
G1 X126.576 Y117.119 E.01036
G1 X127.508 Y116.188 E.03546
G3 X127.785 Y116.454 I-2.768 J3.163 E.01035
G1 X126.862 Y117.376 E.03513
G1 X127.12 Y117.662 E.01036
G1 X128.051 Y116.73 E.03548
G1 X128.301 Y117.024 E.01038
G1 X127.377 Y117.948 E.03519
G3 X127.617 Y118.252 I-1.3 J1.273 E.01044
G1 X128.551 Y117.318 E.03557
G3 X128.787 Y117.625 I-2.113 J1.871 E.01044
G1 X127.845 Y118.567 E.03589
G3 X128.066 Y118.889 I-1.396 J1.197 E.01054
G1 X129.007 Y117.948 E.03585
G1 X129.219 Y118.28 E.0106
G1 X128.264 Y119.235 E.03638
G1 X128.461 Y119.58 E.01072
G1 X129.426 Y118.615 E.03675
G3 X129.616 Y118.969 I-2.474 J1.558 E.01081
G1 X128.63 Y119.955 E.03755
G1 X128.796 Y120.333 E.01111
G1 X129.787 Y119.341 E.03776
G1 X129.958 Y119.713 E.01103
G1 X128.939 Y120.733 E.03883
G1 X129.069 Y121.146 E.01166
G1 X130.104 Y120.11 E.03943
G1 X130.246 Y120.512 E.01147
G1 X129.185 Y121.573 E.04041
G3 X129.276 Y122.025 I-4.186 J1.084 E.01242
G1 X130.371 Y120.93 E.0417
G3 X130.478 Y121.367 I-4.716 J1.385 E.0121
G1 X129.357 Y122.488 E.04269
G1 X129.398 Y122.719 E.00634
G1 X128.916 Y123.207 E.01845
G2 X128.82 Y123.568 I.488 J.324 E.01025
G1 X130.561 Y121.827 E.06633
G1 X130.635 Y122.296 E.0128
G1 X128.995 Y123.937 E.06248
G1 X129.27 Y124.204 E.01035
G1 X130.68 Y122.795 E.05366
G1 X130.712 Y123.306 E.01378
G1 X129.337 Y124.681 E.05238
G3 X129.215 Y125.346 I-6.287 J-.805 E.0182
G1 X130.701 Y123.861 E.05655
G3 X130.673 Y124.431 I-4.17 J.086 E.0154
G1 X129.025 Y126.08 E.06276
G1 X128.708 Y126.94 E.02468
G1 X130.588 Y125.06 E.07159
G3 X130.471 Y125.72 I-4.867 J-.521 E.01807
G1 X127.461 Y128.73 E.11463
; WIPE_START
G1 X128.875 Y127.316 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X121.853 Y130.305 Z1.771 F30000
G1 X110.982 Y134.931 Z1.771
G1 Z1.371
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G1 X109.603 Y136.311 E.05649
G3 X108.477 Y135.138 I5.136 J-6.059 E.04715
G1 X106.844 Y129.224 F30000
G1 F16200
G1 X107.059 Y129.726 E.0158
G2 X107.544 Y130.693 I19.626 J-9.232 E.03134
G1 X106.747 Y131.491 E.03265
G3 X106.621 Y130.788 I3.615 J-1.011 E.0207
G1 X114.302 Y138.469 E.31449
G2 X115.047 Y138.543 I.76 J-3.858 E.02172
G1 X115.874 Y137.716 E.03385
G1 X116.105 Y137.796 E.00708
G2 X117.44 Y138.158 I5.63 J-18.122 E.04006
; WIPE_START
G1 X116.105 Y137.796 E-.52571
G1 X115.874 Y137.716 E-.09288
G1 X115.61 Y137.979 E-.14141
; WIPE_END
G1 E-.04 F1800
G1 X112.276 Y131.113 Z1.771 F30000
G1 X106.338 Y118.885 Z1.771
G1 Z1.371
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.421087
G1 F15000
G1 X115.222 Y110.001 E.3383
G1 X114.811 Y110.172 E.01199
G2 X114.239 Y110.441 I2.935 J7.003 E.01702
G1 X107.632 Y117.048 E.2516
G1 X108.119 Y116.141 E.02772
G1 X108.315 Y115.821 E.01009
G1 X113.008 Y111.128 E.17871
G1 X112.18 Y111.68 E.0268
G1 X111.655 Y112.077 E.01772
G1 X111.225 Y112.429 E.01497
G1 X110.771 Y112.834 E.01637
G2 X108.809 Y114.784 I61.435 J63.784 E.07449
G1 X108.483 Y111.92 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G3 X109.598 Y110.737 I6.259 J4.777 E.04715
G1 X110.98 Y112.119 E.05662
G1 X117.445 Y108.894 F30000
G1 F16200
G1 X117.004 Y108.997 E.0131
G2 X115.881 Y109.344 I2.24 J9.239 E.03405
G1 X115.039 Y108.502 E.03448
G2 X114.302 Y108.584 I.206 J5.201 E.0215
G1 X106.611 Y116.275 E.3149
G3 X106.747 Y115.562 I7.05 J.977 E.02102
G1 X107.545 Y116.36 E.03268
G1 X107.449 Y116.535 E.00577
G2 X106.845 Y117.829 I14.126 J7.37 E.04137
; WIPE_START
G1 X107.449 Y116.535 E-.54282
G1 X107.545 Y116.36 E-.0757
G1 X107.282 Y116.097 E-.14148
; WIPE_END
G1 E-.04 F1800
G1 X114.031 Y119.662 Z1.771 F30000
G1 X149.592 Y138.448 Z1.771
G1 Z1.371
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.103556
G1 F15000
G1 X149.679 Y138.532 E.00056
; LINE_WIDTH: 0.128826
G1 X149.765 Y138.616 E.00078
; LINE_WIDTH: 0.151189
G1 X149.876 Y138.712 E.00118
; CHANGE_LAYER
; Z_HEIGHT: 1.56578
; LAYER_HEIGHT: 0.195083
; WIPE_START
G1 F15000
G1 X149.765 Y138.616 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 11/33
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
G17
G3 Z1.771 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.197 Y138.254
G1 Z1.566
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G3 X152.558 Y139.316 I-1.64 J-.734 E.06207
G1 X115.566 Y139.316 E1.1118
G3 X105.773 Y129.523 I.024 J-9.817 E.46204
G1 X105.773 Y117.529 E.36048
G3 X115.566 Y107.736 I9.817 J.024 E.46204
G1 X152.655 Y107.741 E1.11471
G3 X154.353 Y109.532 I-.093 J1.79 E.08182
G1 X154.353 Y111.521 E.05978
G3 X154.279 Y112.032 I-1.993 J-.027 E.01556
G1 X154.279 Y112.158 E.00379
G1 X154.279 Y134.895 E.68336
G2 X154.344 Y135.349 I2.737 J-.159 E.0138
G1 X154.353 Y137.521 E.06529
G3 X154.22 Y138.198 I-1.797 J-.001 E.02089
; WIPE_START
M204 S10000
G1 X154.011 Y138.578 E-.16472
G1 X153.761 Y138.856 E-.14218
G1 X153.458 Y139.076 E-.14216
G1 X153.116 Y139.228 E-.14222
G1 X152.75 Y139.306 E-.14217
G1 X152.681 Y139.31 E-.02656
; WIPE_END
G1 E-.04 F1800
G1 X152.093 Y131.7 Z1.966 F30000
G1 X150.296 Y108.453 Z1.966
G1 Z1.566
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16578.696
G1 X150.267 Y108.467 E.00104
G2 X151.729 Y108.345 I.907 J2.059 E.41021
G1 X151.755 Y108.129 E.00705
G3 X152.709 Y108.138 I.392 J9.6 E.03098
G3 X153.96 Y109.542 I-.169 J1.41 E.06668
G1 X153.96 Y111.511 E.06387
G3 X153.886 Y111.983 I-1.71 J-.026 E.01556
G1 X153.886 Y135.069 E.74891
G3 X153.96 Y135.542 I-1.636 J.498 E.01556
G1 X153.96 Y137.51 E.06387
G3 X152.547 Y138.923 I-1.404 J.009 E.07213
G1 X151.752 Y138.923 E.02579
G1 X151.721 Y138.715 E.00684
G2 X150.628 Y138.715 I-.547 J-2.184 E.42314
G1 X150.597 Y138.923 E.00685
G1 X115.571 Y138.923 E1.13623
G3 X106.166 Y129.518 I.018 J-9.423 E.47899
G1 X106.166 Y117.534 E.38876
G3 X115.571 Y108.129 I9.423 J.018 E.47899
G1 X150.594 Y108.129 E1.13615
G1 X150.62 Y108.345 E.00705
G1 X150.353 Y108.434 E.00912
; WIPE_START
G1 X150.267 Y108.467 E-.03489
G1 X150.028 Y108.585 E-.10139
G1 X149.807 Y108.735 E-.10151
G1 X149.604 Y108.909 E-.10151
G1 X149.424 Y109.106 E-.10146
G1 X149.268 Y109.323 E-.10152
G1 X149.139 Y109.557 E-.10147
G1 X149.039 Y109.804 E-.1015
G1 X149.029 Y109.842 E-.01475
; WIPE_END
G1 E-.04 F1800
G1 X143.779 Y115.382 Z1.966 F30000
G1 X125.281 Y134.906 Z1.966
G1 Z1.566
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.253 Y134.94 E.00134
G3 X125.076 Y135.082 I-.532 J-.478 E.00685
G3 X120.576 Y111.169 I-4.365 J-11.558 E1.29667
G3 X132.315 Y127.79 I.121 J12.37 E.71807
G3 X131.872 Y128.212 I-.726 J-.318 E.0189
G1 X131.819 Y128.229 E.00166
G3 X131.084 Y128.017 I-.143 J-.886 E.02376
G3 X130.779 Y127.3 I.407 J-.596 E.02475
G2 X122.022 Y112.869 I-10.095 J-3.747 E.58307
G2 X113.677 Y115.416 I-1.278 J10.756 E.26989
G1 X115.65 Y117.388 E.08383
G3 X119.654 Y115.634 I5.104 J6.202 E.13306
G2 X121.773 Y115.634 I1.06 J-.799 E.07377
G3 X128.606 Y122.467 I-1.081 J7.915 E.31192
G2 X128.606 Y124.586 I.798 J1.06 E.07377
G3 X121.773 Y131.419 I-7.944 J-1.111 E.31171
G2 X119.654 Y131.419 I-1.06 J.798 E.07377
G3 X112.821 Y124.586 I1.111 J-7.944 E.31171
G2 X112.821 Y122.467 I-.799 J-1.06 E.07377
G3 X114.575 Y118.463 I8.162 J1.19 E.13297
G1 X112.603 Y116.49 E.08383
G2 X110.09 Y125.092 I8.114 J7.038 E.27782
G2 X124.39 Y133.618 I10.627 J-1.569 E.57248
G3 X124.739 Y133.588 I.24 J.748 E.01063
G3 X125.338 Y134.101 I-.218 J.861 E.02457
G3 X125.322 Y134.85 I-.618 J.36 E.02368
G1 X125.316 Y134.857 E.00028
M204 S10000
G1 X125.668 Y135.04 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16578.696
G1 X125.651 Y135.064 E.00096
G3 X125.269 Y135.426 I-.933 J-.603 E.01723
G3 X118.131 Y136.013 I-4.564 J-11.803 E.23556
G3 X120.568 Y110.776 I2.583 J-12.487 E1.21039
M73 P60 R7
G3 X132.68 Y127.936 I.129 J12.764 E.80021
G3 X132.243 Y128.472 I-1.025 J-.39 E.02282
G3 X130.855 Y128.338 I-.601 J-1.034 E.04828
G3 X130.431 Y127.082 I.613 J-.907 E.0462
G2 X114.26 Y115.442 I-9.724 J-3.543 E.87048
G1 X115.68 Y116.862 E.06517
G3 X119.791 Y115.211 I5.236 J7.09 E.14526
G1 X120.103 Y115.531 E.01452
G2 X121.237 Y115.602 I.611 J-.663 E.03991
G2 X121.636 Y115.21 I-1.521 J-1.946 E.01817
G3 X124.232 Y115.953 I-1.369 J9.689 E.08787
G1 X124.467 Y116.064 E.00843
G3 X129.029 Y122.604 I-3.866 J7.558 E.26928
G1 X128.708 Y122.916 E.01453
G2 X128.637 Y124.051 I.664 J.611 E.0399
G2 X129.029 Y124.449 I1.947 J-1.522 E.01816
G3 X128.176 Y127.28 I-9.579 J-1.343 E.0963
G3 X121.636 Y131.842 I-7.558 J-3.866 E.26927
G1 X121.324 Y131.521 E.01452
G2 X120.189 Y131.45 I-.611 J.663 E.0399
G2 X119.791 Y131.842 I1.522 J1.947 E.01817
G3 X116.96 Y130.989 I1.343 J-9.578 E.0963
G3 X112.397 Y124.449 I3.866 J-7.558 E.26928
G1 X112.718 Y124.137 E.01452
G2 X112.789 Y123.002 I-.663 J-.611 E.0399
G2 X112.398 Y122.604 I-1.952 J1.525 E.01816
G3 X114.049 Y118.493 I8.524 J1.038 E.14535
G1 X112.629 Y117.073 E.06517
G2 X124.276 Y133.241 I8.087 J6.453 E.87118
G3 X124.616 Y133.183 I.337 J.953 E.01123
G3 X125.683 Y133.91 I-.038 J1.201 E.04421
G3 X125.735 Y134.909 I-.965 J.551 E.03364
G1 X125.695 Y134.986 E.00283
; WIPE_START
G1 X125.651 Y135.064 E-.03399
G1 X125.545 Y135.206 E-.06723
G1 X125.416 Y135.327 E-.06733
G1 X125.269 Y135.426 E-.06729
G1 X125.124 Y135.493 E-.06063
G1 X124.581 Y135.679 E-.21831
G1 X124.047 Y135.836 E-.21166
G1 X123.961 Y135.858 E-.03356
; WIPE_END
G1 E-.04 F1800
G1 X129.3 Y130.403 Z1.966 F30000
G1 X150.423 Y108.825 Z1.966
G1 Z1.566
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.425 Y108.824 E.00007
G3 X151.064 Y108.669 I.75 J1.701 E.01989
G3 X151.428 Y108.686 I.11 J1.534 E.01096
G1 X151.504 Y108.695 E.00229
G3 X150.164 Y108.965 I-.329 J1.83 E.30908
G1 X150.37 Y108.853 E.00704
; WIPE_START
M204 S10000
G1 X150.425 Y108.824 E-.02363
G1 X150.771 Y108.713 E-.13831
G1 X151.064 Y108.669 E-.11259
G1 X151.428 Y108.686 E-.1383
G1 X151.504 Y108.695 E-.02899
G1 X151.718 Y108.747 E-.08377
G1 X151.924 Y108.824 E-.08373
G1 X152.121 Y108.924 E-.08377
G1 X152.267 Y109.023 E-.06692
; WIPE_END
G1 E-.04 F1800
G1 X152.411 Y116.654 Z1.966 F30000
G1 X152.804 Y137.426 Z1.966
G1 Z1.566
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.802 Y137.426 E.00007
G3 X151.064 Y134.672 I-1.627 J-.899 E.23175
G3 X151.428 Y134.689 I.11 J1.536 E.01096
G1 X151.504 Y134.698 E.00229
G3 X152.896 Y137.227 I-.329 J1.829 E.09938
G1 X152.829 Y137.372 E.00479
M204 S10000
G1 X153.596 Y137.521 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.356363
G1 F15000
G1 X153.6 Y137.503 E.00047
; LINE_WIDTH: 0.329218
G1 X153.624 Y137.356 E.00339
; LINE_WIDTH: 0.281289
G1 X153.648 Y137.211 E.00279
; LINE_WIDTH: 0.240249
G1 X153.665 Y137.053 E.00251
; LINE_WIDTH: 0.208568
G1 X153.68 Y136.907 E.00194
; LINE_WIDTH: 0.174876
G1 X153.69 Y136.308 E.00633
; LINE_WIDTH: 0.196328
G1 X153.668 Y136.009 E.00368
; LINE_WIDTH: 0.238883
G1 X153.647 Y135.853 E.00247
; LINE_WIDTH: 0.279346
G1 X153.628 Y135.707 E.00277
; LINE_WIDTH: 0.31483
G1 X153.611 Y135.621 E.0019
; LINE_WIDTH: 0.345289
G1 X153.597 Y135.551 E.00174
; LINE_WIDTH: 0.380484
G1 X153.57 Y135.425 E.00345
; LINE_WIDTH: 0.431287
G2 X153.453 Y135.11 I-2.336 J.685 E.01041
G1 X153.596 Y137.521 F30000
; LINE_WIDTH: 0.381771
G1 F15000
G1 X153.568 Y137.632 E.00309
; LINE_WIDTH: 0.431027
G3 X153.502 Y137.826 I-1.95 J-.559 E.00634
; LINE_WIDTH: 0.475496
G1 X153.5 Y137.83 E.00018
G3 X153.13 Y138.334 I-1.361 J-.61 E.02169
; LINE_WIDTH: 0.419492
G3 X152.605 Y138.716 I-3.919 J-4.844 E.01951
; WIPE_START
G1 X153.13 Y138.334 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.897 Y138.719 Z1.966 F30000
G1 Z1.566
G1 E.8 F1800
; LINE_WIDTH: 0.158756
G1 F15000
G1 X149.769 Y138.609 E.00156
; LINE_WIDTH: 0.133562
G1 X149.683 Y138.526 E.00087
; LINE_WIDTH: 0.108434
G1 X149.598 Y138.442 E.00063
G1 X133.184 Y131.438 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.421075
G1 F15000
G1 X128.695 Y126.948 E.19136
G3 X128.521 Y127.311 I-1.782 J-.634 E.01214
G1 X132.851 Y131.641 E.18457
G1 X132.631 Y131.957 E.01161
G1 X128.342 Y127.667 E.18285
G3 X128.146 Y128.008 I-1.69 J-.743 E.01186
G1 X132.406 Y132.268 E.18159
G1 X132.173 Y132.571 E.01153
G1 X127.936 Y128.334 E.18062
G3 X127.722 Y128.657 I-2.122 J-1.172 E.01168
G1 X131.932 Y132.867 E.17945
G1 X131.687 Y133.158 E.01147
G1 X127.49 Y128.961 E.17889
G3 X127.238 Y129.245 I-1.895 J-1.427 E.01146
G1 X131.431 Y133.438 E.17874
G1 X131.303 Y133.579 E.00573
G1 X131.17 Y133.713 E.00571
G1 X126.984 Y129.528 E.17843
G3 X126.716 Y129.796 I-1.39 J-1.121 E.01145
G1 X130.903 Y133.983 E.17848
G3 X130.627 Y134.243 I-3.265 J-3.205 E.01144
G1 X126.434 Y130.05 E.17872
G3 X126.15 Y130.302 I-1.323 J-1.206 E.01147
G1 X130.345 Y134.498 E.17885
G1 X130.056 Y134.745 E.01146
G1 X125.838 Y130.527 E.1798
G1 X125.527 Y130.752 E.01158
G1 X129.759 Y134.984 E.18041
G1 X129.458 Y135.219 E.01152
G1 X125.196 Y130.957 E.18166
G1 X124.855 Y131.152 E.01185
G1 X129.146 Y135.443 E.18292
G1 X128.828 Y135.662 E.01162
G1 X124.506 Y131.34 E.18424
G3 X124.138 Y131.507 I-1.235 J-2.224 E.01222
G1 X128.505 Y135.875 E.18616
G1 X128.17 Y136.077 E.01177
G1 X126.084 Y133.99 E.08894
G3 X126.161 Y134.603 I-1.201 J.462 E.01881
G1 X127.831 Y136.273 E.07118
G1 X127.484 Y136.462 E.01191
G1 X126.05 Y135.029 E.06109
G3 X125.847 Y135.362 I-1.611 J-.756 E.01178
G1 X127.126 Y136.641 E.05451
G3 X126.762 Y136.813 I-2.247 J-4.265 E.01214
G1 X125.573 Y135.624 E.05069
G3 X125.224 Y135.812 I-.948 J-1.345 E.01196
G1 X126.39 Y136.978 E.0497
G3 X126.007 Y137.131 I-2.033 J-4.527 E.01244
G1 X124.825 Y135.949 E.0504
G3 X124.416 Y136.076 I-1.664 J-4.626 E.01292
G1 X125.617 Y137.277 E.0512
G1 X125.218 Y137.415 E.01271
G1 X123.996 Y136.193 E.05209
G3 X123.566 Y136.299 I-1.43 J-4.884 E.01336
G1 X124.807 Y137.539 E.05288
G1 X124.386 Y137.655 E.01315
G1 X123.12 Y136.389 E.05398
G3 X122.66 Y136.465 I-1.104 J-5.213 E.01405
G1 X123.956 Y137.762 E.05526
G1 X123.514 Y137.855 E.01364
G1 X122.186 Y136.528 E.05659
G3 X121.696 Y136.574 I-.778 J-5.593 E.01483
G1 X123.058 Y137.935 E.05803
G1 X123.01 Y137.943 E.00144
G1 X122.844 Y138.153 E.00805
G1 X122.851 Y138.265 E.00341
G1 X121.189 Y136.603 E.07086
G3 X120.662 Y136.612 I-.369 J-6.029 E.0159
G1 X122.639 Y138.589 E.08427
G1 X122.102 Y138.589 E.01616
G1 X120.112 Y136.599 E.08484
G3 X119.537 Y136.56 I.163 J-6.614 E.01739
G1 X121.566 Y138.589 E.08651
G1 X121.03 Y138.589 E.01616
G1 X118.929 Y136.488 E.08957
G1 X118.282 Y136.378 E.01977
G1 X120.494 Y138.589 E.09426
G1 X119.957 Y138.589 E.01616
G1 X117.601 Y136.233 E.10044
G3 X116.866 Y136.034 I1.497 J-7.001 E.02295
G1 X119.421 Y138.589 E.1089
G1 X118.885 Y138.589 E.01616
G1 X116.046 Y135.75 E.12102
G3 X115.112 Y135.352 I5.147 J-13.386 E.0306
G1 X117.535 Y137.775 E.10328
G1 X116.823 Y137.6 E.0221
G1 X113.385 Y134.162 E.14654
; WIPE_START
G1 X114.799 Y135.576 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X116.131 Y132.618 Z1.966 F30000
G1 Z1.566
G1 E.8 F1800
G1 F15000
G1 X112.058 Y128.545 E.17363
G3 X111.523 Y127.474 I5.57 J-3.45 E.03613
G1 X116.77 Y132.72 E.22363
G2 X117.629 Y133.043 I2.186 J-4.516 E.02769
G1 X111.185 Y126.599 E.27466
G3 X110.989 Y125.866 I5.23 J-1.796 E.02289
G1 X118.598 Y133.476 E.32438
G1 X116.674 Y131.015 F30000
G1 F15000
G1 X119.054 Y133.395 E.10145
G2 X119.668 Y133.473 I.732 J-3.306 E.01869
G1 X117.951 Y131.756 E.07319
G1 X118.093 Y131.81 E.00457
G1 X118.697 Y131.966 E.0188
G1 X120.252 Y133.521 E.0663
G1 X120.798 Y133.531 E.01646
G1 X119.376 Y132.109 E.06063
G1 X119.907 Y132.202 E.01625
G1 X119.956 Y132.152 E.0021
G1 X121.322 Y133.518 E.05823
G2 X121.808 Y133.468 I-.118 J-3.561 E.01475
G1 X120.22 Y131.88 E.06771
G3 X120.528 Y131.652 I.701 J.624 E.01164
G1 X122.287 Y133.411 E.07498
G2 X122.734 Y133.322 I-.26 J-2.479 E.01377
G1 X121.6 Y132.188 E.04835
G1 X122.056 Y132.108 E.01397
G1 X123.176 Y133.227 E.04772
G2 X123.592 Y133.107 I-.483 J-2.454 E.01307
G1 X122.508 Y132.023 E.0462
G1 X122.934 Y131.913 E.01326
G1 X124.003 Y132.981 E.04554
G1 X124.423 Y132.865 E.01314
G1 X123.358 Y131.801 E.04539
G1 X123.748 Y131.654 E.01255
G1 X125.343 Y133.249 E.06799
; WIPE_START
G1 X123.929 Y131.835 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X118.462 Y137.161 Z1.966 F30000
G1 X117.441 Y138.157 Z1.966
G1 Z1.566
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G1 X117.368 Y138.142 E.00242
G3 X115.874 Y137.715 I3.599 J-15.431 E.0504
G1 X115.041 Y138.549 E.03826
G3 X114.31 Y138.476 I.014 J-3.857 E.02387
G1 X106.613 Y130.78 E.35309
G2 X106.742 Y131.496 I3.813 J-.314 E.02364
G1 X107.545 Y130.692 E.03687
G1 X107.334 Y130.295 E.01459
G3 X106.845 Y129.223 I19.696 J-9.634 E.03823
G1 X108.799 Y132.257 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.421075
G1 F15000
G1 X110.576 Y134.034 E.07575
G2 X111.458 Y134.82 I9.883 J-10.208 E.03562
G1 X111.936 Y135.195 E.01831
G1 X112.428 Y135.549 E.01828
G1 X113.001 Y135.924 E.02064
G1 X108.316 Y131.238 E.19972
G3 X107.64 Y130.026 I14.285 J-8.76 E.04185
G1 X114.211 Y136.597 E.28008
G2 X115.09 Y137.002 I5.295 J-10.339 E.02918
G1 X115.192 Y137.042 E.00331
G1 X106.51 Y128.36 E.37009
G1 X106.51 Y127.823 E.01618
G1 X116.311 Y137.625 E.41781
G1 X108.472 Y135.143 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X109.598 Y136.316 I6.26 J-4.885 E.05283
G1 X110.983 Y134.931 E.06355
G1 X110.08 Y130.857 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.421075
G1 F15000
G1 X106.509 Y127.286 E.15221
G1 X106.509 Y126.749 E.01618
G1 X108.887 Y129.128 E.10138
G3 X108.489 Y128.194 I13.46 J-6.282 E.0306
G1 X106.508 Y126.213 E.08445
G1 X106.508 Y125.676 E.01618
G1 X108.206 Y127.374 E.0724
G3 X108.011 Y126.643 I5.794 J-1.94 E.02285
G1 X106.507 Y125.139 E.06409
G1 X106.507 Y124.602 E.01618
G1 X107.855 Y125.951 E.05748
G1 X107.749 Y125.309 E.01961
G1 X106.506 Y124.066 E.05299
G1 X106.506 Y123.529 E.01618
G1 X107.679 Y124.702 E.05002
G3 X107.64 Y124.127 I6.629 J-.741 E.01739
G1 X106.505 Y122.992 E.04836
G1 X106.505 Y122.455 E.01618
G1 X107.627 Y123.577 E.04782
G3 X107.636 Y123.05 I5.999 J-.157 E.01589
G1 X106.504 Y121.919 E.04824
G1 X106.504 Y121.382 E.01618
G1 X107.665 Y122.543 E.0495
G3 X107.712 Y122.053 I5.613 J.289 E.01483
G1 X106.503 Y120.845 E.05151
G1 X106.503 Y120.308 E.01618
G1 X107.774 Y121.58 E.0542
G3 X107.851 Y121.12 I5.306 J.651 E.01405
G1 X106.502 Y119.771 E.05749
G1 X106.502 Y119.235 E.01618
G1 X107.941 Y120.674 E.06134
G1 X108.046 Y120.243 E.01337
G1 X106.502 Y118.698 E.06584
G1 X106.501 Y118.262 E.01315
G1 X106.623 Y118.283 E.00372
G1 X108.164 Y119.824 E.06569
G3 X108.291 Y119.415 I4.738 J1.256 E.01291
G1 X107.098 Y118.222 E.05087
G1 X107.116 Y118.212 E.00061
G1 X107.262 Y117.85 E.01177
G1 X108.428 Y119.016 E.04971
G1 X108.578 Y118.63 E.01249
G1 X107.427 Y117.478 E.04909
G3 X107.598 Y117.113 I4.479 J1.874 E.01216
G1 X108.738 Y118.253 E.04862
G3 X108.906 Y117.885 I4.289 J1.734 E.0122
G1 X107.778 Y116.757 E.0481
G3 X107.968 Y116.41 I4.647 J2.324 E.01191
G1 X109.083 Y117.526 E.04755
G3 X109.272 Y117.178 I4.088 J1.991 E.01193
G1 X108.162 Y116.068 E.04731
G1 X108.366 Y115.736 E.01175
G1 X109.467 Y116.837 E.04694
G1 X109.67 Y116.503 E.01177
G1 X108.578 Y115.412 E.04654
G1 X108.795 Y115.092 E.01164
G1 X109.884 Y116.182 E.04644
G3 X110.105 Y115.866 I3.72 J2.369 E.01161
G1 X109.022 Y114.783 E.04616
G1 X109.258 Y114.483 E.01151
G1 X110.332 Y115.557 E.04579
G1 X110.571 Y115.259 E.0115
G1 X109.502 Y114.191 E.04555
G1 X109.747 Y113.899 E.01147
G1 X110.816 Y114.968 E.04557
G1 X111.066 Y114.682 E.01145
G1 X109.996 Y113.612 E.04561
G1 X110.257 Y113.337 E.01143
G1 X111.329 Y114.408 E.04566
G3 X111.597 Y114.14 I3.207 J2.94 E.01143
G1 X110.526 Y113.07 E.04563
G1 X110.8 Y112.807 E.01143
G1 X111.871 Y113.878 E.04565
G1 X112.156 Y113.627 E.01145
G1 X111.083 Y112.554 E.04574
G1 X111.372 Y112.307 E.01146
G1 X112.448 Y113.383 E.04585
G1 X112.746 Y113.144 E.0115
G1 X111.668 Y112.066 E.04595
G1 X111.973 Y111.835 E.01154
G1 X113.06 Y112.922 E.04634
G1 X113.374 Y112.7 E.0116
G1 X112.282 Y111.608 E.04656
G1 X112.599 Y111.389 E.01162
G1 X113.696 Y112.486 E.04675
G1 X114.027 Y112.28 E.01174
G1 X112.926 Y111.179 E.04696
G1 X113.257 Y110.974 E.01174
G1 X114.367 Y112.084 E.04732
G3 X114.715 Y111.895 I2.326 J3.879 E.01193
G1 X113.598 Y110.778 E.04761
G1 X113.947 Y110.591 E.01193
G1 X115.074 Y111.718 E.04806
G3 X115.443 Y111.55 I2.102 J4.124 E.01221
G1 X114.301 Y110.409 E.04865
G1 X114.667 Y110.238 E.01216
G1 X115.819 Y111.391 E.04912
G1 X116.205 Y111.241 E.01249
G1 X115.04 Y110.075 E.04967
G1 X115.421 Y109.92 E.0124
G1 X116.604 Y111.103 E.05045
G3 X117.013 Y110.976 I1.661 J4.606 E.01291
G1 X115.819 Y109.782 E.05089
G1 X116.218 Y109.644 E.01271
G1 X117.432 Y110.859 E.05177
G1 X117.863 Y110.753 E.01337
G1 X116.622 Y109.512 E.05293
G1 X117.041 Y109.395 E.01313
G1 X118.31 Y110.664 E.05407
G3 X118.769 Y110.587 I1.107 J5.22 E.01405
G1 X117.474 Y109.292 E.05522
G1 X117.92 Y109.202 E.01373
G1 X119.243 Y110.525 E.05639
G3 X119.735 Y110.481 I.601 J3.933 E.0149
G1 X118.29 Y109.035 E.06161
G1 X118.365 Y108.937 E.00372
G1 X118.344 Y108.719 E.0066
G1 X118.419 Y108.628 E.00357
G1 X120.248 Y110.457 E.07796
G3 X120.772 Y110.445 I.362 J4.396 E.01582
G1 X118.801 Y108.473 E.08404
G1 X119.337 Y108.473 E.01616
G1 X121.317 Y110.453 E.0844
G3 X121.893 Y110.493 I-.164 J6.619 E.0174
G1 X119.873 Y108.473 E.08609
G1 X120.409 Y108.473 E.01616
G1 X122.499 Y110.562 E.08907
G3 X123.141 Y110.668 I-.888 J7.388 E.01962
G1 X120.945 Y108.473 E.09359
G1 X121.481 Y108.473 E.01616
G1 X123.827 Y110.818 E.09997
G3 X124.566 Y111.021 I-1.949 J8.551 E.02311
G1 X122.018 Y108.472 E.10862
G1 X122.554 Y108.472 E.01616
G1 X125.687 Y111.605 E.13355
G1 X123.676 Y109.058 F30000
G1 F15000
G1 X126.32 Y111.702 E.1127
G3 X127.498 Y112.344 I-4.978 J10.539 E.04047
G1 X124.614 Y109.46 E.12294
G3 X125.384 Y109.694 I-2.215 J8.67 E.02429
G1 X134.547 Y118.857 E.39057
G1 X134.224 Y117.998 E.02766
G1 X126.241 Y110.015 E.34028
G1 X127.218 Y110.455 E.03228
G1 X133.781 Y117.018 E.27975
G1 X133.308 Y116.138 E.0301
G1 X133.101 Y115.801 E.01192
G1 X128.439 Y111.14 E.19871
G3 X129.245 Y111.677 I-6.629 J10.824 E.02922
G1 X129.732 Y112.043 E.01836
G1 X130.202 Y112.428 E.0183
G1 X130.655 Y112.832 E.01831
G3 X132.607 Y114.772 I-69.169 J71.569 E.08294
; WIPE_START
G1 X131.188 Y113.362 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.798 Y118.934 Z1.966 F30000
G1 Z1.566
G1 E.8 F1800
G1 F15000
G1 X125.743 Y114.879 E.17284
G2 X124.666 Y114.339 I-3.736 J6.102 E.03634
G1 X129.906 Y119.579 E.22336
G1 X129.995 Y119.772 E.0064
G1 X130.23 Y120.438 E.0213
G1 X123.806 Y114.015 E.27382
G2 X123.057 Y113.803 I-1.529 J3.97 E.02348
G1 X130.662 Y121.407 E.32417
G1 X128.196 Y119.477 F30000
G1 F15000
G1 X130.582 Y121.863 E.10171
G3 X130.669 Y122.486 I-8.119 J1.452 E.01898
G1 X128.935 Y120.753 E.07389
G3 X129.162 Y121.516 I-4.657 J1.799 E.02402
G1 X130.706 Y123.06 E.06579
G3 X130.717 Y123.607 I-2.977 J.333 E.01652
G1 X129.295 Y122.185 E.06059
G1 X129.388 Y122.715 E.01622
G1 X129.339 Y122.765 E.00211
G1 X130.702 Y124.129 E.05812
G3 X130.663 Y124.626 I-3.639 J-.033 E.01505
G1 X129.073 Y123.036 E.0678
G2 X128.84 Y123.339 I.401 J.55 E.01168
G1 X130.592 Y125.091 E.07469
G1 X130.516 Y125.551 E.01405
G1 X129.375 Y124.41 E.04862
G1 X129.295 Y124.867 E.01397
G1 X130.417 Y125.988 E.04781
G3 X130.295 Y126.403 I-3.293 J-.745 E.01303
G1 X129.212 Y125.32 E.04615
G3 X129.109 Y125.753 I-4.126 J-.75 E.01343
G1 X130.169 Y126.813 E.04517
G1 X130.062 Y127.164 E.01105
G1 X130.055 Y127.235 E.00216
G1 X128.988 Y126.169 E.04545
G1 X128.842 Y126.559 E.01255
G1 X130.094 Y127.811 E.05339
G2 X130.502 Y128.486 I1.356 J-.358 E.0241
G2 X131.063 Y128.855 I1.881 J-2.251 E.02029
G1 X131.178 Y128.895 E.00365
G1 X133.265 Y130.981 E.08895
G1 X133.463 Y130.643 E.01181
G1 X131.79 Y128.97 E.0713
G2 X132.218 Y128.862 I-.281 J-2.015 E.01334
G1 X133.649 Y130.293 E.06098
G1 X133.829 Y129.937 E.01203
G1 X132.55 Y128.658 E.05451
G2 X132.812 Y128.384 I-.96 J-1.178 E.01146
G1 X134.003 Y129.575 E.05076
G2 X134.164 Y129.2 I-4.42 J-2.125 E.01231
G1 X133 Y128.035 E.04965
G1 X133.136 Y127.635 E.01273
G1 X134.319 Y128.818 E.05041
G1 X134.467 Y128.429 E.01253
G1 X133.264 Y127.226 E.05128
G2 X133.38 Y126.807 I-4.743 J-1.548 E.01313
G1 X134.601 Y128.027 E.05202
G1 X134.727 Y127.617 E.01294
G1 X133.486 Y126.377 E.05288
G1 X133.576 Y125.93 E.01372
G1 X134.844 Y127.198 E.05404
G1 X134.949 Y126.767 E.01338
G1 X133.653 Y125.47 E.05526
G2 X133.715 Y124.996 I-5.397 J-.949 E.01442
G1 X135.041 Y126.323 E.05655
G2 X135.122 Y125.867 I-5.006 J-1.122 E.01395
G1 X133.761 Y124.506 E.05801
M73 P61 R7
G2 X133.79 Y123.999 I-5.795 J-.584 E.01533
G1 X135.192 Y125.401 E.05977
G1 X135.248 Y124.92 E.01459
G1 X133.799 Y123.472 E.06174
G2 X133.786 Y122.922 I-6.286 J-.12 E.01658
G1 X135.285 Y124.421 E.06392
G1 X135.307 Y123.907 E.01552
G1 X133.746 Y122.346 E.06653
G2 X133.676 Y121.74 I-6.946 J.492 E.01839
G1 X135.311 Y123.374 E.06967
G1 X135.289 Y122.817 E.01683
G1 X133.571 Y121.098 E.07325
G2 X133.422 Y120.413 I-7.915 J1.361 E.02114
G1 X135.247 Y122.238 E.07779
G1 X135.19 Y121.645 E.01796
G1 X133.22 Y119.675 E.08398
G2 X132.935 Y118.853 I-15.02 J4.753 E.02621
G1 X135.094 Y121.012 E.09202
G2 X134.96 Y120.342 I-8.114 J1.268 E.02059
G1 X132.536 Y117.919 E.10332
G2 X131.91 Y116.756 I-12.19 J5.819 E.03984
G1 X135.018 Y119.864 E.13248
G1 X135.693 Y122.952 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X135.544 Y121.331 I-13.194 J.396 E.05284
G1 X149.131 Y134.918 E.62336
G2 X148.783 Y135.51 I2.185 J1.684 E.02234
G1 X145.719 Y138.575 E.14058
G1 X145.112 Y138.575 E.0197
G1 X134.902 Y128.365 E.46838
G1 X135.029 Y127.985 E.01299
G2 X135.541 Y125.724 I-14.898 J-4.565 E.07529
G1 X149.134 Y112.132 E.62359
G3 X148.777 Y111.536 I1.978 J-1.591 E.0226
G1 X145.72 Y108.48 E.14023
G1 X145.11 Y108.48 E.0198
G1 X134.903 Y118.686 E.46826
G1 X134.726 Y118.191 E.01707
G2 X134.294 Y117.177 I-20.17 J7.992 E.03575
; WIPE_START
G1 X134.726 Y118.191 E-.41874
G1 X134.903 Y118.686 E-.19994
G1 X135.166 Y118.423 E-.14133
; WIPE_END
G1 E-.04 F1800
G1 X127.726 Y116.722 Z1.966 F30000
G1 X124.763 Y116.044 Z1.966
G1 Z1.566
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.421075
G1 F15000
G1 X122.373 Y113.655 E.10185
G2 X121.753 Y113.57 I-1.231 J6.735 E.01888
G1 X123.481 Y115.298 E.07365
G2 X122.724 Y115.077 I-2.424 J6.904 E.02378
G1 X121.182 Y113.535 E.06573
G2 X120.627 Y113.517 I-.379 J3.015 E.01676
G1 X122.054 Y114.944 E.06085
G1 X121.519 Y114.851 E.01636
G1 X121.473 Y114.899 E.00203
G1 X120.115 Y113.542 E.05785
G2 X119.614 Y113.577 I.003 J3.663 E.01516
G1 X121.208 Y115.171 E.06796
G3 X120.9 Y115.399 I-.603 J-.494 E.01168
G1 X119.141 Y113.641 E.07495
G2 X118.692 Y113.727 I.404 J3.316 E.01382
G1 X119.829 Y114.865 E.0485
G1 X119.373 Y114.944 E.01397
G1 X118.258 Y113.829 E.04753
G2 X117.835 Y113.943 I.405 J2.361 E.01322
G1 X118.92 Y115.028 E.04625
G2 X118.487 Y115.131 I.781 J4.247 E.01343
G1 X117.433 Y114.077 E.04491
G2 X117.036 Y114.217 I.563 J2.231 E.01269
G1 X118.072 Y115.253 E.04416
G1 X117.68 Y115.397 E.01259
G1 X116.664 Y114.381 E.04332
G1 X116.292 Y114.545 E.01226
G1 X117.289 Y115.542 E.0425
G1 X116.929 Y115.719 E.01208
G1 X115.945 Y114.734 E.04196
G1 X115.6 Y114.925 E.01189
G1 X116.569 Y115.895 E.04134
G2 X116.227 Y116.089 I1.082 J2.303 E.01187
G1 X115.266 Y115.128 E.04097
G2 X114.948 Y115.347 I1.55 J2.596 E.01163
G1 X116.025 Y116.423 E.0459
; WIPE_START
G1 X114.948 Y115.347 E-.57868
G1 X115.266 Y115.128 E-.14656
G1 X115.331 Y115.193 E-.03477
; WIPE_END
G1 E-.04 F1800
G1 X113.612 Y118.836 Z1.966 F30000
G1 Z1.566
G1 E.8 F1800
G1 F15000
G1 X112.535 Y117.76 E.0459
G2 X112.32 Y118.081 I1.741 J1.394 E.01167
G1 X113.278 Y119.039 E.0408
G2 X113.083 Y119.38 I2.104 J1.423 E.01187
G1 X112.116 Y118.413 E.04123
G2 X111.917 Y118.751 I1.743 J1.251 E.01183
G1 X112.907 Y119.74 E.04216
G1 X112.73 Y120.1 E.01208
G1 X111.74 Y119.109 E.04221
G1 X111.562 Y119.468 E.01206
G1 X112.585 Y120.491 E.04362
G1 X112.441 Y120.883 E.01259
G1 X111.41 Y119.853 E.04392
G1 X111.261 Y120.24 E.0125
G1 X112.318 Y121.297 E.04508
G2 X112.215 Y121.73 I4.132 J1.213 E.01343
G1 X111.127 Y120.643 E.04637
G2 X111.017 Y121.068 I3.039 J1.017 E.01327
G1 X112.132 Y122.183 E.04752
G1 X112.052 Y122.64 E.01397
G1 X110.915 Y121.502 E.0485
G2 X110.834 Y121.958 I2.443 J.668 E.01397
G1 X112.588 Y123.712 E.07476
G3 X112.36 Y124.02 I-.853 J-.393 E.01164
G1 X110.767 Y122.428 E.06786
G2 X110.729 Y122.925 I2.691 J.459 E.01507
G1 X112.088 Y124.284 E.05791
G1 X112.038 Y124.333 E.00209
G1 X112.131 Y124.863 E.01625
G1 X110.704 Y123.437 E.06081
G2 X110.722 Y123.991 I3.035 J.178 E.01675
G1 X112.263 Y125.532 E.06569
G2 X112.49 Y126.295 I4.881 J-1.033 E.024
G1 X110.761 Y124.566 E.07368
G1 X110.845 Y125.187 E.01886
G1 X113.211 Y127.553 E.10085
; WIPE_START
G1 X111.797 Y126.138 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X111.353 Y118.519 Z1.966 F30000
G1 X110.981 Y112.12 Z1.966
G1 Z1.566
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G1 X109.592 Y110.731 E.06375
G2 X108.479 Y111.915 I6.992 J7.684 E.05279
G1 X117.445 Y108.895 F30000
G1 F16200
G1 X117.004 Y108.998 E.01471
G2 X115.882 Y109.345 I2.239 J9.234 E.03812
G1 X115.033 Y108.496 E.03896
G2 X114.31 Y108.576 I.201 J5.095 E.02362
G1 X106.604 Y116.282 E.35353
G3 X106.74 Y115.555 I3.876 J.348 E.02405
G1 X107.546 Y116.361 E.037
G1 X107.196 Y117.037 E.02469
G2 X106.846 Y117.83 I21.538 J9.969 E.02812
; WIPE_START
G1 X107.196 Y117.037 E-.3294
G1 X107.546 Y116.361 E-.28927
G1 X107.283 Y116.098 E-.14133
; WIPE_END
G1 E-.04 F1800
G1 X114.797 Y114.757 Z1.966 F30000
G1 X149.714 Y108.522 Z1.966
G1 Z1.566
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.120615
G1 F15000
G1 X149.876 Y108.383 E.00134
G1 X149.986 Y108.352 E.00072
; WIPE_START
G1 X149.876 Y108.383 E-.26441
G1 X149.714 Y108.522 E-.49559
; WIPE_END
G1 E-.04 F1800
G1 X152.527 Y108.334 Z1.966 F30000
G1 Z1.566
G1 E.8 F1800
; LINE_WIDTH: 0.383144
G1 F15000
G3 X153.007 Y108.623 I-2.528 J4.736 E.01522
; LINE_WIDTH: 0.435645
G3 X153.141 Y108.731 I-.868 J1.214 E.00538
; LINE_WIDTH: 0.48002
G3 X153.43 Y109.087 I-.912 J1.038 E.01605
; LINE_WIDTH: 0.460975
G3 X153.536 Y109.319 I-1.9 J1.005 E.00852
; LINE_WIDTH: 0.420663
G1 X153.563 Y109.4 E.00257
; LINE_WIDTH: 0.383345
G3 X153.598 Y109.552 I-1.416 J.405 E.00422
; LINE_WIDTH: 0.344284
G1 X153.612 Y109.621 E.00169
; LINE_WIDTH: 0.3174
G1 X153.625 Y109.69 E.00154
; LINE_WIDTH: 0.281457
G1 X153.647 Y109.851 E.0031
; LINE_WIDTH: 0.24025
G1 X153.667 Y109.996 E.00232
; LINE_WIDTH: 0.197701
G1 X153.689 Y110.298 E.00375
; LINE_WIDTH: 0.174614
G1 X153.681 Y110.896 E.00631
; LINE_WIDTH: 0.207674
G1 X153.665 Y111.051 E.00205
; LINE_WIDTH: 0.238915
G1 X153.65 Y111.196 E.00229
; LINE_WIDTH: 0.260063
G1 X153.615 Y111.414 E.00383
G1 X153.557 Y111.37 F30000
; LINE_WIDTH: 0.20706
G1 F15000
G1 X153.611 Y111.272 E.00146
; LINE_WIDTH: 0.242258
G1 X153.645 Y111.226 E.00092
G1 X153.67 Y111.261 E.00068
; LINE_WIDTH: 0.189345
G1 X153.695 Y111.296 E.0005
; LINE_WIDTH: 0.140119
G1 X153.719 Y111.331 E.00033
; LINE_WIDTH: 0.110912
G3 X153.707 Y111.756 I-4.362 J.09 E.00233
G1 X153.436 Y111.574 F30000
; LINE_WIDTH: 0.108423
G1 F15000
G1 X153.372 Y111.675 E.00063
G1 X153.436 Y111.574 F30000
; LINE_WIDTH: 0.13353
G1 F15000
G1 X153.5 Y111.473 E.00087
; LINE_WIDTH: 0.166545
G1 X153.557 Y111.37 E.00117
; WIPE_START
G1 X153.5 Y111.473 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X151.755 Y113.063 Z1.966 F30000
G1 Z1.566
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G3 X150.16 Y112.919 I-.544 J-2.891 E.0526
G1 X153.538 Y116.297 E.15496
G1 X153.538 Y115.404 E.02897
G1 X130.367 Y138.575 E1.06301
G1 X129.76 Y138.575 E.0197
G1 X127.879 Y136.694 E.08628
G1 X128.162 Y136.54 E.01045
G2 X132.118 Y133.257 I-7.538 J-13.11 E.16758
G1 X137.436 Y138.575 E.24396
G1 X138.043 Y138.575 E.0197
G1 X153.538 Y123.08 E.71086
G1 X153.538 Y123.973 E.02897
G1 X138.047 Y108.482 E.71068
G1 X137.432 Y108.482 E.01996
G1 X132.111 Y113.802 E.24408
G2 X127.881 Y110.357 I-11.216 J9.449 E.17803
G1 X129.753 Y108.484 E.08589
G1 X130.373 Y108.484 E.02011
G1 X153.538 Y131.649 E1.06273
G1 X153.538 Y130.756 E.02897
G1 X150.16 Y134.133 E.15493
G3 X151.755 Y133.995 I1.04 J2.747 E.0526
; CHANGE_LAYER
; Z_HEIGHT: 1.78951
; LAYER_HEIGHT: 0.223738
; WIPE_START
G1 F16200
G1 X151.02 Y133.93 E-.28048
G1 X150.16 Y134.133 E-.33571
G1 X150.428 Y133.865 E-.14381
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 12/33
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
G17
G3 Z1.966 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.199 Y138.253
G1 Z1.79
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X154.197 Y138.253 E.00007
G3 X152.558 Y139.316 I-1.64 J-.734 E.07003
G1 X115.566 Y139.316 E1.25437
G3 X105.773 Y129.523 I.004 J-9.797 E.52158
G1 X105.773 Y117.529 E.40671
G3 X115.566 Y107.736 I9.817 J.024 E.52129
G1 X152.669 Y107.742 E1.25815
G3 X154.353 Y109.532 I-.108 J1.789 E.09182
G1 X154.353 Y111.521 E.06745
G2 X154.325 Y112.019 I6.763 J.635 E.01692
G1 X154.325 Y135.034 E.78041
G3 X154.353 Y137.521 I-35.653 J1.651 E.08436
G3 X154.313 Y137.898 I-1.797 J-.001 E.0129
G1 X154.217 Y138.196 E.01061
; WIPE_START
M204 S10000
G1 X154.197 Y138.253 E-.02314
G1 X154.011 Y138.578 E-.14217
G1 X153.761 Y138.856 E-.14219
G1 X153.458 Y139.076 E-.14217
G1 X153.116 Y139.228 E-.14217
G1 X152.75 Y139.306 E-.14217
G1 X152.682 Y139.31 E-.02599
; WIPE_END
G1 E-.04 F1800
G1 X152.092 Y131.7 Z2.19 F30000
G1 X150.288 Y108.462 Z2.19
G1 Z1.79
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F14676.533
G1 X150.27 Y108.473 E.00079
G2 X151.664 Y108.336 I.905 J2.05 E.46361
G1 X151.689 Y108.123 E.00785
G3 X152.71 Y108.132 I.424 J10.3 E.03742
G3 X153.966 Y109.542 I-.17 J1.416 E.07565
G1 X153.966 Y111.512 E.07217
G3 X153.938 Y111.805 I-1.5 J.003 E.0108
G1 X153.938 Y135.248 E.85908
G3 X153.966 Y135.541 I-1.471 J.29 E.0108
G1 X153.966 Y137.511 E.07217
G3 X152.548 Y138.929 I-1.41 J.009 E.08181
G1 X151.7 Y138.929 E.03105
G1 X151.67 Y138.724 E.00762
G2 X151.465 Y134.303 I-.499 J-2.192 E.22955
G2 X150.679 Y138.724 I-.289 J2.229 E.25101
G1 X150.649 Y138.929 E.00762
G1 X115.571 Y138.929 E1.28541
G3 X106.16 Y129.518 I-.001 J-9.41 E.54172
G1 X106.16 Y117.534 E.43916
G3 X115.571 Y108.123 I9.429 J.018 E.54141
G1 X150.66 Y108.123 E1.28581
G1 X150.685 Y108.336 E.00785
G2 X150.519 Y108.38 I.489 J2.186 E.0063
G1 X150.345 Y108.442 E.00677
; WIPE_START
G1 X150.27 Y108.473 E-.03084
G1 X150.031 Y108.591 E-.1011
G1 X149.81 Y108.739 E-.10124
G1 X149.609 Y108.913 E-.10124
G1 X149.429 Y109.11 E-.10116
G1 X149.274 Y109.326 E-.10124
G1 X149.104 Y109.66 E-.14215
G1 X149.039 Y109.863 E-.08103
; WIPE_END
G1 E-.04 F1800
G1 X143.784 Y115.398 Z2.19 F30000
G1 X125.317 Y134.847 Z2.19
G1 Z1.79
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G3 X125.076 Y135.082 I-.619 J-.391 E.01153
G3 X120.632 Y111.168 I-4.367 J-11.558 E1.46502
G3 X132.315 Y127.79 I.063 J12.372 E.80824
G3 X131.888 Y128.207 I-.732 J-.323 E.02075
G1 X131.819 Y128.229 E.00246
G3 X131.084 Y128.017 I-.143 J-.885 E.02681
G3 X130.807 Y127.196 I.439 J-.605 E.03135
G2 X113.677 Y115.416 I-10.1 J-3.658 E.9586
G1 X115.65 Y117.388 E.09458
G3 X119.651 Y115.634 I5.193 J6.407 E.14994
G2 X121.774 Y115.634 I1.061 J-.818 E.08309
G3 X128.606 Y122.464 I-1.082 J7.914 E.3518
G2 X128.606 Y124.587 I.818 J1.061 E.08309
G3 X121.775 Y131.419 I-7.944 J-1.112 E.35155
G2 X119.653 Y131.419 I-1.061 J.818 E.08309
G3 X112.821 Y124.587 I1.112 J-7.944 E.3516
G2 X113.113 Y124.275 I-1.214 J-1.43 E.01452
G2 X112.821 Y122.464 I-1.117 J-.749 E.06845
G3 X114.575 Y118.463 I7.955 J1.102 E.15004
G1 X112.603 Y116.49 E.09458
G2 X124.39 Y133.618 I8.113 J7.036 E.95935
G3 X124.739 Y133.588 I.24 J.748 E.01199
G3 X125.339 Y134.101 I-.218 J.861 E.02773
G3 X125.347 Y134.795 I-.64 J.354 E.02449
M204 S10000
G1 X125.662 Y135.038 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F14676.533
G1 X125.648 Y135.062 E.00103
G3 X125.266 Y135.421 I-.92 J-.598 E.01939
G3 X120.624 Y110.781 I-4.559 J-11.898 E1.63463
G3 X132.675 Y127.934 I.071 J12.76 E.90141
G3 X132.24 Y128.467 I-1.019 J-.388 E.02564
G3 X130.859 Y128.333 I-.597 J-1.029 E.05427
G3 X130.437 Y127.084 I.61 J-.902 E.0519
G2 X114.25 Y115.441 I-9.724 J-3.554 E.98462
G1 X115.68 Y116.871 E.07406
G3 X119.783 Y115.218 I5.146 J6.859 E.16394
G1 X120.12 Y115.555 E.01747
G2 X121.237 Y115.61 I.594 J-.687 E.04416
G2 X121.64 Y115.217 I-1.51 J-1.954 E.02067
G3 X124.062 Y115.88 I-1.198 J9.132 E.0923
G3 X129.021 Y122.595 I-3.45 J7.736 E.31987
G1 X128.685 Y122.933 E.01747
G2 X128.629 Y124.05 I.687 J.594 E.04417
G2 X129.022 Y124.453 I1.955 J-1.511 E.02067
G3 X128.359 Y126.875 I-9.131 J-1.198 E.09229
G3 X121.644 Y131.834 I-7.736 J-3.449 E.31987
G1 X121.307 Y131.498 E.01748
G2 X120.189 Y131.442 I-.594 J.687 E.04416
G2 X119.786 Y131.835 I1.51 J1.954 E.02067
G3 X116.962 Y130.983 I1.345 J-9.565 E.10851
G3 X112.404 Y124.453 I3.861 J-7.551 E.30376
G1 X112.726 Y124.137 E.01653
G2 X112.796 Y123 I-.672 J-.612 E.04511
G2 X112.405 Y122.596 I-1.999 J1.537 E.02066
G3 X114.058 Y118.493 I8.729 J1.131 E.16384
G1 X112.628 Y117.064 E.07406
G2 X124.278 Y133.247 I8.097 J6.456 E.9844
G3 X124.616 Y133.189 I.335 J.948 E.01263
G3 X125.677 Y133.913 I-.038 J1.195 E.0497
G3 X125.732 Y134.907 I-.949 J.551 E.03786
G1 X125.69 Y134.985 E.00322
; WIPE_START
G1 X125.648 Y135.062 E-.03352
G1 X125.541 Y135.202 E-.06697
G1 X125.412 Y135.322 E-.06696
G1 X125.266 Y135.421 E-.0669
G1 X125.122 Y135.487 E-.06032
G1 X124.579 Y135.673 E-.21822
G1 X124.045 Y135.83 E-.21148
G1 X123.954 Y135.853 E-.03563
; WIPE_END
G1 E-.04 F1800
G1 X129.294 Y130.4 Z2.19 F30000
G1 X150.422 Y108.825 Z2.19
G1 Z1.79
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.425 Y108.824 E.00008
G3 X151.064 Y108.669 I.75 J1.701 E.02244
G3 X151.419 Y108.685 I.11 J1.496 E.01206
G1 X151.504 Y108.695 E.00289
G3 X150.229 Y108.925 I-.329 J1.829 E.35115
G1 X150.369 Y108.852 E.00536
; WIPE_START
M204 S10000
G1 X150.425 Y108.824 E-.02371
G1 X150.762 Y108.715 E-.13485
G1 X151.064 Y108.669 E-.11604
G1 X151.419 Y108.685 E-.13485
G1 X151.504 Y108.695 E-.03244
G1 X151.718 Y108.747 E-.08377
G1 X151.924 Y108.824 E-.08373
G1 X152.121 Y108.924 E-.08377
G1 X152.266 Y109.023 E-.06684
; WIPE_END
G1 E-.04 F1800
G1 X152.411 Y116.654 Z2.19 F30000
G1 X152.805 Y137.424 Z2.19
G1 Z1.79
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.797 Y137.423 E.00025
G3 X151.064 Y134.672 I-1.623 J-.9 E.26088
G3 X151.419 Y134.688 I.11 J1.497 E.01206
G1 X151.504 Y134.698 E.00289
G3 X152.892 Y137.225 I-.329 J1.826 E.11202
G1 X152.829 Y137.37 E.00535
M204 S10000
G1 X153.596 Y137.521 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.40649
G1 F15000
G1 X153.568 Y137.632 E.00372
; LINE_WIDTH: 0.452907
G1 F14571.175
G3 X153.511 Y137.803 I-1.652 J-.457 E.00664
; LINE_WIDTH: 0.499159
G1 F13077.293
G1 X153.5 Y137.831 E.00125
G3 X153.13 Y138.335 I-1.36 J-.61 E.0259
; LINE_WIDTH: 0.443949
G1 F14900.82
G3 X152.591 Y138.726 I-4.012 J-4.961 E.02405
G1 X153.596 Y137.521 F30000
; LINE_WIDTH: 0.380966
G1 F15000
G1 X153.6 Y137.502 E.00061
; LINE_WIDTH: 0.353749
G1 X153.624 Y137.356 E.00411
; LINE_WIDTH: 0.306004
G1 X153.648 Y137.212 E.00345
; LINE_WIDTH: 0.264891
G1 X153.665 Y137.053 E.00316
; LINE_WIDTH: 0.233215
G1 X153.68 Y136.908 E.00246
; LINE_WIDTH: 0.199483
G1 X153.69 Y136.309 E.00827
; LINE_WIDTH: 0.22084
G1 X153.668 Y136.01 E.00472
; LINE_WIDTH: 0.263383
G1 X153.647 Y135.853 E.0031
; LINE_WIDTH: 0.30386
G1 X153.628 Y135.708 E.00342
; LINE_WIDTH: 0.339433
G1 X153.611 Y135.621 E.00235
; LINE_WIDTH: 0.370069
G1 X153.597 Y135.55 E.00211
; LINE_WIDTH: 0.414935
G2 X153.564 Y135.403 I-1.516 J.27 E.00505
G1 X153.292 Y135.284 E.00994
G1 X151.741 Y134 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F14676.533
G2 X150.146 Y134.147 I-.538 J2.89 E.05942
G1 X153.591 Y130.702 E.17853
G1 X153.591 Y131.703 E.03667
G1 X130.365 Y108.476 E1.20368
G1 X129.762 Y108.476 E.02211
G1 X127.889 Y110.362 E.09739
G3 X132.11 Y113.803 I-7.093 J13.011 E.20072
G1 X137.44 Y108.474 E.27619
G1 X138.038 Y108.474 E.02193
G1 X153.591 Y124.027 E.80601
G1 X153.591 Y123.026 E.03667
G1 X138.035 Y138.583 E.80621
G1 X137.444 Y138.583 E.02165
G1 X132.117 Y133.256 E.27606
M73 P62 R7
G1 X132.01 Y133.384 E.00613
G3 X127.878 Y136.693 I-11.353 J-9.943 E.19498
G1 X129.768 Y138.583 E.09794
G1 X130.359 Y138.583 E.02165
G1 X153.591 Y115.35 E1.204
G1 X153.591 Y116.351 E.03667
G1 X150.144 Y112.903 E.17867
G3 X149.274 Y112.279 I2.26 J-4.072 E.03933
; WIPE_START
G1 X149.718 Y112.675 E-.22612
G1 X150.144 Y112.903 E-.18358
G1 X150.796 Y113.555 E-.3503
; WIPE_END
G1 E-.04 F1800
G1 X149.72 Y108.529 Z2.19 F30000
G1 Z1.79
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.134306
G1 F15000
G1 X149.898 Y108.376 E.00185
G1 X150.024 Y108.341 E.00103
; WIPE_START
G1 X149.898 Y108.376 E-.27118
G1 X149.72 Y108.529 E-.48882
; WIPE_END
G1 E-.04 F1800
G1 X152.413 Y108.324 Z2.19 F30000
G1 Z1.79
G1 E.8 F1800
; LINE_WIDTH: 0.2674
G1 F15000
G1 X152.633 Y108.434 E.00491
G1 X153.435 Y108.702 E.01692
G1 X153.141 Y108.731 F30000
; LINE_WIDTH: 0.504628
G1 F12920.684
G3 X153.43 Y109.086 I-.911 J1.037 E.01916
; LINE_WIDTH: 0.485625
G1 F13481.733
G3 X153.536 Y109.319 I-1.873 J.993 E.01022
; LINE_WIDTH: 0.445191
G1 F14854.239
G1 X153.563 Y109.401 E.0031
; LINE_WIDTH: 0.407899
G1 F15000
G3 X153.598 Y109.552 I-1.427 J.407 E.00508
; LINE_WIDTH: 0.368966
G1 X153.612 Y109.62 E.00205
; LINE_WIDTH: 0.342149
G1 X153.625 Y109.689 E.00188
; LINE_WIDTH: 0.306121
G1 X153.647 Y109.851 E.00384
; LINE_WIDTH: 0.264917
G1 X153.667 Y109.996 E.0029
; LINE_WIDTH: 0.222375
G3 X153.689 Y110.298 I-5.053 J.533 E.00481
; LINE_WIDTH: 0.199481
G1 X153.68 Y110.905 E.0084
; LINE_WIDTH: 0.247784
G1 X153.643 Y111.194 E.0053
; LINE_WIDTH: 0.243014
G1 X153.589 Y111.292 E.00198
; LINE_WIDTH: 0.205905
G1 X153.542 Y111.378 E.00141
; LINE_WIDTH: 0.171118
G1 X153.494 Y111.464 E.0011
; LINE_WIDTH: 0.152797
G1 X153.491 Y111.469 E.00006
; LINE_WIDTH: 0.126948
G1 X153.364 Y111.67 E.00171
; WIPE_START
G1 X153.491 Y111.469 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X153.141 Y108.731 Z2.19 F30000
G1 Z1.79
G1 E.8 F1800
; LINE_WIDTH: 0.460173
G1 F14314.284
G2 X153.007 Y108.623 I-.999 J1.102 E.00649
; LINE_WIDTH: 0.407654
G1 F15000
G2 X152.511 Y108.324 I-3.091 J4.569 E.01897
; WIPE_START
G1 X153.007 Y108.623 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X146.065 Y111.796 Z2.19 F30000
G1 X134.293 Y117.178 Z2.19
G1 Z1.79
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F14676.533
G1 X134.488 Y117.606 E.0172
G3 X134.902 Y118.687 I-20.204 J8.363 E.04246
G1 X145.118 Y108.471 E.52943
G1 X145.712 Y108.471 E.02176
G1 X148.794 Y111.554 E.15974
G2 X149.14 Y112.126 I2.275 J-.984 E.02456
G1 X135.54 Y125.726 E.7048
G1 X135.474 Y126.157 E.01598
G3 X134.901 Y128.364 I-15.515 J-2.846 E.08365
G1 X145.12 Y138.583 E.52957
G1 X145.711 Y138.583 E.02165
G1 X148.798 Y135.495 E.16001
G3 X149.137 Y134.924 I2.557 J1.132 E.0244
G1 X135.542 Y121.329 E.70454
G3 X135.691 Y122.95 I-13.039 J2.018 E.05968
G1 X132.912 Y127.74 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.422395
G1 F15000
G1 X135.186 Y125.466 E.10976
G2 X135.254 Y124.868 I-48.252 J-5.842 E.02055
G1 X133.386 Y126.736 E.09015
G2 X133.54 Y126.053 I-7.751 J-2.101 E.0239
G1 X135.296 Y124.297 E.08475
G1 X135.313 Y123.75 E.01868
G1 X133.65 Y125.413 E.08028
G2 X133.724 Y124.81 I-6.875 J-1.151 E.02076
G1 X135.311 Y123.223 E.07658
G1 X135.284 Y122.721 E.01717
G1 X133.768 Y124.236 E.07316
G2 X133.786 Y123.689 I-6.261 J-.48 E.0187
G1 X135.248 Y122.227 E.07055
G1 X135.205 Y121.741 E.01667
G1 X133.782 Y123.164 E.06869
G2 X133.758 Y122.659 I-5.79 J.024 E.01727
G1 X135.142 Y121.275 E.0668
G2 X135.062 Y120.825 I-5.459 J.734 E.0156
G1 X133.716 Y122.171 E.06497
G2 X133.658 Y121.699 I-4.71 J.341 E.01622
G1 X134.972 Y120.386 E.06341
G1 X134.87 Y119.958 E.015
G1 X133.585 Y121.242 E.06199
G2 X133.492 Y120.806 I-3.616 J.541 E.01524
G1 X134.751 Y119.547 E.06075
G1 X134.633 Y119.136 E.01459
G1 X133.396 Y120.373 E.05966
G2 X133.288 Y119.951 I-3.372 J.642 E.01485
G1 X134.505 Y118.734 E.05874
G1 X134.366 Y118.344 E.01414
G1 X133.167 Y119.544 E.05788
G1 X133.033 Y119.148 E.01426
G1 X134.214 Y117.967 E.05699
G2 X134.055 Y117.596 I-4.524 J1.714 E.01377
G1 X132.888 Y118.763 E.05634
G2 X132.734 Y118.387 I-4.376 J1.567 E.01386
G1 X133.89 Y117.232 E.05577
G1 X133.713 Y116.879 E.01346
G1 X132.573 Y118.019 E.05501
G1 X132.399 Y117.664 E.0135
G1 X133.53 Y116.533 E.05461
G1 X133.34 Y116.193 E.01328
G1 X132.217 Y117.316 E.05421
G2 X132.029 Y116.975 I-3.478 J1.699 E.0133
G1 X133.141 Y115.863 E.05366
G2 X132.936 Y115.538 I-4.006 J2.296 E.01311
G1 X131.827 Y116.647 E.05351
G2 X131.62 Y116.325 I-2.737 J1.531 E.01308
G1 X132.723 Y115.222 E.05322
G1 X132.651 Y115.116 E.00438
G1 X132.502 Y114.913 E.00857
G1 X131.402 Y116.013 E.0531
G1 X131.184 Y115.702 E.01297
G1 X132.277 Y114.609 E.05275
G1 X132.036 Y114.321 E.01283
G1 X130.955 Y115.402 E.05215
G2 X130.719 Y115.109 I-3.484 J2.57 E.01285
G1 X131.794 Y114.033 E.05192
G1 X131.553 Y113.745 E.01283
G1 X130.472 Y114.826 E.05219
G2 X130.218 Y114.55 I-3.284 J2.766 E.01279
G1 X131.298 Y113.47 E.05213
G1 X131.038 Y113.201 E.01278
G1 X129.959 Y114.28 E.05208
G1 X129.689 Y114.021 E.01278
G1 X130.769 Y112.94 E.05215
G1 X130.657 Y112.831 E.00533
G1 X130.494 Y112.686 E.00746
G1 X129.412 Y113.767 E.05219
G1 X129.131 Y113.52 E.0128
G1 X130.214 Y112.436 E.05228
G1 X129.923 Y112.198 E.01284
G1 X128.837 Y113.284 E.05242
G2 X128.538 Y113.053 I-2.79 J3.314 E.01289
G1 X129.629 Y111.963 E.05262
G1 X129.326 Y111.736 E.0129
G1 X128.233 Y112.829 E.05277
G2 X127.916 Y112.616 I-2.589 J3.515 E.01303
G1 X129.015 Y111.517 E.05304
G1 X128.701 Y111.302 E.013
G1 X127.593 Y112.41 E.05345
G1 X127.264 Y112.21 E.01315
G1 X128.376 Y111.098 E.05365
G1 X128.044 Y110.9 E.01318
G1 X126.923 Y112.022 E.05414
G2 X126.574 Y111.841 I-2.249 J3.901 E.0134
G1 X127.708 Y110.707 E.0547
G1 X127.359 Y110.526 E.0134
G1 X126.219 Y111.667 E.05504
G1 X125.851 Y111.504 E.0137
G1 X127.005 Y110.351 E.05568
G1 X126.644 Y110.182 E.01359
G1 X125.475 Y111.351 E.05642
G2 X125.09 Y111.207 I-1.627 J3.761 E.01405
G1 X126.272 Y110.025 E.05704
G1 X125.892 Y109.875 E.01392
G1 X124.693 Y111.075 E.05791
G2 X124.282 Y110.956 I-1.175 J3.302 E.0146
G1 X125.506 Y109.732 E.05908
G1 X125.106 Y109.602 E.01434
G1 X123.864 Y110.845 E.05996
G2 X123.44 Y110.74 I-1.042 J3.292 E.01493
G1 X124.698 Y109.481 E.06075
G1 X124.282 Y109.367 E.01471
G1 X122.998 Y110.651 E.06198
G1 X122.54 Y110.58 E.01583
G1 X123.853 Y109.267 E.0634
G1 X123.407 Y109.183 E.01548
G1 X122.067 Y110.523 E.06468
G2 X121.579 Y110.482 I-.717 J5.567 E.01672
G1 X123.088 Y108.973 E.07281
G1 X123.061 Y108.938 E.00152
G1 X123.082 Y108.722 E.0074
G1 X122.959 Y108.573 E.00661
G1 X121.072 Y110.459 E.09107
G2 X120.547 Y110.455 I-.296 J4.293 E.01794
G1 X122.542 Y108.461 E.09627
G1 X122.012 Y108.461 E.01807
G1 X119.992 Y110.481 E.09747
G2 X119.428 Y110.516 I-.002 J4.474 E.01933
G1 X121.482 Y108.461 E.09918
G1 X120.953 Y108.461 E.01807
G1 X118.824 Y110.59 E.10275
G2 X118.184 Y110.7 I.94 J7.378 E.02215
G1 X120.423 Y108.461 E.10805
G1 X119.894 Y108.462 E.01807
G1 X117.502 Y110.853 E.11544
G2 X116.765 Y111.061 I4.928 J18.898 E.02614
G1 X119.364 Y108.462 E.12546
G1 X118.834 Y108.462 E.01807
G1 X115.635 Y111.661 E.1544
G1 X117.699 Y109.068 F30000
G1 F15000
G1 X114.998 Y111.768 E.13034
G2 X113.811 Y112.426 I5.448 J11.232 E.04635
G1 X116.768 Y109.469 E.14271
G1 X115.985 Y109.723 E.02809
G1 X106.491 Y119.217 E.45824
G1 X106.491 Y119.746 E.01805
G1 X109.605 Y116.633 E.15028
G2 X108.955 Y117.811 I11.402 J7.05 E.04596
G1 X106.492 Y120.275 E.11891
G1 X106.492 Y120.804 E.01805
G1 X108.542 Y118.754 E.09896
G2 X108.248 Y119.578 I9.283 J3.781 E.02986
G1 X106.492 Y121.333 E.08474
G1 X106.493 Y121.862 E.01805
G1 X108.04 Y120.315 E.07468
G2 X107.887 Y120.997 I7.723 J2.091 E.02388
G1 X106.493 Y122.391 E.06727
G1 X106.494 Y122.92 E.01805
G1 X107.777 Y121.637 E.06194
G2 X107.703 Y122.241 I6.867 J1.15 E.02076
G1 X106.494 Y123.449 E.05834
G1 X106.495 Y123.978 E.01805
G1 X107.659 Y122.814 E.05619
G2 X107.641 Y123.362 I6.256 J.482 E.01871
G1 X106.495 Y124.507 E.05529
G1 X106.496 Y125.036 E.01805
G1 X107.645 Y123.887 E.05547
G2 X107.669 Y124.392 I5.796 J-.021 E.01728
G1 X106.496 Y125.565 E.0566
G1 X106.497 Y126.094 E.01805
G1 X107.71 Y124.88 E.05858
G2 X107.767 Y125.353 I5.427 J-.415 E.01625
G1 X106.497 Y126.623 E.06131
G1 X106.498 Y127.152 E.01805
G1 X107.838 Y125.811 E.06471
G1 X107.927 Y126.253 E.01536
G1 X106.498 Y127.681 E.06895
G1 X106.498 Y128.21 E.01805
G1 X108.027 Y126.682 E.07376
G2 X108.138 Y127.1 I4.848 J-1.064 E.01478
G1 X106.499 Y128.739 E.0791
G1 X106.499 Y128.792 E.00181
G1 X106.906 Y128.726 E.01407
G1 X106.992 Y128.776 E.00339
G1 X108.259 Y127.508 E.06116
G1 X108.394 Y127.903 E.01424
G1 X107.211 Y129.086 E.05707
G1 X107.37 Y129.456 E.01376
G1 X108.538 Y128.288 E.05637
G2 X108.691 Y128.665 I4.382 J-1.562 E.01387
G1 X107.538 Y129.818 E.05566
G2 X107.712 Y130.173 I4.359 J-1.909 E.01351
G1 X108.854 Y129.032 E.0551
G2 X109.027 Y129.387 I4.154 J-1.813 E.01351
G1 X107.896 Y130.519 E.05462
G2 X108.087 Y130.857 I4.154 J-2.124 E.01326
G1 X109.209 Y129.736 E.05413
G1 X109.396 Y130.077 E.0133
G1 X108.283 Y131.19 E.05373
G1 X108.491 Y131.513 E.01307
G1 X109.597 Y130.406 E.05339
G2 X109.803 Y130.729 I3.8 J-2.203 E.01309
G1 X108.703 Y131.829 E.05309
G1 X108.922 Y132.14 E.01297
G1 X110.016 Y131.046 E.05279
G1 X110.24 Y131.351 E.01292
G1 X109.151 Y132.441 E.05259
G2 X109.384 Y132.737 I3.665 J-2.638 E.01287
G1 X110.471 Y131.65 E.05247
G1 X110.707 Y131.944 E.01285
G1 X109.625 Y133.026 E.05222
G1 X109.713 Y133.131 E.00468
G1 X109.873 Y133.307 E.00812
G1 X110.954 Y132.225 E.05219
G2 X111.208 Y132.502 I3.284 J-2.756 E.01279
G1 X110.126 Y133.584 E.05222
G1 X110.389 Y133.85 E.01278
G1 X111.467 Y132.772 E.05203
G2 X111.737 Y133.031 I3.102 J-2.964 E.01278
G1 X110.657 Y134.112 E.05216
G1 X110.931 Y134.367 E.01279
G1 X112.013 Y133.285 E.05223
G1 X112.296 Y133.532 E.01281
G1 X111.214 Y134.613 E.05221
G2 X111.501 Y134.856 I3.057 J-3.33 E.01283
G1 X112.588 Y133.768 E.05249
G2 X112.887 Y133.999 I2.793 J-3.306 E.01289
G1 X111.797 Y135.089 E.0526
G1 X112.1 Y135.316 E.01291
G1 X113.193 Y134.222 E.05276
G2 X113.509 Y134.436 I2.6 J-3.518 E.01302
G1 X112.408 Y135.537 E.05317
G2 X112.726 Y135.748 I2.679 J-3.698 E.01304
G1 X113.832 Y134.643 E.05336
G1 X114.162 Y134.842 E.01316
G1 X113.049 Y135.954 E.05369
G1 X113.38 Y136.153 E.01317
G1 X114.503 Y135.03 E.05419
G2 X114.851 Y135.212 I2.249 J-3.887 E.0134
G1 X113.72 Y136.343 E.05458
G1 X114.065 Y136.527 E.01335
G1 X115.206 Y135.386 E.05506
G1 X115.574 Y135.547 E.01372
G1 X114.42 Y136.702 E.05571
G1 X114.783 Y136.868 E.01363
G1 X115.951 Y135.7 E.05638
G1 X116.335 Y135.845 E.01401
G1 X115.152 Y137.028 E.05709
G1 X115.533 Y137.177 E.01394
G1 X116.738 Y135.972 E.05817
G1 X117.142 Y136.098 E.01444
G1 X115.922 Y137.318 E.05888
G1 X116.318 Y137.451 E.01427
G1 X117.556 Y136.213 E.05976
G2 X117.985 Y136.313 I1.368 J-4.868 E.01504
G1 X116.725 Y137.573 E.0608
G1 X117.145 Y137.683 E.0148
G1 X118.428 Y136.4 E.06189
G2 X118.886 Y136.472 I1.048 J-5.219 E.01583
G1 X117.572 Y137.785 E.06339
G1 X118.01 Y137.877 E.01526
G1 X119.358 Y136.529 E.06506
G2 X119.846 Y136.571 I.72 J-5.563 E.01671
G1 X118.441 Y137.975 E.0678
G1 X118.581 Y138.151 E.00767
G1 X118.566 Y138.379 E.0078
G1 X120.351 Y136.595 E.08613
G2 X120.876 Y136.599 I.314 J-5.994 E.01792
G1 X118.875 Y138.6 E.09659
G1 X119.404 Y138.6 E.01807
G1 X121.423 Y136.581 E.09745
G2 X121.997 Y136.537 I-.216 J-6.588 E.01963
G1 X119.934 Y138.6 E.09957
G1 X120.463 Y138.6 E.01807
G1 X122.6 Y136.463 E.10315
G2 X123.24 Y136.353 I-.939 J-7.365 E.02216
G1 X120.992 Y138.6 E.10847
G1 X121.522 Y138.6 E.01807
G1 X123.923 Y136.199 E.11588
G2 X124.659 Y135.992 I-2 J-8.527 E.02612
G1 X122.051 Y138.6 E.12588
G1 X122.581 Y138.6 E.01807
G1 X135.089 Y126.092 E.60372
G1 X134.953 Y126.757 E.02319
G1 X123.945 Y137.766 E.53132
G2 X124.653 Y137.587 I-6.186 J-26.007 E.02493
G1 X134.771 Y127.469 E.48837
G1 X134.533 Y128.237 E.02744
G1 X125.424 Y137.346 E.43965
G1 X126.269 Y137.03 E.03079
G1 X134.217 Y129.082 E.38359
G1 X133.775 Y130.053 E.0364
G1 X127.244 Y136.585 E.31524
G1 X127.971 Y136.199 E.02809
G1 X128.443 Y135.915 E.01882
G1 X133.1 Y131.258 E.22473
G1 X132.474 Y132.183 E.0381
G1 X132.103 Y132.665 E.02075
G1 X131.713 Y133.131 E.02073
G1 X131.304 Y133.58 E.02074
G3 X129.466 Y135.421 I-177.532 J-175.432 E.08878
G1 X125.964 Y134.688 F30000
G1 F15000
G1 X131.688 Y128.963 E.27627
G3 X131.224 Y128.899 I-.031 J-1.474 E.01607
G1 X126.086 Y134.036 E.24796
G2 X125.914 Y133.679 I-.921 J.225 E.01363
G1 X130.869 Y128.724 E.23917
G3 X130.552 Y128.511 I.764 J-1.48 E.01305
G1 X125.705 Y133.358 E.23394
G2 X125.423 Y133.111 I-1.368 J1.28 E.01283
G1 X130.303 Y128.231 E.23552
G3 X130.123 Y127.881 I.947 J-.706 E.01349
G1 X125.071 Y132.934 E.24386
G2 X124.616 Y132.859 I-.442 J1.278 E.01582
G1 X130.05 Y127.425 E.2623
G3 X130.202 Y126.743 I1.99 J.086 E.02395
G1 X123.93 Y133.015 E.30271
G1 X123.177 Y133.239 E.0268
G1 X130.429 Y125.988 E.34998
G2 X130.565 Y125.321 I-4.778 J-1.328 E.02323
G1 X128.44 Y127.447 E.10259
G2 X128.848 Y126.509 I-4.187 J-2.381 E.03498
G1 X130.669 Y124.688 E.08787
G2 X130.714 Y124.114 I-4.158 J-.615 E.01968
G1 X129.107 Y125.721 E.07758
G2 X129.252 Y125.046 I-11.204 J-2.769 E.02357
G1 X130.729 Y123.569 E.07127
G2 X130.717 Y123.052 I-2.825 J-.191 E.01768
G1 X129.365 Y124.404 E.06525
G1 X129.376 Y124.34 E.00224
G1 X129.136 Y124.104 E.01149
G1 X130.685 Y122.555 E.07476
G2 X130.63 Y122.08 I-3.476 J.157 E.01633
G1 X128.883 Y123.827 E.08434
G3 X128.824 Y123.357 I.434 J-.294 E.01678
G1 X130.547 Y121.634 E.08316
G1 X130.457 Y121.194 E.01531
G1 X129.311 Y122.34 E.05531
G1 X129.232 Y121.89 E.01561
G1 X130.349 Y120.773 E.05392
G2 X130.219 Y120.373 I-2.964 J.746 E.01434
G1 X129.137 Y121.456 E.05223
G2 X129.016 Y121.046 I-2.615 J.547 E.01457
G1 X130.081 Y119.982 E.05138
G2 X129.933 Y119.6 I-2.848 J.881 E.01398
G1 X128.889 Y120.644 E.0504
G2 X128.742 Y120.262 I-1.866 J.496 E.01401
G1 X129.767 Y119.237 E.04947
G1 X129.587 Y118.887 E.01341
G1 X128.581 Y119.893 E.04856
G2 X128.411 Y119.534 I-1.766 J.615 E.0136
G1 X129.407 Y118.538 E.04807
G2 X129.201 Y118.214 I-1.85 J.947 E.01311
G1 X128.218 Y119.197 E.04744
G1 X128.026 Y118.86 E.01324
G1 X128.995 Y117.891 E.04679
G2 X128.778 Y117.578 I-2.38 J1.422 E.01299
G1 X127.807 Y118.55 E.04689
G1 X127.585 Y118.242 E.01294
G1 X128.549 Y117.278 E.04653
G2 X128.308 Y116.989 I-2.222 J1.602 E.01284
G1 X127.349 Y117.948 E.04629
G1 X127.099 Y117.669 E.0128
G1 X128.053 Y116.715 E.04605
G1 X127.798 Y116.441 E.01278
G1 X126.848 Y117.391 E.04582
G1 X126.569 Y117.14 E.01279
G1 X127.529 Y116.18 E.04633
G2 X127.247 Y115.933 I-1.939 J1.937 E.01282
G1 X126.29 Y116.889 E.04615
G2 X125.996 Y116.654 I-1.248 J1.26 E.01288
G1 X126.955 Y115.696 E.04626
G2 X126.662 Y115.459 I-1.875 J2.019 E.01286
G1 X125.689 Y116.432 E.04697
G2 X125.379 Y116.213 I-1.525 J1.824 E.01298
G1 X126.352 Y115.24 E.04694
G2 X126.025 Y115.037 I-1.641 J2.278 E.01313
G1 X125.05 Y116.012 E.04707
G2 X124.7 Y115.833 I-1.299 J2.099 E.01344
G1 X125.696 Y114.837 E.04806
G2 X125.354 Y114.649 I-1.195 J1.769 E.01332
G1 X124.347 Y115.656 E.04857
G2 X123.977 Y115.497 I-.928 J1.654 E.01379
G1 X124.998 Y114.476 E.0493
G2 X124.64 Y114.305 I-1.423 J2.526 E.01357
G1 X123.592 Y115.352 E.05056
G2 X123.198 Y115.216 I-1.046 J2.39 E.01422
G1 X124.262 Y114.153 E.05134
G1 X123.864 Y114.022 E.01432
G1 X122.783 Y115.103 E.05218
G2 X122.348 Y115.008 I-1.109 J4.017 E.01518
G1 X123.465 Y113.891 E.0539
G2 X123.04 Y113.787 I-.78 J2.267 E.01497
G1 X121.898 Y114.929 E.05511
G1 X121.527 Y114.864 E.01286
G1 X121.11 Y115.289 E.02031
G3 X120.877 Y115.42 I-.38 J-.401 E.00923
G1 X122.609 Y113.688 E.08361
G2 X122.151 Y113.616 I-.618 J2.459 E.01584
G1 X120.411 Y115.356 E.08397
G1 X120.384 Y115.341 E.00107
G1 X120.136 Y115.102 E.01175
G1 X121.685 Y113.554 E.07475
G2 X121.184 Y113.524 I-.41 J2.712 E.01712
G1 X119.833 Y114.876 E.06523
G1 X119.192 Y114.987 E.02221
G1 X120.676 Y113.503 E.07164
G1 X120.119 Y113.53 E.01902
G1 X118.514 Y115.136 E.0775
G1 X117.745 Y115.375 E.02746
G1 X119.547 Y113.573 E.08696
G2 X118.915 Y113.676 I.431 J4.648 E.02187
G1 X116.793 Y115.798 E.10243
G2 X115.718 Y116.444 I2.851 J5.965 E.04285
G1 X115.668 Y116.394 E.00242
G1 X118.249 Y113.813 E.12456
G2 X117.484 Y114.048 I1.332 J5.687 E.02734
G1 X115.403 Y116.129 E.10042
G1 X115.138 Y115.864 E.01278
G1 X116.61 Y114.392 E.07104
G1 X116.258 Y114.548 E.01315
G1 X115.512 Y114.961 E.0291
G1 X114.755 Y115.718 E.03652
; WIPE_START
G1 X115.512 Y114.961 E-.40666
G1 X116.258 Y114.548 E-.32402
G1 X116.328 Y114.516 E-.02932
; WIPE_END
G1 E-.04 F1800
G1 X112.905 Y117.568 Z2.19 F30000
G1 Z1.79
G1 E.8 F1800
G1 F15000
G1 X112.171 Y118.302 E.0354
G1 X111.947 Y118.665 E.01456
G1 X111.563 Y119.439 E.02949
G1 X113.051 Y117.951 E.0718
G1 X113.316 Y118.216 E.01278
G1 X111.221 Y120.311 E.10111
G1 X111.006 Y121.056 E.02646
G1 X113.581 Y118.481 E.12428
G1 X113.631 Y118.531 E.00242
G2 X112.985 Y119.606 I5.32 J3.926 E.04285
G1 X110.863 Y121.728 E.10243
G2 X110.766 Y122.354 I3.359 J.838 E.02164
G1 X112.578 Y120.542 E.08746
G2 X112.321 Y121.328 I4.941 J2.05 E.02827
G1 X110.711 Y122.939 E.07772
G2 X110.69 Y123.489 I4 J.431 E.01883
G1 X112.174 Y122.005 E.07166
G1 X112.063 Y122.646 E.02221
G1 X110.711 Y123.997 E.06523
G2 X110.74 Y124.498 I2.74 J.091 E.01712
G1 X112.289 Y122.949 E.07475
G1 X112.528 Y123.197 E.01175
G1 X112.543 Y123.224 E.00107
G1 X110.803 Y124.964 E.08397
G2 X110.875 Y125.422 I2.53 J-.16 E.01584
G1 X112.607 Y123.69 E.08361
G3 X112.475 Y123.923 I-.532 J-.147 E.00923
G1 X112.051 Y124.34 E.02032
G1 X112.116 Y124.711 E.01286
G1 X110.974 Y125.853 E.05511
G2 X111.076 Y126.28 I3.161 J-.533 E.015
G1 X112.194 Y125.161 E.05397
G2 X112.29 Y125.596 I4.122 J-.676 E.01518
G1 X111.201 Y126.685 E.05256
G1 X111.339 Y127.076 E.01416
G1 X112.41 Y126.005 E.05168
G1 X112.537 Y126.407 E.0144
G1 X111.499 Y127.445 E.05011
G1 X111.659 Y127.815 E.01374
G1 X112.679 Y126.794 E.04925
G2 X112.843 Y127.161 I2.371 J-.838 E.0137
G1 X111.838 Y128.165 E.0485
G1 X112.025 Y128.508 E.01331
G1 X113.02 Y127.513 E.04802
G2 X113.2 Y127.862 I1.728 J-.669 E.01344
G1 X112.221 Y128.841 E.04725
G1 X112.434 Y129.158 E.01302
G1 X113.407 Y128.184 E.04699
G1 X113.615 Y128.506 E.01307
G1 X112.647 Y129.474 E.04673
G2 X112.883 Y129.768 I1.712 J-1.136 E.01287
G1 X113.842 Y128.808 E.04631
G1 X114.079 Y129.101 E.01285
G1 X113.12 Y130.06 E.04625
G2 X113.367 Y130.342 I2.177 J-1.649 E.01282
G1 X114.322 Y129.388 E.04607
G1 X114.586 Y129.653 E.01278
G1 X113.628 Y130.611 E.04625
G1 X113.902 Y130.866 E.01279
G1 X114.851 Y129.917 E.04579
G2 X115.137 Y130.16 I1.28 J-1.218 E.01284
G1 X114.176 Y131.121 E.04639
G2 X114.471 Y131.357 I1.428 J-1.485 E.01287
G1 X115.43 Y130.397 E.04632
G2 X115.732 Y130.624 I1.215 J-1.3 E.01293
G1 X114.769 Y131.587 E.0465
G2 X115.078 Y131.808 I1.358 J-1.57 E.01297
G1 X116.054 Y130.832 E.04715
G1 X116.376 Y131.039 E.01307
G1 X115.401 Y132.014 E.04707
G1 X115.725 Y132.22 E.01309
G1 X116.726 Y131.219 E.04832
G1 X117.078 Y131.396 E.01346
G1 X116.067 Y132.407 E.04878
M73 P63 R7
G2 X116.421 Y132.583 I2.082 J-3.755 E.01349
G1 X117.449 Y131.555 E.04958
G1 X117.833 Y131.7 E.01403
G1 X116.792 Y132.741 E.05027
G1 X117.169 Y132.894 E.01388
G1 X118.229 Y131.833 E.05118
G1 X118.65 Y131.942 E.01483
G1 X117.559 Y133.034 E.05268
G1 X117.966 Y133.156 E.0145
G1 X119.077 Y132.045 E.05363
G1 X119.527 Y132.124 E.01561
G1 X118.381 Y133.27 E.05532
G1 X118.821 Y133.36 E.01532
G1 X120.547 Y131.633 E.08331
G3 X121.014 Y131.696 I.163 J.561 E.01655
G1 X119.269 Y133.441 E.08423
G1 X119.746 Y133.493 E.01638
G1 X121.29 Y131.95 E.07451
G1 X121.536 Y132.187 E.01168
G1 X121.591 Y132.178 E.00191
G1 X120.236 Y133.533 E.06539
G1 X120.757 Y133.542 E.01776
G1 X122.233 Y132.065 E.07126
G2 X122.924 Y131.904 I-.663 J-4.4 E.02424
G1 X121.297 Y133.531 E.07852
G2 X121.887 Y133.47 I-.143 J-4.314 E.02025
G1 X123.696 Y131.661 E.08731
G2 X124.607 Y131.28 I-1.931 J-5.886 E.03376
G1 X122.297 Y133.59 E.1115
; WIPE_START
G1 X123.711 Y132.176 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X118.188 Y137.444 Z2.19 F30000
G1 X117.442 Y138.156 Z2.19
G1 Z1.79
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F14676.533
G1 X117.368 Y138.14 E.00278
G3 X115.876 Y137.714 I3.596 J-15.418 E.05689
G1 X115.033 Y138.557 E.04368
G3 X114.319 Y138.486 I.013 J-3.762 E.02631
G1 X106.594 Y130.761 E.40034
G2 X106.732 Y131.505 I3.965 J-.351 E.02777
G1 X107.546 Y130.691 E.04217
G1 X107.335 Y130.295 E.01646
G3 X106.846 Y129.222 I19.682 J-9.627 E.0432
G1 X110.984 Y134.93 F30000
G1 F14676.533
G1 X109.587 Y136.327 E.0724
G3 X108.469 Y135.146 I6.589 J-7.358 E.05965
G1 X106.323 Y118.856 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.422395
G1 F15000
G1 X115.152 Y110.027 E.42611
G2 X114.183 Y110.466 I6.349 J15.283 E.03632
G1 X107.657 Y116.992 E.31496
G1 X108.116 Y116.14 E.03305
G1 X108.333 Y115.786 E.01414
G1 X112.972 Y111.147 E.22391
G1 X112.178 Y111.677 E.03259
G1 X111.652 Y112.075 E.0225
G2 X110.411 Y113.179 I9.838 J12.314 E.0567
G1 X108.827 Y114.763 E.07648
G1 X108.466 Y111.904 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F14676.533
G3 X109.592 Y110.731 I6.265 J4.89 E.05967
G1 X110.982 Y112.121 E.07203
G1 X106.847 Y117.831 F30000
G1 F14676.533
G1 X106.936 Y117.613 E.00862
G3 X107.547 Y116.362 I14.528 J6.324 E.05104
G1 X106.732 Y115.547 E.04222
G2 X106.594 Y116.291 I3.831 J1.096 E.02777
G1 X114.319 Y108.566 E.40034
G3 X115.025 Y108.488 I.901 J4.894 E.02604
G1 X115.883 Y109.346 E.04446
G3 X117.446 Y108.896 I4.28 J11.938 E.05966
; WIPE_START
G1 X115.883 Y109.346 E-.61824
G1 X115.619 Y109.082 E-.14176
; WIPE_END
G1 E-.04 F1800
G1 X121.398 Y114.068 Z2.19 F30000
G1 X149.84 Y138.608 Z2.19
G1 Z1.79
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.114649
G1 F15000
G2 X150.018 Y138.708 I.213 J-.169 E.00128
; CHANGE_LAYER
; Z_HEIGHT: 2.02683
; LAYER_HEIGHT: 0.237315
; WIPE_START
G1 F15000
G1 X149.946 Y138.689 E-.27307
G1 X149.84 Y138.608 E-.48693
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 13/33
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
G17
G3 Z2.19 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.196 Y138.258
G1 Z2.027
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X154.007 Y138.575 E.01317
G3 X152.558 Y139.316 I-1.458 J-1.063 E.06026
G1 X115.566 Y139.316 E1.32007
G3 X105.773 Y129.523 I.004 J-9.797 E.54889
G1 X105.773 Y117.529 E.42801
G3 X115.566 Y107.736 I9.797 J.004 E.54889
G1 X152.685 Y107.743 E1.32462
G3 X154.353 Y109.532 I-.125 J1.788 E.09606
G1 X154.353 Y137.521 E.99881
G3 X154.216 Y138.203 I-1.804 J-.009 E.025
; WIPE_START
M204 S10000
G1 X154.007 Y138.575 E-.16218
G1 X153.807 Y138.81 E-.11724
G1 X153.615 Y138.974 E-.09587
G1 X153.291 Y139.161 E-.14217
G1 X152.935 Y139.277 E-.14215
G1 X152.673 Y139.304 E-.10041
; WIPE_END
G1 E-.04 F1800
G1 X152.806 Y137.423 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.802 Y137.426 E.00017
G3 X151.064 Y134.672 I-1.627 J-.899 E.27516
G3 X151.409 Y134.686 I.11 J1.455 E.01234
G1 X151.504 Y134.698 E.0034
G3 X152.896 Y137.227 I-.329 J1.829 E.118
G1 X152.831 Y137.368 E.00557
; WIPE_START
M204 S10000
G1 X152.802 Y137.426 E-.02443
G1 X152.686 Y137.613 E-.08369
G1 X152.547 Y137.784 E-.08375
G1 X152.389 Y137.938 E-.08377
G1 X152.214 Y138.072 E-.08376
G1 X152.024 Y138.184 E-.08377
G1 X151.822 Y138.273 E-.08375
G1 X151.612 Y138.337 E-.08374
G1 X151.394 Y138.376 E-.08379
G1 X151.222 Y138.386 E-.06555
; WIPE_END
G1 E-.04 F1800
G1 X151.016 Y130.756 Z2.427 F30000
G1 X150.423 Y108.825 Z2.427
G1 Z2.027
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X150.425 Y108.824 E.00008
G3 X151.064 Y108.669 I.75 J1.701 E.02361
G3 X151.409 Y108.684 I.11 J1.453 E.01234
G1 X151.504 Y108.695 E.0034
G3 X150.229 Y108.925 I-.329 J1.829 E.36954
G1 X150.369 Y108.852 E.00565
M204 S10000
G1 X150.251 Y108.481 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13937.913
G1 X150.035 Y108.596 E.00945
G2 X151.633 Y108.331 I1.14 J1.926 E.47861
G1 X151.658 Y108.12 E.0082
G3 X152.71 Y108.129 I.439 J10.717 E.0406
G3 X153.969 Y109.542 I-.17 J1.419 E.07981
G1 X153.969 Y137.511 E1.07922
G3 X152.548 Y138.932 I-1.41 J.011 E.08635
G1 X151.676 Y138.932 E.03364
G1 X151.645 Y138.728 E.00796
G2 X150.149 Y138.526 I-.465 J-2.196 E.48484
G1 X150.257 Y138.574 E.00456
G2 X150.704 Y138.728 I.872 J-1.796 E.01827
G1 X150.673 Y138.932 E.00796
G1 X115.571 Y138.932 E1.35448
G3 X106.157 Y129.519 I-.001 J-9.413 E.57059
G1 X106.157 Y126.12 E.13114
G1 X106.373 Y126.099 E.00837
G2 X106.376 Y120.957 I14.339 J-2.564 E3.33224
G1 X106.157 Y120.938 E.00846
G1 X106.157 Y117.534 E.13133
G3 X115.571 Y108.12 I9.413 J-.001 E.57059
G1 X150.691 Y108.12 E1.35515
G1 X150.716 Y108.331 E.0082
G2 X150.307 Y108.459 I.459 J2.19 E.01657
; WIPE_START
G1 X150.035 Y108.596 E-.11571
G1 X149.812 Y108.742 E-.10102
G1 X149.611 Y108.915 E-.10112
G1 X149.431 Y109.112 E-.10104
G1 X149.276 Y109.328 E-.10109
G1 X149.148 Y109.561 E-.1011
G1 X149.048 Y109.807 E-.10105
G1 X149.021 Y109.903 E-.03788
; WIPE_END
G1 E-.04 F1800
G1 X143.766 Y115.439 Z2.427 F30000
G1 X125.261 Y134.93 Z2.427
G1 Z2.027
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.249 Y134.937 E.00049
G3 X125.076 Y135.082 I-.551 J-.482 E.00811
G3 X120.182 Y111.178 I-4.366 J-11.559 E1.52571
G3 X132.315 Y127.79 I.526 J12.353 E.86699
G3 X131.819 Y128.229 I-.724 J-.317 E.02441
G3 X131.084 Y128.017 I-.143 J-.885 E.02821
G3 X130.807 Y127.196 I.439 J-.605 E.033
G2 X113.677 Y115.416 I-10.1 J-3.658 E1.00881
G1 X115.65 Y117.388 E.09953
G3 X119.653 Y115.634 I5.104 J6.202 E.15795
G2 X121.774 Y115.634 I1.06 J-.815 E.0874
G3 X128.606 Y122.466 I-1.112 J7.944 E.37002
G2 X128.606 Y124.587 I.815 J1.061 E.0874
G3 X121.774 Y131.419 I-7.944 J-1.112 E.37002
G2 X119.653 Y131.419 I-1.061 J.815 E.0874
G3 X112.821 Y124.587 I1.112 J-7.944 E.37004
G2 X112.821 Y122.466 I-.815 J-1.061 E.0874
G3 X114.575 Y118.463 I7.957 J1.101 E.15795
G1 X112.603 Y116.49 E.09953
G2 X124.39 Y133.618 I8.123 J7.03 E1.00909
G3 X124.739 Y133.588 I.24 J.748 E.01261
G3 X125.338 Y134.101 I-.218 J.861 E.02918
G3 X125.317 Y134.847 I-.64 J.355 E.02793
G1 X125.295 Y134.88 E.00145
; WIPE_START
M204 S10000
G1 X125.249 Y134.937 E-.02756
G1 X125.076 Y135.082 E-.08597
M73 P63 R6
G1 X124.462 Y135.304 E-.24819
G1 X123.944 Y135.457 E-.20516
G1 X123.448 Y135.568 E-.19313
; WIPE_END
G1 E-.04 F1800
G1 X122.83 Y138.439 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.58721
G1 F10371.844
G1 X122.268 Y138.474 E.02917
; LINE_WIDTH: 0.556503
G1 F11001.8
G1 X121.961 Y138.486 E.01503
; LINE_WIDTH: 0.53053
G1 F11597.601
G1 X121.644 Y138.499 E.01471
; LINE_WIDTH: 0.500417
G1 F12374.572
G1 X120.406 Y138.512 E.05381
G1 X119.773 Y138.499 E.02755
; LINE_WIDTH: 0.530922
G1 F11588.136
G1 X119.465 Y138.486 E.01427
; LINE_WIDTH: 0.556961
G1 F10991.822
G1 X119.147 Y138.473 E.01557
; LINE_WIDTH: 0.587557
G1 F10365.129
G1 X118.597 Y138.439 E.02862
G1 X108.463 Y135.151 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F13937.913
G2 X109.583 Y136.331 I7.328 J-5.837 E.06283
G1 X111.04 Y134.874 E.07949
; WIPE_START
G1 X109.625 Y136.288 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.906 Y129.164 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
G1 F13937.913
G2 X107.604 Y130.634 I14.682 J-6.073 E.06283
G1 X106.729 Y131.509 E.04774
G3 X106.59 Y130.757 I3.868 J-1.105 E.02954
G1 X114.324 Y138.491 E.42204
G2 X115.029 Y138.561 I.717 J-3.648 E.02738
G1 X115.937 Y137.653 E.04956
G2 X117.505 Y138.089 I9.326 J-30.457 E.0628
; WIPE_START
G1 X115.937 Y137.653 E-.61839
G1 X115.673 Y137.916 E-.14161
; WIPE_END
G1 E-.04 F1800
G1 X110.312 Y132.484 Z2.427 F30000
G1 X106.615 Y128.739 Z2.427
G1 Z2.027
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.472687
G1 F13188.166
G1 X106.583 Y128.543 E.00809
; LINE_WIDTH: 0.426845
G1 F14796.428
G1 X106.551 Y128.347 E.00721
; LINE_WIDTH: 0.381003
G1 F15000
G1 X106.519 Y128.152 E.00633
; LINE_WIDTH: 0.334521
G1 X106.487 Y127.95 E.00559
; LINE_WIDTH: 0.288869
G1 X106.465 Y127.797 E.00357
; LINE_WIDTH: 0.245431
G1 X106.443 Y127.643 E.00292
; LINE_WIDTH: 0.201993
G1 X106.422 Y127.489 E.00227
; LINE_WIDTH: 0.158304
G1 X106.4 Y127.334 E.00163
; LINE_WIDTH: 0.120642
G1 X106.381 Y127.176 E.00107
; WIPE_START
G1 X106.4 Y127.334 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.25 Y125.918 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.567876
G1 F10759.747
G1 X106.218 Y125.504 E.02073
; LINE_WIDTH: 0.538205
G1 F11414.921
G1 X106.2 Y125.195 E.01462
; LINE_WIDTH: 0.503305
G1 F12295.558
G1 X106.183 Y124.895 E.01311
; LINE_WIDTH: 0.463867
G1 F13469.859
G1 X106.161 Y124.288 E.02426
; LINE_WIDTH: 0.434058
G1 F14517.865
G1 X106.151 Y123.674 E.02275
G1 X106.17 Y122.47 E.04461
; LINE_WIDTH: 0.474392
G1 F13135.075
G1 X106.184 Y122.162 E.01262
; LINE_WIDTH: 0.502829
G1 F12308.521
G1 X106.198 Y121.863 E.01309
; LINE_WIDTH: 0.532818
G1 F11542.529
G1 X106.223 Y121.496 E.01714
; LINE_WIDTH: 0.563771
G1 F10845.869
G1 X106.247 Y121.139 E.01775
; WIPE_START
G1 X106.223 Y121.496 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.38 Y119.884 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.123997
G1 F15000
G1 X106.401 Y119.727 E.00112
; LINE_WIDTH: 0.162135
G1 X106.421 Y119.57 E.0017
; LINE_WIDTH: 0.200273
G1 X106.441 Y119.413 E.00228
; LINE_WIDTH: 0.243271
G1 X106.465 Y119.255 E.00297
; LINE_WIDTH: 0.29073
G1 X106.488 Y119.101 E.00362
; LINE_WIDTH: 0.337611
G1 X106.512 Y118.947 E.00432
; LINE_WIDTH: 0.384492
G1 X106.535 Y118.793 E.00503
; LINE_WIDTH: 0.431368
G1 F14620.517
G1 X106.577 Y118.55 E.00906
; LINE_WIDTH: 0.475515
G1 F13100.324
G1 X106.618 Y118.315 E.0098
; WIPE_START
G1 X106.577 Y118.55 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X110.953 Y112.297 Z2.427 F30000
G1 X111.038 Y112.177 Z2.427
G1 Z2.027
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F13937.913
G1 X109.584 Y110.723 E.07931
G2 X108.47 Y111.907 I5.149 J5.965 E.06283
G1 X117.509 Y108.962 F30000
G1 F13937.913
G2 X115.944 Y109.407 I2.684 J12.398 E.06282
G1 X115.024 Y108.487 E.05023
G1 X114.333 Y108.553 E.02679
G1 X106.599 Y116.287 E.42204
G3 X106.726 Y115.541 I5.279 J.514 E.02924
G1 X107.605 Y116.42 E.04796
G2 X106.908 Y117.89 I22.231 J11.433 E.0628
; WIPE_START
G1 X107.605 Y116.42 E-.61836
G1 X107.341 Y116.156 E-.14164
; WIPE_END
G1 E-.04 F1800
G1 X113.759 Y112.025 Z2.427 F30000
G1 X118.605 Y108.906 Z2.427
G1 Z2.027
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.576423
G1 F10584.752
G1 X118.859 Y108.596 E.02038
G1 X119.16 Y108.581 E.01529
; LINE_WIDTH: 0.556611
G1 F10999.435
G1 X119.46 Y108.565 E.01471
; LINE_WIDTH: 0.521267
G1 F11826.006
G1 X120.085 Y108.545 E.02843
; LINE_WIDTH: 0.495507
G1 F12511.227
G1 X121.329 Y108.545 E.05349
; LINE_WIDTH: 0.52057
G1 F11843.563
G1 X121.956 Y108.565 E.02847
; LINE_WIDTH: 0.556086
G1 F11010.877
G1 X122.267 Y108.581 E.01519
; LINE_WIDTH: 0.587904
G1 F10358.434
G1 X122.567 Y108.596 E.01562
; LINE_WIDTH: 0.567751
G1 F10762.349
G1 X122.822 Y108.906 E.02004
; WIPE_START
G1 X122.567 Y108.596 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.141 Y114.706 Z2.427 F30000
G1 X129.942 Y118.446 Z2.427
G1 Z2.027
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F12000
M204 S2000
G1 X125.788 Y114.293 E.20964
G1 X124.783 Y113.809
G1 X130.43 Y119.457 E.28502
G1 X130.736 Y120.285
G1 X123.952 Y113.501 E.34239
G1 X123.225 Y113.296
G1 X130.945 Y121.016 E.38961
G1 X131.084 Y121.676
G1 X122.561 Y113.154 E.43011
G1 X121.95 Y113.065
G1 X131.176 Y122.29 E.46558
G1 X131.229 Y122.865
G1 X127.74 Y119.377 E.17606
G1 X128.257 Y120.416
G1 X131.248 Y123.406 E.15093
G1 X131.241 Y123.921
G1 X128.541 Y121.221 E.13627
G1 X128.716 Y121.918
G1 X131.211 Y124.413 E.1259
G1 X131.16 Y124.884
G1 X128.818 Y122.542 E.11823
G1 X128.555 Y122.801
G1 X131.092 Y125.338 E.12802
G1 X131.007 Y125.775
G1 X128.355 Y123.123 E.1338
G1 X128.28 Y123.57
G1 X130.906 Y126.196 E.13256
G1 X130.79 Y126.602
G1 X128.806 Y124.618 E.10011
G1 X128.729 Y125.062
G1 X130.661 Y126.995 E.09751
G1 X130.564 Y127.42
G1 X128.635 Y125.49 E.09738
; WIPE_START
M204 S10000
G1 X130.049 Y126.905 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X132.163 Y119.571 Z2.427 F30000
G1 X133.085 Y116.371 Z2.427
G1 Z2.027
G1 E.8 F1800
G1 F12000
M204 S2000
G1 X127.88 Y111.165 E.26272
G1 X126.78 Y110.587
G1 X133.655 Y117.462 E.34696
G1 X134.045 Y118.374
G1 X125.866 Y110.195 E.4128
G1 X125.062 Y109.913
G1 X134.323 Y119.174 E.46739
G1 X134.535 Y119.908
G1 X131.119 Y116.492 E.17239
; WIPE_START
M204 S10000
G1 X132.534 Y117.907 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.883 Y117.778 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
G1 F12000
M204 S2000
G1 X134.702 Y120.597 E.14223
G1 X134.822 Y121.239
G1 X132.333 Y118.749 E.12563
G1 X132.636 Y119.574
G1 X134.907 Y121.846 E.11464
G1 X134.964 Y122.424
G1 X132.86 Y120.321 E.10616
G1 X133.017 Y121
G1 X134.995 Y122.978 E.09982
G1 X135.005 Y123.509
G1 X133.129 Y121.634 E.09464
G1 X133.207 Y122.233
G1 X134.996 Y124.022 E.09028
G1 X134.97 Y124.518
G1 X133.253 Y122.801 E.08666
G1 X133.272 Y123.343
G1 X134.929 Y124.999 E.08361
G1 X134.875 Y125.467
G1 X133.269 Y123.861 E.08104
G1 X133.246 Y124.36
G1 X134.804 Y125.918 E.07863
G1 X134.721 Y126.357
G1 X133.205 Y124.841 E.07653
G1 X133.148 Y125.306
M73 P64 R6
G1 X134.628 Y126.786 E.07471
G1 X134.526 Y127.206
G1 X133.076 Y125.757 E.07313
G1 X132.989 Y126.191
G1 X134.409 Y127.611 E.07165
G1 X134.283 Y128.008
G1 X132.888 Y126.613 E.0704
G1 X132.777 Y127.023
G1 X134.151 Y128.397 E.06933
G1 X134.007 Y128.775
G1 X132.655 Y127.423 E.06822
G1 X132.522 Y127.812
G1 X133.854 Y129.144 E.06722
G1 X133.695 Y129.507
G1 X132.332 Y128.144 E.06875
G1 X132.033 Y128.367
G1 X133.525 Y129.859 E.0753
G1 X133.348 Y130.204
G1 X131.594 Y128.45 E.08851
; WIPE_START
M204 S10000
G1 X133.008 Y129.864 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.165 Y130.543 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
G1 F12000
M204 S2000
G1 X128.522 Y125.9 E.23435
G1 X128.392 Y126.291
G1 X132.972 Y130.872 E.23119
G1 X132.773 Y131.195
G1 X128.245 Y126.667 E.2285
G1 X128.084 Y127.028
G1 X132.568 Y131.512 E.22631
G1 X132.353 Y131.818
G1 X127.909 Y127.375 E.22426
G1 X127.721 Y127.708
G1 X132.133 Y132.12 E.22265
G1 X131.906 Y132.415
G1 X127.52 Y128.029 E.22135
G1 X127.307 Y128.338
G1 X131.67 Y132.701 E.22021
G1 X131.43 Y132.983
G1 X127.08 Y128.634 E.21951
G1 X126.841 Y128.916
G1 X131.181 Y133.256 E.21902
G1 X130.926 Y133.523
G1 X126.591 Y129.188 E.2188
G1 X126.328 Y129.447
G1 X130.666 Y133.785 E.21893
G1 X130.396 Y134.037
G1 X126.055 Y129.696 E.2191
G1 X125.77 Y129.933
G1 X130.122 Y134.285 E.21963
G1 X129.84 Y134.525
G1 X125.473 Y130.158 E.22042
G1 X125.162 Y130.368
G1 X129.55 Y134.757 E.2215
G1 X129.256 Y134.985
G1 X124.839 Y130.568 E.22292
G1 X124.503 Y130.754
G1 X128.953 Y135.204 E.22458
G1 X128.643 Y135.416
G1 X124.153 Y130.926 E.22658
G1 X123.789 Y131.084
G1 X128.328 Y135.623 E.22908
G1 X128.002 Y135.819
G1 X123.411 Y131.228 E.2317
G1 X123.016 Y131.355
G1 X127.671 Y136.01 E.23491
G1 X127.333 Y136.194
G1 X125.638 Y134.499 E.08554
G1 X125.524 Y134.906
G1 X126.985 Y136.368 E.07375
G1 X126.631 Y136.535
G1 X125.283 Y135.187 E.06802
G1 X124.932 Y135.358
G1 X126.269 Y136.695 E.0675
G1 X125.896 Y136.844
G1 X124.543 Y135.491 E.0683
G1 X124.14 Y135.61
G1 X125.516 Y136.987 E.06945
G1 X125.129 Y137.121
G1 X123.727 Y135.719 E.07072
G1 X123.303 Y135.817
G1 X124.728 Y137.242 E.07192
G1 X124.319 Y137.355
G1 X122.866 Y135.902 E.07332
G1 X122.415 Y135.973
G1 X123.901 Y137.459 E.07501
G1 X123.47 Y137.55
G1 X121.947 Y136.027 E.07688
G1 X121.463 Y136.064
G1 X123.027 Y137.629 E.07895
G1 X122.572 Y137.696
G1 X120.96 Y136.084 E.08135
G1 X120.438 Y136.083
G1 X122.105 Y137.751 E.08415
G1 X121.623 Y137.791
G1 X119.892 Y136.06 E.08738
G1 X119.319 Y136.009
G1 X121.123 Y137.813 E.09102
G1 X120.606 Y137.817
G1 X118.715 Y135.927 E.09539
G1 X118.075 Y135.808
G1 X120.069 Y137.803 E.10067
G1 X119.511 Y137.767
G1 X117.382 Y135.638 E.10743
G1 X116.625 Y135.403
G1 X118.928 Y137.705 E.1162
G1 X118.315 Y137.615
G1 X115.777 Y135.076 E.12811
G1 X114.771 Y134.592
G1 X117.668 Y137.489 E.14622
G1 X116.979 Y137.322
G1 X113.382 Y133.725 E.18154
; WIPE_START
M204 S10000
G1 X114.796 Y135.139 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.307 Y133.783 Z2.427 F30000
G1 X124.522 Y133.383 Z2.427
G1 Z2.027
G1 E.8 F1800
G1 F12000
M204 S2000
G1 X122.604 Y131.465 E.0968
G1 X122.173 Y131.555
G1 X124.114 Y133.496 E.09797
G1 X123.719 Y133.623
G1 X121.729 Y131.633 E.10044
G1 X120.667 Y131.093
G1 X123.31 Y133.737 E.13341
G1 X122.887 Y133.836
G1 X120.249 Y131.197 E.13318
G1 X119.943 Y131.413
G1 X122.449 Y133.919 E.12647
G1 X121.993 Y133.985
G1 X119.629 Y131.621 E.1193
G1 X118.989 Y131.503
G1 X121.518 Y134.032 E.12762
G1 X121.022 Y134.058
G1 X118.282 Y131.318 E.13827
G1 X117.451 Y131.009
G1 X120.503 Y134.061 E.15402
G1 X119.954 Y134.034
G1 X116.334 Y130.414 E.1827
; WIPE_START
M204 S10000
G1 X117.748 Y131.828 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X115.686 Y124.48 Z2.427 F30000
G1 X114.083 Y118.768 Z2.427
G1 Z2.027
G1 E.8 F1800
G1 F12000
M204 S2000
G1 X112.387 Y117.072 E.08556
G1 X112.164 Y117.371
G1 X113.871 Y119.078 E.08615
G1 X113.672 Y119.401
G1 X111.95 Y117.679 E.08692
G1 X111.745 Y117.996
G1 X113.486 Y119.737 E.08788
G1 X113.313 Y120.086
G1 X111.552 Y118.325 E.08889
G1 X111.369 Y118.663
G1 X113.155 Y120.45 E.09014
G1 X113.011 Y120.828
G1 X111.195 Y119.012 E.09166
G1 X111.032 Y119.371
G1 X112.884 Y121.223 E.09346
G1 X112.775 Y121.635
G1 X110.88 Y119.741 E.0956
G1 X110.742 Y120.124
G1 X112.684 Y122.067 E.09802
G1 X112.607 Y122.511
G1 X110.616 Y120.521 E.10045
G1 X110.504 Y120.93
G1 X113.147 Y123.573 E.13337
G1 X113.043 Y123.991
G1 X110.406 Y121.354 E.13309
G1 X110.323 Y121.793
G1 X112.826 Y124.297 E.12636
G1 X112.619 Y124.611
G1 X110.257 Y122.249 E.11921
G1 X110.21 Y122.724
G1 X112.736 Y125.251 E.12752
G1 X112.921 Y125.957
G1 X110.184 Y123.22 E.13817
G1 X110.181 Y123.739
G1 X113.231 Y126.789 E.1539
; WIPE_START
M204 S10000
G1 X111.817 Y125.375 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.826 Y127.905 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
G1 F12000
M204 S2000
G1 X110.207 Y124.287 E.18262
G1 X110.263 Y124.865
G1 X119.373 Y133.975 E.45976
G1 X118.753 Y133.877
G1 X110.361 Y125.485 E.42351
G1 X110.513 Y126.159
G1 X118.083 Y133.728 E.382
G1 X117.338 Y133.505
G1 X110.733 Y126.901 E.33332
G1 X111.061 Y127.751
G1 X116.485 Y133.175 E.27375
G1 X115.431 Y132.643
G1 X111.602 Y128.814 E.19323
; WIPE_START
M204 S10000
G1 X113.016 Y130.228 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X118.003 Y124.449 Z2.427 F30000
G1 X124.863 Y116.499 Z2.427
G1 Z2.027
G1 E.8 F1800
G1 F12000
M204 S2000
G1 X121.377 Y113.013 E.17594
G1 X120.834 Y112.993
G1 X123.824 Y115.982 E.15088
G1 X123.018 Y115.698
G1 X120.319 Y112.999 E.13622
G1 X119.827 Y113.029
G1 X122.321 Y115.524 E.12591
G1 X121.697 Y115.422
G1 X119.355 Y113.079 E.1182
G1 X118.902 Y113.148
G1 X121.438 Y115.685 E.12799
G1 X121.116 Y115.884
G1 X118.467 Y113.235 E.1337
G1 X118.046 Y113.336
G1 X120.67 Y115.96 E.13244
G1 X119.621 Y115.433
G1 X117.639 Y113.451 E.10005
G1 X117.245 Y113.579
G1 X119.177 Y115.511 E.09748
G1 X118.749 Y115.604
G1 X116.863 Y113.719 E.09515
G1 X116.494 Y113.872
G1 X118.339 Y115.717 E.09313
G1 X117.948 Y115.847
G1 X116.137 Y114.037 E.09136
G1 X115.792 Y114.213
G1 X117.572 Y115.994 E.08986
G1 X117.211 Y116.155
G1 X115.455 Y114.398 E.08865
G1 X115.128 Y114.593
G1 X116.865 Y116.33 E.08766
G1 X116.531 Y116.519
G1 X114.811 Y114.799 E.08682
G1 X114.506 Y115.015
G1 X116.211 Y116.72 E.08606
G1 X115.904 Y116.935
G1 X114.209 Y115.24 E.08553
; WIPE_START
M204 S10000
M73 P65 R6
G1 X115.623 Y116.654 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X121.591 Y111.896 Z2.427 F30000
G1 X124.335 Y109.708 Z2.427
G1 Z2.027
G1 E.8 F1800
G1 F12000
M204 S2000
G1 X127.748 Y113.121 E.17225
; WIPE_START
M204 S10000
G1 X126.334 Y111.707 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.463 Y112.358 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
G1 F12000
M204 S2000
G1 X123.65 Y109.545 E.14192
G1 X123.001 Y109.418
G1 X125.491 Y111.908 E.12568
G1 X124.665 Y111.604
G1 X122.394 Y109.333 E.11458
G1 X121.816 Y109.276
G1 X123.92 Y111.38 E.10619
G1 X123.24 Y111.223
G1 X121.262 Y109.244 E.09985
G1 X120.736 Y109.241
G1 X122.605 Y111.109 E.09429
G1 X122.006 Y111.033
G1 X120.221 Y109.247 E.0901
G1 X119.723 Y109.272
G1 X121.438 Y110.987 E.08654
G1 X120.897 Y110.968
G1 X119.241 Y109.311 E.0836
G1 X118.774 Y109.367
G1 X120.378 Y110.971 E.08093
G1 X119.88 Y110.994
G1 X118.32 Y109.435 E.0787
G1 X117.881 Y109.518
G1 X119.399 Y111.035 E.07658
G1 X118.934 Y111.092
G1 X117.454 Y109.612 E.0747
G1 X117.036 Y109.716
G1 X118.484 Y111.164 E.07307
G1 X118.048 Y111.25
G1 X116.627 Y109.829 E.07171
G1 X116.236 Y109.96
G1 X117.627 Y111.351 E.07018
G1 X117.217 Y111.463
G1 X115.846 Y110.092 E.06916
G1 X115.469 Y110.237
G1 X116.817 Y111.585 E.06801
G1 X116.427 Y111.717
G1 X115.097 Y110.387 E.06713
G1 X114.734 Y110.546
G1 X116.051 Y111.863 E.06646
G1 X115.683 Y112.017
G1 X114.379 Y110.713 E.06583
G1 X114.035 Y110.891
G1 X115.324 Y112.18 E.06503
G1 X114.974 Y112.352
G1 X113.698 Y111.075 E.06443
G1 X113.366 Y111.266
G1 X114.635 Y112.535 E.06405
G1 X114.303 Y112.725
G1 X113.045 Y111.467 E.06349
G1 X112.731 Y111.674
G1 X113.979 Y112.922 E.06299
G1 X113.665 Y113.13
G1 X112.426 Y111.891 E.06253
G1 X112.12 Y112.108
G1 X113.358 Y113.345 E.06244
G1 X113.057 Y113.566
G1 X111.829 Y112.339 E.06195
G1 X111.539 Y112.57
G1 X112.767 Y113.799 E.06199
G1 X112.484 Y114.037
G1 X111.257 Y112.811 E.0619
G1 X110.982 Y113.057
G1 X112.207 Y114.282 E.06183
G1 X111.94 Y114.537
G1 X110.716 Y113.314 E.06176
G1 X110.456 Y113.575
G1 X111.68 Y114.799 E.0618
G1 X111.426 Y115.067
G1 X110.201 Y113.842 E.0618
G1 X109.956 Y114.119
G1 X111.182 Y115.345 E.0619
G1 X110.945 Y115.63
G1 X109.714 Y114.399 E.06214
G1 X109.482 Y114.689
G1 X110.715 Y115.922 E.06222
G1 X110.494 Y116.223
G1 X109.256 Y114.985 E.06252
G1 X109.034 Y115.285
G1 X110.281 Y116.532 E.06291
G1 X110.075 Y116.847
G1 X108.824 Y115.597 E.06311
G1 X108.618 Y115.913
G1 X109.877 Y117.172 E.06355
G1 X109.69 Y117.506
G1 X108.42 Y116.236 E.06411
G1 X108.23 Y116.569
G1 X109.509 Y117.848 E.06454
G1 X109.337 Y118.197
G1 X108.046 Y116.907 E.06513
G1 X107.871 Y117.254
G1 X109.177 Y118.559 E.06589
G1 X109.025 Y118.929
G1 X107.708 Y117.612 E.06645
G1 X107.549 Y117.976
G1 X108.881 Y119.308 E.06722
G1 X108.749 Y119.697
G1 X107.398 Y118.346 E.06819
G1 X107.256 Y118.727
G1 X108.629 Y120.1 E.06929
G1 X108.52 Y120.512
G1 X107.12 Y119.112 E.07066
G1 X106.996 Y119.51
G1 X108.422 Y120.936 E.07197
G1 X108.337 Y121.373
G1 X106.839 Y119.875 E.07559
G1 X106.734 Y120.292
G1 X108.267 Y121.825 E.07738
G1 X108.213 Y122.293
G1 X106.64 Y120.72 E.07942
G1 X106.56 Y121.162
G1 X108.175 Y122.777 E.0815
G1 X108.156 Y123.279
G1 X106.493 Y121.617 E.08391
G1 X106.438 Y122.083
G1 X108.156 Y123.802 E.08673
G1 X108.18 Y124.348
G1 X106.396 Y122.564 E.09004
G1 X106.37 Y123.06
G1 X108.231 Y124.92 E.0939
G1 X108.314 Y125.525
G1 X106.364 Y123.576 E.09839
G1 X106.377 Y124.11
G1 X108.432 Y126.166 E.10375
G1 X108.601 Y126.856
G1 X106.41 Y124.666 E.11055
G1 X106.468 Y125.246
G1 X108.837 Y127.614 E.11953
G1 X109.163 Y128.462
G1 X106.555 Y125.854 E.13159
G1 X106.675 Y126.497
G1 X109.647 Y129.468 E.14996
; WIPE_START
M204 S10000
G1 X108.232 Y128.054 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X110.514 Y130.857 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
G1 F12000
M204 S2000
G1 X106.836 Y127.179 E.18563
G1 X107.143 Y128.009
G1 X116.233 Y137.098 E.45874
G1 X115.41 Y136.797
G1 X107.44 Y128.827 E.40223
G1 X107.856 Y129.765
G1 X114.475 Y136.384 E.33405
M204 S10000
G1 X113.333 Y135.764 F30000
G1 F12000
M204 S2000
G1 X108.473 Y130.904 E.24531
; WIPE_START
M204 S10000
G1 X109.887 Y132.318 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X116.415 Y128.364 Z2.427 F30000
G1 X132.393 Y118.688 Z2.427
G1 Z2.027
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.196106
G1 F15000
G1 X132.312 Y118.569 E.00203
; LINE_WIDTH: 0.155752
G1 X132.231 Y118.45 E.00146
; LINE_WIDTH: 0.115398
G1 X132.149 Y118.331 E.0009
G1 X131.944 Y117.718 F30000
; LINE_WIDTH: 0.202439
G1 F15000
G1 X131.832 Y117.568 E.00274
; LINE_WIDTH: 0.159552
G1 X131.719 Y117.418 E.00197
; LINE_WIDTH: 0.116665
G1 X131.607 Y117.268 E.00119
G1 X131.179 Y116.433 F30000
; LINE_WIDTH: 0.226049
G1 F15000
G1 X131.068 Y116.298 E.00295
; LINE_WIDTH: 0.196642
G1 X130.89 Y116.09 E.00387
; LINE_WIDTH: 0.15417
G1 X130.71 Y115.88 E.00276
; LINE_WIDTH: 0.114056
G1 X130.468 Y115.609 E.00222
; WIPE_START
G1 X130.71 Y115.88 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.372 Y116.892 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.106157
G1 F15000
G1 X133.319 Y116.818 E.00049
; LINE_WIDTH: 0.138552
G1 X133.224 Y116.693 E.00132
; LINE_WIDTH: 0.181457
G1 X133.13 Y116.569 E.00197
; LINE_WIDTH: 0.214607
G1 X133.026 Y116.43 E.00275
; WIPE_START
G1 X133.13 Y116.569 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.534 Y112.73 Z2.427 F30000
G1 X124.133 Y111.333 Z2.427
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.129744
G1 F15000
G1 X123.905 Y111.395 E.0018
; WIPE_START
G1 X124.133 Y111.333 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.719 Y110.647 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.201201
G1 F15000
G1 X126.6 Y110.564 E.00212
; LINE_WIDTH: 0.165476
G1 X126.481 Y110.48 E.00161
; LINE_WIDTH: 0.122779
G1 X126.374 Y110.409 E.00089
; LINE_WIDTH: 0.0965739
G1 X126.35 Y110.392 E.00013
; WIPE_START
G1 X126.374 Y110.409 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X125.909 Y112.091 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.115216
G1 F15000
G1 X125.791 Y112.01 E.0009
; LINE_WIDTH: 0.155222
G1 X125.672 Y111.928 E.00145
; LINE_WIDTH: 0.195228
G1 X125.553 Y111.847 E.00201
; WIPE_START
G1 X125.672 Y111.928 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.973 Y112.634 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.116482
G1 F15000
G1 X126.823 Y112.522 E.00119
; LINE_WIDTH: 0.159008
G1 X126.673 Y112.409 E.00196
; LINE_WIDTH: 0.201534
G1 X126.524 Y112.297 E.00273
; WIPE_START
G1 X126.673 Y112.409 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.631 Y113.773 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.111715
G1 F15000
G1 X128.386 Y113.553 E.00193
; LINE_WIDTH: 0.149045
G1 X128.178 Y113.374 E.00261
; LINE_WIDTH: 0.190899
G1 X127.967 Y113.193 E.00377
; LINE_WIDTH: 0.223158
G1 X127.807 Y113.062 E.00344
; WIPE_START
G1 X127.967 Y113.193 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X132.6 Y115.596 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.111721
G1 F15000
G1 X132.484 Y115.455 E.00108
; LINE_WIDTH: 0.144721
G1 X132.367 Y115.313 E.00166
; LINE_WIDTH: 0.18345
G1 X132.175 Y115.09 E.00378
; LINE_WIDTH: 0.227907
G1 X131.983 Y114.866 E.00505
; LINE_WIDTH: 0.266326
G1 X131.785 Y114.646 E.00617
; LINE_WIDTH: 0.298686
G1 X131.588 Y114.425 E.00709
; LINE_WIDTH: 0.334837
G1 X131.185 Y113.994 E.01617
; LINE_WIDTH: 0.357456
G2 X129.925 Y112.754 I-23.017 J22.117 E.05241
; LINE_WIDTH: 0.312822
G1 X129.707 Y112.556 E.00748
; LINE_WIDTH: 0.283671
G1 X129.488 Y112.357 E.00665
; LINE_WIDTH: 0.248132
G1 X129.262 Y112.161 E.0057
; LINE_WIDTH: 0.206194
G1 X129.036 Y111.965 E.00449
; LINE_WIDTH: 0.16271
G1 X128.838 Y111.8 E.00279
; LINE_WIDTH: 0.117711
G1 X128.639 Y111.634 E.00167
; WIPE_START
G1 X128.838 Y111.8 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.494 Y117.709 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.108533
G1 F15000
G1 X129.4 Y117.595 E.00082
; LINE_WIDTH: 0.135155
G1 X129.306 Y117.481 E.0012
; LINE_WIDTH: 0.167048
G1 X129.142 Y117.29 E.00283
; LINE_WIDTH: 0.204183
G1 X128.977 Y117.099 E.00374
; LINE_WIDTH: 0.246376
G1 X128.671 Y116.76 E.00862
; LINE_WIDTH: 0.29327
G2 X127.665 Y115.741 I-17.201 J15.987 E.03356
; LINE_WIDTH: 0.268411
G1 X127.313 Y115.417 E.01007
; LINE_WIDTH: 0.234421
G1 X127.133 Y115.258 E.00426
; LINE_WIDTH: 0.204409
G1 X126.953 Y115.099 E.00356
; LINE_WIDTH: 0.168836
G1 X126.769 Y114.944 E.00275
; LINE_WIDTH: 0.127693
G1 X126.585 Y114.789 E.00179
; LINE_WIDTH: 0.101169
G1 X126.525 Y114.74 E.00037
; WIPE_START
G1 X126.585 Y114.789 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X125.528 Y116.933 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.0964528
G1 F15000
G1 X125.497 Y116.906 E.00018
; LINE_WIDTH: 0.118075
G1 X125.329 Y116.766 E.00141
; LINE_WIDTH: 0.158917
G1 X125.159 Y116.625 E.00231
; LINE_WIDTH: 0.192158
G1 X125.041 Y116.532 E.00205
; LINE_WIDTH: 0.217299
G1 X124.922 Y116.44 E.00242
G1 X124.248 Y116.171 F30000
; LINE_WIDTH: 0.11832
G1 F15000
G1 X124.129 Y116.088 E.00095
; LINE_WIDTH: 0.176582
G2 X123.886 Y115.92 I-6.808 J9.563 E.00358
; WIPE_START
G1 X124.129 Y116.088 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X116.551 Y116.997 Z2.427 F30000
G1 X115.713 Y117.098 Z2.427
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.181637
G1 F15000
G1 X113.998 Y115.383 E.03065
; WIPE_START
G1 X115.412 Y116.797 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X114.266 Y118.552 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.245354
G1 F15000
G1 X112.55 Y116.836 E.04562
; WIPE_START
G1 X113.964 Y118.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.124 Y123.254 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.17053
G1 F15000
G1 X112.974 Y123.039 E.00304
; LINE_WIDTH: 0.22867
G2 X112.541 Y122.577 I-2.699 J2.099 E.01089
; WIPE_START
G1 X112.818 Y122.852 E-.46772
G1 X112.974 Y123.039 E-.29228
; WIPE_END
G1 E-.04 F1800
G1 X113.015 Y124.047 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.10368
G1 F15000
G1 X112.937 Y124.146 E.00064
; WIPE_START
G1 X113.015 Y124.047 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.879 Y126.175 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.101162
G1 F15000
G1 X112.935 Y125.943 E.00116
; WIPE_START
G1 X112.879 Y126.175 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.441 Y127.233 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.098359
G1 F15000
G1 X113.414 Y127.197 E.0002
; LINE_WIDTH: 0.121219
G1 X113.333 Y127.081 E.00096
; LINE_WIDTH: 0.160206
G1 X113.251 Y126.965 E.0015
; LINE_WIDTH: 0.199192
G1 X113.17 Y126.849 E.00203
; WIPE_START
G1 X113.251 Y126.965 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X114.442 Y128.753 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.0995175
G1 F15000
G1 X114.354 Y128.657 E.00061
; LINE_WIDTH: 0.118311
G1 X114.211 Y128.494 E.00141
; LINE_WIDTH: 0.147373
G1 X114.066 Y128.328 E.00205
; LINE_WIDTH: 0.179721
G1 X113.916 Y128.147 E.00293
; LINE_WIDTH: 0.215033
G1 X113.765 Y127.966 E.00374
; WIPE_START
G1 X113.916 Y128.147 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X111.662 Y128.754 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.2071
G1 F15000
G1 X111.512 Y128.559 E.00372
; LINE_WIDTH: 0.163734
G1 X111.417 Y128.429 E.00175
; LINE_WIDTH: 0.118059
G1 X111.323 Y128.3 E.00104
; WIPE_START
G1 X111.417 Y128.429 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X108.364 Y125.815 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.126432
G1 F15000
G1 X108.247 Y125.592 E.00184
; WIPE_START
G1 X108.364 Y125.815 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.351 Y128.885 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.0980635
G1 F15000
G1 X109.328 Y128.852 E.00018
; LINE_WIDTH: 0.116026
G1 X109.282 Y128.786 E.00051
; LINE_WIDTH: 0.14581
G1 X109.236 Y128.719 E.00074
; LINE_WIDTH: 0.174758
G1 X109.169 Y128.621 E.00142
; LINE_WIDTH: 0.20289
G1 X109.102 Y128.523 E.00175
; WIPE_START
G1 X109.169 Y128.621 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.953 Y130.008 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.118694
G1 F15000
G1 X109.818 Y129.835 E.00144
; LINE_WIDTH: 0.163116
G1 X109.702 Y129.681 E.00209
; LINE_WIDTH: 0.204793
G1 X109.587 Y129.528 E.00286
; WIPE_START
G1 X109.702 Y129.681 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X108.532 Y130.844 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.205693
G1 F15000
G1 X108.396 Y130.667 E.00334
; LINE_WIDTH: 0.16037
G1 X108.259 Y130.491 E.00236
; LINE_WIDTH: 0.116456
G1 X108.16 Y130.357 E.00105
; WIPE_START
G1 X108.259 Y130.491 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X111.556 Y132.129 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.111394
G1 F15000
M73 P66 R6
G1 X111.084 Y131.63 E.00401
; LINE_WIDTH: 0.146845
G1 X110.909 Y131.435 E.00243
; LINE_WIDTH: 0.175183
G1 X110.732 Y131.238 E.00318
; LINE_WIDTH: 0.21415
G1 X110.455 Y130.916 E.0067
; WIPE_START
G1 X110.732 Y131.238 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.323 Y133.784 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.21771
G1 F15000
G1 X113.048 Y133.549 E.00584
; LINE_WIDTH: 0.181851
G1 X112.844 Y133.366 E.00347
; LINE_WIDTH: 0.151365
G1 X112.638 Y133.182 E.00268
; LINE_WIDTH: 0.112312
G1 X112.097 Y132.67 E.00442
; WIPE_START
G1 X112.638 Y133.182 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X114.61 Y132.112 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.110373
G1 F15000
G1 X114.449 Y131.973 E.00123
; LINE_WIDTH: 0.14068
G1 X114.287 Y131.834 E.00185
; LINE_WIDTH: 0.168325
G1 X114.108 Y131.673 E.00273
; LINE_WIDTH: 0.193343
G1 X113.929 Y131.512 E.00331
; LINE_WIDTH: 0.229471
G3 X112.907 Y130.502 I16.026 J-17.25 E.0248
; LINE_WIDTH: 0.204889
G1 X112.581 Y130.149 E.00715
; LINE_WIDTH: 0.170918
G1 X112.422 Y129.969 E.00279
; LINE_WIDTH: 0.140951
G1 X112.263 Y129.789 E.00209
; LINE_WIDTH: 0.110604
G1 X112.132 Y129.634 E.00117
; WIPE_START
G1 X112.263 Y129.789 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X116.274 Y130.474 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.215033
G1 F15000
G1 X116.093 Y130.324 E.00374
; LINE_WIDTH: 0.179512
G1 X115.909 Y130.172 E.00296
; LINE_WIDTH: 0.147182
G1 X115.746 Y130.029 E.00202
; LINE_WIDTH: 0.11127
G1 X115.487 Y129.798 E.00203
; WIPE_START
G1 X115.746 Y130.029 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X117.39 Y131.07 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.199183
G1 F15000
G1 X117.274 Y130.988 E.00203
; LINE_WIDTH: 0.160212
G1 X117.158 Y130.907 E.0015
; LINE_WIDTH: 0.115775
G1 X117.007 Y130.799 E.00117
; WIPE_START
G1 X117.158 Y130.907 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.873 Y127.278 Z2.427 F30000
G1 X128.823 Y124.602 Z2.427
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.161735
G1 F15000
G1 X128.853 Y124.488 E.00126
G3 X128.424 Y124.03 I6.23 J-6.259 E.00673
; LINE_WIDTH: 0.111817
G1 X128.357 Y123.934 E.00068
G1 X128.459 Y122.966 F30000
; LINE_WIDTH: 0.109586
G1 F15000
G2 X128.377 Y123.076 I.853 J.718 E.00078
; WIPE_START
G1 X128.459 Y122.966 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.603 Y121.158 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.184471
G1 F15000
G2 X128.431 Y120.87 I-11.866 J6.897 E.00433
; WIPE_START
G1 X128.603 Y121.158 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.8 Y119.317 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.208019
G1 F15000
G1 X127.631 Y119.102 E.00416
; LINE_WIDTH: 0.163956
G1 X127.483 Y118.923 E.00254
; LINE_WIDTH: 0.116332
G1 X127.307 Y118.712 E.00174
; WIPE_START
G1 X127.483 Y118.923 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X130.193 Y118.932 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.11506
G1 F15000
G1 X130.117 Y118.825 E.00081
; LINE_WIDTH: 0.154738
G1 X130.041 Y118.719 E.00131
; LINE_WIDTH: 0.187229
G1 X129.961 Y118.613 E.00175
; LINE_WIDTH: 0.212541
G1 X129.882 Y118.506 E.00207
; WIPE_START
G1 X129.961 Y118.613 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.151 Y126.152 Z2.427 F30000
G1 X131.525 Y128.52 Z2.427
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.156245
G1 F15000
G1 X131.279 Y128.38 E.00288
; WIPE_START
G1 X131.525 Y128.52 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X132.747 Y127.255 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.108751
G1 F15000
G1 X132.665 Y127.388 E.00088
; WIPE_START
G1 X132.747 Y127.255 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.278 Y124.768 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.107335
G1 F15000
G1 X133.213 Y124.589 E.00104
; WIPE_START
G1 X133.278 Y124.768 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.86 Y128.899 Z2.427 F30000
G1 X114.915 Y136.588 Z2.427
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.118406
G1 F15000
G1 X114.801 Y136.511 E.0009
; LINE_WIDTH: 0.164775
G1 X114.688 Y136.433 E.00151
; LINE_WIDTH: 0.204512
G1 X114.535 Y136.324 E.00279
G1 X113.88 Y136.077 F30000
; LINE_WIDTH: 0.115918
G1 F15000
G1 X113.755 Y135.983 E.00098
; LINE_WIDTH: 0.157317
G1 X113.63 Y135.89 E.00161
; LINE_WIDTH: 0.190865
G1 X113.511 Y135.797 E.00203
; LINE_WIDTH: 0.216545
G1 X113.393 Y135.705 E.00241
G1 X112.497 Y135.218 F30000
; LINE_WIDTH: 0.113097
G1 F15000
G1 X112.32 Y135.067 E.0014
; LINE_WIDTH: 0.148859
G1 X112.142 Y134.916 E.00221
; LINE_WIDTH: 0.184314
G1 X111.922 Y134.721 E.0038
; LINE_WIDTH: 0.219504
G1 X111.701 Y134.525 E.0048
; LINE_WIDTH: 0.260202
G1 X111.267 Y134.124 E.01196
; LINE_WIDTH: 0.29518
G3 X110.015 Y132.865 I22.008 J-23.147 E.04195
; LINE_WIDTH: 0.260962
G1 X109.815 Y132.646 E.00602
; LINE_WIDTH: 0.234678
G1 X109.614 Y132.427 E.00527
; LINE_WIDTH: 0.200914
G1 X109.426 Y132.209 E.00418
; LINE_WIDTH: 0.159706
G1 X109.237 Y131.992 E.00303
; LINE_WIDTH: 0.116023
G3 X109.026 Y131.746 I4.622 J-4.194 E.00204
; WIPE_START
G1 X109.237 Y131.992 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X114.711 Y134.652 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.207241
G1 F15000
G1 X114.574 Y134.549 E.00259
; LINE_WIDTH: 0.170828
G1 X114.435 Y134.445 E.00201
; LINE_WIDTH: 0.138092
G1 X114.333 Y134.366 E.00109
; LINE_WIDTH: 0.109508
G1 X114.231 Y134.286 E.00073
; WIPE_START
G1 X114.333 Y134.366 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X116.562 Y135.466 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.170971
G1 F15000
G1 X116.253 Y135.269 E.00425
; WIPE_START
G1 X116.562 Y135.466 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X118.09 Y135.793 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.0962162
G1 F15000
G1 X117.866 Y135.86 E.00103
; WIPE_START
G1 X118.09 Y135.793 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X119.251 Y136.077 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.116289
G1 F15000
G1 X119.045 Y135.974 E.00146
; WIPE_START
G1 X119.251 Y136.077 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.485 Y133.65 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.104482
G1 F15000
G1 X123.337 Y133.733 E.00088
; WIPE_START
G1 X123.485 Y133.65 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X116.889 Y133.347 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.161092
G1 F15000
G1 X116.718 Y133.23 E.0022
; LINE_WIDTH: 0.197739
G1 X116.546 Y133.114 E.00294
; WIPE_START
G1 X116.718 Y133.23 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.408 Y129.557 Z2.427 F30000
G1 X135.606 Y122.858 Z2.427
G1 Z2.027
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F13937.913
G2 X135.451 Y121.238 I-13.065 J.436 E.06284
G1 X149.14 Y134.927 E.74701
G2 X148.805 Y135.488 I2.241 J1.717 E.02527
G1 X145.707 Y138.587 E.16909
G1 X145.124 Y138.587 E.02249
G1 X134.839 Y128.302 E.56122
G2 X135.446 Y125.819 I-14.014 J-4.742 E.09877
G1 X149.141 Y112.125 E.74729
G3 X148.803 Y111.562 I2.118 J-1.654 E.0254
G1 X145.708 Y108.467 E.16887
G1 X145.122 Y108.468 E.02261
G1 X134.841 Y118.749 E.56103
G2 X134.235 Y117.238 I-15.003 J5.145 E.06283
G1 X149.27 Y112.282 F30000
G1 F13937.913
G2 X150.136 Y112.895 I2.489 J-2.599 E.04111
G1 X153.617 Y116.377 E.18997
G1 X153.617 Y115.324 E.0406
G1 X130.355 Y138.587 E1.26942
G1 X129.772 Y138.587 E.02249
G1 X127.82 Y136.635 E.10649
G2 X132.061 Y133.2 I-7.496 J-13.591 E.21169
G1 X137.448 Y138.587 E.29393
G1 X138.031 Y138.587 E.02249
G1 X153.619 Y122.998 E.85067
G1 X153.62 Y124.055 E.04078
G1 X138.035 Y108.47 E.85048
G1 X137.444 Y108.47 E.0228
G1 X132.055 Y113.859 E.29407
G2 X127.822 Y110.416 I-11.637 J9.981 E.21167
G1 X129.765 Y108.472 E.10605
G1 X130.361 Y108.472 E.02298
G1 X153.622 Y131.733 E1.26935
G1 X153.622 Y130.672 E.04096
G1 X150.14 Y134.154 E.19001
G2 X149.274 Y134.774 I1.107 J2.46 E.04138
; WIPE_START
G1 X149.602 Y134.469 E-.17029
G1 X150.14 Y134.154 E-.23685
G1 X150.796 Y133.497 E-.35286
; WIPE_END
G1 E-.04 F1800
G1 X149.843 Y138.605 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.118766
G1 F15000
G2 X150.034 Y138.713 I.229 J-.181 E.00148
; WIPE_START
G1 X149.958 Y138.692 E-.27042
G1 X149.843 Y138.605 E-.48958
; WIPE_END
G1 E-.04 F1800
G1 X152.584 Y138.731 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.455513
G1 F13747.985
G2 X153.13 Y138.335 I-3.515 J-5.418 E.02637
; LINE_WIDTH: 0.510773
G1 F12095.873
G2 X153.5 Y137.831 I-.99 J-1.114 E.02802
G1 X153.511 Y137.802 E.00136
; LINE_WIDTH: 0.464499
G1 F13449.27
G2 X153.568 Y137.632 I-1.595 J-.627 E.00719
; LINE_WIDTH: 0.418192
G1 F15000
G1 X153.596 Y137.522 E.00403
; LINE_WIDTH: 0.392657
G1 X153.6 Y137.502 E.00068
; LINE_WIDTH: 0.3654
G1 X153.624 Y137.356 E.00448
; LINE_WIDTH: 0.317726
G1 X153.648 Y137.212 E.00378
; LINE_WIDTH: 0.276556
G1 X153.665 Y137.053 E.00349
; LINE_WIDTH: 0.24488
G1 X153.68 Y136.908 E.00273
; LINE_WIDTH: 0.211142
G1 X153.69 Y136.309 E.00928
; LINE_WIDTH: 0.232454
G1 X153.668 Y136.01 E.00526
; LINE_WIDTH: 0.275019
G1 X153.647 Y135.853 E.00343
; LINE_WIDTH: 0.315476
G1 X153.628 Y135.708 E.00374
; LINE_WIDTH: 0.351062
G1 X153.611 Y135.621 E.00259
; LINE_WIDTH: 0.381786
G1 X153.597 Y135.55 E.0023
; LINE_WIDTH: 0.423277
G1 F14938.203
G1 X153.54 Y135.265 E.01046
G1 X153.535 Y111.792 F30000
; LINE_WIDTH: 0.393296
G1 F15000
G1 X153.6 Y111.499 E.00992
; LINE_WIDTH: 0.365439
G1 X153.624 Y111.355 E.00447
; LINE_WIDTH: 0.317779
G1 X153.648 Y111.21 E.00379
; LINE_WIDTH: 0.29203
G1 X153.65 Y111.195 E.00034
; LINE_WIDTH: 0.275042
G1 X153.665 Y111.051 E.00315
; LINE_WIDTH: 0.243811
G1 X153.681 Y110.895 E.00291
; LINE_WIDTH: 0.210826
G1 X153.689 Y110.297 E.00925
; LINE_WIDTH: 0.234077
G2 X153.667 Y109.996 I-5.134 J.236 E.00536
; LINE_WIDTH: 0.276618
G1 X153.647 Y109.851 E.00319
; LINE_WIDTH: 0.31781
G1 X153.625 Y109.689 E.00422
; LINE_WIDTH: 0.353888
G1 X153.612 Y109.62 E.00205
; LINE_WIDTH: 0.380661
G1 X153.598 Y109.552 E.00223
; LINE_WIDTH: 0.419515
G2 X153.564 Y109.401 I-1.452 J.254 E.00551
; LINE_WIDTH: 0.456812
G1 F13703.998
G1 X153.536 Y109.319 E.00338
; LINE_WIDTH: 0.497285
G1 F12461.405
G2 X153.43 Y109.086 I-1.974 J.758 E.01106
; LINE_WIDTH: 0.51627
G1 F11953.006
G2 X153.141 Y108.731 I-1.2 J.682 E.0207
; LINE_WIDTH: 0.471782
G1 F13216.525
G2 X153.006 Y108.623 I-.998 J1.101 E.00704
; LINE_WIDTH: 0.419306
G1 F15000
G2 X152.504 Y108.32 I-3.124 J4.617 E.02091
; WIPE_START
G1 X153.006 Y108.623 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.978 Y108.32 Z2.427 F30000
G1 Z2.027
G1 E.8 F1800
; LINE_WIDTH: 0.156727
G1 F15000
G1 X149.902 Y108.378 E.00098
; LINE_WIDTH: 0.129771
G1 X149.723 Y108.533 E.00181
; CHANGE_LAYER
; Z_HEIGHT: 2.29732
; LAYER_HEIGHT: 0.270486
; WIPE_START
G1 F15000
G1 X149.902 Y108.378 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 14/33
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
G17
G3 Z2.427 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.194 Y138.262
G1 Z2.297
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X154.009 Y138.577 E.01454
G3 X152.558 Y139.316 I-1.453 J-1.057 E.06744
G1 X115.566 Y139.316 E1.47556
G3 X105.773 Y129.523 I.024 J-9.817 E.61321
G1 X105.773 Y117.529 E.47843
G3 X115.566 Y107.736 I9.797 J.004 E.61355
G1 X152.703 Y107.744 E1.48136
G3 X154.353 Y109.532 I-.143 J1.788 E.10667
G1 X154.353 Y137.521 E1.11646
G3 X154.217 Y138.207 I-1.797 J-.001 E.0281
; WIPE_START
M204 S10000
G1 X154.009 Y138.577 E-.1611
G1 X153.761 Y138.856 E-.14206
G1 X153.458 Y139.076 E-.14218
G1 X153.116 Y139.228 E-.14221
G1 X152.75 Y139.306 E-.14216
G1 X152.671 Y139.31 E-.03029
; WIPE_END
G1 E-.04 F1800
G1 X152.087 Y131.7 Z2.697 F30000
G1 X150.305 Y108.468 Z2.697
G1 Z2.297
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F12450.724
G1 X150.274 Y108.483 E.00147
G2 X151.828 Y108.386 I.908 J2.044 E.53819
G1 X151.558 Y108.321 E.01202
G1 X151.582 Y108.113 E.00902
G3 X152.711 Y108.122 I.477 J11.515 E.04876
G3 X153.976 Y109.542 I-.171 J1.426 E.08979
G1 X153.976 Y137.511 E1.20813
G3 X152.548 Y138.939 I-1.42 J.009 E.0971
G1 X151.602 Y138.939 E.04086
G1 X151.583 Y138.725 E.00929
G2 X148.988 Y136.985 I-.407 J-2.198 E.45736
G2 X150.766 Y138.725 I2.187 J-.457 E.114
G1 X150.747 Y138.939 E.00929
G1 X115.571 Y138.939 E1.51945
G3 X106.15 Y129.518 I.018 J-9.439 E.63889
G1 X106.15 Y117.534 E.51766
G3 X115.571 Y108.113 I9.42 J-.001 E.63925
G1 X150.767 Y108.113 E1.52028
G1 X150.791 Y108.321 E.00902
G1 X150.653 Y108.354 E.00612
G1 X150.362 Y108.449 E.01325
; WIPE_START
G1 X150.274 Y108.483 E-.03565
G1 X150.036 Y108.599 E-.10064
G1 X149.817 Y108.747 E-.10077
G1 X149.616 Y108.921 E-.10078
G1 X149.437 Y109.116 E-.10076
G1 X149.282 Y109.332 E-.10077
G1 X149.154 Y109.564 E-.10071
G1 X149.054 Y109.81 E-.10078
G1 X149.041 Y109.858 E-.01914
; WIPE_END
G1 E-.04 F1800
G1 X144.007 Y115.595 Z2.697 F30000
G1 X125.934 Y136.191 Z2.697
G1 Z2.297
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.461 Y136.385 E.0204
G3 X120.143 Y109.828 I-4.748 J-12.86 E1.88853
G3 X121.283 Y109.828 I.571 J14.93 E.04551
G3 X126.513 Y135.946 I-.57 J13.697 E1.45628
G1 X125.989 Y136.167 E.02269
M204 S10000
G1 X126.062 Y136.557 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F12450.724
G1 X125.592 Y136.739 E.0218
G3 X120.127 Y109.451 I-4.878 J-13.214 E2.10127
G3 X121.298 Y109.451 I.586 J15.339 E.0506
G3 X126.137 Y136.524 I-.585 J14.073 E1.64571
G1 X126.117 Y136.533 E.00093
; WIPE_START
G1 X125.592 Y136.739 E-.21452
G1 X125.039 Y136.933 E-.22271
G1 X124.477 Y137.101 E-.22274
G1 X124.222 Y137.166 E-.10003
; WIPE_END
G1 E-.04 F1800
G1 X129.403 Y131.562 Z2.697 F30000
G1 X150.423 Y108.825 Z2.697
G1 Z2.297
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.425 Y108.824 E.00008
G3 X151.064 Y108.669 I.75 J1.702 E.02639
G3 X151.398 Y108.683 I.11 J1.407 E.01335
G1 X151.504 Y108.695 E.00424
G3 X150.229 Y108.925 I-.329 J1.83 E.41331
G1 X150.37 Y108.852 E.00632
; WIPE_START
M204 S10000
G1 X150.425 Y108.824 E-.02352
G1 X150.742 Y108.72 E-.12688
G1 X151.064 Y108.669 E-.12401
G1 X151.398 Y108.683 E-.12688
G1 X151.504 Y108.695 E-.04044
G1 X151.718 Y108.747 E-.08377
G1 X151.924 Y108.824 E-.08373
G1 X152.121 Y108.924 E-.08378
G1 X152.267 Y109.023 E-.06701
; WIPE_END
G1 E-.04 F1800
G1 X152.412 Y116.654 Z2.697 F30000
G1 X152.806 Y137.421 Z2.697
G1 Z2.297
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.802 Y137.426 E.00027
G3 X151.064 Y134.672 I-1.627 J-.899 E.30757
G3 X151.398 Y134.685 I.11 J1.408 E.01335
G1 X151.504 Y134.698 E.00424
G3 X152.896 Y137.227 I-.329 J1.829 E.1319
G1 X152.832 Y137.367 E.00614
M204 S10000
G1 X153.596 Y137.522 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.421117
G1 F13441.201
G1 X153.601 Y137.501 E.00087
; LINE_WIDTH: 0.393779
G1 F14535.703
G1 X153.624 Y137.357 E.00541
; LINE_WIDTH: 0.346345
G1 F15000
G1 X153.648 Y137.213 E.00464
; LINE_WIDTH: 0.305129
G1 X153.665 Y137.053 E.00438
; LINE_WIDTH: 0.273437
G1 X153.68 Y136.909 E.00344
; LINE_WIDTH: 0.239646
G1 X153.69 Y136.31 E.01199
; LINE_WIDTH: 0.260859
G1 X153.668 Y136.011 E.0067
; LINE_WIDTH: 0.303442
G1 X153.647 Y135.853 E.0043
; LINE_WIDTH: 0.343884
G1 X153.628 Y135.709 E.00458
; LINE_WIDTH: 0.385165
G1 F14918.483
G2 X153.589 Y135.505 I-3.468 J.561 E.00749
; LINE_WIDTH: 0.422598
G1 F13386.601
G1 X153.552 Y135.319 E.0076
G1 X153.596 Y137.522 F30000
; LINE_WIDTH: 0.446795
G1 F12553.387
G1 X153.568 Y137.632 E.00485
; LINE_WIDTH: 0.492936
G1 F11221.488
G3 X153.511 Y137.802 I-1.644 J-.454 E.00858
; LINE_WIDTH: 0.539203
G1 F10142.446
G1 X153.5 Y137.831 E.00166
G3 X153.129 Y138.335 I-1.359 J-.61 E.03344
; LINE_WIDTH: 0.483925
G1 F11458.914
G3 X152.568 Y138.742 I-4.174 J-5.164 E.03254
; WIPE_START
G1 X153.129 Y138.335 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.043 Y138.743 Z2.697 F30000
G1 Z2.297
G1 E.8 F1800
; LINE_WIDTH: 0.129031
G1 F15000
G1 X149.85 Y138.596 E.0019
; WIPE_START
G1 X150.043 Y138.743 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.281 Y134.781 Z2.697 F30000
G1 Z2.297
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F12450.724
G3 X150.12 Y134.173 I2.531 J2.613 E.04493
G1 X153.631 Y130.662 E.21447
G1 X153.632 Y131.743 E.04668
G1 X130.351 Y108.462 E1.42215
G1 X129.775 Y108.463 E.02489
G1 X127.888 Y110.364 E.11572
G3 X132.109 Y113.805 I-7.092 J13.009 E.23657
G1 X137.453 Y108.46 E.32649
G1 X138.025 Y108.46 E.02469
G1 X153.629 Y124.064 E.95324
G1 X153.629 Y122.989 E.04648
G1 X138.021 Y138.596 E.95346
G1 X137.457 Y138.596 E.02434
G1 X132.116 Y133.255 E.32633
G1 X132.008 Y133.382 E.0072
G3 X127.876 Y136.691 I-11.352 J-9.941 E.22985
G1 X129.781 Y138.596 E.11638
G1 X130.345 Y138.596 E.02434
G1 X153.627 Y115.315 E1.42222
G1 X153.627 Y116.386 E.04628
G1 X150.117 Y112.877 E.21439
G3 X149.284 Y112.269 I2.241 J-3.948 E.04465
; WIPE_START
G1 X149.726 Y112.664 E-.22537
G1 X150.117 Y112.877 E-.16916
G1 X150.797 Y113.557 E-.36546
; WIPE_END
G1 E-.04 F1800
G1 X149.73 Y108.541 Z2.697 F30000
G1 Z2.297
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.136658
G1 F15000
G1 X149.908 Y108.388 E.00204
; LINE_WIDTH: 0.167739
G1 X150.01 Y108.309 E.00156
; WIPE_START
G1 X149.908 Y108.388 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X152.486 Y108.309 Z2.697 F30000
G1 Z2.297
G1 E.8 F1800
; LINE_WIDTH: 0.447671
G1 F12525.158
G3 X153.006 Y108.622 I-2.712 J5.092 E.02606
; LINE_WIDTH: 0.500148
G1 F11038.427
G3 X153.141 Y108.731 I-.86 J1.207 E.00847
; LINE_WIDTH: 0.54477
G1 F10026.438
G3 X153.43 Y109.086 I-.911 J1.037 E.02464
; LINE_WIDTH: 0.525807
G1 F10432.915
G3 X153.536 Y109.319 I-1.842 J.98 E.01325
; LINE_WIDTH: 0.485185
G1 F11425.108
G1 X153.564 Y109.402 E.00408
; LINE_WIDTH: 0.447853
G1 F12519.294
G3 X153.598 Y109.552 I-1.419 J.405 E.00662
; LINE_WIDTH: 0.409131
G1 F13900.099
G1 X153.611 Y109.62 E.00269
; LINE_WIDTH: 0.382538
G1 F15000
G1 X153.625 Y109.688 E.00248
; LINE_WIDTH: 0.346404
G1 X153.647 Y109.851 E.00521
; LINE_WIDTH: 0.305188
G1 X153.666 Y109.995 E.00396
; LINE_WIDTH: 0.262652
G3 X153.689 Y110.297 I-5.031 J.532 E.00683
; LINE_WIDTH: 0.239302
G1 X153.681 Y110.895 E.01194
; LINE_WIDTH: 0.272243
G1 X153.665 Y111.051 E.0037
; LINE_WIDTH: 0.303478
M73 P67 R6
G1 X153.65 Y111.195 E.00392
; LINE_WIDTH: 0.320594
G1 X153.648 Y111.21 E.00045
; LINE_WIDTH: 0.346389
G1 X153.624 Y111.355 E.00465
; LINE_WIDTH: 0.393834
G1 F14533.303
G1 X153.601 Y111.499 E.00541
; LINE_WIDTH: 0.430922
G1 F13087.777
G3 X153.549 Y111.732 I-3.948 J-.759 E.00981
; WIPE_START
G1 X153.601 Y111.499 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X146.278 Y113.653 Z2.697 F30000
G1 X134.292 Y117.18 Z2.697
G1 Z2.297
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F12450.724
G1 X134.901 Y118.689 E.0703
G1 X145.132 Y108.458 E.625
G1 X145.699 Y108.458 E.02448
G1 X148.823 Y111.582 E.19087
G2 X149.15 Y112.116 I2.182 J-.97 E.0271
G1 X135.537 Y125.728 E.83155
G1 X135.472 Y126.156 E.01871
G3 X134.899 Y128.363 I-15.517 J-2.847 E.09854
G1 X145.133 Y138.596 E.62517
G1 X145.697 Y138.596 E.02434
G1 X148.823 Y135.471 E.19094
G3 X149.147 Y134.934 I2.653 J1.236 E.02714
G1 X135.54 Y121.327 E.83123
G3 X135.689 Y122.948 I-13.042 J2.019 E.07035
; WIPE_START
G1 X135.54 Y121.327 E-.61851
G1 X135.803 Y121.59 E-.14149
; WIPE_END
G1 E-.04 F1800
G1 X130.37 Y116.229 Z2.697 F30000
G1 X123.274 Y109.227 Z2.697
G1 Z2.297
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.562263
G1 F9678.584
G3 X123.081 Y137.866 I-2.559 J14.303 E2.26157
G1 X123.022 Y137.876 F30000
; LINE_WIDTH: 0.565667
G1 F9613.688
G3 X121.624 Y138.022 I-1.577 J-8.363 E.07869
; LINE_WIDTH: 0.53617
G1 F10206.784
G3 X119.209 Y137.985 I-.81 J-25.938 E.1273
; LINE_WIDTH: 0.568618
G1 F9558.121
G3 X118.368 Y137.868 I.41 J-6.051 E.04782
G1 X118.596 Y138.046 E.01625
G1 X118.654 Y138.223 E.01052
G1 X118.638 Y138.482 E.01457
G3 X119.782 Y138.503 I-1.115 J92.961 E.06442
; LINE_WIDTH: 0.53617
G1 F10206.775
G2 X122.238 Y138.49 I.831 J-78.754 E.12942
; LINE_WIDTH: 0.575427
G1 F9432.331
G1 X122.789 Y138.482 E.03139
G1 X122.772 Y138.214 E.01532
G1 X122.905 Y137.956 E.01653
G1 X122.972 Y137.91 E.00463
; WIPE_START
G1 X122.905 Y137.956 E-.05181
G1 X122.772 Y138.214 E-.18514
G1 X122.789 Y138.482 E-.17159
G1 X122.238 Y138.49 E-.35146
; WIPE_END
G1 E-.04 F1800
G1 X115.808 Y134.378 Z2.697 F30000
G1 X107.2 Y128.874 Z2.697
G1 Z2.297
G1 E.8 F1800
; LINE_WIDTH: 0.562315
G1 F9677.582
G2 X118.309 Y137.857 I13.514 J-5.351 E.83004
; WIPE_START
G1 X117.468 Y137.688 E-.32599
G1 X116.828 Y137.532 E-.25047
G1 X116.365 Y137.394 E-.18354
; WIPE_END
G1 E-.04 F1800
G1 X110.775 Y132.197 Z2.697 F30000
G1 X107.2 Y128.874 Z2.697
G1 Z2.297
G1 E.8 F1800
; LINE_WIDTH: 0.525453
G1 F10440.806
G3 X106.779 Y127.561 I39.027 J-13.229 E.07101
G1 X106.586 Y127.584 E.01
G1 X106.587 Y128.73 E.05902
G1 X106.867 Y128.687 E.01457
G1 X107.089 Y128.761 E.01206
G1 X107.157 Y128.831 E.00505
; WIPE_START
G1 X107.089 Y128.761 E-.03728
G1 X106.867 Y128.687 E-.08895
G1 X106.587 Y128.73 E-.10748
G1 X106.586 Y127.584 E-.4354
G1 X106.779 Y127.561 E-.07378
G1 X106.793 Y127.604 E-.0171
; WIPE_END
G1 E-.04 F1800
G1 X107.109 Y119.978 Z2.697 F30000
G1 X107.182 Y118.22 Z2.697
G1 Z2.297
G1 E.8 F1800
; LINE_WIDTH: 0.562974
G1 F9664.967
G3 X118.128 Y109.228 I13.521 J5.301 E.82345
G1 X118.187 Y109.217 F30000
; LINE_WIDTH: 0.534522
G1 F10242.092
G1 X118.375 Y109.211 E.00991
; LINE_WIDTH: 0.488712
G1 F11331.546
G1 X118.564 Y109.204 E.00896
; LINE_WIDTH: 0.42109
G1 F12000
G1 X118.753 Y109.198 E.00755
G3 X122.51 Y109.174 I1.979 J15.788 E.15069
; LINE_WIDTH: 0.437962
G1 X122.799 Y109.199 E.01215
; LINE_WIDTH: 0.473892
G1 F11735.384
G1 X123.089 Y109.223 E.01329
; LINE_WIDTH: 0.508009
G1 F10845.572
G1 X123.181 Y109.225 E.00459
; LINE_WIDTH: 0.529961
G1 F10341.085
G1 X123.274 Y109.227 E.00481
G1 X123.152 Y109.114 E.00859
; LINE_WIDTH: 0.473892
G1 F11735.384
G1 X123.113 Y108.986 E.00615
; LINE_WIDTH: 0.421517
G1 F12000
G3 X123.087 Y108.723 I.3 J-.163 E.01088
G1 X122.902 Y108.499 E.01162
G1 X118.518 Y108.5 E.17563
G1 X118.337 Y108.72 E.01142
G1 X118.331 Y109.011 E.01163
; LINE_WIDTH: 0.485232
G1 F11423.857
G1 X118.276 Y109.089 E.00452
; LINE_WIDTH: 0.533362
G1 F10267.089
G1 X118.221 Y109.168 E.00503
G1 X118.702 Y108.851 F30000
; LINE_WIDTH: 0.376172
G1 F12000
G1 X119.089 Y108.829 E.01358
; LINE_WIDTH: 0.332502
G1 X119.475 Y108.807 E.01172
; LINE_WIDTH: 0.281204
G3 X121.931 Y108.806 I1.247 J39.099 E.0604
; LINE_WIDTH: 0.325682
G1 X122.238 Y108.822 E.00908
; LINE_WIDTH: 0.357552
G1 X122.546 Y108.838 E.01016
; LINE_WIDTH: 0.386107
G1 X122.661 Y108.846 E.0042
; WIPE_START
G1 X122.546 Y108.838 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X116.032 Y112.815 Z2.697 F30000
G1 X107.182 Y118.22 Z2.697
G1 Z2.297
G1 E.8 F1800
; LINE_WIDTH: 0.53022
G1 F10335.399
G1 X106.989 Y118.348 E.01202
G3 X106.58 Y118.328 I-.171 J-.713 E.02161
G1 X106.581 Y119.303 E.0507
G1 X106.759 Y119.212 E.0104
G1 X106.847 Y119.252 E.00498
G2 X107.163 Y118.277 I-168.422 J-55.274 E.05331
G1 X106.849 Y117.833 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F12450.724
G1 X106.938 Y117.614 E.0102
G3 X107.549 Y116.364 I14.523 J6.322 E.06013
G1 X106.721 Y115.536 E.05056
G2 X106.579 Y116.307 I3.964 J1.127 E.0339
G1 X114.338 Y108.548 E.47393
G3 X115.013 Y108.477 I.888 J5.151 E.02938
G1 X115.885 Y109.348 E.05321
G3 X117.448 Y108.898 I4.28 J11.942 E.07032
G1 X108.456 Y111.893 F30000
G1 F12450.724
G3 X109.583 Y110.722 I8.097 J6.659 E.07029
G1 X110.983 Y112.122 E.08558
; WIPE_START
G1 X109.583 Y110.722 E-.75287
G1 X109.57 Y110.735 E-.00714
; WIPE_END
G1 E-.04 F1800
G1 X107.434 Y118.063 Z2.697 F30000
G1 X106.888 Y119.935 Z2.697
G1 Z2.297
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.5317
G1 F10303.113
G1 X106.589 Y120.141 E.01896
; LINE_WIDTH: 0.523305
G1 F10489.006
G1 X106.569 Y120.322 E.0093
; LINE_WIDTH: 0.483786
G1 F11462.653
G1 X106.549 Y120.502 E.00851
; LINE_WIDTH: 0.443438
G1 F12662.73
G1 X106.529 Y120.69 E.00802
; LINE_WIDTH: 0.405426
G1 F14048.348
G1 X106.511 Y120.888 E.00762
; LINE_WIDTH: 0.370274
G1 F15000
G1 X106.493 Y121.086 E.00685
; LINE_WIDTH: 0.334647
G1 X106.475 Y121.289 E.00623
; LINE_WIDTH: 0.296604
G1 X106.455 Y121.586 E.00782
; LINE_WIDTH: 0.256142
G1 X106.435 Y121.887 E.00658
; LINE_WIDTH: 0.221946
G1 X106.421 Y122.184 E.00538
; LINE_WIDTH: 0.193988
G1 X106.407 Y122.484 E.0045
; LINE_WIDTH: 0.154195
G1 X106.389 Y123.674 E.01261
G1 X106.398 Y124.273 E.00634
; LINE_WIDTH: 0.183275
G1 X106.42 Y124.87 E.00824
; LINE_WIDTH: 0.222099
G1 X106.437 Y125.167 E.00538
; LINE_WIDTH: 0.256415
G1 X106.454 Y125.469 E.00661
; LINE_WIDTH: 0.297007
G1 X106.477 Y125.766 E.00785
; LINE_WIDTH: 0.343951
G1 X106.501 Y126.069 E.00959
; LINE_WIDTH: 0.387465
G1 F14814.319
G1 X106.521 Y126.268 E.00723
; LINE_WIDTH: 0.426762
G1 F13235.438
G1 X106.54 Y126.466 E.00809
; LINE_WIDTH: 0.466948
G1 F11934.674
G1 X106.561 Y126.673 E.00938
; LINE_WIDTH: 0.501847
G1 F10996.17
G1 X106.59 Y126.912 E.01176
; LINE_WIDTH: 0.530207
G1 F10335.693
G1 X106.618 Y127.15 E.01251
; WIPE_START
G1 X106.59 Y126.912 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X110.259 Y133.604 Z2.697 F30000
G1 X110.986 Y134.928 Z2.697
G1 Z2.297
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F12450.724
G1 X109.583 Y136.331 E.08571
G3 X108.457 Y135.159 I5.143 J-6.066 E.07034
G1 X117.443 Y138.154 F30000
G1 F12450.724
G1 X117.368 Y138.138 E.00332
G3 X115.877 Y137.712 I3.594 J-15.414 E.06701
G1 X115.02 Y138.57 E.05238
G3 X114.335 Y138.502 I.011 J-3.609 E.02975
G1 X106.585 Y130.752 E.47344
G2 X106.723 Y131.514 I4.219 J-.372 E.03351
G1 X107.548 Y130.69 E.05035
G1 X107.337 Y130.294 E.01936
G3 X106.848 Y129.221 I19.654 J-9.615 E.05098
; CHANGE_LAYER
; Z_HEIGHT: 2.57732
; LAYER_HEIGHT: 0.28
; WIPE_START
G1 F12450.724
G1 X107.337 Y130.294 E-.44839
G1 X107.548 Y130.69 E-.17028
G1 X107.285 Y130.953 E-.14133
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 15/33
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
G17
G3 Z2.697 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.191 Y138.267
G1 Z2.577
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X154.009 Y138.577 E.01475
G3 X152.558 Y139.316 I-1.453 J-1.057 E.06942
G1 X115.566 Y139.316 E1.51885
G3 X105.773 Y129.523 I.024 J-9.817 E.6312
G1 X105.773 Y117.529 E.49246
G3 X115.566 Y107.736 I9.797 J.004 E.63155
G1 X152.722 Y107.745 E1.5256
G3 X154.353 Y109.532 I-.164 J1.787 E.10902
G1 X154.353 Y137.521 E1.14921
G3 X154.215 Y138.212 I-1.797 J-.001 E.02914
; WIPE_START
M204 S10000
G1 X154.009 Y138.577 E-.15913
G1 X153.761 Y138.856 E-.14207
G1 X153.458 Y139.076 E-.14217
G1 X153.116 Y139.228 E-.14221
G1 X152.75 Y139.306 E-.14217
G1 X152.666 Y139.311 E-.03226
; WIPE_END
G1 E-.04 F1800
G1 X152.083 Y131.7 Z2.977 F30000
G1 X150.305 Y108.47 Z2.977
G1 Z2.577
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F12090.657
G1 X150.275 Y108.485 E.00148
G2 X151.828 Y108.388 I.907 J2.042 E.55371
G1 X151.536 Y108.317 E.01333
G1 X151.561 Y108.111 E.00924
G3 X152.711 Y108.12 I.487 J11.901 E.05118
G3 X153.978 Y109.542 I-.171 J1.428 E.09261
G1 X153.978 Y137.511 E1.24412
G3 X152.548 Y138.941 I-1.422 J.009 E.10013
G1 X151.572 Y138.941 E.04338
G1 X151.553 Y138.728 E.00952
G2 X150.396 Y138.625 I-.386 J-2.2 E.57208
G2 X150.796 Y138.728 I.635 J-1.625 E.01841
G1 X150.777 Y138.941 E.00952
G1 X115.571 Y138.941 E1.56602
G3 X106.148 Y129.519 I.019 J-9.441 E.65802
G1 X106.148 Y117.534 E.53312
G3 X115.571 Y108.111 I9.422 J-.001 E.65839
G1 X150.788 Y108.111 E1.56654
G1 X150.813 Y108.317 E.00924
G1 X150.642 Y108.359 E.0078
G1 X150.362 Y108.451 E.01313
; WIPE_START
G1 X150.275 Y108.485 E-.03534
G1 X150.037 Y108.601 E-.10058
G1 X149.818 Y108.749 E-.10067
G1 X149.617 Y108.922 E-.10068
G1 X149.438 Y109.118 E-.10067
G1 X149.284 Y109.333 E-.10067
G1 X149.156 Y109.565 E-.10065
G1 X149.056 Y109.81 E-.10069
G1 X149.042 Y109.861 E-.02005
; WIPE_END
G1 E-.04 F1800
G1 X144.009 Y115.599 Z2.977 F30000
G1 X125.951 Y136.184 Z2.977
G1 Z2.577
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.463 Y136.39 E.02176
G3 X120.572 Y109.819 I-4.74 J-12.863 E1.96083
G3 X123.545 Y110.112 I-.055 J15.795 E.12283
G3 X126.516 Y135.952 I-2.822 J13.415 E1.40606
G1 X126.006 Y136.161 E.02262
M204 S10000
G1 X126.081 Y136.547 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F12090.657
G1 X125.591 Y136.737 E.02338
G3 X120.565 Y109.444 I-4.878 J-13.211 E2.18287
G3 X124.049 Y109.844 I.137 J14.18 E.15639
G3 X126.136 Y136.522 I-3.335 J13.682 E1.57054
; WIPE_START
G1 X125.591 Y136.737 E-.22251
G1 X125.038 Y136.931 E-.22274
G1 X124.476 Y137.099 E-.22274
G1 X124.242 Y137.159 E-.09201
; WIPE_END
G1 E-.04 F1800
G1 X129.422 Y131.553 Z2.977 F30000
G1 X150.423 Y108.825 Z2.977
G1 Z2.577
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.425 Y108.824 E.00007
G3 X151.064 Y108.669 I.75 J1.701 E.02717
G3 X151.386 Y108.681 I.11 J1.356 E.01325
G1 X151.504 Y108.695 E.00486
G3 X150.229 Y108.925 I-.329 J1.83 E.42531
G1 X150.37 Y108.852 E.00652
; WIPE_START
M204 S10000
G1 X150.425 Y108.824 E-.02342
G1 X150.631 Y108.747 E-.08373
G1 X150.845 Y108.695 E-.08376
G1 X151.064 Y108.669 E-.08379
G1 X151.386 Y108.681 E-.12235
G1 X151.504 Y108.695 E-.04498
G1 X151.718 Y108.747 E-.08377
G1 X151.924 Y108.824 E-.08373
G1 X152.121 Y108.924 E-.08377
G1 X152.266 Y109.023 E-.06669
; WIPE_END
G1 E-.04 F1800
G1 X152.412 Y116.654 Z2.977 F30000
G1 X152.807 Y137.419 Z2.977
G1 Z2.577
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.802 Y137.426 E.00036
G3 X151.064 Y134.672 I-1.627 J-.899 E.3166
G1 X151.285 Y134.672 E.00905
G3 X152.896 Y137.227 I-.11 J1.855 E.14482
G1 X152.833 Y137.365 E.00623
M204 S10000
G1 X153.596 Y137.523 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.45498
G1 F11938.186
G1 X153.568 Y137.632 E.00508
; LINE_WIDTH: 0.501045
G1 F10691.047
G3 X153.511 Y137.802 I-1.648 J-.456 E.009
; LINE_WIDTH: 0.547359
G1 F9674.879
G1 X153.5 Y137.831 E.00175
G3 X153.129 Y138.335 I-1.359 J-.61 E.03506
; LINE_WIDTH: 0.492032
G1 F10914.132
G3 X152.563 Y138.745 I-4.183 J-5.173 E.03444
G1 X153.596 Y137.523 F30000
; LINE_WIDTH: 0.429329
G1 F12767.517
G1 X153.601 Y137.501 E.00093
; LINE_WIDTH: 0.401967
G1 F13789.349
G1 X153.624 Y137.357 E.0057
; LINE_WIDTH: 0.354563
G1 F15000
G1 X153.648 Y137.213 E.0049
; LINE_WIDTH: 0.313303
G1 X153.665 Y137.053 E.00465
; LINE_WIDTH: 0.281617
G1 X153.68 Y136.909 E.00366
; LINE_WIDTH: 0.247815
G2 X153.694 Y136.609 I-5.117 J-.384 E.00644
G1 X153.69 Y136.31 E.0064
; LINE_WIDTH: 0.268977
G1 X153.668 Y136.011 E.00715
; LINE_WIDTH: 0.311556
G1 X153.647 Y135.853 E.00457
; LINE_WIDTH: 0.352006
G1 X153.628 Y135.709 E.00484
; LINE_WIDTH: 0.392045
G1 F14201.5
G2 X153.59 Y135.512 I-3.333 J.538 E.00762
; LINE_WIDTH: 0.426711
G1 F12858.708
G1 X153.555 Y135.333 E.00762
; WIPE_START
G1 X153.59 Y135.512 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.087 Y138.725 Z2.977 F30000
G1 Z2.577
G1 E.8 F1800
; LINE_WIDTH: 0.117784
G1 F15000
G3 X149.91 Y138.683 I.609 J-2.978 E.0012
G1 X149.852 Y138.594 F30000
; LINE_WIDTH: 0.131955
G1 F15000
G1 X150.052 Y138.746 E.00207
G1 X135.689 Y122.947 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F12090.657
G2 X135.539 Y121.326 I-13.189 J.398 E.07245
G1 X149.155 Y134.942 E.85655
G2 X148.828 Y135.466 I1.899 J1.553 E.02754
G1 X145.694 Y138.599 E.19711
G1 X145.136 Y138.599 E.02483
G1 X134.899 Y128.362 E.64398
G1 X135.025 Y127.984 E.01771
G2 X135.537 Y125.729 I-14.895 J-4.564 E.10299
G1 X149.149 Y112.116 E.85632
G3 X148.829 Y111.588 I2.074 J-1.62 E.02754
G1 X145.696 Y108.455 E.19709
G1 X145.134 Y108.455 E.02497
G1 X134.9 Y118.689 E.6438
G1 X134.722 Y118.192 E.0235
G2 X134.291 Y117.18 I-20.21 J8.009 E.04893
; WIPE_START
G1 X134.722 Y118.192 E-.41791
G1 X134.9 Y118.689 E-.20076
G1 X135.163 Y118.426 E-.14133
; WIPE_END
G1 E-.04 F1800
G1 X129.126 Y113.756 Z2.977 F30000
G1 X123.273 Y109.228 Z2.977
G1 Z2.577
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.566684
G1 F9305.811
G3 X135.147 Y121.869 I-2.537 J14.28 E1.07435
G1 X135.239 Y123.064 E.06928
G3 X123.079 Y137.864 I-14.533 J.455 E1.20849
G1 X123.02 Y137.875 F30000
; LINE_WIDTH: 0.5518
G1 F9587.51
G1 X122.881 Y137.875 E.0078
; LINE_WIDTH: 0.514142
G1 F10382.661
G1 X122.742 Y137.876 E.0072
; LINE_WIDTH: 0.476485
G1 F11321.634
G1 X122.603 Y137.876 E.0066
; LINE_WIDTH: 0.422771
G1 F12000
G1 X122.464 Y137.877 E.00575
G3 X118.675 Y137.856 I-1.809 J-15.712 E.15717
; LINE_WIDTH: 0.469932
G1 F11502.654
G1 X118.573 Y137.86 E.00476
; LINE_WIDTH: 0.508698
G1 F10508.652
G1 X118.471 Y137.863 E.00521
; LINE_WIDTH: 0.547465
G1 F9672.777
G1 X118.369 Y137.867 E.00566
G1 X118.428 Y137.939 E.00521
; LINE_WIDTH: 0.508698
G1 F10508.652
G1 X118.487 Y138.012 E.00479
; LINE_WIDTH: 0.469932
G1 F11502.654
G1 X118.546 Y138.085 E.00438
; LINE_WIDTH: 0.422472
G1 F12000
G1 X118.573 Y138.217 E.00559
G1 X118.551 Y138.567 E.01446
G1 X122.876 Y138.567 E.17878
G1 X122.875 Y138.08 E.02011
; LINE_WIDTH: 0.48292
G1 F11149.321
G1 X122.912 Y138.028 E.00309
; LINE_WIDTH: 0.518003
G1 F10295.112
G1 X122.949 Y137.976 E.00334
; LINE_WIDTH: 0.553087
G1 F9562.478
G1 X122.986 Y137.924 E.0036
G1 X118.919 Y138.22 F30000
; LINE_WIDTH: 0.371869
G1 F12000
G1 X119.351 Y138.241 E.01536
; LINE_WIDTH: 0.330548
G1 X119.782 Y138.262 E.01333
; LINE_WIDTH: 0.292212
G2 X121.624 Y138.262 I.933 J-33.181 E.0488
; LINE_WIDTH: 0.321299
G1 X121.931 Y138.25 E.00915
; LINE_WIDTH: 0.346639
G1 X122.238 Y138.237 E.01004
; LINE_WIDTH: 0.375908
G1 X122.448 Y138.224 E.00755
; WIPE_START
G1 X122.238 Y138.237 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X115.76 Y134.201 Z2.977 F30000
G1 X107.204 Y128.871 Z2.977
G1 Z2.577
G1 E.8 F1800
; LINE_WIDTH: 0.567867
G1 F9284.134
G2 X118.31 Y137.856 I13.521 J-5.357 E.86502
; WIPE_START
G1 X117.412 Y137.679 E-.34812
G1 X116.825 Y137.53 E-.22989
G1 X116.366 Y137.392 E-.18199
; WIPE_END
G1 E-.04 F1800
G1 X110.778 Y132.194 Z2.977 F30000
G1 X107.204 Y128.871 Z2.977
G1 Z2.577
G1 E.8 F1800
; LINE_WIDTH: 0.532876
G1 F9971.254
G3 X106.767 Y127.532 I32.96 J-11.515 E.076
G1 X106.585 Y127.554 E.00985
G1 X106.586 Y128.728 E.06332
G1 X106.966 Y128.698 E.02052
G3 X107.162 Y128.829 I-.083 J.338 E.01297
; WIPE_START
G1 X107.091 Y128.757 E-.03839
G1 X106.966 Y128.698 E-.05248
G1 X106.586 Y128.728 E-.14456
G1 X106.585 Y127.554 E-.44613
G1 X106.767 Y127.532 E-.06941
G1 X106.774 Y127.554 E-.00903
; WIPE_END
G1 E-.04 F1800
G1 X107.108 Y119.929 Z2.977 F30000
G1 X107.183 Y118.222 Z2.977
G1 Z2.577
G1 E.8 F1800
; LINE_WIDTH: 0.566901
G1 F9301.843
G3 X115.401 Y110.004 I13.529 J5.312 E.69129
G1 X116.532 Y109.608 E.06927
G3 X118.129 Y109.229 I4.228 J14.289 E.09494
G1 X123.273 Y109.228 F30000
; LINE_WIDTH: 0.544043
G1 F9741.166
G1 X123.212 Y109.171 E.00459
; LINE_WIDTH: 0.510433
G1 F10468.166
G1 X123.152 Y109.115 E.00427
; LINE_WIDTH: 0.475221
G1 F11356.099
G1 X123.113 Y108.988 E.0063
; LINE_WIDTH: 0.421561
G1 F12000
G3 X123.087 Y108.723 I.303 J-.163 E.01125
G1 X122.9 Y108.495 E.01219
G1 X118.52 Y108.496 E.1806
G1 X118.336 Y108.72 E.01198
G1 X118.331 Y109.011 E.012
; LINE_WIDTH: 0.487451
G1 F11031.117
G1 X118.26 Y109.115 E.00614
; LINE_WIDTH: 0.537236
G1 F9880.144
G1 X118.188 Y109.218 E.00686
; LINE_WIDTH: 0.53844
G1 F9855.272
G1 X118.377 Y109.213 E.01035
; LINE_WIDTH: 0.491064
G1 F10938.652
G1 X118.567 Y109.207 E.00932
; LINE_WIDTH: 0.421134
G1 F12000
G1 X118.756 Y109.202 E.00781
G3 X122.51 Y109.178 I1.965 J14.242 E.15505
; LINE_WIDTH: 0.438406
G1 X122.798 Y109.202 E.01248
; LINE_WIDTH: 0.475221
G1 F11356.099
G1 X123.086 Y109.226 E.0137
; LINE_WIDTH: 0.510433
G1 F10468.166
G1 X123.15 Y109.227 E.00326
; LINE_WIDTH: 0.544043
G1 F9741.166
G1 X123.213 Y109.227 E.0035
G1 X118.705 Y108.851 F30000
; LINE_WIDTH: 0.388059
G1 F12000
G1 X119.091 Y108.829 E.01447
; LINE_WIDTH: 0.342916
G3 X119.506 Y108.806 I.804 J10.766 E.01342
; LINE_WIDTH: 0.29314
G3 X121.931 Y108.806 I1.213 J33.841 E.06447
; LINE_WIDTH: 0.337914
G1 X122.238 Y108.822 E.00976
; LINE_WIDTH: 0.369804
G1 X122.546 Y108.838 E.01088
; LINE_WIDTH: 0.398138
G1 X122.658 Y108.846 E.00436
; WIPE_START
G1 X122.546 Y108.838 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X116.032 Y112.816 Z2.977 F30000
G1 X107.183 Y118.222 Z2.977
G1 Z2.577
M73 P68 R6
G1 E.8 F1800
; LINE_WIDTH: 0.534288
G1 F9941.56
G1 X106.991 Y118.35 E.0125
G3 X106.578 Y118.33 I-.172 J-.717 E.02264
G1 X106.579 Y119.498 E.06318
G1 X106.771 Y119.519 E.0104
G3 X107.164 Y118.279 I29.539 J8.699 E.07039
G1 X106.611 Y119.933 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.525511
G1 F10129.05
G1 X106.584 Y120.183 E.01333
; LINE_WIDTH: 0.488382
G1 F11007.141
G1 X106.557 Y120.432 E.01226
; LINE_WIDTH: 0.450672
G1 F12069.863
G1 X106.529 Y120.69 E.01153
; LINE_WIDTH: 0.413581
G1 F13336.3
G1 X106.511 Y120.888 E.00803
; LINE_WIDTH: 0.378432
G1 F14808.795
G1 X106.494 Y121.086 E.00723
; LINE_WIDTH: 0.342794
G1 F15000
G1 X106.475 Y121.29 E.0066
; LINE_WIDTH: 0.30475
G1 X106.455 Y121.586 E.0083
; LINE_WIDTH: 0.264303
G1 X106.435 Y121.887 E.00702
; LINE_WIDTH: 0.230107
G1 X106.421 Y122.184 E.00577
; LINE_WIDTH: 0.20213
G1 X106.407 Y122.484 E.00487
; LINE_WIDTH: 0.162337
G1 X106.389 Y123.674 E.01388
G1 X106.398 Y124.273 E.00698
; LINE_WIDTH: 0.19144
G1 X106.42 Y124.87 E.00896
; LINE_WIDTH: 0.230266
G1 X106.437 Y125.167 E.00577
; LINE_WIDTH: 0.264559
G1 X106.454 Y125.469 E.00705
; LINE_WIDTH: 0.30517
G1 X106.477 Y125.766 E.00833
; LINE_WIDTH: 0.352137
G1 X106.501 Y126.07 E.01015
; LINE_WIDTH: 0.395638
G1 F14049.438
G1 X106.521 Y126.268 E.00762
; LINE_WIDTH: 0.434914
G1 F12577.27
G1 X106.54 Y126.466 E.00851
; LINE_WIDTH: 0.475092
G1 F11359.619
G1 X106.561 Y126.673 E.00985
; LINE_WIDTH: 0.520445
G1 F10240.515
G1 X106.615 Y127.119 E.02358
G1 X106.848 Y129.221 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F12090.657
G1 X107.064 Y129.724 E.02437
G2 X107.548 Y130.69 I19.652 J-9.245 E.04805
G1 X106.721 Y131.516 E.05201
G3 X106.584 Y130.751 I3.937 J-1.1 E.03464
G1 X114.339 Y138.505 E.48781
G2 X115.017 Y138.573 I.69 J-3.513 E.03037
G1 X115.877 Y137.712 E.05413
G1 X116.106 Y137.791 E.01078
G2 X117.444 Y138.154 I5.612 J-18.061 E.06165
G1 X108.454 Y135.16 F30000
G1 F12090.657
G2 X109.575 Y136.338 I6.733 J-5.286 E.07246
G1 X110.986 Y134.928 E.08872
; WIPE_START
G1 X109.575 Y136.338 E-.75794
G1 X109.572 Y136.334 E-.00206
; WIPE_END
G1 E-.04 F1800
G1 X110.016 Y128.715 Z2.977 F30000
G1 X110.984 Y112.123 Z2.977
G1 Z2.577
G1 E.8 F1800
G1 F12090.657
G1 X109.575 Y110.714 E.08859
G2 X108.461 Y111.898 I5.156 J5.972 E.07243
G1 X117.449 Y108.898 F30000
G1 F12090.657
G1 X117.006 Y109.002 E.02023
G2 X115.885 Y109.348 I2.234 J9.219 E.0522
G1 X115.01 Y108.473 E.05506
G2 X114.339 Y108.547 I.185 J4.729 E.03006
G1 X106.576 Y116.31 E.48831
G3 X106.721 Y115.536 I6.472 J.813 E.03502
G1 X107.549 Y116.364 E.05207
G1 X107.454 Y116.536 E.00876
G2 X106.849 Y117.833 I14.107 J7.362 E.06367
; WIPE_START
G1 X107.454 Y116.536 E-.54372
G1 X107.549 Y116.364 E-.0748
G1 X107.286 Y116.101 E-.14148
; WIPE_END
G1 E-.04 F1800
G1 X114.887 Y115.408 Z2.977 F30000
G1 X149.278 Y112.273 Z2.977
G1 Z2.577
G1 E.8 F1800
G1 F12090.657
G2 X150.112 Y112.871 I2.547 J-2.672 E.04577
G1 X153.63 Y116.389 E.22129
G1 X153.629 Y115.312 E.0479
G1 X130.342 Y138.599 E1.46492
G1 X129.784 Y138.599 E.02483
G1 X127.876 Y136.691 E.12003
G1 X128.16 Y136.536 E.01439
G2 X132.115 Y133.254 I-7.536 J-13.106 E.22973
G1 X137.46 Y138.599 E.33624
G1 X138.018 Y138.599 E.02483
G1 X153.632 Y122.986 E.98219
G1 X153.632 Y124.067 E.04811
G1 X138.022 Y108.457 E.98197
G1 X137.456 Y108.458 E.02518
G1 X132.109 Y113.805 E.3364
G2 X127.878 Y110.359 I-11.212 J9.446 E.24412
G1 X129.778 Y108.46 E.1195
G1 X130.349 Y108.46 E.02539
G1 X153.634 Y131.746 E1.46484
G1 X153.634 Y130.659 E.04831
G1 X150.114 Y134.179 E.22143
G2 X149.282 Y134.784 I1.121 J2.417 E.04602
G1 X153.552 Y111.717 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.43604
G1 F12539.603
G2 X153.601 Y111.499 I-3.663 J-.932 E.0096
; LINE_WIDTH: 0.401937
G1 F13790.582
G1 X153.624 Y111.355 E.00569
; LINE_WIDTH: 0.354571
G1 F15000
G1 X153.648 Y111.211 E.0049
; LINE_WIDTH: 0.328739
G1 X153.65 Y111.195 E.00049
; LINE_WIDTH: 0.31161
G1 X153.665 Y111.051 E.00415
; LINE_WIDTH: 0.280385
G1 X153.681 Y110.894 E.00395
; LINE_WIDTH: 0.247451
G1 X153.689 Y110.296 E.01278
; LINE_WIDTH: 0.270824
G2 X153.666 Y109.995 I-5.02 J.228 E.00727
; LINE_WIDTH: 0.313343
G1 X153.647 Y109.851 E.0042
; LINE_WIDTH: 0.35456
G1 X153.625 Y109.688 E.00551
; LINE_WIDTH: 0.39073
G1 F14257.994
G1 X153.611 Y109.62 E.00262
; LINE_WIDTH: 0.417329
G1 F13196.392
G1 X153.598 Y109.552 E.00283
; LINE_WIDTH: 0.456009
G1 F11907.156
G2 X153.564 Y109.402 I-1.44 J.251 E.00696
; LINE_WIDTH: 0.493355
G1 F10880.793
G1 X153.536 Y109.319 E.0043
; LINE_WIDTH: 0.533988
G1 F9947.863
G2 X153.43 Y109.086 I-1.949 J.747 E.0139
; LINE_WIDTH: 0.552932
G1 F9565.485
G2 X153.141 Y108.731 I-1.199 J.682 E.02582
; LINE_WIDTH: 0.508294
G1 F10518.136
G2 X153.006 Y108.622 I-.986 J1.087 E.00889
; LINE_WIDTH: 0.455831
G1 F11912.521
G2 X152.481 Y108.306 I-3.263 J4.824 E.02767
; WIPE_START
G1 X153.006 Y108.622 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.019 Y108.306 Z2.977 F30000
G1 Z2.577
G1 E.8 F1800
; LINE_WIDTH: 0.170902
G1 F15000
G1 X149.909 Y108.39 E.00175
; LINE_WIDTH: 0.138615
G1 X149.732 Y108.543 E.0021
; CHANGE_LAYER
; Z_HEIGHT: 2.84732
; LAYER_HEIGHT: 0.27
; WIPE_START
G1 F15000
G1 X149.909 Y108.39 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 16/33
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
G17
G3 Z2.977 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.188 Y138.272
G1 Z2.847
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X154.009 Y138.577 E.0141
G3 X152.558 Y139.316 I-1.453 J-1.057 E.06734
G1 X115.566 Y139.316 E1.47333
G3 X105.773 Y129.523 I.004 J-9.797 E.61262
G1 X105.773 Y117.529 E.47771
G3 X115.566 Y107.736 I9.799 J.006 E.61258
G1 X152.731 Y107.745 E1.48025
G3 X154.353 Y109.532 I-.195 J1.806 E.1051
G1 X154.353 Y137.521 E1.11477
G3 X154.212 Y138.217 I-1.797 J-.001 E.02848
; WIPE_START
M204 S10000
G1 X154.009 Y138.577 E-.1571
G1 X153.774 Y138.843 E-.13484
G1 X153.614 Y138.975 E-.07879
G1 X153.291 Y139.161 E-.14183
G1 X152.935 Y139.277 E-.14212
G1 X152.66 Y139.306 E-.10533
; WIPE_END
G1 E-.04 F1800
G1 X152.066 Y131.696 Z3.247 F30000
G1 X150.254 Y108.488 Z3.247
G1 Z2.847
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F12469.826
G1 X150.036 Y108.599 E.01056
G2 X151.559 Y108.321 I1.138 J1.925 E.5379
G1 X151.584 Y108.113 E.00901
G3 X152.694 Y108.121 I.482 J10.586 E.0479
G3 X153.976 Y109.542 I-.152 J1.426 E.09038
G1 X153.976 Y137.511 E1.20628
G3 X152.548 Y138.939 I-1.42 J.009 E.09695
G1 X151.603 Y138.939 E.04074
G1 X151.584 Y138.725 E.00928
G2 X150.765 Y138.725 I-.409 J-2.196 E.56991
G1 X150.746 Y138.939 E.00928
G1 X115.571 Y138.939 E1.51706
G3 X106.15 Y129.518 I-.001 J-9.42 E.63827
G1 X106.15 Y117.534 E.51686
G3 X115.571 Y108.113 I9.422 J.001 E.63822
G1 X150.765 Y108.113 E1.51791
G1 X150.79 Y108.321 E.00901
G2 X150.308 Y108.462 I.384 J2.203 E.0217
; WIPE_START
G1 X150.036 Y108.599 E-.11575
G1 X149.816 Y108.747 E-.10074
G1 X149.616 Y108.921 E-.10079
G1 X149.437 Y109.116 E-.10078
G1 X149.282 Y109.332 E-.10076
G1 X149.154 Y109.564 E-.10074
G1 X149.054 Y109.809 E-.10075
G1 X149.027 Y109.91 E-.03969
; WIPE_END
G1 E-.04 F1800
G1 X143.991 Y115.646 Z3.247 F30000
G1 X125.967 Y136.177 Z3.247
G1 Z2.847
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.462 Y136.389 E.02181
G3 X120.487 Y109.821 I-4.74 J-12.862 E1.89859
G3 X124.65 Y110.394 I.217 J13.845 E.16805
G3 X126.515 Y135.95 I-3.928 J13.133 E1.31834
G1 X126.023 Y136.154 E.02123
M204 S10000
G1 X126.101 Y136.542 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F12469.826
G1 X125.592 Y136.739 E.02356
G3 X115.89 Y110.294 I-4.878 J-13.212 E1.91087
G3 X120.479 Y109.444 I4.825 J13.242 E.20221
G3 X126.156 Y136.516 I.234 J14.082 E1.67745
; WIPE_START
G1 X125.592 Y136.739 E-.23033
G1 X125.039 Y136.933 E-.22276
G1 X124.477 Y137.101 E-.22279
G1 X124.263 Y137.156 E-.08413
; WIPE_END
G1 E-.04 F1800
G1 X129.44 Y131.549 Z3.247 F30000
G1 X150.423 Y108.824 Z3.247
G1 Z2.847
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.425 Y108.824 E.00005
G3 X151.064 Y108.669 I.75 J1.702 E.02635
G3 X151.374 Y108.68 I.11 J1.306 E.01238
G1 X151.504 Y108.695 E.00519
G3 X150.228 Y108.925 I-.329 J1.83 E.41271
G1 X150.37 Y108.852 E.00634
; WIPE_START
M204 S10000
G1 X150.425 Y108.824 E-.02331
G1 X150.631 Y108.747 E-.08373
G1 X150.845 Y108.695 E-.08377
G1 X151.064 Y108.669 E-.08378
G1 X151.374 Y108.68 E-.11782
G1 X151.504 Y108.695 E-.04952
G1 X151.718 Y108.747 E-.08376
G1 X151.924 Y108.824 E-.08375
G1 X152.121 Y108.924 E-.08375
G1 X152.266 Y109.023 E-.0668
; WIPE_END
G1 E-.04 F1800
G1 X152.412 Y116.654 Z3.247 F30000
G1 X152.808 Y137.417 Z3.247
G1 Z2.847
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.803 Y137.427 E.00043
G3 X151.064 Y134.672 I-1.629 J-.898 E.30743
G3 X151.374 Y134.682 I.11 J1.308 E.01238
G1 X151.504 Y134.698 E.00519
G3 X152.898 Y137.228 I-.329 J1.831 E.13175
G1 X152.834 Y137.363 E.00596
M204 S10000
G1 X153.596 Y137.522 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.420736
G1 F13475.679
G1 X153.601 Y137.501 E.00087
; LINE_WIDTH: 0.393392
G1 F14574.126
G1 X153.624 Y137.357 E.0054
; LINE_WIDTH: 0.345945
G1 F15000
G1 X153.648 Y137.213 E.00463
; LINE_WIDTH: 0.304732
G1 X153.665 Y137.053 E.00436
; LINE_WIDTH: 0.273037
G1 X153.68 Y136.909 E.00343
; LINE_WIDTH: 0.23924
G1 X153.69 Y136.31 E.01195
; LINE_WIDTH: 0.260434
G1 X153.668 Y136.011 E.00668
; LINE_WIDTH: 0.303001
G1 X153.647 Y135.853 E.00429
; LINE_WIDTH: 0.343454
G1 X153.628 Y135.709 E.00457
; LINE_WIDTH: 0.384815
G1 F14956.576
G2 X153.588 Y135.505 I-3.537 J.575 E.00748
; LINE_WIDTH: 0.422384
G1 F13414.752
G1 X153.552 Y135.319 E.0076
G1 X153.596 Y137.522 F30000
; LINE_WIDTH: 0.446394
G1 F12585.59
G1 X153.568 Y137.632 E.00483
; LINE_WIDTH: 0.495017
G1 F11185.484
G3 X153.501 Y137.827 I-2.269 J-.672 E.00991
; LINE_WIDTH: 0.539627
G1 F10149.572
G1 X153.498 Y137.835 E.00046
G3 X153.129 Y138.335 I-1.354 J-.611 E.03316
; LINE_WIDTH: 0.483473
G1 F11488.917
G3 X152.568 Y138.742 I-4.161 J-5.147 E.03245
; WIPE_START
G1 X153.129 Y138.335 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.042 Y138.743 Z3.247 F30000
G1 Z2.847
G1 E.8 F1800
; LINE_WIDTH: 0.128883
G1 F15000
G1 X149.85 Y138.596 E.00189
; WIPE_START
G1 X150.042 Y138.743 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.281 Y134.781 Z3.247 F30000
G1 Z2.847
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F12469.826
G3 X150.121 Y134.173 I2.531 J2.612 E.04488
G1 X153.633 Y130.66 E.21424
G1 X153.633 Y131.744 E.04676
G1 X130.345 Y108.456 E1.42044
G1 X129.781 Y108.456 E.02432
G1 X127.463 Y110.775 E.14142
G2 X123.613 Y109.4 I-6.639 J12.513 E.17693
G1 X122.669 Y108.456 E.05756
G1 X122.105 Y108.456 E.02432
G1 X121.445 Y109.117 E.04028
G2 X116.323 Y109.786 I-.73 J14.338 E.22399
G1 X115.02 Y108.483 E.07951
G2 X114.335 Y108.551 I.012 J3.612 E.02972
G1 X106.58 Y116.306 E.47305
G3 X106.724 Y115.539 I6.48 J.819 E.03371
G1 X107.96 Y116.775 E.07543
G3 X111.382 Y112.521 I12.851 J6.832 E.23687
G1 X109.576 Y110.715 E.11013
G2 X108.456 Y111.895 I6.435 J7.233 E.07023
G1 X106.615 Y119.897 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.523395
G1 F10503.521
M73 P68 R5
G1 X106.587 Y120.159 E.01347
; LINE_WIDTH: 0.48367
G1 F11483.614
G1 X106.558 Y120.42 E.01232
; LINE_WIDTH: 0.443364
G1 F12684.538
G1 X106.529 Y120.69 E.01148
; LINE_WIDTH: 0.405003
G1 F14086.54
G1 X106.511 Y120.888 E.0076
; LINE_WIDTH: 0.369867
G1 F15000
G1 X106.493 Y121.086 E.00683
; LINE_WIDTH: 0.334255
G1 X106.475 Y121.289 E.00621
; LINE_WIDTH: 0.296212
G1 X106.455 Y121.586 E.0078
; LINE_WIDTH: 0.255742
G1 X106.435 Y121.887 E.00656
; LINE_WIDTH: 0.221539
G1 X106.421 Y122.184 E.00536
; LINE_WIDTH: 0.193583
G1 X106.407 Y122.484 E.00448
; LINE_WIDTH: 0.153791
G1 X106.389 Y123.674 E.01255
G1 X106.398 Y124.273 E.00631
; LINE_WIDTH: 0.182871
G1 X106.42 Y124.87 E.00821
; LINE_WIDTH: 0.221693
G1 X106.437 Y125.167 E.00536
; LINE_WIDTH: 0.25601
G1 X106.454 Y125.469 E.00659
; LINE_WIDTH: 0.296625
G1 X106.477 Y125.766 E.00783
; LINE_WIDTH: 0.343581
G1 X106.501 Y126.07 E.00957
; LINE_WIDTH: 0.387075
G1 F14853.864
G1 X106.521 Y126.268 E.00721
; LINE_WIDTH: 0.426366
G1 F13269.754
G1 X106.54 Y126.466 E.00807
; LINE_WIDTH: 0.466545
G1 F11964.911
G1 X106.561 Y126.673 E.00935
; LINE_WIDTH: 0.50152
G1 F11021.505
G1 X106.59 Y126.912 E.01177
; LINE_WIDTH: 0.530055
G1 F10355.349
G1 X106.619 Y127.152 E.01253
G1 X108.463 Y135.153 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F12469.826
G2 X109.577 Y136.336 I7.899 J-6.326 E.07017
G1 X111.383 Y134.531 E.11014
G3 X107.962 Y130.276 I9.334 J-11.007 E.2369
G1 X106.724 Y131.514 E.07554
G3 X106.579 Y130.746 I6.366 J-1.593 E.03371
G1 X114.343 Y138.51 E.47355
G1 X115.015 Y138.574 E.02911
G1 X116.319 Y137.27 E.07953
G2 X121.445 Y137.936 I4.401 J-13.835 E.22411
G1 X122.097 Y138.588 E.03977
G1 X122.678 Y138.588 E.02507
G1 X123.604 Y137.661 E.05652
G2 X127.463 Y136.278 I-2.916 J-14.213 E.17738
G1 X129.775 Y138.59 E.141
G1 X130.351 Y138.59 E.02486
G1 X153.633 Y115.308 E1.42006
G1 X153.633 Y116.392 E.04676
G1 X150.118 Y112.877 E.21443
G3 X149.285 Y112.268 I2.039 J-3.662 E.04461
; WIPE_START
G1 X149.727 Y112.665 E-.22573
G1 X150.118 Y112.877 E-.16891
G1 X150.798 Y113.557 E-.36536
; WIPE_END
G1 E-.04 F1800
G1 X149.73 Y108.541 Z3.247 F30000
G1 Z2.847
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.136532
G1 F15000
G1 X149.908 Y108.387 E.00203
; LINE_WIDTH: 0.167547
G1 X150.01 Y108.309 E.00155
; WIPE_START
G1 X149.908 Y108.387 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X152.486 Y108.309 Z3.247 F30000
G1 Z2.847
G1 E.8 F1800
; LINE_WIDTH: 0.447293
G1 F12556.515
G3 X153.006 Y108.622 I-2.72 J5.104 E.02599
; LINE_WIDTH: 0.499752
G1 F11065.6
G3 X153.141 Y108.731 I-.856 J1.202 E.00843
; LINE_WIDTH: 0.544366
G1 F10050.688
G3 X153.43 Y109.086 I-.911 J1.037 E.02459
; LINE_WIDTH: 0.524501
G1 F10478.614
G3 X153.538 Y109.324 I-1.769 J.946 E.01343
; LINE_WIDTH: 0.484007
G1 F11474.537
G1 X153.564 Y109.402 E.00385
; LINE_WIDTH: 0.447467
G1 F12550.921
G3 X153.598 Y109.552 I-1.422 J.405 E.00661
; LINE_WIDTH: 0.408732
G1 F13936.823
G1 X153.611 Y109.62 E.00268
; LINE_WIDTH: 0.382111
G1 F15000
G1 X153.625 Y109.688 E.00248
; LINE_WIDTH: 0.345971
G1 X153.647 Y109.851 E.00519
; LINE_WIDTH: 0.304756
G1 X153.666 Y109.995 E.00395
; LINE_WIDTH: 0.262235
G3 X153.689 Y110.297 I-5.002 J.53 E.0068
; LINE_WIDTH: 0.238888
G1 X153.681 Y110.895 E.0119
; LINE_WIDTH: 0.271839
G1 X153.665 Y111.051 E.00369
; LINE_WIDTH: 0.303069
G1 X153.65 Y111.195 E.00391
; LINE_WIDTH: 0.320178
G1 X153.648 Y111.21 E.00045
; LINE_WIDTH: 0.345984
G1 X153.624 Y111.355 E.00463
; LINE_WIDTH: 0.393427
G1 F14572.615
G1 X153.601 Y111.499 E.0054
; LINE_WIDTH: 0.430654
G1 F13117.1
G3 X153.548 Y111.733 I-3.932 J-.756 E.00982
G1 X132.7 Y131.559 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F12469.826
G3 X131.718 Y132.857 I-23.47 J-16.752 E.0702
G1 X137.453 Y138.592 E.34984
G1 X138.025 Y138.592 E.02466
G1 X153.633 Y122.984 E.95201
G1 X153.633 Y124.068 E.04676
G1 X138.021 Y108.456 E.95225
G1 X137.457 Y108.456 E.02432
G1 X131.718 Y114.195 E.35003
G3 X134.452 Y119.137 I-11.416 J9.543 E.24507
G1 X145.133 Y108.456 E.65146
G1 X145.697 Y108.456 E.02432
G1 X148.823 Y111.582 E.19065
G2 X149.15 Y112.116 I2.162 J-.959 E.02707
G1 X134.848 Y126.418 E.87235
G3 X134.457 Y127.92 I-27.369 J-6.329 E.06694
G1 X145.132 Y138.595 E.65111
G1 X145.699 Y138.595 E.02446
G1 X148.822 Y135.471 E.19053
G3 X149.147 Y134.934 I2.65 J1.234 E.02711
G1 X134.85 Y120.637 E.872
G3 X135.084 Y122.248 I-27.435 J4.8 E.0702
; CHANGE_LAYER
; Z_HEIGHT: 3.08881
; LAYER_HEIGHT: 0.241499
; WIPE_START
G1 F12469.826
G1 X134.85 Y120.637 E-.61839
G1 X135.114 Y120.901 E-.14161
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 17/33
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
G17
G3 Z3.247 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.186 Y138.276
G1 Z3.089
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X154.009 Y138.577 E.01264
G3 X152.558 Y139.316 I-1.453 J-1.057 E.06126
G1 X115.566 Y139.316 E1.34007
G3 X105.773 Y129.523 I.004 J-9.797 E.55721
G1 X105.773 Y117.529 E.4345
G3 X115.566 Y107.736 I9.797 J.004 E.55721
G1 X152.748 Y107.746 E1.34698
G3 X154.353 Y109.532 I-.214 J1.806 E.095
G1 X154.353 Y137.521 E1.01394
G3 X154.211 Y138.221 I-1.797 J-.001 E.02607
; WIPE_START
M204 S10000
G1 X154.009 Y138.577 E-.15523
G1 X153.761 Y138.856 E-.14214
G1 X153.458 Y139.076 E-.14218
G1 X153.116 Y139.228 E-.14215
G1 X152.75 Y139.306 E-.1422
G1 X152.655 Y139.311 E-.0361
; WIPE_END
G1 E-.04 F1800
G1 X152.531 Y131.68 Z3.489 F30000
G1 X152.217 Y112.512 Z3.489
G1 Z3.089
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13727.299
G1 X152.427 Y112.386 E.00958
G2 X151.624 Y108.33 I-1.252 J-1.859 E.20615
G1 X151.649 Y108.119 E.00831
G3 X152.708 Y108.128 I.449 J10.108 E.04153
G3 X153.97 Y109.542 I-.168 J1.42 E.08116
G1 X153.97 Y137.511 E1.09578
G3 X152.548 Y138.933 I-1.414 J.009 E.08769
G1 X151.668 Y138.933 E.03445
G1 X151.638 Y138.73 E.00807
G2 X149.709 Y138.229 I-.459 J-2.197 E.47152
G1 X149.84 Y138.328 E.00643
G2 X150.711 Y138.73 I1.395 J-1.882 E.03785
G1 X150.681 Y138.933 E.00807
G1 X115.571 Y138.933 E1.37556
G3 X106.156 Y129.519 I-.001 J-9.414 E.57939
G1 X106.156 Y117.534 E.46954
G3 X115.571 Y108.119 I9.414 J-.001 E.57939
G1 X150.7 Y108.119 E1.37632
G1 X150.725 Y108.33 E.00831
G2 X152.163 Y112.538 I.449 J2.196 E.29833
; WIPE_START
G1 X152.427 Y112.386 E-.11566
G1 X152.64 Y112.226 E-.10103
G1 X152.83 Y112.041 E-.10104
G1 X152.998 Y111.835 E-.10105
G1 X153.14 Y111.61 E-.10101
G1 X153.254 Y111.37 E-.10104
G1 X153.339 Y111.118 E-.10104
G1 X153.36 Y111.02 E-.03813
; WIPE_END
G1 E-.04 F1800
G1 X147.739 Y116.183 Z3.489 F30000
G1 X125.982 Y136.171 Z3.489
M73 P69 R5
G1 Z3.089
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.463 Y136.39 E.02041
G3 X120.407 Y109.823 I-4.74 J-12.863 E1.72402
G3 X124.651 Y110.394 I.298 J13.836 E.15575
G3 X126.516 Y135.951 I-3.928 J13.133 E1.19914
G1 X126.037 Y136.148 E.01874
M204 S10000
G1 X126.12 Y136.541 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F13727.299
G1 X125.594 Y136.744 E.02213
G3 X120.399 Y109.44 I-4.88 J-13.218 E1.91721
G3 X123.889 Y109.799 I.314 J14.089 E.13782
G3 X134.161 Y119.32 I-3.16 J13.711 E.57435
G3 X126.175 Y136.515 I-13.448 J4.207 E.81478
; WIPE_START
G1 X125.594 Y136.744 E-.23737
G1 X125.041 Y136.939 E-.22277
G1 X124.479 Y137.107 E-.22291
G1 X124.282 Y137.157 E-.07695
; WIPE_END
G1 E-.04 F1800
G1 X129.955 Y132.05 Z3.489 F30000
G1 X152.023 Y112.18 Z3.489
G1 Z3.089
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G3 X151.064 Y108.669 I-.849 J-1.654 E.23955
G3 X151.363 Y108.679 I.11 J1.259 E.01086
G1 X151.504 Y108.695 E.00512
G3 X152.076 Y112.152 I-.329 J1.83 E.16554
; WIPE_START
M204 S10000
G1 X151.822 Y112.27 E-.10643
G1 X151.612 Y112.335 E-.08374
G1 X151.394 Y112.374 E-.08379
G1 X151.175 Y112.387 E-.08374
G1 X150.955 Y112.374 E-.08374
G1 X150.737 Y112.335 E-.0838
G1 X150.527 Y112.27 E-.08373
G1 X150.325 Y112.181 E-.08375
G1 X150.173 Y112.091 E-.06728
; WIPE_END
G1 E-.04 F1800
G1 X150.963 Y119.683 Z3.489 F30000
G1 X152.809 Y137.415 Z3.489
G1 Z3.089
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.802 Y137.426 E.00047
G3 X151.064 Y134.672 I-1.627 J-.899 E.27934
G3 X151.363 Y134.681 I.11 J1.26 E.01086
G1 X151.504 Y134.698 E.00512
G3 X152.897 Y137.227 I-.329 J1.829 E.11979
G1 X152.834 Y137.361 E.00534
M204 S10000
G1 X153.596 Y137.522 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.396254
G1 F15000
G1 X153.6 Y137.502 E.0007
; LINE_WIDTH: 0.368991
G1 X153.624 Y137.357 E.00459
; LINE_WIDTH: 0.321358
G1 X153.648 Y137.212 E.00388
; LINE_WIDTH: 0.28019
G1 X153.665 Y137.053 E.0036
; LINE_WIDTH: 0.248498
G1 X153.68 Y136.908 E.00282
; LINE_WIDTH: 0.214735
G1 X153.69 Y136.309 E.0096
; LINE_WIDTH: 0.236045
G1 X153.668 Y136.01 E.00543
; LINE_WIDTH: 0.278607
G1 X153.647 Y135.853 E.00354
; LINE_WIDTH: 0.319077
G1 X153.628 Y135.708 E.00384
; LINE_WIDTH: 0.364234
G2 X153.585 Y135.484 I-3.755 J.608 E.007
; LINE_WIDTH: 0.41006
G1 X153.544 Y135.278 E.00742
G1 X153.596 Y137.522 F30000
; LINE_WIDTH: 0.421801
G1 F14773.585
G1 X153.568 Y137.632 E.00413
; LINE_WIDTH: 0.468084
G1 F13130.941
G3 X153.511 Y137.802 I-1.66 J-.459 E.00736
; LINE_WIDTH: 0.514366
G1 F11817.037
G1 X153.5 Y137.831 E.0014
G3 X153.13 Y138.335 I-1.36 J-.61 E.02868
; LINE_WIDTH: 0.459112
G1 F13420.19
G3 X152.582 Y138.732 I-4.065 J-5.027 E.02712
; WIPE_START
G1 X153.13 Y138.335 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.039 Y138.714 Z3.489 F30000
G1 Z3.089
G1 E.8 F1800
; LINE_WIDTH: 0.120008
G1 F15000
G3 X149.844 Y138.604 I.039 J-.295 E.00154
G1 X135.093 Y122.259 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F13727.299
G2 X134.861 Y120.648 I-28.342 J3.259 E.06377
G1 X149.141 Y134.928 E.79119
G2 X148.807 Y135.486 I2.249 J1.722 E.02552
G1 X145.705 Y138.588 E.17187
G1 X145.125 Y138.588 E.02274
G1 X134.463 Y127.926 E.59074
G2 X134.858 Y126.407 I-26.364 J-7.672 E.0615
G1 X149.141 Y112.124 E.79138
G3 X148.805 Y111.565 I2.112 J-1.65 E.02564
G1 X145.707 Y108.466 E.17167
G1 X145.123 Y108.466 E.02287
G1 X134.46 Y119.129 E.59079
G2 X131.724 Y114.189 I-14.195 J4.635 E.22258
G1 X137.445 Y108.469 E.31696
G1 X138.033 Y108.468 E.02305
G1 X153.621 Y124.056 E.86366
G1 X153.621 Y122.997 E.0415
G1 X138.029 Y138.588 E.86386
G1 X137.449 Y138.588 E.02274
G1 X131.723 Y132.863 E.31723
G2 X132.706 Y131.565 I-22.61 J-18.146 E.06377
G1 X149.271 Y112.281 F30000
G1 F13727.299
G2 X150.134 Y112.893 I3.11 J-3.474 E.04154
G1 X153.619 Y116.378 E.19308
G1 X153.618 Y115.323 E.04132
G1 X130.353 Y138.588 E1.28903
G1 X129.773 Y138.588 E.02274
G1 X127.469 Y136.284 E.12764
G3 X123.594 Y137.672 I-7.114 J-13.765 E.16176
G1 X122.678 Y138.588 E.05077
G1 X122.097 Y138.588 E.02274
G1 X121.453 Y137.943 E.03571
G3 X116.312 Y137.277 I-.732 J-14.512 E.20416
G1 X115.028 Y138.562 E.07118
G3 X114.336 Y138.503 I.065 J-4.849 E.02722
G1 X106.597 Y130.764 E.42879
G2 X106.73 Y131.507 I3.964 J-.327 E.02963
G1 X107.956 Y130.282 E.06791
G2 X111.377 Y134.536 I12.76 J-6.758 E.2152
G1 X109.588 Y136.325 E.09911
G3 X108.462 Y135.153 I5.168 J-6.09 E.0638
G1 X106.63 Y127.247 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.522353
G1 F11616.447
G1 X106.595 Y126.96 E.01339
; LINE_WIDTH: 0.482567
G1 F12689.426
G1 X106.561 Y126.672 E.01226
; LINE_WIDTH: 0.442008
G1 F14008.468
G1 X106.54 Y126.466 E.00798
; LINE_WIDTH: 0.40186
G1 F15000
G1 X106.521 Y126.268 E.00686
; LINE_WIDTH: 0.362562
G1 X106.501 Y126.069 E.00609
; LINE_WIDTH: 0.319074
G1 X106.477 Y125.766 E.008
; LINE_WIDTH: 0.272107
G1 X106.454 Y125.469 E.00646
; LINE_WIDTH: 0.231506
G1 X106.437 Y125.167 E.00534
; LINE_WIDTH: 0.197201
G1 X106.42 Y124.87 E.00426
; LINE_WIDTH: 0.158356
G1 X106.398 Y124.273 E.00626
; LINE_WIDTH: 0.129301
G1 X106.389 Y123.675 E.00456
G1 X106.407 Y122.484 E.00908
; LINE_WIDTH: 0.1691
G1 X106.421 Y122.184 E.00346
; LINE_WIDTH: 0.197069
G1 X106.435 Y121.887 E.00426
; LINE_WIDTH: 0.231275
G1 X106.455 Y121.586 E.00532
; LINE_WIDTH: 0.271725
G1 X106.476 Y121.289 E.00644
; LINE_WIDTH: 0.309774
G1 X106.493 Y121.086 E.00518
; LINE_WIDTH: 0.345398
G1 X106.511 Y120.888 E.00575
; LINE_WIDTH: 0.380579
G1 X106.529 Y120.689 E.00644
; LINE_WIDTH: 0.420556
G1 F14823.474
G1 X106.551 Y120.484 E.0075
; LINE_WIDTH: 0.464817
G1 F13234.8
G1 X106.573 Y120.285 E.0081
; LINE_WIDTH: 0.508291
G1 F11974.313
G1 X106.595 Y120.087 E.00896
; LINE_WIDTH: 0.537306
G1 F11258.646
G1 X106.633 Y119.795 E.01407
G1 X108.462 Y111.9 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F13727.299
G3 X109.588 Y110.727 I6.289 J4.912 E.0638
G1 X111.376 Y112.515 E.09906
G2 X107.954 Y116.769 I9.421 J11.083 E.21517
G1 X106.728 Y115.543 E.06793
G2 X106.589 Y116.297 I3.876 J1.107 E.03009
G1 X114.326 Y108.56 E.42868
G3 X115.02 Y108.483 I.889 J4.844 E.02741
G1 X116.317 Y109.78 E.07187
G3 X121.453 Y109.109 I4.396 J13.648 E.20403
G1 X122.088 Y108.473 E.03522
G1 X122.686 Y108.473 E.02342
G1 X123.601 Y109.388 E.05068
G3 X127.465 Y110.773 I-2.726 J13.691 E.16141
G1 X129.767 Y108.471 E.12753
G1 X130.36 Y108.471 E.02323
G1 X153.623 Y131.734 E1.28896
G1 X153.623 Y130.671 E.04168
G1 X150.138 Y134.156 E.1931
G2 X149.275 Y134.775 I1.113 J2.462 E.04189
G1 X153.546 Y111.78 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.396863
G1 F15000
G1 X153.601 Y111.499 E.00969
; LINE_WIDTH: 0.369053
G1 X153.624 Y111.355 E.00458
; LINE_WIDTH: 0.321422
G1 X153.648 Y111.21 E.00389
; LINE_WIDTH: 0.29567
G1 X153.65 Y111.195 E.00035
; LINE_WIDTH: 0.278659
G1 X153.665 Y111.051 E.00325
; LINE_WIDTH: 0.247412
G1 X153.681 Y110.895 E.00301
; LINE_WIDTH: 0.214415
G1 X153.689 Y110.297 E.00957
; LINE_WIDTH: 0.237673
G2 X153.667 Y109.996 I-5.112 J.234 E.00553
; LINE_WIDTH: 0.280204
G1 X153.647 Y109.851 E.00328
; LINE_WIDTH: 0.321423
G1 X153.625 Y109.689 E.00434
; LINE_WIDTH: 0.357508
G1 X153.611 Y109.62 E.0021
; LINE_WIDTH: 0.384267
G1 X153.598 Y109.552 E.00229
; LINE_WIDTH: 0.423085
G1 F14722.493
G2 X153.564 Y109.401 I-1.441 J.252 E.00564
; LINE_WIDTH: 0.460377
G1 F13378.64
G1 X153.536 Y109.319 E.00347
; LINE_WIDTH: 0.500892
G1 F12171.594
G2 X153.43 Y109.086 I-1.969 J.756 E.01133
; LINE_WIDTH: 0.519873
G1 F11677.987
G2 X153.141 Y108.731 I-1.199 J.681 E.02119
; LINE_WIDTH: 0.475349
G1 F12905.672
G2 X153.006 Y108.623 I-.999 J1.102 E.00721
; LINE_WIDTH: 0.422878
G1 F14730.697
G2 X152.502 Y108.319 I-3.143 J4.646 E.02152
; WIPE_START
G1 X153.006 Y108.623 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.982 Y108.319 Z3.489 F30000
G1 Z3.089
G1 E.8 F1800
; LINE_WIDTH: 0.158112
G1 F15000
G1 X149.903 Y108.379 E.00104
; LINE_WIDTH: 0.130642
G1 X149.723 Y108.534 E.00184
; CHANGE_LAYER
; Z_HEIGHT: 3.32481
; LAYER_HEIGHT: 0.235998
; WIPE_START
G1 F15000
G1 X149.903 Y108.379 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 18/33
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
G17
G3 Z3.489 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.182 Y138.255
G1 Z3.325
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X154.161 Y138.301 E.0018
G3 X152.558 Y139.306 I-1.609 J-.786 E.07078
G1 X115.566 Y139.306 E1.31376
G3 X105.784 Y129.523 I.004 J-9.786 E.54566
G1 X105.784 Y117.529 E.42596
G3 X115.566 Y107.747 I9.786 J.004 E.54566
G1 X152.563 Y107.747 E1.31395
G3 X154.342 Y109.514 I-.01 J1.789 E.09866
G1 X154.342 Y137.538 E.99528
G3 X154.248 Y138.088 I-1.79 J-.023 E.01988
G1 X154.204 Y138.199 E.00424
; WIPE_START
M204 S10000
G1 X154.161 Y138.301 E-.04208
G1 X154.056 Y138.492 E-.08278
G1 X153.786 Y138.818 E-.1611
G1 X153.454 Y139.065 E-.15694
G1 X153.271 Y139.156 E-.07766
G1 X153.079 Y139.227 E-.07773
G1 X152.881 Y139.275 E-.07739
G1 X152.661 Y139.296 E-.08433
; WIPE_END
G1 E-.04 F1800
G1 X152.078 Y131.686 Z3.725 F30000
G1 X150.301 Y108.461 Z3.725
G1 Z3.325
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F14005.775
G1 X150.271 Y108.475 E.00128
G2 X151.681 Y108.343 I.904 J2.051 E.48547
G1 X151.706 Y108.132 E.00817
G3 X152.639 Y108.136 I.424 J9.904 E.03584
G3 X153.958 Y109.521 I-.084 J1.4 E.08082
G1 X153.958 Y137.531 E1.07558
G3 X152.549 Y138.921 I-1.406 J-.016 E.08428
G1 X151.714 Y138.921 E.03209
G1 X151.683 Y138.717 E.00793
G2 X153.092 Y137.69 I-.534 J-2.213 E.0687
G2 X151.398 Y134.298 I-1.918 J-1.161 E.17347
G2 X150.666 Y138.717 I-.221 J2.233 E.25949
G1 X150.635 Y138.921 E.00793
G1 X115.571 Y138.921 E1.34646
G3 X106.168 Y129.519 I-.001 J-9.402 E.56716
G1 X106.168 Y117.534 E.4602
G3 X115.571 Y108.132 I9.402 J-.001 E.56716
G1 X150.643 Y108.132 E1.34674
G1 X150.668 Y108.343 E.00817
G1 X150.358 Y108.443 E.01249
; WIPE_START
G1 X150.271 Y108.475 E-.03537
G1 X150.033 Y108.593 E-.10103
G1 X149.812 Y108.742 E-.10107
G1 X149.611 Y108.915 E-.10108
G1 X149.431 Y109.112 E-.10114
G1 X149.276 Y109.328 E-.10109
G1 X149.147 Y109.561 E-.10107
G1 X149.047 Y109.807 E-.10106
G1 X149.036 Y109.85 E-.01707
; WIPE_END
G1 E-.04 F1800
G1 X144.008 Y115.593 Z3.725 F30000
G1 X125.995 Y136.165 Z3.725
G1 Z3.325
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.461 Y136.385 E.02049
G3 X120.332 Y109.824 I-4.748 J-12.859 E1.68802
G3 X123.73 Y110.155 I.377 J13.747 E.12154
G3 X126.513 Y135.946 I-3.016 J13.371 E1.20867
G1 X126.05 Y136.142 E.01787
M204 S10000
G1 X126.158 Y136.526 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F14005.775
G1 X126.14 Y136.531 E.00075
G3 X120.324 Y109.44 I-5.426 J-13.005 E1.89891
G3 X134.14 Y119.248 I.397 J14.075 E.69809
G3 X126.676 Y136.294 I-13.427 J4.278 E.78048
G1 X126.213 Y136.502 E.01947
; WIPE_START
G1 X126.14 Y136.531 E-.03011
G1 X125.595 Y136.748 E-.22269
G1 X125.041 Y136.94 E-.22293
G1 X124.479 Y137.108 E-.2229
G1 X124.322 Y137.148 E-.06137
; WIPE_END
G1 E-.04 F1800
G1 X129.495 Y131.536 Z3.725 F30000
G1 X150.425 Y108.824 Z3.725
G1 Z3.325
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G3 X151.064 Y108.669 I.75 J1.701 E.0235
G3 X151.353 Y108.677 I.11 J1.215 E.01028
G1 X151.504 Y108.695 E.00539
G3 X150.37 Y108.849 I-.329 J1.829 E.37348
; WIPE_START
M204 S10000
G1 X150.698 Y108.731 E-.13233
G1 X151.064 Y108.669 E-.14121
G1 X151.353 Y108.677 E-.10969
G1 X151.504 Y108.695 E-.05769
G1 X151.718 Y108.747 E-.08377
G1 X151.924 Y108.824 E-.08374
G1 X152.121 Y108.924 E-.08375
G1 X152.269 Y109.024 E-.06782
; WIPE_END
G1 E-.04 F1800
G1 X152.414 Y116.655 Z3.725 F30000
G1 X152.81 Y137.413 Z3.725
G1 Z3.325
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.802 Y137.426 E.00052
G3 X151.064 Y134.672 I-1.627 J-.899 E.27385
G3 X151.353 Y134.68 I.11 J1.217 E.01028
G1 X151.504 Y134.698 E.00539
G3 X152.896 Y137.227 I-.329 J1.829 E.11744
G1 X152.835 Y137.359 E.00517
M204 S10000
G1 X153.582 Y137.558 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.413945
G1 F15000
G1 X153.559 Y137.638 E.00291
; LINE_WIDTH: 0.454503
G1 F13849.613
G3 X153.496 Y137.823 I-1.772 J-.493 E.00758
; LINE_WIDTH: 0.497689
G1 F12511.7
G1 X153.449 Y137.915 E.00447
G3 X153.125 Y138.33 I-1.252 J-.646 E.02275
; LINE_WIDTH: 0.462882
G1 F13568.11
G1 X153.059 Y138.383 E.00336
; LINE_WIDTH: 0.4376
G1 F14454.586
G1 X152.583 Y138.72 E.0217
G1 X153.582 Y137.558 F30000
; LINE_WIDTH: 0.388576
G1 F15000
G1 X153.595 Y137.5 E.00193
; LINE_WIDTH: 0.352932
G1 X153.619 Y137.355 E.00427
; LINE_WIDTH: 0.305261
G1 X153.643 Y137.21 E.0036
; LINE_WIDTH: 0.264153
G1 X153.66 Y137.052 E.00327
; LINE_WIDTH: 0.232544
G1 X153.675 Y136.907 E.00255
; LINE_WIDTH: 0.198884
G1 X153.684 Y136.309 E.00852
; LINE_WIDTH: 0.220226
G1 X153.662 Y136.011 E.00488
; LINE_WIDTH: 0.262677
G1 X153.642 Y135.855 E.00321
; LINE_WIDTH: 0.303036
G1 X153.622 Y135.71 E.00355
; LINE_WIDTH: 0.325131
G1 X153.62 Y135.693 E.00043
; LINE_WIDTH: 0.352557
G1 X153.595 Y135.567 E.00375
; LINE_WIDTH: 0.40203
G1 X153.57 Y135.44 E.00437
; LINE_WIDTH: 0.40992
G1 X153.548 Y135.429 E.00086
; LINE_WIDTH: 0.376231
G1 X153.525 Y135.419 E.00077
; LINE_WIDTH: 0.344183
G1 X153.31 Y135.326 E.00662
G1 X153.141 Y134.875 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.390646
G1 F12000
G1 X153.25 Y134.774 E.00484
; LINE_WIDTH: 0.413219
G1 X153.34 Y134.762 E.00317
; LINE_WIDTH: 0.458366
G1 X153.43 Y134.749 E.00357
; LINE_WIDTH: 0.497802
G1 X153.52 Y134.736 E.00391
G1 X153.552 Y134.575 E.00706
; LINE_WIDTH: 0.462416
G1 X153.541 Y112.296 E.8821
G1 X153.535 Y111.806 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.380559
G1 F15000
G1 X153.595 Y111.498 E.00998
; LINE_WIDTH: 0.352927
G1 X153.619 Y111.353 E.00427
; LINE_WIDTH: 0.305246
G1 X153.643 Y111.208 E.0036
; LINE_WIDTH: 0.279586
G1 X153.645 Y111.194 E.0003
; LINE_WIDTH: 0.262678
G1 X153.66 Y111.049 E.00297
; LINE_WIDTH: 0.23152
G1 X153.675 Y110.895 E.0027
; LINE_WIDTH: 0.198576
G1 X153.684 Y110.298 E.00849
; LINE_WIDTH: 0.221704
M73 P70 R5
G1 X153.661 Y109.997 E.00497
; LINE_WIDTH: 0.264159
G1 X153.642 Y109.852 E.003
; LINE_WIDTH: 0.305258
G1 X153.62 Y109.691 E.00398
; LINE_WIDTH: 0.343708
G1 X153.604 Y109.61 E.00234
; LINE_WIDTH: 0.381851
G1 X153.581 Y109.495 E.00373
; LINE_WIDTH: 0.418638
G1 X153.551 Y109.382 E.00414
; LINE_WIDTH: 0.461866
G1 F13601.632
G2 X153.491 Y109.222 I-1.261 J.383 E.00674
; LINE_WIDTH: 0.500635
G1 F12429.789
G1 X153.425 Y109.09 E.00639
G2 X153.147 Y108.745 I-1.253 J.727 E.01924
; LINE_WIDTH: 0.463001
G1 F13564.183
G2 X153.021 Y108.641 I-.855 J.905 E.00649
; LINE_WIDTH: 0.428744
G1 F14793.162
G1 X152.966 Y108.604 E.00241
; LINE_WIDTH: 0.398308
G1 F15000
G1 X152.505 Y108.331 E.0179
; WIPE_START
G1 X152.966 Y108.604 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.019 Y108.349 Z3.725 F30000
G1 Z3.325
G1 E.8 F1800
; LINE_WIDTH: 0.135235
G1 F15000
G1 X149.897 Y108.382 E.00103
G1 X149.722 Y108.532 E.00187
; WIPE_START
G1 X149.897 Y108.382 E-.48994
G1 X150.019 Y108.349 E-.27006
; WIPE_END
G1 E-.04 F1800
G1 X150.528 Y115.964 Z3.725 F30000
G1 X151.734 Y134.002 Z3.725
G1 Z3.325
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F14005.775
G2 X150.14 Y134.153 I-.531 J2.894 E.06227
G1 X153.142 Y131.151 E.163
G1 X153.142 Y131.253 E.0039
G1 X130.843 Y108.954 E1.21097
G1 X129.283 Y108.954 E.05987
G1 X127.467 Y110.771 E.09865
G2 X123.597 Y109.384 I-6.631 J12.412 E.15842
G1 X123.169 Y108.956 E.02326
G1 X121.605 Y108.956 E.06003
G3 X121.311 Y109.099 I-.21 J-.059 E.01419
G2 X116.316 Y109.78 I-.499 J14.995 E.19449
G1 X115.495 Y108.958 E.04462
G2 X113.732 Y109.154 I.445 J12.037 E.06817
G1 X107.19 Y115.696 E.35525
G1 X107.14 Y115.955 E.01015
G1 X107.953 Y116.768 E.04414
G3 X111.378 Y112.517 I13.197 J7.127 E.2108
G1 X109.931 Y111.07 E.07859
G2 X108.814 Y112.25 I5.523 J6.341 E.06248
G1 X106.577 Y118.741 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.46446
G1 F12000
G1 X106.575 Y118.706 E.00143
G3 X106.621 Y116.672 I18.987 J-.589 E.08096
G1 X106.839 Y115.407 E.05108
G3 X107.396 Y113.796 I7.845 J1.815 E.06795
G3 X108.762 Y111.652 I8.655 J4.002 E.10146
G1 X109.364 Y111.033 E.03436
G1 X110.334 Y110.217 E.05042
G3 X111.827 Y109.358 I6.223 J9.083 E.06862
G1 X113.017 Y108.907 E.05064
G3 X115.143 Y108.548 I3.118 J12.008 E.0859
G1 X148.886 Y108.539 E1.34265
; LINE_WIDTH: 0.488592
G1 X148.978 Y108.563 E.00398
; LINE_WIDTH: 0.537086
G1 F11498.371
G1 X149.069 Y108.587 E.00442
; LINE_WIDTH: 0.587211
G1 F10424.197
G1 X149.165 Y108.617 E.00518
; WIPE_START
G1 X149.069 Y108.587 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.646 Y110.361 Z3.725 F30000
G1 X106.577 Y118.741 Z3.725
G1 Z3.325
G1 E.8 F1800
; LINE_WIDTH: 0.454878
G1 F12000
G1 X106.564 Y119.043 E.01174
; LINE_WIDTH: 0.421217
G1 X106.551 Y119.345 E.01076
G1 X106.846 Y119.384 E.0106
G1 X106.969 Y119 E.01436
G1 X106.711 Y118.918 E.00966
; LINE_WIDTH: 0.452086
G1 X106.613 Y118.789 E.00625
G1 X106.645 Y119.743 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.528435
G1 F11706.559
G1 X106.6 Y120.088 E.01601
; LINE_WIDTH: 0.49262
G1 F12655.181
G1 X106.578 Y120.287 E.00848
; LINE_WIDTH: 0.449126
G1 F14036.484
G1 X106.556 Y120.485 E.00764
; LINE_WIDTH: 0.404877
G1 F15000
G1 X106.534 Y120.69 E.00703
; LINE_WIDTH: 0.364932
G1 X106.516 Y120.889 E.00602
; LINE_WIDTH: 0.329753
G1 X106.499 Y121.087 E.00535
; LINE_WIDTH: 0.294159
G1 X106.481 Y121.29 E.00477
; LINE_WIDTH: 0.256131
G1 X106.461 Y121.587 E.00588
; LINE_WIDTH: 0.215697
G1 X106.44 Y121.887 E.00477
; LINE_WIDTH: 0.181501
G1 X106.427 Y122.185 E.00375
; LINE_WIDTH: 0.153538
G1 X106.413 Y122.484 E.00297
; LINE_WIDTH: 0.116988
G1 X106.395 Y123.485 E.00639
G1 X106.395 Y123.721 F30000
; LINE_WIDTH: 0.112808
G1 F15000
G1 X106.403 Y124.271 E.00329
; LINE_WIDTH: 0.142656
G1 X106.425 Y124.867 E.00528
; LINE_WIDTH: 0.18149
G1 X106.442 Y125.167 E.00378
; LINE_WIDTH: 0.215692
G1 X106.459 Y125.464 E.00473
; LINE_WIDTH: 0.256194
G1 X106.483 Y125.765 E.00597
; LINE_WIDTH: 0.30298
G1 X106.506 Y126.062 E.00724
; LINE_WIDTH: 0.346321
G1 X106.526 Y126.266 E.00583
; LINE_WIDTH: 0.386207
G1 X106.546 Y126.465 E.00643
; LINE_WIDTH: 0.425526
G1 F14920.138
G1 X106.565 Y126.663 E.00718
; LINE_WIDTH: 0.469722
G1 F13346.662
G1 X106.604 Y126.987 E.01315
; LINE_WIDTH: 0.517023
G1 F11993.015
G1 X106.642 Y127.303 E.01426
G1 X106.579 Y128.351 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.463989
G1 F12000
G2 X106.622 Y130.378 I21.367 J.568 E.08062
G1 X106.828 Y131.641 E.05088
G2 X107.395 Y133.25 I7.841 J-1.857 E.06794
G1 X107.781 Y134.013 E.03397
G2 X108.772 Y135.406 I7.87 J-4.548 E.06805
G1 X109.667 Y136.309 E.05053
G1 X110.689 Y137.077 E.05081
G2 X112.229 Y137.862 I4.38 J-6.683 E.06883
G2 X115.581 Y138.515 I3.401 J-8.532 E.13653
G1 X149.004 Y138.515 E1.3284
; LINE_WIDTH: 0.487072
G1 X149.07 Y138.497 E.00284
; LINE_WIDTH: 0.533766
G1 F11577.388
G1 X149.135 Y138.479 E.00315
; LINE_WIDTH: 0.580459
G1 F10557.055
G1 X149.2 Y138.461 E.00345
; WIPE_START
G1 X149.135 Y138.479 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.71 Y136.712 Z3.725 F30000
G1 X106.579 Y128.351 Z3.725
G1 Z3.325
G1 E.8 F1800
; LINE_WIDTH: 0.453101
G1 F12000
G1 X106.722 Y128.138 E.00992
; LINE_WIDTH: 0.419504
G1 X106.97 Y128.059 E.00926
G1 X106.846 Y127.664 E.01468
G1 X106.551 Y127.699 E.01053
; LINE_WIDTH: 0.431206
G1 X106.564 Y127.995 E.01083
; LINE_WIDTH: 0.458926
G1 X106.577 Y128.291 E.01162
G1 X108.812 Y134.804 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F14005.775
G2 X109.925 Y135.989 I6.168 J-4.674 E.06253
G1 X111.376 Y134.538 E.07882
G3 X107.955 Y130.283 I9.761 J-11.351 E.21083
G1 X107.14 Y131.098 E.04427
G1 X107.19 Y131.357 E.01012
G1 X113.732 Y137.899 E.35527
G2 X115.489 Y138.101 I1.946 J-9.191 E.06801
G1 X116.311 Y137.278 E.04467
G2 X121.454 Y137.945 I4.488 J-14.448 E.20011
G1 X121.614 Y138.105 E.00869
G1 X123.161 Y138.105 E.05939
G1 X123.592 Y137.674 E.02341
G2 X127.471 Y136.286 I-3.236 J-15.154 E.15867
G1 X129.29 Y138.105 E.09881
G1 X130.837 Y138.105 E.05939
G1 X153.142 Y115.8 E1.2113
G1 X153.142 Y115.901 E.0039
G1 X150.137 Y112.896 E.16319
G3 X149.269 Y112.282 I1.621 J-3.211 E.04095
G1 X132.707 Y131.566 F30000
G1 F14005.775
G3 X131.725 Y132.864 I-23.618 J-16.868 E.0625
G1 X136.966 Y138.105 E.28463
G1 X138.512 Y138.105 E.05938
G1 X153.142 Y123.475 E.79446
G1 X153.142 Y123.577 E.0039
G1 X138.517 Y108.952 E.79424
G1 X136.962 Y108.952 E.05971
G1 X131.725 Y114.188 E.28435
G3 X134.463 Y119.126 I-11.503 J9.606 E.21812
G1 X144.64 Y108.95 E.55262
G1 X146.19 Y108.95 E.05955
G1 X148.802 Y111.561 E.14182
G2 X149.14 Y112.125 I2.459 J-1.092 E.02532
G1 X134.855 Y126.41 E.77575
G3 X134.464 Y127.927 I-23.113 J-5.148 E.06017
G1 X144.642 Y138.105 E.5527
G1 X146.188 Y138.105 E.05939
G1 X148.804 Y135.489 E.14207
G3 X149.14 Y134.927 I2.573 J1.154 E.02519
G1 X134.863 Y120.65 E.77529
G3 X135.091 Y122.262 I-39.986 J6.463 E.06249
G1 X149.844 Y138.606 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.116463
G1 F15000
G2 X150.014 Y138.702 I.204 J-.162 E.00127
; CHANGE_LAYER
; Z_HEIGHT: 3.52311
; LAYER_HEIGHT: 0.198296
; WIPE_START
G1 F15000
G1 X149.945 Y138.683 E-.27444
G1 X149.844 Y138.606 E-.48556
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 19/33
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
G17
G3 Z3.725 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.153 Y138.233
G1 Z3.523
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X154.148 Y138.249 E.00051
G3 X152.559 Y139.271 I-1.591 J-.729 E.06085
G1 X115.566 Y139.27 E1.12809
G3 X105.819 Y129.523 I.004 J-9.751 E.46685
G1 X105.819 Y117.53 E.36575
G3 X115.566 Y107.782 I9.751 J.004 E.46686
G1 X152.578 Y107.783 E1.12867
G3 X154.307 Y109.498 I-.03 J1.758 E.082
G1 X154.307 Y137.555 E.8556
G3 X154.259 Y137.926 I-1.75 J-.035 E.01144
G1 X154.173 Y138.177 E.00807
; WIPE_START
M204 S10000
G1 X154.148 Y138.249 E-.02918
G1 X153.97 Y138.556 E-.1348
G1 X153.762 Y138.79 E-.11907
G1 X153.51 Y138.989 E-.12169
G1 X153.337 Y139.088 E-.07594
G1 X153.146 Y139.168 E-.07854
G1 X152.958 Y139.225 E-.07465
G1 X152.628 Y139.263 E-.12612
; WIPE_END
G1 E-.04 F1800
G1 X152.04 Y131.653 Z3.923 F30000
G1 X150.247 Y108.474 Z3.923
G1 Z3.523
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16337.674
G1 X150.029 Y108.587 E.00809
G2 X151.849 Y108.377 I1.146 J1.938 E.40356
G1 X151.885 Y108.176 E.00673
G3 X152.711 Y108.185 I.34 J6.291 E.02724
G3 X153.914 Y109.507 I-.147 J1.342 E.06428
G1 X153.914 Y137.545 E.92299
G3 X152.546 Y138.878 I-1.37 J-.038 E.06957
G1 X151.903 Y138.878 E.02118
G1 X151.862 Y138.684 E.00653
G1 X152.128 Y138.567 E.00958
G2 X150.146 Y138.533 I-.957 J-2.038 E.39811
G1 X150.487 Y138.684 E.01229
G1 X150.446 Y138.878 E.00653
G1 X115.571 Y138.878 E1.14806
G3 X106.212 Y129.519 I-.001 J-9.358 E.48396
G1 X106.212 Y117.534 E.39451
G3 X115.571 Y108.175 I9.359 J-.001 E.48398
G1 X150.464 Y108.176 E1.14866
G1 X150.501 Y108.377 E.00673
G2 X150.302 Y108.45 I.674 J2.148 E.00696
; WIPE_START
G1 X150.029 Y108.587 E-.11612
G1 X149.807 Y108.735 E-.10139
G1 X149.605 Y108.909 E-.10147
G1 X149.425 Y109.106 E-.10148
G1 X149.269 Y109.323 E-.10144
G1 X149.14 Y109.557 E-.10144
G1 X149.04 Y109.805 E-.10148
G1 X149.015 Y109.894 E-.03517
; WIPE_END
G1 E-.04 F1800
G1 X143.988 Y115.637 Z3.923 F30000
G1 X126.014 Y136.169 Z3.923
G1 Z3.523
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.994 Y136.182 E.00072
G3 X120.265 Y109.826 I-5.27 J-12.655 E1.46432
G3 X122.985 Y110.006 I.432 J14.102 E.08326
G3 X127.028 Y135.7 I-2.261 J13.521 E1.04427
G1 X126.068 Y136.144 E.03225
M204 S10000
G1 X126.151 Y136.538 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F16337.674
G1 X126.143 Y136.539 E.00026
G3 X117.961 Y137.356 I-5.431 J-13.015 E.27466
G3 X112.106 Y112.357 I2.752 J-13.829 E1.06229
G3 X115.676 Y110.356 I8.507 J10.991 E.13521
G3 X120.256 Y109.433 I5.051 J13.238 E.15451
G3 X134.667 Y125.556 I.457 J14.093 E.8112
G3 X126.679 Y136.301 I-13.955 J-2.032 E.45925
G1 X126.206 Y136.514 E.01709
; WIPE_START
G1 X126.143 Y136.539 E-.02564
G1 X125.598 Y136.756 E-.22291
G1 X125.043 Y136.948 E-.22299
G1 X124.481 Y137.116 E-.22301
G1 X124.314 Y137.159 E-.06545
; WIPE_END
G1 E-.04 F1800
G1 X129.486 Y131.546 Z3.923 F30000
G1 X150.425 Y108.824 Z3.923
G1 Z3.523
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G3 X151.064 Y108.669 I.75 J1.701 E.02018
G1 X151.285 Y108.669 E.00672
G3 X150.37 Y108.849 I-.11 J1.855 E.32742
; WIPE_START
M204 S10000
G1 X150.631 Y108.747 E-.10647
G1 X150.845 Y108.695 E-.08377
G1 X151.064 Y108.669 E-.08378
G1 X151.285 Y108.669 E-.08373
G1 X151.504 Y108.695 E-.08378
G1 X151.718 Y108.747 E-.08373
G1 X151.924 Y108.824 E-.08378
G1 X152.121 Y108.925 E-.08378
G1 X152.267 Y109.023 E-.06718
; WIPE_END
G1 E-.04 F1800
G1 X152.413 Y116.654 Z3.923 F30000
G1 X152.811 Y137.412 Z3.923
G1 Z3.523
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.802 Y137.426 E.00051
G3 X151.064 Y134.672 I-1.627 J-.899 E.23514
G1 X151.285 Y134.672 E.00672
G3 X152.896 Y137.227 I-.11 J1.855 E.10756
G1 X152.836 Y137.357 E.00439
M204 S10000
G1 X153.578 Y137.495 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.284264
G1 F15000
G1 X153.602 Y137.349 E.00288
; LINE_WIDTH: 0.236391
G1 X153.626 Y137.204 E.00231
; LINE_WIDTH: 0.195666
G1 X153.642 Y137.048 E.00194
; LINE_WIDTH: 0.164291
G1 X153.657 Y136.902 E.00144
; LINE_WIDTH: 0.130989
G1 X153.666 Y136.309 E.00424
; LINE_WIDTH: 0.152486
G1 X153.645 Y136.013 E.00264
; LINE_WIDTH: 0.194593
G1 X153.624 Y135.859 E.0019
; LINE_WIDTH: 0.2347
G1 X153.605 Y135.714 E.00228
; LINE_WIDTH: 0.27492
G1 X153.584 Y135.604 E.0021
; LINE_WIDTH: 0.315207
G1 X153.565 Y135.507 E.00218
; LINE_WIDTH: 0.353079
G1 X153.546 Y135.41 E.00248
; LINE_WIDTH: 0.376491
G1 X153.487 Y135.151 E.00716
G1 X153.175 Y134.828 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.369209
G1 F12000
G1 X153.53 Y134.748 E.00962
G1 X153.547 Y134.396 E.00929
G1 X153.545 Y112.782 E.57044
; LINE_WIDTH: 0.38797
G1 X153.525 Y112.46 E.00901
; LINE_WIDTH: 0.442421
G1 X153.504 Y112.138 E.01043
G1 X153.364 Y112.151 E.00456
G1 X153.298 Y112.11 E.00252
G1 X152.957 Y112.484 E.01637
G1 X153.132 Y112.558 E.00614
G1 X153.197 Y112.66 E.00389
; LINE_WIDTH: 0.369224
G1 X153.22 Y112.782 E.00328
G1 X153.22 Y134.396 E.57047
G1 X153.189 Y134.519 E.00333
G1 X153.008 Y134.656 E.00599
G1 X153.133 Y134.785 E.00475
G1 X151.754 Y133.996 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X150.159 Y134.134 I-.553 J2.885 E.05337
G1 X152.854 Y131.44 E.12545
G1 X152.854 Y130.965 E.01563
G1 X131.125 Y109.236 E1.01157
G1 X129.002 Y109.236 E.06989
G1 X127.473 Y110.764 E.07116
G2 X123.577 Y109.364 I-7.031 J13.441 E.13673
G1 X123.449 Y109.236 E.00596
G1 X125.077 Y109.236 E.0536
; WIPE_START
G1 X123.449 Y109.236 E-.61876
G1 X123.577 Y109.364 E-.06881
G1 X123.761 Y109.414 E-.07243
; WIPE_END
G1 E-.04 F1800
G1 X130.079 Y113.695 Z3.923 F30000
G1 X132.713 Y115.48 Z3.923
G1 Z3.523
G1 E.8 F1800
G1 F16200
G2 X131.733 Y114.18 I-21.748 J15.382 E.05358
G1 X136.678 Y109.236 E.23019
G1 X138.801 Y109.236 E.06989
G1 X152.854 Y123.289 E.65423
G1 X152.854 Y123.764 E.01563
G1 X138.801 Y137.817 E.65423
G1 X136.678 Y137.817 E.06989
G1 X131.732 Y132.871 E.23023
G2 X132.715 Y131.574 I-22.749 J-18.256 E.05358
; WIPE_START
G1 X131.732 Y132.871 E-.61841
G1 X131.996 Y133.135 E-.14159
; WIPE_END
G1 E-.04 F1800
G1 X125.675 Y137.412 Z3.923 F30000
G1 X125.077 Y137.817 Z3.923
G1 Z3.523
G1 E.8 F1800
G1 F16200
G1 X123.449 Y137.817 E.0536
G1 X123.578 Y137.688 E.00599
G2 X127.479 Y136.294 I-3.221 J-15.164 E.13678
G1 X129.002 Y137.817 E.07091
G1 X131.125 Y137.817 E.06989
G1 X152.854 Y116.088 E1.01157
G1 X152.854 Y115.613 E.01563
G1 X150.158 Y112.917 E.12549
G2 X151.753 Y113.062 I1.053 J-2.744 E.05337
G1 X153.371 Y111.675 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.109112
G1 F15000
G1 X153.435 Y111.574 E.00064
; LINE_WIDTH: 0.134896
G1 X153.502 Y111.467 E.00094
; LINE_WIDTH: 0.16948
G1 X153.559 Y111.364 E.00121
; LINE_WIDTH: 0.214708
G2 X153.627 Y111.191 I-.267 J-.205 E.00261
; LINE_WIDTH: 0.194616
G1 X153.642 Y111.046 E.0018
; LINE_WIDTH: 0.163636
G1 X153.658 Y110.894 E.00149
; LINE_WIDTH: 0.130791
G1 X153.666 Y110.301 E.00422
; LINE_WIDTH: 0.153452
G1 X153.644 Y110.003 E.00269
; LINE_WIDTH: 0.195627
G1 X153.624 Y109.857 E.00182
; LINE_WIDTH: 0.236424
G1 X153.603 Y109.699 E.0025
; LINE_WIDTH: 0.276269
G1 X153.585 Y109.607 E.00176
; LINE_WIDTH: 0.312046
G1 X153.567 Y109.515 E.00203
; LINE_WIDTH: 0.353239
G2 X153.529 Y109.369 I-1.573 J.333 E.0038
; LINE_WIDTH: 0.404072
G2 X153.45 Y109.176 I-1.654 J.559 E.0061
; LINE_WIDTH: 0.431992
G1 X153.411 Y109.101 E.00266
G2 X153.088 Y108.717 I-1.154 J.644 E.01589
; LINE_WIDTH: 0.3834
G1 X152.991 Y108.641 E.00337
; LINE_WIDTH: 0.347033
G1 X152.57 Y108.38 E.01219
G1 X152.446 Y108.383 F30000
; LINE_WIDTH: 0.237144
G1 F15000
G3 X153.453 Y108.808 I-6.433 J16.658 E.01718
; WIPE_START
G1 X152.446 Y108.383 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.908 Y108.399 Z3.923 F30000
G1 Z3.523
G1 E.8 F1800
; LINE_WIDTH: 0.111774
G1 F15000
G2 X149.714 Y108.523 I.045 J.282 E.00133
G1 X142.725 Y109.236 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G1 X144.354 Y109.236 E.0536
G1 X134.472 Y119.117 E.46001
G3 X134.878 Y120.665 I-14.759 J4.691 E.05269
G1 X149.132 Y134.919 E.66359
G2 X148.785 Y135.509 I2.187 J1.685 E.02259
G1 X146.477 Y137.817 E.10745
G1 X144.354 Y137.817 E.06989
G1 X134.473 Y127.936 E.45999
G2 X134.868 Y126.397 I-21.793 J-6.421 E.05231
G1 X149.133 Y112.133 E.66406
G3 X148.779 Y111.538 I2.167 J-1.691 E.02285
G1 X146.477 Y109.236 E.10718
G1 X148.105 Y109.236 E.0536
; WIPE_START
G1 X146.477 Y109.236 E-.61876
G1 X146.739 Y109.499 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X148.551 Y116.913 Z3.923 F30000
G1 X153.578 Y137.495 Z3.923
G1 Z3.523
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.327942
G1 F15000
G1 X153.556 Y137.589 E.00223
; LINE_WIDTH: 0.372919
G3 X153.506 Y137.749 I-2.731 J-.753 E.00448
; LINE_WIDTH: 0.426019
G1 X153.481 Y137.812 E.00212
G3 X153.081 Y138.344 I-1.262 J-.533 E.02081
; LINE_WIDTH: 0.38633
G1 X153.007 Y138.4 E.00256
; LINE_WIDTH: 0.36178
G1 X152.951 Y138.437 E.00174
; LINE_WIDTH: 0.328328
G1 X152.859 Y138.495 E.00252
; LINE_WIDTH: 0.294222
G1 X152.51 Y138.674 E.00798
G1 X151.632 Y138.546 F30000
; LINE_WIDTH: 0.500727
G1 F14528.847
G1 X151.532 Y138.684 E.00631
; LINE_WIDTH: 0.536685
G1 F13471.561
G1 X151.433 Y138.822 E.00682
G3 X150.916 Y138.822 I-.258 J-7.178 E.02063
; LINE_WIDTH: 0.531074
G1 F13626.286
G1 X150.816 Y138.684 E.00673
; LINE_WIDTH: 0.500828
G1 F14525.627
G1 X150.717 Y138.545 E.00631
G1 X149.846 Y138.674 F30000
; LINE_WIDTH: 0.150281
G1 F15000
G1 X149.77 Y138.608 E.00088
; LINE_WIDTH: 0.134185
G1 X149.684 Y138.525 E.00089
; LINE_WIDTH: 0.1091
G1 X149.598 Y138.442 E.00064
; WIPE_START
G1 X149.684 Y138.525 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X142.062 Y138.127 Z3.923 F30000
G1 X114.784 Y136.702 Z3.923
G1 Z3.523
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X116.302 Y137.287 I11.363 J-27.215 E.05358
G1 X115.773 Y137.817 E.02465
G3 X113.335 Y137.502 I-.094 J-8.866 E.08117
G1 X107.582 Y131.749 E.26784
G3 X107.383 Y130.855 I6.14 J-1.838 E.03017
G1 X107.947 Y130.291 E.02627
G2 X111.373 Y134.541 I13.034 J-7.002 E.18074
G1 X110.128 Y135.785 E.05794
G3 X109.011 Y134.604 I7.675 J-8.373 E.05358
G1 X106.957 Y128.179 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.370624
G1 F12000
G1 X106.974 Y128.111 E.00185
G1 X106.908 Y127.908 E.00566
G1 X106.597 Y127.952 E.00833
G2 X106.622 Y130.368 I27.419 J.922 E.06406
G1 X106.835 Y131.633 E.03399
G2 X108.254 Y134.724 I8.934 J-2.23 E.09066
G1 X108.768 Y135.395 E.02241
G1 X109.663 Y136.3 E.03373
M73 P71 R5
G2 X113.423 Y138.235 I5.94 J-6.92 E.11312
G2 X115.556 Y138.51 I2.257 J-9.114 E.05711
G1 X149.132 Y138.503 E.88998
G3 X149.223 Y138.289 I.171 J-.053 E.00669
G1 X149.051 Y138.057 E.00765
G1 X148.849 Y138.182 E.00631
G1 X148.82 Y138.184 E.00076
G1 X115.584 Y138.184 E.88097
G3 X113.926 Y138.012 I-.068 J-7.442 E.04427
G1 X113.513 Y137.931 E.01116
G3 X109.305 Y135.499 I2.184 J-8.635 E.13048
G1 X108.526 Y134.558 E.03238
G3 X107.698 Y133.11 I6.304 J-4.561 E.0443
G3 X107.166 Y131.569 I6.658 J-3.165 E.04329
G3 X106.913 Y129.506 I9.027 J-2.15 E.05522
G1 X106.912 Y128.313 E.0316
G1 X106.938 Y128.236 E.00216
G1 X106.696 Y127.549 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.52932
G1 F13675.403
G1 X106.655 Y127.262 E.01142
; LINE_WIDTH: 0.498259
G1 F14607.513
G1 X106.631 Y127.064 E.00736
; LINE_WIDTH: 0.450548
G1 F15000
G1 X106.607 Y126.865 E.00659
; LINE_WIDTH: 0.402
G1 X106.583 Y126.66 E.00601
; LINE_WIDTH: 0.357782
G1 X106.563 Y126.461 E.00508
; LINE_WIDTH: 0.318435
G1 X106.543 Y126.263 E.00444
; LINE_WIDTH: 0.278645
G1 X106.523 Y126.06 E.00389
; LINE_WIDTH: 0.235368
G1 X106.5 Y125.762 E.00465
; LINE_WIDTH: 0.188637
G1 X106.477 Y125.462 E.00355
; LINE_WIDTH: 0.148169
G1 X106.46 Y125.165 E.00254
; LINE_WIDTH: 0.112347
G1 X106.441 Y124.834 E.00187
G1 X106.441 Y122.251 F30000
; LINE_WIDTH: 0.112252
G1 F15000
G1 X106.458 Y121.889 E.00204
; LINE_WIDTH: 0.148169
G1 X106.478 Y121.59 E.00256
; LINE_WIDTH: 0.188557
G1 X106.498 Y121.292 E.00352
; LINE_WIDTH: 0.226523
G1 X106.516 Y121.09 E.00301
; LINE_WIDTH: 0.262018
G1 X106.534 Y120.892 E.00353
; LINE_WIDTH: 0.297207
G1 X106.551 Y120.693 E.0041
; LINE_WIDTH: 0.337092
G1 X106.574 Y120.489 E.00489
; LINE_WIDTH: 0.381266
G1 X106.596 Y120.29 E.00547
; LINE_WIDTH: 0.424819
G1 X106.617 Y120.092 E.00617
; LINE_WIDTH: 0.469329
G1 X106.656 Y119.798 E.0102
; LINE_WIDTH: 0.512642
G1 F14160.569
G1 X106.693 Y119.513 E.01092
G1 X109.02 Y112.455 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G3 X110.135 Y111.274 I6.439 J4.961 E.05356
G1 X111.367 Y112.506 E.05738
G2 X107.945 Y116.76 I9.439 J11.098 E.18079
G1 X107.386 Y116.201 E.02602
G3 X107.577 Y115.308 I6.335 J.892 E.03008
G1 X113.345 Y109.541 E.26852
G3 X115.773 Y109.236 I2.269 J8.255 E.08082
G1 X116.308 Y109.771 E.02492
G2 X114.787 Y110.348 I5.064 J15.647 E.05359
G1 X113.511 Y109.117 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.368047
G1 F12000
G1 X114.723 Y108.911 E.03232
G3 X115.575 Y108.872 I.992 J12.195 E.02244
G1 X149.017 Y108.869 E.87944
G1 X149.133 Y108.882 E.00305
G1 X149.348 Y108.662 E.0081
G1 X149.266 Y108.544 E.00377
G1 X149.017 Y108.543 E.00653
G1 X115.575 Y108.55 E.87944
G1 X114.723 Y108.582 E.02243
G2 X113.48 Y108.79 I3.653 J25.699 E.03315
G2 X111.843 Y109.352 I2.278 J9.291 E.04559
G1 X110.721 Y109.966 E.03361
G1 X109.691 Y110.735 E.03382
G1 X109.072 Y111.32 E.02242
G1 X108.252 Y112.308 E.03374
G2 X107.08 Y114.578 I8.423 J5.787 E.06737
G1 X106.749 Y115.817 E.03373
G2 X106.579 Y117.547 I8.892 J1.748 E.04579
G2 X106.596 Y119.113 I17.323 J.596 E.0412
G1 X106.907 Y119.154 E.00825
G1 X106.985 Y118.912 E.0067
G3 X106.907 Y118.746 I.073 J-.136 E.00517
G3 X106.953 Y116.704 I18.084 J-.61 E.05375
G3 X107.528 Y114.312 I10.227 J1.195 E.06484
G1 X108.058 Y113.213 E.0321
G3 X109.588 Y111.266 I8.654 J5.227 E.06529
G1 X110.536 Y110.486 E.03227
G1 X111.584 Y109.844 E.03232
G1 X112.343 Y109.494 E.02199
G1 X113.454 Y109.135 E.0307
; CHANGE_LAYER
; Z_HEIGHT: 3.6883
; LAYER_HEIGHT: 0.165191
; WIPE_START
G1 F12000
G1 X112.343 Y109.494 E-.44366
G1 X111.587 Y109.843 E-.31634
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 20/33
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
G17
G3 Z3.923 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.099 Y138.233
G1 Z3.688
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X153.99 Y138.433 E.00589
G3 X152.569 Y139.222 I-1.44 J-.919 E.04386
G1 X115.566 Y139.222 E.9577
G3 X105.868 Y129.523 I.004 J-9.702 E.39425
G1 X105.868 Y117.529 E.31043
G3 X115.566 Y107.831 I9.702 J.004 E.39425
G1 X152.613 Y107.832 E.95883
G3 X154.259 Y109.525 I-.061 J1.706 E.06746
G1 X154.259 Y137.528 E.72478
G3 X154.124 Y138.179 I-1.708 J-.014 E.01731
; WIPE_START
M204 S10000
G1 X153.99 Y138.433 E-.10921
G1 X153.779 Y138.705 E-.13069
G1 X153.548 Y138.904 E-.1161
G1 X153.379 Y139.011 E-.07584
G1 X153.194 Y139.098 E-.07794
G1 X153.006 Y139.163 E-.07552
G1 X152.812 Y139.201 E-.07487
G1 X152.569 Y139.222 E-.09296
G1 X152.551 Y139.222 E-.00687
; WIPE_END
G1 E-.04 F1800
G1 X151.98 Y131.611 Z4.088 F30000
G1 X150.244 Y108.467 Z4.088
G1 Z3.688
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X150.022 Y108.575 E.00688
G2 X152.017 Y108.422 I1.152 J1.944 E.33832
G1 X152.063 Y108.232 E.00546
G3 X152.754 Y108.247 I.265 J3.678 E.0193
G3 X153.859 Y109.538 I-.195 J1.285 E.05167
G1 X153.859 Y137.515 E.78059
G3 X152.552 Y138.823 I-1.307 J.001 E.05732
G1 X152.055 Y138.823 E.01387
G1 X152.013 Y138.625 E.00563
G1 X152.138 Y138.57 E.00381
G2 X149.865 Y134.69 I-.964 J-2.041 E.20903
G2 X150.336 Y138.625 I1.304 J1.84 E.13506
G1 X150.294 Y138.823 E.00563
G1 X115.571 Y138.822 E.96882
G3 X106.267 Y129.519 I-.001 J-9.303 E.40776
G1 X106.267 Y117.534 E.33438
G3 X115.571 Y108.23 I9.303 J-.001 E.40776
G1 X150.286 Y108.232 E.96859
G1 X150.332 Y108.422 E.00546
G1 X150.297 Y108.44 E.00109
; WIPE_START
G1 X150.022 Y108.575 E-.11647
G1 X149.803 Y108.729 E-.10191
G1 X149.6 Y108.904 E-.10179
G1 X149.419 Y109.102 E-.10181
G1 X149.263 Y109.32 E-.10174
G1 X149.134 Y109.554 E-.10181
G1 X149.033 Y109.802 E-.10174
G1 X149.01 Y109.885 E-.03271
; WIPE_END
G1 E-.04 F1800
G1 X143.983 Y115.628 Z4.088 F30000
G1 X126.014 Y136.157 Z4.088
G1 Z3.688
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.462 Y136.388 E.01548
G3 X120.204 Y109.827 I-4.74 J-12.863 E1.22647
G3 X121.853 Y109.864 I.486 J15.16 E.04271
G3 X126.515 Y135.95 I-1.13 J13.662 E.93057
G1 X126.069 Y136.134 E.01248
M204 S10000
G1 X126.181 Y136.533 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X126.147 Y136.548 E.00103
G3 X120.188 Y109.428 I-5.424 J-13.023 E1.37701
G3 X121.886 Y109.466 I.501 J15.601 E.04741
G3 X126.684 Y136.311 I-1.163 J14.06 E1.03238
G1 X126.235 Y136.509 E.01367
; WIPE_START
G1 X126.147 Y136.548 E-.03688
G1 X125.6 Y136.763 E-.22311
G1 X125.046 Y136.954 E-.223
G1 X124.483 Y137.123 E-.22314
G1 X124.346 Y137.158 E-.05387
; WIPE_END
G1 E-.04 F1800
G1 X129.515 Y131.542 Z4.088 F30000
G1 X150.424 Y108.824 Z4.088
G1 Z3.688
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.425 Y108.824 E.00001
G3 X151.064 Y108.669 I.75 J1.699 E.01712
G3 X151.336 Y108.675 I.11 J1.142 E.00704
G1 X151.504 Y108.695 E.00438
G3 X150.229 Y108.925 I-.329 J1.828 E.26779
G1 X150.371 Y108.852 E.00414
; WIPE_START
M204 S10000
G1 X150.425 Y108.824 E-.02297
G1 X150.631 Y108.747 E-.08372
G1 X150.845 Y108.695 E-.08376
G1 X151.064 Y108.669 E-.08379
G1 X151.336 Y108.675 E-.10313
G1 X151.504 Y108.695 E-.06427
G1 X151.718 Y108.747 E-.08378
G1 X151.924 Y108.824 E-.08373
G1 X152.121 Y108.924 E-.08377
G1 X152.267 Y109.023 E-.06709
; WIPE_END
G1 E-.04 F1800
G1 X152.413 Y116.654 Z4.088 F30000
G1 X152.811 Y137.411 Z4.088
G1 Z3.688
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.802 Y137.426 E.00046
G3 X151.064 Y134.672 I-1.628 J-.899 E.19962
G3 X151.336 Y134.678 I.11 J1.144 E.00704
G1 X151.504 Y134.698 E.00438
G3 X152.897 Y137.227 I-.329 J1.83 E.08559
G1 X152.837 Y137.356 E.00369
M204 S10000
G1 X153.551 Y137.504 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.251769
G1 F15000
G1 X153.531 Y137.578 E.00111
; LINE_WIDTH: 0.280405
G1 X153.512 Y137.652 E.00126
; LINE_WIDTH: 0.313444
G1 X153.461 Y137.799 E.00292
; LINE_WIDTH: 0.353304
G3 X153.097 Y138.299 I-1.319 J-.576 E.01333
; LINE_WIDTH: 0.318395
G1 X153.028 Y138.354 E.00168
; LINE_WIDTH: 0.287906
G1 X152.665 Y138.605 E.0075
G1 X152.589 Y138.611 F30000
; LINE_WIDTH: 0.228285
G1 F15000
G2 X153.481 Y138.109 I-7.937 J-15.124 E.01328
G1 X153.551 Y137.504 F30000
; LINE_WIDTH: 0.233874
G1 F15000
G1 X153.554 Y137.487 E.00023
; LINE_WIDTH: 0.206458
G1 X153.578 Y137.341 E.00171
; LINE_WIDTH: 0.15836
G1 X153.602 Y137.195 E.00123
; LINE_WIDTH: 0.111637
G1 X153.628 Y136.954 E.00124
G1 X153.627 Y136.098 F30000
; LINE_WIDTH: 0.0937713
G1 F15000
G1 X153.62 Y136.012 E.00034
; LINE_WIDTH: 0.118088
G1 X153.601 Y135.866 E.00082
; LINE_WIDTH: 0.158458
G1 X153.58 Y135.711 E.00129
; LINE_WIDTH: 0.184209
G1 X153.562 Y135.621 E.00092
G1 X153.452 Y135.447 E.00206
; LINE_WIDTH: 0.141064
G1 X153.449 Y135.442 E.00005
; LINE_WIDTH: 0.127455
G1 X153.378 Y135.344 E.00075
; LINE_WIDTH: 0.102125
G1 X153.308 Y135.246 E.00054
G1 X153.039 Y134.52 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.441226
G1 F12000
G1 X153.049 Y134.626 E.00292
G1 X153.207 Y134.812 E.00667
G1 X153.318 Y134.742 E.00358
G1 X153.447 Y134.778 E.00365
G1 X153.44 Y112.784 E.60065
G3 X153.426 Y112.165 I11.991 J-.577 E.01691
G1 X153.308 Y112.134 E.00334
G3 X152.928 Y112.539 I-1.784 J-1.29 E.01521
G1 X153.024 Y112.68 E.00464
G1 X153.037 Y112.784 E.00288
G1 X153.039 Y134.46 E.59197
G1 X151.771 Y133.99 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X150.175 Y134.118 I-.572 J2.882 E.04524
G1 X152.632 Y131.661 E.09696
G1 X152.632 Y130.744 E.0256
G1 X131.353 Y109.464 E.83966
G1 X128.773 Y109.464 E.07196
G1 X127.485 Y110.752 E.05083
G3 X131.74 Y114.174 I-7.148 J13.246 E.15318
G1 X136.451 Y109.463 E.18589
G1 X139.027 Y109.462 E.07187
G1 X152.632 Y123.068 E.53685
G1 X152.632 Y123.985 E.0256
G1 X139.022 Y137.595 E.53704
G1 X136.456 Y137.595 E.07158
G1 X131.734 Y132.873 E.18633
G3 X127.486 Y136.301 I-10.946 J-9.221 E.15324
G1 X128.78 Y137.595 E.05109
G1 X131.346 Y137.595 E.07158
G1 X152.632 Y116.309 E.83992
G1 X152.632 Y115.392 E.0256
G1 X150.177 Y112.936 E.09689
G2 X151.773 Y113.068 I1.034 J-2.787 E.04524
G1 X153.38 Y111.68 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.102116
G1 F15000
G1 X153.445 Y111.578 E.00054
; LINE_WIDTH: 0.127437
G1 X153.509 Y111.476 E.00075
; LINE_WIDTH: 0.168026
G2 X153.589 Y111.275 I-.475 J-.304 E.00195
; LINE_WIDTH: 0.147782
G1 X153.602 Y111.193 E.00063
; LINE_WIDTH: 0.111637
G1 X153.628 Y110.952 E.00124
G1 X153.627 Y110.096 F30000
; LINE_WIDTH: 0.0937628
G1 F15000
G1 X153.62 Y110.01 E.00034
; LINE_WIDTH: 0.11808
G1 X153.601 Y109.863 E.00082
; LINE_WIDTH: 0.158483
G1 X153.58 Y109.709 E.00129
; LINE_WIDTH: 0.195427
G1 X153.564 Y109.628 E.00088
; LINE_WIDTH: 0.226776
G1 X153.548 Y109.548 E.00105
; LINE_WIDTH: 0.266159
G1 X153.515 Y109.403 E.00231
; LINE_WIDTH: 0.311867
G1 X153.466 Y109.271 E.00261
; LINE_WIDTH: 0.352456
G2 X153.062 Y108.727 I-1.347 J.577 E.01459
; LINE_WIDTH: 0.304953
G2 X152.975 Y108.661 I-.83 J1.002 E.00198
; LINE_WIDTH: 0.27665
G1 X152.921 Y108.626 E.00104
; LINE_WIDTH: 0.246251
G1 X152.604 Y108.443 E.0052
G1 X152.551 Y108.453 F30000
; LINE_WIDTH: 0.163246
G1 F15000
G3 X153.349 Y108.779 I-5.501 J14.634 E.00742
; WIPE_START
G1 X152.551 Y108.453 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X151.841 Y108.298 Z4.088 F30000
G1 Z3.688
G1 E.8 F1800
; LINE_WIDTH: 0.493598
G1 F15000
G2 X150.508 Y108.298 I-.668 J4.701 E.04127
G1 X149.731 Y108.439 F30000
; LINE_WIDTH: 0.147295
G1 F15000
G1 X149.643 Y108.525 E.00092
; LINE_WIDTH: 0.127462
G1 X149.561 Y108.614 E.00075
; LINE_WIDTH: 0.102117
G1 X149.48 Y108.703 E.00054
G1 X149.078 Y108.893 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.442457
G1 F12000
G1 X148.962 Y108.764 E.00476
G1 X148.979 Y108.644 E.00333
G1 X121.916 Y108.65 E.74135
G2 X119.474 Y108.651 I-1.176 J75.561 E.06691
G1 X115.164 Y108.652 E.11806
G1 X113.921 Y108.812 E.03431
G2 X111.913 Y109.444 I1.381 J7.886 E.05784
G2 X110.178 Y110.484 I3.093 J7.132 E.05557
G1 X109.737 Y110.825 E.01528
G1 X109.146 Y111.387 E.02234
G1 X108.338 Y112.366 E.03477
G2 X107.189 Y114.607 I6.886 J4.946 E.06923
G2 X106.697 Y117.091 I9.048 J3.083 E.06958
G2 X106.679 Y118.731 I57.528 J1.471 E.04493
G1 X106.92 Y118.594 E.0076
G1 X107.046 Y118.632 E.00361
G1 X107.087 Y118.393 E.00663
G3 X107.248 Y115.923 I12.917 J-.401 E.06791
G1 X107.437 Y115.143 E.022
G1 X107.851 Y114.011 E.03302
G3 X109.713 Y111.396 I8.564 J4.128 E.08834
G3 X111.681 Y110 I6.698 J7.354 E.06625
G1 X112.806 Y109.526 E.03346
G1 X113.564 Y109.297 E.02169
G1 X114.776 Y109.1 E.03364
G1 X115.164 Y109.06 E.01068
G1 X119.48 Y109.059 E.11823
G3 X121.916 Y109.056 I1.249 J24.801 E.06676
G1 X148.959 Y109.052 E.74079
G1 X149.042 Y108.941 E.00381
G1 X148.33 Y109.46 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G1 X146.701 Y109.461 E.04543
G1 X148.759 Y111.518 E.08118
G2 X149.126 Y112.14 I2.579 J-1.103 E.02021
G1 X134.887 Y126.379 E.56185
G3 X134.479 Y127.942 I-23.151 J-5.208 E.04507
G1 X144.132 Y137.595 E.38092
G1 X146.698 Y137.595 E.07158
G1 X148.767 Y135.526 E.08165
G3 X149.125 Y134.912 I2.529 J1.063 E.01988
G1 X134.89 Y120.677 E.56168
G2 X134.473 Y119.116 I-12.433 J2.485 E.04511
G1 X144.129 Y109.461 E.38098
G1 X142.5 Y109.461 E.04543
; WIPE_START
G1 X144.129 Y109.461 E-.61876
G1 X143.866 Y109.724 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X136.235 Y109.886 Z4.088 F30000
G1 X114.777 Y110.342 Z4.088
G1 Z3.688
G1 E.8 F1800
G1 F16200
G3 X116.297 Y109.76 I10.012 J23.854 E.04542
G1 X116.004 Y109.467 E.01156
G2 X113.013 Y109.873 I-.348 J8.658 E.08465
G1 X107.914 Y114.972 E.2012
G2 X107.576 Y116.391 I10.923 J3.352 E.04072
G1 X107.938 Y116.753 E.01428
G3 X111.36 Y112.499 I12.88 J6.86 E.15323
G1 X110.285 Y111.424 E.04243
G2 X109.172 Y112.608 I6.596 J7.316 E.0454
G1 X107.033 Y119.297 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.512539
G1 F15000
G1 X106.72 Y119.497 E.01193
; LINE_WIDTH: 0.506283
G1 X106.7 Y119.646 E.00474
; LINE_WIDTH: 0.467525
G1 X106.681 Y119.794 E.00435
; LINE_WIDTH: 0.428767
G1 X106.662 Y119.942 E.00396
; LINE_WIDTH: 0.389104
G1 X106.641 Y120.097 E.00372
; LINE_WIDTH: 0.347166
G1 X106.62 Y120.296 E.00419
; LINE_WIDTH: 0.303584
G1 X106.598 Y120.494 E.00361
; LINE_WIDTH: 0.259541
G1 X106.576 Y120.697 E.00308
; LINE_WIDTH: 0.219767
G1 X106.558 Y120.896 E.00247
; LINE_WIDTH: 0.184545
G1 X106.54 Y121.095 E.002
; LINE_WIDTH: 0.149145
G1 X106.523 Y121.295 E.00154
; LINE_WIDTH: 0.110419
G1 X106.5 Y121.632 E.0017
G1 X106.5 Y125.427 F30000
; LINE_WIDTH: 0.11232
G1 F15000
G1 X106.523 Y125.741 E.00163
; LINE_WIDTH: 0.15806
G1 X106.547 Y126.055 E.0026
; LINE_WIDTH: 0.200928
G1 X106.567 Y126.257 E.00227
; LINE_WIDTH: 0.240742
G1 X106.587 Y126.456 E.00276
; LINE_WIDTH: 0.280227
G1 X106.607 Y126.655 E.0033
; LINE_WIDTH: 0.324376
G1 X106.631 Y126.859 E.004
; LINE_WIDTH: 0.372753
G1 X106.655 Y127.058 E.00454
; LINE_WIDTH: 0.420471
G1 X106.679 Y127.256 E.00518
; LINE_WIDTH: 0.465901
G1 X106.717 Y127.528 E.00795
; LINE_WIDTH: 0.506568
G1 X106.755 Y127.791 E.00842
G1 X106.961 Y128.179 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.443542
G1 F12000
G1 X106.681 Y128.219 E.00777
G2 X106.726 Y130.383 I20.946 J.641 E.05947
G2 X107.176 Y132.439 I12.126 J-1.574 E.05787
G2 X108.507 Y134.915 I9.418 J-3.467 E.07749
G2 X109.445 Y135.96 I11.561 J-9.427 E.03856
G2 X111.114 Y137.213 I7.217 J-7.88 E.05742
G2 X112.699 Y137.933 I5.919 J-10.922 E.04786
G1 X113.836 Y138.238 E.03232
G2 X115.586 Y138.411 I1.744 J-8.699 E.04838
G2 X121.623 Y138.415 I4.076 J-1556.835 E.16582
G1 X149.105 Y138.411 E.75484
G3 X149.171 Y138.291 I.116 J-.014 E.00401
G1 X148.959 Y138.003 E.00983
G1 X121.822 Y138.003 E.74536
G3 X119.611 Y138.003 I-1.106 J-18.261 E.06078
G1 X115.586 Y138.003 E.11055
G3 X113.941 Y137.845 I-.008 J-8.543 E.04545
G1 X112.805 Y137.54 E.03232
G3 X109.718 Y135.646 I3.024 J-8.393 E.10017
G1 X108.913 Y134.774 E.03259
G3 X108.037 Y133.409 I8.127 J-6.179 E.04459
G1 X107.563 Y132.284 E.03354
G1 X107.334 Y131.525 E.02175
G1 X107.142 Y130.348 E.03278
G3 X107.093 Y128.558 I16.078 J-1.329 E.04919
G1 X106.981 Y128.236 E.00938
G1 X109.17 Y134.446 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X110.291 Y135.623 I6.062 J-4.648 E.04542
G1 X111.362 Y134.552 E.04226
G3 X107.94 Y130.298 I9.765 J-11.358 E.15318
G1 X107.583 Y130.654 E.01406
G2 X107.91 Y132.077 I9.164 J-1.355 E.04076
G1 X113.013 Y137.18 E.20135
G2 X115.994 Y137.595 I2.712 J-8.546 E.08439
G1 X116.295 Y137.295 E.01186
G3 X114.776 Y136.709 I9.992 J-28.153 E.04541
; WIPE_START
G1 X116.295 Y137.295 E-.61841
G1 X116.031 Y137.558 E-.14159
; WIPE_END
G1 E-.04 F1800
G1 X123.661 Y137.761 Z4.088 F30000
G1 X149.591 Y138.449 Z4.088
G1 Z3.688
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.106865
G1 F15000
G1 X149.762 Y138.615 E.00114
G1 X150.511 Y138.763 F30000
; LINE_WIDTH: 0.489671
G1 F15000
G2 X151.838 Y138.763 I.663 J-5.133 E.04067
; CHANGE_LAYER
; Z_HEIGHT: 3.82595
; LAYER_HEIGHT: 0.137646
; WIPE_START
G1 F15000
G1 X151.162 Y138.806 E-.38731
G1 X150.511 Y138.763 E-.37269
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 21/33
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
G17
G3 Z4.088 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X154.052 Y138.203
G1 Z3.826
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X153.993 Y138.323 E.00293
G3 X152.629 Y139.165 I-1.437 J-.803 E.03667
G1 X115.566 Y139.165 E.81159
G3 X105.925 Y129.523 I.004 J-9.646 E.33161
G1 X105.925 Y117.529 E.26264
G3 X115.566 Y107.888 I9.646 J.004 E.33161
G1 X152.629 Y107.888 E.81159
G3 X154.202 Y109.478 I-.092 J1.664 E.0537
G1 X154.202 Y137.575 E.61525
G3 X154.095 Y138.105 I-1.646 J-.055 E.01191
G1 X154.076 Y138.148 E.00103
; WIPE_START
M204 S10000
G1 X153.993 Y138.323 E-.07357
G1 X153.87 Y138.515 E-.08674
G1 X153.731 Y138.675 E-.08058
G1 X153.573 Y138.818 E-.08063
G1 X153.225 Y139.026 E-.15415
G1 X153.04 Y139.094 E-.07491
G1 X152.85 Y139.139 E-.07434
G1 X152.629 Y139.165 E-.08463
G1 X152.496 Y139.165 E-.05046
; WIPE_END
G1 E-.04 F1800
G1 X151.925 Y131.554 Z4.226 F30000
G1 X150.195 Y108.486 Z4.226
G1 Z3.826
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G2 X152.154 Y108.486 I.98 J2.041 E.28762
G1 X152.201 Y108.293 E.00468
G3 X153.199 Y108.471 I.202 J1.756 E.02424
G3 X153.796 Y109.492 I-.654 J1.068 E.02905
G1 X153.796 Y137.561 E.66188
G3 X152.605 Y138.76 I-1.239 J-.04 E.04384
G1 X152.212 Y138.76 E.00929
G1 X152.161 Y138.574 E.00454
G2 X150.188 Y138.574 I-.986 J-2.041 E.28772
G1 X150.137 Y138.76 E.00454
G1 X115.571 Y138.76 E.81508
G3 X106.33 Y129.518 I.018 J-9.259 E.34211
G1 X106.33 Y117.534 E.28259
G3 X115.571 Y108.293 I9.259 J.018 E.34211
G1 X150.148 Y108.293 E.81533
G1 X150.181 Y108.428 E.00327
; WIPE_START
G1 X150.022 Y108.575 E-.08215
G1 X149.799 Y108.725 E-.1021
G1 X149.596 Y108.9 E-.10207
G1 X149.414 Y109.098 E-.10201
G1 X149.258 Y109.316 E-.10208
G1 X149.128 Y109.552 E-.10199
G1 X149.027 Y109.8 E-.10208
G1 X148.982 Y109.967 E-.06552
; WIPE_END
G1 E-.04 F1800
G1 X143.95 Y115.706 Z4.226 F30000
G1 X126.021 Y136.155 Z4.226
M73 P72 R5
G1 Z3.826
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X125.462 Y136.388 E.01326
G3 X120.156 Y109.828 I-4.742 J-12.863 E1.03676
G1 X120.713 Y109.816 E.0122
G3 X126.515 Y135.949 I.007 J13.709 E.81222
G1 X126.076 Y136.132 E.01041
M204 S10000
G1 X126.188 Y136.536 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X126.149 Y136.554 E.00102
G3 X120.14 Y109.423 I-5.429 J-13.029 E1.16329
G1 X120.713 Y109.411 E.01353
G3 X126.686 Y136.317 I.007 J14.114 E.9005
G1 X126.243 Y136.512 E.01142
; WIPE_START
G1 X126.149 Y136.554 E-.03919
G1 X125.602 Y136.768 E-.22322
G1 X125.034 Y136.964 E-.22833
G1 X124.485 Y137.129 E-.21801
G1 X124.354 Y137.162 E-.05125
; WIPE_END
G1 E-.04 F1800
G1 X129.521 Y131.545 Z4.226 F30000
G1 X150.424 Y108.824 Z4.226
G1 Z3.826
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.425 Y108.824 E.00001
G3 X151.064 Y108.669 I.75 J1.701 E.01449
G1 X151.285 Y108.669 E.00483
G3 X150.082 Y109.021 I-.11 J1.855 E.22774
G1 X150.372 Y108.854 E.00734
; WIPE_START
M204 S10000
G1 X150.425 Y108.824 E-.02298
G1 X150.631 Y108.747 E-.08373
G1 X150.845 Y108.695 E-.08377
G1 X151.064 Y108.669 E-.08378
G1 X151.285 Y108.669 E-.08374
G1 X151.504 Y108.695 E-.08378
G1 X151.718 Y108.747 E-.08372
G1 X151.924 Y108.824 E-.08378
G1 X152.121 Y108.924 E-.08378
G1 X152.267 Y109.023 E-.06695
; WIPE_END
G1 E-.04 F1800
G1 X152.413 Y116.654 Z4.226 F30000
G1 X152.812 Y137.41 Z4.226
G1 Z3.826
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.802 Y137.426 E.00042
G3 X151.064 Y134.672 I-1.628 J-.898 E.16891
G1 X151.285 Y134.672 E.00483
G3 X152.897 Y137.227 I-.11 J1.856 E.07725
G1 X152.837 Y137.355 E.00309
M204 S10000
G1 X153.526 Y137.479 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.132373
G1 F15000
G1 X153.545 Y137.366 E.00066
; LINE_WIDTH: 0.0998168
G1 X153.563 Y137.254 E.00045
G1 X153.586 Y137.288 F30000
; LINE_WIDTH: 0.193991
G1 F15000
G1 X153.525 Y137.5 E.00203
; LINE_WIDTH: 0.226546
G3 X153.436 Y137.783 I-1.771 J-.4 E.00328
; LINE_WIDTH: 0.271573
G3 X153.035 Y138.313 I-1.269 J-.543 E.00912
; LINE_WIDTH: 0.21985
G1 X152.731 Y138.533 E.00401
G1 X152.677 Y138.528 F30000
; LINE_WIDTH: 0.152333
G1 F15000
G2 X153.369 Y138.155 I-6.075 J-12.087 E.00542
G1 X153.405 Y138.102 F30000
; LINE_WIDTH: 0.150052
G1 F15000
G1 X153.526 Y137.479 E.00429
G1 X153.235 Y138.293 F30000
; LINE_WIDTH: 0.094433
G1 F15000
G1 X152.674 Y138.52 E.0022
G1 X151.986 Y138.704 F30000
; LINE_WIDTH: 0.472118
G1 F15000
G3 X151.697 Y138.747 I-.857 J-4.839 E.00725
; LINE_WIDTH: 0.437128
G3 X151.43 Y138.77 I-.526 J-4.515 E.00614
; LINE_WIDTH: 0.407407
G3 X150.896 Y138.768 I-.25 J-6.43 E.01131
; LINE_WIDTH: 0.441476
G3 X150.626 Y138.744 I.283 J-4.559 E.00627
; LINE_WIDTH: 0.472929
G1 X150.363 Y138.704 E.00661
; WIPE_START
G1 X150.626 Y138.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.19 Y138.329 Z4.226 F30000
G1 Z3.826
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.469819
G1 F12000
G3 X148.854 Y137.889 I1.397 J-1.412 E.01371
G1 X122.981 Y137.889 E.63885
; LINE_WIDTH: 0.456961
G1 X122.603 Y137.928 E.00911
; LINE_WIDTH: 0.431226
G1 X122.225 Y137.968 E.00856
; LINE_WIDTH: 0.389402
G3 X119.798 Y138.005 I-1.533 J-20.788 E.04901
; LINE_WIDTH: 0.408566
G1 X119.206 Y137.959 E.01262
; LINE_WIDTH: 0.464444
G3 X118.408 Y137.889 I.576 J-11.178 E.01954
G1 X115.587 Y137.889 E.06882
; LINE_WIDTH: 0.470895
G3 X113.212 Y137.544 I.279 J-10.257 E.05953
G1 X112.086 Y137.116 E.02983
G3 X108.994 Y134.679 I3.455 J-7.562 E.09838
G1 X108.536 Y134.046 E.01934
G1 X107.965 Y132.985 E.02982
G3 X107.214 Y129.938 I7.789 J-3.535 E.07812
G1 X107.207 Y128.97 E.02397
G1 X107.028 Y128.448 E.01366
G1 X106.763 Y128.485 E.00664
G2 X106.803 Y130.353 I19.847 J.508 E.04624
G1 X106.92 Y131.176 E.02059
G1 X107.246 Y132.391 E.03113
G2 X107.934 Y133.885 I7.279 J-2.448 E.04079
G2 X109.812 Y136.169 I7.655 J-4.378 E.07354
G1 X110.434 Y136.677 E.01987
G2 X112.651 Y137.816 I5.369 J-7.726 E.06189
G2 X114.297 Y138.229 I2.76 J-7.504 E.04208
G1 X115.587 Y138.329 E.03203
G1 X118.592 Y138.337 E.07439
; LINE_WIDTH: 0.439481
G1 X119.186 Y138.352 E.01365
; LINE_WIDTH: 0.393014
G2 X122.233 Y138.355 I1.584 J-56.575 E.06213
; LINE_WIDTH: 0.436629
G1 X122.848 Y138.336 E.01404
; LINE_WIDTH: 0.469777
G1 X149.13 Y138.329 E.64889
; WIPE_START
G1 X147.13 Y138.33 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X153.563 Y135.798 Z4.226 F30000
G1 Z3.826
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.0898976
G1 F15000
G1 X153.552 Y135.723 E.00026
; LINE_WIDTH: 0.115735
G1 X153.533 Y135.626 E.00048
; LINE_WIDTH: 0.153405
G2 X153.457 Y135.438 I-.409 J.057 E.00142
; LINE_WIDTH: 0.12183
G1 X153.386 Y135.339 E.00063
; LINE_WIDTH: 0.0963012
G1 X153.315 Y135.241 E.00045
G1 X151.79 Y113.073 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G3 X150.193 Y112.952 I-.579 J-2.948 E.03824
G1 X152.502 Y115.262 E.07702
G1 X152.502 Y116.439 E.02777
G1 X131.476 Y137.465 E.70117
G1 X128.65 Y137.465 E.06663
G1 X127.492 Y136.307 E.03864
G2 X131.745 Y132.884 I-6.801 J-12.805 E.12951
G1 X136.326 Y137.465 E.15278
G1 X139.152 Y137.465 E.06663
G1 X152.502 Y124.115 E.4452
G1 X152.502 Y122.937 E.02777
G1 X139.155 Y109.59 E.44509
G1 X136.322 Y109.591 E.0668
G1 X131.746 Y114.168 E.15262
G2 X127.491 Y110.746 I-11.065 J9.403 E.12951
G1 X128.644 Y109.594 E.03845
G1 X131.482 Y109.593 E.06691
G1 X152.502 Y130.613 E.70099
G1 X152.502 Y131.791 E.02777
G1 X150.189 Y134.105 E.07715
G3 X151.784 Y133.988 I1 J2.721 E.03822
G1 X153.363 Y112.436 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.468663
G1 F12000
G1 X153.214 Y112.465 E.00374
G1 X153.113 Y112.393 E.00305
G1 X152.913 Y112.57 E.0066
G1 X152.926 Y134.483 E.53964
G1 X153.215 Y134.783 E.01027
G3 X153.366 Y134.744 I.094 J.052 E.00428
G1 X153.363 Y112.496 E.5479
G1 X153.235 Y111.939 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.0962816
G1 F15000
G1 X153.312 Y111.845 E.00045
; LINE_WIDTH: 0.121773
G1 X153.388 Y111.75 E.00063
; LINE_WIDTH: 0.152108
G1 X153.489 Y111.61 E.00119
; LINE_WIDTH: 0.185472
G1 X153.586 Y111.475 E.00145
G1 X153.526 Y111.476 F30000
; LINE_WIDTH: 0.150052
G1 F15000
G1 X153.475 Y111.739 E.00181
G1 X153.526 Y111.476 F30000
; LINE_WIDTH: 0.132373
G1 F15000
G1 X153.545 Y111.364 E.00066
; LINE_WIDTH: 0.0998168
G1 X153.563 Y111.252 E.00045
G1 X153.563 Y109.796 F30000
; LINE_WIDTH: 0.0899089
G1 F15000
G1 X153.552 Y109.72 E.00026
; LINE_WIDTH: 0.118085
G1 X153.531 Y109.612 E.00055
; LINE_WIDTH: 0.160494
G1 X153.51 Y109.503 E.00081
; LINE_WIDTH: 0.193626
G1 X153.488 Y109.418 E.0008
; LINE_WIDTH: 0.220048
G1 X153.466 Y109.35 E.00077
; LINE_WIDTH: 0.258386
G2 X153.369 Y109.132 I-1.574 J.573 E.00306
; LINE_WIDTH: 0.275688
G2 X153.038 Y108.743 I-1.174 J.663 E.00709
; LINE_WIDTH: 0.220025
G1 X152.939 Y108.669 E.00132
; LINE_WIDTH: 0.181651
G1 X152.684 Y108.518 E.00253
G1 X152.678 Y108.532 F30000
; LINE_WIDTH: 0.0945713
G1 F15000
G1 X153.273 Y108.794 E.00237
; WIPE_START
G1 X152.678 Y108.532 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X151.98 Y108.343 Z4.226 F30000
G1 Z3.826
G1 E.8 F1800
; LINE_WIDTH: 0.459003
G1 F15000
G2 X151.564 Y108.294 I-1.035 J7.012 E.01011
; LINE_WIDTH: 0.416371
G2 X150.761 Y108.296 I-.388 J5.05 E.01743
; LINE_WIDTH: 0.460286
G1 X150.369 Y108.343 E.00955
G1 X149.689 Y108.522 F30000
; LINE_WIDTH: 0.101977
G1 F15000
G1 X149.607 Y108.551 E.00035
G1 X149.473 Y108.697 E.0008
G1 X148.963 Y108.724 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.469357
G1 F12000
G1 X123.073 Y108.732 E.6386
G1 X122.555 Y108.713 E.01277
; LINE_WIDTH: 0.415714
G1 X121.942 Y108.697 E.01328
; LINE_WIDTH: 0.383261
G2 X119.5 Y108.697 I-1.214 J78.078 E.04845
; LINE_WIDTH: 0.414389
G1 X118.888 Y108.713 E.01321
; LINE_WIDTH: 0.468682
G1 X118.346 Y108.733 E.01336
G1 X115.145 Y108.734 E.07884
G2 X113.039 Y109.097 I.429 J8.776 E.05275
G1 X111.954 Y109.501 E.02851
G2 X109.206 Y111.441 I4.2 J8.87 E.08326
G2 X106.762 Y117.54 I6.469 J6.131 E.16572
G2 X106.761 Y118.572 I203.64 J.81 E.02542
G1 X107.032 Y118.613 E.00676
G1 X107.202 Y118.129 E.01263
G3 X107.349 Y115.966 I14.671 J-.088 E.05346
G3 X112.108 Y109.913 I8.278 J1.611 E.19692
G1 X113.193 Y109.508 E.02852
G3 X115.151 Y109.175 I2.688 J9.87 E.04901
G1 X118.346 Y109.173 E.07868
G1 X118.901 Y109.113 E.01374
; LINE_WIDTH: 0.415224
G1 X119.503 Y109.066 E.01308
; LINE_WIDTH: 0.383259
G3 X121.915 Y109.066 I1.211 J25.761 E.04787
; LINE_WIDTH: 0.414854
G1 X122.518 Y109.112 E.01306
; LINE_WIDTH: 0.469347
G2 X123.073 Y109.172 I1.115 J-7.82 E.01377
G1 X148.85 Y109.164 E.63581
G1 X149.046 Y108.889 E.00833
G1 X148.959 Y108.784 E.00337
G1 X142.372 Y109.59 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G1 X144 Y109.589 E.0384
G1 X134.486 Y119.103 E.31727
G3 X134.901 Y120.688 I-29.89 J8.658 E.03863
G1 X149.119 Y134.906 E.47416
G2 X148.753 Y135.541 I2.169 J1.676 E.01733
G1 X146.828 Y137.465 E.06418
G1 X144.002 Y137.465 E.06663
G1 X134.487 Y127.95 E.31732
G2 X134.897 Y126.369 I-24.599 J-7.221 E.03852
G1 X149.12 Y112.145 E.47431
G3 X148.744 Y111.503 I5.782 J-3.818 E.01756
G1 X146.829 Y109.588 E.06385
G1 X148.457 Y109.588 E.0384
; WIPE_START
G1 X146.829 Y109.588 E-.61876
G1 X147.092 Y109.851 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X139.481 Y110.424 Z4.226 F30000
G1 X109.263 Y112.7 Z4.226
G1 Z3.826
G1 E.8 F1800
G1 F16200
G3 X110.378 Y111.517 I36.719 J33.496 E.03834
G1 X111.354 Y112.494 E.03257
G2 X107.932 Y116.747 I9.463 J11.119 E.1295
G1 X107.695 Y116.51 E.0079
G3 X108.132 Y114.753 I11.01 J1.809 E.04273
G1 X112.791 Y110.095 E.15534
G3 X116.134 Y109.597 I2.975 J8.493 E.08018
G1 X116.29 Y109.754 E.00523
G2 X114.771 Y110.336 I8.682 J24.912 E.03838
; WIPE_START
G1 X116.29 Y109.754 E-.61837
G1 X116.134 Y109.597 E-.08425
G1 X115.983 Y109.597 E-.05738
; WIPE_END
G1 E-.04 F1800
G1 X110.661 Y115.068 Z4.226 F30000
G1 X106.822 Y119.017 Z4.226
G1 Z3.826
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.50099
G1 F15000
G1 X106.785 Y119.255 E.00637
; LINE_WIDTH: 0.464662
G1 X106.748 Y119.502 E.00609
; LINE_WIDTH: 0.425583
G1 X106.729 Y119.651 E.00334
; LINE_WIDTH: 0.386639
G1 X106.709 Y119.8 E.00301
; LINE_WIDTH: 0.347695
G1 X106.69 Y119.949 E.00268
; LINE_WIDTH: 0.30805
G1 X106.669 Y120.103 E.00243
; LINE_WIDTH: 0.266186
G1 X106.648 Y120.302 E.00265
; LINE_WIDTH: 0.222591
G1 X106.626 Y120.5 E.00216
; LINE_WIDTH: 0.178706
G1 X106.604 Y120.702 E.0017
; LINE_WIDTH: 0.13838
G1 X106.584 Y120.922 E.00135
; LINE_WIDTH: 0.101819
G1 X106.565 Y121.141 E.00089
G1 X106.565 Y125.916 F30000
; LINE_WIDTH: 0.0920578
G1 F15000
G1 X106.576 Y126.052 E.00048
; LINE_WIDTH: 0.120392
G1 X106.596 Y126.252 E.00102
; LINE_WIDTH: 0.159923
G1 X106.615 Y126.451 E.00146
; LINE_WIDTH: 0.199307
G1 X106.635 Y126.649 E.0019
; LINE_WIDTH: 0.243287
G1 X106.659 Y126.852 E.00245
; LINE_WIDTH: 0.291559
G1 X106.683 Y127.051 E.00294
; LINE_WIDTH: 0.339359
G1 X106.707 Y127.25 E.00348
; LINE_WIDTH: 0.383543
G1 X106.736 Y127.453 E.00407
; LINE_WIDTH: 0.422513
G1 X106.763 Y127.649 E.00436
; LINE_WIDTH: 0.460796
G1 X106.791 Y127.845 E.00479
; LINE_WIDTH: 0.499078
G1 X106.819 Y128.04 E.00521
; WIPE_START
G1 X106.791 Y127.845 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X111.895 Y133.519 Z4.226 F30000
G1 X114.77 Y136.715 Z4.226
G1 Z3.826
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G2 X116.288 Y137.301 I11.624 J-27.841 E.03838
G1 X116.124 Y137.465 E.00547
G3 X112.791 Y136.958 I-.301 J-9.22 E.07996
G1 X108.132 Y132.299 E.15535
G3 X107.695 Y130.543 I10.72 J-3.601 E.04272
G1 X107.934 Y130.304 E.00797
G2 X111.356 Y134.558 I13.206 J-7.12 E.12946
G1 X110.377 Y135.536 E.03263
G3 X109.262 Y134.353 I42.733 J-41.382 E.03834
; CHANGE_LAYER
; Z_HEIGHT: 3.96773
; LAYER_HEIGHT: 0.141784
; WIPE_START
G1 F16200
G1 X109.818 Y135.004 E-.32524
G1 X110.377 Y135.536 E-.29344
G1 X110.64 Y135.273 E-.14133
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 22/33
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
G17
G3 Z4.226 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X153.997 Y138.18
G1 Z3.968
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X153.988 Y138.198 E.00044
G3 X152.561 Y139.101 I-1.426 J-.674 E.0401
G1 X115.566 Y139.101 E.83256
G3 X105.989 Y129.523 I.004 J-9.581 E.33854
G1 X105.989 Y117.529 E.26992
G3 X115.566 Y107.952 I9.601 J.023 E.33835
G1 X152.686 Y107.954 E.83537
G3 X154.139 Y109.484 I-.134 J1.582 E.05194
G1 X154.139 Y137.569 E.63204
G3 X154.078 Y137.957 I-1.576 J-.045 E.00888
G1 X154.017 Y138.124 E.00399
; WIPE_START
M204 S10000
G1 X153.988 Y138.198 E-.03025
G1 X153.846 Y138.441 E-.10693
G1 X153.587 Y138.725 E-.14618
G1 X153.248 Y138.947 E-.15388
G1 X153.066 Y139.019 E-.07431
G1 X152.877 Y139.07 E-.07434
G1 X152.561 Y139.101 E-.1208
G1 X152.421 Y139.101 E-.05331
; WIPE_END
G1 E-.04 F1800
G1 X151.839 Y131.491 Z4.368 F30000
G1 X150.083 Y108.534 Z4.368
G1 Z3.968
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X149.852 Y108.69 E.00677
G2 X152.266 Y108.534 I1.331 J1.833 E.28306
G1 X152.32 Y108.356 E.00452
G3 X153.624 Y109.03 I.173 J1.263 E.0379
G3 X153.734 Y109.497 I-1.416 J.58 E.01166
G1 X153.734 Y137.556 E.6801
G3 X152.557 Y138.696 I-1.194 J-.055 E.04377
G1 X152.316 Y138.696 E.00584
G1 X152.265 Y138.511 E.00466
G2 X150.084 Y138.511 I-1.091 J-1.983 E.28945
G1 X150.033 Y138.696 E.00466
G1 X115.571 Y138.696 E.83528
G3 X106.393 Y129.518 I-.001 J-9.177 E.34944
G1 X106.393 Y117.534 E.29047
G3 X115.571 Y108.356 I9.196 J.018 E.34925
G1 X150.029 Y108.356 E.83518
G1 X150.066 Y108.477 E.00306
M204 S250
G1 X150.425 Y108.824 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.631 Y108.747 E.00495
G3 X151.064 Y108.669 I.543 J1.778 E.00993
G1 X151.285 Y108.669 E.00496
G3 X150.371 Y108.849 I-.11 J1.855 E.24164
; WIPE_START
M204 S10000
G1 X150.631 Y108.747 E-.10625
G1 X150.845 Y108.695 E-.08379
G1 X151.064 Y108.669 E-.08379
G1 X151.285 Y108.669 E-.08373
G1 X151.504 Y108.695 E-.0838
G1 X151.718 Y108.747 E-.08371
G1 X151.924 Y108.824 E-.08379
G1 X152.121 Y108.924 E-.08376
G1 X152.268 Y109.024 E-.06739
; WIPE_END
G1 E-.04 F1800
G1 X152.414 Y116.655 Z4.368 F30000
G1 X152.812 Y137.409 Z4.368
G1 Z3.968
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X152.802 Y137.426 E.00045
G3 X151.064 Y134.672 I-1.627 J-.899 E.17353
G1 X151.285 Y134.672 E.00496
G3 X152.896 Y137.227 I-.11 J1.855 E.07938
G1 X152.838 Y137.354 E.00316
M204 S10000
G1 X153.502 Y137.433 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.0871166
G1 F15000
G3 X153.38 Y138.027 I-9.851 J-1.707 E.00199
G1 X153.41 Y137.767 F30000
; LINE_WIDTH: 0.160094
G1 F15000
G2 X153.512 Y137.435 I-4.462 J-1.555 E.0026
G1 X153.41 Y137.767 F30000
; LINE_WIDTH: 0.213072
G1 F15000
G3 X153.042 Y138.267 I-1.241 J-.526 E.00661
; LINE_WIDTH: 0.170455
G1 X152.795 Y138.454 E.00251
G1 X152.095 Y138.655 F30000
; LINE_WIDTH: 0.441468
G1 F15000
G1 X151.904 Y138.684 E.00458
; LINE_WIDTH: 0.414453
G3 X151.692 Y138.715 I-.635 J-3.601 E.00477
; LINE_WIDTH: 0.374632
G3 X151.428 Y138.738 I-.522 J-4.476 E.00526
; LINE_WIDTH: 0.345038
G3 X150.902 Y138.737 I-.249 J-6.371 E.00956
; LINE_WIDTH: 0.378321
G3 X150.635 Y138.712 I.274 J-4.456 E.00538
; LINE_WIDTH: 0.416044
G1 X150.445 Y138.684 E.0043
; LINE_WIDTH: 0.441479
G1 X150.254 Y138.655 E.00458
G1 X149.611 Y138.471 F30000
; LINE_WIDTH: 0.113734
G1 F15000
G1 X149.517 Y138.435 E.00049
G1 X149.369 Y138.254 E.00112
; WIPE_START
G1 X149.517 Y138.435 E-.5303
G1 X149.611 Y138.471 E-.2297
; WIPE_END
G1 E-.04 F1800
G1 X153.502 Y135.634 Z4.368 F30000
G1 Z3.968
G1 E.8 F1800
; LINE_WIDTH: 0.0990881
G1 F15000
G1 X153.485 Y135.546 E.00036
; LINE_WIDTH: 0.130562
G2 X153.456 Y135.438 I-.161 J-.014 E.00066
; LINE_WIDTH: 0.12263
G1 X153.385 Y135.34 E.00065
; LINE_WIDTH: 0.0971584
G1 X153.314 Y135.242 E.00047
G1 X152.151 Y133.493 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G1 X152.151 Y133.687 E.00471
G2 X150.738 Y133.555 I-.981 J2.878 E.03473
G1 X152.151 Y132.142 E.04845
G1 X152.151 Y130.263 E.04556
G1 X131.828 Y109.939 E.69665
G1 X128.299 Y109.939 E.08552
G1 X127.552 Y110.686 E.0256
G1 X127.677 Y110.751 E.00342
G3 X131.804 Y114.11 I-7.054 J12.88 E.12969
G1 X135.975 Y109.939 E.14298
G1 X139.504 Y109.939 E.08553
G1 X152.151 Y122.587 E.43354
G1 X152.151 Y124.466 E.04556
M73 P73 R5
G1 X139.503 Y137.114 E.43354
G1 X135.975 Y137.114 E.08552
G1 X131.803 Y132.942 E.143
G1 X131.676 Y133.093 E.00478
G3 X127.552 Y136.367 I-11.298 J-10 E.12829
G1 X128.299 Y137.114 E.02561
G1 X131.828 Y137.114 E.08552
G1 X152.151 Y116.79 E.69665
G1 X152.151 Y114.911 E.04556
G1 X150.741 Y113.501 E.04833
G2 X152.151 Y113.369 I.428 J-3.037 E.03464
G1 X152.151 Y113.567 E.0048
G1 X153.234 Y111.938 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.0971915
G1 F15000
G1 X153.311 Y111.844 E.00047
; LINE_WIDTH: 0.122715
G1 X153.387 Y111.75 E.00065
; LINE_WIDTH: 0.155376
G1 X153.524 Y111.559 E.00169
G1 X153.502 Y111.431 F30000
; LINE_WIDTH: 0.0877631
G1 F15000
G3 X153.435 Y111.777 I-5.542 J-.891 E.00117
G1 X153.502 Y109.632 F30000
; LINE_WIDTH: 0.104076
G1 F15000
G1 X153.478 Y109.505 E.00055
; LINE_WIDTH: 0.139742
G1 X153.453 Y109.408 E.00063
; LINE_WIDTH: 0.176106
G1 X153.408 Y109.288 E.00108
; LINE_WIDTH: 0.214515
G1 X153.344 Y109.15 E.00161
G2 X153.041 Y108.788 I-1.151 J.653 E.00505
; LINE_WIDTH: 0.168839
G2 X152.937 Y108.706 I-.52 J.555 E.00106
; LINE_WIDTH: 0.131339
G1 X152.774 Y108.608 E.00111
G1 X152.094 Y108.404 F30000
; LINE_WIDTH: 0.447961
G1 F15000
G2 X151.824 Y108.356 I-.951 J4.588 E.0066
; LINE_WIDTH: 0.420814
G1 X151.702 Y108.342 E.00277
; LINE_WIDTH: 0.389371
G1 X151.56 Y108.326 E.00298
; LINE_WIDTH: 0.3539
G2 X150.769 Y108.327 I-.384 J4.977 E.0148
; LINE_WIDTH: 0.391724
G1 X150.647 Y108.342 E.00257
; LINE_WIDTH: 0.439567
G1 X150.524 Y108.356 E.00291
G2 X150.255 Y108.404 I.669 J4.559 E.00646
G1 X149.595 Y108.566 F30000
; LINE_WIDTH: 0.0961033
G1 F15000
G1 X149.474 Y108.698 E.00068
G1 X148.651 Y109.768 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.370427
G1 F12000
G1 X148.548 Y110.275 E.01016
G1 X148.562 Y110.897 E.01222
G1 X148.722 Y111.5 E.01226
G1 X149.02 Y112.049 E.01226
G1 X149.438 Y112.512 E.01226
G1 X149.953 Y112.865 E.01226
G1 X150.533 Y113.086 E.01221
G1 X151.155 Y113.165 E.01231
G1 X151.775 Y113.095 E.01226
G1 X152.242 Y112.929 E.00973
G1 X153.017 Y134.597 F30000
; LINE_WIDTH: 0.41927
G1 F12000
G1 X153.21 Y134.818 E.00659
G1 X153.329 Y134.769 E.00289
G1 X153.325 Y112.417 E.50209
G1 X153.18 Y112.415 E.00327
G1 X153.105 Y112.354 E.00216
G1 X152.9 Y112.563 E.00659
G1 X152.366 Y112.892 E.01409
G1 X152.549 Y113.047 E.00538
G1 X152.55 Y113.066 E.00044
G1 X152.55 Y133.987 E.46993
G1 X152.488 Y134.115 E.00321
G1 X152.312 Y134.154 E.00403
G1 X152.549 Y134.246 E.00569
G1 X152.969 Y134.561 E.01181
; WIPE_START
G1 X152.549 Y134.246 E-.19977
G1 X152.312 Y134.154 E-.09634
G1 X152.488 Y134.115 E-.06814
G1 X152.55 Y133.987 E-.05431
G1 X152.55 Y133.088 E-.34144
; WIPE_END
G1 E-.04 F1800
G1 X151.364 Y125.548 Z4.368 F30000
G1 X148.811 Y109.318 Z4.368
G1 Z3.968
G1 E.8 F1800
; LINE_WIDTH: 0.419639
G1 F12000
G3 X149.082 Y108.887 I1.864 J.867 E.01149
G1 X148.997 Y108.808 E.00259
G1 X148.997 Y108.761 E.00105
G1 X124.061 Y108.769 E.56067
G3 X125.763 Y109.259 I-3.004 J13.618 E.03986
G1 X125.998 Y109.455 E.00686
G1 X126.011 Y109.54 E.00195
G1 X148.488 Y109.54 E.50538
G1 X148.658 Y109.697 E.00521
G1 X148.651 Y109.768 E.00159
G1 X148.791 Y109.375 E.00937
G1 X126.242 Y109.154 F30000
; LINE_WIDTH: 0.416557
G1 F12000
G1 X148.399 Y109.151 E.49424
G1 X152.938 Y134.045 F30000
; LINE_WIDTH: 0.418376
G1 F12000
G1 X152.938 Y113.068 E.47011
G1 X148.648 Y137.283 F30000
; LINE_WIDTH: 0.370535
G1 F12000
G1 X148.537 Y136.624 E.01312
G1 X148.589 Y136.004 E.01222
G1 X148.784 Y135.411 E.01226
G1 X149.114 Y134.881 E.01226
G1 X149.558 Y134.443 E.01226
G1 X150.095 Y134.121 E.01231
G1 X150.689 Y133.935 E.01222
G1 X151.311 Y133.894 E.01226
G1 X151.989 Y134.029 E.01357
G1 X152.257 Y134.132 E.00563
; WIPE_START
G1 X151.989 Y134.029 E-.10894
G1 X151.311 Y133.894 E-.26255
G1 X150.689 Y133.935 E-.23709
G1 X150.309 Y134.054 E-.15142
; WIPE_END
G1 E-.04 F1800
G1 X142.763 Y135.203 Z4.368 F30000
G1 X125.761 Y137.793 Z4.368
G1 Z3.968
G1 E.8 F1800
; LINE_WIDTH: 0.419635
G1 F12000
G3 X124.029 Y138.292 I-5.232 J-14.906 E.04055
G1 X148.873 Y138.292 E.55858
G1 X148.864 Y138.157 E.00303
G1 X148.99 Y138.041 E.00385
G1 X148.795 Y137.721 E.00842
G1 X148.648 Y137.283 E.0104
G1 X148.485 Y137.512 E.00633
G1 X126.008 Y137.512 E.50536
G1 X125.985 Y137.612 E.00231
G1 X125.808 Y137.755 E.0051
G1 X126.246 Y137.902 F30000
; LINE_WIDTH: 0.420377
G1 F12000
G1 X148.388 Y137.902 E.49879
G1 X122.267 Y138.436 F30000
; LINE_WIDTH: 0.370427
G1 F12000
G2 X123.473 Y138.349 I-1.408 J-27.797 E.02375
G1 X119.156 Y138.436 F30000
G1 F12000
G3 X117.997 Y138.353 I1.426 J-28.003 E.02282
G1 X111.04 Y134.384 F30000
; LINE_WIDTH: 0.419997
G1 F12000
G3 X108.037 Y130.638 I9.647 J-10.81 E.10856
G1 X107.983 Y130.778 E.00337
G1 X107.781 Y130.934 E.00576
G1 X107.607 Y130.897 E.00399
G1 X107.387 Y130.697 E.00669
G3 X106.808 Y129.496 I12.552 J-6.789 E.03002
G1 X106.837 Y130.349 E.01921
G2 X106.987 Y131.298 I14.83 J-1.862 E.02163
G1 X107.28 Y132.393 E.02551
G2 X109.218 Y135.573 I8.558 J-3.034 E.08441
G1 X110.143 Y136.414 E.02814
G1 X111.179 Y137.116 E.02814
G1 X112.306 Y137.663 E.0282
G2 X115.581 Y138.292 I3.266 J-8.171 E.07551
G1 X117.393 Y138.292 E.04078
G3 X115.669 Y137.794 I3.09 J-13.943 E.04041
G1 X115.433 Y137.604 E.00682
G1 X115.371 Y137.427 E.00422
G1 X115.475 Y137.221 E.00519
G1 X115.611 Y137.142 E.00355
G3 X111.086 Y134.423 I5.172 J-13.732 E.11946
G1 X110.787 Y134.68 F30000
G1 F12000
G3 X107.953 Y131.277 I10.044 J-11.244 E.10003
G1 X107.781 Y131.328 E.00404
G1 X107.364 Y131.199 E.00982
G1 X107.651 Y132.27 E.02493
G2 X109.498 Y135.3 I8.163 J-2.896 E.08045
G1 X110.385 Y136.107 E.02699
G1 X111.374 Y136.777 E.02689
G1 X112.455 Y137.303 E.02705
G2 X115.165 Y137.882 I3.026 J-7.527 E.06267
G1 X114.996 Y137.599 E.00743
G2 X114.977 Y137.312 I-.915 J-.085 E.0065
G3 X110.833 Y134.719 I5.727 J-13.764 E.11051
G1 X109.673 Y134.853 F30000
; LINE_WIDTH: 0.491826
G1 F12000
G2 X110.641 Y135.754 I12.71 J-12.684 E.03525
G2 X111.774 Y136.516 I8.466 J-11.367 E.03641
; LINE_WIDTH: 0.439637
G1 X112.335 Y136.812 E.01498
; LINE_WIDTH: 0.405797
G1 X112.644 Y136.952 E.00737
; LINE_WIDTH: 0.379837
G1 X112.954 Y137.091 E.00686
; LINE_WIDTH: 0.341814
G2 X114.475 Y137.47 I2.633 J-7.328 E.02825
G3 X113.132 Y136.806 I9.96 J-21.848 E.02697
; LINE_WIDTH: 0.375857
G1 X112.846 Y136.651 E.00649
; LINE_WIDTH: 0.402737
G1 X112.561 Y136.495 E.007
; LINE_WIDTH: 0.436442
G1 X112.029 Y136.17 E.01461
; LINE_WIDTH: 0.490481
G3 X109.636 Y134.147 I7.043 J-10.76 E.08348
; LINE_WIDTH: 0.458612
G1 X109.299 Y133.759 E.01272
; LINE_WIDTH: 0.405667
G3 X108.049 Y132.13 I23.372 J-19.223 E.04451
G1 X107.992 Y132.074 E.00175
G2 X108.842 Y133.822 I7.883 J-2.754 E.04225
; LINE_WIDTH: 0.445282
G1 X109.235 Y134.352 E.01581
; LINE_WIDTH: 0.479242
G1 X109.634 Y134.808 E.0157
; WIPE_START
G1 X109.235 Y134.352 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z4.368 I1.185 J.275 P1  F30000
G1 X114.834 Y110.226 Z4.368
G1 Z3.968
G1 E.8 F1800
; LINE_WIDTH: 0.419997
G1 F12000
G1 X115.618 Y109.916 E.01898
G1 X115.474 Y109.833 E.00375
G1 X115.368 Y109.582 E.00611
G1 X115.429 Y109.455 E.00318
G1 X115.663 Y109.26 E.00686
G3 X117.355 Y108.771 I5.228 J14.928 E.03967
G1 X115.141 Y108.771 E.04983
G2 X113.907 Y108.92 I.874 J12.508 E.02799
G1 X112.697 Y109.243 E.02819
G2 X110.149 Y110.634 I2.993 J8.515 E.06562
G1 X109.22 Y111.478 E.02823
G2 X107.774 Y113.508 I7.231 J6.681 E.05626
G1 X107.28 Y114.66 E.02819
G2 X106.888 Y116.277 I8.27 J2.863 E.0375
G1 X106.798 Y117.573 E.02924
G3 X107.351 Y116.419 I13.626 J5.82 E.0288
G1 X107.604 Y116.16 E.00816
G1 X107.75 Y116.109 E.00349
G1 X107.972 Y116.238 E.00578
G1 X108.042 Y116.398 E.00392
G3 X113.471 Y110.927 I12.549 J7.024 E.1756
G3 X114.78 Y110.252 I6.001 J10.014 E.03316
G1 X118.19 Y108.687 F30000
; LINE_WIDTH: 0.370427
G1 F12000
G3 X119.041 Y108.629 I1.753 J19.418 E.01675
G1 X122.325 Y108.625 F30000
G1 F12000
G1 X123.12 Y108.678 E.01566
G1 X115.02 Y109.733 F30000
; LINE_WIDTH: 0.419997
G1 F12000
G3 X114.997 Y109.446 I.335 J-.171 E.00665
G1 X115.172 Y109.161 E.00753
G2 X113.985 Y109.302 I.745 J11.356 E.02691
G1 X112.82 Y109.614 E.02715
G2 X110.395 Y110.937 I2.851 J8.11 E.06244
G1 X109.499 Y111.75 E.02723
G2 X108.123 Y113.683 I6.898 J6.37 E.05354
G1 X107.648 Y114.792 E.02714
G1 X107.425 Y115.552 E.01783
G1 X107.365 Y115.859 E.00705
G1 X107.604 Y115.734 E.00608
G3 X107.949 Y115.785 I.118 J.397 E.00809
G3 X113.271 Y110.593 I12.69 J7.685 E.16911
G3 X114.965 Y109.755 I6.302 J10.609 E.04258
G1 X113.932 Y109.812 F30000
; LINE_WIDTH: 0.377617
G1 F12000
G1 X114.332 Y109.624 E.00886
G2 X112.927 Y109.968 I4.32 J20.709 E.02902
; LINE_WIDTH: 0.392312
G1 X112.593 Y110.117 E.00765
; LINE_WIDTH: 0.421702
G1 X112.259 Y110.267 E.00827
; LINE_WIDTH: 0.457252
G1 X111.59 Y110.634 E.0188
; LINE_WIDTH: 0.49757
G2 X109.488 Y112.405 I5.074 J8.156 E.07446
; LINE_WIDTH: 0.464452
G1 X109.066 Y112.925 E.01678
; LINE_WIDTH: 0.424257
G1 X108.685 Y113.47 E.01512
; LINE_WIDTH: 0.372954
G1 X108.361 Y114.049 E.01312
G1 X107.99 Y114.915 E.01864
G1 X107.923 Y115.144 E.00473
G3 X108.961 Y113.716 I19.64 J13.185 E.03493
; LINE_WIDTH: 0.420687
G1 X109.36 Y113.221 E.01435
; LINE_WIDTH: 0.462107
G1 X109.786 Y112.745 E.01592
; LINE_WIDTH: 0.496772
G3 X111.723 Y111.083 I8.881 J8.39 E.06888
; LINE_WIDTH: 0.462912
G1 X112.26 Y110.734 E.016
; LINE_WIDTH: 0.427942
G1 X112.67 Y110.506 E.01079
; LINE_WIDTH: 0.383325
G3 X113.88 Y109.841 I50.308 J90 E.02814
G1 X115.723 Y110.099 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.421047
G1 F3000
G1 X115.723 Y136.768 E.60178
G1 X115.332 Y136.614 E.00947
G1 X115.332 Y110.44 E.59062
G1 X114.942 Y110.606 E.00957
G1 X114.942 Y136.445 E.58307
G1 X114.551 Y136.263 E.00972
G1 X114.551 Y110.788 E.57486
G1 X114.161 Y110.986 E.00988
G1 X114.161 Y136.069 E.56601
G1 X113.77 Y135.856 E.01004
G1 X113.77 Y111.202 E.55632
G3 X113.43 Y111.402 I-4.985 J-8.112 E.00889
G1 X113.379 Y111.434 E.00135
G1 X113.379 Y135.626 E.54591
G1 X112.989 Y135.381 E.01041
G1 X112.989 Y111.672 E.53501
G1 X112.598 Y111.935 E.01064
G1 X112.598 Y135.118 E.52313
G1 X112.207 Y134.837 E.01086
G1 X112.207 Y112.22 E.51037
G1 X111.817 Y112.524 E.01117
G1 X111.817 Y134.53 E.49658
G1 X111.426 Y134.201 E.01152
G1 X111.426 Y112.85 E.48179
G1 X111.036 Y113.202 E.01186
G1 X111.036 Y133.848 E.46589
G3 X110.645 Y133.467 I4.376 J-4.88 E.01231
G1 X110.645 Y113.581 E.44873
G1 X110.254 Y113.993 E.0128
G1 X110.254 Y133.055 E.43015
G3 X109.864 Y132.608 I5.172 J-4.912 E.0134
G1 X109.864 Y114.44 E.40998
G1 X109.473 Y114.929 E.01412
G1 X109.473 Y132.12 E.38793
G3 X109.082 Y131.584 I6.24 J-4.96 E.01497
G1 X109.082 Y115.467 E.36369
G1 X108.692 Y116.064 E.0161
G1 X108.692 Y130.992 E.33685
G3 X108.301 Y130.321 I16.845 J-10.253 E.01752
G1 X108.301 Y116.733 E.30661
G1 X108.176 Y116.956 E.00577
G1 X107.911 Y116.873 E.00628
G1 X107.911 Y130.183 E.30034
G1 X107.621 Y130.27 E.00682
G1 X107.625 Y130.316 E.00105
G1 X107.52 Y130.111 E.00521
G1 X107.52 Y116.945 E.29709
G1 X107.129 Y117.791 E.02102
G1 X107.129 Y129.258 E.25876
G1 X106.746 Y128.248 E.02438
G1 X106.739 Y118.3 E.22448
; WIPE_START
G1 X106.74 Y120.3 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X111.7 Y114.498 Z4.368 F30000
G1 X116.114 Y109.334 Z4.368
G1 Z3.968
G1 E.8 F1800
G1 F3000
G1 X116.114 Y137.536 E.63638
G1 X116.504 Y137.656 E.00922
G1 X116.504 Y109.394 E.63776
G1 X116.895 Y109.285 E.00915
G1 X116.895 Y137.767 E.64271
G1 X117.285 Y137.867 E.0091
G1 X117.285 Y109.187 E.64719
G1 X117.676 Y109.096 E.00905
G1 X117.676 Y137.954 E.65118
G1 X118.067 Y138.032 E.00899
M73 P73 R4
G1 X118.067 Y109.022 E.65462
G1 X118.457 Y108.956 E.00894
G1 X118.457 Y138.097 E.65759
G1 X118.848 Y138.151 E.0089
G1 X118.848 Y108.899 E.6601
G1 X119.239 Y108.857 E.00887
M73 P74 R4
G1 X119.239 Y138.198 E.66209
G1 X119.629 Y138.23 E.00885
G1 X119.629 Y108.822 E.66361
G1 X120.02 Y108.798 E.00883
G1 X120.02 Y138.254 E.66468
G1 X120.41 Y138.27 E.00882
G1 X120.41 Y108.786 E.66531
G1 X120.801 Y108.782 E.00882
G1 X120.801 Y138.27 E.66541
G1 X121.192 Y138.263 E.00882
G1 X121.192 Y108.79 E.66507
G1 X121.582 Y108.808 E.00882
G1 X121.582 Y138.246 E.66428
G1 X121.973 Y138.216 E.00884
G1 X121.973 Y108.834 E.66301
G1 X122.364 Y108.875 E.00886
G1 X122.364 Y138.178 E.66124
G1 X122.754 Y138.129 E.00888
G1 X122.754 Y108.924 E.65902
G1 X123.145 Y108.982 E.00891
G1 X123.145 Y138.068 E.65634
G1 X123.535 Y137.998 E.00895
G1 X123.535 Y109.056 E.65311
G1 X123.926 Y109.137 E.009
G1 X123.926 Y137.916 E.64943
G1 X124.317 Y137.823 E.00906
G1 X124.317 Y109.228 E.64526
G1 X124.707 Y109.334 E.00914
G1 X124.707 Y137.721 E.64056
G1 X125.098 Y137.604 E.0092
G1 X125.098 Y109.449 E.63532
G1 X125.388 Y109.543 E.00688
G1 X125.283 Y110.131 E.01348
G1 X125.488 Y110.207 E.00495
G1 X125.488 Y136.846 E.60112
G1 X125.879 Y136.699 E.00942
G1 X125.879 Y110.351 E.59454
G3 X126.27 Y110.514 I-1.747 J4.753 E.00955
G1 X126.27 Y136.54 E.58729
G1 X126.66 Y136.367 E.00964
G1 X126.66 Y110.688 E.57946
G3 X127.051 Y110.875 I-2.098 J4.894 E.00977
G1 X127.051 Y136.177 E.57096
G1 X127.442 Y135.973 E.00994
G1 X127.442 Y111.077 E.56179
G3 X127.832 Y111.298 I-2.463 J4.807 E.01013
G1 X127.832 Y135.755 E.55189
G1 X128.223 Y135.521 E.01028
G1 X128.223 Y111.535 E.54126
G1 X128.613 Y111.787 E.0105
G1 X128.613 Y135.265 E.52979
G1 X129.004 Y134.983 E.01087
G1 X129.004 Y112.058 E.51733
G1 X129.395 Y112.352 E.01103
G1 X129.395 Y134.69 E.50407
G1 X129.785 Y134.385 E.01117
G1 X129.785 Y112.668 E.49007
M73 P75 R4
G1 X130.176 Y113.007 E.01168
G1 X130.176 Y134.048 E.4748
G1 X130.567 Y133.685 E.01204
G1 X130.567 Y113.381 E.45816
G3 X130.906 Y113.724 I-9.014 J9.261 E.01088
G1 X130.957 Y113.776 E.00166
G1 X130.957 Y133.29 E.44034
G1 X131.348 Y132.863 E.01306
G1 X131.348 Y114.194 E.42128
G3 X131.738 Y114.658 I-5.379 J4.916 E.01371
G1 X131.738 Y132.398 E.40031
G1 X132.129 Y131.89 E.01448
G1 X132.129 Y115.167 E.37735
G1 X132.52 Y115.728 E.01542
G1 X132.52 Y131.326 E.35198
G1 X132.91 Y130.698 E.01669
G1 X132.91 Y116.35 E.32376
G1 X133.301 Y117.074 E.01858
G1 X133.301 Y129.974 E.29107
G1 X133.336 Y129.908 E.00168
G2 X133.692 Y129.162 I-15.371 J-7.789 E.01865
G1 X133.692 Y117.889 E.25439
G1 X133.717 Y117.941 E.00131
G3 X134.082 Y118.891 I-11.213 J4.86 E.02297
G1 X134.082 Y128.162 E.20921
G1 X134.226 Y127.73 E.01028
G1 X134.473 Y126.824 E.0212
G1 X134.473 Y120.22 E.14901
G1 X134.59 Y120.747 E.01218
G3 X134.863 Y123.561 I-14.302 J2.811 E.06389
G1 X134.863 Y125.753 E.04947
G1 X145.551 Y109.939 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F16200
G1 X147.179 Y109.939 E.03947
G1 X148.197 Y110.956 E.03488
G2 X148.844 Y112.422 I3.537 J-.686 E.03915
G1 X135.001 Y126.264 E.47449
G1 X134.919 Y126.675 E.01016
G3 X134.552 Y128.015 I-15.732 J-3.594 E.03368
G1 X143.651 Y137.114 E.3119
G1 X147.179 Y137.114 E.08552
G1 X148.203 Y136.091 E.03507
G3 X148.841 Y134.629 I3.557 J.683 E.039
G1 X135.002 Y120.789 E.47438
M73 P76 R4
G1 X134.981 Y120.674 E.00284
G2 X134.552 Y119.038 I-15.559 J3.21 E.04101
G1 X143.651 Y109.939 E.31189
G1 X142.023 Y109.939 E.03947
; CHANGE_LAYER
; Z_HEIGHT: 4.09741
; LAYER_HEIGHT: 0.129679
; WIPE_START
G1 F16200
G1 X143.651 Y109.939 E-.61876
G1 X143.388 Y110.202 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 23/33
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
G17
G3 Z4.368 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X153.925 Y138.147
G1 Z4.097
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X153.846 Y138.298 E.00353
G3 X152.558 Y139.027 I-1.294 J-.782 E.03205
G1 X115.566 Y139.027 E.7665
G3 X106.062 Y129.523 I.023 J-9.527 E.30913
G1 X106.062 Y117.529 E.24852
G3 X115.566 Y108.025 I9.508 J.004 E.3093
G1 X152.66 Y108.029 E.7686
G3 X154.064 Y109.529 I-.108 J1.509 E.04682
G1 X154.064 Y137.523 E.58005
G3 X153.961 Y138.064 I-1.512 J-.008 E.01148
G1 X153.949 Y138.092 E.00062
; WIPE_START
M204 S10000
G1 X153.846 Y138.298 E-.08751
G1 X153.735 Y138.462 E-.07519
G1 X153.594 Y138.617 E-.0798
G1 X153.331 Y138.815 E-.12496
G1 X153.083 Y138.933 E-.10448
G1 X152.9 Y138.989 E-.07288
G1 X152.558 Y139.027 E-.1305
G1 X152.336 Y139.027 E-.08468
; WIPE_END
G1 E-.04 F1800
G1 X151.742 Y131.418 Z4.497 F30000
G1 X149.964 Y108.612 Z4.497
G1 Z4.097
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G2 X153.43 Y110.804 I1.216 J1.914 E.20354
G1 X153.657 Y110.828 E.00509
G1 X153.657 Y136.234 E.56671
G1 X153.422 Y136.252 E.00525
G2 X149.957 Y138.448 I-2.25 J.281 E.2035
G1 X149.899 Y138.62 E.00405
G1 X115.571 Y138.62 E.76571
G3 X106.47 Y129.518 I.017 J-9.119 E.31874
G1 X106.47 Y117.534 E.26731
G3 X115.571 Y108.433 I9.1 J-.001 E.31892
G1 X149.909 Y108.433 E.76593
G1 X149.946 Y108.555 E.00284
M204 S250
G1 X150.425 Y108.824 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.631 Y108.747 E.00456
G3 X151.064 Y108.669 I.543 J1.778 E.00914
G1 X151.285 Y108.669 E.00457
G3 X150.371 Y108.849 I-.11 J1.856 E.22258
; WIPE_START
M204 S10000
G1 X150.631 Y108.747 E-.1063
G1 X150.845 Y108.695 E-.08374
G1 X151.064 Y108.669 E-.08378
G1 X151.285 Y108.669 E-.08374
G1 X151.504 Y108.695 E-.08377
G1 X151.718 Y108.747 E-.08376
G1 X151.924 Y108.824 E-.08372
G1 X152.121 Y108.924 E-.0838
G1 X152.268 Y109.024 E-.06739
; WIPE_END
G1 E-.04 F1800
G1 X153.422 Y110.249 Z4.497 F30000
G1 Z4.097
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G2 X152.385 Y108.612 I-2.231 J.266 E.0447
G1 X152.44 Y108.433 E.00418
G3 X152.64 Y108.436 I.056 J2.735 E.00445
G3 X153.657 Y109.539 I-.079 J1.094 E.03687
G1 X153.657 Y110.232 E.01544
G1 X153.482 Y110.245 E.00391
; WIPE_START
G1 X153.394 Y110.059 E-.07806
G1 X153.323 Y109.8 E-.10221
G1 X153.222 Y109.551 E-.1021
G1 X153.093 Y109.316 E-.10209
G1 X152.95 Y109.116 E-.0931
G1 X152.757 Y108.901 E-.10982
G1 X152.551 Y108.723 E-.10344
G1 X152.4 Y108.622 E-.06918
; WIPE_END
G1 E-.04 F1800
G1 X152.597 Y116.252 Z4.497 F30000
G1 X153.149 Y137.643 Z4.497
G1 Z4.097
G1 E.8 F1800
G1 F18000
G1 X153.158 Y137.622 E.00051
G2 X153.43 Y136.806 I-2.06 J-1.141 E.01929
G1 X153.657 Y136.83 E.00509
G3 X153.639 Y137.719 I-5.149 J.342 E.01986
G3 X152.45 Y138.62 I-1.105 J-.224 E.03636
G1 X152.392 Y138.448 E.00405
G2 X153.014 Y137.849 I-1.295 J-1.968 E.01938
G1 X153.116 Y137.693 E.00414
M204 S250
G1 X152.813 Y137.408 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X152.802 Y137.426 E.00044
G3 X150.845 Y134.698 I-1.628 J-.899 E.15525
G1 X151.065 Y134.671 E.00459
G3 X152.897 Y137.227 I.109 J1.856 E.07765
G1 X152.838 Y137.353 E.00289
M204 S10000
G1 X153.414 Y137.636 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.100149
G1 F15000
G3 X153.34 Y137.826 I-1.046 J-.297 E.00078
; LINE_WIDTH: 0.130909
G3 X153.03 Y138.229 I-1.237 J-.632 E.00278
; LINE_WIDTH: 0.0904226
G3 X152.939 Y138.297 I-.51 J-.589 E.00038
G1 X152.225 Y138.59 F30000
; LINE_WIDTH: 0.399733
G1 F15000
G1 X151.947 Y138.64 E.00555
; LINE_WIDTH: 0.37751
G1 X151.825 Y138.658 E.00228
; LINE_WIDTH: 0.338473
G1 X151.685 Y138.678 E.00232
; LINE_WIDTH: 0.295535
G3 X151.426 Y138.701 I-.507 J-4.305 E.00368
; LINE_WIDTH: 0.266046
G1 X151.168 Y138.708 E.00325
G3 X150.908 Y138.7 I.009 J-4.434 E.00326
; LINE_WIDTH: 0.298378
G3 X150.647 Y138.676 I.271 J-4.418 E.00376
; LINE_WIDTH: 0.340986
G1 X150.524 Y138.658 E.00205
; LINE_WIDTH: 0.392955
G3 X150.124 Y138.59 I.945 J-6.746 E.00783
G1 X149.49 Y138.409 F30000
; LINE_WIDTH: 0.0957303
G1 F15000
G1 X149.366 Y138.256 E.00071
G1 X148.473 Y137.97 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.40456
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X148.769 Y137.654 E.0227
G1 X148.72 Y137.51 E.00798
G3 X148.61 Y137.159 I1.418 J-.638 E.01931
G1 X148.039 Y137.768 E.04371
G1 X147.417 Y137.768 E.03262
G1 X148.533 Y136.576 E.0855
G1 X148.536 Y136.45 E.0066
G3 X148.64 Y135.797 I3.983 J.296 E.03469
G1 X146.604 Y137.97 E.15597
G1 X148.338 Y138.012 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.420539
; LAYER_HEIGHT: 0.129679
G1 F15000
G1 X148.6 Y138.274 E.00768
G1 X148.044 Y138.274 E.01152
G1 X147.959 Y138.189 E.0025
G1 X147.404 Y138.189 E.01152
G1 X147.489 Y138.274 E.0025
G1 X146.934 Y138.274 E.01152
G1 X146.848 Y138.189 E.0025
G1 X146.293 Y138.189 E.01152
G1 X146.378 Y138.274 E.0025
G1 X145.823 Y138.274 E.01152
G1 X145.738 Y138.189 E.0025
G1 X145.182 Y138.189 E.01152
G1 X145.267 Y138.274 E.0025
G1 X144.712 Y138.274 E.01152
G1 X144.627 Y138.189 E.0025
G1 X144.072 Y138.189 E.01152
G1 X144.157 Y138.274 E.0025
G1 X143.601 Y138.274 E.01152
G1 X143.516 Y138.189 E.0025
G1 X142.961 Y138.189 E.01152
G1 X143.046 Y138.274 E.0025
G1 X142.491 Y138.274 E.01152
G1 X142.405 Y138.189 E.0025
G1 X141.85 Y138.189 E.01152
G1 X141.935 Y138.274 E.0025
G1 X141.38 Y138.274 E.01152
G1 X141.295 Y138.189 E.0025
G1 X140.739 Y138.189 E.01152
G1 X140.824 Y138.274 E.0025
G1 X140.269 Y138.274 E.01152
G1 X140.184 Y138.189 E.0025
G1 X139.628 Y138.189 E.01152
G1 X139.714 Y138.274 E.0025
G1 X139.158 Y138.274 E.01152
G1 X139.073 Y138.189 E.0025
G1 X138.518 Y138.189 E.01152
G1 X138.603 Y138.274 E.0025
G1 X138.048 Y138.274 E.01152
G1 X137.962 Y138.189 E.0025
G1 X137.407 Y138.189 E.01152
G1 X137.492 Y138.274 E.0025
G1 X136.937 Y138.274 E.01152
G1 X136.852 Y138.189 E.0025
G1 X136.296 Y138.189 E.01152
G1 X136.381 Y138.274 E.0025
G1 X135.826 Y138.274 E.01152
G1 X135.741 Y138.189 E.0025
G1 X135.185 Y138.189 E.01152
G1 X135.271 Y138.274 E.0025
G1 X134.715 Y138.274 E.01152
G1 X134.63 Y138.189 E.0025
G1 X134.075 Y138.189 E.01152
G1 X134.16 Y138.274 E.0025
G1 X133.605 Y138.274 E.01152
G1 X133.519 Y138.189 E.0025
G1 X132.964 Y138.189 E.01152
G1 X133.049 Y138.274 E.0025
G1 X132.494 Y138.274 E.01152
G1 X132.409 Y138.189 E.0025
G1 X131.853 Y138.189 E.01152
G1 X131.938 Y138.274 E.0025
G1 X131.383 Y138.274 E.01152
G1 X131.298 Y138.189 E.0025
G1 X130.742 Y138.189 E.01152
G1 X130.828 Y138.274 E.0025
G1 X130.272 Y138.274 E.01152
G1 X130.187 Y138.189 E.0025
G1 X129.632 Y138.189 E.01152
G1 X129.717 Y138.274 E.0025
G1 X129.162 Y138.274 E.01152
G1 X129.076 Y138.189 E.0025
G1 X128.521 Y138.189 E.01152
G1 X128.606 Y138.274 E.0025
G1 X128.051 Y138.274 E.01152
G1 X127.966 Y138.189 E.0025
G1 X127.41 Y138.189 E.01152
G1 X127.495 Y138.274 E.0025
G1 X126.94 Y138.274 E.01152
G1 X126.855 Y138.189 E.0025
G1 X126.451 Y138.189 E.00838
G1 X126.23 Y138.001 E.00603
G1 X126.161 Y138.051 E.00176
G1 X126.385 Y138.274 E.00656
G1 X125.829 Y138.274 E.01152
G1 X106.817 Y119.262 E.55789
G1 X106.817 Y118.706 E.01153
G1 X125.337 Y137.226 E.54346
G1 X125.42 Y137.097 E.00319
G1 X124.709 Y136.432 E.02019
G1 X124.988 Y136.322 E.00622
G1 X106.816 Y118.15 E.53323
G1 X106.816 Y117.594 E.01153
G1 X125.387 Y136.165 E.54495
G1 X125.785 Y136.009 E.00889
G1 X106.831 Y117.055 E.55618
G1 X106.88 Y116.548 E.01057
G1 X126.175 Y135.842 E.56618
G2 X126.466 Y135.711 I-1.435 J-3.572 E.00664
G1 X126.555 Y135.667 E.00205
G1 X106.944 Y116.057 E.57545
G3 X107.039 Y115.597 I3.484 J.481 E.00976
G1 X126.927 Y135.484 E.58356
G1 X127.286 Y135.288 E.00849
G1 X107.149 Y115.15 E.5909
G3 X107.285 Y114.731 I2.311 J.519 E.00916
G1 X127.637 Y135.084 E.59721
G2 X127.928 Y134.907 I-1.94 J-3.518 E.00706
G1 X127.981 Y134.872 E.00132
G1 X107.428 Y114.319 E.60311
G3 X107.591 Y113.927 I2.824 J.951 E.00881
G1 X128.316 Y134.651 E.60813
G2 X128.624 Y134.423 I-1.676 J-2.585 E.00796
G1 X128.635 Y134.415 E.00028
G1 X107.779 Y113.559 E.612
G1 X107.968 Y113.192 E.00855
G1 X128.952 Y134.177 E.61576
G2 X129.268 Y133.938 I-1.784 J-2.689 E.00823
G1 X108.182 Y112.851 E.61875
G1 X108.399 Y112.513 E.00834
G1 X129.567 Y133.682 E.62116
G2 X129.86 Y133.418 I-3.012 J-3.639 E.00816
G1 X108.639 Y112.197 E.62271
G1 X108.883 Y111.887 E.00821
G1 X130.145 Y133.149 E.62391
G1 X130.422 Y132.87 E.00815
G1 X109.147 Y111.595 E.62429
G1 X109.418 Y111.31 E.00815
G1 X130.689 Y132.582 E.62418
G2 X130.95 Y132.287 I-3.406 J-3.277 E.00817
G1 X109.705 Y111.042 E.62341
G1 X110.002 Y110.784 E.00817
G1 X131.203 Y131.985 E.62211
G2 X131.445 Y131.672 I-3.641 J-3.069 E.00822
G1 X110.309 Y110.536 E.62021
G3 X110.636 Y110.307 I1.762 J2.17 E.00828
G1 X131.681 Y131.352 E.61753
G2 X131.909 Y131.025 I-3.818 J-2.91 E.00828
G1 X110.974 Y110.09 E.61431
G3 X111.322 Y109.883 I1.258 J1.721 E.00842
G1 X132.127 Y130.687 E.61047
G2 X132.336 Y130.341 I-4.053 J-2.682 E.0084
G1 X111.689 Y109.694 E.60585
G3 X112.066 Y109.515 I1.123 J1.882 E.00866
G1 X132.535 Y129.984 E.60064
G3 X132.724 Y129.618 I8.968 J4.404 E.00855
G1 X112.462 Y109.356 E.59455
G3 X112.868 Y109.207 I1.249 J2.766 E.00898
M73 P77 R4
G1 X132.908 Y129.247 E.58804
G2 X133.083 Y128.866 I-2.953 J-1.588 E.00869
G1 X113.301 Y109.084 E.58047
G1 X113.748 Y108.976 E.00954
G1 X133.246 Y128.474 E.57214
G1 X133.399 Y128.072 E.00893
G1 X114.213 Y108.886 E.56299
G3 X114.713 Y108.83 I.635 J3.468 E.01045
G1 X133.538 Y127.656 E.5524
G2 X133.667 Y127.229 I-5.062 J-1.761 E.00925
G1 X115.227 Y108.789 E.5411
G1 X115.782 Y108.789 E.01152
G1 X133.784 Y126.791 E.52825
G2 X133.89 Y126.341 I-5.35 J-1.488 E.0096
G1 X116.337 Y108.789 E.51505
G1 X116.893 Y108.789 E.01152
G1 X133.982 Y125.878 E.50146
G1 X134.057 Y125.398 E.01008
G1 X117.448 Y108.788 E.48738
G1 X118.003 Y108.788 E.01152
G1 X134.116 Y124.902 E.47283
G2 X134.134 Y124.725 I-2.105 J-.301 E.00368
G1 X134.159 Y124.389 E.00701
G1 X118.558 Y108.788 E.45778
G1 X119.113 Y108.788 E.01152
G1 X134.182 Y123.856 E.44216
G2 X134.184 Y123.303 I-6.484 J-.304 E.01148
G1 X119.669 Y108.788 E.42594
G1 X120.224 Y108.788 E.01152
G1 X134.162 Y122.726 E.40901
G2 X134.113 Y122.121 I-7.295 J.29 E.01259
G1 X120.779 Y108.787 E.39127
G1 X121.334 Y108.787 E.01152
G1 X134.032 Y121.485 E.37261
G2 X133.91 Y120.808 I-24.989 J4.15 E.01428
G1 X121.89 Y108.787 E.35274
G1 X122.445 Y108.787 E.01152
G1 X133.737 Y120.08 E.33137
G2 X133.505 Y119.292 I-9.589 J2.398 E.01704
G1 X123 Y108.787 E.30827
G1 X123.555 Y108.787 E.01152
G1 X133.175 Y118.407 E.2823
G2 X132.937 Y117.879 I-4.351 J1.65 E.01203
G2 X132.691 Y117.367 I-18.07 J8.354 E.01178
G1 X124.11 Y108.786 E.25179
G1 X124.666 Y108.786 E.01152
G1 X126.654 Y110.775 E.05835
G1 X126.923 Y110.488 E.00815
G1 X125.221 Y108.786 E.04994
G1 X125.776 Y108.786 E.01152
G1 X127.191 Y110.201 E.04153
G1 X127.46 Y109.915 E.00815
G1 X126.331 Y108.786 E.03312
G1 X126.886 Y108.786 E.01152
G1 X127.729 Y109.628 E.02471
G1 X127.997 Y109.341 E.00815
G1 X127.442 Y108.785 E.0163
G1 X127.997 Y108.785 E.01152
G1 X128.266 Y109.054 E.0079
G1 X128.444 Y108.864 E.00542
G1 X128.631 Y108.864 E.00387
G1 X128.552 Y108.785 E.00231
G1 X129.107 Y108.785 E.01152
G1 X129.186 Y108.864 E.00232
G1 X129.742 Y108.864 E.01152
G1 X129.662 Y108.785 E.00232
G1 X130.218 Y108.785 E.01152
G1 X130.297 Y108.864 E.00233
G1 X130.852 Y108.864 E.01152
G1 X130.773 Y108.784 E.00233
G1 X131.328 Y108.784 E.01152
G1 X131.408 Y108.864 E.00234
G1 X131.963 Y108.864 E.01152
G1 X131.883 Y108.784 E.00234
G1 X132.438 Y108.784 E.01152
G1 X132.518 Y108.864 E.00235
G1 X133.074 Y108.864 E.01152
G1 X132.994 Y108.784 E.00235
G1 X133.549 Y108.784 E.01152
G1 X133.629 Y108.864 E.00236
G1 X134.185 Y108.864 E.01152
G1 X134.104 Y108.783 E.00236
G1 X134.659 Y108.783 E.01152
G1 X134.74 Y108.864 E.00237
G1 X135.295 Y108.864 E.01152
G1 X135.215 Y108.783 E.00237
G1 X135.77 Y108.783 E.01152
G1 X135.851 Y108.864 E.00238
G1 X136.406 Y108.864 E.01152
G1 X136.325 Y108.783 E.00238
G1 X136.88 Y108.783 E.01152
G1 X136.961 Y108.864 E.00239
G1 X137.517 Y108.864 E.01152
G1 X137.435 Y108.782 E.00239
G1 X137.991 Y108.782 E.01152
G1 X138.072 Y108.864 E.00239
G1 X138.628 Y108.864 E.01152
G1 X138.546 Y108.782 E.0024
G1 X139.101 Y108.782 E.01152
G1 X139.183 Y108.864 E.0024
G1 X139.738 Y108.864 E.01152
G1 X139.656 Y108.782 E.00241
G1 X140.211 Y108.782 E.01152
G1 X140.294 Y108.864 E.00241
G1 X140.849 Y108.864 E.01152
G1 X140.767 Y108.781 E.00242
G1 X141.322 Y108.781 E.01152
G1 X141.404 Y108.864 E.00242
G1 X141.96 Y108.864 E.01152
G1 X141.877 Y108.781 E.00243
G1 X142.432 Y108.781 E.01152
G1 X142.515 Y108.864 E.00243
G1 X143.071 Y108.864 E.01152
G1 X142.987 Y108.781 E.00244
G1 X143.543 Y108.78 E.01152
G1 X143.626 Y108.864 E.00244
G1 X144.181 Y108.864 E.01152
G1 X144.098 Y108.78 E.00245
G1 X144.653 Y108.78 E.01152
G1 X144.737 Y108.864 E.00245
G1 X145.292 Y108.864 E.01152
G1 X145.208 Y108.78 E.00246
G1 X145.763 Y108.78 E.01152
G1 X145.847 Y108.864 E.00246
G1 X146.403 Y108.864 E.01152
G1 X146.319 Y108.78 E.00247
G1 X146.874 Y108.779 E.01152
G1 X146.958 Y108.864 E.00247
G1 X147.514 Y108.864 E.01152
G1 X147.429 Y108.779 E.00248
G1 X147.984 Y108.779 E.01152
G1 X148.069 Y108.864 E.00248
G1 X148.624 Y108.864 E.01152
G1 X148.54 Y108.779 E.00249
G1 X149.095 Y108.779 E.01152
G1 X149.293 Y108.977 E.00582
G1 X150.132 Y108.464 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.410877
G1 F15000
G1 X150.323 Y108.43 E.00393
; LINE_WIDTH: 0.377813
G1 X150.514 Y108.396 E.00359
; LINE_WIDTH: 0.34329
G1 X150.655 Y108.378 E.00238
; LINE_WIDTH: 0.311748
G1 X150.778 Y108.364 E.00185
; LINE_WIDTH: 0.27479
G3 X151.555 Y108.362 I.398 J4.892 E.01016
; LINE_WIDTH: 0.309919
G1 X151.694 Y108.378 E.00207
; LINE_WIDTH: 0.340879
G1 X151.816 Y108.393 E.00204
; LINE_WIDTH: 0.376017
G3 X152.026 Y108.43 I-.524 J3.576 E.00393
; LINE_WIDTH: 0.410868
G1 X152.217 Y108.464 E.00393
G1 X152.938 Y108.754 F30000
; LINE_WIDTH: 0.0955563
G1 F15000
G3 X153.04 Y108.837 I-.515 J.744 E.00047
; LINE_WIDTH: 0.134286
G3 X153.312 Y109.173 I-.828 J.948 E.00244
; LINE_WIDTH: 0.10808
G3 X153.415 Y109.417 I-2.999 J1.401 E.00112
; WIPE_START
G1 X153.312 Y109.173 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X153.548 Y110.528 Z4.497 F30000
G1 Z4.097
G1 E.8 F1800
; LINE_WIDTH: 0.211327
G1 F15000
G1 X153.861 Y110.532 E.00303
G1 X153.548 Y110.528 F30000
; LINE_WIDTH: 0.170326
G1 F15000
G1 X153.236 Y110.523 E.00235
; WIPE_START
G1 X153.548 Y110.528 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X153.427 Y111.607 Z4.497 F30000
G1 Z4.097
G1 E.8 F1800
; LINE_WIDTH: 0.13342
G1 F15000
G1 X153.39 Y111.752 E.00083
; LINE_WIDTH: 0.120151
G1 X153.314 Y111.846 E.00059
; LINE_WIDTH: 0.0946021
G1 X153.237 Y111.94 E.00043
; WIPE_START
G1 X153.314 Y111.846 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X145.872 Y113.542 Z4.497 F30000
G1 X132.474 Y116.595 Z4.497
G1 Z4.097
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.420539
G1 F15000
G1 X127.649 Y111.769 E.14159
G1 X128.82 Y109.082 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.40456
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X126.93 Y111.099 E.14475
G1 X127.349 Y111.317 E.02473
G1 X129.253 Y109.285 E.14582
G1 X129.876 Y109.285 E.03262
G1 X127.755 Y111.548 E.16243
G3 X128.151 Y111.791 I-2.718 J4.877 E.02431
G1 X130.499 Y109.285 E.17984
G1 X131.121 Y109.285 E.03262
G1 X128.537 Y112.044 E.19802
G3 X128.912 Y112.308 I-2.983 J4.648 E.02405
G1 X131.744 Y109.285 E.21695
G1 X132.367 Y109.285 E.03262
G1 X129.278 Y112.583 E.23667
G3 X129.631 Y112.871 I-3.296 J4.399 E.02387
G1 X132.99 Y109.285 E.25735
G1 X133.613 Y109.285 E.03262
G1 X129.974 Y113.169 E.27874
G3 X130.306 Y113.48 I-2.324 J2.808 E.02382
G1 X134.236 Y109.285 E.30107
G1 X134.858 Y109.285 E.03262
G1 X130.628 Y113.801 E.32412
G2 X130.946 Y114.127 I7.955 J-7.456 E.02383
G1 X135.481 Y109.285 E.34748
G1 X136.104 Y109.285 E.03262
G1 X131.249 Y114.468 E.37196
G3 X131.541 Y114.821 I-4.078 J3.683 E.024
G1 X136.727 Y109.285 E.39726
G1 X137.35 Y109.285 E.03262
G1 X131.824 Y115.184 E.42331
G3 X132.097 Y115.557 I-4.325 J3.445 E.02424
G1 X137.973 Y109.285 E.45012
G1 X138.595 Y109.285 E.03262
G1 X132.358 Y115.944 E.47788
G3 X132.607 Y116.343 I-4.68 J3.196 E.02465
G1 X139.218 Y109.285 E.50652
G1 X139.841 Y109.285 E.03262
G1 X132.845 Y116.754 E.536
G3 X133.068 Y117.18 I-3.299 J2.004 E.02522
G1 X140.464 Y109.285 E.56657
G1 X141.087 Y109.285 E.03262
G1 X133.281 Y117.618 E.59802
G3 X133.489 Y118.06 I-3.684 J2.01 E.02562
G1 X141.71 Y109.285 E.62975
G1 X142.333 Y109.285 E.03262
G1 X133.678 Y118.524 E.66306
G3 X133.851 Y119.004 I-5.68 J2.331 E.02671
G1 X142.955 Y109.285 E.69745
G1 X143.578 Y109.285 E.03262
G1 X134.011 Y119.498 E.73296
G3 X134.155 Y120.01 I-6.071 J1.986 E.02782
G1 X144.201 Y109.285 E.76964
G1 X144.824 Y109.285 E.03262
G1 X134.282 Y120.539 E.80761
G3 X134.391 Y121.087 I-6.388 J1.554 E.0293
G1 X145.447 Y109.285 E.84698
G1 X146.07 Y109.285 E.03262
G1 X134.481 Y121.657 E.88783
G3 X134.548 Y122.249 I-7.094 J1.109 E.03125
G1 X146.692 Y109.285 E.93036
G1 X147.315 Y109.285 E.03262
G1 X134.592 Y122.868 E.97476
G3 X134.608 Y123.516 I-7.769 J.517 E.03394
G1 X147.938 Y109.285 E1.02124
G1 X148.561 Y109.285 E.03262
G1 X134.592 Y124.197 E1.07013
G3 X134.538 Y124.919 I-19.956 J-1.128 E.03795
G1 X148.611 Y109.897 E1.07809
G2 X148.535 Y110.642 I1.815 J.561 E.03952
G1 X134.437 Y125.692 E1.08004
G3 X134.283 Y126.522 I-12.257 J-1.848 E.04419
G1 X148.624 Y111.213 E1.09863
G2 X148.803 Y111.686 I1.905 J-.454 E.02658
G1 X134.044 Y127.442 E1.13071
G3 X133.694 Y128.481 I-13.413 J-3.945 E.05745
G1 X149.048 Y112.09 E1.17627
G2 X149.32 Y112.404 I1.341 J-.887 E.02181
G1 X149.349 Y112.433 E.00217
G1 X132.614 Y130.299 E1.28212
G1 X125.807 Y136.235 F30000
G1 F3000
G1 X125.484 Y136.58 E.02476
G1 X125.816 Y136.891 E.02381
G1 X126.502 Y136.158 E.05258
G2 X127.715 Y135.528 I-11.72 J-24.049 E.07159
G1 X125.863 Y137.506 E.1419
G1 X126.007 Y137.641 E.01039
G1 X126.249 Y137.465 E.01569
G1 X126.402 Y137.595 E.01052
G1 X149.702 Y112.722 E1.78497
G2 X150.116 Y112.944 I1.142 J-1.63 E.02469
G1 X126.863 Y137.768 E1.78143
G1 X127.486 Y137.768 E.03262
G1 X150.59 Y113.103 E1.77004
G2 X151.151 Y113.169 I.558 J-2.323 E.02965
G1 X128.108 Y137.768 E1.7653
G1 X128.731 Y137.768 E.03262
G1 X151.861 Y113.076 E1.77194
M73 P78 R4
G2 X152.805 Y112.632 I-1.123 J-3.61 E.05485
G1 X152.805 Y112.733 E.00531
G1 X129.354 Y137.768 E1.79657
G1 X129.977 Y137.768 E.03262
G1 X152.805 Y113.398 E1.74886
G1 X152.805 Y114.063 E.03482
G1 X130.6 Y137.768 E1.70114
G1 X131.223 Y137.768 E.03262
G1 X152.805 Y114.728 E1.65343
G1 X152.805 Y115.393 E.03482
G1 X131.846 Y137.768 E1.60571
G1 X132.468 Y137.768 E.03262
G1 X152.805 Y116.058 E1.558
G1 X152.805 Y116.722 E.03482
G1 X133.091 Y137.768 E1.51028
G1 X133.714 Y137.768 E.03262
G1 X152.805 Y117.387 E1.46256
G1 X152.805 Y118.052 E.03482
G1 X134.337 Y137.768 E1.41485
G1 X134.96 Y137.768 E.03262
G1 X152.805 Y118.717 E1.36713
G1 X152.805 Y119.382 E.03482
G1 X135.583 Y137.768 E1.31942
G1 X136.205 Y137.768 E.03262
G1 X152.805 Y120.047 E1.2717
G1 X152.805 Y120.712 E.03482
G1 X136.828 Y137.768 E1.22398
G1 X137.451 Y137.768 E.03262
G1 X152.805 Y121.377 E1.17627
G1 X152.805 Y122.042 E.03482
G1 X138.074 Y137.768 E1.12855
G1 X138.697 Y137.768 E.03262
G1 X152.805 Y122.707 E1.08084
G1 X152.805 Y123.372 E.03482
G1 X139.32 Y137.768 E1.03312
G1 X139.942 Y137.768 E.03262
G1 X152.805 Y124.036 E.9854
G1 X152.805 Y124.701 E.03482
G1 X140.565 Y137.768 E.93769
G1 X141.188 Y137.768 E.03262
G1 X152.805 Y125.366 E.88997
G1 X152.805 Y126.031 E.03482
G1 X141.811 Y137.768 E.84226
G1 X142.434 Y137.768 E.03262
G1 X152.805 Y126.696 E.79454
G1 X152.805 Y127.361 E.03482
G1 X143.057 Y137.768 E.74682
G1 X143.68 Y137.768 E.03262
G1 X152.805 Y128.026 E.69911
G1 X152.805 Y128.691 E.03482
G1 X144.302 Y137.768 E.65139
G1 X144.925 Y137.768 E.03262
G1 X152.805 Y129.356 E.60368
G1 X152.805 Y130.021 E.03482
G1 X145.548 Y137.768 E.55596
G1 X146.171 Y137.768 E.03262
G1 X152.805 Y130.686 E.50824
M73 P79 R4
G1 X152.805 Y131.35 E.03482
G1 X150.281 Y134.045 E.19338
G3 X151.05 Y133.889 I.8 J1.968 E.04134
G1 X152.805 Y132.015 E.13446
M73 P79 R3
G1 X152.805 Y132.68 E.03482
G1 X151.638 Y133.926 E.0894
G3 X152.088 Y134.052 I-.81 J3.743 E.02447
G1 X152.128 Y134.067 E.00228
G1 X152.805 Y133.345 E.05184
G1 X152.805 Y134.01 E.03482
G1 X152.415 Y134.426 E.02988
G1 X153.238 Y134.47 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.443649
; LAYER_HEIGHT: 0.129679
G1 F12000
G1 X153.238 Y112.52 E.48224
G1 X153.15 Y134.995 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.0946135
G1 F15000
G1 X153.232 Y135.085 E.00043
; LINE_WIDTH: 0.120184
G1 X153.314 Y135.174 E.00059
; LINE_WIDTH: 0.150582
G1 X153.446 Y135.337 E.00136
; WIPE_START
G1 X153.314 Y135.174 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X153.548 Y136.53 Z4.497 F30000
G1 Z4.097
G1 E.8 F1800
; LINE_WIDTH: 0.170324
G1 F15000
G1 X153.236 Y136.525 E.00235
G1 X153.548 Y136.53 F30000
; LINE_WIDTH: 0.211324
G1 F15000
G1 X153.861 Y136.535 E.00303
; WIPE_START
G1 X153.548 Y136.53 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X145.934 Y137.05 Z4.497 F30000
G1 X125.45 Y138.451 Z4.497
G1 Z4.097
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.420539
G1 F15000
G1 X106.817 Y119.818 E.54676
G1 X106.818 Y120.373 E.01153
G1 X124.719 Y138.274 E.52527
G1 X124.163 Y138.274 E.01152
G1 X106.818 Y120.929 E.50896
G1 X106.819 Y121.485 E.01153
G1 X123.608 Y138.274 E.49265
G1 X123.052 Y138.274 E.01152
G1 X106.819 Y122.041 E.47634
G1 X106.82 Y122.597 E.01153
G1 X122.497 Y138.274 E.46003
G1 X121.942 Y138.274 E.01152
G1 X106.82 Y123.153 E.44372
G1 X106.821 Y123.709 E.01153
G1 X121.386 Y138.274 E.42741
G1 X120.831 Y138.274 E.01152
G1 X106.821 Y124.264 E.4111
G1 X106.822 Y124.82 E.01153
G1 X120.276 Y138.274 E.39479
G1 X119.72 Y138.274 E.01152
G1 X106.822 Y125.376 E.37848
G1 X106.823 Y125.932 E.01153
G1 X119.165 Y138.274 E.36217
G1 X118.609 Y138.274 E.01152
G1 X106.823 Y126.488 E.34585
M73 P80 R3
G1 X106.824 Y127.044 E.01153
G1 X118.054 Y138.274 E.32954
G1 X117.499 Y138.274 E.01152
G1 X106.824 Y127.599 E.31323
G1 X106.824 Y128.155 E.01153
G1 X116.943 Y138.274 E.29692
G1 X116.388 Y138.274 E.01152
G1 X106.825 Y128.711 E.28061
G1 X106.825 Y129.267 E.01153
G1 X115.833 Y138.274 E.2643
G3 X115.262 Y138.259 I-.127 J-6.026 E.01184
G1 X106.826 Y129.823 E.24755
G2 X106.872 Y130.424 I3.2 J.057 E.01254
G1 X114.673 Y138.225 E.22892
G1 X114.025 Y138.132 E.0136
G1 X106.954 Y131.061 E.20749
G2 X107.12 Y131.783 I5.128 J-.802 E.01538
G1 X113.307 Y137.97 E.18154
G3 X112.488 Y137.707 I.968 J-4.416 E.01787
G1 X107.383 Y132.601 E.14981
G2 X107.841 Y133.615 I5.535 J-1.892 E.02311
G1 X111.475 Y137.249 E.10663
G3 X109.533 Y135.862 I3.834 J-7.423 E.04969
G1 X108.151 Y134.48 E.04053
; CHANGE_LAYER
; Z_HEIGHT: 4.21799
; LAYER_HEIGHT: 0.120585
; WIPE_START
G1 F15000
G1 X109.533 Y135.862 E-.74233
G1 X109.568 Y135.892 E-.01767
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 24/33
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
G17
G3 Z4.497 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X153.846 Y138.124
G1 Z4.218
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X153.831 Y138.159 E.00074
G3 X152.556 Y138.946 I-1.276 J-.642 E.03052
G1 X115.566 Y138.946 E.71626
G3 X106.144 Y129.523 I.006 J-9.429 E.28655
G1 X106.144 Y117.529 E.23224
G3 X115.566 Y108.107 I9.426 J.004 E.28657
G1 X152.582 Y108.108 E.71676
G3 X153.983 Y109.524 I-.047 J1.447 E.04253
G1 X153.983 Y137.529 E.54229
G3 X153.932 Y137.895 I-1.429 J-.012 E.00716
G1 X153.867 Y138.068 E.00359
; WIPE_START
M204 S10000
G1 X153.831 Y138.159 E-.03738
G1 X153.723 Y138.342 E-.08056
G1 X153.588 Y138.506 E-.08084
G1 X153.433 Y138.648 E-.07962
G1 X153.268 Y138.756 E-.07522
G1 X153.092 Y138.842 E-.07422
G1 X152.914 Y138.902 E-.07142
G1 X152.556 Y138.946 E-.13696
G1 X152.231 Y138.946 E-.12378
; WIPE_END
G1 E-.04 F1800
G1 X151.681 Y131.333 Z4.618 F30000
G1 X150.035 Y108.517 Z4.618
G1 Z4.218
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X149.593 Y108.897 E.01215
G2 X153.361 Y111.136 I1.582 J1.626 E.17341
G1 X153.574 Y111.171 E.0045
G1 X153.574 Y135.873 E.51474
G1 X153.367 Y135.913 E.00439
G2 X149.844 Y138.364 I-2.186 J.616 E.18019
G1 X149.785 Y138.537 E.0038
G1 X115.571 Y138.537 E.71294
G3 X106.553 Y129.518 I.001 J-9.02 E.29518
G1 X106.553 Y117.534 E.24972
G3 X115.571 Y108.516 I9.017 J-.001 E.2952
G1 X149.975 Y108.517 E.71689
M204 S250
G1 X150.425 Y108.824 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.631 Y108.747 E.00425
G3 X151.064 Y108.669 I.543 J1.778 E.00854
G1 X151.285 Y108.669 E.00427
G3 X150.371 Y108.849 I-.11 J1.856 E.208
; WIPE_START
M204 S10000
G1 X150.631 Y108.747 E-.10624
G1 X150.845 Y108.695 E-.08373
G1 X151.064 Y108.669 E-.08378
G1 X151.285 Y108.669 E-.08373
G1 X151.504 Y108.695 E-.0838
G1 X151.718 Y108.747 E-.08373
G1 X151.924 Y108.824 E-.08378
G1 X152.121 Y108.924 E-.08373
G1 X152.268 Y109.024 E-.06748
; WIPE_END
G1 E-.04 F1800
G1 X153.353 Y109.902 Z4.618 F30000
G1 Z4.218
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G2 X152.508 Y108.684 I-2.238 J.65 E.03144
G1 X152.592 Y108.509 E.00405
G1 X152.812 Y108.548 E.00468
G3 X153.574 Y109.541 I-.265 J.992 E.02803
G1 X153.574 Y109.873 E.00692
G1 X153.413 Y109.894 E.00339
; WIPE_START
G1 X153.224 Y109.55 E-.14916
G1 X153.094 Y109.314 E-.1022
G1 X152.948 Y109.11 E-.09556
G1 X152.758 Y108.899 E-.10784
G1 X152.508 Y108.684 E-.12528
G1 X152.592 Y108.509 E-.07379
G1 X152.812 Y108.548 E-.08528
G1 X152.865 Y108.566 E-.02089
; WIPE_END
G1 E-.04 F1800
G1 X153.021 Y116.196 Z4.618 F30000
G1 X153.466 Y137.974 Z4.618
G1 Z4.218
G1 E.8 F1800
G1 F18000
G1 X153.463 Y137.978 E.0001
G3 X152.59 Y138.544 I-.932 J-.481 E.0227
G1 X152.509 Y138.361 E.00417
G2 X153.361 Y137.138 I-1.322 J-1.829 E.03166
G1 X153.574 Y137.173 E.0045
G3 X153.536 Y137.797 I-2.298 J.173 E.01307
G1 X153.488 Y137.918 E.00271
M204 S250
G1 X152.812 Y137.405 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X152.795 Y137.44 E.00075
G3 X150.845 Y134.698 I-1.62 J-.912 E.14477
G1 X151.065 Y134.671 E.00429
G3 X152.897 Y137.228 I.11 J1.856 E.07259
G1 X152.838 Y137.351 E.00264
; WIPE_START
M204 S10000
G1 X152.795 Y137.44 E-.03747
G1 X152.686 Y137.613 E-.07777
G1 X152.547 Y137.784 E-.08374
G1 X152.389 Y137.938 E-.08378
G1 X152.213 Y138.072 E-.08411
G1 X152.01 Y138.19 E-.08935
G1 X151.822 Y138.273 E-.07776
G1 X151.611 Y138.337 E-.08378
G1 X151.394 Y138.376 E-.08377
G1 X151.241 Y138.385 E-.05848
; WIPE_END
G1 E-.04 F1800
G1 X152.357 Y138.524 Z4.618 F30000
G1 Z4.218
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.311867
G1 F15000
G1 X151.935 Y138.6 E.00602
; LINE_WIDTH: 0.290545
G1 X151.813 Y138.618 E.00161
; LINE_WIDTH: 0.252197
G1 X151.678 Y138.638 E.00151
; LINE_WIDTH: 0.210139
G1 X151.424 Y138.66 E.00231
; LINE_WIDTH: 0.180793
G1 X150.916 Y138.66 E.00386
; LINE_WIDTH: 0.212103
G1 X150.659 Y138.636 E.00236
; LINE_WIDTH: 0.254016
G1 X150.536 Y138.618 E.00139
; LINE_WIDTH: 0.306943
G3 X150.005 Y138.526 I1.26 J-8.865 E.00745
; WIPE_START
G1 X150.536 Y138.618 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X148.639 Y138.366 Z4.618 F30000
G1 Z4.218
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.422338
G1 F15000
G1 X149.01 Y137.996 E.01021
G3 X148.807 Y137.637 I1.406 J-1.029 E.00804
G1 X148.256 Y138.189 E.0152
G1 X147.695 Y138.189 E.01092
G1 X148.653 Y137.231 E.02638
G3 X148.57 Y136.753 I3.375 J-.829 E.00946
G1 X147.134 Y138.189 E.03955
G1 X146.574 Y138.189 E.01092
G1 X148.804 Y135.958 E.06145
; WIPE_START
G1 X147.39 Y137.373 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.603 Y134.16 Z4.618 F30000
G1 Z4.218
G1 E.8 F1800
G1 F15000
G1 X153.226 Y131.537 E.07227
G1 X153.226 Y132.097 E.01092
G1 X151.4 Y133.923 E.05029
G3 X151.875 Y134.009 I-.122 J2.037 E.00942
G1 X153.226 Y132.658 E.03721
G1 X153.226 Y133.219 E.01092
G1 X152.285 Y134.16 E.02594
G3 X152.64 Y134.365 I-.626 J1.497 E.00802
G1 X153.226 Y133.779 E.01614
G1 X153.226 Y134.34 E.01092
G1 X152.829 Y134.738 E.01095
G1 X153.152 Y134.993 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.110328
G1 F15000
G1 X153.31 Y135.166 E.00097
G1 X153.345 Y135.283 E.00051
; WIPE_START
G1 X153.31 Y135.166 E-.26089
G1 X153.152 Y134.993 E-.49911
; WIPE_END
G1 E-.04 F1800
G1 X146.221 Y138.189 Z4.618 F30000
G1 X145.836 Y138.366 Z4.618
G1 Z4.218
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.422338
G1 F15000
G1 X153.226 Y130.976 E.20359
G1 X153.226 Y130.415 E.01092
G1 X145.452 Y138.189 E.21414
G1 X144.892 Y138.189 E.01092
G1 X153.226 Y129.855 E.22959
G1 X153.226 Y129.294 E.01092
G1 X144.331 Y138.189 E.24503
G1 X143.77 Y138.189 E.01092
G1 X153.226 Y128.733 E.26048
G1 X153.226 Y128.173 E.01092
G1 X143.21 Y138.189 E.27592
G1 X142.649 Y138.189 E.01092
G1 X153.226 Y127.612 E.29137
G1 X153.226 Y127.051 E.01092
G1 X142.088 Y138.189 E.30681
G1 X141.527 Y138.189 E.01092
G1 X153.226 Y126.49 E.32226
G1 X153.226 Y125.93 E.01092
G1 X140.967 Y138.189 E.3377
G1 X140.406 Y138.189 E.01092
G1 X153.226 Y125.369 E.35315
G1 X153.226 Y124.808 E.01092
G1 X139.845 Y138.189 E.36859
G1 X139.285 Y138.189 E.01092
G1 X153.226 Y124.248 E.38404
G1 X153.226 Y123.687 E.01092
G1 X138.724 Y138.189 E.39948
G1 X138.163 Y138.189 E.01092
G1 X153.226 Y123.126 E.41493
G1 X153.226 Y122.566 E.01092
G1 X137.603 Y138.189 E.43037
G1 X137.042 Y138.189 E.01092
G1 X153.226 Y122.005 E.44582
G1 X153.226 Y121.444 E.01092
G1 X136.481 Y138.189 E.46126
G1 X135.921 Y138.189 E.01092
G1 X153.226 Y120.884 E.47671
G1 X153.226 Y120.323 E.01092
G1 X135.36 Y138.189 E.49215
G1 X134.799 Y138.189 E.01092
G1 X153.226 Y119.762 E.5076
G1 X153.226 Y119.202 E.01092
G1 X134.239 Y138.189 E.52304
G1 X133.678 Y138.189 E.01092
G1 X153.226 Y118.641 E.53849
G1 X153.226 Y118.08 E.01092
G1 X133.117 Y138.189 E.55393
G1 X132.557 Y138.189 E.01092
G1 X153.226 Y117.52 E.56938
G1 X153.226 Y116.959 E.01092
G1 X131.996 Y138.189 E.58482
G1 X131.435 Y138.189 E.01092
G1 X153.226 Y116.398 E.60027
G1 X153.226 Y115.838 E.01092
G1 X130.875 Y138.189 E.61571
G1 X130.314 Y138.189 E.01092
G1 X153.226 Y115.277 E.63115
G1 X153.226 Y114.716 E.01092
G1 X129.753 Y138.189 E.6466
G1 X129.193 Y138.189 E.01092
G1 X153.226 Y114.156 E.66204
G1 X153.226 Y113.595 E.01092
G1 X128.632 Y138.189 E.67749
G1 X128.071 Y138.189 E.01092
G1 X153.226 Y113.034 E.69293
G1 X153.226 Y112.474 E.01092
G1 X127.51 Y138.189 E.70838
G1 X126.95 Y138.189 E.01092
G1 X152.214 Y112.925 E.69595
G3 X151.45 Y113.129 I-.921 J-1.918 E.0155
G1 X126.389 Y138.189 E.69033
G1 X125.828 Y138.189 E.01092
G1 X150.89 Y113.128 E.69035
G3 X150.426 Y113.031 I.437 J-3.241 E.00923
G1 X125.268 Y138.189 E.69303
G1 X124.707 Y138.189 E.01092
G1 X150.021 Y112.875 E.69733
G3 X149.669 Y112.666 I1.643 J-3.172 E.00797
G1 X124.146 Y138.189 E.70307
G1 X123.586 Y138.189 E.01092
G1 X149.363 Y112.411 E.71009
G3 X149.098 Y112.116 I1.105 J-1.259 E.00775
G1 X123.025 Y138.189 E.71823
G1 X122.464 Y138.189 E.01092
G1 X148.875 Y111.778 E.72754
G3 X148.707 Y111.386 I1.451 J-.858 E.00833
G1 X121.904 Y138.189 E.73833
G1 X121.343 Y138.189 E.01092
G1 X148.591 Y110.942 E.75058
G3 X148.563 Y110.409 I3.122 J-.43 E.01041
G1 X120.782 Y138.189 E.76526
G1 X120.222 Y138.189 E.01092
G1 X148.683 Y109.728 E.78401
G3 X148.965 Y109.121 I1.813 J.474 E.01311
G1 X148.828 Y109.022 E.00329
G1 X119.661 Y138.189 E.80345
G1 X119.1 Y138.189 E.01092
G1 X148.425 Y108.865 E.80778
G1 X147.864 Y108.865 E.01092
G1 X118.54 Y138.189 E.80778
G1 X117.979 Y138.189 E.01092
G1 X147.303 Y108.865 E.80778
G1 X146.742 Y108.865 E.01092
G1 X117.418 Y138.189 E.80777
G1 X116.858 Y138.189 E.01092
G1 X146.181 Y108.865 E.80777
G1 X145.62 Y108.866 E.01092
G1 X116.297 Y138.189 E.80776
G1 X115.736 Y138.189 E.01092
G1 X145.06 Y108.866 E.80776
G1 X144.499 Y108.866 E.01092
G1 X115.194 Y138.171 E.80725
G3 X114.665 Y138.139 I-.096 J-2.777 E.01033
G1 X143.938 Y108.866 E.80636
G1 X143.377 Y108.866 E.01092
G1 X114.175 Y138.068 E.80441
G3 X113.704 Y137.979 I.233 J-2.513 E.00936
M73 P81 R3
G1 X142.816 Y108.866 E.80194
G1 X142.255 Y108.867 E.01092
G1 X113.253 Y137.869 E.79893
G3 X112.82 Y137.741 I.679 J-3.089 E.0088
G1 X141.695 Y108.867 E.79539
G1 X141.134 Y108.867 E.01092
G1 X112.415 Y137.586 E.79111
G1 X112.014 Y137.426 E.0084
G1 X140.573 Y108.867 E.78669
G1 X140.012 Y108.867 E.01092
G1 X111.634 Y137.245 E.78172
G3 X111.276 Y137.042 I1.246 J-2.61 E.00802
G1 X139.451 Y108.867 E.77612
G1 X138.89 Y108.867 E.01092
G1 X110.921 Y136.837 E.77047
G3 X110.59 Y136.607 I1.04 J-1.848 E.00786
G1 X138.33 Y108.868 E.76413
G1 X137.769 Y108.868 E.01092
G1 X110.263 Y136.374 E.7577
G3 X109.952 Y136.124 I1.59 J-2.293 E.00777
G1 X137.208 Y108.868 E.75081
G1 X136.647 Y108.868 E.01092
G1 X109.661 Y135.854 E.74337
G1 X109.374 Y135.58 E.00772
G1 X136.086 Y108.868 E.73583
G1 X135.525 Y108.868 E.01092
G1 X109.101 Y135.292 E.72789
G3 X108.848 Y134.985 I2.061 J-1.957 E.00776
G1 X134.965 Y108.869 E.71942
G1 X134.404 Y108.869 E.01092
G1 X108.601 Y134.672 E.71078
G3 X108.373 Y134.339 I1.672 J-1.387 E.00787
G1 X133.843 Y108.869 E.7016
G1 X133.282 Y108.869 E.01092
G1 X108.153 Y133.998 E.69223
G3 X107.95 Y133.641 I1.703 J-1.203 E.00802
G1 X132.721 Y108.869 E.68237
G1 X132.16 Y108.869 E.01092
G1 X107.759 Y133.271 E.67218
G3 X107.587 Y132.882 I1.947 J-1.096 E.00829
G1 X131.6 Y108.869 E.66147
G1 X131.039 Y108.87 E.01092
G1 X107.426 Y132.482 E.65044
G3 X107.283 Y132.065 I2.847 J-1.213 E.0086
G1 X130.478 Y108.87 E.63894
G1 X129.917 Y108.87 E.01092
G1 X107.16 Y131.627 E.62687
G3 X107.066 Y131.16 I3.279 J-.907 E.00927
G1 X129.356 Y108.87 E.61402
G1 X128.795 Y108.87 E.01092
G1 X106.985 Y130.681 E.60082
G1 X106.934 Y130.171 E.00998
G1 X128.235 Y108.87 E.58676
G1 X127.674 Y108.871 E.01092
G1 X106.911 Y129.634 E.57196
G1 X106.91 Y129.073 E.01091
G1 X127.113 Y108.871 E.55652
G1 X126.552 Y108.871 E.01092
G1 X106.91 Y128.513 E.54108
G1 X106.909 Y127.953 E.01091
G1 X125.991 Y108.871 E.52565
G1 X125.43 Y108.871 E.01092
G1 X106.909 Y127.393 E.51021
G1 X106.908 Y126.833 E.01091
G1 X124.87 Y108.871 E.49478
G1 X124.309 Y108.871 E.01092
G1 X106.908 Y126.272 E.47934
G1 X106.907 Y125.712 E.01091
G1 X123.748 Y108.872 E.4639
G1 X123.187 Y108.872 E.01092
G1 X106.907 Y125.152 E.44847
G1 X106.906 Y124.592 E.01091
G1 X122.626 Y108.872 E.43303
G1 X122.065 Y108.872 E.01092
G1 X106.906 Y124.032 E.41759
G1 X106.905 Y123.471 E.01091
G1 X121.505 Y108.872 E.40216
G1 X120.944 Y108.872 E.01092
G1 X106.905 Y122.911 E.38672
G1 X106.905 Y122.351 E.01091
G1 X120.383 Y108.873 E.37129
G1 X119.822 Y108.873 E.01092
G1 X106.904 Y121.791 E.35585
G1 X106.904 Y121.231 E.01091
G1 X119.261 Y108.873 E.34041
G1 X118.7 Y108.873 E.01092
G1 X106.903 Y120.67 E.32498
G1 X106.903 Y120.11 E.01091
G1 X118.14 Y108.873 E.30954
G1 X117.579 Y108.873 E.01092
G1 X106.902 Y119.55 E.29411
G1 X106.902 Y118.99 E.01091
G1 X117.018 Y108.873 E.27867
G1 X116.457 Y108.874 E.01092
G1 X106.901 Y118.429 E.26323
G1 X106.901 Y117.869 E.01091
G1 X115.896 Y108.874 E.2478
G1 X115.335 Y108.874 E.01092
G1 X106.906 Y117.303 E.2322
G3 X106.951 Y116.698 I4.247 J.009 E.01183
G1 X114.735 Y108.914 E.21443
G2 X114.097 Y108.991 I.223 J4.495 E.01253
G1 X107.036 Y116.052 E.19451
G3 X107.182 Y115.345 I5.02 J.671 E.01408
G1 X113.373 Y109.154 E.17054
G2 X112.557 Y109.41 I1.293 J5.56 E.01668
G1 X107.448 Y114.518 E.14071
G1 X107.521 Y114.307 E.00435
G1 X107.881 Y113.525 E.01678
G1 X111.54 Y109.866 E.10078
G1 X111.232 Y110.025 E.00675
G2 X109.604 Y111.242 I4.476 J7.688 E.03968
G1 X108.209 Y112.636 E.03842
G1 X149.264 Y108.908 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.096388
G1 F15000
G1 X149.393 Y108.729 E.00076
; WIPE_START
G1 X149.264 Y108.908 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.824 Y108.312 Z4.618 F30000
G1 Z4.218
G1 E.8 F1800
; LINE_WIDTH: 0.205163
G1 F15000
G1 X150.541 Y108.468 E.00285
; LINE_WIDTH: 0.180928
G1 X150.433 Y108.531 E.00095
; LINE_WIDTH: 0.136012
G1 X150.322 Y108.597 E.0007
; LINE_WIDTH: 0.0966354
G1 X150.182 Y108.692 E.00059
G1 X150.43 Y108.447 F30000
; LINE_WIDTH: 0.22902
G1 F15000
G1 X150.788 Y108.404 E.0036
; LINE_WIDTH: 0.188503
G1 X151.052 Y108.388 E.00212
G1 X151.551 Y108.403 E.00398
; LINE_WIDTH: 0.223211
G1 X151.684 Y108.419 E.0013
; LINE_WIDTH: 0.25361
G1 X151.806 Y108.433 E.00138
; LINE_WIDTH: 0.291944
M73 P82 R3
G1 X151.943 Y108.457 E.00182
; LINE_WIDTH: 0.338479
G1 X152.065 Y108.479 E.00191
; LINE_WIDTH: 0.364693
G1 X152.35 Y108.54 E.00484
; WIPE_START
G1 X152.065 Y108.479 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X153.342 Y111.772 Z4.618 F30000
G1 Z4.218
G1 E.8 F1800
; LINE_WIDTH: 0.092325
G1 F15000
G3 X153.239 Y111.943 I-.254 J-.036 E.00067
; CHANGE_LAYER
; Z_HEIGHT: 4.33056
; LAYER_HEIGHT: 0.112563
; WIPE_START
G1 F15000
G1 X153.322 Y111.84 E-.49232
G1 X153.342 Y111.772 E-.26768
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 25/33
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
G17
G3 Z4.618 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X153.771 Y138.07
G1 Z4.331
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X153.674 Y138.237 E.00352
G3 X152.557 Y138.854 I-1.137 J-.739 E.02413
G1 X115.566 Y138.854 E.67153
G3 X106.235 Y129.523 I.004 J-9.335 E.26607
G1 X106.235 Y117.529 E.21774
G3 X115.566 Y108.198 I9.354 J.023 E.26592
G1 X152.643 Y108.203 E.67311
G3 X153.89 Y109.457 I-.083 J1.329 E.03512
G1 X153.89 Y137.595 E.51082
G3 X153.796 Y138.001 I-1.353 J-.097 E.0076
G1 X153.792 Y138.013 E.00023
; WIPE_START
M204 S10000
G1 X153.674 Y138.237 E-.09615
G1 X153.463 Y138.504 E-.12915
G1 X153.264 Y138.654 E-.09463
G1 X153.096 Y138.746 E-.07279
G1 X152.921 Y138.806 E-.07049
G1 X152.74 Y138.843 E-.07021
G1 X152.557 Y138.854 E-.06976
G1 X152.144 Y138.854 E-.15681
; WIPE_END
G1 E-.04 F1800
G1 X151.585 Y131.242 Z4.731 F30000
G1 X149.925 Y108.609 Z4.731
G1 Z4.331
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X149.592 Y108.896 E.00859
G2 X153.28 Y111.38 I1.583 J1.629 E.15774
G1 X153.479 Y111.425 E.00399
G1 X153.479 Y135.627 E.47265
G1 X153.272 Y135.666 E.00412
G2 X149.498 Y138.062 I-2.099 J.863 E.15482
G1 X149.891 Y138.444 E.0107
G1 X115.571 Y138.444 E.67027
G3 X106.646 Y129.518 I-.001 J-8.924 E.27382
G1 X106.646 Y117.534 E.23405
G3 X115.571 Y108.609 I8.942 J.017 E.27367
G1 X149.865 Y108.609 E.66977
M204 S250
G1 X150.425 Y108.824 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.631 Y108.747 E.00399
G3 X151.064 Y108.669 I.543 J1.778 E.00801
G1 X151.285 Y108.669 E.004
G3 X150.371 Y108.849 I-.11 J1.856 E.19502
; WIPE_START
M204 S10000
G1 X150.631 Y108.747 E-.10616
G1 X150.845 Y108.695 E-.08375
G1 X151.064 Y108.669 E-.08378
G1 X151.285 Y108.669 E-.08373
G1 X151.504 Y108.695 E-.08403
G1 X151.728 Y108.751 E-.08742
G1 X151.924 Y108.824 E-.07983
G1 X152.121 Y108.924 E-.08375
G1 X152.268 Y109.024 E-.06756
; WIPE_END
G1 E-.04 F1800
G1 X153.272 Y109.664 Z4.731 F30000
G1 Z4.331
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G2 X152.656 Y108.809 I-2.091 J.857 E.02076
G1 X152.761 Y108.626 E.00412
G1 X152.93 Y108.684 E.00348
G3 X153.479 Y109.624 I-.393 J.86 E.02265
G1 X153.331 Y109.653 E.00295
; WIPE_START
G1 X153.096 Y109.314 E-.15681
G1 X152.945 Y109.104 E-.0979
G1 X152.656 Y108.809 E-.15701
G1 X152.761 Y108.626 E-.08021
G1 X152.93 Y108.684 E-.0678
G1 X153.172 Y108.839 E-.10897
G1 X153.327 Y109.022 E-.0913
; WIPE_END
G1 E-.04 F1800
G1 X153.347 Y116.655 Z4.731 F30000
G1 X153.403 Y137.89 Z4.731
G1 Z4.331
G1 E.8 F1800
G1 F18000
G1 X153.34 Y138.009 E.00263
G3 X152.763 Y138.426 I-.799 J-.498 E.01425
G1 X152.656 Y138.251 E.004
G2 X153.28 Y137.383 I-1.485 J-1.725 E.02108
G1 X153.479 Y137.428 E.00399
G3 X153.425 Y137.834 I-.938 J.083 E.00807
M204 S250
G1 X152.813 Y137.406 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X152.803 Y137.426 E.00041
G3 X151.064 Y134.672 I-1.628 J-.898 E.14005
G1 X151.285 Y134.672 E.004
G3 X152.897 Y137.227 I-.11 J1.856 E.06404
G1 X152.839 Y137.352 E.0025
M204 S10000
G1 X153.415 Y137.203 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.48823
G1 F15000
G2 X153.441 Y136.091 I-4.672 J-.663 E.02372
; LINE_WIDTH: 0.498529
G1 X153.426 Y136.081 E.00038
; LINE_WIDTH: 0.473142
G1 X153.412 Y136.071 E.00036
; LINE_WIDTH: 0.436457
G1 X153.153 Y135.898 E.00588
G1 X153.247 Y135.13 F30000
; LINE_WIDTH: 0.0881176
G1 F15000
G2 X153.154 Y134.991 I-.198 J.032 E.00051
; WIPE_START
G1 X153.229 Y135.073 E-.49502
G1 X153.247 Y135.13 E-.26498
; WIPE_END
G1 E-.04 F1800
G1 X151.568 Y138.649 Z4.731 F30000
G1 Z4.331
G1 E.8 F1800
; LINE_WIDTH: 0.323162
G1 F15000
G1 X152.518 Y138.419 E.0134
G1 X152.534 Y138.445 F30000
; LINE_WIDTH: 0.213839
G1 F15000
G1 X151.921 Y138.555 E.00541
; LINE_WIDTH: 0.19354
G1 X151.799 Y138.573 E.00096
; LINE_WIDTH: 0.155995
G1 X151.67 Y138.593 E.00079
; LINE_WIDTH: 0.114901
G1 X151.421 Y138.615 E.00104
; LINE_WIDTH: 0.0857153
G1 X150.924 Y138.614 E.0014
; LINE_WIDTH: 0.115885
G1 X150.672 Y138.592 E.00106
; LINE_WIDTH: 0.15641
G1 X150.554 Y138.574 E.00073
; LINE_WIDTH: 0.193621
G3 X150.419 Y138.547 I-.034 J-.175 E.0011
; LINE_WIDTH: 0.179194
G1 X150.316 Y138.477 E.00089
; LINE_WIDTH: 0.134025
G1 X150.208 Y138.404 E.00066
; LINE_WIDTH: 0.094717
G1 X150.073 Y138.3 E.00055
G1 X149.294 Y138.231 F30000
; LINE_WIDTH: 0.0963186
G1 F15000
G1 X149.17 Y138.033 E.00077
; WIPE_START
G1 X149.294 Y138.231 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.892 Y130.622 Z4.731 F30000
G1 X151.637 Y108.404 Z4.731
G1 Z4.331
G1 E.8 F1800
; LINE_WIDTH: 0.394428
G1 F15000
G1 X152.328 Y108.591 E.01217
G1 X152.391 Y108.858 E.00466
G1 X152.526 Y108.624 F30000
; LINE_WIDTH: 0.266545
G1 F15000
G1 X152.049 Y108.523 E.00541
; LINE_WIDTH: 0.242504
G1 X151.932 Y108.502 E.00119
; LINE_WIDTH: 0.198933
G1 X151.807 Y108.48 E.00102
; LINE_WIDTH: 0.161314
G1 X151.679 Y108.464 E.00081
; LINE_WIDTH: 0.129603
G1 X151.546 Y108.448 E.00065
; LINE_WIDTH: 0.0942428
G1 X151.052 Y108.434 E.00159
G1 X150.798 Y108.449 E.00082
; LINE_WIDTH: 0.129119
G1 X150.676 Y108.463 E.00059
; LINE_WIDTH: 0.164223
G1 X150.509 Y108.486 E.00108
; LINE_WIDTH: 0.169603
G1 X150.417 Y108.54 E.00071
; LINE_WIDTH: 0.131117
G1 X150.322 Y108.597 E.00055
; LINE_WIDTH: 0.0949267
G1 X150.182 Y108.691 E.00055
; WIPE_START
G1 X150.322 Y108.597 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.05 Y109.327 Z4.731 F30000
G1 Z4.331
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.421816
G1 F15000
G1 X148.681 Y108.958 E.00952
G1 X148.119 Y108.958 E.01026
G1 X148.736 Y109.575 E.01591
G2 X148.607 Y110.009 I2.849 J1.085 E.00825
G1 X147.557 Y108.958 E.02709
G1 X146.994 Y108.958 E.01026
G1 X148.556 Y110.52 E.04029
G2 X148.633 Y111.16 I2.81 J-.014 E.01177
G1 X146.432 Y108.958 E.05678
G1 X145.87 Y108.958 E.01026
G1 X153.13 Y116.218 E.18725
G1 X153.13 Y115.656 E.01026
G1 X150.544 Y113.07 E.06669
G2 X151.184 Y113.148 I.532 J-1.712 E.01182
G1 X153.13 Y115.094 E.05019
G1 X153.13 Y114.531 E.01026
G1 X151.691 Y113.093 E.03711
G2 X152.127 Y112.966 I-.65 J-3.067 E.00829
G1 X153.13 Y113.969 E.02586
G1 X153.13 Y113.407 E.01026
G1 X152.504 Y112.781 E.01614
G2 X152.836 Y112.551 I-.8 J-1.508 E.00739
G1 X153.308 Y113.022 E.01217
G1 X153.06 Y112.178 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.0996714
G1 F15000
G1 X153.216 Y112.026 E.00076
G1 X153.246 Y111.928 E.00035
G1 X153.415 Y111.2 F30000
; LINE_WIDTH: 0.488234
G1 F15000
G2 X153.441 Y110.089 I-4.671 J-.663 E.02372
; LINE_WIDTH: 0.498565
G1 X153.426 Y110.079 E.00038
; LINE_WIDTH: 0.473217
G1 X153.412 Y110.069 E.00036
; LINE_WIDTH: 0.436577
G1 X153.153 Y109.896 E.00588
; WIPE_START
G1 X153.412 Y110.069 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X153.308 Y116.959 Z4.731 F30000
G1 Z4.331
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.421816
G1 F15000
G1 X145.307 Y108.958 E.20635
G1 X144.745 Y108.958 E.01026
G1 X153.13 Y117.343 E.21626
G1 X153.13 Y117.906 E.01026
G1 X144.182 Y108.958 E.23077
G1 X143.62 Y108.958 E.01026
G1 X153.13 Y118.468 E.24527
G1 X153.13 Y119.03 E.01026
G1 X143.058 Y108.958 E.25978
G1 X142.495 Y108.958 E.01026
G1 X153.13 Y119.593 E.27428
G1 X153.13 Y120.155 E.01026
G1 X141.933 Y108.958 E.28879
G1 X141.371 Y108.958 E.01026
G1 X153.13 Y120.717 E.30329
G1 X153.13 Y121.28 E.01026
G1 X140.808 Y108.958 E.3178
G1 X140.246 Y108.958 E.01026
G1 X153.13 Y121.842 E.3323
G1 X153.13 Y122.405 E.01026
G1 X139.683 Y108.958 E.34681
G1 X139.121 Y108.958 E.01026
G1 X153.13 Y122.967 E.36131
G1 X153.13 Y123.529 E.01026
G1 X138.559 Y108.958 E.37581
G1 X137.996 Y108.958 E.01026
G1 X153.13 Y124.092 E.39032
G1 X153.13 Y124.654 E.01026
G1 X137.434 Y108.958 E.40482
G1 X136.872 Y108.958 E.01026
G1 X153.13 Y125.216 E.41933
G1 X153.13 Y125.779 E.01026
G1 X136.309 Y108.958 E.43383
G1 X135.747 Y108.958 E.01026
G1 X153.13 Y126.341 E.44834
G1 X153.13 Y126.904 E.01026
G1 X135.184 Y108.958 E.46284
G1 X134.622 Y108.958 E.01026
G1 X153.13 Y127.466 E.47735
G1 X153.13 Y128.028 E.01026
G1 X134.06 Y108.958 E.49185
G1 X133.497 Y108.958 E.01026
G1 X153.13 Y128.591 E.50636
G1 X153.13 Y129.153 E.01026
G1 X132.935 Y108.958 E.52086
G1 X132.373 Y108.958 E.01026
G1 X153.13 Y129.715 E.53537
G1 X153.13 Y130.278 E.01026
G1 X131.81 Y108.958 E.54987
G1 X131.248 Y108.958 E.01026
G1 X153.13 Y130.84 E.56438
G1 X153.13 Y131.403 E.01026
G1 X130.685 Y108.958 E.57888
G1 X130.123 Y108.958 E.01026
G1 X153.13 Y131.965 E.59339
G1 X153.13 Y132.527 E.01026
G1 X129.561 Y108.958 E.60789
G1 X128.998 Y108.958 E.01026
G1 X153.13 Y133.09 E.6224
G1 X153.13 Y133.652 E.01026
G1 X128.436 Y108.958 E.6369
G1 X127.873 Y108.958 E.01026
G1 X153.13 Y134.214 E.6514
G1 X153.13 Y134.54 E.00594
G1 X153.006 Y134.653 E.00306
G1 X127.311 Y108.958 E.66272
G1 X126.749 Y108.958 E.01026
G1 X151.771 Y133.981 E.64538
G2 X151.14 Y133.911 I-.598 J2.534 E.01162
G1 X126.186 Y108.958 E.64359
G1 X125.624 Y108.958 E.01026
G1 X150.633 Y133.967 E.64502
G2 X150.201 Y134.098 I.334 J1.875 E.00824
G1 X125.062 Y108.958 E.6484
G1 X124.499 Y108.958 E.01026
G1 X149.825 Y134.284 E.65319
G2 X149.498 Y134.519 I.779 J1.43 E.00737
G1 X123.937 Y108.958 E.65926
G1 X123.374 Y108.958 E.01026
G1 X149.212 Y134.796 E.66641
G2 X148.968 Y135.114 I1.213 J1.184 E.00733
G1 X122.812 Y108.958 E.67461
G1 X122.25 Y108.958 E.01026
G1 X148.774 Y135.483 E.68412
G2 X148.632 Y135.903 I1.694 J.807 E.00811
G1 X121.687 Y108.958 E.69496
G1 X121.125 Y108.958 E.01026
G1 X148.56 Y136.393 E.7076
G2 X148.598 Y136.994 I2.772 J.127 E.01099
G1 X120.563 Y108.958 E.72308
G1 X120 Y108.958 E.01026
G1 X148.858 Y137.816 E.7443
G1 X148.647 Y137.95 E.00456
G1 X148.738 Y138.094 E.00312
G1 X148.574 Y138.094 E.003
G1 X119.438 Y108.958 E.75147
G1 X118.875 Y108.958 E.01026
G1 X148.012 Y138.094 E.75147
G1 X147.449 Y138.094 E.01026
G1 X118.313 Y108.958 E.75147
G1 X117.751 Y108.958 E.01026
G1 X146.887 Y138.094 E.75147
G1 X146.324 Y138.094 E.01026
G1 X117.188 Y108.958 E.75147
G1 X116.626 Y108.958 E.01026
G1 X145.762 Y138.094 E.75147
G1 X145.2 Y138.094 E.01026
G1 X116.064 Y108.958 E.75147
G2 X115.505 Y108.962 I-.242 J5.9 E.0102
G1 X144.637 Y138.094 E.75138
G1 X144.075 Y138.094 E.01026
G1 X114.968 Y108.987 E.75073
G2 X114.458 Y109.039 I.018 J2.692 E.00937
G1 X143.513 Y138.094 E.74938
G1 X142.95 Y138.094 E.01026
G1 X113.966 Y109.11 E.74756
G2 X113.505 Y109.212 I2.108 J10.677 E.00861
G1 X142.388 Y138.094 E.74494
G1 X141.825 Y138.094 E.01026
G1 X113.07 Y109.339 E.74165
G2 X112.643 Y109.474 I.726 J3.053 E.00818
G1 X141.263 Y138.094 E.73817
G1 X140.701 Y138.094 E.01026
G1 X112.239 Y109.632 E.73409
G2 X111.854 Y109.81 I1.052 J2.775 E.00773
G1 X140.138 Y138.094 E.7295
G1 X139.576 Y138.094 E.01026
G1 X111.483 Y110.002 E.72456
G2 X111.125 Y110.206 I.89 J1.975 E.00753
G1 X139.014 Y138.094 E.7193
M73 P83 R3
G1 X138.451 Y138.094 E.01026
G1 X110.783 Y110.426 E.71362
G2 X110.449 Y110.655 I1.434 J2.443 E.00738
G1 X137.889 Y138.094 E.70771
G1 X137.326 Y138.094 E.01026
G1 X110.137 Y110.905 E.70127
G1 X109.836 Y111.166 E.00727
G1 X136.764 Y138.094 E.69454
G1 X136.202 Y138.094 E.01026
G1 X109.545 Y111.437 E.68753
G1 X109.27 Y111.725 E.00725
G1 X135.639 Y138.094 E.68011
G1 X135.077 Y138.094 E.01026
G1 X109.002 Y112.02 E.67251
G2 X108.754 Y112.333 I2.446 J2.195 E.00731
G1 X134.515 Y138.094 E.66442
G1 X133.952 Y138.094 E.01026
G1 X108.517 Y112.659 E.65603
G2 X108.297 Y113.001 I2.568 J1.891 E.00743
G1 X133.39 Y138.094 E.6472
G1 X132.827 Y138.094 E.01026
G1 X108.084 Y113.351 E.63818
G2 X107.893 Y113.722 I2.497 J1.523 E.00762
G1 X132.265 Y138.094 E.62861
G1 X131.703 Y138.094 E.01026
G1 X107.716 Y114.108 E.61865
G2 X107.549 Y114.503 I2.68 J1.368 E.00783
G1 X131.14 Y138.094 E.60846
G1 X130.578 Y138.094 E.01026
G1 X107.408 Y114.925 E.59759
G1 X107.28 Y115.359 E.00826
G1 X130.016 Y138.094 E.58638
G1 X129.453 Y138.094 E.01026
G1 X107.177 Y115.818 E.57454
G1 X107.086 Y116.29 E.00876
G1 X128.891 Y138.094 E.56238
G1 X128.328 Y138.094 E.01026
G1 X107.036 Y116.802 E.54918
G2 X107 Y117.329 I3.665 J.512 E.00964
G1 X127.766 Y138.094 E.53559
G1 X127.204 Y138.094 E.01026
G1 X106.995 Y117.886 E.52121
G1 X106.996 Y118.449 E.01027
G1 X126.641 Y138.094 E.50669
G1 X126.079 Y138.094 E.01026
G1 X106.996 Y119.012 E.49217
G1 X106.997 Y119.575 E.01026
G1 X125.517 Y138.094 E.47766
G1 X124.954 Y138.094 E.01026
G1 X106.997 Y120.138 E.46314
G1 X106.998 Y120.7 E.01027
G1 X124.392 Y138.094 E.44862
G1 X123.829 Y138.094 E.01026
G1 X106.998 Y121.263 E.43411
G1 X106.999 Y121.826 E.01026
G1 X123.267 Y138.094 E.41959
G1 X122.705 Y138.094 E.01026
G1 X106.999 Y122.389 E.40507
G1 X107 Y122.952 E.01026
G1 X122.142 Y138.094 E.39056
G1 X121.58 Y138.094 E.01026
G1 X107 Y123.515 E.37604
G1 X107.001 Y124.077 E.01026
G1 X121.018 Y138.094 E.36152
G1 X120.455 Y138.094 E.01026
G1 X107.001 Y124.64 E.34701
G1 X107.002 Y125.203 E.01026
G1 X119.893 Y138.094 E.33249
G1 X119.33 Y138.094 E.01026
G1 X107.002 Y125.766 E.31797
G1 X107.002 Y126.329 E.01026
G1 X118.768 Y138.094 E.30345
G1 X118.206 Y138.094 E.01026
G1 X107.003 Y126.892 E.28894
G1 X107.003 Y127.455 E.01026
G1 X117.643 Y138.094 E.27442
G1 X117.081 Y138.094 E.01026
G1 X107.004 Y128.017 E.2599
G1 X107.004 Y128.58 E.01026
G1 X116.519 Y138.094 E.24539
G1 X115.956 Y138.094 E.01026
G1 X107.005 Y129.143 E.23087
G1 X107.005 Y129.706 E.01027
G1 X115.385 Y138.085 E.21612
G1 X114.794 Y138.057 E.01078
G1 X107.041 Y130.304 E.19997
G2 X107.116 Y130.941 I4.489 J-.204 E.01171
G1 X114.142 Y137.968 E.18124
G3 X113.432 Y137.82 I.819 J-5.699 E.01325
G1 X107.276 Y131.663 E.15878
G2 X107.526 Y132.476 I5.583 J-1.275 E.01553
G1 X112.613 Y137.563 E.13121
G3 X111.597 Y137.11 I1.867 J-5.547 E.02032
G1 X107.98 Y133.492 E.0933
G1 X108.144 Y133.81 E.00652
G2 X109.356 Y135.431 I7.646 J-4.455 E.037
G1 X110.744 Y136.819 E.03581
; CHANGE_LAYER
; Z_HEIGHT: 4.42906
; LAYER_HEIGHT: 0.0985003
; WIPE_START
G1 F15000
G1 X109.356 Y135.431 E-.74608
G1 X109.332 Y135.403 E-.01392
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 26/33
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change
G17
G3 Z4.731 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X153.675 Y138.06
G1 Z4.429
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X153.662 Y138.086 E.00045
G3 X152.556 Y138.761 I-1.104 J-.565 E.02183
G1 X115.566 Y138.761 E.5921
G3 X106.329 Y129.523 I.022 J-9.26 E.23212
G1 X106.329 Y117.529 E.19199
G3 X115.566 Y108.292 I9.26 J.022 E.23212
G1 X152.615 Y108.296 E.59305
G3 X153.798 Y109.532 I-.059 J1.24 E.03022
G1 X153.798 Y137.52 E.44801
G3 X153.759 Y137.828 I-1.241 J0 E.00497
G1 X153.695 Y138.004 E.003
; WIPE_START
M204 S10000
G1 X153.662 Y138.086 E-.03352
G1 X153.549 Y138.27 E-.08222
G1 X153.412 Y138.422 E-.07764
G1 X153.253 Y138.551 E-.07781
G1 X153.093 Y138.642 E-.06981
G1 X152.919 Y138.708 E-.07108
G1 X152.742 Y138.748 E-.06873
G1 X152.556 Y138.761 E-.07096
G1 X152.008 Y138.761 E-.20824
; WIPE_END
G1 E-.04 F1800
G1 X152.289 Y131.134 Z4.829 F30000
G1 X153.094 Y109.306 Z4.829
G1 Z4.429
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X152.914 Y109.055 E.00531
G1 X153.099 Y108.902 E.00413
G1 X153.191 Y108.999 E.00231
G3 X153.301 Y109.167 I-.606 J.514 E.00346
G1 X153.144 Y109.272 E.00326
; WIPE_START
G1 X152.914 Y109.055 E-.22254
G1 X153.099 Y108.902 E-.16887
G1 X153.191 Y108.999 E-.09443
G1 X153.301 Y109.167 E-.14111
G1 X153.144 Y109.272 E-.13306
; WIPE_END
G1 E-.04 F1800
G1 X150.426 Y108.823 Z4.829 F30000
G1 Z4.429
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X150.637 Y108.745 E.0036
G3 X150.846 Y108.695 I.538 J1.78 E.00344
G1 X151.065 Y108.669 E.00353
G3 X150.371 Y108.848 I.11 J1.856 E.17545
M204 S10000
G1 X149.762 Y108.705 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
M73 P84 R3
G1 X149.408 Y109.093 E.00904
G2 X153.198 Y111.575 I1.771 J1.431 E.13092
G1 X153.384 Y111.628 E.00333
G1 X153.384 Y135.433 E.40971
G1 X153.191 Y135.483 E.00343
G2 X149.496 Y138.064 I-2.017 J1.049 E.1331
G1 X149.788 Y138.347 E.00699
G1 X115.571 Y138.347 E.58891
G3 X106.742 Y129.518 I.017 J-8.846 E.23857
G1 X106.742 Y117.534 E.20626
G3 X115.571 Y108.705 I8.846 J.017 E.23857
G1 X149.702 Y108.705 E.58744
; WIPE_START
G1 X149.408 Y109.093 E-.18492
G1 X149.251 Y109.312 E-.1025
G1 X149.121 Y109.548 E-.10236
G1 X149.019 Y109.798 E-.1024
G1 X148.948 Y110.058 E-.10252
G1 X148.909 Y110.324 E-.10243
G1 X148.904 Y110.49 E-.06288
; WIPE_END
G1 E-.04 F1800
G1 X150.001 Y118.043 Z4.829 F30000
G1 X152.814 Y137.406 Z4.829
G1 Z4.429
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X152.803 Y137.426 E.00037
G3 X151.064 Y134.672 I-1.628 J-.898 E.12351
G1 X151.285 Y134.672 E.00353
G3 X152.896 Y137.233 I-.11 J1.856 E.05656
G1 X152.839 Y137.351 E.0021
M204 S10000
G1 X153.327 Y137.425 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.54392
G1 F15000
G1 X153.333 Y137.394 E.00065
; LINE_WIDTH: 0.51724
G1 X153.353 Y137.269 E.00252
; LINE_WIDTH: 0.471537
G2 X153.378 Y137.118 I-2.489 J-.477 E.00277
; LINE_WIDTH: 0.435126
G1 X153.39 Y136.995 E.00205
; LINE_WIDTH: 0.407359
G1 X153.405 Y136.85 E.00226
; LINE_WIDTH: 0.385815
G2 X153.391 Y136.05 I-5.092 J-.311 E.01173
; LINE_WIDTH: 0.444168
G1 X153.338 Y135.658 E.00671
G1 X153.151 Y134.988 F30000
; LINE_WIDTH: 0.0945164
G1 F15000
G1 X153.122 Y134.904 E.00026
G1 X152.967 Y134.77 E.0006
G1 X152.587 Y134.534 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.420038
G1 F15000
G1 X153.032 Y134.089 E.01009
G1 X153.032 Y133.524 E.00903
G1 X152.365 Y134.192 E.01511
G2 X151.967 Y134.025 I-.896 J1.583 E.00692
G1 X153.032 Y132.96 E.02411
G1 X153.032 Y132.396 E.00903
G1 X151.502 Y133.926 E.03464
G2 X150.95 Y133.914 I-.338 J2.78 E.00885
G1 X153.032 Y131.832 E.04714
G1 X153.032 Y131.268 E.00903
G1 X150.212 Y134.089 E.06386
G2 X148.735 Y135.565 I.922 J2.399 E.03442
G1 X146.305 Y137.995 E.05503
G1 X146.869 Y137.995 E.00903
G1 X148.557 Y136.307 E.03822
G2 X148.571 Y136.858 I2.317 J.218 E.00884
G1 X147.433 Y137.995 E.02576
G1 X147.997 Y137.995 E.00903
G1 X148.673 Y137.319 E.01531
G2 X148.837 Y137.72 I1.765 J-.487 E.00694
G1 X148.382 Y138.175 E.0103
; WIPE_START
G1 X148.837 Y137.72 E-.24452
G1 X148.74 Y137.516 E-.08585
G1 X148.673 Y137.319 E-.07884
G1 X148.021 Y137.972 E-.35079
; WIPE_END
G1 E-.04 F1800
G1 X150.074 Y138.303 Z4.829 F30000
G1 Z4.429
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.0919348
G1 F15000
G1 X150.208 Y138.406 E.00048
; LINE_WIDTH: 0.13402
G1 X150.428 Y138.554 E.0012
G1 X150.586 Y138.531 F30000
; LINE_WIDTH: 0.104205
G1 F15000
G3 X150.209 Y138.468 I.868 J-6.307 E.00128
G1 X152.364 Y138.554 F30000
; LINE_WIDTH: 0.636511
G1 F15000
G1 X152.912 Y138.151 E.01679
; LINE_WIDTH: 0.676662
G2 X153.251 Y137.702 I-.712 J-.888 E.01496
; LINE_WIDTH: 0.638988
G1 X153.285 Y137.598 E.0027
; LINE_WIDTH: 0.604982
G1 X153.308 Y137.506 E.00223
; WIPE_START
G1 X153.285 Y137.598 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X145.673 Y138.167 Z4.829 F30000
G1 X145.561 Y138.175 Z4.829
G1 Z4.429
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.420038
G1 F15000
G1 X153.032 Y130.704 E.16915
G1 X153.032 Y130.14 E.00903
G1 X145.177 Y137.995 E.17786
G1 X144.612 Y137.995 E.00903
G1 X153.032 Y129.576 E.19063
G1 X153.032 Y129.011 E.00903
G1 X144.048 Y137.995 E.2034
G1 X143.484 Y137.995 E.00903
G1 X153.032 Y128.447 E.21617
G1 X153.032 Y127.883 E.00903
G1 X142.92 Y137.995 E.22894
G1 X142.356 Y137.995 E.00903
G1 X153.032 Y127.319 E.24172
G1 X153.032 Y126.755 E.00903
G1 X141.792 Y137.995 E.25449
G1 X141.228 Y137.995 E.00903
G1 X153.032 Y126.191 E.26726
G1 X153.032 Y125.627 E.00903
G1 X140.664 Y137.995 E.28003
G1 X140.099 Y137.995 E.00903
G1 X153.032 Y125.062 E.2928
G1 X153.032 Y124.498 E.00903
G1 X139.535 Y137.995 E.30557
G1 X138.971 Y137.995 E.00903
G1 X153.032 Y123.934 E.31835
G1 X153.032 Y123.37 E.00903
G1 X138.407 Y137.995 E.33112
G1 X137.843 Y137.995 E.00903
G1 X153.032 Y122.806 E.34389
G1 X153.032 Y122.242 E.00903
G1 X137.279 Y137.995 E.35666
G1 X136.715 Y137.995 E.00903
G1 X153.032 Y121.678 E.36943
G1 X153.032 Y121.114 E.00903
G1 X136.151 Y137.995 E.38221
G1 X135.586 Y137.995 E.00903
G1 X153.032 Y120.549 E.39498
G1 X153.032 Y119.985 E.00903
G1 X135.022 Y137.995 E.40775
G1 X134.458 Y137.995 E.00903
G1 X153.032 Y119.421 E.42052
G1 X153.032 Y118.857 E.00903
G1 X133.894 Y137.995 E.43329
G1 X133.33 Y137.995 E.00903
G1 X153.032 Y118.293 E.44607
G1 X153.032 Y117.729 E.00903
G1 X132.766 Y137.995 E.45884
G1 X132.202 Y137.995 E.00903
G1 X153.032 Y117.165 E.47161
G1 X153.032 Y116.601 E.00903
G1 X131.637 Y137.995 E.48438
G1 X131.073 Y137.995 E.00903
G1 X153.032 Y116.036 E.49715
G1 X153.032 Y115.472 E.00903
G1 X130.509 Y137.995 E.50993
G1 X129.945 Y137.995 E.00903
G1 X153.032 Y114.908 E.5227
G1 X153.032 Y114.344 E.00903
G1 X129.381 Y137.995 E.53547
G1 X128.817 Y137.995 E.00903
G1 X153.032 Y113.78 E.54824
G1 X153.032 Y113.216 E.00903
G1 X128.253 Y137.995 E.56101
M73 P84 R2
G1 X127.689 Y137.995 E.00903
G1 X153.031 Y112.653 E.57374
G1 X152.894 Y112.513 E.00314
G3 X152.163 Y112.957 I-1.59 J-1.792 E.01376
G1 X127.124 Y137.995 E.56688
G1 X126.56 Y137.995 E.00903
G1 X151.416 Y113.139 E.56274
G3 X150.857 Y113.134 I-.246 J-3.635 E.00896
G1 X125.996 Y137.995 E.56286
G1 X125.432 Y137.995 E.00903
G1 X150.396 Y113.031 E.56519
G3 X149.992 Y112.871 I.468 J-1.779 E.00698
G1 X124.868 Y137.995 E.56881
G1 X124.304 Y137.995 E.00903
G1 X149.643 Y112.657 E.57367
G3 X149.337 Y112.398 I.935 J-1.414 E.00642
G1 X123.74 Y137.995 E.57953
G1 X123.176 Y137.995 E.00903
G1 X149.073 Y112.098 E.58631
G3 X148.854 Y111.753 I2.938 J-2.104 E.00655
G1 X122.611 Y137.995 E.59413
G1 X122.047 Y137.995 E.00903
G1 X148.686 Y111.356 E.60311
G3 X148.575 Y110.904 I3.438 J-1.087 E.00747
G1 X121.483 Y137.995 E.61336
G1 X120.919 Y137.995 E.00903
G1 X148.556 Y110.359 E.62569
G3 X148.699 Y109.651 I1.936 J.025 E.01163
G1 X120.355 Y137.995 E.64172
G1 X119.791 Y137.995 E.00903
G1 X148.729 Y109.057 E.65516
G1 X148.165 Y109.057 E.00903
G1 X119.227 Y137.995 E.65516
G1 X118.662 Y137.995 E.00903
G1 X147.601 Y109.057 E.65516
G1 X147.037 Y109.057 E.00903
G1 X118.098 Y137.995 E.65516
G1 X117.534 Y137.995 E.00903
G1 X146.472 Y109.057 E.65516
G1 X145.908 Y109.057 E.00903
G1 X116.97 Y137.995 E.65516
G1 X116.406 Y137.995 E.00903
G1 X145.344 Y109.057 E.65516
G1 X144.78 Y109.057 E.00903
G1 X115.842 Y137.995 E.65516
G3 X115.291 Y137.982 I-.131 J-5.816 E.00882
G1 X144.216 Y109.057 E.65485
G1 X143.652 Y109.057 E.00903
G1 X114.753 Y137.956 E.65426
G1 X114.26 Y137.885 E.00798
G1 X143.088 Y109.057 E.65266
G1 X142.524 Y109.057 E.00903
G1 X113.782 Y137.799 E.6507
G1 X113.328 Y137.688 E.00748
G1 X141.959 Y109.057 E.64821
G1 X141.395 Y109.057 E.00903
G1 X112.892 Y137.561 E.64532
G3 X112.477 Y137.411 I1.36 J-4.425 E.00706
G1 X140.831 Y109.057 E.64194
G1 X140.267 Y109.057 E.00903
G1 X112.082 Y137.242 E.6381
G3 X111.704 Y137.056 I1.238 J-2.991 E.00675
G1 X139.703 Y109.057 E.63388
G1 X139.139 Y109.057 E.00903
G1 X111.333 Y136.863 E.62951
G3 X110.983 Y136.649 I31.403 J-52.039 E.00657
G1 X138.575 Y109.057 E.62469
G1 X138.011 Y109.057 E.00903
G1 X110.646 Y136.421 E.61952
G1 X110.327 Y136.177 E.00644
G1 X137.446 Y109.057 E.61399
G1 X136.882 Y109.057 E.00903
G1 X110.021 Y135.919 E.60814
G1 X109.72 Y135.656 E.0064
G1 X136.318 Y109.057 E.60219
G1 X135.754 Y109.057 E.00903
G1 X109.437 Y135.374 E.59581
G1 X109.175 Y135.072 E.0064
G1 X135.19 Y109.057 E.58897
G1 X134.626 Y109.057 E.00903
G1 X108.914 Y134.769 E.58212
G3 X108.671 Y134.447 I2.117 J-1.845 E.00645
G1 X134.062 Y109.057 E.57484
G1 X133.497 Y109.057 E.00903
G1 X108.45 Y134.104 E.56707
G1 X108.23 Y133.761 E.00654
G1 X132.933 Y109.057 E.55929
G1 X132.369 Y109.057 E.00903
G1 X108.031 Y133.395 E.55102
G1 X107.854 Y133.008 E.00682
G1 X131.805 Y109.057 E.54225
G1 X131.241 Y109.057 E.00903
G1 X107.682 Y132.617 E.53338
M73 P85 R2
G1 X107.537 Y132.198 E.0071
G1 X130.677 Y109.057 E.5239
G1 X130.113 Y109.057 E.00903
G1 X107.403 Y131.767 E.51416
G1 X107.292 Y131.313 E.00748
G1 X129.549 Y109.057 E.50388
G1 X128.984 Y109.057 E.00903
G1 X107.199 Y130.842 E.49322
G3 X107.143 Y130.335 I3.518 J-.647 E.00819
G1 X128.42 Y109.057 E.48172
G1 X127.856 Y109.057 E.00903
G1 X107.104 Y129.809 E.46982
G1 X107.104 Y129.246 E.00902
G1 X127.292 Y109.057 E.45706
G1 X126.728 Y109.057 E.00903
G1 X107.103 Y128.682 E.4443
G1 X107.103 Y128.118 E.00902
G1 X126.164 Y109.057 E.43154
G1 X125.6 Y109.057 E.00903
G1 X107.102 Y127.555 E.41878
G1 X107.102 Y126.991 E.00902
G1 X125.036 Y109.057 E.40602
G1 X124.471 Y109.057 E.00903
G1 X107.101 Y126.427 E.39326
G1 X107.101 Y125.864 E.00902
G1 X123.907 Y109.057 E.38049
G1 X123.343 Y109.057 E.00903
G1 X107.101 Y125.3 E.36773
G1 X107.1 Y124.736 E.00902
G1 X122.779 Y109.057 E.35497
G1 X122.215 Y109.057 E.00903
G1 X107.1 Y124.173 E.34221
G1 X107.099 Y123.609 E.00902
G1 X121.651 Y109.057 E.32945
G1 X121.087 Y109.057 E.00903
G1 X107.099 Y123.045 E.31669
G1 X107.098 Y122.482 E.00902
G1 X120.522 Y109.057 E.30393
G1 X119.958 Y109.057 E.00903
G1 X107.098 Y121.918 E.29116
G1 X107.097 Y121.354 E.00902
G1 X119.394 Y109.057 E.2784
G1 X118.83 Y109.057 E.00903
G1 X107.097 Y120.79 E.26564
G1 X107.096 Y120.227 E.00902
G1 X118.266 Y109.057 E.25288
G1 X117.702 Y109.057 E.00903
G1 X107.096 Y119.663 E.24012
G1 X107.095 Y119.1 E.00902
G1 X117.138 Y109.057 E.22736
G1 X116.574 Y109.057 E.00903
G1 X107.095 Y118.536 E.2146
G1 X107.094 Y117.972 E.00902
G1 X116.009 Y109.057 E.20183
G2 X115.439 Y109.064 I-.215 J6.024 E.00914
G1 X107.097 Y117.405 E.18885
G3 X107.135 Y116.804 I4.226 J-.038 E.00966
G1 X114.846 Y109.092 E.17459
G2 X114.197 Y109.177 I.118 J3.431 E.01049
G1 X107.206 Y116.168 E.15828
G3 X107.364 Y115.447 I5.118 J.737 E.01183
G1 X113.495 Y109.316 E.13881
G2 X112.669 Y109.577 I1.413 J5.899 E.01387
G1 X107.614 Y114.632 E.11446
G1 X107.701 Y114.379 E.0043
G1 X108.036 Y113.646 E.0129
G1 X111.66 Y110.022 E.08205
G1 X111.329 Y110.192 E.00597
G2 X109.727 Y111.391 I4.399 J7.551 E.03209
G1 X108.358 Y112.76 E.031
; WIPE_START
G1 X109.727 Y111.391 E-.73576
G1 X109.775 Y111.349 E-.02424
; WIPE_END
G1 E-.04 F1800
G1 X117.393 Y110.87 Z4.829 F30000
G1 X149.97 Y108.82 Z4.829
G1 Z4.429
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.091923
G1 F15000
G1 X150.098 Y108.71 E.00048
; LINE_WIDTH: 0.127759
G1 X150.185 Y108.643 E.00047
; LINE_WIDTH: 0.165538
G1 X150.268 Y108.58 E.0006
; LINE_WIDTH: 0.17416
G1 X150.309 Y108.57 E.00026
; LINE_WIDTH: 0.140766
G1 X150.451 Y108.545 E.00069
; LINE_WIDTH: 0.0965439
G1 X150.584 Y108.521 E.00041
G1 X151.807 Y108.499 F30000
; LINE_WIDTH: 0.287828
G1 F15000
G1 X152.9 Y108.798 E.01212
G1 X152.855 Y108.835 F30000
; LINE_WIDTH: 0.452273
G1 F15000
G1 X152.577 Y108.72 E.00521
G2 X151.937 Y108.499 I-4.079 J10.732 E.01172
; WIPE_START
G1 X152.577 Y108.72 E-.52629
G1 X152.855 Y108.835 E-.23371
; WIPE_END
G1 E-.04 F1800
G1 X153.286 Y109.426 Z4.829 F30000
G1 Z4.429
G1 E.8 F1800
; LINE_WIDTH: 0.511781
G1 F15000
G1 X153.353 Y109.775 E.00699
; LINE_WIDTH: 0.474663
G3 X153.375 Y109.925 I-2.487 J.424 E.00276
; LINE_WIDTH: 0.437882
G1 X153.391 Y110.048 E.00207
; LINE_WIDTH: 0.385808
G3 X153.405 Y110.848 I-5.081 J.489 E.01173
; LINE_WIDTH: 0.407329
G1 X153.391 Y110.993 E.00225
; LINE_WIDTH: 0.435035
G1 X153.378 Y111.115 E.00205
; LINE_WIDTH: 0.459658
G3 X153.332 Y111.398 I-4.761 J-.626 E.00504
G1 X153.17 Y112.078 F30000
; LINE_WIDTH: 0.0837138
G1 F15000
G1 X153.063 Y112.182 E.00037
; CHANGE_LAYER
; Z_HEIGHT: 4.51203
; LAYER_HEIGHT: 0.0829763
; WIPE_START
G1 F15000
G1 X153.17 Y112.078 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 27/33
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change
G17
G3 Z4.829 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X153.595 Y138.005
G1 Z4.512
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X153.519 Y138.147 E.00219
G3 X152.556 Y138.67 I-.966 J-.631 E.01553
G1 X115.566 Y138.67 E.50295
G3 X106.419 Y129.523 I.003 J-9.15 E.19535
G1 X106.419 Y117.529 E.16308
G3 X115.566 Y108.382 I9.15 J.003 E.19535
G1 X152.725 Y108.394 E.50526
G3 X153.707 Y109.533 I-.173 J1.142 E.02226
G1 X153.707 Y137.519 E.38053
G3 X153.634 Y137.921 I-1.154 J-.003 E.00558
G1 X153.62 Y137.95 E.00044
; WIPE_START
M204 S10000
G1 X153.519 Y138.147 E-.08412
G1 X153.388 Y138.316 E-.08113
G1 X153.245 Y138.444 E-.07293
G1 X153.08 Y138.544 E-.07329
G1 X152.911 Y138.615 E-.06968
G1 X152.74 Y138.657 E-.06702
G1 X152.556 Y138.67 E-.07015
G1 X151.92 Y138.67 E-.24169
; WIPE_END
G1 E-.04 F1800
G1 X151.538 Y131.047 Z4.912 F30000
G1 X150.426 Y108.823 Z4.912
G1 Z4.512
G1 E.8 F1800
G1 F9000
M204 S5000
G1 X150.631 Y108.747 E.00298
G3 X151.064 Y108.669 I.543 J1.778 E.006
G1 X151.285 Y108.669 E.003
G3 X150.371 Y108.848 I-.11 J1.856 E.14607
M204 S10000
G1 X149.672 Y108.799 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X149.405 Y109.091 E.00577
G2 X153.103 Y111.732 I1.767 J1.435 E.10858
G1 X153.29 Y111.786 E.00285
G1 X153.29 Y135.267 E.34309
G1 X153.11 Y135.325 E.00276
G2 X149.323 Y137.857 I-1.933 J1.207 E.10667
G1 X149.645 Y138.253 E.00746
G1 X115.572 Y138.253 E.49786
G3 X106.836 Y129.518 I-.002 J-8.733 E.20049
G1 X106.836 Y117.535 E.1751
G3 X115.572 Y108.799 I8.733 J-.002 E.20049
G1 X149.612 Y108.799 E.49738
; WIPE_START
G1 X149.405 Y109.091 E-.13562
G1 X149.248 Y109.31 E-.10268
G1 X149.118 Y109.547 E-.10254
G1 X149.016 Y109.797 E-.10255
G1 X148.945 Y110.057 E-.10264
G1 X148.905 Y110.324 E-.10253
G1 X148.897 Y110.594 E-.10261
G1 X148.899 Y110.617 E-.00884
; WIPE_END
G1 E-.04 F1800
G1 X150.003 Y118.169 Z4.912 F30000
G1 X152.814 Y137.405 Z4.912
G1 Z4.512
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X152.804 Y137.427 E.00033
G3 X151.064 Y134.672 I-1.629 J-.898 E.10496
G1 X151.285 Y134.672 E.003
G3 X152.898 Y137.228 I-.11 J1.857 E.04798
G1 X152.84 Y137.351 E.00185
M204 S10000
G1 X153.285 Y137.398 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.440251
G1 F15000
G1 X153.29 Y137.373 E.00036
; LINE_WIDTH: 0.415205
G1 X153.31 Y137.251 E.00167
; LINE_WIDTH: 0.371721
G1 X153.333 Y137.108 E.00173
; LINE_WIDTH: 0.336637
G1 X153.346 Y136.986 E.00133
; LINE_WIDTH: 0.293889
G1 X153.358 Y136.863 E.00115
G2 X153.371 Y136.601 I-4.391 J-.335 E.00245
; LINE_WIDTH: 0.289323
G2 X153.346 Y136.062 I-4.407 J-.073 E.00496
; LINE_WIDTH: 0.338873
G1 X153.33 Y135.94 E.00134
; LINE_WIDTH: 0.374864
G1 X153.31 Y135.795 E.00176
; LINE_WIDTH: 0.413413
G1 X153.252 Y135.499 E.00403
G1 X153.074 Y134.855 F30000
; LINE_WIDTH: 0.0801937
G1 F15000
G1 X152.964 Y134.76 E.00031
; WIPE_START
G1 X153.074 Y134.855 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X153.261 Y137.503 Z4.912 F30000
G1 Z4.512
G1 E.8 F1800
; LINE_WIDTH: 0.518218
G1 F15000
G3 X153.223 Y137.64 I-.817 J-.155 E.00241
; LINE_WIDTH: 0.558248
G1 X153.177 Y137.75 E.00218
; LINE_WIDTH: 0.581058
G3 X152.908 Y138.093 I-.958 J-.474 E.00835
; LINE_WIDTH: 0.542742
G1 X152.867 Y138.126 E.00094
; LINE_WIDTH: 0.514913
G1 X152.359 Y138.462 E.01022
G1 X152.145 Y138.462 F30000
; LINE_WIDTH: 0.430578
G1 F15000
G2 X153.406 Y137.917 I-9.167 J-22.941 E.01916
; WIPE_START
G1 X152.145 Y138.462 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.003 Y138.363 Z4.912 F30000
G1 Z4.512
G1 E.8 F1800
; LINE_WIDTH: 0.115457
G1 F15000
G1 X150.336 Y138.444 E.00113
G1 X150.203 Y138.462 F30000
; LINE_WIDTH: 0.14993
G1 F15000
G1 X150.099 Y138.373 E.00061
; LINE_WIDTH: 0.120857
G1 X149.992 Y138.28 E.00049
; LINE_WIDTH: 0.0887055
G1 X149.87 Y138.162 E.00041
; WIPE_START
M73 P86 R2
G1 X149.992 Y138.28 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.058 Y130.648 Z4.912 F30000
G1 X150.251 Y108.591 Z4.912
G1 Z4.512
G1 E.8 F1800
; LINE_WIDTH: 0.122286
G1 F15000
G1 X150.098 Y108.708 E.00068
; LINE_WIDTH: 0.0886725
G1 X149.969 Y108.819 E.00041
; WIPE_START
G1 X150.098 Y108.708 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X148.899 Y109.624 Z4.912 F30000
G1 Z4.512
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.421427
G1 F15000
G1 X148.429 Y109.154 E.00907
G1 X147.858 Y109.154 E.00779
G1 X148.617 Y109.913 E.01465
G2 X148.548 Y110.415 I2.741 J.633 E.00692
G1 X147.287 Y109.154 E.02433
G1 X146.716 Y109.154 E.00779
G1 X148.847 Y111.285 E.04112
; WIPE_START
G1 X147.433 Y109.871 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.417 Y112.854 Z4.912 F30000
G1 Z4.512
G1 E.8 F1800
G1 F15000
G1 X152.936 Y115.373 E.04861
G1 X152.936 Y114.803 E.00779
G1 X151.286 Y113.153 E.03183
G2 X151.79 Y113.087 I-.027 J-2.15 E.00696
G1 X152.936 Y114.232 E.0221
G1 X152.936 Y113.661 E.00779
G1 X152.215 Y112.941 E.0139
G2 X152.589 Y112.744 I-.639 J-1.669 E.00578
G1 X153.117 Y113.271 E.01017
G1 X152.857 Y112.397 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.0922187
G1 F15000
G1 X153.025 Y112.269 E.00053
G2 X153.074 Y112.146 I-2.077 J-.898 E.00033
G1 X153.017 Y111.49 F30000
; LINE_WIDTH: 0.380764
G1 F15000
G1 X153.273 Y111.365 E.0035
; LINE_WIDTH: 0.411914
G1 X153.293 Y111.355 E.00029
G1 X153.311 Y111.24 E.00155
; LINE_WIDTH: 0.373588
G1 X153.33 Y111.126 E.0014
; LINE_WIDTH: 0.338791
G1 X153.346 Y110.983 E.00155
; LINE_WIDTH: 0.311124
G1 X153.358 Y110.861 E.00122
; LINE_WIDTH: 0.287421
G2 X153.348 Y110.078 I-4.935 J-.327 E.00714
; LINE_WIDTH: 0.336542
G1 X153.33 Y109.937 E.00153
; LINE_WIDTH: 0.371775
G1 X153.313 Y109.815 E.00148
; LINE_WIDTH: 0.391877
G1 X153.31 Y109.793 E.00028
; LINE_WIDTH: 0.419251
G1 X153.286 Y109.671 E.00168
; LINE_WIDTH: 0.466715
G1 X153.262 Y109.549 E.00188
; LINE_WIDTH: 0.496236
G1 X153.042 Y108.73 E.01373
G1 X153.471 Y109.329 F30000
; LINE_WIDTH: 0.495502
G1 F15000
G1 X152.774 Y108.864 E.01354
G1 X152.24 Y108.591 E.00968
G1 X152.456 Y108.591 F30000
; LINE_WIDTH: 0.556612
G1 F15000
G1 X152.958 Y109.003 E.01183
; LINE_WIDTH: 0.586755
G3 X153.153 Y109.258 I-.705 J.744 E.00619
; LINE_WIDTH: 0.559746
G1 X153.499 Y110.108 E.01682
; WIPE_START
G1 X153.153 Y109.258 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X153.117 Y116.125 Z4.912 F30000
G1 Z4.512
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.421427
G1 F15000
G1 X146.145 Y109.154 E.13452
G1 X145.575 Y109.154 E.00779
G1 X152.936 Y116.515 E.14205
G1 X152.936 Y117.086 E.00779
G1 X145.004 Y109.154 E.15306
G1 X144.433 Y109.154 E.00779
G1 X152.936 Y117.657 E.16408
G1 X152.936 Y118.227 E.00779
G1 X143.862 Y109.154 E.17509
G1 X143.291 Y109.154 E.00779
G1 X152.936 Y118.798 E.18611
G1 X152.936 Y119.369 E.00779
G1 X142.721 Y109.154 E.19712
G1 X142.15 Y109.154 E.00779
G1 X152.936 Y119.94 E.20814
G1 X152.936 Y120.511 E.00779
G1 X141.579 Y109.154 E.21915
G1 X141.008 Y109.154 E.00779
G1 X152.936 Y121.081 E.23017
G1 X152.936 Y121.652 E.00779
G1 X140.437 Y109.154 E.24118
G1 X139.867 Y109.154 E.00779
G1 X152.936 Y122.223 E.2522
G1 X152.936 Y122.794 E.00779
G1 X139.296 Y109.154 E.26321
G1 X138.725 Y109.154 E.00779
G1 X152.936 Y123.365 E.27423
G1 X152.936 Y123.935 E.00779
G1 X138.154 Y109.154 E.28524
G1 X137.583 Y109.154 E.00779
G1 X152.936 Y124.506 E.29626
G1 X152.936 Y125.077 E.00779
G1 X137.013 Y109.154 E.30727
G1 X136.442 Y109.154 E.00779
G1 X152.936 Y125.648 E.31829
G1 X152.936 Y126.219 E.00779
G1 X135.871 Y109.154 E.3293
G1 X135.3 Y109.154 E.00779
G1 X152.936 Y126.789 E.34032
G1 X152.936 Y127.36 E.00779
G1 X134.729 Y109.154 E.35133
G1 X134.159 Y109.154 E.00779
G1 X152.936 Y127.931 E.36235
G1 X152.936 Y128.502 E.00779
G1 X133.588 Y109.154 E.37336
G1 X133.017 Y109.154 E.00779
G1 X152.936 Y129.073 E.38438
G1 X152.936 Y129.643 E.00779
G1 X132.446 Y109.154 E.39539
G1 X131.875 Y109.154 E.00779
G1 X152.936 Y130.214 E.40641
G1 X152.936 Y130.785 E.00779
G1 X131.305 Y109.154 E.41742
G1 X130.734 Y109.154 E.00779
G1 X152.936 Y131.356 E.42844
G1 X152.936 Y131.927 E.00779
G1 X130.163 Y109.154 E.43945
G1 X129.592 Y109.154 E.00779
G1 X152.936 Y132.497 E.45047
G1 X152.936 Y133.068 E.00779
G1 X129.021 Y109.154 E.46148
G1 X128.45 Y109.154 E.00779
G1 X152.936 Y133.639 E.4725
G1 X152.936 Y134.21 E.00779
G1 X127.88 Y109.154 E.48352
G1 X127.309 Y109.154 E.00779
G1 X152.313 Y134.158 E.48251
G2 X151.504 Y133.92 I-.991 J1.88 E.01157
G1 X126.738 Y109.154 E.47793
G1 X126.167 Y109.154 E.00779
G1 X150.924 Y133.911 E.47775
G2 X150.443 Y134.001 I.136 J2.063 E.00669
G1 X125.596 Y109.154 E.47948
G1 X125.026 Y109.154 E.00779
G1 X150.032 Y134.16 E.48256
G2 X149.672 Y134.371 I.705 J1.616 E.00571
G1 X124.455 Y109.154 E.48663
G1 X123.884 Y109.154 E.00779
G1 X149.356 Y134.626 E.49154
G2 X149.087 Y134.928 I2.817 J2.77 E.00552
G1 X123.313 Y109.154 E.49737
G1 X122.742 Y109.154 E.00779
G1 X148.864 Y135.275 E.50407
G2 X148.686 Y135.669 I1.562 J.94 E.0059
G1 X122.172 Y109.154 E.51167
G1 X121.601 Y109.154 E.00779
G1 X148.576 Y136.129 E.52056
G2 X148.548 Y136.672 I2.793 J.417 E.00743
G1 X121.03 Y109.154 E.53103
G1 X120.459 Y109.154 E.00779
G1 X148.688 Y137.383 E.54475
G2 X148.93 Y137.899 I2.513 J-.866 E.00778
G1 X148.633 Y137.899 E.00406
G1 X119.888 Y109.154 E.5547
G1 X119.318 Y109.154 E.00779
G1 X148.062 Y137.899 E.5547
G1 X147.491 Y137.899 E.00779
G1 X118.747 Y109.154 E.5547
G1 X118.176 Y109.154 E.00779
G1 X146.92 Y137.899 E.5547
G1 X146.35 Y137.899 E.00779
G1 X117.605 Y109.154 E.5547
G1 X117.034 Y109.154 E.00779
G1 X145.779 Y137.899 E.5547
G1 X145.208 Y137.899 E.00779
G1 X116.464 Y109.154 E.5547
G1 X115.893 Y109.154 E.00779
G1 X144.637 Y137.899 E.5547
G1 X144.066 Y137.899 E.00779
G1 X115.334 Y109.166 E.55447
G1 X114.789 Y109.192 E.00744
G1 X143.496 Y137.899 E.55397
G1 X142.925 Y137.899 E.00779
G1 X114.283 Y109.257 E.55271
G1 X113.805 Y109.349 E.00665
G1 X142.354 Y137.899 E.55093
G1 X141.783 Y137.899 E.00779
G1 X113.342 Y109.457 E.54885
G2 X112.91 Y109.596 I.755 J3.085 E.00619
G1 X141.212 Y137.899 E.54617
G1 X140.642 Y137.899 E.00779
G1 X112.486 Y109.743 E.54334
G2 X112.091 Y109.919 I.728 J2.156 E.0059
G1 X140.071 Y137.899 E.53994
G1 X139.5 Y137.899 E.00779
G1 X111.701 Y110.099 E.53646
G2 X111.335 Y110.304 I1.245 J2.661 E.00573
G1 X138.929 Y137.899 E.53251
G1 X138.358 Y137.899 E.00779
G1 X110.987 Y110.527 E.5282
G2 X110.643 Y110.754 I1.415 J2.513 E.00563
G1 X137.788 Y137.899 E.52382
G1 X137.217 Y137.899 E.00779
G1 X110.322 Y111.003 E.51901
G1 X110.016 Y111.268 E.00552
G1 X136.646 Y137.899 E.5139
G1 X136.075 Y137.899 E.00779
G1 X109.717 Y111.54 E.50865
G1 X109.438 Y111.832 E.00551
G1 X135.504 Y137.899 E.50301
G1 X134.934 Y137.899 E.00779
G1 X109.168 Y112.132 E.49722
G1 X108.917 Y112.453 E.00555
G1 X134.363 Y137.899 E.49103
G1 X133.792 Y137.899 E.00779
G1 X108.673 Y112.779 E.48474
G1 X108.45 Y113.127 E.00564
G1 X133.221 Y137.899 E.47803
G1 X132.65 Y137.899 E.00779
G1 X108.235 Y113.483 E.47116
G2 X108.044 Y113.863 I2.561 J1.53 E.0058
G1 X132.08 Y137.899 E.46384
G1 X131.509 Y137.899 E.00779
G1 X107.865 Y114.254 E.45627
G2 X107.705 Y114.665 I2.073 J1.043 E.00603
G1 X130.938 Y137.899 E.44834
G1 X130.367 Y137.899 E.00779
G1 X107.558 Y115.089 E.44016
G2 X107.432 Y115.534 I3.046 J1.101 E.00632
G1 X129.796 Y137.899 E.43157
G1 X129.226 Y137.899 E.00779
G1 X107.339 Y116.012 E.42235
G2 X107.261 Y116.505 I2.544 J.657 E.00681
G1 X128.655 Y137.899 E.41285
G1 X128.084 Y137.899 E.00779
G1 X107.211 Y117.026 E.4028
G2 X107.191 Y117.577 I9.661 J.624 E.00752
G1 X127.513 Y137.899 E.39217
G1 X126.942 Y137.899 E.00779
G1 X107.192 Y118.148 E.38114
G1 X107.192 Y118.719 E.0078
G1 X126.372 Y137.899 E.37012
G1 X125.801 Y137.899 E.00779
G1 X107.192 Y119.29 E.35909
G1 X107.193 Y119.862 E.0078
G1 X125.23 Y137.899 E.34807
M73 P87 R2
G1 X124.659 Y137.899 E.00779
G1 X107.193 Y120.433 E.33705
G1 X107.194 Y121.004 E.0078
G1 X124.088 Y137.899 E.32602
G1 X123.517 Y137.899 E.00779
G1 X107.194 Y121.575 E.315
G1 X107.195 Y122.147 E.0078
G1 X122.947 Y137.899 E.30397
G1 X122.376 Y137.899 E.00779
G1 X107.195 Y122.718 E.29295
G1 X107.196 Y123.289 E.0078
G1 X121.805 Y137.899 E.28192
G1 X121.234 Y137.899 E.00779
G1 X107.196 Y123.86 E.2709
G1 X107.197 Y124.432 E.0078
G1 X120.663 Y137.899 E.25988
G1 X120.093 Y137.899 E.00779
G1 X107.197 Y125.003 E.24885
G1 X107.198 Y125.574 E.0078
G1 X119.522 Y137.899 E.23783
G1 X118.951 Y137.899 E.00779
G1 X107.198 Y126.146 E.2268
G1 X107.198 Y126.717 E.0078
G1 X118.38 Y137.899 E.21578
G1 X117.809 Y137.899 E.00779
G1 X107.199 Y127.288 E.20476
G1 X107.199 Y127.859 E.0078
G1 X117.239 Y137.899 E.19373
G1 X116.668 Y137.899 E.00779
G1 X107.2 Y128.431 E.18271
G1 X107.2 Y129.002 E.0078
G1 X116.097 Y137.899 E.17168
G3 X115.524 Y137.896 I-.258 J-6.049 E.00783
G1 X107.201 Y129.573 E.16061
G2 X107.224 Y130.168 I3.154 J.172 E.00813
G1 X114.924 Y137.867 E.14859
G3 X114.275 Y137.789 I.084 J-3.429 E.00893
G1 X107.291 Y130.805 E.13477
G2 X107.444 Y131.529 I5.131 J-.708 E.01011
G1 X113.572 Y137.657 E.11825
G1 X112.757 Y137.412 E.01162
G1 X107.69 Y132.346 E.09777
G2 X108.13 Y133.356 I5.695 J-1.876 E.01505
G1 X111.751 Y136.978 E.06989
G3 X109.543 Y135.341 I3.71 J-7.31 E.03768
G1 X108.427 Y134.225 E.02154
; CHANGE_LAYER
; Z_HEIGHT: 4.60273
; LAYER_HEIGHT: 0.090694
; WIPE_START
G1 F15000
G1 X109.543 Y135.341 E-.59979
G1 X109.849 Y135.632 E-.16021
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 28/33
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change
G17
G3 Z4.912 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X153.605 Y137.476
G1 Z4.603
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X153.605 Y137.526 E.00073
G3 X152.556 Y138.567 I-1.051 J-.01 E.02427
G1 X115.566 Y138.567 E.54747
G3 X106.523 Y129.523 I.022 J-9.065 E.21011
G1 X106.523 Y117.529 E.17752
G3 X115.566 Y108.486 I9.047 J.003 E.21023
G1 X152.689 Y108.495 E.54944
G3 X153.605 Y109.521 I-.126 J1.034 E.02225
G1 X153.605 Y137.416 E.41286
M204 S10000
G1 X153.19 Y137.476 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X153.19 Y137.502 E.00042
G3 X153.028 Y137.929 I-.652 J-.003 E.00743
G1 X152.86 Y138.076 E.00355
G1 F17636.606
G1 X152.766 Y138.118 E.00163
G1 F15152.697
G1 X152.541 Y138.151 E.00362
G1 F10299.573
G1 X152.025 Y138.151 E.00821
G1 F2760
G1 X150.324 Y138.151 E.02706
G1 F8187.179
G1 X149.924 Y138.151 E.00636
G1 F16494.359
G1 X149.524 Y138.151 E.00636
G1 F18000
G1 X149.124 Y138.151 E.00636
G1 X115.571 Y138.151 E.5338
G3 X106.938 Y129.518 I.016 J-8.649 E.21564
G1 X106.938 Y117.535 E.19065
G3 X115.571 Y108.901 I8.631 J-.002 E.21576
G1 X149.134 Y108.901 E.53395
G1 X149.534 Y108.901 E.00636
G1 F16494.359
G1 X149.934 Y108.901 E.00636
G1 F8187.179
G1 X150.334 Y108.901 E.00636
G1 F2760
G1 X152.015 Y108.901 E.02675
G1 F8187.179
G1 X152.415 Y108.906 E.00636
G1 F12969.356
G1 X152.662 Y108.909 E.00392
G1 F17874.135
G1 X152.86 Y108.976 E.00332
G1 F18000
G1 X153.038 Y109.126 E.00371
G3 X153.19 Y109.533 I-.49 J.414 E.00704
G1 X153.19 Y137.416 E.4436
; WIPE_START
G1 X153.19 Y137.502 E-.03274
G1 X153.171 Y137.671 E-.06446
G1 X153.119 Y137.811 E-.05687
G1 X153.028 Y137.929 E-.0568
G1 X152.86 Y138.076 E-.08488
G1 X152.766 Y138.118 E-.03888
G1 X152.541 Y138.151 E-.08656
G1 X152.025 Y138.151 E-.19608
G1 X151.649 Y138.151 E-.14273
; WIPE_END
G1 E-.04 F1800
G1 X152.518 Y133.689 Z5.003 F30000
G1 Z4.603
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.421453
G1 F15000
G1 X152.837 Y133.37 E.0067
G1 X152.837 Y132.802 E.00844
G1 X152.251 Y133.387 E.0123
G1 X151.803 Y133.267 E.00689
G1 X152.837 Y132.233 E.0217
G1 X152.837 Y131.665 E.00844
G1 X151.292 Y133.209 E.03244
G1 X150.979 Y133.212 E.00465
G1 X150.69 Y133.243 E.00432
G1 X152.837 Y131.096 E.0451
G1 X152.837 Y130.528 E.00844
G1 X149.906 Y133.459 E.06157
G1 X149.413 Y133.713 E.00823
G1 X149.146 Y133.898 E.00483
G1 X148.848 Y134.156 E.00585
G1 X148.595 Y134.434 E.00559
G1 X148.385 Y134.724 E.0053
G1 X148.203 Y135.043 E.00547
G1 X148.108 Y135.256 E.00346
G1 X145.567 Y137.798 E.05339
G1 X146.135 Y137.798 E.00844
G1 X147.891 Y136.042 E.03687
G1 X147.863 Y136.264 E.00331
G1 X147.854 Y136.647 E.0057
G1 X146.704 Y137.798 E.02417
G1 X147.272 Y137.798 E.00844
G1 X147.914 Y137.156 E.01348
G1 X148.034 Y137.605 E.0069
G1 X147.66 Y137.978 E.00785
G1 X148.342 Y137.79 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.436643
G1 F3000
G1 X152.606 Y137.79 E.06573
G2 X152.837 Y137.482 I-.052 J-.279 E.0065
G1 X152.837 Y137.373 E.00169
G1 X148.378 Y137.373 E.06872
G1 X148.285 Y136.963 E.00647
G1 X152.837 Y136.955 E.07016
G1 X152.837 Y136.538 E.00643
G1 X148.254 Y136.538 E.07064
G1 X148.284 Y136.121 E.00645
G1 X152.837 Y136.121 E.07018
G1 X152.837 Y135.704 E.00643
G1 X148.374 Y135.704 E.06879
G1 X148.53 Y135.287 E.00687
G1 X152.837 Y135.287 E.06639
G1 X152.837 Y134.869 E.00643
G1 X148.772 Y134.869 E.06265
G1 X148.912 Y134.68 E.00362
G1 X149.119 Y134.452 E.00475
G1 X152.837 Y134.452 E.05731
G1 X152.837 Y134.129 E.00499
G1 X152.697 Y134.035 E.00259
G1 X149.652 Y134.035 E.04693
G1 X150.064 Y133.827 E.00711
G1 X150.335 Y133.73 E.00444
G1 X150.68 Y133.649 E.00547
G1 X150.932 Y133.618 E.0039
G1 X152.239 Y133.618 E.02016
G1 X144.818 Y137.978 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.421453
G1 F15000
G1 X152.837 Y129.959 E.16845
G1 X152.837 Y129.391 E.00844
G1 X144.43 Y137.798 E.1766
G1 X143.861 Y137.798 E.00844
G1 X152.837 Y128.822 E.18854
G1 X152.837 Y128.254 E.00844
G1 X143.293 Y137.798 E.20049
G1 X142.724 Y137.798 E.00844
G1 X152.837 Y127.685 E.21243
G1 X152.837 Y127.117 E.00844
G1 X142.156 Y137.798 E.22437
G1 X141.587 Y137.798 E.00844
G1 X152.837 Y126.548 E.23632
G1 X152.837 Y125.98 E.00844
G1 X141.019 Y137.798 E.24826
G1 X140.45 Y137.798 E.00844
G1 X152.837 Y125.411 E.2602
G1 X152.837 Y124.843 E.00844
G1 X139.882 Y137.798 E.27214
G1 X139.313 Y137.798 E.00844
G1 X152.837 Y124.274 E.28409
G1 X152.837 Y123.706 E.00844
G1 X138.745 Y137.798 E.29603
G1 X138.176 Y137.798 E.00844
G1 X152.837 Y123.137 E.30797
G1 X152.837 Y122.569 E.00844
G1 X137.608 Y137.798 E.31991
G1 X137.039 Y137.798 E.00844
G1 X152.837 Y122 E.33186
G1 X152.837 Y121.432 E.00844
G1 X136.471 Y137.798 E.3438
G1 X135.902 Y137.798 E.00845
G1 X152.837 Y120.863 E.35574
G1 X152.837 Y120.295 E.00844
G1 X135.334 Y137.798 E.36769
G1 X134.765 Y137.798 E.00844
G1 X152.837 Y119.726 E.37963
G1 X152.837 Y119.158 E.00844
G1 X134.197 Y137.798 E.39157
G1 X133.628 Y137.798 E.00844
G1 X152.837 Y118.589 E.40351
G1 X152.837 Y118.021 E.00844
G1 X133.06 Y137.798 E.41546
G1 X132.491 Y137.798 E.00844
G1 X152.837 Y117.452 E.4274
G1 X152.837 Y116.884 E.00844
G1 X131.923 Y137.798 E.43934
G1 X131.354 Y137.798 E.00844
G1 X152.837 Y116.315 E.45129
G1 X152.837 Y115.747 E.00844
G1 X130.786 Y137.798 E.46323
G1 X130.217 Y137.798 E.00844
G1 X152.837 Y115.178 E.47517
G1 X152.837 Y114.61 E.00844
G1 X129.649 Y137.798 E.48711
G1 X129.08 Y137.798 E.00844
G1 X152.837 Y114.041 E.49906
G1 X152.837 Y113.473 E.00844
G1 X128.512 Y137.798 E.511
G1 X127.943 Y137.798 E.00844
G1 X151.996 Y113.745 E.50528
G1 X151.607 Y113.82 E.00588
G1 X151.33 Y113.843 E.00413
G1 X127.375 Y137.798 E.50324
G1 X126.806 Y137.798 E.00845
G1 X150.779 Y113.825 E.5036
G1 X150.304 Y113.731 E.00719
G1 X126.238 Y137.798 E.50557
G1 X125.669 Y137.798 E.00844
G1 X149.882 Y113.585 E.50866
G1 X149.504 Y113.395 E.00629
G1 X125.101 Y137.798 E.51264
G1 X124.532 Y137.798 E.00844
G1 X149.163 Y113.167 E.51743
G1 X148.858 Y112.904 E.00599
M73 P88 R2
G1 X123.964 Y137.798 E.52296
G1 X123.395 Y137.798 E.00844
G1 X148.587 Y112.606 E.52921
G1 X148.351 Y112.273 E.00606
G1 X122.827 Y137.798 E.53621
G1 X122.258 Y137.798 E.00844
G1 X148.153 Y111.903 E.54399
G1 X147.996 Y111.491 E.00654
G1 X121.69 Y137.798 E.55264
G1 X121.121 Y137.798 E.00844
G1 X147.89 Y111.029 E.56235
G1 X147.854 Y110.496 E.00793
G1 X120.552 Y137.798 E.57354
G1 X119.984 Y137.798 E.00844
G1 X147.919 Y109.863 E.58684
G1 X148.015 Y109.498 E.0056
G1 X148.105 Y109.263 E.00374
G1 X147.951 Y109.263 E.00229
G1 X119.415 Y137.798 E.59945
G1 X118.847 Y137.798 E.00844
G1 X147.382 Y109.263 E.59945
G1 X146.814 Y109.263 E.00845
G1 X118.278 Y137.798 E.59945
G1 X117.71 Y137.798 E.00845
G1 X146.245 Y109.263 E.59945
G1 X145.677 Y109.263 E.00845
G1 X117.141 Y137.798 E.59945
G1 X116.573 Y137.798 E.00844
G1 X145.108 Y109.263 E.59945
G1 X144.54 Y109.263 E.00845
G1 X116.004 Y137.798 E.59945
G3 X115.442 Y137.792 I-.212 J-5.926 E.00835
G1 X143.971 Y109.263 E.59931
G1 X143.403 Y109.263 E.00845
G1 X114.9 Y137.766 E.59877
G3 X114.392 Y137.705 I.065 J-2.681 E.0076
G1 X142.834 Y109.263 E.59748
G1 X142.266 Y109.263 E.00845
G1 X113.901 Y137.627 E.59586
G3 X113.445 Y137.515 I.558 J-3.248 E.00698
G1 X141.697 Y109.263 E.5935
G1 X141.128 Y109.263 E.00845
G1 X113.006 Y137.386 E.59078
G3 X112.588 Y137.235 I.584 J-2.26 E.0066
G1 X140.56 Y109.263 E.5876
G1 X139.991 Y109.263 E.00845
G1 X112.182 Y137.072 E.58419
G3 X111.803 Y136.883 I.799 J-2.077 E.00631
G1 X139.423 Y109.263 E.58022
G1 X138.854 Y109.263 E.00845
G1 X111.428 Y136.69 E.57615
G3 X111.076 Y136.473 I11.506 J-19.134 E.00614
G1 X138.286 Y109.263 E.57161
G1 X137.717 Y109.263 E.00845
G1 X110.744 Y136.237 E.56664
G3 X110.414 Y135.998 I1.504 J-2.427 E.00605
G1 X137.149 Y109.263 E.56163
G1 X136.58 Y109.263 E.00845
G1 X110.106 Y135.738 E.55616
G1 X109.815 Y135.46 E.00597
G1 X136.012 Y109.263 E.55033
G1 X135.443 Y109.263 E.00845
G1 X109.529 Y135.178 E.54439
G1 X109.265 Y134.873 E.00599
G1 X134.875 Y109.263 E.538
G1 X134.306 Y109.263 E.00845
G1 X109.005 Y134.564 E.5315
G3 X108.768 Y134.233 I2.195 J-1.828 E.00606
G1 X133.738 Y109.263 E.52455
G1 X133.169 Y109.264 E.00845
G1 X108.545 Y133.887 E.51728
G3 X108.33 Y133.534 I2.361 J-1.679 E.00615
G1 X132.6 Y109.264 E.50986
G1 X132.032 Y109.264 E.00845
G1 X108.138 Y133.158 E.50195
G1 X107.957 Y132.77 E.00636
G1 X131.463 Y109.264 E.4938
G1 X130.895 Y109.264 E.00845
G1 X107.797 Y132.361 E.48521
G3 X107.653 Y131.937 I3.303 J-1.365 E.00666
G1 X130.326 Y109.264 E.47631
G1 X129.758 Y109.264 E.00845
G1 X107.537 Y131.485 E.4668
G3 X107.431 Y131.022 I2.374 J-.784 E.00707
G1 X129.189 Y109.264 E.45707
G1 X128.621 Y109.264 E.00845
G1 X107.36 Y130.525 E.44663
G3 X107.308 Y130.009 I3.579 J-.625 E.00771
G1 X128.052 Y109.264 E.43579
G1 X127.484 Y109.264 E.00845
G1 X107.301 Y129.446 E.42398
G1 X107.301 Y128.878 E.00844
G1 X126.915 Y109.264 E.41205
G1 X126.347 Y109.264 E.00845
G1 X107.3 Y128.31 E.40011
G1 X107.3 Y127.742 E.00844
G1 X125.778 Y109.264 E.38818
G1 X125.21 Y109.264 E.00845
G1 X107.299 Y127.174 E.37625
G1 X107.299 Y126.606 E.00844
G1 X124.641 Y109.264 E.36431
G1 X124.073 Y109.264 E.00845
G1 X107.298 Y126.038 E.35238
G1 X107.298 Y125.47 E.00844
G1 X123.504 Y109.264 E.34045
G1 X122.935 Y109.264 E.00845
G1 X107.297 Y124.902 E.32851
G1 X107.297 Y124.334 E.00844
G1 X122.367 Y109.264 E.31658
G1 X121.798 Y109.264 E.00845
G1 X107.296 Y123.766 E.30464
G1 X107.296 Y123.198 E.00844
G1 X121.23 Y109.264 E.29271
G1 X120.661 Y109.264 E.00845
G1 X107.296 Y122.63 E.28078
G1 X107.295 Y122.062 E.00844
G1 X120.093 Y109.264 E.26884
G1 X119.524 Y109.264 E.00845
G1 X107.295 Y121.494 E.25691
G1 X107.294 Y120.926 E.00844
G1 X118.956 Y109.264 E.24498
G1 X118.387 Y109.264 E.00845
G1 X107.294 Y120.358 E.23304
G1 X107.293 Y119.79 E.00844
G1 X117.819 Y109.264 E.22111
G1 X117.25 Y109.264 E.00845
G1 X107.293 Y119.222 E.20917
G1 X107.292 Y118.654 E.00844
G1 X116.682 Y109.264 E.19724
G1 X116.113 Y109.264 E.00845
G1 X107.292 Y118.086 E.18531
G3 X107.292 Y117.517 I11.499 J-.282 E.00845
G1 X115.545 Y109.265 E.17336
G2 X114.956 Y109.285 I-.187 J3.097 E.00877
G1 X107.322 Y116.919 E.16036
M73 P89 R2
G1 X107.389 Y116.283 E.00949
G1 X114.32 Y109.352 E.1456
G1 X113.616 Y109.488 E.01065
G1 X107.525 Y115.579 E.12795
G3 X107.78 Y114.755 I7.874 J1.986 E.01281
G1 X112.803 Y109.732 E.10552
G2 X111.79 Y110.176 I1.82 J5.525 E.01645
G1 X108.196 Y113.771 E.07551
G3 X109.807 Y111.591 I7.201 J3.637 E.04046
G1 X110.928 Y110.47 E.02353
G1 X150.11 Y113.44 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.436393
G1 F3000
G1 X151.35 Y113.44 E.01911
G1 X151.574 Y113.42 E.00346
G1 X151.868 Y113.365 E.0046
G1 X152.186 Y113.268 E.00513
G1 X152.485 Y113.138 E.00502
G1 X152.687 Y113.023 E.00358
G1 X149.662 Y113.023 E.04661
G1 X149.322 Y112.785 E.0064
G1 X149.126 Y112.606 E.00408
G1 X152.837 Y112.606 E.05716
G1 X152.837 Y112.189 E.00642
G1 X148.773 Y112.189 E.06261
G1 X148.535 Y111.772 E.0074
G1 X152.837 Y111.772 E.06627
G1 X152.837 Y111.355 E.00642
G1 X148.374 Y111.356 E.06876
G1 X148.282 Y110.939 E.00658
G1 X152.837 Y110.938 E.07017
G1 X152.837 Y110.521 E.00642
G1 X148.254 Y110.522 E.0706
G1 X148.286 Y110.105 E.00644
G1 X152.837 Y110.104 E.07011
G1 X152.837 Y109.688 E.00642
G1 X148.378 Y109.688 E.0687
G1 X148.536 Y109.271 E.00687
G1 X152.931 Y109.271 E.06771
; CHANGE_LAYER
; Z_HEIGHT: 4.68802
; LAYER_HEIGHT: 0.0852962
; WIPE_START
G1 F3000
G1 X150.931 Y109.271 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 29/33
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change
G17
G3 Z5.003 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X153.487 Y137.478
G1 Z4.688
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X153.487 Y137.521 E.00061
G3 X152.555 Y138.45 I-.929 J0 E.02041
G1 X115.566 Y138.45 E.51635
G3 X106.64 Y129.523 I.003 J-8.93 E.19572
G1 X106.64 Y117.529 E.16743
G3 X115.566 Y108.603 I8.93 J.003 E.19572
G1 X152.614 Y108.606 E.51718
G3 X153.487 Y109.532 I-.048 J.92 E.01961
G1 X153.487 Y137.418 E.38929
M204 S10000
G1 X153.07 Y137.478 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X153.07 Y137.511 E.0005
G3 X152.537 Y138.033 I-.535 J-.013 E.01238
G1 X115.571 Y138.033 E.55458
G3 X107.056 Y129.518 I-.002 J-8.513 E.20068
G1 X107.056 Y117.535 E.17978
G3 X115.571 Y109.02 I8.513 J-.002 E.20068
G1 X152.582 Y109.022 E.55525
G3 X153.07 Y109.542 I-.046 J.532 E.01172
G1 X153.07 Y137.418 E.41821
; WIPE_START
G1 X153.07 Y137.511 E-.03555
G1 X153.038 Y137.699 E-.07225
G1 X152.977 Y137.815 E-.05007
G1 X152.898 Y137.903 E-.04487
G1 X152.739 Y137.999 E-.07071
G1 X152.537 Y138.033 E-.07768
G1 X151.461 Y138.033 E-.40886
; WIPE_END
G1 E-.04 F1800
G1 X151.847 Y130.41 Z5.088 F30000
G1 X152.897 Y109.653 Z5.088
G1 Z4.688
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.423295
G1 F15000
G1 X152.669 Y109.425 E.00453
G2 X152.546 Y109.376 I-.131 J.149 E.0019
G1 X152.047 Y109.376 E.00702
G1 X152.716 Y110.045 E.01331
G1 X152.716 Y110.617 E.00806
G1 X151.474 Y109.376 E.02471
G1 X150.902 Y109.376 E.00806
G1 X152.716 Y111.19 E.03611
G1 X152.716 Y111.763 E.00806
G1 X150.329 Y109.376 E.04751
G1 X149.757 Y109.376 E.00806
G1 X152.716 Y112.336 E.0589
G1 X152.716 Y112.908 E.00806
G1 X149.184 Y109.376 E.0703
G1 X148.611 Y109.377 E.00806
G1 X152.716 Y113.481 E.0817
G1 X152.716 Y114.054 E.00806
G1 X148.039 Y109.377 E.0931
G1 X147.466 Y109.377 E.00806
G1 X152.716 Y114.627 E.10449
G1 X152.716 Y115.199 E.00806
G1 X146.893 Y109.377 E.11589
G1 X146.321 Y109.377 E.00806
G1 X152.716 Y115.772 E.12729
G1 X152.716 Y116.345 E.00806
G1 X145.748 Y109.377 E.13869
G1 X145.176 Y109.377 E.00806
G1 X152.716 Y116.918 E.15008
G1 X152.716 Y117.49 E.00806
G1 X144.603 Y109.377 E.16148
G1 X144.03 Y109.378 E.00806
G1 X152.716 Y118.063 E.17288
G1 X152.716 Y118.636 E.00806
G1 X143.458 Y109.378 E.18428
G1 X142.885 Y109.378 E.00806
G1 X152.716 Y119.209 E.19568
G1 X152.716 Y119.781 E.00806
G1 X142.312 Y109.378 E.20707
G1 X141.74 Y109.378 E.00806
G1 X152.716 Y120.354 E.21847
G1 X152.716 Y120.927 E.00806
G1 X141.167 Y109.378 E.22987
G1 X140.595 Y109.378 E.00806
G1 X152.716 Y121.5 E.24127
G1 X152.716 Y122.072 E.00806
G1 X140.022 Y109.378 E.25266
G1 X139.449 Y109.379 E.00806
G1 X152.716 Y122.645 E.26406
G1 X152.716 Y123.218 E.00806
G1 X138.877 Y109.379 E.27546
G1 X138.304 Y109.379 E.00806
G1 X152.716 Y123.791 E.28686
G1 X152.716 Y124.363 E.00806
G1 X137.731 Y109.379 E.29825
G1 X137.159 Y109.379 E.00806
G1 X152.716 Y124.936 E.30965
G1 X152.716 Y125.509 E.00806
G1 X136.586 Y109.379 E.32105
G1 X136.014 Y109.379 E.00806
G1 X152.716 Y126.081 E.33245
G1 X152.716 Y126.654 E.00806
G1 X135.441 Y109.379 E.34384
M73 P89 R1
G1 X134.868 Y109.379 E.00806
G1 X152.716 Y127.227 E.35524
G1 X152.716 Y127.8 E.00806
G1 X134.296 Y109.38 E.36664
G1 X133.723 Y109.38 E.00806
G1 X152.716 Y128.372 E.37804
G1 X152.716 Y128.945 E.00806
G1 X133.151 Y109.38 E.38944
G1 X132.578 Y109.38 E.00806
G1 X152.716 Y129.518 E.40083
G1 X152.716 Y130.091 E.00806
G1 X132.005 Y109.38 E.41223
G1 X131.433 Y109.38 E.00806
G1 X152.716 Y130.663 E.42363
G1 X152.716 Y131.236 E.00806
G1 X130.86 Y109.38 E.43503
G1 X130.287 Y109.38 E.00806
G1 X152.716 Y131.809 E.44642
G1 X152.716 Y132.382 E.00806
G1 X129.715 Y109.381 E.45782
G1 X129.142 Y109.381 E.00806
G1 X152.716 Y132.954 E.46922
G1 X152.716 Y133.527 E.00806
G1 X128.57 Y109.381 E.48062
G1 X127.997 Y109.381 E.00806
G1 X152.716 Y134.1 E.49201
G1 X152.716 Y134.673 E.00806
G1 X127.424 Y109.381 E.50341
G1 X126.852 Y109.381 E.00806
G1 X152.716 Y135.245 E.51481
G1 X152.716 Y135.818 E.00806
G1 X126.279 Y109.381 E.52621
G1 X125.706 Y109.381 E.00806
G1 X152.716 Y136.391 E.5376
G1 X152.716 Y136.964 E.00806
G1 X125.134 Y109.381 E.549
G1 X124.561 Y109.382 E.00806
G1 X152.708 Y137.528 E.56024
G3 X152.523 Y137.679 I-.168 J-.018 E.00373
G1 X152.286 Y137.679 E.00333
G1 X123.989 Y109.382 E.56324
G1 X123.416 Y109.382 E.00806
G1 X151.713 Y137.679 E.56323
G1 X151.14 Y137.679 E.00806
G1 X122.843 Y109.382 E.56323
G1 X122.271 Y109.382 E.00806
G1 X150.568 Y137.679 E.56323
G1 X149.995 Y137.679 E.00806
G1 X121.698 Y109.382 E.56323
G1 X121.125 Y109.382 E.00806
G1 X149.422 Y137.679 E.56322
G1 X148.849 Y137.679 E.00806
G1 X120.553 Y109.382 E.56322
G1 X119.98 Y109.383 E.00806
G1 X148.277 Y137.679 E.56322
G1 X147.704 Y137.679 E.00806
G1 X119.408 Y109.383 E.56322
G1 X118.835 Y109.383 E.00806
G1 X147.131 Y137.679 E.56322
G1 X146.558 Y137.679 E.00806
G1 X118.262 Y109.383 E.56321
G1 X117.69 Y109.383 E.00806
G1 X145.986 Y137.679 E.56321
G1 X145.413 Y137.679 E.00806
G1 X117.117 Y109.383 E.56321
G1 X116.544 Y109.383 E.00806
G1 X144.84 Y137.679 E.56321
G1 X144.267 Y137.679 E.00806
G1 X115.972 Y109.383 E.5632
G1 X115.399 Y109.384 E.00806
G1 X143.695 Y137.679 E.5632
G1 X143.122 Y137.679 E.00806
G1 X114.849 Y109.407 E.56274
G2 X114.345 Y109.475 I.226 J3.56 E.00717
G1 X142.549 Y137.679 E.56138
G1 X141.976 Y137.679 E.00806
G1 X113.858 Y109.561 E.55967
G1 X113.398 Y109.673 E.00668
G1 X141.404 Y137.679 E.55744
G1 X140.831 Y137.679 E.00806
M73 P90 R1
G1 X112.956 Y109.804 E.55484
G2 X112.543 Y109.964 I.918 J2.965 E.00623
G1 X140.258 Y137.679 E.55164
G1 X139.685 Y137.679 E.00806
G1 X112.138 Y110.131 E.54832
G1 X111.76 Y110.326 E.00598
G1 X139.113 Y137.679 E.54444
G1 X138.54 Y137.679 E.00806
G1 X111.388 Y110.527 E.54045
G2 X111.039 Y110.751 I1.46 J2.653 E.00584
G1 X137.967 Y137.679 E.53598
G1 X137.394 Y137.679 E.00806
G1 X110.704 Y110.988 E.53126
G2 X110.381 Y111.238 I1.737 J2.575 E.00575
G1 X136.822 Y137.679 E.52628
G1 X136.249 Y137.679 E.00806
G1 X110.073 Y111.503 E.52101
G2 X109.784 Y111.787 I1.843 J2.161 E.00571
G1 X135.676 Y137.679 E.51536
G1 X135.104 Y137.679 E.00806
G1 X109.505 Y112.08 E.50952
G2 X109.238 Y112.386 I2.007 J2.019 E.00572
G1 X134.531 Y137.679 E.50343
G1 X133.958 Y137.679 E.00806
G1 X108.993 Y112.714 E.4969
G1 X108.755 Y113.049 E.00578
G1 X133.385 Y137.679 E.49024
G1 X132.813 Y137.679 E.00806
G1 X108.534 Y113.4 E.48325
G2 X108.336 Y113.775 I2.521 J1.569 E.00597
G1 X132.24 Y137.679 E.47579
G1 X131.667 Y137.679 E.00806
G1 X108.142 Y114.154 E.46825
G1 X107.978 Y114.563 E.0062
G1 X131.094 Y137.679 E.4601
G1 X130.522 Y137.679 E.00806
G1 X107.824 Y114.981 E.45178
G1 X107.694 Y115.424 E.00649
G1 X129.949 Y137.679 E.44297
G1 X129.376 Y137.679 E.00806
G1 X107.586 Y115.889 E.43371
G2 X107.494 Y116.37 I2.523 J.734 E.0069
G1 X128.803 Y137.679 E.42415
G1 X128.231 Y137.679 E.00806
G1 X107.444 Y116.892 E.41374
G2 X107.413 Y117.434 I3.772 J.487 E.00765
G1 X127.658 Y137.679 E.40296
G1 X127.085 Y137.679 E.00806
G1 X107.411 Y118.005 E.3916
G1 X107.411 Y118.578 E.00807
G1 X126.512 Y137.679 E.38019
G1 X125.94 Y137.679 E.00806
G1 X107.412 Y119.151 E.36878
G1 X107.412 Y119.724 E.00807
G1 X125.367 Y137.679 E.35737
G1 X124.794 Y137.679 E.00806
G1 X107.413 Y120.298 E.34596
G1 X107.413 Y120.871 E.00807
G1 X124.221 Y137.679 E.33455
G1 X123.649 Y137.679 E.00806
G1 X107.414 Y121.444 E.32314
G1 X107.414 Y122.017 E.00807
G1 X123.076 Y137.679 E.31174
G1 X122.503 Y137.679 E.00806
G1 X107.415 Y122.59 E.30033
G1 X107.415 Y123.164 E.00807
G1 X121.93 Y137.679 E.28892
G1 X121.358 Y137.679 E.00806
G1 X107.416 Y123.737 E.27751
G1 X107.416 Y124.31 E.00807
G1 X120.785 Y137.679 E.2661
G1 X120.212 Y137.679 E.00806
G1 X107.416 Y124.883 E.25469
G1 X107.417 Y125.456 E.00807
G1 X119.639 Y137.679 E.24328
G1 X119.067 Y137.679 E.00806
G1 X107.417 Y126.03 E.23187
G1 X107.418 Y126.603 E.00807
G1 X118.494 Y137.679 E.22046
G1 X117.921 Y137.679 E.00806
G1 X107.418 Y127.176 E.20905
G1 X107.419 Y127.749 E.00807
G1 X117.348 Y137.679 E.19764
G1 X116.776 Y137.679 E.00806
G1 X107.419 Y128.322 E.18624
G1 X107.42 Y128.896 E.00807
G1 X116.203 Y137.679 E.17483
G1 X115.63 Y137.679 E.00806
G1 X107.42 Y129.469 E.16342
G2 X107.43 Y130.051 I4.127 J.222 E.00821
G1 X115.032 Y137.653 E.1513
G3 X114.39 Y137.584 I.039 J-3.385 E.00909
G1 X107.505 Y130.7 E.13703
G2 X107.641 Y131.408 I3.774 J-.354 E.01016
G1 X113.682 Y137.449 E.12025
G3 X112.886 Y137.226 I1.622 J-7.311 E.01164
G1 X107.864 Y132.204 E.09996
G1 X108.148 Y132.912 E.01075
G1 X108.305 Y133.217 E.00483
G1 X111.891 Y136.803 E.07137
G1 X111.831 Y136.774 E.00092
G3 X109.964 Y135.449 I3.767 J-7.288 E.03233
G1 X108.569 Y134.054 E.02777
; CHANGE_LAYER
; Z_HEIGHT: 4.76802
; LAYER_HEIGHT: 0.0799999
; WIPE_START
G1 F15000
G1 X109.964 Y135.449 E-.74972
G1 X109.985 Y135.467 E-.01028
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 30/33
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change
G17
G3 Z5.088 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X153.359 Y137.479
G1 Z4.768
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X153.359 Y137.516 E.00048
G3 X152.553 Y138.323 I-.807 J0 E.01664
G1 X115.566 Y138.323 E.48564
G3 X106.767 Y129.523 I.003 J-8.802 E.18147
G1 X106.767 Y117.529 E.15748
G3 X115.566 Y108.73 I8.803 J.004 E.18146
G1 X152.569 Y108.731 E.48586
G3 X153.359 Y109.537 I-.015 J.806 E.01642
G1 X153.359 Y137.419 E.36611
M204 S10000
G1 X152.942 Y137.479 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X152.942 Y137.496 E.00023
G3 X152.531 Y137.905 I-.394 J.015 E.00918
G1 X115.572 Y137.905 E.52143
G3 X107.185 Y129.518 I-.002 J-8.385 E.18587
G1 X107.185 Y117.535 E.16907
G3 X115.571 Y109.148 I8.385 J-.001 E.18586
G1 X152.547 Y109.149 E.52165
G3 X152.942 Y109.557 I.003 J.392 E.00896
G1 X152.942 Y137.419 E.39309
; WIPE_START
G1 X152.942 Y137.496 E-.02894
G1 X152.933 Y137.585 E-.03431
G1 X152.893 Y137.7 E-.04611
G1 X152.822 Y137.796 E-.04517
G1 X152.698 Y137.872 E-.05553
G1 X152.531 Y137.905 E-.0645
G1 X151.254 Y137.905 E-.48545
; WIPE_END
G1 E-.04 F1800
G17
G3 Z5.168 I.37 J1.159 P1  F30000
G1 X151.798 Y137.731 Z5.168
G1 Z4.768
M73 P91 R1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.423328
G1 F15000
G1 X152.587 Y136.943 E.01476
G1 X152.587 Y136.368 E.0076
G1 X151.405 Y137.55 E.02212
G1 X150.831 Y137.55 E.0076
G1 X152.587 Y135.794 E.03287
G1 X152.587 Y135.22 E.0076
G1 X150.256 Y137.55 E.04362
G1 X149.682 Y137.55 E.0076
G1 X152.587 Y134.645 E.05438
G1 X152.587 Y134.071 E.0076
G1 X149.108 Y137.55 E.06513
G1 X148.533 Y137.55 E.0076
G1 X152.587 Y133.496 E.07589
G1 X152.587 Y132.922 E.0076
G1 X147.959 Y137.55 E.08664
G1 X147.384 Y137.55 E.0076
G1 X152.587 Y132.348 E.0974
G1 X152.587 Y131.773 E.0076
G1 X146.81 Y137.55 E.10815
G1 X146.236 Y137.55 E.0076
G1 X152.587 Y131.199 E.1189
G1 X152.587 Y130.624 E.0076
G1 X145.661 Y137.55 E.12966
G1 X145.087 Y137.55 E.0076
G1 X152.587 Y130.05 E.14041
G1 X152.587 Y129.476 E.0076
G1 X144.512 Y137.55 E.15117
G1 X143.938 Y137.55 E.0076
G1 X152.587 Y128.901 E.16192
G1 X152.587 Y128.327 E.0076
G1 X143.364 Y137.55 E.17267
G1 X142.789 Y137.55 E.0076
G1 X152.587 Y127.752 E.18343
G1 X152.587 Y127.178 E.0076
G1 X142.215 Y137.55 E.19418
G1 X141.64 Y137.55 E.0076
G1 X152.587 Y126.604 E.20494
G1 X152.587 Y126.029 E.0076
G1 X141.066 Y137.55 E.21569
G1 X140.492 Y137.55 E.0076
G1 X152.587 Y125.455 E.22644
G1 X152.587 Y124.88 E.0076
G1 X139.917 Y137.55 E.2372
G1 X139.343 Y137.55 E.0076
G1 X152.587 Y124.306 E.24795
G1 X152.587 Y123.732 E.0076
G1 X138.769 Y137.55 E.25871
G1 X138.194 Y137.55 E.0076
G1 X152.587 Y123.157 E.26946
G1 X152.587 Y122.583 E.0076
G1 X137.62 Y137.55 E.28021
G1 X137.045 Y137.55 E.0076
G1 X152.587 Y122.008 E.29097
G1 X152.587 Y121.434 E.0076
G1 X136.471 Y137.55 E.30172
G1 X135.897 Y137.55 E.0076
G1 X152.587 Y120.86 E.31248
G1 X152.587 Y120.285 E.0076
G1 X135.322 Y137.55 E.32323
G1 X134.748 Y137.55 E.0076
G1 X152.587 Y119.711 E.33399
G1 X152.587 Y119.136 E.0076
G1 X134.173 Y137.55 E.34474
G1 X133.599 Y137.55 E.0076
G1 X152.587 Y118.562 E.35549
G1 X152.587 Y117.988 E.0076
G1 X133.025 Y137.55 E.36625
G1 X132.45 Y137.55 E.0076
G1 X152.587 Y117.413 E.377
G1 X152.587 Y116.839 E.0076
G1 X131.876 Y137.55 E.38776
G1 X131.301 Y137.55 E.0076
G1 X152.587 Y116.264 E.39851
G1 X152.587 Y115.69 E.0076
G1 X130.727 Y137.55 E.40926
G1 X130.153 Y137.55 E.0076
G1 X152.587 Y115.116 E.42002
G1 X152.587 Y114.541 E.0076
G1 X129.578 Y137.55 E.43077
G1 X129.004 Y137.55 E.0076
G1 X152.587 Y113.967 E.44153
G1 X152.587 Y113.392 E.0076
G1 X128.429 Y137.55 E.45228
G1 X127.855 Y137.55 E.0076
G1 X152.587 Y112.818 E.46303
G1 X152.587 Y112.244 E.0076
G1 X127.281 Y137.55 E.47379
G1 X126.706 Y137.55 E.0076
G1 X152.587 Y111.669 E.48454
G1 X152.587 Y111.095 E.0076
G1 X126.132 Y137.55 E.4953
G1 X125.557 Y137.55 E.0076
G1 X152.587 Y110.52 E.50605
G1 X152.587 Y109.946 E.0076
G1 X124.983 Y137.55 E.51681
G1 X124.409 Y137.55 E.0076
G1 X152.454 Y109.504 E.52508
G1 X151.88 Y109.504 E.00761
G1 X123.834 Y137.55 E.52508
G1 X123.26 Y137.55 E.0076
G1 X151.305 Y109.504 E.52507
G1 X150.73 Y109.504 E.00761
G1 X122.685 Y137.55 E.52507
G1 X122.111 Y137.55 E.0076
G1 X150.156 Y109.505 E.52507
G1 X149.581 Y109.505 E.00761
G1 X121.537 Y137.55 E.52507
G1 X120.962 Y137.55 E.0076
G1 X149.007 Y109.505 E.52506
G1 X148.432 Y109.505 E.00761
G1 X120.388 Y137.55 E.52506
G1 X119.813 Y137.55 E.0076
G1 X147.858 Y109.505 E.52506
G1 X147.283 Y109.505 E.00761
G1 X119.239 Y137.55 E.52506
G1 X118.665 Y137.55 E.0076
G1 X146.709 Y109.505 E.52505
G1 X146.134 Y109.506 E.00761
G1 X118.09 Y137.55 E.52505
G1 X117.516 Y137.55 E.0076
G1 X145.56 Y109.506 E.52505
G1 X144.985 Y109.506 E.00761
G1 X116.941 Y137.55 E.52505
G1 X116.367 Y137.55 E.0076
G1 X144.411 Y109.506 E.52504
G1 X143.836 Y109.506 E.00761
G1 X115.793 Y137.55 E.52504
G3 X115.235 Y137.533 I-.106 J-5.894 E.00739
G1 X143.262 Y109.506 E.52473
G1 X142.687 Y109.506 E.00761
G1 X114.693 Y137.5 E.52411
G3 X114.195 Y137.424 I.285 J-3.518 E.00668
G1 X142.113 Y109.506 E.52268
G1 X141.538 Y109.507 E.00761
G1 X113.714 Y137.331 E.52094
G3 X113.266 Y137.204 I.441 J-2.4 E.00617
G1 X140.963 Y109.507 E.51856
G1 X140.389 Y109.507 E.00761
G1 X112.831 Y137.065 E.51595
G1 X112.421 Y136.9 E.00585
G1 X139.814 Y109.507 E.51287
G1 X139.24 Y109.507 E.00761
G1 X112.023 Y136.724 E.50956
G3 X111.651 Y136.521 I1.232 J-2.704 E.00561
G1 X138.665 Y109.507 E.50576
G1 X138.091 Y109.507 E.00761
G1 X111.287 Y136.311 E.50183
G3 X110.941 Y136.083 I1.42 J-2.534 E.00549
G1 X137.516 Y109.508 E.49756
G1 X136.942 Y109.508 E.00761
G1 X110.618 Y135.832 E.49285
G3 X110.298 Y135.577 I1.183 J-1.812 E.00542
G1 X136.367 Y109.508 E.48808
G1 X135.793 Y109.508 E.00761
G1 X110.004 Y135.297 E.48283
G3 X109.714 Y135.013 I1.326 J-1.641 E.00539
G1 X135.218 Y109.508 E.47751
G1 X134.644 Y109.508 E.00761
G1 X109.447 Y134.705 E.47174
G3 X109.186 Y134.391 I2.059 J-1.979 E.0054
G1 X134.069 Y109.508 E.46587
G1 X133.495 Y109.509 E.00761
G1 X108.948 Y134.055 E.45957
G1 X108.723 Y133.705 E.0055
G1 X132.92 Y109.509 E.45302
G1 X132.345 Y109.509 E.00761
G1 X108.514 Y133.34 E.44619
G1 X108.318 Y132.961 E.00564
G1 X131.771 Y109.509 E.43909
G1 X131.196 Y109.509 E.00761
G1 X108.14 Y132.566 E.43168
G3 X107.989 Y132.142 I2.886 J-1.267 E.00596
G1 X130.622 Y109.509 E.42375
G1 X130.047 Y109.509 E.00761
G1 X107.845 Y131.712 E.41568
G3 X107.734 Y131.248 I3.183 J-1.008 E.00631
G1 X129.473 Y109.509 E.407
G1 X128.898 Y109.51 E.00761
G1 X107.641 Y130.767 E.39798
G3 X107.582 Y130.251 I2.67 J-.566 E.00688
G1 X128.324 Y109.51 E.38833
G1 X127.749 Y109.51 E.00761
G1 X107.55 Y129.71 E.37819
M73 P92 R1
G1 X107.549 Y129.136 E.0076
G1 X127.175 Y109.51 E.36744
G1 X126.6 Y109.51 E.00761
G1 X107.549 Y128.562 E.35669
G1 X107.548 Y127.988 E.0076
G1 X126.026 Y109.51 E.34594
G1 X125.451 Y109.51 E.00761
G1 X107.548 Y127.414 E.33519
G1 X107.547 Y126.84 E.0076
G1 X124.877 Y109.511 E.32445
G1 X124.302 Y109.511 E.00761
G1 X107.547 Y126.266 E.3137
G1 X107.546 Y125.692 E.0076
G1 X123.728 Y109.511 E.30295
G1 X123.153 Y109.511 E.00761
G1 X107.546 Y125.118 E.2922
G1 X107.545 Y124.544 E.0076
G1 X122.578 Y109.511 E.28145
G1 X122.004 Y109.511 E.00761
G1 X107.545 Y123.97 E.27071
G1 X107.545 Y123.396 E.0076
G1 X121.429 Y109.511 E.25996
G1 X120.855 Y109.511 E.00761
G1 X107.544 Y122.822 E.24921
G1 X107.544 Y122.248 E.0076
G1 X120.28 Y109.512 E.23846
G1 X119.706 Y109.512 E.00761
G1 X107.543 Y121.674 E.22771
G1 X107.543 Y121.1 E.0076
G1 X119.131 Y109.512 E.21696
G1 X118.557 Y109.512 E.00761
G1 X107.542 Y120.526 E.20622
G1 X107.542 Y119.952 E.0076
G1 X117.982 Y109.512 E.19547
G1 X117.408 Y109.512 E.00761
G1 X107.541 Y119.378 E.18472
G1 X107.541 Y118.805 E.0076
G1 X116.833 Y109.512 E.17397
G1 X116.259 Y109.513 E.00761
G1 X107.541 Y118.231 E.16322
G1 X107.54 Y117.657 E.0076
G1 X115.684 Y109.513 E.15248
G2 X115.102 Y109.52 I-.251 J3.062 E.00772
G1 X107.557 Y117.065 E.14125
G1 X107.618 Y116.43 E.00845
G1 X114.467 Y109.581 E.12823
G2 X113.754 Y109.719 I.81 J6.085 E.00962
G1 X107.756 Y115.718 E.11231
G3 X107.989 Y114.91 I4.386 J.83 E.01115
G1 X112.962 Y109.937 E.09309
G1 X112.23 Y110.229 E.01042
G1 X111.953 Y110.372 E.00413
G1 X108.397 Y113.928 E.06658
G1 X108.432 Y113.85 E.00113
G3 X109.732 Y112.018 I7.867 J4.204 E.02981
G1 X111.091 Y110.659 E.02545
; CHANGE_LAYER
; Z_HEIGHT: 4.84802
; LAYER_HEIGHT: 0.0799999
; WIPE_START
G1 F15000
G1 X109.732 Y112.018 E-.73044
G1 X109.681 Y112.077 E-.02956
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 31/33
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change
G17
G3 Z5.168 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X153.206 Y137.479
G1 Z4.848
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X153.206 Y137.511 E.00041
G3 X152.555 Y138.167 I-.657 J0 E.01347
G1 X115.566 Y138.167 E.48567
G3 X106.922 Y129.523 I.007 J-8.651 E.17824
G1 X106.922 Y117.529 E.15748
G3 X115.566 Y108.885 I8.647 J.003 E.17826
G1 X152.61 Y108.888 E.4864
G3 X153.206 Y109.542 I-.062 J.655 E.01275
G1 X153.206 Y137.419 E.36604
M204 S10000
G1 X152.789 Y137.478 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G3 X152.538 Y137.749 I-.254 J.017 E.00583
G1 X115.572 Y137.749 E.52153
G3 X107.34 Y129.518 I.002 J-8.233 E.1824
G1 X107.34 Y117.535 E.16906
G3 X115.571 Y109.303 I8.229 J-.002 E.18243
G1 X152.576 Y109.306 E.52207
G3 X152.789 Y109.575 I-.027 J.239 E.00538
G1 X152.789 Y137.418 E.39281
; WIPE_START
G1 X152.77 Y137.596 E-.06799
G1 X152.73 Y137.668 E-.03142
G1 X152.645 Y137.727 E-.03931
G1 X152.538 Y137.749 E-.04153
G1 X151.013 Y137.749 E-.57974
; WIPE_END
G1 E-.04 F1800
G1 X151.458 Y130.13 Z5.248 F30000
G1 X152.615 Y110.316 Z5.248
G1 Z4.848
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.420958
G1 F15000
G1 X151.96 Y109.661 E.01219
G1 X151.389 Y109.661 E.00751
G1 X152.433 Y110.706 E.01945
G1 X152.433 Y111.277 E.00752
G1 X150.818 Y109.661 E.03007
G1 X150.247 Y109.661 E.00751
G1 X152.433 Y111.848 E.0407
G1 X152.433 Y112.419 E.00752
G1 X149.676 Y109.661 E.05133
G1 X149.105 Y109.661 E.00751
G1 X152.433 Y112.99 E.06195
G1 X152.433 Y113.561 E.00752
G1 X148.534 Y109.661 E.07258
G1 X147.963 Y109.662 E.00751
G1 X152.433 Y114.132 E.08321
G1 X152.433 Y114.703 E.00752
G1 X147.392 Y109.662 E.09383
G1 X146.821 Y109.662 E.00751
G1 X152.433 Y115.274 E.10446
G1 X152.433 Y115.845 E.00752
G1 X146.25 Y109.662 E.11509
G1 X145.679 Y109.662 E.00751
G1 X152.433 Y116.416 E.12571
G1 X152.433 Y116.987 E.00752
G1 X145.108 Y109.662 E.13634
G1 X144.537 Y109.662 E.00751
G1 X152.433 Y117.558 E.14697
G1 X152.433 Y118.129 E.00752
G1 X143.966 Y109.662 E.1576
G1 X143.396 Y109.662 E.00751
G1 X152.433 Y118.7 E.16822
G1 X152.433 Y119.271 E.00752
G1 X142.825 Y109.663 E.17885
G1 X142.254 Y109.663 E.00751
G1 X152.433 Y119.842 E.18948
G1 X152.433 Y120.413 E.00752
G1 X141.683 Y109.663 E.2001
G1 X141.112 Y109.663 E.00751
G1 X152.433 Y120.984 E.21073
G1 X152.433 Y121.555 E.00752
G1 X140.541 Y109.663 E.22136
G1 X139.97 Y109.663 E.00751
G1 X152.433 Y122.127 E.23198
G1 X152.433 Y122.698 E.00752
G1 X139.399 Y109.663 E.24261
G1 X138.828 Y109.663 E.00751
G1 X152.433 Y123.269 E.25324
G1 X152.433 Y123.84 E.00752
G1 X138.257 Y109.663 E.26386
G1 X137.686 Y109.664 E.00751
G1 X152.433 Y124.411 E.27449
G1 X152.433 Y124.982 E.00752
G1 X137.115 Y109.664 E.28512
G1 X136.544 Y109.664 E.00751
G1 X152.433 Y125.553 E.29575
G1 X152.433 Y126.124 E.00752
G1 X135.973 Y109.664 E.30637
G1 X135.402 Y109.664 E.00751
G1 X152.433 Y126.695 E.317
G1 X152.433 Y127.266 E.00752
G1 X134.832 Y109.664 E.32763
G1 X134.261 Y109.664 E.00751
G1 X152.433 Y127.837 E.33825
G1 X152.433 Y128.408 E.00752
G1 X133.69 Y109.664 E.34888
G1 X133.119 Y109.664 E.00751
G1 X152.433 Y128.979 E.35951
G1 X152.433 Y129.55 E.00752
G1 X132.548 Y109.665 E.37013
G1 X131.977 Y109.665 E.00751
G1 X152.433 Y130.121 E.38076
G1 X152.433 Y130.692 E.00752
G1 X131.406 Y109.665 E.39139
G1 X130.835 Y109.665 E.00751
G1 X152.433 Y131.263 E.40201
G1 X152.433 Y131.834 E.00752
G1 X130.264 Y109.665 E.41264
G1 X129.693 Y109.665 E.00751
G1 X152.433 Y132.405 E.42327
G1 X152.433 Y132.976 E.00752
G1 X129.122 Y109.665 E.43389
G1 X128.551 Y109.665 E.00751
G1 X152.433 Y133.547 E.44452
G1 X152.433 Y134.118 E.00752
G1 X127.98 Y109.665 E.45515
G1 X127.409 Y109.666 E.00751
G1 X152.433 Y134.69 E.46578
G1 X152.433 Y135.261 E.00752
G1 X126.838 Y109.666 E.4764
G1 X126.268 Y109.666 E.00751
G1 X152.433 Y135.832 E.48703
G1 X152.433 Y136.403 E.00752
G1 X125.697 Y109.666 E.49766
G1 X125.126 Y109.666 E.00751
G1 X152.433 Y136.974 E.50828
G1 X152.433 Y137.394 E.00554
G1 X152.283 Y137.394 E.00198
G1 X124.555 Y109.666 E.51611
G1 X123.984 Y109.666 E.00751
G1 X151.712 Y137.394 E.51611
G1 X151.141 Y137.394 E.00752
G1 X123.413 Y109.666 E.51611
G1 X122.842 Y109.666 E.00751
G1 X150.57 Y137.394 E.5161
G1 X149.999 Y137.394 E.00752
M73 P93 R1
G1 X122.271 Y109.667 E.5161
G1 X121.7 Y109.667 E.00751
G1 X149.428 Y137.394 E.5161
G1 X148.857 Y137.394 E.00752
G1 X121.129 Y109.667 E.5161
G1 X120.558 Y109.667 E.00751
G1 X148.286 Y137.394 E.5161
G1 X147.715 Y137.394 E.00752
G1 X119.987 Y109.667 E.51609
G1 X119.416 Y109.667 E.00751
G1 X147.144 Y137.394 E.51609
G1 X146.572 Y137.394 E.00752
G1 X118.845 Y109.667 E.51609
G1 X118.274 Y109.667 E.00751
G1 X146.001 Y137.394 E.51609
G1 X145.43 Y137.394 E.00752
G1 X117.704 Y109.667 E.51609
G1 X117.133 Y109.668 E.00751
G1 X144.859 Y137.394 E.51608
G1 X144.288 Y137.394 E.00752
G1 X116.562 Y109.668 E.51608
G1 X115.991 Y109.668 E.00751
G1 X143.717 Y137.394 E.51608
G1 X143.146 Y137.394 E.00752
G1 X115.42 Y109.668 E.51608
G2 X114.88 Y109.699 I-.114 J2.681 E.00713
G1 X142.575 Y137.394 E.51549
G1 X142.004 Y137.394 E.00752
G1 X114.363 Y109.753 E.51449
G1 X113.885 Y109.846 E.00641
G1 X141.433 Y137.394 E.51276
G1 X140.862 Y137.394 E.00752
G1 X113.424 Y109.957 E.5107
G2 X112.996 Y110.099 I.783 J3.07 E.00595
G1 X140.291 Y137.394 E.50805
G1 X139.72 Y137.394 E.00752
G1 X112.575 Y110.25 E.50525
G2 X112.183 Y110.428 I1.05 J2.834 E.00568
G1 X139.149 Y137.394 E.50193
G1 X138.578 Y137.394 E.00752
G1 X111.806 Y110.622 E.49831
G2 X111.442 Y110.829 I1.13 J2.411 E.00552
G1 X138.007 Y137.394 E.49446
G1 X137.436 Y137.394 E.00752
G1 X111.098 Y111.057 E.49022
G1 X110.766 Y111.295 E.00539
G1 X136.865 Y137.394 E.48579
G1 X136.294 Y137.394 E.00752
G1 X110.454 Y111.555 E.48095
G1 X110.148 Y111.82 E.00533
G1 X135.723 Y137.394 E.47602
G1 X135.152 Y137.394 E.00752
G1 X109.868 Y112.111 E.4706
G2 X109.593 Y112.406 I1.317 J1.506 E.00533
G1 X134.581 Y137.394 E.4651
G1 X134.009 Y137.394 E.00752
G1 X109.343 Y112.728 E.45912
G2 X109.096 Y113.052 I1.637 J1.506 E.00537
G1 X133.438 Y137.394 E.45309
G1 X132.867 Y137.394 E.00752
G1 X108.873 Y113.4 E.44661
G2 X108.66 Y113.758 I2.481 J1.724 E.00549
G1 X132.296 Y137.394 E.43996
G1 X131.725 Y137.394 E.00752
G1 X108.471 Y114.14 E.43284
G1 X108.292 Y114.532 E.00567
G1 X131.154 Y137.394 E.42554
G1 X130.583 Y137.394 E.00752
G1 X108.132 Y114.943 E.41789
G2 X108.002 Y115.384 I2.981 J1.118 E.00606
G1 X130.012 Y137.394 E.40968
G1 X129.441 Y137.394 E.00752
G1 X107.885 Y115.839 E.40122
G1 X107.793 Y116.317 E.00642
G1 X128.87 Y137.394 E.39231
G1 X128.299 Y137.394 E.00752
G1 X107.735 Y116.831 E.38275
G2 X107.699 Y117.366 I3.722 J.519 E.00706
G1 X127.728 Y137.394 E.37279
G1 X127.157 Y137.394 E.00752
G1 X107.696 Y117.933 E.36224
G1 X107.696 Y118.504 E.00752
G1 X126.586 Y137.394 E.3516
G1 X126.015 Y137.394 E.00752
G1 X107.697 Y119.076 E.34096
G1 X107.697 Y119.647 E.00752
G1 X125.444 Y137.394 E.33033
G1 X124.873 Y137.394 E.00752
G1 X107.697 Y120.219 E.31969
G1 X107.698 Y120.79 E.00752
G1 X124.302 Y137.394 E.30905
G1 X123.731 Y137.394 E.00752
G1 X107.698 Y121.362 E.29841
G1 X107.699 Y121.933 E.00752
G1 X123.16 Y137.394 E.28778
G1 X122.589 Y137.394 E.00752
G1 X107.699 Y122.505 E.27714
G1 X107.7 Y123.076 E.00752
G1 X122.018 Y137.394 E.2665
G1 X121.446 Y137.394 E.00752
G1 X107.7 Y123.648 E.25587
G1 X107.7 Y124.219 E.00752
G1 X120.875 Y137.394 E.24523
G1 X120.304 Y137.394 E.00752
G1 X107.701 Y124.791 E.23459
G1 X107.701 Y125.362 E.00752
G1 X119.733 Y137.394 E.22395
G1 X119.162 Y137.394 E.00752
G1 X107.702 Y125.934 E.21332
G1 X107.702 Y126.505 E.00752
G1 X118.591 Y137.394 E.20268
G1 X118.02 Y137.394 E.00752
G1 X107.703 Y127.077 E.19204
G1 X107.703 Y127.648 E.00752
G1 X117.449 Y137.394 E.18141
G1 X116.878 Y137.394 E.00752
G1 X107.704 Y128.22 E.17077
G1 X107.704 Y128.791 E.00752
G1 X116.307 Y137.394 E.16013
G1 X115.736 Y137.394 E.00752
G1 X107.704 Y129.363 E.14949
G2 X107.708 Y129.938 I3.039 J.267 E.00758
G1 X115.144 Y137.374 E.13841
G3 X114.514 Y137.315 I-.008 J-3.318 E.00834
G1 X107.769 Y130.569 E.12556
G2 X107.9 Y131.272 I5.512 J-.669 E.00942
G1 X113.819 Y137.19 E.11016
G3 X113.032 Y136.974 I1.23 J-6.024 E.01075
G1 X108.128 Y132.07 E.09128
G2 X108.531 Y133.044 I5.301 J-1.622 E.01389
G1 X112.035 Y136.549 E.06524
G3 X109.994 Y135.078 I3.65 J-7.22 E.03325
G1 X108.829 Y133.914 E.02168
; CHANGE_LAYER
; Z_HEIGHT: 4.92802
; LAYER_HEIGHT: 0.0799999
; WIPE_START
M73 P94 R1
G1 F15000
G1 X109.994 Y135.078 E-.62601
G1 X110.182 Y135.264 E-.10042
G1 X110.249 Y135.322 E-.03357
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 32/33
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change
G17
G3 Z5.248 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X153.008 Y137.491
G1 Z4.928
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X153.008 Y137.535 E.00057
G3 X152.556 Y137.971 I-.451 J-.015 E.00913
G1 X115.566 Y137.971 E.48568
G3 X107.119 Y129.523 I.007 J-8.455 E.1742
G1 X107.119 Y117.529 E.15748
G3 X115.566 Y109.082 I8.468 J.02 E.17412
G1 X152.581 Y109.082 E.48601
G3 X153.008 Y109.518 I-.025 J.452 E.0088
G1 X153.008 Y137.431 E.36651
M204 S10000
G1 X152.591 Y137.491 F30000
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X152.591 Y137.553 E.00087
G1 X115.571 Y137.553 E.52227
G3 X107.536 Y129.518 I.001 J-8.036 E.17806
G1 X107.536 Y117.535 E.16907
G3 X115.571 Y109.499 I8.049 J.014 E.17798
G1 X152.591 Y109.499 E.52227
G1 X152.591 Y137.431 E.39407
G1 X151.601 Y137.379 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.420498
G1 F15000
G1 X152.236 Y136.745 E.01179
G1 X152.236 Y136.175 E.0075
G1 X151.212 Y137.198 E.01902
G1 X150.642 Y137.198 E.0075
G1 X152.236 Y135.605 E.02963
G1 X152.236 Y135.034 E.0075
G1 X150.071 Y137.198 E.04023
G1 X149.501 Y137.198 E.0075
G1 X152.236 Y134.464 E.05084
G1 X152.236 Y133.893 E.0075
G1 X148.931 Y137.198 E.06144
G1 X148.36 Y137.198 E.0075
G1 X152.236 Y133.323 E.07205
G1 X152.236 Y132.753 E.0075
G1 X147.79 Y137.198 E.08265
G1 X147.22 Y137.198 E.0075
G1 X152.236 Y132.182 E.09326
G1 X152.236 Y131.612 E.0075
G1 X146.649 Y137.198 E.10386
G1 X146.079 Y137.198 E.0075
G1 X152.236 Y131.041 E.11447
G1 X152.236 Y130.471 E.0075
G1 X145.508 Y137.198 E.12507
G1 X144.938 Y137.198 E.0075
G1 X152.236 Y129.901 E.13568
G1 X152.236 Y129.33 E.0075
G1 X144.368 Y137.198 E.14628
G1 X143.797 Y137.198 E.0075
G1 X152.236 Y128.76 E.15689
G1 X152.236 Y128.189 E.0075
G1 X143.227 Y137.198 E.16749
G1 X142.656 Y137.198 E.0075
G1 X152.236 Y127.619 E.1781
G1 X152.236 Y127.049 E.0075
G1 X142.086 Y137.198 E.1887
G1 X141.516 Y137.198 E.0075
G1 X152.236 Y126.478 E.1993
G1 X152.236 Y125.908 E.0075
G1 X140.945 Y137.198 E.20991
G1 X140.375 Y137.198 E.0075
G1 X152.236 Y125.337 E.22051
G1 X152.236 Y124.767 E.0075
G1 X139.804 Y137.198 E.23112
G1 X139.234 Y137.198 E.0075
G1 X152.236 Y124.197 E.24172
G1 X152.236 Y123.626 E.0075
G1 X138.664 Y137.198 E.25233
G1 X138.093 Y137.198 E.0075
G1 X152.236 Y123.056 E.26293
G1 X152.236 Y122.485 E.0075
G1 X137.523 Y137.198 E.27354
G1 X136.952 Y137.198 E.0075
G1 X152.236 Y121.915 E.28414
G1 X152.236 Y121.345 E.0075
G1 X136.382 Y137.198 E.29475
G1 X135.812 Y137.198 E.0075
G1 X152.236 Y120.774 E.30535
G1 X152.236 Y120.204 E.0075
G1 X135.241 Y137.198 E.31596
G1 X134.671 Y137.198 E.0075
G1 X152.236 Y119.633 E.32656
G1 X152.236 Y119.063 E.0075
G1 X134.1 Y137.198 E.33717
G1 X133.53 Y137.198 E.0075
G1 X152.236 Y118.493 E.34777
G1 X152.236 Y117.922 E.0075
G1 X132.96 Y137.198 E.35838
G1 X132.389 Y137.198 E.0075
G1 X152.236 Y117.352 E.36898
G1 X152.236 Y116.781 E.0075
G1 X131.819 Y137.198 E.37959
G1 X131.248 Y137.198 E.0075
G1 X152.236 Y116.211 E.39019
G1 X152.236 Y115.641 E.0075
G1 X130.678 Y137.198 E.4008
G1 X130.108 Y137.198 E.0075
G1 X152.236 Y115.07 E.4114
G1 X152.236 Y114.5 E.0075
G1 X129.537 Y137.198 E.42201
G1 X128.967 Y137.198 E.0075
G1 X152.236 Y113.929 E.43261
G1 X152.236 Y113.359 E.0075
G1 X128.396 Y137.198 E.44321
G1 X127.826 Y137.198 E.0075
G1 X152.236 Y112.789 E.45382
G1 X152.236 Y112.218 E.0075
G1 X127.256 Y137.198 E.46442
G1 X126.685 Y137.198 E.0075
G1 X152.236 Y111.648 E.47503
G1 X152.236 Y111.078 E.0075
G1 X126.115 Y137.198 E.48563
G1 X125.545 Y137.198 E.0075
G1 X152.236 Y110.507 E.49624
G1 X152.236 Y109.937 E.0075
G1 X124.974 Y137.198 E.50684
G1 X124.404 Y137.198 E.0075
G1 X151.747 Y109.855 E.50837
G1 X151.177 Y109.855 E.0075
G1 X123.833 Y137.198 E.50837
G1 X123.263 Y137.198 E.0075
G1 X150.606 Y109.855 E.50837
G1 X150.036 Y109.855 E.0075
G1 X122.693 Y137.198 E.50837
G1 X122.122 Y137.198 E.0075
G1 X149.466 Y109.855 E.50837
G1 X148.895 Y109.855 E.0075
G1 X121.552 Y137.198 E.50837
G1 X120.981 Y137.198 E.0075
G1 X148.325 Y109.855 E.50837
G1 X147.755 Y109.855 E.0075
G1 X120.411 Y137.198 E.50837
G1 X119.841 Y137.198 E.0075
G1 X147.184 Y109.855 E.50837
G1 X146.614 Y109.855 E.0075
G1 X119.27 Y137.198 E.50837
G1 X118.7 Y137.198 E.0075
G1 X146.043 Y109.855 E.50837
G1 X145.473 Y109.855 E.0075
G1 X118.129 Y137.198 E.50837
G1 X117.559 Y137.198 E.0075
G1 X144.903 Y109.855 E.50837
G1 X144.332 Y109.855 E.0075
G1 X116.989 Y137.198 E.50837
G1 X116.418 Y137.198 E.0075
G1 X143.762 Y109.855 E.50837
G1 X143.191 Y109.855 E.0075
G1 X115.848 Y137.198 E.50837
G3 X115.291 Y137.184 I-.134 J-5.878 E.00732
G1 X142.621 Y109.855 E.50812
G1 X142.051 Y109.855 E.0075
G1 X114.754 Y137.151 E.5075
G1 X114.255 Y137.08 E.00662
G1 X141.48 Y109.855 E.50617
G1 X140.91 Y109.855 E.0075
G1 X113.778 Y136.987 E.50444
G3 X113.336 Y136.858 I.682 J-3.173 E.00606
G1 X140.339 Y109.855 E.50205
G1 X139.769 Y109.855 E.0075
G1 X112.904 Y136.72 E.49948
G3 X112.501 Y136.552 I.973 J-2.895 E.00574
G1 X139.199 Y109.855 E.49635
M73 P94 R0
G1 X138.628 Y109.855 E.0075
G1 X112.11 Y136.373 E.49303
G3 X111.737 Y136.175 I1.195 J-2.703 E.00555
G1 X138.058 Y109.855 E.48935
G1 X137.487 Y109.855 E.0075
G1 X111.39 Y135.952 E.48521
G3 X111.046 Y135.725 I1.417 J-2.511 E.00542
G1 X136.917 Y109.855 E.48099
G1 X136.347 Y109.855 E.0075
G1 X110.727 Y135.475 E.47633
G1 X110.42 Y135.21 E.00532
G1 X135.776 Y109.855 E.47142
G1 X135.206 Y109.855 E.0075
G1 X110.131 Y134.929 E.46618
G1 X109.851 Y134.639 E.0053
G1 X134.635 Y109.855 E.46078
G1 X134.065 Y109.855 E.0075
G1 X109.591 Y134.328 E.45501
G1 X109.34 Y134.009 E.00534
G1 X133.495 Y109.855 E.44908
G1 X132.924 Y109.855 E.0075
G1 X109.114 Y133.665 E.44267
M73 P95 R0
G3 X108.894 Y133.315 I2.337 J-1.719 E.00544
G1 X132.354 Y109.855 E.43617
G1 X131.783 Y109.855 E.0075
G1 X108.698 Y132.94 E.4292
G1 X108.52 Y132.548 E.00566
G1 X131.213 Y109.855 E.42192
G1 X130.643 Y109.855 E.0075
G1 X108.359 Y132.138 E.4143
G1 X108.212 Y131.715 E.00589
G1 X130.072 Y109.855 E.40642
G1 X129.502 Y109.855 E.0075
G1 X108.094 Y131.262 E.39801
G1 X108.002 Y130.784 E.0064
G1 X128.931 Y109.855 E.38912
G1 X128.361 Y109.855 E.0075
G1 X107.938 Y130.278 E.37971
G3 X107.901 Y129.745 I2.798 J-.462 E.00704
G1 X127.791 Y109.855 E.3698
G1 X127.22 Y109.855 E.0075
G1 X107.9 Y129.175 E.3592
G1 X107.9 Y128.605 E.00749
G1 X126.65 Y109.855 E.3486
G1 X126.08 Y109.855 E.0075
G1 X107.899 Y128.035 E.33801
G1 X107.899 Y127.465 E.00749
G1 X125.509 Y109.855 E.32741
G1 X124.939 Y109.855 E.0075
G1 X107.899 Y126.895 E.31681
G1 X107.898 Y126.325 E.00749
G1 X124.368 Y109.855 E.30621
G1 X123.798 Y109.855 E.0075
G1 X107.898 Y125.755 E.29562
G1 X107.897 Y125.185 E.00749
G1 X123.228 Y109.855 E.28502
G1 X122.657 Y109.855 E.0075
G1 X107.897 Y124.615 E.27442
G1 X107.896 Y124.045 E.00749
G1 X122.087 Y109.855 E.26383
G1 X121.516 Y109.855 E.0075
G1 X107.896 Y123.475 E.25323
G1 X107.896 Y122.905 E.00749
G1 X120.946 Y109.855 E.24263
G1 X120.376 Y109.855 E.0075
G1 X107.895 Y122.335 E.23204
G1 X107.895 Y121.765 E.00749
G1 X119.805 Y109.855 E.22144
G1 X119.235 Y109.855 E.0075
G1 X107.894 Y121.195 E.21084
G1 X107.894 Y120.625 E.00749
G1 X118.664 Y109.855 E.20025
G1 X118.094 Y109.855 E.0075
G1 X107.893 Y120.055 E.18965
G1 X107.893 Y119.485 E.00749
G1 X117.524 Y109.855 E.17905
G1 X116.953 Y109.855 E.0075
G1 X107.893 Y118.915 E.16846
G1 X107.892 Y118.345 E.00749
G1 X116.383 Y109.855 E.15786
G1 X115.812 Y109.855 E.0075
G1 X107.892 Y117.775 E.14726
G3 X107.9 Y117.197 I11.76 J-.127 E.00761
G1 X115.225 Y109.871 E.1362
G2 X114.603 Y109.923 I-.041 J3.276 E.00822
G1 X107.957 Y116.569 E.12356
G3 X108.079 Y115.877 I5.016 J.523 E.00924
G1 X113.921 Y110.035 E.10862
G2 X113.131 Y110.255 I1.141 J5.637 E.01079
G1 X108.299 Y115.086 E.08983
G3 X108.695 Y114.12 I5.256 J1.589 E.01375
G1 X112.163 Y110.652 E.06448
G2 X110.024 Y112.22 I3.751 J7.358 E.03502
G1 X108.975 Y113.27 E.01951
; CHANGE_LAYER
; Z_HEIGHT: 5.00802
; LAYER_HEIGHT: 0.0799999
; WIPE_START
G1 F15000
G1 X110.024 Y112.22 E-.56393
G1 X110.398 Y111.864 E-.19607
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 33/33
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change
G17
G3 Z5.328 I1.217 J0 P1  F30000
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
; OBJECT_ID: 1237
G1 X152.696 Y137.549
G1 Z5.008
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F9000
M204 S5000
G1 X152.617 Y137.643 E.00161
G1 X152.542 Y137.658 E.00101
G1 X115.566 Y137.658 E.4855
G3 X107.431 Y129.523 I.019 J-8.154 E.16767
G1 X107.431 Y117.529 E.15748
G3 X115.566 Y109.395 I8.138 J.003 E.16777
G1 X152.542 Y109.395 E.4855
G1 X152.617 Y109.41 E.00101
G1 X152.696 Y109.504 E.00161
G1 X152.696 Y137.489 E.36745
; WIPE_START
M204 S10000
G1 X152.617 Y137.643 E-.06578
G1 X152.542 Y137.658 E-.0291
G1 X150.792 Y137.658 E-.66512
; WIPE_END
G1 E-.04 F1800
G1 X151.261 Y130.04 Z5.408 F30000
G1 X152.475 Y110.332 Z5.408
G1 Z5.008
G1 E.8 F1800
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X151.758 Y109.616 E.0133
G1 X151.189 Y109.616
G1 X152.475 Y110.902 E.02388
G1 X152.475 Y111.472
G1 X150.619 Y109.616 E.03446
G1 X150.049 Y109.616
G1 X152.475 Y112.041 E.04504
G1 X152.475 Y112.611
G1 X149.48 Y109.616 E.05561
G1 X148.91 Y109.616
G1 X152.475 Y113.181 E.06619
G1 X152.475 Y113.75
G1 X148.34 Y109.616 E.07677
G1 X147.771 Y109.616
G1 X152.475 Y114.32 E.08735
G1 X152.475 Y114.89
G1 X147.201 Y109.616 E.09793
G1 X146.631 Y109.616
G1 X152.475 Y115.46 E.10851
G1 X152.475 Y116.029
G1 X146.062 Y109.616 E.11909
G1 X145.492 Y109.616
G1 X152.475 Y116.599 E.12966
G1 X152.475 Y117.169
G1 X144.922 Y109.616 E.14024
G1 X144.353 Y109.616
G1 X152.475 Y117.738 E.15082
G1 X152.475 Y118.308
G1 X143.783 Y109.616 E.1614
G1 X143.213 Y109.616
G1 X152.475 Y118.878 E.17198
G1 X152.475 Y119.447
G1 X142.643 Y109.616 E.18256
G1 X142.074 Y109.616
G1 X152.475 Y120.017 E.19314
G1 X152.475 Y120.587
G1 X141.504 Y109.616 E.20371
G1 X140.934 Y109.616
G1 X152.475 Y121.156 E.21429
G1 X152.475 Y121.726
G1 X140.365 Y109.616 E.22487
G1 X139.795 Y109.616
G1 X152.475 Y122.296 E.23545
G1 X152.475 Y122.865
G1 X139.225 Y109.616 E.24603
G1 X138.656 Y109.616
G1 X152.475 Y123.435 E.25661
G1 X152.475 Y124.005
G1 X138.086 Y109.616 E.26719
G1 X137.516 Y109.616
G1 X152.475 Y124.575 E.27776
G1 X152.475 Y125.144
G1 X136.947 Y109.616 E.28834
G1 X136.377 Y109.616
G1 X152.475 Y125.714 E.29892
G1 X152.475 Y126.284
G1 X135.807 Y109.616 E.3095
G1 X135.237 Y109.616
G1 X152.475 Y126.853 E.32008
G1 X152.475 Y127.423
G1 X134.668 Y109.616 E.33066
G1 X134.098 Y109.616
G1 X152.475 Y127.993 E.34124
G1 X152.475 Y128.562
G1 X133.528 Y109.616 E.35181
G1 X132.959 Y109.616
G1 X152.475 Y129.132 E.36239
G1 X152.475 Y129.702
G1 X132.389 Y109.616 E.37297
G1 X131.819 Y109.616
G1 X152.475 Y130.271 E.38355
M73 P96 R0
G1 X152.475 Y130.841
G1 X131.25 Y109.616 E.39413
G1 X130.68 Y109.616
G1 X152.475 Y131.411 E.40471
G1 X152.475 Y131.98
G1 X130.11 Y109.616 E.41528
G1 X129.541 Y109.616
G1 X152.475 Y132.55 E.42586
G1 X152.475 Y133.12
G1 X128.971 Y109.616 E.43644
G1 X128.401 Y109.616
G1 X152.475 Y133.69 E.44702
G1 X152.475 Y134.259
G1 X127.832 Y109.616 E.4576
G1 X127.262 Y109.616
G1 X152.475 Y134.829 E.46818
G1 X152.475 Y135.399
G1 X126.692 Y109.616 E.47876
G1 X126.122 Y109.616
G1 X152.475 Y135.968 E.48933
G1 X152.475 Y136.538
G1 X125.553 Y109.616 E.49991
G1 X124.983 Y109.616
G1 X152.475 Y137.108 E.51049
G1 X152.234 Y137.437
G1 X124.413 Y109.616 E.5166
G1 X123.844 Y109.616
G1 X151.664 Y137.437 E.5166
G1 X151.095 Y137.437
G1 X123.274 Y109.616 E.5166
G1 X122.704 Y109.616
G1 X150.525 Y137.437 E.5166
G1 X149.955 Y137.437
G1 X122.135 Y109.616 E.5166
G1 X121.565 Y109.616
G1 X149.385 Y137.437 E.5166
G1 X148.816 Y137.437
G1 X120.995 Y109.616 E.5166
G1 X120.426 Y109.616
G1 X148.246 Y137.437 E.5166
G1 X147.676 Y137.437
G1 X119.856 Y109.616 E.5166
G1 X119.286 Y109.616
G1 X147.107 Y137.437 E.5166
G1 X146.537 Y137.437
G1 X118.717 Y109.616 E.5166
G1 X118.147 Y109.616
G1 X145.967 Y137.437 E.5166
G1 X145.398 Y137.437
G1 X117.577 Y109.616 E.5166
G1 X117.007 Y109.616
G1 X144.828 Y137.437 E.5166
G1 X144.258 Y137.437
G1 X116.438 Y109.616 E.5166
G1 X115.868 Y109.616
G1 X143.689 Y137.437 E.5166
G1 X143.119 Y137.437
G1 X115.311 Y109.628 E.51637
G1 X114.771 Y109.658
G1 X142.549 Y137.437 E.51582
G1 X141.98 Y137.437
G1 X114.273 Y109.73 E.51449
G1 X113.792 Y109.819
G1 X141.41 Y137.437 E.51283
G1 X140.84 Y137.437
G1 X113.346 Y109.943 E.51053
G1 X112.911 Y110.077
G1 X140.27 Y137.437 E.50804
G1 X139.701 Y137.437
G1 X112.502 Y110.238 E.50505
G1 X112.11 Y110.415
G1 X139.131 Y137.437 E.50176
G1 X138.561 Y137.437
G1 X111.733 Y110.608 E.49818
G1 X111.378 Y110.823
G1 X137.992 Y137.437 E.4942
G1 X137.422 Y137.437
G1 X111.032 Y111.047 E.49003
G1 X110.703 Y111.287
G1 X136.852 Y137.437 E.48557
G1 X136.283 Y137.437
G1 X110.389 Y111.543 E.48081
G1 X110.097 Y111.821
G1 X135.713 Y137.437 E.47566
G1 X135.143 Y137.437
G1 X109.809 Y112.102 E.47044
G1 X109.544 Y112.407
G1 X134.574 Y137.437 E.46477
G1 X134.004 Y137.437
G1 X109.285 Y112.718 E.45901
G1 X109.048 Y113.05
G1 X133.434 Y137.437 E.45283
M73 P97 R0
G1 X132.865 Y137.437
G1 X108.825 Y113.397 E.44639
G1 X108.613 Y113.755
G1 X132.295 Y137.437 E.43975
G1 X131.725 Y137.437
G1 X108.425 Y114.137 E.43265
G1 X108.247 Y114.528
G1 X131.155 Y137.437 E.42539
G1 X130.586 Y137.437
G1 X108.095 Y114.946 E.41762
G1 X107.955 Y115.375
G1 X130.016 Y137.437 E.40965
G1 X129.446 Y137.437
G1 X107.844 Y115.834 E.40114
G1 X107.749 Y116.309
G1 X128.877 Y137.437 E.39232
G1 X128.307 Y137.437
G1 X107.694 Y116.823 E.38277
G1 X107.657 Y117.356
G1 X127.737 Y137.437 E.37287
G1 X127.168 Y137.437
G1 X107.653 Y117.922 E.36236
G1 X107.654 Y118.492
G1 X126.598 Y137.437 E.35178
G1 X126.028 Y137.437
G1 X107.654 Y119.062 E.34119
G1 X107.655 Y119.633
G1 X125.459 Y137.437 E.3306
G1 X124.889 Y137.437
G1 X107.655 Y120.203 E.32002
G1 X107.655 Y120.773
G1 X124.319 Y137.437 E.30943
G1 X123.75 Y137.437
G1 X107.656 Y121.343 E.29884
G1 X107.656 Y121.913
G1 X123.18 Y137.437 E.28826
G1 X122.61 Y137.437
G1 X107.657 Y122.483 E.27767
G1 X107.657 Y123.053
G1 X122.04 Y137.437 E.26708
G1 X121.471 Y137.437
G1 X107.658 Y123.623 E.2565
G1 X107.658 Y124.193
G1 X120.901 Y137.437 E.24591
G1 X120.331 Y137.437
G1 X107.658 Y124.764 E.23532
G1 X107.659 Y125.334
G1 X119.762 Y137.437 E.22474
G1 X119.192 Y137.437
G1 X107.659 Y125.904 E.21415
G1 X107.66 Y126.474
G1 X118.622 Y137.437 E.20357
G1 X118.053 Y137.437
G1 X107.66 Y127.044 E.19298
G1 X107.661 Y127.614
G1 X117.483 Y137.437 E.18239
G1 X116.913 Y137.437
G1 X107.661 Y128.184 E.17181
G1 X107.661 Y128.754
G1 X116.344 Y137.437 E.16122
G1 X115.774 Y137.437
G1 X107.662 Y129.325 E.15063
G1 X107.662 Y129.895
G1 X115.186 Y137.418 E.13971
G1 X114.563 Y137.365
G1 X107.725 Y130.527 E.12697
G1 X107.843 Y131.214
G1 X113.882 Y137.253 E.11214
G1 X113.095 Y137.036
G1 X108.059 Y132 E.09351
G1 X108.443 Y132.954
G1 X112.139 Y136.65 E.06864
M204 S10000
G1 X111.457 Y136.283 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.0859607
G1 F15000
G1 X111.302 Y136.162 E.00044
; LINE_WIDTH: 0.127408
G1 X111.11 Y135.999 E.00091
; LINE_WIDTH: 0.169364
G1 X110.917 Y135.836 E.00125
; LINE_WIDTH: 0.21132
G1 X110.725 Y135.673 E.0016
; LINE_WIDTH: 0.249846
G1 X110.452 Y135.425 E.0028
; LINE_WIDTH: 0.276055
G3 X109.665 Y134.638 I10.624 J-11.408 E.0094
; LINE_WIDTH: 0.244938
M73 P98 R0
G1 X109.417 Y134.358 E.00277
; LINE_WIDTH: 0.200553
G1 X109.169 Y134.079 E.00223
; LINE_WIDTH: 0.159554
G1 X109.054 Y133.936 E.00085
; LINE_WIDTH: 0.121935
G1 X108.938 Y133.793 E.00063
; LINE_WIDTH: 0.0843155
G1 X108.823 Y133.649 E.0004
; WIPE_START
G1 X108.938 Y133.793 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.587 Y136.864 Z5.408 F30000
G1 Z5.008
G1 E.8 F1800
; LINE_WIDTH: 0.200228
G1 F15000
G1 X112.205 Y136.585 E.00283
; WIPE_START
G1 X112.587 Y136.864 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.919 Y129.239 Z5.408 F30000
G1 X113.764 Y109.822 Z5.408
G1 Z5.008
G1 E.8 F1800
; LINE_WIDTH: 0.0777965
G1 F15000
G1 X113.6 Y109.912 E.00037
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F15000
G1 X113.764 Y109.822 E-.76
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
G1 Z5.50802 F900 ; lower z a little
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

    G1 Z105.008 F600
    G1 Z103.008

M400 P100
M17 R ; restore z current

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M73 P100 R0
; EXECUTABLE_BLOCK_END

