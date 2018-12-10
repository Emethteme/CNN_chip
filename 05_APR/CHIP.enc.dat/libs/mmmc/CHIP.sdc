###################################################################
set sdc_version 1.7

#define your sdc here
create_clock -name "CLK" -add -period 10.0 -waveform {0.0 4.0} [get_ports clk]
set_propagated_clock [all_clocks]

set_clock_gating_check -setup 0.0
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports rst_n]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_valid_1}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_valid_2}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[0]}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[1]}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[2]}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[3]}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[4]}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[5]}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[6]}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[7]}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[8]}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[9]}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[10]}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[11]}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[12]}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[13]}]
set_input_delay -clock [get_clocks CLK] -add_delay 4.0 [get_ports {in_data[14]}]


set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {out_valid}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {number_2}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {number_4}]
set_output_delay -clock [get_clocks CLK] -add_delay 1.0 [get_ports {number_6}]