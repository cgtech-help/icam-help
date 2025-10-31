##############################################################################
# Description
#     This is the Definition File for CLS File Generation 
#
#     #1003:0  general information (version)
#     #1003:3  LINTOL & STOCK TOLERANCE
#     #1003:5  OPERATION TIME
#     #1003:8  SUB OPERATION
#     #1003:9  TOOL LIST
#     #1003:15 COORDINATE SYSTEMS
#     #1003:19 TOOLING SYSTEM
#     #1003:20 TOOLPATH GROUP NAME
#     #1003:21 TOOL PATH TRNASFORM MATRIX
#     #1003:22 Unhandled UDE
#     #1003:26 DEPOSITION PARAMETERS
#     #1003:30 NX1926 and after: auto bounding block blank information
#
# Revisions
#
#   Date        Who     Reason
#
###############################################################################
#System or MOM varaibles
global mom_kin_arc_output_mode
global mom_kin_helical_arc_output_mode
global mom_kin_max_arc_radius
global mom_kin_min_arc_radius
global mom_kin_arc_valid_planes
global mom_motion_output
global mom_arc_mode

global mom_out_angle_pos
global mom_tool_adj_reg_defined
global mom_util_done_heading
global mom_arc_times
global mom_tool_material_description
global mom_tool_type
global mom_spindle_mode

###############################################################################
set mom_kin_arc_output_mode					"FULL_CIRCLE"
set mom_kin_helical_arc_output_mode			"FULL_CIRCLE"
set mom_kin_max_arc_radius					9999.9999
set mom_kin_min_arc_radius					0.0001
set mom_kin_arc_valid_plane					ANY ;# XYZ
set mom_arc_mode							CIRCULAR
set mom_motion_output						TRUE
set	mom_kin_clsf_generation					TRUE

#set mom_kin_iks_usage						TRUE
#set mom_kin_coordinate_system_type			MAIN ;# LOCAL/MAIN/CSYS

set mom_out_angle_pos(0)					0.0
set mom_out_angle_pos(1)					0.0
set mom_prev_out_angle_pos(0)				0.0
set mom_prev_out_angle_pos(1)				0.0
set mom_tool_adj_reg_defined				0
set mom_util_done_heading					0
set mom_arc_times							0
set mom_tool_material_description			"UNDEFINED"
set mom_tool_type							"UNDEFINED"
set mom_spindle_mode						"NONE"

###############################################################################
# User defined variables
global mom_icam_version
global mom_my_operation_time
global mom_my_tool_list
global mom_my_goto_flag
global mom_my_prev_feed_val
global mom_my_prev_feed_unit
global mom_my_protected_move
global mom_my_buffer_did_output
global mom_my_lintol_did_output
global mom_my_loadtl_did_output
global mom_my_tracking_did_output
global mom_my_cycle_feed_rate_mode
global mom_my_last_apply
global mom_my_this_apply
global mom_my_deposition
global mom_max_cut_traverse
global mom_my_pitch_did_output
global mom_force_tracking_point_angle_radius
global mom_force_spindl_after_optype
global mom_my_max_length
global mom_my_show_message
global mom_allow_load_wire
global has_last_tool_vector
set has_last_tool_vector 0
set mom_allow_load_wire 0
global mom_my_cycle_retract_auto
set mom_my_cycle_retract_auto 1

global mom_my_use_user_defined_partno
set mom_my_use_user_defined_partno 0

global mom_my_load_tool_order_flag
set mom_my_load_tool_order_flag 1
global mom_my_load_tool_index
global mom_my_load_tool_marker

global buffering
global buffer_size
global buffer

set Step_value1 0.000000
set Step_value2 0.000000
set Step_value3 0.000000

global mom_output_am
set mom_output_am 1

global mom_my_am_on
global mom_my_am_flag
global mom_my_am_fedrate
global mom_my_pos_fedrate

set mom_my_am_on ""
set mom_my_am_flag 0
set mom_my_am_fedrate 0
set mom_my_pos_fedrate -1

###############################################################################
# CLS user defined switch
set mom_my_show_message						0
set mom_my_max_length						256
set mom_force_spindl_after_optype 1
set mom_force_tracking_point_angle_radius 1

global mom_icam_custom
global mom_customer_custom
set mom_icam_custom [file dirname [info script]]
append mom_icam_custom "/icam_custom.tcl"

if {[file exists $mom_icam_custom]} { source $mom_icam_custom }
set mom_customer_custom [MOM_ask_env_var UGII_CAM_POST_DIR]icam_custom.tcl
if {[file exists $mom_customer_custom]} { source $mom_customer_custom }

###############################################################################
proc MOM_start_of_program {} {
global mom_icam_version
global mom_part_name
global mom_ug_version
global mom_my_optype
global mom_my_last_apply
global mom_my_this_apply
global mom_my_units_did_output
global mom_my_multax_flag
global mom_my_prev_feed_unit
global mom_my_prev_feed_val
global mom_my_pocket_id
global mom_my_tool_size
global mom_my_prev_feed_val
global mom_my_thread_cycle_filter
global mom_my_use_user_defined_partno
global mom_kin_clsf_generation
global buffering
global buffer_size
global mom_output_am

	if { ![info exist mom_kin_clsf_generation] } { set mom_output_am 0 }
	
	set buffering 0
	set buffer_size 0
	
global mom_output_file_full_name
	if {[file exists $mom_output_file_full_name]} {
		MOM_close_output_file $mom_output_file_full_name
		catch { file delete -force $mom_output_file_full_name }
		MOM_open_output_file $mom_output_file_full_name
	}
	
	set mom_my_prev_feed_val 0.0
	set mom_my_prev_feed_unit "NONE"
	set mom_my_tool_size 0
	set mom_my_pocket_id [get_pocket_id]
	set mom_my_last_apply ""
	set mom_my_this_apply ""
	set mom_my_units_did_output "NO"
	set mom_my_optype ""
	set mom_my_prev_feed_val 0
	set mom_my_thread_cycle_filter	0
	
	reset_my_variables

	# header 1: Template version
    set mom_icam_version "24,2215"
	MOM_do_template icam_version
	MOM_output_literal "#1003:0/'ICAMCLSF.TCL',24,2232"
	#MOM_output_literal #1003:0/'UG_VERSION=$mom_ug_version'
	set str [split $mom_ug_version " "]
	set tmp [split [lindex $str 1] .]
	MOM_output_literal "#1003:0/'[lindex $str 0]',[lindex $tmp 0],[lindex $tmp 1],[lindex $tmp 2],[lindex $tmp 3]"

	# header 2: tool listed at header section
	output_tool_list

	# header 3: PARTNO unless it's user defined
	set temp_part_name [file tail $mom_part_name]
	set temp_name_list [split $temp_part_name .]
	set temp_part_name [lindex $temp_name_list 0]
	set temp_part_name [string toupper $temp_part_name]
	if { $mom_my_use_user_defined_partno == 0 } {
		MOM_output_literal "PARTNO/'$temp_part_name'"
	}

	# header 4: output MULTAX/ON always
	set mom_my_multax_flag "ON"
	MOM_output_literal "MULTAX/ON"
	
	# header 5: UNITS
	output_units
}

###############################################################################
proc output_units {} {
global mom_output_unit
global mom_my_units_did_output
	if {$mom_my_units_did_output != "YES"} {
		if {$mom_output_unit == "IN"} {
			MOM_output_literal "UNITS/INCHES"
		} elseif {$mom_output_unit == "MM"} {
			MOM_output_literal "UNITS/MM"
		} else {
			MOM_output_literal "\$\$ WARNING - UNITS: $mom_output_unit"
			MOM_output_literal "UNITS/MM"
		}
	}
	set mom_my_units_did_output "YES"
}

###############################################################################
proc MOM_start_of_group {} {
global mom_group_name
	# header 6: group name
	if {[string first "'" $mom_group_name] != -1 || [string first "\"" $mom_group_name] != -1} {
		MOM_output_literal "#1003:20/$mom_group_name"
	} else {
		MOM_output_literal "#1003:20/'$mom_group_name'"
	}
}

###############################################################################
proc MOM_machine_mode {} {
global mom_machine_mode
global mom_operation_type
global mom_my_optype
global mom_my_this_apply
global mom_kin_machine_type
global mom_machine_name
	#For each new group before actual toolpath
	#if {[info exists mom_machine_name] && [string length $mom_machine_name] > 0} { MOM_output_literal "\$\$ MACHINE/'$mom_machine_name'"}
	if {$mom_machine_mode == "MILL"} {
		#MOM_output_literal "\$\$ MACHINE_MODE/MILL"
		set mom_kin_machine_type "5_axis_head_table"
		set mom_my_this_apply "APPLY/MILL"
		set mom_my_optype OPTYPE/MILL
	} elseif { $mom_machine_mode == "DRILL"} {
		set mom_operation_type [string toupper $mom_operation_type]
		if { [string first "CENTERLINE" $mom_operation_type] != -1 } {
			#MOM_output_literal "\$\$ MACHINE_MODE/TURN,DRILL"
			set mom_kin_machine_type "lathe"
			set mom_my_optype OPTYPE/AXIAL
			set mom_my_this_apply "APPLY/TURN"
		} else {
			#MOM_output_literal "\$\$ MACHINE_MODE/MILL"
			set mom_kin_machine_type "5_axis_head_table"
			set mom_my_this_apply "APPLY/MILL"
			set mom_my_optype "OPTYPE/MILL"
		}
	} elseif {$mom_machine_mode == "TURN" || $mom_machine_mode == "LATHE"} {
		#MOM_output_literal "\$\$ MACHINE_MODE/TURN"
		set mom_kin_machine_type "lathe"
		set mom_my_this_apply "APPLY/TURN"
		set mom_my_optype OPTYPE/TURN
	} elseif {$mom_machine_mode == "WEDM"} {
		set mom_my_this_apply ""
		set mom_my_optype ""
	} else {
		# output the warning right away when it happens without order control
		MOM_output_literal "\$\$ WARNING - UNSUPPORTED MACHINE MODE: $mom_machine_mode"
		MOM_output_literal "\$\$ USING DEFAULT: MILL"
		set mom_kin_machine_type "5_axis_head_table"
		set mom_my_this_apply "APPLY/MILL"
		set mom_my_optype ""
	}
	MOM_get_optype
}

proc MOM_end_of_group {} {}

###############################################################################
proc MOM_sequence_number { } {
global mom_sequence_mode
global mom_sequence_number
global mom_sequence_frequency
global mom_sequence_increment
global mom_sequence_text
global mom_sequence_text_defined

	set txt ""
	if { $mom_sequence_text_defined && [info exists mom_sequence_text] && $mom_sequence_text != "" } { set txt ,$mom_sequence_text }

	if {$mom_sequence_mode=="OFF" || $mom_sequence_mode=="ON" || $mom_sequence_mode=="AUTO" } {
		MOM_output_literal SEQNO/$mom_sequence_mode$txt
	} else {
		if { [info exists mom_sequence_number] && $mom_sequence_number != 0 } {
			set Sequence "SEQNO/$mom_sequence_number"
			if { [info exists mom_sequence_increment] && $mom_sequence_increment != 0 } {
				append Sequence ",INCR,$mom_sequence_increment"
				if { [info exists mom_sequence_frequency] && $mom_sequence_frequency != 0 } {
					append Sequence ",$mom_sequence_frequency"
				}
			} 
			MOM_output_literal $Sequence$txt
		}
	}
}

###############################################################################
proc MOM_set_axis { } {
global mom_axis_position
global mom_axis_position_value
global mom_axis_position_value_defined

	set SetAxis MOVETO/$mom_axis_position
	if { [info exists mom_axis_position_value_defined] && $mom_axis_position_value_defined == 1 } {
		append SetAxis ",[fm $mom_axis_position_value]"
	}
	MOM_output_literal $SetAxis
}

###############################################################################
proc MOM_set_polar { } {
global mom_coordinate_output_mode
	MOM_output_literal "MODE/POLAR,$mom_coordinate_output_mode"
}

###############################################################################
proc output_tool_list { } {
global mom_isv_tool_count
global mom_isv_tool_number
global mom_isv_tool_name
global mom_isv_tool_description
	if { [info exists mom_isv_tool_count] && $mom_isv_tool_count > 0 } { 
		for {set i 0} {$i<$mom_isv_tool_count} {incr i} {
			if {[info exists mom_isv_tool_number($i)]} {
				set str "#1003:9/'TOOL',$mom_isv_tool_number($i)"
				if {[info exists mom_isv_tool_name($i)] && [string length $mom_isv_tool_name($i)] > 0 } { 
#					append str ",TLNAME,'[regsub ' [string trim $mom_isv_tool_name($i)] _]'"
					set tname [string trim $mom_isv_tool_name($i)]
					append str ",TLNAME,'${tname}',OUT"
				}
				if {[info exists mom_isv_tool_description($i)] && [string length $mom_isv_tool_description($i)] > 0 } { 
#					append str ",'DESC',OUT,'[string map {' _} [string trim $mom_isv_tool_description($i)]]'"
					set tdesc [string trim $mom_isv_tool_description($i)]
					append str ",'DESC',OUT,'${tdesc}'"
				}
				MOM_output_literal $str
			}
		}
	}
}

proc disp {var} {
global [subst $var]
	if {[info exists [subst $var]]} { MOM_output_literal "\$\$ $var=[subst $$var]" }
}

###############################################################################
proc MOM_start_of_path {} {
global mom_my_last_apply
global mom_my_this_apply
global mom_machine_mode
global mom_operation_type
global mom_path_name
global mom_my_this_apply
global mom_fixture_offset_value
global mom_update_post_cmds_from_tool
global mom_my_cutcom_adjust
global mom_my_optype
global mom_kin_machine_type
global mom_my_stock_tolerance
global mom_my_pocket_id
global mom_use_a_axis
global mom_tool_insert_position
global mom_tool_holder_angle_for_cutting
global mom_tool_tracking_point
global mom_spindle_maximum_rpm
global mom_turn_holder_hand
global mom_wire_cutcom_status
global mom_wire_cutcom_adjust_register
global mom_transformation_matrix
global mom_translation_vector
global mom_last_pos
global mom_layer_thickness
global mom_feed_cut_value
global mom_toolpath_time
global mom_toolpath_length
global mom_my_operation_time
global mom_my_load_tool_index
global mom_my_load_tool_marker
global buffering
global buffer_size
global buffer

global mom_tool_adjust_register
global mom_tool_adjust_reg_toggle
global mom_tool_adjust_register_defined
global mom_tool_length_adjust_register
global mom_tool_offset_defined
global mom_tool_z_offset_defined
global mom_tool_z_offset_toggle
global mom_tool_z_offset

global mom_length_comp_register
global mom_length_comp_register_defined
global spindle_retract_value
catch { unset spindle_retract_value }
global cycle_retract_feed_rate
catch { unset cycle_retract_feed_rate }
global spindle_retract_flag
set spindle_retract_flag 0
global cycle_retract_feed_rate_flag
set cycle_retract_feed_rate_flag 0
#disp mom_tool_length_adjust_register
#disp mom_tool_offset_defined

#disp mom_tool_adjust_reg_toggle
#disp mom_tool_adjust_register_defined
#disp mom_tool_adjust_register

#disp mom_tool_z_offset_defined
#disp mom_tool_z_offset_toggle
#disp mom_tool_z_offset

global has_last_tool_vector
	set has_last_tool_vector 0

	set buffering 0
	set buffer_size 0
	set mom_my_load_tool_index -1
	set mom_my_load_tool_marker 0

global mom_cycle_step1
global mom_cycle_step2
global mom_cycle_step3
	set mom_cycle_step1 0.0
	set mom_cycle_step2 0.0
	set mom_cycle_step3 0.0

	catch { unset mom_last_pos }
	reset_my_variables
global mom_my_optype
global mom_my_z_offset
	set mom_my_z_offset ""
	
global mom_operation_description	
global mom_my_tool_adjust_register
	set mom_my_tool_adjust_register ""
	if { [info exists mom_tool_adjust_register] && [info exists mom_tool_adjust_register_defined] && $mom_tool_adjust_register_defined == 1 } { 
		set mom_my_tool_adjust_register $mom_tool_adjust_register
	} 
	
	if {[info exists mom_tool_adjust_register_defined] && [info exists mom_tool_adjust_reg_toggle] \
	&& [info exists mom_tool_adjust_register] && $mom_tool_adjust_register_defined==1 && $mom_tool_adjust_reg_toggle==1} {
		set mom_my_z_offset "#1003:19/OSETNO,$mom_tool_adjust_register"
	}

	if {[info exists mom_tool_z_offset_defined] && [info exists mom_tool_z_offset_toggle] \
	&& [info exists mom_tool_z_offset] && $mom_tool_z_offset_defined==1 && $mom_tool_z_offset_toggle==1} {
		if {[string length $mom_my_z_offset] > 0} {
			append mom_my_z_offset ",LENGTH,[fm $mom_tool_z_offset]"
		} else {
			set mom_my_z_offset "#1003:19/LENGTH,[fm $mom_tool_z_offset]"
		}
	}

	if {[info exists mom_toolpath_time] && $mom_toolpath_time !=0 } {
		set h [expr int($mom_toolpath_time/60)]
		set m [expr int($mom_toolpath_time-$h*60)]
		set s [expr round(($mom_toolpath_time-$h*60-$m)*60)]
		if {$h<10} {set h "0$h"}
		if {$m<10} {set m "0$m"}
		if {$s<10} {set s "0$s"}
		set mom_my_operation_time "#1003:5/TIME,'$h:$m:$s'"
		if {[info exists mom_toolpath_length] && $mom_toolpath_length>0} {
			append mom_my_operation_time ",[fm $mom_toolpath_length]"
		}
		# append OPNAME for tool path description
		if { [info exists mom_operation_description] } {
			append mom_my_operation_time ",OPTYPE,'$mom_operation_description'"
		}
	} else {
		# append OPNAME for tool path description
		if { [info exists mom_operation_description] } {
			set mom_my_operation_time "#1003:5/OPTYPE,'$mom_operation_description'"
		}
	}

	if {$mom_machine_mode == "MILL"} {
		set mom_kin_machine_type "5_axis_head_table"
		set mom_my_this_apply "APPLY/MILL"
		set mom_my_optype OPTYPE/MILL
		set mom_operation_type [string toupper $mom_operation_type]
		if {[string first "ADDITIVE" $mom_operation_type] != -1} {
			set mom_my_optype OPTYPE/AM
			if { [info exists mom_layer_thickness] } { append mom_my_optype ",THICKD,$mom_layer_thickness" }
			#if { [info exists mom_feed_cut_value] } { append mom_my_optype ",'FEDRAT',[fm $mom_feed_cut_value]" }
		}
	} elseif {($mom_machine_mode == "TURN") || ($mom_machine_mode == "LATHE")} {
		set mom_kin_machine_type "lathe"
		set mom_my_this_apply "APPLY/TURN"
		set mom_my_optype OPTYPE/TURN
	} elseif {$mom_machine_mode == "DRILL"} {                                 
		set mom_operation_type [string toupper $mom_operation_type]
		if {[string first "CENTERLINE" $mom_operation_type] != -1} {
			set mom_kin_machine_type "lathe"
			set mom_my_this_apply "APPLY/TURN"
			set mom_my_optype OPTYPE/AXIAL
		} else {
			set mom_kin_machine_type "5_axis_head_table"
			set mom_my_this_apply "APPLY/MILL"
			set mom_my_optype OPTYPE/MILL
		}
	} elseif {$mom_machine_mode == "WEDM"} {
		set mom_my_this_apply ""
		set mom_my_optype ""
	} else {
		MOM_output_literal "\$\$ WARNING - MODE NOT RECOGNIZED: $mom_machine_mode"
		set mom_kin_machine_type "5_axis_head_table"
		set mom_my_this_apply "APPLY/MILL"
		set mom_my_optype OPTYPE/MILL
	}

	MOM_get_optype
	MOM_get_cutcom
	set mom_my_stock_tolerance [get_stock_tolerance]

	MOM_output_literal "$$ START-OF-PATH"
	# section 1: APPLY/OPTYPE
	if { $mom_my_this_apply != $mom_my_last_apply} {
		MOM_output_literal $mom_my_this_apply
		set mom_my_last_apply $mom_my_this_apply
	}

	# section 2: OPNAME
	MOM_output_literal "OPNAME/'$mom_path_name, CATEGORY: $mom_operation_type'"

	set mom_my_pocket_id [get_pocket_id]
	
	# section : UNITS (it was output already)
	output_units

	if { [info exists mom_transformation_matrix] && [info exists mom_translation_vector] } {
		set vx [fm $mom_transformation_matrix(0)],[fm $mom_transformation_matrix(1)],[fm $mom_transformation_matrix(2)]
		set vy [fm $mom_transformation_matrix(3)],[fm $mom_transformation_matrix(4)],[fm $mom_transformation_matrix(5)]
		set vz [fm $mom_transformation_matrix(6)],[fm $mom_transformation_matrix(7)],[fm $mom_transformation_matrix(8)]
		set vc [fm $mom_translation_vector(0)],[fm $mom_translation_vector(1)],[fm $mom_translation_vector(2)]
		MOM_output_literal "#1003:21/$vx,0,$vy,0,$vz,0,$vc,1"
	}

	# section 3: MSYS
	output_msys	
	MOM_get_ask_oper_csys

	# section 4: Output blank block (stock) if there's one defined
	output_blank_block
	
	set buffering 1
	set buffer_size 0

	if { [string length $mom_my_optype] == 0 && [string length $mom_my_z_offset] > 0 } {
		MOM_output_literal "\$\$ #$mom_my_z_offset"
	}
	
	# next: start event
}

###############################################################################
proc MOM_end_of_path {} {
global mom_max_cut_traverse
global mom_my_thread_cycle
global mom_delay_text
global mom_delay_text_defined
global mom_auxfun_text_defined
global mom_tool_text_defined
global mom_opstop_text_defined
global mom_stop_text_defined
global mom_spindle_text
global mom_auxfun_text
global mom_prefun_text
global mom_flush_text
global mom_tool_text
global mom_tool_preselect_text
global mom_user_defined_text
global mom_head_text
global mom_opstop_text
global mom_stop_text
global mom_rotation_text
global mom_coolant_text
global mom_origin_text
global mom_power_text ;# associated text
global mom_cutcom_text
global mom_opskip_text
global mom_tool_number
global mom_text
global mom_flush_tank_text
global mom_tool_point_angle
global mom_tool_point_length
global mom_tool_tip_length
global mom_my_load_tool_marker
global mom_my_load_tool_index
global mom_my_load_tool_order_flag
global has_last_tool_vector
global mom_tool_number_defined
global mom_last_deposition_width
global mom_last_deposition_height
global mom_my_last_am
global mom_my_optype

	if { [string first "OPTYPE/AM" $mom_my_optype] == 0 } {
		if { [info exist mom_my_last_am] && $mom_my_last_am == "AM/ON" } { MOM_output_literal "AM/OFF" }
	}

	# force a "#1003:18/OFF" record in case NX did not handled it properly
	if { $mom_my_thread_cycle != "OFF" } { MOM_output_literal "#1003:18/OFF" }

	# output buffer if it never get chance to output
	output_buffer

	# reset max_cut_traverse
	if {[info exists mom_max_cut_traverse]} {catch {unset mom_max_cut_traverse}}
	
	MOM_output_literal "$$ END-OF-PATH"

	if { $mom_my_load_tool_order_flag == 1 } {
		if { $mom_my_load_tool_marker != 1 && $mom_my_load_tool_index != -1 } {
			flush_buffer_load_tool
		}
	}
	flush_buffer

	set has_last_tool_vector 0

global Step_value1
global Step_value2
global Step_value3
	set Step_value1 0.0
	set Step_value2 0.0
	set Step_value3 0.0

	# unset certain variables
	catch {unset mom_opstop_text_defined}
	catch {unset mom_stop_text_defined}
	catch {unset mom_delay_text_defined}
	catch {unset mom_auxfun_text_defined}
	catch {unset mom_tool_text_defined}

	catch { unset mom_last_deposition_width }
	catch { unset mom_last_deposition_height }
	catch { unset mom_my_last_am }

	catch {unset mom_delay_text}
	catch {unset mom_spindle_text}
	catch {unset mom_tool_number}
	catch {unset mom_tool_number_defined}
	
	catch {unset mom_auxfun_text}
	catch {unset mom_prefun_text}
	catch {unset mom_flush_text}
	catch {unset mom_tool_text}
	catch {unset mom_tool_preselect_text}
	catch {unset mom_user_defined_text}
	catch {unset mom_head_text}
	catch {unset mom_opstop_text}
	catch {unset mom_stop_text}
	catch {unset mom_rotation_text}

	catch {unset mom_coolant_text}

	catch {unset mom_origin_text}
	catch {unset mom_power_text}
	catch {unset mom_cutcom_text}
	catch {unset mom_opskip_text}

	catch {unset mom_text}

	catch {unset mom_flush_tank_text}
	
	catch { unset mom_tool_point_angle }
	catch { unset mom_tool_point_length }
	catch { unset mom_tool_tip_length }
}

