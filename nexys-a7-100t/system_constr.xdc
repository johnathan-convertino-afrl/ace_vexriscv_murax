set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]


## I/O delay constraints
create_clock -period 10.000 -name VIRTUAL_clk_out1_system_clk_wiz_1 -waveform {0.000 5.000}

set_input_delay -clock VIRTUAL_clk_out1_system_clk_wiz_1 -max 50.000 [get_ports ftdi_tx]
set_input_delay -clock VIRTUAL_clk_out1_system_clk_wiz_1 -min 20.000 [get_ports ftdi_tx]
set_output_delay -clock VIRTUAL_clk_out1_system_clk_wiz_1 -max 50.000 [get_ports ftdi_rx]
set_output_delay -clock VIRTUAL_clk_out1_system_clk_wiz_1 -min 20.000 [get_ports ftdi_rx]
set_input_delay -clock VIRTUAL_clk_out1_system_clk_wiz_1 -max 100.000 [get_ports resetn]
set_input_delay -clock VIRTUAL_clk_out1_system_clk_wiz_1 -min 50.000 [get_ports resetn]

## it doesn't actually matter
set_false_path -through [get_ports ftdi_tx]
set_false_path -through [get_ports ftdi_rx]
set_false_path -through [get_ports resetn]


set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]






