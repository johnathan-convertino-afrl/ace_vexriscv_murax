# NOT USED, KEPT FOR REFERENCE
# set freq hz of the clk to 48MHz, and set verilog parameter of top level.
# set_property CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {48} [get_ips clk_wiz_1]
# set CLK_FREQ_MHZ [get_property CONFIG.CLKOUT1_REQUESTED_OUT_FREQ [get_ips clk_wiz_1]]
# set_property generic clock_speed=[ expr $CLK_FREQ_MHZ * 1000000 ] [current_fileset]
# generate_target all [get_ips]
# ip_vlvn_version_check "xilinx.com:ip:mig_7series:4.2"
#
# create_ip  -vlnv xilinx.com:ip:mig_7series:4.2 -module_name  native_ddr_ctrl
# set native_ddr_cntrl_dir [get_property IP_DIR [get_ips [get_property CONFIG.Component_Name [get_ips native_ddr_ctrl]]]]
# file copy -force ddr_mig.prj "$native_ddr_cntrl_dir/"
# set_property CONFIG.XML_INPUT_FILE ddr_mig.prj [get_ips native_ddr_ctrl]

# create a pll clock IP with a 100 MHz clock
# create_ip -vlnv xilinx.com:ip:clk_wiz:6.0 -module_name clk_wiz_1
# set_property CONFIG.PRIMITIVE MMCM [get_ips clk_wiz_1]
# set_property CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 100 [get_ips clk_wiz_1]
# set_property CONFIG.USE_LOCKED false [get_ips clk_wiz_1]
# set_property CONFIG.PRIM_IN_FREQ 100.000 [get_ips clk_wiz_1]
# set_property CONFIG.USE_RESET true [get_ips clk_wiz_1]
# set_property CONFIG.RESET_TYPE {ACTIVE_LOW} [get_ips clk_wiz_1]
# set_property CONFIG.RESET_PORT {resetn} [get_ips clk_wiz_1]

# set_property generate_synth_checkpoint false [get_files native_ddr_ctrl.xci]