###############################################################################
proc MOM_gohome_move {} {
global mom_mcs_goto
	MOM_output_literal "GOHOME/[fm $mom_mcs_goto(0)],[fm $mom_mcs_goto(1)],[fm $mom_mcs_goto(2)]"
}

###############################################################################
proc MOM_cycle_off {} {
global mom_my_first_cycle_move
global mom_my_thread_cycle
	if { $mom_my_thread_cycle == "ON" } { 
		MOM_output_literal "#1003:18/OFF"
		set mom_my_thread_cycle "OFF"
	} else { 
		MOM_output_literal "CYCLE/OFF" 
	}
	set mom_my_first_cycle_move "YES"
global Step_value1
global Step_value2
global Step_value3
	set Step_value1 0.0
	set Step_value2 0.0
	set Step_value3 0.0
}

###############################################################################
proc MOM_csys {} {}
proc MOM_set_csys {} {}
proc MOM_msys {} {}
proc output_msys {} {
global mom_msys_origin
global mom_msys_matrix
	set msys0 [ffm $mom_msys_matrix(0)]
	set msys1 [ffm $mom_msys_matrix(1)]
	set msys3 [ffm $mom_msys_matrix(3)]
	set msys4 [ffm $mom_msys_matrix(4)]
	set msys6 [ffm $mom_msys_matrix(6)]
	set msys7 [ffm $mom_msys_matrix(7)]
	set orig0 [ffm $mom_msys_origin(0)]
	set orig1 [ffm $mom_msys_origin(1)]
	set orig2 [ffm $mom_msys_origin(2)]
	MOM_output_literal "MSYS/$orig0,$orig1,$orig2,$msys0,$msys3,$msys6,$msys1,$msys4,$msys7"
}

###############################################################################
proc MOM_set_modes {} {
global mom_parallel_to_axis
global mom_output_mode
global mom_arc_mode
global mom_feed_set_mode
global mom_cls_machine_mode
global mom_modes_text
	if {[output_user_text "\$\$ SET/MODE," mom_modes_text] == 0 } {
		if {[info exists mom_output_mode]} {
			if {$mom_output_mode == "ABSOLUTE"} {
			  set mom_output_mode "ABSOL"
			} else {
			  set mom_output_mode "INCR"
			}
		}
		if {[info exists mom_arc_mode]} { 
			if {$mom_arc_mode == "CIRCULAR"} { 
				set mom_arc_mode "LINCIR" 
			} else {
				set mom_arc_mode "LINEAR" 
			}
		}
		if {[info exists mom_feed_set_mode]} { if {$mom_feed_set_mode == "INVERSE"} { set mom_feed_set_mode "INVERS" } }
		if {[info exists mom_parallel_to_axis]} { if {$mom_parallel_to_axis == "VAXIS"} { set mom_parallel_to_axis "UAXIS" } }
		if {[info exists mom_cls_machine_mode]} {
			# Temporary fix - mom_machine_mode should not get set DRILL
			if {$mom_cls_machine_mode == "DRILL"} { catch {unset mom_cls_machine_mode} }
		}
		
		MOM_output_literal "\$\$ SET/MODE,$mom_output_mode,$mom_arc_mode,$mom_feed_set_mode,$mom_parallel_to_axis,$mom_cls_machine_mode"
	}
}

################################################################################
proc MOM_spindle_rpm {} { 
	output_spindle
}

################################################################################
proc MOM_spindle_css {} { 
	output_spindle 
}

################################################################################
proc MOM_spindle_off {} {
global mom_spindle_text
global mom_my_spindle_last
	if {[output_user_text "SPINDL/OFF," mom_spindle_text] != 1} { MOM_output_literal SPINDL/OFF }
	set mom_my_spindle_last SPINDL/OFF
}

################################################################################
proc MOM_spindle_orient {} {
}

################################################################################
proc MOM_auxfun {} {
global mom_auxfun
global mom_auxfun_text
global mom_auxfun_text_defined
	if {[output_user_text "AUXFUN/" mom_auxfun_text] == 0 } {
		set aux "AUXFUN/$mom_auxfun"
		if {$mom_auxfun_text_defined == 1 && $mom_auxfun_text != ""} { append aux ,$mom_auxfun_text }
		MOM_output_literal $aux
	}
}

################################################################################
proc MOM_prefun {} {
global mom_prefun
global mom_prefun_text
	if {[output_user_text "PREFUN/" mom_prefun_text] == 0 } {
		set str PREFUN/$mom_prefun
		if {[info exists mom_prefun_text] && $mom_prefun_text != ""} {append str ,$mom_prefun_text}
		MOM_output_literal $str
	}
}

################################################################################
proc MOM_dwell {} {	MOM_delay }
proc MOM_delay {} {
global mom_delay_mode
global mom_delay_text
global mom_delay_value
global mom_delay_revs
global mom_command_status
global mom_delay_text_defined
	if { [info exists mom_delay_text_defined] && $mom_delay_text_defined } { set mom_delay_text $mom_delay_text }
	if {[output_user_text "DELAY/" mom_delay_text] == 0 } {
		set delay_text ""
		if { [info exists mom_delay_text_defined] && $mom_delay_text_defined && $mom_delay_text != "" } { set delay_text ,$mom_delay_text }
		if {$mom_delay_mode == "SECONDS"} {
			MOM_output_literal "DELAY/[fm $mom_delay_value]$delay_text"
		} elseif {$mom_delay_mode == "REVOLUTIONS"} {
			MOM_output_literal "DELAY/REV,[fm $mom_delay_revs]$delay_text"
		} else {
			MOM_do_template delay
		}
	}
}

###############################################################################
proc MOM_flush {} {
global mom_flush_status
global mom_flush_guides		;# UPPER, LOWER, ALL(flushing nozzle guide)
global mom_flush_pressure	;# LOW, MEDIUM, HIGH, REGISTER
global mom_flush_register	;# flush pressure register number(integer)
global mom_flush_text		;# associated text
global mom_command_status
	if {$mom_command_status == "USER DEFINED" || $mom_command_status == "USER_DEFINED"} {
		if {[info exists mom_flush_text]} { MOM_output_literal FLUSH/$mom_flush_text }
	} else {
		if {$mom_flush_status == "ON"} {
			if {$mom_flush_guides == "NONE"} {
				MOM_suppress once Guides
			} else {
				MOM_force once Guides
			}

			if {$mom_flush_pressure == "NONE"} {
				MOM_suppress once Pressure
				MOM_suppress once Register
			} elseif {$mom_flush_pressure == "REGISTER"} {
				MOM_suppress once Pressure
				MOM_force once Register
			} else {
				MOM_force once Guides
				MOM_suppress once Register
			}
		} else {
			MOM_suppress once Guides
			MOM_suppress once Pressure
			MOM_suppress once Register
		}
		MOM_do_template flush
		catch { unset set mom_flush_text }
	}
}

###############################################################################
proc MOM_flush_tank {} {
global mom_flush_tank	;# IN(fill flushing tank), OUT(empty tank)
global mom_flush_tank_text ;# associated text
global mom_command_status
	if {[output_user_text "FLUSH/" mom_flush_tank_text] ==0} {
		MOM_do_template flush_tank
	}
}

###############################################################################
proc MOM_lock_axis {} { 
global mom_lock_axis
global mom_lock_axis_plane
global mom_lock_axis_value	
global mom_lock_axis_value_defined
	set LockAxis "SET/LOCK,'$mom_lock_axis',$mom_lock_axis_plane"
	if {[info exists mom_lock_axis_value_defined] && $mom_lock_axis_value_defined == 1 } {
		append LockAxis ",$mom_lock_axis_value" 
	}
	MOM_output_literal $LockAxis
}

###############################################################################
proc MOM_opskip_on {} {
global mom_opskip_text
global mom_command_status
	if {[output_user_text "OPSKIP/" mom_opskip_text] == 0} {
		if {[info exists mom_opskip_text]} {
			MOM_output_literal "OPSKIP/ON,$mom_opskip_text"
		} else {
			MOM_output_literal "OPSKIP/ON"
		}
	}
}

###############################################################################
proc MOM_opskip_off {} {
global mom_opskip_text
global mom_command_status
	if {[output_user_text "OPSKIP/" mom_opskip_text] == 0} {
		if {[info exists mom_opskip_text]} {
			MOM_output_literal "OPSKIP/OFF,$mom_opskip_text"
		} else {
			MOM_output_literal "OPSKIP/OFF"
		}
	}
}

###############################################################################
proc MOM_cycle_plane_change {} {}

###############################################################################
proc MOM_cutcom_on {} {
global mom_cutcom_status
global mom_cutcom_mode
global mom_cutcom_plane
global mom_cutcom_adjust_register
global mom_cutcom_text
global mom_cutter_data_output_indicator
	if {[output_user_text "CUTCOM/" mom_cutcom_text] == 0 } {
		if {[info exists mom_cutcom_plane] && $mom_cutcom_plane != "NONE"} {
			if {[info exists mom_cutcom_adjust_register]} {			
				if {$mom_cutcom_plane == "XZ"} {
					set cutcom CUTCOM/$mom_cutcom_mode,ZXPLAN,OSETNO,$mom_cutcom_adjust_register
				} else {
					set cutcom CUTCOM/$mom_cutcom_mode,${mom_cutcom_plane}PLAN,OSETNO,$mom_cutcom_adjust_register
				}
			} else {
				if {$mom_cutcom_plane == "XZ"} {
					set cutcom CUTCOM/$mom_cutcom_mode,ZXPLAN
				} else {
					set cutcom CUTCOM/$mom_cutcom_mode,${mom_cutcom_plane}PLAN
				}				
			}
		} else {
			if {[info exists mom_cutcom_adjust_register]} {
				set cutcom CUTCOM/$mom_cutcom_mode,OSETNO,$mom_cutcom_adjust_register
			} else {
				set cutcom CUTCOM/$mom_cutcom_mode
			}
		}
		MOM_output_literal $cutcom
		if {[info exists mom_cutter_data_output_indicator] && $mom_cutter_data_output_indicator == 1 } {
			MOM_output_literal #1003:3/CUTCOM,'CONTACT'
		}
	}
}

###############################################################################
proc MOM_cutcom_off {} { 
global mom_cutcom_text
	if {[output_user_text "CUTCOM/" mom_cutcom_text] == 0 } {
		MOM_output_literal CUTCOM/OFF 
	}
}

###############################################################################
proc MOM_power {} {
global mom_power_value ;# power value(EDM)
global mom_power_text ;# associated text
global mom_command_status
	if {[output_user_text "POWER/" mom_power_text] == 0}{
		if {[info exists mom_power_text]} {
			MOM_output_literal "POWER/[fm $mom_power_value],$mom_power_text"
		} else {
			MOM_output_literal "POWER/[fm $mom_power_value]"
		}
	}
}

###############################################################################
proc MOM_origin {} {
global mom_origin_text
global mom_origin
global mom_machine_mode
global mom_command_status
	if {[output_user_text "ORIGIN/" mom_origin_text] == 0 } {
		if {$mom_machine_mode == "TURN"} {
			set output_string "ORIGIN/[fm $mom_origin(0)],[fm $mom_origin(1)]"
		} else {
			set output_string "ORIGIN/[fm $mom_origin(0)],[fm $mom_origin(1)],[fm $mom_origin(2)]"
		}
		if {[info exists mom_origin_text]} {append output_string ,$mom_origin_text}
		MOM_output_literal $output_string
	}
}

###############################################################################
proc MOM_coolant_on {} {
global mom_coolant_mode
global mom_coolant_text
global mom_coolant_flow
global mom_coolant_text_defined
	if {[output_user_text "COOLNT/" mom_coolant_text] == 0 } {
		if {$mom_coolant_mode == "TAP"} {
			set mom_coolant_mode "TAPKUL"
		} elseif { $mom_coolant_mode == "" } {
			set mom_coolant_mode "ON" 
		}
		set command "COOLNT/$mom_coolant_mode"
		if { [info exists mom_coolant_flow] && $mom_coolant_flow != ""} {append command ,$mom_coolant_flow}
		if { [info exists mom_coolant_text_defined] && $mom_coolant_text_defined && [info exists mom_coolant_text] && $mom_coolant_text != ""} {append command ,$mom_coolant_text}
		MOM_output_literal $command
	}
}

###############################################################################
proc MOM_coolant_off {} {
global mom_coolant_mode
global mom_coolant_status
global mom_coolant_text
global mom_coolant_text_defined
	if {[output_user_text "COOLNT/" mom_coolant_text] == 0 } {
		set command "COOLNT/$mom_coolant_status"
		if { [info exists mom_coolant_text_defined] && $mom_coolant_text_defined && [info exists mom_coolant_text] && $mom_coolant_text != ""} {append command ,$mom_coolant_text}
		MOM_output_literal $command
	}
}

################################################################################
proc MOM_rotate {} {
global mom_rotation_mode
global mom_rotation_direction
global mom_rotation_reference_mode
global mom_rotation_text
global mom_command_status
global mom_rotate_axis_type
global mom_rotation_angle
global mom_rotation_angle_defined
global mom_rotation_text_defined

	if {[output_user_text "ROTATE/" mom_rotation_text] == 0} {
		set str ROTATE/$mom_rotate_axis_type
		if { [info exists mom_rotation_angle_defined] && $mom_rotation_angle_defined } { 
			if {$mom_rotation_mode == "NONE"} {
				append str ,[fm $mom_rotation_angle]
			} elseif {$mom_rotation_mode == "ATANGLE"} {
				append str ,ATANGL,[fm $mom_rotation_angle]
			} elseif {$mom_rotation_mode == "ABSOLUTE"} {
				append str ,ABSOL,[fm $mom_rotation_angle]
			} elseif {$mom_rotation_mode == "INCREMENTAL"} {
				append str ,INCR,[fm $mom_rotation_angle]
			}
		}
		if { [info exists mom_rotation_direction] && $mom_rotation_direction != "NONE"} { append str ,$mom_rotation_direction }
		if { [info exists mom_rotation_reference_mode] && $mom_rotation_reference_mode == "ON"} { append str ,ROTREF }
		if { [info exists mom_rotation_text_defined] && $mom_rotation_text_defined && [info exists mom_rotation_text] } { append str ,$mom_rotation_text }
		
		MOM_output_literal $str
	}
}

################################################################################
proc MOM_clamp {} {
global mom_clamp_status
global mom_clamp_text
global mom_command_status
global mom_clamp_axis
	if {[output_user_text "CLAMP/" mom_clamp_text] == 0 } {
		if {$mom_clamp_status == "ON" || $mom_clamp_status == "OFF"} {
			if {[info exists mom_clamp_text]} {
				MOM_output_literal CLAMP/$mom_clamp_status,$mom_clamp_text
			} else {
				MOM_output_literal CLAMP/$mom_clamp_status
			}
		} else {
			if {$mom_clamp_status == "AXISON"} {
				set mom_clamp_status "ON"
			} elseif {$mom_clamp_status == "AXISOFF"} {
				set mom_clamp_status "OFF"
			}
			if {[info exists mom_clamp_text]} {
				MOM_output_literal CLAMP/$mom_clamp_axis,$mom_clamp_status,$mom_clamp_text
			} else {
				MOM_output_literal CLAMP/$mom_clamp_axis,$mom_clamp_status
			}
		}
	}
}

################################################################################
proc MOM_stop {} {
global mom_stop_text
global mom_stop_text_defined
	if { [info exists mom_stop_text_defined] && $mom_stop_text_defined && [info exists mom_stop_text] && [string length $mom_stop_text] > 0 } {
		MOM_output_literal STOP/[string toupper $mom_stop_text]
	} else {
		MOM_output_literal STOP
	}
}

################################################################################
proc MOM_opstop {} {
global mom_opstop_text
global mom_opstop_text_defined
	if { [info exists mom_opstop_text_defined] && $mom_opstop_text_defined && [info exists mom_opstop_text] && [string length $mom_opstop_text] > 0} {
		MOM_output_literal OPSTOP/[string toupper $mom_opstop_text]
	} else {
		MOM_output_literal OPSTOP
	}
}

proc MOM_head {} {
global mom_command_status
global mom_head_name_defined
global mom_head_name
	if { [info exists mom_command_status] && $mom_command_status == "ACTIVE" } {
		if { [info exists mom_head_name_defined] && $mom_head_name_defined == 1 } {
			if { [info exists mom_head_name] && $mom_head_name != "" } { MOM_output_literal "HEAD/'$mom_head_name'" }
		}
	}
}

################################################################################
proc MOM_select_head {} {
global mom_head_type
global mom_my_tlhead
global mom_head_text
	if {[output_user_text "SELECT/HEAD," mom_head_text] == 0} {
		if {[info exists mom_head_type]} {
			if {$mom_head_type == "REAR"} {
				set mom_my_tlhead HEAD/1
			} elseif {$mom_head_type == "FRONT"} {
				set mom_my_tlhead HEAD/2
			} elseif {$mom_head_type == "RIGHT"} {
				set mom_my_tlhead HEAD/3
			} elseif {$mom_head_type == "LEFT"} {
				set mom_my_tlhead HEAD/4
			} elseif {$mom_head_type == "SIDE"} {
				set mom_my_tlhead HEAD/5
			} elseif {$mom_head_type == "SADDLE"} {
				set mom_my_tlhead HEAD/6
			} else {
				set mom_my_tlhead ""
				MOM_output_literal "\$\$ WARNING - HEAD SELECTION NOT RECOGNIZED"
			}
			MOM_output_literal $mom_my_tlhead
			set mom_my_tlhead ""
		}
	}
}

################################################################################
proc MOM_pprint {} {
global mom_pprint
	if {[info exists mom_pprint]} { MOM_output_literal PPRINT/$mom_pprint }
}

###############################################################################
proc MOM_length_compensation {} {
global mom_length_comp_register_text_defined
global mom_length_comp_register_text
global mom_overide_oper_param
global mom_tool_adjust_register
global mom_tool_length_adjust_register
global mom_length_comp_register
global mom_length_comp_register_defined
global mom_command_status
global mom_text

	if { [info exists mom_command_status] } {
		set LenComp ""
		if { $mom_command_status == "ACTIVE" } { 
			if { [info exists mom_overide_oper_param] && $mom_overide_oper_param == 1 } {
				set LenComp "CUTCOM/ON,LENGTH,$mom_length_comp_register" 
			} else {
				set LenComp "CUTCOM/ON,LENGTH,$mom_tool_length_adjust_register" 
			}
		}
		
		if { [info exists mom_length_comp_register_text_defined] && $mom_length_comp_register_text_defined == 1 } {
			if { $mom_length_comp_register_text != "" } { 
				if { $LenComp == "" } {
					set LenComp "CUTCOM/ON,'$mom_length_comp_register_text'" 
				} else {
					append LenComp ",'$mom_length_comp_register_text'" 
				}
			}
		}
		
		MOM_output_literal $LenComp
	}
}

###############################################################################
proc MOM_text {} {
global mom_user_defined_text
global mom_my_show_message
global mom_my_use_user_defined_partno
	if { [info exists mom_user_defined_text] } {
		set text [string toupper [string trim $mom_user_defined_text]]
		if { $mom_user_defined_text != "" } {
			if {$text != "FINI" } {
				if { $mom_my_use_user_defined_partno != 0 || ([string range $text 0 6] != "PARTNO/" && [string range $text 0 6] != "PARTNO ") } {
					if {$mom_my_show_message == 1} {MOM_output_literal "\$\$ WARNING - USER DEFINED TEXT"}
					MOM_output_literal $mom_user_defined_text
				}
			}
		}
	}
}

###############################################################################
proc MOM_translate {} {
global mom_user_defined_text
global mom_my_show_message
	if { [info exists mom_user_defined_text] && $mom_user_defined_text != "" } {
		if {$mom_my_show_message == 1} {MOM_output_literal "\$\$ WARNING - TRANSLATE USER DEFINED TEXT"}
		MOM_output_literal $mom_user_defined_text
	}
}

################################################################################
proc MOM_lintol {} {
global mom_user_defined_text
global mom_my_show_message
	if { [info exists mom_user_defined_text]} {
		if {$mom_my_show_message == 1} {MOM_output_literal "\$\$ WARNING - USER DEFINED LINTOL"}
		MOM_output_literal $mom_user_defined_text
	}
}

################################################################################
proc MOM_insert {} {
global mom_Instruction
	if {[info exists mom_Instruction]} { MOM_output_literal INSERT/$mom_Instruction }
}

###############################################################################
proc MOM_operator_message {} {
global mom_operator_message
global mom_operator_message_defined
	if {$mom_operator_message_defined == 1 && [info exists mom_operator_message] && $mom_operator_message != ""} {
		MOM_output_literal "DISPLY/[string toupper $mom_operator_message]"
		catch {unset mom_operator_message}
	}
}

###############################################################################
proc output_load_tool_buffer {} {
global mom_carrier_name
global mom_my_loadtl_did_output
global mom_my_loadtl
global mom_my_tlhead
global mom_my_tlname
global mom_my_tlpitch
global mom_my_cutter
global mom_my_catalog
global mom_my_tldesc
global mom_my_tlcutcom
global mom_my_parameters
global mom_my_parameters_count
global mom_my_holder
global mom_my_total_length
global mom_my_hdiscription
global mom_my_pocket_id
global mom_my_holder_offset
global mom_my_max_length 
global mom_cutter_description
global mom_tool_catalog_number
global mom_tool_coolant_through
global mom_my_load_tool_order_flag
global mom_my_load_tool_index
global mom_my_tracking_did_output
global mom_head_spindle_axis
global mom_head_gauge_point
global buffer_size
global mom_tool_tracking_point
global mom_tool_xmount
global mom_tool_ymount
global mom_feed_cut_value
global mom_feed_approach_value
global mom_feed_retract_value
global mom_head_name
global mom_turn_holder_hand
global mom_use_turn_holder

	if {$mom_my_loadtl_did_output != "YES"} {
		if {$mom_my_loadtl != ""} { 
			if {$mom_my_loadtl != "" || [is_turn_operation] == 1 && $mom_my_tracking_did_output != "YES" } { MOM_output_literal "OPTYPE/TOOL" }
			if {$mom_my_tlhead != ""} {MOM_output_literal $mom_my_tlhead}
			if {$mom_my_tlname != ""} {MOM_output_literal $mom_my_tlname}
			if {$mom_my_cutter != ""} {MOM_output_literal $mom_my_cutter}
			if {$mom_my_catalog != ""} {MOM_output_literal $mom_my_catalog}
			if {$mom_my_tldesc != ""} {MOM_output_literal $mom_my_tldesc}
			if {$mom_my_tlcutcom != ""} {MOM_output_literal $mom_my_tlcutcom}
		
			if {[info exists mom_carrier_name] && $mom_carrier_name != ""} { MOM_output_literal "#1003:19/'CARRIER',OUT,'$mom_carrier_name'" }

			set tool_parameter ""
			if {[info exists mom_my_parameters_count] && $mom_my_parameters_count > 0 } { 
				set tool_parameter "#1003:19/TOOL"
				for {set i 0} {$i<$mom_my_parameters_count} {incr i} {
					if {[info exists mom_my_parameters($i)]} {
						set str $mom_my_parameters($i)
						set len1 [string length $tool_parameter]
						set len2 [string length $str]
						set len [expr $len1+$len2+1]
						if {[expr $len-$mom_my_max_length] > 0} {
							MOM_output_literal "$tool_parameter$"
							set tool_parameter $str
						} else {
							append tool_parameter $str
						}
					}
				}
				
				# Outputting the turn holder side if it exists
				if {[info exists mom_use_turn_holder]} {
					if {$mom_use_turn_holder == "Yes"} {
						if {[info exists mom_turn_holder_hand]} {
							if { $mom_turn_holder_hand == 0 } { 
								append tool_parameter ",SIDE,LEFT"
							} else {
								append tool_parameter ",SIDE,RIGHT"
							}
						}
					}
				}
				
				MOM_output_literal $tool_parameter
			}

			set mom_my_parameters_count 0
			
			if {$mom_my_holder != ""} {MOM_output_literal $mom_my_holder}
			if {$mom_my_holder_offset != ""} {MOM_output_literal $mom_my_holder_offset}
			if {$mom_my_pocket_id != ""} {MOM_output_literal $mom_my_pocket_id}
			if {$mom_my_tlpitch != ""} {MOM_output_literal $mom_my_tlpitch}
			if {$mom_my_hdiscription != ""} {MOM_output_literal $mom_my_hdiscription}
			if {$mom_my_total_length != ""} {MOM_output_literal $mom_my_total_length}

			# G302 
			turn_tool_tracking_point
			
			# Output Tracking and Tool mounts
			if { [info exists mom_tool_tracking_point] && [info exists mom_tool_xmount] && [info exists mom_tool_ymount] } {
				MOM_output_literal "#1003:19/'PNUM',$mom_tool_tracking_point,'SIM',XOFF,$mom_tool_xmount,YOFF,$mom_tool_ymount"
			}
			

			# Head Spindle AXIS OFFSET/ORIENTATION
			if { [info exists mom_head_spindle_axis] && [info exists mom_head_gauge_point] } {
				if { $mom_head_gauge_point(0)!= 0 || $mom_head_gauge_point(1) != 0 ||  $mom_head_gauge_point(2)!= 0 || $mom_head_spindle_axis(0)!= 0 || $mom_head_spindle_axis(1)!= 0 || $mom_head_spindle_axis(2)!= 0 } {
				MOM_output_literal "#1003:19/HEAD,[fm $mom_head_gauge_point(0)],[fm $mom_head_gauge_point(1)],[fm $mom_head_gauge_point(2)],[fm $mom_head_spindle_axis(0)],[fm $mom_head_spindle_axis(1)],[fm $mom_head_spindle_axis(2)]"
				}
				if { [info exists mom_head_name] && $mom_head_name != "NONE" } {
				MOM_output_literal "#1003:19/HEAD,ID,'$mom_head_name'"
				}
			}
			
			# Output Feed cut, angle and retract value
			if { [info exists mom_feed_cut_value] && [info exists mom_feed_approach_value] && [info exists mom_feed_retract_value] } {
				MOM_output_literal "#1003:1009/CUTS,[fm $mom_feed_cut_value],FEDTO,[fm $mom_feed_approach_value],BACK,[fm $mom_feed_retract_value]"
			}

			# output Load/TOOL,
			MOM_output_literal $mom_my_loadtl
			
			# output tool associated coolant
			if { [info exists mom_tool_coolant_through] && $mom_tool_coolant_through == "Yes" } { MOM_output_literal "COOLNT/THRU" }
			
			set mom_my_load_tool_index $buffer_size
			set mom_my_loadtl_did_output "YES"
		} else {
			# G302 
			turn_tool_tracking_point
		}
	} 
}

