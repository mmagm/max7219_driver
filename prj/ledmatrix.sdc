create_clock -period "50.0 MHz" [get_ports clk]
create_clock -period "1 MHz" [get_ports sck]

derive_clock_uncertainty

set_false_path -from * -to [get_ports {sw_rst_n}]

set_false_path -from [get_ports {cs}]  -to [all_clocks]
set_false_path -from [get_ports {dout}]  -to [all_clocks]
