`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/16 09:41:58
// Design Name: 
// Module Name: ten_eth_four_chnl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ten_eth_four_chnl#(
    parameter                 P_CHANNEL_NUM = 4     
)(          
    input                           dclk                ,
    input                           sys_rst             ,
    input                           i_gt_refclk_p       ,
    input                           i_gt_refclk_n       ,

    output [P_CHANNEL_NUM-1 : 0]    o_sfp_disable       ,
    output [P_CHANNEL_NUM-1 : 0]    o_chnl_led          ,


    input  [P_CHANNEL_NUM-1 : 0]    i_gt_rxp            ,
    input  [P_CHANNEL_NUM-1 : 0]    i_gt_rxn            ,
    output [P_CHANNEL_NUM-1 : 0]    o_gt_txp            ,
    output [P_CHANNEL_NUM-1 : 0]    o_gt_txn            ,

    output                          rx0_stat_status     ,
    output                          rx0_axis_tvalid     ,
    output [63:0]                   rx0_axis_tdata      ,
    output                          rx0_axis_tlast      ,
    output [7 :0]                   rx0_axis_tkeep      ,
    output                          rx0_axis_tuser      ,
    output                          tx0_axis_tready     ,
    input                           tx0_axis_tvalid     ,
    input  [63:0]                   tx0_axis_tdata      ,
    input                           tx0_axis_tlast      ,
    input  [7 :0]                   tx0_axis_tkeep      ,
    input                           tx0_axis_tuser      
);
/*============================================ parameter ================================================*/
localparam  MIN_LENGTH     = 8'd64              ;
localparam  MAX_LENGTH     = 15'd9600           ;

/*============================================ reg ======================================================*/
/*============================================ wire =====================================================*/
// wire        sys_rst                             ;
// wire        dclk                                ;
// wire        locked                              ; 
// assign      sys_rst = ~locked                   ;

wire        gt_refclk_out                       ;
wire [2 :0] gt_loopback_in_0                    ;
wire        qpllreset_in_0                      ;
wire        tx_clk_out_0                        ;
wire        rx_clk_out_0                        ;
wire        rx_core_clk_0                       ;
wire [2 :0] txoutclksel_in_0                    ;
wire [2 :0] rxoutclksel_in_0                    ;
wire        gtwiz_reset_tx_datapath_0           ;
wire        gtwiz_reset_rx_datapath_0           ;
wire        rxrecclkout_0                       ;
wire        gtpowergood_out_0                   ;
wire        rx_reset_0                          ;
wire        user_rx_reset_0                     ;
/*----ctrl rx----*/         
wire        ctl_rx_enable_0                     ;
wire        ctl_rx_check_preamble_0             ;
wire        ctl_rx_check_sfd_0                  ;
wire        ctl_rx_force_resync_0               ;
wire        ctl_rx_delete_fcs_0                 ;
wire        ctl_rx_ignore_fcs_0                 ;
wire [14:0] ctl_rx_max_packet_len_0             ;
wire [7 :0] ctl_rx_min_packet_len_0             ;
wire        ctl_rx_process_lfi_0                ;
wire        ctl_rx_test_pattern_0               ;
wire        ctl_rx_data_pattern_select_0        ;
wire        ctl_rx_test_pattern_enable_0        ;
wire        ctl_rx_custom_preamble_enable_0     ;
/*----RX_0 Stats Signals----*/  
wire        stat_rx_framing_err_0           ;
wire        stat_rx_framing_err_valid_0     ;
wire        stat_rx_local_fault_0           ;
wire        stat_rx_block_lock_0            ;
wire        stat_rx_valid_ctrl_code_0       ;
wire        stat_rx_status_0                ;
wire        stat_rx_remote_fault_0          ;
wire [1 :0] stat_rx_bad_fcs_0               ;
wire [1 :0] stat_rx_stomped_fcs_0           ;
wire        stat_rx_truncated_0             ;
wire        stat_rx_internal_local_fault_0  ;
wire        stat_rx_received_local_fault_0  ;
wire        stat_rx_hi_ber_0                ;
wire        stat_rx_got_signal_os_0         ;
wire        stat_rx_test_pattern_mismatch_0 ;
wire [3 :0] stat_rx_total_bytes_0           ;
wire [1 :0] stat_rx_total_packets_0         ;
wire [13:0] stat_rx_total_good_bytes_0      ;
wire        stat_rx_total_good_packets_0    ;
wire        stat_rx_packet_bad_fcs_0        ;
wire        stat_rx_packet_64_bytes_0       ;
wire        stat_rx_packet_65_127_bytes_0   ;
wire        stat_rx_packet_128_255_bytes_0  ;
wire        stat_rx_packet_256_511_bytes_0  ;
wire        stat_rx_packet_512_1023_bytes_0 ;
wire        stat_rx_packet_1024_1518_bytes_0;
wire        stat_rx_packet_1519_1522_bytes_0;
wire        stat_rx_packet_1523_1548_bytes_0;
wire        stat_rx_packet_1549_2047_bytes_0;
wire        stat_rx_packet_2048_4095_bytes_0;
wire        stat_rx_packet_4096_8191_bytes_0;
wire        stat_rx_packet_8192_9215_bytes_0;
wire        stat_rx_packet_small_0          ;
wire        stat_rx_packet_large_0          ;
wire        stat_rx_unicast_0               ;
wire        stat_rx_multicast_0             ;
wire        stat_rx_broadcast_0             ;
wire        stat_rx_oversize_0              ;
wire        stat_rx_toolong_0               ;
wire        stat_rx_undersize_0             ;
wire        stat_rx_fragment_0              ;
wire        stat_rx_vlan_0                  ;
wire        stat_rx_inrangeerr_0            ;
wire        stat_rx_jabber_0                ;
wire        stat_rx_bad_code_0              ;
wire        stat_rx_bad_sfd_0               ;
wire        stat_rx_bad_preamble_0          ;
/*----tx single----*/
wire        tx_reset_0                      ;
wire        user_tx_reset_0                 ;
wire        tx_unfout_0                     ;
wire [55:0] tx_preamblein_0                 ;
wire [55:0] rx_preambleout_0                ;
wire        ctl_tx_enable_0                 ;
wire        ctl_tx_send_rfi_0               ;
wire        ctl_tx_send_lfi_0               ;
wire        ctl_tx_send_idle_0              ;
wire        ctl_tx_fcs_ins_enable_0         ;
wire        ctl_tx_ignore_fcs_0             ;
wire        ctl_tx_test_pattern_0           ;
wire        ctl_tx_test_pattern_enable_0    ;
wire        ctl_tx_test_pattern_select_0    ;
wire        ctl_tx_data_pattern_select_0    ;
wire [57:0] ctl_tx_test_pattern_seed_a_0    ;
wire [57:0] ctl_tx_test_pattern_seed_b_0    ;
wire [3 :0] ctl_tx_ipg_value_0              ;
wire        ctl_tx_custom_preamble_enable_0 ;

wire        stat_tx_local_fault_0            ;
wire [3 :0] stat_tx_total_bytes_0            ;
wire        stat_tx_total_packets_0          ;
wire [13:0] stat_tx_total_good_bytes_0       ;
wire        stat_tx_total_good_packets_0     ;
wire        stat_tx_bad_fcs_0                ;
wire        stat_tx_packet_64_bytes_0        ;
wire        stat_tx_packet_65_127_bytes_0    ;
wire        stat_tx_packet_128_255_bytes_0   ;
wire        stat_tx_packet_256_511_bytes_0   ;
wire        stat_tx_packet_512_1023_bytes_0  ;
wire        stat_tx_packet_1024_1518_bytes_0 ;
wire        stat_tx_packet_1519_1522_bytes_0 ;
wire        stat_tx_packet_1523_1548_bytes_0 ;
wire        stat_tx_packet_1549_2047_bytes_0 ;
wire        stat_tx_packet_2048_4095_bytes_0 ;
wire        stat_tx_packet_4096_8191_bytes_0 ;
wire        stat_tx_packet_8192_9215_bytes_0 ;
wire        stat_tx_packet_small_0           ;
wire        stat_tx_packet_large_0           ;
wire        stat_tx_unicast_0                ;
wire        stat_tx_multicast_0              ;
wire        stat_tx_broadcast_0              ;
wire        stat_tx_vlan_0                   ;
wire        stat_tx_frame_error_0            ;


//sfp1
wire [2 :0] gt_loopback_in_1                    ;
wire        qpllreset_in_1                      ;
wire        tx_clk_out_1                        ;
wire        rx_clk_out_1                        ;
wire        rx_core_clk_1                       ;
wire [2 :0] txoutclksel_in_1                    ;
wire [2 :0] rxoutclksel_in_1                    ;
wire        gtwiz_reset_tx_datapath_1           ;
wire        gtwiz_reset_rx_datapath_1           ;
wire        rxrecclkout_1                       ;
wire        gtpowergood_out_1                   ;
wire        rx_reset_1                          ;
wire        user_rx_reset_1                     ;
/*----ctrl rx----*/         
wire        ctl_rx_enable_1                     ;
wire        ctl_rx_check_preamble_1             ;
wire        ctl_rx_check_sfd_1                  ;
wire        ctl_rx_force_resync_1               ;
wire        ctl_rx_delete_fcs_1                 ;
wire        ctl_rx_ignore_fcs_1                 ;
wire [14:0] ctl_rx_max_packet_len_1             ;
wire [7 :0] ctl_rx_min_packet_len_1             ;
wire        ctl_rx_process_lfi_1                ;
wire        ctl_rx_test_pattern_1               ;
wire        ctl_rx_data_pattern_select_1        ;
wire        ctl_rx_test_pattern_enable_1        ;
wire        ctl_rx_custom_preamble_enable_1     ;
/*----RX_0 Stats Signals----*/  
wire        stat_rx_framing_err_1           ;
wire        stat_rx_framing_err_valid_1     ;
wire        stat_rx_local_fault_1           ;
wire        stat_rx_block_lock_1            ;
wire        stat_rx_valid_ctrl_code_1       ;
wire        stat_rx_status_1                ;
wire        stat_rx_remote_fault_1          ;
wire [1 :0] stat_rx_bad_fcs_1               ;
wire [1 :0] stat_rx_stomped_fcs_1           ;
wire        stat_rx_truncated_1             ;
wire        stat_rx_internal_local_fault_1  ;
wire        stat_rx_received_local_fault_1  ;
wire        stat_rx_hi_ber_1                ;
wire        stat_rx_got_signal_os_1         ;
wire        stat_rx_test_pattern_mismatch_1 ;
wire [3 :0] stat_rx_total_bytes_1           ;
wire [1 :0] stat_rx_total_packets_1         ;
wire [13:0] stat_rx_total_good_bytes_1      ;
wire        stat_rx_total_good_packets_1    ;
wire        stat_rx_packet_bad_fcs_1        ;
wire        stat_rx_packet_64_bytes_1       ;
wire        stat_rx_packet_65_127_bytes_1   ;
wire        stat_rx_packet_128_255_bytes_1  ;
wire        stat_rx_packet_256_511_bytes_1  ;
wire        stat_rx_packet_512_1023_bytes_1 ;
wire        stat_rx_packet_1024_1518_bytes_1;
wire        stat_rx_packet_1519_1522_bytes_1;
wire        stat_rx_packet_1523_1548_bytes_1;
wire        stat_rx_packet_1549_2047_bytes_1;
wire        stat_rx_packet_2048_4095_bytes_1;
wire        stat_rx_packet_4096_8191_bytes_1;
wire        stat_rx_packet_8192_9215_bytes_1;
wire        stat_rx_packet_small_1          ;
wire        stat_rx_packet_large_1          ;
wire        stat_rx_unicast_1               ;
wire        stat_rx_multicast_1             ;
wire        stat_rx_broadcast_1             ;
wire        stat_rx_oversize_1              ;
wire        stat_rx_toolong_1               ;
wire        stat_rx_undersize_1             ;
wire        stat_rx_fragment_1              ;
wire        stat_rx_vlan_1                  ;
wire        stat_rx_inrangeerr_1            ;
wire        stat_rx_jabber_1                ;
wire        stat_rx_bad_code_1              ;
wire        stat_rx_bad_sfd_1               ;
wire        stat_rx_bad_preamble_1          ;
/*----tx single----*/
wire        tx_reset_1                      ;
wire        user_tx_reset_1                 ;
wire        tx_unfout_1                     ;
wire [55:0] tx_preamblein_1                 ;
wire [55:0] rx_preambleout_1                ;
wire        ctl_tx_enable_1                 ;
wire        ctl_tx_send_rfi_1               ;
wire        ctl_tx_send_lfi_1               ;
wire        ctl_tx_send_idle_1              ;
wire        ctl_tx_fcs_ins_enable_1         ;
wire        ctl_tx_ignore_fcs_1             ;
wire        ctl_tx_test_pattern_1           ;
wire        ctl_tx_test_pattern_enable_1    ;
wire        ctl_tx_test_pattern_select_1    ;
wire        ctl_tx_data_pattern_select_1    ;
wire [57:0] ctl_tx_test_pattern_seed_a_1    ;
wire [57:0] ctl_tx_test_pattern_seed_b_1    ;
wire [3 :0] ctl_tx_ipg_value_1              ;
wire        ctl_tx_custom_preamble_enable_1 ;

wire        stat_tx_local_fault_1            ;
wire [3 :0] stat_tx_total_bytes_1            ;
wire        stat_tx_total_packets_1          ;
wire [13:0] stat_tx_total_good_bytes_1       ;
wire        stat_tx_total_good_packets_1     ;
wire        stat_tx_bad_fcs_1                ;
wire        stat_tx_packet_64_bytes_1        ;
wire        stat_tx_packet_65_127_bytes_1    ;
wire        stat_tx_packet_128_255_bytes_1   ;
wire        stat_tx_packet_256_511_bytes_1   ;
wire        stat_tx_packet_512_1023_bytes_1  ;
wire        stat_tx_packet_1024_1518_bytes_1 ;
wire        stat_tx_packet_1519_1522_bytes_1 ;
wire        stat_tx_packet_1523_1548_bytes_1 ;
wire        stat_tx_packet_1549_2047_bytes_1 ;
wire        stat_tx_packet_2048_4095_bytes_1 ;
wire        stat_tx_packet_4096_8191_bytes_1 ;
wire        stat_tx_packet_8192_9215_bytes_1 ;
wire        stat_tx_packet_small_1           ;
wire        stat_tx_packet_large_1           ;
wire        stat_tx_unicast_1                ;
wire        stat_tx_multicast_1              ;
wire        stat_tx_broadcast_1              ;
wire        stat_tx_vlan_1                   ;
wire        stat_tx_frame_error_1            ;

//=============sfp2=================//
wire [2 :0] gt_loopback_in_2                    ;
wire        qpllreset_in_2                      ;
wire        tx_clk_out_2                        ;
wire        rx_clk_out_2                        ;
wire        rx_core_clk_2                       ;
wire [2 :0] txoutclksel_in_2                    ;
wire [2 :0] rxoutclksel_in_2                    ;
wire        gtwiz_reset_tx_datapath_2           ;
wire        gtwiz_reset_rx_datapath_2           ;
wire        rxrecclkout_2                       ;
wire        gtpowergood_out_2                   ;
wire        rx_reset_2                          ;
wire        user_rx_reset_2                     ;
/*----ctrl rx----*/         
wire        ctl_rx_enable_2                     ;
wire        ctl_rx_check_preamble_2             ;
wire        ctl_rx_check_sfd_2                  ;
wire        ctl_rx_force_resync_2               ;
wire        ctl_rx_delete_fcs_2                 ;
wire        ctl_rx_ignore_fcs_2                 ;
wire [14:0] ctl_rx_max_packet_len_2             ;
wire [7 :0] ctl_rx_min_packet_len_2             ;
wire        ctl_rx_process_lfi_2                ;
wire        ctl_rx_test_pattern_2               ;
wire        ctl_rx_data_pattern_select_2        ;
wire        ctl_rx_test_pattern_enable_2        ;
wire        ctl_rx_custom_preamble_enable_2     ;
/*----RX_0 Stats Signals----*/  
wire        stat_rx_framing_err_2           ;
wire        stat_rx_framing_err_valid_2     ;
wire        stat_rx_local_fault_2           ;
wire        stat_rx_block_lock_2            ;
wire        stat_rx_valid_ctrl_code_2       ;
wire        stat_rx_status_2                ;
wire        stat_rx_remote_fault_2          ;
wire [1 :0] stat_rx_bad_fcs_2               ;
wire [1 :0] stat_rx_stomped_fcs_2           ;
wire        stat_rx_truncated_2             ;
wire        stat_rx_internal_local_fault_2  ;
wire        stat_rx_received_local_fault_2  ;
wire        stat_rx_hi_ber_2                ;
wire        stat_rx_got_signal_os_2         ;
wire        stat_rx_test_pattern_mismatch_2 ;
wire [3 :0] stat_rx_total_bytes_2           ;
wire [1 :0] stat_rx_total_packets_2         ;
wire [13:0] stat_rx_total_good_bytes_2      ;
wire        stat_rx_total_good_packets_2    ;
wire        stat_rx_packet_bad_fcs_2        ;
wire        stat_rx_packet_64_bytes_2       ;
wire        stat_rx_packet_65_127_bytes_2   ;
wire        stat_rx_packet_128_255_bytes_2  ;
wire        stat_rx_packet_256_511_bytes_2  ;
wire        stat_rx_packet_512_1023_bytes_2 ;
wire        stat_rx_packet_1024_1518_bytes_2;
wire        stat_rx_packet_1519_1522_bytes_2;
wire        stat_rx_packet_1523_1548_bytes_2;
wire        stat_rx_packet_1549_2047_bytes_2;
wire        stat_rx_packet_2048_4095_bytes_2;
wire        stat_rx_packet_4096_8191_bytes_2;
wire        stat_rx_packet_8192_9215_bytes_2;
wire        stat_rx_packet_small_2          ;
wire        stat_rx_packet_large_2          ;
wire        stat_rx_unicast_2               ;
wire        stat_rx_multicast_2             ;
wire        stat_rx_broadcast_2             ;
wire        stat_rx_oversize_2              ;
wire        stat_rx_toolong_2               ;
wire        stat_rx_undersize_2             ;
wire        stat_rx_fragment_2              ;
wire        stat_rx_vlan_2                  ;
wire        stat_rx_inrangeerr_2            ;
wire        stat_rx_jabber_2                ;
wire        stat_rx_bad_code_2              ;
wire        stat_rx_bad_sfd_2               ;
wire        stat_rx_bad_preamble_2          ;
/*----tx single----*/
wire        tx_reset_2                      ;
wire        user_tx_reset_2                 ;
wire        tx_unfout_2                     ;
wire [55:0] tx_preamblein_2                 ;
wire [55:0] rx_preambleout_2                ;
wire        ctl_tx_enable_2                 ;
wire        ctl_tx_send_rfi_2               ;
wire        ctl_tx_send_lfi_2               ;
wire        ctl_tx_send_idle_2              ;
wire        ctl_tx_fcs_ins_enable_2         ;
wire        ctl_tx_ignore_fcs_2             ;
wire        ctl_tx_test_pattern_2           ;
wire        ctl_tx_test_pattern_enable_2    ;
wire        ctl_tx_test_pattern_select_2    ;
wire        ctl_tx_data_pattern_select_2    ;
wire [57:0] ctl_tx_test_pattern_seed_a_2    ;
wire [57:0] ctl_tx_test_pattern_seed_b_2    ;
wire [3 :0] ctl_tx_ipg_value_2              ;
wire        ctl_tx_custom_preamble_enable_2 ;

wire        stat_tx_local_fault_2            ;
wire [3 :0] stat_tx_total_bytes_2            ;
wire        stat_tx_total_packets_2          ;
wire [13:0] stat_tx_total_good_bytes_2       ;
wire        stat_tx_total_good_packets_2     ;
wire        stat_tx_bad_fcs_2                ;
wire        stat_tx_packet_64_bytes_2        ;
wire        stat_tx_packet_65_127_bytes_2    ;
wire        stat_tx_packet_128_255_bytes_2   ;
wire        stat_tx_packet_256_511_bytes_2   ;
wire        stat_tx_packet_512_1023_bytes_2  ;
wire        stat_tx_packet_1024_1518_bytes_2 ;
wire        stat_tx_packet_1519_1522_bytes_2 ;
wire        stat_tx_packet_1523_1548_bytes_2 ;
wire        stat_tx_packet_1549_2047_bytes_2 ;
wire        stat_tx_packet_2048_4095_bytes_2 ;
wire        stat_tx_packet_4096_8191_bytes_2 ;
wire        stat_tx_packet_8192_9215_bytes_2 ;
wire        stat_tx_packet_small_2           ;
wire        stat_tx_packet_large_2           ;
wire        stat_tx_unicast_2                ;
wire        stat_tx_multicast_2              ;
wire        stat_tx_broadcast_2              ;
wire        stat_tx_vlan_2                   ;
wire        stat_tx_frame_error_2            ;

//==================sfp3==================//
wire [2 :0] gt_loopback_in_3                    ;
wire        qpllreset_in_3                      ;
wire        tx_clk_out_3                        ;
wire        rx_clk_out_3                        ;
wire        rx_core_clk_3                       ;
wire [2 :0] txoutclksel_in_3                    ;
wire [2 :0] rxoutclksel_in_3                    ;
wire        gtwiz_reset_tx_datapath_3           ;
wire        gtwiz_reset_rx_datapath_3           ;
wire        rxrecclkout_3                       ;
wire        gtpowergood_out_3                   ;
wire        rx_reset_3                          ;
wire        user_rx_reset_3                     ;
/*----ctrl rx----*/         
wire        ctl_rx_enable_3                     ;
wire        ctl_rx_check_preamble_3             ;
wire        ctl_rx_check_sfd_3                  ;
wire        ctl_rx_force_resync_3               ;
wire        ctl_rx_delete_fcs_3                 ;
wire        ctl_rx_ignore_fcs_3                 ;
wire [14:0] ctl_rx_max_packet_len_3             ;
wire [7 :0] ctl_rx_min_packet_len_3             ;
wire        ctl_rx_process_lfi_3                ;
wire        ctl_rx_test_pattern_3               ;
wire        ctl_rx_data_pattern_select_3        ;
wire        ctl_rx_test_pattern_enable_3        ;
wire        ctl_rx_custom_preamble_enable_3     ;
/*----RX_0 Stats Signals----*/  
wire        stat_rx_framing_err_3           ;
wire        stat_rx_framing_err_valid_3     ;
wire        stat_rx_local_fault_3           ;
wire        stat_rx_block_lock_3            ;
wire        stat_rx_valid_ctrl_code_3       ;
wire        stat_rx_status_3                ;
wire        stat_rx_remote_fault_3          ;
wire [1 :0] stat_rx_bad_fcs_3               ;
wire [1 :0] stat_rx_stomped_fcs_3           ;
wire        stat_rx_truncated_3             ;
wire        stat_rx_internal_local_fault_3  ;
wire        stat_rx_received_local_fault_3  ;
wire        stat_rx_hi_ber_3                ;
wire        stat_rx_got_signal_os_3         ;
wire        stat_rx_test_pattern_mismatch_3 ;
wire [3 :0] stat_rx_total_bytes_3           ;
wire [1 :0] stat_rx_total_packets_3         ;
wire [13:0] stat_rx_total_good_bytes_3      ;
wire        stat_rx_total_good_packets_3    ;
wire        stat_rx_packet_bad_fcs_3        ;
wire        stat_rx_packet_64_bytes_3       ;
wire        stat_rx_packet_65_127_bytes_3   ;
wire        stat_rx_packet_128_255_bytes_3  ;
wire        stat_rx_packet_256_511_bytes_3  ;
wire        stat_rx_packet_512_1023_bytes_3 ;
wire        stat_rx_packet_1024_1518_bytes_3;
wire        stat_rx_packet_1519_1522_bytes_3;
wire        stat_rx_packet_1523_1548_bytes_3;
wire        stat_rx_packet_1549_2047_bytes_3;
wire        stat_rx_packet_2048_4095_bytes_3;
wire        stat_rx_packet_4096_8191_bytes_3;
wire        stat_rx_packet_8192_9215_bytes_3;
wire        stat_rx_packet_small_3          ;
wire        stat_rx_packet_large_3          ;
wire        stat_rx_unicast_3               ;
wire        stat_rx_multicast_3             ;
wire        stat_rx_broadcast_3             ;
wire        stat_rx_oversize_3              ;
wire        stat_rx_toolong_3               ;
wire        stat_rx_undersize_3             ;
wire        stat_rx_fragment_3              ;
wire        stat_rx_vlan_3                  ;
wire        stat_rx_inrangeerr_3            ;
wire        stat_rx_jabber_3                ;
wire        stat_rx_bad_code_3              ;
wire        stat_rx_bad_sfd_3               ;
wire        stat_rx_bad_preamble_3          ;
/*----tx single----*/
wire        tx_reset_3                      ;
wire        user_tx_reset_3                 ;
wire        tx_unfout_3                     ;
wire [55:0] tx_preamblein_3                 ;
wire [55:0] rx_preambleout_3                ;
wire        ctl_tx_enable_3                 ;
wire        ctl_tx_send_rfi_3               ;
wire        ctl_tx_send_lfi_3               ;
wire        ctl_tx_send_idle_3              ;
wire        ctl_tx_fcs_ins_enable_3         ;
wire        ctl_tx_ignore_fcs_3             ;
wire        ctl_tx_test_pattern_3           ;
wire        ctl_tx_test_pattern_enable_3    ;
wire        ctl_tx_test_pattern_select_3    ;
wire        ctl_tx_data_pattern_select_3    ;
wire [57:0] ctl_tx_test_pattern_seed_a_3    ;
wire [57:0] ctl_tx_test_pattern_seed_b_3    ;
wire [3 :0] ctl_tx_ipg_value_3              ;
wire        ctl_tx_custom_preamble_enable_3 ;

wire        stat_tx_local_fault_3            ;
wire [3 :0] stat_tx_total_bytes_3            ;
wire        stat_tx_total_packets_3          ;
wire [13:0] stat_tx_total_good_bytes_3       ;
wire        stat_tx_total_good_packets_3     ;
wire        stat_tx_bad_fcs_3                ;
wire        stat_tx_packet_64_bytes_3        ;
wire        stat_tx_packet_65_127_bytes_3    ;
wire        stat_tx_packet_128_255_bytes_3   ;
wire        stat_tx_packet_256_511_bytes_3   ;
wire        stat_tx_packet_512_1023_bytes_3  ;
wire        stat_tx_packet_1024_1518_bytes_3 ;
wire        stat_tx_packet_1519_1522_bytes_3 ;
wire        stat_tx_packet_1523_1548_bytes_3 ;
wire        stat_tx_packet_1549_2047_bytes_3 ;
wire        stat_tx_packet_2048_4095_bytes_3 ;
wire        stat_tx_packet_4096_8191_bytes_3 ;
wire        stat_tx_packet_8192_9215_bytes_3 ;
wire        stat_tx_packet_small_3           ;
wire        stat_tx_packet_large_3           ;
wire        stat_tx_unicast_3                ;
wire        stat_tx_multicast_3              ;
wire        stat_tx_broadcast_3              ;
wire        stat_tx_vlan_3                   ;
wire        stat_tx_frame_error_3            ;

//===================== axis interface ==========================//
//sfp0
wire        rx_axis_tvalid_0        ;
wire [63:0] rx_axis_tdata_0         ;
wire        rx_axis_tlast_0         ;
wire [7 :0] rx_axis_tkeep_0         ;
wire        rx_axis_tuser_0         ; 

wire        tx_axis_tready_0        ;
wire        tx_axis_tvalid_0        ;
wire [63:0] tx_axis_tdata_0         ;
wire        tx_axis_tlast_0         ;
wire [7 :0] tx_axis_tkeep_0         ;
wire        tx_axis_tuser_0         ;

//sfp1
wire        rx_axis_tvalid_1        ;
wire [63:0] rx_axis_tdata_1         ;
wire        rx_axis_tlast_1         ;
wire [7 :0] rx_axis_tkeep_1         ;
wire        rx_axis_tuser_1         ;

wire        tx_axis_tready_1        ;
wire        tx_axis_tvalid_1        ;
wire [63:0] tx_axis_tdata_1         ;
wire        tx_axis_tlast_1         ;
wire [7 :0] tx_axis_tkeep_1         ;
wire        tx_axis_tuser_1         ;

//sfp2
wire        rx_axis_tvalid_2        ;
wire [63:0] rx_axis_tdata_2         ;
wire        rx_axis_tlast_2         ;
wire [7 :0] rx_axis_tkeep_2         ;
wire        rx_axis_tuser_2         ; 

wire        tx_axis_tready_2        ;
wire        tx_axis_tvalid_2        ;
wire [63:0] tx_axis_tdata_2         ;
wire        tx_axis_tlast_2         ;
wire [7 :0] tx_axis_tkeep_2         ;
wire        tx_axis_tuser_2         ;

//sfp1
wire        rx_axis_tvalid_3        ;
wire [63:0] rx_axis_tdata_3         ;
wire        rx_axis_tlast_3         ;
wire [7 :0] rx_axis_tkeep_3         ;
wire        rx_axis_tuser_3         ; 

wire        tx_axis_tready_3        ;
wire        tx_axis_tvalid_3        ;
wire [63:0] tx_axis_tdata_3         ;
wire        tx_axis_tlast_3         ;
wire [7 :0] tx_axis_tkeep_3         ;
wire        tx_axis_tuser_3         ;

/*============================================ component ================================================*/
// clk_wiz_100mhz clk_wiz_100mhz_u0
// (
//     .clk_out1                         (dclk     ),  
//     .locked                           (locked   ),  
//     .clk_in1_p                        (i_dclk_p ),  
//     .clk_in1_n                        (i_dclk_n )   
// );

ila_chnl ila_chnl_data (
	.clk    (tx_clk_out_0   ),
	.probe0 (o_chnl_led     )
);

xxv_ethernet_xcvu128 xxv_ethernet_xcvu128_u0 (
    .gt_txp_out                       (o_gt_txp                           ),      // output wire [0 : 0] gt_txp_out
    .gt_txn_out                       (o_gt_txn                           ),      // output wire [0 : 0] gt_txn_out
    .gt_rxp_in                        (i_gt_rxp                           ),      // input wire [0 : 0] gt_rxp_in
    .gt_rxn_in                        (i_gt_rxn                           ),      // input wire [0 : 0] gt_rxn_in
    .sys_reset                        (sys_rst                            ),      // input wire sys_reset
    .dclk                             (dclk                               ),      // input wire dclk
    .gt_refclk_p                      (i_gt_refclk_p                      ),      // input wire gt_refclk_p
    .gt_refclk_n                      (i_gt_refclk_n                      ),      // input wire gt_refclk_n
    .gt_refclk_out                    (gt_refclk_out                      ),      // output wire gt_refclk_out
    /*======================= sfp0 =========================*/
    .rx_core_clk_0                    (rx_core_clk_0                      ),      // input wire rx_core_clk_0
    .txoutclksel_in_0                 (txoutclksel_in_0                   ),      // input wire [2 : 0] txoutclksel_in_0
    .rxoutclksel_in_0                 (rxoutclksel_in_0                   ),      // input wire [2 : 0] rxoutclksel_in_0
    .gtwiz_reset_tx_datapath_0        (gtwiz_reset_tx_datapath_0          ),      // input wire gtwiz_reset_tx_datapath_0
    .gtwiz_reset_rx_datapath_0        (gtwiz_reset_rx_datapath_0          ),      // input wire gtwiz_reset_rx_datapath_0
    .rxrecclkout_0                    (rxrecclkout_0                      ),      // output wire rxrecclkout_0
    .tx_clk_out_0                     (tx_clk_out_0                       ),      // output wire tx_clk_out_0
    .rx_clk_out_0                     (rx_clk_out_0                       ),      // output wire rx_clk_out_0
    .gtpowergood_out_0                (gtpowergood_out_0                  ),      // output wire gtpowergood_out_0
    
    .rx_reset_0                       (rx_reset_0                         ),      // input wire rx_reset_0
    .user_rx_reset_0                  (user_rx_reset_0                    ),      // output wire user_rx_reset_0
    .rx_axis_tvalid_0                 (rx_axis_tvalid_0                   ),      // output wire rx_axis_tvalid_0
    .rx_axis_tdata_0                  (rx_axis_tdata_0                    ),      // output wire [63 : 0] rx_axis_tdata_0
    .rx_axis_tlast_0                  (rx_axis_tlast_0                    ),      // output wire rx_axis_tlast_0
    .rx_axis_tkeep_0                  (rx_axis_tkeep_0                    ),      // output wire [7 : 0] rx_axis_tkeep_0
    .rx_axis_tuser_0                  (rx_axis_tuser_0                    ),      // output wire rx_axis_tuser_0
    
    .ctl_rx_enable_0                  (ctl_rx_enable_0                    ),      // input wire ctl_rx_enable_0
    .ctl_rx_check_preamble_0          (ctl_rx_check_preamble_0            ),      // input wire ctl_rx_check_preamble_0
    .ctl_rx_check_sfd_0               (ctl_rx_check_sfd_0                 ),      // input wire ctl_rx_check_sfd_0
    .ctl_rx_force_resync_0            (ctl_rx_force_resync_0              ),      // input wire ctl_rx_force_resync_0
    .ctl_rx_delete_fcs_0              (ctl_rx_delete_fcs_0                ),      // input wire ctl_rx_delete_fcs_0
    .ctl_rx_ignore_fcs_0              (ctl_rx_ignore_fcs_0                ),      // input wire ctl_rx_ignore_fcs_0
    .ctl_rx_max_packet_len_0          (ctl_rx_max_packet_len_0            ),      // input wire [14 : 0] ctl_rx_max_packet_len_0
    .ctl_rx_min_packet_len_0          (ctl_rx_min_packet_len_0            ),      // input wire [7 : 0] ctl_rx_min_packet_len_0
    .ctl_rx_process_lfi_0             (ctl_rx_process_lfi_0               ),      // input wire ctl_rx_process_lfi_0
    .ctl_rx_test_pattern_0            (ctl_rx_test_pattern_0              ),      // input wire ctl_rx_test_pattern_0
    .ctl_rx_data_pattern_select_0     (ctl_rx_data_pattern_select_0       ),      // input wire ctl_rx_data_pattern_select_0
    .ctl_rx_test_pattern_enable_0     (ctl_rx_test_pattern_enable_0       ),      // input wire ctl_rx_test_pattern_enable_0
    .ctl_rx_custom_preamble_enable_0  (ctl_rx_custom_preamble_enable_0    ),      // input wire ctl_rx_custom_preamble_enable_0
    
    .stat_rx_framing_err_0            (stat_rx_framing_err_0              ),      // output wire stat_rx_framing_err_0
    .stat_rx_framing_err_valid_0      (stat_rx_framing_err_valid_0        ),      // output wire stat_rx_framing_err_valid_0
    .stat_rx_local_fault_0            (stat_rx_local_fault_0              ),      // output wire stat_rx_local_fault_0
    .stat_rx_block_lock_0             (stat_rx_block_lock_0               ),      // output wire stat_rx_block_lock_0
    .stat_rx_valid_ctrl_code_0        (stat_rx_valid_ctrl_code_0          ),      // output wire stat_rx_valid_ctrl_code_0
    .stat_rx_status_0                 (stat_rx_status_0                   ),      // output wire stat_rx_status_0
    .stat_rx_remote_fault_0           (stat_rx_remote_fault_0             ),      // output wire stat_rx_remote_fault_0
    .stat_rx_bad_fcs_0                (stat_rx_bad_fcs_0                  ),      // output wire [1 : 0] stat_rx_bad_fcs_0_0
    .stat_rx_stomped_fcs_0            (stat_rx_stomped_fcs_0              ),      // output wire [1 : 0] stat_rx_stomped_fcs_0
    .stat_rx_truncated_0              (stat_rx_truncated_0                ),      // output wire stat_rx_truncated_0
    .stat_rx_internal_local_fault_0   (stat_rx_internal_local_fault_0     ),      // output wire stat_rx_internal_local_fault_0
    .stat_rx_received_local_fault_0   (stat_rx_received_local_fault_0     ),      // output wire stat_rx_received_local_fault_0
    .stat_rx_hi_ber_0                 (stat_rx_hi_ber_0                   ),      // output wire stat_rx_hi_ber_0
    .stat_rx_got_signal_os_0          (stat_rx_got_signal_os_0            ),      // output wire stat_rx_got_signal_os_0
    .stat_rx_test_pattern_mismatch_0  (stat_rx_test_pattern_mismatch_0    ),      // output wire stat_rx_test_pattern_mismatch_0
    .stat_rx_total_bytes_0            (stat_rx_total_bytes_0              ),      // output wire [3 : 0] stat_rx_total_bytes_0
    .stat_rx_total_packets_0          (stat_rx_total_packets_0            ),      // output wire [1 : 0] stat_rx_total_packets_0
    .stat_rx_total_good_bytes_0       (stat_rx_total_good_bytes_0         ),      // output wire [13 : 0] stat_rx_total_good_bytes_0
    .stat_rx_total_good_packets_0     (stat_rx_total_good_packets_0       ),      // output wire stat_rx_total_good_packets_0
    .stat_rx_packet_bad_fcs_0         (stat_rx_packet_bad_fcs_0           ),      // output wire stat_rx_packet_bad_fcs_0
    .stat_rx_packet_64_bytes_0        (stat_rx_packet_64_bytes_0          ),      // output wire stat_rx_packet_64_bytes_0
    .stat_rx_packet_65_127_bytes_0    (stat_rx_packet_65_127_bytes_0      ),      // output wire stat_rx_packet_65_127_bytes_0
    .stat_rx_packet_128_255_bytes_0   (stat_rx_packet_128_255_bytes_0     ),      // output wire stat_rx_packet_128_255_bytes_0
    .stat_rx_packet_256_511_bytes_0   (stat_rx_packet_256_511_bytes_0     ),      // output wire stat_rx_packet_256_511_bytes_0
    .stat_rx_packet_512_1023_bytes_0  (stat_rx_packet_512_1023_bytes_0    ),      // output wire stat_rx_packet_512_1023_bytes_0
    .stat_rx_packet_1024_1518_bytes_0 (stat_rx_packet_1024_1518_bytes_0   ),      // output wire stat_rx_packet_1024_1518_bytes_0
    .stat_rx_packet_1519_1522_bytes_0 (stat_rx_packet_1519_1522_bytes_0   ),      // output wire stat_rx_packet_1519_1522_bytes_0
    .stat_rx_packet_1523_1548_bytes_0 (stat_rx_packet_1523_1548_bytes_0   ),      // output wire stat_rx_packet_1523_1548_bytes_0
    .stat_rx_packet_1549_2047_bytes_0 (stat_rx_packet_1549_2047_bytes_0   ),      // output wire stat_rx_packet_1549_2047_bytes_0
    .stat_rx_packet_2048_4095_bytes_0 (stat_rx_packet_2048_4095_bytes_0   ),      // output wire stat_rx_packet_2048_4095_bytes_0
    .stat_rx_packet_4096_8191_bytes_0 (stat_rx_packet_4096_8191_bytes_0   ),      // output wire stat_rx_packet_4096_8191_bytes_0
    .stat_rx_packet_8192_9215_bytes_0 (stat_rx_packet_8192_9215_bytes_0   ),      // output wire stat_rx_packet_8192_9215_bytes_0
    .stat_rx_packet_small_0           (stat_rx_packet_small_0             ),      // output wire stat_rx_packet_small_0
    .stat_rx_packet_large_0           (stat_rx_packet_large_0             ),      // output wire stat_rx_packet_large_0
    .stat_rx_unicast_0                (stat_rx_unicast_0                  ),      // output wire stat_rx_unicast_0
    .stat_rx_multicast_0              (stat_rx_multicast_0                ),      // output wire stat_rx_multicast_0
    .stat_rx_broadcast_0              (stat_rx_broadcast_0                ),      // output wire stat_rx_broadcast_0
    .stat_rx_oversize_0               (stat_rx_oversize_0                 ),      // output wire stat_rx_oversize_0
    .stat_rx_toolong_0                (stat_rx_toolong_0                  ),      // output wire stat_rx_toolong_0
    .stat_rx_undersize_0              (stat_rx_undersize_0                ),      // output wire stat_rx_undersize_0
    .stat_rx_fragment_0               (stat_rx_fragment_0                 ),      // output wire stat_rx_fragment_0
    .stat_rx_vlan_0                   (stat_rx_vlan_0                     ),      // output wire stat_rx_vlan_0
    .stat_rx_inrangeerr_0             (stat_rx_inrangeerr_0               ),      // output wire stat_rx_inrangeerr_0
    .stat_rx_jabber_0                 (stat_rx_jabber_0                   ),      // output wire stat_rx_jabber_0
    .stat_rx_bad_code_0               (stat_rx_bad_code_0                 ),      // output wire stat_rx_bad_code_0
    .stat_rx_bad_sfd_0                (stat_rx_bad_sfd_0                  ),      // output wire stat_rx_bad_sfd_0
    .stat_rx_bad_preamble_0           (stat_rx_bad_preamble_0             ),      // output wire stat_rx_bad_preamble_0
    
    .tx_reset_0                       (tx_reset_0                         ),      // input wire tx_reset_0
    .user_tx_reset_0                  (user_tx_reset_0                    ),      // output wire user_tx_reset_0
    .tx_axis_tready_0                 (tx_axis_tready_0                   ),      // output wire tx_axis_tready_0
    .tx_axis_tvalid_0                 (tx_axis_tvalid_0                   ),      // input wire tx_axis_tvalid_0
    .tx_axis_tdata_0                  (tx_axis_tdata_0                    ),      // input wire [63 : 0] tx_axis_tdata_0
    .tx_axis_tlast_0                  (tx_axis_tlast_0                    ),      // input wire tx_axis_tlast_0
    .tx_axis_tkeep_0                  (tx_axis_tkeep_0                    ),      // input wire [7 : 0] tx_axis_tkeep_0
    .tx_axis_tuser_0                  (tx_axis_tuser_0                    ),      // input wire tx_axis_tuser_0
    .tx_unfout_0                      (tx_unfout_0                        ),      // output wire tx_unfout_0
    .tx_preamblein_0                  (tx_preamblein_0                    ),      // input wire [55 : 0] tx_preamblein_0
    .rx_preambleout_0                 (rx_preambleout_0                   ),      // output wire [55 : 0] rx_preambleout_0  
    
    .stat_tx_local_fault_0            (stat_tx_local_fault_0              ),      // output wire stat_tx_local_fault_0
    .stat_tx_total_bytes_0            (stat_tx_total_bytes_0              ),      // output wire [3 : 0] stat_tx_total_bytes_0_0
    .stat_tx_total_packets_0          (stat_tx_total_packets_0            ),      // output wire stat_tx_total_packets_0
    .stat_tx_total_good_bytes_0       (stat_tx_total_good_bytes_0         ),      // output wire [13 : 0] stat_tx_total_good_bytes_0
    .stat_tx_total_good_packets_0     (stat_tx_total_good_packets_0       ),      // output wire stat_tx_total_good_packets_0
    .stat_tx_bad_fcs_0                (stat_tx_bad_fcs_0                  ),      // output wire stat_tx_bad_fcs_0
    .stat_tx_packet_64_bytes_0        (stat_tx_packet_64_bytes_0          ),      // output wire stat_tx_packet_64_bytes_0
    .stat_tx_packet_65_127_bytes_0    (stat_tx_packet_65_127_bytes_0      ),      // output wire stat_tx_packet_65_127_bytes_0
    .stat_tx_packet_128_255_bytes_0   (stat_tx_packet_128_255_bytes_0     ),      // output wire stat_tx_packet_128_255_bytes_0
    .stat_tx_packet_256_511_bytes_0   (stat_tx_packet_256_511_bytes_0     ),      // output wire stat_tx_packet_256_511_bytes_0
    .stat_tx_packet_512_1023_bytes_0  (stat_tx_packet_512_1023_bytes_0    ),      // output wire stat_tx_packet_512_1023_bytes_0
    .stat_tx_packet_1024_1518_bytes_0 (stat_tx_packet_1024_1518_bytes_0   ),      // output wire stat_tx_packet_1024_1518_bytes_0
    .stat_tx_packet_1519_1522_bytes_0 (stat_tx_packet_1519_1522_bytes_0   ),      // output wire stat_tx_packet_1519_1522_bytes_0
    .stat_tx_packet_1523_1548_bytes_0 (stat_tx_packet_1523_1548_bytes_0   ),      // output wire stat_tx_packet_1523_1548_bytes_0
    .stat_tx_packet_1549_2047_bytes_0 (stat_tx_packet_1549_2047_bytes_0   ),      // output wire stat_tx_packet_1549_2047_bytes_0
    .stat_tx_packet_2048_4095_bytes_0 (stat_tx_packet_2048_4095_bytes_0   ),      // output wire stat_tx_packet_2048_4095_bytes_0
    .stat_tx_packet_4096_8191_bytes_0 (stat_tx_packet_4096_8191_bytes_0   ),      // output wire stat_tx_packet_4096_8191_bytes_0
    .stat_tx_packet_8192_9215_bytes_0 (stat_tx_packet_8192_9215_bytes_0   ),      // output wire stat_tx_packet_8192_9215_bytes_0
    .stat_tx_packet_small_0           (stat_tx_packet_small_0             ),      // output wire stat_tx_packet_small_0
    .stat_tx_packet_large_0           (stat_tx_packet_large_0             ),      // output wire stat_tx_packet_large_0
    .stat_tx_unicast_0                (stat_tx_unicast_0                  ),      // output wire stat_tx_unicast_0
    .stat_tx_multicast_0              (stat_tx_multicast_0                ),      // output wire stat_tx_multicast_0
    .stat_tx_broadcast_0              (stat_tx_broadcast_0                ),      // output wire stat_tx_broadcast_0
    .stat_tx_vlan_0                   (stat_tx_vlan_0                     ),      // output wire stat_tx_vlan_00
    .stat_tx_frame_error_0            (stat_tx_frame_error_0              ),      // output wire stat_tx_frame_error_0
    
    .ctl_tx_enable_0                  (ctl_tx_enable_0                    ),      // input wire ctl_tx_enable_0
    .ctl_tx_send_rfi_0                (ctl_tx_send_rfi_0                  ),      // input wire ctl_tx_send_rfi_0
    .ctl_tx_send_lfi_0                (ctl_tx_send_lfi_0                  ),      // input wire ctl_tx_send_lfi_0
    .ctl_tx_send_idle_0               (ctl_tx_send_idle_0                 ),      // input wire ctl_tx_send_idle_0
    .ctl_tx_fcs_ins_enable_0          (ctl_tx_fcs_ins_enable_0            ),      // input wire ctl_tx_fcs_ins_enable_0
    .ctl_tx_ignore_fcs_0              (ctl_tx_ignore_fcs_0                ),      // input wire ctl_tx_ignore_fcs_0
    .ctl_tx_test_pattern_0            (ctl_tx_test_pattern_0              ),      // input wire ctl_tx_test_pattern_0
    .ctl_tx_test_pattern_enable_0     (ctl_tx_test_pattern_enable_0       ),      // input wire ctl_tx_test_pattern_enable_0
    .ctl_tx_test_pattern_select_0     (ctl_tx_test_pattern_select_0       ),      // input wire ctl_tx_test_pattern_select_0
    .ctl_tx_data_pattern_select_0     (ctl_tx_data_pattern_select_0       ),      // input wire ctl_tx_data_pattern_select_0
    .ctl_tx_test_pattern_seed_a_0     (ctl_tx_test_pattern_seed_a_0       ),      // input wire [57 : 0] ctl_tx_test_pattern_seed_a_0
    .ctl_tx_test_pattern_seed_b_0     (ctl_tx_test_pattern_seed_b_0       ),      // input wire [57 : 0] ctl_tx_test_pattern_seed_b_0
    .ctl_tx_ipg_value_0               (ctl_tx_ipg_value_0                 ),      // input wire [3 : 0] ctl_tx_ipg_value_0
    .ctl_tx_custom_preamble_enable_0  (ctl_tx_custom_preamble_enable_0    ),      // input wire ctl_tx_custom_preamble_enable_0
    .gt_loopback_in_0                 (gt_loopback_in_0                   ),      // input wire [2 : 0] gt_loopback_in_0
    .qpllreset_in_0                   (qpllreset_in_0                     ),      // input wire qpllreset_in_0
    /*======================================================*/
    /*======================= sfp1 =========================*/
    /*======================================================*/
    .rx_core_clk_1                    (rx_core_clk_1                      ), 
    .txoutclksel_in_1                 (txoutclksel_in_1                   ), 
    .rxoutclksel_in_1                 (rxoutclksel_in_1                   ), 
    .gtwiz_reset_tx_datapath_1        (gtwiz_reset_tx_datapath_1          ), 
    .gtwiz_reset_rx_datapath_1        (gtwiz_reset_rx_datapath_1          ), 
    .rxrecclkout_1                    (rxrecclkout_1                      ), 
    .tx_clk_out_1                     (tx_clk_out_1                       ), 
    .rx_clk_out_1                     (rx_clk_out_1                       ), 
    .gtpowergood_out_1                (gtpowergood_out_1                  ), 
    
    .rx_reset_1                       (rx_reset_1                         ), 
    .user_rx_reset_1                  (user_rx_reset_1                    ), 
    .rx_axis_tvalid_1                 (rx_axis_tvalid_1                   ), 
    .rx_axis_tdata_1                  (rx_axis_tdata_1                    ), 
    .rx_axis_tlast_1                  (rx_axis_tlast_1                    ), 
    .rx_axis_tkeep_1                  (rx_axis_tkeep_1                    ), 
    .rx_axis_tuser_1                  (rx_axis_tuser_1                    ), 
    
    .ctl_rx_enable_1                  (ctl_rx_enable_1                    ), 
    .ctl_rx_check_preamble_1          (ctl_rx_check_preamble_1            ), 
    .ctl_rx_check_sfd_1               (ctl_rx_check_sfd_1                 ), 
    .ctl_rx_force_resync_1            (ctl_rx_force_resync_1              ), 
    .ctl_rx_delete_fcs_1              (ctl_rx_delete_fcs_1                ), 
    .ctl_rx_ignore_fcs_1              (ctl_rx_ignore_fcs_1                ), 
    .ctl_rx_max_packet_len_1          (ctl_rx_max_packet_len_1            ), 
    .ctl_rx_min_packet_len_1          (ctl_rx_min_packet_len_1            ), 
    .ctl_rx_process_lfi_1             (ctl_rx_process_lfi_1               ), 
    .ctl_rx_test_pattern_1            (ctl_rx_test_pattern_1              ), 
    .ctl_rx_data_pattern_select_1     (ctl_rx_data_pattern_select_1       ), 
    .ctl_rx_test_pattern_enable_1     (ctl_rx_test_pattern_enable_1       ), 
    .ctl_rx_custom_preamble_enable_1  (ctl_rx_custom_preamble_enable_1    ), 
    
    .stat_rx_framing_err_1            (stat_rx_framing_err_1              ), 
    .stat_rx_framing_err_valid_1      (stat_rx_framing_err_valid_1        ), 
    .stat_rx_local_fault_1            (stat_rx_local_fault_1              ), 
    .stat_rx_block_lock_1             (stat_rx_block_lock_1               ), 
    .stat_rx_valid_ctrl_code_1        (stat_rx_valid_ctrl_code_1          ), 
    .stat_rx_status_1                 (stat_rx_status_1                   ), 
    .stat_rx_remote_fault_1           (stat_rx_remote_fault_1             ), 
    .stat_rx_bad_fcs_1                (stat_rx_bad_fcs_1                  ), 
    .stat_rx_stomped_fcs_1            (stat_rx_stomped_fcs_1              ), 
    .stat_rx_truncated_1              (stat_rx_truncated_1                ), 
    .stat_rx_internal_local_fault_1   (stat_rx_internal_local_fault_1     ), 
    .stat_rx_received_local_fault_1   (stat_rx_received_local_fault_1     ), 
    .stat_rx_hi_ber_1                 (stat_rx_hi_ber_1                   ), 
    .stat_rx_got_signal_os_1          (stat_rx_got_signal_os_1            ), 
    .stat_rx_test_pattern_mismatch_1  (stat_rx_test_pattern_mismatch_1    ), 
    .stat_rx_total_bytes_1            (stat_rx_total_bytes_1              ), 
    .stat_rx_total_packets_1          (stat_rx_total_packets_1            ), 
    .stat_rx_total_good_bytes_1       (stat_rx_total_good_bytes_1         ), 
    .stat_rx_total_good_packets_1     (stat_rx_total_good_packets_1       ), 
    .stat_rx_packet_bad_fcs_1         (stat_rx_packet_bad_fcs_1           ), 
    .stat_rx_packet_64_bytes_1        (stat_rx_packet_64_bytes_1          ), 
    .stat_rx_packet_65_127_bytes_1    (stat_rx_packet_65_127_bytes_1      ), 
    .stat_rx_packet_128_255_bytes_1   (stat_rx_packet_128_255_bytes_1     ), 
    .stat_rx_packet_256_511_bytes_1   (stat_rx_packet_256_511_bytes_1     ), 
    .stat_rx_packet_512_1023_bytes_1  (stat_rx_packet_512_1023_bytes_1    ), 
    .stat_rx_packet_1024_1518_bytes_1 (stat_rx_packet_1024_1518_bytes_1   ), 
    .stat_rx_packet_1519_1522_bytes_1 (stat_rx_packet_1519_1522_bytes_1   ), 
    .stat_rx_packet_1523_1548_bytes_1 (stat_rx_packet_1523_1548_bytes_1   ), 
    .stat_rx_packet_1549_2047_bytes_1 (stat_rx_packet_1549_2047_bytes_1   ), 
    .stat_rx_packet_2048_4095_bytes_1 (stat_rx_packet_2048_4095_bytes_1   ), 
    .stat_rx_packet_4096_8191_bytes_1 (stat_rx_packet_4096_8191_bytes_1   ), 
    .stat_rx_packet_8192_9215_bytes_1 (stat_rx_packet_8192_9215_bytes_1   ), 
    .stat_rx_packet_small_1           (stat_rx_packet_small_1             ), 
    .stat_rx_packet_large_1           (stat_rx_packet_large_1             ), 
    .stat_rx_unicast_1                (stat_rx_unicast_1                  ), 
    .stat_rx_multicast_1              (stat_rx_multicast_1                ), 
    .stat_rx_broadcast_1              (stat_rx_broadcast_1                ), 
    .stat_rx_oversize_1               (stat_rx_oversize_1                 ), 
    .stat_rx_toolong_1                (stat_rx_toolong_1                  ), 
    .stat_rx_undersize_1              (stat_rx_undersize_1                ), 
    .stat_rx_fragment_1               (stat_rx_fragment_1                 ), 
    .stat_rx_vlan_1                   (stat_rx_vlan_1                     ), 
    .stat_rx_inrangeerr_1             (stat_rx_inrangeerr_1               ), 
    .stat_rx_jabber_1                 (stat_rx_jabber_1                   ), 
    .stat_rx_bad_code_1               (stat_rx_bad_code_1                 ), 
    .stat_rx_bad_sfd_1                (stat_rx_bad_sfd_1                  ), 
    .stat_rx_bad_preamble_1           (stat_rx_bad_preamble_1             ), 
    
    .tx_reset_1                       (tx_reset_1                         ), 
    .user_tx_reset_1                  (user_tx_reset_1                    ), 
    .tx_axis_tready_1                 (tx_axis_tready_1                   ), 
    .tx_axis_tvalid_1                 (tx_axis_tvalid_1                   ), 
    .tx_axis_tdata_1                  (tx_axis_tdata_1                    ), 
    .tx_axis_tlast_1                  (tx_axis_tlast_1                    ), 
    .tx_axis_tkeep_1                  (tx_axis_tkeep_1                    ), 
    .tx_axis_tuser_1                  (tx_axis_tuser_1                    ),    
    .tx_unfout_1                      (tx_unfout_1                        ), 
    .tx_preamblein_1                  (tx_preamblein_1                    ), 
    .rx_preambleout_1                 (rx_preambleout_1                   ), 
    
    .stat_tx_local_fault_1            (stat_tx_local_fault_1              ), 
    .stat_tx_total_bytes_1            (stat_tx_total_bytes_1              ), 
    .stat_tx_total_packets_1          (stat_tx_total_packets_1            ), 
    .stat_tx_total_good_bytes_1       (stat_tx_total_good_bytes_1         ), 
    .stat_tx_total_good_packets_1     (stat_tx_total_good_packets_1       ), 
    .stat_tx_bad_fcs_1                (stat_tx_bad_fcs_1                  ), 
    .stat_tx_packet_64_bytes_1        (stat_tx_packet_64_bytes_1          ), 
    .stat_tx_packet_65_127_bytes_1    (stat_tx_packet_65_127_bytes_1      ), 
    .stat_tx_packet_128_255_bytes_1   (stat_tx_packet_128_255_bytes_1     ), 
    .stat_tx_packet_256_511_bytes_1   (stat_tx_packet_256_511_bytes_1     ), 
    .stat_tx_packet_512_1023_bytes_1  (stat_tx_packet_512_1023_bytes_1    ), 
    .stat_tx_packet_1024_1518_bytes_1 (stat_tx_packet_1024_1518_bytes_1   ), 
    .stat_tx_packet_1519_1522_bytes_1 (stat_tx_packet_1519_1522_bytes_1   ), 
    .stat_tx_packet_1523_1548_bytes_1 (stat_tx_packet_1523_1548_bytes_1   ), 
    .stat_tx_packet_1549_2047_bytes_1 (stat_tx_packet_1549_2047_bytes_1   ), 
    .stat_tx_packet_2048_4095_bytes_1 (stat_tx_packet_2048_4095_bytes_1   ), 
    .stat_tx_packet_4096_8191_bytes_1 (stat_tx_packet_4096_8191_bytes_1   ), 
    .stat_tx_packet_8192_9215_bytes_1 (stat_tx_packet_8192_9215_bytes_1   ), 
    .stat_tx_packet_small_1           (stat_tx_packet_small_1             ), 
    .stat_tx_packet_large_1           (stat_tx_packet_large_1             ), 
    .stat_tx_unicast_1                (stat_tx_unicast_1                  ), 
    .stat_tx_multicast_1              (stat_tx_multicast_1                ), 
    .stat_tx_broadcast_1              (stat_tx_broadcast_1                ), 
    .stat_tx_vlan_1                   (stat_tx_vlan_1                     ), 
    .stat_tx_frame_error_1            (stat_tx_frame_error_1              ), 
    
    .ctl_tx_enable_1                  (ctl_tx_enable_1                    ), 
    .ctl_tx_send_rfi_1                (ctl_tx_send_rfi_1                  ), 
    .ctl_tx_send_lfi_1                (ctl_tx_send_lfi_1                  ), 
    .ctl_tx_send_idle_1               (ctl_tx_send_idle_1                 ), 
    .ctl_tx_fcs_ins_enable_1          (ctl_tx_fcs_ins_enable_1            ), 
    .ctl_tx_ignore_fcs_1              (ctl_tx_ignore_fcs_1                ), 
    .ctl_tx_test_pattern_1            (ctl_tx_test_pattern_1              ), 
    .ctl_tx_test_pattern_enable_1     (ctl_tx_test_pattern_enable_1       ), 
    .ctl_tx_test_pattern_select_1     (ctl_tx_test_pattern_select_1       ), 
    .ctl_tx_data_pattern_select_1     (ctl_tx_data_pattern_select_1       ), 
    .ctl_tx_test_pattern_seed_a_1     (ctl_tx_test_pattern_seed_a_1       ), 
    .ctl_tx_test_pattern_seed_b_1     (ctl_tx_test_pattern_seed_b_1       ), 
    .ctl_tx_ipg_value_1               (ctl_tx_ipg_value_1                 ), 
    .ctl_tx_custom_preamble_enable_1  (ctl_tx_custom_preamble_enable_1    ), 
    .gt_loopback_in_1                 (gt_loopback_in_1                   ), 
     /*======================================================*/
    /*======================= sfp2 =========================*/
    /*======================================================*/
    .rx_core_clk_2                    (rx_core_clk_2                      ), 
    .txoutclksel_in_2                 (txoutclksel_in_2                   ), 
    .rxoutclksel_in_2                 (rxoutclksel_in_2                   ), 
    .gtwiz_reset_tx_datapath_2        (gtwiz_reset_tx_datapath_2          ), 
    .gtwiz_reset_rx_datapath_2        (gtwiz_reset_rx_datapath_2          ), 
    .rxrecclkout_2                    (rxrecclkout_2                      ), 
    .tx_clk_out_2                     (tx_clk_out_2                       ), 
    .rx_clk_out_2                     (rx_clk_out_2                       ), 
    .gtpowergood_out_2                (gtpowergood_out_2                  ), 
    
    .rx_reset_2                       (rx_reset_2                         ), 
    .user_rx_reset_2                  (user_rx_reset_2                    ), 
    .rx_axis_tvalid_2                 (rx_axis_tvalid_2                   ), 
    .rx_axis_tdata_2                  (rx_axis_tdata_2                    ), 
    .rx_axis_tlast_2                  (rx_axis_tlast_2                    ), 
    .rx_axis_tkeep_2                  (rx_axis_tkeep_2                    ), 
    .rx_axis_tuser_2                  (rx_axis_tuser_2                    ), 
    
    .ctl_rx_enable_2                  (ctl_rx_enable_2                    ), 
    .ctl_rx_check_preamble_2          (ctl_rx_check_preamble_2            ), 
    .ctl_rx_check_sfd_2               (ctl_rx_check_sfd_2                 ), 
    .ctl_rx_force_resync_2            (ctl_rx_force_resync_2              ), 
    .ctl_rx_delete_fcs_2              (ctl_rx_delete_fcs_2                ), 
    .ctl_rx_ignore_fcs_2              (ctl_rx_ignore_fcs_2                ), 
    .ctl_rx_max_packet_len_2          (ctl_rx_max_packet_len_2            ), 
    .ctl_rx_min_packet_len_2          (ctl_rx_min_packet_len_2            ), 
    .ctl_rx_process_lfi_2             (ctl_rx_process_lfi_2               ), 
    .ctl_rx_test_pattern_2            (ctl_rx_test_pattern_2              ), 
    .ctl_rx_data_pattern_select_2     (ctl_rx_data_pattern_select_2       ), 
    .ctl_rx_test_pattern_enable_2     (ctl_rx_test_pattern_enable_2       ), 
    .ctl_rx_custom_preamble_enable_2  (ctl_rx_custom_preamble_enable_2    ), 
    
    .stat_rx_framing_err_2            (stat_rx_framing_err_2              ), 
    .stat_rx_framing_err_valid_2      (stat_rx_framing_err_valid_2        ), 
    .stat_rx_local_fault_2            (stat_rx_local_fault_2              ), 
    .stat_rx_block_lock_2             (stat_rx_block_lock_2               ), 
    .stat_rx_valid_ctrl_code_2        (stat_rx_valid_ctrl_code_2          ), 
    .stat_rx_status_2                 (stat_rx_status_2                   ), 
    .stat_rx_remote_fault_2           (stat_rx_remote_fault_2             ), 
    .stat_rx_bad_fcs_2                (stat_rx_bad_fcs_2                  ), 
    .stat_rx_stomped_fcs_2            (stat_rx_stomped_fcs_2              ), 
    .stat_rx_truncated_2              (stat_rx_truncated_2                ), 
    .stat_rx_internal_local_fault_2   (stat_rx_internal_local_fault_2     ), 
    .stat_rx_received_local_fault_2   (stat_rx_received_local_fault_2     ), 
    .stat_rx_hi_ber_2                 (stat_rx_hi_ber_2                   ), 
    .stat_rx_got_signal_os_2          (stat_rx_got_signal_os_2            ), 
    .stat_rx_test_pattern_mismatch_2  (stat_rx_test_pattern_mismatch_2    ), 
    .stat_rx_total_bytes_2            (stat_rx_total_bytes_2              ), 
    .stat_rx_total_packets_2          (stat_rx_total_packets_2            ), 
    .stat_rx_total_good_bytes_2       (stat_rx_total_good_bytes_2         ), 
    .stat_rx_total_good_packets_2     (stat_rx_total_good_packets_2       ), 
    .stat_rx_packet_bad_fcs_2         (stat_rx_packet_bad_fcs_2           ), 
    .stat_rx_packet_64_bytes_2        (stat_rx_packet_64_bytes_2          ), 
    .stat_rx_packet_65_127_bytes_2    (stat_rx_packet_65_127_bytes_2      ), 
    .stat_rx_packet_128_255_bytes_2   (stat_rx_packet_128_255_bytes_2     ), 
    .stat_rx_packet_256_511_bytes_2   (stat_rx_packet_256_511_bytes_2     ), 
    .stat_rx_packet_512_1023_bytes_2  (stat_rx_packet_512_1023_bytes_2    ), 
    .stat_rx_packet_1024_1518_bytes_2 (stat_rx_packet_1024_1518_bytes_2   ), 
    .stat_rx_packet_1519_1522_bytes_2 (stat_rx_packet_1519_1522_bytes_2   ), 
    .stat_rx_packet_1523_1548_bytes_2 (stat_rx_packet_1523_1548_bytes_2   ), 
    .stat_rx_packet_1549_2047_bytes_2 (stat_rx_packet_1549_2047_bytes_2   ), 
    .stat_rx_packet_2048_4095_bytes_2 (stat_rx_packet_2048_4095_bytes_2   ), 
    .stat_rx_packet_4096_8191_bytes_2 (stat_rx_packet_4096_8191_bytes_2   ), 
    .stat_rx_packet_8192_9215_bytes_2 (stat_rx_packet_8192_9215_bytes_2   ), 
    .stat_rx_packet_small_2           (stat_rx_packet_small_2             ), 
    .stat_rx_packet_large_2           (stat_rx_packet_large_2             ), 
    .stat_rx_unicast_2                (stat_rx_unicast_2                  ), 
    .stat_rx_multicast_2              (stat_rx_multicast_2                ), 
    .stat_rx_broadcast_2              (stat_rx_broadcast_2                ), 
    .stat_rx_oversize_2               (stat_rx_oversize_2                 ), 
    .stat_rx_toolong_2                (stat_rx_toolong_2                  ), 
    .stat_rx_undersize_2              (stat_rx_undersize_2                ), 
    .stat_rx_fragment_2               (stat_rx_fragment_2                 ), 
    .stat_rx_vlan_2                   (stat_rx_vlan_2                     ), 
    .stat_rx_inrangeerr_2             (stat_rx_inrangeerr_2               ), 
    .stat_rx_jabber_2                 (stat_rx_jabber_2                   ), 
    .stat_rx_bad_code_2               (stat_rx_bad_code_2                 ), 
    .stat_rx_bad_sfd_2                (stat_rx_bad_sfd_2                  ), 
    .stat_rx_bad_preamble_2           (stat_rx_bad_preamble_2             ), 
    
    .tx_reset_2                       (tx_reset_2                         ), 
    .user_tx_reset_2                  (user_tx_reset_2                    ), 
    .tx_axis_tready_2                 (tx_axis_tready_2                   ), 
    .tx_axis_tvalid_2                 (tx_axis_tvalid_2                   ), 
    .tx_axis_tdata_2                  (tx_axis_tdata_2                    ), 
    .tx_axis_tlast_2                  (tx_axis_tlast_2                    ), 
    .tx_axis_tkeep_2                  (tx_axis_tkeep_2                    ), 
    .tx_axis_tuser_2                  (tx_axis_tuser_2                    ), 
    .tx_unfout_2                      (tx_unfout_2                        ), 
    .tx_preamblein_2                  (tx_preamblein_2                    ), 
    .rx_preambleout_2                 (rx_preambleout_2                   ), 
    
    .stat_tx_local_fault_2            (stat_tx_local_fault_2              ), 
    .stat_tx_total_bytes_2            (stat_tx_total_bytes_2              ), 
    .stat_tx_total_packets_2          (stat_tx_total_packets_2            ), 
    .stat_tx_total_good_bytes_2       (stat_tx_total_good_bytes_2         ), 
    .stat_tx_total_good_packets_2     (stat_tx_total_good_packets_2       ), 
    .stat_tx_bad_fcs_2                (stat_tx_bad_fcs_2                  ), 
    .stat_tx_packet_64_bytes_2        (stat_tx_packet_64_bytes_2          ), 
    .stat_tx_packet_65_127_bytes_2    (stat_tx_packet_65_127_bytes_2      ), 
    .stat_tx_packet_128_255_bytes_2   (stat_tx_packet_128_255_bytes_2     ), 
    .stat_tx_packet_256_511_bytes_2   (stat_tx_packet_256_511_bytes_2     ), 
    .stat_tx_packet_512_1023_bytes_2  (stat_tx_packet_512_1023_bytes_2    ), 
    .stat_tx_packet_1024_1518_bytes_2 (stat_tx_packet_1024_1518_bytes_2   ), 
    .stat_tx_packet_1519_1522_bytes_2 (stat_tx_packet_1519_1522_bytes_2   ), 
    .stat_tx_packet_1523_1548_bytes_2 (stat_tx_packet_1523_1548_bytes_2   ), 
    .stat_tx_packet_1549_2047_bytes_2 (stat_tx_packet_1549_2047_bytes_2   ), 
    .stat_tx_packet_2048_4095_bytes_2 (stat_tx_packet_2048_4095_bytes_2   ), 
    .stat_tx_packet_4096_8191_bytes_2 (stat_tx_packet_4096_8191_bytes_2   ), 
    .stat_tx_packet_8192_9215_bytes_2 (stat_tx_packet_8192_9215_bytes_2   ), 
    .stat_tx_packet_small_2           (stat_tx_packet_small_2             ), 
    .stat_tx_packet_large_2           (stat_tx_packet_large_2             ), 
    .stat_tx_unicast_2                (stat_tx_unicast_2                  ), 
    .stat_tx_multicast_2              (stat_tx_multicast_2                ), 
    .stat_tx_broadcast_2              (stat_tx_broadcast_2                ), 
    .stat_tx_vlan_2                   (stat_tx_vlan_2                     ), 
    .stat_tx_frame_error_2            (stat_tx_frame_error_2              ), 
    
    .ctl_tx_enable_2                  (ctl_tx_enable_2                    ), 
    .ctl_tx_send_rfi_2                (ctl_tx_send_rfi_2                  ), 
    .ctl_tx_send_lfi_2                (ctl_tx_send_lfi_2                  ), 
    .ctl_tx_send_idle_2               (ctl_tx_send_idle_2                 ), 
    .ctl_tx_fcs_ins_enable_2          (ctl_tx_fcs_ins_enable_2            ), 
    .ctl_tx_ignore_fcs_2              (ctl_tx_ignore_fcs_2                ), 
    .ctl_tx_test_pattern_2            (ctl_tx_test_pattern_2              ), 
    .ctl_tx_test_pattern_enable_2     (ctl_tx_test_pattern_enable_2       ), 
    .ctl_tx_test_pattern_select_2     (ctl_tx_test_pattern_select_2       ), 
    .ctl_tx_data_pattern_select_2     (ctl_tx_data_pattern_select_2       ), 
    .ctl_tx_test_pattern_seed_a_2     (ctl_tx_test_pattern_seed_a_2       ), 
    .ctl_tx_test_pattern_seed_b_2     (ctl_tx_test_pattern_seed_b_2       ), 
    .ctl_tx_ipg_value_2               (ctl_tx_ipg_value_2                 ), 
    .ctl_tx_custom_preamble_enable_2  (ctl_tx_custom_preamble_enable_2    ), 
    .gt_loopback_in_2                 (gt_loopback_in_2                   ), 
    /*======================================================*/
    /*======================= sfp3 =========================*/
    /*======================================================*/
    .rx_core_clk_3                    (rx_core_clk_3                      ), 
    .txoutclksel_in_3                 (txoutclksel_in_3                   ), 
    .rxoutclksel_in_3                 (rxoutclksel_in_3                   ), 
    .gtwiz_reset_tx_datapath_3        (gtwiz_reset_tx_datapath_3          ), 
    .gtwiz_reset_rx_datapath_3        (gtwiz_reset_rx_datapath_3          ), 
    .rxrecclkout_3                    (rxrecclkout_3                      ), 
    .tx_clk_out_3                     (tx_clk_out_3                       ), 
    .rx_clk_out_3                     (rx_clk_out_3                       ), 
    .gtpowergood_out_3                (gtpowergood_out_3                  ), 
    
    .rx_reset_3                       (rx_reset_3                         ), 
    .user_rx_reset_3                  (user_rx_reset_3                    ), 
    .rx_axis_tvalid_3                 (rx_axis_tvalid_3                   ), 
    .rx_axis_tdata_3                  (rx_axis_tdata_3                    ), 
    .rx_axis_tlast_3                  (rx_axis_tlast_3                    ), 
    .rx_axis_tkeep_3                  (rx_axis_tkeep_3                    ), 
    .rx_axis_tuser_3                  (rx_axis_tuser_3                    ), 
    
    .ctl_rx_enable_3                  (ctl_rx_enable_3                    ), 
    .ctl_rx_check_preamble_3          (ctl_rx_check_preamble_3            ), 
    .ctl_rx_check_sfd_3               (ctl_rx_check_sfd_3                 ), 
    .ctl_rx_force_resync_3            (ctl_rx_force_resync_3              ), 
    .ctl_rx_delete_fcs_3              (ctl_rx_delete_fcs_3                ), 
    .ctl_rx_ignore_fcs_3              (ctl_rx_ignore_fcs_3                ), 
    .ctl_rx_max_packet_len_3          (ctl_rx_max_packet_len_3            ), 
    .ctl_rx_min_packet_len_3          (ctl_rx_min_packet_len_3            ), 
    .ctl_rx_process_lfi_3             (ctl_rx_process_lfi_3               ), 
    .ctl_rx_test_pattern_3            (ctl_rx_test_pattern_3              ), 
    .ctl_rx_data_pattern_select_3     (ctl_rx_data_pattern_select_3       ), 
    .ctl_rx_test_pattern_enable_3     (ctl_rx_test_pattern_enable_3       ), 
    .ctl_rx_custom_preamble_enable_3  (ctl_rx_custom_preamble_enable_3    ), 
    
    .stat_rx_framing_err_3            (stat_rx_framing_err_3              ), 
    .stat_rx_framing_err_valid_3      (stat_rx_framing_err_valid_3        ), 
    .stat_rx_local_fault_3            (stat_rx_local_fault_3              ), 
    .stat_rx_block_lock_3             (stat_rx_block_lock_3               ), 
    .stat_rx_valid_ctrl_code_3        (stat_rx_valid_ctrl_code_3          ), 
    .stat_rx_status_3                 (stat_rx_status_3                   ), 
    .stat_rx_remote_fault_3           (stat_rx_remote_fault_3             ), 
    .stat_rx_bad_fcs_3                (stat_rx_bad_fcs_3                  ), 
    .stat_rx_stomped_fcs_3            (stat_rx_stomped_fcs_3              ), 
    .stat_rx_truncated_3              (stat_rx_truncated_3                ), 
    .stat_rx_internal_local_fault_3   (stat_rx_internal_local_fault_3     ), 
    .stat_rx_received_local_fault_3   (stat_rx_received_local_fault_3     ), 
    .stat_rx_hi_ber_3                 (stat_rx_hi_ber_3                   ), 
    .stat_rx_got_signal_os_3          (stat_rx_got_signal_os_3            ), 
    .stat_rx_test_pattern_mismatch_3  (stat_rx_test_pattern_mismatch_3    ), 
    .stat_rx_total_bytes_3            (stat_rx_total_bytes_3              ), 
    .stat_rx_total_packets_3          (stat_rx_total_packets_3            ), 
    .stat_rx_total_good_bytes_3       (stat_rx_total_good_bytes_3         ), 
    .stat_rx_total_good_packets_3     (stat_rx_total_good_packets_3       ), 
    .stat_rx_packet_bad_fcs_3         (stat_rx_packet_bad_fcs_3           ), 
    .stat_rx_packet_64_bytes_3        (stat_rx_packet_64_bytes_3          ), 
    .stat_rx_packet_65_127_bytes_3    (stat_rx_packet_65_127_bytes_3      ), 
    .stat_rx_packet_128_255_bytes_3   (stat_rx_packet_128_255_bytes_3     ), 
    .stat_rx_packet_256_511_bytes_3   (stat_rx_packet_256_511_bytes_3     ), 
    .stat_rx_packet_512_1023_bytes_3  (stat_rx_packet_512_1023_bytes_3    ), 
    .stat_rx_packet_1024_1518_bytes_3 (stat_rx_packet_1024_1518_bytes_3   ), 
    .stat_rx_packet_1519_1522_bytes_3 (stat_rx_packet_1519_1522_bytes_3   ), 
    .stat_rx_packet_1523_1548_bytes_3 (stat_rx_packet_1523_1548_bytes_3   ), 
    .stat_rx_packet_1549_2047_bytes_3 (stat_rx_packet_1549_2047_bytes_3   ), 
    .stat_rx_packet_2048_4095_bytes_3 (stat_rx_packet_2048_4095_bytes_3   ), 
    .stat_rx_packet_4096_8191_bytes_3 (stat_rx_packet_4096_8191_bytes_3   ), 
    .stat_rx_packet_8192_9215_bytes_3 (stat_rx_packet_8192_9215_bytes_3   ), 
    .stat_rx_packet_small_3           (stat_rx_packet_small_3             ), 
    .stat_rx_packet_large_3           (stat_rx_packet_large_3             ), 
    .stat_rx_unicast_3                (stat_rx_unicast_3                  ), 
    .stat_rx_multicast_3              (stat_rx_multicast_3                ), 
    .stat_rx_broadcast_3              (stat_rx_broadcast_3                ), 
    .stat_rx_oversize_3               (stat_rx_oversize_3                 ), 
    .stat_rx_toolong_3                (stat_rx_toolong_3                  ), 
    .stat_rx_undersize_3              (stat_rx_undersize_3                ), 
    .stat_rx_fragment_3               (stat_rx_fragment_3                 ), 
    .stat_rx_vlan_3                   (stat_rx_vlan_3                     ), 
    .stat_rx_inrangeerr_3             (stat_rx_inrangeerr_3               ), 
    .stat_rx_jabber_3                 (stat_rx_jabber_3                   ), 
    .stat_rx_bad_code_3               (stat_rx_bad_code_3                 ), 
    .stat_rx_bad_sfd_3                (stat_rx_bad_sfd_3                  ), 
    .stat_rx_bad_preamble_3           (stat_rx_bad_preamble_3             ), 
    
    .tx_reset_3                       (tx_reset_3                         ), 
    .user_tx_reset_3                  (user_tx_reset_3                    ), 
    .tx_axis_tready_3                 (tx_axis_tready_3                   ), 
    .tx_axis_tvalid_3                 (tx_axis_tvalid_3                   ), 
    .tx_axis_tdata_3                  (tx_axis_tdata_3                    ), 
    .tx_axis_tlast_3                  (tx_axis_tlast_3                    ), 
    .tx_axis_tkeep_3                  (tx_axis_tkeep_3                    ), 
    .tx_axis_tuser_3                  (tx_axis_tuser_3                    ),    
    .tx_unfout_3                      (tx_unfout_3                        ), 
    .tx_preamblein_3                  (tx_preamblein_3                    ), 
    .rx_preambleout_3                 (rx_preambleout_3                   ), 
    
    .stat_tx_local_fault_3            (stat_tx_local_fault_3              ), 
    .stat_tx_total_bytes_3            (stat_tx_total_bytes_3              ), 
    .stat_tx_total_packets_3          (stat_tx_total_packets_3            ), 
    .stat_tx_total_good_bytes_3       (stat_tx_total_good_bytes_3         ), 
    .stat_tx_total_good_packets_3     (stat_tx_total_good_packets_3       ), 
    .stat_tx_bad_fcs_3                (stat_tx_bad_fcs_3                  ), 
    .stat_tx_packet_64_bytes_3        (stat_tx_packet_64_bytes_3          ), 
    .stat_tx_packet_65_127_bytes_3    (stat_tx_packet_65_127_bytes_3      ), 
    .stat_tx_packet_128_255_bytes_3   (stat_tx_packet_128_255_bytes_3     ), 
    .stat_tx_packet_256_511_bytes_3   (stat_tx_packet_256_511_bytes_3     ), 
    .stat_tx_packet_512_1023_bytes_3  (stat_tx_packet_512_1023_bytes_3    ), 
    .stat_tx_packet_1024_1518_bytes_3 (stat_tx_packet_1024_1518_bytes_3   ), 
    .stat_tx_packet_1519_1522_bytes_3 (stat_tx_packet_1519_1522_bytes_3   ), 
    .stat_tx_packet_1523_1548_bytes_3 (stat_tx_packet_1523_1548_bytes_3   ), 
    .stat_tx_packet_1549_2047_bytes_3 (stat_tx_packet_1549_2047_bytes_3   ), 
    .stat_tx_packet_2048_4095_bytes_3 (stat_tx_packet_2048_4095_bytes_3   ), 
    .stat_tx_packet_4096_8191_bytes_3 (stat_tx_packet_4096_8191_bytes_3   ), 
    .stat_tx_packet_8192_9215_bytes_3 (stat_tx_packet_8192_9215_bytes_3   ), 
    .stat_tx_packet_small_3           (stat_tx_packet_small_3             ), 
    .stat_tx_packet_large_3           (stat_tx_packet_large_3             ), 
    .stat_tx_unicast_3                (stat_tx_unicast_3                  ), 
    .stat_tx_multicast_3              (stat_tx_multicast_3                ), 
    .stat_tx_broadcast_3              (stat_tx_broadcast_3                ), 
    .stat_tx_vlan_3                   (stat_tx_vlan_3                     ), 
    .stat_tx_frame_error_3            (stat_tx_frame_error_3              ), 
    
    .ctl_tx_enable_3                  (ctl_tx_enable_3                    ), 
    .ctl_tx_send_rfi_3                (ctl_tx_send_rfi_3                  ), 
    .ctl_tx_send_lfi_3                (ctl_tx_send_lfi_3                  ), 
    .ctl_tx_send_idle_3               (ctl_tx_send_idle_3                 ), 
    .ctl_tx_fcs_ins_enable_3          (ctl_tx_fcs_ins_enable_3            ), 
    .ctl_tx_ignore_fcs_3              (ctl_tx_ignore_fcs_3                ), 
    .ctl_tx_test_pattern_3            (ctl_tx_test_pattern_3              ), 
    .ctl_tx_test_pattern_enable_3     (ctl_tx_test_pattern_enable_3       ), 
    .ctl_tx_test_pattern_select_3     (ctl_tx_test_pattern_select_3       ), 
    .ctl_tx_data_pattern_select_3     (ctl_tx_data_pattern_select_3       ), 
    .ctl_tx_test_pattern_seed_a_3     (ctl_tx_test_pattern_seed_a_3       ), 
    .ctl_tx_test_pattern_seed_b_3     (ctl_tx_test_pattern_seed_b_3       ), 
    .ctl_tx_ipg_value_3               (ctl_tx_ipg_value_3                 ), 
    .ctl_tx_custom_preamble_enable_3  (ctl_tx_custom_preamble_enable_3    ), 
    .gt_loopback_in_3                 (gt_loopback_in_3                   )
);

/*============================================ assign ================================================*/
assign      o_chnl_led     = {stat_rx_status_3,stat_rx_status_2,stat_rx_status_1,stat_rx_status_0};
assign      o_sfp_disable  = 4'b0000          ;
/*======================= sfp0 =========================*/
assign gt_loopback_in_0                 = 3'b000        ;
assign rx_core_clk_0                    = tx_clk_out_0  ; 
assign txoutclksel_in_0                 = 3'b101        ;
assign rxoutclksel_in_0                 = 3'b101        ;
assign gtwiz_reset_tx_datapath_0        = 1'b0          ;
assign gtwiz_reset_rx_datapath_0        = 1'b0          ;
assign rx_reset_0                       = 1'b0          ;
assign qpllreset_in_0                   = 1'b0          ;
/*----ctrl rx----*/ 
assign ctl_rx_enable_0                  = 1'b1          ;
assign ctl_rx_check_preamble_0          = 1'b1          ;
assign ctl_rx_check_sfd_0               = 1'b1          ;
assign ctl_rx_force_resync_0            = 1'b0          ;
assign ctl_rx_delete_fcs_0              = 1'b1          ;
assign ctl_rx_ignore_fcs_0              = 1'b0          ;
assign ctl_rx_max_packet_len_0          = MAX_LENGTH    ;
assign ctl_rx_min_packet_len_0          = MIN_LENGTH    ;
assign ctl_rx_process_lfi_0             = 1'b0          ;
assign ctl_rx_test_pattern_0            = 1'b0          ;
assign ctl_rx_test_pattern_enable_0     = 1'b0          ;
assign ctl_rx_data_pattern_select_0     = 1'b0          ;
assign ctl_rx_custom_preamble_enable_0  = 1'b0          ;
/*----tx single----*/
assign tx_preamblein_0                  = 55'h55_55_55_55_55_55_55;
assign tx_reset_0                       = 1'b0          ;
assign ctl_tx_enable_0                  = 1'b1          ;
assign ctl_tx_send_rfi_0                = 1'b0          ;
assign ctl_tx_send_lfi_0                = 1'b0          ;
assign ctl_tx_send_idle_0               = 1'b0          ;
assign ctl_tx_fcs_ins_enable_0          = 1'b1          ;
assign ctl_tx_ignore_fcs_0              = 1'b0          ;
assign ctl_tx_test_pattern_0            = 'd0           ;
assign ctl_tx_test_pattern_enable_0     = 'd0           ;
assign ctl_tx_test_pattern_select_0     = 'd0           ;
assign ctl_tx_data_pattern_select_0     = 'd0           ;
assign ctl_tx_test_pattern_seed_a_0     = 'd0           ;
assign ctl_tx_test_pattern_seed_b_0     = 'd0           ;
assign ctl_tx_ipg_value_0               = 4'd12         ;
assign ctl_tx_custom_preamble_enable_0  = 1'b0          ;

/*======================= sfp1 =========================*/
assign gt_loopback_in_1                 = 3'b000        ;
assign rx_core_clk_1                    = tx_clk_out_0  ; 
assign txoutclksel_in_1                 = 3'b101        ;
assign rxoutclksel_in_1                 = 3'b101        ;
assign gtwiz_reset_tx_datapath_1        = 1'b0          ;
assign gtwiz_reset_rx_datapath_1        = 1'b0          ;
assign rx_reset_1                       = 1'b0          ;
assign qpllreset_in_1                   = 1'b0          ;
/*----ctrl rx----*/ 
assign ctl_rx_enable_1                  = 1'b1          ;
assign ctl_rx_check_preamble_1          = 1'b1          ;
assign ctl_rx_check_sfd_1               = 1'b1          ;
assign ctl_rx_force_resync_1            = 1'b0          ;
assign ctl_rx_delete_fcs_1              = 1'b1          ;
assign ctl_rx_ignore_fcs_1              = 1'b0          ;
assign ctl_rx_max_packet_len_1          = MAX_LENGTH    ;
assign ctl_rx_min_packet_len_1          = MIN_LENGTH    ;
assign ctl_rx_process_lfi_1             = 1'b0          ;
assign ctl_rx_test_pattern_1            = 1'b0          ;
assign ctl_rx_test_pattern_enable_1     = 1'b0          ;
assign ctl_rx_data_pattern_select_1     = 1'b0          ;
assign ctl_rx_custom_preamble_enable_1  = 1'b0          ;
/*----tx single----*/
assign tx_preamblein_1                  = 55'h55_55_55_55_55_55_55;
assign tx_reset_1                       = 1'b0          ;
assign ctl_tx_enable_1                  = 1'b1          ;
assign ctl_tx_send_rfi_1                = 1'b0          ;
assign ctl_tx_send_lfi_1                = 1'b0          ;
assign ctl_tx_send_idle_1               = 1'b0          ;
assign ctl_tx_fcs_ins_enable_1          = 1'b1          ;
assign ctl_tx_ignore_fcs_1              = 1'b0          ;
assign ctl_tx_test_pattern_1            = 'd0           ;
assign ctl_tx_test_pattern_enable_1     = 'd0           ;
assign ctl_tx_test_pattern_select_1     = 'd0           ;
assign ctl_tx_data_pattern_select_1     = 'd0           ;
assign ctl_tx_test_pattern_seed_a_1     = 'd0           ;
assign ctl_tx_test_pattern_seed_b_1     = 'd0           ;
assign ctl_tx_ipg_value_1               = 4'd12         ;
assign ctl_tx_custom_preamble_enable_1  = 1'b0          ;

/*======================= sfp2 =========================*/
assign gt_loopback_in_2                 = 3'b000        ;
assign rx_core_clk_2                    = tx_clk_out_0  ; 
assign txoutclksel_in_2                 = 3'b101        ;
assign rxoutclksel_in_2                 = 3'b101        ;
assign gtwiz_reset_tx_datapath_2        = 1'b0          ;
assign gtwiz_reset_rx_datapath_2        = 1'b0          ;
assign rx_reset_2                       = 1'b0          ;
assign qpllreset_in_2                   = 1'b0          ;
/*----ctrl rx----*/ 
assign ctl_rx_enable_2                  = 1'b1          ;
assign ctl_rx_check_preamble_2          = 1'b1          ;
assign ctl_rx_check_sfd_2               = 1'b1          ;
assign ctl_rx_force_resync_2            = 1'b0          ;
assign ctl_rx_delete_fcs_2              = 1'b1          ;
assign ctl_rx_ignore_fcs_2              = 1'b0          ;
assign ctl_rx_max_packet_len_2          = MAX_LENGTH    ;
assign ctl_rx_min_packet_len_2          = MIN_LENGTH    ;
assign ctl_rx_process_lfi_2             = 1'b0          ;
assign ctl_rx_test_pattern_2            = 1'b0          ;
assign ctl_rx_test_pattern_enable_2     = 1'b0          ;
assign ctl_rx_data_pattern_select_2     = 1'b0          ;
assign ctl_rx_custom_preamble_enable_2  = 1'b0          ;
/*----tx single----*/
assign tx_preamblein_2                  = 55'h55_55_55_55_55_55_55;
assign tx_reset_2                       = 1'b0          ;
assign ctl_tx_enable_2                  = 1'b1          ;
assign ctl_tx_send_rfi_2                = 1'b0          ;
assign ctl_tx_send_lfi_2                = 1'b0          ;
assign ctl_tx_send_idle_2               = 1'b0          ;
assign ctl_tx_fcs_ins_enable_2          = 1'b1          ;
assign ctl_tx_ignore_fcs_2              = 1'b0          ;
assign ctl_tx_test_pattern_2            = 'd0           ;
assign ctl_tx_test_pattern_enable_2     = 'd0           ;
assign ctl_tx_test_pattern_select_2     = 'd0           ;
assign ctl_tx_data_pattern_select_2     = 'd0           ;
assign ctl_tx_test_pattern_seed_a_2     = 'd0           ;
assign ctl_tx_test_pattern_seed_b_2     = 'd0           ;
assign ctl_tx_ipg_value_2               = 4'd12         ;
assign ctl_tx_custom_preamble_enable_2  = 1'b0          ;

/*======================= sfp3 =========================*/
assign gt_loopback_in_3                 = 3'b000        ;
assign rx_core_clk_3                    = tx_clk_out_0  ; 
assign txoutclksel_in_3                 = 3'b101        ;
assign rxoutclksel_in_3                 = 3'b101        ;
assign gtwiz_reset_tx_datapath_3        = 1'b0          ;
assign gtwiz_reset_rx_datapath_3        = 1'b0          ;
assign rx_reset_3                       = 1'b0          ;
assign qpllreset_in_3                   = 1'b0          ;
/*----ctrl rx----*/ 
assign ctl_rx_enable_3                  = 1'b1          ;
assign ctl_rx_check_preamble_3          = 1'b1          ;
assign ctl_rx_check_sfd_3               = 1'b1          ;
assign ctl_rx_force_resync_3            = 1'b0          ;
assign ctl_rx_delete_fcs_3              = 1'b1          ;
assign ctl_rx_ignore_fcs_3              = 1'b0          ;
assign ctl_rx_max_packet_len_3          = MAX_LENGTH    ;
assign ctl_rx_min_packet_len_3          = MIN_LENGTH    ;
assign ctl_rx_process_lfi_3             = 1'b0          ;
assign ctl_rx_test_pattern_3            = 1'b0          ;
assign ctl_rx_test_pattern_enable_3     = 1'b0          ;
assign ctl_rx_data_pattern_select_3     = 1'b0          ;
assign ctl_rx_custom_preamble_enable_3  = 1'b0          ;
/*----tx single----*/
assign tx_preamblein_3                  = 55'h55_55_55_55_55_55_55;
assign tx_reset_3                       = 1'b0          ;
assign ctl_tx_enable_3                  = 1'b1          ;
assign ctl_tx_send_rfi_3                = 1'b0          ;
assign ctl_tx_send_lfi_3                = 1'b0          ;
assign ctl_tx_send_idle_3               = 1'b0          ;
assign ctl_tx_fcs_ins_enable_3          = 1'b1          ;
assign ctl_tx_ignore_fcs_3              = 1'b0          ;
assign ctl_tx_test_pattern_3            = 'd0           ;
assign ctl_tx_test_pattern_enable_3     = 'd0           ;
assign ctl_tx_test_pattern_select_3     = 'd0           ;
assign ctl_tx_data_pattern_select_3     = 'd0           ;
assign ctl_tx_test_pattern_seed_a_3     = 'd0           ;
assign ctl_tx_test_pattern_seed_b_3     = 'd0           ;
assign ctl_tx_ipg_value_3               = 4'd12         ;
assign ctl_tx_custom_preamble_enable_3  = 1'b0          ;
endmodule