###############################################################################
proc output_buffer {} {
global mom_my_buffer_did_output
global mom_my_optype
global mom_my_loadtl
global mom_my_z_offset
global mom_operation_type_enum
global mom_from_move_buffer
global mom_from_output_order_flag
global mom_my_loadtl_did_output
global mom_my_cutcom_adjust
global mom_my_deposition
global my_cutting_motion
global mom_my_operation_time
global mom_feed_per_tooth
global mom_surface_speed
global mom_output_unit
global mom_feed_cut_value
global mom_feed_approach_value
global mom_feed_retract_value

	output_load_tool_buffer
	if {$mom_my_buffer_did_output != "YES"} { 
		if {$mom_my_optype != ""} {
			if { [info exists mom_operation_type_enum] && $mom_operation_type_enum == 1100 } {
				# MOM_output_literal "\$\$ MILL MACHINE CONTROL"
				# MOM_output_literal $mom_my_optype 
			} elseif { [info exists mom_operation_type_enum] && $mom_operation_type_enum == 1200 } { 
				# MOM_output_literal "\$\$ LATHE MACHINE CONTROL"
				# MOM_output_literal $mom_my_optype 
			} else {
				# output OPTYPE after LOAD/TOOL,
				MOM_output_literal $mom_my_optype 
				# output extra tool length z offset if there's no load/tool
				if { [info exists mom_my_z_offset] && [string length $mom_my_z_offset]>0} {
					MOM_output_literal $mom_my_z_offset
				}
				
				if {[string first "OPTYPE/AM" $mom_my_optype] == 0 } {
					if { [info exists mom_my_deposition] && $mom_my_deposition != ""} {
						MOM_output_literal $mom_my_deposition
						set mom_my_deposition ""
					}
				}
				# output tool path time
				if {[info exists mom_my_operation_time] && $mom_my_operation_time != "" } {
					MOM_output_literal $mom_my_operation_time
				}
				
				# output tool path Feeds
				if {[info exists mom_feed_per_tooth] && [info exists mom_surface_speed] && [info exists mom_output_unit] } {
					if { $mom_output_unit == "MM" } {
						MOM_output_literal "#1003:3/FEED,'PER_TOOTH',MM,[fm $mom_feed_per_tooth],SPINDL,'SURFACE',SMM,[fm $mom_surface_speed]"
					} else {
						MOM_output_literal "#1003:3/FEED,'PER_TOOTH',INCHES,[fm $mom_feed_per_tooth],SPINDL,'SURFACE',SFM,[fm $mom_surface_speed]"
					}	
				}
				
				# Output Feed cut, angle and retract value
				if { [info exists mom_feed_cut_value] && [info exists mom_feed_approach_value] && [info exists mom_feed_retract_value] } {
					MOM_output_literal "#1003:1009/CUTS,[fm $mom_feed_cut_value],FEDTO,[fm $mom_feed_approach_value],BACK,[fm $mom_feed_retract_value]"
				}
				
			}
		}
		set mom_my_buffer_did_output "YES"

		# ouput spindle after OPTYPE and before others command
		if { [info exists my_cutting_motion] && $my_cutting_motion == 1 } {
			output_spindle
			output_cycle_retract_feed_rate
		}
		
		# cutcom need to be handled more precisely ???
		if { $mom_my_cutcom_adjust != "" } {
			MOM_output_literal $mom_my_cutcom_adjust
		}
	}
	#output_tolerance
}

###############################################################################
proc output_cycle_retract_feed_rate {} {
global cycle_retract_feed_rate_flag
	if { [info exists cycle_retract_feed_rate_flag] && $cycle_retract_feed_rate_flag == 0 } {
		MOM_output_literal "\$\$ ##1003:19/CYCLE,FEDOPT,"
	}
	set cycle_retract_feed_rate_flag 1
}

###############################################################################
proc output_spindle {} {
global mom_my_buffer_did_output
global mom_my_spindle
global mom_my_spindle_status
global mom_my_spindle_last
global mom_operation_type
global mom_force_spindl_after_optype
global mom_update_post_cmds_from_tool
global mom_spindle_mode
global mom_spindle_speed
global mom_spindle_rpm
global mom_spindle_direction
global mom_spindle_status
global mom_spindle_startup_status
global mom_spindle_text
global mom_spindle_text_defined
global mom_spindle_range
global mom_spindle_range_defined
global mom_my_optype
global mom_my_this_apply
global mom_spindle_preset_rpm_toggle
global mom_spindle_preset_rpm
global mom_spindle_maximum_rpm_defined
global mom_spindle_maximum_rpm
global mom_spindle_reverse
global mom_user_defined_text
global mom_command_status
global spindle_retract_flag

	set mom_my_spindle_status ""
	if { [info exists mom_spindle_startup_status] && $mom_spindle_startup_status == "UNKNOWN" } { 
		set mom_my_spindle_status "\$\$ SPINDLE_STARTUP_STATUS = UNKNOWN" 
	}
	
	if { $mom_command_status == "USER DEFINED" || $mom_command_status == "USER_DEFINED" } {
		if { [info exists mom_spindle_text] && $mom_spindle_text != "" } { set mom_my_spindle SPINDL/$mom_spindle_text }
	} else {
		set my_max_rpm 0
		set my_spindle_preset ""
		if {$mom_my_this_apply == "APPLY/TURN"} {
			if {[info exists mom_spindle_maximum_rpm_defined ] && $mom_spindle_maximum_rpm_defined == 1 && [info exists mom_spindle_maximum_rpm]} {
				if {[info exists mom_spindle_mode] && \
					($mom_spindle_mode == "RPM" && $mom_spindle_rpm > 0.0000001 || \
					($mom_spindle_mode == "SFM" || $mom_spindle_mode == "SMM") && $mom_spindle_speed > 0.0000001) } { 
					if {[info exists mom_spindle_rpm] && $mom_spindle_rpm > 0.0000001} { 
						set my_max_rpm $mom_spindle_maximum_rpm
					}
				}
			}
			if { [info exists mom_spindle_preset_rpm_toggle] && $mom_spindle_preset_rpm_toggle == 1 && [info exists mom_spindle_preset_rpm] && $mom_spindle_preset_rpm > 0.000001 } {
				set my_spindle_preset "#1003:19/'SPINDL_PRESET',SET,$mom_spindle_preset_rpm,RPM"
				if { $mom_spindle_direction != "NONE" } { append my_spindle_preset ",$mom_spindle_direction" }
			}
		}
		
		set my_range_rpm ""
		if {[info exists mom_spindle_range_defined] && $mom_spindle_range_defined == 1 && [info exists mom_spindle_range] && [string length $mom_spindle_range] != 0} {
			set my_range_rpm $mom_spindle_range
		}

		if {[info exists mom_spindle_reverse]} {
			set mom_spindle_mode "ON"
			set mom_my_spindle "SPINDL/$mom_spindle_mode"
		} else {
			if {$mom_spindle_mode == "RPM"} {
				if { $mom_spindle_rpm > 0 } { set mom_my_spindle "SPINDL/[fm $mom_spindle_rpm],$mom_spindle_mode" }
			} else {
				if { $mom_spindle_speed > 0 } { set mom_my_spindle "SPINDL/[fm $mom_spindle_speed],$mom_spindle_mode" }
			}
		}

		if { $mom_my_spindle != "" } {
			if { [info exists mom_spindle_direction] && $mom_spindle_direction != "NONE" } { append mom_my_spindle ",$mom_spindle_direction" }
			if { [info exists my_max_rpm] && $my_max_rpm > 0} { append mom_my_spindle ,MAXRPM,[fm $my_max_rpm] }
			if { [info exists my_range_rpm] && [string length $my_range_rpm] > 0} { append mom_my_spindle ,RANGE,$my_range_rpm }
			if { [info exists mom_spindle_text] && $mom_spindle_text != "" } { append mom_my_spindle ",$mom_spindle_text" }
		}
	}
	
	if { [info exists mom_force_spindl_after_optype] && $mom_force_spindl_after_optype == 1 && $mom_my_buffer_did_output != "YES"} { return }
	
	if { $mom_my_spindle != "" && $mom_my_spindle != $mom_my_spindle_last } {
		if { [info exists my_spindle_preset] && $my_spindle_preset != "" } { MOM_output_literal $my_spindle_preset }
		if { [info exists mom_operation_type] == 0 || $mom_operation_type != "Turn Teach Mode" } { 
			#MOM_output_literal $mom_my_spindle_status
			MOM_output_literal $mom_my_spindle 
			if { [info exists spindle_retract_flag] && $spindle_retract_flag == 0 } {
				MOM_output_literal "\$\$ ##1003:19/CYCLE,OUT,"
			}
			set spindle_retract_flag 1
			set mom_my_spindle_last $mom_my_spindle
		}
	}
}

###############################################################################
proc reset_my_variables {} {
global mom_my_buffer_did_output
global mom_my_loadtl_did_output
global mom_my_lintol_did_output
global mom_my_cycle_feed_rate_mode
global mom_my_loadtl
global mom_my_tlhead
global mom_my_tlname
global mom_my_tlpitch
global mom_my_cutter
global mom_my_tldesc
global mom_my_tlcutcom
global mom_my_catalog
global mom_my_holder
global mom_cycle_option
global mom_my_total_length
global mom_my_hdiscription
global mom_my_holder_offset
global mom_my_thread_cycle
global mom_my_spindle_last
global mom_my_spindle
global mom_my_spindle_status
global mom_my_pitch_did_output
global mom_my_tracking_did_output
global mom_my_parameters_count
global mom_my_goto_flag
global mom_my_deposition
global mom_command_status
global my_cutting_motion

	set my_cutting_motion 0
	set mom_command_status ""
	set mom_my_thread_cycle "OFF"
	set mom_my_pitch_did_output "NO"
	set mom_my_buffer_did_output "NO"
	set mom_my_loadtl_did_output "NO"
	set mom_my_lintol_did_output "NO"
	set mom_my_tracking_did_output "NO"
	
	if {[info exists mom_my_cycle_feed_rate_mode]} {unset mom_my_cycle_feed_rate_mode}
	if {[info exists mom_cycle_option]} {unset mom_cycle_option}
	set mom_my_parameters_count 0
	set mom_my_goto_flag 0
	
	set mom_my_deposition ""
	set mom_my_loadtl ""
	set mom_my_tlhead ""
	set mom_my_tlname ""
	set mom_my_tlpitch ""
	set mom_my_catalog ""
	set mom_my_tldesc ""
	set mom_my_tlcutcom ""
	set mom_my_total_length ""
	set mom_my_cutter ""
	set mom_my_holder ""
	set mom_my_spindle ""
	set mom_my_spindle_status ""
	set mom_my_spindle_last ""
	set mom_my_hdiscription ""
	set mom_my_holder_offset ""
}

###############################################################################
proc get_tool_list {} {
global mom_tool_name
global mom_tool_number
global mom_tool_description
global mom_my_tool_size
global mom_my_tool_list
	set description "EMPTY"
	if {[info exists mom_tool_description] && [string trim $mom_tool_description] != ""} {set description [string trim $mom_tool_description]}
	if {[info exists mom_tool_name] && [info exists mom_tool_number]} {
		set str "#1003:9/'TOOL',${mom_tool_number},TLNAME,'[string map {' _} [string trim $mom_tool_name]]',OUT,'[string map {' _} ${description}]'"
		set i 0
		while {$i < $mom_my_tool_size} {
			if {$mom_my_tool_list($i) == $str} {
				set i $mom_my_tool_size
			} else {
				incr i
			}
		}
		if {$i == $mom_my_tool_size} {
			set mom_my_tool_list($mom_my_tool_size) $str
			incr mom_my_tool_size
		}
	}
}

###############################################################################
proc MOM_get_optype {} {
global mom_oper_method
global mom_my_optype
global mom_template_subtype
	if {[info exists mom_oper_method]} { 
		if {[string first "TURN" $mom_oper_method] != -1 || [string first "LATHE" $mom_oper_method] != -1} {
			set mom_my_optype OPTYPE/TURN
			if {[string first "CENTERLINE" $mom_oper_method] != -1} {set mom_my_optype OPTYPE/AXIAL}
		} elseif {[string first "MILL" $mom_oper_method] != -1 } {
			set mom_my_optype OPTYPE/MILL
			if {[string first "AXIAL" $mom_oper_method] != -1} {set mom_my_optype OPTYPE/AXIAL}
		} elseif {[string first "DRILL" $mom_oper_method] != -1} {
			set mom_my_optype OPTYPE/AXIAL
		} elseif {[info exists mom_template_subtype] && [string first "DRILL" $mom_template_subtype] != -1} {
			set mom_my_optype OPTYPE/AXIAL
		}
	}
	if {[info exists mom_template_subtype] && [string first "PROBING" $mom_template_subtype] != -1} {set mom_my_optype OPTYPE/PROBE}
}

###############################################################################
proc get_stock_tolerance {} {
global mom_stock_blank
global mom_stock_check_geometry
global mom_stock_drive
global mom_stock_floor
global mom_stock_part
	set str ""
	if {[info exists mom_stock_blank] && [expr abs($mom_stock_blank)] > 0 } { append str "\n#1003:3/'BLANK',[fm $mom_stock_blank]" }
	if {[info exists mom_stock_check_geometry] && [expr abs($mom_stock_check_geometry)] > 0 } { append str "\n#1003:3/'CHECK',[fm $mom_stock_check_geometry]" }
	if {[info exists mom_stock_drive] && [expr abs($mom_stock_drive)] > 0 } { append str "\n#1003:3/'DRIVE',[fm $mom_stock_drive]" }
	if {[info exists mom_stock_floor] && [expr abs($mom_stock_floor)] > 0 } { append str "\n#1003:3/'FLOOR',[fm $mom_stock_floor]" }
	if {[info exists mom_stock_part] && [expr abs($mom_stock_part)] > 0 } { append str "\n#1003:3/'PART',[fm $mom_stock_part]" }
	return [string trimleft $str "\n"]
}

###############################################################################
proc output_tolerance {} {
global mom_my_lintol_did_output
global mom_my_stock_tolerance
global mom_inside_outside_tolerances
global mom_oper_method
	if {$mom_my_lintol_did_output != "YES" } {
		if {$mom_my_stock_tolerance != ""} {MOM_output_literal $mom_my_stock_tolerance}
		MOM_output_literal "#1003:3/IN,[fm [expr abs($mom_inside_outside_tolerances(0))]]"
		MOM_output_literal "#1003:3/OUT,[fm [expr abs($mom_inside_outside_tolerances(1))]]"
		set lintol [expr ((abs($mom_inside_outside_tolerances(0)) + abs($mom_inside_outside_tolerances(1)))/2)]
		if { [info exists mom_oper_method] } {
			MOM_output_literal "#1003:3/LINTOL,[fm $lintol],'METHOD',OUT,'$mom_oper_method'"
		} else {
			MOM_output_literal "#1003:3/LINTOL,[fm $lintol]"
		}
		set mom_my_lintol_did_output "YES"
	}
}

###############################################################################
proc get_pocket_id {} {
global mom_my_pocket_id
global mom_pocket_id
	if {[info exists mom_pocket_id] && $mom_pocket_id > 0 } { set mom_my_pocket_id "#1003:19/'MCT_POCKET',${mom_pocket_id}" }
}
	
###############################################################################
proc MOM_get_cutcom {} {
global mom_fixture_offset_value
global mom_my_cutcom_adjust
	set mom_my_cutcom_adjust ""
	if { [info exists mom_fixture_offset_value] && $mom_fixture_offset_value > 0 } {
		set mom_my_cutcom_adjust "CUTCOM/ON,ADJUST,$mom_fixture_offset_value"
	}
}

###############################################################################
proc is_turn_operation { } {
global mom_operation_type
global mom_operation_name
	if { [info exists mom_operation_type] } {
		set mom_operation_type [string toupper $mom_operation_type]
		# MOM_output_literal "\$\$ $mom_operation_type"
		if { [string first "TURN" $mom_operation_type] != -1 } { 
			if { [info exists mom_operation_name] && [string first "CENTERLINE" $mom_operation_name] != -1 } { return 0 }
			return 1;
		}
	}
	return 0
}

###############################################################################
proc fm { v } {
global mom_clsf_decimal_places
	if { [info exists v] != 1 } { return "" }
	set f "%-.${mom_clsf_decimal_places}f"
	set r [format $f $v]
	
	if {[string first . $r] != -1} {
		set r [string trimright $r 0]
		set r [string trimright $r .]
	}
	return $r
}

###############################################################################
proc ffm { v } {
	if { [info exists v] != 1 } { return "" }
	set f "%-.12f"
	set r [format $f $v]
	if { [string first . $r] != -1} {
		set r [string trimright $r 0]
		set r [string trimright $r .]
	}
	return $r
}

###############################################################################.
proc output_user_text { v1 v2 } {
	upvar $v2 text
global mom_command_status
	if {$mom_command_status == "USER DEFINED" || $mom_command_status == "USER_DEFINED"} {
		set str $v1
		if {[info exists text] } {
			set text [string trimright $text ","]
			if { $text != "" } { append str $text }
		}
		MOM_output_literal $str
		return 1
	}
	return 0
}

###############################################################################.
proc is_equal {s t} {
global mom_system_tolerance
	if { [expr abs($s - $t)] <= $mom_system_tolerance } { return 1 } else { return 0 }
}

###############################################################################
proc MOM_first_turret {} {
}

###############################################################################
proc MOM_first_tool {} {
	#MOM_output_literal "$$ First Tool"
	user_tool_change
}

###############################################################################
proc MOM_load_tool {} {
global mom_my_loadtl_did_output
global mom_my_load_tool_marker
	set mom_my_load_tool_marker 1
	set mom_my_loadtl_did_output "NO"
	# MOM_output_literal "\$\$ Load Tool Marker"
	user_tool_change
	output_load_tool_buffer
}

###############################################################################
proc MOM_tool_change {} {
global mom_my_loadtl_did_output
	set mom_my_loadtl_did_output "NO"
	MOM_output_literal "$$ Tool Change"
	user_tool_change
}

#proc MOM_turret_change {} {
#global mom_my_loadtl_did_output
#	set mom_my_loadtl_did_output "NO"
#	user_tool_change
#}

###############################################################################
proc MOM_mill_tool_change {} {
global mom_my_loadtl_did_output
	set mom_my_loadtl_did_output "NO"
	MOM_output_literal "$$ Mill Tool Change"
	user_tool_change
}

###############################################################################
proc MOM_lathe_tool_change {} {
global mom_my_loadtl_did_output
	set mom_my_loadtl_did_output "NO"
	MOM_output_literal "$$ Lathe Tool Change"
	user_tool_change
}

###############################################################################
proc MOM_probe_change {} {
global mom_my_loadtl_did_output
	set mom_my_loadtl_did_output "NO"
	MOM_output_literal "$$ Probe Tool Change"
	user_tool_change
}

###############################################################################
proc MOM_tool_preselect {} {
global mom_tool_preselect_text
global mom_tool_preselect_number
	if {[output_user_text "SELECT/TOOL," mom_tool_preselect_text] == 0} {
		if { [info exists mom_tool_preselect_number] } {
			set str SELECT/TOOL,$mom_tool_preselect_number
			if {[info exists mom_tool_preselect_text] && $mom_tool_preselect_text != "" } {	
				append str ,$mom_tool_preselect_text 
			}
			MOM_output_literal $str
		}
	}
}

