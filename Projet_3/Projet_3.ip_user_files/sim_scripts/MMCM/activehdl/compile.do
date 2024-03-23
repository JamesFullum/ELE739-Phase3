transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vmap -link {C:/Users/james/ETS/Hiver_2024/ELE739/ELE739-Projet_3/Projet_3/Projet_3.cache/compile_simlib/activehdl}
vlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" -l xil_defaultlib \
"../../../../Projet_3.gen/sources_1/ip/MMCM/MMCM_clk_wiz.v" \
"../../../../Projet_3.gen/sources_1/ip/MMCM/MMCM.v" \


vlog -work xil_defaultlib \
"glbl.v"

