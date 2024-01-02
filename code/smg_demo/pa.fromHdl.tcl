
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name smg_demo -dir "C:/Users/Admin/Desktop/FPGA_ISE_code/FPGA_design/smg_demo/smg_demo/planAhead_run_1" -part xc6slx9ftg256-2
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "smg_demo.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {smg_demo.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top smg_demo $srcset
add_files [list {smg_demo.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx9ftg256-2