###############################################################################
proc user_tool_change { } {
global mom_part_unit
global mom_output_unit 
global mom_out_angle_pos
global mom_my_this_apply
global mom_tool_radius
global mom_tool_angle
global mom_tool_type
global mom_tool_pitch
global mom_tool_adj_reg_defined
global mom_tool_adjust_register
global mom_tool_cutcom_register
global mom_tool_length
global mom_tool_nose_radius
global mom_tool_corner1_radius
global mom_tool_corner1_center_x
global mom_tool_corner1_center_y
global mom_tool_lower_corner_radius
global mom_tool_upper_corner_radius
global mom_tool_insert_width
global mom_tool_tip_angle
global mom_tool_tip_length
global mom_tool_taper_angle
global mom_tool_point_angle
global mom_tool_point_length
global mom_tool_diameter
global mom_tool_name
global mom_tool_description
global mom_tool_flute_length
global mom_holder_description
global mom_tool_holder_offset
global mom_tool_flutes_number
global mom_tool_tapered_shank_length
global mom_tool_tapered_shank_taper_length
global mom_tool_tapered_shank_diameter
global mom_tool_use_tapered_shank
global mom_tool_holder_overall_length

global mom_my_tlname
global mom_my_cutter
global mom_my_catalog
global mom_my_tldesc
global mom_my_tlcutcom
global mom_my_parameters
global mom_my_parameters_count
global mom_my_holder
global mom_my_loadtl
global mom_my_tlpitch
global mom_my_total_length

global mom_my_hdiscription
global mom_my_holder_offset
global mom_command_status
global mom_my_loadtl_did_output

global mom_tool_mach_radius_toggle
global mom_tool_mach_angle
global mom_tool_mach_radius
global mom_tool_shank_diameter
global mom_tool_barrel_radius
global mom_force_tracking_point_angle_radius
global mom_turn_holder_hand

global mom_operation_type
global mom_wire_guides_upper_plane
global mom_wire_guides_lower_plane

global mom_use_a_axis
global mom_tool_insert_position
global mom_tool_holder_angle_for_cutting
global mom_tool_tracking_point
global mom_spindle_maximum_rpm
global mom_tool_holder_num

global mom_tool_ug_subtype
global mom_tool_ug_type

global mom_length_comp_register
global mom_load_tool_number_defined
global mom_tool_adjust_reg_defined
global mom_load_tool_reg_toggle
global mom_tool_adjust_register_defined
global mom_tool_change_type
global mom_tool_holder
global mom_tool_holder_defined
global mom_tool_length_adjust_register
global mom_tool_mach_angle_toggle
global mom_tool_number_defined
global mom_tool_number
global mom_tool_offset # 3 elements
global mom_tool_offset_defined
global mom_tool_text
global mom_tool_text_defined
global mom_tool_x_offset
global mom_tool_x_offset_defined
global mom_tool_y_offset
global mom_tool_y_offset_defined
global mom_tool_z_offset
global mom_tool_z_offset_defined
global mom_tool_adjust_reg_toggle

global mom_tool_catalog_number
global mom_cutter_description
global has_last_tool_vector
global my_cutting_motion
	set my_cutting_motion 1

	set has_last_tool_vector 0
	if {[info exists mom_tool_number_defined] && $mom_tool_number_defined == 0} {
		if {$mom_tool_text_defined && $mom_tool_text != ""} {
			set mom_my_loadtl LOAD/TOOL,$mom_tool_text
		}
		return
	}

	#get_tool_list
	set tool_type [string toupper $mom_tool_type]
	set tlp [string range $tool_type 0 3]
	if {$mom_tool_type == "Milling Tool-Barrel"} {set tlp "BARR"}
	if {$mom_tool_type == "Milling Tool-T Cutter"} {set tlp "TCUT"}

	set mom_my_tlname "TLNAME/'$mom_tool_name'"

	if {[info exists mom_tool_catalog_number] && $mom_tool_catalog_number != ""} { 
		set mom_my_catalog "#1003:19/'CATALOG',OUT,'$mom_tool_catalog_number'" 
	}

	if {[info exists mom_cutter_description] && $mom_cutter_description != ""} {
		set mom_my_tldesc "#1003:19/'TLDESC',OUT,'$mom_cutter_description'"
	}

	if {[info exists mom_tool_cutcom_register]} {
		set mom_my_tlcutcom "#1003:19/'CUTCOM',$mom_tool_cutcom_register"
	}

	set taper_barrel 0
	if { [info exists mom_tool_ug_subtype] && $mom_tool_ug_subtype == 2 && [info exist mom_tool_ug_type] && $mom_tool_ug_type == 7 } {
		set taper_barrel 1
	}
	
	if {$tlp == "MILL" || $tlp == "BARR" || $tlp == "TCUT" || $tlp == "DRIL" || $tlp == "SPOT" || $tlp == "CHAM" || $tlp == "REAM" || $tlp == "TAP" } {
		if { $taper_barrel == 1 } {
			set mom_my_cutter "CUTTER/[fm $mom_tool_diameter]"
		} else {
			if { $tlp == "DRIL" || $tlp == "SPOT" || $tlp == "REAM" || $tlp == "TAP"} {
				set center_x 0.
				set center_y 0.
				set radius   0.
				set taper_angle  0. 
				set tip_angle [expr 90-((180 * $mom_tool_point_angle) / 3.14159265)/2]
			} elseif { $tlp == "MILL" || $tlp == "CHAM" } {
				set tip_angle $mom_tool_tip_angle
				set taper_angle $mom_tool_taper_angle
				set radius $mom_tool_corner1_radius
				set center_x $mom_tool_corner1_center_x
				set center_y $mom_tool_corner1_center_y
			} else {
				set tip_angle 0.
				set taper_angle 0.
				set radius $mom_tool_lower_corner_radius
				set center_x 0.
				set center_y 0.
			}
			set e [expr $mom_tool_diameter / 2 - $radius]
			set mom_my_cutter "CUTTER/[fm $mom_tool_diameter],[fm $radius],[fm $e],[fm $radius],[fm $tip_angle],[fm $taper_angle],[fm $mom_tool_flute_length]"
		}
	} elseif {$tlp == "GROO" } {
		if { [info exists mom_tool_insert_width] && $mom_tool_insert_width > 0 } { set mom_my_cutter CUTTER/[fm $mom_tool_insert_width] }
	} elseif { $tlp == "TURN" } {
		set mom_my_cutter CUTTER/[fm $mom_tool_nose_radius]
	} elseif { $tlp == "THRE" } {
		if { $mom_operation_type == "Turn Threading" } {
			set mom_my_cutter CUTTER/[fm $mom_tool_nose_radius]
		} else {
			set mom_my_cutter CUTTER/[fm $mom_tool_diameter]
		}
	} elseif { $tlp == "PROB" } {
		set mom_my_cutter "#1003:19/PROBE"
		if {[info exists mom_tool_diameter] && $mom_tool_diameter > 0 } {append mom_my_cutter ,DIAMET,[fm $mom_tool_diameter]}
		if {[info exists mom_tool_flute_length] && $mom_tool_flute_length > 0 } {append mom_my_cutter ,LENGTH,[fm $mom_tool_flute_length]}
	} elseif {$mom_tool_type == "UNDEFINED" } {
		#set mom_my_cutter CUTTER/'UNDEFINED'
	} elseif {$tlp == "WIRE" } {
		set mom_my_cutter "CUTTER/[fm $mom_tool_diameter]\nPIVOTZ/[fm $mom_wire_guides_upper_plane],[fm $mom_wire_guides_lower_plane]"
	} elseif { $mom_tool_type == "Material Extruder" } {
		set mom_my_cutter "#1003:26/'EXTRUDER',OUT"
		extruder_parameters mom_my_cutter
	} else {
		set mom_my_cutter "\$\$ $mom_tool_type is not an expected tool type"
	}

	if {$tlp == "WIRE" } {
		if { $mom_tool_number > 0 } {
			if { $mom_tool_adj_reg_defined == 1 && [string trim $mom_tool_length_adjust_register] != ""} {
				MOM_output_literal LOAD/WIRE,$mom_tool_number,OSETNO,$mom_tool_length_adjust_register
			} elseif {[string trim $mom_length_comp_register] != ""} {
				MOM_output_literal LOAD/WIRE,$mom_tool_number,OSETNO,$mom_length_comp_register
			}
		} else {
			MOM_output_literal LOAD/WIRE
		}
	} else {
		# load tool
		set mom_my_loadtl LOAD/TOOL,$mom_tool_number
		if { [info exists mom_tool_change_type] && $mom_tool_change_type == "MANUAL" } {
			append mom_my_loadtl ,MANUAL
		} 

		if { $mom_tool_adj_reg_defined == 1 && $mom_tool_length_adjust_register != ""} {
			append mom_my_loadtl ,OSETNO,$mom_tool_length_adjust_register
		} elseif { $mom_length_comp_register != ""} {
			append mom_my_loadtl ,OSETNO,$mom_length_comp_register
		}
		
		if { $mom_my_this_apply == "APPLY/TURN" } {
			if { $mom_force_tracking_point_angle_radius ==1 && [info exists mom_tool_mach_angle_toggle] && [info exists mom_tool_mach_radius_toggle]} {
				if { $mom_tool_mach_angle_toggle == 1 && $mom_tool_mach_radius_toggle == 1 } {
					# same as CLSF STANDARD (standard was wrong)
					#append mom_my_loadtl ,TLANGL,[fm $mom_tool_angle]
					#append mom_my_loadtl ,RADIUS,[fm $mom_tool_radius] 
					# using mach_angle & mach_radius
					set angle [expr $mom_tool_mach_angle * 45 / atan(1)]
					if { $angle!=0 || $mom_tool_mach_radius!=0 } {
						append mom_my_loadtl ,TLANGL,[fm $angle],RADIUS,[fm $mom_tool_mach_radius] 
					}
				}
			}
		}
		if { [info exists mom_tool_z_offset_defined] && $mom_tool_z_offset_defined == 1 } {
			if {[info exists mom_tool_z_offset] } {
				append mom_my_loadtl ,LENGTH,[fm $mom_tool_z_offset]
			}
		}

		if { [info exists mom_tool_holder_num] && $mom_tool_holder_num > 0 } { append mom_my_loadtl ",HOLDER,$mom_tool_holder_num" }
		catch {unset mom_tool_holder_num}
	}

	# load tool user defined
	if { $mom_tool_text_defined && [info exists mom_tool_text] && $mom_tool_text != ""} { append mom_my_loadtl ,$mom_tool_text }
	
	if { [info exists mom_tool_pitch] && $mom_tool_pitch > 0 } {
		set pitch $mom_tool_pitch
		if { [info exists mom_output_unit] && [info exists mom_part_unit] } {
			if { $mom_output_unit == "MM" && $mom_part_unit == "IN" } {
				set pitch [expr $mom_tool_pitch * 25.4]
			} elseif { $mom_output_unit == "IN" && $mom_part_unit == "MM" } {
				set pitch [expr $mom_tool_pitch / 25.4]
			}
		}
		set mom_my_tlpitch "#1003:19/'PITCH',[fm $pitch]"
	}

	if {[info exists mom_tool_holder_offset] && $mom_tool_holder_offset > 0 } { set mom_my_holder_offset "#1003:19/'HOLDER_OFFSET',[fm $mom_tool_holder_offset]" }
	if {[info exists mom_holder_description] && [string length $mom_holder_description] > 0 } { set mom_my_hdiscription "#1003:19/'HOLDER_DESC',OUT,'$mom_holder_description'" }
	if {[info exists mom_tool_holder_overall_length]} {set mom_my_total_length "#1003:19/'GAGE',[fm [expr $mom_tool_length + $mom_tool_holder_overall_length]]"}
	
	set mom_my_parameters_count 0
	if {[info exists mom_tool_diameter]} {TLDESC ",'D',[fm $mom_tool_diameter]"}

	if {[info exists mom_tool_lower_corner_radius]} {
		TLDESC ",'R1',[fm $mom_tool_lower_corner_radius]"
	} elseif {[info exists mom_tool_corner1_radius]} {
		TLDESC ",'R1',[fm $mom_tool_corner1_radius]"
	}

	if { $taper_barrel == 1 } {
		if {[info exists mom_tool_upper_corner_radius]} {TLDESC ",'R2',[fm $mom_tool_upper_corner_radius]"}
		if {[info exists mom_tool_shank_diameter]} {TLDESC ",'ND',[fm $mom_tool_shank_diameter]"}
		if {[info exists mom_tool_barrel_radius]} {TLDESC ",'R',[fm $mom_tool_barrel_radius]"}
	} else {
		if {[info exists mom_tool_taper_angle]} {TLDESC ",'B',[fm $mom_tool_taper_angle]"}
		if {[info exists mom_tool_tip_angle]} {TLDESC ",'A',[fm $mom_tool_tip_angle]"}
	}
	
	if {[info exists mom_tool_length]} {TLDESC ",'L',[fm $mom_tool_length]"}
	if {[info exists mom_tool_flute_length]} {TLDESC ",'FL',[fm $mom_tool_flute_length]"}

	if {[info exists mom_tool_flutes_number]} {TLDESC ",'FLUTES',[fm $mom_tool_flutes_number]"}
	if {[info exists mom_tool_point_angle]} {TLDESC ",'PA',[fm $mom_tool_point_angle]"}
	if {[info exists mom_tool_point_length]} {TLDESC ",'PL',[fm $mom_tool_point_length]"}
	if {[info exists mom_tool_tip_length]} {TLDESC ",'TL',[fm $mom_tool_tip_length]"}
	if {[info exists mom_tool_pitch]} {TLDESC ",'P',[fm $mom_tool_pitch]"}
	
	#SHANK
	if {[info exists mom_tool_use_tapered_shank] && $mom_tool_use_tapered_shank == "Yes" } {
		if {[info exists mom_tool_tapered_shank_diameter] } {TLDESC ",'SD',[fm $mom_tool_tapered_shank_diameter]"}
		if {[info exists mom_tool_tapered_shank_length] } {TLDESC ",'SL',[fm $mom_tool_tapered_shank_length]"}
		if {[info exists mom_tool_tapered_shank_taper_length]} {TLDESC ",'STL',[fm $mom_tool_tapered_shank_taper_length]"}
	}
	
	if { $mom_my_parameters_count > 0 } { TLDESC ",TYPE,'$mom_tool_type'" }

	if {[info exists mom_tool_holder_overall_length] && $mom_tool_holder_overall_length > 0 } {
		set value $mom_tool_holder_overall_length
		if { [info exists mom_output_unit] && [info exists mom_part_unit] } {
			if { $mom_output_unit == "MM" && $mom_part_unit == "IN" } {
				set value [expr $mom_tool_holder_overall_length * 25.4]
			} elseif { $mom_output_unit == "IN" && $mom_part_unit == "MM" } {
				set value [expr $mom_tool_holder_overall_length / 25.4]
			}
		}
		set mom_my_holder "#1003:19/'HOLDER_LENGTH',[fm $value]"
	}

	if {[info exists mom_command_status] && $mom_command_status == "USER_DEFINED" } {
		if {$mom_tool_text_defined && $mom_tool_text != ""} {
			set mom_my_loadtl LOAD/TOOL,$mom_tool_text
		}
	}

	# output_load_tool_buffer
}

proc extruder_parameters { v } {
upvar $v extruder

global mom_tool_length
global mom_tool_diameter
global mom_tool_tapered_shank_diameter
global mom_tool_tapered_shank_length

global mom_tool_tapered_shank_taper_length

global mom_laser_nozzle_tip_diameter
global mom_nozzle_orifice_diameter

global mom_min_bead_height
global mom_max_bead_height
global mom_min_bead_width
global mom_max_bead_width
global mom_min_extrusion_rate
global mom_max_extrusion_rate
	# Extruder Properties
	if { [info exists mom_tool_length ] } { append extruder ",'SD',$mom_tool_length" }
	if { [info exists mom_tool_diameter ] } { append extruder ",'ED',$mom_tool_diameter" }
    # Nozzle Dimensions
	if { [info exists mom_tool_tapered_shank_diameter ] } { append extruder ",'ND',$mom_tool_tapered_shank_diameter" }
	if { [info exists mom_tool_tapered_shank_length ] } { append extruder ",'NL',$mom_tool_tapered_shank_length" }
	if { [info exists mom_laser_nozzle_tip_diameter ] } { append extruder ",'NTD',$mom_laser_nozzle_tip_diameter" }
	if { [info exists mom_tool_tapered_shank_taper_length ] } { append extruder ",'NTL',$mom_tool_tapered_shank_taper_length" }
	if { [info exists mom_nozzle_orifice_diameter ] } { append extruder ",'NOD',$mom_nozzle_orifice_diameter" }
    # Extrusion Settings
	if { [info exists mom_min_bead_width] && [info exists mom_max_bead_width] } { append extruder ",'BW',$mom_min_bead_width,$mom_max_bead_width" }
	if { [info exists mom_min_bead_height] && [info exists mom_max_bead_height] } { append extruder ",'BH',$mom_min_bead_height,$mom_max_bead_height" }
	if { [info exists mom_min_extrusion_rate] && [info exists mom_max_extrusion_rate] } { append extruder ",'ER',$mom_min_extrusion_rate,$mom_max_extrusion_rate" }
}

proc TLDESC { value } {
global mom_my_parameters
global mom_my_parameters_count
	set mom_my_parameters($mom_my_parameters_count) $value
	incr mom_my_parameters_count
}

###############################################################################
proc MOM_tracking_point_change {} {
global mom_tool_offset
global mom_tool_adjust_register_defined
global mom_tool_adjust_register
global mom_tool_x_offset_defined
global mom_tool_y_offset_defined
global mom_tool_z_offset_defined
global mom_tracking_point_name
global mom_my_tool_adjust_register

    set ofstno ""
    if { [info exists mom_tool_adjust_register_defined] && [info exists mom_tool_adjust_register] && $mom_tool_adjust_register_defined == 1 } {
		set ofstno "OFSTNO/$mom_tool_adjust_register"
    } elseif { [info exists mom_my_tool_adjust_register] && $mom_my_tool_adjust_register != "" } {
		set ofstno "OFSTNO/$mom_my_tool_adjust_register"
	}

	if { $ofstno != "" } {
		if { [info exists mom_tool_x_offset_defined] && [info exists mom_tool_offset] && $mom_tool_x_offset_defined == 1 } {
			append ofstno ",XOFF,[fm $mom_tool_offset(0)]"
		} 

		if { [info exists mom_tool_y_offset_defined] && [info exists mom_tool_offset] && $mom_tool_y_offset_defined == 1 } {
			append ofstno ",YOFF,[fm $mom_tool_offset(1)]"
		} 

		if { [info exists mom_tool_z_offset_defined] && [info exists mom_tool_offset] && $mom_tool_z_offset_defined == 1 } {
			append ofstno ",ZOFF,[fm $mom_tool_offset(2)]"
		}
	
		MOM_output_literal $ofstno
	}
}

###############################################################################
proc turn_tool_tracking_point {} {
global mom_tool_tracking_point
global mom_tool_insert_position
global mom_tool_holder_angle_for_cutting
global mom_tool_text
global mom_tool_side
global mom_tool_type
global mom_tool_orient_angle
global mom_tool_insert_angle
global mom_tool_nose_angle
global mom_tool_orientation
global mom_tool_holder_orient_angle
global mom_lathe_spindle_axis
global mom_operation_type
global mom_spindle_direction
global mom_turn_holder_hand
global mom_tracking_point_radius_id
global mom_my_tracking_did_output
global mom_flip_a_axis
global mom_use_a_axis
global mom_use_b_axis
global mom_system_template_subtype
global mom_template_subtype
global mom_spindle_maximum_rpm
global mom_length_comp_register
global mom_tool_text_defined
global DueZero

	if { $mom_my_tracking_did_output == "YES" } { return }
	
	if { [is_turn_operation] != 1 } { return }

	if { [info exists DueZero] } {
		# Output holder hand SIDE 0=left 2=right
		# Output holder flip ORIENT 0=no flip 1=flip
		# Output position tool insert UP 1=topside, 2=downside
		if { [info exists mom_turn_holder_hand] } {
			if { $mom_turn_holder_hand == 0 } { 
				MOM_output_literal SET/TURN,SIDE,LEFT,ORIENT,$mom_use_a_axis,UP,$mom_tool_insert_position 
			} else {
				MOM_output_literal SET/TURN,SIDE,RIGHT,ORIENT,$mom_use_a_axis,UP,$mom_tool_insert_position
			}
		}

		# Output Point OUT da 1 a 9
		# Angle A Tilting Head ANGLE trasform from radians to degrees
		if { [info exists mom_tool_tracking_point] } { MOM_output_literal SET/TURN,OUT,$mom_tool_tracking_point }

		# Output Osetno to verify if change
		if { [info exists mom_length_comp_register] } { MOM_output_literal SET/TURN,OSETNO,$mom_length_comp_register }

		# Output Spindle MAXRPM
		if { [info exists mom_spindle_maximum_rpm] } { MOM_output_literal SET/TURN,MAXRPM,[format "%-.2f" $mom_spindle_maximum_rpm] }
	}
	
	# trans factor
	set pi [expr 180/acos(-1)]
	
	# Cut Angle (exists)
	set cut_angle 0
	if { [info exists mom_use_b_axis] && $mom_use_b_axis == 1 } {
		set cut_angle [ffm [expr $mom_tool_holder_angle_for_cutting*$pi]]
	} elseif { [info exists mom_tool_holder_orient_angle] } {
		set cut_angle [ffm [expr $mom_tool_holder_orient_angle*$pi]]
	}
	
	if { [info exists DueZero] } { MOM_output_literal SET/TURN,ANGLE,$cut_angle }

	# tool type
	set tool_type [string range [string toupper $mom_tool_type] 0 3]

	# insert internal angle
	set nose_angle 0
	# groove corner indicator: not a groove tool if it's 0 (expect 1,2 if it's a groove tool)
	set groove_id 0
	if { $tool_type == "TURN" } {
		if { [info exists mom_tool_nose_angle] } { set nose_angle [expr $mom_tool_nose_angle*$pi] }
	} elseif { $tool_type == "GROO" } {
		set groove_id $mom_tracking_point_radius_id
		if { [info exist mom_system_template_subtype] } {
			set groove_od [string trim $mom_system_template_subtype]
			if { [string length $groove_od] == 0 } {
				MOM_output_literal "#1003:8/GROOVE,'$mom_template_subtype',ID,$groove_id,TYPE,'$mom_tool_type'"
			} else {
				MOM_output_literal "#1003:8/GROOVE,'$groove_od',ID,$groove_id,TYPE,'$mom_tool_type'"
			}
		}
	} elseif { $tool_type == "THRE" } {
		if { $mom_operation_type == "Turn Threading" } { 
			if { [info exists mom_tool_nose_angle] } { set nose_angle [expr $mom_tool_nose_angle*$pi] }
		} 
	}

	#insert orientation
	set nose_orient 0
	if { [info exists mom_tool_orientation] } {
		set nose_orient [ffm [expr $mom_tool_orientation*$pi]]
	}
	
	#Holder orientation
	set hld_orient 0
	if { [info exists mom_tool_holder_orient_angle] } {
		set hld_orient [ffm [expr $mom_tool_holder_orient_angle*$pi]]
	}
	
	# information
	if { [info exists mom_tracking_point_radius_id] && [info exists mom_tool_tracking_point] } {
		set turn_info "#1003:19/ID,$mom_tracking_point_radius_id,OSETNO,$mom_tool_tracking_point"

		# tool flip status
		set flip 0
		if { [info exists mom_flip_a_axis] && $mom_flip_a_axis != 0 } { 
			set flip 1
			append turn_info ,INVERS
		}
	
		# tool orient angle
		if { [info exists mom_tool_orient_angle] } { append turn_info ,ATANGL,[expr 180*$mom_tool_orient_angle/acos(-1)] }
	
		append turn_info ,'$tool_type'
		append turn_info ,$nose_angle,$nose_orient,$hld_orient,$cut_angle

		#O orientation index
		if { [info exists mom_tracking_point_radius_id] } {
			if { $groove_id == 1 || $groove_id == 2 } {
				append turn_info ,ORIENT,[G302G]
			} elseif { $groove_id == 0 } {
				append turn_info ,ORIENT,[G302O $nose_angle $nose_orient $hld_orient $cut_angle $flip]
			}
		}
		
		if { $mom_tool_text_defined && [info exists mom_tool_text] && $mom_tool_text != "" } { append turn_info ,$mom_tool_text }
		if { $mom_my_tracking_did_output != "YES" } { MOM_output_literal $turn_info }
	}
	
	set mom_my_tracking_did_output "YES"
}

###############################################################################
# catch ID / OD / FACE
# tool type (standard, full nose, ...)
# holder angle
# tool orient angle
# overwrite angle, flip
#
proc G302G {} {
global mom_tool_insert_type
global mom_turn_holder_hand
global mom_tool_type
global mom_tracking_point_radius_id
global mom_flip_a_axis
global mom_system_template_subtype
global mom_template_subtype
	#MOM_output_literal "system_subtype: $mom_system_template_subtype"
	#MOM_output_literal "subtype: $mom_template_subtype"
	
	if {[info exists mom_system_template_subtype]} {
		set groove_od [string trim $mom_system_template_subtype]

		if { [string range $mom_system_template_subtype 0 8] == "ID_GROOVE" || [string length $groove_od] == 0 && $mom_template_subtype == "GROOVE_ID" } {
			if { $mom_tracking_point_radius_id == 1 } {
				if { [info exists mom_flip_a_axis] && $mom_flip_a_axis != 0 } { 
					return 1
				} else {
					return 7
				}
			} else {
				if { [info exists mom_flip_a_axis] && $mom_flip_a_axis != 0 } { 
					return 3
				} else {
					return 5
				}
			}
		} else {
			if { $mom_tracking_point_radius_id == 1 } {
				if { [info exists mom_flip_a_axis] && $mom_flip_a_axis != 0 } { 
					return 7
				} else {
					return 1
				}
			} else {
				if { [info exists mom_flip_a_axis] && $mom_flip_a_axis != 0 } { 
					return 7
				} else {
					return 1
				}
			}
		}
	}
}

###############################################################################
proc G302O { nose_angle nose_orient hld_orient cut_angle flip } {
	set epslon 0.00000000001
	# calculate initial insert angle, convert to veritcal position
	# ignore holder orientation -->> a
	set b [expr $nose_angle*0.5+$nose_orient]
	# rotate holder to up-straight (0 degree) -->> b
	set a [expr $b-$hld_orient]
	set a [expr $a+$cut_angle]

	while { $a < 0 } { set a [expr $a+360] }
	
	set a [expr fmod($a,360)]
	
	set oa ""
	if { $a > $epslon && [expr 90-$a] > $epslon } {
		set oa 1
	} elseif { [expr abs(90-$a)] < $epslon } {
		set oa 2
	} elseif { [expr $a-90] > $epslon && [expr 180-$a] > $epslon } {
		set oa 3
	} elseif { $a <= 180 && [expr $a-180] < $epslon } {
		set oa 4
	} elseif { [expr $a-180] > $epslon && [expr 270-$a] > $epslon } {
		set oa 5
	} elseif { [expr abs($a-270)] < $epslon } {
		set oa 6
	} elseif { [expr $a-270] > $epslon && [expr 360-$a] > $epslon } {
		set oa 7
	} elseif { [expr abs($a-360)] < $epslon || [expr abs($a)] < $epslon } {
		set oa 8
	}

	set out ""
	if { $oa != "" } {
		set out $oa
		if { $flip == 1 } { 
			set c [expr $a-$cut_angle]
			while { $c < 0 } { set c [expr $c+360] }
			set c [expr fmod($c,360)]
			if { $c > 180 } {
				set d [expr $cut_angle+360-$c]
			} else {
				set d [expr $cut_angle-$c]
			}
			while { $d < 0 } { set d [expr $d+360] }
			set d [expr fmod($d,360)]
			set ob ""
			if { $d > $epslon && [expr 90-$d] > $epslon } {
				set ob 1
			} elseif { [expr abs(90-$d)] < $epslon } {
				set ob 2
			} elseif { [expr $d-90] > $epslon && [expr 180-$d] > $epslon } {
				set ob 3
			} elseif { $d <= 180 && [expr $d-180] < $epslon } {
				set ob 4
			} elseif { [expr $d-180] > $epslon && [expr 270-$d] > $epslon } {
				set ob 5
			} elseif { [expr abs($d-270)] < $epslon } {
				set ob 6
			} elseif { [expr $d-270] > $epslon && [expr 360-$d] > $epslon } {
				set ob 7
			} elseif { [expr abs($d-360)] < $epslon || [expr abs($d)] < $epslon } {
				set ob 8
			}
			set out $ob
		}
	}
	return $out
}

