onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /SRRNet_top_tb/OCS_controller_u0/w_chnl_ready
add wave -noupdate /SRRNet_top_tb/OCS_controller_u0/w_new_slot_start
add wave -noupdate /SRRNet_top_tb/OCS_controller_u0/w_slot_id
add wave -noupdate /SRRNet_top_tb/OCS_controller_u0/ocs_slot_ctrl_u0/r_config_flag
add wave -noupdate -group tor0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tvalid}
add wave -noupdate -group tor0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tdata}
add wave -noupdate -group tor0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tlast}
add wave -noupdate -group tor0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/w_dealy}
add wave -noupdate -group tor0 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy}
add wave -noupdate -group tor0 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy_cnt}
add wave -noupdate -group tor0 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_pkt_cnt}
add wave -noupdate -group tor0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tvalid}
add wave -noupdate -group tor0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tdata}
add wave -noupdate -group tor0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tlast}
add wave -noupdate -group tor0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/w_dealy}
add wave -noupdate -group tor0 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy}
add wave -noupdate -group tor0 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy_cnt}
add wave -noupdate -group tor0 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_pkt_cnt}
add wave -noupdate -group tor1 {/SRRNet_top_tb/gen_loop[1]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tvalid}
add wave -noupdate -group tor1 {/SRRNet_top_tb/gen_loop[1]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tdata}
add wave -noupdate -group tor1 {/SRRNet_top_tb/gen_loop[1]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tlast}
add wave -noupdate -group tor1 {/SRRNet_top_tb/gen_loop[1]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/w_dealy}
add wave -noupdate -group tor1 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[1]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy}
add wave -noupdate -group tor1 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[1]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy_cnt}
add wave -noupdate -group tor1 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[1]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_pkt_cnt}
add wave -noupdate -group tor1 {/SRRNet_top_tb/gen_loop[1]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tvalid}
add wave -noupdate -group tor1 {/SRRNet_top_tb/gen_loop[1]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tdata}
add wave -noupdate -group tor1 {/SRRNet_top_tb/gen_loop[1]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tlast}
add wave -noupdate -group tor1 {/SRRNet_top_tb/gen_loop[1]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/w_dealy}
add wave -noupdate -group tor1 -color Magenta {/SRRNet_top_tb/gen_loop[1]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy}
add wave -noupdate -group tor1 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[1]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy_cnt}
add wave -noupdate -group tor1 -color Magenta {/SRRNet_top_tb/gen_loop[1]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_pkt_cnt}
add wave -noupdate -group tor2 {/SRRNet_top_tb/gen_loop[2]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tvalid}
add wave -noupdate -group tor2 {/SRRNet_top_tb/gen_loop[2]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tdata}
add wave -noupdate -group tor2 {/SRRNet_top_tb/gen_loop[2]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tlast}
add wave -noupdate -group tor2 {/SRRNet_top_tb/gen_loop[2]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/w_dealy}
add wave -noupdate -group tor2 -color Magenta {/SRRNet_top_tb/gen_loop[2]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy}
add wave -noupdate -group tor2 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[2]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy_cnt}
add wave -noupdate -group tor2 -color Magenta {/SRRNet_top_tb/gen_loop[2]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_pkt_cnt}
add wave -noupdate -group tor2 {/SRRNet_top_tb/gen_loop[2]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tvalid}
add wave -noupdate -group tor2 {/SRRNet_top_tb/gen_loop[2]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tdata}
add wave -noupdate -group tor2 {/SRRNet_top_tb/gen_loop[2]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tlast}
add wave -noupdate -group tor2 {/SRRNet_top_tb/gen_loop[2]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/w_dealy}
add wave -noupdate -group tor2 -color Magenta {/SRRNet_top_tb/gen_loop[2]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy}
add wave -noupdate -group tor2 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[2]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy_cnt}
add wave -noupdate -group tor2 -color Magenta {/SRRNet_top_tb/gen_loop[2]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_pkt_cnt}
add wave -noupdate -group tor3 {/SRRNet_top_tb/gen_loop[3]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tvalid}
add wave -noupdate -group tor3 {/SRRNet_top_tb/gen_loop[3]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tdata}
add wave -noupdate -group tor3 {/SRRNet_top_tb/gen_loop[3]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tlast}
add wave -noupdate -group tor3 {/SRRNet_top_tb/gen_loop[3]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/w_dealy}
add wave -noupdate -group tor3 -color Magenta {/SRRNet_top_tb/gen_loop[3]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy}
add wave -noupdate -group tor3 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[3]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy_cnt}
add wave -noupdate -group tor3 -color Magenta {/SRRNet_top_tb/gen_loop[3]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_pkt_cnt}
add wave -noupdate -group tor3 {/SRRNet_top_tb/gen_loop[3]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tvalid}
add wave -noupdate -group tor3 {/SRRNet_top_tb/gen_loop[3]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tdata}
add wave -noupdate -group tor3 {/SRRNet_top_tb/gen_loop[3]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tlast}
add wave -noupdate -group tor3 {/SRRNet_top_tb/gen_loop[3]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/w_dealy}
add wave -noupdate -group tor3 -color Magenta {/SRRNet_top_tb/gen_loop[3]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy}
add wave -noupdate -group tor3 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[3]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy_cnt}
add wave -noupdate -group tor3 -color Magenta {/SRRNet_top_tb/gen_loop[3]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_pkt_cnt}
add wave -noupdate -group tor4 {/SRRNet_top_tb/gen_loop[4]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tvalid}
add wave -noupdate -group tor4 {/SRRNet_top_tb/gen_loop[4]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tdata}
add wave -noupdate -group tor4 {/SRRNet_top_tb/gen_loop[4]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tlast}
add wave -noupdate -group tor4 {/SRRNet_top_tb/gen_loop[4]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/w_dealy}
add wave -noupdate -group tor4 -color Magenta {/SRRNet_top_tb/gen_loop[4]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy}
add wave -noupdate -group tor4 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[4]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy_cnt}
add wave -noupdate -group tor4 -color Magenta {/SRRNet_top_tb/gen_loop[4]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_pkt_cnt}
add wave -noupdate -group tor4 {/SRRNet_top_tb/gen_loop[4]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tvalid}
add wave -noupdate -group tor4 {/SRRNet_top_tb/gen_loop[4]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tdata}
add wave -noupdate -group tor4 {/SRRNet_top_tb/gen_loop[4]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tlast}
add wave -noupdate -group tor4 {/SRRNet_top_tb/gen_loop[4]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/w_dealy}
add wave -noupdate -group tor4 -color Magenta {/SRRNet_top_tb/gen_loop[4]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy}
add wave -noupdate -group tor4 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[4]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy_cnt}
add wave -noupdate -group tor4 -color Magenta {/SRRNet_top_tb/gen_loop[4]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_pkt_cnt}
add wave -noupdate -group tor5 {/SRRNet_top_tb/gen_loop[5]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tvalid}
add wave -noupdate -group tor5 {/SRRNet_top_tb/gen_loop[5]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tdata}
add wave -noupdate -group tor5 {/SRRNet_top_tb/gen_loop[5]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tlast}
add wave -noupdate -group tor5 {/SRRNet_top_tb/gen_loop[5]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/w_dealy}
add wave -noupdate -group tor5 -color Magenta {/SRRNet_top_tb/gen_loop[5]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy}
add wave -noupdate -group tor5 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[5]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy_cnt}
add wave -noupdate -group tor5 -color Magenta {/SRRNet_top_tb/gen_loop[5]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_pkt_cnt}
add wave -noupdate -group tor5 {/SRRNet_top_tb/gen_loop[5]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tvalid}
add wave -noupdate -group tor5 {/SRRNet_top_tb/gen_loop[5]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tdata}
add wave -noupdate -group tor5 {/SRRNet_top_tb/gen_loop[5]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tlast}
add wave -noupdate -group tor5 {/SRRNet_top_tb/gen_loop[5]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/w_dealy}
add wave -noupdate -group tor5 -color Magenta {/SRRNet_top_tb/gen_loop[5]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy}
add wave -noupdate -group tor5 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[5]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy_cnt}
add wave -noupdate -group tor5 -color Magenta {/SRRNet_top_tb/gen_loop[5]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_pkt_cnt}
add wave -noupdate -group tor6 {/SRRNet_top_tb/gen_loop[6]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tvalid}
add wave -noupdate -group tor6 {/SRRNet_top_tb/gen_loop[6]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tdata}
add wave -noupdate -group tor6 {/SRRNet_top_tb/gen_loop[6]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tlast}
add wave -noupdate -group tor6 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[6]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy}
add wave -noupdate -group tor6 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[6]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy_cnt}
add wave -noupdate -group tor6 {/SRRNet_top_tb/gen_loop[6]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/w_dealy}
add wave -noupdate -group tor6 -color Magenta {/SRRNet_top_tb/gen_loop[6]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_pkt_cnt}
add wave -noupdate -group tor6 {/SRRNet_top_tb/gen_loop[6]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tvalid}
add wave -noupdate -group tor6 {/SRRNet_top_tb/gen_loop[6]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tdata}
add wave -noupdate -group tor6 {/SRRNet_top_tb/gen_loop[6]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tlast}
add wave -noupdate -group tor6 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[6]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy}
add wave -noupdate -group tor6 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[6]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy_cnt}
add wave -noupdate -group tor6 {/SRRNet_top_tb/gen_loop[6]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/w_dealy}
add wave -noupdate -group tor6 -color Magenta {/SRRNet_top_tb/gen_loop[6]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_pkt_cnt}
add wave -noupdate -group tor7 {/SRRNet_top_tb/gen_loop[7]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tvalid}
add wave -noupdate -group tor7 {/SRRNet_top_tb/gen_loop[7]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tdata}
add wave -noupdate -group tor7 {/SRRNet_top_tb/gen_loop[7]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/s_axis_rx_tlast}
add wave -noupdate -group tor7 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[7]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy}
add wave -noupdate -group tor7 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[7]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_dealy_cnt}
add wave -noupdate -group tor7 {/SRRNet_top_tb/gen_loop[7]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/w_dealy}
add wave -noupdate -group tor7 -color Magenta {/SRRNet_top_tb/gen_loop[7]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port0/r_pkt_cnt}
add wave -noupdate -group tor7 {/SRRNet_top_tb/gen_loop[7]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tvalid}
add wave -noupdate -group tor7 {/SRRNet_top_tb/gen_loop[7]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tdata}
add wave -noupdate -group tor7 {/SRRNet_top_tb/gen_loop[7]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/s_axis_rx_tlast}
add wave -noupdate -group tor7 -radix unsigned {/SRRNet_top_tb/gen_loop[7]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/w_dealy}
add wave -noupdate -group tor7 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[7]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy}
add wave -noupdate -group tor7 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[7]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_dealy_cnt}
add wave -noupdate -group tor7 -color Magenta -radix unsigned {/SRRNet_top_tb/gen_loop[7]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/ten_eth_rx_uplink_port1/r_pkt_cnt}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/i_clk}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/i_rst}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/i_stat_rx_status}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/i_time_stamp}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/i_cur_connect_tor}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/i_sim_start}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/i_check_mac}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/i_check_id}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/i_check_valid}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/o_outport}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/o_result_valid}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/o_check_id}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/o_seek_flag}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/tx_axis_tvalid}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/tx_axis_tdata}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/tx_axis_tlast}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/tx_axis_tkeep}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/tx_axis_tuser}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/rx_axis_tvalid}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/rx_axis_tdata}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/rx_axis_tlast}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/rx_axis_tkeep}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/rx_axis_tuser}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/rx_axis_tready}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_cur_state}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_nxt_state}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_st_cnt}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_dealy}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/ri_sim_start}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_tx_axis_tvalid}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_tx_axis_tdata}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_tx_axis_tlast}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_tx_cnt}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_random_dest}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_dest_tor}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_dest_server}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_dest_mac}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/ro_outport}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/ro_result_valid}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/ro_check_id}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/ro_seek_flag}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/ri_check_mac}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/ri_check_id}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/ri_check_valid}
add wave -noupdate -group s0 -radix unsigned {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_cycle_cnt}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_send_gap}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/r_send_end}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/feedback}
add wave -noupdate -group s0 {/SRRNet_top_tb/gen_loop[0]/ToR_DDR_tb_u0/SRRNet_Top_u0/VCU128_10g_eth_data_ctrl_link/server_module_server0/w_skews_tor}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {40333597305 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 195
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {34809776880 fs} {57817893310 fs}
