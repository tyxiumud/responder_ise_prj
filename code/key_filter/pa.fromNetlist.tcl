
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name key_filter -dir "C:/Users/Admin/Desktop/FPGA_ISE_code/key_filter/planAhead_run_2" -part xc6slx9ftg256-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/Admin/Desktop/FPGA_ISE_code/key_filter/key_filter.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Admin/Desktop/FPGA_ISE_code/key_filter} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "key_filter.ucf" [current_fileset -constrset]
add_files [list {key_filter.ucf}] -fileset [get_property constrset [current_run]]
link_design
