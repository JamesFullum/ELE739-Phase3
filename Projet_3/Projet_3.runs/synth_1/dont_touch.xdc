# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: imports/new/Basys_3.xdc

# IP: ip/MMCM/MMCM.xci
set_property KEEP_HIERARCHY SOFT [get_cells -hier -filter {REF_NAME==MMCM || ORIG_REF_NAME==MMCM} -quiet] -quiet

# XDC: c:/Users/james/ETS/Hiver_2024/ELE739/ELE739-Projet_3/Projet_3/Projet_3.gen/sources_1/ip/MMCM/MMCM_board.xdc
set_property KEEP_HIERARCHY SOFT [get_cells [split [join [get_cells -hier -filter {REF_NAME==MMCM || ORIG_REF_NAME==MMCM} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: c:/Users/james/ETS/Hiver_2024/ELE739/ELE739-Projet_3/Projet_3/Projet_3.gen/sources_1/ip/MMCM/MMCM.xdc
#dup# set_property KEEP_HIERARCHY SOFT [get_cells [split [join [get_cells -hier -filter {REF_NAME==MMCM || ORIG_REF_NAME==MMCM} -quiet] {/inst } ]/inst ] -quiet] -quiet

# XDC: c:/Users/james/ETS/Hiver_2024/ELE739/ELE739-Projet_3/Projet_3/Projet_3.gen/sources_1/ip/MMCM/MMCM_ooc.xdc