vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../ipstatic" \
"../../../../Projet_3.gen/sources_1/ip/MMCM/MMCM_clk_wiz.v" \
"../../../../Projet_3.gen/sources_1/ip/MMCM/MMCM.v" \


vlog -work xil_defaultlib \
"glbl.v"

