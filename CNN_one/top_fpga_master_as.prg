usb_connect
if { [as_device_id] } {
  as_write  ./top_fpga_master.bin
  as_verify ./top_fpga_master.bin
}
usb_close
