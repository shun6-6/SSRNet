`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/19 11:04:53
// Design Name: 
// Module Name: VCU128_10g_eth_top
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


module VCU128_10g_eth_top#(
    parameter                   P_CHANNEL_NUM   = 2         ,
    parameter                   P_MIN_LENGTH    = 8'd64     ,
    parameter                   P_MAX_LENGTH    = 15'd9600 
)(
    input                       i_gt_refclk_p   ,
    input                       i_gt_refclk_n   ,
    input                       i_sys_clk_p     ,
    input                       i_sys_clk_n     ,
    output [P_CHANNEL_NUM-1:0]  o_gt_txp        ,
    output [P_CHANNEL_NUM-1:0]  o_gt_txn        ,
    input  [P_CHANNEL_NUM-1:0]  i_gt_rxp        ,
    input  [P_CHANNEL_NUM-1:0]  i_gt_rxn        ,
    output [P_CHANNEL_NUM-1:0]  o_sfp_dis       ,

    output                      o_0_tx_clk_out      ,
    output                      o_0_rx_clk_out      ,
    output                      o_0_user_tx_reset   ,
    output                      o_0_user_rx_reset   ,
    output                      o_0_stat_rx_status  ,
    output                      tx0_axis_tready     ,
    input                       tx0_axis_tvalid     ,
    input  [63 :0]              tx0_axis_tdata      ,
    input                       tx0_axis_tlast      ,
    input  [7  :0]              tx0_axis_tkeep      ,
    input                       tx0_axis_tuser      ,
    output                      rx0_axis_tvalid     ,
    output [63 :0]              rx0_axis_tdata      ,
    output                      rx0_axis_tlast      ,
    output [7  :0]              rx0_axis_tkeep      ,
    output                      rx0_axis_tuser      ,

    output                      o_1_tx_clk_out      ,
    output                      o_1_rx_clk_out      ,
    output                      o_1_user_tx_reset   ,
    output                      o_1_user_rx_reset   ,
    output                      o_1_stat_rx_status  ,
    output                      tx1_axis_tready     ,
    input                       tx1_axis_tvalid     ,
    input  [63 :0]              tx1_axis_tdata      ,
    input                       tx1_axis_tlast      ,
    input  [7  :0]              tx1_axis_tkeep      ,
    input                       tx1_axis_tuser      ,
    output                      rx1_axis_tvalid     ,
    output [63 :0]              rx1_axis_tdata      ,
    output                      rx1_axis_tlast      ,
    output [7  :0]              rx1_axis_tkeep      ,
    output                      rx1_axis_tuser         
);

assign o_sfp_dis = 2'b00;

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

uplus_ten_gig_module#(
    .P_CHANNEL_NUM          (P_CHANNEL_NUM      ),
    .P_MIN_LENGTH           (P_MIN_LENGTH       ),
    .P_MAX_LENGTH           (P_MAX_LENGTH       )
)uplus_ten_gig_module_u0(
    .i_gt_refclk_p          (i_gt_refclk_p      ),
    .i_gt_refclk_n          (i_gt_refclk_n      ),
    .i_dclk                 (w_dclk             ),
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
    .rx1_axis_tuser         (rx1_axis_tuser     ) 
);
endmodule
