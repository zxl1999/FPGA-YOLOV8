map -import

if { [info exists DESIGN] && ! [info exists TOP_MODULE] } {
  set TOP_MODULE "$DESIGN"
}
if { ! [info exists DESIGN] } {
  set DESIGN "top_fpga"
}
if { ! [info exists TOP_MODULE] } {
  set TOP_MODULE "top_fpga"
}

set verilogs { D:\\ETree_Board\\ETree_F01\\AG10KL\\Project\\05_OV7670_NET\\quartus_prj\\rtl\\eth_udp\\mii_to_rmii.v D:\\ETree_Board\\ETree_F01\\AG10KL\\Project\\05_OV7670_NET\\quartus_prj\\rtl\\eth_udp\\ip_send.v D:\\ETree_Board\\ETree_F01\\AG10KL\\Project\\05_OV7670_NET\\quartus_prj\\rtl\\eth_udp\\eth_udp.v D:\\ETree_Board\\ETree_F01\\AG10KL\\Project\\05_OV7670_NET\\quartus_prj\\rtl\\eth_udp\\crc32.v D:\\ETree_Board\\ETree_F01\\AG10KL\\Project\\05_OV7670_NET\\quartus_prj\\rtl\\I2C_OV7670_Config.v D:\\ETree_Board\\ETree_F01\\AG10KL\\Project\\05_OV7670_NET\\quartus_prj\\rtl\\I2C_Controller.v D:\\ETree_Board\\ETree_F01\\AG10KL\\Project\\05_OV7670_NET\\quartus_prj\\rtl\\I2C_AV_Config.v D:\\ETree_Board\\ETree_F01\\AG10KL\\Project\\05_OV7670_NET\\quartus_prj\\rtl\\cmos1_fifo.v D:\\ETree_Board\\ETree_F01\\AG10KL\\Project\\05_OV7670_NET\\quartus_prj\\rtl\\alt_pll.v D:\\ETree_Board\\ETree_F01\\AG10KL\\Project\\05_OV7670_NET\\quartus_prj\\rtl\\camera_if.v D:\\ETree_Board\\ETree_F01\\AG10KL\\Project\\05_OV7670_NET\\quartus_prj\\rtl\\top_fpga.v }
if { [ llength $verilogs ] == 0 } {
  set verilogs "D:/ETree_Board/ETree_F01/AG10KL/Project/05_OV7670_NET/quartus_prj/${DESIGN}.v"
}
foreach verilog $verilogs {
  read_verilog "$verilog"
}

  read_verilog -sv -lib +/agm/rodina/cells_sim.v
  read_verilog -sv -lib +/agm/common/m9k_bb.v
  read_verilog -sv -lib +/agm/common/altpll_bb.v
  hierarchy -check -top ${TOP_MODULE}

  synth -run coarse -top ${DESIGN}

  map proc
  opt_expr
  opt_clean
  check
  opt

  wreduce
  alumacc
  share
  opt
  fsm
  opt -fast
  memory -nomap
  opt_clean

  memory_bram -rules +/agm/common/brams.txt
  techmap -map +/agm/common/brams_map.v

  opt -fast -mux_undef -undriven -fine -full
  memory_map
  opt -undriven -fine

  techmap -autoproc -map +/techmap.v -map +/agm/rodina/arith_map.v
  dffsr2dff
  dff2dffe -direct-match \$_DFF_*
  opt -full

  techmap -map +/agm/rodina/cells_map.v
  agm_dffeas
  opt -full

  clean -purge
  setundef -undriven -zero
  abc -markgroups -dff
  opt_expr -mux_undef -undriven -full
  opt_merge
  opt_rmdff
  opt_clean

  abc -lut 4
  clean

  techmap -map +/agm/rodina/cells_map.v
  dffinit -ff dffeas Q INIT
  clean -purge

  hierarchy -check
  check -noinit

  write_verilog -bitblasted -attr2comment -defparam -decimal -renameprefix syn_ ${DESIGN}.vqm
# exec sed -i "/\\\\\\\$paramod/s/\[$=\\]/_/g" ${DESIGN}.vqm

