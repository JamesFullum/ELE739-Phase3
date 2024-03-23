vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../ipstatic" \
"../../../../Projet_3.gen/sources_1/ip/MMCM/MMCM_clk_wiz.v" \
"../../../../Projet_3.gen/sources_1/ip/MMCM/MMCM.v" \


vlog -work xil_defaultlib \
"glbl.v"

