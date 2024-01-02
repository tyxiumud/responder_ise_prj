
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name key_filter -dir "E:/FPGAtest/key_filter/planAhead_run_1" -part xc3s100ecp132-4
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "key_filter.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {key_filter.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top key_filter $srcset
add_files [list {key_filter.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s100ecp132-4