###############################################################################
proc set_deposition_parameters { } {
global mom_deposition_on_stepover
global mom_my_deposition
global mom_my_optype

	if {[string first "OPTYPE/AM" $mom_my_optype] == 0 } {
		set mom_my_deposition "#1003:26/AM"
		if { [info exists mom_deposition_on_stepover] } { 
			if { $mom_deposition_on_stepover == 0 } {
				append mom_my_deposition ",'DEPO_ON_STEPOVER',OFF" 
			} else {
				append mom_my_deposition ",'DEPO_ON_STEPOVER',ON" 
			}
		}
	}
}


###############################################################################
proc MOM_initial_move {} {
global mom_motion_type
global mom_my_first_cycle_move
global my_cutting_motion
	set my_cutting_motion 1

	set_deposition_parameters

	set mom_my_first_cycle_move "YES"

	output_buffer
	output_tolerance

	if { [info exists mom_motion_type] && $mom_motion_type != "CYCLE" } {
		output_feedrate
		if {$mom_motion_type != "FROM" } { output_xyz GOTO }
	}
}

################################################################################
proc MOM_first_move {} {
global mom_mcs_goto
global mom_tool_axis
global mom_operation_type
global mom_motion_type
global mom_motion_event
global mom_my_using_machine_mode
global mom_my_first_cycle_move
global mom_my_this_apply
global mom_tool_insert_position
global mom_use_a_axis
global mom_tool_holder_angle_for_cutting
global mom_tool_tracking_point
global mom_spindle_maximum_rpm
global mom_length_comp_register
global mom_turn_holder_hand
global my_cutting_motion
	set my_cutting_motion 1

	set_deposition_parameters

	set mom_my_first_cycle_move "YES"

	output_buffer
	output_tolerance

	if { $mom_motion_type == "CYCLE" } {
		if { $mom_operation_type != "Point to Point" && $mom_operation_type != "Drilling" && $mom_operation_type != "Hole Making"
		&& $mom_operation_type != "POINT TO POINT" && $mom_operation_type != "DRILLING" && $mom_operation_type != "HOLE MAKING"	} {
			output_xyz GOTO
		}
		# if { $mom_my_this_apply == "APPLY/TURN" } { MOM_$mom_motion_event }
	} 
	MOM_$mom_motion_event
}

###############################################################################
proc MOM_before_motion {} {
global mom_deposition_width
global mom_deposition_height
global mom_last_deposition_width
global mom_last_deposition_height
global mom_my_last_am
global mom_machine_mode
global mom_mcs_goto
global mom_my_first_cycle_move
global mom_my_this_apply
global mom_my_optype
global mom_motion_type
global mom_level_number
global mom_power_level
global mom_deposition_on_stepover

	set mom_my_first_cycle_move "YES"
	if {$mom_my_this_apply == "APPLY/MILL"} {
		output_multax
	} else {
		if {[expr abs($mom_mcs_goto(1))] > 0.00001} { 
			MOM_output_literal "\$\$ WARNING - TURNING MOTION WITH A Y VALUE [fm $mom_mcs_goto(1)]"
		}
	}
	
	if { [info exists mom_motion_type] && [string first "OPTYPE/AM" $mom_my_optype] == 0 } {
		if { $mom_motion_type == "CUT" || $mom_deposition_on_stepover == 1 && $mom_motion_type == "STEPOVER" } {
			if {![info exists mom_last_deposition_width] || ![is_equal $mom_last_deposition_width $mom_deposition_width] ||\
				![info exists mom_last_deposition_height] || ![is_equal $mom_last_deposition_height $mom_deposition_height] } {
				MOM_output_literal "#1003:26/AM,[fm $mom_deposition_width],[fm $mom_deposition_height]"
			}
			set mom_last_deposition_width $mom_deposition_width
			set mom_last_deposition_height $mom_deposition_height
			if { ![info exist mom_my_last_am] || $mom_my_last_am != "AM/ON" } { 
				set am "AM/ON"
				if { [info exists mom_level_number] } { append am ",SET,$mom_level_number" }
				if { [info exists mom_power_level] } { append am ",POWER,$mom_power_level"}
				MOM_output_literal $am
			}
			set mom_my_last_am "AM/ON"
		} else {
			if { [info exist mom_my_last_am] && $mom_my_last_am == "AM/ON" } { MOM_output_literal "AM/OFF" }
			set mom_my_last_am "AM/OFF"
		}
	}
}

###############################################################################
proc MOM_from_move {} {
global mom_mcs_goto
global mom_tool_axis
global my_cutting_motion
	set my_cutting_motion 1
	output_buffer
	MOM_output_literal FROM/[fm $mom_mcs_goto(0)],[fm $mom_mcs_goto(1)],[fm $mom_mcs_goto(2)],[fm $mom_tool_axis(0)],[fm $mom_tool_axis(1)],[fm $mom_tool_axis(2)]
}

###############################################################################
proc MOM_linear_move {} {
global mom_mcs_goto
global mom_motion_type
	output_feedrate
	if {$mom_motion_type != "FROM" } { 
		# MOM_output_literal "\$\$ Linear Move"
		output_xyz GOTO 
	}
}

###############################################################################
proc MOM_rapid_move {} {
	MOM_output_literal RAPID
	output_xyz GOTO
}

###############################################################################
proc MOM_circular_move {} {
global mom_arc_axis
	# MOM_output_literal "\$\$ Circular Move"
	output_feedrate
	# Invert the arc axis.  UG arc axis is opposite of ISO standard.
	# The dot product of a clockwise arc is negative.
	# the dot product of a counter-clockwise arc is positive.
	# the arc axis/plane follows the right-hand rule.
	set mom_arc_axis(0) [expr ($mom_arc_axis(0) * -1)]
	set mom_arc_axis(1) [expr ($mom_arc_axis(1) * -1)]
	set mom_arc_axis(2) [expr ($mom_arc_axis(2) * -1)]
	MOM_do_template movarc
	output_xyz GOTO
}

###############################################################################
proc MOM_thread {} {
global mom_total_depth
global mom_total_depth_angle
global mom_total_depth_constant_increment
global mom_my_optype
	if { $mom_my_optype == "OPTYPE/MILL" || $mom_my_optype == "OPTYPE/AXIAL" } {
		set cycle_statement CYCLE/THREAD,DEPTH,[fm $mom_total_depth],CUTS,$cuts,CUTANG,[ffm $mom_total_depth_angle]
		output_cycle_statement cycle_statement
	}
}

###############################################################################
proc MOM_thread_move {} {
	MOM_output_literal "\$\$ THREAD_MOVE"
	output_xyz GOTO
}

################################################################################
proc MOM_lathe_thread_move {} {
	MOM_output_literal "\$\$ LATHR_THREAD_MOVE"
	output_xyz GOTO
}

################################################################################
proc MOM_lathe_thread {} {
global mom_total_depth
global mom_total_depth_constant_increment
	output_thread_lathe
	#if {[expr $mom_total_depth - $mom_total_depth_constant_increment] <= 0 || $mom_total_depth_constant_increment == 0 } {
	#	single_pass_turn_threading
	#} else {
	#	multiple_passes_turn_threading
	#}
}

################################################################################
proc output_thread_lathe {} {
global mom_lathe_thread_advance_type 
global mom_lathe_thread_increment 
global mom_lathe_thread_type 
global mom_lathe_thread_value
global mom_output_unit
global mom_my_pitch_did_output
global mom_total_depth_angle
global mom_tool_included_angle
global mom_thread_pullout_vector
global mom_thread_infeed_vector
global mom_thread_pullout_angle
global mom_thread_infeed_angle
global mom_total_depth
global mom_total_depth_constant_increment
global mom_thread_engage_type
global mom_thread_pullout_type

	if { [info exists mom_thread_pullout_angle] && $mom_thread_pullout_angle != 0 } { MOM_output_literal "\$\$ $mom_thread_pullout_angle" }
	if { [info exists mom_thread_infeed_angle] && $mom_thread_infeed_angle != 0 } { MOM_output_literal "\$\$ $mom_thread_infeed_angle" }

	set pi [expr atan(1)*4.0]
	set infeed 0
	if { [info exists mom_thread_engage_type] && $mom_thread_engage_type != 0 && [info exists mom_thread_infeed_vector] && $mom_thread_infeed_vector(0) > 0.000001 } {
		#MOM_output_literal "\$\$ infeed vector: $mom_thread_infeed_vector(0),$mom_thread_infeed_vector(1)"
		set angle_infeed [expr atan($mom_thread_infeed_vector(1)/$mom_thread_infeed_vector(0))*180.0/$pi]
		if { $angle_infeed < 0 } { set angle_infeed [expr $angle_infeed+360.0] }
		set infeed 1
	}
	set pullout 0
	if {[info exists mom_thread_pullout_vector] && $mom_thread_pullout_vector(0) > 0.000001 } {
		#MOM_output_literal "\$\$ pullout vector: $mom_thread_pullout_vector(0),$mom_thread_pullout_vector(1)"
		set angle_pullout [expr atan($mom_thread_pullout_vector(1)/$mom_thread_pullout_vector(0))*180.0/$pi]
		if { $angle_pullout < 0 } { set angle_pullout [expr $angle_pullout+360.0] }
		set pullout 1
	}		
		
	if { $mom_output_unit == "MM" } {
		set pitch_unit 25.4
	} else {
		set pitch_unit 1
	}

	set thread THREAD/
	if {$mom_lathe_thread_type < 5} {
		append thread TURN
	} else {
		append thread FACE
	}

	set pitch ""
	if { $mom_lathe_thread_type == "2" || $mom_lathe_thread_type == "6" } {
		if {$mom_lathe_thread_value > 0} { set pitch PITCH/TPI,[fm [expr $pitch_unit / $mom_lathe_thread_value]] }
		#append thread ,PITCH,[fm $mom_lathe_thread_value]
	} elseif { $mom_lathe_thread_type == "3" || $mom_lathe_thread_type == "7" } {
		if {$mom_lathe_thread_value > 0} { set pitch PITCH/TPI,[fm [expr $pitch_unit / [expr $mom_lathe_thread_value * 0.5]]] }
		append thread ,LEAD,[fm $mom_lathe_thread_value]
	} elseif { $mom_lathe_thread_type == "4" || $mom_lathe_thread_type == "8" } {
		set pitch PITCH/TPI,[fm $mom_lathe_thread_value]
		append thread ,TPI,[fm $mom_lathe_thread_value]
	}

	set increment_type ""
	set mom_lathe_thread_increment [expr abs($mom_lathe_thread_increment)]
	if {$mom_lathe_thread_advance_type == 3} {
		set increment_type "DECR"
		if {$mom_lathe_thread_type != 1} { append thread ,DECR,[fm $mom_lathe_thread_increment] }
	} elseif {$mom_lathe_thread_advance_type == 2} {
		set increment_type "INCR"
		if {$mom_lathe_thread_type != 1} { append thread ,INCR,[fm $mom_lathe_thread_increment ]}
	}
	if {$mom_lathe_thread_advance_type == 1 || $mom_lathe_thread_type == 1} { set increment_type "" }
	
	if {[expr $mom_total_depth - $mom_total_depth_constant_increment] <= 0 || $mom_total_depth_constant_increment == 0 } {
	} else {
		if { $infeed } { append thread ,TLANGL,[ffm $angle_infeed] }
		if { $pullout } { append thread ,ATANGL,[ffm $angle_pullout] }
	}
	
	if { $mom_my_pitch_did_output == "NO" && $pitch != "" } {
		set mom_my_pitch_did_output "YES"
		if { $increment_type != "" } { append pitch ,$increment_type,[fm $mom_lathe_thread_increment] }
		MOM_output_literal $pitch
	} 

	MOM_output_literal $thread
}

################################################################################
proc single_pass_turn_threading {} {
global mom_lathe_thread_type 
global mom_total_depth_angle
global mom_my_thread_cycle
	if {[expr abs($mom_total_depth_angle - [expr 4*atan(1)])] < 0.000000000000001} {
		if {$mom_lathe_thread_type < 5} {
			set thread THREAD/TURN
		} else {
			set thread THREAD/FACE
		}
	} else {
		set thread THREAD/TAPER
	}
	set mom_my_thread_cycle "ON"
	MOM_output_literal $thread
}

################################################################################
proc multiple_passes_turn_threading {} {
global mom_total_depth
global mom_total_depth_angle
global mom_total_depth_constant_increment
global mom_lathe_thread_advance_type
global mom_lathe_thread_increment
global mom_number_of_chases
global mom_tool_included_angle
global mom_my_thread_cycle
	set cuts [expr int([expr ceil([expr $mom_total_depth/$mom_total_depth_constant_increment])])]
	set pi [expr 4*atan(1)]
	set angle [expr $mom_total_depth_angle*180/$pi]
	set thread "#1003:18/ON,DEPTH,[fm $mom_total_depth],CUTS,$cuts,STEP,[fm $mom_total_depth_constant_increment],CUTANG,[ffm $angle]"
	if {[info exists mom_number_of_chases] && $mom_number_of_chases > 0 } { append thread ,FINCUT,$mom_number_of_chases }
	if {[info exists mom_tool_included_angle] && $mom_tool_included_angle > 0} {
		set angle [expr $mom_tool_included_angle*180/$pi]
		append thread ,TLANGL,[ffm $angle],OPTION,0
	}
#ATANGL,TLANGL, OPTION,
	if {$mom_lathe_thread_advance_type == 3} {
		append thread ,DECR,[fm $mom_lathe_thread_increment]
	} elseif {$mom_lathe_thread_advance_type == 2} {
		append thread ,INCR,[fm $mom_lathe_thread_increment]
	}
	set mom_my_thread_cycle "ON"
	MOM_output_literal $thread
}

#######################################################
proc output_xyz { v } {
global mom_mcs_goto 
global mom_tool_axis
	set x [fm $mom_mcs_goto(0)]
	set y [fm $mom_mcs_goto(1)]
	set z [fm $mom_mcs_goto(2)]
	set i [ffm $mom_tool_axis(0)]
	set j [ffm $mom_tool_axis(1)]
	set k [ffm $mom_tool_axis(2)]
	MOM_output_literal "$v/$x,$y,$z,$i,$j,$k"
}
						
###############################################################################
proc output_feedrate {} {
global mom_motion_type
global mom_programmed_feed_rate
global mom_feed_rate_mode
global mom_feed_rate
global mom_feed_rate_per_rev
global mom_my_prev_feed_val
global mom_my_prev_feed_unit
global mom_my_last_fedrat

	set pgm 0
	if { [info exists mom_programmed_feed_rate] } { set pgm $mom_programmed_feed_rate }
	
	set fmd ""
	if { [info exists mom_feed_rate_mode] && $mom_feed_rate_mode != "NONE" } { set fmd $mom_feed_rate_mode }

	if { $mom_motion_type == "CYCLE" || $mom_motion_type == "SIDECUT" } {
		return
	} elseif { $mom_motion_type == "RAPID" } {
		if { $pgm < 0.0000001 || $fmd == "" } { 
			MOM_output_literal RAPID
		} elseif { $pgm > 0.0000001 || $mom_my_prev_feed_val != $mom_feed_rate && $mom_my_prev_feed_val != $mom_feed_rate_per_rev || $mom_my_prev_feed_unit != $fmd } {
			if { $mom_feed_rate > 0.0000001 && ( $fmd == "IPM" || $fmd == "MMPM" ) } {
				set fed FEDRAT/[fm $mom_feed_rate],$fmd
				set mom_my_prev_feed_val $mom_feed_rate
				MOM_output_literal "\$\$ WARNING - positioning motion with FEEDRATE"
				if { ![info exists mom_my_last_fedrat] || $mom_my_last_fedrat != $fed } { MOM_output_literal $fed } 
				set mom_my_last_fedrat $fed
			} elseif { $pgm > 0.0000001 && ( $fmd == "IPM" || $fmd == "MMPM" ) } {
				set fed FEDRAT/[fm $pgm],$fmd
				set mom_my_prev_feed_val $pgm
				MOM_output_literal "\$\$ WARNING - positioning motion with FEEDRATE"
				if { ![info exists mom_my_last_fedrat] || $mom_my_last_fedrat != $fed } { MOM_output_literal $fed } 
				set mom_my_last_fedrat $fed
			} elseif { $fmd == "IPR" || $fmd == "MMPR" } {
				set fed FEDRAT/[fm $mom_feed_rate_per_rev],$fmd
				set mom_my_prev_feed_val $mom_feed_rate_per_rev
				MOM_output_literal "\$\$ WARNING - positioning motion with FEEDRATE"
				if { ![info exists mom_my_last_fedrat] || $mom_my_last_fedrat != $fed } { MOM_output_literal $fed } 
				set mom_my_last_fedrat $fed
			} elseif { $mom_feed_rate > 0.0000001 } {
				set fed FEDRAT/[fm $mom_feed_rate]
				set mom_my_prev_feed_val $mom_feed_rate
				MOM_output_literal "\$\$ WARNING - positioning motion with FEEDRATE"
				if { ![info exists mom_my_last_fedrat] || $mom_my_last_fedrat != $fed } { MOM_output_literal $fed } 
				set mom_my_last_fedrat $fed
			}  elseif { $pgm > 0.0000001 } {
				set fed FEDRAT/[fm $pgm]
				set mom_my_prev_feed_val $pgm
				MOM_output_literal "\$\$ WARNING - positioning motion with FEEDRATE"
				if { ![info exists mom_my_last_fedrat] || $mom_my_last_fedrat != $fed } { MOM_output_literal $fed } 
				set mom_my_last_fedrat $fed
			} elseif { $mom_feed_rate < 0.0000001 && $pgm < 0.0000001 } {
				MOM_output_literal "\$\$ WARNING - positioning motion with ZERO feedrate (USING RAPID.1)"
				MOM_output_literal RAPID
			}
		} else {
			MOM_output_literal RAPID
		}
	} else {
		if { $pgm > 0.0000001 || $mom_my_prev_feed_val != $mom_feed_rate && $mom_my_prev_feed_val != $mom_feed_rate_per_rev || $mom_my_prev_feed_unit != $fmd || $mom_feed_rate > 0.0000001 } {
			if { $pgm < 0.0000001 && $mom_feed_rate < 0.0000001 } {
				MOM_output_literal "\$\$ WARNING - motion with ZERO feedrate (USING RAPID.2)"
				MOM_output_literal RAPID
			} else {
				if { $mom_feed_rate > 0.0000001 && ( $fmd == "IPM" || $fmd == "MMPM" ) } {
					set fed FEDRAT/[fm $mom_feed_rate],$fmd
					set mom_my_prev_feed_val $mom_feed_rate
				} elseif { $pgm > 0.0000001 && ( $fmd == "IPM" || $fmd == "MMPM" ) } {
					set fed FEDRAT/[fm $pgm],$fmd
					set mom_my_prev_feed_val $pgm
				} elseif { $fmd == "IPR" || $fmd == "MMPR" } {
					set fed FEDRAT/[fm $mom_feed_rate_per_rev],$fmd
					set mom_my_prev_feed_val $mom_feed_rate_per_rev
				} elseif { $mom_feed_rate > 0.0000001} {
					set fed FEDRAT/[fm $mom_feed_rate]
					set mom_my_prev_feed_val $mom_feed_rate
				} elseif { $pgm > 0.0000001} {
					set fed FEDRAT/[fm $pgm]
					set mom_my_prev_feed_val $pgm
				} else {
					set fed ""
				}
				if { $fed != "" } { 
					if { ![info exists mom_my_last_fedrat] || $mom_my_last_fedrat != $fed } { MOM_output_literal $fed } 
					set mom_my_last_fedrat $fed
				}
			}
		} else {
			MOM_output_literal "\$\$ WARNING - motion with ZERO feedrate (USING RAPID.3)"
			MOM_output_literal RAPID
		}
	}
	set mom_my_prev_feed_unit $fmd
}

###############################################################################
proc MOM_bore {} {
global mom_cycle_feed_to
	set depth [expr 0-$mom_cycle_feed_to]
	set cycle_statement CYCLE/REAM,DEPTH,[fm $depth]
	output_cycle_statement2 cycle_statement
}

###############################################################################
proc MOM_bore_dwell {} {
global mom_cycle_feed_to
	set depth [expr 0-$mom_cycle_feed_to]
	set cycle_statement CYCLE/REAM,DEPTH,[fm $depth]
	output_cycle_statement cycle_statement
}

###############################################################################
proc MOM_bore_drag {} {
global mom_cycle_feed_to
	set depth [expr 0-$mom_cycle_feed_to]
	set cycle_statement CYCLE/BORE,DEPTH,[fm $depth]
	output_cycle_statement cycle_statement
}

###############################################################################
proc MOM_bore_no_drag {} {
global mom_cycle_feed_to
global mom_cycle_orient
	set cycle_statement "CYCLE/BORE"
	if {[info exists mom_cycle_orient] == 1} { append cycle_statement ,ORIENT,[fm $mom_cycle_orient] }
	set depth [expr 0-$mom_cycle_feed_to]
	append cycle_statement ,DEPTH,[fm $depth]
	output_cycle_statement cycle_statement
}

###############################################################################
proc MOM_bore_manual_dwell {} {
global mom_cycle_feed_to
	set depth [expr 0-$mom_cycle_feed_to]
	set cycle_statement CYCLE/REAM,DEPTH,[fm $depth]
	output_cycle_statement cycle_statement
}

###############################################################################
proc MOM_bore_manual {} {
global mom_cycle_feed_to
	set depth [expr 0-$mom_cycle_feed_to]
	set cycle_statement CYCLE/REAM,DEPTH,[fm $depth]
	output_cycle_statement2 cycle_statement
}

###############################################################################
proc MOM_bore_back {} {
global mom_cycle_feed_to
global mom_cycle_orient
global mom_siemens_cycle_rpa
global mom_siemens_cycle_rpo
global mom_siemens_cycle_rpap
	set depth [expr 0-$mom_cycle_feed_to]
	set cycle_statement CYCLE/BORE,BACK,DEPTH,[fm $depth]
	if {[info exists mom_cycle_orient] == 1} { append cycle_statement ,ORIENT,[fm $mom_cycle_orient] }
	if { [info exists mom_siemens_cycle_rpa] && [info exists mom_siemens_cycle_rpo] && [info exists mom_siemens_cycle_rpap] } {
		append cycle_statement ,OFSETL,[fm $mom_siemens_cycle_rpa],[fm $mom_siemens_cycle_rpo],[fm $mom_siemens_cycle_rpap]
	}
	output_cycle_statement cycle_statement
}

###############################################################################
proc MOM_cdrill {} {
global mom_cycle_hole_dia
global mom_cycle_counter_sink_dia
global mom_cycle_tool_angle
	set cycle_statement CYCLE/CDRILL,DIAMET,[fm $mom_cycle_counter_sink_dia],TLANGL,[fm $mom_cycle_tool_angle],HOLDIA,[fm $mom_cycle_hole_dia]
	output_cycle_statement cycle_statement
}

