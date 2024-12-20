`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/19 20:27:06
// Design Name: 
// Module Name: OCS_controller
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
/*控制器有8个channel，连接8个ToR，当对应连接的所有的ToR的链路
状态稳定后，第一个时隙开始，下发一个时间同步指令给所有ToR，
所有ToR下行连接的server开始产生数据，等待一个完整的时隙后，开始切换
ocs状态，等待切换时延结束后，下发一次时间同步，标志一次全新的时隙开始*/

module OCS_controller#(
    parameter                   P_CHANNEL_NUM   = 8         ,
    parameter                   P_MIN_LENGTH    = 8'd64     ,
    parameter                   P_MAX_LENGTH    = 15'd9600 
)(
    input                       i_gt_0_refclk_p     ,
    input                       i_gt_0_refclk_n     ,
    input                       i_gt_1_refclk_p     ,
    input                       i_gt_1_refclk_n     ,
    input                       i_sys_clk_p         ,
    input                       i_sys_clk_n         ,
    output [P_CHANNEL_NUM-1:0]  o_gt_txp            ,
    output [P_CHANNEL_NUM-1:0]  o_gt_txn            ,
    input  [P_CHANNEL_NUM-1:0]  i_gt_rxp            ,
    input  [P_CHANNEL_NUM-1:0]  i_gt_rxn            ,
    output [P_CHANNEL_NUM-1:0]  o_sfp_dis           
);

assign o_sfp_dis = 8'b0000_0000;

wire            w_dclk              ;
wire            w_locked            ;
wire            w_sys_reset         ;

clk_wiz_100Mhz clk_wiz_100Mhz_u0
(
    .clk_out1               (w_dclk         ),  
    .locked                 (w_locked       ),  
    .clk_in1_p              (i_sys_clk_p    ),  
    .clk_in1_n              (i_sys_clk_n    )   
);

rst_gen_module#(
    .P_RST_CYCLE            (20)   
)rst_gen_module_u0(
    .i_clk                  (w_dclk         ),
    .i_rst                  (~w_locked      ),
    .o_rst                  (w_sys_reset    ) 
);

ten_gig_ctrl_module#(
    .P_CHANNEL_NUM          (P_CHANNEL_NUM >> 2 ),
    .P_MIN_LENGTH           (P_MIN_LENGTH       ),
    .P_MAX_LENGTH           (P_MAX_LENGTH       )
)ten_gig_ctrl_module_u0(
    .i_gt_refclk_p          (i_gt_0_refclk_p    ),
    .i_gt_refclk_n          (i_gt_0_refclk_n    ),
    .i_dclk                 (i_dclk             ),
    .i_sys_reset            (w_sys_reset        ),

    .o_gt_txp               (o_gt_txp[3:0]),
    .o_gt_txn               (o_gt_txn[3:0]),
    .i_gt_rxp               (i_gt_rxp[3:0]),
    .i_gt_rxn               (i_gt_rxn[3:0]),

    .o_0_tx_clk_out         (o_0_tx_clk_out     ),
    .o_0_rx_clk_out         (o_0_rx_clk_out     ),
    .o_0_user_tx_reset      (o_0_user_tx_reset  ),
    .o_0_user_rx_reset      (o_0_user_rx_reset  ),
    .o_0_stat_rx_status     (o_0_stat_rx_status ),
    .tx0_axis_tready        (tx0_axis_tready    ),
    .tx0_axis_tvalid        (tx0_axis_tvalid    ),
    .tx0_axis_tdata         (tx0_axis_tdata     ),
    .tx0_axis_tlast         (tx0_axis_tlast     ),
    .tx0_axis_tkeep         (tx0_axis_tkeep     ),
    .tx0_axis_tuser         (tx0_axis_tuser     ),
    .rx0_axis_tvalid        (rx0_axis_tvalid    ),
    .rx0_axis_tdata         (rx0_axis_tdata     ),
    .rx0_axis_tlast         (rx0_axis_tlast     ),
    .rx0_axis_tkeep         (rx0_axis_tkeep     ),
    .rx0_axis_tuser         (rx0_axis_tuser     ),

    .o_1_tx_clk_out         (o_1_tx_clk_out     ),
    .o_1_rx_clk_out         (o_1_rx_clk_out     ),
    .o_1_user_tx_reset      (o_1_user_tx_reset  ),
    .o_1_user_rx_reset      (o_1_user_rx_reset  ),
    .o_1_stat_rx_status     (o_1_stat_rx_status ),
    .tx1_axis_tready        (tx1_axis_tready    ),
    .tx1_axis_tvalid        (tx1_axis_tvalid    ),
    .tx1_axis_tdata         (tx1_axis_tdata     ),
    .tx1_axis_tlast         (tx1_axis_tlast     ),
    .tx1_axis_tkeep         (tx1_axis_tkeep     ),
    .tx1_axis_tuser         (tx1_axis_tuser     ),
    .rx1_axis_tvalid        (rx1_axis_tvalid    ),
    .rx1_axis_tdata         (rx1_axis_tdata     ),
    .rx1_axis_tlast         (rx1_axis_tlast     ),
    .rx1_axis_tkeep         (rx1_axis_tkeep     ),
    .rx1_axis_tuser         (rx1_axis_tuser     ),

    .o_2_tx_clk_out         (o_2_tx_clk_out     ),
    .o_2_rx_clk_out         (o_2_rx_clk_out     ),
    .o_2_user_tx_reset      (o_2_user_tx_reset  ),
    .o_2_user_rx_reset      (o_2_user_rx_reset  ),
    .o_2_stat_rx_status     (o_2_stat_rx_status ),
    .tx2_axis_tready        (tx2_axis_tready    ),
    .tx2_axis_tvalid        (tx2_axis_tvalid    ),
    .tx2_axis_tdata         (tx2_axis_tdata     ),
    .tx2_axis_tlast         (tx2_axis_tlast     ),
    .tx2_axis_tkeep         (tx2_axis_tkeep     ),
    .tx2_axis_tuser         (tx2_axis_tuser     ),
    .rx2_axis_tvalid        (rx2_axis_tvalid    ),
    .rx2_axis_tdata         (rx2_axis_tdata     ),
    .rx2_axis_tlast         (rx2_axis_tlast     ),
    .rx2_axis_tkeep         (rx2_axis_tkeep     ),
    .rx2_axis_tuser         (rx2_axis_tuser     ),

    .o_3_tx_clk_out         (o_3_tx_clk_out     ),
    .o_3_rx_clk_out         (o_3_rx_clk_out     ),
    .o_3_user_tx_reset      (o_3_user_tx_reset  ),
    .o_3_user_rx_reset      (o_3_user_rx_reset  ),
    .o_3_stat_rx_status     (o_3_stat_rx_status ),
    .tx3_axis_tready        (tx3_axis_tready    ),
    .tx3_axis_tvalid        (tx3_axis_tvalid    ),
    .tx3_axis_tdata         (tx3_axis_tdata     ),
    .tx3_axis_tlast         (tx3_axis_tlast     ),
    .tx3_axis_tkeep         (tx3_axis_tkeep     ),
    .tx3_axis_tuser         (tx3_axis_tuser     ),
    .rx3_axis_tvalid        (rx3_axis_tvalid    ),
    .rx3_axis_tdata         (rx3_axis_tdata     ),
    .rx3_axis_tlast         (rx3_axis_tlast     ),
    .rx3_axis_tkeep         (rx3_axis_tkeep     ),
    .rx3_axis_tuser         (rx3_axis_tuser     )
);


ten_gig_ctrl_module#(
    .P_CHANNEL_NUM          (P_CHANNEL_NUM >> 2 ),
    .P_MIN_LENGTH           (P_MIN_LENGTH       ),
    .P_MAX_LENGTH           (P_MAX_LENGTH       )
)ten_gig_ctrl_module_u1(
    .i_gt_refclk_p          (i_gt_1_refclk_p    ),
    .i_gt_refclk_n          (i_gt_1_refclk_n    ),
    .i_dclk                 (i_dclk             ),
    .i_sys_reset            (w_sys_reset        ),

    .o_gt_txp               (o_gt_txp[P_CHANNEL_NUM-1:4]),
    .o_gt_txn               (o_gt_txn[P_CHANNEL_NUM-1:4]),
    .i_gt_rxp               (i_gt_rxp[P_CHANNEL_NUM-1:4]),
    .i_gt_rxn               (i_gt_rxn[P_CHANNEL_NUM-1:4]),

    .o_0_tx_clk_out         (o_4_tx_clk_out     ),
    .o_0_rx_clk_out         (o_4_rx_clk_out     ),
    .o_0_user_tx_reset      (o_4_user_tx_reset  ),
    .o_0_user_rx_reset      (o_4_user_rx_reset  ),
    .o_0_stat_rx_status     (o_4_stat_rx_status ),
    .tx0_axis_tready        (tx4_axis_tready    ),
    .tx0_axis_tvalid        (tx4_axis_tvalid    ),
    .tx0_axis_tdata         (tx4_axis_tdata     ),
    .tx0_axis_tlast         (tx4_axis_tlast     ),
    .tx0_axis_tkeep         (tx4_axis_tkeep     ),
    .tx0_axis_tuser         (tx4_axis_tuser     ),
    .rx0_axis_tvalid        (rx4_axis_tvalid    ),
    .rx0_axis_tdata         (rx4_axis_tdata     ),
    .rx0_axis_tlast         (rx4_axis_tlast     ),
    .rx0_axis_tkeep         (rx4_axis_tkeep     ),
    .rx0_axis_tuser         (rx4_axis_tuser     ),

    .o_1_tx_clk_out         (o_5_tx_clk_out     ),
    .o_1_rx_clk_out         (o_5_rx_clk_out     ),
    .o_1_user_tx_reset      (o_5_user_tx_reset  ),
    .o_1_user_rx_reset      (o_5_user_rx_reset  ),
    .o_1_stat_rx_status     (o_5_stat_rx_status ),
    .tx1_axis_tready        (tx5_axis_tready    ),
    .tx1_axis_tvalid        (tx5_axis_tvalid    ),
    .tx1_axis_tdata         (tx5_axis_tdata     ),
    .tx1_axis_tlast         (tx5_axis_tlast     ),
    .tx1_axis_tkeep         (tx5_axis_tkeep     ),
    .tx1_axis_tuser         (tx5_axis_tuser     ),
    .rx1_axis_tvalid        (rx5_axis_tvalid    ),
    .rx1_axis_tdata         (rx5_axis_tdata     ),
    .rx1_axis_tlast         (rx5_axis_tlast     ),
    .rx1_axis_tkeep         (rx5_axis_tkeep     ),
    .rx1_axis_tuser         (rx5_axis_tuser     ),

    .o_2_tx_clk_out         (o_6_tx_clk_out     ),
    .o_2_rx_clk_out         (o_6_rx_clk_out     ),
    .o_2_user_tx_reset      (o_6_user_tx_reset  ),
    .o_2_user_rx_reset      (o_6_user_rx_reset  ),
    .o_2_stat_rx_status     (o_6_stat_rx_status ),
    .tx2_axis_tready        (tx6_axis_tready    ),
    .tx2_axis_tvalid        (tx6_axis_tvalid    ),
    .tx2_axis_tdata         (tx6_axis_tdata     ),
    .tx2_axis_tlast         (tx6_axis_tlast     ),
    .tx2_axis_tkeep         (tx6_axis_tkeep     ),
    .tx2_axis_tuser         (tx6_axis_tuser     ),
    .rx2_axis_tvalid        (rx6_axis_tvalid    ),
    .rx2_axis_tdata         (rx6_axis_tdata     ),
    .rx2_axis_tlast         (rx6_axis_tlast     ),
    .rx2_axis_tkeep         (rx6_axis_tkeep     ),
    .rx2_axis_tuser         (rx6_axis_tuser     ),

    .o_3_tx_clk_out         (o_7_tx_clk_out     ),
    .o_3_rx_clk_out         (o_7_rx_clk_out     ),
    .o_3_user_tx_reset      (o_7_user_tx_reset  ),
    .o_3_user_rx_reset      (o_7_user_rx_reset  ),
    .o_3_stat_rx_status     (o_7_stat_rx_status ),
    .tx3_axis_tready        (tx7_axis_tready    ),
    .tx3_axis_tvalid        (tx7_axis_tvalid    ),
    .tx3_axis_tdata         (tx7_axis_tdata     ),
    .tx3_axis_tlast         (tx7_axis_tlast     ),
    .tx3_axis_tkeep         (tx7_axis_tkeep     ),
    .tx3_axis_tuser         (tx7_axis_tuser     ),
    .rx3_axis_tvalid        (rx7_axis_tvalid    ),
    .rx3_axis_tdata         (rx7_axis_tdata     ),
    .rx3_axis_tlast         (rx7_axis_tlast     ),
    .rx3_axis_tkeep         (rx7_axis_tkeep     ),
    .rx3_axis_tuser         (rx7_axis_tuser     )
);

endmodule
