create_clock -name clk_50m -period 20.000 [get_ports {clk}]
create_clock -name cmos_pclk -period 40.000 [get_ports {cam_pclk}]
create_clock -name clk_net -period 40.000 [get_ports {e_rxclk}]
derive_pll_clocks -create_base_clocks