###############################################################################
proc MOM_drill_counter_sink {} {
global mom_cycle_hole_dia
global mom_cycle_counter_sink_dia
global mom_cycle_tool_angle
global mom_cycle_feed_to
global mom_tool_tip_diameter
	if { [info exists mom_tool_tip_diameter] && $mom_tool_tip_diameter > 0 } {
		MOM_output_literal "\$\$ TOOL TIP DIAMETER $mom_tool_tip_diameter, use DRILL CYCLE"
		MOM_output_literal "\$\$ CYCLE FEED TO $mom_cycle_feed_to"
		#set alpha [expr { 90.0 - $mom_cycle_tool_angle / 2.0 }]
		#set alpha [expr { $alpha / 180.0 }]
		#set pi [expr { atan(1) * 4 }]
		#set alpha [expr {$alpha * $pi}]
		#set alpha [expr tan($alpha)]
		#set width [expr { $mom_cycle_counter_sink_dia - $mom_tool_tip_diameter }]
		#set width [expr { $width / 2.0 }]
		#set height [expr { $width * $alpha }]
		set height [expr { 0 - $mom_cycle_feed_to }]
		set cycle_statement CYCLE/DRILL,DEPTH,[fm $height]
	} else {
		set cycle_statement CYCLE/CSINK
    	if { [info exists mom_cycle_counter_sink_dia] } {
		  append cycle_statement ,DIAMET,[fm $mom_cycle_counter_sink_dia]
        }
	if { [info exists mom_cycle_tool_angle] } {
	append cycle_statement ,TLANGL,[fm $mom_cycle_tool_angle]
        }  
	}
	output_cycle_statement cycle_statement
}

###############################################################################
proc MOM_drill {} {
global mom_cycle_feed_to
	set depth [expr 0-$mom_cycle_feed_to]
	set cycle_statement CYCLE/DRILL,DEPTH,[fm $depth]
	output_cycle_statement cycle_statement
}

###############################################################################
proc MOM_drill_text {} {
global mom_cycle_feed_to
	set depth [expr 0-$mom_cycle_feed_to]
	set cycle_statement CYCLE/DRILL,DEPTH,[fm $depth]
	output_cycle_statement cycle_statement
}

###############################################################################
proc MOM_drill_dwell {} {  
global mom_cycle_feed_to
	set depth [expr 0-$mom_cycle_feed_to]
	set cycle_statement CYCLE/DRILL,DEPTH,[fm $depth]
	output_cycle_statement cycle_statement
}

###############################################################################
proc MOM_drill_break_chip {} { 
global mom_cycle_feed_to
global mom_cycle_step1
global mom_cycle_step2
global mom_cycle_step3
global mom_part_unit
	set depth [expr (abs($mom_cycle_feed_to))]
	set cycle_statement CYCLE/BRKCHP,DEPTH,[fm $depth],INCR
	if {$mom_cycle_step1 == 0 && $mom_cycle_step2 == 0 && $mom_cycle_step3 == 0} {
		# STEP DEPTH NOT SET WILL USE DEFAULT OF .1 INCH OR 2.54 MM
		if {$mom_part_unit == "IN"} {
			append cycle_statement ,0.1
		} else {
			append cycle_statement ,2.54
		}
	} else {
		if {($mom_cycle_step1 != 0)} { append cycle_statement ,[fm $mom_cycle_step1] }
		if {($mom_cycle_step2 != 0)} { append cycle_statement ,[fm $mom_cycle_step2] }
		if {($mom_cycle_step3 != 0)} { append cycle_statement ,[fm $mom_cycle_step3] }
	}
	output_cycle_statement cycle_statement
}

###############################################################################
proc MOM_drill_deep {} {
global mom_cycle_feed_to
global mom_part_unit
global mom_cycle_step1
global mom_cycle_step2
global mom_cycle_step3
	set depth [expr (abs($mom_cycle_feed_to))]
	set cycle_statement CYCLE/DEEP,DEPTH,[fm $depth],INCR
	if {$mom_cycle_step1 == 0 && $mom_cycle_step2 == 0 && $mom_cycle_step3 == 0} {
		# STEP DEPTH NOT SET WILL USE DEFAULT OF .1 INCH OR 2.54 MM
		if {$mom_part_unit == "IN"} {
			append cycle_statement ,0.1
		} else {
			append cycle_statement ,2.54
		}
	} else {
		if {($mom_cycle_step1 != 0)} { append cycle_statement ,[fm $mom_cycle_step1] }
		if {($mom_cycle_step2 != 0)} { append cycle_statement ,[fm $mom_cycle_step2] }
		if {($mom_cycle_step3 != 0)} { append cycle_statement ,[fm $mom_cycle_step3] }
	}
	output_cycle_statement cycle_statement
}

###############################################################################
proc MOM_drill_csink_dwell {} {
global mom_cycle_hole_dia
global mom_cycle_counter_sink_dia
global mom_cycle_tool_angle
global mom_tool_tip_diameter
global mom_cycle_feed_to
	if { [info exists mom_tool_tip_diameter] && $mom_tool_tip_diameter > 0 } {
		MOM_output_literal "\$\$ TOOL TIP DIAMETER $mom_tool_tip_diameter, use DRILL CYCLE"
		MOM_output_literal "\$\$ CYCLE FEED TO $mom_cycle_feed_to"
		#set alpha [expr { 90.0 - $mom_cycle_tool_angle / 2.0 }]
		#set alpha [expr { $alpha / 180.0 }]
		#set pi [expr { atan(1) * 4 }]
		#set alpha [expr {$alpha * $pi}]
		#set alpha [expr tan($alpha)]
		#set width [expr { $mom_cycle_counter_sink_dia - $mom_tool_tip_diameter }]
		#set width [expr { $width / 2.0 }]
		#set height [expr { $width * $alpha }]
		set height [expr { 0 - $mom_cycle_feed_to }]
		set cycle_statement CYCLE/DRILL,DEPTH,[fm $height]
	} else {
		set sink_dia ""
		if {[info exists mom_cycle_counter_sink_dia]} {
			set sink_dia ,DIAMET,[fm $mom_cycle_counter_sink_dia]
		}
		set tool_angle ""
		if { [info exists mom_cycle_tool_angle]} {
			set tool_angle ,TLANGL,[fm $mom_cycle_tool_angle]
		}
		set cycle_statement CYCLE/CSINK$sink_dia$tool_angle
	}
	output_cycle_statement cycle_statement
}

###############################################################################
proc MOM_tap {} { 
global mom_spindle_direction
global mom_cycle_feed_to
	set invers ""
	if { [info exists mom_spindle_direction] && $mom_spindle_direction == "CCLW" } { set invers "INVERS," }
	set user_value [expr (abs($mom_cycle_feed_to))]
	set cycle_statement "CYCLE/TAP,${invers}DEPTH,[fm $user_value]"
	output_cycle_statement2 cycle_statement
}

###############################################################################
proc MOM_tap_float {} {
global mom_spindle_direction
global mom_cycle_feed_to
  	set invers ""
	if { [info exists mom_spindle_direction] && $mom_spindle_direction == "CCLW" } { set invers "INVERS," }
	set user_value [expr (abs($mom_cycle_feed_to))]
	set cycle_statement "CYCLE/TAP,FLOAT,${invers}DEPTH,[fm $user_value]"
	output_cycle_statement2 cycle_statement
}

###############################################################################
proc MOM_tap_deep {} {
global mom_spindle_direction
global mom_cycle_feed_to
  	set invers ""
	if { [info exists mom_spindle_direction] && $mom_spindle_direction == "CCLW" } { set invers "INVERS," }
	set user_value [expr (abs($mom_cycle_feed_to))]
	set cycle_statement "CYCLE/TAP,DEEP,${invers}DEPTH,[fm $user_value]"
	output_cycle_step_statement cycle_statement
	output_cycle_statement2 cycle_statement
}

###############################################################################
proc MOM_tap_break_chip {} {
global mom_cycle_status
global mom_spindle_direction
global mom_cycle_feed_to
  	set invers ""
	if { [info exists mom_spindle_direction] && $mom_spindle_direction == "CCLW" } { set invers "INVERS," }
	set user_value [expr (abs($mom_cycle_feed_to))]
	set cycle_statement "CYCLE/TAP,BRKCHP,${invers}DEPTH,[fm $user_value]"
	if {$mom_cycle_status != "SAME"} { output_cycle_step_statement cycle_statement }
	output_cycle_statement2 cycle_statement
}

###############################################################################
proc MOM_bore_move {} { user_cycle_move }
proc MOM_bore_back_move {} { user_cycle_move }
proc MOM_bore_drag_move {} { user_cycle_move }
proc MOM_bore_dwell_move {}	{ user_cycle_move }
proc MOM_bore_manual_dwell_move {} { user_cycle_move }
proc MOM_bore_manual_move {} { user_cycle_move }
proc MOM_bore_no_drag_move {} { user_cycle_move }
proc MOM_drill_text_move {} { user_cycle_move }
proc MOM_drill_move {} { user_cycle_move }
proc MOM_drill_dwell_move {} { user_cycle_move }
proc MOM_drill_break_chip_move {} { user_cycle_move }
proc MOM_drill_deep_move {} { user_cycle_move }
proc MOM_drill_csink_dwell_move {} { user_cycle_move }
proc MOM_drill_counter_sink_move {} { user_cycle_move }
proc MOM_cdrill_move {} { user_cycle_move }
proc MOM_tap_move {} { user_cycle_move }
proc MOM_tap_deep_move {} { user_cycle_move }
proc MOM_tap_break_chip_move {} { user_cycle_move }

proc MOM_catch_warning {} { 
#global mom_warning_info
#	MOM_output_literal "\$\$ $mom_warning_info" 
}

###############################################################################
proc user_cycle_move {} {
global mom_my_first_cycle_move
	if {$mom_my_first_cycle_move == "YES"} {
		set mom_my_first_cycle_move "NO"
	} else {
		user_plane_change
	}
	#MOM_output_literal "\$\$ User Cycle Move"
	output_xyz GOTO
}

###############################################################################
proc user_plane_change {} {
global mom_tool_axis
global mom_prev_tool_axis
global mom_mcs_goto
global mom_prev_mcs_goto
global mom_tool_axis
global mom_my_first_cycle_move
	set difx [expr abs(($mom_tool_axis(0) - $mom_prev_tool_axis(0)))]
	set dify [expr abs(($mom_tool_axis(1) - $mom_prev_tool_axis(1)))]
	set difz [expr abs(($mom_tool_axis(2) - $mom_prev_tool_axis(2)))]
	if { $difx < 0.0000001 } { set difx 0 }
	if { $dify < 0.0000001 } { set dify 0 }
	if { $difz < 0.0000001 } { set difz 0 }
	set hole_plane_1 [expr (($mom_prev_mcs_goto(0) * $mom_prev_tool_axis(0)) + ($mom_prev_mcs_goto(1) * $mom_prev_tool_axis(1)) + ($mom_prev_mcs_goto(2) * $mom_prev_tool_axis(2)))]
	set hole_plane_2 [expr (($mom_mcs_goto(0) * $mom_tool_axis(0)) + ($mom_mcs_goto(1) * $mom_tool_axis(1)) + ($mom_mcs_goto(2) * $mom_tool_axis(2)))]
	set plane_diff [expr ($hole_plane_1 - $hole_plane_2)]
#	MOM_output_literal "***************DIF: $difx,$dify,$difz"
	if {($difx != 0) || ($dify != 0) || ($difz != 0)} {
		MOM_cycle_off
		set first_cycle_move "NO"
	} elseif {($plane_diff > .001) } {            ;# if new plane is lower
		MOM_cycle_off
		MOM_do_template rapid
		MOM_do_template cycle_goto_1              ;# use current X and Y values and Z from previous move
		set first_cycle_move "NO"
	} elseif {($plane_diff < -.001)} {            ;# if new plane is higher
		MOM_cycle_off
		MOM_do_template rapid
		MOM_do_template cycle_goto_2              ;# output previous X and Y values and use Z from current move
		set first_cycle_move "NO"
	} else {
		# no plane change.  Do nothing.
	}
}

###############################################################################
proc output_cycle_step_statement { v } {
upvar $v cycle_statement
global mom_cycle_step1
global mom_cycle_step2
global mom_cycle_step3
global mom_cycle_retract_mode
global mom_cycle_retract_to
global Step_value1
global Step_value2
global Step_value3
	if {$mom_cycle_step1 != 0.0} {
		if {$mom_cycle_step2 != 0.0} {
			if {$mom_cycle_step3 != 0.0} {
				if {$mom_cycle_step1 != $Step_value1 || $mom_cycle_step2 != $Step_value2 || $mom_cycle_step3 != $Step_value3} {
					set Step_value1 $mom_cycle_step1
					set Step_value2 $mom_cycle_step2
					set Step_value3 $mom_cycle_step3
					append cycle_statement ,INCR,$mom_cycle_step1,$mom_cycle_step2,$mom_cycle_step3
				} 
			} else {
				MOM_suppress once Step3
				if {$mom_cycle_step1 != $Step_value1 || $mom_cycle_step2 != $Step_value2 || $mom_cycle_step3 != $Step_value3} {
					set Step_value1 $mom_cycle_step1
					set Step_value2 $mom_cycle_step2
					append cycle_statement ,INCR,$mom_cycle_step1,$mom_cycle_step2
				}
			}
		} else {
			MOM_suppress once Step2
			MOM_suppress once Step3
			if {$mom_cycle_step1 != $Step_value1 || $mom_cycle_step2 != $Step_value2} {
				set Step_value1 $mom_cycle_step1
				append cycle_statement ,INCR,$mom_cycle_step1
			}
		}
	}
	set mom_cycle_step1 0.0
	set mom_cycle_step2 0.0
	set mom_cycle_step3 0.0
}

###############################################################################
proc output_cycle_statement2 { v } {
upvar $v cycle_statement
	Cycle_Feed_Option cycle_statement
	Cycle_Option_Option cycle_statement
	Cycle_Text_Option cycle_statement
	output_buffer
	output_tolerance
global mom_cycle_status
	if {$mom_cycle_status == "SAME"} { MOM_output_literal "CYCLE/OFF" }
	MOM_output_literal $cycle_statement

global mom_spindle_retract_nominal_value
global mom_spindle_retract_nominal_value_defined
global spindle_retract_value
	if { [info exists mom_spindle_retract_nominal_value_defined] && $mom_spindle_retract_nominal_value_defined == 1 } {
		if { [info exists mom_spindle_retract_nominal_value] } {
			if { [info exists spindle_retract_value] } {
			} else {
				set spindle_retract_value $mom_spindle_retract_nominal_value
			}
		}
	}

global cycle_retract_feed_rate
global mom_siemens_cycle_rff_defined
global mom_siemens_cycle_rff
	if { [info exists mom_siemens_cycle_rff_defined] && $mom_siemens_cycle_rff_defined == 1 } {
		if { [info exists mom_siemens_cycle_rff] } {
			if { [info exists cycle_retract_feed_rate] } {
			} else {
				set cycle_retract_feed_rate $mom_siemens_cycle_rff
			}
		}
	}
}

###############################################################################
proc output_cycle_statement { v } {
upvar $v cycle_statement
	Cycle_Feed_Option cycle_statement
	Cycle_Dwell_Option cycle_statement
	Cycle_Option_Option cycle_statement
	Cycle_Text_Option cycle_statement
	output_buffer
	output_tolerance
global mom_cycle_status
	if {$mom_cycle_status == "SAME"} { MOM_output_literal "CYCLE/OFF" }
	MOM_output_literal $cycle_statement

global mom_spindle_retract_nominal_value
global mom_spindle_retract_nominal_value_defined
global spindle_retract_value
	if { [info exists mom_spindle_retract_nominal_value_defined] && $mom_spindle_retract_nominal_value_defined == 1 } {
		if { [info exists mom_spindle_retract_nominal_value] } {
			if { [info exists spindle_retract_value] } {
			} else {
				set spindle_retract_value $mom_spindle_retract_nominal_value
			}
		}
	}

global cycle_retract_feed_rate
global mom_siemens_cycle_rff_defined
global mom_siemens_cycle_rff
	if { [info exists mom_siemens_cycle_rff_defined] && $mom_siemens_cycle_rff_defined == 1 } {
		if { [info exists mom_siemens_cycle_rff] } {
			if { [info exists cycle_retract_feed_rate] } {
			} else {
				set cycle_retract_feed_rate $mom_siemens_cycle_rff
			}
		}
	}
}

###############################################################################
proc Cycle_Text_Option { v } {
upvar $v cycle_statement
global mom_cycle_text
global mom_cycle_text_defined
	# TO OUTPUT THE SPECIAL TEXT / MAY NEED CUSTOMIZING DEPENDING ON CUSTOMER AND USE CASE.
	if {[info exists mom_cycle_text_defined] && $mom_cycle_text_defined == 1 && $mom_cycle_text != ""} { append cycle_statement ,$mom_cycle_text }
	catch { unset mom_cycle_text_defined }
}

###############################################################################
proc Cycle_Feed_Option { v } {
upvar $v CycSta
global mom_mom_my_cycle_feed_rate_mode
global mom_cycle_retract_mode
global mom_cycle_feed_rate_per_rev
global mom_cycle_feed_rate
global mom_cycle_retract_to
global mom_cycle_rapid_to
global mom_cycle_clearance_plane
global mom_my_cycle_feed_rate_mode
global mom_last_pos
global mom_cycle_feed_to
global mom_motion_distance
global mom_my_cycle_pos
global mom_my_cycle_tool_axis
global mom_tool_axis
global mom_cycle_return_type
global mom_cycle_initial_plane
global mom_operation_type
global mom_cycle_orient

	IPR_options
	if {$mom_my_cycle_feed_rate_mode == "IPM"} {
		append CycSta ,IPM,[fm $mom_cycle_feed_rate]
	} elseif {$mom_my_cycle_feed_rate_mode == "IPR"} {
		append CycSta ,IPR,[fm $mom_cycle_feed_rate_per_rev]
	} elseif {$mom_my_cycle_feed_rate_mode == "MMPM"} {
		append CycSta ,MMPM,[fm $mom_cycle_feed_rate]
	} elseif {$mom_my_cycle_feed_rate_mode == "MMPR"} {
		append CycSta ,MMPR,[fm $mom_cycle_feed_rate_per_rev]
	} else {
		# FEEDRATE SET TO NONE
	}

	if { [info exists mom_cycle_rapid_to] && $mom_cycle_rapid_to > 0 } {
		append CycSta ,CLEAR,[fm $mom_cycle_rapid_to]
	} elseif { [info exists mom_cycle_clearance_plane] && $mom_cycle_clearance_plane > 0 } {
		append CycSta ,CLEAR,[fm $mom_cycle_clearance_plane]
	}
	
	if { [info exists mom_cycle_rapid_to] && [info exists mom_cycle_clearance_plane] } {
		append CycSta ,RAPTO,[fm [expr $mom_cycle_clearance_plane - $mom_cycle_rapid_to]]
	}
	
	if { [info exists mom_cycle_retract_mode] } {
		if { $mom_cycle_retract_mode == "MANUAL" } {
			MOM_output_literal "\$\$ RETURN $mom_cycle_retract_mode"
			if { [info exists mom_cycle_retract_to] } {
				append CycSta ,RETURN,[fm $mom_cycle_retract_to]
			}
		} elseif { $mom_cycle_retract_mode == "AUTO" } {
			MOM_output_literal "\$\$ RETURN $mom_cycle_retract_mode"
			if { [info exists mom_operation_type] } {
				if { $mom_operation_type == "POINT TO POINT" } {
					MOM_output_literal "\$\$ LAGECY OPER TYPE: '$mom_operation_type'"
					#append CycSta ,RETURN,[fm $mom_cycle_retract_to]
					append CycSta ", RETURN , AUTO"
					return
				}
			}
			
			if { [info exists mom_cycle_return_type] } {
				MOM_output_literal "\$\$ RETURN $mom_cycle_return_type"
				if { $mom_cycle_return_type == "INITIAL" && [info exists mom_cycle_initial_plane]} {
					append CycSta ,RETURN,[fm $mom_cycle_initial_plane]
					return
				}
			}

			if { [info exists mom_last_pos] } {
				#MOM_output_literal "\$\$ USING LAST POSITION"
				set mom_my_cycle_pos(0) $mom_last_pos(0)
				set mom_my_cycle_pos(1) $mom_last_pos(1)
				set mom_my_cycle_pos(2) $mom_last_pos(2)
				set mom_my_cycle_tool_axis(0) $mom_tool_axis(0)
				set mom_my_cycle_tool_axis(1) $mom_tool_axis(1)
				set mom_my_cycle_tool_axis(2) $mom_tool_axis(2)
				append CycSta ,RETURN,AUTO
				return
			} 
			
			if { [info exists mom_cycle_retract_to] && $mom_cycle_retract_to > 0 } {
				#MOM_output_literal "\$\$ USING CYCLE RETRACT TO"
				append CycSta ,RETURN,[fm $mom_cycle_retract_to]
				return
			}
			
			append CycSta ", RETURN , AUTO"
		} 
	}
}

###############################################################################
proc Cycle_Dwell_Option { v } {
upvar $v CycSta
global mom_cycle_delay_mode
global mom_cycle_delay_revs
global mom_cycle_delay
	if {[info exists mom_cycle_delay_mode] && $mom_cycle_delay_mode != "OFF"} {
		if {$mom_cycle_delay_mode == "SECONDS"} {
			append CycSta ,DWELL,[fm $mom_cycle_delay]
		} elseif {$mom_cycle_delay_mode == "REVOLUTIONS"} {
			append CycSta ,REV,[fm $mom_cycle_delay_revs]
		} elseif {$mom_cycle_delay_mode == "ON"} {
			# DELAY MODE IS JUST SET TO "ON"
			# SINCE NO TIME IS SPEWCIFIED A DEFAULT OF 1.0 SECONDS WILL BE USED
			append CycSta ",DWELL,1.0" 
		}
	}
}

###############################################################################
proc Cycle_Option_Option { v } {
upvar $v CycSta
global mom_cycle_option
	if {[info exists mom_cycle_option] && $mom_cycle_option != ""} {
		append CycSta ,$mom_cycle_option
	}
}

###############################################################################
proc IPR_options {} {
global mom_cycle_feed_rate
global mom_cycle_feed_rate_per_rev
global mom_mom_my_cycle_feed_rate_mode
global mom_cycle_status
global mom_part_unit
global mom_output_unit 
global mom_my_cycle_feed_rate_mode
global mom_cycle_feed_rate_mode

	set mom_my_cycle_feed_rate_mode $mom_cycle_feed_rate_mode

	if {$mom_cycle_feed_rate_mode == "IPM" || $mom_cycle_feed_rate_mode == "MMPM"} {
		if { [info exists mom_output_unit] && [info exists mom_part_unit] } {
			if { $mom_output_unit == "MM" && $mom_part_unit == "IN" } {
				set mom_my_cycle_feed_rate_mode "MMPM"
			} elseif { $mom_output_unit == "IN" && $mom_part_unit == "MM" } {
				set mom_my_cycle_feed_rate_mode "IPM" 
			}
		} 
	} elseif {$mom_cycle_feed_rate_mode == "IPR" || $mom_cycle_feed_rate_mode == "MMPR"} {
		if { [info exists mom_output_unit] && [info exists mom_part_unit] } {
			if { $mom_output_unit == "MM" && $mom_part_unit == "IN" } {
				set mom_my_cycle_feed_rate_mode "MMPR"
			} elseif { $mom_output_unit == "IN" && $mom_part_unit == "MM" } {
				set mom_my_cycle_feed_rate_mode "IPR"
			} 
		}
	}
}

###############################################################################
proc MOM_probe_on {} {MOM_output_literal "#1003:8/PROBE,ON" }
proc MOM_probe_off {} {MOM_output_literal PROBE/OFF}
proc MOM_probe_multi_stylus_store {} { MOM_output_literal "#1003:8/PROBE,MULTI_STYLUS_STORE" }
proc MOM_probe_multi_stylus_load {} { MOM_output_literal "#1003:8/PROBE,MULTI_STYLUS_LOAD" }
proc MOM_probe_corner {} { MOM_output_literal PROBE/CORNER }
proc MOM_probe_xyz {} { MOM_output_literal PROBE/XYZ }

###############################################################################
proc MOM_calibrate_probe_length {} { 
	MOM_output_literal PROBE/CALIB,LENGTH[get_probe_over_travel] 
}

