set_property SRC_FILE_INFO {cfile:c:/Users/james/ETS/Hiver_2024/ELE739/ELE739-Projet_3/Projet_3/Projet_3.gen/sources_1/ip/MMCM/MMCM.xdc rfile:../Projet_3.gen/sources_1/ip/MMCM/MMCM.xdc id:1 order:EARLY scoped_inst:DUT_INST/MMCM_INST/inst} [current_design]
current_instance DUT_INST/MMCM_INST/inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.100
