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
    input                       i_gt_refclk_p       ,
    input                       i_gt_refclk_n       ,
    input                       i_sys_clk_p         ,
    input                       i_sys_clk_n         ,
    output [P_CHANNEL_NUM-1:0]  o_gt_txp            ,
    output [P_CHANNEL_NUM-1:0]  o_gt_txn            ,
    input  [P_CHANNEL_NUM-1:0]  i_gt_rxp            ,
    input  [P_CHANNEL_NUM-1:0]  i_gt_rxn            ,
    output [P_CHANNEL_NUM-1:0]  o_sfp_dis           
);

assign o_sfp_dis = 1'b0;

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
    .i_gt_refclk_p          (i_gt_refclk_p      ),
    .i_gt_refclk_n          (i_gt_refclk_n      ),
    .i_dclk                 (i_dclk             ),
    .i_sys_reset            (w_sys_reset        ),

    .o_gt_txp               (o_gt_txp[P_CHANNEL_NUM-1:0]),
    .o_gt_txn               (o_gt_txn[P_CHANNEL_NUM-1:0]),
    .i_gt_rxp               (i_gt_rxp[P_CHANNEL_NUM-1:0]),
    .i_gt_rxn               (i_gt_rxn[P_CHANNEL_NUM-1:0]),

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
    .rx0_axis_tuser         (rx0_axis_tuser     )
);

endmodule