###############################################################################
proc MOM_machine_move {} {
global mom_operation_type
global mom_xaxis_status
global mom_xaxis_value
global mom_yaxis_status
global mom_yaxis_value
global mom_zaxis_status
global mom_zaxis_value  
global mom_aaxis_status
global mom_aaxis_value
global mom_baxis_status
global mom_baxis_value
global mom_caxis_status
global mom_caxis_value
global mom_programmed_feed_rate
	if { [info exists mom_operation_type] && $mom_operation_type == "Generic Motion" } {
		set str ""
		if { $mom_xaxis_status == 1 } { 
			if { $str != "" } { append str , }
			append str XAXIS,[fm $mom_xaxis_value]
		}

		if { $mom_yaxis_status == 1 } { 
			if { $str != "" } { append str , }
			append str YAXIS,[fm $mom_yaxis_value] 
		}

		if { $mom_zaxis_status == 1 } { 
			if { $str != "" } { append str , }
			append str ZAXIS,[fm $mom_zaxis_value] 
		}

		if { $mom_aaxis_status == 1 } {
			if { $str != "" } { append str , }
			append str AAXIS,[fm $mom_aaxis_value] 
		} 

		if { $mom_baxis_status == 1 } {
			if { $str != "" } { append str , }
			append str BAXIS,[fm $mom_baxis_value] 
		} 

		if { $mom_caxis_status == 1 } {
			if { $str != "" } { append str , }
			append str CAXIS,[fm $mom_caxis_value] 
		} 
		if {$mom_programmed_feed_rate == 0} {
			MOM_output_literal RAPID
		} else {
			output_feedrate
		}
		if { $str != "" } {
			MOM_output_literal "MOVETO/$str"
		}
	}
}

###############################################################################
proc MOM_start_of_subop_path {} {
global mom_my_protected_move
global mom_template_type
global mom_subop_name
global mom_move_type_name
global mom_probe_angle_measure_method
global mom_probe_measure_angles

global mom_probe_standoff_distance
global mom_probe_radial_clearance

global mom_probe_nominal_tolerance
global mom_probe_nominal_tolerance_output

global mom_probe_cylindrical_tolerance
global mom_probe_cylindrical_tolerance_output

global mom_probe_upper_tolerance
global mom_probe_upper_tolerance_output

global mom_probe_nullband_tolerance
global mom_probe_nullband_tolerance_output

global mom_probe_over_travel_distance
global mom_probe_over_travel_distance_output

global mom_probe_feedback_percent
global mom_probe_feedback_percent_output

global mom_probe_experience_value
global mom_probe_experience_value_output

global mom_probe_work_offset_number
global mom_probe_work_offset_number_output

global mom_adjust_register
global mom_adjust_register_toggle_status

global has_last_tool_vector
	set has_last_tool_vector 0

	set mom_my_protected_move 0
	set start "#1003:8/START"

	set para ""
	if {[info exists mom_subop_name]} { append start ",'$mom_subop_name'" }
	if {[info exists mom_move_type_name]} {	
		append start ",'$mom_move_type_name'" 
		# "Probe_Point" || $mom_move_type_name == "Probe_Cylinder"
		if { [string range $mom_move_type_name 0 5] == "Probe_" } {
			
			append para "#1003:8/PROBE"
			
			if {[info exists mom_probe_standoff_distance] } { 
				append para ",[fm $mom_probe_standoff_distance]" 
			} else {
				append para ",-10000" 
			}

			if {[info exists mom_probe_radial_clearance] } { 
				append para ",[fm $mom_probe_radial_clearance]" 
			} else {
				append para ",-10000" 
			}
			
			if {[info exists mom_probe_nominal_tolerance_output] && $mom_probe_nominal_tolerance_output == 1 } { 
				append para ",[fm $mom_probe_nominal_tolerance]" 
			} else {
				append para ",-10000" 
			}

			if {[info exists mom_probe_cylindrical_tolerance_output] && $mom_probe_cylindrical_tolerance_output == 1 } { 
				append para ",[fm $mom_probe_cylindrical_tolerance]" 
			} else {
				append para ",-10000" 
			}

			if {[info exists mom_probe_upper_tolerance_output] && $mom_probe_upper_tolerance_output == 1 } {
				append para ",[fm $mom_probe_upper_tolerance]" 
			} else {
				append para ",-10000" 
			}

			if {[info exists mom_probe_nullband_tolerance_output] && $mom_probe_nullband_tolerance_output == 1 } { 
				append para ",[fm $mom_probe_nullband_tolerance]" 
			} else {
				append para ",-10000"
			}

			if {[info exists mom_probe_over_travel_distance_output] && $mom_probe_over_travel_distance_output == 1 } { 
				append para ",[fm $mom_probe_over_travel_distance]" 
			} else {
				append para ",-10000"
			}

			if {[info exists mom_probe_feedback_percent_output] && $mom_probe_feedback_percent_output == 1 } { 
				append para ",[fm $mom_probe_feedback_percent]" 
			} else {
				append para ",-10000"
			}

			if {[info exists mom_probe_experience_value_output] && $mom_probe_experience_value_output == 1 } { 
				append para ",[fm $mom_probe_experience_value]" 
			} else {
				append para ",-10000"
			}

			if {[info exists mom_adjust_register_toggle_status] && $mom_adjust_register_toggle_status == 1 } { 
				append para ",$mom_adjust_register" 
			} else {
				append para ",-1"
			}
			
			if {[info exists mom_probe_work_offset_number_output] && $mom_probe_work_offset_number_output == 1 } { 
				append para ",$mom_probe_work_offset_number" 
			} else {
				append para ",-1"
			}
			
		}
	}
	#MOM_output_literal "$$"
	if { $start != "#1003:8/START" } { MOM_output_literal $start }
	if {$para != "" } {
		MOM_output_literal "$$ #1003:8/PROBE,STANDOFF,RADIAL,NOMIANL,CYLINDRICAL,UPPER,NULLBAND,OVERTRAVEL,FEEDBACK,EXPERIENCE,ADJUST,OFFSET (-1: NONE)"
		MOM_output_literal $para
	}
	if {[info exists mom_probe_angle_measure_method] && $mom_probe_angle_measure_method == "1" && [info exists mom_probe_measure_angles]} {
		MOM_output_literal "#1003:8/PROBE_MEASURE_ANGLE,[fm $mom_probe_measure_angles(0)],[fm $mom_probe_measure_angles(1)],[fm $mom_probe_measure_angles(2)]"
    }
}
    
###############################################################################
proc MOM_probe_protected_move {} {
global mom_my_protected_move
global mom_motion_type
	set mom_my_protected_move 1
	if {$mom_motion_type == "FROM"} {
		#MOM_output_literal "\$\$ probe protected move FROM"
		output_feedrate
		output_xyz GOTO
	}
}

###############################################################################
proc MOM_end_of_subop_path {} {
global mom_subop_name
global mom_move_type_name

global has_last_tool_vector
	set has_last_tool_vector 0

global mom_my_protected_move
	set mom_my_protected_move 0
	set end "#1003:8/END"
	if {[info exists mom_subop_name]} { append end ",'$mom_subop_name'" }
	if {[info exists mom_move_type_name]} {	append end ",'$mom_move_type_name'" }
	if { $end != "#1003:8/END" } { MOM_output_literal $end }
}

###############################################################################
proc MOM_calibrate_stylus_offsets {} {
global mom_circle_diameter
	if {[info exists mom_circle_diameter]} {
		MOM_output_literal PROBE/CALIB,PEN,DIAMET,[fm $mom_circle_diameter][get_probe_over_travel]
	}
}

###############################################################################
proc MOM_probe_angled_surface_point {} {
global mom_probe_axis
global mom_measurement_type
global mom_probe_tool_axis
	set probe "PROBE/SFACE"
    if { $mom_measurement_type == "2AXIS" } {
         append probe ",2AXIS"
    } elseif { $mom_measurement_type == "3AXIS" } {
         append probe ",3AXIS"
    }
	append probe ,VECTOR,[fm $mom_probe_tool_axis(0)],[fm $mom_probe_tool_axis(1)],[fm $mom_probe_tool_axis(2)]
	append probe [get_probe_over_travel]
	MOM_output_literal $probe
}

###############################################################################
proc MOM_calibrate_stylus_radius {} {
global mom_stylus_caliberation_type
global mom_move_length
global mom_probe_zero_offset_output
global mom_probe_zero_offset
	set str "PROBE/CALIB"
	if {[info exists mom_stylus_caliberation_type]} {
		set tp [string toupper $mom_stylus_caliberation_type]
		if { $tp == "BALL_RADIUS" } {
			append str ,RADIUS
		} elseif { $tp == "VECTOR_BALL_RADIUS"} {
			append str ,XYZ
		}
        
		if {[info exists mom_move_length]} { append str ,DEPTH,[fm $mom_move_length] }
		if {[info exists mom_probe_zero_offset_output] && $mom_probe_zero_offset_output == "1"} { append str ,ADJUST,[fm $mom_probe_zero_offset] }
        append str [get_probe_over_travel]
        MOM_output_literal $str
	}
}

###############################################################################
proc MOM_calibrate_sphere {} {
global mom_circle_diameter
global mom_adjust_register
	set str PROBE/CALIB,ROUND
	if {[info exists mom_circle_diameter]} { append str ,DIAMET,[fm $mom_circle_diameter] }
	if {[info exists mom_adjust_register]} { append str ,ADJUST,$mom_adjust_register }
    append str [get_probe_over_travel]
    MOM_output_literal $str
}

###############################################################################
proc MOM_probe_single_direction_point {} {
global mom_probe_direction
	set str PROBE/PNT
	if {[info exists mom_probe_direction]} { append str ,$mom_probe_direction }
    append str [get_probe_over_travel]
    MOM_output_literal $str
}

###############################################################################
proc MOM_probe_four_point_bore {} {
global mom_circle_diameter
global mom_move_length
	set str PROBE/BORE,IN
	if {[info exists mom_circle_diameter]} {append str ,DIAMET,[fm $mom_circle_diameter]}
	if {[info exists mom_move_length]} {append str ,DEPTH,[fm $mom_move_length]}
    append str [get_probe_over_travel]
    MOM_output_literal $str
}

###############################################################################
proc MOM_probe_four_point_boss {} {
global mom_circle_diameter
global mom_move_length
global mom_my_protected_move
	set str PROBE/BORE,OUT
	if {[info exists mom_circle_diameter]} {append str ,DIAMET,[fm $mom_circle_diameter]}
	if {[info exists mom_move_length]} {append str ,DEPTH,[fm $mom_move_length]}
    append str [get_probe_over_travel]
    if {$mom_my_protected_move != "1"} {MOM_output_literal "\$\$ WARNING - MISSING PROTECTED MOVE, VERIFY YOUR TOOL PATH DEFINITION"}
    MOM_output_literal $str
}

###############################################################################
proc MOM_probe_three_point_bore {} {
global mom_circle_diameter
global mom_move_length
global mom_my_protected_move
global mom_probe_angle_pos
global mom_probe_angles
	set str PROBE/BORE,IN
	if {[info exists mom_probe_angle_pos]} {append str ,[fm $mom_probe_angle_pos(0)],[fm $mom_probe_angle_pos(1)],[fm $mom_probe_angle_pos(2)]}
	if {[info exists mom_probe_angles]} {append str ,ATANGL,[fm $mom_probe_angles(0)],[fm $mom_probe_angles(1)],[fm $mom_probe_angles(2)]}
	if {[info exists mom_circle_diameter]} {append str ,DIAMET,[fm $mom_circle_diameter]}
	if {[info exists mom_move_length]} {append str ,DEPTH,[fm $mom_move_length]}
    append str [get_probe_over_travel]
    if {$mom_my_protected_move != "1"} {MOM_output_literal "\$\$ WARNING - MISSING PROTECTED MOVE, VERIFY YOUR TOOL PATH DEFINITION"}
    MOM_output_literal $str
}

###############################################################################
proc MOM_probe_three_point_boss {} {
global mom_circle_diameter
global mom_move_length
global mom_my_protected_move
global mom_probe_angle_pos
global mom_probe_angles
	set str PROBE/BORE,OUT
	if {[info exists mom_probe_angle_pos]} {append str ,[fm $mom_probe_angle_pos(0)],[fm $mom_probe_angle_pos(1)],[fm $mom_probe_angle_pos(2)]}
	if {[info exists mom_probe_angles]} {append str ,ATANGL,[fm $mom_probe_angles(0)],[fm $mom_probe_angles(1)],[fm $mom_probe_angles(2)]}
	if {[info exists mom_circle_diameter]} {append str ,DIAMET,[fm $mom_circle_diameter]}
	if {[info exists mom_move_length]} {append str ,DEPTH,[fm $mom_move_length]}
    append str [get_probe_over_travel]
    if {$mom_my_protected_move != "1"} {MOM_output_literal "\$\$ WARNING - MISSING PROTECTED MOVE, VERIFY YOUR TOOL PATH DEFINITION"}
    MOM_output_literal $str
}

###############################################################################
proc MOM__part_attributes {} {
}

###############################################################################
proc get_probe_over_travel {} {
global mom_probe_standoff_distance
global mom_probe_radial_clearance
global mom_probe_over_travel_distance_output
global mom_probe_over_travel_distance
global mom_probe_approach_type
global mom_probe_work_offset_number_output
global mom_probe_work_offset_number
	set str ""
	if {[info exists mom_probe_standoff_distance]} {append str ,CLEAR,[fm $mom_probe_standoff_distance]}
	if {[info exists mom_probe_radial_clearance]} {append str ,STEP,[fm $mom_probe_radial_clearance]}
	if {[info exists mom_probe_over_travel_distance_output] && $mom_probe_over_travel_distance_output == "1"} {append str ,TRAV,[fm $mom_probe_over_travel_distance]}
	if {[info exists mom_probe_approach_type]} {append str ,PROTCT,$mom_probe_approach_type}
	if {[info exists mom_probe_work_offset_number_output] && $mom_probe_work_offset_number_output == "1"} {append str ,ZERO,$mom_probe_work_offset_number}
    return $str
}

###############################################################################
proc flush_buffer {} { 
global buffer_size
global buffer
global buffering
global mom_my_goto_flag
global mom_my_z_offset
global mom_my_loadtl
global mom_my_optype
global spindle_retract_value
global cycle_retract_feed_rate
	set buffering 0
	for {set k 0} {$k < $buffer_size} {incr k} {
		if { [ string first "\$\$ ##1003:19/" $buffer($k) ] == 0 } {
			if { [ string first "\$\$ ##1003:19/CYCLE,OUT" $buffer($k) ] == 0 } {
				if { [info exists spindle_retract_value] } {
					MOM_output_literal "[string range $buffer($k) 4 [string length $buffer($k)]]$spindle_retract_value"
					catch { unset spindle_retract_value }
				}
			} elseif { [ string first "\$\$ ##1003:19/CYCLE,FEDOPT" $buffer($k) ] == 0 } {
				if { [info exists cycle_retract_feed_rate] } {
					MOM_output_literal "[string range $buffer($k) 4 [string length $buffer($k)]]$cycle_retract_feed_rate"
					catch { unset cycle_retract_feed_rate }
				}
			} else {
				if { [info exists mom_my_optype] && [string length $mom_my_optype] > 0 } {

				} else {
					MOM_output_literal [string range $buffer($k) 4 [string length $buffer($k)]]
				}
			}
		} else {
			if { $mom_my_goto_flag != 0 || [string first "#1003:3/" $buffer($k)] != 0 } {
				MOM_output_literal $buffer($k)
			}
		}
	}
	set buffer_size 0
}

###############################################################################
proc flush_buffer_load_tool {} { 
global buffer_size
global buffer
global buffering
	set buffering 0
	set flag 0
	for {set k 0} {$k < $buffer_size} {incr k} {
		set pos1 [string first "OPTYPE/TOOL" $buffer($k)]
		set pos2 [string first "LOAD/TOOL" $buffer($k)]
		if { $flag == 0 && $pos1 == 0 } { set flag 1 }
		if { $flag == 1 } {
			MOM_output_literal $buffer($k)
			set buffer($k) ""
			if { $pos2 == 0 } { set flag 0 }
		}
	}
}

###############################################################################
proc MOM_before_output {} { 
global mom_o_buffer
global mom_my_thread_cycle_filter
global mom_my_max_length
global mom_max_cut_traverse
global mom_my_cycle_pos
global mom_my_cycle_tool_axis
global mom_my_cycle_auto_on
global mom_my_cycle_auto
global mom_my_cycle_retract_auto
global buffering
global buffer_size
global buffer
global last_tool_vector
global has_last_tool_vector
global mom_my_goto_flag
global mom_output_am
global mom_my_am_on
global mom_my_am_flag
global mom_my_am_fedrate
global mom_my_pos_fedrate
global mom_my_last_rapid
global mom_my_optype
global cycle_was_off

	if {[string first "GOTO/" $mom_o_buffer] == 0} { set mom_my_goto_flag 1 }

	if { $buffering == 1 } {
		set buffer($buffer_size) $mom_o_buffer
		incr buffer_size
		set mom_o_buffer ""
	}

	if { [info exists mom_output_am] && $mom_output_am == 1 && [info exists mom_my_optype] && [string first "OPTYPE/AM" $mom_my_optype] == 0 } {
		if {[string first "\$\$ AM/ON" $mom_o_buffer] == 0} {
			set pos [string first ",'FEDRAT'," $mom_o_buffer]
			if { $pos != -1 } {
				set mom_my_am_fedrate [string range $mom_o_buffer [expr $pos+10] [string length $mom_o_buffer]]
				set mom_my_am_on [string range $mom_o_buffer 3 [expr $pos-1]]
				set mom_o_buffer ""
			}
			set mom_my_last_rapid 0
		} elseif {[string first "\$\$ AM/OFF" $mom_o_buffer] == 0} {
			if { $mom_my_am_flag == 1 } {
				set mom_o_buffer "AM/OFF"
			} else {
				set mom_o_buffer ""
			}
			set mom_my_am_on ""
			set mom_my_am_flag 0
			set mom_my_last_rapid 0
		} elseif { [info exists mom_my_am_on] && $mom_my_am_on != ""} {
			if { [string first "FEDRAT/" $mom_o_buffer] == 0} {
				set pos [string first "," $mom_o_buffer]
				if { $pos == -1 } {
					set mom_my_pos_fedrate [string range $mom_o_buffer 7 [string length $mom_o_buffer]]
				} else {
					set mom_my_pos_fedrate [string range $mom_o_buffer [expr $pos+1] [string length $mom_o_buffer]]
				}
				set mom_my_last_rapid 0
			} elseif { [string first "RAPID" $mom_o_buffer] == 0} {
				if { $mom_my_am_flag == 1 } {
					set mom_o_buffer "AM/OFF\n$mom_o_buffer"
					set mom_my_am_flag 0
				}
				set mom_my_last_rapid 1
			} elseif { [string first "GOTO/" $mom_o_buffer] == 0} {
				if { $mom_my_am_flag == 0 && $mom_my_last_rapid != 1 && [expr $mom_my_am_fedrate-$mom_my_pos_fedrate] == 0 } {
					set mom_o_buffer "$mom_my_am_on\n$mom_o_buffer"
					set mom_my_am_flag 1
				}
				set mom_my_last_rapid 0
			} else {
				set mom_my_last_rapid 0
			}
		} else {
			set mom_my_last_rapid 0
		}
	}

	if {[string first "GOTO/" $mom_o_buffer] == 0} {
		set pc [scan $mom_o_buffer "GOTO/%f,%f,%f,%f,%f,%f" x y z i j k]
		if { $pc == 3 } {
			if {[scan $mom_o_buffer "GOTO/%f,%f,%f ICAM_PRB_VEC_CHK %f,%f,%f" x y z i j k] == 6} {
				#ignore this tool axis vector: do not use it as last tool vector
				set mom_o_buffer "GOTO/[ffm $x],[ffm $y],[ffm $z],[ffm $i],[ffm $j],[ffm $k]"
			} elseif {$has_last_tool_vector == 1} {
				if {[scan $mom_o_buffer "GOTO/%f,%f,%f $$ %f,%f,%f" x y z i j k] == 6} {
					# 9 elements GOTO clause
					set pos [string first " $$ " $mom_o_buffer]
					if { $pos > 0 } {
						set header [string range $mom_o_buffer 0 [expr $pos-1]]
						append header ,[ffm $last_tool_vector(0)],[ffm $last_tool_vector(1)],[ffm $last_tool_vector(2)]
						append header [string range $mom_o_buffer $pos [string length $mom_o_buffer]]
						set mom_o_buffer $header
					}
				} else {
					# append last tool vector (minimum 6 elements for GOTO clause)
					append mom_o_buffer ,[ffm $last_tool_vector(0)],[ffm $last_tool_vector(1)],[ffm $last_tool_vector(2)]
				}
			}
		} elseif { $pc == 6 } {
			# normal 6 elements GOTO clause: remeber tool vector
			set has_last_tool_vector 1
			set last_tool_vector(0) $i
			set last_tool_vector(1) $j
			set last_tool_vector(2) $k
		}
	}

	set mom_o_buffer [string trimright $mom_o_buffer ","]
	
	if {[string first "CYCLE/" $mom_o_buffer] == 0} {
		if {[string first "CYCLE/OFF" $mom_o_buffer] == 0} {
			if {[info exists cycle_was_off] } {
				if { $cycle_was_off == 1 } {
					set mom_o_buffer ""
					return
				} else {
					set cycle_was_off 1
				}
			} else {
				set cycle_was_off 1
			}
		} else {
			set cycle_was_off 0
		}
	}

	if {[string first "PAINT/" $mom_o_buffer] == 0} {
		set mom_o_buffer ""
	} elseif { $mom_my_cycle_retract_auto == 1 } {
		if { [info exists mom_my_cycle_auto_on] && $mom_my_cycle_auto_on == 1 } {
			if { [string first "GOTO/" $mom_o_buffer] == 0 } {
				set tmp [string trimleft $mom_o_buffer "GOTO/"]
				set x 0
				set y 0
				set z 0
				set n [scan $tmp "%f,%f,%f" x y z]
				######################################
				set x [expr $mom_my_cycle_pos(0)-$x]
				set y [expr $mom_my_cycle_pos(1)-$y]
				set z [expr $mom_my_cycle_pos(2)-$z]
				set x [expr $x*$x]
				set y [expr $y*$y]
				set z [expr $z*$z]
				set z [expr $x+$y+$z]
				set z [expr sqrt($z)]
				set pos [string first ",AUTO" $mom_my_cycle_auto]
				set s1 [string range $mom_my_cycle_auto 0 $pos]
				set s2 [string range $mom_my_cycle_auto [expr $pos+5] [string length $mom_my_cycle_auto]]
				set s ${s1}${z}${s2}
				set mom_o_buffer "${s}\n$mom_o_buffer"
				set mom_my_cycle_auto_on 0
			} elseif { [string first "CYCLE/Off" $mom_o_buffer] == 0} {
				set mom_o_buffer "${mom_my_cycle_auto}\n$mom_o_buffer"
				set mom_my_cycle_auto_on 0
			} else {
				append mom_my_cycle_auto "\n$mom_o_buffer"
				set mom_o_buffer ""
			}
		} elseif { [string first "CYCLE/" $mom_o_buffer] == 0} {
			set pos [string first ",RETURN,AUTO" $mom_o_buffer]
			if { $pos > 0 } {
				set mom_my_cycle_auto_on 1
				catch { unset mom_my_cycle_auto }
				set mom_my_cycle_auto $mom_o_buffer
				set mom_o_buffer "\$\$ $mom_o_buffer"
			}
		}
	} elseif { $mom_my_thread_cycle_filter == 0 && [string first "#1003:18/ON" $mom_o_buffer] == 0 } {
		##set mom_o_buffer [string replace $mom_o_buffer 0 7 "THREAD"]
		set len [string length $mom_o_buffer]
		set buf [string range $mom_o_buffer 8 [expr {$len-1}]]
		set mom_o_buffer "THREAD$buf"
		##
		set mom_my_thread_cycle_filter 1
	} elseif { $mom_my_thread_cycle_filter > 0 && [string first "GOTO/" $mom_o_buffer] == 0 } {
		incr mom_my_thread_cycle_filter 1
		if {$mom_my_thread_cycle_filter > 3} { set mom_o_buffer "" }
	} elseif { $mom_my_thread_cycle_filter > 1 && [string first "#1003:18/ON" $mom_o_buffer] == 0 } {
		set mom_o_buffer ""
	} elseif { [string first "#1003:18/OFF" $mom_o_buffer] == 0 } {
		##set mom_o_buffer [string replace $mom_o_buffer 0 7 "THREAD"]
		set len [string length $mom_o_buffer]
		set buf [string range $mom_o_buffer 8 [expr {$len-1}]]
		set mom_o_buffer "THREAD$buf"
		##
		set mom_my_thread_cycle_filter 0
	} elseif { $mom_my_thread_cycle_filter > 1} {
		if { [string first "GOTO/" $mom_o_buffer] == 0 || [string first "/" $mom_o_buffer] < 0 } {
			set mom_o_buffer ""
		} else {
			set mom_my_thread_cycle_filter 0
		}
	} elseif {[info exists mom_max_cut_traverse] && $mom_max_cut_traverse > 0.000001 } {
		MaxCutTraverse
	} elseif {[string length $mom_o_buffer] > $mom_my_max_length} {
		set str $mom_o_buffer
		set mom_o_buffer ""
		if {[string first ' $str] == -1} {
			set llen [string length $str]
			set ppos [string last "," $str $mom_my_max_length]
			set i 0
			while { $ppos != -1 && $llen > $mom_my_max_length} {
				set sarray($i) [string range $str 0 $ppos]\$\n
				incr i
				set str [string range $str [expr $ppos+1] [expr $llen-1]]
				set llen [string length $str]
				set ppos [string last "," $str $mom_my_max_length]
			}
			set result ""
			for {set x 0} {$x < $i} {incr x} {
				append result $sarray($x)
			}
			append result $str
			set mom_o_buffer $result
		} else {
			set llen [string length $str]
			set result [string range $str 0 [expr $mom_my_max_length-1]]
			append result "\$\n"
			append result [string range $str $mom_my_max_length [expr $llen-1]]
			set mom_o_buffer $result
		}
	}
}

###############################################################################
proc MOM_MaxCutTraverse {} {
global mom_max_cut_traverse
global last_command
global apply_rapid
global last_i last_j last_k
	if {[info exists mom_max_cut_traverse] && $mom_max_cut_traverse < 0.001 } {
		catch {unset mom_max_cut_traverse}
	} else {
		set apply_rapid 0
		set last_command ""
		set last_i 0
		set last_j 0
		set last_k 1
		MOM_output_literal "\$\$ Using Max Cut Traverse Control, MaxCutTraverse = [fm $mom_max_cut_traverse]"
	}
}

###############################################################################
proc MaxCutTraverse {} {
global mom_o_buffer
global last_command
global apply_rapid
global last_i last_j last_k
global mom_max_cut_traverse
	if {[info exists mom_max_cut_traverse] != 1} {return}
	if { $mom_max_cut_traverse <= 0 } {return}
	set cmd [string trim $mom_o_buffer]
	if {[string range $cmd 0 4] != "GOTO/"} {
		if {$cmd == "RAPID" && [string length $last_command] > 5} { set apply_rapid 1 }
	} else {
		if {[string range $last_command 0 4] != "GOTO/"} {
			set last_command $cmd
			set apply_rapid 0
		} else {
			set last_buf $cmd
			set i1 0
			set j1 0
			set k1 1
			set i2 0
			set j2 0
			set k2 1

			set tmp [string trimleft $last_command "GOTO/"]
			set n1 [scan $tmp "%f,%f,%f,%f,%f,%f" x1 y1 z1 i1 j1 k1]
			if {$n1 != 3 && $n1 != 6 } {return}

			set tmp [string trimleft $last_buf "GOTO/"]
			set n2 [scan $tmp "%f,%f,%f,%f,%f,%f" x2 y2 z2 i2 j2 k2]
			if {$n2 != 3 && $n2 != 6 } {return}

			if {$n1==3} {
				set i1 $last_i
				set j1 $last_j
				set k1 $last_k
			} elseif {$n1==6} {
				set last_i $i1
				set last_j $j1
				set last_k $k1
			} 

			if {$n2==6} {
				set last_i $i2
				set last_j $j2
				set last_k $k2
			}

			set a [expr $x2-$x1]
			set b [expr $y2-$y1]
			set c [expr $z2-$z1]
			set d [expr sqrt($a*$a+$b*$b+$c*$c)]

			if { $d > $mom_max_cut_traverse } {
				set divf1 [expr $d/$mom_max_cut_traverse]
				set divf2 [expr ceil($divf1)]
				set div [expr int($divf2)]

				set mom_o_buffer ""
				for {set p 1} {$p < $div} {incr p} {
					set x [fm [expr $x1+($x2-$x1)*$p/$div]]
					set y [fm [expr $y1+($y2-$y1)*$p/$div]]
					set z [fm [expr $z1+($z2-$z1)*$p/$div]]
					if {$n2==6} {
						set i [fm [expr $i1+($i2-$i1)*$p/$div]]
						set j [fm [expr $j1+($j2-$j1)*$p/$div]]
						set k [fm [expr $k1+($k2-$k1)*$p/$div]]
						if { $apply_rapid == 1 } {
							set mom_o_buffer "${mom_o_buffer}GOTO/$x,$y,$z,$i,$j,${k}\nRAPID\n"
						} else {
							set mom_o_buffer "${mom_o_buffer}GOTO/$x,$y,$z,$i,$j,${k}\n"
						}
					} else {
						if { $apply_rapid == 1 } {
							set mom_o_buffer "${mom_o_buffer}GOTO/$x,$y,${z}\nRAPID\n"
						} else {
							set mom_o_buffer "${mom_o_buffer}GOTO/$x,$y,${z}\n"
						}
					}
				}
				set mom_o_buffer ${mom_o_buffer}$last_buf
			}
			set apply_rapid 0
			set last_command $last_buf
		}
	}
}

###############################################################################
proc show_sync_status { } {
global mom_my_sync_primary_last
global mom_sync_affected
global mom_sync_primary
global mom_run_number
global mom_carrier_name
global mom_carrier_names
global mom_kin_merge_output_files
global mom_multi_channel_mode
global mom_number_of_runs
global mom_postprocessing_mode
global mom_channel_id
global mom_sync_status

global mom_motion_type
global mom_move_type
global mom_move_type_name
global mom_template_subtype

	if {[info exists mom_postprocessing_mode]} { MOM_output_literal "\$\$ post processing mode : $mom_postprocessing_mode" }
	if {[info exists mom_sync_status]} { MOM_output_literal "\$\$ sync status : $mom_sync_status" }
	if {[info exists mom_multi_channel_mode]} { MOM_output_literal "\$\$ multi channel mode : $mom_multi_channel_mode" }
	if {[info exists mom_sync_primary]} { MOM_output_literal "\$\$ sync primary : $mom_sync_primary" }
	if {[info exists mom_carrier_name]} { MOM_output_literal "\$\$ carrier : $mom_carrier_name" }
	if {[info exists mom_run_number]} { MOM_output_literal "\$\$ run number : $mom_run_number" }
	if {[info exists mom_channel_id]} { MOM_output_literal "\$\$ channel id : $mom_channel_id" }
	if {[info exists mom_number_of_runs]} { 
		MOM_output_literal "\$\$ number of runs : $mom_number_of_runs"
		for {set i 0} {$i < $mom_number_of_runs} {incr i} {
			MOM_output_literal "\$\$     sync affected $mom_sync_affected($i)"
		}
	}
	if {[info exists mom_motion_type]} { MOM_output_literal "\$\$ motion type : $mom_motion_type" }
	if {[info exists mom_move_type]} { MOM_output_literal "\$\$ move type : $mom_move_type" }
	if {[info exists mom_move_type_name]} { MOM_output_literal "\$\$ move type name : $mom_move_type_name" }
	if {[info exists mom_template_subtype]} { MOM_output_literal "\$\$ template subtype : $mom_template_subtype" }
	if {[info exists mom_my_sync_primary_last]} { MOM_output_literal "\$\$ last sync primary : $mom_my_sync_primary_last" }
}

###############################################################################
proc MOM_sync { } {
global mom_sync_code
global mom_sync_index
global mom_sync_start
global mom_sync_incr
global mom_sync_max
global mom_sync_number
global mom_sync_primary
global mom_run_number
global mom_number_of_runs
global mom_sync_both_flag
global mom_sync_main_flag
global mom_sync_side_flag
global mom_carrier_name
global mom_channel_id

	set mom_sync_start  0
	set mom_sync_incr   1
	set mom_sync_max    100

	#show_sync_status
	
	if { [info exists mom_run_number] && [info exists mom_channel_id] } {
		# output just once at the begining of the program
		if { $mom_run_number == 1 } {
			if { [info exists mom_sync_both_flag] == 0 || $mom_sync_both_flag == 0 } {
				MOM_output_literal "HEAD/BOTH" ;# temporary: output for main and side
				set mom_sync_both_flag 1
			}
		}

		# At the begining of the affected operations
		if { $mom_channel_id == 1 } {
			if { [info exists mom_sync_main_flag] == 0 || $mom_sync_main_flag == 0 } {
				MOM_output_literal "HEAD/MAIN,SPINDL,$mom_sync_primary"
				set mom_sync_main_flag 1
			}
		} else {
			if { [info exists mom_sync_side_flag] == 0 || $mom_sync_side_flag == 0 } {
				MOM_output_literal "HEAD/SIDE,SPINDL,$mom_sync_primary"
				set mom_sync_side_flag 1
			}
		}
	
		if {![info exists mom_sync_code] } { set mom_sync_code $mom_sync_start }
		set mom_sync_code [expr $mom_sync_code + $mom_sync_incr]
		#MOM_output_literal "WAITM($mom_sync_number,1,2)"
		
		MOM_output_literal HEAD/NEXT,$mom_sync_number,SPINDL,$mom_sync_primary
	}
}

###############################################################################
proc output_sync_off {} {
global mom_output_tape_file_full_name
global mom_output_file_full_name
global mom_output_cls_file_full_name
global mom_sys_output_file_suffix

global mom_run_number
global mom_number_of_runs
global mom_icam_version

global mom_part_name
	set output_name [file tail $mom_part_name]
	set pos [string last "." $output_name]
	if { $pos != -1 } { set output_name [string range $output_name 0 [expr $pos-1]].cls }
	set output_root "[file rootname $mom_output_file_full_name]"
	set pos1 [string last "\\" $output_root]
	set pos2 [string last "/" $output_root]
	if { $pos2 > $pos1 } {
		set pos $pos2
	} else {
		set pos $pos1
	}
	
	set output_root [string range $output_root 0 $pos]
	set output_cls_full_name "$output_root$output_name"

	set mom_output_tape_file_full_name ""
	
	if { [info exists mom_number_of_runs] && $mom_number_of_runs > 1 } {
		if { $mom_run_number == $mom_number_of_runs } {
			MOM_output_literal "HEAD/OFF"
			MOM_output_literal FINI
		}
		
		set original $mom_output_file_full_name
		set channel "_CHANNEL_"
		set output_full_name [string toupper [file rootname $original]]
		set pos [string last $channel $output_full_name]
		if { $pos != -1 } {
			if { $mom_run_number == $mom_number_of_runs } {
				# set output tape file
				set extension [file extension $original]
				set mom_output_cls_file_full_name $output_cls_full_name
				set mom_output_tape_file_full_name [file rootname $output_cls_full_name]$extension
			}

			if { $mom_run_number == 1 } {
				# clear existing files
				if {[file exists $output_cls_full_name]} {
					catch { file delete -force $output_cls_full_name }
				}
				# make a copy
				MOM_close_output_file $original
				catch { file copy -force $original $output_cls_full_name }
			} else {
				# get current content
				MOM_close_output_file $original
				set fsize [file size $original]
				set source [open $original r]
				set data2 [read $source $fsize]
				close $source
				# get tool description list
				set tools ""
				set pos [string first "#1003:9/'TOOL'," $data2]
				if { $pos != -1 } {
					set st $pos
					set pos [string first "PARTNO/" $data2]
					if { $pos != -1 } {
						set ed [expr $pos-1]
						set tools [string range $data2 $st $ed]
					}
				}
				# get data without header
				set pos [string first "UNITS/INCHES" $data2]
				if { $pos != -1 } {
					set st [expr $pos+13]
					set ed [string length $data2]
					set data2 [string range $data2 $st $ed]
				}
				# open previous file, it has to be exists
				if {[file exists $output_cls_full_name]} {
					set fsize [file size $output_cls_full_name]
					set source [open $output_cls_full_name r]
					set data1 [read $source $fsize]
					close $source
					# get previuos header till end of tool description list
					set pos [string first "PARTNO/" $data1]
					if { $pos != -1 } {
						# rewrite file
						set st [expr $pos-1]
						set ed [string length $data1]
						set target [open "$output_cls_full_name" "w"]
						puts -nonewline $target [string range $data1 0 $st]
						puts -nonewline $target $tools
						puts -nonewline $target [string range $data1 $pos $ed]
						puts -nonewline $target $data2
						close $target
					} else {
						# directly combine without tool description list
						set target [open "$output_cls_full_name" "a+"]
						puts -nonewline $target $data2
						close $target
					}
				}
			}
			# clean up
			if {[file exists $output_cls_full_name]} { catch { file delete -force $original } }
		}
	} elseif { [info exists mom_icam_version] } {
		MOM_output_literal FINI
		set output_file_full_name [string toupper $mom_output_file_full_name]
		set mom_output_cls_file_full_name $output_file_full_name
		set cls [file rootname $output_file_full_name].CLS
	
		if { $cls != $output_file_full_name } {
			MOM_close_output_file $mom_output_file_full_name
			set mom_output_tape_file_full_name $output_file_full_name
			set mom_output_cls_file_full_name $cls

			if {[file exists $cls]} {catch {file delete -force $cls} }
			catch {file copy -force $output_file_full_name $cls}

		} else {
			MOM_close_output_file $mom_output_file_full_name
			if { [info exists mom_sys_output_file_suffix] } {
				set mom_output_tape_file_full_name [file rootname $output_file_full_name].$mom_sys_output_file_suffix
			} else {
				set mom_output_tape_file_full_name [file rootname $output_file_full_name].tap
			}
		}
	} else {
		MOM_output_literal FINI
	}
}

###############################################################################
proc output_multax {} {
global mom_my_multax_flag
global mom_my_this_apply
	if {$mom_my_this_apply == "APPLY/MILL"} {
		if { $mom_my_multax_flag == "OFF" } {
			set mom_my_multax_flag "ON"
			MOM_output_literal "MULTAX/ON"
		}
	}
}

if {[file exists $mom_icam_custom]} { source $mom_icam_custom }
if {[file exists $mom_customer_custom]} { source $mom_customer_custom }

###############################################################################
proc MOM_end_of_program {} {
	output_sync_off
}

###############################################################################
proc MOM_wire_feed_rate {} {
global mom_Appended_Text
global mom_wire_feed_rate
	if { [info exist mom_Appended_Text] && $mom_Appended_Text != "" } { 
		MOM_output_literal FEDRAT/$mom_wire_feed_rate,$mom_Appended_Text 
	} else {
		MOM_output_literal FEDRAT/$mom_wire_feed_rate
	}
	set mom_Appended_Text ""
}

###############################################################################
proc MOM_cut_wire {} {
global mom_cut_wire_text ;     #associated text
global mom_allow_load_wire
	set allow_load_wire 1
	if { [info exists mom_cut_wire_text] && $mom_cut_wire_text != "" } {
		MOM_output_literal UNLOAD/WIRE,$mom_cut_wire_text
	} else {
		MOM_output_literal UNLOAD/WIRE
	}
	set mom_cut_wire_text ""
}

###############################################################################
proc MOM_thread_wire {} {
global mom_thread_wire_text
global mom_operation_type
global mom_allow_load_wire
	if { [info exists mom_allow_load_wire] == 0 || $mom_allow_load_wire != 1 } { return }
	if { [info exists mom_thread_wire_text] && $mom_thread_wire_text != "" } {
		MOM_output_literal LOAD/WIRE,$mom_thread_wire_text
	} else {
		MOM_output_literal LOAD/WIRE
	}
	set mom_thread_wire_text ""
	set mom_allow_load_wire 0
}

###############################################################################
proc MOM_wire_angles {} {
global mom_wire_slope ;      #tilt sideways the direction of 
                             #motion(+right)
global mom_wire_angle ;      #tilt along the direction of motion
                             #(+forward)
global mom_wire_angle_text ; #associated text
global mom_wire_angle_defined ; #angle defined flag
	set s ""
	if { [info exists mom_wire_angle_text] && $mom_wire_angle_text != "" } { set s ,$mom_wire_angle_text } 
	if {[info exists mom_wire_angle_defined] && $mom_wire_angle_defined == 1 && [info exists mom_wire_angle] } {
		MOM_output_literal STAN/SLOPE,$mom_wire_slope,ANGLE,$mom_wire_angle$s
	} else {
		MOM_output_literal STAN/SLOPE,$mom_wire_slope$s
	}
	set mom_wire_angle_text ""
}

###############################################################################
proc MOM_wire_cutcom {} {
global mom_wire_cutcom_status
global mom_wire_cutcom_mode ;            #RIGHT, LEFT, ON, OFF
global mom_wire_cutcom_adjust_register ; #register number(integer)
global mom_wire_cutcom_text ;            #associated text
	if {[info exists mom_wire_cutcom_status]} {
		set s CUTCOM/$mom_wire_cutcom_mode
		if {$mom_wire_cutcom_status == "SAME"} {
			set s CUTCOM/ON
		} elseif {$mom_wire_cutcom_status == "OFF"} {
			set s CUTCOM/OFF
		}
		if {[info exists mom_wire_cutcom_adjust_register] == 1} {
			append s ,$mom_wire_cutcom_adjust_register
		}
		if { [info exists mom_wire_cutcom_text] && $mom_wire_cutcom_text != "" } {
			append s ,$mom_wire_cutcom_text
		} 
		MOM_output_literal $s
	} elseif { [info exists mom_wire_cutcom_text] && $mom_wire_cutcom_text != "" } {
		MOM_output_literal CUTCOM/$mom_wire_cutcom_text
	} 
	catch {unset mom_wire_cutcom_adjust_register}
	set mom_wire_cutcom_text ""
}

###############################################################################
proc MOM_wire_guides {} {
global mom_wire_guides_text ;        #associated text
global mom_wire_guides_upper_plane
global mom_wire_guides_lower_plane
	set s ""
	if { [info exists mom_wire_guides_text] && $mom_wire_guides_text != "" } { set s ,$mom_wire_guides_text } 
	MOM_output_literal SET/UPPER,$mom_wire_guides_upper_plane,LOWER,$mom_wire_guides_lower_plane$s
	set mom_wire_guides_text ""
}

###############################################################################
proc output_blank_block {} {
global mom_blank_block_center	; #[3]
global mom_blank_block_feature_matrix	;	#[9]
global mom_blank_block_height
global mom_blank_block_length
global mom_blank_block_width
global mom_blank_geometry_type
global mom_bounding_geometry_axis_type
global mom_blank_auto_box_deltas	;	#[6]

	if { [info exists mom_blank_geometry_type] && $mom_blank_geometry_type == 3 } {
		if { [info exists mom_blank_block_feature_matrix] } {
			set orig0 0
			set orig1 0
			set orig2 0
			if { [info exists mom_blank_block_center] } {
				set orig0 [ffm $mom_blank_block_center(0)]
				set orig1 [ffm $mom_blank_block_center(1)]
				set orig2 [ffm $mom_blank_block_center(2)]
			}
			set msys0 [ffm $mom_blank_block_feature_matrix(0)]
			set msys1 [ffm $mom_blank_block_feature_matrix(1)]
			set msys3 [ffm $mom_blank_block_feature_matrix(3)]
			set msys4 [ffm $mom_blank_block_feature_matrix(4)]
			set msys6 [ffm $mom_blank_block_feature_matrix(6)]
			set msys7 [ffm $mom_blank_block_feature_matrix(7)]
			MOM_output_literal "#1003:30/ORIENT,$orig0,$orig1,$orig2,$msys0,$msys3,$msys6,$msys1,$msys4,$msys7"
		}
	}
	if { [info exists mom_blank_block_height] && [info exists mom_blank_block_length] && [info exists mom_blank_block_width] } {
		set length [ffm $mom_blank_block_length]
		set width [ffm $mom_blank_block_width]
		set height [ffm $mom_blank_block_height]
		if { [info exists mom_blank_auto_box_deltas] } {
			set x [expr $mom_blank_auto_box_deltas(0)-$mom_blank_auto_box_deltas(1)]
			set y [expr $mom_blank_auto_box_deltas(2)-$mom_blank_auto_box_deltas(3)]
			set z [expr $mom_blank_auto_box_deltas(4)-$mom_blank_auto_box_deltas(5)]
			set length [ffm [expr $length+$x]]
			set width [ffm [expr $width+$y]]
			set height [ffm [expr $height+$z]]
		}
		MOM_output_literal "#1003:30/SIZE,$length,$width,$height"
	}
}

proc use_group_name_2 { } {
global mom_output_file_full_name
global mom_output_tape_file_full_name

	if { [info exists mom_output_tape_file_full_name] && [file exists $mom_output_tape_file_full_name] } {
		catch {file copy -force $mom_output_tape_file_full_name $mom_output_file_full_name}
	}
}

proc use_group_name { filename } {
upvar $filename v
global mom_parent_group_name

	if { [info exists mom_parent_group_name] && [info exists v] } {
		set output_file [file rootname $v]

		set pos1 [string last "\\" $output_file]
		set pos2 [string last "/" $output_file]
		set pos -1
		if { $pos1 > $pos2 } {
			set pos $pos1
		} else {
			set pos $pos2
		}

		if { $pos != -1 } {
			set output_file [string range $output_file 0 $pos]
			append output_file $mom_parent_group_name
			append output_file [file extension $v]
			set v $output_file
			return 1
		}
	}
	return 0
}

proc use_group_name_1 { } {
global mom_parent_group_name
global mom_output_tape_file_full_name
global mom_output_cls_file_full_name

	if { [info exists mom_parent_group_name] } {
		if { [info exists mom_output_tape_file_full_name] } { 
			# update tape file name
			if { [use_group_name mom_output_tape_file_full_name] } {
				catch {file delete -force $mom_output_tape_file_full_name}
			}
		}
		if { [info exists mom_output_cls_file_full_name] } { 
			# update cls file name
			set src $mom_output_cls_file_full_name
			if { [use_group_name mom_output_cls_file_full_name] } {
				# copy cls to keep CLS fro review in case NC output is skipped
				if {[file exists $src]} {
					catch {file copy -force $src $mom_output_cls_file_full_name}
				}
			}
		}
	}
}

###############################################################################
proc MOM_level_marker { } {
global mom_level_number
	#MOM_output_literal "AM/SET,$mom_level_number"
}

###############################################################################
proc MOM_laserpower { } {
global mom_power_level
	#MOM_output_literal "AM/POWER,$mom_power_level"
}

###############################################################################
proc MOM_rpm_exstruder { } {
}

###############################################################################
proc MOM_path_region_marker_start { } {
global mom_level_number
global mom_power_level
global mom_feed_cut_value
global mom_output_am
	if { [info exists mom_output_am] && $mom_output_am == 1 } {
		set am "AM/ON"
		if { [info exists mom_level_number] } { append am ",SET,$mom_level_number" }
		if { [info exists mom_power_level] } { append am ",POWER,$mom_power_level"}
		if { [info exists mom_feed_cut_value] } { 
			# using fedrate to control am/on,off
			append am ",'FEDRAT',[fm $mom_feed_cut_value]" 
			MOM_output_literal "\$\$ $am"
		}
	}
}

###############################################################################
proc MOM_path_region_marker_end { } {
global mom_delay_value
global mom_output_am
	if { [info exists mom_output_am] && $mom_output_am == 1 } {
		MOM_output_literal "\$\$ AM/OFF"
	}
}

###############################################################################
proc MOM_pattern_marker_finish_pass { } {
global mom_pattern_marker_state
}

###############################################################################
proc MOM_pattern_marker_infill { } {
global mom_pattern_marker_state
	MOM_output_literal "#1003:26/AM,'INFILL'"
}


###############################################################################
proc MOM_get_ask_oper_csys { } {
global mom_operation_name
global mom_result
global mom_result1
global mom_result2
	
	
	if { [info exists mom_operation_name] } {
	
		MOM_ask_oper_csys $mom_operation_name 
		
		MOM_output_literal "#1003:15/MSYS,MODE,$mom_result"
		
		MOM_output_literal "#1003:15/OP,MSYS,[fm [lindex $mom_result1 0]],[fm [lindex $mom_result1 1]],[fm [lindex $mom_result1 2]] ,[fm [lindex $mom_result1 9]],[fm [lindex $mom_result1 3]],[fm [lindex $mom_result1 4]],[fm [lindex $mom_result1 5]] ,[fm [lindex $mom_result1 10]],[fm [lindex $mom_result1 6]],[fm [lindex $mom_result1 7]],[fm [lindex $mom_result1 8]],[fm [lindex $mom_result1 11]]"
		
		MOM_output_literal "#1003:15/MACHIN,MSYS,[fm [lindex $mom_result2 0]],[fm [lindex $mom_result2 1]],[fm [lindex $mom_result2 2]] ,[fm [lindex $mom_result2 9]],[fm [lindex $mom_result2 3]],[fm [lindex $mom_result2 4]],[fm [lindex $mom_result2 5]] ,[fm [lindex $mom_result2 10]],[fm [lindex $mom_result2 6]],[fm [lindex $mom_result2 7]],[fm [lindex $mom_result2 8]],[fm [lindex $mom_result2 11]]"      
		
	}
}

